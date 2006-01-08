<cfset EntryRecord = viewstate.getvalue("EntryRecord") />
<cfset CommentArray = viewstate.getvalue("CommentArray") />

<cfif NOT EntryRecord.getDisableComments()>
	<a name="comments"></a>
	<h2>Comments</h2>

	<cfloop from="1" to="#ArrayLen(CommentArray)#" index="x">
		<cfoutput>
			<div class="comment #Iif(x MOD 2 IS 1, DE('odd'), DE('even'))#">
				#CommentArray[x].formatComment()#
				<p>
					Posted By #CommentArray[x].getName()# on #DateFormat(CommentArray[x].getPosted(), "mmm. d, yyyy")# 
					at #TimeFormat(CommentArray[x].getPosted(), "h:mm tt")#
					<cfif UserRecord.isLoggedIn()>
						|
						<a href="index.cfm?event=DeleteComment&entryId=#CommentArray[x].getEntryId()#&commentId=#CommentArray[x].getCommentId()###comments" onclick="return confirm('Are your sure you want to delete this comment?');">Delete</a>
					</cfif>
				</p>
			</div>
		</cfoutput>
	</cfloop>
<cfelse>
	<p>Sorry, comments are disabled for this entry.</p>
</cfif>