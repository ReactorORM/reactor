<cfset BlogConfig = viewstate.getValue("BlogConfig") />
<cfset particpants = viewstate.getValue("particpants") />
<cfset EntryRecord = viewstate.getValue("EntryRecord") />
<cfset CommentRecord = viewstate.getValue("CommentRecord") />

<cfmail from="#BlogConfig.getAuthorEmailAddress()#" query="particpants" to="emailAddress" subject="Comment added to blog: #BlogConfig.getBlogTitle()# - #EntryRecord.getTitle()#" type="html">
	
	<p>
		<strong>Comment added to Blog:</strong><br>
		#BlogConfig.getBlogTitle()#
	</p>	
	<p>
		<strong>Entry:</strong><br>
		<a href="#BlogConfig.getBaseUrl()#?event=ViewEntry&entryId=#EntryRecord.getEntryId()#">#EntryRecord.getTitle()#</a>
	</p>	
	<p>
		<strong>URL:</strong><br>
		<a href="#BlogConfig.getBaseUrl()#?event=ViewEntry&entryId=#EntryRecord.getEntryId()#">#BlogConfig.getBaseUrl()#?event=ViewEntry&entryId=#EntryRecord.getEntryId()#</a>
	</p>		
	<p>
		<strong>Comment Made By:</strong><br>
		#particpants.name#
	</p>		
	<p>
		<strong>Comment:</strong><br>
		#CommentRecord.getComment()#
	</p>	
	
</cfmail>