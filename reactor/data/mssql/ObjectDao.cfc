<cfcomponent hint="I read Object data from a MSSQL database." extends="reactor.data.abstractObjectDao">
	
	<cffunction name="read" access="public" hint="I populate an Object object based on it's name" output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to populate." required="yes" type="any" _type="reactor.core.object" />
		
		<!--- get all field data --->
		<cfset readObject(arguments.Object) />
		<cfset readFields(arguments.Object) />
	</cffunction>
	
	<cffunction name="readObject" access="private" hint="I confirm that this object exists at all.  If not, I throw an error." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to check on." required="yes" type="any" _type="reactor.core.object" />
		<cfset var qObject = 0 />
		
		<cfstoredproc datasource="#getDsn()#" procedure="sp_tables" username="#getUsername()#" password="#getPassword()#">
			<cfprocparam cfsqltype="cf_sql_varchar" maxlength="384" 
						value="#ListLast(arguments.Object.getName(),'.')#" />
			<cfprocresult name="qObject" />
		</cfstoredproc>
		
		<cfif qObject.recordCount>
			<cfset arguments.Object.setDatabase(qObject.TABLE_QUALIFIER) />
			<cfset arguments.Object.setOwner(qObject.TABLE_OWNER) />
			<cfset arguments.Object.setType(qObject.TABLE_TYPE) />
		<cfelse>		
			<cfthrow type="Reactor.NoSuchObject" />
		</cfif>		
	</cffunction>
	
	<cffunction name="readFields" access="private" hint="I populate the table with fields." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to read fields into." required="yes" type="any" _type="reactor.core.object" />
		<cfset var qFields = 0 />
		<cfset var Field = 0 />
				
		<cfquery name="qFields" datasource="#getDsn()#" username="#getUsername()#" password="#getPassword()#">
			SELECT 
				col.COLUMN_NAME as name,
				CASE
					WHEN colCon.CONSTRAINT_NAME IS NOT NULL THEN 'true'
					ELSE 'false'
				END as primaryKey,
				CASE
          WHEN columnProperty(object_id(quotename(col.TABLE_SCHEMA)+'.'+quotename(col.TABLE_NAME)), col.COLUMN_NAME, 'IsIdentity') > 0 THEN 'true'
          ELSE 'false'
				END AS [identity],	
				CASE
					WHEN col.IS_NULLABLE = 'No' THEN 'false'
					ELSE 'true'
				END as nullable,

				col.DATA_TYPE as dbDataType,
				CASE
					WHEN ISNUMERIC(col.CHARACTER_MAXIMUM_LENGTH) = 1 THEN col.CHARACTER_MAXIMUM_LENGTH
					ELSE 0
				END as length,
				col.COLUMN_DEFAULT as [default],
				CASE
					WHEN columnProperty(object_id(quotename(col.TABLE_SCHEMA)+'.'+quotename(col.TABLE_NAME)), col.COLUMN_NAME, 'IsRowGUIDCol') = 1 THEN 'true'
					WHEN columnProperty(object_id(quotename(col.TABLE_SCHEMA)+'.'+quotename(col.TABLE_NAME)), col.COLUMN_NAME, 'IsComputed') = 1 THEN 'true'
					ELSE 'false'
				END as readOnly
			FROM INFORMATION_SCHEMA.COLUMNS as col LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS as tabCon
				ON col.TABLE_NAME = tabCon.TABLE_NAME
				AND tabCon.CONSTRAINT_TYPE = 'PRIMARY KEY'
			LEFT JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE as colCon
				ON col.COLUMN_NAME = colCon.COLUMN_NAME
				AND col.TABLE_NAME = colCon.TABLE_NAME
				AND colCon.CONSTRAINT_NAME = tabCon.CONSTRAINT_NAME
			WHERE col.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="128" 
										value="#ListLast(arguments.Object.getName(),'.')#" />
		</cfquery>
		
		<cfloop query="qFields">
			<!--- create the field --->
			<cfset Field = StructNew() />
			<cfset Field.name = qFields.name />
			<cfset Field.primaryKey = qFields.primaryKey />
			<cfset Field.identity = qFields.identity />
			<cfset Field.nullable = qFields.nullable />
			<cfset Field.dbDataType = qFields.dbDataType />
			<cfset Field.cfDataType = getCfDataType(qFields.dbDataType) />
			<cfset Field.cfSqlType = getCfSqlType(qFields.dbDataType) />
			<cfset Field.length = qFields.length />
			<cfset Field.default = getDefault(qFields.default, Field.cfDataType, Field.nullable) />
			<cfset Field.sequenceName = "" />
			<cfset Field.readOnly = qFields.readOnly />
			<cfset Field.scale = "0" />
			
			<!--- add the field to the table --->
			<cfset arguments.Object.addField(Field) />
		</cfloop>
	</cffunction>
	
	<cffunction name="getDefault" access="public" hint="I get a default value for a cf datatype." output="false" returntype="any" _returntype="string">
		<cfargument name="sqlDefaultValue" hint="I am the default value defined by SQL." required="yes" type="any" _type="string" />
		<cfargument name="typeName" hint="I am the cf type name to get a default value for." required="yes" type="any" _type="string" />
		<cfargument name="nullable" hint="I indicate if the column is nullable." required="yes" type="any" _type="boolean" />
		
    <cfset var MSguid = CreateUUID() />
    
		<!--- strip out parens --->
		<cfif Len(arguments.sqlDefaultValue)>
			<cfif ReFind("(^\(+)([0-9]+)(\)+$)", arguments.sqlDefaultValue, 0)>
				<cfset arguments.sqlDefaultValue = ReReplace(arguments.sqlDefaultValue, "(^\(+)([0-9]+)(\)+$)", "\2", "all") />	
			<cfelse>
				<cfset arguments.sqlDefaultValue = Mid(arguments.sqlDefaultValue, 2, Len(arguments.sqlDefaultValue)-2 )/>
			</cfif>
		</cfif>
		
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="numeric">
				<cfif IsNumeric(arguments.sqlDefaultValue)>
					<cfreturn arguments.sqlDefaultValue />
				<cfelseif arguments.nullable>
					<cfreturn ""/>
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
			<cfcase value="uniqueidentifier">
				<cfif ReFindNoCase("'*newId()'*", arguments.sqlDefaultValue)>
					<cfreturn "##left(MSguid,23)&"-"&right(MSguid,12)##" />
				<cfelse>
					<cfreturn "" />
				</cfif>
			</cfcase>
			<cfcase value="string">
				<!--- insure that the first and last characters are "'" --->
				<cfif ReFindNoCase("'*newId()'*", arguments.sqlDefaultValue)>
					<cfreturn "##CreateUUID()##" />
					<!---  IS "newId()" --->
				<cfelseif Left(arguments.sqlDefaultValue, 1) IS "'" AND Right(arguments.sqlDefaultValue, 1) IS "'">
					<!--- mssql functions must be constants.  for this reason I can convert anything quoted in single quotes safely to a string --->
					<cfset arguments.sqlDefaultValue = Mid(arguments.sqlDefaultValue, 2, Len(arguments.sqlDefaultValue)-2) />
					<cfset arguments.sqlDefaultValue = Replace(arguments.sqlDefaultValue, "''", "'", "All") />
					<cfset arguments.sqlDefaultValue = Replace(arguments.sqlDefaultValue, """", """""", "All") />
          <cfreturn arguments.sqlDefaultValue/>
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
	
	<cffunction name="getCfSqlType" access="private" hint="I translate the MSSQL data type names into ColdFusion cf_sql_xyz names" output="false" returntype="any" _returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="any" _type="string" />
		
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
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="decimal">
				<cfreturn "cf_sql_float" />
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
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="smallint">
				<cfreturn "cf_sql_smallint" />
			</cfcase>
			<cfcase value="smallmoney">
				<cfreturn "cf_sql_float" />
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
				<cfreturn "cf_sql_idstamp" />
			</cfcase>
			<cfcase value="varbinary">
				<cfreturn "cf_sql_varbinary" />
			</cfcase>
			<cfcase value="varchar">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="xml">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
		</cfswitch>
		
		<cfthrow message="Unsupported (or incorrectly supported) database datatype: #arguments.typeName#." />
	</cffunction>

	<cffunction name="getCfDataType" access="private" hint="I translate the MSSQL data type names into ColdFusion data type names" output="false" returntype="any" _returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="any" _type="string" />
		
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
				<cfreturn "guid" />
			</cfcase>
			<cfcase value="varbinary">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="varchar">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="xml">
				<cfreturn "string" />
			</cfcase>
		</cfswitch>
	
		<cfthrow message="Unsupported (or incorrectly supported) database datatype: #arguments.typeName#." />
		
	</cffunction>

</cfcomponent>
