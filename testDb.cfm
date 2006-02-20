
<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init("/config/reactor.xml") />

<cfset CategoriesRecord = reactor.createRecord("Categories") />
