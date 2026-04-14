<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>



<c:url value="/" var="root"/>
<script type="text/javascript">
var g_AC = "text-align:center;";var g_AL = "text-align:left;";var g_AR = "text-align:right;";
var dhx_skin_skyblue = "dhx_skyblue";var dhx_skin_web = "dhx_web"; var dhx_skin_brd="dhx_brd";var df_dhx_skin = dhx_skin_web;
var layout_1C = "1C";var layout_2E = "2E";var layout_2U = "2U";var lMinWidth = 230, rMinWidth=750;
var df_pageSize = 10;
var chkReadOnly = false; var df_isDebug=false;
<%-- var sessionTime = <%=session.getMaxInactiveInterval() %>;
var timer;
var reset; --%>
</script>

<script type="text/javascript" src="${root}cmm/js/xbolt/icons.js"></script>
<c:if test="${screenType ne 'model'}"><%@ include file="uiInc.jsp" %></c:if>
<c:if test="${screenType eq 'model'}"><%@ include file="uiInc_model.jsp" %></c:if>
<%@ include file="sessionCheck.jsp" %>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00018" var="WM00018" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00066" var="WM00066" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00033" var="CM00033" />

<script type="text/javascript">
//if (_isIE) _isIE = 8;//dhtmlx grid
var authLev = '${sessionScope.loginInfo.sessionAuthLev}';
var languageCode = '${sessionScope.loginInfo.sessionCurrLangCode}';
var sessionDefFont = "${sessionScope.loginInfo.sessionDefFont}";
//if(document.documentMode<=8 && "${sessionScope.loginInfo.sessionCurrLangType}"=="2052"){$(".SubinfoTabs ul li span").attr("style","padding: 7px 12px 5px 6px;");}

