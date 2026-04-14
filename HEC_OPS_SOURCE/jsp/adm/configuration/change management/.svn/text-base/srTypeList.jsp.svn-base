<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00148" var="WM00148" />

<!-- 2. Script -->
<script type="text/javascript">
	
	var OT_gridArea; //그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		// 초기 표시 화면 크기 조정
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		};
		
		$("#excel").click(function(){OT_gridArea.toExcel("${root}excelGenerate");});
		gridOTInit();
		doOTSearchList();
	});
	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit() {
		var d = setOTGridData();
		OT_gridArea = fnNewInitGrid("grdOTGridArea", d);
		OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		fnSetColType(OT_gridArea, 1, "ch");
		OT_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		OT_gridArea.attachEvent("onRowSelect", function(id, ind) { //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id, ind);
		});
		//OT_gridArea.setColumnHidden(7, true);
		OT_gridArea.setColumnHidden(8, true);
		OT_gridArea.setColumnHidden(9, true);
		OT_gridArea.setColumnHidden(10, true);
		OT_gridArea.setColumnHidden(11, true);
 		OT_gridArea.setColumnHidden(12, true); 
 		OT_gridArea.setColumnHidden(13, true); 
 		OT_gridArea.setColumnHidden(14, true); 
 		OT_gridArea.setColumnHidden(15, true); 
 		OT_gridArea.setColumnHidden(17, true); 
 		OT_gridArea.setColumnHidden(18, true); 
 		OT_gridArea.setColumnHidden(19, true); 
 		OT_gridArea.setColumnHidden(20, true); 
 		OT_gridArea.setColumnHidden(21, true); 
 		OT_gridArea.setColumnHidden(22, true); 
		//START - PAGING
		OT_gridArea.enablePaging(true,10,10,"pagingArea",true,"recInfoArea");
		OT_gridArea.setPagingSkin("bricks");
		OT_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		//END - PAGING
	}

	function setOTGridData() {
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getAllSRTypeList";
		result.header = "${menu.LN00024},#master_checkbox,Code,Name,${menu.LN00099},항목유형,Process Model,MenuID,VarFilter,PreFix,MaxSRLvl,Deactivated,${menu.LN00070},TS_DocCategory,ProcModelID,DocDomain,${menu.LN00088},DimTypeID,SRMstCnt,SRCatCnt,SRAreaCnt,ModelID,ItemID"; 
		result.cols = "CHK|SRTypeCode|SRTypeNM|DocCategory|ItemType|ProcModel|MenuID|VarFilter|Prefix|MaxSRAreaLvl|Deactivated|LastUpdated|TS_DocCategory|ProcModelID|DocDomain|Dimension|DimTypeID|SRMstCnt|SRCatCnt|SRAreaCnt|ModelID|ItemID";
		result.widths = "50,50,100,200,150,100,200,60,200,50,70,100,70,70,70,70,70,100,70,70,70,70";
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,left,left,left,left,center,left,center,center,center,center,center,center,center,left,center,center,center,center,center,center";
		result.data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";	
		if($("#SRTypeCode").val() != '' && $("#SRTypeCode").val() != null){
			result.data = result.data +"&SRTypeCode="+$("#SRTypeCode").val();
		}
		return result;

	}

	
	// END ::: GRID	
	//===============================================================================

	//조회
function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
}
 
//그리드ROW선택시
function gridOnRowOTSelect(id, ind){
	if(ind != 1 && ind != 6){
		var url = "srTypeDetail.do";
		var data = "&SRTypeCode="+ OT_gridArea.cells(id, 2).getValue() + 
				"&TS_DocCategory="+OT_gridArea.cells(id, 13).getValue()+
				"&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + 
				"&pageNum=" + $("#currPage").val()+
				"&viewType=E";				
		var target = "srTypeList";	
		ajaxPage(url,data,target);	
	}	
	if(ind == 6){
		var modelID = OT_gridArea.cells(id, 21).getValue()
		var s_itemID = OT_gridArea.cells(id, 22).getValue()
		
		var url = "popupMasterMdlEdt.do?"
				+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&s_itemID="+s_itemID
				+"&modelID="+modelID
				+"&scrnType=view";
		
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
}

function fnAddSRType(){
	var url = "srTypeDetail.do";
	var data = "&pageNum=" + $("#currPage").val() +"&viewType=N";				
	var target = "srTypeList";	
	ajaxPage(url,data,target);	
}

function fnDelSRType(){		
	if (OT_gridArea.getCheckedRows(1).length == 0) {
		alert("${WM00023}");
		return;
	}
	var cnt  = OT_gridArea.getRowsNum();
	var SRTypeCode = new Array;
	var j = 0;
	var chkVal;
	for ( var i = 0; i < cnt; i++) { 
		chkVal = OT_gridArea.cells2(i,1).getValue();
		if(chkVal == 1){					
			var SRMstCnt = OT_gridArea.cells2(i, 18).getValue();
			var SRCatCnt = OT_gridArea.cells2(i, 19).getValue();
			var SRAreaCnt = OT_gridArea.cells2(i, 20).getValue();
			if(SRMstCnt == 0 && SRCatCnt == 0 && SRAreaCnt == 0){
				SRTypeCode[j] = OT_gridArea.cells2(i, 2).getValue();
				j++;
			}else{
				alert(OT_gridArea.cells2(i, 2).getValue()+" ${WM00148}");
				return;
			}				
		}
	}	
	var url = "deleteSRType.do";
	var data = "&SRTypeCode="+SRTypeCode+"&pageNum=" + $("#currPage").val()+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";				
	var target = "saveDFrame";	
	ajaxPage(url,data,target);	
}

function fnCallBack(){
	doOTSearchList();
}
</script>
</head>
<body>
<div id="srTypeDiv">
	<form name="srTypeList" id="srTypeList" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input>
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;SR Type List</li>
		</ul>
	</div>	
	<div class="child_search01 mgL10 mgR10">
		<li class="floatR pdR10">
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit"  alt="New" onclick="fnAddSRType()" ></span>
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDelSRType()" ></span>
		</li>
	</div>
	<div class="countList pdL10">
		<li class="count">Total  <span id="TOT_CNT"></span></li>
		<li class="floatR">&nbsp;</li>
 	</div>
	<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
		<div id="grdOTGridArea" style="height:360px; width:100%"></div>
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
