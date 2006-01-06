<!--- create the reactorFactory --->
<cfset Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("reactor.xml")) />

<!--- create a userRecord --->
<cfset UserRecord = Reactor.createRecord("User") />

<!--- create a new record --->
<cfset UserRecord.setUsername("jschmoe") />
<cfset UserRecord.setPassword("foobar") />
<cfset UserRecord.setFirstName("Joe") />
<cfset UserRecord.setLastName("Schmoe") />

<!--- save the record --->
<cfset UserRecord.save() />

<!--- now, let's list all the records in the database --->
<cfset UserGateway = Reactor.createGateway("User") />

<!--- dump all of the users --->
<cfdump var="#UserGateway.getAll()#" />