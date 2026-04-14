<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>


<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid1;				//그리드 전역변수
	var pp_grid2;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	var userId = "${sessionScope.loginInfo.sessionUserId}";
	var authLev = "${sessionScope.loginInfo.sessionAuthLev}";
	
	$(document).ready(function() {	
		PgridInit();
		doPSearchList();
		PgridInit2();
		doPSearchList2();
	});	

	//그리드 초기화
	function PgridInit(){		
		var d = setPGridData();
		pp_grid1 = fnNewInitGrid("grdPAArea", d);
		pp_grid1.setImagePath("${root}${HTML_IMG_DIR}");
		pp_grid1.setIconPath("${root}${HTML_IMG_DIR}");
		pp_grid1.setColumnHidden(5, true);
		fnSetColType(pp_grid1, 4, "img");
		fnSetColType(pp_grid1, 12, "img");
		pp_grid1.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	}
	
	// Model order by 'MTCategory' 알파벳순
	function setPGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "custom_SQL.zhdhi_selectValidateItemList";
		result.header = "${menu.LN00024},${menu.LN00106},${menu.LN00028},${menu.LN00178},${menu.LN00179},OjbectID,${menu.LN00033},${menu.LN00027},${menu.LN00004},${menu.LN00070},ItemBlocked,MTCategory,${menu.LN00125},IsPublic,ItemAuthorID,ModelBlocked,ModelTypeName,URL,ChangeSetID,ItemID,ModelID,LockOwner";
		result.cols = "Identifier|Name|KBN|VrfctnLink|ObjectID|MTCName|StatusName|UserName|LastUpdated|ItemBlocked|MTCategory|BtnControl|IsPublic|ItemAuthorID|ModelBlocked|ModelTypeName|URL|ChangeSetID|ObjectID|ModelID|LockOwner";
		result.widths = "30,100,290,80,80,80,80,80,80,80,0,0,80,0,0,0,0,0,0,0,0,0";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "ItemID=${ItemID}&ModelID=${ModelID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&ModelTypeCode=${ModelTypeCode}&userId="+userId+"&authLev="+authLev;
		return result;
	}

	function gridOnRowSelect(id, ind){
		var modelName = pp_grid1.cells(id, 2).getValue();
		var ItemBlocked = pp_grid1.cells(id, 10).getValue();
		var MTCategory = pp_grid1.cells(id, 11).getValue();				
		var ModelIsPublic = pp_grid1.cells(id, 13).getValue();
		var itemAthId = pp_grid1.cells(id, 14).getValue();
		var modelBlocked = pp_grid1.cells(id, 15).getValue();
		var modelTypeName = pp_grid1.cells(id, 16).getValue();
		var menuUrl = pp_grid1.cells(id, 17).getValue();
		var changeSetID = pp_grid1.cells(id, 18).getValue();
		var ItemID = pp_grid1.cells(id, 19).getValue();
		var ModelID = pp_grid1.cells(id, 20).getValue();
		var LockOwner = pp_grid1.cells(id, 21).getValue();
		var scrnType = "";
		var myItem = "";
		if(itemAthId == userId || LockOwner == userId || "1" == authLev){
			myItem = "Y";
		}
		if(ind == 12){
			if(MTCategory == "VER" || ItemBlocked != "0"){// 카테고리가 vsersion 이면 model viewr open		
			   scrnType =  "view";
			}else{	
				if(ModelIsPublic == 1){
					scrnType = "edit";					
				} else{
					if((itemAthId == userId || "${sessionScope.loginInfo.sessionUserId}" == userId) && modelBlocked == "0"&& myItem == 'Y' ){
						scrnType = "edit";	
					} else{
						scrnType = "view";
					}
				}
			}
			var url = "popupMasterMdlEdt.do?"
					+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&s_itemID="+ItemID
					+"&modelID="+ModelID
					+"&scrnType="+scrnType
					+"&MTCategory="+MTCategory
					+"&modelName="+encodeURIComponent(modelName)
				    +"&modelTypeName="+encodeURIComponent(modelTypeName)
					+"&menuUrl="+menuUrl
					+"&changeSetID="+changeSetID
					+"&selectedTreeID="+ItemID;
			var w = 1200;
			var h = 900;
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		} else{
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+ItemID+"&scrnType=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,ItemID);
		}
	}
		
	function doPSearchList(){
		var d = setPGridData();
		fnLoadDhtmlxGridJson(pp_grid1, d.key, d.cols, d.data, false);
	}	
	
	function doGetCompareModelList(){	
		if(pp_grid1.getCheckedRows(1).length == 0){	
			alert("${WM00023}");
			return;
		}
		
		var ModelID;
		
		var checkedRows = pp_grid1.getCheckedRows(1).split(",");
		for(var i = 0 ; i < checkedRows.length; i++ ){
			ModelID = pp_grid1.cells2(i,2).getValue();
		}
		var url = "getValidateItem.do?ModelID="+ModelID+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var w = 880;
		var h = 500;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		self.close();
	}
	
	//그리드 초기화
	function PgridInit2(){		
		var d = setPGridData2();
		pp_grid2 = fnNewInitGrid("grdPAArea2", d);
		pp_grid2.setImagePath("${root}${HTML_IMG_DIR}");
		pp_grid2.setIconPath("${root}${HTML_IMG_DIR}");
		pp_grid2.setColumnHidden(5, true);
		fnSetColType(pp_grid2, 4, "img");
		fnSetColType(pp_grid2, 12, "img");
		pp_grid2.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect2(id,ind);});
	}
	
	function setPGridData2(){
		var result = new Object();
		result.title = "${title}";
		result.key = "custom_SQL.zhdhi_selectValidateItemListFromModel";
		result.header = "${menu.LN00024},${menu.LN00106},${menu.LN00028},${menu.LN00178},${menu.LN00179},OjbectID,${menu.LN00033},${menu.LN00027},${menu.LN00004},${menu.LN00070},ItemBlocked,MTCategory,${menu.LN00125},IsPublic,ItemAuthorID,ModelBlocked,ModelTypeName,URL,ChangeSetID,ModelID,LockOwner";
		result.cols = "Identifier|Name|KBN|VrfctnLink|ItemID|MTCName|StatusName|UserName|LastUpdated|ItemBlocked|MTCategory|BtnControl|IsPublic|ItemAuthorID|ModelBlocked|ModelTypeName|URL|ChangeSetID|ModelID|LockOwner";
		result.widths = "30,100,290,80,80,80,80,80,80,80,0,0,80,0,0,0,0,0,0,0,0";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "ItemID=${ItemID}&ModelID=${ModelID}&&languageID=${sessionScope.loginInfo.sessionCurrLangType}&ModelTypeCode=${ModelTypeCode}&InboundChks=${InboundChks}&userId="+userId+"&authLev="+authLev;
		return result;
	}
	
	function gridOnRowSelect2(id, ind){
		var ItemID = pp_grid2.cells(id, 5).getValue();
		var modelName = pp_grid2.cells(id, 2).getValue();
		var ItemBlocked = pp_grid2.cells(id, 10).getValue();
		var MTCategory = pp_grid2.cells(id, 11).getValue();				
		var ModelIsPublic = pp_grid2.cells(id, 13).getValue();
		var itemAthId = pp_grid2.cells(id, 14).getValue();
		var modelBlocked = pp_grid2.cells(id, 15).getValue();
		var modelTypeName = pp_grid2.cells(id, 16).getValue();
		var menuUrl = pp_grid2.cells(id, 17).getValue();
		var changeSetID = pp_grid2.cells(id, 18).getValue();
		var ModelID = pp_grid2.cells(id, 19).getValue();
		var LockOwner = pp_grid2.cells(id, 20).getValue();
		var scrnType = "";
		var myItem = "";
		if(itemAthId == userId || LockOwner == userId || "1" == authLev){
			myItem = "Y";
		}
		if(ind == 12){
			if(MTCategory == "VER" || ItemBlocked != "0"){// 카테고리가 vsersion 이면 model viewr open		
			   scrnType =  "view";
			}else{	
				if(ModelIsPublic == 1){
					scrnType = "edit";					
				} else{
					if((itemAthId == userId || "${sessionScope.loginInfo.sessionUserId}" == userId) && modelBlocked == "0"&& myItem == 'Y'){ 
						scrnType = "edit";	
					} else{
						scrnType = "view";
					}
				}
			}
			var url = "popupMasterMdlEdt.do?"
					+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&s_itemID="+ItemID
					+"&modelID="+ModelID
					+"&scrnType="+scrnType
					+"&MTCategory="+MTCategory
					+"&modelName="+encodeURIComponent(modelName)
				    +"&modelTypeName="+encodeURIComponent(modelTypeName)
					+"&menuUrl="+menuUrl
					+"&changeSetID="+changeSetID
					+"&selectedTreeID="+ItemID;
			var w = 1200;
			var h = 900;
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		} else{
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+ItemID+"&scrnType=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,ItemID);
		}
	}
	
	function doPSearchList2(){
		var d = setPGridData2();
		fnLoadDhtmlxGridJson(pp_grid2, d.key, d.cols, d.data, false);
	}	
	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body style="width:100%;">
