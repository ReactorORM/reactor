
<cfcomponent hint="I am the base Gateway object for the InvoiceProduct table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "CAF9ECE5C44292D7A17CAC3CD9E18371" />

	<cffunction name="getAll" access="public" hint="I return all rows from the InvoiceProduct table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the InvoiceProduct table." output="false" returntype="query">
		
			<cfargument name="InvoiceProductId" hint="If provided, I match the provided value to the InvoiceProductId field in the InvoiceProduct table." required="no" type="string" />
		
			<cfargument name="InvoiceId" hint="If provided, I match the provided value to the InvoiceId field in the InvoiceProduct table." required="no" type="string" />
		
			<cfargument name="ProductId" hint="If provided, I match the provided value to the ProductId field in the InvoiceProduct table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.InvoiceProductId')>
				<cfset Where.isEqual(
					
							"InvoiceProduct"
						
				, "InvoiceProductId", arguments.InvoiceProductId) />
			</cfif>
		
			<cfif IsDefined('arguments.InvoiceId')>
				<cfset Where.isEqual(
					
							"InvoiceProduct"
						
				, "InvoiceId", arguments.InvoiceId) />
			</cfif>
		
			<cfif IsDefined('arguments.ProductId')>
				<cfset Where.isEqual(
					
							"InvoiceProduct"
						
				, "ProductId", arguments.ProductId) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
