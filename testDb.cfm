<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />
<cfset reactor.init("/config/reactor.xml") />
	
	
<cfset user = reactor.createRecord("user") />

<cfdump var="#user.load(userId=4).getforwardUserIterator().getQuery()#" />
<cfdump var="#user.load(userId=14).getforwardUserIterator().getQuery()#" />