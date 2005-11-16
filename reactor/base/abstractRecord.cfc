<cfcomponent hint="I am an abstract record.  I am used primarly to allow type definitions for return values.  I also loosely define an interface for a record objects and some core methods." extends="reactor.base.abstractObject">
	
	<cfset variables.To = 0 />
	<cfset variables.Dao = 0 />
	<cfset variables.ObjectFactory = 0 />
	
	<cffunction name="configure" access="public" hint="I configure and return this object." output="false" returntype="reactor.base.abstractObject">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="reactor.config.config" />
		<cfargument name="name" hint="I am the name of this object." required="yes" type="string" />
		<cfargument name="objectFactory" hint="I am the reactor factory." required="yes" type="reactor.core.objectFactory" />
		<cfset super.configure(arguments.config, arguments.name, arguments.objectFactory) />
		
		<cfset _setTo(_getObjectFactory().create(arguments.name, "To")) />
		<cfset _setDao(_getObjectFactory().create(arguments.name, "Dao")) />
		
		<cfreturn this />
	</cffunction>
		
	<cffunction name="load" access="public" hint="I load this record based on its primary key values." output="false" returntype="boolean">
		
	</cffunction>
	
	<cffunction name="save" access="public" hint="I save record based on its primary key values." output="false" returntype="boolean">
		
	</cffunction>
	
</cfcomponent>