
<!--- create the reactorFactory --->
<cfset Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("reactor.xml")) />

<!--- create an address record --->
<cfset AddressRecord = Reactor.createRecord("Address") />

<!--- dump the address record --->
<cfdump var="#AddressRecord#" />
