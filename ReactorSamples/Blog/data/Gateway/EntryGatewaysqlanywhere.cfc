<cfcomponent hint="I am the sqlanywhere custom Gateway object for the Entry object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="EntryGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	<cffunction name="getArchives" access="public" hint="I return a query of months, years and number of entries." output="false" returntype="query">
		<cfset var archvies = 0 />

		<cfquery name="archives" datasource="#_getConfig().getDsn()#" cachedwithin="#CreateTimespan(0, 0, 1, 0)#">
			SELECT 	month("publicationDate")  as month,
					year("publicationDate")       as year,
					count( "entryId" )            as entryCount
			FROM "Entry"
			GROUP BY year("publicationDate"),
			 		     month("publicationDate")
			ORDER BY year("publicationDate")  desc,
				  	   month("publicationDate") desc
		</cfquery>

		<cfreturn archives />
	</cffunction>


	<cffunction name="getMatching" access="public" hint="I return an array of matching blog entries records." output="false" returntype="query">
		<cfargument name="categoryId" hint="I am a category to match"   required="yes" type="numeric" default="0" />
		<cfargument name="month"      hint="I am a month to filter for" required="yes" type="numeric" default="0" />
		<cfargument name="year"       hint="I am a year to filter for"  required="yes" type="numeric" default="0" />
		<cfset var entries = 0 />

		<cfquery name="entries" datasource="#_getConfig().getDsn()#">
			SELECT e."entryId",
                e."title",
	            e."preview",
				e."publicationDate" as publicationDate,
				e."publicationDate" as publicationDateTime,
				e."views",
				c."categoryId",
				c."name" as categoryName,
				u."firstName",
				u."lastName",
				e."disableComments",
				count(DISTINCT m."commentId") as commentCount,
				count(e."entryId") as temp1,

				CASE
					WHEN   e."timesRated" = 0 THEN 0
					ELSE ( e."totalRating"/e."timesRated" )
				END AS averageRating

			FROM "Entry" e LEFT JOIN "EntryCategory"  ec
				ON e."entryId" = ec."entryId"
			LEFT JOIN "Category"  c
				ON ec."categoryId" = c."categoryId"
			JOIN "User"  u
				ON e."postedByUserId" = u."userId"
			LEFT JOIN "Comment" m
				ON e."entryId" = m."entryId"

			WHERE e."publicationDate" <= getdate()
				<!--- filter by categoryId --->
				<cfif arguments.categoryId>
					AND c."categoryId" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.categoryId#" />
				</cfif>
				<!--- filter by date --->
				<cfif arguments.month>
					AND month(e."publicationDate") = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.month#" />
				</cfif>
				<cfif arguments.year>
					AND year(e."publicationDate") = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.year#" />
				</cfif>
				<cfif NOT arguments.categoryId AND NOT arguments.month AND NOT arguments.year>
					AND e."publicationDate" - getDate() <= <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.recentEntryDays#" />
				</cfif>
			GROUP BY e."entryId",
				e."title",
				e."preview",
				e."publicationDate",
				e."publicationDate",
				e."views",
				c."categoryId",
				c."name",
				u."firstName",
				u."lastName",
				e."disableComments",
				CASE
					WHEN e."timesRated" = 0 THEN 0
					ELSE (e."totalRating"/e."timesRated")
				END
			ORDER BY e."publicationDate" DESC
		</cfquery>

		<cfreturn entries />
	</cffunction>

	<cffunction name="getHighestRatedEntries" access="public" hint="I return the highest rated entries"  output="false" returntype="query">
		<cfargument name="limit" hint="I am the maximum number of entries to return" required="yes" type="numeric" />
		<cfset var qHighest = 0 />

		<cfquery name="qHighest" datasource="#_getConfig().getDsn()#" maxrows="#limit#" blockfactor="#limit#">
			SELECT e."entryId",
			       e."title",
					CASE
						WHEN e."timesRated" = 0 THEN 0
						ELSE (e."totalRating"/e."timesRated")
					END AS averageRating
			FROM "Entry" e
			ORDER BY averageRating DESC
		</cfquery>

		<cfreturn qHighest />
	</cffunction>

	<cffunction name="GetMostViewedEntries" access="public" hint="I return the most viewed entries"  output="false" returntype="query">
		<cfargument name="limit" hint="I am the maximum number of entries to return" required="yes" type="numeric" />
		<cfset var qViews = 0 />

		<cfquery name="qViews" datasource="#_getConfig().getDsn()#"  maxrows="#limit#" blockfactor="#limit#">
			SELECT 	e."entryId",
					e."title",
					e."views"
			FROM "Entry"  e
			ORDER BY e."views" DESC
		</cfquery>

		<cfreturn qViews />
	</cffunction>

	<cffunction name="GetMostCommentedOn" access="public" hint="I return the most commented on entries"  output="false" returntype="query">
		<cfargument name="limit" hint="I am the maximum number of entries to return" required="yes" type="numeric" />
		<cfset var qComments = 0 />

		<cfquery name="qComments" datasource="#_getConfig().getDsn()#"  maxrows="#limit#" blockfactor="#limit#">
			SELECT 	e."entryId",
					e."title",
					count(c."commentId") as comments
			FROM "Entry" e JOIN "Comment" c
				ON e."entryId" = c."entryId"
			GROUP BY e."entryId", e."title"
			ORDER BY comments DESC
		</cfquery>

		<cfreturn qComments />
	</cffunction>

</cfcomponent>