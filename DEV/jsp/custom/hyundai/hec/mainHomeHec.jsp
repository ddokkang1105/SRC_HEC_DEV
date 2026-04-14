<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/reset.css" />
<script type="text/javascript">
    var noticType;var menuIndex = "1 3 4";
    var ruleType;var csIndex = "1 5 16";
    var i_gridArea; var itemTypeCode = "";
	var csType="1";
  
    
    $(document).ready(function(){
    	$("#mainLayer").innerWidth($( window ).width());
		$("#mainLayer").innerHeight($( window ).height());
		$( window ).resize( function() {
			$("#mainLayer").innerWidth($( window ).width());
			$("#mainLayer").innerHeight($( window ).height());
		});
		
        setNoticFrame("1",0);
        setCSFrame("1",0);
        
        $("#icon_plant").click(function(){
        	$("#tab1").attr("checked",true);
        });
        $("#icon_ma").click(function(){
        	$("#tab2").attr("checked",true);
        });
        $("#icon_ms").click(function(){
        	$("#tab3").attr("checked",true);
        });
    });
    
    function setNoticFrame(avg,ind){
    	$(".tab-btn.2").removeClass("active");
    	$(".tab-btn.2").eq(ind).addClass('active');
    	$("#boardMgtID").val(avg);
        var url = "mainBoardList.do";   
        var target = "subBrdFrame";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardMgtID="+avg;
        ajaxPage(url, data, target);
    }
    
    function setCSFrame(avg, ind){
    	$(".tab-btn.1").removeClass("active");
    	$(".tab-btn.1").eq(ind).addClass('active');
    	    	
    	var url = "";
    	var data = "";
    	var target = "";
    	
    	if(avg == "1") {
			csType = "1";
			itemTypeCode = "OJ00001";
    	}
    	if(avg == "5") {
			csType = "5";
    		itemTypeCode = "OJ00005";
    	}
    	if(avg == "16") {
			csType = "16";
    		itemTypeCode = "OJ00016";
    	}
    	
        url = "mainChangeSetList_v2.do";   
        data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemTypeCode="+itemTypeCode;
		target = "subCSFrame"+avg;
		
        ajaxPage(url, data, target);
    }

    
    function fileNameClick(avg1, avg2, avg3, avg4, avg5){
    	var originalFileName = new Array();
    	var sysFileName = new Array();
    	var filePath = new Array();
    	var seq = new Array();
    	sysFileName[0] =  avg3 + avg1;
    	originalFileName[0] =  avg3;
    	filePath[0] = avg3;
    	seq[0] = avg4;
    	var url  = "fileDownload.do?sysFileName="+sysFileName+"&originalFileName="+encodeURIComponent(originalFileName)+"&filePath="+filePath+"&seq="+seq+"&scrnType="+avg5;
    	ajaxSubmitNoAdd(document.mainLayerFrm, url,"saveFrame");
    }
    
    function fnClickMoreBoard(){
    	var boardMgtID = $("#boardMgtID").val();
    	if(boardMgtID ==""){boardMgtID="1";}
    	parent.clickMainMenu('BOARD', 'BOARD','','','','','', boardMgtID);
    }
    
    function fnSearch(){
    	var radioObj = document.all("searchMode");
		var searchMode = "";
		for (var i = 0; i < radioObj.length; i++) {
			if (radioObj[i].checked) {
				searchMode = radioObj[i].value;
				break;
			}
		}
		if(searchMode == "1"){
			fnSearchProcess("OJ00001"); 
		}else if(searchMode == "2"){ 
			fnSearchProcess("OJ00005"); 
		}else if(searchMode == "3"){
			fnSearchProcess("OJ00016");
		}
    }

    function fnSearchProcess(avg){
    	var searchValue = $("#searchValue").val();
    	var url = "searchList.do";
    	var target = "mainLayerFrm";
    	var data = "itemTypeCode="+avg1+"&screenType=main&searchKey=AT00001&searchValue="+searchValue; 
    	ajaxPage(url, data, target);
    }
    
    function setProcessL1(arcCode,id) {
    	parent.clickMainMenu(arcCode,'','','','csh_process','','itemMgt.do?tLink=Y&accMode=OPS&popupUrl=goViewSymbolPop.do&pWidth=1400&pHeight=600&nodeID='+id);
    }
    
    function setMyWork(arcCode,id) {
    	parent.clickMainMenu(arcCode,'표준관리 :: 나의 관리항목','','','','csh_document','itemFolderMgt.do?objClassList=CL05003,CL16004&nodeID='+id+'&showTOJ=Y&accMode=DEV&ownerType=author');
    }
	
	//https://hwaydev.hec.co.kr/myOwnerItemList.do?&ownerType=team&arcCode=ARC5101&menuStyle=csh_process&tmplFilter=undefined&ProjectID=	
	function setMyOrgWork(arcCode,id) {
    	parent.clickMainMenu('ARC5101','표준관리 :: 나의 조직표준','','','','csh_document','myOwnerItemListV4.do?ownerType=team');
    }
	
	function setMyRoleWork(arcCode,id) { // 나의 직무표준
    	parent.clickMainMenu(arcCode,'나의 직무표준','','','','csh_document','itemMgt.do?nodeID='+id+'&accMode=DEV');
    }
	
    function setSopL1(arcCode,id) {
    	parent.clickMainMenu(arcCode,'','','','csh_yellowbooks','csh_document','multiItemTreeMgt.do?&arcDefPage=subMainMgt&pageUrl=zHecSopMain&defMenuItemID='+id+'&objClassLimainHomeHec.jspst=CL05003');
    }

    function setStpL1(arcCode,id) {
    	parent.clickMainMenu(arcCode,'','','','csh_process','','multiItemTreeMgt.do?&arcDefPage=subMainMgt&pageUrl=zHecSopMain&defMenuItemID='+id+'&objClassList=CL05003');
    }
    
    function fnClickMoreChangeSet(){
		/* if(csType == "1") {
    		classCode = "CL01005";
    	}
    	if(csType == "5") {
    		classCode = "CL05003";
    	}
    	if(csType == "16") {
    		classCode = "CL16004";
    	}
 		*/
 		classCode = "CL05003,CL16004";
    	parent.clickMainMenu('CHANGESET', 'CHANGESET','','','','','.do?', '','',classCode,'','');
    }
    
    function fnClickMoreAuthorLogList(){
    	parent.clickMainMenu('AUTHORLOG', 'AUTHORLOG','','','','','.do?', '');
    }

    function gridItemSearchInit(){		
		var d = setGridItemSearchData();		
		i_gridArea = fnNewInitGrid("subRuleFrame2", d);
		
		i_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		i_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
	
		//i_gridArea.setColumnHidden(6, true);
		
		i_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	
		fnLoadDhtmlxGridJson(i_gridArea, d.key, d.cols, d.data, "", "", "", "", "", "${WM00119}", 1000);
	}	
    
    function gridOnRowSelect(id, ind) {    	

		var itemID = i_gridArea.cells(id, 6).getValue();
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemID);	
		
    }
	function setGridItemSearchData(){
		var result = new Object();
		result.title = "${title}"; 
		result.key = "search_SQL.getSearchMultiList";
		result.header = "${menu.LN00024},담당자,ID,사규/프로세스명,최종수정일,";
		result.cols = "Name|Identifier|ItemName|LastUpdated|ItemID";
		result.widths = "30,50,200,300,150,0"; // base 검색
		result.sorting = "int,str,str,str,str,str,int";
		result.aligns = "center,center,center,center,center,left,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&isLastSearch=Y&idExist=Y"
		 			+ "&pageNo=1&LIST_PAGE_SCALE=20&ItemTypeCodes='OJ00001','OJ00007'&ClassCodes='CL01004','CL07002'";
		 

		return result;
	}
	

    function setReport() {
    	var url = "zhwc_ProcessItemStatistics.do";
    	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&isMainMenu=Y";
    	var target = "mainLayerFrm";
    	
    	ajaxPage(url, data, target);
    }
    function setMultiItemMgt(arcCode,id) {
    	parent.clickMainMenu(arcCode,'','','','csh_process','','multiItemTreeMgt.do?&nodeID='+id);
    }
    function setItemMgt(arcCode,id) {
    	parent.clickMainMenu(arcCode,'','','','csh_process','','itemMgt.do?&nodeID='+id);
    }
        
        
    function showSubItem(avg) {

    	var url = "zHecGetSubItemList.do";
    	var data = "selectItemID="+avg;
    	var target = "subProcDiv";
    	
    	ajaxPage(url, data, target);    	
    }

    function setSubItemListDiv(avg) {
    	var subList = avg.split("@");
    	var divText = "<ul>";
	    
        for(var i=0; i< subList.length;i++) {
	        var temp = subList[i].split("_");
	        
	        divText += "<li class='floatL' style='padding-right:10px;'><img src='/cmm/hyundai/images//img_main_s1.png' style='width:80px;height:80px;'><br/><span onclick='setProcessL1(\"AR010712\",\""+temp[0]+"\");' style='background-image:url(\"/cmm/hyundai/images//img_main_s1.png\"); color: white;display: inline-block;width: 73px;text-align:center;'>"+temp[1]+"</span></li>";
	        
        }
        divText += "</ul>"
        
        $("#subProcDiv").html(divText);
        $("#subProcDiv").attr("style","");
        $("#L0Last").attr("style","");
    }
	
	//나의 의견 : https://hwaydev.hec.co.kr/forumMgt.do?&myBoard=Y&arcCode=ARC5300&menuStyle=csh_process&tmplFilter=undefined&ProjectID=
	function setMyForumMgt(arcCode){
		//forumMgt.do?&myBoard=Y&arcCode=ARC5300&menuStyle=csh_process&tmplFilter=undefined&ProjectID=		
		parent.clickMainMenu(arcCode,'나의 의견','','','','csh_document','forumMgt.do?myBoard=Y&arcCode='+arcCode+'&menuStyle=csh_process&tmplFilter=undefined&ProjectID=');
	}
	
