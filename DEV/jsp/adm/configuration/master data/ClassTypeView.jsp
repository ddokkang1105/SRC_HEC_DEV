<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />

<!--1. Include JSP -->
<!-- <%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%> -->
<!--  <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="Check in option"/>

<!-- Script -->
<script type="text/javascript">


var parent = document.getElementById("groupListDiv").parentNode.id;




	$(document).ready(function() {
		
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});
		
		fnSelect('languageID', '', 'langType', '${languageID}', 'Select');
// 		fnSelect('SymbolName', '&Category=SB', 'getDicWord', '${resultMap.DefSymCode}', 'Select');
		var data = "&languageID=${languageID}&menuCat=CLS&Category=WF";
		fnSelect('menuID', data, 'getMenuType', '${resultMap.MenuID}', 'Select');
		fnSelect('WorkFlow', data, 'getDicWord', '${resultMap.DefWFID}', 'Select');
		$("#FileOption").val("${resultMap.FileOption}");
		
		var chk1 = document.getElementsByName("check1");
		if(chk1[0].checked == true){
			$("#CheckInOption").show();
		}else{
			$("#CheckInOption").hide();
		}
		$("#CheckInOption").val("${resultMap.CheckInOption}");
		$("#AutoID").val("${resultMap.AutoID}");
				
		setTimeout(function(){
			$("#SymbolName").msDropDown();
		}, 100);
		
		if(parent == "arcFrame") document.querySelector("#classTypeTitle").remove()
		
	});

	function updateClassType() {
		console.log("updateClassType");
		if (confirm("${CM00001}")) {
			var chk1 = document.getElementsByName("check1");
			if(chk1[0].checked == true){
				if($("#CheckInOption").val() == null || $("#CheckInOption").val() == ""){
					alert("${WM00034}");
					return false;
				}
			}
			
			var checkConfirm = false;
			if ('${sessionScope.loginInfo.sessionCurrLangType}' != $("#languageID").val()) {
				if (confirm("${CM00006}")) {
					checkConfirm = true;
				}
			} else {
				checkConfirm = true;
			}

			if(checkConfirm) {
				var url = "admin/updateClassType.do";
				ajaxSubmit(document.ClassTypeList, url, "ClassFrame");
			}
		}
	}

	function goBackList() {
		var url = "DefineConnectionType.do";
		var data = "&selectedCat=${selectedCat}";
		var target = parent;
	
		ajaxPage(url, data, target);
	}
	
	function checkBox1(){
		var chk1 = document.getElementsByName("check1");
		if(chk1[0].checked == true)
		{
			$("#objChangeMgt").val("1");
			$("#CheckInOption").show();
		}
		else{
			$("#objChangeMgt").val("0");
			$("#CheckInOption").val("");
			$("#CheckInOption").hide();
		}
	}

	function checkBox3(){
		
		var chk3 = document.getElementsByName("check3");
		
		if(chk3[0].checked == true)
		{
			$("#objHasDimension").val("1");
		}
		else{
			$("#objHasDimension").val("0");
		}
		
	}
	function checkBox4(){		
		var chk4 = document.getElementsByName("check4");
		if(chk4[0].checked == true){
			$("#objHasFile").val("1");
		}
		else{
			$("#objHasFile").val("0");
		}
	}
	
	function checkBox6(){		
		var chk6 = document.getElementsByName("check6");		
		if(chk6[0].checked == true){
			$("#objDeactivated").val("1");
		}
		else{			
			$("#objDeactivated").val("0");
		}
	}
	
	function checkBox7(){		
		var chk7 = document.getElementsByName("check7");		
		if(chk7[0].checked == true){
			$("#objSubscription").val("1");
		}
		else{			
			$("#objSubscription").val("0");
		}
	}
	
	function thisReload(){
		var url    = "ClassTypeView.do"; // 요청이 날라가는 주소
		var data   = "classCode=${resultMap.ItemClassCode}"
					+ "&languageID="+$("#languageID").val()
					+ "&pageNum=${pageNum}"
					+ "&ItemTypeCode=${resultMap.ItemTypeCode}"
					+ "&CategoryCode=${CategoryCode}";
		var target = parent;

		

		
		ajaxPage(url, data, target);	
	}
	
	function searchPopup(url){	window.open(url,'','width=400, height=330, left=300, top=300,scrollbar=yes,resizble=0');}
	function setSearchTeam(teamID,teamName){$('#mgtTeamID').val(teamID);$('#mgtTeamName').val(teamName);}

	function fnItemPopUp(){
		var itemID = "${itemID}";
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop&screenMode=pop&accMode=DEV";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemID);
	}
	
