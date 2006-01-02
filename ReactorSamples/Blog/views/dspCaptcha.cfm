<cfset Captcha = viewstate.getValue("Captcha") />

<cfcontent file="#expandPath("images/captcha/#Captcha.fileName#")#" type="image/jpeg" deletefile="yes" reset="yes" /><cfabort>