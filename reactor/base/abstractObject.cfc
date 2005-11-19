<cfcomponent hint="I am the base object used for all reactor stuff.  I may be one step of overkill, but I'm sure you can deal with it.">

	<cfset variables.signature = "" />
	<cfset variables.config = 0 />
	<cfset variables.name = "" />
	<cfset variables.ReactorFactory = 0 />
	
	<!---
		This is a non-standard named init method.  The reason for this is so that all objects can share a common method for initilization
		while not dis-allowing the use of the init method for specific purposes on objects like Beans.
	---->
	<cffunction name="configure" access="public" hint="I configure and return this object." output="false" returntype="reactor.base.abstractObject">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="reactor.config.config" />
		<cfargument name="name" hint="I am the name of this object." required="yes" type="string" />
		<cfargument name="ReactorFactory" hint="I am the reactorFactory object." required="yes" type="reactor.reactorFactory" />
		
		<cfset _setConfig(arguments.config) />
		<cfset _setName(arguments.name) />
		<cfset _setReactorFactory(arguments.ReactorFactory) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getSignature" access="public" hint="I return this object's corrisponding DB signature." output="false" returntype="string">
		<cfreturn variables.signature />
	</cffunction>
	
	<!--- config --->
    <cffunction name="_setConfig" access="private" output="false" returntype="void">
       <cfargument name="config" hint="I am the configuraion object to use." required="yes" type="reactor.config.config" />
       <cfset variables.config = arguments.config />
    </cffunction>
    <cffunction name="_getConfig" access="private" output="false" returntype="reactor.config.config">
       <cfreturn variables.config />
    </cffunction>
	
	<!--- name --->
    <cffunction name="_setName" access="private" output="false" returntype="void">
       <cfargument name="name" hint="I am the object's name" required="yes" type="string" />
       <cfset variables.name = arguments.name />
    </cffunction>
    <cffunction name="_getName" access="private" output="false" returntype="string">
       <cfreturn variables.name />
    </cffunction>
	
	<!--- reactorFactory --->
    <cffunction name="_setReactorFactory" access="private" output="false" returntype="void">
       <cfargument name="reactorFactory" hint="I am the reactorFactory object" required="yes" type="reactor.reactorFactory" />
       <cfset variables.reactorFactory = arguments.reactorFactory />
    </cffunction>
    <cffunction name="_getReactorFactory" access="private" output="false" returntype="reactor.reactorFactory">
       <cfreturn variables.reactorFactory />
    </cffunction>
</cfcomponent>