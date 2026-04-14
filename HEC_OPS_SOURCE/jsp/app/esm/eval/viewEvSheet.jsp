<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<style>
	body{
		overflow:auto;
	}
	.attrValue {
	border: 1px solid #ececec;
    background: #fff;
    padding: 8px 10px;
    margin: 5px auto 20px;	
    color: #666666;
    font-size: 13px;
	}
	.attr_title p {font-weight: 700;font-size: 16px;margin: 15px 0 5px 10px;color: #193598;}
	.attr_title span {font-size:13px;color:#333;font-weight: normal;}
	.attrValue_que{font-size: 14px;}
</style>
<script type="text/javascript">
	var screenType = "${screenType}";
	
	$(document).ready(function(){
		if(screenType == "V"){
			<c:forEach var="evItemValue" items="${evItemValue}" varStatus="status">
				var attrCode = "${evItemValue.AttrTypeCode}";
				var value = "${evItemValue.Value}";
				<c:if test="${evItemValue.DataType eq 'LOV'}">
					$("input:radio[name='"+attrCode+"']:radio[value='"+value+"']").prop('checked', true);
				</c:if>
				<c:if test="${evItemValue.DataType eq 'Text'}">
					$("textarea[name='"+attrCode+"']").html(value);
				</c:if>
			</c:forEach>
			$("input:radio").attr('disabled',true);
			$("textarea").attr("disabled",true);
		}
	});
	
	function fnSaveEv(){
		if(!confirm("${CM00001}")){ return;}
			var url = "saveEv.do?srStatus=${status}&srType="+"${srType}";
			ajaxSubmit(document.evalFrm, url, "saveFrame");
	}
	
	function actionComplete() {
		parent.self.close();
		parent.opener.fnGoSRList();
	}
</script>
</head>
<body>
<form name="evalFrm" id="evalFrm" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="srID" name="srID"  value="${srID}" />
	<div id="evalSRDiv" style="padding:5px;">
		<div class="attr_title">
			<p>${evTitleName}&nbsp;<c:if test="${screenType eq 'V'}"><span>(&nbsp;Created on : ${creationTime}&nbsp;)</span></c:if></p>
		</div>
		<div class="attr">
			<ul id="evalSRDiv">
				<c:set value="1" var="no" />
				<c:forEach var="evItemList" items="${evItemList}" varStatus="status">
					<li class="attrValue_que">${no }.&nbsp;${evItemList.Name}</li>
					<li class="attrValue">
						<c:if test="${evItemList.DataType eq 'LOV' }">
						<c:forEach var="LovList" items="${evItemList.LovList}" varStatus="status">
							<input type="radio" name="${evItemList.AttrTypeCode}" id="${evItemList.AttrTypeCode}_${LovList.Score}" value="${LovList.Score}">
							<label for="${evItemList.AttrTypeCode}_${LovList.Score}">&nbsp;${LovList.NAME}&nbsp;&nbsp;</label>
						</c:forEach>
						</c:if>
						<c:if test="${evItemList.DataType eq 'Text' }">
							<textarea style="resize:none; width:100%; height:50px;background: #fff;" name="${evItemList.AttrTypeCode}"></textarea>
						</c:if>
					</li>
				<c:set var="no" value="${no+1}"/>
				</c:forEach>
			</ul>
		</div>
		<div class="alignR mgT10 mgR10 mgB10">
		<c:if test="${screenType eq 'E'}">
			<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span><input value="Submit" type="submit" onclick="fnSaveEv()"></span>
		</c:if>
		</div>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</body>
</html>