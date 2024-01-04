source("code/util/network_4_5.R")
source("code/util/shortest_path.R")
require(lpSolve)

numServers <- 1
numNodes <- nrow(L)


Costs <- L
Costs[L == 0] <- Inf

# Delays are deltas
Delays <- matrix(rep(0, len = numNodes^2), nrow = numNodes)
for (i in 1:numNodes) {
  for (j in 1:numNodes) {
    if (i != j) {
      rrr <- ShortestPath(Costs, i, j)
      Delays[i, j] <- rrr[length(rrr)]
    }
  }
}

z_start_idx <- 0
z_idx <- function(idx) {
  stopifnot(idx >= 1 && idx <= numNodes)
  z_start_idx + idx
}

g_start_idx <- numNodes
g_idx <- function(i, j) {
  stopifnot(i >= 1 && i <= numNodes)
  stopifnot(j >= 1 && j <= numNodes)
  g_start_idx + numNodes * (j - 1) + i
}

numConstraints <- 1 + numNodes + numNodes^2
objective <- replicate(numConstraints, 0)

objective_idxs <- sapply(1:numNodes, function(i) sapply(1:numNodes, function(j) g_idx(i, j)))
objective_values <- sapply(1:numNodes, function(i) sapply(1:numNodes, function(j) Delays[[i, j]]))
objective[objective_idxs] <- objective_values

mat <- matrix(
  0,
  nrow = numConstraints,
  ncol = numConstraints,
  byrow = TRUE
)
dir <- replicate(numConstraints, "==")
rhs <- replicate(numConstraints, 0)

# `Σ_i z_i == numServers`
mat[1, sapply(1:numNodes, z_idx)] <- replicate(numNodes, 1)
dir[1] <- "=="
rhs[1] <- numServers

# `∀i Σ_j g_i^j == 1`
for (i in 1:numNodes) {
  mat[1 + i, sapply(1:numNodes, function(j) g_idx(i, j))] <- replicate(numNodes, 1)
  dir[1 + i] <- "=="
  rhs[1 + i] <- 1
}

# `∀i,j g_i^j - z_j <= 0`
for (i in 1:numNodes) {
  for (j in 1:numNodes) {
    mat[1 + numNodes + numNodes * (j - 1) + i, g_idx(i, j)] <- 1
    mat[1 + numNodes + numNodes * (j - 1) + i, z_idx(j)] <- -1
    dir[1 + numNodes + numNodes * (j - 1) + i] <- "<="
    rhs[1 + numNodes + numNodes * (j - 1) + i] <- 0
  }
}

# Find the optimal solution
optimum <- lp(
  direction = "min",
  objective.in = objective,
  const.mat = mat,
  const.dir = dir,
  const.rhs = rhs,
  all.bin = TRUE
)

cat(sprintf("Total cost: %.2f\n", optimum$objval))

for (i in 1:numNodes) {
  cat(sprintf("z_%d: %d\n", i, optimum$solution[[z_idx(i)]]))
}

for (i in 1:numNodes) {
  for (j in 1:numNodes) {
    cat(sprintf("g_%d^%d: %d; ", i, j, optimum$solution[[g_idx(i, j)]]))
  }
  cat("\n")
}
