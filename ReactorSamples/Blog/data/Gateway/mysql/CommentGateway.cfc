
<cfcomponent hint="I am the custom Gateway object for the  table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="ReactorBlogData.Gateway.mysql.base.CommentGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="getParticipants" access="public" hint="I return a query of all the participants in comments on a blog entry." output="false" returntype="query">
		<cfargument name="entryId" hint="I am the id of the entry." required="yes" type="numeric" />
		<cfargument name="postingEmailAddress" hint="I am the email address of the person posting the comment - don't get me." required="yes" type="string" />
		<cfargument name="authorName" hint="I am the name of the author." required="yes" type="string" />
		<cfargument name="authorEmail" hint="I am the email address for the author." required="yes" type="string" />
		<cfset var query = createQuery() />
		<cfset var participants = 0 />
		
		<cfset query.setDistinct(true) />
		<cfset query.getWhere().isEqual("Comment", "entryId", arguments.entryId) />
		<cfset query.getWhere().isNotNull("Comment", "emailAddress") />
		<cfset query.getWhere().isNotEqual("Comment", "emailAddress", arguments.postingEmailAddress) />
		<cfset query.getWhere().isNotEqual("Comment", "emailAddress", arguments.authorEmail) />
		
		<cfset query.returnField("Comment", "emailAddress").returnField("Comment", "name") />
		
		<cfset participants = getByQuery(query) />
		
		<!--- why did I not return the author email, only to add it in?  I didn't want to have to check if it was in there and add it if not --->
		<cfset QueryAddRow(participants)/>
		<cfset QuerySetCell(participants, "emailAddress", arguments.authorEmail) />
		<cfset QuerySetCell(participants, "name", arguments.authorEmail) />
		
		<cfreturn participants />
	</cffunction>
	
</cfcomponent>
	
