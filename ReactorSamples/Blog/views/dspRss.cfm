<cfheader name="content-type" value="text/xml" /><?xml version="1.0" encoding="iso-8859-1"?>

<cfset BlogConfig = viewstate.getValue("BlogConfig") />
<cfset entries = viewstate.getValue("entries") />
<cfset link = "http://" & CGI.SERVER_NAME & CGI.SCRIPT_NAME />

<rss version="2.0">
	<channel>
		<cfoutput>
			<title>#BlogConfig.getBlogTitle()#</title>
			<link>#link#</link>
			<description>#BlogConfig.getBlogDescription()#</description>
			<language>en-us</language>
			<pubDate>#dateFormat(now(), "ddd, dd mmm yyyy") & " " & timeFormat(now(), "HH:mm:ss") & " -" & numberFormat(getTimeZoneInfo().utcHourOffset, "00") & "00"#</pubDate>
			<lastBuildDate>#dateFormat(entries.publicationDateTime[1], "ddd, dd mmm yyyy") & " " & timeFormat(entries.publicationDateTime[1], "HH:mm:ss") & " -" & numberFormat(getTimeZoneInfo().utcHourOffset, "00") & "00"#</lastBuildDate>
			<generator>ReactorBlog</generator>
			<docs>http://blogs.law.harvard.edu/tech/rss</docs>
			<managingEditor>#BlogConfig.getAuthorEmailAddress()#</managingEditor>
			<webMaster>#BlogConfig.getAuthorEmailAddress()#</webMaster>
		</cfoutput>
	
		<cfoutput query="entries" group="entryId">
			<item>
				<title>#Replace(entries.title, "&", "&amp;", "all")#</title>
				<link>#link#?event=viewEntry&amp;entryId=#entries.entryID#</link>
				<description>#Replace(Trim(ReReplace(entries.preview, "<[^<]+?>", "", "all")), "&", "&amp;", "all")#</description>
				<cfoutput>
					<category>#Replace(entries.categoryName, "&", "&amp;", "all")#</category>
				</cfoutput>
				<pubDate>#dateFormat(entries.publicationDateTime, "ddd, dd mmm yyyy") & " " & timeFormat(entries.publicationDateTime, "HH:mm:ss") & " -" & numberFormat(getTimeZoneInfo().utcHourOffset, "00") & "00"#</pubDate>
				<guid>#link#?event=viewEntry&amp;entryId=#entries.entryID#</guid>
			</item>
		</cfoutput>
		
		
	</channel>
</rss>