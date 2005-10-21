<cfset config = CreateObject("Component", "reactor.bean.config").init("scratch", "mssql", "/reactorData", "development") />
<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(config) />

<cfset InvoiceBean = reactor.createBean("Invoice") />
<cfset InvoiceBean.init(1, 1, now()) />

<cfdump var="#InvoiceBean.getCustomerId()#" />