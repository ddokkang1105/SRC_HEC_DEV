<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%
	List AttrColumn = (List)request.getAttribute("AttrColumn");
	HashMap getList1 = (HashMap)AttrColumn.get(1);
	HashMap AttrInfo = (HashMap)request.getAttribute("AttrInfo");
	String occInfoLength[] = {"2"};
%>

<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 개요 기본정보 수정 팝업 -->
<!-- 
	@RequestMapping("/editItemInfoPop.do")
	* item_SQL.xml - getItemOCC

	* Action
	  - Save      :: saveObjectInfo.do

	  - Check SQL :: attr_SQL.identifierEqualCount    -- Count
				  :: attr_SQL.getEqualIdentifierInfo  -- Get Top 1 Value(ClassCode/Path/Name(AT00001) )
 -->
 
 <!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
 
<script type="text/javascript">

$(document).ready(function(){		
	$("input.datePicker").each(generateDatePicker);
	
	// bot_zone_large의 top위치 설정
	var maskHeight = $(document).height();    
    var top  = (maskHeight - setWindowHeight())*2/7;    
	document.getElementById('botZone').style.top = (top + 545)+"px";	
	
});
function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

// [Save] click
function saveObjInfoMain(){
	if(confirm("${CM00001}")){
		var url = "saveObjectInfo.do";
		alert(1);
		alert($("#isSubmit").val());
		
		ajaxSubmit(document.editFrm, url, "blankFrame");
		alert(2);
	}
}

