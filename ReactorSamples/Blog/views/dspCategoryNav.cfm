<cfset Categories = viewstate.getValue("Categories") />

<h3>Categories</h3>
<ul class="categories">
	<cfoutput query="Categories">
		<li>
			<span style="float: right; margin-left: 10px;"><a href="index.cfm?event=rss&categoryId=#Categories.categoryId#" class="rss">RSS</a></span>
			<a href="index.cfm?filter=category&categoryId=#Categories.categoryId#"><span style="float: right;">#Categories.entryCount#</span>
			#Categories.name#</a>
		</li>
	</cfoutput>
</ul>