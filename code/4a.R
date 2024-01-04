source("code/util/network_4_5.R")
source("code/util/shortest_path.R")

numNodes=nrow(R) #Total number of nodes
numLinks=sum(R) #Total number of links

Mu=1e9/8e3 #Service rate in packets/second

TotalRate=sum(Tr)*1e6/8e3 #Total traffic rate in packets/second

#Prepares Costs matrix for ShortestPath function
Costs=L;Costs[R==0]=Inf #Cost is infinity if there is no link

Routes=list() #Initialize list that stores the shortest paths between each pair of nodes
Rates=matrix(rep(0,len=numNodes^2),nrow=numNodes) #Initialize matrix that stores the total traffic rates of each link

#Loads each link with its total traffic rate; placed in Rates matrix
numRoute=1
for (i in 1:numNodes) {
  for (j in 1:numNodes) {
    if (i!=j) {
      thisRouteCost=ShortestPath(Costs,i,j) #Determines shortest path from i to j (and its cost)
      thisRoute=thisRouteCost[-length(thisRouteCost)] #Extracts path from thisRouteCost vector
      Routes[[numRoute]]=thisRoute #Stores shortest path in Routes list
      lenRoute=length(thisRoute) #Determines length of route
      for (k in 1:lenRoute-1) { #Updates link rates
        o=thisRoute[k] #Origin of link
        d=thisRoute[k+1] #Destination of link
        Rates[o,d]=Rates[o,d]+Tr[i,j]*1e6/8e3 #Increments traffic rate of link from o to d
      }
      numRoute=numRoute+1
    }
  }
}

#Calculates maximum link load and average packet delay, using the Rates matrix
LinkLoads=Rates/Mu #Link loads
MaxLoad=max(LinkLoads) #Maximum of link loads
AverageLoad=sum(LinkLoads)/numLinks #Average of link loads
LinkDelays=R*(1/(Mu-Rates)+L*1e3/3e8) #Link average delays
LinkPackets=Rates*LinkDelays #Link average number of packets
AverageDelay=sum(LinkPackets)/TotalRate #Average packet delay

#Prints the results
cat(sprintf("Maximum link load in scenario A = %f",MaxLoad),"\n")
cat(sprintf("Average packet delay in scenario A = %f",AverageDelay),"\n")
