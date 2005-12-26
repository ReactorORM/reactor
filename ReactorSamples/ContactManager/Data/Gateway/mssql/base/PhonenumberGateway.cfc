
<cfcomponent hint="I am the base Gateway object for the PhoneNumber table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "D26C7E5FB8D319B6167A41C898734D3A" />

	<cffunction name="getAll" access="public" hint="I return all rows from the PhoneNumber table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the PhoneNumber table." output="false" returntype="query">
		
			<cfargument name="PhoneNumberId" hint="If provided, I match the provided value to the PhoneNumberId field in the PhoneNumber table." required="no" type="string" />
		
			<cfargument name="ContactId" hint="If provided, I match the provided value to the ContactId field in the PhoneNumber table." required="no" type="string" />
		
			<cfargument name="PhoneNumber" hint="If provided, I match the provided value to the PhoneNumber field in the PhoneNumber table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.PhoneNumberId')>
				<cfset Where.isEqual(
					
							"PhoneNumber"
						
				, "PhoneNumberId", arguments.PhoneNumberId) />
			</cfif>
		
			<cfif IsDefined('arguments.ContactId')>
				<cfset Where.isEqual(
					
							"PhoneNumber"
						
				, "ContactId", arguments.ContactId) />
			</cfif>
		
			<cfif IsDefined('arguments.PhoneNumber')>
				<cfset Where.isEqual(
					
							"PhoneNumber"
						
				, "PhoneNumber", arguments.PhoneNumber) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
