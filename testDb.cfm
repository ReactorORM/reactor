<cfset config = CreateObject("Component", "reactor.bean.config").init("scratch", "mssql", "/reactorData", "always") />
<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(config) />

<cfset InvoiceBean = reactor.createBean("Invoice") />
<cfset InvoiceRecord = reactor.createRecord("Invoice") />

<!--- code before this would create and populate the invoice record --->

<cfset InvoiceBean.populate(InvoiceRecord) />
<cfset InvoiceBean.save() />