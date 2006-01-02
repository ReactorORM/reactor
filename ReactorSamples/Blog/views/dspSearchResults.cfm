<cfset searchResults = viewstate.getValue("searchResults") />

<h1>Search Results</h1>

<cfif StructKeyExists(searchResults, "suggestedQuery")>
	<cfoutput>
		<p>You might want to try searching for '<a href="index.cfm?event=search&criteria=#UrlEncodedFormat(searchResults.suggestedQuery)#">#searchResults.suggestedQuery#</a>'.</p>
	</cfoutput>
</cfif>

<cfoutput>
	<p><small>Searched #searchResults.searched# document#Iif(searchResults.searched GT 1, DE('s'), DE(''))# and found #searchResults.found# match#Iif(searchResults.found GT 1, DE('es'), DE(''))# in #searchResults.time# milliseconds.</small></p>
</cfoutput>

<cfif searchResults.found>
	<cfoutput query="searchResults.matches">
		<p>
			<a href="#searchResults.matches.url#">#searchResults.matches.title#</a><br />
			#searchResults.matches.context#<br />
		</p>
	</cfoutput>
<cfelse>
	<p>Sorry, no matches were found for your search.</p>
</cfif>