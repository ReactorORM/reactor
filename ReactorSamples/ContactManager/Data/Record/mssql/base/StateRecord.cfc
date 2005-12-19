
<cfcomponent hint="I am the base record representing the State table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractRecord" >
	
	<cfset variables.signature = "208F6ACA3B35ADF1A45F3F56E12BD13A" />
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="ReactorSamples.ContactManager.data.Record.mssql.base.StateRecord">
		
			<cfargument name="StateId" hint="I am the default value for the  StateId field." required="no" type="string" default="0" />
		
			<cfargument name="Abbreviation" hint="I am the default value for the  Abbreviation field." required="no" type="string" default="" />
		
			<cfargument name="Name" hint="I am the default value for the  Name field." required="no" type="string" default="" />
		
			<cfset setStateId(arguments.StateId) />
		
			<cfset setAbbreviation(arguments.Abbreviation) />
		
			<cfset setName(arguments.Name) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		
					
					<!--- validate StateId is numeric --->
					<cfif Len(Trim(getStateId())) AND NOT IsNumeric(getStateId())>
						<cfset ValidationErrorCollection.addError("StateId", ErrorManager.getError("State", "StateId", "invalidType")) />
					</cfif>					
				
						<!--- validate Abbreviation is provided --->
						<cfif NOT Len(Trim(getAbbreviation()))>
							<cfset ValidationErrorCollection.addError("Abbreviation", ErrorManager.getError("State", "Abbreviation", "notProvided")) />
						</cfif>
					
					
					<!--- validate Abbreviation is string --->
					<cfif NOT IsSimpleValue(getAbbreviation())>
						<cfset ValidationErrorCollection.addError("Abbreviation", ErrorManager.getError("State", "Abbreviation", "invalidType")) />
					</cfif>
					
					<!--- validate Abbreviation length --->
					<cfif Len(getAbbreviation()) GT 5 >
						<cfset ValidationErrorCollection.addError("Abbreviation", ErrorManager.getError("State", "Abbreviation", "invalidLength")) />
					</cfif>					
				
						<!--- validate Name is provided --->
						<cfif NOT Len(Trim(getName()))>
							<cfset ValidationErrorCollection.addError("Name", ErrorManager.getError("State", "Name", "notProvided")) />
						</cfif>
					
					
					<!--- validate Name is string --->
					<cfif NOT IsSimpleValue(getName())>
						<cfset ValidationErrorCollection.addError("Name", ErrorManager.getError("State", "Name", "invalidType")) />
					</cfif>
					
					<!--- validate Name length --->
					<cfif Len(getName()) GT 50 >
						<cfset ValidationErrorCollection.addError("Name", ErrorManager.getError("State", "Name", "invalidLength")) />
					</cfif>					
				
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	
		<!--- StateId --->
		<cffunction name="setStateId" access="public" output="false" returntype="void">
			<cfargument name="StateId" hint="I am this record's StateId value." required="yes" type="string" />
			<cfset _getTo().StateId = arguments.StateId />
		</cffunction>
		<cffunction name="getStateId" access="public" output="false" returntype="string">
			<cfreturn _getTo().StateId />
		</cffunction>	
	
		<!--- Abbreviation --->
		<cffunction name="setAbbreviation" access="public" output="false" returntype="void">
			<cfargument name="Abbreviation" hint="I am this record's Abbreviation value." required="yes" type="string" />
			<cfset _getTo().Abbreviation = arguments.Abbreviation />
		</cffunction>
		<cffunction name="getAbbreviation" access="public" output="false" returntype="string">
			<cfreturn _getTo().Abbreviation />
		</cffunction>	
	
		<!--- Name --->
		<cffunction name="setName" access="public" output="false" returntype="void">
			<cfargument name="Name" hint="I am this record's Name value." required="yes" type="string" />
			<cfset _getTo().Name = arguments.Name />
		</cffunction>
		<cffunction name="getName" access="public" output="false" returntype="string">
			<cfreturn _getTo().Name />
		</cffunction>	
	
	
	<cffunction name="load" access="public" hint="I load the State record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().read(_getTo()) />
	</cffunction>	
	
	<cffunction name="save" access="public" hint="I save the State record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void">
		<cfset _getDao().save(_getTo()) />
	</cffunction>	
	
	<cffunction name="delete" access="public" hint="I delete the State record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().delete(_getTo()) />
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo("State")) />
	</cffunction>
	
	
			
	<!--- to --->
	<cffunction name="_setTo" access="public" output="false" returntype="void">
	    <cfargument name="to" hint="I am this record's transfer object." required="yes" type="ReactorSamples.ContactManager.data.To.mssql.StateTo" />
	    <cfset variables.to = arguments.to />
	</cffunction>
	<cffunction name="_getTo" access="public" output="false" returntype="ReactorSamples.ContactManager.data.To.mssql.StateTo">
		<cfreturn variables.to />
	</cffunction>	
	
	<!--- dao --->
	<cffunction name="_setDao" access="private" output="false" returntype="void">
	    <cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="ReactorSamples.ContactManager.data.Dao.mssql.StateDao" />
	    <cfset variables.dao = arguments.dao />
	</cffunction>
	<cffunction name="_getDao" access="private" output="false" returntype="ReactorSamples.ContactManager.data.Dao.mssql.StateDao">
	    <cfreturn variables.dao />
	</cffunction>
	
</cfcomponent>
	
