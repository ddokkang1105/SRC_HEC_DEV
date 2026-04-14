<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00105" var="WM00105"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00069" var="WM00069"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00057" var="CM00057"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00058" var="CM00058" arguments="CSR"/>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	String modelID  = (String)request.getAttribute("ModelID");
	String ItemID = (String)request.getAttribute("ItemID");
	String modelXML = (String)request.getAttribute("modelXML");	
	String modelExsist = (String)request.getAttribute("modelExsist");
	String modelName = (String)request.getAttribute("modelName");	
	String diagramForXml = (String)request.getAttribute("diagramForXml");
	String updateForXml=(String)request.getAttribute("updateForXml");
%>
<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=5,IE=9" ><![endif]-->
<!DOCTYPE html>
<html>
<head>
    <title>SF OLM Diagrams</title>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="Description" content="draw.io is free online diagram software for making flow charts, process diagrams, org charts, UML, ER and network diagrams">
    <meta name="Keywords" content="diagram, online, visio, flow chart maker, uml, erd">
    <meta itemprop="name" content="draw.io - free flow chart maker and diagrams online">
	<meta itemprop="description" content="draw.io is a free online diagramming application  and flow chart maker . You can use it to create UML, entity relationship,
		org charts, BPMN and BPM, database schema and networks. Also possible are telecommunication network, workflow, flowcharts, maps overlays and GIS, electronic 
		circuit and social network diagrams. It's like a mini version of Visio in your browser.">
	<meta itemprop="image" content="https://lh4.googleusercontent.com/-cLKEldMbT_E/Tx8qXDuw6eI/AAAAAAAAAAs/Ke0pnlk8Gpg/w500-h344-k/BPMN%2Bdiagram%2Brc2f.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<%@ include file="/WEB-INF/jsp/template/uiInc_model.jsp"%>
	<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/diagram.css">
    <link rel="stylesheet" type="text/css" href="modeling/mxgraph_v3.4/styles/grapheditor.css">
	<script type="text/javascript" src="./modeling/mxgraph_v3.4/js/jquery-1.4.2.min.js"></script>
	<script type="text/javascript" src="./modeling/mxgraph_v3.4/js/jquery.simplemodal-1.3.5.min.js"></script>
	<script type="text/javascript" src="./cmm/js/xbolt/popupHelper.js"></script>
	<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

	<script type="text/javascript">	
		function urlReload() {
			thisReload();
		}
		
		function thisReload() {
			var url = "newDiagramViewer";
			var	target = "actFrame";
			var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID=${ItemID}";
			parent.setActFrame(url,'','','${tobeViewOption}','');	 	
		}
	</script>

	<!--[if (IE 9)|(IE 10)]><!-->
		<script type="text/vbscript">
			Function mxUtilsBinaryToArray(Binary)
				Dim i
				ReDim byteArray(LenB(Binary))
				For i = 1 To LenB(Binary)
					byteArray(i-1) = AscB(MidB(Binary, i, 1))
				Next
				mxUtilsBinaryToArray = byteArray
			End Function
		</script>
	<!--<![endif]-->
	<script type="text/javascript">
		var clickNo = 1;		
		var t0 = new Date();
		// Public global variables
		var DEF_FONT = "${sessionScope.loginInfo.sessionDefFont}";
		var DEF_FONTSIZE = "${sessionScope.loginInfo.sessionDefFontSize}";
		var DEF_FONTSTYLE = "${sessionScope.loginInfo.sessionDefFontStyle}";
		var DEF_FONTCOLOR = "${sessionScope.loginInfo.sessionDefFontColor}";
		var DISPLY_RIGHT_BAR="${displayRightBar}";
		var NEXT_DISPLY_RIGHT_BAR=DISPLY_RIGHT_BAR;		
		var SCRN_TYPE = 'view';
		var DEF_LANGCODE = "${sessionScope.loginInfo.sessionCurrLangCode}";
		var DefaultXml = "/default_"+DEF_LANGCODE+".xml";
		
		var BASE_PATH = './modeling/mxgraph_v3.4/';
		
		var MAX_REQUEST_SIZE = 10485760;
		var MAX_AREA = 10000 * 10000;
	
		var idx = (window.location.href).lastIndexOf('/');
		var baseUrl=(window.location.href).substring(0,idx);
		
		var EXPORT_URL = baseUrl+'/export';
		var SAVE_URL = 'save';
		var OPEN_URL = 'open';
		var PROXY_URL = 'proxy';
		
		var STENCIL_PATH = BASE_PATH+'stencils';
		var SHAPES_PATH = BASE_PATH+'shapes';
		var IMAGE_PATH = BASE_PATH+'images';
		var DISPLAY_IMAGE_PATH = "${root}${HTML_IMG_DIR_MODEL_SYMBOL}/display/"; 
		var GRAPH_IMAGE_PATH = BASE_PATH+'img';
		var ICONFINDER_PATH = (navigator.userAgent.indexOf('MSIE') >= 0) ? 'iconfinder' : 'https://www.draw.io/iconfinder';
		var STYLE_PATH = BASE_PATH+'styles';
		var CSS_PATH = BASE_PATH+'styles';
		var OPEN_FORM = 'open.html';
		var TEMPLATE_PATH = BASE_PATH+'/templates';
		var DROPBOX_APPKEY = 'libwls2fa9szdji';
		
		var RESOURCES_PATH = BASE_PATH+'resources';
		var RESOURCE_BASE = RESOURCES_PATH + '/dia';
		
		var DIAGRAM_PATH = "diagram";
	
		var tapAndHoldStartsConnection = true;
		var showConnectorImg = true;
		
		var modelExsist  = "<%=modelExsist%>";
		if(modelExsist =="null"){alert("${WM00105}");}	
		var model = <%=modelID%>;	
		var itemID = "${ItemID}";
		var arCode = "${option}";
		var linkOption = "${linkOption}";
		var modelName = "${modelName}";
		var itemBlocked = "${itemBlocked}";
		var itemAthId = "${itemAthId}";
		var ChangeMgt = "${changeMgt}";
		var itemIdentifier = "${itemIdentifier}";
		var userId = "${sessionScope.loginInfo.sessionUserId}";
		var modelBlocked = "${ModelBlocked}";
		var mlvl = "${sessionScope.loginInfo.sessionMlvl}";
		var authLev = "${sessionScope.loginInfo.sessionAuthLev}";
		var modelIsPublic = "${ModelIsPublic}";
		var auth="N";
		var modelTypeName = "${modelTypeName}"; 
		var isModel = "${isModel}";
		var quickCheckOut = "${quickCheckOut}";
		var itemStatus = "${itemStatus}"; 
		var viewType = "${viewType}"; 
		var positionX = "${positionX}";
		var positionY = "${positionY}";
		var menuUrl = "${menuUrl}";	
		var viewScale = "${viewScale}";
		var focusedItemID = "${focusedItemID}";
		var scrnType = "${scrnType}";
		var attrRevYN = "${attrRevYN}";
		var changeSetID = "${changeSetID}";
		var infoTabURL = "${infoTabURL}";
		var procInstNo = "${procInstNo}";
		var varFilter = "${varFilter}";
		var warningDisplay = "N";
		
		var popupViewModelUrl = "popupMasterMdlEdt.do?instanceNo="+procInstNo;
				
		//if(procInstNo != "") popupViewModelUrl = "viewProcInstModel.do?instanceNo="+procInstNo;
		if(itemBlocked == "0" ){
			if(modelIsPublic == 1 ){
				auth = "Y"; 	
			}else{
				if(itemAthId == userId && modelBlocked == "0"  || mlvl == "SYS" ){
					auth = "Y"; 
				}
			}
		}else{
			auth="N";
		}
		
		var urlParams = (function(url) 
		{ 
			var result = new Object();

			url=url+"&demo=1";
			var idx = url.lastIndexOf('?');
	
			if (idx > 0){
				var params = url.substring(idx + 1).split('&');				
				for (var i = 0; i < params.length; i++){
					idx = params[i].indexOf('=');					
					if (idx > 0){
						result[params[i].substring(0, idx)] = params[i].substring(idx + 1);
					}
				}
			}
			return result;
		})(window.location.href);

		function mxscript(src)
		{
			document.write('<script src="'+src+'"></scr' + 'ipt>');
		};

		function mxinclude(src)
		{
			var g = document.createElement('script'); g.type = 'text/javascript'; g.async = true; g.src = src;
		    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(g, s);
		};

		var isSvgBrowser = navigator.userAgent.indexOf('MSIE') < 0 || document.documentMode >= 9;
		var isLocalStorage = false;

		function setCurrentXml(data, filename)
		{
			if (window.parent != null && window.parent.openFile != null)
			{
				window.parent.openFile.setData(data, filename);
			}
		};

		function getLanguage() 
		{
			var lang = (urlParams['offline'] == '1') ? 'en' : urlParams['lang'];
			
			if (lang == null && typeof(JSON) != 'undefined')
			{
				if (isLocalStorage) 
				{
					try
					{
						var value = localStorage.getItem('.drawio-config');
						
						if (value != null)
						{
							lang = JSON.parse(value).language || null;
						}
					}
					catch (e)
					{
						isLocalStorage = false;
					}
				}
			}
			
			return lang;
		};

		var mxLoadResources = false;
		var mxLanguage = "${sessionScope.loginInfo.sessionCurrLangCode}";
		var msLanguageType = "${sessionScope.loginInfo.sessionCurrLangType}";

		var mxLanguageMap = {'i18n': '', 'id' : 'Bahasa Indonesia', 'ms' : 'Bahasa Melayu', 'bs' : 'Bosanski', 'ca' : 'Català', 'cs' : 'Čeština', 'da' : 'Dansk', 'de' : 'Deutsch', 'et' : 'Eesti', 'en' : 'English', 'es' : 'Español', 
				'fil' : 'Filipino', 'fr' : 'Français', 'it' : 'Italiano', 'hu' : 'Magyar', 'nl' : 'Nederlands', 'no' : 'Norsk', 
				'pl' : 'Polski', 'pt-br' : 'Português (Brasil)', 'pt' : 'Português (Portugal)', 'ro' : 'Română', 'fi' : 'Suomi', 'sv' : 'Svenska', 'vi' : 'Tiếng Việt', 'tr' : 'Türkçe',
				'el' : 'Ελληνικά', 'ru' : 'Русский', 'sr' : 'Српски', 'uk' : 'Українська', 'he' : 'עברית',
				'ar' : 'العربية', 'th' : 'ไทย', 'ko' : '한국어', 'ja' : '日本語', 'zh' : '中文（中国）',  'zh-tw' : '中文（台灣）'};

		var geBasePath = 'js';
		var mxBasePath = BASE_PATH+'src';
		var mxLanguages = [];
		
		for (var lang in mxLanguageMap)
		{
			if (lang != 'en')
			{
				mxLanguages.push(lang);
			}
		}

		var uiTheme = (function() 
		{
			var ui = urlParams['ui'];
			
			if (ui == null && typeof(JSON) != 'undefined')
			{
				if (isLocalStorage) 
				{
					try
					{
						var value = localStorage.getItem('.drawio-config');
						
						if (value != null)
						{
							ui = JSON.parse(value).ui || null;
						}
					}
					catch (e)
					{
						isLocalStorage = false;
					}
				}
			}
			
			return ui;
		})();
		
		var ex = urlParams['export'];
		
		if (ex != null)
		{
			EXPORT_URL = ex;
		}
		
		if (urlParams['offline'] == '1' || urlParams['demo'] == '1' || urlParams['stealth'] == '1' || urlParams['local'] == '1')
		{
			urlParams['analytics'] = '0';
			urlParams['picker'] = '0';
			urlParams['gapi'] = '0';
			urlParams['db'] = '0';
			urlParams['od'] = '0';
		}
		
		if (urlParams['offline'] == '1' || urlParams['local'] == '1')
		{
			urlParams['math'] = '0';
		}
		
		var modelViewHYN = "${modelViewHYN}";
		if(modelViewHYN == "Y"){ 
			mxscript(BASE_PATH+'js/modelView_H.js');
		}else{ 
			//mxscript(BASE_PATH+'js/app.min_v3.4.js');
			mxscript(BASE_PATH+'js/diagramEditor.js');		
		}

		if ((window.location.hash != null && ((window.location.hash.length == 0 && urlParams['splash'] != '0') ||
			window.location.hash.substring(0, 2) == '#G')) && (urlParams['url'] == null || window.location.hash.length > 0) &&
			(((urlParams['embed'] != '1' && urlParams['client'] != '1' && urlParams['gapi'] != '0') ||
			((urlParams['embed'] == '1' || urlParams['client'] == '1') && urlParams['gapi'] == '1')) &&
			isSvgBrowser && isLocalStorage && (document.documentMode == null || document.documentMode >= 10)))
		{
			mxscript('https://apis.google.com/js/api.js');
		}
		
		if ((window.location.hash != null && ((window.location.hash.length == 0 && (urlParams['splash'] != '0' && urlParams['state'] == null)) ||
			window.location.hash.substring(0, 2) == '#W') && (urlParams['url'] == null || window.location.hash.length > 0)) &&
			((window.location.hostname == 'www.draw.io' || window.location.hostname == 'test.draw.io' ||
			window.location.hostname == 'drive.draw.io' || window.location.hostname == 'legacy.draw.io') &&
			(((urlParams['embed'] != '1' && urlParams['client'] != '1' && urlParams['od'] != '0') ||
			((urlParams['embed'] == '1' || urlParams['client'] == '1') && urlParams['od'] == '1')) &&
			!navigator.userAgent.match(/(iPad|iPhone|iPod)/g) )))
		{
			mxscript('https://js.live.net/v5.0/wl.js');
		}

		if (typeof(JSON) == 'undefined')
		{
			mxscript('js/json/json2.min.js');
		}
		
		window.onerror = function()
		{
			var status = document.getElementById('geStatus');
			
			if (status != null)
			{
				status.innerHTML = 'Page could not be loaded. Please try refreshing.';
			}
		};
	</script>