</script>

</head>

<BODY style="background:#efefef;overflow:auto;">

<div class="noform" id="mainLayer" style="margin: 0px auto;background: rgb(255, 255, 255);overflow: auto;">
<form name="mainLayerFrm" id="mainLayerFrm" enctype="multipart/form-data" method="post" action="#" onsubmit="return false;" style="width:100%;height: 100%;display: flex;align-items: center;justify-content: center;">
<input id="chkSearch" type="hidden" value="false"></input>
<input id="boardMgtID" type="hidden" value="" >

<div class="contents">
	 <section class="sec1">
	 	<div class="container">
	 		<ul class="tile-group group-4">
	 			 <li>
		 			 <dl>
		                 <dt>My work</dt>
		                 <dd>
		                     <button class="btn btn-success" type="button">${menu.ZLN030}</button>
		                     <div class="btn-overlay">
		                         <button class="btn-cnt"  onclick="setMyWork('ARC5100','201')">
		                             <div class="btn-img-wrap">
		                                 <img src="${root}${HTML_IMG_DIR}/main/icon_notebook.png" alt="">
		                                 <span>${authorCnt}</span>
		                             </div>
		                             <p>${menu.ZLN006}</p>
		                         </button>							 

								 <button class="btn-cnt"  onclick="setMyOrgWork('ARC5101','201')">
		                             <div class="btn-img-wrap">
		                                 <img src="${root}${HTML_IMG_DIR}/main/icon_notebook.png" alt="">
		                                 <!--<span></span>-->
		                             </div>
		                             <p>${menu.ZLN031}</p>
		                         </button>
								 
								 <button class="btn-cnt"  onclick="setMyForumMgt('ARC5300','')">
		                             <div class="btn-img-wrap">
		                                 <img src="${root}${HTML_IMG_DIR}/main/icon_notebook.png" alt="">
									 <!--<span></span>-->
		                             </div>
		                             <p>${menu.ZLN032}</p>
		                         </button>
								 
								 <button class="btn-cnt"  onclick="setMyRoleWork('ARC1140','295981')">
		                             <div class="btn-img-wrap">
		                                 <img src="${root}${HTML_IMG_DIR}/main/icon_notebook.png" alt="">
		                                 <!--<span></span>-->
		                             </div>
		                             <p>${menu.ZLN033}</p>
		                         </button>
								 
		                     </div>
		                 </dd>
		             </dl>
	 			 </li>
	 			 <li>
	                 <dl>
	                     <dt>Process</dt>
	                     <dd>
	                         <p class="tile-sub-title">업무수행의 절차, 순서, 방법과 기준을 Map의 형태로 표현한 표준 문서</p>
	                         <div class="btn-overlay">
	                             <button class="btn-cnt" onclick="setProcessL1('ARC1130','144966')">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_plant2.png" alt="">
	                                     <span>55</span>
	                                 </div>
	                                 <p>${menu.ZLN007}</p>
	                             </button><!--
	                             <button class="btn-cnt">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_building.png" alt="">
	                                     <span>${p2Cnt}</span>
	                                 </div>
	                                 <p>${menu.ZLN008}</p>
	                             </button>-->
	                             <button class="btn-cnt" onclick="setProcessL1('ARC3120','204135')">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_infra.png" alt="">
	                                     <span>15</span>
	                                 </div>
	                                 <p>${menu.ZLN008}</p>
	                             </button><!--
	                             <button class="btn-cnt">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_econ.png" alt="">
	                                     <span>${p4Cnt}</span>
	                                 </div>
	                                <p>${menu.ZLN010}</p>
	                             </button>
	                             <button class="btn-cnt">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_breefcase.png" alt="">
	                                     <span>${p5Cnt}</span>
	                                 </div>
	                                <p>${menu.ZLN011}</p>
	                             </button>-->
	                         </div>
	                     </dd>
	                 </dl>
	             </li>
	             <li>
	                 <dl>
	                     <dt>SOP(Standard Operating Procedure)</dt>
	                     <dd>
	                         <p class="tile-sub-title">조직, 제도, 업무의 절차 및 기준을 서술형 문서의 형태로 작성한 표준문서</p>
	                         <div class="btn-overlay">
	                             <button class="btn-cnt" onclick="setSopL1('ARC2001','123850')">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_plant2.png" alt="">
	                                     <span>${sop1Cnt}</span>
	                                 </div>
	                                  <p>${menu.ZLN007}</p>
	                             </button>
	                             <button class="btn-cnt" onclick="setSopL1('ARC2002','125704')">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_building.png" alt="">
	                                     <span>${sop2Cnt}</span>
	                                 </div>
	                                    <p>${menu.ZLN008}</p>
	                             </button>
								 <!--
	                             <button class="btn-cnt" onclick="setSopL1('ARC2003','125706')">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_infra.png" alt="">
	                                     <span>${sop3Cnt}</span>
	                                 </div>
	                                    <p>${menu.ZLN009}</p>
	                             </button>
								 -->
	                             <button class="btn-cnt"  onclick="setSopL1('ARC2004','125708')">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_econ.png" alt="">
	                                     <span>${sop4Cnt}</span>
	                                 </div>
	                                  <p>${menu.ZLN010}</p>
	                             </button>
	                             <button class="btn-cnt"  onclick="setSopL1('ARC2005','125106')">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_breefcase.png" alt="">
	                                     <span>${sop5Cnt}</span>
	                                 </div>
	                                 <p>${menu.ZLN011}</p>
	                             </button>
								 <!--
	                             <button class="btn-cnt"  onclick="setSopL1('ARC8100','225568')">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_notebook.png" alt="">
	                                     <span>${sopGecCnt}</span>
	                                 </div>
	                                 <p>GEC</p>
	                             </button>
								 -->
	                         </div>
	                     </dd>
	                 </dl>
	             </li>
	             <li>
	                 <dl>
	                     <dt>STP(Standard Technical Practice)</dt>
	                     <dd>
	                         <p class="tile-sub-title">프로젝트 수행 및 기술적인 업무 수행을 목적으로 Typical하게 사용되는 기술참고자료</p>
	                         <div class="btn-overlay">
	                             <button class="btn-cnt"  onclick="setStpL1('ARC3001','133167')">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_plant2.png" alt="">
	                                     <span>${stp1Cnt}</span>
	                                 </div>
	                                 <p>${menu.ZLN007}</p>
	                             </button>
	                             <button class="btn-cnt" onclick="setStpL1('ARC3002','125839')">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_building.png" alt="">
	                                     <span>${stp2Cnt}</span>
	                                 </div>
	                                 <p>${menu.ZLN008}</p>
	                             </button>
	                             <!--
								 <button class="btn-cnt" onclick="setStpL1('ARC3003','158323')">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_infra.png" alt="">
	                                     <span>${stp3Cnt}</span>
	                                 </div>
	                                 <p>${menu.ZLN009}</p>
	                             </button>
								 -->
	                             <button class="btn-cnt" onclick="setStpL1('ARC3004','158325')">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_econ.png" alt="">
	                                     <span>${stp4Cnt}</span>
	                                 </div>
	                                 <p>${menu.ZLN010}</p>
	                             </button>
	                             <!--
	                             <button class="btn-cnt" onclick="setStpL1('ARC3004','225570')">
	                                 <div class="btn-img-wrap">
	                                     <img src="${root}${HTML_IMG_DIR}/main/icon_notebook.png" alt="">
	                                     <span>${stpGecCnt}</span>
	                                 </div>
	                                 <p>GEC</p>
	                             </button>
								 -->
	                         </div>
	                     </dd>
	                 </dl>
	             </li>
	 		</ul>
	 	</div>
	 </section>
	 <section class="sec2">
 		<div class="container">
	 		<ul class="tile-group group-2">
	 			<li>
	 				<dl>
	 					<dt>사내표준관리시스템</dt>
	 					<dd>
	 						<div class="swap-tab-container">
	 							<div class="tab-btn-group">
	                                <button class="tab-btn 1" type="button" onclick="setCSFrame('1',$(this).index());">Process</button>
	                                <button class="tab-btn 1" type="button" onclick="setCSFrame('5',$(this).index());">SOP</button>
	                                <button class="tab-btn 1" type="button" onclick="setCSFrame('16',$(this).index());">STP</button>
	                            </div>
	                            <div class="tab-swap-contents">
                                	<div class="tab-content active">
                                		<div style="height: 175px;overflow: hidden;">
	                                		<div id="subCSFrame1"  name="subCSFrame1" style="width:100%;"></div>
	                                		<div id="subCSFrame5"  name="subCSFrame5" style="width:100%;"></div>
	                                		<div id="subCSFrame16"  name="subCSFrame16" style="width:100%;"></div>
                                		</div> <div class="more_btn-cover">
			                                <a href="" class="btn btn-default" onClick="javascript:fnClickMoreChangeSet();">
			                                    more
			                                </a>
			                            </div>
                                	</div>
                                </div>
	 						</div>
	 					</dd>
	 				</dl>
	 			</li>
	 			<li>
	 				<dl>
	 					<dt>공지사항&amp;FAQ</dt>
	 					<dd>
	 						<div class="swap-tab-container">
	 							<div class="tab-btn-group">
	                                <button class="tab-btn 2" type="button" onclick="setNoticFrame('1',$(this).index());">${menu.LN00001}</button>
	                                <button class="tab-btn 2" type="button" onclick="setNoticFrame('2',$(this).index());">FAQ</button>
	                            </div>
	                            <div class="tab-swap-contents">
                                	<div class="tab-content active">
                                		<div style="height: 165px;overflow: hidden;">
	                                		<div id="subBrdFrame"  name="subBrdFrame" style="width:100%;"></div>
                                		</div> <div class="more_btn-cover">
			                                <a href="" class="btn btn-default" onClick="javascript:fnClickMoreBoard();">
			                                    more
			                                </a>
			                            </div>
                                	</div>
                                </div>
	 						</div>
	 					</dd>
	 				</dl>
	 			</li>
	 		</ul>
	 	</div>
	 </section>
</div>


</form>
</div>

<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</BODY>