<cfcomponent hint="I am an abstract Dao object.  I define the Dao's interface.">
	
	<cfset variables.dsn = "" />
	
	<cffunction name="init" access="public" hint="I configure and return a DAO" output="false" returntype="reactor.data.abstractObjectDao">
		<cfargument name="dsn" hint="I am the DSN to use." required="yes" type="string" />
		
		<cfset setDsn(arguments.dsn) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- read --->
	<cffunction name="read" access="public" hint="I define the read method." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to read." required="yes" type="reactor.core.object" />
		<cfthrow type="reactor.UnimplementedMethod"
			message="The read method is abstract and must be overridden." />
	</cffunction>
	
	<!--- dsn --->
    <cffunction name="setDsn" access="public" output="false" returntype="void">
       <cfargument name="dsn" hint="I am the DSN to use." required="yes" type="string" />
       <cfset variables.dsn = arguments.dsn />
    </cffunction>
    <cffunction name="getDsn" access="public" output="false" returntype="string">
       <cfreturn variables.dsn />
    </cffunction>
	
</cfcomponent>