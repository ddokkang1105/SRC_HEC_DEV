<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript">
    var pWindow = window.opener || window;

    /**
     * @function fnUpdateTeamRoleInfo
     * @description 수정된 역할 정보를 저장
     */
    function fnUpdateTeamRoleInfo(){
        if(!confirm("${CM00001}")){ return; } // 저장하시겠습니까?

        var url = "updateTeamRoleInfo.do";
        var target = "saveRoleFrame";
        var data = $("#detailFrm").serialize();

        ajaxPage(url, data, target);
    }

    /**
     * @function fnTeamRoleCallBack
     * @description 저장 완료 후 saveRoleFrame에 의해 호출되는 콜백 함수
     */
    function fnTeamRoleCallBack() {
        // 1. 부모창 리스트 새로고침
        if(pWindow.reloadItemTeamRoleList) {
            pWindow.reloadItemTeamRoleList();
        }
        // 2. 현재 상세 모달 닫기
        if(pWindow.fnCloseDetailModal) {
            pWindow.fnCloseDetailModal();
        }
    }

    // 담당자 검색 팝업
    function searchPopupWf(avg){
        var searchValue = $("#modalMemberName").val();
        var url = avg + "&searchValue=" + encodeURIComponent(searchValue)
            + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
        window.open(url, 'window', 'width=340, height=300, left=300, top=300, scrollbar=yes, resizable=0');
    }

    // 담당자 검색 콜백
    function setSearchNameWf(memberID, userName, teamName, teamID, objId, objName, teamPath) {
        if (objName) {
            $("#" + objName).val(userName + "(" + teamName + ")");
        }
        if (objId) {
            $("#" + objId).val(memberID);
        }
    }
</script>

<div class="pdL10 pdR10">
    <form name="detailFrm" id="detailFrm" method="post" onsubmit="return false;">
        <input type="hidden" id="teamRoleID" name="teamRoleID" value="${teamRoleInfo.TeamRoleID}" />
        <input type="hidden" id="teamID" name="teamID" value="${teamRoleInfo.TeamID}" />
        <input type="hidden" id="itemID" name="itemID" value="${s_itemID}" />

        <div class="child_search_head mgB10">
            <p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;Role Detail Information</p>
        </div>

        <table class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0">
            <colgroup>
                <col width="25%">
                <col width="75%">
            </colgroup>
            <tr>
                <th class="last pdL10">Code</th>
                <td class="last">
                    <input type="text" class="text" id="teamCode" name="teamCode" value="${teamRoleInfo.TeamCode}" readOnly style="border:0; background:transparent;" />
                </td>
            </tr>
            <tr>
                <th class="last pdL10">${menu.LN00247}</th> <td class="last">
                <input type="text" class="text" id="teamName" name="teamName" value="${teamRoleInfo.TeamNM}" readOnly style="border:0; background:transparent;" />
            </td>
            </tr>
            <tr>
                <th class="last pdL10">${menu.LN00119}</th> <td class="last">
                <input type="text" class="text" id="roleType" name="roleType" value="${teamRoleInfo.TeamRoleNM}" readOnly style="border:0; background:transparent;" />
            </td>
            </tr>
            <tr>
                <th class="last pdL10">${menu.LN00004}</th> <td class="last">
                <input type="text" class="text" id="modalMemberName" name="memberName" value="${teamRoleInfo.RoleManagerNM}" style="width:88%;" />

                <input type="hidden" id="roleManagerID" name="roleManagerID" value="${teamRoleInfo.RoleManagerID}" />

                <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png"
                       onclick="searchPopupWf('searchPluralNamePop.do?objId=roleManagerID&objName=modalMemberName&UserLevel=ALL')" value="Search">
            </td>
            </tr>
            <tr>
                <th class="last pdL10">${menu.LN00035}</th> <td class="last">
                <input type="text" class="text" id="roleDescription" name="roleDescription" value="${teamRoleInfo.RoleDescription}" style="width:95%;" />
            </td>
            </tr>
        </table>

        <div class="alignBTN mgT20">
            <span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnUpdateTeamRoleInfo()"></span>
        </div>
    </form>

    <iframe id="saveRoleFrame" name="saveRoleFrame" style="width:0px;height:0px;display:none;"></iframe>
</div>