
<cfcomponent hint="I am the db2 custom Gateway object for the Category object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="CategoryGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="getCountedCategories" access="public" hint="I return a query of categories and the number of times used sorted by the times used and name" output="false" returntype="query">
		<cfset var categories = 0 />
		
		<cfquery name="categories" datasource="#_getConfig().getDsn()#">
			SELECT c."categoryId", c."name", count(DISTINCT ec."entryId") as "entryCount"
			FROM "NULLID"."Category" as c LEFT JOIN "NULLID"."EntryCategory" as ec 
				ON c."categoryId" = ec."categoryId"
			GROUP BY c."categoryId", c."name"
			ORDER BY c."name"
		</cfquery>
		
		<cfreturn categories />
	</cffunction>
</cfcomponent>
	
