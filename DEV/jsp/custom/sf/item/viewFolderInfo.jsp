<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
.folderInfo {
	border: 1px solid #e4e4e4;
    padding: 25px;
}
.folderInfo li p{
    width: 200px;
    font-weight: 700;
    color: #707070;
}
</style>
<script>
function viewMbrInfo(id) {
	var url = "viewMbrInfo.do?memberID="+id;		
	window.open(url,'window','width=1200, height=700, left=400, top=100,scrollbar=yes,resizble=0');
}
</script>
<body>
	<ul class="folderInfo mgL5 mgR10 mgT15">
		<li class="flex mgB20">
			<p>Last updated on</p>
			<div>${prcList.LastUpdated}</div>
		</li>
		<li class="flex mgB20">
			<p>Last user</p>
			<div onclick="viewMbrInfo(${prcList.LastUserID})" class="underline">${prcList.LastUserName}<c:if test="${!empty prcList.LastUserTeamName }">(${prcList.LastUserTeamName})</c:if></div>
		</li>
		<li class="flex mgB20">
			<p>Created on</p>
			<div>${prcList.itemCreateDT}</div>
		</li>
		<li class="flex">
			<p>Creator</p>
			<div onclick="viewMbrInfo(${prcList.itemCreator})" class="underline">${prcList.itemCreatorNM}<c:if test="${!empty prcList.itemCreatorTeamNM }">(${prcList.itemCreatorTeamNM})</c:if></div>
		</li>
	</ul>
</body>

