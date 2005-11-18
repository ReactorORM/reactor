<cfcomponent hint="I am used primarly to allow type definitions for return values.  I also loosely define an interface for gateway objects and some core methods." extends="reactor.base.abstractObject">
	
	<!--- metadata --->
    <cffunction name="getObjectMetadata" access="private" output="false" returntype="reactor.base.abstractMetadata">
       <cfreturn _getObjectFactory().create(_getName(), "Metadata") />
    </cffunction>	
	
	<!--- createQuery --->
	<cffunction name="createQuery" access="public" hint="I return a query object which can be used to compose and execute complex queries on this gateway." output="false" return="reactor.query.criteria">
		<cfset var query = CreateObject("Component", "reactor.query.query").init(getObjectMetadata()) />
		<cfreturn query />
	</cffunction>
	
	<!--- getByQuery --->
	<cffunction name="getByQuery" access="public" hint="I return all matching rows from the object." output="false" returntype="query">
		<cfargument name="Query" hint="I the query to run.  Create me using the createQuery method on this object." required="yes" default="reactor.query.query" />
		<cfset var qGet = 0 />
		<cfset var result = 0 />
		<cfset var Convention = getObjectMetadata().getConventions() />
		<cfset var where = arguments.Query.getWhere().getWhere() />
		<cfset var whereNode = 0 />
		
		<cfquery name="qGet" result="result" datasource="#_getConfig().getDsn()#">
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
				<!--- <!--- isBetween --->
				<cfcase value="isBetween">
					#objectMetadata.getQuerySafeColumn(whereNode.field)#
						<cfif NOT getColumnLength(whereNode.field)>
							BETWEEN <cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#whereNode.value1#" />
							AND <cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#whereNode.value2#" />
						<cfelse>
							BETWEEN <cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="#whereNode.value1#" />
							AND <cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="#whereNode.value2#" />
						</cfif>
				</cfcase>
				
				<!--- isBetweenFields --->
				<cfcase value="isBetweenFields">
					#objectMetadata.getQuerySafeColumn(whereNode.field)#
						BETWEEN [#getObjectName()#].[#whereNode.field1#]
						AND [#getObjectName()#].[#whereNode.field2#]
				</cfcase> --->
				
				<!--- isEqual --->
				<cfcase value="isEqual">
					#Convention.formatFieldName(whereNode.field, whereNode.object)# = 
						<cfif NOT arguments.Query.getField(whereNode.object, whereNode.field).length>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
						<cfelse>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
						</cfif>
				</cfcase>
				
				<!--- <!--- isEqualField --->
				<cfcase value="isEqualField">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# = [#getObjectName()#].[#whereNode.field1#]
				</cfcase>
				
				<!--- isNotEqual --->
				<cfcase value="isNotEqual">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# != 
						<cfif NOT getColumnLength(whereNode.field)>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
						<cfelse>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
						</cfif>
				</cfcase>
				
				<!--- isNotEqualField --->
				<cfcase value="isNotEqualField">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# != [#getObjectName()#].[#whereNode.field1#]
				</cfcase>
				
				<!--- isGte --->
				<cfcase value="isGte">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# >= 
						<cfif NOT getColumnLength(whereNode.field)>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
						<cfelse>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
						</cfif>
				</cfcase>
				
				<!--- isGteField --->
				<cfcase value="isGteField">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# >= [#getObjectName()#].[#whereNode.field1#]
				</cfcase>
				
				<!--- isGt --->
				<cfcase value="isGt">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# > 
						<cfif NOT getColumnLength(whereNode.field)>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
						<cfelse>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
						</cfif>
				</cfcase>
				
				<!--- isGtField --->
				<cfcase value="isGtField">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# > [#getObjectName()#].[#whereNode.field1#]
				</cfcase>
				
				<!--- isLike --->
				<cfcase value="isLike">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# LIKE
						<cfswitch expression="#whereNode.mode#">
							<cfcase value="Anywhere">
								<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="%#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#%" />
							</cfcase>
							<cfcase value="Left">
								<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="%#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
							</cfcase>
							<cfcase value="Right">
								<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#%" />
							</cfcase>
							<cfcase value="All">
								<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
							</cfcase>
						</cfswitch>
				</cfcase>
				
				<!--- isNotLike --->
				<cfcase value="isNotLike">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# NOT LIKE
						<cfswitch expression="#whereNode.mode#">
							<cfcase value="Anywhere">
								<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="%#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#%" />
							</cfcase>
							<cfcase value="Left">
								<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="%#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
							</cfcase>
							<cfcase value="Right">
								<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#%" />
							</cfcase>
							<cfcase value="All">
								<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
							</cfcase>
						</cfswitch>
				</cfcase>
				
				<!--- isIn --->
				<cfcase value="isIn">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# IN ( 
						<cfif NOT getColumnLength(whereNode.field)>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#whereNode.values#" list="yes" />
						<cfelse>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="#whereNode.values#" list="yes" />
						</cfif>
					)
				</cfcase>
				
				<!--- isNotIn --->
				<cfcase value="isNotIn">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# NOT IN ( 
						<cfif NOT getColumnLength(whereNode.field)>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#whereNode.values#" list="yes" />
						<cfelse>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="#whereNode.values#" list="yes" />
						</cfif>
					)
				</cfcase>
				
				<!--- isNull --->
				<cfcase value="isNull">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# IS NULL
				</cfcase>
				
				<!--- isNotNull --->
				<cfcase value="isNotNull">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# IS NOT NULL
				</cfcase>
				
				<!--- isLte --->
				<cfcase value="isLte">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# <= 
						<cfif NOT getColumnLength(whereNode.field)>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
						<cfelse>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
						</cfif>
				</cfcase>
				
				<!--- isLteField --->
				<cfcase value="isLteField">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# <= [#getObjectName()#].[#whereNode.field1#]
				</cfcase>
				
				<!--- isLt --->
				<cfcase value="isLt">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# < 
						<cfif NOT getColumnLength(whereNode.field)>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
						<cfelse>
							<cfqueryparam cfsqltype="#arguments.Query.getField(whereNode.object, whereNode.field).cfSqlType#" maxlength="#arguments.Query.getField(whereNode.object, whereNode.field).length#" value="#Convention.formatValue(whereNode.value, arguments.Query.getField(whereNode.object, whereNode.field).dbDataType)#" />
						</cfif>
				</cfcase>
				
				<!--- isLtField --->
				<cfcase value="isLtField">
					#objectMetadata.getQuerySafeColumn(whereNode.field)# < [#getObjectName()#].[#whereNode.field1#]
				</cfcase> --->
			</cfswitch>	
		<cfelse>
			<!--- just output it --->
			#UCASE(whereNode)#
		</cfif>
		
	</cfloop>
