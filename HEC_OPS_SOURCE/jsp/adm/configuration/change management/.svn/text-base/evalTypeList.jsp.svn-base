<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00148" var="WM00148" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>

<!-- 2. Script -->
<script type="text/javascript">

	var OT_gridArea;				
	var p_gridArea;
	var skin = "dhx_skyblue";
	
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 470)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 470)+"px;");
		};
		
		gridOTInit();
		doOTSearchList();
		$("#allocDiv").attr("style","display:none;");
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();
		OT_gridArea = fnNewInitGridMultirowHeader("grdOTGridArea", d);
		OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		fnSetColType(OT_gridArea, 1, "ch");
		OT_gridArea.enablePaging(true,20,10,"pagingArea",true, "recinfoArea");
		OT_gridArea.setPagingSkin("bricks");
		OT_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setOTGridData(){	
		var result = new Object();
		result.title = "";
		result.key = "";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},${menu.LN00028},${menu.LN00035},";
		result.widths = "50,50,150,250,250,250";
		result.sorting = "int,int,str,str,str,str";
		result.types = "ro,ro,ro,ro,ro,ro";
		result.aligns = "center,center,center,center,center,center";
		result.data = "";			
		return result;	
	}

	// END ::: GRID	
	//===============================================================================
	
	function fnSaveGridData(id){
		var evTypeCode = OT_gridArea.cells(id,2).getValue();
		var name = $("#name_"+id).val();
		var description = $("#description_"+id).val();
		
		var url = "saveEvalType.do";
		var data = "evTypeCode=" + evTypeCode+"&name="+name+"&description="+description+"&viewType=E";
		var target = "saveDFrame";
		ajaxPage(url, data, target);
	}
	
	//조회
	function doOTSearchList(){
		OT_gridArea.enableRowspan();
		OT_gridArea.enableColSpan(true);
		OT_gridArea.loadXML("${root}" + "${xmlFilName}");
	}

	function fnCallBack(){
		gridOTInit();
		doOTSearchList();
		$("#allocDiv").attr("style","display:none;");
	}
	
	function fnAddEvalType(){
		var url = "addEvalTypePop.do";
		window.open(url,'','width=500, height=200, left=300, top=200,scrollbar=yes,resizble=0');
	}
	
	function fnDelEvalType(){
		if(OT_gridArea.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");	
			alert("${WM00023}");	
		}else{
			if(confirm("${CM00004}")){
				var checkedRows = OT_gridArea.getCheckedRows(1).split(",");
				var evTypeCodes = "";
				for(var i = 0 ; i < checkedRows.length; i++ ){
					if (evTypeCodes == "") {
						evTypeCodes = OT_gridArea.cells(checkedRows[i], 2).getValue();
					} else {
						evTypeCodes += ","+OT_gridArea.cells(checkedRows[i], 2).getValue();
					}
				}
				var url = "delEvalType.do";
				var data = "evTypeCodes="+evTypeCodes;
				var target = "saveDFrame";
				ajaxPage(url, data, target);
			}
		}
	}
	
	function fnAlloc(id){$
		$("#allocDiv").attr("style","display:block;");
		var code =  OT_gridArea.cells(id,2).getValue();

		$("#evTypeCode").val(code);
		gridInit(code);
		doSearchList(code);
	}
	
	function gridInit(e){		
		var d = setGridData(e);
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
	}
	
	function setGridData(e){	
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getAllocAttrType";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},${menu.LN00028},${menu.LN00035}";
		result.cols = "CHK|AttrTypeCode|Name|Description";
		result.widths = "50,50,150,550,350";
		result.sorting = "int,int,str,str,str";
		result.aligns = "center,center,center,left,left";
		result.data = "evTypeCode="+e+"&category=EVAL&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;	
	}
	
	//조회
	function doSearchList(e){
		var d = setGridData(e);
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function fnAddAttr(){
		var evTypeCode = $("#evTypeCode").val();
		var url = "addEvalAttrAlloc.do?evTypeCode="+evTypeCode;
		window.open(url,self,'width=800, height=500, left=400, top=200,scrollbar=yes,resizble=0');
	}
	
	function fnDelAttr(){
		if(p_gridArea.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");	
			alert("${WM00023}");	
		}else{
			if(confirm("${CM00004}")){
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");
				var attrTypeCodes = "";
				var evTypeCode = $("#evTypeCode").val();
				for(var i = 0 ; i < checkedRows.length; i++ ){
					if (attrTypeCodes == "") {
						attrTypeCodes = p_gridArea.cells(checkedRows[i], 2).getValue();
					} else {
						attrTypeCodes += ","+p_gridArea.cells(checkedRows[i], 2).getValue();
					}
				}
				var url = "delEvalAttrAlloc.do";
				var data = "evTypeCode="+evTypeCode+"&attrTypeCodes="+attrTypeCodes;
				var target = "saveDFrame";
				ajaxPage(url, data, target);		
			}
		}
	}
</script>
<body>
	<div>
		<form name="emailFormList" id="emailFormList" action="" method="post" onsubmit="return false;">	
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
		<input type="hidden" id="evTypeCode" name="evTypeCode" value=""></input> 
		<div class="cfgtitle" >				
			<ul>
				<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Evaluation Type</li>
			</ul>
		</div>
	    <div class="countList">
	        <li class="floatR mgR20">
	        	<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddEvalType()"></span>
	        	&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDelEvalType()"></span>
			</li>
	    </div>
		<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
			<div id="grdOTGridArea" style="height:250px; width:100%"></div>
		</div>
		<!-- START :: PAGING -->
		<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div>
		</div>	
		<!-- END :: PAGING -->		
		</form>
	</div>
	
	<div id="allocDiv">
		<div class="mgT10 mgB12" >				
			<ul>
				<li class="floatL mgL20 mgT10 mgB12"><h3>Attribute Allocation</h3></li>
				<li class="floatR mgR20">
	        	<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddAttr()"></span>
				&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDelAttr()"></span>
			</li>
			</ul>
		</div>
		<div id="gridDiv" class="mgB10 clear mgL10 mgR10">
			<div id="grdGridArea" style="height:360px; width:100%"></div>
		</div>
	</div>
	
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>