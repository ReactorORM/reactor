
<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />

<cfset reactor.init("/config/reactor.xml") />

<cfset EntryGateway = reactor.createGateway("Entry") />

<cfset query = EntryGateway.createQuery() />
<cfset where = query.getWhere() />
<cfset where.setMode("or").addWhere(where.createWhere().isLte("Entry", "entryId", 2).setMode("or").isGte("Entry", "entryId", 174)).isLte("Entry", "views", 700) />

<cfdump var="#EntryGateway.getByQuery(query)#" /><cfabort>
