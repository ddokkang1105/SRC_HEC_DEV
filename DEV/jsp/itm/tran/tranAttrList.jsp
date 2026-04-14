<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00101" var="WM00101" />

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		};
		
		var data = "Deactivated=1";
		fnSelect('itemType', data, 'itemTypeCode', '');	
		fnSelect('language', data+"&SubLanguage=1", 'langType', '${sessionScope.loginInfo.sessionCurrLangType}');
  		
		
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				doSearchList();
				return false;
			}
		});
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
	
	//===============================================================================
	// BEGIN ::: GRID
// 	function gridInit(){	
// 		var d = setGridData();
// 		p_gridArea = fnNewInitGrid("grdGridArea", d);
// 		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
// 		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");	
// 		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});		
// 		p_gridArea.enablePaging(true,30,null,"pagingArea",true,"recInfoArea");
// 		p_gridArea.setPagingSkin("bricks");
// 		p_gridArea.setColumnHidden(13, true);	
// 		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
// 	}
	
// 	function setGridData(){
// 		var languageID = $("#language").val();			
// 		var result = new Object();
// 		result.title = "${title}";
// 		result.key = "report_SQL.getTranAttrList";                                                                                                                                    
// 		result.header ="${menu.LN00024},${menu.LN00042},${menu.LN00021},L1,${menu.LN00016},${menu.LN00106},Path,Filed Name,Default Language(Before),Default Language(Updated),Target Language,${menu.LN00070},Revision Date,Revision No.";
// 		result.cols = "CategoryCode|ItemType|L1|Class|Identifier|Path|FieldNM|TextDefOLD|TextDef|TargetText|LastUpdated|RevisionDate|Rev_Def";
// 		result.widths = "0,60,80,70,80,70,150,120,120,180,180,70,80,80";
// 		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str";
// 		result.aligns = "center,center,center,center,center,left,left,left,left,left,left,left,center,center";
// 		result.data = "languageID=" + languageID
// 						+ "&sessionLanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
// 						+ "&category=" + $("#category").val()
// 						+ "&itemType=" + $("#itemType").val()
// 						+ "&pageNum=" + $("#currPage").val();
						
// 		return result;
// 	}
	
	function fnUpdateAttrTran(){		
		var url = "updateTranAttr.do";
		var data = "&pageNum="+$("#currPage").val()+"&category="+$("#category").val()+"&itemType="+$("#itemType").val();
		var target = "saveFrame";
		ajaxPage(url, data, target);
	}
	
// 	function doSearchList(){ 
// 		if(!fnCheckValue()){
// 			return;
// 		}
// 		var d = setGridData();
// 		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
// 	}
	
	function fnCheckValue(){
		var languageID = $("#language").val();
		if(languageID == "" || languageID == null){
			alert('${WM00101}');
			return false;
		}
		return true;
	}
		
	/* function fnDownData(){
		if(!fnCheckValue()){
			return;
		}
		$('#fileDownLoading').removeClass('file_down_off');
		$('#fileDownLoading').addClass('file_down_on');
		var url = "downloadTranAttrExcel.do";
		ajaxSubmit(document.tranAttrFrm, url);
	}  */
	
	function doFileDown(avg1, avg2, avg3) {
		var url = "fileDown.do";
		$('#original').val(avg1);
		$('#filename').val(avg2);
		$('#downFile').val(avg3);
		
		ajaxSubmitNoAlert(document.tranAttrFrm, url);
		$('#fileDownLoading').addClass('file_down_off');
		$('#fileDownLoading').removeClass('file_down_on');
	}
	
	function fnTranAttrExcelImport(){
		var url = "tranAttrExcelImport.do";
		var w = 500;
		var h = 180;
		itmInfoPopup(url,w,h);
	}
	
	//===============================================================================
	// BEGIN ::: DATA EXCEL
	function fnDownData() {
		var languageID = $("#language").val();
		var sqlID = "report_SQL.getTranAttrList";
		var param =  "targetLang=" + languageID
			+ "&sessionLanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&category=" + $("#category").val()
			+ "&itemType=" + $("#itemType").val()
			+ "&sqlID="+sqlID;
			
		if(!fnCheckValue()){
			return;
		}
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				p_gridDownArea.data.parse(result);
				fnDownExcel();
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}  
	
	function fnDownExcel(){
// 		p_gridDownArea.toExcel("${root}excelGenerate");
		fnGridExcelDownLoad(p_gridDownArea);
	}
	
