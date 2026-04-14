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
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>표준 정보 편집</title>

    <%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
    <jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
    <link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />


    <script type="text/javascript">
        var chkReadOnly = false;
        var isWf = "";
        var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
        var s_itemID = "${itemID}";
        var scrnMode = "${scrnMode}";
        var sessionUserId = "${sessionScope.loginInfo.sessionUserId}";
        var sessionAuthLev = "${sessionScope.loginInfo.sessionAuthLev}";

        // file 관련 설정
        var docCategory = 'ITM';
        var scrnType = 'ITM';
        var mgtId = '';
        var previousAddedFileNames = new Set();
    </script>

    <%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
    <%@ include file="/WEB-INF/jsp/template/fileAttachWindow.jsp"%>

    <spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

    <style>
		    /* 편집 화면 내부에서만 스크롤이 발생하도록 강제 */
		#processItemInfo {
		    height: 100vh !important; /* 브라우저 높이 전체 사용 */
		    overflow: hidden !important;
		}
		
		#itemDiv {
		
		    height: calc(100vh - 60px) !important; 
		    overflow-y: auto !important; 
		    overflow-x: hidden;
		    padding-bottom: 50px; 
		}
		
	
		.tbl_preview {
		    width: 100% !important;
		}


        .noticeTab02{margin-top:-15px;}
        .noticeTab02 > input{display:none;}
        .noticeTab02 > label{display:inline-block;margin:0 0 -1px; padding:15px 0; font-weight:700;text-align:center;color:#999999;width:62px;}
        .noticeTab02 > section {display: none;padding: 20px 0 0;}
        .noticeTab02 > input:checked+label{color:#333333;border-bottom:3px solid #008bd5;}
        #itemDiv > div { padding : 0 10px; }
        #refresh:hover { cursor:pointer; }
        .tdhidden{display:none;}
        #maintext table { border: 1px solid #ccc; width:100%; }
        #maintext th{ text-align: left; padding: 10px; color: #000; font-weight: bold; }
        #maintext td{ width: 97%; border: 1px solid #ccc; display: block; padding-top: 10px; padding-left: 10px; margin: 0px auto 15px; overflow-x: auto; line-height: 18px; }
        #maintext textarea { width: 100%; resize:none; }
        
    </style>

    <script type="text/javascript">
        $(document).ready(function(){               
            $("input:checkbox:not(:checked)").each(function(){
                $("#"+$(this).attr("name")).css('display','none');
            });

            $('.popup_closeBtn').click(function(){
                layerWindow.removeClass('open');
            });

            initPageData();
        });

        async function initPageData() {
            await renderProcessInfo();
            await renderRoleList();
            await renderFileList();
            setInfoFrame('2');
        }

        async function renderProcessInfo() {
            const sqlID = 'report_SQL.getItemInfo'; 
            const sqlGridList = 'N';
            const requestData = { languageID, s_itemID, sqlID, sqlGridList };
            const params = new URLSearchParams(requestData).toString();
            const url = "getData.do?" + params;
            
            try {
                const response = await fetch(url, { method: 'GET' });
                const result = await response.json();
                
                if (result && result.success && result.data && result.data.length > 0) {
                    const info = result.data[0];
                    const fields = {
                        "itemTypeCode": info.ItemTypeCode,
                        "parentPath": (scrnMode === 'N' ? info.Path : null),
                        "AT00001": info.ItemName,
                        "Description": info.ChangeSetDec,
                        "Reason": info.Reason,
                        "AuthorID": info.AuthorID,
                        "ownerTeamCode": info.OwnerTeamID,
                        "projectId": info.ProjectID
                    };

                    for (let id in fields) {
                        const el = document.getElementById(id);
                        if (el && fields[id] !== null) el.value = fields[id] || '';
                    }

                    if(scrnMode === 'E') {
                        if(document.getElementById("itemTypeNameSpan")) document.getElementById("itemTypeNameSpan").innerText = info.ItemTypeName || '';
                        if(document.getElementById("pathSpan")) document.getElementById("pathSpan").innerText = info.Path || '';
                        if(document.getElementById("identifierSpan")) document.getElementById("identifierSpan").innerText = info.Identifier || '';
                        if(document.getElementById("ownerTeamNameSpan")) document.getElementById("ownerTeamNameSpan").innerText = info.OwnerTeamName || '';
                    }
                }
            } catch (error) {
                console.error("renderProcessInfo error:", error);
            }
        }

        async function renderRoleList() {
            const sqlID = "role_SQL.getItemTeamRoleList";
            const asgnOption = '1,2'; 
            const requestData = { languageID, itemID : s_itemID, asgnOption, sqlID };
            const params = new URLSearchParams(requestData).toString();
            const url = "getData.do?" + params;
            
            try {
                const response = await fetch(url, { method: 'GET' });
                const result = await response.json();
                if (result && result.success && result.data) {
                    const relRoles = result.data
                        .filter(item => item.TeamRoletype === 'REL')
                        .map(item => item.TeamNM)
                        .join(', ');
                    const orgNamesEl = document.getElementById("orgNames");
                    if(orgNamesEl) orgNamesEl.value = relRoles;
                }
            } catch (error) {
                console.error("renderRoleList error:", error);
            }
        }

        async function renderFileList() {
            const requestData = { DocumentID : s_itemID, s_itemID, DocCategory : 'ITM', languageID, isPublic : 'N' };
            const params = new URLSearchParams(requestData).toString();
            const url = "getItemFileListInfo.do?" + params;

            try {
                const response = await fetch(url, { method: 'GET' });
                const result = await response.json();
                if (result && result.success && result.data) {
                    const existingFileListEl = document.getElementById("existingFileList");
                    if(!existingFileListEl) return;
                    let html = "";
                    result.data.forEach(file => {
                        const canDelete = (sessionUserId === file.RegMemberID || sessionAuthLev === "1");
                        const delIcon = canDelete ? `<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="Delete file" align="absmiddle" onclick="fnDeleteItemFile('\${file.Seq}')">` : "";
                        html += `
                            <div id="divDownFile\${file.Seq}" class="mm" name="divDownFile\${file.Seq}">
                                <input type="checkbox" name="attachFileCheck" value="\${file.Seq}" class="mgL2 mgR2">
                                <span style="cursor:pointer;" onclick="fileNameClick('\${file.Seq}');">\${file.FileRealName}</span>
                                \${delIcon}<br>
                            </div>`;
                    });
                    existingFileListEl.innerHTML = html;
                }
            } catch (error) {
                console.error("renderFileList error:", error);
            }
        }

      //************** addFilePop V4 설정 START ************************//
    	function doAttachFileV4(){
    		var url="addFilePopV4.do";
    		var data="scrnType=BRD&mgtId="+$("#BoardMgtID").val()+"&id="+$('#BoardID').val();
    		openPopup(url+"?"+data,480,450, "Attach File");
    	}
    	
    	function openDhxVaultModal(){		
    		// dhtmlx 윈도우로 vault 띄우기
    		newFileWindow.show();
    	}
    	
    	
    	var fileIDMapV4 = new Map();
    	var fileNameMapV4 = new Map();
    	function fnAttacthFileHtmlV4(fileID, fileName){ 
    		fileID = fileID.replace("u","");
    		fileIDMapV4.set(fileID,fileID);
    		fileNameMapV4.set(fileID,fileName);
    	}
    	
    	// addFilePopV4에서 파일 삭제시, fileMap에서 해당파일 제거 
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
    		display_scripts=$("#tmp_file_items").html();

    		let fileFormat = "";
    		fileIDMapV4.forEach(function(fileID) {
    			fileFormat = fileNameMapV4.get(fileID).split(".")[1];
    			switch (true) {
    				case fileFormat.includes("do") : fileFormat = "doc"; break;
    				case fileFormat.includes("xl") : fileFormat = "xls"; break;
    				case fileFormat.includes("pdf") : fileFormat = "pdf"; break;
    				case fileFormat.includes("hw") : fileFormat = "hwp"; break;
    				case fileFormat.includes("pp") : fileFormat = "ppt"; break;
    				default : fileFormat = "log"
    			}
    			  display_scripts = display_scripts+
    			  	'<li id="'+fileID+'"  class="flex icon_color_inherit justify-between mm align-center" name="'+fileID+'">'+ 
    				'<span><span class="btn_pack small icon mgR25">'+
    				'	<span class="'+fileFormat+'"></span></span>' +
    				'	<span style="line-height:24px;">'+fileNameMapV4.get(fileID) + '</span></span>' +
    				'<i class="mdi mdi-window-close" onclick="fnDeleteFileHtmlV4('+fileID+', true)"></i>'+
    				'</li>';
    		});
    		document.getElementById("tmp_file_items").innerHTML = display_scripts;		
    		$("#tmp_file_items").attr('style', 'display: block;');
    	
    		fileIDMapV4 = new Map();
    		fileNameMapV4 = new Map();
    	}
    	
    	//  임시파일 삭제 
    	function fnDeleteFileHtmlV4(fileID, doDeleteFromVault){			
    		var fileName = document.getElementById(fileID)?.innerText;
    		
    		fileIDMapV4.delete(String(fileID));
    		fileNameMapV4.delete(String(fileID));
//     		fileSizeMapV4.delete(String(fileID));
    		
    		if(fileName != "" && fileName != null && fileName != undefined){
    			$("#"+fileID).remove();
    			
    			if (doDeleteFromVault){
    				// vault 모달이 존재하고 vault 객체가 초기화되어 있으면 해당 파일 삭제
    				if(typeof vault !== 'undefined' && vault !== null){
    					try {
    						// fileID에서 숫자만 추출 (vault 내 파일 id에는 불필요한 u가 붙어있었음)
    						var vaultFileId = "u" + fileID;

    						var vaultFile = vault.data.getItem(vaultFileId);
    						
    						if(vaultFile){
    							// console.log("vault에서 제거: ", vaultFileId);				
    							vault.data.remove(vaultFileId);
    						}
    					} catch(e) {
    						console.error("Vault에서 파일 삭제 중 오류:", e);
    					}
    				} else {
    					console.error("Vault 모달이 존재하지 않음");
    					
    				}
    			}
    		}
    		
    		if(!document.querySelector("#tmp_file_items").innerHTML) {
    			document.querySelector("#tmp_file_items").style.display = "";
    		}
    	}
    	//************** addFilePop V4 설정 END ************************//
    	
        function saveObjInfoMain(){ 
            if(confirm("${CM00001}")){  
                if(setAllCondition()) {
     
                    var url = "zhec_saveItemInfoAPI.do"; 
                    var frm = document.getElementById('editSTPFrm');
                    ajaxSubmitNoAdd(frm, url);
                }
            }
        }

        function goApprovalPop() {
            if(confirm("${CM00001}") && setAllCondition()){        
                isWf = "Y";
 
                var url = "zhec_saveItemInfoAPI.do";    
                var frm = document.getElementById('editSTPFrm');
                ajaxSubmitNoAdd(frm, url);
            }
        }

        function fnItemDelete() {
            if(confirm("폐기를 진행하시겠습니까?") && setAllCondition()){        
                isWf = "Y";
                $("#scrnMode").val("D");
        
                var url = "zhec_saveItemInfoAPI.do";    
                var frm = document.getElementById('editSTPFrm');
                ajaxSubmitNoAdd(frm, url);
            }
        }
        
        function fnEditCallBack(avg, newToken) {
    		
        	if(isWf == "Y" && avg != "Y") {
    			var url = "${wfURL}.do?";
    			var data = "isPop=Y&changeSetID=${itemInfo.CurChangeSet}&isMulti=N&wfInstanceID=${itemInfo.WFInstanceID}&wfDocType=CS&ProjectID=${itemInfo.ProjectID}&isView=N&isProc=N";
    					
    			var w = 1500;
    			var h = 1050; 
    			itmInfoPopup(url+data,w,h);
    			goBack();
    		}
    		else if (isWf == "Y" && avg == "Y") {
    			var url = "${wfURL}.do?";
    			var data = "isPop=Y&changeSetID=${itemInfo.CurChangeSet}&isMulti=N&wfInstanceID=${itemInfo.WFInstanceID}&wfDocType=CS&ProjectID=${itemInfo.ProjectID}&isView=N&isProc=N";
    					
    			var w = 1500;
    			var h = 1050; 
    			itmInfoPopup(url+data,w,h);
    			goBack();
    		}
    		else {
	   			// file 토큰 업데이트
	           	if(newToken) {
	           		document.getElementById("uploadToken").value = newToken;
	           		
	           		// temp 파일 삭제
	           		var ul = document.getElementById("tmp_file_items");
	   				while (ul.firstChild) {
	   				    ul.removeChild(ul.firstChild);
	   				}
	   				ul.style.display = "none";
	           		
	           		//전역 uploadToken 갱신
	           	    uploadToken = newToken;     
	           	    
	           		// file창 리로드
	           	    renderFileList();
	           	    
	           	    // Vault 재초기화 (새 토큰 사용)
	           	    if (window.vault) {
	           	        initVault();
	           	    }
	   		    }
    		}
    		
    	}

        function setInfoFrame(avg){
        	var url = "";
        	var data = ""
            if(avg == "1") {
                $("#Con_01").show(); $("#Con_02").hide(); $("#Con_03").hide();
            } else if(avg == "2") { 
                $("#Con_01").hide(); $("#Con_02").show(); $("#Con_03").hide();      
                 url = "cxnItemTreeMgtV4.do";   
                 data = "s_itemID=${itemID}&varFilter=CN00116&languageID=${sessionScope.loginInfo.sessionCurrLangType}&frameName=subRelFrame";
                ajaxPage(url, data, "subRelFrame");
            } else if(avg == "3") { 
                $("#Con_01").hide(); $("#Con_02").hide(); $("#Con_03").show();      
                url = "itemHistory.do";   
                data = "s_itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&pop=pop";
     
          
              ajaxPage(url, data, "csFrame");
                
      
            }
        }

        function openPreviewPop(){
            var url = "itemMainMgt.do?" + "s_itemID=${itemID}" + "&scrnMode=V&accMode=DEV&itemID=${itemID}" + "&itemViewPage=custom/hyundai/hec/item/viewSTPInfoV4&screenMode=pop&itemMainPage=custom/hyundai/hec/item/viewSTPInfoV4";
            window.open(url, "", "width=1200,height=900,top=100,left=100,toolbar=no,status=no,resizable=yes,scrollbar=yes");
        }

        function goBack() {
            var url = "itemMainMgt.do";
            var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V" + "&accMode=${accMode}&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}";
//             ajaxPage(url, data, "processItemInfo");

			if(parent.olm?.menuTree) {
				// 트리 오른쪽 화면에서 view 화면으로 돌아갈 경우 - 트리 클릭 이벤트로 아이템 다시 로드
				parent.olm.menuTree.selection.add("${itemID}");
				parent.olm.getMenuUrl("${itemID}");
			} else {
				// 팝업에서 로드할 경우, url 재호출
				location.href = url+"?"+data;
			}
        }

        function setAllCondition() {
            if("${sessionScope.loginInfo.sessionAuthLev}" == "1") return true;
            if ($("#AT00001").val() == "" ) { alert("표준명을 입력하여 주십시오."); return false; }
            if ($("#Description").val() == "" ) { alert("제/개정/폐기 사유를 입력하여 주십시오."); return false; }
            if ($("#Reason").val() == ""  ) { alert("주요 개정 사항을 입력하여 주십시오."); return false; }
            if ($("#orgNames").val() == ""  ) { alert("유관조직을 선택하여 주십시오."); return false; }
            return true;
        }
        var orgTeamTreePop;
        function fnGoOrgTreePop(){
            var url = "orgTreePop.do";
            var data = "?s_itemID=${itemID}&teamIDs=${teamIDs}";
            //fnOpenLayerPopup(url,data,function(){},617,436);
            orgTeamTreePop = openUrlWithDhxModal(url, data, "Search Organization" , 617, 436)
        }

    	function fnSaveTeamRole(teamIDs,teamNames){
    		$("#orgNames").val(teamNames);
    		$("#orgTeamIDs").val(teamIDs);
    		orgTeamTreePop.hide();
    	}
    	
    	
        function fileNameClick(avg1){
            var seq = [avg1];
            var url = "fileDownload.do?seq="+seq+"&scrnType=STP";
            ajaxSubmitNoAdd(document.editSTPFrm, url, "saveFrame");
        }

        function fnDeleteItemFile(seq){
            var url = "changeSetFileDelete.do";
            var data = "&delType=1&fltpCode=FLTP1601&seq="+seq;
            ajaxPage(url, data, "saveFrame");
            $('#divDownFile'+seq).remove();
        }
    </script>
