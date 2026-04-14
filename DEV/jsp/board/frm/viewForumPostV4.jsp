<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript">
    var previousAddedFileNames = new Set();
    var scrnType = "BRD";
    var docCategory = "BRD";
    var mgtId = "${forumDTO.boardMgtID}";
    var boardId = "${forumDTO.boardID}";
    var itemClassCode = "";
    var documentId = "";
    var projectId = "";
    var changeSetId = "";
</script>

<%@ include file="/WEB-INF/jsp/template/fileAttachWindow.jsp"%>

<!-- 화면 표시 메시지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00005" var="CM00005" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00016" var="CM00016" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00071" var="CM00071" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00068" var="WM00068" />

<script type="text/javascript">
    var sessionUserId = "${sessionScope.loginInfo.sessionUserId}";
    var sessionUserNm = "${sessionScope.loginInfo.sessionUserNm}";
    var sessionCurrLangType = "${sessionScope.loginInfo.sessionCurrLangType}";
    var currentBoardMap = {};

    $(document).ready(function() {
        const boardIds = "${forumDTO.boardIds}";
        const prev = document.getElementById("prev");
        const next = document.getElementById("next");

        if (prev && next) {
            const boardIdArray = boardIds ? boardIds.split(",").map(id => id.trim()) : [];
            const curIndex = boardIdArray.findIndex(e => e === "${forumDTO.boardID}");

            if (boardIdArray.length > 1 && curIndex !== -1) {
                if(curIndex - 1 < 0 ) {
                    next.style.display = "none";
                }
                if(curIndex + 1 == boardIdArray.length) {
                    prev.style.display = "none";
                }
                prev.addEventListener("click", () => goPage(curIndex + 1));
                next.addEventListener("click", () => goPage(curIndex - 1));
            } else {
                prev.style.display = "none";
                next.style.display = "none";
            }
        }

        function goPage (index) {
            const boardIdArray = boardIds ? boardIds.split(",").map(id => id.trim()) : [];
            if (boardIdArray[index]) {
                fnCallBack(boardIdArray[index], "${ItemID}");
            }
        }

        fnGetForumDetail();

        const btnTop = document.getElementById("top");
        let scrollArea = document.getElementById("carcontent") || document.getElementById("help_content");
        if(btnTop && scrollArea) {
            btnTop.addEventListener("click", (e) => {
                scrollArea.scroll({ top: 0, behavior: 'smooth' });
            });
        }
    });

    function fnGetForumDetail() {
        var url = "viewForumPostData.do";
        var formData = new FormData();
        formData.append("boardID", "${forumDTO.boardID}");
        formData.append("BoardMgtID", "${forumDTO.boardMgtID}");
        formData.append("ItemID", "${forumDTO.itemID}");
        formData.append("s_itemID", "${forumDTO.s_itemID}");
        formData.append("filter", "${forumDTO.filter}");
        
        // 추가 전용 권한 및 식별 파라미터
        formData.append("myBoard", "${forumDTO.myBoard}");
        formData.append("boardTitle", "${forumDTO.boardTitle}");
        formData.append("emailCode", "${forumDTO.emailCode}");
        formData.append("srID", "${forumDTO.srID}");
        formData.append("pageNum", "${forumDTO.pageNum}");
        formData.append("isMyCop", "${forumDTO.isMyCop}");
        formData.append("screenType", "${forumDTO.screenType}");
        formData.append("projectID", "${forumDTO.projectID}");
        formData.append("scStartDt", "${forumDTO.scStartDt}");
        formData.append("scEndDt", "${forumDTO.scEndDt}");
        formData.append("category", "${forumDTO.category}");
        formData.append("categoryIndex", "${forumDTO.categoryIndex}");
        formData.append("categoryCnt", "${forumDTO.categoryCnt}");
        formData.append("itemTypeCode", "${forumDTO.itemTypeCode}");
        formData.append("searchType", "${forumDTO.searchType}");
        formData.append("searchValue", "${forumDTO.searchValue}");
        formData.append("listType", "${forumDTO.listType}");
        formData.append("boardIds", "${forumDTO.boardIds}");
        formData.append("mailRcvListSQL", "${forumDTO.mailRcvListSQL}");
        formData.append("regUserName", "${forumDTO.regUserName}");
        formData.append("authorName", "${forumDTO.authorName}");
        formData.append("showItemInfo", "${forumDTO.showItemInfo}");
        formData.append("srType", "${forumDTO.srType}");
        formData.append("scrnType", "${forumDTO.scrnType}");
        formData.append("dueDateMgt", "${forumDTO.dueDateMgt}");
        formData.append("replyMailOption", "${forumDTO.replyMailOption}");
        formData.append("forumMailOption", "${forumDTO.forumMailOption}");
        formData.append("showReplyDT", "${forumDTO.showReplyDT}");
        formData.append("openDetailSearch", "${forumDTO.openDetailSearch}");
        formData.append("showAuthorInfo", "${forumDTO.showAuthorInfo}");
        formData.append("showItemVersionInfo", "${forumDTO.showItemVersionInfo}");
        formData.append("noticType", "${forumDTO.noticType}");

        // SR 옵션 파라미터
        if ("${forumDTO.srID}" !== "") {
            formData.append("srCategory", "${forumDTO.srCategory}");
            formData.append("srArea1", "${forumDTO.srArea1}");
            formData.append("subject", "${forumDTO.subject}");
            formData.append("searchStatus", "${forumDTO.searchStatus}");
            formData.append("receiptUser", "${forumDTO.receiptUser}");
            formData.append("requestUser", "${forumDTO.requestUser}");
            formData.append("requestTeam", "${forumDTO.requestTeam}");
            formData.append("startRegDT", "${forumDTO.startRegDT}");
            formData.append("endRegDT", "${forumDTO.endRegDT}");
            formData.append("searchSrCode", "${forumDTO.searchSrCode}");
            formData.append("srReceiptTeam", "${forumDTO.srReceiptTeam}");
            formData.append("srMode", "${forumDTO.srMode}");
        }
        
        fetch(url, {
            method: 'POST',
            body: new URLSearchParams(formData)
        })
        .then(response => response.json())
        .then(res => {
            fnSetForumDetail(res);
        })
        .catch(error => console.error("Error fetching forum details:", error));
    }

    function fnSetForumDetail(res) {
        var boardMap = res.boardMap || {};
        currentBoardMap = boardMap;
        var fileList = res.fileList || [];
        currentFileList = fileList;
        var replyList = res.replyList || [];
        var boardTitle = res.boardTitle || "";
        var replyListCnt = res.replyListCnt || 0;

        // Hidden parameters for Reply form
        if(document.getElementById("uploadToken")) document.getElementById("uploadToken").value = res.uploadToken || "${forumDTO.uploadToken}";
        if (typeof uploadToken !== 'undefined') uploadToken = res.uploadToken || "${forumDTO.uploadToken}"; // Update global token for vault modal
        if(document.getElementById("regId")) document.getElementById("regId").value = boardMap.RegID || "";
        if(document.getElementById("refID")) document.getElementById("refID").value = boardMap.RefID || "";
        if(document.getElementById("likeInfo")) document.getElementById("likeInfo").value = boardMap.LikeInfo || "";
        if(document.getElementById("parentRefID")) document.getElementById("parentRefID").value = boardMap.RefID || "";
        if(document.getElementById("memberID")) document.getElementById("memberID").value = boardMap.RegUserID || "";
        if(document.getElementById("subject")) document.getElementById("subject").value = boardMap.Subject || "";
        if(document.getElementById("scheduleID")) document.getElementById("scheduleID").value = boardMap.ScheduleID || "";
        
        // 추가 파라미터 셋팅
        if(document.getElementById("s_itemID")) document.getElementById("s_itemID").value = res.s_itemID || "${forumDTO.s_itemID}";
        if(document.getElementById("noticType")) document.getElementById("noticType").value = res.noticType || "${forumDTO.noticType}";
        if(document.getElementById("ItemID")) document.getElementById("ItemID").value = res.itemID || "${forumDTO.itemID}";
        if(document.getElementById("score")) document.getElementById("score").value = res.score || "${forumDTO.score}";
        if(document.getElementById("currPage")) document.getElementById("currPage").value = res.pageNum || "${forumDTO.pageNum}";
        if(document.getElementById("BoardMgtID")) document.getElementById("BoardMgtID").value = res.boardMgtID || "${forumDTO.boardMgtID}";
        if(document.getElementById("screenType")) document.getElementById("screenType").value = res.screenType || "${forumDTO.screenType}";
        if(document.getElementById("itemTypeCode")) document.getElementById("itemTypeCode").value = res.itemTypeCode || "${forumDTO.itemTypeCode}";
        if(document.getElementById("mailRcvListSQL")) document.getElementById("mailRcvListSQL").value = res.mailRcvListSQL || "${forumDTO.mailRcvListSQL}";
        if(document.getElementById("emailCode")) document.getElementById("emailCode").value = res.emailCode || "${forumDTO.emailCode}";
        if(document.getElementById("replyMailOption")) document.getElementById("replyMailOption").value = res.replyMailOption || "${forumDTO.replyMailOption}";
        if(document.getElementById("forumMailOption")) document.getElementById("forumMailOption").value = res.forumMailOption || "${forumMailOption}";
        if(document.getElementById("showReplyDT")) document.getElementById("showReplyDT").value = res.showReplyDT || "${forumDTO.showReplyDT}";
        if(document.getElementById("openDetailSearch")) document.getElementById("openDetailSearch").value = res.openDetailSearch || "${forumDTO.openDetailSearch}";
        if(document.getElementById("showAuthorInfo")) document.getElementById("showAuthorInfo").value = res.showAuthorInfo || "${forumDTO.showAuthorInfo}";
        if(document.getElementById("showItemVersionInfo")) document.getElementById("showItemVersionInfo").value = res.showItemVersionInfo || "${forumDTO.showItemVersionInfo}";


        // Header and Subject
        document.getElementById("boardTitle_span").innerText = boardTitle;
        document.getElementById("subject_div").innerText = boardMap.Subject || "";

        // Author Info
        var writeUserNM = boardMap.WriteUserNM || "";
        var teamName = boardMap.TeamName || "";
        var initial = writeUserNM ? writeUserNM.substring(0, 1) : "";
        document.getElementById("author_initial").innerText = initial;
        document.getElementById("author_name").innerText = writeUserNM + (teamName ? "(" + teamName + ")" : "");
        document.getElementById("last_updated").innerText = boardMap.LastUpdated || boardMap.RegDT || "";
        document.getElementById("read_count").innerText = boardMap.ReadCNT || "0";

        // Path and Item Info
        var pathItemArea = document.getElementById("path_item_area");
        if (boardMap.ItemID && String(boardMap.ItemID) !== '0') {
            pathItemArea.innerHTML = '<img src="${root}${HTML_IMG_DIR_ITEM}/' + (boardMap.ClassIcon || '') + '" >' +
                                     '<label onclick="fnOpenItemPop(' + boardMap.ItemID + ')" class="mgL5">' + (boardMap.Path || '') + '/' + (boardMap.ItemName || '') + '</label>';
        } else {
            pathItemArea.innerHTML = '';
        }

        // Category info
        var categoryHtml = "";
        
        if (boardMap.Category && boardMap.Category !== '-' && boardMap.Category !== 'null') {
            if ("${dueDateMgt}" === "Y") {
                categoryHtml += '<li class="flex mgB10"><p style="width: 60px; font-weight:700;">구분</p><div>' + boardMap.Category + '</div></li>';
                categoryHtml += '<li class="flex mgB10"><p style="width: 60px; font-weight:700;">요청기한</p><div>' + (boardMap.SC_END_DT || '') + '</div></li>';
            }
        }

        if ("${mailRcvListSQL}" === "review") {
            categoryHtml += '<li class="flex mgB10"><p style="width: 60px; font-weight:700;">寃?좉린??/p><div>' + (boardMap.SC_END_DT || '') + '</div></li>';
            categoryHtml += '<li class="flex mgB10"><p style="width: 60px; font-weight:700;">寃?좊???/p><div>' + (boardMap.reviewDept || '') + '</div></li>';
            categoryHtml += '<li class="flex mgB10"><p style="width: 60px; font-weight:700;">寃?좎옄</p><span class="flex" style="flex-wrap: wrap;width: fit-content;">';
            if (boardMap.sharerNames) {
                var sharers = boardMap.sharerNames.split(',');
                sharers.forEach(function(i) {
                    if (i) {
                        var initial = i.substring(0, 1);
                        categoryHtml += '<div class="mgR20"><span class="mem_list"><span class="thumb mini"><span lang="ko" class="initial_profile" style="background-color: rgb(134, 164, 212);"><em>' + initial + '</em></span></span><span class="name_info"><span class="name_txt">' + i + '</span></span></span></div>';
                    }
                });
            }
            categoryHtml += '</span></li>';
        }

        var fileCount = 0;
        var fHtml = "";
        fileList.forEach(function(f) {
            if (f.BoardID == boardMap.BoardID) {
                fileCount++;
                var ext = (f.FileName || "").split('.').pop().toLowerCase();
                var iconClass = "log";
                if (ext.includes("do")) iconClass = "doc";
                else if (ext.includes("xl")) iconClass = "xls";
                else if (ext.includes("pdf")) iconClass = "pdf";
                else if (ext.includes("hw")) iconClass = "hwp";
                else if (ext.includes("pp")) iconClass = "ppt";
                
                fHtml += '<li onclick="fileNameClick(\'' + f.Seq + '\')">';
                fHtml += '<span class="btn_pack small icon mgR30"><span class="' + iconClass + '"></span></span>';
                fHtml += '<span style="line-height:24px;">' + f.FileRealName + '</span></li>';
            }
        });

        categoryHtml += '<li><div class="mgB25">';
        if (fileCount > 0) {
            categoryHtml += '<p style="width: 60px; font-weight:700;">${menu.LN00111}<span>&nbsp;' + fileCount + '</span></p>';
        }
        categoryHtml += '<div class="flex justify-between align-end">';
        var ulVisibility = fileCount === 0 ? 'style="visibility: hidden;"' : '';
        categoryHtml += '<ul class="file_box" ' + ulVisibility + '>';
        if (fileCount > 0) {
            categoryHtml += fHtml;
        }
        categoryHtml += '</ul></div></div></li>';
        
        document.getElementById("category_info_ul").innerHTML = categoryHtml;

        // Sharers (bottom area if not review)
        var sharerAreaHtml = "";
        if (boardMap.sharerNames && "${mailRcvListSQL}" !== "review") {
            sharerAreaHtml += '<div><ul><li class="flex mgB10"><p style="width: 60px; font-weight:700; ">${menu.LN00245}</p><span class="flex" style="flex-wrap: wrap;width: fit-content;">';
            var sharers = boardMap.sharerNames.split(',');
            sharers.forEach(function(i) {
                if (i) {
                    var initial = i.substring(0, 1);
                    sharerAreaHtml += '<div class="mgR20"><span class="mem_list"><span class="thumb mini"><span lang="ko" class="initial_profile" style="background-color: rgb(134, 164, 212);"><em>' + initial + '</em></span></span><span class="name_info"><span class="name_txt">' + i + '</span></span></span></div>';
                }
            });
            sharerAreaHtml += '</span></li>';
            sharerAreaHtml += '<li class="align-center flex mgB20"><p style="width: 60px; font-weight:700;">${menu.LN00233}</p><div>' + (boardMap.SC_END_DT || '') + '</div></li></ul></div>';
        }
        document.getElementById("sharer_area").innerHTML = sharerAreaHtml;

        // Content
        document.getElementById("content_area").innerHTML = boardMap.Content || "";

        // Bottom File Box for non-dueDate/review
        var bottomFileBoxArea = document.getElementById("bottom_file_box_area");
        var bottomFlexArea = document.getElementById("bottom_flex_area");

        // Clear previous dynamically added file elements
        var oldP = bottomFileBoxArea.querySelector("p.mgB10");
        if(oldP) oldP.remove();
        var oldUl = bottomFlexArea.querySelector("ul.file_box");
        if(oldUl) oldUl.remove();

        if ("${dueDateMgt}" !== "Y" && "${mailRcvListSQL}" !== "review") {
            if (fileCount > 0) {
                var bottomP = document.createElement("p");
                bottomP.className = "mgB10";
                bottomP.style.visibility = "hidden";
                bottomP.innerHTML = "${menu.LN00111}<span>&nbsp;" + fileCount + "</span>";
                bottomFileBoxArea.insertBefore(bottomP, bottomFlexArea);
                
                var bottomUl = document.createElement("ul");
                bottomUl.className = "file_box";
                bottomUl.style.visibility = "hidden";
                
                var bottomFHtml = "";
                fileList.forEach(function(f) {
                    if (f.BoardID == boardMap.BoardID && "${BoardMgtID}" !== "BRD0201") {
                        var ext = (f.FileName || "").split('.').pop().toLowerCase();
                        var iconClass = "log";
                        if (ext.includes("do")) iconClass = "doc";
                        else if (ext.includes("xl")) iconClass = "xls";
                        else if (ext.includes("pdf")) iconClass = "pdf";
                        else if (ext.includes("hw")) iconClass = "hwp";
                        else if (ext.includes("pp")) iconClass = "ppt";
                        
                        bottomFHtml += '<li onclick="fileNameClick(\'' + f.Seq + '\')">';
                        bottomFHtml += '<span class="btn_pack small icon mgR30"><span class="' + iconClass + '"></span></span>';
                        bottomFHtml += '<span style="line-height:24px;">' + f.FileRealName + '</span></li>';
                    }
                });
                bottomUl.innerHTML = bottomFHtml;
                bottomFlexArea.insertBefore(bottomUl, document.getElementById("bottom_buttons"));
            }
        }

        // Buttons
        var btnComplete = document.getElementById("btn_complete");
        var btnEdit = document.getElementById("btn_edit");
        var btnDel = document.getElementById("btn_del");
        var btnChangeItem = document.getElementById("btn_change_item");

        if (btnComplete) btnComplete.style.display = "none";
        if (btnEdit) btnEdit.style.display = "none";
        if (btnDel) btnDel.style.display = "none";
        if (btnChangeItem) btnChangeItem.style.display = "none";

        var isBlocked = boardMap.Blocked === "1";

        var reviewCloseYN = "N";
        if ("${ItemMgtUserMap.AuthorID}" === sessionUserId || sessionUserId === "${BoardMgtInfo.MgtUserID}") {
            reviewCloseYN = "Y";
        }
        
        if ("${BoardMgtInfo.BlockOption}" === "1" && !isBlocked) {
            if ("${mailRcvListSQL}" === "review" && "${replyOption}" !== "2") {
                if (boardMap.sharerIDs) {
                    var sharerIDs = boardMap.sharerIDs.split(',');
                    if (sharerIDs.includes(sessionUserId)) {
                        reviewCloseYN = "N";
                    }
                }
            }
            if (reviewCloseYN === "Y" && btnComplete) {
                btnComplete.style.display = "inline-block";
            }
        }

        if (sessionUserId == boardMap.RegUserID && !isBlocked) {
            if (btnEdit) btnEdit.style.display = "inline-block";
            if (btnDel) btnDel.style.display = "inline-block";
        }

        if (("${ItemMgtUserMap.AuthorID}" === sessionUserId || "${sessionScope.loginInfo.sessionAuthLev}" === "1") && !isBlocked) {
            // Keep display none per original but leave DOM element ready for JS to handle if needed
        }

        // Replies
        document.getElementById("reply_count_span").innerText = replyListCnt;
        var rHtml = "";
        replyList.forEach(function(reply) {
            var rInitial = reply.WriteUserNM ? reply.WriteUserNM.substring(0, 1) : "";
            var nameEN = reply.NameEN ? "<span>(" + reply.NameEN + ")</span>" : "";
            rHtml += '<ul class="reply_list" id="reply_list' + reply.BoardID + '">';
            rHtml += '<li class="flex align-center justify-between">';
            rHtml += '  <div><span class="mem_list mgR10"><span class="thumb mini"><span lang="ko" class="initial_profile" style="background-color: rgb(134, 164, 212);"><em>'+rInitial+'</em></span></span>';
            rHtml += '  <span class="name_info"><span class="name_txt">'+reply.WriteUserNM+'</span>'+nameEN+'</span></span>';
            rHtml += '  <span class="reply_regDT">'+reply.RegDT+'</span></div>';
            rHtml += '  <div class="reply_btn">';
            if (sessionUserId == reply.RegUserID) {
                rHtml += '      <button type="button" onclick="editComment('+reply.BoardID+', \'${ItemID}\', '+reply.RegUserID+')" class="cmm-btn" style="border-right: 1px solid #dfdfdf;">Edit</button>';
                rHtml += '      <button type="button" onclick="deleteComment(\''+reply.BoardID+'\', \'${ItemID}\')" class="cmm-btn">Del</button>';
            }
            rHtml += '  </div>';
            rHtml += '</li>';
            rHtml += '<li class="flex align-center justify-between"></li>';
            rHtml += '<li class="flex justify-between mgT10 mgL23" id="reply_content' + reply.BoardID + '"><p>'+(reply.Content || "")+'</p></li>';
            
            // Reply files
            var rfHtml = "";
            var f_size = 0;
            fileList.forEach(function(f) {
                if (f.BoardID == reply.BoardID) {
                    f_size++;
                    var ext = (f.FileName || "").split('.').pop().toLowerCase();
                    var iconClass = "log";
                    if (ext.includes("do")) iconClass = "doc";
                    else if (ext.includes("xl")) iconClass = "xls";
                    else if (ext.includes("pdf")) iconClass = "pdf";
                    else if (ext.includes("hw")) iconClass = "hwp";
                    else if (ext.includes("pp")) iconClass = "ppt";
                    
                    rfHtml += '<li onclick="fileNameClick(\'' + f.Seq + '\')" id="reply_file' + f.Seq + '" class="flex icon_color_inherit justify-between mm align-center">';
                    rfHtml += '<span><span class="btn_pack small icon mgR30"><span class="'+iconClass+'"></span></span><span style="line-height:24px;">'+f.FileRealName+'</span></span>';
                    rfHtml += '<i class="mdi mdi-window-close" onclick="fnDeleteItemFile(\''+f.BoardID+'\',\''+f.Seq+'\')" style="display:none;"></i>';
                    rfHtml += '</li>';
                }
            });
            if (f_size !== 0) {
                rHtml += '<ul class="file_box mgT10 mgL23" id="tmp_file_items' + reply.BoardID + '">' + rfHtml + '</ul>';
            }
            rHtml += '</ul>';
        });
        document.getElementById("reply_list_area").innerHTML = rHtml;

        // Reply Box display logic
        var replyOption = res.replyOption || "";
        var itemAuthorID = (res.ItemMgtUserMap && res.ItemMgtUserMap.AuthorID) ? res.ItemMgtUserMap.AuthorID : "";
        var mgtUserID = (res.BoardMgtInfo && res.BoardMgtInfo.MgtUserID) ? res.BoardMgtInfo.MgtUserID : "";

        if (boardMap.Blocked != "1") {
            if (replyOption == "0") document.getElementById("register_box").style.display = "block";
            if (replyOption == "1" && (itemAuthorID == sessionUserId || boardMap.ReplyFlag == 'T')) document.getElementById("register_box").style.display = "block";
            if (replyOption == "2" && (mgtUserID == sessionUserId || boardMap.ReplyFlag == 'T')) document.getElementById("register_box").style.display = "block";
            if ("${mailRcvListSQL}" != "review" && replyOption == "3" && boardMap.ReplyFlag == 'T') document.getElementById("register_box").style.display = "block";
            if ("${mailRcvListSQL}" == "review" && replyOption == "3") {
                if (boardMap.sharerIDs) {
                    var sharerArray = boardMap.sharerIDs.split(',');
                    if (sharerArray.includes(sessionUserId)) {
                        document.getElementById("register_box").style.display = "block";
                    }
                }
            }
        }
        
        document.getElementById("reply_user_name").innerText = sessionUserNm;

        // Init Editor UX
        const inputTarget = document.getElementById("input_target");
        if (inputTarget) {
            inputTarget.addEventListener("focus", (e) => {
                e.target.parentNode.className = "scroll_box writing"
            });
            inputTarget.addEventListener("blur", (e) => {
                if(e.target.innerHTML.replaceAll('<br>','') != "") {
                    e.target.parentNode.className = "scroll_box writing"
                } else {
                    e.target.parentNode.className = "scroll_box"
                }
            });
        }
    }

    function fileNameClick(seq) {
        var url = "fileDown.do?seq=" + seq + "&scrnType=BRD";
        document.getElementById("saveFrame").src = url;
    }

    function goBack() {
        var url = "boardForumList.do";
        var boardTitleVal = document.getElementById("boardTitle_span") ? document.getElementById("boardTitle_span").innerText : "${forumDTO.boardTitle}";
        var emailCodeVal = document.getElementById("emailCode") ? document.getElementById("emailCode").value : "${forumDTO.emailCode}";
        var replyMailOptionVal = document.getElementById("replyMailOption") ? document.getElementById("replyMailOption").value : "${forumDTO.replyMailOption}";

        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
                 + "&category=${forumDTO.category}"
                 + "&pageNum=${forumDTO.pageNum}"
                 + "&noticType=${forumDTO.noticType}"
                 + "&BoardMgtID=${forumDTO.boardMgtID}"
                 + "&isMyCop=${forumDTO.isMyCop}"
                 + "&scStartDt=${forumDTO.scStartDt}"
                 + "&scEndDt=${forumDTO.scEndDt}"
                 + "&searchType=${forumDTO.searchType}"
                 + "&searchValue=${forumDTO.searchValue}"
                 + "&ItemTypeCode=${forumDTO.itemTypeCode}"
                 + "&mailRcvListSQL=${forumDTO.mailRcvListSQL}"
                 + "&emailCode=" + emailCodeVal
                 + "&replyMailOption=" + replyMailOptionVal
                 + "&forumMailOption=${forumDTO.forumMailOption}"
                 + "&showReplyDT=${forumDTO.showReplyDT}"
                 + "&openDetailSearch=${forumDTO.openDetailSearch}"
                 + "&screenType=${forumDTO.screenType}"
                 + "&projectID=${forumDTO.projectID}"
                 + "&listType=${forumDTO.listType}"
                 + "&srID=${forumDTO.srID}"
                 + "&srType=${forumDTO.srType}"
                 + "&regUserName=${forumDTO.regUserName}"
                 + "&authorName=${forumDTO.authorName}"
                 + "&myBoard=${forumDTO.myBoard}"
                 + "&showItemInfo=${forumDTO.showItemInfo}"
                 + "&scrnType=${forumDTO.scrnType}"
                 + "&boardTitle=" + encodeURIComponent(boardTitleVal)
                 + "&dueDateMgt=${forumDTO.dueDateMgt}"
                 + "&showAuthorInfo=${forumDTO.showAuthorInfo}"
                 + "&showItemVersionInfo=${forumDTO.showItemVersionInfo}";
                 
        if("${forumDTO.srID}" != null && "${forumDTO.srID}" != ''){
            data += "&srCategory=${forumDTO.srCategory}&subject=${forumDTO.subject}";
            data += "&startRegDT=${forumDTO.startRegDT}&endRegDT=${forumDTO.endRegDT}&searchSrCode=${forumDTO.searchSrCode}";
            data += "&receiptUser=${forumDTO.receiptUser}&requestUser=${forumDTO.requestUser}&requestTeam=${forumDTO.requestTeam}";
            data += "&srReceiptTeam=${forumDTO.srReceiptTeam}&searchStatus=${forumDTO.searchStatus}";
        }
        
        if("${forumDTO.listType}" == 1) {
            data = data + "&s_itemID=" + "${forumDTO.s_itemID}";
        }
        
        ajaxPage(url, data, "help_content");
    }

    function deleteComment(boardID, ItemID) {
        if (!confirm("${CM00002}")) {
            return;
        }

        var url = "deleteBoardComment.do";
        var formData = new FormData();
        formData.append("boardID", boardID);
        formData.append("parentID", "${boardID}");

        fetch(url, {
            method: 'POST',
            body: new URLSearchParams(formData)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok: ' + response.statusText);
            }
            return response.json();
        })
        .then(json => {
            if (json.result === "success") {
                alert(json.message);
                fnGetForumDetail(); // Reload the post details and comments
            } else {
                alert(json.message || "An error occurred while deleting the comment.");
                console.error("Error:", json.message);
            }
        })
        .catch(error => {
            alert("An error occurred. Check the console for details.");
            console.error("Fetch Error:", error);
        });
    }

    function actionForum(avg){
        var confirmStr = "${CM00005}";
        var actionUrl =  "boardListInfoMgt.do";
        var target = "help_content";
        
        if(avg == "del"){
            confirmStr = "${CM00002}";
            actionUrl = "boardForumDelete.do";
        }
        
        var boardTitleVal = document.getElementById("boardTitle_span") ? document.getElementById("boardTitle_span").innerText : "${forumDTO.boardTitle}";
        var emailCodeVal = document.getElementById("emailCode") ? document.getElementById("emailCode").value : "${forumDTO.emailCode}";
        var replyMailOptionVal = document.getElementById("replyMailOption") ? document.getElementById("replyMailOption").value : "${forumDTO.replyMailOption}";
        
        // Backend fails validation if boardIds is completely empty. Fallback to current boardID.
        var boardIdsVal = "${forumDTO.boardIds}";
        if (!boardIdsVal) {
            boardIdsVal = boardId;
        }

        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}" 
            + "&noticType="+$('#noticType').val() 
            + "&BoardID=" + boardId
            + "&BoardMgtID=" + mgtId
            + "&s_itemID="+$('#s_itemID').val()
            + "&ItemID="+$('#ItemID').val()
            + "&filter="+$('#filter').val()
            + "&pageNum="+$("#currPage").val()
            + "&noticType=${forumDTO.noticType}"
            + "&isMyCop=${forumDTO.isMyCop}"
            + "&category=${forumDTO.category}"
            + "&categoryIndex=${forumDTO.categoryIndex}"
            + "&categpryCnt=${forumDTO.categoryCnt}"
            + "&searchType=${forumDTO.searchType}"+"&searchValue=${forumDTO.searchValue}"
            + "&scStartDt=${forumDTO.scStartDt}"+"&scEndDt=${forumDTO.scEndDt}"
            + "&listType=${forumDTO.listType}"
            + "&screenType=${forumDTO.screenType}"
            + "&emailCode=" + emailCodeVal
            + "&replyMailOption=" + replyMailOptionVal
            + "&forumMailOption=${forumDTO.forumMailOption}"
            + "&showReplyDT=${forumDTO.showReplyDT}"
            + "&openDetailSearch=${forumDTO.openDetailSearch}"
            + "&mailRcvListSQL=${forumDTO.mailRcvListSQL}"
            + "&srID=${forumDTO.srID}"
            + "&srType=${forumDTO.srType}"
            + "&showItemInfo=${forumDTO.showItemInfo}"
            + "&scrnType=${forumDTO.scrnType}"
            + "&boardTitle="+encodeURIComponent(boardTitleVal)
            + "&myBoard=${forumDTO.myBoard}"
            + "&boardIds=" + boardIdsVal
            + "&fileTokenYN=Y"
            + "&dueDateMgt=${forumDTO.dueDateMgt}&showAuthorInfo=${forumDTO.showAuthorInfo}&showItemVersionInfo=${forumDTO.showItemVersionInfo}";

        if(avg !== "del") {
            data += "&url=/board/frm/editForumPostV4";
        }

        if(confirm(confirmStr)){
            ajaxPage(actionUrl, data, target);
        }
    }

    function saveReply() {
        var commentContent = document.getElementById("input_target").innerText.replaceAll("\n","<br>");
        document.getElementById("content_new").value = commentContent;
        document.getElementById("boardID").value = "";

        if(confirm("${CM00001}")){
            var actionUrl = "saveForumReply.do";
            ajaxSubmitNoAdd(document.formDetailFrm, actionUrl, "saveFrame");
        }
    }

    function boardClose() {
        if(confirm("${CM00016}")){
            fetch(`/blockedForum.do?type=board&blocked=1&replyMailOption=${replyMailOption}&s_itemID=${s_itemID}&postEmailYN=`+(currentBoardMap.PostEmailYN||'')+`&boardID=${boardID}&regUserID=`+(currentBoardMap.RegUserID||'')+`&itemAuthorID=`+(currentBoardMap.itemAuthorID||'')+`&scheduleID=`+(currentBoardMap.ScheduleID||'')+`&emailCode=REQITMCLS&userID=`+sessionUserId+`&mailRcvListSQL=${mailRcvListSQL}&BoardMgtID=${BoardMgtID}`)
            .then((response) => response.json())
            .then((json) => {
                if(json.result == "success") alert("${WM00067}");
                if(json.result == "failed") alert("${WM00068}");
                doReturn();
            });
        }
    }

    function fnOpenItemPop(itemID){
        var changeSetID = currentBoardMap.BrdChangeSetID || "";
        var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
        if (changeSetID != "") url = url + "&option=CNGREW&changeSetID="+changeSetID;
        var w = 1200;
        var h = 900;
        itmInfoPopup(url,w,h,itemID);
    }

    // Variables for file attachment
    var currentFileList = [];
    var attachReplyFileSeq = "";
    var fileIDMapV4 = new Map();
    var fileNameMapV4 = new Map();

    function extractFileRealNamesToSet(arr, boardId) {
        if (!arr || arr.length === 0) return new Set();
        if (boardId) {
            const arrFilteredByBoardId = arr.filter(item => item.BoardID == boardId);
            return new Set(arrFilteredByBoardId.map(item => item.FileRealName));
        } else {
            return new Set(arr.map(item => item.FileRealName));
        }
    }

    function openDhxVaultModal(seq) {
        boardId = seq || "";
        attachReplyFileSeq = seq || "";
        
        if (seq) {
            previousAddedFileNames = extractFileRealNamesToSet(currentFileList, seq);
        } else {
            previousAddedFileNames = new Set();
        }
        if (typeof newFileWindow !== "undefined") {
            newFileWindow.show();
        } else {
            console.error("newFileWindow is not defined. fileAttachWindow.jsp might not be loaded properly.");
        }
    }

    function fnAttacthFileHtmlV4(fileID, fileName){
        fileID = fileID.replace("u","");
        fileIDMapV4.set(fileID,fileID);
        fileNameMapV4.set(fileID,fileName);
    }

    function fnDeleteFileMapV4(fileID, removeAll){ 
        if(removeAll == "Y"){
            fileIDMapV4 = new Map();
            fileNameMapV4 = new Map();
        }else{
            fileID = fileID.replace("u","");        
            fileIDMapV4.delete(String(fileID));
            fileNameMapV4.delete(String(fileID));
        }
    }

    function fnDisplayTempFileV4(){
        var targetUl;
        if(attachReplyFileSeq) {
            var editBox = document.querySelector("#editBox_" + attachReplyFileSeq);
            if(editBox && !editBox.querySelector("#tmp_file_items" + attachReplyFileSeq + ".tmp_file_items")) {
                editBox.firstChild.innerHTML += '<ul class="file_box mgB15 mgL15 mgT10 tmp_file_items" id="tmp_file_items' + attachReplyFileSeq + '" style="display: block;"></ul>';
            }
            targetUl = document.querySelector("#tmp_file_items" + attachReplyFileSeq + ".tmp_file_items");
        } else {
            targetUl = document.getElementById("tmp_file_items");
        }
        
        if (!targetUl) return;
        targetUl.style.display = "block";
        var display_scripts = targetUl.innerHTML;
        
        let fileFormat = "";
        fileIDMapV4.forEach(function(fileID) {
            fileFormat = (fileNameMapV4.get(fileID) || "").split(".").pop().toLowerCase();
            switch (true) {
                case fileFormat.includes("do") : fileFormat = "doc"; break;
                case fileFormat.includes("xl") : fileFormat = "xls"; break;
                case fileFormat.includes("pdf") : fileFormat = "pdf"; break;
                case fileFormat.includes("hw") : fileFormat = "hwp"; break;
                case fileFormat.includes("pp") : fileFormat = "ppt"; break;
                default : fileFormat = "log"
            }
            display_scripts += 
                '<li id="' + fileID + '" class="flex icon_color_inherit justify-between mm align-center" name="' + fileID + '">' + 
                '<span><span class="btn_pack small icon mgR30"><span class="' + fileFormat + '"></span></span>' +
                '<span style="line-height:24px;">' + fileNameMapV4.get(fileID) + '</span></span>' +
                '   <i class="mdi mdi-window-close" onclick="fnDeleteFileHtmlV4(\'' + fileID + '\', true)" style="cursor:pointer;"></i>' +
                '</li>';    
        });
        
        targetUl.innerHTML = display_scripts;
        fileIDMapV4 = new Map();
        fileNameMapV4 = new Map();
    }

    function fnDeleteFileHtmlV4(fileID, doDeleteFromVault){            
        var fileEl = document.getElementById(fileID);
        var fileName = fileEl ? fileEl.innerText : null;
        
        fileIDMapV4.delete(String(fileID));
        fileNameMapV4.delete(String(fileID));
        
        if(fileEl){
            fileEl.remove();
            
            if (doDeleteFromVault && typeof vault !== 'undefined' && vault !== null){
                try {
                    var vaultFileId = "u" + fileID;
                    var vaultFile = vault.data.getItem(vaultFileId);
                    if(vaultFile){
                        vault.data.remove(vaultFileId);
                    }
                } catch(e) {
                    console.error("Vault Error:", e);
                }
            }
        }
        
        var targetUl = attachReplyFileSeq ? document.querySelector("#tmp_file_items" + attachReplyFileSeq + ".tmp_file_items") : document.getElementById("tmp_file_items");
        if (targetUl && !targetUl.innerHTML.trim()) {
            targetUl.style.display = "none";
        }
    }

    function editComment(seq, ItemID, regUserID) {  
        // 다른 편집기 삭제
        document.querySelectorAll(".edit_box").forEach((e) => {
            e.remove();
        });
        
        // display:none -> 원복
        document.querySelectorAll(".reply_list").forEach((item) => {
            for(let i=0; i< item.children.length; i++) {
                if(item.children[i].hasAttribute("id")) {
                    item.children[i].style.display = "";
                }
            }
        });

        // 편집기로 바꾸기
        document.querySelector("#reply_content"+seq).style.display = "none";
        const replyContent = document.querySelector("#reply_content"+seq+" p").innerHTML;
        
        let replyFile = "";
        if(document.querySelector("#tmp_file_items"+seq)) {
            document.querySelector("#tmp_file_items"+seq).style.display = "none";
            replyFile = document.querySelector("#tmp_file_items"+seq).outerHTML;
        }
        
        const registerBox = '<div id="editBox_'+seq+'" class="edit_box mgL23"><div class="wrapper mgT10">'+
                '<div class="scroll_box writing" id="scroll_target">'+
                    '<div class="input_box pdT10" id="input_target'+seq+'" contenteditable="true">'+replyContent+'</div>'+
                    '<span class="placeholder pdT10">Please enter a comment</span>'+
                '</div>'+
                replyFile.replace('ul class="file_box mgT10 mgL23"','ul class="file_box mgB15 mgL15 mgT10 mgL23 tmp_file_items"').replaceAll('none','block').replaceAll("reply_file","tmp_file")+
            '</div>'+
            '<div class="btn_box">'+
                '<div class="attach_btns icon_color_inherit" onclick="openDhxVaultModal('+seq+')" style="cursor:pointer"><i class="mdi mdi-paperclip"></i></div>'+
                '<div class="register_btns">'+
                    '<button type="button" class="point cancel" id="reply-cancel">Cancel</button>'+
                    '<button type="button" class="point" id="edit">Input</button>'+
                '</div>'+
            '</div></div>';
        document.querySelector("#reply_list"+seq).innerHTML += registerBox;
        
        const inputTarget = document.getElementById("input_target"+seq);
        inputTarget.addEventListener("focus", (e) => {
            e.target.parentNode.className = "scroll_box writing"
        });

        inputTarget.addEventListener("blur", (e) => {
            if(e.target.innerHTML.replaceAll('<br>','') != "") {
                e.target.parentNode.className = "scroll_box writing"
            } else {
                e.target.parentNode.className = "scroll_box"
            }
        });
        
        // 취소 버튼 클릭시 이벤트
        document.querySelector("#reply-cancel").addEventListener("click", (btn) => {
            const editReplyBox = btn.target.parentNode.parentNode.parentNode;
            const showSeq = editReplyBox.getAttribute("id");
            editReplyBox.remove();
            document.querySelector("#reply_content"+showSeq.split("_")[1]).style.display = "";
            if(document.querySelector("#tmp_file_items"+seq)) document.querySelector("#tmp_file_items"+showSeq.split("_")[1]).style.display = "";
        });
        
        document.querySelector("#edit").addEventListener("click", (btn) => {
            const editReplyBox = btn.target.parentNode.parentNode.parentNode;
            const showSeq = editReplyBox.getAttribute("id");
            const commentContent = document.getElementById("input_target"+showSeq.split("_")[1]).innerText.replaceAll("\n","<br>");
            document.getElementById("content_new").value = commentContent;
            document.getElementById("boardID_form").value = seq;
            if(confirm("${CM00001}")){
                var actionUrl = "saveForumReply.do";
                ajaxSubmitNoAdd(document.formDetailFrm, actionUrl, "saveFrame");
            }
        });
    }

    function removeBySeqInPlace(arr, seqValue) {
        if (!arr || !Array.isArray(arr)) return arr;
        let originalLength = arr.length;
        for (let i = arr.length - 1; i >= 0; i--) {
            if (arr[i].Seq == seqValue) {
                arr.splice(i, 1);
            }
        }
        return arr;
    }

    function fnDeleteItemFile(BoardID, seq){
        fileObjArray = removeBySeqInPlace(currentFileList, seq);
        previousAddedFileNames = extractFileRealNamesToSet(fileObjArray);
        
        if (document.querySelector("#tmp_file"+seq)) {
            document.querySelector("#tmp_file"+seq).onclick = "";
        }
        
        var url = "boardFileDelete.do";
        var data = "&delType=1&BoardID="+BoardID+"&Seq="+seq;
        ajaxPage(url, data, "saveFrame");
        
        if (document.querySelector("#tmp_file"+seq)) {
            document.querySelector("#tmp_file"+seq).remove();
        }
        if (document.querySelector("#reply_file"+seq)) {
            document.querySelector("#reply_file"+seq).remove();
        }
        
        document.querySelectorAll(".file_box").forEach((item) => {
            if(item.innerText == "") item.style.display = "none";
        });
    }

    window.fnCallBack = function(parentID, s_itemID) {
        var boardTitleVal = document.getElementById("boardTitle_span") ? document.getElementById("boardTitle_span").innerText : "${boardTitle}";
        var emailCodeVal = document.getElementById("emailCode") ? document.getElementById("emailCode").value : "${emailCode}";
        var replyMailOptionVal = document.getElementById("replyMailOption") ? document.getElementById("replyMailOption").value : "${replyMailOption}";
        
        var data = "NEW=N&boardMgtID=${BoardMgtID}&noticType=${noticType}&boardID=" + parentID
            + "&emailCode=" + emailCodeVal
            + "&replyMailOption=" + replyMailOptionVal
            + "&forumMailOption=${forumMailOption}"
            + "&showReplyDT=${showReplyDT}"
            + "&openDetailSearch=${openDetailSearch}"
            + "&mailRcvListSQL=${mailRcvListSQL}"
            + "&itemID=" + s_itemID + "&s_itemID=" + s_itemID + "&pageNum=${pageNum}&isMyCop=${isMyCop}&listType=${listType}&boardIds=${boardIds}"
            + "&showItemInfo=${showItemInfo}&dueDateMgt=${dueDateMgt}&showAuthorInfo=${showAuthorInfo}&showItemVersionInfo=${showItemVersionInfo}"
            + "&srID=${srID}&srType=${srType}&scrnType=${scrnType}&boardTitle=" + encodeURIComponent(boardTitleVal) + "&myBoard=${myBoard}"
            + "&url=board/frm/viewForumPostV4";
            
        var url = "boardListInfoMgt.do";
        var target = "help_content";
        ajaxPage(url, data, target);
    };

    window.doReturn = function() {
        // 1. 댓글 입력창 텍스트 초기화
        var inputTarget = document.getElementById("input_target");
        if(inputTarget) {
            inputTarget.innerHTML = "";
            inputTarget.parentNode.className = "scroll_box";
        }

        // 2. 화면에 표시된 임시 파일 목록 UI 초기화
        var tempFileItems = document.getElementById("tmp_file_items");
        if (tempFileItems) {
            tempFileItems.innerHTML = "";
            tempFileItems.style.display = "none"; 
        }

        // 3. 파일 첨부 컴포넌트(vault)의 내부 데이터 완전 초기화
        if (typeof vault !== 'undefined' && vault !== null) {
            vault.data.removeAll();
        }

        // 4. ?꾩떆 ?꾩슦誘?蹂??珥덇린??n        fnDeleteFileMapV4(null, "Y");

        // 5. 寃뚯떆湲 諛??볤? 紐⑸줉 ?덈줈怨좎묠
        fnGetForumDetail();
    };

    window.fnCallBackDel = function() {
        goBack();
    };
    
    window.thisReload = function(boardID, s_itemID) {
        fnGetForumDetail();
    };

