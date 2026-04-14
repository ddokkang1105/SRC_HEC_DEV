<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>${menu.LN00001}</title>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script type="text/javascript">
	var chkReadOnly = true;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<script>	
jQuery(document).ready(function() {	
	$('#popup_close_btn').click(function(){clickClosePop();});
});
function clickSetCookie(){var cookieId="sfolmLdNtc_"+"${resultMap.BoardID}";if(document.getElementById("IS_CHECK").checked){setCookie(cookieId, "${resultMap.BoardID}", 2);} else {setCookie(cookieId, "", -1);}}
function clickClosePop(){
	document.getElementById("mask").style.display = "none";
	document.getElementById("popupDiv").style.display = "none";
}
</script>
<style>
	strong,em{font-size:inherit;}
</style>
</head><body>
<div class="popup01">
<ul>
  <li class="con_zone" style="height:360px;">
    <div class="title popup_title"><span class="pdL10">${menu.LN00001}</span>
    </div> 
    <div class="szone">
        <div class="popup01con01">
           <table border="0" width="100%" class="tbl_blue01" cellpadding="0" cellspacing="0">
           <colgroup>
           	<col width="20">
           	<col width="80">
           </colgroup>
                    <tr>
                        <th>${menu.LN00002}</th>
                        <td class="last">${resultMap.Subject}</td>
                    </tr>
                    <tr>
                        <th>${menu.LN00013}</th>
                        <td class="last">${resultMap.RegDT}</td>
                    </tr>
                    <tr>
                        <td colspan="2" class="alignL last">
							<div style="width:656px;height:265px;overflow:auto;">
								${resultMap.Content}
							</div>
						</td>
                    </tr>                   
                </table>
        </div>
        <div class="popup02Close mgL10 mgT30" style="float:left !important">
        	<input   class="pdL50 pdT3" type="checkbox" name="IS_CHECK" id="IS_CHECK" value="" onclick="clickSetCookie();"/>&nbsp;<font class="pdR10">${menu.LN00161}</font>
		</div>
         <div class="floatL mgR10  mgT30" style="cursor:pointer;float:right !important">
                <span class="popup_closeBtn" id="popup_close_btn" >${menu.LN00160}<img src='${root}${HTML_IMG_DIR}/btn_close2.png' title="close" style="top: -3px;position: relative;"></span>
         </div>
    </div>
    </li>  
    </ul>
</div>





</body></html>