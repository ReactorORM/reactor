<cfset UserRecord = viewstate.getValue("OtherUserRecord") />
<cfset Errors = viewstate.getValue("Errors") />

<h1>User</h1>

<cfform name="UserForm" action="index.cfm?event=SubmitUserForm" method="post">

	<cf_input label="First Name:"
		errors="#Errors#"
		alias="User"
		required="yes"
		type="text"
		name="firstName"
		value="#UserRecord.getFirstName()#"
		size="20"
		maxlength="20" />
		
	<cf_input label="Last Name:"
		errors="#Errors#"
		alias="User"
		required="yes"
		type="text"
		name="lastName"
		value="#UserRecord.getLastName()#"
		size="20"
		maxlength="20" />
		
	<cf_input label="Email Address:"
		errors="#Errors#"
		alias="User"
		required="yes"
		type="text"
		name="emailAddress"
		value="#UserRecord.getEmailAddress()#"
		size="20"
		maxlength="50" />
		
	<cf_input label="User Name:"
		errors="#Errors#"
		alias="User"
		required="yes"
		type="text"
		name="userName"
		value="#UserRecord.getUserName()#"
		size="20"
		maxlength="20" />
		
	<cf_input label="Password:"
		errors="#Errors#"
		alias="User"
		required="yes"
		type="password"
		name="password"
		value="#UserRecord.getPassword()#"
		size="20"
		maxlength="20" />
	
	<cfinput	
		type="hidden"
		name="userId"
		value="#UserRecord.getUserId()#" />
	
	<cf_input
		type="Submit"
		name="submit"
		value="Save User" />
		
</cfform>
