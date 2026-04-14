<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="PlanStartDT"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="PlanEndDT"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="M/D"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="Subject"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_5" arguments="ChangeScope"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00014" var="WM00014_1" arguments="${menu.LN00061}" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00014" var="WM00014_2" arguments="${menu.LN00221}" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00132" var="WM00132" />


<script type="text/javascript">
	var esType = "${srInfo.ESType}"
	var srType = "${srInfo.SRType}"
	
	if(esType != '' && esType != null && esType !== undefined) srType = esType;
	var data = 'languageID=${sessionScope.loginInfo.sessionCurrLangType}&customerNo=${srInfo.ClientID}&srType=' + srType;
	
	$(document).ready(function(){	
		$("input.datePicker1").each(generateDatePicker);
		
		fnSelect('scrArea1', data, 'getESMSRArea1', '${srInfo.SRArea1}', 'Select', 'esm_SQL');
		fnGetSCRArea2("${srInfo.SRArea1}");
	});
	
	function fnGetSCRArea2(SCRArea1ID){
		fnSelect('scrArea2', data + "&parentID="+SCRArea1ID , 'getSrArea2', '${srInfo.SRArea2}', 'Select');
	}
	
	function fnSaveNewSCR() {
		var newProcPathID = "";
		if(confirm("${CM00001}")){	
			if(!fnCheckValidation()){return;}
			if( document.all("impAnalYN").checked == true){ $("#impAnalYN").val("Y"); }else{ $("#impAnalYN").val("N"); }
			//if( document.all("cmYN").checked == true){ $("#cmYN").val("Y"); }else{ $("#cmYN").val("N"); }
			//if( document.all("finTestChk").checked == true){ $("#finTestYN").val("Y"); }else{ $("#FinTestYN").val("N"); }			
			//if( document.all("CTRChk").checked == true){ 
			//	$("#CTRYN").val("Y"); 
			//}else{ $("#CTRYN").val("N"); }
			
			var url = "createSCRMst.do?srID=${srID}&srArea2=${srInfo.SRArea2}"
					+"&fixedPath=${srInfo.FixedPath}&srType=${srInfo.SRType}"
					+"&srCategory=${srInfo.Category}&speCode=${speCode}";
			ajaxSubmit(document.scrFrm, url, "saveFrame");
		}
	}
	
	function fnCheckValidation(){
		var isCheck = true;		
		var planStartDT = $("#planStartDT").val();
		var planEndDT = $("#planEndDT").val();
		var planManDay = $("#planManDay").val();
		var subject = $("#subject").val();
		var changeScope = $("#changeScope").val();
		if (typeof(tinyMCE) != "undefined"){
			changeScope =  tinyMCE.get('changeScope').getContent();
			$("#changeScope").val(changeScope);
		}
	
		//if(planStartDT == "" ){ alert("${WM00034_1}"); isCheck = false; return isCheck;}
		if(planEndDT == "" ){ alert("${WM00034_2}"); isCheck = false; return isCheck;}
		if(planManDay == ""){ alert("${WM00034_3}"); isCheck = false; return isCheck;}
		if(subject == ""){ alert("${WM00034_4}"); isCheck = false; return isCheck;}
		if(changeScope == ""){ alert("${WM00034_5}"); isCheck = false; return isCheck;}
	
		if(planStartDT != ""){
			var planStartDT = parseInt(planStartDT.replaceAll("-",""));
			var planEndDT = parseInt(planEndDT.replaceAll("-",""));
			var currDate = parseInt("${thisYmd}");
			
			if(planStartDT < currDate){
				alert("${WM00014_1}"); isCheck = false; return isCheck;
			} else if(planEndDT < currDate){
				alert("${WM00014_2}"); isCheck = false; return isCheck;
			} else if(planStartDT > planEndDT){
				alert("${WM00132}"); isCheck = false; return isCheck;
			}
		}
		return isCheck;
	}
	
	function fnCallBack(scrID){
		opener.fnViewScrDetail(scrID);
		self.close();
	}
	
	function fnSRDetail(){
		var scrnType = "";
		var isPopup = "Y";
		var srID = "${srID}";
		var url = "processItsp.do?scrnType=${scrnType}&srID="+srID+"&isPopup="+isPopup+"&srType=${srInfo.SRType}";
		window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
	}
	
