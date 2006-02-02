

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init("/config/reactor.xml") />

<cfset rec = reactor.createRecord("test") />

<cfdump var="#rec#" />