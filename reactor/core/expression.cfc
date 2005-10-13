<cfcomponent hint="I am an object used to create expressions for where statements">

	<cfset variables.expression = "" />
	<cfset variables.mode = "AND" />
	
	<cffunction name="and" access="public" hint="I return an expression which is the conjunction of two expressions (expression1 AND expression2)." output="false" returntype="reactor.core.expression">
		<cfargument name="Expression1" hint="I am the first expression" required="yes" type="reactor.core.expression" />
		<cfargument name="Expression2" hint="I am the first expression" required="yes" type="reactor.core.expression" />
		
		<cfset appendExpression("(#arguments.Expression1.asString()#) AND (#arguments.Expression2.asString()#)") />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="or" access="public" hint="I return an expression which is the disjunction of two expressions (expression1 OR expression2)." output="false" returntype="reactor.core.expression">
		<cfargument name="Expression1" hint="I am the first expression" required="yes" type="reactor.core.expression" />
		<cfargument name="Expression2" hint="I am the first expression" required="yes" type="reactor.core.expression" />
		
		<cfset appendExpression("(#arguments.Expression1.asString()#) OR (#arguments.Expression2.asString()#)") />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="not" access="public" hint="I return the negation of an expression." output="false" returntype="reactor.core.expression">
		<cfargument name="Expression" hint="I am the name of the field" required="yes" type="reactor.core.expression" />
		
		<cfset appendExpression("NOT (#arguments.expression.asString()#)") />
		
		<cfreturn this />
	</cffunction>
				
	<cffunction name="isBetween" access="public" hint="I return an expression which checks if a field is between two other values." output="false" returntype="reactor.core.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value1" hint="I am the first value" required="yes" type="string" />
		<cfargument name="value2" hint="I am the second value" required="yes" type="string" />
		
		<cfif IsNumeric(arguments.value1) AND IsNumeric(arguments.value2)>
			<cfset appendExpression("#arguments.field# BETWEEN #arguments.value1# AND #arguments.value2#") />
		<cfelse>
			<cfset appendExpression("#arguments.field# BETWEEN '#arguments.value1#' AND '#arguments.value2#'") />
		</cfif>
		
		<cfreturn this />
	</cffunction>
			
	<cffunction name="isBetweenFields" access="public" hint="I return an expression which checks if a field is between two other fields." output="false" returntype="reactor.core.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="field1" hint="I am the first field to compare" required="yes" type="string" />
		<cfargument name="field2" hint="I am the second field to compare" required="yes" type="string" />
		
		<cfset appendExpression("#arguments.field# BETWEEN [#arguments.field1#] AND [#arguments.field2#]") />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isEqual" access="public" hint="I return an expression which checks if a fields equals a value." output="false" returntype="reactor.core.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare" required="yes" type="string" />
		
		<cfif IsNumeric(arguments.value)>
			<cfset appendExpression("#arguments.field# = #arguments.value#") />
		<cfelse>
			<cfset appendExpression("#arguments.field# = '#arguments.value#'") />		
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isEqualField" access="public" hint="I return an expression which checks if two fields in the query are equal." output="false" returntype="reactor.core.expression">
		<cfargument name="field1" hint="I am the name of the first field" required="yes" type="string" />
		<cfargument name="field2" hint="I am the name of the second field" required="yes" type="string" />
		
		<cfset appendExpression("[#arguments.field1#] = [#arguments.field2#]") />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isNotEqual" access="public" hint="I return an expression which checks if a field does not equal a value." output="false" returntype="reactor.core.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare" required="yes" type="string" />
		
		<cfif IsNumeric(arguments.value)>
			<cfset appendExpression("#arguments.field# != #arguments.value#") />
		<cfelse>
			<cfset appendExpression("#arguments.field# != '#arguments.value#'") />		
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isNotEqualField" access="public" hint="I return an expression which checks if two fields in the query are not equal." output="false" returntype="reactor.core.expression">
		<cfargument name="field1" hint="I am the name of the first field" required="yes" type="string" />
		<cfargument name="field2" hint="I am the name of the second field" required="yes" type="string" />
		
		<cfset appendExpression("[#arguments.field1#] != [#arguments.field2#]") />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isGte" access="public" hint="I return an expression which checks if a field is greater than or equal to a value." output="false" returntype="reactor.core.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		
		<cfif IsNumeric(arguments.value)>
			<cfset appendExpression("#arguments.field# >= #arguments.value#") />
		<cfelse>
			<cfset appendExpression("#arguments.field# >= '#arguments.value#'") />		
		</cfif>	
		
		<cfreturn this />	
	</cffunction>
	
	<cffunction name="isGteField" access="public" hint="I return an expression which checks if a field is greater than or equal to another field." output="false" returntype="reactor.core.expression">
		<cfargument name="field1" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="field2" hint="I am the field to compare against" required="yes" type="string" />
		
		<cfset appendExpression("[#arguments.field1#] >= [#arguments.field2#]") />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isGt" access="public" hint="I return an expression which checks if a field is greater than a value." output="false" returntype="reactor.core.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		
		<cfif IsNumeric(arguments.value)>
			<cfset appendExpression("#arguments.field# > #arguments.value#") />
		<cfelse>
			<cfset appendExpression("#arguments.field# > '#arguments.value#'") />		
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isGtField" access="public" hint="I return an expression which checks if a field is greater than another field." output="false" returntype="reactor.core.expression">
		<cfargument name="field1" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="field2" hint="I am the field to compare against" required="yes" type="string" />
		
		<cfset appendExpression("[#arguments.field1#] > [#arguments.field2#]") />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isLike" access="public" hint="I return an expression which checks if a field is 'like' a value." output="false" returntype="reactor.core.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		<cfargument name="mode" hint="I am the mode of the like comparison.  Options are: Anywhere, Left, All, Right" required="yes" type="string" />
		
		<cfif NOT ListFindNoCase("Anywhere,Left,All,Right", arguments.mode)>
			<cfthrow message="Invalid Mode" detail="The 'mode' argument is invalid.  This must be one of: Anywhere, Left, All, Right" />
		</cfif>
		
		<cfswitch expression="#arguments.mode#">
			<cfcase value="Anywhere">
				<cfset appendExpression("#arguments.field# LIKE '%#arguments.value#%'") />
			</cfcase>
			<cfcase value="Left">
				<cfset appendExpression("#arguments.field# LIKE '%#arguments.value#'") />
			</cfcase>
			<cfcase value="Right">
				<cfset appendExpression("#arguments.field# LIKE '#arguments.value#%'") />
			</cfcase>
			<cfcase value="All">
				<cfset appendExpression("#arguments.field# LIKE '#arguments.value#'") />
			</cfcase>
		</cfswitch>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isNotLike" access="public" hint="I return an expression which checks if a field is 'not like' a value." output="false" returntype="reactor.core.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		<cfargument name="mode" hint="I am the mode of the like comparison.  Options are: Anywhere, Left, All, Right" required="yes" type="string" />
		
		<cfif NOT ListFindNoCase("Anywhere,Left,All,Right", arguments.mode)>
			<cfthrow message="Invalid Mode" detail="The 'mode' argument is invalid.  This must be one of: Anywhere, Left, All, Right" />
		</cfif>
		
		<cfswitch expression="#arguments.mode#">
			<cfcase value="Anywhere">
				<cfset appendExpression("#arguments.field# NOT LIKE '%#arguments.value#%'") />
			</cfcase>
			<cfcase value="Left">
				<cfset appendExpression("#arguments.field# NOT LIKE '%#arguments.value#'") />
			</cfcase>
			<cfcase value="Right">
				<cfset appendExpression("#arguments.field# NOT LIKE '#arguments.value#%'") />
			</cfcase>
			<cfcase value="All">
				<cfset appendExpression("#arguments.field# NOT LIKE '#arguments.value#'") />
			</cfcase>
		</cfswitch>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isIn" access="public" hint="I return an expression which checks if a field's value is in a list of values." output="false" returntype="reactor.core.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="values" hint="I am a comma delimited list of values to compare against" required="yes" type="string" />
		
		<cfset appendExpression("[#arguments.field1#] IN (#arguments.values#)") />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isNotIn" access="public" hint="I return an expression which checks if a field's value is not in a list of values." output="false" returntype="reactor.core.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="values" hint="I am a comma delimited list of values to compare against" required="yes" type="string" />
		
		<cfset appendExpression("[#arguments.field1#] NOT IN (#arguments.values#)") />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isNotNull" access="public" hint="I return an expression which checks if a field's is not null." output="false" returntype="reactor.core.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		
		<cfset appendExpression("#arguments.field# IS NOT NULL") />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isNull" access="public" hint="I return an expression which checks if a field's is null." output="false" returntype="reactor.core.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		
		<cfset appendExpression("#arguments.field# IS NULL") />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isLte" access="public" hint="I return an expression which checks if a field is greater than or equal to a value." output="false" returntype="reactor.core.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		
		<cfif IsNumeric(arguments.value)>
			<cfset appendExpression("#arguments.field# <= #arguments.value#") />
		<cfelse>
			<cfset appendExpression("#arguments.field# <= '#arguments.value#'") />		
		</cfif>		
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isLteField" access="public" hint="I return an expression which checks if a field is greater than or equal to another field." output="false" returntype="reactor.core.expression">
		<cfargument name="field1" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="field2" hint="I am the field to compare against" required="yes" type="string" />
		
		<cfset appendExpression("[#arguments.field1#] <= [#arguments.field2#]") />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isLt" access="public" hint="I return an expression which checks if a field is greater than a value." output="false" returntype="reactor.core.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		
		<cfif IsNumeric(arguments.value)>
			<cfset appendExpression("#arguments.field# < #arguments.value#") />
		<cfelse>
			<cfset appendExpression("#arguments.field# < '#arguments.value#'") />		
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isLtField" access="public" hint="I return an expression which checks if a field is greater than another field." output="false" returntype="reactor.core.expression">
		<cfargument name="field1" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="field2" hint="I am the field to compare against" required="yes" type="string" />
		
		<cfset appendExpression("[#arguments.field1#] < [#arguments.field2#]") />
		
		<cfreturn this />
	</cffunction>
	
	<!--- mode --->
    <cffunction name="setMode" access="public" output="false" returntype="reactor.core.expression">
		<cfargument name="mode" hint="I am the type of 'junction' mode to use when adding expressions" required="yes" type="string" />
		
		<cfif NOT ListFindNoCase("Or,And", arguments.mode)>
			<cfthrow message="Invalid Mode" detail="The 'mode' argument is invalid.  This must be one of: Or, And" />
		</cfif>
		
		<cfset variables.mode = UCase(arguments.mode) />
		
		<cfreturn this />
    </cffunction>
    <cffunction name="getMode" access="private" output="false" returntype="string">
		<cfreturn variables.mode />
    </cffunction>
	
	<!--- expression --->
    <cffunction name="setExpression" access="private" output="false" returntype="void">
       <cfargument name="expression" hint="I am the expression as a string." required="yes" type="string" />
       <cfset variables.expression = arguments.expression />
    </cffunction>
    <cffunction name="getExpression" access="private" output="false" returntype="string">
       <cfreturn variables.expression />
    </cffunction>
	
	<cffunction name="appendExpression" access="private" output="false" returntype="void">
		<cfargument name="expressionToAppend" hint="I am the expression as append." required="yes" type="string" />
		<cfset var expression = getExpression() />
		
		<cfif Len(expression)>
			<cfset expression = expression & " " & getMode() & " " />
		</cfif>
		
		<!--- <cfset expression = expression  & "(" & arguments.expressionToAppend & ")" /> --->
		<cfset expression = expression  & arguments.expressionToAppend />
	   
		<cfset setExpression(expression) />
    </cffunction>
	
	<cffunction name="asString" access="public" output="false" returntype="string">
       <cfreturn variables.expression />
    </cffunction>
</cfcomponent>