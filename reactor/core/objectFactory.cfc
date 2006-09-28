<cfcomponent hint="I am the object factory.">
	
	<cfset variables.config = "" />
	<cfset variables.ReactorFactory = "" />
	<cfset variables.BeanFactory = "" />
	<!---<cfset variables.TimedCache = CreateObject("Component", "reactor.util.TimedCache").init(createTimeSpan(0, 0, 0, 10)) />--->
	<cfset variables.Cache = StructNew() />
	<cfset variables.Cache.Dao = StructNew() />
	<cfset variables.Cache.Gateway = StructNew() />
	<cfset variables.Cache.Metadata = StructNew() />
	<cfset variables.Cache.Validator = StructNew() />
	
	<cffunction name="init" access="public" hint="I configure the table factory." output="false" returntype="any">
		<cfargument name="config" hint="I am a reactor config object" required="yes" type="any" />
		<cfargument name="ReactorFactory" hint="I am the reactorFactory object." required="yes" type="any" />
		<cfset var pluginQuery = 0 />
		<cfset var pluginList = "" />
		
		<cfset setConfig(arguments.config) />
		<cfset setReactorFactory(arguments.ReactorFactory) />
		<cfset setConvention(CreateObject("Component", "reactor.data.#arguments.config.getType()#.Convention")) />

		<!--- load plugins --->
		<cfdirectory action="list" directory="#expandPath("/reactor/plugins")#" name="pluginQuery" />
		
		<!--- parse out the avaliable plugins --->
		<cfloop query="pluginQuery">
			<cfif NOT ListFindNoCase(pluginList, ListFirst(pluginQuery.name, "."))>
				<cfset pluginList = ListAppend(pluginList, ListFirst(pluginQuery.name, ".")) />
			</cfif>
		</cfloop>
		
		<!--- set the avaliable plugins --->
		<cfset setPluginList(pluginList) />

		<cfreturn this />
	</cffunction>
	
	<cffunction name="compile" access="public" hint="I create all of the default reactor object types (but not plugins) so as to compile all objects according to the current configuration options" output="false" returntype="void">
		<cfset var objectNames = getConfig().getObjectNames() />
		<cfset var x = 0 />
		
		<!--- generate the base object types --->
		<cfloop from="1" to="#ArrayLen(objectNames)#" index="x">
			<cfset create(objectNames[x], "Record") />
			<cfset create(objectNames[x], "Dao") />
			<cfset create(objectNames[x], "To") />
			<cfset create(objectNames[x], "Gateway") />
			<cfset create(objectNames[x], "Metadata") />
			<cfset createDictionary(objectNames[x]) />
			<cfset create(objectNames[x], "Validator") />
		</cfloop>
	</cffunction>

	<cffunction name="create" access="public" hint="I create and return an object for a specific table." output="false" returntype="any">
		<cfargument name="alias" hint="I am the alias of the object to create an object for." required="yes" type="any" />
		<cfargument name="type" hint="I am the type of object to create.  Options are: To, Dao, Gateway, Record, Metadata, Validator unless this is a plugin." required="yes" type="any" />
		<cfargument name="plugin" hint="I indicate if this is creating a plugin" required="no" type="any" default="false" />
		<cfset var DbObject = 0 />
		<cfset var GeneratedObject = 0 />
		<cfset var generate = false />
		<cfset var ObjectTranslator = 0 />
		<cfset var metadata = 0 />
		
		<cfif NOT arguments.plugin AND NOT ListFind("Record,Dao,Gateway,To,Metadata,Validator", arguments.type)>
			<cfthrow type="reactor.InvalidObjectType"
				message="Invalid Object Type"
				detail="The type argument must be one of: Record, Dao, Gateway, To, Metadata, Validator" />
				
		<cfelseif arguments.plugin AND NOT ListFindNoCase(getPluginList(), arguments.type)>
			<cfthrow type="reactor.InvalidPluginType"
				message="Invalid Plugin Type"
				detail="The plugin type must be one of: #replace(getPluginList(), ",", ", ", "all")#" />
		</cfif>
		
		<cftry>
