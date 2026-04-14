<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
//===============================================================================
// BEGIN ::: GRID

var layout = new dhx.Layout("grdGridArea", { 
			rows: [
				{
					id: "a",
				},
			]
		});
	
		var gridData = ${gridData};
		var grid = new dhx.Grid("grdGridArea", {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ hidden :true, width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 100, id: "ProjectCode", header: [{ text: "Code" , align: "center" }], align: "center" },
				{ fillspace: true, id: "ProjectName", header: [{ text: "${menu.LN00131}", align: "center" }], align: "center" },
				{ width: 50, id: "StatusName", header: [{ text: "${menu.LN00027}", align: "center" }], align: "center" },
				{ hidden :true, width: 100, id: "ProjectID", header: [{ text: "ProjectID", align: "center" }], align: "center" },	
				{ hidden :true, width: 100, id: "TemplCode", header: [{ text: "TemplCode", align: "center" }], align: "center" },	
				{ hidden :true, width: 100, id: "TemplUrl", header: [{ text: "TemplUrl", align: "center" }], align: "center" },	
				{ hidden :true, width: 100, id: "TemplName", header: [{ text: "TemplName", align: "center" }], align: "center" },	
				{ hidden :true, width: 100, id: "URLFilter", header: [{ text: "URLFilter", align: "center" }], align: "center" },	
				{ hidden :true, width: 100, id: "TemplFilter", header: [{ text: "TmplFilter", align: "center" }], align: "center" }
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);
		$("#TOT_CNT").html(grid.data.getLength());


		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnRowSelect(row);
			}
		}); 

		//그리드ROW선택시
		function gridOnRowSelect(row){	
			var projectID = row.ProjectID;
			var target = "projectListDiv";
			var url = "viewProjectInfo.do";
			data = "isNew=N&s_itemID=" +projectID+ "&pjtMode=R&refID=${refID}&screenType=${screenType}";
			ajaxPage(url, data, target);
		}

		// function gridOnRowSelect(id, ind){	
		// 	var projectID = p_gridArea.cells(id, 4).getValue();
		// 	var tmplCode = p_gridArea.cells(id, 5).getValue();	
		// 	var tmplName = p_gridArea.cells(id, 7).getValue();
		// 	var tmplUrl = "pjtTemplate";
		// 	var urlFilter = p_gridArea.cells(id, 8).getValue();
		// 	var tmplFilter = p_gridArea.cells(id, 9).getValue();
			
		// 	//alert("tmplCode:"+tmplCode+", tmplName : "+tmplName+", tmplUrl : "+tmplUrl);		
		// 	var opener = window.dialogArguments;
		// 	opener.changeTempl(tmplCode, tmplName, tmplUrl, '', urlFilter, tmplFilter, projectID);
		// 	self.close();
		// }
		
// END ::: GRID	
//===============================================================================

	//조회
	function doOTSearchList(){
		// var sqlID = "project_SQL.getPJTMemberRelList"; 원본 쿼리
		var sqlID = "project_SQL.getSetProjectList"; //myProjectList.jsp 쿼리 사용 
		var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
				  + "&loginUserID=${sessionScope.loginInfo.sessionUserId}"
				  + "&sqlID="+sqlID;
				
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
 		$("#TOT_CNT").html(grid.data.getLength());
 		fnMasterChk('');
 	}
	
</script>
<body>
<div id="projectListDiv" style="padding: 0 6px 6px 6px;">
<form name="projectFrm" id="projectFrm" action="" method="post"  onsubmit="return false;">
   	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3><img src="${root}${HTML_IMG_DIR}/icon_pjt_brd.png">&nbsp;&nbsp; ProjectList</h3>
	</div>	
   
	<div class="countList">
        <li class="count">Total  <span id="TOT_CNT"></span></li>   
    </div>    
	<div id="gridDiv" style="width:100%;" class="clear" >
		<div id="grdGridArea" style="height:580px; width:100%"></div>
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
</form>
</div>
</body>