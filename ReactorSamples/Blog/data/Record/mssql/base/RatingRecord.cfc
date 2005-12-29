
<cfcomponent hint="I am the base record representing the Rating table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractRecord" >
	
	<cfset variables.signature = "DFDE9A5FA15D8C30E7E437F9293B587D" />
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="ReactorBlogData.Record.mssql.base.RatingRecord">
		
			<cfargument name="RatingId" hint="I am the default value for the  RatingId field." required="no" type="string" default="0" />
		
			<cfargument name="EntryId" hint="I am the default value for the  EntryId field." required="no" type="string" default="0" />
		
			<cfargument name="Rating" hint="I am the default value for the  Rating field." required="no" type="string" default="0" />
		
			<cfset setRatingId(arguments.RatingId) />
		
			<cfset setEntryId(arguments.EntryId) />
		
			<cfset setRating(arguments.Rating) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		
					
					<!--- validate RatingId is numeric --->
					<cfif Len(Trim(getRatingId())) AND NOT IsNumeric(getRatingId())>
						<cfset ValidationErrorCollection.addError("RatingId", ErrorManager.getError("Rating", "RatingId", "invalidType")) />
					</cfif>					
				
					
					<!--- validate EntryId is numeric --->
					<cfif Len(Trim(getEntryId())) AND NOT IsNumeric(getEntryId())>
						<cfset ValidationErrorCollection.addError("EntryId", ErrorManager.getError("Rating", "EntryId", "invalidType")) />
					</cfif>					
				
					
					<!--- validate Rating is numeric --->
					<cfif Len(Trim(getRating())) AND NOT IsNumeric(getRating())>
						<cfset ValidationErrorCollection.addError("Rating", ErrorManager.getError("Rating", "Rating", "invalidType")) />
					</cfif>					
				
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	
		<!--- RatingId --->
		<cffunction name="setRatingId" access="public" output="false" returntype="void">
			<cfargument name="RatingId" hint="I am this record's RatingId value." required="yes" type="string" />
			<cfset _getTo().RatingId = arguments.RatingId />
		</cffunction>
		<cffunction name="getRatingId" access="public" output="false" returntype="string">
			<cfreturn _getTo().RatingId />
		</cffunction>	
	
		<!--- EntryId --->
		<cffunction name="setEntryId" access="public" output="false" returntype="void">
			<cfargument name="EntryId" hint="I am this record's EntryId value." required="yes" type="string" />
			<cfset _getTo().EntryId = arguments.EntryId />
		</cffunction>
		<cffunction name="getEntryId" access="public" output="false" returntype="string">
			<cfreturn _getTo().EntryId />
		</cffunction>	
	
		<!--- Rating --->
		<cffunction name="setRating" access="public" output="false" returntype="void">
			<cfargument name="Rating" hint="I am this record's Rating value." required="yes" type="string" />
			<cfset _getTo().Rating = arguments.Rating />
		</cffunction>
		<cffunction name="getRating" access="public" output="false" returntype="string">
			<cfreturn _getTo().Rating />
		</cffunction>	
	
	
	<cffunction name="load" access="public" hint="I load the Rating record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().read(_getTo()) />
	</cffunction>	
	
	<cffunction name="save" access="public" hint="I save the Rating record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void">
		<cfset _getDao().save(_getTo()) />
	</cffunction>	
	
	<cffunction name="delete" access="public" hint="I delete the Rating record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().delete(_getTo()) />
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo("Rating")) />
	</cffunction>
	
	
			
	<!--- to --->
	<cffunction name="_setTo" access="public" output="false" returntype="void">
	    <cfargument name="to" hint="I am this record's transfer object." required="yes" type="ReactorBlogData.To.mssql.RatingTo" />
	    <cfset variables.to = arguments.to />
	</cffunction>
	<cffunction name="_getTo" access="public" output="false" returntype="ReactorBlogData.To.mssql.RatingTo">
		<cfreturn variables.to />
	</cffunction>	
	
	<!--- dao --->
	<cffunction name="_setDao" access="private" output="false" returntype="void">
	    <cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="ReactorBlogData.Dao.mssql.RatingDao" />
	    <cfset variables.dao = arguments.dao />
	</cffunction>
	<cffunction name="_getDao" access="private" output="false" returntype="ReactorBlogData.Dao.mssql.RatingDao">
	    <cfreturn variables.dao />
	</cffunction>
	
</cfcomponent>
	
