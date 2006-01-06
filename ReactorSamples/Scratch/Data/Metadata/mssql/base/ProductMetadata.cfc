
<cfcomponent hint="I am the base Metadata object for the Product table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractMetadata" >
	
	<cfset variables.signature = "1F9769460092807EAA804112D726C42B" >
	
	<cfset variables.metadata.name = "Product" />
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
		<cfset variables.metadata.hasMany[1].name = "Invoice" />
		<cfset variables.metadata.hasMany[1].alias = "Invoice" />
		
		
				<cfset variables.metadata.hasMany[1].link = "InvoiceProduct" />
			
		<cfset variables.metadata.hasMany[2] = StructNew() />
		<cfset variables.metadata.hasMany[2].name = "InvoiceProduct" />
		<cfset variables.metadata.hasMany[2].alias = "InvoiceProduct" />
		
		
				<cfset variables.metadata.hasMany[2].relate = ArrayNew(1) />
			
				
					<cfset variables.metadata.hasMany[2].relate[1] = StructNew() />
					<cfset variables.metadata.hasMany[2].relate[1].from = "productId" />
					<cfset variables.metadata.hasMany[2].relate[1].to = "productId" />
				
	
	<!--- Fields --->
	<cfset variables.metadata.fields = ArrayNew(1) />
	
		<cfset variables.metadata.fields[1] = StructNew() />
		<cfset variables.metadata.fields[1]["name"] = "ProductId" />
		<cfset variables.metadata.fields[1]["primaryKey"] = "true" />
		<cfset variables.metadata.fields[1]["identity"] = "true" />
		<cfset variables.metadata.fields[1]["nullable"] = "false" />
		<cfset variables.metadata.fields[1]["dbDataType"] = "int" />
		<cfset variables.metadata.fields[1]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[1]["cfSqlType"] = "cf_sql_integer" />
		<cfset variables.metadata.fields[1]["length"] = "0" />
		<cfset variables.metadata.fields[1]["default"] = "0" />
		<!--- cfset variables.metadata.fields[1]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[1]["object"] = "Product" />
	
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
		<cfset variables.metadata.fields[2]["object"] = "Product" />
	
		<cfset variables.metadata.fields[3] = StructNew() />
		<cfset variables.metadata.fields[3]["name"] = "Description" />
		<cfset variables.metadata.fields[3]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[3]["identity"] = "false" />
		<cfset variables.metadata.fields[3]["nullable"] = "false" />
		<cfset variables.metadata.fields[3]["dbDataType"] = "varchar" />
		<cfset variables.metadata.fields[3]["cfDataType"] = "string" />
		<cfset variables.metadata.fields[3]["cfSqlType"] = "cf_sql_varchar" />
		<cfset variables.metadata.fields[3]["length"] = "2000" />
		<cfset variables.metadata.fields[3]["default"] = "" />
		<!--- cfset variables.metadata.fields[3]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[3]["object"] = "Product" />
	
		<cfset variables.metadata.fields[4] = StructNew() />
		<cfset variables.metadata.fields[4]["name"] = "Price" />
		<cfset variables.metadata.fields[4]["primaryKey"] = "false" />
		<cfset variables.metadata.fields[4]["identity"] = "false" />
		<cfset variables.metadata.fields[4]["nullable"] = "false" />
		<cfset variables.metadata.fields[4]["dbDataType"] = "money" />
		<cfset variables.metadata.fields[4]["cfDataType"] = "numeric" />
		<cfset variables.metadata.fields[4]["cfSqlType"] = "cf_sql_money" />
		<cfset variables.metadata.fields[4]["length"] = "0" />
		<cfset variables.metadata.fields[4]["default"] = "0" />
		<!--- cfset variables.metadata.fields[4]["overridden"] = "false" /--->
		<cfset variables.metadata.fields[4]["object"] = "Product" />
	
	
	<cffunction name="dumpVariables">
		<cfdump var="#variables#" > <cfabort >
	</cffunction>
		
</cfcomponent>
	
