<cfcomponent displayname="fortuneConfig" hint="I am a config bean for the fortune web service.">
	
	<cfset variables.topicList = "" />
	<cfset variables.minLength = 0 />
	<cfset variables.maxLength = 0 />
	
	<cffunction name="init" access="public" hint="I configure and return the blogConfig" output="false" returntype="fortuneConfig">
		<cfargument name="topicList" hint="A comma delimited list of topics to restrict the fortune to. Use an empty string to use all topics." required="no" type="string" default="" />
		<cfargument name="minLength" hint="The minimum length of the fortune to return. Use 0 to allow any length." required="no" type="numeric" default="0" />
		<cfargument name="maxLength" hint="The maximum length of the fortune to return. Use 0 to allow any length." required="no" type="numeric" default="0" />
		
		<cfset setTopicList(arguments.topicList) />
		<cfset setMinLength(arguments.minLength) />
		<cfset setMaxLength(arguments.maxLength) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- topicList --->
    <cffunction name="setTopicList" access="public" output="false" returntype="void">
       <cfargument name="topicList" hint="A comma delimited list of topics to restrict the fortune to. Use an empty string to use all topics." required="yes" type="string" />
       <cfset variables.topicList = arguments.topicList />
    </cffunction>
    <cffunction name="getTopicList" access="public" output="false" returntype="string">
       <cfreturn variables.topicList />
    </cffunction>
	
	<!--- minLength --->
    <cffunction name="setMinLength" access="public" output="false" returntype="void">
       <cfargument name="minLength" hint="The minimum length of the fortune to return. Use 0 to allow any length." required="yes" type="numeric" />
       <cfset variables.minLength = arguments.minLength />
    </cffunction>
    <cffunction name="getMinLength" access="public" output="false" returntype="numeric">
       <cfreturn variables.minLength />
    </cffunction>
	
	<!--- maxLength --->
    <cffunction name="setMaxLength" access="public" output="false" returntype="void">
       <cfargument name="maxLength" hint="The maximum length of the fortune to return. Use 0 to allow any length." required="yes" type="numeric" />
       <cfset variables.maxLength = arguments.maxLength />
    </cffunction>
    <cffunction name="getMaxLength" access="public" output="false" returntype="numeric">
       <cfreturn variables.maxLength />
    </cffunction>
</cfcomponent>