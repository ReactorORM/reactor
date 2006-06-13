<cfcomponent hint="I am a component used to define ad-hoc queries used throughout Reactor.">
	
	<!--- I'm putting data in variables.instance so that I can easily clear the instance struct to reset this object for pooling --->
	<cfset variables.instance = StructNew() />
	
	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the query." output="false" returntype="reactor.query.query">
		<cfargument name="objectAlias" hint="I am the alias of the object that will be queried." required="yes" type="string" />
		<cfargument name="queryAlias" hint="I am the alias of the object within the query." required="yes" type="string" />
		<cfargument name="ReactorFactory" hint="I am the ReactorFactory" required="yes" type="reactor.reactorFactory" />
		
		<!--- this is the base object being queried --->
		<cfset setObject(CreateObject("Component", "reactor.query.object").init(arguments.ReactorFactory.createMetadata(arguments.objectAlias), arguments.queryAlias, arguments.ReactorFactory)) />
		<!--- by default we want to return all fields --->
		<cfset variables.instance.returnFields = ArrayNew(1) />
		
		<!--- configure the distinct / maxrows --->
		<cfset variables.instance.distinct = false />
		<cfset variables.instance.maxrows = -1 />
		
		<!--- create/reset the where and order --->
		<cfset resetWhere() />
		<cfset resetOrder() />
		
		<cfreturn this />
	</cffunction>
	
	<!--- setFieldPrefix --->
	<cffunction name="setFieldPrefix" access="public" hint="I I set a prefix prepended to all fields returned from the named object." output="false" returntype="void">
		<cfargument name="objectAlias" hint="I am the alias of the object that the prefix is being added to." required="yes" type="string" />
		<cfargument name="prefix" hint="I am the prefix to prepend." required="yes" type="string" />
		<cfset findObject(arguments.objectAlias).setFieldPrefix(arguments.prefix) />
				
	</cffunction>
	
	<!--- returnObjectFields --->
	<cffunction name="returnObjectFields" access="public" hint="I specify a particular object from which all fields (or the spcified list of fields) should be returned. When this or returnObjectField() is first called they cause only the specified column(s) to be returned.  Additional columns can be added with multiple calls to these functions." output="false" returntype="reactor.query.query">
		<cfargument name="objectAlias" hint="I am the object alias that is being searched for." required="yes" type="string" />
		<cfargument name="fieldAliasList" hint="I am an optiona list of specific field aliass to return." required="no" type="string" default="" />
		<cfset var fieldAlias = "" />
		
		<cfif NOT Len(arguments.fieldAliasList)>
			<cfset ArrayAppend(variables.instance.returnFields, arguments.objectAlias) />
		<cfelse>
			<cfloop list="#arguments.fieldAliasList#" index="fieldAlias">
				<cfset returnObjectField(arguments.objectAlias, fieldAlias) />
			</cfloop>
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<!--- returnObjectField --->
	<cffunction name="returnObjectField" access="public" hint="I specify a particular field a query should return.  When this or returnObjectFields() is first called they cause only the specified column(s) to be returned.  Additional columns can be added with multiple calls to these functions." output="false" returntype="reactor.query.query">
		<cfargument name="objectAlias" hint="I am the object alias that is being searched for." required="yes" type="string" />
		<cfargument name="fieldAlias" hint="I am the alias of the field." required="yes" type="string" />
		<cfset var field = StructNew() />
		<cfset field.objectAlias = arguments.objectAlias />
		<cfset field.fieldAlias = arguments.fieldAlias />
		
		<cfset ArrayAppend(variables.instance.returnFields, field) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- setFieldExpression --->
	<cffunction name="setFieldExpression" access="public" hint="I am used to modify the value of a field when it's selected." output="false" returntype="reactor.query.query">
		<cfargument name="objectAlias" hint="I am the object alias that is being searched for." required="yes" type="string" />
		<cfargument name="fieldAlias" hint="I am the alias of the field." required="yes" type="string" />
		<cfargument name="expression" hint="I am the expression to add replace the field with." required="yes" type="string" />
		<cfargument name="cfDataType" hint="I am the cfsql data type to use." required="no" type="string" />
		<cfset var Object = findObject(arguments.objectAlias) />
		
		<cfset StructDelete(arguments, "objectAlias")>
			
		<cfinvoke component="#Object#" method="setFieldExpression" argumentcollection="#arguments#" />
		
		<cfreturn this />
	</cffunction>
	
	<!--- hasJoins --->
	<cffunction name="hasJoins" access="public" hint="I indicate if this object is joined to any others." output="false" returntype="boolean">
		<cfreturn getObject().hasJoins() />
	</cffunction>
	
	<!--- join --->
	<cffunction name="join" access="public" hint="I am a convenience method which simply calls innerJoin." output="false" returntype="reactor.query.query">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="string" default="#arguments.joinToObjectAlias#" />
		
		<cfset innerJoin(joinFromObjectAlias=arguments.joinFromObjectAlias, joinToObjectAlias=arguments.joinToObjectAlias, relationshipAlias=arguments.relationshipAlias, alias=arguments.alias) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- innerJoin --->
	<cffunction name="innerJoin" access="public" hint="I create an iuner join from this object to another object via the specified relationship which can be on either object." output="false" returntype="reactor.query.query">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="string" default="#arguments.joinToObjectAlias#" />
		
		<cfset findObject(arguments.joinFromObjectAlias).addJoin(joinToObjectAlias=arguments.joinToObjectAlias, relationshipAlias=arguments.relationshipAlias, alias=arguments.alias, joinType="inner") />
		
		<cfreturn this />
	</cffunction>
	
	<!--- leftJoin --->
	<cffunction name="leftJoin" access="public" hint="I create a left join from this object to another object via the specified relationship which can be on either object." output="false" returntype="reactor.query.query">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="string" default="#arguments.joinToObjectAlias#" />
		
		<cfset findObject(arguments.joinFromObjectAlias).addJoin(joinToObjectAlias=arguments.joinToObjectAlias, relationshipAlias=arguments.relationshipAlias, alias=arguments.alias, joinType="left") />
		
		<cfreturn this />
	</cffunction>
	
	<!--- rightJoin --->
	<cffunction name="rightJoin" access="public" hint="I create a right join from this object to another object via the specified relationship which can be on either object." output="false" returntype="reactor.query.query">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="string" default="#arguments.joinToObjectAlias#" />
		
		<cfset findObject(arguments.joinFromObjectAlias).addJoin(joinToObjectAlias=arguments.joinToObjectAlias, relationshipAlias=arguments.relationshipAlias, alias=arguments.alias, joinType="right") />		
		
		<cfreturn this />
	</cffunction>
	
	<!--- fullJoin --->
	<cffunction name="fullJoin" access="public" hint="I create a right join from this object to another object via the specified relationship which can be on either object." output="false" returntype="reactor.query.query">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="string" default="#arguments.joinToObjectAlias#" />
		
		<cfset findObject(arguments.joinFromObjectAlias).addJoin(joinToObjectAlias=arguments.joinToObjectAlias, relationshipAlias=arguments.relationshipAlias, alias=arguments.alias, joinType="full") />		
		
		<cfreturn this />
	</cffunction>
	
	<!--- getSelectAsString --->
	<cffunction name="getSelectAsString" access="public" hint="I return the fields to be seleted for the query." output="false" returntype="string">
		<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="reactor.data.abstractConvention" />
		
		<cfreturn getObject().getSelectAsString(arguments.Convention, variables.instance.returnFields) />
	</cffunction>
	
	<!--- getFromAsString --->
	<cffunction name="getFromAsString" access="public" hint="I return a from statement for the query." output="false" returntype="string">
		<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="reactor.data.abstractConvention" />
		<cfset var from = arguments.Convention.formatObjectAlias(getObject().getObjectMetadata(), getObject().getAlias()) />
		
		<cfset from = from & getObject().getJoinsAsString(arguments.Convention) />

		<cfreturn from />
	</cffunction>
	
	<!--- getDeleteAsString --->
	<cffunction name="getDeleteAsString" access="public" hint="I return a from statement for a delete statement." output="false" returntype="string">
		<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="reactor.data.abstractConvention" />
		<cfset var from = arguments.Convention.formatObjectName(getObject().getObjectMetadata()) />
		
		<cfreturn from />
	</cffunction>
	
	<!--- findObject --->
	<cffunction name="findObject" access="public" hint="I am used to find a specific object in the query based on its alias.  If the object can not be found an error is thrown." output="false" returntype="object">
		<cfargument name="objectAlias" hint="I am the object alias that is being searched for." required="yes" type="string" />
		<cfset var Object = 0 />
		
		<!--- try to find the object --->
		<cfset Object = getObject().findObject(arguments.objectAlias) />
		
		<!--- if this is an object return it --->
		<cfif IsObject(Object)>
			<cfreturn Object />
		</cfif>
	
		<!--- if it wasn't an object then throw an error, we couldn't find the requested object --->
		<cfthrow message="Can Not Find Object" detail="Can not find the object '#arguments.objectAlias#' as an object within the query." type="reactor.findObject.CanNotFindObject" />

	</cffunction>
	
	<!--- reset --->
	<cffunction name="reset" access="public" hint="I reset this CFC so that it can be reused in a pool of queries." output="false" returntype="void">
		<cfset StructClear(variables.instance) />
	</cffunction>
	
	<!--- object --->
    <cffunction name="setObject" access="private" output="false" returntype="void">
       <cfargument name="object" hint="I am the base object being queried" required="yes" type="reactor.query.object" />
       <cfset variables.instance.object = arguments.object />
    </cffunction>
    <cffunction name="getObject" access="private" output="false" returntype="reactor.query.object">
       <cfreturn variables.instance.object />
    </cffunction>
	
	<!--- maxrows --->
    <cffunction name="setMaxrows" hint="I configure the number of rows returned by the query." access="public" output="false" returntype="void">
		<cfargument name="maxrows" hint="I set the maximum number of rows to return. If -1 all rows are returned." required="yes" type="numeric" />
		<cfset variables.instance.maxrows = arguments.maxrows />
    </cffunction>
    <cffunction name="getMaxrows" access="public" output="false" returntype="numeric">
		<cfreturn variables.instance.maxrows />
    </cffunction>
	
	<!--- distinct --->
    <cffunction name="setDistinct" hint="I indicate if only distinct rows should be returned" access="public" output="false" returntype="void">
		<cfargument name="distinct" hint="I indicate if the query should only return distinct matches" required="yes" type="boolean" />
		<cfset variables.instance.distinct = arguments.distinct />
    </cffunction>
    <cffunction name="getDistinct" access="public" output="false" returntype="boolean">
		<cfreturn variables.instance.distinct />
    </cffunction>
	
	<!--- where --->
    <cffunction name="setWhere" access="public" output="false" returntype="void">
		<cfargument name="where" hint="I am the query's where experssion" required="yes" type="reactor.query.where" />
		<cfset variables.instance.where = arguments.where />
    </cffunction>
    <cffunction name="getWhere" access="public" output="false" returntype="reactor.query.where">
		<cfreturn variables.instance.where />
    </cffunction>
	<cffunction name="resetWhere" access="public" output="false" returntype="void">
		<cfset variables.instance.where = CreateObject("Component", "reactor.query.where").init(this) />
	</cffunction>
	
	<!--- order --->
    <cffunction name="setOrder" access="public" output="false" returntype="void">
		<cfargument name="order" hint="I am the order expression" required="yes" type="reactor.query.order" />
		<cfset variables.instance.order = arguments.order />
    </cffunction>
    <cffunction name="getOrder" access="public" output="false" returntype="reactor.query.order">
		<cfreturn variables.instance.order />
    </cffunction>
	<cffunction name="resetOrder" access="public" output="false" returntype="void">
		<cfset variables.instance.order = CreateObject("Component", "reactor.query.order").init(this) />
	</cffunction>
</cfcomponent>