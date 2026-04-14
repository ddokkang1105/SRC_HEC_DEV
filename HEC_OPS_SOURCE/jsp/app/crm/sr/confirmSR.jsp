<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<script type="text/javascript">
	
	function fnSaveSRPoint(){
		if(!confirm("${CM00001}")){ return;}
		var srPoint = getCheckedRadioVal();
		var opinion = $("#opinion").val();
		var url = "saveSRPoint.do";
		var data = "srID=${srID}&srPoint="+srPoint+"&opinion="+opinion;			
		var target = "comfirmSRDiv";
		ajaxPage(url, data, target);
	}
	
	function getCheckedRadioVal() {
		var radioObj = document.all('sPoint');
		var srPoint;
		if (radioObj.length == undefined) {
			if (radioObj.checked) {	srPoint = radioObj.value; }			
		} else {
			for (var i = 0; i < radioObj.length; i++) {
				if (radioObj[i].checked) { srPoint = radioObj[i].value;	}
			}
		}
		return srPoint;
	}
	
	function fnCallBack(){
		var screenType = "${screenType}";
		if(screenType == "EMAIL"){
			parent.window.close();
		}else{
			parent.opener.fnGoSRList();
			parent.self.close();
		}
	}
	
	/* 첨부문서 다운로드 */
	function FileDownload(checkboxName, isAll){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var seq = new Array();
		var j =0;
		var checkObj = document.all(checkboxName);
		
		// 모두 체크 처리를 해준다.
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = true;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = true;
			}
		}

		// 하나의 파일만 체크 되었을 경우
		if (checkObj.length == undefined) {
			if (checkObj.checked) {
				seq[0] = checkObj.value;
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				seq[j] = checkObj[i].value;
				j++;
			}
		}
		if(j==0){
			alert("${WM00049}");
			return;
		}
		j =0;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=SR";
		alert("url : "+url);
		ajaxSubmitNoAdd(document.comfirmSRFrm, url,"saveFrame");
		// 모두 체크 해제
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = false;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = false;
			}
		}
	}
	
	function fileNameClick(avg1){
		var seq = new Array()
		seq[0] = avg1;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=SR";
		ajaxSubmitNoAdd(document.comfirmSRFrm, url,"saveFrame");
	}	

	
</script>
</head>
<body>
<form name="comfirmSRFrm" id="comfirmSRFrm" method="post" action="#" onsubmit="return false;">	
<div id="comfirmSRDiv" style="padding: 0 6px 6px 6px; width:100%; height:700px; overflow:scroll;overflow-y;overflow-x:hidden;"> 
	<div class="cop_hdtitle pdL5 pd" style="border-bottom:1px solid #ccc">
		<h3>- ${menu.LN00285}</h3>
	</div>
	<div id="objectInfoDiv" class="hidden floatC" style="width:100%;overflow-x:hidden;overflow-y:auto;">
		<table class="tbl_brd mgT5 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="25%">
			<col>
		</colgroup>		
		
		<c:if test="${screenType=='EMAIL'}">
		<tr>
			<!-- 첨부문서 -->
			<th class="alignL pdL10" >${menu.LN00111}</th>
			<td class="sline tit last alignL" >
				<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
				<div id="tmp_file_items" name="tmp_file_items"></div>
				<div class="floatR pdR20" id="divFileImg">
				<c:if test="${SRFiles.size() > 0}">
					<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
					<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
				</c:if>
				</div>
				<c:forEach var="fileList" items="${SRFiles}" varStatus="status">
				<div id="divDownFile${fileList.Seq}"  class="mm"  name="divDownFile${fileList.Seq}">
						<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
						<span style="cursor:pointer;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>				
						<br>
					</div>
				</c:forEach>
				</div>
			</td>
		</tr>		
		</c:if>
		<tr>
		  <th class="alignL pdL10" rowspan="2">${menu.LN00283}</th> 
		  <td class="sline tit last alignC" >${menu.LN00292}</td>
		<tr>
		  <td class="sline tit last alignC" >
		  &nbsp;&nbsp;<input type="radio" name="sPoint" value="1" id="sPoint1">&nbsp;&nbsp; 1 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="sPoint" value="2" id="sPoint2">&nbsp;&nbsp; 2 &nbsp; &nbsp;&nbsp;
			<input type="radio" name="sPoint" value="3" id="sPoint3" checked>&nbsp;&nbsp; 3 &nbsp;&nbsp;&nbsp;
			<input type="radio" name="sPoint" value="4" id="sPoint4">&nbsp;&nbsp; 4 &nbsp;&nbsp;&nbsp;
			<input type="radio" name="sPoint" value="5" id="sPoint5">&nbsp;&nbsp; 5
		  </td>
		</tr>
		<tr>
		  <th class="alignL viewtop pdL10">${menu.LN00284}</th>
		  <td class="sline tit last alignL pdR10" >
		  	<textarea class="edit" id="opinion" name="opinion" style="width:100%;height:160px;"></textarea></td>
		</tr>
	</table>
	<div class="alignBTN">
	<span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveSRPoint()"></span>&nbsp;&nbsp;
	</div>
	</div>
	</div>
	</form>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</body>
</html>