<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %><c:url value="/" var="root"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<c:url value="/" var="root"/>

<script type="text/javascript">
$(document).ready(function(){		
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&editable=1&category=MC";
	fnSelect('MTCategory', data, 'getDictionary', 'BAS');
});

function fnReport(){
	var outputType = $("#outputType").val();
	var url = $("#url").val();
	var classCodeList = $("#classCodeList").val();
	opener.subItemInfoRpt(url, classCodeList, outputType);
	self.close();
}

function fnGetRadioValue(radioName) {
	var radioObj = document.all(radioName);
	for (var i = 0; i < radioObj.length; i++) {
		if (radioObj[i].checked) {
			return radioObj[i].value;
		}
	}
}
</script>
<form name="reportFrm" id="reportFrm" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="url" name="url" value="${url}"/>
	<input type="hidden" id="classCodeList" name="classCodeList" value="${classCodeList}"/>
	<div id="objectInfoDiv" class="hidden" style="width:100%;height:350px;">
		<div class="child_search_head">
			<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Select report Option</p>
		</div>
	
		<div id="framecontent" class="mgT10 mgB10">	
			<div class="attr">
				 <table width="85%"  border="0" cellspacing="0" cellpadding="0" >
					<tr>
						<!-- output Type-->
						<td  style="padding-bottom:3px;">Output Type</td>
						<td  style="padding-bottom:3px;">
							<select id="outputType" class="sel" style="width:90%;margin-left=5px;">
								<option value="doc" <c:if test="${outputType eq 'doc' }"> selected </c:if> >doc</option>
								<option value="pdf" <c:if test="${outputType eq 'pdf' }"> selected </c:if> >pdf</option>
							</select>
						</td>
					</tr>
				</table>
			</div>
	 		<div class="alignBTN mgB5 mgR10">
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnReport()" type="submit"></span>
			</div>
		</div>			
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;"></iframe>

</body></html>