<cfcomponent hint="I represent an object being queried.">

	<!--- this is metadata on the actual object --->
	<cfset variables.ObjectMetadata = 0 />
	
	<!--- this is the object's alias --->
	<cfset variables.alias = "" />
	
	<!--- this is an array of objects this object is joined to --->
	<cfset variables.joins = ArrayNew(1) />
	
	<!--- init --->
	<cffunction name="init" access="public" hint="I am configure and return the query object" output="false" returntype="reactor.query.object">
		<cfargument name="ObjectMetadata" hint="I am the metadata for the object being encapsulated" required="yes" type="reactor.base.abstractMetadata" />
		<cfargument name="alias" hint="I am a required alias for this object." required="yes" type="string" />
		
		<cfset setObjectMetadata(arguments.ObjectMetadata) />
		<cfset setAlias(arguments.alias) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- getFromAsString --->
	<cffunction name="getFromAsString" access="package" hint="I get this object as fragment of a from statement" output="false" returntype="string">
		<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="reactor.data.abstractConvention" />
		<cfargument name="Join" hint="I am the Join object linking this object and the object it is joined to." required="no" type="reactor.query.join" />
		<cfargument name="previousAlias" hint="I am the alias of the previous object." required="no" type="string" />
		<cfset var from = arguments.Convention.formatObjectAlias(this.getObjectMetadata(), getAlias()) & " " />
		<cfset var joins = getJoins() />
		<cfset var relationships = 0 />
		<cfset var x = 0 />
		
		<!--- if there's a join comming into this object then output the ON expression --->
		<cfif IsDefined("arguments.Join")>
			<cfset from = from & chr(13) & chr(10) />
			<cfset from = from & " ON " & arguments.Join.getAsString(arguments.Convention, arguments.previousAlias, getAlias())  />
		</cfif>
		
		<cfloop from="1" to="#ArrayLen(joins)#" index="x">
			<cfset from = from & chr(13) & chr(10) />
			<cfset from = from & UCase(joins[x].getType()) & " JOIN " & joins[x].getToObject().getFromAsString(arguments.Convention, joins[x], getAlias()) />
			<cfset from = from & chr(13) & chr(10) />
		</cfloop>
		
		<cfreturn from />
		
	</cffunction>
	
	<!--- getSelectAsString --->
	<cffunction name="getSelectAsString" access="package" hint="I get this object as fragment of a select statement" output="false" returntype="string">
		<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="reactor.data.abstractConvention" />
		<cfargument name="returnFields" hint="I am an array of fields to return. If empty, return all fields." required="yes" type="array" />
		<cfargument name="prefix" hint="I am a prefix prepended to columns retured from this join" required="no" type="string" default="" />
		<cfset var select = "" />
		<cfset var field = "" />
		<cfset var joinedFields = "" />
		<cfset var fields = getObjectMetadata().getFields() />
		<cfset var joins = getJoins() />
		<cfset var x = 0 />
		<cfset var allowedFieldList = getAllowedFields(arguments.returnFields) />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfset field = arguments.Convention.formatFieldName(fields[x].name, getAlias()) & " AS " />
			
			<!--- add the field alias --->
			<cfset field = field & arguments.Convention.formatFieldAlias(fields[x].alias, arguments.prefix) />
			
			<cfif NOT ArrayLen(arguments.returnFields) OR ListFindNoCase(allowedFieldList, fields[x].alias) OR ListFindNoCase(allowedFieldList, alias) >
				<cfset select = ListAppend(select, field & chr(13) & chr(10)) />
			</cfif>
		</cfloop>
		
		<cfloop from="1" to="#ArrayLen(joins)#" index="x">
			<cfset joinedFields = joins[x].getToObject().getSelectAsString(arguments.Convention, arguments.returnFields, joins[x].getPrefix()) />
			
			<cfif Len(joinedFields)>
				<cfset select = ListAppend(select, joinedFields) />
			</cfif>
		</cfloop>
		
		<!--- add spaces after commas --->
		<cfset select = Replace(select, ",", ", ", "all") />
	
		<cfreturn select />		
	</cffunction>
	
	<!--- getAllowedFields --->
	<cffunction name="getAllowedFields" access="private" hint="I translate the array of fields into a list of fields relevant to this object which can be returned." output="false" returntype="string">
		<cfargument name="returnFields" hint="I am an array of fields to return. If empty, return all fields." required="yes" type="array" />
		<cfset var x = 0 />
		<cfset var Field = 0 />
		<cfset var fields = "" />
		
		<cfloop from="1" to="#ArrayLen(arguments.returnFields)#" index="x">
			<cfset Field = arguments.returnFields[x] />
			
			<!--- if this field is in this object append it ot the list of fields --->
			<cfif Field.getObject() IS this.getAlias()>
				<cfset fields = ListAppend(fields, Field.getAlias()) />
			</cfif>
		</cfloop>
		
		<cfreturn fields />
	</cffunction>
	
	<!--- findObject --->
	<cffunction name="findObject" access="public" hint="I find an object in the query" output="false" returntype="reactor.query.object">
		<cfargument name="alias" hint="I am the alias of a object being searched for." required="yes" type="string" />
		<cfset var joins = getJoins() />
		<cfset var Join = 0 />
		<cfset var x = 0 />
		
		<!--- am I what's being looked for? --->
		<cfif getAlias() IS arguments.alias>
			<!--- yes --->
			<cfreturn this />
			
		<cfelse>
			<!--- no, loop over all my sub-objects and check them --->
			<cfloop from="1" to="#ArrayLen(joins)#" index="x">
				<cfset Join = joins[x] />
				
				<cftry>
					<cfreturn Join.getToObject().findObject(arguments.alias) />
					<cfcatch />
				</cftry>
			</cfloop>
		</cfif>

		<cfthrow message="Can Not Find Object" detail="Can not find the object '#arguments.alias#' as an alias within the query." type="reactor.findObject.CanNotFindObject" />
	</cffunction>
	
	<!--- getRelatedObject --->
	<cffunction name="getRelatedObject" access="public" hint="I return a related object." output="false" returntype="reactor.query.object">
		<cfargument name="alias" hint="I am the alias of a related object to get." required="yes" type="string" />
		<cfset var relationshipStruct = getObjectMetadata().getRelationship(arguments.alias) />
		<cfset var RelatedObjectMetadata = 0 />
		<cfset var RelatedObject = 0 />
		
		<!--- check to see if this is a linked table --->
		<cfif IsDefined("relationshipStruct.link")>
			<cfthrow message="Can Not Get Related Objects From HasMany Links" detail="Can't get relation from '#getObjectMetadata().getName()#' to '#arguments.alias#' via a hasMany relationship.  You need to explicity use the intermediary object, '#relationshipStruct.link#'." type="reactor.getRelatedObject.CanNotGetRelatedObjectsFromHasManyLinks" />
		</cfif>
		
		<!--- if it's not a linked table get the related object's metadata --->
		<cfset RelatedObjectMetadata = getObjectMetadata().getRelationshipMetadata(arguments.alias) />
		
		<!--- create the related object --->
		<cfset RelatedObject = CreateObject("Component", "reactor.query.object").init(RelatedObjectMetadata, arguments.alias) />
		
		<!--- return the related object --->
		<cfreturn RelatedObject />
	</cffunction>
	
	<!--- join --->
	<cffunction name="join" access="public" hint="I add a join from this object to another object." output="false" returntype="void">
		<cfargument name="ToObject" hint="I am the query object being joined to" required="yes" type="reactor.query.object" />
		<cfargument name="toPrefix" hint="I am the prefix appended to all fields in the ToObject." required="yes" type="string" />
		<cfargument name="type" hint="I am the type of join." required="yes" type="string" />
		<cfset var joins = getJoins() />
		<cfset var Join = CreateObject("Component", "reactor.query.join").init(this, arguments.ToObject, arguments.toPrefix, arguments.type) />
		
		<cfset ArrayAppend(joins, join) />
		<cfset setJoins(joins) />
	</cffunction>
	
	<!--- objectMetadata --->
    <cffunction name="setObjectMetadata" access="private" output="false" returntype="void">
       <cfargument name="objectMetadata" hint="I am the object's metadata" required="yes" type="reactor.base.abstractMetadata" />
       <cfset variables.objectMetadata = arguments.objectMetadata />
    </cffunction>
    <cffunction name="getObjectMetadata" access="package" output="false" returntype="reactor.base.abstractMetadata">
       <cfreturn variables.objectMetadata />
    </cffunction>
	
	<!--- alias --->
    <cffunction name="setAlias" access="private" output="false" returntype="void">
       <cfargument name="alias" hint="I am the object's alias" required="yes" type="string" />
       <cfset variables.alias = arguments.alias />
    </cffunction>
    <cffunction name="getAlias" access="package" output="false" returntype="string">
       <cfreturn variables.alias />
    </cffunction>
	
	<!--- joins --->
    <cffunction name="setJoins" access="private" output="false" returntype="void">
       <cfargument name="joins" hint="I am the joins from this object to other objects" required="yes" type="array" />
       <cfset variables.joins = arguments.joins />
    </cffunction>
    <cffunction name="getJoins" access="private" output="false" returntype="array">
       <cfreturn variables.joins />
    </cffunction>
	
</cfcomponent>