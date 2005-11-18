<cfcomponent hint="I am a join between two objects">
	
	<!--- I am the objects being joined to --->
	<cfset variables.FromObject = 0 />
	<cfset variables.ToObject = 0 />
	
	<!--- the type of join --->
	<cfset variables.join = "" />
	
	<!--- relationships --->
	<cfset variables.relationships = ArrayNew(1) />
	
	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the join" output="false" returntype="reactor.query.join">
		<cfargument name="FromObject" hint="I am the object being joined from." required="yes" type="reactor.query.object" />
		<cfargument name="ToObject" hint="I am the object being joined to." required="yes" type="reactor.query.object" />
		<cfargument name="type" hint="I am the type of join. Options are: left, right, full" required="no" type="string" default="left" />
		
		<cfset setFromObject(arguments.FromObject) />
		<cfset setToObject(arguments.ToObject) />	
		<cfset setType(arguments.type) />
		
		<cfset addRelationships() />
		
		<cfreturn this />
	</cffunction>
	
	<!--- getAsString --->
	<cffunction name="getAsString" access="package" hint="I get this object as fragment of a from statement" output="false" returntype="string">
		<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="reactor.data.abstractConvention" />
		<cfargument name="fromAlias" hint="I am the from alias" required="yes" type="string" />
		<cfargument name="toAlias" hint="I am the to alias" required="yes" type="string" />
		<cfset var relationships = getRelationships() />
		<cfset var x = 0 />
		<cfset var output = "" />
		<cfset var fromName = "" />
		<cfset var toName = "" />
		
		<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
			<cfset fromName = arguments.Convention.formatFieldName(relationships[x].getFromField(), fromAlias) />
			<cfset toName = arguments.Convention.formatFieldName(relationships[x].getToField(), toAlias) />
			<cfset output = output & fromName & " = " & toName />
		</cfloop>
		
		<cfreturn output & " " />
	</cffunction>
	
	<!--- addRelationships --->
	<cffunction name="addRelationships" access="public" hint="I add a relationship to this join." output="false" returntype="void">
		<cfset var FromObjectMetadata = getFromObject().getObjectMetadata() />
		<cfset var relationships = FromObjectMetadata.getRelationship(getToObject().getAlias()).relate />
		<cfset var Relationship = 0 />
		
		<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
			<cfset addRelationship(CreateObject("Component", "reactor.query.relationship").init(relationships[x].from, relationships[x].to)) />
		</cfloop>
	</cffunction>
	
	<!--- addRelationship --->
	<cffunction name="addRelationship" access="private" hint="I add a relationship to this join." output="false" returntype="void">
		<cfargument name="Relationship" hint="I am a relationshop between fields in the two objects" required="yes" type="reactor.query.relationship" />
		<cfset var relationships = getRelationships() />
		
		<cfset ArrayAppend(relationships, arguments.Relationship) />
		
		<cfset setRelationships(relationships) />
	</cffunction>
	
	<!--- fromObject --->
    <cffunction name="setFromObject" access="private" output="false" returntype="void">
       <cfargument name="fromObject" hint="I am the object being joined from" required="yes" type="reactor.query.object" />
       <cfset variables.fromObject = arguments.fromObject />
    </cffunction>
    <cffunction name="getFromObject" access="private" output="false" returntype="reactor.query.object">
       <cfreturn variables.fromObject />
    </cffunction>
	
	<!--- toObject --->
    <cffunction name="setToObject" access="private" output="false" returntype="void">
       <cfargument name="toObject" hint="I am the object being joined to" required="yes" type="reactor.query.object" />
       <cfset variables.toObject = arguments.toObject />
    </cffunction>
    <cffunction name="getToObject" access="package" output="false" returntype="reactor.query.object">
       <cfreturn variables.toObject />
    </cffunction>
	
	<!--- relationships --->
    <cffunction name="setRelationships" access="private" output="false" returntype="void">
       <cfargument name="relationships" hint="I am an array of column relationships" required="yes" type="array" />
       <cfset variables.relationships = arguments.relationships />
    </cffunction>
    <cffunction name="getRelationships" access="package" output="false" returntype="array">
       <cfreturn variables.relationships />
    </cffunction>
		
	<!--- type --->
    <cffunction name="setType" access="public" output="false" returntype="void">
		<cfargument name="type" hint="I am the type of join" required="yes" type="string" />
		
		<cfif NOT ListFindNoCase("left,right,full", arguments.type)>
			<cfthrow message="Invalid Join Type" detail="The join type '#arguments.type#' is not a valdid join type.  Options are: left, right, full" type="reactor.setType.InvalidJoinType" />
		</cfif>
		
		<cfset variables.type = arguments.type />
    </cffunction>
    <cffunction name="getType" access="public" output="false" returntype="string">
       <cfreturn variables.type />
    </cffunction>
	
</cfcomponent>