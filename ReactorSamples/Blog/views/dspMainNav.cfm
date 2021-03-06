<cfset UserRecord = viewstate.getvalue("UserRecord") />
<cfset BlogConfig = viewstate.getvalue("BlogConfig") />

<h3>This Site</h3>
<ul class="mainNav">
	<li><span style="float: right;"><a href="index.cfm?event=rss" class="rss">RSS</a></span><a href="index.cfm">Blog</a></li>
	<li><a href="index.cfm?event=stats">Best of the Blog</a></li>
	<cfif IsObject(UserRecord) AND UserRecord.isLoggedIn()>
		<li><a href="index.cfm?event=EntryForm">Add New Entry</a></li>
		<li><a href="index.cfm?event=ListCategories">Manage Categories</a></li>
		<li><a href="index.cfm?event=ListUsers">Manage Users</a></li>
		<cfif BlogConfig.searchEnabled()>
			<li><a href="index.cfm?event=Reindex" onclick="return confirm('Are you sure you want to reindex?  This may take a while.');">Reindex All Entries</a></li>
		</cfif>
		<li><a href="index.cfm?event=logout">Log Out</a></li>
	</cfif>
	
</ul>