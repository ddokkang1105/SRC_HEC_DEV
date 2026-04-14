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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021" arguments="Edit "/>
<!-- 2. Script -->
<script type="text/javascript">

	var OT_gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		};
		//Grid 초기화
		gridOTInit();
		doOTSearchList();
		
		$("#excel").click(function(){OT_gridArea.toExcel("${root}excelGenerate");});	
		
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
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();
		OT_gridArea = fnNewInitGrid("grdOTGridArea", d);
		OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		OT_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
		OT_gridArea.enablePaging(true,20,10,"pagingArea",true, "recinfoArea");
		OT_gridArea.setPagingSkin("bricks");
		OT_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setOTGridData(){	
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getLanguageList";
		result.header = "${menu.LN00024},LanguageID,LanguageCode,Name,NameEN,IsDefault,Deactivated,FontFamily,FontStyle,FontSize,FontColor";
		result.cols = "LanguageID|LanguageCode|Name|NameEN|IsDefault|Deactivated|FontFamily|FontStyle|FontSize|FontColor";
		result.widths = "50,80,90,150,150,70,80,80,80,80,80";
		result.sorting = "int,str,str,str,str,str,,str,str,str,str,str";
		result.aligns = "center,center,center,left,left,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";			
		return result;	
	}
	
	function searchPopup(url){
		window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchTeam(teamID,teamName){
		$('#ownerTeamCode').val(teamID);
		$('#teamName').val(teamName);
	}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind){ 	
		$("#languageID").val(OT_gridArea.cells(id, 1).getValue());	
		$("#name").val(OT_gridArea.cells(id, 3).getValue());	
		$("#nameEN").val(OT_gridArea.cells(id, 4).getValue());	
		$("#fontFamily").val(OT_gridArea.cells(id, 7).getValue());	
		$("#fontSize").val(OT_gridArea.cells(id, 9).getValue());	
		$("#fontColor").val(OT_gridArea.cells(id, 10).getValue());	
		var deactivated = OT_gridArea.cells(id, 6).getValue();
		$("#deactivated").val(deactivated);
		if(deactivated == 1){
			$("#deactivated").attr("checked",true);
		}else{
			$("#deactivated").attr("checked",false);
		}
	}
	
	function checkBox(){			
		var chk1 = document.getElementsByName("deactivated");
		if(chk1[0].checked == true){ $("#deactivated").val("1");
		}else{	$("#deactivated").val("0"); }
	}
	
	// END ::: GRID	
	//===============================================================================
	
	//조회
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
	}
	
	function saveLanguageMgt(){
		if(confirm("${CM00001}")){
			var languageID = $("#languageID").val();
			if(languageID ==""){
				alert("${WM00021}");return;
			}
			var url = "saveLanguageMgt.do";
			ajaxSubmit(document.languageFrm, url,"saveFrame");			
		}
	}
	
	function fnCallBack(){ 
		gridOTInit();
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
<div style="margin:0 10px;" >
	<!-- BEGIN :: BOARD_ADMIN_FORM -->
	<form name="languageFrm" id="languageFrm" action="" method="post" onsubmit="return false;">	
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Language</li>
		</ul>
	</div>	
	<div class="child_search01 mgR10 mgL10">
		<li class="floatR pdR10">
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>
	</div>
	
	<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
        <div class="countList pdL10">
               <li class="count">Total <span id="TOT_CNT"></span></li>
             <li class="floatR">&nbsp;</li>
         </div>

		<div id="gridOTDiv" class="mgB10 clear">
			<div id="grdOTGridArea" style="width:100%"></div>
		</div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div>
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
			&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="saveLanguageMgt()"></span>
	</div>	
	<!-- END :: PAGING -->		
	</form>
	</div>
	<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>