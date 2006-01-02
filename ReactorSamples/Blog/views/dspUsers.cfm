<cfset Users = viewstate.getValue("Users") />

<h1>Manage Blog Users</h1>

<p><a href="index.cfm?event=UserForm">Create a New User</a></p>

<cfif Users.recordcount>
	<table>
		<tr class="header">
			<td>Full Name</td>
			<td>User Name</td>
			<td>Entries</td>
			<td>Options</td>
		</tr>
		<cfoutput query="Users">
			<tr class="row #Iif(Users.currentRow MOD 2 IS 1, DE('odd'), DE('even'))#">
				<td>
					#Users.firstName# #Users.lastName#
				</td>
				<td>
					#Users.userName#
				</td>
				<td>
					#Users.entryCount#
				</td>
				<td>
					<a href="index.cfm?event=UserForm&userId=#Users.userId#">Edit</a>
					|
					<cfif Users.entryCount>
						<span class="disabled">Delete</span>
					<cfelse>
						<a href="index.cfm?event=DeleteUser&userId=#Users.userId#">Delete</a>
					</cfif>
				</td>
			</tr>
		</cfoutput>
	</table>
</cfif>