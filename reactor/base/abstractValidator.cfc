<cfcomponent hint="I am an abstract Validator.  I am used to define an interface and for validation objects.">
	
	<cfinclude template="base.cfm" />
	
	<cffunction name="_configure" access="public" hint="I configure and return this object." output="false" returntype="any" _returntype="reactor.base.abstractValidator">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="any" _type="reactor.config.config" />
		<cfargument name="alias" hint="I am the alias of this object." required="yes" type="any" _type="string" />
		<cfargument name="ReactorFactory" hint="I am the reactorFactory object." required="yes" type="any" _type="reactor.reactorFactory" />
		<cfargument name="Convention" hint="I am a database Convention object." required="yes" type="any" _type="reactor.data.abstractConvention" />
		
		<cfset _setConfig(arguments.config) />
		<cfset _setAlias(arguments.alias) />
		<cfset _setReactorFactory(arguments.ReactorFactory) />
		<cfset _setConvention(arguments.Convention) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createErrorCollection" access="public" hint="I create and return an error collection" output="false" returntype="any" _returntype="reactor.util.ErrorCollection">
		<cfargument name="Dictionary" hint="I am the dictionary to use to translate errors." required="yes" type="any" _type="reactor.dictionary.dictionary" />
		
		<cfreturn CreateObject("Component", "reactor.util.ErrorCollection").init(arguments.Dictionary) />
	</cffunction>
	
</cfcomponent>
