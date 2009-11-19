<cfcomponent hint="This is a simple iterator used in the getByFilter function" output="false">
			
		<cfscript>
			variables.query = QueryNew("null");
			variables.Record = "";
			variables.currentRow = 0;
			variables.totalRows = 0; 
			variables.stFields = StructNew();
		</cfscript>

		<cffunction name="init" output="false" returntype="any" access="public">
			<cfargument name="Query" required="true">
			<cfargument name="RecordObject" required="true">	
				<cfscript>
					variables.Record = arguments.RecordObject;
					variables.Query = arguments.Query;
					variables.totalRows = variables.Query.recordcount;
				</cfscript>
			<cfreturn this>
		</cffunction>
		
		<cfscript>
			function getTotal(){
				return variables.totalRows;
			}
		</cfscript>

		<cffunction name="hasMore" returntype="boolean" output="false" access="public">
				<cfif variables.currentRow LT variables.totalRows>
					<cfreturn true>
				</cfif>
			<cfreturn false>
		</cffunction>

		<cffunction name="getNext" returntype="any" output="false" access="public">
				<cfscript>
					variables.currentRow = variables.currentRow + 1;
					var stFields = StructNew();	
					//Load the record
					var col = "";
				</cfscript>
					<cfloop list="#variables.Query.columnList#" index="col">
						<cfset stFields[col] = variables.Query[col][variables.currentRow]>
					</cfloop> 
				<cfset variables.Record.init(argumentCollection=stFields)>
			<cfreturn variables.Record>
		</cffunction>

		<cffunction name="getRecordCount" returntype="numeric" output="false" access="public">
				<cfreturn variables.totalRows>
		</cffunction>
		
		<!--- Reset --->
		<cffunction name="reset" returntype="any" output="false" access="public">
			<cfscript>
				variables.currentRow = 0;
			</cfscript>
		</cffunction>

		<cffunction name="hasNext" returntype="boolean" output="false" access="public">
				<cfif variables.currentRow LT variables.totalRows>
					<cfreturn true>
				</cfif>
			<cfreturn false>
		</cffunction>

		<cffunction name="next" returntype="any" output="false" access="public">
				<cfscript>
					variables.currentRow = variables.currentRow + 1;
					var stFields = StructNew();	
					//Load the record
					var col = "";
				</cfscript>
					<cfloop list="#variables.Query.columnList#" index="col">
						<cfset stFields[col] = variables.Query[col][variables.currentRow]>
					</cfloop> 
				<cfset variables.Record.init(argumentCollection=stFields)>
			<cfreturn variables.Record>
		</cffunction>

		<cffunction name="getTotalRecords" returntype="numeric" output="false" access="public">
				<cfreturn variables.totalRows>
		</cffunction>
		
		<!--- Reset --->
		<cffunction name="reset" returntype="any" output="false" access="public">
			<cfscript>
				variables.currentRow = 0;
			</cfscript>
		</cffunction>
		
		
</cfcomponent>
