
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!DOCTYPE html>
<html>
<head>
<!-- meta block -->
<title>Basic initialization - DHTMLX Grid</title>
<meta name="description" content="Check interactive samples of DHTMLX Grid to explore its initialization and other details.">
<!-- 2025-03-26 소스 취약점 -->
<meta http-equiv="Content-Security-Policy" content="script-src 'self' 'sha256-0lrhsqqzoeiSmJAAXjKhQAnMB+uJl00lJt1tPHDqnzE=';"/>

<!-- end meta block -->
<meta name="viewport" content="width=device-width, initial-scale=1.0" charset="utf-8">
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">

	function fnClickedCategory(clickID, sqlID){

		$("#TOT").attr("style", "color: #000000;cursor: pointer;font-size:14px;");
		$("#ITM").attr("style", "color: #000000;cursor: pointer;font-size:14px;");
		$("#MDL").attr("style", "color: #000000;cursor: pointer;font-size:14px;");
		$("#FILE").attr("style", "color: #000000;cursor: pointer;font-size:14px;");
		
		if($("#"+clickID).val() == "Y"){
			$("#"+clickID).attr("style", "color: #000000;cursor: pointer;font-size:14px;");
			$("#"+clickID).val("N");
		}else{
			$("#"+clickID).attr("style", "color: #03c75a;cursor: pointer;font-size:14px;"); // #03c75a
			$("#"+clickID).val("Y");
		}
		$("#sqlID").val(sqlID);
		doSearchList();
	}
	
</script>	
</head>
<body>
	<div class="pdL10 pdR10 pdT10" style="background:#fff;height:100%;">
	<input type="hidden" id="sqlID" name="sqlID" value="getTotalSearchList">
		<div class="child_search" >
			<li class="shortcut"><h3><img src="${root}${HTML_IMG_DIR}/icon_search_title.png">&nbsp;&nbsp;통합&nbsp;${menu.LN00047}</h3></li>
		</div>
	  	<div class="countList pdB10" style="border-bottom:1px solid #ccc">
	    	
	    	<li class="pdL20" style="float:left;">
	    		<input type="text" class="text"  id="searchValue" name="searchValue" value="${searchValue}" style="width:250px;">
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList()" value="검색">
	    	</li>
	    	<li class="floatR pdR20">
				<!-- <span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span> -->
			</li>	
    	</div>
    	<div class="countList pdB10">
    		<li class="count floatL">
	    		Total  <span id="TOT_CNT" class=mgR30 ></span>
	    	</li>
	    	<li>
	    		<span id="TOT" class="TOT" onClick="fnClickedCategory('TOT', 'getTotalSearchList');" style="cursor: pointer;font-size:14px;" >통합</span>&nbsp;&nbsp;&nbsp;
	    		<span id="ITM" class="ITM" onClick="fnClickedCategory('ITM', 'getItemSearchList');" style="cursor: pointer;font-size:14px;" >Item</span>&nbsp;&nbsp;&nbsp;
	    		<span id="MDL" class="MDL" onClick="fnClickedCategory('MDL', 'getModelSearchList');" style="cursor: pointer;font-size:14px;" >Model</span>&nbsp;&nbsp;&nbsp;
	    		<span id="FILE" class="FILE" onClick="fnClickedCategory('FILE', 'getFileSearchList');" style="cursor: pointer;font-size:14px;" >File</span>&nbsp;&nbsp;&nbsp;
	    	</li>
    	</div>
    	<div id="gridDiv" class="mgB10 clear">
		<div id="list" style="width: 100%; height:500px;"></div>
		</div>		
		<div id="pagination" style="padding: 20px 0px 0;"></div>
</div>
		
