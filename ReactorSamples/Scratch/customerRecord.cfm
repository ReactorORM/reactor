<!--- create the reactorFactory --->
<cfset Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("reactor.xml")) />

<!--- create a customerRecord --->
<cfset CustomerRecord = Reactor.createRecord("Customer") />

<!--- dump this customer's address record --->
<cfdump var="#CustomerRecord.getAddressRecord()#" />