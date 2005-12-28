<cfset UserRecord = viewstate.getvalue("UserRecord") />
<cfset entries = viewstate.getValue("entries") />

<cfif entries.recordcount>
	
	<h1>Blog Entries</h1>
	<cfoutput query="entries" group="publicationDate">
		<h2>#DateFormat(entries.publicationDate, "mmmm d, yyyy")#</h2>			
	
		<cfoutput group="entryId">
			<div class="entry">
				<!--- output the header --->
				<h3>
					<a href="index.cfm?event=viewEntry&entryId=#entries.entryId#">#entries.title#</a>
				</h3>
				<small>Posted By: #entries.firstName# #entries.lastName# at #TimeFormat(entries.publicationDateTime, "h:mm tt")#</small>
				
				<!--- output the preview --->
				#entries.preview#
				
				<!--- output various links --->
				<p>
					<a href="index.cfm?event=viewEntry&entryId=#entries.entryId#">View Full Entry</a> 
					|
					<a href="index.cfm?event=viewEntry&entryId=#entries.entryId###comments">#entries.commentCount# Comments</a>
				</p>
					
				<p>
					<!--- output the categories --->
					<cfset categories = "" />
					<cfoutput>
						<cfif Len(categories)>
							<cfset categories = categories & ", " />
						</cfif>
						<cfif Len(entries.categoryId)>
							<cfset categories = categories & '<a href="index.cfm?categoryId=#entries.categoryId#">#entries.categoryName#</a>' />
						</cfif>
					</cfoutput>
					
					<cfif Len(categories)>
						Categories: #categories#<br />
					</cfif>
					<small>This article has been viewed #entries.views# times and has an average rating of #entries.averageRating# out of 5.</small>
					<cfif UserRecord.isLoggedIn()>
						|
						<a href="index.cfm?event=EntryForm&entryId=#entries.entryId#">Edit</a>,
						<a href="index.cfm?event=DeleteEntry&entryId=#entries.entryId#">Delete</a>
					</cfif>
				</p>
			</div>
		</cfoutput>
		
	</cfoutput>
	
	
<cfelse>

	<h1>Sorry!</h1>
	<p>Sorry, there are no blog entries which match your criteria.</p>
</cfif>