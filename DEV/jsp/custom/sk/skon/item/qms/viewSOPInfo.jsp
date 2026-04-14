<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<% pageContext.setAttribute("newLine", "\n"); %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
 
<script type="text/javascript">	var chkReadOnly = true;	</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<style>
	.scroll-area {
	    overflow: hidden auto;
	    background-attachment: local;
	}
	.contents-box-wrapper {
		margin: 0 auto;
	    width: 1200px;
	    background: url(../cmm/common/images/line.png) 50%/52% no-repeat;
	    background-attachment: local;
	}
	.contents-box div {
	    width: 200px;
	    height: 150px;
	    margin: 30px 0;
        background: #fff;
	}
	.process-bar {
		margin: 20px 0;
	}
	.process-bar div{
		 height: 200px;
	}
	.contents-box h4 {
    	padding: 10px 20px;
    	padding-top: 0;
  	    border-radius: 3px 3px 0 0;
  	    font-size:13px;
	}
	.process-bar h4{ 
		padding-top: 10px;
		height: 20px;
		text-align: center;
	}
	.process-bar div:nth-child(4n+1) h4{
		color: #fff;
	    background: url(../cmm/common/images/process.png) 10px 50%, #055185;
	    background-repeat: no-repeat;
	    background-size: 22px;
	}
	.contents-box ul {
		overflow: auto;
	    height: calc(100% - 53px);
	    padding: 10px 20px;
	}
	.contents-box textarea {
		overflow: auto;
	    height: calc(100% - 30px);
	    padding: 10px 20px;
	    width: 100%;
	    box-sizing: border-box;
	    resize:none;
	    text-align: inherit;
	}
	.process-bar ul {
		height: calc(100% - 58px);
		padding: 6px 20px;
	}
	.alignR {
		border-right:3px solid;
	}
	.alignL {
		border-left:3px solid;
	}
	.alignR h4, .alignL h4{
		color:#055185;
	}
	.alignR h4 img, .alignL h4 img{
		width: 15px;
	    margin-right: 7px;
    }
    .tri {
	    content: "";
	    width: 0px;
	    height: 0px;
	    border-bottom: 15px solid #e6e6e6;
	    border-right: 10px solid transparent;
	    border-left: 10px solid transparent;
	    transform: rotate(90deg);
	    margin-left: 3px;
	}
	.contents-box li:hover:not(.not-hover li){
		text-decoration: underline;
	    cursor: pointer;
	    color: #0085BA;
	}
	.two-box {
		width: 93%;
		margin: 0 auto;
	}
	.two-box div{
		width:320px;
	}
	.tdhidden{display:none;}
</style>
<script type="text/javascript">
	getPlainText();
	
	function fnItemPopUp(itemId){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemId);
	}
	
	function fnOpenTeamInfoMain(teamID){
		var w = "1200";
		var h = "800";
		var url = "orgMainInfo.do?id="+teamID;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnOpenUserInfo(id){		
		var url = "viewMbrInfo.do?memberID="+id;		
		window.open(url,'window','width=1200, height=700, left=400, top=100,scrollbar=yes,resizble=0');
	}
	
	function fileNameClick(seq){
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.frontFrm, url,"saveFrame");
	}
	
	function getPlainText() {
		fetch("/olmapi/plainText/?languageID=${sessionScope.loginInfo.sessionCurrLangType}&attrTypeCode=AT00805,AT00009,AT00085,AT00012,AT00090&itemClassCode=CL08002")
		.then(res => res.json())
		.then(data => {
			let html = "";
			for(var i = 0; i < data.length; i++) {
				if(document.getElementById(data[i].ItemID)) {
					if(data[i].AttrTypeCode == "AT00090") {
						if(data[i].PlainText.includes("01") && !document.getElementById(data[i].ItemID).children.namedItem(data[i].AttrTypeCode+"_01").innerHTML) document.getElementById(data[i].ItemID).children.namedItem(data[i].AttrTypeCode+"_01").innerHTML = "O";
						if(data[i].PlainText.includes("02") && !document.getElementById(data[i].ItemID).children.namedItem(data[i].AttrTypeCode+"_02").innerHTML) document.getElementById(data[i].ItemID).children.namedItem(data[i].AttrTypeCode+"_02").innerHTML = "O";
					} else {
						document.getElementById(data[i].ItemID).children.namedItem(data[i].AttrTypeCode).innerHTML = data[i].PlainText;
					}
				}
			}
		})
	}