<!--- 			<cfswitch expression="#getConfig().getMode()#"> --->
				<cfif compareNocase(getConfig().getMode(), "always") is 0>
					<!--- we always need the db object to transform --->
					<cfset DbObject = getObject(arguments.alias) />
					<cfset generate = true />
				<cfelseif compareNocase(getConfig().getMode(), "development") is 0>				
					<!--- we always need the db object to compare to our existing object --->
					<cfset DbObject = getObject(arguments.alias) />
					<cftry>
						<!--- create an instance of the object and check its signature --->
						<cfset GeneratedObject = CreateObject("Component", getObjectName(arguments.type, arguments.alias, arguments.plugin)) />
						<cfcatch>
							<cfset generate = true />
						</cfcatch>
					</cftry>
					<cfif NOT generate>
						<!--- check the object's signature --->
						<cfif DbObject.getSignature() IS NOT GeneratedObject._getSignature()>
							<cfset generate = true />
						</cfif>
					</cfif>
				<cfelseif compareNocase(getConfig().getMode(), "production") is 0>
					<cftry>
						
						<!--- get an instance of the object from cache or create it --->
						<cfif ListFind("Dao,Gateway,Metadata,Validator", arguments.type)>

							<cfif StructKeyExists(variables.Cache[arguments.type], arguments.alias)>
								<cfset GeneratedObject = variables.Cache[arguments.type][arguments.alias] />
							<cfelse>
								<cfset GeneratedObject = CreateObject("Component", getObjectName(arguments.type, arguments.alias, arguments.plugin)) />
								<cfset variables.Cache[arguments.type][arguments.alias] = GeneratedObject />
							</cfif>

						<cfelse>

							<!--- we never cache Record, To or iterator objects --->
							<cfset GeneratedObject = CreateObject("Component", getObjectName(arguments.type, arguments.alias, arguments.plugin)) />
	
						</cfif>
						<cfcatch>
							<!--- we only need the dbobject if it doesn't already exist --->
							<cfset DbObject = getObject(arguments.alias) />
							<cfset generate = true />
						</cfcatch>
					</cftry>
			</cfif>
			<cfcatch type="Reactor.NoSuchObject">
				<cfthrow type="Reactor.NoSuchObject" message="Object '#arguments.alias#' does not exist." detail="Reactor was unable to find an object in the database with the name '#arguments.alias#.'" />
			</cfcatch>
		</cftry>
		<!--- return either a generated object or the existing object --->
		<cfif generate>
			<cfset ObjectTranslator = CreateObject("Component", "reactor.core.objectTranslator").init(getConfig(), DbObject, this) />
			
			<cfset ObjectTranslator.generateObject(arguments.type, arguments.plugin) />	
			
			<cfif ListFind("Dao,Gateway,Record", arguments.type) OR arguments.plugin>
				<!--- check to see if a metadata object of this type exists.  If not, create it --->
				<cfif StructKeyExists(variables.Cache.metadata, arguments.alias)>
					<cfset metadata = variables.Cache.metadata[arguments.alias] />
				<cfelse> 
					<cfset metadata = create(arguments.alias, "Metadata") />
				</cfif>
				
				<cfset GeneratedObject = CreateObject("Component", getObjectName(arguments.type, arguments.alias, arguments.plugin))._configure(getConfig(), arguments.alias, getReactorFactory(), getConvention(), metadata) />
			<cfelse>
				<cfset GeneratedObject = CreateObject("Component", getObjectName(arguments.type, arguments.alias, arguments.plugin))._configure(getConfig(), arguments.alias, getReactorFactory(), getConvention()) />
			</cfif>

		<cfelse>
			<cfif ListFind("Dao,Gateway,Record", arguments.type) OR arguments.plugin>
				<!--- check to see if a metadata object of this type exists.  If not, create it --->
				<cfif StructKeyExists(variables.Cache.metadata, arguments.alias)>
					<cfset metadata = variables.Cache.metadata[arguments.alias] />
				<cfelse> 
					<cfset metadata = create(arguments.alias, "Metadata") />
				</cfif>
				
				<cfset GeneratedObject = GeneratedObject._configure(getConfig(), arguments.alias, getReactorFactory(), getConvention(), metadata) />
			<cfelse>
				<cfset GeneratedObject = GeneratedObject._configure(getConfig(), arguments.alias, getReactorFactory(), getConvention()) />
			</cfif>
		</cfif>
		
		<cfif isObject(variables.BeanFactory)>
			<cfset GeneratedObject._setBeanFactory(variables.BeanFactory) />
		</cfif>
		
		<cfreturn GeneratedObject />
	</cffunction>

	<cffunction name="createDictionary" access="public" hint="I create and return a dictionary object for a specific table." output="false" returntype="any">
		<cfargument name="alias" hint="I am the alias of the object to create an object for." required="yes" type="any" />
		<cfset var DbObject = 0 />
		<cfset var generate = false />
		<cfset var DictionaryObject = 0 />
		<cfset var dictionaryXmlPath = "#getObject(arguments.alias).getMapping()#/Dictionary/#arguments.alias#dictionary.xml" />
		<cfset var ObjectTranslator = 0 />
		
		<cftry>
