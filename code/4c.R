source("code/util/network_4_5.R")
source("code/util/shortest_path.R")
source("code/util/greedy_randomized.R")
source("code/util/build_neighbour.R")
source("code/util/evaluate.R")

numIterations <- 10

numNodes <- nrow(R) # Total number of nodes
numODPairs <- numNodes^2 - numNodes # Total number of OD Pairs
numRoutes <- numODPairs # Total number of routes

prev_best_rates <- matrix(
  c(
    c(0, 15000, 0, 0, 15000, 0, 0, 0, 0, 0, 3000, 0, 0, 0, 0, 0, 0),
    c(6750, 0, 82000, 0, 42000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    c(0, 80000, 0, 18000, 0, 106500, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    c(0, 0, 11000, 0, 24500, 54750, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    c(21000, 44000, 0, 21000, 0, 0, 68000, 0, 0, 0, 44000, 0, 0, 0, 0, 0, 0),
    c(0, 0, 105000, 30750, 0, 0, 27000, 0, 89250, 0, 0, 108625, 0, 0, 0, 0, 0),
    c(0, 0, 0, 0, 60000, 19500, 0, 61250, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    c(0, 0, 0, 0, 0, 0, 43750, 0, 42250, 0, 15750, 0, 41250, 0, 0, 0, 0),
    c(0, 0, 0, 0, 0, 96250, 0, 52000, 0, 45500, 0, 0, 0, 0, 0, 0, 0),
    c(0, 0, 0, 0, 0, 0, 0, 0, 48750, 0, 0, 29750, 0, 0, 19250, 0, 0),
    c(2750, 0, 0, 0, 48000, 0, 0, 15000, 0, 0, 0, 0, 0, 57750, 0, 0, 0),
    c(0, 0, 0, 0, 0, 81125, 0, 0, 0, 27625, 0, 0, 0, 0, 0, 34000, 0),
    c(0, 0, 0, 0, 0, 0, 0, 46000, 0, 0, 0, 0, 0, 83875, 43125, 0, 0),
    c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 78750, 0, 75000, 0, 0, 0, 0),
    c(0, 0, 0, 0, 0, 0, 0, 0, 0, 19250, 0, 0, 43125, 0, 0, 0, 24500),
    c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74000, 0, 0, 0, 0, 12000),
    c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24500, 15000, 0)
  ),
  nrow = 17,
  ncol = 17,
)

extra_capacity <- 0.97434 * prev_best_rates / max(prev_best_rates)

Mu <- (1 + extra_capacity) * 1e9 / 8e3

GlobalBest <- Inf
for (iter in 1:numIterations) {
  CurrentSolution <- GreedyRandomized(R, Tr, L, Mu)
  CurrentObjective <- Evaluate(CurrentSolution, Tr, R, Mu)

  cat("Current objective:\n")
  cat(sprintf("  Link load = %f", CurrentObjective[[2]]), "\n")
  cat(sprintf("  Average packet delay = %f", CurrentObjective[[1]]), "\n")


  CurrentAvgDelay <- CurrentObjective[1]
  if (CurrentObjective[2] > 1) {
    cat(sprintf("Maximum link load > 1 at start of iteration %d", iter), "\n")
    next
  }
  rep <- TRUE
  while (rep == TRUE) {
    NeighbourBest <- Inf
    for (i in 1:numRoutes) { # Iterates over neighbor solutions
      NeighbourSolution <- BuildNeighbour(CurrentSolution, i, R, Tr, L, Mu)
      NeighbourObjective <- Evaluate(NeighbourSolution, Tr, R, Mu)
      NeighbourAvgDelay <- NeighbourObjective[1]
      if (NeighbourObjective[2] > 1) {
        cat(sprintf("Maximum link load > 1 at iteration %d and route %d", iter, i), "\n")
        next
      }
      if (NeighbourAvgDelay < NeighbourBest) {
        NeighbourBest <- NeighbourAvgDelay
        NeighbourBestSolution <- NeighbourSolution
      }
    }
    if (NeighbourBest < CurrentAvgDelay) {
      CurrentAvgDelay <- NeighbourBest
      CurrentSolution <- NeighbourBestSolution
    } else {
      rep <- FALSE
    }
  }
  if (CurrentAvgDelay < GlobalBest) {
    GlobalBestSolution <- CurrentSolution
    GlobalBest <- CurrentAvgDelay
  }
}

GlobalBestAll <- Evaluate(GlobalBestSolution, Tr, R, Mu)

cat(sprintf("Maximum link load = %f\n", GlobalBestAll[2]))
cat(sprintf("Average packet delay = %f\n", GlobalBestAll[1]))
