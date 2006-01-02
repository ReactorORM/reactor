
	
<cfcomponent hint="I am the base DAO object for the Entry table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractDao" >
	
	<cfset variables.signature = "8D18CB60509CCB025710FA43E1C939D1" />

	<cffunction name="save" access="public" hint="I create or update a Entry record." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Entry" required="yes" type="ReactorBlogData.To.mssql.EntryTo" />

		
		<cfif IsNumeric(arguments.to.EntryId) AND Val(arguments.to.EntryId)>
			<cfset update(arguments.to) />
		<cfelse>
			<cfset create(arguments.to) />
		</cfif>
			
	</cffunction>
	
	
	
	<cffunction name="create" access="public" hint="I create a Entry object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Entry" required="yes" type="ReactorBlogData.To.mssql.EntryTo" />
		<cfset var Convention = getConventions() />
		<cfset var qCreate = 0 />
		
			
		<cftransaction>
			<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">
				INSERT INTO #Convention.FormatObjectName(getObjectMetadata(), '')#
				(
					
							#Convention.formatFieldName('Title', 'Entry')#
							,
							#Convention.formatFieldName('Preview', 'Entry')#
							,
							#Convention.formatFieldName('Article', 'Entry')#
							,
							#Convention.formatFieldName('PublicationDate', 'Entry')#
							,
							#Convention.formatFieldName('PostedByUserId', 'Entry')#
							,
							#Convention.formatFieldName('DisableComments', 'Entry')#
							,
							#Convention.formatFieldName('Views', 'Entry')#
							
				) VALUES (
					
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="200"
							
							value="#arguments.to.Title#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="1000"
							
							value="#arguments.to.Preview#"
								
								null="#Iif(NOT Len(arguments.to.Preview), DE(true), DE(false))#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_longvarchar"
							
								scale="2147483647"
							
							value="#arguments.to.Article#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_timestamp"
							
							value="#arguments.to.PublicationDate#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_integer"
							
							value="#arguments.to.PostedByUserId#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_bit"
							
							value="#arguments.to.DisableComments#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_integer"
							
							value="#arguments.to.Views#"
							 />
							
				)
				
								#Convention.lastInseredIdSyntax(getObjectMetadata())#
						
				
				</cfquery>
		</cftransaction>
			
		
			<cfif qCreate.recordCount>
				<cfset arguments.to.EntryId = qCreate.id />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="read" access="public" hint="I read a  Entry object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Entry which will be populated." required="yes" type="ReactorBlogData.To.mssql.EntryTo" />
		<cfset var qRead = 0 />
		<cfset var EntryGateway = _getReactorFactory().createGateway("Entry") />
		
		<cfset qRead = EntryGateway.getByFields(
			EntryId = arguments.to.EntryId
		) />
		
		<cfif qRead.recordCount>
				<cfset arguments.to.EntryId = 
				
						qRead.EntryId
				/>
			
				<cfset arguments.to.Title = 
				
						qRead.Title
				/>
			
				<cfset arguments.to.Preview = 
				
						qRead.Preview
				/>
			
				<cfset arguments.to.Article = 
				
						qRead.Article
				/>
			
				<cfset arguments.to.PublicationDate = 
				
						qRead.PublicationDate
				/>
			
				<cfset arguments.to.PostedByUserId = 
				
						qRead.PostedByUserId
				/>
			
				<cfset arguments.to.DisableComments = 
				
						qRead.DisableComments
				/>
			
				<cfset arguments.to.Views = 
				
						qRead.Views
				/>
			
		</cfif>
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a Entry object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Entry which will be used to update a record in the table." required="yes" type="ReactorBlogData.To.mssql.EntryTo" />
		<cfset var Convention = getConventions() />
		<cfset var qUpdate = 0 />
		
		
		<cfquery name="qUpdate" datasource="#_getConfig().getDsn()#">
			UPDATE #Convention.FormatObjectName(getObjectMetadata(), '')#
			SET 
			
				#Convention.formatUpdateFieldName('Title')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="200"
					
					value="#arguments.to.Title#"
					 />
				,
				#Convention.formatUpdateFieldName('Preview')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="1000"
					
					value="#arguments.to.Preview#"
					
						null="#Iif(NOT Len(arguments.to.Preview), DE(true), DE(false))#"
					 />
				,
				#Convention.formatUpdateFieldName('Article')# = <cfqueryparam
					cfsqltype="cf_sql_longvarchar"
					
						scale="2147483647"
					
					value="#arguments.to.Article#"
					 />
				,
				#Convention.formatUpdateFieldName('PublicationDate')# = <cfqueryparam
					cfsqltype="cf_sql_timestamp"
					
					value="#arguments.to.PublicationDate#"
					 />
				,
				#Convention.formatUpdateFieldName('PostedByUserId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.PostedByUserId#"
					 />
				,
				#Convention.formatUpdateFieldName('DisableComments')# = <cfqueryparam
					cfsqltype="cf_sql_bit"
					
					value="#arguments.to.DisableComments#"
					 />
				,
				#Convention.formatUpdateFieldName('Views')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.Views#"
					 />
				
			WHERE
			
				#Convention.formatUpdateFieldName('EntryId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.EntryId#"
					 />
				
		</cfquery>
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a record in the Entry table." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Entry which will be used to delete from the table." required="yes" type="ReactorBlogData.To.mssql.EntryTo" />
		<cfset var Convention = getConventions() />
		<cfset var qDelete = 0 />
		
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#">
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata(), '')#
			WHERE
			
				#Convention.formatFieldName('EntryId', 'Entry')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.EntryId#"
					 />
				
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>
	
