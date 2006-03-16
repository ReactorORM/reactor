<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />
<cfset reactor.init("/config/reactor.xml") />


<cfset UserRecord = reactor.createRecord("User") />
