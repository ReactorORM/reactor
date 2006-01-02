<cfset Categories = viewstate.getValue("Categories") />

<h1>Manage Blog Categories</h1>

<p><a href="index.cfm?event=CategoryForm">Create a New Category</a></p>

<cfif Categories.recordcount>
	<table>
		<tr class="header">
			<td>Name</td>
			<td>Entries</td>
			<td>Options</td>
		</tr>
		<cfoutput query="Categories">
			<tr class="row #Iif(Categories.currentRow MOD 2 IS 1, DE('odd'), DE('even'))#">
				<td>
					<a href="index.cfm?filter=category&categoryId=#Categories.categoryId#">#Categories.name#</a>
				</td>
				<td>
					#Categories.entryCount#
				</td>
				<td>
					<a href="index.cfm?event=CategoryForm&categoryId=#Categories.categoryId#">Edit</a>
					|
					<cfif Categories.entryCount>
						<span class="disabled">Delete</span>
					<cfelse>
						<a href="index.cfm?event=DeleteCategory&categoryId=#Categories.categoryId#">Delete</a>
					</cfif>
				</td>
			</tr>
		</cfoutput>
	</table>
</cfif>