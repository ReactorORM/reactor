
	
<cfcomponent hint="I am the base DAO object for the Address table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractDao" >
	
	<cfset variables.signature = "21A2E5B68F903F232359A5EE1C80F954" />

	<cffunction name="save" access="public" hint="I create or update a Address record." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Address" required="yes" type="ReactorSamples.ContactManager.data.To.mssql.AddressTo" />

		
		<cfif IsNumeric(arguments.to.AddressId) AND Val(arguments.to.AddressId)>
			<cfset update(arguments.to) />
		<cfelse>
			<cfset create(arguments.to) />
		</cfif>
			
	</cffunction>
	
	
	
	<cffunction name="create" access="public" hint="I create a Address object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Address" required="yes" type="ReactorSamples.ContactManager.data.To.mssql.AddressTo" />
		<cfset var Convention = getConventions() />
		<cfset var qCreate = 0 />
		
			
		<cftransaction>
			<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">
				INSERT INTO #Convention.FormatObjectName(getObjectMetadata(), '')#
				(
					
							#Convention.formatFieldName('ContactId', 'Address')#
							,
							#Convention.formatFieldName('Line1', 'Address')#
							,
							#Convention.formatFieldName('Line2', 'Address')#
							,
							#Convention.formatFieldName('City', 'Address')#
							,
							#Convention.formatFieldName('StateId', 'Address')#
							,
							#Convention.formatFieldName('PostalCode', 'Address')#
							,
							#Convention.formatFieldName('CountryId', 'Address')#
							
				) VALUES (
					
							<cfqueryparam cfsqltype="cf_sql_integer"
							
							value="#arguments.to.ContactId#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.Line1#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.Line2#"
								
								null="#Iif(NOT Len(arguments.to.Line2), DE(true), DE(false))#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="50"
							
							value="#arguments.to.City#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_smallint"
							
							value="#arguments.to.StateId#"
								
								null="#Iif(NOT Len(arguments.to.StateId), DE(true), DE(false))#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_varchar"
							
								scale="20"
							
							value="#arguments.to.PostalCode#"
							 />
							,
							<cfqueryparam cfsqltype="cf_sql_smallint"
							
							value="#arguments.to.CountryId#"
							 />
							
				)
			</cfquery>
			
				<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">	
					#Convention.lastInseredIdSyntax(getObjectMetadata())#
				</cfquery>
			
		</cftransaction>
			
		
			<cfif qCreate.recordCount>
				<cfset arguments.to.AddressId = qCreate.id />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="read" access="public" hint="I read a  Address object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Address which will be populated." required="yes" type="ReactorSamples.ContactManager.data.To.mssql.AddressTo" />
		<cfset var qRead = 0 />
		<cfset var AddressGateway = _getReactorFactory().createGateway("Address") />
		
		<cfset qRead = AddressGateway.getByFields(
			AddressId = arguments.to.AddressId
		) />
		
		<cfif qRead.recordCount>
				<cfset arguments.to.AddressId = 
				
						qRead.AddressId
				/>
			
				<cfset arguments.to.ContactId = 
				
						qRead.ContactId
				/>
			
				<cfset arguments.to.Line1 = 
				
						qRead.Line1
				/>
			
				<cfset arguments.to.Line2 = 
				
						qRead.Line2
				/>
			
				<cfset arguments.to.City = 
				
						qRead.City
				/>
			
				<cfset arguments.to.StateId = 
				
						qRead.StateId
				/>
			
				<cfset arguments.to.PostalCode = 
				
						qRead.PostalCode
				/>
			
				<cfset arguments.to.CountryId = 
				
						qRead.CountryId
				/>
			
		</cfif>
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a Address object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Address which will be used to update a record in the table." required="yes" type="ReactorSamples.ContactManager.data.To.mssql.AddressTo" />
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
				#Convention.formatUpdateFieldName('Line1')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.Line1#"
					 />
				,
				#Convention.formatUpdateFieldName('Line2')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.Line2#"
					
						null="#Iif(NOT Len(arguments.to.Line2), DE(true), DE(false))#"
					 />
				,
				#Convention.formatUpdateFieldName('City')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="50"
					
					value="#arguments.to.City#"
					 />
				,
				#Convention.formatUpdateFieldName('StateId')# = <cfqueryparam
					cfsqltype="cf_sql_smallint"
					
					value="#arguments.to.StateId#"
					
						null="#Iif(NOT Len(arguments.to.StateId), DE(true), DE(false))#"
					 />
				,
				#Convention.formatUpdateFieldName('PostalCode')# = <cfqueryparam
					cfsqltype="cf_sql_varchar"
					
						scale="20"
					
					value="#arguments.to.PostalCode#"
					 />
				,
				#Convention.formatUpdateFieldName('CountryId')# = <cfqueryparam
					cfsqltype="cf_sql_smallint"
					
					value="#arguments.to.CountryId#"
					 />
				
			WHERE
			
				#Convention.formatUpdateFieldName('AddressId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.AddressId#"
					 />
				
		</cfquery>
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a record in the Address table." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for Address which will be used to delete from the table." required="yes" type="ReactorSamples.ContactManager.data.To.mssql.AddressTo" />
		<cfset var Convention = getConventions() />
		<cfset var qDelete = 0 />
		
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#">
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata(), '')#
			WHERE
			
				#Convention.formatFieldName('AddressId', 'Address')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.AddressId#"
					 />
				
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>
	
