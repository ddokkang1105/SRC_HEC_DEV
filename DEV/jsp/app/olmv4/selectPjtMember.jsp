<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%-- <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="Name"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>

<!-- icons -->
<link rel="stylesheet" href="//cdn.materialdesignicons.com/5.4.55/css/materialdesignicons.min.css" />

<style>
    .dhx_dataview_template_d_box {
        background-color: transparent;
    }

    .dhx_dataview_template_d_box .dhx_dataview-item {
        padding: 0;
        border: 1px solid #dfdfdf;
        background-color: #fff;
        overflow: hidden;
    }

    .dhx_dataview_template_d {
        display: -webkit-box;
        display: -ms-flexbox;
        display: flex;
        width: 100%;
        height: 136px;
        padding: 12px;
            cursor: pointer;
    }

    .dhx_dataview_template_d__inside {
        display: -webkit-box;
        display: -ms-flexbox;
        display: flex;
        width: 100%;
    }

    .dhx_dataview_template_d__picture {
        width: 100px;
        min-width: 100px;
        background: center center/cover no-repeat #f7f7f7;
    }

    .dhx_dataview_template_d__picture:before {
        content: "";
        display: block;
        padding-top: 100%;
    }

    .dhx_dataview_template_d__body {
        padding-left: 12px;
        min-width: 250px;
    }

    .dhx_dataview_template_d__title,
    .dhx_dataview_template_d__text {
        white-space: nowrap;
        text-overflow: ellipsis;
        overflow: hidden;
    }

    .dhx_dataview_template_d__title {
        color: rgba(0, 0, 0, 0.7);
        font-weight: 600;
    }

    .dhx_dataview_template_d__row {
        display: -webkit-box;
        display: -ms-flexbox;
        display: flex;
        -webkit-box-align: center;
        -ms-flex-align: center;
        align-items: center;
        margin: 4px 0;
    }

    .dhx_dataview_template_d__icon {
        font-size: 18px;
        margin-right: 4px;
        color: rgba(0, 0, 0, 0.7);
    }

    .dhx_dataview_template_d__text {
        color: rgba(0, 0, 0, 0.7);
    }

    .dhx_dataview_template_d__link {
        color: #0288d1;
    }
</style>

<!-- 2. Script -->
<script type="text/javascript">
	
