<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<style type="text/css">
	#framecontent{border:1px solid #e4e4e4;overflow: hidden; background: #f9f9f9;padding:5px;margin:0 auto;}
</style>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00029" var="WM00029"/>

<script>

	
	$(document).ready(function(){	
		$('#fileDownLoading').removeClass('file_down_on');
		$('#fileDownLoading').addClass('file_down_off');

		doSearchAttr1List();
		doSearchAttr2List();


	});
	//===============================================================================
	// BEGIN ::: GRID

 	function doSearchAttr1List(){

		let	sqlID = "report_SQL.itemAttrHeaderByHierarchStr";
		let param ="&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&s_itemID=${s_itemID}&itemTypeCode=${itemTypeCode}"
					+"&sqlID="+sqlID;	
					
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
					 grid1.data.parse(result);
				 
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});	
	}
	 
	function doSearchAttr2List(){

		let	sqlID = "report_SQL.itemAttrHeaderByHierarchStr";
		let param ="&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&s_itemID=${s_itemID}&itemTypeCode=${itemTypeCode}"
					+"&Mandatory=1"
					+"&sqlID="+sqlID;	
					
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
					 grid2.data.parse(result);
				 
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});	
	} 
	
	function doClickMove(toRight){
	
		 // source/target 결정
		  const source = toRight ? grid1 : grid2;
		  const target = toRight ? grid2 : grid1;


		  const items = source.data.serialize();


		  const toMove = items.filter(row => row.CHK === true);

		  if (!toMove.length) {
		    alert("${WM00029}"); // "선택된 항목이 없습니다" 
		    return;
		  }


		  toMove.forEach(row => {

		    let newId = row.id;
		    if (target.data.exists && target.data.exists(newId)) {
		      newId = Date.now() + "_" + newId;
		    } else if (target.data.getItem && target.data.getItem(newId)) {
		      newId = Date.now() + "_" + newId;
		    }


		    const newRow = { ...row, id: newId, CHK: false };


		    target.data.add(newRow);

	
		    source.data.remove(row.id);
		  });
	}	
	//==========================================================================
	//===============================================================================
	// BEGIN ::: GRID
		/* =================grid1 ====================== */
	 var layout = new dhx.Layout("attr1GridArea", {
    rows: [
        {
            id: "a",
        },
    ]
}); 

 var grid1 = new dhx.Grid(null, {
    columns: [
        { hidden:true , width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { id: "CHK", width: 60, header: [{ text: "", align: "center" }],
        			type: "boolean",       
        		  editable: true,
        		  align: "center"
        },
        {  gravity:1,id: "AttrName",  header: [{ text: "${menu.LN00114}", align: "center" }], align: "left" },
        {  hidden:true ,width: 100,id:"AttrType",   header: [{ text: "${menu.LN00015}", align: "center" }], align: "left" }
        
    ],

    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
});

layout.getCell("a").attach(grid1);
	
	
	
	/* =================grid2 ====================== */
	
var layout2 = new dhx.Layout("attr2GridArea", {
    rows: [
        {
            id: "a",
        },
    ]
}); 

 var grid2 = new dhx.Grid(null, {
    columns: [
        { hidden:true , width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { id: "CHK", width: 60, header: [{ text: "", align: "center" }],
        			type: "boolean",       
        		  editable: true,
        		  align: "center"
        },
        { gravity:1,id: "AttrName",  header: [{ text: "${menu.LN00115}", align: "center" }], align: "left" },
        {hidden:true, width: 100,id:"AttrType",   header: [{ text: "${menu.LN00115}", align: "center" }], align: "left" }
        
    ],

    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
});

layout2.getCell("a").attach(grid2);


/* ==============================================Excel down Grid ===================================== */
 var layout3 = new dhx.Layout("excelGridArea", { rows: [{ id: "a" }] });

 var gridData3 = "";

 // 2) 고정 컬럼
 const baseCols = [
   { width: 50,  id: "",               header: [{ text: "", align: "center" },{ text: "관계", align: "center" }], align: "center" },
   { width: 80,  id: "ConnctionID",    header: [{ text: "", align: "center" },{ text: "ConnctionID", align: "center"}], align: "center" },
   //from 그룹 
   { width: 100, id: "FromIdentifier", header: [{ text: "From", align: "center", colspan: 3 }, { text: "Identifier", align: "center" }], align: "center" },
   { width: 200, id: "FromItemName",   header: [{ text: "", align: "center" },{ text: "Name", align: "center" }], align: "left" },
   { width: 300, id: "FromItemPath",   header: [{ text: "", align: "center" },{ text: "Path", align: "center" }], align: "left" },
   //to 그룹 
   { width: 100, id: "ToIdentifier",   header: [{ text: "To", align: "center",colspan: 3  },{ text: "Identifier", align: "center" }], align: "left" },
   { width: 120, id: "ToItemName",     header: [{ text: "", align: "center" },{ text: "Name", align: "center" }], align: "left" },
   { width: 200, id: "ToItemPath",     header: [{ text: "", align: "center" },{ text: "Path", align: "center" }], align: "left" },
 ];



 var layout3 = new dhx.Layout("excelGridArea", { rows: [{ id: "a" }] });
 // grid3 생성
  var grid3 = new dhx.Grid(null, {
    columns: baseCols,     // 초기엔 base만
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: []
  });
 layout3.getCell("a").attach(grid3);


	
 	function doSearchList(){
		$('#fileDownLoading').removeClass('file_down_off');
		$('#fileDownLoading').addClass('file_down_on');

		var url = "cNListReportExcel.do";
		

		 
		  const rows = [];
		  if (typeof grid2.data.each === "function") {
		    grid2.data.each(r => rows.push(r));
		  } else if (typeof grid2.data.serialize === "function") {
		    rows.push(...grid2.data.serialize());
		  }

		  const types = rows.map(r => r.AttrType).filter(v => v != null && v !== "");
		  const names = rows.map(r => r.AttrName).filter(v => v != null && v !== "");
	

		  const subcols  = types.join("|");                          

		  const subdata  = types.map(function(t){ return "'" + String(t).replace(/'/g,"''") + "'"; }).join(",");
		  const attrName = names.map(function(n){ return "'" + String(n).replace(/'/g,"''") + "'"; }).join(",");

		  $('#subcols').val(subcols || "");
		  $('#AttrTypeCode').val(subdata || "");
		  $('#AttrName').val(attrName || "");

		ajaxSubmit(document.reportFrm, url);
		
		

	} 
//배열처리 
	 const asArray = (v) => {
	   if (Array.isArray(v)) return v;
	   if (typeof v !== "string") return [];
	   const s = v.trim();
	   if (!s) return [];
	   // JSON 배열 문자열이면 파싱
	   if (s.startsWith("[") && s.endsWith("]")) {
	     try { return JSON.parse(s); } catch(e) {}
	   }

	   return s.split(",").map(x => x.replace(/['"]/g,"").trim()).filter(Boolean);
	 };

	function doFileDown(avg1, avg2) {
		var url = "fileDown.do";
		document.reportFrm.original.value = avg1;
		document.reportFrm.filename.value = avg1;
		document.reportFrm.scrnType.value = avg2;
		
		ajaxSubmitNoAlert(document.reportFrm, url);
		$('#fileDownLoading').addClass('file_down_off');
		$('#fileDownLoading').removeClass('file_down_on');
	}
	
	// END ::: GRID	
	//===============================================================================
		
	//선택된 라디오 버틈 value 취득
	function fnGetRadioValue(radioName, hiddenName) {
		var radioObj = document.all(radioName);
		var isChecked = false;
		for (var i = 0; i < radioObj.length; i++) {
			if (radioObj[i].checked) {
				$('#' + hiddenName).val(radioObj[i].value);
				isChecked = true;
				break;
			}
		}
		if (!isChecked) {
			$('#' + hiddenName).val(0);
		}
	}	
	
</script>
<!-- BIGIN :: ATTR LIST_GRID -->
<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}/loading_circle.gif"/>
</div>

<div>
<form name="reportFrm" id="reportFrm" action="#" method="post" onsubmit="return false;">
	<div class="pdT10">
		<input type="hidden" id="subcols" name="subcols" value="">
		<input type="hidden" id="AttrTypeCode" name="AttrTypeCode" value="${attType}">
		<input type="hidden" id="AttrName" name="AttrName" value="${attrName}">
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
		<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
		<input type="hidden" id="itemTypeCode" name="itemTypeCode" value="${itemTypeCode}"/>
		
		<input type="hidden" id="original" name="original" value="">
		<input type="hidden" id="filename" name="filename" value="">
		<input type="hidden" id="downFile" name="downFile" value="">
		<input type="hidden" id="scrnType" name="scrnType" value="">
		
		<input type="hidden" id="downLoadMode" name="downLoadMode" value="">
	</div>
</form>
	<table style="width:100%;height:185px;overflow:hidden;" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="45%" align="left"><div id="attr1GridArea" style="height:250px;width:100%"></div></td>
			<td width="10%" align="center">
				<img src="${root}${HTML_IMG_DIR}/btn_add_attr.png"  style = "cursor: pointer;" onclick="doClickMove(true);" title="추가"><br><br>
				<img src="${root}${HTML_IMG_DIR}/btn_remove_attr.png" style = "cursor: pointer;" onclick="doClickMove(false);" title="삭제">
			</td>				
			<td width="45%" align="left"><div id="attr2GridArea" style="height:250px;width:100%"></div></td>
		</tr>
		<tr>
			<td colspan="3" align="right" class="pdT10 pdR20">
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="btnDown" onclick="doSearchList();"></span>
			</td>
		</tr>
	</table>
	
</div>
<!-- END :: LIST_GRID -->

<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
