
<cfcomponent hint="I am the mysql custom Metadata object for the PhoneNumber table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="PhoneNumberMetadata">
	<!--- Place custom code here, it will not be overwritten --->

	<cfset variables.metadata.owner = "" />
	<cfset variables.metadata.dbms = "mysql" />
	
</cfcomponent>
	
