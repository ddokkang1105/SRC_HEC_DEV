<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.js?v=7.1.8"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.css?v=7.1.8">

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>

<script>	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 340)+"px; width:100%;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 340)+"px; width:100%;");
		};
		
		$("#excel").click(function (){
			fnGridExcelDownLoad();
		});
		
		doSearchList();
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
	
	function fnOpenItemPop(itemID){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		var w = 1200;
		var h = 900; 
		itmInfoPopup(url,w,h,itemID);
	}
	
	let activityItemID = "";
	function assignActivate() {
		grid.showColumn("assign");
		
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
					+"&frameName=${frameName}&showElement=${showElement}&cxnTypeList=${cxnTypeList}&grid=${grid}&activityOnly=${activityOnly}&attrTypeCode=${attrTypeCode}";
		
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
	
	function editPopup(id,cxnClassName){
		$("#items").val(id);
		var url = "editAttrOfItemsPop.do?items="+id+"&attrCode='${attrTypeCode}'";
	    var w = 940;
		var h = 700;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");	
	}
	
	function selfClose() {
		thisReload();
	}
</script>
<body>
	<input type="hidden" id="cxnTypeCode" name="cxnTypeCode" >
	<input type="hidden" id="cxnClassCode" name="cxnClassCode" >
	<input type="hidden" id="items" name="items" value="">
   <div class="countList pdB5 " >
        <li class="floatR">
        	<c:if test="${myItem == 'Y'}">
	        	<span class="btn_pack nobg" alt="Assign" title="Assign"  style="cursor:pointer;_cursor:hand"><a onclick="assignActivate();"class="assign" ></a></span>
	        </c:if>
		    <span class="btn_pack nobg white mgR10"><a class="xls" OnClick="fnGridExcelDownLoad(treeGrid);" title="Excel" id="excel"></a></span>
       </li>
   </div>   
	<div style="width: 100%;" id="layout"></div>
</body>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	var pagination;
	
	var grid = new dhx.Grid("grid",  {
		columns: [
			{ maxWidth: 200, id: "value",  header: [{ text: "${menu.LN00028}" , align:"center"}, { content: "inputFilter"}], htmlEnable: true},
			{ width: 100, id: "assign", header: [{ text: "" , align:"center"}], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		let result = '<img src="${root}${HTML_IMG_DIR}/item/icon_link.png" width="7" height="11" onclick="assignProcess('+row.ItemID+')">';
	        		return result;
	            }
			},
			{  hidden: true, width: 100, id: "parent",  type: "string",  header: [{ text: "PREE TREE ID"}] },
			{  hidden: true, width: 100, id: "id", type: "string",  header: [{ text: "TREE ID" }] },
			{  hidden: true, width: 100, id: "ItemID",  type: "string",  header: [{ text: "ItemID"}] },
			${treegridHeader}
		],
		adjust: true,
		selection: "row",
		resizable: true
	});
	grid.hideColumn("assign");
	layout.getCell("a").attach(grid);
	
	
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
	
	function doSearchList(){
		var data = "menuId=role_SQL.getSubItemTeamRoleTreeGList";
		data += "&cols=TREE_ID|PRE_TREE_ID|TREE_NM|ItemID|ClassCode|${cols}|${cxnCols}|${attrCols}"
		data += "&s_itemID=${s_itemID}&elmClassList=${elmClassList}&attrTypeCode=${attrTypeCode}";
		
		$.ajax({
			url:"getRnrMatrixByRoleDataList.do",
			type:"POST",
			data: data,
			success: function(res){
				let result = JSON.parse(res.replaceAll("class='identifier'","class='identifier none'"));
				if("${activityOnly}" == "Y") result = result.filter(e => e.ClassCode == "CL01006");
				grid.data.parse(result);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}
</script>