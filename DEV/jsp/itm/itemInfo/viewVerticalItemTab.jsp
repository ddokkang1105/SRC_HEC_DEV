<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ page import="xbolt.cmm.framework.val.GlobalVal"%>  
 <%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 
<!DOCTYPE html>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<head>
	<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>
	<style>
		.iteminfo-wrapper {
		    height: 100%;
		}
		.item-contents {
			overflow: auto;
		}
	</style>
</head>
<body>
	<div class="item-header pdL10 pdT10 pdB10 pdR10">
		<div class="flex justify-between btn-wrap">
			<div class="align-center flex">
			<c:if test="${showPreNextIcon eq 'Y'}" >
			<div id="openItemsli" style="font-family:arial;" class="floatL">
				<span id="preAbl" name="preAbl"><img style="cursor:auto;" src="${root}cmm/common/images/icon_back_btn.png" width="26" height="24" OnClick="fnGoBackItem();"></span>
				<span id="preDis" name="preDis" disabled=true><img style="cursor:auto;" src="${root}cmm/common/images/icon_back_btn_.png" width="26" height="24"></span>
				<input type="hidden" id="openItemName" name="openItemName" size="8">	
				<input type="hidden" id="openItemID" name="openItemID" size="8">		
				<span id="nextAbl" name="nextAbl" ><img style="cursor:auto;" src="${root}cmm/common/images/icon_next_btn.png"  width="26" height="24" OnClick="fnGoNextItem();"></span>	
				<span id="nextDis" name="nextDis"><img style="cursor:auto;" src="${root}cmm/common/images//icon_next_btn_.png"  width="26" height="24"></span>	
			</div>
			</c:if>
			<div id="itemNameAndPath">
			<c:choose>
		   		<c:when test="${itemInfo.CategoryCode eq 'MCN' || itemInfo.CategoryCode eq 'CN' || itemInfo.CategoryCode eq 'CN1' }" >
		   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.FromItemTypeImg}" OnClick="fnOpenParentItemPop('${itemInfo.CxnFromItemID}');" style="cursor:pointer;vertical-align: text-top !important;">&nbsp;${itemInfo.FromItemName}
		   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.ToItemTypeImg}" OnClick="fnOpenParentItemPop('${itemInfo.CxnToItemID}');" style="cursor:pointer;vertical-align: text-top !important;">&nbsp;${itemInfo.ToItemName}
				 <c:if test="${itemInfo.ItemName ne '' && prcList.ItemName != null}">/<font color="#3333FF"><b>${itemInfo.ItemName}</b></font> </c:if>
		   		</c:when>
		   		<c:otherwise>
		   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.ItemTypeImg}" OnClick="fnOpenParentItemPop('${parentItemID}');" style="cursor:pointer;vertical-align: text-top !important;">
				  	<b style="font-size:13px;">${itemInfo.Identifier}&nbsp;${itemInfo.ItemName}</b>				  		   	
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
		   	</div>
		   	</div>
		 </div>
		 <div class="flex align-center mgT5">
			 <span class="mgR10 status">${itemInfo.StatusName}</span>
			 <span class="mgR5">${menu.LN00004}</span><span class="align-center flex link mgR10" id="authorInfo">${itemInfo.Name}</span>
			 <span class="mgR5">${menu.LN00018}</span><span class="mgR10 link" onclick="fnOpenTeamInfoMain(${itemInfo.OwnerTeamID})">${itemInfo.OwnerTeamName}</span>
			 <span class="align-center flex mgR10">Last Updated. ${itemInfo.LastUpdated}</span>
			 <span class="align-center flex mgR10">Created On. ${itemInfo.LastUpdated}</span>
		 </div>
	</div>
	
	<div style="height:calc(100% - 76px); overflow: auto;" class="pdL20 pdR20">
		<c:set value="1" var="tabNum" />
		<c:forEach var="i" items="${getList}" varStatus="status" >
			<h1>${i.Name}</h1>
			<div id="menu-${tabNum}" class="mgB30"></div>
			<script>					
					var languageID = "${languageID}";
					if(languageID == ""){
						languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
					}		
				
					var data = "languageID="+languageID
					+"&s_itemID=${id}"
					+"&pop=${pop}"
					+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
					+"&userID=${sessionScope.loginInfo.sessionUserId}"
					+"&option=${option}"
					+"&MenuID="+"${i.VarFilter}"
					+ "${i.MenuFilter}" + "&fromModelYN=${fromModelYN}"
					+"&changeSetID=${changeSetID}"
					+"&showTOJ=${showTOJ}"
					+"&tLink=${tLink}"
					+"&accMode=${accMode}"
					+"&loadEdit=${loadEdit}"
					+"&showLink=${showLink}"
					+"&myCSR=${myCSR}"
					+"&csrIDs=${csrIDs}"
					+"&udfSTR=${udfSTR}"
					+"&focusedObjID=${focusedObjID}";
					
					
					if("${i.URL}" == "newDiagramViewer") {
						var src = "${i.URL}.do?" + data;
						// div 내부에 iframe 생성
						const container = document.getElementById("menu-${tabNum}");
						const iframe = document.createElement("iframe");
						iframe.id = "model";
						iframe.name = "model";
						  iframe.width = "100%";
						  iframe.frameborder = "0";
						  iframe.scrolling = "no";

						  container.appendChild(iframe);
						  
						  document.getElementById('model').contentWindow.location.href= src; // firefox 호환성  location.href에서 변경
							$("#model").attr("style", "display:block;height:600px;border: 0;");
					} else {
						ajaxPage('${i.URL}.do', data, "menu-${tabNum}");
					}

				</script>
		<c:set var="tabNum" value="${tabNum+1}"/>
		</c:forEach>
		
	</div>
</body>
</html>
	