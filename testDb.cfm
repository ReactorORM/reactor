
<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />

<cfset reactor.init("/config/reactor.xml") />

<cfset User = reactor.createRecord("user").load(userId=122) />

<cfdump var="#User.getAddressIterator().getQuery()#" />

<cfset User.getAddressIterator().getAt(1).setStreet("123 Foo") />

<cfdump var="#User.getAddressIterator().isDirty()#" />


<!---<cfset User.setAddressId("") />
<cfset User.save() />--->