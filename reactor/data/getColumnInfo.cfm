<cfif ThisTag.ExecutionMode IS "start">
	<cfparam name="attributes.datasource">
	<cfparam name="attributes.table">
	<cfparam name="attributes.rQuery">
	
<cfelse>
	<cfexit method="exittemplate">
</cfif>


