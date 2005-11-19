<cfcomponent>
	<cfset variables.ObjectFactory = 0 />
	
	<cffunction name="init" access="public" hint="I configure this object factory" returntype="reactorFactory">
		<cfargument name="pathToConfigXml" hint="I am the path to the config XML file." required="yes" type="string" />
		<cfset var config = CreateObject("Component", "reactor.config.config").init(arguments.pathToConfigXml) />
		
		<cfset setObjectFactory(CreateObject("Component", "reactor.core.ObjectFactory").init(config, this)) />
		
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
	
	<cffunction name="createBean" access="public" hint="I return a bean object." output="false" returntype="reactor.base.abstractBean">
		<cfargument name="name" hint="I am the name of the bean to return.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().create(arguments.name, "Bean") />
	</cffunction>
	
	<cffunction name="createMetadata" access="public" hint="I return a metadata object." output="false" returntype="reactor.base.abstractMetadata">
		<cfargument name="name" hint="I am the name of the metadata to return.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().create(arguments.name, "Metadata") />
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