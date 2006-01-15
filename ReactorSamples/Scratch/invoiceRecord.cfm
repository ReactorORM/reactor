
<!--- create the reactorFactory --->
<cfset Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("reactor.xml")) />

<!--- create an invoice record --->
<cfset InvoiceRecord = Reactor.createRecord("Invoice") />
<cfset InvoiceRecord.setInvoiceId(1) />
<cfset InvoiceRecord.load() />

<!--- output all the products on this invoice --->

<!--- get all of the Products on the Invoice --->
<cfset ProductQuery = InvoiceRecord.getProductQuery() />

<!--- dump the products --->
<cfdump var="#ProductQuery#" />
