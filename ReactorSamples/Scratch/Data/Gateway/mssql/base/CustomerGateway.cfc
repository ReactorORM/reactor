
<cfcomponent hint="I am the base Gateway object for the Customer table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "CCA4E499673B1A3F1C864B58F500D055" />

	<cffunction name="getAll" access="public" hint="I return all rows from the Customer table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the Customer table." output="false" returntype="query">
		
			<cfargument name="CustomerId" hint="If provided, I match the provided value to the CustomerId field in the Customer table." required="no" type="string" />
		
			<cfargument name="Username" hint="If provided, I match the provided value to the Username field in the Customer table." required="no" type="string" />
		
			<cfargument name="Password" hint="If provided, I match the provided value to the Password field in the Customer table." required="no" type="string" />
		
			<cfargument name="FirstName" hint="If provided, I match the provided value to the FirstName field in the Customer table." required="no" type="string" />
		
			<cfargument name="LastName" hint="If provided, I match the provided value to the LastName field in the Customer table." required="no" type="string" />
		
			<cfargument name="DateCreated" hint="If provided, I match the provided value to the DateCreated field in the Customer table." required="no" type="string" />
		
			<cfargument name="AddressId" hint="If provided, I match the provided value to the AddressId field in the Customer table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.CustomerId')>
				<cfset Where.isEqual(
					
							"Customer"
						
				, "CustomerId", arguments.CustomerId) />
			</cfif>
		
			<cfif IsDefined('arguments.Username')>
				<cfset Where.isEqual(
					
							"Customer"
						
				, "Username", arguments.Username) />
			</cfif>
		
			<cfif IsDefined('arguments.Password')>
				<cfset Where.isEqual(
					
							"Customer"
						
				, "Password", arguments.Password) />
			</cfif>
		
			<cfif IsDefined('arguments.FirstName')>
				<cfset Where.isEqual(
					
							"Customer"
						
				, "FirstName", arguments.FirstName) />
			</cfif>
		
			<cfif IsDefined('arguments.LastName')>
				<cfset Where.isEqual(
					
							"Customer"
						
				, "LastName", arguments.LastName) />
			</cfif>
		
			<cfif IsDefined('arguments.DateCreated')>
				<cfset Where.isEqual(
					
							"Customer"
						
				, "DateCreated", arguments.DateCreated) />
			</cfif>
		
			<cfif IsDefined('arguments.AddressId')>
				<cfset Where.isEqual(
					
							"Customer"
						
				, "AddressId", arguments.AddressId) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
