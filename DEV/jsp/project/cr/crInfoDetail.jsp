<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>


<script type="text/javascript">
	var chkReadOnly = true;
</script>
<!-- script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script-->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>


<script type="text/javascript">
	
	$(document).ready(function(){
		
		
	});
	
	//================================================================================================================================================
	
	// [List]
	function goBack() {
		var url = "crList.do";
		var data = "crMode=${crMode}&srType=ITSP&screenType=${screenType}&projectID=${refID}&csrID=${csrID}"
			+ "&crArea1=${crArea1}"
			+ "&crArea2=${crArea2}"
			+ "&requestUser=${requestUser}"
			+ "&crStatus=${crStatus}"
			+ "&DUE_DT=${DUE_DT}"
			+ "&completionDT=${completionDT}"
			+ "&receiptTeam=${receiptTeam}"
			+ "&receiptUser=${receiptUser}"
			+ "&subject=${subject}";
			
		var target = "help_content";
		if("${crMode}"=="CSR"){ target = "tabFrame"; }
		ajaxPage(url, data, target);
	}
	
	// [Edit]
	function goEdit() {
		// Cr 편집 화면으로 이동
		var url = "addNewCr.do"; // 변경 오더 등록 화면
		var data = "crMode=${crMode}&isCrEdit=Y"
				+ "&crID=${getMap.CRID}"
				+ "&currPageI=${currPageI}"
				+ "&ParentID=${ParentID}"
				+ "&screenType=${screenType}";
		var target = "help_content"; if("${screenType}"=="CSR"){ target = "tabFrame"; }
		ajaxPage(url, data, target);
	}
	
	function fnWithdrawCR() {
		var url = "saveNewCr.do"; 
		var data =  "crMode=${crMode}"
				+ "&crID=${getMap.CRID}"
				+ "&currPageI=${currPageI}"
				+ "&status=WTR"
				+ "&ITSMIF=${getMap.ITSMIF}"
				+ "&receiptID=${getMap.ReceiptUserID}";
		var target = "saveFrame";
		ajaxPage(url, data, target);	
	}
	
	function fnOpenViewSR(srID){
		var w = 1200;
		var h = 714; 		
		var url = "viewSRIframe.do?screenType=CR&srID="+srID+"&srType=ITSP&isPopup=Y";		
		itmInfoPopup(url,w,h);
	}
		
</script>
</head>
<body>

<div id="viewCRDIV" style="width:99%;height:100%;margin:auto;overflow-y:auto"> 
 <form name="crInfoDetailFrm" id="crInfoDetailFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
	
<c:if test="${crMode != 'CSR' && crMode != 'ITM' }" >	
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 0 0 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;CR 조회</h3>
	</div>	
