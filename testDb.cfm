
<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init("/config/reactor.xml") />

<cfset DaisyIterator = reactor.createIterator("Daisy") />

<cfdump var="#DaisyIterator.getQuery()#" />
