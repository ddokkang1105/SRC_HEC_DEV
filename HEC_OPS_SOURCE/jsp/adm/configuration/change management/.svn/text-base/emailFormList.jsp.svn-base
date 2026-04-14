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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<!-- 2. Script -->
<script type="text/javascript">

	var OT_gridArea;				
	var skin = "dhx_skyblue";
	var ids= new Array;
	var codes= new Array;
	
	$(document).on('propertychange change paste', '.name, .description', function(){
		if (ids.indexOf(OT_gridArea.getSelectedRowId()) == -1){ // 중복체크
			ids.push(OT_gridArea.getSelectedRowId());
			codes.push(OT_gridArea.cells(OT_gridArea.getSelectedRowId(), 2).getValue());
		}
	});
	
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 150)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 150)+"px;");
		};
		
		gridOTInit();
		doOTSearchList();
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();
		OT_gridArea = fnNewInitGridMultirowHeader("grdOTGridArea", d);
		OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		OT_gridArea.setColumnHidden(4, true);
		fnSetColType(OT_gridArea, 1, "ch");
		OT_gridArea.enablePaging(true,20,10,"pagingArea",true, "recinfoArea");
		OT_gridArea.setPagingSkin("bricks");
		OT_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setOTGridData(){	
		var result = new Object();
		result.title = "";
		result.key = "";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},${menu.LN00028},HTMLForm,${menu.LN00035},";
		result.widths = "50,50,150,250,150,250,150";
		result.sorting = "int,int,,str,str,str,str,str";
		result.types = "ro,ro,ro,ro,ro,ro,ro";
		result.aligns = "center,center,center,center,center,center,center";
		result.data = "";			
		return result;	
	}

	// END ::: GRID	
	//===============================================================================
	
	function fnGetEmailForm(id){
		var emailCode = OT_gridArea.cells(id,2).getValue();
		var url = "editEmailFormPop.do?emailCode="+emailCode;
		window.open(url,'','width=1100, height=590, left=300, top=200,scrollbar=yes,resizble=0');
	}
		
	function fnSaveGridData(id){
		var emailCode = OT_gridArea.cells(id,2).getValue();
		var name = $("input[name='name_"+id+"']").val();
		var description = $("input[name='description_"+id+"']").val();
		
		var url = "saveEmailForm.do";
		var data = "emailCode=" + emailCode+"&name="+name+"&description="+description+"&viewType=E";
		var target = "saveDFrame";
		ajaxPage(url, data, target);
	}
	
	//조회
	function doOTSearchList(){
		OT_gridArea.loadXML("${root}" + "${xmlFilName}");
	}

	function fnCallBack(){
		ids = [];
		codes = [];
		doOTSearchList();
	}
	
	function fnAddEmailForm(){
		var url = "addEmailFormPop.do";
		window.open(url,'','width=1100, height=670, left=300, top=200,scrollbar=yes,resizble=0');
	}
	
	function fnDelEmailForm(){
		if(OT_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");	
		}else{
			if(confirm("${CM00004}")){
				var checkedRows = OT_gridArea.getCheckedRows(1).split(",");
				var emailCodes = "";
				for(var i = 0 ; i < checkedRows.length; i++ ){
					if (emailCodes == "") {
						emailCodes = OT_gridArea.cells(checkedRows[i], 2).getValue();
					} else {
						emailCodes += ","+OT_gridArea.cells(checkedRows[i], 2).getValue();
					}
				}
				var url = "delEmailForm.do";
				var data = "emailCodes="+emailCodes;
				var target = "saveDFrame";
				ajaxPage(url, data, target);		
			}
		}
	}
	
	function fnSaveAll(){
		var url = "saveAllEmailForm.do?ids="+ids+"&emailCodes="+codes;
		if(confirm("${CM00001}")){
			ajaxSubmit(document.emailFormList, url,"saveDFrame");
		}
	}
</script>
<body>
<div id="">
	<form name="emailFormList" id="emailFormList" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Email Form</li>
		</ul>
	</div>
    <div class="countList">
        <li class="floatR mgR20">
        	&nbsp;<span class="btn_pack small icon"><span class="save"></span><input value="Save All" type="submit" onclick="fnSaveAll()"></span>
        	&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddEmailForm()"></span>
        	&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDelEmailForm()"></span>
		</li>
    </div>
	<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
		<div id="grdOTGridArea" style="width:100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div>
	</div>	
	<!-- END :: PAGING -->		
	</form>
	</div>
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>