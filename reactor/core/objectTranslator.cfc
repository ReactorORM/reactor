<cfcomponent hint="I am a component which translates a database objects into xml documents">

	<cfset variables.Config = 0 />
	<cfset variables.Object = 0 />
	<cfset variables.ObjectFactory = 0 />
	
	<cffunction name="init" access="public" hint="I configure and return the objectTranslator" output="false" returntype="reactor.core.objectTranslator">
		<cfargument name="Config" hint="I am a reactor config object" required="yes" type="reactor.config.config" />
		<cfargument name="Object" hint="I am the object being transformed" required="yes" type="reactor.core.object" />
		<cfargument name="ObjectFactory" hint="I am the object factory used to generate any dependant objects" required="yes" type="reactor.core.objectFactory" />
		
		<cfset setConfig(arguments.config) />
		<cfset setObject(arguments.Object) />
		<cfset setObjectFactory(arguments.ObjectFactory) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="generateObject" access="public" hint="I generate a To object" output="false" returntype="void">
		<cfargument name="type" hint="I am the type of object to create.  Options are: To, Dao, Gateway, Record, Metadata" required="yes" type="string" />
		<cfset var objectXML = getObject().getXml() />
		<cfset var pathToErrorFile = "" />
		
		<!--- if this is a Record object we're genereating then we need to generate/populate the ErrorMessages.xml file --->
		<cfif arguments.type IS "Record">
			<!--- I am the path to the error file --->
			<cfset pathToErrorFile = expandPath(getConfig().getMapping() & "/ErrorMessages.xml" ) />
			<!--- if the file doesn't exist insure the path to the file exists --->
			<cfset insurePathExists(pathToErrorFile) />
			<!--- generate the error messages --->
			<cfset generateErrorMessages(pathToErrorFile) />
		</cfif>
		
		<!--- write the project object --->
		<cfset generate(
			objectXML,
			getDirectoryFromPath(getCurrentTemplatePath()) & "../xsl/#lcase(arguments.type)#.project.xsl",
			getObjectPath(arguments.type, objectXML.object.XmlAttributes.alias, "Project"),
			true) />
		
		<!--- write the base object --->
		<cfset generate(
			objectXML,
			getDirectoryFromPath(getCurrentTemplatePath()) & "../xsl/#lcase(arguments.type)#.base.xsl",
			getObjectPath(arguments.type, objectXML.object.XmlAttributes.alias, "Base"),
			false) />
		
		<!--- generate the custom object --->
		<cfset generate(
			objectXML,
			getDirectoryFromPath(getCurrentTemplatePath()) & "../xsl/#lcase(arguments.type)#.custom.xsl",
			getObjectPath(arguments.type, objectXML.object.XmlAttributes.alias, "Custom"),
			false) />
			
	</cffunction>
	
	<cffunction name="generate" access="private" hint="I transform the XML via the specified XSL file and output to the provided path, overwritting it configured to do so." output="false" returntype="void">
		<cfargument name="objectXML" hint="I am the object's XML to transform." required="yes" type="string" />
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
			<cfset code = XMLTransform(arguments.objectXML, xsl) />
			<!--- insure the outputPath directory exists --->
			<cfset insurePathExists(arguments.outputPath)>
			<!--- write the file to disk --->
			<cffile action="write" file="#arguments.outputPath#" output="#code#" />
		</cfif>
	</cffunction>	

	<!--- generateErrorMessages --->
	<cffunction name="generateErrorMessages" access="public" hint="I genereate / populate the ErrorMessages.xml file" output="false" returntype="void">
		<cfargument name="pathToErrorFile" hint="I am the path to the ErrorMessages.xml file." required="yes" type="string" />
		<cfset var XmlErrors = "" />
		<cfset var XmlSearchResult = "" />
		<cfset var Object = getObject() />
		<cfset var fields = Object.getFields() />
		<cfset var tableNode = 0 />
		<cfset var fieldNode = 0 />
		<cfset var errorMessageNode = 0 />
		
		<!--- check to see if the error file exists --->
		<cfif NOT FileExists(pathToErrorFile) > 
			<cfsavecontent variable="XmlErrors">
				<tables />
			</cfsavecontent>
		<cfelse>
			<!--- read the file --->
			<cffile action="read" file="#pathToErrorFile#" variable="XmlErrors" />
			<cfset tableExists = true />
		</cfif>
		
		<!--- parse the xml --->
		<cfset XmlErrors = XmlParse(XmlErrors) />
		
		<!--- insure a node exists for this table --->
		<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#Object.getName()#']") />
		<cfif NOT ArrayLen(XmlSearchResult)>
			<cfset ArrayAppend(XmlErrors.tables.XmlChildren, XMLElemNew(XmlErrors, "table")) />
			<cfset tableNode = XmlErrors.tables.XmlChildren[ArrayLen(XmlErrors.tables.XmlChildren)] />
			<cfset tableNode.XmlAttributes["name"] = Object.getName() />
		<cfelse>
			<cfset tableNode = XmlSearchResult[1] />
		</cfif>
		
		<!--- insure a node exists for all fields --->
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#Object.getName()#']/field[@name = '#fields[x].getName()#']") />
			<cfif NOT ArrayLen(XmlSearchResult)>
				<cfset ArrayAppend(tableNode.XmlChildren, XMLElemNew(XmlErrors, "field")) />
				<cfset fieldNode = tableNode.XmlChildren[ArrayLen(tableNode.XmlChildren)] />
				<cfset fieldNode.XmlAttributes["name"] = fields[x].getName() />
			<cfelse>
				<cfset fieldNode = XmlSearchResult[1] />
			</cfif>
			
			<!--- insure that all applicable error messages have been created for this fieldNode --->
			<cfswitch expression="#fields[x].getCfDataType()#">
				<cfcase value="binary">
					<!--- required validation error message --->
					<cfif NOT fields[x].getNullable()>
						<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#Object.getName()#']/field[@name = '#fields[x].getName()#']/errorMessage[@name = 'notProvided']") />
						<cfif NOT ArrayLen(XmlSearchResult)>
							<cfset ArrayAppend(fieldNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
							<cfset errorMessageNode = fieldNode.XmlChildren[ArrayLen(fieldNode.XmlChildren)] />
							<cfset errorMessageNode.XmlAttributes["name"] = "notProvided" />
							<cfset errorMessageNode.XmlAttributes["message"] = "The #fields[x].getName()# field is required but was not provided." />
						</cfif>
					</cfif>
					
					<!--- datatype validate error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#Object.getName()#']/field[@name = '#fields[x].getName()#']/errorMessage[@name = 'invalidType']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(fieldNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = fieldNode.XmlChildren[ArrayLen(fieldNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidType" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #fields[x].getName()# field must be true or false." />
					</cfif>
					
					<!--- size validataion error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#Object.getName()#']/field[@name = '#fields[x].getName()#']/errorMessage[@name = 'invalidLength']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(fieldNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = fieldNode.XmlChildren[ArrayLen(fieldNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidLength" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #fields[x].getName()# field is too long.  This field must be no more than #fields[x].getLength()# bytes long." />
					</cfif>
				</cfcase>
				<cfcase value="boolean">
					<!--- required validation error message --->
					<cfif NOT fields[x].getNullable()>
						<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#Object.getName()#']/field[@name = '#fields[x].getName()#']/errorMessage[@name = 'notProvided']") />
						<cfif NOT ArrayLen(XmlSearchResult)>
							<cfset ArrayAppend(fieldNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
							<cfset errorMessageNode = fieldNode.XmlChildren[ArrayLen(fieldNode.XmlChildren)] />
							<cfset errorMessageNode.XmlAttributes["name"] = "notProvided" />
							<cfset errorMessageNode.XmlAttributes["message"] = "The #fields[x].getName()# field is required but was not provided." />
						</cfif>
					</cfif>
					
					<!--- datatype validate error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#Object.getName()#']/field[@name = '#fields[x].getName()#']/errorMessage[@name = 'invalidType']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(fieldNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = fieldNode.XmlChildren[ArrayLen(fieldNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidType" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #fields[x].getName()# field must be a true or false value." />
					</cfif>
				</cfcase>
				<cfcase value="date">
					<!--- required validation error message --->
					<cfif NOT fields[x].getNullable()>
						<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#Object.getName()#']/field[@name = '#fields[x].getName()#']/errorMessage[@name = 'notProvided']") />
						<cfif NOT ArrayLen(XmlSearchResult)>
							<cfset ArrayAppend(fieldNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
							<cfset errorMessageNode = fieldNode.XmlChildren[ArrayLen(fieldNode.XmlChildren)] />
							<cfset errorMessageNode.XmlAttributes["name"] = "notProvided" />
							<cfset errorMessageNode.XmlAttributes["message"] = "The #fields[x].getName()# field is required but was not provided." />
						</cfif>
					</cfif>
					
					<!--- datatype validate error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#Object.getName()#']/field[@name = '#fields[x].getName()#']/errorMessage[@name = 'invalidType']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(fieldNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = fieldNode.XmlChildren[ArrayLen(fieldNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidType" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #fields[x].getName()# field must be a date value." />
					</cfif>
				</cfcase>
				<cfcase value="numeric">
					<!--- required validation error message --->
					<cfif NOT fields[x].getNullable()>
						<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#Object.getName()#']/field[@name = '#fields[x].getName()#']/errorMessage[@name = 'notProvided']") />
						<cfif NOT ArrayLen(XmlSearchResult)>
							<cfset ArrayAppend(fieldNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
							<cfset errorMessageNode = fieldNode.XmlChildren[ArrayLen(fieldNode.XmlChildren)] />
							<cfset errorMessageNode.XmlAttributes["name"] = "notProvided" />
							<cfset errorMessageNode.XmlAttributes["message"] = "The #fields[x].getName()# field is required but was not provided." />
						</cfif>
					</cfif>
					
					<!--- datatype validate error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#Object.getName()#']/field[@name = '#fields[x].getName()#']/errorMessage[@name = 'invalidType']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(fieldNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = fieldNode.XmlChildren[ArrayLen(fieldNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidType" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #fields[x].getName()# field must be a numeric value." />
					</cfif>
				</cfcase>
				<cfcase value="string">
					<!--- required validation error message --->
					<cfif NOT fields[x].getNullable()>
						<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#Object.getName()#']/field[@name = '#fields[x].getName()#']/errorMessage[@name = 'notProvided']") />
						<cfif NOT ArrayLen(XmlSearchResult)>
							<cfset ArrayAppend(fieldNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
							<cfset errorMessageNode = fieldNode.XmlChildren[ArrayLen(fieldNode.XmlChildren)] />
							<cfset errorMessageNode.XmlAttributes["name"] = "notProvided" />
							<cfset errorMessageNode.XmlAttributes["message"] = "The #fields[x].getName()# field is required but was not provided." />
						</cfif>
					</cfif>
					
					<!--- datatype validate error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#Object.getName()#']/field[@name = '#fields[x].getName()#']/errorMessage[@name = 'invalidType']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(fieldNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = fieldNode.XmlChildren[ArrayLen(fieldNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidType" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #fields[x].getName()# field must be a string value." />
					</cfif>
					
					<!--- size validataion error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#Object.getName()#']/field[@name = '#fields[x].getName()#']/errorMessage[@name = 'invalidLength']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(fieldNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = fieldNode.XmlChildren[ArrayLen(fieldNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidLength" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #fields[x].getName()# field is too long.  This field must be no more than #fields[x].getLength()# characters long." />
					</cfif>
				</cfcase>
			</cfswitch>
		</cfloop>
		
		<!--- format the xml and write it back to the ErrorFile --->
		<cflock type="exclusive" timeout="30">
			<cffile action="write" file="#pathToErrorFile#" output="#FormatErrorXml(XmlErrors)#" />
		</cflock>
	</cffunction>
	
	<cffunction name="getObjectPath" access="private" hint="I return the path to the type of object specified." output="false" returntype="string">
		<cfargument name="type" hint="I am the type of object to return.  Options are: Record, Dao, Gateway, To" required="yes" type="string" />
		<cfargument name="name" hint="I am the name of the table to get the structure XML for." required="yes" type="string" />
		<cfargument name="class" hint="I indicate if the 'class' of object to return.  Options are: Project, Base, Custom" required="yes" type="string" />
		<cfset var root = "" />
		
		<cfif NOT ListFind("Record,Dao,Gateway,To,Metadata", arguments.type)>
			<cfthrow type="reactor.InvalidArgument"
				message="Invalid Type Argument"
				detail="The type argument must be one of: Record, Dao, Gateway, To, Metadata" />
		</cfif>
		<cfif NOT ListFind("Project,Base,Custom", arguments.class)>
			<cfthrow type="reactor.InvalidArgument"
				message="Invalid Class Argument"
				detail="The class argument must be one of: Project, Base, Custom" />
		</cfif>
	
		<cfif arguments.class IS "Project">
			<!--- removed & getConfig().getType() & "/" from the following line of code --->
			<cfset root = "#getDirectoryFromPath(getCurrentTemplatePath())#../project/" & getConfig().getProject() & "/" & arguments.type & "/" />
			<cfreturn root & arguments.name & arguments.type & ".cfc" />
		
		<cfelseif arguments.class IS "Base">
			<cfset root = expandPath(getConfig().getMapping() & "/" & arguments.type & "/" ) />
			<cfreturn root & arguments.name & arguments.type & ".cfc" />
		
		<cfelseif arguments.class IS "Custom">
			<cfset root = expandPath(getConfig().getMapping() & "/" & arguments.type & "/" ) />
			<cfreturn root & arguments.name & arguments.type & getConfig().getType() & ".cfc" />
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="FormatErrorXml" access="public" hint="I format the Xml Errors doc to make it more easily human readable." output="false" returntype="string">
		<cfargument name="XmlErrors" hint="I am the xml error document to format." required="yes" type="string" />
		<cfset arguments.XmlErrors = ToString(arguments.XmlErrors) />
		
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*<table ", chr(13) & chr(10) & chr(9) & "<table ", "all") />
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*</table>", chr(13) & chr(10) & chr(9) & "</table>", "all") />
		
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*<field ", chr(13) & chr(10) & chr(9) & chr(9) & "<field ", "all") />
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*</field>", chr(13) & chr(10) & chr(9) & chr(9) & "</field>", "all") />
		
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*<errorMessage ", chr(13) & chr(10) & chr(9) & chr(9) & chr(9) & "<errorMessage ", "all") />
		
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*</tables>", chr(13) & chr(10) & "</tables>", "all") />
		
		<cfreturn arguments.XmlErrors />
	</cffunction>
	
	<cffunction name="insurePathExists" access="private" hint="I insure the directories for the path to the specified exist" output="false" returntype="void">
		<cfargument name="path" hint="I am the path to the file." required="yes" type="string" />
		<cfset var directory = getDirectoryFromPath(arguments.path) />
		
		<cfif NOT DirectoryExists(directory)>
			<cfdirectory action="create" directory="#getDirectoryFromPath(arguments.path)#" />
		</cfif>
	</cffunction>
	
		
	<!--- 
	<cffunction name="copyNodes" access="private" hint="I copy an XML object's nodes into another XML object." output="false" returntype="void">
		<cfargument name="document" hint="I am the destination document." required="yes" type="string" />
		<cfargument name="destNode" hint="I am the destination node to copy into." required="yes" type="any" />
		<cfargument name="sourceNode" hint="I am the source node to copy from" required="yes" type="any" />
		<cfargument name="temp" required="no" default="1" />
		<cfset var attribute = 0 />
		<cfset var sourceChild = 0 />
		<cfset var x = 0 />
		
		<!--- copy attributes --->
		<cfloop collection="#arguments.sourceNode.XmlAttributes#" item="attribute">
			<cfset arguments.destNode.XmlAttributes[attribute] = arguments.sourceNode.XmlAttributes[attribute] />
		</cfloop>
		
		<!--- copy children --->
		<cfloop from="1" to="#ArrayLen(arguments.sourceNode.XmlChildren)#" index="x">
			<cfset sourceChild = arguments.sourceNode.XmlChildren[x] />
			<cfset destChild = XMLElemNew(document, sourceChild.XmlName) />
			<!--- add the destNode to the dest xml children --->
			<cfset ArrayAppend(arguments.destNode.XmlChildren, destChild) />
			
			
			<!--- copy the nodes --->
			<cfset copyNodes(arguments.document, Duplicate(destChild), sourceChild, temp + 1) />
			
			<cfif temp IS 1>
				<cfdump var="#arguments.destNode#" />
				<cfdump var="#arguments.sourceNode#" />
				<cfabort>
			</cfif>
		</cfloop>
		
	</cffunction>
	--->
	
	<!--- table
    <cffunction name="setObject" access="private" output="false" returntype="void">
       <cfargument name="table" hint="I am the table being translated" required="yes" type="reactor.core.object" />
       <cfset variables.Object = arguments.table />
    </cffunction>
    <cffunction name="getObject" access="private" output="false" returntype="reactor.core.object">
       <cfreturn variables.Object />
    </cffunction> --->
	
	<!--- config --->
    <cffunction name="setConfig" access="public" output="false" returntype="void">
       <cfargument name="config" hint="I am the config object used to configure reactor" required="yes" type="reactor.config.config" />
       <cfset variables.config = arguments.config />
    </cffunction>
    <cffunction name="getConfig" access="public" output="false" returntype="reactor.config.config">
       <cfreturn variables.config />
    </cffunction>
	
	<!--- object --->
    <cffunction name="setObject" access="private" output="false" returntype="void">
       <cfargument name="object" hint="I am the object being transformed." required="yes" type="reactor.core.Object" />
       <cfset variables.object = arguments.object />
    </cffunction>
    <cffunction name="getObject" access="private" output="false" returntype="reactor.core.Object">
       <cfreturn variables.object />
    </cffunction>
	
	<!--- objectFactory --->
    <cffunction name="setObjectFactory" access="private" output="false" returntype="void">
       <cfargument name="objectFactory" hint="I am the object factory used to generate any dependant objects" required="yes" type="reactor.core.objectFactory" />
       <cfset variables.objectFactory = arguments.objectFactory />
    </cffunction>
    <cffunction name="getObjectFactory" access="private" output="false" returntype="reactor.core.objectFactory">
       <cfreturn variables.objectFactory />
    </cffunction>
</cfcomponent>