<cfcomponent hint="I am a component used to define ad-hoc queries used throughout Reactor.">
	
	<cfset variables.where = 0 />
	<cfset variables.order = 0 />
	<cfset variables.maxrows = -1 />
	<cfset variables.initData = StructNew() />
	<cfset variables.instance = StructNew() />
	<cfset variables.instance.queryCommands = ArrayNew(1) />
	<cfset variables.instance.orderCommands = ArrayNew(1) />
	<cfset variables.values = ArrayNew(1) />
	<cfset variables.instance.objectSignatures = "" />
	
	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the query." output="false" returntype="any" _returntype="reactor.query.query">
		<cfargument name="objectAlias" hint="I am the alias of the object that will be queried." required="yes" type="any" _type="string" />
		<cfargument name="queryAlias" hint="I am the alias of the object within the query." required="yes" type="any" _type="string" />
		<cfargument name="ReactorFactory" hint="I am the ReactorFactory" required="yes" type="any" _type="reactor.reactorFactory" />
		
		<cfset variables.initData = arguments />
		
		<cfset logObjectSignature(arguments.objectAlias) />
		
		<cfset resetWhere() />
		<cfset resetOrder() />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="logObjectSignature" access="private" hint="I log an object's signature so that we can tell when it's changes and force the regeneration of queries." output="false" returntype="void">
		<cfargument name="objectAlias" hint="I am the object's alias." required="yes" type="any" _type="string" />
		
		<cfset variables.instance.objectSignatures = variables.instance.objectSignatures & variables.initData.ReactorFactory.createMetadata(arguments.objectAlias)._getSignature() />
	</cffunction>
	
	<cffunction name="getWhereCommands" access="package" hint="I return a structure which contains the array of where commands (so I can pass the array byref)" output="false" returntype="struct">
		<cfset var result = StructNew() />
		<cfset result.whereCommands = variables.instance.whereCommands />
		<cfreturn result />
	</cffunction>
	
	<cffunction name="getValue" access="public" hint="I return a specific value for the query" output="false" returntype="any" _returntype="any">
		<cfargument name="index" hint="I am the index of the value" required="yes" type="any" _type="numeric" />
		
		<cfreturn variables.values[arguments.index] />		
	</cffunction>
	<cffunction name="getValues" access="public" hint="I return a specific value for the query" output="false" returntype="any" _returntype="array">
		<cfreturn variables.values />		
	</cffunction>
	
	<!--- parse --->
	<cffunction name="getQueryFile" access="public" hint="I render the query data to a physical query on disk and return the path to that file.  If the exact query already exists then I simply return that file's path." output="false" returntype="any" _returntype="string">
		<cfargument name="Config" hint="I am the Config object." required="yes" type="any" _type="reactor.config.config" />
		<cfargument name="Convention" hint="I am the Convention object to use when rendering the query." required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfargument name="type" hint="I am the type of query (select or delete)." required="yes" type="any" _type="string" />
		<cfset var queryFileName = "/reactor/project/#arguments.Config.getProject()#/Queries/" & arguments.Config.getType() & "_" & getHash() & ".cfm" />
		<cfset var queryDirectory = 0 />
		<cfset var whereCommands = 0 />
		<cfset var Query = 0 />
		<cfset var Where = 0 />
		<cfset var Order = 0 />
		<cfset var x = 0 />
		
		<cfif NOT FileExists(expandPath(queryFileName))> 
			<!--- create the queryRenderer --->
			<cfset Query = CreateObject("Component", "reactor.query.render.query").init(variables.initData.objectAlias, variables.initData.queryAlias, variables.initData.ReactorFactory) />
			
			<!--- run query commands --->
			<cfloop from="1" to="#ArrayLen(variables.instance.queryCommands)#" index="x">
				<!--- invoke the command --->
				<cfinvoke component="#Query#" method="#variables.instance.queryCommands[x].method#" argumentcollection="#variables.instance.queryCommands[x].params#" />
			</cfloop>
			
			<!--- run where commands --->
			<cfset Where = Query.getWhere() />
			<cfset whereCommands = variables.where.getWhereCommands() />
			<cfset applyWhere(Where, whereCommands) />
						
			<!--- run order commands --->
			<cfset Order = Query.getOrder() />
			<cfloop from="1" to="#ArrayLen(variables.instance.orderCommands)#" index="x">
				<!--- invoke the command --->
				<cfinvoke component="#Order#" method="#variables.instance.orderCommands[x].method#" argumentcollection="#variables.instance.orderCommands[x].params#" />
			</cfloop>
			
			<!--- check the type of the query --->
			<cfif arguments.type IS "select">
				<cfset Query = renderSelect(Query, Convention) />
				
			<cfelseif arguments.type IS "delete">
				<!--- check if the object has any joins --->
				<cfif Query.hasJoins()>
					<cfthrow message="Can Not Delete By Query With Joins"
						detail="You can not use a query that has joins when calling delete by query."
						type="reactor.abstractGateway.CanNotDeleteByQueryWithJoins" />
				</cfif>
				
				<cfset Query = renderDelete(Query, Convention) />
			</cfif>
			
			<!--- write the query to disk --->
			<cfset queryDirectory = getDirectoryFromPath(expandPath(queryFileName)) />
			<cfif NOT DirectoryExists(queryDirectory)>
				<cfdirectory action="create" directory="#queryDirectory#" />				
			</cfif>
			
			<cffile action="write" file="#expandPath(queryFileName)#" output="#Query#" nameconflict="overwrite" />
			
		</cfif>
		
		<cfreturn queryFileName />
	</cffunction>
	
	<cffunction name="applyWhere" access="private" hint="I add the where statements to the rendered query" output="false" returntype="void">
		<cfargument name="Where" hint="I am the where statement to populate" required="yes" type="any" _type="reactor.query.render.where" />
		<cfargument name="whereCommands" hint="I am the array of whereCommands" required="yes" type="any" _type="array" />
		<cfset var x = 0 />
		<cfset var Where2 = 0 />
		
		<cfloop from="1" to="#ArrayLen(arguments.whereCommands)#" index="x">
			<!--- invoke the command --->
			<cfif ListFindNoCase("addWhere,negateWhere", arguments.whereCommands[x].method)>
				<!--- create a new where object --->
				<cfset Where2 = arguments.where.createWhere() />
				
				<cfset applyWhere(Where2, arguments.whereCommands[x].params.where.getWhereCommands()) />
				
				<cfinvoke component="#arguments.Where#" method="#arguments.whereCommands[x].method#">
					<cfinvokeargument name="Where1" value="#Where2#" />
				</cfinvoke>
			<cfelse>
				<cfinvoke component="#arguments.Where#" method="#arguments.whereCommands[x].method#" argumentcollection="#arguments.whereCommands[x].params#" />
			</cfif>		
		</cfloop>
	</cffunction>
	
	<cffunction name="renderDelete" access="public" hint="I render a delete query" output="true" returntype="any" _returntype="string">
		<cfargument name="Query" hint="I the query to render. " required="yes" type="any" _type="reactor.query.render.query" />
		<cfargument name="Convention" hint="I am the Convention object to use when rendering the query." required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfset var result = "" />
		
		<cfsavecontent variable="result">
			DELETE FROM 
			#arguments.Query.getDeleteAsString(Convention)#
			#renderWhere(arguments.Query, arguments.Convention)#
		</cfsavecontent>
		
		<!--- make this valid cfml --->
		<cfset result = Replace(result, "[[", "<", "all") />
		<cfset result = Replace(result, "]]", ">", "all") />
		
		<!--- return the query --->
		<cfreturn result />
	</cffunction>
	
	<cffunction name="renderSelect" access="public" hint="I render a select query" output="true" returntype="any" _returntype="string">
		<cfargument name="Query" hint="I the query to render. " required="yes" type="any" _type="reactor.query.render.query" />
		<cfargument name="Convention" hint="I am the Convention object to use when rendering the query." required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfset var result = "" />
		<cfset var where = arguments.Query.getWhere().getWhere() />
		<cfset var order = arguments.Query.getOrder().getOrder() />
		<cfset var whereNode = 0 />
		<cfset var orderNode = 0 />
		<cfset var x = 0 />
		
		<cfsavecontent variable="result">
			SELECT
					
			<!--- distinct --->
			<cfif arguments.Query.getDistinct()>
				DISTINCT
			</cfif>
			
			<!--- collumns --->
			#arguments.Query.getSelectAsString(Convention)#
			
			FROM
						
			#arguments.Query.getFromAsString(Convention)#
			
			#renderWhere(arguments.Query, arguments.Convention)#
			
			<cfif ArrayLen(order)>
				ORDER BY 
				
				<!--- loop over all of the order-bys and render them out --->
				<cfloop from="1" to="#ArrayLen(order)#" index="x">
					<!--- get the arguments for this expression --->
					<cfset orderNode = order[x] />
					
					<!---#arguments.Convention.formatFieldName(orderNode.field, orderNode.object)#--->
					#getFieldExpression(orderNode, arguments.Convention)# #UCASE(orderNode.direction)#
					
					<cfif x IS NOT ArrayLen(order)>
						,
					</cfif>
				</cfloop>
			</cfif>
		</cfsavecontent>
		
		<!--- make this valid cfml --->
		<cfset result = Replace(result, "[[", "<", "all") />
		<cfset result = Replace(result, "]]", ">", "all") />
		
		<!--- return the query --->
		<cfreturn result />
	</cffunction>
	
	<cffunction name="renderWhere" access="public" hint="I render a where clause" output="true" returntype="any" _returntype="string">
		<cfargument name="Query" hint="I the query to render. " required="yes" type="any" _type="reactor.query.render.query" />
		<cfargument name="Convention" hint="I am the Convention object to use when rendering the query." required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfset var result = "" />
		<cfset var where = arguments.Query.getWhere().getWhere() />
		<cfset var whereNode = 0 />
		<cfset var x = 0 />
		
		<cfsavecontent variable="result">
			<cfif ArrayLen(where)>
				WHERE
						
				<!--- loop over all of the expressions and render them out --->
				<cfloop from="1" to="#ArrayLen(where)#" index="x">
					<!--- get the arguments for this expression --->
					<cfset whereNode = where[x] />
					
					<!--- if the node is a structure output it accordingly.  otherwise, just output it. --->	
					<cfif IsStruct(whereNode)>
						<!--- render the expression --->
	
							<!--- isBetween --->
							<cfif compareNocase(whereNode.comparison,"isBetween") is 0>
								#getFieldExpression(whereNode, arguments.Convention)#
									<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
										BETWEEN [[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="##arguments.Query.getValue(#whereNode.value1#)##" /]]
										AND [[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="##arguments.Query.getValue(#whereNode.value2#)##" /]]
									<cfelse>
										BETWEEN [[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="##arguments.Query.getValue(#whereNode.value1#)##" /]]
										AND [[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="##arguments.Query.getValue(#whereNode.value2#)##" /]]
									</cfif>
							
							<!--- isBetweenFields --->
							<cfelseif compareNocase(whereNode.comparison,"isBetweenFields") is 0>
								#getFieldExpression(whereNode, arguments.Convention)#
									BETWEEN #getFieldExpression(whereNode, arguments.Convention, 1)#
									AND #getFieldExpression(whereNode, arguments.Convention, 2)#
							
							<!--- isEqual --->
							<cfelseif compareNocase(whereNode.comparison,"isEqual") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# = 
									<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="##arguments.Query.getValue(#whereNode.value#)##" /]]
									<cfelse>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="##arguments.Query.getValue(#whereNode.value#)##" /]]
									</cfif>
							
							<!--- isEqualField --->
							<cfelseif compareNocase(whereNode.comparison,"isEqualField") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# = #getFieldExpression(whereNode, arguments.Convention, 1)#
							

							<!--- isNotEqual --->
							<cfelseif compareNocase(whereNode.comparison,"isNotEqual") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# != 
									<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="##arguments.Query.getValue(#whereNode.value#)##" /]]
									<cfelse>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="##arguments.Query.getValue(#whereNode.value#)##" /]]
									</cfif>
							
							<!--- isNotEqualField --->
							<cfelseif compareNocase(whereNode.comparison,"isNotEqualField") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# != #getFieldExpression(whereNode, arguments.Convention, 1)#
							
							<!--- isGte --->
							<cfelseif compareNocase(whereNode.comparison,"isGte") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# >= 
									<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="##arguments.Query.getValue(#whereNode.value#)##" /]]
									<cfelse>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="##arguments.Query.getValue(#whereNode.value#)##" /]]
									</cfif>
							
							<!--- isGteField --->
							<cfelseif compareNocase(whereNode.comparison,"isGteField") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# >= #getFieldExpression(whereNode, arguments.Convention, 1)#
							
							<!--- isGt --->
							<cfelseif compareNocase(whereNode.comparison,"isGt") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# > 
									<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="##arguments.Query.getValue(#whereNode.value#)##" /]]
									<cfelse>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="##arguments.Query.getValue(#whereNode.value#)##" /]]
									</cfif>
							
							<!--- isGtField --->
							<cfelseif compareNocase(whereNode.comparison,"isGtField") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# > #getFieldExpression(whereNode, arguments.Convention, 1)#
							
							<!--- isLte --->
							<cfelseif compareNocase(whereNode.comparison,"isLte") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# <= 
									<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="##arguments.Query.getValue(#whereNode.value#)##" /]]
									<cfelse>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="##arguments.Query.getValue(#whereNode.value#)##" /]]
									</cfif>
							
							<!--- isLteField --->
							<cfelseif compareNocase(whereNode.comparison,"isLteField") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# <= #getFieldExpression(whereNode, arguments.Convention, 1)#
							
							<!--- isLt --->
							<cfelseif compareNocase(whereNode.comparison,"isLt") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# < 
									<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="##arguments.Query.getValue(#whereNode.value#)##" /]]
									<cfelse>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="##arguments.Query.getValue(#whereNode.value#)##" /]]
									</cfif>
							
							<!--- isLtField --->
							<cfelseif compareNocase(whereNode.comparison,"isLtField") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# < #getFieldExpression(whereNode, arguments.Convention, 1)#
							
							<!--- isLike --->
							<cfelseif compareNocase(whereNode.comparison,"isLike") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# LIKE								
									<cfif compareNocase(whereNode.mode,"Anywhere") is 0>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+2)#" value="%##arguments.Query.getValue(#whereNode.value#)##%" /]]
									<cfelseif compareNocase(whereNode.mode,"Left") is 0>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+1)#" value="##arguments.Query.getValue(#whereNode.value#)##%" /]]
									<cfelseif compareNocase(whereNode.mode,"Right") is 0>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+1)#" value="%##arguments.Query.getValue(#whereNode.value#)##" /]]
									<cfelseif compareNocase(whereNode.mode,"All") is 0>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="##arguments.Query.getValue(#whereNode.value#)##" /]]
									</cfif>
							
							<!--- isNotLike --->
							<cfelseif compareNocase(whereNode.comparison,"isNotLike") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# NOT LIKE
									<cfif compareNocase(whereNode.mode,"Anywhere") is 0>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+2)#" value="%##arguments.Query.getValue(#whereNode.value#)##%" /]]
									<cfelseif compareNocase(whereNode.mode,"Left") is 0>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+1)#" value="##arguments.Query.getValue(#whereNode.value#)##%" /]]
									<cfelseif compareNocase(whereNode.mode,"Right") is 0>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#min(getMaxIntegerLength(),arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+1)#" value="%##arguments.Query.getValue(#whereNode.value#)##" /]]
									<cfelseif compareNocase(whereNode.mode,"All") is 0>
										[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="##arguments.Query.getValue(#whereNode.value#)##" /]]
									</cfif>
							
							<!--- isIn --->
							<cfelseif compareNocase(whereNode.comparison,"isIn") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# IN ( 
									<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
										[[cfif Len(Trim(arguments.Query.getValue(#whereNode.values#)))]]
											[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="##arguments.Query.getValue(#whereNode.values#)##" list="yes" /]]
										[[cfelse]]
											[[cfqueryparam null="yes" /]]
										[[/cfif]]
									<cfelse>
										[[cfif Len(Trim(arguments.Query.getValue(#whereNode.values#)))]]
											[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="##arguments.Query.getValue(#whereNode.values#)##" list="yes" /]]
										[[cfelse]]
											[[cfqueryparam null="yes" /]]
										[[/cfif]]
									</cfif>
								)
							
							<!--- isNotIn --->
							<cfelseif compareNocase(whereNode.comparison,"isNotIn") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# NOT IN ( 
									<cfif NOT arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length>
										[[cfif Len(Trim(arguments.Query.getValue(#whereNode.values#)))]]
											[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="##arguments.Query.getValue(#whereNode.values#)##" list="yes" /]]
										[[cfelse]]
											[[cfqueryparam null="yes" /]]
										[[/cfif]]
									<cfelse>
										[[cfif Len(Trim(arguments.Query.getValue(#whereNode.values#)))]]
											[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" maxlength="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#" value="##arguments.Query.getValue(#whereNode.values#)##" list="yes" /]]
										[[cfelse]]
											[[cfqueryparam null="yes" /]]
										[[/cfif]]
									</cfif>
								)
							
							<!--- isNull --->
							<cfelseif compareNocase(whereNode.comparison,"isNull") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# IS NULL
							
							<!--- isNotNull --->
							<cfelseif compareNocase(whereNode.comparison,"isNotNull") is 0>
								#getFieldExpression(whereNode, arguments.Convention)# IS NOT NULL								
						</cfif>	
					<cfelse>
						<!--- just output it --->
						#UCASE(whereNode)#
					</cfif>
					
				</cfloop>
			</cfif>
		</cfsavecontent>
		
		<cfreturn result />		
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
	
	<cffunction name="getHash" access="private" hint="I get a hash of the data in this query" output="false" returntype="any" _returntype="string">
		<cfreturn hash(variables.initData.objectAlias & variables.instance.objectSignatures & arrayToString(variables.where.getWhereCommands()) & variables.initData.queryAlias & structToString(variables.instance)) />
	</cffunction>
	
	<cffunction name="structToString" access="private" hint="I get a string of the data in this structure (assuming only arrays, structs and strings are contained within)" output="false" returntype="any" _returntype="string">
		<cfargument name="struct" hint="I am the struct to convert to a string" required="yes" type="any" _type="struct" />
		<cfset var keys = StructKeyArray(arguments.struct) />
		<cfset var x = 0 />
		<cfset var result = "" />
		<cfset var value = "" />
		<cfset ArraySort(keys, "text") />

		<cfloop from="1" to="#ArrayLen(keys)#" index="x">
			<cfset value = arguments.struct[keys[x]] />
					
			<cfif IsArray(value)>
				<cfset result = result & arrayToString(value) />
				
			<cfelseif IsObject(value)>
				<cfset result = result & arrayToString(value.getWhereCommands()) />
			
			<cfelseif IsStruct(value)>
				<cfset result = result & structToString(value) />
			
			<cfelse>
				<cfset result = result & value />
				
			</cfif>
		</cfloop>
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="arrayToString" access="private" hint="I get a string of the data in this array (assuming only arrays, structs and strings are contained within)" output="false" returntype="any" _returntype="string">
		<cfargument name="array" hint="I am the struct to convert to a string" required="yes" type="any" _type="array" />
		<cfset var x = 0 />
		<cfset var result = "" />
		<cfset var value = "" />
			
		<cfloop from="1" to="#ArrayLen(arguments.array)#" index="x">
			<cfset value = arguments.array[x] />
			
			<cfif IsArray(value)>
				<cfset result = result & arrayToString(value) />
				
			<cfelseif IsStruct(value)>
				<cfset result = result & structToString(value) />
			
			<cfelse>
				<cfset result = result & value />
				
			</cfif>
			
		</cfloop>
		
		<cfreturn result />
	</cffunction>
	
	<!--- addValue --->
	<cffunction name="addValue" access="package" hint="I add a value to the array of values" output="false" returntype="any" _returntype="numeric">
		<cfargument name="value" hint="I am the value to add" required="yes" type="any" _type="any" />
		<cfset ArrayAppend(variables.values, arguments.value) />
		<cfreturn ArrayLen(variables.values) />
	</cffunction>
	
	<!--- addQueryCommand --->
	<cffunction name="addQueryCommand" access="private" hint="I add a command to the query commands array." output="false" returntype="void">
		<cfargument name="params" hint="I am the arguments to pass" required="yes" type="struct" />
		<cfargument name="method" hint="I am the name of the method to call" required="yes" type="string" />
		<cfset ArrayAppend(variables.instance.queryCommands, arguments) />
	</cffunction>
	
	<!--- addWhereCommand
	<cffunction name="addWhereCommand" access="package" hint="I add a command to the where commands array." output="false" returntype="void">
		<cfargument name="params" hint="I am the arguments to pass" required="yes" type="struct" />
		<cfargument name="method" hint="I am the name of the method to call" required="yes" type="string" />
		<cfset ArrayAppend(variables.instance.whereCommands, arguments) />
	</cffunction> --->
	
	<!--- addOrderCommand --->
	<cffunction name="addOrderCommand" access="package" hint="I add a command to the order commands array." output="false" returntype="void">
		<cfargument name="params" hint="I am the arguments to pass" required="yes" type="struct" />
		<cfargument name="method" hint="I am the name of the method to call" required="yes" type="string" />
		<cfset ArrayAppend(variables.instance.orderCommands, arguments) />
	</cffunction>
	
	<!--- hasJoins --->
	<cffunction name="hasJoins" access="public" hint="I indicate if this object is joined to any others." output="false" returntype="any" _returntype="boolean">
		<cfreturn arrayLen(variables.whereCommands) />
	</cffunction>
	
	<!--- setFieldAlias --->
	<cffunction name="setFieldAlias" access="public" hint="I set an alias on the field from the named object." output="false" returntype="any" _returntype="reactor.query.query">
		<cfargument name="objectAlias" hint="I am the alias of the object that the alias is being set for." required="yes" type="any" _type="string" />
		<cfargument name="currentAlias" hint="I am current field alias." required="yes" type="any" _type="string" />
		<cfargument name="newAlias" hint="I am new field alias to use." required="yes" type="any" _type="string" />
		
		<cfset addQueryCommand(arguments, "setFieldAlias") />
		
		<cfreturn this />
	</cffunction>
	
	<!--- returnObjectFields --->
	<cffunction name="returnObjectFields" access="public" hint="I specify a particular object from which all fields (or the spcified list of fields) should be returned. When this or returnObjectField() is first called they cause only the specified column(s) to be returned.  Additional columns can be added with multiple calls to these functions." output="false" returntype="any" _returntype="reactor.query.query">
		<cfargument name="objectAlias" hint="I am the object alias that is being searched for." required="yes" type="any" _type="string" />
		<cfargument name="fieldAliasList" hint="I am an optiona list of specific field aliass to return." required="no" type="any" _type="string" default="" />
		
		<cfset addQueryCommand(arguments, "returnObjectFields") />
		
		<cfreturn this />
	</cffunction>
	
	<!--- returnObjectField --->
	<cffunction name="returnObjectField" access="public" hint="I specify a particular field a query should return.  When this or returnObjectFields() is first called they cause only the specified column(s) to be returned.  Additional columns can be added with multiple calls to these functions." output="false" returntype="any" _returntype="reactor.query.query">
		<cfargument name="objectAlias" hint="I am the object alias that is being searched for." required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the alias of the field." required="yes" type="any" _type="string" />
		
		<cfset addQueryCommand(arguments, "returnObjectField") />
		
		<cfreturn this />
	</cffunction>
	
	<!--- setFieldPrefix --->
	<cffunction name="setFieldPrefix" access="public" hint="I I set a prefix prepended to all fields returned from the named object." output="false" returntype="void">
		<cfargument name="objectAlias" hint="I am the alias of the object that the prefix is being added to." required="yes" type="any" _type="string" />
		<cfargument name="prefix" hint="I am the prefix to prepend." required="yes" type="any" _type="string" />
		
		<cfset addQueryCommand(arguments, "setFieldPrefix") />
	</cffunction>
	
	<!--- setFieldExpression --->
	<cffunction name="setFieldExpression" access="public" hint="I am used to modify the value of a field when it's selected." output="false" returntype="any" _returntype="reactor.query.query">
		<cfargument name="objectAlias" hint="I am the object alias that is being searched for." required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the alias of the field." required="yes" type="any" _type="string" />
		<cfargument name="expression" hint="I am the expression to add replace the field with." required="yes" type="any" _type="string" />
		<cfargument name="cfDataType" hint="I am the cfsql data type to use." required="no" type="any" _type="string" />
		
		<cfset addQueryCommand(arguments, "setFieldExpression") />
		
		<cfreturn this />
	</cffunction>
	
	<!--- join --->
	<cffunction name="join" access="public" hint="I am a convenience method which simply calls innerJoin." output="false" returntype="any" _returntype="reactor.query.query">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="any" _type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="any" _type="string" default="#arguments.joinToObjectAlias#" />
		
		<cfset addQueryCommand(arguments, "join") />
		<cfset logObjectSignature(arguments.joinToObjectAlias) />
		<cfreturn this />
	</cffunction>
	
	<!--- innerJoin --->
	<cffunction name="innerJoin" access="public" hint="I create an iuner join from this object to another object via the specified relationship which can be on either object." output="false" returntype="any" _returntype="reactor.query.query">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="any" _type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="any" _type="string" default="#arguments.joinToObjectAlias#" />
		
		<cfset addQueryCommand(arguments, "innerJoin") />
		<cfset logObjectSignature(arguments.joinToObjectAlias) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- leftJoin --->
	<cffunction name="leftJoin" access="public" hint="I create a left join from this object to another object via the specified relationship which can be on either object." output="false" returntype="any" _returntype="reactor.query.query">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="any" _type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="any" _type="string" default="#arguments.joinToObjectAlias#" />
		
		<cfset addQueryCommand(arguments, "leftJoin") />
		<cfset logObjectSignature(arguments.joinToObjectAlias) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- rightJoin --->
	<cffunction name="rightJoin" access="public" hint="I create a right join from this object to another object via the specified relationship which can be on either object." output="false" returntype="any" _returntype="reactor.query.query">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="any" _type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="any" _type="string" default="#arguments.joinToObjectAlias#" />
		
		<cfset addQueryCommand(arguments, "rightJoin") />
		<cfset logObjectSignature(arguments.joinToObjectAlias) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- fullJoin --->
	<cffunction name="fullJoin" access="public" hint="I create a right join from this object to another object via the specified relationship which can be on either object." output="false" returntype="any" _returntype="reactor.query.query">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="any" _type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="any" _type="string" default="#arguments.joinToObjectAlias#" />
		
		<cfset addQueryCommand(arguments, "fullJoin") />
		<cfset logObjectSignature(arguments.joinToObjectAlias) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- maxrows --->
    <cffunction name="setMaxrows" hint="I configure the number of rows returned by the query." access="public" output="false" returntype="void">
		<cfargument name="maxrows" hint="I set the maximum number of rows to return. If -1 all rows are returned." required="yes" type="any" _type="numeric" />
		<cfset variables.maxrows = arguments.maxrows />
		
		<cfset addQueryCommand(arguments, "setMaxrows") />
    </cffunction>
    <cffunction name="getMaxrows" access="public" output="false" returntype="any" _returntype="numeric">
		<cfreturn variables.maxrows />
    </cffunction>
	
	<!--- distinct --->
    <cffunction name="setDistinct" hint="I indicate if only distinct rows should be returned" access="public" output="false" returntype="void">
		<cfargument name="distinct" hint="I indicate if the query should only return distinct matches" required="yes" type="any" _type="boolean" />
		<cfset variables.instance.distinct = arguments.distinct />
		
		<cfset addQueryCommand(arguments, "setDistinct") />
    </cffunction>
    <cffunction name="getDistinct" access="public" output="false" returntype="any" _returntype="boolean">
		<cfreturn variables.instance.distinct />
    </cffunction>
	
	<!--- where --->
    <cffunction name="getWhere" access="public" output="false" returntype="any" _returntype="reactor.query.where">
		<cfreturn variables.where />
    </cffunction>
	<cffunction name="resetWhere" access="public" output="false" returntype="void">
		<cfset variables.where = CreateObject("Component", "reactor.query.where").init(this) />
	</cffunction>
	
	<!--- order --->
    <cffunction name="getOrder" access="public" output="false" returntype="any" _returntype="reactor.query.order">
		<cfreturn variables.order />
    </cffunction>
	<cffunction name="resetOrder" access="public" output="false" returntype="void">
		<cfset variables.order = CreateObject("Component", "reactor.query.order").init(this) />
	</cffunction>
</cfcomponent>
