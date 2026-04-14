<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>

<%
    DecimalFormat df = new DecimalFormat("00");
    Calendar currentCalendar = Calendar.getInstance();

  //현재 날짜 구하기
    String strYear   = Integer.toString(currentCalendar.get(Calendar.YEAR));
    String strMonth  = df.format(currentCalendar.get(Calendar.MONTH));
    String strDay   = df.format(currentCalendar.get(Calendar.DATE));
    String strDate = strYear +","+ strMonth +","+ strDay;

  //일주일 전 날짜 구하기
    currentCalendar.add(currentCalendar.DATE, -7);
    String strYear7   = Integer.toString(currentCalendar.get(Calendar.YEAR));
    String strMonth7  = df.format(currentCalendar.get(Calendar.MONTH) + 1);
    String strDay7   = df.format(currentCalendar.get(Calendar.DATE));
    String strDate7 = strYear7 + strMonth7 + strDay7;

  //한달 전 날짜 구하기
    currentCalendar.add(currentCalendar.DATE, -24);
    String strYear31   = Integer.toString(currentCalendar.get(Calendar.YEAR));
    String strMonth31  = df.format(currentCalendar.get(Calendar.MONTH) + 1);
    String strDay31   = df.format(currentCalendar.get(Calendar.DATE));
    String strDate31 = strYear31 + strMonth31 + strDay31;
%>

<!-- dhtmlx scheduler -->
<link rel="stylesheet" href="<c:url value='/cmm/js/dhtmlx/dhtmlxScheduler/codebase/dhtmlxscheduler.css'/>" type="text/css">
<script src="<c:url value='/cmm/js/dhtmlx/dhtmlxScheduler/codebase/dhtmlxscheduler.js'/>" type="text/javascript"></script>
<script src="<c:url value='/cmm/js/dhtmlx/dhtmlxDataProcessor/codebase/dhtmlxdataprocessor.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00040" var="CM00040"/>
<script type="text/javascript" charset="utf-8">
	
	var myDataProcessor;
	var formData = "projectID=${projectID}";
	var userId = "${sessionScope.loginInfo.sessionUserId}";
	$(document).ready(function(){		
		scheduler.config.xml_date="%Y-%m-%d %H:%i";
		scheduler.init('scheduler_here',new Date(<%=strDate%>),"month");
		
		scheduler.config.lightbox.sections = [			
											{name:"Subject", height:50, map_to:"text", type:"textarea" },
		                      				{name:"description", height:130, map_to:"content", type:"textarea" , focus:true},
		                      				{name:"Location", height:43, type:"textarea", map_to:"location" },
		                      				{name:"time", height:72, type:"time", map_to:"auto"}
		                      			];
		
        myDataProcessor = new dataProcessor("saveSchedul.do?userId="+userId);
		myDataProcessor.setTransactionMode("POST", true);
		myDataProcessor.setUpdateMode("off");

		myDataProcessor.init(scheduler);
		myDataProcessor.defineAction("updated", function(tag) {
			alert(tag.firstChild.nodeValue);

		    return true;
		});
		
		// 조회 
		$.ajax({   
			url : "selectSchdlList.do",     
			type: "POST",     
			data : formData,
			//dataType :  'json',
			//contentType: "application/x-www-form-urlencoded; charset=utf-8",
			beforeSend: function(x) {if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	},
			success: function(data){  
				scheduler.parse(data, "json");
			},     
			error: function (jqXHR, textStatus, errorThrown)     {       }
			});
		
	 });  
	
	// 스케쥴 조회 
	function fnSelectSchdl(){ 
		scheduler.clearAll(); 
		$.ajax({   
			url : "selectSchdlList.do",     
			type: "POST",     
			data : formData,
			//dataType :  'json',
			//contentType: "application/x-www-form-urlencoded; charset=utf-8",
			beforeSend: function(x) {if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	},
			success: function(data)     {  
				scheduler.parse(data, "json");
			},     
			error: function (jqXHR, textStatus, errorThrown)     {       }
			});
		
	}
   
	function fnSaveSchdl(){
		var sessionAuthLev = "${sessionScope.loginInfo.sessionAuthLev}";
		if(sessionAuthLev < 3){
			if(confirm("${CM00001}")){	
				myDataProcessor.sendData();
			}
		}else{
			alert("${CM00040}"); return;
		}
	}
	
	// 스케쥴 목록이동	
	function fnGoList(){ 
		var projectID = "${projectID}";
		var screenType = "${screenType}";
		var pageNum = "${pageNum}";
		if(screenType == "mainV3"){ // mainHomLayerV3일경우 
			parent.fnCallSheduleList(projectID,screenType,pageNum); 
		}else{
			document.location.href = "goSchdlListMgt.do";
		}
	}
	
	//스케쥴 상세화면 이동
	function goSchdlDetail(isNew,boardMgtID,scheduleId){		
		var url = "selectSchedulDetail.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&NEW="+isNew+"&scheduleId="+scheduleId;
		var target = "subBFrame";
		ajaxPage(url, data, target);		
	}
	
	function fnOnDblClick(){ //alert(017);
		var url="schdlDetailPop.do";
		var data=data="languageID=${sessionScope.loginInfo.sessionCurrLangType}&scheduleID=1";
		fnOpenLayerPopup(url,data,"",617,436);/*openPopup(url,400,400,"new");*/
	}
	
