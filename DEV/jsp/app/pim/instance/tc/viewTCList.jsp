<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<!-- 2. Script -->
<script type="text/javascript">
	var gridArea;				
	var skin = "dhx_skyblue";
	var index;
	
	$(document).ready(function() {
		var bottomView = $("#bottomView").innerHeight();
		document.getElementById('gridArea').style.height = (bottomView - 104)+"px";
		
		setElmGridList();
	});	
	
	$.fn.rowspan = function(colIdx, isStats) {
		return this.each(function(){
			var that;
			$('tr', this).each(function(row) {
				$('td:eq('+colIdx+')', this).filter(':visible').each(function(col) {
					if ($(this).html() != "&nbsp;" && $(this).html() == $(that).html()&& (!isStats|| isStats && $(this).prev().html() == $(that).prev().html())) {
						rowspan = $(that).attr("rowspan") || 1;
						rowspan = Number(rowspan)+1;
					
						$(that).attr("rowspan",rowspan);
						$(this).hide();
					} else {
						that = this;
					}
					that = (that == null) ? this : that;
				});
			});
		});
	};
	
	//===============================================================================
// BEGIN ::: GRID
	function setElmGridList(){
		var xmlData="${testResultXml}";
	    gridArea = new dhtmlXGridObject('gridArea');
	    gridArea.selMultiRows = true;
	    gridArea.imgURL = "${root}${HTML_IMG_DIR_ITEM}/";
	    gridArea.setImagePath("${root}${HTML_IMG_DIR_ITEM}/");
	    gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		gridArea.setHeader("${menu.LN00024},#master_checkbox,Step ${menu.LN00028},Guideline,Appl.,T-Code,프로그램명,Check Point,Document No,담당자,테스트 결과,Results,비고,ElmInstNo");
		gridArea.setInitWidths("30,30,180,*,60,80,120,120,80,100,80,80,50,100");
		gridArea.setColAlign("center,center,left,left,center,left,left,left,center,center,center,left,center");
		gridArea.setColTypes("ro,ch,link,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
		gridArea.setColSorting("str,int,str,str,str,str,str,str,str,str,str,str,str,str");
   	  	gridArea.init();
		gridArea.setSkin("dhx_web");
// 		gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		gridArea.enableRowspan(true);
		gridArea.parse(xmlData, function(){setTimeout(function() {$('.row20px').rowspan(2);$('.row20px').rowspan(3);}, 150);});
		gridArea.setColumnHidden(1, true);
		gridArea.setColumnHidden(8, true);
		gridArea.setColumnHidden(12, true);
		gridArea.setColumnHidden(13, true);
	}
	// END ::: GRID	
	//===============================================================================
	
	function fnDelete(){
		var elmInstNo = "";
		var status = "";
		var checkedRows = gridArea.getCheckedRows(1).split(",");
		for(var i = 0 ; i < checkedRows.length; i++ ){
			if (elmInstNo == "") {
				elmInstNo = gridArea.cells(checkedRows[i], 13).getValue();
			} else {
				elmInstNo = elmInstNo + "," + gridArea.cells(checkedRows[i], 13).getValue();
			}
		}
		if (confirm("${CM00042}")) {
			var url  = "deleteElmInst.do";
			var data = "&procInstNo=${instanceNo}&elmInstNo="+elmInstNo;
			var target = "saveDFrame";
			ajaxPage(url,data,target);
		}
	}
	
	function fnEditTestResult(){
		var url = "editTCList.do";
		var target = "cfgFrame";
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&elmItemID=${elmItemID}"
			+ "&fromModelYN=${fromModelYN}"
			+ "&instanceNo=${instanceNo}"
			+ "&instanceClass=${instanceClass}"
			+ "&processID=${procInstanceInfo.ProcessID}&procModelID=${procInstanceInfo.ProcModelID}";
		ajaxPage(url, data, target);
	}
	
	function fnItemPopUp(itemID){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemID);
	}
</script>
<style type="text/css">
	div.gridbox_dhx_web.gridbox .odd_dhx_web {background:none;}
	div.gridbox_dhx_web.gridbox table.obj tr.rowselected {background:none;}
	div.gridbox_dhx_web.gridbox table.obj.row20px tr.rowselected td {background:none;}
	div.gridbox_dhx_web.gridbox table.obj.row20px tr td a {color:#0054FF; text-decoration: underline;}
</style>
</head>
<body>
<div style="width:100%;">
	<form name="pimElementFrm" id="pimElementFrm" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<input type="hidden" id="cxnTypeCode" name="cxnTypeCode" value="OJ00004"></input> 
    <div class="countList">
		<ul>
		    <li class="floatR">
<!-- 		    	&nbsp;<span class="btn_pack medium icon"><span class="del"></span><input value="Delete" type="submit" onclick="fnDelete()"></span> -->
		    	&nbsp;<span class="btn_pack medium icon"><span class="edit"></span><input value="Edit" type="submit" onclick="fnEditTestResult()"></span>
<!-- 				&nbsp;<span class="btn_pack small icon"><span class="save"></span><input value="Save All" type="submit" onclick="fnSaveAll()"></span> -->
	 		</li>
		</ul>
    </div>
	<div id="gridDiv" class="mgB10 clear">
		<div id="gridArea" style="width:100%;"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div>
	</div>	
	<!-- END :: PAGING -->		
	</form>
	</div>
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>