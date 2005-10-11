<cfcomponent>
	
	<cfset variables.fromColumnName = "" />
	<cfset variables.toColumnName = "" />
	
	<cffunction name="init" access="public" hint="I configure a relationship and return it." output="false" returntype="reactor.core.relationship">
		<cfargument name="fromColumnName" hint="I am the columnName that refers to another tableName's columnName." required="yes" type="string" />
		<cfargument name="toColumnName" hint="I am the columnName that is being referred to by the from columnName." required="yes" type="string" />
		
		<cfset setFromColumnName(arguments.fromColumnName) />
		<cfset setToColumnName(arguments.toColumnName) />
		
		<cfreturn this />
	</cffunction>

	<!--- fromColumnName --->
    <cffunction name="setFromColumnName" access="public" output="false" returntype="void">
       <cfargument name="fromColumnName" hint="I am the columnName that refers to another tableName's columnName." required="yes" type="string" />
       <cfset variables.fromColumnName = arguments.fromColumnName />
    </cffunction>
    <cffunction name="getFromColumnName" access="public" output="false" returntype="string">
       <cfreturn variables.fromColumnName />
    </cffunction>

	<!--- toColumnName --->
    <cffunction name="setToColumnName" access="public" output="false" returntype="void">
       <cfargument name="toColumnName" hint="I am the columnName that is being referred to by the from columnName." required="yes" type="string" />
       <cfset variables.toColumnName = arguments.toColumnName />
    </cffunction>
    <cffunction name="getToColumnName" access="public" output="false" returntype="string">
       <cfreturn variables.toColumnName />
    </cffunction>
</cfcomponent>