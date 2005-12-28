
<cfcomponent hint="I am the base record representing the Entry table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractRecord" >
	
	<cfset variables.signature = "0E8A0DCC028F2DF598EC814ED991B3AA" />
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="ReactorBlogData.Record.mssql.base.EntryRecord">
		
			<cfargument name="EntryId" hint="I am the default value for the  EntryId field." required="no" type="string" default="0" />
		
			<cfargument name="Title" hint="I am the default value for the  Title field." required="no" type="string" default="" />
		
			<cfargument name="Preview" hint="I am the default value for the  Preview field." required="no" type="string" default="" />
		
			<cfargument name="Article" hint="I am the default value for the  Article field." required="no" type="string" default="" />
		
			<cfargument name="PublicationDate" hint="I am the default value for the  PublicationDate field." required="no" type="string" default="#Now()#" />
		
			<cfargument name="PostedByUserId" hint="I am the default value for the  PostedByUserId field." required="no" type="string" default="0" />
		
			<cfargument name="DisableComments" hint="I am the default value for the  DisableComments field." required="no" type="string" default="false" />
		
			<cfargument name="Views" hint="I am the default value for the  Views field." required="no" type="string" default="0" />
		
			<cfset setEntryId(arguments.EntryId) />
		
			<cfset setTitle(arguments.Title) />
		
			<cfset setPreview(arguments.Preview) />
		
			<cfset setArticle(arguments.Article) />
		
			<cfset setPublicationDate(arguments.PublicationDate) />
		
			<cfset setPostedByUserId(arguments.PostedByUserId) />
		
			<cfset setDisableComments(arguments.DisableComments) />
		
			<cfset setViews(arguments.Views) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		
					
					<!--- validate EntryId is numeric --->
					<cfif Len(Trim(getEntryId())) AND NOT IsNumeric(getEntryId())>
						<cfset ValidationErrorCollection.addError("EntryId", ErrorManager.getError("Entry", "EntryId", "invalidType")) />
					</cfif>					
				
						<!--- validate Title is provided --->
						<cfif NOT Len(Trim(getTitle()))>
							<cfset ValidationErrorCollection.addError("Title", ErrorManager.getError("Entry", "Title", "notProvided")) />
						</cfif>
					
					
					<!--- validate Title is string --->
					<cfif NOT IsSimpleValue(getTitle())>
						<cfset ValidationErrorCollection.addError("Title", ErrorManager.getError("Entry", "Title", "invalidType")) />
					</cfif>
					
					<!--- validate Title length --->
					<cfif Len(getTitle()) GT 200 >
						<cfset ValidationErrorCollection.addError("Title", ErrorManager.getError("Entry", "Title", "invalidLength")) />
					</cfif>					
				
					
					<!--- validate Preview is string --->
					<cfif NOT IsSimpleValue(getPreview())>
						<cfset ValidationErrorCollection.addError("Preview", ErrorManager.getError("Entry", "Preview", "invalidType")) />
					</cfif>
					
					<!--- validate Preview length --->
					<cfif Len(getPreview()) GT 1000 >
						<cfset ValidationErrorCollection.addError("Preview", ErrorManager.getError("Entry", "Preview", "invalidLength")) />
					</cfif>					
				
						<!--- validate Article is provided --->
						<cfif NOT Len(Trim(getArticle()))>
							<cfset ValidationErrorCollection.addError("Article", ErrorManager.getError("Entry", "Article", "notProvided")) />
						</cfif>
					
					
					<!--- validate Article is string --->
					<cfif NOT IsSimpleValue(getArticle())>
						<cfset ValidationErrorCollection.addError("Article", ErrorManager.getError("Entry", "Article", "invalidType")) />
					</cfif>
					
					<!--- validate Article length --->
					<cfif Len(getArticle()) GT 2147483647 >
						<cfset ValidationErrorCollection.addError("Article", ErrorManager.getError("Entry", "Article", "invalidLength")) />
					</cfif>					
				
						<!--- validate PublicationDate is provided --->
						<cfif NOT Len(Trim(getPublicationDate()))>
							<cfset ValidationErrorCollection.addError("PublicationDate", ErrorManager.getError("Entry", "PublicationDate", "notProvided")) />
						</cfif>
					
					
					<!--- validate PublicationDate is date --->
					<cfif NOT IsDate(getPublicationDate())>
						<cfset ValidationErrorCollection.addError("PublicationDate", ErrorManager.getError("Entry", "PublicationDate", "invalidType")) />
					</cfif>					
				
					
					<!--- validate PostedByUserId is numeric --->
					<cfif Len(Trim(getPostedByUserId())) AND NOT IsNumeric(getPostedByUserId())>
						<cfset ValidationErrorCollection.addError("PostedByUserId", ErrorManager.getError("Entry", "PostedByUserId", "invalidType")) />
					</cfif>					
				
						<!--- validate DisableComments is provided --->
						<cfif NOT Len(Trim(getDisableComments()))>
							<cfset ValidationErrorCollection.addError("DisableComments", ErrorManager.getError("Entry", "DisableComments", "notProvided")) />
						</cfif>
					
					
					<!--- validate DisableComments is boolean --->
					<cfif NOT IsBoolean(getDisableComments())>
						<cfset ValidationErrorCollection.addError("DisableComments", ErrorManager.getError("Entry", "DisableComments", "invalidType")) />
					</cfif>					
				
					
					<!--- validate Views is numeric --->
					<cfif Len(Trim(getViews())) AND NOT IsNumeric(getViews())>
						<cfset ValidationErrorCollection.addError("Views", ErrorManager.getError("Entry", "Views", "invalidType")) />
					</cfif>					
				
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	
		<!--- EntryId --->
		<cffunction name="setEntryId" access="public" output="false" returntype="void">
			<cfargument name="EntryId" hint="I am this record's EntryId value." required="yes" type="string" />
			<cfset _getTo().EntryId = arguments.EntryId />
		</cffunction>
		<cffunction name="getEntryId" access="public" output="false" returntype="string">
			<cfreturn _getTo().EntryId />
		</cffunction>	
	
		<!--- Title --->
		<cffunction name="setTitle" access="public" output="false" returntype="void">
			<cfargument name="Title" hint="I am this record's Title value." required="yes" type="string" />
			<cfset _getTo().Title = arguments.Title />
		</cffunction>
		<cffunction name="getTitle" access="public" output="false" returntype="string">
			<cfreturn _getTo().Title />
		</cffunction>	
	
		<!--- Preview --->
		<cffunction name="setPreview" access="public" output="false" returntype="void">
			<cfargument name="Preview" hint="I am this record's Preview value." required="yes" type="string" />
			<cfset _getTo().Preview = arguments.Preview />
		</cffunction>
		<cffunction name="getPreview" access="public" output="false" returntype="string">
			<cfreturn _getTo().Preview />
		</cffunction>	
	
		<!--- Article --->
		<cffunction name="setArticle" access="public" output="false" returntype="void">
			<cfargument name="Article" hint="I am this record's Article value." required="yes" type="string" />
			<cfset _getTo().Article = arguments.Article />
		</cffunction>
		<cffunction name="getArticle" access="public" output="false" returntype="string">
			<cfreturn _getTo().Article />
		</cffunction>	
	
		<!--- PublicationDate --->
		<cffunction name="setPublicationDate" access="public" output="false" returntype="void">
			<cfargument name="PublicationDate" hint="I am this record's PublicationDate value." required="yes" type="string" />
			<cfset _getTo().PublicationDate = arguments.PublicationDate />
		</cffunction>
		<cffunction name="getPublicationDate" access="public" output="false" returntype="string">
			<cfreturn _getTo().PublicationDate />
		</cffunction>	
	
		<!--- PostedByUserId --->
		<cffunction name="setPostedByUserId" access="public" output="false" returntype="void">
			<cfargument name="PostedByUserId" hint="I am this record's PostedByUserId value." required="yes" type="string" />
			<cfset _getTo().PostedByUserId = arguments.PostedByUserId />
		</cffunction>
		<cffunction name="getPostedByUserId" access="public" output="false" returntype="string">
			<cfreturn _getTo().PostedByUserId />
		</cffunction>	
	
		<!--- DisableComments --->
		<cffunction name="setDisableComments" access="public" output="false" returntype="void">
			<cfargument name="DisableComments" hint="I am this record's DisableComments value." required="yes" type="string" />
			<cfset _getTo().DisableComments = arguments.DisableComments />
		</cffunction>
		<cffunction name="getDisableComments" access="public" output="false" returntype="string">
			<cfreturn _getTo().DisableComments />
		</cffunction>	
	
		<!--- Views --->
		<cffunction name="setViews" access="public" output="false" returntype="void">
			<cfargument name="Views" hint="I am this record's Views value." required="yes" type="string" />
			<cfset _getTo().Views = arguments.Views />
		</cffunction>
		<cffunction name="getViews" access="public" output="false" returntype="string">
			<cfreturn _getTo().Views />
		</cffunction>	
	
	
	<cffunction name="load" access="public" hint="I load the Entry record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().read(_getTo()) />
	</cffunction>	
	
	<cffunction name="save" access="public" hint="I save the Entry record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void">
		<cfset _getDao().save(_getTo()) />
	</cffunction>	
	
	<cffunction name="delete" access="public" hint="I delete the Entry record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().delete(_getTo()) />
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo("Entry")) />
	</cffunction>
	
	
	<!--- Record For Author --->
	<cffunction name="setAuthorRecord" access="public" output="false" returntype="void">
	    <cfargument name="Record" hint="I am the Record to set the Author value from." required="yes" type="ReactorBlogData.Record.mssql.UserRecord" />
		
			<cfset setpostedByUserId(Record.getuserId()) />
		
	</cffunction>
	<cffunction name="getAuthorRecord" access="public" output="false" returntype="ReactorBlogData.Record.mssql.UserRecord">
		<cfset var Record = _getReactorFactory().createRecord("User") />
		
			<cfset Record.setuserId(getpostedByUserId()) />
		
		<cfset Record.load() />
		<cfreturn Record />
	</cffunction>
	
		<!--- Query For Category --->
		<cffunction name="createCategoryQuery" access="public" output="false" returntype="reactor.query.query">
			<cfset var Query = _getReactorFactory().createGateway("Category").createQuery() />
			
			
				<!--- if this is a linked table add a join back to the linking table --->
				<cfset Query.join("Category", "EntryCategory") />
			
			
			<cfreturn Query />
		</cffunction>
		
		
				<!--- Query For Category --->
				<cffunction name="getCategoryQuery" access="public" output="false" returntype="query">
					<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createCategoryQuery()#" type="reactor.query.query" />
					<cfset var CategoryGateway = _getReactorFactory().createGateway("Category") />
					<cfset var relationship = _getReactorFactory().createMetadata("EntryCategory").getRelationship("Entry").relate />
					
					<cfloop from="1" to="#ArrayLen(relationship)#" index="x">
						<cfset arguments.Query.getWhere().isEqual("EntryCategory", relationship[x].from, evaluate("get#relationship[x].to#()")) />
					</cfloop>
					
					<cfset arguments.Query.returnObjectFields("Category") />

					<cfreturn CategoryGateway.getByQuery(arguments.Query)>
				</cffunction>
				
				<!--- Query For Category --->
				<!--- cffunction name="getCategoryQuery" access="public" output="false" returntype="query">
					<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createCategoryQuery()#" type="reactor.query.query" />
					<cfset var relationships = _getReactorFactory().createMetadata("EntryCategory").getRelationship("Category").relate />
					<cfset var x = 0 />
					<cfset var relationship = 0 />
					<cfset var LinkedGateway = _getReactorFactory().createGateway("Category") />
					<cfset var LinkedQuery = LinkedGateway.createQuery() />
					<cfset var EntryCategoryQuery = getEntryCategoryQuery() />

					<cfif EntryCategoryQuery.recordCount>
						<cfloop from="1" to="#ArrayLen(relationships)#" index="x">
							<cfset relationship = relationships[x] />
							
							<cfset LinkedQuery.getWhere().isIn("Category", relationship.to, evaluate("ValueList(EntryCategoryQuery.#relationship.from#)")) />
							
						</cfloop>
					<cfelse>
						<cfset LinkedQuery.setMaxRows(0) />
							
					</cfif>
					
					<cfreturn LinkedGateway.getByQuery(LinkedQuery) />
				</cffunction--->
			
		
		<!--- Array For Category --->
		<cffunction name="getCategoryArray" access="public" output="false" returntype="array">
			<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createCategoryQuery()#" type="reactor.query.query" />
			<cfset var CategoryQuery = getCategoryQuery(arguments.Query) />
			<cfset var CategoryArray = ArrayNew(1) />
			<cfset var CategoryRecord = 0 />
			<cfset var CategoryTo = 0 />
			<cfset var field = "" />
			
			<cfloop query="CategoryQuery">
				<cfset CategoryRecord = _getReactorFactory().createRecord("Category") >
				<cfset CategoryTo = CategoryRecord._getTo() />
	
				<!--- populate the record's to --->
				<cfloop list="#CategoryQuery.columnList#" index="field">
					<cfset CategoryTo[field] = CategoryQuery[field][CategoryQuery.currentrow] >
				</cfloop>
				
				<cfset CategoryRecord._setTo(CategoryTo) />
				
				<cfset CategoryArray[ArrayLen(CategoryArray) + 1] = CategoryRecord >
			</cfloop>
	
			<cfreturn CategoryArray />
		</cffunction>		
	
		<!--- Query For Comment --->
		<cffunction name="createCommentQuery" access="public" output="false" returntype="reactor.query.query">
			<cfset var Query = _getReactorFactory().createGateway("Comment").createQuery() />
			
			
			
			<cfreturn Query />
		</cffunction>
		
		
				<!--- Query For Comment --->
				<cffunction name="getCommentQuery" access="public" output="false" returntype="query">
					<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createCommentQuery()#" type="reactor.query.query" />
					<cfset var CommentGateway = _getReactorFactory().createGateway("Comment") />
					
						<cfset arguments.Query.getWhere().isEqual("Comment", "entryId", getentryId()) />
					
					<cfreturn CommentGateway.getByQuery(arguments.Query)>
				</cffunction>
			
		
		<!--- Array For Comment --->
		<cffunction name="getCommentArray" access="public" output="false" returntype="array">
			<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createCommentQuery()#" type="reactor.query.query" />
			<cfset var CommentQuery = getCommentQuery(arguments.Query) />
			<cfset var CommentArray = ArrayNew(1) />
			<cfset var CommentRecord = 0 />
			<cfset var CommentTo = 0 />
			<cfset var field = "" />
			
			<cfloop query="CommentQuery">
				<cfset CommentRecord = _getReactorFactory().createRecord("Comment") >
				<cfset CommentTo = CommentRecord._getTo() />
	
				<!--- populate the record's to --->
				<cfloop list="#CommentQuery.columnList#" index="field">
					<cfset CommentTo[field] = CommentQuery[field][CommentQuery.currentrow] >
				</cfloop>
				
				<cfset CommentRecord._setTo(CommentTo) />
				
				<cfset CommentArray[ArrayLen(CommentArray) + 1] = CommentRecord >
			</cfloop>
	
			<cfreturn CommentArray />
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
					
						<cfset arguments.Query.getWhere().isEqual("EntryCategory", "entryId", getentryId()) />
					
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
	    <cfargument name="to" hint="I am this record's transfer object." required="yes" type="ReactorBlogData.To.mssql.EntryTo" />
	    <cfset variables.to = arguments.to />
	</cffunction>
	<cffunction name="_getTo" access="public" output="false" returntype="ReactorBlogData.To.mssql.EntryTo">
		<cfreturn variables.to />
	</cffunction>	
	
	<!--- dao --->
	<cffunction name="_setDao" access="private" output="false" returntype="void">
	    <cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="ReactorBlogData.Dao.mssql.EntryDao" />
	    <cfset variables.dao = arguments.dao />
	</cffunction>
	<cffunction name="_getDao" access="private" output="false" returntype="ReactorBlogData.Dao.mssql.EntryDao">
	    <cfreturn variables.dao />
	</cffunction>
	
</cfcomponent>
	
