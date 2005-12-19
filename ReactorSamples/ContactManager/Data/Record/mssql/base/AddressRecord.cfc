
<cfcomponent hint="I am the base record representing the Address table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractRecord" >
	
	<cfset variables.signature = "21A2E5B68F903F232359A5EE1C80F954" />
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="ReactorSamples.ContactManager.data.Record.mssql.base.AddressRecord">
		
			<cfargument name="AddressId" hint="I am the default value for the  AddressId field." required="no" type="string" default="0" />
		
			<cfargument name="ContactId" hint="I am the default value for the  ContactId field." required="no" type="string" default="0" />
		
			<cfargument name="Line1" hint="I am the default value for the  Line1 field." required="no" type="string" default="" />
		
			<cfargument name="Line2" hint="I am the default value for the  Line2 field." required="no" type="string" default="" />
		
			<cfargument name="City" hint="I am the default value for the  City field." required="no" type="string" default="" />
		
			<cfargument name="StateId" hint="I am the default value for the  StateId field." required="no" type="string" default="" />
		
			<cfargument name="PostalCode" hint="I am the default value for the  PostalCode field." required="no" type="string" default="" />
		
			<cfargument name="CountryId" hint="I am the default value for the  CountryId field." required="no" type="string" default="0" />
		
			<cfset setAddressId(arguments.AddressId) />
		
			<cfset setContactId(arguments.ContactId) />
		
			<cfset setLine1(arguments.Line1) />
		
			<cfset setLine2(arguments.Line2) />
		
			<cfset setCity(arguments.City) />
		
			<cfset setStateId(arguments.StateId) />
		
			<cfset setPostalCode(arguments.PostalCode) />
		
			<cfset setCountryId(arguments.CountryId) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		
					
					<!--- validate AddressId is numeric --->
					<cfif Len(Trim(getAddressId())) AND NOT IsNumeric(getAddressId())>
						<cfset ValidationErrorCollection.addError("AddressId", ErrorManager.getError("Address", "AddressId", "invalidType")) />
					</cfif>					
				
					
					<!--- validate ContactId is numeric --->
					<cfif Len(Trim(getContactId())) AND NOT IsNumeric(getContactId())>
						<cfset ValidationErrorCollection.addError("ContactId", ErrorManager.getError("Address", "ContactId", "invalidType")) />
					</cfif>					
				
						<!--- validate Line1 is provided --->
						<cfif NOT Len(Trim(getLine1()))>
							<cfset ValidationErrorCollection.addError("Line1", ErrorManager.getError("Address", "Line1", "notProvided")) />
						</cfif>
					
					
					<!--- validate Line1 is string --->
					<cfif NOT IsSimpleValue(getLine1())>
						<cfset ValidationErrorCollection.addError("Line1", ErrorManager.getError("Address", "Line1", "invalidType")) />
					</cfif>
					
					<!--- validate Line1 length --->
					<cfif Len(getLine1()) GT 50 >
						<cfset ValidationErrorCollection.addError("Line1", ErrorManager.getError("Address", "Line1", "invalidLength")) />
					</cfif>					
				
					
					<!--- validate Line2 is string --->
					<cfif NOT IsSimpleValue(getLine2())>
						<cfset ValidationErrorCollection.addError("Line2", ErrorManager.getError("Address", "Line2", "invalidType")) />
					</cfif>
					
					<!--- validate Line2 length --->
					<cfif Len(getLine2()) GT 50 >
						<cfset ValidationErrorCollection.addError("Line2", ErrorManager.getError("Address", "Line2", "invalidLength")) />
					</cfif>					
				
						<!--- validate City is provided --->
						<cfif NOT Len(Trim(getCity()))>
							<cfset ValidationErrorCollection.addError("City", ErrorManager.getError("Address", "City", "notProvided")) />
						</cfif>
					
					
					<!--- validate City is string --->
					<cfif NOT IsSimpleValue(getCity())>
						<cfset ValidationErrorCollection.addError("City", ErrorManager.getError("Address", "City", "invalidType")) />
					</cfif>
					
					<!--- validate City length --->
					<cfif Len(getCity()) GT 50 >
						<cfset ValidationErrorCollection.addError("City", ErrorManager.getError("Address", "City", "invalidLength")) />
					</cfif>					
				
					
					<!--- validate StateId is numeric --->
					<cfif Len(Trim(getStateId())) AND NOT IsNumeric(getStateId())>
						<cfset ValidationErrorCollection.addError("StateId", ErrorManager.getError("Address", "StateId", "invalidType")) />
					</cfif>					
				
						<!--- validate PostalCode is provided --->
						<cfif NOT Len(Trim(getPostalCode()))>
							<cfset ValidationErrorCollection.addError("PostalCode", ErrorManager.getError("Address", "PostalCode", "notProvided")) />
						</cfif>
					
					
					<!--- validate PostalCode is string --->
					<cfif NOT IsSimpleValue(getPostalCode())>
						<cfset ValidationErrorCollection.addError("PostalCode", ErrorManager.getError("Address", "PostalCode", "invalidType")) />
					</cfif>
					
					<!--- validate PostalCode length --->
					<cfif Len(getPostalCode()) GT 20 >
						<cfset ValidationErrorCollection.addError("PostalCode", ErrorManager.getError("Address", "PostalCode", "invalidLength")) />
					</cfif>					
				
					
					<!--- validate CountryId is numeric --->
					<cfif Len(Trim(getCountryId())) AND NOT IsNumeric(getCountryId())>
						<cfset ValidationErrorCollection.addError("CountryId", ErrorManager.getError("Address", "CountryId", "invalidType")) />
					</cfif>					
				
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	
		<!--- AddressId --->
		<cffunction name="setAddressId" access="public" output="false" returntype="void">
			<cfargument name="AddressId" hint="I am this record's AddressId value." required="yes" type="string" />
			<cfset _getTo().AddressId = arguments.AddressId />
		</cffunction>
		<cffunction name="getAddressId" access="public" output="false" returntype="string">
			<cfreturn _getTo().AddressId />
		</cffunction>	
	
		<!--- ContactId --->
		<cffunction name="setContactId" access="public" output="false" returntype="void">
			<cfargument name="ContactId" hint="I am this record's ContactId value." required="yes" type="string" />
			<cfset _getTo().ContactId = arguments.ContactId />
		</cffunction>
		<cffunction name="getContactId" access="public" output="false" returntype="string">
			<cfreturn _getTo().ContactId />
		</cffunction>	
	
		<!--- Line1 --->
		<cffunction name="setLine1" access="public" output="false" returntype="void">
			<cfargument name="Line1" hint="I am this record's Line1 value." required="yes" type="string" />
			<cfset _getTo().Line1 = arguments.Line1 />
		</cffunction>
		<cffunction name="getLine1" access="public" output="false" returntype="string">
			<cfreturn _getTo().Line1 />
		</cffunction>	
	
		<!--- Line2 --->
		<cffunction name="setLine2" access="public" output="false" returntype="void">
			<cfargument name="Line2" hint="I am this record's Line2 value." required="yes" type="string" />
			<cfset _getTo().Line2 = arguments.Line2 />
		</cffunction>
		<cffunction name="getLine2" access="public" output="false" returntype="string">
			<cfreturn _getTo().Line2 />
		</cffunction>	
	
		<!--- City --->
		<cffunction name="setCity" access="public" output="false" returntype="void">
			<cfargument name="City" hint="I am this record's City value." required="yes" type="string" />
			<cfset _getTo().City = arguments.City />
		</cffunction>
		<cffunction name="getCity" access="public" output="false" returntype="string">
			<cfreturn _getTo().City />
		</cffunction>	
	
		<!--- StateId --->
		<cffunction name="setStateId" access="public" output="false" returntype="void">
			<cfargument name="StateId" hint="I am this record's StateId value." required="yes" type="string" />
			<cfset _getTo().StateId = arguments.StateId />
		</cffunction>
		<cffunction name="getStateId" access="public" output="false" returntype="string">
			<cfreturn _getTo().StateId />
		</cffunction>	
	
		<!--- PostalCode --->
		<cffunction name="setPostalCode" access="public" output="false" returntype="void">
			<cfargument name="PostalCode" hint="I am this record's PostalCode value." required="yes" type="string" />
			<cfset _getTo().PostalCode = arguments.PostalCode />
		</cffunction>
		<cffunction name="getPostalCode" access="public" output="false" returntype="string">
			<cfreturn _getTo().PostalCode />
		</cffunction>	
	
		<!--- CountryId --->
		<cffunction name="setCountryId" access="public" output="false" returntype="void">
			<cfargument name="CountryId" hint="I am this record's CountryId value." required="yes" type="string" />
			<cfset _getTo().CountryId = arguments.CountryId />
		</cffunction>
		<cffunction name="getCountryId" access="public" output="false" returntype="string">
			<cfreturn _getTo().CountryId />
		</cffunction>	
	
	
	<cffunction name="load" access="public" hint="I load the Address record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().read(_getTo()) />
	</cffunction>	
	
	<cffunction name="save" access="public" hint="I save the Address record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void">
		<cfset _getDao().save(_getTo()) />
	</cffunction>	
	
	<cffunction name="delete" access="public" hint="I delete the Address record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().delete(_getTo()) />
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo("Address")) />
	</cffunction>
	
	
	<!--- Record For State --->
	<cffunction name="setStateRecord" access="public" output="false" returntype="void">
	    <cfargument name="Record" hint="I am the Record to set the State value from." required="yes" type="ReactorSamples.ContactManager.data.Record.mssql.StateRecord" />
		
			<cfset setstateId(Record.getstateId()) />
		
	</cffunction>
	<cffunction name="getStateRecord" access="public" output="false" returntype="ReactorSamples.ContactManager.data.Record.mssql.StateRecord">
		<cfset var Record = _getReactorFactory().createRecord("State") />
		
			<cfset Record.setstateId(getstateId()) />
		
		<cfset Record.load() />
		<cfreturn Record />
	</cffunction>
	
	<!--- Record For Country --->
	<cffunction name="setCountryRecord" access="public" output="false" returntype="void">
	    <cfargument name="Record" hint="I am the Record to set the Country value from." required="yes" type="ReactorSamples.ContactManager.data.Record.mssql.CountryRecord" />
		
			<cfset setcountryId(Record.getcountryId()) />
		
	</cffunction>
	<cffunction name="getCountryRecord" access="public" output="false" returntype="ReactorSamples.ContactManager.data.Record.mssql.CountryRecord">
		<cfset var Record = _getReactorFactory().createRecord("Country") />
		
			<cfset Record.setcountryId(getcountryId()) />
		
		<cfset Record.load() />
		<cfreturn Record />
	</cffunction>
	
			
	<!--- to --->
	<cffunction name="_setTo" access="public" output="false" returntype="void">
	    <cfargument name="to" hint="I am this record's transfer object." required="yes" type="ReactorSamples.ContactManager.data.To.mssql.AddressTo" />
	    <cfset variables.to = arguments.to />
	</cffunction>
	<cffunction name="_getTo" access="public" output="false" returntype="ReactorSamples.ContactManager.data.To.mssql.AddressTo">
		<cfreturn variables.to />
	</cffunction>	
	
	<!--- dao --->
	<cffunction name="_setDao" access="private" output="false" returntype="void">
	    <cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="ReactorSamples.ContactManager.data.Dao.mssql.AddressDao" />
	    <cfset variables.dao = arguments.dao />
	</cffunction>
	<cffunction name="_getDao" access="private" output="false" returntype="ReactorSamples.ContactManager.data.Dao.mssql.AddressDao">
	    <cfreturn variables.dao />
	</cffunction>
	
</cfcomponent>
	
