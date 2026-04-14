<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<c:url value="/" var="root"/>

<script type="text/javascript">
	var p_gridArea_wfStep;				//그리드 전역변수
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#grdWFStepInstArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdWFStepInstArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		};
		
		wfGridInit();
		doSearchWfStepList();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID

	function doSearchWfStepList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea_wfStep, d.key, d.cols, d.data, false, "Y");
	}

	//그리드 초기화
	function wfGridInit(){
		var d = setGridData();
		p_gridArea_wfStep = fnNewInitGrid("grdWFStepInstArea", d);
		p_gridArea_wfStep.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea_wfStep.setColumnHidden(7, true);		
		p_gridArea_wfStep.setColumnHidden(8, true);	
	}

	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "wf_SQL.getWfStepInstList";
		// No,역할, 담당자, 관리조직, 상태, 최종 수정일
		result.header = "${menu.LN00024},${menu.LN00004},${menu.LN00104},${menu.LN00120},${menu.LN00027},${menu.LN00075},Comment,StepInstID,WFID";
		result.cols = "ActorName|TeamName|WFStepName|StatusNM|ApprovalDate|Comment|StepInstID|WFID";
		result.widths = "50,150,*,100,150,150,360,0";
		result.sorting = "str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,left";
		result.data = "ProjectID=${ProjectID}&wfInstanceID=${wfInstanceID}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;
	}

	// END ::: GRID	
	//===============================================================================
	
	// [List] 버튼 이벤트
	function goBack(){
		var url = "newProjectInfoView.do";
		var data = "ProjectID=${ProjectID}&isNew=${isNew}&mainMenu=${mainMenu}&s_itemID=${s_itemID}" 
			+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}";
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
</script>


<div id="detailDiv" style="width:100%;overflow:auto; overflow-x:hidden; padding:0 0 17px 0;">
	<c:if test="${screenType != 'csrDtl' }" >
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 0">
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;${menu.LN00135}
		</h3>
	</div>
	
	<!-- Button area -->
	<table class="tbl_blue01 mgT10" style="table-layout:fixed;">
        <tr>
           <td class="alignR pdR20 last" bgcolor="#f9f9f9">	
           		&nbsp;<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goBack()" type="submit"></span>
           </td>
      	</tr>
   </table>
	</c:if>
	<!-- 변경 합의 / 승인 내역 -->
	<div id="gridPjtDiv" style="width:100%;" class="mgT10 mgB10 clear" >
		<div id="grdWFStepInstArea" style="width:100%;"></div>
	</div>



</div>
