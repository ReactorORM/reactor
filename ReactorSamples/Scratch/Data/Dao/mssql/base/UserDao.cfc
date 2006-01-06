
	
<cfcomponent hint="I am the base DAO object for the User table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractDao" >
	
	<cfset variables.signature = "853B86719DE37AC19E665A8A23411F0D" />

	<cffunction name="save" access="public" hint="I create or update a User record." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for User" required="yes" type="ScratchData.To.mssql.UserTo" />

		
		<cfif IsNumeric(arguments.to.UserId) AND Val(arguments.to.UserId)>
			<cfset update(arguments.to) />
		<cfelse>
			<cfset create(arguments.to) />
		</cfif>
			
	</cffunction>
	
	
	
	<cffunction name="create" access="public" hint="I create a User object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for User" required="yes" type="ScratchData.To.mssql.UserTo" />
		<cfset var Convention = getConventions() />
		<cfset var qCreate = 0 />
		
			
		<cftransaction>
			<cfquery name="qCreate" datasource="#_getConfig().getDsn()#">
				INSERT INTO #Convention.FormatObjectName(getObjectMetadata(), '')#
				(
					
							#Convention.formatFieldName('Username', 'User')#
							,
							#Convention.formatFieldName('Password', 'User')#
							,
							#Convention.formatFieldName('FirstName', 'User')#
							,
							#Convention.formatFieldName('LastName', 'User')#
							,
							#Convention.formatFieldName('DateCreated', 'User')#
							
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
							
				)
				
								#Convention.lastInseredIdSyntax(getObjectMetadata())#
						
				
				</cfquery>
		</cftransaction>
			
		
			<cfif qCreate.recordCount>
				<cfset arguments.to.UserId = qCreate.id />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="read" access="public" hint="I read a  User object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for User which will be populated." required="yes" type="ScratchData.To.mssql.UserTo" />
		<cfset var qRead = 0 />
		<cfset var UserGateway = _getReactorFactory().createGateway("User") />
		
		<cfset qRead = UserGateway.getByFields(
			UserId = arguments.to.UserId
		) />
		
		<cfif qRead.recordCount>
				<cfset arguments.to.UserId = 
				
						qRead.UserId
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
			
		</cfif>
	</cffunction>
	
	<cffunction name="update" access="public" hint="I update a User object." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for User which will be used to update a record in the table." required="yes" type="ScratchData.To.mssql.UserTo" />
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
				
			WHERE
			
				#Convention.formatUpdateFieldName('UserId')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.UserId#"
					 />
				
		</cfquery>
	</cffunction>
	
	<cffunction name="delete" access="public" hint="I delete a record in the User table." output="false" returntype="void">
		<cfargument name="to" hint="I am the transfer object for User which will be used to delete from the table." required="yes" type="ScratchData.To.mssql.UserTo" />
		<cfset var Convention = getConventions() />
		<cfset var qDelete = 0 />
		
		
		<cfquery name="qDelete" datasource="#_getConfig().getDsn()#">
			DELETE FROM #Convention.FormatObjectName(getObjectMetadata(), '')#
			WHERE
			
				#Convention.formatFieldName('UserId', 'User')# = <cfqueryparam
					cfsqltype="cf_sql_integer"
					
					value="#arguments.to.UserId#"
					 />
				
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>
	
