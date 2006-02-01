
<cfcomponent hint="I am the database agnostic custom Record object for the Comment table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.ReactorBlog.Record.CommentRecord" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		<cfset super.validate(arguments.ValidationErrorCollection) />
		
		<!--- Add custom validation logic here, it will not be overwritten --->
		
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	<cffunction name="formatComment" access="public" hint="I format the comment into html" output="false" returntype="string">
		<cfset var comment = getComment() />
		
		<!--- strip all html --->
		<cfset comment = ReReplace(comment, "<[^<]+?>", "", "all") />
		
		<!--- strip CRs --->
		<cfset comment = StripCR(comment) />
		
		<!--- replace all multiple LFs with </p><p> --->
		<cfset comment = "<p>" & ReReplace(comment, "(\n){2,}", "</p><p>", "all") & "</p>" />
		<!--- replace all single LFs with <br> --->
		<cfset comment = ReReplace(comment, "\n", "<br />", "all") />
		
		<!--- add 2 linebreaks after the </p>s (to make it easier to read) --->
		<cfset comment = Replace(comment, "</p>", "</p>" & chr(13) & chr(10) & chr(13) & chr(10), "all") />
		
		<!--- add 1 linebreak after the <br />s too --->
		<cfset comment = Replace(comment, "<br />", "<br />" & chr(13) & chr(10), "all") />
		
		<cfreturn comment />
	</cffunction>
	

	
</cfcomponent>
	
