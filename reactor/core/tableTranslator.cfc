<cfcomponent hint="I am a component which translates a table object into an xml document">

	<cfset variables.Table = 0 />
	<cfset variables.Config = 0 />
	
	<cffunction name="init" access="public" hint="I configure and return the tableTranslator" output="false" returntype="reactor.core.tableTranslator">
		<cfargument name="config" hint="I am a reactor config object" required="yes" type="reactor.bean.config" />
		<cfargument name="name" hint="I am a mapping to the location where objects are created." required="yes" type="string" />
		<cfset var Table = CreateObject("Component", "reactor.core.table").init(arguments.config, arguments.name) />
		<cfset var TableDao = CreateObject("Component", "reactor.data.#arguments.config.getDbType()#.TableDao").init(arguments.config.getDsn()) />
		<cfset TableDao.read(Table) />
		
		<cfset setConfig(arguments.config) />
		<cfset setTable(Table) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getSignature" access="public" hint="I get this table's signature" output="false" returntype="string">
		<cfreturn getXml().table.XmlAttributes.signature />
	</cffunction>
	
	<cffunction name="generateErrorMessages" access="public" hint="I genereate / populate the ErrorMessages.xml file" output="false" returntype="void">
		<cfargument name="pathToErrorFile" hint="I am the path to the ErrorMessages.xml file." required="yes" type="string" />
		<cfset var XmlErrors = "" />
		<cfset var XmlSearchResult = "" />
		<cfset var columns = getTable().getColumns() />
		<cfset var tableNode = 0 />
		<cfset var columnNode = 0 />
		<cfset var errorMessageNode = 0 />
		
		<!--- check to see if the error file exists --->
		<cfif NOT FileExists(pathToErrorFile) > 
			<cfsavecontent variable="XmlErrors">
				<tables />
			</cfsavecontent>
		<cfelse>
			<!--- read the file --->
			<cffile action="read" file="#pathToErrorFile#" variable="XmlErrors" />
			<cfset tableExists = true />
		</cfif>
		
		<!--- parse the xml --->
		<cfset XmlErrors = XmlParse(XmlErrors) />
		
		<!--- insure a node exists for this table --->
		<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getTable().getName()#']") />
		<cfif NOT ArrayLen(XmlSearchResult)>
			<cfset ArrayAppend(XmlErrors.tables.XmlChildren, XMLElemNew(XmlErrors, "table")) />
			<cfset tableNode = XmlErrors.tables.XmlChildren[ArrayLen(XmlErrors.tables.XmlChildren)] />
			<cfset tableNode.XmlAttributes["name"] = getTable().getName() />
		<cfelse>
			<cfset tableNode = XmlSearchResult[1] />
		</cfif>
		
		<!--- insure a node exists for all columns --->
		<cfloop from="1" to="#ArrayLen(columns)#" index="x">
			<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getTable().getName()#']/column[@name = '#columns[x].getName()#']") />
			<cfif NOT ArrayLen(XmlSearchResult)>
				<cfset ArrayAppend(tableNode.XmlChildren, XMLElemNew(XmlErrors, "column")) />
				<cfset columnNode = tableNode.XmlChildren[ArrayLen(tableNode.XmlChildren)] />
				<cfset columnNode.XmlAttributes["name"] = columns[x].getName() />
			<cfelse>
				<cfset columnNode = XmlSearchResult[1] />
			</cfif>
			
			<!--- insure that all applicable error messages have been created for this columnNode --->
			<cfswitch expression="#columns[x].getDataType()#">
				<cfcase value="binary">
					<!--- required validation error message --->
					<cfif NOT columns[x].getNullable()>
						<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getTable().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'notProvided']") />
						<cfif NOT ArrayLen(XmlSearchResult)>
							<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
							<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
							<cfset errorMessageNode.XmlAttributes["name"] = "notProvided" />
							<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field is required but was not provided." />
						</cfif>
					</cfif>
					
					<!--- datatype validate error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getTable().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'invalidType']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidType" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field must be true or false." />
					</cfif>
					
					<!--- size validataion error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getTable().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'invalidLength']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidLength" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field is too long.  This field must be no more than #columns[x].getLength()# bytes long." />
					</cfif>
				</cfcase>
				<cfcase value="boolean">
					<!--- required validation error message --->
					<cfif NOT columns[x].getNullable()>
						<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getTable().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'notProvided']") />
						<cfif NOT ArrayLen(XmlSearchResult)>
							<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
							<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
							<cfset errorMessageNode.XmlAttributes["name"] = "notProvided" />
							<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field is required but was not provided." />
						</cfif>
					</cfif>
					
					<!--- datatype validate error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getTable().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'invalidType']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidType" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field must be a true or false value." />
					</cfif>
				</cfcase>
				<cfcase value="date">
					<!--- required validation error message --->
					<cfif NOT columns[x].getNullable()>
						<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getTable().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'notProvided']") />
						<cfif NOT ArrayLen(XmlSearchResult)>
							<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
							<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
							<cfset errorMessageNode.XmlAttributes["name"] = "notProvided" />
							<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field is required but was not provided." />
						</cfif>
					</cfif>
					
					<!--- datatype validate error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getTable().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'invalidType']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidType" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field must be a date value." />
					</cfif>
				</cfcase>
				<cfcase value="numeric">
					<!--- required validation error message --->
					<cfif NOT columns[x].getNullable()>
						<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getTable().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'notProvided']") />
						<cfif NOT ArrayLen(XmlSearchResult)>
							<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
							<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
							<cfset errorMessageNode.XmlAttributes["name"] = "notProvided" />
							<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field is required but was not provided." />
						</cfif>
					</cfif>
					
					<!--- datatype validate error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getTable().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'invalidType']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidType" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field must be a numeric value." />
					</cfif>
				</cfcase>
				<cfcase value="string">
					<!--- required validation error message --->
					<cfif NOT columns[x].getNullable()>
						<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getTable().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'notProvided']") />
						<cfif NOT ArrayLen(XmlSearchResult)>
							<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
							<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
							<cfset errorMessageNode.XmlAttributes["name"] = "notProvided" />
							<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field is required but was not provided." />
						</cfif>
					</cfif>
					
					<!--- datatype validate error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getTable().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'invalidType']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidType" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field must be a string value." />
					</cfif>
					
					<!--- size validataion error message --->
					<cfset XmlSearchResult = XmlSearch(XmlErrors, "/tables/table[@name = '#getTable().getName()#']/column[@name = '#columns[x].getName()#']/errorMessage[@name = 'invalidLength']") />
					<cfif NOT ArrayLen(XmlSearchResult)>
						<cfset ArrayAppend(columnNode.XmlChildren, XMLElemNew(XmlErrors, "errorMessage")) />
						<cfset errorMessageNode = columnNode.XmlChildren[ArrayLen(columnNode.XmlChildren)] />
						<cfset errorMessageNode.XmlAttributes["name"] = "invalidLength" />
						<cfset errorMessageNode.XmlAttributes["message"] = "The #columns[x].getName()# field is too long.  This field must be no more than #columns[x].getLength()# characters long." />
					</cfif>
				</cfcase>
			</cfswitch>
		</cfloop>
		
		<!--- format the xml and write it back to the ErrorFile --->
		<cflock type="exclusive" timeout="30">
			<cffile action="write" file="#pathToErrorFile#" output="#FormatErrorXml(XmlErrors)#" />
		</cflock>
	</cffunction>
	
	<cffunction name="FormatErrorXml" access="public" hint="I format the Xml Errors doc to make it more easily human readable." output="false" returntype="string">
		<cfargument name="XmlErrors" hint="I am the xml error document to format." required="yes" type="xml" />
		<cfset arguments.XmlErrors = ToString(arguments.XmlErrors) />
		
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*<table ", chr(13) & chr(10) & chr(9) & "<table ", "all") />
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*</table>", chr(13) & chr(10) & chr(9) & "</table>", "all") />
		
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*<column ", chr(13) & chr(10) & chr(9) & chr(9) & "<column ", "all") />
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*</column>", chr(13) & chr(10) & chr(9) & chr(9) & "</column>", "all") />
		
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*<errorMessage ", chr(13) & chr(10) & chr(9) & chr(9) & chr(9) & "<errorMessage ", "all") />
		
		<cfset arguments.XmlErrors = ReReplace(arguments.XmlErrors, "[\s]*</tables>", chr(13) & chr(10) & "</tables>", "all") />
		
		<cfreturn arguments.XmlErrors />
	</cffunction>
	
	<cffunction name="getXml" access="public" hint="I return this table expressed as an XML document" output="false" returntype="string">
		<cfset var structure = 0 />
		<cfset var Table = getTable() />
		<cfset var Columns = Table.getColumns() />
		<cfset var Column = 0 />
		<cfset var ForeignKeys = Table.getForeignKeys() />
		<cfset var ForeignKey = 0 />
		<cfset var ReferencingKeys = Table.getReferencingKeys() />
		<cfset var ReferencingKey = 0 />
		<cfset var SuperTables = 0 />
		<cfset var Relationships = 0 />
		<cfset var Relationship = 0 />
		<cfset var columnList = "" />
		<cfset var exists = false />
		<cfset var x = 0 />
		<cfset var y = 0 />
		
		<cfsavecontent variable="structure">
			<cfoutput>
				<table
					name="#Table.getName()#"
					dbType="#getConfig().getDbType()#"
					
					baseToSuper="#Table.getBaseToSuper()#"
					baseDaoSuper="#Table.getBaseDaoSuper()#"
					baseGatewaySuper="#Table.getBaseGatewaySuper()#"
					baseRecordSuper="#Table.getBaseRecordSuper()#"
					baseBeanSuper="#Table.getBaseBeanSuper()#"
					
					customToSuper="#Table.getCustomToSuper()#"
					customDaoSuper="#Table.getCustomDaoSuper()#"
					customGatewaySuper="#Table.getCustomGatewaySuper()#"
					customRecordSuper="#Table.getCustomRecordSuper()#"
					customBeanSuper="#Table.getCustomBeanSuper()#">
					
					<columns>
						<cfloop from="1" to="#ArrayLen(Columns)#" index="x">
							<cfset Column = Columns[x] />
							<cfset exists = ListFindNoCase(columnList, Column.getName()) />
							<column name="#Column.getName()#"
								type="#Column.getDataType()#"
								cfSqlType="#Column.getCfSqlType()#"
								identity="#Column.getIdentity()#"
								nullable="#Column.getNullable()#"
								length="#Column.getLength()#"
								default="#XMLFormat(Column.getDefault())#"
								defaultExpression="#XMLFormat(Column.getDefaultExpression())#"
								primaryKey="#Column.getPrimaryKey()#" />
							<cfif NOT exists>
								<cfset columnList = ListAppend(columnList, Column.getName()) />
							</cfif>
						</cfloop>
					</columns>
					
					<cfif Table.hasSuperTable()>
						<!-- super tables sorted forward -->
						<cfset SuperTables = Table.getSuperTables() />
						<superTables sort="backward">
							<cfloop from="#ArrayLen(SuperTables)#" to="1" step="-1" index="x">
								<superTable fromTable="#SuperTables[x].getFromTableName()#"
									toTable="#SuperTables[x].getToTableName()#">
									<relationship>
										<cfset Relationships = SuperTables[x].getRelationships() />
										<cfloop from="1" to="#ArrayLen(Relationships)#" index="y">
											<cfset Relationship = Relationships[y] />
											<column name="#Relationship.getFromColumnName()#"
												referencedColumn="#Relationship.getToColumnName()#" />
										</cfloop>
									</relationship>
									<columns>
										<cfset columns = SuperTables[x].getColumns() />
										<cfloop from="1" to="#ArrayLen(columns)#" index="x">
											<cfset Column = columns[x] />
											<cfset exists = ListFindNoCase(columnList, Column.getName()) />
											<column name="#Column.getName()#"
												type="#Column.getDataType()#"
												cfSqlType="#Column.getCfSqlType()#"
												nullable="#Column.getNullable()#"
												length="#Column.getLength()#"
												default="#XMLFormat(Column.getDefault())#"
												defaultExpression="#XMLFormat(Column.getDefaultExpression())#"
												overridden="#Iif(exists, DE('true'), DE('false'))#" />
											<cfif NOT exists>
												<cfset columnList = ListAppend(columnList, Column.getName()) />
											</cfif>
										</cfloop>
									</columns>
								</superTable>
							</cfloop>
						</superTables>
						
						<superTables />
					</cfif>
					
					<foreignKeys>
						<cfloop from="1" to="#ArrayLen(ForeignKeys)#" index="x">
							<cfset ForeignKey = ForeignKeys[x] />
							<foreignKey name="#ForeignKey.getName()#"
								table="#ForeignKey.getToTableName()#"
								remoteRecordSuper="#Table.getRelationshipRecordSuper(ForeignKey.getToTableName())#">
								<!--- recordType="#getObjectName("Record", ForeignKey.getToTableName())#" --->
								<cfset RelationShips = ForeignKey.getRelationships() />
								<cfloop from="1" to="#ArrayLen(Relationships)#" index="y">
									<column name="#RelationShips[y].getFromColumnName()#"
										referencedColumn="#RelationShips[y].getToColumnName()#" />
								</cfloop>
							</foreignKey>
						</cfloop>
					</foreignKeys>
					
					<referencingKeys>
						<cfloop from="1" to="#ArrayLen(ReferencingKeys)#" index="x">
							<cfset ReferencingKey = ReferencingKeys[x] />
							<referencingKey name="#ReferencingKey.getName()#"
								table="#ReferencingKey.getFromTableName()#">
								<!--- recordType="#getObjectName("Record", ForeignKey.getToTableName())#" --->
								<cfset RelationShips = ReferencingKey.getRelationships() />
								<cfloop from="1" to="#ArrayLen(Relationships)#" index="y">
									<column name="#RelationShips[y].getFromColumnName()#"
										referencedColumn="#RelationShips[y].getToColumnName()#" />
								</cfloop>
							</referencingKey>
						</cfloop>
					</referencingKeys>
				</table>
			</cfoutput>
		</cfsavecontent>
		
		<cfset structure = XmlParse(structure) />
		<cfset signature = Hash(structure) />
		<cfset structure.XmlRoot.XmlAttributes["signature"] = signature />
		
		<!--- create the 'forward' supertable --->
		<!---
			You, who are reading this comment, may wonder what the heck I'm doing.  The answer is this:  
			1) CF's XSL parser is a 1.0 version, not 2.0.  Thus, there are a LOT of missing xpath functions such 
			as reverse().  
			2) There are some cases where I need to go through the hierarchy of "super" tables forwards and some
			times where I need to go through them backwards. (hence the sort attribute).  I tried all sorts of other
			options, but this seemed to be the best option.
		--->
		<cfif Table.hasSuperTable()>
			<cfset structure.table.superTables[2] = Duplicate(structure.table.superTables[1]) />
			<cfset structure.table.superTables[2].XmlAttributes.sort = 'forward' />
			<cfset y = 1 />
			<cfloop from="#ArrayLen(structure.table.superTables[1].superTable)#" to="1" step="-1" index="x">
				<cfset structure.table.superTables[2].XmlChildren[x] = Duplicate(structure.table.superTables[1].XmlChildren[y]) />
				<cfset y = y + 1/>
			</cfloop>
		</cfif>
		
		<cfreturn structure />
	</cffunction>
	
	<cffunction name="getSuperTableXml" access="private" hint="I return an XML fragement describing the super table structure." output="false" returntype="string">
		<cfargument name="SuperTable" hint="I am the supertable to return XML for." required="yes" type="reactor.core.SuperTable" />
		<cfset var xml = "" />
		<cfset var Columns = arguments.SuperTable.getColumns() />
		<cfset var Column = 0 />
		<cfset var Relationships = arguments.SuperTable.getRelationships() />
		<cfset var Relationship = 0 />
		<cfset var x = 0 />
		
		<cfsavecontent variable="xml">
			<cfoutput>
				<superTable name="#arguments.SuperTable.getToTablename()#">
					<relationship>
						<cfloop from="1" to="#ArrayLen(Relationships)#" index="x">
							<cfset Relationship = Relationships[x] />
							<column name="#Relationship.getFromColumnName()#"
								referencedColumn="#Relationship.getToColumnName()#" />
						</cfloop>
					</relationship>
					
					<columns>
						<cfloop from="1" to="#ArrayLen(Columns)#" index="x">
							<cfset Column = Columns[x] />
							<column name="#Column.getName()#"
								type="#Column.getDataType()#"
								cfSqlType="#Column.getCfSqlType()#"
								nullable="#Column.getNullable()#"
								length="#Column.getLength()#"
								default="#XMLFormat(Column.getDefault())#"
								defaultExpression="#XMLFormat(Column.getDefaultExpression())#" />
						</cfloop>
					</columns>
					<cfif SuperTable.hasSuperTable()>
						#getSuperTableXml(SuperTable.getSuperTable())#
					</cfif>
				</superTable>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn xml />
	</cffunction>
	
	<!--- table --->
    <cffunction name="setTable" access="private" output="false" returntype="void">
       <cfargument name="table" hint="I am the table being translated" required="yes" type="reactor.core.table" />
       <cfset variables.table = arguments.table />
    </cffunction>
    <cffunction name="getTable" access="private" output="false" returntype="reactor.core.table">
       <cfreturn variables.table />
    </cffunction>
	
	<!--- config --->
    <cffunction name="setConfig" access="public" output="false" returntype="void">
       <cfargument name="config" hint="I am the config object used to configure reactor" required="yes" type="reactor.bean.config" />
       <cfset variables.config = arguments.config />
    </cffunction>
    <cffunction name="getConfig" access="public" output="false" returntype="reactor.bean.config">
       <cfreturn variables.config />
    </cffunction>
</cfcomponent>