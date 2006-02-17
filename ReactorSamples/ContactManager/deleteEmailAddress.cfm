
<!--- load the emailAddress record --->
<cfset EmailAddressRecord = Application.Reactor.createRecord("EmailAddress") />
<cfset EmailAddressRecord.setEmailAddressId(url.emailAddressID) />
<cfset EmailAddressRecord.delete() />

<cflocation url="viewContact.cfm?contactId=#url.contactId#" />