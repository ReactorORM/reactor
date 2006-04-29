<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />
<cfset reactor.init("/config/reactor.xml") />
	
	
<cfset user = reactor.createIterator("user") />

<cfdump var="#user.getQuery(count=5)#" />