<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />

<!--1. Include JSP -->
<!--  <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />

<!-- Script -->
<script type="text/javascript">

	$(document).ready(function() {
		
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});

		fnSelect('getLanguageID', '', 'langType', '${languageID}', 'Select');
		fnSelect('ObjCategory', '', 'ObjCategoryCode', '${resultMap.Category}', 'Select');
		if('${viewType}' =='N'){
			
		fnSelect('Category', '', 'ObjCategoryCode', '${Category}', 'Select');
		}
		$('#CategoryCode').change(function(){changeObjectType($(this).val());});
	});

	function UpdateObjectType() {
		if (confirm("${CM00001}")) {
			var checkConfirm = false;
			if ('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()) {
				if (confirm("${CM00006}")) {
					checkConfirm = true;
				}
			} else {
				checkConfirm = true;
			}

			if(checkConfirm) {
				var url = "admin/UpdateObjectType.do";
				ajaxSubmit(document.ObjectTypeViewList, url, "blankFrame");
			}
		}

	}
	function saveAttrribute() { 
		
		//if(confirm("저장하시겠습니까?")){
		if(confirm("${CM00001}")){
					
					var checkConfirm = false;					
					/*if('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()){
						alert("선택된 언어와 로그인된 언어가 다릅니다.");
						checkConfirm = false;
					}*/					
					if('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()){
						//alert("선택된 언어와 로그인된 언어가 다릅니다.");
						alert("${WM00065}");
						checkConfirm = false;
					}	
					else{ 
						checkConfirm = true;
					}			
					if(checkConfirm){
						
						var url = "admin/SaveObjectType.do";
		
						ajaxSubmit(document.ObjectTypeViewList, url, "blankFrame");
					}
				}

	  }
		

	function goBack() {
		var url = "DefineObjectType.do";
		var data ="&selectedCat=${selectedCat}&selectedItemType=${selectedItemType}&cfgCode=${cfgCode}";
		var target = "objectTypeDiv";
		
		ajaxPage(url, data, target);
	}
	
	function CheckBox1(){
		
		var chk1 = document.getElementsByName("check1");
		
		if(chk1[0].checked == true)
		{
			
			$("#objDeactivated").val("1");
		}
		else{
			
			$("#objDeactivated").val("0");
		}
		
	}

function objReload(){
	var url    = "objectTypeView.do"; // 요청이 날라가는 주소
	var data   = "languageID="+$("#getLanguageID").val() +
				 "&ItemTypeCode="+$("#objItemTypeCode").val() +
				 "&pageNum=" + $("#currPage").val();
	var target = "objectTypeDiv";
	ajaxPage(url,data,target);
}

function onlyNumber(){
	if((event.keyCode < 48) || (event.keyCode > 57)){
		event.returnValue = false;
	}
}

// [Allocation] click
function editAttrSortNum() {
	var url = "editAttrSortNumPop.do?";
	var data = "itemTypeCode=${resultMap.ItemTypeCode}";
	var option = "width=600,height=800,left=300,top=100,toolbar=no,status=no,resizable=yes";
    window.open(url+data, self, option);
}

function fnOnlyEnNum(obj){
	var regType = /^[A-Za-z0-9*]+$/;
    if(!regType.test(obj.value)) {
        obj.focus();
        $(obj).val( $(obj).val().replace(/[^A-Za-z0-9]/gi,"") );
        return false;
    }
}

//[OBJECT] 값 설정
function changeObjectType(avg1){
	var url    = "getObjectTypeList.do"; // 요청이 날라가는 주소
	var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+avg1; //파라미터들
	var target = "ItemTypeCode";             // selectBox id
	var defaultValue = "";              // 초기에 세팅되고자 하는 값
	var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
	
	ajaxSelect(url, data, target, defaultValue, isAll);
}


function saveClassType() {
	// [OBJECT 필수 체크]
	/*
	if('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()){
		//alert("선택된 언어와 로그인된 언어가 다릅니다.");
		alert("${WM00065}");
		return false;
	}*/
			
	if($("#ItemTypeCode").val() == ""){
		//alert("Object을 선택하세요.");
		alert("${WM00041}");
		return false;
	}
	
	//if(confirm("저장하시겠습니까?")){
	if(confirm("${CM00001}")){
		var url = "admin/saveClassType.do";
		ajaxSubmit(document.ObjectTypeViewList, url, "blankFrame");
	}	
}
</script>

