<cfset BlogConfig = viewState.getValue("BlogConfig") />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
   "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="alternate" type="application/rss+xml" href="index.cfm?event=rss" title="<cfoutput>#BlogConfig.getBlogTitle()#</cfoutput>">
<link rel="stylesheet" href="scripts/styles/styles.css" />
<title><cfoutput>#BlogConfig.getBlogTitle()#</cfoutput></title>
</head>

<body>
<img src="images/logo.gif" alt="DougHughes.net" id="logo" />

<cfif BlogConfig.searchEnabled()>
	<div id="searchField">
		<cfform name="search" action="index.cfm?event=search" method="post">
			Search: 
			<cfinput type="text" name="criteria" value="#viewstate.getValue('criteria')#" size="20" maxlength="40" class="inputText" />
			<cfinput type="submit" name="Submit" value="Search" class="inputSubmit" />
		</cfform>
	</div>
</cfif>

<div id="body">
	<cfif server.ColdFusion.ProductName IS "ColdFusion Server" AND ListFirst(server.ColdFusion.ProductVersion) GTE 7>
		<!--- print --->
		<span id="printButtons">
			Print this page:
			<cfoutput>
				<a href="index.cfm?#CGI.QUERY_STRING#&print=flashPaper"><img src="images/flashPaper.gif" /></a>
				<a href="index.cfm?#CGI.QUERY_STRING#&print=flashPaper">FlashPaper</a>
				<a href="index.cfm?#CGI.QUERY_STRING#&print=pdf"><img src="images/acrobat.gif" /></a>
				<a href="index.cfm?#CGI.QUERY_STRING#&print=pdf">Acrobat</a>
			</cfoutput>
		</span>
	</cfif>
		
	<!--- content --->
	<div id="content">
		<cfif viewCollection.exists("body")>
			<cfoutput>#viewCollection.getView("body")#</cfoutput>
		</cfif>
	</div>
	
	<!--- left nav --->
	<div id="leftNav">
		<cfif viewCollection.exists("leftNav")>
			<cfoutput>#viewCollection.getView("leftNav")#</cfoutput>
		</cfif>
	</div>
</div>

<br style="clear: both;" />

<div id="footer">
	<cfoutput>
		<p>Copyright #Year(Now())# Doug Hughes, All rights reserved.</p>
	</cfoutput>
	
	<cfif viewCollection.exists("bottomNav")>
		<cfoutput>#viewCollection.getView("bottomNav")#</cfoutput>
	</cfif>
</div>

<br style="clear: both;" />

</body>
</html>
