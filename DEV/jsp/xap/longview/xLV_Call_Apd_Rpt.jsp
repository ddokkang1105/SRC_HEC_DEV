<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<title>[sample] Longview_Fuction_Samples_assign</title>
	<meta http-equiv="x-ua-compatible" content="IE=edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="apple-mobile-web-app-title" content="[sample] Longview_Fuction_Samples_assign">
	<meta name="application-name" content="[sample] Longview_Fuction_Samples_assign" />
	<link rel="shortcut icon" href="/longview/client/img/favicon.ico" sizes="256x256" />
	<link href="/longview/client/img/favicon57.png" rel="apple-touch-icon-precomposed">
	<link href="/longview/client/img/favicon72.png" rel="apple-touch-icon-precomposed" sizes="72x72">
	<link href="/longview/client/img/favicon114.png" rel="apple-touch-icon-precomposed" sizes="114x114">
	<link href="/longview/client/img/favicon144.png" rel="apple-touch-icon-precomposed" sizes="144x144">
	<meta name="msapplication-TileImage" content="/longview/clientfavicon144.png"/>
	<meta name="msapplication-TileColor" content="#c5eeff"/>
	<meta name="msapplication-tap-highlight" content="no" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
	<style>
	@-ms-viewport{
		width: device-width;
	}
	</style>
	<link type="text/css" rel="stylesheet" href="/longview/client/css/arcclient.css"/>
</head>
<body id="arcBody" style="background-color:Silver">

	<div id="arcContainer" class="arcContainer"></div>
	<script type="text/javascript">
		var script = "/longview/client/js/version_cb.js?b=" + (new Date()).getTime();
		document.writeln("<script type='text/javascript' src='" + script + "'><\/script>");
	</script>
	<script type="text/javascript">
		var ARCPLAN = ARCPLAN || {},
			version_argument = version_argument || "",
			startupScript;
		
		var apdID = "${apdID}";
		
		if(apdID == "ARCBASIC") {
			ARCPLAN.language = "server";
			ARCPLAN.application = "arcBasicSource";
			ARCPLAN.startDocName = "00_arcBasic_Start.apd";
			ARCPLAN.arcCgiSite = "/cgi-bin/arcCGI10.exe";
			
		} else {	
			ARCPLAN.language = "server";
			ARCPLAN.application = "${apdID}";
			ARCPLAN.startDocName = "${apdID}.apd";
			ARCPLAN.arcCgiSite = "/cgi-bin/arcCGI10.exe";
		}

		startupScript = "/longview/client/js/arcclientstartup.js?" + version_argument;
		document.writeln("<script type='text/javascript' src='" + startupScript + "'><\/script>");
	</script>
</body>
</html>
