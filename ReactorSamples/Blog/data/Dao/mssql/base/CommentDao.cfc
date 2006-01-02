
	
<cfcomponent hint="I am the base DAO object for the Comment table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractDao" >
	
	<cfset variables.signature = "70B044B9DE65C8A35BAB85BF49421FC7" />

	<cffunction name="save" access="public" hint="I create or update a Comment record." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Comment" required="yes" type="ReactorBlogData.To.mssql.CommentTo" />

		
		<cfif IsNumeric(arguments.to.CommentID) AND Val(arguments.to.CommentID)>
			<cfset update(arguments.to) />
		<cfelse>
			<cfset create(arguments.to) />
		</cfif>
			
	</cffunction>
	
	
	
	<cffunction name="create" access="public" hint="I create a Comment object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Comment" required="yes" type="ReactorBlogData.To.mssql.CommentTo" />
		<cfset var Convention = getConventions() />
		<cfset var qCreate = 0 />
		
			
		<cftransaction>
			<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">
				INSERT INTO #Convention.FormatObjectName(getObjectMetadata(), '')#
				(
					
							#Convention.formatFieldName('EntryId', 'Comment')#
							,
							#Convention.formatFieldName('Name', 'Comment')#
							,
							#Convention.formatFieldName('EmailAddress', 'Comment')#
							,
							#Convention.formatFieldName('Comment', 'Comment')#
							,
							#Convention.formatFieldName('Posted', 'Comment')#
							
				) VALUES (
					
							<cfqueryparam cfsqltype="cf_sql_integer"
							
							value="#arguments.to.EntryId#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.Name#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.EmailAddress#"
								
								null="#Iif(NOT Len(arguments.to.EmailAddress), DE(true), DE(false))#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_longvarchar"
							
								scale="2147483647"
							
							value="#arguments.to.Comment#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_timestamp"
							
							value="#arguments.to.Posted#"
							 />
							
				)
				
								#Convention.lastInseredIdSyntax(getObjectMetadata())#
						
				
				</cfquery>
		</cftransaction>
			
		
			<cfif qCreate.recordCount>
				<cfset arguments.to.CommentID = qCreate.id />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="read" access="public" hint="I read a  Comment object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Comment which will be populated." required="yes" type="ReactorBlogData.To.mssql.CommentTo" />
		<cfset var qRead = 0 />
		<cfset var CommentGateway = _getReactorFactory().createGateway("Comment") />
		
		<cfset qRead = CommentGateway.getByFields(
			CommentID = arguments.to.CommentID
		) />
		
		<cfif qRead.recordCount>
				<cfset arguments.to.CommentID = 
				
						qRead.CommentID
				/>
			
				<cfset arguments.to.EntryId = 
				
						qRead.EntryId
				/>
			
				<cfset arguments.to.Name = 
				
						qRead.Name
				/>
			
				<cfset arguments.to.EmailAddress = 
				
						qRead.EmailAddress
				/>
			
				<cfset arguments.to.Comment = 
				
						qRead.Comment
				/>
			
				<cfset arguments.to.Posted = 
				
						qRead.Posted
				/>
			
		</cfif>
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a Comment object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Comment which will be used to update a record in the table." required="yes" type="ReactorBlogData.To.mssql.CommentTo" />
		<cfset var Convention = getConventions() />
		<cfset var qUpdate = 0 />
		
		
		<cfquery name="qUpdate" datasource="#_getConfig().getDsn()#">
			UPDATE #Convention.FormatObjectName(getObjectMetadata(), '')#
			SET 
			
				#Convention.formatUpdateFieldName('EntryId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.EntryId#"
					 />
				,
				#Convention.formatUpdateFieldName('Name')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.Name#"
					 />
				,
				#Convention.formatUpdateFieldName('EmailAddress')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.EmailAddress#"
					
						null="#Iif(NOT Len(arguments.to.EmailAddress), DE(true), DE(false))#"
					 />
				,
				#Convention.formatUpdateFieldName('Comment')# = <cfqueryparam
					cfsqltype="cf_sql_longvarchar"
					
						scale="2147483647"
					
					value="#arguments.to.Comment#"
					 />
				,
				#Convention.formatUpdateFieldName('Posted')# = <cfqueryparam
					cfsqltype="cf_sql_timestamp"
					
					value="#arguments.to.Posted#"
					 />
				
			WHERE
			
				#Convention.formatUpdateFieldName('CommentID')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.CommentID#"
					 />
				
		</cfquery>
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a record in the Comment table." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Comment which will be used to delete from the table." required="yes" type="ReactorBlogData.To.mssql.CommentTo" />
		<cfset var Convention = getConventions() />
		<cfset var qDelete = 0 />
		
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#">
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata(), '')#
			WHERE
			
				#Convention.formatFieldName('CommentID', 'Comment')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.CommentID#"
					 />
				
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>
	
