<cfset BlogConfig = viewstate.getValue("BlogConfig") />

<cfmail from="#BlogConfig.getAuthorEmailAddress()#" to="#BlogConfig.getAuthorEmailAddress()#" subject="Error on blog #BlogConfig.getBlogTitle()#" type="html">
	<p>Dear #BlogConfig.getAuthorName()#,</p>
	
	<p>This email is being sent to notify you of the following bug on the blog #BlogConfig.getBlogTitle()#:</p>
	
	#viewCollection.getView("body")#
	
	<p>Your Faithful Website,</p>
	<p>#BlogConfig.getBlogTitle()#</p>
</cfmail>