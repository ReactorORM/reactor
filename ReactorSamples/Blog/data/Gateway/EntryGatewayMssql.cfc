
<cfcomponent hint="I am the mssql custom Gateway object for the Entry table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="EntryGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	
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
				u.firstName, u.lastName, e.disableComments,
				
				count(DISTINCT m.commentId) as commentCount,				
				IsNull(Round(sum(r.rating)/Convert(float, count(e.entryId)), 0), 0) as averageRating
				
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
				u.firstName, u.lastName, e.disableComments
			ORDER BY e.publicationDate DESC
		</cfquery>
		
		<cfreturn entries />
	</cffunction>
	
	<cffunction name="getHighestRatedEntries" access="public" hint="I return the highest rated entries"  output="false" returntype="query">
		<cfargument name="limit" hint="I am the maximum number of entries to return" required="yes" type="numeric" />
		<cfset var qHighest = 0 />
		
		<cfquery name="qHighest" datasource="#_getConfig().getDsn()#">
			SELECT TOP #limit# e.entryId, e.title, IsNull(sum(r.rating)/Convert(float, count(e.entryId)), 0) as averageRating
			FROM Entry as e JOIN Rating as r
				ON e.entryId = r.entryId
			GROUP BY e.entryId, e.title
			ORDER BY averageRating DESC
		</cfquery>
		
		<cfreturn qHighest />
	</cffunction>
	
	<cffunction name="GetMostViewedEntries" access="public" hint="I return the most viewed entries"  output="false" returntype="query">
		<cfargument name="limit" hint="I am the maximum number of entries to return" required="yes" type="numeric" />
		<cfset var qViews = 0 />
		
		<cfquery name="qViews" datasource="#_getConfig().getDsn()#">
			SELECT TOP #limit# e.entryId, e.title, e.views
			FROM Entry as e
			ORDER BY e.views DESC
		</cfquery>
		
		<cfreturn qViews />
	</cffunction>
	
	<cffunction name="GetMostCommentedOn" access="public" hint="I return the most commented on entries"  output="false" returntype="query">
		<cfargument name="limit" hint="I am the maximum number of entries to return" required="yes" type="numeric" />
		<cfset var qComments = 0 />
		
		<cfquery name="qComments" datasource="#_getConfig().getDsn()#">
			SELECT TOP #limit# e.entryId, e.title, count(c.commentId) as comments
			FROM Entry as e JOIN Comment as c
				ON e.entryId = c.entryId
			GROUP BY e.entryId, e.title
			ORDER BY comments DESC
		</cfquery>
		
		<cfreturn qComments />
	</cffunction>
		
</cfcomponent>
	
