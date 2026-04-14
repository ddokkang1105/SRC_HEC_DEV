<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript">
	
	function goSave(){	
		opener.fnSubmitWfInstInfo();
		self.close();
	}
</script>
</head>
<body>
<div id="apprCommentDiv" style="padding: 0 6px 6px 6px; height:300px;overflow:auto;"> 
<form name="apprCommentFrm" id="apprCommentFrm" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="projectID" name="projectID"  value="${projectID}" />	
	<input type="hidden" id="wfInstanceID" name="wfInstanceID" value="${wfInstanceID}" />
	<input type="hidden" id="stepInstID" name="stepInstID" value="${stepInstID}" />
	<input type="hidden" id="actorID" name="actorID" value="${actorID}" />
	<input type="hidden" id="lastSeq" name="lastSeq" value="${lastSeq}" />
	<input type="hidden" id="stepSeq" name="stepSeq" value="${stepSeq}" />
	<input type="hidden" id="srID" name="srID" value="${srID}" />
	<input type="hidden" id="wfStepInstStatus" name="wfStepInstStatus" value="${wfStepInstStatus}" />
	
	<div class="cop_hdtitle mgB10" style="border-bottom:1px solid #ccc">
		<ul>
			<li>
				<h3>
					* Approval Path
				</h3>
			</li>
		</ul>	
	</div>
	<table class="tbl_brd mgT10 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="33%">
			<col width="33%">
		    <col width="33%">
		</colgroup>		
		<tr>
		  <th class="alignC pdL10">${menu.LN00004}</th> <!-- 진행단계 -->
		  <th class="alignC pdL10">${menu.LN00104}</th> <!-- 담당조직 -->
		  <th class="alignC pdL10">${menu.LN00120}</th> 
		</tr>
		<c:forEach var="list" items="${wfInstList}" varStatus="status">
			<tr style="height:26px;">
				<td class="sline tit last alignC " >${list.ActorName}</td>
				<td class="sline tit last alignC " >${list.TeamName}</td>
				<td class="sline tit last alignC " >${list.WFStepName}</td>
			</tr>
		</c:forEach>
		<c:forEach var="list" items="${wfRefInstList}" varStatus="status">
			<tr style="height:26px;">
				<td class="sline tit last alignC " >${list.ActorName}</td>
				<td class="sline tit last alignC " >${list.TeamName}</td>
				<td class="sline tit last alignC " >${list.WFStepName}</td>
			</tr>
		</c:forEach>
	</table>
	<div class="alignR pdT10">
		<span class="btn_pack medium icon"><span class="confirm"></span><input value="Confirm" onclick="goSave()" type="button"></span>
	</div>
	</form>	
	<div style="display:none;"><iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe></div>
</div>
</body>
</html>