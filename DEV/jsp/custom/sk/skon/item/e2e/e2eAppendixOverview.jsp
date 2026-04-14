<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<!-- dhtmlx7  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<head>
<style>
	#itemDiv > div {
		padding : 0 10px;
	}
	.cont_title{
		border: 1px solid #dfdfdf;
	    border-bottom: 0;
	    padding: 5px 0px;
	    width: 20%;
	    text-align: center;
	    border-radius: 0 10px 0 0;
	}
	#refresh:hover {
		cursor:pointer;
	}
	.tdhidden{display:none;}
	#itemNameAndPath, #functions{
		display:inline;
   	 	line-height: 23px;
	}
	

 	.new {
		color:blue;
		font-weight:bold
	}
	.mod {
		color:orange;
		font-weight:bold
	}
	.remain{
	color:#000000;
	}

</style>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00059" var="CM00059" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00072" var="CM00072" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00073" var="CM00073" />

<script type="text/javascript">
	var chkReadOnly = true;	
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<script type="text/javascript">
const defSiteCode = "${defSiteCode}";
const defDimValueID ="${defDimValueID}";
var checkOutFlag = "N";
var scrnType="${scrnType}";

let itemListData = [];

$(document).ready(function(){	
	
		$("#appendix").attr("style","height:"+(setWindowHeight() - 185)+"px;");
	    // 화면 크기 조정
	    window.onresize = function() {
	      $("#appendix").attr("style","height:"+(setWindowHeight() - 185)+"px;");
	    };
	});
	

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}


	//edit버튼 클릭시
	function fnEditItemInfo() {
	 	var url = "processItemInfo.do";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/e2e/editAppendixInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
		+"&defSiteCode=${defSiteCode}"
		+"&wfOptopn=V"
		+"&defDimValueID=${defDimValueID}"
		+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		
		ajaxPage(url, data, "frontFrm"); 
	}
	
	//편집 저장후 콜백
	function fnCllbackEdit(itemID) {
		
	 	var url = "processItemInfo.do";
		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/e2e/editAppendixInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
		+"&defSiteCode="+defSiteCode
		+"&defDimValueID=${defDimValueID}"
		+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		
		ajaxPage(url, data, "frontFrm");
	}
	
	//HISTORY 클릭시
	function fnGoChangeMgt() {
		var url = "itemHistory.do";
		var target = "itemDescriptionDIV";
		var data = "s_itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myItem=${myItem}&itemStatus=${itemStatus}&backBtnYN=N";
		
		$("#itemDescriptionDIV").css('display','block');
		$("#itemDiv").css('display','none');
		ajaxPage(url, data, target);
	}
	
	//Standardmenu
		function fnChangeMenu(menuID,menuName) {
		
		itemOption = "N";

		if(menuID == "management"){
			parent.fnGetMenuUrl("${itemID}", "Y");			
		}
	}
	

	// Reload
		function fnMenuReload() {
		
	      		var url = "processItemInfo.do";
				var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V"
					+"&accMode=${accMode}&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
					+"&url=/custom/sk/skon/item/tsd/viewTSDInfo&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"
				
				ajaxPage(url, data, "frontFrm");
			}
			
	
	//Report
		function fnGoReportList() {
			var url = "objectReportList.do";
			var target = "itemDescriptionDIV";
			var accMode = $("#accMode").val();
			var data = "s_itemID=${itemID}&option=${option}&kbn=newItemInfo&accMode="+accMode; 
			$("#itemDescriptionDIV").css('display','block');
			$("#itemDiv").css('display','none');
			ajaxPage(url, data, target);
		}
		
	

	// callback - goApprovalPop
	function fnItemMenuReload() {
		fnEditItemInfo();

	}
	
	// check out 실행 함수 

	function fnQuickCheckOut(avg){
	
	
	   var defCSRID="${projectID}";
	   var changeType = avg;
	
		if(checkOutFlag == "N"){
		    dhx.confirm({
		    	text: "${CM00072}", // 개정을 시작하시겠습니까?
		        buttons: ["No", "Yes"],
		        css: "align-center"
		    }).then(function (result) {
		    	if(result){
					var url = "cngCheckOutPop.do?";
					var data = "changeType="+changeType+"&s_itemID=${itemID}&pjtIds="+defCSRID;
				 	var target = self;
				 	var option = "width=500px, height=350px, left=200, top=100,scrollbar=yes,resizble=0";
				 	window.open(url+data, 'CheckOut', option);
				 	checkOutFlag = "Y";
				}
		    });
		}
	}
	
	//Approval Request
	function goApprovalPop() {
				
		var url = "wfDocMgt.do?";
		var data="isPop=Y&changeSetID=${itemInfo.CurChangeSet}&isMulti=N&wfInstanceID=${itemInfo.WFInstanceID}&wfDocType=CS&ProjectID=${itemInfo.ProjectID}&docSubClass=${itemInfo.ClassCode}";
	
		var w = 1200;
		var h = 750; 
		itmInfoPopup(url+data,w,h);
	}
	
	// [Rework] click
	function rework() {
		if (confirm("${CM00059}")) {
			var url = "rework.do";
			var data = "item=${itemInfo.ItemID}&cngt=${itemInfo.CurChangeSet}&pjtId=${itemInfo.ProjectID}&defDimValueID=${defDimValueID}"; 
			
			$.ajax({
				url: url,
				type: 'post',
				data: data,
				async: true,
				success: function(data){
					fnItemMenuReload();
				}
			});
		}
	}
	
	// [결재 취소] click
	function withdrawAprvReq() {
		if (confirm("${CM00073}")) { // 결재 취소하시겠습니까?
			var url = "rework.do";
			var data = "item=${itemInfo.ItemID}&cngt=${itemInfo.CurChangeSet}&pjtId=${itemInfo.ProjectID}"; 
			
			$.ajax({
				url: url,
				type: 'post',
				data: data,
				async: true,
				success: function(data){
					fnItemMenuReload();
				}
			});
		}
	}
	
	
</script>
</head>
<body>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" enctype="multipart/form-data" onsubmit="return false;"> 
		<div id=htmlReport style="width:100%;overflow-y:auto;overflow-x:hidden;">
		<!-- 헤더값 -->
		<div id="itemDiv">

		<div id="mainprocess" class="mgB10" style="width:99%">
		<div id="process" class="mgB10">
			<div class="flex justify-between align-center pdT10 pdB10">
				<div class="flex align-center">
				<p class="cont_title mgB1">${menu.ZLN0026}</p> <!-- Appendix -->
				</div>
				<c:if test="${screenMode ne 'pop' && accMode ne 'OPS' && (itemInfo.AuthorID == sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionAuthLev eq '1')}" >
					<c:if test="${itemInfo.Blocked eq '0' && itemInfo.Status ne 'DEL1'}" >
						<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="button" onclick="fnEditItemInfo()"></span>
					</c:if>
				</c:if>
			</div>
	        <table class="tbl_preview mgB10">
	            <tbody>
	            	<tr>			
						<td>
							<textarea id="appendix" class="tinymceText" readonly="readonly">
							<div class="mceNonEditable">${attrMap.ZAT02025}</div>		
							</textarea>
						</td>
					</tr>
	            </tbody>
	        </table>    
	    </div>  
	    </div>  
	    </div>  
</div> 
</form>
</body>

<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
