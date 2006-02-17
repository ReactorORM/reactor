
<!--- load the phone number record --->
<cfset PhoneNumberRecord = Application.Reactor.createRecord("PhoneNumber") />
<cfset PhoneNumberRecord.setPhoneNumberId(url.phoneNumberId) />
<cfset PhoneNumberRecord.delete() />

<cflocation url="viewContact.cfm?contactId=#url.contactId#" />