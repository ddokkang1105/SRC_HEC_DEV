<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<c:url value="/" var="root" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message
	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message
	code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message
	code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012" />



<!-- 2. Script  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">

	$(document).ready(function() {
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
	});

	$(function() {
		// 초기 표시 화면 크기 조정
		$("#grdOTGridArea").attr("style","height:" + (setWindowHeight() - 180) + "px;");
		// 화면 크기 조정
		window.onresize = function() {$("#grdOTGridArea").attr("style","height:" + (setWindowHeight() - 180) + "px;");
		};
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
	});

	function setWindowHeight() {
		var size = window.innerHeight;
		var height = 0;
		if (size == null || size == undefined) {
			height = document.body.clientHeight;
		} else {
			height = window.innerHeight;
		}
		return height;
	}

	
	
 
	function fnEditMltp(data) {
		var url = "subTab.do";
		var data = "url=defineTemplateMenu&templCode"+data.templCode
		        + "&TemplCode="
				+ data.TemplCode + "&TemplateName=" + data.TemplateName
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&cfgCode=${cfgCode}"
				+ "&pageNum=${pageNum}&viewType=E&projectID="+ data.ProjectID
		var target = "tempListDiv";
		ajaxPage(url, data, target);
	} 


	function fnAddNewTemplate() {
		var url = "defineTemplateView.do";
		var data = "&cfgCode=${cfgCode}&pageNum=" + $("#currPage").val()
				+ "&viewType=N";
		var target = "tempListDiv";
		ajaxPage(url, data, target);
	}

	function fnDelTempl() {
		//체크된 로우 확인 
		var checkedRow = grid.data.findAll(function (data){
			return data.checkbox
		});
		
		if(checkedRow.length !=0){
			var templCode = new Array;
			var j = 0;
			for (idx in checkedRow) {    
				templCode[idx] = checkedRow[idx].TemplCode
				console.log("templCode:"+templCode[idx] );
			}
				if (confirm("${CM00004}")) {
					var url = "admin/deleteTempl.do";
					var target = "blankFrame";
					$("#templCode").val(templCode);
					ajaxSubmit(document.tempList, url, target);
				}
		}else {
			// 체크된게 없을경우 
			alert("${WM00023}");
			return;
		}
	}


 	function fnEditTmp(TemplCode, ProjectID){
		var url = "subTab.do";
		var urlDetail="defineTemplateMenu";
		var data ="url="+urlDetail+"&templCode="+TemplCode
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+ "&pageNum="+$("#currPage").val()+"&viewType=E&projectID="+ProjectID;
		var target ="tempListDiv";
		ajaxPage(url,data,target);
	}

	 
</script>


</head>

