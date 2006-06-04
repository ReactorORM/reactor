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
		<cfargument name="type" hint="I am the type of object to create.  Options are: To, Dao, Gateway, Record, Metadata, Validator" required="yes" type="string" />
		<cfargument name="plugin" hint="I indicate if this is generating a plugin" required="yes" type="boolean" />
		<cfset var objectXML = getObject().getXml() />
		<cfset var pathToErrorFile = "" />
		
		<!--- write the project object --->
		<cfset generate(
			objectXML,
			getDirectoryFromPath(getCurrentTemplatePath()) & "../#Iif(arguments.plugin, De("plugins"), De("xsl"))#/#lcase(arguments.type)#.project.xsl",
			getObjectPath(arguments.type, objectXML.object.XmlAttributes.alias, "Project", arguments.plugin),
			true) />
		
		<!--- write the base object --->
		<cfset generate(
			objectXML,
			getDirectoryFromPath(getCurrentTemplatePath()) & "../#Iif(arguments.plugin, De("plugins"), De("xsl"))#/#lcase(arguments.type)#.base.xsl",
			getObjectPath(arguments.type, objectXML.object.XmlAttributes.alias, "Base", arguments.plugin),
			false) />
		
		<!--- generate the custom object --->
		<cfset generate(
			objectXML,
			getDirectoryFromPath(getCurrentTemplatePath()) & "../#Iif(arguments.plugin, De("plugins"), De("xsl"))#/#lcase(arguments.type)#.custom.xsl",
			getObjectPath(arguments.type, objectXML.object.XmlAttributes.alias, "Custom", arguments.plugin),
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
			<cflock type="exclusive" timeout="30">
				<cffile action="write" file="#arguments.outputPath#" output="#code#" />
			</cflock>
		</cfif>
	</cffunction>
	
	<!--- generateDictionary --->
	<cffunction name="generateDictionary" access="public" hint="I generate the xml for a dictionary.xml file" output="false" returntype="void">
		<cfargument name="dictionaryXmlPath" hint="I am the path to the dictionary xml file." required="yes" type="string" />
		<cfset var alias = getObject().getAlias() />
		<cfset var dictionaryXml = "<#alias# />" />
		<cfset var initialDictionaryXml = 0 />
		<cfset var fields = Object.getFields() />
		<cfset var field = 0 />
		<cfset var x = 0 />
		<cfset arguments.dictionaryXmlPath = ExpandPath(arguments.dictionaryXmlPath)  />
		
		<!--- check to see if the dictionary.xml file exists at all --->
		<cfif NOT FileExists(arguments.dictionaryXmlPath)>
			<!--- insure the outputPath directory exists --->
			<cfset insurePathExists(arguments.dictionaryXmlPath)>
		<cfelse>
			<!--- read the dictionary Xml file --->
			<cffile action="read" file="#arguments.dictionaryXmlPath#" variable="dictionaryXml" />
		</cfif>
		
		<!--- parse the dictionaryXml --->
		<cfset dictionaryXml = XMLParse(dictionaryXml, false) />
		<cfset initialDictionaryXml = Duplicate(dictionaryXml) />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<!--- grab a specific field --->
			<cfset field = fields[x] />
			
			<!--- insure the field exists --->
			<cfset paramNode(dictionaryXml, "/#alias#/#field.getName()#") />
				
			<!--- insure a label exists --->
			<cfset paramNode(dictionaryXml, "/#alias#/#field.getName()#/label", field.getName()) />
			
			<!--- insure a comment exists --->
			<cfset paramNode(dictionaryXml, "/#alias#/#field.getName()#/comment", "") />
			
			<!--- insure a maxLength exists --->
			<cfset paramNode(dictionaryXml, "/#alias#/#field.getName()#/maxlength", field.getLength()) />
			
			<!--- required validation error message --->
			<cfif NOT fields[x].getNullable()>
				<cfset paramNode(dictionaryXml, "/#alias#/#field.getName()#/notProvided", "The #field.getName()# field is required but was not provided.") />
			</cfif>
			
			<!--- data type validation error message --->
			<cfset paramNode(dictionaryXml, "/#alias#/#field.getName()#/invalidType", "The #field.getName()# field does not contain valid data.  This field must be a #fields[x].getCfDataType()# value.") />
					
			<!--- size validataion error message --->
			<cfif field.getLength()>
				<cfset paramNode(dictionaryXml, "/#alias#/#field.getName()#/invalidLength", "The #field.getName()# field is too long.  This field must be no more than #field.getLength()# bytes long.") />
			</cfif>			
		</cfloop>
		
		<!--- if the initial xml and the new xml are different, format the xml and write it back to the dictionary xml file --->
		<cfif dictionaryXml IS NOT initialDictionaryXml>
			<cflock type="exclusive" timeout="30">
				<cffile action="write" file="#arguments.dictionaryXmlPath#" output="#formatXml(dictionaryXml)#" />
			</cflock>
		</cfif>
	</cffunction>
	
	<!--- paramNode --->
	<cffunction name="paramNode" access="private" hint="I insure that an xml node exists.  If not, I create it and set it to a default value." output="false" returntype="void">
		<cfargument name="xml" hint="I am the xml document" required="yes" type="string" />
		<cfargument name="pathToNode" hint="I am the xpath path to the parent node." required="yes" type="string" />
		<cfargument name="value" hint="I am the default value for the node." required="no" type="string" default="" />
		<cfset var matches = 0 />
		<cfset var node = 0 />
		<cfset var parentNodePath = 0 />
		<cfset var parentNode = 0 />
		
		<!--- search to see if path exists in the document --->
		<cfset matches = XmlSearch(arguments.xml, arguments.pathToNode) />
		
		<!--- if the path doesn't exist, create it --->
		<cfif NOT ArrayLen(matches)>
			<!--- get the parent node path --->
			<cfset parentNodePath = ListDeleteAt(arguments.pathToNode, ListLen(arguments.pathToNode, "/"), "/") />
			
			<!--- first, make sure that the specified parent exists --->
			<cfset paramNode(arguments.xml, parentNodePath) />
			
			<!--- create the node --->
			<cfset node = XMLElemNew(arguments.xml, ListLast(arguments.pathToNode, "/")) />
			
			<!--- if a value has been provided, set it. --->
			<cfif Len(arguments.value)>
				<cfset node.XmlText = arguments.value />
			</cfif>
			
			<!--- get the parent Node --->
			<cfset parentNode = XmlSearch(arguments.xml, parentNodePath) />
			<cfset parentNode = parentNode[1] />
			
			<!--- add the new node to its parent --->
			<cfset ArrayAppend(parentNode.XmlChildren, node) />
		</cfif>
	</cffunction>
	
	<cffunction name="getObjectPath" access="private" hint="I return the path to the type of object specified." output="false" returntype="string">
		<cfargument name="type" hint="I am the type of object to return.  Options are: Record, Dao, Gateway, To, Metadata, Validator" required="yes" type="string" />
		<cfargument name="name" hint="I am the name of the table to get the structure XML for." required="yes" type="string" />
		<cfargument name="class" hint="I indicate if the 'class' of object to return.  Options are: Project, Base, Custom" required="yes" type="string" />
		<cfargument name="plugin" hint="I indicate if this is generating a plugin" required="yes" type="boolean" />
		<cfset var root = "" />
		
		<cfif arguments.class IS "Project">
			<cfset root = "#getDirectoryFromPath(getCurrentTemplatePath())#../project/" & getConfig().getProject() & "/#Iif(arguments.plugin, De("Plugins/"), De(""))#" & arguments.type & "/" />
			<cfreturn root & arguments.name & arguments.type & ".cfc" />
		
		<cfelseif arguments.class IS "Base">
			<cfset root = expandPath(getConfig().getMapping() & "/#Iif(arguments.plugin, De("Plugins/"), De(""))#" & arguments.type & "/" ) />
			<cfreturn root & arguments.name & arguments.type & ".cfc" />
		
		<cfelseif arguments.class IS "Custom">
			<cfset root = expandPath(getConfig().getMapping() & "/#Iif(arguments.plugin, De("Plugins/"), De(""))#" & arguments.type & "/" ) />
			<cfreturn root & arguments.name & arguments.type & getConfig().getType() & ".cfc" />
		
		</cfif>
		
	</cffunction>
	
	<cffunction name="formatXml" access="public" hint="I format xml to make it more easily human readable." output="false" returntype="string">
		<cfargument name="xml" hint="I am the xml to format." required="yes" type="string" />
		<cfset var newXmlDocument = "" />
		<cfset var splitXml = 0 />
		<cfset var x = 0 />
		<cfset var tabs = 0 />
		<cfset arguments.xml = ToString(arguments.xml) />
		
		<!--- remove extra crlfs and tabs --->
		<cfset arguments.xml = Trim(ReReplace(arguments.xml, "(?m)[\r\n]*[\t]*", "", "all")) />
		
		<!--- add the doctype to the newXmlDocument --->
		<cfset newXmlDocument = Trim(Mid(arguments.xml, 1, find(chr(10), arguments.xml))) />
		<cfset arguments.xml = Right(arguments.xml, Len(arguments.xml) - Len(newXmlDocument)) />
		
		<!--- add linebreaks before every tag --->
		<cfset arguments.xml = Replace(arguments.xml, "<", chr(13) & chr(10) & "<", "all") />

		<!--- fix all line breaks before close tags wrapping content --->
		<cfset arguments.xml = ReReplace(arguments.xml, "(?m)([^>])([\r][\n]|[\n])</", "\1</", "all") />

		<cfset splitXml = ListToArray(arguments.xml, chr(13) & chr(10)) />

		<cfloop from="1" to="#ArrayLen(splitXml)#" index="x">
			<cfif Left(splitXml[x], 2) IS "</">
				<cfset tabs = tabs - 1 />
			</cfif>
			
			<cfset newXmlDocument = newXmlDocument & chr(13) & chr(10) & RepeatString(chr(9), tabs) & splitXml[x] />
			
			<cfif NOT Find("/", splitXml[x], 1)>
				<cfset tabs = tabs + 1 />
			</cfif>
			
		</cfloop>

		<cfreturn Trim(newXmlDocument) />
	</cffunction>
	
	<cffunction name="insurePathExists" access="private" hint="I insure the directories for the path to the specified exist" output="false" returntype="void">
		<cfargument name="path" hint="I am the path to the file." required="yes" type="string" />
		<cfset var directory = getDirectoryFromPath(arguments.path) />
		
		<cfif NOT DirectoryExists(directory)>
			<cfdirectory action="create" directory="#getDirectoryFromPath(arguments.path)#" />
		</cfif>
	</cffunction>
	
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
