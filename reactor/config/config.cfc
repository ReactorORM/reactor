<cfcomponent hint="I am a bean used to encapsulate Reactor's configuration.">

	<cfset variables.configXml = "" />
	<cfset variables.project = "" />
	<cfset variables.dsn = "" />
	<cfset variables.Type = "" />
	<cfset variables.mapping = "" />
	<cfset variables.mode = "" />
	<cfset variables.username = "" />
	<cfset variables.password = "" />
	<cfset variables.objectMap = StructNew() />
	<cfset variables.parsedObjectMap = StructNew()>
	<!--- this variables holds loaded reactor configuration files --->
	<cfset variables.loadedFiles = ArrayNew(1) />
	
	<cfset this.DBTYPES = "mssql,mysql,mysql4,postgresql,db2,oracle,oraclerdb,sqlanywhere,informix,hibernate">
	
	<cffunction name="init" access="public" hint="I configure this config bean." output="false" returntype="any" _returntype="reactor.config.config">
		<cfargument name="pathToConfigXml" hint="I am the path to the config XML file." required="yes" type="any" _type="string" />
		<!--- validate and parse the xml file. --->
		<cfset var xmlObject = validateAndParseXML( arguments.pathToConfigXml ) />
		
		<!--- load the basic configuration settings --->
		<cfset loadConfig( xmlObject ) />

		<!--- load this file's objects --->
		<cfset addObjectsFromXml( xmlObject ) />

		<cfreturn this />
	</cffunction>
	
	<!--- getObjectNames --->
	<cffunction name="getObjectNames" returntype="any" _returntype="array" access="public" output="false" hint="I return an array of all configured object names.">
		<cfreturn StructKeyArray(variables.objectMap) />
	</cffunction>
	
	<!--- addObjects --->
	<cffunction name="addObjects" returntype="void" access="public" output="false" hint="I add more Reactor objects to the configuration.">
		<cfargument name="objectXmlFile" type="any" _type="string" required="true" hint="I am the path to the config XML file to be added." />
		<!--- validate and parse the xml file. --->
		<cfset var xmlObject = validateAndParseXML( arguments.objectXmlFile ) />
		
		<!--- load this file's objects --->
		<cfset addObjectsFromXml( xmlObject ) />
	</cffunction>
	
	<!--- addObjectsFromXml --->
	<cffunction name="addObjectsFromXml" returntype="void" access="private" output="false" hint="I add Reactor objects from an XML object.">
		<cfargument name="configXml" type="any" _type="string" required="true" hint="I am the XML object to be processed." />
		
		<cfset var objectsConfig = xmlsearch( arguments.configXml, '//reactor/objects' ) />
		<cfset var x = 0 />
		<cfset var object = 0 />
		<cfset var objectConfig = '' />
		<cfset var nObjectConfig = '' />
		
		<!--- load import files --->
		<cfset loadImports( arguments.configXml ) />
		
		<cfif ArrayLen( objectsConfig )>
			<cfset objectsConfig = objectsConfig[1] />
			<cfset objectConfig = xmlsearch( objectsConfig, '//object' ) />	
			<cfset nObjectConfig = arraylen( objectConfig ) />
			<cfloop from="1" to="#nObjectConfig#" index="x">
				<cfset object = objectConfig[x]>
				
				<cfif NOT StructKeyExists( object.xmlAttributes, "alias" )>
					<cfset object.xmlAttributes["alias"] = object.xmlAttributes.name />
				</cfif>
				
				<!--- check to see if the containing object tag has a mapping attribute.  if so, copy its value into this tag. --->
				<cfif StructKeyExists( objectsConfig.XmlAttributes, "mapping" ) AND NOT StructKeyExists( object.xmlAttributes, "mapping" )>
					<cfset object.xmlAttributes["mapping"] = objectsConfig.XmlAttributes.mapping />
				</cfif>
				
				<cfset variables.objectMap[object.xmlAttributes.alias] = object />
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="loadImports" returntype="void" access="private" output="false" hint="">
		<cfargument name="configXml" type="any" required="true" hint="I am the XML object to be processed." />
		<cfset var imports = XMLSearch( arguments.configXML, '//reactor/import' ) />
		<cfset var i =  "" />
		<cfif ArrayLen( imports )>
			<cfloop from="1" to="#ArrayLen( imports )#" index="i">
				<cfset addObjects( imports[i].XMLAttributes.file ) />
			</cfloop>
		</cfif>
	</cffunction>
	
	<!--- loadConfig --->
	<cffunction name="loadConfig" access="private" hint="I read the basic config settings from the config xml." output="false" returntype="void">
		<cfargument name="configXml" hint="I am the raw configuration xml" required="yes" type="any" _type="string" />
		<cfset var config = 0 />
		<cfset var x = 0 />
    
		<!--- load the config settings --->
		<cfset config = XMLSearch(arguments.configXml, "/reactor/config/*") />

		<cfloop from="1" to="#ArrayLen(config)#" index="x">
        <cfif listFindNocase("project,dsn,type,mapping,mode,username,password",config[x].XmlName) gt 0>
    			<cfinvoke method="set#config[x].XmlName#">
    				<cfinvokeargument name="#config[x].XmlName#" value="#config[x].XmlAttributes.Value#" />
    			</cfinvoke>
        </cfif>
		</cfloop>
	</cffunction>

	<!--- validate and parse xml --->
	<cffunction name="validateAndParseXML" returntype="any" _returntype="any" access="private" output="false" hint="I validates and parses xml file passed as an argument.">
		<cfargument name="xmlFile" type="any" _type="string" required="true" hint="I am the path to the config XML file." />
		<cfset var xml = "">
		
		<!--- attempt to expand the path to config 
		#204: Calling fileExists() on the root-relative config file location before 
			  using an expandPath() will cause an error in security sandbox. 
		--->
		 <cftry> 
			<cfif NOT FileExists(arguments.xmlFile)> 
				<cfset arguments.xmlFile = expandPath( arguments.xmlFile ) /> 
			</cfif> 
		
			<cfcatch> 
				<cfset arguments.xmlFile = expandPath( arguments.xmlFile ) /> 
			</cfcatch> 
		</cftry> 

		<cfif NOT FileExists( arguments.xmlFile )>
			<cfthrow type="reactor.config.InvalidPathToConfig"
				message="Invalid Path To Config"
				detail="The path #arguments.xmlFile# does not exist." />
		</cfif>

		<!--- check if this file has already been loaded to prevent recursion.  --->
		<cfif NOT variables.loadedFiles.contains( UCase( arguments.XMLFile ) )>
			<cfset ArrayAppend( variables.loadedFiles, UCase( arguments.XMLFile ) ) />
			<!--- read and parse the xml --->
			<cffile action="read" file="#arguments.xmlFile#" variable="xml" />
			
			<cftry>
				<cfset xml = XMLParse(xml) />	
				<cfcatch type="any">
					<cfthrow type="reactor.config.InvalidConfigXML" 
	 	                 message="Invalid XML Object" 
	 	                 detail="configXml is not a valid XML Object." />
				</cfcatch>
			</cftry>
		<cfelse>
			<cfthrow type="reactor.config.FileLoaded"
					 message="Config file already loaded"
					 detail="Config file (#arguments.xmlFile#) has already been loaded." />
		</cfif>
		<cfreturn xml />
	</cffunction>
	
	<cffunction name="getObjectConfig" access="public" output="false" returntype="any" _returntype="string" hint="I return the base configuration for a particular object.  If the object is not explictly configure a default config is returned.">
		<cfargument name="alias" required="yes" type="any" _type="any" hint="I am the alias of the object to get the configuration for" />
		<cfset var table = 0 />
		
		<cfif structKeyExists(variables.parsedObjectMap, arguments.alias)>
			<cfreturn variables.parsedObjectMap[arguments.alias]>
		</cfif>

		<cfif structKeyExists(variables.objectMap,arguments.alias)>
			<cfset table = variables.objectMap[arguments.alias] /> 
		<cfelse>
			<cfset table = "<object name=""#arguments.alias#"" alias=""#arguments.alias#"" />" />
		</cfif>
		
		<cfset variables.parsedObjectMap[arguments.alias] = xmlParse(table)>
		<cfreturn variables.parsedObjectMap[arguments.alias] />
	</cffunction>

	<!--- dsn --->
  <cffunction name="setDsn" access="public" output="false" returntype="void">
       <cfargument name="dsn" hint="I am the DSN to connect to." required="yes" type="any" _type="string" />
       <cfset variables.dsn = arguments.dsn />
  </cffunction>
  <cffunction name="getDsn" access="public" output="false" returntype="any" _returntype="string">
       <cfreturn variables.dsn />
  </cffunction>

	<!--- Type --->
	<cffunction name="setType" access="public" output="false" returntype="void">
		<cfargument name="Type" hint="I am the type of database the dsn is for" required="yes" type="any" _type="string" />

		<cfif NOT ListFindNoCase(this.DBTYPES, arguments.Type)>
			<cfthrow type="reactor.InvalidType"
				message="Invalid Type Setting"
				detail="The Type argument must be one of: #this.DBTYPES#" />
		</cfif>

		<cfset variables.Type = arguments.Type />
  </cffunction>
  <cffunction name="getType" access="public" output="false" returntype="any" _returntype="string">
    <cfreturn lcase(variables.Type) />
  </cffunction>

	<!--- mapping --->
  <cffunction name="setMapping" access="public" output="false" returntype="void">
		<cfargument name="mapping" hint="I am a mapping to the location where objects are created." required="yes" type="any" _type="string" />

		<cfif NOT DirectoryExists(expandPath(arguments.mapping))>
			<cfthrow type="reactor.Invalidmapping"
				message="Invalid Mapping Setting"
				detail="The mapping argument must be a mapping to a directory which exists." />
		</cfif>

		<cfset variables.mapping = arguments.mapping />
  </cffunction>

  <cffunction name="getMapping" access="public" output="false" returntype="any" _returntype="string">
		<cfargument name="alias" hint="I am an optional alias of an object.  The object will be checked for its own custom mapping." required="no" type="any" _type="string" default="" />
		<cfset var mapping = variables.mapping />
		<cfset var object = 0 />
		
		<cfif Len(arguments.alias)>
			<cfset object = getObjectConfig(arguments.alias) />
			<cfif StructKeyExists(object.object.XmlAttributes, "mapping")>
				<cfreturn object.object.XmlAttributes.mapping />
			</cfif>
		</cfif>
		<cfreturn mapping />
  </cffunction>

  <cffunction name="getMappingObjectStem" access="public" output="false" returntype="any" _returntype="string">
		<cfargument name="mapping" hint="I am the mapping to get the stem for." required="no" default="#getMapping()#" />
		<cfset var objectStem = ReReplaceNoCase(arguments.mapping, "/+", ".", "all") />

		<cfif Left(objectStem, 1) IS ".">
			<cfset objectStem = Right(objectStem, Len(objectStem) - 1) />
		</cfif>

		<cfreturn objectStem />
  </cffunction>

	<!--- mode --->
  <cffunction name="setMode" access="public" output="false" returntype="void">
		<cfargument name="mode" hint="I am the mode in which the system is running.  Options are: development, production" required="yes" type="any" _type="string" />

		<cfif NOT ListFindNoCase("development,production,always", arguments.mode)>
			<cfthrow type="reactor.InvalidMode"
				message="Invalid Mode Setting"
				detail="The mode argument must be one of: development, production, always" />
		</cfif>

		<cfset variables.mode = arguments.mode />
  </cffunction>
  <cffunction name="getMode" access="public" output="false" returntype="any" _returntype="string">
       <cfreturn variables.mode />
  </cffunction>

	<!--- project --->
  <cffunction name="setProject" access="public" output="false" returntype="void">
       <cfargument name="project" hint="I am the name of the project." required="yes" type="any" _type="string" />
       <cfset variables.project = ReReplace(arguments.project, "[\W]", "", "all") />
  </cffunction>
  <cffunction name="getProject" access="public" output="false" returntype="any" _returntype="string">
       <cfreturn variables.project />
  </cffunction>

	<!--- username --->
  <cffunction name="setUsername" access="public" output="false" returntype="void">
       <cfargument name="username" hint="I am the username to use for DSNs" required="yes" type="any" _type="string" />
       <cfset variables.username = arguments.username />
  </cffunction>
  <cffunction name="getUsername" access="public" output="false" returntype="any" _returntype="string">
       <cfreturn variables.username />
  </cffunction>

	<!--- password --->
  <cffunction name="setPassword" access="public" output="false" returntype="void">
       <cfargument name="password" hint="I am the password to use for DSNs" required="yes" type="any" _type="string" />
       <cfset variables.password = arguments.password />
  </cffunction>
  <cffunction name="getPassword" access="public" output="false" returntype="any" _returntype="string">
       <cfreturn variables.password />
  </cffunction>

</cfcomponent>

