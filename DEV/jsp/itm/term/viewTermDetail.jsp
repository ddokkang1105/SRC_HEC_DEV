<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript">
	var chkReadOnly = true;	
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<!-- dhtmlx7  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	jQuery(document).ready(function() {
		fnSetVisitLog("${itemID}");
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('AT00034', data+"&attrTypeCode=AT00034", 'getAttrTypeLov', '${termDetailInfo.AT00034}', 'Select');		
		
		if("${option}" == "selectHier") {
			getItemPath();
		}
	});
	
	
	function fnGoEditTerm(){
		var url = "editTermDetail.do";
		var target = "viewTermDetailDiv";
		var data = "itemID=${itemID}&csr=${csr}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&option=${option}";
	 	ajaxPage(url, data, target);
	}

	function fnSaveTermDetail(){
		var itemID = "${itemID}";
		var url = "saveTermDetail.do";
		var data = "csr=${csr}&mgt=${mgt}&itemID="+itemID;	
		var target = "saveFrame";
		
		ajaxPage(url,data,target);
	}
	
	function fnCallBack(){
		$(opener.location).attr("href", "javascript:fnCallBack();");
		self.close();
	}
	
	function fnSetVisitLog(itemID){
		var url = "setVisitLog.do";
		var target = "blankDiv";
		var data = "ItemId="+itemID;
		ajaxPage(url, data, target);
	}
	
	function fnDeleteTerms(){
		var itemID = "${itemID}";
		var url = "deleteTerm.do";
		var data = "csr=${csr}&mgt=${mgt}&itemID="+itemID+"&csrAuthorID=${csrAuthorID}";	
		var target = "saveFrame";
		
		ajaxPage(url,data,target);
	}
	
	function getItemPath() {
		fetch("/getItemPath.do?itemID=${itemID}&csr=${csr}&languageID=${sessionScope.loginInfo.sessionCurrLangType}")
		.then(res => res.json())
		.then(res => document.getElementById("itemPath").insertAdjacentHTML("beforeend", res.data.map(e => e.PlainText).join("/")))
	}
</script>
</head>

<body>

