
<cfcomponent hint="I am the base record representing the Category table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractRecord" >
	
	<cfset variables.signature = "8FBBCE7490382D9832B8EC45EAFBB33A" />
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="ReactorBlogData.Record.mysql.base.CategoryRecord">
		
			<cfargument name="CategoryId" hint="I am the default value for the  CategoryId field." required="no" type="string" default="0" />
		
			<cfargument name="Name" hint="I am the default value for the  Name field." required="no" type="string" default="" />
		
			<cfset setCategoryId(arguments.CategoryId) />
		
			<cfset setName(arguments.Name) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		
					
					<!--- validate CategoryId is numeric --->
					<cfif Len(Trim(getCategoryId())) AND NOT IsNumeric(getCategoryId())>
						<cfset ValidationErrorCollection.addError("CategoryId", ErrorManager.getError("Category", "CategoryId", "invalidType")) />
					</cfif>					
				
						<!--- validate Name is provided --->
						<cfif NOT Len(Trim(getName()))>
							<cfset ValidationErrorCollection.addError("Name", ErrorManager.getError("Category", "Name", "notProvided")) />
						</cfif>
					
					
					<!--- validate Name is string --->
					<cfif NOT IsSimpleValue(getName())>
						<cfset ValidationErrorCollection.addError("Name", ErrorManager.getError("Category", "Name", "invalidType")) />
					</cfif>
					
					<!--- validate Name length --->
					<cfif Len(getName()) GT 50 >
						<cfset ValidationErrorCollection.addError("Name", ErrorManager.getError("Category", "Name", "invalidLength")) />
					</cfif>					
				
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	
		<!--- CategoryId --->
		<cffunction name="setCategoryId" access="public" output="false" returntype="void">
			<cfargument name="CategoryId" hint="I am this record's CategoryId value." required="yes" type="string" />
			<cfset _getTo().CategoryId = arguments.CategoryId />
		</cffunction>
		<cffunction name="getCategoryId" access="public" output="false" returntype="string">
			<cfreturn _getTo().CategoryId />
		</cffunction>	
	
		<!--- Name --->
		<cffunction name="setName" access="public" output="false" returntype="void">
			<cfargument name="Name" hint="I am this record's Name value." required="yes" type="string" />
			<cfset _getTo().Name = arguments.Name />
		</cffunction>
		<cffunction name="getName" access="public" output="false" returntype="string">
			<cfreturn _getTo().Name />
		</cffunction>	
	
	
	<cffunction name="load" access="public" hint="I load the Category record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().read(_getTo()) />
	</cffunction>	
	
	<cffunction name="save" access="public" hint="I save the Category record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void">
		<cfset _getDao().save(_getTo()) />
	</cffunction>	
	
	<cffunction name="delete" access="public" hint="I delete the Category record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().delete(_getTo()) />
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo("Category")) />
	</cffunction>
	
	
		<!--- Query For Entry --->
		<cffunction name="createEntryQuery" access="public" output="false" returntype="reactor.query.query">
			<cfset var Query = _getReactorFactory().createGateway("Entry").createQuery() />
			
			
				<!--- if this is a linked table add a join back to the linking table --->
				<cfset Query.join("Entry", "EntryCategory") />
			
			
			<cfreturn Query />
		</cffunction>
		
		
				<!--- Query For Entry --->
				<cffunction name="getEntryQuery" access="public" output="false" returntype="query">
					<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createEntryQuery()#" type="reactor.query.query" />
					<cfset var EntryGateway = _getReactorFactory().createGateway("Entry") />
					<cfset var relationship = _getReactorFactory().createMetadata("EntryCategory").getRelationship("Category").relate />
					
					<cfloop from="1" to="#ArrayLen(relationship)#" index="x">
						<cfset arguments.Query.getWhere().isEqual("EntryCategory", relationship[x].from, evaluate("get#relationship[x].to#()")) />
					</cfloop>
					
					<cfset arguments.Query.returnObjectFields("Entry") />

					<cfreturn EntryGateway.getByQuery(arguments.Query)>
				</cffunction>
				
				<!--- Query For Entry --->
				<!--- cffunction name="getEntryQuery" access="public" output="false" returntype="query">
					<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createEntryQuery()#" type="reactor.query.query" />
					<cfset var relationships = _getReactorFactory().createMetadata("EntryCategory").getRelationship("Entry").relate />
					<cfset var x = 0 />
					<cfset var relationship = 0 />
					<cfset var LinkedGateway = _getReactorFactory().createGateway("Entry") />
					<cfset var LinkedQuery = LinkedGateway.createQuery() />
					<cfset var EntryCategoryQuery = getEntryCategoryQuery() />

					<cfif EntryCategoryQuery.recordCount>
						<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
							<cfset relationship = relationships[x] />
							
							<cfset LinkedQuery.getWhere().isIn("Entry", relationship.to, evaluate("ValueList(EntryCategoryQuery.#relationship.from#)")) />
							
						</cfloop>
					<cfelse>
						<cfset LinkedQuery.setMaxRows(0) />
							
					</cfif>
					
					<cfreturn LinkedGateway.getByQuery(LinkedQuery) />
				</cffunction--->
			
		
		<!--- Array For Entry --->
		<cffunction name="getEntryArray" access="public" output="false" returntype="array">
			<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createEntryQuery()#" type="reactor.query.query" />
			<cfset var EntryQuery = getEntryQuery(arguments.Query) />
			<cfset var EntryArray = ArrayNew(1) />
			<cfset var EntryRecord = 0 />
			<cfset var EntryTo = 0 />
			<cfset var field = "" />
			
			<cfloop query="EntryQuery">
				<cfset EntryRecord = _getReactorFactory().createRecord("Entry") >
				<cfset EntryTo = EntryRecord._getTo() />
	
				<!--- populate the record's to --->
				<cfloop list="#EntryQuery.columnList#" index="field">
					<cfset EntryTo[field] = EntryQuery[field][EntryQuery.currentrow] >
				</cfloop>
				
				<cfset EntryRecord._setTo(EntryTo) />
				
				<cfset EntryArray[ArrayLen(EntryArray) + 1] = EntryRecord >
			</cfloop>
	
			<cfreturn EntryArray />
		</cffunction>		
	
		<!--- Query For EntryCategory --->
		<cffunction name="createEntryCategoryQuery" access="public" output="false" returntype="reactor.query.query">
			<cfset var Query = _getReactorFactory().createGateway("EntryCategory").createQuery() />
			
			
			
			<cfreturn Query />
		</cffunction>
		
		
				<!--- Query For EntryCategory --->
				<cffunction name="getEntryCategoryQuery" access="public" output="false" returntype="query">
					<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createEntryCategoryQuery()#" type="reactor.query.query" />
					<cfset var EntryCategoryGateway = _getReactorFactory().createGateway("EntryCategory") />
					
						<cfset arguments.Query.getWhere().isEqual("EntryCategory", "categoryId", getcategoryId()) />
					
					<cfreturn EntryCategoryGateway.getByQuery(arguments.Query)>
				</cffunction>
			
		
		<!--- Array For EntryCategory --->
		<cffunction name="getEntryCategoryArray" access="public" output="false" returntype="array">
			<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createEntryCategoryQuery()#" type="reactor.query.query" />
			<cfset var EntryCategoryQuery = getEntryCategoryQuery(arguments.Query) />
			<cfset var EntryCategoryArray = ArrayNew(1) />
			<cfset var EntryCategoryRecord = 0 />
			<cfset var EntryCategoryTo = 0 />
			<cfset var field = "" />
			
			<cfloop query="EntryCategoryQuery">
				<cfset EntryCategoryRecord = _getReactorFactory().createRecord("EntryCategory") >
				<cfset EntryCategoryTo = EntryCategoryRecord._getTo() />
	
				<!--- populate the record's to --->
				<cfloop list="#EntryCategoryQuery.columnList#" index="field">
					<cfset EntryCategoryTo[field] = EntryCategoryQuery[field][EntryCategoryQuery.currentrow] >
				</cfloop>
				
				<cfset EntryCategoryRecord._setTo(EntryCategoryTo) />
				
				<cfset EntryCategoryArray[ArrayLen(EntryCategoryArray) + 1] = EntryCategoryRecord >
			</cfloop>
	
			<cfreturn EntryCategoryArray />
		</cffunction>		
	
			
	<!--- to --->
	<cffunction name="_setTo" access="public" output="false" returntype="void">
	    <cfargument name="to" hint="I am this record's transfer object." required="yes" type="ReactorBlogData.To.mysql.CategoryTo" />
	    <cfset variables.to = arguments.to />
	</cffunction>
	<cffunction name="_getTo" access="public" output="false" returntype="ReactorBlogData.To.mysql.CategoryTo">
		<cfreturn variables.to />
	</cffunction>	
	
	<!--- dao --->
	<cffunction name="_setDao" access="private" output="false" returntype="void">
	    <cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="ReactorBlogData.Dao.mysql.CategoryDao" />
	    <cfset variables.dao = arguments.dao />
	</cffunction>
	<cffunction name="_getDao" access="private" output="false" returntype="ReactorBlogData.Dao.mysql.CategoryDao">
	    <cfreturn variables.dao />
	</cffunction>
	
</cfcomponent>
	
