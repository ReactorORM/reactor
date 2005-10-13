<cfcomponent hint="I am the core setup object for all tests." extends="org.cfcunit.framework.TestCase">

	<cfset variables.reactor = 0 />
	<cfset variables.config = 0 />
	
	<cffunction name="setUp" returntype="void" access="private">
		<cfargument name="type" required="yes" type="string" />
		
		<cftry>
			<!--- delete the data directory if it exists --->
			<cfif DirectoryExists(expandPath("/reactorUnitTests/data"))>
				<cfdirectory action="delete" recurse="yes" directory="#expandPath("/reactorUnitTests/data")#" />
			</cfif>
			
			<!--- create the data directory --->
			<cfif NOT DirectoryExists(expandPath("/reactorUnitTests/data"))>
				<cfdirectory action="create" directory="#expandPath("/reactorUnitTests/data")#" />
			</cfif>
			<cfcatch></cfcatch>
		</cftry>
		
		<!--- create and configure reactor --->
		<cfset setConfig(CreateObject("Component", "reactor.bean.config").init("scratch", arguments.type, "/reactorUnitTests/data", "always")) />
		<cfset setReactor(CreateObject("Component", "reactor.reactorFactory").init(getConfig())) />
		
		<!--- create the test tables --->
		<cftransaction>
			<cfquery datasource="#getConfig().getDsn()#">
				<cfinclude template="/reactorUnitTests/scripts/dropDatabaseObjects.#getConfig().getDbType()#.sql" />
				<cfinclude template="/reactorUnitTests/scripts/createDatabaseObjects.#getConfig().getDbType()#.sql" />
			</cfquery>
		</cftransaction>
	</cffunction>
	
	<cffunction name="tearDown" returntype="void" access="private">
		<cftry>
			<!--- delete the data directory if it exists --->
			<cfif DirectoryExists(expandPath("/reactorUnitTests/data"))>
				<cfdirectory action="delete" recurse="yes" directory="#expandPath("/reactorUnitTests/data")#" />
			</cfif>
			<cfcatch></cfcatch>
		</cftry>
		
		<!--- drop the test database --->
		<cfquery datasource="#getConfig().getDsn()#">
			<cfinclude template="/reactorUnitTests/scripts/dropDatabaseObjects.#getConfig().getDbType()#.sql" />
		</cfquery>		
	</cffunction>
	
	<!--- assertIsOfType --->
	<cffunction name="assertIsOfType" access="public" output="false" returntype="void">
		<cfargument name="object" required="yes" type="any" />
		<cfargument name="typeName" required="yes" type="string" />
		<cfset var metadata = getMetaData(arguments.object) />
		
		<cfloop condition="IsDefined('metadata.extends')">
			<cfif metadata.name IS arguments.typeName>
				<cfreturn />
			</cfif>
			
			<cfset metadata = metadata.extends />
		</cfloop>
		
		<cfset fail("Object is not of type '#arguments.typeName#'") />
	</cffunction>
	
	<!--- reactor --->
    <cffunction name="setReactor" access="public" output="false" returntype="void">
       <cfargument name="reactor" hint="" required="yes" type="reactor.reactorFactory" />
       <cfset variables.instance.reactor = arguments.reactor />
    </cffunction>
    <cffunction name="getReactor" access="public" output="false" returntype="reactor.reactorFactory">
       <cfreturn variables.instance.reactor />
    </cffunction>
	
	<!--- config --->
    <cffunction name="setConfig" access="public" output="false" returntype="void">
       <cfargument name="config" hint="" required="yes" type="reactor.bean.config" />
       <cfset variables.instance.config = arguments.config />
    </cffunction>
    <cffunction name="getConfig" access="public" output="false" returntype="reactor.bean.config">
       <cfreturn variables.instance.config />
    </cffunction>

</cfcomponent>