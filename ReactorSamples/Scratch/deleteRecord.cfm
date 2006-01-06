<!--- create the reactorFactory --->
<cfset Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("reactor.xml")) />

<!--- create a userRecord --->
<cfset UserRecord = Reactor.createRecord("User") />

<!--- set the record to delete --->
<cfset UserRecord.setUserId(2) />

<!--- delete the record --->
<cfset UserRecord.delete() />