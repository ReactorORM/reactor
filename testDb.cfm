
<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init("/config/reactor.xml") />

<cfset FuzzyGateway = reactor.createGateway("Fuzzy") />

<cfdump var="#FuzzyGateway.getByFields(fuzzyId=5, sortByFieldList='fuzzyId')#" />
