<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root" />

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/cmm/common/css/siteMap.css" />
<script type="text/javascript">
	
</script>

<!-- 화면 표시 메세지 취득  -->
<%-- <spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/> --%>
<script type="text/javascript">
	$(document).ready(function() {
		
	});
</script>


<form name="frontFrm" id="frontFrm" action="#" method="post"
	onsubmit="return false;">
	<div class="mgB10">
		<div class="sec01">
			<div class="nav_tab">
				<div class="siteMapContent">
					<c:choose>
						<c:when test="${templCode == ''}">
							<div id="slidemenu01" class="slidemenu" style="display: block"></div>
						</c:when>
						<c:otherwise>
							<c:forEach var="templ" items="${templList}" varStatus="status">
								<%-- <div class="siteMapContents_box">
									<div class="siteMapContainer">
										<p>
											<a onclick="parent.changeTempl('${templ.TemplCode}','${templ.TemplText}','${templ.MainURL}','${templ.MainScnText}','${templ.URLFilter}','${templ.TmplFilter}','','${templ.TmplType}');" href="#">
												Home
											</a>
											<script type="text/javascript">isTempLoad['${templ.TemplCode}']=false;</script>
										</p>
									</div>
								</div> --%>
								<c:forEach var="mainMenu" items="${mainMenuList}" varStatus="status">
									<c:if test="${templ.TemplCode == mainMenu.TemplCode}">
										<div class="siteMapContents_box">
											<div class="siteMapContainer">
												<c:choose>
													<c:when test="${mainMenu.CHILD_MENT_CNT > 0}">
														<p>
															<a href="#" alt="${mainMenu.MENU_NM}" class="topmenu"
																id="${mainMenu.MENU_NM}"> <c:if
																	test="${mainMenu.ICON != ''}">
																	<%-- <img class="menuicon"
																		src="${root}${HTML_IMG_DIR_ARC}/${mainMenu.ICON}"></img> --%>
																</c:if> ${mainMenu.MENU_NM}
															</a>
														</p>
														<c:forEach var="scnMenu" items="${scnMenuList}" varStatus="status">
															<c:if test="${mainMenu.MENU_ID == scnMenu.PRNT_MENU_ID}">
																<c:if test="${scnMenu.DimTypeID != '0'}">
																	<p class="mgl20">
																		<a href="#" alt="${scnMenu.MENU_NM}">${scnMenu.MENU_NM}</a>
																	</p>
																	
																	<c:forEach var="thdMenu" items="${thdMenuList}" varStatus="status">
																		<c:if
																			test="${scnMenu.MENU_ID == thdMenu.PRNT_MENU_ID}">
																			<p class="mgl40">
																				<a onclick="parent.clickMainMenu('${thdMenu.PRNT_MENU_ID}','${mainMenu.MENU_NM}','${mainMenu.ICON}', '${thdMenu.DefDimValueID}','${mainMenu.STYLE}','${scnMenu.STYLE}','${thdMenu.URL}.do?${thdMenu.FILTER}')"
																					href="#" alt="${thdMenu.MENU_NM}">${thdMenu.MENU_NM}</a>
																			</p>
																		</c:if>
																	</c:forEach>
																	
																</c:if>
																<c:if test="${scnMenu.DimTypeID == '0'}">
																	<p class="mgl20">
																		<a onclick="parent.clickMainMenu('${scnMenu.MENU_ID}','${mainMenu.MENU_NM}&nbsp;::&nbsp;${scnMenu.MENU_NM}','${mainMenu.ICON}','','${mainMenu.STYLE}','${scnMenu.STYLE}','${scnMenu.URL}.do?${scnMenu.FILTER}')"
																			href="#" alt="${scnMenu.MENU_NM}">${scnMenu.MENU_NM}</a>
																	</p>
																</c:if>
															</c:if>
														</c:forEach>
													</c:when>
													<c:otherwise>
														<p>
															<a onclick="parent.clickMainMenu('${mainMenu.MENU_ID}','${mainMenu.MENU_NM}','${mainMenu.ICON}','','${mainMenu.STYLE}','','${mainMenu.URL}.do?${mainMenu.FILTER}')"
																href="#" alt="${mainMenu.MENU_NM}" class="topmenu" id="${mainMenu.MENU_NM}">
																<c:if test="${mainMenu.ICON != ''}">
																	<%-- <img class="menuicon" src="${root}${HTML_IMG_DIR_ARC}/${mainMenu.ICON}"></img> --%>
																</c:if>
																${mainMenu.MENU_NM}</a>
														</p>
													</c:otherwise>
												</c:choose>
											</div>
										</div>
									</c:if>
								</c:forEach>
							</c:forEach>
						</c:otherwise>
					</c:choose>
					<div class="siteMapContents_box">
						<div class="siteMapContainer">
							<c:forEach var="topMenu" items="${topMenuList}" varStatus="status">
								<p>
									<a onclick="parent.clickMainMenu('${topMenu.MenuID}','${topMenu.Name}','','','','','${topMenu.URL}.do?${topMenu.FILTER}')"
									href="#">
										 <%-- <img class="topIconImg" alt="img${topMenu.MenuID}" src="${root}${HTML_IMG_DIR_SHORTCUT}${topMenu.Icon}"></img> --%>
										${topMenu.Name}
									</a>
								</p>
							</c:forEach>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>