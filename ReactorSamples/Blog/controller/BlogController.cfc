<cfcomponent displayname="BlogController" output="false" hint="I am the controller for a blog." extends="ModelGlue.Core.Controller">

	<cfset variables.Reactor = 0 />
	<cfset variables.CategoryGateway = 0 />
	<cfset variables.CommentGateway = 0 />
	<cfset variables.EntryGateway = 0 />
	<cfset variables.BlogConfig = 0 />
	<cfset variables.Captcha = 0 />
	<cfset variables.Search = 0 />
	
	<!--- Constructor --->
	<cffunction name="Init" access="Public" returnType="BlogController" output="false" hint="I build a new BlogController">
		<cfargument name="ModelGlue" required="true" type="ModelGlue.ModelGlue" />
		<cfargument name="InstanceName" required="true" type="string" />
		<cfset super.Init(arguments.ModelGlue) />
		
		<!--- Controllers are in the application scope:  Put any application startup code here. --->
		<cfset variables.Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/ReactorSamples/Blog/config/Reactor.xml")) />
		<cfset variables.CategoryGateway = Reactor.createGateway("Category") /> 
		<cfset variables.CommentGateway = Reactor.createGateway("Comment") /> 
		<cfset variables.BlogConfig = getModelGlue().getConfigBean("blogConfig.xml", true) /> 
		<cfset variables.EntryGateway = Reactor.createGateway("Entry").init(variables.BlogConfig.getRecentEntryDays()) /> 
		<cfset variables.UrlPinger = CreateObject("Component", "reactorSamples.Blog.model.blog.UrlPinger").init(variables.BlogConfig.getPingUrlArray()) />
		<cfset variables.Search = CreateObject("Component", "reactorSamples.Blog.model.search.Search").init(variables.BlogConfig.getBlogSearchCollection(), variables.BlogConfig.getAdditionalCollectonsList()) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- DoGetCommentParticipants --->
	<cffunction name="DoGetCommentParticipants" access="Public" returntype="void" output="false" hint="I get the email addresses of people who have been participating in the comments.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.setValue("particpants", variables.CommentGateway.getParticipants(arguments.event.getValue("entryId"))) />
	</cffunction>
	
	<!--- DoSetErrorResult --->
	<cffunction name="DoSetErrorResult" access="Public" returntype="void" output="false" hint="I set the error result.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.addResult(Iif(variables.BlogConfig.getShowFriendlyErrors(), DE('friendly'), DE('unfriendly'))) />
	</cffunction>
	
	<!--- DoSaveCategory --->
	<cffunction name="DoSaveCategory" access="Public" returntype="void" output="false" hint="I save a category.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var CategoryRecord = arguments.event.getValue("CategoryRecord") />
		<cfset CategoryRecord.save() />
	</cffunction>
	
	<!--- DoValidateCategory --->
	<cffunction name="DoValidateCategory" access="Public" returntype="void" output="false" hint="I validate a category.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var CategoryRecord = arguments.event.getValue("CategoryRecord") />
		<cfset var Errors = CategoryRecord.validate() />
		
		<cfset arguments.event.setValue("Errors", Errors) />
		<cfif Errors.hasErrors()>
			<cfset arguments.event.addResult("invalid") />
		<cfelse>
			<cfset arguments.event.addResult("valid") />
		</cfif>
	</cffunction>
	
	<!--- DoGetCategory --->
	<cffunction name="DoGetCategory" access="Public" returntype="void" output="false" hint="I get or create a category.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var CategoryRecord = variables.Reactor.createRecord("Category") />
		
		<cfset CategoryRecord.setCategoryId(arguments.event.getValue("categoryId", 0)) />
		<cfset CategoryRecord.load() />
		
		<!--- update the category --->
		<cfset arguments.event.makeEventBean(CategoryRecord) />
		<cfset arguments.event.setValue("CategoryRecord", CategoryRecord) />		
	</cffunction>
	
	<!--- DoDeleteCategory --->
	<cffunction name="DoDeleteCategory" access="Public" returntype="void" output="false" hint="I delete a category.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var CategoryRecord = arguments.event.getValue("CategoryRecord") />
		<cfset CategoryRecord.delete() />
	</cffunction>
	
	<!--- DoUpdateSearch --->
	<cffunction name="DoUpdateSearch" access="Public" returntype="void" output="false" hint="I add stuff to the search system.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var EntryRecord = arguments.event.getValue("EntryRecord") />
		<cfif BlogConfig.searchEnabled()>
			<cfset variables.Search.index("index.cfm?event=viewEntry&entryId=#EntryRecord.getEntryId()#", EntryRecord.getTitle(), EntryRecord.getArticle()) />	
		</cfif>
	</cffunction>
	
	<!--- DoReindex --->
	<cffunction name="DoReindex" access="Public" returntype="void" output="false" hint="I reindex all entries.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var entries = variables.EntryGateway.getAll() />
		<cfloop query="entries">
			<cfset variables.Search.index("index.cfm?event=viewEntry&entryId=#entries.entryId#", entries.title, entries.article) />	
		</cfloop>
	</cffunction>
	
	<!--- DoSearch --->
	<cffunction name="DoSearch" access="Public" returntype="void" output="false" hint="I search for stuff.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.setValue("searchResults", variables.Search.search(arguments.event.getValue("criteria"))) />
	</cffunction>
	
	<!--- DoPings --->
	<cffunction name="DoPings" access="Public" returntype="void" output="false" hint="I ping urls when an entry is created or edited.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset variables.UrlPinger.ping() />
	</cffunction>
	
	<!--- DoDeleteComment --->
	<cffunction name="DoDeleteComment" access="Public" returntype="void" output="false" hint="I delete a comment.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var CommentRecord = arguments.event.getValue("CommentRecord") />
		<cfset CommentRecord.delete() />
	</cffunction>
	
	<!--- DoValidateComment --->
	<cffunction name="DoValidateComment" access="Public" returntype="void" output="false" hint="I validate a comment.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var CommentRecord = arguments.event.getValue("CommentRecord") />
		<cfset var Errors = CommentRecord.validate() />
		
		<cfset arguments.event.setValue("Errors", Errors) />
		<cfif Errors.hasErrors()>
			<cfset arguments.event.addResult("invalid") />
		<cfelse>
			<cfset arguments.event.addResult("valid") />
		</cfif>
	</cffunction>
	
	<!--- DoSaveComment --->
	<cffunction name="DoSaveComment" access="Public" returntype="void" output="false" hint="I save an comment.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var CommentRecord = arguments.event.getValue("CommentRecord") />
		<cfset CommentRecord.save() />
	</cffunction>
	
	<!--- DoGetComments --->
	<cffunction name="DoGetComments" access="Public" returntype="void" output="false" hint="I get the comments for a blog entries.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var EntryRecord = arguments.event.getValue("EntryRecord") />
		<cfset arguments.event.setValue("CommentArray", EntryRecord.getCommentArray()) />
	</cffunction>
	
	<!--- DoGetRecentEntries --->
	<cffunction name="DoGetRecentEntries" access="Public" returntype="void" output="false" hint="I get a query of all recent blog entries.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.setValue("recentEntries", variables.EntryGateway.getRecentEntries(variables.BlogConfig.getRecentEntryCount())) />
	</cffunction>
	
	<!--- DoGetArchives --->
	<cffunction name="DoGetArchives" access="Public" returntype="void" output="false" hint="I get a query of all archive months, years and number of entries.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.setValue("archives", variables.EntryGateway.getArchives()) />
	</cffunction>
	
	<!--- DoGetCategories --->
	<cffunction name="DoGetCategories" access="Public" returntype="void" output="false" hint="I get a query of all the categories in the blog.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.setValue("Categories", variables.CategoryGateway.getCountedCategories()) />
	</cffunction>
		
	<!--- DoGetEntries --->
	<cffunction name="DoGetEntries" access="Public" returntype="void" output="false" hint="I get a query of blog entries.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var categoryId = arguments.event.getValue("categoryId", 0) />
		<cfset var month = arguments.event.getValue("month", 0) />
		<cfset var year = arguments.event.getValue("year", 0) />
		
		<cfset arguments.event.setValue("entries", variables.EntryGateway.getMatching(categoryId, month, year)) />
	</cffunction>
	
	<!--- DoGetEntry --->
	<cffunction name="DoGetEntry" access="Public" returntype="void" output="false" hint="I get or create an entry.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var EntryRecord = variables.Reactor.createRecord("Entry") />
		
		<cfset EntryRecord.setEntryId(arguments.event.getValue("entryId", 0)) />
		<cfset EntryRecord.load() />
		
		<!--- update the entry --->
		<cfset arguments.event.makeEventBean(EntryRecord) />
		<cfset arguments.event.setValue("EntryRecord", EntryRecord) />		
	</cffunction>
	
	<!--- DoGetComment --->
	<cffunction name="DoGetComment" access="Public" returntype="void" output="false" hint="I get or create a comment.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var CommentRecord = variables.Reactor.createRecord("Comment") />
		
		<cfset CommentRecord.setCommentId(arguments.event.getValue("commentId", 0)) />
		<cfset CommentRecord.load() />
					
		<!--- update the entry --->
		<cfset arguments.event.makeEventBean(CommentRecord) />
		<cfset arguments.event.setValue("CommentRecord", CommentRecord) />	
	</cffunction>
	
	<!--- DoSaveEntry --->
	<cffunction name="DoSaveEntry" access="Public" returntype="void" output="false" hint="I save an entry.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var EntryRecord = arguments.event.getValue("EntryRecord") />
		<cfset EntryRecord.setPostedByUserId(arguments.event.getValue("UserRecord").getUserId()) />
		<cfset EntryRecord.save() />
	</cffunction>
	
	<!--- DoValidateEntry --->
	<cffunction name="DoValidateEntry" access="Public" returntype="void" output="false" hint="I validate an entry.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var EntryRecord = arguments.event.getValue("EntryRecord") />
		<cfset var Errors = EntryRecord.validate() />
		
		<cfif Errors.hasErrors()>
			<cfset arguments.event.setValue("Errors", Errors) />
			<cfset arguments.event.addResult("invalid") />
		<cfelse>
			<cfset arguments.event.addResult("valid") />
		</cfif>
	</cffunction>
	
	<!--- DoDeleteEntry --->
	<cffunction name="DoDeleteEntry" access="Public" returntype="void" output="false" hint="I save an entry.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var EntryRecord = arguments.event.getValue("EntryRecord") />
		<cfset EntryRecord.delete() />
	</cffunction>
	
	<!--- DoRateEntry --->
	<cffunction name="DoRateEntry" access="Public" returntype="void" output="false" hint="I rate an entry.  Users can only rate an entry one time per session.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var RatingRecord = variables.Reactor.createRecord("Rating") />
		<cfset var ScopeFacade = CreateObject("Component", "ReactorSamples.Blog.model.util.ScopeFacade").init("session") />
		<cfset var EntriesRatedList = ScopeFacade.getValue("EntriesRatedList", "") />
		
		<cfif NOT ListFind(EntriesRatedList, arguments.event.getValue("entryId")) AND arguments.event.getValue("rating") GTE 1 AND arguments.event.getValue("rating") LTE 5>
			<!--- rate the entry --->
			<cfset RatingRecord.setEntryId(arguments.event.getValue("entryId")) />
			<cfset RatingRecord.setRating(arguments.event.getValue("rating")) />
			<cfset RatingRecord.save() />
			<!--- save the fact that this user has rated this entry --->
			<cfset EntriesRatedList = ListAppend(EntriesRatedList, arguments.event.getValue("entryId")) />
		</cfif>
		
		<!--- save the ratings --->
		<cfset ScopeFacade.setValue("EntriesRatedList", EntriesRatedList) />
	</cffunction>
	
	<!--- DoIncramentViewCount --->
	<cffunction name="DoIncramentViewCount" access="Public" returntype="void" output="false" hint="I save an entry.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var EntryRecord = arguments.event.getValue("EntryRecord") />
		<cfset EntryRecord.setViews(EntryRecord.getViews() + 1) />
		<cfset EntryRecord.save() />
	</cffunction>
	
	<!--- ManageLayout --->
	<cffunction name="ManageLayout" access="Public" returntype="void" output="false" hint="I add results indicating which view has been requested.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		
		<cfif arguments.event.valueExists("print")>
			<cfset arguments.event.addResult("print") />
		</cfif>
		
	</cffunction>
	
	<!--- UpdateEntry
	<cffunction name="UpdateEntry" access="Public" returntype="void" output="false" hint="I update an entry.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var EntryRecord = arguments.event.getValue("EntryRecord") />
		
	</cffunction> --->
	
	<!--- Functions specified by <message-listener> tags --->
	<cffunction name="OnRequestStart" access="Public" returntype="void" output="false" hint="I am an event handler.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.setValue("BlogConfig", variables.BlogConfig) />
	</cffunction>
	
	<cffunction name="OnRequestEnd" access="Public" returntype="void" output="false" hint="I am an event handler.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
	</cffunction>

</cfcomponent>

