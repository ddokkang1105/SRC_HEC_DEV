<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 담당 Item 목록 -->
<!-- 
	@RequestMapping(value="/ProcessDimensionList.do")
	* dim_SQL.xml - selectDimList_gridList
	* Action
	  - Add  :: NewDimension.do
	         :: NewSubDimension.do
	  - Del  :: DelDimension.do
	         :: DelSubDimension.do 
	* SubMenu - subChangeManagement  
-->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00005" var="CM00005"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00024" var="WM00024"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="ClassCode"/>


<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	var p_gridArea2;				//그리드 전역변수
	$(document).ready(function() {
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea2").attr("style","width:100%;height:"+(setWindowHeight() - 500)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea2").attr("style","width:100%;height:"+(setWindowHeight() - 500)+"px;");
		};
		$('#searchValue').keypress(function(onkey){if(onkey.keyCode == 13){doSetGrid2Child();return false;}});	
			
		gridInit();
		doSearchList();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");		
		//p_gridArea.setColumnHidden(0, true);
		p_gridArea.setColumnHidden(2, true);
		p_gridArea.setColumnHidden(5, true);
		p_gridArea.setColumnHidden(6, true);
		p_gridArea.setColumnHidden(8, true);	
		p_gridArea.setColumnHidden(10, true);					
		fnSetColType(p_gridArea, 1, "ch");//ra : radio		
		fnSetColType(p_gridArea, 7, "img");		
		fnSetColType(p_gridArea, 9, "img");		
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	}	
	function doSearchList(){var d = setGridData();fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);}	
	function setGridData(){		
		var result = new Object();
		result.title = "${title}";
		result.key = "dim_SQL.selectDimList";
		result.header = "No,#master_checkbox,Dimension,Code,Value,ParentDimID,SCount,Deleted,MaxLevel,Sub Dimension,Deleted";	//5
		result.cols = "CHK|PlainText|DimValueID|Name|ParentID|SCount|DeletedIMG|MaxLevel|MLBtn|Deleted";
		result.widths = "50,50,1,200,250,1,1,100,1,100,1";
		result.sorting = "str,str,str,str,int,str,int,int,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center";
		result.data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;
	}
	function gridOnRowSelect(id, ind){ 
		var maxLevel = p_gridArea.cells(id,8).getValue();
		
		if(ind == 9 && (maxLevel*1) > 1) {
			var url = "getDimensionSubLevel.do";
			
			var data = "&dimValueID="+p_gridArea.cells(id,3).getValue()+"&dimTypeID=${s_itemID}"; 
			url += "?" + data;
			var option = "width=920,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
		    window.open(url, self, option);
		}
		else if(ind != 1 && maxLevel != 2){
			grid2Init(p_gridArea.cells(id, 3).getValue());
			doSetGrid2(p_gridArea.cells(id, 3).getValue());
			$("#sDimValue").val(p_gridArea.cells(id, 3).getValue());
			selectitemType();
		}
	}
	// END ::: GRID	
	//===============================================================================
	/*
	function goInfoView(avg){
		var url = "subMain.do";
		var data = "url=middleMenu/subChangeManagement&s_itemID="+avg+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var target = "iFr";
		ajaxPage(url, data, target);	
	}*/		
	//그리드 선택시 하부에 그리드
	function grid2Init(avg){		
		var d = setGrid2Data(avg);		
		p_gridArea2 = fnNewInitGrid("grdGridArea2", d);
		p_gridArea2.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea2.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		fnSetColType(p_gridArea2, 1, "ch");
		fnSetColType(p_gridArea2, 2, "img");		
		p_gridArea2.setColumnHidden(10, true);	
		p_gridArea2.setColumnHidden(11, true);	
		p_gridArea2.setColumnHidden(12, true);
		p_gridArea2.setColumnHidden(13, true);
		
		p_gridArea2.enablePaging(true,20,10,"pagingArea",true,"recInfoArea");
		p_gridArea2.setPagingSkin("bricks");
		
		
		p_gridArea2.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect2(id,ind);});
	}
	
	function setGrid2Data(avg){
		var result = new Object();
		result.title = "${menu.LN00007}";
		result.key = "dim_SQL.selectDimPertinentDetailList";  
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00016},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00013},${menu.LN00017},ItemID,SCOUNT"; //9
		result.cols = "CHK|ItemTypeImg|Identifier|ItemName|Path|ClassName|TeamName|OwnerTeamName|Name|LastUpdated|Version|ID|SCOUNT";
		result.widths = "30,30,50,70,150,*,90,80,80,80,80,50,0,0";
		result.sorting = "str,int,str,str,str,str,str,str,str,str,str,str,int";
		result.aligns = "center,center,center,center,left,left,left,center,center,center,center,center,center";
		result.data = "dimTypeID=${s_itemID}&s_itemID="+avg+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}&ItemClassCode="+$("#newClassCode").val()+"&searchValue="+$("#searchValue").val();
		return result;
	}
	
	function gridOnRowSelect2(id, ind){
		if(ind != 1){doDetail(p_gridArea2.cells(id, 12).getValue());}else{return false;}
	}
	function doDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
	}
	 
	function doSetGrid2(avg){addDim(2);var d = setGrid2Data(avg);fnLoadDhtmlxGridJson(p_gridArea2, d.key, d.cols, d.data);}
	function addDim(avg){
		if(avg == '1'){
		   $("#addNewItem").removeAttr('style', 'display: none');   
		   $("#gridDiv2").attr('style', 'display: none');
		   $("#valueInsert").attr('style', 'display: none');   
		   $("#newSearch").attr('style', 'display: none');
		   $("#dimValueName").val("");
		   $("#dimValueID").val("");
		   $("#dimValueID").attr('disabled', '');
		   $("#BeforeDimValueID").val("");
		   $("#saveType").val("New");
		   $("#dimDeleted").attr("checked", false);   
		}else{
			$("#addNewItem").attr('style', 'display: none');   
			$("#gridDiv2").removeAttr('style', 'display: none');
			$("#valueInsert").removeAttr('style', 'display: none');   
			$("#newSearch").attr('style', 'display: none');
		}if(avg == '3'){
			// Edit 버튼 클릭 이벤트
			$("#gridDiv2").attr('style', 'display: none');
			$("#valueInsert").attr('style', 'display: none');
			$("#dimValueID").attr('disabled', 'disabled'); // dimValueID 수정불가
			$("#newSearch").attr('style', 'display: none');
			
		    var checked=[];
		    p_gridArea.forEachRow(function(id){
		       if (p_gridArea.cells(id,1).isChecked())
		          checked.push(id);
		    });

			if(checked.length == 0 || checked.length > 1){
				alert("${WM00042}");
			} else {
			    $("#addNewItem").removeAttr('style', 'display: none');
			    
			    /*var checkedRows = checked.split(",");
			    for(var i = 0 ; i < checkedRows.length; i++ ){*/
			    	$("#dimValueName").val(p_gridArea.cells(checked[0], 4).getValue());
			     	$("#dimValueID").val(p_gridArea.cells(checked[0], 3).getValue());
			     	$("#BeforeDimValueID").val(p_gridArea.cells(checked[0], 3).getValue());
			     
			    	if(p_gridArea.cells(checked[0], 5).getValue() == '1'){
			    		$("#dimDeleted").attr("checked", true);
			    	}else{
			      		$("#dimDeleted").attr("checked", false);
			    	}
			   	//}
			    
				$("#saveType").val("Edit");
			}
		}
	}	
	function newDimension(){		
		//var confirmValue = "신규 정보를 생성 하시겠습니까?";		
		var confirmValue = "${CM00009}";		
		if($("#saveType").val() == "Edit"){
			//confirmValue = "정보를 수정 하시겠습니까?";
			confirmValue = "${CM00005}";
		}		
		if(confirm(confirmValue)){
			var url = "NewDimension.do";
			var data = "s_itemID=${s_itemID}"
						+"&saveType="+$("#saveType").val()
						+"&dimDeleted="+$("#dimDeleted").is(":checked")
						+"&dimValueID="+$("#dimValueID").val()
						+"&dimValueName="+$("#dimValueName").val();			
			if($("#saveType").val() == "Edit"){data = data +"&BeforeDimValueID="+$("#BeforeDimValueID").val()+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";}
			
			var target = "blankFrame";
			ajaxPage(url, data, target);			
			
			// Dimension 생성 div display none
			$("#addNewItem").attr('style', 'display: none');
			/*
			$("#dimValueName").val("");
			$("#dimValueID").val("");
			$("#BeforeDimValueID").val("");
			$("#dimDeleted").attr("checked", false);
			*/
		}
	}
	function doCheckValidation(){var isCheck=true; 
		return isCheck;		
	}
	function newItemInsert(){
		if(p_gridArea2.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");   
			alert("${WM00023}"); 
		}else{
			//if(confirm("선택된 항목을 추가 하시겠습니까?")){    
			if(confirm("${CM00012}")){    
				var checkedRows = p_gridArea2.getCheckedRows(1).split(",");
			    for(var i = 0 ; i < checkedRows.length; i++ ){
			    	var url = "NewSubDimenstion.do";
			     	var data = "DimTypeID=${s_itemID}&DimValueID="+p_gridArea.cells(p_gridArea.getSelectedId(), 3).getValue()+"&loginID=${sessionScope.loginInfo.sessionUserId}&s_itemID="+p_gridArea2.cells(checkedRows[i], 12).getValue();
			     	var target = "blankFrame";
			     	if(i+1 == checkedRows.length){data = data +"&FinalData=Final";}
			     	ajaxPage(url, data, target);
			     	p_gridArea2.deleteRow(checkedRows[i]);
				}
			}
		}	
	}	
	function delRemove(){		
		if(p_gridArea.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");   
			alert("${WM00023}"); 		
		}else{			
			//if(confirm("선택된 항목을 삭제 하시겠습니까?")){		
			if(confirm("${CM00004}")){		
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");
				for(var i = 0 ; i < checkedRows.length; i++ ){
					if(p_gridArea.cells(checkedRows[i], 6).getValue() != '0'){
						//alert(p_gridArea.cells(checkedRows[i], 3).getValue()+" 프로세스는 하위항목이 있으므로 삭제할 수 없습니다.");
						alert(p_gridArea.cells(checkedRows[i], 4).getValue()+ "${WM00024}");
						p_gridArea.cells(checkedRows[i], 1).setValue(0);
					}else{
						var url = "DelDimension.do";
						var data = "DimTypeID=${s_itemID}&DimValueID="+p_gridArea.cells(checkedRows[i], 3).getValue()+"&loginID=${sessionScope.loginInfo.sessionUserId}";
						var target = "blankFrame";
						if(i+1 == checkedRows.length){data = data +"&FinalData=Final";}
						ajaxPage(url, data, target);
					}					
				}				
			}
		}
	}	
	function delSubDim(){
		if(p_gridArea2.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요."); 
			alert("${WM00023}");
		}else{
			//if(confirm("선택된 항목을 삭제 하시겠습니까?")){
			if(confirm("${CM00004}")){		
				var checkedRows = p_gridArea2.getCheckedRows(1).split(",");
				var dimTypeId ="${s_itemID}"; 
				var dimValueId =p_gridArea.cells(p_gridArea.getSelectedId(), 3).getValue();
				var items = "";
			    for(var i = 0 ; i < checkedRows.length; i++ ){
			    	if (items == "") {
			    		items = p_gridArea2.cells(checkedRows[i], 12).getValue();
					} else {
						items = items + "," + p_gridArea2.cells(checkedRows[i], 12).getValue();
					}
			    	
			     	p_gridArea2.deleteRow(checkedRows[i]);   					
				}
			    
			    var url = "DelSubDimension.do";
				var data = "items="+items+"&dimTypeId="+dimTypeId+"&dimValueId=" + dimValueId;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		}
	}
	
	function assignDim2Item(){
		/*
		grid2child();
		$("#newSearch").removeAttr('style', 'display: none');
		$("#valueInsert").attr('style', 'display: none');		
		fnSelect('ItemTypeCode', '&Deactivated=1', 'itemTypeCode', '', 'All');*/
		
		var url = "searchNewDimItemPop.do";
		var data = "dimTypeID=${s_itemID}&dimValueID="+p_gridArea.cells(p_gridArea.getSelectedId(), 3).getValue();
		fnOpenLayerPopup(url,data,doCallBack,617,436);
		
	}
	
	function doCallBack(){}
	// [Add popup] Close 이벤트
	function addClose(avg){
		grid2Init(avg);
		doSetGrid2(avg);
	}
	
	function grid2child(){			
		var d = setGrid2Child(p_gridArea.cells(p_gridArea.getSelectedId(), 4).getValue());		
		p_gridArea2 = fnNewInitGrid("grdGridArea2", d);
		p_gridArea2.setImagePath("${root}${HTML_IMG_DIR}/");
		fnSetColType(p_gridArea2, 1, "ch");
	}
	function setGrid2Child(avg){
		var result = new Object();
		result.title = "${menu.LN00007}";
		result.key = "dim_SQL.selectDimNewSelectList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00016},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00013},${menu.LN00017}"; //5
		result.cols = "CHK|ID|ItemName|Path|ClassName|TeamName|OwnerTeamName|Name|LastUpdated|Version"; //4
		result.widths = "50,50,50,150,*,100,100,100,100,100,50"; //5
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str"; //5
		result.aligns = "center,center,center,center,left,center,center,center,left,center,center"; //5
		result.data = "dimTypeID=${s_itemID}&s_itemID="+avg+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}&mainClassCode="+$("#newClassCode").val();
		return result;
	}
	function doSetGrid2Child(){
		if($("#newClassCode").val() == ""){alert("${WM00041}");return;}		
		var d = setGrid2Child(p_gridArea.cells(p_gridArea.getSelectedId(), 3).getValue());
		fnLoadDhtmlxGridJson(p_gridArea2, d.key, d.cols, d.data);
	}	

	function selectitemType(){
		var url    = "getClassCodeOption.do"; // 요청이 날라가는 주소
		var data   = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&hasDim=1"; //파라미터들
		var target = "newClassCode";             // selectBox id	
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}	
	
	function doSearchList2(){
	
		var dimVal = $("#sDimValue").val();
		var d = setGrid2Data(dimVal);
		
		fnLoadDhtmlxGridJson(p_gridArea2, d.key, d.cols, d.data);
	}	
	
	function fnDeleteDim(){		
		var dimValueIDs = new Array;
		if(p_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}"); 		
		}else{			
			if(confirm("${CM00004}")){		
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");
				for(var i = 0 ; i < checkedRows.length; i++ ){
						dimValueIDs[i] = p_gridArea.cells(checkedRows[i], 3).getValue();
										
				}
				var url = "deleteDimension.do";
				var data = "dimTypeID=${s_itemID}&dimValueIDs="+dimValueIDs;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		}
	}	
	
</script>
</head>
<body>
	<form name="dimList" id="dimList" action="#" method="post" onsubmit="return false;">
	</form>		
	<input type="hidden" id="sDimValue" value="" />
	<!-- BIGIN :: LIST_GRID -->
	<div class="child_search mgB10">
	
		<li class="floatL pdR20">
		 <c:forEach var="prcList" items="${prcList}" varStatus="status">
		  	<c:choose>
		   		<c:when test="${prcList.CategoryCode eq 'MCN' || prcList.CategoryCode eq 'CN' || prcList.CategoryCode eq 'CN1' }" >
		   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${prcList.FromItemTypeImg}" OnClick="fnOpenParentItemPop();" style="cursor:pointer;">&nbsp;${prcList.FromItemName}
		   		 --> 
		   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${prcList.ToItemTypeImg}" OnClick="fnOpenParentItemPop();" style="cursor:pointer;">&nbsp;${prcList.ToItemName}
				 <c:if test="${prcList.ItemName ne '' && prcList.ItemName != null}">/<font color="#3333FF"><b>${prcList.ItemName}</b></font> </c:if>
		   		</c:when>
		   		<c:otherwise>
		   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${prcList.ItemTypeImg}" OnClick="fnOpenParentItemPop();" style="cursor:pointer;">&nbsp;${prcList.Path}
				  	<c:if test="${prcList.ItemName ne '' && prcList.ItemName != null}">/<font color="#3333FF"><b>${prcList.ItemName}</b></font> </c:if>
		   		</c:otherwise>
		   	</c:choose>
		   		
		  	
		  </c:forEach>
		</li>
		<li class="floatR pdR20">
			&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" id="newButton"  onclick="addDim(1)"></span>&nbsp;
			&nbsp;<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" id="newButton"  onclick="addDim(3)"></span>&nbsp;
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Remove" type="submit" onclick="delRemove()"></span>
			<c:if test="${loginInfo.sessionMlvl == 'SYS'}" >
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteDim()"></span>
			</c:if>
		</li>
	</div>
		
	<div id="gridDiv" class="mgB10">
		<div id="grdGridArea" style="height:250px; width:100%"></div>
	</div>
	<table id="addNewItem" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" style="display: none;">
		<tr>
			<td colspan="4" class="noline"><img src="${root}${HTML_IMG_DIR}/icon_mark.png">Dimension Add</td>
		</tr>
		<tr>
			<th class="viewtop">${menu.LN00015}</th>				
			<td class="viewtop"><input type="text" class="text" id="dimValueID" name="dimValueID"  value=""/></td>			
			<th class="viewtop">${menu.LN00028}</th>				
			<td class="viewtop"><input type="text" class="text" id="dimValueName" name="dimValueName"  value=""/></td>
			<th class="viewtop">Deleted</th>				
			<td class="viewtop"><input type="checkbox" id="dimDeleted" name="dimDeleted" /></td>
		</tr>
		<tr>
			<td colspan="6" class="btnlast">
				<input type="hidden" id="saveType" name="saveType" value="New">
				<input type="hidden" id="BeforeDimValueID" name="BeforeDimValueID" value="">					
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="newDimension()"></span>
			</td>
		</tr>	
	</table>
	<div id="valueInsert" class="child_search mgB10" style="display:none;">
		<li  class="count">Total  <span id="TOT_CNT"></span></li>
		<li class="L">
			&nbsp;${menu.LN00016}
			<select id="newClassCode" name="newClassCode" style="width:150px;" >
				<option value="">select</option>
			</select>	
		</li>
		<li>
			<select id="searchKey" name="searchKey" style="width:150px;">
				<option value="Name">Name</option>
			</select>
			<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="doSearchList2()" value="검색">
		</li>
		<li class="floatR">	
			&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" id="newButton1"  onclick="assignDim2Item()" ></a></span>&nbsp;
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delSubDim()"></span>
		</li>
	</div>	
	
	<div id="gridDiv2" class="mgB10">
		<div id="grdGridArea2" style="width:100%;height:100%"></div>
		<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	
	</div>
	
	
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	
</body>
</html>