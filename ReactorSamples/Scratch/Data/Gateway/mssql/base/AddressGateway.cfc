
<cfcomponent hint="I am the base Gateway object for the Address table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "83C36EF059D7F69183D9588239ABED3E" />

	<cffunction name="getAll" access="public" hint="I return all rows from the Address table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the Address table." output="false" returntype="query">
		
			<cfargument name="AddressId" hint="If provided, I match the provided value to the AddressId field in the Address table." required="no" type="string" />
		
			<cfargument name="Street1" hint="If provided, I match the provided value to the Street1 field in the Address table." required="no" type="string" />
		
			<cfargument name="Street2" hint="If provided, I match the provided value to the Street2 field in the Address table." required="no" type="string" />
		
			<cfargument name="City" hint="If provided, I match the provided value to the City field in the Address table." required="no" type="string" />
		
			<cfargument name="State" hint="If provided, I match the provided value to the State field in the Address table." required="no" type="string" />
		
			<cfargument name="Zip" hint="If provided, I match the provided value to the Zip field in the Address table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.AddressId')>
				<cfset Where.isEqual(
					
							"Address"
						
				, "AddressId", arguments.AddressId) />
			</cfif>
		
			<cfif IsDefined('arguments.Street1')>
				<cfset Where.isEqual(
					
							"Address"
						
				, "Street1", arguments.Street1) />
			</cfif>
		
			<cfif IsDefined('arguments.Street2')>
				<cfset Where.isEqual(
					
							"Address"
						
				, "Street2", arguments.Street2) />
			</cfif>
		
			<cfif IsDefined('arguments.City')>
				<cfset Where.isEqual(
					
							"Address"
						
				, "City", arguments.City) />
			</cfif>
		
			<cfif IsDefined('arguments.State')>
				<cfset Where.isEqual(
					
							"Address"
						
				, "State", arguments.State) />
			</cfif>
		
			<cfif IsDefined('arguments.Zip')>
				<cfset Where.isEqual(
					
							"Address"
						
				, "Zip", arguments.Zip) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
