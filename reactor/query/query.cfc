<cfcomponent hint="I am a component used to define ad-hoc queries used throughout Reactor.">

	<cfset variables.where = 0 />
	<cfset variables.order = CreateObject("Component", "reactor.query.order").init(this) />
	<cfset variables.maxrows = -1 />
	<cfset variables.page = 0>
	<cfset variables.rows = 0 />
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

   	<cfset setMaxIntegerLength() />

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
	<cffunction name="setValues" access="public" hint="I return a specific value for the query" output="false" returntype="void" _returntype="void">
		<cfargument name="values" hint="I am the values to set" required="yes" type="any" _type="array" />
		<cfset variables.values = arguments.values />
	</cffunction>


	<!--- Pagination Settings --->
	
	<cffunction name="setPagination" access="public" hint="Sets how this query should be paginated" output="false" returntype="void" _returntype="void">
		<cfargument name="page" hint="the page to retrieve from the query" required="yes" type="numeric" _type="numeric">
		<cfargument name="rows" hint="the page to retrieve from the query" required="yes" type="numeric" _type="numeric">
			<cfset variables.page = arguments.page>
			<cfset variables.rows = arguments.rows>
	</cffunction>


	<cffunction name="getPagination" access="public" hint="Returns the pagination settings" output="false" returntype="string" _returntype="string">
		<cfargument name="setting" hint="the paginaation setting to return" required="yes" type="string" _type="string">
			<cfif setting EQ "page">
				<cfreturn variables.page>
			<cfelseif setting EQ "rows">
				<cfreturn variables.rows>
			</cfif>
	</cffunction>

	<!--- parse --->
	<cffunction name="getQueryFile" access="public" hint="I render the query data to a physical query on disk and return the path to that file.  If the exact query already exists then I simply return that file's path." output="false" returntype="any" _returntype="string">
		<cfargument name="Config" hint="I am the Config object." required="yes" type="any" _type="reactor.config.config" />
		<cfargument name="Convention" hint="I am the Convention object to use when rendering the query." required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfargument name="type" hint="I am the type of query (select or delete)." required="yes" type="any" _type="string" />
		<cfset var queryFileName = "/reactor/project/#arguments.Config.getProject()#/Queries/" &"_" & getHash(arguments.Config.getType(),arguments.type) & ".cfm" />
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
  			<cflock type="exclusive" timeout="30">
	  			<cfdirectory action="create" directory="#queryDirectory#" />
  			</cflock>
			</cfif>


			<!--- write the file to disk --->
			<cflock type="exclusive" timeout="30">
  			<cffile action="write" file="#expandPath(queryFileName)#" output="#Query#" nameconflict="overwrite" />
			</cflock>

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

	<cffunction name="renderDelete" access="public" hint="I render a delete query" output="false" returntype="any" _returntype="string">
		<cfargument name="Query" hint="I the query to render. " required="yes" type="any" _type="reactor.query.render.query" />
		<cfargument name="Convention" hint="I am the Convention object to use when rendering the query." required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfset var result = "" />

		<cfset result = "DELETE FROM
			#arguments.Query.getDeleteAsString(arguments.Convention)#
			#renderWhereForDelete(arguments.Query, arguments.Convention)#
		"/>
		<!--- make this valid cfml --->
		<cfset result = Replace(result, "[[", "<", "all") />
		<cfset result = Replace(result, "]]", ">", "all") />
		<!--- return the query --->
		<cfreturn result />
	</cffunction>

	<cffunction name="renderSelect" access="public" hint="I render a select query" output="false" returntype="any" _returntype="string">
		<cfargument name="Query" hint="I the query to render. " required="yes" type="any" _type="reactor.query.render.query" />
		<cfargument name="Convention" hint="I am the Convention object to use when rendering the query." required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfset var result = "" />
		<cfset var where = arguments.Query.getWhere().getWhere() />
		<cfset var order = arguments.Query.getOrder().getOrder() />
		<cfset var whereNode = 0 />
		<cfset var orderNode = 0 />
		<cfset var x = 0 />
		<cfset var buf = createObject("JAVA", "java.lang.StringBuffer").init()>

		<cfscript>
		buf.append("SELECT ");

			// distinct
			if (arguments.Query.getDistinct()) {
				buf.append("DISTINCT ");
			}

			// columns
			buf.append(arguments.Query.getSelectAsString(Convention));
			buf.append(" ");

			buf.append("FROM ");

			buf.append(arguments.Query.getFromAsString(Convention));
			buf.append(" ");

			buf.append(renderWhere(arguments.Query, arguments.Convention));
			buf.append(" ");

			if (ArrayLen(order)) {
				buf.append("ORDER BY ");

				// loop over all of the order-bys and render them out
				for(x = 1; x lte ArrayLen(order); x = x+1) {
					// get the arguments for this expression
					orderNode = order[x];

					buf.append(getFieldExpression(orderNode, arguments.Convention));
					buf.append(" ");
					buf.append(UCASE(orderNode.direction));
					buf.append(" ");

					if (x IS NOT ArrayLen(order)) {
						buf.append(", ");
					}
				}
			}
		</cfscript>

		<cfset result = buf.toString()>

		<!--- make this valid cfml --->
		<cfset result = Replace(result, "[[", "<", "all") />
		<cfset result = Replace(result, "]]", ">", "all") />

		<!--- return the query --->
		<cfreturn result />
	</cffunction>

	<cffunction name="renderWhere" access="public" hint="I render a where clause" output="false" returntype="any" _returntype="string">
		<cfargument name="Query" hint="I the query to render. " required="yes" type="any" _type="reactor.query.render.query" />
		<cfargument name="Convention" hint="I am the Convention object to use when rendering the query." required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfset var result = "" />
		<cfset var where = arguments.Query.getWhere().getWhere() />
		<cfset var whereNode = 0 />
		<cfset var x = 0 />
		<cfset var buf = createObject("JAVA", "java.lang.StringBuffer").init() />
        <cfset var scale = "" />
        <cfset var maxlength = "" />
        <cfset var maxlengthwithwildcard = "" />

		<cfscript>
			if (ArrayLen(where)) {
				buf.append('WHERE ');

				// loop over all of the expressions and render them out
				for (x = 1; x lte ArrayLen(where); x = x+1) {
					// get the arguments for this expression
					whereNode = where[x];

					// if the node is a structure output it accordingly.  otherwise, just output it.
					if (IsStruct(whereNode)) {
						// render the expression
            // scale is an optional parameter to cfqueryparam. So set scale to the entire parameter clause here and
            // reuse throughout this function
            // i.e. scale="2"
             if ( arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).scale gt "0" ) {
             	scale = "scale=""#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).scale#""" ;
             } else {
              	scale = "";
             }
            // maxlength is an optional parameter to cfqueryparam. So set maxlength to the entire parameter clause here
            if ( arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length  gt "0" ) {
             	maxlength = "maxlength=""#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#""" ;
            	// add room for wildcards
              maxlengthwithwildcard = min( getMaxIntegerLength(),
                       arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+2 );
             	maxlengthwithwildcard = "maxlength=""#maxlengthwithwildcard#""" ;
             } else {
               	maxlength = "";
                maxlengthwithwildcard = "";
             }

							// isBetween
							if (compareNocase(whereNode.comparison,"isBetween") is 0) {
								buf.append(getFieldExpression(whereNode, arguments.Convention)).append(" ");
									buf.append('BETWEEN [[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#"  #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value1#)##" /]] ');
									buf.append('AND [[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value2#)##" /]] ');

							// isBetweenFields
							} else if (compareNocase(whereNode.comparison,"isBetweenFields") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# ');
								buf.append('BETWEEN #getFieldExpression(whereNode, arguments.Convention, 1)# ');
								buf.append('AND #getFieldExpression(whereNode, arguments.Convention, 2)# ');


							// isEqual
							} else if (compareNocase(whereNode.comparison,"isEqual") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# = ');
								buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#"  #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');

							// isEqualField
							} else if (compareNocase(whereNode.comparison,"isEqualField") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# = #getFieldExpression(whereNode, arguments.Convention, 1)# ');

							// isNotEqual
							} else if (compareNocase(whereNode.comparison,"isNotEqual") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# != ');
								buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#"  #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');

							// isNotEqualField
							} else if (compareNocase(whereNode.comparison,"isNotEqualField") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# != #getFieldExpression(whereNode, arguments.Convention, 1)# ');

							// isGte
							} else if (compareNocase(whereNode.comparison,"isGte") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# >= ');
									buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#"  #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');

							// isGteField
							} else if (compareNocase(whereNode.comparison,"isGteField") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# >= #getFieldExpression(whereNode, arguments.Convention, 1)# ');

							// isGt
							} else if (compareNocase(whereNode.comparison,"isGt") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# > ');
								buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#"  #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');

							// isGtField
							} else if (compareNocase(whereNode.comparison,"isGtField") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# > #getFieldExpression(whereNode, arguments.Convention, 1)# ');

							// isLte
							} else if (compareNocase(whereNode.comparison,"isLte") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# <= ');
								buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#"  #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');

							// isLteField
							} else if (compareNocase(whereNode.comparison,"isLteField") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# <= #getFieldExpression(whereNode, arguments.Convention, 1)# ');

							// isLt
							} else if (compareNocase(whereNode.comparison,"isLt") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# < ');
								buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#"  #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');

							// isLtField
							} else if (compareNocase(whereNode.comparison,"isLtField") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# < #getFieldExpression(whereNode, arguments.Convention, 1)# ');

							// isLike
							} else if (compareNocase(whereNode.comparison,"isLike") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# LIKE ');
									if (compareNocase(whereNode.mode,"Anywhere") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="%##arguments.Query.getValue(#whereNode.value#)##%" /]] ');
									} else if (compareNocase(whereNode.mode,"Left") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="##arguments.Query.getValue(#whereNode.value#)##%" /]] ');
									} else if (compareNocase(whereNode.mode,"Right") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="%##arguments.Query.getValue(#whereNode.value#)##" /]] ');
									} else if (compareNocase(whereNode.mode,"All") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlength#  #scale# value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');
									}
									
							// isLikeNoCase
							} else if (compareNocase(whereNode.comparison,"isLikeNoCase") is 0) {
								buf.append('lower(#getFieldOrExpressionForDelete(whereNode, arguments.Convention)#) LIKE ');
									if (compareNocase(whereNode.mode,"Anywhere") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale#  value="%##lcase(arguments.Query.getValue(#whereNode.value#))##%" /]] ');
									} else if (compareNocase(whereNode.mode,"Left") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="##lcase(arguments.Query.getValue(#whereNode.value#))##%" /]] ');
									} else if (compareNocase(whereNode.mode,"Right") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="%##lcase(arguments.Query.getValue(#whereNode.value#)##" /]] ');
									} else if (compareNocase(whereNode.mode,"All") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="##lcase(arguments.Query.getValue(#whereNode.value#))##" /]] ');
									}

							// isNotLike
							} else if (compareNocase(whereNode.comparison,"isNotLike") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# NOT LIKE ');
									if (compareNocase(whereNode.mode,"Anywhere") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#"  #maxlengthwithwildcard# #scale#  value="%##arguments.Query.getValue(#whereNode.value#)##%" /]] ');
									} else if (compareNocase(whereNode.mode,"Left") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#"  #maxlengthwithwildcard# #scale#  value="##arguments.Query.getValue(#whereNode.value#)##%" /]] ');
									} else if (compareNocase(whereNode.mode,"Right") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#"  #maxlengthwithwildcard# #scale#  value="%##arguments.Query.getValue(#whereNode.value#)##" /]] ');
									} else if (compareNocase(whereNode.mode,"All") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#"  #maxlength# #scale#  value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');
									}

							// isIn
							} else if (compareNocase(whereNode.comparison,"isIn") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# IN ( ');
								buf.append('[[cfif Len(Trim(arguments.Query.getValue(#whereNode.values#)))]] ');
								buf.append('	[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" value="##arguments.Query.getValue(#whereNode.values#)##" list="yes" /]] ');
								buf.append('[[cfelse]] ');
								buf.append('	[[cfqueryparam null="yes" /]] ');
								buf.append('[[/cfif]] ');
								buf.append(') ');

							// isNotIn
							} else if (compareNocase(whereNode.comparison,"isNotIn") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# NOT IN ( ');
								buf.append('[[cfif Len(Trim(arguments.Query.getValue(#whereNode.values#)))]] ');
								buf.append('	[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.values#)##" list="yes" /]] ');
								buf.append('[[cfelse]] ');
								buf.append('	[[cfqueryparam null="yes" /]] ');
								buf.append('[[/cfif]] ');
								buf.append(') ');

							// isNull
							} else if (compareNocase(whereNode.comparison,"isNull") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# IS NULL ');

							// isNotNull
							} else if (compareNocase(whereNode.comparison,"isNotNull") is 0) {
								buf.append('#getFieldExpression(whereNode, arguments.Convention)# IS NOT NULL ');
						}
					} else {
						// just output it
						buf.append('#UCASE(whereNode)# ');
					}

				}
			}
		</cfscript>

		<cfreturn buf.toString()/>
	</cffunction>


	<cffunction name="renderWhereForDelete" access="public" hint="I render a where clause for a delete" output="false" returntype="any" _returntype="string">
		<cfargument name="Query" hint="I am the query to render. " required="yes" type="any" _type="reactor.query.render.query" />
		<cfargument name="Convention" hint="I am the Convention object to use when rendering the query." required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfset var result = "" />
		<cfset var where = arguments.Query.getWhere().getWhere() />
		<cfset var whereNode = 0 />
		<cfset var x = 0 />
		<cfset var buf = createObject("JAVA", "java.lang.StringBuffer").init() />
        <cfset var scale = "" />
        <cfset var maxlength = "" />
        <cfset var maxlengthwithwildcard = "" />

		<cfscript>
			if (ArrayLen(where)) {
				buf.append('WHERE ');

				// loop over all of the expressions and render them out
				for (x = 1; x lte ArrayLen(where); x = x+1) {
					// get the arguments for this expression
					whereNode = where[x];

					// if the node is a structure output it accordingly.  otherwise, just output it.
					if (IsStruct(whereNode)) {
						// render the expression

                            // scale is an optional parameter to cfqueryparam. So set scale to the entire parameter clause here and
                            // reuse throughout this function
                            // i.e. scale="2"
                            if ( arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).scale  gt "0" ) {
                            	scale = "scale=""#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).scale#""" ;
                            } else {
                            	scale = "";
                            }
                            // maxlength is an optional parameter to cfqueryparam. So set maxlength to the entire parameter clause here
                            if ( arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length  gt "0" ) {
                            	maxlength = "maxlength=""#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length#""" ;
                            	// add room for wildcards
                                maxlengthwithwildcard = min( getMaxIntegerLength(), arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).length+2 );
             	maxlengthwithwildcard = "maxlength=""#maxlengthwithwildcard#""" ;
                            } else {
                            	maxlength = "";
                                maxlengthwithwildcard = "";
                            }

							// isBetween
							if (compareNocase(whereNode.comparison,"isBetween") is 0) {
								buf.append(getFieldOrExpressionForDelete(whereNode, arguments.Convention)).append(" ");
								buf.append('BETWEEN [[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value1#)##" /]] ');
								buf.append('AND [[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value2#)##" /]] ');

							// isBetweenFields
							} else if (compareNocase(whereNode.comparison,"isBetweenFields") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# ');
								buf.append('BETWEEN #getFieldOrExpressionForDelete(whereNode, arguments.Convention, 1)# ');
								buf.append('AND #getFieldOrExpressionForDelete(whereNode, arguments.Convention, 2)# ');

							// isEqual
							} else if (compareNocase(whereNode.comparison,"isEqual") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# = ');
								buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');

							// isEqualField
							} else if (compareNocase(whereNode.comparison,"isEqualField") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# = #getFieldOrExpressionForDelete(whereNode, arguments.Convention, 1)# ');

							// isNotEqual
							} else if (compareNocase(whereNode.comparison,"isNotEqual") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# != ');
								buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');

							// isNotEqualField
							} else if (compareNocase(whereNode.comparison,"isNotEqualField") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# != #getFieldOrExpressionForDelete(whereNode, arguments.Convention, 1)# ');

							// isGte
							} else if (compareNocase(whereNode.comparison,"isGte") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# >= ');
								buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');

							// isGteField
							} else if (compareNocase(whereNode.comparison,"isGteField") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# >= #getFieldOrExpressionForDelete(whereNode, arguments.Convention, 1)# ');

							// isGt
							} else if (compareNocase(whereNode.comparison,"isGt") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# > ');
								buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');

							// isGtField
							} else if (compareNocase(whereNode.comparison,"isGtField") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# > #getFieldOrExpressionForDelete(whereNode, arguments.Convention, 1)# ');

							// isLte
							} else if (compareNocase(whereNode.comparison,"isLte") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# <= ');
								buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');

							// isLteField
							} else if (compareNocase(whereNode.comparison,"isLteField") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# <= #getFieldOrExpressionForDelete(whereNode, arguments.Convention, 1)# ');

							// isLt
							} else if (compareNocase(whereNode.comparison,"isLt") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# < ');
								buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');

							// isLtField
							} else if (compareNocase(whereNode.comparison,"isLtField") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# < #getFieldOrExpressionForDelete(whereNode, arguments.Convention, 1)# ');

							// isLike
							} else if (compareNocase(whereNode.comparison,"isLike") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# LIKE ');
									if (compareNocase(whereNode.mode,"Anywhere") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale#  value="%##arguments.Query.getValue(#whereNode.value#)##%" /]] ');
									} else if (compareNocase(whereNode.mode,"Left") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="##arguments.Query.getValue(#whereNode.value#)##%" /]] ');
									} else if (compareNocase(whereNode.mode,"Right") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="%##arguments.Query.getValue(#whereNode.value#)##" /]] ');
									} else if (compareNocase(whereNode.mode,"All") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');
									}

							// isLikeNoCase
							} else if (compareNocase(whereNode.comparison,"isLikeNoCase") is 0) {
								buf.append('lower(#getFieldOrExpressionForDelete(whereNode, arguments.Convention)#) LIKE ');
									if (compareNocase(whereNode.mode,"Anywhere") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale#  value="%##lcase(arguments.Query.getValue(#whereNode.value#))##%" /]] ');
									} else if (compareNocase(whereNode.mode,"Left") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="##lcase(arguments.Query.getValue(#whereNode.value#))##%" /]] ');
									} else if (compareNocase(whereNode.mode,"Right") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="%##lcase(arguments.Query.getValue(#whereNode.value#))##" /]] ');
									} else if (compareNocase(whereNode.mode,"All") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="##lcase(arguments.Query.getValue(#whereNode.value#))##" /]] ');
									}
									
							// isNotLike
							} else if (compareNocase(whereNode.comparison,"isNotLike") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# NOT LIKE ');
									if (compareNocase(whereNode.mode,"Anywhere") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="%##arguments.Query.getValue(#whereNode.value#)##%" /]] ');
									} else if (compareNocase(whereNode.mode,"Left") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="##arguments.Query.getValue(#whereNode.value#)##%" /]] ');
									} else if (compareNocase(whereNode.mode,"Right") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="%##arguments.Query.getValue(#whereNode.value#)##" /]] ');
									} else if (compareNocase(whereNode.mode,"All") is 0) {
										buf.append('[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlengthwithwildcard# #scale# value="##arguments.Query.getValue(#whereNode.value#)##" /]] ');
									}

							// isIn
							} else if (compareNocase(whereNode.comparison,"isIn") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# IN ( ');
								buf.append('[[cfif Len(Trim(arguments.Query.getValue(#whereNode.values#)))]] ');
								buf.append('	[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#" #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.values#)##" list="yes" /]] ');
								buf.append('[[cfelse]] ');
								buf.append('	[[cfqueryparam null="yes" /]] ');
								buf.append('[[/cfif]] ');
								buf.append(') ');

							// isNotIn
							} else if (compareNocase(whereNode.comparison,"isNotIn") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# NOT IN ( ');
								buf.append('[[cfif Len(Trim(arguments.Query.getValue(#whereNode.values#)))]] ');
								buf.append('	[[cfqueryparam cfsqltype="#arguments.Query.findObject(whereNode.objectAlias).getField(whereNode.fieldAlias).cfSqlType#"  #maxlength# #scale# value="##arguments.Query.getValue(#whereNode.values#)##" list="yes" /]] ');
								buf.append('[[cfelse]] ');
								buf.append('	[[cfqueryparam null="yes" /]] ');
								buf.append('[[/cfif]] ');
								buf.append(') ');

							// isNull
							} else if (compareNocase(whereNode.comparison,"isNull") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# IS NULL ');

							// isNotNull
							} else if (compareNocase(whereNode.comparison,"isNotNull") is 0) {
								buf.append('#getFieldOrExpressionForDelete(whereNode, arguments.Convention)# IS NOT NULL ');
						}
					} else {
						// just output it
						buf.append('#UCASE(whereNode)# ');
					}

				}
			}
		</cfscript>

		<cfreturn buf.toString()/>
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
		<cfargument name="dbType" _required="true" _type="string">
		<cfargument name="queryType" _required="true" _type="string">
		<cfreturn hash(variables.initData.objectAlias & 
						variables.instance.objectSignatures & 
						arrayToString(variables.where.getWhereCommands()) & 
						variables.initData.queryAlias &
						structToString(variables.instance) &
						arguments.dbType &
						arguments.queryType
					) />
	</cffunction>

	<cffunction name="structToString" access="private" hint="I get a string of the data in this structure (assuming only arrays, structs and strings are contained within)" output="false" returntype="any" _returntype="string">
		<cfargument name="struct" hint="I am the struct to convert to a string" required="yes" type="any" _type="struct" />
		<cfset var keys = StructKeyArray(arguments.struct) />
		<cfset var x = 0 />
		<cfset var result = "" />
		<cfset var value = "" />
		<cfset ArraySort(keys, "text") />

		<cfloop from="1" to="#ArrayLen(keys)#" index="x">
                <cftry>
        			<cfset value = arguments.struct[keys[x]] />
                    <cfcatch type="java.lang.NullPointerException">
                        <cfreturn result />
                    </cfcatch>
                </cftry>

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
	<cffunction name="innerJoin" access="public" hint="I create an inner join from this object to another object via the specified relationship which can be on either object." output="false" returntype="any" _returntype="reactor.query.query">
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
		<cfset variables.instance.orderCommands = ArrayNew(1) />
	</cffunction>

    <!---  maxIntegerLength --->
    <cffunction name="setMaxIntegerLength" access="private" output="false" returntype="void">
      <cfset variables.maxIntegerLength =  createObject('java', 'java.lang.Integer').MAX_VALUE />
    </cffunction>
    <cffunction name="getMaxIntegerLength" access="private" output="false" returntype="any" _returntype="numeric">
	     <cfreturn variables.maxIntegerLength />
    </cffunction>

	<cffunction name="dump">
		<cfdump var="#variables#" /><cfabort>
	</cffunction>
</cfcomponent>
