<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<%@ include file="/WEB-INF/jsp/template/autoCompText.jsp"%> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css" />
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021" arguments="Add "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="${menu.ZLN0101} "/>

<script type="text/javascript">
	$(document).ready(function(){
	
	var itemTypeCode = "${itemTypeCode}";
	
	
	if (itemTypeCode == 'OJ00011'){
		fnAutoComplete("", "OJ00011", "CL11004");
	}

}); 
	getAttrLovList("OJ00001");
	
	function fnAutoComplete(attrTypeCode, itemTypeCode, itemClassCode){
		
		if(itemTypeCode == "OJ00011") {
			autoComplete("textValue", attrTypeCode, itemTypeCode, itemClassCode, "${sessionScope.loginInfo.sessionCurrLangType}", 5, "top");
		}
		
		else {
			autoComplete("name", attrTypeCode, itemTypeCode, itemClassCode, "${sessionScope.loginInfo.sessionCurrLangType}", 5, "top");
		}
	}
		
	if("${initSearch}" == "N") {
		let data = "&category=CLS&languageID=${sessionScope.loginInfo.sessionCurrLangType}&selectedCode=${classCodes}";
	
		<c:if test="${itemTypeCode eq 'OJ00001'}">
			fnSelect('classCode', data, 'getDictionaryOrdStnm', '', '');
		</c:if>
		<c:if test="${itemTypeCode eq 'OJ00011'}">
			fnSelect('Category', data+"&attrTypeCode=AT00034", 'getAttrTypeLov', '', '전사용어 All');
		</c:if>
	}
	
	function ZAT01060change(value){

		if(value == 'CL01005'){
			fnSelect('ZAT01060', data+"&lovCode=3&lovListFilter='GP'", 'getSubLovList', 'GP', '');
			fnAutoComplete("AT00001", "OJ00001", "CL01005");
		} else if(value == 'CL01005A'){
			fnSelect('ZAT01060', data+"&lovCode=3&lovListFilter='GP'", 'getSubLovList', 'GP', '');
			fnAutoComplete("AT00001", "OJ00001", "CL01005A");
		} else if(value == 'CL01006A'){
			fnSelect('ZAT01060', data+"&lovCode=4&lovListFilter='GU'", 'getSubLovList', 'GU', '');
			fnAutoComplete("AT00001", "OJ00001", "CL01006A");
		} else if(value == 'CL01006B'){
			fnSelect('ZAT01060', data+"&lovCode=4&lovListFilter='GU'", 'getSubLovList', 'GU', '');
			fnAutoComplete("AT00001", "OJ00001", "CL01006B");
		} else {
			getAttrLovList("OJ00016");
			fnAutoComplete("AT00001", "OJ00016", "CL16004");
		}
	}
	
	function fnAutoCompleteChange(value){

		if (value == 'total') {
			fnAutoComplete("", "OJ00011", "CL11004");
		}
		else if(value == 'name') {
			fnAutoComplete("AT00001", "OJ00011", "CL11004");
		}
			
		else if(value == 'desc') {
			fnAutoComplete("AT00056", "OJ00011", "CL11004");
		}
		
	}
	
	async function getAttrLovList(itemTypeCode){
		let param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
							+"&sqlID=attr_SQL.selectAttrLovOption"
							+"&attrTypeCode=ZAT01060";

		await getLovListByItemType(itemTypeCode).then(res => {
			if(itemTypeCode === "OJ00001") lovListFilter = res;
			param += "&lovListFilter=" + res;
		});
		
		if(itemTypeCode !== "OJ00001") {
			fetch("/olmapi/getLovValue/?"+param)	
			.then(res => res.json())
			.then(res => {
				let lovHtml = "";
				lovHtml += "<option value=''>Select</option>"
				for(var i=0; i < res.data.length; i++) {
					lovHtml += '<option value="'+res.data[i].CODE+'">'+res.data[i].NAME+'</option>';
				}
				
				document.querySelector("#ZAT01060").innerHTML = lovHtml;
			});
		}
	}
	
	async function getLovListByItemType(itemTypeCode) {
		const res = await fetch("/olmapi/skAttrLovList/?itemTypeCode="+itemTypeCode+"&attrTypeCode=ZAT01060");
		const data = await res.json();
		return data;
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
						<c:if test="${itemTypeCode eq 'OJ00001'}">
							<!-- 문서구분 -->
							<label for="classCode" class="pdR10" >${menu.ZLN0101}</label>
							<select id="classCode" style="width:170px;" onchange="ZAT01060change(this.value)"></select>
							<!-- 문서유형 -->
							<label for="ZAT01060" class="pdL20 pdR10">${menu.LN00091}</label>
							<select id="ZAT01060" style="width:170px;"></select>
							<!-- 문서번호 -->
							<label for="id" class="pdL20 pdR10">${menu.ZLN0068}</label>
							<input type="text" id="id" class="text" style="width:150px;"/>
							<!-- 문서명 -->
							<label for="name" class="pdL20 pdR10">${menu.LN00101}</label>
							<!-- <input type="text" id="name" class="text" style="width:150px;"/> -->
							<input type="text" id="name" value="" class="text" style="width:150px;ime-mode:active;">
						</c:if>
						<c:if test="${itemTypeCode eq 'OJ00011'}">
							<input type="hidden" id="classCode" value="CL11004">
							<!-- 용어구분 -->
							<label for="Category" class="pdR10">${menu.ZLN0136}</label>
							<select id="Category" style="width:170px;"></select>
							<!-- 용어명 -->
							<label for="termSearch" class="pdL20 pdR10">${menu.ZLN0137}</label>
							<select id="termSearch" style="width:100px;" class="mgR10" onchange="fnAutoCompleteChange(this.value)">
								<!-- 통합 / 용어 / 용어정의 -->
								<option value="total">${menu.ZLN0069}</option>
								<option value="name">${menu.LN00388}</option>
								<option value="desc">${menu.ZLN0097}</option>
							</select>
							<input type="text" id="textValue" value="${text}" class="text" style="width:150px;ime-mode:active;">
						</c:if>
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
	
		const layout = new dhx.Layout("layout", {
			    rows: [
			        {
			            id: "a",
			        },
			    ]
			});
		
		let gridConfig = "";
		if("${itemTypeCode}" == "OJ00001") {
			gridConfig  = [
				// ItemID / No / 0 / 문서레벨 / 문서유형 / 문서경로 / 문서명 / 문서번호
		    	{ hidden: true,width: 100, id: "ItemID", header: [{ text: "ItemID" , align: "center" }], align: "center" },
		        { hidden:true,  width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
		       	{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}]
		        	, align: "center"
			        , type: "boolean"
			        , editable: true
			        , sortable: false
		        },
		        { width: 100, id: "DocLevValue", header: [{ text: "${menu.ZLN0075}" , align: "center" },{content: "selectFilter"}], align: "center" },
		        { width: 130, id: "DocTypeValue", header: [{ text: "${menu.LN00091}" , align: "center" },{content: "selectFilter"}], align: "center" }, 
				{ width: 200, id: "Path", header: [{ text: "${menu.LN00102}" , align: "center" },{content: "selectFilter"}], align: "center" },	       
		        { id: "ItemName", header: [{ text: "${menu.LN00101}" , align: "center" },{content: "inputFilter"}], align: "left" },
		        { width: 180, id: "Identifier", header: [{ text: "${menu.ZLN0068}" , align: "center" },{content: "inputFilter"}], align: "center" },
	        ];
		}
		if("${itemTypeCode}" == "OJ00011") {
			gridConfig = [
				// No / 0 / 용어구분 및 경로 / 용어 / 용어정의 / 상태
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
		        { width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
		        { width: 200, id: "Path", header: [{ text: "${menu.ZLN0096}" , align: "center" }], align: "center" },
		        { width: 200, id: "ItemName", header: [{ text: "${menu.LN00388}" , align: "center" }], align: "left" },
		        { id: "KoreanText", header: [{ text: "${menu.ZLN0097}" , align: "center" }], align: "left" , htmlEnable : true },
		        { width: 100, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" }], align: "center" },
		    ]
		}
		
	
		const grid = new dhx.Grid("", {
		    columns: gridConfig,
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
	  			let url = "jsonDhtmlxListV7.do?sqlID=zSK_SQL.getSearchList&languageID=${sessionScope.loginInfo.sessionCurrLangType}&ClassCodes="+classCode+"&masterItemId=${items}&itemID=${itemID}";
	  			if("${initSearch}" == "N") {
	  				if("${itemTypeCode}" == "OJ00001") url += "&AttrCodeBase1=AT00001&baseCondition1="+document.getElementById("name").value+"&baseCondition2="+document.getElementById("id").value+"&docType="+document.getElementById("ZAT01060").value;
	  				if("${itemTypeCode}" == "OJ00011") {
	  					url += "&attrTypeCode=AT00034&lovCode="+document.getElementById("Category").value;
	  					if(document.getElementById("termSearch").value == "total") url += "&AttrCodeBase1=AT00001&baseCondition1="+document.getElementById("textValue").value+"&koreanText="+document.getElementById("textValue").value;
	  					if(document.getElementById("termSearch").value == "name") url += "&AttrCodeBase1=AT00001&baseCondition1="+document.getElementById("textValue").value;
	  					if(document.getElementById("termSearch").value == "desc") url += "&koreanText="+document.getElementById("textValue").value;
	  				}
	  			}
	  			
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
			console.log("chekceditems : ", chekeditems);
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