</script>

<style type="text/css" media="screen">
	html, body{
		margin:0px;
		padding:0px;
		height:100%;
		overflow:hidden;
	}	
</style>

<div style="padding:0px 0 0 40px;">
<form id="SCHFrm" action="saveSchedul.do" method="post" >
	<input type="hidden" id="noticType" name="noticType" value="${noticType}">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}" />	
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
	<input type="hidden" id="privateId" name="privateId" value="${privateId}">
	<input type="hidden" id="noticType" name="noticType" value="${noticType}">
	<input type="hidden" id="userId" name="userId" value="${sessionScope.loginInfo.sessionUserId}">
	<input type="hidden" id="userGrpId" name="userGrpId" value="">
</form>
	<div class="cop_hdtitle" style="padding:20px 0 0 20px;border-bottom:1px solid #ccc;margin:0 auto;width:100%;">
	<h3 style="padding: 0 0 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_schedule.png">&nbsp;&nbsp;Schedule&nbsp;</h3>
	</div><div style="height:10px"></div>	
	<div id="scheduler_here" class="dhx_cal_container" style='width:95%; height:85%;margin:0 auto;padding:20px 0 0 20px'>		
	    <div class="dhx_cal_navline">
	        <div class="dhx_cal_prev_button" style="left:252px;">&nbsp;</div>
	        <div class="dhx_cal_today_button"  style="left:300px;"></div>
	        <div class="dhx_cal_next_button" style="left:380px;">&nbsp;</div>
	        <div class="dhx_cal_date"></div>
	        <div class="dhx_cal_tab" name="day_tab" style="right:204px;"></div>
	        <div class="dhx_cal_tab" name="week_tab" style="right:140px;"></div>
	        <div class="dhx_cal_tab" name="month_tab" style="right:76px;"></div>
	        <div style="margin-left:86%">
		      <span class="btn_pack medium icon"><span class="reload"></span><input value="Reload" type="button" onclick="fnSelectSchdl()"></span>&nbsp;&nbsp;
		      <!--<c:if test="${sessionScope.loginInfo.sessionAuthLev<3}">
		      <span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="button" onclick="fnSaveSchdl()"></span>&nbsp;&nbsp; 
		      </c:if>-->
		      <span id="viewList" class="btn_pack medium icon"><span class="list"></span><input value="List" type="button"  onclick="fnGoList()"></span> 
		    </div>
	    </div>
	    <div style="border-left:1px;padding:0 50px 0 0px" class="dhx_cal_header" ></div>
	    <div style="border-left:1px;" class="dhx_cal_data"></div>       
	</div>
	
	<div id="subFrame" name="subFrame" width="" height=""></div>
	</div>


