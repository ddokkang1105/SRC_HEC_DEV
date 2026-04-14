<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>

<script>

	$(document).ready(function(){	
		$("input.datePicker").each(generateDatePicker);
		$("#TOT_CNT").html("${editChildItemAttrList.size()}");
		fnSetMultiSelectBox();
	});
	
	function fnSetMultiSelectBox(){
		<c:forEach var="list" items="${editChildItemAttrList}" varStatus="sts">
			<c:if test="${list.DataType1 == 'MLOV'}" >				
				$('#MLOV_${list.AttrTypeCode1}_${list.ItemID}').SumoSelect();	
			</c:if>
			<c:if test="${list.DataType2 == 'MLOV'}" >				
				$('#MLOV_${list.AttrTypeCode2}_${list.ItemID}').SumoSelect();				
			</c:if>
			<c:if test="${list.DataType3 == 'MLOV'}" >				
				$('#MLOV_${list.AttrTypeCode3}_${list.ItemID}').SumoSelect();	
			</c:if>
			<c:if test="${list.DataType4 == 'MLOV'}" >				
				$('#MLOV_${list.AttrTypeCode4}_${list.ItemID}').SumoSelect();	
			</c:if>
		</c:forEach>
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function getAttrLovList(avg, avg2, avg3, avg4){ 
		var url    = "getSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&sqlID=attr_SQL.selectAttrLovOption" //파라미터들					
					+"&s_itemID="+avg
					+"&itemID=${s_itemID}";
					
		var target = avg4; // avg;             // selectBox id
		var defaultValue = avg2;              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                      // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		
		ajaxSelect(url, data, target, defaultValue, isAll);
	}

	function fnGetSubAttrTypeCode(attrCode,subAttrCode,lovCode){ 
		if(subAttrCode != "" && subAttrCode != null){			
			var data = "languageID=${sessionScope.loginInfo.sessionCUrrLangType}&lovCode="+lovCode
			fnSelect(subAttrCode, data, 'getSubLovList', 'Select');
		}
	}
	
	function fnSaveChildItemAttr(){	
		if(confirm("${CM00001}")){	
			var mLovCodeValue;
			var j=0;
			var childItemIDs = new Array;
			<c:forEach var="i" items="${editChildItemAttrList}" varStatus="iStatus">
			    childItemIDs[j] = "${i.ItemID}"; j++;
			    
				<c:if test="${i.DataType1 == 'MLOV'}" >
					var mLovCodeValue = new Array();
					$("#MLOV_${i.AttrTypeCode1}_${i.ItemID} :selected").each(function(ii, el){ 
						mLovCodeValue.push($(el).val());
					});
					$("#${i.AttrTypeCode1}_${i.ItemID}").val(mLovCodeValue);
				</c:if>
				
				<c:if test="${i.DataType2 == 'MLOV'}" >
					var mLovCodeValue = new Array();
					$("#MLOV_${i.AttrTypeCode2}_${i.ItemID} :selected").each(function(ii, el){ 
						mLovCodeValue.push($(el).val());
					});
					
					$("#${i.AttrTypeCode2}_${i.ItemID}").val(mLovCodeValue);
				</c:if>
				
				<c:if test="${i.DataType3 == 'MLOV'}" >
					var mLovCodeValue = new Array();
					$("#MLOV_${i.AttrTypeCode3}_${i.ItemID} :selected").each(function(ii, el){ 
						mLovCodeValue.push($(el).val());
					});
					$("#${i.AttrTypeCode3}_${i.ItemID}").val(mLovCodeValue);
				</c:if>
				
				<c:if test="${i.DataType4 == 'MLOV'}" >
					var mLovCodeValue = new Array();
					$("#MLOV_${i.AttrTypeCode4}_${i.ItemID} :selected").each(function(ii, el){ 
						mLovCodeValue.push($(el).val());
					});
					$("#${i.AttrTypeCode4}_${i.ItemID}").val(mLovCodeValue);
				</c:if>				
			</c:forEach>
			$("#childItemIDs").val(childItemIDs);
			var url = "saveChildItemAttr.do";	
			ajaxSubmit(document.childItemList, url, "blankFrame");
		}
	}
	
	function fnCallBack(){
		var url = "editChildItemAttrList.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&varFilter=${attrTypeCodes}"; 
	 	ajaxPage(url, data, target);
	}
	
	function fnSaveChildItemAttrByRow(rowItemID){	
		if(confirm("${CM00001}")){	
			var mLovCodeValue;
			var j=0;
			var childItemIDs = new Array;
			var itemID = "";
			<c:forEach var="i" items="${editChildItemAttrList}" varStatus="iStatus">
			   
			    itemID = "${i.ItemID}";
			    if(itemID == rowItemID){
			    	 childItemIDs[j] = "${i.ItemID}"; j++;
					<c:if test="${i.DataType1 == 'MLOV'}" >
						var mLovCodeValue = new Array();
						$("#MLOV_${i.AttrTypeCode1}_${i.ItemID} :selected").each(function(ii, el){ 
							mLovCodeValue.push($(el).val());
						});
						$("#${i.AttrTypeCode1}_${i.ItemID}").val(mLovCodeValue);
					</c:if>
					
					<c:if test="${i.DataType2 == 'MLOV'}" >
						var mLovCodeValue = new Array();
						$("#MLOV_${i.AttrTypeCode2}_${i.ItemID} :selected").each(function(ii, el){ 
							mLovCodeValue.push($(el).val());
						});
						
						$("#${i.AttrTypeCode2}_${i.ItemID}").val(mLovCodeValue);
					</c:if>
					
					<c:if test="${i.DataType3 == 'MLOV'}" >
						var mLovCodeValue = new Array();
						$("#MLOV_${i.AttrTypeCode3}_${i.ItemID} :selected").each(function(ii, el){ 
							mLovCodeValue.push($(el).val());
						});
						$("#${i.AttrTypeCode3}_${i.ItemID}").val(mLovCodeValue);
					</c:if>
					
					<c:if test="${i.DataType4 == 'MLOV'}" >
						var mLovCodeValue = new Array();
						$("#MLOV_${i.AttrTypeCode4}_${i.ItemID} :selected").each(function(ii, el){ 
							mLovCodeValue.push($(el).val());
						});
						$("#${i.AttrTypeCode4}_${i.ItemID}").val(mLovCodeValue);
					</c:if>	
			    }
			</c:forEach>
			$("#childItemIDs").val(childItemIDs);
			var url = "saveChildItemAttr.do";	
			ajaxSubmit(document.childItemList, url, "blankFrame");
		}
	}

</script>	
<form name="childItemList" id="childItemList" method="post" onsubmit="return false;">
	<input type="hidden" id="childItemIDs" name="childItemIDs" >
	<input type="hidden" id="attrTypeCodes" name="attrTypeCodes" value="${attrTypeCodes}" >
	<input type="hidden" id="dataTypes" name="dataTypes" value="${dataTypes}" >
	<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
	<!-- <div style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">	 -->
	<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Edit Child Item Attributes</div>
        <div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR">&nbsp;<c:if test="${editYN eq 'Y' }"> &nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save all" type="button" onclick="fnSaveChildItemAttr();"></span></c:if>
	</li>
          </div>
		<div id="editArea">
			<table class="tbl_blue01 mgT2" width="100%"  border="0" cellspacing="0" cellpadding="0">
		        <colgroup>
					<col width="3%">
					<col width="8%">
					<col width="20%">
					<col width="16%">
					<col width="16%">
					<col width="16%">
					<col width="16%">
					<col width="5%">
				</colgroup>
				<tr>
					<th class="viewtop last">No.</th>
					<th class="viewtop last">${menu.LN00106}</th>
					<th class="viewtop last">${menu.LN00028}</th>
					<th class="viewtop last">${attrTypeMap.attrTypeName1}</th>
					<th class="viewtop last">${attrTypeMap.attrTypeName2}</th>
					<th class="viewtop last">${attrTypeMap.attrTypeName3}</th>
					<th class="viewtop last">${attrTypeMap.attrTypeName4}</th>
					<th class="viewtop last"></th>
				</tr>
			
				<c:forEach var="list" items="${editChildItemAttrList}" varStatus="iStatus">	
					<tr>
						<td class="last">${iStatus.count}</td>
						<td class="last">
							<input type="text" id="ID_${list.ItemID}" name="ID_${list.ItemID}" value="${list.Identifier}" class="text" <c:if test="${editYN ne 'Y' }"> readOnly </c:if> >
						</td>
						<td class="last">
							<input type="text" id="Name_${list.ItemID}" name="Name_${list.ItemID}" value="${list.ItemName}" class="text" <c:if test="${editYN ne 'Y' }"> readOnly </c:if> >
							
							<input type="hidden" id="itemClassCode_${list.ItemID}" name="itemClassCode_${list.ItemID}" value="${list.ClassCode}">
							<input type="hidden" id="itemTypeCode_${list.ItemID}" name="itemTypeCode_${list.ItemID}" value="${list.ItemTypeCode}">							
						</td>
						<!-- AttrTypeCode_1 -->
						<td class="last">
							<c:choose>
							<c:when test="${list.DataType1 eq 'Text'}">	
								<input type="text" id="${list.AttrTypeCode1}_${list.ItemID}" name="${list.AttrTypeCode1}_${list.ItemID}" value="${list.PlainText1}" class="text"  <c:if test="${editYN ne 'Y' }">readOnly</c:if> >
							</c:when>
							<c:when test="${list.DataType1 eq 'LOV'}">			
								<select id="${list.AttrTypeCode1}_${list.ItemID}" name=""${list.AttrTypeCode1}_${list.ItemID}" class="sel" OnChange="fnGetSubAttrTypeCode('${list.AttrTypeCode1}','${list.SubAttrTypeCode1}',this.value);"  <c:if test="${editYN ne 'Y' }">disabled </c:if>>
								<script>
									getAttrLovList('${list.AttrTypeCode1}','${list.LovCode1}', '${list.SubAttrTypeCode1}','${list.AttrTypeCode1}_${list.ItemID}' );
								</script>	
								</select>
							</c:when>	
							
							<c:when test="${list.DataType1 eq 'MLOV'}">
								 <select id="MLOV_${list.AttrTypeCode1}_${list.ItemID}" name="MLOV_${list.AttrTypeCode1}_${list.ItemID}[]" style="height:16px;width:250px;" multiple="multiple">
									<option value="">Select</option>
									<c:forEach var="mLovList1" items="${list.mLovList1}" varStatus="status">
										<option value="${mLovList1.CODE}" <c:if test="${mLovList1.LovCode == mLovList1.CODE}" >selected=selected</c:if> >${mLovList1.NAME}</option>
									</c:forEach>
								 </select>
								 <input type="hidden" id="${list.AttrTypeCode1}_${list.ItemID}" name="${list.AttrTypeCode1}_${list.ItemID}" >	 
							</c:when>	
							<c:when test="${list.DataType1 eq 'Date'}">
							<ul>
								<li>
									<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
									<font> <input type="text" id="${list.AttrTypeCode1}_${list.ItemID}" name="${list.AttrTypeCode1}_${list.ItemID}" value="${list.PlainText1}"	class="text datePicker" size="8"
											style="width: 120px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
									</font>
								</li>
							</ul>
							</c:when>
							</c:choose>
						</td>
						<!-- AttrTypeCode_2 -->
						<td class="last">							
							<c:choose>
							<c:when test="${list.DataType2 eq 'Text'}">	
								<input type="text" id="${list.AttrTypeCode2}_${list.ItemID}" name="${list.AttrTypeCode2}_${list.ItemID}" value="${list.PlainText2}" class="text"  <c:if test="${editYN ne 'Y' }">readOnly</c:if>>
							</c:when>
							<c:when test="${list.DataType2 eq 'LOV'}">			
								<select id="${list.AttrTypeCode2}_${list.ItemID}" name="${list.AttrTypeCode2}_${list.ItemID}" class="sel" OnChange="fnGetSubAttrTypeCode('${list.AttrTypeCode2}','${list.SubAttrTypeCode2}',this.value);" <c:if test="${editYN ne 'Y' }">disabled </c:if>>
								<script>
									getAttrLovList('${list.AttrTypeCode2}','${list.LovCode2}', '${list.SubAttrTypeCode2}', '${list.AttrTypeCode2}_${list.ItemID}' );
								</script>	
								</select>
							</c:when>	
							
							<c:when test="${list.DataType2 eq 'MLOV'}">								 
								<select id="MLOV_${list.AttrTypeCode2}_${list.ItemID}" name="MLOV_${list.AttrTypeCode2}_${list.ItemID}[]" style="height:16px;width:250px;" multiple="multiple">
									<option value="">Select</option>
									<c:forEach var="mLovList2" items="${list.mLovList2}" varStatus="status">
										<option value="${mLovList2.CODE}" <c:if test="${mLovList2.LovCode == mLovList2.CODE}" >selected=selected</c:if> >${mLovList2.NAME}</option>
									</c:forEach>
								</select>
								<input type="hidden" id="${list.AttrTypeCode2}_${list.ItemID}" name="${list.AttrTypeCode2}_${list.ItemID}" >
							</c:when>	
							<c:when test="${list.DataType2 eq 'Date'}">
							<ul>
								<li>
									<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
									<font> <input type="text" id="${list.AttrTypeCode2}_${list.ItemID}" name="${list.AttrTypeCode2}_${list.ItemID}" value="${list.PlainText1}"	class="text datePicker" size="8"
											style="width: 120px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
									</font>
								</li>
							</ul>
							</c:when>
							</c:choose>
						</td>
						<!-- AttrTypeCode_3 -->
						<td class="last">							
							<c:choose>
							<c:when test="${list.DataType3 eq 'Text'}">	
								<input type="text" id="${list.AttrTypeCode3}_${list.ItemID}" name="${list.AttrTypeCode3}_${list.ItemID}" value="${list.PlainText3}" class="text"  <c:if test="${editYN ne 'Y' }">readOnly</c:if>>
							</c:when>
							<c:when test="${list.DataType3 eq 'LOV'}">			
								<select id="${list.AttrTypeCode3}_${list.ItemID}" name="${list.AttrTypeCode3}_${list.ItemID}" class="sel" OnChange="fnGetSubAttrTypeCode('${list.AttrTypeCode3}','${list.SubAttrTypeCode3}',this.value);"  <c:if test="${editYN ne 'Y' }">disabled </c:if>>
								<script>
									getAttrLovList('${list.AttrTypeCode3}','${list.LovCode3}', '${list.SubAttrTypeCode3}', '${list.AttrTypeCode3}_${list.ItemID}' );
								</script>	
								</select>
							</c:when>	
							
							<c:when test="${list.DataType3 eq 'MLOV'}">
								<select id="MLOV_${list.AttrTypeCode3}_${list.ItemID}" name="MLOV_${list.AttrTypeCode3}_${list.ItemID}[]" style="height:16px;width:250px;" multiple="multiple">
									<option value="">Select</option>
									<c:forEach var="mLovList3" items="${list.mLovList3}" varStatus="status">
										<option value="${mLovList3.CODE}" <c:if test="${mLovList3.LovCode == mLovList3.CODE}" >selected='selected'</c:if> >${mLovList3.NAME}</option>
									</c:forEach>
								</select>
								<input type="hidden" id="${list.AttrTypeCode3}_${list.ItemID}" name="${list.AttrTypeCode3}_${list.ItemID}" >
							</c:when>	
							<c:when test="${list.DataType3 eq 'Date'}">
							<ul>
								<li>
									<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
									<font> <input type="text" id="${list.AttrTypeCode3}_${list.ItemID}" name="${list.AttrTypeCode3}_${list.ItemID}" value="${list.PlainText3}"	class="text datePicker" size="8"
											style="width: 120px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
									</font>
								</li>
							</ul>
							</c:when>
							</c:choose>
						</td>
						<!-- AttrTypeCode_4 -->
						<td class="last">							
							<c:choose>
							<c:when test="${list.DataType4 eq 'Text'}">	
								<input type="text" id="${list.AttrTypeCode4}_${list.ItemID}" name="${list.AttrTypeCode4}_${list.ItemID}" value="${list.PlainText4}" class="text"  <c:if test="${editYN ne 'Y' }">readOnly</c:if>>
							</c:when>
							<c:when test="${list.DataType4 eq 'LOV'}">			
								<select id="${list.AttrTypeCode4}_${list.ItemID}" name="${list.AttrTypeCode4}_${list.ItemID}" class="sel" OnChange="fnGetSubAttrTypeCode('${list.AttrTypeCode4}','${list.SubAttrTypeCode4}',this.value);"  <c:if test="${editYN ne 'Y' }">disabled </c:if>>
								<script>
									getAttrLovList('${list.AttrTypeCode4}','${list.LovCode4}', '${list.SubAttrTypeCode4}', '${list.AttrTypeCode4}_${list.ItemID}' );
								</script>
								</select>	
							</c:when>	
							
							<c:when test="${list.DataType4 eq 'MLOV'}">
								 <select id="MLOV_${list.AttrTypeCode4}_${list.ItemID}" name="MLOV_${list.AttrTypeCode4}_${list.ItemID}[]" style="height:16px;width:250px;" multiple="multiple">
									<option value="">Select</option>
									<c:forEach var="mLovList4" items="${list.mLovList4}" varStatus="status">
										<option value="${mLovList4.CODE}" <c:if test="${mLovList4.LovCode == mLovList4.CODE}" >selected='selected'</c:if> >${mLovList4.NAME}</option>
									</c:forEach>
								</select>
							    <input type="hidden" id="${list.AttrTypeCode4}_${list.ItemID}" name="${list.AttrTypeCode4}_${list.ItemID}" >
							</c:when>	
							<c:when test="${list.DataType4 eq 'Date'}">
								<font> <input type="text" id="${list.AttrTypeCode4}_${list.ItemID}" name="${list.AttrTypeCode4}_${list.ItemID}" value="${list.PlainText4}"	class="text datePicker" size="8"
										style="width: 120px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
								</font>
							
							</c:when>
							</c:choose>
						</td>
						<td class="last">	
							<button class="gridBtn" onclick="fnSaveChildItemAttrByRow(${list.ItemID});">Save</button>	
						</td>
					</tr>
				</c:forEach>		
			</table>
		</div>
	<!-- </div> -->
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>