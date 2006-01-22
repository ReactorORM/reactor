

<!---<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />


<cfset AuctionGateway = reactor.createGateway("Auction")>



<cfdump var="#AuctionGateway.getTestQuery()#" />--->

<cfset test = CreateObject("Component", "ReactorBlogData.Gateway.CategoryGatewayMssql") />