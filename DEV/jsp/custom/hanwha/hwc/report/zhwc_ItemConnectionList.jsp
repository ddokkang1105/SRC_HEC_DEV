<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>
<script>
var tc_gridArea;				//그리드 전역변수
$(document).ready(function(){
	
	// 초기 표시 화면 크기 조정 
	$("#grdChildGridArea").attr("style","height:"+(setWindowHeight() - 110)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdChildGridArea").attr("style","height:"+(setWindowHeight() - 110)+"px;");
	};
	
	$("#excel").click(function(){
		var count=tc_gridArea.getRowsNum();
		
		for(var i=0;i<count; i++) {
			var rowID = tc_gridArea.getRowId(i);
			var text = tc_gridArea.cells(rowID,8).getValue();
			text = text.replace(/\n/g, '@@');
			tc_gridArea.cells(rowID, 8).setValue(text); 
			
			text = tc_gridArea.cells(rowID,7).getValue();
			text = text.replace(/\r\n|\n|\r/g, '@@');
			tc_gridArea.cells(rowID, 7).setValue(text); 
		}
		tc_gridArea.toExcel("${root}excelGenerate");
	});
	$('#type').change(function(){changeType();});

	gridTcInit();		
	doSearchList();

	
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}


function gridTcInit(){	
	var d = setTcGridData();
	tc_gridArea = fnNewInitGridMultirowHeader("grdChildGridArea", d);
	
	setTimeout(function() {

		var count=tc_gridArea.getRowsNum();
		
		for(var i=0;i<count; i++) {
			var rowID = tc_gridArea.getRowId(i);
		
			
			tc_gridArea.setCellTextStyle(rowID, 8, "white-space:pre-line");
			tc_gridArea.setCellTextStyle(rowID, 7, "white-space:pre-line");
		}
	}, 1000);
	
	
}

function setTcGridData(){
	var tcResult = new Object();
	
	tcResult.title = "";
	tcResult.key = "";
	tcResult.header = "Level,ID,L1 Name,L2 Name,L3 Name,L4 Name,L5 Name,File List,Connection List, Team Name, Author Name, 개정번호, 시행일";
	tcResult.widths = "50,100,150,150,150,150,150,400,300,150,150,50,80";
	tcResult.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str";
	tcResult.aligns = "center,center,center,center,center,center,center,left,left,center,center,center,center";
	tcResult.data = "";
	return tcResult;
}


function doSearchList(){
	tc_gridArea.loadXML("${root}" + "${xmlFilName}");
}


function changeType() {
	var avg = $("#type").val();
	
	if(avg != "no") {
		var url = "zhwc_ItemConnectionList.do";
		var data = "fromItemID="+avg;
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
}



</script>	
<div style="padding:0 200px;">
	<div id="processListDiv" class="hidden" style="float:left;height:100%;">
		<div style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">	
			
			<div class="cop_hdtitle mgT5" style="border-bottom:1px solid #ccc">
				<h2 style="padding-top:6px;">
					<img src="/cmm/common/images/statistics.png" style="margin-top:-11px;">&nbsp;&nbsp;Hanwha Rule & Process Connection List&nbsp;</h2>
			</div>
		
			<h3 style="font-size:12px;margin-top:10px;">Select Type 
			<Select id="type" name="type">
			<option value="no">Select</option>
			<option value="135984">일반규정</option>
			<!-- <option value="136383">SHEC 전사규정</option>
			<option value="136385">품질 전사규정</option> -->
			<option value="15">위임전결</option>
			<option value="181317">업무서식</option>
			<option value="181319">시스템매뉴얼</option>
			<option value="140391">로컬프로세스 - 보은사업장</option>
			<option value="140659">로컬프로세스 - 구미사업장</option>
			<option value="141485">로컬프로세스 - 종합연구소</option>
			<option value="141661">로컬프로세스 - 여수사업장</option>
			<option value="141943">로컬프로세스 - 대전사업장</option>
			<option value="180893">요령 - 보은1사업장</option>
			<option value="142505">요령 - 보은2사업장</option>			
			<option value="142801">요령 - 구미사업장</option>
			<option value="143979">요령 - 종합연구소</option>
			<option value="143709">요령 - 여수사업장</option>
			<option value="145103">요령 - 대전사업장</option>
			</Select>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			</h3>
			
			<div id="gridDiv" class="mgB10 clear" style="margin-top:10px;">
				<div id="grdChildGridArea" style="width:50%"></div>
			</div>
			
		</div>
	</div>
</div>