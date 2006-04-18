
<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />

<cfset reactor.init("/config/reactor.xml") />

<cfset Address = reactor.createRecord("Address").load(addressId=92) />
<cfset User = reactor.createRecord("user").load(userId=121) />


<cfset User.setAddressId("") />

<cfset User.save() />