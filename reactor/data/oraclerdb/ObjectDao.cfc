<cfcomponent hint="I read Object data from a Oracle rdb database." extends="reactor.data.abstractObjectDao">

	<cffunction name="read" access="public" hint="I populate an Object object based on it's name" output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to populate." required="yes" type="any" _type="reactor.core.object" />

		<!--- get all field data --->
		<cfset readObject(arguments.Object) />
		<cfset readFields(arguments.Object) />
	</cffunction>


	<cffunction name="readObject" access="private" hint="I confirm that this object exists at all.  If not, I throw an error." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to check on." required="yes" type="any" _type="reactor.core.object" />
		<cfset var qObject = 0 />
		<!--- "rdb$System_Flag = 0" excludes retrieve system tables and views --->
		<cfquery name="qObject"   datasource="#getDsn()#" username="#getUsername()#" password="#getPassword()#">
		select 'TABLE'	table_type
		from rdb$Relations
		where (rdb$System_Flag = 0 or rdb$System_Flag is null)
			AND  rdb$View_Source is null
			and  rdb$Relation_name =
			   <cfqueryparam
							cfsqltype="cf_sql_varchar"
							maxlength="31"
							value="#ucase(arguments.Object.getName())#" />
		union all
		select 'VIEW'	table_type
		from rdb$Relations
		where (rdb$System_Flag = 0 or rdb$System_Flag is null)
			AND  rdb$View_Source is not null
			and  rdb$Relation_name =
			   <cfqueryparam
							cfsqltype="cf_sql_varchar"
							maxlength="31"
							value="#ucase(arguments.Object.getName())#" />
		</cfquery>

		<cfif qObject.recordCount>
			<cfset arguments.Object.setType(lcase(qObject.table_type)) />
		<cfelse>
			<cfthrow type="reactor.NoSuchObject" />
		</cfif>
	</cffunction>


	<cffunction name="readFields" access="private" hint="I populate the table with fields." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to read fields into." required="yes" type="any" _type="reactor.core.object" />
		<cfset var qFields = 0 />
		<cfset var Field = 0 />
		<cfset var thisDefault = "" />
<!--- source: http://starlet.deltatel.ru/sys$common/syshlp/sql$dclhelp.hlp
	  3  All_System_Relations
   The Oracle Rdb system relations are as follows:

   RDB$CATALOG_SCHEMA          Contains the name and definition of
                               each SQL catalog and schema. This
                               relation is present only in databases
                               with the SQL multischema feature
                               enabled.
   RDB$COLLATIONS              The collating sequences used by this
                               database.
   RDB$CONSTRAINTS             Name and definition of each
                               constraint.
   RDB$CONSTRAINT_RELATIONS    Name of each relation that
                               participates in a given constraint.
   RDB$DATABASE                Database specific information.
   RDB$FIELD_VERSIONS          One record for each version of each
                               field definition in the database.
   RDB$FIELDS                  Characteristics of each field in the
                               database.
   RDB$INDEX_SEGMENTS          Fields that make up keys for
                               relations.
   RDB$INDICES                 Characteristics of the indexes for
                               each relation.
   RDB$INTERRELATIONS          Interdependencies of entities used in
                               the database.
   RDB$MODULES                 Module definition as defined by
                               a user, including the header and
                               declaration section.
   RDB$PARAMETERS              Interface definition for each
                               routine stored in RDB$ROUTINES. Each
                               parameter to a routine (procedure or
                               function) is described by a row in
                               RDB$PARAMETERS.
   RDB$PRIVILEGES              Protection for the database,
                               relations, views, and fields.
   RDB$QUERY_OUTLINES          Query outline definitions used by
                               the optimizer to retrieve known query
                               outlines prior to optimization.
   RDB$RELATION_CONSTRAINTS    Lists all relation-specific
                               constraints.
   RDB$RELATION_CONSTRAINT_    Lists the fields that participate
   FLDS                        in unique, primary, or foreign key
                               declarations for relation-specific
                               constraints.
   RDB$RELATION_FIELDS         Fields defined for each relation.
   RDB$RELATIONS               Relations in the database.
   RDB$ROUTINES                Description of each routine (either
                               standalone or within a module.)
   RDB$STORAGE_MAPS            Characteristics of each storage map.
   RDB$STORAGE_MAP_AREAS       Characteristics of each storage area
                               referred to by a storage map.
   RDB$SYNONYMS                Connects an object's user- specified
                               name to its internal database name.
                               This relation is only present in
                               databases with the SQL multischema
                               feature enabled.
   RDB$TRIGGERS                Definition of a trigger.
   RDB$VIEW_RELATIONS          Interdependencies of relations used
                               in views.
   RDB$WORKLOAD                Collects workload information.
