
<cfcomponent hint="I am the base Metadata object for the Invoice table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractMetadata" >
	
	<cfset variables.signature = "4BB04E77F8C785BFEC9964C618CFF1F3" >
	
	<cfset variables.metadata.name = "Invoice" />
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
		<cfset variables.metadata.hasMany[1].name = "Product" />
		<cfset variables.metadata.hasMany[1].alias = "Product" />
		
		
				<cfset variables.metadata.hasMany[1].link = "InvoiceProduct" />
			
		<cfset variables.metadata.hasMany[2] = StructNew() />
		<cfset variables.metadata.hasMany[2].name = "InvoiceProduct" />
		<cfset variables.metadata.hasMany[2].alias = "InvoiceProduct" />
		
		
				<cfset variables.metadata.hasMany[2].relate = ArrayNew(1) />
			
				
					<cfset variables.metadata.hasMany[2].relate[1] = StructNew() />
					<cfset variables.metadata.hasMany[2].relate[1].from = "invoiceId" />
					<cfset variables.metadata.hasMany[2].relate[1].to = "invoiceId" />
				
	
	<!--- Fields --->
	<cfset variables.metadata.fields = ArrayNew(1) />
	
		<cfset variables.metadata.fields[1] = StructNew() />
		<cfset variables.metadata.fields[1]["name"] = "InvoiceId" />
		<cfset variables.metadata.fields[1]["primaryKey"] = "true" />
		<cfset variables.metadata.fields[1]["identity"] = "true" />
		<cfset variables.metadata.fields[1]["nullable"] = "false" />
		<cfset variables.metadata.fields[1]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[1]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[1]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[1]["length"] = "0" />
		<cfset variables.metadata.fields[1]["default"] = "0" />
		<!--- cfset variables.metadata.fields[1]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[1]["object"] = "Invoice" />
	
		<cfset variables.metadata.fields[2] = StructNew() />
		<cfset variables.metadata.fields[2]["name"] = "CustomerId" />
		<cfset variables.metadata.fields[2]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[2]["identity"] = "false" />
		<cfset variables.metadata.fields[2]["nullable"] = "false" />
		<cfset variables.metadata.fields[2]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[2]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[2]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[2]["length"] = "0" />
		<cfset variables.metadata.fields[2]["default"] = "0" />
		<!--- cfset variables.metadata.fields[2]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[2]["object"] = "Invoice" />
	
	
	<cffunction name="dumpVariables">
		<cfdump var="#variables#" > <cfabort >
	</cffunction>
		
</cfcomponent>
	