</cfif>

			
		</cfquery>
		
		<cfdump var="#qGet#" /><cfabort>
		
		<cfreturn qGet />
		
		<!---- 
		
		
		<cfset var x = 0 />
		
		<cfset var objectMetadata = getObjectMetadata() />
		<cfset var childObjectMetadata = 0 />
		<cfset var superObjectMetadata = objectMetadata />
		<cfset var columnList = objectMetadata.getColumnList(false) />
		<cfset var column = "" />
		<cfset var relationships = 0 />
		
		
		<cfset var x = 0 />
		<cfset var args = 0 />
		<cfset var joins = Criteria.getJoins() />
		<cfset var join = 0 />
		<!--- expression related --->
		<cfset var expression = arguments.Criteria.getExpression().getExpression().expression />
		<cfset var expressionNodes = expression.XmlChildren />
		<!--- order related --->
		<cfset var order = arguments.Criteria.getOrder().getOrder().order />
		<cfset var orderNodes = order.XmlChildren />
		
		<cfquery name="qGet" result="result" datasource="#_getConfig().getDsn()#">
			SELECT 

			<cfif arguments.Criteria.getDistinct()>
				DISTINCT
			</cfif>

			<cfloop list="#columnList#" index="column">
				#objectMetadata.getQuerySafeColumn(column)#
				<cfif column IS NOT ListLast(columnList) OR ArrayLen(joins)>
					,
				</cfif>
			</cfloop>
			
			<cfloop from="1" to="#ArrayLen(joins)#" index="x">
				<cfset join = joins[x] />
				<cfset columnList = join.ObjectMetadata.getColumnList() />
				
				<cfloop list="#columnList#" index="column">
					#join.ObjectMetadata.getQuerySafeColumn(column)#
					<cfif column IS NOT ListLast(columnList) OR ArrayLen(joins) IS NOT x>
						,
					</cfif>
				</cfloop>
			</cfloop>

			FROM #objectMetadata.getQuerySafeTableName()# AS #objectMetadata.getQuerySafeTableAlias()#
		
			<cfloop condition="#superObjectMetadata.hasSuper()#">
				<cfset childObjectMetadata = superObjectMetadata />
				<cfset superObjectMetadata = superObjectMetadata.getSuperObjectMetadata() />
				
				JOIN #superObjectMetadata.getQuerySafeTableName()# AS #superObjectMetadata.getQuerySafeTableAlias()# ON 
					<cfset relationships = childObjectMetadata.getSuperRelation() />
					<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
						#childObjectMetadata.getQuerySafeColumn(relationships[x].from)# = #superObjectMetadata.getQuerySafeColumn(relationships[x].to)#
						<cfif X IS NOT ArrayLen(relationships)>
							AND
						</cfif>
					</cfloop>
			</cfloop>
			
			<cfloop from="1" to="#ArrayLen(joins)#" index="x">
				<cfset join = joins[x] />
				
				#join.type# #join.ObjectMetadata.getQuerySafeTableName()# AS #join.ObjectMetadata.getQuerySafeTableAlias()# ON
					<cfset relationships = join.relation />
					<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
						#objectMetadata.getQuerySafeColumn(relationships[x].from)# = #join.ObjectMetadata.getQuerySafeColumn(relationships[x].to)#
						<cfif X IS NOT ArrayLen(relationships)>
							AND
						</cfif>
					</cfloop>
			</cfloop>
			
			
			
			<cfif ArrayLen(orderNodes)>
				ORDER BY 
				
				<!--- loop over all of the order-bys and render them out --->
				<cfloop from="1" to="#ArrayLen(orderNodes)#" index="x">
					<!--- get the arguments for this expression --->
					<cfset args = orderNodes[x].XmlAttributes />
					
					#objectMetadata.getQuerySafeColumn(args.field)# #UCASE(orderNodes[x].XmlName)#
					
					<cfif x IS NOT ArrayLen(orderNodes)>
						,
					</cfif>
					
				</cfloop>
			</cfif>
		</cfquery>
		
		<cfdump var="#result#" /><cfabort>
		
		
		<cfreturn qGet />
		--->
	</cffunction>

