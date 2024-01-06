BuildNeighbour <- function(Routes, i, R, Tr, L, Mu) {
  # Builds a neighbor solution by removing route i, updating the link rates and
  # link delays, and determining the shortest path of the removed flow
  numNodes <- nrow(R) # Total number of nodes
  numODPairs <- numNodes^2 - numNodes # Total number of OD Pairs
  numRoutes <- numODPairs # Total number of routes
  RemovedRoute <- Routes[[i]] # Removed route
  OriginRemovedRoute <- RemovedRoute[1] # Origin of removed route
  DestinationRemovedRoute <- RemovedRoute[length(RemovedRoute)] # Destination of removed route
  ReducedRoutes <- Routes
  ReducedRoutes[[i]] <- NULL # List of routes without removed route
  Rates <- matrix(rep(0, len = numNodes^2), nrow = numNodes) # Initializes matrix that stores the link rates
  for (j in 1:(numRoutes - 1)) { #
    thisRoute <- ReducedRoutes[[j]]
    lenRoute <- length(thisRoute)
    OriginRoute <- thisRoute[1]
    DestinationRoute <- thisRoute[lenRoute]
    ODRate <- Tr[OriginRoute, DestinationRoute] * 1e6 / 8e3
    for (k in 1:(lenRoute - 1)) { # Installs traffic rate of best flow in each of its links
      o <- thisRoute[k] # Origin of link
      d <- thisRoute[k + 1] # Destination of link
      Rates[o, d] <- Rates[o, d] + ODRate # Increments traffic rate of link from o to d
    }
  }
  DelSys <- 1 / (Mu - Rates)
  DelSys[DelSys < 0] <- Inf
  LinkDelays <- DelSys + L * 1e3 / 3e8 # Link average delays
  LinkDelays[R == 0] <- Inf # Link average delay is infinity if there is no link
  NewRouteCost <- ShortestPath(LinkDelays, OriginRemovedRoute, DestinationRemovedRoute)
  NewRoute <- NewRouteCost[-(length(NewRouteCost))]
  Routes[[i]] <- NewRoute
  return(Routes)
}
