<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<style>
.dhx_dataview {
    background-color: transparent;
}
.dhx_dataview-item {
    background-color: #fff;
    overflow: hidden;
    padding : 0;
}
.item_wrap {
	padding: 8px;
}
.dhx_widget{
	color: rgba(0, 0, 0, 0.9);
}
.btnControl:before {
	content: "";
    position: absolute;
    z-index: -1;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: #2098D1;
    border-radius: 3px;
    -webkit-transform: scaleX(0);
    transform: scaleX(0);
    -webkit-transform-origin: 0 50%;
    transform-origin: 0 50%;
    -webkit-transition-property: transform;
    transition-property: transform;
    -webkit-transition-duration: 0.3s;
    transition-duration: 0.2s;
    -webkit-transition-timing-function: ease-out;
    transition-timing-function: ease-out;
}
.btnControl {
	width: 35%;
	max-width: 125px;
    padding: 5px 10px;
    border: none;
    color: #fff;
    background: #dfdfdf;
    border-radius: 3px;
    -webkit-transform: perspective(1px) translateZ(0);
    transform: perspective(1px) translateZ(0);
}

.btnControl:hover:before {
    -webkit-transform: scaleX(1);
    transform: scaleX(1);
}
.itemName:hover {
	text-decoration: underline;
	color: #2098D1;
}
.subTitle {
	color: rgba(0, 0, 0, 0.5);
	width:60px;
	display:inline-block;
}
</style>

