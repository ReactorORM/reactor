
<cfcomponent hint="I am the base Gateway object for the Entry table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "0E8A0DCC028F2DF598EC814ED991B3AA" />

	<cffunction name="getAll" access="public" hint="I return all rows from the Entry table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the Entry table." output="false" returntype="query">
		
			<cfargument name="EntryId" hint="If provided, I match the provided value to the EntryId field in the Entry table." required="no" type="string" />
		
			<cfargument name="Title" hint="If provided, I match the provided value to the Title field in the Entry table." required="no" type="string" />
		
			<cfargument name="Preview" hint="If provided, I match the provided value to the Preview field in the Entry table." required="no" type="string" />
		
			<cfargument name="Article" hint="If provided, I match the provided value to the Article field in the Entry table." required="no" type="string" />
		
			<cfargument name="PublicationDate" hint="If provided, I match the provided value to the PublicationDate field in the Entry table." required="no" type="string" />
		
			<cfargument name="PostedByUserId" hint="If provided, I match the provided value to the PostedByUserId field in the Entry table." required="no" type="string" />
		
			<cfargument name="DisableComments" hint="If provided, I match the provided value to the DisableComments field in the Entry table." required="no" type="string" />
		
			<cfargument name="Views" hint="If provided, I match the provided value to the Views field in the Entry table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.EntryId')>
				<cfset Where.isEqual(
					
							"Entry"
						
				, "EntryId", arguments.EntryId) />
			</cfif>
		
			<cfif IsDefined('arguments.Title')>
				<cfset Where.isEqual(
					
							"Entry"
						
				, "Title", arguments.Title) />
			</cfif>
		
			<cfif IsDefined('arguments.Preview')>
				<cfset Where.isEqual(
					
							"Entry"
						
				, "Preview", arguments.Preview) />
			</cfif>
		
			<cfif IsDefined('arguments.Article')>
				<cfset Where.isEqual(
					
							"Entry"
						
				, "Article", arguments.Article) />
			</cfif>
		
			<cfif IsDefined('arguments.PublicationDate')>
				<cfset Where.isEqual(
					
							"Entry"
						
				, "PublicationDate", arguments.PublicationDate) />
			</cfif>
		
			<cfif IsDefined('arguments.PostedByUserId')>
				<cfset Where.isEqual(
					
							"Entry"
						
				, "PostedByUserId", arguments.PostedByUserId) />
			</cfif>
		
			<cfif IsDefined('arguments.DisableComments')>
				<cfset Where.isEqual(
					
							"Entry"
						
				, "DisableComments", arguments.DisableComments) />
			</cfif>
		
			<cfif IsDefined('arguments.Views')>
				<cfset Where.isEqual(
					
							"Entry"
						
				, "Views", arguments.Views) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
