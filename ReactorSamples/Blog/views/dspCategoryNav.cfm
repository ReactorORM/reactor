<cfset Categories = viewstate.getValue("Categories") />

<h3>Categories</h3>
<ul class="categories">
	<cfoutput query="Categories">
		<li><a href="index.cfm?filter=category&categoryId=#Categories.categoryId#">#Categories.name# (#Categories.entryCount#)</a></li>
	</cfoutput>
</ul>