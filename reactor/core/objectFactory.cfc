<cfcomponent hint="I am the object factory.">
	
	<cfset variables.config = "" />
	
	<cffunction name="init" access="public" hint="I configure the table factory." output="false" returntype="reactor.core.objectFactory">
		<cfargument name="config" hint="I am a reactor config object" required="yes" type="reactor.bean.config" />
		
		<cfset setConfig(config) />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="create" access="public" hint="I create and return a To for a specific table." output="false" returntype="reactor.base.abstractObject">
		<cfargument name="name" hint="I am the name of the table create a To for." required="yes" type="string" />
		<cfargument name="type" hint="I am the type of object to create.  Options are: To, Dao, Gateway, Record" required="yes" type="string" />
		<cfset var Object = 0 />
		<cfset var generate = false />
		<cfset var TableTranslator = 0 />
		
		<cfif NOT ListFindNoCase("record,dao,gateway,to", arguments.type)>
			<cfthrow type="reactor.InvalidObjectType"
				message="Invalid Object Type"
				detail="The type argument must be one of: record, dao, gateway, to" />
		</cfif>
	
		<cfswitch expression="#getConfig().getMode()#">
			<cfcase value="always">
				<cfset TableTranslator = CreateObject("Component", "reactor.core.tableTranslator").init(getConfig(), arguments.name) />
				<cfset generate = true />
			</cfcase>
			<cfcase value="development">
				<cftry>
					<!--- create an instance of the object and check it's signature --->
					<cfset Object = CreateObject("Component", getObjectName(arguments.type, arguments.name)) />
					<cfcatch>
						<cfset TableTranslator = CreateObject("Component", "reactor.core.tableTranslator").init(getConfig(), arguments.name) />
						<cfset generate = true />
					</cfcatch>
				</cftry>
				<cfif NOT generate>
					<!--- check the object's signature --->
					<cfset TableTranslator = CreateObject("Component", "reactor.core.tableTranslator").init(getConfig(), arguments.name) />
					<cfif TableTranslator.getSignature() IS NOT Object.getSignature()>
						<cfset generate = true />
					</cfif>
				</cfif>
			</cfcase>
			<cfcase value="production">
				<cftry>
					<!--- create an instance of the object and check it's signature --->
					<cfset Object = CreateObject("Component", getObjectName(arguments.type, arguments.name)) />
					<cfcatch>
						<cfset TableTranslator = CreateObject("Component", "reactor.core.tableTranslator").init(getConfig(), arguments.name) />
						<cfset generate = true />
					</cfcatch>
				</cftry>
			</cfcase>
		</cfswitch>
		
		<!--- return either a generated object or the existing object --->
		<cfif generate>
			<cfset generateObject(TableTranslator, arguments.type) />			
			<cfreturn CreateObject("Component", getObjectName(arguments.type, arguments.name)).init(getConfig()) />
		<cfelse>
			<cfreturn Object.init(getConfig()) />
		</cfif>
	</cffunction>
	
 	<cffunction name="generateObject" access="private" hint="I generate a To object" output="false" returntype="void">
		<cfargument name="TableTranslator" hint="I am the TableTranslator to use to generate the To." required="yes" type="reactor.core.tableTranslator" />
		<cfargument name="type" hint="I am the type of object to create.  Options are: To, Dao, Gateway, Record" required="yes" type="string" />
		<cfset var XML = arguments.TableTranslator.getXml() />
		<cfset var superTable = XMLSearch(XML, "/table/superTable") />
				
		<cfif ArrayLen(superTable)>
			<!--- we need to insure that the base object exists --->
			<cfset generateObject(CreateObject("Component", "reactor.core.tableTranslator").init(getConfig(), superTable[1].XmlAttributes.name), arguments.type) />
		</cfif>
		
		<!--- write the base object --->
		<cfset generate(
			XML,
			expandPath("/reactor/xsl/#arguments.type#.base.xsl"),
			getObjectPath(arguments.type, XML.table.XmlAttributes.name, "base"),
			true) />
		<!--- generate the custom object --->
		<cfset generate(
			XML,
			expandPath("/reactor/xsl/#arguments.type#.custom.xsl"),
			getObjectPath(arguments.type, XML.table.XmlAttributes.name, "custom"),
			false) />
	</cffunction>
	
	<cffunction name="generate" access="private" hint="I transform the XML via the specified XSL file and output to the provided path, overwritting it configured to do so." output="false" returntype="void">
		<cfargument name="xml" hint="I am the XML to transform." required="yes" type="xml" />
		<cfargument name="xslPath" hint="I am the path to the XSL file to use for translation" required="yes" type="string" />
		<cfargument name="outputPath" hint="I am the path to the file to output to." required="yes" type="string" />
		<cfargument name="overwrite" hint="I indicate if the ouput path should be overwritten if it exists." required="yes" type="boolean" />
		<cfset var xsl = 0 />
		<cfset var code = 0 />
		
		<!--- check to see if the output file exists and if we can overwrite it --->
		<cfif NOT (FileExists(arguments.outputPath) AND NOT arguments.overwrite)>
			<!--- read the xsl --->
			<cffile action="read" file="#arguments.xslPath#" variable="xsl" />
			<!--- transform this structure into the base TO object --->
			<cfset code = XMLTransform(arguments.xml, xsl) />
			<!--- insure the outputPath director exists --->
			<cfset insurePathExists(arguments.outputPath)>
			<!--- write the file to disk --->
			<cffile action="write" file="#arguments.outputPath#" output="#code#" />
		</cfif>
	</cffunction>
	
	<cffunction name="getTable" access="private" hint="I create a table object which encapsulates table metadata." output="false" returntype="reactor.core.table">
		<cfargument name="name" hint="I am the name of the table create a To for." required="yes" type="string" />
		<cfset var Table = CreateObject("Component", "reactor.core.Table").init(getConfig(), arguments.name) />
		<cfset var TableDao = CreateObject("Component", "reactor.data.#getConfig().getDbType()#.TableDao").init(getConfig().getDsn()) />
		
		<!--- inspect the table --->
		<cfset TableDao.read(Table) />
		
		<cfreturn Table />
	</cffunction>
	
	<!----
	<cffunction name="createRecord" access="public" hint="I create and return a record for a specific table." output="false" returntype="reactor.base.abstractRecord">
		<cfargument name="name" hint="I am the name of the table create a record for." required="yes" type="string" />
		<cfset var Record = 0 />
		<cfset var generate = false />
		<cfset var structure = 0 />
		<cfset var xslBase = 0 />
		<cfset var xslCustom = 0 />
		<cfset var recordCode = 0 />
		<cfset var recordPath = 0 />
		
		<!--- try to create the object --->
		<cftry>
			<cfset Record = CreateObject("Component", getObjectName("Record", arguments.name)) />
			<cfcatch>
				<!--- if there are errors then we need to generate the record --->
				<cfset generate = true />
			</cfcatch>
		</cftry>
		
		<!---
			If we don't already need to generate the Record, check to insure that the Record's signature matches the tables's signature.
			If not, then we need to regenerate.
		--->
		<cfif getConfig().getMode() IS "always" OR (NOT generate AND getConfig().getMode() IS "development" AND Record.getSignature() IS NOT getTableSignature(arguments.name))>
			<cfset generate = true />
		</cfif>
		
		<!--- if we need to generate it, generate it --->
		<cfif generate>
			<!--- get the structure --->
			<cfset structure = getTableStructure(arguments.name) />
			
			<!--- insure that the base object exists --->
			<cfif structure.table.XmlAttributes.baseTable IS NOT arguments.name>
				<!--- we need to insure that an object exists --->
				<!--- TODO: right now, this creates and instantiates the object.  in the future I'd like it to only generate the object and only if it doesn't exist --->
				<cfset createRecord(structure.table.XmlAttributes.baseTable) />
			</cfif>
			
			<!--- read the Record xsl --->
			<cffile action="read" file="#expandPath("/reactor/xsl/record.base.xsl")#" variable="xslBase" />
			<cffile action="read" file="#expandPath("/reactor/xsl/record.custom.xsl")#" variable="xslCustom" />
			
			<!--- transform this structure into the base Record object --->
			<cfset recordCode = XMLTransform(structure, xslBase) />
			<!--- get the path to the base Record --->
			<cfset recordPath = getObjectPath("Record", arguments.name, "base") />
			<!--- insure that the output directory exists --->
			<cfset insurePathExists(recordPath) />
			<!--- write the base Record --->
			<cffile action="write" file="#recordPath#" output="#recordCode#" nameconflict="overwrite" />
			
			<!--- get the path to the custom Record --->
			<cfset recordPath = getObjectPath("Record", arguments.name, "custom") />
			<cfif NOT FileExists(recordPath)>
				<!--- transform this structure into the custom Record object --->
				<cfset recordCode = XMLTransform(structure, xslCustom) />
				<!--- insure that the output directory exists --->
				<cfset insurePathExists(recordPath) />
				<!--- write the custom Record --->
				<cffile action="write" file="#recordPath#" output="#recordCode#" />
			</cfif>
			
			<!--- create the newly generated Record --->
			<cfset Record = CreateObject("Component", getObjectName("Record", arguments.name)).init(arguments.name, this) />
		<cfelse>
			<!--- init the already-existing Record --->
			<cfset Record = Record.init(arguments.name, this) />
		</cfif>
		
		<cfreturn Record />
	</cffunction>

	
	
	<cffunction name="createDao" access="public" hint="I create and return a DAO for a specific table." output="false" returntype="reactor.base.abstractDao">
		<cfargument name="name" hint="I am the name of the table create a Dao for." required="yes" type="string" />
		<cfset var Dao = 0 />
		<cfset var generate = false />
		<cfset var structure = 0 />
		<cfset var xslBase = 0 />
		<cfset var xslCustom = 0 />
		<cfset var daoCode = 0 />
		<cfset var daoPath = 0 />
		
		<!--- try to create the object --->
		<cftry>
			<cfset Dao = CreateObject("Component", getObjectName("Dao", arguments.name)) />
			<cfcatch>
				<!--- if there are errors then we need to generate the record --->
				<cfset generate = true />
			</cfcatch>
		</cftry>
		
		<!---
			If we don't already need to generate the Dao, check to insure that the Dao's signature matches the object's signature.
			If not, then we need to regenerate.
		--->
		<cfif getConfig().getMode() IS "always" OR (NOT generate AND getConfig().getMode() IS "development" AND Dao.getSignature() IS NOT getTableSignature(arguments.name))>
			<cfset generate = true />
		</cfif>
		
		<!--- if we need to generate it, generate it --->
		<cfif generate>
			<!--- get the structure --->
			<cfset structure = getTableStructure(arguments.name) />
			
			<!--- insure that the base object exists --->
			<cfif structure.table.XmlAttributes.baseTable IS NOT arguments.name>
				<!--- we need to insure that an object exists --->
				<!--- TODO: right now, this creates and instantiates the object.  in the future I'd like it to only generate the object and only if it doesn't exist --->
				<cfset createDao(structure.table.XmlAttributes.baseTable) />
			</cfif>
		
			<!--- read the Dao xsl --->
			<cffile action="read" file="#expandPath("/reactor/xsl/#getDbType()#/dao.base.xsl")#" variable="xslBase" />
			<cffile action="read" file="#expandPath("/reactor/xsl/#getDbType()#/dao.custom.xsl")#" variable="xslCustom" />
			
			<!--- transform this structure into the base DAO object --->
			<cfset daoCode = XMLTransform(structure, xslBase) />
			<!--- get the path to the base DAO --->
			<cfset daoPath = getObjectPath("DAO", arguments.name, "base") />
			<!--- insure that the output directory exists --->
			<cfset insurePathExists(daoPath) />
			<!--- write the base DAO --->
			<cffile action="write" file="#daoPath#" output="#daoCode#" nameconflict="overwrite" />
			
			<!--- get the path to the custom DAO --->
			<cfset daoPath = getObjectPath("DAO", arguments.name, "custom") />
			<cfif NOT FileExists(daoPath)>
				<!--- transform this structure into the custom DAO object --->
				<cfset daoCode = XMLTransform(structure, xslCustom) />
				<!--- insure that the output directory exists --->
				<cfset insurePathExists(daoPath) />
				<!--- write the custom DAO --->
				<cffile action="write" file="#daoPath#" output="#daoCode#" />
			</cfif>
			
			<cfset Dao = CreateObject("Component", getObjectName("DAO", arguments.name)).init(getDsn()) />
		<cfelse>
			<!--- init the Dao --->
			<cfset Dao = Dao.init(getDsn()) />
		</cfif>
		
		<cfreturn Dao />
	</cffunction>
	
	<cffunction name="createGateway" access="public" hint="I create a Gateway based upon a name." output="false" returntype="reactor.base.abstractGateway">
		<cfargument name="name" hint="I am the name of the table create a Gateway for." required="yes" type="string" />
		<cfset var Gateway = 0 />
		<cfset var generate = false />
		<cfset var structure = 0 />
		<cfset var baseStructure = 0 />
		<cfset var xslBase = 0 />
		<cfset var xslCustom = 0 />
		<cfset var gatewayCode = 0 />
		<cfset var gatewayPath = 0 />
		
		<!--- try to create the object --->
		<cftry>
			<cfset Gateway = CreateObject("Component", getObjectName("Gateway", arguments.name)) />
			<cfcatch>
				<!--- if there are errors then we need to generate the record --->
				<cfset generate = true />
			</cfcatch>
		</cftry>
		
		<!---
			If we don't already need to generate the Gateway, check to insure that the Gateway's signature matches the object's signature.
			If not, then we need to regenerate.
		--->
		<cfif getConfig().getMode() IS "always" OR (NOT generate AND getConfig().getMode() IS "development" AND Gateway.getSignature() IS NOT getTableSignature(arguments.name))>
			<cfset generate = true />
		</cfif>
		
		<!--- if we need to generate it, generate it --->
		<cfif generate>
			<!--- get the structure --->
			<cfset structure = getTableStructure(arguments.name) />
			
			<!--- read the Gateway xsl --->
			<cffile action="read" file="#expandPath("/reactor/xsl/#getDbType()#/gateway.base.xsl")#" variable="xslBase" />
			<cffile action="read" file="#expandPath("/reactor/xsl/#getDbType()#/gateway.custom.xsl")#" variable="xslCustom" />
			
			<!--- transform this structure into the base Gateway object --->
			<cfset gatewayCode = XMLTransform(structure, xslBase) />
			<!--- get the path to the base Gateway --->
			<cfset gatewayPath = getObjectPath("Gateway", arguments.name, "base") />
			<!--- insure that the output directory exists --->
			<cfset insurePathExists(gatewayPath) />
			<!--- write the base Gateway --->
			<cffile action="write" file="#gatewayPath#" output="#gatewayCode#" nameconflict="overwrite" />
			
			<!--- get the path to the custom Gateway --->
			<cfset gatewayPath = getObjectPath("Gateway", arguments.name, "custom") />
			<cfif NOT FileExists(gatewayPath)>
				<!--- transform this structure into the custom Gateway object --->
				<cfset gatewayCode = XMLTransform(structure, xslCustom) />
				<!--- insure that the output directory exists --->
				<cfset insurePathExists(gatewayPath) />
				<!--- write the custom Gateway--->
				<cffile action="write" file="#gatewayPath#" output="#gatewayCode#" />
			</cfif>
			
			<cfset Gateway = CreateObject("Component", getObjectName("Gateway", arguments.name)).init(getDsn()) />
		<cfelse>
			<!--- init the Gateway --->
			<cfset Gateway = Gateway.init(getDsn()) />
		</cfif>
		
		<cfreturn Gateway />
	</cffunction>
	--->
	
	<cffunction name="getObjectName" access="private" hint="I return the correct name of the a object based on it's type and other configurations" output="false" returntype="string">
		<cfargument name="type" hint="I am the type of object to return.  Options are: record, dao, gateway, to" required="yes" type="string" />
		<cfargument name="name" hint="I am the name of the object to return." required="yes" type="string" />
		<cfargument name="base" hint="I indicate if the base object name should be returned.  If false, the custom is returned." required="no" type="boolean" default="false" />
		<cfset var creationPath = replaceNoCase(right(getConfig().getCreationPath(), Len(getConfig().getCreationPath()) - 1), "/", ".") />
		
		<cfif NOT ListFindNoCase("record,dao,gateway,to", arguments.type)>
			<cfthrow type="reactor.InvalidObjectType"
				message="Invalid Object Type"
				detail="The type argument must be one of: record, gateway" />
		</cfif>
		
		<cfreturn creationPath & "." & arguments.type & ".mssql." & Iif(arguments.base, DE('base.'), DE('')) & arguments.name & arguments.type  />
	</cffunction>
	
	<cffunction name="getObjectPath" access="private" hint="I return the path to the type of object specified." output="false" returntype="string">
		<cfargument name="type" hint="I am the type of object to return.  Options are: record, dao, gateway, to" required="yes" type="string" />
		<cfargument name="name" hint="I am the name of the table to get the structure XML for." required="yes" type="string" />
		<cfargument name="class" hint="I indicate if the 'class' of object to return.  Options are: base, custom" required="yes" type="string" />
		
		<cfif NOT ListFindNoCase("record,dao,gateway,to", arguments.type)>
			<cfthrow type="reactor.InvalidArgument"
				message="Invalid Type Argument"
				detail="The type argument must be one of: record, dao, gateway, to" />
		</cfif>
		<cfif NOT ListFindNoCase("base,custom", arguments.class)>
			<cfthrow type="reactor.InvalidArgument"
				message="Invalid Class Argument"
				detail="The class argument must be one of: base, custom" />
		</cfif>
		
		<cfreturn expandPath(getConfig().getCreationPath() & "/" & arguments.type & "/mssql/" & Iif(arguments.class IS "base", DE('base/'), DE('')) & arguments.name & arguments.type & ".cfc") />
	</cffunction>
	
	<cffunction name="insurePathExists" access="private" hint="I insure the directories for the path to the specified exist" output="false" returntype="void">
		<cfargument name="path" hint="I am the path to the file." required="yes" type="string" />
		<cfset var directory = getDirectoryFromPath(arguments.path) />
		
		<cfif NOT DirectoryExists(directory)>
			<cfdirectory action="create" directory="#getDirectoryFromPath(arguments.path)#" />
		</cfif>
	</cffunction>
	
	<!---
	<cffunction name="getTableSignature" access="private" hint="I return the signature for a specific table." output="false" returntype="string">
		<cfargument name="name" hint="I am the name of the table to get the signature for." required="yes" type="string" />
		<cfset var definition = getTableStructure(arguments.name) />
		
		<cfreturn definition.table.XmlAttributes.signature />
	</cffunction>
	
	
	
	
	
	<cffunction name="TitleCase" access="private" hint="I return the string in title case." output="false" returntype="string">
		<cfargument name="string" hint="I am the string to return in title case." required="yes" type="string" />
		<cfargument name="firstOnly" hint="I indicate if only the first caracter is altered, or if all characters are." required="no" type="boolean" default="false" />
		
		<cfif arguments.firstOnly>
			<cfreturn Ucase(left(arguments.string, 1)) & right(arguments.string, Len(arguments.string) - 1) />
		<cfelse>
			<cfreturn Ucase(left(arguments.string, 1)) & Lcase(right(arguments.string, Len(arguments.string) - 1)) />
		</cfif>		
	</cffunction>
	---->
	
	<!--- config --->
    <cffunction name="setConfig" access="public" output="false" returntype="void">
       <cfargument name="config" hint="I am the config object used to configure reactor" required="yes" type="reactor.bean.config" />
       <cfset variables.config = arguments.config />
    </cffunction>
    <cffunction name="getConfig" access="public" output="false" returntype="reactor.bean.config">
       <cfreturn variables.config />
    </cffunction>
	
</cfcomponent>