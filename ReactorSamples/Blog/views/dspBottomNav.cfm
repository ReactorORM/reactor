<cfset UserRecord = viewstate.getValue("UserRecord") />

<p>
	<a href="index.cfm">Home</a>
	|
	<cfif IsObject(UserRecord) AND UserRecord.isLoggedIn()>
		<a href="index.cfm?event=logout">Log Out</a>
	<cfelse>
		<a href="index.cfm?event=loginForm">Login</a>
	</cfif>
</p>