
<cfset reactorFactory = CreateObject("Component", "reactor.reactorFactory") />
<cfset reactorFactory.init("/config/reactor.xml") />

<cfset CustomerGateway = reactorFactory.createGateway("Customer") />

<cfset total = 0 />
<cfloop from="1" to="30" index="x">
	<cfset tick = getTickCount() />
	<cfset CustomerGateway.test() />
	<cfset total = total + (getTickCount()-tick) />
</cfloop>

avg: <cfdump var="#total/30#" />
