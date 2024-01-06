source("code/util/network_4_5.R")
source("code/util/shortest_path.R")
source("code/util/greedy_randomized.R")
source("code/util/build_neighbour.R")
source("code/util/evaluate.R")

numIterations <- 10

numNodes <- nrow(R) # Total number of nodes
numODPairs <- numNodes^2 - numNodes # Total number of OD Pairs
numRoutes <- numODPairs # Total number of routes

Mu <- 1e9 / 8e3 # Service rate in packets/second

set.seed(0)
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

cat(sprintf("Maximum link load in scenario B = %f\n", GlobalBestAll[2]))
cat(sprintf("Average packet delay in scenario B = %f\n", GlobalBestAll[1]))
cat("Best solution in scenario B:\n")
print(GlobalBestSolution)
