<cfcomponent hint="I am used primarly to allow type definitions for return values.  I also loosely define an interface for gateway objects and some core methods.">

	<cfinclude template="base.cfm" />
	
	<!--- a gateway keeps a pool of query objects 
	<cfset variables.queryPool = 0 />
	<cfset variables.queryObjectPool = 0 />--->
	
	<cfset variables.lastExecutedQuery = StructNew() />
	
	<!--- configure --->
	<cffunction name="_configure" access="public" hint="I configure and return this object." output="false" returntype="any" _returntype="reactor.base.abstractGateway">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="any" _type="reactor.config.config" />
		<cfargument name="alias" hint="I am the alias of this object." required="yes" type="any" _type="string" />
		<cfargument name="ReactorFactory" hint="I am the reactorFactory object." required="yes" type="any" _type="reactor.reactorFactory" />
		<cfargument name="Convention" hint="I am a database Convention object." required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfargument name="ObjectMetadata" hint="I am a database Convention object." required="yes" type="any" _type="reactor.base.abstractMetadata" />
		
		<cfset _setConfig(arguments.config) />
		<cfset _setAlias(arguments.alias) />
		<cfset _setReactorFactory(arguments.ReactorFactory) />
		<cfset _setConvention(arguments.Convention) />
		<cfset setObjectMetadata(arguments.ObjectMetadata) />>
    	<cfset setMaxIntegerLength() />
		
		<cfreturn this />
	</cffunction>
	
	<!--- objectMetadata --->
    <cffunction name="setObjectMetadata" access="private" output="false" returntype="void">
       <cfargument name="objectMetadata" hint="I set the object metadata." required="yes" type="any" _type="reactor.base.abstractMetadata" />
       <cfset variables.objectMetadata = arguments.objectMetadata />
    </cffunction>
    <cffunction name="getObjectMetadata" access="private" output="false" returntype="any" _returntype="reactor.base.abstractMetadata">
       <cfreturn variables.objectMetadata />
    </cffunction>	

	<!--- createQuery --->
	<cffunction name="createQuery" access="public" hint="I return a query object which can be used to compose and execute complex queries on this gateway." output="false" returntype="any" _returntype="reactor.query.query">
		<cfset var query = createObject("component","reactor.query.query").init(_getAlias(), _getAlias(), _getReactorFactory()) />
		
		<cfreturn query />
	</cffunction>
	
	<!--- deleteAll --->
	<cffunction name="deleteAll" access="public" hint="I delete all rows from the object." output="false" returntype="void">
		<cfset var Query = createQuery() />
		
		<cfset deleteByQuery(Query) />
	</cffunction>
	
	<!--- deleteByQuery --->
	<cffunction name="deleteByQuery" access="public" hint="I delete all matching rows from the object based on the provided query object.  Note, the select list is ignored and the query can not have any joins." output="false" returntype="void">
		<cfargument name="Query" hint="I the query to run.  Create me using the createQuery method on this object." required="yes" type="any" _type="reactor.query.query" />
		<cfset var pathToQuery = Query.getQueryFile(_getConfig(), _getConvention(), "delete") />
		<cfset var qGet = 0 />
		<cfset var queryData = StructNew() />
		<cfset queryData.query = "" />
		<cfset queryData.params = arguments.Query.getValues() />
				
		<!--- run the query --->
		<cfquery name="qGet" datasource="#_getConfig().getDsn()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
			<cfsavecontent variable="queryData.query">
				<!--- include the actual rendered query --->
				<cfinclude template="#pathToQuery#" />
			</cfsavecontent>
			<cfoutput>#replaceNoCase(queryData.query, "''", "'", "all")#</cfoutput>
		</cfquery>
		
		<!--- store some data about the query --->
		<cfset queryData.query = replaceNoCase(queryData.query, "''", "'", "all") />
		<cfset setLastExecutedQuery(queryData) />
		
		<cfreturn  />
	</cffunction>
	
	<!--- getByQuery --->
	<cffunction name="getByQuery" access="public" hint="I return all matching rows from the object." output="false" returntype="any" _returntype="query">
		<cfargument name="Query" hint="I the query to run.  Create me using the createQuery method on this object." required="yes" type="any" _type="reactor.query.query" />
		<cfset var pathToQuery = Query.getQueryFile(_getConfig(), _getConvention(), "select") />
		<cfset var qGet = 0 />
		<cfset var queryData = StructNew() />
		<cfset queryData.query = "" />
		<cfset queryData.params = arguments.Query.getValues() />
				
		<!--- run the query --->
		<cfquery name="qGet" datasource="#_getConfig().getDsn()#" maxrows="#arguments.query.getMaxRows()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
			<cfsavecontent variable="queryData.query">
				<!--- include the actual rendered query --->
				<cfinclude template="#pathToQuery#" />
			</cfsavecontent>
			<cfoutput>#replaceNoCase(queryData.query, "''", "'", "all")#</cfoutput>
		</cfquery>
		
		<!--- store some data about the query --->
		<cfset queryData.query = replaceNoCase(queryData.query, "''", "'", "all") />
		<cfset setLastExecutedQuery(queryData) />
		
		<cfreturn qGet />
	</cffunction>
	
	<!--- lastExecutedQuery --->
    <cffunction name="setLastExecutedQuery" access="private" output="false" returntype="void">
		<cfargument name="lastExecutedQuery" hint="I am the last query executed by this gateway" required="yes" type="any" _type="struct" />
		<cflock type="exclusive" timeout="5" throwontimeout="yes">
			<cfset variables.lastExecutedQuery = arguments.lastExecutedQuery />
		</cflock>
    </cffunction>
    <cffunction name="getLastExecutedQuery" access="public" output="false" returntype="any" _returntype="struct">
       <cfset var lastExecutedQuery = 0 />
	   <cflock type="exclusive" timeout="5" throwontimeout="yes">
			<cfset lastExecutedQuery = variables.lastExecutedQuery />
		</cflock>
	   <cfreturn lastExecutedQuery />
    </cffunction>

 <!---  maxIntegerLength --->
    <cffunction name="setMaxIntegerLength" access="private" output="false" returntype="void">
      <cfset variables.maxIntegerLength =  createObject('java', 'java.lang.Integer').MAX_VALUE />    
    </cffunction>
    <cffunction name="getMaxIntegerLength" access="private" output="false" returntype="any" _returntype="numeric">
	     <cfreturn variables.maxIntegerLength />
    </cffunction>
</cfcomponent>