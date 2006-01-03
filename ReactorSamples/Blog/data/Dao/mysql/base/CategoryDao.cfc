
	
<cfcomponent hint="I am the base DAO object for the Category table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractDao" >
	
	<cfset variables.signature = "8FBBCE7490382D9832B8EC45EAFBB33A" />

	<cffunction name="save" access="public" hint="I create or update a Category record." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Category" required="yes" type="ReactorBlogData.To.mysql.CategoryTo" />

		
		<cfif IsNumeric(arguments.to.CategoryId) AND Val(arguments.to.CategoryId)>
			<cfset update(arguments.to) />
		<cfelse>
			<cfset create(arguments.to) />
		</cfif>
			
	</cffunction>
	
	
	
	<cffunction name="create" access="public" hint="I create a Category object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Category" required="yes" type="ReactorBlogData.To.mysql.CategoryTo" />
		<cfset var Convention = getConventions() />
		<cfset var qCreate = 0 />
		
			
		<cftransaction>
			<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">
				INSERT INTO #Convention.FormatObjectName(getObjectMetadata(), '')#
				(
					
							#Convention.formatFieldName('Name', 'Category')#
							
				) VALUES (
					
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.Name#"
							 />
							
				)
				
							</cfquery>
							
							<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">	
								#Convention.lastInseredIdSyntax(getObjectMetadata())#
						
				
				</cfquery>
		</cftransaction>
			
		
			<cfif qCreate.recordCount>
				<cfset arguments.to.CategoryId = qCreate.id />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="read" access="public" hint="I read a  Category object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Category which will be populated." required="yes" type="ReactorBlogData.To.mysql.CategoryTo" />
		<cfset var qRead = 0 />
		<cfset var CategoryGateway = _getReactorFactory().createGateway("Category") />
		
		<cfset qRead = CategoryGateway.getByFields(
			CategoryId = arguments.to.CategoryId
		) />
		
		<cfif qRead.recordCount>
				<cfset arguments.to.CategoryId = 
				
						qRead.CategoryId
				/>
			
				<cfset arguments.to.Name = 
				
						qRead.Name
				/>
			
		</cfif>
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a Category object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Category which will be used to update a record in the table." required="yes" type="ReactorBlogData.To.mysql.CategoryTo" />
		<cfset var Convention = getConventions() />
		<cfset var qUpdate = 0 />
		
		
		<cfquery name="qUpdate" datasource="#_getConfig().getDsn()#">
			UPDATE #Convention.FormatObjectName(getObjectMetadata(), '')#
			SET 
			
				#Convention.formatUpdateFieldName('Name')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.Name#"
					 />
				
			WHERE
			
				#Convention.formatUpdateFieldName('CategoryId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.CategoryId#"
					 />
				
		</cfquery>
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a record in the Category table." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Category which will be used to delete from the table." required="yes" type="ReactorBlogData.To.mysql.CategoryTo" />
		<cfset var Convention = getConventions() />
		<cfset var qDelete = 0 />
		
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#">
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata(), '')#
			WHERE
			
				#Convention.formatFieldName('CategoryId', 'Category')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.CategoryId#"
					 />
				
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>
	
