<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%-- <%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%> --%>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css" />
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021" arguments="Add "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="${menu.LN00016} "/>

<script type="text/javascript">
	if("${initSearch}" == "N") {
		let data = "&category=CLS&languageID=${sessionScope.loginInfo.sessionCurrLangType}&selectedCode=${classCodes}"
		fnSelect('classCode', data, 'getDictionaryOrdStnm', '', 'Select');
	}
</script>
<body>
	<div class="pdL20 pdR20">
		<div class="btn-wrap">
			<div class="page-title new-form">
				<%-- 
				속성 검색
				<select id="attrCodeBase1" class="mgL10 pdR20" style="min-width: 100px;">
					<option value="">Select</option>
					<c:forEach var="attr" items="${attrList}">
						<c:if test="${attr.HTML ne '1'}">					
							<option value="${attr.AttrTypeCode}">${attr.Name}</option>
						</c:if>
					</c:forEach>
				</select>
				<input type="text" id="baseCondition1" class="text" style="width:200px;" placeholder="검색어를 입력하세요">
				--%>
				<c:if test="${initSearch eq 'N'}">
					<div class="flex align-center">
							<label for="classCode" class="pdR10">구분</label>
							<select id="classCode" style="width:170px;"></select>
							<label for="id" class="pdL20 pdR10">문서 번호</label>
							<input type="text" id="id" class="text" style="width:150px;"/>
							<label for="name" class="pdL20 pdR10">문서명</label>
							<input type="text" id="name" class="text" style="width:150px;"/>
					</div>
				</c:if>
			</div>
			<div class="btns pdB15 pdT15">
<!-- 				<button class="secondary" onclick="searchList()">Search</button> -->
				<c:if test="${initSearch eq 'N'}"><button class="secondary" id="search">Search</button></c:if>
				<button class="primary" onclick="callBack(searchList)">Add</button>
			</div>
		</div>
		<div id="layout" style="width: 100%"></div>
	</div>
	<script>
		let attrCodeBase1 = ""; // 속성 코드
		let baseCondition1 = ""; // 검색 내용
		let itemsArr = "${items}";
		
		if("${initSearch}" !== "N") searchList();
		else {
			$("#search").click(function(){
				searchList("'"+document.getElementById('classCode').value+"'");
			});
		}
	
		document.querySelector("#layout").style.height = setWindowHeight() - 123+"px";
		window.onresize = function() {
			document.querySelector("#layout").style.height = setWindowHeight() - 123+"px"
		};
		
		console.log("items>> "+"${items}");
	
		const layout = new dhx.Layout("layout", {
			    rows: [
			        {
			            id: "a",
			        },
			    ]
			});
	
		const grid = new dhx.Grid("", {
		    columns: [
		    	{ hidden: true,width: 100, id: "ItemID", header: [{ text: "ItemID" , align: "center" }], align: "center" },
		        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
		        { width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}]
		        	, align: "center"
			        , type: "boolean"
			        , editable: true
			        , sortable: false
		        },
				{ width: 200, id: "Path", header: [{ text: "${menu.LN00043}" , align: "center" },{content: "inputFilter"}], align: "center" },
		        { width: 100, id: "ClassName", header: [{ text: "구분" , align: "center" },{content: "selectFilter"}], align: "center" },
		        { width: 150, id: "Identifier", header: [{ text: "문서 번호" , align: "center" },{content: "inputFilter"}], align: "center" },
		        { id: "ItemName", header: [{ text: "문서명" , align: "center" },{content: "inputFilter"}], align: "left" },
		        { hidden:true,width: 100, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" },{content: "inputFilter"}], align: "center" },
		      
		        

		        ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		});
	
		layout.getCell("a").attach(grid);
		
	  	function searchList(classCode = "${classCodes}") {
	  		
	  		if("${initSearch}" == "N" && document.getElementById("classCode").value == "") {
	  			alert("${WM00025}");
	  			return false;
	  		}
	  		
			if(classCode !== "") {
			
		  		$('#loading').fadeIn(150);
	  			let url = "jsonDhtmlxListV7.do?sqlID=search_SQL.getSearchList&languageID=${sessionScope.loginInfo.sessionCurrLangType}&ClassCodes="+classCode+"&masterItemId=${items}";
	  			if("${initSearch}" == "N") url += "&AttrCodeBase1=AT00001&baseCondition1="+document.getElementById("name").value+"&baseCondition2="+document.getElementById("id").value;
	  			
	  			fetch(url)
		  		.then(res => res.json())
		  		.then(data => {
		  			
	             /*    data.forEach(row => {
	               
	                    if (itemsArr.includes(row.ItemID)) {
	                        row.checkbox = true;
	                    }
	                }); */
		  			grid.data.parse(data);
	              
		  			$('#loading').fadeOut(150);
		  		})
	  		}
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
		
		function callBack() {
			const chekeditems = grid.data.getRawData().filter(e => e.checkbox);
			console.log("${callBackData}");
			if(chekeditems.length > 0) {
				if("${callBackData}" == "ALL") opener.setCheckedItems(chekeditems);
				else opener.setCheckedItems(chekeditems.map(e => e.ItemID).toString());
				self.close();
			} else {
				alert("${WM00021}");
			}
		}
	</script>
</body>