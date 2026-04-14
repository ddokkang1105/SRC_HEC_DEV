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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var chkReadOnly = false;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> 

<head>
<style>
	#itemDiv > div {
		padding : 10px 10px;
		height : 450px;
		overflow-y: auto;
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
	
	function fnSaveItemMst(itemID,s_itemID){	
		console.log("fnSaveItemMST itemID :"+itemID );
		var csrID = parent.$("#csrID").val();
		var classCode = parent.$("#classCode").val();
		var identifier = parent.$("#identifier").val();
		var itemName = parent.$("#itemName").val();
		var dimTypeID = parent.$("#dimTypeID").val();
		var dimTypeValueID= parent.$("#dimTypeValueID").val();
		
		var autoID= parent.$("#autoID").val();
		var preFix= parent.$("#preFix").val();
		
		$("#itemID").val(itemID);
		$("#s_itemID").val(s_itemID);
		$("#csrID").val(csrID);
		$("#classCode").val(classCode);
		$("#identifier").val(identifier);
		$("#itemName").val(itemName);
		$("#dimTypeID").val(dimTypeID);
		$("#dimTypeValueID").val(dimTypeValueID);
		
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
		
		var url = "saveItemMst.do";	
		ajaxSubmit(document.attrFrm, url);
	}
	
	function fnCallBack(itemID){
		parent.fnCallBackSaveItemMST(itemID);
	}
	
