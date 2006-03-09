
<cfcomponent hint="I am the db2 custom Gateway object for the Entry object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="EntryGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="getMatching" access="public" hint="I return an array of matching blog entries records." output="false" returntype="query">
		<cfargument name="categoryId" hint="I am a category to match" required="yes" type="numeric" default="0" />
		<cfargument name="month" hint="I am a month to filter for" required="yes" type="numeric" default="0" />
		<cfargument name="year" hint="I am a year to filter for" required="yes" type="numeric" default="0" />
		<cfset var entries = 0 />
		
		<cfquery name="entries" datasource="#_getConfig().getDsn()#">
			SELECT e."entryId", e."title", e."preview",
				CHAR(MONTH(e."publicationDate")) || '/' || CHAR(DAY(e."publicationDate")) || '/' || CHAR(YEAR(e."publicationDate")) as "publicationDate",
				e."publicationDate" as "publicationDateTime",
				e."views", c."categoryId", c."name" as "categoryName", 
				u."firstName", u."lastName", e."disableComments",
				
				count(DISTINCT m."commentID") as "commentCount",
				CASE 
					WHEN e."timesRated" = 0 THEN 0
					ELSE ROUND(e."totalRating"/e."timesRated", 0)
				END as averageRating
				
			FROM "NULLID"."Entry" as e LEFT JOIN "NULLID"."EntryCategory" as ec
				ON e."entryId" = ec."entryId"
			LEFT JOIN "NULLID"."Category" as c
				ON ec."categoryId" = c."categoryId"
			JOIN "NULLID"."User" as u
				ON e."postedByUserId" = u."userId"
			LEFT JOIN "NULLID"."Comment" as m
				ON e."entryId" = m."entryId"
			
			WHERE e."publicationDate" <= current timestamp
				<!--- filter by categoryId --->
				<cfif arguments.categoryId>
					AND c."categoryId" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.categoryId#" />
				</cfif>
				<!--- filter by date --->
				<cfif arguments.month>
					AND MONTH(e."publicationDate") = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.month#" />
				</cfif>
				<cfif arguments.year>
					AND YEAR(e."publicationDate") = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.year#" />
				</cfif>
				<cfif NOT arguments.categoryId AND NOT arguments.month AND NOT arguments.year>
					AND timestampdiff(16, char(e."publicationDate" - current timestamp)) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.recentEntryDays#" />
				</cfif>
			GROUP BY e."entryId", e."title", e."preview", 
				CHAR(MONTH(e."publicationDate")) || '/' || CHAR(DAY(e."publicationDate")) || '/' || CHAR(YEAR(e."publicationDate")),
				e."publicationDate",
				e."views", c."categoryId", c."name", 
				u."firstName", u."lastName", e."disableComments",
				CASE 
					WHEN e."timesRated" = 0 THEN 0
					ELSE ROUND(e."totalRating"/e."timesRated", 0)
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
				ELSE ROUND(e."totalRating"/e."timesRated", 0)
			END as averageRating
			FROM "NULLID"."Entry" as e
			ORDER BY 
			CASE 
				WHEN e."timesRated" = 0 THEN 0
				ELSE ROUND(e."totalRating"/e."timesRated", 0)
			END DESC
			FETCH FIRST #limit# ROWS ONLY
			OPTIMIZE FOR #limit# ROWS
		</cfquery>
		
		<cfreturn qHighest />
	</cffunction>
	
	<cffunction name="GetMostViewedEntries" access="public" hint="I return the most viewed entries"  output="false" returntype="query">
		<cfargument name="limit" hint="I am the maximum number of entries to return" required="yes" type="numeric" />
		<cfset var qViews = 0 />
		
		<cfquery name="qViews" datasource="#_getConfig().getDsn()#">
			SELECT e."entryId", e."title", e."views"
			FROM "NULLID"."Entry" as e
			ORDER BY e."views" DESC
			FETCH FIRST #limit# ROWS ONLY
			OPTIMIZE FOR #limit# ROWS
		</cfquery>
		
		<cfreturn qViews />
	</cffunction>
	
	<cffunction name="GetMostCommentedOn" access="public" hint="I return the most commented on entries"  output="false" returntype="query">
		<cfargument name="limit" hint="I am the maximum number of entries to return" required="yes" type="numeric" />
		<cfset var qComments = 0 />
		
		<cfquery name="qComments" datasource="#_getConfig().getDsn()#">
			SELECT e."entryId", e."title", count(c."commentID") as "comments"
			FROM "NULLID"."Entry" as e JOIN "NULLID"."Comment" as c
				ON e."entryId" = c."entryId"
			GROUP BY e."entryId", e."title"
			ORDER BY count(c."commentID") DESC
			FETCH FIRST #limit# ROWS ONLY
			OPTIMIZE FOR #limit# ROWS
		</cfquery>
		
		<cfreturn qComments />
	</cffunction>
	
	<cffunction name="getArchives" access="public" hint="I return a query of months, years and number of entries." output="false" returntype="query">
		<cfset var archvies = 0 />
		
		<cfquery name="archives" datasource="#_getConfig().getDsn()#" cachedwithin="#CreateTimespan(0, 0, 1, 0)#">
			SELECT MONTH("publicationDate") as month, YEAR("publicationDate") as year, count("entryId") as "entryCount"
			FROM "NULLID"."Entry"
			GROUP BY MONTH("publicationDate"), YEAR("publicationDate")
			ORDER BY YEAR("publicationDate") desc, MONTH("publicationDate") desc
		</cfquery>
		
		<cfreturn archives />
	</cffunction>
</cfcomponent>
	
