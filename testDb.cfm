<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />

<cfset reactor.init("/config/reactor.xml") />

<cfset Address = reactor.createRecord("Address") />
<cfset User = reactor.createRecord("User") />

<cfset Address.setStreet("1261 Cambria Dr") />
<cfset Address.setCity("East Lansing") />

<cfset User.setAddress(Address) />

<cfset User.removeAddress() />

<cfdump var="#User.getAddress().getStreet()#" /><cfabort>