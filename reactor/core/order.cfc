<cfcomponent hint="I am am object which represents an order imposed on a query.">
	
	<cfset variables.order = "" />
	
	<cffunction name="setAsc" access="public" hint="I add an assending order." output="false" returntype="reactor.core.order">
		<cfargument name="field" hint="I am the name of the field to sort." required="yes" type="string" />
		
		<cfset appendOrder("[#arguments.field#] ASC") />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDesc" access="public" hint="I add an descending order." output="false" returntype="reactor.core.order">
		<cfargument name="field" hint="I am the name of the field to sort." required="yes" type="string" />
		
		<cfset appendOrder("[#arguments.field#] DESC") />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="appendOrder" access="private" output="false" returntype="void">
		<cfargument name="orderToAppend" hint="I am the order statement to append." required="yes" type="string" />
		<cfset var order = getOrder() />
		
		<cfif Len(order)>
			<cfset order = order & ", " />
		</cfif>
		
		<cfset order = order  & arguments.orderToAppend />
	   
		<cfset setOrder(order) />
    </cffunction>
	
	<!--- order --->
    <cffunction name="setOrder" access="private" output="false" returntype="void">
       <cfargument name="order" hint="I am the order string" required="yes" type="string" />
       <cfset variables.order = arguments.order />
    </cffunction>
    <cffunction name="getOrder" access="private" output="false" returntype="string">
       <cfreturn variables.order />
    </cffunction>
	
	<cffunction name="asString" access="public" output="false" returntype="string">
       <cfreturn variables.order />
    </cffunction>
	
</cfcomponent>