<cfcomponent hint="I represent metadata about a database object.">

	<!---<cfset variables.config = "" />--->
	<cfset variables.Config = 0 />
	<cfset variables.Xml = 0 />
	<cfset variables.name = "" />
	<cfset variables.owner = "" />
	<cfset variables.type = "" />
	<cfset variables.database = "" />
	
	<cfset variables.fields = ArrayNew(1) />
	
	<cffunction name="init" access="public" hint="I configure the object." returntype="reactor.core.object">
		<cfargument name="name" hint="I am a mapping to the location where objects are created." required="yes" type="string" />
		<cfargument name="Config" hint="I am a reactor config object" required="yes" type="reactor.config.config" />
		
		<cfset setName(arguments.name) />
		<cfset setConfig(arguments.Config) />
		
		<!--- this creates the base XML document
		<cfset createXml() /> --->
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getSignature" access="public" hint="I get this table's signature" output="false" returntype="string">
		<cfreturn getXml().object.XmlAttributes.signature />
	</cffunction>
		
	<cffunction name="getXml" access="public" hint="I return this table expressed as an XML document" output="false" returntype="xml">
		<cfset var Config = getConfig().getObjectConfig(getName()) />
		<cfset var fields = getFields() />
		<cfset var linkerRelationships = 0 />
		<cfset var linkerRelationship = 0 />
		<cfset var newHasMany = 0 />
		<cfset var newRelationship = 0 />
		<cfset var x = 0 />
		<cfset var y = 0 />
		<cfset var z = 0 />
		
		<!--- add/validate relationship aliases --->
		<cfset var relationships = Config.object.XmlChildren />
		<cfset var relationship = 0 />
		<cfset var aliasList = "" />
		
		<!--- 
		Expand linked relationships.
		In otherwords, if the config indicates that this object links to another via a linking table, then copy the link into this xml document.
		 --->
		<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
			<cfset relationship = relationships[x] />
			
			<!--- if this is a has-many relationship with a link, expand it --->
			<cfif IsDefined("relationship.link")>
				<!--- get the relationships that the linking object has --->
				<cfset linkerRelationships = getConfig().getObjectConfig(relationship.link.XmlAttributes.name).object.XmlChildren />
								
				<!--- find links back to this object --->
				<cfloop from="1" to="#ArrayLen(linkerRelationships)#" index="y">
					<cfset linkerRelationship = linkerRelationships[y] />
					
					<!--- if this is a link back to this object copy the node into this document --->
					<cfif linkerRelationship.XmlAttributes.name IS arguments.name>
						<!--- create a hasMany relationship int this document --->
						<cfset newHasMany = XMLElemNew(Config, "hasMany") />
						<cfset newHasMany.XmlAttributes["name"] = relationship.link.XmlAttributes.name />
						<cfset newHasMany.XmlAttributes["alias"] = relationship.link.XmlAttributes.name />
						
						<!--- add all relationships --->
						<cfloop from="1" to="#ArrayLen(linkerRelationship.XmlChildren)#" index="z">
							<cfset newRelationship = XMLElemNew(Config, "relate") />
							<cfset newRelationship.XmlAttributes["from"] = linkerRelationship.XmlChildren[z].XmlAttributes.to />
							<cfset newRelationship.XmlAttributes["to"] = linkerRelationship.XmlChildren[z].XmlAttributes.from />
							
							<!--- add the relationship --->
							<cfset ArrayAppend(newHasMany.XmlChildren, newRelationship) />
						</cfloop>
						
						<!--- add the hasMany to the relationship --->
						<cfset ArrayAppend(relationships, newHasMany) />
						
					</cfif>
				</cfloop>
			</cfif>
			
			<cfif NOT IsDefined("relationship.XmlAttributes.alias")>
				<cfset relationship.XmlAttributes["alias"] = relationship.XmlAttributes.name />
				<!--- make sure this alias hasn't already been used --->
				<cfif ListFindNoCase(aliasList, relationship.XmlAttributes["alias"])>
					<!--- it's been used - throw an error --->
					<cfthrow message="Duplicate Relationship Or Alias" detail="The relationship or alias '#relationship.XmlAttributes["alias"]#' has already been used for the '#arguments.name#' object." type="reactor.getXml.DuplicateRelationshipOrAlias" />
				<cfelse>
					<!--- all this column to the list --->
					<cfset aliasList = ListAppend(aliasList, relationship.XmlAttributes["alias"]) />
				</cfif>
			</cfif>
		</cfloop>
		
		<!--- if this object has a super object read that and add it into this --->
		<cfif IsDefined("Config.object.super.XmlAttributes.name")>	
			<!--- create a new object node --->
			<cfset ArrayAppend(Config.object.super.XmlChildren, XMLElemNew(Config, "object")) />
			<cfset copyNode(Config, Config.object.super.object, getXml(Config.object.super.XmlAttributes.name).object) />
		</cfif>
		
		<!--- add the fields to the config settings --->
		<cfset Config.Object.fields = XMLElemNew(Config, "fields") />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfset addXmlField(fields[x], Config) />
		</cfloop>
		
		<!--- set the base config settings --->
		<cfset Config.Object.XmlAttributes["owner"] = getOwner() />
		<cfset Config.Object.XmlAttributes["type"] = getType() />
		<cfset Config.Object.XmlAttributes["database"] = getDatabase() />
		
		<!--- config meta data required for generating objects --->
		<cfset Config.Object.XmlAttributes["mapping"] = getConfig().getMappingObjectStem() />
		<cfset Config.Object.XmlAttributes["dbms"] = getConfig().getType() />
		
		<!--- add the object's signature --->
		<cfset Config.Object.XmlAttributes["signature"] = Hash(ToString(Config)) />
		
		<!---
		<cfdump var="#Config#" /><cfabort>
		--->
		
		<cfreturn Config />
	</cffunction>
	
	<cffunction name="addXmlField" access="private" hint="I add a field to the xml document." output="false" returntype="void">
		<cfargument name="field" hint="I am the field to add to the xml" required="yes" type="reactor.core.field" />
		<cfargument name="config" hint="I am the field to add to the xml" required="yes" type="xml" />
		<cfset var xmlField = 0 />
		<cfset var overriddenFields = 0 />
		
		<!--- create the field node--->
		<cfset xmlField = XMLElemNew(arguments.config, "field") />
		
		<!--- get any super fields with the same name and override them --->
		<cfif IsDefined("arguments.config.object.super.XmlAttributes.name")>	
			<cfset overriddenFields = XmlSearch(arguments.config, "/object/super/object/fields/field[@name = '#field.getName()#']") />
			<cfif ArrayLen(overriddenFields)>
				<cfloop from="1" to="#ArrayLen(overriddenFields)#" index="y">
					<cfset overriddenFields[y].XmlAttributes["overridden"] = 'true' />
				</cfloop>
			</cfif>
		</cfif>
		
		<!--- set the field's properties --->
		<cfset xmlField.XmlAttributes["name"] = arguments.field.getName() />
		<cfset xmlField.XmlAttributes["primaryKey"] = arguments.field.getPrimaryKey() />
		<cfset xmlField.XmlAttributes["identity"] = arguments.field.getIdentity() />
		<cfset xmlField.XmlAttributes["nullable"] = arguments.field.getNullable() />
		<cfset xmlField.XmlAttributes["dbDataType"] = arguments.field.getDbDataType() />
		<cfset xmlField.XmlAttributes["cfDataType"] = arguments.field.getCfDataType() />
		<cfset xmlField.XmlAttributes["cfSqlType"] = arguments.field.getCfSqlType() />
		<cfset xmlField.XmlAttributes["length"] = arguments.field.getLength() />
		<cfset xmlField.XmlAttributes["default"] = arguments.field.getDefault() />
		<cfset xmlField.XmlAttributes["overridden"] = 'false' />
		<cfset xmlField.XmlAttributes["object"] = arguments.config.object.XmlAttributes.name />
		
		<!--- add the field node --->
		<cfset ArrayAppend(arguments.config.Object.fields.XmlChildren, xmlField) />
		
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
	
	<cffunction name="addField" access="public" hint="I add a field to this object." output="false" returntype="void">
		<cfargument name="field" hint="I am the field to add" required="yes" type="reactor.core.field" />
		<cfset var fields = getFields() />
		<cfset fields[ArrayLen(fields) + 1] = arguments.field />
		
		<cfset setFields(fields) />
	</cffunction>

	<cffunction name="getField" access="public" hint="I return a specific field." output="false" returntype="reactor.core.field">
		<cfargument name="name" hint="I am the name of the field to return" required="yes" type="string" />
		<cfset var fields = getFields() />
		<cfset var x = 1 />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfif fields[x].getName() IS arguments.name>
				<cfreturn fields[x] />
			</cfif>
		</cfloop>
	</cffunction>
	
	<!--- name --->
    <cffunction name="setName" access="public" output="false" returntype="void">
       <cfargument name="name" hint="I am the name of the object" required="yes" type="string" />
       <cfset variables.name = arguments.name />	   
    </cffunction>
    <cffunction name="getName" access="public" output="false" returntype="string">
       <cfreturn variables.name />
    </cffunction>
	
	<!--- owner --->
    <cffunction name="setOwner" access="public" output="false" returntype="void">
       <cfargument name="owner" hint="I am the object owner." required="yes" type="string" />
       <cfset variables.owner = arguments.owner />
    </cffunction>
    <cffunction name="getOwner" access="public" output="false" returntype="string">
       <cfreturn variables.owner />
    </cffunction>
	
	<!--- type --->
    <cffunction name="setType" access="public" output="false" returntype="void">
		<cfargument name="type" hint="I am the object type (options are view or table)" required="yes" type="string" />
		<cfset arguments.type = lcase(arguments.type) />
		
		<cfif NOT ListFind("table,view", arguments.type)>
			<cfthrow type="reactor.object.InvalidObjectType"
				message="Invalid Object Type"
				detail="The Type argument must be one of: table, view" />
		</cfif>
		
		<cfset variables.type = arguments.type />
    </cffunction>
    <cffunction name="getType" access="public" output="false" returntype="string">
       <cfreturn variables.type />
    </cffunction>
	
	<!--- fields --->
    <cffunction name="setFields" access="public" output="false" returntype="void">
       <cfargument name="fields" hint="I am this object's fields" required="yes" type="array" />
       <cfset variables.fields = arguments.fields />
    </cffunction>
    <cffunction name="getFields" access="public" output="false" returntype="array">
       <cfreturn variables.fields />
    </cffunction>
	
	<!--- database --->
    <cffunction name="setDatabase" access="public" output="false" returntype="void">
		<cfargument name="database" hint="I am the database this table is in." required="yes" type="string" />
		<cfset variables.database = arguments.database />
    </cffunction>
    <cffunction name="getDatabase" access="public" output="false" returntype="string">
		<cfreturn variables.database />
    </cffunction>
	
	<!--- config --->
    <cffunction name="setConfig" access="public" output="false" returntype="void">
       <cfargument name="config" hint="I am the config object used to configure reactor" required="yes" type="reactor.config.config" />
       <cfset variables.config = arguments.config />
    </cffunction>
    <cffunction name="getConfig" access="public" output="false" returntype="reactor.config.config">
       <cfreturn variables.config />
    </cffunction>
	
	<!--- xml
    <cffunction name="setXml" access="private" output="false" returntype="void">
       <cfargument name="xml" hint="I return the xml document which describes this object." required="yes" type="xml" />
       <cfset variables.xml = arguments.xml />
    </cffunction>
    <cffunction name="getXml" access="public" output="false" returntype="xml">
       <cfreturn variables.xml />
    </cffunction> --->
</cfcomponent>