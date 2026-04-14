<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!--1. Include JSP -->
<!--  <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />

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

		var viewType ="${viewType}";
		if (viewType =="N") {
			fnSelect('objItemTypeCode', '', 'itemTypeCode', '','Select');
		}else {
			fnSelect('itemTypeCode','','itemTypeCode','${resultMap.ItemTypeCode}','Select');		
		}
		//ZoomOption select
		$("#zoomOption").val("${resultMap.ZoomOption}").prop("selected",true);
		

	});

	function updateModelType() {
	
		
		var viewType =$("#viewType").val();
		if (viewType=="N") {
		  saveModelFlow();
		}else {
			
		if (confirm("${CM00001}")) {
			var checkConfirm = false;			
			if ('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()) {
				if (confirm("${CM00006}")) {
					checkConfirm = true;
				}
			} else {
				checkConfirm = true;
			}
			if (checkConfirm) {	

			
					var url = "admin/updateModelType.do?viewType="+viewType;		
					ajaxSubmit(document.ModelTypeViewList, url,"saveFrame");
				
				}
			}
		}
		
	}
	function saveModelFlow(){		
		if(confirm("${CM00001}")){			
			var checkConfirm = false;							
			if('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()){
				alert("${WM00065}");
				checkConfirm = false;
			}	
			else{ checkConfirm = true;}			
			if(checkConfirm){				
				var url = "saveModelType.do";
				ajaxSubmit(document.ModelTypeViewList, url, "saveFrame");
			}
		}
	}


	function goBack() {
		var url = "modelType.do";
		var data = "&pageNum=" + $("#CurrPageNum").val();
		var target = "modelTypeDiv";
		ajaxPage(url, data, target);
	}
	
	function CheckBox1(){		
		var chk1 = document.getElementsByName("check1");		
		if(chk1[0].checked == true){			
			$("#objIsModel").val("1");
		}else{		
			$("#objIsModel").val("0");
		}
	
	}

	function ModelTypeReload(viewType){	
		
		if (viewType =="N") {
		
			
			goBack();
		}else {
			
		var url    = "modelTypeView.do"; // 요청이 날라가는 주소
		var data   = "ModelTypeCode=${resultMap.ModelTypeCode}" +
					 "&languageID="+$("#getLanguageID").val() +
					 "&pageNum=" + $("#CurrPageNum").val() +
					 "&viewType="+ $("#viewType").val()+
					  "&ItemTypeCode=${resultMap.ItemTypeCode}"+
					 "&Name=" + $("#Name").val();
		var target = parent;		
		ajaxPage(url,data,target);
		}
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
	<form name="ModelTypeViewList" id="ModelTypeViewList" action="saveWorkFlowType.do" method="post" onsubmit="return false;">
	<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
	
	<c:choose>
	 <c:when test="${viewType == 'N'}">
	
		 <input type="hidden" id="SaveType" name="SaveType" value="New" />
		    <input type="hidden" id="orgTypeCode" name="orgTypeCode" />  
		 <input type="hidden" id="Creator" name="Creator" value="${sessionScope.loginInfo.sessionUserId}"/>
		 <input type="hidden" id="LanguageID" name="LanguageID" value="${languageID}"/>
	</c:when>
	 <c:otherwise>
	
		<input type="hidden" id="SaveType" name="SaveType" value="Edit" /> 
	</c:otherwise>
	</c:choose>
		<input type="hidden" id="orgLastUser" name="orgLastUser" value="${sessionScope.loginInfo.sessionUserId}" />
		<input type="hidden" id="Name" name="Name" value="${Name}">  
		<input type="hidden" id="ModelTypeCode" name="ModelTypeCode" value="${resultMap.ModelTypeCode}"> 
		<input type="hidden" id="CurrPageNum" name="CurrPageNum" value="${pageNum}">
		<input type="hidden" id="objIsModel" name="objIsModel" value="${resultMap.IsModel}">
		<input type="hidden" id="cfgCode" name="cfgCode" value="${cfgCode}">
		<input type="hidden" id="viewType" name="viewType" value="${viewType}">
  	   <c:if test="${viewType == 'N'}">
  	
		<div class="title-section flex align-center justify-between">
			<span class="flex align-center">
				<span class="back" onclick="goBack()"><span class="icon arrow"></span></span>
				<span id="title">${menu.LN00005}</span>
			</span>
		</div>
		</c:if>

		<div class="contents_body_inner mgL30">
			<ul class="detail_settings_list mgT10">
				<!-- 언어 -->
				<li class="item">
					<h4 class="title">${menu.LN00147}</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="getLanguageID" name="getLanguageID" class="lw_btn_select" onchange="ModelTypeReload()"></select>
						</div>
					</div>
				</li>
				<li class="item">
				<!-- Code -->
					<h4 class="title">${menu.LN00015}</h4>
					<div class="option_area">
						<div class="input_cover">
						    <c:choose>
						        <c:when test="${viewType == 'N'}">
						           <input type="text" class="lw_input" id="objWFID"	name="objMaxModelTypeCode" value="${MaxModelTypeCode}" onkeyup="fnOnlyEnNum(this);" onchange="fnOnlyEnNum(this);"/>		
						        </c:when>
						        <c:otherwise>
						            <input type="text" class="lw_input" value="${resultMap.ModelTypeCode}" disabled/>
						        </c:otherwise>
						    </c:choose>
						</div>
					</div>
					
					
				<!-- 명칭 -->
					<h4 class="title">${menu.LN00028}</h4>
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input" id="objName" name="objName" value="${resultMap.Name}" />
						</div>
					</div>
				</li>
			
				<li class="item">
				<!-- 항목유형 -->
					<h4 class="title">${menu.LN00021}</h4>
					<div class="option_area">
						<div class="input_cover">
						<c:choose>
						        <c:when test="${viewType == 'N'}">
						         	<select id="objItemTypeCode" name="objItemTypeCode" class="lw_btn_select">
									<option value="">Select</option>
									<c:forEach var="i" items="${itemTypeCode}">
										<option value="${i.CODE}" data-image="${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/ICON_${i.CODE}.png" <c:if test="${i.CODE eq resultMap.DefSymCode}"> selected="selected"</c:if>>${i.NAME}</option>
									</c:forEach>
								</select>	
						        </c:when>
						        <c:otherwise>
						         <select id="itemTypeCode" name="itemTypeCode" class="lw_btn_select">
									<option value="">Select</option>
									<c:forEach var="i" items="${itemTypeCode}">
										<option value="${i.CODE}" data-image="${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/ICON_${i.CODE}.png" <c:if test="${i.CODE eq resultMap.DefSymCode}"> selected="selected"</c:if>>${i.NAME}</option>
									</c:forEach>
								</select>
						        </c:otherwise>
						    </c:choose>
							
						</div>
					</div>
					<!--ArisTypeNum  -->
					<h4 class="title">ArisTypeNum</h4>
					<div class="option_area">
						<div class="input_cover">
							<input type="text" class="lw_input" id="C" name="ArisTypeNum" value="${resultMap.ArisTypeNum}" />
						</div>
					</div>
				</li>
				 <c:choose>
					<c:when test="${viewType == 'N'}">	         
					</c:when>
					<c:otherwise>							        
				<li class="item">
					<!--  최종수정자 -->
					<h4 class="title">${menu.LN00105}</h4>
					<div class="option_area">
						<div class="input_cover">
						<input type="text" class="lw_input" value="${resultMap.LastUserName}" disabled/>
							
						</div>
					</div>
					<!--  수정일 -->
					<h4 class="title">${menu.LN00070}</h4>
					<div class="option_area">
						<div class="input_cover">
						<input type="text" class="lw_input" value="${resultMap.LastUpdated}" disabled/>
							
						</div>
					</div>
				</li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${viewType == 'N'}">	 
					<li class="item">
					<h4 class="title">ZoomOption</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="zoomOption" name="zoomOption" class="lw_btn_select">
								<option value="">Select</option>
								<option value="FTW">Fit To Window</option>
								<option value="FTP">Fit To Page</option>
							</select>
						</div>
					</div>
					
				</li>        
					</c:when>
					<c:otherwise>
				<!--ismodel  -->
				<li class="item">
					<h4 class="title">IsModel</h4>
					<div class="option_area">
						<div class="input_cover">
							
							<input type="checkbox" class="lw_toggle" id="check1" name="check1" <c:if test="${resultMap.IsModel == '1'}">checked="checked"</c:if> value="${resultMap.IsModel}" onclick="CheckBox1()">
							<label for="check1"></label>
						</div>
					</div>			
				<!--ZoomOption  -->
		
					<h4 class="title">ZoomOption</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="zoomOption" name="zoomOption" class="lw_btn_select">
								<option value="">Select</option>
								<option value="FTW">Fit To Window</option>
								<option value="FTP">Fit To Page</option>
							</select>
						</div>
					</div>
					
				</li>
					</c:otherwise>
				</c:choose>
			
				
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
				<button class="cmm-btn2 mgR5 mgB20" style="height: 30px;" onclick="updateModelType()" value="Save">Save</button>
			</span>
					
			</c:if>
		</div>

	</form>
</div>
  
	<iframe name="WorkFlowSaveFrame" id="WorkFlowSaveFrame" src="about:blank" style="display: none" frameborder="0"></iframe>
	<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="saveFrame" id="saveFrame" src="about:blank"
				style="display: none;" frameborder="0" scrolling='no'></iframe>
		</div>