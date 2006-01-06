
<cfcomponent hint="I am the base record representing the Invoice table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractRecord" >
	
	<cfset variables.signature = "4BB04E77F8C785BFEC9964C618CFF1F3" />
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="ScratchData.Record.mssql.base.InvoiceRecord">
		
			<cfargument name="InvoiceId" hint="I am the default value for the  InvoiceId field." required="no" type="string" default="0" />
		
			<cfargument name="CustomerId" hint="I am the default value for the  CustomerId field." required="no" type="string" default="0" />
		
			<cfset setInvoiceId(arguments.InvoiceId) />
		
			<cfset setCustomerId(arguments.CustomerId) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		
					
					<!--- validate InvoiceId is numeric --->
					<cfif Len(Trim(getInvoiceId())) AND NOT IsNumeric(getInvoiceId())>
						<cfset ValidationErrorCollection.addError("InvoiceId", ErrorManager.getError("Invoice", "InvoiceId", "invalidType")) />
					</cfif>					
				
					
					<!--- validate CustomerId is numeric --->
					<cfif Len(Trim(getCustomerId())) AND NOT IsNumeric(getCustomerId())>
						<cfset ValidationErrorCollection.addError("CustomerId", ErrorManager.getError("Invoice", "CustomerId", "invalidType")) />
					</cfif>					
				
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	
		<!--- InvoiceId --->
		<cffunction name="setInvoiceId" access="public" output="false" returntype="void">
			<cfargument name="InvoiceId" hint="I am this record's InvoiceId value." required="yes" type="string" />
			<cfset _getTo().InvoiceId = arguments.InvoiceId />
		</cffunction>
		<cffunction name="getInvoiceId" access="public" output="false" returntype="string">
			<cfreturn _getTo().InvoiceId />
		</cffunction>	
	
		<!--- CustomerId --->
		<cffunction name="setCustomerId" access="public" output="false" returntype="void">
			<cfargument name="CustomerId" hint="I am this record's CustomerId value." required="yes" type="string" />
			<cfset _getTo().CustomerId = arguments.CustomerId />
		</cffunction>
		<cffunction name="getCustomerId" access="public" output="false" returntype="string">
			<cfreturn _getTo().CustomerId />
		</cffunction>	
	
	
	<cffunction name="load" access="public" hint="I load the Invoice record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().read(_getTo()) />
	</cffunction>	
	
	<cffunction name="save" access="public" hint="I save the Invoice record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void">
		<cfset _getDao().save(_getTo()) />
	</cffunction>	
	
	<cffunction name="delete" access="public" hint="I delete the Invoice record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().delete(_getTo()) />
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo("Invoice")) />
	</cffunction>
	
	
		<!--- Query For Product --->
		<cffunction name="createProductQuery" access="public" output="false" returntype="reactor.query.query">
			<cfset var Query = _getReactorFactory().createGateway("Product").createQuery() />
			
			
				<!--- if this is a linked table add a join back to the linking table --->
				<cfset Query.join("Product", "InvoiceProduct") />
			
			
			<cfreturn Query />
		</cffunction>
		
		
				<!--- Query For Product --->
				<cffunction name="getProductQuery" access="public" output="false" returntype="query">
					<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createProductQuery()#" type="reactor.query.query" />
					<cfset var ProductGateway = _getReactorFactory().createGateway("Product") />
					<cfset var relationship = _getReactorFactory().createMetadata("InvoiceProduct").getRelationship("Invoice").relate />
					
					<cfloop from="1" to="#ArrayLen(relationship)#" index="x">
						<cfset arguments.Query.getWhere().isEqual("InvoiceProduct", relationship[x].from, evaluate("get#relationship[x].to#()")) />
					</cfloop>
					
					<cfset arguments.Query.returnObjectFields("Product") />

					<cfreturn ProductGateway.getByQuery(arguments.Query)>
				</cffunction>
				
				<!--- Query For Product --->
				<!--- cffunction name="getProductQuery" access="public" output="false" returntype="query">
					<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createProductQuery()#" type="reactor.query.query" />
					<cfset var relationships = _getReactorFactory().createMetadata("InvoiceProduct").getRelationship("Product").relate />
					<cfset var x = 0 />
					<cfset var relationship = 0 />
					<cfset var LinkedGateway = _getReactorFactory().createGateway("Product") />
					<cfset var LinkedQuery = LinkedGateway.createQuery() />
					<cfset var InvoiceProductQuery = getInvoiceProductQuery() />

					<cfif InvoiceProductQuery.recordCount>
						<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
							<cfset relationship = relationships[x] />
							
							<cfset LinkedQuery.getWhere().isIn("Product", relationship.to, evaluate("ValueList(InvoiceProductQuery.#relationship.from#)")) />
							
						</cfloop>
					<cfelse>
						<cfset LinkedQuery.setMaxRows(0) />
							
					</cfif>
					
					<cfreturn LinkedGateway.getByQuery(LinkedQuery) />
				</cffunction--->
			
		
		<!--- Array For Product --->
		<cffunction name="getProductArray" access="public" output="false" returntype="array">
			<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createProductQuery()#" type="reactor.query.query" />
			<cfset var ProductQuery = getProductQuery(arguments.Query) />
			<cfset var ProductArray = ArrayNew(1) />
			<cfset var ProductRecord = 0 />
			<cfset var ProductTo = 0 />
			<cfset var field = "" />
			
			<cfloop query="ProductQuery">
				<cfset ProductRecord = _getReactorFactory().createRecord("Product") >
				<cfset ProductTo = ProductRecord._getTo() />
	
				<!--- populate the record's to --->
				<cfloop list="#ProductQuery.columnList#" index="field">
					<cfset ProductTo[field] = ProductQuery[field][ProductQuery.currentrow] >
				</cfloop>
				
				<cfset ProductRecord._setTo(ProductTo) />
				
				<cfset ProductArray[ArrayLen(ProductArray) + 1] = ProductRecord >
			</cfloop>
	
			<cfreturn ProductArray />
		</cffunction>		
	
		<!--- Query For InvoiceProduct --->
		<cffunction name="createInvoiceProductQuery" access="public" output="false" returntype="reactor.query.query">
			<cfset var Query = _getReactorFactory().createGateway("InvoiceProduct").createQuery() />
			
			
			
			<cfreturn Query />
		</cffunction>
		
		
				<!--- Query For InvoiceProduct --->
				<cffunction name="getInvoiceProductQuery" access="public" output="false" returntype="query">
					<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createInvoiceProductQuery()#" type="reactor.query.query" />
					<cfset var InvoiceProductGateway = _getReactorFactory().createGateway("InvoiceProduct") />
					
						<cfset arguments.Query.getWhere().isEqual("InvoiceProduct", "invoiceId", getinvoiceId()) />
					
					<cfreturn InvoiceProductGateway.getByQuery(arguments.Query)>
				</cffunction>
			
		
		<!--- Array For InvoiceProduct --->
		<cffunction name="getInvoiceProductArray" access="public" output="false" returntype="array">
			<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createInvoiceProductQuery()#" type="reactor.query.query" />
			<cfset var InvoiceProductQuery = getInvoiceProductQuery(arguments.Query) />
			<cfset var InvoiceProductArray = ArrayNew(1) />
			<cfset var InvoiceProductRecord = 0 />
			<cfset var InvoiceProductTo = 0 />
			<cfset var field = "" />
			
			<cfloop query="InvoiceProductQuery">
				<cfset InvoiceProductRecord = _getReactorFactory().createRecord("InvoiceProduct") >
				<cfset InvoiceProductTo = InvoiceProductRecord._getTo() />
	
				<!--- populate the record's to --->
				<cfloop list="#InvoiceProductQuery.columnList#" index="field">
					<cfset InvoiceProductTo[field] = InvoiceProductQuery[field][InvoiceProductQuery.currentrow] >
				</cfloop>
				
				<cfset InvoiceProductRecord._setTo(InvoiceProductTo) />
				
				<cfset InvoiceProductArray[ArrayLen(InvoiceProductArray) + 1] = InvoiceProductRecord >
			</cfloop>
	
			<cfreturn InvoiceProductArray />
		</cffunction>		
	
			
	<!--- to --->
	<cffunction name="_setTo" access="public" output="false" returntype="void">
	    <cfargument name="to" hint="I am this record's transfer object." required="yes" type="ScratchData.To.mssql.InvoiceTo" />
	    <cfset variables.to = arguments.to />
	</cffunction>
	<cffunction name="_getTo" access="public" output="false" returntype="ScratchData.To.mssql.InvoiceTo">
		<cfreturn variables.to />
	</cffunction>	
	
	<!--- dao --->
	<cffunction name="_setDao" access="private" output="false" returntype="void">
	    <cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="ScratchData.Dao.mssql.InvoiceDao" />
	    <cfset variables.dao = arguments.dao />
	</cffunction>
	<cffunction name="_getDao" access="private" output="false" returntype="ScratchData.Dao.mssql.InvoiceDao">
	    <cfreturn variables.dao />
	</cffunction>
	
</cfcomponent>
	
