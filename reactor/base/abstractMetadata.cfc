<cfcomponent hint="I am an abstract Metadata.  I am used to define an interface and return types.">
	
	<cfinclude template="base.cfm" />
	
	<cffunction name="_configure" access="public" hint="I configure and return this object." output="false" returntype="any" _returntype="reactor.base.abstractMetadata">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="any" _type="reactor.config.config" />
		<cfargument name="alias" hint="I am the alias of this object." required="yes" type="any" _type="string" />
		<cfargument name="ReactorFactory" hint="I am the reactorFactory object." required="yes" type="any" _type="reactor.reactorFactory" />
		<cfargument name="Convention" hint="I am a database Convention object." required="yes" type="any" _type="reactor.data.abstractConvention" />
		
		<!---<cfset _setConfig(arguments.config) />
		<cfset _setAlias(arguments.alias) />
		<cfset _setReactorFactory(arguments.ReactorFactory) />
		<cfset _setConvention(arguments.Convention) />--->
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getConventions" access="public" output="false" returntype="any" _returntype="reactor.data.abstractConvention">
		<cfreturn _getConvention() />
	</cffunction>

	<cffunction name="getDatabase" access="public" hint="I return the name of the database this object is in." output="false" returntype="any" _returntype="string">
		<cfreturn getObjectMetadata().database />
	</cffunction>

	<cffunction name="getDbms" access="public" hint="I return the name of the database this object is in." output="false" returntype="any" _returntype="string">
		<cfreturn getObjectMetadata().dbms />
	</cffunction>
	
	<cffunction name="getName" access="public" hint="I return the name of the object." output="false" returntype="any" _returntype="string">
		<cfreturn getObjectMetadata().name />
	</cffunction>
	
	<cffunction name="getAlias" access="public" hint="I return the alias of the object." output="false" returntype="any" _returntype="string">
		<cfreturn getObjectMetadata().alias />
	</cffunction>
	
	<cffunction name="getOwner" access="public" hint="I return the owner of this object." output="false" returntype="any" _returntype="string">
		<cfreturn getObjectMetadata().owner />
	</cffunction>
	
	<cffunction name="getType" access="public" hint="I return the type of object (view, table)." output="false" returntype="any" _returntype="string">
		<cfreturn getObjectMetadata().type />
	</cffunction>
	
	<cffunction name="getFields" access="public" hint="I return an array of structures describing this object's fields" output="false" returntype="any" _returntype="array">
		<cfreturn Duplicate(getObjectMetadata().fields) />
	</cffunction>
	
	<cffunction name="getFieldQuery" access="public" hint="I return an Query of describing this object's fields" output="false" returntype="any" _returntype="query">
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
	
	<cffunction name="hasexternalFields" access="public" hint="I indicate if this object has any configured external fields" output="false" returntype="any" _returntype="boolean">
		<cfreturn ArrayLen(getObjectMetadata().externalFields) GT 0/>
	</cffunction>
	
	<cffunction name="hasField" access="public" hint="I indicate if this object has a field with the given alias" output="false" returntype="any" _returntype="boolean">
		<cfargument name="alias" hint="I am the alias of the field to get" required="yes" type="any" _type="string" />
		<cfset var fields = getFields() />
		<cfset var field = 0 />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfif fields[x].alias IS arguments.alias>
				<cfreturn true />
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfreturn false />
	</cffunction>
	
	<cffunction name="hasExternalField" access="public" hint="I indicate if this object has an external field with the given alias" output="false" returntype="any" _returntype="boolean">
		<cfargument name="alias" hint="I am the alias of the field to get" required="yes" type="any" _type="string" />
		<cfset var fields = getExternalFields() />
		<cfset var field = 0 />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfif fields[x].fieldAlias IS arguments.alias>
				<cfreturn true />
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfreturn false />
	</cffunction>
	
	<cffunction name="getExternalFields" access="public" hint="I return an array of structures describing this object's external mapped fields" output="false" returntype="any" _returntype="array">
		<cfreturn Duplicate(getObjectMetadata().externalFields) />
	</cffunction>
	
	<cffunction name="getExternalFieldQuery" access="public" hint="I return an Query of describing this object's external mapped fields" output="false" returntype="any" _returntype="query">
		<cfset var fields = getexternalFields() />
		<cfset var fieldQuery = QueryNew(StructKeyList(fields[1])) />
		<cfset var x = 0 />
		<cfset var field = "" />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfset QueryAddRow(fieldQuery) />
			<cfloop collection="#fields[x]#" item="field">
				<cfset QuerySetCell(fieldQuery, field, fields[x][field]) />					
			</cfloop>
		</cfloop>
		
		<cfquery name="fieldQuery" dbtype="query">
			SELECT *
			FROM fieldQuery
			ORDER BY sourceAlias
		</cfquery>
		
		<cfreturn fieldQuery/>
	</cffunction>
	
	<cffunction name="getField" access="public" hint="I return a structure of data about a specific field." output="false" returntype="any" _returntype="struct">
		<cfargument name="alias" hint="I am the alias of the field to get" required="yes" type="any" _type="string" />
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
	
	<cffunction name="getFieldList" access="public" hint="I return a list of fields in this object." output="false" returntype="any" _returntype="string">
		<cfset var fields = getFields() />
		<cfset var columList = "" />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfset columList = ListAppend(columList, fields[x].alias) />
		</cfloop>
		
		<cfreturn columList />
	</cffunction>
	
	<cffunction name="getExternalFieldList" access="public" hint="I return a list of external fields in this object." output="false" returntype="any" _returntype="string">
		<cfset var fields = getexternalFields() />
		<cfset var columList = "" />
		<cfset var x = 0 />
				
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfset columList = ListAppend(columList, fields[x].fieldAlias) />
		</cfloop>
		
		<cfreturn columList />
	</cffunction>
		
	<!--- hasSharedkey --->
	<cffunction name="hasSharedkey" access="public" hint="I indicate if any of this object's relationships to the object with the specified alias use shared keys." output="false" returntype="any" _returntype="boolean">
		<cfargument name="alias" hint="I am the alias of the related object." required="yes" type="any" _type="string" />
		<cfset var relationships = getRelationships(arguments.alias) />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
			<cfif StructKeyExists(relationships[x], "sharedKey") AND relationships[x].sharedKey IS true>
				<cfreturn true />
			</cfif>
		</cfloop>
		
		<cfreturn false />
	</cffunction>
	
	<!--- getRelationship --->
	<cffunction name="getRelationship" access="public" hint="I get a relationship by alias." output="false" returntype="any" _returntype="struct">
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship we're looking for." required="yes" type="any" _type="string" />
		<cfset var x = 0 />
				
		<!--- check hasManys first --->
		<cfloop from="1" to="#ArrayLen(variables.metadata.hasMany)#" index="x">
			<cfif variables.metadata.hasMany[x].alias IS arguments.relationshipAlias>
				<cfreturn Duplicate(variables.metadata.hasMany[x]) />
			</cfif>
		</cfloop>
		
		<!--- check hasOnes next --->
		<cfloop from="1" to="#ArrayLen(variables.metadata.hasOne)#" index="x">
			<cfif variables.metadata.hasOne[x].alias IS arguments.relationshipAlias>
				<cfreturn Duplicate(variables.metadata.hasOne[x]) />
			</cfif>
		</cfloop>
		
		<!--- throw an error! --->
		<cfthrow message="Relationship Does Not Exist" detail="The #getAlias()# object does not have a relationship with an alias of #arguments.relationshipAlias#" type="reactor.getRelationship.RelationshipDoesNotExist" />
		
	</cffunction>
	
	<!--- getRelationships --->
	<cffunction name="getRelationships" access="public" hint="I get an array of relationships.  I passed an alias I filter the relationships to only those that relate to the alias." output="false" returntype="any" _returntype="array">
		<cfargument name="alias" hint="I am the alias of the related object." required="no" type="any" _type="string" default="" />
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
	
	<!--- hasRelationship --->
	<cffunction name="hasRelationship" access="public" hint="I indicate if this object as a relationship with another object" output="false" returntype="any" _returntype="boolean">
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship we're looking for." required="yes" type="any" _type="string" />
		<cfset var x = 0 />
				
		<!--- check hasManys first --->
		<cfloop from="1" to="#ArrayLen(variables.metadata.hasMany)#" index="x">
			<cfif variables.metadata.hasMany[x].alias IS arguments.relationshipAlias>
				<cfreturn true />
			</cfif>
		</cfloop>
		
		<!--- check hasOnes next --->
		<cfloop from="1" to="#ArrayLen(variables.metadata.hasOne)#" index="x">
			<cfif variables.metadata.hasOne[x].alias IS arguments.relationshipAlias>
				<cfreturn true />
			</cfif>
		</cfloop>
		
		<cfreturn false />
	</cffunction>
		
	<!--- metadata --->
    <cffunction name="getObjectMetadata" access="public" output="false" returntype="any" _returntype="struct">
       <cfreturn variables.metadata />
    </cffunction>
	
	
	<cffunction name="getPrimaryKey" access="public" output="false" returntype="any" hint="I return the primary key if there is one">
		
		<cfset var fields = getFields()>
		<cfset var f = "">
		<cfloop array="#fields#" index="f">
			<cfif f.primaryKey>
				<cfreturn f.alias>
			</cfif>
		</cfloop>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getDisplayField" access="public" output="false" returntype="any" hint="I return the first most obvious field to use as a display">
		<cfset var fields=''>
		<cfset var f=''>

		<cfif hasField("name")>  <!--- Quick way to do this, so that we can always get the name field, which generally covers all bases --->
			<cfreturn "name">
		</cfif>
		
		<!--- If we didnt find a name field, lets get the first string field --->
		<cfset fields = getFields()>
		<cfloop array="#fields#" index="f">
			<cfif f.cfDataType EQ "string">
				<cfreturn f.alias>
			</cfif>
		</cfloop>
		<cfreturn "">
	</cffunction>
	
</cfcomponent>
