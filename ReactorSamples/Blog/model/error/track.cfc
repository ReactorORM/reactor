<cfcomponent hint="I am data tracked about a user's session.  For debugging purposes.">
	
	<cfset variables.url = "" />
	<cfset variables.time = now() />
	<cfset variables.method = "get" />
	<cfset variables.referrer = "" />
	<cfset variables.values = "" />
	
	<cffunction name="init" hint="I configure and return a track" output="false" returntype="track">
		<cfargument name="url" hint="I am the url the user visited" required="yes" type="string" />
		<cfargument name="method" hint="I am the method used to get the url.  (Get or Post)" required="yes" type="string" />
		<cfargument name="referrer" hint="I am where the user came from" required="yes" type="string" />
		<cfargument name="values" hint="I am the event values" required="yes" type="struct" />
		
		<cfset setUrl(arguments.url) />
		<cfset setMethod(arguments.method) />
		<cfset setReferrer(arguments.referrer) />
		<cfset setValues(arguments.values) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- url --->
    <cffunction name="setUrl" access="private" output="false" returntype="void">
       <cfargument name="url" hint="I am the url the user visited" required="yes" type="string" />
       <cfset variables.url = arguments.url />
    </cffunction>
    <cffunction name="getUrl" access="public" output="false" returntype="string">
       <cfreturn variables.url />
    </cffunction>
	
	<!--- time --->
    <cffunction name="getTime" access="public" output="false" returntype="date">
       <cfreturn variables.time />
    </cffunction>
	
	<!--- method --->
    <cffunction name="setMethod" access="private" output="false" returntype="void">
       <cfargument name="method" hint="I am the method used to get the url.  (Get or Post)" required="yes" type="string" />
       <cfset variables.method = arguments.method />
    </cffunction>
    <cffunction name="getMethod" access="public" output="false" returntype="string">
       <cfreturn variables.method />
    </cffunction>
	
	<!--- referrer --->
    <cffunction name="setReferrer" access="private" output="false" returntype="void">
       <cfargument name="referrer" hint="I am where the user came from" required="yes" type="string" />
       <cfset variables.referrer = arguments.referrer />
    </cffunction>
    <cffunction name="getReferrer" access="public" output="false" returntype="string">
       <cfreturn variables.referrer />
    </cffunction>
	
	<!--- values --->
    <cffunction name="setValues" access="public" output="false" returntype="void">
       <cfargument name="values" hint="I am the event values" required="yes" type="struct" />
       <cfset variables.values = arguments.values />
    </cffunction>
    <cffunction name="getValues" access="public" output="false" returntype="struct">
       <cfreturn variables.values />
    </cffunction>
	
</cfcomponent>