
<cfcomponent hint="I am the base Gateway object for the Comment table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractGateway" >
	
	<cfset variables.signature = "213DDCE078FE802CAA38D229ED2C3AF8" />

	<cffunction name="getAll" access="public" hint="I return all rows from the Comment table." output="false" returntype="query">
		<cfreturn getByFields() />
	</cffunction>
	
	<cffunction name="getByFields" access="public" hint="I return all matching rows from the Comment table." output="false" returntype="query">
		
			<cfargument name="CommentID" hint="If provided, I match the provided value to the CommentID field in the Comment table." required="no" type="string" />
		
			<cfargument name="EntryId" hint="If provided, I match the provided value to the EntryId field in the Comment table." required="no" type="string" />
		
			<cfargument name="Name" hint="If provided, I match the provided value to the Name field in the Comment table." required="no" type="string" />
		
			<cfargument name="EmailAddress" hint="If provided, I match the provided value to the EmailAddress field in the Comment table." required="no" type="string" />
		
			<cfargument name="Comment" hint="If provided, I match the provided value to the Comment field in the Comment table." required="no" type="string" />
		
			<cfargument name="Posted" hint="If provided, I match the provided value to the Posted field in the Comment table." required="no" type="string" />
		
		<cfset var Query = createQuery() />
		<cfset var Where = Query.getWhere() />
		
		
			<cfif IsDefined('arguments.CommentID')>
				<cfset Where.isEqual(
					
							"Comment"
						
				, "CommentID", arguments.CommentID) />
			</cfif>
		
			<cfif IsDefined('arguments.EntryId')>
				<cfset Where.isEqual(
					
							"Comment"
						
				, "EntryId", arguments.EntryId) />
			</cfif>
		
			<cfif IsDefined('arguments.Name')>
				<cfset Where.isEqual(
					
							"Comment"
						
				, "Name", arguments.Name) />
			</cfif>
		
			<cfif IsDefined('arguments.EmailAddress')>
				<cfset Where.isEqual(
					
							"Comment"
						
				, "EmailAddress", arguments.EmailAddress) />
			</cfif>
		
			<cfif IsDefined('arguments.Comment')>
				<cfset Where.isEqual(
					
							"Comment"
						
				, "Comment", arguments.Comment) />
			</cfif>
		
			<cfif IsDefined('arguments.Posted')>
				<cfset Where.isEqual(
					
							"Comment"
						
				, "Posted", arguments.Posted) />
			</cfif>
		
		
		<cfreturn getByQuery(Query) />
	</cffunction>
	
</cfcomponent>
	