</head>

<body>
    <form name="editSTPFrm" id="editSTPFrm" action="#" method="post" enctype="multipart/form-data" onsubmit="return false;"> 
        <div id="processItemInfo">
            <input type="hidden" id="s_itemID" name="s_itemID" value="${itemID}" />
            <input type="hidden" id="option" name="option" value="${option}" />      
            <input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />        
            <input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />     
            <input type="hidden" id="AuthorID" name="AuthorID" value="" />
            <input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="" />            
            <input type="hidden" id="sub" name="sub" value="${sub}" />
            <input type="hidden" id="function" name="function" value="saveObjInfoMain">
            <input type="hidden" id="scrnMode" name="scrnMode" value="${scrnMode}" />
            <input type="hidden" id="projectId" name="projectId" value="" />
            <input type="hidden" id="orgTeamIDs" name="orgTeamIDs" value="${teamIDs}" />
            <input type="hidden" id="uploadToken" name="uploadToken" value="${uploadToken}" />

            <div id="htmlReport" style="width:100%;height:100%;overflow-y:auto;overflow-x:hidden;">
                <div id="menuDiv" style="margin:0 10px;border-top:1px solid #ddd;" >
                    <div id="itemDescriptionDIV" name="itemDescriptionDIV" style="width:100%;text-align:center;"></div>
                </div>
                        
                <div id="itemDiv">
                    <div id="process" class="mgB10">
                        <div class="pdL10 pdT15 pdB5" style="width:98%;">
                            <p class="cont_title">${scrnMode eq 'N' ? '표준 신규 등록' : '표준 편집'}</p>
                        </div>
                        <table class="tbl_preview mgB10">
                            <colgroup>
                                <col width="10%"><col width="15%"><col width="10%"><col width="15%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>표준 유형</th>
                                    <td class="alignL pdL10">
                                        <span id="itemTypeNameSpan"></span>
                                        <input type="hidden" id="itemTypeCode" name="itemTypeCode" value="">
                                    </td>
                                    <th>분류체계</th>
                                    <td class="alignL pdL10">
                                        <span id="pathSpan"></span>
                                        <input type="hidden" id="parentPath" name="parentPath">
                                    </td>
                                </tr>
                                <tr>
                                    <th>Stp No.</th>
                                    <td class="alignL pdL10"><span id="identifierSpan"></span></td>
                                    <th>표준명</th>
                                    <td class="alignL pdL10">
                                        <input type="text" id="AT00001" name="AT00001" value="" class="text" maxLength="100">
                                    </td>
                                </tr>
                                <tr>
                                    <th>주관조직</th>
                                    <td class="alignL pdL10"><span id="ownerTeamNameSpan"></span></td>
                                    <th>유관조직</th>
                                    <td class="alignL pdL10">
                                        <input type="text" id="orgNames" name="orgNames" value="" class="text" onClick="fnGoOrgTreePop()" readonly>
                                    </td>
                                </tr>
                                <tr>
                                    <th>제/개정 사유</th>
                                    <td class="alignL pdL10" colspan="3">                       
                                        <textarea class="edit" id="Description" name="Description" style="width:100%;height:40px;"></textarea> 
                                    </td>                       
                                </tr>
                                <tr>
                                    <th>주요 개정 사항</th>
                                    <td class="alignL pdL10" colspan="3">                       
                                        <textarea class="edit" id="Reason" name="Reason" style="width:100%;height:40px;"></textarea>
                                    </td>                       
                                </tr>
                                <tr>
                                    <th>첨부문서</th>
                                    <td class="alignL pdL10" colspan="3">
                                        <div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
                                            <ul id="tmp_file_items" name="tmp_file_items" class="file_box mgB5 mgT10 tmp_file_items"></ul>
                                            <div id="existingFileList"></div>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="alignR">
                        <span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="button" onclick="goBack()"></span>
                        <span class="btn_pack medium icon"><span class="upload"></span><input value="${menu.LN00019}" type="button" onclick="openDhxVaultModal()"></span>&nbsp;&nbsp;      
                        <span class="btn_pack medium icon"><span class="search"></span><input value="Preview" onclick="openPreviewPop()" type="button"></span>
                        <span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveObjInfoMain()" type="button"></span>
                        <c:if test="${itemInfo.Status ne 'NEW1'}">
                            <span class="btn_pack medium icon"><span class="del"></span><input value="폐기" onclick="fnItemDelete()" type="button"></span>
                        </c:if>
                        <span class="btn_pack medium icon"><span class="save"></span><input value="${menu.LN00211}" onclick="goApprovalPop()" type="button"></span>
                    </div>
                    
                    <div class="noticeTab02">
                        <input id="tab_02" type="radio" name="notice02" checked>
                        <label for="tab_02" id="pli5" onclick="setInfoFrame('2');"><h5>연관 항목</h5></label>
                        <input id="tab_03" type="radio" name="notice02">
                        <label for="tab_03" id="pli6" onclick="setInfoFrame('3');"><h5>${menu.LN00215}</h5></label>

                        <div id="Con_02">
                            <div id="subRelFrame" name="subRelFrame" style="width:100%;"></div>
                        </div>
                        <div id="Con_03">
                            <div id="csFrame" name="csFrame" style="width:100%;"></div>
                        </div>
                    </div>  
                </div>
            </div>
        </div>
    </form>
    <iframe id="saveFrame" name="saveFrame" style="display:none" title="데이터 처리 프레임"></iframe>
</body>
</html>