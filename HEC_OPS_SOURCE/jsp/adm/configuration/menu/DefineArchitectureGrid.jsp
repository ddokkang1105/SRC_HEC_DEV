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

<!-- 2. Script -->
<script type="text/javascript">
	$(function(){	
		// 초기 표시 화면 크기 조정
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
		};
		gridOTInit();
		doOTSearchList();
	});
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	//===============================================================================
	//BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();	
		gridArea = fnNewInitGrid("grdOTGridArea", d);
		gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		gridArea.setIconPath("${root}${HTML_IMG_DIR_ARC}/");
		fnSetColType(gridArea, 1, "ch");
		fnSetColType(gridArea, 6, "img");
		gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
		//START - PAGING
		//gridArea.enablePaging(true, df_pageSize, null, "pagingArea", true, "recinfoArea");
		gridArea.enablePaging(true,20,10,"pagingArea",true, "recinfoArea");
		gridArea.setPagingSkin("bricks");
		gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		//END - PAGING
	}  

	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getDefineArchitectureList";
		result.header = "${menu.LN00024},#master_checkbox,Code,Level1,Level2,Style,Icon,DeActivated,MenuURL,Type"; 	
		result.cols = "CHK|ArcCode|ArcGroup|ArcName|Style|Icon|Deactivated|MenuURL|Type"; 
		result.widths = "50,50,80,150,150,120,50,80,200,80";
		result.sorting = "int,int,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,left,left,left,center,center,left,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&searchKey="+ $("#searchKey").val()
						+ "&searchValue="+ $("#searchValue").val()
						+ "&pageNum="+ $("#currPage").val();							 
			if($("#CategoryCode").val() != null){
				result.data = result.data +"&CategoryCode="+$("#CategoryCode").val();			
			}				
		return result;
	}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind){
		var url = "architectureView.do";
		var data = "&ArcCode="+ gridArea.cells(id, 2).getValue() + 
				"&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + 
				"&pageNum=" + $("#currPage").val()+
				"&viewType=E";				
		var target = "processListDiv";	
		ajaxPage(url,data,target);	
	}
	
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(gridArea, d.key, d.cols, d.data);
	}
	
	function fnDelArc(){
		if (gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		var cnt  = gridArea.getRowsNum();
		var arcCode = new Array;
		var j = 0;
		for ( var i = 0; i < cnt; i++) { 
			chkVal = gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				arcCode[j] = gridArea.cells2(i, 2).getValue();
				j++;
			}
		}
		
		if(confirm("${CM00004}")){
			var url = "deleteArchitecture.do";
			var target = "blankFrame";
			var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + 
						"&pageNum=" + $("#currPage").val()+
						"&arcCode="+arcCode;		
			//$("#arcCode").val(arcCode);
			//ajaxSubmit(document.processList, url, target);
			
			ajaxPage(url,data,target);	
		}
	}
	
	function fnCallBack(){
		doOTSearchList();
	}
	
	function fnAddArc(){
		var url = "architectureView.do";
		var data = "&pageNum=" + $("#currPage").val() +"&viewType=N";				
		var target = "processList";	
		ajaxPage(url,data,target);	
	}

</script>
</head>
<body>
<div id="processListDiv">	
<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
		<input type="hidden" id="arcCode" name="arcCode" value="" ></input>
		<div class="cfgtitle" >					
			<ul>
				<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Architecture</li>
			</ul>
		</div>
		<div class="child_search01  mgL10 mgR10">
				<li class="pdL10">
					<select id="searchKey" name="searchKey">
						<option value="">Select</option>
						<option value="G">Group</option>
						<option value="T">Tree</option>
						<option value="M">Menu</option>
					</select>						
					<input type="text" id="searchValue" name="searchValue" value="" class="text" style="width:150px;ime-mode:active;">
					<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="doOTSearchList()" value="검색">
				</li>				
				<li class="floatR pdR10">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">	
					<!-- 엑셀 다운 아이콘  -->
					&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
					
					<!-- 생성 아이콘  -->
					&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit"  alt="신규" onclick="fnAddArc()" ></span>
					&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDelArc()" ></span>
					</c:if>	
				</li>
		</div>
		<input type="hidden" id="orgTypeCode" name="orgTypeCode" />
		<input type="hidden" id="SaveType" name="SaveType" value="New" />	
		<input type="hidden" id="currPage" name="currPage" value=""></input> 
		<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
		 <div class="countList pdL10">
               <li class="count">Total  <span id="TOT_CNT"></span></li>
             <li class="floatR">&nbsp;</li>
         </div>		
		<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
			<div id="grdOTGridArea" style="width: 100%"></div>
		</div>
		</div>	
		<!-- START :: PAGING -->
		<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div>
		</div>	
		<!-- END :: PAGING -->			
	</form>
	</div>	
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>