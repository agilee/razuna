<!---
*
* Copyright (C) 2005-2008 Razuna
*
* This file is part of Razuna - Enterprise Digital Asset Management.
*
* Razuna is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Razuna is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero Public License for more details.
*
* You should have received a copy of the GNU Affero Public License
* along with Razuna. If not, see <http://www.gnu.org/licenses/>.
*
* You may restribute this Program with a special exception to the terms
* and conditions of version 3.0 of the AGPL as described in Razuna's
* FLOSS exception. You should have received a copy of the FLOSS exception
* along with Razuna. If not, see <http://www.razuna.com/licenses/>.
*
--->
<cfoutput>
<cfcontent reset="true">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US">
<head>
<title><cfif application.razuna.whitelabel>#wl_html_title#<cfelse>Razuna Enterprise Digital Asset Management</cfif></title>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<!--- Control the cache --->
<!---
<cfheader name="Expires" value="#GetHttpTimeString(DateAdd('d', 1, Now()))#">
<cfheader name="PRAGMA" value="#GetHttpTimeString(DateAdd('d', 1, Now()))#">
--->
<cfheader name="Expires" value="#GetHttpTimeString(Now())#">
<cfheader name="CACHE-CONTROL" value="NO-CACHE, no-store, must-revalidate">
<cfheader name="PRAGMA" value="#GetHttpTimeString(Now())#">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<script language="JavaScript" type="text/javascript">var dynpath = '#dynpath#';</script>
<!--- CSS --->
<link rel="stylesheet" type="text/css" href="#dynpath#/global/host/dam/views/layouts/main.css?_v=#attributes.cachetag#" />
<!--- JS --->
<script type="text/javascript" src="#dynpath#/global/js/jquery-1.7.2.min.js?_v=#attributes.cachetag#"></script>
<script type="text/javascript" src="#dynpath#/global/js/jquery.validate.min.js?_v=#attributes.cachetag#"></script>
<script type="text/javascript" src="#dynpath#/global/js/jquery.form.min.js?_v=#attributes.cachetag#"></script>
<script type="text/javascript" src="#dynpath#/global/host/dam/js/login.min.js?_v=#attributes.cachetag#"></script>
<cfif jr_enable EQ "true"><cfinclude template="../../js/janrain.cfm" runonce="true"></cfif>
<link rel="SHORTCUT ICON" href="favicon.ico" />
<style>
body{
  /*background-image: url(../../global/host/dam/images/login_bg.jpg);*/
  background-image: url(../../global/host/dam/images/pimsourcebg.jpg);
}
##outer{
  background-color: transparent;
  margin-top: 0px;
}
</style>
</head>
<body>
<div id="container">
	#trim(thecontent)#
</div>
<cfif application.razuna.isp>
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-27003876-1']);
  _gaq.push(['_setDomainName', 'razuna.com']);
  _gaq.push(['_trackPageview']);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>
</cfif>
</body>
</html>
</cfoutput>