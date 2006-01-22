<cfset highestRatedEntries = viewstate.getvalue("highestRatedEntries") />
<cfset mostViewedEntries = viewstate.getValue("mostViewedEntries") />
<cfset mostCommentedOn = viewstate.getValue("mostCommentedOn") />

<h1>Best of the Blog</h1>

<h2>Highest Rated Entries</h2>

<table>
	<tr class="header">
		<td>
			Entry
		</td>
		<td width="100">
			Average Rating
		</td>
	</tr>
	<cfoutput query="highestRatedEntries">
		<tr class="row #Iif(highestRatedEntries.currentRow MOD 2 IS 1, DE('odd'), DE('even'))#">
			<td>
				<a href="index.cfm?event=viewEntry&entryId=#highestRatedEntries.entryId#">#highestRatedEntries.title#</a>
			</td>
			<td>
				#NumberFormat(highestRatedEntries.averageRating, "9.99")# out of 5
			</td>
		</tr>
	</cfoutput>
</table>

<h2>Most Viewed Entries</h2>

<table>
	<tr class="header">
		<td>
			Entry
		</td>
		<td width="100">
			Views
		</td>
	</tr>
	<cfoutput query="mostViewedEntries">
		<tr class="row #Iif(mostViewedEntries.currentRow MOD 2 IS 1, DE('odd'), DE('even'))#">
			<td>
				<a href="index.cfm?event=viewEntry&entryId=#mostViewedEntries.entryId#">#mostViewedEntries.title#</a>
			</td>
			<td>
				#mostViewedEntries.views#
			</td>
		</tr>
	</cfoutput>
</table>


<h2>Most Commented On Entries</h2>

<table>
	<tr class="header">
		<td>
			Entry
		</td>
		<td width="100">
			Comments
		</td>
	</tr>
	<cfoutput query="mostCommentedOn">
		<tr class="row #Iif(mostCommentedOn.currentRow MOD 2 IS 1, DE('odd'), DE('even'))#">
			<td>
				<a href="index.cfm?event=viewEntry&entryId=#mostCommentedOn.entryId#">#mostCommentedOn.title#</a>
			</td>
			<td>
				#mostCommentedOn.comments#
			</td>
		</tr>
	</cfoutput>
</table>
