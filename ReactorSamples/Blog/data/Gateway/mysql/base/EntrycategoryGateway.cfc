
<cfcomponent hint="I am the base Gateway object for the EntryCategory table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "044DEDBE111807360D1608E501B49D78" />

	<cffunction name="getAll" access="public" hint="I return all rows from the EntryCategory table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the EntryCategory table." output="false" returntype="query">
		
			<cfargument name="EntryCategoryId" hint="If provided, I match the provided value to the EntryCategoryId field in the EntryCategory table." required="no" type="string" />
		
			<cfargument name="EntryId" hint="If provided, I match the provided value to the EntryId field in the EntryCategory table." required="no" type="string" />
		
			<cfargument name="CategoryId" hint="If provided, I match the provided value to the CategoryId field in the EntryCategory table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.EntryCategoryId')>
				<cfset Where.isEqual(
					
							"EntryCategory"
						
				, "EntryCategoryId", arguments.EntryCategoryId) />
			</cfif>
		
			<cfif IsDefined('arguments.EntryId')>
				<cfset Where.isEqual(
					
							"EntryCategory"
						
				, "EntryId", arguments.EntryId) />
			</cfif>
		
			<cfif IsDefined('arguments.CategoryId')>
				<cfset Where.isEqual(
					
							"EntryCategory"
						
				, "CategoryId", arguments.CategoryId) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