// 	function gridDownInit(){	
// 		var d = setGridDownData();
// 		p_gridDownArea = fnNewInitGrid("grdGridDownArea", d);
// 		p_gridDownArea.setImagePath("${root}${HTML_IMG_DIR}/");
// 		p_gridDownArea.setIconPath("${root}${HTML_IMG_DIR}/");		
// 		p_gridDownArea.setPagingSkin("bricks");
// 	}
		
// 	function setGridDownData(){
// 		var languageID = $("#language").val();		
// 		var result = new Object();
// 		result.title = "${title}";
// 		result.key = "report_SQL.getTranAttrDataList";                                                                                                                                    
// 		result.header ="${menu.LN00024},System ID,AttrType Code,Language ID,Item type,Class,ID,Path,Default Language(before),Default Language(updated),Target Language,Last Updated,Revision Date,Revision No.";
// 		result.cols = "ItemID|AttrTypeCode|LanguageID|ItemType|Class|Identifier|ItemPath|TextDefOLD|TextDef|TargetText|LastUpdated|RevisionDate|Rev_Def";
// 		result.widths = "0,60,70,50,80,80,50,150,200,200,200,80,80,80";
// 		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str";
// 		result.aligns = "center,center,center,center,center,left,left,left,left,left,left,left,center,center";
// 		result.data = "language=" + languageID
// 						+ "&sessionLanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
// 						+ "&category=" + $("#category").val()
// 						+ "&itemType=" + $("#itemType").val()
// 						+ "&pageNum=" + $("#currPage").val();
// 		return result;
// 	}
	
	
	
</script>
<!-- BIGIN :: ATTR LIST_GRID -->
<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}/loading_circle.gif"/>
</div>
<div id="tranAttrDiv">
<form name="tranAttrFrm" id="tranAttrFrm" action="#" method="post"  onsubmit="return false;">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="original" name="original" value="">
	<input type="hidden" id="filename" name="filename" value="">
	<input type="hidden" id="downFile" name="downFile" value=""> 

	<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Translation</div>
	<div class="child_search">
		<li>
			${menu.LN00033} &nbsp;&nbsp; 		
			<select id="category" Name="category" style="width:150px;">
				<option value="" >Select</opiton> 
				<option value="OJ" >Object</option>
				<option value="CN" >Connection</option>
				<option value="MOJ" >Modeling object</option>
				<option value="MCN" >Modeling connection</option>
				<option value="TXT" >Modeling Text</option>			
			</select>  &nbsp;&nbsp;
			ItemType &nbsp;&nbsp; 		
			<select id="itemType" Name="itemType" style="width:150px;"></select> &nbsp;&nbsp;
			Language &nbsp;&nbsp; 		
			<select id="language" Name="language" style="width:150px;"></select>
		</li>
		<li class="floatR pdR20">
			&nbsp;<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="doSearchList()" style="cursor:pointer;"/>
		</li>
	</div>
	<div class="countList pdT5 pdB5 " >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
        	<span class="btn_pack medium icon"><span class="confirm"></span><input value="Creat revision" type="button" onclick="fnUpdateAttrTran();"></span>
        	<span class="btn_pack small icon"><span class="down"></span><input value="Download updated data" type="button" id="data" OnClick="fnDownData()"></span>
        	<span class="btn_pack small icon"><span class="down"></span><input value="Update translated data" type="button" id="excel" OnClick="fnTranAttrExcelImport();"></span>
        </li>
    </div>
    
	<div id="layout" style="width:100%;"></div>
	<div id="pagination"></div>
	<div id="p_gridDownArea" style="display:none;"></div>
