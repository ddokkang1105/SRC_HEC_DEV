<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
	<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>
	<script type="text/javascript">
		var chkReadOnly = true;
	</script>
	<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
	<script>
		getAttrList();
	
		async function getAttrList() {
			const res = await fetch("/getAttrList.do?s_itemID=${s_itemID}&languageID=${languageID}&showInvisible=${showInvisible}");
			const data = await res.json();
			const attributesList = data.data;
			
			if (attributesList.length === 0) {
		        return;
		    }
			
			let html = '';
			
			const hasTwoColumns = attributesList.some(attr => attr.ColumnNum2 == '2');
		    let colgroupHtml = '';
		    if (hasTwoColumns) {
		        colgroupHtml = '<col width="11%"><col width="39%"><col width="11%"><col width="39%">';
		    } else {
		        colgroupHtml = '<col width="11%"><col width="89%">';
		    }
			
	// 		html += '<div id="attrList" class="mgT20">'
	// 		html += '<table width="100%" cellpadding="0" cellspacing="0" border="0" class="new-form form-column-8">';
			html += '<colgroup>'+colgroupHtml+'</colgroup>';
			
			for (const attrList of attributesList) {
				html += '<tr>';
				html += '<th>';
				if(attrList.Mandatory == '1') html += '<p style="display:inline;color:#FF0000;">*</p>'
				html += attrList.Name
		//			if("${papagoTrans}" == "Y" && attrList.DataType == 'Text' && attrList.HTML != '1') html += '<button onclick="fnOpenPapagoTrans(\''+attrList.AttrTypeCode+'\',\''+attrList.HTML+'\')">Papago</button>';
				html += '</th>';
				
				html += '<td class="tdLast alignL"'
				if(attrList.DataType == 'Text') html += 'style="height:${attrList.AreaHeight}px;"'
				if(attrList.ColumnNum2 != '2' ) html += 'colspan="3"'
				html += '>'
				
				if(attrList.HTML == '1') {
					html += '<div style="width:100%; height:'+attrList.AreaHeight+'px;" class="pd0">'
					html += '<textarea class="tinymceText" readonly="readonly" name="'+attrList.AttrTypeCode+'">'+attrList.PlainText+'</textarea>'
					html += '</div>'
				}
				
				if(attrList.HTML != '1') {
					if(attrList.Link == null) html += attrList.PlainText
					if(attrList.Link || "${attrUrl}") {
						html += '<a onClick="fnRunLink(\''+attrList.URL+'\',\'${attrUrl}\', \''+attrList.AttrTypeCode+'\', \''+attrList.VarFilter+'\');" style="color:#0054FF;text-decoration:underline;cursor:pointer;">';
						html += attrList.PlainText
						html += '</a>'
					}
				}
				html += '</td>';
				
				// 두번째 칼럼
				if(attrList.ColumnNum2 == '2') {
					colgroup = '<col width="11%"><col width="39%"><col width="11%"><col width="39%">'
					
					html += '<th>';
					if(attrList.Mandatory2 == '1') html += '<p style="display:inline;color:#FF0000;">*</p>'
					html += attrList.Name2
		//				if("${papagoTrans}" == "Y" && attrList.DataType2 == 'Text' && attrList.HTML2 != '1') html += '<button onclick="fnOpenPapagoTrans(\''+attrList.AttrTypeCode2+'\',\''+attrList.HTML2+'\')">Papago</button>';
					html += '</th>';
					
					html += '<td class="tdLast alignL"'
					if(attrList.DataType2 == 'Text') html += 'style="height:${attrList.AreaHeight}px;"'
					html += '>'
					
					if(attrList.HTML2 == '1') {
						html += '<div style="width:100%; height:'+attrList.AreaHeight2+'px;" class="pd0">'
						html += '<textarea class="tinymceText" readonly="readonly" name="'+attrList.AttrTypeCode2+'">'+attrList.PlainText2+'</textarea>'
						html += '</div>'
					}
					
					if(attrList.HTML2 != '1') {
						if(attrList.Link2 == null) html += attrList.PlainText2
						if(attrList.Link || "${attrUrl}") {
							html += '<a onClick="fnRunLink(\''+attrList.URL2+'\',\'${attrUrl}\', \''+attrList.AttrTypeCode2+'\', \''+attrList.VarFilter2+'\');" style="color:#0054FF;text-decoration:underline;cursor:pointer;">';
							html += attrList.PlainText2
							html += '</a>'
						}
					}
					html += '</td>';
				}
						
				html += '</tr>';
			}
			
	// 		html += '</table>'
	// 		html += '</div>'
	
			document.querySelector("#attr").insertAdjacentHTML("beforeEnd", html);
	
			// 새 스크립트 요소 생성
		    const script = document.createElement('script');
		    script.type = 'text/javascript';
		    script.src = '<c:url value="/cmm/js/xbolt/tinyEditorHelper.js"/>';
		    
		    document.body.appendChild(script);
		}
		
		function goItemInfoEdit() {
// 			if (isPossibleEdit == "Y") { 
			
			    var url = "editItemAttr.do";
				var target = "attrList";
				var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&showVersion=${showVersion}&showInvisible=${showInvisible}";
			 	ajaxPage(url, data, target);
// 			} else {
// 				if (itemStatus == "REL") {
// 					alert("${WM00120}"); // [변경 요청 안된 상태]
// 				} else {
// 					alert("${WM00050}"); // [승인요청중]
// 				}
// 			}
		}
	</script>
	</head>
	<body>
		<table width="100%" cellpadding="0" cellspacing="0" border="0" class="form-column-8 new-form mgT10" id="attr"></table>
	</body>
</html>