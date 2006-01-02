
<cfcomponent hint="I am the base record representing the Comment table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractRecord" >
	
	<cfset variables.signature = "70B044B9DE65C8A35BAB85BF49421FC7" />
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="ReactorBlogData.Record.mssql.base.CommentRecord">
		
			<cfargument name="CommentID" hint="I am the default value for the  CommentID field." required="no" type="string" default="0" />
		
			<cfargument name="EntryId" hint="I am the default value for the  EntryId field." required="no" type="string" default="0" />
		
			<cfargument name="Name" hint="I am the default value for the  Name field." required="no" type="string" default="" />
		
			<cfargument name="EmailAddress" hint="I am the default value for the  EmailAddress field." required="no" type="string" default="" />
		
			<cfargument name="Comment" hint="I am the default value for the  Comment field." required="no" type="string" default="" />
		
			<cfargument name="Posted" hint="I am the default value for the  Posted field." required="no" type="string" default="#Now()#" />
		
			<cfset setCommentID(arguments.CommentID) />
		
			<cfset setEntryId(arguments.EntryId) />
		
			<cfset setName(arguments.Name) />
		
			<cfset setEmailAddress(arguments.EmailAddress) />
		
			<cfset setComment(arguments.Comment) />
		
			<cfset setPosted(arguments.Posted) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		
					
					<!--- validate CommentID is numeric --->
					<cfif Len(Trim(getCommentID())) AND NOT IsNumeric(getCommentID())>
						<cfset ValidationErrorCollection.addError("CommentID", ErrorManager.getError("Comment", "CommentID", "invalidType")) />
					</cfif>					
				
					
					<!--- validate EntryId is numeric --->
					<cfif Len(Trim(getEntryId())) AND NOT IsNumeric(getEntryId())>
						<cfset ValidationErrorCollection.addError("EntryId", ErrorManager.getError("Comment", "EntryId", "invalidType")) />
					</cfif>					
				
						<!--- validate Name is provided --->
						<cfif NOT Len(Trim(getName()))>
							<cfset ValidationErrorCollection.addError("Name", ErrorManager.getError("Comment", "Name", "notProvided")) />
						</cfif>
					
					
					<!--- validate Name is string --->
					<cfif NOT IsSimpleValue(getName())>
						<cfset ValidationErrorCollection.addError("Name", ErrorManager.getError("Comment", "Name", "invalidType")) />
					</cfif>
					
					<!--- validate Name length --->
					<cfif Len(getName()) GT 50 >
						<cfset ValidationErrorCollection.addError("Name", ErrorManager.getError("Comment", "Name", "invalidLength")) />
					</cfif>					
				
					
					<!--- validate EmailAddress is string --->
					<cfif NOT IsSimpleValue(getEmailAddress())>
						<cfset ValidationErrorCollection.addError("EmailAddress", ErrorManager.getError("Comment", "EmailAddress", "invalidType")) />
					</cfif>
					
					<!--- validate EmailAddress length --->
					<cfif Len(getEmailAddress()) GT 50 >
						<cfset ValidationErrorCollection.addError("EmailAddress", ErrorManager.getError("Comment", "EmailAddress", "invalidLength")) />
					</cfif>					
				
						<!--- validate Comment is provided --->
						<cfif NOT Len(Trim(getComment()))>
							<cfset ValidationErrorCollection.addError("Comment", ErrorManager.getError("Comment", "Comment", "notProvided")) />
						</cfif>
					
					
					<!--- validate Comment is string --->
					<cfif NOT IsSimpleValue(getComment())>
						<cfset ValidationErrorCollection.addError("Comment", ErrorManager.getError("Comment", "Comment", "invalidType")) />
					</cfif>
					
					<!--- validate Comment length --->
					<cfif Len(getComment()) GT 2147483647 >
						<cfset ValidationErrorCollection.addError("Comment", ErrorManager.getError("Comment", "Comment", "invalidLength")) />
					</cfif>					
				
						<!--- validate Posted is provided --->
						<cfif NOT Len(Trim(getPosted()))>
							<cfset ValidationErrorCollection.addError("Posted", ErrorManager.getError("Comment", "Posted", "notProvided")) />
						</cfif>
					
					
					<!--- validate Posted is date --->
					<cfif NOT IsDate(getPosted())>
						<cfset ValidationErrorCollection.addError("Posted", ErrorManager.getError("Comment", "Posted", "invalidType")) />
					</cfif>					
				
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	
		<!--- CommentID --->
		<cffunction name="setCommentID" access="public" output="false" returntype="void">
			<cfargument name="CommentID" hint="I am this record's CommentID value." required="yes" type="string" />
			<cfset _getTo().CommentID = arguments.CommentID />
		</cffunction>
		<cffunction name="getCommentID" access="public" output="false" returntype="string">
			<cfreturn _getTo().CommentID />
		</cffunction>	
	
		<!--- EntryId --->
		<cffunction name="setEntryId" access="public" output="false" returntype="void">
			<cfargument name="EntryId" hint="I am this record's EntryId value." required="yes" type="string" />
			<cfset _getTo().EntryId = arguments.EntryId />
		</cffunction>
		<cffunction name="getEntryId" access="public" output="false" returntype="string">
			<cfreturn _getTo().EntryId />
		</cffunction>	
	
		<!--- Name --->
		<cffunction name="setName" access="public" output="false" returntype="void">
			<cfargument name="Name" hint="I am this record's Name value." required="yes" type="string" />
			<cfset _getTo().Name = arguments.Name />
		</cffunction>
		<cffunction name="getName" access="public" output="false" returntype="string">
			<cfreturn _getTo().Name />
		</cffunction>	
	
		<!--- EmailAddress --->
		<cffunction name="setEmailAddress" access="public" output="false" returntype="void">
			<cfargument name="EmailAddress" hint="I am this record's EmailAddress value." required="yes" type="string" />
			<cfset _getTo().EmailAddress = arguments.EmailAddress />
		</cffunction>
		<cffunction name="getEmailAddress" access="public" output="false" returntype="string">
			<cfreturn _getTo().EmailAddress />
		</cffunction>	
	
		<!--- Comment --->
		<cffunction name="setComment" access="public" output="false" returntype="void">
			<cfargument name="Comment" hint="I am this record's Comment value." required="yes" type="string" />
			<cfset _getTo().Comment = arguments.Comment />
		</cffunction>
		<cffunction name="getComment" access="public" output="false" returntype="string">
			<cfreturn _getTo().Comment />
		</cffunction>	
	
		<!--- Posted --->
		<cffunction name="setPosted" access="public" output="false" returntype="void">
			<cfargument name="Posted" hint="I am this record's Posted value." required="yes" type="string" />
			<cfset _getTo().Posted = arguments.Posted />
		</cffunction>
		<cffunction name="getPosted" access="public" output="false" returntype="string">
			<cfreturn _getTo().Posted />
		</cffunction>	
	
	
	<cffunction name="load" access="public" hint="I load the Comment record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().read(_getTo()) />
	</cffunction>	
	
	<cffunction name="save" access="public" hint="I save the Comment record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void">
		<cfset _getDao().save(_getTo()) />
	</cffunction>	
	
	<cffunction name="delete" access="public" hint="I delete the Comment record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().delete(_getTo()) />
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo("Comment")) />
	</cffunction>
	
	
			
	<!--- to --->
	<cffunction name="_setTo" access="public" output="false" returntype="void">
	    <cfargument name="to" hint="I am this record's transfer object." required="yes" type="ReactorBlogData.To.mssql.CommentTo" />
	    <cfset variables.to = arguments.to />
	</cffunction>
	<cffunction name="_getTo" access="public" output="false" returntype="ReactorBlogData.To.mssql.CommentTo">
		<cfreturn variables.to />
	</cffunction>	
	
	<!--- dao --->
	<cffunction name="_setDao" access="private" output="false" returntype="void">
	    <cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="ReactorBlogData.Dao.mssql.CommentDao" />
	    <cfset variables.dao = arguments.dao />
	</cffunction>
	<cffunction name="_getDao" access="private" output="false" returntype="ReactorBlogData.Dao.mssql.CommentDao">
	    <cfreturn variables.dao />
	</cffunction>
	
</cfcomponent>
	
