<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
	.checkbox {
		display: inline-block;
	    position: relative;
	    margin-right: 30px;
	}
	
	.checkbox input[type=checkbox] {
		clip: rect(0, 0, 0, 0);
		height: 0px;
		margin: -1px;
		overflow: hidden;
		position: absolute;
		width: 0px;
	}
	
	.checkbox input[type=checkbox]+label {
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
		display: inline-block;
		min-height: 20px;
		padding-left: 22px;
		vertical-align: middle;
	    cursor: default;
	}
	
	.checkbox input[type=checkbox]+label:before {
		position: absolute;
		content: "";
		height: 16px;
		width: 16px;
		left: 0px;
		top: 0px;
		border-radius: 3px;
		border: 1px solid #ddd;
		transition: all 0.15s;
	}
	.checkbox input[type=checkbox]:disabled:checked+label:before {
		background-color: #888;
		background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' height='20px' viewBox='0 -960 960 960' width='20px' fill='%23FFFFFF'%3E%3Cpath d='M389-267 195-460l51-52 143 143 325-324 51 51-376 375Z'/%3E%3C/svg%3E");
		background-repeat: no-repeat;
		background-position: center center;
		background-size: 16px;
		border: 1px solid #888;
		cursor:default;
	}
	
	textarea.activityText{
		resize: none;
		width: 100%;
		background: none;
		padding: 0;
	}
	
</style>

<script>
	let srType = "${srType}";
	jQuery(document).ready(function() {
		
		if("${espDueDateMgt}" != "" && "${espDueDateMgt}" != null && "${espDueDateMgt}" !== undefined){
			fnEspDueDateMgtFrame();
		}
	});
	
	document.querySelector("#allDetail").addEventListener("click", function(e) {
		let test = ${jsonLogList};
		test.filter(e => e.ActivityCode !== "00").forEach(e => doDetail(document.querySelector("#"+e.speCode+"_"+e.RNUM).children.namedItem("fold"), e.speCode, e.ActivitySeq, e.DocCategory))
	})

	function doDetail(e, speCode, activitySeq, docCategory) {
		if(!e.parentElement.nextElementSibling?.classList.contains("attr-list")) {
			$('#loading').fadeIn(150);
			e.classList.add("on");
			
			fetch("/olmapi/espActivityAttr/?srID=${srID}&languageID=${languageID}&srType=${srType}&speCode="+speCode+"&activitySeq="+activitySeq+"&docCategory=" + docCategory)
			.then((response) => response.json())
			.then((data) => {
				// Editable = 1인 리스트와 그 외 targetAttrType 리스트
				let extraList = [];
				extraList = data.filter(e => e.VarFilter).filter(e => e.LovCode === e.VarFilter.split("&").filter(e => e.includes("actionValue"))[0]?.replace("actionValue=", ""))
											.map(e => e.VarFilter.split("&").filter(e => e.includes("targetAttrType"))[0]?.replace("targetAttrType=", ""));
				//data = data.filter(e => e.Editable === "1" || extraList.includes(e.AttrTypeCode));
				data = data.filter(e => e.Invisible !== "1" || extraList.includes(e.AttrTypeCode));
				let attrHtml = "";
				
				attrHtml += "<tr  class='attr-list'><th colspan=12><table class='table-list'>";
				attrHtml += "<colgroup><col width='49px'><col width='180px'><col width='*'></colgroup>";
				
				for(let i = 0; i < data.length; i++) {
					let className = "";
					if(i == 0) className = "border-top-none";
					if(i == data.length - 1) className += " border-bottom-none";
					
					attrHtml += "<tr>"
					attrHtml += `<td class='\${className}'></td>`
					attrHtml += `<td class='\${className}'>\${data[i].Name}</td>`
					
					//TimeZone
					if(data[i].DataType === "Time"){
						if(data[i].PlainText && data[i].PlainText !== "today") data[i].PlainText = data[i].PlainText.substring(0, 16);
					} else if (data[i].DataType === "Date") {
						if(data[i].PlainText && data[i].PlainText !== "today") data[i].PlainText = data[i].PlainText.substring(0, 10);
					}
					
					if(data[i].DefaultValue === "today" && (data[i].DataType === "Time" || data[i].DataType === "Date")) {
						attrHtml += `<td class='\${className} alignL'>\${data[i].PlainText || ""}</td>`;
					}
					else if(data[i].DataType === "Text") {
						attrHtml += `<td class='\${className} alignL'><textarea readonly class='\activityText'>\${data[i].PlainText || data[i].DefaultValue || ""}</textarea></td>`;
					}
					else {
						attrHtml += `<td class='\${className} alignL'>\${data[i].PlainText || data[i].DefaultValue || ""}</td>`;
					}
					
					attrHtml +=  "</tr>"
				}
				
				attrHtml +=  "</table></td></tr>";
				e.parentElement.insertAdjacentHTML("afterend", attrHtml);
				
				// textarea있을경우 자동 높이 조정
				const textareas = document.querySelectorAll('.activityText');
				if (textareas && textareas.length > 0) {
					textareas.forEach(textarea => {
				        textarea.style.height = 'auto';
				        textarea.style.height = textarea.scrollHeight + 'px';
				        // * char(10)변환 적용
				        textarea.value = textarea.value.replace(/char\(10\)/g, '\n');
				    });
				}
				
				$('#loading').fadeOut(150);
			})
			.catch((error) => console.log("error:", error));
			
			
		} else {
			if(e.parentElement.nextElementSibling.classList.contains("hide")) {
				e.classList.add("on");
				e.parentElement.nextElementSibling.classList.remove("hide");
			} else {
				e.classList.remove("on");
				e.parentElement.nextElementSibling.classList.add("hide");
			}
		}
	}
	
	// 완료예정일
	function fnEspDueDateMgtFrame(){
		$("#espDueDateMgtFrame").attr("style", "display:block;width:100%; height:675px; border:none;");
		var data = "&srID=${srID}&languageID=${languageID}&srType=${srType}&speCode=${speCode}&espDueDateMgt=V";
		var src = "espDueDateMgt.do?"+data; 
		 document.getElementById('espDueDateMgtFrame').contentWindow.location.href= src;
	}
	
	// 결재문서 팝업
	function openWfDoc(WFInstanceID, ActivityLogID) {
		let defApprovalSystem = "${defApprovalSystem}";
		if(defApprovalSystem == "OLM") url =  "${wfURL}.do";	 else url = "zDlm_wfDocMgt.do";
		window.open(url+"?docCategory=SPE&actionType=view&wfInstanceID="+WFInstanceID+"&documentID="+ActivityLogID+"&documentNo=${srCode}&inhouse=${inhouse}",WFInstanceID,'width=1300, height=800, left=300, top=300,scrollbar=yes,resizble=0');
	}

