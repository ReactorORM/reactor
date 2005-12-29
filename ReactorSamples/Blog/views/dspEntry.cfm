<cfset UserRecord = viewstate.getvalue("UserRecord") />
<cfset EntryRecord = viewstate.getValue("EntryRecord") />

<cfoutput>
	<h1>#EntryRecord.getTitle()#</h1>
	<small>Posted By: #EntryRecord.getAuthorRecord().getFirstName()# #EntryRecord.getAuthorRecord().getLastName()# on #DateFormat(EntryRecord.getPublicationDate(), "mmm. d, yyyy")# at #TimeFormat(EntryRecord.getPublicationDate(), "h:mm tt")#</small>
	
	#EntryRecord.getArticle()#
	
	<!--- output various links --->
	<p>
		<a href="##comments">#EntryRecord.getCommentCount()# Comments</a>
		<cfif UserRecord.isLoggedIn()>
			|
			<a href="index.cfm?event=EntryForm&entryId=#EntryRecord.getEntryId()#">Edit</a>
			|
			<a href="index.cfm?event=DeleteEntry&entryId=#EntryRecord.getEntryId()#" onclick="return confirm('Are your sure you want to delete this entry?');">Delete</a>
		</cfif>
	</p>
		
	<!--- output the categories --->
	<cfset categoryQuery = EntryRecord.getCategoryQuery() />
	<cfif categoryQuery.recordCount>
		<p>
			<strong>Categories:</strong>
			<cfloop query="categoryQuery">
				<a href="index.cfm?filter=category&categoryId=#categoryQuery.categoryId#">#categoryQuery.name#</a>
			</cfloop>
			<br />
		</p>
	</cfif>
	
	<p>
		<strong>Rate this entry:</strong>
		<cfloop from="1" to="#EntryRecord.getAverageRating()#" index="x">
			<a href="index.cfm?event=rateEntry&entryId=#EntryRecord.getEntryId()#&rating=#x#"><img src="images/starOn.gif" alt="Rate this at #x# out of 5."/></a>
		</cfloop>
		<cfloop from="#EntryRecord.getAverageRating() + 1#" to="5" index="x">
			<a href="index.cfm?event=rateEntry&entryId=#EntryRecord.getEntryId()#&rating=#x#"><img src="images/starOff.gif" alt="Rate this at #x# out of 5." /></a>
		</cfloop>
	</p>	
</cfoutput>
