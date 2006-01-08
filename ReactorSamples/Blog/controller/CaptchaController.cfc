<cfcomponent displayname="CaptchaController" output="false" hint="I am the controller for a User." extends="ModelGlue.Core.Controller">

	
	<cfset variables.BlogConfig = 0 />
	<cfset variables.Captcha = 0 />
	
	<!--- Constructor --->
	<cffunction name="Init" access="Public" returnType="CaptchaController" output="false" hint="I build a new CaptchaController">
		<cfargument name="ModelGlue" required="true" type="ModelGlue.ModelGlue" />
		<cfargument name="InstanceName" required="true" type="string" />
		<cfset super.Init(arguments.ModelGlue) />
		
		<cfset variables.BlogConfig = getModelGlue().getConfigBean("blogConfig.xml", true) /> 
		<cfif variables.BlogConfig.getUseCaptcha()>
			<cfset variables.Captcha = CreateObject("Component", "ReactorSamples.blog.model.util.Captcha").configure(expandPath(variables.BlogConfig.getCaptchaDirectory()), variables.BlogConfig.getCaptchaKey()) />
		</cfif>
		<cfreturn this />
	</cffunction>
	
	<!--- DoCreateCaptcha --->
	<cffunction name="DoCreateCaptcha" access="Public" returntype="void" output="false" hint="I create a captcha image.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
		<cfset var ScopeFacade = CreateObject("Component", "ReactorSamples.blog.model.util.ScopeFacade").init("session") />
		
		<cfif variables.BlogConfig.getUseCaptcha()>
			<cfset ScopeFacade.setValue("Captcha", variables.Captcha.createCaptcha()) />
			<cfset arguments.event.setValue("Captcha", ScopeFacade.getValue("Captcha")) />
		</cfif>
	</cffunction>
	
	<!--- DoValidateCaptcha --->
	<cffunction name="DoValidateCaptcha" access="Public" returntype="void" output="false" hint="I am an event handler.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">		
		<cfset var Errors = arguments.event.getValue("Errors") />
		<cfset var ScopeFacade = CreateObject("Component", "ReactorSamples.blog.model.util.ScopeFacade").init("session") />
		<cfset var captchaHash = 0 />
		
		<cfif variables.BlogConfig.getUseCaptcha()>
			<!--- get the session's hash --->
			<cfif ScopeFacade.exists("Captcha")>
				<!--- check the captcha string against the submitted captcha string --->
				<cfset captchaHash = ScopeFacade.getValue("Captcha").hash />
			</cfif>
			<!--- verify the hash --->
			<cfif NOT variables.Captcha.validate(captchaHash, arguments.event.getValue("captcha"))>
				<!--- add an error --->
				<cfset Errors.addError("Captcha", "Sorry, the code you entered was incorrect.  Please try again.") />
			</cfif>
		</cfif>

		<cfif Errors.hasErrors()>
			<cfset arguments.event.addResult("invalid") />
		<cfelse>
			<cfset arguments.event.addResult("valid") />
		</cfif>

	</cffunction>
	
	<!--- Functions specified by <message-listener> tags --->
	<cffunction name="OnRequestStart" access="Public" returntype="void" output="false" hint="I am an event handler.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">		
	</cffunction>
	
	<cffunction name="OnRequestEnd" access="Public" returntype="void" output="false" hint="I am an event handler.">
		<cfargument name="event" type="ModelGlue.Core.Event" required="true">
	</cffunction>

</cfcomponent>

