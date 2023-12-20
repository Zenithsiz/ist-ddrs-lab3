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

# Links:
idx_y_12 <- 9
idx_y_13 <- 10
idx_y_23 <- 11
idx_y_24 <- 12
idx_y_34 <- 13

# Flows:
b_14 <- 4.5
b_24 <- 2.5
b_23 <- 4.5
b_13 <- 1.5

# Capacity multiple
c_total <- 10
c_mul <- 2

# Objective: `Σ_i price * y_i`
price <- 1000
objective <- replicate(14, 0)
objective[c(idx_y_12, idx_y_13, idx_y_23, idx_y_24, idx_y_34)] <- price

# Equations:
# (Link 1 -> 2): b_14 * x_124  + b_14 * x_1234 + b_13 * x_123              - c_mul * y_12 <= 0
# (Link 1 -> 3): b_14 * x_134  + b_13 * x_13                               - c_mul * y_13 <= 0
# (Link 2 -> 3): b_14 * x_1234 + b_23 * x_234 + b_23 * x_23 + b_13 * x_123 - c_mul * y_23 <= 0
# (Link 2 -> 4): b_14 * x_124  + b_24 * x_24                               - c_mul * y_24 <= 0
# (Link 3 -> 4): b_14 * x_1234 + b_14 * x_134 + b_23 * x_234               - c_mul * y_34 <= 0
# (Link 1 -> 2): c_mul * y_12 <= c_total
# (Link 1 -> 3): c_mul * y_13 <= c_total
# (Link 2 -> 3): c_mul * y_23 <= c_total
# (Link 2 -> 4): c_mul * y_24 <= c_total
# (Link 3 -> 4): c_mul * y_34 <= c_total
# (Flow 1): x_124 + x_1234 + x_134 = 1
# (Flow 2): x_24 + x_234 = 1
# (Flow 3): x_23 = 1
# (Flow 4): x_13 + x_123 = 1
mat <- matrix(
  0,
  nrow = 14,
  ncol = 14,
  byrow = TRUE
)
dir <- replicate(14, "")
rhs <- replicate(14, 0)

mat[1, c(idx_x_124, idx_x_1234, idx_x_123, idx_y_12)] <- c(b_14, b_14, b_13, -c_mul)
dir[1] <- "<="
rhs[1] <- 0

mat[2, c(idx_x_134, idx_x_13, idx_y_13)] <- c(b_14, b_13, -c_mul)
dir[2] <- "<="
rhs[2] <- 0

mat[3, c(idx_x_1234, idx_x_234, idx_x_23, idx_x_123, idx_y_23)] <- c(b_14, b_24, b_23, b_13, -c_mul)
dir[3] <- "<="
rhs[3] <- 0

mat[4, c(idx_x_124, idx_x_24, idx_y_24)] <- c(b_14, b_24, -c_mul)
dir[4] <- "<="
rhs[4] <- 0

mat[5, c(idx_x_1234, idx_x_134, idx_x_234, idx_y_34)] <- c(b_14, b_14, b_24, -c_mul)
dir[5] <- "<="
rhs[5] <- 0

mat[6, c(idx_y_12)] <- c(c_mul)
dir[6] <- "<="
rhs[6] <- c_total

mat[7, c(idx_y_13)] <- c(c_mul)
dir[7] <- "<="
rhs[7] <- c_total

mat[8, c(idx_y_23)] <- c(c_mul)
dir[8] <- "<="
rhs[8] <- c_total

mat[9, c(idx_y_24)] <- c(c_mul)
dir[9] <- "<="
rhs[9] <- c_total

mat[10, c(idx_y_34)] <- c(c_mul)
dir[10] <- "<="
rhs[10] <- c_total

mat[11, c(idx_x_124, idx_x_1234, idx_x_134)] <- c(1, 1, 1)
dir[11] <- "=="
rhs[11] <- 1

mat[12, c(idx_x_24, idx_x_234)] <- c(1, 1)
dir[12] <- "=="
rhs[12] <- 1

mat[13, c(idx_x_23)] <- c(1)
dir[13] <- "=="
rhs[13] <- 1

mat[14, c(idx_x_13, idx_x_123)] <- c(1, 1)
dir[14] <- "=="
rhs[14] <- 1

int <- c(idx_y_12, idx_y_13, idx_y_23, idx_y_24, idx_y_34)

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
  binary.vec = bin,
  int.vec = int
))
optimum_a <- optimums[[1]]
optimum_b <- optimums[[2]]

cat("Solution a:\n")
print(optimum_a$solution)
print(optimum_a$objval)

cat("Solution b:\n")
print(optimum_b$solution)
print(optimum_b$objval)
