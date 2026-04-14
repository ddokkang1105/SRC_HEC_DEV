<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp"%>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<!-- 2. Script -->
<script type="text/javascript">
	var p_tree;
	var projectID = "${projectID}";
	var srID = "${srID}";
	var option ="AR000000";
	var itemTypeCodeList = "${itemTypeCodeList}";
	var scrID = "${scrID}";
		
	$(document).ready(function() {
		initTree();

		$("#classCode").SumoSelect({defaultValues: "${itemTypeCodeList}"});

		$('#classCode').change(function(){doSearchList($(this).val());});
	
	});
	
	//===============================================================================
	// BEGIN ::: GRID
	function initTree(){ 
		var data = "itemTypeCodeList="+itemTypeCodeList+"&tFilterCode=MJ&changeMgt=Y&itemStatus=${itemStatus}&updated=${updated}&itemStatusList=${itemStatusList}";		
		var d = fnSetMenuTreeData(data);
		p_tree = new dhtmlXTreeObject("treeArea", "100%", "100%", 0);	
		p_tree.setSkin('dhx_skyblue');
		p_tree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/csh_process/");
		p_tree.enableSmartXMLParsing(true);
		
		p_tree.enableCheckBoxes(true);	//CheckBox
		p_tree.enableDragAndDrop(false);
		fnLoadDhtmlxTreeJson(p_tree, d.key, d.cols, d.data, option);
		p_tree.setOnLoadingEnd(fnEndLoadPopupTree);
		setTimeout(fnSelectItem,1000); 	
		p_tree.attachEvent("onCheck", function(id, state){fnOnCheck(id,state); });
	}
	
	function fnOnCheck(id, state){
		if(state == 0) return false;
		var itemName = p_tree.getItemText(id);
		
		$.ajax({
			url: "checkChangeMgt.do",
			type: 'post',
			data: "&ItemID="+id,
			error: function(xhr, status, error) { 
			},
			success: function(data){	
				if(data != "1"){
					alert(itemName +"은(는) 변경관리 대상이 아닙니다.");
					p_tree.setCheck(id,false);
				}
			}
		});	
	}
	
	
	function doSearchList(avg){
	
		var temp = avg + "";
		temp = temp.split(",");
		var avg2 = "";
		for(var i in temp) {
			if(i == 0)
				avg2 += "'" + temp[i] + "'";
			else 
				avg2 += ",'" + temp[i] + "'";
		}
		if(avg == null) avg2 = "${classCodeList}";
		p_tree.destructor();
		p_tree = new dhtmlXTreeObject("treeArea", "100%", "100%", 0);	
		var data = "classCodeList="+avg2+"&tFilterCode=MJ&changeMgt=Y&itemStatus=${itemStatus}&updated=${updated}";
		
		var d = fnSetMenuTreeData(data);
		
		p_tree.setSkin('dhx_skyblue');
		p_tree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/csh_process/");
		p_tree.enableSmartXMLParsing(true);		
		p_tree.enableCheckBoxes(true);	//CheckBox		
		p_tree.enableDragAndDrop(false);
		
		fnLoadDhtmlxTreeJson(p_tree, d.key, d.cols, d.data,option);
		
		p_tree.setOnLoadingEnd(fnEndLoadPopupTree);
		setTimeout(fnSelectItem,1000); 	
		p_tree.attachEvent("onCheck", function(id, state){fnOnCheck(id,state); });
	}
	
	function fnSelectItem(){
		p_tree.selectItem("${s_itemID}",true,false);
	}
	function fnEndLoadPopupTree(){
		p_tree.disableCheckbox("${s_itemID}",false);
	}
	
	// [Assign][Add] click
	function commitItem(){
		if(p_tree.getAllChecked() == ""){
			alert("${WM00023}");
			return false;
		}
		
		if("${srID}" != "") {
			opener.fnSaveReceiveItspInfo(p_tree.getAllChecked());
			self.close();
		} else {
			fnCommitItem(p_tree.getAllChecked());
		}
		
		if (window.dhtmlx) {
	        for (const key in window.dhtmlx) {
	            delete window.dhtmlx[key];
	        }
	        delete window.dhtmlx;
	    }

	    if (window.dhx) {
	        delete window.dhx;
	    }
	}
	
	// [Commit] Click
	function fnCommitItem(itemIDs){
		var url = "openCommitCommentPop.do";
		var data = "?items="+itemIDs+"&pjtIds=${projectID}";
		window.open(url+data,'',"width=350px, height=350px, left=200, top=100,scrollbar=yes,resizble=0");
	}
	
	// [Check Out] click
	function checkOutItem(){
		var srID = "${srID}";
		var scrID = "${scrID}";
		if(p_tree.getAllChecked() == ""){
			alert("${WM00023}");
			return false;
		}
		if(scrID != ""){
			fnCheckOutItemWithSCR(p_tree.getAllChecked());
		} else {
			fnCheckOutItemWithSR(p_tree.getAllChecked());
		}
		
		if (window.dhtmlx) {
	        for (const key in window.dhtmlx) {
	            delete window.dhtmlx[key];
	        }
	        delete window.dhtmlx;
	    }

	    if (window.dhx) {
	        delete window.dhx;
	    }
	}
	
	function fnCheckOutItemWithSR(itemIDs){
		var url = "checkOutItem.do";		
		var data = "projectID="+projectID+"&itemIds="+itemIDs+"&srID="+srID; 
		var target="blankFrame";			
		ajaxPage(url, data, target);
		
	}
	
	function fnCheckOutItemWithSCR(itemIDs){
		var url = "checkOutItem.do";		
		var data = "projectID="+projectID+"&itemIds="+itemIDs+"&scrID="+scrID; 
		var target="blankFrame";			
		ajaxPage(url, data, target);		
	}
	
	function fnReload() {
		opener.fnUpdateStatus("${speCode}");
		self.close();
	}
	
	function thisReload() {
		opener.fnCallBackSR();
		self.close();
	}
	
	function fnSearchTreeText(type){
		var schText = $("#schTreeMenuText").val();
		//1:검색, 2:다음, 3:이전
		if(type == "1")p_tree.findItem(schText,0,1);
		else if(type == "2") p_tree.findItem(schText);
		else if(type == "3") p_tree.findItem(schText,1);	
	}
	
	
