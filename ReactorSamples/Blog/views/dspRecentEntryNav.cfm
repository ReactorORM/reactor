<cfset recentEntries = viewstate.getValue("recentEntries") />

<h3>Recent Entries</h3>
<ul class="categories">
	<cfoutput query="recentEntries">
		<li><a href="index.cfm?event=viewEntry&entryId=#recentEntries.entryId#">#recentEntries.title#</a></li>
	</cfoutput>
</ul>