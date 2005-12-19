
<cfcomponent hint="I am the base record representing the Contact table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractRecord" >
	
	<cfset variables.signature = "10010BEA05240DFE8FCF4A559D362C72" />
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="ReactorSamples.ContactManager.data.Record.mssql.base.ContactRecord">
		
			<cfargument name="ContactId" hint="I am the default value for the  ContactId field." required="no" type="string" default="0" />
		
			<cfargument name="FirstName" hint="I am the default value for the  FirstName field." required="no" type="string" default="" />
		
			<cfargument name="LastName" hint="I am the default value for the  LastName field." required="no" type="string" default="" />
		
			<cfset setContactId(arguments.ContactId) />
		
			<cfset setFirstName(arguments.FirstName) />
		
			<cfset setLastName(arguments.LastName) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		
					
					<!--- validate ContactId is numeric --->
					<cfif Len(Trim(getContactId())) AND NOT IsNumeric(getContactId())>
						<cfset ValidationErrorCollection.addError("ContactId", ErrorManager.getError("Contact", "ContactId", "invalidType")) />
					</cfif>					
				
						<!--- validate FirstName is provided --->
						<cfif NOT Len(Trim(getFirstName()))>
							<cfset ValidationErrorCollection.addError("FirstName", ErrorManager.getError("Contact", "FirstName", "notProvided")) />
						</cfif>
					
					
					<!--- validate FirstName is string --->
					<cfif NOT IsSimpleValue(getFirstName())>
						<cfset ValidationErrorCollection.addError("FirstName", ErrorManager.getError("Contact", "FirstName", "invalidType")) />
					</cfif>
					
					<!--- validate FirstName length --->
					<cfif Len(getFirstName()) GT 50 >
						<cfset ValidationErrorCollection.addError("FirstName", ErrorManager.getError("Contact", "FirstName", "invalidLength")) />
					</cfif>					
				
						<!--- validate LastName is provided --->
						<cfif NOT Len(Trim(getLastName()))>
							<cfset ValidationErrorCollection.addError("LastName", ErrorManager.getError("Contact", "LastName", "notProvided")) />
						</cfif>
					
					
					<!--- validate LastName is string --->
					<cfif NOT IsSimpleValue(getLastName())>
						<cfset ValidationErrorCollection.addError("LastName", ErrorManager.getError("Contact", "LastName", "invalidType")) />
					</cfif>
					
					<!--- validate LastName length --->
					<cfif Len(getLastName()) GT 50 >
						<cfset ValidationErrorCollection.addError("LastName", ErrorManager.getError("Contact", "LastName", "invalidLength")) />
					</cfif>					
				
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	
		<!--- ContactId --->
		<cffunction name="setContactId" access="public" output="false" returntype="void">
			<cfargument name="ContactId" hint="I am this record's ContactId value." required="yes" type="string" />
			<cfset _getTo().ContactId = arguments.ContactId />
		</cffunction>
		<cffunction name="getContactId" access="public" output="false" returntype="string">
			<cfreturn _getTo().ContactId />
		</cffunction>	
	
		<!--- FirstName --->
		<cffunction name="setFirstName" access="public" output="false" returntype="void">
			<cfargument name="FirstName" hint="I am this record's FirstName value." required="yes" type="string" />
			<cfset _getTo().FirstName = arguments.FirstName />
		</cffunction>
		<cffunction name="getFirstName" access="public" output="false" returntype="string">
			<cfreturn _getTo().FirstName />
		</cffunction>	
	
		<!--- LastName --->
		<cffunction name="setLastName" access="public" output="false" returntype="void">
			<cfargument name="LastName" hint="I am this record's LastName value." required="yes" type="string" />
			<cfset _getTo().LastName = arguments.LastName />
		</cffunction>
		<cffunction name="getLastName" access="public" output="false" returntype="string">
			<cfreturn _getTo().LastName />
		</cffunction>	
	
	
	<cffunction name="load" access="public" hint="I load the Contact record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().read(_getTo()) />
	</cffunction>	
	
	<cffunction name="save" access="public" hint="I save the Contact record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void">
		<cfset _getDao().save(_getTo()) />
	</cffunction>	
	
	<cffunction name="delete" access="public" hint="I delete the Contact record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().delete(_getTo()) />
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo("Contact")) />
	</cffunction>
	
	
		<!--- Query For Address --->
		<cffunction name="createAddressQuery" access="public" output="false" returntype="reactor.query.query">
			<cfset var Query = _getReactorFactory().createGateway("Address").createQuery() />
			
			
			
			<cfreturn Query />
		</cffunction>
		
		
				<!--- Query For Address --->
				<cffunction name="getAddressQuery" access="public" output="false" returntype="query">
					<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createAddressQuery()#" type="reactor.query.query" />
					<cfset var AddressGateway = _getReactorFactory().createGateway("Address") />
					
						<cfset arguments.Query.getWhere().isEqual("Address", "contactId", getcontactId()) />
					
					<cfreturn AddressGateway.getByQuery(arguments.Query)>
				</cffunction>
			
		
		<!--- Array For Address --->
		<cffunction name="getAddressArray" access="public" output="false" returntype="array">
			<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createAddressQuery()#" type="reactor.query.query" />
			<cfset var AddressQuery = getAddressQuery(arguments.Query) />
			<cfset var AddressArray = ArrayNew(1) />
			<cfset var AddressRecord = 0 />
			<cfset var AddressTo = 0 />
			<cfset var field = "" />
			
			<cfloop query="AddressQuery">
				<cfset AddressRecord = _getReactorFactory().createRecord("Address") >
				<cfset AddressTo = AddressRecord._getTo() />
	
				<!--- populate the record's to --->
				<cfloop list="#AddressQuery.columnList#" index="field">
					<cfset AddressTo[field] = AddressQuery[field][AddressQuery.currentrow] >
				</cfloop>
				
				<cfset AddressRecord._setTo(AddressTo) />
				
				<cfset AddressArray[ArrayLen(AddressArray) + 1] = AddressRecord >
			</cfloop>
	
			<cfreturn AddressArray />
		</cffunction>		
	
		<!--- Query For EmailAddress --->
		<cffunction name="createEmailAddressQuery" access="public" output="false" returntype="reactor.query.query">
			<cfset var Query = _getReactorFactory().createGateway("EmailAddress").createQuery() />
			
			
			
			<cfreturn Query />
		</cffunction>
		
		
				<!--- Query For EmailAddress --->
				<cffunction name="getEmailAddressQuery" access="public" output="false" returntype="query">
					<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createEmailAddressQuery()#" type="reactor.query.query" />
					<cfset var EmailAddressGateway = _getReactorFactory().createGateway("EmailAddress") />
					
						<cfset arguments.Query.getWhere().isEqual("EmailAddress", "contactId", getcontactId()) />
					
					<cfreturn EmailAddressGateway.getByQuery(arguments.Query)>
				</cffunction>
			
		
		<!--- Array For EmailAddress --->
		<cffunction name="getEmailAddressArray" access="public" output="false" returntype="array">
			<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createEmailAddressQuery()#" type="reactor.query.query" />
			<cfset var EmailAddressQuery = getEmailAddressQuery(arguments.Query) />
			<cfset var EmailAddressArray = ArrayNew(1) />
			<cfset var EmailAddressRecord = 0 />
			<cfset var EmailAddressTo = 0 />
			<cfset var field = "" />
			
			<cfloop query="EmailAddressQuery">
				<cfset EmailAddressRecord = _getReactorFactory().createRecord("EmailAddress") >
				<cfset EmailAddressTo = EmailAddressRecord._getTo() />
	
				<!--- populate the record's to --->
				<cfloop list="#EmailAddressQuery.columnList#" index="field">
					<cfset EmailAddressTo[field] = EmailAddressQuery[field][EmailAddressQuery.currentrow] >
				</cfloop>
				
				<cfset EmailAddressRecord._setTo(EmailAddressTo) />
				
				<cfset EmailAddressArray[ArrayLen(EmailAddressArray) + 1] = EmailAddressRecord >
			</cfloop>
	
			<cfreturn EmailAddressArray />
		</cffunction>		
	
		<!--- Query For PhoneNumber --->
		<cffunction name="createPhoneNumberQuery" access="public" output="false" returntype="reactor.query.query">
			<cfset var Query = _getReactorFactory().createGateway("PhoneNumber").createQuery() />
			
			
			
			<cfreturn Query />
		</cffunction>
		
		
				<!--- Query For PhoneNumber --->
				<cffunction name="getPhoneNumberQuery" access="public" output="false" returntype="query">
					<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createPhoneNumberQuery()#" type="reactor.query.query" />
					<cfset var PhoneNumberGateway = _getReactorFactory().createGateway("PhoneNumber") />
					
						<cfset arguments.Query.getWhere().isEqual("PhoneNumber", "contactId", getcontactId()) />
					
					<cfreturn PhoneNumberGateway.getByQuery(arguments.Query)>
				</cffunction>
			
		
		<!--- Array For PhoneNumber --->
		<cffunction name="getPhoneNumberArray" access="public" output="false" returntype="array">
			<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createPhoneNumberQuery()#" type="reactor.query.query" />
			<cfset var PhoneNumberQuery = getPhoneNumberQuery(arguments.Query) />
			<cfset var PhoneNumberArray = ArrayNew(1) />
			<cfset var PhoneNumberRecord = 0 />
			<cfset var PhoneNumberTo = 0 />
			<cfset var field = "" />
			
			<cfloop query="PhoneNumberQuery">
				<cfset PhoneNumberRecord = _getReactorFactory().createRecord("PhoneNumber") >
				<cfset PhoneNumberTo = PhoneNumberRecord._getTo() />
	
				<!--- populate the record's to --->
				<cfloop list="#PhoneNumberQuery.columnList#" index="field">
					<cfset PhoneNumberTo[field] = PhoneNumberQuery[field][PhoneNumberQuery.currentrow] >
				</cfloop>
				
				<cfset PhoneNumberRecord._setTo(PhoneNumberTo) />
				
				<cfset PhoneNumberArray[ArrayLen(PhoneNumberArray) + 1] = PhoneNumberRecord >
			</cfloop>
	
			<cfreturn PhoneNumberArray />
		</cffunction>		
	
			
	<!--- to --->
	<cffunction name="_setTo" access="public" output="false" returntype="void">
	    <cfargument name="to" hint="I am this record's transfer object." required="yes" type="ReactorSamples.ContactManager.data.To.mssql.ContactTo" />
	    <cfset variables.to = arguments.to />
	</cffunction>
	<cffunction name="_getTo" access="public" output="false" returntype="ReactorSamples.ContactManager.data.To.mssql.ContactTo">
		<cfreturn variables.to />
	</cffunction>	
	
	<!--- dao --->
	<cffunction name="_setDao" access="private" output="false" returntype="void">
	    <cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="ReactorSamples.ContactManager.data.Dao.mssql.ContactDao" />
	    <cfset variables.dao = arguments.dao />
	</cffunction>
	<cffunction name="_getDao" access="private" output="false" returntype="ReactorSamples.ContactManager.data.Dao.mssql.ContactDao">
	    <cfreturn variables.dao />
	</cffunction>
	
</cfcomponent>
	
