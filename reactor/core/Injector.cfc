<cfcomponent hint="I am a definition of the other objects that need to be injected into an object in reactor" output="false">

	<cfscript>
		variables.target = "";
		variables.beans = "";
	
	</cfscript>


	<cffunction name="init" access="public" returntype="Injector" output="false">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setTarget" access="public" returntype="void" output="false">
		<cfargument name="target" required="true" type="any" >
		<cfset variables.target = arguments.target>
	</cffunction>
	
	<cffunction name="setBeans" access="public" returntype="void" output="false">
		<cfargument name="beans" required="true" type="any" >
		<cfset variables.beans = arguments.beans>
	</cffunction>	
	
	<cffunction name="getBeans" access="public" returntype="string" output="false">
		<cfreturn variables.beans>
	</cffunction>

	<cffunction name="isTarget" access="public" returntype="boolean" output="false">
		<cfargument name="targetName" required="true">
		<cfif ListFindNoCase(variables.target,arguments.targetName)>
			<cfreturn true>
		</cfif>
		<cfreturn false />
	</cffunction>

</cfcomponent>