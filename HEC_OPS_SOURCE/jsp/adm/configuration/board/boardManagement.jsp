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

<!-- 2. Script -->
<script type="text/javascript">

	var OT_gridArea;				
	var skin = "dhx_skyblue";
	
	$(document).ready(function() {		
		gridOTInit();
		doOTSearchList();
		$("#excel").click(function(){OT_gridArea.toExcel("${root}excelGenerate");});	
	});	
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();
		OT_gridArea = fnNewInitGrid("grdOTGridArea", d);
		fnSetColType(OT_gridArea, 1, "ch");
		OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		OT_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
		OT_gridArea.setColumnHidden(6, true);
		OT_gridArea.setColumnHidden(10, true);
		OT_gridArea.setColumnHidden(11, true);
		OT_gridArea.setColumnHidden(12, true);
		OT_gridArea.setColumnHidden(13, true);
		OT_gridArea.enablePaging(true,20,10,"pagingArea",true, "recinfoArea");
		OT_gridArea.setPagingSkin("bricks");
		OT_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setOTGridData(){	
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getAllBoardMgtList";
		result.header = "${menu.LN00024},#master_checkbox,Group ID,Group Name,Board ID,Board Name,Board Type,Board Type,${menu.LN00013},${menu.LN00004},BoardMgtID,BoardMgtCnt,BoardCnt,BoardName";
		result.cols = "CHK|Level1|Level1Name|Level2|Level2Name|BoardTypeCD|BoardTypeName|RegDT|ModUserName|BoardMgtID|BoardMgtCnt|BoardCnt|BoardMgtName";
		result.widths = "50,50,80,150,80,150,90,90,80,80,80,80,80,80,80";
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,left,center,left,center,center,center,center,center,center,center,center,center";
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
		if(ind != 1){
			var url = "boardMgtDetail.do";
			var data = "&boardMgtID="+ OT_gridArea.cells(id, 10).getValue() + 
					"&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + 
					"&pageNum=" + $("#currPage").val()+
					"&viewType=E";				
			var target = "boardMgtList";	
			ajaxPage(url,data,target);	
		}
	}
	
	// END ::: GRID	
	//===============================================================================
	
	//조회
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
	}

	function fnAddBoardMgt(){
		var url = "boardMgtDetail.do";
		var data = "&pageNum=" + $("#currPage").val() +"&viewType=N";				
		var target = "boardMgtList";	
		ajaxPage(url,data,target);	
	}
	
	function fnDelBoardMgt(){		
		if (OT_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		
		var cnt  = OT_gridArea.getRowsNum();
		var boardMgtID = new Array;
		var j = 0;
		var chkVal;
		for ( var i = 0; i < cnt; i++) { 
			chkVal = OT_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){					
				if(OT_gridArea.cells2(i, 11).getValue() == 0 && OT_gridArea.cells2(i, 12).getValue() == 0){
					boardMgtID[j] = OT_gridArea.cells2(i,10).getValue();
					j++;
				}else{
					alert(OT_gridArea.cells2(i, 13).getValue()+" ${WM00148}");
					return;
				}				
			}
		}	
		
		var url = "deleteBoardMgt.do";
		var data = "&boardMgtID="+boardMgtID+"&pageNum=" + $("#currPage").val();				
		var target = "saveDFrame";	
		ajaxPage(url,data,target);	
	}
	
	function fnCallBack(){
		doOTSearchList();
	}
	

</script>
<body>
<div id="boardMgtDiv">
	<form name="boardMgtList" id="boardMgtList" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Board management</li>
		</ul>
	</div>	
	<div class="child_search01 mgL10 mgR10">
		<li class="floatR pdR10">
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit"  alt="New" onclick="fnAddBoardMgt()" ></span>
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDelBoardMgt()" ></span>
		</li>
	</div>
    <div class="countList pdL10">
          <li class="count">Total  <span id="TOT_CNT"></span></li>
         <li class="floatR">&nbsp;</li>
    </div>
	<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
		<div id="grdOTGridArea" style="height:360px; width:100%"></div>
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