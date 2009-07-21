<cfcomponent hint="I represent metadata about a database object.">

	<!---<cfset variables.config = "" />--->
	<cfset variables.Config = 0 />
	<cfset variables.ObjectConfig = 0 />
	<cfset variables.Xml = 0 />
	<cfset variables.alias = "" />
	<cfset variables.name = "" />
	<cfset variables.owner = "" />
	<cfset variables.type = "" />
	<cfset variables.database = "" />
	
	<cfset variables.fields = ArrayNew(1) />
		
	<cfset variables.ignoreUndefinedFields = false>
	
	<cffunction name="init" access="public" hint="I configure the object." returntype="any" _returntype="reactor.core.object">
		<cfargument name="alias" hint="I am the alias of the obeject being represented." required="yes" type="any" _type="string" />
		<cfargument name="Config" hint="I am a reactor config object" required="yes" type="any" _type="reactor.config.config" />

		<cfset var ObjectDao = 0/>
    <cfset var exactObjectName = "" />
    		
		<cfset setAlias(arguments.alias) />
		<cfset setConfig(arguments.Config) />
		<cfset setObjectConfig(getConfig().getObjectConfig(getAlias())) />
		<cfset setName(getObjectConfig().object.XmlAttributes.name) />

		<cfset ObjectDao = CreateObject("Component", "reactor.data.#getConfig().getType()#.ObjectDao").init(getConfig().getDsn(), getConfig().getUsername(), getConfig().getPassword()) />
		
		<!--- read the object --->
		<cfset exactObjectName = ObjectDao.getExactObjectName(objectname=this.getName(), objectTypeList="table,view") />
    <cfif compare( exactObjectName, getName() ) is not 0>
      <cfset setName( exactObjectName ) />
      <cfset getObjectConfig().object.XmlAttributes.name = getName() />
    </cfif>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getSignature" access="public" hint="I get this table's signature" output="false" returntype="any" _returntype="string">
		<cfreturn getXml().object.XmlAttributes.signature />
	</cffunction>
	
	<cffunction name="getMapping" access="public" hint="I return this object's mapping" output="false" returntype="any" _returntype="string">
		<cfset var mapping = "/" & Replace(getXml().object.XmlAttributes.mapping, ".", "/", "all") />
		<cfreturn mapping />
	</cffunction>
	
 	<cffunction name="getRelationships" access="private" hint="I find relationships between the two provided object aliases" output="false" returntype="any" _returntype="array">
		<cfargument name="from" hint="I am the alias of the object the relationship is from" required="yes" type="any" _type="string" />
		<cfargument name="to" hint="I am the alias of the object the relationship is to" required="yes" type="any" _type="string" />
		<cfset var fromObject = getConfig().getObjectConfig(arguments.from) />
		<cfset var toObject = getConfig().getObjectConfig(arguments.to) />
		<cfset var relationships = XmlSearch(fromObject, "/object/hasMany[@name='#toObject.object.XmlAttributes.alias#']/relate/..|/object/hasOne[@name='#toObject.object.XmlAttributes.alias#']") />
		<cfset var invert = false />
		<cfset var relationship = ArrayNew(1) />
		<cfset var x = 0 />
				
		<!--- check the from object for a relationship to the to object --->
		<cfif NOT ArrayLen(relationships)>
			<cfset relationships = XmlSearch(toObject, "/object/hasMany[@name='#fromObject.object.XmlAttributes.alias#']/relate/..|/object/hasOne[@name='#fromObject.object.XmlAttributes.alias#']") />
			<cfset invert = true />
		</cfif>
		
		<!--- if we don't have any relationships throw an error --->
		<cfif NOT ArrayLen(relationships)>
			<cfthrow message="Relationship Does Not Exist" detail="No relationship exists between #arguments.from# and #arguments.to#." type="reactor.core.object.getRelationships.RelationshipDoesNotExist" />
		</cfif>
		
		<!--- get the first relationship --->
		<cfset relationships = relationships[1] />
		
		<!--- loop over the relations between from and to and make an array --->
		<cfloop from="1" to="#ArrayLen(relationships.XmlChildren)#" index="x">
			<cfset relationship[x] = StructNew() />
			
			<cfif NOT invert>
				<cfset relationship[x].from = relationships.XmlChildren[x].XmlAttributes.from />
				<cfset relationship[x].to = relationships.XmlChildren[x].XmlAttributes.to />
			<cfelse>
				<cfset relationship[x].from = relationships.XmlChildren[x].XmlAttributes.to />
				<cfset relationship[x].to = relationships.XmlChildren[x].XmlAttributes.from />
			</cfif>
		</cfloop>
		
		<cfreturn relationship />
	</cffunction>
	
	<cffunction name="getXml" access="public" hint="I return this table expressed as an XML document" output="false" returntype="any" _returntype="any">
		<cfset var Config = Duplicate(getObjectConfig()) />
		<cfset var fields = getFields() />
		<cfset var links = 0 />
		<cfset var link = 0 />
		<cfset var linkFrom = 0 />
		<cfset var linkTo = 0 />
		<cfset var newRelationship = 0 />
		<cfset var newRelate = 0 />
		<cfset var linkedConfig = 0 />
		<!--- <cfset var newHasMany = 0 />--->
		<cfset var x = 0 />
		<cfset var y = 0 />
		<cfset var z = 0 />
		<cfset var exists = false />
		
		<!--- add/validate relationship aliases --->
		<cfset var relationships = XmlSearch(Config, "/object/hasMany | /object/hasOne") />
		<cfset var relationship = 0 />
		<cfset var aliasList = "" />
		
		<cfset var fromRelationship = 0 />
		<cfset var toRelationship = 0 />
		<cfset var relationshipNode = 0 />
		<cfset var linkExpandNode = 0 />

                <cfset var ignoreIter = 0> 
		<cfset var ignoreIterMax=0>
		<cfset var fieldIter = 0>
		<cfset var fieldsToIgnoreMax = 0>
		
		<!--- insure aliases are set --->
		<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
			<cfset relationship = relationships[x] />
			
			<cfif NOT structKeyExists(relationship.XmlAttributes, "alias")>
				<cfset relationship.XmlAttributes["alias"] = relationship.XmlAttributes.name />
			</cfif>
		</cfloop>
		
		<!--- Assign aliases for relationships that don't have them --->
		<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
			<cfset relationship = relationships[x] />
			
			<cfif NOT structKeyExists(relationship.XmlAttributes, "alias")>
				<cfset relationship.XmlAttributes["alias"] = relationship.XmlAttributes.name />
				<!--- make sure this alias hasn't already been used --->
				<cfif ListFindNoCase(aliasList, relationship.XmlAttributes["alias"])>
					<!--- it's been used - throw an error --->
					<cfthrow message="Duplicate Relationship Or Alias" detail="The relationship or alias '#relationship.XmlAttributes["alias"]#' has already been used for the '#getName()#' object." type="reactor.getXml.DuplicateRelationshipOrAlias" />
				<cfelse>
					<!--- all this column to the list --->
					<cfset aliasList = ListAppend(aliasList, relationship.XmlAttributes["alias"]) />
				</cfif>
			</cfif>
			
			<!--- also, if the relationship is hasOne default sharedKey to false --->
			<cfif relationship.XmlName IS "hasOne">
				<cfif NOT structKeyExists(relationship.XmlAttributes, "sharedKey")>
					<cfset relationship.XmlAttributes["sharedKey"] = "false" />
				</cfif>
			</cfif>
			
			<!--- also!  if the relationship is a link and we don't have a relationship directly to the linking object
			we need to get the linking object's relationship back to this object and invert it to create a non-linking
			relationship.  (note, if the incomming relatonship is a hasOne and and is from it's pk columns then our outgoing
			link is a hasOne too - this is not yet implemented) (Also: if this is a multi-step link we're not going to expand it) --->
			<cfif ArrayLen(relationship.XmlChildren) IS 1 AND StructKeyExists(relationship, "link")>
				<cfset linkedConfig = CreateObject("Component", "reactor.core.object").init(relationship.link.XmlAttributes.name, getConfig()).getXml() />
				
				<!--- make sure that all of the links have froms and tos that they're using. --->
				<cfloop from="1" to="#ArrayLen(relationship.XmlChildren)#" index="y">
					<!--- if this link doesn't indicate the "from" relationship on the linking object try to figure it out --->
					<cfif NOT StructKeyExists(relationship.XmlChildren[y].XmlAttributes, "from")>
						<!--- look for a hasOne relationship on the linking object with this object's alias as its name (god I wish I could use xpath, but it's case sensitive) --->
						<cfloop from="1" to="#ArrayLen(linkedConfig.object.xmlChildren)#" index="z">
							<!--- if this is a hasOne, check to see if it's name is this object's alias --->
							<cfif linkedConfig.object.xmlChildren[z].XmlName IS "hasOne" AND linkedConfig.object.xmlChildren[z].XmlAttributes.name IS getAlias()>
								<cfset relationship.XmlChildren[y].XmlAttributes["from"] = linkedConfig.object.xmlChildren[z].XmlAttributes.alias />
								<cfbreak />
							</cfif>
						</cfloop>
					</cfif>
					
					<!--- if this link doesn't indicate the "to" relationship on the linking object try to figure out out --->
					<cfif NOT StructKeyExists(relationship.XmlChildren[y].XmlAttributes, "to")>
						<!--- look for a hasOne relationship on the linking object with this relationship's name as its alias  --->
						<cfloop from="1" to="#ArrayLen(linkedConfig.object.xmlChildren)#" index="z">
							<!--- if this is a hasOne, check to see if it's name is this object's alias --->
							<cfif linkedConfig.object.xmlChildren[z].XmlName IS "hasOne" AND linkedConfig.object.xmlChildren[z].XmlAttributes.name IS relationship.XmlAttributes.name>
								<cfset relationship.XmlChildren[y].XmlAttributes["to"] = linkedConfig.object.xmlChildren[z].XmlAttributes.alias />
								<cfbreak />
							</cfif>
						</cfloop>
					</cfif>
					
					<cfset fromRelationship = getRelationship(linkedConfig, relationship.XmlChildren[y].XmlAttributes.from) />
					<cfset toRelationship = getRelationship(linkedConfig, relationship.XmlChildren[y].XmlAttributes.to) />
					<!--- get info on the from relationship --->
					<cfset linkExpandNode = XMLElemNew(Config, "relation") />
					<cfset linkExpandNode.XmlAttributes["name"] = relationship.XmlChildren[y].XmlAttributes.from />
					
					<cfloop from="1" to="#ArrayLen(fromRelationship)#" index="z">
						<cfset relationshipNode = XMLElemNew(Config, "relate") />
						<cfset ArrayAppend(linkExpandNode.XmlChildren, relationshipNode) />
						
						<!--- oh my god! doug discovers XMLChildPos!  --->
						<cfset relationshipNode = linkExpandNode.XmlChildren[XMLChildPos(linkExpandNode,  "relate", z)] />

						<cfset relationshipNode.XmlAttributes["from"] = fromRelationship[z].XmlAttributes.from />
						<cfset relationshipNode.XmlAttributes["to"] = fromRelationship[z].XmlAttributes.to />
					</cfloop>
					
					<cfset ArrayAppend(relationship.XmlChildren[y].XmlChildren, linkExpandNode) />
					
					<!--- get info on the from relationship --->
					<cfset linkExpandNode = XMLElemNew(Config, "relation") />
					<cfset linkExpandNode.XmlAttributes["name"] = relationship.XmlChildren[y].XmlAttributes.to />
					
					<cfloop from="1" to="#ArrayLen(toRelationship)#" index="z">
						<cfset relationshipNode = XMLElemNew(Config, "relate") />
						<cfset ArrayAppend(linkExpandNode.XmlChildren, relationshipNode) />
						
						<!--- oh my god! doug discovers XMLChildPos!  --->
						<cfset relationshipNode = linkExpandNode.XmlChildren[XMLChildPos(linkExpandNode,  "relate", z)] />

						<cfset relationshipNode.XmlAttributes["from"] = toRelationship[z].XmlAttributes.from />
						<cfset relationshipNode.XmlAttributes["to"] = toRelationship[z].XmlAttributes.to />
					</cfloop>
					
					<cfset ArrayAppend(relationship.XmlChildren[y].XmlChildren, linkExpandNode) />
					
				</cfloop>
					
				
				<!--- loop over the linked config and look for a matching link (stupid xpath!) --->
				<cfloop from="1" to="#ArrayLen(linkedConfig.object.XmlChildren)#" index="y">
					<cfif StructKeyExists(linkedConfig.object.XmlChildren[y].XmlAttributes, "name") AND linkedConfig.object.XmlChildren[y].XmlAttributes.name IS getAlias()>
						<cfset linkedConfig = linkedConfig.object.XmlChildren[y] />
						<cfset exists = false />
						
						<!--- make sure this config doesn't already have a has many to the link (xpath is case sensitive!) --->
						<cfloop from="1" to="#ArrayLen(Config.object.XmlChildren)#" index="z">
							<cfif StructKeyExists(Config.object.XmlChildren[z].XmlAttributes, "alias") AND
								Config.object.XmlChildren[z].XmlName IS Iif(linkedConfig.XmlName IS "hasOne", De("hasMany"), De("hasOne"))
								AND Config.object.XmlChildren[z].XmlAttributes.name IS relationship.link.XmlAttributes.name>
								
								<!--- this relationship already exists, exit the loop! --->
								<cfset exists = true />
								<cfbreak />
							</cfif>
						</cfloop>
						
						<!--- if the inverse relationship doesn't exist in this config object already, create it --->
						<cfif NOT exists>
							<!--- invert the relationship --->
							<cfif linkedConfig.XmlName IS "hasOne">
								<!--- todo: deal with one-to-one cases --->
								<cfset newRelationship = XmlElemNew(Config, "hasMany") />
							<cfelse>
								<cfset newRelationship = XmlElemNew(Config, "hasOne") />
							</cfif>
							
							<cfset newRelationship.XmlAttributes["name"] = relationship.link.XmlAttributes.name />
							<cfset newRelationship.XmlAttributes["alias"] = relationship.link.XmlAttributes.name />
							
							<!--- invert the relationship --->
							<cfloop from="1" to="#ArrayLen(linkedConfig.XmlChildren)#" index="y">
								<cfset newRelate = XMLElemNew(Config, "relate") />
								<cfset newRelate.XmlAttributes["from"] = linkedConfig.XmlChildren[y].XmlAttributes.to />
								<cfset newRelate.XmlAttributes["to"] = linkedConfig.XmlChildren[y].XmlAttributes.from />
							</cfloop>
							
							<!--- add the relate tag to the new relationship --->
							<cfset ArrayAppend(newRelationship.XmlChildren, newRelate) />
							
							<!--- add this to the config object --->
							<cfset ArrayAppend(Config.object.XmlChildren, newRelationship) />
						</cfif>
						
						<!--- exit the loop, please --->
						<cfbreak />
					</cfif>
				</cfloop>
				
			</cfif>
		</cfloop>
		
		<!--- add the fields to the config settings --->
		
		<!--- check to see if a fields node already exists --->
		<cfif NOT structKeyExists(Config.Object, "fields")>
			<cfset Config.Object.fields = XMLElemNew(Config, "fields") />
		</cfif>
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfset addXmlField(fields[x], Config) />
		</cfloop>		
		
		<cfset fieldsToIgnore = ""> 
		<!--- delete the fields from the base config file --->
		<cfloop from="#ArrayLen(Config.object.xmlChildren)#" to="1" index="x" step="-1">
			<cfif Config.object.xmlChildren[x].XmlName IS "field">
				<cfif StructKeyExists(Config.object.xmlChildren[x].XmlAttributes, "source")>
					<cfset addExternalField(Config.object.xmlChildren[x], Config) />
				</cfif>

				<cfif StructKeyExists(Config.object.xmlChildren[x].XmlAttributes, "ignore")> 
				         <!--- Check that we have a name ---> 
				         <cfif NOT StructKeyExists(Config.object.xmlChildren[x].XmlAttributes, "name")> 
				                 <cfthrow message="Name is required if the ignore attribute is used"> 
				         </cfif> 
				         <cfif Config.object.xmlChildren[x].XmlAttributes["ignore"]> 
				                 <cfset fieldsToIgnore = ListAppend(fieldsToIgnore, Config.object.xmlChildren[x].XmlAttributes["name"])> 
				         </cfif> 
				 </cfif> 
				
				<cfset ArrayDeleteAt(Config.object.xmlChildren, x) />	
			</cfif>
		</cfloop>

		<cfset fieldsToIgnoreMax=ListLen(fieldsToIgnore)>
		<cfloop from="1" to="#fieldsToIgnoreMax#" index="fieldIter"> 
			<cfset ignoreIterMax = ArrayLen(Config.object.fields.XMLChildren)>
			<cfloop from ="1" to="#ignoreIterMax#" index="ignoreIter">
            	<cfif ListFindNoCase(listGetAt(fieldsToIgnore,fieldIter), Config.Object.fields.XMLChildren[ignoreIter].XmlAttributes.alias)> 
                	<cfset ArrayDeleteAt(Config.object.fields.XMLChildren, ignoreIter) /> 
					<cfbreak>
				</cfif> 
	                         
			</cfloop> 
		</cfloop>
		
		<!--- set the base config settings --->
		<cfset Config.Object.XmlAttributes["owner"] = getOwner() />
		<cfset Config.Object.XmlAttributes["type"] = getType() />
		<cfset Config.Object.XmlAttributes["database"] = getDatabase() />
		
		<!--- config meta data required for generating objects --->
		<cfset Config.Object.XmlAttributes["project"] = getConfig().getProject() />
		
		<cfif StructKeyExists(Config.Object.XmlAttributes, "mapping")>
			<cfset Config.Object.XmlAttributes["mapping"] = getConfig().getMappingObjectStem(Config.Object.XmlAttributes.mapping) />
		<cfelse>
			<cfset Config.Object.XmlAttributes["mapping"] = getConfig().getMappingObjectStem() />
		</cfif>
		
		<cfset Config.Object.XmlAttributes["dbms"] = getConfig().getType() />
		
		<!--- add the object's signature --->
		<cfset Config.Object.XmlAttributes["signature"] = Hash(ToString(Config)) />
		
		<!---<cfif getAlias() is "Daisy">
			<cfdump var="#Config#" /><cfabort>
		</cfif>--->
		<cfreturn Config />
	</cffunction>
	
	<cffunction name="getRelationship" access="public" hint="I return the named relationship's data for the specified xml node in the provided document" output="false" returntype="any" _returntype="any">
		<cfargument name="xmlDoc" hint="I am the document to get the node from" required="yes" type="any" _type="any">
		<cfargument name="alias" hint="I am the alias of the relationship to get" required="yes" type="any" _type="string" />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(arguments.xmlDoc.object.xmlChildren)#" index="x">
			<cfif arguments.xmlDoc.object.xmlChildren[x].XmlName IS "hasOne" AND arguments.xmlDoc.object.xmlChildren[x].XmlAttributes.alias IS arguments.alias>
				<cfreturn arguments.xmlDoc.object.xmlChildren[x].XmlChildren />
			</cfif>
		</cfloop>		
	</cffunction>
	
	<cffunction name="addExternalField" access="private" hint="I add a field from another object to the xml document." output="false" returntype="void">
		<cfargument name="field" hint="I am the field to add to the xml" required="yes" type="any" _type="any" />
		<cfargument name="config" hint="I am the xml to add the field to." required="yes" type="any" _type="string" />
		<cfset var externalField = XMLElemNew(arguments.config, "externalField") />
		<cfset var hasOne = XmlSearch(arguments.config, "/object/hasOne[@alias = '#arguments.field.xmlAttributes.source#']") />
		<cfset var remoteField = getObject(hasOne[1].XmlAttributes.name, getConfig()).getField(arguments.field.xmlAttributes.field) />
				
		<cfif StructKeyExists(arguments.field.xmlAttributes, "alias")>
			<cfset externalField.XmlAttributes["fieldAlias"] = arguments.field.xmlAttributes.alias />
		<cfelse>
			<cfset externalField.XmlAttributes["fieldAlias"] = arguments.field.xmlAttributes.field />
		</cfif>
		<cfset externalField.XmlAttributes["sourceAlias"] = arguments.field.xmlAttributes.source />
		<cfset externalField.XmlAttributes["sourceName"] = hasOne[1].XmlAttributes.name />
		<cfset externalField.XmlAttributes["field"] = arguments.field.xmlAttributes.field />
		
		<cftry>
			<cfset externalField.XmlAttributes["cfDataType"] = remoteField.cfDataType />
			<cfcatch>
				<cfdump var="#remoteField#" /><cfabort>
			</cfcatch>
		</cftry>
		<cfset externalField.XmlAttributes["default"] = remoteField.default />
				
		<!--- add the external field node --->
		<cfset ArrayAppend(arguments.config.Object.fields.XmlChildren, externalField) />
	</cffunction>
	
	<!---<cffunction name="getFieldDetails" access="public" hint="I return the complete details (alias and all) for a field" output="false" returntype="any" _returntype="struct">
		<cfargument name="name" hint="I am the name of the field to return" required="yes" type="any" _type="string" />
		<cfset var field = getField(arguments.name) />
		<cfset var config = getconfig().getObjectConfig(getAlias()) />
		<cfset var fieldTags = XmlSearch(config, "/object/field") />
		<cfset var fieldTag = 0 />
		<cfset var x = 0 />
		
		<!---
			The next few lines of code loop over the provided xml config and look for a field with the same name as the field
			we're working with.  I used to use XmlSearch, but that's case sensitive and I need it not to be.		
		--->
		<cfloop from="1" to="#ArrayLen(fieldTags)#" index="x">
			<cfif StructKeyExists(fieldTags[x].XmlAttributes, "name") AND fieldTags[x].XmlAttributes.name IS arguments.field.name>
				<cfset fieldTag = fieldTags[x] />
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfif IsSimpleValue(fieldTag)>
			<cfreturn field />
		<cfelse>
			<cfdump var="#field#" />
			<cfdump var="#fieldTag#" /><cfabort>	
		</cfif>
	</cffunction>--->
	
	<cffunction name="addXmlField" access="private" hint="I add a field to the xml document." output="false" returntype="void">
		<cfargument name="field" hint="I am the field to add to the xml" required="yes" type="any" _type="struct" />
		<cfargument name="config" hint="I am the xml to add the field to." required="yes" type="any" _type="string" />
		<cfset var xmlField = 0 />
		<cfset var fieldTags = XmlSearch(arguments.config, "/object/field") />
		<cfset var fieldTag = 0 />
		<cfset var x = 0 />
		<cfset var exactObjectName = "" />
		<cfset var objectDAO = 0 />
		<cfset var exactName = 0 />

		<!---
			The next few lines of code loop over the provided xml config and look for a field with the same name as the field
			we're working with.  I used to use XmlSearch, but that's case sensitive and I need it not to be.		
		--->
		<cfloop from="1" to="#ArrayLen(fieldTags)#" index="x">
			<cfif StructKeyExists(fieldTags[x].XmlAttributes, "name") AND fieldTags[x].XmlAttributes.name IS arguments.field.name>
				<cfset fieldTag = fieldTags[x] />
				<cfbreak />
			</cfif>
		</cfloop>
		
		<!--- create the field node--->
		<cfset xmlField = XMLElemNew(arguments.config, "field") />
		
		<!--- set the field's properties --->
		<cfset xmlField.XmlAttributes["name"] = arguments.field.name />
		<cfif NOT IsSimpleValue(fieldTag) AND StructKeyExists(fieldTag.XmlAttributes, "alias") >
			<cfset xmlField.XmlAttributes["alias"] = fieldTag.XmlAttributes.alias />
		<cfelse>
			<cfset xmlField.XmlAttributes["alias"] = arguments.field.name />
		</cfif>
		<cfset xmlField.XmlAttributes["primaryKey"] = arguments.field.primaryKey />
		<cfset xmlField.XmlAttributes["identity"] = arguments.field.identity />
		<cfset xmlField.XmlAttributes["nullable"] = arguments.field.nullable />
		<cfset xmlField.XmlAttributes["dbDataType"] = arguments.field.dbDataType />
		<cfset xmlField.XmlAttributes["cfDataType"] = arguments.field.cfDataType />
		<cfset xmlField.XmlAttributes["cfSqlType"] = arguments.field.cfSqlType />
		<cfset xmlField.XmlAttributes["length"] = arguments.field.length />
		<cfset xmlField.XmlAttributes["scale"] = arguments.field.scale />
		<cfset xmlField.XmlAttributes["default"] = arguments.field.default />
		<cfset xmlField.XmlAttributes["object"] = arguments.config.object.XmlAttributes.name />
		<cfset xmlField.XmlAttributes["sequence"] = arguments.field.sequenceName />
		<cfset xmlField.XmlAttributes["readOnly"] = arguments.field.readOnly />
		
		<!--- use sequence name specfied in the reactor.xml file if provided, if it doesn't match the default sequence specified for a column then throw an error --->
		<cfif NOT IsSimpleValue(fieldTag) AND StructKeyExists(fieldTag.XmlAttributes, "sequence") >
			<cfif len(arguments.field.sequenceName) eq 0>
				<cfset xmlField.XmlAttributes["sequence"] = fieldTag.XmlAttributes.sequence />
			<cfelseif arguments.field.sequenceName neq fieldTag.XmlAttributes.sequence>
				<cfthrow message="Sequence names are not the same." detail="The database's default value for table: '#arguments.config.object.XmlAttributes.name#' column: '#arguments.field.name#' uses a sequence named '#arguments.field.sequenceName#' but the reactor.xml configuration file indicates that a sequence named '#fieldTag.XmlAttributes.sequence#' should be used." type="reactor.core.object.addXmlField.SequenceNameMismatch" />
			</cfif>
		</cfif>

		<cfif xmlField.XmlAttributes["sequence"] gt "">
			<cfset ObjectDao = CreateObject("Component",
				"reactor.data.#getConfig().getType()#.ObjectDao").init(getConfig().getDsn(),
				getConfig().getUsername(),
				getConfig().getPassword()
			) />
			<cfset exactName = ObjectDao.getExactObjectName(objectName=xmlField.XmlAttributes["sequence"], objectTypeList="sequence") />
			<cfif compare( exactName, xmlField.XmlAttributes["sequence"] ) is not 0>
				<cfset xmlField.XmlAttributes["sequence"] = exactName />
			</cfif>
		</cfif>
		
		<!--- add the field node --->
		<cfset ArrayAppend(arguments.config.Object.fields.XmlChildren, xmlField) />
		
	</cffunction>
	
	<cffunction name="copyNode" access="private"  hint="Copies a node from one document into a second document.  (This code was coppied from Spike's blog at http://www.spike.org.uk/blog/index.cfm?do=ReactorSamples.Blog.cat&catid=8245E3A4-D565-E33F-39BC6E864D6B5DAA)" output="false" returntype="void">
		<cfargument name="xmlDoc" hint="I am the document to copy the nodes into" required="yes" type="any" _type="any">
		<cfargument name="newNode" hint="I am the node to copy the nodes into" required="yes" type="any" _type="any">
		<cfargument name="oldNode" hint="I am the node to copy the nodes from" required="yes" type="any" _type="any">
		<cfset var key = "" />
		<cfset var index = "" />
		<cfset var i = "" />
		
		<cfif len(trim(oldNode.xmlComment))>		
			<cfset arguments.newNode.xmlComment = trim(oldNode.xmlComment) />
		</cfif>
	
		<cfif len(trim(oldNode.xmlCData))>
			<cfset arguments.newNode.xmlCData = trim(oldNode.xmlCData)>
		</cfif>
		
		<cfset arguments.newNode.xmlAttributes = oldNode.xmlAttributes>
		
		<cfset arguments.newNode.xmlText = trim(oldNode.xmlText) />
		
		<cfloop from="1" to="#arrayLen(oldNode.xmlChildren)#" index="i">
			<cfset arguments.newNode.xmlChildren[i] = xmlElemNew(xmlDoc, oldNode.xmlChildren[i].xmlName) />
			<cfset copyNode(xmlDoc, arguments.newNode.xmlChildren[i], oldNode.xmlChildren[i]) />
		</cfloop>
	</cffunction>
	
	<cffunction name="addField" access="public" hint="I add a field to this object." output="false" returntype="void">
		<cfargument name="field" hint="I am the field to add" required="yes" type="any" _type="struct" />
		<cfset var fields = getFields() />
		<cfset var cfg = getObjectConfig() />
		<cfset var i=0>
		
		<cfif variables.ignoreUndefinedFields is false>
			<cfset fields[ArrayLen(fields) + 1] = arguments.field />			
			<cfset setFields(fields) />
		</cfif>
			
		<cfif variables.ignoreUndefinedFields is true >
			<cfloop from="1" to="#arrayLen(cfg.object.XmlChildren)#" index="i">
				<cfif field.name is cfg.object.XmlChildren[i].XmlAttributes.name>
					<cfset fields[ArrayLen(fields) + 1] = arguments.field />
					<cfset setFields(fields) />
				</cfif>
			</cfloop>		
		</cfif>	
			
	</cffunction>

	<cffunction name="getField" access="public" hint="I return a specific field." output="false" returntype="any" _returntype="struct">
		<cfargument name="name" hint="I am the name of the field to return" required="yes" type="any" _type="string" />
		<cfset var fields = getFields() />
		<cfset var x = 1 />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfif fields[x].name IS arguments.name>
				<cfreturn fields[x] />
			</cfif>
		</cfloop>
		
		<!--- we couldn't find the field, throw an error --->
		<cfthrow message="Couldn't find field" detail="The field '#arguments.name#' could not be found in the object '#getAlias()#'." type="reactor.object.CouldntFindField" />
	</cffunction>
	
	<cffunction name="getObject" access="public" hint="I read and return a reactor.core.object object for a specific db object." output="false" returntype="any" _returntype="reactor.core.object">
		<cfargument name="name" hint="I am the name of the object to translate." required="yes" type="any" _type="string" />
		<cfset var Object = 0 />
		<cfset var ObjectDao = 0/>
		
		<cfset Object = CreateObject("Component", "reactor.core.object").init(arguments.name, getConfig()) />
		<cfset ObjectDao = CreateObject("Component", "reactor.data.#getConfig().getType()#.ObjectDao").init(getConfig().getDsn(), getConfig().getUsername(), getConfig().getPassword()) />
		
		<!--- read the object --->
		<cfset ObjectDao.read(Object) />
		
		<!--- return the object --->
		<cfreturn Object />
	</cffunction>
	
	<!--- name --->
    <cffunction name="setName" access="public" output="false" returntype="void">
       <cfargument name="name" hint="I am the name of the object" required="yes" type="any" _type="string" />
       <cfset variables.name = arguments.name />	   
    </cffunction>
    <cffunction name="getName" access="public" output="false" returntype="any" _returntype="string">
       <cfreturn variables.name />
    </cffunction>
	
	<!--- alias --->
    <cffunction name="setAlias" access="public" output="false" returntype="void">
       <cfargument name="alias" hint="I am the alias this object is known as." required="yes" type="any" _type="string" />
       <cfset variables.alias = arguments.alias />
    </cffunction>
    <cffunction name="getAlias" access="public" output="false" returntype="any" _returntype="string">
       <cfreturn variables.alias />
    </cffunction>
	
	<!--- owner --->
    <cffunction name="setOwner" access="public" output="false" returntype="void">
       <cfargument name="owner" hint="I am the object owner." required="yes" type="any" _type="string" />
       <cfset variables.owner = arguments.owner />
    </cffunction>
    <cffunction name="getOwner" access="public" output="false" returntype="any" _returntype="string">
       <cfreturn variables.owner />
    </cffunction>
	
	<!--- type --->
    <cffunction name="setType" access="public" output="false" returntype="void">
		<cfargument name="type" hint="I am the object type (options are view or table)" required="yes" type="any" _type="string" />
		<cfset arguments.type = lcase(arguments.type) />
		
		<cfif NOT ListFind("table,view", arguments.type)>
			<cfthrow type="reactor.object.InvalidObjectType"
				message="Invalid Object Type"
				detail="The Type argument must be one of: table, view" />
		</cfif>
		
		<cfset variables.type = arguments.type />
    </cffunction>
    <cffunction name="getType" access="public" output="false" returntype="any" _returntype="string">
       <cfreturn variables.type />
    </cffunction>
	
	<!--- fields --->
    <cffunction name="setFields" access="public" output="false" returntype="void">
       <cfargument name="fields" hint="I am this object's fields" required="yes" type="any" _type="array" />
       <cfset variables.fields = arguments.fields />
    </cffunction>
    <cffunction name="getFields" access="public" output="false" returntype="any" _returntype="array">
       <cfreturn variables.fields />
    </cffunction>
	
	<!--- database --->
    <cffunction name="setDatabase" access="public" output="false" returntype="void">
		<cfargument name="database" hint="I am the database this table is in." required="yes" type="any" _type="string" />
		<cfset variables.database = arguments.database />
    </cffunction>
    <cffunction name="getDatabase" access="public" output="false" returntype="any" _returntype="string">
		<cfreturn variables.database />
    </cffunction>
	
	<!--- config --->
    <cffunction name="setConfig" access="public" output="false" returntype="void">
       <cfargument name="config" hint="I am the config object used to configure reactor" required="yes" type="any" _type="reactor.config.config" />
       <cfset variables.config = arguments.config />
    </cffunction>
    <cffunction name="getConfig" access="public" output="false" returntype="any" _returntype="reactor.config.config">
       <cfreturn variables.config />
    </cffunction>
	
	<!--- objectConfig --->
    <cffunction name="setObjectConfig" access="private" output="false" returntype="void">
       <cfargument name="objectConfig" hint="I am the configuration for this specific object" required="yes" type="any" _type="string" />
       <cfset variables.objectConfig = arguments.objectConfig />

		<cfif StructKeyExists(variables.objectConfig.object.XmlAttributes,"ignoreUndeclaredFields")>
			<cfset variables.ignoreUndefinedFields=true>
		</cfif>
		
    </cffunction>
    <cffunction name="getObjectConfig" access="public" output="false" returntype="any" _returntype="any">
       <cfreturn variables.objectConfig />
    </cffunction>
	
</cfcomponent>

