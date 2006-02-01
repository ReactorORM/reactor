

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init("/config/reactor.xml") />

<cfset UserRecord = reactor.createRecord("User") />
<cfset UserRecord.setEmailAddress("doug@doughughes.net") />
<cfset UserRecord.load("EmailAddress") />

<cfdump var="#UserRecord.getFirstName()#" />


