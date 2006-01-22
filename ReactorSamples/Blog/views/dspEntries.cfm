<cfset UserRecord = viewstate.getvalue("UserRecord") />
<cfset entries = viewstate.getValue("entries") />
<cfset CategoryRecord = viewstate.getValue("CategoryRecord") />

<h1>Blog Entries</h1>

<cfif CategoryRecord.getCategoryId()>
	<cfoutput>
		<p><small>Category: #CategoryRecord.getName()#</small></p>
	</cfoutput>
</cfif>
<cfif viewstate.getValue("month", 0) AND viewstate.getValue("year", 0)>
	<cfoutput>
		<p><small>Archive: #MonthAsString(viewstate.getValue("month"))# #viewstate.getValue("year")#</small></p>
	</cfoutput>
</cfif>

<cfif entries.recordcount>
	
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
					<cfif NOT entries.disableComments>
						|
						<a href="index.cfm?event=viewEntry&entryId=#entries.entryId###comments">#entries.commentCount# Comments</a>
					</cfif>
					<cfif UserRecord.isLoggedIn()>
						|
						<a href="index.cfm?event=EntryForm&entryId=#entries.entryId#">Edit</a>
						|
						<a href="index.cfm?event=DeleteEntry&entryId=#entries.entryId#" onclick="return confirm('Are your sure you want to delete this entry?');">Delete</a>
					</cfif>
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
					<small>This article has been viewed #entries.views# times and has
					<cfif entries.averageRating GT 0>
						 an average rating of #entries.averageRating# out of 5.
					<cfelse>
						not yet been rated.</small>
					</cfif>
					</small>
				</p>
			</div>
		</cfoutput>
		
	</cfoutput>
	
	
<cfelse>

	<p>Sorry, there are no blog entries which match your criteria.</p>
</cfif>