<cfcomponent hint="I am an abstract record.  I am used primarly to allow type definitions for return values.  I also loosely define an interface for a record objects and some core methods." extends="reactor.base.abstractObject">
	
	<cfset variables.To = 0 />
	<cfset variables.Dao = 0 />
	<cfset variables.ObjectFactory = 0 />
	
	<cffunction name="configure" access="public" hint="I configure and return this object." output="false" returntype="reactor.base.abstractObject">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="reactor.config.config" />
		<cfargument name="name" hint="I am the name of this object." required="yes" type="string" />
		<cfargument name="ReactorFactory" hint="I am the reactor factory." required="yes" type="reactor.reactorFactory" />
		<cfset super.configure(arguments.config, arguments.name, arguments.ReactorFactory) />
		
		<cfset _setTo(_getReactorFactory().createTo(arguments.name)) />
		<cfset _setDao(_getReactorFactory().createDao(arguments.name)) />
		
		<cfreturn this />
	</cffunction>
		
	<cffunction name="load" access="public" hint="I load this record based on its primary key values." output="false" returntype="boolean">
		
	</cffunction>
	
	<cffunction name="save" access="public" hint="I save record based on its primary key values." output="false" returntype="boolean">
		
	</cffunction>
	
</cfcomponent>