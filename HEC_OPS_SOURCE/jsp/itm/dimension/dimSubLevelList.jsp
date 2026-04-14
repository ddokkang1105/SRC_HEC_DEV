<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00024" var="WM00024"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	var p_gridArea2;
	var skin = "dhx_skyblue";
	var dp;
	
	$(document).ready(function() {
		// 초기 표시 화면 크기 조정 

		$("#grdGridArea2").attr("style","height:"+(setWindowHeight() - 330)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea2").attr("style","height:"+(setWindowHeight() - 330)+"px;");
		}
		gridInit();
		doSearchList();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");		
		//p_gridArea.setColumnHidden(0, true);	
		p_gridArea.setColumnHidden(4,true);
		p_gridArea.setColumnHidden(5,true);
		p_gridArea.setColumnHidden(6,true);
		p_gridArea.setColumnHidden(7,true);
		fnSetColType(p_gridArea, 1, "ch");//ra : radio		
		fnSetColType(p_gridArea, 8, "img");
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
				
		dp = new dataProcessor("saveDimSubLevelGridData.do"); // lock feed url
		dp.enableDebug(true);
		//dp.enableDataNames(true); // will use names instead of indexes
		dp.setTransactionMode("POST",true); // set mode as send-all-by-post
		dp.setUpdateMode("off"); // disable auto-update
		
		dp.init(p_gridArea); // link dataprocessor to the grid  
		dp.attachEvent("onAfterUpdate", function(){});
	}	

	function gridOnRowSelect(id, ind){ 		
		if(ind == 8){
			grid2Init(p_gridArea.cells(id, 4).getValue());
			doSetGrid2(p_gridArea.cells(id, 4).getValue());
		}
	}
	
	function fnAfterUpdateSendData(){
		alert("${WM00067}");
		gridInit();
		doSearchList();
	}

	function fnSaveGridData(){
		dp.sendData(); 
	}
	
	function setGridData(){		
		var result = new Object();
		result.title = "${title}";
		result.key = "dim_SQL.selectDimSubLevelList";
		result.header = "No,#master_checkbox,Code,Value,BeforeCode,TypeID,ParentID,SCount,Con Item";	//5
		result.cols = "CHK|DimValueID|Name|DimValueID|DimTypeID|ParentID|SCount|ConItemImg";
		result.widths = "50,50,250,200,10,10,10,10,50";
		result.sorting = "str,str,str,str,str,str,str,int,str";
		result.types = "ro,ro,ed,ed,ed,ed,ed,ro,img";
		result.aligns = "center,center,center,center,center,center,center,center,center";
		result.data = "dimTypeID=${dimTypeID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&dimValueID=${dimValueID}";
		return result;
	}

	// END ::: GRID	
	//===============================================================================
	
	function delDim(){		
		if(p_gridArea.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");   
			alert("${WM00023}"); 		
		}else{			
			//if(confirm("선택된 항목을 삭제 하시겠습니까?")){		
			if(confirm("${CM00004}")){		
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");
				for(var i = 0 ; i < checkedRows.length; i++ ){
					if(p_gridArea.cells(checkedRows[i], 7).getValue() != '0'){					
						alert(p_gridArea.cells(checkedRows[i], 2).getValue()+ "${WM00024}");
						p_gridArea.cells(checkedRows[i], 1).setValue(0);
					}else{
						var url = "DelDimension.do";
						var data = "DimTypeID=${dimTypeID}&DimValueID="+p_gridArea.cells(checkedRows[i], 4).getValue()+"&loginID=${sessionScope.loginInfo.sessionUserId}";
						var target = "blankFrame";
						if(i+1 == checkedRows.length){data = data +"&FinalData=Final";}
						ajaxPage(url, data, target);
					}					
				}				
			}
		}
	}	
	function addClose(avg){
		grid2Init(avg);
		doSetGrid2(avg);
	}
	function doCallBack(){}
	// [Add popup] Close 이벤트
	function fnAddRowGrid(avg){
		p_gridArea.addRow(p_gridArea.uid(),[p_gridArea.getRowsNum()+1,'0','','','','${dimTypeID}','${dimValueID}','0']);
	}
	function grid2Init(avg){		
		var d = setGrid2Data(avg);		
		p_gridArea2 = fnNewInitGrid("grdGridArea2", d);
		p_gridArea2.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea2.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		fnSetColType(p_gridArea2, 1, "ch");
		fnSetColType(p_gridArea2, 2, "img");		
		p_gridArea2.setColumnHidden(10, true);	
		p_gridArea2.setColumnHidden(11, true);	
		p_gridArea2.setColumnHidden(12, true);
		p_gridArea2.setColumnHidden(13, true);
		p_gridArea2.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect2(id,ind);});
	}
	function setGrid2Data(avg){
		var result = new Object();
		result.title = "${menu.LN00007}";
		result.key = "dim_SQL.selectDimPertinentDetailList";  
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00016},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00013},${menu.LN00017},ItemID,SCOUNT"; //9
		result.cols = "CHK|ItemTypeImg|Identifier|ItemName|Path|ClassName|TeamName|OwnerTeamName|Name|LastUpdated|Version|ID|SCOUNT";
		result.widths = "30,30,50,70,150,*,90,80,80,80,80,50,0,0";
		result.sorting = "str,int,str,str,str,str,str,str,str,str,str,str,int";
		result.aligns = "center,center,center,center,left,left,left,center,center,center,center,center,center";
		result.data = "dimTypeID=${dimTypeID}&s_itemID="+avg+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;
	}
	
	function doSetGrid2(avg){
		$("#valueInsert").removeAttr('style', 'display: none');   
		var d = setGrid2Data(avg);
		fnLoadDhtmlxGridJson(p_gridArea2, d.key, d.cols, d.data);
	}

	function gridOnRowSelect2(id, ind){
		if(ind != 1){doDetail(p_gridArea2.cells(id, 12).getValue());}else{return false;}
	}
	function doDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
	}
	 

	function delSubDim(){
		if(p_gridArea2.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요."); 
			alert("${WM00023}");
		}else{
			//if(confirm("선택된 항목을 삭제 하시겠습니까?")){
			if(confirm("${CM00004}")){		
				var checkedRows = p_gridArea2.getCheckedRows(1).split(",");
				var dimTypeId ="${s_itemID}"; 
				var dimValueId =p_gridArea.cells(p_gridArea.getSelectedId(), 4).getValue();
				var items = "";
			    for(var i = 0 ; i < checkedRows.length; i++ ){
			    	if (items == "") {
			    		items = p_gridArea2.cells(checkedRows[i], 12).getValue();
					} else {
						items = items + "," + p_gridArea2.cells(checkedRows[i], 12).getValue();
					}
			    	
			     	p_gridArea2.deleteRow(checkedRows[i]);   					
				}
			    
			    var url = "DelSubDimension.do";
				var data = "items="+items+"&dimTypeId="+dimTypeId+"&dimValueId=" + dimValueId;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		}
	}
	
	function newDimensionChild(){		
		var url = "searchNewDimItemPop.do";
		var data = "dimTypeID=${dimTypeID}&dimValueID="+p_gridArea.cells(p_gridArea.getSelectedId(), 4).getValue();
		fnOpenLayerPopup(url,data,doCallBack,617,436);
		
	}
</script>
</head>
<body>
	<form name="dimList" id="dimList" action="#" method="post" onsubmit="return false;">
	</form>		
	<!-- BIGIN :: LIST_GRID -->
	<div class="child_search mgB10">
		<li class="floatL pdR20">
			Path :  ${dimValuePath}
		</li>
		<li class="floatR pdR20">
			&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" id="newButton"  onclick="fnAddRowGrid()"></span>&nbsp;
			&nbsp;<span class="btn_pack small icon"><span class="edit"></span><input value="Save" type="submit" id="newButton"  onclick="fnSaveGridData()"></span>&nbsp;
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delDim()"></span>
		</li>
	</div>
		
	<div id="gridDiv" class="mgB10">
		<div id="grdGridArea" style="height:250px; width:100%"></div>
	</div>
	
	<div id="valueInsert" class="child_search mgB10" style="display:none;">
		<li class="floatR pdR20">
			&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" id="newButton1"  onclick="newDimensionChild()" ></a></span>&nbsp;
				&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delSubDim()"></span>
		</li>
	</div>	
	
	<div id="gridDiv2" class="mgB10">
		<div id="grdGridArea2" style="width:100%"></div>
	</div>

	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	
</body>
</html>