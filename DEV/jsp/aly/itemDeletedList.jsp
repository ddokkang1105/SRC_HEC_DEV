<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
 
 
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00046" var="CM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00048" var="CM00048"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00148" var="WM00148"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	$(document).ready(function() {
		// SKON CSRF 보안 조치
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
				}
		})		
		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px; width:100%;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px; width:100%;");
		};
		
		fnSelect('status', "languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=ITMSTS", 'getDictionaryOrdStnm', '', 'Select');
		fnSelect('itemTypeCode', "sessionCurrLangType=${sessionScope.loginInfo.sessionCurrLangType}", 'itemTypeCode', '', 'Select');
		
		$('#itemTypeCode').change(function(){
			changeItemTypeCode($(this).val()); // 계층 option 셋팅
		});
		// 속성 option 셋팅 : 선택된 classCode를 조건으로
		$('#classCode').change(function(){changeClassCode($(this).val(), "");});
		
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function changeItemTypeCode(avg){
		var url    = "getClassCodeOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+avg; //파라미터들
		var target = "classCode";             // selectBox id
		var defaultValue = "${classCode}";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}

	function doSearchList(){
 		var sqlID = "analysis_SQL.getItemDeletedList";
 		
		var param = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&status=" + $("#status").val()
			+ "&itemTypeCode=" + $("#itemTypeCode").val()
			+ "&classCode=" + $("#classCode").val()
			+ "&sqlID="+sqlID;
		
 		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
		 		grid.data.parse(result);
		 		fnMasterChk('');
		 		$("#TOT_CNT").html(grid.data.getLength());
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
		
	}
	
	function doDetail(avg){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}
	
	function urlReload(){
		var url = "itemDeletedList.do";
		var target="help_content";
		ajaxPage(url, "", target);
	}
	
	/**  
	 * [Recover][Delete Item Master] 버튼 이벤트
	 */
	function fnRecoverItem(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");
			return false;
		} else {
			   // 배열의 길이가 하나이상 있음 1 => !TRUE ==FALSE
			if(confirm("${CM00048}")){ 
				var items = new Array();
				for(idx in selectedCell){
					items[idx] = selectedCell[idx].ItemID;
				}
				var url = "admin/deletedItemRecover.do";
				var data = "&items=" + items;
				var target = "help_content";
				
				ajaxPage(url, data, target);
				
			}
		}
	}
	
	/**  
	 * [Delete Item Master] 버튼 이벤트
	 */
	function fnDeleteItemMaster(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");
			return false;
		} else {
			   // 배열의 길이가 하나이상 있음 1 => !TRUE ==FALSE
			if(confirm("${CM00046}")){ 
				var items = new Array();
				for(idx in selectedCell){
					items[idx] = selectedCell[idx].ItemID;
				}
				
				var url = "admin/delItemMaster.do";
				var data = "&items=" + items;
				var target = "help_content";
				
				ajaxPage(url, data, target);
				
			}
		}		
		
	}
	
	
</script>
<body>
<form name="itemDeletedList" id="itemDeletedList" action="#" method="post"  onsubmit="return false;">
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	
	<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Deleted List(Item)</div>
	
	<div class="child_search">
		<li>			
			<li>
			${menu.LN00021} &nbsp;&nbsp; 		
			<select id="itemTypeCode" Name="itemTypeCode" style="width:150px;">
				<option value="" >Select</opiton> 
			</select>
			&nbsp;
			&nbsp;
			${menu.LN00016} &nbsp;&nbsp; 		
			<select id="classCode" Name="classCode" style="width:150px;">
				<option value="" >Select</opiton> 
			</select>
			&nbsp;
			&nbsp;
			${menu.LN00027} &nbsp;&nbsp; 		
			<select id="status" Name="status" style="width:150px;">
				<option value="" >Select</opiton> 
			</select>
			&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="doSearchList()" style="cursor:pointer;"/>
			</li>
		</li>
		<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="edit"></span><input value="Recover" type="submit" onclick="fnRecoverItem();"></span>
				&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="edit"></span><input value="Delete Item Master" type="submit" onclick="fnDeleteItemMaster();"></span>
			</c:if>
		</li>
	</div>
	
   	<div class="countList pdT5">
    	<li  class="count">Total  <span id="TOT_CNT"></span></li>
   	</div>
   	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>	
</form>
	
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	var pagination;
	
	var gridData = ${gridData};
	
	var grid = new dhx.Grid("grid",  {
	    columns: [
			{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center"}], align:"center"},
	        { width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", align:"center" }], align: "center", type: "boolean", editable: true, sortable: false},
	        
	        { width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}", align:"center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR_ITEM}/' + row.ItemTypeImg + '" width="18" height="18">';
	            }
	        },
	        
	        { width: 120, id: "ClassName", header: [{text: "${menu.LN00016}", align:"center"}], align: "center"},
	        { width: 140, id: "Identifier", header: [{text: "${menu.LN00015}", align:"center"}], align: "center"},
	        { width: 220, id: "ItemName", header: [{ text: "${menu.LN00028}", align:"center" }], htmlEnable: true, align:"left"},	
	        { width: 520, id: "Path", header: [{ text: "${menu.LN00043}", align:"center"}], align:"left"},
	        	        
	        { width: 120, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}", align:"center" }], align:"center"},
	        { width: 120, id: "Name", header: [{ text: "${menu.LN00004}", align:"center" }], align:"center"},
	        { width: 100, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align:"center"},
	        { width: 100, id: "StatusName", header: [{ text: "${menu.LN00027}", align:"center" }], align:"center", htmlEnable: true},
	        { width: 0, id: "ItemID", header: [{ text: "ItemID", align:"center" }], align:"center", hidden: true},
	        { width: 0, id: "ClassCode", header: [{ text: "ClassCode", align:"center" }], align:"center", hidden: true},
	        { width: 0, id: "Status", header: [{ text: "Status", align:"center" }], align:"center", hidden: true},
	      
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true   
	    
	});
	
	$("#TOT_CNT").html(grid.data.getLength());

	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "checkbox"){
			doDetail(row.ItemID);
		}
		
	 }); 
	
	 layout.getCell("a").attach(grid);
	 
	 if(pagination){pagination.destructor();}
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});

</script>	
</body>
</html>