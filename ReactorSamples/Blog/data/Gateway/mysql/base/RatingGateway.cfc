
<cfcomponent hint="I am the base Gateway object for the Rating table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "9A96D996C6E0389942CFB5D6486A8ECA" />

	<cffunction name="getAll" access="public" hint="I return all rows from the Rating table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the Rating table." output="false" returntype="query">
		
			<cfargument name="RatingId" hint="If provided, I match the provided value to the RatingId field in the Rating table." required="no" type="string" />
		
			<cfargument name="EntryId" hint="If provided, I match the provided value to the EntryId field in the Rating table." required="no" type="string" />
		
			<cfargument name="Rating" hint="If provided, I match the provided value to the Rating field in the Rating table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.RatingId')>
				<cfset Where.isEqual(
					
							"Rating"
						
				, "RatingId", arguments.RatingId) />
			</cfif>
		
			<cfif IsDefined('arguments.EntryId')>
				<cfset Where.isEqual(
					
							"Rating"
						
				, "EntryId", arguments.EntryId) />
			</cfif>
		
			<cfif IsDefined('arguments.Rating')>
				<cfset Where.isEqual(
					
							"Rating"
						
				, "Rating", arguments.Rating) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
