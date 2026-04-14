<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<script src="https://cdn.polyfill.io/v3/polyfill.min.js?features=default,Array.prototype.includes,Array.prototype.find"></script>


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00068" var="WM00068" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="대무자"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="Activity Code"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00116" var="WM00116" arguments="사원"/>

<style>
.dhx_grid-cell {
	color: rgba(0, 0, 0, 0.95);
}
.dhx_grid-cell .edit-button, .dhx_grid-cell .save-button {
	padding: 0 15px;
	width: auto;
}
.dhx_grid-cell .edit-button {
    border: 1px solid #0288d1;
    background:none;
}
.dhx_layout-rows {
	flex: 1 auto;
}
.dhx_layout-columns .dhx_layout-rows:first-child .dhx_form-element {
	padding-right:20px;
}
.title-section {
	margin-top:0;
}
.dhx_form-group--disabled {
	opacity: .7;
}
</style>
<!-- 2. Script -->
<script type="text/javascript">
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정
		$("#gridArea").attr("style","height:"+(setWindowHeight() - 120)+"px; width:100%;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#gridArea").attr("style","height:"+(setWindowHeight() - 120)+"px; width:100%;");
		};
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function searchMemberPop(avg1,avg2,avg3) {
		var url = "searchPluralNamePop.do?objId="+avg2+"&objName="+avg3+"&UserLevel=ALL"
				+ "&searchValue=" + encodeURIComponent(avg1)
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		window.open(url,'window','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchNameWf(avg1,avg2,avg3,avg4,id,name){
		if(id == "MemberID") {
			form.setValue({"MemberID": avg1});
			form.setValue({"memberInfo": avg2+"("+avg3+")"});
			
			var found =  grid.data.find(function(e){	// 중복체크
				return e.MemberID == avg1;
			});
			if(found) {
				alert("${WM00116}");
				form.setValue({"MemberID": ""});
				form.setValue({"memberInfo": ""});
			}
		}
		
		if(id == "agentID") {
			form.setValue({"agentID": avg1});
			form.setValue({"agentInfo": avg2+"("+avg3+")"});
		}
	}

	var formConfig = {
	        padding: 0,
			 rows: [
				  {
		                type: "input",
		                name: "Seq",
		                label: "Seq",
		                hidden: true,
		            },
				 {
		                type: "input",
		                id : "memberInfo",
		                name: "memberInfo",
		                label: "Member Info",
		                required: true,
		            },
		            {
		                type: "input",
		                id : "MemberID",
		                name: "MemberID",
		                label: "MemberID",
		                hidden: true,
		            },
		            {
		                type: "input",
		                name: "superiorInfo",
		                label: "Superior Info",
		                disabled : true
		            },
		            {
		                type: "input",
		                id: "agentInfo",
		                name: "agentInfo",
		                label: "Agent Info",
		                required: true,
		            },
		            {
		                type: "input",
		                id : "agentID",
		                name: "agentID",
		                label: "Agent ID",
		                hidden: true,
		            },
		            {
		                align: "end",
		                cols: [
		                    {
		                        id: "save-button",
		                        type: "button",
		                        text: "Save",              
		                        icon: "mdi mdi-check",
		                        circle: true,
		                        submit: true,
		                    }
		                ]
		            }
			 ]
	};
	
	var form;
	function fnLoadWindow(data) {
		form = new dhx.Form(null, formConfig);
		
		if(data) {
			form.clear();
			editWindow.show();
			editWindow.attach(form);
			form.setValue(data);
			form.getItem("memberInfo").disable();
		} else {
			form.clear();
			addWindow.show();
			addWindow.attach(form);
			form.getItem("superiorInfo").hide();
		}
		
		form.getItem("memberInfo").events.on("change", function (value) {
			searchMemberPop(value, "MemberID", "memberInfo");
		});
		
		form.getItem("agentInfo").events.on("change", function (value) {
			searchMemberPop(value, "agentID", "agentInfo");
		});
		
		form.getItem("save-button").events.on("click", function (value) {
			saveMbrAgent(value);
		});
	}
	
	function saveMbrAgent(value) {
		if(form.validate(false, value)){
			var newData = form.getValue();
			var url = "saveMbrAgent.do";
			var data = "seq=" +newData.Seq	// ADD, EDIT 구분
							+"&memberID="+newData.MemberID
							+"&agentID="+newData.agentID
							+"&status=0&roleCategory=${roleCategory}&userID=${sessionScope.loginInfo.sessionUserId}";
			var target = "saveFrame";
			ajaxPage(url, data, target);
		    closeEditor();
		}
	}
	
	var addWindow = new dhx.Window({
		title: "Add Agent",
	    width: 600,
	    height: 450,
	    modal: true,
	    movable: true
	});
	
	var editWindow = new dhx.Window({
		title: "Edit Agent",
	    width: 600,
	    height: 450,
	    modal: true,
	    movable: true
	});
	
	function fnDel(){
		var selectedCell =  grid.selection.getCells();
		if(!selectedCell.length){
			alert("${WM00023}");	
		}else{
			if(confirm("${CM00004}")){
				var seq = "";
				for(var i=0; i<selectedCell.length; i++){
					grid.data.remove(selectedCell[i].row.Seq);
				    if (seq == "") {
				    	seq = selectedCell[i].row.Seq;
					} else {
						seq += ","+selectedCell[i].row.Seq;
					}
				};
				var url = "deleteMbrAgent.do";
				var data = "seq="+seq+"&roleCategory=${roleCategory}";
				var target = "saveFrame";
				ajaxPage(url, data, target);		
			}
		}
	}
	
	function closeEditor() {
		addWindow.hide();
	    editWindow.hide();
	}
	
</script>
<body>
	<form action="" method="post" onsubmit="return false;">
	    <div class="title-section">
			Member Agent Report
			<span class="floatR btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDel()"></span>
			<span class="floatR btn_pack small icon mgR10"><span class="add"></span><input value="Add" type="submit" onclick="fnLoadWindow()"></span>
		</div>
		<div id="gridArea"></div>
		<div id="pagination"></div>
	</form>
	<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none; height:0px;" frameborder="0" scrolling='no'></iframe>
</body>
<script>
	var gridData = ${gridData};
	var grid = new dhx.Grid("gridArea", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" }], align: "center" },
	        { width: 50, id: "Seq", header: [{ text: "Seq" }], align: "center" },
	        { width: 150, id: "Name", header: [{ text: "${menu.LN00028}" }, { content: "inputFilter" }] },
	        { width: 250, id: "TeamName", header: [{ text: "${menu.LN00104}" }, { content: "selectFilter" }] },
	        { width: 250, id: "memberInfo", header: [{ text: "Member" }, { content: "inputFilter" }] },
	        { width: 250, id: "superiorInfo", header: [{ text: "상위조직 부서장" }, { content: "inputFilter" }] },
	        { width: 250, id: "agentInfo", header: [{ text: "대무자" }, { content: "inputFilter" }] },
	        { width: 250, id: "LastUpdated", header: [{ text: "${menu.LN00070}" }, { content: "inputFilter" }] },
	        {
	            id: "action", width: 150, header: [{ text: "Actions", align: "center" }],
	            htmlEnable: true, align: "center",
	            template: function () {
	                return "<span class='action-buttons'><a class='edit-button'>Edit</a></span>"
	            }
	        },
	    ],
	    eventHandlers: {
	        onclick: {
	            "edit-button": function (e, data) {
	            	fnLoadWindow(data.row);
	            }
	        }
	    },
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true
	});
	
	grid.hideColumn("memberInfo");
	grid.hideColumn("Seq");
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 40,
	});
	
	function reload(newGridData){
		grid.data.parse(newGridData);
	}
</script>
</html>