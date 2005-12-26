
	
<cfcomponent hint="I am the base DAO object for the Contact table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractDao" >
	
	<cfset variables.signature = "EC0B43B586B2CBF66C6A81BEE88F2DD8" />

	<cffunction name="save" access="public" hint="I create or update a Contact record." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Contact" required="yes" type="ContactManagerData.To.mssql.ContactTo" />

		
		<cfif IsNumeric(arguments.to.ContactId) AND Val(arguments.to.ContactId)>
			<cfset update(arguments.to) />
		<cfelse>
			<cfset create(arguments.to) />
		</cfif>
			
	</cffunction>
	
	
	
	<cffunction name="create" access="public" hint="I create a Contact object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Contact" required="yes" type="ContactManagerData.To.mssql.ContactTo" />
		<cfset var Convention = getConventions() />
		<cfset var qCreate = 0 />
		
			
		<cftransaction>
			<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">
				INSERT INTO #Convention.FormatObjectName(getObjectMetadata(), '')#
				(
					
							#Convention.formatFieldName('FirstName', 'Contact')#
							,
							#Convention.formatFieldName('LastName', 'Contact')#
							
				) VALUES (
					
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.FirstName#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.LastName#"
							 />
							
				)
				
								#Convention.lastInseredIdSyntax(getObjectMetadata())#
						
				
				</cfquery>
		</cftransaction>
			
		
			<cfif qCreate.recordCount>
				<cfset arguments.to.ContactId = qCreate.id />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="read" access="public" hint="I read a  Contact object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Contact which will be populated." required="yes" type="ContactManagerData.To.mssql.ContactTo" />
		<cfset var qRead = 0 />
		<cfset var ContactGateway = _getReactorFactory().createGateway("Contact") />
		
		<cfset qRead = ContactGateway.getByFields(
			ContactId = arguments.to.ContactId
		) />
		
		<cfif qRead.recordCount>
				<cfset arguments.to.ContactId = 
				
						qRead.ContactId
				/>
			
				<cfset arguments.to.FirstName = 
				
						qRead.FirstName
				/>
			
				<cfset arguments.to.LastName = 
				
						qRead.LastName
				/>
			
		</cfif>
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a Contact object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Contact which will be used to update a record in the table." required="yes" type="ContactManagerData.To.mssql.ContactTo" />
		<cfset var Convention = getConventions() />
		<cfset var qUpdate = 0 />
		
		
		<cfquery name="qUpdate" datasource="#_getConfig().getDsn()#">
			UPDATE #Convention.FormatObjectName(getObjectMetadata(), '')#
			SET 
			
				#Convention.formatUpdateFieldName('FirstName')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.FirstName#"
					 />
				,
				#Convention.formatUpdateFieldName('LastName')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.LastName#"
					 />
				
			WHERE
			
				#Convention.formatUpdateFieldName('ContactId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.ContactId#"
					 />
				
		</cfquery>
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a record in the Contact table." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Contact which will be used to delete from the table." required="yes" type="ContactManagerData.To.mssql.ContactTo" />
		<cfset var Convention = getConventions() />
		<cfset var qDelete = 0 />
		
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#">
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata(), '')#
			WHERE
			
				#Convention.formatFieldName('ContactId', 'Contact')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.ContactId#"
					 />
				
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>
	
