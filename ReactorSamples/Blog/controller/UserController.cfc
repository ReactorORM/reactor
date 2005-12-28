<cfcomponent displayname="UserController" output="false" hint="I am the controller for a User." extends="ModelGlue.Core.Controller">

	<cfset variables.Reactor = 0 />
	<cfset variables.CategoryGateway = 0 />
	
	<!--- Constructor --->
	<cffunction name="Init" access="Public" returnType="UserController" output="false" hint="I build a new UserController">
		<cfargument name="ModelGlue" required="true" type="ModelGlue.ModelGlue" />
		<cfargument name="InstanceName" required="true" type="string" />
		<cfset super.Init(arguments.ModelGlue) />
		
		<cfset variables.Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/ReactorSamples/Blog/config/Reactor.xml")) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- DoLogout --->
	<cffunction name="DoLogout" access="Public" returntype="void" output="false" hint="I log a user out.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var ScopeFacade = CreateObject("Component", "ReactorSamples.Blog.model.util.ScopeFacade").init("session") />
		<cfset ScopeFacade.SetValue("UserRecord", variables.Reactor.createRecord("User")) /> 
		<cfset arguments.event.setValue("UserRecord", ScopeFacade.getValue("UserRecord")) />
	</cffunction>
	
	<!--- DoValidateLogin --->
	<cffunction name="DoValidateLogin" access="Public" returntype="void" output="false" hint="I validate a login.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var UserRecord = arguments.event.getValue("UserRecord") />
			
		<cfset arguments.event.makeEventBean(UserRecord) />

		<cfif UserRecord.login()>
			<!--- restore the user's event --->
			<cfset RestoreEventValues(arguments.event) />
			
			<cfset arguments.event.forward(UserRecord.getPostLoginEvent()) />
		<cfelse>
			<cfset arguments.event.addResult("invalid") />
		</cfif>
	</cffunction>
	
	<!--- DoCheckIfLoggedIn --->
	<cffunction name="DoCheckIfLoggedIn" access="Public" returntype="void" output="false" hint="I check if a user is logged in.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var UserRecord = arguments.event.getValue("UserRecord") />
		<cfset var returnToEvent = "Home" />
		
		<cfif arguments.event.argumentExists("returnToEvent")>
			<cfset returnToEvent = arguments.event.getArgument("returnToEvent") />
		</cfif>
		
		<cfif NOT UserRecord.isLoggedIn()>
			<!--- save the current event --->
			<cfset SaveEventValues(arguments.event) />
			
			<cfset UserRecord.setPostLoginEvent(returnToEvent) />
			<cfset arguments.event.forward("LoginForm") />
		</cfif>
		
	</cffunction>
	
	<!--- SaveEventValues --->
	<cffunction name="SaveEventValues" access="private" returntype="void" output="false" hint="I save event arguments.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var ScopeFacade = CreateObject("Component", "ReactorSamples.Blog.model.util.ScopeFacade").init("session") />
		<cfset ScopeFacade.SetValue("EventValues", arguments.event.getAllValues()) />		
	</cffunction>
	
	<!--- RestoreEventValues --->
	<cffunction name="RestoreEventValues" access="private" returntype="void" output="false" hint="I restore saved event arguments.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var ScopeFacade = CreateObject("Component", "ReactorSamples.Blog.model.util.ScopeFacade").init("session") />
		<cfset var eventValues = ScopeFacade.getValue("EventValues", StructNew()) />
		<cfset var item = 0 />
		
		<cfloop collection="#eventValues#" item="item">
			<cfset arguments.event.setValue(item, eventValues[item]) />
		</cfloop>
		
		<cfset ScopeFacade.removeValue("EventValues") />
	</cffunction>
	
	<!--- Functions specified by <message-listener> tags --->
	<cffunction name="OnRequestStart" access="Public" returntype="void" output="false" hint="I am an event handler.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var ScopeFacade = CreateObject("Component", "ReactorSamples.Blog.model.util.ScopeFacade").init("session") />
		
		<cfif NOT ScopeFacade.Exists("UserRecord")>
			<cfset ScopeFacade.SetValue("UserRecord", variables.Reactor.createRecord("User")) /> 
		</cfif>
		
		<cfset arguments.event.setValue("UserRecord", ScopeFacade.getValue("UserRecord")) />		
	</cffunction>
	
	<cffunction name="OnRequestEnd" access="Public" returntype="void" output="false" hint="I am an event handler.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
	</cffunction>

</cfcomponent>
