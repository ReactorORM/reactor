<cfcomponent hint="I am am object which represents an order imposed on a query.">

	<cfset variables.query = 0 />

	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the criteria object" output="false" returntype="any" _returntype="reactor.query.order">
		<cfargument name="query" hint="I am the array of order commands." required="yes" type="any" _type="ractor.query.query">
		
		<cfset variables.query = arguments.query />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addOrderCommand" access="private" hint="I append a node to the order expression" output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="params" hint="I am the arguments to pass" required="yes" type="struct" />
		<cfargument name="method" hint="I am the name of the method to call" required="yes" type="string" />
		
		<cfset variables.query.addOrderCommand(arguments.params, arguments.method) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setAsc" access="public" hint="I add an assending order." output="false" returntype="any" _returntype="reactor.query.order">
		<cfargument name="objectAlias" hint="I am the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the name of the field" required="yes" type="any" _type="string" />
		
		<cfset addOrderCommand(arguments, "setAsc") />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDesc" access="public" hint="I add an descending order." output="false" returntype="any" _returntype="reactor.query.order">
		<cfargument name="objectAlias" hint="I am the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the name of the field" required="yes" type="any" _type="string" />
		
		<cfset addOrderCommand(arguments, "setDesc") />
		<cfreturn this />
	</cffunction>

</cfcomponent>


	<!--- order
    <cffunction name="setOrder" access="private" output="false" returntype="void">
       <cfargument name="order" hint="I am the array of order by statements" required="yes" type="any" _type="array" />
       <cfset variables.order = arguments.order />
    </cffunction>
    <cffunction name="getOrder" access="public" output="false" returntype="any" _returntype="array">
		<cfset var field = 0 />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(variables.order)#" index="x">
			
			<cfif IsStruct(variables.order[x])>
				<cfset field = getQuery().findObject(variables.order[x].objectAlias).getField(variables.order[x].fieldAlias) />
				
				<cfif StructKeyExists(field, "expression")>
					<cfset variables.order[x].expression = field.expression />
				</cfif>
			</cfif>
		</cfloop>
				
		<cfreturn variables.order />
    </cffunction> --->