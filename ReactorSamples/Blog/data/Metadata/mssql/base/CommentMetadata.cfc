
<cfcomponent hint="I am the base Metadata object for the Comment table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractMetadata" >
	
	<cfset variables.signature = "213DDCE078FE802CAA38D229ED2C3AF8" >
	
	<cfset variables.metadata.name = "Comment" />
	<cfset variables.metadata.owner = "dbo" />
	<cfset variables.metadata.type = "table" />
	<cfset variables.metadata.database = "ReactorBlog" />
	<cfset variables.metadata.dbms = "mssql" />
	
	<!--- Super Object --->
	<cfset variables.metadata.super = structNew() />
	
	
	<!--- Has One --->
	<cfset variables.metadata.hasOne = ArrayNew(1) />
	
	
	<!--- Has Many --->
	<cfset variables.metadata.hasMany = ArrayNew(1) />
	
	
	<!--- Fields --->
	<cfset variables.metadata.fields = ArrayNew(1) />
	
		<cfset variables.metadata.fields[1] = StructNew() />
		<cfset variables.metadata.fields[1]["name"] = "CommentID" />
		<cfset variables.metadata.fields[1]["primaryKey"] = "true" />
		<cfset variables.metadata.fields[1]["identity"] = "true" />
		<cfset variables.metadata.fields[1]["nullable"] = "false" />
		<cfset variables.metadata.fields[1]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[1]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[1]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[1]["length"] = "0" />
		<cfset variables.metadata.fields[1]["default"] = "0" />
		<!--- cfset variables.metadata.fields[1]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[1]["object"] = "Comment" />
	
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
		<cfset variables.metadata.fields[2]["object"] = "Comment" />
	
		<cfset variables.metadata.fields[3] = StructNew() />
		<cfset variables.metadata.fields[3]["name"] = "Name" />
		<cfset variables.metadata.fields[3]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[3]["identity"] = "false" />
		<cfset variables.metadata.fields[3]["nullable"] = "false" />
		<cfset variables.metadata.fields[3]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[3]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[3]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[3]["length"] = "50" />
		<cfset variables.metadata.fields[3]["default"] = "" />
		<!--- cfset variables.metadata.fields[3]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[3]["object"] = "Comment" />
	
		<cfset variables.metadata.fields[4] = StructNew() />
		<cfset variables.metadata.fields[4]["name"] = "EmailAddress" />
		<cfset variables.metadata.fields[4]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[4]["identity"] = "false" />
		<cfset variables.metadata.fields[4]["nullable"] = "false" />
		<cfset variables.metadata.fields[4]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[4]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[4]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[4]["length"] = "50" />
		<cfset variables.metadata.fields[4]["default"] = "" />
		<!--- cfset variables.metadata.fields[4]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[4]["object"] = "Comment" />
	
		<cfset variables.metadata.fields[5] = StructNew() />
		<cfset variables.metadata.fields[5]["name"] = "Comment" />
		<cfset variables.metadata.fields[5]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[5]["identity"] = "false" />
		<cfset variables.metadata.fields[5]["nullable"] = "false" />
		<cfset variables.metadata.fields[5]["dbDataType"] = "text" />
		<cfset variables.metadata.fields[5]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[5]["cfSqlType"] = "cf_sql_longvarchar" />
		<cfset variables.metadata.fields[5]["length"] = "2147483647" />
		<cfset variables.metadata.fields[5]["default"] = "" />
		<!--- cfset variables.metadata.fields[5]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[5]["object"] = "Comment" />
	
		<cfset variables.metadata.fields[6] = StructNew() />
		<cfset variables.metadata.fields[6]["name"] = "Posted" />
		<cfset variables.metadata.fields[6]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[6]["identity"] = "false" />
		<cfset variables.metadata.fields[6]["nullable"] = "false" />
		<cfset variables.metadata.fields[6]["dbDataType"] = "datetime" />
		<cfset variables.metadata.fields[6]["cfDataType"] = "date" />
		<cfset variables.metadata.fields[6]["cfSqlType"] = "cf_sql_date" />
		<cfset variables.metadata.fields[6]["length"] = "0" />
		<cfset variables.metadata.fields[6]["default"] = "#Now()#" />
		<!--- cfset variables.metadata.fields[6]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[6]["object"] = "Comment" />
	
	
	<cffunction name="dumpVariables">
		<cfdump var="#variables#" > <cfabort >
	</cffunction>
		
</cfcomponent>
	