<form name="symbolFrm" id="symbolFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" name="SymTypeCode" id="SymTypeCode" >
	<input type="hidden" name="ModelID" id="ModelID" value="${ModelID}" >
	<input type="hidden" name="ItemID" id="ItemID" value="${ItemID}" >
</form>	

	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00127}</p>
	</div>
	 <div style="border-top:1px solid #ccc;padding:10px;font-weight:bold;"> Outbound check </div>
	<div id="gridMLDiv" class="mgB10 clear">
    <div id="grdPAArea" style="width:100%;height:242px;"></div>	
    </div>
    <div class="countList" >
        <li>&nbsp;&nbsp;Number of validation checks : <span>${TotalCnt}</span> , Consistent : <span id="Consistent">${Consistent}</span> , Inconsistent : <span id="Inconsistent">${InConsistent}</span></li>
        <li class="floatR">&nbsp;</li>
    </div>
    <div id="gridMLDiv" class="mgB10 clear">
     <div style="border-top:1px solid #ccc;padding:10px;font-weight:bold;">Inbound check </div>
     <div id="grdPAArea2" style="width:100%;height:242px;"></div>
     </div>
	 <div class="countList">
        <li>&nbsp;&nbsp;Number of validation checks : <span>${TotalCnt2}</span> , Consistent : <span id="Consistent2">${Consistent2}</span> , Inconsistent : <span id="Inconsistent2">${InConsistent2}</span></li>
        <li class="floatR">&nbsp;</li>
    </div>
   	
</body>
</html>