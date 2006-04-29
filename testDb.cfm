<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />
<cfset reactor.init("/config/reactor.xml") />
	
	
<cfset Doug = reactor.createRecord("user").load(userId=14) />

<cfdump var="#Doug.getForwardUserIterator().getQuery()#" />