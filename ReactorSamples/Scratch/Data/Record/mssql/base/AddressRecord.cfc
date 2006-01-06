
<cfcomponent hint="I am the base record representing the Address table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractRecord" >
	
	<cfset variables.signature = "83C36EF059D7F69183D9588239ABED3E" />
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="ScratchData.Record.mssql.base.AddressRecord">
		
			<cfargument name="AddressId" hint="I am the default value for the  AddressId field." required="no" type="string" default="0" />
		
			<cfargument name="Street1" hint="I am the default value for the  Street1 field." required="no" type="string" default="" />
		
			<cfargument name="Street2" hint="I am the default value for the  Street2 field." required="no" type="string" default="" />
		
			<cfargument name="City" hint="I am the default value for the  City field." required="no" type="string" default="" />
		
			<cfargument name="State" hint="I am the default value for the  State field." required="no" type="string" default="" />
		
			<cfargument name="Zip" hint="I am the default value for the  Zip field." required="no" type="string" default="" />
		
			<cfset setAddressId(arguments.AddressId) />
		
			<cfset setStreet1(arguments.Street1) />
		
			<cfset setStreet2(arguments.Street2) />
		
			<cfset setCity(arguments.City) />
		
			<cfset setState(arguments.State) />
		
			<cfset setZip(arguments.Zip) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		
					
					<!--- validate AddressId is numeric --->
					<cfif Len(Trim(getAddressId())) AND NOT IsNumeric(getAddressId())>
						<cfset ValidationErrorCollection.addError("AddressId", ErrorManager.getError("Address", "AddressId", "invalidType")) />
					</cfif>					
				
						<!--- validate Street1 is provided --->
						<cfif NOT Len(Trim(getStreet1()))>
							<cfset ValidationErrorCollection.addError("Street1", ErrorManager.getError("Address", "Street1", "notProvided")) />
						</cfif>
					
					
					<!--- validate Street1 is string --->
					<cfif NOT IsSimpleValue(getStreet1())>
						<cfset ValidationErrorCollection.addError("Street1", ErrorManager.getError("Address", "Street1", "invalidType")) />
					</cfif>
					
					<!--- validate Street1 length --->
					<cfif Len(getStreet1()) GT 50 >
						<cfset ValidationErrorCollection.addError("Street1", ErrorManager.getError("Address", "Street1", "invalidLength")) />
					</cfif>					
				
					
					<!--- validate Street2 is string --->
					<cfif NOT IsSimpleValue(getStreet2())>
						<cfset ValidationErrorCollection.addError("Street2", ErrorManager.getError("Address", "Street2", "invalidType")) />
					</cfif>
					
					<!--- validate Street2 length --->
					<cfif Len(getStreet2()) GT 50 >
						<cfset ValidationErrorCollection.addError("Street2", ErrorManager.getError("Address", "Street2", "invalidLength")) />
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
				
						<!--- validate State is provided --->
						<cfif NOT Len(Trim(getState()))>
							<cfset ValidationErrorCollection.addError("State", ErrorManager.getError("Address", "State", "notProvided")) />
						</cfif>
					
					
					<!--- validate State is string --->
					<cfif NOT IsSimpleValue(getState())>
						<cfset ValidationErrorCollection.addError("State", ErrorManager.getError("Address", "State", "invalidType")) />
					</cfif>
					
					<!--- validate State length --->
					<cfif Len(getState()) GT 50 >
						<cfset ValidationErrorCollection.addError("State", ErrorManager.getError("Address", "State", "invalidLength")) />
					</cfif>					
				
						<!--- validate Zip is provided --->
						<cfif NOT Len(Trim(getZip()))>
							<cfset ValidationErrorCollection.addError("Zip", ErrorManager.getError("Address", "Zip", "notProvided")) />
						</cfif>
					
					
					<!--- validate Zip is string --->
					<cfif NOT IsSimpleValue(getZip())>
						<cfset ValidationErrorCollection.addError("Zip", ErrorManager.getError("Address", "Zip", "invalidType")) />
					</cfif>
					
					<!--- validate Zip length --->
					<cfif Len(getZip()) GT 10 >
						<cfset ValidationErrorCollection.addError("Zip", ErrorManager.getError("Address", "Zip", "invalidLength")) />
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
	
		<!--- Street1 --->
		<cffunction name="setStreet1" access="public" output="false" returntype="void">
			<cfargument name="Street1" hint="I am this record's Street1 value." required="yes" type="string" />
			<cfset _getTo().Street1 = arguments.Street1 />
		</cffunction>
		<cffunction name="getStreet1" access="public" output="false" returntype="string">
			<cfreturn _getTo().Street1 />
		</cffunction>	
	
		<!--- Street2 --->
		<cffunction name="setStreet2" access="public" output="false" returntype="void">
			<cfargument name="Street2" hint="I am this record's Street2 value." required="yes" type="string" />
			<cfset _getTo().Street2 = arguments.Street2 />
		</cffunction>
		<cffunction name="getStreet2" access="public" output="false" returntype="string">
			<cfreturn _getTo().Street2 />
		</cffunction>	
	
		<!--- City --->
		<cffunction name="setCity" access="public" output="false" returntype="void">
			<cfargument name="City" hint="I am this record's City value." required="yes" type="string" />
			<cfset _getTo().City = arguments.City />
		</cffunction>
		<cffunction name="getCity" access="public" output="false" returntype="string">
			<cfreturn _getTo().City />
		</cffunction>	
	
		<!--- State --->
		<cffunction name="setState" access="public" output="false" returntype="void">
			<cfargument name="State" hint="I am this record's State value." required="yes" type="string" />
			<cfset _getTo().State = arguments.State />
		</cffunction>
		<cffunction name="getState" access="public" output="false" returntype="string">
			<cfreturn _getTo().State />
		</cffunction>	
	
		<!--- Zip --->
		<cffunction name="setZip" access="public" output="false" returntype="void">
			<cfargument name="Zip" hint="I am this record's Zip value." required="yes" type="string" />
			<cfset _getTo().Zip = arguments.Zip />
		</cffunction>
		<cffunction name="getZip" access="public" output="false" returntype="string">
			<cfreturn _getTo().Zip />
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
	
	
		<!--- Query For Customer --->
		<cffunction name="createCustomerQuery" access="public" output="false" returntype="reactor.query.query">
			<cfset var Query = _getReactorFactory().createGateway("Customer").createQuery() />
			
			
			
			<cfreturn Query />
		</cffunction>
		
		
				<!--- Query For Customer --->
				<cffunction name="getCustomerQuery" access="public" output="false" returntype="query">
					<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createCustomerQuery()#" type="reactor.query.query" />
					<cfset var CustomerGateway = _getReactorFactory().createGateway("Customer") />
					
						<cfset arguments.Query.getWhere().isEqual("Customer", "addressId", getaddressId()) />
					
					<cfreturn CustomerGateway.getByQuery(arguments.Query)>
				</cffunction>
			
		
		<!--- Array For Customer --->
		<cffunction name="getCustomerArray" access="public" output="false" returntype="array">
			<cfargument name="Query" hint="I am the query object to use to filter the results of this method" required="no" default="#createCustomerQuery()#" type="reactor.query.query" />
			<cfset var CustomerQuery = getCustomerQuery(arguments.Query) />
			<cfset var CustomerArray = ArrayNew(1) />
			<cfset var CustomerRecord = 0 />
			<cfset var CustomerTo = 0 />
			<cfset var field = "" />
			
			<cfloop query="CustomerQuery">
				<cfset CustomerRecord = _getReactorFactory().createRecord("Customer") >
				<cfset CustomerTo = CustomerRecord._getTo() />
	
				<!--- populate the record's to --->
				<cfloop list="#CustomerQuery.columnList#" index="field">
					<cfset CustomerTo[field] = CustomerQuery[field][CustomerQuery.currentrow] >
				</cfloop>
				
				<cfset CustomerRecord._setTo(CustomerTo) />
				
				<cfset CustomerArray[ArrayLen(CustomerArray) + 1] = CustomerRecord >
			</cfloop>
	
			<cfreturn CustomerArray />
		</cffunction>		
	
			
	<!--- to --->
	<cffunction name="_setTo" access="public" output="false" returntype="void">
	    <cfargument name="to" hint="I am this record's transfer object." required="yes" type="ScratchData.To.mssql.AddressTo" />
	    <cfset variables.to = arguments.to />
	</cffunction>
	<cffunction name="_getTo" access="public" output="false" returntype="ScratchData.To.mssql.AddressTo">
		<cfreturn variables.to />
	</cffunction>	
	
	<!--- dao --->
	<cffunction name="_setDao" access="private" output="false" returntype="void">
	    <cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="ScratchData.Dao.mssql.AddressDao" />
	    <cfset variables.dao = arguments.dao />
	</cffunction>
	<cffunction name="_getDao" access="private" output="false" returntype="ScratchData.Dao.mssql.AddressDao">
	    <cfreturn variables.dao />
	</cffunction>
	
</cfcomponent>
	
