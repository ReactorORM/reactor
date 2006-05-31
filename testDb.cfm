<cfset reactorFactory = CreateObject("Component", "reactor.reactorFactory") />
<cfset reactorFactory.init("/config/reactor.xml") />



<cfset userRecord = reactorFactory.createRecord("User") />
<cfset userRecord.load(userId=4) />

<cfset rel = userRecord.getChildUserIterator().getAt(1) />

<cfset rel.setName("Elizabeth") />

<cfset userRecord.save() />