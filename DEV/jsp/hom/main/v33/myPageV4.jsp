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
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>

<style type="text/css">
* html body{ /*IE6 hack*/
padding: 0 0 0 200px; /*Set value to (0 0 0 WidthOfFrameDiv)*/
}
* html #carcontent{ /*IE6 hack*/
width: 100%; 
}
</style>

<script type="text/javascript">
var useCR = "<%=GlobalVal.USE_COMP_CR%>";
var apprSystem = "<%=GlobalVal.DEF_APPROVAL_SYSTEM%>";
var screenType = "${screenType}";
var mainType = "${mainType}";

	$(document).ready(function(){
		clickOpenClose(1);
		if(mainType =="mySRDtl") {
			setSubFrame(10, "srView"); //SR Processing detail
		} else if(mainType == "myWF") { clickOpenClose(3); setSubFrame(14);} 
		 else if(mainType == "myWF15") { clickOpenClose(3); setSubFrame(15);}
		 else if(mainType == "myWF16") { clickOpenClose(3); setSubFrame(16);}
		 else if(mainType == "myItem") {clickOpenClose(2); setSubFrame(2);}
		 else if(mainType == "myCSItem") {setSubFrame(6);}
		 else if(mainType == "myWFDtl") { clickOpenClose(3); setSubFrame(14, "${wfInstanceID}");} 
		
		 else {setSubFrame(12);}
		
		$("#btnFold").click(function(){
			$("#foldframe").attr("style","display:none;");
			$("#foldframeTop").addClass('foldframeTop');
			//$("#foldcontent").addClass('foldcontent');
			$("#foldcontent").removeClass('unfoldcontent');
			$("#foldcontent").addClass('foldcontent');	
			$("#title1").attr("style","display:none;");	
			$("#title2").attr("style","display:block;");	
			fnSetGridResizing();
	     });
		$("#btnUnfold").click(function(){
			$("#foldframe").attr("style","display:block;");
			$("#foldframeTop").addClass('unfoldframeTop');
			$("#foldcontent").removeClass('foldcontent');
			$("#foldcontent").addClass('unfoldcontent');
			$("#title1").attr("style","display:block;");
// 			$("#title2").attr("style","display:none;");	
			fnSetGridResizing(230);
	     });
	});
	
	function fnSetGridResizing(avg){
		$("#help_content").innerHTML = $("#grdGridArea").attr("style","width:"+(setWindowWidth()-avg)+"px;");
		$("#help_content").innerHTML = p_gridArea.setSizes();
	}
	
	function setWindowWidth(){
		var size = window.innerWidth;
		var width = 0;
		if( size == null || size == undefined){
			width = document.body.clientWidth;
		}else{
			width=window.innerWidth;
		}return width;
	} 
	
	// [Menu] Click
	function setSubFrame(avg, wfInstanceID){ 
		setMenuStyle(avg);
		
		var target = "help_content";
		var url = "";
		var data = "";
		
		/* 프로젝트 Main */
		if(avg == "0") {
			url = "myPageMain.do";
		}

		/* Communication */
		if(avg == "1") {
			  var 	url =  "boardForumList.do";
			  var 	data = data + "&BoardMgtID=4&boardTypeCD=MN007&url=boardLForumist&myBoard=Y";
			//clickOpenClose(4);
		}
		
		/* Contents --> Item */
		if(avg == "2") {
			//url = "myItemTreeDiagramList.do";
			url = "itemListMgt.do";
			data = "ownerType=manager&itemListPage=itm/structure/ownerItemListV4";
		}
		
		/* Contents --> Model */
		if(avg == "3") {
			url = "myPageMainModelList.do";
			data = data + "&mainMenu=1&screenType=MyPg";
		}
		/* Contents --> Document */
		if(avg == "4") {
			url = "fileListMgt.do"; //url = "olmDocList.do";
			data = "screenType=mainV4&pageNum=1&myDoc=Y&isPublic=N&url=file/olmDocFileList&listFilterType=search";
		}
			
		/* Change Management  --> Order */
		if(avg == "5") {
			url = "csrList.do";
			data = "&mainMenu=1&memberId=${sessionScope.loginInfo.sessionUserId}";
		}
		
		/*  Change Management  --> Change set */
		if(avg == "6") {		
			url = "myChangeSetV4.do";
			//myChangeSetV4.do
			data = data + "&isMainMenu=4&memberId=${sessionScope.loginInfo.sessionUserId}";
		}
		
		/*  Change Management  --> Task  */ 
		if(avg == "7") {
			url = "editTaskResultList.do";
			data = "mainVersion=mainV4";
		}
		
		/*  Change Management  --> Issue */ 
		if(avg == "8") {
			url = "issueSearchList.do";
			data = "&issueMode=ARC&languageID=${sessionScope.loginInfo.sessionCurrLangType}"; 
		}
		
		/*  Change Management  --> Aproval(변경승인)  */ 
		if(avg == "9") {
			url = "csrList.do";
			data = "mainMenu=3&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		}
		
		/* My SR */
		if(avg == "10") {
			url =  "srList.do";	
			if(option == "srView"){
				var srID = "${srID}"; 				
				data = data + "&srType=ITSP&srMode=mySR&srStatus=ING&screenType=srRcv&srID=${srID}&mainType=mySRDtl";	
			}else {
				data = data + "&srType=ITSP&srMode=mySR&srStatus=ING&screenType=srRcv&pageNum=1"; 		
		    }
		} 
		
		/* Change Management --> CrMstList */
		if(avg == "11") {
			url = "crList.do"; 
			data =  data + "&crMode=myCr&srType=ITSP&screenType=MyPg";
		}
	
		/* Change Management --> my Projet List */
		 if(avg == "12") {
			url = "myProjectList.do";
			data = "isNew=N&pjtMode=R&screenType=myPJT&mainVersion=mainV5";
		 }
		
		 if(avg == "13") { // 상신 : AREQ
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=AREQ&screenType=MyPg&wfStepID=AREQ";
		 }
			
		 if(avg == "14") { // 결재할 문서 CurAprv
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=CurAprv&screenType=MyPg";
			
			if(wfInstanceID != "" && wfInstanceID != undefined){
				data =  data + "&wfInstanceID="+wfInstanceID;
			}
		 }
			
		 if(avg == "15") { // 결재 예정 ToDoAprv
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=ToDoAprv&screenType=MyPg";
		  }
			
		 if(avg == "16") { // 참조 Ref + 관리조직 참조
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=RefMgt&screenType=MyPg";
		 }
			
		 if(avg == "17") { // 승인완료 Cls
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=Cls&screenType=MyPg";
		 }
		 if(avg == "18") { // Info
				url = "viewMyInfo.do"; 
				data =  data + "";
			}
		 if(avg == "19") { // 대무자
			 url = "mbrAgentCfg.do"; 
			 data =  data + "";
		 }
		 if(avg == "20") { // user group
			 url = "groupUsersList.do";
			 data =  data + "";
		 }
		 ajaxPage(url, data, target);
	}
	
	/* Report */
	function setRptFrame(curIndex, url, reportCode) {
		setMenuStyle(curIndex);
		var target = "help_content";
		var url = url;
		var data = "s_itemID=${projectID}";
		
		ajaxPage(url, data, target);
		fnSetVisitLog(reportCode);
	}
	
	function fnSetVisitLog(reportCode){
		url = "setVisitLog.do";
		target = "help_content";
		data = "ActionType=RPT&MenuID="+reportCode;
		ajaxPage(url, data, target);
	}
	
	// [+][-] button event
	function clickOpenClose(avg) {
		if ( avg == 0 || $(".smenu" + avg).css("display") == "none" ||  $(".plus"+ avg).css("display") != "none") {
			$(".smenu" + avg).css("display", "block");
			$(".plus" + avg).css("display", "none");
			$(".minus" + avg).css("display", "block");
		} else {
			$(".smenu" + avg).css("display", "none");
			$(".plus" + avg).css("display", "block");
			$(".minus" + avg).css("display", "none");
		}
	}
	
	function setMenuStyle(avg){
		document.querySelectorAll('.hlepsub .on').forEach(function(e, index){
		    e.classList.remove("on")
		});
		
		document.getElementById("menuCng"+avg).classList.add("on");
		
		document.querySelectorAll('.hlepsub a img').forEach(function(e, index){
		    var src = e.getAttribute("src");
		    var imgName = src.split(".")[0];
		    if(imgName.includes("_b")) {e.setAttribute("src",imgName.substr(0,imgName.length-2)+"."+src.split(".")[1]);}			
		});
		
		var $this = document.querySelector("#menuCng"+avg+" img");
		var getSrc= $this.getAttribute("src");
		var splitResult = getSrc.split(".");
		var result= splitResult[0]+"_b."+splitResult[1];
		$this.setAttribute("src",result);
	}
</script>
</head>
<style type="text/css">
* html body{ /*IE6 hack*/
padding: 0 0 0 200px; /*Set value to (0 0 0 WidthOfFrameDiv)*/
}
* html #carcontent{ /*IE6 hack*/
width: 100%; 
}
</style>
<input id="chkSearch" type="hidden" value="false"></input>
<body id="mainMenu">
	 <div>
	   	<ul class="help_menu">
	   		 <li class="helptitle2" id="title1">
	    		 <span><font style="font-size:15px;"> &nbsp;My Page</font>		 
	    		 <img id="btnFold" class="floatR mgT10 mgR15" src="${root}cmm/common/images/menu/btn_layout_previous.png">
	    		 </span> 	    		
	   		 </li>
	   		 <li id="title2">
	    		 <img id="btnUnfold" name="btnUnfold" class="mgT10 mgL15" src="${root}cmm/common/images/menu/btn_layout_next.png"> 
	   		 </li>
	   	</ul>
    </div>
    <div id="foldframe" class="foldframe">
       	<ul class="help_menu">
       		<c:if test="${sessionScope.loginInfo.sessionLogintype ne 'viewer'}">
       		<!-- 1.Change Management -->        		
           	<li class="helpstitle plus1"><a onclick="clickOpenClose(1);"><img class="mgR5"  src="${root}cmm/common/images/menu/sidebar_tap_close.png"><span class="fontchange">&nbsp;To Do list</span></a></li>
           	<li class="helpstitle line minus1" style="display:none;"><a class="on" onclick="clickOpenClose(1);"><img class="mgR5"  src="${root}cmm/common/images/menu/sidebar_tap_open.png"><span class="fontchange">&nbsp;To Do list</span></a></li>
      	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng12" onclick="setSubFrame(12);"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_project.png">&nbsp;${menu.LN00131}</a></li>
      		<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng5" onclick="setSubFrame(5);"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_csr.png">&nbsp;${menu.LN00191}</a></li>
      	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng6" onclick="setSubFrame(6);"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_contents.png">&nbsp;${menu.LN00082}</a></li>      	 	
      	 	<c:if test="${useCR == 'Y'}" >
      			<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng11" onclick="setSubFrame(11);">&nbsp;IT&nbsp;${menu.LN00092}(CR)</a></li>
      	 	</c:if>
      	 	<c:if test="${useTask == 'Y'}" >
      	 		<li class="hlepsub smenu1"><a id="menuCng7" onclick="setSubFrame(7);">&nbsp;Project Task</a></li>
      	    </c:if>    
      	    <li class="hlepsub line smenu1" style="display:none;"><a id="menuCng1" onclick="setSubFrame(1);"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_QA.png"> &nbsp;Q&A</a></li>
      	      	 
			<!-- 2.Contents -->
			<c:if test="${apprSystem != 'OLM'}" >
               	<li class="helpstitle line plus2"><a onclick="clickOpenClose(2);"><img class="mgR5" src="${root}cmm/common/images/menu/sidebar_tap_close.png"><span class="fontchange">&nbsp;Contents</span></a></li>
            </c:if>
            <c:if test="${apprSystem == 'OLM'}" >
                <li class="helpstitle plus2"><a onclick="clickOpenClose(2);"><img class="mgR5"  src="${root}cmm/common/images/menu/sidebar_tap_close.png"><span class="fontchange">&nbsp;Contents</span></a></li>
            </c:if>
                <li class="helpstitle line minus2" style="display:none;"><a class="on" onclick="clickOpenClose(2);"><img class="mgR5" src="${root}cmm/common/images/menu/sidebar_tap_open.png"><span class="fontchange">&nbsp;Contents</span></a></li> 
           	 	<li class="hlepsub line smenu2" style="display:none;"><a id="menuCng2" onclick="setSubFrame(2);"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_contents.png">&nbsp;${menu.LN00190}</a></li>
           	 	<li class="hlepsub line smenu2" style="display:none;"><a id="menuCng3" onclick="setSubFrame(3);"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_model.png">&nbsp;${menu.LN00125}</a></li>
           	 	<li class="hlepsub line smenu2" style="display:none;"><a id="menuCng4" onclick="setSubFrame(4);"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_cs_all.png">&nbsp;${menu.LN00134}</a></li>
	        
            
            </c:if>
