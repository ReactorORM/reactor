
<cfcomponent hint="I am the database agnostic custom TO object for the Entry table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.ReactorBlogData.To.EntryTo">
	<!--- Place custom code here, it will not be overwritten --->
	
	<cfset this.PublicationDate = Now() />
	<cfset this.categoryIdList = "0" />
	<cfset this.newCategoryList = "" />
	
</cfcomponent>
	
