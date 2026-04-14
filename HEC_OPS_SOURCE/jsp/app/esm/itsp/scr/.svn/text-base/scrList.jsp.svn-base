<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script>
	var p_gridArea;	
	var mySCR = "${mySCR}";
	var scrMode = "${scrMode}";
	var scrStatus = "${scrStatus}";
		
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 219)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 219)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
				
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		
		fnSelect('scrStatus', data+"&category=SCRSTS", 'getDictionaryOrdStnm', scrStatus, 'Select');
  		fnSelect('regTeam', data, 'getSCRRegTeam', '', 'Select', 'scr_SQL');	
  		
		$("input.datePicker").each(generateDatePicker);
	
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				doSearchList();
				return false;
			}
		});		
		
		setTimeout(function() { gridInit(); doSearchList();},500 );
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
	
	function gridInit(){	
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");	
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});		
		p_gridArea.enablePaging(true,30,null,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.setColumnHidden(0, true);
		p_gridArea.setColumnHidden(11, true);
		p_gridArea.setColumnHidden(12, true);
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setGridData(){
		var result = new Object();
		//result.title = "${title}";
		result.key = "scr_SQL.getSCR";       
		result.header = "${menu.LN00024},SCR No.,${menu.LN00002},${menu.LN00027},Project,${menu.LN00153},${menu.LN00004},${menu.LN00094},${menu.LN00013},${menu.LN00221},CTS${menu.LN00118},SRID,SCRID";
		result.cols = "SCRCode|Subject|StatusName|ProjectName|RegTeamName|RegUserName|ApproverName|RegDT|PlanEndDT|ScrCtsCls|SRID|SCRID";
		result.widths = "0,100,*,100,80,90,80,140,80,80,80";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,left,left,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"	
				    	+ "&pageNum=" + $("#currPage").val()
						+ "&scrMode=" + scrMode
						+ "&mySCR=" + mySCR
						+ "&subject=" + $("#subject").val()
						+ "&status=" + $("#scrStatus").val()
						+ "&regUserName=" + $("#regUser").val()
						+ "&regTeam=" + $("#subject").val()
						+ "&scrCode=" + $("#scrCode").val()
						+ "&st_planStartDT=" + $("#st_planStartDT").val()
						+ "&end_planStartDT=" + $("#end_planStartDT").val()
						+ "&st_planEndDT=" + $("#st_planEndDT").val()
						+ "&end_planEndDT=" + $("#end_planEndDT").val()
						+ "&st_regDT=" + $("#st_regDT").val()
						+ "&end_regDT=" + $("#end_regDT").val()
						+ "&regTeamID=" + $("#regTeam").val()
						+ "&finTestor=${finTestor}"
						+ "&loginUserId=${sessionScope.loginInfo.sessionUserId}";
		return result;
	}
	
	function doSearchList(){ 
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function gridOnRowSelect(id, ind){
		var scrnType = "${scrnType}";
		var scrID = p_gridArea.cells(id, 12).getValue();
		var srID = p_gridArea.cells(id, 11).getValue();
		var screenMode = "V";
		var url = "viewScrDetail.do";		
		var data = "srID="+srID+"&scrID="+scrID+"&screenMode="+screenMode; 
		var w = 1100;
		var h = 800;
		window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	function fnGoDetail(){
		var scrnType = "${scrnType}";
		var mainType = "${mainType}";
		var srID = "${srID}";
		var url = "processItsp.do";
		var data = "&pageNum="+$("#currPage").val()
					+"&srMode=${srMode}&srType=${srType}&scrnType=${scrnType}&itemProposal=${itemProposal}&srID="+srID+"&mainType="+mainType;
		var target = "srListDiv";
		ajaxPage(url, data, target);
	}
		
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}

	
</script>

<div id="scrDiv">
<form name="scrFrm" id="scrFrm" action="" method="post"  onsubmit="return false;">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<div class="floatL mgT10 mgB12" style="width:100%"><h3><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;System Change Request</h3></div>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
		<colgroup>
		    <col width="8%">
		    <col width="17%">
		 	<col width="8%">
		    <col width="17%">
		 	<col width="8%">
		    <col width="17%">
		    <col width="8%">
		    <col width="17%">
	    </colgroup>      
	     <tr>
	      	<!-- 상태 -->
	       	<th class="alignL pdL5">${menu.LN00027}</th>
	        <td>      
		       	<select id="scrStatus" Name="scrStatus" style="width:98%"></select>
	       	</td> 
	     	<!-- 작업계획시작일 -->
	        <th class="alignL pdL5">${menu.LN00061}</th>     
	        <td>     
	            <font><input type="text" id="st_planStartDT" name="st_planStartDT" value=""class="input_off datePicker stext" size="8"
					style="width:63px;text-align:center;" onchange="this.value=makeDateType(this.value);" maxlength="15" >
				</font>
				~
				<font><input type="text" id="end_planStartDT" name="end_planStartDT" value=""	class="input_off datePicker stext" size="8"
					style="width:63px;text-align:center;" onchange="this.value=makeDateType(this.value);" maxlength="15">
				</font>
	         </td> 
	        <!-- 작업계획시작일 -->
	        <th class="alignL pdL5">${menu.LN00221}</th>     
	        <td>     
	            <font><input type="text" id="st_planEndDT" name="st_planEndDT" value=""class="input_off datePicker stext" size="8"
					style="width:63px;text-align:center;" onchange="this.value=makeDateType(this.value);" maxlength="15" >
				</font>
				~
				<font><input type="text" id="end_planEndDT" name="end_planEndDT" value=""	class="input_off datePicker stext" size="8"
					style="width:63px;text-align:center;" onchange="this.value=makeDateType(this.value);" maxlength="15">
				</font>
	        </td>
	          <!-- 등록일 -->
	        <th class="alignL pdL5">${menu.LN00013}</th>     
	        <td>     
	            <font><input type="text" id="st_regDT" name="st_regDT" value=""class="input_off datePicker stext" size="8"
					style="width:63px;text-align:center;" onchange="this.value=makeDateType(this.value);" maxlength="15" >
				</font>
				~
				<font><input type="text" id="end_regDT" name="end_regDT" value=""	class="input_off datePicker stext" size="8"
					style="width:63px;text-align:center;" onchange="this.value=makeDateType(this.value);" maxlength="15">
				</font>
	        </td>	       
	     <tr>
	     	  <!-- SCR No. -->
	        <th class="alignL  pdL5">SCR No.</th>
	        <td  class= "alignL"><input type="text" class="text" id="scrCode" name="scrCode" value="" style="ime-mode:active;width:98%;" /></td>  
	        <!-- SCR 제목 -->
	        <th class="alignL pdL5" >${menu.LN00002}</th>     
		    <td><input type="text" class="text" id="subject" name="subject" value="${subject}" style="ime-mode:active;width:98%;" /></td>    
	        <!-- 담당자 -->
	       	<th class="alignL pdL5">${menu.LN00004}</th>
	        <td><input type="text" class="text" id="regUser" name="regUser" value="" style="ime-mode:active;width:98%;" /></td>
	  		 <!-- 담당조직 -->
	        <th class="alignL pdL5">${menu.LN00153}</th>
	        <td  class= "alignL">     
		        <select id="regTeam" Name="regTeam" style="width:98%">
		            <option value=''>Select</option>
		        </select>
	        </td> 	        
	    </tr>      	 	
   	</table>
   
	<div class="countList pdT5 pdB5" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
           	&nbsp;<span id="viewSearch" class="btn_pack medium icon"><span class="search"></span><input value="Search" type="submit" onclick="doSearchList();" style="cursor:hand;"></span>
        	&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
        </li>
    </div>
    
	<div id="gridDiv" class="mgB10 clear" class="clear" >
		<div id="grdGridArea"></div>
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL5"></div></div>
</form>
</div>