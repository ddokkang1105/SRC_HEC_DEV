<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />

<!--1. Include JSP -->
<!-- <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="Menu"/>

<!-- Script -->
<script type="text/javascript">
	$(document).ready(function() {
		
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});
		
		var languageID = "${languageID}";
		if(languageID == ""){languageID = '${sessionScope.loginInfo.sessionCurrLangType}';}
		var data = "&languageID="+languageID+"&menuCat=ARC";
		fnSelect('getLanguageID', '', 'langType',languageID, 'Select');
		fnSelect('filterType', '', 'getFilterType', '${resultMap.FilterType}', 'Select');
		fnSelect('menuType', data, 'getMenuType', '${resultMap.MenuID}', 'Select');
		$("#treeType").val("${resultMap.Type}").attr("selected", "selected");
		fnSelect('parentID','','getArcCode','${resultMap.ParentID}', 'Select');
		$("#WID").val("${resultMap.WID}");
		$("#idFilter").val("${resultMap.IDFilter}");
		
// 		if("${viewType}" != "N") fnArcAllocation(languageID);
	});

	function updateArchitecture() {
		if($("#dimTypePath").val() == ''){$("#dimTypeID").val("");}
		if (confirm("${CM00001}")) {
			var checkConfirm = false;
			if ('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()) {
				if (confirm("${CM00006}")) {
					checkConfirm = true;
				}
			} else if($("#menuType").val() == null || $("#menuType").val() == ""){
				alert("${WM00025}");
				checkConfirm = false;
				return false;
			} else {
				checkConfirm = true;
			}

			if (checkConfirm) {
				var url = "admin/updateArchitectrue.do?viewType=${viewType}";
				ajaxSubmit(document.ArchitecturDetail, url);
			}
		}

	}
	
	function CheckBox1(){
		var chk1 = document.getElementsByName("check1");
		if(chk1[0].checked == true){
			$("#objDimTypeID").val("1");
		}else{ $("#objDimTypeID").val("0");}
		
	}
