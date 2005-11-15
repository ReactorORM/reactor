<cfcomponent hint="I am an abstract Metadata.  I am used to define an interface and return types." extends="reactor.base.abstractObject">

	<cfset variables.metadataXml = XmlParse("<object></object>", false) />
	
	<cffunction name="getQuerySafeTableAlias" access="public" hint="I return table alias formatted for the database." output="false" returntype="string">
		
	</cffunction>

	<cffunction name="getQuerySafeColumn" access="public" hint="I return a column expression formatted for the database." output="false" returntype="string">
		
	</cffunction>
	
	<cffunction name="getQuerySafeTableName" access="public" hint="I return a table expression formatted for the database." output="false" returntype="string">
		
	</cffunction>
	
	<cffunction name="setMetadataXml" access="private" hint="I set the metadata and fix it as I do so." output="false" returntype="void">
		<cfargument name="metadataXml" hint="I am the metadata to fix and set" required="yes" type="string" />
		<cfset variables.metadataXml = XmlParse(arguments.metadataXml, false) />
	</cffunction>

	<cffunction name="getDatabase" access="public" hint="I return the name of the database this object is in." output="false" returntype="string">
		<cfreturn getMetadataXml().object.XmlAttributes.database />
	</cffunction>

	<cffunction name="getDbms" access="public" hint="I return the name of the database this object is in." output="false" returntype="string">
		<cfreturn getMetadataXml().object.XmlAttributes.dbms />
	</cffunction>
	
	<cffunction name="getName" access="public" hint="I return the name of the object." output="false" returntype="string">
		<cfreturn getMetadataXml().object.XmlAttributes.name />
	</cffunction>
	
	<cffunction name="getOwner" access="public" hint="I return the owner of this object." output="false" returntype="string">
		<cfreturn getMetadataXml().object.XmlAttributes.owner />
	</cffunction>
	
	<cffunction name="getType" access="public" hint="I return the type of object (view, table)." output="false" returntype="string">
		<cfreturn getMetadataXml().object.XmlAttributes.type />
	</cffunction>
	
	<cffunction name="getColumn" access="public" hint="I return a structure of data about a specific column." output="false" returntype="struct">
		<cfargument name="name" hint="I am the name of the column to get" required="yes" type="string" />
		<!--- <cfset var column = XmlSearch(getMetadataXml(), "//column[@name = '#arguments.name#']") /> --->
		<cfset var columns = 0 />
		<cfset var column = 0 />
		<cfset var x = 0 />
		
		<!--- loop over the columns and look for a match --->
		
		<cfset columns = XmlSearch(getMetadataXml(), "//column") />
		<cfloop from="1" to="#ArrayLen(columns)#" index="x">
			<cfif columns[x].XmlAttributes.name IS arguments.name>
				<cfset column = columns[x].XmlAttributes />			
				<cfset column["table"] = getName() />
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
		<cfset var columns = XmlSearch(getMetadataXml(), "//column[@overridden = 'false']") />
		<cfset var superColumns = 0 />
		<cfset var columList = "" />
		<cfset var column = "" />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(columns)#" index="x">
			<cfset columList = ListAppend(columList, columns[x].XmlAttributes.name) />
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
		
	<!--- <cffunction name="getColumnMetadata" access="public" hint="I return a structure of information about a column" output="false" returntype="struct">
		<cfargument name="name" hint="I am the name of the column" required="yes" type="string" />
		<cfset var columns = XmlSearch(getMetadataXml(), "//column") />
		<cfset var column = 0 />
		<cfset var x = 0 />
		
		<!--- find the column named with the name argument --->
		<cfloop from="1" to="#ArrayLen(columns)#" index="x">
			<cfset column = columns[x].XmlAttributes />
			<cfif column.name IS arguments.name>
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfreturn column />
	</cffunction> --->
	
	<cffunction name="hasSuper" access="public" hint="I indicate if the object has a super object." output="false" returntype="boolean">
		<cfreturn ArrayLen(XmlSearch(getMetadataXml(), "object/super")) IS 1 />
	</cffunction>
	
	<cffunction name="getSuperRelation" access="public" hint="I return an array of relationships between this object and it's super object" output="false" returntype="array">
		<cfreturn getRelationArray("/object/super/relate") />
	</cffunction>
	
	<cffunction name="getHasOneRelation" access="public" hint="I return an array of relationships between this object and the object it has one of." output="false" returntype="array">
		<cfargument name="name" hint="I am the name of the object related to" required="yes" type="string" />
		<cfreturn getRelationArray("/object/hasOne[@name = '#arguments.name#']/relate") />
	</cffunction>
	
	<cffunction name="getHasOneList" access="public" hint="I return list of objects this object has one of." output="false" returntype="string">
		<cfreturn getRelationList("/object/hasOne/@name") />
	</cffunction>
	
	<cffunction name="getHasManyList" access="public" hint="I return list of objects this object has many one of." output="false" returntype="string">
		<cfreturn getRelationList("/object/hasMany/@name") />
	</cffunction>
	
	<cffunction name="getHasManyRelation" access="public" hint="I return an array of relationships between this object and the object it many of." output="false" returntype="array">
		<cfargument name="name" hint="I am the name of the object related to" required="yes" type="string" />
		<cfreturn getRelationArray("/object/hasMany[@name = '#arguments.name#']/relate") />
	</cffunction>
	
	<cffunction name="getHasManyLink" access="public" hint="I return a structure describing the relationship between this object and a linked object." output="false" returntype="struct">
		<cfargument name="name" hint="I am the name of the object related to" required="yes" type="string" />
		<cfset var linkObject = XmlSearch(getMetadataXml(), "/object/hasMany[@name = '#arguments.name#']/link/@name") />
		<cfset var link = StructNew() />
		<cfset linkObject = getObjectFactory().create(linkObject[1].XmlValue, "Metadata") />
		<cfset link["link"] = linkObject.getName() />
		<cfset link[getName()] = linkObject.getHasOneRelation(getName()) />
		<cfset link[arguments.name] = linkObject.getHasOneRelation(arguments.name) />
		
		<cfreturn link />
	</cffunction>
	
	<cffunction name="getHasManyRelationshipType" access="public" hint="I return type of has many relationship." output="false" returntype="string">
		<cfargument name="name" hint="I am the name of the object related to" required="yes" type="string" />
		
		<cfif ArrayLen(XmlSearch(getMetadataXml(), "/object/hasMany[@name = '#arguments.name#']/link"))>
			<cfreturn "link" />
		<cfelse>
			<cfreturn "relate" />
		</cfif>
	</cffunction>
	
	<cffunction name="getRelationArray" access="private" hint="I return an array of relationships" output="false" returntype="array">
		<cfargument name="node" hint="I am the node to translate into an array of structures" required="yes" type="string" />
		<cfset var relations = XmlSearch(getMetadataXml(), arguments.node) />
		<cfset var relationsArray = ArrayNew(1) />
		<cfset var x = 0 />
				
		<cfloop from="1" to="#ArrayLen(relations)#" index="x">
			<cfset relationsArray[x] = StructNew() />
			<cfset relationsArray[x].from = relations[x].XmlAttributes.from />
			<cfset relationsArray[x].to = relations[x].XmlAttributes.to />
		</cfloop>
		
		<cfreturn relationsArray />		
	</cffunction>
	
	<cffunction name="getRelationList" access="private" hint="I return an array of relationships" output="false" returntype="string">
		<cfargument name="node" hint="I am the node to translate into an array of structures" required="yes" type="string" />
		<cfset var relations = XmlSearch(getMetadataXml(), arguments.node) />
		<cfset var relationsList = "" />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(relations)#" index="x">
			<cfset relationsList = ListAppend(relationsList, relations[x].XmlValue) />
		</cfloop>
		
		<cfreturn relationsList />		
	</cffunction>
	
	<cffunction name="getSuperObjectName" access="public" hint="I return the name of this object's super object." output="false" returntype="string">
		<cfif hasSuper()>
			<cfreturn getMetadataXml().object.super.XmlAttributes.name />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
	<cffunction name="getSuperObjectMetadata" access="public" hint="I return the metadata object for this object's super object." output="false" returntype="reactor.base.abstractMetadata">
		<cfif hasSuper()>
			<cfreturn getObjectFactory().create(getSuperObjectName(), "Metadata") />
		<cfelse>
			<cfthrow message="Object Does Not Have a Super Object" detail="The '#getName()#' object does not have a super object." type="reactor.getSuperObjectMetadata.ObjectDoesNotHaveASuperObject" />
		</cfif>
	</cffunction>
	
	<!--- <cffunction name="isBase" access="private" output="false" returntype="boolean">
		<cfreturn NOT ArrayLen(XmlSearch(getMetadataXml(), "//columns")) />
	</cffunction> --->
	
	<!--- metadata --->
    <cffunction name="getMetadataXml" access="public" output="false" returntype="xml">
       <cfreturn variables.metadataXml />
    </cffunction>

</cfcomponent>