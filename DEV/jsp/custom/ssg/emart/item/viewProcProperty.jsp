<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
<script src="${root}cmm/js/tinymce_v7/tinymce.min.js" type="text/javascript"></script>
<script type="text/javascript">
	let chkReadOnly = true;

	
	
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<script>

	
	$(document).ready(function(){

		$('#authorInfo').click(function(){			
			var url = "viewMbrInfo.do?memberID=${prcList.AuthorID}";		
			window.open(url,'window','width=1200, height=700, left=400, top=100,scrollbar=yes,resizble=0');
		});
			// 파일리스트		
		  renderFileListByOption();
	
		 // 하위항목 리스트 
		  renderSubItemList();

	});

	function fnOpenTeamInfoMain(teamID){
		var w = "1200";
		var h = "800";
		var url = "orgMainInfo.do?id="+teamID;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}



	// 첨부문서 리스트 가져오기 
	async function getAttachFileList() {
	  const languageID  = "${sessionScope.loginInfo.sessionCurrLangType}";
	  const itemID      = "${itemID}";
	  const hideBlocked = "${hideBlocked}";
	

	
	  const requestData = {
	    languageID: languageID,
	    DocumentID: itemID,
	    hideBlocked: hideBlocked,
	    isPublick: "N",
	    DocCategory: "ITM"
	  };
	
	  const params = new URLSearchParams(requestData).toString();
	  const url = "zEMT_getAttachFileList.do?" + params;
	
	  try {
	    const response = await fetch(url, {
	      method: "GET",
	      headers: {
	        "Accept": "application/json"
	      }
	    });
	

	    if (!response.ok) {
	  
	      throw new Error(`HTTP error! status: ${response.status}`);
	    }
	
	
	
	    const result = await response.json();
	
	    if (result.success === false) {
	      console.error("[getAttachFileList] success=false, body:", result);
	      throw new Error(result.message || "첨부파일 조회 실패");
	    }
	


	    
	    return Array.isArray(result.data) ? result.data : [];
	
	  } catch (error) {
	    Promise.all([
	      getDicData("ERRTP", "LN0014"),
	      getDicData("BTN", "LN0034"), // 닫기
	    ]).then(results => {
	      showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
	    });
	
	    console.error("[getAttachFileList] error:", error.message);
	    return [];
	  }
}

	//파일 렌더
	async function renderFileListByOption() {
	

		const itemFileOption = "${itemFileOption}";
		  const isViewer = (itemFileOption === "VIEWER");

		  const listArea = document.getElementById(isViewer ? "viewerFileListArea" : "attachFileListArea");
		  if (!listArea) return;

		  const btnArea = isViewer ? null : document.getElementById("attachBtnArea");

		  // 초기화
		  listArea.innerHTML = "";
		  if (btnArea) btnArea.style.display = "none";

		  let fileList = [];
		  try {
		    fileList = await getAttachFileList(); 
		  } catch (e) {
		    console.error(e);
		    return;
		  }


		  if (!Array.isArray(fileList) || fileList.length === 0) return;

		  // 일반 모드 (not VIEWER)면 버튼 표시
		  if (btnArea) btnArea.style.display = "block";

		  const frag = document.createDocumentFragment();

		  for (const f of fileList) {
		    const row = document.createElement("div");

		    // 일반 모드(NOT VIEWER)만 체크박스
		    if (!isViewer) {
		      const chk = document.createElement("input");
		      chk.type = "checkbox";
		      chk.name = "checkedFile";
		      chk.className = "mgL2 mgR2";
		      chk.value =  f.FileName + "/" + f.FileRealName + "//" + f.Seq;
		      row.appendChild(chk);
		    }

		    // 파일명(공통)
		    const span = document.createElement("span");
		    span.style.cursor = "pointer";
		    span.textContent = f.FileRealName;

		    
		    const mode = isViewer ? "VIEWER" : "OLM";
		    span.onclick = () => fileNameClick(mode, f.Seq, f.ExtFileURL);

		    row.appendChild(span);

		    if (isViewer) {
		      const img = document.createElement("img");
		      img.src = "${root}${HTML_IMG_DIR}/btn_view_en.png";
		      img.style.cursor = "pointer";
		      img.onclick = () => fileNameClick("VIEWER", f.Seq, f.ExtFileURL);

		      row.appendChild(document.createTextNode(" "));
		      row.appendChild(img);
		    }

		    row.appendChild(document.createElement("br"));
		    frag.appendChild(row);
		  }

		  listArea.appendChild(frag);
		}

	
	// 하위항목 리스트 받아오기 
	async function getSubItemList() {
	  const languageID  = "${sessionScope.loginInfo.sessionCurrLangType}";
	  const s_itemID      = "${itemID}";

	  const requestData = {
	    languageID: languageID,
	    s_itemID: s_itemID,
	 
	  };
	
	  const params = new URLSearchParams(requestData).toString();
	  const url = "zEMT_getSubItemList.do?" + params;
	
	  try {
	    const response = await fetch(url, {
	      method: "GET",
	      headers: {
	        "Accept": "application/json"
	      }
	    });
	

	    if (!response.ok) {
	  
	      throw new Error(`HTTP error! status: ${response.status}`);
	    }
	
	
	
	    const result = await response.json();
	    
	
	    if (result.success === false) {
	      console.error("[getAttachFileList] success=false, body:", result);
	      throw new Error(result.message || "하위 항목 조회 실패");
	    }

	    console.log(result.data);
	    return Array.isArray(result.data) ? result.data : [];
	
	  } catch (error) {
	    Promise.all([
	      getDicData("ERRTP", "LN0014"),
	      getDicData("BTN", "LN0034"), // 닫기
	    ]).then(results => {
	      showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
	    });
	
	    console.error("[getAttachFileList] error:", error.message);
	    return [];
	  }
}

	
	// 하위항목 렌더링 
	async function renderSubItemList() {
		const activityList = await getSubItemList();
		const tbody = document.getElementById("activityListTbody");
		
		if(!tbody) return;
		
		tbody.innerHTML = activityList.map(list => `
		  <tr>
		    <td>
		      <span style="color: blue; cursor:pointer; border-bottom: 1px solid;"
		            onclick="clickItemEvent(\${list.ItemID})">
				\${list.Identifier ?? ""}
		      </span>
		    </td>
		    <td class="alignL pdL10">\${list.ItemName ?? ""}</td>
		    <td class="alignL pdL10">\${list.AT00003 ?? ""}</td>
		    <td class="alignL pdL10">\${list.AT00017 ?? ""}</td>
		    <td class="alignL pdL10">\${renderConList(list.conList)}</td>
		    <td class="alignL pdL5">\${list.AT00014 ?? ""}</td>
		  </tr>
		`).join("");
		
	}


	function renderConList(conList) {
		  if (!Array.isArray(conList) || conList.length === 0) return "";

		  return conList
		    .filter(list2 => list2.ClassCode === "CNL0104")
		    .map(list2 => list2.itemName ?? "")
		    .filter(Boolean)
		    .join("<br>");
		}
	
	function clickItemEvent(itemID) {
		var url = "popupMasterItem.do?"
				+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
 				+"&id="+itemID
				+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fileNameClick(avg3, avg4, avg5){
		
		if(avg3 == "VIEWER") {
			var url = "openViewerPop.do?seq="+avg4;
			var w = screen.width;
			var h = screen.height;
			
			if(avg5 != "") { 
				url = url + "&isNew=N";
			}
			else {
				url = url + "&isNew=Y";
			}
			window.open(url, "openViewerPop", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
			//window.open(url,1316,h); 
		}
		else {	
			var url  = "fileDownload.do?seq="+avg4;
			ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		}
						
	}
</script>
<style>
	.borderR td:not(:last-child), .borderR th:not(:last-child){
		border-right: 1px solid #dfdfdf;
	}
</style>

<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;" style="height: 100%;"> 
	<div id="htmlReport" style="width:100%;overflow-y:auto;overflow-x:hidden;">		
	
<table style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
	<colgroup> 
		<col width="11%">
		<col width="14%">
		<col width="11%">
		<col width="14%">
		<col width="11%">
		<col width="14%">
		<col width="11%">
		<col width="14%">
	</colgroup>
	<tr>
		<!-- 항목계층 -->
		<th class="viewtop">${menu.LN00016}</th>
		<td class="viewtop">${prcList.ClassName}</td>
		<!-- 상태 -->
		<th class="viewtop">${menu.LN00027}</th>
		<td class="viewtop">${prcList.StatusName}</td>				
		<!-- 수정일 -->
		<th class="viewtop" >${menu.LN00070}</th>
		<td class="viewtop">${prcList.LastUpdated}</td>
		<!-- 생성일 -->
		<th class="viewtop" >${menu.LN00013}</th>
		<td class="tdLast viewtop">${prcList.CreateDT}</td>
	</tr>
	<tr>				
		<!-- 관리조직 -->
		<th>${menu.LN00018}</th>
		<td style="cursor:pointer;color: #0054FF;text-decoration: underline;"  OnClick="fnOpenTeamInfoMain(${prcList.OwnerTeamID})" >${prcList.OwnerTeamName}</td>
		<input type="hidden" id="orderTeamName" name="orderTeamName"  value="${prcList.OwnerTeamName}"/>
		<!-- 담당자 -->	
		<th>${menu.LN00004}</th>
		<td id="authorInfo" style="cursor:pointer;_cursor:hand;color: #0054FF;text-decoration: underline;">${prcList.Name} </td>
		 <!-- 법인 -->	
		<th>${menu.LN00352}</th>
		<td>${prcList.TeamName}</td>
		<!-- 프로젝트 -->
		<th>${menu.LN00131}</th>
		<td>${prcList.ProjectName}</td>
	</tr>
	<c:if test="${itemFileOption ne 'VIEWER'}">
	  <tr>
	    <th style="height:53px;">${menu.LN00019}</th>
	    <td style="height:53px;" class="tdLast alignL pdL5" colspan="7">
	      <div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
	
	        <!-- 버튼 영역: JS가 데이터 있을 때만 show -->
	        <div class="floatR pdR20" id="attachBtnArea" style="display:none;">
	          <span class="btn_pack medium icon mgB2">
	            <span class="download"></span>
	            <input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('checkedFile', 'Y')">
	          </span><br>
	          <span class="btn_pack medium icon">
	            <span class="download"></span>
	            <input value="Download" type="button" onclick="FileDownload('checkedFile')">
	          </span><br>
	        </div>
	
	        <!--  파일 리스트  영역 -->
	        <div id="attachFileListArea"></div>
	
	      </div>
	    </td>
	  </tr>
	</c:if>
	
	<c:if test="${itemFileOption eq 'VIEWER'}">
	  <tr>
	    <th style="height:53px;">${menu.LN00019}</th>
	    <td style="height:53px;" class="tdLast alignL pdL5" colspan="7">
	      <div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
	        <div class="floatR pdR20"></div>
	
	        <!-- VIEWER 파일 리스틑 영역 -->
	        <div id="viewerFileListArea"></div>
	
	      </div>
	    </td>
	  </tr>
	</c:if>
</table>

<table style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview mgT20">
	<colgroup> 
		<col width="11%">
		<col width="39%">
		<col width="11%">
		<col width="39%">
	</colgroup>
	<tr>
		<th>업태(Division)</th>
		<td class="alignL pdL5">
		<c:forEach var="list" items="${dimResultList}">
			<c:if test="${list.dimTypeName eq 'Division' }">${list.dimValueNames}</c:if>
		</c:forEach>
		</td>
		<th>Center</th>
		<td class="alignL pdL5">
		<c:forEach var="list" items="${dimResultList}">
			<c:if test="${list.dimTypeName eq 'Center' }">${list.dimValueNames}</c:if>
		</c:forEach>
		</td>
	</tr>
	<tr>
		<th>Category</th>
		<td class="alignL pdL5">
		<c:forEach var="list" items="${dimResultList}">
			<c:if test="${list.dimTypeName eq 'Category' }">${list.dimValueNames}</c:if>
		</c:forEach>
		</td>
		<th>${attrNameMap.AT00007}</th>
		<td class="alignL pdL5"><textarea style="width:100%;height:20px;" readonly="readonly">${attrMap.AT00007}</textarea></td>
	</tr>
	<tr>
		<th>${attrNameMap.AT00003}</th>
		<td class="alignL pdL5" colspan="3">
			<div style="width:100%;height:150px;">
				<textarea class="tinymceText" readonly="readonly">
					 ${attrMap.AT00003}
				 </textarea>
			 </div>
		</td>
	</tr>
	<tr>
		<th>${attrNameMap.AT00015}</th>
		<td class="alignL pdL5"><textarea style="width:100%;height:70px;" readonly="readonly">${attrMap.AT00015}</textarea></td>
		<th>${attrNameMap.AT00016}</textarea></th>
		<td class="alignL pdL5"><textarea style="width:100%;height:70px;" readonly="readonly">${attrMap.AT00016}</textarea></td>
	</tr>
	<tr>
		<th>${attrNameMap.AT00042}</th>
		<td class="alignL pdL5" colspan="3">
			<textarea style="width:100%;height:150px;" readonly="readonly">${attrMap.AT00042}</textarea>
		</td>
	</tr>
</table>

<table style="able-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview borderR mgT20">
	<colgroup> 
		<col width="25%">
		<col width="25%">
		<col width="25%">
		<col width="25%">
	</colgroup>
	<tr>
		<th>업태구분</th>
		<th>프로세스 오너</th>
		<th>주관부서</th>
		<th>관련부서</th>
	</tr>
	<tr>
		<td>이마트</td>
		<td>${attrMap.ZAT0001}</td>
		<td>${attrMap.ZAT0002}</td>
		<td>${attrMap.ZAT0003}</td>
	</tr>
	<tr>
		<td>노브랜드</td>
		<td>${attrMap.ZAT0004}</td>
		<td>${attrMap.ZAT0005}</td>
		<td>${attrMap.ZAT0006}</td>
	</tr>
	<tr>
		<td>트레이더스</td>
		<td>${attrMap.ZAT0007}</td>
		<td>${attrMap.ZAT0008}</td>
		<td>${attrMap.ZAT0009}</td>
	</tr>
	<tr>
		<td>SSG푸드마켓</td>
		<td>${attrMap.ZAT0010}</td>
		<td>${attrMap.ZAT0011}</td>
		<td>${attrMap.ZAT0012}</td>
	</tr>
	<tr>
		<td>전문점</td>
		<td>${attrMap.ZAT0013}</td>
		<td>${attrMap.ZAT0014}</td>
		<td>${attrMap.ZAT0015}</td>
	</tr>
</table>

<table style="able-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview borderR mgT20">
	<colgroup> 
		<col width="25%">
		<col width="25%">
		<col width="25%">
		<col width="25%">
	</colgroup>
	<tr>
		<th>센터구분</th>
		<th>프로세스 오너</th>
		<th>주관부서</th>
		<th>관련부서</th>
	</tr>
	<tr>
		<td>TC</td>
		<td>${attrMap.ZAT0016}</td>
		<td>${attrMap.ZAT0017}</td>
		<td>${attrMap.ZAT0018}</td>
	</tr>
	<tr>
		<td>DC</td>
		<td>${attrMap.ZAT0019}</td>
		<td>${attrMap.ZAT0020}</td>
		<td>${attrMap.ZAT0021}</td>
	</tr>
	<tr>
		<td>RDC</td>
		<td>${attrMap.ZAT0022}</td>
		<td>${attrMap.ZAT0023}</td>
		<td>${attrMap.ZAT0024}</td>
	</tr>
	<tr>
		<td>전문점</td>
		<td>${attrMap.ZAT0025}</td>
		<td>${attrMap.ZAT0026}</td>
		<td>${attrMap.ZAT0027}</td>
	</tr>
	<tr>
		<td>PC</td>
		<td>${attrMap.ZAT0028}</td>
		<td>${attrMap.ZAT0029}</td>
		<td>${attrMap.ZAT0030}</td>
	</tr>
	<tr>
		<td>APC</td>
		<td>${attrMap.ZAT0031}</td>
		<td>${attrMap.ZAT0032}</td>
		<td>${attrMap.ZAT0033}</td>
	</tr>
</table>

<table style="able-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview borderR mgT20">
	<colgroup> 
		<col width="12%">
		<col width="13%">
		<col width="42%">
		<col width="10%">
		<col width="10%">
		<col width="13%">
	</colgroup>
	<tr>
		<th>Activity ID</th>
		<th>Activity 명</th>
		<th>Guideline</th>
		<th>Role</th>
		<th>System</th>
		<th>T-Code</th>
	</tr>
	<tbody id="activityListTbody">
	</tbody>

</table>
	</div>
</form>