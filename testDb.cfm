<!---<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />
<cfset reactor.init("/config/reactor.xml") />
	
	
<!---
<cfdump var="#user.load(userId=4).getforwardUserIterator().getQuery()#" />
<cfdump var="#user.load(userId=14).getforwardUserIterator().getQuery()#" />--->


<cfset RelatedUser = reactor.createGateway("RelatedUser") />
<cfset query = RelatedUser.createQuery() />
<cfset query.joinViaAlias("RelatedUser", "Child", "User") />

<cfset query.getWhere().isEqual("User", "userId", 4) />


<cfdump var="#RelatedUser.getByQuery(query)#" />--->
<cfapplication name="BlogSampleApplication" />
<cfdump var="#application.variables#" />