<cfcomponent displayname="Controller" output="false" hint="I am a sample model-glue controller." extends="ModelGlue.Core.Controller">

<!--- WARNING

The following are "reserved" terms, used by the base
ModelGlue.Core.Controller.

Do not name functions any of the following:

GetModelGlue
GetControllerName
AddToCache
ExistsInCache
GetFromCache
RemoveFromCache

Do not declare variables in the variables scope named the following:

variables.ModelGlue


		 /WARNING --->


<!--- Constructor --->
<cffunction name="Init" access="Public" returnType="Controller" output="false" hint="I build a new SampleController">
  <cfargument name="ModelGlue" required="true" type="ModelGlue.ModelGlue" />
  <cfargument name="InstanceName" required="true" type="string" />
  <cfset super.Init(arguments.ModelGlue) />

	<!--- Controllers are in the application scope:  Put any application startup code here. --->
  <cfreturn this />
</cffunction>

<!--- Functions specified by <message-listener> tags --->
<cffunction name="OnRequestStart" access="Public" returntype="void" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
</cffunction>

<cffunction name="OnRequestEnd" access="Public" returntype="void" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
</cffunction>

</cfcomponent>