<form name="ObjectTypeViewList" id="ObjectTypeViewList" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
	<div id="groupListDiv" class="hidden" style="width: 100%; height: 100%;">
		<c:choose>
				<c:when test="${viewType == 'N'}">
				 <input type="hidden" id="SaveType" name="SaveType" value="New" />
				 <input type="hidden" id="Creator" name="Creator" value="${sessionScope.loginInfo.sessionUserId}"/>
				 <input type="hidden" id="viewType" name="viewType" value="${viewType}"/> 
				 <input type="hidden" id="LanguageID" name="LanguageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
				</c:when>
				<c:otherwise>
				<input type="hidden" id="orgLastUser" name="orgLastUser" value="${sessionScope.loginInfo.sessionUserId}" />
				<input type="hidden" id="SaveType" name="SaveType" value="Edit" /> 
				<input type="hidden" id="objDeactivated" name="objDeactivated" value="${resultMap.Deactivated}">
				<input type="hidden" id="objItemTypeCode" name="objItemTypeCode" value="${resultMap.ItemTypeCode}">
				<input type="hidden" id="currPage" name="currPage" value="${pageNum}"/> 
				<input type="hidden" id="viewType" name="viewType" value="${viewType}"/> 
				</c:otherwise>
			</c:choose>
		
		
	</div>
	<div class="title-section flex align-center justify-between">
		<span class="flex align-center">
			<span class="back" onclick="goBack()"><span class="icon arrow"></span></span>
			<c:choose>
				<c:when test="${viewType == 'N'}">
				<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00005}</p>
				</c:when>
				<c:otherwise>
				  <span id="title">Edit Object Type</span>			
				
				</c:otherwise>
			</c:choose>
		</span>

	</div>

	<div class="contents_body_inner mgL30">
			<ul class="detail_settings_list mgT10">
				<!-- 언어 -->
						<c:choose>
						 <c:when test="${viewType == 'N'}">
						 <li class="item">
						 <h4 class="title">${menu.LN00147}</h4>
							<div class="option_area">
								<div class="input_cover">
								 	 <select id="getLanguageID" name="getLanguageID" class="lw_btn_select" disabled="disabled"></select>
								 </div>
							</div>
						</li>
						  </c:when>	
						  <c:when test="${viewType == 'C'}">
						  
						  </c:when>				
						  <c:otherwise>
						  <li class="item">
						   <h4 class="title">${menu.LN00147}</h4>
							<div class="option_area">
								<div class="input_cover">
							 	<select id="getLanguageID" name="getLanguageID" class="lw_btn_select" onchange="objReload()"></select>
								</div>
							</div>
							</li>
						  </c:otherwise>
						</c:choose>
		
				<li class="item">
				<!-- Code -->
				  <h4 class="title">${menu.LN00015}</h4>
						<div class="option_area">
						<div class="input_cover">
				   <c:choose>
				    <c:when test="${viewType == 'N'}">					
				    	<input type="text" class="lw_input" id="objItemTypeCode" name="objItemTypeCode" value="${MaxObjectTypeCode}"  onkeyup="fnOnlyEnNum(this);" onchange="fnOnlyEnNum(this);"/>
					</c:when>
					<c:when test="${viewType == 'C'}">					        
						<input type="text" class="lw_input" id="objType" name="objType" maxlength="10" STYLE='IME-MODE:DISABLED'  onkeyup="fnOnlyEnNum(this);" onchange="fnOnlyEnNum(this);"/>
					</c:when>
					    <c:otherwise>
					    <input type="text" class="lw_input" value="${resultMap.ItemTypeCode}" disabled/>
					    </c:otherwise>
					</c:choose>
					</div>
					</div>
				<!-- 명칭 -->
					<h4 class="title">${menu.LN00028}</h4>
					<div class="option_area">
						<div class="input_cover">
						<c:choose>
							<c:when test="${viewType == 'N'}">
							<input type="text" class="lw_input" id="objName" name="objName" />
							</c:when>
							<c:otherwise>
							
							<input type="text" class="lw_input" id="objName" name="objName" value="${resultMap.Name}" />
							 </c:otherwise>
						</c:choose>
						</div>
					</div>
				</li>
			
				
				<!-- icon -->
				<c:if test="${viewType == ' ' }">
				<li class="item">
						<h4 class="title">
					 <c:if test="${!empty resultMap.Icon}"><img src="${root}${HTML_IMG_DIR_ITEM}/${resultMap.Icon}"/></c:if>
					  <c:if test="${empty resultMap.Icon}">Icon</c:if>
					</h4>
					<div class="option_area">
						<div class="input_cover">
						<input type="text" class="lw_input" id="objIcon" name="objIcon" value="${resultMap.Icon}" />
					    </div>
					</div>	
					
					<!-- DefArc -->
					<h4 class="title">DefArc</h4>
					<div class="option_area">
						<div class="input_cover">
						<input type="text"  class="lw_input" id="objDefArc" name="objDefArc" value="${resultMap.DefArc}"/>
					
						</div>
					</div>
					</li>
				</c:if>
			
						        
					<!--  RootItemID -->
						
						  <li class="item">
						<c:choose>
						  <c:when test="${viewType == 'N'}">
							<h4 class="title">RootItemID</h4>
							<div class="option_area">
								<div class="input_cover">
						  
							<input type="text" class="lw_input" id="objRootItemId" name="objRootItemId" />	
							</div>
					      </div>													
						  </c:when>
						  <c:when test="${viewType == 'C'}">
						 <h4 class="title">Category</h4>
						 <div class="option_area" style="widows: 100%">
						  <select id="CategoryCode" name="CategoryCode">
							<option value=""></option>
							<c:forEach var="i" items="${CategoryOption}">
								<option value="${i.Category}">${i.Category}</option>						
							</c:forEach>				
							</select>
							</div>
						  </c:when>
						  <c:otherwise>
						  <!--  Category -->
						    <h4 class="title">RootItemID</h4>
							<div class="option_area">
							<div class="input_cover">
						  
						  	<input type="text" class="lw_input" id="objRootItemId" name="objRootItemId" value="${resultMap.RootItemID}" onkeypress="onlyNumber();" style="ime-mode:disabled"/>
						  </div>
						  </div>
						
						  </c:otherwise>
						</c:choose>		
					
				  <!-- OBJECT -->
					<c:choose>
					<c:when test="${viewType == 'C'}">
					<h4 class="title">OBJECT</h4>
					<div class="option_area">
						<div class="input_cover">
						<select id="ItemTypeCode" name="ItemTypeCode" style="width: 100%"></select>
							
						</div>
					</div>
					</c:when>
					<c:otherwise>
						<!--  Category -->
					<h4 class="title">Category</h4>
					<div class="option_area">
						<div class="input_cover">
							<select id="ObjCategory" name="ObjCategory"></select>
						</div>
					</div>
					</c:otherwise>	
					</c:choose>
					
				</li>
			<!-- Deactivated -->
		
				<li class="item">
					<h4 class="title">Deactivated</h4>
					<div class="option_area">
						<div class="input_cover">			
							<input type="checkbox" class="lw_toggle" id="check1" name="check1" 
							<c:if test="${resultMap.Deactivated == '1'}">checked="checked"</c:if> 
							value="${resultMap.Deactivated}" onclick="CheckBox1()">
							<label for="check1"></label>
						</div>
					</div>		
	
				<!--작성자 -->
				<c:if test="${viewType == ''}">
					<h4 class="title">${menu.LN00060}</h4>
					<div class="option_area">
						<div class="input_cover">
					
						<div>${resultMap.CreateName}</div>
				
						</div>
					</div>
					
				</li>
				</c:if>
				<!-- 생성일  -->
				<c:if test="${viewType == ''}">		
				<li class="item">
					<h4 class="title">${menu.LN00013}</h4>
					<div class="option_area">
						<div class="input_cover single">
							${resultMap.CreationTime}
						</div>
					</div>
				</li>
				</c:if>
				<!-- Description -->
					<li class="item">
					<h4 class="title">Description</h4>
					<div class="option_area">
						<div class="input_cover single">
							<c:choose>
						  <c:when test="${viewType == 'N'}">
							<input type="text" class="lw_input" id="objDescription" name="objDescription" />								
						  </c:when>
						  <c:otherwise>
						  	<input type="text" class="lw_input" id="objDescription" name="objDescription" value="${resultMap.Description}" />
						  </c:otherwise>
						</c:choose>	
							
						</div>
					</div>
				</li>
			</ul>
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="mgT15 mgR10 floatR">
			<!-- 	<button class="cmm-btn2 mgR5 mgB20" style="height: 30px;" onclick="updateModelType()" value="Save">Save</button>
				 -->
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}"> 
				<c:choose>
			    	<c:when test="${viewType == 'N'}">
					<button class="cmm-btn2 mgR5" style="height: 30px;" onclick="saveAttrribute()" value="Save">Save</button>
			    	</c:when>
			    	<c:when test="${viewType == 'C'}">
			    	<button class="cmm-btn2 mgR5" style="height: 30px;" onclick="saveClassType()" value="Save">Save</button>
			    	</c:when>
				    <c:otherwise>						
					<button class="cmm-btn mgR5" style="height: 30px;" onclick="editAttrSortNum();" value="Allocation" >Allocation</button>
					<button class="cmm-btn2 mgR5" style="height: 30px;" onclick="UpdateObjectType()" value="Save">Save</button>
					</c:otherwise>
				</c:choose>		
				</c:if>	 	
			</span>
					
			</c:if>
		</div>
</form>
	
<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
</div>
		

