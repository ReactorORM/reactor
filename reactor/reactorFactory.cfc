<cfcomponent>
	<cfset variables.ObjectFactory = 0 />
	
	<cffunction name="init" access="public" hint="I configure this object factory" returntype="reactorFactory">
		<cfargument name="dsn" hint="I am the DSN to connect to." required="yes" type="string" />
		<cfargument name="dbtype" hint="I am the type of database the dsn is for.  Options are: mssql" required="yes" type="string" />
		<cfargument name="generationPath" hint="I am a mapping to the location where objects are generated." required="yes" type="string" />
		<cfargument name="mode" hint="I indicate the mode the system is running in.  Options are development, production, always" required="yes" type="string" />
		
		<cfif NOT ListFindNoCase("mssql", arguments.dbtype)>
			<cfthrow type="reactor.InvalidDbType"
				message="Invalid dbtype"
				detail="The dbtype argument must be one of: mssql" />
		</cfif>
		
		<cfif NOT ListFindNoCase("development,production,always", arguments.mode)>
			<cfthrow type="reactor.InvalidMode"
				message="Invalid Mode Argument"
				detail="The mode argument must be one of: development, production, always" />
		</cfif>
		
		<cfset setObjectFactory(CreateObject("Component", "reactor.core.#arguments.dbtype#.ObjectFactory").init(arguments.dsn, arguments.dbtype, arguments.generationPath, arguments.mode)) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createRecord" access="public" hint="I return a record object." output="false" returntype="reactor.core.abstractRecord">
		<cfargument name="name" hint="I am the name of the record to return.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().createRecord(arguments.name) />
	</cffunction>
	
	<cffunction name="createDao" access="public" hint="I return a Dao object." output="false" returntype="reactor.core.abstractTo">
		<cfargument name="name" hint="I am the name of the Dao to return.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().createDao(arguments.name) />
	</cffunction>
	
	<cffunction name="createTo" access="public" hint="I return a To object." output="false" returntype="reactor.core.abstractTo">
		<cfargument name="name" hint="I am the name of the TO to return.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().createTo(arguments.name) />
	</cffunction>
	
	<cffunction name="createGateway" access="public" hint="I return a gateway object." output="false" returntype="reactor.core.abstractGateway">
		<cfargument name="name" hint="I am the name of the record to return.  I corrispond to the name of a object in the DB." required="yes" type="string" />
		<cfreturn getObjectFactory().createGateway(arguments.name) />
	</cffunction>
	
	<!--- ObjectFactory --->
    <cffunction name="setObjectFactory" access="private" output="false" returntype="void">
       <cfargument name="ObjectFactory" hint="I am the table factory used to get table metadata" required="yes" type="reactor.core.abstractObjectFactory" />
       <cfset variables.ObjectFactory = arguments.ObjectFactory />
    </cffunction>
    <cffunction name="getObjectFactory" access="private" output="false" returntype="reactor.core.abstractObjectFactory">
       <cfreturn variables.ObjectFactory />
    </cffunction>
	
	<!---
	<cffunction name="getObjectName" access="private" hint="I return the correct name of the a object based on it's type and other configurations" output="false" returntype="string">
		<cfargument name="type" hint="I am the type of object to return.  Options are: record, gateway" required="yes" type="string" />
		<cfargument name="name" hint="I am the name of the object to return." required="yes" type="string" />
		<cfset var generationPath = replaceNoCase(right(getGenerationPath(), Len(getGenerationPath()) - 1), "/", ".") />
		
		<cfif NOT ListFindNoCase("record,gateway", arguments.type)>
			<cfthrow type="reactor.InvalidObjectType"
				message="Invalid Object Type"
				detail="The type argument must be one of: record, gateway" />
		</cfif>
		
		<cfreturn generationPath & "." & arguments.type & "." & getDbType() & "." & arguments.name & arguments.type  />
	</cffunction>
	--->
	
	<!--- dsn
    <cffunction name="setDsn" access="private" output="false" returntype="void">
       <cfargument name="dsn" hint="I am the DSN to connect to." required="yes" type="string" />
       <cfset variables.dsn = arguments.dsn />
    </cffunction>
    <cffunction name="getDsn" access="private" output="false" returntype="string">
       <cfreturn variables.dsn />
    </cffunction> --->
	
	<!--- dbType
    <cffunction name="setDbType" access="private" output="false" returntype="void">
       <cfargument name="dbType" hint="I am the type of database the dsn is for" required="yes" type="string" />
       <cfset variables.dbType = arguments.dbType />
    </cffunction>
    <cffunction name="getDbType" access="private" output="false" returntype="string">
       <cfreturn variables.dbType />
    </cffunction> --->
	
	<!--- generationPath
    <cffunction name="setGenerationPath" access="private" output="false" returntype="void">
       <cfargument name="generationPath" hint="I am a mapping to the location where objects are generated." required="yes" type="string" />
       <cfset variables.generationPath = arguments.generationPath />
    </cffunction>
    <cffunction name="getGenerationPath" access="private" output="false" returntype="string">
       <cfreturn variables.generationPath />
    </cffunction> --->
</cfcomponent>