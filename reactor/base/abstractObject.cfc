<cfcomponent hint="I am the base object used for all reactor stuff.  I may be one step of overkill, but I'm sure you can deal with it.">
	
	<cffunction name="init" access="public" hint="I configure and return the Gateway object." output="false" returntype="reactor.base.abstractObject">
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