<div id="viewTermDetailDiv">
<div id="viewTermDetailStyle" style="height:100vh;overflow:auto; overflow-x:hidden; padding: 6px; 6px; 6px; 6px;" >	
	<div class="cop_hdtitle">
		<h3>
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;Term detail information
		</h3>
	</div>
	<div id="tblChangeSet" style="width:99%">
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="15%"/>
				<col width="35%"/>
				<col width="15%"/>
				<col width="35%"/>		
			</colgroup>
			<c:if test="${option ne 'selectHier'}">
				<tr>	
					<!-- Category -->
					<th class="viewtop pdL10">${menu.LN00033}</th>
					<td class="viewtop alignL">${termDetailInfo.CategoryNM}</td>   
					<!-- 약어 -->
					<th class="viewtop pdL10">${menu.LN00080}</th>
					<td class="viewtop alignL last">${termDetailInfo.Abbreviation}</td>
				</tr>				
				<tr>				
					<th class="pdL10">${menu.LN00028}</th>
					<td class="alignL pdL5 last" colspan="3">
					<input type="text" id="name" name="name" value="${termDetailInfo.Name}" size="100%" style="border:0px;" readOnly>
					</td>				
				</tr>
			</c:if>
			<c:if test="${option eq 'selectHier'}">
				<tr>
					<th>${menu.LN00043}</th>
					<td class="alignL pdL5 last" colspan="3" id="itemPath"></td>
				</tr>
				<tr>
					<th>Korean ${menu.LN00028}</th>
					<td class="alignL pdL5 last" colspan="3">
						<input type="text" id="name" name="name" value="${termDetailInfo.Name}" size="100%" style="border:0px;" readOnly>
					</td>
				</tr>
				<tr>
					<th>English ${menu.LN00028}</th>
					<td class="alignL pdL5 last" colspan="3">
						<input type="text" id="name" name="name" value="${termDetailInfo.enName}" size="100%" style="border:0px;" readOnly>
					</td>
				</tr>
				<tr>
					<th>Chinese ${menu.LN00028}</th>
					<td class="alignL pdL5 last" colspan="3">
						<input type="text" id="name" name="name" value="${termDetailInfo.cnName}" size="100%" style="border:0px;" readOnly>
					</td>
				</tr>
			</c:if>
		</table>
		
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="15%"/>
				<col width="85%"/>
			</colgroup>
			<!-- 
			<tr>				
				<th class="pdL10">${menu.LN00035}</th>
				<td class="alignL pdL5 last" id="AT00003_1042" name="AT00003_1042" >
					<textarea class="tinymceText" style="width:100%;height:150px;" readonly="readonly">${termDetailInfo.Overview}</textarea>
				</td>
			</tr>
			<tr>				
				<th class="pdL10">${menu.LN00145}</th>
				<td class="alignL pdL5 last" id="AT00056_1042" name="AT00056_1042" >
					<textarea class="tinymceText" style="width:100%;height:150px;" readonly="readonly">${termDetailInfo.Content}</textarea>
				</td>
			</tr>		
			 -->
			<tr>				
				<th class="pdL10">Korean Description</th>
				<td class="alignL pdL5 last">
					<div style="width:100%;height:150px;">
						<textarea class="tinymceText" readonly="readonly">
							${termDetailInfo.KoreanText}
						</textarea>
					</div>
				</td>
			</tr>
			<tr>				
				<th class="pdL10">English Description</th>
				<td class="alignL pdL5 last">
					<div style="width:100%;height:150px;">
						<textarea class="tinymceText" readonly="readonly">${termDetailInfo.EnglishText}</textarea>
					</div>
				</td>
			</tr>
			<tr>				
				<th class="pdL10">Chinese Description</th>
				<td class="alignL pdL5 last">
				<div style="width:100%;height:150px;">
					<textarea class="tinymceText" readonly="readonly">${termDetailInfo.ChineseText}</textarea>
				</div>
				</td>
			</tr>
		</table>
		<c:if test="${csr !=  '' && csr !=  null}" > 
			<div class="alignBTN">
			 	<c:if test="${mgt !=  'Y'}" >
			   	&nbsp;<span class="btn_pack medium icon"><span class="edit"></span>
			   		<input value="Edit" onclick="fnGoEditTerm()" type="submit"></span>  
			   </c:if>
			   <c:if test="${csrAuthorID == sessionScope.loginInfo.sessionUserId }" >
			   		<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteTerms()"></span>&nbsp;
			   	</c:if>
			   	<c:if test="${mgt ==  'Y' && csrAuthorID == sessionScope.loginInfo.sessionUserId }" >
        			<span class="btn_pack medium icon"><span class="confirm"></span><input value="Release"  onclick="fnSaveTermDetail()" type="submit"></span>&nbsp;       			
        		</c:if>
		    </div>
	    </c:if>
	    
		<!-- 연관항목 -->
		<div class="align-center flex justify-between pdB5 pdL10 pdT15">
			<p class="cont_title">${menu.LN00008}</p>
		</div>
		<div id="layout1" style="width: 100%; height:200px;" class="mgB20"></div>

	    <c:if test="${csr !=  '' && csr !=  null}" >
		    <div class="align-center flex justify-between pdB5 pdL10 pdT15">
				<p class="cont_title">Change history</p>
			</div>
			<table class="tbl_brd mgT5 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="25%">
				    <col width="25%">
				 	<col width="25%">
				    <col width="25%">
				</colgroup>		
				<tr>
				  <th class="alignC pdL10">${menu.LN00070}</th> <!-- 수정일 -->
				  <th class="alignC pdL10">Editor</th> <!-- 담당자 -->
				  <th class="alignC pdL10">${menu.LN00104}</th> <!-- 부서명 -->
				  <th class="alignC pdL10">${menu.LN00136}</th> <!-- 변경내역 -->
				</tr>
				<c:forEach var="list" items="${itemHistoryList}" varStatus="status">
					<tr style="height:26px;">
						<td class="sline tit last alignL " >${list.RequestDate}</td>
						<td class="sline tit last alignC " >${list.RequestUserName}</td>
						<td class="sline tit last alignC " >${list.RequestUserTeamName}</td>
						<td class="sline tit last alignC " >${list.Description}</td>
					</tr>
				</c:forEach>
			</table>
		</c:if>	
		
</div>
<div>
<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</div>
</div>
<script>
	const layout1 = new dhx.Layout("layout1", {rows: [{id: "a" }]});
	
	const cxnList = ${cxnList}
	const grid1 = new dhx.Grid("", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
	        { width: 100, id: "Identifier", header: [{ text: "ID" , align: "center" }], align: "left"  },
	        { id: "ItemName", header: [{ text: "${menu.LN00028}" , align: "center" }], align: "left" },
	        { width: 100, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" }], align: "center" },
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data : cxnList
	});
	layout1.getCell("a").attach(grid1);
</script>
</body>
</html>
