<cfcomponent>
	
	<cfset variables.pingUrlArray = ArrayNew(1) />
	
	<cffunction name="init" access="public" hint="I configure and return the UrlPinger" output="false" returntype="UrlPinger">
		<cfargument name="pingUrlArray" hint="I am an array of URLs which should be pinged." required="no" type="array" default="#ArrayNew(1)#" />
	
		<cfset setPingUrlArray(arguments.pingUrlArray) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- ping --->
	<cffunction name="ping" access="public" hint="I ping the configured URLs" output="false" returntype="void">
		<cfset var urls = getPingUrlArray() />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(urls)#" index="x">
			<cfhttp url="#urls[x]#" timeout="0" />
		</cfloop>
	</cffunction>
	
	<!--- pingUrlArray --->
    <cffunction name="setPingUrlArray" access="private" output="false" returntype="void">
       <cfargument name="pingUrlArray" hint="I am an array of URLs which should be pinged when new entries are added." required="yes" type="array" />
       <cfset variables.pingUrlArray = arguments.pingUrlArray />
    </cffunction>
    <cffunction name="getPingUrlArray" access="private" output="false" returntype="array">
       <cfreturn variables.pingUrlArray />
    </cffunction>
	
</cfcomponent>