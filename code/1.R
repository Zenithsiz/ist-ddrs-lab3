require(lpSolve)

# Routes:
idx_x_124 <- 1
idx_x_1234 <- 2
idx_x_134 <- 3
idx_x_24 <- 4
idx_x_234 <- 5
idx_x_23 <- 6
idx_x_13 <- 7
idx_x_123 <- 8

# Flows:
b_14 <- 4.5
b_24 <- 2.5
b_23 <- 4.5
b_13 <- 1.5

# Capacity
c_total <- 10

# Objective: `r`
idx_r <- 9
objective <- replicate(9, 0)
objective[idx_r] <- 1

# Equations:
# (Link 1 -> 2): b_14 * x_124  + b_14 * x_1234 + b_13 * x_123              - c * r <= 0
# (Link 1 -> 3): b_14 * x_134  + b_13 * x_13                               - c * r <= 0
# (Link 2 -> 3): b_14 * x_1234 + b_23 * x_234 + b_23 * x_23 + b_13 * x_123 - c * r <= 0
# (Link 2 -> 4): b_14 * x_124  + b_24 * x_24                               - c * r <= 0
# (Link 3 -> 4): b_14 * x_1234 + b_14 * x_134 + b_23 * x_234               - c * r <= 0
# (Flow 1): x_124 + x_1234 + x_134 = 1
# (Flow 2): x_24 + x_234 = 1
# (Flow 3): x_23 = 1
# (Flow 4): x_13 + x_123 = 1
mat <- matrix(
  0,
  nrow = 9,
  ncol = 9,
  byrow = TRUE
)
dir <- replicate(9, "")
rhs <- replicate(9, 0)

mat[1, c(idx_x_124, idx_x_1234, idx_x_123, idx_r)] <- c(b_14, b_14, b_13, -c_total)
dir[1] <- "<="
rhs[1] <- 0

mat[2, c(idx_x_134, idx_x_13, idx_r)] <- c(b_14, b_13, -c_total)
dir[2] <- "<="
rhs[2] <- 0

mat[3, c(idx_x_1234, idx_x_234, idx_x_23, idx_x_123, idx_r)] <- c(b_14, b_24, b_23, b_13, -c_total)
dir[3] <- "<="
rhs[3] <- 0

mat[4, c(idx_x_124, idx_x_24, idx_r)] <- c(b_14, b_24, -c_total)
dir[4] <- "<="
rhs[4] <- 0

mat[5, c(idx_x_1234, idx_x_134, idx_x_234, idx_r)] <- c(b_14, b_14, b_24, -c_total)
dir[5] <- "<="
rhs[5] <- 0

mat[6, c(idx_x_124, idx_x_1234, idx_x_134)] <- c(1, 1, 1)
dir[6] <- "=="
rhs[6] <- 1

mat[7, c(idx_x_24, idx_x_234)] <- c(1, 1)
dir[7] <- "=="
rhs[7] <- 1

mat[8, c(idx_x_23)] <- c(1)
dir[8] <- "=="
rhs[8] <- 1

mat[9, c(idx_x_13, idx_x_123)] <- c(1, 1)
dir[9] <- "=="
rhs[9] <- 1

bin_a <- c()
bin_b <- c(
  idx_x_124,
  idx_x_1234,
  idx_x_134,
  idx_x_24,
  idx_x_234,
  idx_x_23,
  idx_x_13,
  idx_x_123
)

optimums <- lapply(list(bin_a, bin_b), \(bin) lp(
  direction = "min",
  objective.in = objective,
  const.mat = mat,
  const.dir = dir,
  const.rhs = rhs,
  # Without bifurcation, x_* must be binary (0 or 1 only), using `binary.vec`
  # With bifurcation, `binary_vec` must be empty
  binary.vec = bin
))
optimum_a <- optimums[[1]]
optimum_b <- optimums[[2]]

cat("Solution a:\n")
print(optimum_a$solution)
print(optimum_a$objval)

cat("Solution b:\n")
print(optimum_b$solution)
print(optimum_b$objval)
