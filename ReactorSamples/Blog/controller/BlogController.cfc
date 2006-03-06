<cfcomponent displayname="BlogController" output="false" hint="I am the controller for a Blog." extends="ModelGlue.Core.Controller">

	<cfset variables.Reactor = 0 />
	<cfset variables.CategoryGateway = 0 />
	<cfset variables.CommentGateway = 0 />
	<cfset variables.UserGateway = 0 />
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
		<cfset variables.BlogConfig = getModelGlue().getConfigBean("blogConfig.xml", true) /> 
		<cfset variables.Reactor = CreateObject("Component", "reactor.reactorFactory").init(variables.BlogConfig.getReactorConfigFile()) />
		<cfset variables.CategoryGateway = Reactor.createGateway("Category") /> 
		<cfset variables.CommentGateway = Reactor.createGateway("Comment") /> 
		<cfset variables.UserGateway = Reactor.createGateway("User") /> 
		<cfset variables.EntryGateway = Reactor.createGateway("Entry").init(variables.BlogConfig.getRecentEntryDays()) /> 
		<cfset variables.UrlPinger = CreateObject("Component", "ReactorSamples.Blog.model.blog.UrlPinger").init(variables.BlogConfig.getPingUrlArray()) />
		<cfset variables.Search = CreateObject("Component", "ReactorSamples.Blog.model.search.Search").init(variables.BlogConfig.getBlogSearchCollection(), variables.BlogConfig.getAdditionalCollectonsList()) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- DoGetHighestRatedEntries --->
	<cffunction name="DoGetHighestRatedEntries" access="Public" returntype="void" output="false" hint="I return the highest rated entries in the blog">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.setValue("highestRatedEntries", variables.EntryGateway.getHighestRatedEntries(variables.BlogConfig.getStatsLimit())) />
	</cffunction>
	
	<!--- DoGetMostViewedEntries --->
	<cffunction name="DoGetMostViewedEntries" access="Public" returntype="void" output="false" hint="I return the most viewed entries in the blog">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.setValue("mostViewedEntries", variables.EntryGateway.GetMostViewedEntries(variables.BlogConfig.getStatsLimit())) />
	</cffunction>
	
	<!--- DoGetMostCommentedOn --->
	<cffunction name="DoGetMostCommentedOn" access="Public" returntype="void" output="false" hint="I return the most commented on entries in the blog">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.setValue("mostCommentedOn", variables.EntryGateway.GetMostCommentedOn(variables.BlogConfig.getStatsLimit())) />
	</cffunction>
	
	<!--- DoGetCommentParticipants --->
	<cffunction name="DoGetCommentParticipants" access="Public" returntype="void" output="false" hint="I get the email addresses of people who have been participating in the comments.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var CommentRecord = arguments.event.getValue("CommentRecord") />
		<cfset var EntryAuthor = variables.EntryGateway.getAuthor(CommentRecord.getEntryId()) />
		
		<cfset var participants = variables.CommentGateway.getParticipants(
			arguments.event.getValue("entryId"),
			CommentRecord.getEmailAddress(),
			EntryAuthor.firstName & " " & EntryAuthor.lastName,
			EntryAuthor.emailAddress
		) />
		
		<cfset arguments.event.setValue("particpants", participants) />
	</cffunction>
	
	<!--- DoSetErrorResult --->
	<cffunction name="DoSetErrorResult" access="Public" returntype="void" output="false" hint="I set the error result.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.addResult(Iif(variables.BlogConfig.getShowFriendlyErrors(), DE('friendly'), DE('unfriendly'))) />
	</cffunction>
	
	<!--- DoSaveUser --->
	<cffunction name="DoSaveUser" access="Public" returntype="void" output="false" hint="I save a User.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var UserRecord = arguments.event.getValue("OtherUserRecord") />
		<cfset UserRecord.save() />
	</cffunction>
	
	<!--- DoValidateUser --->
	<cffunction name="DoValidateUser" access="Public" returntype="void" output="false" hint="I validate a User.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var UserRecord = arguments.event.getValue("OtherUserRecord") />
		<cfset var Errors = UserRecord.validate() />
		
		<cfset arguments.event.setValue("Errors", Errors) />
		<cfif Errors.hasErrors()>
			<cfset arguments.event.addResult("invalid") />
		<cfelse>
			<cfset arguments.event.addResult("valid") />
		</cfif>
	</cffunction>
	
	<!--- DoGetUser --->
	<cffunction name="DoGetUser" access="Public" returntype="void" output="false" hint="I get or create a User.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var UserRecord = variables.Reactor.createRecord("User").load(UserId=arguments.event.getValue("UserId", 0)) />
		
		<!--- update the User --->
		<cfset arguments.event.makeEventBean(UserRecord) />
		<cfset arguments.event.setValue("OtherUserRecord", UserRecord) />		
	</cffunction>
	
	<!--- DoDeleteUser --->
	<cffunction name="DoDeleteUser" access="Public" returntype="void" output="false" hint="I delete a User.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var UserRecord = arguments.event.getValue("OtherUserRecord") />
		<cfset UserRecord.delete() />
	</cffunction>
	
	<!--- DoGetUsers --->
	<cffunction name="DoGetUsers" access="Public" returntype="void" output="false" hint="I get a query of all the Users in the Blog.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.setValue("Users", variables.UserGateway.getAllUsers()) />
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
		<cfset var CategoryRecord = variables.Reactor.createRecord("Category").load(categoryId=arguments.event.getValue("categoryId", 0)) />
				
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
	
	<!--- DoGetCategories --->
	<cffunction name="DoGetCategories" access="Public" returntype="void" output="false" hint="I get a query of all the categories in the Blog.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.setValue("Categories", variables.CategoryGateway.getCountedCategories()) />
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
		<cfset var reIndexEntries = QueryNew("url,title,body") />
		
		<!---
			This is a lot more code than I would normally put in a controller.  but, in the interest of time, I'm doing it!
			Additionally, these next 6 lines of code are formatting a query in such a way that the indexQuery method on the 
			search object will know how to work with it.  This is bad.  Sorry.  	
		--->
		<cfloop query="entries">
			<cfset QueryAddRow(reIndexEntries) />
			<cfset QuerySetCell(reIndexEntries, "url", "index.cfm?event=viewEntry&entryId=#entries.entryId#") />
			<cfset QuerySetCell(reIndexEntries, "title", entries.title) />
			<cfset QuerySetCell(reIndexEntries, "body", ReReplace(entries.article, "<[^<]+?>", "", "all")) />
		</cfloop>
				
		<!--- empty the collection --->
		<cfset variables.Search.empty() />
		
		<cfset variables.Search.indexQuery(reIndexEntries) />	
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
	
	<!--- DoSetSubscriptionStatus --->
	<cffunction name="DoSetSubscriptionStatus" access="Public" returntype="void" output="false" hint="I set a commenter's subscription status for an entry.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset variables.CommentGateway.setSubscriptionStatus(arguments.event.getValue("emailAddress"), arguments.event.getValue("subscribe", 0), arguments.event.getValue("EntryId", 0)) />
	</cffunction>
	
	<!--- DoSaveComment --->
	<cffunction name="DoSaveComment" access="Public" returntype="void" output="false" hint="I save an comment.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var CommentRecord = arguments.event.getValue("CommentRecord") />
		<cfset CommentRecord.setSubscribe(arguments.event.getValue("subscribe", 0)) />
		<cfset CommentRecord.save() />
	</cffunction>
	
	<!--- DoGetComments --->
	<cffunction name="DoGetComments" access="Public" returntype="void" output="false" hint="I get the comments for a blog entries.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var EntryRecord = arguments.event.getValue("EntryRecord") />
		<cfset arguments.event.setValue("CommentArray", EntryRecord.getCommentIterator().getArray()) />
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
		
	<!--- DoGetEntries --->
	<cffunction name="DoGetEntries" access="Public" returntype="void" output="false" hint="I get a query of blog entries.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var categoryId = arguments.event.getValue("categoryId", 0) />
		<cfset var month = arguments.event.getValue("month", 0) />
		<cfset var year = arguments.event.getValue("year", 0) />
		
		<cfset arguments.event.setValue("entries", variables.EntryGateway.getMatching(categoryId, month, year)) />
		
	</cffunction>
		
	<!--- DoValidateEntryExists --->
	<cffunction name="DoValidateEntryExists" access="Public" returntype="void" output="false" hint="I validate that an entry exists.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var entry = variables.EntryGateway.getByFields(entryId=arguments.event.getValue("entryId", 0)) />
		
		<cfif NOT entry.recordCount>
			<cfset arguments.event.addResult("NoSuchEntry") />
		</cfif>
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
		<cfset var CommentRecord = variables.Reactor.createRecord("Comment").load(commentId=arguments.event.getValue("commentId", 0)) />
		
		<!--- update the entry --->
		<cfset arguments.event.makeEventBean(CommentRecord) />
		<cfset arguments.event.setValue("CommentRecord", CommentRecord) />	
	</cffunction>
	
	<!--- DoSaveEntry --->
	<cffunction name="DoSaveEntry" access="Public" returntype="void" output="false" hint="I save an entry.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var EntryRecord = arguments.event.getValue("EntryRecord") />
		<cfset EntryRecord.setDisableComments(arguments.event.getValue("disableComments", 0)) />
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
		<cfset var EntryRecord = arguments.event.getValue("EntryRecord") />
		<cfset var ScopeFacade = CreateObject("Component", "ReactorSamples.Blog.model.util.ScopeFacade").init("session") />
		<cfset var EntriesRatedList = ScopeFacade.getValue("EntriesRatedList", "") />
		
		<cfif NOT ListFind(EntriesRatedList, arguments.event.getValue("entryId")) AND arguments.event.getValue("rating") GTE 1 AND arguments.event.getValue("rating") LTE 5>
			<!--- rate the entry --->
			<cfset EntryRecord.setTotalRating(EntryRecord.getTotalRating() + round(arguments.event.getValue("rating"))) />
			<cfset EntryRecord.setTimesRated(EntryRecord.getTimesRated() + 1) />
			<cfset EntryRecord.save() />
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

