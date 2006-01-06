
<cfcomponent hint="I am the custom Record object for the  table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="ScratchData.Record.mssql.base.CustomerRecord" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		<cfset super.validate(arguments.ValidationErrorCollection) />
		
		<!--- Add custom validation logic here, it will not be overwritten --->
		
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	<cffunction name="getTotalSpent" access="public" output="false" returntype="numeric">
		<cfset var Query = createInvoiceQuery() />
		<cfset var products = 0 />
		
		<!---
			By virtue of creating this query, we're now querying the invoice table.
			When we pass this query to the getInvoiceQuery() method this will be 
			filtered  to only return rows which match this customer's id 
		--->
		
		<!--- let's join the invoice table to the invoiceproduct and product tables --->
		<cfset Query.join("Invoice", "InvoiceProduct").join("InvoiceProduct", "Product") />
		
		<!--- let's only return the price field --->
		<cfset Query.returnField("Product", "price") />
		
		<!--- let's run the query --->
		<cfset products = getInvoiceQuery(Query) />
		
		<!--- now let's get a value list and add up the results --->
		<cfreturn ArraySum(ListToArray(ValueList(products.price))) />
	</cffunction>
	
	<!---<cffunction name="getTotalSpent" access="public" output="false" returntype="numeric">
		<cfset var total = 0 />
		
		<cfquery name="total" datasource="#_getConfig().getDsn()#">
			SELECT sum(p.price) as totalSpent
			FROM Customer as c JOIN Invoice as i
				ON c.customerId = i.invoiceID
			JOIN InvoiceProduct as ip
				ON i.invoiceId = ip.invoiceId
			JOIN Product as p
				ON ip.productId = p.productId
			WHERE c.customerId = #getCustomerId()#
		</cfquery>
		
		<cfreturn Iif(IsNumeric(total.totalSpent), DE(total.totalSpent), DE(0)) />
	</cffunction>--->
	
</cfcomponent>
	
