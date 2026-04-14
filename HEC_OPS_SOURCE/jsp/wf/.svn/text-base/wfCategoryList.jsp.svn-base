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
	var categoryCnt = "${categoryCnt}";
	
	$(document).ready(function() {

		if(categoryCnt == "1") {
			var temp = $("#wfCategory option:eq(1)").val().split("/");
			window.opener.goWfStepInfo(temp[0],temp[1]+".do","${wfInstanceID}");
			
			self.close();
		}
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		$('#wfCategory').change(function(){
			var temp = $(this).val().split("/");
			
			if(temp != "" && temp != undefined)
				doSearchList(temp[0]); // 변경오더 option 셋팅
		});
		
		gridWFInit("");
		

	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	/* ChangeSet List */
	function gridWFInit(avg){
		var d = setGridCngtData(avg);
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setColumnHidden(7, true);
		p_gridArea.setColumnHidden(8, true);
		p_gridArea.setColumnHidden(9, true);

		
		p_gridArea.enablePaging(true,100,null,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){
			$("#currPageA").val(ind);
		});
	}
	
	function setGridCngtData(avg){
		var result = new Object();
		result.title = "${title}";

		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00106},${menu.LN00002},${menu.LN00004},${menu.LN00027},${menu.LN00013},${menu.LN00022},,,Project,Path";
		result.cols = "CHK|CODE|Subject|AuthorName|StatusName|CreationTime|ProjectID|ItemID|ChangeSetID|ProjectName|Path";
		result.widths = "30,30,100,400,80,80,80,30,30,30,130,200";
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center";
		
		if(avg == "CSR") {
			result.key = "wf_SQL.getWFCSRList";		
			p_gridArea.setColumnHidden(11, true);	
		}
		else if(avg == "CS") {
			result.key = "wf_SQL.getWFChangeSetList";
			p_gridArea.setColumnHidden(11, false);
		}
		
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&AuthorID=${sessionScope.loginInfo.sessionUserId}"
					+ "&status='CMP'" 
					+ "&pageNum=" + $("#currPageA").val();
		
		return result;
	}
	
	function doSearchList(avg){
		var d = setGridCngtData(avg);
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, false, "", "", "", "", "${WM00119}", 1000);
	}
	
	
	// [Approval Request] click : 변경오더 조회 화면 일때
	function goSetWfStepInfo() {
		var wfInfo = $("#wfCategory option:selected").val().split("/");
		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var items = "";
		var ids = "";
		var msg = "";
		var projectID = "";
		
		if(categoryCnt > 1) {
			var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
	
			
			for(var i = 0 ; i < checkedRows.length; i++ ){
				
				if (items == "") {
					items = p_gridArea.cells(checkedRows[i], 9).getValue();
					projectID = p_gridArea.cells(checkedRows[i], 7).getValue();
				} else {
					items = items + "," + p_gridArea.cells(checkedRows[i], 9).getValue();
				}
			}
		}
		
		var url = wfInfo[1]+".do?";
		
		var data = "isNew=Y&wfDocType="+wfInfo[0]+"&isMulti=Y&isPop=Y&wfDocumentIDs="+items+"&ProjectID="+projectID;
				
		var w = 1200;
		var h = 550; 
		ajaxPage(url,data,"createWFInstanceFrm");
		
	}
	
</script>

<form name="createWFInstanceFrm" id="createWFInstanceFrm" method="post" action="#" onsubmit="return false;">
<div>	
   	<input type="hidden" id="item" name="item" value=""></input>
	<input type="hidden" id="cngt" name="cngt" value=""></input> 
	<input type="hidden" id="pjtId" name="pjtId" value=""></input>
	<input type="hidden" id="pjtCreator" name="pjtCreator" value="${pjtCreator}"></input>
	<input type="hidden" id="currPageA" name="currPageA" value="${currPageA}"></input>
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3><img src="${root}${HTML_IMG_DIR}/bullet_blue.png"  id="subTitle_baisic">&nbsp;&nbsp;${menu.LN00243}</h3>		
	</div>
	<div style="height:10px"></div>	
	<table border="0" cellpadding="0" cellspacing="0" width="20%" class="tbl_blue01" id="search">
		<colgroup>
		    <col width="10%">
			<col width="90%">
	    </colgroup>
	    <tr>
	    	<!-- 프로젝트 -->
	       	<th class="alignL viewtop pdL10">문서 유형</th>
	        <td class="alignL viewtop pdL10"> 
	        	<select id="wfCategory" Name="wfCategory">
		           	<option value=''>Select</option>
		           	<c:forEach var="i" items="${categoryList}">
		               	<option value="${i.CODE}">${i.NAME}</option>
		           	</c:forEach>
		       	</select>
	       	</td>  
	    </tr>
	       	
    </table>
    
    <div class="countList pdT10">
	    <li class="count">Total  <span id="TOT_CNT"></span></li>
	    <li class="floatR" style="padding-right:5px;">
	    	<span class="btn_pack medium icon"><span class="confirm"></span><input value="Approval Request" type="submit" onclick="goSetWfStepInfo();"></span>		
		</li>
 	</div>
	
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