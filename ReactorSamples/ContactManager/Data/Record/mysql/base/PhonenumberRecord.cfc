
<cfcomponent hint="I am the base record representing the PhoneNumber table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractRecord" >
	
	<cfset variables.signature = "34CA0A3324768DA70159CB001D1989AF" />
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="ContactManagerData.Record.mysql.base.PhoneNumberRecord">
		
			<cfargument name="PhoneNumberId" hint="I am the default value for the  PhoneNumberId field." required="no" type="string" default="0" />
		
			<cfargument name="ContactId" hint="I am the default value for the  ContactId field." required="no" type="string" default="0" />
		
			<cfargument name="PhoneNumber" hint="I am the default value for the  PhoneNumber field." required="no" type="string" default="" />
		
			<cfset setPhoneNumberId(arguments.PhoneNumberId) />
		
			<cfset setContactId(arguments.ContactId) />
		
			<cfset setPhoneNumber(arguments.PhoneNumber) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		
					
					<!--- validate PhoneNumberId is numeric --->
					<cfif Len(Trim(getPhoneNumberId())) AND NOT IsNumeric(getPhoneNumberId())>
						<cfset ValidationErrorCollection.addError("PhoneNumberId", ErrorManager.getError("PhoneNumber", "PhoneNumberId", "invalidType")) />
					</cfif>					
				
					
					<!--- validate ContactId is numeric --->
					<cfif Len(Trim(getContactId())) AND NOT IsNumeric(getContactId())>
						<cfset ValidationErrorCollection.addError("ContactId", ErrorManager.getError("PhoneNumber", "ContactId", "invalidType")) />
					</cfif>					
				
						<!--- validate PhoneNumber is provided --->
						<cfif NOT Len(Trim(getPhoneNumber()))>
							<cfset ValidationErrorCollection.addError("PhoneNumber", ErrorManager.getError("PhoneNumber", "PhoneNumber", "notProvided")) />
						</cfif>
					
					
					<!--- validate PhoneNumber is string --->
					<cfif NOT IsSimpleValue(getPhoneNumber())>
						<cfset ValidationErrorCollection.addError("PhoneNumber", ErrorManager.getError("PhoneNumber", "PhoneNumber", "invalidType")) />
					</cfif>
					
					<!--- validate PhoneNumber length --->
					<cfif Len(getPhoneNumber()) GT 50 >
						<cfset ValidationErrorCollection.addError("PhoneNumber", ErrorManager.getError("PhoneNumber", "PhoneNumber", "invalidLength")) />
					</cfif>					
				
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	
		<!--- PhoneNumberId --->
		<cffunction name="setPhoneNumberId" access="public" output="false" returntype="void">
			<cfargument name="PhoneNumberId" hint="I am this record's PhoneNumberId value." required="yes" type="string" />
			<cfset _getTo().PhoneNumberId = arguments.PhoneNumberId />
		</cffunction>
		<cffunction name="getPhoneNumberId" access="public" output="false" returntype="string">
			<cfreturn _getTo().PhoneNumberId />
		</cffunction>	
	
		<!--- ContactId --->
		<cffunction name="setContactId" access="public" output="false" returntype="void">
			<cfargument name="ContactId" hint="I am this record's ContactId value." required="yes" type="string" />
			<cfset _getTo().ContactId = arguments.ContactId />
		</cffunction>
		<cffunction name="getContactId" access="public" output="false" returntype="string">
			<cfreturn _getTo().ContactId />
		</cffunction>	
	
		<!--- PhoneNumber --->
		<cffunction name="setPhoneNumber" access="public" output="false" returntype="void">
			<cfargument name="PhoneNumber" hint="I am this record's PhoneNumber value." required="yes" type="string" />
			<cfset _getTo().PhoneNumber = arguments.PhoneNumber />
		</cffunction>
		<cffunction name="getPhoneNumber" access="public" output="false" returntype="string">
			<cfreturn _getTo().PhoneNumber />
		</cffunction>	
	
	
	<cffunction name="load" access="public" hint="I load the PhoneNumber record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().read(_getTo()) />
	</cffunction>	
	
	<cffunction name="save" access="public" hint="I save the PhoneNumber record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void">
		<cfset _getDao().save(_getTo()) />
	</cffunction>	
	
	<cffunction name="delete" access="public" hint="I delete the PhoneNumber record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().delete(_getTo()) />
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo("PhoneNumber")) />
	</cffunction>
	
	
			
	<!--- to --->
	<cffunction name="_setTo" access="public" output="false" returntype="void">
	    <cfargument name="to" hint="I am this record's transfer object." required="yes" type="ContactManagerData.To.mysql.PhoneNumberTo" />
	    <cfset variables.to = arguments.to />
	</cffunction>
	<cffunction name="_getTo" access="public" output="false" returntype="ContactManagerData.To.mysql.PhoneNumberTo">
		<cfreturn variables.to />
	</cffunction>	
	
	<!--- dao --->
	<cffunction name="_setDao" access="private" output="false" returntype="void">
	    <cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="ContactManagerData.Dao.mysql.PhoneNumberDao" />
	    <cfset variables.dao = arguments.dao />
	</cffunction>
	<cffunction name="_getDao" access="private" output="false" returntype="ContactManagerData.Dao.mysql.PhoneNumberDao">
	    <cfreturn variables.dao />
	</cffunction>
	
</cfcomponent>
	
