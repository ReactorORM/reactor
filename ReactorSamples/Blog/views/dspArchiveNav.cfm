<cfset archives = viewstate.getValue("archives") />

<h3>Archives</h3>
<ul class="categories">
	<cfoutput query="archives">
		<li><a href="index.cfm?filter=date&month=#archives.month#&year=#archives.year#"><span style="float: right;">#archives.entryCount#</span>#MonthAsString(archives.month)# #archives.year#</a></li>
	</cfoutput>
</ul>