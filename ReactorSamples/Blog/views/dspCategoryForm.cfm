<cfset CategoryRecord = viewstate.getValue("CategoryRecord") />
<cfset Errors = viewstate.getValue("Errors") />

<h1>Category</h1>

<cfform name="CategoryForm" action="index.cfm?event=SubmitCategoryForm" method="post">

	<cf_input label="Category Name:"
		errors="#Errors#"
		required="yes"
		type="text"
		name="name"
		value="#CategoryRecord.getName()#"
		size="40"
		maxlength="50" />
	
	<cfinput	
		type="hidden"
		name="categoryId"
		value="#CategoryRecord.getCategoryId()#" />
	
	<cf_input
		type="Submit"
		name="submit"
		value="Save Category" />
		
</cfform>
