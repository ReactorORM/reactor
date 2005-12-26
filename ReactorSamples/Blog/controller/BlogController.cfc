<cfcomponent displayname="BlogController" output="false" hint="I am the controller for a blog." extends="ModelGlue.Core.Controller">

	<cfset variables.CategoryGateway = 0 />

	<!--- Constructor --->
	<cffunction name="Init" access="Public" returnType="BlogController" output="false" hint="I build a new BlogController">
		<cfargument name="ModelGlue" required="true" type="ModelGlue.ModelGlue" />
		<cfargument name="InstanceName" required="true" type="string" />
		<cfset var Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/ReactorSamples/Blog/config/Reactor.xml")) />
		<cfset super.Init(arguments.ModelGlue) />
		
		<cfset variables.CategoryGateway = Reactor.createGateway("Category") /> 
				
		<!--- Controllers are in the application scope:  Put any application startup code here. --->
		<cfreturn this />
	</cffunction>
	
	<!--- GetCategories --->
	<cffunction name="GetCategories" access="Public" returntype="void" output="false" hint="I get a query of all the categories in the blog.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset arguments.event.setValue("Categories", variables.CategoryGateway.getCountedCategories()) />
	</cffunction>
		
	<!--- Functions specified by <message-listener> tags --->
	<cffunction name="OnRequestStart" access="Public" returntype="void" output="false" hint="I am an event handler.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
	</cffunction>
	
	<cffunction name="OnRequestEnd" access="Public" returntype="void" output="false" hint="I am an event handler.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
	</cffunction>

</cfcomponent>

