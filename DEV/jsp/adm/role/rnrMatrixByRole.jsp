<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.js?v=7.1.8"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.css">

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021" arguments="Assign "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<script>
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
      	$("#treegrid_container").attr("style","height:"+(setWindowHeight() * 0.92)+"px;");
      
      	// 화면 크기 조정
      	window.onresize = function() {
         	$("#treegrid_container").attr("style","height:"+(setWindowHeight() * 0.92)+"px;");
      	};
	      
		fnTreeGridLoad();
		window.parent.closeMaskLayer();
	});
	 
	function setWindowHeight(){
      var size = window.innerHeight;
      var height = 0;
      if( size == null || size == undefined){
         height = document.body.clientHeight;
      }else{
         height=window.innerHeight;
      }return height;
	}
	 
	function fnTreeGridLoad(){
		var d=fnSetMenuTreeGridDataV7();
		fnLoadDhtmlxTreeGridJsonV7(d.key, d.cols, d.data); 
	}
	
	function fnSetMenuTreeGridDataV7(data){
		//console.log("${header} ::: ${column}");
		if(data == 'undefined' || data == null){data = "";}
		var result = new Object();
		result.title = "${title}";
		result.key = "role_SQL.getSubItemTeamRoleTreeGList";
		result.header = "TREE_ID,PRE_TREE_ID,TREE_NM,ItemID";
		result.cols = "TREE_ID|PRE_TREE_ID|TREE_NM|ItemID|${cols}";
		result.data = data ;
		return result;
	}
	
	function fnLoadDhtmlxTreeGridJsonV7(key, cols, value, select, noMsg, callbackFnc) {
		var msg = "${WM00018}";
		var data = "menuId="+key;
		data += "&cols=" + cols.replaceAll('||','|');
		data += "&SelectMenuId=" + select;
		data += "&" + value;
		data += "&s_itemID=${s_itemID}&elmClassList=${elmClassList}";
		
		// console.log("data :"+data);
		try{if(key==null || key == ""){fnLog("ERROR fnLoadDhtmlxTreeJson() data: " + data);
		fnLog("ERROR fnLoadDhtmlxTreeJson() callstack : " + showCallStack());}} catch(e) {}if(callbackFnc == undefined || callbackFnc == null){ callbackFnc="";}
		ajaxTreeGridLoadV7("<c:url value='/getRnrMatrixByRoleDataList.do'/>", data, "", false, noMsg, msg, callbackFnc);
	}
	
	function ajaxTreeGridLoadV7(url, data, target, debug, noMsg, msg, callback) {
		$.ajax({
			url: url,type: 'post',data: data
			,error: function(xhr, status, error) {('#loading').fadeOut(150);var errUrl = "errorPage.do";var errMsg = "status::"+status+"///error::"+error;var callback = "";var width = "300px";var height = "300px";var callBack = function(){};fnOpenLayerPopup(errUrl,errMsg,callBack,width,height);}
			,beforeSend: function(x) {$('#loading').fadeIn();if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	}
			,success: function(result){
				$('#loading').fadeOut();if(debug){alert(result);}	if(result == 'error' || result == ""){if(noMsg != 'Y'){alert(msg);}
				}else{
					result = JSON.parse(result);
					if(result != ""){
						fnTreeGridList(result);
						treeGrid.hideColumn("assign");
					}
				}
				if(callback== null || callback==""){}
				else if (typeof callback === "function") {
			        callback(); 
			    }
			}
		});
	}
	
	var treeGrid; var treeGridData;
	function fnTreeGridList(resultdata){
		treeGridData = resultdata;
		treeGrid = new dhx.TreeGrid("treegrid_container", {
			columns: [
				{ width: 300, id: "value",  header: [{ text: "${menu.LN00028}" , align:"center"}, { content: "inputFilter"}], htmlEnable: true },
				{ width: 100, id: "assign", header: [{ text: "" , align:"center"}], htmlEnable: true, align: "center",
		        	template: function (text, row, col) {
		        		let result = "";
		        		if(row.$level == "1") result = '<img src="${root}${HTML_IMG_DIR}/item/icon_link.png" width="7" height="11" onclick="assignProcess('+row.ItemID+')">';
		        		return result;
		            }
				},
				{  hidden: true, width: 100, id: "parent",  type: "string",  header: [{ text: "PREE TREE ID"}] },
				{  hidden: true, width: 100, id: "id", type: "string",  header: [{ text: "TREE ID" }] },
				{  hidden: true, width: 100, id: "ItemID",  type: "string",  header: [{ text: "ItemID"}] },
				${treegridHeader}
			],
			autoWidth: true,
			data: resultdata,
			selection: "row",
			resizable: true
		});
	} 
	
	function rowDataTemplate(value, row, col) {		
		var desccol = col.id.replaceAll('T','D');
		 if (!value) {
	        return;
	    }else{
	    	if(row[String(desccol)] == undefined){return;}
	    	var roleDesc = row[String(desccol)].replaceAll("&lt;","<").replaceAll("&gt;",">");
	    	return roleDesc;
	    }
	}
	
	
	function fnDownload() {
		treeGrid = new dhx.TreeGrid("treegrid_container", {
			columns: [
				{ width: 300, id: "value",  header: [{ text: "${menu.LN00028}" , align:"center"}, { content: "inputFilter"}], htmlEnable: true },
				{  hidden: true, width: 100, id: "parent",  type: "string",  header: [{ text: "PREE TREE ID"}] },
				{  hidden: true, width: 100, id: "id", type: "string",  header: [{ text: "TREE ID" }] },
				{  hidden: true, width: 100, id: "ItemID",  type: "string",  header: [{ text: "ItemID"}] },
				${treegridHeaderEx}
			],
			autoWidth: true,
			data: treeGridData,
			selection: "row",
			resizable: true
		});
		
		/* treeGrid.export.xlsx({
	        url: "//export.dhtmlx.com/excel"
	    }); */
		
		treeGrid.destructor();
	}
	
	function fnOpenItemPop(itemID){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		var w = 1200;
		var h = 900; 
		itmInfoPopup(url,w,h,itemID);
	}
	
	let activityItemID = "";
	function assignActivate() {
		treeGrid.showColumn("assign");
		
		// 삭제 버튼 활성화
		document.getElementsByName("del-btn").forEach(e => e.classList.remove("none"))
	}
	
	// 연관항목 생성
	function assignProcess(itemID){
		activityItemID = itemID;
		var url = "selectCxnItemTypePop.do?s_itemID="+activityItemID+"&varFilter=${varFilter}&cxnTypeList=${cxnTypeList}&screenMode="; 
		var w = 500;
		var h = 300;
		itmInfoPopup(url,w,h);
	}
	
	function fnOpenItemTree(itemTypeCode, searchValue, cxnClassCode){
		$("#cxnTypeCode").val(itemTypeCode);
		$("#cxnClassCode").val(cxnClassCode);
		var url = "itemTypeCodeTreePop.do";
		var data = "ItemTypeCode="+itemTypeCode+"&searchValue="+searchValue
			+"&openMode=assign&s_itemID="+activityItemID;

		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
	function doCallBack(){
		//alert(1);
	}
	
	//After [Assign -> Assign]
	function setCheckedItems(checkedItems){
		var cxnTypeCode = $("#cxnTypeCode").val();
		var cxnClassCode = $("#cxnClassCode").val();
		var url = "createCxnItem.do";
		var data = "s_itemID="+activityItemID+"&cxnTypeCode="+cxnTypeCode+"&items="+checkedItems
					+ "&cxnTypeCodes=${varFilter}"
					+ "&cxnClassCode="+cxnClassCode;
		var target = "blankFrame";
		
		ajaxPage(url, data, target);
		
		$("#cxnTypeCode").val("");
		$("#cxnClassCode").val("");
		$(".popup_div").hide();
		$("#mask").hide();	
	}
	
	//[Assign] 이벤트 후 Reload
	function thisReload(){
		var url = "rnrMatrixByRole.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&varFilter=${varFilter}&option=${option}"
					+"&filter=${filter}&screenMode=${screenMode}&showTOJ=${showTOJ}"
					+"&frameName=${frameName}&showElement=${showElement}&cxnTypeList=${cxnTypeList}";
		
	 	ajaxPage(url, data, target);
	}
	
	function delConnection(activityItemID, itemID){
		if("${myItem}" == "Y") {
			if(confirm("${CM00004}")){
				var url = "DELCNItems.do";
				var data = "isOrg=Y&s_itemID="+itemID+"&items="+activityItemID;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		}
	}
	
	function urlReload() {
		thisReload();
	}
	
	function editPopup() {
		
	}
</script>

<style>
  	body {
      margin: 0;
    }

    .custom-tooltip {
        display: flex;
    }
    
    .custom-tooltip > *:last-child {
        margin-left: 12px;
    }
    
    .custom-tooltip img {
        width: 62px;
        height: 62px;
    }

</style>

<body>
   <div class="countList pdB5 " >
        <li class="floatR">
        	<c:if test="${myItem == 'Y'}">
	        	<span class="btn_pack nobg" alt="Assign" title="Assign"  style="cursor:pointer;_cursor:hand"><a onclick="assignActivate();"class="assign" ></a></span>
	        </c:if>
		    <span class="btn_pack nobg white mgR10"><a class="xls" OnClick="fnGridExcelDownLoad(treeGrid);" title="Excel" id="excel"></a></span>
	        
       </li>
   </div>   
   <div id="gridDiv" style="width:100%;" class="clear" >
		<div id="treegrid_container" style="width:100%; height:100%; overflow: scroll;"></div>
	</div> 
	<form name="cxnItemTreeFrm" id="cxnItemTreeFrm" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="cxnTypeCode" name="cxnTypeCode" >
		<input type="hidden" id="cxnClassCode" name="cxnClassCode" >
	</form>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>