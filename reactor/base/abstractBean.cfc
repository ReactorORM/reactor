<cfcomponent hint="I am an abstract Bean.  I am used to define an interface and for return types." extends="reactor.base.abstractObject">

	<cffunction name="configure" access="public" hint="I configure and return this object." output="false" returntype="reactor.base.abstractObject">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="reactor.config.config" />
		<cfargument name="name" hint="I am the name of this object." required="yes" type="string" />
		<cfargument name="ReactorFactory" hint="I am the reactor factory." required="yes" type="reactor.reactorFactory" />
		<cfset super.configure(arguments.config, arguments.name, arguments.objectFactory) />
		
		<cfset _setTo(_getReactorFactory().createTo(arguments.name)) />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="createErrorCollection" access="public" hint="I return a new validationErrorCollection" output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfreturn CreateObject("Component", "reactor.util.ValidationErrorCollection").init() />
	</cffunction>

</cfcomponent>