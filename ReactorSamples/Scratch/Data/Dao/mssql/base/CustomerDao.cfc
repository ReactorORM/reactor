
	
<cfcomponent hint="I am the base DAO object for the Customer table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractDao" >
	
	<cfset variables.signature = "CCA4E499673B1A3F1C864B58F500D055" />

	<cffunction name="save" access="public" hint="I create or update a Customer record." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Customer" required="yes" type="ScratchData.To.mssql.CustomerTo" />

		
		<cfif IsNumeric(arguments.to.CustomerId) AND Val(arguments.to.CustomerId)>
			<cfset update(arguments.to) />
		<cfelse>
			<cfset create(arguments.to) />
		</cfif>
			
	</cffunction>
	
	
	
	<cffunction name="create" access="public" hint="I create a Customer object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Customer" required="yes" type="ScratchData.To.mssql.CustomerTo" />
		<cfset var Convention = getConventions() />
		<cfset var qCreate = 0 />
		
			
		<cftransaction>
			<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">
				INSERT INTO #Convention.FormatObjectName(getObjectMetadata(), '')#
				(
					
							#Convention.formatFieldName('Username', 'Customer')#
							,
							#Convention.formatFieldName('Password', 'Customer')#
							,
							#Convention.formatFieldName('FirstName', 'Customer')#
							,
							#Convention.formatFieldName('LastName', 'Customer')#
							,
							#Convention.formatFieldName('DateCreated', 'Customer')#
							,
							#Convention.formatFieldName('AddressId', 'Customer')#
							
				) VALUES (
					
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.Username#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.Password#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.FirstName#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.LastName#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_timestamp"
							
							value="#arguments.to.DateCreated#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_integer"
							
							value="#arguments.to.AddressId#"
							 />
							
				)
				
								#Convention.lastInseredIdSyntax(getObjectMetadata())#
						
				
				</cfquery>
		</cftransaction>
			
		
			<cfif qCreate.recordCount>
				<cfset arguments.to.CustomerId = qCreate.id />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="read" access="public" hint="I read a  Customer object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Customer which will be populated." required="yes" type="ScratchData.To.mssql.CustomerTo" />
		<cfset var qRead = 0 />
		<cfset var CustomerGateway = _getReactorFactory().createGateway("Customer") />
		
		<cfset qRead = CustomerGateway.getByFields(
			CustomerId = arguments.to.CustomerId
		) />
		
		<cfif qRead.recordCount>
				<cfset arguments.to.CustomerId = 
				
						qRead.CustomerId
				/>
			
				<cfset arguments.to.Username = 
				
						qRead.Username
				/>
			
				<cfset arguments.to.Password = 
				
						qRead.Password
				/>
			
				<cfset arguments.to.FirstName = 
				
						qRead.FirstName
				/>
			
				<cfset arguments.to.LastName = 
				
						qRead.LastName
				/>
			
				<cfset arguments.to.DateCreated = 
				
						qRead.DateCreated
				/>
			
				<cfset arguments.to.AddressId = 
				
						qRead.AddressId
				/>
			
		</cfif>
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a Customer object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Customer which will be used to update a record in the table." required="yes" type="ScratchData.To.mssql.CustomerTo" />
		<cfset var Convention = getConventions() />
		<cfset var qUpdate = 0 />
		
		
		<cfquery name="qUpdate" datasource="#_getConfig().getDsn()#">
			UPDATE #Convention.FormatObjectName(getObjectMetadata(), '')#
			SET 
			
				#Convention.formatUpdateFieldName('Username')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.Username#"
					 />
				,
				#Convention.formatUpdateFieldName('Password')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.Password#"
					 />
				,
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
				,
				#Convention.formatUpdateFieldName('DateCreated')# = <cfqueryparam
					cfsqltype="cf_sql_timestamp"
					
					value="#arguments.to.DateCreated#"
					 />
				,
				#Convention.formatUpdateFieldName('AddressId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.AddressId#"
					 />
				
			WHERE
			
				#Convention.formatUpdateFieldName('CustomerId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.CustomerId#"
					 />
				
		</cfquery>
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a record in the Customer table." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Customer which will be used to delete from the table." required="yes" type="ScratchData.To.mssql.CustomerTo" />
		<cfset var Convention = getConventions() />
		<cfset var qDelete = 0 />
		
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#">
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata(), '')#
			WHERE
			
				#Convention.formatFieldName('CustomerId', 'Customer')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.CustomerId#"
					 />
				
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>
	
