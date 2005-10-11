<cfcomponent>
	<cfset variables.ObjectFactory = 0 />
	
	<cffunction name="init" access="public" hint="I configure this object factory" returntype="reactorFactory">
		<cfargument name="config" hint="I am a reactor config object" required="yes" type="reactor.bean.config" />
		
		<cfset setObjectFactory(CreateObject("Component", "reactor.core.ObjectFactory").init(arguments.config)) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createRecord" access="public" hint="I return a record object." output="false" returntype="reactor.base.abstractRecord">
		<cfargument name="name" hint="I am the name of the record to return.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().create(arguments.name, "Record") />
	</cffunction>
	
	<cffunction name="createDao" access="public" hint="I return a Dao object." output="false" returntype="reactor.base.abstractDao">
		<cfargument name="name" hint="I am the name of the Dao to return.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().create(arguments.name, "Dao") />
	</cffunction>
	
	<cffunction name="createTo" access="public" hint="I return a To object." output="false" returntype="reactor.base.abstractTo">
		<cfargument name="name" hint="I am the name of the TO to return.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().create(arguments.name, "To") />
	</cffunction>
	
	<cffunction name="createGateway" access="public" hint="I return a gateway object." output="false" returntype="reactor.base.abstractGateway">
		<cfargument name="name" hint="I am the name of the record to return.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().create(arguments.name, "Gateway") />
	</cffunction>
	
	<!--- ObjectFactory --->
    <cffunction name="setObjectFactory" access="private" output="false" returntype="void">
       <cfargument name="ObjectFactory" hint="I am the table factory used to get table metadata" required="yes" type="reactor.core.objectFactory" />
       <cfset variables.ObjectFactory = arguments.ObjectFactory />
    </cffunction>
    <cffunction name="getObjectFactory" access="private" output="false" returntype="reactor.core.objectFactory">
       <cfreturn variables.ObjectFactory />
    </cffunction>

</cfcomponent>