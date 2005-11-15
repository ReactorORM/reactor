<cfcomponent hint="I am a component which translates a database objects into xml documents">

	<!--- <cfset variables.Object = 0 /> --->
	<cfset variables.Config = 0 />
	
	<cffunction name="init" access="public" hint="I configure and return the objectTranslator" output="false" returntype="reactor.core.objectTranslator">
		<cfargument name="config" hint="I am a reactor config object" required="yes" type="reactor.config.config" />
		<!--- <cfargument name="name" hint="I am a mapping to the location where objects are created." required="yes" type="string" />
		<cfset var Object = CreateObject("Component", "reactor.core.object").init(arguments.name) />
		<cfset var ObjectDao = CreateObject("Component", "reactor.data.#arguments.config.getType()#.ObjectDao").init(arguments.config.getDsn()) />		
		<cfset ObjectDao.read(Object) /> --->
		
		<cfset setConfig(arguments.config) />
		<!--- <cfset setObject(Object) /> --->
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getObject" access="private" hint="I read and return the object" output="false" returntype="reactor.core.object">
		<cfargument name="name" hint="I am the name of the object to translate." required="yes" type="string" />
		<cfset var Object = CreateObject("Component", "reactor.core.object").init(arguments.name) />
		<cfset var ObjectDao = CreateObject("Component", "reactor.data.#getConfig().getType()#.ObjectDao").init(getConfig().getDsn()) />		
		
		<cfset ObjectDao.read(Object) />
		
		<cfreturn Object />
	</cffunction>
	
	<cffunction name="getSignature" access="public" hint="I get this table's signature" output="false" returntype="string">
		<cfargument name="name" hint="I am the name of the object to translate." required="yes" type="string" />
		<cfreturn getXml(arguments.name).object.XmlAttributes.signature />
	</cffunction>
		
	<cffunction name="getXml" access="public" hint="I return this table expressed as an XML document" output="false" returntype="string">
		<cfargument name="name" hint="I am the name of the object to translate." required="yes" type="string" />
		<cfargument name="temp" required="no" default="0" />
		<cfset var Config = getConfig().getObjectConfig(arguments.name) />
		<cfset var Object = getObject(arguments.name) />
		<cfset var columns = Object.getColumns() />
		<cfset var column = 0 />
		<cfset var overriddenColumns = 0 />
		<cfset var x = 0 />
		<cfset var y = 0 />
				
		<!--- if this object has a super object read that and add it into this --->
		<cfif IsDefined("Config.object.super.XmlAttributes.name")>	
			<!--- create a new object node --->
			<cfset ArrayAppend(Config.object.super.XmlChildren, XMLElemNew(Config, "object")) />
			<cfset copyNode(Config, Config.object.super.object, getXml(Config.object.super.XmlAttributes.name, temp + 1).object) />
		</cfif>
		
		<!--- add the columns to the config settings --->
		<cfset Config.Object.columns = XMLElemNew(Config, "columns") />
		<cfloop from="1" to="#ArrayLen(columns)#" index="x">
			<!--- create the column node--->
			<cfset ArrayAppend(Config.Object.columns.XmlChildren, XMLElemNew(Config, "column")) />
			<cfset column = Config.Object.columns.XmlChildren[ArrayLen(Config.Object.columns.XmlChildren)] />
			
			<!--- get any super columns with the same name and override them --->
			<cfif IsDefined("Config.object.super.XmlAttributes.name")>	
				<cfset overriddenColumns = XmlSearch(Config, "/object/super/object/columns/column[@name = '#columns[x].getName()#']") />
				<cfif ArrayLen(overriddenColumns)>
					<cfloop from="1" to="#ArrayLen(overriddenColumns)#" index="y">
						<cfset overriddenColumns[y].XmlAttributes["overridden"] = 'true' />
					</cfloop>
				</cfif>
			</cfif>
			
			<!--- set the column's properties --->
			<cfset column.XmlAttributes["name"] = columns[x].getName() />
			<cfset column.XmlAttributes["primaryKey"] = columns[x].getPrimaryKey() />
			<cfset column.XmlAttributes["identity"] = columns[x].getIdentity() />
			<cfset column.XmlAttributes["nullable"] = columns[x].getNullable() />
			<cfset column.XmlAttributes["dbDataType"] = columns[x].getDbDataType() />
			<cfset column.XmlAttributes["cfDataType"] = columns[x].getCfDataType() />
			<cfset column.XmlAttributes["cfSqlType"] = columns[x].getCfSqlType() />
			<cfset column.XmlAttributes["length"] = columns[x].getLength() />
			<cfset column.XmlAttributes["default"] = columns[x].getDefault() />
			<cfset column.XmlAttributes["overridden"] = 'false' />
		</cfloop>
		
		<!--- set the base config settings --->
		<cfset Config.Object.XmlAttributes["owner"] = Object.getOwner() />
		<cfset Config.Object.XmlAttributes["type"] = Object.getType() />
		<cfset Config.Object.XmlAttributes["database"] = Object.getDatabase() />
		
		<!--- config meta data required for generating objects --->
		<cfset Config.Object.XmlAttributes["mapping"] = getConfig().getMappingObjectStem() />
		<cfset Config.Object.XmlAttributes["dbms"] = getConfig().getType() />
		
		<!--- add the object's signature --->
		<cfset Config.Object.XmlAttributes["signature"] = Hash(ToString(Config)) />
			
		<cfreturn Config />
	</cffunction>
	
	
	<cffunction name="copyNode" access="private"  hint="Copies a node from one document into a second document.  (This code was coppied from Skike's blog at http://www.spike.org.uk/blog/index.cfm?do=blog.cat&catid=8245E3A4-D565-E33F-39BC6E864D6B5DAA)" output="false" returntype="void">
		<cfargument name="xmlDoc" hint="I am the document to copy the nodes into" required="yes" type="any">
		<cfargument name="newNode" hint="I am the node to copy the nodes into" required="yes" type="any">
		<cfargument name="oldNode" hint="I am the node to copy the nodes from" required="yes" type="any">
	
		<cfset var key = "" />
		<cfset var index = "" />
		<cfset var i = "" />
		
		<cfif len(trim(oldNode.xmlComment))>		
			<cfset newNode.xmlComment = trim(oldNode.xmlComment) />
		</cfif>
	
		<cfif len(trim(oldNode.xmlCData))>
			<cfset newNode.xmlCData = trim(oldNode.xmlCData)>
		</cfif>
		
		<cfset newNode.xmlAttributes = oldNode.xmlAttributes>
		
		<cfset newNode.xmlText = trim(oldNode.xmlText) />
		
		<cfloop from="1" to="#arrayLen(oldNode.xmlChildren)#" index="i">
			<cfset newNode.xmlChildren[i] = xmlElemNew(xmlDoc,oldNode.xmlChildren[i].xmlName) />
			<cfset copyNode(xmlDoc,newNode.xmlChildren[i],oldNode.xmlChildren[i]) />
		</cfloop>
	</cffunction>
	
	<!--- 
	<cffunction name="copyNodes" access="private" hint="I copy an XML object's nodes into another XML object." output="false" returntype="void">
		<cfargument name="document" hint="I am the destination document." required="yes" type="xml" />
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
	
	<!--- <cffunction name="generateErrorMessages" access="public" hint="I genereate / populate the ErrorMessages.xml file" output="false" returntype="void">
		<cfargument name="pathToErrorFile" hint="I am the path to the ErrorMessages.xml file." required="yes" type="string" />
		<cfargument name="name" hint="I am the name of the object to translate." required="yes" type="string" />
		<cfset var XmlErrors = "" />
		<cfset var XmlSearchResult = "" />
		<cfset var columns = getObject().getColumns() />
		<cfset var tableNode = 0 />
		<cfset var columnNode = 0 />
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
		<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getObject().getName()#']") />
		<cfif NOT ArrayLen(XmlSearchResult)>
			<cfset ArrayAppend(XmlErrors.tables.XmlChildren, XMLElemNew(XmlErrors, "table")) />
			<cfset tableNode = XmlErrors.tables.XmlChildren[ArrayLen(XmlErrors.tables.XmlChildren)] />
			<cfset tableNode.XmlAttributes["name"] = getObject().getName() />
		<cfelse>
			<cfset tableNode = XmlSearchResult[1] />
		</cfif>
		
		<!--- insure a node exists for all columns --->
		<cfloop from="1" to="#ArrayLen(columns)#" index="x">
			<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getObject().getName()#']/column[@name = '#columns[x].getName()#']") />
			<cfif NOT ArrayLen(XmlSearchResult)>
				<cfset ArrayAppend(tableNode.XmlChildren, XMLElemNew(XmlErrors, "column")) />
				<cfset columnNode = tableNode.XmlChildren[ArrayLen(tableNode.XmlChildren)] />
				<cfset columnNode.XmlAttributes["name"] = columns[x].getName() />
			<cfelse>
				<cfset columnNode = XmlSearchResult[1] />
			</cfif>
			
			<!--- insure that all applicable error messages have been created for this columnNode --->
			<cfswitch expression="#columns[x].getDataType()#">
				<cfcase value="binary">
					<!--- required validation error message --->
					<cfif NOT columns[x].getNullable()>
						<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getObject().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'notProvided']") />
						<cfif NOT ArrayLen(XmlSearchResult)>
							<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
							<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
							<cfset errorMessageNode.XmlAttributes["name"] = "notProvided" />
							<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field is required but was not provided." />
						</cfif>
					</cfif>
					
					<!--- datatype validate error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getObject().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'invalidType']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidType" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field must be true or false." />
					</cfif>
					
					<!--- size validataion error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getObject().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'invalidLength']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidLength" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field is too long.  This field must be no more than #columns[x].getLength()# bytes long." />
					</cfif>
				</cfcase>
				<cfcase value="boolean">
					<!--- required validation error message --->
					<cfif NOT columns[x].getNullable()>
						<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getObject().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'notProvided']") />
						<cfif NOT ArrayLen(XmlSearchResult)>
							<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
							<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
							<cfset errorMessageNode.XmlAttributes["name"] = "notProvided" />
							<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field is required but was not provided." />
						</cfif>
					</cfif>
					
					<!--- datatype validate error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getObject().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'invalidType']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidType" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field must be a true or false value." />
					</cfif>
				</cfcase>
				<cfcase value="date">
					<!--- required validation error message --->
					<cfif NOT columns[x].getNullable()>
						<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getObject().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'notProvided']") />
						<cfif NOT ArrayLen(XmlSearchResult)>
							<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
							<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
							<cfset errorMessageNode.XmlAttributes["name"] = "notProvided" />
							<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field is required but was not provided." />
						</cfif>
					</cfif>
					
					<!--- datatype validate error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getObject().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'invalidType']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidType" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field must be a date value." />
					</cfif>
				</cfcase>
				<cfcase value="numeric">
					<!--- required validation error message --->
					<cfif NOT columns[x].getNullable()>
						<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getObject().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'notProvided']") />
						<cfif NOT ArrayLen(XmlSearchResult)>
							<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
							<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
							<cfset errorMessageNode.XmlAttributes["name"] = "notProvided" />
							<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field is required but was not provided." />
						</cfif>
					</cfif>
					
					<!--- datatype validate error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getObject().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'invalidType']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidType" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field must be a numeric value." />
					</cfif>
				</cfcase>
				<cfcase value="string">
					<!--- required validation error message --->
					<cfif NOT columns[x].getNullable()>
						<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getObject().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'notProvided']") />
						<cfif NOT ArrayLen(XmlSearchResult)>
							<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
							<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
							<cfset errorMessageNode.XmlAttributes["name"] = "notProvided" />
							<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field is required but was not provided." />
						</cfif>
					</cfif>
					
					<!--- datatype validate error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getObject().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'invalidType']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidType" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field must be a string value." />
					</cfif>
					
					<!--- size validataion error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getObject().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'invalidLength']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidLength" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field is too long.  This field must be no more than #columns[x].getLength()# characters long." />
					</cfif>
				</cfcase>
			</cfswitch>
		</cfloop>
		
		<!--- format the xml and write it back to the ErrorFile --->
		<cflock type="exclusive" timeout="30">
			<cffile action="write" file="#pathToErrorFile#" output="#FormatErrorXml(XmlErrors)#" />
		</cflock>
	</cffunction>
	
	<cffunction name="FormatErrorXml" access="public" hint="I format the Xml Errors doc to make it more easily human readable." output="false" returntype="string">
		<cfargument name="XmlErrors" hint="I am the xml error document to format." required="yes" type="xml" />
		<cfset arguments.XmlErrors = ToString(arguments.XmlErrors) />
		
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*<table ", chr(13) & chr(10) & chr(9) & "<table ", "all") />
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*</table>", chr(13) & chr(10) & chr(9) & "</table>", "all") />
		
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*<column ", chr(13) & chr(10) & chr(9) & chr(9) & "<column ", "all") />
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*</column>", chr(13) & chr(10) & chr(9) & chr(9) & "</column>", "all") />
		
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*<errorMessage ", chr(13) & chr(10) & chr(9) & chr(9) & chr(9) & "<errorMessage ", "all") />
		
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*</tables>", chr(13) & chr(10) & "</tables>", "all") />
		
		<cfreturn arguments.XmlErrors />
	</cffunction> --->
	
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
</cfcomponent>