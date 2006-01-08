<cfset BlogConfig = viewstate.getValue("BlogConfig") />
<cfset particpants = viewstate.getValue("particpants") />
<cfset EntryRecord = viewstate.getValue("EntryRecord") />
<cfset CommentRecord = viewstate.getValue("CommentRecord") />

<cfmail from="#BlogConfig.getAuthorEmailAddress()#" query="particpants" to="#particpants.emailAddress#" subject="Comment added to blog: #BlogConfig.getBlogTitle()# - #EntryRecord.getTitle()#" type="html">
	<p>Dear #particpants.name#,</p>
	
	<p>
		<strong>Comment added to Blog:</strong><br>
		#BlogConfig.getBlogTitle()#
	</p>	
	<p>
		<strong>Entry:</strong><br>
		<a href="http://#CGI.SERVER_NAME#/#BlogConfig.getBlogPath()#?event=ViewEntry&entryId=#EntryRecord.getEntryId()#">#EntryRecord.getTitle()#</a>
	</p>	
	<p>
		<strong>URL:</strong><br>
		<a href="http://#CGI.SERVER_NAME#/#BlogConfig.getBlogPath()#?event=ViewEntry&entryId=#EntryRecord.getEntryId()#">http://#CGI.SERVER_NAME#/#BlogConfig.getBlogPath()#?event=ViewEntry&amp;entryId=#EntryRecord.getEntryId()#</a>
	</p>		
	<p>
		<strong>Comment Made By:</strong><br>
		#CommentRecord.getName()#
	</p>		
	<p>
		<strong>Comment:</strong><br>
		#CommentRecord.getComment()#
	</p>
		
</cfmail>