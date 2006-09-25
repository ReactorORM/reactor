<cfcomponent hint="I am the base object used for all reactor stuff.  I may be one step of overkill, but I'm sure you can deal with it.">

	<cfset variables.signature = "" />
	<cfset variables.config = 0 />
	<cfset variables.name = "" />
	<cfset variables.ReactorFactory = 0 />
	<cfset variables.BeanFactory = 0 />
	
	<!---
		This is a non-standard named init method.  The reason for this is so that all objects can share a common method for initilization
		while not dis-allowing the use of the init method for specific purposes on objects like Records.
	---->
	<cffunction name="_configure" access="public" hint="I configure and return this object." output="false" returntype="any">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="any" />
		<cfargument name="alias" hint="I am the alias of this object." required="yes" type="any" />
		<cfargument name="ReactorFactory" hint="I am the reactorFactory object." required="yes" type="any" />
		<cfargument name="Convention" hint="I am a database Convention object." required="yes" type="any" />
		
		<cfset _setConfig(arguments.config) />
		<cfset _setAlias(arguments.alias) />
		<cfset _setReactorFactory(arguments.ReactorFactory) />
		<cfset _setConvention(arguments.Convention) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="_getSignature" access="public" hint="I return this object's corrisponding DB signature." output="false" returntype="any">
		<cfreturn variables.signature />
	</cffunction>
	
	<!--- config --->
    <cffunction name="_setConfig" access="public" output="false" returntype="void">
       <cfargument name="config" hint="I am the configuraion object to use." required="yes" type="any" />
       <cfset variables.config = arguments.config />
    </cffunction>
    <cffunction name="_getConfig" access="private" output="false" returntype="any">
       <cfreturn variables.config />
    </cffunction>
	
	<!--- name --->
    <cffunction name="_setName" access="public" output="false" returntype="void">
       <cfargument name="name" hint="I am the object's name" required="yes" type="any" />
       <cfset variables.name = arguments.name />
    </cffunction>
    <cffunction name="_getName" access="private" output="false" returntype="any">
       <cfreturn variables.name />
    </cffunction>
	
	<!--- reactorFactory --->
    <cffunction name="_setReactorFactory" access="public" output="false" returntype="void">
       <cfargument name="reactorFactory" hint="I am the reactorFactory object" required="yes" type="any" />
       <cfset variables.reactorFactory = arguments.reactorFactory />
    </cffunction>
    <cffunction name="_getReactorFactory" access="private" output="false" returntype="any">
       <cfreturn variables.reactorFactory />
    </cffunction>
	
	<!--- convention --->
    <cffunction name="_setConvention" access="public" output="false" returntype="void">
       <cfargument name="convention" hint="I am the Convention object to use." required="yes" type="any" />
       <cfset variables.convention = arguments.convention />
    </cffunction>
    <cffunction name="_getConvention" access="private" output="false" returntype="any">
       <cfreturn variables.convention />
    </cffunction>
	
	
	<!--- alias --->
    <cffunction name="_setAlias" access="private" output="false" returntype="void">
       <cfargument name="alias" hint="I am the alias of this object." required="yes" type="any" />
       <cfset variables.alias = arguments.alias />
    </cffunction>
    <cffunction name="_getAlias" access="public" output="false" returntype="any">
       <cfreturn variables.alias />
    </cffunction>

  <!--- BeanFactory --->
  <cffunction name="_setBeanFactory" access="public" output="false" returntype="void" hint="I set a BeanFactory (Spring-interfaced IoC container) to inject into all created objects)." >
  	<cfargument name="beanFactory" type="any" required="true" />
  	<cfset variables.BeanFactory = arguments.beanFactory />
	</cffunction>    
  <cffunction name="_getBean" access="public" output="false" returntype="any" hint="I set a BeanFactory (Spring-interfaced IoC container) to inject into all created objects)." >
  	<cfargument name="name" type="any" required="true" />
  	<cfreturn variables.BeanFactory.getBean(arguments.name) />
	</cffunction>    
		
</cfcomponent>
