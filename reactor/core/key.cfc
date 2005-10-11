<cfcomponent>
	
	<cfset variables.name = "" />
	<cfset variables.fromTableName = "" />
	<cfset variables.toTableName = "" />
	<cfset variables.relationships = ArrayNew(1) />
	
	<cffunction name="init" access="public" hint="I configure and return the key." output="false" returntype="reactor.core.key">
		<cfargument name="name" hint="I am the name of the key" required="yes" type="string" />
		<cfargument name="fromTableName" hint="I am the name of the table with the foreign key." required="yes" type="string" />
		<cfargument name="toTableName" hint="I am the name of the table being referred to key." required="yes" type="string" />
		
		<cfset setName(arguments.name) />
		<cfset setFromTableName(arguments.fromTableName) />
		<cfset setToTableName(arguments.toTableName) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addRelationship" access="public" hint="I add a relationship to this key." output="false" returntype="void">
		<cfargument name="relationship" hint="I am the relationship to add" required="yes" type="reactor.core.relationship" />
		<cfset var relationships = getRelationships() />
		<cfset relationships[ArrayLen(relationships) + 1] = arguments.relationship />
		<cfset setRelationships(relationships) />
	</cffunction>
	
	<cffunction name="getFromColumnNames" access="public" hint="I return a list of all from-column names" output="false" returntype="string">
		<cfset var names = "" />
		<cfset var relationships = getRelationships() />
		<cfset var x = 1 />
		
		<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
			<cfset names = ListAppend(names, relationships[x].getFromColumnName()) />
		</cfloop>
		
		<cfreturn names />
	</cffunction>
	
	<!--- relationships --->
    <cffunction name="setRelationships" access="public" output="false" returntype="void">
       <cfargument name="relationships" hint="I am the relationships in the key" required="yes" type="array" />
       <cfset variables.relationships = arguments.relationships />
    </cffunction>
    <cffunction name="getRelationships" access="public" output="false" returntype="array">
       <cfreturn variables.relationships />
    </cffunction>
	
	<!--- name --->
    <cffunction name="setName" access="public" output="false" returntype="void">
       <cfargument name="name" hint="I am the name of the key" required="yes" type="string" />
       <cfset variables.name = arguments.name />
    </cffunction>
    <cffunction name="getName" access="public" output="false" returntype="string">
       <cfreturn variables.name />
    </cffunction>
		
	<!--- fromTableName --->
    <cffunction name="setFromTableName" access="public" output="false" returntype="void">
       <cfargument name="fromTableName" hint="I am the tableName that refers to another tableName." required="yes" type="string" />
       <cfset variables.fromTableName = arguments.fromTableName />
    </cffunction>
    <cffunction name="getFromTableName" access="public" output="false" returntype="string">
       <cfreturn variables.fromTableName />
    </cffunction>
		
	<!--- toTableName --->
    <cffunction name="setToTableName" access="public" output="false" returntype="void">
       <cfargument name="toTableName" hint="I am the tableName that is being referred to by the from tableName." required="yes" type="string" />
       <cfset variables.toTableName = arguments.toTableName />
    </cffunction>
    <cffunction name="getToTableName" access="public" output="false" returntype="string">
       <cfreturn variables.toTableName />
    </cffunction>
</cfcomponent>