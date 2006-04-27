<cfcomponent hint="I am an abstract Metadata.  I am used to define an interface and return types." extends="reactor.base.abstractObject">
	<cffunction name="getConventions" access="public" output="false" returntype="reactor.data.abstractConvention">
		<cfreturn _getConvention() />
  </cffunction>

	<cffunction name="getDatabase" access="public" hint="I return the name of the database this object is in." output="false" returntype="string">
		<cfreturn getObjectMetadata().database />
	</cffunction>

	<cffunction name="getDbms" access="public" hint="I return the name of the database this object is in." output="false" returntype="string">
		<cfreturn getObjectMetadata().dbms />
	</cffunction>
	
	<cffunction name="getName" access="public" hint="I return the name of the object." output="false" returntype="string">
		<cfreturn getObjectMetadata().name />
	</cffunction>
	
	<cffunction name="getAlias" access="public" hint="I return the alias of the object." output="false" returntype="string">
		<cfreturn getObjectMetadata().alias />
	</cffunction>
	
	<cffunction name="getOwner" access="public" hint="I return the owner of this object." output="false" returntype="string">
		<cfreturn getObjectMetadata().owner />
	</cffunction>
	
	<cffunction name="getType" access="public" hint="I return the type of object (view, table)." output="false" returntype="string">
		<cfreturn getObjectMetadata().type />
	</cffunction>
	
	<cffunction name="getFields" access="public" hint="I return an array of structures describing this object's fields" output="false" returntype="array">
		<cfreturn Duplicate(getObjectMetadata().fields) />
	</cffunction>
	
	<cffunction name="getFieldQuery" access="public" hint="I return an Query of describing this object's fields" output="false" returntype="query">
		<cfset var fields = getFields() />
		<cfset var fieldQuery = QueryNew(StructKeyList(fields[1])) />
		<cfset var x = 0 />
		<cfset var field = "" />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfset QueryAddRow(fieldQuery) />
			<cfloop collection="#fields[x]#" item="field">
				<cfset QuerySetCell(fieldQuery, field, fields[x][field]) />					
			</cfloop>
		</cfloop>
		
		<cfreturn fieldQuery/>
	</cffunction>
	
	<cffunction name="getField" access="public" hint="I return a structure of data about a specific field." output="false" returntype="struct">
		<cfargument name="alias" hint="I am the alias of the field to get" required="yes" type="string" />
		<cfset var fields = getFields() />
		<cfset var field = 0 />
		<cfset var x = 0 />
		
		<!--- loop over the fields and look for a match --->
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfif fields[x].alias IS arguments.alias>
				<cfset field = fields[x] />
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfif IsStruct(field)>
			<!--- return the field's attributes --->
			<cfreturn field />
				
		<cfelse>
			<cfthrow message="Field Does Not Exist" detail="The field '#arguments.alias#' does not exist for the '#getAlias()#' object." type="reactor.getField.FieldDoesNotExist" />
			
		</cfif>
	</cffunction>
	
	<cffunction name="getFieldList" access="public" hint="I return a list of fields in this object." output="false" returntype="string">
		<cfset var fields = getFields() />
		<cfset var superFields = 0 />
		<cfset var columList = "" />
		<cfset var field = "" />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfset columList = ListAppend(columList, fields[x].alias) />
		</cfloop>
		
		<cfreturn columList />
	</cffunction>
	
	<!--- LinkRelationship --->
	<cffunction name="hasLinkRelationship" access="public" hint="I indicate if this object has a to another where the named object is the link" output="false" returntype="boolean">
		<cfargument name="link" hint="I am the name of an object that this object may use as a link to another object." required="yes" type="string" />
		<cfset var relationships = getRelationships() />
		
		<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
			<cfif StructKeyExists(relationships[x], "link") AND ArrayLen(relationships[x].link) IS 1 AND relationships[x].link[1] IS arguments.link>
				<cfreturn true />
			</cfif>
		</cfloop>
		
		<cfreturn false />
	</cffunction>
	
	<!--- getLinkRelationship --->
	<cffunction name="getLinkRelationship" access="public" hint="I return a structure representing the link between this object and another where the named object in the link" output="false" returntype="struct">
		<cfargument name="link" hint="I am the name of an object that this object may use as a link to another object." required="yes" type="string" />
		<cfset var relationships = getRelationships() />
		
		<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
			<cfif StructKeyExists(relationships[x], "link") AND ArrayLen(relationships[x].link) IS 1 AND relationships[x].link[1] IS arguments.link>
				<cfreturn relationships[x] />
			</cfif>
		</cfloop>
	</cffunction>
	
	<!--- getRelationships --->
	<cffunction name="getRelationships" access="public" hint="I get an array of relationships.  I passed an alias I filter the relationships to only those that relate to the alias." output="false" returntype="array">
		<cfargument name="alias" hint="I am the alias of the related object." required="no" type="string" default="" />
		<cfset var objectMetadata = getObjectMetadata() />
		<cfset var allRelationships = ArrayNew(1) />
		<cfset var relationships = 0 />
		<cfset var x = 0 />
		
		<!--- check the hasone relationships --->
		<cfif ArrayLen(objectMetadata.hasOne)>
			<cfset relationships = objectMetadata.hasOne />
			<!--- loop over the relationships and find a match by alias --->
			<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
				<cfif NOT Len(arguments.alias) OR relationships[x].name IS arguments.alias>
					<cfset ArrayAppend(allRelationships, relationships[x]) />
				</cfif>
			</cfloop>
		</cfif>
		
		<!--- check the hasMany relationships --->
		<cfif ArrayLen(objectMetadata.hasMany)>
			<cfset relationships = objectMetadata.hasMany />
			<!--- loop over the relationships and find a match by alias --->
			<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
				<cfif NOT Len(arguments.alias) OR relationships[x].name IS arguments.alias>
					<cfset ArrayAppend(allRelationships, relationships[x]) />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn Duplicate(allRelationships) />
	</cffunction>
	
	<!--- getRelationship --->
	<cffunction name="getRelationship" access="public" hint="I get a relationship by alias." output="false" returntype="struct">
		<cfargument name="alias" hint="I am the alias of the related object." required="yes" type="string" />
		<cfargument name="relationAlias" hint="I am the alias of the relationship on that object that is neded." required="no" type="string" default="" />
		<cfset var relationships = getRelationships(arguments.alias) />
		<cfset var matches = ArrayNew(1) />
		<cfset var x = 0 />
		
		<!--- no relationship --->
		<cfif NOT ArrayLen(relationships)>
			<cfthrow
				message="Relationship Does Not Exist"
				detail="The object '#getAlias()#' object does not have any relationships with an object with the alias of '#arguments.alias#'."
				type="reactor.getRelationship.RelationshipDoesNotExist" />
		</cfif>
		
		<!--- if we're looking for a relation which a specific alias then return that one --->
		<cfif Len(arguments.relationAlias)>
			<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
				<cfif relationships[x].alias IS arguments.relationAlias>
					<cfset ArrayAppend(matches,relationships[x]) />
				</cfif>
			</cfloop>
			
			<cfif ArrayLen(matches) IS 1>
				<cfreturn matches[1] />
				
			<cfelseif ArrayLen(matches) GT 1>
				<!--- more than one had the required alias --->
				<cfthrow
					message="Ambigious Relationship Alias"
					detail="The object '#getAlias()#' has #ArrayLen(relationships)# relationships with the alias '#relationAlias#' to an object with an alias of '#arguments.alias#'.  This is not allowed.  Please fix the duplicate aliases in your reactor configuration file."
					type="reactor.getRelationship.AmbigiousRelationshipAlias" />
					
			<cfelse>
				<!--- no relation had the required alias --->
				<cfthrow message="Relationship Does Not Exist With Alias"
					detail="The object '#getAlias()#' does have at least one relationship to an object with an alias of '#arguments.alias#'.  However, no relationship has an alias of '#arguments.relationAlias#'."
					type="reactor.getRelationship.RelationshipDoesNotExistWithAlias" />
					
			</cfif>
		</cfif>
		
		<!--- if only one result was returned then return that, otherwise throw an error --->
		<cfif ArrayLen(relationships) IS 1>
			<!--- return the one match --->
			<cfreturn relationships[1] />
		
		<cfelse>
			<cfthrow
				message="Ambigious Relationship"
				detail="The object '#getAlias()#' has #ArrayLen(relationships)# relationships to an object with an alias of '#arguments.alias#'.  To return a specific relationship please provide the relationAlias."
				type="reactor.getRelationship.AmbigiousRelationship" />
		
		</cfif>
		
		
	</cffunction>
	
	<!--- hasSharedkey --->
	<cffunction name="hasSharedkey" access="public" hint="I indicate if any of this object's relationships to the object with the specified alias use shared keys." output="false" returntype="boolean">
		<cfargument name="alias" hint="I am the alias of the related object." required="yes" type="string" />
		<cfset var relationships = getRelationships(arguments.alias) />
		
		<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
			<cfif StructKeyExists(relationships[x], "sharedKey") AND relationships[x].sharedKey IS true>
				<cfreturn true />
			</cfif>
		</cfloop>
		
		<cfreturn false />
	</cffunction>
	
	
	<!--- hasRelationship --->
	<cffunction name="hasRelationship" access="public" hint="I indicate if this object as a relationship with another object" output="false" returntype="boolean">
		<cfargument name="alias" hint="I am the alias of the related object." required="yes" type="string" />
		<cfargument name="relationAlias" hint="I am the alias of the relationship on that object that is neded." required="no" type="string" default="" />
		
		<cftry>
			<cfset getRelationship(arguments.alias, arguments.relationAlias) />
			<cfcatch>
				<cfreturn false />
			</cfcatch>
		</cftry>
		
		<cfreturn true />
		
	</cffunction>
		
	<!---- getRelationshipMetadata --->
	<cffunction name="getRelationshipMetadata" access="public" hint="I return a related object's metadata based on the provided alias" output="false" returntype="reactor.base.abstractMetadata">
		<cfargument name="alias" hint="I am the alias of the related object." required="yes" type="string" />
		<!---<cfset var relationship = getRelationship(arguments.alias) />
		<cfset var RelationshipMetadata = _getReactorFactory().createMetadata(relationship.name) />--->
		
		<cfreturn _getReactorFactory().createMetadata(arguments.alias) />
	</cffunction>
	
	<!--- metadata --->
    <cffunction name="getObjectMetadata" access="public" output="false" returntype="struct">
       <cfreturn variables.metadata />
    </cffunction>
		
	<!---<cffunction name="dumpVariables">
		<cfdump var="#variables#" />
		<cfabort />
	</cffunction>--->

</cfcomponent>