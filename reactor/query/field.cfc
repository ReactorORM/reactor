<cfcomponent hint="I represent an object and field name.  Nothing more.">

	<cfset variables.object = "" />
	<cfset variables.field = "" />
	<cfset variables.alias = "" />

	<cffunction name="init" access="public" hint="I configure and return the field." output="false" returntype="reactor.query.field">
		<cfargument name="object" hint="I am the alias of the object the field is in." required="yes" type="string" />
		<cfargument name="field" hint="I am the field name in the object" required="yes" type="string" />
		<cfargument name="alias" hint="I am the alias of the field" required="yes" type="string" />
	
		<cfset setObject(arguments.object) />
		<cfset setField(arguments.field) />
		<cfset setAlias(arguments.alias) />
	
		<cfreturn this />
	</cffunction>
	
	<!--- object --->
    <cffunction name="setObject" access="private" output="false" returntype="void">
       <cfargument name="object" hint="I am the alias of the object the field is in." required="yes" type="string" />
       <cfset variables.object = arguments.object />
    </cffunction>
    <cffunction name="getObject" access="public" output="false" returntype="string">
       <cfreturn variables.object />
    </cffunction>
	
	<!--- field --->
    <cffunction name="setField" access="private" output="false" returntype="void">
       <cfargument name="field" hint="I am the field name in the object" required="yes" type="string" />
       <cfset variables.field = arguments.field />
    </cffunction>
    <cffunction name="getField" access="public" output="false" returntype="string">
       <cfreturn variables.field />
    </cffunction>
	
	<!--- alias --->
    <cffunction name="setAlias" access="private" output="false" returntype="void">
       <cfargument name="alias" hint="I am the alias of the field" required="yes" type="string" />
       <cfset variables.alias = arguments.alias />
    </cffunction>
    <cffunction name="getAlias" access="public" output="false" returntype="string">
       <cfreturn variables.alias />
    </cffunction>
</cfcomponent>