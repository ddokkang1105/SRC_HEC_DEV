<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00016}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00043}"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%-- <%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%> --%>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css" />
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<body>
	<div class="pdL20 pdR20">
		<div class="btn-wrap">
			<div class="page-title new-form">
			</div>
			<div class="btns pdB15 pdT15">
<!-- 				<button class="secondary" onclick="newItemInsert()">Create and assign</button> -->
				<button class="secondary" onclick="cxnItemDelete()">Del</button>
				<button class="primary" onclick="openSearchItemListPop()">Add</button>
			</div>
		</div>
		<!-- 
		<table id="addNewItem" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" >
			<colgroup>
				<col width="15%">
				<col width="30%">
				<col width="15%">
				<col width="30%">
			</colgroup>
			<tr>
				<th>Code</th>
				<td><input type="text" class="text" id="newIdentifier" name="newIdentifier"/></td>
				<th>${menu.LN00028}</th>
				<td class="last"><input type="text" class="text" id="newItemName" name="newItemName"/></td>
			</tr>	
			<tr>
				<th>${menu.LN00016}</th>
				<td>
					<select id="newClassCode" name="newClassCode" class="sel">
					<c:forEach var="i" items="${classOption}">
						<option value="${i.ItemClassCode}"  >${i.Name}</option>						
					</c:forEach>				
					</select>
				</td>
				<th>${menu.LN00043}</th>
				<td class="last"><input type="text"class="text" id="parentItemPath" name="parentItemPath" readonly="readonly" onclick="itemTypeCodeTreePop();"/></td>
			</tr>
		</table>
		 -->
		<div id="layout" style="width: 100%"></div>
	</div>
	<form name ="searchItemListPop" >
		<input type="hidden" name="classCodes" />
		<input type="hidden" name="itemTypeCode" />
		<input type="hidden" name="items" />
	</form>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	<script>	
		searchList();
	
		document.querySelector("#layout").style.height = setWindowHeight() - 123+"px";
		window.onresize = function() {
			document.querySelector("#layout").style.height = setWindowHeight() - 123+"px"
		};
	
		const layout = new dhx.Layout("layout", {
			    rows: [
			        {
			            id: "a",
			        },
			    ]
			});
	
		const grid = new dhx.Grid("", {
		    columns: [
		        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
		        { width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
		        { width: 120, id: "Path", header: [{ text: "${menu.LN00043}" , align: "center" },{content: "inputFilter"}], align: "center" },
		        { width: 100, id: "ClassName", header: [{ text: "${menu.LN00042}" , align: "center" },{content: "selectFilter"}], align: "center" },
		        { width: 150, id: "Identifier", header: [{ text: "${menu.LN00106}" , align: "center" },{content: "inputFilter"}], align: "center" },
		        { id: "ItemName", header: [{ text: "${menu.LN00028}" , align: "center" },{content: "inputFilter"}], align: "left" },
		        { width: 100, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" },{content: "inputFilter"}], align: "center" },
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		});
	
		layout.getCell("a").attach(grid);
		
	  	function searchList() {
	  		fetch(`/cxnItemList.do?itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&cxnTypeList='${CXNItemTypeCode}'`)
			.then((res) => res.json())
	  		.then(data => grid.data.parse(data.list))
	  	}
		
		function setWindowHeight(){
			var size = window.innerHeight;
			var height = 0;
			if( size == null || size == undefined){
				height = document.body.clientHeight;
			}else{
				height=window.innerHeight;
			}return height;
		}
		
		function setCheckedItems(checkedItems) {
			var url = "createCxnItem.do";
			var data = "s_itemID=${itemID}&cxnTypeCode=${CXNItemTypeCode}&items="+checkedItems+"&cxnClassCode=${CXNClassCode}";
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
		
		// callback - setCheckedItems
		function thisReload() {
			console.log("thisReload");
			searchList();
		}
		
		function newItemInsert() {
			if($("#newItemName").val() == ""){alert("${WM00034_1}");$("#newItemName").focus();return false;}
			if($("#newClassCode").val() == ""){alert("${WM00034_2}");$("#newClassCode").focus();return false;}
			if($("#parentItemPath").val() == ""){alert("${WM00034_3}");$("#parentItemPath").focus();return false;}
				
			if(confirm("${CM00009}")){
				var url = "newItemInsertAndAssign.do";
				var data = "s_itemID=${itemID}&option=${option}"
							+"&CNItemTypeCode=${varFilter}&isFromItem=${isFromItem}"
							+"&newClassCode="+$("#newClassCode").val()
							+"&newIdentifier="+replaceText($("#newIdentifier").val())
							+"&OwnerTeamId="+$("#ownerTeamID").val()
							+"&AuthorID="+$("#AuthorSID").val()
							+"&newItemName="+replaceText($("#newItemName").val())
							+"&parentItemId="+$("#parentItemId").val()
							+"&addBtnYN=${addBtnYN}"
							+"&autoID="+$("#autoID").val()
							+"&preFix="+$("#preFix").val();
							
				var target = "blankFrame";		
				ajaxPage(url, data, target);
			}
		}
		
		function urlReload() {
			opener.newItemInsertCallBack();
		}
		
		function openSearchItemListPop() {
			var popupForm = document.searchItemListPop;
			 var url = "searchItemListPop.do";
			 window.open("" ,"searchItemListPop", "width=900, height=500, left=500, top=300"); 
			 popupForm.action =url; 
			 popupForm.method="post";
			 popupForm.target="searchItemListPop";
			 popupForm.classCodes.value = "${classCodes}";
			 popupForm.itemTypeCode.value = "${itemTypeCode}";
			 popupForm.items.value = grid.data.getRawData().map(e => e.ItemID).toString();
			 popupForm.submit();
		}
		
		function cxnItemDelete() {
			var selectedCell = grid.data.getRawData().filter(e => e.checkbox);
			if(!selectedCell.length){
				alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
			}else{
				if (confirm("${CM00004}")) {
					var items = new Array();	
					for(idx in selectedCell){
						items.push(selectedCell[idx].ItemID);
					};
					
					if (items != "") {
						var url = "DELCNItems.do"; 
						var data = "isOrg=Y&s_itemID=${itemID}&items="+items;
						var target = "blankFrame";
						ajaxPage(url, data, target);
					}
				}
			}
		}
		
		// callback - cxnItemDelete
		function urlReload() {
			console.log("urlReload");
			searchList();
		}
	</script>
</body>