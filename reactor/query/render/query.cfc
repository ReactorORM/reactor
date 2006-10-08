<cfcomponent hint="I am a component used to define ad-hoc queries used throughout Reactor.">
	
	<!--- I'm putting data in variables.instance so that I can easily clear the instance struct to reset this object for pooling --->
	<cfset variables.instance = StructNew() />
	
	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the query." output="false" returntype="any" _returntype="reactor.query.render.query">
		<cfargument name="objectAlias" hint="I am the alias of the object that will be queried." required="yes" type="any" _type="string" />
		<cfargument name="queryAlias" hint="I am the alias of the object within the query." required="yes" type="any" _type="string" />
		<cfargument name="ReactorFactory" hint="I am the ReactorFactory" required="yes" type="any" _type="reactor.reactorFactory" />
		<cfset var externalFields = 0 />
		<cfset var x = 0 />
		
		<!--- this is the base object being queried --->
		<cfset setObject(CreateObject("Component", "reactor.query.render.object").init(arguments.ReactorFactory.createMetadata(arguments.objectAlias), arguments.queryAlias, arguments.ReactorFactory)) />
		<!--- by default we want to return all fields --->
		<cfset variables.instance.returnFields = ArrayNew(1) />
				
		<!--- configure the distinct / maxrows --->
		<cfset variables.instance.distinct = false />
		<cfset variables.instance.maxrows = -1 />
		
		<!--- create/reset the where and order --->
		<cfset resetWhere() />
		<cfset resetOrder() />

		<!--- join any external objects --->
		<cfif getObject().getObjectMetadata().hasExternalFields()>
			<cfset externalFields = getObject().getObjectMetadata().getExternalFieldQuery() />

			<!--- loop over all the objects (which are already sorted by the source alias) --->
			<cfoutput query="externalFields" group="sourceAlias">
				<!--- join to the source object --->
				<cfset leftJoin(getObject().getObjectMetadata().getAlias(), externalFields.sourceName, externalFields.sourceAlias, "ReactorReadOnly" & externalFields.sourceAlias) />
				<cfoutput>
					<!--- only return filds in that object --->
					<cfset setFieldAlias("ReactorReadOnly" & externalFields.sourceAlias, externalFields.field, externalFields.fieldAlias) />
					<cfset returnObjectFields("ReactorReadOnly" & externalFields.sourceAlias, externalFields.fieldAlias) />
				</cfoutput>
			</cfoutput>
			
			<!--- make sure all the fields from the base object are returned --->
			<cfset returnObjectFields(getObject().getObjectMetadata().getAlias()) />
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<!--- setFieldAlias --->
	<cffunction name="setFieldAlias" access="public" hint="I set an alias on the field from the named object." output="false" returntype="void">
		<cfargument name="objectAlias" hint="I am the alias of the object that the alias is being set for." required="yes" type="any" _type="string" />
		<cfargument name="currentAlias" hint="I am current field alias." required="yes" type="any" _type="string" />
		<cfargument name="newAlias" hint="I am new field alias to use." required="yes" type="any" _type="string" />
		<cfset findObject(arguments.objectAlias).setFieldAlias(arguments.currentAlias, arguments.newAlias) />
				
	</cffunction>
	
	<!--- returnObjectFields --->
	<cffunction name="returnObjectFields" access="public" hint="I specify a particular object from which all fields (or the spcified list of fields) should be returned. When this or returnObjectField() is first called they cause only the specified column(s) to be returned.  Additional columns can be added with multiple calls to these functions." output="false" returntype="any" _returntype="reactor.query.render.query">
		<cfargument name="objectAlias" hint="I am the object alias that is being searched for." required="yes" type="any" _type="string" />
		<cfargument name="fieldAliasList" hint="I am an optiona list of specific field aliass to return." required="no" type="any" _type="string" default="" />
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
	<cffunction name="returnObjectField" access="public" hint="I specify a particular field a query should return.  When this or returnObjectFields() is first called they cause only the specified column(s) to be returned.  Additional columns can be added with multiple calls to these functions." output="false" returntype="any" _returntype="reactor.query.render.query">
		<cfargument name="objectAlias" hint="I am the object alias that is being searched for." required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the alias of the field." required="yes" type="any" _type="string" />
		<cfset var field = StructNew() />
		<cfset field.objectAlias = arguments.objectAlias />
		<cfset field.fieldAlias = arguments.fieldAlias />
		
		<cfset ArrayAppend(variables.instance.returnFields, field) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- setFieldPrefix --->
	<cffunction name="setFieldPrefix" access="public" hint="I I set a prefix prepended to all fields returned from the named object." output="false" returntype="void">
		<cfargument name="objectAlias" hint="I am the alias of the object that the prefix is being added to." required="yes" type="any" _type="string" />
		<cfargument name="prefix" hint="I am the prefix to prepend." required="yes" type="any" _type="string" />
		<cfset findObject(arguments.objectAlias).setFieldPrefix(arguments.prefix) />
				
	</cffunction>
	
	<!--- setFieldExpression --->
	<cffunction name="setFieldExpression" access="public" hint="I am used to modify the value of a field when it's selected." output="false" returntype="any" _returntype="reactor.query.render.query">
		<cfargument name="objectAlias" hint="I am the object alias that is being searched for." required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the alias of the field." required="yes" type="any" _type="string" />
		<cfargument name="expression" hint="I am the expression to add replace the field with." required="yes" type="any" _type="string" />
		<cfargument name="cfDataType" hint="I am the cfsql data type to use." required="no" type="any" _type="string" />
		<cfset var Object = findObject(arguments.objectAlias) />
		
		<cfset StructDelete(arguments, "objectAlias")>
			
		<cfinvoke component="#Object#" method="setFieldExpression" argumentcollection="#arguments#" />
		
		<cfreturn this />
	</cffunction>
	
	<!--- hasJoins --->
	<cffunction name="hasJoins" access="public" hint="I indicate if this object is joined to any others." output="false" returntype="any" _returntype="boolean">
		<cfreturn getObject().hasJoins() />
	</cffunction>
	
	<!--- join --->
	<cffunction name="join" access="public" hint="I am a convenience method which simply calls innerJoin." output="false" returntype="any" _returntype="reactor.query.render.query">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="any" _type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="any" _type="string" default="#arguments.joinToObjectAlias#" />
		
		<cfset innerJoin(joinFromObjectAlias=arguments.joinFromObjectAlias, joinToObjectAlias=arguments.joinToObjectAlias, relationshipAlias=arguments.relationshipAlias, alias=arguments.alias) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- innerJoin --->
	<cffunction name="innerJoin" access="public" hint="I create an iuner join from this object to another object via the specified relationship which can be on either object." output="false" returntype="any" _returntype="reactor.query.render.query">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="any" _type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="any" _type="string" default="#arguments.joinToObjectAlias#" />
		
		<cfset findObject(arguments.joinFromObjectAlias).addJoin(joinToObjectAlias=arguments.joinToObjectAlias, relationshipAlias=arguments.relationshipAlias, alias=arguments.alias, joinType="inner") />
		
		<cfreturn this />
	</cffunction>
	
	<!--- leftJoin --->
	<cffunction name="leftJoin" access="public" hint="I create a left join from this object to another object via the specified relationship which can be on either object." output="false" returntype="any" _returntype="reactor.query.render.query">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="any" _type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="any" _type="string" default="#arguments.joinToObjectAlias#" />
		
		<cfset findObject(arguments.joinFromObjectAlias).addJoin(joinToObjectAlias=arguments.joinToObjectAlias, relationshipAlias=arguments.relationshipAlias, alias=arguments.alias, joinType="left") />
		
		<cfreturn this />
	</cffunction>
	
	<!--- rightJoin --->
	<cffunction name="rightJoin" access="public" hint="I create a right join from this object to another object via the specified relationship which can be on either object." output="false" returntype="any" _returntype="reactor.query.render.query">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="any" _type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="any" _type="string" default="#arguments.joinToObjectAlias#" />
		
		<cfset findObject(arguments.joinFromObjectAlias).addJoin(joinToObjectAlias=arguments.joinToObjectAlias, relationshipAlias=arguments.relationshipAlias, alias=arguments.alias, joinType="right") />		
		
		<cfreturn this />
	</cffunction>
	
	<!--- fullJoin --->
	<cffunction name="fullJoin" access="public" hint="I create a right join from this object to another object via the specified relationship which can be on either object." output="false" returntype="any" _returntype="reactor.query.render.query">
		<cfargument name="joinFromObjectAlias" hint="I am the alias of the object being joined from." required="yes" type="any" _type="string" />
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="no" type="any" _type="string" default="#arguments.joinToObjectAlias#" />
		
		<cfset findObject(arguments.joinFromObjectAlias).addJoin(joinToObjectAlias=arguments.joinToObjectAlias, relationshipAlias=arguments.relationshipAlias, alias=arguments.alias, joinType="full") />		
		
		<cfreturn this />
	</cffunction>
	
	<!--- getSelectAsString --->
	<cffunction name="getSelectAsString" access="public" hint="I return the fields to be seleted for the query." output="false" returntype="any" _returntype="string">
		<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="any" _type="reactor.data.abstractConvention" />
		
		<cfreturn getObject().getSelectAsString(arguments.Convention, variables.instance.returnFields) />
	</cffunction>
	
	<!--- getFromAsString --->
	<cffunction name="getFromAsString" access="public" hint="I return a from statement for the query." output="false" returntype="any" _returntype="string">
		<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfset var from = arguments.Convention.formatObjectAlias(getObject().getObjectMetadata(), getObject().getAlias()) />
		
		<cfset from = from & getObject().getJoinsAsString(arguments.Convention) />

		<cfreturn from />
	</cffunction>
	
	<!--- getDeleteAsString --->
	<cffunction name="getDeleteAsString" access="public" hint="I return a from statement for a delete statement." output="false" returntype="any" _returntype="string">
		<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfset var from = arguments.Convention.formatObjectName(getObject().getObjectMetadata()) />
		
		<cfreturn from />
	</cffunction>
	
	<!--- findObject --->
	<cffunction name="findObject" access="public" hint="I am used to find a specific object in the query based on its alias.  If the object can not be found an error is thrown." output="false" returntype="any" _returntype="object">
		<cfargument name="objectAlias" hint="I am the object alias that is being searched for." required="yes" type="any" _type="string" />
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
		
	<!--- object --->
    <cffunction name="setObject" access="private" output="false" returntype="void">
       <cfargument name="object" hint="I am the base object being queried" required="yes" type="any" _type="reactor.query.render.object" />
       <cfset variables.instance.object = arguments.object />
    </cffunction>
    <cffunction name="getObject" access="private" output="false" returntype="any" _returntype="reactor.query.render.object">
       <cfreturn variables.instance.object />
    </cffunction>
	
	<!--- maxrows --->
    <cffunction name="setMaxrows" hint="I configure the number of rows returned by the query." access="public" output="false" returntype="void">
		<cfargument name="maxrows" hint="I set the maximum number of rows to return. If -1 all rows are returned." required="yes" type="any" _type="numeric" />
		<cfset variables.instance.maxrows = arguments.maxrows />
    </cffunction>
    <cffunction name="getMaxrows" access="public" output="false" returntype="any" _returntype="numeric">
		<cfreturn variables.instance.maxrows />
    </cffunction>
	
	<!--- distinct --->
    <cffunction name="setDistinct" hint="I indicate if only distinct rows should be returned" access="public" output="false" returntype="void">
		<cfargument name="distinct" hint="I indicate if the query should only return distinct matches" required="yes" type="any" _type="boolean" />
		<cfset variables.instance.distinct = arguments.distinct />
    </cffunction>
    <cffunction name="getDistinct" access="public" output="false" returntype="any" _returntype="boolean">
		<cfreturn variables.instance.distinct />
    </cffunction>
	
	<!--- where --->
    <cffunction name="setWhere" access="public" output="false" returntype="void">
		<cfargument name="where" hint="I am the query's where experssion" required="yes" type="any" _type="reactor.query.render.where" />
		<cfset variables.instance.where = arguments.where />
    </cffunction>
    <cffunction name="getWhere" access="public" output="false" returntype="any" _returntype="reactor.query.render.where">
		<cfreturn variables.instance.where />
    </cffunction>
	<cffunction name="resetWhere" access="public" output="false" returntype="void">
		<cfset variables.instance.where = CreateObject("Component", "reactor.query.render.where").init(this) />
	</cffunction>
	
	<!--- order --->
    <cffunction name="setOrder" access="public" output="false" returntype="void">
		<cfargument name="order" hint="I am the order expression" required="yes" type="any" _type="reactor.query.render.order" />
		<cfset variables.instance.order = arguments.order />
    </cffunction>
    <cffunction name="getOrder" access="public" output="false" returntype="any" _returntype="reactor.query.render.order">
		<cfreturn variables.instance.order />
    </cffunction>
	<cffunction name="resetOrder" access="public" output="false" returntype="void">
		<cfset variables.instance.order = CreateObject("Component", "reactor.query.render.order").init(this) />
	</cffunction>
</cfcomponent>
