
<cfcomponent hint="I am the custom Record object for the  table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="ReactorBlogData.Record.mssql.base.EntryRecord" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		<!--- strip all html and special characters to see if the user actually provided an article --->
		<cfset var article = Trim(ReReplaceNoCase(getArticle(), '(<(.|\n)+?>)|&.+?;|\r|\n|\t', "", "all")) />
		
		<!--- validate the Entry --->
		<cfset super.validate(arguments.ValidationErrorCollection) />
		
		<!--- make sure the user actually provided an article --->
		<cfif NOT Len(article)>
			<cfset arguments.ValidationErrorCollection.addError("article", ErrorManager.getError("Entry", "Article", "notProvided")) />
		</cfif>
		
		<!--- insure that at least one category was selected/provided --->
		<cfif NOT Len(getNewCategoryList()) AND NOT Len(getCategoryIdList())>
			<cfset arguments.ValidationErrorCollection.addError("categoryIdList", ErrorManager.getError("Entry", "CategoryIdList", "NoCategorySelected")) />
		</cfif>
		
		<!--- Add custom validation logic here, it will not be overwritten --->
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	<cffunction name="load" access="public" hint="I load the Entry record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset var categories = 0 />
		<!--- load the entry --->
		<cfset super.load() />
		<!--- get the category ids for this entry --->
		<cfset categories = getCategoryQuery() />
		<cfset setCategoryIdList(valueList(categories.categoryId)) />
	</cffunction>	
	
	<cffunction name="save" access="public" hint="I save the Entry record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void">
		<cfset var CategoryGateway = _getReactorFactory().createGateway("Category") />
		<cfset var EntryCategoryGateway = _getReactorFactory().createGateway("EntryCategory") />
		<cfset var EntryCategoryRecord = 0 />
		<cfset var CategoryRecord = 0 />
		<cfset var categoryIdList = getCategoryIdList() />
		<cfset var newCategoryList = getNewCategoryList() /> 
		<cfset var category = "" />
		<cfset var categories = "" />
		<cfset super.save() />
		
		<!--- create any new categories --->
		<cfloop list="#newCategoryList#" index="category">
			<!--- insure this category doesn't already exist --->
			<cfset categories = CategoryGateway.getByFields(name=category) />
			
			<cfif NOT categories.recordcount>
				<!--- the category does not exist - create it --->
				<cfset CategoryRecord = _getReactorFactory().createRecord("Category") />
				<cfset CategoryRecord.setName(Trim(category)) />
				<cfset CategoryRecord.save() />
				<cfset categoryIdList = ListAppend(categoryIdList, CategoryRecord.getCategoryId()) />
			<cfelse>
				<!--- the category exists, use it --->
				<cfset categoryIdList = ListAppend(categoryIdList, categories.categoryId) />
			</cfif>
		</cfloop>
		
		<!--- delete all categories associated with this entry --->
		<cfset EntryCategoryGateway.deleteByEntryId(getEntryId()) />
		
		<!--- associate selected categories --->
		<cfloop list="#categoryIdList#" index="category">	
			<!--- the category does not exist - create it --->
			<cfset EntryCategoryRecord = _getReactorFactory().createRecord("EntryCategory") />
			<cfset EntryCategoryRecord.setEntryId(getEntryId()) />
			<cfset EntryCategoryRecord.setCategoryId(category) />
			<cfset EntryCategoryRecord.save() />
		</cfloop>
	</cffunction>	
	
	<cffunction name="delete" access="public" hint="I delete the Entry record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset var EntryCategoryGateway = _getReactorFactory().createGateway("EntryCategory") />
		<cfset var RatingGateway = _getReactorFactory().createGateway("Rating") />
		
		<!--- delete all categories associated with this entry --->
		<cfset EntryCategoryGateway.deleteByEntryId(getEntryId()) />
		
		<!--- delete all raitings too --->
		<cfset RatingGateway.deleteByEntryId(getEntryId()) />
		
		<cfset super.delete() />
	</cffunction>
	
	<cffunction name="setArticle" access="public" output="false" returntype="void">
		<cfargument name="article" hint="I am the article html." required="yes" type="string" />
		<cfset var preview = "" />
		<cfset var location = 0 />
		<cfset var newLocation = 0 />
		
		<cfset arguments.article = Trim(arguments.article) />
		
		<cfset super.setArticle(arguments.article) />
		<!--- create a preview --->
		
		<cfloop condition="true">
			<cfset newLocation = ReFindNoCase("</p.*?>", arguments.article, location, true) />
			<cfset newLocation = newLocation.pos[1] + newLocation.len[1] />
			
			<cfif newLocation LTE 1000>
				<cfset location = newLocation />
			<cfelse>
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfset preview = Left(arguments.article, location) />
		
		<cfset setPreview(preview) />
	</cffunction>
		
	<cffunction name="setCategoryIdList" access="public" output="false" returntype="void">
		<cfargument name="categoryIdList" hint="I am this record's categoryIdList value." required="yes" type="string" />
		<cfset _getTo().categoryIdList = arguments.categoryIdList />
	</cffunction>
	<cffunction name="getCategoryIdList" access="public" output="false" returntype="string">
		<cfreturn _getTo().categoryIdList />
	</cffunction>	
	
	<cffunction name="setNewCategoryList" access="public" output="false" returntype="void">
		<cfargument name="newCategoryList" hint="I am a comma seperated list of new categories." required="yes" type="string" />
		<cfset _getTo().newCategoryList = arguments.newCategoryList />
	</cffunction>
	<cffunction name="getNewCategoryList" access="public" output="false" returntype="string">
		<cfreturn _getTo().newCategoryList />
	</cffunction>
	
</cfcomponent>
	
