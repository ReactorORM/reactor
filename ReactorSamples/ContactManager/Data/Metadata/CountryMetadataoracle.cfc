
<cfcomponent hint="I am the oracle custom Metadata object for the Country object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="CountryMetadata">
	<!--- Place custom code here, it will not be overwritten --->

	<cfset variables.metadata.owner = "SYSTEM" />
	<cfset variables.metadata.dbms = "oracle" />
	
</cfcomponent>
	
