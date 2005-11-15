

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />

<cfset myGw = reactor.createGateway("Administrator") />

<cfdump var="#myGw.getByFields(password='test123')#" />

<cfabort> 