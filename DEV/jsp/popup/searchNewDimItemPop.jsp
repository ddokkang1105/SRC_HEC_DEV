<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00021}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00016}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<!-- Dhtmlx grid  upgrade  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 2. Script -->
<script type="text/javascript">
    
	$(document).ready(function() {	
		fnSelect('ItemTypeCode', '&Deactivated=1', 'itemTypeCode', '', 'Select');
	});	


	function doSetGridPopData(){
		if($("#ItemTypeCode").val() == ""){alert("${WM00041_1}");return false;}	
		if($("#newClassCodePop").val() == ""){alert("${WM00041_2}");return false;}	
		gridinit();			
	}	

	function gridinit() {
		var	sqlID = "dim_SQL.selectDimNewSelectList";	
		var param = "dimTypeID=${dimTypeID}&s_itemID=${dimValueID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&mainClassCode="
					+$("#newClassCodePop").val()
					+"&sqlID="+sqlID;	 		
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
				    grid.data.parse(result);
				    $("#TOT_CNT2").html(grid.data.getLength());
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});	 
	}
	
	function selectitemType(avg){
		var url    = "getClassCodeOption.do"; // 요청이 날라가는 주소
		var data   = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+avg+"&hasDim=1"; //파라미터들
		var target = "newClassCodePop";             // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}	
	// END ::: GRID	
	//===============================================================================
		
	function addNewDimItem(){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
			alert("${WM00023}");	
		}else{
			if(confirm("${CM00012}")){    //if(confirm("선택된 항목을 추가 하시겠습니까?"))
			    for(idx in selectedCell){
			    	var url = "admin/NewSubDimension.do";
			     	var data = "DimTypeID=${dimTypeID}&DimValueID=${dimValueID}&loginID=${sessionScope.loginInfo.sessionUserId}&s_itemID="+selectedCell[idx].ID;
			     	var target = "blankFrame";
			     	if(parseInt(idx)+1 == selectedCell.length){data = data +"&FinalData=Final";}
			     	ajaxPage(url, data, target);
				}
			    
			    $(".popup_div").hide();
				$("#mask").hide();
			}
		}	
	}
		
</script>


<div class="popup01">
<ul>
  <li class="con_zone">
	<div class="title popup_title"><span class="pdL10"> Search</span>
		<div class="floatR mgR10">
			<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close">
		</div>
	</div> 
	<div class="szone">
		<div class="child_search">
			<table class="tbl_popup" cellpadding="0" cellspacing="0" border="0" width="100%">
            	<colgroup>
            		<col width="70%">
            		<col>
            	</colgroup>
	            	<tr>
	               		<td class="pdL10 alignL">
							&nbsp;${menu.LN00021}
							<select id="ItemTypeCode" name="ItemTypeCode" onchange="selectitemType(this.value)" ></select>
							&nbsp;${menu.LN00016}				
							<select id="newClassCodePop" name="newClassCodePop"></select> 
							<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSetGridPopData();" value="검색">              		
						</td>
						<td class="alignR pdR10">
							&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="addNewDimItem()"></span>
						</td>
	               	</tr>
       			</table>
       		</div>
  		<div class="con01 mgL10">	
     		<div class="alignL mgT5 mgB5">	
				<p style="color:#1141a1;">Total  <span id="TOT_CNT2"></span></p>
			</div>
			<div id="grdGridAreaPop" style="width:100%;height:250px;overflow:auto;"></div>  		
		</div>
	</div>
	</li>
	</ul>
</div>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>


<script type="text/javascript">

 
	var layout = new dhx.Layout("grdGridAreaPop", {
		rows : [ {
			id : "c",
		}, ]
	});	 
	 var gridData = "${gridData}"; 


	var grid = new dhx.Grid("grdGridAreaPop", {
		  columns: [

			  	{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center",rowspan:2 }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" 
					, align: "center", rowspan: 2}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 100, id: "Identifier", header: [{ text: "${menu.LN00015}" , align: "center" },{ content: "inputFilter" }],align: "center"},
				{ width: 200, id: "ItemName", header: [{ text: "${menu.LN00028}" , align: "center" },{ content: "inputFilter" }], align: "left"},
				{ width: 250, id: "Path", header: [{ text: "${menu.LN00043}" , align: "center" }], align: "left" },
				{ width: 100, id: "ClassName", header: [{ text: "${menu.LN00016}" , align: "center" }], align: "center" },	
				{ width: 80, id: "TeamName", header: [{ text: "${menu.LN00014}" , align: "center" },{ content: "selectFilter" }], align: "center" },
				{ width: 120, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}" , align: "center" },{ content: "selectFilter" }], align: "center" },
				{ width: 150, id: "Name", header: [{ text: "${menu.LN00004}" , align: "center" }], align: "center" },
				{ hidden:true,width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00013}" , align: "center" }], align: "center" },
				{ hidden:true,width: 80, id: "Version", header: [{ text: "${menu.LN00017}" , align: "center" }], align: "center" },
				{ hidden:true,width: 80, id: "ID", header: [{ text: "ItemID" , align: "center" }], align: "center"}
			],
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
		data: gridData
	}); 

	layout.getCell("c").attach(grid);
 
	$("#TOT_CNT2").html(grid.data.getLength());


</script>