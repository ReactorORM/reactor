
<cfcomponent hint="I am the base Gateway object for the State table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "AF094764175E758685A2CA687B7FD93D" />

	<cffunction name="getAll" access="public" hint="I return all rows from the State table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the State table." output="false" returntype="query">
		
			<cfargument name="StateId" hint="If provided, I match the provided value to the StateId field in the State table." required="no" type="string" />
		
			<cfargument name="Abbreviation" hint="If provided, I match the provided value to the Abbreviation field in the State table." required="no" type="string" />
		
			<cfargument name="Name" hint="If provided, I match the provided value to the Name field in the State table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.StateId')>
				<cfset Where.isEqual(
					
							"State"
						
				, "StateId", arguments.StateId) />
			</cfif>
		
			<cfif IsDefined('arguments.Abbreviation')>
				<cfset Where.isEqual(
					
							"State"
						
				, "Abbreviation", arguments.Abbreviation) />
			</cfif>
		
			<cfif IsDefined('arguments.Name')>
				<cfset Where.isEqual(
					
							"State"
						
				, "Name", arguments.Name) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
