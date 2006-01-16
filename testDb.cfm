

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />

<cfset TestRecord = reactor.createRecord("Test") />
<cfset TestRecord.setTestId("D357FBDC-ABA2-9CEE-69E7-CCE761733CB2") />
<cfset TestRecord.load() />

<cfdump var="#TestRecord.getTestId()#" />