

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />

<cfset productRecord = reactor.createRecord("Product") />
<cfset productRecord.setProductId(1) />
<cfset productRecord.load() />

<cfdump var="#productRecord.getInvoiceQuery()#" /> 