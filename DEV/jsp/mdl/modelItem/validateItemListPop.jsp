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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>


<!-- 2. Script -->
<script type="text/javascript">
	//var pp_grid1;				//그리드 전역변수
	//var pp_grid2;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	var userId = "${sessionScope.loginInfo.sessionUserId}";
	var authLev = "${sessionScope.loginInfo.sessionAuthLev}";
	
	$(document).ready(function() {	

		doPSearchList();
		doPSearchList2();
	});	


	function doPSearchList(){
		let	sqlID = "model_SQL.selectValidateItemList";
		let param ="&ItemID=${ItemID}"
					+"&ModelID=${ModelID}"	
					+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&ModelTypeCode=${ModelTypeCode}"
					+"&userId="+userId+"&authLev="+authLev
					+"&sqlID="+sqlID;	
					
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
					 grid1.data.parse(result);
				 
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});	
	}
		
	

	function doPSearchList2(){
		let	sqlID = "model_SQL.selectValidateItemListFromModel";
		let param ="ItemID=${ItemID}&ModelID=${ModelID}&&languageID=${sessionScope.loginInfo.sessionCurrLangType}&ModelTypeCode=${ModelTypeCode}&InboundChks=${InboundChks}&userId="+userId+"&authLev="+authLev
					+"&sqlID="+sqlID;	
					
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
					 grid2.data.parse(result);
				 
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});	
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
   	
   	
<!-- dhtmlx9 ver upgrade -->

<script type="text/javascript">
 var layout = new dhx.Layout("grdPAArea", {
    rows: [
        {
            id: "a",
        },
    ]
}); 

	

