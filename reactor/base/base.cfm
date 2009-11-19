
<!--- this file includes a set of base variables and functions.  I used to be the abstractObject.cfc, but, let's face it, that was overkill.  Heck, this might 
be overkill too... but it's a start at lessening the inheritance tree --->

<cfset variables.signature = "" />
<cfset variables.config = 0 />
<cfset variables.name = "" />
<cfset variables.ReactorFactory = 0 />
<cfset variables.BeanFactory = 0 />

<cffunction name="_getSignature" access="public" hint="I return this object's corrisponding DB signature." output="false" returntype="any" _returntype="string">
	<cfreturn variables.signature />
</cffunction>

<!--- config --->
<cffunction name="_setConfig" access="public" output="false" returntype="void">
   <cfargument name="config" hint="I am the configuraion object to use." required="yes" type="any" _type="reactor.config.config" />
   <cfset variables.config = arguments.config />
</cffunction>
<cffunction name="_getConfig" access="private" output="false" returntype="any" _returntype="reactor.config.config">
   <cfreturn variables.config />
</cffunction>

<!--- name --->
<cffunction name="_setName" access="public" output="false" returntype="void">
   <cfargument name="name" hint="I am the object's name" required="yes" type="any" _type="string" />
   <cfset variables.name = arguments.name />
</cffunction>
<cffunction name="_getName" access="private" output="false" returntype="any" _returntype="string">
   <cfreturn variables.name />
</cffunction>

<!--- reactorFactory --->
<cffunction name="_setReactorFactory" access="public" output="false" returntype="void">
   <cfargument name="reactorFactory" hint="I am the reactorFactory object" required="yes" type="any" _type="reactor.reactorFactory" />
   <cfset variables.reactorFactory = arguments.reactorFactory />
</cffunction>
<cffunction name="_getReactorFactory" access="private" output="false" returntype="any" _returntype="reactor.reactorFactory">
   <cfreturn variables.reactorFactory />
</cffunction>

<!--- convention --->
<cffunction name="_setConvention" access="public" output="false" returntype="void">
   <cfargument name="convention" hint="I am the Convention object to use." required="yes" type="any" _type="reactor.data.abstractConvention" />
   <cfset variables.convention = arguments.convention />
</cffunction>
<cffunction name="_getConvention" access="private" output="false" returntype="any" _returntype="reactor.data.abstractConvention">
   <cfreturn variables.convention />
</cffunction>


<!--- alias --->
<cffunction name="_setAlias" access="private" output="false" returntype="void">
   <cfargument name="alias" hint="I am the alias of this object." required="yes" type="any" _type="string" />
   <cfset variables.alias = arguments.alias />
</cffunction>
<cffunction name="_getAlias" access="public" output="false" returntype="any" _returntype="string">
   <cfreturn variables.alias />
</cffunction>

<!--- BeanFactory --->
<cffunction name="_setBeanFactory" access="public" output="false" returntype="void" hint="I set a BeanFactory (Spring-interfaced IoC container) to inject into all created objects)." >
<cfargument name="beanFactory" type="any" _type="any" required="true" />
<cfset variables.BeanFactory = arguments.beanFactory />
</cffunction>    
<cffunction name="_getBean" access="public" output="false" returntype="any" _returntype="any" hint="I set a BeanFactory (Spring-interfaced IoC container) to inject into all created objects)." >
<cfargument name="name" type="any" _type="string" required="true" />
<cfreturn variables.BeanFactory.getBean(arguments.name) />
</cffunction>    
	
<!--- Injected Beans --->	
<cffunction name="_setInjectedBean" access="public" output="false" returntype="void" hint="I set a BeanFactory (Spring-interfaced IoC container) to inject into all created objects)." >
	<cfargument name="beanName" type="string" _type="string" required="true" />
	<cfargument name="bean" type="any" _type="any" required="true" />
		<cfset variables[arguments.beanName] = arguments.bean>
</cffunction>    



