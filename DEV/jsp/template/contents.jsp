<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<link href="${root}${HTML_CSS_DIR}/style.css" rel="stylesheet"/>
<body>
	<div id="SubTabs">
		<ul>
			<li><a href="#"><span>정보</span></a></li>
			<li><a href="#"><span>구조</span></a></li>
			<li><a href="#"><span>모델</span></a></li>
			<li><a href="#"><span>요소</span></a></li>
			<li><a href="#"><span>관련항목</span></a></li>
			<li><a href="#"><span>관련모델</span></a></li>
			<li><a href="#"><span>변경이력</span></a></li>
		</ul>
	</div>
	<table class="board_blue" width="100%" cellpadding="0" cellspacing="0" border="0">
		<colgroup>
			<col width="10%">
			<col width="15%">
			<col width="10%">
			<col width="15%">
			<col width="10%">
			<col width="15%">
			<col width="10%">
			<col width="15%">
		</colgroup>
		<tr>
			<th class="viewtop">Name</th>
			<td class="viewtop">&nbsp;</td>
			<th class="viewtop">ID</th>
			<td class="viewtop">&nbsp;</td>
			<th class="viewtop">유형</th>
			<td class="viewtop">&nbsp;</td>
			<th class="viewtop">Rev</th>
			<td class="viewtop last">&nbsp;</td>
		</tr>
		<tr>
			<th>회사</th>
			<td>&nbsp;</td>
			<th>관리조직</th>
			<td>&nbsp;</td>				
			<th>최종작성자</th>
			<td>&nbsp;</td>				
			<th>최종작성일</th>
			<td class="last">&nbsp;</td>				
		</tr>
		<tr>
			<th>경로</th>
			<td colspan="7" class="last"></td>
		</tr>
		<tr>
			<th>첨부파일</th>
			<td colspan="7" class="last"></td>
		</tr>
		<tr>
			<td colspan="8" height="1" class="hr1">&nbsp;</td>
		</tr>		
	</table>
	<div class="SubinfoTabs">
		<ul>
			<li><a href="#">개요</a></li>
			<li class="on"><a href="#">상세속성</a></li>
			<li><a href="#">리포트</a></li>
		</ul>
		<br style="clear: left" />
	</div>
	<table class="board_blue" width="100%" cellpadding="0" cellspacing="0" border="0">
		<colgroup>
			<col width="20%">
			<col>
		</colgroup>
		<tr>
			<th class="viewtop">Full Name</th>
			<td class="viewtop">&nbsp;</td>
		</tr>
		<tr>
			<th>운영기준</th>
			<td class="last">&nbsp;</td>
		</tr>
		<tr>
			<th>표준화</th>
			<td class="last">&nbsp;</td>
		</tr>
		<tr>
			<th>사업부</th>
			<td class="last">&nbsp;</td>
		</tr>
		<tr>
			<th>지역</th>
			<td class="last">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" class="hr1" height="1">&nbsp;</td>
		</tr>
	</table>
	
	<div class="alignBTN">
		<span class="btn_pack icon">
			<span class="save"></span>
			<input value="Save" type="submit">
		</span>&nbsp;
		
		
	</div>
</body>

</html>