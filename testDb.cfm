

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />


<cfset AuctionGateway = reactor.createGateway("Auction")>



<cfdump var="#AuctionGateway.getTestQuery()#" />