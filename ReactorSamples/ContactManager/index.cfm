
<!---

This file uses reactor's Gateway objects to get a list of contacts in your database.

---->

<!--- Create a ContactGateway.  Gateway objects are used to query the database for multiple rows of data --->
<cfset ContactGateway = Application.Reactor.createGateway("Contact") />

<!--- Get all the Contacts in the databaes --->
<cfset contactQuery = ContactGateway.getAll() />

<!--- output the list of contacts --->
<h2>List Contacts</h2>
<cfif contactQuery.recordCount>
	<table border="1" cellpadding="5" cellspacing="0">
		<tr>
			<td style="font-size: 14px; font-weight: bold;">
				First Name
			</td>
			<td style="font-size: 14px; font-weight: bold;">
				Last Name				
			</td>
			<td>&nbsp;</td>
		</tr>
		<cfoutput query="contactQuery">
			<tr>
				<td>
					#contactQuery.firstName#
				</td>
				<td>
					#contactQuery.lastName#
				</td>
				<td>
					<a href="viewContact.cfm?contactId=#contactQuery.contactId#">View</a> |
					<a href="deleteContact.cfm?contactId=#contactQuery.contactId#">Delete</a>
				</td>
			</tr>
		</cfoutput>	
	</table>
<cfelse>
	<p>There are no contacts to list.  <a href="addEditContact.cfm">Click here to create a new contact</a>.</p>
</cfif>


<cfoutput>
	<br /><small style="color: gray;">You are currently running against a #Application.Reactor.createMetadata("Contact").getDbms()# database.</small>
</cfoutput>