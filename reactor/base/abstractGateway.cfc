<cfcomponent hint="I am used primarly to allow type definitions for return values.  I also loosely define an interface for gateway objects and some core methods." extends="reactor.base.abstractObject">

	<!--- a gateway keeps a pool of query objects --->
	<cfset variables.queryPool = 0 />
		
	<!--- metadata --->
    <cffunction name="getObjectMetadata" access="private" output="false" returntype="reactor.base.abstractMetadata">
       <cfreturn _getReactorFactory().createMetadata(_getName()) />
    </cffunction>	

	<!---
		Sean 3/7/2006: add pool management for query objects
		pool management: queryPool is a linked-list with 0 as the terminator
	--->
	
	<!--- get a query object from the pool (thread-safe) --->
	<cffunction name="getQueryObject" access="private" output="false" returntype="reactor.query.query">
		<cfset var query = 0 />
		<cfif isStruct(variables.queryPool)>
			<cflock name="reactor_gateway_#_getName()#_pool" timeout="10" type="exclusive">
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
	<cffunction name="releaseQueryObject" access="private" output="false" returntype="void">
		<cfargument name="query" required="true" />
		<cfset var link = structNew() />
		<cfset link.head = arguments.query />
		<cflock name="reactor_gateway_#_getName()#_pool" timeout="10" type="exclusive">
			<cfset link.next = variables.queryPool />
			<cfset variables.queryPool = link />
		</cflock>
	</cffunction>	
	
	<!--- createQuery --->
	<cffunction name="createQuery" access="public" hint="I return a query object which can be used to compose and execute complex queries on this gateway." output="false" return="reactor.query.criteria">
		<cfset var query = getQueryObject().init(getObjectMetadata()) />
		<cfreturn query />
	</cffunction>
	
	<!--- getByQuery --->
	<cffunction name="getByQuery" access="public" hint="I return all matching rows from the object." output="false" returntype="query">
		<cfargument name="Query" hint="I the query to run.  Create me using the createQuery method on this object." required="yes" type="reactor.query.query" />
		<cfargument name="releaseQuery" hint="I indicate whether to return the Query to the resource pool after use." type="boolean" default="false" />
		<cfset var qGet = 0 />
		<cfset var Convention = getObjectMetadata().getConventions() />
		<cfset var where = arguments.Query.getWhere().getWhere() />
		<cfset var order = arguments.Query.getOrder().getOrder() />
		<cfset var whereNode = 0 />
		<cfset var orderNodes = 0 />
		<cfset var x = 0 />
		
		<cfquery name="qGet" datasource="#_getConfig().getDsn()#" maxrows="#arguments.Query.getMaxRows()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
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
						<cfswitch expression="#whereNode.comparison#">
							<!--- isBetween --->
							<cfcase value="isBetween">
								#Convention.formatFieldName(whereNode.field, whereNode.object)#
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
								#Convention.formatFieldName(whereNode.field, whereNode.object)#
									BETWEEN #Convention.formatFieldName(whereNode.compareToField1, whereNode.compareToObject1)#
									AND #Convention.formatFieldName(whereNode.compareToField2, whereNode.compareToObject2)#
							</cfcase>
							
							<!--- isEqual --->
							<cfcase value="isEqual">
								#Convention.formatFieldName(whereNode.field, whereNode.object)# = 
									<cfif NOT arguments.Query.getField(whereNode.object, whereNode.alias).length>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.alias).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.alias).dbDataType)#" />
									<cfelse>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.alias).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.alias).dbDataType)#" />
									</cfif>
							</cfcase>
							
							<!--- isEqualField --->
							<cfcase value="isEqualField">
								#Convention.formatFieldName(whereNode.field, whereNode.object)# = #Convention.formatFieldName(whereNode.compareToField1, whereNode.compareToObject1)#
							</cfcase>
							
							<!--- isNotEqual --->
							<cfcase value="isNotEqual">
								#Convention.formatFieldName(whereNode.field, whereNode.object)# != 
									<cfif NOT arguments.Query.getField(whereNode.object, whereNode.alias).length>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									<cfelse>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									</cfif>
							</cfcase>
							
							<!--- isNotEqualField --->
							<cfcase value="isNotEqualField">
								#Convention.formatFieldName(whereNode.field, whereNode.object)# != #Convention.formatFieldName(whereNode.compareToField1, whereNode.compareToObject1)#
							</cfcase>
							
							<!--- isGte --->
							<cfcase value="isGte">
								#Convention.formatFieldName(whereNode.field, whereNode.object)# >= 
									<cfif NOT arguments.Query.getField(whereNode.object, whereNode.alias).length>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									<cfelse>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									</cfif>
							</cfcase>
							
							<!--- isGteField --->
							<cfcase value="isGteField">
								#Convention.formatFieldName(whereNode.field, whereNode.object)# >= #Convention.formatFieldName(whereNode.compareToField1, whereNode.compareToObject1)#
							</cfcase>
							
							<!--- isGt --->
							<cfcase value="isGt">
								#Convention.formatFieldName(whereNode.field, whereNode.object)# > 
									<cfif NOT arguments.Query.getField(whereNode.object, whereNode.alias).length>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									<cfelse>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									</cfif>
							</cfcase>
							
							<!--- isGtField --->
							<cfcase value="isGtField">
								#Convention.formatFieldName(whereNode.field, whereNode.object)# > #Convention.formatFieldName(whereNode.compareToField1, whereNode.compareToObject1)#
							</cfcase>
							
							<!--- isLte --->
							<cfcase value="isLte">
								#Convention.formatFieldName(whereNode.field, whereNode.object)# <= 
									<cfif NOT arguments.Query.getField(whereNode.object, whereNode.alias).length>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									<cfelse>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									</cfif>
							</cfcase>
							
							<!--- isLteField --->
							<cfcase value="isLteField">
								#Convention.formatFieldName(whereNode.field, whereNode.object)# <= #Convention.formatFieldName(whereNode.compareToField1, whereNode.compareToObject1)#
							</cfcase>
							
							<!--- isLt --->
							<cfcase value="isLt">
								#Convention.formatFieldName(whereNode.field, whereNode.object)# < 
									<cfif NOT arguments.Query.getField(whereNode.object, whereNode.alias).length>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									<cfelse>
										<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.alias).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
									</cfif>
							</cfcase>
							
							<!--- isLtField --->
							<cfcase value="isLtField">
								#Convention.formatFieldName(whereNode.field, whereNode.object)# < #Convention.formatFieldName(whereNode.compareToField1, whereNode.compareToObject1)#
							</cfcase>
							
							<!--- isLike --->
							<cfcase value="isLike">
								#Convention.formatFieldName(whereNode.field, whereNode.object)# LIKE
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
								#Convention.formatFieldName(whereNode.field, whereNode.object)# NOT LIKE
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
								#Convention.formatFieldName(whereNode.field, whereNode.object)# IN ( 
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
								#Convention.formatFieldName(whereNode.field, whereNode.object)# NOT IN ( 
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
								#Convention.formatFieldName(whereNode.field, whereNode.object)# IS NULL
							</cfcase>
							
							<!--- isNotNull --->
							<cfcase value="isNotNull">
								#Convention.formatFieldName(whereNode.field, whereNode.object)# IS NOT NULL
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
					
					#Convention.formatFieldName(orderNode.field, orderNode.object)# #UCASE(orderNode.direction)#
					
					<cfif x IS NOT ArrayLen(order)>
						,
					</cfif>
					
				</cfloop>
			</cfif>			
		</cfquery>
		
		<cfif arguments.releaseQuery>
			<cfset releaseQueryObject(arguments.Query) />
		</cfif>
		<!---<cfset qGet.result = result />--->
		
		<!--- return the query result --->
		<cfreturn qGet />
	</cffunction>

</cfcomponent>
