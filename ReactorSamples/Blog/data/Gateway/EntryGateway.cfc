
<cfcomponent hint="I am the database agnostic custom Gateway object for the Entry table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.ReactorBlog.Gateway.EntryGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cfset variables.recentEntryDays = 0 />
	
	<cffunction name="init" access="public" hint="I configure and return the WntryGateway" output="false" returntype="EntryGateway">
		<cfargument name="recentEntryDays" hint="I am the number of days an entry is recent." required="yes" type="numeric" />
		<cfset variables.recentEntryDays = arguments.recentEntryDays />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAuthor" access="public" hint="I return the author who created a record" output="false" returntype="query">
		<cfargument name="entryId" hint="I am the entryId to match" required="yes" type="numeric" default="0" />
		<cfset var EntryQuery = createQuery() />
		<cfset EntryQuery.join("Entry", "User") />
		<cfset EntryQuery.returnObjectFields("User") />
		<cfset EntryQuery.getWhere().isEqual("Entry", "entryId", arguments.entryId) />
		
		<cfreturn getByQuery(EntryQuery) />
	</cffunction>
	
	<cffunction name="getRecentEntries" access="public" hint="I return a query of recent entries." output="false" returntype="query">
		<cfargument name="count" hint="I am the number of recent entries to return" required="yes" type="numeric" />
		<cfset var EntryQuery = createQuery() />
		<cfset EntryQuery.setMaxRows(arguments.count) />
		<cfset EntryQuery.returnObjectField("Entry", "entryId").returnObjectField("Entry", "title") />
		<cfset EntryQuery.getOrder().setDesc("Entry", "publicationDate") />
		<cfreturn getByQuery(EntryQuery) />
	</cffunction>
	
	<cffunction name="getArchives" access="public" hint="I return a query of months, years and number of entries." output="false" returntype="query">
		<cfset var archvies = 0 />
		
		<cfquery name="archives" datasource="#_getConfig().getDsn()#" cachedwithin="#CreateTimespan(0, 0, 1, 0)#">
			SELECT MONTH(publicationDate) as month, YEAR(publicationDate) as year, count(entryId) as entryCount
			FROM Entry
			GROUP BY MONTH(publicationDate), YEAR(publicationDate)
			ORDER BY YEAR(publicationDate) desc, MONTH(publicationDate) desc
		</cfquery>
		
		<cfreturn archives />
	</cffunction>
	
</cfcomponent>
	