</script>

<div class="popup01">
<ul>
  <li>
	<ul id="breadcrumb">
        <li><span>Select Item</span></li>
    </ul>
	<div class="szone">
  		<div class="con01 mgL10">
  			<div class="floatL mgB10" style="display:flex;">
  				<span class="mgR10">${menu.LN00016}</span>
  				<select id="classCode" name="classCode" multiple="multiple" style="width:180px;">
  					<option value=''>Select</option>
        			<c:forEach var="i" items="${getList}">
                		<option value="${i.CODE}">${i.NAME}</option>                      
        			</c:forEach>             
                </select>
     		</div>	
     		<div class="floatR mgB10">
     			<!-- 검색  -->
	     		<input type="text" class="text" id="schTreeMenuText" style="width:180px;ime-mode:active;"/>
	     		<a onclick="fnSearchTreeText('1')"><img src="${root}${HTML_IMG_DIR}/btn_icon_search.png"></a>
	     		<a onclick="fnSearchTreeText('3')"><img src="${root}${HTML_IMG_DIR}/btn_previous.png"></a> | <a onclick="fnSearchTreeText('2')"> <img src="${root}${HTML_IMG_DIR}/btn_next.png"> </a>
	     		<!-- Assign Button  -->
     			<span class="btn_pack medium icon">
     			<c:if test="${actionType == 'commit'}"><span class="confirm"></span><input value="Select" type="submit" onclick="commitItem();"></c:if>
     			<c:if test="${actionType == 'checkOut'}"><span class="add"></span><input value="Check Out" type="submit" onclick="checkOutItem();"></c:if>
     			</span>
     			
     		</div>	
			<div id="treeArea" style="width:100%;height:325px;background-color:#f9f9f9;border :1px solid Silver;overflow:auto;"></div>  		
		</div>
	</div>
	</li>
	</ul>
</div>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
