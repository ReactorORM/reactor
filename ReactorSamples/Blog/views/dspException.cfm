<cfset exception = viewstate.getValue("exception") />
<cfset tracks = viewstate.getValue("tracks") />

<h1>Oops! There was an error</h1>

<cfoutput>
	<table>
		<tr>
			<td valign="top"><b>Message</b></td>
			<td valign="top">#exception.message#</td>
		</tr>
		<tr>
			<td valign="top"><b>Detail</b></td>
			<td valign="top">#exception.detail#</td>
		</tr>
		<tr>
			<td valign="top"><b>Extended Info</b></td>
			<td valign="top">#exception.ExtendedInfo#</td>
		</tr>
		<tr>
			<td valign="top"><b>Tag Context</b></td>
			<td valign="top">
				<cfset tagCtxArr = exception.TagContext />
				<cfloop index="i" from="1" to="#ArrayLen(tagCtxArr)#">
					<cfset tagCtx = tagCtxArr[i] />
					#tagCtx['template']# (#tagCtx['line']#)<br>
				</cfloop>
			</td>
		</tr>
	</table>
</cfoutput>

<h2>CGI Details</h2>

<cfdump var="#CGI#" />

<h2>User Tracks</h2>

<cfloop from="#ArrayLen(tracks)#" to="1" index="x" step="-1">
	<cfset Track = tracks[x] />
	<table>
		<cfoutput>
			<tr>
				<td colspan="2"><h3 style="border: 1px solid black;">#x#.</h3></td>
			</tr>
			<tr>
				<td>
					<strong>URL:</strong> 
				</td>
				<td>
					<a href="#Track.getUrl()#">#Track.getUrl()#</a>
				</td>
			</tr>
			<tr>
				<td>
					<strong>Referrer:</strong> 
				</td>
				<td>
					<cfif Len(Track.getReferrer())>
						<a href="#Track.getReferrer()#">#Track.getReferrer()#</a>
					<cfelse>
						<em>None</em>
					</cfif>
				</td>
			</tr>
			<tr>
				<td>
					<strong>Event Values:</strong> 
				</td>
				<td>
					<cfset Values = Track.getValues() />
					<cfif StructCount(Values)>
						<table>
							<cfloop collection="#Values#" item="item">
								<tr>
									<td>
										<span style="text-decoration: underline;">#item#:</span> 
									</td>
									<td>
										<cfif IsObject(Values[item])>
											<em>Object</em>
										<cfelseif NOT IsSimpleValue(Values[item])>
											<em>Complex Value</em>
										<cfelse>
											#Values[item]#
										</cfif>
									</td>
								</tr>
							</cfloop>
						</table>
					<cfelse>
						<em>None</em>
					</cfif>
				</td>
			</tr>
			<tr>
				<td>
					<strong>Time:</strong> 
				</td>
				<td>
					#DateFormat(Track.getTime(), "mm/dd/yyyy")# #TimeFormat(Track.getTime(), "h:mm:ss tt")#
				</td>
			</tr>
		</cfoutput>
	</table>
	
</cfloop>