</cfcomponent>

<!---


	
	<!--- getObjectName --->
	<cffunction name="getObjectName" access="public" output="false" returntype="string">
		<cfreturn getObjectMetadata()._getName() />
	</cffunction>
	
	<!--- getFieldCfSqlType --->
	<cffunction name="getFieldCfSqlType" access="public" output="false" returntype="string">
		<cfargument name="name" required="yes" type="string" />
		<cfreturn getObjectMetadata().getField(arguments.name).cfsqlType />
	</cffunction>
	
	<!--- getFieldLength --->
	<cffunction name="getFieldLength" access="public" output="false" returntype="string">
		<cfargument name="name" required="yes" type="string" />
		
		<cfreturn getObjectMetadata().getField(arguments.name).length />
	</cffunction>
	
	<!--- getFieldDbDataType --->
	<cffunction name="getFieldDbDataType" access="public" output="false" returntype="string">
		<cfargument name="name" required="yes" type="string" />

		<cfreturn getObjectMetadata().getField(arguments.name).dbDataType />
	</cffunction>
	
	<!--- getValue --->
	<cffunction name="getValue" access="private" hint="I return a value.  If the value is a uuid I translate to sql" output="false" returntype="any">
		<cfargument name="value" hint="I am the value to get" required="yes" type="any" />
		<cfargument name="type" hint="I am this value's type" required="yes" type="string" />
		
		<cfif arguments.type IS variables.dbUniqueIdentifierType>
			<cfreturn Left(arguments.value, 23) & "-" & Right(arguments.value, 12) />
		<cfelse>
			<cfreturn arguments.value />
		</cfif>
	</cffunction>
	
--->