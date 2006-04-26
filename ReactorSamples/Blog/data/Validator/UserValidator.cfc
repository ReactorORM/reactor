
<cfcomponent hint="I am the validator object for the User object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.ReactorBlog.Validator.UserValidator">
	<!--- Place custom code here, it will not be overwritten --->
	
	<!--- validateUsername --->
	<cffunction name="validateUsername" access="public" hint="I validate the username field" output="false" returntype="reactor.util.ErrorCollection">
		<cfargument name="UserRecord" hint="I am the UserRecord to validate." required="no" type="reactor.project.ReactorBlog.Record.UserRecord" />
		<cfargument name="ErrorCollection" hint="I am the error collection to populate. If not provided a new collection is created." required="no" type="reactor.util.ErrorCollection" default="#createErrorCollection(arguments.UserRecord._getDictionary())#" />
		
		<cfset super.validateUsername(arguments.UserRecord, arguments.ErrorCollection) />
		
		<!--- validate username is unique --->
		<cfset validateUsernameIsUnique(arguments.UserRecord, arguments.ErrorCollection)>
		
		<cfreturn arguments.ErrorCollection />
	</cffunction>
		
	<!--- validateUsernameIsUnique --->
	<cffunction name="validateUsernameIsUnique" access="public" hint="I validate that the username field is unique" output="false" returntype="reactor.util.ErrorCollection">
		<cfargument name="UserRecord" hint="I am the UserRecord to validate." required="no" type="reactor.project.ReactorBlog.Record.UserRecord" />
		<cfargument name="ErrorCollection" hint="I am the error collection to populate. If not provided a new collection is created." required="no" type="reactor.util.ErrorCollection" default="#createErrorCollection(arguments.UserRecord._getDictionary())#" />
		<cfset var UserGateway = _getReactorFactory().createGateway("User") />

		<!--- insure that another user with the same username does not already exist --->
		<cfif UserGateway.validateUserName(arguments.UserRecord.getUserId(), arguments.UserRecord.getUserName())>
			<cfset arguments.ErrorCollection.addError("User.username.duplicateName") />
		</cfif>
		
		<cfreturn arguments.ErrorCollection />
	</cffunction>	
	
</cfcomponent>
	
