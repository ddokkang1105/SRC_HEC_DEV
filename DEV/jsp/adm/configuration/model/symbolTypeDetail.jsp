<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!--1. Include JSP -->
<!--  <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00016}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00021}"/>
<style>

</style>
<!-- Script -->
<script type="text/javascript">
var parent = document.getElementById("groupListDiv").parentNode.id; 

	$(document).ready(function() {
		
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
	
		fnSelect('getLanguageID', '', 'langType', '${languageID}', 'Select');

		fnSelect('ItemTypeCode', '&category=${resultMap.ItemCategory}', 'itemTypeCode', '${resultMap.ItemTypeCode}',  'Select');
		fnSelect('ClassCode', '&option=${resultMap.ItemTypeCode}', 'classCodeOption', '${resultMap.ClassCode}', 'Select');

		var data = "languageID=${languageID}&attrTypeCode=''";
		fnSelect('DefLovCode', data, 'getAttrTypeCodeLov', '${resultMap.DefLovCode}', 'Select');
		var myCP;
		myCP = dhtmlXColorPicker(["DefColor","DefStrokeColor","DefGradientColor","DefFillColor","DefFontColor","DefLabelBGColor"]);
		myCP.setColor([143,235,0]);
		
		if(parent == "arcFrame") document.querySelector("#classTypeTitle").remove();
	});
	
	function saveSymbolType(){
		if(confirm("${CM00001}")){	
			if($("#SymbolName").val() == null || $("#SymbolName").val() == ""){
				alert("${WM00034_1}");
				return false;
			}
			if($("#ItemTypeCode").val() == null || $("#ItemTypeCode").val() == ""){
				alert("${WM00034_3}");
				return false;
			}
			if($("#ClassCode").val() == null || $("#ClassCode").val() == ""){
				alert("${WM00034_2}");
				return false;
			}
			
			// var url = "admin/saveSymbolType.do?viewType=${viewType}";
			var url = "admin/saveSymbolType.do?viewType=${viewType}";
			var target = "saveFrame";		
			ajaxSubmit(document.SymbolTypeDetail, url, target);
		}
	}

	function goBack() {
		var url = "symbolType.do";
		var data = "&pageNum=${pageNum}"
				 +"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				 + "&cfgCode=${cfgCode}"
				 + "&viewType=E";
		var target = "symbolTypeDiv";
		ajaxPage(url, data, target);
	}


	
	function CheckBox2(){
		var chk1 = document.getElementsByName("check1");
		
		if(chk1[0].checked == true){
			$("#Deactivated").val("1");
		}else{
			$("#Deactivated").val("0");
		}
	}
	
	function fnGetItemType(category){
		fnSelect('ItemTypeCode', '&category='+category, 'itemTypeCode', '',  'Select');
	}
	
	function fnChangeItemType(itemTypeCode){
		fnSelect('ClassCode', '&option='+itemTypeCode, 'classCodeOption', '', 'Select');
	}

	function thisReload(){
		var url    = "symbolTypeDetail.do"; // 요청이 날라가는 주소
		var data   =  "SymTypeCode=${resultMap.SymTypeCode}" 
					+ "&languageID="+$("#getLanguageID").val()
					+ "&pageNum=${pageNum}"
					+ "&viewType="+ $("#viewType").val()
					+ "&cfgCode=${cfgCode}"
					+ "&ItemTypeCode=${resultMap.ItemTypeCode}"
					+ "&CategoryCode=${CategoryCode}"
					+ "&SymbolName="+$("#SymbolName").val();
		var target = parent;
		ajaxPage(url,data,target);	
	}
	
	function fnOnlyEnNum(obj){
		var regType = /^[A-Za-z0-9*]+$/;
        if(!regType.test(obj.value)) {
            obj.focus();
            $(obj).val( $(obj).val().replace(/[^A-Za-z0-9]/gi,"") );
            return false;
        }
    }
</script>

