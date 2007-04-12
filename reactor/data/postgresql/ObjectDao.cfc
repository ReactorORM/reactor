<cfcomponent hint="I read Object data from a Postgresql database." extends="reactor.data.abstractObjectDao">
	<!--- 
	PostgreSQL support added by Clayton Partridge.
		  
	Current no support for Arrays or percision attributes of data-types
	Exotic datatypes might not work either.
		
	--->
	
	
	<cffunction name="read" access="public" hint="I populate an Object object based on it's name" output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to populate." required="yes" type="any" _type="reactor.core.object" />
		
		<!--- get all field data --->
		<cfset readObject(arguments.Object) />
		<cfset readFields(arguments.Object) />
	</cffunction>

	<cffunction name="readObject" access="private" hint="I confirm that this object exists at all.  If not, I throw an error." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to check on." required="yes" type="any" _type="reactor.core.object" />
		<cfset var qObject = 0 />
		
		<cfquery name="qObject" datasource="#getDsn()#" username="#getUsername()#" password="#getPassword()#">
			SELECT 
			current_database() AS DATABASE_NAME, 
			nc.nspname AS table_schema, 
			c.relname AS table_name, 
			u.usename AS table_owner,
			CASE 
				WHEN (nc.nspname ~~ like_escape('pg!_temp!_%', '!')) THEN 'LOCAL TEMPORARY' 
				WHEN (c.relkind = 'r') THEN 'TABLE'
				WHEN (c.relkind = 'v') THEN 'VIEW' 
				ELSE NULL::text 
			END AS table_type
			
			FROM 
			pg_namespace nc, 
			pg_class c, 
			pg_user u 
			WHERE 
			(
				(
					(c.relnamespace = nc.oid) 
					AND 
					(u.usesysid = c.relowner)
				) 
				AND 
				(
					(c.relkind = 'r')
					OR 
					(c.relkind = 'v')
				)
			)
			AND c.relname = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="63" value="#arguments.Object.getName()#" />
		</cfquery>
		
		<cfif qObject.recordCount>
			<!--- set the owner --->
			<cfset arguments.Object.setDatabase(qObject.DATABASE_NAME) />
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
			
			c.relname AS table_name, 
			
			a.attname AS name, 
			
			CASE 
			    WHEN (co.conkey IS NULL) THEN 'false'
				WHEN (a.attnum = ANY (co.conkey)) THEN 'true'
				ELSE 'false'
			END as primaryKey,
			
			CASE 
				WHEN ad.adsrc LIKE 'nextval(%' THEN 'true'
				ELSE 'false'
			END as identity,
			
			CASE 
				WHEN (a.attnotnull OR ((t.typtype = 'd') AND t.typnotnull)) THEN 'false' 
				ELSE 'true' 
			END AS nullable, 
			
			CASE 
				WHEN (t.typtype = 'd') THEN CASE 
					WHEN ((bt.typelem <> 0) AND (bt.typlen = -1)) THEN 'ARRAY' 
					WHEN (nbt.nspname = 'pg_catalog') THEN format_type(t.typbasetype, NULL) 
					ELSE 'USER-DEFINED' 
				END 
				ELSE CASE 
					WHEN ((t.typelem <> (0)::oid) AND (t.typlen = -1)) THEN 'ARRAY' 
					WHEN (nt.nspname = 'pg_catalog') THEN format_type(a.atttypid, NULL) 
					ELSE 'USER-DEFINED'
				END 
			END AS dbDataType, 
			
			information_schema._pg_char_max_length(information_schema._pg_truetypid(a.*, t.*), information_schema._pg_truetypmod(a.*, t.*)) AS length,
			
			ad.adsrc AS default
			
			FROM (pg_attribute a LEFT JOIN pg_attrdef ad ON ((a.attrelid = ad.adrelid) AND (a.attnum = ad.adnum))), 
			pg_class c LEFT JOIN pg_constraint co ON ((c.oid = co.conrelid) AND (co.contype = 'p')), 
			pg_namespace nc, 
			(
				(
					pg_type t 
					JOIN 
					pg_namespace nt 
					ON (t.typnamespace = nt.oid)
				) 
				LEFT JOIN 
				(
					pg_type bt 
					JOIN 
					pg_namespace nbt 
					ON (bt.typnamespace = nbt.oid)
				) 
				ON (
					(
						(t.typtype = 'd') 
						AND 
						(t.typbasetype = bt.oid)
					)
				)
			) 
			
			WHERE 
			(
				(
					(
						(
							(
								(
									
									(a.attrelid = c.oid) 
									AND 
									(a.atttypid = t.oid)
									
								) 
								AND 
								(nc.oid = c.relnamespace)
							) 
							AND 
							(a.attnum > 0)
						) 
						AND 
						(NOT a.attisdropped)
					) 
					AND 
					(
						(c.relkind = 'r'::"char") 
						OR 
						(c.relkind = 'v'::"char")
					)
				) 
			)
			AND
			c.relname = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="63" value="#arguments.Object.getName()#" />
			order by a.attnum
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
			<cfif qFields.dbDataType eq "text">
				<cfset Field.length = 2147483647 /> <!--- the actual value for text is unlimited, with up to 1.6TB per row --->
			<cfelse>
				<cfset Field.length = val(qFields.length) />
			</cfif>
			<cfset Field.default = getDefault(qFields.default, Field.cfDataType, Field.nullable) />
			<cfif qFields.identity eq "true">
				<cfset Field.sequenceName = Replace(ListGetAt(qFields.default,2,"'"""),"public.","") />
			<cfelse>
				<cfset Field.sequenceName = "" >
			</cfif>
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
					<cfreturn val(arguments.sqlDefaultValue) />
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
					<cfreturn Iif(val(arguments.sqlDefaultValue), DE(true), DE(false)) />
				<cfelse>
					<cfreturn false />
				</cfif>
			</cfcase>
			<cfcase value="string">
				<!--- insure that the first and last characters are "'" --->
				
				<cfif Left(arguments.sqlDefaultValue, 1) IS "'" AND Right(arguments.sqlDefaultValue, 1) IS "'">
					<!--- taken from the mssql ObjectDao.cfc --->
					<!--- mssql functions must be constants.  for this reason I can convert anything quoted in single quotes safely to a string --->
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
				<cfelseif ListFind("CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,LOCALTIME,LOCALTIMESTAMP",arguments.sqlDefaultValue)>
					<!--- percision can be added to CURRENT_TIME,CURRENT_TIMESTAMP,LOCALTIME,LOCALTIMESTAMP add in later? --->
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
	
	<cffunction name="getCfSqlType" access="private" hint="I translate the Postgresql data type names into ColdFusion cf_sql_xyz names" output="false" returntype="any" _returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="any" _type="string" />
		
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="bigint,int8">
				<cfreturn "cf_sql_bigint" />
			</cfcase>
			<!---
			<cfcase value="bit">
				<cfreturn "cf_sql_binary" />
			</cfcase>
			<cfcase value="bit varying,varbit">
				<cfreturn "cf_sql_binary" />
			</cfcase>
			--->
			<cfcase value="boolean,bool">
				<cfreturn "cf_sql_bit" />
			</cfcase>
			<!---
			<cfcase value="box">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			--->
			<cfcase value="bytea">
				<cfreturn "cf_sql_longvarbinary" />
			</cfcase>
			<cfcase value="character varying,varchar">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="character,char">
				<cfreturn "cf_sql_char" />
			</cfcase>
			<!---
			<cfcase value="cidr">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="circle">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			--->
			<cfcase value="date">
				<cfreturn "cf_sql_date" />
			</cfcase>
			<cfcase value="double precision,float8">
				<cfreturn "cf_sql_float" />
			</cfcase>
			<!---
			<cfcase value="inet">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			--->
			<cfcase value="integer,int,int4">
				<cfreturn "cf_sql_integer" />
			</cfcase>
			<!---
			<cfcase value="interval">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="line">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="lseg">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="macaddr">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			--->
			<cfcase value="money">
				<cfreturn "cf_sql_money" />
			</cfcase>
			<cfcase value="numeric,decimal">
				<cfreturn "cf_sql_float" />
			</cfcase>
			<!---
			<cfcase value="path">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="point">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="polygon">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			--->
			<cfcase value="real,float4">
				<cfreturn "cf_sql_float" />
			</cfcase>
			<cfcase value="smallint,int2">
				<cfreturn "cf_sql_smallint" />
			</cfcase>
			<cfcase value="serial,serial4">
				<cfreturn "cf_sql_integer" />
			</cfcase>
			<cfcase value="text">
				<cfreturn "cf_sql_longvarchar" />
			</cfcase>
			
			<!--- should precision be added to time values? --->
			<cfcase value="time">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="time with time zone,timez,time without time zone">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="timestamp">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="timestamp with time zone,timestamp without time zone">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="ARRAY">
				<cfthrow message="ARRAYs are not supported">
			</cfcase>
			<cfdefaultcase> 
				<cfthrow message="#arguments.typeName# datatypes are not supported">
			</cfdefaultcase>
		</cfswitch>
		
		<cfthrow message="Unsupported (or incorrectly supported) database datatype: #arguments.typeName#." />
	</cffunction>

	<cffunction name="getCfDataType" access="private" hint="I translate the Postgresql data type names into ColdFusion data type names" output="false" returntype="any" _returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="any" _type="string" />
		
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="bigint,int8">
				<cfreturn "numeric" />
			</cfcase>
			<!---
			<cfcase value="bit">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="bit varying,varbit">
				<cfreturn "binary" />
			</cfcase>
			--->
			<cfcase value="boolean,bool">
				<cfreturn "boolean" />
			</cfcase>
			<!---
			<cfcase value="box">
				<cfreturn "string" />
			</cfcase>--->
			<cfcase value="bytea">
				<cfreturn "binary" />
			</cfcase>
			
			<cfcase value="character varying,varchar">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="character,char">
				<cfreturn "string" />
			</cfcase>
			<!---
			<cfcase value="cidr">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="circle">
				<cfreturn "string" />
			</cfcase>
			--->
			<cfcase value="date">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="double precision,float8">
				<cfreturn "numeric" />
			</cfcase>
			<!---
			<cfcase value="inet">
				<cfreturn "string" />
			</cfcase>
			--->
			<cfcase value="integer,int,int4">
				<cfreturn "numeric" />
			</cfcase>
			<!---
			<cfcase value="interval">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="line">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="lseg">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="macaddr">
				<cfreturn "string" />
			</cfcase>
			--->
			<cfcase value="money">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="numeric,decimal">
				<cfreturn "numeric" />
			</cfcase>
			<!---
			<cfcase value="path">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="point">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="polygon">
				<cfreturn "string" />
			</cfcase>
			--->
			<cfcase value="real,float4">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="smallint,int2">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="serial,serial4">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="text">
				<cfreturn "string" />
			</cfcase>
			
			<!--- should precision be added to time values? --->
			<cfcase value="time">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="time with time zone,timez,time without time zone">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="timestamp">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="timestamp with time zone,timestamp without time zone">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="ARRAY">
				<cfthrow message="ARRAYs are not supported">
			</cfcase>
		</cfswitch>
	
		<cfthrow message="Unsupported (or incorrectly supported) database datatype: #arguments.typeName#." />
	</cffunction>

</cfcomponent>