</script>

<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;" style="height: 100%;">
<div id="processItemInfo" style="height:100%;overflow-y:auto;">
<input type="hidden" id="currIdx" value="">
<input type="hidden" id="openItemList" value="">

<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">	
<input type="hidden" id="itemViewPage" name="itemViewPage" value="${itemViewPage}">	
<input type="hidden" id="itemEditPage" name="itemEditPage" value="${itemEditPage}">	
<input type="hidden" id="defAccMode" name="defAccMode" value="${defAccMode}">	
<input type="hidden" id="scrnMode" name="scrnMode" value="${scrnMode}">	
<input type="hidden" id="option" name="option" value="${option}">	
<input type="hidden" id="accMode" name="accMode" value="${accMode}">	


	<div class="scroll-area">
		
		<div id="itemDiv">
			<!-- BIGIN :: 기본정보 -->
			<div id="process" class="mgB30 mgT10">
				<table class="tbl_preview mgB30">
					<colgroup>
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
					</colgroup>
					<tr>
						<th>Class</th>
						<td class="alignL pdL10">${prcList.Identifier}</td>
						<th>Process Owner</th>
						<td class="alignL pdL10">${attrMap.AT00012}</td>
						<th>Process Dept</th>
						<td class="alignL pdL10">${attrMap.AT00017}</td>
					</tr>
					<tr>
						<th>Purpose</th>
						<td class="alignL pdL10" colspan="5">
							<div style="width:100%;height:150px;">
								<textarea class="tinymceText"  readonly="readonly">
									${attrMap.AT00003}
								</textarea>
							</div>
						</td>
					</tr>
				</table>
			</div>
			</div>
	
	
		<div class="contents-box-wrapper">
			<!-- 상단 속성 -->
			<div class="flex justify-between contents-box two-box not-hover">
				<div class="alignR">
					<h4><img src="${root}cmm/common/images/operation.png">${attrNameMap.AT00086 }</h4> <%-- ${attrNameMap.AT00015 } --%>
					<textarea readonly="readonly">&middot; ${fn:replace(attrMap.AT00086, newLine, "&middot; ")}</textarea>
				</div>
				<div class="alignL">
					<h4><img src="${root}cmm/common/images/skill.png">${attrNameMap.AT00082 }</h4>
					<textarea readonly="readonly">&middot; ${fn:replace(attrMap.AT00082, newLine, "&middot; ")}</textarea>
				</div>
			</div>
			
			<!-- 중간 cxn, 선후행 -->
			<div class="flex justify-between contents-box align-center process-bar">
				<div class="alignL" style="border-radius: 5px;border: 2px solid #ccc;">
					<h4>Pre-Process</h4>
					<textarea readonly="readonly" style="height:80%;">&middot; ${fn:replace(attrMap.ZAT02001, newLine, "&middot; ")}</textarea>
				</div>
				<span class="tri"></span>
				<div class="alignL" style="border-radius: 5px;border: 2px solid #0085ba;">
					<h4 style="color:#0085ba;">${attrNameMap.AT00015}</h4>
					<textarea readonly="readonly" style="height:calc(100% - 40px );">&middot; ${fn:replace(attrMap.AT00015, newLine, "&middot; ")}</textarea>
				</div>
				<span class="tri"></span>
				<div>
					<ul class="flex align-center justify-center not-hover" style="height: 100%; padding: 0; background: url(../cmm/common/images/circle.png) no-repeat; background-size: 100%;">
						<li style="font-size: 15px;font-weight: 700;color:#0085BA;word-break:keep-all;width: 150px;text-align: center;">${prcList.ItemName}</li>
					</ul>
				</div>
				<span class="tri"></span>
				<div class="alignL" style="border-radius: 5px;border: 2px solid #0085ba;">
					<h4 style="color:#0085ba;">${attrNameMap.AT00016}</h4>
					<textarea readonly="readonly" style="height:calc(100% - 40px );">&middot; ${fn:replace(attrMap.AT00016, newLine, "&middot; ")}</textarea>
				</div>
				<span class="tri"></span>
				<div class="alignL" style="border-radius: 5px;border: 2px solid #ccc;">
					<h4>Pro-Process</h4>
					<textarea readonly="readonly" style="height:80%;">&middot; ${fn:replace(attrMap.ZAT02002, newLine, "&middot; ")}</textarea>
				</div>
			</div>
			
			<!-- 하단 cxn -->
			<div class="flex justify-between contents-box two-box">
				<div class="alignR">
					<h4><img src="${root}cmm/common/images/way.png">Method, Procedure (How)</h4>
					<ul>
						<c:forEach var="list" items="${relItemList}" varStatus="status">
						<c:if test="${list.CXNItemTypeCode eq 'CN00105'}">
						<li onClick="fnItemPopUp(${list.s_itemID})">&middot; ${list.ItemName}</li>
						</c:if>
						</c:forEach>
					</ul>
				</div>
				<div class="alignL">
					<h4><img src="${root}cmm/common/images/chart.png">Process KPI (Measure)</h4>
					<%-- <textarea readonly="readonly" style="height:auto;">&middot; ${fn:replace(attrMap.AT00007, newLine, "&middot; ")}</textarea> --%>
					<ul>
						<c:forEach var="list" items="${relItemList}" varStatus="status">
						<c:if test="${list.ItemTypeCode eq 'OJ00008'}">
						<li onClick="fnItemPopUp(${list.s_itemID})">&middot; ${list.ItemName}</li>
						</c:if>
						</c:forEach>
					</ul>
				</div>
			</div>
		</div>
		
		<div class="mgB20">
			<p class="alignC pdB10 pdT10" style="background: #e5e5e5;font-size: 14px;font-weight: 700;">Work Process & Procedure</p>
				<div style="width:100%;height:300px;">
					<textarea class="tinymceText"  readonly="readonly">
						${attrMap.AT00008}
					</textarea>
				</div>
		</div>
		
		<!-- BIGIN :: 관련 KPI -->
			<div class="mgB20">
				<p class="alignC pdB10 pdT10" style="background: #e5e5e5;font-size: 14px;font-weight: 700;">Process KPI</p>
				<table class="tbl_preview mgB20" id="kpiCxnList">
					<colgroup>
						<col width="5%">
						<col width="15%">
						<col width="15%">
						<col width="15%">
						<col width="15%">
						<col width="15%">
						<col width="10%">
						<col width="10%">
					</colgroup>
					<tr>
						<th>${menu.LN00024}</th>
						<th>KPI Description</th>
						<th>Unit</th>
						<th>Measure</th>
						<th>Method</th>
						<th>Owner</th>
						<th>Effectiveness</th>
						<th>Efficiency</th>
					</tr>
					<c:set value="1" var="no" />
					<c:forEach var="relItemList" items="${relItemList}" varStatus="status">
					<c:if test="${relItemList.ItemTypeCode eq 'OJ00008' }">
					<tr onclick="fnItemPopUp(${relItemList.s_itemID})" style="cursor: pointer;" id="${relItemList.s_itemID}">
						<td>${no }</td>
						<td>${relItemList.ItemName}</td>
						<td name="AT00805"></td>
						<td name="AT00009"></td>
						<td name="AT00085"></td>
						<td name="AT00012"></td>
						<td name="AT00090_01"></td>
						<td name="AT00090_02"></td>
						<td class="tdhidden" id="ItemID">${relItemList.s_itemID}</td>
					</tr>
					<c:set var="no" value="${no+1}"/>
					</c:if>
					</c:forEach>
				</table>	
			</div>
	</div>
	
</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</head>
