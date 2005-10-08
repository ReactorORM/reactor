<cfcomponent hint="I am a MSSQL Table Factory.  I am load tables from MSSQL." extends="reactor.core.abstractObjectFactory">
	
	<cffunction name="getReferencingKeys" access="public" hint="I return a query of external table's keys referencing this table." output="false" returntype="query">
		<cfargument name="name" hint="I am the name of the table inspect." required="yes" type="string" />
		<cfset var TimedCache = getTimedCache() />
		<cfset var qReferencingKey = 0 />
		
		<cfif TimedCache.exists("referencingKey_" & arguments.name)>
			<cfset qReferencingKey = TimedCache.getValue("referencingKey_" & arguments.name) />
		<cfelse>
			<cfquery name="qReferencingKey" datasource="#getDsn()#">
				SELECT so.name as fkName, 
					forTab.name as foreignTableName, 
					thsTab.name as thisTableName,
					forCol.name as foreignColumnName,
					thsCol.name as thisColumnName,	
					thsTab.name + '.' + thsCol.name + '->' + forTab.name + '.' + forCol.name as asString
				FROM SysForeignKeys as sfk JOIN SysObjects as so
					ON sfk.constid = so.id
				JOIN SysObjects as forTab
					ON sfk.rkeyid = forTab.id
				JOIN SysObjects as thsTab 
					ON sfk.fkeyid = thsTab.id
				JOIN SysColumns as forCol
					ON sfk.rkeyid = forCol.id AND sfk.rkey = forCol.colid
				JOIN SysColumns as thsCol
					ON sfk.fkeyid = thsCol.id AND sfk.fkey = thsCol.colid
				WHERE forTab.name = <cfqueryparam cfsqltype="cf_sql_varchar" scale="128" value="#arguments.name#" />
				ORDER BY sfk.constid
			</cfquery>
			
			<!--- cache the results --->
			<cfset TimedCache.setValue("referencingKey_" & arguments.name, qReferencingKey) />
		</cfif>		
		
		<!--- return the data --->
		<cfreturn qReferencingKey />
	</cffunction>
	
	<cffunction name="getForeignKeys" access="public" hint="I return a query of foreign key information on the table." output="false" returntype="query">
		<cfargument name="name" hint="I am the name of the table inspect." required="yes" type="string" />
		<cfset var TimedCache = getTimedCache() />
		<cfset var qForeignKey = 0 />
		
		<cfif TimedCache.exists("foreignKey_" & arguments.name)>
			<cfset qForeignKey = TimedCache.getValue("foreignKey_" & arguments.name) />
		<cfelse>
			<cfquery name="qForeignKey" datasource="#getDsn()#">
				SELECT so.name as fkName, 
					forTab.name as foreignTableName, 
					thsTab.name as thisTableName,
					forCol.name as foreignColumnName,
					thsCol.name as thisColumnName,	
					thsTab.name + '.' + thsCol.name + '->' + forTab.name + '.' + forCol.name as asString
				FROM SysForeignKeys as sfk JOIN SysObjects as so
					ON sfk.constid = so.id
				JOIN SysObjects as forTab
					ON sfk.rkeyid = forTab.id
				JOIN SysObjects as thsTab 
					ON sfk.fkeyid = thsTab.id
				JOIN SysColumns as forCol
					ON sfk.rkeyid = forCol.id AND sfk.rkey = forCol.colid
				JOIN SysColumns as thsCol
					ON sfk.fkeyid = thsCol.id AND sfk.fkey = thsCol.colid
				WHERE thsTab.name = <cfqueryparam cfsqltype="cf_sql_varchar" scale="128" value="#arguments.name#" />
				ORDER BY sfk.constid
			</cfquery>
			
			<!--- cache the results --->
			<cfset TimedCache.setValue("foreignKey_" & arguments.name, qForeignKey) />
		</cfif>		
		
		<!--- return the data --->
		<cfreturn qForeignKey />
	</cffunction>
	
	<cffunction name="getPrimaryKeyColumnList" access="public" hint="I return a list of columns in the primary on the table." output="false" returntype="string">
		<cfargument name="name" hint="I am the name of the table inspect." required="yes" type="string" />
		<cfset var TimedCache = getTimedCache() />
		<cfset var qPrimaryKey = 0 />
		<cfset var columnList = "" />
		
		<cfif TimedCache.exists("primaryKey_" & arguments.name)>
			<cfset columnList = TimedCache.getValue("primaryKey_" & arguments.name) />
		<cfelse>
			<cfstoredproc datasource="#getDsn()#" procedure="sp_pkeys">
				<cfprocparam cfsqltype="cf_sql_varchar" scale="384" value="#arguments.name#" />
				<cfprocresult name="qPrimaryKey" resultset="1" />
			</cfstoredproc>
			
			<!--- cache the results --->
			<cfset columnList = ValueList(qPrimaryKey.column_name) />
			<cfset TimedCache.setValue("primaryKey_" & arguments.name, columnList) />
		</cfif>		
		
		<!--- return the data --->
		<cfreturn columnList />
	</cffunction>
	
	<cffunction name="getColumns" access="public" hint="I return a query of column information on the table." output="false" returntype="query">
		<cfargument name="name" hint="I am the name of the table inspect." required="yes" type="string" />
		<cfset var TimedCache = getTimedCache() />
		<cfset var qColumns = 0 />
		
		<cfif TimedCache.exists("columns_" & arguments.name)>
			<cfset qColumns = TimedCache.getValue("columns_" & arguments.name) />
		<cfelse>
			<cfstoredproc datasource="#getDsn()#" procedure="sp_columns">
				<cfprocparam cfsqltype="cf_sql_varchar" scale="384" value="#arguments.name#" />
				<cfprocresult name="qColumns" resultset="1" />
			</cfstoredproc>
			
			<!--- cache the results --->
			<cfset TimedCache.setValue("columns_" & arguments.name, qColumns) />
		</cfif>		
		
		<!--- return the data --->
		<cfreturn qColumns />
	</cffunction>
	
	<cffunction name="getTable" access="public" hint="I return a query of generic information on the table.  If the table doesn't exist I throw an error." output="false" returntype="query">
		<cfargument name="name" hint="I am the name of the table inspect." required="yes" type="string" />
		<cfset var TimedCache = getTimedCache() />
		<cfset var qTable = 0 />
		
		<cfif TimedCache.exists("table_" & arguments.name)>
			<cfset qTable = TimedCache.getValue("table_" & arguments.name) />
		<cfelse>
			<cfstoredproc datasource="#getDsn()#" procedure="sp_tables">
				<cfprocparam cfsqltype="cf_sql_varchar" scale="384" value="#arguments.name#" />
				<cfprocresult name="qTable" resultset="1" />
			</cfstoredproc>
			
			<!--- before we go any further, check to make sure the name is a real table --->
			<cfif NOT qTable.recordCount>
				<cfthrow type="reactor.InvalidTableName"
					message="Invalid Name Argument"
					detail="The name argument must be a valid table or view name which exists in the database." />
			</cfif>
			
			<!--- cache the results --->
			<cfset TimedCache.setValue("table_" & arguments.name, qTable) />
		</cfif>		
		
		<!--- return the data --->
		<cfreturn qTable />
	</cffunction>
	
	<cffunction name="getTableDefinition" access="private" hint="I return the definition for a table." output="false" returntype="struct">
		<cfargument name="name" hint="I am the name of the table to get the definition for." required="yes" type="string" />
		<cfset var definition = StructNew() />
		
		<cfset definition.table = getTable(arguments.name) />
		<cfset definition.columns = getColumns(arguments.name) />
		<cfset definition.columnList = ValueList(definition.columns.column_name) />
		<cfset definition.primaryKeyColumnList = getPrimaryKeyColumnList(arguments.name) />
		<cfset definition.foreignKeys = getForeignKeys(arguments.name) />
		<cfset definition.foreignKeysColumnList = ValueList(definition.foreignKeys.foreignColumnName) />
		<cfset definition.referencingKeys = getReferencingKeys(arguments.name) />
		<cfset definition.baseTable = getBaseTable(arguments.name, definition.primaryKeyColumnList, definition.foreignKeys) />
		<cfset definition.baseTableColumns = getColumns(definition.baseTable) />
		<cfset definition.baseTablePrimaryKeyColumnList = getPrimaryKeyColumnList(definition.baseTable) />
		
		<!--- return the data --->
		<cfreturn definition />
	</cffunction>
	
	<cffunction name="getTableStructure" access="private" hint="I return an XML document representing the table's structure." output="false" returntype="xml">
		<cfargument name="name" hint="I am the name of the table to get the structure XML for." required="yes" type="string" />
		<cfset var definition = getTableDefinition(arguments.name) /> 
		<cfset var structure = 0 />
		<cfset var signature = "" />
		
		<cfset var customToBase = "reactor.core.abstractTo" />
		<cfset var customDaoBase = "reactor.core.abstractDao" />
		<cfset var customGatewayBase = "reactor.core.abstractGatewy" />
		<cfset var customRecordBase = "reactor.core.abstractRecord" />
		
		<cfif TimedCache.exists("str_" & arguments.name)>
			<cfset structure = TimedCache.getValue("str_" & arguments.name) />
		<cfelse>
			<!--- find out what the generated tables extend --->
			<cfif definition.baseTable IS NOT arguments.name>
				<cfset customToBase = getObjectName("To", definition.baseTable, false) />
				<cfset customDaoBase = getObjectName("Dao", definition.baseTable, false) />
				<cfset customGatewayBase = getObjectName("Gateway", definition.baseTable, false) />
				<cfset customRecordBase = getObjectName("Record", definition.baseTable, false) />
			</cfif>
			
			<cfsavecontent variable="structure">
				<table
					name="<cfoutput>#TitleCase(arguments.name, true)#</cfoutput>"
					baseTable="<cfoutput>#definition.baseTable#</cfoutput>"
					
					customToBase="<cfoutput>#customToBase#</cfoutput>"
					customDaoBase="<cfoutput>#customDaoBase#</cfoutput>"
					customGatewayBase="<cfoutput>#customGatewayBase#</cfoutput>"
					customRecordBase="<cfoutput>#customRecordBase#</cfoutput>"
					
					toBase="<cfoutput>#getObjectName("To", arguments.name, true)#</cfoutput>"
					daoBase="<cfoutput>#getObjectName("Dao", arguments.name, true)#</cfoutput>"
					gatewayBase="<cfoutput>#getObjectName("Gateway", arguments.name, true)#</cfoutput>"
					recordBase="<cfoutput>#getObjectName("Record", arguments.name, true)#</cfoutput>">
					<columns>
						<cfoutput query="definition.columns">
							<column name="#TitleCase(definition.columns.Column_Name, true)#"
								type="#ListFirst(definition.columns.Type_Name, " ")#"
								identity="#Iif(ListLast(definition.columns.Type_Name, " ") IS "identity", DE('true'), DE('false'))#"
								nullable="#Iif(definition.columns.NULLABLE, DE('true'), DE('false'))#"
								length="#definition.columns.Length#"
								default="#definition.columns.Column_Def#"
								primaryKey="#Iif(ListFindNoCase(definition.primaryKeyColumnList, definition.columns.Column_Name), DE('true'), DE('false'))#"
								foreignKey="#Iif(ListFindNoCase(definition.foreignKeysColumnList, definition.columns.Column_Name), DE('true'), DE('false'))#"
								/>
						</cfoutput>
					</columns>
					<foreignKeys>
						<cfoutput query="definition.foreignKeys" group="fkName">
							<foreignKey name="#fkName#"
								table="#TitleCase(foreignTableName, true)#"
								recordType="#getObjectName("Record", foreignTableName)#">
								<cfoutput>
									<column name="#TitleCase(thisColumnName, true)#"
										referencedColumn="#TitleCase(foreignColumnName, true)#" />
								</cfoutput>
							</foreignKey>
						</cfoutput>
					</foreignKeys>
					<referencingKeys>
						<cfoutput query="definition.referencingKeys" group="fkName">
							<referencingKey name="#fkName#"
								table="#TitleCase(thisTableName, true)#">
								<cfoutput>
									<column name="#TitleCase(thisColumnName, true)#"
										referencedColumn="#TitleCase(foreignColumnName, true)#" />
								</cfoutput>
							</referencingKey>
						</cfoutput>
					</referencingKeys>
					<baseTableColumns>
						<cfif definition.baseTable IS NOT arguments.name>
							<cfoutput query="definition.baseTableColumns">
								<baseTableColumn name="#TitleCase(definition.baseTableColumns.Column_Name, true)#"
									type="#ListFirst(definition.baseTableColumns.Type_Name, " ")#"
									overridden="#Iif(ListFindNoCase(definition.columnList, definition.baseTableColumns.Column_Name), DE('true'), DE('false'))#"
									primaryKey="#Iif(ListFindNoCase(definition.baseTablePrimaryKeyColumnList, definition.baseTableColumns.Column_Name), DE('true'), DE('false'))#" />
							</cfoutput>
						</cfif>
					</baseTableColumns>
				</table>
			</cfsavecontent>
						
			<cfset structure = XmlParse(structure) />
			<cfset signature = Hash(structure) />
			<cfset structure.XmlRoot.XmlAttributes["signature"] = signature />
			
			<!--- cache the results --->
			<cfset TimedCache.setValue("str_" & arguments.name, structure) />
		</cfif>
		
		<cfreturn structure />
	</cffunction>
	
	<cffunction name="getBaseTable" access="private" hint="I check to see if this table's primary keys are foreign keys to another table.  If so, I return the name of that table." output="false" returntype="string">
		<cfargument name="name" hint="I am the name of the table." required="yes" type="string" />
		<cfargument name="primaryKeyColumnList" hint="I am the query of the primary key" required="yes" type="string" />
		<cfargument name="foreignKeys" hint="I am the query of foreign keys" required="yes" type="query" />
		<cfset var TimedCache = getTimedCache() />
		<cfset var pkColumnList = arguments.primaryKeyColumnList />
		<cfset var currentFkName = "" />
		<cfset var listLoc = 0 />
		
		<cfif TimedCache.exists("base_" & arguments.name)>
			<cfset arguments.name = TimedCache.getValue("base_" & arguments.name) />
		<cfelse>
			<!--- loop over the foreign keys --->
			<cfloop query="arguments.foreignKeys">
				<!--- check to see if we're starting a new fk set --->
				<cfif currentFkName IS NOT arguments.foreignKeys.fkName>
					<!--- reset some variables --->
					<!--- set the foreign key name.  we'll use this to check to see if we're still on the same foreign key as we loop over the fk query --->
					<cfset currentFkName = arguments.foreignKeys.fkName />
					<!--- get a list of all columns in the primary key --->
					<cfset pkColumnList = arguments.primaryKeyColumnList />
				</cfif>
				
				<!--- Check to see if the columns in the foreign key named #currentFkName# represent all of the columns in the primary key columns. --->
				
				<!--- if the FK column name exists in the primary key then delete it from the list. --->
				<cfset listLoc = ListFindNoCase(pkColumnList, arguments.foreignKeys.thisColumnName) />
				<cfif listLoc>
					<cfset pkColumnList = ListDeleteAt(pkColumnList, listLoc) />
				</cfif>
				
				<!--- if we don't have any items left in the primary key column list then all of the columns in the primary key are part of the foreign key to another table. --->
				<cfif NOT Len(pkColumnList)>
					<!--- the foreign table is a "super" table for this table --->
					<cfset arguments.name = arguments.foreignKeys.foreignTableName />
					<cfbreak />
				</cfif>
			</cfloop>

			<!--- cache the results --->
			<cfset TimedCache.setValue("base_" & arguments.name, arguments.name) />
		</cfif>		
		
		<cfreturn arguments.name />
	</cffunction>
	
</cfcomponent>