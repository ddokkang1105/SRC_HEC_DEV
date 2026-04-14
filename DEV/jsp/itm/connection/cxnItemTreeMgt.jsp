<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>


<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<style>
	.grid__cell_status-item {
	    text-align: center;
	    height: 20px;
	    width: 70px;
	    border-radius: 100px;
	    background: rgba(0, 0, 0, 0.05);
	}
	
	.grid__cell_status-item.new{
		background: rgba(2, 136, 209, 0.1);
    	color: #0288D1;
	}
	
	.grid__cell_status-item.mod{
		background: rgba(10, 177, 105, 0.1);
    	color: #0ab169;
	}
	
	/* .dhx_cell-editor__checkbox{
		align-items : flex-end;
		padding-right : 3px;
	} */
</style>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<!-- 2. Script -->
<script type="text/javascript">
	var positionX,positionY;
	var cxnItemID;
	$(document).ready(function() {		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 155)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 155)+"px;");
		};		
		$("#excel").click(function(){ fnGridExcelDownLoad(treeGrid); });
		
	});
	function resizeLayout(){window.clearTimeout(t);t=window.setTimeout(function(){setScreenResize();},200);}
	function setScreenResize(){var clientHeight=document.body.clientHeight; alert(clientHeight);}
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var pagination;
	var gridData = ${gridData};
	var treeGrid = new dhx.Grid("treegrid", {
		type: "tree",
	    columns: [
	    	{ id: "TreeName", width: 350, header: [{ text: "${menu.LN00028}", align: "center" }], htmlEnable: true, 
	        	template: function (text, row, col) {
	        		if(row.parent != "treegrid" && row.parent != "${s_itemID}"){
						if(row.HaveTeamParent == "Y"){
							return '&emsp;&emsp;&emsp;&emsp;' + row.TreeName;
						} else if(row.IsTeamParent == "Y"){
							return '&emsp;&emsp;&emsp;<img src="${root}${HTML_IMG_DIR}/item/'+row.ItemTypeImg+'" width="18" height="18">&nbsp;'+ row.TreeName;
						}else{
							return '&emsp;' + row.TreeName;
	        			}
	        		}else{
	        			return '<img src="${root}${HTML_IMG_DIR}/item/'+row.Icon+'" width="18" height="18">&nbsp;'+ row.TreeName;	        			
	        		}
            	} 	
	        },
	        { width: 40, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnTreeGridMasterChk(checked)'></input>", align: "center" }], type: "boolean", align: "center", htmlEnable: true, editable: true, sortable: false},
	        { id: "ItemPath", type: "string", header: [{ text: "${menu.LN00043}", align: "center" }], autoWidth: true },
	        { id: "LinkType", width: 100, type: "string", header: [{ text: "${menu.LN00038}", align: "center" }], align: "center" },
	        { id: "linkImg", width: 50, type: "html", header: [{ text: "Link", align: "center"}], htmlEnable: true, align: "center", sortable: false, hidden: true
	        		, template: function (text, row, col) {
		        		if(row.linkImg == undefined){
		        			return '<img src="${root}${HTML_IMG_DIR}/item/blank.png" width="19" height="20">';
		        		}else{	
			        		return '<img src="${root}${HTML_IMG_DIR}/item/'+row.linkImg+'" width="19" height="20">';
		        		}
	            	} 
	        },
	        { id: "OwnerTeamName", width: 120, type: "string", header: [{ text: "${menu.LN00018}", align: "center" }], align: "center", hidden: true},
	        { id: "Name", width: 120, type: "string", header: [{ text: "${menu.LN00004}", align: "center" }], align: "center" },
	        { id: "LastUpdated", width: 120, type: "string", header: [{ text: "${menu.LN00070}", align: "center" }], align: "center" },
	        { id: "Status", width: 120, type: "string", header: [{ text: "${menu.LN00027}", align: "center"}] , htmlEnable: true, align: "center",
	            template: function (text, row, col) {
	                var result = "";
	                switch (text) {
	        			case "NEW1" : result = '<span class="grid__cell_status-item new">'+row.StatusName+'</span>'; break;
	        			case "MOD1" : result = '<span class="grid__cell_status-item mod">'+row.StatusName+'</span>'; break;
	        			case "MOD2" : result = '<span class="grid__cell_status-item mod">'+row.StatusName+'</span>'; break;
	        			case "REL" : result = '<span class="grid__cell_status-item">'+row.StatusName+'</span>'; break;
	        			default : result = '';
        			}
	                return result;
	            }
	        },
	    ],
	    autoWidth: true,
	    sortable: true,
	    adjust: false,
	    resizable: true,
	    data: gridData
	});
	
	treeGrid.data.sort({
	    by: "parent",
	    dir: "asc",
	    as: function (value) { return value ? value : "" }
	});
	
	
	layout.getCell("a").attach(treeGrid);
	
	$("#TOT_CNT").html(treeGrid.data.getLength());
	
 	treeGrid.events.on("filterChange", function(row,column,e,item){
		$("#TOT_CNT").html(treeGrid.data.getLength());
	});
	
	treeGrid.events.on("cellClick", function(row,column,e){
		if(column.id == "linkImg"){
			if(row.linkUrl != "" && row.linkUrl != undefined ){
				fnOpenLink(row.ItemID,row.linkUrl,row.lovCode,row.attrTypeCode);
			}
		} else if(column.id == "Name" && row.AuthorID != "" && row.AuthorID != undefined ){
			var url = "viewMbrInfo.do?memberID="+row.AuthorID;		
			window.open(url,'window','width=1200, height=700, left=400, top=100,scrollbar=yes,resizble=0');		
		}else if(column.id == "LinkType" && row.CXNItemID != "" && row.CXNItemID != undefined){	
			doPtgDetail(row.CXNItemID);
		} else if(column.id != "checkbox"){
			if(row.s_itemID != "" &&  row.ItemID != undefined && row.ItemID != ""){ doPtgDetail(row.ItemID); }
		}
	}); 
	
	treeGrid.events.on("cellMouseOver",function(row,column,e){
		if(column.id == "LinkType" && row.CXNItemID != "" && row.CXNItemID != undefined){				
			positionY = event.clientY + 10;
			positionX = event.clientX - 100;
			fnGetCxnAttrList(row.CXNItemID);
		}else{ fnCloseLayer(); }		
	});
	
	function fnTreeGridMasterChk(state) {
	    event.stopPropagation();
	    treeGrid.data.forEach(function (row) {
	        treeGrid.data.update(row.id, { "checkbox" : state })
	    })
	}
			
	function fnLinkHideShow(){
		if( document.all("linkHideShow").checked == true){			
			treeGrid.showColumn("linkImg");
		}else{
			treeGrid.hideColumn("linkImg");
		}
	}
	
	function fnTeamHideShow(){
		if( document.all("teamHideShow").checked == true){
			treeGrid.showColumn("OwnerTeamName");
		}else{
			treeGrid.hideColumn("OwnerTeamName");
		}
	}
	
	function doPtgDetail(avg){		
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}	
	
	function assignProcess(){	
		var url = "selectCxnItemTypePop.do?s_itemID=${s_itemID}&varFilter=${varFilter}&screenMode="; 
		var w = 500;
		var h = 300;
		itmInfoPopup(url,w,h);
	}
	
	function fnOpenItemTree(itemTypeCode, searchValue, cxnClassCode){
		$("#cxnTypeCode").val(itemTypeCode);
		$("#cxnClassCode").val(cxnClassCode);
		var url = "itemTypeCodeTreePop.do";
		var data = "ItemTypeCode="+itemTypeCode+"&searchValue="+searchValue
			+"&openMode=assign&s_itemID=${s_itemID}";

		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
	function doCallBack(){
		//alert(1);
	}
	
	//[Assign] 이벤트 후 Reload
	function thisReload(){
		var url = "cxnItemTreeMgt.do";
		var target = "actFrame";
		if('${frameName}' != ''){
			target = '${frameName}';
		}		
		var data = "s_itemID=${s_itemID}&varFilter=${varFilter}&option=${option}"
					+"&filter=${filter}&screenMode=${screenMode}&showTOJ=${showTOJ}"
					+"&frameName=${frameName}&showElement=${showElement}&cxnTypeList=${cxnTypeList}";
		
	 	ajaxPage(url, data, target);
	}
	
	function delProcess(){
		var selectedCell = treeGrid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");
			return false;
		}
		
		if(confirm("${CM00004}")){		
			var items = new Array();	
			for(idx in selectedCell){
				if(selectedCell[idx].parent != "treegrid" && selectedCell[idx].parent != "${s_itemID}" && selectedCell[idx].parent != "cxnProcess" && selectedCell[idx].IsTeamParent != "Y"){
					items.push(selectedCell[idx].ItemID);
				}else{
					alert(selectedCell[idx].TreeName + " 는(은) ${WM00046}");
					treeGrid.data.update(selectedCell[idx].id, { "checkbox" : false });
				}
			};
			
			if (items != "") {
				var url = "DELCNItems.do"; 
				var data = "isOrg=Y&s_itemID=${s_itemID}&items="+items;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		}
	}
			
	function fnConnItemDocumentList(){	
		var url = "cxnItemFileList.do";
		itemIDs="${itemIDs}";
		if(itemIDs == "[]"){
			itemIDs = -1;
		}
		var target = "processDIV";
		var data = "s_itemID=${s_itemID}&option=${option}&filter=${filter}&screenMode=${screenMode}&itemIDs="+itemIDs
				+"&childCXN=${childCXN}&cxnTypeList=${cxnTypeList}"; 
	 	ajaxPage(url, data, target);
	}
	
	//After [Assign -> Assign]
	function setCheckedItems(checkedItems){
		var cxnTypeCode = $("#cxnTypeCode").val();
		var cxnClassCode = $("#cxnClassCode").val();
		var url = "createCxnItem.do";
		var data = "s_itemID=${s_itemID}&cxnTypeCode="+cxnTypeCode+"&items="+checkedItems
					+ "&cxnTypeCodes=${varFilter}"
					+ "&cxnClassCode="+cxnClassCode;
		var target = "blankFrame";
		
		ajaxPage(url, data, target);
		
		$("#cxnTypeCode").val("");
		$("#cxnClassCode").val("");
		$(".popup_div").hide();
		$("#mask").hide();	
	}
	
	function fnEditAttr(){
		var selectedCell = treeGrid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");
			return false;
		}
		var items = new Array();	
		var classCodes = new Array();
		for(idx in selectedCell){
			if(selectedCell[idx].parent != "treegrid" && selectedCell[idx].parent != "${s_itemID}" && selectedCell[idx].parent != "cxnProcess"){
				//items.push(selectedCell[idx].ItemID);
				items.push(selectedCell[idx].CXNItemID);
				//classCodes.push(selectedCell[idx].ClassCode);
				classCodes.push(selectedCell[idx].CXNClassCode);
			}else{
				alert(selectedCell[idx].TreeName + " 는(은) ${WM00046}");
				treeGrid.data.update(selectedCell[idx].id, { "checkbox" : false });
			}
		};
		if(items == "") return;
		var url = "selectAttributePop.do";
		var data = "classCodes="+classCodes+"&items="+items;
		var option = "dialogWidth:400px; dialogHeight:250px;";		
		var w = "400";
		var h = "350";

		$("#items").val(items);
		$("#classCodes").val(classCodes);
		window.open("", "selectAttribute", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		document.cxnItemTreeFrm.action=url;
		document.cxnItemTreeFrm.target="selectAttribute";
		document.cxnItemTreeFrm.submit();
	}
	
	function urlReload(addBtnYN) {
		thisReload(addBtnYN);
	}
		
	function fnCloseLayer(){
		var layerWindow = $('.cxn_layer');
		layerWindow.removeClass('open');
	}
	
	function fnGetCxnAttrList(itemID){	
		var data = "itemID=" + itemID;
		var target = "blankFrame";
		var url = "";
		
		$.ajax({
			url: "getCxnAttrList.do"
			,type: 'post'
			,data: data
		    ,beforeSend: function(x) {//$('#loading').fadeIn(150);
		   	 if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}
		    }
			,success: function(data){
				$("#" + target).html(data);
			}
		});
	}
	
	function fnSetCxnAttrList(cxnHtml,cxnCnt){			
		if(Number(cxnCnt) == 0){fnCloseLayer();	 return; }
		var oPopup = document.getElementById("connectionPopup");
		
		oPopup.style.top = positionY +"px";
		oPopup.style.left = positionX +"px";
		if(Number(positionY)>540){
			oPopup.style.top = positionY - 280 +"px";
		}
		
		var layerWindow = $('.cxn_layer');
		layerWindow.addClass('open');
				
		var cxnAttrLayer ="";
		
		cxnAttrLayer += "<table class='tbl_blue01' width='100%' border='0' cellpadding='0' cellspacing='0'>";
		cxnAttrLayer += cxnHtml;
		cxnAttrLayer += "</table>"; 
		$('#cxnAttrLayer').html(cxnAttrLayer);
	}
	
	function fnOpenLink(itemID,url,lovCode,attrTypeCode){
		var url = url+".do?itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode;
	
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h);
	}
	
