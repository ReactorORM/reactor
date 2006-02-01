<cfcomponent hint="I am the object factory.">
	
	<cfset variables.config = "" />
	<cfset variables.ReactorFactory = "" />
	<cfset variables.TimedCache = CreateObject("Component", "reactor.util.TimedCache").init(createTimeSpan(0, 0, 0, 5)) />
	
	<cffunction name="init" access="public" hint="I configure the table factory." output="false" returntype="reactor.core.objectFactory">
		<cfargument name="config" hint="I am a reactor config object" required="yes" type="reactor.config.config" />
		<cfargument name="ReactorFactory" hint="I am the reactorFactory object." required="yes" type="reactor.reactorFactory" />
		
		<cfset setConfig(arguments.config) />
		<cfset setReactorFactory(arguments.ReactorFactory) />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="create" access="public" hint="I create and return an object for a specific table." output="false" returntype="reactor.base.abstractObject">
		<cfargument name="name" hint="I am the name of the table create an object for." required="yes" type="string" />
		<cfargument name="type" hint="I am the type of object to create.  Options are: To, Dao, Gateway, Record, Metadata" required="yes" type="string" />
		<cfset var DbObject = 0 />
		<cfset var DbObjectDao = 0 />
		<cfset var GeneratedObject = 0 />
		<cfset var generate = false />
		<cfset var objectTranslator = 0 />
		
		<!--- if we don't have a cached version of this object create one --->
		<cfif NOT variables.TimedCache.exists(arguments.name)>
			<!--- create and load a reactor.core.object object --->
			<cfset variables.TimedCache.setValue(arguments.name, getObject(arguments.name), createTimeSpan(0, 0, 0, 8)) />
		</cfif>
		
		<!--- get the cached object --->
		<cftry>
			<cfset DbObject = variables.TimedCache.getValue(arguments.name) />
			<cfcatch>
				<!--- it's possible that the cache timed out between when we checked to see if it existed and now --->
				<cfset DbObject = getObject(arguments.name) />
			</cfcatch>
		</cftry>
				
		<cfif NOT ListFindNoCase("record,dao,gateway,to,metadata", arguments.type)>
			<cfthrow type="reactor.InvalidObjectType"
				message="Invalid Object Type"
				detail="The type argument must be one of: record, dao, gateway, to, metadata" />
		</cfif>
		
		<cftry>
			<cfswitch expression="#getConfig().getMode()#">
				<cfcase value="always">
					<cfset generate = true />
				</cfcase>
				<cfcase value="development">
					<cftry>
						<!--- create an instance of the object and check its signature --->
						<cfset GeneratedObject = CreateObject("Component", getObjectName(arguments.type, arguments.name)) />
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
						<!--- create an instance of the object and check it's signature --->
						<cfset GeneratedObject = CreateObject("Component", getObjectName(arguments.type, arguments.name)) />
						<cfcatch>
							<cfset generate = true />
						</cfcatch>
					</cftry>
				</cfcase>
			</cfswitch>
			
			<cfcatch type="Reactor.NoSuchObject">
				<cfthrow type="Reactor.NoSuchObject" message="Object '#arguments.name#' does not exist." detail="Reactor was unable to find an object in the database with the name '#arguments.name#.'" />
			</cfcatch>
		</cftry>
		
		<!--- return either a generated object or the existing object --->
		<cfif generate>
			<cfset ObjectTranslator = CreateObject("Component", "reactor.core.objectTranslator").init(getConfig(), DbObject, this) />
			
			<cfset ObjectTranslator.generateObject(arguments.type) />	
			
			<cfset GeneratedObject = CreateObject("Component", getObjectName(arguments.type, arguments.name)).configure(getConfig(), arguments.name, getReactorFactory()) />

		<cfelse>
			<cfset GeneratedObject = GeneratedObject.configure(getConfig(), arguments.name, getReactorFactory()) />

		</cfif>
		
		<cfreturn GeneratedObject />
	</cffunction>
	
	<cffunction name="getObject" access="private" hint="I read and return a reactor.core.object object for a specific db object." output="false" returntype="reactor.core.object">
		<cfargument name="name" hint="I am the name of the object to translate." required="yes" type="string" />
		<cfset var Object = CreateObject("Component", "reactor.core.object").init(arguments.name, getConfig()) />
		<cfset var ObjectDao = CreateObject("Component", "reactor.data.#getConfig().getType()#.ObjectDao").init(getConfig().getDsn(), getConfig().getUsername(), getConfig().getPassword()) />		
		
		<cfset ObjectDao.read(Object) />
		
		<cfreturn Object />
	</cffunction>
	
	<cffunction name="getObjectName" access="private" hint="I return the correct name of the a object based on it's type and other configurations" output="false" returntype="string">
		<cfargument name="type" hint="I am the type of object to return.  Options are: record, dao, gateway, to" required="yes" type="string" />
		<cfargument name="name" hint="I am the name of the object to return." required="yes" type="string" />
		<!--- <cfargument name="base" hint="I indicate if the base object name should be returned.  If false, the custom is returned." required="no" type="boolean" default="false" /> --->
		<cfset var creationPath = replaceNoCase(right(getConfig().getMapping(), Len(getConfig().getMapping()) - 1), "/", ".", "all") />
		
		<cfset arguments.type = lcase(arguments.type) />
		
		<!---<cfdump var="#arguments.type#" />
		<cfdump var="#arguments.name#" />
		<cfabort>--->
		
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
	
</cfcomponent>