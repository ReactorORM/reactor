
<cfcomponent hint="I am the custom Gateway object for the  table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="ReactorBlogData.Gateway.mysql.base.UserGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="getAllUsers" access="public" hint="I return a query of users and the number of entries they've created" output="false" returntype="query">
		<cfset var users = 0 />
		
		<cfquery name="users" datasource="#_getConfig().getDsn()#">
			SELECT u.userId, u.firstName, u.lastName, u.userName, COUNT(e.entryId) as entryCount
			FROM `User` as u LEFT JOIN Entry as e
				ON u.userId = e.postedByUserId
			GROUP BY u.userId, u.firstName, u.lastName, u.userName
			ORDER BY u.firstName, u.lastName
		</cfquery>
		
		<cfreturn users />
	</cffunction>
	
	<cffunction name="validateUserName" access="public" hint="I look for other users with the same username.  True if found, false if not." output="false" returntype="boolean">
		<cfargument name="userId" hint="I am the userId to check." required="yes" type="numeric" />
		<cfargument name="userName" hint="I am the username ot check for." required="yes" type="string" />
		<cfset var validate = 0 />
		
		<cfquery name="validate" datasource="#_getConfig().getDsn()#">
			SELECT userId
			FROM `User` 
			WHERE userId != <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userId#" />
				AND userName = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="20" value="#arguments.userName#" />
		</cfquery>
		
		<cfreturn validate.recordcount IS 1 />
	</cffunction>
	
</cfcomponent>
	
