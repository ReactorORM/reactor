
<cfcomponent hint="I am the base Metadata object for the Address table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractMetadata" >
	
	<cfset variables.signature = "83C36EF059D7F69183D9588239ABED3E" >
	
	<cfset variables.metadata.name = "Address" />
	<cfset variables.metadata.owner = "dbo" />
	<cfset variables.metadata.type = "table" />
	<cfset variables.metadata.database = "scratch" />
	<cfset variables.metadata.dbms = "mssql" />
	
	<!--- Super Object --->
	<cfset variables.metadata.super = structNew() />
	
	
	<!--- Has One --->
	<cfset variables.metadata.hasOne = ArrayNew(1) />
	
	
	<!--- Has Many --->
	<cfset variables.metadata.hasMany = ArrayNew(1) />
	
		<cfset variables.metadata.hasMany[1] = StructNew() />
		<cfset variables.metadata.hasMany[1].name = "Customer" />
		<cfset variables.metadata.hasMany[1].alias = "Customer" />
		
		
				<cfset variables.metadata.hasMany[1].relate = ArrayNew(1) />
			
				
					<cfset variables.metadata.hasMany[1].relate[1] = StructNew() />
					<cfset variables.metadata.hasMany[1].relate[1].from = "addressId" />
					<cfset variables.metadata.hasMany[1].relate[1].to = "addressId" />
				
	
	<!--- Fields --->
	<cfset variables.metadata.fields = ArrayNew(1) />
	
		<cfset variables.metadata.fields[1] = StructNew() />
		<cfset variables.metadata.fields[1]["name"] = "AddressId" />
		<cfset variables.metadata.fields[1]["primaryKey"] = "true" />
		<cfset variables.metadata.fields[1]["identity"] = "true" />
		<cfset variables.metadata.fields[1]["nullable"] = "false" />
		<cfset variables.metadata.fields[1]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[1]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[1]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[1]["length"] = "0" />
		<cfset variables.metadata.fields[1]["default"] = "0" />
		<!--- cfset variables.metadata.fields[1]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[1]["object"] = "Address" />
	
		<cfset variables.metadata.fields[2] = StructNew() />
		<cfset variables.metadata.fields[2]["name"] = "Street1" />
		<cfset variables.metadata.fields[2]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[2]["identity"] = "false" />
		<cfset variables.metadata.fields[2]["nullable"] = "false" />
		<cfset variables.metadata.fields[2]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[2]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[2]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[2]["length"] = "50" />
		<cfset variables.metadata.fields[2]["default"] = "" />
		<!--- cfset variables.metadata.fields[2]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[2]["object"] = "Address" />
	
		<cfset variables.metadata.fields[3] = StructNew() />
		<cfset variables.metadata.fields[3]["name"] = "Street2" />
		<cfset variables.metadata.fields[3]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[3]["identity"] = "false" />
		<cfset variables.metadata.fields[3]["nullable"] = "true" />
		<cfset variables.metadata.fields[3]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[3]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[3]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[3]["length"] = "50" />
		<cfset variables.metadata.fields[3]["default"] = "" />
		<!--- cfset variables.metadata.fields[3]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[3]["object"] = "Address" />
	
		<cfset variables.metadata.fields[4] = StructNew() />
		<cfset variables.metadata.fields[4]["name"] = "City" />
		<cfset variables.metadata.fields[4]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[4]["identity"] = "false" />
		<cfset variables.metadata.fields[4]["nullable"] = "false" />
		<cfset variables.metadata.fields[4]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[4]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[4]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[4]["length"] = "50" />
		<cfset variables.metadata.fields[4]["default"] = "" />
		<!--- cfset variables.metadata.fields[4]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[4]["object"] = "Address" />
	
		<cfset variables.metadata.fields[5] = StructNew() />
		<cfset variables.metadata.fields[5]["name"] = "State" />
		<cfset variables.metadata.fields[5]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[5]["identity"] = "false" />
		<cfset variables.metadata.fields[5]["nullable"] = "false" />
		<cfset variables.metadata.fields[5]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[5]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[5]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[5]["length"] = "50" />
		<cfset variables.metadata.fields[5]["default"] = "" />
		<!--- cfset variables.metadata.fields[5]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[5]["object"] = "Address" />
	
		<cfset variables.metadata.fields[6] = StructNew() />
		<cfset variables.metadata.fields[6]["name"] = "Zip" />
		<cfset variables.metadata.fields[6]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[6]["identity"] = "false" />
		<cfset variables.metadata.fields[6]["nullable"] = "false" />
		<cfset variables.metadata.fields[6]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[6]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[6]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[6]["length"] = "10" />
		<cfset variables.metadata.fields[6]["default"] = "" />
		<!--- cfset variables.metadata.fields[6]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[6]["object"] = "Address" />
	
	
	<cffunction name="dumpVariables">
		<cfdump var="#variables#" > <cfabort >
	</cffunction>
		
</cfcomponent>
	
