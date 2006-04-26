<cfcomponent displayname="TimedCache" output="false" hint="I am a timed cache of anything you want to cache.">
  
	<cffunction name="Init" access="public" returnType="TimedCache" output="false" hint="I build a new TimedCache.">
		<cfargument name="defaultTimeout" type="numeric" required="true" />
		
		<cfset variables.defaultTimeout = arguments.defaultTimeout />
		<cfset variables.members = structNew() />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="GetAll" access="public" returnType="struct" output="false" hint="I get all values using StructCopy().">
		<cfreturn structCopy(variables.members) />
	</cffunction>

	<cffunction name="SetValue" access="public" returnType="void" output="false" hint="I set a value in the collection.">
		<cfargument name="name" type="string" required="true" hint="I am the name of the value.">
		<cfargument name="value" type="any" required="true" hint="I am the value.">
		<cfargument name="timeout" type="numeric" required="false" hint="I am the [optional] timespan for which this value should be cached." />
		<cfset var item = structNew() />
		
		<cfif structKeyExists(arguments, "timeout")>
			<cfset item.expires = now() * 1 + arguments.timeout />
		<cfelse>
			<cfset item.expires = now() * 1 + variables.defaultTimeout />
		</cfif>
		
		<cfset item.value = arguments.value />
		
		<cfset variables.members[arguments.name] = item />
	</cffunction>

	<cffunction name="GetValue" access="public" returnType="any" output="false" hint="I get a value from the collection.">
		<cfargument name="name" type="string" required="true" hint="I am the name of the value.">
		
		
		<cfif Exists(arguments.name)>
			<cfreturn variables.members[arguments.name].value />
		<cfelse>
			<cfthrow type="ModelGlue.Util.TimedCache.ItemNotFound" message="TimedCache: Request item not in cache.  Use Exists() to make sure it exists before trying to get it." />
		</cfif>
	</cffunction>

	<cffunction name="RemoveValue" access="public" returnType="void" output="false" hint="I remove a value from the collection.">
		<cfargument name="name" type="string" required="true" hint="I am the name of the value.">
		<cfset structDelete(variables.members, arguments.name) />
	</cffunction>

	<cffunction name="Exists" access="public" returnType="boolean" output="false" hint="I state if a value exists.">
		<cfargument name="name" type="string" required="true" hint="I am the name of the value.">

		<cfset GarbageCollect(arguments.name) />
		
		
		<cfreturn structKeyExists(variables.members, arguments.name)>
	</cffunction>

	<cffunction name="GarbageCollect" access="private" returnType="void" output="false">
		<cfargument name="name" type="string" required="true" hint="I am the name of the value.">
		<cfif structKeyExists(variables.members, arguments.name) AND now() * 1 gte variables.members[arguments.name].expires>
			<cfset structDelete(variables.members, arguments.name) />
		</cfif>
	</cffunction>

</cfcomponent>