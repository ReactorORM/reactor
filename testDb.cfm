

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />

<cfset stateRecord = reactor.createMetadata("Address") />

<!---<cfset addressRecord = reactor.createRecord("Address") />
<cfset addressRecord.setStreet1("1261 Cambria Dr.") />
<cfset addressRecord.setCity("East Lansing") />
<cfset addressRecord.setCity("East Lansing") />
<cfset addressRecord.load() />

<cfdump var="#addressRecord.getStreet1()#" /> --->