
	
<cfcomponent hint="I am the base DAO object for the Rating table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractDao" >
	
	<cfset variables.signature = "DFDE9A5FA15D8C30E7E437F9293B587D" />

	<cffunction name="save" access="public" hint="I create or update a Rating record." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Rating" required="yes" type="ReactorBlogData.To.mssql.RatingTo" />

		
		<cfif IsNumeric(arguments.to.RatingId) AND Val(arguments.to.RatingId)>
			<cfset update(arguments.to) />
		<cfelse>
			<cfset create(arguments.to) />
		</cfif>
			
	</cffunction>
	
	
	
	<cffunction name="create" access="public" hint="I create a Rating object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Rating" required="yes" type="ReactorBlogData.To.mssql.RatingTo" />
		<cfset var Convention = getConventions() />
		<cfset var qCreate = 0 />
		
			
		<cftransaction>
			<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">
				INSERT INTO #Convention.FormatObjectName(getObjectMetadata(), '')#
				(
					
							#Convention.formatFieldName('EntryId', 'Rating')#
							,
							#Convention.formatFieldName('Rating', 'Rating')#
							
				) VALUES (
					
							<cfqueryparam cfsqltype="cf_sql_integer"
							
							value="#arguments.to.EntryId#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_integer"
							
							value="#arguments.to.Rating#"
							 />
							
				)
				
								#Convention.lastInseredIdSyntax(getObjectMetadata())#
						
				
				</cfquery>
		</cftransaction>
			
		
			<cfif qCreate.recordCount>
				<cfset arguments.to.RatingId = qCreate.id />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="read" access="public" hint="I read a  Rating object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Rating which will be populated." required="yes" type="ReactorBlogData.To.mssql.RatingTo" />
		<cfset var qRead = 0 />
		<cfset var RatingGateway = _getReactorFactory().createGateway("Rating") />
		
		<cfset qRead = RatingGateway.getByFields(
			RatingId = arguments.to.RatingId
		) />
		
		<cfif qRead.recordCount>
				<cfset arguments.to.RatingId = 
				
						qRead.RatingId
				/>
			
				<cfset arguments.to.EntryId = 
				
						qRead.EntryId
				/>
			
				<cfset arguments.to.Rating = 
				
						qRead.Rating
				/>
			
		</cfif>
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a Rating object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Rating which will be used to update a record in the table." required="yes" type="ReactorBlogData.To.mssql.RatingTo" />
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
				#Convention.formatUpdateFieldName('Rating')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.Rating#"
					 />
				
			WHERE
			
				#Convention.formatUpdateFieldName('RatingId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.RatingId#"
					 />
				
		</cfquery>
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a record in the Rating table." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Rating which will be used to delete from the table." required="yes" type="ReactorBlogData.To.mssql.RatingTo" />
		<cfset var Convention = getConventions() />
		<cfset var qDelete = 0 />
		
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#">
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata(), '')#
			WHERE
			
				#Convention.formatFieldName('RatingId', 'Rating')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.RatingId#"
					 />
				
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>
	
