

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />


<cfset tmpRecord = reactor.createRecord("TMP")>
<cfset tmpRecord.setMyColumn("test")>
<cfset tmpRecord.save()>


<cfdump var="#TestRecord.getTestId()#" />