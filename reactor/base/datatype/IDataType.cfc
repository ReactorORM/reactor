<cfinterface >


	<cffunction name="getValue" returntype="any" access="public" output="false">
		<cfargument name="event">
		<cfargument name="field">
	</cffunction>
	
	<cffunction name="renderInput" returntype="string" access="public" output="false">
		<cfargument name="inputfield" type="string">
		<cfargument name="RecordObject" type="reactor.base.abstractRecord">
		<cfargument name="MetaData" type="reactor.base.abstractMetaData">
	</cffunction>

</cfinterface>