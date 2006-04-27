
<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />

<cfset reactor.init("/config/reactor.xml") />


<cfset Doug = reactor.createRecord("user").load(userId=4) />
<cfset Mike = reactor.createRecord("user").load(userId=14) />

<cfset Doug.getRelationIterator().add(Mike) />

<cfdump var="#Doug.getRelationIterator().getQuery()#" />

<cfset Doug.save() />
