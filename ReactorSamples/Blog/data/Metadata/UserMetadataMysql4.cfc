
<cfcomponent hint="I am the mysql custom Metadata object for the User table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="UserMetadata">
	<!--- Place custom code here, it will not be overwritten --->

	<cfset variables.metadata.owner = "" />
	<cfset variables.metadata.dbms = "mysql" />
	
</cfcomponent>
	
