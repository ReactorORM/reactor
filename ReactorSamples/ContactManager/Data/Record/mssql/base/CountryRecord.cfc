
<cfcomponent hint="I am the base record representing the Country table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractRecord" >
	
	<cfset variables.signature = "96A2CBCD27DBAB19DE1B22D007E5D26C" />
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="ContactManagerData.Record.mssql.base.CountryRecord">
		
			<cfargument name="CountryId" hint="I am the default value for the  CountryId field." required="no" type="string" default="0" />
		
			<cfargument name="Abbreviation" hint="I am the default value for the  Abbreviation field." required="no" type="string" default="" />
		
			<cfargument name="Name" hint="I am the default value for the  Name field." required="no" type="string" default="" />
		
			<cfargument name="SortOrder" hint="I am the default value for the  SortOrder field." required="no" type="string" default="0" />
		
			<cfset setCountryId(arguments.CountryId) />
		
			<cfset setAbbreviation(arguments.Abbreviation) />
		
			<cfset setName(arguments.Name) />
		
			<cfset setSortOrder(arguments.SortOrder) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		
					
					<!--- validate CountryId is numeric --->
					<cfif Len(Trim(getCountryId())) AND NOT IsNumeric(getCountryId())>
						<cfset ValidationErrorCollection.addError("CountryId", ErrorManager.getError("Country", "CountryId", "invalidType")) />
					</cfif>					
				
						<!--- validate Abbreviation is provided --->
						<cfif NOT Len(Trim(getAbbreviation()))>
							<cfset ValidationErrorCollection.addError("Abbreviation", ErrorManager.getError("Country", "Abbreviation", "notProvided")) />
						</cfif>
					
					
					<!--- validate Abbreviation is string --->
					<cfif NOT IsSimpleValue(getAbbreviation())>
						<cfset ValidationErrorCollection.addError("Abbreviation", ErrorManager.getError("Country", "Abbreviation", "invalidType")) />
					</cfif>
					
					<!--- validate Abbreviation length --->
					<cfif Len(getAbbreviation()) GT 10 >
						<cfset ValidationErrorCollection.addError("Abbreviation", ErrorManager.getError("Country", "Abbreviation", "invalidLength")) />
					</cfif>					
				
						<!--- validate Name is provided --->
						<cfif NOT Len(Trim(getName()))>
							<cfset ValidationErrorCollection.addError("Name", ErrorManager.getError("Country", "Name", "notProvided")) />
						</cfif>
					
					
					<!--- validate Name is string --->
					<cfif NOT IsSimpleValue(getName())>
						<cfset ValidationErrorCollection.addError("Name", ErrorManager.getError("Country", "Name", "invalidType")) />
					</cfif>
					
					<!--- validate Name length --->
					<cfif Len(getName()) GT 50 >
						<cfset ValidationErrorCollection.addError("Name", ErrorManager.getError("Country", "Name", "invalidLength")) />
					</cfif>					
				
					
					<!--- validate SortOrder is numeric --->
					<cfif Len(Trim(getSortOrder())) AND NOT IsNumeric(getSortOrder())>
						<cfset ValidationErrorCollection.addError("SortOrder", ErrorManager.getError("Country", "SortOrder", "invalidType")) />
					</cfif>					
				
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	
		<!--- CountryId --->
		<cffunction name="setCountryId" access="public" output="false" returntype="void">
			<cfargument name="CountryId" hint="I am this record's CountryId value." required="yes" type="string" />
			<cfset _getTo().CountryId = arguments.CountryId />
		</cffunction>
		<cffunction name="getCountryId" access="public" output="false" returntype="string">
			<cfreturn _getTo().CountryId />
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
	
		<!--- SortOrder --->
		<cffunction name="setSortOrder" access="public" output="false" returntype="void">
			<cfargument name="SortOrder" hint="I am this record's SortOrder value." required="yes" type="string" />
			<cfset _getTo().SortOrder = arguments.SortOrder />
		</cffunction>
		<cffunction name="getSortOrder" access="public" output="false" returntype="string">
			<cfreturn _getTo().SortOrder />
		</cffunction>	
	
	
	<cffunction name="load" access="public" hint="I load the Country record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().read(_getTo()) />
	</cffunction>	
	
	<cffunction name="save" access="public" hint="I save the Country record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void">
		<cfset _getDao().save(_getTo()) />
	</cffunction>	
	
	<cffunction name="delete" access="public" hint="I delete the Country record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().delete(_getTo()) />
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo("Country")) />
	</cffunction>
	
	
			
	<!--- to --->
	<cffunction name="_setTo" access="public" output="false" returntype="void">
	    <cfargument name="to" hint="I am this record's transfer object." required="yes" type="ContactManagerData.To.mssql.CountryTo" />
	    <cfset variables.to = arguments.to />
	</cffunction>
	<cffunction name="_getTo" access="public" output="false" returntype="ContactManagerData.To.mssql.CountryTo">
		<cfreturn variables.to />
	</cffunction>	
	
	<!--- dao --->
	<cffunction name="_setDao" access="private" output="false" returntype="void">
	    <cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="ContactManagerData.Dao.mssql.CountryDao" />
	    <cfset variables.dao = arguments.dao />
	</cffunction>
	<cffunction name="_getDao" access="private" output="false" returntype="ContactManagerData.Dao.mssql.CountryDao">
	    <cfreturn variables.dao />
	</cffunction>
	
</cfcomponent>
	
