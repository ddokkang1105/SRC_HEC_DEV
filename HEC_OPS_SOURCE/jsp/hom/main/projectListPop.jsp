<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script>
	var p_gridArea;	
	$(document).ready(function(){			
		gridInit();
		doSearchList();		
	});
	
	function gridInit(){	
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");	
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});	
		
		p_gridArea.setColumnHidden(4, true);
		p_gridArea.setColumnHidden(5, true);
		p_gridArea.setColumnHidden(6, true);
		p_gridArea.setColumnHidden(7, true);
		p_gridArea.setColumnHidden(8, true);
		p_gridArea.setColumnHidden(9, true);
		
	}
	function setGridData(){
		var result = new Object();	
		result.title = "${title}";
		result.key = "project_SQL.getPJTMemberRelList";
		result.header = "${menu.LN00024},Code,${menu.LN00131},${menu.LN00027},ProjectID,TemplCode,TemplUrl,TemplName,URLFilter,TmplFilter";
		result.cols = "ProjectCode|ProjectName|StatusNM|ProjectID|TemplCode|TemplUrl|TemplName|URLFilter|TemplFilter";
		result.widths = "30,100,*,50,0,0,0,0,0";
		result.sorting = "str,str,str,str,str,str,str,str,str";
		result.aligns = "left,left,left,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&loginUserID=${sessionScope.loginInfo.sessionUserId}";	
						
		return result;
	}
	
	function gridOnRowSelect(id, ind){	
		var projectID = p_gridArea.cells(id, 4).getValue();
		var tmplCode = p_gridArea.cells(id, 5).getValue();	
		var tmplName = p_gridArea.cells(id, 7).getValue();
		var tmplUrl = "pjtTemplate";
		var urlFilter = p_gridArea.cells(id, 8).getValue();
		var tmplFilter = p_gridArea.cells(id, 9).getValue();
		
		//alert("tmplCode:"+tmplCode+", tmplName : "+tmplName+", tmplUrl : "+tmplUrl);		
		var opener = window.dialogArguments;
		opener.changeTempl(tmplCode, tmplName, tmplUrl, '', urlFilter, tmplFilter, projectID);
		self.close();
	}
	
    function doSearchList(){ 
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
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