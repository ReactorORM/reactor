
<!--- load the emailAddress record --->
<cfset ContactRecord = Application.Reactor.createRecord("Contact") />
<cfset ContactRecord.setContactId(url.contactId) />
<cfset ContactRecord.load() />


<!--- delete the contact's email addresses --->
<cfset ContactEmailAddressArray = ContactRecord.getEmailAddressArray() />
<cfloop from="1" to="#ArrayLen(ContactEmailAddressArray)#" index="x">
	<cfset ContactEmailAddressArray[x].delete() />
</cfloop>

<!--- delete the contact's addresses --->
<cfset ContactAddressArray = ContactRecord.getAddressArray() />
<cfloop from="1" to="#ArrayLen(ContactAddressArray)#" index="x">
	<cfset ContactAddressArray[x].delete() />
</cfloop>

<!--- delete the contact's phone number --->
<cfset ContactPhoneNumberArray = ContactRecord.getPhoneNumberArray() />
<cfloop from="1" to="#ArrayLen(ContactPhoneNumberArray)#" index="x">
	<cfset ContactPhoneNumberArray[x].delete() />
</cfloop>

<cfset ContactRecord.delete() />

<cflocation url="index.cfm" />