</script>

<div class="pdB15 mgT10" style="width: 80%; margin: 0 auto;">
<form name="formDetailFrm" id="formDetailFrm" method="post" onsubmit="return false;" enctype="multipart/form-data">
    <input type="hidden" id="uploadToken" name="uploadToken" value="${forumDTO.uploadToken}">
    <input type="hidden" id="s_itemID" name="s_itemID" value="${forumDTO.s_itemID}">
    <input type="hidden" id="filter" name="filter" value="edit">
    <input type="hidden" id="boardID" name="boardID">
    <input type="hidden" id="noticType" name="noticType" value="${forumDTO.noticType}">
    <input type="hidden" id="userId" name="userId" value="${sessionScope.loginInfo.sessionUserId}">
    <input type="hidden" id="regId" name="regId" value="">
    <input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
    <input type="hidden" id="ItemID" name="ItemID" value="${forumDTO.itemID}">
    <input type="hidden" id="score" name="score" value="${forumDTO.score}">
    <input type="hidden" id="currPage" name="currPage" value="${forumDTO.pageNum}">
    <input type="hidden" id="refID" name="refID" value="">
    <input type="hidden" id="BoardMgtID" name="BoardMgtID" value="${forumDTO.boardMgtID}">
    <input type="hidden" id="screenType" name="screenType" value="${forumDTO.screenType}">
    <input type="hidden" id="likeInfo" name="likeInfo" value="">
    <input type="hidden" id="itemTypeCode" name="itemTypeCode" value="${forumDTO.itemTypeCode}">
    <input type="hidden" id="replyLev" name="replyLev" value="1">
    <input type="hidden" id="parentRefID" name="parentRefID" value="">
    <input type="hidden" id="content_new" name="content_new" value="">
    <input type="hidden" id="parentID" name="parentID" value="${forumDTO.boardID}">
    <input type="hidden" id="mailRcvListSQL" name="mailRcvListSQL" value="${forumDTO.mailRcvListSQL}">
    <input type="hidden" id="emailCode" name="emailCode" value="${forumDTO.emailCode}">
    <input type="hidden" id="replyMailOption" name="replyMailOption" value="${forumDTO.replyMailOption}">
    <input type="hidden" id="forumMailOption" name="forumMailOption" value="${forumMailOption}">
    <input type="hidden" id="memberID" name="memberID" value="">
    <input type="hidden" id="subject" name="subject" value="">
    <input type="hidden" id="scheduleID" name="scheduleID" value="">
    <input type="hidden" id="showReplyDT" name="showReplyDT" value="${forumDTO.showReplyDT}">
    <input type="hidden" id="openDetailSearch" name="openDetailSearch" value="${forumDTO.openDetailSearch}">
    <input type="hidden" id="showAuthorInfo" name="showAuthorInfo" value="${forumDTO.showAuthorInfo}">
    <input type="hidden" id="showItemVersionInfo" name="showItemVersionInfo" value="${forumDTO.showItemVersionInfo}">

    <div class="align-center flex justify-between pdT20 pdB10"  style="border-bottom: 1px solid #dfdfdf;">
        <p style="font-size: 13px;color: #8d8d8d;" id="boardTitle_span"></p>
        <button type="button" class="cmm-btn" style="height: 32px;" onclick="goBack()">List</button>
    </div>
    
    <div class="subject" id="subject_div"></div>
    <div style="border-bottom: 1px solid #dfdfdf;">
        <div class="align-center flex justify-between mgT5 pdB20">
            <div class="flex">
                <span class="mem_list">
                    <span class="thumb mini">
                        <span lang="ko" class="initial_profile" style="background-color: #4265ee;">
                            <em id="author_initial"></em>
                        </span>
                    </span>
                     <span class="name_info"><span class="name_txt" id="author_name"></span></span>
                </span>
                <span class="lastUpdated pdL10" id="last_updated"></span>
                <div class="flex view_count icon_color_inherit mgL30"><i class='mdi mdi-eye-outline mgR10'></i><span id="read_count"></span></div>
            </div>
            <div class="flex" id="path_item_area"></div>
        </div>
        
        <div class="align-center flex justify-between mgT5 pdB20">
            <ul id="category_info_ul" style="width: 100%;"></ul>
        </div>
        <div id="sharer_area"></div>
    </div>
    
    <div class="mgB50 mgT25" style="color:#000;min-height: 80px;" id="content_area"></div>
    
    <div class="mgB25" style="display:block;" id="bottom_file_box_area">
        <div class="flex justify-between align-end" id="bottom_flex_area">
            <div id="bottom_buttons">
                <button type="button" id="btn_complete" class="cmm-btn mgR5" style="height: 32px; width:100px; display:none;" onclick="boardClose()">완료</button>
                <button type="button" id="btn_edit" class="cmm-btn mgR5" style="height: 32px; display:none;" onclick="actionForum('edit')">Edit</button>
                <button type="button" id="btn_del" class="cmm-btn mgR5" style="height: 32px; display:none;" onclick="actionForum('del')">Del</button>
                <button type="button" id="btn_change_item" class="cmm-btn mgR5" style="height: 32px; display:none;">Change Item</button>
            </div>
        </div>
    </div>

    <!-- Comment -->
    <div class="reply_box">
        <p>Reply<span style="color:#4265ee;">&nbsp;<span id="reply_count_span"></span></span></p>
        <div id="reply_list_area"></div>
    </div>
    
    <div class="register_box" id="register_box" style="display:none;">
        <div class="wrapper">
            <div class="user_Name" id="reply_user_name"></div>
            <div class="scroll_box" id="scroll_target">
                <div class="input_box" id="input_target" contenteditable="true"></div>
                <span class="placeholder">Please enter a comment</span>
            </div>
            <ul id="tmp_file_items" name="tmp_file_items" class="file_box mgB15 mgL15 mgT10 tmp_file_items"></ul>
        </div>
        <div class="btn_box">
            <div class="attach_btns icon_color_inherit" onclick="openDhxVaultModal()" style="cursor:pointer"><i class='mdi mdi-paperclip'></i></div>
            <div class="register_btns">
                <button type="button" class="point" id="send" onclick="saveReply()">Input</button>
            </div>
        </div>
    </div>
    
    <div class="flex align-center justify-between mgT20 pdB10">
        <div></div>
        <div>
            <button type="button" class="cmm-btn mgR5" id="prev" style="height: 32px;"><span class="arrow-left mgR5"></span>Prev</button>
            <button type="button" class="cmm-btn mgR5" id="next" style="height: 32px;">Next<span class="arrow-right mgL5"></span></button>
            <button type="button" class="cmm-btn mgR5" style="height: 32px;" onclick="goBack()">List</button>
            <button type="button" class="cmm-btn" id="top" style="height: 32px;">top</button>
        </div>
    </div>
</form> 
</div>
<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
