
<cfcomponent hint="I am the database agnostic custom Gateway object for the Rating table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.ReactorBlogData.Gateway.RatingGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="deleteByEntryId" access="public" hint="I delete all associations for an entry" output="false" returntype="void">
		<cfargument name="entryId" hint="I am the id of the entry to delete ratings for" required="yes" type="numeric" />
		<cfquery datasource="#_getConfig().getDsn()#">
			DELETE FROM Rating
			WHERE entryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.entryId#" />
		</cfquery>
	</cffunction>

</cfcomponent>
	