function returnSaveObj(){location.reload();}
function searchPopup(url){	window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');}
function setSearchName(memberID,memberName){$('#AuthorID').val(memberID);$('#AuthorName').val(memberName);}
function setSearchTeam(teamID,teamName){$('#ownerTeamCode').val(teamID);$('#teamName').val(teamName);}

function changeItemTypeCode(avg, avg2){
	var url    = "getSelectOption.do"; // 요청이 날라가는 주소
	var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&sqlID=attr_SQL.selectAttrLovOption" //파라미터들
				+"&s_itemID="+avg; //파라미터들
	var target = avg; // avg;             // selectBox id
	var defaultValue = avg2;              // 초기에 세팅되고자 하는 값
	var isAll  = "";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
	ajaxSelect(url, data, target, defaultValue, isAll);
}

// [save] 이벤트 후 처리
function selfClose() {
	urlReload();
	$(".popup_div").hide();
	$("#mask").hide();
}

</script>

<form name="editFrm" id="editFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />
	<input type="hidden" id="option" name="option"  value="${option}" />		
	<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />		
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />		
	<input type="hidden" id="AuthorID" name="AuthorID" value="${getList.AuthorID}" />
	<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="${getList.OwnerTeamID}" />			
	<input type="hidden" id="sub" name="sub" value="${sub}" />
	<input type="hidden" id="function" name="function" value="saveObjInfoMain">
	<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />

<div class="popup_large">
	<ul>
		<li class="top_zone popup_title"><img src="${root}${HTML_IMG_DIR}/popup_box2_.png" /></li>
		<li class="con_zone">
			<div class="title popup_title"><span class="pdL10"><p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Edit</p></span>
				<div class="floatR mgR20">
					<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close">
				</div>
			</div> 
	       
	       	<div class="alignR mgT5 mgR10">
                <!-- Save Button  -->
                <span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveObjInfoMain()" type="submit"></span>
            </div>  
                
            <div class="szone" style="width:98%;overflow:auto;margin-bottom:5px;overflow-x:hidden;">
            <div class="con_large mgL10">
                
                <table class="tbl_preview mgT10" width="100%" border="0" cellpadding="0" cellspacing="0">
                    <colgroup>
                        <col width="12%">
                        <col width="28%">
                        <col width="12%">
                        <col width="28%">
                    </colgroup>
                    <tr><td colspan="4" style="height:300px;">&nbsp;&nbsp;TEST AREA</td></tr>
                    <tr>
                        <!-- ID -->
                        <th  class="viewtop">${menu.LN00015}</th>
                        <td  class="viewtop"><input type="text" class="text" id="Identifier" name="Identifier"  value="${getList.Identifier}"/></td>
                        <!-- 명칭 -->
                        <th class="viewtop">${menu.LN00028}</th>
                        <td class="viewtop"><input type="text" class="text" id="AT00001" name="AT00001"  value="${AttrInfo.AT00001}"/></td>
                    </tr>
                    <tr>
                        <!-- 계층 -->
                        <th>${menu.LN00016}</th>
                        <td>
                            <select id="classCode" name="classCode" class="sel">
                            <option value=""></option>
        <c:forEach var="i" items="${classOption}">
                            <option value="${i.ItemClassCode}" <c:if test="${ getList.ClassName == i.Name}">selected="selected"</c:if> >${i.Name}</option>                      
        </c:forEach>                
                            </select>
                        </td>
                        <!-- 법인 -->
                        <th>${menu.LN00014}</th>
                        <td>
                        <select id="companyCode" name="companyCode" class="sel">
        <c:forEach var="i" items="${companyOption}">
                            <option value="${i.TeamID}" <c:if test="${ getList.TeamName == i.Name}">selected="selected"</c:if>>${i.Name}</option>                       
        </c:forEach>
                        </select>
                        </td>   
                    </tr>
                    <tr>
                        <!-- 관리조직 -->
                        <th>${menu.LN00018}</th>
                        <td><input type="text"class="text" id="teamName" name="teamName" readonly="readonly" onclick="searchPopup('searchTeamPop.do')" value="${getList.OwnerTeamName}" /></td>             
                        <!-- 담당자-->         
                        <th>${menu.LN00004}</th>
                        <td><input type="text" class="text" id="AuthorName" name="AuthorName" readonly="readonly" onclick="searchPopup('searchNamePop.do')" value="${getList.Name}"/></td>
                    </tr>
                </table>
        
                <!-- 여기부터 속성 edit -->
                <table class="tbl_preview" width="100%" border="0" cellpadding="0" cellspacing="0">
                    <colgroup>
                        <col width="15%">
                        <col>
                    </colgroup> 
                    <!-- AttrList is null -->
                    <c:if test="${fn:length(getAttrList) eq 0 }">
                        <tr>
                            <td  class="alignC" colspan = 2>
                                 No attribute type allocated 
                            </td>
                        </tr>
                    </c:if>
                    
                    <!-- AttrList is not null -->
                    <!-- First Attr Value-->            
                    <c:forEach var="i" items="${getAttrList}" varStatus="iStatus">
                                <tr>
                                
                    <c:choose>
                    <c:when test="${iStatus.count eq 1 }">                  
                                    <th  class="alignC">${i.Name}</th>
                                    <td  class="alignL pdL10">
                    </c:when>
                    <c:when test="${iStatus.count ne 1 }">                  
                                    <th class="alignC">${i.Name}</th>
                                    <td  class="tit">
                    </c:when>                   
                    </c:choose>                 
                    
                    <!-- Attr Type :: Text, Date, URL, Select(Have Lov Code) -->
                    <!-- IF Type Text HTML USE(1) WHEN TEXTAREA or NotUse THEN TEXT --> 
                    <c:choose>
                    <c:when test="${i.DataType eq 'Text'}"> 
                        <c:choose>
                            <c:when test="${i.HTML eq '1'}">
                                                <textarea class="textgrow" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" style="width:100%;height:40px;">${i.PlainText}</textarea>
                            </c:when>
                            <c:when test="${i.HTML ne '1'}">
                                                <input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="${i.PlainText}" class="text">
                            </c:when>
                        </c:choose>
                    </c:when>
                    <c:when test="${i.DataType eq ''}"> 
                        <c:choose>
                            <c:when test="${i.HTML eq '1'}">
                                            <textarea class="textgrow" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" style="width:100%;height:40px;">${i.PlainText}</textarea>
                            </c:when>
                            <c:when test="${i.HTML ne '1'}">
                                            <input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="${i.PlainText}" class="text">
                            </c:when>
                        </c:choose>
                    </c:when>
                    <c:when test="${i.DataType eq 'LOV'}">                  
                                         <select id="${i.AttrTypeCode}" name="${i.AttrTypeCode}"  class="sel">
                                         </select>
                    <script>
                    changeItemTypeCode('${i.AttrTypeCode}','${i.LovCode}');
                    </script>                    
                    </c:when>                   
                    <c:when test="${i.DataType eq 'URL'}">
                        <a href="${i.PlainText}" target="_blank">${i.PlainText}</a>
                        <input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="${i.PlainText}" class="text">
                    </c:when>
                    <c:when test="${i.DataType eq 'Date'}">
                    <!-- 2013-11-15 Datapicker확인중 -->
                        <ul>
                            <li>
                                <fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
                                 <input type="text" id=SC_END_DT  name="SC_END_DT" value="${i.PlainText}" class="text datePicker" size="8"
                                        style="width: 70px;" onchange="this.value = makeDateType(this.value);"  maxlength="10">
                                
                            </li>
                        </ul>
                    </c:when>
                    </c:choose>                 
                                    </td>               
                                </tr>
                    </c:forEach>
        
                </table>            
                    
            </div> <!-- con_large --> 
        	</div> <!-- szone --> 
	
		</li>
	</ul>
</div>

<div class="bot_zone_large" id="botZone">
	<img src="${root}${HTML_IMG_DIR}/popup_box6_.png">
</div>

</form>	

<!-- START :: FRAME --> 		
<iframe id="blankFrame" name="blankFrame" style="display:none" frameborder="0"></iframe>
<!-- END :: FRAME -->				

	
