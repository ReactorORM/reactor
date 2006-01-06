
<cfcomponent hint="I am the base Gateway object for the Invoice table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "4BB04E77F8C785BFEC9964C618CFF1F3" />

	<cffunction name="getAll" access="public" hint="I return all rows from the Invoice table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the Invoice table." output="false" returntype="query">
		
			<cfargument name="InvoiceId" hint="If provided, I match the provided value to the InvoiceId field in the Invoice table." required="no" type="string" />
		
			<cfargument name="CustomerId" hint="If provided, I match the provided value to the CustomerId field in the Invoice table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.InvoiceId')>
				<cfset Where.isEqual(
					
							"Invoice"
						
				, "InvoiceId", arguments.InvoiceId) />
			</cfif>
		
			<cfif IsDefined('arguments.CustomerId')>
				<cfset Where.isEqual(
					
							"Invoice"
						
				, "CustomerId", arguments.CustomerId) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
