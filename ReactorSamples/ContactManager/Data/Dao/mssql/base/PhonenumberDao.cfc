
	
<cfcomponent hint="I am the base DAO object for the PhoneNumber table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractDao" >
	
	<cfset variables.signature = "D26C7E5FB8D319B6167A41C898734D3A" />

	<cffunction name="save" access="public" hint="I create or update a PhoneNumber record." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for PhoneNumber" required="yes" type="ContactManagerData.To.mssql.PhoneNumberTo" />

		
		<cfif IsNumeric(arguments.to.PhoneNumberId) AND Val(arguments.to.PhoneNumberId)>
			<cfset update(arguments.to) />
		<cfelse>
			<cfset create(arguments.to) />
		</cfif>
			
	</cffunction>
	
	
	
	<cffunction name="create" access="public" hint="I create a PhoneNumber object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for PhoneNumber" required="yes" type="ContactManagerData.To.mssql.PhoneNumberTo" />
		<cfset var Convention = getConventions() />
		<cfset var qCreate = 0 />
		
			
		<cftransaction>
			<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">
				INSERT INTO #Convention.FormatObjectName(getObjectMetadata(), '')#
				(
					
							#Convention.formatFieldName('ContactId', 'PhoneNumber')#
							,
							#Convention.formatFieldName('PhoneNumber', 'PhoneNumber')#
							
				) VALUES (
					
							<cfqueryparam cfsqltype="cf_sql_integer"
							
							value="#arguments.to.ContactId#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.PhoneNumber#"
							 />
							
				)
			</cfquery>
			
				<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">	
					#Convention.lastInseredIdSyntax(getObjectMetadata())#
				</cfquery>
			
		</cftransaction>
			
		
			<cfif qCreate.recordCount>
				<cfset arguments.to.PhoneNumberId = qCreate.id />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="read" access="public" hint="I read a  PhoneNumber object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for PhoneNumber which will be populated." required="yes" type="ContactManagerData.To.mssql.PhoneNumberTo" />
		<cfset var qRead = 0 />
		<cfset var PhoneNumberGateway = _getReactorFactory().createGateway("PhoneNumber") />
		
		<cfset qRead = PhoneNumberGateway.getByFields(
			PhoneNumberId = arguments.to.PhoneNumberId
		) />
		
		<cfif qRead.recordCount>
				<cfset arguments.to.PhoneNumberId = 
				
						qRead.PhoneNumberId
				/>
			
				<cfset arguments.to.ContactId = 
				
						qRead.ContactId
				/>
			
				<cfset arguments.to.PhoneNumber = 
				
						qRead.PhoneNumber
				/>
			
		</cfif>
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a PhoneNumber object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for PhoneNumber which will be used to update a record in the table." required="yes" type="ContactManagerData.To.mssql.PhoneNumberTo" />
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
				#Convention.formatUpdateFieldName('PhoneNumber')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.PhoneNumber#"
					 />
				
			WHERE
			
				#Convention.formatUpdateFieldName('PhoneNumberId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.PhoneNumberId#"
					 />
				
		</cfquery>
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a record in the PhoneNumber table." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for PhoneNumber which will be used to delete from the table." required="yes" type="ContactManagerData.To.mssql.PhoneNumberTo" />
		<cfset var Convention = getConventions() />
		<cfset var qDelete = 0 />
		
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#">
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata(), '')#
			WHERE
			
				#Convention.formatFieldName('PhoneNumberId', 'PhoneNumber')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.PhoneNumberId#"
					 />
				
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>
	
