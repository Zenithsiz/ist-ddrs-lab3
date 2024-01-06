require(lpSolve)

# Links:
idx_x_12 <- 1
idx_x_13 <- 2
idx_x_23 <- 3
idx_x_24 <- 4
idx_x_34 <- 5

# Capacity multiple
c_total <- 10
c_mul <- 2

# Objective: `Σ_i c_i * x_i`
cost_12 <- 1
cost_13 <- 5
cost_23 <- 1
cost_24 <- 5
cost_34 <- 1
objective <- replicate(5, 0)
objective[c(idx_x_12, idx_x_13, idx_x_23, idx_x_24, idx_x_34)] <- c(cost_12, cost_13, cost_23, cost_24, cost_34)

# Equations:
# (Node 1): x_12 + x_13 = 1
# (Node 2): x_12 - x_24 - x_23 = 0
# (Node 3): x_13 + x_23 - x_34 = 0
# (Node 4): -x_24 - x_34 = -1
mat <- matrix(
  0,
  nrow = 5,
  ncol = 5,
  byrow = TRUE
)
dir <- replicate(5, "==")
rhs <- replicate(5, 0)

mat[1, c(idx_x_12, idx_x_13)] <- c(1, 1)
dir[1] <- "=="
rhs[1] <- 1

mat[2, c(idx_x_12, idx_x_24, idx_x_23)] <- c(1, -1, -1)
dir[2] <- "=="
rhs[2] <- 0

mat[3, c(idx_x_13, idx_x_23, idx_x_34)] <- c(1, 1, -1)
dir[3] <- "=="
rhs[3] <- 0

mat[4, c(idx_x_24, idx_x_34)] <- c(-1, -1)
dir[4] <- "=="
rhs[4] <- -1

bin <- c(idx_x_12, idx_x_13, idx_x_23, idx_x_24, idx_x_34)

optimum <- lp(
  direction = "min",
  objective.in = objective,
  const.mat = mat,
  const.dir = dir,
  const.rhs = rhs,
  binary.vec = bin,
)

print(optimum$solution)
print(optimum$objval)
