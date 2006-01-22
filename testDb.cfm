

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />


<cfset UserRecord = reactor.createRecord("User")>
<cfset UserRecord.setEmailAddress("doug@doughughes.net") />
<cfset UserRecord.load("emailAddress") />

<cfdump var="#UserRecord.getFirstName()#" />

