<cfcomponent hint="I am used primarly to allow type definitions for return values.  I also loosely define an interface for Dao objects and some core methods.">
	
	<cfset variables.dsn = "" />
	
	<cffunction name="init" access="public" hint="I configure and return the DAO object." output="false" returntype="reactor.core.abstractDao">
		<cfargument name="dsn" hint="I am the datasource to use." required="yes" type="string" />
		
		<cfset setDsn(arguments.dsn) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="create" access="public" hint="I create a row in the database." output="false" returntype="void">
	</cffunction>
	
	<cffunction name="read" access="public" hint="I read a row from the database." output="false" returntype="void">
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a row in the database." output="false" returntype="void">
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a row in the database." output="false" returntype="void">
	</cffunction>
	
	<cffunction name="getSignature" access="public" hint="I return this object's corrisponding DB signature." output="false" returntype="string">
		<cfreturn variables.signature />
	</cffunction>
	
	<!--- dsn --->
    <cffunction name="setDsn" access="private" output="false" returntype="void">
       <cfargument name="dsn" hint="I am the DSN to use for database connectivity." required="yes" type="string" />
       <cfset variables.dsn = arguments.dsn />
    </cffunction>
    <cffunction name="getDsn" access="private" output="false" returntype="string">
       <cfreturn variables.dsn />
    </cffunction>
	
</cfcomponent>