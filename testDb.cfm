

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init("/config/reactor.xml") />

<cfset UserRecord = reactor.createRecord("User").load(emailAddress="doug@doughughes.net", userId=100) />

<cfdump var="#UserRecord.getFirstName()#" />


