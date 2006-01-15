
<cfcomponent hint="I am the custom Record object for the  table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.ReactorBlogData.Record.UserRecord" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cfset variables.postLoginEvent = "Home" />
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		<cfset var UserGateway = _getReactorFactory().createGateway("User") />
		<cfset super.validate(arguments.ValidationErrorCollection) />
		
		<!--- Add custom validation logic here, it will not be overwritten --->
		
		<!--- insure that another user with the same username does not already exist --->
		<cfif UserGateway.validateUserName(getUserId(), getUserName())>
			<cfset arguments.ValidationErrorCollection.addError("userName", ErrorManager.getError("User", "Username", "duplicateName")) />
		</cfif>
		
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	<cffunction name="validateLogon" access="public" hint="I validate that this object has the minimum information needed to logon." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
		
	<cffunction name="login" access="public" hint="I log this user into the site" output="false" returntype="boolean">
		<cfset var UserGateway = _getReactorFactory().createGateway(_getName()) />
		<cfset var User = UserGateway.getByFields(username=getUserName(), password=getPassword()) />
		
		<cfif User.RecordCount IS 1>
			<cfset setUserId(User.userId) />
			<cfset load() />
		</cfif>
		
		<cfreturn isLoggedIn() />
	</cffunction>
	
	<cffunction name="isLoggedIn" access="public" hint="I indicate if the user is logged in." output="false" returntype="boolean">
		<cfreturn getUserId() GT 0 />
	</cffunction>
	
	<cffunction name="getFullName" access="public" hint="I return the user's full name." output="false" returntype="string">
		<cfreturn getFirstName() & " " & getLastName() />
	</cffunction>
	
	<!--- postLoginEvent --->
    <cffunction name="setPostLoginEvent" access="public" output="false" returntype="void">
       <cfargument name="postLoginEvent" hint="I store where the user goes after logging in." required="yes" type="string" />
       <cfset variables.postLoginEvent = arguments.postLoginEvent />
    </cffunction>
    <cffunction name="getPostLoginEvent" access="public" output="false" returntype="string">
       <cfreturn variables.postLoginEvent />
    </cffunction>
	
</cfcomponent>
	
