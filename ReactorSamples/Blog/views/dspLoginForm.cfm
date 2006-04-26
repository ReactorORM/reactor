<cfset submitted = viewstate.getValue("submit") />
<cfset username = viewstate.getValue("username") />
<cfset password = viewstate.getValue("password") />

<h1>Login</h1>

<cfform name="LoginForm" action="index.cfm?event=SubmitLoginForm" method="post">

	<cfif Len(submitted)>
		<p>Login failed.  Please try again.</p>
	</cfif>
	
	<cf_input label="Login Name:" required="yes" type="text" name="username" value="#username#" size="20" maxlength="20" />
	<cf_input label="Password:" required="yes" type="password" name="password" value="" size="20" maxlength="20" />
	
	<cf_input type="Submit" name="submit" value="Login" />
		
</cfform>