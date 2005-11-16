<cfcomponent hint="I am a component used to set various criteria on queries.">
	
	<cfset variables.Expression = 0 />
	<cfset variables.Order = 0 />
	<cfset variables.Metadata = 0 />
	<cfset variables.distinct = false />
	<cfset variables.maxRows = -1 />
	<cfset variables.join = XmlParse("<join></join>") />
	
	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the criteria object" output="false" returntype="reactor.query.criteria">
		<cfargument name="Metadata" hint="I am the Metadata for the object being querired" required="yes" type="reactor.base.abstractMetadata">
		
		<cfset setObjectMetadata(arguments.metadata) />
		<cfset setExpression(CreateObject("Component", "reactor.query.expression").init(getObjectMetadata())) />
		<cfset setOrder(CreateObject("Component", "reactor.query.order").init(getObjectMetadata())) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- join --->
	<cffunction name="join" hint="I add a join to another object." access="public" output="false" returntype="void">
		<cfargument name="name" hint="The object to join" required="yes" type="string" />
		
		<!--- get the relationship to the specified object --->
		<cfswitch expression="#getObjectMetadata().getRelationshipType(arguments.name)#">
			<cfcase value="hasOne">
				<cfdump var="#getObjectMetadata().getHasOneRelation(arguments.name)#" />
			</cfcase>
			<cfcase value="hasMany">
				has many
			</cfcase>
			<cfcase value="none">
				<cfthrow message="No Relationship To Object" detail="The '#getObjectMetadata().getName()#' object does not have any relationships to the '#arguments.name#' object." type="reactor.join.No Relationship To Object" />
			</cfcase>
		</cfswitch>
		
		got here....<cfabort>
	</cffunction>
	
	<!--- metadata --->
    <cffunction name="setObjectMetadata" access="private" output="false" returntype="void">
       <cfargument name="metadata" hint="I am the xml metadata for the object being queried." required="yes" type="reactor.base.abstractMetadata" />
       <cfset variables.metadata = arguments.metadata />
    </cffunction>
    <cffunction name="getObjectMetadata" access="private" output="false" returntype="reactor.base.abstractMetadata">
       <cfreturn variables.metadata />
    </cffunction>
	
	<!--- validateField --->
	<cffunction name="validateField" access="private" output="false" returntype="void">
		<cfargument name="field" hint="I am the name of the field to validate" required="yes" type="string" />
		
		<cfif NOT ListFindNoCase(getObjectMetadata().getColumnList(), arguments.field)>
			<cfthrow message="Field Does Not Exist" detail="The field '#arguments.field#' does not exist in the object '#getObjectMetadata().getName()#'." type="reactor.validateField.Field Does Not Exist" />
		</cfif>
	</cffunction>
	
	<!--- expression --->
    <cffunction name="setExpression" access="public" output="false" returntype="void">
       <cfargument name="expression" hint="I set the expression for the where statement" required="yes" type="reactor.query.expression" />
       <cfset variables.expression = arguments.expression />
    </cffunction>
    <cffunction name="getExpression" access="public" output="false" returntype="reactor.query.expression">
       <cfreturn variables.expression />
    </cffunction>
	
	<!--- order --->
    <cffunction name="setOrder" access="public" output="false" returntype="void">
       <cfargument name="order" hint="I set the order statement for the query" required="yes" type="reactor.query.order" />
       <cfset variables.order = arguments.order />
    </cffunction>
    <cffunction name="getOrder" access="public" output="false" returntype="reactor.query.order">
       <cfreturn variables.order />
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
</cfcomponent>