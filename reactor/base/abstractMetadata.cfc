<cfcomponent hint="I am an abstract Metadata.  I am used to define an interface and return types." extends="reactor.base.abstractObject">

	
	<!--- <cfset variables.metadataXml = XmlParse("<object></object>", false) /> --->
	
	<cffunction name="getQuerySafeTableAlias" access="public" hint="I return table alias formatted for the database." output="false" returntype="string">
		
	</cffunction>

	<cffunction name="getQuerySafeColumn" access="public" hint="I return a column expression formatted for the database." output="false" returntype="string">
		
	</cffunction>
	
	<cffunction name="getQuerySafeTableName" access="public" hint="I return a table expression formatted for the database." output="false" returntype="string">
		
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
	
	<cffunction name="getColumns" access="public" hint="I return an array of structures describing this object's columns" output="false" returntype="array">
		<cfreturn getObjectMetadata().columns />
	</cffunction>
	
	<cffunction name="getColumn" access="public" hint="I return a structure of data about a specific column." output="false" returntype="struct">
		<cfargument name="name" hint="I am the name of the column to get" required="yes" type="string" />
		<cfset var columns = getColumns() />
		<cfset var column = 0 />
		<cfset var x = 0 />
		
		<!--- loop over the columns and look for a match --->
		<cfloop from="1" to="#ArrayLen(columns)#" index="x">
			<cfif columns[x].name IS arguments.name>
				<cfset column = columns[x] />			
				<cfset column["table"] = getName() />
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfif IsStruct(column)>
			<!--- return the column's attributes --->
			<cfreturn column />
						
		<cfelseif hasSuper()>
			<cfreturn getSuperObjectMetadata().getColumn(arguments.name) />
			
		<cfelse>
			<cfthrow message="Field Does Not Exist" detail="The field '#arguments.name#' does not exist for the current object or any of its super objects." type="reactor.getColumn.FieldDoesNotExist" />
			
		</cfif>
	</cffunction>
	
	<cffunction name="getColumnList" access="public" hint="I return a list of columns in this object." output="false" returntype="string">
		<cfset var columns = getColumns() />
		<cfset var superColumns = 0 />
		<cfset var columList = "" />
		<cfset var column = "" />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(columns)#" index="x">
			<cfset columList = ListAppend(columList, columns[x].name) />
		</cfloop>
		
		<cfif hasSuper()>
			<cfset superColumns = getSuperObjectMetadata().getColumnList() />
			
			<cfloop list="#superColumns#" index="column">
				<cfif NOT ListFindNoCase(columList, column)>
					<cfset columList = ListAppend(columList, column) />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn columList />
	</cffunction>
	
	<cffunction name="hasSuper" access="public" hint="I indicate if the object has a super object." output="false" returntype="boolean">
		<cfreturn Len(StructKeyList(getObjectMetadata().super)) />
	</cffunction>
	
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
		
	<cffunction name="getSuperRelation" access="public" hint="I return an array of relationships between this object and it's super object" output="false" returntype="array">
		<cfreturn getObjectMetadata().super.relate />
	</cffunction>
		
	<cffunction name="getSuperName" access="public" hint="I return then name of this object's super object" output="false" returntype="string">
		<cfreturn getObjectMetadata().super.name />
	</cffunction>
	
	<cffunction name="getHasOneRelation" access="public" hint="I return an array of relationships between this object and the object it has one of." output="false" returntype="array">
		<cfargument name="name" hint="I am the name of the object related to" required="yes" type="string" />
		<cfset var hasOne = getObjectMetadata().hasOne />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(hasOne)#" index="x">
			<cfif hasOne[x].name IS arguments.name>
				<cfreturn hasOne[x].relate />
			</cfif>
		</cfloop>
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
	
	<cffunction name="getSuperObjectName" access="public" hint="I return the name of this object's super object." output="false" returntype="string">
		<cfif hasSuper()>
			<cfreturn getObjectMetadata().super.name />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
	<cffunction name="getRelatedMetadata" access="public" hint="I return the metadata object for the specified related." output="false" returntype="reactor.base.abstractMetadata">
		<cfargument name="name" hint="I am the name of the object related to" required="yes" type="string" />
		<cfif getRelationshipType(arguments.name) IS NOT "none">
			<cfreturn _getObjectFactory().create(arguments.name, "Metadata") />
		<cfelse>
			<cfthrow message="Object Does Not Have Related Object" detail="The '#getName()#' object does not have a related '#arguments.name#' object." type="reactor.getRelatedMetadata.ObjectDoesNotHaveRelatedObject" />
		</cfif>
	</cffunction>
		
	<cffunction name="getSuperObjectMetadata" access="public" hint="I return the metadata object for this object's super object." output="false" returntype="reactor.base.abstractMetadata">
		<cfif hasSuper()>
			<cfreturn _getObjectFactory().create(getSuperObjectName(), "Metadata") />
		<cfelse>
			<cfthrow message="Object Does Not Have a Super Object" detail="The '#getName()#' object does not have a super object." type="reactor.getSuperObjectMetadata.ObjectDoesNotHaveASuperObject" />
		</cfif>
	</cffunction>

	<!--- metadata --->
    <cffunction name="getObjectMetadata" access="public" output="false" returntype="struct">
       <cfreturn variables.metadata />
    </cffunction>

</cfcomponent>