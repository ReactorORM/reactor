<cfcomponent hint="I represent metadata about a database object.">

	<cfset variables.config = "" />
	<cfset variables.name = "" />
	<cfset variables.owner = "" />
	<cfset variables.type = "" />
	<cfset variables.database = 0 />
	
	<cfset variables.fields = ArrayNew(1) />
	
	<cffunction name="init" access="public" hint="I configure the object." returntype="reactor.core.object">
		<cfargument name="name" hint="I am a mapping to the location where objects are created." required="yes" type="string" />
		
		<cfset setName(arguments.name) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addField" access="public" hint="I add a field to this object." output="false" returntype="void">
		<cfargument name="field" hint="I am the field to add" required="yes" type="reactor.core.field" />
		<cfset var fields = getFields() />
		<cfset fields[ArrayLen(fields) + 1] = arguments.field />
		<cfset setFields(fields) />
	</cffunction>

	<cffunction name="getField" access="public" hint="I return a specific field." output="false" returntype="reactor.core.field">
		<cfargument name="name" hint="I am the name of the field to return" required="yes" type="string" />
		<cfset var fields = getFields() />
		<cfset var x = 1 />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfif fields[x].getName() IS arguments.name>
				<cfreturn fields[x] />
			</cfif>
		</cfloop>
	</cffunction>
	
	<!--- name --->
    <cffunction name="setName" access="public" output="false" returntype="void">
       <cfargument name="name" hint="I am the name of the object" required="yes" type="string" />
       <cfset variables.name = arguments.name />
    </cffunction>
    <cffunction name="getName" access="public" output="false" returntype="string">
       <cfreturn variables.name />
    </cffunction>
	
	<!--- owner --->
    <cffunction name="setOwner" access="public" output="false" returntype="void">
       <cfargument name="owner" hint="I am the object owner." required="yes" type="string" />
       <cfset variables.owner = arguments.owner />
    </cffunction>
    <cffunction name="getOwner" access="public" output="false" returntype="string">
       <cfreturn variables.owner />
    </cffunction>
	
	<!--- type --->
    <cffunction name="setType" access="public" output="false" returntype="void">
		<cfargument name="type" hint="I am the object type (options are view or table)" required="yes" type="string" />
		<cfset arguments.type = lcase(arguments.type) />
		
		<cfif NOT ListFind("table,view", arguments.type)>
			<cfthrow type="reactor..object.InvalidObjectType"
				message="Invalid Object Type"
				detail="The Type argument must be one of: table, view" />
		</cfif>
		
		<cfset variables.type = arguments.type />
    </cffunction>
    <cffunction name="getType" access="public" output="false" returntype="string">
       <cfreturn variables.type />
    </cffunction>
	
	<!--- fields --->
    <cffunction name="setFields" access="public" output="false" returntype="void">
       <cfargument name="fields" hint="I am this object's fields" required="yes" type="array" />
       <cfset variables.fields = arguments.fields />
    </cffunction>
    <cffunction name="getFields" access="public" output="false" returntype="array">
       <cfreturn variables.fields />
    </cffunction>
	
	<!--- database --->
    <cffunction name="setDatabase" access="public" output="false" returntype="void">
       <cfargument name="database" hint="I am the database this table is in." required="yes" type="string" />
       <cfset variables.database = arguments.database />
    </cffunction>
    <cffunction name="getDatabase" access="public" output="false" returntype="string">
       <cfreturn variables.database />
    </cffunction>
</cfcomponent>