
<cfcomponent hint="I am the base Metadata object for the Contact table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractMetadata" >
	
	<cfset variables.signature = "97CFF00E66557D10E2BF718AFD8FBFA1" >
	
	<cfset variables.metadata.name = "Contact" />
	<cfset variables.metadata.owner = "" />
	<cfset variables.metadata.type = "table" />
	<cfset variables.metadata.database = "contactmanager" />
	<cfset variables.metadata.dbms = "mysql" />
	
	<!--- Super Object --->
	<cfset variables.metadata.super = structNew() />
	
	
	<!--- Has One --->
	<cfset variables.metadata.hasOne = ArrayNew(1) />
	
	
	<!--- Has Many --->
	<cfset variables.metadata.hasMany = ArrayNew(1) />
	
		<cfset variables.metadata.hasMany[1] = StructNew() />
		<cfset variables.metadata.hasMany[1].name = "Address" />
		<cfset variables.metadata.hasMany[1].alias = "Address" />
		
		
				<cfset variables.metadata.hasMany[1].relate = ArrayNew(1) />
			
				
					<cfset variables.metadata.hasMany[1].relate[1] = StructNew() />
					<cfset variables.metadata.hasMany[1].relate[1].from = "contactId" />
					<cfset variables.metadata.hasMany[1].relate[1].to = "contactId" />
				
		<cfset variables.metadata.hasMany[2] = StructNew() />
		<cfset variables.metadata.hasMany[2].name = "EmailAddress" />
		<cfset variables.metadata.hasMany[2].alias = "EmailAddress" />
		
		
				<cfset variables.metadata.hasMany[2].relate = ArrayNew(1) />
			
				
					<cfset variables.metadata.hasMany[2].relate[1] = StructNew() />
					<cfset variables.metadata.hasMany[2].relate[1].from = "contactId" />
					<cfset variables.metadata.hasMany[2].relate[1].to = "contactId" />
				
		<cfset variables.metadata.hasMany[3] = StructNew() />
		<cfset variables.metadata.hasMany[3].name = "PhoneNumber" />
		<cfset variables.metadata.hasMany[3].alias = "PhoneNumber" />
		
		
				<cfset variables.metadata.hasMany[3].relate = ArrayNew(1) />
			
				
					<cfset variables.metadata.hasMany[3].relate[1] = StructNew() />
					<cfset variables.metadata.hasMany[3].relate[1].from = "contactId" />
					<cfset variables.metadata.hasMany[3].relate[1].to = "contactId" />
				
	
	<!--- Fields --->
	<cfset variables.metadata.fields = ArrayNew(1) />
	
		<cfset variables.metadata.fields[1] = StructNew() />
		<cfset variables.metadata.fields[1]["name"] = "ContactId" />
		<cfset variables.metadata.fields[1]["primaryKey"] = "true" />
		<cfset variables.metadata.fields[1]["identity"] = "true" />
		<cfset variables.metadata.fields[1]["nullable"] = "false" />
		<cfset variables.metadata.fields[1]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[1]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[1]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[1]["length"] = "0" />
		<cfset variables.metadata.fields[1]["default"] = "0" />
		<!--- cfset variables.metadata.fields[1]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[1]["object"] = "Contact" />
	
		<cfset variables.metadata.fields[2] = StructNew() />
		<cfset variables.metadata.fields[2]["name"] = "FirstName" />
		<cfset variables.metadata.fields[2]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[2]["identity"] = "false" />
		<cfset variables.metadata.fields[2]["nullable"] = "false" />
		<cfset variables.metadata.fields[2]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[2]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[2]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[2]["length"] = "50" />
		<cfset variables.metadata.fields[2]["default"] = "" />
		<!--- cfset variables.metadata.fields[2]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[2]["object"] = "Contact" />
	
		<cfset variables.metadata.fields[3] = StructNew() />
		<cfset variables.metadata.fields[3]["name"] = "LastName" />
		<cfset variables.metadata.fields[3]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[3]["identity"] = "false" />
		<cfset variables.metadata.fields[3]["nullable"] = "false" />
		<cfset variables.metadata.fields[3]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[3]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[3]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[3]["length"] = "50" />
		<cfset variables.metadata.fields[3]["default"] = "" />
		<!--- cfset variables.metadata.fields[3]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[3]["object"] = "Contact" />
	
	
	<cffunction name="dumpVariables">
		<cfdump var="#variables#" > <cfabort >
	</cffunction>
		
</cfcomponent>
	
