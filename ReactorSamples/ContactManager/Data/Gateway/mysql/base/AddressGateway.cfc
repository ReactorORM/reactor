
<cfcomponent hint="I am the base Gateway object for the Address table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "C8ADB2383CA28DB2D7F4372F24B56A08" />

	<cffunction name="getAll" access="public" hint="I return all rows from the Address table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the Address table." output="false" returntype="query">
		
			<cfargument name="AddressId" hint="If provided, I match the provided value to the AddressId field in the Address table." required="no" type="string" />
		
			<cfargument name="ContactId" hint="If provided, I match the provided value to the ContactId field in the Address table." required="no" type="string" />
		
			<cfargument name="Line1" hint="If provided, I match the provided value to the Line1 field in the Address table." required="no" type="string" />
		
			<cfargument name="Line2" hint="If provided, I match the provided value to the Line2 field in the Address table." required="no" type="string" />
		
			<cfargument name="City" hint="If provided, I match the provided value to the City field in the Address table." required="no" type="string" />
		
			<cfargument name="StateId" hint="If provided, I match the provided value to the StateId field in the Address table." required="no" type="string" />
		
			<cfargument name="PostalCode" hint="If provided, I match the provided value to the PostalCode field in the Address table." required="no" type="string" />
		
			<cfargument name="CountryId" hint="If provided, I match the provided value to the CountryId field in the Address table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.AddressId')>
				<cfset Where.isEqual(
					
							"Address"
						
				, "AddressId", arguments.AddressId) />
			</cfif>
		
			<cfif IsDefined('arguments.ContactId')>
				<cfset Where.isEqual(
					
							"Address"
						
				, "ContactId", arguments.ContactId) />
			</cfif>
		
			<cfif IsDefined('arguments.Line1')>
				<cfset Where.isEqual(
					
							"Address"
						
				, "Line1", arguments.Line1) />
			</cfif>
		
			<cfif IsDefined('arguments.Line2')>
				<cfset Where.isEqual(
					
							"Address"
						
				, "Line2", arguments.Line2) />
			</cfif>
		
			<cfif IsDefined('arguments.City')>
				<cfset Where.isEqual(
					
							"Address"
						
				, "City", arguments.City) />
			</cfif>
		
			<cfif IsDefined('arguments.StateId')>
				<cfset Where.isEqual(
					
							"Address"
						
				, "StateId", arguments.StateId) />
			</cfif>
		
			<cfif IsDefined('arguments.PostalCode')>
				<cfset Where.isEqual(
					
							"Address"
						
				, "PostalCode", arguments.PostalCode) />
			</cfif>
		
			<cfif IsDefined('arguments.CountryId')>
				<cfset Where.isEqual(
					
							"Address"
						
				, "CountryId", arguments.CountryId) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
