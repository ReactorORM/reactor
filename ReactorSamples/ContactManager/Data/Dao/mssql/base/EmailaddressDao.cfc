
	
<cfcomponent hint="I am the base DAO object for the EmailAddress table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractDao" >
	
	<cfset variables.signature = "4BB6551711F43BC31E23513D2CA9A89A" />

	<cffunction name="save" access="public" hint="I create or update a EmailAddress record." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for EmailAddress" required="yes" type="ReactorSamples.ContactManager.data.To.mssql.EmailAddressTo" />

		
		<cfif IsNumeric(arguments.to.EmailAddressId) AND Val(arguments.to.EmailAddressId)>
			<cfset update(arguments.to) />
		<cfelse>
			<cfset create(arguments.to) />
		</cfif>
			
	</cffunction>
	
	
	
	<cffunction name="create" access="public" hint="I create a EmailAddress object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for EmailAddress" required="yes" type="ReactorSamples.ContactManager.data.To.mssql.EmailAddressTo" />
		<cfset var Convention = getConventions() />
		<cfset var qCreate = 0 />
		
			
		<cftransaction>
			<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">
				INSERT INTO #Convention.FormatObjectName(getObjectMetadata(), '')#
				(
					
							#Convention.formatFieldName('ContactId', 'EmailAddress')#
							,
							#Convention.formatFieldName('EmailAddress', 'EmailAddress')#
							
				) VALUES (
					
							<cfqueryparam cfsqltype="cf_sql_integer"
							
							value="#arguments.to.ContactId#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="100"
							
							value="#arguments.to.EmailAddress#"
							 />
							
				)
			</cfquery>
			
				<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">	
					#Convention.lastInseredIdSyntax(getObjectMetadata())#
				</cfquery>
			
		</cftransaction>
			
		
			<cfif qCreate.recordCount>
				<cfset arguments.to.EmailAddressId = qCreate.id />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="read" access="public" hint="I read a  EmailAddress object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for EmailAddress which will be populated." required="yes" type="ReactorSamples.ContactManager.data.To.mssql.EmailAddressTo" />
		<cfset var qRead = 0 />
		<cfset var EmailAddressGateway = _getReactorFactory().createGateway("EmailAddress") />
		
		<cfset qRead = EmailAddressGateway.getByFields(
			EmailAddressId = arguments.to.EmailAddressId
		) />
		
		<cfif qRead.recordCount>
				<cfset arguments.to.EmailAddressId = 
				
						qRead.EmailAddressId
				/>
			
				<cfset arguments.to.ContactId = 
				
						qRead.ContactId
				/>
			
				<cfset arguments.to.EmailAddress = 
				
						qRead.EmailAddress
				/>
			
		</cfif>
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a EmailAddress object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for EmailAddress which will be used to update a record in the table." required="yes" type="ReactorSamples.ContactManager.data.To.mssql.EmailAddressTo" />
		<cfset var Convention = getConventions() />
		<cfset var qUpdate = 0 />
		
		
		<cfquery name="qUpdate" datasource="#_getConfig().getDsn()#">
			UPDATE #Convention.FormatObjectName(getObjectMetadata(), '')#
			SET 
			
				#Convention.formatUpdateFieldName('ContactId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.ContactId#"
					 />
				,
				#Convention.formatUpdateFieldName('EmailAddress')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="100"
					
					value="#arguments.to.EmailAddress#"
					 />
				
			WHERE
			
				#Convention.formatUpdateFieldName('EmailAddressId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.EmailAddressId#"
					 />
				
		</cfquery>
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a record in the EmailAddress table." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for EmailAddress which will be used to delete from the table." required="yes" type="ReactorSamples.ContactManager.data.To.mssql.EmailAddressTo" />
		<cfset var Convention = getConventions() />
		<cfset var qDelete = 0 />
		
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#">
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata(), '')#
			WHERE
			
				#Convention.formatFieldName('EmailAddressId', 'EmailAddress')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.EmailAddressId#"
					 />
				
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>
	
