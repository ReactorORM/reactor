<cfset UserRecord = viewstate.getvalue("UserRecord") />

<h3>This Site</h3>
<ul class="mainNav">
	<li><a href="index.cfm">Blog</a></li>
	<cfif UserRecord.isLoggedIn()>
		<li><a href="index.cfm?event=EntryForm">Add New Entry</a></li>
	</cfif>
	
</ul>