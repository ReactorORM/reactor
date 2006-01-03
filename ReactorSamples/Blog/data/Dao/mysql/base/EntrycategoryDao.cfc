
	
<cfcomponent hint="I am the base DAO object for the EntryCategory table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractDao" >
	
	<cfset variables.signature = "044DEDBE111807360D1608E501B49D78" />

	<cffunction name="save" access="public" hint="I create or update a EntryCategory record." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for EntryCategory" required="yes" type="ReactorBlogData.To.mysql.EntryCategoryTo" />

		
		<cfif IsNumeric(arguments.to.EntryCategoryId) AND Val(arguments.to.EntryCategoryId)>
			<cfset update(arguments.to) />
		<cfelse>
			<cfset create(arguments.to) />
		</cfif>
			
	</cffunction>
	
	
	
	<cffunction name="create" access="public" hint="I create a EntryCategory object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for EntryCategory" required="yes" type="ReactorBlogData.To.mysql.EntryCategoryTo" />
		<cfset var Convention = getConventions() />
		<cfset var qCreate = 0 />
		
			
		<cftransaction>
			<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">
				INSERT INTO #Convention.FormatObjectName(getObjectMetadata(), '')#
				(
					
							#Convention.formatFieldName('EntryId', 'EntryCategory')#
							,
							#Convention.formatFieldName('CategoryId', 'EntryCategory')#
							
				) VALUES (
					
							<cfqueryparam cfsqltype="cf_sql_integer"
							
							value="#arguments.to.EntryId#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_integer"
							
							value="#arguments.to.CategoryId#"
							 />
							
				)
				
							</cfquery>
							
							<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">	
								#Convention.lastInseredIdSyntax(getObjectMetadata())#
						
				
				</cfquery>
		</cftransaction>
			
		
			<cfif qCreate.recordCount>
				<cfset arguments.to.EntryCategoryId = qCreate.id />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="read" access="public" hint="I read a  EntryCategory object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for EntryCategory which will be populated." required="yes" type="ReactorBlogData.To.mysql.EntryCategoryTo" />
		<cfset var qRead = 0 />
		<cfset var EntryCategoryGateway = _getReactorFactory().createGateway("EntryCategory") />
		
		<cfset qRead = EntryCategoryGateway.getByFields(
			EntryCategoryId = arguments.to.EntryCategoryId
		) />
		
		<cfif qRead.recordCount>
				<cfset arguments.to.EntryCategoryId = 
				
						qRead.EntryCategoryId
				/>
			
				<cfset arguments.to.EntryId = 
				
						qRead.EntryId
				/>
			
				<cfset arguments.to.CategoryId = 
				
						qRead.CategoryId
				/>
			
		</cfif>
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a EntryCategory object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for EntryCategory which will be used to update a record in the table." required="yes" type="ReactorBlogData.To.mysql.EntryCategoryTo" />
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
				#Convention.formatUpdateFieldName('CategoryId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.CategoryId#"
					 />
				
			WHERE
			
				#Convention.formatUpdateFieldName('EntryCategoryId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.EntryCategoryId#"
					 />
				
		</cfquery>
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a record in the EntryCategory table." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for EntryCategory which will be used to delete from the table." required="yes" type="ReactorBlogData.To.mysql.EntryCategoryTo" />
		<cfset var Convention = getConventions() />
		<cfset var qDelete = 0 />
		
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#">
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata(), '')#
			WHERE
			
				#Convention.formatFieldName('EntryCategoryId', 'EntryCategory')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.EntryCategoryId#"
					 />
				
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>
	