--->

		<!--- possible values for RDB$CONSTRAINT_TYPE are
			  1     RDB$K_CON_CONDITION         Requires conditional expression
			                                     constraint.
			   2     RDB$K_CON_PRIMARY_KEY       Primary key constraint.
			   3     RDB$K_CON_REFERENTIAL       Referential (foreign key)
			                                     constraint.
			   4     RDB$K_CON_UNIQUE            Unique constraint.
			   5                                 Reserved for future use.
			   6     RDB$K_CON_NOT_NULL          Not null (missing) constraint.
			   7     RDB$K_CON_SINGLE_LEVEL      Used only by SERdb.
		--->
		<!---  Oracle rdb has no equivalent to autoincrement or identity  --->
		<cfquery name="qFields"  datasource="#getDsn()#" username="#getUsername()#" password="#getPassword()#">
			SELECT
			    trim( rdb$relations.rdb$relation_name  ) as table_name,
			    trim( col.rdb$field_name           ) as name,
			    pkColumn.rdb$field_name   			as primarykey,
				'false'                      		as identity,
			    colcon.rdb$field_name  				as not_nullable,
			    rdb$fields.rdb$field_type    		as dbdatatype,
			    rdb$fields.rdb$field_length  	 	as length,
			    col.rdb$default_value  				as first_default,
			    rdb$fields.rdb$default_value  		as second_default
			from    RDB$RELATIONS
			 inner join RDB$RELATION_FIELDS 		 as col    on rdb$relations.rdb$relation_name = col.rdb$relation_name

			 left join  RDB$RELATION_CONSTRAINTS 	 as tabCon on col.rdb$relation_name = tabcon.rdb$relation_name
			 												   and tabCon.rdb$constraint_type = 6
			 left join  RDB$RELATION_CONSTRAINT_FLDS as colCon on col.rdb$field_name  = colcon.rdb$field_name
			 												   and tabcon.rdb$constraint_type = 6

			left join  RDB$RELATION_CONSTRAINTS 	 as pkTable on col.rdb$relation_name = pkTable.rdb$relation_name
			 												   and pkTable.rdb$constraint_type = 2
			left join  RDB$RELATION_CONSTRAINT_FLDS as pkColumn on col.rdb$field_name  = pkColumn.rdb$field_name
			 												   and pkTable.rdb$constraint_name = pkColumn.rdb$constraint_name
			 												   and pkTable.rdb$constraint_type = 2

			 left join  RDB$FIELDS 							   on col.rdb$field_source = rdb$fields.rdb$field_name
			where  rdb$relations.rdb$relation_name = <cfqueryparam
													cfsqltype="cf_sql_varchar"
													maxlength="31"
													value="#uCase(arguments.Object.getName())#" />
		</cfquery>
		
 		<cfloop query="qFields">
			<!--- create the field --->
			<cfset Field = StructNew() />
			<cfset Field.nmae = qFields.name />
			<cfif qFields.primaryKey is not "">
				<cfset Field.primaryKey = true />
			<cfelse>
				<cfset Field.primaryKey = false />
			</cfif>

			<cfset Field.identity = qFields.identity />
			<cfif qFields.not_nullable is "">
				<cfset Field.nullable = true />
			<cfelse>
				<cfset Field.nullable = false />
			</cfif>

			<cfset Field.dbDataType = qFields.dbDataType />
			<cfset Field.cfDataType = getCfDataType(qFields.dbDataType) />
			<cfset Field.cfSqlType = getCfSqlType(qFields.dbDataType) />
			<cfset Field.length = qFields.length />
 			<cfscript>
 				thisDefault = "";
 				if (first_default is "") {
 					thisDefault = second_default;
 				} else {
 					thisDefault = first_default;
 				}
 			</cfscript>
			<cfset Field.default = getDefault(first_default, Field.cfDataType, Field.nullable) />
			<cfset Field.sequenceName = "" />
			<cfset Field.readOnly = "false" />
			<cfset Field.scale = "0" />

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
   				<cfreturn arguments.sqlDefaultValue  />
			</cfcase>
			<cfcase value="DATE,TIMESTAMP">
				<cfswitch expression="#arguments.sqlDefaultValue#">
				 	<cfcase value="CURRENT_TIME"><cfreturn "##timeFormat(Now())##" /></cfcase>
				 	<cfcase value="CURRENT_DATE"><cfreturn "##DateFormat(Now())##" /></cfcase>
				 	<cfcase value="CURRENT_TIMESTAMP"><cfreturn "##Now()##" /></cfcase>
				 </cfswitch>
   				 <cfreturn arguments.sqlDefaultValue  />
			</cfcase>
			<cfdefaultcase>
				<cfreturn "" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="getCfSqlType" access="private" hint="I translate the Oracle data type names into ColdFusion cf_sql_xyz names" output="false" returntype="any" _returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="any" _type="string" />
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="14">	<cfreturn "cf_sql_varchar" /> </cfcase>	<!--- Character string--->
			<cfcase value="37">	<cfreturn "cf_sql_varchar"/> </cfcase>	<!--- Varying character string--->
			<cfcase value="15">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Numeric string, unsigned--->
			<cfcase value="16">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Numeric string, left separate sign--->
			<cfcase value="17">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Numeric string, left overpunched sign--->
			<cfcase value="18">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Numeric string, right separate sign--->
			<cfcase value="19">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Numeric string, right overpunched sign--->
			<cfcase value="20">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Numeric string, zoned sign--->
			<cfcase value="21">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Packed-decimal string--->
			<cfcase value="1">	<cfreturn "cf_sql_bit"/> 	 </cfcase>	<!--- Aligned bit string--->
			<cfcase value="34">	<cfreturn "cf_sql_bit"/> 	 </cfcase>	<!--- Unaligned bit string--->
			<cfcase value="35">	<cfreturn "cf_sql_timestamp"/> </cfcase>	<!--- Absolute date and time--->
			<cfcase value="3">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Word (unsigned)--->
			<cfcase value="4">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Longword (unsigned)--->
			<cfcase value="5">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Quadword (unsigned)--->
			<cfcase value="25">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Octaword (unsigned)--->
			<cfcase value="6">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Byte integer (signed)--->
			<cfcase value="7">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Word integer (signed)--->
			<cfcase value="8">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Longword integer (signed)--->
			<cfcase value="9">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Quadword integer (signed)--->
			<cfcase value="26">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- Octaword integer (signed)--->
			<cfcase value="10">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- F_floating--->
			<cfcase value="11">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- D_floating--->
			<cfcase value="27">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- G_floating--->
			<cfcase value="28">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- H_floating--->
			<cfcase value="12">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- F_floating complex--->
			<cfcase value="13">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- D_floating complex--->
			<cfcase value="29">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- G_floating complex--->
			<cfcase value="30">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- H_floating complex--->
			<cfcase value="52">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- S_floating--->
			<cfcase value="53">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- T_floating--->
			<cfcase value="54">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- S_floating complex--->
			<cfcase value="55">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- T_floating complex--->
			<cfcase value="57">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- X_floating--->
			<cfcase value="58">	<cfreturn "cf_sql_numeric"/> </cfcase>	<!--- X_floating complex--->
			<cfdefaultcase>
				<cfreturn "" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="getCfDataType" access="private" hint="I translate the Oracle rdb data type names into ColdFusion data type names" output="false" returntype="any" _returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="any" _type="string" />

		<cfswitch expression="#arguments.typeName#">
			<cfcase value="14">	<cfreturn "string"/> </cfcase>	<!--- Character string--->
			<cfcase value="37">	<cfreturn "string"/> </cfcase>	<!--- Varying character string--->
			<cfcase value="15">	<cfreturn "numeric"/> </cfcase>	<!--- Numeric string, unsigned--->
			<cfcase value="16">	<cfreturn "numeric"/> </cfcase>	<!--- Numeric string, left separate sign--->
			<cfcase value="17">	<cfreturn "numeric"/> </cfcase>	<!--- Numeric string, left overpunched sign--->
			<cfcase value="18">	<cfreturn "numeric"/> </cfcase>	<!--- Numeric string, right separate sign--->
			<cfcase value="19">	<cfreturn "numeric"/> </cfcase>	<!--- Numeric string, right overpunched sign--->
			<cfcase value="20">	<cfreturn "numeric"/> </cfcase>	<!--- Numeric string, zoned sign--->
			<cfcase value="21">	<cfreturn "numeric"/> </cfcase>	<!--- Packed-decimal string--->
			<cfcase value="1">	<cfreturn "boolean"/> </cfcase>	<!--- Aligned bit string--->
			<cfcase value="34">	<cfreturn "boolean"/> </cfcase>	<!--- Unaligned bit string--->
			<cfcase value="35">	<cfreturn "date"/> </cfcase>	<!--- Absolute date and time--->
			<cfcase value="3">	<cfreturn "numeric"/> </cfcase>	<!--- Word (unsigned)--->
			<cfcase value="4">	<cfreturn "numeric"/> </cfcase>	<!--- Longword (unsigned)--->
			<cfcase value="5">	<cfreturn "numeric"/> </cfcase>	<!--- Quadword (unsigned)--->
			<cfcase value="25">	<cfreturn "numeric"/> </cfcase>	<!--- Octaword (unsigned)--->
			<cfcase value="6">	<cfreturn "numeric"/> </cfcase>	<!--- Byte integer (signed)--->
			<cfcase value="7">	<cfreturn "numeric"/> </cfcase>	<!--- Word integer (signed)--->
			<cfcase value="8">	<cfreturn "numeric"/> </cfcase>	<!--- Longword integer (signed)--->
			<cfcase value="9">	<cfreturn "numeric"/> </cfcase>	<!--- Quadword integer (signed)--->
			<cfcase value="26">	<cfreturn "numeric"/> </cfcase>	<!--- Octaword integer (signed)--->
			<cfcase value="10">	<cfreturn "numeric"/> </cfcase>	<!--- F_floating--->
			<cfcase value="11">	<cfreturn "numeric"/> </cfcase>	<!--- D_floating--->
			<cfcase value="27">	<cfreturn "numeric"/> </cfcase>	<!--- G_floating--->
			<cfcase value="28">	<cfreturn "numeric"/> </cfcase>	<!--- H_floating--->
			<cfcase value="12">	<cfreturn "numeric"/> </cfcase>	<!--- F_floating complex--->
			<cfcase value="13">	<cfreturn "numeric"/> </cfcase>	<!--- D_floating complex--->
			<cfcase value="29">	<cfreturn "numeric"/> </cfcase>	<!--- G_floating complex--->
			<cfcase value="30">	<cfreturn "numeric"/> </cfcase>	<!--- H_floating complex--->
			<cfcase value="52">	<cfreturn "numeric"/> </cfcase>	<!--- S_floating--->
			<cfcase value="53">	<cfreturn "numeric"/> </cfcase>	<!--- T_floating--->
			<cfcase value="54">	<cfreturn "numeric"/> </cfcase>	<!--- S_floating complex--->
			<cfcase value="55">	<cfreturn "numeric"/> </cfcase>	<!--- T_floating complex--->
			<cfcase value="57">	<cfreturn "numeric"/> </cfcase>	<!--- X_floating--->
			<cfcase value="58">	<cfreturn "numeric"/> </cfcase>	<!--- X_floating complex--->
			<cfdefaultcase>
				<cfreturn "" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

</cfcomponent>

