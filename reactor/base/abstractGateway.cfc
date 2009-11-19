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
		<cfset var PaginationString = "">
		<cfset var endRecord = 0>		
		<cfset var startRecord = 0>
		<cfset var qPaginated = "">
		<cfset var col = "">
		<cfset queryData.query = "" />
		<cfset queryData.params = arguments.Query.getValues() />
			
		
		<!--- If the driver convention supports pagination --->
		<cfif _getConvention().supportsPagination() AND Query.getPagination("page") GT 0>
			<cfset PaginationString = _getConvention().formatPaginationSetting(Query.getPagination("page"),Query.getPagination("rows"))>
		</cfif>
			
		<!--- run the query --->
		<cfquery name="qGet" datasource="#_getConfig().getDsn()#" maxrows="#arguments.query.getMaxRows()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
			<cfsavecontent variable="queryData.query">
				<!--- include the actual rendered query --->
				<cfinclude template="#pathToQuery#" />
			</cfsavecontent>
			<cfoutput>#replaceNoCase(queryData.query, "''", "'", "all")#</cfoutput>
			<cfoutput>#PaginationString#</cfoutput>
			
		</cfquery>
		
		<!--- IF we dont support it, lets fake it --->
		<cfif NOT _getConvention().supportsPagination() AND Query.getPagination("page") GT 0>
			<cfset rows = Query.getPagination("rows")>
			<cfset page = Query.getPagination("page")>
			
			<cfset endRecord = rows * page>		
			<cfset startRecord = (endRecord - rows) + 1>
			
			<!--- ReCreate The Query --->
			<cfset qPaginated = QueryNew(qGet.columnlist)>
			
			<cfoutput query="qGet" startrow="#startRecord#"  maxrows="#rows#">
				<cfset QueryAddRow(qPaginated)>
				<cfloop list="#qGet.columnlist#" index="col">
					<cfset QuerySetCell(qPaginated,col,qGet[col])>
				</cfloop>
			</cfoutput>
			<cfset qGet = qPaginated>	
		</cfif>
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
	
<!--- getbyFilter --->	

	<cffunction name="getByFilter" access="public" output="false" returntype="any" hint="I am a utility method to filter the results of a query"> 
		<cfargument name="include" type="struct" default="#StructNew()#" hint="Field/Value pairs that should be included in the query">
		<cfargument name="exclude" type="struct" default="#StructNew()#" hint="Field/Value pairs that should be excluded in the query">
		<cfargument name="contains" type="struct" default="#StructNew()#" hint="Field/Value pairs that should be contained  in the query">
		<cfargument name="orderby" type="struct" default="#StructNew()#" hint="Field/Direction to order by, acceptable values are ASC and DESC">
		<cfargument name="isIn" type="struct" default="#StructNew()#" hint="Field/List pairs that should be included in the query">
		<cfargument name="notIn" type="struct" default="#StructNew()#" hint="Field/List pairs that should be excluded in the query">
		<cfargument name="maxrows" type="numeric" default="0" required="false" hint="The maximum number of rows to return in the query">
		<cfargument name="format" type="string" default="query" required="false" hint="The format that you want to return the query in, valid values are query and iterator">
		<cfargument name="page" type="numeric" default="0" required="false" hint="The page to get in a paginated set of results">
		<cfargument name="rows" type="numeric" default="0" required="false" hint="The number of rows to for each page to return, required if page GT 0">
		<cfscript>
			var QueryObj = this.createQuery();
			var Where = QueryObj.getWhere();
			var Order = QueryObj.getOrder();
			var inc = "";
			var ex = "";
			var cont = "";
			var r_Object = "";
			var TableName = getObjectMetadata().getAlias();
			var totalRowCount = 0;
		</cfscript>
		
		
		<!--- Check the pagination --->
		
		<cfif page GT 0 AND rows EQ 0>
			<cfthrow message="Rows (per page) need to be defined if you are requesting a page"
				type="reactor.core.gateway.filter.Arguments">
		</cfif>
		
		
		<!--- Do the includes --->
		<cfloop collection="#include#" item="inc">
				<cfset Where.isEqual(TableName,inc, include[inc])>
		</cfloop>
		
		<!--- Do the excludes --->
		<cfloop collection="#exclude#" item="ex">
				<cfset Where.isNotEqual(TableName,ex, exclude[ex])>
		</cfloop>
		
		<!--- Do the contains --->	
		<cfloop collection="#arguments.contains#" item="cont">
				<cfset Where.isLikeNoCase(TableName,cont, arguments.contains[cont])>
		</cfloop>
		
		<!--- include / exclude lists of values --->
		<cfloop collection="#arguments.isIn#" item="inc">
			<cfset Where.isIn(TableName, inc, arguments.isIn[inc])>
		</cfloop>
		<cfloop collection="#arguments.notIn#" item="ex">
			<cfset Where.isNotIn(TableName, ex, arguments.notIn[ex])>
		</cfloop>
			
		<!--- Do the ordering --->
		
		<cfloop collection="#orderby#" item="ord">
			<cfif orderby[ord] EQ "ASC">
				<cfset Order.setAsc(TableName, ord, "ASC")>
			<cfelseif orderby[ord] EQ "DESC">
				<cfset Order.setDesc(TableName, ord)>
			</cfif>
		</cfloop>
		
		<!--- Set the pagination --->
		<cfif page GT 0 AND rows GT 0>
			<cfset QueryObj.setPagination(page,rows)>
		</cfif>
		
		<!--- Do the maxrows --->
		<cfif maxrows GT 0>
			<cfset QueryObj.setMaxRows(maxrows)>
		</cfif>
		
		<cfif format EQ "iterator">
			<cfset r_Object = CreateObject("component", "reactor.iterator.BasicIterator").init(
							getByQuery(QueryObj),
							_getReactorFactory().createRecord(this.getObjectMetadata().getAlias())
							)>
			<cfreturn r_Object>
		</cfif>
		
		<cfreturn getByQuery(QueryObj)>
	</cffunction>
	
