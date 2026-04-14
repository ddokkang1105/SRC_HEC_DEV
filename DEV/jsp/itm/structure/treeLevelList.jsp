<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>

<script type="text/javascript">
	
	$(document).ready(function(){
		
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
	
	function fnCheckItemArrayAccRight(seq, DocumentID, id){
		$.ajax({
			url: "checkItemArrayAccRight.do",
			type: 'post',
			data: "&itemIDs="+DocumentID+"&seq="+seq,
			error: function(xhr, status, error) { 
			},
			success: function(data){				
				data = data.replace("<script>","").replace(";<\/script>","");		
				fnCheckAccCtrlFileDownload(data, seq, DocumentID, id);
			}
		});	
	}
	
	
	function fnClearSearch(){
		$("#identifier").val("");
		$("#itemName").val("");
		$("#AT00000").val("");
		$("#level").val("");
		$("#levelName").val("");
	}
	
	function fnGoFileList(){
		var url = "zSkdc_subItemFileList.do";
		var target = "editSubItemFileDiv";
		var data = "s_itemID=${s_itemID}&strItemID=${strItemID}&mstItemID=${mstItemID}"; 
	 	ajaxPage(url, data, target);
	}
	
	function fnSelectClassCode(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");
			return false;
		}
		
		var classCodes = new Array();	
		var levels = new Array();	
		for(idx in selectedCell){
		  	classCodes.push(selectedCell[idx].CODE);
		  	levels.push(selectedCell[idx].Level);
		};
		
		opener.fnGetCategory("${arcCode}", classCodes, levels);
		self.close();
	}
	
	
</script>

<body>
<div id="editSubItemFileDiv" name="editSubItemFileDiv" style="width:98%;height:98%;padding-left:5px;" >
	<div class="countList pdT5" >
	  	<li class="count mgT10 floatL">Total  <span id="TOT_CNT"></span></li>
    	<li class="floatR alignBTN mgR5">	
    		<span class="btn_pack medium icon"><span class="next"></span><input value="Select" type="button" onclick="fnSelectClassCode()"></span>
        </li>
    </div>
	<div style="width: 100%;height:300px;" id="layout"></div>

<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>\
</div>
</body>

<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	var gridData = ${gridData};
	
	var grid = new dhx.Grid("grid",  {
	    columns: [
	    	{ width: 30, id: "checkbox", header: [{ htmlEnable: true, , text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 80, id: "CODE", header: [{text: "Code", align:"center"}], align: "center"},
	        { width: 180, id: "NAME", header: [{ text: "${menu.LN00028}", align:"center" }], align:"left"},
	        { width: 80, id: "Level", header: [{ text: "Level", align:"center" }], align:"left"}
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true   
	    
	});
	
	$("#TOT_CNT").html(grid.data.getLength());
	
	grid.events.on("filterChange", function(row,column,e,item){
		$("#TOT_CNT").html(grid.data.getLength());
	});

	layout.getCell("a").attach(grid);
	
 	function fnReload(){ 
 		var varFilter ="${classCode}";
		var classCode = "";
		if(varFilter != ""){
			var classCodeSpl = varFilter.split(",");				
				if(classCodeSpl.length >0){
					for(var i=0; i<classCodeSpl.length; i++){
					if(i==0){
						classCode += "'"+classCodeSpl[i]+"'";
					}else{
			  			classCode += ",'"+classCodeSpl[i]+"'";
					}
				}
			}
		}
		if($("#startLastUpdated").val() != "" && $("#endLastUpdated").val() == "")	$("#endLastUpdated").val(new Date().toISOString().substring(0,10));
		
		var level = $("#level").val();
		var levelName = $("#levelName").val();
		
		
		var sqlID = "custom_SQL.zSkdc_getSubItemFileList";
		var param =  "strItemID=${strItemID}"	
				+ "&s_itemID=${mstItemID}"
			 	+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			 	+ "&identifier="+$("#identifier").val()
				+ "&itemName="+$("#itemName").val()
				+ "&AT00000="+$("#AT00000").val()
				+ "&sqlID="+sqlID;
				
				if(level == "L1"){
					param = param + "&L1="+levelName;
				} else if(level == "L2"){
					param = param + "&L2="+levelName;
				} else if(level == "L3"){
					param = param + "&L3="+levelName;
				} else if(level == "L4"){
					param = param + "&L4="+levelName;
				} else if(level == "L5"){
					param = param + "&L5="+levelName;
				}
				
				console.log("param: "+param);
			
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);				
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
 	}
 	
 	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 		fnMasterChk('');
 		$("#TOT_CNT").html(grid.data.getLength());
 	}
 	
</script>

</html>