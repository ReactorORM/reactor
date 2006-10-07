<cfcomponent displayname="dictionary" hint="I am an object used to read Reactor Dictionary XML files.">

	<cfset variables.dictionaryXml = "" />
	
	<cffunction name="init" access="public" hint="I configure and return this dictionary" output="false" returntype="any" _returntype="reactor.dictionary.dictionary">
		<cfargument name="pathToDictionary" hint="I am the path to the XML document this dictionary will use." required="yes" type="any" _type="string" />
		<cfset var dictionaryXml = "" />
		
		<cffile action="read" file="#ExpandPath(arguments.pathToDictionary)#" variable="dictionaryXml" />
		<cfset setDictionaryXml(XmlParse(dictionaryXml, false)) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- getValue --->
	<cffunction name="getValue" access="public" hint="I get a value from the dictionary" output="false" returntype="any" _returntype="string">
		<cfargument name="element" hint="I am the path to the element to get from the dictionary.  IE: foo.bar to get dictionary/foo/bar" required="yes" type="any" _type="string" />
		<cfset var node = 0 />
		
		<cftry>
			<cfset node = evaluate("getDictionaryXml().#arguments.element#") />
			<cfreturn node.xmltext />
			<cfcatch>
				<cfreturn arguments.element />
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	<!--- dictionaryXml --->
    <cffunction name="setDictionaryXml" access="private" output="false" returntype="void">
       <cfargument name="dictionaryXml" hint="I am the xml from the dictionary" required="yes" type="any" _type="string" />
       <cfset variables.dictionaryXml = arguments.dictionaryXml />
    </cffunction>
    <cffunction name="getDictionaryXml" access="private" output="false" returntype="any" _returntype="string">
       <cfreturn variables.dictionaryXml />
    </cffunction>
	
</cfcomponent>
