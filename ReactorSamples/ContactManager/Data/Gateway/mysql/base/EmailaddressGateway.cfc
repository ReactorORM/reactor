
<cfcomponent hint="I am the base Gateway object for the EmailAddress table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "1A9130F428562C287E99358B18E59149" />

	<cffunction name="getAll" access="public" hint="I return all rows from the EmailAddress table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the EmailAddress table." output="false" returntype="query">
		
			<cfargument name="EmailAddressId" hint="If provided, I match the provided value to the EmailAddressId field in the EmailAddress table." required="no" type="string" />
		
			<cfargument name="ContactId" hint="If provided, I match the provided value to the ContactId field in the EmailAddress table." required="no" type="string" />
		
			<cfargument name="EmailAddress" hint="If provided, I match the provided value to the EmailAddress field in the EmailAddress table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.EmailAddressId')>
				<cfset Where.isEqual(
					
							"EmailAddress"
						
				, "EmailAddressId", arguments.EmailAddressId) />
			</cfif>
		
			<cfif IsDefined('arguments.ContactId')>
				<cfset Where.isEqual(
					
							"EmailAddress"
						
				, "ContactId", arguments.ContactId) />
			</cfif>
		
			<cfif IsDefined('arguments.EmailAddress')>
				<cfset Where.isEqual(
					
							"EmailAddress"
						
				, "EmailAddress", arguments.EmailAddress) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