<div id="groupListDiv">
<form name="SymbolTypeDetail" id="SymbolTypeDetail" action="*" method="post" onsubmit="return false;" style="padding: 0 10px 0 5px;">
		<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
		<input type="hidden" id="SymTypeCode" name="SymTypeCode" value="${resultMap.SymTypeCode}"> 
		<input type="hidden" id="LanguageID" name="LanguageID" value="${languageID}"/>
		<input type="hidden" id="cfgCode" name="cfgCode" value="${cfgCode}">
		<input type="hidden" id="viewType" name="viewType" value="${viewType}">
		<input type="hidden" id="Deactivated" name="Deactivated" value="${resultMap.Deactivated}">
	
        <div class="title-section flex align-center justify-between" id="classTypeTitle">
			<span class="flex align-center">
				<span class="back" onclick="goBack()"><span class="icon arrow"></span></span>
				<span id="title">Edit Symbol Type</span>
			</span>
		</div>

		<div class="contents_body_inner mgL30">
			<ul class="detail_settings_list mgT10">
				<li class="item">
					<h4 class="title">${menu.LN00147}</h4> <!-- 언어 -->
					<div class="option_area">
						<div class="input_cover">
							<select id="getLanguageID" name="getLanguageID" class="lw_btn_select" onchange="thisReload()"></select> 
						</div>
					</div>
				</li>
				<li class="item"> 
					<h4 class="title">${menu.LN00015}</h4> <!-- 코드 -->
					
					<div class="option_area">
						<div class="input_cover">
					  <c:choose>
						        <c:when test="${viewType == 'N'}">
					
						         <input type="text" class="lw_input" id="objWFID"	name="objMaxSymbolTypeCode" value="${MaxSymbolTypeCode}" onkeyup="fnOnlyEnNum(this);" onchange="fnOnlyEnNum(this);"/>		
						        </c:when>
						        <c:otherwise>
						           
						            <input type="text" class="lw_input" value="${resultMap.SymTypeCode}" disabled/>
						        </c:otherwise>
						    </c:choose>
	
						</div>
					
					</div>
					<h4 class="title" style="margin-left: 10%;">${menu.LN00028}</h4>  <!-- 명칭 -->
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input" id="SymbolName" name="SymbolName" value="${resultMap.SymbolName}" />
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title" >${menu.LN00171}</h4> <!-- 파일경로 -->
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input" id="ImagePath" name="ImagePath" value="${resultMap.ImagePath}"
							style="width: 400px;" />
						</div>
					</div>
					<h4 class="title" style="margin-left: 10%;">${menu.LN00033}</h4> <!-- 카테고리 -->
					<div class="option_area">
						<div class="input_cover">
							<select id="ItemCategory" name="ItemCategory" class="lw_btn_select" OnChange="fnGetItemType(this.value)">
								<option <c:if test="${resultMap.ItemCategory == 'OJ' }">selected="selected"</c:if> value="OJ">OJ</option>
								<option <c:if test="${resultMap.ItemCategory == 'MCN' }">selected="selected"</c:if> value="MCN">MCN</option>
								<option <c:if test="${resultMap.ItemCategory == 'MOJ' }">selected="selected"</c:if> value="MOJ">MOJ</option>				
								<option <c:if test="${resultMap.ItemCategory == 'TXT' }">selected="selected"</c:if> value="TXT">TXT</option>
							</select>
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">${menu.LN00021}</h4> <!-- 항목유형 -->
					<div class="option_area">
						<div class="input_cover">
							<select id="ItemTypeCode" name="ItemTypeCode" class="lw_btn_select" OnChange="fnChangeItemType(this.value)">
								<option value="">Select</option>
								<c:forEach var="i" items="${itemTypeCode}">
									<option value="${i.CODE}" <c:if test="${i.CODE eq resultMap.ItemTypeCode}"> selected="selected"</c:if>>${i.NAME}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<h4 class="title" style="margin-left:10%;">${menu.LN00016}</h4> <!-- 클래스 -->
					<div class="option_area">
						<div class="input_cover">
							<select id="ClassCode" name="ClassCode" class="lw_btn_select"></select>
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">Deactived.</h4> <!-- Deactived -->
					<div class="option_area">
						<div class="input_cover">
							<input type="checkbox" class="lw_toggle" id="check1" name="check1" 
								<c:if test="${resultMap.Deactivated == '1'}">checked="checked"
								</c:if> 
								value="${resultMap.ChangDeactivatedeMgt}" onclick="CheckBox2()">
							<label for="check1"></label>
						</div>
					</div>
					<h4 class="title" style="margin-left: 10%;">DefFillColor</h4> <!-- DefFillColor -->
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input" id="DefFillColor" name="DefFillColor" value="${resultMap.DefFillColor}" />
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">DefStrokeColor</h4> <!-- DefStrokeColor -->
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input" id="DefStrokeColor" name="DefStrokeColor" value="${resultMap.DefStrokeColor}" />
						</div>
					</div>
					<h4 class="title" style="margin-left: 10%;">DefGradientColor</h4> <!-- DefGradientColor -->
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input" id="DefGradientColor" name="DefGradientColor" value="${resultMap.DefGradientColor}" />
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">DefShadow</h4> <!-- DefShadow -->
					<div class="option_area">
						<div class="input_cover">
							<input type="number" name="DefShadow" id="DefShadow" class="lw_input" value="${resultMap.DefShadow}" />
						</div>
					</div>
					<h4 class="title" style="margin-left: 10%;">DefFontColor</h4> <!-- DefFontColor -->
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input" id="DefFontColor" name="DefFontColor" value="${resultMap.DefFontColor}" />
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">DefLabelBGColor</h4> <!-- DefLabelBGColor -->
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input" id="DefLabelBGColor" name="DefLabelBGColor" value="${resultMap.DefLabelBGColor}" />
						</div>
					</div>
					<h4 class="title" style="margin-left: 10%;">DefSpacingTop</h4> <!-- DefSpacingTop -->
					<div class="option_area">
						<div class="input_cover">
							<input type="number" name="DefSpacingTop" id="DefSpacingTop" class="lw_input" value="${resultMap.DefSpacingTop}" />
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">DefFontSize</h4> <!-- DefFontSize -->
					<div class="option_area">
						<div class="input_cover">
							<input type="number" name="DefFontSize" id="DefFontSize" class="lw_input" value="${resultMap.DefFontSize}" />
						</div>
					</div>
					<h4 class="title" style="margin-left:10%;">DefWidth</h4> <!-- DefWidth -->
					<div class="option_area">
						<div class="input_cover">
							<input type="number" name="DefWidth" id="DefWidth" class="lw_input" value="${resultMap.DefWidth}" />
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">DefHeight</h4> <!-- DefHeight -->
					<div class="option_area">
						<div class="input_cover">
							<input type="number" name="DefHeight" id="DefHeight" class="lw_input" value="${resultMap.DefHeight}" />
						</div>
					</div>
					<h4 class="title" style="margin-left: 10%;">Default LoV</h4> <!-- Default LoV -->
					<div class="option_area">
						<div class="input_cover">
							<select id="DefLovCode" name="DefLovCode" class="lw_btn_select"></select>
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">SortNum</h4> <!-- SortNum -->
					<div class="option_area">
						<div class="input_cover">
							<input type="number" name="SortNum" id="SortNum" class="lw_input" value="${resultMap.SortNum}" />
						</div>
					</div>
					<div>

					</div>
				</li>
			</ul>

			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<span class="mgT15 mgR10 floatR">
					<button class="cmm-btn mgR5 mgB20" style="height: 30px;" onclick="goBack()" value="List" >List</button>
					<button class="cmm-btn2 mgR5 mgB20" style="height: 30px;" onclick="saveSymbolType()" value="Save">Save</button>
				</span>
			</c:if>
		</div>

	</form>	
</div>

<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display: none;" frameborder="0" scrolling='no'></iframe>
</div>

		
