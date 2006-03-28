
<cfcomponent hint="I am the database agnostic custom Gateway object for the Comment table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.ReactorBlog.Gateway.CommentGateway" >
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
		<cfset query.getWhere().isEqual("Comment", "subscribe", 1) />
		
		<cfset query.returnField("Comment", "emailAddress").returnField("Comment", "name") />
		
		<cfset participants = getByQuery(query) />
		
		<!--- why did I not return the author email, only to add it in?  I didn't want to have to check if it was in there and add it if not --->
		<cfset QueryAddRow(participants)/>
		<cfset QuerySetCell(participants, "emailAddress", arguments.authorEmail) />
		<cfset QuerySetCell(participants, "name", arguments.authorName) />
		
		<cfreturn participants />
	</cffunction>
	
	<cffunction name="setSubscriptionStatus" access="public" hint="I update the subscription status for an email address and entry." output="false" returntype="void">
		<cfargument name="emailAddress" hint="I am the email address to set the subscription status for." required="yes" type="string" />
		<cfargument name="subscribe" hint="I indicate if the user wants to subscribe or not." required="yes" type="boolean" />
		<cfargument name="entryId" hint="I am the entryId of the entry to set the subscription status for." required="no" type="numeric" default="0" />
		
		<cfquery datasource="#_getConfig().getDsn()#">
			UPDATE Comment
			SET subscribe = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.subscribe#" />
			WHERE emailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="50" value="#arguments.emailAddress#" />
				<cfif arguments.entryId>
					AND entryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.entryId#" />
				</cfif>
		</cfquery>		
	</cffunction>
	
</cfcomponent>
	