</script>
</head>
<form name="attrFrm" id="attrFrm" action="#" method="post" onsubmit="return false;"> 
	<input type="hidden" id="s_itemID" name="s_itemID" >
	<input type="hidden" id="itemID" name="itemID" value="${itemID}" >
	<input type="hidden" id="csrID" name="csrID" >
	<input type="hidden" id="classCode" name="classCode" >
	<input type="hidden" id="identifier" name="identifier" >
	<input type="hidden" id="itemName" name="itemName" >
	<input type="hidden" id="dimTypeID" name="dimTypeID" >
	<input type="hidden" id="dimTypeValueID" name="dimTypeValueID" >
	<input type="hidden" id="fltpCode" name="fltpCode" value="FLTP001" >
	<input type="hidden" id="autoID" name="autoID">
	<input type="hidden" id="preFix" name="preFix">
	<div id="htmlReport" style="width:100%;overflow-y:auto;overflow-x:hidden;">
		<div id="itemDiv">			
			<div class="mgB30">
				<table style="table-layout:fixed;" class="tbl_preview" width="100%" border="0" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="12%">
						<col>
						<col width="12%">
						<col>
					</colgroup>	
					<c:forEach var="i" items="${attributesList}" varStatus="iStatus">
					<tr>	
					<c:choose>
						<c:when test="${iStatus.count eq 1 }">					
							<th class="alignC">
								<c:if test="${i.Mandatory eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name}
							</th>
							<td  class="alignL pdL10"
							<c:if test="${i.ColumnNum eq null || i.ColumnNum ne 1 }">colspan="3"</c:if>
							>
						</c:when>
						<c:when test="${iStatus.count ne 1 }">					
							<th class="alignC">
								<c:if test="${i.Mandatory eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name}
							</th>
							<td  class="tit"
							<c:if test="${i.ColumnNum eq null || i.ColumnNum ne 1 }">colspan="3"</c:if>
							>
						</c:when>					
					</c:choose>					
						
					<c:choose>
					<c:when test="${i.DataType eq 'Text'}">	
							<c:choose>
								<c:when test="${i.HTML eq '1'}">
									<div style="width:100%;height:${i.AreaHeight}px;">
										<textarea class="tinymceText" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" >${i.PlainText}</textarea>
									</div>
								</c:when>
								<c:when test="${i.HTML ne '1'}">
									<textarea class="edit" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" style="width:99%;height:${i.AreaHeight}px;">${i.PlainText}</textarea>
								</c:when>
							</c:choose>
					</c:when>
					<c:when test="${i.DataType eq ''}">	
						<c:choose>
							<c:when test="${i.HTML eq '1'}">
								<div style="width:100%;height:40px;">
									<textarea class="tinymceText" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" >${i.PlainText}</textarea>
								</div>
							</c:when>
							<c:when test="${i.HTML ne '1'}">
								<input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="${i.PlainText}" class="text">
							</c:when>
						</c:choose>
					</c:when>
					<c:when test="${i.DataType eq 'LOV'}">			
						<select id="${i.AttrTypeCode}" name="${i.AttrTypeCode}"  class="sel" OnChange="fnGetSubAttrTypeCode('${i.AttrTypeCode}','${i.SubAttrTypeCode}',this.value);" ></select>
					<script>
						getAttrLovList('${i.AttrTypeCode}','${i.LovCode}', '${i.SubAttrTypeCode}');
					</script>					 
					</c:when>
					<c:when test="${i.DataType eq 'MLOV'}">
						<input type="hidden" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" />
						 <c:forEach var="mLovList" items="${i.mLovList}" varStatus="status">				 
						 <input type="checkbox" id="${mLovList.AttrTypeCode}${mLovList.CODE}" name="${mLovList.AttrTypeCode}${mLovList.CODE}" value="${mLovList.CODE}"
						 <c:if test="${mLovList.LovCode == mLovList.CODE}" > checked </c:if>>&nbsp;${mLovList.NAME} &nbsp;&nbsp;
						 </c:forEach>			 
					</c:when>
					<c:when test="${i.DataType eq 'Date'}">
					<!-- 2013-11-15 Datapicker확인중 -->
					<ul>
						<li>
							<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
							 <input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="${i.PlainText}"	class="text datePicker" size="8"
									style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
							
						</li>
					</ul>
					</c:when>
					</c:choose>			
					</td>
						
						
					<!-- 두번째 컬럼 START  -->
					<c:if test="${i.ColumnNum2 eq '2'}"> 
					<c:choose>
						<c:when test="${iStatus.count eq 1 }">					
							<th class="alignC">
								<c:if test="${i.Mandatory2 eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name2}
							</th>
							<td  class="alignL pdL10">
						</c:when>
						<c:when test="${iStatus.count ne 1 }">					
							<th class="alignC">
								<c:if test="${i.Mandatory2 eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name2}
							</th>
							<td  class="tit">
						</c:when>					
					</c:choose>					
					
					<!-- Attr Type :: Text, Date, URL, Select(Have Lov Code) -->
					<!-- IF Type Text HTML USE(1) WHEN TEXTAREA or NotUse THEN TEXT -->			
					<c:choose>
					<c:when test="${i.DataType2 eq 'Text'}">	
							<c:choose>
								<c:when test="${i.HTML2 eq '1'}">
									<!-- <script type="text/javascript">
										tinyMCE.EditorManager.execCommand('mceRemoveEditor', false, "${i.AttrTypeCode}");
									</script> -->
									<div style="width:100%;height:${i.AreaHeight}px;">
										<textarea class="tinymceText" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" >${i.PlainText2}</textarea>
									</div>
								</c:when>
								<c:when test="${i.HTML2 ne '1'}">
									<textarea class="edit" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" style="width:100%;height:${i.AreaHeight2}px;">${i.PlainText2}</textarea>
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
								<input type="text" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" value="${i.PlainText2}" class="text">
							</c:when>
						</c:choose>
					</c:when>
					<c:when test="${i.DataType2 eq 'LOV'}">		
						<select id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}"  class="sel" OnChange=fnGetSubAttrTypeCode('${i.AttrTypeCode2}','${i.SubAttrTypeCode2}',this.value);></select>
						<script>
							getAttrLovList('${i.AttrTypeCode2}','${i.LovCode2}','${i.SubAttrTypeCode2}');
						</script>					 
					</c:when>
					<c:when test="${i.DataType2 eq 'MLOV'}">
						<input type="hidden" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" />
						 <c:forEach var="mLovList2" items="${i.mLovList2}" varStatus="status">				 
						 <input type="checkbox" id="${mLovList2.AttrTypeCode}${mLovList2.CODE}" name="${mLovList2.AttrTypeCode}${mLovList2.CODE}" value="${mLovList2.CODE}"
						 <c:if test="${mLovList2.LovCode == mLovList2.CODE}" > checked </c:if>>&nbsp;${mLovList2.NAME} &nbsp;&nbsp;
						 </c:forEach>			 
					</c:when>		
					
					<c:when test="${i.DataType2 eq 'Date'}">
					<!-- 2013-11-15 Datapicker확인중 -->
					<ul>
						<li>
							<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
							 <input type="text" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" value="${i.PlainText2}"	class="text datePicker" size="8"
									style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
							
						</li>
					</ul>
					</c:when>
					</c:choose>			
					</td>	
					</c:if> 
					<!-- 두번째 컬럼 END  -->
					</tr>
					
					</c:forEach>
				</table>
			</div>
		</div>
	</div>
</form>

<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
