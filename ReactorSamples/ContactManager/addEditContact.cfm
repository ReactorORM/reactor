
<!--- default the contactId --->
<cfparam name="url.contactId" default="0" />

<!--- Create a contact record object.  Record objects represent one row in the database and have save, and delete methods --->
<cfset ContactRecord = Application.Reactor.createRecord("Contact") />
<!--- set the contactId for this contact --->
<cfset ContactRecord.setContactId(url.contactId) />

<cfif url.contactId>
	<!--- load the contact from the database --->
	<cfset ContactRecord.load() />
</cfif>

<cfif IsDefined("Form.Submitted")>
	<!--- populate the contactRecord --->
	<cfset ContactRecord.setFirstName(form.FirstName) />
	<cfset ContactRecord.setLastName(form.LastName) />
	
	<!--- validate the contact --->
	<cfset ValidationErrorCollection = ContactRecord.validate() />
	
	<cfif NOT ValidationErrorCollection.hasErrors()>
		<!--- save the contact and redirect to their view --->
		<cfset ContactRecord.save() />
		
		<cflocation url="viewContact.cfm?contactId=#ContactRecord.getContactId()#" />
	</cfif>
</cfif>

<!--- if there were errors saving the contact then output them --->
<cfif IsDefined("ValidationErrorCollection") AND ValidationErrorCollection.hasErrors()>
	<cfset errors = ValidationErrorCollection.getAllErrors() />
	<ul>
	<cfloop from="1" to="#ArrayLen(errors)#" index="x">
		<cfoutput>
			<li>#errors[x]#</li>
		</cfoutput>
	</cfloop>
	</ul>
</cfif>

<!--- show the contact form --->
<h2>Add / Edit a Contact</h2>
<cfform name="addEditContact" action="addEditContact.cfm?contactId=#ContactRecord.getContactId()#">
	<table border="1" cellpadding="5" cellspacing="0">
		<tr>
			<td>
				First Name:
			</td>
			<td>
				<cfinput type="text" name="firstName" value="#ContactRecord.getFirstName()#" />
			</td>
		</tr>
		<tr>
			<td>
				Last Name:
			</td>
			<td>
				<cfinput type="text" name="lastName" value="#ContactRecord.getLastName()#" />
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				<input type="submit" name="Submitted" value="Save Contact" />
			</td>
		</tr>
	</table>
</cfform>