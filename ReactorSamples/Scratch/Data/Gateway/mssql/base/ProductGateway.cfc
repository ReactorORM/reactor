
<cfcomponent hint="I am the base Gateway object for the Product table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "1F9769460092807EAA804112D726C42B" />

	<cffunction name="getAll" access="public" hint="I return all rows from the Product table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the Product table." output="false" returntype="query">
		
			<cfargument name="ProductId" hint="If provided, I match the provided value to the ProductId field in the Product table." required="no" type="string" />
		
			<cfargument name="Name" hint="If provided, I match the provided value to the Name field in the Product table." required="no" type="string" />
		
			<cfargument name="Description" hint="If provided, I match the provided value to the Description field in the Product table." required="no" type="string" />
		
			<cfargument name="Price" hint="If provided, I match the provided value to the Price field in the Product table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.ProductId')>
				<cfset Where.isEqual(
					
							"Product"
						
				, "ProductId", arguments.ProductId) />
			</cfif>
		
			<cfif IsDefined('arguments.Name')>
				<cfset Where.isEqual(
					
							"Product"
						
				, "Name", arguments.Name) />
			</cfif>
		
			<cfif IsDefined('arguments.Description')>
				<cfset Where.isEqual(
					
							"Product"
						
				, "Description", arguments.Description) />
			</cfif>
		
			<cfif IsDefined('arguments.Price')>
				<cfset Where.isEqual(
					
							"Product"
						
				, "Price", arguments.Price) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
