<cfcomponent hint="I am a bean used to encapsulate Reactor's configuration.">

	<cfset variables.configXml = "" />
	<cfset variables.project = "" />
	<cfset variables.dsn = "" />
	<cfset variables.Type = "" />
	<cfset variables.mapping = "" />
	<cfset variables.mode = "" />
	<cfset variables.username = "" />
	<cfset variables.password = "" />
	<cfset variables.objectMap = structNew() />
	
	<cffunction name="init" access="public" hint="I configure this config bean." output="false" returntype="reactor.config.config">
		<cfargument name="pathToConfigXml" hint="I am the path to the config XML file." required="yes" type="string" />
		<cfset var xml = 0 />

		<!--- attempt to expand the path to config --->
		<cfif FileExists(expandPath(arguments.pathToConfigXml))>
			<cfset arguments.pathToConfigXml = expandPath(arguments.pathToConfigXml) />
		</cfif>

		<cfif NOT FileExists(arguments.pathToConfigXml)>
			<cfthrow type="reactor.config.InvalidPathToConfig"
				message="Invalid Path To Config"
				detail="The path #arguments.pathToConfigXml# does not exist." />
		</cfif>

		<!--- read and parse the xml --->
		<cffile action="read" file="#arguments.pathToConfigXml#" variable="xml" />
		<cfset xml = XMLParse(xml) />

		<!--- load the basic configuration settings --->
		<cfset loadConfig(xml) />

		<!--- load this file's objects --->
		<cfset addObjectsFromXml(xml) />

		<cfreturn this />
	</cffunction>
	
	<!--- addObjects --->
	<cffunction name="addObjects" returntype="void" access="public" output="false" hint="I add more Reactor objects to the configuration.">
		<cfargument name="objectXmlFile" type="string" required="true" hint="I am the path to the config XML file to be added." />
		<cfset var xml = 0 />

		<!--- attempt to expand the path to config --->
		<cfif fileExists(expandPath(arguments.objectXmlFile))>
			<cfset arguments.objectXmlFile = expandPath(arguments.objectXmlFile) />
		</cfif>

		<cfif not fileExists(arguments.objectXmlFile)>
			<cfthrow type="reactor.config.InvalidPathToConfig"
				message="Invalid Path To Config"
				detail="The path #arguments.objectXmlFile# does not exist." />
		</cfif>

		<!--- read and parse the xml --->
		<cffile action="read" file="#arguments.objectXmlFile#" variable="xml" />
		<cfset xml = XMLParse(xml) />
		
		<cfset addObjectsFromXml(xml) />
	</cffunction>
	
	<!--- addObjectsFromXml --->
	<cffunction name="addObjectsFromXml" returntype="void" access="private" output="false" hint="I add Reactor objects from an XML object.">
		<cfargument name="configXml" type="xml" required="true" hint="I am the XML object to be processed." />
		<cfset var objectsConfig = 0 />
		<cfset var objectConfig = ArrayNew(1) />
		<cfset var object = 0 />
		<cfset var x = 0 />

		<cfif StructKeyExists(arguments.configXml.reactor, "objects")>
			<cfset objectsConfig = arguments.configXml.reactor.objects />
		</cfif>

		<cfif IsXml(objectsConfig) AND ArrayLen(objectsConfig.XmlChildren)>
			<cfset objectConfig = objectsConfig.XmlChildren />
			
			<cfloop from="1" to="#ArrayLen(objectConfig)#" index="x">
				<cfset object = objectConfig[x] />
				
				<cfif NOT StructKeyExists(object.xmlAttributes, "alias")>
					<cfset object.xmlAttributes["alias"] = object.xmlAttributes.name />
				</cfif>
				
				<!--- check to see if the containing object tag has a mapping attribute.  if so, copy its value into this tag. --->
				<cfif StructKeyExists(objectsConfig.XmlAttributes, "mapping") AND NOT StructKeyExists(object.xmlAttributes, "mapping")>
					<cfset object.xmlAttributes["mapping"] = objectsConfig.XmlAttributes.mapping />
				</cfif>
				
				<cfset variables.objectMap[object.xmlAttributes.alias] = object />
			</cfloop>
		</cfif>
	</cffunction>

	<!--- loadConfig --->
	<cffunction name="loadConfig" access="private" hint="I read the basic config settings from the config xml." output="false" returntype="void">
		<cfargument name="configXml" hint="I am the raw configuration xml" required="yes" type="string" />
		<cfset var config = 0 />
		<cfset var x = 0 />

		<!--- load the config settings --->
		<cfset config = XMLSearch(arguments.configXml, "/reactor/config/*") />

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

	<cffunction name="getObjectConfig" access="public" output="false" returntype="string" hint="I return the base configuration for a particular object.  If the object is not explictly configure a default config is returned.">
		<cfargument name="alias" required="yes" type="string" hint="I am the alias of the object to get the configuration for" />
		<cfset var table = 0 />

		<cfif structKeyExists(variables.objectMap,arguments.alias)>
			<cfset table = variables.objectMap[arguments.alias] />
		<cfelse>
			<cfset table = "<object name=""#arguments.alias#"" alias=""#arguments.alias#"" />" />
		</cfif>

		<!--- return the base config --->
		<cfreturn xmlParse(toString(table)) />
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

		<cfif NOT ListFind("mssql,mysql,mysql4,postgresql,db2,oracle,oraclerdb,sqlanywhere", arguments.Type)>
			<cfthrow type="reactor.InvalidType"
				message="Invalid Type Setting"
				detail="The Type argument must be one of: mssql,mysql,mysql4,postgresql,db2,oracle,oraclerdb,sqlanywhere" />
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
		<cfargument name="alias" hint="I am an optional alias of an object.  The object will be checked for its own custom mapping." required="no" type="string" default="" />
		<cfset var mapping = variables.mapping />
		<cfset var object = 0 />
		
		<cfif Len(arguments.alias)>
			<cfset object = getObjectConfig(arguments.alias) />
			<cfif StructKeyExists(object.object.XmlAttributes, "mapping")>
				<cfset mapping = object.object.XmlAttributes.mapping />
			</cfif>
		</cfif>
		
		<cfreturn mapping />
    </cffunction>
    <cffunction name="getMappingObjectStem" access="public" output="false" returntype="string">
		<cfargument name="mapping" hint="I am the mapping to get the stem for." required="no" default="#getMapping()#" />
		<cfset var objectStem = ReReplaceNoCase(arguments.mapping, "/+", ".", "all") />

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

</cfcomponent>