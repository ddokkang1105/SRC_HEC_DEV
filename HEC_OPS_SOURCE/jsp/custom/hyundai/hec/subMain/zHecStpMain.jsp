<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/stpSubMain.css"/>

<script type="text/javascript">
    var divText = "";
    var l1ItemID = "";
    var l2ItemID = "";
    var l2Cnt = 0;
    var l2Index = 0;
    
    $(document).ready(function(){
   		var defMenuItemID = "${defMenuItemID}";
   		
   		if(defMenuItemID != "") {
   			setSubItems(defMenuItemID,"${arcCode}");
   		}
		
		$(".sec01").attr("style","height:"+(setWindowHeight() - 65)+"px;");
		$(".nav_tab").attr("style","height:"+(setWindowHeight()  -137)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$(".sec01").attr("style","height:"+(setWindowHeight() - 65)+"px;");
			$(".nav_tab").attr("style","height:"+(setWindowHeight()  -137)+"px;");
		};
    });
    
    function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
    
    function createSubItemDiv(avg){
    	var subList = avg.split("@");
    	var arcCode = $("#arcCode").val();
    	var funcName = "setStpL1";
    	 
        for(var i=0; i<subList.length;i++) { //
	        var temp = subList[i].split("_");

			if(i > 0 && temp[2] == "1" && l2ItemID != temp[0] && l2ItemID != "") {
				divText += "</ul></div>";	
			}

			if(i > 0 && temp[2] == "0" && l1ItemID != temp[0]) {
				divText += "</ul></div></div>";
			}
			
			if(temp[2] == "0") {
				divText += "<div id='Div"+temp[0]+"' class='stpContents_box'><div class='title_sub' onClick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>"+temp[1]+"</div>";
				l1ItemID = temp[0];
				l2ItemID = "";
			}
			else if(temp[2] == "1"){
				divText += "<div class='dcontainer'><p onClick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>"+temp[1]+" ("+temp[4]+")</p><span id='showIcon"+temp[0]+"' onClick='showSubItem(\""+temp[0]+"\")' class='openicon' title='Show'>▼</span><ul id='"+temp[0]+"' style='display:none'>";	
				l2ItemID = temp[2];
			}
			else {
				divText += "<li><span></span><a onclick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>"+temp[1]+" ("+temp[4]+")</a></li>";
			}
        }
        
    	$("#stpContent1").html(divText);
    	var subHeight = $("#stpContent1").height();
    	var winHeight = setWindowHeight();
		
//     	if(subHeight > winHeight) {
// 			$(".nav_tab").attr("style","height:"+( subHeight + 100)+"px;");
//     	}
//     	else {
// 			$(".nav_tab").attr("style","height:900px;");    
//     	}
		
    }
    
    function showSubItem(avg) {
    	if(!$("#"+avg).hasClass("open")) {
    		$("#"+avg).attr("style","");
    		$("#showIcon"+avg).html("▲");
    		$("#"+avg).addClass("open");
    	}
    	else {
    		$("#"+avg).attr("style","display:none");
    		$("#"+avg).removeClass("open");
    		$("#showIcon"+avg).html("▼");
    	}
    }
    
    function checkSubItemCnt(avg,avg2) {
    	ajaxPage("zHecCreateSubItemDiv.do", "itemID="+avg+"&arcCode="+avg2+"&level=2&itemClassCode=CL16004", "saveFrame");
    }
    function setSubItems(avg,avg2){

        divText = "";    	
    	checkSubItemCnt(avg,avg2);


    	$("ul#l0List > li").each(function(i) {
    		var value = $(this).attr('value');
    		if(avg == value) {
    			$(this).addClass("on");    			
    		}
    		else {
    			$(this).removeClass("on");  
    			
    		}
    	});  
    }
    function setStpL1(arcCode,id) {
    	parent.fnRefreshPageCall(arcCode,id,"V");
    }
    
    
</script>

</head>

<BODY style="overflow:auto;">

<input id="arcCode" type="hidden" value="${arcCode}"></input>
<div id="stpContainer">
<div id="stpContents">
<ul class="row">
	<li class="col-4">
		<h1>Standard Technical Practice</h1>
	    <div class="sec01"><!--style="width:1450px;" -->
	    <div class="whitebar">
	   		<input id="tab1" type="radio" name="tabs" <c:if test="${defMenuItemID == '133167'}">checked</c:if>>
			<label for="tab1" onClick="setSubItems('133167','ARC3100')">플랜트</label>
			<input id="tab3" type="radio" name="tabs" <c:if test="${defMenuItemID == '125839'}">checked</c:if>>
			<label for="tab3" onClick="setSubItems('125839','ARC3300')">건축</label>
			<!--
			<input id="tab4" type="radio" name="tabs"  <c:if test="${defMenuItemID == '158323'}">checked</c:if>>
			<label for="tab4" onClick="setSubItems('158323','ARC3300')">인프라</label>
			-->
			<input id="tab5" type="radio" name="tabs"  <c:if test="${defMenuItemID == '158325'}">checked</c:if>>
			<label for="tab5" onClick="setSubItems('158325','ARC3400')">자산</label>
	    </div>
				    	<div class="nav_tab">
							<div id="stpContent1"><!--  style="width:1500px;" -->
							</div>
					</div>
				</li>
			</ul>
		</div>
	</div>

<div style="display:none;"><iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe></div>
</BODY>