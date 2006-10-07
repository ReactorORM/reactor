<cfcomponent hint="I am used primarly to allow type definitions for return values.  I also loosely define an interface for gateway objects and some core methods." extends="reactor.base.abstractObject">

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
		
		<cfset super._configure(arguments.Config, arguments.alias, arguments.ReactorFactory, arguments.Convention) />
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
		<cfset var qDelete = 0 />
		<cfset var Convention = _getConvention() />
		<cfset var where = arguments.Query.getWhere().getWhere() />
		<cfset var order = arguments.Query.getOrder().getOrder() />
		<cfset var whereNode = 0 />
		<cfset var x = 0 />
		<cfset var queryData = StructNew() />
		<cfset queryData.query = "" />
		<cfset queryData.params = ArrayNew(1) />
		
		<!--- check if the object has any joins --->
		<cfif arguments.Query.hasJoins()>
			<cfthrow message="Can Not Delete By Query With Joins"
				detail="You can not use a query that has joins when calling delete by query."
				type="reactor.abstractGateway.CanNotDeleteByQueryWithJoins" />
		</cfif>
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#" maxrows="#arguments.Query.getMaxRows()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
			<cfsavecontent variable="queryData.query">
				DELETE FROM 
										
				#arguments.Query.getDeleteAsString(Convention)#
				
				<cfif ArrayLen(where)>
					WHERE
							
					<!--- loop over all of the expressions and render them out --->
					<cfloop from="1" to="#ArrayLen(where)#" index="x">
						<!--- get the arguments for this expression --->
						<cfset whereNode = where[x] />
						
						<!--- if the node is a structure output it accordingly.  otherwise, just output it. --->	
						<cfif IsStruct(whereNode)>
							<!--- render the expression --->
<!--- 							<cfswitch expression="#whereNode.comparison#"> --->
								<!--- isBetween --->
								<cfif compareNocase(whereNode.comparison,"isBetween") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)#
										<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
											BETWEEN <cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#whereNode.value1#" />
											<cfset ArrayAppend(queryData.params, whereNode.value1) />
											AND <cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#whereNode.value2#" />
											<cfset ArrayAppend(queryData.params, whereNode.value2) />
										<cfelse>
											BETWEEN <cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#whereNode.value1#" />
											<cfset ArrayAppend(queryData.params, whereNode.value1) />
											AND <cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#whereNode.value2#" />
											<cfset ArrayAppend(queryData.params, whereNode.value2) />
										</cfif>
								
								<!--- isBetweenFields --->
								<cfelseif compareNocase(whereNode.comparison,"isBetweenFields") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)#
										BETWEEN #getFieldOrExpressionForDelete(whereNode, Convention, 1)#
										AND #getFieldOrExpressionForDelete(whereNode, Convention, 2)#
								
								<!--- isEqual --->
								<cfelseif compareNocase(whereNode.comparison,"isEqual") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# = 
										<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										<cfelse>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										</cfif>
								
								<!--- isEqualField --->
								<cfelseif compareNocase(whereNode.comparison,"isEqualField") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# = #getFieldOrExpressionForDelete(whereNode, Convention, 1)#
								
								<!--- isNotEqual --->
								<cfelseif compareNocase(whereNode.comparison,"isNotEqual") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# != 
										<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										<cfelse>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										</cfif>
								
								<!--- isNotEqualField --->
								<cfelseif compareNocase(whereNode.comparison,"isNotEqualField") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# != #getFieldOrExpressionForDelete(whereNode, Convention, 1)#
								
								<!--- isGte --->
								<cfelseif compareNocase(whereNode.comparison,"isGte") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# >= 
										<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										<cfelse>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										</cfif>
								
								<!--- isGteField --->
								<cfelseif compareNocase(whereNode.comparison,"isGteField") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# >= #getFieldOrExpressionForDelete(whereNode, Convention, 1)#
								
								<!--- isGt --->
								<cfelseif compareNocase(whereNode.comparison,"isGt") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# > 
										<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										<cfelse>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										</cfif>
								
								<!--- isGtField --->
								<cfelseif compareNocase(whereNode.comparison,"isGtField") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# > #getFieldOrExpressionForDelete(whereNode, Convention, 1)#
								
								<!--- isLte --->
								<cfelseif compareNocase(whereNode.comparison,"isLte") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# <= 
										<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										<cfelse>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										</cfif>
								
								<!--- isLteField --->
								<cfelseif compareNocase(whereNode.comparison,"isLteField") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# <= #getFieldOrExpressionForDelete(whereNode, Convention, 1)#
								
								<!--- isLt --->
								<cfelseif compareNocase(whereNode.comparison,"isLt") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# < 
										<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										<cfelse>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										</cfif>
								
								<!--- isLtField --->
								<cfelseif compareNocase(whereNode.comparison,"isLtField") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# < #getFieldOrExpressionForDelete(whereNode, Convention, 1)#
								
								<!--- isLike --->
								<cfelseif compareNocase(whereNode.comparison,"isLike") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# LIKE								
