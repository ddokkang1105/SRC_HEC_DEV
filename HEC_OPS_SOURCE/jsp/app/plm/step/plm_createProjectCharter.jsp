<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
 <%@ page import="xbolt.cmm.framework.val.GlobalVal"%>  
 <link rel="stylesheet" type="text/css" href="${root}cmm/common/css/pim.css"/>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<script type="text/javascript">
	
	$(document).ready(function(){
		var height = setWindowHeight();
		if(document.getElementById('HtmlReport')!=null&&document.getElementById('HtmlReport')!=undefined){
			document.getElementById('HtmlReport').style.height = (height)+"px";
		};
		
		window.onresize = function(){
			height = setWindowHeight();
			document.getElementById('HtmlReport').style.height = (height)+"px";
		};
		
	});
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnCreateProjectCharter() {

		if(confirm("${CM00001}")){			
			var wbsTypeList = $("#wbsTypeList").val();
			if(wbsTypeList == ""){alert("${WM00034}"); return;}
			var url = "plm_newProjectCharter.do";
			ajaxSubmit(document.wbsInstInfoFrm, url);
		}
	}
	
	function fnCallBackSubmit() {
		opener.doSearchList();
		self.close();
	}
	
</script>
<div id="HtmlReport" style="width:100%; float:left; overflow-y:auto">
<form name="wbsInstInfoFrm" id="wbsInstInfoFrm" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="p_itemID" name="p_itemID"  value="${p_itemID}" />

	<!-- 화면 타이틀 : 결재경로 생성-->	
	<div class="cop_hdtitle">
		<ul>
			<li class="floatL mgL10">
				<h3 style="padding: 6px 0">
					<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;과제차터 생성
				</h3>
			</li>
	        <li class="floatR mgT10 mgR10">  
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnCreateProjectCharter()" type="button"></span> 
			</li> 
		</ul>	
	</div>
	<div id="objectInfoDiv" class="hidden floatC" style="width:100%;overflow-x:hidden;overflow-y:auto;" >
	<table style="table-layout: fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="instance_table">
		<colgroup>
			<col width="11%">
			<col width="22%">
		</colgroup>
		<tr>
			<th class="viewtop">WBS Type</th>
			<td class="tdLast alignL pdL5 last viewtop">
				<select id="wbsTypeList" name="wbsTypeList" style="width:140px;">
			    		<option value=''>Select</option>
	           	   		<c:forEach var="i" items="${wbsTypeList}">
	                   		<option value="${i.MyItemID}">${i.Identifier} ${i.ItemName}</option>
	           	    	</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th>과제 명</th>
			<td class="tdLast alignL pdL5 last">
					<input type="text" id="procInstanceName" name="procInstanceName" value="" style="width:100%;">
			</td>
		</tr>
		<tr>
			<th>과제 코드</th>
			<td class="tdLast alignL pdL5 last">
					<input type="text" id="ProcInstNo" name="ProcInstNo" value="" style="width:100%;">
			</td>
		</tr>
	</table>
	</div>	
	</form>	
	<div style="display:none;"><iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe></div>

</div>