</script>

<div id="groupListDiv">
	<form name="ClassTypeList" id="ClassTypeList" action="#" method="post" onsubmit="return false;" style="padding: 0 10px 0 5px;">
		<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
		<input type="hidden" id="orgTypeCode" name="orgTypeCode" value="${itemID}" /> 
		<input type="hidden" id="orgLastUser" name="orgLastUser" value="${sessionScope.loginInfo.sessionUserId}" />
		<input type="hidden" id="ItemClassCode" name="ItemClassCode" value="${resultMap.ItemClassCode}">
		<input type="hidden" id="SaveType" name="SaveType" value="Edit" /> 
		<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
		<input type="hidden" id="objChangeMgt" name="objChangeMgt" value="${resultMap.ChangeMgt}">
		<input type="hidden" id="objHasDimension" name="objHasDimension" value="${resultMap.HasDimension}">
		<input type="hidden" id="objHasFile" name="objHasFile" value="${resultMap.HasFile}">
		<input type="hidden" id="objDeactivated" name="objDeactivated" value="${resultMap.Deactivated}">	
		<input type="hidden" id="DefSymCode" name="DefSymCode" value="${resultMap.DefSymCode}">
		<input type="hidden" id="objSubscription" name="objSubscription" value="${resultMap.SubscrOption}">
		<input type="hidden" id="pageNum" name="pageNum" value="${pageNum}">
		<input type="hidden" id="mgtTeamID" name="mgtTeamID" value="${mgtTeamID}">
        <div class="title-section flex align-center justify-between" id="classTypeTitle">
			<span class="flex align-center">
				<span class="back" onclick="goBackList()"><span class="icon arrow"></span></span>
				<span id="title">Edit ClassType</span>
			</span>
		</div>

		<div class="contents_body_inner mgL30">
			<ul class="detail_settings_list mgT10">
				<li class="item">
					<h4 class="title">${menu.LN00147}</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="languageID" name="languageID" class="lw_btn_select" onchange="thisReload()"></select>
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">${menu.LN00015}</h4>
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input" value="${resultMap.ItemClassCode}" disabled/>
						</div>
					</div>
					<h4 class="title">${menu.LN00028}</h4>
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input" id="objClassName" name="objClassName" value="${resultMap.ClassName}" />
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">Icon</h4>
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input" id="objIcon" name="objIcon" value="${resultMap.Icon}" />
						</div>
					</div>
					<h4 class="title">Defalut Symbol</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="SymbolName" name="SymbolName" class="lw_btn_select">
								<option value="">Select</option>
								<c:forEach var="i" items="${SymCodeList}">
									<option value="${i.CODE}" data-image="${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/ICON_${i.CODE}.png" <c:if test="${i.CODE eq resultMap.DefSymCode}"> selected="selected"</c:if>>${i.NAME}</option>
								</c:forEach>
							</select>
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">Change Mgt.</h4>
					<div class="option_area">
						<div class="input_cover">
							<input type="checkbox" class="lw_toggle" id="check1" name="check1" <c:if test="${resultMap.ChangeMgt == '1'}">checked="checked"</c:if> value="${resultMap.ChangeMgt}" onclick="checkBox1()">
							<label for="check1"></label>
						</div>
					</div>
					<h4 class="title">Check In Option</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="CheckInOption" name="CheckInOption" class="lw_btn_select">
								<option value="">Select</option>
								<option value="01">01</option>
								<option value="01B">01B</option>
								<option value="02">02</option>
								<option value="03">03</option>
								<option value="03A">03A</option>
								<option value="03B">03B</option>
							</select>
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">Subscription</h4>
					<div class="option_area">
						<div class="input_cover">
							<input type="checkbox" class="lw_toggle" id="check7" name="check7" <c:if test="${resultMap.SubscrOption == '1'}"> checked="checked" </c:if> value="${resultMap.SubscrOption}" onclick="checkBox7()">
							<label for="check7"></label>
						</div>
					</div>
					<h4 class="title">Ver. Numbering</h4>
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input" id="DefVersionIncr" name="DefVersionIncr" value="${resultMap.DefVersionIncr}" />
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">Menu</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="menuID" name="menuID" class="lw_btn_select"></select>
						</div>
					</div>
					<h4 class="title">Def. Work flow</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="WorkFlow" name="WorkFlow" class="lw_btn_select"></select>
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">File Option</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="FileOption" name="FileOption" class="lw_btn_select">
								<option value="">Select</option>
								<option value="N">N</option>
								<option value="OLM">OLM</option>
								<option value="VIEWER">VIEWER</option>
								<option value="ExtLink">ExtLink</option>
								<option value="PDFCNVT">PDF Convert</option>
							</select>
						</div>
					</div>
					<h4 class="title">Has Dimension</h4>
					<div class="option_area">
						<div class="input_cover">
							<input type="checkbox" name="check3" id="check3" class="lw_toggle" <c:if test="${resultMap.HasDimension == '1'}">checked="checked"</c:if> value="${resultMap.HasDimension}" onclick="checkBox3()">
							<label for="check3"></label>
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">Level</h4>
					<div class="option_area">
						<div class="input_cover">
							<input type="number" name="level" id="level" class="lw_input" value="${resultMap.Level}" />
						</div>
					</div>
					<h4 class="title">Auto ID</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="AutoID" name="AutoID" class="lw_btn_select">
								<option value="">Select</option>
								<option value="Y">Y</option>
								<option value="N">N</option>
							</select>
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">PreFix</h4>
					<div class="option_area">
						<div class="input_cover">
							<input type="text" name="PreFix" id="PreFix" class="lw_input" value="${resultMap.Prefix}" />
						</div>
					</div>
					<h4 class="title">Deactivated</h4>
					<div class="option_area">
						<div class="input_cover">
							<input type="checkbox" name="check6" id="check6" class="lw_toggle" <c:if test="${resultMap.Deactivated == '1'}"> checked="checked"</c:if> value="${resultMap.Deactivated}" onclick="checkBox6()">
							<label for="check6"></label>
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">Mgt Team Name</h4>
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input" id="mgtTeamName" name="mgtTeamName" readonly="readonly" onclick="searchPopup('searchTeamPop.do')" value="${resultMap.MgtTeamName}" /> </div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">Var Filter</h4>
					<div class="option_area">
						<div class="input_cover single">
							<input type="text" class="lw_input" id="Varfilter" name="Varfilter" value="${resultMap.Varfilter}" />
						</div>
					</div>
				</li>
				<li class="item">
					<h4 class="title">Description</h4>
					<div class="option_area">
						<div class="input_cover single">
							<input type="text" class="lw_input" id="objDescription" name="objDescription" value="${resultMap.Description}" />
						</div>
					</div>
				</li>
			</ul>
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="mgT15 mgR10 floatR">
				<button class="cmm-btn2 mgR5 mgB20" style="height: 30px;" onclick="updateClassType()" value="Save">Save</button>
			</span>
					<c:if test="${!empty itemID}">
					<span class="mgT15 floatR">
					<button class="cmm-btn mgR5 mgB20" style="height: 30px;" onclick="fnItemPopUp()" value="View item">View item</button>
					</span>
				</c:if> 
			</c:if>
		</div>

	</form>
	</div>
		<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="ClassFrame" id="ClassFrame" src="about:blank"
				style="display: none;" frameborder="0" scrolling='no'></iframe>
		</div>
