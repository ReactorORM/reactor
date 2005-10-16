<cfcomponent hint="I am a CFC used to manage translations of errors into error messages">

	<cfset variables.errorData = "" />
	
	<cffunction name="init" access="public" hint="I configure and return the errorManager." output="false" returntype="reactor.core.errorManager">
		<cfargument name="pathToXml" hint="I am the path to the XML file to read" required="yes" type="string" />
		<cfset var errorData = "" />

		<cffile action="read" file="#arguments.pathToXml#" variable="errorData" />
		<cfset setErrorData(XmlParse(errorData)) />

		<cfreturn this />
	</cffunction>
	
	<cffunction name="getError" access="public" hint="I retrieve and return a specific named error message." output="false" returntype="string">
		<cfargument name="table" hint="I am the name of the table the error is for." required="yes" type="string" />
		<cfargument name="field" hint="I am the name of the field the error is for." required="yes" type="string" />
		<cfargument name="errorId" hint="I am the id of the error." required="yes" type="string" />
		
		<cfreturn "You need to parse and read the xml file... not to mention generate it." />
	</cffunction>
	
	<!--- errorData --->
    <cffunction name="setErrorData" access="private" output="false" returntype="void">
       <cfargument name="errorData" hint="I am the error data read from the provided xml file." required="yes" type="xml" />
       <cfset variables.errorData = arguments.errorData />
    </cffunction>
    <cffunction name="getErrorData" access="private" output="false" returntype="xml">
       <cfreturn variables.errorData />
    </cffunction>

</cfcomponent>