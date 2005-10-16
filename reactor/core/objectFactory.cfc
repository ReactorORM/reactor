<cfcomponent hint="I am the object factory.">
	
	<cfset variables.config = "" />
	
	<cffunction name="init" access="public" hint="I configure the table factory." output="false" returntype="reactor.core.objectFactory">
		<cfargument name="config" hint="I am a reactor config object" required="yes" type="reactor.bean.config" />
		
		<cfset setConfig(config) />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="create" access="public" hint="I create and return a To for a specific table." output="false" returntype="reactor.base.abstractObject">
		<cfargument name="name" hint="I am the name of the table create a To for." required="yes" type="string" />
		<cfargument name="type" hint="I am the type of object to create.  Options are: To, Dao, Gateway, Record, Bean" required="yes" type="string" />
		<cfset var Object = 0 />
		<cfset var generate = false />
		<cfset var TableTranslator = 0 />
		
		<cfif NOT ListFindNoCase("record,dao,gateway,to,bean", arguments.type)>
			<cfthrow type="reactor.InvalidObjectType"
				message="Invalid Object Type"
				detail="The type argument must be one of: record, dao, gateway, to, bean" />
		</cfif>
	
		<cftry>
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
			
			<cfcatch type="Reactor.NoSuchTable">
				<cfthrow type="Reactor.NoSuchTable" message="Table '#arguments.name#' does not exist." detail="Reactor was unable to find a table in the database with the name '#arguments.name#.'" />
			</cfcatch>
		</cftry>
		
		<!--- return either a generated object or the existing object --->
		<cfif generate>
			<cfset generateObject(TableTranslator, arguments.type) />			
			<cfswitch expression="#arguments.type#">
				<cfcase value="Record,Bean">
					<cfreturn CreateObject("Component", getObjectName(arguments.type, arguments.name)).config(getConfig(), arguments.name, this) />
				</cfcase>	
				<cfdefaultcase>
					<cfreturn CreateObject("Component", getObjectName(arguments.type, arguments.name)).config(getConfig()) />
				</cfdefaultcase>
			</cfswitch>
		<cfelse>
			<cfswitch expression="#arguments.type#">
				<cfcase value="Record,Bean">
					<cfreturn Object.config(arguments.name, this) />
				</cfcase>	
				<cfdefaultcase>
					<cfreturn Object.config(getConfig()) />
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</cffunction>
	
 	<cffunction name="generateObject" access="private" hint="I generate a To object" output="false" returntype="void">
		<cfargument name="TableTranslator" hint="I am the TableTranslator to use to generate the To." required="yes" type="reactor.core.tableTranslator" />
		<cfargument name="type" hint="I am the type of object to create.  Options are: To, Dao, Gateway, Record, Bean" required="yes" type="string" />
		<cfset var XML = arguments.TableTranslator.getXml() />
		<cfset var superTable = XMLSearch(XML, "/table/superTables[@sort = 'backward']/superTable") />
		
		<cfif ArrayLen(superTable) and arguments.type IS NOT "gateway">
			<!--- we need to insure that the base object exists for Dao, Record --->
			<cfset generateObject(CreateObject("Component", "reactor.core.tableTranslator").init(getConfig(), superTable[1].XmlAttributes.toTable), arguments.type) />
		</cfif>
		
		<!--- write the base object --->
		<cfset generate(
			XML,
			expandPath("/reactor/xsl/#lcase(arguments.type)#.base.xsl"),
			getObjectPath(arguments.type, XML.table.XmlAttributes.name, "base"),
			true) />
		<!--- generate the custom object --->
		<cfset generate(
			XML,
			expandPath("/reactor/xsl/#lcase(arguments.type)#.custom.xsl"),
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
	
	<cffunction name="getObjectName" access="private" hint="I return the correct name of the a object based on it's type and other configurations" output="false" returntype="string">
		<cfargument name="type" hint="I am the type of object to return.  Options are: record, dao, gateway, to, bean" required="yes" type="string" />
		<cfargument name="name" hint="I am the name of the object to return." required="yes" type="string" />
		<cfargument name="base" hint="I indicate if the base object name should be returned.  If false, the custom is returned." required="no" type="boolean" default="false" />
		<cfset var creationPath = replaceNoCase(right(getConfig().getCreationPath(), Len(getConfig().getCreationPath()) - 1), "/", ".") />
		
		<cfif NOT ListFindNoCase("record,dao,gateway,to,bean", arguments.type)>
			<cfthrow type="reactor.InvalidObjectType"
				message="Invalid Object Type"
				detail="The type argument must be one of: record, dao, gateway, to, bean" />
		</cfif>
		
		<cfreturn creationPath & "." & arguments.type & ".mssql." & Iif(arguments.base, DE('base.'), DE('')) & arguments.name & arguments.type  />
	</cffunction>
	
	<cffunction name="getObjectPath" access="private" hint="I return the path to the type of object specified." output="false" returntype="string">
		<cfargument name="type" hint="I am the type of object to return.  Options are: record, dao, gateway, to" required="yes" type="string" />
		<cfargument name="name" hint="I am the name of the table to get the structure XML for." required="yes" type="string" />
		<cfargument name="class" hint="I indicate if the 'class' of object to return.  Options are: base, custom" required="yes" type="string" />
		
		<cfif NOT ListFindNoCase("record,dao,gateway,to,bean", arguments.type)>
			<cfthrow type="reactor.InvalidArgument"
				message="Invalid Type Argument"
				detail="The type argument must be one of: record, dao, gateway, to, bean" />
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