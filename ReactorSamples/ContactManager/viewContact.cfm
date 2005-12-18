
<cfparam name="form.Submitted" default="" />

<!--- default some new records --->
<cfset NewEmailAddressRecord = Application.Reactor.createRecord("EmailAddress") />
<cfset NewAddressRecord = Application.Reactor.createRecord("Address") />
<cfset NewPhoneNumberRecord = Application.Reactor.createRecord("PhoneNumber") />

<cfswitch expression="#form.Submitted#">
	<cfcase value="Add Email">
		<!--- create a new Email record --->
		<cfset NewEmailAddressRecord.setContactId(url.contactId) />
		<cfset NewEmailAddressRecord.setEmailAddress(form.EmailAddress) />
		
		<!--- validate the email address --->
		<cfset EmailAddressVerificationErrorCollection = NewEmailAddressRecord.validate() />
		
		<cfif NOT EmailAddressVerificationErrorCollection.hasErrors()>
			<cfset NewEmailAddressRecord.save() />
			<!--- this is a cheap way to reset the form --->
			<cflocation url="viewContact.cfm?contactId=#url.contactId#" />
		</cfif>		
	</cfcase>
	
	<cfcase value="Add Address">
		<!--- create a new address record --->
		<cfset NewAddressRecord.setContactId(url.contactId) />
		<cfset NewAddressRecord.setLine1(form.line1) />
		<cfset NewAddressRecord.setLine2(form.line2) />
		<cfset NewAddressRecord.setCity(form.city) />
		<cfset NewAddressRecord.setStateId(form.stateId) />
		<cfset NewAddressRecord.setPostalCode(form.postalCode) />
		<cfset NewAddressRecord.setCountryId(form.countryId) />
		
		<!--- validate the email address --->
		<cfset AddressVerificationErrorCollection = NewAddressRecord.validate() />
		
		<cfif NOT AddressVerificationErrorCollection.hasErrors()>
			<cfset NewAddressRecord.save() />
			<!--- this is a cheap way to reset the form --->
			<cflocation url="viewContact.cfm?contactId=#url.contactId#" />
		</cfif>		
	</cfcase>
	
	<cfcase value="Add Phone Number">
		<!--- create a new Phone record --->
		<cfset NewPhoneNumberRecord.setContactId(url.contactId) />
		<cfset NewPhoneNumberRecord.setPhoneNumber(form.phoneNumber) />
		
		<!--- validate the email address --->
		<cfset PhoneNumberVerificationErrorCollection = NewPhoneNumberRecord.validate() />
		
		<cfif NOT PhoneNumberVerificationErrorCollection.hasErrors()>
			<cfset NewPhoneNumberRecord.save() />
			<!--- this is a cheap way to reset the form --->
			<cflocation url="viewContact.cfm?contactId=#url.contactId#" />
		</cfif>		
	</cfcase>
	
	
	
	
</cfswitch>

<!--- get all the states --->
<cfset stateQuery = Application.Reactor.createGateway("State").getAll() />
<!--- get all countries, but sort so the US shows first (sorry rest of the world!) --->
<cfset CountryGateway = Application.Reactor.createGateway("Country") />
<cfset CountryQuery = CountryGateway.createQuery() />
<!--- sort the query based on the sortOrder Column and then the name of the country --->
<cfset CountryQuery.getOrder().setDesc("Country", "sortOrder").setAsc("Country", "Name") />
<!--- overwrite the query object with the actualy query data (this is sloppy, but it does the trick) --->
<cfset countryQuery = CountryGateway.getByQuery(CountryQuery) />

<!--- Create a contact record object.  Record objects represent one row in the database and have save, and delete methods --->
<cfset ContactRecord = Application.Reactor.createRecord("Contact") />
<!--- load the contact --->
<cfset ContactRecord.setContactId(url.contactId) />
<cfset ContactRecord.load() />

<cfoutput>
	<h2>Viewing Contact</h2>
	<p>
		<strong>Name:</strong> #ContactRecord.getFirstName()# #ContactRecord.getLastName()#<br />
		<a href="addEditContact.cfm?contactId=#ContactRecord.getContactId()#">Edit Contact</a>
	</p>
</cfoutput>
	
<h3>Contact Email Addresses</h3>
<!--- output this contact's associated phone numbers --->
<cfset emailAddressQuery = ContactRecord.getEmailAddressQuery() />
<cfif emailAddressQuery.recordCount>
	<table border="1" cellpadding="5" cellspacing="0">
		<cfoutput query="emailAddressQuery">
			<tr>
				<td>
					#emailAddressQuery.emailAddress#
				</td>
				<td>
					<a href="deleteEmailAddress.cfm?contactId=#ContactRecord.getContactId()#&emailAddressId=#emailAddressQuery.emailAddressId#">Delete</a>
				</td>
			</tr>
		</cfoutput>
	</table>
	<br />
<cfelse>
	<p>This contact has no email addresses.</p>
</cfif>
		