<!--- 								<cfswitch expression="#whereNode.mode#"> --->
											<cfif compareNocase(whereNode.mode,"Anywhere") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+2)#" value="%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%" />
												<cfset ArrayAppend(queryData.params, "%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%") />
											<cfelseif compareNocase(whereNode.mode,"Left") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+1)#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%" />
												<cfset ArrayAppend(queryData.params, "#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%") />
											<cfelseif compareNocase(whereNode.mode,"Right") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+1)#" value="%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
												<cfset ArrayAppend(queryData.params, "%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#") />
											<cfelseif compareNocase(whereNode.mode,"All") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
												<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										</cfif>
								
								<!--- isNotLike --->
								<cfelseif compareNocase(whereNode.comparison,"isNotLike") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# NOT LIKE
<!--- 								<cfswitch expression="#whereNode.mode#"> --->
 										<cfif compareNocase(whereNode.mode,"Anywhere") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+2)#" value="%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%" />
												<cfset ArrayAppend(queryData.params, "%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%") />
											<cfelseif compareNocase(whereNode.mode,"Left") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+1)#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%" />
												<cfset ArrayAppend(queryData.params, "#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%") />
											<cfelseif compareNocase(whereNode.mode,"Right") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+1)#" value="%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
												<cfset ArrayAppend(queryData.params, "%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#") />
											<cfelseif compareNocase(whereNode.mode,"All") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
												<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										</cfif>
								
								<!--- isIn --->
								<cfelseif compareNocase(whereNode.comparison,"isIn") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# IN ( 
										<cfif Len(Trim(whereNode.values))>
											<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#whereNode.values#" list="yes" />
												<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, whereNode.values)) />
											<cfelse>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#whereNode.values#" list="yes" />
												<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, whereNode.values)) />
											</cfif>
										<cfelse>
											<cfqueryparam null="yes" />
											<cfset ArrayAppend(queryData.params, "NULL") />
										</cfif>
									)
								
								<!--- isNotIn --->
								<cfelseif compareNocase(whereNode.comparison,"isNotIn") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# NOT IN ( 
										<cfif Len(Trim(whereNode.values))>
											<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#whereNode.values#" list="yes" />
												<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, whereNode.values)) />
											<cfelse>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#whereNode.values#" list="yes" />
												<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, whereNode.values)) />
											</cfif>
										<cfelse>
											<cfqueryparam null="yes" />
											<cfset ArrayAppend(queryData.params, "NULL") />
										</cfif>
									)
								
								<!--- isNull --->
								<cfelseif compareNocase(whereNode.comparison,"isNull") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# IS NULL
								
								<!--- isNotNull --->
								<cfelseif compareNocase(whereNode.comparison,"isNotNull") is 0>
									#getFieldOrExpressionForDelete(whereNode, Convention)# IS NOT NULL
								
							</cfif>	
						<cfelse>
							<!--- just output it --->
							#UCASE(whereNode)#
						</cfif>
						
					</cfloop>
				</cfif>
			</cfsavecontent>
			<cfoutput>#replaceNoCase(queryData.query, "''", "'", "all")#</cfoutput>
		</cfquery>
			
		<cfset queryData.query = replaceNoCase(queryData.query, "''", "'", "all") />
		<cfset setLastExecutedQuery(queryData) />
		
	</cffunction>
	
	<!--- getByQuery --->
	<cffunction name="getByQuery" access="public" hint="I return all matching rows from the object." output="false" returntype="any" _returntype="query">
		<cfargument name="Query" hint="I the query to run.  Create me using the createQuery method on this object." required="yes" type="any" _type="reactor.query.query" />
		<cfset var qGet = 0 />
		<cfset var Convention = _getConvention() />
		<cfset var where = arguments.Query.getWhere().getWhere() />
		<cfset var order = arguments.Query.getOrder().getOrder() />
		<cfset var whereNode = 0 />
		<cfset var orderNode = 0 />
		<cfset var x = 0 />
		<cfset var queryData = StructNew() />
		<cfset queryData.query = "" />
		<cfset queryData.params = ArrayNew(1) />
		
		<cfquery name="qGet" datasource="#_getConfig().getDsn()#" maxrows="#arguments.Query.getMaxRows()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
			<cfsavecontent variable="queryData.query">
				SELECT
				
				<!--- distinct --->
				<cfif arguments.Query.getDistinct()>
					DISTINCT
				</cfif>
				
				<!--- collumns --->
				#arguments.Query.getSelectAsString(Convention)#
				
				FROM
							
				#arguments.Query.getFromAsString(Convention)#
				
				<cfif ArrayLen(where)>
					WHERE
							
					<!--- loop over all of the expressions and render them out --->
					<cfloop from="1" to="#ArrayLen(where)#" index="x">
						<!--- get the arguments for this expression --->
						<cfset whereNode = where[x] />
						
						<!--- if the node is a structure output it accordingly.  otherwise, just output it. --->	
						<cfif IsStruct(whereNode)>
							<!--- render the expression --->
