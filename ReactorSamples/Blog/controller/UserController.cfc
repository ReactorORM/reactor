<cfcomponent displayname="UserController" output="false" hint="I am the controller for a User." extends="ModelGlue.Core.Controller">

	<cfset variables.Reactor = 0 />
	<cfset variables.CategoryGateway = 0 />
	<cfset variables.ScopeFacade = 0 />
	
	<!--- Constructor --->
	<cffunction name="Init" access="Public" returnType="UserController" output="false" hint="I build a new UserController">
		<cfargument name="ModelGlue" required="true" type="ModelGlue.ModelGlue" />
		<cfargument name="InstanceName" required="true" type="string" />
		<cfset super.Init(arguments.ModelGlue) />
		
		<cfset variables.Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/ReactorSamples/User/config/Reactor.xml")) />
		<cfset variables.CategoryGateway = variables.Reactor.createGateway("Category") /> 
		<cfset variables.ScopeFacade = CreateObject("Component", "ReactorSamples.Blog.model.util.ScopeCache").init("session") />
		<!--- Controllers are in the application scope:  Put any application startup code here. --->
		<cfreturn this />
	</cffunction>
	
	<!--- GetCategories --->
	<cffunction name="GetCategories" access="Public" returntype="void" output="false" hint="I get a query of all the categories in the User.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.setValue("Categories", variables.CategoryGateway.getCountedCategories()) />
	</cffunction>
		
	<!--- Functions specified by <message-listener> tags --->
	<cffunction name="OnRequestStart" access="Public" returntype="void" output="false" hint="I am an event handler.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var UserRecord = 0 />
		
		<cfif NOT variables.ScopeFacade.Exists("UserRecord")>
			<cfset variables.ScopeFacade.SetValue("UserRecord", variables.) /> 
		</cfif>
		
	</cffunction>
	
	<cffunction name="OnRequestEnd" access="Public" returntype="void" output="false" hint="I am an event handler.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
	</cffunction>

</cfcomponent>

