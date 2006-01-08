<cfcomponent>
	
	<cfset variables.primaryCollection = "" />
	<cfset variables.additionalCollectonsList = "" />
	
	<cffunction name="init" access="public" hint="I configure and return the search component" output="false" returntype="Search">
		<cfargument name="primaryCollection" hint="I am the collection to index and search" required="yes" type="string" />
		<cfargument name="additionalCollectonsList" hint="I am a comma seperated list of additional collections to search" required="yes" type="string" />
		
		<cfset setPrimaryCollection(arguments.primaryCollection) />
		<cfset setAdditionalCollectonsList(replace(arguments.additionalCollectonsList, ",", " ", "all")) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- index --->
	<cffunction name="index" access="public" hint="I index the provided string" output="false" returntype="void">
		<cfargument name="url" hint="I am the data being indexed. (This will be deleted and recreated.)" required="yes" type="string" />
		<cfargument name="title" hint="I am the title use when indexing." required="yes" type="string" />
		<cfargument name="body" hint="I am the body of the item being indexed." required="yes" type="string" />
		<cfset arguments.body = ReReplace(arguments.body, "<[^<]+?>", "", "all") />
		
		<!--- index the data --->
		<cfindex action="update"
			key="#arguments.url#"
			type="custom"
			URLpath="#arguments.url#"
			title="#arguments.title#"
			body="#arguments.body#"
			collection="#getPrimaryCollection()#" />
		
	</cffunction>
	
	<!--- indexQuery --->
	<cffunction name="indexQuery" access="public" hint="I index the provided query" output="false" returntype="void">
		<cfargument name="query" hint="I am the query to index. (must have url, title and body fields.)" required="yes" type="query" />
		
		<cfindex action="update"
			query="arguments.query"
			key="url"
			body="body"
			URLpath="url"
			title="title"
			collection="#getPrimaryCollection()#" />
		
	</cffunction>
	
	<!--- search --->
	<cffunction name="search" access="public" hint="I search for the string" output="false" returntype="struct">
		<cfargument name="criteria" hint="I am the criteria to search for" required="yes" type="string" />
		<cfset var status = StructNew() />
		
		<cfsearch name="status.matches"
			type="natural"
			collection="#getPrimaryCollection()# #getAdditionalCollectonsList()#"
			criteria="#arguments.criteria#"
			contextPassages="2"
			suggestions="always"
			status="status"
			maxrows="20" />
		
		<cfreturn status />	
	</cffunction>
	
	<!--- empty --->
	<cffunction name="empty" access="public" hint="I empty the search catalog" output="false" returntype="void">
		<cfindex action="purge" collection="#getPrimaryCollection()#" />
	</cffunction>
	
	<!--- primaryCollection --->
    <cffunction name="setPrimaryCollection" access="private" output="false" returntype="void">
       <cfargument name="primaryCollection" hint="I am the collection to index and search" required="yes" type="string" />
       <cfset variables.primaryCollection = arguments.primaryCollection />
    </cffunction>
    <cffunction name="getPrimaryCollection" access="private" output="false" returntype="string">
       <cfreturn variables.primaryCollection />
    </cffunction>
	
	<!--- additionalCollectonsList --->
    <cffunction name="setAdditionalCollectonsList" access="private" output="false" returntype="void">
       <cfargument name="additionalCollectonsList" hint="I am a comma seperated list of additional collections to search" required="yes" type="string" />
       <cfset variables.additionalCollectonsList = arguments.additionalCollectonsList />
    </cffunction>
    <cffunction name="getAdditionalCollectonsList" access="private" output="false" returntype="string">
       <cfreturn variables.additionalCollectonsList />
    </cffunction>
	
</cfcomponent>