</script>
<style>
.attr-list {
display:table-row;
background: #f8f8f8;
}
.attr-list.hide {
	display:none;
}
.border-top-none {
	border-top:none !important;
}
.border-bottom-none {
	border-bottom:none !important;
}
.fold {
    transition: transform 0.2s;
    cursor:pointer;
}
.fold.on {
	    transform: rotate(180deg);
}
</style>
<body>
	<div class="border-section">
		<div class="pdT20 pdB10"></div>
		<table class="table-list" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
			<colgroup>
			    <col width="50px">
			    <col width="180px">
			    <col width="100px">
			    <col width="140px">
			    <col width="120px">
			    <col width="100px">
			    <col width="80px">
			    <col width="140px">
			    <col width="140px">
			    <col width="60px">	
			    <col width="*">
			    <col width="50px">			    
			</colgroup>
			<thead>
				<tr>
					<th>${menu.LN00024}</th>
					<th>${menu.ZLN0060} ${menu.LN00028}</th>
					<th>${menu.LN00004}</th>
					<th>${menu.LN00104}</th>
					<th>${menu.ZLN0018}</th>
					<th>${menu.ZLN0197}</th>			
					<th>${menu.LN00027}</th>
					<th>${menu.LN00077}</th>
					<th>${menu.LN00064}</th>
					<th>${menu.LN01013}</th>
					<th>${menu.LN00076}</th>
					<th id="allDetail"><svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#434343"><path d="M480-333 240-573l51-51 189 189 189-189 51 51-240 240Z"/></svg></th>
				</tr>
			</thead>
			<c:forEach var="list" items="${logList}">
				<tr id="${list.speCode}_${list.RNUM}">
					<td>${list.RNUM}</td>
					<td>${list.ActivityName}</td>
					<td>${list.ActorName}</td>
					<td>${list.TeamName}</td>
					<td>${list.CompanyName}</td>
					<td>${list.ReferenceMembers}</td>
					<td>${list.ActivityStatus}</td>
					<td>${list.StartTime}</td>
					<td>${list.EndTime}</td>
					<td><c:if test="${!empty list.ActivityWFInstanceID}"><img style="cursor: pointer;" src="${root}${HTML_IMG_DIR}/icon_search_title.png" onclick="openWfDoc('${list.ActivityWFInstanceID}', '${list.ActivityLogID}')"></c:if></td>
					<td>${list.CommentFiltered}</td>					
					<td <c:if test="${list.ActivityCode ne '00' }">onclick="doDetail(this, '${list.speCode}', ${list.ActivitySeq}, '${list.DocCategory}')" class="fold" name="fold"</c:if> >
						<c:if test="${list.ActivityCode ne '00' }">
						<svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#434343"><path d="M480-333 240-573l51-51 189 189 189-189 51 51-240 240Z"/></svg>
						</c:if>
					</td>
				</tr>
			</c:forEach>
		</table>
		
		<iframe id="espDueDateMgtFrame"  style="width:100%; height:675px; border:none;display:none;"></iframe>
	</div>
</body>