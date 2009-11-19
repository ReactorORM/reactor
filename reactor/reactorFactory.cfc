<cfcomponent>
	<cfset variables.ObjectFactory = 0 />
	<cfset variables.BeanFactory = 0 />
	
	<cffunction name="init" access="public" hint="I configure this object factory" returntype="any" _returntype="reactorFactory">
		<cfargument name="configuration" hint="I am either a relative or absolute path to the config XML file or an instance of a reactor.config.config component" required="yes" type="any" _type="any" />
		<cfargument name="BeanFactory" hint="I am an IOC beanfactory that you can inject to inject objects into your records and gateways" required="false" type="coldspring.beans.BeanFactory">

		<!--- if the config was not passed in, load the XML file --->
		<cfif NOT IsObject(arguments.configuration)>
			<cfset arguments.configuration = CreateObject("Component", "reactor.config.config").init(arguments.configuration) />
		</cfif>
		
		<!--- pass the configuration into the objectFactory --->
		<cfset setObjectFactory(CreateObject("Component", "reactor.core.objectFactory").init(arguments.configuration, this)) />
		
<!--- 		If we have passed in a BeanFactory set it for the following method --->

		<cfif StructKeyExists(arguments,"factory") AND isObject(arguments.factory)>
			<cfset variables.BeanFactory = arguments.factory>
			<cfset getObjectFactory().setBeanFactory(arguments.factory) />		
			<cfreturn this />
		</cfif>
		
		<!--- give the objectfactory the beanfactory if it is injected --->
		<cfset getObjectFactory().setBeanFactory(getBeanFactory()) />		
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createRecord" access="public" hint="I return a record object." output="false" returntype="any" _returntype="reactor.base.abstractRecord">
		<cfargument name="objectAlias" hint="I am the alias of the record to return.  I corrispond to the name of a object in the DB." required="yes" type="any" _type="string" />
		<cfset var Record = 0 />
		
		<cfset Record = getObjectFactory().create(arguments.objectAlias, "Record") />
		
		<cfreturn Record />
	</cffunction>
	
	<cffunction name="createDao" access="public" hint="I return a Dao object." output="false" returntype="any" _returntype="reactor.base.abstractDao">
		<cfargument name="objectAlias" hint="I am the alias of the Dao to return.  I corrispond to the name of a object in the DB." required="yes" type="any" _type="string" />
		<cfset var Dao = 0 />
		
		<cfset Dao = getObjectFactory().create(arguments.objectAlias, "Dao") />
		
		<cfreturn Dao />
	</cffunction>
	
	<cffunction name="createTo" access="public" hint="I return a To object." output="false" returntype="any" _returntype="reactor.base.abstractTo">
		<cfargument name="objectAlias" hint="I am the alias of the TO to return.  I corrispond to the name of a object in the DB." required="yes" type="any" _type="string" />
		<cfset var To = 0 />
		
		<cfset To = getObjectFactory().create(arguments.objectAlias, "To") />
		
		<cfreturn To />
	</cffunction>
	
	<cffunction name="createGateway" access="public" hint="I return a gateway object." output="false" returntype="any" _returntype="reactor.base.abstractGateway">
		<cfargument name="objectAlias" hint="I am the alias of the record to return.  I corrispond to the name of a object in the DB." required="yes" type="any" _type="string" />
		<cfset var Gateway = 0 />
		
		<cfset Gateway = getObjectFactory().create(arguments.objectAlias, "Gateway") />
		
		<cfreturn Gateway />
	</cffunction>

	<cffunction name="createMetadata" access="public" hint="I return a metadata object." output="false" returntype="any" _returntype="reactor.base.abstractMetadata">
		<cfargument name="objectAlias" hint="I am the alias of the metadata to return.  I corrispond to the name of a object in the DB." required="yes" type="any" _type="string" />
		<cfset var Metadata = 0 />
		
		<cfset Metadata = getObjectFactory().create(arguments.objectAlias, "Metadata") />
		
		<cfreturn Metadata />
	</cffunction>

	<cffunction name="createIterator" access="public" hint="I return an iterator object." output="false" returntype="any" _returntype="reactor.iterator.iterator">
		<cfargument name="objectAlias" hint="I am the alias of the object the iterator is being created for.  I corrispond to the name of a object in the DB." required="yes" type="any" _type="string" />
		<cfset var Iterator = 0 />
		
		<cfset Iterator = createobject("Component", "reactor.iterator.iterator").init(this, arguments.objectAlias) />
		
		<cfreturn Iterator />
	</cffunction>

	<cffunction name="createDictionary" access="public" hint="I return a dictionary object." output="false" returntype="any" _returntype="reactor.dictionary.dictionary">
		<cfargument name="objectAlias" hint="I am the alias of the object the dictionary is being created for.  I corrispond to the name of a object in the DB." required="yes" type="any" _type="string" />
		<cfset var Dictionary = 0 />
		
		<cfset Dictionary = getObjectFactory().createDictionary(arguments.objectAlias) />
		
		<cfreturn Dictionary />
	</cffunction>

	<cffunction name="createValidator" access="public" hint="I return a validator object." output="false" returntype="any" _returntype="reactor.base.abstractValidator">
		<cfargument name="objectAlias" hint="I am the alias of the object the validator is being created for.  I corrispond to the name of a object in the DB." required="yes" type="any" _type="string" />
		<cfset var Validator = 0 />
		
		<cfset Validator = getObjectFactory().create(arguments.objectAlias, "Validator") />
		
		<cfreturn Validator />
	</cffunction>

	<cffunction name="getXml" access="public" hint="I return the raw XML for a database object.  I combine the configuration and the database metadata." output="false" returntype="any" _returntype="string">
		<cfargument name="objectAlias" hint="I am the alias of the object the xml describes.  I corrispond to the name of a object in the DB." required="yes" type="any" _type="string" />
		<cfreturn getObjectFactory().getObject(arguments.objectAlias).getXml() />
	</cffunction>

	<cffunction name="createPlugin" access="public" hint="I return a plugin object of the specified type." output="false" returntype="any" _returntype="any">
		<cfargument name="objectAlias" hint="I am the alias of the metadata to return.  I corrispond to the name of a object in the DB." required="yes" type="any" _type="string" />
		<cfargument name="plugin" hint="I am the name of the plugin to use." required="yes" type="any" _type="string" />
		<cfset var Object = 0 />
		
		<cfset Object = getObjectFactory().create(arguments.objectAlias, arguments.plugin, true) />
		
		<cfreturn Object />
	</cffunction>
	
	<cffunction name="compile" access="public" hint="I simply call all the create methods for all of the reactor object types so as to compile all objects according to the current configuration options" output="false" returntype="void">
		<cfset getObjectFactory().compile() />
	</cffunction>
	
	<!--- ObjectFactory --->
	<cffunction name="setObjectFactory" access="private" output="false" returntype="void">
		<cfargument name="ObjectFactory" hint="I am the table factory used to get table metadata" required="yes" type="any" _type="reactor.core.objectFactory" />
		<cfset variables.ObjectFactory = arguments.ObjectFactory />
	</cffunction>
	<cffunction name="getObjectFactory" access="private" output="false" returntype="any" _returntype="reactor.core.objectFactory">
		<cfreturn variables.ObjectFactory />
	</cffunction>
  
	<!--- BeanFactory --->
	<cffunction name="setBeanFactory" access="public" output="false" returntype="void" hint="I set a BeanFactory (Spring-interfaced IoC container) to inject into all created objects)." >
		<cfargument name="factory" type="coldspring.beans.BeanFactory" required="true" />
		<cfset variables.BeanFactory = arguments.factory />
		<cfset getObjectFactory().setBeanFactory( arguments.factory )>
	</cffunction>
	
	<cffunction name="getBeanFactory" access="public" output="false" returntype="any" _returntype="any">
		<cfreturn variables.BeanFactory />
	</cffunction>

</cfcomponent>
