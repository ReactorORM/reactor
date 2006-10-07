<cfcomponent>
	
	<cfset variables.Dictionary = 0 />
	<cfset variables.errors = ArrayNew(1) />
	<cfset variables.alias = "" />
	
	<cffunction name="init" access="public" hint="I configure and return the error collection." output="false" returntype="any" _returntype="ErrorCollection">
		<cfargument name="Dictionary" hint="I am the dictionary to use to translate errors." required="yes" type="any" _type="reactor.dictionary.dictionary" />
		
		<!--- set the dictionary --->
		<cfset setDictionary(arguments.Dictionary) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- getAsStruct --->
	<cffunction name="getAsStruct" access="public" hint="I return the collected errors as a struct of arrays.  this is really intended to work with MG:U's validationErrors tag." output="false" returntype="any" _returntype="struct">
		<cfset var errorStruct = StructNew() />
		<cfset var error = "" />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#count()#" index="x">
			<cfset error = getAt(x) />

			<cfparam name="errorStruct.#ListGetAt(error, 2, ".")#" default="#ArrayNew(1)#" />
			
			<cfset ArrayAppend(errorStruct[ListGetAt(error, 2, ".")], getTranslatedError(error)) />
		</cfloop>
		
		<cfreturn errorStruct />
	</cffunction>
	
	<!--- getAt --->
	<cffunction name="getAt" access="public" hint="I return an error at a specific index." output="false" returntype="any" _returntype="string">
		<cfargument name="index" hint="I am the index of the error to return" required="yes" type="any" _type="numeric" />
		<cfset var errors = getErrors() />
		<cfreturn errors[arguments.index] />
	</cffunction>
	
	<!--- addError --->
	<cffunction name="addError" access="public" hint="I add an error to the collection." output="false" returntype="void">
		<cfargument name="error" output="I am an idetifier for an error.  This should be a dot-style syntax where each element corrisponds to an element in the provided dictionary.  For example, username.notProvided.  Be aware that the identifiers are case sensitive. Duplicate identifiers are ignored." required="yes" type="any" _type="string" />
		
		<cfif NOT hasError(arguments.error)>
			<cfset ArrayAppend(variables.errors, arguments.error) />
		</cfif>
	</cffunction>
	
	<!--- hasError --->
 	<cffunction name="hasError" access="public" hint="I indicate if this collection has the provided error." output="false" returntype="any" _returntype="boolean">
		<cfargument name="error" output="I am an idetifier for an error.  This should be a dot-style syntax where each element corrisponds to an element in the provided dictionary.  For example, username.notProvided.  Be aware that the identifiers are case sensitive. Duplicate identifiers are ignored." required="yes" type="any" _type="string" />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(variables.errors)#" index="x">
			<cfif variables.errors[x] IS arguments.error>
				<cfreturn true />
			</cfif>
		</cfloop>
		
		<cfreturn false />
	</cffunction>
	
	<!--- hasErrors --->
 	<cffunction name="hasErrors" access="public" hint="I indicate if this collection has errors.  If the rootList argument is provided this incidates if there are any errors with the specified roots.  For example. foo.bar would return true if there was an error foo.bar.notProvided in the collection.  You can also provide a comma seperated list of roots to check.  IE, Foo.Bar,Bar.Foo.  When a list is provided if at least one item is matched this returns true." output="false" returntype="any" _returntype="boolean">
		<cfargument name="rootList" output="I am an optional list of roots to match." required="no" type="any" _type="string" default="" />
		<cfset var x = 0 />
		<cfset var root = "" />
		
		<cfif NOT Len(arguments.rootList)>
			<cfreturn count() />
		<cfelse>
			<cfloop from="1" to="#ArrayLen(variables.errors)#" index="x">
				<cfloop list="#arguments.rootList#" index="root">
					<cfif Left(variables.errors[x], Len(root)) IS root>
						<cfreturn true />
					</cfif>
				</cfloop>
			</cfloop>
			
			<cfreturn false />
		</cfif>
	</cffunction>
	
	<!--- getErrors --->
    <cffunction name="getErrors" hint="I return the array of errors.  If the optional rootList argument is provided then only errors with a root specified in the list are returned.  Otherwise all errors are returned." access="public" output="false" returntype="any" _returntype="array">
		<cfargument name="rootList" output="I am an optional list of roots to match." required="no" type="any" _type="string" default="" />
		<cfset var x = 0 />
		<cfset var errors = 0 />
		<cfset var root = "" />
		
		<cfif NOT Len(arguments.rootList)>
			<cfreturn variables.errors />
		<cfelse>
			<cfset errors = ArrayNew(1) />
			
			<cfloop from="1" to="#ArrayLen(variables.errors)#" index="x">
				<cfloop list="#arguments.rootList#" index="root">
					<cfif Left(variables.errors[x], Len(root)) IS root>
						<cfset ArrayAppend(errors, variables.errors[x]) />
					</cfif>
				</cfloop>
			</cfloop>
			
			<cfreturn errors />
		</cfif>
    </cffunction>
	
	<!--- dictionary --->
    <cffunction name="setDictionary" access="private" output="false" returntype="void">
       <cfargument name="dictionary" hint="I am the dictionary object used to translate errors into messages." required="yes" type="any" _type="reactor.dictionary.dictionary" />
       <cfset variables.dictionary = arguments.dictionary />
    </cffunction>
    <cffunction name="getDictionary" access="private" output="false" returntype="any" _returntype="reactor.dictionary.dictionary">
       <cfreturn variables.dictionary />
    </cffunction>
	
	<!--- getTranslatedErrors --->
	<cffunction name="getTranslatedErrors" hint="I return an array of translated errors.  If the optional rootList argument is provided then only errors with a root specified in the list are returned.  Otherwise all errors are returned." access="public" output="false" returntype="any" _returntype="array">
		<cfargument name="rootList" output="I am an optional list of roots to match." required="no" type="any" _type="string" default="" />
		<cfset var x = 0 />
		<cfset var errors = getErrors(arguments.rootList) />
		<cfset var translated = ArrayNew(1) />
		
		<cfloop from="1" to="#ArrayLen(errors)#" index="x">
			<cfset translated[x] = getTranslatedError(errors[x]) />
		</cfloop>
		
		<cfreturn translated />
	</cffunction>
	
	<cffunction name="getTranslatedError" hint="I translate a specific error." access="public" output="false" returntype="any" _returntype="string">
		<cfargument name="error" output="I am the error to translate.  I simply pass the provided string into the Dictionary object to translate it.  There's no guarantee that the provided error is an error on this object." required="yes" type="any" _type="string" /><br>

		<cfreturn getDictionary().getValue(arguments.error) />		
	</cffunction>
	
	<cffunction name="merge" hint="I merge another ErrorCollection into this." access="public" output="false" returntype="void">
		<cfargument name="ErrorCollection" hint="I am the other ErrorCollection" required="yes" type="any" _type="reactor.util.ErrorCollection" />
		<cfset var errors = arguments.ErrorCollection.getErrors() />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(errors)#" index="x">
			<cfset addError(errors[x]) />
		</cfloop>		
	</cffunction>
	
	<!--- count --->
    <cffunction name="count" hint="I return the number of errors in this error collection." access="public" output="false" returntype="any" _returntype="numeric">
       <cfreturn ArrayLen(getErrors()) />
    </cffunction>
</cfcomponent>
