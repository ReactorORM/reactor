

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />

<cfset addressRecord = reactor.createRecord("Address") />
<cfset addressRecord.setAddressId(1) />
<cfset addressRecord.load() />

<cfdump var="#addressRecord.getStreet1()#" /> 