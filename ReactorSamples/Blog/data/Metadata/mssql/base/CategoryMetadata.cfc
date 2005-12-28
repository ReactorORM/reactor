
<cfcomponent hint="I am the base Metadata object for the Category table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractMetadata" >
	
	<cfset variables.signature = "106C93A7D6005D46BE18AAAA81C55D30" >
	
	<cfset variables.metadata.name = "Category" />
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
	
		<cfset variables.metadata.hasMany[1] = StructNew() />
		<cfset variables.metadata.hasMany[1].name = "Entry" />
		<cfset variables.metadata.hasMany[1].alias = "Entry" />
		
		
				<cfset variables.metadata.hasMany[1].link = "EntryCategory" />
			
		<cfset variables.metadata.hasMany[2] = StructNew() />
		<cfset variables.metadata.hasMany[2].name = "EntryCategory" />
		<cfset variables.metadata.hasMany[2].alias = "EntryCategory" />
		
		
				<cfset variables.metadata.hasMany[2].relate = ArrayNew(1) />
			
				
					<cfset variables.metadata.hasMany[2].relate[1] = StructNew() />
					<cfset variables.metadata.hasMany[2].relate[1].from = "categoryId" />
					<cfset variables.metadata.hasMany[2].relate[1].to = "categoryId" />
				
	
	<!--- Fields --->
	<cfset variables.metadata.fields = ArrayNew(1) />
	
		<cfset variables.metadata.fields[1] = StructNew() />
		<cfset variables.metadata.fields[1]["name"] = "CategoryId" />
		<cfset variables.metadata.fields[1]["primaryKey"] = "true" />
		<cfset variables.metadata.fields[1]["identity"] = "true" />
		<cfset variables.metadata.fields[1]["nullable"] = "false" />
		<cfset variables.metadata.fields[1]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[1]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[1]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[1]["length"] = "0" />
		<cfset variables.metadata.fields[1]["default"] = "0" />
		<!--- cfset variables.metadata.fields[1]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[1]["object"] = "Category" />
	
		<cfset variables.metadata.fields[2] = StructNew() />
		<cfset variables.metadata.fields[2]["name"] = "Name" />
		<cfset variables.metadata.fields[2]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[2]["identity"] = "false" />
		<cfset variables.metadata.fields[2]["nullable"] = "false" />
		<cfset variables.metadata.fields[2]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[2]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[2]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[2]["length"] = "50" />
		<cfset variables.metadata.fields[2]["default"] = "" />
		<!--- cfset variables.metadata.fields[2]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[2]["object"] = "Category" />
	
	
	<cffunction name="dumpVariables">
		<cfdump var="#variables#" > <cfabort >
	</cffunction>
		
</cfcomponent>
	
