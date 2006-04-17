
<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />

<cfset reactor.init("/config/reactor.xml") />


<cfset Address = reactor.createRecord("Address").load(addressId=64) />
<cfset User = reactor.createRecord("User").load(userId=8) />

<cfset User.getUserAddressIterator().add(Address) />

<cfset User.save() />