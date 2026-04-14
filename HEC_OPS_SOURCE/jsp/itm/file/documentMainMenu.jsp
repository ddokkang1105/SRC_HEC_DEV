<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<style>
body {background:url("${root}${HTML_IMG_DIR}/blank.png")}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		setSubFrame('${itemTypeCode}', 1); // 초기 프로젝트 리스트 표시
	});

	// [Menu] Click
	function setSubFrame(ItemTypeCode, avg) { 
		clickSubMenuT(avg); // 클릭한 변경
		var target = "help_content";
		var data = "itemTypeCode=" + ItemTypeCode+"&docType=${docType}&pageNum=1&isPublic=${isPublic}";
		if("${screenType}" == "main"){
			data = data + "&searchKey=${searchKey}&searchValue=${searchValue}&screenType=${screenType}&regMemberName=${regMemberName}&fltpCode=${fltpCode}&itemClassCode=${itemClassCode}";
		}
		var url = "documentGridList.do";
		ajaxPage(url, data, target);
	}

	function setDisplay(divID, count) {

		var openDiv = $('#openDiv').val();
		var openDivStyle = $('#openDivStyle').val();

		if (openDiv != "") {
			if (openDivStyle == "block") {
				if (openDiv == divID) {
					document.getElementById(divID).style.display = "none";
					$('#openDivStyle').val("none");
				} else {
					document.getElementById(openDiv).style.display = "none";
					document.getElementById(divID).style.display = "block";
					$('#openDivStyle').val("block");
				}
			} else {
				document.getElementById(divID).style.display = "block";
				$('#openDivStyle').val("block");
			}
		} else {
			document.getElementById(divID).style.display = "block";
			$('#openDivStyle').val("block");
		}

		var beforeCount = $('#beforeCount').val();
		if ($('#openDivStyle').val() == "none") {
			document.getElementById("imgA" + count).style.display = "none";
			document.getElementById("imgB" + count).style.display = "block";
			if (beforeCount != "" && beforeCount != count) {
				document.getElementById("imgA" + beforeCount).style.display = "none";
				document.getElementById("imgB" + beforeCount).style.display = "block";
			}
		} else {
			document.getElementById("imgA" + count).style.display = "block";
			document.getElementById("imgB" + count).style.display = "none";
			if (beforeCount != "" && beforeCount != count) {
				document.getElementById("imgA" + beforeCount).style.display = "none";
				document.getElementById("imgB" + beforeCount).style.display = "block";
			}
		}

		$('#openDiv').val(divID);
		$('#beforeCount').val(count);

	}

	function clickSubMenuT(avg) { 
		var subTitleCnt = "${itemTypeListSize}";

		for ( var i = 0; i <= subTitleCnt; i++) {
			if (i == avg) {
				$("#itemType" + i).addClass("on");
			} else {
				$("#itemType" + i).removeClass("on");
			}
		}

	}
		
</script>
</head>


<body id="mainMenu" style="width:100%;height:100%;">
	<div id="help_content" style="width:100%;height:100%;"></div>
</body>
</html>


