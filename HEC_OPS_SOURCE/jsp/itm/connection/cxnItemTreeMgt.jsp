<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/dhtmlx/dhtmlxgrid_treegrid.css'/>">
<script src="<c:url value='/cmm/js/dhtmlx/dhtmlxTreeGrid/codebase/dhtmlxtreegrid.js'/>" type="text/javascript" charset="utf-8"></script> 

<style type="text/css" media="screen">
 .row20px img{   height:11px;  }
 .row20px div img{  height:18px;  }
 .objbox{
	overflow-x:hidden!important;
	
}
</style>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">
	var ptg_gridArea;
	var positionX,positionY;
	var cxnItemID;
	$(document).ready(function() {		
		// 초기 표시 화면 크기 조정 
		$("#grdPtgArea").attr("style","height:"+(setWindowHeight() - 150)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdPtgArea").attr("style","height:"+(setWindowHeight() - 150)+"px;");
		};		
		//if(window.attachEvent){window.attachEvent("onresize",resizeLayout);}else{window.addEventListener("resize",resizeLayout, false);}
		var t;
		//$("#assignPrc").click(function(){assignProcess();});
		//$("#delPrc").click(function(){delProcess();});
		$("#excelPrc").click(function(){ptg_gridArea.toExcel("${root}excelGenerate");});
		setPtgGridList();
	});
	function resizeLayout(){window.clearTimeout(t);t=window.setTimeout(function(){setScreenResize();},200);}
	function setScreenResize(){var clientHeight=document.body.clientHeight; alert(clientHeight);}
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	//===============================================================================
	// BEGIN ::: GRID
	function setPtgGridList(){	
		var treePData="${prcTreeXml}";
		//treePData = treePData.replaceAll("&#34;", "\"");
	    ptg_gridArea = new dhtmlXGridObject('grdPtgArea');
	    ptg_gridArea.selMultiRows = true;
	    //ptg_gridArea.imgURL = "${root}${HTML_IMG_DIR_ITEM}/";
	    ptg_gridArea.setImagePath("${root}${HTML_IMG_DIR_ITEM}/");
	    ptg_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		ptg_gridArea.setHeader("#master_checkbox,${menu.LN00028},${menu.LN00043},${menu.LN00038},Link,${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00070},${menu.LN00027},ItemID,ClassCode,CxnItemID,LinkUrl,LovCode,CxnClassCode,AttrTypeCode");
		ptg_gridArea.setInitWidths("30,400,300,100,60,150,120,120,90,90,80,80,80,80,80,80,80");
		ptg_gridArea.setColAlign("center,left,left,center,center,center,center,center,center,center,center,center,center,left,center,center,center");
		ptg_gridArea.setColTypes("ch,tree,ro,ro,img,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
		ptg_gridArea.setColSorting("int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str");
		//ptg_gridArea.enableTooltips("false,true,true,true,true");
   	  	ptg_gridArea.init();
		ptg_gridArea.setSkin("dhx_web");
		ptg_gridArea.setColumnHidden(3, true);
		ptg_gridArea.setColumnHidden(4, true);
		ptg_gridArea.setColumnHidden(5, true);
		ptg_gridArea.setColumnHidden(10, true);
		ptg_gridArea.setColumnHidden(11, true);
		ptg_gridArea.setColumnHidden(12, true);
		ptg_gridArea.setColumnHidden(13, true);
		ptg_gridArea.setColumnHidden(14, true);
		ptg_gridArea.setColumnHidden(15, true);
		ptg_gridArea.setColumnHidden(16, true);
		
		ptg_gridArea.attachEvent("onCheck", function(rId,cInd,state){ptgGridOnCheck(rId,cInd,state);});
		ptg_gridArea.attachEvent("onRowSelect", function(id,ind){ptgGridOnRowSelect(id,ind);});
		ptg_gridArea.attachEvent("onMouseOver", function(id,ind,event){fnOnRowOver(id,ind,event);});	

		ptg_gridArea.loadXMLString(treePData);
		//ptg_gridArea.loadXML("${root}doc/tmp/cxnTreeMgt.xml");	
		
		ptg_gridArea.checkAll(false);
		//ptg_gridArea.enableTreeCellEdit(false);
	}
	function setLoaingEndTreeGrid(){
		 ptg_gridArea.forEachRow(function(id){
			 var classCode=ptg_gridArea.cells(id, 11).getValue();if(classCode==""||classCode=="CL01005"){ptg_gridArea.cellById(id,0).setDisabled(true);}else{}
		 });
	}
	function ptgGridOnCheck(rId,cInd,state){
		if( state ){var classCode=ptg_gridArea.cells(rId, 11).getValue();
			if(classCode==""||classCode=="CL01005"){alert("${WM00046}");ptg_gridArea.cells(rId,0).setValue(0);}
			else{var itemID=ptg_gridArea.cells(rId, 10).getValue();
				if(itemID==""||itemID==undefined){var subitems=ptg_gridArea.getSubItems(rId).split(",");for(var i=0;i<subitems.length;i++){ptg_gridArea.cells(subitems[i],0).setValue(1);}}
			}
		}else{if(itemID==""||itemID==undefined){var subitems=ptg_gridArea.getSubItems(rId).split(",");for(var i=0;i<subitems.length;i++){ptg_gridArea.cells(subitems[i],0).setValue(0);}}} 
	}
	function ptgGridOnRowSelect(id, ind){
		fnCloseLayer();	
		if(ind != 0){
			if(ind == 3){
				var cxnItemID=ptg_gridArea.cells(id, 12).getValue();
				if(cxnItemID != ""){
					doPtgDetail(cxnItemID);
				}
			}else if(ind == 4){
					var itemID = ptg_gridArea.cells(id, 10).getValue();
					var linkUrl = ptg_gridArea.cells(id, 13).getValue();
					var lovCode = ptg_gridArea.cells(id, 14).getValue();
					var attrTypeCode = ptg_gridArea.cells(id, 16).getValue();
					if(linkUrl != ""){
						fnOpenLink(itemID,linkUrl,lovCode,attrTypeCode);
					}
			}else{
				var itemID=ptg_gridArea.cells(id, 10).getValue();
				if(itemID==""||itemID==undefined){				
				}else{doPtgDetail(itemID);}
			}
		}
	}
	
	function doPtgDetail(avg){
		/*
		var url    = "subMenu.do"; // 요청이 날라가는 주소
		var data   = "url=processChildMenu&languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}&parentID=${s_itemID}&subID="+avg; //파라미터들
		var target = "PPobjInfo";
		ajaxPage(url, data, target);
		*/
		
		//var url = "itemInfoPop.do?screenMode=pop&languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg;
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}	
	function doPPSearchList(){setPtgGridList();}
	
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
					+"&frameName=${frameName}&showElement=${showElement}";
		
	 	ajaxPage(url, data, target);
	}
	
	function delProcess(){
		if(ptg_gridArea.getCheckedRows(0).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");	
			alert("${WM00023}");
		}else{
			/*
			//if(confirm("선택된 항목을 삭제하시겠습니까?")){
			if(confirm("${CM00004}")){
				var checkedRows = ptg_gridArea.getCheckedRows(0).split(",");
				for(var i = checkedRows.length-1 ; i >=0 ; i-- ){
					var itemID=ptg_gridArea.cells(checkedRows[i], 8).getValue();
					if(itemID==""||itemID==undefined){}
					else{var url = "DELCNItems.do";var data = "s_itemID=${s_itemID}&items="+itemID;var target = "blankFrame";ajaxPage(url, data, target);}	
					ptg_gridArea.deleteRow(checkedRows[i]);
				}				
			}*/
			
			//if(confirm("선택된 항목를 삭제하시겠습니까?")){
			if(confirm("${CM00004}")){
				var checkedRows = ptg_gridArea.getCheckedRows(0).split(",");
				var items = "";
				
				for(var i = checkedRows.length-1 ; i >=0 ; i-- ){
					var itemID=ptg_gridArea.cells(checkedRows[i], 10).getValue();
					if(itemID==""||itemID==undefined){}
					else{
						// 삭제 할 ITEMID의 문자열을 셋팅
						if (items == "") {
							items = itemID;
						} else {
							items = items + "," + itemID;
						}
					}
				}
				
				if (items != "") {
					var url = "DELCNItems.do"; 
					var data = "isOrg=Y&s_itemID=${s_itemID}&items="+items;
					var target = "blankFrame";
					ajaxPage(url, data, target);
				}
			}
		}	
	}
			
	function fnConnItemDocumentList(){	
		var url = "cxnItemFileList.do";
		var target = "processDIV";
		var data = "s_itemID=${s_itemID}&option=${option}&filter=${filter}&screenMode=${screenMode}&itemIDs=${itemIDs}"; 
				+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"; 
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
		var j = 0;		
		var items = new Array();
		var classCodes = new Array();
		
		var checkedRows = ptg_gridArea.getCheckedRows(0).split(",");
		if(ptg_gridArea.getCheckedRows(0).length == 0){
			alert("${WM00023}"); return;
		}
		for(var i = checkedRows.length-1 ; i >=0 ; i-- ){
			var itemID = ptg_gridArea.cells(checkedRows[i], 12).getValue();
			var classCode = ptg_gridArea.cells(checkedRows[i], 15).getValue();
			if(itemID !="" ){
				items[j] = itemID;
				classCodes[j] = classCode;
				j++;
			}
		}
		
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
	
	function fnOnRowOver(id, ind, event){		
		if(ind != 0){
			cxnItemID = ptg_gridArea.cells(id, 12).getValue();
			if(ind == 3 && cxnItemID != ""){				
				positionY = event.clientY + 10;
				positionX = event.clientX - 100;
				fnGetCxnAttrList(cxnItemID);
			}else{ fnCloseLayer(); }		
			
		}
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
	
	// ADD HEC IVELL 
	function fncxnItemListPop(e){		
		 var popupForm = document.cxnItemTreeFrm;
		 var url = "zHec_searchItemListPop.do";
		 window.open("" ,"zHec_searchItemListPop", "width=875, height=500, left=400, top=200"); 
		 
		 popupForm.action =url; 
		 popupForm.method="post";
		 popupForm.target="zHec_searchItemListPop";
		 popupForm.s_itemID.value = "${s_itemID}";
		 popupForm.submit();
	}

	// NEW Assign Save	
	function fnSaveCheckedItems(checkedItems, itemTypeCode){		
		var cxnTypeCode = itemTypeCode;
		var cxnClassCode = $("#cxnClassCode").val();
		var url = "createCxnItem.do";
		var data = "s_itemID=${s_itemID}&cxnTypeCode="+cxnTypeCode+"&items="+checkedItems
					+ "&cxnTypeCodes=${varFilter}"
					+ "&cxnClassCode="+cxnClassCode;
		var target = "blankFrame";
		
		ajaxPage(url, data, target);
		
		$("#cxnTypeCode").val("");
		$("#cxnClassCode").val("");
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
	
	<input type="hidden" name="s_itemID" />
	<input type="hidden" name="itemTypeCode" />
	
	<div class="child_search01" id="pertinentSearch">
		<ul>
			<li class="floatR pdR10" >				
				<c:if test="${childCXN ne 'Y' && sessionScope.loginInfo.sessionAuthLev < 4}">
				<span class="btn_pack small icon"><span class="assign"></span><input value="Assign" type="submit" onclick="assignProcess();" title="Assign Process"></span>
				<span class="btn_pack small icon"><span class="assign"></span><input value="Assign_new" type="submit" onclick="fncxnItemListPop()"></span>
				<span class="btn_pack small icon"><span class="edit"></span><input value="Relationship" type="submit" onclick="fnEditAttr();" title="Attribute"></span>	
				</c:if>

				<c:if test="${sessionScope.loginInfo.sessionAuthLev < 4}">
				<span class="btn_pack small icon" id="delPrc"><span class="del"></span><input value="Del" type="submit" id="delPrc" onclick="delProcess();"></span>			
				</c:if>
				<span class="btn_pack medium icon"><span class="list"></span><input value="Documents" type="submit" id="file" onclick="fnConnItemDocumentList();"></span>
				<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excelPrc"></span>	
			</li>			
		</ul>
	</div>	
	<div id="gridPtgDiv" class="mgB10 mgT5">
		<div id="grdPtgArea" style="width:100%;"></div>
	</div>	
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
