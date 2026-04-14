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
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/subMain.css"/>

<script type="text/javascript">
    var divText = "";
    var l1ItemID = "";
    var l2ItemID = "";
    
    $(document).ready(function(){
   		var defMenuItemID = "${defMenuItemID}";
   		
   		if(defMenuItemID != "") {
   			setSubItems(defMenuItemID,"${arcCode}");
   		}
   		
   		$(".sec01").attr("style","height:"+(setWindowHeight() - 45)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$(".sec01").attr("style","height:"+(setWindowHeight() - 40)+"px;");
		};
		
		$(".nav_tab").attr("style","height:"+(setWindowHeight()  -117)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$(".nav_tab").attr("style","height:"+(setWindowHeight()  -117)+"px;");
		};
    });
    function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
    function createSubItemDiv(avg){
    	var subList = avg.split("@");
    	var arcCode = $("#arcCode").val();
		var funcName = "setProcessL1";
    	       
		if(arcCode != "ARC1400") {
			arcCode = "ARC1100";
		}
		else {
			funcName = "setProcessL1NoMulti";
		}

        for(var i=0; i< subList.length;i++) {
	        var temp = subList[i].split("_");

			if(i > 0 && temp[2] == "1" && l2ItemID != temp[0] && l2ItemID != "") {
				divText += "</ul></div>";	
			}
			if(i > 0 && temp[2] == "0" && l1ItemID != temp[0]) {
				divText += "</ul></div></div>";
			}

			if(temp[2] == "0") {
				divText += "<div id='Div"+temp[0]+"' class='pContents_box'><div class='title_sub' onClick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>"+temp[1]+"</div>";
				l1ItemID = temp[0];
				l2ItemID = "";
			}
			else if(temp[2] == "1"){
				divText += "<div class='dcontainer'><p><a onClick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>"+temp[1]+"</a></p><ul>";
				l2ItemID = temp[2];
			}
			else if(temp[2] == "2"){
				divText += "<li><span></span><a onclick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>&bull;&nbsp;"+temp[1]+"</a></li>";
			}
			
        }

    	$("#pContent1").html(divText);
    	var subHeight = $("#pContent1").height();
    	var winHeight = setWindowHeight();

//     	if(subHeight > winHeight) {
// 			$(".nav_tab").attr("style","height:"+( subHeight + 50)+"px;margin-bottom: 50px;");
//     	}
//     	else {
// 			$(".nav_tab1").attr("style","margin-bottom: 50px;");    		
//     	}
		
    }
    
    function checkSubItemCnt(avg,avg2) {
    	ajaxPage("zHecCreateSubItemDiv.do", "itemID="+avg+"&arcCode="+avg2+"&level=3", "saveFrame");
    }
    function setSubItems(avg,avg2){
        divText = "";    	
    	checkSubItemCnt(avg,avg2);
    	$("#arcCode").val(avg2);
    	
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
    
    function setProcessL1(arcCode,id) {

        parent.fnRefreshPageMulti(arcCode,id);
    }

    function setProcessL1NoMulti(arcCode,id) {

        parent.fnRefreshPage(arcCode,id);
    }
    
    
</script>

</head>

<BODY style="overflow:auto;">
<input id="arcCode" type="hidden" value="${arcCode}"></input>
<div id="pContainer">
<div id="pContents">
<ul class="row">
	<li class="col-4">
		<h1>Process</h1>
	    <div class="sec01"><!--style="width:1430px;" -->
	    <div class="whitebar">
			<input id="tab1" type="radio" name="tabs" <c:if test="${defMenuItemID == '101057'}">checked</c:if> >
			<label for="tab1" onClick="setSubItems('101057','ARC1110')">플랜트</label>
			<input id="tab2" type="radio" name="tabs" <c:if test="${defMenuItemID == '101059'}">checked</c:if>>
			<label for="tab2" onClick="setSubItems('101059','ARC1120')">건축</label>
			<input id="tab3" type="radio" name="tabs" <c:if test="${defMenuItemID == '101061'}">checked</c:if>>
			<label for="tab3" onClick="setSubItems('101061','ARC1130')">인프라</label>
			<input id="tab6" type="radio" name="tabs" <c:if test="${defMenuItemID == '101063'}">checked</c:if>>
			<label for="tab6" onClick="setSubItems('101063','ARC1400')">경영지원</label>
		</div>
				    	<div class="nav_tab">
							<div id="pContent1"><!--  style="width:1500px;" -->
							</div>
					</div>
				</li>
			</ul>
		</div>
	</div>


<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</BODY>