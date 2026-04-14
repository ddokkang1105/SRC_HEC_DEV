<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<%
String noticType = request.getParameter("noticType") == null ? "1" : request.getParameter("noticType");
%>

<style>
.postInfo {
    height: 100%;
    overflow-y: auto;
    background: #fff;
}
.postInfo ul {
    background: #fff;
    width: 96%;
    padding: 0 2%;
    display: table;
}
.postInfo ul:hover {
    background: rgba(65, 152, 247, 0.15);
    cursor: pointer;
    box-shadow: 2px 0px 0px 0px #4265EE inset;
    transition: background-color .2s ease-out;
}
.postInfo li {
    display: table-cell;
    padding: 1.44% 1.4%;
    border-bottom: 1px solid #e6e6e6;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.postInfo ul:last-child li { border: none; }
</style>

<input type="hidden" id="noticType" name="noticType" value="<%=noticType%>">

<div class="postInfo" id="mainBoardQnAListArea">
    <div id="mainBoardQnALoading" style="padding:10px; text-align:center;"></div>
</div>

<script>
    $(document).ready(function() {
        loadMainBoardQnAList();
    });

    function loadMainBoardQnAList() {
        var params = new URLSearchParams({
            LanguageID:  "${sessionScope.loginInfo.sessionCurrLangType}",
            BoardMgtID:  "${boardMgtID}",
            boardGrpID:  "${boardGrpID}",
            replyLev:    "${replyLev}",
            projectID:   "${templProjectID}",
            projectType: "${templProjectType}",
            viewType:    "home",
            sqlID:       "forum_SQL.forumGridList",  // ← QnA 전용 SQL
            listSize:    "${listSize}"
        });

        fetch("getData.do?" + params.toString(), { method: "GET" })
            .then(function(response) {
                if (!response.ok) throw new Error("HTTP " + response.status);
                return response.json();
            })
            .then(function(result) {
                renderMainBoardQnAList(result.data || []);
            })
            .catch(function(error) {
                console.log("ERR: " + error.message);
                $("#mainBoardQnAListArea").html("<div style='padding:10px;'>데이터를 불러올 수 없습니다.</div>");
            });
    }

    function renderMainBoardQnAList(dataList) {
        var listSize = parseInt("${listSize}") || 5;
        var html = "";

        if (!dataList || dataList.length === 0) {
            html = "<div style='padding:10px;'>There is no item to be listed.</div>";
        } else {
            var limit = Math.min(dataList.length, listSize);
            for (var i = 0; i < limit; i++) {
                var item = dataList[i];
                var newImg = (item.chkNew === '1')
                    ? '<img src="${root}${HTML_IMG_DIR}/new.png">'
                    : "";
                html += '<ul onclick="fnDetail(\'' + item.BoardMgtID + '\',\'' + item.BoardID + '\')">';
                html += '  <li style="width:25%;max-width:595px;">'  + (item.itemName    || "") + '</li>';
                html += '  <li style="width:55%;max-width:595px;">'  + (item.Subject     || "") + newImg + '</li>';
                html += '  <li style="width:10%;" class="alignC">'   + (item.WriteUserNM || "") + '</li>';
                html += '  <li style="width:15%;" class="alignC">'   + (item.ModDT       || "") + '</li>';
                html += '</ul>';
            }
        }
        $("#mainBoardQnAListArea").html(html);
    }

    function fnDetail(mgtID, ID) {
        var url  = "boardDetailPop.do";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
                 + "&BoardID="    + ID
                 + "&BoardMgtID=" + mgtID
                 + "&noticType="  + $('#noticType').val();
        fnOpenLayerPopup(url, data, "", 617, 436); // ← QnA 팝업 크기
    }
</script>