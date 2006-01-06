
<cfcomponent hint="I am the base Metadata object for the Customer table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractMetadata" >
	
	<cfset variables.signature = "CCA4E499673B1A3F1C864B58F500D055" >
	
	<cfset variables.metadata.name = "Customer" />
	<cfset variables.metadata.owner = "dbo" />
	<cfset variables.metadata.type = "table" />
	<cfset variables.metadata.database = "scratch" />
	<cfset variables.metadata.dbms = "mssql" />
	
	<!--- Super Object --->
	<cfset variables.metadata.super = structNew() />
	
	
	<!--- Has One --->
	<cfset variables.metadata.hasOne = ArrayNew(1) />
	
		<cfset variables.metadata.hasOne[1] = StructNew() />
		<cfset variables.metadata.hasOne[1].name = "Address" />
		<cfset variables.metadata.hasOne[1].alias = "Address" />
		<cfset variables.metadata.hasOne[1].relate = ArrayNew(1) />
		
		
			<cfset variables.metadata.hasOne[1].relate[1] = StructNew() />
			<cfset variables.metadata.hasOne[1].relate[1].from = "addressId" />
			<cfset variables.metadata.hasOne[1].relate[1].to = "addressId" />
		
	
	<!--- Has Many --->
	<cfset variables.metadata.hasMany = ArrayNew(1) />
	
	
	<!--- Fields --->
	<cfset variables.metadata.fields = ArrayNew(1) />
	
		<cfset variables.metadata.fields[1] = StructNew() />
		<cfset variables.metadata.fields[1]["name"] = "CustomerId" />
		<cfset variables.metadata.fields[1]["primaryKey"] = "true" />
		<cfset variables.metadata.fields[1]["identity"] = "true" />
		<cfset variables.metadata.fields[1]["nullable"] = "false" />
		<cfset variables.metadata.fields[1]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[1]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[1]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[1]["length"] = "0" />
		<cfset variables.metadata.fields[1]["default"] = "0" />
		<!--- cfset variables.metadata.fields[1]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[1]["object"] = "Customer" />
	
		<cfset variables.metadata.fields[2] = StructNew() />
		<cfset variables.metadata.fields[2]["name"] = "Username" />
		<cfset variables.metadata.fields[2]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[2]["identity"] = "false" />
		<cfset variables.metadata.fields[2]["nullable"] = "false" />
		<cfset variables.metadata.fields[2]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[2]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[2]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[2]["length"] = "50" />
		<cfset variables.metadata.fields[2]["default"] = "" />
		<!--- cfset variables.metadata.fields[2]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[2]["object"] = "Customer" />
	
		<cfset variables.metadata.fields[3] = StructNew() />
		<cfset variables.metadata.fields[3]["name"] = "Password" />
		<cfset variables.metadata.fields[3]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[3]["identity"] = "false" />
		<cfset variables.metadata.fields[3]["nullable"] = "false" />
		<cfset variables.metadata.fields[3]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[3]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[3]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[3]["length"] = "50" />
		<cfset variables.metadata.fields[3]["default"] = "" />
		<!--- cfset variables.metadata.fields[3]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[3]["object"] = "Customer" />
	
		<cfset variables.metadata.fields[4] = StructNew() />
		<cfset variables.metadata.fields[4]["name"] = "FirstName" />
		<cfset variables.metadata.fields[4]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[4]["identity"] = "false" />
		<cfset variables.metadata.fields[4]["nullable"] = "false" />
		<cfset variables.metadata.fields[4]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[4]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[4]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[4]["length"] = "50" />
		<cfset variables.metadata.fields[4]["default"] = "" />
		<!--- cfset variables.metadata.fields[4]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[4]["object"] = "Customer" />
	
		<cfset variables.metadata.fields[5] = StructNew() />
		<cfset variables.metadata.fields[5]["name"] = "LastName" />
		<cfset variables.metadata.fields[5]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[5]["identity"] = "false" />
		<cfset variables.metadata.fields[5]["nullable"] = "false" />
		<cfset variables.metadata.fields[5]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[5]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[5]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[5]["length"] = "50" />
		<cfset variables.metadata.fields[5]["default"] = "" />
		<!--- cfset variables.metadata.fields[5]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[5]["object"] = "Customer" />
	
		<cfset variables.metadata.fields[6] = StructNew() />
		<cfset variables.metadata.fields[6]["name"] = "DateCreated" />
		<cfset variables.metadata.fields[6]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[6]["identity"] = "false" />
		<cfset variables.metadata.fields[6]["nullable"] = "false" />
		<cfset variables.metadata.fields[6]["dbDataType"] = "datetime" />
		<cfset variables.metadata.fields[6]["cfDataType"] = "date" />
		<cfset variables.metadata.fields[6]["cfSqlType"] = "cf_sql_timestamp" />
		<cfset variables.metadata.fields[6]["length"] = "0" />
		<cfset variables.metadata.fields[6]["default"] = "#Now()#" />
		<!--- cfset variables.metadata.fields[6]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[6]["object"] = "Customer" />
	
		<cfset variables.metadata.fields[7] = StructNew() />
		<cfset variables.metadata.fields[7]["name"] = "AddressId" />
		<cfset variables.metadata.fields[7]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[7]["identity"] = "false" />
		<cfset variables.metadata.fields[7]["nullable"] = "false" />
		<cfset variables.metadata.fields[7]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[7]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[7]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[7]["length"] = "0" />
		<cfset variables.metadata.fields[7]["default"] = "0" />
		<!--- cfset variables.metadata.fields[7]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[7]["object"] = "Customer" />
	
	
	<cffunction name="dumpVariables">
		<cfdump var="#variables#" > <cfabort >
	</cffunction>
		
</cfcomponent>
	
