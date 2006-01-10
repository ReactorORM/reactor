<cfcomponent displayname="FortuneController" output="false" hint="I am the controller for Fortunes." extends="ModelGlue.Core.Controller">

	<cfset variables.Fortune = 0 />
	<cfset variables.FortuneConfig = 0 />
	<cfset variables.TimedCache = 0 />

	<!--- Constructor --->
	<cffunction name="Init" access="Public" returnType="FortuneController" output="false" hint="I build a new FortuneController">
		<cfargument name="ModelGlue" required="true" type="ModelGlue.ModelGlue" />
		<cfargument name="InstanceName" required="true" type="string" />
		<cfset super.Init(arguments.ModelGlue) />
		
		<cfset variables.FortuneFacade = CreateObject("Component", "ReactorSamples.Blog.model.fortune.FortuneFacade").init(
			getModelGlue().getConfigBean("fortuneConfig.xml", true),
			CreateObject("Component", "modelglue.util.timedCache")
		) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- GetFortune --->
	<cffunction name="GetFortune" access="Public" returntype="void" output="false" hint="I get a fortune.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		
		<!--- set the fortune into the event --->
		<cfset arguments.event.setValue("fortune", variables.FortuneFacade.getFortune()) />
	</cffunction>
	
	<!--- GetAnyFortune --->
	<cffunction name="GetAnyFortune" access="Public" returntype="void" output="false" hint="I get any fortune.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		
		<!--- set the fortune into the event --->
		<cfset arguments.event.setValue("anyFortune", variables.FortuneFacade.getAnyFortune()) />
	</cffunction>
	
	<!--- GetFortuneTopics --->
	<cffunction name="GetFortuneTopics" access="Public" returntype="void" output="false" hint="I get any fortune.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		
		<!--- set the fortune topics into the event --->
		<cfset arguments.event.setValue("fortuneTopics", variables.FortuneFacade.getFortuneTopics()) />
	</cffunction>
	
	<!--- Functions specified by <message-listener> tags --->
	<cffunction name="OnRequestStart" access="Public" returntype="void" output="false" hint="I am an event handler.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var ScopeFacade = CreateObject("Component", "ReactorSamples.Blog.model.util.ScopeFacade").init("session") />
	</cffunction>
	
	<cffunction name="OnRequestEnd" access="Public" returntype="void" output="false" hint="I am an event handler.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
	</cffunction>

</cfcomponent>

