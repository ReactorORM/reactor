
<!---
<cfset timer = getTickCount() />

	<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />
	<cfset reactor.init("/config/reactor.xml") />
	<cfset FuzzyGateway = reactor.createGateway("Fuzzy") />
	<cfset data = FuzzyGateway.getByFields(fuzzyId=5, sortByFieldList='fuzzyId') />

<cfset timer = getTickCount() - timer />

<cfdump var="#data#" />

<cfoutput>#timer# ms
</cfoutput>--->

<cfquery name="test" datasource="SampleDB2">
	SELECT *
	FROM SYSIBM.SYSTABLES
</cfquery>

<cfdump var="#test#" />