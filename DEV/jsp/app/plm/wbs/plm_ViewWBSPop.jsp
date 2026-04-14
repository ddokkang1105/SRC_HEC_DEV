<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<script src="${root}cmm/js/dhtmlx/dhtmlxGantt/dhtmlxgantt.js" type="text/javascript"></script>
<script src="${root}cmm/js/dhtmlx/dhtmlxGantt/locale/locale_kr.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/dhtmlxgantt.css" />
<style>
	html, body {
		height: 100%;
		padding: 0px;
		margin: 0px;
		overflow: hidden;
	}

</style>
<script>
jQuery(document).ready(function() {

	gantt.config.columns = [
		{name:"text",       label:"Process 명",  width:300, tree:true },
		{name:"start_date", label:"시작일", align: "center", width:100},
		{name:"end_date",   label:"종료일",   align: "center",width:100 },
		{name:"id", id:"id" , label:"TREE_ID",   align: "center", hide:true, width:100},
		{name: "add", width: 40}
	];
	
	gantt.attachEvent("onAfterTaskAdd", function(id,item){
		$("#startDate").val(item.start_date);
		$("#endDate").val(item.end_date);
		$("#stepKey").val(item.id);
		$("#parent").val(item.parent);
		$("#text").val(item.text);
		
		ajaxSubmitNoAdd(document.wbsFrm, "pim_UpdateProjectWBS");
	});

	gantt.attachEvent("onBeforeTaskDisplay", function(id, task){
	  
		var filterValue = $("#searchValue").val();
		  
		if(hasValue(id, filterValue)){
		  	return true;
		}else{
		    return false;
		}

	});
	
	gantt.attachEvent("onLightboxDelete", function(id){
	    var task = gantt.getTask(id);
	    if (task.duration > 60){
	        alert("The duration is too long. Please, try again");
	        return false;
	    }
	    return true;
	});
	
	gantt.attachEvent("onLightboxSave", function(id, task, is_new){
	
		
		$("#startDate").val(changeDateFormat(task.start_date));
		$("#endDate").val(changeDateFormat(task.end_date));
		$("#stepKey").val(task.id);

		ajaxSubmitNoAdd(document.wbsFrm, "pim_UpdateProjectWBS.do","blankFrame");
	    return true;
	});

	$.ajax({   
		url : "/getWBSInstanceList.do",     
		type: "POST",     
		data : "ProcInstNo=${ProcInstNo}",
		beforeSend: function(x) {if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	},
		success: function(returnData){

			var temp = returnData.split("(SLASH)");
			temp = "{" + temp[0] +"," + temp[1] + "}";	
			$(".mygantt").dhx_gantt({
				data: temp
			});
			
			modSampleHeight();

		},     
		error: function (jqXHR, textStatus, errorThrown)     {       }
	});
	


});

function fnCallBackSubmit(){				
	ajaxPage("pim_ViewProjectWBS.do","ProcInstNo=${ProcInstNo}","wbsDiv");
}
function fnMultiSave() {
	var cnt = gantt.getTaskCount();
	var nxt = "";
	var wbsKey = "";
	var wbsStartDate = "";
	var wbsEndDate = "";
	var procKey = $("#ProcInstNo").val();
	var wbsParentList = "";
	
	if(confirm("일괄 적용 하시겠습니까?")){			
		for(var i=1; i<cnt; i++) {
			var tmp = gantt.getTaskByIndex(i);
			
			if(i==1) {
				wbsKey = tmp.id;
				wbsStartDate = changeDateFormat(tmp.start_date);
				wbsEndDate = changeDateFormat(tmp.end_date);
			}
			else {
				wbsKey = wbsKey + "," + tmp.id;
				wbsStartDate = wbsStartDate + "," + changeDateFormat(tmp.start_date);
				wbsEndDate = wbsEndDate + "," + changeDateFormat(tmp.end_date);
			}
			
			if(procKey != tmp.parent) {
				wbsParentList = wbsParentList + (i==1? "" : ",") + tmp.parent;
			}
			
		}
		
		$("#startDate").val(wbsStartDate);
		$("#endDate").val(wbsEndDate);
		$("#parent").val(wbsParentList);
		$("#stepKey").val(wbsKey);

		ajaxSubmitNoAdd(document.wbsFrm, "pim_UpdateMultiWBSList.do","blankFrame");
	}
}

function modSampleHeight(){
	var headHeight = 100;
	var sch = document.getElementById("mygantt");
	sch.style.height = (parseInt(document.body.offsetHeight)-headHeight)+"px";

	gantt.setSizes();
}

function changeDateFormat(temp) {
   var yyyy = temp.getFullYear();
   var mm = ('0' + (temp.getMonth()+1)).slice(-2);
   var dd  = ('0' + temp.getDate()).slice(-2);
   return String(yyyy + '-' + mm + '-' + dd);
}
	
function doSearchList(){
	gantt.refreshData();
}	

//find substring inside a string
function contains(haystack, needle){
	var a = (haystack || "").toLowerCase(),
	   b = (needle || "").toLowerCase();
	
	return !!(a.indexOf(b) > -1);

}

function hasValue(parent, value){
	if(contains(gantt.getTask(parent).text, value))
	 return true;
	
	var child = gantt.getChildren(parent);
	for(var i = 0; i < child.length; i++){
	 if(hasValue(child[i], value))
	   return true;
	}
	return false;
}

</script>
<div id="wbsDiv">
<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
	<ul>
		<li>
			<h3 style="padding: 6px 0 6px 0">
				<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;WBS List
			</h3>
		</li>
	</ul>	
</div>
<div class="child_search">
	<ul>
		<li class="L">
		&nbsp;${menu.LN00047}
		<select id="searchKey" name="searchKey" style="width:150px;">
			<option value="">Select</option>
			<option value="Task">Task</option>
		</select>
		</li>
		<li>
			<input type="text" id="searchValue" name="searchValue" value="${searchValue}"  class="text" style="width:150px;ime-mode:active;"/>
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="doSearchList()" value="검색">
		</li>	
		 <li style="float:right;">
	    	<span class="btn_pack medium icon"><span class="confirm"></span><input value="Save all" type="submit" onclick="fnMultiSave();"></span>
	    </li>		
	</ul>
</div>
<div class="mygantt" id="mygantt" name="mygantt" style="width:100%; height:100%;"></div>
<form id="wbsFrm" name="wbsFrm" action="">
	<input type="hidden" id="startDate" name="startDate" value="" />
	<input type="hidden" id="endDate" name="endDate" value="" />
	<input type="hidden" id="text" name="text" value="" />
	<input type="hidden" id="stepKey" name="stepKey" value="" />
	<input type="hidden" id="parent" name="parent" value="" />
	<input type="hidden" id="ProcInstNo" name="ProcInstNo" value="${ProcInstNo}" />
</form>
</div>
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>