<script>

	$(document).ready(function() {
		$("#TOT").attr("style", "color: #03c75a;cursor: pointer;font-size:14px;");
	});
	
	const list = new dhx.List("list", {
	    css: "dhx_widget--bordered", 
	    template: template,
	    itemHeight: 72,
	});
	
	const pagination = new dhx.Pagination("pagination", {
	    css: "dhx_widget--bordered",
	    data: list.data
	});
	
	function doSearchList(){
		ajaxListLoadV7();
	}
	
	function ajaxListLoadV7(debug, noMsg, msg, callback) {
		var searchValue = $("#searchValue").val();
		var sqlID = $("#sqlID").val();
		if(searchValue == ""){
			alert("검색어를 입력하세요."); return;
		}
		var url = "getTotalSearchList.do";
		var data = "searchValue="+$("#searchValue").val()+"&sqlID="+sqlID;
		$.ajax({
			url: url,type: 'post',data: data
			,error: function(xhr, status, error) {('#loading').fadeOut(150);var errUrl = "errorPage.do";var errMsg = "status::"+status+"///error::"+error;var callback = "";var width = "300px";var height = "300px";var callBack = function(){};fnOpenLayerPopup(errUrl,errMsg,callBack,width,height);}
			,beforeSend: function(x) {$('#loading').fadeIn();if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	}
			,success: function(result){
				$('#loading').fadeOut(3000);if(debug){alert(result);}	if(result == 'error' || result == ""){if(noMsg != 'Y'){alert(msg);}
				}else{					
					result = JSON.parse(result);
					$("#TOT_CNT").html(result.length);
					fnListDataLoad(result);
				}
				if(callback== null || callback==""){}
				else if (typeof callback === "function") {
			        callback(); 
			    }
			}
		});
	}

	function fnListDataLoad(dataset){
		list.data.parse(dataset);
	} 

	function template(item) {
		var searchValue = $("#searchValue").val();
	    let template = "<div class='list_item'>";
	        template += "<div onClick=fnOnRowSelect('"+item.ID+"','"+item.ItemID+"','"+item.Category+"','"+item.AuthorID+"','"+item.LockOwner+"','"+item.ItemBlocked+"','"+item.MTCategory+"','"+item.ModelBlocked+"','"+item.IsPublic+"') class='item_name'>" + item.Name + "</div>";
	        template += "</div>";
	        
	        template = template.replace(searchValue, "<span style='font-weight:bold'>"+searchValue+"</span>");
	    return template;
	};
	
	function fnOnRowSelect(ID, itemID,  category, authorID, lockOwner, itemBlocked, MTCategory, modelBlocked, IsPublic){
		console.log("itemID :"+ID+", Category :"+category+", authorID:"+authorID+", lockOwner:"+lockOwner+", itemBlocked:"+itemBlocked+", MTCategory:"+MTCategory+", modelBlocked:"+modelBlocked+", IsPublic:"+IsPublic);
		if(category == "Item"){
			fnItemDetail(ID);
		}else if(category == "Model"){
			fnModelDetail(ID, itemID, authorID, lockOwner, itemBlocked, MTCategory, modelBlocked, IsPublic);
		}else if(category == "File"){
			fnFileDetail(ID)
		}
	}
	
	function fnItemDetail(itemID){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemID);
	}
	
	function fnModelDetail(modelID, itemID, authorID, lockOwner, itemBlocked, MTCategory, modelBlocked, IsPublic){
		var scrnType = "";
		var sessionUerID = "${sessionScope.loginInfo.sessionUserId}";
		var sessionAuthLev = "${sessionScope.loginInfo.sessionAuthLev}";
		var myItem = "";
		if(sessionUerID == authorID || sessionUerID == lockOwner || sessionAuthLev == "1"){
			myItem = "Y";
		}
		
		if(MTCategory == "VER" || itemBlocked != "0"){// 카테고리가 vsersion 이면 model viewr open		
			   scrnType =  "view";
		}else{	
			if(IsPublic == 1){
				scrnType = "edit"; 			
			} else{
				if(modelBlocked == "0" && myItem == 'Y' ){
					scrnType = "edit";
				} else{
					scrnType = "view";
				}
			}
		}

		var url = "popupMasterMdlEdt.do?"
			+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&s_itemID="+itemID
			+"&modelID="+modelID
			+"&scrnType="+scrnType
			+"&MTCategory="+MTCategory;
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnFileDetail(fileID ){
		var isNew = "N";					
		var url  = "documentDetail.do?isNew"+isNew
				+"&seq="+fileID;
		var w = 1200;
		var h = 500;
		itmInfoPopup(url,w,h); 
	}
	
</script>
</body>
</html>
