

<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("/config/reactor.xml")) />

<cfset AdministratorRecord = reactor.createRecord("Administrator") />

<cfdump var="#AdministratorRecord#" />