<!--- this form is used to create a new email address for this contact --->
<cfform name="newEmail" action="viewContact.cfm?contactId=#ContactRecord.getContactId()#">
	<cfif IsDefined("EmailAddressVerificationErrorCollection") AND EmailAddressVerificationErrorCollection.hasErrors()>
		<cfset errors = EmailAddressVerificationErrorCollection.getAllErrors() />
		<ul>
		<cfloop from="1" to="#ArrayLen(errors)#" index="x">
			<cfoutput>
				<li>#errors[x]#</li>
			</cfoutput>
		</cfloop>
		</ul>
	</cfif>
	<table border="1" cellpadding="5" cellspacing="0">
		<tr>
			<td>
				New Email:
			</td>
			<td>
				<cfinput type="text" name="emailAddress" value="#NewEmailAddressRecord.getEmailAddress()#" />
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				<input type="submit" name="Submitted" value="Add Email" />
			</td>
		</tr>
	</table>
</cfform>

<h3>Contact Addresses</h3>
<!--- output this contact's associated addresses --->
<!--- note: this is an example of getting an array of related objects --->
<cfset addressArray = ContactRecord.getAddressArray() />
<cfif ArrayLen(addressArray)>
	<table border="1" cellpadding="5" cellspacing="0">
		<cfloop from="1" to="#ArrayLen(addressArray)#" index="x">
			<cfset Address = addressArray[x] />
			<cfoutput>
				<tr>
					<td>
						<!--- note, format is a custom method created as an example of how you can extend and customize reactor-created objects --->
						#Address.format()#
					</td>
					<td>
						<a href="deleteAddress.cfm?contactId=#ContactRecord.getContactId()#&addressId=#Address.getAddressId()#">Delete</a>
					</td>
				</tr>
			</cfoutput>
		</cfloop>
	</table>
	<br />
<cfelse>
	<p>This contact has no addresses.</p>
</cfif>

<!--- this form is used to create a new address for this contact --->
<cfform name="newAddress" action="viewContact.cfm?contactId=#ContactRecord.getContactId()#">
	<cfif IsDefined("AddressVerificationErrorCollection") AND AddressVerificationErrorCollection.hasErrors()>
		<cfset errors = AddressVerificationErrorCollection.getAllErrors() />
		<ul>
		<cfloop from="1" to="#ArrayLen(errors)#" index="x">
			<cfoutput>
				<li>#errors[x]#</li>
			</cfoutput>
		</cfloop>
		</ul>
	</cfif>
	<table border="1" cellpadding="5" cellspacing="0">
		<tr>
			<td>
				Line 1:
			</td>
			<td>
				<cfinput type="text" name="line1" value="#NewAddressRecord.getLine1()#" />
			</td>
		</tr>
		<tr>
			<td>
				Line 2:
			</td>
			<td>
				<cfinput type="text" name="line2" value="#NewAddressRecord.getLine2()#" />
			</td>
		</tr>
		<tr>
			<td>
				City:
			</td>
			<td>
				<cfinput type="text" name="city" value="#NewAddressRecord.getCity()#" />
			</td>
		</tr>
		<tr>
			<td>
				State/Prov:
			</td>
			<td>
				<cfselect name="stateId" query="stateQuery" display="name" value="stateId" selected="#NewAddressRecord.getStateId()#" />
			</td>
		</tr>
		<tr>
			<td>
				Postal Code:
			</td>
			<td>
				<cfinput type="text" name="postalCode" value="#NewAddressRecord.getPostalCode()#" />
			</td>
		</tr>
		<tr>
			<td>
				Country:
			</td>
			<td>
				<cfselect name="countryId" query="countryQuery" display="name" value="countryId" selected="#NewAddressRecord.getCountryId()#" />
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				<input type="submit" name="Submitted" value="Add Address" />
			</td>
		</tr>
	</table>
</cfform>

<h3>Contact Phone Numbers</h3>
<!--- output this contact's associated phone numbers --->
<cfset phoneNumberQuery = ContactRecord.getPhoneNumberQuery() />
<cfif phoneNumberQuery.recordCount>
	<table border="1" cellpadding="5" cellspacing="0">
		<cfoutput query="phoneNumberQuery">
			<tr>
				<td>
					#phoneNumberQuery.phoneNumber#
				</td>
				<td>
					<a href="deletePhoneNumber.cfm?contactId=#ContactRecord.getContactId()#&phoneNumberId=#phoneNumberQuery.phoneNumberId#">Delete</a>
				</td>
			</tr>
		</cfoutput>
	</table>
	<br />
<cfelse>
	<p>This contact has no phone numbers.</p>
</cfif>
		
<!--- this form is used to create a phone number for this contact --->
<cfform name="newPhone" action="viewContact.cfm?contactId=#ContactRecord.getContactId()#">
	<cfif IsDefined("PhoneNumberVerificationErrorCollection") AND PhoneNumberVerificationErrorCollection.hasErrors()>
		<cfset errors = PhoneNumberVerificationErrorCollection.getAllErrors() />
		<ul>
		<cfloop from="1" to="#ArrayLen(errors)#" index="x">
			<cfoutput>
				<li>#errors[x]#</li>
			</cfoutput>
		</cfloop>
		</ul>
	</cfif>
	<table border="1" cellpadding="5" cellspacing="0">
		<tr>
			<td>
				New Phone Number:
			</td>
			<td>
				<cfinput type="text" name="phoneNumber" value="#NewPhoneNumberRecord.getPhoneNumber()#" />
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				<input type="submit" name="Submitted" value="Add Phone Number" />
			</td>
		</tr>
	</table>
</cfform>
	