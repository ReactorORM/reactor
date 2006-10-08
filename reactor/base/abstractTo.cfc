<cfcomponent hint="I am an abstract TO.  I am used to define an interface and for return types.">
	
	<cfinclude template="base.cfm" />
	
	<cffunction name="_configure" access="public" hint="I configure and return this object." output="false" returntype="any" _returntype="reactor.base.abstractTo">
		<cfargument name="config" hint="I am the configuration object to use." required="yes" type="any" _type="reactor.config.config" />
		<cfargument name="alias" hint="I am the alias of this object." required="yes" type="any" _type="string" />
		<cfargument name="ReactorFactory" hint="I am the reactorFactory object." required="yes" type="any" _type="reactor.reactorFactory" />
		<cfargument name="Convention" hint="I am a database Convention object." required="yes" type="any" _type="reactor.data.abstractConvention" />
		
		<cfset _setConfig(arguments.config) />
		<cfset _setAlias(arguments.alias) />
		<cfset _setReactorFactory(arguments.ReactorFactory) />
		<cfset _setConvention(arguments.Convention) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="_copy" access="public" hint="I copy another TO's values into this TO.  Properties which exist in both TOs are copied from the provided TO to this TO." output="false" returntype="void">
		<cfargument name="To" hint="I am the TO to copy data from" required="yes" type="any" _type="reactor.base.abstractTo" />
		<cfset var item = 0 />
		
		<cfloop collection="#this#" item="item">
			<!--- only copy simple values --->
			<cfif StructKeyExists(arguments.To, item) AND NOT IsCustomFunction(this[item])>
				<cfset this[item] = arguments.To[item] />
			</cfif>
		</cfloop>
				
	</cffunction>
	
	<cffunction name="_isEqual" access="public" hint="I indicate if two TOs are the same in terms of type and values.  If any of the values in the TO can not be converted to a string them this will return false." output="false" returntype="any" _returntype="boolean">
		<cfargument name="To" hint="I am the TO to copy data from" required="yes" type="any" _type="reactor.base.abstractTo" />
		<cfset var item = 0 />
		
		<!--- make sure they're the same type! --->
		<cfif getMetadata(this).name IS NOT getMetadata(arguments.To).name>
			<cfreturn false />
		</cfif>


		<!--- they're the same type, are all the non-function values the same? --->
		<cfloop collection="#this#" item="item">
		
			<cftry>
				<cfif NOT IsCustomFunction(this[item]) AND Compare(ToString(this[item]), ToString(arguments.to[item])) IS NOT 0>
					<cfreturn false />
				</cfif>
				<cfcatch>
					<!--- the value couldn't be convered to a string so we can't compare it. --->
					<cfreturn false />
				</cfcatch>
			</cftry>			
			
		</cfloop>
		
		<!--- all the values matched up, they're equal! --->
		<cfreturn true />
	</cffunction>
	
</cfcomponent>

