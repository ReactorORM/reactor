<cfcomponent hint="I read Object data from a Oracle database." extends="reactor.data.abstractObjectDao">

	<cffunction name="read" access="public" hint="I populate an Object object based on it's name" output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to populate." required="yes" type="any" _type="reactor.core.object" />

		<!--- get all field data --->
		<cfset readObject(arguments.Object) />
		<cfset readFields(arguments.Object) />
	</cffunction>


	<cffunction name="readObject" access="private" hint="I confirm that this object exists at all.  If not, I throw an error." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to check on." required="yes" type="any" _type="reactor.core.object" />
      <cfset var qObject = 0 />

  		<cfquery name="qObject"   datasource="#getDsn()#" username="#getUsername()#" password="#getPassword()#">
  			SELECT   object_name table_name,
            object_type  as TABLE_TYPE,
  					owner        as table_owner
  			FROM all_objects
  			where object_type in ('TABLE','VIEW')
  			and	object_name = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="64" value="#arguments.Object.getName()#" />
  		</cfquery>
  		<cfif qObject.recordCount is 0>
    		<cfquery name="qObject"   datasource="#getDsn()#" username="#getUsername()#" password="#getPassword()#">
    			SELECT  object_name table_name,
              object_type  as TABLE_TYPE,
    					owner        as table_owner
    			FROM all_objects
    			where object_type in ('TABLE','VIEW')
    			and	object_name = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="64" value="#ucase(arguments.Object.getName())#" />
    		</cfquery>
      </cfif>
      
  		<cfif qObject.recordCount>
  			<!--- set the owner --->
  			<cfset arguments.Object.setOwner( qObject.TABLE_OWNER ) />
  			<cfset arguments.Object.setType( lcase(qObject.table_type) ) />
  			<cfset arguments.Object.setName( qObject.table_name ) />
  		<cfelse>
  			<cfthrow type="reactor.NoSuchObject" />
  		</cfif>
	</cffunction>

	<cffunction name="getExactObjectName" access="public" hint="I return the case-sensitive object name" output="false" returntype="any" _returntype="string">
		<cfargument name="ObjectName" hint="I am the object name to check on." required="true" type="any" _type="string" />
		<cfargument name="objectTypeList" default="table,view"       type="any" _type="string" hint="I am a comma-delimited list of object types" />

    <cfset var qObject = 0 />

		<cfquery name="qObject"   datasource="#getDsn()#" username="#getUsername()#" password="#getPassword()#">
			SELECT   object_name
			FROM     all_objects
			where object_type in ( <cfqueryparam value="#ucase(arguments.objectTypeList)#" cfsqltype="CF_SQL_VARCHAR" maxlength="64" list="Yes"> )
			and	 
        (   object_name   = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="64" value="#arguments.ObjectName#" />
         or object_name   = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="64" value="#ucase(arguments.ObjectName )#" />
         or upper(object_name) = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="64" value="#ucase(arguments.ObjectName)#" /> )
      order by case
         when object_name = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="64" value="#arguments.ObjectName#" /> then 1
         when upper(object_name) = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="64" value="#ucase(arguments.ObjectName)#" /> then 2
         else 3
       end
		</cfquery>
    <cfif qObject.recordCount is 0>
			<cfthrow type="reactor.NoSuchObject" />
		</cfif>
		<cfreturn qObject.object_name />
	</cffunction>

	<cffunction name="readFields" access="private" hint="I populate the table with fields." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to read fields into." required="yes" type="any" _type="reactor.core.object" />
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
                      /* oracle returns  4000 for clobs which is the length of what Oracle stores inline in the record. However, oracle can store several gb out of line. */
                      when col.data_type in ('CLOB','BLOB')   then 20000000
                      /* Oracle can compress a number in a smaller field so use precision if available */
                      else nvl(col.data_precision, col.data_length)
                    end                   as length,
                    col.data_scale        as scale,
                    col.DATA_DEFAULT      as "DEFAULT",
				    CASE
                          WHEN updateCol.updatable = 'YES' THEN 'false'
                          ELSE 'true'
                    END                  as readonly
              FROM  all_tab_columns   col,
 				    all_updatable_columns updateCol,
                    ( select  colCon.column_name,
                   			  colcon.table_name
                    from   all_cons_columns  colCon,
                           all_constraints   tabCon
                    where tabCon.table_name = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="128" value="#arguments.Object.getName()#" />
                         AND colCon.CONSTRAINT_NAME = tabCon.CONSTRAINT_NAME
                         AND colCon.TABLE_NAME      = tabCon.TABLE_NAME
                         AND 'P'                    = tabCon.CONSTRAINT_TYPE
                   ) primaryConstraints
              where col.table_name = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="128" value="#arguments.Object.getName()#" />
              		and col.COLUMN_NAME        = primaryConstraints.COLUMN_NAME (+)
                    AND col.TABLE_NAME       = primaryConstraints.TABLE_NAME (+)
					and updateCol.table_name  (+) = col.table_name 
					and updateCol.COLUMN_NAME (+) = col.COLUMN_NAME 
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
			<cfset Field.scale        = qFields.scale />
			<cfset Field.default      = getDefault(qFields.default, Field.cfDataType, Field.nullable) />
			<cfset Field.sequenceName = "" />
    	<cfset Field.readOnly     = qFields.readonly />
      
			<!--- add the field to the table --->
			<cfset arguments.Object.addField(Field) />
		</cfloop>
	</cffunction>

	<cffunction name="getDefault" access="public" hint="I get a default value for a cf datatype." output="false" returntype="any" _returntype="string">
		<cfargument name="sqlDefaultValue" hint="I am the default value defined by SQL." 	 required="yes" type="any" _type="string" />
		<cfargument name="typeName" hint="I am the cf type name to get a default value for." required="yes" type="any" _type="string" />
		<cfargument name="nullable" hint="I indicate if the column is nullable." 			 required="yes" type="any" _type="boolean" />

		<cfset arguments.sqlDefaultValue = trim(arguments.sqlDefaultValue)/>

		<!--- strip out any parens --->
		<cfif left(arguments.sqlDefaultValue,1) is "(" and right(arguments.sqlDefaultValue,1) is ")">
			<cfset arguments.sqlDefaultValue = mid(arguments.sqlDefaultValue,2,len(arguments.sqlDefaultValue)-2) />
		</cfif>

		<!--- strip out any single quotes --->
		<cfif left(arguments.sqlDefaultValue,1) is "'" and right(arguments.sqlDefaultValue,1) is "'">
			<cfset arguments.sqlDefaultValue = mid(arguments.sqlDefaultValue,2,len(arguments.sqlDefaultValue)-2) />
		</cfif>
			<cfif compareNocase(arguments.typename, "NUMERIC") is 0>
				<cfif IsNumeric(arguments.sqlDefaultValue)>
					<cfreturn arguments.sqlDefaultValue />
				<cfelseif arguments.nullable>
					<cfreturn "" />
				<cfelse>
					<cfreturn 0 />
				</cfif>
			
			<cfelseif compareNocase(arguments.typename, "STRING") is 0>
				<cfif FindNoCase("SYS_GUID()", arguments.sqlDefaultValue) gt 0>
					<cfreturn "##replace(CreateUUID(),'-','','all')##" />
				<cfelse>
   				<cfreturn arguments.sqlDefaultValue  />
   			</cfif>
				<cfreturn arguments.sqlDefaultValue  />
			
			<cfelseif  compareNocase(arguments.typename, "DATE") is 0 
              or compareNocase(arguments.typename, "TIMESTAMP") is 0>
				<cfif arguments.sqlDefaultValue IS "SYSDATE">
					<cfreturn "##Now()##" />
				<cfelse>
   				<cfreturn arguments.sqlDefaultValue  />
   			</cfif>
			
			<cfelse>
				<cfreturn "" />
			
		</cfif>
	</cffunction>

	<cffunction name="getCfSqlType" access="private" hint="I translate the Oracle data type names into ColdFusion cf_sql_xyz names" output="false" returntype="any" _returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="any" _type="string" />
        <!--- most commonly used --->
		<cfif compareNocase(arguments.typename, "varchar2") is 0>
				<cfreturn "cf_sql_varchar" />
			<cfelseif compareNocase(arguments.typename, "timestamp(6)") is 0>
				<cfreturn "cf_sql_date" />
			<cfelseif compareNocase(arguments.typename, "integer") is 0>
				<cfreturn "cf_sql_numeric" />
			<cfelseif compareNocase(arguments.typename, "number") is 0>
				<cfreturn "cf_sql_numeric" />

        <!--- misc --->
			<cfelseif compareNocase(arguments.typename, "rowid") is 0>
				<cfreturn "cf_sql_varchar" />
			
			<!--- time --->
			<cfelseif compareNocase(arguments.typename, "date") is 0>
				<cfreturn "cf_sql_timestamp" />

         <!--- strings --->
			<cfelseif compareNocase(arguments.typename, "char") is 0>
				<cfreturn "cf_sql_char" />
			<cfelseif compareNocase(arguments.typename, "nchar") is 0>
				<cfreturn "cf_sql_char" />
			<cfelseif compareNocase(arguments.typename, "varchar") is 0>
				<cfreturn "cf_sql_varchar" />
			<cfelseif compareNocase(arguments.typename, "nvarchar2") is 0>
				<cfreturn "cf_sql_varchar" />
			
			<!--- long types --->
			<!---   @@Note: bfile  not supported --->
			<cfelseif compareNocase(arguments.typename, "blob") is 0>
				<cfreturn "cf_sql_blob" />
			<cfelseif compareNocase(arguments.typename, "clob") is 0>
				<cfreturn "cf_sql_clob" />
			<cfelseif compareNocase(arguments.typename, "nclob") is 0>
				<cfreturn "cf_sql_clob" />
			<cfelseif compareNocase(arguments.typename, "long") is 0>
				<cfreturn "cf_sql_longvarchar" />
			
			   <!--- @@Note: may need "tobinary(ToBase64(x))" when updating --->
			<cfelseif compareNocase(arguments.typename, "long raw") is 0>
				<cfreturn "cf_sql_longvarbinary" />
			<cfelseif compareNocase(arguments.typename, "raw") is 0>
			   <!--- @@Note: may need "tobinary(ToBase64(x))" when updating --->
				<cfreturn "cf_sql_varbinary" />
			
			<!--- numerics --->
			<cfelseif compareNocase(arguments.typename, "float") is 0>
				<cfreturn "cf_sql_float" />
			<cfelseif compareNocase(arguments.typename, "real") is 0>
				<cfreturn "cf_sql_numeric" />
			
		</cfif>
		<cfthrow message="Unsupported (or incorrectly supported) database datatype: #arguments.typeName#." />
	</cffunction>

	<cffunction name="getCfDataType" access="private" hint="I translate the Oracle data type names into ColdFusion data type names" output="false" returntype="any" _returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="any" _type="string" />

		<!--- most commonly used types --->
		<cfif compareNocase(arguments.typename, "varchar2") is 0>
				<cfreturn "string" />
			<cfelseif compareNocase(arguments.typename, "date") is 0>
				<cfreturn "date" />
			<cfelseif compareNocase(arguments.typename, "integer") is 0>
				<cfreturn "numeric" />
			<cfelseif compareNocase(arguments.typename, "number") is 0>
				<cfreturn "numeric" />

        <!--- misc --->
			<cfelseif compareNocase(arguments.typename, "rowid") is 0>
				<cfreturn "string" />
			
			<!--- time --->
			
			<cfelseif compareNocase(arguments.typename, "timestamp(6)") is 0>
				<cfreturn "date" />
			
            <!--- strings --->
			<cfelseif compareNocase(arguments.typename, "char") is 0>
				<cfreturn "string" />		
			<cfelseif compareNocase(arguments.typename, "nchar") is 0>
				<cfreturn "string" />
			<cfelseif compareNocase(arguments.typename, "varchar") is 0>
				<cfreturn "string" />
			<cfelseif compareNocase(arguments.typename, "nvarchar2") is 0>
				<cfreturn "string" />
			
			<!--- long --->
			<!---   @@Note: bfile  not supported --->
			<cfelseif compareNocase(arguments.typename, "blob") is 0>
				<cfreturn "binary" />
			<cfelseif compareNocase(arguments.typename, "clob") is 0>
				<cfreturn "string" />
			<cfelseif compareNocase(arguments.typename, "nclob") is 0>
				<cfreturn "string" />
			<cfelseif compareNocase(arguments.typename, "long") is 0>
				<cfreturn "string" />
		   <cfelseif compareNocase(arguments.typename, "long raw") is 0>
				<cfreturn "binary" />
			<cfelseif compareNocase(arguments.typename, "raw") is 0>
				<cfreturn "binary" />
			
			<!--- numerics --->
			<cfelseif compareNocase(arguments.typename, "float") is 0>
				<cfreturn "numeric" />
			<cfelseif compareNocase(arguments.typename, "real") is 0>
				<cfreturn "numeric" />
		
		</cfif>

		<cfthrow message="Unsupported (or incorrectly supported) database datatype: #arguments.typeName#." />

	</cffunction>

</cfcomponent>