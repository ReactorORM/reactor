<cfcomponent hint="I am not all that abstract.  I contain a base set of functionality shared across all objectFactories.  I do define methods which must be overridden.">
	
	<cfset variables.dsn = "" />
	<cfset variables.creationPath = "" />
	<cfset variables.mode = "" />
	<cfset variables.TimedCache = CreateObject("Component", "reactor.util.TimedCache").init(createTimeSpan(0,0,0,5)) /> 
	
	<!---// must be overridden //--->
	<cffunction name="getTableDefinition" access="private" hint="I return the definition for a table." output="false" returntype="struct">
		<cfargument name="name" hint="I am the name of the table to get the definition for." required="yes" type="string" />
		
	</cffunction>
	
	<cffunction name="getTableStructure" access="private" hint="I return an XML document representing the table's structure." output="false" returntype="xml">
		<cfargument name="name" hint="I am the name of the table to get the structure XML for." required="yes" type="string" />
		
	</cffunction>
	<!---// end must be overridden //--->
	
	<cffunction name="init" access="public" hint="I configure the table factory." output="false" returntype="reactor.core.abstractObjectFactory">
		<cfargument name="dsn" hint="I am the DSN to use to inspect the DB." required="yes" type="string" />
		<cfargument name="dbtype" hint="I am the type of database the dsn is for.  Options are: mssql" required="yes" type="string" />
		<cfargument name="creationPath" hint="I am a mapping to the location where objects are created." required="yes" type="string" />
		<cfargument name="mode" hint="I indicate the mode the system is running in.  Options are development, production, always" required="yes" type="string" />
		
		<cfif NOT ListFindNoCase("development,production,always", arguments.mode)>
			<cfthrow type="reactor.InvalidMode"
				message="Invalid Mode Argument"
				detail="The mode argument must be one of: development, production, always" />
		</cfif>
		
		<cfset setDsn(arguments.dsn) />
		<cfset setDbType(arguments.dbtype) />
		<cfset setCreationPath(arguments.creationPath) />
		<cfset setMode(arguments.mode) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createRecord" access="public" hint="I create and return a record for a specific table." output="false" returntype="reactor.core.abstractRecord">
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
		<cfif getMode() IS "always" OR (NOT generate AND getMode() IS "development" AND Record.getSignature() IS NOT getTableSignature(arguments.name))>
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

	<cffunction name="createTo" access="public" hint="I create and return a To for a specific table." output="false" returntype="reactor.core.abstractTo">
		<cfargument name="name" hint="I am the name of the table create a To for." required="yes" type="string" />
		<cfset var To = 0 />
		<cfset var generate = false />
		<cfset var structure = 0 />
		<cfset var xslBase = 0 />
		<cfset var xslCustom = 0 />
		<cfset var toCode = 0 />
		<cfset var toPath = 0 />
		
		<!--- try to create the object --->
		<cftry>
			<cfset To = CreateObject("Component", getObjectName("TO", arguments.name)) />
			<cfcatch>
				<!--- if there are errors then we need to generate the To --->
				<cfset generate = true />
			</cfcatch>
		</cftry>
		
		<!---
			If we don't already need to generate the TO, check to insure that the TO's signature matches the tables's signature.
			If not, then we need to regenerate.
		--->
		<cfif getMode() IS "always" OR (NOT generate AND getMode() IS "development" AND To.getSignature() IS NOT getTableSignature(arguments.name))>
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
				<cfset createTo(structure.table.XmlAttributes.baseTable) />
			</cfif>
		
			<!--- read the to xsl --->
			<cffile action="read" file="#expandPath("/reactor/xsl/to.base.xsl")#" variable="xslBase" />
			<cffile action="read" file="#expandPath("/reactor/xsl/to.custom.xsl")#" variable="xslCustom" />
			
			<!--- transform this structure into the base TO object --->
			<cfset toCode = XMLTransform(structure, xslBase) />
			<!--- get the path to the base TO --->
			<cfset toPath = getObjectPath("TO", arguments.name, "base") />
			<!--- insure that the output directory exists --->
			<cfset insurePathExists(toPath) />
			<!--- write the base TO --->
			<cffile action="write" file="#toPath#" output="#toCode#" nameconflict="overwrite" />
			
			<!--- get the path to the custom TO --->
			<cfset toPath = getObjectPath("TO", arguments.name, "custom") />
			<cfif NOT FileExists(toPath)>
				<!--- transform this structure into the custom TO object --->
				<cfset toCode = XMLTransform(structure, xslCustom) />
				<!--- insure that the output directory exists --->
				<cfset insurePathExists(toPath) />
				<!--- write the custom TO --->
				<cffile action="write" file="#toPath#" output="#toCode#" />
			</cfif>
			
			<!--- create the newly generated T0 --->
			<cfset To = CreateObject("Component", getObjectName("TO", arguments.name)) />
		</cfif>
		
		<cfreturn To />
	</cffunction>
	
	<cffunction name="createDao" access="public" hint="I create and return a DAO for a specific table." output="false" returntype="reactor.core.abstractDao">
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
		<cfif getMode() IS "always" OR (NOT generate AND getMode() IS "development" AND Dao.getSignature() IS NOT getTableSignature(arguments.name))>
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
	
	<cffunction name="createGateway" access="public" hint="I create a Gateway based upon a name." output="false" returntype="reactor.core.abstractGateway">
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
		<cfif getMode() IS "always" OR (NOT generate AND getMode() IS "development" AND Gateway.getSignature() IS NOT getTableSignature(arguments.name))>
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
	
	<cffunction name="getTableSignature" access="private" hint="I return the signature for a specific table." output="false" returntype="string">
		<cfargument name="name" hint="I am the name of the table to get the signature for." required="yes" type="string" />
		<cfset var definition = getTableStructure(arguments.name) />
		
		<cfreturn definition.table.XmlAttributes.signature />
	</cffunction>
	
	<cffunction name="insurePathExists" access="private" hint="I insure the directories for the path to the specified exist" output="false" returntype="void">
		<cfargument name="path" hint="I am the path to the file." required="yes" type="string" />
		<cfset var directory = getDirectoryFromPath(arguments.path) />
		
		<cfif NOT DirectoryExists(directory)>
			<cfdirectory action="create" directory="#getDirectoryFromPath(arguments.path)#" />
		</cfif>
	</cffunction>
	
	<cffunction name="getObjectName" access="private" hint="I return the correct name of the a object based on it's type and other configurations" output="false" returntype="string">
		<cfargument name="type" hint="I am the type of object to return.  Options are: record, dao, gateway, to" required="yes" type="string" />
		<cfargument name="name" hint="I am the name of the object to return." required="yes" type="string" />
		<cfargument name="base" hint="I indicate if the base object name should be returned.  If false, the custom is returned." required="no" type="boolean" default="false" />
		<cfset var creationPath = replaceNoCase(right(getCreationPath(), Len(getCreationPath()) - 1), "/", ".") />
		
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
		
		<cfreturn expandPath(getCreationPath() & "/" & arguments.type & "/mssql/" & Iif(arguments.class IS "base", DE('base/'), DE('')) & TitleCase(arguments.name, true) & TitleCase(arguments.type) & ".cfc") />
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
	
	<!--- dsn --->
    <cffunction name="setDsn" access="private" output="false" returntype="void">
       <cfargument name="dsn" hint="I am the DSN to connect to." required="yes" type="string" />
       <cfset variables.dsn = arguments.dsn />
    </cffunction>
    <cffunction name="getDsn" access="private" output="false" returntype="string">
       <cfreturn variables.dsn />
    </cffunction>
	
	<!--- dbType --->
	<cffunction name="setDbType" access="private" output="false" returntype="void">
       <cfargument name="dbType" hint="I am the type of database the dsn is for" required="yes" type="string" />
       <cfset variables.dbType = arguments.dbType />
    </cffunction>
    <cffunction name="getDbType" access="private" output="false" returntype="string">
       <cfreturn variables.dbType />
    </cffunction>
	
	<!--- creationPath --->
    <cffunction name="setCreationPath" access="private" output="false" returntype="void">
       <cfargument name="creationPath" hint="I am a mapping to the location where objects are created." required="yes" type="string" />
       <cfset variables.creationPath = arguments.creationPath />
    </cffunction>
    <cffunction name="getCreationPath" access="private" output="false" returntype="string">
       <cfreturn variables.creationPath />
    </cffunction>
	
	<!--- mode --->
    <cffunction name="setMode" access="private" output="false" returntype="void">
       <cfargument name="mode" hint="I am the mode in which the system is running.  Options are: development, production" required="yes" type="string" />
       <cfset variables.mode = arguments.mode />
    </cffunction>
    <cffunction name="getMode" access="private" output="false" returntype="string">
       <cfreturn variables.mode />
    </cffunction>
	
	<!--- timedCache --->
    <cffunction name="getTimedCache" access="private" output="false" returntype="reactor.util.TimedCache">
       <cfreturn variables.timedCache />
    </cffunction>
	
</cfcomponent>