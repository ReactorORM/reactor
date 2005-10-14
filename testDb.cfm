<cfset config = CreateObject("Component", "reactor.bean.config").init("scratch", "mssql", "/reactorData", "always") />
<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(config) />



<cfset CustomerRecord = reactor.createRecord("Customer") />
<cfset CustomerRecord.setUserId(1) />
<cfset CustomerRecord.load() />

<cfdump var="#CustomerRecord.getFirstName()#" /><cfabort>

<cfset invoices = CustomerRecord.getInvoiceQuery() />

<cfdump var="#invoices#" /><cfabort>


<cfset InvoiceProducts = invoices[1].getInvoiceProductArray() />
<cfset Product = InvoiceProducts[1].getRecordForProductId() />

<cfdump var="#Product.getProductId()#" />