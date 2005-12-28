<cfcomponent displayname="BlogController" output="false" hint="I am the controller for a blog." extends="ModelGlue.Core.Controller">

	<cfset variables.Reactor = 0 />
	<cfset variables.CategoryGateway = 0 />
	<cfset variables.EntryGateway = 0 />
	<cfset variables.BlogConfig = 0 />
	
	<!--- Constructor --->
	<cffunction name="Init" access="Public" returnType="BlogController" output="false" hint="I build a new BlogController">
		<cfargument name="ModelGlue" required="true" type="ModelGlue.ModelGlue" />
		<cfargument name="InstanceName" required="true" type="string" />
		<cfset super.Init(arguments.ModelGlue) />
		
		<cfset variables.Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/ReactorSamples/Blog/config/Reactor.xml")) />
		<cfset variables.CategoryGateway = Reactor.createGateway("Category") /> 
		<cfset variables.EntryGateway = Reactor.createGateway("Entry") /> 
		<cfset variables.BlogConfig = getModelGlue().getConfigBean("blogConfig.xml", true) /> 
				
		<!--- Controllers are in the application scope:  Put any application startup code here. --->
		<cfreturn this />
	</cffunction>
	
	<!--- GetCategories --->
	<cffunction name="GetCategories" access="Public" returntype="void" output="false" hint="I get a query of all the categories in the blog.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.setValue("Categories", variables.CategoryGateway.getCountedCategories()) />
	</cffunction>
		
	<!--- GetEntries --->
	<cffunction name="GetEntries" access="Public" returntype="void" output="false" hint="I get a query of blog entries.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var categoryId = arguments.event.getValue("categoryId", 0) />
		<cfset var date = arguments.event.getValue("date", "1/1/1900") />
		
		<cfset arguments.event.setValue("entries", variables.EntryGateway.getMatching(categoryId, date)) />
	</cffunction>
	
	<!--- GetEntry --->
	<cffunction name="GetEntry" access="Public" returntype="void" output="false" hint="I get or create an entry.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var EntryRecord = variables.Reactor.createRecord("Entry") />
		
		<cfset EntryRecord.setEntryId(arguments.event.getValue("entryId", 0)) />
		<cfset EntryRecord.load() />
		
		<!--- update the entry --->
		<cfset arguments.event.makeEventBean(EntryRecord) />
		<cfset arguments.event.setValue("EntryRecord", EntryRecord) />		
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

