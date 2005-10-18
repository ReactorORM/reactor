<cfcomponent hint="I am a bean used to encapsulate Reactor's configuration.">
	
	<cfset variables.dsn = "" />
	<cfset variables.dbtype = "" />
	<cfset variables.creationPath = "" />
	<cfset variables.mode = "" />
	
	<cffunction name="init" access="public" hint="I configure this config bean." output="false" returntype="reactor.bean.config">
		<cfargument name="dsn" hint="I am the DSN to use to inspect the DB." required="yes" type="string" />
		<cfargument name="dbtype" hint="I am the type of database the dsn is for.  Options are: mssql" required="yes" type="string" />
		<cfargument name="creationPath" hint="I am a mapping to the location where objects are created." required="yes" type="string" />
		<cfargument name="mode" hint="I indicate the mode the system is running in.  Options are development, production, always" required="yes" type="string" />
		
		<cfset setDsn(arguments.dsn) />
		<cfset setDbType(arguments.dbtype) />
		<cfset setCreationPath(arguments.creationPath) />
		<cfset setMode(arguments.mode) />
		
		<cfreturn this />		
	</cffunction>
	
	<!--- dsn --->
    <cffunction name="setDsn" access="public" output="false" returntype="void">
       <cfargument name="dsn" hint="I am the DSN to connect to." required="yes" type="string" />
       <cfset variables.dsn = arguments.dsn />
    </cffunction>
    <cffunction name="getDsn" access="public" output="false" returntype="string">
       <cfreturn variables.dsn />
    </cffunction>
	
	<!--- dbType --->
	<cffunction name="setDbType" access="public" output="false" returntype="void">
		<cfargument name="dbType" hint="I am the type of database the dsn is for" required="yes" type="string" />
		
		<cfif NOT ListFindNoCase("mssql", arguments.dbtype)>
			<cfthrow type="reactor.InvalidDbType"
				message="Invalid dbtype"
				detail="The dbtype argument must be one of: mssql" />
		</cfif>
		
		<cfset variables.dbType = arguments.dbType />
    </cffunction>
    <cffunction name="getDbType" access="public" output="false" returntype="string">
       <cfreturn lcase(variables.dbType) />
    </cffunction>
	
	<!--- creationPath --->
    <cffunction name="setCreationPath" access="public" output="false" returntype="void">
		<cfargument name="creationPath" hint="I am a mapping to the location where objects are created." required="yes" type="string" />
		
		<cfif NOT DirectoryExists(expandPath(arguments.creationPath))>
			<cfthrow type="reactor.InvalidCreationPath"
				message="Invalid creationPath Argument"
				detail="The creationPath argument must be a mapping to a directory which exists." />
		</cfif>
		
		<cfset variables.creationPath = arguments.creationPath />
    </cffunction>
    <cffunction name="getCreationPath" access="public" output="false" returntype="string">
       <cfreturn variables.creationPath />
    </cffunction>
	
	<!--- mode --->
    <cffunction name="setMode" access="public" output="false" returntype="void">
		<cfargument name="mode" hint="I am the mode in which the system is running.  Options are: development, production" required="yes" type="string" />
		
		<cfif NOT ListFindNoCase("development,production,always", arguments.mode)>
			<cfthrow type="reactor.InvalidMode"
				message="Invalid Mode Argument"
				detail="The mode argument must be one of: development, production, always" />
		</cfif>
		
		<cfset variables.mode = arguments.mode />
    </cffunction>
    <cffunction name="getMode" access="public" output="false" returntype="string">
       <cfreturn variables.mode />
    </cffunction>
	
</cfcomponent>


		