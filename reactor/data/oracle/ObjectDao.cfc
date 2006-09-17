 <cfcomponent hint="I read Object data from a Oracle database." extends="reactor.data.abstractObjectDao">

	<cffunction name="read" access="public" hint="I populate an Object object based on it's name" output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to populate." required="yes" type="reactor.core.object" />

		<!--- get all field data --->
		<cfset readObject(arguments.Object) />
		<cfset readFields(arguments.Object) />
	</cffunction>


	<cffunction name="readObject" access="private" hint="I confirm that this object exists at all.  If not, I throw an error." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to check on." required="yes" type="reactor.core.object" />
      <!--- @@Note: added "var" --->
      <cfset var qObject = 0 />

		<cfquery name="qObject"   datasource="#getDsn()#" username="#getUsername()#" password="#getPassword()#">
			SELECT  object_type  as TABLE_TYPE,
					owner        as table_owner
			FROM all_objects
			where object_type in ('TABLE','VIEW')
			and	object_name = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="64" value="#arguments.Object.getName()#" />
		</cfquery>

		<cfif qObject.recordCount>
			<!--- set the owner --->
			<cfset arguments.Object.setOwner( qObject.TABLE_OWNER ) />
			<cfset arguments.Object.setType( lcase(qObject.table_type) ) />
		<cfelse>
			<cfthrow type="reactor.NoSuchObject" />
		</cfif>
	</cffunction>



	<cffunction name="readFields" access="private" hint="I populate the table with fields." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to read fields into." required="yes" type="reactor.core.object" />
		<cfset var qFields = 0 />
		<cfset var Field = 0 />

		<cfquery name="qFields"  datasource="#getDsn()#" username="#getUsername()#" password="#getPassword()#">
			 SELECT
               	    col.COLUMN_NAME       as name,
                    CASE
                          WHEN primaryConstraints.column_name IS NULL THEN 'false'
                          ELSE 'true'
                    END                   as primaryKey,
                    /* Oracle has no equivalent to autoincrement or  identity */
                    'false'                     AS "IDENTITY",                    
                    CASE
                          WHEN col.NULLABLE = 'Y' THEN 'true'
                          ELSE 'false'
                    END                  as NULLABLE,
                   col.DATA_TYPE         as dbDataType,
                    case
                      /* 26 is the length of now() in ColdFusion (i.e. {ts '2006-06-26 13:10:14'})*/
                      when col.data_type = 'DATE'   then 26
                      else col.data_length
                    end                 as length,
                    col.DATA_DEFAULT      as "DEFAULT"
              FROM  all_tab_columns   col,
                    ( select  colCon.column_name,
                   			  colcon.table_name
                    from    all_cons_columns  colCon,
                           all_constraints   tabCon
                    where tabCon.table_name = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="128" value="#arguments.Object.getName()#" />
                         AND colCon.CONSTRAINT_NAME = tabCon.CONSTRAINT_NAME
                         AND colCon.TABLE_NAME      = tabCon.TABLE_NAME
                         AND 'P'                    = tabCon.CONSTRAINT_TYPE
                   ) primaryConstraints
              where col.table_name = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="128" value="#arguments.Object.getName()#" />
              		and col.COLUMN_NAME        = primaryConstraints.COLUMN_NAME (+)
                    AND col.TABLE_NAME       = primaryConstraints.TABLE_NAME (+)
          order by col.column_id
		</cfquery>

		<cfloop query="qFields">
			<!--- create the field --->
			<cfset Field = StructNew() />
			<cfset Field.name         = qFields.name />
			<cfset Field.primaryKey   = qFields.primaryKey />
			<cfset Field.identity     = qFields.identity />
			<cfset Field.nullable     = qFields.nullable />
			<cfset Field.dbDataType   = qFields.dbDataType />
			<cfset Field.cfDataType   = getCfDataType(qFields.dbDataType) />
			<cfset Field.cfSqlType    = getCfSqlType(qFields.dbDataType) />
			<cfset Field.length       = qFields.length />
			<cfset Field.default      = getDefault(qFields.default, Field.cfDataType, Field.nullable) />
			<cfset Field.sequenceName = "" />
			
			<!--- add the field to the table --->
			<cfset arguments.Object.addField(Field) />
		</cfloop>
	</cffunction>

	<cffunction name="getDefault" access="public" hint="I get a default value for a cf datatype." output="false" returntype="string">
		<cfargument name="sqlDefaultValue" hint="I am the default value defined by SQL." 	 required="yes" type="string" />
		<cfargument name="typeName" hint="I am the cf type name to get a default value for." required="yes" type="string" />
		<cfargument name="nullable" hint="I indicate if the column is nullable." 			 required="yes" type="boolean" />

		<cfset arguments.sqlDefaultValue = trim(arguments.sqlDefaultValue)/>

		<!--- strip out any parens --->
		<cfif left(arguments.sqlDefaultValue,1) is "(" and right(arguments.sqlDefaultValue,1) is ")">
			<cfset arguments.sqlDefaultValue = mid(arguments.sqlDefaultValue,2,len(arguments.sqlDefaultValue)-2) />
		</cfif>

		<!--- strip out any single quotes --->
		<cfif left(arguments.sqlDefaultValue,1) is "'" and right(arguments.sqlDefaultValue,1) is "'">
			<cfset arguments.sqlDefaultValue = mid(arguments.sqlDefaultValue,2,len(arguments.sqlDefaultValue)-2) />
		</cfif>
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="NUMERIC">
				<cfif IsNumeric(arguments.sqlDefaultValue)>
					<cfreturn arguments.sqlDefaultValue />
				<cfelseif arguments.nullable>
					<cfreturn "" />
				<cfelse>
					<cfreturn 0 />
				</cfif>
			</cfcase>
			<cfcase value="STRING">
				<cfif FindNoCase("SYS_GUID()", arguments.sqlDefaultValue) gt 0>
					<cfreturn "##replace(CreateUUID(),'-','','all')##" />
				<cfelse>
   				<cfreturn arguments.sqlDefaultValue  />
   			</cfif>
				<cfreturn arguments.sqlDefaultValue  />
			</cfcase>
			<cfcase value="DATE,TIMESTAMP">
				<cfif arguments.sqlDefaultValue IS "SYSDATE">
					<cfreturn "##Now()##" />
				<cfelse>
   				<cfreturn arguments.sqlDefaultValue  />
   			</cfif>
			</cfcase>
			<cfdefaultcase>
				<cfreturn "" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="getCfSqlType" access="private" hint="I translate the Oracle data type names into ColdFusion cf_sql_xyz names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
		<cfswitch expression="#lcase(arguments.typeName)#">
        <!--- misc --->
			<cfcase value="rowid">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<!--- time --->
			<cfcase value="date">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="timestamp(6)">
				<cfreturn "cf_sql_date" />
			</cfcase>
         <!--- strings --->
			<cfcase value="char">
				<cfreturn "cf_sql_char" />
			</cfcase>
			<cfcase value="nchar">
				<cfreturn "cf_sql_char" />
			</cfcase>
			<cfcase value="varchar">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="varchar2">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="nvarchar2">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<!--- long types --->
			<!---   @@Note: bfile  not supported --->
			<cfcase value="blob">
				<cfreturn "cf_sql_blob" />
			</cfcase>
			<cfcase value="clob">
				<cfreturn "cf_sql_clob" />
			</cfcase>
			<cfcase value="nclob">
				<cfreturn "cf_sql_clob" />
			</cfcase>
			<cfcase value="long">
				<cfreturn "cf_sql_longvarchar" />
			</cfcase>
			   <!--- @@Note: may need "tobinary(ToBase64(x))" when updating --->
			<cfcase value="long raw">
				<cfreturn "cf_sql_longvarbinary" />
			</cfcase>
			<cfcase value="raw">
			   <!--- @@Note: may need "tobinary(ToBase64(x))" when updating --->
				<cfreturn "cf_sql_varbinary" />
			</cfcase>
			<!--- numerics --->
			<cfcase value="float">
				<cfreturn "cf_sql_float" />
			</cfcase>
			<cfcase value="integer">
				<cfreturn "cf_sql_numeric" />
			</cfcase>
			<cfcase value="number">
				<cfreturn "cf_sql_numeric" />
			</cfcase>
			<cfcase value="real">
				<cfreturn "cf_sql_numeric" />
			</cfcase>
		</cfswitch>
		<cfthrow message="Unsupported (or incorrectly supported) database datatype: #arguments.typeName#." />
	</cffunction>

	<cffunction name="getCfDataType" access="private" hint="I translate the Oracle data type names into ColdFusion data type names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />

		<cfswitch expression="#arguments.typeName#">
        <!--- misc --->
			<cfcase value="rowid">
				<cfreturn "string" />
			</cfcase>
			<!--- time --->
			<cfcase value="date">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="timestamp(6)">
				<cfreturn "date" />
			</cfcase>
            <!--- strings --->
			<cfcase value="char">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="nchar">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="varchar">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="varchar2">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="nvarchar2">
				<cfreturn "string" />
			</cfcase>
			<!--- long --->
			<!---   @@Note: bfile  not supported --->
			<cfcase value="blob">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="clob">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="nclob">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="long">
				<cfreturn "string" />
			</cfcase>
		   <cfcase value="long raw">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="raw">
				<cfreturn "binary" />
			</cfcase>
			<!--- numerics --->
			<cfcase value="float">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="integer">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="number">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="real">
				<cfreturn "numeric" />
			</cfcase>

		</cfswitch>

		<cfthrow message="Unsupported (or incorrectly supported) database datatype: #arguments.typeName#." />

	</cffunction>

</cfcomponent>