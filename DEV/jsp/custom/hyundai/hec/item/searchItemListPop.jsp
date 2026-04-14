<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<%@ include file="/WEB-INF/jsp/template/autoCompText.jsp"%> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css" />
<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.js?v=7.1.8"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.css?v=7.1.8">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021" arguments="Add "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="문서구분 "/>

<script type="text/javascript">
	$(document).ready(function(){
		let data = "&itemTypeCode=${itemTypeCode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&cxnTypeCodes=${cxnTypeCodes}";
		fnSelect('itemTypeCode', data, 'getItemTypeCodeFromCXN', '', 'Select');
	});
	
</script>
<body>
	<div class="pdL20 pdR20">
		<div class="btn-wrap">
			<div class="page-title new-form">
				<div class="flex align-center">
						<label for="itemTypeCode" class="pdR10" >표준유형</label>
						<select id="itemTypeCode" style="width:170px;"></select>						
						<label for="id" class="pdL20 pdR10">문서번호</label>
						<input type="text" id="id" class="text" style="width:150px;"/>
						<label for="name" class="pdL20 pdR10">문서명</label>
						<input type="text" id="name" value="" class="text" style="width:150px;ime-mode:active;">
				</div>
			</div>
			<div class="btns pdB15 pdT15">
				<button class="secondary" id="search">Search</button>
				<button class="primary" onclick="fnAssignCxn();">Add</button>
			</div>
		</div>
		<div id="layout" style="width: 100%"></div>
	</div>
	<script>
		$("#search").click(function(){
			searchList();
		});
	
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
		
		let gridConfig = [
		    	{ hidden:true, width: 100, id: "ItemID", header: [{ text: "ItemID" , align: "center" }], align: "center" },
		    	{ hidden:true, width: 130, id: "ItemTypeCode", header: [{ text: "ItemTypeCode" , align: "center" }], align: "center" }, 
		        { hidden:true,  width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
		        
		       	{ width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}]
		        	, align: "center"
			        , type: "boolean"
			        , editable: true
			        , sortable: false
		        },
		        { width: 130, id: "ItemTypeName", header: [{ text: "표준유형" , align: "center" }], align: "center" },  
		        { width: 130, id: "Identifier", header: [{ text: "문서번호" , align: "center" },{content: "inputFilter"}], align: "center" },
		        { width: 400, id: "PlainText", header: [{ text: "문서명" , align: "center" },{content: "inputFilter"}], align: "left" },
	        ];
	
		const grid = new dhx.Grid("", {
		    columns: gridConfig,
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		});
	
		layout.getCell("a").attach(grid);
		
	  	function searchList() {
	  		let identifier = $("#id").val();
	  		let itemName = $("#name").val();
	  		let itemTypeCode = $("#itemTypeCode").val();
	  		let items = "${items}";
	  		
	  		if(itemTypeCode == ""){
	  			alert("표준유형을 선택하세요."); return;
	  		}
	  			
	  		if (identifier === "" && itemName === "") {
	  		    alert("문서번호나 문서명 중 하나 이상을 입력하세요.");
	  		    return;
	  		}
	  		
	  		$('#loading').fadeIn(150);
  			let url = "jsonDhtmlxListV7.do?sqlID=zHEC_SQL.getSearchItemList&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
  					+"&items=${items}&itemID=${s_itemID}"
  					+"&identifier="+identifier
  					+"&itemName="+itemName
  					+"&itemTypeCode="+itemTypeCode;
  			
  			
  			fetch(url)
	  		.then(res => res.json())
	  		.then(data => {
	  			grid.data.parse(data);
              
	  			$('#loading').fadeOut(150);
	  		})
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
		
		function fnAssignCxn() {			
			const checkedRows = grid.data.getRawData().filter(e => e.checkbox);
			
			const itemTypeCode = checkedRows.length > 0 ? checkedRows[0].ItemTypeCode : null;			
			const chekeditems = checkedRows.map(e => e.ItemID);
			if(chekeditems.length > 0) {
				opener.fnSaveCheckedItems(chekeditems, itemTypeCode);
				self.close();
			} else {
				alert("${WM00021}");
			}
			
		}
	</script>
</body>