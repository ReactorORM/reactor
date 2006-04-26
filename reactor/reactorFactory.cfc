<cfcomponent>
	<cfset variables.ObjectFactory = 0 />
	
	<cffunction name="init" access="public" hint="I configure this object factory" returntype="reactorFactory">
		<cfargument name="configuration" hint="I am either a relative or absolute path to the config XML file or an instance of a reactor.config.config component" required="yes" type="any" />
		
		<!--- if the config was not passed in, load the XML file --->
		<cfif NOT IsObject(arguments.configuration)>
			<cfset arguments.configuration = CreateObject("Component", "reactor.config.config").init(arguments.configuration) />
		</cfif>
		
		<!--- pass the configuration into the objectFactory --->
		<cfset setObjectFactory(CreateObject("Component", "reactor.core.objectFactory").init(arguments.configuration, this)) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createRecord" access="public" hint="I return a record object." output="false" returntype="any">
		<cfargument name="objectAlias" hint="I am the alias of the record to return.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().create(arguments.objectAlias, "Record") />
	</cffunction>
	
	<cffunction name="createDao" access="public" hint="I return a Dao object." output="false" returntype="reactor.base.abstractDao">
		<cfargument name="objectAlias" hint="I am the alias of the Dao to return.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().create(arguments.objectAlias, "Dao") />
	</cffunction>
	
	<cffunction name="createTo" access="public" hint="I return a To object." output="false" returntype="reactor.base.abstractTo">
		<cfargument name="objectAlias" hint="I am the alias of the TO to return.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().create(arguments.objectAlias, "To") />
	</cffunction>
	
	<cffunction name="createGateway" access="public" hint="I return a gateway object." output="false" returntype="reactor.base.abstractGateway">
		<cfargument name="objectAlias" hint="I am the alias of the record to return.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().create(arguments.objectAlias, "Gateway") />
	</cffunction>

	<cffunction name="createMetadata" access="public" hint="I return a metadata object." output="false" returntype="reactor.base.abstractMetadata">
		<cfargument name="objectAlias" hint="I am the alias of the metadata to return.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().create(arguments.objectAlias, "Metadata") />
	</cffunction>

	<cffunction name="createIterator" access="public" hint="I return an iterator object." output="false" returntype="reactor.iterator.iterator">
		<cfargument name="objectAlias" hint="I am the alias of the object the iterator is being created for.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn createobject("Component", "reactor.iterator.iterator").init(this, arguments.objectAlias) />
	</cffunction>

	<cffunction name="createDictionary" access="public" hint="I return a dictionary object." output="false" returntype="reactor.dictionary.dictionary">
		<cfargument name="objectAlias" hint="I am the alias of the object the dictionary is being created for.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().createDictionary(arguments.objectAlias) />
	</cffunction>

	<cffunction name="createValidator" access="public" hint="I return a validator object." output="false" returntype="reactor.base.abstractValidator">
		<cfargument name="objectAlias" hint="I am the alias of the object the validator is being created for.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().create(arguments.objectAlias, "Validator") />
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