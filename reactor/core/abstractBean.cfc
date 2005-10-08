<cfcomponent hint="I am an abstract form bean.  If you extend me to create a bean, you can then pass the extended form bean into any data bean to automatically populate it.">
	
	<cffunction name="getFields" access="public" hint="I return a list of fields represented by this form bean." output="false" returntype="string">
		<cfset var functions = GetMetaData(this).functions />
		<cfset var x = 0 />
		<cfset var fields = "" />
		
		<cfloop from="1" to="#ArrayLen(functions)#" index="x">
			<cfif Left(functions[x].name, 3) IS "get">
				<cfset fields = ListAppend(fields, Right(functions[x].name, Len(functions[x].name) - 3)) />
			</cfif> 
		</cfloop>	
				
		<cfreturn fields/>
	</cffunction>
	
	<cffunction name="populate" access="public" hint="I populate this form bean from a data bean." output="false" returntype="void">
		<cfargument name="Record" hint="I am the data bean to use to populate this form bean." required="yes" type="Reactor.core.abstractRecord" />
		<cfset var functions = GetMetaData(this).functions />
		<cfset var TO = arguments.Record.getTo() />
		<cfset var x = 0 />
		<cfset var fields = "" />
		<cfset var field = "" />
		<cfset var args = 0 />
		<cfset var paramName = "" />
		
		<!--- loop over all the functions in this form bean.  we're going to be matching setter names to field names in the TO --->
		<cfloop from="1" to="#ArrayLen(functions)#" index="x">
			<!--- check to see if this function is a setter --->
			<cfif Left(functions[x].name, 3) IS "set">
				<!--- if so, get the name of the field it represents --->
				<cfset field = Right(functions[x].name, Len(functions[x].name) - 3) />
				
				<!--- check to see if the TO has a field for this setter --->
				<cfif StructKeyExists(TO, field)>
					<!--- it does, not we need to find out the name of the argument in the setter --->
					<cfset paramName = GetMetaData(this[functions[x].name]).parameters[1].name />
					
					<!--- create an arguments structure which sets the paramName to the value for that param --->
					<cfset args = StructNew() />
					<cfset args[paramName] = TO[field] />
					
					<!--- invoke the setter method on this form bean --->
					<cftry>
						<cfinvoke component="#this#" method="set#field#" argumentcollection="#args#" />
						<cfcatch></cfcatch>
					</cftry>
				</cfif>
			</cfif> 
		</cfloop>	
	</cffunction> 
	
	<cffunction name="getSignature" access="public" hint="I return this object's corrisponding DB signature." output="false" returntype="string">
		<cfreturn variables.signature />
	</cffunction>
	
</cfcomponent>