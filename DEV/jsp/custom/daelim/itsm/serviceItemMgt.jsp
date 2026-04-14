<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:url value="/" var="root" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<!-- DHX Grid 7.1.8 -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css" />
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css" />
<script src="/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<style>
	.dhx_cell-editor {
		box-shadow: none;
	}
	.dhx_grid-cell.edit-calander, .dhx_grid-cell.edit-input {
		cursor:text;
	}
	.dhx_grid-cell.edit-calander:after, .dhx_grid-cell.edit-input:after  {
		content: "";
		position: absolute;
		border: 1px solid #ddd;
		width: calc(100% - 12px);
		height: calc(100% - 12px);
		left: 6px;
		border-radius: 6px;
	}
	.delete {
		transition: all 0.2s;
	    cursor: pointer;
	    height: calc(100% - 12px);
	    padding: 0 15px;
	    border-radius: 6px;
	    background: #FFFFFF;
	    color: #222;
	    border: 1px solid #C9C9C9;
	}
</style>
</head>
<body>
	<div class="border-section pdT20">
		<div class="btn-wrap pdB10">
			<div></div>
			<div class="btns">
				<c:if test="${editMode eq 'Y'}">
					<button onclick="fnDescSave()" class="tertiary">내용 저장</button>
					<button onclick="fnAdd()" class="primary">CI 추가</button>
				</c:if>
			</div>
		</div>
		<div id="grid" style="width: 100%; height: 300px;"></div>
	</div>
	<script>
		
		const data = ${gridData};
		
		const serviceItem = new dhx.Grid("grid", {
	    	columns: [
		        {  width: 60, id: "RNUM", header: [{ text: "No", align:"center"  }], align:"center" },
		        {  width: 200, id: "Identifier", header: [{ text: "${menu.LN00106}", align:"center" }], align:"center" },
		        { width: 200, id: "ItemNM", header: [{ text: "CI ${menu.LN00028}", align:"center" }], align:"center" },
		        { width: 300, id: "Path", header: [{ text: "${menu.LN00043}", align:"center" }], align:"center" },
		        { id: "Description", header: [{ text: "${menu.LN00003}", align:"center" }], align:"left", gravity:1,
		        	mark: ( cell, columnCell, row  ) => ( "${editMode}" === "Y" && "edit-input") 
		        },
		        { width: 80, id: "btn", header: [{ test: "", align:"center" }], align:"center", htmlEnable: true,
		        	template: function (text, row) {
		                return `<button onclick="fnRowDelete(\${row.ServiceItemID}, '\${row.id}')" class="delete">삭제</button>`
		            },
		        },
		        { hidden: true, width: 60, id: "ServiceItemID", header: [{ text: "ServiceItemID", align:"center"  }], align:"center" },
	        ],
	        autoWidth: true,
		    data: data,
		    resizable: false,
		    rowHeight: 40
		});
		
		if("${editMode}" == "N") serviceItem.hideColumn("btn");
		
		serviceItem.events.on("cellClick", function(row,column){
			if(column.id == "ItemNM") fnItemPopUp(row.ItemID);
		   	if(column.id == "Description" && "${editMode}" === "Y") serviceItem.edit(row.id,column.id);
		});
		
		function fnAdd() {
			window.open("searchItemListPop.do?classCodes='CL19002','CL19003'&itemTypeCode=OJ00019&items="+(serviceItem.data.getRawData().map(e => e.ItemID)).toString(), "serviceItemMgt","width=700 height=500 resizable=yes");
		}
		
		function setCheckedItems(checkedItems){
			const data = {
				srID : "${srID}",
				items : checkedItems,
		    };
	   		
		    // 객체를 JSON 문자열로 변환
			fetch('/saveServiceItem.do', {
				method: 'POST',
				body : JSON.stringify(data),
				headers: {
					'Content-type': 'application/json; charset=UTF-8',
				},
			})
			.then((res) => res.json())
			.then((data) => {
				alert(data.message);
				serviceItem.data.parse(data.gridData);
			});
		}
		
		function fnDescSave() {
	 		fetch('/saveDescServiceItem.do', {
	 			method: 'POST',
	 			body : JSON.stringify({data : serviceItem.data.getRawData()}),
	 			headers: {
	 				'Content-type': 'application/json; charset=UTF-8',
	 			},
	 		})
	 		.then((res) => res.json())
	 		.then((data) => {
	 			alert(data.message);
	 		});
		}
		
		function fnRowDelete(serviceItemID, id) {
			fetch('/deleteServiceItem.do', {
	 			method: 'POST',
	 			body : JSON.stringify({serviceItemID : serviceItemID}),
	 			headers: {
	 				'Content-type': 'application/json; charset=UTF-8',
	 			},
	 		})
	 		.then((res) => res.json())
	 		.then((data) => {
	 			serviceItem.data.remove(id);
	 			alert(data.message);
	 		});
		}
		
		function fnItemPopUp(itemId){
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,itemId);
		}
	</script>
</body>
</html>