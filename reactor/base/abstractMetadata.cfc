<cfcomponent hint="I am an abstract Metadata.  I am used to define an interface and return types." extends="reactor.base.abstractObject">

	<cffunction name="getConventions" access="public" hint="I return a conventions object specific for this database type." output="false" returntype="reactor.data.abstractConvention">
		<cfreturn CreateObject("Component", "reactor.data.#getDbms()#.Convention") />
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
	
	<cffunction name="getOwner" access="public" hint="I return the owner of this object." output="false" returntype="string">
		<cfreturn getObjectMetadata().owner />
	</cffunction>
	
	<cffunction name="getType" access="public" hint="I return the type of object (view, table)." output="false" returntype="string">
		<cfreturn getObjectMetadata().type />
	</cffunction>
	
	<cffunction name="getFields" access="public" hint="I return an array of structures describing this object's fields" output="false" returntype="array">
		<cfreturn getObjectMetadata().fields />
	</cffunction>
	
	<cffunction name="getField" access="public" hint="I return a structure of data about a specific field." output="false" returntype="struct">
		<cfargument name="name" hint="I am the name of the field to get" required="yes" type="string" />
		<cfset var fields = getFields() />
		<cfset var field = 0 />
		<cfset var x = 0 />
		
		<!--- loop over the fields and look for a match --->
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfif fields[x].name IS arguments.name>
				<cfset field = fields[x] />
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfif IsStruct(field)>
			<!--- return the field's attributes --->
			<cfreturn field />
						
		<!--- <cfelseif hasSuper()>
			<cfreturn getSuperObjectMetadata().getField(arguments.name) /> --->
			
		<cfelse>
			<cfthrow message="Field Does Not Exist" detail="The field '#arguments.name#' does not exist for the '#getName()#' object." type="reactor.getField.FieldDoesNotExist" />
			
		</cfif>
	</cffunction>
	
	<cffunction name="getFieldList" access="public" hint="I return a list of fields in this object." output="false" returntype="string">
		<cfset var fields = getFields() />
		<cfset var superFields = 0 />
		<cfset var columList = "" />
		<cfset var field = "" />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfset columList = ListAppend(columList, fields[x].name) />
		</cfloop>
		
		<cfif hasSuper()>
			<cfset superFields = getSuperObjectMetadata().getFieldList() />
			
			<cfloop list="#superFields#" index="field">
				<cfif NOT ListFindNoCase(columList, field)>
					<cfset columList = ListAppend(columList, field) />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn columList />
	</cffunction>
	
	<!--- hasSuper --->
	<cffunction name="hasSuper" access="public" hint="I indicate if this object has a super relationship" output="false" returntype="boolean">
		<cfset var objectMetadata = getObjectMetadata() />
		
		<!--- check the super relationship --->
		<cfif IsDefined("objectMetadata.super.alias")>
			<cfreturn true />
		</cfif>
		
		<cfreturn false />
	</cffunction>
	
	<!--- getSuperAlias --->
	<cffunction name="getSuperAlias" access="public" hint="I return the super object's alias" output="false" returntype="string">
		<cfreturn getObjectMetadata().super.alias />
	</cffunction>
	
	<!--- getRelationship --->
	<cffunction name="getRelationship" access="public" hint="I get a relationship by name or alias" output="false" returntype="struct">
		<cfargument name="name" hint="I am the name or alias of the related object." required="yes" type="string" />
		<cfset var objectMetadata = getObjectMetadata() />
		<cfset var relationships = 0 />
		<cfset var x = 0 />
		
		<!--- check the super relationship --->
		<cfif IsDefined("objectMetadata.super.alias") AND objectMetadata.super.alias IS arguments.name>
			<cfreturn objectMetadata.super />
		</cfif>
		
		<!--- check the hasone relationships --->
		<cfif ArrayLen(objectMetadata.hasOne)>
			<cfset relationships = objectMetadata.hasOne />
			<!--- loop over the relationships and find a match --->
			<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
				<cfif relationships[x].alias IS arguments.name>
					<!--- this is a match --->
					<cfreturn relationships[x]/>
				</cfif> 
			</cfloop>
		</cfif>
		
		<!--- check the hasMany relationships --->
		<cfif ArrayLen(objectMetadata.hasMany)>
			<cfset relationships = objectMetadata.hasMany />
			<!--- loop over the relationships and find a match --->
			<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
				<cfif relationships[x].alias IS arguments.name>
					<!--- this is a match --->
					<cfreturn relationships[x]/>
				</cfif> 
			</cfloop>
		</cfif>
		
		<cfthrow message="Relationship Does Not Exist" detail="The object '#getName()#' does have have a relationship with an alias or name of '#arguments.name#'." type="reactor.getRelationship.RelationshipDoesNotExist" />
	</cffunction>
		
	<!---- getRelationshipMetadata --->
	<cffunction name="getRelationshipMetadata" access="public" hint="I return a related object's metadata based on the provided alias or name" output="false" returntype="reactor.base.abstractMetadata">
		<cfargument name="name" hint="I am the name or alias of the related object." required="yes" type="string" />
		<cfset var relationship = getRelationship(arguments.name) />
		<cfset var RelationshipMetadata = _getReactorFactory().createMetadata(relationship.name) />
		
		<cfreturn RelationshipMetadata />
	</cffunction>
	
	<!--- metadata --->
    <cffunction name="getObjectMetadata" access="public" output="false" returntype="struct">
       <cfreturn variables.metadata />
    </cffunction>

