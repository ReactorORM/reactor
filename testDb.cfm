<cfset config = CreateObject("Component", "reactor.bean.config").init("scratch", "mssql", "/reactorData", "always") />
<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(config) />

<cfset InvoiceGateway = reactor.createGateway("Invoice") />

<cfdump var="#InvoiceGateway.getAll()#" />

