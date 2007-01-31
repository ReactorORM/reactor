 <cfcomponent hint="I read Object data from a Oracle database." extends="reactor.data.abstractObjectDao">

	<cffunction name="read" access="public" hint="I populate an Object object based on it's name" output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to populate." required="yes" type="any" _type="reactor.core.object" />

		<!--- get all field data --->
		<cfset readObject(arguments.Object) />
		<cfset readFields(arguments.Object) />
	</cffunction>


	<cffunction name="readObject" access="private" hint="I confirm that this object exists at all.  If not, I throw an error." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to check on." required="yes" type="any" _type="reactor.core.object" />
      <!--- @@Note: added "var" --->
     <cfset var qObject = 0 />
     <cfset var thisType = "" />

    <!--- this query uses views that should be the same in "Adaptive Server Anywhere" and "Adaptive Server Enterprise" --->
		<cfquery name="qObject"   datasource="#getDsn()#" username="#getUsername()#" password="#getPassword()#">
				select sysobjects.type as object_type ,
				       sysusers.name   as table_owner
				from dbo.sysobjects
				,    dbo.sysusers
				<!--- V - views; U - User tables; S - System tables --->
				where sysobjects.type in ('V','U','S')
				and   sysusers.uid = sysobjects.uid
                and   sysusers.name = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="128" value="#arguments.Object.getName()#" />
				and   sysobjects.name =
			   <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="128" value="#arguments.Object.getName()#" />
		</cfquery>

		<cfif qObject.recordCount>
			<!--- set the owner --->
			<cfset arguments.Object.setOwner( qObject.table_owner ) />
			<!--- set the type --->
			<cfswitch expression="#qObject.object_type#"  >
			  <cfcase value="V">
			    <cfset thisType = "view">
			  </cfcase>
			  <cfcase value="U,S">  <!--- U for user table and S for system table --->
			    <cfset thisType = "table">
			  </cfcase>
			</cfswitch>
			<cfset arguments.Object.setType( thisType ) />
		<cfelse>
			<cfthrow type="reactor.NoSuchObject" />
		</cfif>
	</cffunction>


	<cffunction name="readFields" access="private" hint="I populate the table with fields." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to read fields into." required="yes" type="any" _type="reactor.core.object" />
		<cfset var qFields = 0 />
		<cfset var Field = 0 />

    <!--- this query uses tables that may not "Adaptive Server Enterprise" --->
		<cfquery name="qFields"  datasource="#getDsn()#" username="#getUsername()#" password="#getPassword()#">
				select
				  syscolumn.column_name     as name,
				  cast((if syscolumn.pkey = 'Y' then 'true' else 'false' endif) as varchar) primaryKey,
				  cast((if syscolumn."default" is not null and (syscolumn."default" = 'autoincrement' or syscolumn."default" = 'global autoincrement') then 'true' else 'false' endif) as varchar) identity,
				  cast((if syscolumn.nulls = 'Y' then 'true' else 'false' endif) as varchar) nullable,
				  sysdomain.domain_name     as dbdatatype ,
				  case
				    when sysdomain.domain_name = 'date' then 26
				    else syscolumn.width
				  end                       as "length",
				  syscolumn."default"
				from syscolumn
				    left outer join sysdomain
				        on syscolumn.domain_id  = sysdomain.domain_id
				,   systable
				where   syscolumn.table_id = systable.table_id
				and   syscolumn.column_type <> 'C' <!--- not computed --->
				and   systable.table_name = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="128" value="#arguments.Object.getName()#" />
				and   systable.table_type in ('BASE','VIEW')  <!---> BASE for base tables, VIEW for views, and GBL TEMP for global temporary tables --->
				order by syscolumn.column_id
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
				<cfif arguments.sqlDefaultValue IS "NEWID()">
					<cfreturn "##replace(CreateUUID(),'-','','all')##" />
				<cfelse>
   				<cfreturn arguments.sqlDefaultValue  />
   			</cfif>
			</cfcase>
			<cfcase value="DATE,TIMESTAMP">
				<cfif IsDate(arguments.sqlDefaultValue)>
					<cfreturn arguments.sqlDefaultValue />
				<cfelseif arguments.sqlDefaultValue IS "current date">
					<cfreturn "##Now()##" />
				<cfelse>
   				<cfreturn arguments.sqlDefaultValue  />
   			</cfif>
			</cfcase>
			<cfcase value="binary">
				<cfif IsBinary(arguments.sqlDefaultValue)>
					<cfreturn arguments.sqlDefaultValue />
				<cfelseif arguments.sqlDefaultValue IS "NEWID()">
					<cfreturn "##replace(CreateUUID(),'-','','all')##" />
				<cfelse>
   				<cfreturn arguments.sqlDefaultValue  />
   			</cfif>
			</cfcase>
			<cfcase value="boolean">
				<cfif IsBoolean(arguments.sqlDefaultValue)>
					<cfreturn Iif(arguments.sqlDefaultValue, DE(true), DE(false)) />
				<cfelse>
					<cfreturn false />
				</cfif>
			</cfcase>

			<cfdefaultcase>
				<cfreturn "" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="getCfSqlType" access="private" hint="I translate the Oracle data type names into ColdFusion cf_sql_xyz names" output="false" returntype="any" _returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="any" _type="string" />
		<cfswitch expression="#lcase(arguments.typeName)#">
      <!--- Numeric --->
			<cfcase value="numeric">		    		<cfreturn "cf_sql_numeric" />		</cfcase>
			<cfcase value="bigint">    				  <cfreturn "cf_sql_numeric" />		</cfcase>
			<cfcase value="decimal">				    <cfreturn "cf_sql_numeric" />		</cfcase>
			<cfcase value="double">				      <cfreturn "cf_sql_double" />		</cfcase>
			<cfcase value="float">				      <cfreturn "cf_sql_numeric" />		</cfcase>
			<cfcase value="integer">				    <cfreturn "cf_sql_numeric" />		</cfcase>
			<cfcase value="smallint">				    <cfreturn "cf_sql_numeric" />		</cfcase>
			<cfcase value="tinyint">				    <cfreturn "cf_sql_numeric" />		</cfcase>
			<cfcase value="unsigned bigint">		<cfreturn "cf_sql_numeric" />		</cfcase>
			<cfcase value="unsigned int">				<cfreturn "cf_sql_numeric" />		</cfcase>
			<cfcase value="unsigned smallint">	<cfreturn "cf_sql_numeric" />		</cfcase>
         <!--- strings --->
			<cfcase value="char">		        		<cfreturn "cf_sql_char" />			</cfcase>
			<cfcase value="varchar">				    <cfreturn "cf_sql_varchar" />		</cfcase>
         <!--- dates and times --->
			<cfcase value="date">				        <cfreturn "cf_sql_timestamp" />	</cfcase>
			<cfcase value="timestamp">				  <cfreturn "cf_sql_timestamp" />	</cfcase>
			<cfcase value="time">		        		<cfreturn "cf_sql_timestamp" />	</cfcase>
         <!--- binary --->
        			  <!--- uuid --->
			<cfcase value="uniqueidentifier">		<cfreturn "cf_sql_binary" />		</cfcase>
			<cfcase value="binary">			      	<cfreturn "cf_sql_varbinary" />	</cfcase>
			<cfcase value="varbinary">				  <cfreturn "cf_sql_varbinary" />	</cfcase>
         <!--- bit --->
			<cfcase value="bit">				        <cfreturn "cf_sql_bit" />			  </cfcase>
			   <!---- long types --->
					   <!--- @@Note: may need "tobinary(ToBase64(x))" when updating --->
			<cfcase value="long binary">				<cfreturn "cf_sql_blob" />			</cfcase>
			<cfcase value="long varchar">				<cfreturn "cf_sql_clob" />			</cfcase>
		</cfswitch>
		<cfthrow message="Unsupported (or incorrectly supported) database datatype: #arguments.typeName#." />
	</cffunction>

	<cffunction name="getCfDataType" access="private" hint="I translate the Oracle data type names into ColdFusion data type names" output="false" returntype="any" _returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="any" _type="string" />

		<cfswitch expression="#arguments.typeName#">
          <!--- Numeric --->
			<cfcase value="numeric">		    		<cfreturn "numeric" />	</cfcase>
			<cfcase value="bigint">    				  <cfreturn "numeric" />	</cfcase>
			<cfcase value="decimal">				    <cfreturn "numeric" />	</cfcase>
			<cfcase value="double">				      <cfreturn "numeric" />	</cfcase>
			<cfcase value="float">				      <cfreturn "numeric" />	</cfcase>
			<cfcase value="integer">				    <cfreturn "numeric" />	</cfcase>
			<cfcase value="smallint">				    <cfreturn "numeric" />	</cfcase>
			<cfcase value="tinyint">				    <cfreturn "numeric" />	</cfcase>
			<cfcase value="uniqueidentifier">		<cfreturn "numeric" />	</cfcase>
			<cfcase value="unsigned bigint">		<cfreturn "numeric" />	</cfcase>
			<cfcase value="unsigned int">				<cfreturn "numeric" />	</cfcase>
			<cfcase value="unsigned smallint">	<cfreturn "numeric" />	</cfcase>
         <!--- strings --->
			<cfcase value="char">		        		<cfreturn "string" />		</cfcase>
			<cfcase value="varchar">				    <cfreturn "string" />		</cfcase>
         <!--- dates and times --->
			<cfcase value="date">				        <cfreturn "date" />	    </cfcase>
			<cfcase value="timestamp">				  <cfreturn "date" />	    </cfcase>
			<cfcase value="time">		        		<cfreturn "date" />	    </cfcase>
         <!--- binary --->
			<cfcase value="binary">			      	<cfreturn "binary" />	  </cfcase>
			<cfcase value="varbinary">				  <cfreturn "binary" />	  </cfcase>
         <!--- boolean --->
			<cfcase value="bit">				        <cfreturn "boolean" />	</cfcase>
			   <!---- long types --->
					   <!--- @@Note: may need "tobinary(ToBase64(x))" when updating --->
			<cfcase value="long binary">				<cfreturn "binary" />		</cfcase>
			<cfcase value="long varchar">				<cfreturn "string" />		</cfcase>
		</cfswitch>

		<cfthrow message="Unsupported (or incorrectly supported) database datatype: #arguments.typeName#." />

	</cffunction>

</cfcomponent>
