<cfcomponent hint="I am used primarly to allow type definitions for return values.  I also loosely define an interface for gateway objects and some core methods." extends="reactor.base.abstractObject">

	<!--- a gateway keeps a pool of query objects --->
	<cfset variables.queryPool = 0 />
	<cfset variables.queryObjectPool = 0 />
	
	<!--- configure --->
	<cffunction name="configure" access="public" hint="I configure and return this object." output="false" returntype="reactor.base.abstractGateway">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="reactor.config.config" />
		<cfargument name="alias" hint="I am the alias of this object." required="yes" type="string" />
		<cfargument name="ReactorFactory" hint="I am the reactorFactory object." required="yes" type="reactor.reactorFactory" />
		<cfargument name="Convention" hint="I am a database Convention object." required="yes" type="reactor.data.abstractConvention" />
		<cfargument name="ObjectMetadata" hint="I am a database Convention object." required="yes" type="reactor.base.abstractMetadata" />
		
		<cfset super.configure(arguments.Config, arguments.alias, arguments.ReactorFactory, arguments.Convention) />
		<cfset setObjectMetadata(arguments.ObjectMetadata) />>
		
		<cfreturn this />
	</cffunction>
	
	<!--- objectMetadata --->
    <cffunction name="setObjectMetadata" access="private" output="false" returntype="void">
       <cfargument name="objectMetadata" hint="I set the object metadata." required="yes" type="reactor.base.abstractMetadata" />
       <cfset variables.objectMetadata = arguments.objectMetadata />
    </cffunction>
    <cffunction name="getObjectMetadata" access="private" output="false" returntype="reactor.base.abstractMetadata">
       <cfreturn variables.objectMetadata />
    </cffunction>	

	<!---
		Sean 3/7/2006: add pool management for query objects
		pool management: queryPool is a linked-list with 0 as the terminator
	--->
	
	<!--- get a query object from the pool (thread-safe) --->
	<cffunction name="getQueryInstance" access="private" output="false" returntype="reactor.query.query">
		<cfset var query = 0 />
		<cfif isStruct(variables.queryPool)>
			<cflock name="reactor_gateway_#_getAlias()#_pool" timeout="10" type="exclusive">
				<cfif isStruct(variables.queryPool)>
					<cfset query = variables.queryPool.head />
					<cfset variables.queryPool = variables.queryPool.next />
				</cfif>
			</cflock>
		</cfif>
		<!--- create a new object if the pool was empty --->
		<cfif not isObject(query)>
			<cfset query = createObject("component","reactor.query.query") />
		</cfif>
		<cfreturn query />
	</cffunction>	
	
	<!--- return a query object to the pool (thread-safe) --->
	<cffunction name="releaseQueryInstance" access="private" output="false" returntype="void">
		<cfargument name="query" required="true" />
		<cfset var link = structNew() />
		<cfset arguments.query.setInitialized(false) />
		<cfset link.head = arguments.query />
		<cflock name="reactor_gateway_#_getAlias()#_pool" timeout="10" type="exclusive">
			<cfset link.next = variables.queryPool />
			<cfset variables.queryPool = link />
		</cflock>
	</cffunction>	

	<!---
		jRinehart 4/24/2006: add pool management for query "object" objects, based off of Sean's query pool
		pool management: queryObjectPool is a linked-list with 0 as the terminator
	--->
	<!--- get a query "object" instance from the pool (thread-safe) --->
	<cffunction name="getQueryObject" access="private" output="false" returntype="reactor.query.object">
		<cfset var object = 0 />
		<cfif isStruct(variables.queryObjectPool)>
			<cflock name="reactor_gateway_#_getAlias()#_objectpool" timeout="10" type="exclusive">
				<cfif isStruct(variables.queryObjectPool)>
					<cfset object = variables.queryObjectPool.head />
					<cfset variables.queryObjectPool = variables.queryObjectPool.next />
				</cfif>
			</cflock>
		</cfif>
		<!--- create a new object if the pool was empty --->
		<cfif not isObject(object)>
			<cfset object = createObject("component","reactor.query.object") />
		</cfif>
		<cfreturn object />
	</cffunction>	
	
	<!--- return a query "object" instance to the pool (thread-safe) --->
	<cffunction name="releaseQueryObject" access="private" output="false" returntype="void">
		<cfargument name="object" required="true" />
		<cfset var link = structNew() />
		<cfset link.head = arguments.object />
		<cflock name="reactor_gateway_#_getAlias()#_objectpool" timeout="10" type="exclusive">
			<cfset link.next = variables.queryObjectPool />
			<cfset variables.queryObjectPool = link />
		</cflock>
	</cffunction>	

	
	<!--- createQuery --->
	<cffunction name="createQuery" access="public" hint="I return a query object which can be used to compose and execute complex queries on this gateway." output="false" return="reactor.query.criteria">
		<cfset var objectMetadata = getObjectMetadata() />
		<cfset var object = "" />
		<cfset var query = "" />

		<cfset object = getQueryObject().init(objectMetadata, objectMetadata.getAlias()) />
		<cfset query = getQueryInstance().init(objectMetadata, object) />
		
		<cfreturn query />
	</cffunction>
	
	<!--- getByQuery --->
	<cffunction name="getByQuery" access="public" hint="I return all matching rows from the object." output="false" returntype="query">
		<cfargument name="Query" hint="I the query to run.  Create me using the createQuery method on this object." required="yes" type="reactor.query.query" />
		<cfargument name="releaseQuery" hint="I indicate whether to return the Query to the resource pool after use." type="boolean" default="true" />
		<cfset var qGet = 0 />
		<cfset var Convention = _getConvention() />
		<cfset var where = arguments.Query.getWhere().getWhere() />
		<cfset var order = arguments.Query.getOrder().getOrder() />
		<cfset var whereNode = 0 />
		<cfset var orderNode = 0 />
		<cfset var x = 0 />
		
	
		<cfquery name="qGet" datasource="#_getConfig().getDsn()#" maxrows="#arguments.Query.getMaxRows()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
			SELECT
			
			<!--- distinct --->
			<cfif arguments.Query.getDistinct()>
				DISTINCT
			</cfif>
			
			<!--- collumns --->
			#arguments.Query.getSelectAsString()#
			
			FROM
						
			#arguments.Query.getFromAsString()#
			
			<cfif ArrayLen(where)>
				WHERE
						
				<!--- loop over all of the expressions and render them out --->
				<cfloop from="1" to="#ArrayLen(where)#" index="x">
					<!--- get the arguments for this expression --->
					<cfset whereNode = where[x] />
					
					<!--- if the node is a structure output it accordingly.  otherwise, just output it. --->	
					<cfif IsStruct(whereNode)>
						<!--- render the expression --->
						<cfswitch expression="#whereNode.comparison#">
							<!--- isBetween --->
							<cfcase value="isBetween">
								#getFieldExpression(whereNode, Convention)#
									<cfif NOT arguments.Query.getField(whereNode.object, whereNode.alias).length>
										BETWEEN <cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#whereNode.value1#" />
										AND <cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#whereNode.value2#" />
									<cfelse>
										BETWEEN <cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#whereNode.value1#" />
										AND <cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#whereNode.value2#" />
									</cfif>
							</cfcase>
							
							<!--- isBetweenFields --->
							<cfcase value="isBetweenFields">
								#getFieldExpression(whereNode, Convention)#
									BETWEEN #getFieldExpression(whereNode, Convention, 1)#
									AND #getFieldExpression(whereNode, Convention, 2)#
							</cfcase>
							
							<!--- isEqual --->
							<cfcase value="isEqual">
								#getFieldExpression(whereNode, Convention)# = 
									<cfif NOT arguments.Query.getField(whereNode.object, whereNode.alias).length>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.alias).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.alias).dbDataType)#" />
									<cfelse>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.alias).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.alias).dbDataType)#" />
									</cfif>
							</cfcase>
							
							<!--- isEqualField --->
							<cfcase value="isEqualField">
								#getFieldExpression(whereNode, Convention)# = #getFieldExpression(whereNode, Convention, 1)#
							</cfcase>
							
							<!--- isNotEqual --->
							<cfcase value="isNotEqual">
								#getFieldExpression(whereNode, Convention)# != 
									<cfif NOT arguments.Query.getField(whereNode.object, whereNode.alias).length>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									<cfelse>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									</cfif>
							</cfcase>
							
							<!--- isNotEqualField --->
							<cfcase value="isNotEqualField">
								#getFieldExpression(whereNode, Convention)# != #getFieldExpression(whereNode, Convention, 1)#
							</cfcase>
							
							<!--- isGte --->
							<cfcase value="isGte">
								#getFieldExpression(whereNode, Convention)# >= 
									<cfif NOT arguments.Query.getField(whereNode.object, whereNode.alias).length>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									<cfelse>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									</cfif>
							</cfcase>
							
							<!--- isGteField --->
							<cfcase value="isGteField">
								#getFieldExpression(whereNode, Convention)# >= #getFieldExpression(whereNode, Convention, 1)#
							</cfcase>
							
							<!--- isGt --->
							<cfcase value="isGt">
								#getFieldExpression(whereNode, Convention)# > 
									<cfif NOT arguments.Query.getField(whereNode.object, whereNode.alias).length>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									<cfelse>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									</cfif>
							</cfcase>
							
							<!--- isGtField --->
							<cfcase value="isGtField">
								#getFieldExpression(whereNode, Convention)# > #getFieldExpression(whereNode, Convention, 1)#
							</cfcase>
							
							<!--- isLte --->
							<cfcase value="isLte">
								#getFieldExpression(whereNode, Convention)# <= 
									<cfif NOT arguments.Query.getField(whereNode.object, whereNode.alias).length>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									<cfelse>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									</cfif>
							</cfcase>
							
							<!--- isLteField --->
							<cfcase value="isLteField">
								#getFieldExpression(whereNode, Convention)# <= #getFieldExpression(whereNode, Convention, 1)#
							</cfcase>
							
							<!--- isLt --->
							<cfcase value="isLt">
								#getFieldExpression(whereNode, Convention)# < 
									<cfif NOT arguments.Query.getField(whereNode.object, whereNode.alias).length>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									<cfelse>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									</cfif>
							</cfcase>
							
							<!--- isLtField --->
							<cfcase value="isLtField">
								#getFieldExpression(whereNode, Convention)# < #getFieldExpression(whereNode, Convention, 1)#
							</cfcase>
							
							<!--- isLike --->
							<cfcase value="isLike">
								#getFieldExpression(whereNode, Convention)# LIKE								
									<cfswitch expression="#whereNode.mode#">
										<cfcase value="Anywhere">
											<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="%#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#%" />
										</cfcase>
										<cfcase value="Left">
											<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#%" />
										</cfcase>
										<cfcase value="Right">
											<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="%#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
										</cfcase>
										<cfcase value="All">
											<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
										</cfcase>
									</cfswitch>
							</cfcase>
							
							<!--- isNotLike --->
							<cfcase value="isNotLike">
								#getFieldExpression(whereNode, Convention)# NOT LIKE
									<cfswitch expression="#whereNode.mode#">
										<cfcase value="Anywhere">
											<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="%#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#%" />
										</cfcase>
										<cfcase value="Left">
											<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#%" />
										</cfcase>
										<cfcase value="Right">
											<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="%#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
										</cfcase>
										<cfcase value="All">
											<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
										</cfcase>
									</cfswitch>
							</cfcase>
							
							<!--- isIn --->
							<cfcase value="isIn">
								#getFieldExpression(whereNode, Convention)# IN ( 
									<cfif Len(Trim(whereNode.values))>
										<cfif NOT arguments.Query.getField(whereNode.object, whereNode.alias).length>
											<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#whereNode.values#" list="yes" />
										<cfelse>
											<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#whereNode.values#" list="yes" />
										</cfif>
									<cfelse>
										<cfqueryparam null="yes" />
									</cfif>
								)
							</cfcase>
							
							<!--- isNotIn --->
							<cfcase value="isNotIn">
								#getFieldExpression(whereNode, Convention)# NOT IN ( 
									<cfif Len(Trim(whereNode.values))>
										<cfif NOT arguments.Query.getField(whereNode.object, whereNode.alias).length>
											<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#whereNode.values#" list="yes" />
										<cfelse>
											<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#whereNode.values#" list="yes" />
										</cfif>
									<cfelse>
										<cfqueryparam null="yes" />
									</cfif>
								)
							</cfcase>
							
							<!--- isNull --->
							<cfcase value="isNull">
								#getFieldExpression(whereNode, Convention)# IS NULL
							</cfcase>
							
							<!--- isNotNull --->
							<cfcase value="isNotNull">
								#getFieldExpression(whereNode, Convention)# IS NOT NULL
							</cfcase>	
							
						</cfswitch>	
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
				
		</cfquery>
			
		
		<cfif arguments.releaseQuery>
			<cfset releaseQueryObject(arguments.Query.getFrom()) />
			<cfset releaseQueryInstance(arguments.Query) />
		</cfif>
		<!---<cfset qGet.result = result />--->
		
		<!--- return the query result --->
		<cfreturn qGet />
	</cffunction>
	
	<cffunction name="getFieldExpression" access="private" hint="I check to see if a field has been replaced with an expression and return either the formatted field or the expression" output="false" returntype="string">
		<cfargument name="node" hint="I am the where node to translate" required="yes" type="struct" />
		<cfargument name="convention" hint="I am the convention used to format the expression" required="yes" type="reactor.data.abstractConvention" />
		<cfargument name="compareToIndex" hint="I am the index of the compare to field (if any)" required="no" type="numeric" />
		
		<cfif StructKeyExists(arguments, "compareToIndex")>
			<cfif StructKeyExists(arguments.node, "compareToExpression#arguments.compareToIndex#")>
				<cfreturn arguments.node["compareToExpression#arguments.compareToIndex#"] />
			<cfelse>
				<cfreturn arguments.Convention.formatFieldName(arguments.node["compareToField#arguments.compareToIndex#"], arguments.node["compareToObject#arguments.compareToIndex#"]) />
			</cfif>
		<cfelse>
			<cfif StructKeyExists(arguments.node, "expression")>
				<cfreturn arguments.node.expression />
			<cfelse>
				<cfreturn arguments.Convention.formatFieldName(arguments.node.field, arguments.node.object) />
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>
