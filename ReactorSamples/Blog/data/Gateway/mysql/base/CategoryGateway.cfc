
<cfcomponent hint="I am the base Gateway object for the Category table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "8FBBCE7490382D9832B8EC45EAFBB33A" />

	<cffunction name="getAll" access="public" hint="I return all rows from the Category table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the Category table." output="false" returntype="query">
		
			<cfargument name="CategoryId" hint="If provided, I match the provided value to the CategoryId field in the Category table." required="no" type="string" />
		
			<cfargument name="Name" hint="If provided, I match the provided value to the Name field in the Category table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.CategoryId')>
				<cfset Where.isEqual(
					
							"Category"
						
				, "CategoryId", arguments.CategoryId) />
			</cfif>
		
			<cfif IsDefined('arguments.Name')>
				<cfset Where.isEqual(
					
							"Category"
						
				, "Name", arguments.Name) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
