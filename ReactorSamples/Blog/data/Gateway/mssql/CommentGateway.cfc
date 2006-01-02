
<cfcomponent hint="I am the custom Gateway object for the  table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="ReactorBlogData.Gateway.mssql.base.CommentGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="getParticipants" access="public" hint="I return a query of all the participants in comments on a blog entry." output="false" returntype="query">
		<cfargument name="entryId" hint="I am the id of the entry." required="yes" type="numeric" />
		<cfset var query = createQuery() />
		
		<cfset query.setDistinct(true) />
		<cfset query.getWhere().isEqual("Comment", "entryId", arguments.entryId).isNotNull("Comment", "emailAddress") />
		<cfset query.returnField("Comment", "emailAddress").returnField("Comment", "name") />
		
		<cfreturn getByQuery(query) />
	</cffunction>
	
</cfcomponent>
	
