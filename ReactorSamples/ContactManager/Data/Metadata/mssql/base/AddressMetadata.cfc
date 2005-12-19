
<cfcomponent hint="I am the base Metadata object for the Address table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractMetadata" >
	
	<cfset variables.signature = "21A2E5B68F903F232359A5EE1C80F954" >
	
	<cfset variables.metadata.name = "Address" />
	<cfset variables.metadata.owner = "dbo" />
	<cfset variables.metadata.type = "table" />
	<cfset variables.metadata.database = "ContactManager" />
	<cfset variables.metadata.dbms = "mssql" />
	
	<!--- Super Object --->
	<cfset variables.metadata.super = structNew() />
	
	
	<!--- Has One --->
	<cfset variables.metadata.hasOne = ArrayNew(1) />
	
		<cfset variables.metadata.hasOne[1] = StructNew() />
		<cfset variables.metadata.hasOne[1].name = "State" />
		<cfset variables.metadata.hasOne[1].alias = "State" />
		<cfset variables.metadata.hasOne[1].relate = ArrayNew(1) />
		
		
			<cfset variables.metadata.hasOne[1].relate[1] = StructNew() />
			<cfset variables.metadata.hasOne[1].relate[1].from = "stateId" />
			<cfset variables.metadata.hasOne[1].relate[1].to = "stateId" />
		
		<cfset variables.metadata.hasOne[2] = StructNew() />
		<cfset variables.metadata.hasOne[2].name = "Country" />
		<cfset variables.metadata.hasOne[2].alias = "Country" />
		<cfset variables.metadata.hasOne[2].relate = ArrayNew(1) />
		
		
			<cfset variables.metadata.hasOne[2].relate[1] = StructNew() />
			<cfset variables.metadata.hasOne[2].relate[1].from = "countryId" />
			<cfset variables.metadata.hasOne[2].relate[1].to = "countryId" />
		
	
	<!--- Has Many --->
	<cfset variables.metadata.hasMany = ArrayNew(1) />
	
	
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
		<cfset variables.metadata.fields[2]["name"] = "ContactId" />
		<cfset variables.metadata.fields[2]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[2]["identity"] = "false" />
		<cfset variables.metadata.fields[2]["nullable"] = "false" />
		<cfset variables.metadata.fields[2]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[2]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[2]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[2]["length"] = "0" />
		<cfset variables.metadata.fields[2]["default"] = "0" />
		<!--- cfset variables.metadata.fields[2]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[2]["object"] = "Address" />
	
		<cfset variables.metadata.fields[3] = StructNew() />
		<cfset variables.metadata.fields[3]["name"] = "Line1" />
		<cfset variables.metadata.fields[3]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[3]["identity"] = "false" />
		<cfset variables.metadata.fields[3]["nullable"] = "false" />
		<cfset variables.metadata.fields[3]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[3]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[3]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[3]["length"] = "50" />
		<cfset variables.metadata.fields[3]["default"] = "" />
		<!--- cfset variables.metadata.fields[3]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[3]["object"] = "Address" />
	
		<cfset variables.metadata.fields[4] = StructNew() />
		<cfset variables.metadata.fields[4]["name"] = "Line2" />
		<cfset variables.metadata.fields[4]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[4]["identity"] = "false" />
		<cfset variables.metadata.fields[4]["nullable"] = "true" />
		<cfset variables.metadata.fields[4]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[4]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[4]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[4]["length"] = "50" />
		<cfset variables.metadata.fields[4]["default"] = "" />
		<!--- cfset variables.metadata.fields[4]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[4]["object"] = "Address" />
	
		<cfset variables.metadata.fields[5] = StructNew() />
		<cfset variables.metadata.fields[5]["name"] = "City" />
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
		<cfset variables.metadata.fields[6]["name"] = "StateId" />
		<cfset variables.metadata.fields[6]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[6]["identity"] = "false" />
		<cfset variables.metadata.fields[6]["nullable"] = "true" />
		<cfset variables.metadata.fields[6]["dbDataType"] = "smallint" />
		<cfset variables.metadata.fields[6]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[6]["cfSqlType"] = "cf_sql_smallint" />
		<cfset variables.metadata.fields[6]["length"] = "0" />
		<cfset variables.metadata.fields[6]["default"] = "" />
		<!--- cfset variables.metadata.fields[6]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[6]["object"] = "Address" />
	
		<cfset variables.metadata.fields[7] = StructNew() />
		<cfset variables.metadata.fields[7]["name"] = "PostalCode" />
		<cfset variables.metadata.fields[7]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[7]["identity"] = "false" />
		<cfset variables.metadata.fields[7]["nullable"] = "false" />
		<cfset variables.metadata.fields[7]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[7]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[7]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[7]["length"] = "20" />
		<cfset variables.metadata.fields[7]["default"] = "" />
		<!--- cfset variables.metadata.fields[7]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[7]["object"] = "Address" />
	
		<cfset variables.metadata.fields[8] = StructNew() />
		<cfset variables.metadata.fields[8]["name"] = "CountryId" />
		<cfset variables.metadata.fields[8]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[8]["identity"] = "false" />
		<cfset variables.metadata.fields[8]["nullable"] = "false" />
		<cfset variables.metadata.fields[8]["dbDataType"] = "smallint" />
		<cfset variables.metadata.fields[8]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[8]["cfSqlType"] = "cf_sql_smallint" />
		<cfset variables.metadata.fields[8]["length"] = "0" />
		<cfset variables.metadata.fields[8]["default"] = "0" />
		<!--- cfset variables.metadata.fields[8]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[8]["object"] = "Address" />
	
	
	<cffunction name="dumpVariables">
		<cfdump var="#variables#" > <cfabort >
	</cffunction>
		
</cfcomponent>
	
