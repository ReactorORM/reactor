<cfcomponent hint="I represent a join in a query.">

	<cffunction name="init" access="public" hint="I configure and return this join." output="false" returntype="reactor.query.join">
		<cfargument name="Object" hint="I am the object being joined to" required="yes" type="reactor.query.object" />
		<cfargument name="relationship" hint="I am the relationship to this object from the object that this joined is on." required="yes" type="struct" />
		<cfargument name="joinType" hint="I am the type of join.  Option are left, right, innner, full." required="yes" type="string" />
		 
		<!--- validate joinType --->
		<cfif NOT ListFindNoCase("left,right,full,inner", arguments.joinType)>
			<!--- throw an error --->
			<cfthrow message="Invalid JoinType Argument" detail="The joinType #arguments.joinType# is invalid.  Valid options are: left, right, full and inner" type="reactor.join.InvalidJoinTypeArgument" />
		</cfif>
		 
		<cfset setObject(arguments.Object) />
		<cfset setRelationship(arguments.relationship) />
		<cfset setJoinType(arguments.joinType) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- getFromAsString --->
	<cffunction name="getJoinsAsString" access="package" hint="I get this join as a fragment of a from statement" output="false" returntype="string">
		<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="reactor.data.abstractConvention" />
		<cfargument name="FromObject" hint="I am the object joining to the joined object." required="yes" type="reactor.query.object" />
		<cfset var join = " " & UCase(getJoinType()) & " JOIN " & arguments.convention.formatObjectAlias(getObject().getObjectMetadata(), getObject().getAlias()) />
		<cfset var relationship = getRelationship() />
		<cfset var x = 0 />
		
		<!--- add the ON --->
		<cfloop from="1" to="#ArrayLen(relationship.relate)#" index="x">
      <cfif x is 1>
        <cfset join = join & " ON " />
      </cfif>
			<cfset join = join & arguments.Convention.formatFieldName(FromObject.getObjectMetadata().getField(relationship.relate[x].from).name, arguments.FromObject.getAlias()) />
			<cfset join = join & " = " & arguments.Convention.formatFieldName(Object.getObjectMetadata().getField(relationship.relate[x].to).name, getObject().getAlias()) />
			
			<!--- if we're related by more than one column then add an and and repeat! --->
			<cfif x IS NOT ArrayLen(relationship.relate)>
				<cfset join = join & " AND " />
			</cfif>
		</cfloop>
		
		<!--- add child joins --->
		<cfset join = join & getObject().getJoinsAsString(arguments.Convention) />
		
		<cfreturn join />		
	</cffunction>
	
	<!--- object --->
    <cffunction name="setObject" access="private" output="false" returntype="void">
       <cfargument name="object" hint="I am the object being joined to" required="yes" type="reactor.query.object" />
       <cfset variables.object = arguments.object />
    </cffunction>
    <cffunction name="getObject" access="public" output="false" returntype="reactor.query.object">
       <cfreturn variables.object />
    </cffunction>
	
	<!--- relationship --->
    <cffunction name="setRelationship" access="private" output="false" returntype="void">
       <cfargument name="relationship" hint="I am the relationship to this object from the object that this joined is on." required="yes" type="struct" />
       <cfset variables.relationship = arguments.relationship />
    </cffunction>
    <cffunction name="getRelationship" access="public" output="false" returntype="struct">
       <cfreturn variables.relationship />
    </cffunction>

	<!--- joinType --->
    <cffunction name="setJoinType" access="public" output="false" returntype="void">
       <cfargument name="joinType" hint="I am the type of join.  Option are left, right, innner, full." required="yes" type="string" />
       <cfset variables.joinType = arguments.joinType />
    </cffunction>
    <cffunction name="getJoinType" access="public" output="false" returntype="string">
       <cfreturn variables.joinType />
    </cffunction>
</cfcomponent>