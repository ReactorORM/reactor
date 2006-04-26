<cfset EntryRecord = viewstate.getValue("EntryRecord") />
<cfset categories = viewstate.getValue("categories") />
<cfset Errors = viewstate.getValue("Errors") />

<h1>Edit Blog Entry</h1>

<cfform name="EntryForm" action="index.cfm?event=SubmitEntryForm" method="post">

	<cf_input label="Title:"
		errors="#Errors#"
		alias="#EntryRecord._getAlias()#"
		required="yes"
		type="text"
		name="title"
		value="#EntryRecord.getTitle()#"
		size="40"
		maxlength="200" />
	
	<cf_input
		label="Body:"
		errors="#Errors#"
		alias="#EntryRecord._getAlias()#"
		required="yes"
		type="editor"
		name="article"
		value="#EntryRecord.getArticle()#" />
	
	
	<cfset publicationDate = EntryRecord.getPublicationDate() />
	<cfif IsDate(publicationDate)>
		<cfset publicationDate = DateFormat(publicationDate, "m/d/yyyy") & " " & TimeFormat(publicationDate, "h:mm tt") />
	</cfif>
	
	<cf_input	
		label="Publish At:"
		errors="#Errors#"
		alias="#EntryRecord._getAlias()#"
		required="yes"
		type="text"
		name="publicationDate"
		value="#publicationDate#"
		size="20"
		maxlength="20"
		comment="A date and time in the future will publish this entry in the future." />
	
	
	<cf_select
		label="Select Categories:"
		errors="#Errors#"
		alias="#EntryRecord._getAlias()#"
		required="no"
		name="categoryIdList"
		query="#Categories#"
		selected="#EntryRecord.getCategoryIterator().getValueList("categoryId")#"
		display="name"
		value="categoryId"
		multiple="true"
		style="width: 200px;"
		comment="Please select at least one category or provide a new category." />
	
	<cf_input
		label="New Categories:"
		errors="#Errors#"
		alias="#EntryRecord._getAlias()#"
		required="no"
		type="text"
		name="newCategoryList"
		value="#viewstate.getValue("newCategoryList")#"
		size="40"
		maxlength="100"
		comment="Seperate new categories with commas." />
	
	<cf_input
		label="Disable comments"
		errors="#Errors#"
		alias="#EntryRecord._getAlias()#"
		type="checkbox"
		name="disableComments"
		value="#EntryRecord.getDisableComments()#" />
	
	<cfinput	
		type="hidden"
		name="entryId"
		value="#EntryRecord.getEntryId()#" />
	
	<cf_input
		type="Submit"
		name="submit"
		value="Save Entry" />
		
</cfform>