<!--- 							<cfswitch expression="#whereNode.comparison#"> --->
								<!--- isBetween --->
								<cfif compareNocase(whereNode.comparison,"isBetween") is 0>
									#getFieldExpression(whereNode, Convention)#
										<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
											BETWEEN <cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#whereNode.value1#" />
											<cfset ArrayAppend(queryData.params, whereNode.value1) />
											AND <cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#whereNode.value2#" />
											<cfset ArrayAppend(queryData.params, whereNode.value2) />
										<cfelse>
											BETWEEN <cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#whereNode.value1#" />
											<cfset ArrayAppend(queryData.params, whereNode.value1) />
											AND <cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#whereNode.value2#" />
											<cfset ArrayAppend(queryData.params, whereNode.value2) />
										</cfif>
								
								<!--- isBetweenFields --->
								<cfelseif compareNocase(whereNode.comparison,"isBetweenFields") is 0>
									#getFieldExpression(whereNode, Convention)#
										BETWEEN #getFieldExpression(whereNode, Convention, 1)#
										AND #getFieldExpression(whereNode, Convention, 2)#
								
								<!--- isEqual --->
								<cfelseif compareNocase(whereNode.comparison,"isEqual") is 0>
									#getFieldExpression(whereNode, Convention)# = 
										<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										<cfelse>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										</cfif>
								
								<!--- isEqualField --->
								<cfelseif compareNocase(whereNode.comparison,"isEqualField") is 0>
									#getFieldExpression(whereNode, Convention)# = #getFieldExpression(whereNode, Convention, 1)#
								
								<!--- isNotEqual --->
								<cfelseif compareNocase(whereNode.comparison,"isNotEqual") is 0>
									#getFieldExpression(whereNode, Convention)# != 
										<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										<cfelse>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										</cfif>
								
								<!--- isNotEqualField --->
								<cfelseif compareNocase(whereNode.comparison,"isNotEqualField") is 0>
									#getFieldExpression(whereNode, Convention)# != #getFieldExpression(whereNode, Convention, 1)#
								
								<!--- isGte --->
								<cfelseif compareNocase(whereNode.comparison,"isGte") is 0>
									#getFieldExpression(whereNode, Convention)# >= 
										<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										<cfelse>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										</cfif>
								
								<!--- isGteField --->
								<cfelseif compareNocase(whereNode.comparison,"isGteField") is 0>
									#getFieldExpression(whereNode, Convention)# >= #getFieldExpression(whereNode, Convention, 1)#
								
								<!--- isGt --->
								<cfelseif compareNocase(whereNode.comparison,"isGt") is 0>
									#getFieldExpression(whereNode, Convention)# > 
										<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										<cfelse>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										</cfif>
								
								<!--- isGtField --->
								<cfelseif compareNocase(whereNode.comparison,"isGtField") is 0>
									#getFieldExpression(whereNode, Convention)# > #getFieldExpression(whereNode, Convention, 1)#
								
								<!--- isLte --->
								<cfelseif compareNocase(whereNode.comparison,"isLte") is 0>
									#getFieldExpression(whereNode, Convention)# <= 
										<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										<cfelse>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										</cfif>
								
								<!--- isLteField --->
								<cfelseif compareNocase(whereNode.comparison,"isLteField") is 0>
									#getFieldExpression(whereNode, Convention)# <= #getFieldExpression(whereNode, Convention, 1)#
								
								<!--- isLt --->
								<cfelseif compareNocase(whereNode.comparison,"isLt") is 0>
									#getFieldExpression(whereNode, Convention)# < 
										<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										<cfelse>
											<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
											<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
										</cfif>
								
								<!--- isLtField --->
								<cfelseif compareNocase(whereNode.comparison,"isLtField") is 0>
									#getFieldExpression(whereNode, Convention)# < #getFieldExpression(whereNode, Convention, 1)#
								
								<!--- isLike --->
								<cfelseif compareNocase(whereNode.comparison,"isLike") is 0>
									#getFieldExpression(whereNode, Convention)# LIKE								
