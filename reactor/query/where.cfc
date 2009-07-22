<cfcomponent hint="I am an object used to create wheres for where statements">

	<cfset variables.query = 0 />
	<cfset variables.whereCommands = ArrayNew(1) />
	
	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the criteria object" output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="query" hint="I am the query object." required="yes" type="any" _type="reactor.query.query">
		
		<cfset variables.query = arguments.query />
		
		<cfreturn this />
	</cffunction>
		
	<cffunction name="addWhereCommand" access="private" hint="I append a node to the where expression" output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="params" hint="I am the arguments to pass" required="yes" type="struct" />
		<cfargument name="method" hint="I am the name of the method to call" required="yes" type="string" />
		
		<!---<cfset variables.query.addWhereCommand(arguments.params, arguments.method) />--->
		<cfset ArrayAppend(variables.whereCommands, arguments) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getWhereCommands" access="public" hint="I return the array of where commands" output="false" returntype="any" _returntype="array">
		<cfreturn variables.whereCommands />
	</cffunction>
	
	<cffunction name="isBetween" access="public" hint="I return an where which checks if a field is between two other values." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the name of the field" required="yes" type="any" _type="string" />
		<cfargument name="value1" hint="I am the first value" required="yes" type="any" _type="string" />
		<cfargument name="value2" hint="I am the second value" required="yes" type="any" _type="string" />
		
		<cfset arguments.value1 = variables.query.addValue(arguments.value1) />
		<cfset arguments.value2 = variables.query.addValue(arguments.value2) />
		
		<cfreturn addWhereCommand(arguments, "isBetween") />
	</cffunction>
			
	<cffunction name="isBetweenFields" access="public" hint="I return an where which checks if a field is between two other fields." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		<cfargument name="compareToObjectAlias1" hint="I am the alias of the object the first comparison field is in" required="yes" type="any" _type="string" />
		<cfargument name="compareToFieldAlias1" hint="I am the first comparison field to compare" required="yes" type="any" _type="string" />
		<cfargument name="compareToObjectAlias2" hint="I am the alias of the object the second comparison field is in" required="yes" type="any" _type="string" />
		<cfargument name="compareToFieldAlias2" hint="I am the second comparison field to compare" required="yes" type="any" _type="string" />
				
		<cfreturn addWhereCommand(arguments, "isBetweenFields") />
	</cffunction>
	
	<cffunction name="isEqual" access="public" hint="I return an where which checks if a fields equals a value." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the alias of the field" required="yes" type="any" _type="string" />
		<cfargument name="value" hint="I am the value to compare" required="yes" type="any" _type="string" />
				
		<cfset arguments.value = variables.query.addValue(arguments.value) />
		
		<cfreturn addWhereCommand(arguments, "isEqual") />
	</cffunction>
	
	<cffunction name="isEqualField" access="public" hint="I return an where which checks if two fields in the query are equal." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		<cfargument name="compareToObjectAlias1" hint="I am the alias of the object the first comparison field is in" required="yes" type="any" _type="string" />
		<cfargument name="compareToFieldAlias1" hint="I am the first comparison field to compare" required="yes" type="any" _type="string" />
		
		<cfreturn addWhereCommand(arguments, "isEqualField") />
	</cffunction>
	
	<cffunction name="isNotEqual" access="public" hint="I return an where which checks if a field does not equal a value." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the name of the field" required="yes" type="any" _type="string" />
		<cfargument name="value" hint="I am the value to compare" required="yes" type="any" _type="string" />
		
		<cfset arguments.value = variables.query.addValue(arguments.value) />
		
		<cfreturn addWhereCommand(arguments, "isNotEqual") />
	</cffunction>
	
	<cffunction name="isNotEqualField" access="public" hint="I return an where which checks if two fields in the query are not equal." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		<cfargument name="compareToObjectAlias1" hint="I am the alias of the object the first comparison field is in" required="yes" type="any" _type="string" />
		<cfargument name="compareToFieldAlias1" hint="I am the first comparison field to compare" required="yes" type="any" _type="string" />
		
		<cfreturn addWhereCommand(arguments, "isNotEqualField") />
	</cffunction>
	
	<cffunction name="isGte" access="public" hint="I return an where which checks if a field is greater than or equal to a value." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="any" _type="string" />
		
		<cfset arguments.value = variables.query.addValue(arguments.value) />
		
		<cfreturn addWhereCommand(arguments, "isGte") />
	</cffunction>
	
	<cffunction name="isGteField" access="public" hint="I return an where which checks if a field is greater than or equal to another field." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		<cfargument name="compareToObjectAlias1" hint="I am the alias of the object the first comparison field is in" required="yes" type="any" _type="string" />
		<cfargument name="compareToFieldAlias1" hint="I am the first comparison field to compare" required="yes" type="any" _type="string" />
		
		<cfreturn addWhereCommand(arguments, "isGteField") />
	</cffunction>
	
	<cffunction name="isGt" access="public" hint="I return an where which checks if a field is greater than a value." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="any" _type="string" />
		
		<cfset arguments.value = variables.query.addValue(arguments.value) />
		
		<cfreturn addWhereCommand(arguments, "isGt") />
	</cffunction>
	
	<cffunction name="isGtField" access="public" hint="I return an where which checks if a field is greater than another field." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		<cfargument name="compareToObjectAlias1" hint="I am the alias of the object the first comparison field is in" required="yes" type="any" _type="string" />
		<cfargument name="compareToFieldAlias1" hint="I am the first comparison field to compare" required="yes" type="any" _type="string" />
		
		<cfreturn addWhereCommand(arguments, "isGtField") />
	</cffunction>
	
	<cffunction name="isLike" access="public" hint="I return an where which checks if a field is 'like' a value." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="any" _type="string" />
		<cfargument name="mode" hint="I am the mode of the like comparison.  Options are: Anywhere, Left, All, Right" required="no" type="any" _type="string" default="anywhere" />
		
		<cfset arguments.value = variables.query.addValue(arguments.value) />
		
		<cfreturn addWhereCommand(arguments, "isLike") />
	</cffunction>

	<cffunction name="isLikeNoCase" access="public" hint="I return an where which checks if a field is 'like' a value, ignores case" output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="any" _type="string" />
		<cfargument name="mode" hint="I am the mode of the like comparison.  Options are: Anywhere, Left, All, Right" required="no" type="any" _type="string" default="anywhere" />
		
		<cfset arguments.value = variables.query.addValue(arguments.value) />
		
		<cfreturn addWhereCommand(arguments, "isLikeNoCase") />
	</cffunction>
	
	<cffunction name="isNotLike" access="public" hint="I return an where which checks if a field is 'not like' a value." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="any" _type="string" />
		<cfargument name="mode" hint="I am the mode of the like comparison.  Options are: Anywhere, Left, All, Right" required="no" type="any" _type="string" default="anywhere" />
		
		<cfset arguments.value = variables.query.addValue(arguments.value) />
		
		<cfreturn addWhereCommand(arguments, "isNotLike") />
	</cffunction>
	
	<cffunction name="isIn" access="public" hint="I return an where which checks if a field's value is in a list of values." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		<cfargument name="values" hint="I am a comma delimited list of values to compare against" required="yes" type="any" _type="string" />
		
		<cfset arguments.values = variables.query.addValue(arguments.values) />
		
		<cfreturn addWhereCommand(arguments, "isIn") />
	</cffunction>
	
	<cffunction name="isNotIn" access="public" hint="I return an where which checks if a field's value is not in a list of values." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		<cfargument name="values" hint="I am a comma delimited list of values to compare against" required="yes" type="any" _type="string" />
		
		<cfset arguments.values = variables.query.addValue(arguments.values) />
		
		<cfreturn addWhereCommand(arguments, "isNotIn") />
	</cffunction>
	
	<cffunction name="isNotNull" access="public" hint="I return an where which checks if a field's is not null." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		
		<cfreturn addWhereCommand(arguments, "isNotNull") />
	</cffunction>
	
	<cffunction name="isNull" access="public" hint="I return an where which checks if a field's is null." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the name of the field" required="yes" type="any" _type="string" />
		
		<cfreturn addWhereCommand(arguments, "isNull") />
	</cffunction>
	
	<cffunction name="isLte" access="public" hint="I return an where which checks if a field is greater than or equal to a value." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the name of the field" required="yes" type="any" _type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="any" _type="string" />
		
		<cfset arguments.value = variables.query.addValue(arguments.value) />
		
		<cfreturn addWhereCommand(arguments, "isLte") />
	</cffunction>
	
	<cffunction name="isLteField" access="public" hint="I return an where which checks if a field is greater than or equal to another field." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		<cfargument name="compareToObjectAlias1" hint="I am the alias of the object the first comparison field is in" required="yes" type="any" _type="string" />
		<cfargument name="compareToFieldAlias1" hint="I am the first comparison field to compare" required="yes" type="any" _type="string" />
		
		<cfreturn addWhereCommand(arguments, "isLteField") />
	</cffunction>
	
	<cffunction name="isLt" access="public" hint="I return an where which checks if a field is greater than a value." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="any" _type="string" />
		
		<cfset arguments.value = variables.query.addValue(arguments.value) />
		
		<cfreturn addWhereCommand(arguments, "isLt") />
	</cffunction>
	
	<cffunction name="isLtField" access="public" hint="I return an where which checks if a field is greater than another field." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="objectAlias" hint="I am the alias of the object the field is in" required="yes" type="any" _type="string" />
		<cfargument name="fieldAlias" hint="I am the field to compare" required="yes" type="any" _type="string" />
		<cfargument name="compareToObjectAlias1" hint="I am the alias of the object the first comparison field is in" required="yes" type="any" _type="string" />
		<cfargument name="compareToFieldAlias1" hint="I am the first comparison field to compare" required="yes" type="any" _type="string" />
		
		<cfreturn addWhereCommand(arguments, "isLtField") />
	</cffunction>
	
	<!--- mode --->
    <cffunction name="setMode" access="public" output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="mode" hint="I am the type of 'junction' mode to use when adding wheres" required="yes" type="any" _type="string" />

		<cfreturn addWhereCommand(arguments, "setMode") />
    </cffunction>
		
	<!--- createWhere --->
	<cffunction name="createWhere" access="public" hint="I return a new where to be used with complex queries." returntype="any" _returntype="reactor.query.where">
		<cfset var whereCommands = ArrayNew(1) />
		<cfset var whereData = StructNew() />
		<cfset var Where = 0 />
		
		<cfset whereData.whereCommands = whereCommands />
		<cfset Where = CreateObject("Component", "reactor.query.where").init(variables.query, whereData) />
		
		<cfreturn Where />
	</cffunction>
	
	<cffunction name="addWhere" access="public" hint="I return an where which is the conjunction of the current where and the provided where. where AND/OR (where)." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="Where" hint="I am the where to add " required="yes" type="any" _type="reactor.query.where" />
		
		<cfreturn addWhereCommand(arguments, "addWhere") />
	</cffunction>
	
	<cffunction name="negateWhere" access="public" hint="I return the negation of an where." output="false" returntype="any" _returntype="reactor.query.where">
		<cfargument name="Where" hint="I am the where to negate" required="yes" type="any" _type="reactor.query.where" />
		
		<cfreturn addWhereCommand(arguments, "negateWhere") />
	</cffunction>
	
	<cffunction name="appendWhere" access="private" hint="I append another where into this where." output="false" returntype="any" _returntype="array">
		<cfargument name="expression" hint="I am the array of where expressions to append to" required="yes" type="any" _type="array" />
		<cfargument name="Where" hint="I am the where to append" required="yes" type="any" _type="reactor.query.where" />
		<cfset var x = 0 />
		<cfset var appendExpression = 0 />

		<cfset appendExpression = arguments.Where.getWhere() />
		
		<cfset ArrayAppend(arguments.expression, "(") />	
		
		<cfloop from="1" to="#ArrayLen(appendExpression)#" index="x">
			<cfset ArrayAppend(arguments.expression, appendExpression[x]) />	
		</cfloop>
		
		<cfset ArrayAppend(arguments.expression, ")") />	
				
		<cfreturn arguments.expression />
	</cffunction>
	
