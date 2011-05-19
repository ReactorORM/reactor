<cfcomponent output="false">
	<cffunction name="getValue" returntype="any" access="public" output="false">
		<cfargument name="event">
		<cfargument name="field">
	</cffunction>
	
	
	<cffunction name="renderInput" returntype="string" access="public" output="false">
		<cfargument name="inputfield" type="string">
		<cfargument name="RecordObject" type="reactor.base.abstractRecord">
		<cfargument name="reactor" type="reactor.reactorFactory">
			<cfscript>
				var r_sField = "";
				var MetaData = RecordObject._getObjectMetadata();
				var aRels = MetaData.getRelationships();
				var r = "";
				var re = "" ;
				var RelatedObject = "";
				var RelatedMetaData = "";
				for(r=1;r<=ArrayLen(aRels);r++){
					if(aRels[r].type EQ "hasone"){
						//See if this field has a related Object
						for(re=1;re<=ArrayLen(aRels[r].relate);re++){
							if(aRels[r].relate[re].from EQ arguments.inputfield){
								RelatedObject = reactor.createGateWay(aRels[r].alias);
								RelatedMetaData = reactor.createMetaData(aRels[r].alias);
								break;
							}			
						}
					}
				}
			</cfscript>
			
				
			<cfsavecontent variable="r_sField">
				
				<cfdump var="#aRels#">
				<cfoutput><label for="#arguments.inputfield#">#camelCaseToTitle(arguments.inputfield)#</label></cfoutput>
				<cfset readonly = "">
				<!--- Add the readonly --->
				<cfif MetaData.getPrimaryKey() EQ arguments.inputfield>
					<cfset readonly = "readonly=""true""">
				</cfif>
				<cfif isObject(RelatedObject)>
					<cfset qRelated = RelatedObject.getAll()>
					<cfset counter = 1>
					<select name="#arguments.inputfield#" id="#arguments.inputfield#" #readonly#>
						<cfloop query="qRelated">
							<!--- Do the selected="selected" thing --->
							<cfset selected = "">
							<cfif qRelated[RelatedMetaData.getPrimaryKey()] EQ Evaluate("RecordObject.get#arguments.inputfield#()")>
								<cfset selected="selected=""selected""">
							</cfif>
							<cfoutput><option value="#qRelated[RelatedMetaData.getPrimaryKey()]#" #selected#>#qRelated[RelatedMetaData.getDisplayField()]#</option>	</cfoutput>					
							<cfset counter++>
						</cfloop>
					</select>
				<cfelse>
				<cfoutput>
				<input type="string" name="#arguments.inputfield#" id="#arguments.inputfield#" value="#Evaluate("RecordObject.get#arguments.inputField#()")#"  #readonly#/>
				</cfoutput>
				</cfif>
			</cfsavecontent>
		
		<cfreturn r_sField>	
	</cffunction>
	
	
	<cffunction name="camelCaseToTitle" access="private" output="false">
		<cfargument name="string">
		<cfset arguments.string = ReReplace(arguments.string, "(^.| .)", "\u\1",'one')>
		<cfreturn ReReplace(arguments.string, "(\B[A-Z])", " \1", "all")>
	</cffunction>
</cfcomponent>