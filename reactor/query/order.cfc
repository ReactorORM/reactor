<cfcomponent hint="I am am object which represents an order imposed on a query.">

	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the criteria object" output="false" returntype="reactor.query.order">
		<cfargument name="query" hint="I am the query this where expression is in." required="yes" type="reactor.query.query">
		
		<cfset variables.order = ArrayNew(1) />
		<cfset setQuery(arguments.query) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- query --->
    <cffunction name="setQuery" access="private" output="false" returntype="void">
       <cfargument name="query" hint="I am the query this where expression is in." required="yes" type="reactor.query.query" />
       <cfset variables.query = arguments.query />
    </cffunction>
    <cffunction name="getQuery" access="private" output="false" returntype="reactor.query.query">
       <cfreturn variables.query />
    </cffunction>
	
	<!--- validateField --->
	<cffunction name="validateField" access="private" output="false" returntype="void">
		<cfargument name="objectAlias" hint="I am the alias of the object of the field should be in" required="yes" type="string" />
		<cfargument name="fieldAlias" hint="I am the name of the field to validate" required="yes" type="string" />
		
		<cfset getQuery().findObject(arguments.objectAlias).getObjectMetadata().getField(arguments.fieldAlias) />
	</cffunction>
	
	<cffunction name="appendNode" access="private" hint="I append a node to the where expression" output="false" returntype="reactor.query.order">
		<cfargument name="node" hint="I am the node to append" required="yes" type="struct" />
		<cfargument name="direction" hint="I am the direction" required="yes" type="string" />
		<cfset var order = getOrder() />
				
		<cfset arguments.node.direction = arguments.direction />
		
		<cfset node.fieldAlias = node.fieldAlias />
		<cfset node.fieldName = getQuery().findObject(node.objectAlias).getObjectMetadata().getField(node.fieldAlias).name />
		
		<cfset ArrayAppend(order, node) />	
		<cfset setOrder(order) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setAsc" access="public" hint="I add an assending order." output="false" returntype="reactor.query.order">
		<cfargument name="objectAlias" hint="I am the object the field is in" required="yes" type="string" />
		<cfargument name="fieldAlias" hint="I am the name of the field" required="yes" type="string" />
		
		<cfset validateField(arguments.objectAlias, arguments.fieldAlias) />
		
		<cfset appendNode(arguments, "ASC") />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDesc" access="public" hint="I add an descending order." output="false" returntype="reactor.query.order">
		<cfargument name="objectAlias" hint="I am the object the field is in" required="yes" type="string" />
		<cfargument name="fieldAlias" hint="I am the name of the field" required="yes" type="string" />
		
		<cfset validateField(arguments.objectAlias, arguments.fieldAlias) />
		
		<cfset appendNode(arguments, "DESC") />
		<cfreturn this />
	</cffunction>

	<!--- order --->
    <cffunction name="setOrder" access="private" output="false" returntype="void">
       <cfargument name="order" hint="I am the array of order by statements" required="yes" type="array" />
       <cfset variables.order = arguments.order />
    </cffunction>
    <cffunction name="getOrder" access="public" output="false" returntype="array">
		<cfset var field = 0 />
		
		<cfloop from="1" to="#ArrayLen(variables.order)#" index="x">
			
			<cfif IsStruct(variables.order[x])>
				<cfset field = getQuery().findObject(variables.order[x].objectAlias).getField(variables.order[x].fieldAlias) />
				
				<cfif StructKeyExists(field, "expression")>
					<cfset variables.order[x].expression = field.expression />
				</cfif>
			</cfif>
		</cfloop>
				
		<cfreturn variables.order />
    </cffunction>
	
</cfcomponent>