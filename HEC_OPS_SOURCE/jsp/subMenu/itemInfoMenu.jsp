<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00057" var="CM00057"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<script type="text/javascript">
	var height = 0;
	var checkOutFlag = "N";
	$(document).ready(function(){
		var topHeight = 33+$(".SubinfoTabs").height();
		height = document.body.clientHeight - topHeight;
	});
	function getHeigth(){
		var topHeight = 33+$(".SubinfoTabs").height();
		var height = document.body.clientHeight - topHeight;
		return height;
	}
	//ajax에서 페이지에 넘길 변수값들 지정
	function getData(avg, avg1, avg2){
				
		//기본 변수 BASE
		// 테이불 TB_MENU 컬럼 Varfilter 내용 추가
		var Data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&s_itemID=${id}"
				//+"&modelID=${id}"
				+"&pop=${pop}"
				+"&width="+$("#actFrame").width()
				+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
				+"&userID=${sessionScope.loginInfo.sessionUserId}"
				+"&option=${option}"
				+"&MenuID="+avg2
				+ avg
				+"&changeSetID=${changeSetID}";
		
		// 테이불 TB_MENU_ALLOC 컬럼 Varfilter 내용 추가	
		if(avg1 != ''){
			Data = Data + "&varFilter=" + avg1;		
		}
		
		/* 하위 항목 이나 검색 화면에서 본 화면을 popup으로 표시 했을때 버튼 제어를 위해 screenMode 파라메터를 넘겨줌 */
		var screenMode = "${screenMode}";
		if (screenMode == 'pop') {
			Data = Data + "&screenMode=${screenMode}";		
		}
		
		return Data;
	}
	
	function setActFrame(avg, avg2, avg3, avg4,avg5){
		$("#url").val(avg);
		$("#sort").val(avg2);
		$("#menuFilter").val(avg3);
		$("#varFilter").val(avg4);
		$("#menuID").val(avg5);
		
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		
		var url = avg+".do";
		var data = getData(avg3, avg4,avg5);
		var target = "actFrame";
		var src = url +"?" + data+"&browserType="+browserType+"&MTCategory=${MTCategory}&focusedItemID=${focusedItemID}";
		var idx = (window.location.href).lastIndexOf('/');
		$("#clickedURL").val((window.location.href).substring(0,idx)+"/"+src);
		if( avg == "newDiagramEditor"  || avg == "newDiagramViewer" || avg == "modelView_H"){
			//$("#digramFrame").attr("src", src);
			digramFrame.location.href  = src;
			$("#digramFrame").attr("style", "display:block;height:"+getHeigth()+"px;");
			$(window).resize(function (){
				$("#digramFrame").attr("style", "display:block;height:"+getHeigth()+"px;");
			});
			$("#actFrame").attr("style", "display:none;");
			$("#actFrame").addClass(".help_hidden");
			$("#tabMenu").attr("style", "display:block;");
		} else {
			$("#tabMenu").attr("style", "display:block;");
			$("#digramFrame").attr("style", "display:none;");
			$("#digramFrame").addClass(".help_hidden");
			$("#actFrame").attr("style", "display:block;height:"+height+"px;");
			$("#actFrame").attr("style", "height:"+height+"px;");
			ajaxTabPage(url, data, target);
		}
	}
	var SubinfoTabsNum = 1; /* 처음 선택된 tab메뉴 ID값*/
	$(function(){
		$("#pli"+SubinfoTabsNum).addClass('on');
		
		$('.SubinfoTabs ul li').mouseover(function(){
			$(this).addClass('on');
		}).mouseout(function(){
			if($(this).attr('id').replace('pli', '') != SubinfoTabsNum) {
				$(this).removeClass('on');
			}
			$('#tempDiv').html('SubinfoTabsNum : ' + SubinfoTabsNum);
		}).click(function(){
			$(".SubinfoTabs ul li").removeClass("on"); //Remove any "active" class
			$(this).addClass('on');
			SubinfoTabsNum = $(this).attr('id').replace('pli', '');
		});
	}); 
	
	function fnGetProjectItemID() {
		var p_itemID =  "${id}";
		
		return p_itemID;
	}
	
	function fnOpenParentItemPop(pID){// ParentItem Popup
		var itemId = pID;
		if(itemId=="" || itemId=="0"){return;}
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemId);
	}
	
	function fnItemInfoMenuReload(){
		parent.olm.getMenuUrl('${s_itemID}');
	}
	
	function fnMenuReload(){		
		var url = $("#url").val();
		var sort = $("#sort").val();
		var menuFilter = $("#menuFilter").val();
		var varFilter = $("#varFilter").val();
		var menuID = $("#menuID").val();

		setActFrame(url, sort, menuFilter, varFilter, menuID);
	}	
	
	function fnGoReportList() {
		var url = "objectReportList.do";
		var target = "actFrame";
		var data = "s_itemID=${id}&option=${option}&kbn=newItemInfo"; 
	 	
		$("#tabMenu").attr("style", "display:none;");
	 	$("#digramFrame").attr("style", "display:none;");
		$("#actFrame").attr("style", "display:block;height:"+height+"px;");
		$("#actFrame").attr("style", "height:"+height+"px;");
		ajaxPage(url, data, target);
	}
	
	function fnGoChangeMgt() {
		var url = "itemHistory.do";
		var target = "actFrame";
		var data = "s_itemID=${id}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myItem=${myItem}&itemStatus=${itemStatus}&backBtnYN=N";
		
		$("#tabMenu").attr("style", "display:none;");
	 	$("#digramFrame").attr("style", "display:none;");
		$("#actFrame").attr("style", "display:block;height:"+height+"px;");
		$("#actFrame").attr("style", "height:"+height+"px;");
		ajaxPage(url, data, target);
	}
	

	// [Check in] Click 
	function fnCheckInItem() {
		var items = "${id}";
		var cngts = "${itemInfo.curChangeSet}";
		var pjtIds = "${projectID}";
		var url = "checkInItem.do";
		var data = "items=" + items + "&cngts=" + cngts + "&pjtIds=" + pjtIds;
		var target = "blankFrame";
		ajaxPage(url, data, target);
	}
	
	function fnEditChangeSet(){
		var url = "editItemChangeInfo.do"
		var data = "?changeSetID=${itemInfo.curChangeSet}&StatusCode=${StatusCode}"
			+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&mainMenu=${mainMenu}&seletedTreeId=${s_itemID}"
			+ "&isItemInfo=Y&screenMode=edit"
			+ "&isMyTask=Y";
		window.open(url+data,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
	}
	
	function fnSubscribe(){
		if(confirm("Do you really subscibe this item?")){
			var url = "saveRoleAssignment.do";
			var data = "itemID=${s_itemID}&assignmentType=SUBSCR&accessRight=R&assigned=1&memberID=${sessionScope.loginInfo.sessionUserId}&seq=";
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnUnsubscribe(){
		if(confirm("Do you really unsubscibe this item?")){
			var url = "deleteRoleAssignment.do";
			var data = "seqArr=${myItemSeq}";
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnQuickCheckOut(){
		var projectNameList = "${projectNameList}";
		
		if(checkOutFlag == "N") {
			if(parseInt(projectNameList)>0){
				dhtmlx.confirm({
					ok: "Yes", cancel: "No",
					text: "${CM00042}",
					width: "310px",
					callback: function(result){
						if(result){
							var url = "cngCheckOutPop.do?";
							var data = "s_itemID=${s_itemID}";
						 	var target = self;
						 	var option = "width=350px, height=350px, left=200, top=100,scrollbar=yes,resizble=0";
						 	window.open(url+data, 'CheckOut', option);
						 	checkOutFlag = "Y";
						}
					}		
				});	
			}else{
				if(confirm("${CM00057}")){
					//var url = "csrDetailPop.do?isNew=Y&quickCheckOut=Y&itemID=${s_itemID}";	
					var url = "registerCSR.do?quickCheckOut=Y&itemID=${s_itemID}";
					window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizble=0');
				} 
			}			
		}
		else {
			//alert(""); --> Edit Start 진행 도중 재 클릭 하였을 시 노출 시킬 경고 메시지를 추가 할 경우 해당 주석을 제거 후 메시지 추가
		}		
	}
	
</script>

<input type="text" id="clickedURL" style="width:800px;display:none;"></input>
<input type="text" id="url"  value="" style="display:none;">
<input type="text" id="sort"  value="" style="display:none;">
<input type="text" id="menuFilter"  value="" style="display:none;">
<input type="text" id="varFilter"  value="" style="display:none;">
<input type="text" id="menuID"  value="" style="display:none;">
<input type="text" id="itemMenu" value="itemInfoMenu" style="display:none;">

<div class="floatL pdL10 pdT10 pdB5">
	<ul>
		<li>
		<c:choose>
	   		<c:when test="${itemInfo.CategoryCode eq 'MCN' || itemInfo.CategoryCode eq 'CN' || itemInfo.CategoryCode eq 'CN1' }" >
	   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.FromItemTypeImg}" OnClick="fnOpenParentItemPop('parentItemID');" style="cursor:pointer;">&nbsp;${itemInfo.FromItemName}
	   		 --> 
	   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.ToItemTypeImg}" OnClick="fnOpenParentItemPop('parentItemID');" style="cursor:pointer;">&nbsp;${itemInfo.ToItemName}
			 <c:if test="${itemInfo.ItemName ne '' && prcList.ItemName != null}">/<font color="#3333FF"><b>${itemInfo.ItemName}</b></font> </c:if>
	   		</c:when>
	   		<c:otherwise>
	   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.ItemTypeImg}" OnClick="fnOpenParentItemPop('parentItemID');" style="cursor:pointer;">
			  	<font color="#3333FF"><b>${itemInfo.Identifier}&nbsp;${itemInfo.ItemName}</b></font>&nbsp;
			  	
				<c:forEach var="path" items="${itemPath}" varStatus="status">
					<c:choose>
						<c:when test="${status.first}">
						(<span style="cursor:pointer" OnClick="fnOpenParentItemPop('${path.itemID}');" >${path.PlainText}</span>
						</c:when>
						<c:when test="${status.last}">
						>&nbsp;<span style="cursor:pointer" OnClick="fnOpenParentItemPop('${path.itemID}');" >${path.PlainText}</span>
						</c:when>
						<c:otherwise>>&nbsp;<span style="cursor:pointer" OnClick="fnOpenParentItemPop('${path.itemID}');" >${path.PlainText}</span></c:otherwise>
					</c:choose>
				</c:forEach>		  
			  	<c:if test="${itemPath != null && itemPath.size() > 0 }">)</c:if>	
			  					  	
	   		</c:otherwise>
	   	</c:choose>
		&nbsp;
			<c:choose>
		   		<c:when test="${subscrOption eq '1' && myItem ne 'Y' && myItemCNT eq '0' && quickCheckOut ne 'Y'}"  >
        			 <span class="btn_pack small icon"><span class="subscribe"></span><input value="Subscribe" type="button" onclick="fnSubscribe()"></span>
		   		</c:when>
		   		<c:when test="${myItem ne 'Y' && myItemCNT ne '0' && quickCheckOut ne 'Y' }"  >
        			 <span class="btn_pack small icon"><span class="unsubscribe"></span><input value="Unsubscribe" type="button" onclick="fnUnsubscribe()"></span>
		   		</c:when>
	   		</c:choose>			   		
		        <span class="btn_pack small icon"><span class="report"></span><input value="Report" type="button" onclick="fnGoReportList()"></span>
	        <c:if test="${menuDisplayMap.ChangeMgt eq '1'}">
		  		 <span class="btn_pack small icon"><span class="cs"></span><input value="History" type="button" onclick="fnGoChangeMgt()"></span>
		  	</c:if>
		  	<c:if test="${srType eq 'ISP'}" >
		  		<span class="btn_pack small icon"><span class="isp"></span><input value="Q&A" type="button" onclick="fnChangeOpinion()"></span>
		  	</c:if>
	   		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' and quickCheckOut eq 'Y' and itemInfo.Status eq 'REL' && checkOutOption ne '02'}" >
   				<span class="btn_pack small icon"><span class="checkout"></span><input value="Check Out" type="button" onclick="fnQuickCheckOut()"></span>
	   		</c:if>	   		
		   	<c:if test="${menuDisplayMap.ChangeMgt eq '1' && itemInfo.Blocked ne '2' && (sessionScope.loginInfo.sessionUserId eq itemInfo.AuthorID || sessionScope.loginInfo.sessionAuthLev eq '1') && (itemInfo.Status eq 'NEW1' || itemInfo.Status eq 'MOD1' || itemInfo.Status eq 'DEL1') && checkInOption ne '03A' && checkOutOption ne '02'}" >
	   			<span class="btn_pack small icon"><span class="checkin"></span><input value="Check In" type="button" onclick="fnEditChangeSet()"></span>
	   		</c:if>
		  	<c:if test="${menuDisplayMap.ChangeMgt eq '1' && itemInfo.Blocked ne '2' && (sessionScope.loginInfo.sessionUserId eq itemInfo.AuthorID || sessionScope.loginInfo.sessionAuthLev eq '1') && (itemInfo.Status eq 'NEW1' || itemInfo.Status eq 'MOD1' || itemInfo.Status eq 'DEL1') && checkInOption eq '03A' && checkOutOption ne '02'}" >
		   		<span class="btn_pack small icon"><span class="checkin"></span><input value="Complete" type="button" onclick="fnCheckInItem()"></span>
	   		</c:if>
	   		<c:if test="${menuDisplayMap.ChangeMgt eq '1' && myItem eq 'Y' && checkOutOption eq '02'}" >
	   			<span class="btn_pack small icon"><span class="checkin"></span><input value="Commit" type="button" onclick="fnCommitItem()"></span>
	   		</c:if>
	   		<span class="btn_pack medium icon"><span class="reload"></span><input value="Reload" type="button" onclick="fnMenuReload()"></span>
	   	
	   	</li>
	</ul>
</div>

<div style="display:inline-block;" class="floatR pdR20 pdT10 pdB20">
	<ul>
	   	<li class="floatR mgB20" id="memberPhotoArea" style="font-family:arial;cursor:pointer;">
		   	<c:if test="${empPhotoItemDisPlay ne 'N' && roleAssignMemberList.size() > 0 }" >
		  		<c:forEach var="author" items="${roleAssignMemberList}" varStatus="status">
				 <span id="authorInfo${status.index}" name="authorInfo${status.index}" ><img src="${author.Photo}" width="26" height="24" OnClick="fnGetAuthorInfo('${author.MemberID}');"></span>
				</c:forEach>
			</c:if>
		</li> 
	</ul>
</div> 
<div style="width:100%;height:40px;" ></div>
<div id="tabMenu" class="SubinfoTabs">
	<ul>
		<c:set value="1" var="tabNum" />
		<c:forEach var="i" items="${getList}" varStatus="status" >
				<li id="pli${tabNum}" onclick="setActFrame('${i.URL}', ${i.Sort}, '${i.MenuFilter}', '${i.VarFilter}', '${i.MenuID}') "><a><span>${i.Name}</span></a></li>
		<c:set var="tabNum" value="${tabNum+1}"/>
		</c:forEach>
	</ul>
</div>
<div id="actFrame" style="width:100%;overflow:auto; overflow-x:hidden; padding:0 0 17px 0;">
</div>
<iframe width="100%" frameborder="0" scrolling="no"  style="display:none;border: 0;overflow:auto; padding:0 0 17px 0;" name="digramFrame" id="digramFrame"></iframe>
<form style="border: 0" name="subFrame" id="subFrame"></form>
<c:forEach var="i" items="${getList}" varStatus="status" >
	<c:if test="${status.count == '1' }" >
		<script>
		setActFrame('<c:out value="${i.URL}" />', <c:out value="${i.Sort}" />, '<c:out value="${i.MenuFilter}" />', '<c:out value="${i.VarFilter}" />', '<c:out value="${i.MenuID}" />');
		</script>	
	</c:if>
</c:forEach>

<div id="blankDiv"></div>