<!--- getRowCountByFilter --->	
	<cffunction name="getTotalRowCountByFilter" access="public" output="false" returntype="numeric" hint="I am a utility method to get the total row count for a filter ignoring any of the pagination settings">
		<cfargument name="include" type="struct" default="#StructNew()#" hint="Field/Value pairs that should be included in the query">
		<cfargument name="exclude" type="struct" default="#StructNew()#" hint="Field/Value pairs that should be excluded in the query">
		<cfargument name="contains" type="struct" default="#StructNew()#" hint="Field/Value pairs that should be contained  in the query">
		<cfargument name="orderby" type="struct" default="#StructNew()#" hint="Field/Direction to order by, acceptable values are ASC and DESC">
		<cfargument name="maxrows" type="numeric" default="0" required="false" hint="The maximum number of rows to return in the query">
		<cfargument name="idcol" type="string" default="" required="false" hint="The id column of this table if it isnt defined in the MetaData">
	
		<cfscript>
			var QueryObj = this.createQuery();
			var Where = QueryObj.getWhere();
			var Order = QueryObj.getOrder();
			var inc = "";
			var ex = "";
			var cont = "";
			var col = "";
			var r_Object = "";
			var TableName = this.getObjectMetadata().getName();
			var totalRowCount = 0;
			var totalRows = 0;
			var TableFields = this.getObjectMetaData().getObjectMetaData();
			var aTableFields = TableFields.Fields;

		</cfscript>
		
		
		<!--- Find the primary key, if we dont find it we need an idCol --->
		<cfloop array="#aTableFields#" index="col">
			<cfif col.identity>
				<cfset arguments.idcol = col.name>
			</cfif>
		</cfloop>
		
		
		<cfif NOT Len(arguments.idcol)>
			<cfthrow message="Please define which column is the primary key which will be used for the count">
		</cfif>

		<cfset QueryObj.returnObjectField(TableName,arguments.idcol)>	
		<cfset QueryObj.setFieldExpression(TableName,arguments.idCol, "COUNT(#arguments.idcol#)", "cf_sql_integer")>		
						
	<!--- Do the includes --->
		<cfloop collection="#include#" item="inc">
				<cfset Where.isEqual(TableName,inc, include[inc])>
		</cfloop>
		
		<!--- Do the excludes --->
		<cfloop collection="#exclude#" item="ex">
				<cfset Where.isNotEqual(TableName,ex, exclude[ex])>
		</cfloop>
		
		<!--- Do the contains --->	
		<cfloop collection="#arguments.contains#" item="cont">
				<cfset Where.isLike(TableName,cont, arguments.contains[cont])>
		</cfloop>
		<cfset totalRows = getByQuery(QueryObj)>
		<cfreturn totalRows[arguments.idCol]>
	</cffunction>

</cfcomponent>