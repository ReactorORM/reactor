<cfset config = CreateObject("Component", "reactor.bean.config").init("scratch", "mssql", "/reactorData", "always") />
<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init(config) />

<cfset LionDao = reactor.createDao("Lion") />

<cfdump var="#LionDao#" />