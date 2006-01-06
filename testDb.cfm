

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />

<cfset CustomerRecord = reactor.createRecord("Customer") />

<cfdump var="#CustomerRecord#" />