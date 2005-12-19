
<cfcomponent hint="I am the base record representing the EmailAddress table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractRecord" >
	
	<cfset variables.signature = "A05CB2B8600B580951645196D7A5132D" />
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="ReactorSamples.ContactManager.data.Record.mysql.base.EmailAddressRecord">
		
			<cfargument name="EmailAddressId" hint="I am the default value for the  EmailAddressId field." required="no" type="string" default="0" />
		
			<cfargument name="ContactId" hint="I am the default value for the  ContactId field." required="no" type="string" default="0" />
		
			<cfargument name="EmailAddress" hint="I am the default value for the  EmailAddress field." required="no" type="string" default="" />
		
			<cfset setEmailAddressId(arguments.EmailAddressId) />
		
			<cfset setContactId(arguments.ContactId) />
		
			<cfset setEmailAddress(arguments.EmailAddress) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		
					
					<!--- validate EmailAddressId is numeric --->
					<cfif Len(Trim(getEmailAddressId())) AND NOT IsNumeric(getEmailAddressId())>
						<cfset ValidationErrorCollection.addError("EmailAddressId", ErrorManager.getError("EmailAddress", "EmailAddressId", "invalidType")) />
					</cfif>					
				
					
					<!--- validate ContactId is numeric --->
					<cfif Len(Trim(getContactId())) AND NOT IsNumeric(getContactId())>
						<cfset ValidationErrorCollection.addError("ContactId", ErrorManager.getError("EmailAddress", "ContactId", "invalidType")) />
					</cfif>					
				
						<!--- validate EmailAddress is provided --->
						<cfif NOT Len(Trim(getEmailAddress()))>
							<cfset ValidationErrorCollection.addError("EmailAddress", ErrorManager.getError("EmailAddress", "EmailAddress", "notProvided")) />
						</cfif>
					
					
					<!--- validate EmailAddress is string --->
					<cfif NOT IsSimpleValue(getEmailAddress())>
						<cfset ValidationErrorCollection.addError("EmailAddress", ErrorManager.getError("EmailAddress", "EmailAddress", "invalidType")) />
					</cfif>
					
					<!--- validate EmailAddress length --->
					<cfif Len(getEmailAddress()) GT 100 >
						<cfset ValidationErrorCollection.addError("EmailAddress", ErrorManager.getError("EmailAddress", "EmailAddress", "invalidLength")) />
					</cfif>					
				
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	
		<!--- EmailAddressId --->
		<cffunction name="setEmailAddressId" access="public" output="false" returntype="void">
			<cfargument name="EmailAddressId" hint="I am this record's EmailAddressId value." required="yes" type="string" />
			<cfset _getTo().EmailAddressId = arguments.EmailAddressId />
		</cffunction>
		<cffunction name="getEmailAddressId" access="public" output="false" returntype="string">
			<cfreturn _getTo().EmailAddressId />
		</cffunction>	
	
		<!--- ContactId --->
		<cffunction name="setContactId" access="public" output="false" returntype="void">
			<cfargument name="ContactId" hint="I am this record's ContactId value." required="yes" type="string" />
			<cfset _getTo().ContactId = arguments.ContactId />
		</cffunction>
		<cffunction name="getContactId" access="public" output="false" returntype="string">
			<cfreturn _getTo().ContactId />
		</cffunction>	
	
		<!--- EmailAddress --->
		<cffunction name="setEmailAddress" access="public" output="false" returntype="void">
			<cfargument name="EmailAddress" hint="I am this record's EmailAddress value." required="yes" type="string" />
			<cfset _getTo().EmailAddress = arguments.EmailAddress />
		</cffunction>
		<cffunction name="getEmailAddress" access="public" output="false" returntype="string">
			<cfreturn _getTo().EmailAddress />
		</cffunction>	
	
	
	<cffunction name="load" access="public" hint="I load the EmailAddress record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().read(_getTo()) />
	</cffunction>	
	
	<cffunction name="save" access="public" hint="I save the EmailAddress record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void">
		<cfset _getDao().save(_getTo()) />
	</cffunction>	
	
	<cffunction name="delete" access="public" hint="I delete the EmailAddress record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().delete(_getTo()) />
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo("EmailAddress")) />
	</cffunction>
	
	
			
	<!--- to --->
	<cffunction name="_setTo" access="public" output="false" returntype="void">
	    <cfargument name="to" hint="I am this record's transfer object." required="yes" type="ReactorSamples.ContactManager.data.To.mysql.EmailAddressTo" />
	    <cfset variables.to = arguments.to />
	</cffunction>
	<cffunction name="_getTo" access="public" output="false" returntype="ReactorSamples.ContactManager.data.To.mysql.EmailAddressTo">
		<cfreturn variables.to />
	</cffunction>	
	
	<!--- dao --->
	<cffunction name="_setDao" access="private" output="false" returntype="void">
	    <cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="ReactorSamples.ContactManager.data.Dao.mysql.EmailAddressDao" />
	    <cfset variables.dao = arguments.dao />
	</cffunction>
	<cffunction name="_getDao" access="private" output="false" returntype="ReactorSamples.ContactManager.data.Dao.mysql.EmailAddressDao">
	    <cfreturn variables.dao />
	</cffunction>
	
</cfcomponent>
	
