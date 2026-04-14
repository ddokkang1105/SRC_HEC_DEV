<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${menu.LN00262}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${menu.LN00021}"/>

<script type="text/javascript">
	function ListToSelectOption(list){
		var options 	= new Array();
		
		var json = new Object();
	    json.value = "";
		json.content = "Select";
		json = JSON.stringify(json);
		options.push(JSON.parse(json));
		
		for(idx in list){
			var json = new Object();
		    json.value = list[idx].CODE;
			json.content = list[idx].NAME,
			
			json = JSON.stringify(json);
			options.push(JSON.parse(json));
		};
		return options;
	}

	var searchForm = new dhx.Form("searchForm", {
		css: "dhx_widget--bordered",
		padding: 20,
	  	align: "around",
	    rows : [
			{
				  cols: [
				   	  {
				   		rows: [
					  	    {
					  	    	align: "end",
					  	    	cols: [
					                {
		 					              id: "regStartDate",
		 					              name: "regStartDate",
		 					              type: "datepicker",
		 					              label: "${menu.LN00093}",
		 					              labelPosition: "left",
		 					              labelWidth: 100,
		 					              dateFormat: "%Y-%m-%d",
		 					             padding : "0 10px 0 0",
		 					            editable: true,
					                },
					                {
					                	id: "regEndDate",
					                	name: "regEndDate",
							              type: "datepicker",
							              dateFormat: "%Y-%m-%d",
							              editable: true,
					                }
					            ]
					          },
					          {
					        	  id:"srReceiptTeam",
					              name: "srReceiptTeam",
					              type: "select",
					              label: "SR ${menu.LN00227}",
					              labelPosition: "left",
					              labelWidth: 100,
					              options: ListToSelectOption(${srReceiptTeam}),
					          },
					          {
					        	  id:"srArea1",
					              name: "srArea1",
					              type: "select",
					              label: "${menu.LN00274}",
					              labelPosition: "left",
					              labelWidth: 100,
					              options: ListToSelectOption(${srArea1}),
					          },
					  	  ]
				   	  },
				   	  {
				   		rows: [
				   			{
					  	    	align: "end",
					  	    	cols: [
					                {
		 					              id: "srDueStartDate",
		 					              name: "srDueStartDate",
		 					              type: "datepicker",
		 					              label: "SR ${menu.LN00221}",
		 					              labelPosition: "left",
		 					              labelWidth: 100,
		 					              dateFormat: "%Y-%m-%d",
		 					             padding : "0 10px 0 0",
					                },
					                {
					                	id: "srDueEndDate",
					                	name: "srDueEndDate",
							              type: "datepicker",
							              dateFormat: "%Y-%m-%d",
					                }
					            ]
					          },
					          {
					        	  id:"crReceiptTeam",
					              name: "crReceiptTeam",
					              type: "select",
					              label: "CR ${menu.LN00227}",
					              labelPosition: "left",
					              labelWidth: 100,
					              options: ListToSelectOption(${crReceiptTeam}),
					          },
					          {
					        	  id:"srArea2",
					              name: "srArea2",
					              type: "select",
					              label: "${menu.LN00185}",
					              labelPosition: "left",
					              labelWidth: 100,
					              options: ListToSelectOption(${srArea2}),
					          },
					  	  ]
				   	  },
				   	  {
				   		  rows: [
				   				{
						  	    	align: "end",
						  	    	cols: [
						                {
			 					              id: "crDueStartDate",
			 					              name: "crDueStartDate",
			 					              type: "datepicker",
			 					              label: "CR ${menu.LN00221}",
			 					              labelPosition: "left",
			 					              labelWidth: 100,
			 					              dateFormat: "%Y-%m-%d",
			 					             padding : "0 10px 0 0",
						                },
						                {
						                	id: "crDueEndDate",
						                	name: "crDueEndDate",
								              type: "datepicker",
								              dateFormat: "%Y-%m-%d",
						                }
						            ]
					          },
					          {
					        	  id:"category",
					              name: "category",
					              type: "select",
					              label: "${menu.LN00033}",
					              labelPosition: "left",
					              labelWidth: 100,
					              options: ListToSelectOption(${category}),
					          },
					          {
					        	  id:"subCategory",
					              name: "subCategory",
					              type: "select",
					              label: "${menu.LN00273}",
					              labelPosition: "left",
					              labelWidth: 100,
					              options: ListToSelectOption(${subCategory}),
					          },
					          {
					                padding: "32px 8px 0",
					                cols: [
					                    {
					                        name: "search-button",
					                        type: "button",
					                        icon: "mdi mdi-magnify",
					                        text: "Search",
					                        circle: true
					                    },
					                    {
					                        name: "clear",
					                        type: "button",
					                        text: "clear",
					                        view: "link",
					                        padding: "0 16px",
					                        circle: true
					                    }
					                ]
					            },
					      ]
				   	  }
				   	  ]
			  },
		  ]
	});
	

	searchForm.getItem("srReceiptTeam").events.on("Change", function(value) {
		fnGetSRArea1(value)
	});
	
	searchForm.getItem("crReceiptTeam").events.on("Change", function(value) {
		fnGetSRArea1(value)
	});
	
	searchForm.getItem("category").events.on("Change", function(value) {
		fnGetSubCategory(value)
	});
	
	searchForm.getItem("srArea1").events.on("Change", function(value) {
		fnGetSRArea2(value)
	});

	searchForm.getItem("search-button").events.on("click", function () {
		var searchData = searchForm.getValue();
		var srArea1 = selectToblank($("#srArea1").val());
		var srArea2 = selectToblank($("#srArea2").val());
		var category = selectToblank($("#category").val());
		var subCategory = selectToblank($("#subCategory").val());
		var srReceiptTeam = selectToblank($("#srReceiptTeam").val());
		var crReceiptTeam = selectToblank($("#crReceiptTeam").val());
		
		var url = "srDashboardChartListV4.do";
		var target = "chartGridArea";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&srArea1="+srArea1 + "&srArea2="+srArea2
			+"&regStartDate="+$("#regStartDate").val()+"&regEndDate="+$("#regEndDate").val()
			+"&srDueStartDate="+$("#srDueStartDate").val()+"&srDueEndDate="+$("#srDueEndDate").val()
			+"&crDueStartDate="+$("#crDueStartDate").val()+"&crDueEndDate="+$("#crDueEndDate").val()
			+"&category="+category+"&subCategory="+subCategory
			+"&srReceiptTeam="+ srReceiptTeam+"&crReceiptTeam="+ crReceiptTeam+"&srType=${srType}";
		data.replaceAll("Select","");
		ajaxPage(url, data, target);
	});
	
	function selectToblank(val) {
		var returnData = val;
		if(val == "Select") val = "";
		return val;
	}
	
	$(document).ready(function(){
		
	});
	
	function fnGetSRArea1(receiptTeam){
	    var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&receiptTeam="+receiptTeam;
      	fnSelect('srArea1', data, 'getESMSRArea1', '${srArea1}', 'Select','esm_SQL');
	}
	
	function fnGetSRArea2(SRArea1ID){
	    var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+SRArea1ID;
	    fnSelect('srArea2', data, 'getSrArea2', '${srArea2}', 'Select');
	}
	
	function fnGetSubCategory(parentID){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+parentID;
		 fnSelect('subCategory', data, 'getESMSRCategory', '${subCategory}', 'Select','esm_SQL');
	}
</script>
<div class="title-section">SR Dashboard</div>
<div id="searchForm"></div>
<div id="chartGridArea" ></div>
</section>