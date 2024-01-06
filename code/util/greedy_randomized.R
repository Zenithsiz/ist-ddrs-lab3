GreedyRandomized <- function(nodes, traffic, link_lengths, μ) {
  # Find all flows and shuffle them
  nodes_len <- nrow(nodes)
  flows <- lapply(1:nodes_len, \(i) lapply((1:nodes_len)[-i], \(j) list(src = i, dst = j)))
  flows <- unlist(flows, recursive = FALSE)
  flows <- sample(flows, length(flows))

  # Calculates the transmission link delays
  # Note: If no edge exists between two nodes, we set their transmission link delay to `Inf`.
  λ <- matrix(0, nrow = nodes_len, ncol = nodes_len)
  trans_delays <- link_lengths * 1e3 / 3e8
  trans_delays[!nodes] <- Inf

  # Calculate the shortest path between all flows
  flow_routes <- lapply(flows, function(flow) {
    # Calculate the current link delays from the transmission link delays and the in-system delays
    sys_delays <- 1 / (μ - λ)
    link_delays <- sys_delays + trans_delays

    # And find the best route for this flow considering the link delays
    # Note: `routes` contains the cost at the end, so we remove it.
    routes <- ShortestPath(link_delays, flow$src, flow$dst)
    routes <- routes[-length(routes)]

    # Then update the rates
    for (idx in 2:length(routes)) {
      node_src <- routes[[idx - 1]]
      node_dst <- routes[[idx]]
      λ[node_src, node_dst] <<- λ[node_src, node_dst] + traffic[node_src, node_dst] * 1e6 / 8e3
    }

    # And return the route
    routes
  })

  # If we broke our invariant, retry
  if (any(λ >= μ)) {
    cat("GreedyRandomized: Invariant broken, trying another solution\n")
    return(GreedyRandomized(nodes, traffic, link_lengths, μ))
  }

  flow_routes
}
