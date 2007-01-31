<cfcomponent hint="I read Object data from a db2 database." extends="reactor.data.abstractObjectDao">
	
	<cffunction name="read" access="public" hint="I populate an Object object based on it's name" output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to populate." required="yes" type="any" _type="reactor.core.object" />
		
		<!--- get all field data --->
		<cfset readObject(arguments.Object) />
		<cfset readFields(arguments.Object) />
	</cffunction>
	
	<cffunction name="readObject" access="private" hint="I confirm that this object exists at all.  If not, I throw an error." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to check on." required="yes" type="any" _type="reactor.core.object" />
		<cfset var qObject = 0 />
		
		<cfquery name="qObject" datasource="#getDsn()#">
			SELECT "NAME", "CREATOR", 
				CASE
					WHEN "TYPE" = 'T' THEN 'table'
					WHEN "TYPE" = 'V' THEN 'view'
				END AS "TYPE"
			FROM SYSIBM.SYSTABLES
			WHERE "NAME" = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="128" value="#arguments.Object.getName()#" /> 
		</cfquery>
				
		<cfif qObject.recordCount>
			<cfset arguments.Object.setDatabase(qObject.NAME) />
			<cfset arguments.Object.setOwner(qObject.CREATOR) />
			<cfset arguments.Object.setType(qObject.TYPE) />
		<cfelse>		
			<cfthrow type="Reactor.NoSuchObject" />
		</cfif>		
	</cffunction>
	
	<cffunction name="readFields" access="private" hint="I populate the table with fields." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to read fields into." required="yes" type="any" _type="reactor.core.object" />
		<cfset var qFields = 0 />
		<cfset var Field = 0 />
				
		<cfquery name="qFields" datasource="#getDsn()#" username="#getUsername()#" password="#getPassword()#">
			SELECT CO."NAME",
				CASE
					WHEN KC."COLUMN_NAME" IS NOT NULL THEN 'true'
					ELSE 'false'
				END AS "PRIMARYKEY",
				CASE
					WHEN CO."IDENTITY" = 'Y' THEN 'true'
					ELSE 'false'
				END AS "IDENTITY",
				CASE
					WHEN CO."NULLS" = 'Y' THEN 'true'
					ELSE 'false'
				END AS "NULL",
				CO."COLTYPE",
				CO."LENGTH",
				CO."DEFAULT"
			FROM SYSIBM.SYSCOLUMNS AS CO LEFT JOIN SYSIBM.SQLPRIMARYKEYS AS KC
				ON CO."TBNAME" = KC."TABLE_NAME"
				AND CO."NAME" = KC."COLUMN_NAME"
			WHERE CO."TBNAME" = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="128" value="#arguments.Object.getName()#" />
      ORDER by CO."COLNO"
		</cfquery>
		
		<cfloop query="qFields">
			<!--- create the field --->
			<cfset Field = StructNew() />
			<cfset Field.name = trim(qFields.NAME) />
			<cfset Field.primaryKey = qFields.PRIMARYKEY />
			<cfset Field.identity = qFields.IDENTITY />
			<cfset Field.nullable = qFields.NULL />
			<cfset Field.dbDataType = trim(qFields.COLTYPE) />
			<cfset Field.cfDataType = getCfDataType(trim(qFields.COLTYPE)) />
			<cfset Field.cfSqlType = getCfSqlType(trim(qFields.COLTYPE)) />
			<cfset Field.length = qFields.LENGTH />
			<cfset Field.default = getDefault(trim(qFields.default), Field.cfDataType, Field.nullable) />
			<cfset Field.sequenceName = "" />
			<cfset Field.readOnly = "false" />
			<cfset Field.scale = "0" />
			
			<!--- add the field to the table --->
			<cfset arguments.Object.addField(Field) />
		</cfloop>
	</cffunction>
	
	<cffunction name="getDefault" access="public" hint="I get a default value for a cf datatype." output="false" returntype="any" _returntype="string">
		<cfargument name="sqlDefaultValue" hint="I am the default value defined by SQL." required="yes" type="any" _type="string" />
		<cfargument name="typeName" hint="I am the cf type name to get a default value for." required="yes" type="any" _type="string" />
		<cfargument name="nullable" hint="I indicate if the column is nullable." required="yes" type="any" _type="boolean" />
		
		<!--- strip out parens
		<cfif Len(arguments.sqlDefaultValue)>
			<cfset arguments.sqlDefaultValue = Mid(arguments.sqlDefaultValue, 2, Len(arguments.sqlDefaultValue)-2 )/>
		</cfif> --->
		
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
			<cfcase value="string">
				<!--- insure that the first and last characters are "'" --->
				<cfif ReFindNoCase("'*newId()'*", arguments.sqlDefaultValue)>
					<cfreturn "##CreateUUID()##" />
					<!---  IS "newId()" --->
				<cfelseif Left(arguments.sqlDefaultValue, 1) IS "'" AND Right(arguments.sqlDefaultValue, 1) IS "'">
					<!--- db2 functions must be constants.  for this reason I can convert anything quoted in single quotes safely to a string --->
					<cfset arguments.sqlDefaultValue = Mid(arguments.sqlDefaultValue, 2, Len(arguments.sqlDefaultValue)-2) />
					<cfset arguments.sqlDefaultValue = Replace(arguments.sqlDefaultValue, "''", "'", "All") />
					<cfset arguments.sqlDefaultValue = Replace(arguments.sqlDefaultValue, """", """""", "All") />
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
	
	<cffunction name="getCfSqlType" access="private" hint="I translate the db2 data type names into ColdFusion cf_sql_xyz names" output="false" returntype="any" _returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="any" _type="string" />
		
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="bigint">
				<cfreturn "cf_sql_bigint" />
			</cfcase>
			<cfcase value="integer">
				<cfreturn "cf_sql_integer" />
			</cfcase>
			<cfcase value="smallint">
				<cfreturn "cf_sql_smallint" />
			</cfcase>
			<cfcase value="decimal">
				<cfreturn "cf_sql_float" />
			</cfcase>
			<cfcase value="numeric">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="float">
				<cfreturn "cf_sql_float" />
			</cfcase>
			<cfcase value="char">
				<cfreturn "cf_sql_char" />
			</cfcase>
			<cfcase value="varchar">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="binary">
				<cfreturn "cf_sql_binary" />
			</cfcase>
			<cfcase value="varbinary">
				<cfreturn "cf_sql_varbinary" />
			</cfcase>
			<cfcase value="blob">
				<cfreturn "cf_sql_blob" />
			</cfcase>
			<cfcase value="clob">
				<cfreturn "cf_sql_clob" />
			</cfcase>
			<cfcase value="date">
				<cfreturn "cf_sql_date" />
			</cfcase>
			<cfcase value="time">
				<cfreturn "cf_sql_time" />
			</cfcase>
			<cfcase value="timestamp,timestmp">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="graphic">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="dbclob">
				<cfreturn "cf_sql_clob" />
			</cfcase>
		</cfswitch>
		
		<cfthrow message="Unsupported (or incorrectly supported) database datatype: #arguments.typeName#." />
	</cffunction>

	<cffunction name="getCfDataType" access="private" hint="I translate the db2 data type names into ColdFusion data type names" output="false" returntype="any" _returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="any" _type="string" />

		<cfswitch expression="#arguments.typeName#">
			<cfcase value="bigint">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="integer">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="smallint">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="decimal">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="numeric">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="float">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="char">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="varchar">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="binary">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="varbin">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="blob">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="clob">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="date">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="time">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="timestamp,timestmp">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="graphic">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="dbclob">
				<cfreturn "string" />
			</cfcase>
		</cfswitch>
		
		<cfthrow message="Unsupported (or incorrectly supported) database datatype: #arguments.typeName#." />
	</cffunction>

</cfcomponent>

