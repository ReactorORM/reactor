<cfcomponent displayname="facade" hint="I am a facade used to access a specific scope.">
	
	<cfset variables.scope = StructNew() />
	<cfset variables.scopeName = "" />

	<cffunction name="init" access="public" returntype="facade" hint="I configure and return the facade." output="false">
		<cfargument name="scopeName" hint="I am the name of the scope this is facading." required="yes" type="string" />
		<cfset setScopeName(arguments.scopeName) />
		<cfreturn this />
	</cffunction>

	<cffunction name="GetAll" access="public" returnType="struct" output="false" hint="I get all values using StructCopy().">
		<cfreturn getScope() />
	</cffunction>

	<cffunction name="SetValue" access="public" returnType="void" output="false" hint="I set a value in the scope.">
		<cfargument name="name" type="string" required="true" hint="I am the name of the value.">
		<cfargument name="value" type="any" required="true" hint="I am the value.">
		<cfset var scope = getScope() />
		
		<cflock name="FacadeSetValue" type="exclusive" timeout="5">
			<cfset scope[arguments.name] = arguments.value />
		</cflock>
	</cffunction>

	<cffunction name="GetValue" access="public" returnType="any" output="false" hint="I get a value from the scope or the default or an empty string.">
		<cfargument name="name" type="string" required="true" hint="I am the name of the value.">
		<cfargument name="default" required="false" type="any" hint="I am a default value to set and return if the value does not exist." />
		<cfset var scope = getScope() />
		
		<!--- does this name exist? --->
		<cfif exists(arguments.name)>
			<cfreturn scope[arguments.name] />
			
		<!--- if not, do we have a default? --->
		<cfelseif structKeyExists(arguments, "default")>
			<cfset setValue(arguments.name, arguments.default) />
			<cfreturn arguments.default />
			
		<!--- otherwise, return an empty string --->
		<cfelse>
			<cfreturn "" />
			
		</cfif>
	</cffunction>

	<cffunction name="RemoveValue" access="public" returnType="void" output="false" hint="I remove a value from the scope.">
		<cfargument name="name" type="string" required="true" hint="I am the name of the value.">
		
		<cflock name="FacadeRemoveValue" type="exclusive" timeout="5">
			<cfset structDelete(getScope(), arguments.name) />
		</cflock>
	</cffunction>

	<cffunction name="Exists" access="public" returnType="boolean" output="false" hint="I state if a value exists.">
		<cfargument name="name" type="string" required="true" hint="I am the name of the value.">
		<cfreturn structKeyExists(getScope(), arguments.name)>
	</cffunction>

	<!--- scope --->
    <cffunction name="setScope" access="private" output="false" returntype="void">
       <cfargument name="scope" hint="I am the scope which is facaded." required="yes" type="struct" />
       <cfset variables.scope = arguments.scope />
    </cffunction>
    <cffunction name="getScope" access="private" output="false" returntype="struct">
       <cfreturn variables.scope />
    </cffunction>
	
	<!--- scopeName --->
    <cffunction name="setScopeName" access="public" output="false" returntype="void">
       <cfargument name="scopeName" hint="I am the name of the scope this is facading." required="yes" type="string" />
       <cfset variables.scopeName = arguments.scopeName />
	   <cfset setScope(evaluate(arguments.scopeName)) />
    </cffunction>
    <cffunction name="getScopeName" access="public" output="false" returntype="string">
       <cfreturn variables.scopeName />
    </cffunction>

</cfcomponent>