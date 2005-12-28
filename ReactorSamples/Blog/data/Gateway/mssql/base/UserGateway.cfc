
<cfcomponent hint="I am the base Gateway object for the User table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "A8D7F99485D5EECC861FDBDCA6E77261" />

	<cffunction name="getAll" access="public" hint="I return all rows from the User table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the User table." output="false" returntype="query">
		
			<cfargument name="UserId" hint="If provided, I match the provided value to the UserId field in the User table." required="no" type="string" />
		
			<cfargument name="Username" hint="If provided, I match the provided value to the Username field in the User table." required="no" type="string" />
		
			<cfargument name="Password" hint="If provided, I match the provided value to the Password field in the User table." required="no" type="string" />
		
			<cfargument name="FirstName" hint="If provided, I match the provided value to the FirstName field in the User table." required="no" type="string" />
		
			<cfargument name="LastName" hint="If provided, I match the provided value to the LastName field in the User table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.UserId')>
				<cfset Where.isEqual(
					
							"User"
						
				, "UserId", arguments.UserId) />
			</cfif>
		
			<cfif IsDefined('arguments.Username')>
				<cfset Where.isEqual(
					
							"User"
						
				, "Username", arguments.Username) />
			</cfif>
		
			<cfif IsDefined('arguments.Password')>
				<cfset Where.isEqual(
					
							"User"
						
				, "Password", arguments.Password) />
			</cfif>
		
			<cfif IsDefined('arguments.FirstName')>
				<cfset Where.isEqual(
					
							"User"
						
				, "FirstName", arguments.FirstName) />
			</cfif>
		
			<cfif IsDefined('arguments.LastName')>
				<cfset Where.isEqual(
					
							"User"
						
				, "LastName", arguments.LastName) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