</cfcomponent>

	<!--- where
    <cffunction name="setWhere" access="public" output="false" returntype="void">
		<cfargument name="where" hint="I am the where's array of statements." required="yes" type="any" _type="array" />
		
		<cfset variables.where = arguments.where />
    </cffunction>
    <cffunction name="getWhere" access="public" output="false" returntype="any" _returntype="array">
		<cfset var field = 0 />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(variables.where)#" index="x">
			
			<cfif IsStruct(variables.where[x])>
				<cfset field = getQuery().findObject(variables.where[x].objectAlias).getField(variables.where[x].fieldAlias) />
				
				<cfif StructKeyExists(field, "expression")>
					<cfset variables.where[x].expression = field.expression />
				</cfif>
				
				<!--- if there's a compareToFieldAlias1 or compareToFieldAlias2 then get their expressions too --->
				<cfif StructKeyExists(variables.where[x], "compareToFieldAlias1")>
					<cfset field = getQuery().findObject(variables.where[x].compareToObjectAlias1).getField(variables.where[x].compareToFieldAlias1) />
					
					<cfif StructKeyExists(field, "expression")>
						<cfset variables.where[x].compareToExpression1 = field.expression />
					</cfif>
				</cfif>
				<cfif StructKeyExists(variables.where[x], "compareToFieldAlias2")>
					<cfset field = getQuery().findObject(variables.where[x].compareToObjectAlias2).getField(variables.where[x].compareToFieldAlias2) />
					
					<cfif StructKeyExists(field, "expression")>
						<cfset variables.where[x].compareToExpression2 = field.expression />
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn variables.where />
    </cffunction> --->