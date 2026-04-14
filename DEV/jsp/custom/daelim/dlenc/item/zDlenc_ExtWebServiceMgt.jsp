<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 


<script type="text/javascript">
$(document).ready(function(){

    var classCode = "${classCode}";
    function editPopup(qsMap) {
        var qsStr = JSON.stringify(qsMap);
        var qsEnc = btoa(qsStr);

        window.open(
            "https://manual.dlenc.co.kr/sso/linkViewWithParam.jsp?_q=" + qsEnc,
            "popupWindow",
            "width=940,height=700,top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes,noopener,noreferrer"
        );
    }

    if (classCode === "CL33016") {

        editPopup({
            "serviceCode": "SvgViewerPopup0001"
        });

    } else if("${parentProjectCode}" === "HQP240003" ){
			editPopup({
            "serviceCode": "Dab40_10_PStdActivityDtil0001",
            "CD_SITE": "${projectCode}",
            "CD_MNOF": "${manual[0].CD_MNOF}",
            "ID_ACTY": "${manual[0].ID_ACTY}"

        });

    }else{
		    editPopup({
            "serviceCode": "Dab40_10_PSiteActivityDtil0001",
            "CD_SITE": "${projectCode}",
            "CD_MNOF": "${manual[0].CD_MNOF}",
            "ID_ACTY": "${manual[0].ID_ACTY}"

        });
    }

});
</script>