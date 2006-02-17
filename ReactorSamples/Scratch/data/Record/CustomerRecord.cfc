
<cfcomponent hint="I am the database agnostic custom Record object for the Customer table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.Scratch.Record.CustomerRecord" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		<cfset super.validate(arguments.ValidationErrorCollection) />
		
		<!--- Add custom validation logic here, it will not be overwritten --->
		
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	<cffunction name="getTotalSpent" access="public" output="false" returntype="numeric">
		<cfset var InvoiceGateway = _getReactorFactory().createGateway("Invoice") />
		<cfset var Query = InvoiceGateway.createQuery() />
		<cfset var products = 0 />
		
		<!--- let's filter this to only this customer's invoices --->
		<cfset Query.getWhere().isEqual("Invoice", "customerId", getCustomerId()) />
		
		<!--- let's join the invoice table to the invoiceproduct and product tables --->
		<cfset Query.join("Invoice", "InvoiceProduct").join("InvoiceProduct", "Product") />
			
		<!--- let's only return the price field --->
		<cfset Query.returnField("Product", "price") />
			
		<!--- let's run the query --->
		<cfset products = InvoiceGateway.getByQuery(Query) />
			
		<!--- now let's get a value list and add up the results --->
		<cfreturn ArraySum(ListToArray(ValueList(products.price))) />
	</cffunction>

	
</cfcomponent>
	
