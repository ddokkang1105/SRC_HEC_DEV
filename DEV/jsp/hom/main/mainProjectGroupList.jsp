<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
	var prj_gridArea;				//그리드 전역변수
	$(document).ready(function(){
		gridClassInit();
		doSearchClassList(false);
	});
	function gridClassInit(){
		var d = setGridClassData();
		prj_gridArea = fnNewInitGrid("prjGridArea", d);
		prj_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		prj_gridArea.setColumnHidden(6, true);
		//prj_gridArea.setColumnHidden(8, true);
		prj_gridArea.attachEvent("onRowSelect", function(id){gridOnClassRowSelect(prj_gridArea.cells(id, 6).getValue());});
	}
	function setGridClassData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "cs_SQL.getPrjChangeSetItem";
		result.header = "${menu.LN00024},${menu.LN00016},${menu.LN00028},${menu.LN00025},${menu.LN00093},${menu.LN00027},";
		result.cols = "ClassName|ItemName|AuthorName|CreationTime|StatusName|ChangeSetID";
		result.widths = "50,100,*,90,80,80,0";
		result.sorting = "int,str,str,str,str,str,int";
		result.aligns = "center,center,left,left,center,center,center";
		result.data = "filter=${filter}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&top=10";
		return result;
	}
	function gridOnClassRowSelect(avg){
		/*
		//alert(id);
		var url = "NewChangeInfoView.do?";
	 	var target = self;
	 	var data = "LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&changeSetID="+avg;
	 	var option = "dialogWidth:650px; dialogHeight:230px; scroll:yes";
	 	window.showModalDialog(url + data , target, option);
	 	*/
	 	
	 	var url = "getChangeInfoViewOfObjHistory.do?";
	 	var target = self;
		var data = "changeSetID=" + avg + "&cngtView=pop"
				+"&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&userId=${sessionScope.loginInfo.sessionUserId}";	
		var option = "dialogWidth:900px; dialogHeight:400px; scroll:yes";
	 	window.showModalDialog(url + data , target, option);
	}
	function doSearchClassList(avg){		
		var d = setGridClassData();
		fnLoadDhtmlxGridJson(prj_gridArea, d.key, d.cols, d.data,false,"Y");
		this.setPagingHTML($("#totalPage").val(), $("#page").val());
	}

</script>
	<form name="projectListFrm" id="projectListFrm" method="post" onsubmit="return false;">
		<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}"/>
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
		<div id="gridDiv" >
			<div id="prjGridArea" style="height:200px; width:100%"></div>
		</div>
	</form>	
