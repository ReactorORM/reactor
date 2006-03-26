<cfcomponent>
	<cffunction name="init" returntype="ReactorCompiler" access="public" output="false">
		<cfargument name="configPath" type="string" required="true" />

		<cfif fileExists(arguments.configPath)>
			<cfset variables.configPath = arguments.configPath>
		<cfelseif fileExists(expandPath(arguments.configPath))>
			<cfset variables.configPath = expandPath(arguments.configPath)>
		<cfelse>
			<cfset throwBadConfigPath()>
		</cfif>

		<cfset variables.configFile = xmlParse(variables.configPath)>

		<cfreturn this />
	</cffunction>

	<cffunction name="run" returntype="void" access="remote" output="true">
		<cfargument name="configPath" type="string" default="" />
		<cfargument name="deleteFirst" type="boolean" default="false" />

		<cfset var objects = "">
		<cfset var i = "">
		<cfset var projName = "">
		<cfset var projPath = "">
		<cfset var rf = "">
		<cfset var ticStart = getTickCount()>
		<cfset var objCounter = 0>
		<cfset var obj = "">

		<cfif not structKeyExists(variables,"configPath") and len(arguments.configPath)>
			<cfset init(arguments.configPath)>
		<cfelse>
			<cfset throwBadConfigPath()>
		</cfif>

		<cfset objects = variables.configFile.reactor.objects.xmlChildren>
		<cfset projName = variables.configFile.reactor.config.project.xmlAttributes.value>
		<cfset projPath = expandPath('/reactor/project/' & projName)>
		<cfset rf = createObject("component","reactor.ReactorFactory").init(variables.configPath)>

		<cfif arguments.deleteFirst and directoryExists(projPath)>
			<cfdirectory action="delete" directory="#projPath#" recurse="true" />
		</cfif>

		<cfoutput>
			Generating Reactor objects for project #projName# (#arrayLen(objects)# object tags):<br><br>
			<cfflush />
			<cfloop from="1" to="#arrayLen(objects)#" index="i">
				<cfif structKeyExists(objects[i].xmlAttributes,"alias")>
					<cfset obj = objects[i].xmlAttributes.alias>
				<cfelse>
					<cfset obj = objects[i].xmlAttributes.name>
				</cfif>
				&nbsp;&nbsp;&nbsp;&nbsp;(#i#) Generating objects for: #obj#<br><cfflush />
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Record object...<br><cfflush />
				<cfset rf.createRecord(obj)>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Gateway object...<br><cfflush />
				<cfset rf.createGateway(obj)>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Metadata object...<br><cfflush />
				<cfset rf.createMetadata(obj)>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Transfer object...<br><cfflush />
				<cfset rf.createTo(obj)>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DAO object...<br><cfflush />
				<cfset rf.createDao(obj)>
				&nbsp;&nbsp;&nbsp;&nbsp;Object #obj# done!<br><br><cfflush />
			</cfloop>
			Finished generating #arrayLen(objects)# Reactor object sets for project #projName# in #(getTickCount()-ticStart)/1000# seconds.<br><br>
			<cfflush />
		</cfoutput>
	</cffunction>

	<cffunction name="throwBadConfigPath" access="private" returntype="void" output="false">
		<cfthrow message="Bath path to config" detail="You have specified an invalid path to your Reactor Config File." />
	</cffunction>
</cfcomponent>