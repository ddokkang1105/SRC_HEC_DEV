<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript">
	var scrnMode = "${scrnMode}";
	var chkReadOnly = false;
	if(scrnMode == "V"){
		chkReadOnly = true;
	}
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<script type="text/javascript">
	
	$(document).ready(function(){
		var height = setWindowHeight();
		if(document.getElementById('elmAttrDiv')!=null&&document.getElementById('elmAttrDiv')!=undefined){
			document.getElementById('elmAttrDiv').style.height = (height-60)+"px";
		};
		
		window.onresize = function(){
			height = setWindowHeight();
			document.getElementById('elmAttrDiv').style.height = (height-60)+"px";
		};
	});
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function saveElmInst(){
		var url = "updateElmInstAttr.do?procInstNo=${procInstNo}&elmInstNo=${elmInstNo}&instanceClass=ELM";
		ajaxSubmit(document.elmAttrFrm, url,"saveFrame");
	}
	
	function editElmInst(scrnMode){
		var url = "elmInstAttr.do";
		var data = "instanceNo=${procInstNo}&elmInstNo=${elmInstNo}&instanceClass=ELM&elmItemID=${elmItemID}&scrnMode="+scrnMode;
		ajaxPage(url, data, "elmAttrDiv");
	}
	
	function goBack(){
		editElmInst('V');
	}
</script>
<div id="elmAttrDiv" style="width:100%; float:left; overflow-y:auto">
<form name="elmAttrFrm" id=""elmAttrFrm"" action="" method="post" onsubmit="return false;">
<div class="pdT10">
	<!-- BIGIN :: 속성 -->
	<c:if test="${attrList.size() > 0}">
		<div id="attrList">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
				<c:forEach var="i" items="${attrList}" varStatus="status">
	   			<colgroup>	
					<col width="11%">
					<col width="89%">
				</colgroup>
				<tr>
					<th>상세 Process</th>
					<td class="tdLast alignL pdL5">
						<textarea class="tinymceText" name="${i.AttrTypeCode}" style="width:100%;height:400px;"><div class="mceNonEditable">${i.PlainText}</div></textarea>
					</td>
				</tr>													
			</c:forEach>
		</table>				
		<c:if test="${sessionScope.loginInfo.sessionUserId eq prcInfo.AuthorID }">
			<li class="floatR mgR10">
			<c:choose>
				<c:when test="${scrnMode eq 'V' }">
					<span class="btn_pack medium icon mgB10 mgT5"><span class="edit"></span><input value="Edit" type="submit" onclick="editElmInst('E')"></span>
				</c:when>
				<c:when test="${scrnMode eq 'E' }">
					<span class="btn_pack medium icon mgB10 mgT5"><span class="pre"></span><input value="Back" type="submit" onclick="editElmInst('V')"></span>
	 				&nbsp;<span class="btn_pack medium icon mgB10 mgT5"><span class="save"></span><input value="Save" type="submit" onclick="saveElmInst()"></span>
				</c:when>
			</c:choose>
			 </li>
	 			
		</c:if>
		</div>
	</c:if>
	<!--  //end 속성 -->
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none;width:0px;height:0px;"></iframe>
</div>	

