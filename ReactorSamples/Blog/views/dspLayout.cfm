<cfset BlogConfig = viewState.getValue("BlogConfig") />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
   "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="stylesheet" href="scripts/styles/styles.css" />
<title><cfoutput>#BlogConfig.getBlogTitle()#</cfoutput></title>
</head>

<body>
<img src="images/logo.gif" alt="DougHughes.net" id="logo" />

<div id="body">
	<div id="content">
		<cfif viewCollection.exists("body")>
			<cfoutput>#viewCollection.getView("body")#</cfoutput>
		</cfif>
	</div>
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
