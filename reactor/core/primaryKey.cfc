<cfcomponent>
	
	<cfset variables.name = "" />
	<cfset variables.columns = ArrayNew(1) />
	
	<cffunction name="init" access="public" hint="I configure and return the key." output="false" returntype="reactor.core.primaryKey">
		<cfargument name="name" hint="I am the name of the key" required="yes" type="string" />
		
		<cfset setName(arguments.name) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addColumn" access="public" hint="I add a column to this table." output="false" returntype="void">
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
	
	<cffunction name="getColumnNames" access="public" hint="I return a list of column names in this primary key" output="false" returntype="string">
		<cfset var names = "" />
		<cfset var columns = getColumns() />
		<cfset var x = 1 />
		
		<cfloop from="1" to="#ArrayLen(columns)#" index="x">
			<cfset names = ListAppend(names, columns[x].getName()) />
		</cfloop>
		
		<cfreturn names />
	</cffunction>
	
	<!--- columns --->
    <cffunction name="setColumns" access="public" output="false" returntype="void">
       <cfargument name="columns" hint="I am the columns in the key" required="yes" type="array" />
       <cfset variables.columns = arguments.columns />
    </cffunction>
    <cffunction name="getColumns" access="public" output="false" returntype="array">
       <cfreturn variables.columns />
    </cffunction>
	
	<!--- name --->
    <cffunction name="setName" access="public" output="false" returntype="void">
       <cfargument name="name" hint="I am the name of the key" required="yes" type="string" />
       <cfset variables.name = arguments.name />
    </cffunction>
    <cffunction name="getName" access="public" output="false" returntype="string">
       <cfreturn variables.name />
    </cffunction>
	
</cfcomponent>