function showCallStack(){var f=showCallStack,result="Call stack:\n";while((f=f.caller)!==null){var sFunctionName = f.toString().match(/^function (\w+)\(/);sFunctionName = (sFunctionName) ? sFunctionName[1] : 'anonymous function';result += sFunctionName;result += getArguments(f.toString(), f.arguments);result += "\n";}return result;}
function fnGetRootUrl() {return "${root}";}
function fnAnySelect(id, data, menuId, defaultValue, isAll) {url = "<c:url value='/ajaxCodeSelect.do'/>";data += "&menuId="+menuId;if(isAll==null) {isAll = 'select';}ajaxSelect(url, data, id, defaultValue, isAll);}
function fnSelect(id, code, menuId, defaultValue, isAll, headerKey, debug) {url = "<c:url value='/ajaxCodeSelect.do'/>";data = "ajaxParam1="+code+"&menuId="+menuId+"&headerKey="+headerKey;if(isAll==null) {isAll = 'select';}ajaxSelect(url, data, id, defaultValue, isAll, headerKey, debug);}
function fnSelectJson(e,n,a,t){var r=new Array;return $.ajax({url:"ajaxCodeSelectJson.do",data:"ajaxParam1="+e+"&menuId="+n+"&headerKey="+a,type:"POST",async:!1,dataType:"json",success:function(e){t&&((n=new Object).value="",n.content=t,n=JSON.stringify(n),r.push(JSON.parse(n)));for(idx in e)if(0!=e[idx].length){var n=new Object,a=e[idx].CODE;e[idx].CODE||(a="");var s=e[idx].NAME;e[idx].NAME||(s=""),n.value=a,n.content=s,n=JSON.stringify(n),r.push(JSON.parse(n))}},error:function(e,n,a){console.log("ERR :["+e.status+"]"+a)}}),r}
function fnRadio(id, code, menuId, defaultValue, radioID, isDisabled) {url = "<c:url value='/ajaxCodeRadio.do'/>";data = "ajaxParam1="+code+"&menuId="+menuId;ajaxRadio(url, data, id, defaultValue, radioID, isDisabled);}
function fnGridCombo(grid, colIndex, code, menuId) {url = "<c:url value='/ajaxDhtmlxCombo.do'/>";data = "ajaxParam1="+code+"&menuId="+menuId;ajaxGridCombo(url, data, grid, colIndex, false);fnSetColType(grid, colIndex, "coro");}
function fnSelectNone(id, code, menuId, defaultValue, isAll, headerKey) {var url = "<c:url value='/ajaxCodeSelect.do'/>";var data = "ajaxParam1="+code+"&menuId="+menuId+"&headerKey="+headerKey;ajaxSelect(url, data, id, defaultValue, 'n', headerKey);}
function fnCheckbox(id, code, menuId, name, checkYn, preHtml, debug) {if(name && name!=null&& name!='') {}else {name="chkBox";}var url = "<c:url value='/ajaxCheckbox.do'/>";var data = "name="+name+"&checkYn="+checkYn+"&ajaxParam1="+code+"&menuId="+menuId;ajaxPage(url, data, id, preHtml, debug);}
function fnPage(id, code, menuId, preHtml, debug) {var url = "<c:url value='/ajaxPage.do'/>";var data = "ajaxParam1="+code+"&menuId="+menuId;ajaxPage(url, data, id, preHtml, debug);}
function fnImgPage(id, imgKey, debug) {var url = "<c:url value='/ajaxImgPage.do'/>";var data = "ATTFILE_ID="+imgKey;ajaxPage(url, data, id, '', debug);}
function fnImgUpdatePage(id, imgKey, debug, noImg, noDel) {var url = "<c:url value='/ajaxImgDeleteabledPage.do'/>";var data = "ATTFILE_ID="+imgKey;if( noImg == 'Y' ){data = data +"&NOIMG=Y";}if( noDel == 'Y' ){data = data +"&NODEL=Y";}ajaxPage(url, data, id, '', debug);}
function fnFilePage(id, imgKey, debug) {var url = "<c:url value='/ajaxFilePage.do'/>";var data = "ATTFILE_ID="+imgKey;ajaxPage(url, data, id, '', debug);}
function fnValue(id, code, menuId, preHtml, debug) {var url = "<c:url value='/ajaxPage.do'/>";var data = "ajaxParam1="+code+"&menuId="+menuId;ajaxValue(url, data, id, preHtml, debug);}
function fnFileDelete(ATTFILE_ID, SEQ, debug) {if(confirm("${CM00033}")) {var url = "<c:url value='/fileDelete.do'/>";var data = "ATTFILE_ID="+ATTFILE_ID+"&SEQ="+SEQ;ajaxPage(url, data, "file"+ATTFILE_ID+"_"+SEQ);}}

function fnNewGrid(id, title, skin) {if( skin == undefined || skin == "" ){skin = df_dhx_skin;}grid = new dhtmlXGridObject('gridbox');grid.setImagePath("<c:url value='/cmm/js/dhtmlx/dhtmlxGrid/codebase/imgs/'/>");grid.setDateFormat("%Y-%m-%d");grid.setSkin(skin);grid.enableAlterCss("even", "uneven");grid.enableKeyboardSupport(true);if(title) {var gridUid = grid.entBox.id;var align = new Array();var colSorting = '';var colAlign = '';var colType = '';for (var ti = 0; ti<title.split(",").length; ti++) {align[ti]=g_AC;if(ti > 0) {colSorting += ',';colAlign += ',';colType += ',';}colSorting += 'str';colAlign += 'center';colType += 'ro';}grid.setHeader(title, null, align);grid.setColSorting	(colSorting);grid.setColAlign	(colAlign);grid.setColTypes	(colType);$add("gridHeaders_"+gridUid, title);}return grid;}
function fnNewInitGrid(id, data, skin, isMulti) {if( skin == undefined || skin == "" ){skin = df_dhx_skin;}grid = new dhtmlXGridObject(id);grid.setImagePath("<c:url value='/cmm/js/dhtmlx/dhtmlxGrid/codebase/imgs/'/>");grid.setDateFormat("%Y-%m-%d");grid.setSkin(skin);grid.enableAlterCss("even", "uneven");grid.enableKeyboardSupport(true);if(data!=null) {var gridUid = grid.entBox.id;var align = new Array();var colWidth = '';var colSorting = '';var colAlign = '';var colType = '';var colHidden = '';for (var ti = 0; ti<data.header.split(",").length; ti++) {align[ti]=g_AC;colWidth += ti>0 ? ',80' : '50';colSorting += ti>0 ? ',str' : 'str';colAlign += ti>0 ? ',center' : 'center';colType += ti>0 ? ',ro' : 'ro';colHidden += ti>0 ? ',false' : 'false';}grid.$columnName = (data.cols).split("|");grid.$cells = $cell(data.cols);grid.$header = data.header.split(",");grid.setHeader(data.header, null, align);grid.setInitWidths(fnNvl(data.widths,colWidth));grid.setColAlign(fnNvl(data.aligns,colAlign));grid.setColTypes(fnNvl(data.types,colType));grid.setColSorting(fnNvl(data.sorting,colSorting));
	grid.enableMultiline(isMulti); ;grid.init();$add("gridHeaders_"+gridUid, data.header);$add("gridCols_"+gridUid, data.cols);} return grid;}
//Multirow header
function fnNewInitGridMultirowHeader(id, data, skin) {
	if( skin == undefined || skin == "" ){skin = df_dhx_skin;}
	grid = new dhtmlXGridObject(id);
	grid.setImagePath("<c:url value='/cmm/js/dhtmlx/dhtmlxGrid/codebase/imgs/'/>");
	grid.setDateFormat("%Y-%m-%d");
	grid.setSkin(skin);grid.enableAlterCss("even", "uneven");
	grid.enableKeyboardSupport(true);
	if(data!=null) {
		var gridUid = grid.entBox.id;var align = new Array();var colWidth = '';var colSorting = '';var colAlign = '';var colType = '';var colHidden = '';
		for (var ti = 0; ti<data.header.split(",").length; ti++){align[ti]=g_AC;colWidth += ti>0 ? ',80' : '50';colSorting += ti>0 ? ',str' : 'str';colAlign += ti>0 ? ',center' : 'center';colType += ti>0 ? ',ro' : 'ro';colHidden += ti>0 ? ',false' : 'false';}
		grid.setHeader(data.header, null, align);
		if(data.attachHeader1 != undefined) {grid.attachHeader(data.attachHeader1);}
		if(data.attachHeader2 != undefined) {grid.attachHeader(data.attachHeader2);}
		grid.setInitWidths(fnNvl(data.widths,colWidth));
		grid.setColAlign(fnNvl(data.aligns,colAlign));
		grid.setColTypes(fnNvl(data.types,colType));
		grid.setColSorting(fnNvl(data.sorting,colSorting));
		grid.init();
	}
	return grid;
}
function getArguments(sFunction, a) {var ii = sFunction.indexOf('(');var iii = sFunction.indexOf(')');var aArgs = sFunction.substr(ii+1, iii-ii-1).split(',');var sArgs = '';for(var i=0; i<a.length; i++) {var q = ('string' == typeof a[i]) ? '"' : '';sArgs+=((i>0) ? ', ' : '')+(typeof a[i])+' '+aArgs[i]+':'+q+a[i]+q+'';}return '('+sArgs+')';}
function fnLoadPramValue(key, cols, value, noMsg){var result = "";try{if(key==null || key == ""){fnLog("ERROR fnLoadDhtmlxJson() data: " + data);fnLog("ERROR fnLoadDhtmlxJson() callstack : " + showCallStack());}} catch(e) {}ajaxPramLoad("<c:url value='/jsonPram.do'/>", data, false, noMsg);return result;	}
function fnLoadDhtmlxGridJson(grid, key, cols, value, debug, noMsg, totCntrNm, url, callbackFnc, msg2, maxCntNum, lockColNum){
	var msg = "${WM00018}";	
	if(noMsg=="Y"){fnCheckSearch('E');}
	if(!fnCheckSearch('S')){
		grid.clearAll();
		//if(debug){alert(2+":::"+grid.getAllRowIds("|"));}
		var data = "menuId="+key;data += "&cols=" + cols;data += "&" + value;
		try{if(key==null || key == ""){fnLog("ERROR fnLoadDhtmlxJson() data: " + data);fnLog("ERROR fnLoadDhtmlxJson() callstack : " + showCallStack());}} catch(e) {}
		if(url == undefined || url == null || url=="") url = "<c:url value='/jsonDhtmlxList.do'/>";
		if(noMsg == undefined || noMsg == null || noMsg==""){ noMsg="N";}
		if(debug){alert("data:::"+data);}
	 	ajaxGridLoad(url, data, grid, debug, noMsg, totCntrNm,callbackFnc, msg, msg2, maxCntNum, lockColNum);
	 	var gridUid = grid.entBox.id;
		$add("gridCols_"+gridUid, cols);
	}
}

function fnLoadDhtmlxTreeJson(tree, key, cols, value, select, noMsg, callbackFnc) {var msg = "${WM00018}";var data = "menuId="+key;data += "&cols=" + cols;data += "&SelectMenuId=" + select;data += "&" + value;try{if(key==null || key == ""){fnLog("ERROR fnLoadDhtmlxTreeJson() data: " + data);fnLog("ERROR fnLoadDhtmlxTreeJson() callstack : " + showCallStack());}} catch(e) {}if(callbackFnc == undefined || callbackFnc == null){ callbackFnc="";}ajaxTreeLoad("<c:url value='/jsonDhtmlxTreeList.do'/>", data, tree, false, noMsg, msg, callbackFnc);}

function fnNewInitChart(config, container) {
	var chart;
	if(config.view == "PIE"){
		chart = new dhtmlXChart({
			view: "pie",
			container: container,
			value: config.value,
			//value:function(obj) {return "<font color='#fff'>" + obj.value + "</font>";},
	        label: config.label,
			color: config.color,
			pieInnerText: config.value,shadow: 0});
	} else if (config.view == "PIE2") {
		//PIE 차트 라벨 ver
		chart = new dhtmlXChart({
			view: "pie",
			container: container,
			value: config.value,
	        label: config.label,
			color: config.color,
			legend: {width: 100,align: "right",valign: "middle",template: config.label},
			pieInnerText: config.value,shadow: 0});
	}
	else if(config.view == "donut"){
		dhtmlxChart = new dhtmlXChart({
			view: "donut",
			container: container,
			value: config.value,
			legend: {width: 75,align: "right",valign: "middle",template: config.label},
			gradient: 1,shadow: false});
	} else if(config.view == "BAR"){
		chart =  new dhtmlXChart({
			view:"bar",
			container : container,
			value:config.value,
			label:config.value,
			radius:0,
			border:true,
			xAxis:{
				template:config.label
				},
			yAxis:{
				start:0,
				end:100,
				step:10,
				template:function(obj){
					return (obj%20?"":obj);}
			}});
	} else if(config.view == "BAR2"){
		chart =  new dhtmlXChart({
			view:"bar",
			container : container,
			value:config.ttl,
			radius:0,
			border:true,
			color:"#36abee",
			width:15,
			xAxis:{
				title:"변경 오더",
				template:config.label
				},
			yAxis:{
				start:0,
				end:1000,
				step:100,
				template:function(obj){
					return (obj%20?"":obj);}
			},
			legend:{
				values:[{text:"Total",color:"#36abee"},{text:"In Change",color:"#58dccd"},{text:"Completed",color:"#a7ee70"}],
				valign:"middle",
				align:"left",
				width:50,
				layout:"x"
			}
		});
		chart.addSeries({
			value:config.mod,
			color:"#58dccd"
		});
		chart.addSeries({
			value:config.cls,
			color:"#a7ee70"
		});
	} else if(config.view == "BAR3"){
		chart =  new dhtmlXChart({
			view:"bar",
			container : container,
			value:config.value,
			//label:config.value,
			radius:0,
			border:true,
			color:"#ffc000",
			width:6,
			xAxis:{
				template:config.label
				},
			yAxis:{
				start:0,
				end:1000,
				step:100,
				template:function(obj){
					return (obj%20?"":obj);} 
				
			}, 
			legend:{
				values:[{text:"Manual",color:"#ffc000"},{text:"System",color:"#0070C0"}],
				valign:"middle",
				align:"left",
				width:10,
				layout:"x"
			}
		});
		chart.addSeries({
			value:config.value2,
			color:"#0070C0"
		});
	}
	return chart;
}
function fnLoadDhtmlxChartJson(chart, container, key, cols, value, debug, noMsg) {var msg = "${WM00018}";var data = "chartId="+key;data += "&cols=" + cols;data += "&"+value;ajaxChartLoad(chart, "<c:url value='/jsonDhtmlxChart.do'/>", data, container, debug, noMsg, msg);}
function fnLoadDhtmlxChartWithGrid(chart, grid, chartCntr, config, debug, noMsg) {chart.clearAll();integrationChartLoad(chart, grid, chartCntr, config, debug, noMsg);}
function fnLoadDhtmlxChartJson2(chart, container, data){var msg = "${WM00018}";ajaxChartLoad(chart, "<c:url value='/statisticsChart.do'/>", data, container,"","",msg);}
function fnLoadDhtmlxChartJson3(chart, container, key, cols, value, debug, noMsg) {var msg = "${WM00018}";var data = "chartId="+key;data += "&cols=" + cols;data += "&"+value;ajaxChartLoad2(chart, "<c:url value='/jsonDhtmlxChart.do'/>", data, container, debug, noMsg, msg);}

function fnDownExcel(grid, title, headers, key, cols, value, coltype, debug) {var form = document.commandMap;if(form==null) {form = $form();}$add("title", title);$add("headers", headers);$add("cols", cols);$add("key", key);$add("coltype", coltype);form.action = "<c:url value='/excelDown.do?'/>"+value;try {form.submit();} catch(e) {}}
function fnLog(cont) {parent.mainMenu.fnLog(cont);}
function generateDatePicker(){$(this).css({"min-width":"90px", "text-align":"left","padding-left":"5px"});$(this).css({"ime-mode":"disabled"});$(this).attr("size", "10");$(this).attr("maxlength", "10");$(this).attr("autocomplete","off");$(this).click(function() {doClickCalendar("Y", this);});var root = fnGetRootUrl();}
// TODO ::: IE8 대응으로 입시 삭제 
function generateDatePicker(){$(this).css({"min-width":"90px", "text-align":"left","padding-left":"5px"});$(this).css({"ime-mode":"disabled"});$(this).attr("size", "10");$(this).attr("maxlength", "10");$(this).attr("autocomplete","off");$(this).click(function() {doClickCalendar("Y", this);});var root = fnGetRootUrl();}
function generateDatePickerNoClck(){$(this).css({"ime-mode":"disabled"});$(this).attr("size", "10");$(this).attr("maxlength", "10"); $(this).blur(function() {closeCalendar();});var root = fnGetRootUrl();var tag = "<img src='${root}cmm/common/images/icon_crd.gif' name=\"Image100\" width=\"16\" height=\"22\" border=\"0\" align=\"absmiddle\" style='cursor:hand' onclick=\"doClickCalendar('N','"+this.id+"');\" onblur=\"closeCalendar();\">";$(tag).appendTo($(this).parent());}
function setPagingHTML( totCnt, pageNo, scale, pageScale, divTag ){if(totCnt==null||totCnt==""){totCnt = "0";}if(pageNo==null||pageNo==""){pageNo = "1";}if(scale==null||scale==""||scale==undefined){scale = "";}if(pageScale==null||pageScale==""||pageScale==undefined){pageScale = "";}if(divTag==null||divTag==""||divTag==undefined){divTag = "paging";}var pgUrl = "<c:url value='/cmm/js/xbolt/paging.jsp'/>";var pgParam = "?totCnt="+totCnt;pgParam += "&page="+pageNo;pgParam += "&scale="+scale;pgParam += "&pageScale="+pageScale;var loader = dhtmlxAjax.postSync(pgUrl+pgParam);if(document.getElementById(divTag)!=null&&document.getElementById(divTag).length>0){document.getElementById(divTag).innerHTML = loader.xmlDoc.responseText;}}
function setSubTab(menuIndex, avg, tabNm, classNm){var realMenuIndex = menuIndex.split(' '); if(tabNm == null || tabNm == "undefined"){tabNm = "pli";}if(classNm == null || classNm == "undefined"){classNm = "on";}for(var i = 0 ; i < realMenuIndex.length; i++){if(realMenuIndex[i] == avg){$('#'+tabNm+realMenuIndex[i]).addClass(classNm);}else{$('#'+tabNm+realMenuIndex[i]).removeClass(classNm);}}}
function openMaskLayer(){var $mask = $('#mask');if($mask.length == 0){$('body').append("<div id='mask' class='mask' style='display:none; filter:alpha(opacity=20); opacity:0.2; -moz-opacity:0.2;' ></div>");$mask = $('#mask');}var maskHeight = $(document).height();var maskWidth = $(window).width();$mask.css({'width':maskWidth,'height':maskHeight ,'position':'absolute','left':0,'top':0,'z-index':'9000','display':'none' ,'background-color':'black'});$mask.show();}
function closeMaskLayer(){if($("#mask").length >0){$("#mask").hide();}}

function fnSetMenuTreeData(data){if(data == 'undefined' || data == null){data = "";}var result = new Object();result.title = "${title}";result.key = "menu_SQL.menuTreeList";result.header = "TREE_ID, PRE_TREE_ID,TREE_NM";result.cols = "TREE_ID|PRE_TREE_ID|TREE_NM";result.data = data ;return result;}
function fnSetScriptMasterDiv(){var divScpt = new Object();divScpt.treeTop="<div id='schTreeArea'>";
divScpt.treeTop=divScpt.treeTop+"<input type='text' class='tree_search' id='schTreeText' style='width:80px;ime-mode:active;' placeholder='Search' value='' text=''/>&nbsp;<a onclick='searchTreeText(\"1\")'><img src='${root}cmm/common/images/btn_icon_search.png'></a> <a onclick='searchTreeText(\"2\")'><img src='${root}cmm/common/images/icon_arrow_left.png'></a> | <a onclick='searchTreeText(\"3\")'><img src='${root}cmm/common/images/icon_arrow_right.png'></a>&nbsp;";divScpt.treeTop = divScpt.treeTop+"<a onclick='fnRefreshTree(null,true)'><img src='${root}cmm/common/images/img_refresh.png'></a>";divScpt.treeTop=divScpt.treeTop+"</div>";divScpt.cntnTop="";return divScpt;}
function fnSetButtonDiv(isViewSave, isViewDel, isViewList){
	if(isViewSave="" || isViewSave == undefined){}else if(isViewSave){$("#viewSave").attr("style", "display:block");}else{$("#viewSave").attr("style", "display:none");}
	if(isViewDel="" || isViewDel == undefined){}else if(isViewDel){$("#viewDel").attr("style", "display:block");}else{$("#viewDel").attr("style", "display:none");}
	if(isViewList="" || isViewList == undefined){}else if(isViewList){$("#viewList").attr("style", "display:block");}else{$("#viewList").attr("style", "display:none");}
}
function fnCheckSearch(isType){
	var schNm = 'chkSearch';
	var sch = $('#'+schNm);
	if(sch.length == 0){
		$('body').append("<input id='"+schNm+"' type='hidden' value=''></input>");
	}
	if(isType == "S"){
		
		if(sch.val()=='true') {
			//alert('조회 중입니다 잠시만 기다려 주십시오.');
			alert("${WM00066}");
			return false;
		}else{
			sch.val("true");
			return false;
		}
		}else if(isType =="E"){
			sch.val("false"); 
			return true;}
	}
function fnCheckIEVer(){var myNav = navigator.userAgent.toLowerCase();return (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : -1;}
function fnChangeLangComboStyle(style){$('#nav2 li.top').attr("style",style);$('#nav2 li ul.sub2').attr("style",style);$('#nav2 li ul.sub2 li a').attr("style",style);}
function fnChangeCmpnyComboStyle(style){$('#nav3 li.top').attr("style",style);$('#nav3 li ul.sub3').attr("style",style);$('#nav3 li ul.sub3 li a').attr("style",style);
}
function fnSetButton(el, iconName, text, style = "primary", buttonWrapper, func) {
	let wrapper, newButton = "";
	if(buttonWrapper) { // 버튼들의 부모태그가 있을 경우, el을 생성해준다.
		wrapper = document.getElementById(buttonWrapper);
		newButton = document.createElement("button");
		newButton.classList.add(style);
		newButton.setAttribute("onclick", func);
		newButton.setAttribute("type", "button");
		if(iconName) newButton.innerHTML = icon[iconName];
		newButton.innerHTML += `<span class='text'>\${text}</span>`;
		wrapper.appendChild(newButton);
	} else { // 버튼들의 부모태그가 없을 경우, el에 스타일, 아이콘등을 생성해준다.
		const button = document.querySelector("#"+el);
		button.classList.add(style);
		button.setAttribute("type", "button");
		if(iconName) button.innerHTML = icon[iconName];
		button.innerHTML += `<span class='text'>\${text}</span>`;
	}
}
function getFileSize(x) {
	  var s = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
	  var e = Math.floor(Math.log(x) / Math.log(1024));
	  if (x === 0) return "0"
	  else return (x / Math.pow(1024, e)).toFixed(1) + " " + s[e];
	};

function checkDateYear(startDate, endDate, period, msg){
	if(period == '' || period == null || period == undefined ){
		period = 365;
	}
	
	if(msg == '' || msg == null || msg == undefined ){
		msg = "1년";
	}
	var start = new Date(startDate);
    var end = new Date(endDate);
    var timeDifference = end - start;
    var oneYearInMilliseconds = period * 24 * 60 * 60 * 1000;
    if (timeDifference > oneYearInMilliseconds) {
        alert(msg+" 이상 조회는 관리자에게 문의 부탁드립니다.");
        return false;
    } else {
    	return true;
    }
}	

function setDefaultLocalDate(period){
	
	// 로컬 시간대로 셋팅 ( dhtmlx calender 시간대 로컬로 설정 )
	if(period == '' || period == null || period == undefined ){
		period = 14;
	}
	
	var now = new Date();
	var offset = now.getTimezoneOffset() * 60000;
	var estNow = new Date(now.getTime() - offset);
	
	var endDate = estNow.toISOString().substring(0,10);
	
	var bDay = new Date(now.setDate(now.getDate() - period));
	var localBDay = new Date(bDay.getTime() - offset);
	
	var startDate = localBDay.toISOString().substring(0,10);
	
	var defaultDate = {
	    "startDate": startDate,
	    "endDate": endDate
	};
	
	return defaultDate;

}	

// 브라우저에서 특정 이벤트 차단
// document.addEventListener('keydown', function (e) {
//     if ((e.ctrlKey && ['c',  'x', 'p'].includes(e.key.toLowerCase())) || e.key === 'PrintScreen') {
//         e.preventDefault();
//         alert('복사/붙여넣기가 차단되었습니다.');
//         return false;
//     }
    
//     if (e.key === 'F12' || (e.ctrlKey && e.shiftKey && ['I', 'J', 'C', 'K'].includes(e.key.toUpperCase()))) {
//         e.preventDefault();
//         alert('개발자 도구 사용이 차단되었습니다.');
//         return false;
//     }
// });

// document.addEventListener('contextmenu', function (e) {
//     e.preventDefault();
// });

// dhtmlx window 객체 전역 선언 (최초 1회만 생성)
var dhxWins = null;

function popup(url, title, width = 600, height = 400, unique = true) {
    // dhtmlxWindows가 없으면 생성
    //     if (!dhxWins) {
    dhxWins = new dhtmlXWindows();
    //     }

    // 고유한 window ID (중복방지 or 매번 새 창 구분 가능)
    let winId = "win_" + url.replace(/[^a-zA-Z0-9]/g, "_");

    // unique=false 이면 매번 새로운 창 열게 id에 timestamp 추가
    if (!unique) {
        winId += "_" + Date.now();
    }

    // unique=true 일 때는 중복 체크 후 포커스만 이동
    if (unique && dhxWins.isWindow(winId)) {
        dhxWins.window(winId).bringToTop();
        return;
    }

    // 새 창 생성
    var win = dhxWins.createWindow(winId, 50, 50, width, height);
    // 버튼 숨기기
    win.button("park").hide(); // 파크 버튼 숨김
    win.button("minmax1").hide(); // minimize 버튼 숨김
    win.button("minmax2").hide(); // maximize 버튼 숨김
    win.denyResize();
    win.setText(title);
    win.center();

    // url 로드 (iframe)
    win.attachURL(url);

    // 닫기 이벤트 (정리 용도)
    win.attachEvent("onClose", function () {
        localStorage.removeItem("selectedText");
        return true;
    });
}

// label 저장
let db;

// 1. IndexedDB 열기
const request = indexedDB.open("dictionary", 2);

request.onupgradeneeded = function (event) {
    db = event.target.result;

    // BTN 저장소 생성
    if (!db.objectStoreNames.contains("BTN"))  db.createObjectStore("BTN", { keyPath: "LABEL_CD" });
    
    // ERRTP 저장소 생성
    if (!db.objectStoreNames.contains("ERRTP")) db.createObjectStore("ERRTP", { keyPath: "LABEL_CD" });
    
    // GUIDELN 저장소 생성
    if (!db.objectStoreNames.contains("GUIDELN")) db.createObjectStore("GUIDELN", { keyPath: "LABEL_CD" });
};

request.onsuccess = function (event) {
    db = event.target.result;
    fetchAndStore("/olmapi/dic/category?category=BTN&languageID=${sessionScope.loginInfo.sessionCurrLangType}", "BTN");
    fetchAndStore("/olmapi/dic/category?category=ERRTP&languageID=${sessionScope.loginInfo.sessionCurrLangType}", "ERRTP");
    fetchAndStore("/olmapi/dic/category?category=GUIDELN&languageID=${sessionScope.loginInfo.sessionCurrLangType}", "GUIDELN");
};

request.onerror = function (event) {
    console.error("IndexedDB 에러:", event.target.error);
};

function fetchAndStore(apiUrl, storeName) {
    fetch(apiUrl)
        .then((res) => res.json())
        .then((data) => {
            const tx = db.transaction(storeName, "readwrite");
            const store = tx.objectStore(storeName);

            data.forEach((item) => {
                // LABEL_CD 키 존재 여부 확인 (필요시 keyPath 수정)
                if (!item.LABEL_CD) {
                    console.warn("["+storeName+"] 항목에 LABEL_CD 없음", item);
                } else {
                    store.put(item);
                }
            });

            tx.oncomplete = () => {
            	 console.log("["+storeName+"] IndexedDB 저장 완료");
            };
        })
        .catch((err) => console.log("["+storeName+"] API 오류:", err));
}

function getDicData(storeName, key) {
    return new Promise((resolve, reject) => {
        const request = indexedDB.open("dictionary");

        request.onerror = (event) => {
            console.error("IndexedDB open error:", event);
            reject(event);
        };

        request.onsuccess = (event) => {
            const db = event.target.result;
            const transaction = db.transaction(storeName, "readonly");
            const objectStore = transaction.objectStore(storeName);
            const getRequest = objectStore.get(key);

            getRequest.onsuccess = (event) => {
                resolve(event.target.result);
            };

            getRequest.onerror = (event) => {
                console.error("Data fetch error:", event);
                reject(event);
            };
        };
    });
}

async function getArcName(arcCode, target) {
	const res = await fetch("/getDictionary.do?category=AR&typeCode="+arcCode+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}");
    const data = await res.json();
    
    if(data !== undefined && data !== null && data !== '') {
    	document.querySelector(target).innerText = data.data.LABEL_NM;
    }
}

var calObj = null;
var _calendarObject1 = null;
var _calendarObject2 = null;
var _calendarObjectId = "";
let previousElementSibling = "";
let nextElementSibling = ""; 
let range = "";

const locale = {
    EN : {
        monthsShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
        months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
        daysShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
        days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
        cancel: "Cancel"
    },
    KO : {
        monthsShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        months: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        daysShort: ["일", "월", "화", "수", "목", "금", "토"],
        days: ["일", "월", "화", "수", "목", "금", "토"],
        cancel: "취소"
    }
}

var activeCalendar = null;
var activeInput = null;
// 이벤트 핸들러를 참조하기 위한 변수
var calendarCloseHandler = null; 

// [calendar] close 함수
function closeCalendar() {
    document.querySelector("#calendar1")?.remove();
    document.querySelector("#calendar2")?.remove();

    if (calendarCloseHandler) {
        document.removeEventListener('mousedown', calendarCloseHandler);
        calendarCloseHandler = null;
    }
    
    activeCalendar = null;
    activeInput = null;
    _calendarObject1 = null;
    _calendarObject2 = null;
}

function doClickCalendar(type, obj, posX, posY, dateType, sToday, itemName) {
    // 이미 활성화된 캘린더가 있다면 닫기
    if ((_calendarObject1 || _calendarObject2) && activeInput !== obj) {
        closeCalendar();
    }
    
    const calendar1Div = document.querySelector("#calendar1");
    
    if(!calendar1Div) {
		if( posX == null || posX == 'undefined' ) posX = 20;
		if( posY == null || posY == 'undefined' ) posY = -130;
		
		const calendar1 = document.querySelector("#calendar1");
		const calendar2 = document.querySelector("#calendar2");
		
		range = false;
		previousElementSibling = obj.previousElementSibling?.classList.contains("datePicker");
		nextElementSibling = obj.nextElementSibling?.classList.contains("datePicker");
		if(previousElementSibling || nextElementSibling) range = true;
		
		doCalendarInit(range, obj);
				
		var divScrollTopHeight = 0;
		if (document.getElementById("editArea") != null ) {
			divScrollTopHeight = document.getElementById("editArea").scrollTop;
		}
		
		if (type == "N") {
			calObj = document.getElementById(obj);
			calObj.focus();
		} else {
			calObj = obj;
		}
		
		var target = document.getElementById(obj);
		if(!target) target = obj
		
		if(previousElementSibling) target = obj.previousElementSibling;
			
		if (type == "N") {
			if(isValidDate($("#" + obj).val())) {
				_calendarObject1.setValue($("#" + obj).val());
			} else {
				_calendarObject1.clear();
			}
		}
		
		if(type == "Y")	_calendarObjectId = obj.id;
		else _calendarObjectId = obj;
		
		_sToday = sToday;
		_dateType = dateType;
		_datecount = 0;
		if( itemName == null || itemName == 'undefined' ) itemName = "해당항목";
		_dateItemName = itemName;
    }
}

function doCalendarInit(range, obj) {
	var objParent = obj.parentElement;
	
	if(!objParent.children.calendar1) {
		var divElement1 = document.createElement("div");
		divElement1.setAttribute("id", "calendar1");
		divElement1.setAttribute("style", "position: absolute; z-index: 999;top:36px;height: 262px;border: 1px solid #ddd;");
		
		objParent.appendChild(divElement1);
		
		_calendarObject1 = new dhx.Calendar("calendar1", { dateFormat : "%Y-%m-%d" });
		
		if(range) {
			var divElement2 = document.createElement("div");
			divElement2.setAttribute("id", "calendar2");
			divElement2.setAttribute("style", "position: absolute; z-index: 999;top:36px;height: 262px;border: 1px solid #ddd;left: 250px;border-left: none;");
			objParent.appendChild(divElement2);
			
			_calendarObject2 = new dhx.Calendar("calendar2", { dateFormat : "%Y-%m-%d" });
			_calendarObject1.link(_calendarObject2);
			
			if( window.innerWidth <= divElement2.getBoundingClientRect().right) {
				const parentRightPosition = divElement2.parentNode.getBoundingClientRect().right;
				divElement1.setAttribute("style", divElement1.getAttribute("style")+"left:"+ ( parentRightPosition -  divElement2.getBoundingClientRect().right ) + "px");
				divElement2.setAttribute("style", divElement2.getAttribute("style")+"left:"+( 250 + parentRightPosition -  divElement2.getBoundingClientRect().right ) + "px");
			}
		}
		
		if(previousElementSibling) {
			_calendarObject1.setValue(obj.previousElementSibling.value);
			_calendarObject2.setValue(obj.value);
		}
		else if(nextElementSibling) {
			_calendarObject1.setValue(obj.value);
			_calendarObject2.setValue(obj.nextElementSibling.value);
		}
		else {
			_calendarObject1.setValue(obj.value);
		}
	}
	
	_calendarObject1.events.on("change", function (date) {
		// 2번째 달력에서 클릭할 경우
		if(previousElementSibling) calObj.previousElementSibling.value = _calendarObject1.getValue();
		// 1번째 달력에서 클릭할 경우
		else if(nextElementSibling) {
			calObj.value = _calendarObject1.getValue();
			calObj.nextElementSibling.value = _calendarObject2.getValue();
		}
		// 달력이 하나만 있는 경우
		else calObj.value = _calendarObject1.getValue();
	});

	if(range) {
		_calendarObject2.events.on("change", function (date) {
			if(previousElementSibling) calObj.value = _calendarObject2.getValue();
			else if(nextElementSibling) calObj.nextElementSibling.value = _calendarObject2.getValue();
		});
	}
	
    activeCalendar = _calendarObject1;
    activeInput = obj
    
    calendarCloseHandler = function(event) {
        const calendar1Div = document.getElementById("calendar1");
        const calendar2Div = document.getElementById("calendar2");
        
        // 클릭된 요소가 input이나 캘린더 컨테이너 내부에 있는지 확인
        const isClickInside = activeInput.contains(event.target) || 
                              (calendar1Div && calendar1Div.contains(event.target)) || 
                              (calendar2Div && calendar2Div.contains(event.target));

        // 클릭이 캘린더 외부에서 발생했을 때만 캘린더를 닫음
        if (!isClickInside) {
            closeCalendar();
        }
    };

    // 이벤트 리스너 추가
    document.addEventListener('mousedown', calendarCloseHandler);
}

/**
 * 선택된 줄의 컬럼을 hidden으로 생성하여 반환한다.
 * @param grid
 * @param form
 * @return
 */
function fnFetchSelectedCol(grid, col_ind, form) {
    $add("gridCols_" + gridUid, grid.config.columns.filter(e => e.id !== "RNUM").map(e => e.id).join("|"));
	var targetColumnId  = grid.config.columns[col_ind].id;//체크된 로우
	
	if(grid.data.getInitialData().length > 0){
		var gridUid = grid._container.id;
		$add("colName", grid.config.columns.filter(e => e.id !== "RNUM").map(e => e.id).join("|"), form);
		$add("rowCount", grid.data.getInitialData().length, form);
		$add("colNum", grid.config.columns.length, form);
		for (i = 0; i < grid.data.getInitialData().length; i++) {
			const rowId = grid.data.getId(i);
			const rowData = grid.data.getItem(rowId);
			for (j = 0; j < grid.config.columns.length; j++) {
				const columnId = grid.config.columns[j].id;
				const cellValue = rowData[columnId];				
				$add("r"+i+"_col"+j, cellValue, form);//form에 "r" + rowIndex + "_col + colIndex의 이름과  ID를 가지고 값은 컬럼의 값을 가진 객체 생성
			}
			var rowType = $("#rowStatus"+grid.data.getInitialData()[i][targetColumnId]).val();
			if (rowType==null) {
				rowType = "U";
			}
			$add("r"+i+"_type", rowType, form);
		}
		return true;
	}
	else {
		alert('선택한 내용이 없습니다.');
		return false;
	}
}

/**
 * 데이터가 없는 것을 표시한다.
 * @param icon - 상위에 표시될 아이콘
 * @param title - 굵을 글자로 표시되는 부분
 * @param desc - 타이틀 하위에 표시될 설명
 * @param buttonFunc - 버튼이 실행될 함수
 * @param buttonTitle - 버튼에 표시될 명칭
 * @param buttonStyle - 버튼에 적용퇼 css 클래스
 * @return
 */
function emptyPage(icon, title, desc, buttonFunc, buttonTitle, buttonStyle = "primary") {
	let html = '';
	
	html += '<div class="empty-wrapper btns">'
	html += icon
	html += '<p class="title">'+title+'</p>'
	if(desc) html += '<p class="desc">'+desc+'</p>'
	if(buttonTitle) html += '<button class="mgT10 '+buttonStyle+'" onclick="'+buttonFunc+'">'+buttonTitle+'</button>'
	html += '</div>'
	
	return html;
}

/**
 * url의 내용물을 ajaxPage로 받아 dhx 모달로 띄운다. 호출환경이 dhtmlx suite 9를 임포트해야 한다.
 * @param url - ajaxPage로 내용물 불러올 url 주소
 * @param data - ajaxPage에 넘겨줄 데이터
 * @param title - 모달 상단에 띄울 제목
 * @param w - 모달의 너비 (px)
 * @param h - 모달이 높이 (px)
 * @return
 */
function openUrlWithDhxModal(url, data, title="", w=1150, h=530, target) {
	
	const actualWidth = w ? w : 1150;
	const actualHeight = h ? h : 530;

    var newDhxWindow = new dhx.Window({
        width: actualWidth,
        height: actualHeight,
		title: title,
        modal: true,
        resizable: true,
        movable: true,
        css: "custom-dhx-modal"
    });
    
    newDhxWindow.show();

    if (target) {
    	ajaxPage(url, data, target);
    } else {
    	var tempTargetId = "rptContent_" + new Date().getTime();
        newDhxWindow.attachHTML('<div id="' + tempTargetId + '" style="width:100%; height:100%;  overflow: hidden; "></div>');
    	ajaxPage(url, data, tempTargetId);
    }
  
    return newDhxWindow;
}

/**
 * form 등 html을 dhx 모달로 띄우며, 띄운 후 콜백함수를 실행시킨다. 호출환경이 dhtmlx suite 9를 임포트해야 한다.
 * @param htmlString - 모달에 띄울 html 내용물
 * @param title - 모달 상단에 띄울 제목
 * @param w - 모달의 너비 (px)
 * @param h - 모달이 높이 (px)
 * @param callback - 모달 뜨고 난 후 실행시킬 콜백함수
 * @return
 */
function openHtmlWithDhxModal(htmlString, title, w=1150, h=530, callback) {
	
	const actualWidth = w ? w : 1150;
	const actualHeight = h ? h : 530;
	
    var newDhxWindow = new dhx.Window({
        width: actualWidth,
        height: actualHeight,
		title: title,
        modal: true,
        resizable: true,
        movable: true,
        css: "custom-dhx-modal"
    });
    newDhxWindow.show();
    newDhxWindow.attachHTML(htmlString);
	
    if(callback && typeof callback === 'function'){
        setTimeout(callback, 50);
    }
    return newDhxWindow;
}

/**
 * dhx message 활용한 토스트 메시지를 띄운다. 호출환경이 dhtmlx suite 9를 임포트해야 한다.
 * @param rawText - 토스트 메시지에 띄울 텍스트. 
 * @param showDuration - 토스트 메시지 유지 시간. 경과 시 토스트 메시지 사라짐.
 * @return
 */
function showDhxMsg(rawText="message to print", showDuration=1500) {
	
	// dhx.message에서 text 속성이 빈문자열이면 오류 일으키므로, 빈문자열 또는 null 들어올 시 " "로 대체해 오류 방지
	const actualText = rawText == "" || rawText == null ? " " : rawText;

	dhx.message({
	    text: actualText,
	    position: "top-center",
	    expire: showDuration,
	    css: "custom-dhx-msg"
	});
}

/**
 * dhx alert를 띄운다. 호출환경이 dhtmlx suite 9를 임포트해야 한다.
 * @param alertMsg - 알러트에 띄울 텍스트.  
 * @param buttonLabel - 알러트 닫기 버튼에 지정할 라벨 텍스트.
 * @param afterCloseCallbackFn - 알러트 닫은 후 실행시킬 콜백함수.
 * @return
 */
function showDhxAlert(rawText="message to print", buttonLabel = "close", afterCloseCallbackFn ) {

	// dhx.alert에서 text 속성이 빈문자열이면 오류 일으키므로, 빈문자열 또는 null 들어올 시 " "로 대체해 오류 방지
	const alertMsg = rawText == "" || rawText == null ? " " : rawText;
	
    dhx.alert({
	     text: alertMsg,
	     buttonsAlignment: "center",
	     buttons: [buttonLabel],
	 }).then(function(answer){
		if ((typeof afterCloseCallbackFn) == "function"){
			afterCloseCallbackFn();
		} else if ((typeof afterCloseCallbackFn) == null || (typeof afterCloseCallbackFn) == undefined) {
			return ;
		} else {
			console.warn("Invalid type - afterCloseCallback: " (typeof afterCloseCallbackFn))
		}
	 });
}

/**
 * dhx confirm을 띄운다. 호출환경이 dhtmlx suite 9를 임포트해야 한다.
 * @param confirmMsg - 컨펌에 띄울 텍스트. 
 * @param afterConfirmCallbackFn - 컨펌 버튼 클릭 후 실행시킬 콜백함수.
 * @param afterCancelCallbackFn - 취소 버튼 클릭 후 실행시킬 콜백함수.
 * @param confirmButtonLabel - 컨펌 버튼에 지정할 라벨 텍스트.
 * @param cancelButtonLabel - 취소 버튼에 지정할 라벨 텍스트.
 * @return
 */
function showDhxConfirm(rawText="message to print", afterConfirmCallbackFn, afterCancelCallbackFn, confirmButtonLabel = "confirm", cancelButtonLabel = "cancel", ) {
	
	// dhx.confirm에서 text 속성이 빈문자열이면 오류 일으키므로, 빈문자열 또는 null 들어올 시 " "로 대체해 오류 방지
	const confirmMsg = rawText == "" || rawText == null ? " " : rawText;
	
	dhx.confirm({
        text: confirmMsg,
        buttonsAlignment: "center",
        buttons: [cancelButtonLabel, confirmButtonLabel],
    }).then(function(result) {
    	// 취소 누를 시 result == false, confirm 누를 시 result == true임
        if (result === true) {
    		if ((typeof afterConfirmCallbackFn) == "function"){
    			afterConfirmCallbackFn();
    		} else if ((typeof afterConfirmCallbackFn) == null || (typeof afterConfirmCallbackFn) == undefined) {
    			return ;
    		} else {
    			console.warn("Invalid type - afterConfirmCallbackFn: " (typeof afterConfirmCallbackFn))
    		}
        } else {
    		if ((typeof afterCancelCallbackFn) == "function"){
    			afterCancelCallbackFn();
    		} else if ((typeof afterCancelCallbackFn) == null || (typeof afterCancelCallbackFn) == undefined) {
    			return ;
    		} else {
    			console.warn("Invalid type - afterCancelCallbackFn: " (typeof afterCancelCallbackFn))
    		}
        }
    });
}

</script>