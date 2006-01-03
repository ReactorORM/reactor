
<cfcomponent hint="I am the base Metadata object for the EntryCategory table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractMetadata" >
	
	<cfset variables.signature = "044DEDBE111807360D1608E501B49D78" >
	
	<cfset variables.metadata.name = "EntryCategory" />
	<cfset variables.metadata.owner = "" />
	<cfset variables.metadata.type = "table" />
	<cfset variables.metadata.database = "reactorblog" />
	<cfset variables.metadata.dbms = "mysql" />
	
	<!--- Super Object --->
	<cfset variables.metadata.super = structNew() />
	
	
	<!--- Has One --->
	<cfset variables.metadata.hasOne = ArrayNew(1) />
	
		<cfset variables.metadata.hasOne[1] = StructNew() />
		<cfset variables.metadata.hasOne[1].name = "Entry" />
		<cfset variables.metadata.hasOne[1].alias = "Entry" />
		<cfset variables.metadata.hasOne[1].relate = ArrayNew(1) />
		
		
			<cfset variables.metadata.hasOne[1].relate[1] = StructNew() />
			<cfset variables.metadata.hasOne[1].relate[1].from = "entryId" />
			<cfset variables.metadata.hasOne[1].relate[1].to = "entryId" />
		
		<cfset variables.metadata.hasOne[2] = StructNew() />
		<cfset variables.metadata.hasOne[2].name = "Category" />
		<cfset variables.metadata.hasOne[2].alias = "Category" />
		<cfset variables.metadata.hasOne[2].relate = ArrayNew(1) />
		
		
			<cfset variables.metadata.hasOne[2].relate[1] = StructNew() />
			<cfset variables.metadata.hasOne[2].relate[1].from = "categoryId" />
			<cfset variables.metadata.hasOne[2].relate[1].to = "categoryId" />
		
	
	<!--- Has Many --->
	<cfset variables.metadata.hasMany = ArrayNew(1) />
	
	
	<!--- Fields --->
	<cfset variables.metadata.fields = ArrayNew(1) />
	
		<cfset variables.metadata.fields[1] = StructNew() />
		<cfset variables.metadata.fields[1]["name"] = "EntryCategoryId" />
		<cfset variables.metadata.fields[1]["primaryKey"] = "true" />
		<cfset variables.metadata.fields[1]["identity"] = "true" />
		<cfset variables.metadata.fields[1]["nullable"] = "false" />
		<cfset variables.metadata.fields[1]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[1]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[1]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[1]["length"] = "0" />
		<cfset variables.metadata.fields[1]["default"] = "0" />
		<!--- cfset variables.metadata.fields[1]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[1]["object"] = "EntryCategory" />
	
		<cfset variables.metadata.fields[2] = StructNew() />
		<cfset variables.metadata.fields[2]["name"] = "EntryId" />
		<cfset variables.metadata.fields[2]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[2]["identity"] = "false" />
		<cfset variables.metadata.fields[2]["nullable"] = "false" />
		<cfset variables.metadata.fields[2]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[2]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[2]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[2]["length"] = "0" />
		<cfset variables.metadata.fields[2]["default"] = "0" />
		<!--- cfset variables.metadata.fields[2]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[2]["object"] = "EntryCategory" />
	
		<cfset variables.metadata.fields[3] = StructNew() />
		<cfset variables.metadata.fields[3]["name"] = "CategoryId" />
		<cfset variables.metadata.fields[3]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[3]["identity"] = "false" />
		<cfset variables.metadata.fields[3]["nullable"] = "false" />
		<cfset variables.metadata.fields[3]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[3]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[3]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[3]["length"] = "0" />
		<cfset variables.metadata.fields[3]["default"] = "0" />
		<!--- cfset variables.metadata.fields[3]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[3]["object"] = "EntryCategory" />
	
	
	<cffunction name="dumpVariables">
		<cfdump var="#variables#" > <cfabort >
	</cffunction>
		
</cfcomponent>
	
