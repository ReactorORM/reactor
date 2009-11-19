<cfcomponent hint="I am the object factory.">
	
	<cfset variables.config = "" />
	<cfset variables.ReactorFactory = "" />
	<cfset variables.BeanFactory = "" />
	<cfset variables.ObjectDao = "" />
	<!---<cfset variables.TimedCache = CreateObject("Component", "reactor.util.TimedCache").init(createTimeSpan(0, 0, 0, 10)) />--->
	<cfset variables.Cache = StructNew() />
	<cfset variables.Cache.Dao = StructNew() />
	<cfset variables.Cache.Gateway = StructNew() />
	<cfset variables.Cache.Metadata = StructNew() />
	<cfset variables.Cache.Validator = StructNew() />
	<cfset variables.Cache.Dictionary = StructNew() />
	
	<cffunction name="init" access="public" hint="I configure the table factory." output="false" returntype="any" _returntype="reactor.core.objectFactory">
		<cfargument name="config" hint="I am a reactor config object" required="yes" type="any" _type="reactor.config.config" />
		<cfargument name="ReactorFactory" hint="I am the reactorFactory object." required="yes" type="any" _type="reactor.reactorFactory" />
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

		<!--- create the objectDao we'll use to read object data --->
		<cfset variables.ObjectDao = CreateObject("Component", "reactor.data.#getConfig().getType()#.ObjectDao").init(getConfig().getDsn(), getConfig().getUsername(), getConfig().getPassword()) />

		<cfreturn this />
	</cffunction>
	
	<cffunction name="compile" access="public" hint="I create all of the default reactor object types (but not plugins) so as to compile all objects according to the current configuration options" output="false" returntype="void">
		<cfset var objectNames = getConfig().getObjectNames() />
		<cfset var x = 0 />
		
		<!--- note the current config mode --->
		<cfset var mode = getConfig().getMode() />
		
		<!--- force to development mode --->
		<cfset getConfig().setMode("Development") />
		
		<!--- generate the base object types --->
		<cfloop from="1" to="#ArrayLen(objectNames)#" index="x">
			<cflog text="Reactor: Compiling #objectNames[x]# objects" />
			<cfset create(objectNames[x], "Record") />
			<cfset create(objectNames[x], "Dao") />
			<cfset create(objectNames[x], "To") />
			<cfset create(objectNames[x], "Gateway") />
			<cfset create(objectNames[x], "Metadata") />
			<cfset createDictionary(objectNames[x]) />
			<cfset create(objectNames[x], "Validator") />
		</cfloop>
		
		<!--- reset the mode --->
		<cfset getConfig().setMode(mode) />
	</cffunction>

	<cffunction name="create" access="public" hint="I create and return an object for a specific table." output="false" returntype="any" _returntype="any">
		<cfargument name="alias" hint="I am the alias of the object to create an object for." required="yes" type="any" _type="string" />
		<cfargument name="type" hint="I am the type of object to create.  Options are: To, Dao, Gateway, Record, Metadata, Validator unless this is a plugin." required="yes" type="any" _type="string" />
		<cfargument name="plugin" hint="I indicate if this is creating a plugin" required="no" type="any" _type="boolean" default="false" />
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
			
			<cfif compareNocase(getConfig().getMode(), "always") is 0>
				<!--- we always need the db object to transform --->
				<cfset DbObject = getObject(arguments.alias) />
				<cfset generate = true />
		
			<cfelseif compareNocase(getConfig().getMode(), "development") is 0>			
				<!--- we always need the db object to compare to our existing object --->
				<cfset DbObject = getObject(arguments.alias) />
				
				<cftry>
					<!--- create an instance of the object and check its signature --->
					<cfset GeneratedObject = createGeneratedObject("Component", getObjectDetails(arguments.type, arguments.alias, arguments.plugin).dbms) />
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
							<cfset GeneratedObject = createGeneratedObject("Component", getObjectDetails(arguments.type, arguments.alias, arguments.plugin).dbms) />
							<cfset variables.Cache[arguments.type][arguments.alias] = GeneratedObject />
						</cfif>

					<cfelse>

						<!--- we never cache Record, To or iterator objects --->
						<cfset GeneratedObject = createGeneratedObject("Component", getObjectDetails(arguments.type, arguments.alias, arguments.plugin).dbms) />

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
			<cfset ObjectTranslator = createGeneratedObject("Component", "reactor.core.objectTranslator").init(getConfig(), DbObject, this) />
					
			<cfset ObjectTranslator.generateObject(arguments.type, arguments.plugin) />	
			
			<cfif ListFind("Dao,Gateway,Record", arguments.type) OR arguments.plugin>
				<!--- check to see if a metadata object of this type exists.  If not, create it --->
				<cfif StructKeyExists(variables.Cache.metadata, arguments.alias)>
					<cfset metadata = variables.Cache.metadata[arguments.alias] />
				<cfelse> 
					<cfset metadata = create(arguments.alias, "Metadata") />
				</cfif>
			
				<cfset GeneratedObject = createGeneratedObject("Component", getObjectDetails(arguments.type, arguments.alias, arguments.plugin).dbms)._configure(getConfig(), arguments.alias, getReactorFactory(), getConvention(), metadata) />
			<cfelse>
				<cfset GeneratedObject = createGeneratedObject("Component", getObjectDetails(arguments.type, arguments.alias, arguments.plugin).dbms)._configure(getConfig(), arguments.alias, getReactorFactory(), getConvention()) />
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
		
		<cfset ObjectTranslator = 0 />
		<cfset DbObject = 0 />
		
		<cfreturn GeneratedObject />
	</cffunction>

	<cffunction name="createGeneratedObject" access="private" returntype="any" output="false" hint="I check for any injectors for this object">
		<cfargument name="objectType">
		<cfargument name="objectPath">	
			<cfset var bi = "">
			<cfset var BeanName = ListGetAt(objectPath,ListLen(objectPath,"."), ".")>
			<cfset var r_Bean = CreateObject(objectType,objectPath)>
			<cfset var lBeans = "">
			<cfset var lb = "">
			<!--- In case there is no BeanFactory --->
			<cfif NOT isObject(variables.BeanFactory)>
				<cfreturn r_Bean />
			</cfif>
			
			<!--- Here we inject any dependencies as defined in the injector --->
			<cfloop array="#variables.BeanFactory.findAllBeanNamesByType("reactor.core.Injector")#" index="bi">
				<cfset injector = variables.BeanFactory.getBean(bi)>
				<cfif injector.isTarget(BeanName)>
						<cfset lBeans = injector.getBeans()>
						<cfloop list="#lBeans#" index="lb">
							<cfset r_Bean._setInjectedBean(lb,variables.BeanFactory.getBean(lb))>
						</cfloop>
				</cfif>
			</cfloop>
		
		<cfreturn r_Bean>
	</cffunction>


	<cffunction name="createDictionary" access="public" hint="I create and return a dictionary object for a specific table." output="false" returntype="any" _returntype="reactor.dictionary.dictionary">
		<cfargument name="alias" hint="I am the alias of the object to create an object for." required="yes" type="any" _type="string" />
		<cfset var DbObject = 0 />
		<cfset var generate = false />
		<cfset var DictionaryObject = 0 />
		<cfset var tempmapping = "/" & Replace(getMapping(), ".", "/", "all") />
		<cfset var dictionaryXmlPath = "#tempmapping#/Dictionary/#arguments.alias#dictionary.xml" />
		<cfset var ObjectTranslator = 0 />
		
		<cftry>
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
	
	<cffunction name="getObject" access="public" hint="I read and return a reactor.core.object object for a specific db object." output="false" returntype="any" _returntype="reactor.core.object">
		<cfargument name="name" hint="I am the name of the object to translate." required="yes" type="any" _type="string" />
		<cfset var Object = 0 />
		
		<!---
			this is a bit of a hack.  See, within one request we might need to hit the DB several times to get the same config settings for one object.
			we only want to hit the db once per that request.  So, I'm using *shock* a request variable right here in a CFC.  Deal with it!
		--->
		<cfparam name="request.reactor.Object" default="#StructNew()#" />
		
		<cfif NOT StructKeyExists(request.reactor.Object, arguments.name)>
			<cfset Object = CreateObject("Component", "reactor.core.object").init(arguments.name, getConfig()) />
		
			<!--- read the object --->
			<cfset variables.ObjectDao.read(Object) />
			
			<cfset request.reactor.Object[arguments.name] = Object />
		<cfelse>
			<cfset Object = request.reactor.Object[arguments.name] />
		</cfif>
		
		<!--- return the object --->
		<cfreturn Object />
	</cffunction>
	
	<cffunction name="getObjectDetails" access="private" hint="I return a structure of the correct name of the a object based on it's type and other configurations" output="false" returntype="any" _returntype="struct">
		<cfargument name="type" hint="I am the type of object to return.  Options are: record, dao, gateway, to" required="yes" type="any" _type="string" />
		<cfargument name="name" hint="I am the name of the object to return." required="yes" type="any" _type="string" />
		<cfargument name="plugin" hint="I indicate if this is creating a plugin" required="yes" type="any" _type="boolean" />
		<cfset var result = StructNew() />
		
		<!--- get the dbms-specific custom file first --->
		<cfset result.dbms = getMapping(arguments.name) & Iif(arguments.plugin, De(".plugins"), De("")) & "." & arguments.type & "." & arguments.name & arguments.type & getConfig().getType() />
		<cfset result.custom = getMapping(arguments.name) & Iif(arguments.plugin, De(".plugins"), De("")) & "." & arguments.type & "." & arguments.name & arguments.type />
		<cfset result.project = "reactor.project." & getConfig().getProject() & "." & arguments.type & "." & arguments.name & arguments.type />
		
		<!--- insure all three paths exists --->
		<cfif NOT componentExists(result.dbms)>
			<cfthrow type="reactor.objectFactory.getObjectDetails.NotAllFilesExist" />
		<cfelseif NOT componentExists(result.custom)>
			<cfthrow type="reactor.objectFactory.getObjectDetails.NotAllFilesExist" />
		<cfelseif NOT componentExists(result.project)>
			<cfthrow type="reactor.objectFactory.getObjectDetails.NotAllFilesExist" />
		</cfif>
		
		<cfreturn result />		
	</cffunction>
	
	<cffunction name="componentExists" access="private" hint="I indicate if a component exists" output="false" returntype="any" _returntype="boolean">
		<cfargument name="name" hint="I am the name of the component in dot noted formated" required="yes" type="any" _type="string" />
		<cfset var absPath = ExpandPath("/" & replace(arguments.name, ".", "/", "all") & ".cfc") />
		
		<cfreturn FileExists(absPath) />
	</cffunction>
	
	<cffunction name="getMapping" access="private" hint="I get and add a / in front of mappings" output="false" returntype="any" _returntype="string">
		<cfargument name="alias" hint="I am an optional alias of an object.  The object will be checked for its own custom mapping." required="no" type="any" _type="string" default="" />
		<cfset var mapping = getConfig().getMapping(arguments.alias) />
		
		<cfreturn replaceNoCase(right(mapping, Len(mapping) - 1), "/", ".", "all") />
	</cffunction>
	
	
	<!--- config --->
  <cffunction name="setConfig" access="public" output="false" returntype="void">
     <cfargument name="config" hint="I am the config object used to configure reactor" required="yes" type="any" _type="reactor.config.config" />
     <cfset variables.config = arguments.config />
  </cffunction>
  <cffunction name="getConfig" access="public" output="false" returntype="any" _returntype="reactor.config.config">
     <cfreturn variables.config />
  </cffunction>
	
	<!--- reactorFactory --->
  <cffunction name="setReactorFactory" access="private" output="false" returntype="void">
     <cfargument name="reactorFactory" hint="I am the reactorFactory object" required="yes" type="any" _type="reactor.reactorFactory" />
     <cfset variables.reactorFactory = arguments.reactorFactory />
  </cffunction>
  <cffunction name="getReactorFactory" access="private" output="false" returntype="any" _returntype="reactor.reactorFactory">
     <cfreturn variables.reactorFactory />
  </cffunction>

  <!--- BeanFactory --->
  <cffunction name="setBeanFactory" access="public" output="false" returntype="void" hint="I set a BeanFactory (Spring-interfaced IoC container) to inject into all created objects)." >
  	<cfargument name="beanFactory" type="any" _type="any" required="true" />
  	<cfset variables.BeanFactory = arguments.beanFactory />
  </cffunction>
	
	<!--- convention --->
  <cffunction name="setConvention" access="private" output="false" returntype="void">
     <cfargument name="convention" hint="I am a convention object" required="yes" type="any" _type="reactor.data.abstractConvention" />
     <cfset variables.convention = arguments.convention/>
  </cffunction>
  <cffunction name="getConvention" access="private" output="false" returntype="any" _returntype="reactor.data.abstractConvention">
     <cfreturn variables.convention />
  </cffunction>
	
	<!--- pluginList --->
  <cffunction name="setPluginList" access="private" output="false" returntype="void">
     <cfargument name="pluginList" hint="I am a list of avaliable plugins" required="yes" type="any" _type="string" />
     <cfset variables.pluginList = arguments.pluginList />
  </cffunction>
  <cffunction name="getPluginList" access="private" output="false" returntype="any" _returntype="string">
     <cfreturn variables.pluginList />
  </cffunction>
	
</cfcomponent>
