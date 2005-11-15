<cfcomponent hint="I represent metadata about a database object.">

	<cfset variables.config = "" />
	<cfset variables.name = "" />
	<cfset variables.owner = "" />
	<cfset variables.type = "" />
	<cfset variables.database = 0 />
	
	<cfset variables.columns = ArrayNew(1) />
	
	<cffunction name="init" access="public" hint="I configure the object." returntype="reactor.core.object">
		<cfargument name="name" hint="I am a mapping to the location where objects are created." required="yes" type="string" />
		
		<cfset setName(arguments.name) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addColumn" access="public" hint="I add a column to this object." output="false" returntype="void">
		<cfargument name="column" hint="I am the column to add" required="yes" type="reactor.core.column" />
		<cfset var columns = getColumns() />
		<cfset columns[ArrayLen(columns) + 1] = arguments.column />
		<cfset setColumns(columns) />
	</cffunction>

	<cffunction name="getColumn" access="public" hint="I return a specific column." output="false" returntype="reactor.core.column">
		<cfargument name="name" hint="I am the name of the column to return" required="yes" type="string" />
		<cfset var columns = getColumns() />
		<cfset var x = 1 />
		
		<cfloop from="1" to="#ArrayLen(columns)#" index="x">
			<cfif columns[x].getName() IS arguments.name>
				<cfreturn columns[x] />
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
	
	<!--- columns --->
    <cffunction name="setColumns" access="public" output="false" returntype="void">
       <cfargument name="columns" hint="I am this object's columns" required="yes" type="array" />
       <cfset variables.columns = arguments.columns />
    </cffunction>
    <cffunction name="getColumns" access="public" output="false" returntype="array">
       <cfreturn variables.columns />
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