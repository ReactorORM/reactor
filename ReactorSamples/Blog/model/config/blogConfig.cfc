<cfcomponent displayname="blogConfig" hint="I am a config bean for the blog app.">
	
	<cfset variables.blogTitle = "" />
	<cfset variables.baseUrl = "" />
	<cfset variables.blogDescription = "" />
	<cfset variables.authorEmailAddress = "" />
	<cfset variables.authorName = "" />
	<cfset variables.recentEntryDays = 0 />
	<cfset variables.useCaptcha = false />
	<cfset variables.captchaKey = "" />
	<cfset variables.pingUrlArray = ArrayNew(1) />
	<cfset variables.blogSearchCollection = "" />
	<cfset variables.additionalCollectonsList = "" />
	<cfset variables.recentEntryCount = 0 />
	<cfset variables.showFriendlyErrors = false />
	
	<cffunction name="init" access="public" hint="I configure and return the blogConfig" output="false" returntype="blogConfig">
		<cfargument name="blogTitle" hint="I am the title of the blog." required="no" type="string" default="" />
		<cfargument name="baseUrl" hint="I am the base url of the blog." required="no" type="string" default="" />
		<cfargument name="blogDescription" hint="I am the description of the blog" required="no" type="string" default="" />
		<cfargument name="authorEmailAddress" hint="I am the author's email address" required="no" type="string" default="" />
		<cfargument name="authorName" hint="I am the author's name" required="no" type="string" default="" />
		<cfargument name="recentEntryDays" hint="I am the number of days an entry is shown on the home page." required="no" type="numeric" default="0" />
		<cfargument name="useCaptcha" hint="I indicate if captcha images should be displayed." required="no" type="boolean" default="false" />
		<cfargument name="captchaKey" hint="I am the license key to use with the Alagad Captcah component wehn useCaptcha is true." required="no" type="string" default="" />
		<cfargument name="pingUrlArray" hint="I am an array of URLs which should be pinged when new entries are added." required="no" type="array" default="#ArrayNew(1)#" />
		<cfargument name="blogSearchCollection" hint="I the name of the verity collection that will be indexed / searched" required="no" type="string" default="" />
		<cfargument name="additionalCollectonsList" hint="I am a comma sepeated list of other collections to search when a search is executed." required="no" type="string" default="" />
		<cfargument name="recentEntryCount" hint="I am the number of recent entries to show." required="no" type="numeric" default="0" />
		<cfargument name="showFriendlyErrors" hint="I indicate if friendly errors should be shown" required="no" type="boolean" default="false" />
		
		<cfset setBlogTitle(arguments.blogTitle) />
		<cfset setBaseUrl(arguments.baseUrl) />
		<cfset setBlogDescription(arguments.blogDescription) />
		<cfset setAuthorEmailAddress(arguments.authorEmailAddress) />
		<cfset setAuthorName(arguments.authorName) />
		<cfset setRecentEntryDays(arguments.recentEntryDays) />
		<cfset setUseCaptcha(arguments.useCaptcha) />
		<cfset setCaptchaKey(arguments.captchaKey) />
		<cfset setPingUrlArray(arguments.pingUrlArray) />
		<cfset setBlogSearchCollection(arguments.blogSearchCollection) />
		<cfset setAdditionalCollectonsList(arguments.additionalCollectonsList) />
		<cfset setRecentEntryCount(arguments.recentEntryCount) />
		<cfset setShowFriendlyErrors(arguments.showFriendlyErrors) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- searchEnabled --->
	<cffunction name="searchEnabled" access="public" hint="I indicate if search is configured" output="false" returntype="boolean">
		<cfreturn Len(getBlogSearchCollection()) />
	</cffunction>
	
	<!--- blogTitle --->
    <cffunction name="setBlogTitle" access="public" output="false" returntype="void">
       <cfargument name="blogTitle" hint="I am the title of the blog." required="yes" type="string" />
       <cfset variables.blogTitle = arguments.blogTitle />
    </cffunction>
    <cffunction name="getBlogTitle" access="public" output="false" returntype="string">
       <cfreturn variables.blogTitle />
    </cffunction>
	
	<!--- baseUrl --->
    <cffunction name="setBaseUrl" access="public" output="false" returntype="void">
       <cfargument name="baseUrl" hint="I am the base url of the blog." required="yes" type="string" />
       <cfset variables.baseUrl = arguments.baseUrl />
    </cffunction>
    <cffunction name="getBaseUrl" access="public" output="false" returntype="string">
       <cfreturn variables.baseUrl />
    </cffunction>
	
	<!--- blogDescription --->
    <cffunction name="setBlogDescription" access="public" output="false" returntype="void">
       <cfargument name="blogDescription" hint="I am the description of the blog" required="yes" type="string" />
       <cfset variables.blogDescription = arguments.blogDescription />
    </cffunction>
    <cffunction name="getBlogDescription" access="public" output="false" returntype="string">
       <cfreturn variables.blogDescription />
    </cffunction>
	
	<!--- authorEmailAddress --->
    <cffunction name="setAuthorEmailAddress" access="public" output="false" returntype="void">
       <cfargument name="authorEmailAddress" hint="I am the author's email address" required="yes" type="string" />
       <cfset variables.authorEmailAddress = arguments.authorEmailAddress />
    </cffunction>
    <cffunction name="getAuthorEmailAddress" access="public" output="false" returntype="string">
       <cfreturn variables.authorEmailAddress />
    </cffunction>
	
	<!--- authorName --->
    <cffunction name="setAuthorName" access="public" output="false" returntype="void">
       <cfargument name="authorName" hint="I am the author's name" required="yes" type="string" />
       <cfset variables.authorName = arguments.authorName />
    </cffunction>
    <cffunction name="getAuthorName" access="public" output="false" returntype="string">
       <cfreturn variables.authorName />
    </cffunction>
	
	<!--- recentEntryDays --->
    <cffunction name="setRecentEntryDays" access="public" output="false" returntype="void">
       <cfargument name="recentEntryDays" hint="I am the number of days an entry is shown on the home page." required="yes" type="numeric" />
       <cfset variables.recentEntryDays = arguments.recentEntryDays />
    </cffunction>
    <cffunction name="getRecentEntryDays" access="public" output="false" returntype="numeric">
       <cfreturn variables.recentEntryDays />
    </cffunction>
	
	<!--- useCaptcha --->
    <cffunction name="setUseCaptcha" access="public" output="false" returntype="void">
       <cfargument name="useCaptcha" hint="I indicate if captcha images should be displayed." required="yes" type="boolean" />
       <cfset variables.useCaptcha = arguments.useCaptcha />
    </cffunction>
    <cffunction name="getUseCaptcha" access="public" output="false" returntype="boolean">
       <cfreturn variables.useCaptcha />
    </cffunction>

	<!--- captchaKey --->
    <cffunction name="setCaptchaKey" access="public" output="false" returntype="void">
       <cfargument name="captchaKey" hint="I am the license key to use with the Alagad Captcah component wehn useCaptcha is true." required="yes" type="string" />
       <cfset variables.captchaKey = arguments.captchaKey />
    </cffunction>
    <cffunction name="getCaptchaKey" access="public" output="false" returntype="string">
       <cfreturn variables.captchaKey />
    </cffunction>
	
	<!--- pingUrlArray --->
    <cffunction name="setPingUrlArray" access="public" output="false" returntype="void">
       <cfargument name="pingUrlArray" hint="I am an array of URLs which should be pinged when new entries are added." required="yes" type="array" />
       <cfset variables.pingUrlArray = arguments.pingUrlArray />
    </cffunction>
    <cffunction name="getPingUrlArray" access="public" output="false" returntype="array">
       <cfreturn variables.pingUrlArray />
    </cffunction>
	
	<!--- blogSearchCollection --->
    <cffunction name="setBlogSearchCollection" access="public" output="false" returntype="void">
       <cfargument name="blogSearchCollection" hint="I the name of the verity collection that will be indexed / searched" required="yes" type="string" />
       <cfset variables.blogSearchCollection = arguments.blogSearchCollection />
    </cffunction>
    <cffunction name="getBlogSearchCollection" access="public" output="false" returntype="string">
       <cfreturn variables.blogSearchCollection />
    </cffunction>
	
	<!--- additionalCollectonsList --->
    <cffunction name="setAdditionalCollectonsList" access="public" output="false" returntype="void">
       <cfargument name="additionalCollectonsList" hint="I am a comma sepeated list of other collections to search when a search is executed." required="yes" type="string" />
       <cfset variables.additionalCollectonsList = arguments.additionalCollectonsList />
    </cffunction>
    <cffunction name="getAdditionalCollectonsList" access="public" output="false" returntype="string">
       <cfreturn variables.additionalCollectonsList />
    </cffunction>
	
	<!--- recentEntryCount --->
    <cffunction name="setRecentEntryCount" access="public" output="false" returntype="void">
       <cfargument name="recentEntryCount" hint="I am the number of recent entries to show." required="yes" type="string" />
       <cfset variables.recentEntryCount = arguments.recentEntryCount />
    </cffunction>
    <cffunction name="getRecentEntryCount" access="public" output="false" returntype="string">
       <cfreturn variables.recentEntryCount />
    </cffunction>
	
	<!--- showFriendlyErrors --->
    <cffunction name="setShowFriendlyErrors" access="public" output="false" returntype="void">
       <cfargument name="showFriendlyErrors" hint="I indicate if friendly errors should be shown" required="yes" type="string" />
       <cfset variables.showFriendlyErrors = arguments.showFriendlyErrors />
    </cffunction>
    <cffunction name="getShowFriendlyErrors" access="public" output="false" returntype="string">
       <cfreturn variables.showFriendlyErrors />
    </cffunction>
</cfcomponent>