</form>
</div>
<div id="gridDownDiv" style="visibility:hidden;overflow:hidden;">
<li class="count">Total <span id="TOT_CNTD"></span></li>
	<div id="grdGridDownArea" style="width:100%;height:40px;overflow:hidden;"></div>
</div>
<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none;width:0px;height:0px;" frameborder="0"></iframe>
<script>	
	var pagination;
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	var p_gridDownArea;
	
	var grid = new dhx.Grid("grid",  {
		columns: [
	        { width: 60, id: "CategoryCode", header: [{ text: "${menu.LN00042}", align:"center" }], align:"center"},
	        { width: 80, id: "ItemType", header: [{text: "${menu.LN00021}", align:"center"}], align: "center"},
	        { width: 70, id: "L1", header: [{ text: "L1", align:"center" }], align:"center"},
	        { width: 80, id: "Class", header: [{ text: "${menu.LN00016}", align:"center" }], align:"center" },
	        { width: 70, id: "Identifier", header: [{ text: "${menu.LN00106}", align:"center" }], align:"left"},
	        { width: 150, id: "Path", header: [{ text: "Path", align:"center" }], align:"left"},
	        { width: 120, id: "FieldNM", header: [{ text: "Filed Name", align:"center" }], align:"left"},
	        { width: 180, id: "TextDefOLD", header: [{ text: "Default Language(Before)", align:"center" }], align:"left"},
	        { width: 180, id: "TextDef", header: [{ text: "Default Language(Updated)", align:"center" }], align:"left"},
	        { width: 180, id: "TargetText", header: [{ text: "Target Language", align:"center" }], align:"left"},
	        { width: 70, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align:"left"},
	        { width: 110, id: "RevisionDate", header: [{ text: "Revision Date", align:"center" }], align:"center"},
	        { width: 110, id: "Rev_Def", header: [{ text: "Revision No.", align:"center" }], align:"center"},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	});
	
	layout.getCell("a").attach(grid);

	 if(pagination){pagination.destructor();}
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
	 
	function doSearchList(){
		var languageID = $("#language").val();
		var sqlID = "report_SQL.getTranAttrList";
		var param =  "targetLang=" + languageID
			+ "&sessionLanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&category=" + $("#category").val()
			+ "&itemType=" + $("#itemType").val()
			+ "&pageNum=" + $("#currPage").val()
			+ "&sqlID="+sqlID;
			
		if(!fnCheckValue()){
			return;
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
	
	var p_gridDownArea = new dhx.Grid("p_gridDownArea",  {
		columns: [
	        { width: 70, id: "ItemID", header: [{ text: "System ID", align:"center" }], align:"center"},
	        { width: 80, id: "AttrTypeCode", header: [{text: "AttrType Code", align:"center"}], align: "center"},
	        { width: 60, id: "LanguageID", header: [{ text: "Language ID", align:"center" }], align:"center"},
	        { width: 90, id: "ItemType", header: [{ text: "Item type", align:"center" }], align:"center" },
	        { width: 90, id: "Class", header: [{ text: "Class", align:"center" }], align:"left"},
	        { width: 60, id: "Identifier", header: [{ text: "ID", align:"center" }], align:"left"},
	        { width: 150, id: "ItemPath", header: [{ text: "Path", align:"center" }], align:"left"},
	        { width: 200, id: "TextDefOLD", header: [{ text: "Default Language(before)", align:"center" }], align:"left"},
	        { width: 200, id: "TextDef", header: [{ text: "Default Language(updated)", align:"center" }], align:"left"},
	        { width: 200, id: "TargetText", header: [{ text: "Target Language", align:"center" }], align:"left"},
	        { width: 90, id: "LastUpdated", header: [{ text: "Last Updated", align:"center" }], align:"left"},
	        { width: 90, id: "RevisionDate", header: [{ text: "Revision Date", align:"center" }], align:"left"},
	        { width: 90, id: "Rev_Def", header: [{ text: "Revision No.", align:"center" }], align:"left"},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	});
</script>