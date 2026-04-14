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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021" arguments="Edit "/>
<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {
		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 350)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 350)+"px;");
		};

		$("#excel").click(function(){fnGridExcelDownLoad();})
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function setOTLayout(type){
		if( schCntnLayout != null){
			schCntnLayout.unload();
		}
		schCntnLayout = new dhtmlXLayoutObject("schContainer",type, skin);
		schCntnLayout.setAutoSize("b","a;b"); //가로, 세로		
		schCntnLayout.items[0].setHeight(350);
	}
	
	
	function searchPopup(url){
		window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchTeam(teamID,teamName){
		$('#ownerTeamCode').val(teamID);
		$('#teamName').val(teamName);
	}

	function checkBox(){			
		var chk1 = document.getElementsByName("deactivated");
		if(chk1[0].checked == true){ $("#deactivated").val("1");
		}else{	$("#deactivated").val("0"); }
	}
	
	//조회
	function doOTSearchList(){
		var sqlID = "config_SQL.getLanguageList";
		var param =  "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&sqlID="+sqlID;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);			
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());
		fnMasterChk('');
	}

	
	function saveLanguageMgt(){
		if(confirm("${CM00001}")){
			var languageID = $("#languageID").val();
			if(languageID ==""){
				alert("${WM00021}");return;
			}
			var url = "admin/saveLanguageMgt.do";
			ajaxSubmit(document.languageFrm, url,"saveFrame");			
		}
	}
	
	function fnCallBack(){ 
		doOTSearchList();
		
		$("#languageID").val("");	
		$("#name").val("");
		$("#nameEN").val("");
		$("#fontFamily").val("");	
		$("#fontSize").val("");	
		$("#fontColor").val("");	
		$("#deactivated").attr("checked",false);	
	}

</script>
<body>
<div>
	<form name="languageFrm" id="languageFrm" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Language</li>
		</ul>
	</div>	
	<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
        <div class="countList pdL10">
             <li class="count">Total <span id="TOT_CNT"></span></li>
             <li class="floatR pdR20"><button class="cmm-btn mgR5" style="height: 30px;" value="Down" id="excel">Download List</button></li>
         </div>

		<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
			<div id="grdOTGridArea" style="width:100%">
				<div style="width: 100%;" id="layout"></div> <!--layout 추가한 부분-->
				<div id="pagination"></div></div>
			</div>
		</div>
	</div>
	<table id="newObject" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" >
		<tr>
			<th class="viewtop last">Name</th>
			<th class="viewtop last">NameEN</th>
			<th class="viewtop last">Deactivated</th>
		</tr>
		<tr>
			<td class="last">
				<input type="text" class="text" id="name" name="name" />
				<input type="hidden" id="languageID" name="languageID" >
			</td>
			<td class="last"><input type="text" class="text" id="nameEN" name="nameEN" /></td>
			<td class="last"><input type="checkbox" id="deactivated" name="deactivated" value="" OnClick=checkBox();></td>
		</tr>
		<tr>
			<th class="last">fontFamily</th>
			<th class="last">fontColor</th>
			<th class="last">fontSize</th>
		</tr>
		<tr>
			<td class="last"><input type="text" class="text" id="fontFamily" name="fontFamily" /></td>
			<td class="last"><input type="text" class="text" id="fontColor" name="fontColor" /></td>
			<td class="last"><input type="text" class="text" id="fontSize" name="fontSize" /></td>
		</tr>	
	</table>
	<div class="alignBTN">
			<button class="cmm-btn2 mgR5" style="height: 30px;" onclick="saveLanguageMgt()" value="Save">Save</button>
	</div>	
	</form>
	</div>
	<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>

<script type="text/javascript">	//그리드 자바스크립트
	var layout = new dhx.Layout("layout", { 
			rows: [
				{
					id: "a",
				},
			]
		});
	
		var gridData = ${gridData};
		var grid = new dhx.Grid(null, {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ hidden: true, width: 50, id: "checkbox", header: [{ text: "" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},			
				{ width: 100, id: "LanguageID", header: [{ text: "LanguageID" , align: "center" }, { content: "inputFilter" }], align: "center" },
				{ width: 100, id: "LanguageCode", header: [{ text: "LanguageCode", align: "center" }, { content: "inputFilter" }], align: "center" },
				{ fillspace: true, id: "Name", header: [{ text: "Name", align: "center" }, { content: "selectFilter" }], align: "left" },
				{ fillspace: true, id: "NameEN", header: [{ text: "NameEN", align: "center" }, { content: "selectFilter" }], align: "left" },
				{ width: 100, id: "IsDefault", header: [{ text: "IsDefault", align: "center" }, { content: "selectFilter" }], align: "center" },		
				{ width: 100, id: "Deactivated", header: [{ text: "Deactivated", align: "center" }, { content: "selectFilter" }], align: "center" },
				{ width: 100, id: "FontFamily", header: [{ text: "FontFamily", align: "center" }, { content: "selectFilter" }], align: "center" },
				{ width: 100, id: "FontStyle", header: [{ text: "FontStyle", align: "center" }], align: "center" },	
				{ width: 100, id: "FontSize", header: [{ text: "FontSize", align: "center" }], align: "center" },	
				{ width: 100, id: "FontColor", header: [{ text: "FontColor", align: "center" }], align: "center" }
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);
		$("#TOT_CNT").html(grid.data.getLength());

		var pagination = new dhx.Pagination("pagination", {
			data: grid.data,
			pageSize: 50,
		});	


		//그리드ROW선택시
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnRowOTSelect(row);
			}
		}); 
	
		function gridOnRowOTSelect(row) {
			$("#languageID").val(row.LanguageID);	
			$("#name").val(row.Name);	
			$("#nameEN").val(row.NameEN);	
			$("#fontFamily").val(row.FontFamily);	
			$("#fontSize").val(row.FontSize);	
			$("#fontColor").val(row.FontColor);	
			$("#deactivated").val(row.Deactivated);
			if(row.Deactivated == 1){
				document.getElementById("deactivated").checked = true;
			} else {
				document.getElementById("deactivated").checked = false;
			}
		}



</script>

</html>