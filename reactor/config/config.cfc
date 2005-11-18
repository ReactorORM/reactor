<cfcomponent hint="I am a bean used to encapsulate Reactor's configuration.">
	
	<cfset variables.configXml = "" />
	<cfset variables.dsn = "" />
	<cfset variables.Type = "" />
	<cfset variables.mapping = "" />
	<cfset variables.mode = "" />
	
	<cffunction name="init" access="public" hint="I configure this config bean." output="false" returntype="reactor.config.config">
		<cfargument name="pathToConfigXml" hint="I am the path to the config XML file." required="yes" type="string" />
		<cfset var xml = 0 />
		
		
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
			</cfswitch>
		</cfloop>
	</cffunction>
	
	<!--- getObjectConfig --->
	<cffunction name="getObjectConfig" access="public" hint="I return the base configuration for a particular object.  If the object is not explictly configure a default config is returned." output="false" returntype="xml">
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
		
		<cfif IsXML(table)>
			<cfset table = XmlParse(ToString(table)) />
		<cfelse>
			<cfset table = XmlParse("<object name=""#arguments.object#"" />") />
		</cfif>
		
		<!--- return the base config --->
		<cfreturn table />
	</cffunction>
	
	<!--- dsn --->
    <cffunction name="setDsn" access="private" output="false" returntype="void">
       <cfargument name="dsn" hint="I am the DSN to connect to." required="yes" type="string" />
       <cfset variables.dsn = arguments.dsn />
    </cffunction>
    <cffunction name="getDsn" access="public" output="false" returntype="string">
       <cfreturn variables.dsn />
    </cffunction>
	
	<!--- Type --->
	<cffunction name="setType" access="private" output="false" returntype="void">
		<cfargument name="Type" hint="I am the type of database the dsn is for" required="yes" type="string" />
		
		<cfif NOT ListFindNoCase("mssql", arguments.Type)>
			<cfthrow type="reactor.InvalidType"
				message="Invalid Type Setting"
				detail="The Type argument must be one of: mssql" />
		</cfif>
		
		<cfset variables.Type = arguments.Type />
    </cffunction>
    <cffunction name="getType" access="public" output="false" returntype="string">
       <cfreturn lcase(variables.Type) />
    </cffunction>
	
	<!--- mapping --->
    <cffunction name="setMapping" access="private" output="false" returntype="void">
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
    <cffunction name="setMode" access="private" output="false" returntype="void">
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
	
	<!--- configXml --->
    <cffunction name="setConfigXml" access="private" output="false" returntype="void">
       <cfargument name="configXml" hint="I am the raw configuration xml" required="yes" type="xml" />
       <cfset variables.configXml = arguments.configXml />
    </cffunction>
    <cffunction name="getConfigXml" access="private" output="false" returntype="xml">
       <cfreturn variables.configXml />
    </cffunction>
	
</cfcomponent>


		