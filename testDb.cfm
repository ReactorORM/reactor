

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />

<cfset AddressRecord = reactor.createRecord("Address") />

<cfdump var="#AddressRecord#" />