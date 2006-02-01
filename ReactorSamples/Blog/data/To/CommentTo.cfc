
<cfcomponent hint="I am the database agnostic custom TO object for the Comment table.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.ReactorBlog.To.CommentTo">
	<!--- Place custom code here, it will not be overwritten --->
	
	<cfset this.Posted = Now() />
</cfcomponent>
	
