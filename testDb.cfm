

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />

<!---
<cfset pr = reactor.createRecord("Product") />
<cfset pr.setProductId(1) />
<cfset pr.load() />

<cfdump var="#pr#" />
--->

<cfset ip = reactor.createGateway("InvoiceProduct") />
<cfset criteria = ip.createCriteria() />
<cfset criteria.join("Invoice") />

<cfdump var="#ip.getByCriteria(criteria)#" />



