
<cfcomponent hint="I am the custom TO object for the  table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.ReactorBlogData.To.EntryTo">
	<!--- Place custom code here, it will not be overwritten --->
	
	<cfset this.categoryIdList = "0" />
	<cfset this.newCategoryList = "" />
	
</cfcomponent>
	
