<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map" %>
<%@page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00069" var="WM00069"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00160" var="WM00160"/>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	/* String modelID  = (String)request.getAttribute("ModelID");
	String ItemID = (String)request.getAttribute("ItemID");
	String modelXML = (String)request.getAttribute("modelXML");	
	String modelName = (String)request.getAttribute("modelName");	
	String diagramForXml = (String)request.getAttribute("diagramForXml"); */

	List symTypeList = (List)request.getAttribute("symTypeList");
%>
<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=5,IE=9" ><![endif]-->
<!DOCTYPE html>
<html>
<head>
    <title>SF OLM Diagrams | draw.io</title>
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

	<!-- Workaround for binary XHR in IE 9/10, see App.loadUrl -->
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

		var t0 = new Date();
		var DEF_FONT = "${sessionScope.loginInfo.sessionDefFont}";
		var DEF_FONTSIZE = "${sessionScope.loginInfo.sessionDefFontSize}";
		var DEF_FONTSTYLE = "${sessionScope.loginInfo.sessionDefFontStyle}";
		var DEF_FONTCOLOR = "${sessionScope.loginInfo.sessionDefFontColor}";
		var DISPLY_RIGHT_BAR="BLOCK";		
		var SCRN_TYPE = '';
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

		var itemID = "${ItemID}";
		var model = "${ModelID}";
		var modelName = "${modelName}";
		var itemBlocked = "${itemBlocked}";
		var itemAthId = "${itemAthId}";
		var userId = "${sessionScope.loginInfo.sessionUserId}";
		var modelBlocked = "${ModelBlocked}";
		var mlvl = "${sessionScope.loginInfo.sessionMlvl}";
		var authLev = "${sessionScope.loginInfo.sessionAuthLev}";
		var modelIsPublic = "${ModelIsPublic}";
		var auth="N";
		var viewScale = "${viewScale}";
		if(modelIsPublic == 1 ){
			auth = "Y"; 	
		}else{
			if( itemBlocked != "2" && itemAthId == userId && modelBlocked == "1"  || mlvl == "SYS"){
				auth = "Y"; 
			}
		}
		var arCode = "${option}";
		var linkOption = "${linkOption}";
		var ItemTypeCode = "${ItemTypeCode}";
		var clickPositionY;
		var clickPositionX;
		var isModel = "${isModel}";
		
		var symbolNm = new Array(); 
		var symbolTitle = new Array();
		var width = new Array();
		var height = new Array();
		var generalPalette = new Array();
		var positionX = "${positionX}";
		var positionY = "${positionY}";
		var modelStatus = "${modelStatus}";
		
		var changeSetID = "${changeSetID}";
		var modelTypeName = "${modelTypeName}"; 
		
		var diagramID = "${diagramID}";
		var urlParams = (function(url)
		{
			var result = new Object();
			url=url+"&demo=1&analytics=0&picker=0&gapi=0&db=0&od=0&lang=ko";
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
			var lang = "${sessionScope.loginInfo.sessionCurrLangCode}";
			
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
		
		var mxLanguageMap = {'ko' : '한국어', 'i18n': '', 'id' : 'Bahasa Indonesia', 'ms' : 'Bahasa Melayu', 'bs' : 'Bosanski', 'ca' : 'Català', 'cs' : 'Čeština', 'da' : 'Dansk', 'de' : 'Deutsch', 'et' : 'Eesti', 'en' : 'English', 'es' : 'Español', 
				'fil' : 'Filipino', 'fr' : 'Français', 'it' : 'Italiano', 'hu' : 'Magyar', 'nl' : 'Nederlands', 'no' : 'Norsk', 
				'pl' : 'Polski', 'pt-br' : 'Português (Brasil)', 'pt' : 'Português (Portugal)', 'ro' : 'Română', 'fi' : 'Suomi', 'sv' : 'Svenska', 'vi' : 'Tiếng Việt', 'tr' : 'Türkçe',
				'el' : 'Ελληνικά', 'ru' : 'Русский', 'sr' : 'Српски', 'uk' : 'Українська', 'he' : 'עברית',
				'ar' : 'العربية', 'th' : 'ไทย', 'ja' : '日本語', 'zh' : '中文（中国）',  'zh-tw' : '中文（台灣）'};

		var geBasePath = 'js';
		var mxBasePath = BASE_PATH+'src';
		var mxLanguages = ['ar', 'bs', 'cs', 'da', 'de', 'el', 'es', 'es-ar', 'fr', 'hu', 'id', 'it', 'ja', 'ko', 'nl', 'no', 'pl', 'pt-br', 'pt', 'ro', 'ru', 'sr', 'sv', 'th', 'tr', 'uk', 'zh'];
		
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

		if (urlParams['dev'] == '1')
		{
			geBasePath = mxDevUrl + '/javascript/examples/grapheditor/www/js';
			mxBasePath = mxDevUrl + '/javascript/src';
			mxscript(mxBasePath + '/js/mxClient.js');
			
			mxscript(drawDevUrl + 'js/diagramly/Devel.js');
		} else {
			mxscript(BASE_PATH+'js/diagram_max.js'); 
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
			!navigator.userAgent.match(/(iPad|iPhone|iPod)/g) &&
			(navigator.userAgent.indexOf('MSIE') < 0 || document.documentMode >= 10))))
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
		function doReturnDiagram(){
			alert("${WM00067}"); location.reload();
		}	
		function doCallMessage(avg){
			if(avg=="dellink"){ alert("${WM00069}");
			}else if(avg=="auth"){ alert("${WM00040}"); 
			}else if(avg=="addObject"){ alert("${WM00160}"); }
		}		
		
		function fnSetSymbolList(){		
		<%
			for(int i=0; i<symTypeList.size(); i++){
				Map symTypeMap = (Map)symTypeList.get(i);
		%>
			symbolNm[<%=i%>] = "<%=symTypeMap.get("SymbolNm")%>";
			symbolTitle[<%=i%>] = "<%=symTypeMap.get("SymbolTitle")%>";
			generalPalette[<%=i%>] = "<%=symTypeMap.get("generalPalette")%>";
			width[<%=i%>] = "<%=symTypeMap.get("DefWidth")%>";
			height[<%=i%>] = "<%=symTypeMap.get("DefHeight")%>";
		<%
			}
		%>
		}
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

