

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />


<cfset myrec = reactor.createRecord("Product") />
<cfset myrec.setProductId(2) />
<cfset myrec.load() />

<cfdump var="#myrec.getInvoiceArray()#" />


<!--- 


<cfset myRec = reactor.createRecord("Product") />
<cfset myRec.setProductId(1) />

<cfset query = myRec.getInvoiceProductQuery() />
<cfset invoiceIdList = ValueList(query.invoiceId) />

<cfset ivGw = reactor.createGateway("Invoice") />
<cfset query = ivGw.createQuery() />
<cfset query.getWhere().isIn("Invoice", "InvoiceId", invoiceIdList) />

<cfdump var="#ivGw.getByQuery(query)#" />

--->


