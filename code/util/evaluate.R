Evaluate <- function(Routes, Tr, R, Mu) {
  # Determines average delay and maximum link load of routing solution
  numNodes <- nrow(R) # Total number of nodes
  TotalRate <- sum(Tr) * 1e6 / 8e3 # Total traffic rate in packets/second
  Rates <- matrix(rep(0, len = numNodes^2), nrow = numNodes) # Initializes matrix that stores the rate of each link
  for (i in seq_along(Routes)) { # Iterates over the routes
    thisRoute <- Routes[[i]] # Reads route
    thisOrigin <- thisRoute[1] # Reads origin of route
    thisDestination <- thisRoute[length(thisRoute)] # Reads destination of route
    lenRoute <- length(thisRoute) # Determines length of route
    ODRate <- Tr[thisOrigin, thisDestination] * 1e6 / 8e3 # Reads rate of OD pair
    for (k in 1:(lenRoute - 1)) { # Installs rate of flow in each of its links
      o <- thisRoute[k] # Origin of link
      d <- thisRoute[k + 1] # Destination of link
      Rates[o, d] <- Rates[o, d] + ODRate # Increments rate of link from m to n
    }
  }
  LinkLoads <- Rates / Mu # Link loads
  MaxLoad <- max(LinkLoads) # Maximum of link loads
  LinkDelays <- R * (1 / (Mu - Rates) + L * 1e3 / 3e8) # Link average delays
  LinkPackets <- Rates * LinkDelays # Link average number of packets
  AverageDelay <- sum(LinkPackets) / TotalRate # Average packet delay
  return(c(AverageDelay, MaxLoad))
}
