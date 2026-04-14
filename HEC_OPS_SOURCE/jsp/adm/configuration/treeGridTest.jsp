<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/dhtmlx/dhtmlxgrid_treegrid.css'/>">
<script src="<c:url value='/cmm/js/dhtmlx/dhtmlxTreeGrid/codebase/dhtmlxtreegrid.js'/>" type="text/javascript" charset="utf-8"></script> 
<script src="<c:url value='/cmm/js/dhtmlx/dhtmlxDataProcessor/codebase/dhtmlxdataprocessor.js'/>" type="text/javascript" charset="utf-8"></script> 

<style type="text/css" media="screen">
 .row20px img{   height:11px;  }
 .row20px div img{  height:18px;  }
</style>


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">
	var ptg_gridArea;
	var dp;
	
	$(document).ready(function() {		
		// 초기 표시 화면 크기 조정 
		$("#grdPtgArea").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdPtgArea").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		};		
		//if(window.attachEvent){window.attachEvent("onresize",resizeLayout);}else{window.addEventListener("resize",resizeLayout, false);}
		var t;
		//$("#assignPrc").click(function(){assignProcess();});
		//$("#delPrc").click(function(){delProcess();});
		$("#excelPrc").click(function(){ptg_gridArea.toExcel("${root}excelGenerate");});
		setPtgGridList();
	});
	function resizeLayout(){window.clearTimeout(t);t=window.setTimeout(function(){setScreenResize();},200);}
	function setScreenResize(){var clientHeight=document.body.clientHeight; alert(clientHeight);}
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	//===============================================================================
	// BEGIN ::: GRID
	function setPtgGridList(){
		var treePData="${treeGridTestXml}";
	    ptg_gridArea = new dhtmlXGridObject('grdPtgArea');
	   // ptg_gridArea.selMultiRows = true;
	    ptg_gridArea.imgURL = "${root}${HTML_IMG_DIR_ITEM}/";
		ptg_gridArea.setHeader("#master_checkbox,PRE_TREE_ID,TREE_ID,TREE_NAME");
		ptg_gridArea.setInitWidths("30,180,180,300");
		ptg_gridArea.setColAlign("center,left,left,left");
		ptg_gridArea.setColTypes("ch,tree,ro,ro");
		ptg_gridArea.setColSorting("int,str,str,str");
		ptg_gridArea.setColumnHidden(3, true);
   	  	ptg_gridArea.init();
		ptg_gridArea.setSkin("dhx_web");
		
		ptg_gridArea.loadXMLString(treePData);
		ptg_gridArea.enableSmartXMLParsing(false);

		dp = new dataProcessor("saveTreeGridData.do"); // lock feed url
		dp.enableDebug(true);
		//dp.enableDataNames(true); // will use names instead of indexes
		dp.setTransactionMode("POST",true); // set mode as send-all-by-post
		dp.setUpdateMode("off"); // disable auto-update
		
		dp.attachEvent("onAfterUpdateFinish", function(){
			alert("onAfterUpdateFinish");
			thisReload();
		});
		
		dp.init(ptg_gridArea); // link dataprocessor to the grid  
		dp.styles={
			updated:"font-style:italic; color:black;",
			inserted:"font-weight:bold; color:green;",
			deleted:"font-weight:bold; color:red;",
			invalid:"color:orange; text-decoration:underline;",
			error:"color:red; text-decoration:underline;",
			clear:"font-weight:normal;text-decoration:none;"
		};

	}
	
	function fnAfterUpdateSendData(){
		thisReload();
	}
	
	function setLoaingEndTreeGrid(){
		 ptg_gridArea.forEachRow(function(id){
			 var classCode=ptg_gridArea.cells(id, 9).getValue();if(classCode==""||classCode=="CL01005"){ptg_gridArea.cellById(id,0).setDisabled(true);}else{}
		 });
	}
	function ptgGridOnCheck(rId,cInd,state){
		if( state ){var classCode=ptg_gridArea.cells(rId, 9).getValue();
			if(classCode==""||classCode=="CL01005"){alert("${WM00046}");ptg_gridArea.cells(rId,0).setValue(0);}
			else{var itemID=ptg_gridArea.cells(rId, 8).getValue();
				if(itemID==""||itemID==undefined){var subitems=ptg_gridArea.getSubItems(rId).split(",");for(var i=0;i<subitems.length;i++){ptg_gridArea.cells(subitems[i],0).setValue(1);}}
			}
		}else{if(itemID==""||itemID==undefined){var subitems=ptg_gridArea.getSubItems(rId).split(",");for(var i=0;i<subitems.length;i++){ptg_gridArea.cells(subitems[i],0).setValue(0);}}} 
	}
	function ptgGridOnRowSelect(id, ind){if(ind != 0){var itemID=ptg_gridArea.cells(id, 8).getValue();if(itemID==""||itemID==undefined){}else{doPtgDetail(itemID);}}}	
	function doPtgDetail(avg){
		/*
		var url    = "subMenu.do"; // 요청이 날라가는 주소
		var data   = "url=processChildMenu&languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}&parentID=${s_itemID}&subID="+avg; //파라미터들
		var target = "PPobjInfo";
		ajaxPage(url, data, target);
		*/
		
		//var url = "itemInfoPop.do?screenMode=pop&languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg;
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}	
	function doPPSearchList(){setPtgGridList();}
	function assignProcess(){	
		var url    = "pertinentListGrid.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}"; //파라미터들
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	function doCallBack(){
		//alert(1);
	}
	
	//[Assign] 이벤트 후 Reload
	function thisReload(){
		var url = "treeGridTest.do";
		var target = "processDIV";
		var data = "s_itemID=${s_itemID}&option=${option}&filter=${filter}&screenMode=${screenMode}"
				+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"; 
	 	ajaxPage(url, data, target);
	}
	
	function delProcess(){
		if(ptg_gridArea.getCheckedRows(0).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");	
			alert("${WM00023}");
		}else{
			/*
			//if(confirm("선택된 항목을 삭제하시겠습니까?")){
			if(confirm("${CM00004}")){
				var checkedRows = ptg_gridArea.getCheckedRows(0).split(",");
				for(var i = checkedRows.length-1 ; i >=0 ; i-- ){
					var itemID=ptg_gridArea.cells(checkedRows[i], 8).getValue();
					if(itemID==""||itemID==undefined){}
					else{var url = "DELCNItems.do";var data = "s_itemID=${s_itemID}&items="+itemID;var target = "blankFrame";ajaxPage(url, data, target);}	
					ptg_gridArea.deleteRow(checkedRows[i]);
				}				
			}*/
			
			//if(confirm("선택된 항목를 삭제하시겠습니까?")){
			if(confirm("${CM00004}")){
				var checkedRows = ptg_gridArea.getCheckedRows(0).split(",");
				var items = "";
				
				for(var i = checkedRows.length-1 ; i >=0 ; i-- ){
					var itemID=ptg_gridArea.cells(checkedRows[i], 8).getValue();
					if(itemID==""||itemID==undefined){}
					else{
						// 삭제 할 ITEMID의 문자열을 셋팅
						if (items == "") {
							items = itemID;
						} else {
							items = items + "," + itemID;
						}
					}
				}
				
				if (items != "") {
					var url = "DELCNItems.do"; 
					var data = "isOrg=Y&s_itemID=${s_itemID}&items="+items;
					var target = "blankFrame";
					ajaxPage(url, data, target);
				}
			}
		}	
	}
			
	function fnConnItemDocumentList(){	
		var url = "cxnItemFileList.do";
		var target = "processDIV";
		var data = "s_itemID=${s_itemID}&option=${option}&filter=${filter}&screenMode=${screenMode}&itemIDs=${itemIDs}"; 
				+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"; 
	 	ajaxPage(url, data, target);
	}
	
	function fnGetLevel(){
	
		var ids = ptg_gridArea.getAllRowIds();
		
		alert("ids :"+ids+" :::::::::::::> "+ptg_gridArea.getLevel(ptg_gridArea.getSelectedRowId()) );
		alert("ids :"+ids+" :::::::::::::> "+ptg_gridArea.getChildItemIdByIndex(ptg_gridArea.getSelectedRowId()) );
	}
	
	function fnMoveRowUp(){
		ptg_gridArea.moveRowUp(ptg_gridArea.getSelectedRowId());
	}
	
	function fnMoveRowDown(){
		ptg_gridArea.moveRowDown(ptg_gridArea.getSelectedRowId());
	}
	
	function fnSaveTreeGridData(){				
		var ids = ptg_gridArea.getAllRowIds().split(",");
		for(var i=0; i < ids.length; i++){
			dp.setUpdated(ids[i], true, "updated");
		}
		dp.sendData(); 
	}


</script>
<body>
<div id="processDIV">
	<div class="child_search" id="pertinentSearch">
		<ul>
			<li class="floatR pdR20" >
			&nbsp;<span class="btn_pack medium icon"><span class="list"></span><input value="save" type="submit" id="file" onclick="fnSaveTreeGridData();"></span>
			&nbsp;<span class="btn_pack medium icon"><span class="list"></span><input value="moveRowUp" type="submit" id="file" onclick="fnMoveRowUp();"></span>
			&nbsp;<span class="btn_pack medium icon"><span class="list"></span><input value="moveRowDown" type="submit" id="file" onclick="fnMoveRowDown();"></span>
			<!-- &nbsp;<span class="btn_pack medium icon"><span class="list"></span><input value="getLevel" type="submit" id="file" onclick="fnGetLevel();"></span> -->
			&nbsp;<span class="btn_pack medium icon"><span class="list"></span><input value="Documents" type="submit" id="file" onclick="fnConnItemDocumentList();"></span>
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excelPrc"></span>	
			</li>			
		</ul>
	</div>
	<div id="gridPtgDiv" class="mgB10 mgT5">
		<div id="grdPtgArea" style="width:100%;"></div>
	</div>
</div>
</body>