</c:if>	
	
	<div id="objectInfoDiv" class="hidden floatC" style="width:100%;overflow-x:hidden;overflow-y:auto;">	
	<div style="height:5px"></div>	* CR 요청 내용	
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;">
			<colgroup>
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
			</colgroup>
		
			<tr>		
				<!-- CRCode -->
				<th class=" alignL pdL10">CR No.</th>
				<td class="alignL pdL10 last">${getMap.CRCode}</td>	      	
		      
				<!-- 요청자  -->
				<th class=" alignL pdL10">${menu.LN00025}</th>
				<td class=" alignL pdL10">${getMap.RegUserName}(${getMap.RegTeamName})</td>
				
				<!-- 상태  -->
				<th class=" alignL pdL10">${menu.LN00027}</th>
				<td class=" alignL pdL10">${getMap.StatusNM}</td>
				
				<!-- 요청일  -->
				<th class=" alignL pdL10">${menu.LN00093}</th>
				<td class=" alignL pdL10 last">${getMap.RegDT}</td>
				
			</tr>
			
		    <tr>
		    	<!-- 도메인  -->
		    	<th class=" alignL pdL10">${menu.LN00274}</th>
				<td class=" alignL pdL10">${getMap.CRArea1NM}</td>		
				<!-- 시스템  -->
		    	<th class=" alignL pdL10">${menu.LN00185}</th>
				<td class=" alignL pdL10">${getMap.CRArea2NM}</td>					
				<!-- 우선순위  -->
				<th class=" alignL pdL10">${menu.LN00067}</th>
				<td class=" alignL pdL10">${getMap.PriorityNM}</td> 
				<!-- 완료요청일-->
				<th class=" alignL pdL10">${menu.LN00222}</th>
				<td class="alignL pdL10 last">${getMap.ReqDueDate}</td>
			</tr>
			 <tr>
				<!-- 제목  -->
				<th class="alignL pdL10">${menu.LN00002}</th>
				<td class="alignL pdL10 " colspan="5">
					${getMap.Subject}
				</td>
			 	<!-- CSR No -->
		       	<th class=" alignL pdL10">SR No.</th>
		        <td class=" alignL pdL10 last"><span style="color:blue;cursor:pointer;" OnClick="fnOpenViewSR(${getMap.SRID});">${getMap.SRCode}</span></td>	  
			</tr>
			<!-- 개요 -->			
			<tr>
				<th class="alignL pdL10" style="height:120px;">${menu.LN00035}</th>
				<td colspan="7" class="last alignL pdL10" valign="Top" >${getMap.Description}</td>
			</tr><br>
		</table>
		<div style="height:5px"></div>
	* CR 처리 현황	
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
			</colgroup>	
			<tr>
				<!-- ITSM  -->
				<th class="alignL pdL10">ITSM</th>
				<td class="alignL pdL10">${getMap.ITSMNM}</td>
				
				<!-- 선/후행  -->
				<th class="alignL pdL10">${menu.LN00178}</th>
				<td class="alignL pdL10">${getMap.ProcOptionNM}</td>
				
				<!-- 접수조직  -->
				<th class="alignL pdL10">${menu.LN00227}</th>
				<td class="alignL pdL10">${getMap.ReceiptTeamName}</td>
				
				<!-- 접수담당자  -->
				<th class="alignL pdL10">${menu.LN00219}</th>
				<td class="alignL pdL10 last">${getMap.ReceiptName}</td>
			
			</tr>
			<tr>
				<!-- 접수일  -->
				<th class="alignL pdL10">${menu.LN00077}</th>
				<td class="alignL pdL10">${getMap.ReceiptDT}</td>	
									
				<!-- 완료예정일 -->
				<th class="alignL pdL10">${menu.LN00221}</th>
				<td class="alignL pdL10 ">${getMap.DueDate}
				</td>		
				
				<!-- 완료일 -->
				<th class="alignL pdL10">${menu.LN00064}</th>
				<td class="alignL pdL10 ">${getMap.CompletionDT}
				
				<!-- 담당자  -->
				<th class="alignL pdL10">${menu.LN00004}</th>
				<td class="alignL pdL10 last">${getMap.ProcessorName}</td>		
				</td>
			</tr>
			<!-- Comments -->			
			<tr>
				<th class="alignL pdL10">${menu.LN00228}</th>
				<td colspan="7"  class="alignL pdL10 last" style="width:100%;height:150px;">${getMap.Comment}
				</td>
			</tr>		
			<tr>
				<th class="alignL pdL10">${menu.LN00136}</th>
				<td colspan="7"  class="alignL pdL10 last" style="width:100%;height:150px;">${getMap.ChangeNotice}
				</td>
			</tr>		
	       <tr>
	       	<td colspan="8" class="alignR pdR20 last" bgcolor="#f9f9f9">   
	            <c:if test="${isPopup != 'Y'}" ><span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" onclick="goBack()"></span> </c:if>
				<c:if test="${isPopup != 'Y' && getMap.Status != 'CLS' && getMap.Status != 'WTR' && getMap.RegUserID == sessionScope.loginInfo.sessionUserId}" >
	         	  &nbsp;<span id="btnDel" class="btn_pack small icon"><span class="del"></span><input value="Withdraw" type="submit" onclick="fnWithdrawCR()"></span>       		
      			</c:if>
      		</td>
      	</tr>
     </table>		
	</div>	
  </form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</body>
</html>
