<cfcomponent hint="I represent an object being queried.  I am really a wrapper for a metadata object.">
	
	<cfset variables.ObjectMetadata = 0 />
	<cfset variables.ReactorFactory = 0 />
	<!---
		this variable represents joins beween this object and other
		objects.  This used to be an object in previous versions but
		was changed for simplicity and speed.
	--->
	<cfset variables.Joins = ArrayNew(1) />
	<cfset variables.alias = "" />
	<cfset variables.fields = 0 />
	<cfset variables.externalFields = 0 />
	<cfset variables.fieldPrefix = "" />
	
	<cffunction name="init" hint="I configure and return the object." output="false" returntype="any" _returntype="reactor.query.render.object">
		<cfargument name="ObjectMetadata" hint="I am the metadata of the object being queried." required="yes" type="any" _type="reactor.base.abstractMetadata" />
		<cfargument name="alias" hint="I am the alais of the object within the query." required="yes" type="any" _type="string" />
		<cfargument name="ReactorFactory" hint="I am a reference to the ReactorFactory." required="yes" type="any" _type="reactor.ReactorFactory" />
		
		<!--- set this object's metadata --->
		<cfset setObjectMetadata(arguments.ObjectMetadata) />
		<!--- get a reference to the ReactorFactory --->
		<cfset setReactorFactory(arguments.ReactorFactory) />
		<!--- this this object's alias.  it defaults to the object's configured alias --->
		<cfset setAlias(arguments.alias) />
		
		<!--- get the fields --->
		<cfset setFields(arguments.ObjectMetadata.getFields()) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- setFieldAlias --->
	<cffunction name="setFieldAlias" access="public" hint="I set a new alias for a field in the query." output="false" returntype="void">
		<cfargument name="currentAlias" hint="I am current field alias." required="yes" type="any" _type="string" />
		<cfargument name="newAlias" hint="I am new field alias to use." required="yes" type="any" _type="string" />
		<cfset getField(arguments.currentAlias).alias = arguments.newAlias />
	</cffunction>
	
	<!--- hasJoins --->
	<cffunction name="hasJoins" access="public" hint="I indicate if this object is joined to any others." output="false" returntype="any" _returntype="boolean">
		<cfreturn ArrayLen(variables.Joins) GT 0 />
	</cffunction>
	
	<!--- getField --->
	<cffunction name="getField" access="public" hint="I return a field in this object." output="false" returntype="any" _returntype="struct">
		<cfargument name="fieldAlias" hint="I am the alias of the field to get." required="yes" type="any" _type="string" />
		<cfset var fields = getFields() />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfif fields[x].alias IS arguments.fieldAlias>
				<cfreturn fields[x] />
			</cfif>
		</cfloop>
		
		<cfthrow message="Field Does Not Exist" detail="The field '#arguments.fieldAlias#' does not exist in the object '#getObjectMetadata().getName()#'." type="reactor.query.render.object.FieldDoesNotExist" />

	</cffunction>
	
	<!--- setFieldExpression --->
	<cffunction name="setFieldExpression" access="public" hint="I am used to modify the value of a field when it's selected." output="false" returntype="void">
		<cfargument name="fieldAlias" hint="I am the alias of the field." required="yes" type="any" _type="string" />
		<cfargument name="expression" hint="I am the expression to add replace the field with." required="yes" type="any" _type="string" />
		<cfargument name="cfDataType" hint="I am the cfsql data type to use." required="no" type="any" _type="string" />
		<cfset var fields = getFields() />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfif fields[x].alias IS arguments.fieldAlias>
				<cfset fields[x]["expression"] = arguments.expression />
				<cfif StructKeyExists(arguments, "cfDataType")>
					<cfset fields[x].cfDataType = arguments.cfDataType />
					<cfbreak />
				</cfif>
			</cfif>
		</cfloop>
				
	</cffunction>
	
	<cffunction name="evaluateReturn" access="private" hint="I check to see if a field should be returned in a query" output="false" returntype="any" _returntype="boolean">
		<cfargument name="returnFields" hint="I am an array of fields and objects to return." required="yes" type="any" _type="array" />
		<cfargument name="fieldAlias" hint="I am the alias of the field" required="yes" type="any" _type="string" />
		<cfset var x = 0 />
		
		<cfif NOT ArrayLen(arguments.returnFields)>
			<cfreturn true />
		</cfif>
		
		<cfloop from="1" to="#ArrayLen(arguments.returnFields)#" index="x">
			<cfif IsSimpleValue(arguments.returnFields[x]) AND arguments.returnFields[x] IS getAlias()>
				<cfreturn true />
			
			<cfelseif IsStruct(arguments.returnFields[x]) AND arguments.returnFields[x].fieldAlias IS arguments.fieldAlias AND arguments.returnFields[x].objectAlias IS getAlias()>
				<cfreturn true />
			
			</cfif>
		</cfloop>
		
		<cfreturn false />
	</cffunction>
	
	<!--- getSelectAsString --->
	<cffunction name="getSelectAsString" access="public" hint="I return the fields to be seleted for the query." output="false" returntype="any" _returntype="string">
		<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfargument name="returnFields" hint="I am an array of fields and objects to return." required="yes" type="any" _type="array" />
		<cfset var select = "" />
		<cfset var fields = getFields() />
		<cfset var field = 0 />
		<cfset var x = 0 />
		<cfset var y = 0 />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfif evaluateReturn(returnFields, fields[x].alias)>
				<!--- add a comma --->
				<cfif y IS NOT 0>
					<cfset select = select & ", " />
				</cfif>
				
				<!--- add the field or expression --->
				<cfif StructKeyExists(fields[x], "expression") AND Len(fields[x].expression)>
					<cfset field = fields[x].expression />
				<cfelse>
					<cfset field = arguments.Convention.formatFieldName(fields[x].name, getAlias()) />
				</cfif>
				
				<!--- add an "as" --->
				<cfset field = field & " AS " />
				
				<!--- add the field alias --->
				<cfset field = field & arguments.Convention.formatFieldAlias(getFieldPrefix() & fields[x].alias) />
				
				<!--- add this to the select --->
				<cfset select = select & " " & field />
				
				<cfset y = y + 1 />
			</cfif>
		</cfloop>
		
		<!--- add any joined objects --->
		<cfloop from="1" to="#arrayLen(variables.Joins)#" index="x">
			<cfset field = trim(variables.Joins[x].getObject().getSelectAsString(arguments.convention, arguments.returnFields)) />
			<cfif Len(field)>
				<cfif Len(trim(select))>
					<cfset select = select & ", ">
				</cfif>
				<cfset select = select & field />
			</cfif>
		</cfloop>
		
		<cfreturn select />
	</cffunction>
	
	<!--- getJoinsAsString --->
	<cffunction name="getJoinsAsString" access="package" hint="I get this object's joins as a fragment of a from statement" output="false" returntype="any" _returntype="string">
		<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="any" _type="reactor.data.abstractConvention" />
		<cfset var from = "" />
		<cfset var x = 0 />
		
		<!--- get this object's joins too --->
		<cfloop from="1" to="#arrayLen(variables.Joins)#" index="x">
			<cfset from = from & variables.Joins[x].getJoinsAsString(arguments.convention, this) />
		</cfloop>
		
		<cfreturn from />		
	</cffunction>
	
	<!--- addJoin --->
	<cffunction name="addJoin" access="package" hint="I add a join to this object." output="false" returntype="void">
		<cfargument name="joinToObjectAlias" hint="I am the alias of the object being joined to." required="yes" type="any" _type="string" />
		<cfargument name="relationshipAlias" hint="I am the alias of the relationship to use when joining these two objects." required="yes" type="any" _type="string" />
		<cfargument name="alias" hint="I the alias of the object in the query." required="yes" type="any" _type="string" />
		<cfargument name="joinType" hint="I am the type of join. Options are: left, right, full and inner." required="yes" type="any" _type="string" />
		<cfset var ToObjectMetadata = 0 />
		<cfset var relationship = 0 />
		<cfset var x = 0 />
		<cfset var from = 0 />
		<cfset var ToObject = 0 />
		<cfset var Join = 0 />
		
		<!--- find the to object's metadata --->
		<cfset ToObjectMetadata = getReactorFactory().createMetadata(arguments.joinToObjectAlias) />
		
		<!--- find the relationship to/from this object --->
		<cfif getObjectMetadata().hasRelationship(arguments.relationshipAlias)>
			<cfset relationship = getObjectMetadata().getRelationship(arguments.relationshipAlias) />
					
		<cfelseif ToObjectMetadata.hasRelationship(arguments.relationshipAlias)>
			<cfset relationship = ToObjectMetadata.getRelationship(arguments.relationshipAlias) />
			
			<!--- we can't join directly to linked objects.  For this reason we need to ignored this relationship if it's a link.  We'll throw an error later. --->
			<cfif NOT StructKeyExists(relationship, "link")>
				<!--- this relationship needs to be inverted --->
				<cfloop from="1" to="#ArrayLen(relationship.relate)#" index="x">
					<cfset from = relationship.relate[x].from />
					<cfset relationship.relate[x].from = relationship.relate[x].to />
					<cfset relationship.relate[x].to = from />
				</cfloop>
			</cfif>
			
		<cfelse>
			<!--- the relationship doesn't exist --->
			<cfthrow message="Relationship Does Not Exist" detail="The relationship alias #arguments.relationshipAlias# does not exist on either #getObjectMetadata().getAlias()# or #ToObjectMetadata.getAlias()#." type="reactor.join.RelationshipDoesNotExist" />
		
		</cfif>
		
		<cfif StructKeyExists(relationship, "link")>
			<!--- we can't use linking relationships --->
			<cfthrow message="Can Not Join Direct To Link" detail="The relationship alias #arguments.relationshipAlias# is a linking relationship.  You can not join via a link.  Instead join using each of the steps in the link explicitly." type="reactor.join.CanNotJoinDirectToLink" />
		</cfif>
		
		<!--- create the query object add this join --->
		<cfset ToObject = CreateObject("Component", "object").init(ToObjectMetadata, arguments.alias ,getReactorFactory()) />
		<cfset Join = CreateObject("Component", "reactor.query.render.join").init(ToObject, relationship, joinType) />
		
		<cfset ArrayAppend(variables.Joins, Join) />
		
	</cffunction>
	
	<!--- findObject --->
	<cffunction name="findObject" access="public" hint="I look for an object which is this object or joined to by this object or other joined objects." output="false" returntype="any" _returntype="any">
		<cfargument name="objectAlias" hint="I am the alias of the object being searched for." required="yes" type="any" _type="string" />
		<cfset var x = 0 />
		<cfset var Object = 0 />
		
		<!--- is this object the one specified by the alias? --->
		<cfif getAlias() is arguments.objectAlias>
			<!--- return this object --->
			<cfreturn this />
			
		<cfelse>
			
			<!--- look for it in the joined objects --->
			<cfloop from="1" to="#ArrayLen(variables.Joins)#" index="x">
				<cfset Object = variables.Joins[x].getObject().findObject(arguments.objectAlias) />
				<cfif IsObject(Object) AND Object.getAlias() IS arguments.objectAlias>
					<cfreturn Object />
				</cfif>
			</cfloop>
			
			<cfreturn "" />
		</cfif>
		
	</cffunction>
	
	<!--- alias --->
    <cffunction name="setAlias" access="public" output="false" returntype="void">
       <cfargument name="alias" hint="I am this object's alias" required="yes" type="any" _type="string" />
       <cfset variables.alias = arguments.alias />
    </cffunction>
    <cffunction name="getAlias" access="public" output="false" returntype="any" _returntype="string">
       <cfreturn variables.alias />
    </cffunction>
	
	<!--- objectMetadata --->
    <cffunction name="setObjectMetadata" access="private" output="false" returntype="void">
       <cfargument name="objectMetadata" hint="I am the metadata of the object being queried" required="yes" type="any" _type="reactor.base.abstractMetadata" />
       <cfset variables.objectMetadata = arguments.objectMetadata />
    </cffunction>
    <cffunction name="getObjectMetadata" access="public" output="false" returntype="any" _returntype="reactor.base.abstractMetadata">
       <cfreturn variables.objectMetadata />
    </cffunction>
	
	<!--- reactorFactory --->
    <cffunction name="setReactorFactory" access="private" output="false" returntype="void">
       <cfargument name="reactorFactory" hint="I am a reference to the ReactorFactory" required="yes" type="any" _type="reactor.ReactorFactory" />
       <cfset variables.reactorFactory = arguments.reactorFactory />
    </cffunction>
    <cffunction name="getReactorFactory" access="private" output="false" returntype="any" _returntype="reactor.ReactorFactory">
       <cfreturn variables.reactorFactory />
    </cffunction>
	
	<!--- fields --->
    <cffunction name="setFields" access="private" output="false" returntype="void">
       <cfargument name="fields" hint="I am the fields in this object" required="yes" type="any" _type="array" />
       <cfset variables.fields = arguments.fields />
    </cffunction>
    <cffunction name="getFields" access="public" output="false" returntype="any" _returntype="array">
       <cfreturn variables.fields />
    </cffunction>
	
	<!--- fieldPrefix --->
    <cffunction name="setFieldPrefix" access="public" output="false" returntype="void">
       <cfargument name="fieldPrefix" hint="I set the prefix to prepend to all fields in this object." required="yes" type="any" _type="string" />
       <cfset variables.fieldPrefix = arguments.fieldPrefix />
    </cffunction>
    <cffunction name="getFieldPrefix" access="public" output="false" returntype="any" _returntype="string">
       <cfreturn variables.fieldPrefix />
    </cffunction>
	
</cfcomponent>
