
<cfcomponent hint="I am the database agnostic custom Record object for the Entry table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.ReactorBlog.Record.EntryRecord" >
	<!--- Place custom code here, it will not be overwritten --->

	<!--- Iterator For Category --->
	<cffunction name="getCategoryIterator" access="public" output="false" returntype="reactor.iterator.iterator">
		<cfset var CategoryIterator = super.getCategoryIterator() />
		
		<!--- if the iterator is not sorted then sort it --->
		<cfif NOT CategoryIterator.isPopulated()>
			<cfset CategoryIterator.getOrder().setAsc("Category", "name") />
			<cfset CategoryIterator.setDistinct(true) />
		</cfif>
		
		<cfreturn CategoryIterator />
	</cffunction>
		
	<cffunction name="delete" access="public" hint="I delete the Entry record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset var EntryCategoryGateway = _getReactorFactory().createGateway("EntryCategory") />
		
		<!--- delete all categories associated with this entry --->
		<cfset EntryCategoryGateway.deleteByEntryId(getEntryId()) />
				
		<cfset super.delete() />
	</cffunction>
	
	<cffunction name="setArticle" access="public" output="false" returntype="void">
		<cfargument name="article" hint="I am the article html." required="yes" type="string" />
		<cfset var preview = "" />
		<cfset var location = 0 />
		<cfset var newLocation = 0 />
		<cfset var delimiter = "" />
		<cfset var maxLength = Iif(Len(arguments.article) LT 1000, DE(Len(arguments.article)), DE(1000)) />
		<cfset var x = 0 />
		<cfset arguments.article = Trim(arguments.article) />
		
		
		<!--- make sure this is formatted with html --->
		<cfif NOT ReFindNoCase("</p.*?>", arguments.article, location) AND NOT ReFindNoCase("<br.*?>", arguments.article, location)>
			<!--- strip CRs --->
			<cfset arguments.article = StripCR(arguments.article) />
			
			<!--- replace all multiple LFs with </p><p> --->
			<cfset arguments.article = "<p>" & ReReplace(arguments.article, "(\n){2,}", "</p><p>", "all") & "</p>" />
			<!--- replace all single LFs with <br> --->
			<cfset arguments.article = ReReplace(arguments.article, "\n", "<br />", "all") />
			
			<!--- add 2 linebreaks after the </p>s (to make it easier to read) --->
			<cfset arguments.article = Replace(arguments.article, "</p>", "</p>" & chr(13) & chr(10) & chr(13) & chr(10), "all") />
			
			<!--- add 1 linebreak after the <br />s too --->
			<cfset arguments.article = Replace(arguments.article, "<br />", "<br />" & chr(13) & chr(10), "all") />
		</cfif>
		
		<!--- save the article --->
		<cfset super.setArticle(arguments.article) />
		
		<!--- if this has a table, delete everyting from that point forward --->
		<cfif ReFindNoCase("<table.*?>", arguments.article)>
			<cfset arguments.article = Left(arguments.article, ReFindNoCase("<table.*?>", arguments.article) - 1) />
		</cfif>
		<!--- if this has a table, delete everyting from that point forward --->
		<cfif ReFindNoCase("<div.*?>", arguments.article)>
			<cfset arguments.article = Left(arguments.article, ReFindNoCase("<div.*?>", arguments.article) - 1) />
		</cfif>
		
		<!--- what delimits a new line in this entry? --->
		<cfif ReFindNoCase("</p.*?>", arguments.article, location) GT 0>
			<cfset delimiter = "</p.*?>" />
			
		<cfelseif ReFindNoCase("<br.*?>", arguments.article, location) GT 0>
			<cfset delimiter = "<br.*?>" />
			
		<cfelse>
			<cfset delimiter = "\s." />
		
		</cfif>
		
		<!--- create a preview --->
		<cfif Len(arguments.article) GT 1000>
			<cfloop condition="true">
				<cfset newLocation = ReFindNoCase(delimiter, arguments.article, location, true) />
				<cfset newLocation = newLocation.pos[1] + newLocation.len[1] - 1 />
				
				<!--- the 'x' var below is a safety net --->
				<cfif newLocation LTE maxLength AND x LTE 50>
					<cfset x = x + 1 />
					<cfset location = newLocation />
				<cfelse>
					<cfbreak />
				</cfif>
			</cfloop>
			
			<!--- get the preview --->
			<cfif location GT 0>
				<cfset preview = Left(arguments.article, location) />
			</cfif>
		
			<cfset setPreview(preview) />
		<cfelse>
			<!--- too short to bother making a preview of --->
			<cfset setPreview(arguments.article) />
		</cfif>
	</cffunction>
	
	<cffunction name="getCommentCount" access="public" hint="I return the number of comments on this entry" output="false" returntype="numeric">
		<cfreturn getCommentIterator().getRecordCount() />
	</cffunction>
	
	<cffunction name="getRatingCount" access="public" hint="I return the number of ratings on this entry" output="false" returntype="numeric">
		<cfreturn getTimesRated() />
	</cffunction>
	
	<cffunction name="getAverageRating" access="public" hint="I return the average rating for this entry" output="false" returntype="numeric">
		<cfset var rating = 0 />

		<cfif getTimesRated()>
			<cfset rating = Round(getTotalRating()/getTimesRated()) />
		</cfif>

		<cfreturn rating />
	</cffunction>
</cfcomponent>
	
