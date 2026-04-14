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
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/subMain_sop.css"/>

<script type="text/javascript">
    var divText = "";
    var l1ItemID = "";
    var l2ItemID = "";
    
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
		divText = "";
		$("#sopContent2").attr("style","display:none;");   
    	var arcCode = $("#arcCode").val();
    	var funcName = "setSopL1";
    			
		if(arcCode == "ARC2500") {
			createSubItemDiv2(avg);
		}
		else {
			var subList = avg.split("@");
			
			for(var i=0; i< subList.length;i++) {
				var temp = subList[i].split("_");

				if(i > 0 && temp[2] == "1" && l2ItemID != temp[0] && l2ItemID != "") {
					divText += "</ul></div>";	
				}
				if(i > 0 && temp[2] == "0" && l1ItemID != temp[0]) {
					divText += "</ul></div></div>";
				}

				if(temp[2] == "0") {
					divText += "<div id='Div"+temp[0]+"' class='sopContents_box'><div class='title_sub' onClick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>"+temp[1]+"</div>";
					l1ItemID = temp[0];
					l2ItemID = "";
				}
				else if(temp[2] == "1"){
					divText += "<div class='dcontainer'><p class='cur-po'><a onClick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>"+temp[1]+"("+temp[4]+")</a></p><ul id='"+temp[0]+"' class='open'>";
					l2ItemID = temp[2];
				}
				else if(temp[2] == "2"){
					divText += "<li><span></span><a onclick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>&bull;&nbsp;"+temp[1]+"("+temp[4]+")</a></li>";
				}
				
			}

			$("#sopContent1").html(divText);
			var subHeight = $("#sopContent1").height();
			var winHeight = setWindowHeight();

// 			if(subHeight > winHeight) {
// 				$(".nav_tab").attr("style","height:"+( subHeight - 200)+"px;");
// 			}
// 			else {
// 				$(".nav_tab").attr("style","height:800px;");    
// 			}
		}
    }

    function createSubItemDiv2(avg){
		divText = "";
		var divText2 = "";
    	var subList = avg.split("@");
    	var arcCode = $("#arcCode").val();
		var l0Index = 0;
		var l1Index = 0;
    	var funcName = "setSopL1";
    	
        for(var i=0; i< subList.length;i++) {
	        var temp = subList[i].split("_");

			if(i > 0 && temp[2] == "1" && l2ItemID != temp[0] && l2ItemID != ""  && l0Index < 7) {
				divText += "</ul></div>";	
			}
			if(i > 0 && temp[2] == "0" && l1ItemID != temp[0]  && l0Index < 7) {
				divText += "</ul></div></div>";
			}
			if(i > 0 && temp[2] == "1" && l2ItemID != temp[0] && l2ItemID != ""  && l0Index > 6) {
				divText2 += "</ul></div>";	
			}
			if(i > 0 && temp[2] == "0" && l1ItemID != temp[0] && l0Index > 6) {
				divText2 += "</ul></div></div>";
			}


			if(temp[2] == "0" && l0Index < 6) {
				divText += "<div id='Div"+temp[0]+"' class='sopContents_box'><div class='title_sub' onClick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>"+temp[1]+"<span>&#43;</span></div>";
				l1ItemID = temp[0];
				l2ItemID = "";
				l1Index = 0;
				l0Index++;
			}
			else if(temp[2] == "0" && l0Index > 5) {
				divText2 += "<div id='Div"+temp[0]+"' class='sopContents_box'><div class='title_sub' onClick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>"+temp[1]+"<span>&#43;</span></div>";
				l1ItemID = temp[0];
				l2ItemID = "";
				l1Index = 0;
				l0Index++;
			}
			else if(temp[2] == "1"  && l0Index < 7 && l1Index < 6){
				divText += "<div class='dcontainer'><p class='cur-po'><a onClick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>"+temp[1]+"</a></p><ul id='"+temp[0]+"'>";
				l2ItemID = temp[2];
				l1Index++;
			}
			else if(temp[2] == "1" && l0Index > 6 && l1Index < 6){
				divText2 += "<div class='dcontainer'><p class='cur-po'><a onClick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>"+temp[1]+"</a></p><ul id='"+temp[0]+"'>";
				l2ItemID = temp[2];
				l1Index++;
			}
			else if(temp[2] == "2"){
				divText += "<li><span></span><a onclick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>&bull;&nbsp;"+temp[1]+"</a></li>";
			}
			
        }

		$("#sopContent1").html(divText);
		$("#sopContent2").attr("style","width:1500px;");   
		$("#sopContent2").html(divText2); 
		var subHeight = $("#sopContent2").height();
		var winHeight = setWindowHeight();

// 		if(subHeight > winHeight) {
// 			$(".nav_tab").attr("style","height:"+( subHeight - 300)+"px;");
// 		}
// 		else {
// 			$(".nav_tab").attr("style","height:900px;");    
// 		}
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
    	ajaxPage("zHecCreateSubItemDiv.do", "itemID="+avg+"&arcCode="+avg2+"&level=1&itemClassCode=CL05003", "saveFrame");
    }
    function setSubItems(avg,avg2){

        divText = "";    	
    	$("#arcCode").val(avg2);
    	checkSubItemCnt(avg,avg2);
    	
    }

    function setSopL1(arcCode,id) {
        parent.fnRefreshPageCall(arcCode,id,"V");
    }
    
</script>


</head>

<input id="arcCode" type="hidden" value="${arcCode}"></input>
<div id="sopContainer">
<div id="sopContents">
<ul class="row">
	<li class="col-4">
		<h1>Standard Operating Procedure</h1>
 	    <div class="sec01">  <!--style="width:1450px;" -->
	    <div class="whitebar">
	    	<input id="tab1" type="radio" name="tabs" <c:if test="${defMenuItemID == '123850'}">checked</c:if>>
			<label for="tab1" onClick="setSubItems('123850','ARC2100')">플랜트</label>
			<input id="tab3" type="radio" name="tabs" <c:if test="${defMenuItemID == '125704'}">checked</c:if>>
			<label for="tab3" onClick="setSubItems('125704','ARC2200')">건축</label>
			<!--  <input id="tab4" type="radio" name="tabs" <c:if test="${defMenuItemID == '125706'}">checked</c:if>>
			<label for="tab4" onClick="setSubItems('125706','ARC2300')">인프라</label> -->
			<input id="tab5" type="radio" name="tabs" <c:if test="${defMenuItemID == '125708'}">checked</c:if>>
			<label for="tab5" onClick="setSubItems('125708','ARC2400')">자산</label>
			<input id="tab6" type="radio" name="tabs" <c:if test="${defMenuItemID == '125106'}">checked</c:if>>
			<label for="tab6" onClick="setSubItems('125106','ARC2500')">지원</label>
	    </div>
				    	<div class="nav_tab">
							
							<div id="sopContent1"> <!--  style="width:1500px;" -->
							</div>
							<div id="sopContent2" style="display:none;">
							</div>
					</div>
				</li>
			</ul>
		</div>
	</div>


<div style="display:none;"><iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe></div>