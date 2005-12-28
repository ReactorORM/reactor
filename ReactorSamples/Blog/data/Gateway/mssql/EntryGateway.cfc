
<cfcomponent hint="I am the custom Gateway object for the  table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="ReactorBlogData.Gateway.mssql.base.EntryGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="getMatching" access="public" hint="I return an array of matching blog entries records." output="false" returntype="query">
		<cfargument name="categoryId" hint="I am a category to match" required="yes" type="numeric" default="0" />
		<cfargument name="date" hint="I am a date to match" required="yes" type="date" default="1/1/1900" />
		<cfset var entries = 0 />
		
		<cfquery name="entries" datasource="#_getConfig().getDsn()#">
			SELECT e.entryId, e.title, e.preview,
				CONVERT(varchar(2), MONTH(e.publicationDate)) + '/' + CONVERT(varchar(2), DAY(e.publicationDate)) + '/' + CONVERT(varchar(4), YEAR(e.publicationDate)) as publicationDate,
				e.publicationDate as publicationDateTime,
				e.views, c.categoryId, c.name as categoryName, 
				u.firstName, u.lastName,
				
				count(m.commentId) as commentCount,
				avg(r.rating) as averageRating
				
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
				<cfif arguments.date IS NOT "1/1/1900">
					AND e.publicationDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(arguments.date, "m/d/yyyy")#" />
					AND e.publicationDate <  <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(DateAdd("d", 1, arguments.date), "m/d/yyyy")#" />
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
	
</cfcomponent>
	
