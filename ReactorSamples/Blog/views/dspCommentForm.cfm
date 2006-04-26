<cfset Errors = viewstate.getValue("Errors") />
<cfset CommentRecord = viewstate.getValue("CommentRecord") />
<cfset BlogConfig = viewstate.getValue("BlogConfig") />
<cfset EntryRecord = viewstate.getValue("EntryRecord") />

<cfif NOT EntryRecord.getDisableComments()>
	<h3>Your Comments</h3>
	
	<cfform name="CommentForm" action="index.cfm?event=SubmitCommentForm" method="post">
	
		<cf_input label="Name:"
			errors="#Errors#"
			alias="Comment"
			required="yes"
			type="text"
			name="name"
			value="#CommentRecord.getName()#"
			size="30"
			maxlength="50" />
			
		<cf_input label="Email Address:"
			errors="#Errors#"
			alias="Comment"
			required="no"
			type="text"
			name="emailAddress"
			value="#CommentRecord.getEmailAddress()#"
			size="30"
			maxlength="50"
			comment="Your email address is never shown on this website." />
		
		<cf_input
			label="Comment:"
			errors="#Errors#"
			alias="Comment"
			required="yes"
			type="textarea"
			name="comment"
			height="150px"
			value="#CommentRecord.getComment()#" />
		
		<cf_input
			label="Notify me when more comments are posted."
			errors="#Errors#"
			alias="Comment"
			type="checkbox"
			name="subscribe"
			value="#CommentRecord.getSubscribe()#" />
		
		<cfif BlogConfig.getUseCaptcha()>
			<cf_input
				label="Enter This Code Below:"
				errors="#Errors#"
				alias="Comment"
				required="yes"
				type="captcha"
				name="captcha"
				comment="This helps prevent comment spam." />
		</cfif>
			
		<cfinput	
			type="hidden"
			name="entryId"
			value="#EntryRecord.getEntryId()#" />
			
		<cf_input
			type="Submit"
			name="submit"
			value="Add a Comment" />
			
	</cfform>
	
	<a href="##commentForm" id="commentForm"></a>
</cfif>

<cfif viewstate.getValue("event") IS "SubmitCommentForm" AND IsObject(Errors) AND Errors.hasErrors()>
	<script language="javascript">
		document.getElementById("commentForm").scrollIntoView();
	</script>
<cfelseif viewstate.getValue("showLastComment", false)>
	<script language="javascript">
		document.getElementById("lastComment").scrollIntoView();
	</script>
</cfif>

<cfdump var="#Errors.getErrors()#" />