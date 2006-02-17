<cfcomponent displayname="event" hint="I am a reactor event object.">
	
	<cfset variables.name = "" />
	<cfset variables.Source = "" />
	<cfset variables.values = StructNew() />
	
	<cffunction name="init" access="public" hint="I configure and return an event." output="false" returntype="event">
		<cfargument name="name" hint="I am the name of the event." required="yes" type="string" />
		<cfargument name="Source" hint="I am the Source of the event." required="yes" type="reactor.base.abstractRecord" />
		
		<cfset setName(arguments.name) />
		<cfset setSource(arguments.Source) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- getValue --->
	<cffunction name="getValue" access="public" hint="I get a value (or a default value) from the event." output="false" returntype="any">
		<cfargument name="name" hint="I am the name of the value to get" required="yes" type="string" />
		<cfargument name="default" hint="I am the default value to return in the case that the value does't exist." required="no" type="any" default="" />
		
		<cfif valueExists(arguments.name)>
			<cfreturn variables.values[arguments.name] />
		<cfelse>
			<cfreturn arguments.default />
		</cfif>
		
	</cffunction>
	
	<!--- setValue --->
	<cffunction name="setValue" access="public" hint="I set a value into the event." output="false" returntype="void">
		<cfargument name="name" hint="I am the name of the value to get" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to set into the event." required="yes" type="any" />
		<cfset variables.values[arguments.name] = arguments.value />
	</cffunction>
	
	<!--- valueExists --->
	<cffunction name="valueExists" hint="I indicate if a value exists in the event" output="false" returntype="boolean">
		<cfargument name="name" hint="I am the name of the value being checked for." required="yes" type="string" />
		<cfreturn StructKeyExists(variables.values, arguments.name) />
	</cffunction>
	
	<!--- removeValue --->
	<cffunction name="removeValue" hint="I remove a value from the event" output="false" returntype="void">
		<cfargument name="name" hint="I am the name of the value being removed." required="yes" type="string" />
		<cfset StructDelete(variables.values, arguments.name) />
	</cffunction>
	
	<!--- name --->
    <cffunction name="setName" access="public" output="false" returntype="void">
       <cfargument name="name" hint="I am the name of the event." required="yes" type="string" />
       <cfset variables.name = arguments.name />
    </cffunction>
    <cffunction name="getName" access="public" output="false" returntype="string">
       <cfreturn variables.name />
    </cffunction>
	
	<!--- values --->
    <cffunction name="setValues" access="public" output="false" returntype="void">
       <cfargument name="values" hint="I am the values being passed in the event" required="yes" type="struct" />
       <cfset variables.values = arguments.values />
    </cffunction>
    <cffunction name="getValues" access="public" output="false" returntype="struct">
       <cfreturn variables.values />
    </cffunction>
	
	<!--- source --->
    <cffunction name="setSource" access="public" output="false" returntype="void">
       <cfargument name="source" hint="I am the source of the event" required="yes" type="reactor.base.abstractRecord" />
       <cfset variables.source = arguments.source />
    </cffunction>
    <cffunction name="getSource" access="public" output="false" returntype="reactor.base.abstractRecord">
       <cfreturn variables.source />
    </cffunction>
</cfcomponent>