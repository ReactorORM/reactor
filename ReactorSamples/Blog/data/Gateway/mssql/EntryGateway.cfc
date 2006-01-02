
<cfcomponent hint="I am the custom Gateway object for the  table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="ReactorBlogData.Gateway.mssql.base.EntryGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cfset variables.recentEntryDays = 0 />
	
	<cffunction name="init" access="public" hint="I configure and return the WntryGateway" output="false" returntype="EntryGateway">
		<cfargument name="recentEntryDays" hint="I am the number of days an entry is recent." required="yes" type="numeric" />
		<cfset variables.recentEntryDays = arguments.recentEntryDays />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getMatching" access="public" hint="I return an array of matching blog entries records." output="false" returntype="query">
		<cfargument name="categoryId" hint="I am a category to match" required="yes" type="numeric" default="0" />
		<cfargument name="month" hint="I am a month to filter for" required="yes" type="numeric" default="0" />
		<cfargument name="year" hint="I am a year to filter for" required="yes" type="numeric" default="0" />
		<cfset var entries = 0 />
		
		<cfquery name="entries" datasource="#_getConfig().getDsn()#">
			SELECT e.entryId, e.title, e.preview,
				CONVERT(varchar(2), MONTH(e.publicationDate)) + '/' + CONVERT(varchar(2), DAY(e.publicationDate)) + '/' + CONVERT(varchar(4), YEAR(e.publicationDate)) as publicationDate,
				e.publicationDate as publicationDateTime,
				e.views, c.categoryId, c.name as categoryName, 
				u.firstName, u.lastName,
				
				count(DISTINCT m.commentId) as commentCount,
				dbo.getAverageRating(e.entryId) as averageRating
				
			FROM Entry as e LEFT JOIN EntryCategory as ec
				ON e.entryId = ec.entryId
			LEFT JOIN Category as c
				ON ec.categoryId = c.categoryId
			JOIN [User] as u
				ON e.postedByUserId = u.userID
			LEFT JOIN Comment as m
				ON e.entryId = m.entryId
			LEFT JOIN Rating as r
				ON e.entryId = r.entryId
			
			WHERE e.publicationDate <= getDate()
				<!--- filter by categoryId --->
				<cfif arguments.categoryId>
					AND c.categoryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.categoryId#" />
				</cfif>
				<!--- filter by date --->
				<cfif arguments.month>
					AND MONTH(e.publicationDate) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.month#" />
				</cfif>
				<cfif arguments.year>
					AND YEAR(e.publicationDate) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.year#" />
				</cfif>
				<cfif NOT arguments.categoryId AND NOT arguments.month AND NOT arguments.year>
					AND DateDiff(d, e.publicationDate, getdate()) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.recentEntryDays#" />
				</cfif>
			GROUP BY e.entryId, e.title, e.preview, 
				CONVERT(varchar(2), MONTH(e.publicationDate)) + '/' + CONVERT(varchar(2), DAY(e.publicationDate)) + '/' + CONVERT(varchar(4), YEAR(e.publicationDate)),
				e.publicationDate,
				e.views, c.categoryId, c.name, 
				u.firstName, u.lastName 
			ORDER BY e.publicationDate DESC
		</cfquery>
		
		<cfreturn entries />
	</cffunction>
	
	<cffunction name="getRecentEntries" access="public" hint="I return a query of recent entries." output="false" returntype="query">
		<cfargument name="count" hint="I am the number of recent entries to return" required="yes" type="numeric" />
		<cfset var EntryQuery = createQuery() />
		<cfset EntryQuery.setMaxRows(arguments.count) />
		<cfset EntryQuery.returnField("Entry", "entryId").returnField("Entry", "title") />
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
	
