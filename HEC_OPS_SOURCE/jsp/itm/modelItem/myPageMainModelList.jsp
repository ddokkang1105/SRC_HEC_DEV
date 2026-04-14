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
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00020" var="WM00020"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00106" var="WM00106"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00033}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00032}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_3" arguments="referenceModel"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00112" var="WM00112"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/>


<script type="text/javascript">

	var p_gridArea;				//그리드 전역변수
	var userId = "${sessionScope.loginInfo.sessionUserId}";
	
	$(document).ready(function(){		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 170)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 170)+"px;");
		};
		
		$("#excel").click(function(){p_gridArea.toExcel("${root}excelGenerate");});
		$('#searchKey').change(function(){
			//$('input:text[id^=search]').each(function(){$(this).hide();});
			if($(this).val() != ''){$('#search' + $(this).val()).show();}
		});
		gridMLInit();		
		doSearchMLList();
		
		fnSelect('mtCategory', '', 'MTCTypeCode', '', 'Select');
		fnSelect('modelType', '', 'getMDLTypeCode', '', 'Select'); 
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID
	function doSearchMLList(){
		var d = setGridMLData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	function gridMLInit(){	
		var d = setGridMLData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");
		
		p_gridArea.setColumnHidden(1,true);
		p_gridArea.setColumnHidden(7,true);
		p_gridArea.setColumnHidden(8,true);
		p_gridArea.setColumnHidden(11, true);
		p_gridArea.setColumnHidden(13, true);
		p_gridArea.setColumnHidden(14, true);
		p_gridArea.setColumnHidden(15, true);
		p_gridArea.setColumnHidden(16, true);
		p_gridArea.setColumnHidden(17, true);
		
		p_gridArea.setColumnHidden(18, true);
		p_gridArea.setColumnHidden(19, true);
		p_gridArea.setColumnHidden(20, true);
		
		fnSetColType(p_gridArea, 1, "ch");//ra : radio
		
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridMLOnRowSelect(id,ind);});
		fnSetColType(p_gridArea, 12, "img");
		fnSetColType(p_gridArea, 14, "img");
		
		p_gridArea.enablePaging(true,20,10,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setGridMLData(){	
		var result = new Object();
		result.title = "${title}";
		result.key =  "model_SQL.getModelList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},${menu.LN00028},${menu.LN00032},${menu.LN00033},${menu.LN00027},${menu.LN00004},${menu.LN00013},${menu.LN00060},${menu.LN00070},ItemID,${menu.LN00125},Blocked,${menu.LN00031},${menu.LN00031},${menu.LN00027},IsPublic,ItemAuthorID,ItemBlocked,ItemStatus";
		result.cols = "CHK|ModelID|Name|ModelTypeName|MTCName|StatusName|Creator|CreationTime|UserName|LastUpdated|ItemID|BtnControl|Blocked|BtnControl|MTCategory|StatusCode|IsPublic|ItemAuthorID|ItemBlocked|ItemStatus";
		result.aligns = "center,center,center,left,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.widths = "30,30,80,*,130,100,100,80,100,100,80,70,70,70,70,70,70,70,70,70,70";
		result.sorting = "int,int,str,str,str,str,str,str,int,str,str,str,str,str,str,str,str,str,str,str,str";
		result.data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&userID=${sessionScope.loginInfo.sessionUserId}"					
			        + "&searchKey="     + $("#searchKey").val()
			        + "&searchValue="     	+ $("#searchValue").val();
					
					if( $("#modelType").val() != null){
						result.data = result.data + "&modelTypeCode=" + $("#modelType").val()
					}
					if( $("#mtCategory").val() != null){
						result.data = result.data + "&MTCategory=" + $("#mtCategory").val()
					}

		return result;
	}
	
	function gridMLOnRowSelect(id, ind){
		$("#newModel").attr('style', 'display: none');
		$("#divTabModelAdd").attr('style', 'display: none');
	
		var modelBlocked = p_gridArea.cells(id,13).getValue();
		var modelId = p_gridArea.cells(id, 2).getValue();
		var itemId = p_gridArea.cells(id, 11).getValue();
		var ItemTypeCode = $("#ItemTypeCode").val(); 
		var MTCategory = p_gridArea.cells(id,15).getValue();
		var ModelStatus= p_gridArea.cells(id,6).getValue();
		var Creator	= p_gridArea.cells(id,7).getValue();
		var CreationTime = p_gridArea.cells(id,8).getValue();
		var UserName = p_gridArea.cells(id,9).getValue();
		var LastUpdated = p_gridArea.cells(id,10).getValue();
		var modelName = p_gridArea.cells(id,3).getValue();
		var ModelStatusCode = p_gridArea.cells(id,16).getValue();
		var ModelTypeName = p_gridArea.cells(id,4).getValue();
		var ModelIsPublic = p_gridArea.cells(id,17).getValue(); 
		var itemBlocked = p_gridArea.cells(id,19).getValue(); 
		var itemAthId = p_gridArea.cells(id,18).getValue(); 
		var selectedItemStatus = p_gridArea.cells(id,20).getValue();
		
		if(ind == 12){ // 모델수정
			if(MTCategory == "VER" || itemBlocked != "0"){// 카테고리가 vsersion 이면 model viewr open		
				var url = "popupMasterMdlEdt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID="+itemId+"&s_itemID="+itemId+"&modelID="+modelId+"&scrnType=view&MTCategory="+MTCategory+"&modelName="+encodeURIComponent(modelName)+"&modelTypeName="+ModelTypeName;
				var w = 1200;
				var h = 900;
				//itmInfoPopup(url,w,h);	
				window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			}else{	
				if(ModelIsPublic == 1){
					var url = "popupMasterMdlEdt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID="+itemId+"&s_itemID="+itemId+"&modelID="+modelId+"&blocked="+itemBlocked+"&modelName="+encodeURIComponent(modelName)+"&modelTypeName="+ModelTypeName+"&scrnType=model";
					var w = 1200;
					var h = 900;
					//itmInfoPopup(url,w,h);
					window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
				} else{
					if(itemAthId == userId && modelBlocked == "0" || '${sessionScope.loginInfo.sessionMlvl}' == "SYS"){
						var url = "popupMasterMdlEdt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID="+itemId+"&s_itemID="+itemId+"&modelID="+modelId+"&blocked="+itemBlocked+"&modelName="+encodeURIComponent(modelName)+"&modelTypeName="+ModelTypeName+"&scrnType=model";
						var w = 1200;
						var h = 900;
						//itmInfoPopup(url,w,h);
						window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
					} else{
						 var url = "popupMasterMdlEdt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID="+itemId+"&s_itemID="+itemId+"&modelID="+modelId+"&scrnType=view&MTCategory="+MTCategory+"&modelName="+encodeURIComponent(modelName)+"&modelTypeName="+ModelTypeName;
						 var w = 1200;
						 var h = 900;
						 //itmInfoPopup(url,w,h);	
						 window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
					}
				}
				
			}
		}
		
		if(ind == 14){ // 속성수정			
			var setUrl = setUrl = "processModelMenu";	
			var s_itemID = modelId;
			
			if( itemBlocked == "0"){
				if(ModelIsPublic == 1 ){
					var url    = "subMenu.do?url="+setUrl+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&parentID=${s_itemID}&filter=${filter}&s_itemID="+s_itemID
					+"&modelBlocked="+modelBlocked+"&itemAthId="+itemAthId+"&blocked="+itemBlocked
					+"&screenType=modelBasicInfoPop&ItemTypeCode="+ItemTypeCode
					+"&MTCategory="+MTCategory+"&ModelStatus="+encodeURIComponent(ModelStatus)
					+"&Creator="+encodeURIComponent(Creator)+"&CreationTime="+CreationTime
					+"&UserName="+encodeURIComponent(UserName)+"&LastUpdated="+LastUpdated
					+"&ModelStatusCode="+ModelStatusCode+"&ModelTypeName="+ModelTypeName
					+"&modelName="+encodeURIComponent(modelName)+"&modelTypeName="+ModelTypeName;
	
				var w = 1200;
				var h = 500;
				window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
				
				}else{
						if(itemAthId == userId && modelBlocked == "0" || '${sessionScope.loginInfo.sessionMlvl}' == "SYS"){
							var url    = "subMenu.do?url="+setUrl+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
										+"&parentID=${s_itemID}&filter=${filter}&s_itemID="+s_itemID
										+"&modelBlocked="+modelBlocked+"&itemAthId="+itemAthId+"&blocked="+itemBlocked
										+"&screenType=modelBasicInfoPop&ItemTypeCode="+ItemTypeCode
										+"&MTCategory="+MTCategory+"&ModelStatus="+encodeURIComponent(ModelStatus)
										+"&Creator="+encodeURIComponent(Creator)+"&CreationTime="+CreationTime
										+"&UserName="+encodeURIComponent(UserName)+"&LastUpdated="+LastUpdated
										+"&ModelStatusCode="+ModelStatusCode+"&ModelTypeName="+ModelTypeName
										+"&modelName="+encodeURIComponent(modelName)+"&modelTypeName="+ModelTypeName;
							
							var w = 1200;
							var h = 500; 
							window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
							
						}else{
							alert("${WM00040}"); return;
						}
				}
			}else{
				if(selectedItemStatus == "REL") {
			         alert("${WM00120}"); // [변경 요청 안된 상태]
			    } else {
			         alert("${WM00050}"); // [승인요청중]
			    }
			}
		}
		if(ind != 12 && ind != 14){
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,itemId);
		}
	}
	
	function gridMLOnRowDblClicked(id){
		var itemId = p_gridArea.cells(id, 11).getValue();
		var modelId = p_gridArea.cells(id, 2).getValue();	
		//var url = "modelingPop.do?ItemID="+itemId+"&ModelID="+modelId+"&option="+$('#option').val();
		var url = "PopupModelDiagramMain.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID="+itemId+"&s_itemID="+itemId+"&modelID="+modelId+"&percentOfImage=100&getWidth=974&getCheck=0";
		var w = 1200;
		var h = 900;
		openPopup(url,w,h);
	}
		
</script>
</head>
<body>
	<form name="taskResultFrm" id="taskResultFrm" action="" method="post" onsubmit="return false">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp; ${menu.LN00058}	</h3>
	</div><div style="height:10px"></div>
	<div class="child_search">
		<li>
			${menu.LN00033}
	 	 	<select id="mtCategory" name="mtCategory" class="sel" style="width:150px;"></select>			
	   	</li>
		<li>
			${menu.LN00032}
	 	 	<select id="modelType" name="modelType" class="sel" style="width:150px;"></select>			
	   	</li>
	   	<li>
	 	 	<select id="searchKey" name="searchKey">
				<option value="Name">Name</option>
				<option value="ID" <c:if test="${!empty searchID}"> selected="selected" </c:if> >ID</option>
			</select>			
			<input type="text" class="text"  id="searchValue" name="searchValue" value="${searchValue}" style="width:150px;">
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchMLList()" value="검색">
	   	</li>
	</div>
	<div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR">&nbsp;</li>
     </div>
	<div id="gridDiv" class="mgB10 clear">
		<div id="grdGridArea" style="height: 340px; width: 100%"></div>
	</div>	
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->		
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body></html>