<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Item Info View</title>

    <%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
    <jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
    <link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />

    <style>
        #itemDiv > div { padding : 0 10px; }
        #refresh:hover { cursor:pointer; }
        .tdhidden { display:none; }
        #maintext table { border: 1px solid #ccc; width:100%; }
        #maintext th { text-align: left; padding: 10px; color: #000; font-weight: bold; }
        #maintext td { display: block; padding: 10px; overflow-x: auto; line-height: 18px; }
        #maintext textarea { width: 100%; resize:none; }
        #itemNameAndPath, #functions { display:inline; }
        .cont_title { font-size: 15px; font-weight: bold; padding: 10px 0; margin-bottom: 10px; border-bottom: 1px solid #ccc; }
    </style>

    <script type="text/javascript">
        var chkReadOnly = true; 
        var languageID = `${sessionScope.loginInfo.sessionCurrLangType}`;
        var s_itemID = `${s_itemID}`;
        var changeSetID = `${changeSetID}`;
        var accMode = `${accMode}`;
        var cxnTypeList = `${cxnTypeList}`;
        var notInCxnClsList = `${notInCxnClsList}`;
        var hideBlocked = `${hideBlocked}`;
        var isSubItem = `${isSubItem}`;
    </script>
    
    <script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

    <script type="text/javascript">
        $(document).ready(function(){       
            // 데이터 렌더링 호출
            renderItemNameAndPath(s_itemID, changeSetID); 
            renderRoleList();
            renderRelItemList();
            renderFileList();
            
            $(".chkbox").click(function() {
                if($(this).is(':checked')) {
                    $("#"+this.name).show();
                } else {
                    $("#"+this.name).hide(300);
                }
            });
            
            $("input:checkbox:not(:checked)").each(function(){
                $("#"+$(this).attr("name")).css('display','none');
            });

            modelView();
                 
            var currIdx = "${currIdx}";
            if(currIdx == "" || currIdx == "undefined"){ currIdx = "0"; }
            
            var itemIDs = getCookie('itemIDs').split(','); 
            if(typeof fnOpenItems === 'function') fnOpenItems(currIdx, itemIDs);
        });
        
        function modelView(){
            var browserType = "";
            var IS_IE11 = !!navigator.userAgent.match(/Trident\/7\./);
            if(IS_IE11){ browserType = "IE11"; }
            // Diagram 관련 로직 (필요 시 구현)
        }
        
        /* 파일 다운로드 및 클릭 이벤트 */
        function fileNameClick(avg1, avg2, avg3, avg4, avg5){
            var seq = avg4;
            if(avg3 == "VIEWER") {
                var url = "openViewerPop.do?seq="+seq;
                var w = screen.width;
                var h = screen.height;
                url += (avg5 != "") ? "&isNew=N" : "&isNew=Y";
                window.open(url, "Mnado", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
            } else {
                var url = "fileDownload.do?seq="+seq;
                ajaxSubmitNoAdd(document.frontFrm, url, "saveFrame");
            }
        }
        
        function clickItemEvent(itemID) {
            var url = "itemMainMgt.do?languageID=" + languageID + "&s_itemID=" + itemID + "&scrnType=pop&itemMainPage=itm/itemInfo/itemMainMgt";
            window.open(url, "", "width=1200, height=900, top=100,left=100,toolbar=no,status=no,resizable=yes");
        }

        function clickItemEvent2(trObj) {
            var classCode = $(trObj).find("#classCode").text();      
            var masterIden = $(trObj).find("#masterKey").text();
            var url = "https://ivell.hec.co.kr/member-popup/ve-pj/qi/detail?masterIden="+masterIden;
            if(classCode == "CL12003") url = "https://ivell.hec.co.kr/member-popup/ll/master-detail-view?masterIden="+masterIden;
            window.open(url, "", "width=1200, height=900, top=100,left=100,toolbar=no,status=no,resizable=yes");
        }
        
    	function fnGoReportList() {
    		var url = "objectReportList.do";
    		var target = "itemDescriptionDIV";
    		var accMode = $("#accMode").val();
    		var data = "s_itemID=${itemID}&option=${option}&kbn=newItemInfo&accMode="+accMode; 
    		$("#itemDescriptionDIV").css('display','block');
    		$("#itemDiv").css('display','none');
    		ajaxPage(url, data, target);
    	}
    	

        function fnEditItemInfo() {
            var url = "itemMainMgt.do";
            var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"; 
            ajaxPage(url, data, "processItemInfo");
        }
    	
    	function fnGoChangeMgt() {
    		var url = "itemHistoryV4.do";
    		var target = "itemDescriptionDIV";
    		var data = "s_itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myItem=${myItem}&itemStatus=${itemStatus}&backBtnYN=N";
    		
    		$("#itemDescriptionDIV").css('display','block');
    		$("#itemDiv").css('display','none');
    		ajaxPage(url, data, target);
    	}
    	
    	function fnGoForumMgt(){
    		var url = "forumMgt.do";
    		var target = "itemDescriptionDIV";
    		var data = "&s_itemID=${itemID}&BoardMgtID=4";
    		
    		$("#itemDescriptionDIV").css('display','block');
    		$("#itemDiv").css('display','none');
    		ajaxPage(url, data, target);
    	}
    	function fnGoForumMgt2(){
    		var url = "forumMgt.do";
    		var target = "itemDescriptionDIV";
    		var data = "&s_itemID=${itemID}&BoardMgtID=BRD110&varFilter=BRD110";
    		
    		$("#itemDescriptionDIV").css('display','block');
    		$("#itemDiv").css('display','none');
    		ajaxPage(url, data, target);
    	}
    	
        /* 비동기 렌더링 함수들 */
        async function renderItemNameAndPath(itemID, changeSetID){
            let sqlID = (accMode === 'OPS') ? "item_SQL.getItemAttrRevInfo" : "report_SQL.getItemInfo";
            const requestData = { languageID, s_itemID : itemID, changeSetID , sqlGridList: 'N', sqlID };
            const params = new URLSearchParams(requestData).toString();
            try {
                const response = await fetch("getData.do?" + params);
                const result = await response.json();
                if (result && result.data) {
                    const div = document.getElementById("itemNameAndPath");
                    const info = result.data[0];
                    const isSpecial = ['MCN', 'CN', 'CN1'].includes(info.CategoryCode);
                    let html = "";
                    if (isSpecial) {
                        html = `<img src="${root}${HTML_IMG_DIR_ITEM}\${info.FromItemTypeImg}" onclick="fnOpenParentItemPop('\${info.FromItemID}');" style="cursor:pointer;vertical-align: text-top;"> &nbsp;\${info.FromItemName}
                                <img src="${root}${HTML_IMG_DIR_ITEM}\${info.ToItemTypeImg}" onclick="fnOpenParentItemPop('\${info.ToItemID}');" style="cursor:pointer;vertical-align: text-top;"> &nbsp;\${info.ToItemName}`;
                        if(info.ItemName !== '') html += `/<font color="#3333FF"><b>\${info.ItemName}</b></font>`;
                    } else {
                        html = `<img src="${root}${HTML_IMG_DIR_ITEM}\${info.ItemTypeImg}" onclick="fnOpenParentItemPop('\${itemID}');" style="cursor:pointer;vertical-align: text-top;">
                                <b style="font-size:13px;">\${info.Identifier}&nbsp;\${info.ItemName}</b>
                                <p id="pathContainer" style="display:inline-block;"></p>`;
                    }
                    div.innerHTML = html;
                    await renderRootItemPath(itemID); 
                }
            } catch (e) { console.error(e); }
        }

        async function renderRootItemPath(itemID){
            const params = new URLSearchParams({ itemID, languageID }).toString();
            try {
                const response = await fetch("getRootItemPath.do?" + params);
                const result = await response.json();
                if (result && result.data) {
                    const links = result.data.map(({ itemID, PlainText }) => `<span style="cursor:pointer" onClick="fnOpenParentItemPop('\${itemID}')">\${PlainText}</span>`).join(' > ');
                    document.querySelector('#pathContainer').innerHTML = `(\${links})`;
                }
            } catch (e) { console.error(e); }
        }

        async function renderRoleList(){
            let sqlID = (isSubItem === 'Y') ? "role_SQL.getSubItemRoleList" : "role_SQL.getItemTeamRoleList";
            let asgnOption = (accMode === 'OPS') ? '2,3' : '1,2';
            const params = new URLSearchParams({ languageID, itemID : s_itemID, asgnOption, sqlID }).toString();
            try {
                const response = await fetch("getData.do?" + params);
                const result = await response.json();
                if (result && result.data) {
                    const html = result.data.filter(item => item.TeamRoletype === 'REL').map(item => item.TeamNM).join(', ');
                    document.getElementById('roleList').textContent = html;
                }
            } catch (e) { console.error(e); }
        }

        async function renderRelItemList() {
            const params = new URLSearchParams({ s_itemID, languageID, cxnTypeList, notInCxnClsList }).toString();
            try {
                const response = await fetch("getCxnItemList.do?" + params);
                const result = await response.json();
                if (result && result.data) {
                    const relItemList = result.data;
                    const tbody_rel = document.getElementById("relProcess_tbody");
                    const tbody_vell = document.getElementById("vell_tbody");
                	if(!tbody_rel) return;
       				
       				// list.TypeName이 없음. 원소스 보고 확인 필요
       				tbody_rel.innerHTML = relItemList
       		        .filter(list => list.ItemTypeCode !== 'OJ00012')
       		        .map((list, index) => `
       		            <tr onclick="clickItemEvent('\${list.ItemID}')" style="cursor: pointer;">
       		                <td>\${list.ClassName ?? ""}</td>
       		                <td>\${list.Identifier ?? ""}</td>
       		                <td class="alignL pdL10">\${list.ItemName ?? ""}</td>
       		            </tr>
       		        `).join("");
       		    	
       				if(!tbody_vell) return;
       				
       				tbody_vell.innerHTML = relItemList
       		        .filter(list => list.ItemTypeCode === 'OJ00012')
       		        .map((list, index) => `
       		            <tr onclick="clickItemEvent2(this)" style="cursor: pointer;">
       		                <td>\${list.ClassName ?? ""}</td>
       		                <td>\${list.Identifier ?? ""}</td>
       		             	<td>\${list.ZAT0001 ?? ""}</td>
       		          		<td>\${list.ZAT0002 ?? ""}</td>
       		                <td class="alignL pdL10"><font style="color: blue; border-bottom: 1px solid blue;">\${list.ItemName ?? ""}</font></td>
       		                
       		             	<td class="tdhidden" id="ItemID">${list.ItemID}</td>
    						<td class="tdhidden" id="masterKey">${list.AT00014}</td>
    						<td class="tdhidden" id="classCode">${list.ClassCode}</td>
       		            </tr>
       		        `).join("");
               
                }
            } catch (e) { console.error(e); }   
        }

        async function renderFileList() {
            const rltdId = await getRltdItemId();
            const params = new URLSearchParams({ DocumentID: s_itemID, s_itemID, DocCategory: 'ITM', languageID, isPublic: 'N', hideBlocked, rltdItemId: rltdId }).toString();
            try {
                const response = await fetch("getItemFileListInfo.do?" + params);
                const result = await response.json();
                if (result && result.data) {
                    const tbody = document.querySelector("tbody[name='file-list']");
                    tbody.innerHTML = result.data.map((file, i) => {
                        const formats = { 'do': 'doc', 'xl': 'xls', 'pdf': 'pdf', 'hw': 'hwp', 'pp': 'ppt' };
                        const icon = formats[Object.keys(formats).find(k => (file.FileFormat||'').includes(k))] || 'log';
                        return `<tr><td>\${i+1}</td><td class="alignL pdL10 flex align-center"><span class="btn_pack small icon mgR25"><span class="\${icon}"></span></span>
                                <span style="cursor:pointer;" onclick="fileNameClick('', '', '', '\${file.Seq}', '');">\${file.FileRealName}</span></td>
                                <td>\${file.WriteUserNM}</td><td>\${file.LastUpdated}</td></tr>`;
                    }).join("");
                }
            } catch (e) { console.error(e); }
        }

        async function getRltdItemId(){
            try {
                const response = await fetch("getRltdItemId.do?languageID=" + languageID + "&DocumentID=" + s_itemID);
                const result = await response.json();
                return result.success ? result.data : "";
            } catch (e) { return ""; }
        }
        
    	function fnGetAuthorInfo(memberID){
    		var url = "viewMbrInfo.do?memberID="+memberID;		
    		window.open(url,'window','width=1200, height=700, left=400, top=100,scrollbar=yes,resizble=0');
    	}
    	
    	function fnMenuReload(){
//     		$("#itemDescriptionDIV").html("");
//     		$("#itemDiv").css('display','block');
    		if(parent.olm?.menuTree) {
    			// 트리 오른쪽 화면에서 view 화면으로 돌아갈 경우 - 트리 클릭 이벤트로 아이템 다시 로드
    			parent.olm.menuTree.selection.add("${itemID}");
    			parent.olm.getMenuUrl("${itemID}");
    		} else {
    			// 팝업에서 로드할 경우, url 재호출
    			location.reload();
    		}
    	}
    </script>
</head>

<body>
    <form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;"> 
        <div id="processItemInfo">
            <input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}"> 
            <input type="hidden" id="accMode" name="accMode" value="${accMode}"> 

            <div style="width:100%;height:100%;overflow-y:auto;overflow-x:hidden;">
               <div id="cont_Header">	
				<div class="pdL10 pdT10 pdB10" id="titWrap" style="width:99%;">
					<ul style="display: inline-block;">
						<li>
							<c:if test="${showPreNextIcon eq 'Y'}" >
							<div id="openItemsli" style="font-family:arial;" class="floatL">
								<span id="preAbl" name="preAbl"><img style="cursor:auto;" src="${root}cmm/common/images/icon_back_btn.png" width="26" height="24" OnClick="fnGoBackItem();"></span>
								<span id="preDis" name="preDis" disabled=true><img style="cursor:auto;" src="${root}cmm/common/images/icon_back_btn_.png" width="26" height="24"></span>
								<input type="hidden" id="openItemName" name="openItemName" size="8">	
								<input type="hidden" id="openItemID" name="openItemID" size="8">		
								<span id="nextAbl" name="nextAbl" ><img style="cursor:auto;" src="${root}cmm/common/images/icon_next_btn.png"  width="26" height="24" OnClick="fnGoNextItem();"></span>	
								<span id="nextDis" name="nextDis"><img style="cursor:auto;" src="${root}cmm/common/images//icon_next_btn_.png"  width="26" height="24"></span>	
							</div>&nbsp;
							</c:if>
						<div id="itemNameAndPath"></div>
					   	&nbsp;
							<div id="functions">
							<!-- 251104 나의관리항목(ownerType=author) 인경우에만 SYS or (편집자이상 and 담당자) edit 버튼 출력 되도록 수정 -->
							<!--c:if test="${sessionScope.loginInfo.sessionLogintype eq 'editor' && myItem eq 'Y'}" > 	-->
							<c:if test="${sessionScope.loginInfo.sessionMlvl eq 'SYS'	
							             or (ownerType eq 'author'
							                 and sessionScope.loginInfo.sessionLogintype eq 'editor'
							                 and myItem eq 'Y')}">								  		
						        <span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="button" onclick="fnEditItemInfo()"></span>
						    </c:if>
							<c:choose>
						   		<c:when test="${itemInfo.SubscrOption eq '1' && myItem ne 'Y' && myItemCNT eq '0'}"  >
				        			 <span class="btn_pack small icon"><span class="unsubscribe"></span><input value="Subscribe" type="button" onclick="fnSubscribe()"></span>
						   		</c:when>
						   		<c:when test="${myItem ne 'Y' && myItemCNT ne '0'}"  >
				        			 <span class="btn_pack small icon"><span class="subscribe"></span><input value="Unsubscribe" type="button" onclick="fnUnsubscribe()"></span>
						   		</c:when>
					   		</c:choose>			   		
						        <span class="btn_pack small icon"><span class="report"></span><input value="Report" type="button" onclick="fnGoReportList()"></span>
					        <c:if test="${itemInfo.ChangeMgt eq '1'}">
						  		 <span class="btn_pack small icon"><span class="cs"></span><input value="History" type="button" onclick="fnGoChangeMgt()"></span>
						  	</c:if>
					  		<span class="btn_pack small icon"><span class="isp"></span><input value="Q&A" type="button" onclick="fnGoForumMgt()"></span>
					  		<span class="btn_pack small icon"><span class="isp"></span><input value="Review" type="button" onclick="fnGoForumMgt2()"></span>
					   		<span class="btn_pack medium icon"><span class="reload"></span><input value="Reload" type="button" onclick="fnMenuReload()"></span>
					   		</div>
					   		<div class="floatR">
								<ul>
									<li  id="memberPhotoArea" style="font-family:arial;cursor:pointer;">
										<c:if test="${empPhotoItemDisPlay ne 'N' && roleAssignMemberList.size() > 0 }" >		   	
											<c:forEach var="author" items="${roleAssignMemberList}" varStatus="status">
											 <span id="authorInfo${status.index}" name="authorInfo${status.index}" ><img src="${author.Photo}" width="26" height="24" OnClick="fnGetAuthorInfo('${author.MemberID}');"></span>
											</c:forEach>
										</c:if>
										
									</li> 
								</ul>
							</div> 
					   	</li>
					</ul>
					<c:if test="${sessionScope.loginInfo.sessionAuthLev == 1}" >
						<span class="btn_pack small icon mgR25" style="float: right;"><input value="Standard Menu" type="button" style="padding-left: 2px;" onclick="fnChangeMenu('management','Management');"></span>
					</c:if>
				</div>
			</div>
                
                <div id="menuDiv" style="margin:0 10px;border-top:1px solid #ddd;" >
                    <div id="itemDescriptionDIV" name="itemDescriptionDIV" style="width:100%;text-align:center;"></div>
                </div>

                <div id="itemDiv">
                    <div style="height: 22px; padding: 10px 0;">
                        <ul style="float:right; padding-right:20px;">
                            <li>
                                <input type="checkbox" class="mgR5 chkbox" name="process" checked>기본정보&nbsp;
                                <input type="checkbox" class="mgR5 chkbox" name="relProcess" checked>관련 Process/SOP/STP&nbsp;
                                <input type="checkbox" class="mgR5 chkbox" name="vell" checked>관련 VELL&nbsp;
                                <input type="checkbox" class="mgR5 chkbox" name="file" checked>첨부파일&nbsp;
                            </li>
                        </ul>
                    </div>

                    <div id="process" class="mgB30">
                        <p class="cont_title">기본 정보</p>
                        <table class="tbl_preview mgB30">
                            <colgroup><col width="10%"><col width="15%"><col width="10%"><col width="15%"><col width="10%"><col width="15%"><col width="10%"><col width="15%"></colgroup>
                            <tr>
                                <th>STP No.</th><td class="alignL pdL10">${itemInfo.Identifier}</td>
                                <th>Rev. No.</th><td class="alignL pdL10">${itemInfo.Version}</td>
                                <th>Rev. Date</th><td class="alignL pdL10">${itemInfo.ValidFrom}</td>
                                <th>${menu.LN00060}</th><td class="alignL pdL10">${itemInfo.Name}</td>
                            </tr>
                            <tr>
                            <th>조직구분</th>
							<td class="alignL pdL10">
							</td>
                                <th>${menu.LN00358}</th><td class="alignL pdL10" colspan="7">${itemInfo.Path}</td>
                            </tr>
                            <tr>
                                <th>${menu.ZLN019}</th><td class="alignL pdL10">${itemInfo.CurOwnerTeamName}</td>
                                <th>${menu.ZLN021}</th><td class="alignL pdL10" colspan="5" id="roleList"></td>
                            </tr>
                        </table>
                    </div>

                    <div id="relProcess" class="mgB30">
                        <p class="cont_title">관련 Process / SOP / STP</p>
                        <table class="tbl_preview mgB20">
                            <colgroup><col width="15%"><col width="25%"><col width="60%"></colgroup>
                            <thead>
                                <tr><th>${menu.LN00042}</th><th>ID</th><th>${menu.ZLN018}</th></tr>
                            </thead>
                            <tbody id="relProcess_tbody"></tbody>
                        </table>    
                    </div>

                    <div id="vell" class="mgB30">
                        <p class="cont_title">관련 VELL</p>
                        <table class="tbl_preview mgB20">
                            <colgroup><col width="10%"><col width="15%"><col width="30%"><col width="15%"><col width="30%"></colgroup>
                            <thead>
                                <tr><th>${menu.LN00042}</th><th>No.</th><th>사업명</th><th>Phase</th><th>Title</th></tr>
                            </thead>
                            <tbody id="vell_tbody"></tbody>
                        </table>    
                    </div>

                    <div id="file" class="mgB30">
                        <p class="cont_title">${menu.LN00111}</p>
                        <table class="tbl_preview">
                            <colgroup><col width="5%"><col width="65%"><col width="15%"><col width="15%"></colgroup> 
                            <thead>
                                <tr><th>No</th><th>${menu.LN00101}</th><th>${menu.LN00060}</th><th>${menu.LN00078}</th></tr>
                            </thead>
                            <tbody name="file-list"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <iframe id="saveFrame" name="saveFrame" style="display:none" title="처리프레임"></iframe>
</body>
</html>