GreedyRandomized <- function(nodes, traffic, link_lengths, mus) {
  # Find all flows and shuffle them
  nodes_len <- nrow(nodes)
  flows <- lapply(1:nodes_len, \(i) lapply((1:nodes_len)[-i], \(j) list(src = i, dst = j)))
  flows <- unlist(flows, recursive = FALSE)
  flows <- sample(flows, length(flows))

  # Calculates the link delays
  rates <- matrix(0, nrow = nodes_len, ncol = nodes_len)
  calc_link_delays <- function() {
    # Calculate the in-system delays
    sys_delays <- 1 / (mus - rates)
    sys_delays[sys_delays <= 0] <- Inf
    sys_delays[is.nan(sys_delays)] <- Inf

    # Then add the propagation delay (converted to seconds)
    link_delays <- nodes * (sys_delays + link_lengths * 1e3 / 3e8)
    link_delays[is.nan(link_delays)] <- Inf

    link_delays
  }

  # Calculate the shortest path between all pairs
  lapply(flows, function(flow) {
    # Calculate the current link delays and find the best route for this flow
    # Note: `routes` contains the cost at the end, so we remove it.
    link_delays <- calc_link_delays()
    routes <- ShortestPath(link_delays, flow$src, flow$dst)
    routes <- routes[-length(routes)]

    # Then update the rates
    for (idx in 2:length(routes)) {
      node_src <- routes[[idx - 1]]
      node_dst <- routes[[idx]]
      rates[node_src, node_dst] <<- rates[node_src, node_dst] + traffic[node_src, node_dst] * 1e6 / 8e3
    }

    # And return the route
    routes
  })
}