<body>
	<div id="tempListDiv">
		<form name="tempList" id="tempList" action="#" method="post"onsubmit="return false;">
			<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
			<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input>
			<input type="hidden" id="templCode" name="templCode" value=""></input>
			<div class="cfgtitle">
		<!-- <ul>
			    <li style="font-size:14px;"><a style="font-weight:400;font-size:14px;">Master data&nbsp;></a>&nbsp;Template</li>
		     </ul> -->	  
				<span id="cfgPath">
				 <c:forEach var = "path" items = "${path}" varStatus = "status">
						<c:choose>
							<c:when test = "${status.last}">
								<span style = "font-weight: bold;">${path.cfgName}</span>
							</c:when>
							<c:otherwise>
								<span>${path.cfgName}&nbsp;>&nbsp;</span>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</span>
			</div>
			<div class="child_search01 mgL10 mgR10">
				<ul>
					<li class="floatR pdR10">
						<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
							<button class="cmm-btn mgR5" style="height: 30px;" id="excel"
								value="Down">Download List</button>
							<!-- 생성 아이콘 -->
							<button class="cmm-btn mgR5" style="height: 30px;"
								onclick="fnAddNewTemplate()" value="Add">Add Template
								Type</button>
							<!-- 삭제 아이콘 -->
							<button class="cmm-btn mgR5" style="height: 30px;"
								onclick="fnDelTempl()" value="Del">Delete</button>
						</c:if>
							
					</li>
				</ul>
			</div>
        </form>
		
			<input type="hidden" id="orgTypeCode" name="orgTypeCode" /> 
			<input type="hidden" id="SaveType" name="SaveType" value="New" />
			<!--  <div id="processListDiv" class="hidden"
				style="width: 100%; height: 100%;">
				<div class="countList pdL10">
					<UL>
						<li class="count">Total <span id="TOT_CNT"></span></li>
						<li class="floatR">&nbsp;</li>
					</UL>

				</div>
				<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
					<div id="grdOTGridArea" style="width: 100%"></div>
				</div>
			</div>   -->
			<div class="alignBTN">&nbsp;
			<span class="btn_pack medium icon" style="display: none;">
				<span class="save">
				<input value="Save" type="submit" alt="저장"id="saveOrg" name="saveOrg" onclick="saveOrgInfo()">
				</span>
			</span>
			</div>
		
		<div style="width: 100%;" id="layout"></div>
		<div id="pagination"></div>
	</div>

	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank"
			style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
	<!-- END :: FRAME -->
	
	<script type="text/javascript">
		var layout = new dhx.Layout("layout", {
			rows : [ {
				id : "a",
			}, ]
		});	
		var gridData = ${gridData};
		var grid = new dhx.Grid("grdOTGridArea", {
		    columns: [
		        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
		        { width: 110, id: "TemplCode", header: [{ text: "Template Code" , align: "center" }, { content: "inputFilter" }], align: "center" },
		        { width: 200, id: "TemplateName", header: [{ text: "Template Name", align: "center" }] },
		         { id: "Action", type: "string", header: [{ text: "Action"  , align:"center"}], width:120, htmlEnable: true, align: "center",
		        	template: function (text, row, col) {
		                return '<span class="btn_pack small icon mgR10"><span class="config"></span><input value="Config." type="submit" onclick="fnEditTmp(\''+row.TemplCode+'\',\''+row.ProjectID+'\')" ></span>';
		            },
		        }, 
		        { fillspace: true, id: "Description", header: [{ text: "Description", align: "center" }, { content: "inputFilter" }], align: "left" },
		        
		        { width: 100, id: "MenuID", header: [{ text: "MenuId", align: "center" }, { content: "inputFilter" }], align: "center" },
		        { width: 100, id: "Style", header: [{ text: "Style", align: "center" }] , align: "center" },
		        { width: 150, id: "ProjectName", header: [{ text: "${menu.LN00131}", align: "center" }, { content: "selectFilter" }], align: "center" },
		        { width: 90, id: "SortNum", header: [{ text: "SortNum", align: "center" }, { content: "selectFilter" }], align: "center" },
		        { hidden: true, width: 80, id: "Creator", header: [{ text: "Creator", align: "center" }] },
		        { hidden: true,width: 80, id: "CreationTime", header: [{ text: "Creation Time", align: "center" }, { content: "selectFilter" }], align: "center" },
		        { hidden: true,width: 80, id: "LastUpdated", header: [{ text: "LastUpdated", align: "center" }, { content: "selectFilter" }], align: "center" },
		        { hidden: true,width: 80, id: "LastUser", header: [{ text: "LastUser", align: "center" }, { content: "selectFilter" }], align: "center" },
		        { width: 90, id: "Deactivated", header: [{ text: "Deactivated", align: "center" }, { content: "selectFilter" }], align: "center" },
		        { width: 100, id: "VarFilter", header: [{ text: "VarFilter", align: "center" }, { content: "selectFilter" }], align: "center" },
		        { hidden: true,width: 0, id: "ProjectID", header: [{ text: "ProjectID", align: "center" }, { content: "selectFilter" }], align: "center" },
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: gridData
		});
		layout.getCell("a").attach(grid);
		
		//조회
		function thisReload(viewType){
			var sqlID = "config_SQL.getDefineTemplateCode";
			var param = "&cfgCode=${cfgCode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + "&pageNum=" + $("#currPage").val() + "&sqlID="+sqlID;
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

		function fnReloadGrid(newGridData) {
				grid.data.parse(newGridData);
				$("#TOT_CNT").html(total);
				fnMasterChk('');
			}

	</script>
	
	
	
</body>

</html>