<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script>
	var p_gridArea;	
	var screenType = "${screenType}";
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		gridInit();
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
	
	function gridInit(){	
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");	
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});	
		p_gridArea.enablePaging(true,30,null,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		
		p_gridArea.setColumnHidden(8, true);
		p_gridArea.setColumnHidden(9, true);
		p_gridArea.setColumnHidden(10, true);
		p_gridArea.setColumnHidden(11, true);
		p_gridArea.setColumnHidden(12, true);
		p_gridArea.setColumnHidden(13, true);
		p_gridArea.setColumnHidden(14, true);
		p_gridArea.setColumnHidden(15, true);
		p_gridArea.setColumnHidden(16, true);
		p_gridArea.setColumnHidden(17, true);
		p_gridArea.setColumnHidden(18, true);
		
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	function setGridData(){
		var result = new Object();	
		var period = $('input[name="period"]:checked').val();
		result.title = "${title}";
		result.key = "wf_SQL.getWFInstList";
		result.header = "${menu.LN00024},${menu.LN00091},${menu.LN00134} No.,${menu.LN00002},${menu.LN00060},${menu.LN00104},${menu.LN00013},${menu.LN00065},ProjectID,WFID,StepInstID,ActorID,StepSeq,WFInstanceID,LastSeq,SRID,DocumentID,,";
		result.cols = "WFDocType|WFInstanceID|Subject|CreatorName|CreatorTeamNM|CreationTime|Status|ProjectID|WFID|StepInstID|ActorID|StepSeq|WFInstanceID|LastSeq|SRID|DocumentID|StatusCode|DocCategory";
		result.widths = "30,120,100,*,100,180,150,100,100,100,50,50,50,50,50,50,0,0";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,left,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&pageNum=" + $("#currPage").val()						
						+ "&wfStepID=${wfStepID}"
						+ "&period="+period
						+ "&beforeYmd=${beforeYmd}"
						+ "&thisYmd=${thisYmd}" 
						+ "&wfMode=${wfMode}"
						+ "&filter=${filter}"
						+ "&projectID=${projectID}";	
						
		if(screenType != "csrDtl"){
			result.data = result.data + "&actorID=${sessionScope.loginInfo.sessionUserId}";
		}
						//alert(result.data);
		return result;
	}
	
	function gridOnRowSelect(id, ind){	
		var status = p_gridArea.cells(id, 7).getValue();
		var projectID = p_gridArea.cells(id, 8).getValue();
		var wfID = p_gridArea.cells(id, 9).getValue();		
		var stepInstID = p_gridArea.cells(id, 10).getValue();
		var actorID = p_gridArea.cells(id, 11).getValue();
		var stepSeq = p_gridArea.cells(id, 12).getValue();
		var wfInstanceID = p_gridArea.cells(id, 13).getValue();
		var lastSeq = p_gridArea.cells(id, 14).getValue();
		var documentID = p_gridArea.cells(id,16).getValue();
		var statusCode = p_gridArea.cells(id,17).getValue();
		var docCategory = p_gridArea.cells(id,18).getValue();
		var url = "wfDocMgt.do?";
		var data = "projectID="+projectID+"&pageNum="+$("#currPage").val()
					+"&stepInstID="+stepInstID
					+"&actorID="+actorID
					+"&stepSeq="+stepSeq
					+"&wfInstanceID="+wfInstanceID
					+"&wfID="+wfID
					+"&documentID="+documentID
					+"&wfMode=${wfMode}"
					+"&screenType="+screenType
					+"&lastSeq="+lastSeq
					+"&srID="+documentID
					+"&docCategory="+docCategory
					+"&actionType=view";
					
		if(statusCode == "0") {

			url = "${wfURL}.do?";
			data += "&isPop=Y&isMulti=N&actionType=create&changeSetID="+documentID;
		}
		else if(statusCode == "1") {

			url = "${wfURL}.do?";
			data += "&isPop=Y&isMulti=N&actionType=view";
		}

		var w = 1200;
		var h = 650; 
		itmInfoPopup(url+data,w,h);
	}
	
    function doSearchList(){ 
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}

	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}
	
	// [Approval Request] click : 변경오더 조회 화면 일때
	function goApprovalPop() {
		var url = "getWFCategoryList.do?";
		var data = "isPop=Y";
				
		var w = 1200;
		var h = 550; 
		itmInfoPopup(url+data,w,h);
		
	}
	
	// [Approval Request] click : 변경오더 조회 화면 일때
	function goWfStepInfo(wfDocType,wfUrl,wfInstanceID) {
		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var url = wfUrl;
		var data = "isNew=Y&wfDocType="+wfDocType+"&isMulti=Y&isPop=Y&categoryCnt=1&wfInstanceID="+wfInstanceID;
				
		ajaxPage(url,data,"wfInstListDiv");
	}
	
	
</script>

<div id="wfInstListDiv">
<form name="wfIsntFrm" id="wfIstFrm" action="" method="post"  onsubmit="return false;">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<c:if test="${screenType !='csrDtl' }" >
   	<div class="cop_hdtitle mgB10 pdT10" style="border-bottom:1px solid #ccc">
		<h3><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp; ${title}</h3>
	</div>	
	</c:if>
	<div class="countList">
        <li class="count">Total  <span id="TOT_CNT"></span></li>   
      <li class="floatR pdR20"> 
			<input type="radio" id="all" name="period" value="0" checked OnClick="doSearchList();">&nbsp;All&nbsp;&nbsp;&nbsp;&nbsp; 
    		<input type="radio" id="week" name="period" value="1" OnClick="doSearchList();"> &nbsp;Last 1 week &nbsp;&nbsp;&nbsp;&nbsp;
    		<input type="radio" id="today" name="period" value="2" OnClick="doSearchList();"> &nbsp;Today&nbsp;&nbsp;  
	   	 </li>
    </div>   
	<div id="gridDiv" style="width:100%;" class="clear" >
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
</form>
</div>