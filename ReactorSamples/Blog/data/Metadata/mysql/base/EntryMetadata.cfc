
<cfcomponent hint="I am the base Metadata object for the Entry table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractMetadata" >
	
	<cfset variables.signature = "E591D242E031943CC427403C11484359" >
	
	<cfset variables.metadata.name = "Entry" />
	<cfset variables.metadata.owner = "" />
	<cfset variables.metadata.type = "table" />
	<cfset variables.metadata.database = "reactorblog" />
	<cfset variables.metadata.dbms = "mysql" />
	
	<!--- Super Object --->
	<cfset variables.metadata.super = structNew() />
	
	
	<!--- Has One --->
	<cfset variables.metadata.hasOne = ArrayNew(1) />
	
		<cfset variables.metadata.hasOne[1] = StructNew() />
		<cfset variables.metadata.hasOne[1].name = "User" />
		<cfset variables.metadata.hasOne[1].alias = "Author" />
		<cfset variables.metadata.hasOne[1].relate = ArrayNew(1) />
		
		
			<cfset variables.metadata.hasOne[1].relate[1] = StructNew() />
			<cfset variables.metadata.hasOne[1].relate[1].from = "postedByUserId" />
			<cfset variables.metadata.hasOne[1].relate[1].to = "userId" />
		
	
	<!--- Has Many --->
	<cfset variables.metadata.hasMany = ArrayNew(1) />
	
		<cfset variables.metadata.hasMany[1] = StructNew() />
		<cfset variables.metadata.hasMany[1].name = "Category" />
		<cfset variables.metadata.hasMany[1].alias = "Category" />
		
		
				<cfset variables.metadata.hasMany[1].link = "EntryCategory" />
			
		<cfset variables.metadata.hasMany[2] = StructNew() />
		<cfset variables.metadata.hasMany[2].name = "Comment" />
		<cfset variables.metadata.hasMany[2].alias = "Comment" />
		
		
				<cfset variables.metadata.hasMany[2].relate = ArrayNew(1) />
			
				
					<cfset variables.metadata.hasMany[2].relate[1] = StructNew() />
					<cfset variables.metadata.hasMany[2].relate[1].from = "entryId" />
					<cfset variables.metadata.hasMany[2].relate[1].to = "entryId" />
				
		<cfset variables.metadata.hasMany[3] = StructNew() />
		<cfset variables.metadata.hasMany[3].name = "Rating" />
		<cfset variables.metadata.hasMany[3].alias = "Rating" />
		
		
				<cfset variables.metadata.hasMany[3].relate = ArrayNew(1) />
			
				
					<cfset variables.metadata.hasMany[3].relate[1] = StructNew() />
					<cfset variables.metadata.hasMany[3].relate[1].from = "entryId" />
					<cfset variables.metadata.hasMany[3].relate[1].to = "entryId" />
				
		<cfset variables.metadata.hasMany[4] = StructNew() />
		<cfset variables.metadata.hasMany[4].name = "EntryCategory" />
		<cfset variables.metadata.hasMany[4].alias = "EntryCategory" />
		
		
				<cfset variables.metadata.hasMany[4].relate = ArrayNew(1) />
			
				
					<cfset variables.metadata.hasMany[4].relate[1] = StructNew() />
					<cfset variables.metadata.hasMany[4].relate[1].from = "entryId" />
					<cfset variables.metadata.hasMany[4].relate[1].to = "entryId" />
				
	
	<!--- Fields --->
	<cfset variables.metadata.fields = ArrayNew(1) />
	
		<cfset variables.metadata.fields[1] = StructNew() />
		<cfset variables.metadata.fields[1]["name"] = "EntryId" />
		<cfset variables.metadata.fields[1]["primaryKey"] = "true" />
		<cfset variables.metadata.fields[1]["identity"] = "true" />
		<cfset variables.metadata.fields[1]["nullable"] = "false" />
		<cfset variables.metadata.fields[1]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[1]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[1]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[1]["length"] = "0" />
		<cfset variables.metadata.fields[1]["default"] = "0" />
		<!--- cfset variables.metadata.fields[1]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[1]["object"] = "Entry" />
	
		<cfset variables.metadata.fields[2] = StructNew() />
		<cfset variables.metadata.fields[2]["name"] = "Title" />
		<cfset variables.metadata.fields[2]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[2]["identity"] = "false" />
		<cfset variables.metadata.fields[2]["nullable"] = "false" />
		<cfset variables.metadata.fields[2]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[2]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[2]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[2]["length"] = "200" />
		<cfset variables.metadata.fields[2]["default"] = "" />
		<!--- cfset variables.metadata.fields[2]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[2]["object"] = "Entry" />
	
		<cfset variables.metadata.fields[3] = StructNew() />
		<cfset variables.metadata.fields[3]["name"] = "Preview" />
		<cfset variables.metadata.fields[3]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[3]["identity"] = "false" />
		<cfset variables.metadata.fields[3]["nullable"] = "true" />
		<cfset variables.metadata.fields[3]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[3]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[3]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[3]["length"] = "1000" />
		<cfset variables.metadata.fields[3]["default"] = "" />
		<!--- cfset variables.metadata.fields[3]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[3]["object"] = "Entry" />
	
		<cfset variables.metadata.fields[4] = StructNew() />
		<cfset variables.metadata.fields[4]["name"] = "Article" />
		<cfset variables.metadata.fields[4]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[4]["identity"] = "false" />
		<cfset variables.metadata.fields[4]["nullable"] = "false" />
		<cfset variables.metadata.fields[4]["dbDataType"] = "longtext" />
		<cfset variables.metadata.fields[4]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[4]["cfSqlType"] = "cf_sql_longvarchar" />
		<cfset variables.metadata.fields[4]["length"] = "4294967295" />
		<cfset variables.metadata.fields[4]["default"] = "" />
		<!--- cfset variables.metadata.fields[4]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[4]["object"] = "Entry" />
	
		<cfset variables.metadata.fields[5] = StructNew() />
		<cfset variables.metadata.fields[5]["name"] = "PublicationDate" />
		<cfset variables.metadata.fields[5]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[5]["identity"] = "false" />
		<cfset variables.metadata.fields[5]["nullable"] = "false" />
		<cfset variables.metadata.fields[5]["dbDataType"] = "datetime" />
		<cfset variables.metadata.fields[5]["cfDataType"] = "date" />
		<cfset variables.metadata.fields[5]["cfSqlType"] = "cf_sql_date" />
		<cfset variables.metadata.fields[5]["length"] = "0" />
		<cfset variables.metadata.fields[5]["default"] = "" />
		<!--- cfset variables.metadata.fields[5]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[5]["object"] = "Entry" />
	
		<cfset variables.metadata.fields[6] = StructNew() />
		<cfset variables.metadata.fields[6]["name"] = "PostedByUserId" />
		<cfset variables.metadata.fields[6]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[6]["identity"] = "false" />
		<cfset variables.metadata.fields[6]["nullable"] = "false" />
		<cfset variables.metadata.fields[6]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[6]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[6]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[6]["length"] = "0" />
		<cfset variables.metadata.fields[6]["default"] = "0" />
		<!--- cfset variables.metadata.fields[6]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[6]["object"] = "Entry" />
	
		<cfset variables.metadata.fields[7] = StructNew() />
		<cfset variables.metadata.fields[7]["name"] = "DisableComments" />
		<cfset variables.metadata.fields[7]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[7]["identity"] = "false" />
		<cfset variables.metadata.fields[7]["nullable"] = "false" />
		<cfset variables.metadata.fields[7]["dbDataType"] = "tinyint" />
		<cfset variables.metadata.fields[7]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[7]["cfSqlType"] = "cf_sql_tinyint" />
		<cfset variables.metadata.fields[7]["length"] = "0" />
		<cfset variables.metadata.fields[7]["default"] = "0" />
		<!--- cfset variables.metadata.fields[7]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[7]["object"] = "Entry" />
	
		<cfset variables.metadata.fields[8] = StructNew() />
		<cfset variables.metadata.fields[8]["name"] = "Views" />
		<cfset variables.metadata.fields[8]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[8]["identity"] = "false" />
		<cfset variables.metadata.fields[8]["nullable"] = "false" />
		<cfset variables.metadata.fields[8]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[8]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[8]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[8]["length"] = "0" />
		<cfset variables.metadata.fields[8]["default"] = "0" />
		<!--- cfset variables.metadata.fields[8]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[8]["object"] = "Entry" />
	
	
	<cffunction name="dumpVariables">
		<cfdump var="#variables#" > <cfabort >
	</cffunction>
		
</cfcomponent>
	