</script>

<style>

.cxn_layer{display:none;width:400px;height:180px;overflow-x:hidden;overflow-y:auto;position:absolute;border:1px gray solid;background-color:white; }
.cxn_layer.open{display:block}

</style>

<body>
<div id="processDIV">	
<form name="cxnItemTreeFrm" id="cxnItemTreeFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="cxnTypeCode" name="cxnTypeCode" >
	<input type="hidden" id="items" name="items" >
	<input type="hidden" id="classCodes" name="classCodes" >
	<input type="hidden" id="cxnClassCode" name="cxnClassCode" >
	<div class="child_search01 mgB10" id="pertinentSearch">
		<ul>
			<li class="floatR pdR30">
				&nbsp;&nbsp;<input type="checkbox" id="linkHideShow" name="linkHideShow" onClick="fnLinkHideShow()">&nbsp;Link&nbsp;&nbsp;
				&nbsp;&nbsp;<input type="checkbox" id="teamHideShow" name="teamHideShow" onClick="fnTeamHideShow()">&nbsp;Team&nbsp;&nbsp;	
				<c:if test="${myItem == 'Y'}">	
					<c:if test="${childCXN ne 'Y' }">
					<span class="btn_pack nobg" alt="Assign" title="Assign"  style="cursor:pointer;_cursor:hand"><a onclick="assignProcess();"class="assign" ></a></span>
          			<span class="btn_pack nobg"><a class="relationship" onclick="fnEditAttr();" title="Relationship"></a></span>	
					</c:if>
					<span class="btn_pack nobg"><a class="file" onclick="fnConnItemDocumentList();" title="Files" id="file"></a></span>	
					<span class="btn_pack nobg white"><a class="del" onclick="delProcess();" title="Delete" id="delPrc"></a></span>	
		
				</c:if>					
				<span class="btn_pack nobg white"><a class="xls"  title="Excel" id="excel"></a></span>	
				
			</li>			
		</ul>
	</div>	
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>	
	<div class="cxn_layer" id="connectionPopup">								
		<div class="mgT10 mgB10 mgL5 mgR5">
		<span class="closeBtn">
			<span style="cursor:pointer;_cursor:hand;position:absolute;right:10px;" OnClick="fnCloseLayer();">Close</span>
		</span> <br>
		<table id="cxnAttrLayer" class="tbl_blue01 mgT5" style="width:100%;height:98%;">
		</table> 
		</div>
	</div> 
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</form>
</div>
</body>
