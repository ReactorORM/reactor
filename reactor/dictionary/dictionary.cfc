<cfcomponent displayname="dictionary" hint="I am an object used to read Reactor Dictionary XML files.">

	<cfset variables.dictionaryXml = "" />
	<cfset variables.translator = 0 />
	<cfset variables.translateMethod = 0 />
	<cfset variables.translateArgument = 0 />
	
	<cffunction name="init" access="public" hint="I configure and return this dictionary" output="false" returntype="reactor.dictionary.dictionary">
		<cfargument name="pathToDictionary" hint="I am the path to the XML document this dictionary will use." required="yes" type="string" />
		<cfset var dictionaryXml = "" />
		
		<cffile action="read" file="#ExpandPath(arguments.pathToDictionary)#" variable="dictionaryXml" />
		<cfset setDictionaryXml(XmlParse(dictionaryXml, false)) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- getValue --->
	<cffunction name="getValue" access="public" hint="I get a value from the dictionary" output="false" returntype="string">
		<cfargument name="element" hint="I am the path to the element to get from the dictionary.  IE: foo.bar to get dictionary/foo/bar" required="yes" type="string" />
		<cfset var match = 0 />
		<cfset arguments.element = "/dictionary/" & replace(arguments.element, ".", "/", "all") />		
		<cfset match = XmlSearch(getDictionaryXml(), arguments.element) />
		
		<cfif ArrayLen(match)>
			<cfset match = match[1].xmlText />
			
			<!--- has a translator been specified? --->
			<cfif IsObject(variables.translator)>
				<!--- translate the value --->
				<cfinvoke component="#variables.translator#" method="#variables.translateMethod#" returnvariable="match">
					<cfinvokeargument name="#variables.translateArgument#" value="#match#" />
				</cfinvoke>
			</cfif>
			
			<!--- return the value --->
			<cfreturn match />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
	<!--- translator --->
    <cffunction name="setTranslator" access="public" output="false" returntype="void">
		<cfargument name="translator" hint="I am an optional translator to translate values from the dictionary into other values.  I must have a method that accepts one string argument and returns a string value" required="yes" type="any" />
		<cfargument name="method" hint="I am the name of a method on the translator that must accept one string argument and returns a string value" required="yes" type="string" />
		<cfset var metadata = 0 />
		<cfset variables.translator = arguments.translator />
		<cfset variables.translateMethod = arguments.method />
		<cfset metadata = GetMetadata(variables.translator[arguments.method]) />
		<cfset variables.translateArgument = metadata.parameters[1].name />
    </cffunction>
	
	<!--- dictionaryXml --->
    <cffunction name="setDictionaryXml" access="private" output="false" returntype="void">
       <cfargument name="dictionaryXml" hint="I am the xml from the dictionary" required="yes" type="string" />
       <cfset variables.dictionaryXml = arguments.dictionaryXml />
    </cffunction>
    <cffunction name="getDictionaryXml" access="private" output="false" returntype="string">
       <cfreturn variables.dictionaryXml />
    </cffunction>
	
</cfcomponent>