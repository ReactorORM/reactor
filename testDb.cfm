<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init("vacationAuctions", "mssql", "/reactorData", "always") />

<cfset VacationAuctionGateway = reactor.createGateway("VacationAuction") />

<cfdump var="#VacationAuctionGateway#" />