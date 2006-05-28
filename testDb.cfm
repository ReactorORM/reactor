<cfset reactorFactory = CreateObject("Component", "reactor.reactorFactory") />
<cfset reactorFactory.init("/config/reactor.xml") />

<cfset userRecord = reactorFactory.createRecord("User") />

<cfset userRecord.load(userId=4) />

<cfdump var="#userRecord.getChildUserIterator().getQuery()#" />