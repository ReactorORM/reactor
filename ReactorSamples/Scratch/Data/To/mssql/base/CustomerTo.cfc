
<cfcomponent hint="I am the base TO object for the Customer table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractTo" >
	
	<cfset variables.signature = "4F6ED61E73B22F04318F7970FE70496C" />
	
		<cfset this.CustomerId = "0" />
	
		<cfset this.Username = "" />
	
		<cfset this.Password = "" />
	
		<cfset this.FirstName = "" />
	
		<cfset this.LastName = "" />
	
		<cfset this.DateCreated = "#Now()#" />
	
		<cfset this.AddressId = "0" />
	
	
</cfcomponent>
	