var ui;

(function()
{
	var lastErrorMessage = null;
	
	window.onerror = function(message, url, linenumber, colno, err)
	{
		try
		{
			if (message == lastErrorMessage || (message != null && url != null &&
				((message.indexOf('Script error') != -1) || (message.indexOf('extension') != -1))))
			{
			}
			else if (message != null && message.indexOf('DocumentClosedError') < 0)
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

	if (uiTheme == 'atlas')
	{
		mxClient.link('stylesheet', 'styles/atlas.css');
	}

	if (urlParams['offline'] == '1')
	{
		mxscript('js/shapes.min.js');
		
		var frame = document.createElement('iframe');
		frame.setAttribute('width', '0');
		frame.setAttribute('height', '0');
		frame.setAttribute('src', 'offline.html');
		document.body.appendChild(frame);
	
		mxStencilRegistry.stencilSet = {};
	
		mxStencilRegistry.getStencil = function(name)
		{
			return mxStencilRegistry.stencils[name];
		};

		mxStencilRegistry.loadStencilSet = function(stencilFile, postStencilLoad, force)
		{
			var name = stencilFile.substring(stencilFile.indexOf('/') + 1);
			name = 'mxgraph.' + name.substring(0, name.length - 4).replace(/\//g, '.');
			var node = mxStencilRegistry.stencilSet[name];
			
			if (node != null)
			{
				mxStencilRegistry.parseStencilSet(node, postStencilLoad, false);
			}
		};
		
		var req2 = mxUtils.load('stencils.xml');
		var root = req2.getXml().documentElement;
		var node = root.firstChild;
		
		while (node != null)
		{
			if (node.nodeName == 'shapes' && node.getAttribute('name') != null)
			{
				mxStencilRegistry.stencilSet[node.getAttribute('name').toLowerCase()] = node;
				mxStencilRegistry.parseStencilSet(node);
			}
			
			node = node.nextSibling;
		}
	}
	
	if (urlParams['picker'] != '0' && !mxClient.IS_QUIRKS && document.documentMode != 8)
	{
		mxscript(document.location.protocol + '//www.google.com/jsapi?autoload=%7B%22modules%22%3A%5B%7B%22name%22%3A%22picker%22%2C%22version%22%3A%221%22%2C%22language%22%3A%22' + mxClient.language + '%22%7D%5D%7D');
	}
	
	if (urlParams['math'] != '0')
	{
		var mathJaxQueue = [];
		
		window.MathJax =
		{
			skipStartupTypeset: true,
			showMathMenu: false,
			messageStyle: 'none',
			AuthorInit: function ()
			{
				MathJax.Hub.Config({
					tex2jax: {
						ignoreClass: 'mxCellEditor'
				  	},
				  	asciimath2jax: {
						ignoreClass: 'mxCellEditor'
				  	}
				});
				MathJax.Hub.Register.StartupHook('Begin', function()
				{
					for (var i = 0; i < mathJaxQueue.length; i++)
					{
						MathJax.Hub.Queue(['Typeset', MathJax.Hub, mathJaxQueue[i]]);
					}
				});
		    }
		};
		
		window.MathJaxRender = function(container)
		{
			if (typeof(MathJax) !== 'undefined' && typeof(MathJax.Hub) !== 'undefined')
			{
				MathJax.Hub.Queue(['Typeset', MathJax.Hub, container]);
			}
			else
			{
				mathJaxQueue.push(container);
			}
		};

		mxscript('js/mathjax/MathJax.js?config=TeX-MML-AM_HTMLorMML');
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
		fnSetSymbolList();
		mxResources.parse(xhr[0].getText());
		
		var themes = {'default-style': xhr[2].getDocumentElement()};
		themes[Graph.prototype.defaultThemeName] = xhr[1].getDocumentElement();
	
		ui = new App(new Editor(urlParams['chrome'] == '0', themes),'${ModelID}','${ItemID}');
		
		ui.editor.filename="${modelName}";
		
		graph=ui.editor.graph;
		graph.setHtmlLabels(true);
		
		var orgdoc = mxUtils.parseXml('${diagramForXml}');

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

		ui.addListener('formatWidthChanged', function()
		{
			mxSettings.setFormatWidth(ui.formatWidth);
			mxSettings.save();
		});

		if (typeof WL === 'undefined' && window.DrawOneDriveClientCallback != null &&
			((window.location.hostname == 'www.draw.io' || window.location.hostname == 'test.draw.io' ||
			window.location.hostname == 'drive.draw.io' || window.location.hostname == 'legacy.draw.io') &&
			(((urlParams['embed'] != '1' && urlParams['od'] != '0') || (urlParams['embed'] == '1' &&
			urlParams['od'] == '1')) && !navigator.userAgent.match(/(iPad|iPhone|iPod)/g) &&
			(navigator.userAgent.indexOf('MSIE') < 0 || document.documentMode >= 10))))
		{
			mxscript('https://js.live.net/v5.0/wl.js', window.DrawOneDriveClientCallback);
		}
		
	}, function()
	{
		document.getElementById('geStatus').innerHTML = 'Error loading page. <a href="javascript:void(0);" onclick="location.reload();">Please try refreshing.</a>';
	});
})();
</script>
<script type="text/javascript">
function doPDetail(itemID,itemName){ 
	ui.setLinkVal(itemID,itemName);	
}

var schText = "";
function fnEditLinkItemID(label, symTypeCode){	
	schText = label.replace(/\n/g, ""); 
	var url = "editLinkItemId.do";
	var target = "blankFrame";
	var data = "&symTypeCode="+symTypeCode+"&option=${option}";
	ajaxPage(url, data, target);
}

function itemTypeCodeTreePop(recItemTypeCode,arcFilter) { 
	var url = "searchItemIdTreePop.do";
	var data = "ItemTypeCode="+recItemTypeCode+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${ItemID}"+arcFilter+"&schText="+schText;

	// fnOpenLayerPopup(url,data,doCallBack,617,436);
	var w = 676;
	var h = 436;
	window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
}

function doCallBack(){}

function fnSetLinkItem(itemId,itemText,itempath){
	doPDetail(itemId, itemText);	
}

function openE2eTreeListPop(itemID, modelID, clickPositionX, clickPositionY, itemTypeCode){
	var url = "e2eTreeListPop.do";
	var data = "ItemID="+itemID+"&modelID="+modelID+"&scrnType=addObj&ItemTypeCode="+itemTypeCode+"&positionX="+clickPositionX+"&positionY="+clickPositionY;

	fnOpenLayerPopup(url,data,"",617,436);
}

function fnCallbackSave(){
	$(".popup_div").hide();
	$("#mask").hide();
	location.reload();
}

var autoSave = "${autoSave}";
setInterval(function(){if(autoSave == "Y")fnAutoSave()},180000);

function fnAutoSave(){
	ui.autoSave();
}
</script>
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none;overflow:hidden;" frameborder="0"></iframe>
</body>
</html>