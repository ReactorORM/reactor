<!--- create the reactorFactory --->
<cfset Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("reactor.xml")) />

<!--- create a userRecord --->
<cfset UserRecord = Reactor.createRecord("User") />

<!--- let's dump the default values in the UserRecord --->
<cfoutput>
<p>
getUserId(): "#UserRecord.getUserId()#"<br />
getUsername(): "#UserRecord.getUsername()#"<br />
getPassword(): "#UserRecord.getPassword()#"<br />
getFirstName(): "#UserRecord.getFirstName()#"<br />
getLastName(): "#UserRecord.getLastName()#"<br />
getDateCreated(): "#UserRecord.getDateCreated()#"<br />
</p>
</cfoutput>

<!--- set the record to load --->
<cfset UserRecord.setUserId(1) />

<!--- load the record --->
<cfset UserRecord.load() />

<!--- let's dump the size getters again --->
<cfoutput>
<p>
getUserId(): "#UserRecord.getUserId()#"<br />
getUsername(): "#UserRecord.getUsername()#"<br />
getPassword(): "#UserRecord.getPassword()#"<br />
getFirstName(): "#UserRecord.getFirstName()#"<br />
getLastName(): "#UserRecord.getLastName()#"<br />
getDateCreated(): "#UserRecord.getDateCreated()#"<br />
</p>
</cfoutput>

<!--- let's change the password --->
<cfset UserRecord.setPassword("Foobar123") />

<!--- time to save the update --->
<cfset UserRecord.save() />