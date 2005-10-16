<cfcomponent hint="I read Table data from a MSSQL database." extends="reactor.data.abstractTableDao">
	
	<cffunction name="read" access="public" hint="I populate a table object based on it's name" output="false" returntype="void">
		<cfargument name="Table" hint="I am the table to populate." required="yes" type="reactor.core.table" />
		
		<!--- get all column data --->
		<cfset tableExists(arguments.Table) />
		<cfset readColumns(arguments.Table) />
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
				getCfDefaultValue(qColumns.column_def, translateDataType(ListFirst(qColumns.Type_Name, " "))),
				getCfDefaultExpression(qColumns.column_def, translateDataType(ListFirst(qColumns.Type_Name, " ")))
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
	
	<cffunction name="readColumns" access="private" hint="I populate the table with columns." output="false" returntype="void">
		<cfargument name="Table" hint="I am the table to populate." required="yes" type="reactor.core.table" />
		<cfset var qColumns = 0 />
		<cfset var Column = 0 />
		
		<!---
		<cfstoredproc datasource="#getDsn()#" procedure="sp_columns">
			<cfprocparam cfsqltype="cf_sql_varchar" scale="384" value="#arguments.Table.getName()#" />
			<cfprocresult name="qColumns" resultset="1" />
		</cfstoredproc>
		--->
		
		<cfquery name="qColumns" datasource="#getDsn()#">
			SELECT 
				col.COLUMN_NAME,
				col.DATA_TYPE,
				columnProperty(object_id(col.TABLE_NAME), col.COLUMN_NAME, 'IsIdentity') AS IS_IDENTITY,
				CASE
					WHEN col.IS_NULLABLE = 'No' THEN 'false'
					ELSE 'true'
				END as IS_NULLABLE,
				CASE
					WHEN ISNUMERIC(col.CHARACTER_MAXIMUM_LENGTH) = 1 THEN col.CHARACTER_MAXIMUM_LENGTH
					ELSE 0
				END as CHARACTER_MAXIMUM_LENGTH,
				col.COLUMN_DEFAULT,
				tabCon.CONSTRAINT_TYPE,
				CASE
					WHEN colCon.CONSTRAINT_NAME IS NOT NULL THEN 'true'
					ELSE 'false'
				END as IS_PRIMARYKEY
			FROM INFORMATION_SCHEMA.COLUMNS as col JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS as tabCon
				ON col.TABLE_NAME = tabCon.TABLE_NAME
				AND tabCon.CONSTRAINT_TYPE = 'PRIMARY KEY'
			LEFT JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE as colCon
				ON col.COLUMN_NAME = colCon.COLUMN_NAME
				AND col.TABLE_NAME = colCon.TABLE_NAME
				AND colCon.CONSTRAINT_NAME = tabCon.CONSTRAINT_NAME
			WHERE col.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" scale="128" value="#arguments.Table.getName()#" />
		</cfquery>
		
		<cfloop query="qColumns">
			<!--- create the column --->
			<cfset Column = CreateObject("Component", "reactor.core.column").init(
				qColumns.column_name,
				translateDataType(qColumns.DATA_TYPE),
				translateCfSqlType(qColumns.DATA_TYPE),
				qColumns.IS_IDENTITY,
				qColumns.IS_NULLABLE,
				qColumns.CHARACTER_MAXIMUM_LENGTH,
				getCfDefaultValue(qColumns.COLUMN_DEFAULT, translateDataType(qColumns.DATA_TYPE)),
				getCfDefaultExpression(qColumns.COLUMN_DEFAULT, translateDataType(qColumns.DATA_TYPE, " ")),
				qColumns.IS_PRIMARYKEY
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
	
	<cffunction name="getCfDefaultExpression" access="public" hint="I get a default value for a cf datatype." output="false" returntype="string">
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
				<cfreturn "" />
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
					<cfreturn arguments.sqlDefaultValue />
				<cfelse>
					<cfreturn "" />
				</cfif>
			</cfcase>
			<cfcase value="date">
				<cfif Left(arguments.sqlDefaultValue, 1) IS "'" AND Right(arguments.sqlDefaultValue, 1) IS "'">
					<cfreturn Mid(arguments.sqlDefaultValue, 2, Len(arguments.sqlDefaultValue)-2) />
				<cfelseif arguments.sqlDefaultValue IS "getDate()">
					<cfreturn "##Now()##" />
				<cfelse>
					<cfreturn "" />
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
