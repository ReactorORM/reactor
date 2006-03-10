<cfset reactor = CreateObject("Component", "reactor.reactorFactory") />
<cfset reactor.init("/config/reactor.xml") />
<cfset TeacherRecord = reactor.createRecord("Teacher") />

<cfdump var="#TeacherRecord.validate().getallerrors()#" />
