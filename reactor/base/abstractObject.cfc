<cfcomponent hint="I am the base object used for all reactor stuff.  I may be one step of overkill, but I'm sure you can deal with it.">
	
	<!---
		This is a non-standard named init method.  The reason for this is so that all objects can share a common method for initilization
		while not dis-allowing the use of the init method for specific purposes on objects like Beans.
	---->
	<cffunction name="config" access="public" hint="I configure and return this object." output="false" returntype="reactor.base.abstractObject">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="reactor.bean.config" />
		
		<cfset setConfig(arguments.config) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getSignature" access="public" hint="I return this object's corrisponding DB signature." output="false" returntype="string">
		<cfreturn variables.signature />
	</cffunction>
	
	<!--- config --->
    <cffunction name="setConfig" access="private" output="false" returntype="void">
       <cfargument name="config" hint="I am the configuraion object to use." required="yes" type="reactor.bean.config" />
       <cfset variables.config = arguments.config />
    </cffunction>
    <cffunction name="getConfig" access="private" output="false" returntype="reactor.bean.config">
       <cfreturn variables.config />
    </cffunction>
</cfcomponent>