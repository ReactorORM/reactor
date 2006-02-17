<!---

The Application.cfm creates some global objects.

---->

<cfset Application.Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath(".") & "/reactor.xml") />

<!--- Because this is only a sample app I'm not going to shy away from adding some HTML in the application.cfm.  --->
<h1>Contact Manager Sample Application</h1>

<a href="index.cfm">List Contacts</a> | 
<a href="addEditContact.cfm">Add a Contact</a>
<hr>