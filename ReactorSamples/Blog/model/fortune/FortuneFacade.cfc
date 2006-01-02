<cfcomponent hint="I am a facade for the fortune web service.  My job is to simplify access to it and caching.">

	<cfset variables.FortuneConfig = 0 />
	<cfset variables.TimedCache = 0 />
	<cfset variables.FortuneWebService = 0 />
	
	<cffunction name="init" access="public" hint="I configure and return this cfc" output="false" returntype="FortuneFacade">
		<cfargument name="FortuneConfig" hint="I am the FortuneConfig Bean" required="yes" type="reactorSamples.Blog.model.config.fortuneConfig" />
		<cfargument name="TimedCache" hint="I am the TimedCache to use.  I reinit this." required="yes" type="modelglue.util.timedCache" />
		
		<cfset setFortuneConfig(arguments.FortuneConfig) />
		<cfset setTimedCache(arguments.TimedCache.init(CreateTimeSpan(0,0,0,15))) />
		<cfset setFortuneWebService(CreateObject("webservice", "http://www.doughughes.net/WebServices/fortune/fortune.cfc?wsdl")) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- getFortune --->
	<cffunction name="getFortune" access="public" hint="I get a fortune" output="false" returntype="string">
		<cfset var Cache = getTimedCache() />
		<cfset var Config = getFortuneConfig() />
		<cfset var Fortune = getFortuneWebService() />
		
		<!--- check to see if we have a cached fortune --->
		<cfif NOT Cache.exists("fortune")>	
			<!--- is not, try to get one --->	
			<cftry>
				<cfset Cache.setValue("fortune", Fortune.getFortune(Config.getTopicList(), Config.getMinLength(), Config.getMaxLength())) />
				<cfcatch>
					<!--- if there were errors just set a default fortune --->
					<cfset Cache.setValue("fortune", "D'oh!") />
				</cfcatch>
			</cftry>
		</cfif>
		
		<!--- return the cached fortune --->
		<cfreturn Cache.getValue("fortune") />

	</cffunction>

	<!--- fortuneConfig --->
    <cffunction name="setFortuneConfig" access="private" output="false" returntype="void">
       <cfargument name="fortuneConfig" hint="I am the FortuneConfig Bean" required="yes" type="reactorSamples.Blog.model.config.fortuneConfig" />
       <cfset variables.fortuneConfig = arguments.fortuneConfig />
    </cffunction>
    <cffunction name="getFortuneConfig" access="private" output="false" returntype="reactorSamples.Blog.model.config.fortuneConfig">
       <cfreturn variables.fortuneConfig />
    </cffunction>
	
	<!--- timedCache --->
    <cffunction name="setTimedCache" access="private" output="false" returntype="void">
       <cfargument name="timedCache" hint="I am the TimedCache to use. " required="yes" type="modelglue.util.timedCache" />
       <cfset variables.timedCache = arguments.timedCache />
    </cffunction>
    <cffunction name="getTimedCache" access="private" output="false" returntype="modelglue.util.timedCache">
       <cfreturn variables.timedCache />
    </cffunction>
	
	<!--- fortune --->
    <cffunction name="setFortuneWebService" access="private" output="false" returntype="void">
       <cfargument name="fortuneWebService" hint="I am the fortune web service" required="yes" type="any" />
       <cfset variables.fortuneWebService = arguments.fortuneWebService />
    </cffunction>
    <cffunction name="getFortuneWebService" access="private" output="false" returntype="any">
       <cfreturn variables.fortuneWebService />
    </cffunction>
</cfcomponent>