
<cfcomponent hint="I am the base record representing the Customer table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractRecord" >
	
	<cfset variables.signature = "CCA4E499673B1A3F1C864B58F500D055" />
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="ScratchData.Record.mssql.base.CustomerRecord">
		
			<cfargument name="CustomerId" hint="I am the default value for the  CustomerId field." required="no" type="string" default="0" />
		
			<cfargument name="Username" hint="I am the default value for the  Username field." required="no" type="string" default="" />
		
			<cfargument name="Password" hint="I am the default value for the  Password field." required="no" type="string" default="" />
		
			<cfargument name="FirstName" hint="I am the default value for the  FirstName field." required="no" type="string" default="" />
		
			<cfargument name="LastName" hint="I am the default value for the  LastName field." required="no" type="string" default="" />
		
			<cfargument name="DateCreated" hint="I am the default value for the  DateCreated field." required="no" type="string" default="#Now()#" />
		
			<cfargument name="AddressId" hint="I am the default value for the  AddressId field." required="no" type="string" default="0" />
		
			<cfset setCustomerId(arguments.CustomerId) />
		
			<cfset setUsername(arguments.Username) />
		
			<cfset setPassword(arguments.Password) />
		
			<cfset setFirstName(arguments.FirstName) />
		
			<cfset setLastName(arguments.LastName) />
		
			<cfset setDateCreated(arguments.DateCreated) />
		
			<cfset setAddressId(arguments.AddressId) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		
					
					<!--- validate CustomerId is numeric --->
					<cfif Len(Trim(getCustomerId())) AND NOT IsNumeric(getCustomerId())>
						<cfset ValidationErrorCollection.addError("CustomerId", ErrorManager.getError("Customer", "CustomerId", "invalidType")) />
					</cfif>					
				
						<!--- validate Username is provided --->
						<cfif NOT Len(Trim(getUsername()))>
							<cfset ValidationErrorCollection.addError("Username", ErrorManager.getError("Customer", "Username", "notProvided")) />
						</cfif>
					
					
					<!--- validate Username is string --->
					<cfif NOT IsSimpleValue(getUsername())>
						<cfset ValidationErrorCollection.addError("Username", ErrorManager.getError("Customer", "Username", "invalidType")) />
					</cfif>
					
					<!--- validate Username length --->
					<cfif Len(getUsername()) GT 50 >
						<cfset ValidationErrorCollection.addError("Username", ErrorManager.getError("Customer", "Username", "invalidLength")) />
					</cfif>					
				
						<!--- validate Password is provided --->
						<cfif NOT Len(Trim(getPassword()))>
							<cfset ValidationErrorCollection.addError("Password", ErrorManager.getError("Customer", "Password", "notProvided")) />
						</cfif>
					
					
					<!--- validate Password is string --->
					<cfif NOT IsSimpleValue(getPassword())>
						<cfset ValidationErrorCollection.addError("Password", ErrorManager.getError("Customer", "Password", "invalidType")) />
					</cfif>
					
					<!--- validate Password length --->
					<cfif Len(getPassword()) GT 50 >
						<cfset ValidationErrorCollection.addError("Password", ErrorManager.getError("Customer", "Password", "invalidLength")) />
					</cfif>					
				
						<!--- validate FirstName is provided --->
						<cfif NOT Len(Trim(getFirstName()))>
							<cfset ValidationErrorCollection.addError("FirstName", ErrorManager.getError("Customer", "FirstName", "notProvided")) />
						</cfif>
					
					
					<!--- validate FirstName is string --->
					<cfif NOT IsSimpleValue(getFirstName())>
						<cfset ValidationErrorCollection.addError("FirstName", ErrorManager.getError("Customer", "FirstName", "invalidType")) />
					</cfif>
					
					<!--- validate FirstName length --->
					<cfif Len(getFirstName()) GT 50 >
						<cfset ValidationErrorCollection.addError("FirstName", ErrorManager.getError("Customer", "FirstName", "invalidLength")) />
					</cfif>					
				
						<!--- validate LastName is provided --->
						<cfif NOT Len(Trim(getLastName()))>
							<cfset ValidationErrorCollection.addError("LastName", ErrorManager.getError("Customer", "LastName", "notProvided")) />
						</cfif>
					
					
					<!--- validate LastName is string --->
					<cfif NOT IsSimpleValue(getLastName())>
						<cfset ValidationErrorCollection.addError("LastName", ErrorManager.getError("Customer", "LastName", "invalidType")) />
					</cfif>
					
					<!--- validate LastName length --->
					<cfif Len(getLastName()) GT 50 >
						<cfset ValidationErrorCollection.addError("LastName", ErrorManager.getError("Customer", "LastName", "invalidLength")) />
					</cfif>					
				
						<!--- validate DateCreated is provided --->
						<cfif NOT Len(Trim(getDateCreated()))>
							<cfset ValidationErrorCollection.addError("DateCreated", ErrorManager.getError("Customer", "DateCreated", "notProvided")) />
						</cfif>
					
					
					<!--- validate DateCreated is date --->
					<cfif NOT IsDate(getDateCreated())>
						<cfset ValidationErrorCollection.addError("DateCreated", ErrorManager.getError("Customer", "DateCreated", "invalidType")) />
					</cfif>					
				
					
					<!--- validate AddressId is numeric --->
					<cfif Len(Trim(getAddressId())) AND NOT IsNumeric(getAddressId())>
						<cfset ValidationErrorCollection.addError("AddressId", ErrorManager.getError("Customer", "AddressId", "invalidType")) />
					</cfif>					
				
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	
		<!--- CustomerId --->
		<cffunction name="setCustomerId" access="public" output="false" returntype="void">
			<cfargument name="CustomerId" hint="I am this record's CustomerId value." required="yes" type="string" />
			<cfset _getTo().CustomerId = arguments.CustomerId />
		</cffunction>
		<cffunction name="getCustomerId" access="public" output="false" returntype="string">
			<cfreturn _getTo().CustomerId />
		</cffunction>	
	
		<!--- Username --->
		<cffunction name="setUsername" access="public" output="false" returntype="void">
			<cfargument name="Username" hint="I am this record's Username value." required="yes" type="string" />
			<cfset _getTo().Username = arguments.Username />
		</cffunction>
		<cffunction name="getUsername" access="public" output="false" returntype="string">
			<cfreturn _getTo().Username />
		</cffunction>	
	
		<!--- Password --->
		<cffunction name="setPassword" access="public" output="false" returntype="void">
			<cfargument name="Password" hint="I am this record's Password value." required="yes" type="string" />
			<cfset _getTo().Password = arguments.Password />
		</cffunction>
		<cffunction name="getPassword" access="public" output="false" returntype="string">
			<cfreturn _getTo().Password />
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
	
		<!--- DateCreated --->
		<cffunction name="setDateCreated" access="public" output="false" returntype="void">
			<cfargument name="DateCreated" hint="I am this record's DateCreated value." required="yes" type="string" />
			<cfset _getTo().DateCreated = arguments.DateCreated />
		</cffunction>
		<cffunction name="getDateCreated" access="public" output="false" returntype="string">
			<cfreturn _getTo().DateCreated />
		</cffunction>	
	
		<!--- AddressId --->
		<cffunction name="setAddressId" access="public" output="false" returntype="void">
			<cfargument name="AddressId" hint="I am this record's AddressId value." required="yes" type="string" />
			<cfset _getTo().AddressId = arguments.AddressId />
		</cffunction>
		<cffunction name="getAddressId" access="public" output="false" returntype="string">
			<cfreturn _getTo().AddressId />
		</cffunction>	
	
	
	<cffunction name="load" access="public" hint="I load the Customer record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().read(_getTo()) />
	</cffunction>	
	
	<cffunction name="save" access="public" hint="I save the Customer record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void">
		<cfset _getDao().save(_getTo()) />
	</cffunction>	
	
	<cffunction name="delete" access="public" hint="I delete the Customer record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().delete(_getTo()) />
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo("Customer")) />
	</cffunction>
	
	
	<!--- Record For Address --->
	<cffunction name="setAddressRecord" access="public" output="false" returntype="void">
	    <cfargument name="Record" hint="I am the Record to set the Address value from." required="yes" type="ScratchData.Record.mssql.AddressRecord" />
		
			<cfset setaddressId(Record.getaddressId()) />
		
	</cffunction>
	<cffunction name="getAddressRecord" access="public" output="false" returntype="ScratchData.Record.mssql.AddressRecord">
		<cfset var Record = _getReactorFactory().createRecord("Address") />
		
			<cfset Record.setaddressId(getaddressId()) />
		
		<cfset Record.load() />
		<cfreturn Record />
	</cffunction>
	
			
	<!--- to --->
	<cffunction name="_setTo" access="public" output="false" returntype="void">
	    <cfargument name="to" hint="I am this record's transfer object." required="yes" type="ScratchData.To.mssql.CustomerTo" />
	    <cfset variables.to = arguments.to />
	</cffunction>
	<cffunction name="_getTo" access="public" output="false" returntype="ScratchData.To.mssql.CustomerTo">
		<cfreturn variables.to />
	</cffunction>	
	
	<!--- dao --->
	<cffunction name="_setDao" access="private" output="false" returntype="void">
	    <cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="ScratchData.Dao.mssql.CustomerDao" />
	    <cfset variables.dao = arguments.dao />
	</cffunction>
	<cffunction name="_getDao" access="private" output="false" returntype="ScratchData.Dao.mssql.CustomerDao">
	    <cfreturn variables.dao />
	</cffunction>
	
</cfcomponent>
	
