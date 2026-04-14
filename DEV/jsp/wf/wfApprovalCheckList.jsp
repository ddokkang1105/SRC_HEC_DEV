<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>

<script type="text/javascript">
	var p_gridArea; //그리드 전역변수(ChangeSet)
	
	$(document).ready(function() {
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		};
		
		gridWFInit("${wfDocType}");

	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	/* ChangeSet List */
	function gridWFInit(avg){
		var d = setGridCngtData(avg);
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		

		
		p_gridArea.enablePaging(true,100,null,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){
			$("#currPageA").val(ind);
		});
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, false, "", "", "", "", "${WM00119}", 1000);
	}
	
	function setGridCngtData(avg){
		var result = new Object();
		result.title = "${title}";		


		if(avg == "CSR") {
			result.key = "wf_SQL.getWFCSRList";
		}
		else if(avg == "CS") {
			result.key = "wf_SQL.getWFChangeSetList";
		}
		result.header = "${menu.LN00024},${menu.LN00106},${menu.LN00002},${menu.LN00004},${menu.LN00027},${menu.LN00013}";
		result.cols = "CODE|Subject|AuthorName|StatusName|CreationTime";
		result.widths = "30,100,*,80,80,80";
		result.sorting = "int,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&pageNum=" + $("#currPageA").val() + "&projectID=${documentIDs}&changeSetID=${documentIDs}";
		
		return result;
	}
	
</script>

<form name="changeInfoLstTskFrm" id="changeInfoLstTskFrm" method="post" action="#" onsubmit="return false;">
<div>	
   	<input type="hidden" id="item" name="item" value=""></input>
	<input type="hidden" id="cngt" name="cngt" value=""></input> 
	<input type="hidden" id="pjtId" name="pjtId" value=""></input>
	<input type="hidden" id="pjtCreator" name="pjtCreator" value="${pjtCreator}"></input>
	<input type="hidden" id="currPageA" name="currPageA" value="${currPageA}"></input>
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3><img src="${root}${HTML_IMG_DIR}/bullet_blue.png"  id="subTitle_baisic">&nbsp;&nbsp;${menu.LN00205}</h3>		
	</div>
	<div style="height:10px"></div>		
    
	<!-- GRID -->	
	<div id="gridCngtDiv" style="width:100%;" class="clear">
		<div id="grdGridArea"></div>
	</div>
	
	<!-- END :: LIST_GRID -->
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->	
</div>
</form>

<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>