<%--             <c:if test="${apprSystem !=  'OLM'}" > --%>
      
            	<!-- 3. Approval List  -->
            	<li class="helpstitle line plus3"><a onclick="clickOpenClose(3);"><img class="mgR5" src="${root}cmm/common/images/menu/sidebar_tap_close.png"><span class="fontchange">&nbsp;${menu.LN00242} </span></a></li>
                <li class="helpstitle line minus3" style="display:none;"><a class="on" onclick="clickOpenClose(3);"><img class="mgR5"  src="${root}cmm/common/images/menu/sidebar_tap_open.png"><span class="fontchange">&nbsp;${menu.LN00242}</span></a></li>
            		<li class="hlepsub line smenu3" style="display:none;"><a id="menuCng14" onclick="setSubFrame(14);"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_app.png">&nbsp;${menu.LN00243}</a></li>
            	 	<li class="hlepsub line smenu3" style="display:none;"><a id="menuCng13" onclick="setSubFrame(13);"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_app2.png">&nbsp;${menu.LN00211}</a></li>
            		<li class="hlepsub line smenu3" style="display:none;"><a id="menuCng15" onclick="setSubFrame(15);"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_app3.png">&nbsp;${menu.LN00244}</a></li>
            	 	<li class="hlepsub line smenu3" style="display:none;"><a id="menuCng16" onclick="setSubFrame(16);"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_app4.png">&nbsp;${menu.LN00245}</a></li>
            		<li class="hlepsub line smenu3" style="display:none;"><a id="menuCng17" onclick="setSubFrame(17);"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_app5.png">&nbsp;${menu.LN00118}</a></li>
