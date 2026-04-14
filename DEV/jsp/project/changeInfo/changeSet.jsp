<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00026" var="WM00026" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00115" var="WM00115" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00129" var="WM00129" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00025" var="CM00025" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00026" var="CM00026_1" arguments="${menu.LN00181}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00026" var="CM00026_2" arguments="${menu.LN00203}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00026" var="CM00026" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00049" var="CM00049" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00050" var="CM00050" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>
<style>
 	.mod_col {
		color:blue;
		font-weight:bold
	}
	.remain_col{
	color:#000000;
	}
</style>
<!-- 2. Script  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var csrList = "${csrList}";
	var screenType = "${screenType}";
	var sessionState = "${sessionScope.loginInfo.sessionState}";
	var myTeam = "${myTeam}";

	$(document).ready(function() {
		$("input.datePicker").each(generateDatePicker); // calendar

		//fnSelect('Status','&Category=CNGSTS','getDicWord','${chgsts}', 'Select');
		//fnSelect('ChangeType', '&Category=CNGT1', 'getDicWord', 'Select');
		
		$("#Project").SumoSelect({parentWidth: 98});
		$("#csrList").SumoSelect({parentWidth: 98});
		$("#Status").SumoSelect({parentWidth: 98, defaultValues: "${status}"});
		$("#ChangeType").SumoSelect({defaultValues: "${changeType}", parentWidth: 98});
		$("#classCode").SumoSelect({defaultValues: "${classCodes}", parentWidth: 98});
		$("#dimTypeId").SumoSelect({parentWidth: 40});
		$('#dimValueId').SumoSelect({parentWidth: 50});
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('Company',data+'&teamType=2','getTeam','','Select');
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		};

		$("#excel").click(function (){	fnGridExcelDownLoad();	});
		
		$('#dimTypeId').change(function(){changeDimValue($(this).val());});
		if('${myPjtId}' != "") {
			//changeCsrList('${myPjtId}'); // 변경오더 option 셋팅
			$("#Project")[0].sumo.selectItem('${myPjtId}');
	
			if( sessionState != null && sessionState != "") {
				changeDimValue("100001");
				$("#dimTypeId")[0].sumo.selectItem("100001");
				setTimeout(function() { 
					$("#dimValueId")[0].sumo.selectItem(sessionState);
				},800 );
			}
		}
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	 
	// [dimValue option] 설정
	function changeDimValue(avg){
		var url    = "getDimValueSelectOption.do"; // 요청이 날라가는 주소
		var data   = "dimTypeId="+avg+"&searchYN=Y"; //파라미터들
		var target = "dimValueId";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(appendDimOption,500);
	}	

	function appendDimOption(){
		$("#dimValueId")[0].sumo.reload();
	}
		
	function fnClearSearch(){
		$("#Company").val("");
		$("#REQ_STR_DT").val("");
		$("#REQ_END_DT").val("");
		$("#MOD_STR_DT").val("${modStartDT}");
		$("#MOD_END_DT").val("${modEndDT}");
		$("#VF_STR_DT").val("");
		$("#VF_END_DT").val("");
	
		$("#CLS_STR_DT").val("${clsStartDt}");
		$("#CLS_END_DT").val("${clsEndDt}");
		
		$("#authorTeamName").val("");
		$("#dimTypeId")[0].sumo.selectItem(0);
		fnResetSelectBox("dimValueId","");
		$('#dimValueId')[0].sumo.reload();
 	    fnClearFilter("ClassCode");
 		fnClearFilter("Identifier");
 		
		fnClearFilter("AuthorName");
 	    fnClearFilter("ItemName");
 	    fnClearFilter("PjtName");
 	    fnClearFilter("csrName");
 	    fnClearFilter("ChangeType");
 	    fnClearFilter("StatusName");
		return;
	}

	function fnResetSelectBox(objName,defaultValue){
		$("select[name='"+ objName +"'] option").not("[value='"+defaultValue+"']").remove(); 
	}
</script>

<form name="changeInfoLstAdmFrm" id="changeInfoLstAdmFrm" method="post" action="#" onsubmit="return false;">
<div class="pdL10 pdR10 pdT10">	
   	<input type="hidden" id="item" name="item" value=""></input>
	<input type="hidden" id="cngt" name="cngt" value=""></input> 
	<input type="hidden" id="pjtId" name="pjtId" value=""></input>
	<input type="hidden" id="pjtCreator" name="pjtCreator" value="${pjtCreator}"></input>
	<input type="hidden" id="currPageA" name="currPageA" value="${currPageA}"></input>
	
	<!-- 화면 타이틀 : 변경항목 목록-->
	<div class="floatL msg" style="width:100%"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png"  id="subTitle_baisic">&nbsp;&nbsp;${menu.LN00205}
	</div><div style="height:10px"></div>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
			<colgroup>
		    <col width="5%">
			<col width="15%">
	
	    </colgroup>
	    <tr>
	
	       	<!-- 법인 -->
	       	<th class="alignL">${menu.LN00014}</th>
			<td class="alignL last" >	 
				<select id="Company" name="Company" class="sel"></select>
			</td>
		 	<!-- 명칭 -->
	       	<th class="alignL" style ="display:none;">${menu.LN00028}</th>
	       	<td class="alignL" style ="display:none;">
	       		<input type="text" class="stext" id="searchValue" name="searchValue" value="" style="width:92.8%;ime-mode:active;"/>  
	       	</td>
	       	
	   		<!-- Dimension -->
	       	<th class="alignL">${menu.LN00088}</th>
	       	<td class="alignL">  
	       	  
	       		<select id="dimTypeId" name="dimTypeId" class="sel" style="float:left;">
		    		<option value=''>Select</option>
           	   		<c:forEach var="i" items="${dimTypeList}">
                   		<option value="${i.DimTypeID}">${i.DimTypeName}</option>
           	    	</c:forEach>
				</select>
				<select id="dimValueId" name="dimValueId" multiple="multiple" class="sel" style="float:left; margin-left: 5%;min-height:15px; ">
					<option value="">Select</option>
				</select>
				</td>
	       	
	        <!-- 담당자 -->
	        <th class="alignL" style="display: none;">${menu.LN00004}</th>
	        <td class="alignL" style="display: none;">
	        	<input type="text" class="stext" id="authorName" name="authorName" value="" style="width:92.8%;ime-mode:active;" />  
	        </td>	
	       	
	   		<!-- 담당조직 -->
	       	<th class="alignL">${menu.LN00018}</th>
	       	<td class="alignL last">
	       		<input type="text" class="stext" id="authorTeamName" name="authorTeamName" value="" style="width:92.8%;ime-mode:active;" />  
	       	</td>
	      </tr>
	      <tr> 
	      	<!-- 등록일 -->
	        <th class="alignL">${menu.LN00063}</th>
	        <td class="alignL">     
	            <input type="text" id="REQ_STR_DT" name="REQ_STR_DT" value=""	class="input_off datePicker text" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
				~
				<input type="text" id="REQ_END_DT" name="REQ_END_DT" value=""	class="input_off datePicker text" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
	         </td>
	         
	         
	        <!-- 수정일 -->
	        <th class="alignL">${menu.LN00070}</th>
	        <td class="alignL">
	            <input type="text" id="MOD_STR_DT" name="MOD_STR_DT" value="${modStartDT}"	class="input_off datePicker text" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
				~
				<input type="text" id="MOD_END_DT" name="MOD_END_DT" value="${modEndDT}"	class="input_off datePicker text" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				  
	        </td>		        
	        
	         
	        <!-- 완료일 -->
	        <th class="alignL">${menu.LN00095}</th>
	        <td class="alignL">
	            <input type="text" id="CLS_STR_DT" name="CLS_STR_DT" value="${clsStartDt}"	class="input_off datePicker text" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
				~
				<input type="text" id="CLS_END_DT" name="CLS_END_DT" value="${clsEndDt}" class="input_off datePicker text" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
	         </td>	
	         
	        <!-- 시행일 -->
	        <th class="alignL">${menu.LN00296}</th>
	        <td class="alignL">     
		        <input type="text" id="VF_STR_DT" name="VF_STR_DT" value=""	class="input_off datePicker text" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
				~
				<input type="text" id="VF_END_DT" name="VF_END_DT" value="" class="inpufnsearcht_off datePicker text" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
	        </td>      	
	      </tr>
	       	
    </table>
    
	<div class="mgT5" align="center">
		&nbsp;<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="fnSearch()" style="cursor:pointer;"/>
		<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="fnClearSearch();" >
	</div>
	
    <div class="countList pdT10">
	    <li class="count">Total  <span id="TOT_CNT"></span></li>
	    <li class="floatR">
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>
 	</div>
	<!-- GRID -->	
	<div id="gridCngtDiv" style="width:100%;" class="clear">
		<div id="grdGridArea"></div>
		<div id="pagination"></div></div>
	</div>
	<!-- END :: LIST_GRID -->
</div>
</form>

<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>



<script type="text/javascript">
		var layout = new dhx.Layout("grdGridArea", {
			rows : [ {
				id : "a",
			}, ]
		});	
		var gridData = ${chgSetData}; 
		
		var grid = new dhx.Grid("grdGridArea", {
		    columns: [
		        { width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ hidden: true, width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
		        { width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}" , align: "center"}],htmlEnable:true, align: "center",
		        	template:function (text,row,col){
		        		return  '<img src="${root}${HTML_IMG_DIR_ITEM}/'+row.ItemTypeImg+'" width="18" height="18">';
		        	}	
		        },
		        { width: 90, id: "ClassCode", header: [{ text: "${menu.LN00016}" , align: "center" }, { content: "selectFilter" }], align: "center"},
		        { width: 120, id: "Identifier", header: [{ text: "${menu.LN00015}" , align: "center" }, { content: "inputFilter" }],align:"center"},
		        { width: 410, id: "ItemName", header: [{ text: "${menu.LN00028}" , align: "center" }, { content: "inputFilter" }],align:"left"},
		        { width: 60, id: "Version", header: [{ text: "Version" , align: "center" }, { content: "selectFilter" }],align: "center" },
		        { width: 100, id: "AuthorName", header: [{ text: "${menu.LN00004}" , align: "center" }, { content: "inputFilter" }],align: "center"},
		        { width: 170, id: "PjtName", header: [{ text: "${menu.LN00131}" , align: "center" }, { content: "selectFilter" }],align: "center" },
		        { width: 150, id: "csrName", header: [{ text: "${menu.LN00191}" , align: "center" }, { content: "selectFilter" }],align: "center" },
		        { width: 80, id: "ChangeType", header: [{ text: "${menu.LN00022}" , align: "center" }, { content: "selectFilter" }],align: "center" },
		        { width: 80, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" }, { content: "selectFilter" }], htmlEnable: true, 
		        	 mark: function (cell, data) { 
		        		 if(cell==='편집 중'){return "mod_col";}
		        		 else return "remain_col";
		        		  },align: "center"},
		        { width: 80, id: "CreationTime", header: [{ text: "${menu.LN00063}" , align: "center" }, { content: "" }], align: "center" },
		        { width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00070}" , align: "center" }, { content: "" }], align: "center" },
		        { width: 80, id: "ApproveDate", header: [{ text: "${menu.LN00095}" , align: "center" }, { content: "" }], align: "center" },
		        { hidden:true,width: 0, id: "ChangeSetID", header: [{ text: "ChangeSetID" , align: "center" }, { content: "" }], align: "center" },
		        { hidden:true,width: 0, id: "ItemID", header: [{ text: "" , align: "center" }, { content: "" }], align: "center" },
		        { hidden:true,width: 0, id: "StatusCode", header: [{ text: "" , align: "center" }, { content: "" }], align: "center" },
		        { hidden:true,width: 0, id: "AuthorID", header: [{ text: "" , align: "center" }, { content: "" }], align: "center" },
		        { hidden:true,width: 0, id: "CreationTime2", header: [{ text: "" , align: "center" }, { content: "" }], align: "center" },
		        { width: 80, id: "ValidFrom", header: [{ text: "${menu.LN00296}" , align: "center" }, { content: "" }], align: "center" },
		        { hidden:true,width: 0, id: "ChangeTypeCode", header: [{ text: "" , align: "center" }, { content: "" }], align: "center" },
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: gridData
		});
		
		$("#TOT_CNT").html(grid.data.getLength());
		layout.getCell("a").attach(grid);

	
		var pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 40,
		});	
		
		pagination.setPage(document.getElementById('currPageA').value);
		
		function fnSearch(){
			let	sqlID = "cs_SQL.getChangeSetMultiList";	
			/* [Dimension] 조건 선택값 */		
			if ($("#dimTypeId").val() != "") {
				var dvArray = new Array();
				var isNotYN = "N";
				$("#dimValueId :selected").each(function(i, el){ 
					var dvTemp = $(el).val();
					if (dvTemp != "" && "nothing" != dvTemp) {
						dvArray.push(dvTemp);
					} else {
						isNotYN = "Y";
						dvArray.push(dvTemp);
					}
				});
			}
			
			let param = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			 	        +"&screenType="+screenType
			 	        +"&pageNum="+$("#currPageA").val()
						+"&searchValue="+$("#searchValue").val()
						+"&authorName="+$("#authorName").val()
						+"&Company="+$("#Company").val()
						+"&DimTypeID="+$("#DimTypeID").val()
						+"&DimTypeID=" + $("#dimTypeId").val() 
						+ "&isNotIn="+isNotYN
						+"&DimValueIDOLM_ARRAY_VALUE="+dvArray
						+"&authorTeamName="+$("#authorTeamName").val()
						+"&reqStartDt="+$("#REQ_STR_DT").val()
						+"&reqEndDt="+$("#REQ_END_DT").val()
						+"&modStartDt="+$("#MOD_STR_DT").val()
						+"&modEndDt="+$("#MOD_END_DT").val()
						+"&clsStartDt="+$("#CLS_STR_DT").val()
						+"&clsEndDt="+$("#CLS_END_DT").val()
						+"&vfStartDt="+$("#VF_STR_DT").val()
						+"&vfEndDt="+$("#VF_END_DT").val()
						+"&sqlID="+sqlID;	 		
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
	 		fnClearFilter("ClassCode");
	 		fnClearFilter("Identifier");
	 		fnClearFilter("Version");
	 	    fnClearFilter("AuthorName");
	 	    fnClearFilter("ItemName");
	 	    fnClearFilter("PjtName");
	 	    fnClearFilter("csrName");
	 	    fnClearFilter("ChangeType");
	 	    fnClearFilter("StatusName");
	 	    
	 	    grid.data.parse(newGridData);
			$("#TOT_CNT").html(grid.data.getLength());
			fnMasterChk('');
	 	}
		
	 	function fnClearFilter(columnID) {
	 		var headerFilter = grid.getHeaderFilter(columnID);
	 		if(headerFilter){
		 	    grid.getHeaderFilter(columnID).clear()
		  }
	 	}

		//그리드ROW선택시
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox" && column.id == "ItemTypeImg"){
				gridOnRowSelect(row);
			}else{
				goInfoView(row.ChangeSetID, row.StatusCode, row.ItemID);
			}
		}); 
		

		//구분 칼럼 Click : Item popup 표시 변경항목 상세 화면으로 이동 
		function gridOnRowSelect(row){
			var isAuthorUser = "N";
			var changeType =row.ChangeTypeCode;
			var itemId = row.ItemID;
			var changeSetID = row.ChangeSetID;
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop&option=CNGREW&changeSetID="+changeSetID;
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,itemId);
		}
		
		// 그 외 [Row Click] 이벤트
		function goInfoView(avg1, avg2, avg3){			
			var url = "viewItemChangeInfo.do?changeSetID="+avg1+"&StatusCode="+avg2
						+ "&ProjectID=${ProjectID}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&isNew=${isNew}&s_itemID=${s_itemID}"
						+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&currPageA=" + $("#currPageA").val()
						+ "&myPjtId=${myPjtId}&itemID="+avg3;
			var w = 1200;
			var h = 500; 
			itmInfoPopup(url,w,h);
		}

		
</script>



