<cfcomponent hint="I am a bean used to encapsulate Reactor's configuration.">
	
	<cfset variables.configXml = "" />
	<cfset variables.project = "" />
	<cfset variables.dsn = "" />
	<cfset variables.Type = "" />
	<cfset variables.mapping = "" />
	<cfset variables.mode = "" />
	<cfset variables.username = "" />
	<cfset variables.password = "" />
	
	<cffunction name="init" access="public" hint="I configure this config bean." output="false" returntype="reactor.config.config">
		<cfargument name="pathToConfigXml" hint="I am the path to the config XML file." required="yes" type="string" />
		<cfset var xml = 0 />
		
		<!--- attempt to expand the path to config --->
		<cfif FileExists(expandPath(arguments.pathToConfigXml))>
			<cfset arguments.pathToConfigXml = expandPath(arguments.pathToConfigXml) />
		</cfif>
				
		<!--- read and parse the xml --->
		<cffile action="read" file="#arguments.pathToConfigXml#" variable="xml" />
		<cfset xml = XMLParse(xml) />
		
		<!--- set the config xml into this object's instance data --->
		<cfset setConfigXml(xml) />
		
		<!--- load the basic configuration settings --->
		<cfset loadConfig() />
		
		<cfreturn this />
	</cffunction>
	
	<!--- loadConfig --->
	<cffunction name="loadConfig" access="private" hint="I read the basic config settings from the config xml." output="false" returntype="void">
		<cfset var config = 0 />
		<cfset var x = 0 />
		
		<!--- load the config settings --->
		<cfset config = XMLSearch(getConfigXml(), "/reactor/config/*") />
		
		<cfloop from="1" to="#ArrayLen(config)#" index="x">
			<cfswitch expression="#config[x].XmlName#">
				<cfcase value="project">
					<cfset setProject(config[x].XmlAttributes.Value) />
				</cfcase>
				<cfcase value="dsn">
					<cfset setDsn(config[x].XmlAttributes.Value) />
				</cfcase>
				<cfcase value="type">
					<cfset setType(config[x].XmlAttributes.Value) />
				</cfcase>
				<cfcase value="mapping">
					<cfset setMapping(config[x].XmlAttributes.Value) />
				</cfcase>
				<cfcase value="mode">
					<cfset setMode(config[x].XmlAttributes.Value) />
				</cfcase>
				<cfcase value="username">
					<cfset setUsername(config[x].XmlAttributes.Value) />
				</cfcase>
				<cfcase value="password">
					<cfset setPassword(config[x].XmlAttributes.Value) />
				</cfcase>
			</cfswitch>
		</cfloop>
	</cffunction>
	
	<!--- getObjectConfig --->
	<cffunction name="getObjectConfig" access="public" hint="I return the base configuration for a particular object.  If the object is not explictly configure a default config is returned." output="false" returntype="string">
		<cfargument name="object" hint="I am the object to get the configuration for" required="yes" type="string" />
		<cfset var configXml = getConfigXml() />
		<cfset var tableConfig = XmlSearch(configXml, "/reactor/objects/object") />
		<cfset var table = 0 />
		<cfset var x = 0 />
		
		<!--- if a matching element is found then convert it to be it's own document.  Otherwise create a new document. --->
		<cfif ArrayLen(tableConfig)>
			<cfloop from="1" to="#ArrayLen(tableConfig)#" index="x">
				<cfif tableConfig[x].XmlAttributes.name IS arguments.object>
					<cfset table = tableConfig[x] />
					<cfbreak />
				</cfif>
			</cfloop>
		</cfif>
		
		<cftry>
			<cfset table = XmlParse(ToString(table)) />
			<cfcatch>
				<cfset table = XmlParse("<object name=""#arguments.object#"" />") />
			</cfcatch>
		</cftry>
		
		<!--- return the base config --->
		<cfreturn table />
	</cffunction>
	
	<!--- dsn --->
    <cffunction name="setDsn" access="public" output="false" returntype="void">
       <cfargument name="dsn" hint="I am the DSN to connect to." required="yes" type="string" />
       <cfset variables.dsn = arguments.dsn />
    </cffunction>
    <cffunction name="getDsn" access="public" output="false" returntype="string">
       <cfreturn variables.dsn />
    </cffunction>
	
	<!--- Type --->
	<cffunction name="setType" access="public" output="false" returntype="void">
		<cfargument name="Type" hint="I am the type of database the dsn is for" required="yes" type="string" />
		
		<cfif NOT ListFind("mssql,mysql,mysql4", arguments.Type)>
			<cfthrow type="reactor.InvalidType"
				message="Invalid Type Setting"
				detail="The Type argument must be one of: mssql,mysql,mysql4" />
		</cfif>
		
		<cfset variables.Type = arguments.Type />
    </cffunction>
    <cffunction name="getType" access="public" output="false" returntype="string">
       <cfreturn lcase(variables.Type) />
    </cffunction>
	
	<!--- mapping --->
    <cffunction name="setMapping" access="public" output="false" returntype="void">
		<cfargument name="mapping" hint="I am a mapping to the location where objects are created." required="yes" type="string" />
		
		<cfif NOT DirectoryExists(expandPath(arguments.mapping))>
			<cfthrow type="reactor.Invalidmapping"
				message="Invalid Mapping Setting"
				detail="The mapping argument must be a mapping to a directory which exists." />
		</cfif>
		
		<cfset variables.mapping = arguments.mapping />
    </cffunction>
    <cffunction name="getMapping" access="public" output="false" returntype="string">
       <cfreturn variables.mapping />
    </cffunction>
    <cffunction name="getMappingObjectStem" access="public" output="false" returntype="string">
		<cfset var objectStem = ReReplaceNoCase(getMapping(), "/+", ".", "all") />

		<cfif Left(objectStem, 1) IS ".">
			<cfset objectStem = Right(objectStem, Len(objectStem) - 1) />
		</cfif>
		
		<cfreturn objectStem />
    </cffunction>
	
	<!--- mode --->
    <cffunction name="setMode" access="public" output="false" returntype="void">
		<cfargument name="mode" hint="I am the mode in which the system is running.  Options are: development, production" required="yes" type="string" />
		
		<cfif NOT ListFindNoCase("development,production,always", arguments.mode)>
			<cfthrow type="reactor.InvalidMode"
				message="Invalid Mode Setting"
				detail="The mode argument must be one of: development, production, always" />
		</cfif>
		
		<cfset variables.mode = arguments.mode />
    </cffunction>
    <cffunction name="getMode" access="public" output="false" returntype="string">
       <cfreturn variables.mode />
    </cffunction>
	
	<!--- project --->
    <cffunction name="setProject" access="public" output="false" returntype="void">
       <cfargument name="project" hint="I am the name of the project." required="yes" type="string" />
       <cfset variables.project = ReReplace(arguments.project, "[\W]", "", "all") />
    </cffunction>
    <cffunction name="getProject" access="public" output="false" returntype="string">
       <cfreturn variables.project />
    </cffunction>
	
	<!--- username --->
    <cffunction name="setUsername" access="public" output="false" returntype="void">
       <cfargument name="username" hint="I am the username to use for DSNs" required="yes" type="string" />
       <cfset variables.username = arguments.username />
    </cffunction>
    <cffunction name="getUsername" access="public" output="false" returntype="string">
       <cfreturn variables.username />
    </cffunction>
	
	<!--- password --->
    <cffunction name="setPassword" access="public" output="false" returntype="void">
       <cfargument name="password" hint="I am the password to use for DSNs" required="yes" type="string" />
       <cfset variables.password = arguments.password />
    </cffunction>
    <cffunction name="getPassword" access="public" output="false" returntype="string">
       <cfreturn variables.password />
    </cffunction>
	
	<!--- configXml --->
    <cffunction name="setConfigXml" access="private" output="false" returntype="void">
       <cfargument name="configXml" hint="I am the raw configuration xml" required="yes" type="string" />
       <cfset variables.configXml = arguments.configXml />
    </cffunction>
    <cffunction name="getConfigXml" access="private" output="false" returntype="string">
       <cfreturn variables.configXml />
    </cffunction>
	
</cfcomponent>


		