<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<c:url value="/" var="root"/>
<script type="text/javascript">
	//var chkReadOnly = true;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<script type="text/javascript">
$(document).ready(function(){		
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&editable=1&category=MC";
	fnSelect('MTCategory', data, 'getDictionary', 'BAS');
});

function wordReportOut(){
	//var opener = window.dialogArguments;
	var avg1 = "";
	var avg2 = "";
	var avg3 = "${url}";
	var avg4 = "";
	
	if ($("input:checkbox[id='checkOnlyMap']").is(":checked") == true) {
		avg1 = "Y";} else {avg1 = "N";}
	avg2 = fnGetRadioValue("radioSize");	
	var checkObj = document.all("delItemsYN");
	var avg5 = $("#MTCategory").val();
	var avg6 = "";
	if("${outputType}" != "doc"){
		avg6 = "${outputType}";
	}else{
		avg6 = $("#outputType").val();
	}
	if (checkObj.checked) {avg4 = "Y"; } else { avg4 = "N"; }
	opener.wordReport(avg1, avg2, avg3, avg4, avg5, avg6);
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
<form name="wordReportFrm" id="wordReportFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />
	
	<div id="objectInfoDiv" class="hidden" style="width:100%;height:350px;">
	
		<div class="child_search_head">
			<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Word Report</p>
		</div>
	
		<div id="framecontent" class="mgT10 mgB10">	
			<div class="attr">
				 <table width="85%"  border="0" cellspacing="0" cellpadding="0" >
					<tr>
						<!-- 출력 범위 -->
						<td>${menu.LN00157}</td>
						<!-- 프로세스 모델 맵만 -->
						<td>
							<input type="checkbox" id="checkOnlyMap">&nbsp;${menu.LN00156}&nbsp;&nbsp;
						</td>
					</tr>
					
					<tr>
						<!-- 용지 크기 -->
						<td>${menu.LN00158}</td>
						<td>
							<input type="radio" name="radioSize" value=1 checked="checked">&nbsp;A4 ( 21.0 cm / 29.7 cm ) <br>
							<input type="radio" name="radioSize" value=2>&nbsp;A3 ( 42.0 cm / 29.7 cm ) <br> &nbsp;&nbsp;
						</td>
					</tr>
					<c:if test="${outputType eq 'doc' }" >
					<tr>
						<!-- output Type-->
						<td  style="padding-bottom:3px;">Output Type</td>
						<td  style="padding-bottom:3px;">
							<select id="outputType" name=""outputType"" class="sel" style="width:90%;margin-left=5px;">
								<option value="doc" <c:if test="${outputType eq 'doc' }"> selected </c:if> >doc</option>
								<option value="pdf" <c:if test="${outputType eq 'pdf' }"> selected </c:if> >pdf</option>
							</select>
						</td>
					</tr>
					</c:if>
					<tr>
						<td>Model Category</td>
						<td class="pdB5">
							<select id="MTCategory" name="MTCategory" class="sel" style="width:90%;margin-left=5px;"></select>
						</td>
					</tr>
					<tr>
						<!-- 삭제된 아이템 포함여부 -->
						<td>Include deleted items</td>
						<td>
							<input type="checkbox" name="delItemsYN" name="delItemsYN" > 
						</td>
					</tr>
				</table>
			</div>
	 		<div class="alignBTN mgB5 mgR10">
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="wordReportOut()" type="submit"></span>
			</div>
		</div>			
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;"></iframe>