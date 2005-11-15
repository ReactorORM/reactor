<cfcomponent hint="I am an object used to create expressions for where statements">

	<cfset variables.mode = "and" />
	<cfset variables.expression = XmlParse("<expression></expression>") />
	<cfset variables.Metadata = 0 />
	
	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the criteria object" output="false" returntype="reactor.query.expression">
		<cfargument name="Metadata" hint="I am the Metadata for the object being querired" required="yes" type="reactor.base.abstractMetadata">
		
		<cfset setObjectMetadata(arguments.metadata) />
		
		<cfreturn this />
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
		
		<cfset getObjectMetadata().getColumn(arguments.field) />
		
		<!--- <cfif NOT ListFindNoCase(getObjectMetadata().getColumnList(), arguments.field)>
			<cfthrow message="Field Does Not Exist" detail="The field '#arguments.field#' does not exist in the object '#getObjectMetadata().getName()#'." type="reactor.validateField.Field Does Not Exist" />
		</cfif> --->
	</cffunction>
	
	<!--- createExpression --->
	<cffunction name="createExpression" access="public" hint="I create and return a new expression." output="false" returntype="reactor.query.expression">
		<cfreturn CreateObject("Component", "reactor.query.expression").init(getObjectMetadata()) />
	</cffunction>
	
	<!--- copyExpression --->
	<cffunction name="copyExpression" access="private" hint="I copy an expression into this expression" output="false" returntype="void">
		<cfargument name="CopyExpression" hint="I am the expression to copy in." required="yes" type="reactor.query.expression" />
		<cfset var expression = getExpression() />
		<cfset var x = 0 />
		<cfset var node = 0 />
		<cfset var attribute = 0 />
		<cfset copyExpressions = XmlSearch(arguments.CopyExpression.getExpression(), "/expression/*") />
		<cfset copyExpression = "" />
		
		<!--- open parens --->
		<cfset node = XMLElemNew(expression, "openParenthesis") />
		<cfset ArrayAppend(expression.expression.XmlChildren, node) />	
		
		<cfloop from="1" to="#ArrayLen(copyExpressions)#" index="x">
			<!--- create the node --->
			<cfset copyExpression = copyExpressions[x] />
			<cfset node = XMLElemNew(expression, copyExpression.XmlName) />
			<!--- copy over all attributes --->
			<cfloop collection="#copyExpression.XmlAttributes#" item="attribute">
				<cfset node.XmlAttributes[attribute] = copyExpression.XmlAttributes[attribute] />
			</cfloop>
			<!--- append the node --->
			<cfset ArrayAppend(expression.expression.XmlChildren, node) />	
		</cfloop>
		
		<!--- close parens --->
		<cfset node = XMLElemNew(expression, "closeParenthesis") />
		<cfset ArrayAppend(expression.expression.XmlChildren, node) />	
	</cffunction>
	
	<cffunction name="and" access="public" hint="I return an expression which is the conjunction of two expressions (expression1 AND expression2)." output="false" returntype="reactor.query.expression">
		<cfargument name="Expression1" hint="I am the first expression" required="yes" type="reactor.query.expression" />
		<cfargument name="Expression2" hint="I am the first expression" required="yes" type="reactor.query.expression" />
		<cfset var expression = getExpression() />
		<cfset var operatorNode = 0 />
		
		<!--- copy the expression into this expression --->
		<cfset copyExpression(arguments.Expression1) />
		
		<cfset operatorNode = XMLElemNew(expression, "and") />
		<cfset ArrayAppend(expression.expression.XmlChildren, operatorNode) />	
		
		<!--- copy the expression into this expression --->
		<cfset copyExpression(arguments.Expression2) />
				
		<cfreturn this />
	</cffunction>
	
	<cffunction name="or" access="public" hint="I return an expression which is the disjunction of two expressions (expression1 OR expression2)." output="false" returntype="reactor.query.expression">
		<cfargument name="Expression1" hint="I am the first expression" required="yes" type="reactor.query.expression" />
		<cfargument name="Expression2" hint="I am the first expression" required="yes" type="reactor.query.expression" />
		<cfset var expression = getExpression() />
		<cfset var operatorNode = 0 />
		
		<!--- copy the expression into this expression --->
		<cfset copyExpression(arguments.Expression1) />
		
		<cfset operatorNode = XMLElemNew(expression, "or") />
		<cfset ArrayAppend(expression.expression.XmlChildren, operatorNode) />	
		
		<!--- copy the expression into this expression --->
		<cfset copyExpression(arguments.Expression2) />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="negate" access="public" hint="I return the negation of an expression." output="false" returntype="reactor.query.expression">
		<cfargument name="Expression1" hint="I am the name of the field" required="yes" type="reactor.query.expression" />
		<cfset var expression = getExpression() />
		<cfset var operatorNode = 0 />
		
		<cfset operatorNode = XMLElemNew(expression, "not") />
		<cfset ArrayAppend(expression.expression.XmlChildren, operatorNode) />	
		
		<!--- copy the expression into this expression --->
		<cfset copyExpression(arguments.Expression1) />
		
		<cfreturn this />
	</cffunction>
				
	<cffunction name="isBetween" access="public" hint="I return an expression which checks if a field is between two other values." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value1" hint="I am the first value" required="yes" type="string" />
		<cfargument name="value2" hint="I am the second value" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isBetween") />
		
		<cfset validateField(arguments.field) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["value1"] = arguments.value1 />
		<cfset node.XmlAttributes["value2"] = arguments.value2 />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
			
	<cffunction name="isBetweenFields" access="public" hint="I return an expression which checks if a field is between two other fields." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="field1" hint="I am the first field to compare" required="yes" type="string" />
		<cfargument name="field2" hint="I am the second field to compare" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isBetweenFields") />
		
		<cfset validateField(arguments.field) />
		<cfset validateField(arguments.field1) />
		<cfset validateField(arguments.field2) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["field1"] = arguments.field1 />
		<cfset node.XmlAttributes["field2"] = arguments.field2 />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isEqual" access="public" hint="I return an expression which checks if a fields equals a value." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isEqual") />
				
		<cfset validateField(arguments.field) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["value"] = arguments.value />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
				
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isEqualField" access="public" hint="I return an expression which checks if two fields in the query are equal." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the first field" required="yes" type="string" />
		<cfargument name="field1" hint="I am the name of the second field" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isEqualField") />
		
		<cfset validateField(arguments.field) />
		<cfset validateField(arguments.field1) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["field1"] = arguments.field1 />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isNotEqual" access="public" hint="I return an expression which checks if a field does not equal a value." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isNotEqual") />
		
		<cfset validateField(arguments.field) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["value"] = arguments.value />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isNotEqualField" access="public" hint="I return an expression which checks if two fields in the query are not equal." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the first field" required="yes" type="string" />
		<cfargument name="field1" hint="I am the name of the second field" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isNotEqualField") />
		
		<cfset validateField(arguments.field) />
		<cfset validateField(arguments.field1) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["field1"] = arguments.field1 />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isGte" access="public" hint="I return an expression which checks if a field is greater than or equal to a value." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isGte") />
		
		<cfset validateField(arguments.field) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["value"] = arguments.value />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />	
	</cffunction>
	
	<cffunction name="isGteField" access="public" hint="I return an expression which checks if a field is greater than or equal to another field." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="field1" hint="I am the field to compare against" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isGteField") />
		
		<cfset validateField(arguments.field) />
		<cfset validateField(arguments.field1) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["field1"] = arguments.field1 />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isGt" access="public" hint="I return an expression which checks if a field is greater than a value." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isGt") />
		
		<cfset validateField(arguments.field) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["value"] = arguments.value />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isGtField" access="public" hint="I return an expression which checks if a field is greater than another field." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="field1" hint="I am the field to compare against" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isGtField") />
		
		<cfset validateField(arguments.field) />
		<cfset validateField(arguments.field1) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["field1"] = arguments.field1 />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isLike" access="public" hint="I return an expression which checks if a field is 'like' a value." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		<cfargument name="mode" hint="I am the mode of the like comparison.  Options are: Anywhere, Left, All, Right" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isLike") />

		<cfif NOT ListFindNoCase("Anywhere,Left,All,Right", arguments.mode)>
			<cfthrow message="Invalid Mode" detail="The 'mode' argument is invalid.  This must be one of: Anywhere, Left, All, Right" />
		</cfif>
		
		<cfset validateField(arguments.field) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["value"] = arguments.value />
		<cfset node.XmlAttributes["mode"] = arguments.mode />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isNotLike" access="public" hint="I return an expression which checks if a field is 'not like' a value." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		<cfargument name="mode" hint="I am the mode of the like comparison.  Options are: Anywhere, Left, All, Right" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isNotLike") />

		<cfif NOT ListFindNoCase("Anywhere,Left,All,Right", arguments.mode)>
			<cfthrow message="Invalid Mode" detail="The 'mode' argument is invalid.  This must be one of: Anywhere, Left, All, Right" />
		</cfif>
		
		<cfset validateField(arguments.field) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["value"] = arguments.value />
		<cfset node.XmlAttributes["mode"] = arguments.mode />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isIn" access="public" hint="I return an expression which checks if a field's value is in a list of values." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="values" hint="I am a comma delimited list of values to compare against" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isIn") />
		
		<cfset validateField(arguments.field) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["values"] = arguments.values />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isNotIn" access="public" hint="I return an expression which checks if a field's value is not in a list of values." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="values" hint="I am a comma delimited list of values to compare against" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isNotIn") />
		
		<cfset validateField(arguments.field) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["values"] = arguments.values />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isNotNull" access="public" hint="I return an expression which checks if a field's is not null." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isNotNull") />
		
		<cfset validateField(arguments.field) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isNull" access="public" hint="I return an expression which checks if a field's is null." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isNull") />
		
		<cfset validateField(arguments.field) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isLte" access="public" hint="I return an expression which checks if a field is greater than or equal to a value." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isLte") />
		
		<cfset validateField(arguments.field) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["value"] = arguments.value />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />	
	</cffunction>
	
	<cffunction name="isLteField" access="public" hint="I return an expression which checks if a field is greater than or equal to another field." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="field1" hint="I am the field to compare against" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isLteField") />
		
		<cfset validateField(arguments.field) />
		<cfset validateField(arguments.field1) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["field1"] = arguments.field1 />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isLt" access="public" hint="I return an expression which checks if a field is greater than a value." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isLt") />
		
		<cfset validateField(arguments.field) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["value"] = arguments.value />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isLtField" access="public" hint="I return an expression which checks if a field is greater than another field." output="false" returntype="reactor.query.expression">
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="field1" hint="I am the field to compare against" required="yes" type="string" />
		<cfset var expression = getExpression() />
		<cfset var node = XMLElemNew(expression, "isLtField") />
		
		<cfset validateField(arguments.field) />
		<cfset validateField(arguments.field1) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		<cfset node.XmlAttributes["field1"] = arguments.field1 />
		
		<cfset appendNode(expression.expression.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<!--- appendNode --->
	<cffunction name="appendNode" access="private" hint="I append a node to the expression" output="false" returntype="void">
		<cfargument name="XmlChildren" hint="I am the XML children to append this node to." required="yes" type="Array" />
		<cfargument name="node" hint="I am the xml node to append" required="yes" type="any" />
		<cfset var expression = getExpression() />
		<cfset var operatorNode = 0 />
		
		<cfif ArrayLen(arguments.XmlChildren) GTE 1>
			<cfset operatorNode = XMLElemNew(expression, getMode()) />
			<cfset ArrayAppend(arguments.XmlChildren, operatorNode) />	
		</cfif>
		
		<!--- append the node --->
		<cfset ArrayAppend(arguments.XmlChildren, arguments.node) />	
	</cffunction>
	
	<!--- mode --->
    <cffunction name="setMode" access="public" output="false" returntype="reactor.query.expression">
		<cfargument name="mode" hint="I am the type of 'junction' mode to use when adding expressions" required="yes" type="string" />

		<cfif NOT ListFindNoCase("Or,And", arguments.mode)>
			<cfthrow message="Invalid Mode" detail="The 'mode' argument is invalid.  This must be one of: Or, And" />
		</cfif>
			
		<cfset variables.mode = arguments.mode />
		
		<cfreturn this />
    </cffunction>
	
	<cffunction name="getMode" access="private" output="false" returntype="string">
		<cfreturn variables.mode />
	</cffunction>
	
	<!--- expression --->
    <cffunction name="setExpression" access="public" output="false" returntype="void">
       <cfargument name="expression" hint="I am the expression as a string." required="yes" type="xml" />
       <cfset variables.expression = arguments.expression />
    </cffunction>
    <cffunction name="getExpression" access="public" output="false" returntype="xml">
       <cfreturn variables.expression />
    </cffunction>
	
</cfcomponent>