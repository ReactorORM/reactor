
<cfset reactor = CreateObject("Component", "reactor.reactorFactory").init("/config/reactor.xml") />

<cfset MyEntryRecord = reactor.createRecord("MyEntry") />
<cfset MyEntryRecord.setEntryId(163) />
<cfset MyEntryRecord.load() />

<cfset iterator = MyEntryRecord.getCategoryIterator() />
<cfset iterator.setDistinct(true) />

<cfdump var="#iterator.getquery()#" />