<!--- 			<cfswitch expression="#getConfig().getMode()#"> --->
				<cfif compareNocase(getConfig().getMode(), "production") is 0>
					<cftry>
						<!--- get an instance of the object from cache or create it --->
						<cfif StructKeyExists(variables.Cache["Dictionary"], arguments.alias)>
							<cfset DictionaryObject = variables.Cache["Dictionary"][arguments.alias] />
						<cfelse>
							<cfset DictionaryObject = CreateObject("Component", "reactor.dictionary.dictionary").init(dictionaryXmlPath) />
							<cfset variables.Cache["Dictionary"][arguments.alias] = DictionaryObject />
						</cfif>

						<cfcatch>
							<!--- we only need the dbobject if it doesn't already exist --->
							<cfset DbObject = getObject(arguments.alias) />
							<cfset generate = true />
						</cfcatch>
					</cftry>
				<cfelse>
					<!--- we always need the db object to update the xml --->
					<cfset DbObject = getObject(arguments.alias) />
					<cfset generate = true />
			</cfif>
			
			<cfcatch type="Reactor.NoSuchObject">
				<cfthrow type="Reactor.NoSuchObject" message="Object '#arguments.alias#' does not exist." detail="Reactor was unable to find an object in the database with the name '#arguments.alias#.'" />
			</cfcatch>
		</cftry>
		
		<!--- return either a generated object or the existing object --->
		<cfif generate>
			<cfset ObjectTranslator = CreateObject("Component", "reactor.core.objectTranslator").init(getConfig(), DbObject, this) />
			
			<cfset ObjectTranslator.generateDictionary(dictionaryXmlPath) />	
			
			<cfset DictionaryObject = CreateObject("Component", "reactor.dictionary.dictionary").init(dictionaryXmlPath) />
		</cfif>
		
		<cfreturn DictionaryObject />
	</cffunction>
	
	<cffunction name="getObject" access="public" hint="I read and return a reactor.core.object object for a specific db object." output="false" returntype="any">
		<cfargument name="name" hint="I am the name of the object to translate." required="yes" type="any" />
		<cfset var Object = 0 />
		<cfset var ObjectDao = 0/>
		
		<cfset Object = CreateObject("Component", "reactor.core.object").init(arguments.name, getConfig()) />
		<cfset ObjectDao = CreateObject("Component", "reactor.data.#getConfig().getType()#.ObjectDao").init(getConfig().getDsn(), getConfig().getUsername(), getConfig().getPassword()) />
		
		<!--- read the object --->
		<cfset ObjectDao.read(Object) />
		
		<!--- return the object --->
		<cfreturn Object />
	</cffunction>
	
	<cffunction name="getObjectName" access="private" hint="I return the correct name of the a object based on it's type and other configurations" output="false" returntype="any">
		<cfargument name="type" hint="I am the type of object to return.  Options are: record, dao, gateway, to" required="yes" type="any" />
		<cfargument name="name" hint="I am the name of the object to return." required="yes" type="any" />
		<cfargument name="plugin" hint="I indicate if this is creating a plugin" required="yes" type="any" />
		<cfset var creationPath = "" />
		<cfset var mapping = getConfig().getMapping(arguments.name) />
		
		<!--- if the user doesn't have a leading slash on their mapping then add one --->
		<cfif left(mapping, 1) IS NOT "/">
			<cfset mapping = "/" & mapping />
		</cfif>
				
		<cfset creationPath = replaceNoCase(right(mapping, Len(mapping) - 1), "/", ".", "all") />
				
		<cfreturn creationPath & Iif(arguments.plugin, De(".plugins"), De("")) & "." & arguments.type & "." & arguments.name & arguments.type & getConfig().getType()  />
	</cffunction>
	
	<!--- config --->
  <cffunction name="setConfig" access="public" output="false" returntype="void">
     <cfargument name="config" hint="I am the config object used to configure reactor" required="yes" type="any" />
     <cfset variables.config = arguments.config />
  </cffunction>
  <cffunction name="getConfig" access="public" output="false" returntype="any">
     <cfreturn variables.config />
  </cffunction>
	
	<!--- reactorFactory --->
  <cffunction name="setReactorFactory" access="private" output="false" returntype="void">
     <cfargument name="reactorFactory" hint="I am the reactorFactory object" required="yes" type="any" />
     <cfset variables.reactorFactory = arguments.reactorFactory />
  </cffunction>
  <cffunction name="getReactorFactory" access="private" output="false" returntype="any">
     <cfreturn variables.reactorFactory />
  </cffunction>

  <!--- BeanFactory --->
  <cffunction name="setBeanFactory" access="public" output="false" returntype="void" hint="I set a BeanFactory (Spring-interfaced IoC container) to inject into all created objects)." >
  	<cfargument name="beanFactory" type="any" required="true" />
  	<cfset variables.BeanFactory = arguments.beanFactory />
  </cffunction>
	
	<!--- convention --->
  <cffunction name="setConvention" access="private" output="false" returntype="void">
     <cfargument name="convention" hint="I am a convention object" required="yes" type="any" />
     <cfset variables.convention = arguments.convention/>
  </cffunction>
  <cffunction name="getConvention" access="private" output="false" returntype="any">
     <cfreturn variables.convention />
  </cffunction>
	
	<!--- pluginList --->
  <cffunction name="setPluginList" access="private" output="false" returntype="void">
     <cfargument name="pluginList" hint="I am a list of avaliable plugins" required="yes" type="any" />
     <cfset variables.pluginList = arguments.pluginList />
  </cffunction>
  <cffunction name="getPluginList" access="private" output="false" returntype="any">
     <cfreturn variables.pluginList />
  </cffunction>
	
</cfcomponent>