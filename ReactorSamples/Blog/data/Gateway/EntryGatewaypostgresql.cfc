
<cfcomponent hint="I am the postgresql custom Gateway object for the Entry table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="EntryGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	<cffunction name="getArchives" access="public" hint="I return a query of months, years and number of entries." output="false" returntype="query">
		<cfset var archvies = 0 />
		
		<cfquery name="archives" datasource="#_getConfig().getDsn()#" cachedwithin="#CreateTimespan(0, 0, 1, 0)#">
			SELECT EXTRACT(MONTH FROM "publicationDate") as month, EXTRACT(YEAR FROM "publicationDate") as year, count("entryId") as entryCount
			FROM "Entry"
			GROUP BY EXTRACT(MONTH FROM "publicationDate"), EXTRACT(YEAR FROM "publicationDate")
			ORDER BY EXTRACT(YEAR FROM "publicationDate") desc, EXTRACT(MONTH FROM "publicationDate") desc
		</cfquery>
		
		<cfreturn archives />
	</cffunction>
	
	
	<cffunction name="getMatching" access="public" hint="I return an array of matching blog entries records." output="false" returntype="query">
		<cfargument name="categoryId" hint="I am a category to match" required="yes" type="numeric" default="0" />
		<cfargument name="month" hint="I am a month to filter for" required="yes" type="numeric" default="0" />
		<cfargument name="year" hint="I am a year to filter for" required="yes" type="numeric" default="0" />
		<cfset var entries = 0 />
		
		<cfquery name="entries" datasource="#_getConfig().getDsn()#">
			SELECT e."entryId", e."title", e."preview",
				CAST(EXTRACT(MONTH FROM e."publicationDate") AS varchar(2)) || '/'::varchar || CAST(EXTRACT(DAY FROM e."publicationDate") AS varchar(2)) || '/'::varchar || CAST(EXTRACT(YEAR FROM e."publicationDate") AS varchar(4)) as publicationDate,
				e."publicationDate" as publicationDateTime,
				e."views", c."categoryId", c."name" as categoryName, 
				u."firstName", u."lastName", e."disableComments",
				count(DISTINCT m."commentId") as commentCount,		
				count(e."entryId") as temp1,
				
				CASE
					WHEN e."timesRated" = 0 THEN 0
					ELSE (e."totalRating"/Cast(e."timesRated" AS float))::float
				END AS averageRating		
				
			FROM "Entry" as e LEFT JOIN "EntryCategory" as ec
				ON e."entryId" = ec."entryId"
			LEFT JOIN "Category" as c
				ON ec."categoryId" = c."categoryId"
			JOIN "User" as u
				ON e."postedByUserId" = u."userId"
			LEFT JOIN "Comment" as m
				ON e."entryId" = m."entryId"
				
			WHERE e."publicationDate" <= now()
				<!--- filter by categoryId --->
				<cfif arguments.categoryId>
					AND c."categoryId" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.categoryId#" />
				</cfif>
				<!--- filter by date --->
				<cfif arguments.month>
					AND EXTRACT(MONTH FROM e."publicationDate") = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.month#" />
				</cfif>
				<cfif arguments.year>
					AND EXTRACT(YEAR FROM e."publicationDate") = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.year#" />
				</cfif>
				<cfif NOT arguments.categoryId AND NOT arguments.month AND NOT arguments.year>
					AND (e."publicationDate"::date - now()::date)::integer <= <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.recentEntryDays#" />
				</cfif>
			GROUP BY e."entryId", e."title", e."preview", 
				CAST(EXTRACT(MONTH FROM e."publicationDate") AS varchar(2)) || '/'::varchar || CAST(EXTRACT(DAY FROM e."publicationDate") AS varchar(2)) || '/'::varchar || CAST(EXTRACT(YEAR FROM e."publicationDate") AS varchar(4)),
				e."publicationDate",
				e."views", c."categoryId", c."name", 
				u."firstName", u."lastName", e."disableComments",
				CASE
					WHEN e."timesRated" = 0 THEN 0
					ELSE (e."totalRating"/Cast(e."timesRated" AS float))::float
				END
			ORDER BY e."publicationDate" DESC
		</cfquery>
		
		<cfreturn entries />
	</cffunction>
	
	<cffunction name="getHighestRatedEntries" access="public" hint="I return the highest rated entries"  output="false" returntype="query">
		<cfargument name="limit" hint="I am the maximum number of entries to return" required="yes" type="numeric" />
		<cfset var qHighest = 0 />
		
		<cfquery name="qHighest" datasource="#_getConfig().getDsn()#">
			SELECT e."entryId", e."title", 
			CASE
				WHEN e."timesRated" = 0 THEN 0
				ELSE (e."totalRating"/Cast(e."timesRated" AS float))::float
			END AS averageRating
			FROM "Entry" as e
			ORDER BY averageRating DESC
			limit #limit#
		</cfquery>
		
		<cfreturn qHighest />
	</cffunction>
	
	<cffunction name="GetMostViewedEntries" access="public" hint="I return the most viewed entries"  output="false" returntype="query">
		<cfargument name="limit" hint="I am the maximum number of entries to return" required="yes" type="numeric" />
		<cfset var qViews = 0 />
		
		<cfquery name="qViews" datasource="#_getConfig().getDsn()#">
			SELECT e."entryId", e."title", e."views"
			FROM "Entry" as e
			ORDER BY e."views" DESC
			LIMIT #limit#
		</cfquery>
		
		<cfreturn qViews />
	</cffunction>
	
	<cffunction name="GetMostCommentedOn" access="public" hint="I return the most commented on entries"  output="false" returntype="query">
		<cfargument name="limit" hint="I am the maximum number of entries to return" required="yes" type="numeric" />
		<cfset var qComments = 0 />
		
		<cfquery name="qComments" datasource="#_getConfig().getDsn()#">
			SELECT e."entryId", e."title", count(c."commentId") as comments
			FROM "Entry" as e JOIN "Comment" as c
				ON e."entryId" = c."entryId"
			GROUP BY e."entryId", e."title"
			ORDER BY comments DESC
			LIMIT #limit#
		</cfquery>
		
		<cfreturn qComments />
	</cffunction>
	
</cfcomponent>
	
