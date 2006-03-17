<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />
<cfset reactor.init("/config/reactor.xml") />


<cfset TestGateway = reactor.createGateway("Test") />



<cfdump var="#TestGateway.getTest()#" /><cfabort>