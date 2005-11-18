<cfcomponent hint="I am an abstract Bean.  I am used to define an interface and for return types." extends="reactor.base.abstractObject">

	<cffunction name="configure" access="public" hint="I configure and return this object." output="false" returntype="reactor.base.abstractObject">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="reactor.config.config" />
		<cfargument name="name" hint="I am the name of this object." required="yes" type="string" />
		<cfargument name="objectFactory" hint="I am the reactor factory." required="yes" type="reactor.core.objectFactory" />
		<cfset super.configure(arguments.config, arguments.name, arguments.objectFactory) />
		
		<cfset _setTo(_getObjectFactory().create(arguments.name, "To")) />
		
		<cfreturn this />
	</cffunction>

</cfcomponent>