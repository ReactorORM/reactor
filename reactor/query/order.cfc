<cfcomponent hint="I am am object which represents an order imposed on a query.">
	
	<cfset variables.order = XmlParse("<order></order>") />
	<cfset variables.Metadata = 0 />
	
	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the criteria object" output="false" returntype="reactor.query.order">
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
		
		<cfif NOT ListFindNoCase(getObjectMetadata().getColumnList(), arguments.field)>
			<cfthrow message="Field Does Not Exist" detail="The field '#arguments.field#' does not exist in the object '#getObjectMetadata().getName()#'." type="reactor.validateField.Field Does Not Exist" />
		</cfif>
	</cffunction>
	
	<cffunction name="setAsc" access="public" hint="I add an assending order." output="false" returntype="reactor.query.order">
		<cfargument name="field" hint="I am the name of the field to sort." required="yes" type="string" />
		<cfset var order = getOrder() />
		<cfset var node = XMLElemNew(order, "asc") />
		
		<cfset validateField(arguments.field) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		
		<cfset ArrayAppend(order.order.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDesc" access="public" hint="I add an descending order." output="false" returntype="reactor.query.order">
		<cfargument name="field" hint="I am the name of the field to sort." required="yes" type="string" />
		<cfset var order = getOrder() />
		<cfset var node = XMLElemNew(order, "desc") />
		
		<cfset validateField(arguments.field) />
		
		<!--- add the expression's XML --->
		<cfset node.XmlAttributes["field"] = arguments.field />
		
		<cfset ArrayAppend(order.order.XmlChildren, node) />	
		
		<cfreturn this />
	</cffunction>

	<!--- order --->
    <cffunction name="setOrder" access="public" output="false" returntype="void">
       <cfargument name="order" hint="I am the order string" required="yes" type="xml" />
       <cfset variables.order = arguments.order />
    </cffunction>
    <cffunction name="getOrder" access="public" output="false" returntype="xml">
       <cfreturn variables.order />
    </cffunction>
	
</cfcomponent>