
<cfcomponent hint="I am the base record representing the EntryCategory table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractRecord" >
	
	<cfset variables.signature = "044DEDBE111807360D1608E501B49D78" />
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="ReactorBlogData.Record.mysql.base.EntryCategoryRecord">
		
			<cfargument name="EntryCategoryId" hint="I am the default value for the  EntryCategoryId field." required="no" type="string" default="0" />
		
			<cfargument name="EntryId" hint="I am the default value for the  EntryId field." required="no" type="string" default="0" />
		
			<cfargument name="CategoryId" hint="I am the default value for the  CategoryId field." required="no" type="string" default="0" />
		
			<cfset setEntryCategoryId(arguments.EntryCategoryId) />
		
			<cfset setEntryId(arguments.EntryId) />
		
			<cfset setCategoryId(arguments.CategoryId) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		
					
					<!--- validate EntryCategoryId is numeric --->
					<cfif Len(Trim(getEntryCategoryId())) AND NOT IsNumeric(getEntryCategoryId())>
						<cfset ValidationErrorCollection.addError("EntryCategoryId", ErrorManager.getError("EntryCategory", "EntryCategoryId", "invalidType")) />
					</cfif>					
				
					
					<!--- validate EntryId is numeric --->
					<cfif Len(Trim(getEntryId())) AND NOT IsNumeric(getEntryId())>
						<cfset ValidationErrorCollection.addError("EntryId", ErrorManager.getError("EntryCategory", "EntryId", "invalidType")) />
					</cfif>					
				
					
					<!--- validate CategoryId is numeric --->
					<cfif Len(Trim(getCategoryId())) AND NOT IsNumeric(getCategoryId())>
						<cfset ValidationErrorCollection.addError("CategoryId", ErrorManager.getError("EntryCategory", "CategoryId", "invalidType")) />
					</cfif>					
				
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	
		<!--- EntryCategoryId --->
		<cffunction name="setEntryCategoryId" access="public" output="false" returntype="void">
			<cfargument name="EntryCategoryId" hint="I am this record's EntryCategoryId value." required="yes" type="string" />
			<cfset _getTo().EntryCategoryId = arguments.EntryCategoryId />
		</cffunction>
		<cffunction name="getEntryCategoryId" access="public" output="false" returntype="string">
			<cfreturn _getTo().EntryCategoryId />
		</cffunction>	
	
		<!--- EntryId --->
		<cffunction name="setEntryId" access="public" output="false" returntype="void">
			<cfargument name="EntryId" hint="I am this record's EntryId value." required="yes" type="string" />
			<cfset _getTo().EntryId = arguments.EntryId />
		</cffunction>
		<cffunction name="getEntryId" access="public" output="false" returntype="string">
			<cfreturn _getTo().EntryId />
		</cffunction>	
	
		<!--- CategoryId --->
		<cffunction name="setCategoryId" access="public" output="false" returntype="void">
			<cfargument name="CategoryId" hint="I am this record's CategoryId value." required="yes" type="string" />
			<cfset _getTo().CategoryId = arguments.CategoryId />
		</cffunction>
		<cffunction name="getCategoryId" access="public" output="false" returntype="string">
			<cfreturn _getTo().CategoryId />
		</cffunction>	
	
	
	<cffunction name="load" access="public" hint="I load the EntryCategory record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().read(_getTo()) />
	</cffunction>	
	
	<cffunction name="save" access="public" hint="I save the EntryCategory record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void">
		<cfset _getDao().save(_getTo()) />
	</cffunction>	
	
	<cffunction name="delete" access="public" hint="I delete the EntryCategory record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().delete(_getTo()) />
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo("EntryCategory")) />
	</cffunction>
	
	
	<!--- Record For Entry --->
	<cffunction name="setEntryRecord" access="public" output="false" returntype="void">
	    <cfargument name="Record" hint="I am the Record to set the Entry value from." required="yes" type="ReactorBlogData.Record.mysql.EntryRecord" />
		
			<cfset setentryId(Record.getentryId()) />
		
	</cffunction>
	<cffunction name="getEntryRecord" access="public" output="false" returntype="ReactorBlogData.Record.mysql.EntryRecord">
		<cfset var Record = _getReactorFactory().createRecord("Entry") />
		
			<cfset Record.setentryId(getentryId()) />
		
		<cfset Record.load() />
		<cfreturn Record />
	</cffunction>
	
	<!--- Record For Category --->
	<cffunction name="setCategoryRecord" access="public" output="false" returntype="void">
	    <cfargument name="Record" hint="I am the Record to set the Category value from." required="yes" type="ReactorBlogData.Record.mysql.CategoryRecord" />
		
			<cfset setcategoryId(Record.getcategoryId()) />
		
	</cffunction>
	<cffunction name="getCategoryRecord" access="public" output="false" returntype="ReactorBlogData.Record.mysql.CategoryRecord">
		<cfset var Record = _getReactorFactory().createRecord("Category") />
		
			<cfset Record.setcategoryId(getcategoryId()) />
		
		<cfset Record.load() />
		<cfreturn Record />
	</cffunction>
	
			
	<!--- to --->
	<cffunction name="_setTo" access="public" output="false" returntype="void">
	    <cfargument name="to" hint="I am this record's transfer object." required="yes" type="ReactorBlogData.To.mysql.EntryCategoryTo" />
	    <cfset variables.to = arguments.to />
	</cffunction>
	<cffunction name="_getTo" access="public" output="false" returntype="ReactorBlogData.To.mysql.EntryCategoryTo">
		<cfreturn variables.to />
	</cffunction>	
	
	<!--- dao --->
	<cffunction name="_setDao" access="private" output="false" returntype="void">
	    <cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="ReactorBlogData.Dao.mysql.EntryCategoryDao" />
	    <cfset variables.dao = arguments.dao />
	</cffunction>
	<cffunction name="_getDao" access="private" output="false" returntype="ReactorBlogData.Dao.mysql.EntryCategoryDao">
	    <cfreturn variables.dao />
	</cffunction>
	
</cfcomponent>
	
