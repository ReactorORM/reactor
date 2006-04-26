<cfcomponent hint="I am the object factory.">
	
	<cfset variables.config = "" />
	<cfset variables.ReactorFactory = "" />
	<cfset variables.TimedCache = CreateObject("Component", "reactor.util.TimedCache").init(createTimeSpan(0, 0, 0, 5)) />
	
	<cffunction name="init" access="public" hint="I configure the table factory." output="false" returntype="reactor.core.objectFactory">
		<cfargument name="config" hint="I am a reactor config object" required="yes" type="reactor.config.config" />
		<cfargument name="ReactorFactory" hint="I am the reactorFactory object." required="yes" type="reactor.reactorFactory" />
		
		<cfset setConfig(arguments.config) />
		<cfset setReactorFactory(arguments.ReactorFactory) />
		<cfset setConvention(CreateObject("Component", "reactor.data.#arguments.config.getType()#.Convention")) />

		<cfreturn this />
	</cffunction>

	<cffunction name="create" access="public" hint="I create and return an object for a specific table." output="false" returntype="reactor.base.abstractObject">
		<cfargument name="alias" hint="I am the alias of the object to create an object for." required="yes" type="string" />
		<cfargument name="type" hint="I am the type of object to create.  Options are: To, Dao, Gateway, Record, Metadata, Validator" required="yes" type="string" />
		<cfset var DbObject = 0 />
		<cfset var GeneratedObject = 0 />
		<cfset var generate = false />
		<cfset var objectTranslator = 0 />
		<cfset var objName = "" />
		
		<cfif NOT ListFind("Record,Dao,Gateway,To,Metadata,Validator", arguments.type)>
			<cfthrow type="reactor.InvalidObjectType"
				message="Invalid Object Type"
				detail="The type argument must be one of: Record, Dao, Gateway, To, Metadata, Validator" />
		</cfif>
		
		<cftry>
			<cfswitch expression="#getConfig().getMode()#">
				<cfcase value="always">
					<!--- we always need the db object to transform --->
					<cfset DbObject = getObject(arguments.alias) />
					<cfset generate = true />
				</cfcase>
				<cfcase value="development">
					<!--- we always need the db object to compare to our existing object --->
					<cfset DbObject = getObject(arguments.alias) />
					<cftry>
						<!--- create an instance of the object and check its signature --->
						<cfset GeneratedObject = CreateObject("Component", getObjectName(arguments.type, arguments.alias)) />
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
				</cfcase>
				<cfcase value="production">
					<cftry>
						<cfset objName = getObjectName(arguments.type, arguments.alias) />

						<!--- get an instance of the object from cache or create it --->
						<cfif listFind("Dao,Gateway,Metadata,Validator",arguments.type)>

							<cfif variables.TimedCache.exists(objName)>
								<cftry>
									<cfset GeneratedObject = variables.TimedCache.getValue(objName) />
									<cfcatch/>
								</cftry>
							</cfif>

							<cfif not isObject(GeneratedObject)>
								<cfset GeneratedObject = CreateObject("Component", objName) />
								<cfset variables.TimedCache.setValue(objName, GeneratedObject) />
							</cfif>

						<cfelse>

							<!--- we never cache Record, To or iterator objects --->
							<cfset GeneratedObject = CreateObject("Component", objName) />
	
						</cfif>
						<cfcatch>
							<!--- we only need the dbobject if it doesn't already exist --->
							<cfset DbObject = getObject(arguments.alias) />
							<cfset generate = true />
						</cfcatch>
					</cftry>
				</cfcase>
			</cfswitch>
			
			<cfcatch type="Reactor.NoSuchObject">
				<cfthrow type="Reactor.NoSuchObject" message="Object '#arguments.alias#' does not exist." detail="Reactor was unable to find an object in the database with the name '#arguments.alias#.'" />
			</cfcatch>
		</cftry>

		<!--- return either a generated object or the existing object --->
		<cfif generate>

			<cfset ObjectTranslator = CreateObject("Component", "reactor.core.objectTranslator").init(getConfig(), DbObject, this) />
			
			<cfset ObjectTranslator.generateObject(arguments.type) />	
			
			<cfset GeneratedObject = CreateObject("Component", getObjectName(arguments.type, arguments.alias)).configure(getConfig(), arguments.alias, getReactorFactory(), getConvention()) />

		<cfelse>

			<cfset GeneratedObject = GeneratedObject.configure(getConfig(), arguments.alias, getReactorFactory(), getConvention()) />
			
		</cfif>
		
		<cfreturn GeneratedObject />
	</cffunction>

	<cffunction name="createDictionary" access="public" hint="I create and return a dictionary object for a specific table." output="false" returntype="reactor.dictionary.dictionary">
		<cfargument name="alias" hint="I am the alias of the object to create an object for." required="yes" type="string" />
		<cfset var DbObject = 0 />
		<cfset var generate = false />
		<cfset var DictionaryObject = 0 />
		<cfset var dictionaryXmlPath = "#getConfig().getMapping()#/Dictionary/#arguments.alias#dictionary.xml" />
		<cfset var ObjectTranslator = 0 />
		
		<cftry>
			<cfswitch expression="#getConfig().getMode()#">
				<cfcase value="production">
					<cftry>
						<!--- get an instance of the object from cache or create it --->
						<cfif variables.TimedCache.exists(dictionaryXmlPath)>
							<cftry>
								<cfset DictionaryObject = variables.TimedCache.getValue(dictionaryXmlPath) />
								<cfcatch/>
							</cftry>
						</cfif>

						<cfif not isObject(DictionaryObject)>
							<cfset DictionaryObject = CreateObject("Component", "reactor.dictionary.dictionary").init(dictionaryXmlPath) />
							<cfset variables.TimedCache.setValue(dictionaryXmlPath, DictionaryObject) />
						</cfif>

						<cfcatch>
							<!--- we only need the dbobject if it doesn't already exist --->
							<cfset DbObject = getObject(arguments.alias) />
							<cfset generate = true />
						</cfcatch>
					</cftry>
				</cfcase>
				<cfdefaultcase>
					<!--- we always need the db object to update the xml --->
					<cfset DbObject = getObject(arguments.alias) />
					<cfset generate = true />
				</cfdefaultcase>
			</cfswitch>
			
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
	
	<cffunction name="getObject" access="private" hint="I read and return a reactor.core.object object for a specific db object." output="false" returntype="reactor.core.object">
		<cfargument name="name" hint="I am the name of the object to translate." required="yes" type="string" />
		<cfset var Object = 0 />
		<cfset var ObjectDao = 0/>
		
		<!--- check for a cached version of the object --->
		<cfif variables.TimedCache.exists(arguments.name)>
			<cftry>
				<!--- try to get the object --->
				<cfset Object = variables.TimedCache.getValue(arguments.name) />
				<!--- refresh the object in cache --->
				<cfset variables.TimedCache.setValue(arguments.name,Object) />
				<cfcatch/>
			</cftry>
		</cfif>
		
		<!--- if the object isn't an object then it wasn't cached and we need to create a new one --->
		<cfif NOT IsObject(Object)>
			<cfset Object = CreateObject("Component", "reactor.core.object").init(arguments.name, getConfig()) />
			<cfset variables.TimedCache.setValue(arguments.name,Object) />
			<cfset ObjectDao = CreateObject("Component", "reactor.data.#getConfig().getType()#.ObjectDao").init(getConfig().getDsn(), getConfig().getUsername(), getConfig().getPassword()) />
			
			<!--- read the object --->
			<cfset ObjectDao.read(Object) />
		</cfif>
		
		<!--- return the object --->
		<cfreturn Object />
	</cffunction>
	
	<cffunction name="getObjectName" access="private" hint="I return the correct name of the a object based on it's type and other configurations" output="false" returntype="string">
		<cfargument name="type" hint="I am the type of object to return.  Options are: record, dao, gateway, to" required="yes" type="string" />
		<cfargument name="name" hint="I am the name of the object to return." required="yes" type="string" />
		<cfset var creationPath = "" />
		
		<!--- if the user doesn't have a leading slash on their mapping then add one --->
		<cfif left(getConfig().getMapping(), 1) IS NOT "/">
			<cfset getConfig().setMapping("/" & getConfig().getMapping()) />
		</cfif>
		
		<cfset creationPath = replaceNoCase(right(getConfig().getMapping(), Len(getConfig().getMapping()) - 1), "/", ".", "all") />
				
		<cfreturn creationPath & "." & arguments.type & "." & arguments.name & arguments.type & getConfig().getType()  />
	</cffunction>
	
	<!--- config --->
    <cffunction name="setConfig" access="public" output="false" returntype="void">
       <cfargument name="config" hint="I am the config object used to configure reactor" required="yes" type="reactor.config.config" />
       <cfset variables.config = arguments.config />
    </cffunction>
    <cffunction name="getConfig" access="public" output="false" returntype="reactor.config.config">
       <cfreturn variables.config />
    </cffunction>
	
	<!--- reactorFactory --->
    <cffunction name="setReactorFactory" access="private" output="false" returntype="void">
       <cfargument name="reactorFactory" hint="I am the reactorFactory object" required="yes" type="reactor.reactorFactory" />
       <cfset variables.reactorFactory = arguments.reactorFactory />
    </cffunction>
    <cffunction name="getReactorFactory" access="private" output="false" returntype="reactor.reactorFactory">
       <cfreturn variables.reactorFactory />
    </cffunction>

	<!--- convention --->
    <cffunction name="setConvention" access="private" output="false" returntype="void">
       <cfargument name="convention" hint="I am a convention object" required="yes" type="reactor.data.abstractConvention" />
       <cfset variables.convention = arguments.convention/>
    </cffunction>
    <cffunction name="getConvention" access="private" output="false" returntype="reactor.data.abstractConvention">
       <cfreturn variables.convention />
    </cffunction>
	
</cfcomponent>