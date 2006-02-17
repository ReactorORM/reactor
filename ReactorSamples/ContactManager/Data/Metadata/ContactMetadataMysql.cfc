
<cfcomponent hint="I am the mysql custom Metadata object for the Contact table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="ContactMetadata">
	<!--- Place custom code here, it will not be overwritten --->

	<cfset variables.metadata.owner = "" />
	<cfset variables.metadata.dbms = "mysql" />
	
</cfcomponent>
	
