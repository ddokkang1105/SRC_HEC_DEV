<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 관리자 : 사용자 -My Dimension 관리 -->
 
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
 
<script type="text/javascript">
	var p_gridArea, role_gridArea;				//그리드 전역변수
	$(document).ready(function() {	
		if("${scrnType}" == "mySpace"){
			$("#grdGridArea").innerHeight(document.body.clientHeight - 560);
			$("#grdGridArea2").attr("style","width:100%;height:"+(document.body.clientHeight - 540)+"px;");
			window.onresize = function() {
				$("#grdGridArea").innerHeight(document.body.clientHeight - 560);
				$("#grdGridArea2").attr("style","width:100%;height:"+(document.body.clientHeight - 540)+"px;");
			};
		} else {
			$("#grdGridArea").innerHeight(document.body.clientHeight - 540);
			$("#grdGridArea2").attr("style","width:100%;height:"+(document.body.clientHeight - 500)+"px;");
			window.onresize = function() {
				$("#grdGridArea").innerHeight(document.body.clientHeight - 540);
				$("#grdGridArea2").attr("style","width:100%;height:"+(document.body.clientHeight - 500)+"px;");
			};
		}
		
		gridInit();
		doSearchList();
		$("#myDimTabs").attr('style', 'display: none');
	});	
	
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		fnSetColType(p_gridArea, 1, "ch");
		fnSetColType(p_gridArea, 6, "ch");
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowSelect(id,ind);
		});	
		p_gridArea.attachEvent("onCheck", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnCheckEvent(id,ind);
		});
	}	
	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "user_SQL.userDimList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00088},${menu.LN00015},Value,DimTypeID,Set Default";	//5
		result.cols = "CHK|DimTypeName|DimValueID|DimValueName|DimTypeID|IsDefault";
		result.widths = "50,50,150,100,200,0,100";
		result.sorting = "str,str,str,str,str,str,int";
		result.aligns = "center,center,center,center,center,center,center";
		result.data = "memberID=${memberID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";

		/* 검색 조건 설정 */			
		// DimTypeID
		if($("#dimTypeId").val() != '' & $("#dimTypeId").val() != null){
			result.data = result.data +"&dimTypeId="+ $("#dimTypeId").val();
		}
		return result;
	}
	
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}	
	
	//그리드ROW선택시
	function gridOnRowSelect(id, ind){
		var dimTypeId = p_gridArea.cells(id, 5).getValue();
		var dimValueId = p_gridArea.cells(id, 3).getValue();
		

		var e = setRoleGridData();
		role_gridArea = fnNewInitGrid("myDimRoleGrid", e);
 		fnLoadDhtmlxGridJson(role_gridArea, e.key, e.cols,
 				"dimTypeId="+dimTypeId+"&dimValueId="+dimValueId+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}");
		
 		
		grid2Init(dimValueId,dimTypeId);
		doSetGrid2(dimValueId,dimTypeId);
		$("#sDimValue").val(dimValueId);
		$("#sDimType").val(dimTypeId);
		selectitemType();
		
 		$("#myDimTabs").attr('style', 'display: block');
		myDimRole();
		myDimItem();
	}
	
	function myDimItem(){
		$("#myDimItem").addClass("on");
		$("#myDimRole").removeClass("on");
		$("#myDimRoleGrid").attr('style', 'display: none');
		$("#myDimItemGrid").attr('style', 'display:block;');
	}
	
	function setRoleGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "user_SQL.getMyDimRoleList";
		result.header = "${menu.LN00024},${menu.LN00004},${menu.LN00247},${menu.LN00078}";
		result.cols = "Name|Path|CreationTime";
		result.widths = "50,100,500,150";
		result.sorting = "str,left,left,str";
		result.aligns = "center,center,center,center";
		return result;
	}
	
	function myDimRole(){
		$("#myDimItem").removeClass("on");
		$("#myDimRole").addClass("on");
		$("#myDimRoleGrid").attr('style', 'display:block; height:200px;');
		$("#myDimItemGrid").attr('style', 'display:none;');
		
	}
	
	function gridOnCheckEvent(id, ind){
		if(ind == 6){
			var dimTypeID = p_gridArea.cells(id, 5).getValue();
			var checkedRows = p_gridArea.getCheckedRows(6).split(",");
			
			for(var i = 0 ; i < checkedRows.length; i++ ){
				var chkValue = p_gridArea.cells(checkedRows[i], 5).getValue();
				if(dimTypeID == chkValue){
					p_gridArea.cells(checkedRows[i],6).setValue(0);
					p_gridArea.cells(id,6).setValue(1);
				}
			}
		}
	}
	
	// [Assign] click 이벤트	
	function assignOrg(){
		var url = "myDimAssignTreePop.do";
		var data = "memberID=${memberID}";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	function doCallBack(){}
	
	// [Assign popup] Close 이벤트
	function assignClose(){
		doSearchList();
	}
	
	function saveDimension(){
		var rowsNum = p_gridArea.getRowsNum()
		var isDeaultIds = "";
		var dimValueIds =""; 
		var dimTypeIds =""; 
		for(var i = 1 ; i < rowsNum+1; i++ ){
			if (dimTypeIds == "") {
				isDeaultIds = p_gridArea.cells(i, 6).getValue();
				dimTypeIds = p_gridArea.cells(i, 5).getValue();
				dimValueIds = p_gridArea.cells(i, 3).getValue();
			} else {
				isDeaultIds = isDeaultIds + "," + p_gridArea.cells(i, 6).getValue();
				dimTypeIds = dimTypeIds + "," + p_gridArea.cells(i, 5).getValue();
				dimValueIds = dimValueIds + "," + p_gridArea.cells(i, 3).getValue();
			}
		}
		var url = "saveDimensionForUser.do";
		var data = "memberID=${memberID}&isDeaultIds="+isDeaultIds+"&dimTypeIds="+dimTypeIds+"&dimValueIds=" + dimValueIds;
		var target = "blankFrame";
		ajaxPage(url, data, target);			
	}
	
	// [Del] Click
	function delDimension() {
		if(p_gridArea.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");	
			alert("${WM00023}");	
		}else{
			if(confirm("${CM00004}")){
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");
				var dimValueIds =""; 
				var dimTypeIds =""; 
				for(var i = 0 ; i < checkedRows.length; i++ ){
					if (dimTypeIds == "") {
						dimTypeIds = p_gridArea.cells(checkedRows[i], 5).getValue();
						dimValueIds = p_gridArea.cells(checkedRows[i], 3).getValue();
					} else {
						dimTypeIds = dimTypeIds + "," + p_gridArea.cells(checkedRows[i], 5).getValue();
						dimValueIds = dimValueIds + "," + p_gridArea.cells(checkedRows[i], 3).getValue();
					}
				}
				
				var url = "delDimensionForUser.do";
				var data = "memberID=${memberID}&dimTypeIds="+dimTypeIds+"&dimValueIds=" + dimValueIds;
				var target = "blankFrame";
				ajaxPage(url, data, target);			
			}
		}	
	}
	
	//그리드 선택시 하부에 그리드
	function grid2Init(avg,avg2){		
		var d = setGrid2Data(avg,avg2);		
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
	
	function setGrid2Data(avg,avg2){
		var result = new Object();
		result.title = "${menu.LN00007}";
		result.key = "dim_SQL.selectDimPertinentDetailList";  
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00016},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00013},${menu.LN00017},ItemID,SCOUNT"; //9
		result.cols = "CHK|ItemTypeImg|Identifier|ItemName|Path|ClassName|TeamName|OwnerTeamName|Name|LastUpdated|Version|ID|SCOUNT";
		result.widths = "30,30,50,70,150,*,90,80,80,80,80,50,0,0";
		result.sorting = "str,int,str,str,str,str,str,str,str,str,str,str,int";
		result.aligns = "center,center,center,center,left,left,left,center,center,center,center,center,center";
		result.data = "dimTypeID="+avg2+"&s_itemID="+avg+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}&ItemClassCode="+$("#newClassCode").val()+"&searchValue="+$("#searchValue").val();
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
	 
	function doSetGrid2(avg,avg2){addDim(2);var d = setGrid2Data(avg,avg2);fnLoadDhtmlxGridJson(p_gridArea2, d.key, d.cols, d.data);}
	
	function selectitemType(){
		var url    = "getClassCodeOption.do"; // 요청이 날라가는 주소
		var data   = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&hasDim=1"; //파라미터들
		var target = "newClassCode";             // selectBox id	
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}	
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
	
	function assignDim2Item(){
		/*
		grid2child();
		$("#newSearch").removeAttr('style', 'display: none');
		$("#valueInsert").attr('style', 'display: none');		
		fnSelect('ItemTypeCode', '&Deactivated=1', 'itemTypeCode', '', 'All');*/
		
		var url = "searchNewDimItemPop.do";
		var data = "dimTypeID=${memberID}&dimValueID="+p_gridArea.cells(p_gridArea.getSelectedId(), 3).getValue();
		fnOpenLayerPopup(url,data,doCallBack,617,436);
		
	}
	
	function delSubDim(){
		if(p_gridArea2.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요."); 
			alert("${WM00023}");
		}else{
			//if(confirm("선택된 항목을 삭제 하시겠습니까?")){
			if(confirm("${CM00004}")){		
				var checkedRows = p_gridArea2.getCheckedRows(1).split(",");
				var dimTypeId =p_gridArea.cells(p_gridArea.getSelectedId(), 5).getValue();
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
		
	function doCallBack(){}
	
	function doSearchList2(){
		
		var dimVal = $("#sDimValue").val();
		var dimType = $("#sDimType").val();
		var d = setGrid2Data(dimVal,dimType);
		
		fnLoadDhtmlxGridJson(p_gridArea2, d.key, d.cols, d.data);
	}
</script>
<input type="hidden" id="sDimValue" value="" />
<input type="hidden" id="sDimType" value="" />
<c:if test="${scrnType eq 'mySpace' }">
	<h3 class="pdT10 pdB10" style="border-bottom:1px solid #ccc;  "><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic" />&nbsp;Dimension</h3>
</c:if>
<div class="child_search01 pdT10 pdB10">
	<li class="mgL10">
       <select id="dimTypeId" Name="dimTypeId">
           <option value=''>Select</option>
       	   <c:forEach var="i" items="${dimTypeList}">
               <option value="${i.DimTypeID}">${i.DimTypeName}</option>
       	    </c:forEach>
   	   </select> 
   	   <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList();" value="검색" style="cursor:pointer;">   
	</li>
	<c:if test="${authLev eq '1' }">
	 <li class="floatR pdR20">
		<span class="btn_pack small icon"><span class="assign"></span><input value="Assign" type="submit" onclick="assignOrg()"></span>&nbsp;
		<span class="btn_pack small icon"><span class="save"></span><input value="Save" type="submit" onclick="saveDimension()"></span>&nbsp;
		<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delDimension();"></span>
	</li>
	</c:if>
</div>
<!-- BIGIN :: LIST_GRID -->
<div id="gridDiv">
	<div id="grdGridArea" style="width:100%;"></div>
</div>
<!-- END :: LIST_GRID -->

<div class="SubinfoTabs mgT15" id="myDimTabs">
	<ul>
		<li id="myDimItem"><a href="javascript:myDimItem();"><span>${menu.LN00087}</span></a></li>
		<li id="myDimRole" ><a href="javascript:myDimRole();"><span>${menu.LN00004}</span></a></li>
	</ul>
</div>

<div class="mgT10">
	<div id="myDimItemGrid" style="width:100%;">	
		<div id="valueInsert" class="child_search01 mgB10" style="display:none;">
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
			<c:if test="${authLev eq '1' }">
			<li class="floatR">	
				&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" id="newButton1"  onclick="assignDim2Item()" ></a></span>&nbsp;
				&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delSubDim()"></span>
			</li>
			</c:if>
		</div>
		<div id="gridDiv2" class="mgB10">
			<div id="grdGridArea2" style="width:100%;height:100%"></div>
			<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
		</div>
	</div>
	<div id="myDimRoleGrid" style="width:100%; display: none;"></div>
</div>

<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" frameborder="0" style="display:none"></iframe>
</div>	
<!-- END :: FRAME -->