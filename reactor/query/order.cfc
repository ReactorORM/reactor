<cfcomponent hint="I am am object which represents an order imposed on a query.">
	<!---
		Sean 3/7/2006: since we pool order objects (as part of query objects), there's
		no point in initializing variables in the pseudo-constructor
	<cfset variables.order = ArrayNew(1) />
	<cfset variables.query = 0 />
	--->
 
	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the criteria object" output="false" returntype="reactor.query.order">
		<cfargument name="query" hint="I am the query this where expression is in." required="yes" type="reactor.query.query">
		
		<!---
			Sean 3/7/2006: order objects remain part of pooled query objects now
			need to re-init everything because we rely on the query object re-running our init()
		--->
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
		<cfargument name="object" hint="I am the alias of the object of the field should be in" required="yes" type="string" />
		<cfargument name="field" hint="I am the name of the field to validate" required="yes" type="string" />
		
		<cfset getQuery().findObject(arguments.object).getObjectMetadata().getField(arguments.field) />
	</cffunction>
	
	<cffunction name="appendNode" access="private" hint="I append a node to the where expression" output="false" returntype="reactor.query.order">
		<cfargument name="node" hint="I am the node to append" required="yes" type="struct" />
		<cfargument name="direction" hint="I am the direction" required="yes" type="string" />
		<cfset var order = getOrder() />
				
		<cfset arguments.node.direction = arguments.direction />
		
		<cfset node.alias = node.field />
		<cfset node.field = getQuery().findObject(node.object).getObjectMetadata().getField(node.field).name />
		
		<cfset ArrayAppend(order, node) />	
		<cfset setOrder(order) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setAsc" access="public" hint="I add an assending order." output="false" returntype="reactor.query.order">
		<cfargument name="object" hint="I am the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		
		<cfset appendNode(arguments, "ASC") />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDesc" access="public" hint="I add an descending order." output="false" returntype="reactor.query.order">
		<cfargument name="object" hint="I am the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		
		<cfset appendNode(arguments, "DESC") />
		<cfreturn this />
	</cffunction>

	<!--- order --->
    <cffunction name="setOrder" access="private" output="false" returntype="void">
       <cfargument name="order" hint="I am the array of order by statements" required="yes" type="array" />
       <cfset variables.order = arguments.order />
    </cffunction>
    <cffunction name="getOrder" access="public" output="false" returntype="array">
       <cfreturn variables.order />
    </cffunction>
	
</cfcomponent>