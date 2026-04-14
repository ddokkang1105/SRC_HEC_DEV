<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>

<!-- 2. Script -->
<script type="text/javascript">
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		};
		
		doSearchList();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	// [Assign] click 이벤트	
	function assignOrg(){
		var url = "dimAssignTreePopByInst.do";
		var data = "s_itemID=${s_itemID}&instanceNo=${instanceNo}&instanceClass=${instanceClass}";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	function doCallBack(){}
	
	// [Assign popup] Close 이벤트
	function assignClose(){
		doSearchList();
	}
	
	// [Del] Click
	function delDimension() {
		var checkedRows = grid.data.getInitialData().filter(e => e.checkbox);
		if(checkedRows.length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");	
			alert("${WM00023}");	
		}else{
			if(confirm("${CM00004}")){
				var dimValueIds = checkedRows.map(e => e.DimValueID).join(",");
				var dimTypeIds = checkedRows.map(e => e.DimTypeID).join(",");
				
				var url = "delDimensionForInstance.do";
				var data = "instanceNo=${instanceNo}&dimTypeIds="+dimTypeIds+"&dimValueIds=" + dimValueIds;
				var target = "blankFrame";
				ajaxPage(url, data, target);			
			}
		}	
	}
	
</script>
<div>
	<div class="child_search">
	   <li class="shortcut">
	 	 <img src="${root}${HTML_IMG_DIR_ITEM}/img_cube.png"></img>&nbsp;&nbsp;<b>${menu.LN00088}</b>
	   </li>
	</div>
	<div class="countList">
		<li class="count">Total  <span id="TOT_CNT"></span></li>
	    <li class="floatR">&nbsp;</li>
	    
	   <li style="padding-left:100px !important;float:left;">
           <select id="dimTypeId" Name="dimTypeId">
               <option value=''>Select</option>
           	   <c:forEach var="i" items="${dimTypeList}">
                   <option value="${i.DimTypeID}">${i.DimTypeName}</option>
           	    </c:forEach>
       	   </select> 
       	   <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList();" value="검색" style="cursor:pointer;">   
	   </li>
	   <li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' and myItem == 'Y'}">
				&nbsp;<span class="btn_pack small icon"><span class="assign"></span><input value="Assign" type="submit" onclick="assignOrg();"></span>
				&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delDimension();"></span>
			</c:if>
		</li>	
	</div>
	
	<div id="layout" style="width:100%"></div>
</div>	
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

	var grid = new dhx.Grid("grid",  {
		columns: [
	        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
	        { width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", align: "center", htmlEnable: true }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 100, id: "DimTypeName", header: [{ text: "${menu.LN00088}", align:"center" }], align:"center"},
	        { width: 100, id: "DimValueID", header: [{text: "Code", align:"center"}], align: "center"},
	        { width: 200, id: "DimValueName", header: [{ text: "Value", align:"center" }], align:"center"},
	        { width: 500, id: "DescAbrv", header: [{ text: "Description", align:"center", colspan : "2" }], align:"left"},
	        { width: 50, id: "ImgView", header: [{ text: "", align:"center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/'+row.ImgView+'" />';
	            }
	        }
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	});

	layout.getCell("a").attach(grid);
	 
	function doSearchList(){
		var sqlID = "instance_SQL.selectInstanceDim";
		var param =  "instanceNo=${instanceNo}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&sqlID="+sqlID;
		
		if($("#dimTypeId").val() != '' & $("#dimTypeId").val() != null){
			param = param +"&dimTypeId="+ $("#dimTypeId").val();
		}
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				grid.data.parse(result);
				$("#TOT_CNT").html(grid.data.getLength());
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
 	}
	
	
	grid.events.on("cellClick", function(row,column,e){
		if(column.id == "ImgView"){
			var dimTypeId = row.DimTypeID
			var dimValueId = row.DimValueID
			var url = "viewInstanceDimDesc.do";
			var data = "?s_itemID=${s_itemID}&instanceNo=${instanceNo}&dimValueId=" + dimValueId+"&dimTypeId="+dimTypeId;
			window.open(url+data,'window','width=500, height=300, left=300, top=300,scrollbar=yes,resizble=0');
		}
	})
</script>
