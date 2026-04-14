<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<c:url value="/" var="root" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- 1. Include JSP -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

<script>
	let selectedIndex = 1;
	window.addEventListener('load', function(){
		if("${arcDefPage}" !== "") {
			setPage(0, "${arcDefPage}")
		} else {
			if("${selectedIndex}") selectedIndex = "${selectedIndex}";
			document.querySelector(".menu[data-index='"+selectedIndex+"']").click();
		}
	
		if("${arcInfo}" !== "") fnSetButton("side-btn", "", "");
		
		const menuTitles = document.querySelectorAll('.menu');
		if (menuTitles) {
			menuTitles.forEach(menuTitle => {
				menuTitle.addEventListener('click', () => {
					const submenu = menuTitle.nextElementSibling;
					menuTitle.classList.toggle('closed');
					
					if (submenu && submenu.classList.contains('menu-2-wrapper')) {
						submenu.classList.toggle('closed');
					}
				});
			});
		}
	});

	function setPage(index, targetUrl) {
		let url, data, arcCode = "";
		if(index !== 0) {
			// 선택된 메뉴에 class 추가
			setTab(index);
		}
		
		if(targetUrl) {
			url = targetUrl;
		} else {
			url = document.querySelector('.menu[data-index="'+selectedIndex+'"]').dataset.url;
			arcCode = document.querySelector('.menu[data-index="'+selectedIndex+'"]').dataset.id;
			fnSetVisitLog(document.querySelector('.menu[data-index="'+selectedIndex+'"]').dataset.id);
		}
		url = targetUrl ? targetUrl : document.querySelector('.menu[data-index="'+selectedIndex+'"]').dataset.url;
		data = document.querySelector('.menu[data-index="'+selectedIndex+'"]').dataset.filter;
		// 페이지 로드
		ajaxPage(url+".do", data+"&arcCode="+arcCode, "mainLayer");
	}
	
	function setTab(index) {
		selectedIndex = index;
		const menus = document.querySelectorAll(".menu");
		menus.forEach(e => e.classList.contains("on") &&  e.classList.remove("on"));
		const clickedMenu = document.querySelector(".menu[data-index='"+index+"']");
		if(clickedMenu) clickedMenu.classList.add("on");
		document.querySelector("#mainLayer").classList.add("load-page", "pdL20", "pdR20");
	}
	
	function setBtnPage(url, varfilter) {
		ajaxPage(url+".do", varfilter, "mainLayer");
		document.querySelector("#mainLayer").classList.add("load-page", "pdL20", "pdR20");
	}
	
	function loadBySelectedIndex() {
		return {
			url : document.querySelector('.menu[data-index="'+selectedIndex+'"]').dataset.url,
			filter : document.querySelector('.menu[data-index="'+selectedIndex+'"]').dataset.filter
		}
	}
	
	function fnSetVisitLog ( arcCode ) {
		var url = "setVisitLog.do";
		var target = "blankDiv";
		var data = "ActionType=ARCMN&MenuID="+arcCode;
		ajaxPage(url, data, target);
	}
	
	document.addEventListener('DOMContentLoaded', () => {
		var sidebarToggle = parent.document.querySelector(".side-toggle-button");
		var sidebar = document.querySelector(".sidemenu-container");
		
		sidebarToggle.addEventListener('click', () => {
	        sidebar.classList.toggle('sidebar-closed');
	        
	        const currentSidebarState = sidebar.classList.contains('sidebar-closed');
	        localStorage.setItem('sidebarClosed', currentSidebarState);
		});
    });
</script>
</head>
<body>
	<div class="sidemenu-container">
		<!-- side menu -->
		<div class="sidemenu-wrapper">
			<c:if test="${!empty arcInfo}">
				<div class="btns mgT30 pdL20 pdR20">
					<button id="side-btn" style="width:100%;" onclick="setBtnPage('${arcInfo.URL}', '${arcInfo.VarFilter}')">${arcInfo.ArcName}</button>
				</div>
			</c:if>
			<ul class="menu-1-wrapper">
				<c:set  var="i" value="1"/>
				<c:forEach var="list" items="${menuList}">
					<c:if test="${list.PRNT_MENU_ID eq arcCode }">
						<li  class="menu align-center flex justify-between" ><span>${list.MENU_NM}</span><svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#FFFFFF"><path d="M480-333 240-573l51-51 189 189 189-189 51 51-240 240Z"/></svg></li>
						<ul class="menu-2-wrapper">
							<c:forEach var="sublist" items="${menuList}" varStatus="status">
							<c:if test="${sublist.PRNT_MENU_ID eq list.MENU_ID }">
								<li class="menu" onclick="setPage(${i})" data-index="${i}" data-url="${sublist.URL}" data-filter="${sublist.FILTER}" data-id="${sublist.MENU_ID}">${sublist.MENU_NM }</li>
								<c:set  var="i" value="${i+1}"/>
								</c:if>
							</c:forEach>
						</ul>
					</c:if>
				</c:forEach>
			</ul>
		</div>
		<div class="load-page-wrapper">
			<div id="mainLayer"></div>
		</div>
	</div>
	<div id="blankDiv"></div>
</body>
</html>