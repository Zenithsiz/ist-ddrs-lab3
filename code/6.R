library(ggplot2)

blocking_prob <- function(ρ, n) {
  i <- 0:n
  ρ^n / (factorial(n) * sum(ρ^i / factorial(i)))
}

λ <- 2
𝜇 <- 1 / 5
ρ <- λ / 𝜇

# Cents / minute
c <- 5

# Cents / minute
lease <- 100 * 10000 / (365 * 24 * 60)

print(blocking_prob(ρ, 20))

# Returns the net revenue
net_revenue <- function(circuits) {
  c * ρ * (1 - blocking_prob(ρ, circuits)) - circuits * lease
}

x <- seq(0, 20)
y <- sapply(x, net_revenue)

max_idx <- which.max(y)
max_x <- x[[max_idx]]
max_y <- y[[max_idx]]

cat(sprintf("Max @ %d: %.2f c / min\n", max_x, max_y))
# TODO: Euros / year

data <- data.frame(x = x, y = y)
plot <- ggplot(data) +
  geom_line(aes(.data$x, .data$y)) +
  geom_point(aes(.data$x, .data$y)) +
  scale_x_continuous(breaks = seq(min(x), max(x), 1)) +
  scale_y_continuous(breaks = seq(min(y), max(y), 1)) +
  xlab("Circuits") +
  ylab("Long-run net revenue (c / min)")

ggsave(plot, file = "output/6.svg", device = "svg")
