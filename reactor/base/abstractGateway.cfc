<cfcomponent hint="I am used primarly to allow type definitions for return values.  I also loosely define an interface for gateway objects and some core methods." extends="reactor.base.abstractObject">
	
	<cffunction name="matchColumn" access="private" hint="I provided column name is in the field list." output="false" returntype="boolean">
		<cfargument name="fieldList" hint="I am a comma delimited list of fields." required="yes" type="string" />
		<cfargument name="columnName" hint="I am the column name to look for in the list" required="yes" type="string" />
		
		<cfreturn NOT Len(arguments.fieldList) OR ListFindNoCase(arguments.fieldList, arguments.columnName) />		
	</cffunction>
	
	<!--- metadata --->
    <cffunction name="getObjectMetadata" access="private" output="false" returntype="reactor.base.abstractMetadata">
       <cfreturn _getObjectFactory().create(_getName(), "Metadata") />
    </cffunction>
	
	<!--- getObjectName --->
	<cffunction name="getObjectName" access="public" output="false" returntype="string">
		<cfreturn getObjectMetadata()._getName() />
	</cffunction>
	
	<!--- getColumnCfSqlType --->
	<cffunction name="getColumnCfSqlType" access="public" output="false" returntype="string">
		<cfargument name="name" required="yes" type="string" />
		<cfreturn getObjectMetadata().getColumn(arguments.name).cfsqlType />
	</cffunction>
	
	<!--- getColumnLength --->
	<cffunction name="getColumnLength" access="public" output="false" returntype="string">
		<cfargument name="name" required="yes" type="string" />
		
		<cfreturn getObjectMetadata().getColumn(arguments.name).length />
	</cffunction>
	
	<!--- getColumnDbDataType --->
	<cffunction name="getColumnDbDataType" access="public" output="false" returntype="string">
		<cfargument name="name" required="yes" type="string" />

		<cfreturn getObjectMetadata().getColumn(arguments.name).dbDataType />
	</cffunction>
	
	<!--- createCriteria --->
	<cffunction name="createCriteria" access="public" hint="I return a critera object which can be used to compose and execute complex queries on this gateway." output="false" return="reactor.query.criteria">
		<cfset var criteria = CreateObject("Component", "reactor.query.criteria").init(getObjectMetadata()) />
		<cfreturn criteria />
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

	<!--- getByCriteria --->
	<cffunction name="getByCriteria" access="public" hint="I return all matching rows from the Test3 table." output="false" returntype="query">
		<cfargument name="Criteria" hint="I am optional criteria to apply to this query." required="yes" default="#CreateObject("Component", "reactor.query.criteria")#" />
		<cfset var objectMetadata = getObjectMetadata() />
		<cfset var childObjectMetadata = 0 />
		<cfset var superObjectMetadata = objectMetadata />
		<cfset var columnList = objectMetadata.getColumnList(false) />
		<cfset var column = "" />
		<cfset var relationships = 0 />
		<cfset var qGet = 0 />
		<cfset var result = 0 />
		<cfset var x = 0 />
		<cfset var args = 0 />
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
				#objectMetadata.getQuerySafeColumn(column)# <cfif column IS NOT ListLast(columnList)>,</cfif>
			</cfloop>

			FROM #objectMetadata.getQuerySafeTableName()# AS #objectMetadata.getQuerySafeTableAlias()#
		
			<cfloop condition="#superObjectMetadata.hasSuper()#">
				<cfset childObjectMetadata = superObjectMetadata />
				<cfset superObjectMetadata = superObjectMetadata.getSuperObjectMetadata() />
				
				JOIN #superObjectMetadata.getQuerySafeTableName()# AS #superObjectMetadata.getQuerySafeTableAlias()# ON 
					<cfset relationships = childObjectMetadata.getSuperRelation() />
					<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
						#childObjectMetadata.getQuerySafeColumn(relationships[x].from)# = #superObjectMetadata.getQuerySafeColumn(relationships[x].to)#
					</cfloop>
			</cfloop>
			
			<cfif ArrayLen(expressionNodes)>
				WHERE
						
				<!--- loop over all of the expressions and render them out --->
				<cfloop from="1" to="#ArrayLen(expressionNodes)#" index="x">
				
					<!--- get the arguments for this expression --->
					<cfset args = expressionNodes[x].XmlAttributes />
								
					<!--- render the expression --->
					<cfswitch expression="#expressionNodes[x].XmlName#">
						<!--- openParenthesis --->
						<cfcase value="openParenthesis">
							(
						</cfcase>		
							
						<!--- closeParenthesis --->
						<cfcase value="closeParenthesis">
							)
						</cfcase>
						
						<!--- and --->
						<cfcase value="and">
							AND
						</cfcase>
						
						<!--- or --->
						<cfcase value="or">
							OR
						</cfcase>
						
						<!--- not --->
						<cfcase value="not">
							NOT
						</cfcase>
						
						<!--- isBetween --->
						<cfcase value="isBetween">
							#objectMetadata.getQuerySafeColumn(args.field)#
								<cfif NOT getColumnLength(args.field)>
									BETWEEN <cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" value="#args.value1#" />
									AND <cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" value="#args.value2#" />
								<cfelse>
									BETWEEN <cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="#args.value1#" />
									AND <cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="#args.value2#" />
								</cfif>
						</cfcase>
						
						<!--- isBetweenFields --->
						<cfcase value="isBetweenFields">
							#objectMetadata.getQuerySafeColumn(args.field)#
								BETWEEN [#getObjectName()#].[#args.field1#]
								AND [#getObjectName()#].[#args.field2#]
						</cfcase>
						
						<!--- isEqual --->
						<cfcase value="isEqual">
							#objectMetadata.getQuerySafeColumn(args.field)# = 
								<cfif NOT getColumnLength(args.field)>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" value="#getValue(args.value, getColumnDbDataType(args.field))#" />
								<cfelse>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="#args.value#" />
								</cfif>
						</cfcase>
						
						<!--- isEqualField --->
						<cfcase value="isEqualField">
							#objectMetadata.getQuerySafeColumn(args.field)# = [#getObjectName()#].[#args.field1#]
						</cfcase>
						
						<!--- isNotEqual --->
						<cfcase value="isNotEqual">
							#objectMetadata.getQuerySafeColumn(args.field)# != 
								<cfif NOT getColumnLength(args.field)>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" value="#args.value#" />
								<cfelse>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="#args.value#" />
								</cfif>
						</cfcase>
						
						<!--- isNotEqualField --->
						<cfcase value="isNotEqualField">
							#objectMetadata.getQuerySafeColumn(args.field)# != [#getObjectName()#].[#args.field1#]
						</cfcase>
						
						<!--- isGte --->
						<cfcase value="isGte">
							#objectMetadata.getQuerySafeColumn(args.field)# >= 
								<cfif NOT getColumnLength(args.field)>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" value="#args.value#" />
								<cfelse>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="#args.value#" />
								</cfif>
						</cfcase>
						
						<!--- isGteField --->
						<cfcase value="isGteField">
							#objectMetadata.getQuerySafeColumn(args.field)# >= [#getObjectName()#].[#args.field1#]
						</cfcase>
						
						<!--- isGt --->
						<cfcase value="isGt">
							#objectMetadata.getQuerySafeColumn(args.field)# > 
								<cfif NOT getColumnLength(args.field)>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" value="#args.value#" />
								<cfelse>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="#args.value#" />
								</cfif>
						</cfcase>
						
						<!--- isGtField --->
						<cfcase value="isGtField">
							#objectMetadata.getQuerySafeColumn(args.field)# > [#getObjectName()#].[#args.field1#]
						</cfcase>
						
						<!--- isLike --->
						<cfcase value="isLike">
							#objectMetadata.getQuerySafeColumn(args.field)# LIKE
								<cfswitch expression="#args.mode#">
									<cfcase value="Anywhere">
										<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="%#args.value#%" />
									</cfcase>
									<cfcase value="Left">
										<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="%#args.value#" />
									</cfcase>
									<cfcase value="Right">
										<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="#args.value#%" />
									</cfcase>
									<cfcase value="All">
										<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="#args.value#" />
									</cfcase>
								</cfswitch>
						</cfcase>
						
						<!--- isNotLike --->
						<cfcase value="isNotLike">
							#objectMetadata.getQuerySafeColumn(args.field)# NOT LIKE
								<cfswitch expression="#args.mode#">
									<cfcase value="Anywhere">
										<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="%#args.value#%" />
									</cfcase>
									<cfcase value="Left">
										<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="%#args.value#" />
									</cfcase>
									<cfcase value="Right">
										<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="#args.value#%" />
									</cfcase>
									<cfcase value="All">
										<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="#args.value#" />
									</cfcase>
								</cfswitch>
						</cfcase>
						
						<!--- isIn --->
						<cfcase value="isIn">
							#objectMetadata.getQuerySafeColumn(args.field)# IN ( 
								<cfif NOT getColumnLength(args.field)>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" value="#args.values#" list="yes" />
								<cfelse>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="#args.values#" list="yes" />
								</cfif>
							)
						</cfcase>
						
						<!--- isNotIn --->
						<cfcase value="isNotIn">
							#objectMetadata.getQuerySafeColumn(args.field)# NOT IN ( 
								<cfif NOT getColumnLength(args.field)>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" value="#args.values#" list="yes" />
								<cfelse>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="#args.values#" list="yes" />
								</cfif>
							)
						</cfcase>
						
						<!--- isNull --->
						<cfcase value="isNull">
							#objectMetadata.getQuerySafeColumn(args.field)# IS NULL
						</cfcase>
						
						<!--- isNotNull --->
						<cfcase value="isNotNull">
							#objectMetadata.getQuerySafeColumn(args.field)# IS NOT NULL
						</cfcase>
						
						<!--- isLte --->
						<cfcase value="isLte">
							#objectMetadata.getQuerySafeColumn(args.field)# <= 
								<cfif NOT getColumnLength(args.field)>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" value="#args.value#" />
								<cfelse>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="#args.value#" />
								</cfif>
						</cfcase>
						
						<!--- isLteField --->
						<cfcase value="isLteField">
							#objectMetadata.getQuerySafeColumn(args.field)# <= [#getObjectName()#].[#args.field1#]
						</cfcase>
						
						<!--- isLt --->
						<cfcase value="isLt">
							#objectMetadata.getQuerySafeColumn(args.field)# < 
								<cfif NOT getColumnLength(args.field)>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" value="#args.value#" />
								<cfelse>
									<cfqueryparam cfsqltype="#getColumnCfSqlType(args.field)#" maxlength="#getColumnLength(args.field)#" value="#args.value#" />
								</cfif>
						</cfcase>
						
						<!--- isLtField --->
						<cfcase value="isLtField">
							#objectMetadata.getQuerySafeColumn(args.field)# < [#getObjectName()#].[#args.field1#]
						</cfcase>
					</cfswitch>
				</cfloop>
			</cfif>
			
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
		
		
		<cfreturn qGet />
	</cffunction>

</cfcomponent>