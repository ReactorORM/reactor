
<cfcomponent hint="I am the db2 custom Metadata object for the Contact object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="ContactMetadata">
	<!--- Place custom code here, it will not be overwritten --->

	<cfset variables.metadata.owner = "NULLID" />
	<cfset variables.metadata.dbms = "db2" />
	
</cfcomponent>
	