</cfcomponent>


<!---
	<cffunction name="getSuperRelation" access="public" hint="I return an array of relationships between this object and it's super object" output="false" returntype="array">
		<cfreturn getObjectMetadata().super.relate />
	</cffunction>
		
	<!--- getSuperName --->
	<cffunction name="getSuperName" access="public" hint="I return then name of this object's super object" output="false" returntype="string">
		<cfreturn getObjectMetadata().super.name />
	</cffunction>
		
	<!--- getSuperAlias --->
	<cffunction name="getSuperAlias" access="public" hint="I return then name of the alias for the super object relationship" output="false" returntype="string">
		<cfreturn getObjectMetadata().super.alias />
	</cffunction>
	
	<!--- getSuperObjectName --->
	<cffunction name="getSuperObjectName" access="public" hint="I return the name of this object's super object." output="false" returntype="string">
		<cfif hasSuper()>
			<cfreturn getObjectMetadata().super.name />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
		
	<!--- getSuperObjectMetadata --->
	<cffunction name="getSuperObjectMetadata" access="public" hint="I return the metadata object for this object's super object." output="false" returntype="reactor.base.abstractMetadata">
		<cfif hasSuper()>
			<cfreturn _getObjectFactory().create(getSuperObjectName(), "Metadata") />
		<cfelse>
			<cfthrow message="Object Does Not Have a Super Object" detail="The '#getName()#' object does not have a super object." type="reactor.getSuperObjectMetadata.ObjectDoesNotHaveASuperObject" />
		</cfif>
	</cffunction>
	
	<!--- getRelationship --->
	<cffunction name="getRelationship" access="public" hint="I return a relationship by its alias." output="false" returntype="struct">
		<cfargument name="alias" hint="I am the name of the object related to" required="yes" type="string" />
		<cfset var relationships = StructNew() />
		<cfset var relationship = 0 />
		<cfset var item = 0 />
		<cfset var x = 0 />
		
		<!--- to get a relationship I need to find it. --->
		<cfset relationships.super = Duplicate(getObjectMetadata().super) />
		<cfset relationships.hasMany = Duplicate(getObjectMetadata().hasMany) />
		<cfset relationships.hasOne = Duplicate(getObjectMetadata().hasOne) />
		
		<!--- loop over the relationship types --->
		<cfloop collection="#relationships#" item="item">
			<cfset relationship = relationships[item] />
			
			<!--- super objects will never be an array --->
			<cfif IsArray(relationship)>
				
				<!--- loop over the array of this relationship type --->
				<cfloop from="#ArrayLen(relationship)#" to="1" index="x" step="-1">
					<cfif relationship[x].alias IS arguments.alias>
						<cfset relationship = relationship[x] />
						<cfset relationship.type =  lcase(item) />
						<cfreturn relationship />
					</cfif>
				</cfloop>
				
			<cfelse>
				
				<!--- check to see if the superobject is the named relationship --->
				<cfif relationship.alias IS arguments.alias>
					<cfset relationship.type =  lcase(item) />
					<cfreturn relationship />
				</cfif>
						
			</cfif>
		</cfloop>
		
		<cfthrow message="Object Does Not Have Relation" detail="The '#getName()#' object does not have a relation named '#arguments.alias#'." type="reactor.getRelationship.ObjectDoesNotHaveRelation" />
	</cffunction>
	
	<cffunction name="hasRelationship" access="public" hint="I indicate if this object has any realtionships with the specified alias" output="false" returntype="boolean">
		<cfargument name="alias" hint="I am the alias of the relationship" required="yes" type="string" />
		
		<!--- to know if an object has a relationship I've got to try to find it --->
		<cftry>
			<cfset getRelationship(arguments.alias) />
			<cfcatch>
				<cfreturn false>
			</cfcatch>
		</cftry>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="getRelationshipObjectName" access="public" hint="I return a relationship's target object based on an provided alias" output="false" returntype="string">
		<cfargument name="alias" hint="I am the alias of the relationship" required="yes" type="string" />
		
		<cfreturn getRelationship(arguments.alias).name />
	</cffunction>
	
	<cffunction name="getRelatedObjectMetadata" access="public" hint="I return the metadata object for the specified related object." output="false" returntype="reactor.base.abstractMetadata">
		<cfargument name="alias" hint="I am the alias of the relation to" required="yes" type="string" />
		<!--- before I can get a related object's metadata I have to know that it's related --->
		
		<cfif hasRelationship(arguments.alias)>
			<cfreturn _getObjectFactory().create(getRelationshipObjectName(arguments.alias), "Metadata") />
		<cfelse>
			<cfthrow message="Object Does Not Have Related Object" detail="The '#getName()#' object does not have a related '#arguments.alias#' object." type="reactor.getRelatedMetadata.ObjectDoesNotHaveRelatedObject" />
		</cfif>
	</cffunction>
	
	
	<!--- 
	<cffunction name="getRelationshipType" access="public" hint="I return a string value indicating what type if relationship this object has to the specified object.  Returns:  hasOne, hasMany, super or none" output="false" returntype="string">
		<cfargument name="name" hint="I am the name of the object related to" required="yes" type="string" />
		
		<!--- check for a super relationship --->
		<cfif hasSuper() AND getSuperName() IS arguments.name>
			<cfreturn "super" />
		
		<!--- check for a hasOne relationship --->
		<cfelseif hasOne(arguments.name)>
			<cfreturn "hasOne" />
		
		<!--- check for a hasMany relationship --->
		<cfelseif hasMany(arguments.name)>
			<cfreturn "hasMany" />
		
		<!--- no relationship! --->
		<cfelse>
			<cfreturn "none" />
		
		</cfif>
		
		<cfabort showerror="got here?" />
		
	</cffunction>
	--->
	
	<cffunction name="getHasOneRelationships" access="public" hint="I return an array of has-one relationships between this object and the named object." output="false" returntype="array">
		<cfargument name="name" hint="I am the name of the object related to" required="yes" type="string" />
		<cfreturn getHasRelationships(arguments.name).hasOne />
	</cffunction>
	
	<cffunction name="hasOne" access="public" hint="I indicate of this object has one of another object." output="false" returntype="boolean">
		<cfargument name="name" hint="I am the name of the object to check for" required="yes" type="string" />
		<cfreturn ListFindNoCase(getHasOneList(), arguments.name) />
	</cffunction>
	
	<cffunction name="hasMany" access="public" hint="I indicate of this object has many of another object." output="false" returntype="boolean">
		<cfargument name="name" hint="I am the name of the object to check for" required="yes" type="string" />
		<cfreturn ListFindNoCase(getHasManyList(), arguments.name) />
	</cffunction>
	
	<cffunction name="getHasOneList" access="public" hint="I return list of objects this object has one of." output="false" returntype="string">
		<cfset var hasOne = getObjectMetadata().hasOne />
		<cfset var hasOneList = "" />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(hasOne)#" index="x">
			<cfset hasOneList = ListAppend(hasOneList, hasOne[x].name) />
		</cfloop>
		
		<cfreturn hasOneList />
	</cffunction>
	
	<cffunction name="getHasManyList" access="public" hint="I return list of objects this object has many one of." output="false" returntype="string">
		<cfset var hasMany = getObjectMetadata().hasMany />
		<cfset var hasManyList = "" />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(hasMany)#" index="x">
			<cfset hasManyList = ListAppend(hasManyList, hasMany[x].name) />
		</cfloop>
		
		<cfreturn hasManyList />
	</cffunction>
	
	<cffunction name="getHasMany" access="public" hint="I return a has many structure relationshipt" output="false" returntype="struct">
		<cfargument name="name" hint="I am the name of the object related to" required="yes" type="string" />
		<cfset var hasMany = getObjectMetadata().hasMany />
		
		<cfloop from="1" to="#ArrayLen(hasMany)#" index="x">
			<cfif hasMany[x].name IS arguments.name>
				<cfreturn hasMany[x] />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="getHasManyRelation" access="public" hint="I return an array of relationships between this object and the object it many of." output="false" returntype="array">
		<cfargument name="name" hint="I am the name of the object related to" required="yes" type="string" />
		<cfset var hasMany = getHasMany(arguments.name) />
		<cfset var x = 0 />
		
		<cfreturn hasMany.relate />		
	</cffunction>
	
	<cffunction name="getHasManyLink" access="public" hint="I return a structure describing the relationship between this object and a linked object." output="false" returntype="struct">
		<cfargument name="name" hint="I am the name of the object related to" required="yes" type="string" />
		<cfset var hasMany = getHasMany(arguments.name) />
		<cfset var link = StructNew() />
		<cfset var linkObject = _getObjectFactory().create(hasMany.link, "Metadata") />
		<cfset var x = 0 />
		
		<cfset link["link"] = linkObject.getName() />
		<cfset link[getName()] = linkObject.getHasOneRelation(getName()) />
		<cfset link[arguments.name] = linkObject.getHasOneRelation(arguments.name) />
		
		<cfreturn link />
	</cffunction>
	
	<cffunction name="getHasManyRelationshipType" access="public" hint="I return type of has many relationship." output="false" returntype="string">
		<cfargument name="name" hint="I am the name of the object related to" required="yes" type="string" />
		<cfset var hasMany = getHasMany(arguments.name) />
		
		<cfif IsDefined("hasMany.link")>
			<cfreturn "link" />
		<cfelse>
			<cfreturn "relate" />
		</cfif>
	</cffunction>
	--->