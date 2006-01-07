
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
		<cfset var delimiter = "" />
		<cfset var maxLength = Iif(Len(arguments.article) LT 1000, DE(Len(arguments.article)), DE(1000)) />
		<cfset var x = 0 />
		<cfset arguments.article = Trim(arguments.article) />
		
		
		<!--- make sure this is formatted with html --->
		<cfif NOT ReFindNoCase("</p.*?>", arguments.article, location) AND NOT ReFindNoCase("<br.*?>", arguments.article, location)>
			<!--- strip CRs --->
			<cfset arguments.article = StripCR(arguments.article) />
			
			<!--- replace all multiple LFs with </p><p> --->
			<cfset arguments.article = "<p>" & ReReplace(arguments.article, "(\n){2,}", "</p><p>", "all") & "</p>" />
			<!--- replace all single LFs with <br> --->
			<cfset arguments.article = ReReplace(arguments.article, "\n", "<br />", "all") />
			
			<!--- add 2 linebreaks after the </p>s (to make it easier to read) --->
			<cfset arguments.article = Replace(arguments.article, "</p>", "</p>" & chr(13) & chr(10) & chr(13) & chr(10), "all") />
			
			<!--- add 1 linebreak after the <br />s too --->
			<cfset arguments.article = Replace(arguments.article, "<br />", "<br />" & chr(13) & chr(10), "all") />
		</cfif>
		
		<!--- save the article --->
		<cfset super.setArticle(arguments.article) />
		
		<!--- if this has a table, delete everyting from that point forward --->
		<cfif ReFindNoCase("<table.*?>", arguments.article)>
			<cfset arguments.article = Left(arguments.article, ReFindNoCase("<table.*?>", arguments.article) - 1) />
		</cfif>
		<!--- if this has a table, delete everyting from that point forward --->
		<cfif ReFindNoCase("<div.*?>", arguments.article)>
			<cfset arguments.article = Left(arguments.article, ReFindNoCase("<div.*?>", arguments.article) - 1) />
		</cfif>
		
		<!--- what delimits a new line in this entry? --->
		<cfif ReFindNoCase("</p.*?>", arguments.article, location) GT 0>
			<cfset delimiter = "</p.*?>" />
			
		<cfelseif ReFindNoCase("<br.*?>", arguments.article, location) GT 0>
			<cfset delimiter = "<br.*?>" />
			
		<cfelse>
			<cfset delimiter = "\s." />
		
		</cfif>
		
		<!--- create a preview --->
		<cfif Len(arguments.article) GT 1000>
			<cfloop condition="true">
				<cfset newLocation = ReFindNoCase(delimiter, arguments.article, location, true) />
				<cfset newLocation = newLocation.pos[1] + newLocation.len[1] - 1 />
				
				<!--- the 'x' var below is a safety net --->
				<cfif newLocation LTE maxLength AND x LTE 50>
					<cfset x = x + 1 />
					<cfset location = newLocation />
				<cfelse>
					<cfbreak />
				</cfif>
			</cfloop>
			
			<!--- get the preview --->
			<cfif location GT 0>
				<cfset preview = Left(arguments.article, location) />
			</cfif>
		
			<cfset setPreview(preview) />
		<cfelse>
			<!--- too short to bother making a preview of --->
			<cfset setPreview(arguments.article) />
		</cfif>
	</cffunction>
	
	<cffunction name="getCommentCount" access="public" hint="I return the number of comments on this entry" output="false" returntype="numeric">
		<cfreturn getCommentQuery().recordCount />
	</cffunction>
	
	<cffunction name="getRatingCount" access="public" hint="I return the number of ratings on this entry" output="false" returntype="numeric">
		<cfreturn getRatingQuery().recordCount />
	</cffunction>
	
	<cffunction name="getAverageRating" access="public" hint="I return the average rating for this entry" output="false" returntype="numeric">
		<cfset var qRating = 0 />		
		
		<!---
		note: I'm not using a cfquery param for two reasons.  1: I want to easily cache this for a few seconds and you can't with a
		cfqueryparam and 2: getEntryId()'s data type is already enforced as a numeric value
		--->
		<cfquery name="qRating" datasource="#_getConfig().getDsn()#" cachedwithin="#CreateTimespan(0,0,0,5)#">
			SELECT dbo.getAverageRating(#getEntryId()#) avgRating
		</cfquery>
		
		<cfreturn qRating.avgRating />
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
	
