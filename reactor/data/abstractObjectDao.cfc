<cfcomponent hint="I am an abstract Dao object.  I define the Dao's interface.">
	
	<cfset variables.dsn = "" />
	<cfset variables.username = "" />
	<cfset variables.password = "" />
	
	<cffunction name="init" access="public" hint="I configure and return a DAO" output="false" returntype="any" _returntype="reactor.data.abstractObjectDao">
		<cfargument name="dsn" hint="I am the DSN to use." required="yes" type="any" _type="string" />
		<cfargument name="username" hint="I am the username to use for DSNs." required="yes" type="any" _type="string" />
		<cfargument name="password" hint="I am the password to use for DSNs." required="yes" type="any" _type="string" />
		
		<cfset setDsn(arguments.dsn) />
		<cfset setUsername(arguments.username) />
		<cfset setPassword(arguments.password) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- read --->
	<cffunction name="read" access="public" hint="I define the read method." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to read." required="yes" type="any" _type="reactor.core.object" />
		<cfthrow type="reactor.UnimplementedMethod"
			message="The read method is abstract and must be overridden." />
	</cffunction>
	
	<!--- getObjectName --->
	<cffunction name="getExactObjectName" access="public" hint="I return the case-sensitive object name" output="false" returntype="any" _returntype="string">
		<cfargument name="ObjectName"       hint="I am the object to check on." required="yes" type="any" _type="string" />
    <!--- override as needed to handle case-sensitivity issues --->
		<cfargument name="ObjectTypeList"  hint="I am a comma-delimited list of the type of object to check on." default="table,view" type="any" _type="string" />
  	<cfreturn arguments.ObjectName />
	</cffunction>
	
	<!--- dsn --->
    <cffunction name="setDsn" access="public" output="false" returntype="void">
       <cfargument name="dsn" hint="I am the DSN to use." required="yes" type="any" _type="string" />
       <cfset variables.dsn = arguments.dsn />
    </cffunction>
    <cffunction name="getDsn" access="public" output="false" returntype="any" _returntype="string">
       <cfreturn variables.dsn />
    </cffunction>
	
	<!--- username --->
    <cffunction name="setUsername" access="public" output="false" returntype="void">
       <cfargument name="username" hint="I am the username to use for DSNs." required="yes" type="any" _type="string" />
       <cfset variables.username = arguments.username />
    </cffunction>
    <cffunction name="getUsername" access="public" output="false" returntype="any" _returntype="string">
       <cfreturn variables.username />
    </cffunction>
	
	<!--- password --->
    <cffunction name="setPassword" access="public" output="false" returntype="void">
       <cfargument name="password" hint="I am the password to use for DSNs" required="yes" type="any" _type="string" />
       <cfset variables.password = arguments.password />
    </cffunction>
    <cffunction name="getPassword" access="public" output="false" returntype="any" _returntype="string">
       <cfreturn variables.password />
    </cffunction>
	
</cfcomponent>
