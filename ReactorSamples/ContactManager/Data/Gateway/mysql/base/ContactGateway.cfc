
<cfcomponent hint="I am the base Gateway object for the Contact table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "97CFF00E66557D10E2BF718AFD8FBFA1" />

	<cffunction name="getAll" access="public" hint="I return all rows from the Contact table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the Contact table." output="false" returntype="query">
		
			<cfargument name="ContactId" hint="If provided, I match the provided value to the ContactId field in the Contact table." required="no" type="string" />
		
			<cfargument name="FirstName" hint="If provided, I match the provided value to the FirstName field in the Contact table." required="no" type="string" />
		
			<cfargument name="LastName" hint="If provided, I match the provided value to the LastName field in the Contact table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.ContactId')>
				<cfset Where.isEqual(
					
							"Contact"
						
				, "ContactId", arguments.ContactId) />
			</cfif>
		
			<cfif IsDefined('arguments.FirstName')>
				<cfset Where.isEqual(
					
							"Contact"
						
				, "FirstName", arguments.FirstName) />
			</cfif>
		
			<cfif IsDefined('arguments.LastName')>
				<cfset Where.isEqual(
					
							"Contact"
						
				, "LastName", arguments.LastName) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
