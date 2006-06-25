<cfset reactorFactory = CreateObject("Component", "reactor.reactorFactory") />
<cfset reactorFactory.init("/config/reactor.xml") />

<cfset record = reactorFactory.createRecord("test") />
<cfdump var="#record#" /><cfabort>