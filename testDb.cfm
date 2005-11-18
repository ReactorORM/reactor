

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />


<cfset admin = reactor.createRecord("Administrator") />
<cfset admin.setAdministratorId(1) />
<cfset admin.load() />

<cfset bean = reactor.createBean("Administrator") />
<cfset bean.populate(admin) />

<cfset bean.setFirstName("AlmostDone") />

<cfset admin.populate(bean) />


<cfdump var="#admin._getTo()#" />


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


