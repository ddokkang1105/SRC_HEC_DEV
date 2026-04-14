<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012" />

<!-- 2. Script  -->
<script type="text/javascript">
	$(function(){
		// 초기 표시 화면 크기 조정 
		$("#gridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#gridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		};
		$("#excel").click(function(){OT_gridArea.toExcel("${root}excelGenerate");});
		gridOTInit();
		doOTSearchList();
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

	function gridOTInit(){		
		var d = setOTGridData();	
		OT_gridArea = fnNewInitGrid("gridArea", d);
		OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		fnSetColType(OT_gridArea, 1, "ch");
		OT_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
		OT_gridArea.enablePaging(true,20,10,"pagingArea",true, "recinfoArea");
		OT_gridArea.setPagingSkin("bricks");
		OT_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}  

	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getTaskTypeMgtList";
		result.header = "${menu.LN00024},#master_checkbox,TaskTypeCode,TaskTypeName,${menu.LN00016},FileType";	
		result.cols = "CHK|TaskTypeCode|TaskTypeName|ItemClassName|FltpName";
		result.widths = "50,50,100,160,160,160";
		result.sorting = "int,int,str,str,str,str";
		result.aligns = "center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&pageNum="+$("#currPage").val();	
		return result;
	}

	function gridOnRowOTSelect(id, ind){
		var url = "taskTypeMgtDetail.do";
		var data = "&taskTypeCode="+ OT_gridArea.cells(id, 2).getValue() 
				  +"&pageNum="+$("#currPage").val()
				  +"&viewType=E&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var target = "taskTypeDiv";
		ajaxPage(url,data,target);
	}

	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
	}

	function fnAddNewTaskType(){
		var url = "taskTypeMgtDetail.do";
		var data = "&pageNum="+$("#currPage").val()+"&viewType=N";
		var target = "taskTypeDiv";
		ajaxPage(url,data,target);
	}
	
	function fnDeleteTaskType(){
		if (OT_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		var cnt  = OT_gridArea.getRowsNum();
		var taskTypeCode = new Array;
		var j = 0;
		for ( var i = 0; i < cnt; i++) { 
			chkVal = OT_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				taskTypeCode[j] = OT_gridArea.cells2(i, 2).getValue();
				j++;
			}
		}
		
		if(confirm("${CM00004}")){
			var url = "deleteTaskTypeCode.do";
			var target = "blankFrame";
			var data = "&pageNum="+$("#currPage").val()+"&taskTypeCode="+taskTypeCode;
			ajaxPage(url,data,target);
		}
	}
	
	function fnCallBack(){
		doOTSearchList();
	}

</script>
</head>

<body>
<div id="taskTypeDiv">
<form name="taskTypeList" id="taskTypeList" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<div class="cfgtitle" >					
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;TaskType</li>
		</ul>
	</div>
	<div class="child_search01 mgL10 mgR10">
		<li class="floatR pdR10">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit"  alt="신규" onclick="fnAddNewTaskType()" ></span>
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteTaskType()" ></span>
			</c:if>	
		</li>
	</div>
 	<div class="countList pdL10">
           <li class="count">Total <span id="TOT_CNT"></span></li>
           <li class="floatR">&nbsp;</li>
       </div>
	<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
		<div id="gridArea" style="width:100%"></div>
	</div>	
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->
	<div class="alignBTN">
		&nbsp;<span class="btn_pack medium icon"  style="display: none; "><span class="save"></span><input value="Save" type="submit" alt="저장" id="saveOrg" name="saveOrg" onclick="saveOrgInfo()" ></span>
	</div>
</form></div>
	
<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>	
<!-- END :: FRAME -->	
</body>
</html>