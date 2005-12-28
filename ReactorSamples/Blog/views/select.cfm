
<cfparam name="attributes.errors" default="" />
<cfparam name="attributes.label" default="" />
<cfparam name="attributes.required" default="false" />
<cfparam name="attributes.comment" default="" />

<cfparam name="attributes.name" />
<cfparam name="attributes.query" />
<cfparam name="attributes.selected" />
<cfparam name="attributes.display" />
<cfparam name="attributes.value" />
<cfparam name="attributes.multiple" default="false" />
<cfparam name="attributes.size" default="4" />

<cfparam name="attributes.style" default="" />
<cfparam name="attributes.class" default="" />
 
<cfset thisTag.errors = attributes.errors />
<cfset thisTag.label = attributes.label />

<cfset classes = "field" />

<!--- add an input field --->
<cfif ThisTag.executionMode IS "Start">
	
	<cfif IsObject(attributes.errors) AND attributes.errors.hasErrors(attributes.name)>
		<cfset errorsArray = attributes.errors.GetPropertyErrors(attributes.name) />
		
		<p class="errorMessage">
			<cfloop from="1" to="#ArrayLen(errorsArray)#" index="x">
				<cfoutput>
					#errorsArray[x]#
					<cfif x IS NOT ArrayLen(errorsArray)>
						<br />
					</cfif>
				</cfoutput>
			</cfloop>
		</p>
		<cfset classes = classes & " errorField" />
	</cfif>
	
	<cfoutput>
		<div class="#classes#">
			<label for="#attributes.name#">#Iif(attributes.required, DE('*'), DE(''))# #attributes.label#</label>
			<cfselect name="#attributes.name#"
				query="attributes.query"
				selected="#attributes.selected#"
				display="#attributes.display#"
				value="#attributes.value#"
				multiple="#attributes.multiple#"
				style="#attributes.style#"
				class="inputSelect #attributes.class#"
				size="#attributes.size#" />
			
			<cfif Len(attributes.comment)>
				<small>#attributes.comment#</small>
			</cfif>
		</div>
	</cfoutput>
</cfif>