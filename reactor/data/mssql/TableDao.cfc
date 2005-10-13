<cfcomponent hint="I read Table data from a MSSQL database." extends="reactor.data.abstractTableDao">
	
	<cffunction name="read" access="public" hint="I populate a table object based on it's name" output="false" returntype="void">
		<cfargument name="Table" hint="I am the table to populate." required="yes" type="reactor.core.table" />
		
		<!--- get all column data --->
		<cfset tableExists(arguments.Table) />
		<cfset readColumns(arguments.Table) />
		<cfset readPrimaryKey(arguments.Table) />
		<cfset readForeignKeys(arguments.Table) />
		<cfset readReferencingKeys(arguments.Table) />
		<cfset readBridgedTables(arguments.Table) />
		<cfset readSuperTable(arguments.Table) />
	</cffunction>
	
	<cffunction name="tableExists" access="private" hint="I confirm that this table exists at all.  If not, I throw an error." output="false" returntype="void">
		<cfargument name="Table" hint="I am the table to check on." required="yes" type="reactor.core.table" />
		<cfset qTable = 0 />
		
		<cfstoredproc datasource="#getDsn()#" procedure="sp_tables">
			<cfprocparam cfsqltype="cf_sql_varchar" scale="384" value="#arguments.Table.getName()#" />
			<cfprocresult name="qTable" />
		</cfstoredproc>
		
		<cfif NOT qTable.recordCount>
			<cfthrow type="Reactor.NoSuchTable" />
		</cfif>		
	</cffunction>
	
	<cffunction name="readBridgedTables" access="private" hint="I read information about tables related to this table through 'bridging' tables." output="false" returntype="void">
		<cfargument name="Table" hint="I am the table to populate." required="yes" type="reactor.core.table" />
		<!--- logic goes here :) --->
	</cffunction>
	
	<cffunction name="readSuperTable" access="private" hint="I read information about the table's super table(s)." output="false" returntype="void">
		<cfargument name="Table" hint="I am the table to populate." required="yes" type="reactor.core.table" />
		<cfargument name="SuperTable" hint="I am the super table to get super table info for (I am used for recursive calls)." required="no" type="reactor.core.superTable" />
		<cfset var tableName = "" />
		<cfset var qSuper = 0 />
		<cfset var NewSuperTable = 0 />
		<cfset var Relationship = 0 />
				
		<cfif StructKeyExists(arguments, "SuperTable") AND IsObject(arguments.SuperTable)>
			<cfset tableName = arguments.SuperTable.getToTableName() />
		<cfelse>
			<cfset tableName = arguments.Table.getName() />
		</cfif>
		
		<cfquery name="qSuper" datasource="#getDsn()#">
			CREATE TABLE ##pKeys(
				TABLE_QUALIFIER sysname,
				TABLE_OWNER sysname,
				TABLE_NAME sysname,
				COLUMN_NAME sysname,
				KEY_SEQ smallint,
				PK_NAME sysname
			)
			
			INSERT INTO ##pKeys EXEC sp_pkeys <cfqueryparam cfsqltype="cf_sql_varchar" scale="128" value="#tableName#" />
			
			SELECT pk.PK_NAME as pkName, so.name as fkName, 
				pk.TABLE_NAME as thisTableName,
				pk.COLUMN_NAME as thisColumnName,	
				forTab.name as foreignTableName, 
				forCol.name as foreignColumnName,
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
			FULL JOIN ##pKeys as pk
				ON thsTab.name = pk.TABLE_NAME AND thsCol.name = pk.COLUMN_NAME
			WHERE pk.PK_NAME IS NOT NULL
			ORDER BY sfk.constid
			
			DROP TABLE ##pKeys 
		</cfquery>
		
		<cfif qSuper.recordCount>
			<cfset NewSuperTable = CreateObject("Component", "reactor.core.superTable").init(qSuper.pkName, qSuper.thisTableName, qSuper.foreignTableName) />
			
			<cfloop query="qSuper">
				<cfif Len(qSuper.foreignColumnName)>
					<!--- add relationships to this key --->
					<cfset NewSuperTable.addRelationship(CreateObject("Component", "reactor.core.relationship").init(
						qSuper.thisColumnName,
						qSuper.foreignColumnName
					)) />
				<cfelse>
					<cfreturn />
				</cfif>
			</cfloop>
			
			<!--- add columns to the superTable --->
			<cfset readSuperTableColumns(NewSuperTable) />
			
			<!--- add this supertable to the hierarcy --->
			<cfset arguments.Table.prependSuperTable(NewSuperTable) />
			<!--- add the supertable to the hierarchy 
			<cfif StructKeyExists(arguments, "SuperTable") AND IsObject(arguments.SuperTable)>
				<cfset arguments.SuperTable.setSuperTable(NewSuperTable) />
			<cfelse>
			</cfif>--->
			
			<!--- recurse and find this table's super table --->
			<cfset readSuperTable(arguments.Table, NewSuperTable) />
		</cfif>
	</cffunction>

	<cffunction name="readSuperTableColumns" access="private" hint="I populate a superTable with columns." output="false" returntype="void">
		<cfargument name="SuperTable" hint="I am the superTable to populate." required="yes" type="reactor.core.superTable" />
		<cfset var qColumns = 0 />
		<cfset var Column = 0 />
		
		<cfstoredproc datasource="#getDsn()#" procedure="sp_columns">
			<cfprocparam cfsqltype="cf_sql_varchar" scale="384" value="#arguments.SuperTable.getToTableName()#" />
			<cfprocresult name="qColumns" resultset="1" />
		</cfstoredproc>

		<cfloop query="qColumns">
			<!--- create the column --->
			<cfset Column = CreateObject("Component", "reactor.core.column").init(
				qColumns.column_name,
				translateDataType(ListFirst(qColumns.Type_Name, " ")),
				translateCfSqlType(ListFirst(qColumns.Type_Name, " ")),
				Iif(ListLast(qColumns.Type_Name, " ") IS "identity", DE(true), DE(false)),
				Iif(qColumns.NULLABLE, DE('true'), DE('false')),
				qColumns.Length,
				getCfDefaultValue(qColumns.column_def, translateDataType(ListFirst(qColumns.Type_Name, " ")))
			) />
			
			<!--- add the column to the superTable --->
			<cfset arguments.SuperTable.addColumn(Column) />
		</cfloop>
	</cffunction>
	
	<cffunction name="readReferencingKeys" access="private" hint="I populate the table with referencing foreign key information." output="false" returntype="void">
		<cfargument name="Table" hint="I am the table to populate." required="yes" type="reactor.core.table" />
		<cfset var qReferencingKey = 0 />
		<cfset var ReferencingKey = 0 />
		
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
			WHERE forTab.name = <cfqueryparam cfsqltype="cf_sql_varchar" scale="128" value="#arguments.Table.getName()#" />
			ORDER BY sfk.constid
		</cfquery>
		
		<cfif qReferencingKey.recordcount>
			<cfoutput query="qReferencingKey" group="fkName">
				<!--- create the foreign key --->
				<cfset ReferencingKey = CreateObject("Component", "reactor.core.key").init(qReferencingKey.foreignColumnName, qReferencingKey.thisTableName, qReferencingKey.foreignTableName) />
				
				<!--- add columns to the foreign key --->
				<cfoutput>
					<!--- add relationships to this key --->
					<cfset referencingKey.addRelationship(CreateObject("Component", "reactor.core.relationship").init(
						qReferencingKey.thisColumnName,
						qReferencingKey.foreignColumnName
					)) />
				</cfoutput>
				test
				<!--- add the foreign key to the table --->
				<cfset arguments.Table.addReferencingKey(referencingKey) />
			</cfoutput>
		</cfif>		
	</cffunction>
		
	<cffunction name="readForeignKeys" access="private" hint="I populate the table with foreign key information." output="false" returntype="void">
		<cfargument name="Table" hint="I am the table to populate." required="yes" type="reactor.core.table" />
		<cfset var qForeignKey = 0 />
		<cfset var ForeignKey = 0 />
		
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
			WHERE thsTab.name = <cfqueryparam cfsqltype="cf_sql_varchar" scale="128" value="#arguments.Table.getName()#" />
			ORDER BY sfk.constid
		</cfquery>
		
		<cfif qForeignKey.recordcount>
			<cfoutput query="qForeignKey" group="fkName">
				<!--- create the foreign key --->
				<cfset ForeignKey = CreateObject("Component", "reactor.core.key").init(qForeignKey.fkName, qForeignKey.thisTableName, qForeignKey.foreignTableName) />
				
				<!--- add columns to the foreign key --->
				<cfoutput>
					<!--- add relationships to this key --->
					<cfset foreignKey.addRelationship(CreateObject("Component", "reactor.core.relationship").init(
						qForeignKey.thisColumnName,
						qForeignKey.foreignColumnName
					)) />
				</cfoutput>
				
				<!--- add the foreign key to the table --->
				<cfset arguments.Table.addForeignKey(foreignKey) />
			</cfoutput>
		</cfif>		
	</cffunction>
	
	<cffunction name="readPrimaryKey" access="private" hint="I populate the table with primary key information." output="false" returntype="void">
		<cfargument name="Table" hint="I am the table to populate." required="yes" type="reactor.core.table" />
		<cfset var qPrimaryKey = 0 />
		<cfset var PrimaryKey = 0 />
		<cfset var Column = 0 />
		<cfstoredproc datasource="#getDsn()#" procedure="sp_pkeys">
			<cfprocparam cfsqltype="cf_sql_varchar" scale="384" value="#arguments.Table.getName()#" />
			<cfprocresult name="qPrimaryKey" resultset="1" />
		</cfstoredproc>
		
		<cfif qPrimaryKey.recordCount>
			<!--- set the primary key's name --->
			<cfset PrimaryKey = CreateObject("Component", "reactor.core.primaryKey").init(qPrimaryKey.pk_name) />
			
			<!--- add columns to the primary key --->
			<cfloop query="qPrimaryKey">
				<cfset Column = arguments.Table.getColumn(qPrimaryKey.column_name) />
				<cfset Column.setPrimaryKey(true) />
				<cfset PrimaryKey.addColumn(Column) />
			</cfloop>
			
			<!--- add the primary key to the table --->
			<cfset arguments.Table.setPrimaryKey(PrimaryKey) />
		</cfif>
	</cffunction>

	<cffunction name="readColumns" access="private" hint="I populate the table with columns." output="false" returntype="void">
		<cfargument name="Table" hint="I am the table to populate." required="yes" type="reactor.core.table" />
		<cfset var qColumns = 0 />
		<cfset var Column = 0 />
		
		<cfstoredproc datasource="#getDsn()#" procedure="sp_columns">
			<cfprocparam cfsqltype="cf_sql_varchar" scale="384" value="#arguments.Table.getName()#" />
			<cfprocresult name="qColumns" resultset="1" />
		</cfstoredproc>
		
		<cfloop query="qColumns">
			<!--- create the column --->
			<cfset Column = CreateObject("Component", "reactor.core.column").init(
				qColumns.column_name,
				translateDataType(ListFirst(qColumns.Type_Name, " ")),
				translateCfSqlType(ListFirst(qColumns.Type_Name, " ")),
				Iif(ListLast(qColumns.Type_Name, " ") IS "identity", DE(true), DE(false)),
				Iif(qColumns.NULLABLE, DE('true'), DE('false')),
				qColumns.Length,
				getCfDefaultValue(qColumns.column_def, translateDataType(ListFirst(qColumns.Type_Name, " ")))
			) />
			
			<!--- add the column to the table --->
			<cfset arguments.Table.addColumn(Column) />
		</cfloop>
	</cffunction>
	
	<cffunction name="getCfDefaultValue" access="public" hint="I get a default value for a cf datatype." output="false" returntype="string">
		<cfargument name="sqlDefaultValue" hint="I am the default value defined by SQL." required="yes" type="string" />
		<cfargument name="typeName" hint="I am the cf type name to get a default value for." required="yes" type="string" />
		
		<!--- strip out parens --->
		<cfif Len(arguments.sqlDefaultValue)>
			<cfset arguments.sqlDefaultValue = Mid(arguments.sqlDefaultValue, 2, Len(arguments.sqlDefaultValue)-2 )/>
		</cfif>
		
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="numeric">
				<cfif IsNumeric(arguments.sqlDefaultValue)>
					<cfreturn arguments.sqlDefaultValue />
				<cfelse>
					<cfreturn 0 />
				</cfif>
			</cfcase>
			<cfcase value="binary">
				<cfreturn """""" />
			</cfcase>
			<cfcase value="boolean">
				<cfif IsBoolean(arguments.sqlDefaultValue)>
					<cfreturn Iif(arguments.sqlDefaultValue, DE(true), DE(false)) />
				<cfelse>
					<cfreturn false />
				</cfif>
			</cfcase>
			<cfcase value="string">
				<!--- insure that the first and last characters are "'" --->
				<cfif Left(arguments.sqlDefaultValue, 1) IS "'" AND Right(arguments.sqlDefaultValue, 1) IS "'">
					<!--- mssql functions must be constants.  for this reason I can convert anything quoted in single quotes safely to a string --->
					<cfset arguments.sqlDefaultValue = Mid(arguments.sqlDefaultValue, 2, Len(arguments.sqlDefaultValue)-2) />
					<cfset arguments.sqlDefaultValue = Replace(arguments.sqlDefaultValue, "''", "'", "All") />
					<cfset arguments.sqlDefaultValue = Replace(arguments.sqlDefaultValue, """", """""", "All") />
					<cfreturn """" & arguments.sqlDefaultValue & """" />
				<cfelse>
					<cfreturn """""" />
				</cfif>
			</cfcase>
			<cfcase value="date">
				<cfif Left(arguments.sqlDefaultValue, 1) IS "'" AND Right(arguments.sqlDefaultValue, 1) IS "'">
					<cfreturn Mid(arguments.sqlDefaultValue, 2, Len(arguments.sqlDefaultValue)-2) />
				<cfelseif arguments.sqlDefaultValue IS "getDate()">
					<cfreturn "Now()" />
				<cfelse>
					<cfreturn """""" />
				</cfif>
			</cfcase>
			<cfdefaultcase>
				<cfreturn "" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="translateCfSqlType" access="private" hint="I translate the MSSQL data type names into ColdFusion cf_sql_xyz names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
		
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="bigint">
				<cfreturn "cf_sql_bigint" />
			</cfcase>
			<cfcase value="binary">
				<cfreturn "cf_sql_binary" />
			</cfcase>
			<cfcase value="bit">
				<cfreturn "cf_sql_bit" />
			</cfcase>
			<cfcase value="char">
				<cfreturn "cf_sql_char" />
			</cfcase>
			<cfcase value="datetime">
				<cfreturn "cf_sql_date" />
			</cfcase>
			<cfcase value="decimal">
				<cfreturn "cf_sql_decimal" />
			</cfcase>
			<cfcase value="float">
				<cfreturn "cf_sql_float" />
			</cfcase>
			<cfcase value="image">
				<cfreturn "cf_sql_longvarbinary" />
			</cfcase>
			<cfcase value="int">
				<cfreturn "cf_sql_integer" />
			</cfcase>
			<cfcase value="money">
				<cfreturn "cf_sql_money" />
			</cfcase>
			<cfcase value="nchar">
				<cfreturn "cf_sql_char" />
			</cfcase>
			<cfcase value="ntext">
				<cfreturn "cf_sql_longvarchar" />
			</cfcase>
			<cfcase value="numeric">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="nvarchar">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="real">
				<cfreturn "cf_sql_real" />
			</cfcase>
			<cfcase value="smalldatetime">
				<cfreturn "cf_sql_date" />
			</cfcase>
			<cfcase value="smallint">
				<cfreturn "cf_sql_smallint" />
			</cfcase>
			<cfcase value="smallmoney">
				<cfreturn "cf_sql_decimal" />
			</cfcase>
			<cfcase value="text">
				<cfreturn "cf_sql_longvarchar" />
			</cfcase>
			<cfcase value="timestamp">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="tinyint">
				<cfreturn "cf_sql_tinyint" />
			</cfcase>
			<cfcase value="uniqueidentifier">
				<cfreturn "cf_sql_char" />
			</cfcase>
			<cfcase value="varbinary">
				<cfreturn "cf_sql_varbinary" />
			</cfcase>
			<cfcase value="varchar">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
		</cfswitch>
	</cffunction>

	<cffunction name="translateDataType" access="private" hint="I translate the MSSQL data type names into ColdFusion data type names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
		
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="bigint">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="binary">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="bit">
				<cfreturn "boolean" />
			</cfcase>
			<cfcase value="char">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="datetime">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="decimal">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="float">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="image">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="int">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="money">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="nchar">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="ntext">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="numeric">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="nvarchar">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="real">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="smalldatetime">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="smallint">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="smallmoney">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="text">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="timestamp">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="tinyint">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="uniqueidentifier">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="varbinary">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="varchar">
				<cfreturn "string" />
			</cfcase>
		</cfswitch>
	</cffunction>

</cfcomponent>

<!---- 
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
								length="#definition.columns.Length#"
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
		
	<cfdump var="#structure#" />
	
	<cfabort>
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
---->
