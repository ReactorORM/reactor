<cfcomponent hint="I am a relationship between two objects">
	
	<cfset variables.fromField = 0 />
	<cfset variables.toField = 0 />
	
	<!--- init --->
	<cffunction name="init" access="public" hint="I represent a relationship between two fields" output="false" returntype="reactor.query.relationship">
		<cfargument name="fromField" hint="I am the from field" required="yes" type="reactor.query.field" />
		<cfargument name="toField" hint="I am the to field" required="yes" type="reactor.query.field" />
	
		<cfset setFromField(arguments.fromField) />
		<cfset setToField(arguments.toField) />
	
		<cfreturn this />
	</cffunction>
	
	<!--- fromField --->
    <cffunction name="setFromField" access="private" output="false" returntype="void">
       <cfargument name="fromField" hint="I am the from field" required="yes" type="reactor.query.field" />
       <cfset variables.fromField = arguments.fromField />
    </cffunction>
    <cffunction name="getFromField" access="package" output="false" returntype="reactor.query.field">
       <cfreturn variables.fromField />
    </cffunction>
	
	<!--- toField --->
    <cffunction name="setToField" access="private" output="false" returntype="void">
       <cfargument name="toField" hint="I am the to field" required="yes" type="reactor.query.field" />
       <cfset variables.toField = arguments.toField />
    </cffunction>
    <cffunction name="getToField" access="package" output="false" returntype="reactor.query.field">
       <cfreturn variables.toField />
    </cffunction>
	
</cfcomponent>