</head>
<body class="geEditor">
<div id="geInfo">
	<div class="geBlock" style="margin-top:20px;padding:0px;text-align:center;">
		<h3 id="geStatus">Loading... Please Wait</h3>		
	</div>
</div>
<script type="text/javascript">

if (urlParams['analytics'] != '0' && urlParams['dev'] != '1' && urlParams['chrome'] != '0')
{
	(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

		ga('create', 'UA-78007-10', 'auto');
		ga('send', 'pageview');
}

var ui,graph;
function fnGoFitPage(d){
	var a=d.pageFormat,b=d.pageScale,a=Math.floor(100*Math.min((d.container.clientWidth-10)/a.width/b,(d.container.clientHeight-10)/a.height/b))/100;d.zoomTo(a);mxUtils.hasScrollbars(d.container)&&(a=d.getPagePadding(),d.container.scrollTop=a.y*d.view.scale,d.container.scrollLeft=
	Math.min(a.x*d.view.scale,(d.container.scrollWidth-d.container.clientWidth)/2))
}
function perView75(graph) {
	// 페이지 관련 설정 제거
	graph.pageVisible = false;
	graph.pageScale = 1;
	
	// 줌 비율 설정
	graph.view.setScale(0.75);
	
	// 스크롤 중앙 정렬
	var pad = graph.getPagePadding();
	var scale = graph.view.scale;
	
	graph.container.scrollTop = pad.y * scale;
	graph.container.scrollLeft = Math.min(
	  pad.x * scale,
	  (graph.container.scrollWidth - graph.container.clientWidth) / 2
	);
	
	// 디버깅 로그
	// console.log("줌 비율:", scale, " / pageScale:", graph.pageScale);
}
(function()
{
	var lastErrorMessage = null;
	
	window.onerror = function(message, url, linenumber, colno, err)
	{
		try
		{
			if (message != null && message.indexOf('DocumentClosedError') < 0)
			{
				lastErrorMessage = message;
				var img = new Image();
				var url = (message.indexOf('NetworkError') >= 0 || message.indexOf('SecurityError') >= 0) ?
					'images/3x3.png' : 'images/2x2.png';
	    		img.src = url + '?msg=' + encodeURIComponent(message) + '&url=' + encodeURIComponent(window.location.href) +
	    			'&lnum=' + encodeURIComponent(linenumber) + '&v=' + encodeURIComponent(EditorUi.VERSION) +
	    			((colno != null) ? '&colno=' + encodeURIComponent(colno) : '') +
	    			((err != null && err.stack != null) ? '&stack=' + encodeURIComponent(err.stack) : '');
			}
		}
		catch (err)
		{
			
		}
	};

	if (urlParams['chrome'] != '0')
	{
		mxscript(BASE_PATH+'js/jscolor/jscolor.js');
	}
	
	if (urlParams['picker'] != '0' && !mxClient.IS_QUIRKS && document.documentMode != 8)
	{
		mxscript(document.location.protocol + '//www.google.com/jsapi?autoload=%7B%22modules%22%3A%5B%7B%22name%22%3A%22picker%22%2C%22version%22%3A%221%22%2C%22language%22%3A%22' + mxClient.language + '%22%7D%5D%7D');
	}
	
	App.prototype.formatEnabled = urlParams['format'] != '0';
	App.prototype.formatWidth = mxSettings.getFormatWidth();
	
	if (typeof gapi === 'undefined' && (((urlParams['embed'] != '1' && urlParams['gapi'] != '0') ||
		(urlParams['embed'] == '1' && urlParams['gapi'] == '1')) && isSvgBrowser &&
		isLocalStorage && (document.documentMode == null || document.documentMode >= 10)))
	{
		mxscript('https://apis.google.com/js/api.js?onload=DrawGapiClientCallback');
	}
	
	if (urlParams['offline'] != '1')
	{
		if (urlParams['plugins'] != '0')
		{
			var plugins = mxSettings.getPlugins();
			var temp = urlParams['p'];
			
			if ((temp != null) || (plugins != null && plugins.length > 0))
			{
				window.DrawPlugins = [];
				
				window.Draw = new Object();
				window.Draw.loadPlugin = function(callback)
				{
					window.DrawPlugins.push(callback);
				};
			}
			
			if (temp != null)
			{
				var t = temp.split(';');
				
				for (var i = 0; i < t.length; i++)
				{
					var url = PluginsDialog.plugins[t[i]];
					
					if (url != null)
					{
						mxscript(url);
					}
					else if (window.console != null)
					{
						console.log('Unknown plugin:', t[i]);
					}
				}
			}
			
			if (plugins != null && plugins.length > 0 && urlParams['plugins'] != '0')
			{
				var warning = 'The page has requested to load the following plugin(s):\n \n {1}\n \n Would you like to load these plugin(s) now?\n \n NOTE : Only allow plugins to run if you fully understand the security implications of doing so.\n';
				
				if (plugins.length == 1 && (plugins[0].charAt(0) == '/' ||
					plugins[0].indexOf(window.location.protocol + '//' + window.location.host) == 0))
				{
					mxscript(plugins[0]);
				}
				else if (mxUtils.confirm(mxResources.replacePlaceholders(warning, [plugins.join('\n')]).replace(/\\n/g, '\n')))
				{
					for (var i = 0; i < plugins.length; i++)
					{
						try
						{
							mxscript(plugins[i]);
						}
						catch (e)
						{
							
						}
					}
				}
			}
		}
	}
	
	mxResources.loadDefaultBundle = false;
	var bundle = mxResources.getDefaultBundle(RESOURCE_BASE, mxLanguage) ||
		mxResources.getSpecialBundle(RESOURCE_BASE, mxLanguage);
	
	mxUtils.getAll([bundle, STYLE_PATH + '/default.xml', STYLE_PATH + '/default-old.xml'], function(xhr)
	{
		mxResources.parse(xhr[0].getText());
		
		var themes = {'default-style': xhr[2].getDocumentElement()};
		themes[Graph.prototype.defaultThemeName] = xhr[1].getDocumentElement();

		ui = new App(new Editor(urlParams['chrome'] == '0', themes),'<%=modelID%>','<%=ItemID%>');
		
		ui.editor.filename = modelName;
		
		graph=ui.editor.graph;
		graph.setGridEnabled(0);	
		graph.setConnectable(0);
		graph.connectionHandler.setCreateTarget(0);

		if(modelExsist !="null"){ui.displayRightbar(DISPLY_RIGHT_BAR);}
		
		var orgdoc = mxUtils.parseXml('<%=diagramForXml%>');
		ui.editor.setGraphXml(orgdoc.documentElement);
		
		if (window.DrawPlugins != null)
		{
			for (var i = 0; i < window.DrawPlugins.length; i++)
			{
				window.DrawPlugins[i](ui);
			}
			
			window.Draw.loadPlugin = function(callback)
			{
				callback(ui);
			};
		}
		var zoomOption = "${zoomOption}";
		if((focusedItemID == null || focusedItemID == "" || focusedItemID == undefined) && (zoomOption != "" || zoomOption != null)){
			if(zoomOption == "FTP"){fnGoFitPage(graph);}else if(zoomOption == "FTW"){ ui.fitWindow(graph);}else if(zoomOption == "PV75"){ perView75(graph);}
		}

		ui.addListener('formatWidthChanged', function()
		{
			mxSettings.setFormatWidth(ui.formatWidth);
			mxSettings.save();
		});
		
		if (typeof WL === 'undefined' && window.DrawOneDriveClientCallback != null &&
			((window.location.hostname == 'www.draw.io' || window.location.hostname == 'test.draw.io' ||
			window.location.hostname == 'drive.draw.io' || window.location.hostname == 'legacy.draw.io') &&
			(((urlParams['embed'] != '1' && urlParams['od'] != '0') || (urlParams['embed'] == '1' &&
			urlParams['od'] == '1')) && !navigator.userAgent.match(/(iPad|iPhone|iPod)/g) 
			 )))
		{
			mxscript('https://js.live.net/v5.0/wl.js', window.DrawOneDriveClientCallback);
		}
		
		if (urlParams['chrome'] != '0' && (urlParams['test'] == '1' || urlParams['dev'] == '1'))
		{
			mxLog.show();
			mxLog.debug('Started in ' + (new Date().getTime() - t0.getTime()) + 'ms');
			mxLog.debug('Export:', EXPORT_URL);
			mxLog.debug('Development mode:', (urlParams['dev'] == '1') ? 'active' : 'inactive');
			mxLog.debug('Test mode:', (urlParams['test'] == '1') ? 'active' : 'inactive');
		}
	}, function()
	{
		document.getElementById('geStatus').innerHTML = 'Error loading page. <a href="javascript:void(0);" onclick="location.reload();">Please try refreshing.</a>';
	});
})();
</script>

<script type="text/javascript">
function doPDetail(itemID){
	ui.setLinkVal(itemID);	
}

function goModelListGrid(){
	if(procInstNo == ''){
		parent.setActFrame('getModelListGrid',3,'','&category=process&filter=model');
	}
}

function fnProcessUpdate(){	
	if(clickNo>3){clickNo=1;}else{clickNo = clickNo +1;}
	if(warningDisplay == "N") warningDisplay = "Y"; else warningDisplay = "N";

	var xml = '<%=updateForXml%>';
	updateProcess(xml);
	
}
function fnOpenSymbols(){
	var url = "goViewSymbolPop.do";
	var w = "830";
	var h = "680";
	window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
}
function doCallMessage(avg){
	if(avg=="dellink"){ alert("${WM00069}");
	}else if(avg=="auth"){ alert("${WM00120}"); }
}	

function fnViewModelInfo(menuUrl){
	if('${pop}' == 'pop'){
		if(menuUrl == "")menuUrl = "modelInfoMain";
		parent.fnViewModelInfo(menuUrl);
	}else{		
		parent.setActFrame('modelInfoMain',3,'','&modelID='+model+'&VarFilter='+varFilter+'&modelViewHYN=${modelViewHYN}');
	}
}

function fnTreeLoad(TLink){
	parent.fnTLink(TLink, true);
}

function updateProcess(xml)
{
	if (xml != null &&	xml.length > 0)
	{
		var doc = mxUtils.parseXml(xml);
		if (doc != null && doc.documentElement != null)
		{
			var model = graph.getModel();
			var nodes = doc.documentElement.getElementsByTagName('update');
			if (nodes != null && nodes.length > 0)
			{			
				model.beginUpdate();
				try
				{
					for (var i = 0; i < nodes.length; i++)
					{
						var id = nodes[i].getAttribute('id');
						var LovCodeLV37 = nodes[i].getAttribute('LovCodeLV37');
						var type = nodes[i].getAttribute('type');
						var AttrTypeCodeAT37 = nodes[i].getAttribute('AttrTypeCodeAT37');
						var cell = model.getCell(id);
						var PEIStatus = nodes[i].getAttribute('PEIStatus');
						console.log("PEIStats :"+PEIStatus+" : mxClient.IS_MAC :"+mxClient.IS_MAC);
						
						
						// graph.getView().getState(cell).getStyle().replace(mxConstants.STYLE_IMAGE, new ImageIcon( GraphViewer.class.getResource("/com/mxgraph/examples/swing/images/cube_green.png")));
						if (cell != null)
						{
							graph.removeCellOverlays(cell);		
							if(warningDisplay == "Y"){
								/* if(PEIStatus != ""){
									var state="";
									graph.warningImageYllD=new mxImage(DISPLAY_IMAGE_PATH+"/"+PEIStatus+(mxClient.IS_MAC?".png":".gif"),18,18);
									graph.addCellOverlay(cell, createOverlay(graph.warningImageYllD, 'State: '+state));

								}else{ */
									graph.setCellStyles(mxConstants.STYLE_GRADIENTCOLOR, '', [cell]);
									graph.setCellStyles(mxConstants.STYLE_FILLCOLOR, '#E6E6E6', [cell]);
									graph.setCellStyles(mxConstants.STYLE_FONTCOLOR, '#808080', [cell]);
									graph.setCellStyles(mxConstants.STYLE_FONTCOLOR, '#808080', [cell]);
									graph.setCellStyles(mxConstants.STYLE_STROKECOLOR, '#808080', [cell]);
								//}
							}else{
								if(PEIStatus == ""){
									graph.setCellStyles(mxConstants.STYLE_GRADIENTCOLOR, '', [cell]);
									graph.setCellStyles(mxConstants.STYLE_FILLCOLOR, '#ffffff', [cell]);
									graph.setCellStyles(mxConstants.STYLE_FONTCOLOR, '#ffffff', [cell]);
									graph.setCellStyles(mxConstants.STYLE_STROKECOLOR, '#ffffff', [cell]);
								}
							}
							
							/*
							if(clickNo==2){
								graph.setCellStyles(mxConstants.STYLE_GRADIENTCOLOR, '', [cell]);
								graph.setCellStyles(mxConstants.STYLE_FILLCOLOR, 'blue', [cell]);
								graph.setCellStyles(mxConstants.STYLE_FONTCOLOR, '#000000', [cell]);
							}						
							else if(clickNo==3){
								if(AttrTypeCodeAT37 == 'LV37001'){
									graph.setCellStyles(mxConstants.STYLE_FILLCOLOR, '#3399FF', [cell]);
								}else if(AttrTypeCodeAT37 == 'LV37002'){
									graph.setCellStyles(mxConstants.STYLE_FILLCOLOR, 'LightBlue', [cell]);
								}else{  
									graph.setCellStyles(mxConstants.STYLE_FILLCOLOR, '#FFEFD5', [cell]); 
									graph.setCellStyles(mxConstants.STYLE_FONTCOLOR, '#000000', [cell]);
								}
							}							
							else if(clickNo==4){
								var state="";
								if (type == 'LV26003'){graph.addCellOverlay(cell, createOverlay(graph.warningImageGrn, 'State: '+state));
								} else if (type == 'LV26002'){graph.addCellOverlay(cell, createOverlay(graph.warningImageYll, 'State: '+state));
								} else if (type == 'LV26001'){graph.addCellOverlay(cell, createOverlay(graph.warningImageRed, 'State: '+state));
								} 
							}
							
							if (state == 'Running')
							{
								graph.setCellStyles(mxConstants.STYLE_FILLCOLOR, '#f8cecc', [cell]);
							}
							else if (state == 'Waiting')
							{
								graph.setCellStyles(mxConstants.STYLE_FILLCOLOR, '#fff2cc', [cell]);
							}
							else if (state == 'Completed')
							{
								graph.setCellStyles(mxConstants.STYLE_FILLCOLOR, '#d4e1f5', [cell]);
							}							
							if (state != 'Init')
							{
								graph.addCellOverlay(cell, createOverlay(graph.warningImage, 'State: '+state));
							}
							*/
							
						}
					} 
				}
				finally
				{
					model.endUpdate();
				}
			}
		}
	}
};

function createOverlay(image, tooltip)
{
	var overlay = new mxCellOverlay(image, tooltip);
	overlay.addListener(mxEvent.CLICK, function(sender, evt)
	{
	});
	
	return overlay;
};

function getState()
{
	var state = 'Init';
	var rnd = Math.random() * 4;
	
	if (rnd > 3)
	{
		state = 'Completed';
	}
	else if (rnd > 2)
	{
		state = 'Running';
	}
	else if (rnd > 1)
	{
		state = 'Waiting';
	}
	
	return state;
};

function fnQuickCheckOut(){
	var projectNameList = "${projectNameList}";
	if(parseInt(projectNameList)> 0){
		var url = "cngCheckOutPop.do?";
		var data = "s_itemID=${ItemID}";
		var option = "width=500px, height=150px, left=200, top=100,scrollbar=yes,resizble=0";
	 	window.open(url+data, 'CheckOut', option);
	}else{
		if(confirm("${CM00057}")){
			var url = "registerCSR.do?quickCheckOut=Y&itemID=${ItemID}";
			window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizble=0');
		}
	}
}

function fnRegNewCSR(){
	if(confirm("${CM00058}")){
		var url = "registerCSR.do?quickCheckOut=Y&itemID=${ItemID}";
		window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizble=0');
	}
}

function fnOpenTreeItem(pID){// TreeReload
	parent.fnOpenParentItemPop(String(pID));	
}


</script>
</body>
</html>