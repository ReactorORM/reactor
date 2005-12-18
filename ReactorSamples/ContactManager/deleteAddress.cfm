
<!--- load the address record --->
<cfset AddressRecord = Application.Reactor.createRecord("Address") />
<cfset AddressRecord.setAddressId(url.addressID) />
<cfset AddressRecord.delete() />

<cflocation url="viewContact.cfm?contactId=#url.contactId#" />