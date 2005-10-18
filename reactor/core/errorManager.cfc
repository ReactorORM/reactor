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
		<cfargument name="column" hint="I am the name of the column the error is for." required="yes" type="string" />
		<cfargument name="errorMessage" hint="I am the name of the error." required="yes" type="string" />
		<cfset var errorData = getErrorData() />
		<cfset var error = 0 />
				
		<!--- try to find this error message --->
		<cfset error = XMLSearch(errorData, "/tables/table[@name = '#arguments.table#']/column[@name = '#arguments.column#']/errorMessage[@name = '#arguments.errorMessage#']/@message") />
		<cfif ArrayLen(error)>
			<cfset error = error[1].XmlValue />
		<cfelse>
			<cfset error = "An unexpcted error occured: #arguments.errorMessage#" />
		</cfif>
		
		<cfreturn error/>
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