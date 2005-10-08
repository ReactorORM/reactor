<cfcomponent hint="I am a component used to set various criteria on queries.">
	
	<cfset variables.Expression = CreateObject("Component", "reactor.core.expression") />
	<cfset variables.Order = CreateObject("Component", "reactor.core.order") />
	
	<cfset variables.fieldList = "" />
	<cfset variables.distinct = false />
	<cfset variables.maxRows = -1 />
	<cfset variables.cachedWithin = 0 />
	
	<!--- expression --->
    <cffunction name="setExpression" access="public" output="false" returntype="void">
       <cfargument name="expression" hint="I set the expression for the where statement" required="yes" type="reactor.core.expression" />
       <cfset variables.expression = arguments.expression />
    </cffunction>
    <cffunction name="getExpression" access="public" output="false" returntype="reactor.core.expression">
       <cfreturn variables.expression />
    </cffunction>
	
	<!--- order --->
    <cffunction name="setOrder" access="public" output="false" returntype="void">
       <cfargument name="order" hint="I set the order statement for the query" required="yes" type="reactor.core.order" />
       <cfset variables.order = arguments.order />
    </cffunction>
    <cffunction name="getOrder" access="public" output="false" returntype="reactor.core.order">
       <cfreturn variables.order />
    </cffunction>
	
	<!--- fieldList --->
    <cffunction name="setFieldList" access="public" output="false" returntype="void">
       <cfargument name="fieldList" hint="I am list of fields to include.  If not provided, all fields are returned." required="yes" type="string" />
       <cfset variables.fieldList = arguments.fieldList />
    </cffunction>
    <cffunction name="getFieldList" access="public" output="false" returntype="string">
       <cfreturn variables.fieldList />
    </cffunction>
	
	<!--- distinct --->
    <cffunction name="setDistinct" access="public" output="false" returntype="void">
       <cfargument name="distinct" hint="I indicate if the query should only return distinct matches" required="yes" type="boolean" />
       <cfset variables.distinct = arguments.distinct />
    </cffunction>
    <cffunction name="getDistinct" access="public" output="false" returntype="boolean">
       <cfreturn variables.distinct />
    </cffunction>
	
	<!--- maxrows --->
    <cffunction name="setMaxrows" access="public" output="false" returntype="void">
       <cfargument name="maxrows" hint="I set the maximum number of rows to return." required="yes" type="numeric" />
       <cfset variables.maxrows = arguments.maxrows />
    </cffunction>
    <cffunction name="getMaxrows" access="public" output="false" returntype="numeric">
       <cfreturn variables.maxrows />
    </cffunction>
	
	<!--- cachedWithin --->
    <cffunction name="setCachedWithin" access="public" output="false" returntype="void">
       <cfargument name="cachedWithin" hint="I set the time span within which the query is cached." required="yes" type="numeric" />
       <cfset variables.cachedWithin = arguments.cachedWithin />
    </cffunction>
    <cffunction name="getCachedWithin" access="public" output="false" returntype="numeric">
       <cfreturn variables.cachedWithin />
    </cffunction>
</cfcomponent>