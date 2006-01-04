
<!--- create the reactorFactory --->
<cfset Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("reactor.xml")) />

<!--- create a userGateway --->
<cfset UserGateway = reactor.createGateway("User") />

<!--- get all records --->
<cfset qUsers = UserGateway.getAll() />

<!--- dump the results --->
<cfdump var="#qUsers#" />