var gridData1 = ${gridData1};
 var grid1 = new dhx.Grid(null, {
    columns: [
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { width: 100,id: "Identifier",  header: [{ text: "${menu.LN00106}", align: "center" }], align: "center" },
        { width: 290,id: "Name",         header: [{ text: "${menu.LN00028}", align: "center" }], align: "left" },
        { width: 80,id:"KBN",      header: [{ text: "${menu.LN00178}", align: "center" }], align: "left" },
        { width: 80,id: "VrfctnLink",  header: [{ text: "${menu.LN00179}", align: "center" }], htmlEnable: true, align: "center",
        	template: function (text, row, col) {
        		return '<img src="${root}${HTML_IMG_DIR}/'+row.VrfctnLink+'" width="18" height="18">';
            } 
        },
    
        
        { width: 80,id: "ObjectID",         header: [{ text: "OjbectID", align: "center" }], align: "center" },
        { width: 80, id: "MTCName",     header: [{ text: "${menu.LN00033}", align: "center" }], align: "left" },    // 80
        { width: 80, id: "StatusName",  header: [{ text: "${menu.LN00027}", align: "center" }], align: "left" },    // 80
        { width: 80, id: "UserName",    header: [{ text: "${menu.LN00060}", align: "center" }], align: "left" },    // 80
        { width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" }], align: "center" },  // 80

        { id: "ItemBlocked",   header: [{ text: "ItemBlocked",  align: "center" }], align: "center", hidden: true },
        { id: "MTCategory",    header: [{ text: "MTCategory",   align: "center" }], align: "left",   hidden: true },
        { width: 80, id: "BtnControl",  header: [{ text: "${menu.LN00125}", align: "center" }], htmlEnable:true,align: "center",
        	template:function (text, row, col) {
        		return '<img src="${root}${HTML_IMG_DIR}/'+row.BtnControl+'" width="55" height="24">';
        	}	
        },
        { id: "IsPublic",      header: [{ text: "IsPublic",      align: "center" }], align: "center", hidden: true },
        { id: "ItemAuthorID",  header: [{ text: "ItemAuthorID",  align: "center" }], align: "center", hidden: true },
        { id: "ModelBlocked",  header: [{ text: "ModelBlocked",  align: "center" }], align: "center", hidden: true },
        { id: "ModelTypeName", header: [{ text: "ModelTypeName", align: "center" }], align: "left",   hidden: true },
        { id: "URL",           header: [{ text: "URL",           align: "center" }], align: "left",   hidden: true },
        { id: "ChangeSetID",   header: [{ text: "ChangeSetID",   align: "center" }], align: "center", hidden: true },
        { id: "ObjectID",   header: [{ text: "ItemID",   align: "center" }], align: "center", hidden: true },
        { id: "ModelID",  header: [{ text: "ModelID",  align: "center" }], align: "center", hidden: true },
        { id: "LockOwner",header: [{ text: "LockOwner",align: "center" }], align: "center", hidden: true }

    ],

    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData1
});

layout.getCell("a").attach(grid1);



grid1.events.on("cellClick", function(row, column, e) {
    var projectId  = row.ProjectID;

   gridOnRowSelect(row, column);
    
});
  
	function gridOnRowSelect(row, col){
		var modelName = row.Name;
		var ItemBlocked = row.ItemBlocked;
		var MTCategory = row.MTCategory;				
		var ModelIsPublic = row.IsPublic;
		var itemAthId = row.ItemAuthorID;
		var modelBlocked = row.ModelBlocked;
		var modelTypeName = row.ModelTypeName;
		var menuUrl = row.URL;
		var changeSetID = row.ChangeSetID;
		var ItemID = row.ObjectID;
		var ModelID = row.ModelID;
		var LockOwner = row.LockOwner;
		var scrnType = "";
		var myItem = "";
		if(itemAthId == userId || LockOwner == userId || "1" == authLev){
			myItem = "Y";
		}
		if(col.id == "BtnControl"){
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

	

/* =======grid 2 =========================  */	
	var layout2 = new dhx.Layout("grdPAArea2", {
	    rows: [
	        {
	            id: "b",
	        },
	    ]
	}); 


	var gridData2 = ${gridData2};
	 var grid2 = new dhx.Grid(null, {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
	        { width: 100,id: "Identifier",  header: [{ text: "${menu.LN00106}", align: "center" }], align: "center" },
	        { width: 290,id: "Name",         header: [{ text: "${menu.LN00028}", align: "center" }], align: "left" },
	        { width: 80,id:"KBN",      header: [{ text: "${menu.LN00178}", align: "center" }], align: "left" },
	        { width: 80,id: "VrfctnLink",  header: [{ text: "${menu.LN00179}", align: "center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/'+row.VrfctnLink+'" width="18" height="18">';
	            } 
	        },
	        { width: 80,id: "ObjectID",         header: [{ text: "OjbectID", align: "center" }], align: "center" },
	        { width: 80, id: "MTCName",     header: [{ text: "${menu.LN00033}", align: "center" }], align: "left" },    // 80
	        { width: 80, id: "StatusName",  header: [{ text: "${menu.LN00027}", align: "center" }], align: "left" },    // 80
	        { width: 80, id: "UserName",    header: [{ text: "${menu.LN00060}", align: "center" }], align: "left" },    // 80
	        { width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" }], align: "center" },  // 80
	        { id: "ItemBlocked",   header: [{ text: "ItemBlocked",  align: "center" }], align: "center", hidden: true },
	        { id: "MTCategory",    header: [{ text: "MTCategory",   align: "center" }], align: "left",   hidden: true },
	        { width: 80, id: "BtnControl",  header: [{ text: "${menu.LN00125}", align: "center" }], htmlEnable:true,align: "center",
	        	template:function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/'+row.BtnControl+'" width="55" height="24">';
	        	}	
	        },
	        { id: "IsPublic",      header: [{ text: "IsPublic",      align: "center" }], align: "center", hidden: true },
	        { id: "ItemAuthorID",  header: [{ text: "ItemAuthorID",  align: "center" }], align: "center", hidden: true },
	        { id: "ModelBlocked",  header: [{ text: "ModelBlocked",  align: "center" }], align: "center", hidden: true },
	        { id: "ModelTypeName", header: [{ text: "ModelTypeName", align: "center" }], align: "left",   hidden: true },
	        { id: "URL",           header: [{ text: "URL",           align: "center" }], align: "left",   hidden: true },
	        { id: "ChangeSetID",   header: [{ text: "ChangeSetID",   align: "center" }], align: "center", hidden: true },
	        { id: "ObjectID",   header: [{ text: "ItemID",   align: "center" }], align: "center", hidden: true },
	        { id: "ModelID",  header: [{ text: "ModelID",  align: "center" }], align: "center", hidden: true },
	        { id: "LockOwner",header: [{ text: "LockOwner",align: "center" }], align: "center", hidden: true }

	    ],

	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData2
	});

	 layout2.getCell("b").attach(grid2);



	grid2.events.on("cellClick", function(row, column, e) {
	    var projectId  = row.ProjectID;

	   gridOnRowSelect2(row, column);
	    
	});

		function gridOnRowSelect2(row, col){
			var ItemID = row.ItemID;
			var modelName = row.Name;
			var ItemBlocked = row.ItemBlocked;
			var MTCategory = row.MTCategory;			
			var ModelIsPublic = row.IsPublic;
			var itemAthId = row.ItemAuthorID;
			var modelBlocked = row.ModelBlocked;
			var modelTypeName = row.ModelTypeName;
			var menuUrl = row.URL;
			var changeSetID = row.ChangeSetID;
			var ModelID = row.ModelID;
			var LockOwner =  row.LockOwner;
			var scrnType = "";
			var myItem = "";
			if(itemAthId == userId || LockOwner == userId || "1" == authLev){
				myItem = "Y";
			}
			if(col.id == "BtnControl"){
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
	
 
</script>
</body>
</html>