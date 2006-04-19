<cfset UserRecord = viewstate.getvalue("UserRecord") />
<cfset EntryRecord = viewstate.getValue("EntryRecord") />

<cfoutput>
	<h1>#EntryRecord.getTitle()#</h1>
	<small>Posted By: #EntryRecord.getAuthor().getFirstName()# #EntryRecord.getAuthor().getLastName()# on #DateFormat(EntryRecord.getPublicationDate(), "mmm. d, yyyy")# at #TimeFormat(EntryRecord.getPublicationDate(), "h:mm tt")#</small>
	
	#EntryRecord.getArticle()#
	
	<!--- output various links --->
	<cfif NOT EntryRecord.getDisableComments()>
		<p>
			<a href="##comments" id="comments">#EntryRecord.getCommentCount()# Comments</a>
		</p>
	</cfif>
	
	<cfif UserRecord.isLoggedIn()>
		<p>
			<a href="index.cfm?event=EntryForm&entryId=#EntryRecord.getEntryId()#">Edit</a>
			|
			<a href="index.cfm?event=DeleteEntry&entryId=#EntryRecord.getEntryId()#" onclick="return confirm('Are your sure you want to delete this entry?');">Delete</a>
		</p>
	</cfif>
		
	<!--- output the categories --->
	<cfset categoryQuery = EntryRecord.getCategoryIterator().getQuery() />
	<cfif categoryQuery.recordCount>
		<p>
			<strong>Categories:</strong>
			<cfloop query="categoryQuery">
				<a href="index.cfm?filter=category&categoryId=#categoryQuery.categoryId#">#categoryQuery.name#</a><cfif categoryQuery.currentRow IS NOT categoryQuery.recordCount>,</cfif>
			</cfloop>
			<br />
		</p>
	</cfif>
	
	<p>
		<strong>Rate this entry:</strong>
		<cfloop from="1" to="#EntryRecord.getAverageRating()#" index="x">
			<a href="##" onclick="location.href = 'index.cfm?event=rateEntry&entryId=#EntryRecord.getEntryId()#&rating=#x#';"><img src="images/starOn.gif" alt="Rate this at #x# out of 5."/></a>
		</cfloop>
		<cfloop from="#EntryRecord.getAverageRating() + 1#" to="5" index="x">
			<a href="##" onclick="location.href = 'index.cfm?event=rateEntry&entryId=#EntryRecord.getEntryId()#&rating=#x#';"><img src="images/starOff.gif" alt="Rate this at #x# out of 5." /></a>
		</cfloop>
		<small>Rated #EntryRecord.getRatingCount()# times in #EntryRecord.getViews()# views.</small>
	</p>	
</cfoutput>
