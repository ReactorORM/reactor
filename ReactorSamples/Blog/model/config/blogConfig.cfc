<cfcomponent displayname="blogConfig" hint="I am a config bean for the blog app.">
	
	<cfset variables.blogTitle = "" />
	<cfset variables.entriesPerPage = 0 />
	
	<cffunction name="init" access="public" hint="I configure and return the blogConfig" output="false" returntype="blogConfig">
		<cfargument name="blogTitle" hint="I am the title of the blog." required="no" type="string" default="" />
		<cfargument name="entriesPerPage" hint="I am the number of entries to show per page." required="no" type="numeric" default="0" />
		
		<cfset setBlogTitle(arguments.blogTitle) />
		<cfset setEntriesPerPage(arguments.entriesPerPage) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- blogTitle --->
    <cffunction name="setBlogTitle" access="public" output="false" returntype="void">
       <cfargument name="blogTitle" hint="I am the title of the blog." required="yes" type="string" />
       <cfset variables.blogTitle = arguments.blogTitle />
    </cffunction>
    <cffunction name="getBlogTitle" access="public" output="false" returntype="string">
       <cfreturn variables.blogTitle />
    </cffunction>
	
	<!--- entriesPerPage --->
    <cffunction name="setEntriesPerPage" access="public" output="false" returntype="void">
       <cfargument name="entriesPerPage" hint="I am the number of entries per page." required="yes" type="numeric" />
       <cfset variables.entriesPerPage = arguments.entriesPerPage />
    </cffunction>
    <cffunction name="getEntriesPerPage" access="public" output="false" returntype="numeric">
       <cfreturn variables.entriesPerPage />
    </cffunction>

</cfcomponent>