<!--- 	  				<cfswitch expression="#whereNode.mode#"> --->
 			  					<cfif compareNocase(whereNode.mode,"Anywhere") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+2)#" value="%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%" />
												<cfset ArrayAppend(queryData.params, "%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%") />
									<cfelseif compareNocase(whereNode.mode,"Left") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+1)#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%" />
												<cfset ArrayAppend(queryData.params, "#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%") />
									<cfelseif compareNocase(whereNode.mode,"Right") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+1)#" value="%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
												<cfset ArrayAppend(queryData.params, "%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#") />
									<cfelseif compareNocase(whereNode.mode,"All") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
												<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
									</cfif>
								
								<!--- isNotLike --->
								<cfelseif compareNocase(whereNode.comparison,"isNotLike") is 0>
									#getFieldExpression(whereNode, Convention)# NOT LIKE
<!--- 										<cfswitch expression="#whereNode.mode#"> --->
											<cfif compareNocase(whereNode.mode,"Anywhere") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+2)#" value="%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%" />
												<cfset ArrayAppend(queryData.params, "%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%") />
											<cfelseif compareNocase(whereNode.mode,"Left") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+1)#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%" />
												<cfset ArrayAppend(queryData.params, "#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#%") />
											<cfelseif compareNocase(whereNode.mode,"Right") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+1)#" value="%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
												<cfset ArrayAppend(queryData.params, "%#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#") />
											<cfelseif compareNocase(whereNode.mode,"All") is 0>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)#" />
												<cfset ArrayAppend(queryData.params, Convention.formatValue(whereNode.value, arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).dbDataType)) />
											</cfif>
								
								<!--- isIn --->
								<cfelseif compareNocase(whereNode.comparison,"isIn") is 0>
									#getFieldExpression(whereNode, Convention)# IN ( 
										<cfif Len(Trim(whereNode.values))>
											<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#whereNode.values#" list="yes" />
												<cfset ArrayAppend(queryData.params, whereNode.values) />
											<cfelse>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#whereNode.values#" list="yes" />
												<cfset ArrayAppend(queryData.params, whereNode.values) />
											</cfif>
										<cfelse>
											<cfqueryparam null="yes" />
											<cfset ArrayAppend(queryData.params, "NULL") />
										</cfif>
									)
								
								<!--- isNotIn --->
								<cfelseif compareNocase(whereNode.comparison,"isNotIn") is 0>
									#getFieldExpression(whereNode, Convention)# NOT IN ( 
										<cfif Len(Trim(whereNode.values))>
											<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="#whereNode.values#" list="yes" />
												<cfset ArrayAppend(queryData.params, whereNode.values) />
											<cfelse>
												<cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="#whereNode.values#" list="yes" />
												<cfset ArrayAppend(queryData.params, whereNode.values) />
											</cfif>
										<cfelse>
											<cfqueryparam null="yes" />
											<cfset ArrayAppend(queryData.params, "NULL") />
										</cfif>
									)
								
								<!--- isNull --->
								<cfelseif compareNocase(whereNode.comparison,"isNull") is 0>
									#getFieldExpression(whereNode, Convention)# IS NULL
								
								<!--- isNotNull --->
								<cfelseif compareNocase(whereNode.comparison,"isNotNull") is 0>
									#getFieldExpression(whereNode, Convention)# IS NOT NULL								
							</cfif>	
						<cfelse>
							<!--- just output it --->
							#UCASE(whereNode)#
						</cfif>
						
					</cfloop>
				</cfif>
				
				<cfif ArrayLen(order)>
					ORDER BY 
					
					<!--- loop over all of the order-bys and render them out --->
					<cfloop from="1" to="#ArrayLen(order)#" index="x">
						<!--- get the arguments for this expression --->
						<cfset orderNode = order[x] />
						
						<!---#Convention.formatFieldName(orderNode.field, orderNode.object)#--->
						#getFieldExpression(orderNode, Convention)# #UCASE(orderNode.direction)#
						
						<cfif x IS NOT ArrayLen(order)>
							,
						</cfif>
					</cfloop>
				</cfif>		
			</cfsavecontent>
			<cfoutput>#replaceNoCase(queryData.query, "''", "'", "all")#</cfoutput>
		</cfquery>
			
		<cfset queryData.query = replaceNoCase(queryData.query, "''", "'", "all") />
		<cfset setLastExecutedQuery(queryData) />
		
		<cfreturn qGet />
	</cffunction>
	
	<cffunction name="getFieldExpression" access="private" hint="I check to see if a field has been replaced with an expression and return either the formatted field or the expression" output="false" returntype="any" _returntype="string">
		<cfargument name="node" hint="I am the where node to translate" required="yes" type="any" _type="struct" />
		<cfargument name="convention" hint="I am the convention used to format the expression" required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfargument name="compareToIndex" hint="I am the index of the compare to field (if any)" required="no" type="any" _type="numeric" />
		
		<cfif StructKeyExists(arguments, "compareToIndex")>
			<cfif StructKeyExists(arguments.node, "compareToExpression#arguments.compareToIndex#")>
				<cfreturn arguments.node["compareToExpression#arguments.compareToIndex#"] />
			<cfelse>
				<cfreturn arguments.Convention.formatFieldName(arguments.node["compareToFieldAlias#arguments.compareToIndex#"], arguments.node["compareToObjectAlias#arguments.compareToIndex#"]) />
			</cfif>
		<cfelse>
			<cfif StructKeyExists(arguments.node, "expression")>
				<cfreturn arguments.node.expression />
			<cfelse>
				<cfreturn arguments.Convention.formatFieldName(arguments.node.fieldName, arguments.node.objectAlias) />
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="getFieldOrExpressionForDelete" access="private" hint="I check to see if a field has been replaced with an expression and return either the formatted field (w/o an alias) or the expression (w/o an alias)" output="false" returntype="any" _returntype="string">
		<cfargument name="node" hint="I am the where node to translate" required="yes" type="any" _type="struct" />
		<cfargument name="convention" hint="I am the convention used to format the expression" required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfargument name="compareToIndex" hint="I am the index of the compare to field (if any)" required="no" type="any" _type="numeric" />
		
		<cfif StructKeyExists(arguments, "compareToIndex")>
			<cfif StructKeyExists(arguments.node, "compareToExpression#arguments.compareToIndex#")>
				<cfreturn arguments.node["compareToExpression#arguments.compareToIndex#"] />
			<cfelse>
				<cfreturn arguments.Convention.formatUpdateFieldName(arguments.node["compareToFieldAlias#arguments.compareToIndex#"]) />
			</cfif>
		<cfelse>
			<cfif StructKeyExists(arguments.node, "expression")>
				<cfreturn arguments.node.expression />
			<cfelse>
				<cfreturn arguments.Convention.formatUpdateFieldName(arguments.node.fieldName) />
			</cfif>
		</cfif>
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

