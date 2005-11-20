

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />


<cfset admin = reactor.createRecord("Administrator") />


<cfset errors = admin.validate() />

<cfdump var="#errors.hasErrors()#" />

<cfdump var="#errors.getErrors()#" />

<cfabort>

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


