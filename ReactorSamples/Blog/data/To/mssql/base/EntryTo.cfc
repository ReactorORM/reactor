
<cfcomponent hint="I am the base TO object for the Entry table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractTo" >
	
	<cfset variables.signature = "8D18CB60509CCB025710FA43E1C939D1" />
	
		<cfset this.EntryId = "0" />
	
		<cfset this.Title = "" />
	
		<cfset this.Preview = "" />
	
		<cfset this.Article = "" />
	
		<cfset this.PublicationDate = "#Now()#" />
	
		<cfset this.PostedByUserId = "0" />
	
		<cfset this.DisableComments = "false" />
	
		<cfset this.Views = "0" />
	
	
</cfcomponent>
	
