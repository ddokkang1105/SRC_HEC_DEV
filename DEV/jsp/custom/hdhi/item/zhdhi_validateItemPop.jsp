<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>


<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid1;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		PgridInit();
		doPSearchList();
	});	

	//그리드 초기화
	function PgridInit(){		
		var d = setPGridData();
		pp_grid1 = fnNewInitGrid("grdPAArea", d);
		pp_grid1.setImagePath("${root}${HTML_IMG_DIR}/");
		pp_grid1.setColumnHidden(5, true);
		pp_grid1.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	}
	
	function setPGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "model_SQL.selectCompareModelList";
		result.header = "${menu.LN00024},${menu.LN00106},${menu.LN00028},${menu.LN00033},${menu.LN00032},${menu.LN00032}";
		result.cols = "ModelID|Name|MTCategory|ModelTypeName|ModelTypeCode";
		result.widths = "30,80,*,80,120,80";
		result.sorting = "str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center";
		result.data = "ItemID=${ItemID}&category=MC&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;
	}

	function gridOnRowSelect(id, ind){
		var ModelID = pp_grid1.cells(id, 1).getValue();
		var ModelTypeCode = pp_grid1.cells(id, 5).getValue();
		$("#ModelID").val(ModelID);	
		$("#ModelTypeCode").val(ModelTypeCode);
	}
	
	function doPSearchList(){
		var d = setPGridData();
		fnLoadDhtmlxGridJson(pp_grid1, d.key, d.cols, d.data, false);
	}	
	
	function doGetCompareModelList(){	
		
		var ModelID =  $("#ModelID").val();
		var ModelTypeCode = $("#ModelTypeCode").val();
		var InboundChk = '';
		$("input[name='inboundChk']:checked").each(function() {
			  if(InboundChk == ""){InboundChk = "\'"+$(this).val()+"\'";}
			  else {InboundChk +=  ",\'"+$(this).val()+"\'";}
		});
		var url = "";
		
		if($("#ModelID").val() == null || $("#ModelID").val() == '' || InboundChk == null || InboundChk == ''){
			alert("${WM00023}");
			return false;			
		} else {
			if(ModelTypeCode == "MT003" || ModelTypeCode == "MT002"){
				url = "getValidateElementList.do?ModelID="+ModelID;
			}else{
				url = "zhdhi_getValidateItemList.do?ItemID=${ItemID}&ModelID="+ModelID
						+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}&ModelTypeCode="+ModelTypeCode
						+"&InboundChk="+InboundChk;
			}
			var w = 1000;
			var h = 680;
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			self.close();
		}
	}
	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body style="width:100%;">
<form name="symbolFrm" id="symbolFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" name="SymTypeCode" id="SymTypeCode" >
	<input type="hidden" name="ModelID" id="ModelID">
	<input type="hidden" name="ItemID" id="ItemID" value="${ItemID}" >
	<input type="hidden" name="ModelTypeCode" id="ModelTypeCode" >
	<div class="child_search_head">
	<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00127}</p>
	</div>
	<div>
   		<div class="alignR mgT5 mgB5 mgR5">	
		<span class="btn_pack small icon"><span class="report"></span><input value="Report" type="submit" onclick="doGetCompareModelList()" ></span>
		</div>
		<div class="countList">
             <li class="count">Total  <span id="TOT_CNT"></span></li>
             <li class="floatR">&nbsp;</li>
         </div>
		<div id="grdPAArea" style="width:100%;height:280px;"></div>
		<div class="mgT10 mgB10" style="background: #f2f2f2; border: 1px solid #ccc; padding: 7px 0;">
			<b style="margin: 0px 20px 0 10px;">Inbound check Option</b>
			<c:forEach var="i" items="${inboundChks}" varStatus="status">
				<c:choose>
					<c:when test="${i.MTCategory == 'BAS'}">
						<input type="checkbox" name="inboundChk" value="${i.MTCategory}" checked>&nbsp;${i.Name}&nbsp;&nbsp;
					</c:when>
					<c:otherwise>
						<input type="checkbox" name="inboundChk" value="${i.MTCategory}">&nbsp;${i.Name}&nbsp;&nbsp;
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</div>
    </div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</body>
</html>