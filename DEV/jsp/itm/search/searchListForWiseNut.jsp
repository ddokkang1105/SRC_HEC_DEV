<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	$(window).load(function(){$("#searchValue").focus();});
	$(document).ready(function() {	
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 70)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 70)+"px;");
		};
		
		$("#excel").click(function(){p_gridArea.toExcel("${root}excelGenerate");});
		$('#searchValue').keypress(function(onkey){if(onkey.keyCode == 13){doSearchList();return false;}});	
		changeItemTypeCode('${ItemTypeCode}');
		gridInit();
	});	
	//===============================================================================
	// BEGIN ::: GRID
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		//p_gridArea.setColumnHidden(0, true);				//RNUM
		//p_gridArea.setColumnHidden(10, true);				//ItemID
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	}	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "search_SQL.getItemSearchList";
		result.header = "${menu.LN00024},${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00016},회사,${menu.LN00018},${menu.LN00004}";	//9
		result.cols = "MyItemID|ItemName|DisplayPath|MyClass|CompNM|OwnerTeamNM|AuthorNM";
		result.widths = "50,100,*,200,150,120,80,100,80";
		result.sorting = "int,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,left,center,center,center,center";
		result.data = "s_itemID=${s_itemID}"
		            + "&ClassCode="     	+ $("#newClassCode").val()
			        + "&searchKey="     	+ $("#searchKey").val()
			        + "&searchValue="     	+ $("#searchValue").val()
			        + "&defDimTypeCode=#{defDimTypeCode}"
			        + "&defDimValueID=#{defDimValueID}"
		 			+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;
	}
	function gridOnRowSelect(id, ind){doDetail(p_gridArea.cells(id,1).getValue());}
	// END ::: GRID	
	//===============================================================================
	function setSubDiv(avg, avg2){
		$("#"+avg2).attr('style', 'display: none');
		$("#"+avg).removeAttr('style', 'display: none');		
		if(avg == 'addNewItem'){setSubDiv('saveOrg','editOrg');
		}else if(avg == 'OrganizationInfo'){setSubDiv('editOrg','saveOrg');}
	}
	function doSearchList(){
		var d = setGridData();
		$("#objInfo").attr('style', 'display: none');
		
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data,false,"N");
	}	
	function doDetail(avg){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}	
	function changeItemTypeCode(avg){
		var url    = "getClassCodeOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+avg; //파라미터들
		var target = "newClassCode";             // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select"; 		
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
</script>
</head>
<body>
	<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	<div class="child_search">
		<ul>
			<li class="L">
			&nbsp;${menu.LN00016}
				<select id="newClassCode" name="newClassCode" style="width:150px;" >
					<option value="">select</option>
					<c:forEach var="i" items="${newClassOption}">
						<option value="${i.CODE}"
							<c:if test="${i.CODE == ClassCode}">
											selected="selected"
							</c:if>					
						>${i.NAME}</option>						
					</c:forEach>				
				</select>	
			<select id="searchKey" name="searchKey" style="width:150px;">
				<option value="Name">Name</option>
<!-- 
				<option value="Code" 
					<c:if test="${searchKey == 'Code'}"> selected="selected"</c:if>	
				>Code</option>
				<option value="Info" 
					<c:if test="${searchKey == 'Info'}"> selected="selected"</c:if>	
				>${menu.LN00005}</option>					
 -->				
			</select>
			</li>
			<li>
				<input type="text" id="searchValue" name="searchValue" value="${searchValue}"  class="text" style="width:150px;ime-mode:active;"/>
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="doSearchList()" value="검색">
				&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			</li>			
		</ul>
	</div>
	</form>		
	<div id="gridDiv" class="mgB10">
		<div id="grdGridArea" style="height:300px; width:100%"></div>
	</div>
	<div id="objInfo" style="height:300px; width:100%"></div>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>	
</body>
</html>