
<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />

<cfset reactor.init("/config/reactor.xml") />

<cfset states = reactor.createIterator("state") />
<cfset State = states.add() />
<cfset State.setAbbreviation("FB") />
<cfset State.setCountryId(223) />
<cfset State.setName("FooBar") />
<cfset State.save() />

<cfset tick = gettickcount()>
<cfdump var="#states.getQuery()#" />
<cfoutput>#getTickcount()-tick#</cfoutput>

<cfset State.delete() />

<cfset tick = gettickcount()>
<cfdump var="#states.getQuery()#" />
<cfoutput>#getTickcount()-tick#</cfoutput>