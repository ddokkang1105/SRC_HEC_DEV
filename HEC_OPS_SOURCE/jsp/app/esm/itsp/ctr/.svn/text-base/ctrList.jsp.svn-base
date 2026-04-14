<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

  
<script type="text/javascript">
	var p_gridArea;					
	var srID ="${srID}";
	var scrID ="${scrID}";
	$(document).ready(function() {	

		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 570)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 570)+"px;");
		};

		$("#excel").click(function(){p_gridArea.toExcel("${root}excelGenerate");});		

		$('.layout').click(function(){
			var changeLayout = $(this).attr('alt');
			setLayout(changeLayout);
		});
					
		gridctrInit();
		doSearchctrList();
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	
	/* CTS List */
	function gridctrInit(){
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnPjtRowSelect(id,ind);});		
		//p_gridArea.enablePaging(true,10,10,"pagingArea",true,"recInfoArea");
		//p_gridArea.setPagingSkin("bricks");
		//p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setGridData(){
		var result = new Object();		
		result.title   = "${title}";
		result.key     = "ctr_SQL.getCTRMst";
		result.header  = "${menu.LN00024},ctrID,CTS No.,${sysArea1LabelNM},${sysArea2LabelNM},상태,긴급,요청자,요청일,검토자,검토일,승인자,승인일,승인상태,실행자,실행일,IF"; 
		result.cols    = "ctrID|ctrCode|sysArea1NM|sysArea2NM|statusNM|urgencyYN|regTName|regDT|reviewerTName|reviewDT|approverTName|approvalDT|aprvStatusNM|CTUserNM2|CTExeDT|ifStatus";
		result.widths  = "35,0,120,85,85,70,40,125,100,125,100,125,100,70,125,100,70";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns  = "center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data    = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					     + "&srID="+srID
					     + "&scrID="+scrID;
		return result;
	}
	
	
	/* List 조회 */
	function doSearchctrList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data,false,"N");	
		//fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	/* 상세 조회 */
	function gridOnPjtRowSelect(id, ind){
		var ctrID = p_gridArea.cells(id, 1).getValue();
	    fnOpenctrDetailPopup(ctrID);	
	}
	
	/* CTS 신규 화면 */
	function fnOpenctrNewPopup() {
		var url = "registerCTR.do?srID="+srID+"&scrID="+scrID;
	    window.open(url,'ctsNew','width=850, height=615, left=300, top=100,scrollbars=yes,resizable=yes');
	}
	
	/* CTS 상세 화면 */
	function fnOpenctrDetailPopup(ctrID) {
	    var url = "ctrDetail.do?ctrID="+ctrID;
	    window.open(url,'ctrDetail','width=850, height=750, left=300, top=150,scrollbars=yes,resizable=yes');
	}


	/* Excel Download */
	function fnDownloadExcel() {	
		p_gridArea.setColumnHidden(8, false);
		p_gridArea.toExcel("${root}excelGenerate");
		p_gridArea.setColumnHidden(8, true);
	}
	
</script>

</head>

<form name="changeReqListFrm" id="changeReqListFrm" action="#" method="post" onsubmit="return false;" >	

	</div>
	<div style="overflow:auto;overflow-x:hidden;">
		<div class="countList">
		    <li class="count">Total  <span id="TOT_CNT"></span></li>
			<div class="floatR mgR10">
			
			<c:if test="${scrInfo.Status eq 'APREL' && scrInfo.FinTestYN ne 'Y' && scrInfo.RegUserID eq sessionScope.loginInfo.sessionUserId}" >	
			&nbsp;<span id="btnAdd"  class="btn_pack small icon"> <span class="add"></span><input value="Create CTS" type="submit" onclick="fnOpenctrNewPopup()"></span>
			</c:if>	
		  	<c:if test="${(scrInfo.Status eq 'TSCMP' or scrInfo.Status eq 'CTR') && scrInfo.RegUserID eq sessionScope.loginInfo.sessionUserId}" >	
				&nbsp;<span id="btnAdd"  class="btn_pack small icon"> <span class="add"></span><input value="Create CTS" type="submit" onclick="fnOpenctrNewPopup()"></span>
			</c:if>
			</div>
		</div>
		<div id="gridDiv" class="mgB10 clear" style="align:center">
			<div id="grdGridArea" style="width:100%;"></div>
		</div>
</form>
