<cfcomponent hint="I am a component used to define ad-hoc queries.">
	<!---
		Sean 3/7/2006: since we pool query objects, there's no point in
		initializing variables in the pseudo-constructor, except for creating
		the where and order objects - uninitialized (createObject() is the
		expense we're trying to avoid for future initializations!)

	< !--- the from object --- >
	<cfset variables.From = 0 />

	< !--- query parts --- >
	<cfset variables.maxRows = -1 />
	<cfset variables.distinct = false />	
	
	< !--- fields --- >
	<cfset variables.returnFields = ArrayNew(1) />
	--->
	
	<!--- default where object (initialized in init() below) --->
	<cfset variables.where = CreateObject("Component", "reactor.query.where") />

	<!--- default order object (initialized in init() below)  --->
	<cfset variables.order = CreateObject("Component", "reactor.query.order") />
 
	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the criteria object" output="false" returntype="reactor.query.query">
		<cfargument name="BaseObjectMetadata" hint="I am the Metadata for the base object being queried" required="yes" type="reactor.base.abstractMetadata">
		<cfset var Object = 0 />
		
		<!---
			Sean 3/7/2006: query objects are pooled now, so we do not create new
			where and order objects each time we are initialized (only when we are
			first created - see pseudo-constructor above)
			
			that also means we must initialize all our instance data here
		--->

		<!--- the from object --->
		<cfset variables.From = 0 />
	
		<!--- query parts --->
		<cfset variables.maxRows = -1 />
		<cfset variables.distinct = false />	
		
		<!--- fields --->
		<cfset variables.returnFields = ArrayNew(1) />
		
		<!--- where --->
		<cfset variables.where.init(this) />
	
		<!--- order --->
		<cfset variables.order.init(this) />
		
		<!--- this var indicates if the query has been initalized if false then the query is new or has been reclaimed into the pool --->
		<cfset variables.initialized = true />
		
		<!--- convention --->
		<cfset variables.convention = arguments.BaseObjectMetadata.getConventions() />

		<cfset Object = CreateObject("Component", "reactor.query.object").init(arguments.BaseObjectMetadata, arguments.BaseObjectMetadata.getAlias()) />
		
		<cfset setFrom(Object) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- verifyInitialized --->
	<cffunction name="verifyInitialized" access="public" hint="I confirm that this query has been initalized and is in a usable state.  If not, I throw an error." output="false" returntype="void">
		<cfif NOT getInitialized()>
			<!--- the query is not initalized - throw an error --->
			<cfthrow message="Query Not Initalized" detail="The query object is not initalized.  This is most likely caused by using a query which has been reclaimed into the query-object pool.  This happens by default when the getByQuery method is called.  If you do not want this query to be recmailed then you should pass 'false' into the second argument on getByQuery, releaseQuery." type="reactor.query.QueryNotInitalized" />
		</cfif>
	</cffunction>
	
	<!--- returnObjectFields --->
	<cffunction name="returnObjectFields" access="public" hint="I specify a particular object from which all fields should be returned. When this or returnField() is first called cause only the specified column to be returned.  Additional columns can be added with multiple calls." output="false" returntype="reactor.query.query">
		<cfargument name="alias" hint="I am the alias of the object." required="yes" type="string" />
		<cfset var fields = findObject(arguments.alias).getFields() />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfset returnField(arguments.alias, fields[x].alias) />
		</cfloop>
		
		<cfreturn this />
	</cffunction>
	
	<!--- returnField --->
	<cffunction name="returnField" access="public" hint="I specify a particular field a query should return.  When this or returnObjectFields() is first called I cause only the specified column to be returned.  Additional columns can be added with multiple calls." output="false" returntype="reactor.query.query">
		<cfargument name="object" hint="I am the alias of the object." required="yes" type="string" />
		<cfargument name="field" hint="I am the alias of the field." required="yes" type="string" />
		<cfset var fieldStruct = getField(arguments.object, arguments.field) />
		<cfset var returnFields = getReturnFields() />
		
		<!--- add a field to return --->
		<cfset ArrayAppend(returnFields, CreateObject("Component", "reactor.query.field").init(arguments.object, fieldStruct.name, fieldStruct.alias)) />
		<cfset setReturnFields(returnFields) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- setFieldExpression --->
	<cffunction name="setFieldExpression" access="public" hint="I am used to modify the value of a field when it's selected." output="false" returntype="reactor.query.query">
		<cfargument name="object" hint="I am the alias of the object." required="yes" type="string" />
		<cfargument name="field" hint="I am the alias of the field." required="yes" type="string" />
		<cfargument name="expression" hint="I am the expression to add replace the field with." required="yes" type="string" />
		<cfargument name="datatype" hint="I am the cfsql data type to use." required="no" type="string" />
		<cfset var fieldStruct = getField(arguments.object, arguments.field) />
		
		<cfset fieldStruct["expression"] = arguments.expression />
		
		<cfif IsDefined("arguments.datatype")>
			<cfset fieldStruct.cfsqltype = arguments.datatype />
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<!--- from --->
    <cffunction name="setFrom" access="private" output="false" returntype="void">
		<cfargument name="from" hint="I am the to from statement" required="yes" type="reactor.query.object" />
		<cfset variables.from = arguments.from />
    </cffunction>
    <cffunction name="getFrom" access="public" output="false" returntype="reactor.query.object">
		<cfset verifyInitialized() />
		<cfreturn variables.from />
    </cffunction>
	
	<!--- getFromAsString --->
	<cffunction name="getFromAsString" access="public" hint="I convert the from objects to a sql from fragment." output="false" returntype="string">
		<cfreturn getFrom().getFromAsString(variables.convention) />
	</cffunction>
	
	<!--- getSelectAsString --->
	<cffunction name="getSelectAsString" access="public" hint="I convert the from objects to a sql select fragment" output="false" returntype="string">
		<cfreturn getFrom().getSelectAsString(variables.convention, getReturnFields()) />
	</cffunction>
	
	<!--- findObject --->
	<cffunction name="findObject" access="package" hint="I find an object in the query" output="false" returntype="reactor.query.object">
		<cfargument name="alias" hint="I am the alias of a object being searched for." required="yes" type="string" />
		<cfset var Object = 0 />
		
		<cfset verifyInitialized() />
		
		<cfset Object = getFrom().findObject(arguments.alias) />
		
		<cfif IsObject(Object)>
			<cfreturn Object />
		</cfif>

		<cfthrow message="Can Not Find Object" detail="Can not find the object '#arguments.alias#' as an alias or name within the query." type="reactor.findObject.CanNotFindObject" />
	</cffunction>
	
	<!--- join --->
	<cffunction name="join" access="public" hint="I join one object to another." output="false" returntype="reactor.query.query">
		<cfargument name="from" hint="I am the alias of a object being joined from." required="yes" type="string" />
		<cfargument name="to" hint="I am the alias of an object being joined to." required="yes" type="string" />
		<cfargument name="toPrefix" hint="I am an optional prefix appended to all fields in the to Object which are returned in this query." required="no" type="string" default="" />
		<cfargument name="type" hint="I am the type of join. Options are: left, right, full" required="no" type="string" default="inner" />
		<cfset var FromObject = findObject(arguments.from) />
		<cfset var ToObject = FromObject.getRelatedObject(arguments.to) />
		<cfset FromObject.join(ToObject, arguments.toPrefix, arguments.type) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- maxrows --->
    <cffunction name="setMaxrows" hint="I configure the number of rows returned by the query." access="public" output="false" returntype="void">
		<cfargument name="maxrows" hint="I set the maximum number of rows to return. If -1 all rows are returned." required="yes" type="numeric" />
		<cfset verifyInitialized() />
		<cfset variables.maxrows = arguments.maxrows />
    </cffunction>
    <cffunction name="getMaxrows" access="public" output="false" returntype="numeric">
		<cfset verifyInitialized() />
		<cfreturn variables.maxrows />
    </cffunction>
	
	<!--- distinct --->
    <cffunction name="setDistinct" hint="I indicate if only distinct rows should be returned" access="public" output="false" returntype="void">
		<cfargument name="distinct" hint="I indicate if the query should only return distinct matches" required="yes" type="boolean" />
		<cfset verifyInitialized() />
		<cfset variables.distinct = arguments.distinct />
    </cffunction>
    <cffunction name="getDistinct" access="public" output="false" returntype="boolean">
		<cfset verifyInitialized() />
		<cfreturn variables.distinct />
    </cffunction>
			
	<!--- where --->
    <cffunction name="setWhere" access="public" output="false" returntype="void">
		<cfargument name="where" hint="I am the query's where experssion" required="yes" type="reactor.query.where" />
		<cfset verifyInitialized() />
		<cfset variables.where = arguments.where />
    </cffunction>
    <cffunction name="getWhere" access="public" output="false" returntype="reactor.query.where">
		<cfset verifyInitialized() />
		<cfreturn variables.where />
    </cffunction>
	<cffunction name="resetWhere" access="public" output="false" returntype="void">
		<cfset verifyInitialized() />
		<cfset variables.where = CreateObject("Component", "reactor.query.where").init(this) />
	</cffunction>
	
	<!--- getField --->
	<cffunction name="getField" access="public" hint="I get a column based on the provided object name/alias and field name" output="false" returntype="struct">
		<cfargument name="object" hint="I am the alias of the object." required="yes" type="string" />
		<cfargument name="field" hint="I am the name of the field." required="yes" type="string" />
		
		<cfreturn findObject(arguments.object).getField(arguments.field) />
	</cffunction>
	
	<!--- order --->
    <cffunction name="setOrder" access="public" output="false" returntype="void">
		<cfargument name="order" hint="I am the order expression" required="yes" type="reactor.query.order" />
		<cfset verifyInitialized() />
		<cfset variables.order = arguments.order />
    </cffunction>
    <cffunction name="getOrder" access="public" output="false" returntype="reactor.query.order">
		<cfset verifyInitialized() />
		<cfreturn variables.order />
    </cffunction>
	<cffunction name="resetOrder" access="public" output="false" returntype="void">
		<cfset verifyInitialized() />
		<cfset variables.order = CreateObject("Component", "reactor.query.order").init(this) />
	</cffunction>
	
	<!--- returnFields --->
    <cffunction name="setReturnFields" access="private" output="false" returntype="void">
		<cfargument name="returnFields" hint="I am an array of fields to return.  If empty all fields are returned." required="yes" type="array" />
		<cfset variables.returnFields = arguments.returnFields />
    </cffunction>
    <cffunction name="getReturnFields" access="private" output="false" returntype="array">
		<cfreturn variables.returnFields />
    </cffunction>
	<cffunction name="resetReturnFields" access="public" output="false" returntype="void">
		<cfset verifyInitialized() />
		<cfset variables.returnFields = ArrayNew(1) />
	</cffunction>
	
	<!--- initialized --->
    <cffunction name="setInitialized" access="public" output="false" returntype="void">
		<cfargument name="initialized" hint="I indicate if the query has been initalized." required="yes" type="boolean" />
		<cfset variables.initialized = arguments.initialized />
    </cffunction>
    <cffunction name="getInitialized" access="public" output="false" returntype="boolean">
		<cfreturn variables.initialized />
    </cffunction>
</cfcomponent>
