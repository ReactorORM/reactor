
<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />

<cfset reactor.init("/config/reactor.xml") />

<cfset User = reactor.createRecord("user").load(userId=122) />

<cfdump var="#User.getAddressIterator().getQuery()#" />

<cfset User.getAddressIterator().delete(1) />

<cfdump var="#User.getAddressIterator().getQuery()#" />


<!---<cfset User.setAddressId("") />
<cfset User.save() />--->