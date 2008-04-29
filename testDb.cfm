
<cfapplication name="reactorTest" />

<cfif NOT StructKeyExists(application, "reactorFactory") OR StructKeyExists(url, "reload")>
	<cfset application.reactorFactory = CreateObject("Component", "reactor.reactorFactory") />
	<cfset application.reactorFactory.init("/config/reactor.xml") />
	<h1>reload</h1>
</cfif>

<cfset CustomerRecord = application.reactorFactory.createRecord("foo5").load(custId=37) />
<cfset CustomerRecord.validate() />

<cfdump var="#CustomerRecord#" />