// 	var dataset 	= new Array();
	var dataset = '${workerData}';

	function template(item) {
		  var template = '<div class="dhx_dataview_template_d">';
		  template += '<div class="dhx_dataview_template_d__inside">';
		  template += '<div class="dhx_dataview_template_d__picture" style="background-image: url('+item.Photo+');"></div>';
		  template += '<div class="dhx_dataview_template_d__body">';
		  template += '<span class="dhx_dataview_template_d__title">'+item.UserName+'('+item.LoginID+')</span>';
		  template += '<div class="dhx_dataview_template_d__row">';
		  template += '<span class="dhx_dataview_template_d__text">'+item.Position+'&nbsp;</span>';
		  template += '</div>';
		  template += '<div class="dhx_dataview_template_d__row">';
		  template += '<span class="dhx_dataview_template_d__text">'+item.TeamPath+'&nbsp;</span>';
		  template += '</div>';
		  template += '<div class="dhx_dataview_template_d__row">';
		  template += '<span class="dhx_dataview_template_d__icon mdi mdi-email-outline"></span>';
		  template += '<span class="dhx_dataview_template_d__text">'+item.Email+'&nbsp;</span>';
		  template += '</div>';
		  template += '<div class="dhx_dataview_template_d__row">';
		  template += '<span class="dhx_dataview_template_d__icon mdi mdi-cellphone-android"></span>';
		  template += '<span class="dhx_dataview_template_d__text">'+item.MTelNum+'&nbsp;</span>';
		  template += '</div>';
		  template += '</div>';
		  template += '</div>';
		  template += "</div>";
		  return template;
		}

		var dataviews = new dhx.DataView("dataview", {
		  itemsInRow: 3,
		  css: "dhx_dataview_template_d_box",
		  template: template,
		  data: dataset,
		  gap: 15,
		  multiselection: true,
		});
	  
		document.querySelector("#name").addEventListener("keyup", function (event) {
			  const value = event.target.value;
			  if (value) {
				  dataviews.data.filter(function(item) {
			      return item.name.includes(value);
			    });
			  } else {
				  dataviews.data.filter();
			  }
			});
		
		document.querySelector("#id").addEventListener("keyup", function (event) {
			  const value = event.target.value;
			  if (value) {
				  dataviews.data.filter(function(item) {
			      return item.LoginID.includes(value);
			    });
			  } else {
				  dataviews.data.filter();
			  }
			});
		
		document.querySelector("#company").addEventListener("keyup", function (event) {
			  const value = event.target.value;
			  if (value) {
				  dataviews.data.filter(function(item) {
			      return item.teamPath.includes(value);
			    });
			  } else {
				  dataviews.data.filter();
			  }
			});
		
		// [Add] 버튼 Click
		function addPjtMember(url){
			if("${screenType}"=="csrDtl"){			
				var url = "selectPjtAuthor.do?projectID=${parentID}&csrId=${projectID}&screenType=${screenType}";
				var w = 800;
				var h = 700;
				itmInfoPopup(url,w,h);
			}else{
				
				var cnt  = pp_grid.getRowsNum();
				
				var memArr = new Array;

				for ( var i = 0; i < cnt; i++) { 
					memArr[i] = pp_grid.cells2(i,10).getValue();
				}	
				
				var url = "selectMemberPop.do?projectID=${projectID}&scrnType=PJT&s_memberIDs="+memArr;
				window.open(url,"","width=1000 height=650 resizable=yes");
			}
		}
		
		function delPjtMember() {
			var id = dataviews.selection.getId();
			if(id.length == 0){
				alert("${WM00023}");
			} else {
				if(confirm("${CM00004}")){
					console.log(id);
					var memberIds =""; 
					
					for(var i = 0 ; i < id.length; i++ ){
// 						var count = pp_grid.cells(checkedRows[i], 12).getValue();
// 						if (count > 0) {
// 							var id = "LoginID : " + pp_grid.cells(checkedRows[i], 2).getValue();
// 							"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00134' var='WM00134' arguments='"+ id +"'/>"
// 							alert("${WM00134}");
// 							pp_grid.cells(checkedRows[i], 1).setValue(0); 
// 						} else {
							if (memberIds == "") {
								memberIds = id[i];
							} else {
								memberIds = memberIds + "," + id[i];
							}
// 						}
					}
					if (memberIds != "") {
						var url = "admin/delPjtMembers.do";
						var data = "projectID=${projectID}&memberIds=" + memberIds;
						var target = "saveFrame";
						ajaxPage(url, data, target);
					}
				}
			} 
		}
		
		function doPSearchList(){
			var url = "selectPjtMember.do";
			var data = "projectID=${projectID}&screenMode=${screenMode}&listEditable=${listEditable}&screenType=csrDtl&parentID=${parentID}&authorID=${authorID}";
			var target = "help_content"; if("${screenType}" == "csrDtl"){ target = "mainLayer"; }
			ajaxPage(url, data, target);
		}
		
		
</script>
<div id="viewProjectInfoDiv">
<form name="userNameListFrm" id="userNameListFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="ProjectID" name="ProjectID" value="${projectID}" />
	<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="" />
	
	<div class="title-section bordered-bottom">${menu.LN00288}</div>
	
	
	<c:if test="${screenType != 'csrDtl'}">
		<div class="msg mgT5" style="width:100%;">
		      	   <img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Worker management    
	    </div>
    </c:if>

	<div class="child_search01 mgB20 mgT10">
		<li>	
			<section class="dhx_sample-controls">
				<label for="company" class="dhx_sample-label">조직</label>
			  <input type="text" id="company" class="dhx_sample-input">
			  
			  <label for="name" class="dhx_sample-label">Name</label>
			  <input type="text" id="name" class="dhx_sample-input">
			  
			  <label for="id" class="dhx_sample-label">ID</label>
			  <input type="text" id="id" class="dhx_sample-input">
			</section>	
		</li>
		<li class="floatR pdR20">
			<c:if test="${listEditable == 'Y' && (sessionScope.loginInfo.sessionMlvl eq 'SYS' or authorID == sessionScope.loginInfo.sessionUserId)}">
				<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="addPjtMember('selectPjtMember.do')" ></span>
				&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delPjtMember()"></span>
			</c:if>	
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>			
			<c:if test="${isPjtMgt != 'Y' && screenType != 'csrDtl'}">
				&nbsp;<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goBack()" type="submit"></span>
			</c:if>						
		</li>
    </div>
  	
<!-- 	<div class="countList pdT5"> -->
<!--     	<li  class="count">Total  <span id="TOT_CNT"></span></li> -->
<!--    	</div> -->
<!-- 	<div id="gridDiv" class="mgB10 clear" align="center"> -->
<!-- 		<div id="grdPAArea" style="width:100%"></div> -->
<!-- 	</div> -->
	<!-- START :: PAGING -->
<!-- 	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>	 -->
	<div id="dataview" style="padding: 5px;background: #f7f7f7;"></div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;" frameborder="0"></iframe>
