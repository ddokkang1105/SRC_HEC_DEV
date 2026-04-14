<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><c:if test="${!empty htmlTitle}">${htmlTitle}</c:if></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033"/>
<script type="text/javascript">

	var languageID="${languageID}";
	var id="${s_itemID}";
	var scrnType="${scrnType}";
	var screenMode="${screenMode}";
	var MTCategory="${MTCategory}";
	var focusedItemID = "${focusedItemID}";
	var srcUrl = "";
	var itemClassMenuURL = "${itemClassMenuURL}";
	var option = `${popOption}`;
	
	jQuery(document).ready(function() {		
		fnSetVisitLog(id);		
		if( '${loginInfo.sessionMlvl}' != "SYS"){
			fnCheckUserAccRight(id, "fnGetMenuPage("+id+")", "${WM00033}");
		}else{
			fnGetMenuPage(id);
		}
	});
	
	
	// [API] arcCode 호출 api
	async function getArcCode(){
		
		if(option == "CNGREW"){
			
			const sqlID = "project_SQL.getItemStatus";
			const requestData = { s_itemID : id, sqlGridList : 'N', sqlID };
			const params = new URLSearchParams(requestData).toString();
			const url = "getData.do?" + params;
			let arcCode = '';
			
			try {
				const response = await fetch(url, { method: 'GET' });
				
				if (!response.ok) {
					// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
					throw throwServerError(result.message, result.status);
				}
			
				const result = await response.json();
				// success 필드 체크
				if (!result.success) {
					throw throwServerError(result.message, result.status);
				}
			
				if (result && result.data) {
					
					const status = result.data;
					if (status === "MOD1" || status === "MOD2") {
						arcCode = "AR000004";
					} else {
						arcCode = "AR000004A";
					}
					
					return arcCode;
					
				} else {
					return;
				}
			
			} catch (error) {
				handleAjaxError(error);
			}
			
		} else {
			return;
		}
		
	}
	
	function fnSetVisitLog(itemID){
		var url = "setVisitLog.do";
		var target = "blankDiv";
		var data = "ItemId="+itemID;
		ajaxPage(url, data, target);
	}
	
	async function fnGetMenuPage(itemID){
		
		const arcCode = await getArcCode();
		
		if(itemClassMenuURL != ""){
			srcUrl = itemClassMenuURL+".do?itemID="+itemID
					+"&itemPopYN=Y&ArcCode=" + arcCode + "&accMode=${accMode}"
					+"&scrnType="+scrnType
					+"&changeSetID=${changeSetID}"
					+"${itemClassMenuVarFilter}"
					+"&s_itemID="+itemID;
		}else{
			srcUrl = "itemMainMgt.do?languageID="+languageID
					+"&s_itemID="+id+"&scrnType="+scrnType
					+"&screenMode="+screenMode+"&MTCategory="+MTCategory
					+"&focusedItemID="+focusedItemID
					+"&arcCode=" + arcCode + "&changeSetID=${changeSetID}"
					+"&accMode=${accMode}${itemClassMenuVarFilter}&loadEdit=${loadEdit}"; 
		}
		$('#main').attr('src',srcUrl);		
	}
	
	
	function fnSetItemClassMenu(itemClassMenuURL,itemID){
		fnGetMenuPage(itemID);
	}
	
	async function fnGetMenuUrl(itemID){
		const arcCode = await getArcCode();
		srcUrl = "itemInfoPop.do?languageID="+languageID+"&id="+id+"&scrnType="+scrnType
				+"&screenMode="+screenMode+"&MTCategory="+MTCategory+"&ArcCode=" + arcCode + "&changeSetID=${changeSetID}";
		$('#main').attr('src',srcUrl);		
	}
	
</script>
</head>
<body style="margin:0; text-align:center;margin-right:10px;">
<iframe name="main" id="main" width="100%" height="99%" frameborder="0" scrolling="no" marginwidth="0" marginheight="0" align="center"></iframe>
</body>
</html>
