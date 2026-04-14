<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/dhtmlx/dhtmlxgrid_treegrid.css">
<script src="<c:url value='/cmm/js/dhtmlx/dhtmlxTreeGrid/codebase/dhtmlxtreegrid.js'/>" type="text/javascript" charset="utf-8"></script> 

<script type="text/javascript">
	var treeGridArea;
	$(document).ready(function() {
		// 초기 표시 화면 크기 조정 
		$("#treeGridArea").attr("style","height:"+(setWindowHeight() - 120)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#treeGridArea").attr("style","height:"+(setWindowHeight() - 180)+"px;");
		};
		if(window.attachEvent){window.attachEvent("onresize",resizeLayout);}else{window.addEventListener("resize",resizeLayout, false);}
		var t;
		$("#excelPrc").click(function(){treeGridArea.toExcel("${root}excelGenerate");});
		//$("#dimValue").val("${dimValue}");
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&classCode=${rootClassCode}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('rootItemID', data, 'getTreeRootItemList', '${rootItemID}', 'Select');
		fnSelect('dimTypeID', data, 'getDimTypeId', '${dimTypeID}', 'Select');
		
		setTreeGridList();
	});
	function resizeLayout(){window.clearTimeout(t);t=window.setTimeout(function(){setScreenResize();},200);}
	
	function setScreenResize(){var clientHeight=document.body.clientHeight; alert(clientHeight);}
	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}
	
	function setTreeGridList(){	
		var treePData="${prcTreeXml}";
		treeGridArea = new dhtmlXGridObject('treeGridArea');
		treeGridArea.selMultiRows = true;
		treeGridArea.imgURL = "${root}${HTML_IMG_DIR_ITEM}/";
		treeGridArea.setHeader("${menu.LN00028},PREE_ITEMID,ITEMID,${dimVNm}");
		treeGridArea.setInitWidths("400,80,80,${dWidth}");
		treeGridArea.setColAlign("left,left,left,${dAlign}");
		treeGridArea.setColTypes("tree,ro,ro,${dType}");
		treeGridArea.setColSorting("str,str,str,${dSort}");
   	  	treeGridArea.init();
		treeGridArea.setSkin("dhx_web_md");
		treeGridArea.attachEvent("onRowSelect", function(id,ind){fnRowSelect(id,ind);});
		treeGridArea.loadXMLString(treePData);
		treeGridArea.checkAll(false);
		treeGridArea.enableTreeCellEdit(false);
		
		treeGridArea.setColumnHidden(1, true);
		treeGridArea.setColumnHidden(2, true);
	}

	function fnRowSelect(id, ind){
		var ids = id.split(".");
		var itemID = ids[0];
		fnOpenItemPop(itemID);
	}	
	
	function fnOpenItemPop(avg){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}

	function fnSearchProchSum(){
		var url = "itemTreeListByDim.do";
		var target = "itemTreeListByDimDiv";		
		var data = "reportCode=${reportCode}&rootItemID="+$("#rootItemID").val()+"&dimTypeID="+$("#dimTypeID").val()+"&maxTreeLevel=${maxTreeLevel}"+"&cxnTypeCode=${cxnTypeCode}"+"&rootClassCode=${rootClassCode}&selectedDimClass=${selectedDimClass}";
		ajaxPage(url, data, target);
	}
	

</script>
<div id="itemTreeListByDimDiv">
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 3px 0 3px 0"><img src="${root}${HTML_IMG_DIR}/img_process.png">&nbsp;&nbsp;${title}</h3>
	</div>
	<div style="height:10px"></div>
	<div class="child_search" id="pertinentSearch">
		<ul>
			<li>&nbsp;&nbsp;L1&nbsp;&nbsp;
				<select id="rootItemID" name="rootItemID" style="width:120px;"></select>
			</li>
		   <li>&nbsp;&nbsp;Dimension Type&nbsp;&nbsp;
				<select id="dimTypeID" name="dimTypeID" style="width:120px;"></select>  <!-- OnChange="fnChangeDimValue(this.value); -->
			</li>
			<li><input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="fnSearchProchSum()"/></li>
			<li class="floatR pdR20" >
				<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excelPrc"></span>	
			</li>			
		</ul>
	</div>
	<div id="gridDiv" class="mgB10 mgT5">
		<div id="treeGridArea" style="width:100%;"></div>
	</div>
</div>