/* 	function CheckBox2(){
		var chk2 = document.getElementsByName("WID");
		if(chk2[0].checked == true){
			$("#widVal").val("1");
		}else{
			$("#widVal").val("0");
		}
	} */
	
	function CheckBox3(){
		var chk3 = document.getElementsByName("Deactivated");
		if(chk3[0].checked == true){
			$("#Deactivated").val("1");
		}else{
			$("#Deactivated").val("0");
		}
	}
	
	function CheckBox4(){
		var chk4 = document.getElementsByName("UntitledOption");

		if(chk4[0].checked == true){
			$("#UntitledOption").val("Y");
		}else{
			$("#UntitledOption").val("N");
		}
	}

	function CheckBox5(){
		var chk5 = document.getElementsByName("SortOption");
		if(chk5[0].checked == true){
			$("#SortOption").val("1");
		}else{
			$("#SortOption").val("0");
		}
	}
	
	function ArcReload(viewType){
		if(viewType == "N") {
			var url = "DefineArchitecture.do";
			var data = "cfgCode=${cfgCode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + "&pageNum=" + $("#currPage").val();
			var target = "processListDiv";
		} else {
			var url    = "architectureView.do"; // 요청이 날라가는 주소
			var data   = "&ArcCode="+$("#ArcCode").val() +"&languageID="+$("#getLanguageID").val();
			var target = "arcFrame";	
		}
		ajaxPage(url,data,target);
	}
	
	function fnChangeTreeType(){
		var treeType = $("#treeType").val();
		
		if(treeType=="G"){		
			$("#parentID").attr('disabled', 'disabled: true');	
		}
	}
	
	function searchItem(){
		var url = "orgItemTreePop.do";
		var data = "ItemID="+$("#dimTypeID").val()+"&ItemTypeCode=OJ00010";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
	function doCallBack(avg){
		var ItemID = avg;
		$("#dimTypeID").val(ItemID);
		var url = "getPathOrg.do";
		var data = "ItemID="+ItemID;
		var target = "blankFrame";
		ajaxPage(url,data,target);
	}

	function thisReload(Path){
		$("#dimTypePath").val(Path);
		$(".popup_div").hide();
		$("#mask").hide();
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
<form name="ArchitecturDetail" id="ArchitecturDetail" action="*" method="post" onsubmit="return false;" style="padding: 0 10px 0 5px;">
<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
<div id="groupListDiv" class="hidden" style="width: 100%; height: 100%; ">
<input type="hidden" id="orgLastUser" name="orgLastUser" value="${sessionScope.loginInfo.sessionUserId}" />
<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}"> 
<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
<input type="hidden" id="dimTypeID" name="dimTypeID" value="${resultMap.DimTypeID}">

<c:if test="${viewType == 'N'}">
<div class="title-section flex align-center justify-between">
	<span class="flex align-center">
		<span class="back" onclick="ArcReload('N')"><span class="icon arrow"></span></span>
		<span id="title">Add Architecture</span>
	</span>
</div>
</c:if>

<div class="contents_body_inner mgL30">
	<ul class="detail_settings_list mgT10">
		<li class="item">
			<h4 class="title">${menu.LN00015}</h4>
			<div class="option_area">
				<div class="input_cover">
					<input type="text" class="lw_input" id="ArcCode" name="ArcCode" value="${resultMap.ArcCode}" <c:if test="${viewType ne 'N'}">readonly style="background: none; border: none;"</c:if>/>
				</div>
			</div>
			<h4 class="title">${menu.LN00147}</h4>
			<div class="option_area">
				<div class="input_cover">
					<select id="getLanguageID" name="getLanguageID" class="lw_btn_select" onchange="ArcReload()"></select>
				</div>
			</div>
		</li>
		<li class="item">
			<h4 class="title">Name</h4>
			<div class="option_area">
				<div class="input_cover single">
					<input type="text" class="lw_input" id="ArcName" name="ArcName" value="${resultMap.ArcName}" />
				</div>
			</div>
		</li>
		<li class="item">
			<h4 class="title">Style</h4>
			<div class="option_area">
				<div class="input_cover">
					<input type="text" class="lw_input" id="Style" name="Style" value="${resultMap.Style}" />
				</div>
			</div>
			<h4 class="title">Icon</h4>
			<div class="option_area">
				<div class="input_cover">
					<input type="text" class="lw_input" id="Icon" name="Icon" value="${resultMap.Icon}" />
				</div>
			</div>
		</li>
		<li class="item">
			<h4 class="title">Parent Arc.</h4>
			<div class="option_area">
				<div class="input_cover">
					<select id="parentID" name="parentID" class="lw_btn_select" style="width:100%;" ></select>
				</div>
			</div>
			<h4 class="title">Menu Type</h4>
			<div class="option_area">
				<div class="input_cover">
					<select id="treeType" name="treeType" class="lw_btn_select" style="width:100%;" OnChange="fnChangeTreeType()" >
						<option value="G">Group</option>
						<option value="T">Tree</option>
						<option value="M">Menu</option>
					</select>
				</div>
			</div>
		</li>
		<li class="item">
			<h4 class="title">Menu</h4>
			<div class="option_area">
				<div class="input_cover">
					<select id="menuType" name="menuType" class="lw_btn_select" style="width:100%;" ></select> 
				</div>
			</div>
			<c:if test="${resultMap.Type != 'G'}">
			<h4 class="title">FilterType</h4>
			<div class="option_area">
				<div class="input_cover">
					<select id="filterType" name="filterType" class="lw_btn_select" style="width:100%;" ></select>
				</div>
			</div>
			</c:if>
		</li>
		<li class="item">
			<h4 class="title">Show ID</h4>
			<div class="option_area">
				<div class="input_cover">
					<select id="WID" name="WID" class="lw_btn_select" style="width:100%;">
						<option value="0">Select</option>
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
					</select> 
				</div>
			</div>
			<h4 class="title">ID Filter</h4>
			<div class="option_area">
				<div class="input_cover">
					<select id="idFilter" name="idFilter" class="lw_btn_select" style="width:100%;">
						<option value="">Select</option>
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
						<option value="5">5</option>
					</select>
				</div>
			</div>
		</li>
		<li class="item">
			<h4 class="title">Sort Option</h4>
			<div class="option_area">
				<div class="input_cover">
					<input type="checkbox" name="SortOption" id="SortOption" class="lw_toggle" <c:if test="${resultMap.SortOption == '1'}">checked="checked"</c:if> value="${resultMap.SortOption}" onclick="CheckBox5()">
					<label for="SortOption"></label>
				</div>
			</div>
			<h4 class="title">Untitled Option</h4>
			<div class="option_area">
				<div class="input_cover">
					<input type="checkbox" name="UntitledOption" class="lw_toggle" id="UntitledOption" <c:if test="${resultMap.UntitledOption == 'Y'}">checked="checked"</c:if> value="${resultMap.UntitledOption}" onclick="CheckBox4()">
					<label for="UntitledOption"></label>
				</div>
			</div>
		</li>
		<li class="item">
			<h4 class="title">DimTypeID</h4>
			<div class="option_area">
				<div class="input_cover">
					<input type="text" class="lw_input"  id="dimTypePath" name="dimTypePath" value="${resultMap.Path}" onclick="searchItem()"/>
				</div>
			</div>
			<h4 class="title">DeActivated</h4>
			<div class="option_area">
				<div class="input_cover">
					<input type="checkbox" name="Deactivated" class="lw_toggle" id="Deactivated" <c:if test="${resultMap.Deactivated == '1'}">checked="checked"</c:if> value="${resultMap.Deactivated}" onclick="CheckBox3()">
					<label for="Deactivated"></label>
				</div>
			</div>
		</li>
		<li class="item">
			<h4 class="title">Var Filter</h4>
			<div class="option_area">
				<div class="input_cover single">
					<input type="text" class="lw_input" id="arcVarFilter" name="arcVarFilter" value="${resultMap.VarFilter}" />
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
	<ul class="mgB10">
	 <button class="cmm-btn2 mgR5 mgT10 floatR" style="height: 30px;" onclick="updateArchitecture()" value="Save">Save</button>	
	</ul>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</div>
</form>