<script>
	var userId = "${sessionScope.loginInfo.sessionUserId}";
	var itemAthId = "${selectedItemAuthorID}";
	
	$(document).ready(function(){
		var data = "languageID=sessionScope.loginInfo.sessionCurrLangType&category=MC";
		fnSelect('category',data,'getDictionary','','Select');
		$("#dataView").css("height",setWindowHeight() - 220 + "px");
		window.onresize = function() {
			$("#dataView").css("height",setWindowHeight() - 220 + "px");
		};
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
</script>
<form name="mdListFrm" id="mdListFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="ItemTypeCode" name="ItemTypeCode" value="${ItemTypeCode}" >
 	<div class="title-section flex align-center justify-between bordered-bottom">
   		<span class="flex align-center">
   			<span class="back"><span class="icon arrow"></span></span>
   			<span id="title">Occurrence list (${occDataSize})</span>
   		</span>
	</div>
	<div class="child_search01 mgB20 mgT10">
		<li>	
			<section class="dhx_sample-controls">
			  <label for="name" class="dhx_sample-label">${menu.LN00367 }</label>
			  <input type="text" id="name" class="dhx_sample-input mgR10">
			  <label for="name" class="dhx_sample-label">${menu.LN00033 }</label>
			  <select class="dhx_select dhx_sample-input" id="category" style="width:177px;"></select>
			</section>	
		</li>
    </div>
	<div id="dataView" style="background: #f7f7f7;"></div>
</form>
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>	
	
	<script>
	var back = document.getElementsByClassName("back");
	back[0].addEventListener("click", fnBack);

	var dataset = '${occData}';
	function template(item) {
		var description = item.Description? item.Description : "-";
		let template = "<div class='item_wrap flex'>";
		template += '<div style="margin: 15px;width: 70%;height:170px;overflow:hidden;"><img src="/diagram/' + item.ModelID + "_" + "${sessionScope.loginInfo.sessionCurrLangCode}" + "." + "<%=GlobalVal.MODELING_DIGM_IMG_TYPE%>"+'" style="width: 100%;"></div>';
		template += "<div style='width: 100%;margin: 15px;'><div style='display:flex;align-items: center;justify-content: space-between;'><h3 style='margin-bottom:4px;'>" + item.Name + "("+ item.MTCName  + ")</h3></div>";
		template += "<p style='margin: 6px 0'><span class='subTitle'>${menu.LN00032}</span>" + item.ModelTypeName + "</p>";
		template += "<p style='margin: 6px 0' class='flex'><span class='subTitle'>${menu.LN00087}</span><span class='itemName'>" + item.ItemName + "(" + item.StatusName + ")</span></p>";
		template += "<p style='margin: 6px 0'><span class='subTitle'>${menu.LN00070}</span>" + item.LastUpdated + "</p>";
		template += "<p style='margin: 6px 0'><span class='subTitle'>${menu.LN01007}</span>" + item.UserName + "</p>";
		template += "<p style='margin-top: 20px;'><button class='btnControl open mgR10'>OPEN</button><button class='btnControl properties'>Properties</button></p>";
		template += "</div></div>";
		return template;
	}

	var dataview = new dhx.DataView("dataView", {
		itemsInRow: 3,
		gap: 20,
		template: template,
		data: dataset,
		eventHandlers: {
	        onclick: {
	        	"itemName": function (e, id) {
	        		var itemId = dataview.data.getItem(id).ItemID;
	    			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop";
					var w = 1200;
					var h = 900;
					itmInfoPopup(url,w,h,itemId);
	            },
	            "open": function (e, id) {
	        		var selectedCell = dataview.data.getItem(id);
	        		var MTCategory = selectedCell.MTCategory;
	        		var blocked = selectedCell.ItemBlocked;
	        		var ModelIsPublic = selectedCell.IsPublic;
	        		var modelBlocked =selectedCell.Blocked;
	        		var itemId =selectedCell.ItemID;
	        		var modelId =selectedCell.ModelID;
	        		var modelName =selectedCell.ItemName;
	        		var ModelTypeName =selectedCell.ModelTypeName;
	        		var menuUrl =selectedCell.URL;
	        		var changeSetID =selectedCell.ChangeSetID;
	        		var scrnType = "view";
	        		var myItem = "${myItem}";
	        		
// 	        		if(MTCategory == "VER" || blocked != "0"){// 카테고리가 vsersion 이면 model viewr open		
// 	        			   scrnType =  "view";
// 	        			}else{	
// 	        				if(ModelIsPublic == 1){
// 	        					scrnType = "edit";					
// 	        				} else{
// 	        					if((itemAthId == userId || "${sessionScope.loginInfo.sessionUserId}" == userId) && modelBlocked == "0" && myItem == 'Y' ){
// 	        						scrnType = "edit";	
// 	        					} else{
// 	        						scrnType = "view";
// 	        					}
// 	        				}
// 	        			}
	        			var url = "popupMasterMdlEdt.do?"
	        					+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
	        					+"&s_itemID="+itemId
	        					+"&modelID="+modelId
	        					+"&scrnType="+scrnType
	        					+"&MTCategory="+MTCategory
	        					+"&modelName="+encodeURIComponent(modelName)
	        				    +"&modelTypeName="+encodeURIComponent(ModelTypeName)
	        					+"&menuUrl="+menuUrl
	        					+"&selectedTreeID=${s_itemID}"
	        					+"&changeSetID="+changeSetID
	        					+"&focusedItemID=${s_itemID}";
	        				
	        			
	        			var w = 1200;
	        			var h = 900;
	        			window.open(url, "_blank");
	            },
	            "properties": function (e, id) {
	            	var selectedCell = dataview.data.getItem(id);
	            	var itemId =selectedCell.ItemID;
	        		var modelId =selectedCell.ModelID;
	        		var blocked = selectedCell.ItemBlocked;
	        		var ItemTypeCode = $("#ItemTypeCode").val();
	        		
	            	var url = "modelInfoMain.do?filter=${filter}"
						+"&s_itemID="+itemId
						+"&modelID="+modelId
						+"&itemAthId="+itemAthId
						+"&blocked="+blocked
						+"&screenType=modelBasicInfoPop"
						+"&ItemTypeCode="+ItemTypeCode;
	
				var w = 1200;
				var h = 900;
				window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	            }
	        }
	    }
	});	
	
	document.querySelector("#name").addEventListener("keyup", filter);
	document.querySelector("#category").addEventListener("change", filter);

	function filter() {
        var name = document.getElementById("name").value;
        var category = document.getElementById("category").value;
		if (name || category) {
			dataview.data.filter(function (item) {
		        return item.ItemName.includes(name) && item.MTCategory.includes(category);
		    });
		} else {
			dataview.data.filter();
		}
	}
		
	function fnBack() {
		var url = "NewItemInfoMain.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
	 	ajaxPage(url, data, target);
	}
</script>