<%--             </c:if> --%>
			
			<c:if test="${sessionScope.loginInfo.sessionLogintype ne 'viewer'}">
	             	 <li class="helpstitle plus4"><a onclick="clickOpenClose(4);"><img class="mgR5" src="${root}cmm/common/images/menu/sidebar_tap_close.png"><span class="fontchange">&nbsp;${menu.LN00287}</span></a></li>
	                 <li class="helpstitle line minus4" style="display:none;"><a class="on" onclick="clickOpenClose(4);"><img class="mgR5"  src="${root}cmm/common/images/menu/sidebar_tap_open.png"><span class="fontchange">&nbsp;${menu.LN00287}</span></a></li>
	             		<c:forEach var="list" items="${reportList}" varStatus="status">
							<li class="hlepsub line smenu4" style="display:none;"><a id="menuCng${startReportIndex + status.count}" onclick="setRptFrame('${startReportIndex + status.count}','${list.ReportURL}?${list.VarFilter}&reportCode=${list.ReportCode}','${list.ReportCode}');"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_monitor.png">&nbsp;${list.ReportName}</a>
							</li>
						</c:forEach>   
				</c:if>    
				<li class="helpstitle plus5"><a onclick="clickOpenClose(5);"><img class="mgR5" src="${root}cmm/common/images/menu/sidebar_tap_close.png"><span class="fontchange">&nbsp;Setting</span></a></li>
                <li class="helpstitle line minus5" style="display:none;"><a class="on" onclick="clickOpenClose(5);"><img class="mgR5" src="${root}cmm/common/images/menu/sidebar_tap_open.png"><span class="fontchange">&nbsp;Setting</span></a></li>
             		<li class="hlepsub line smenu5" style="display:none;"><a id="menuCng18" onclick="setSubFrame(18);"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_info.png">&nbsp;Information</a></li> 
             		<li class="hlepsub line smenu5" style="display:none;"><a id="menuCng19" onclick="setSubFrame(19);"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_of.png">&nbsp;Out of office</a></li>
             		<c:if test="${userGrMgtYN eq 'Y'}">
             		<li class="hlepsub line smenu5" style="display:none;"><a id="menuCng20" onclick="setSubFrame(20);"><img class="mgR5" src="${root}cmm/common/images/menu/icon_sidebar_monitor.png">&nbsp;User Group</a></li>
             		</c:if> 
           </ul>
	</div>
	<div id="foldcontent" class="unfoldcontent">
       <div id="help_content" class="pdL10 pdR10" ></div>
	</div>
</body>
</html>


