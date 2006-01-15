<!--- create the reactorFactory --->
<cfset Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("reactor.xml")) />

<!--- create a customerRecord and load one --->
<cfset CustomerRecord = Reactor.createRecord("Customer") />
<cfset CustomerRecord.setCustomerId(1) />
<cfset CustomerRecord.load() />

<!--- how much did this customer spend? --->
<cfoutput>
	#CustomerRecord.getTotalSpent()#
</cfoutput>