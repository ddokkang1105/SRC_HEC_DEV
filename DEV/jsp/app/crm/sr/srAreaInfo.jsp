<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<script>
	var p_gridArea;	
	var screenType = "${screenType}";
	var srMode = "${srMode}";
	var srType = "${srType}";

	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		};
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
	});
	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}
</script>

<div id="srAreaInfoListDiv">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<div class="floatL msg" style="width:100%">
		<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;Service desk</span>
	</div>
	<li class="mgT5 mgB5 alignR"><span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span></li>
	<div id="layout" style="width:100%"></div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
</div>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var gridData = ${gridData};
	var spansData = ${spansData};
	
	var grid = new dhx.Grid("grid",  {
		columns: [
	        { width: 30, id: "no", header: [{ text: "${menu.LN00024}", align:"center"}], align:"center" },
	        { width: 150, id: "SRArea1Name", header: [{ text: "${menu.LN00274}", align:"center" }]},
	        { width: 200, id: "AuthorInfo1", header: [{text: "${menu.LN00004}", align:"center"}]},
	        { id: "SRArea2Name", header: [{ text: "${menu.LN00185}", align:"center" }]},
	        { width: 250, id: "AuthorInfo2", header: [{ text: "${menu.LN00004}", align:"center" }]},
	        { width: 250, id: "AuthorInfo3", header: [{ text: "ITO ${menu.LN00004}", align:"center" }]}
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    spans : spansData
	});
	
	layout.getCell("a").attach(grid);
</script>