</script>
</head>
<body>
<div id="scrDiv" style="padding: 0 10px 0 10px">
<form name="scrFrm" id="scrFrm" method="post" action="#" onsubmit="return false;">	
	<input type="hidden" id="finTestYN" name="finTestYN" />
	<input type="hidden" id="CTRYN" name="CTRYN" />
	<div class="cop_hdtitle pdB10">
		<span class="floatL" ><h3 class="floatL" style="padding: 6px 0 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;SCR ${menu.LN00128}</h3></span>
		<span class="floatR mgT10 mgB5 mgR10" >
			<span class="btn_pack medium icon"><span class="save"></span><input value="Submit" onclick="fnSaveNewSCR()" type="submit"></span>
		</span>
	</div><br><br>
	<div style="border-top:1px solid #ccc">	
	<div id="objectInfoDiv" class="hidden floatC">
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="15%">
				<col width="20%">
				<col width="15%">
				<col width="20%">
				<col width="15%">
				<col width="20%">
				<col width="15%">
				<col width="20%">
			</colgroup>
			<tr>						
				<th class="alignL pdL10 viewline">${menu.LN00061}</th> 
				<td>
					<input type="text" id="planStartDT" name="planStartDT" value="" class="text datePicker1" style="width: 120px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</td>
				
				<th class="alignL pdL10">${menu.LN00221}</th>
			    <td>
			    	<input type="text" id="planEndDT" name="planEndDT" value="${srInfo.DueDate.replaceAll('/','-')}" class="text datePicker1" style="width: 120px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			    </td>
			    
			    <th class="alignL pdL10">M/D</th>				  
			    <td><input type="text" class="text" id="planManDay" name="planManDay" value=""  style="ime-mode:active;width:100%;"  onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"/></td>	

				<th class="alignL pdL10">SR No.</th>
				<td class="last"><span OnClick="fnSRDetail();" style="font-weight:bold;color:blue;font-size:12px;cursor:pointer;">${srInfo.SRCode}</span></td>
			</tr>	
		 	<tr>
		 		<th class="alignL pdL10 viewline">영향도분석</th>				  
			    <td><input type="checkbox" id="impAnalYN" name="impAnalYN" ></td>		
			    				
		        <!-- <th class="alignL pdL10">형상관리</th>
		        <td><input type="checkbox" id="cmYN" name="cmYN" ></td> -->	
		        
		        <!-- 
		        	
				<th class="alignL pdL10">현업테스트</th>
		        <td><input type="checkbox" id="finTestChk" name="finTestChk" 
		        <c:set var="prop" value=""/>
		       <c:forEach var="i" items="${elmList}">
		       		<c:if test="${i.Identifier eq 'SPE009'}"><c:set var="prop" value="checked"/>
		       			<c:if test="${i.Dashed ne 1 }"><c:set var="prop" value="checked disabled"/></c:if> 
		       		</c:if>
		        </c:forEach>
		        <c:choose>
					<c:when test="${!empty prop}"><c:out value="${prop}" /></c:when>
					<c:otherwise>disabled</c:otherwise>
		        </c:choose>
		        >
		        </td>
				
				<th class="alignL pdL10">운영이관</th>
				<td><input type="checkbox" id="CTRChk" name="CTRChk" disabled
				<c:forEach var="i" items="${elmList}">	
		        	<c:if test="${i.Identifier eq 'SPE011'}">checked</c:if> 
		        </c:forEach>
		        >
		        </td>
		         -->
		        
		        <td class="last" colspan=8></td>
			</tr>
			<tr>
				<th class="alignL pdL10 viewline">${srInfo.SRArea1NM}</th>
				<td><select id="scrArea1" Name="scrArea1" OnChange="fnGetSCRArea2(this.value);" style="width:140px"></select></td>		
				<th class="alignL pdL10">${srInfo.SRArea2NM}</th>
				<td class="last alignL" colspan="5"><select id="scrArea2" Name="scrArea2" style="width:140px;"></select></td>
			</tr>
			<tr>
				<th class="alignL pdL10 viewline">${menu.LN00002}</th>
				<td class="last" colspan="7">
					<input type="text" class="text" id="subject" name="subject" value="${srInfo.Subject}" style="ime-mode:active;width:100%;" />
				</td>
			</tr>
			<tr>
		 		<th class="alignL pdL10 viewline">${menu.LN00290}</th>
				<td class="last" colspan="7" style="height:80px;" valign="Top"> 
					<divstyle="width:100%;height:160px;">
						<textarea class="tinymceText" id="changeScope" name="changeScope" >${srInfo.Description}</textarea>
					</div>
				</td>
			</tr>		
	 		<tr>
		 		<th class="alignL pdL10 viewline">업무할당</th>
				<td class="last" colspan="7" style="height:80px;" valign="Top"> 
					<textarea class="edit" id="jobDescription" name="jobDescription" style="width:100%;height:80px;"></textarea>
				</td>
			</tr>
			
			<tr>
		 		<th class="alignL pdL10 viewline">이슈사항</th>
				<td class="last" colspan="7" style="height:80px;" valign="Top"> 
					<textarea class="edit" id="scrIssue" name="scrIssue" style="width:100%;height:80px;"></textarea>
				</td>
			</tr>
  	</table>
	</div>
	</form>	
	</div>
	
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</body>
</html>