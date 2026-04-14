<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 <!DOCTYPE html>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script type="text/javascript">
	var chkReadOnly = false;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> 

<head>
<style>
	#itemDiv > div {
		padding : 10px 10px;
	}
	#itemDiv li > div > label {
		margin-top: 10px;
		width: 100px !important;
	}
</style>
<script type="text/javascript">

	$(document).ready(function(){				
		$("input.datePicker").each(generateDatePicker);			
		
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function getAttrLovList(avg, avg2, avg3){ 
		var url    = "getSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&sqlID=attr_SQL.selectAttrLovOption" //파라미터들					
					+"&s_itemID="+avg
					+"&itemID=${s_itemID}";
					
		var target = avg; // avg;             // selectBox id
		var defaultValue = avg2;              // 초기에 세팅되고자 하는 값
		var isAll  = "";                      // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
	
	function fnGetSubAttrTypeCode(attrCode,subAttrCode,lovCode){ 
		if(subAttrCode != "" && subAttrCode != null){			
			var data = "languageID=${sessionScope.loginInfo.sessionCUrrLangType}&lovCode="+lovCode
			fnSelect(subAttrCode, data, 'getSubLovList', 'Select');
		}
	}
	
	function fnCreateItemMst(s_itemID){		
		var csrID = parent.$("#csrID").val();
		var classCode = parent.$("#classCode").val();
		var identifier = parent.$("#identifier").val();
		var itemName = parent.$("#itemName").val();
		var dimTypeID = parent.$("#dimTypeID").val();
		var dimTypeValueID= parent.$("#dimTypeValueID").val();
		let subDimTypeValueID = parent.$("#subDimTypeValueID").val();
		
		var autoID= parent.$("#autoID").val();
		var preFix= parent.$("#preFix").val();
		
		$("#s_itemID").val(s_itemID);
		$("#csrID").val(csrID);
		$("#classCode").val(classCode);
		$("#identifier").val(identifier);
		$("#itemName").val(itemName);
		$("#dimTypeID").val(dimTypeID);
		$("#dimTypeValueID").val(dimTypeValueID);
		$("#subDimTypeValueID").val(subDimTypeValueID);
		
		$("#autoID").val(autoID);
		$("#preFix").val(preFix);
		
		var mLovCode = "";
		var AttrTypeValue;
		var mLovCodeValue;
		var k; var l;
		var dataType = "";
		<c:forEach var="i" items="${attrAllocList}" varStatus="iStatus">
		    AttrTypeValue = new Array;
		    mLovCodeValue = new Array;
		    k=0;
		    dataType = "${i.DataType}";
			<c:if test="${i.DataType == 'MLOV'}" >
				<c:forEach var="mLovList" items="${i.mLovList}" varStatus="status">
					mLovCode = "${mLovList.AttrTypeCode}"+"${mLovList.CODE}";
					var checkObj = document.all(mLovCode);
					if (checkObj.checked) {
						AttrTypeValue[k] = $("#"+mLovCode).val();
						mLovCodeValue[k] = $("#"+mLovCode).val();
						k++;
					}				
				</c:forEach>
				$("#"+"${i.AttrTypeCode}").val(mLovCodeValue);
			</c:if>
			
			l=0;
		    dataType = "${i.DataType2}";
		  
			<c:if test="${i.DataType2 == 'MLOV'}" >
			  AttrTypeValue = new Array;
			    mLovCodeValue = new Array;
				<c:forEach var="mLovList2" items="${i.mLovList2}" varStatus="status">
					mLovCode = "${mLovList2.AttrTypeCode}"+"${mLovList2.CODE}";
					var checkObj = document.all(mLovCode);
					if (checkObj.checked) {
						AttrTypeValue[l] = $("#"+mLovCode).val();
						mLovCodeValue[l] = $("#"+mLovCode).val();
						l++;
					}				
				</c:forEach>
				$("#"+"${i.AttrTypeCode2}").val(mLovCodeValue);
			</c:if>
		</c:forEach>
		
		var url = "createItemMst.do";	
		ajaxSubmit(document.attrFrm, url);
	}
	
	function fnCallBack(s_itemID){
		parent.fnCallBackCreateItemMST(s_itemID);
	}
	
</script>
</head>
<form name="attrFrm" id="attrFrm" action="#" method="post" onsubmit="return false;" style="height: 100%;"> 
	<input type="hidden" id="s_itemID" name="s_itemID" >
	<input type="hidden" id="csrID" name="csrID" >
	<input type="hidden" id="classCode" name="classCode" >
	<input type="hidden" id="identifier" name="identifier" >
	<input type="hidden" id="itemName" name="itemName" >
	<input type="hidden" id="dimTypeID" name="dimTypeID" >
	<input type="hidden" id="dimTypeValueID" name="dimTypeValueID" >
	<input type="hidden" id="subDimTypeValueID" name="subDimTypeValueID" >
	<input type="hidden" id="fltpCode" name="fltpCode" value="FLTP001" >
	<input type="hidden" id="autoID" name="autoID">
	<input type="hidden" id="preFix" name="preFix">
	<div style="width:100%;height: 100%;overflow-y:auto;overflow-x:hidden;">
		<div id="itemDiv">			
			<div class="mgB30">
				<ul>
				<c:forEach var="i" items="${attrAllocList}" varStatus="iStatus">
					<li class="pdL10 pdR10 mgB15 <c:if test="${i.ColumnNum2 eq '2'}">flex</c:if>">
						<div style="flex: 1 1 0;" class="flex">
						<label for="${i.AttrTypeCode}"><c:if test="${i.Mandatory eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name}</label>
						<c:choose>
							<c:when test="${i.DataType eq 'Text'}">	
								<c:choose>
									<c:when test="${i.HTML eq '1'}">
										<div style="width:100%;height:${i.AreaHeight}px;">
											<textarea class="tinymceText" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" ></textarea>
										</div>
									</c:when>
									<c:when test="${i.HTML ne '1'}">
										<textarea class="form-input" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" class="form-input" rows="1" style="flex: 1 1 0;width:100%;height:${i.AreaHeight}px;<c:if test="${i.AreaHeight < 100 }">max-height:100px;</c:if>"></textarea>
									</c:when>
								</c:choose>
							</c:when>
							<c:when test="${i.DataType eq ''}">	
								<c:choose>
									<c:when test="${i.HTML eq '1'}">
										<div style="width:100%;height:40px;">
											<textarea class="tinymceText" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" ></textarea>
										</div>
									</c:when>
									<c:when test="${i.HTML ne '1'}">
										<input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" class="form-input" value="${i.PlainText}" class="text">
									</c:when>
								</c:choose>
							</c:when>
							<c:when test="${i.DataType eq 'LOV'}">
								<select id="${i.AttrTypeCode}" name="${i.AttrTypeCode}"  class="form-sel" style="width:100%;" onchange="fnGetSubAttrTypeCode('${i.AttrTypeCode}','${i.SubAttrTypeCode}',this.value);" ></select>
							<script>
								getAttrLovList('${i.AttrTypeCode}','${i.LovCode}', '${i.SubAttrTypeCode}');
							</script>
							</c:when>
							<c:when test="${i.DataType eq 'MLOV'}">
								<input type="hidden" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" />
								<div class="hgt40 flex align-center">
								<c:forEach var="mLovList" items="${i.mLovList}" varStatus="status">
								<input type="checkbox" id="${mLovList.AttrTypeCode}${mLovList.CODE}" name="${mLovList.AttrTypeCode}${mLovList.CODE}" value="${mLovList.CODE}"
								<c:if test="${mLovList.LovCode == mLovLis.CODE}" > checked </c:if> class="mgR5">
								<label for="${mLovList.AttrTypeCode}${mLovList.CODE}" class="mgR20">${mLovList.NAME}</label>
								</c:forEach>
								</div>
							</c:when>	
							<c:when test="${i.DataType eq 'Date'}">
							<ul>
								<li>
									<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
									<span class="wrap_sbj">
									<input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="${i.PlainText}"	class="text datePicker" size="8"
											style="width: 180px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
									</span>
								</li>
							</ul>
							</c:when>	
						</c:choose>
					</div>
					
					
					<c:if test="${i.ColumnNum2 eq '2'}">
						<div class="pdL35 flex" style="flex:1 1 0;">
							<label for="${i.AttrTypeCode2}"><c:if test="${i.Mandatory2 eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name2}</label>
							<c:choose>
							<c:when test="${i.DataType2 eq 'Text'}">
									<c:choose>
										<c:when test="${i.HTML2 eq '1'}">
											<script type="text/javascript">
												tinyMCE.EditorManager.execCommand('mceRemoveEditor', false, "${i.AttrTypeCode}");
											</script>
											<div style="width:100%;height:${i.AreaHeight}px;">
												<textarea class="tinymceText" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" >${i.PlainText2}</textarea>
											</div>
										</c:when>
										<c:when test="${i.HTML2 ne '1'}">
											<textarea class="form-input" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" class="form-input" rows="1" style="flex: 1 1 0;width:100%;height:${i.AreaHeight2}px;<c:if test="${i.AreaHeight2 < 100 }">max-height:100px;</c:if>">${i.PlainText2}</textarea>
										</c:when>
									</c:choose>
							</c:when>
							<c:when test="${i.DataType2 eq ''}">	
								<c:choose>
									<c:when test="${i.HTML2 eq '1'}">
										<div style="width:100%;height:40px;">
											<textarea class="tinymceText" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" >${i.PlainText2}</textarea>
										</div>
									</c:when>
									<c:when test="${i.HTML2 ne '1'}">
										<input type="text" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" class="form-input" value="${i.PlainText2}" class="text">
									</c:when>
								</c:choose>
							</c:when>
							<c:when test="${i.DataType2 eq 'LOV'}">		
								<select id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}"  class="form-sel" style="width:100%;" onchange=fnGetSubAttrTypeCode('${i.AttrTypeCode2}','${i.SubAttrTypeCode2}',this.value);></select>
								<script>
									getAttrLovList('${i.AttrTypeCode2}','${i.LovCode2}','${i.SubAttrTypeCode2}');
								</script>					 
							</c:when>
							<c:when test="${i.DataType2 eq 'MLOV'}">
								<input type="hidden" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" />
								<div class="hgt40 flex align-center">
							 	<c:forEach var="mLovList2" items="${i.mLovList2}" varStatus="status">
								<input type="checkbox" id="${mLovList2.AttrTypeCode}${mLovList2.CODE}" name="${mLovList2.AttrTypeCode}${mLovList2.CODE}" value="${mLovList2.CODE}"
								<c:if test="${mLovList2.LovCode == mLovList2.CODE}" > checked </c:if> class="mgR5">
								<label for="${mLovList2.AttrTypeCode}${mLovList2.CODE}" class="mgR20">${mLovList2.NAME}</label>
								</c:forEach>
								</div>
							</c:when>	
							
							<c:when test="${i.DataType2 eq 'Date'}">
							<ul>
								<li>
									<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
									<span class="wrap_sbj">
									<input type="text" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" value="${i.PlainText2}"	class="text datePicker" size="8"
											style="width: 180px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
									</span>
								</li>
							</ul>
							</c:when>
							</c:choose>
						</div>
						</c:if>
					</li>
				</c:forEach>
				</ul>
			</div>
		</div>
	</div>
</form>
<script>
/* document.querySelectorAll("textarea:not(.tinymceText)").forEach((textarea) => {
textarea.addEventListener("keyup", e => {
	if(e.target.style.maxHeight){
		let scHeight = e.target.scrollHeight+2;
		console.log(scHeight)
		if(scHeight > e.target.style.maxHeight.replace(/[^0-9]/g,'')) e.target.style.overflow = "auto";
		else e.target.style.overflow = "hidden";
		textarea.style.height = scHeight+"px";
	}
});
}); */


document.querySelectorAll("textarea:not(.tinymceText)").forEach(function (element) {
	const originH = element.style.height.replace(/[^0-9]/g,'');
	const offset = element.offsetHeight - element.clientHeight;
    element.addEventListener('input', function (e) {
    	if(e.target.style.maxHeight){
    		e.target.style.height = 'auto';
	    		console.log(e.target.scrollHeight, originH)
    		if(e.target.scrollHeight > originH) {
	      		e.target.style.height = e.target.scrollHeight + offset + 'px';
    		} else if(e.target.scrollHeight - 20 < originH) {
    			e.target.style.height = originH + 'px';
    		}
    	}
    });
  });
</script>

<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
