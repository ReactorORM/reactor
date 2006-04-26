
<cfcomponent hint="I am the validator object for the Entry object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.ReactorBlog.Validator.EntryValidator">
	<!--- Place custom code here, it will not be overwritten --->
	
	<!--- validateArticleProvided --->
	<cffunction name="validateArticleProvided" access="public" hint="I validate that the article field was provided" output="false" returntype="reactor.util.ErrorCollection">
		<cfargument name="EntryRecord" hint="I am the EntryRecord to validate." required="no" type="reactor.project.ReactorBlog.Record.EntryRecord" />
		<cfargument name="ErrorCollection" hint="I am the error collection to populate. If not provided a new collection is created." required="no" type="reactor.util.ErrorCollection" default="#createErrorCollection(arguments.EntryRecord._getDictionary())#" />
		<cfset var article = Trim(ReReplaceNoCase(arguments.EntryRecord.getArticle(), '(<(.|\n)+?>)|&.+?;|\r|\n|\t', "", "all")) />
				
		<!--- make sure the user actually provided an article --->
		<cfif NOT Len(article)>
			<cfset arguments.ErrorCollection.addError("Entry.article.notProvided") />
		</cfif>
		
		<cfreturn arguments.ErrorCollection />
	</cffunction>

	
</cfcomponent>
	
