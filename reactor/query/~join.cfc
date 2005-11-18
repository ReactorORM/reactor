<cfcomponent hint="I represent a join between two objects.">

	<cfset variables.type = "" />
	<cfset variables.fromObjectMetadata = "" />
	<cfset variables.toObjectMetadata = "" />
	<cfset variables.alias = "" />
	
	<!--- init --->
	<cffunction name="init" access="public" output="false" returntype="reactor.query.join">
		<cfargument name="type" hint="I am the type of join" required="yes" type="string" />
		<cfargument name="fromObjectMetadata" hint="I am the metadata of the from object" required="yes" type="reactor.base.abstractMetadata" />
		<cfargument name="toObjectMetadata" hint="I am the metadata of the to object" required="yes" type="reactor.base.abstractMetadata" />
		<cfargument name="alias" hint="I am the alias for this join.  All resulting columns will be prefixed with this alias" required="yes" type="string" />
		
		<cfset setType(arguments.type) />
		<cfset setFromObjectMetadata(arguments.fromObjectMetadata) />
		<cfset setToObjectMetadata(arguments.toObjectMetadata) />
		<cfset setAlias(arguments.alias) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- type --->
    <cffunction name="setType" access="public" output="false" returntype="void">
		<cfargument name="type" hint="I am the type of join" required="yes" type="string" />
		
		
		
		<cfset variables.type = arguments.type />
    </cffunction>
    <cffunction name="getType" access="public" output="false" returntype="string">
       <cfreturn variables.type />
    </cffunction>
	
	<!--- fromObjectMetadata --->
    <cffunction name="setFromObjectMetadata" access="public" output="false" returntype="void">
       <cfargument name="fromObjectMetadata" hint="I am the from object's metadata" required="yes" type="reactor.base.abstractMetadata" />
       <cfset variables.fromObjectMetadata = arguments.fromObjectMetadata />
    </cffunction>
    <cffunction name="getFromObjectMetadata" access="public" output="false" returntype="reactor.base.abstractMetadata">
       <cfreturn variables.fromObjectMetadata />
    </cffunction>
	
	<!--- toObjectMetadata --->
    <cffunction name="setToObjectMetadata" access="public" output="false" returntype="void">
       <cfargument name="toObjectMetadata" hint="I am the to object's metadata" required="yes" type="reactor.base.abstractMetadata" />
       <cfset variables.toObjectMetadata = arguments.toObjectMetadata />
    </cffunction>
    <cffunction name="getToObjectMetadata" access="public" output="false" returntype="reactor.base.abstractMetadata">
       <cfreturn variables.toObjectMetadata />
    </cffunction>
	
	<!--- alias --->
    <cffunction name="setAlias" access="public" output="false" returntype="void">
       <cfargument name="alias" hint="I am the alias for this join.  All resulting columns will be prefixed with this alias" required="yes" type="string" />
       <cfset variables.alias = arguments.alias />
    </cffunction>
    <cffunction name="getAlias" access="public" output="false" returntype="string">
       <cfreturn variables.alias />
    </cffunction>
	
</cfcomponent>