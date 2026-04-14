<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagIncV7.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00040" var="CM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00052" var="WM00052"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00054" var="WM00054"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00055" var="WM00055"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00056" var="WM00056"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00106" var="WM00106"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="CSR"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00116" var="WM00116_1" arguments="${menu.LN00015}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00059" var="WM00059"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00121" var="WM00121"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00124" var="WM00124"/>


<style>
	.grid__cell_status-item {
	    text-align: center;
	    height: 20px;
	    width: 70px;
	    border-radius: 100px;
	    background: rgba(0, 0, 0, 0.05);
	}
	
	.grid__cell_status-item.new{
		background: rgba(2, 136, 209, 0.1);
    	color: #0288D1;
	}
	
	.grid__cell_status-item.mod{
		background: rgba(10, 177, 105, 0.1);
    	color: #0ab169;
	}
</style>
<script type="text/javascript">
	var gridData = ${resultData};
	var statusCSS;
	var editedRow = [];
	
	$(document).ready(function() {
	 	// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() * 0.78) + "px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() * 0.78) +"px;");
		};
	 	
	 	$("#backBtn").css("display","none");
		$("#addBtn").css("display","none");
		$("#saveAllBtn").css("display","none");		
		$("#editAttrBtn").css("display","none");
		$("#copyBtn").css("display","none");
		$("#moveBtn").css("display","none");
		$("#sortItemBtn").css("display","none");
		$("#ownershipBtn").css("display","none");
		$("#delBtn").css("display","none");
		fnGridList(gridData);
		
		if("${editRowYN}" == "Y"){
			fnEdit();
		}
		
		window.parent.closeMaskLayer();
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	var grid;
	function fnGridList(resultdata){
		$("#TOT_CNT").html(${totalCnt});
		var classList = ${classList};
		
		grid = new dhx.Grid("grid_container", {
			columns: [
				{ width: 34, id: 'RNUM', header: [{ text: '${menu.LN00024}', align: 'center'}], align: 'center'},
				{ width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" }], align: "center", type: "boolean",  editable: true, sortable: false},
				{ width: 40, id: "gubun", type: "string", header: [{ text: "${menu.LN00042}", align:"center" }],  htmlEnable: true, align: "center",
			       	template: function (text, row, col) {
			       		return "<img src='${root}${HTML_IMG_DIR_ITEM}/" + row.ItemClassIcon + "'>";
			        },
			    },
		        { width: 80, id: 'Identifier', header: [{ text: '${menu.LN00015}', align: 'center'}, { content: "inputFilter"}], align: 'center'},
		        { id: 'ItemName', header: [{ text: '${menu.LN00028}', align: 'center'}, { content: "inputFilter"}], gravity:1, align: 'left', htmlEnable: true},
		        { width: 100, id: 'ClassName', header: [{ text: '${menu.LN00016}', align: 'center'}, { content: "inputFilter"}], align: 'center', editorType: "select", options: ${classOptionData} },
		        { width: 80, id: 'ClassCode', header: [{ text: 'ClassCode' }], hidden:true},
		        ${headerConfig}
		        { width: 100, id: "Status", header: [{ text: "${menu.LN00027}" , align: 'center'}], htmlEnable: true, align: "center",
		            template: function (text, row, col) {
		                var result = "";
		                switch (text) {
		        			case "NEW1" : result = '<span class="grid__cell_status-item new">'+row.StatusNM+'</span>'; break;
		        			case "MOD1" : result = '<span class="grid__cell_status-item mod">'+row.StatusNM+'</span>'; break;
		        			case "MOD2" : result = '<span class="grid__cell_status-item mod">'+row.StatusNM+'</span>'; break;
		        			default : result = '<span class="grid__cell_status-item">'+row.StatusNM+'</span>';
	        			}
		                return result;
		            }
		        },
		        {
		            id: "action", width: 80, header: [{ text: "Actions", align: "center" }],
		            htmlEnable: true, align: "center", sortable: false,
		           /*  template: function(text, row, col) {
		            	return "<span class='action-buttons'><a class='save-button'>save</a></span>";
		            } */
		            template: function(text, row, col) {
		            	return "<span class='action-buttons'><a class='edit-button' title='edit'><i class='mdi mdi-pencil'></i></a></span>";
		            }
		        }
		         ,
		        { id: 'DataType1', header: [{ text: 'DataType1', align: 'center'}], align: 'center', hidden:true },
		        { id: 'DataType2', header: [{ text: 'DataType2', align: 'center'}], align: 'center', hidden:true },
		        { id: 'DataType3', header: [{ text: 'DataType3', align: 'center'}], align: 'center', hidden:true },
		        { id: 'DataType4', header: [{ text: 'DataType4', align: 'center'}], align: 'center', hidden:true },
		        
		        { id: 'LovCode1', header: [{ text: 'LovCode1', align: 'center'}], align: 'center', hidden:true },
		        { id: 'LovCode2', header: [{ text: 'LovCode2', align: 'center'}], align: 'center', hidden:true },
		        { id: 'LovCode3', header: [{ text: 'LovCode3', align: 'center'}], align: 'center', hidden:true },
		        { id: 'LovCode4', header: [{ text: 'LovCode4', align: 'center'}], align: 'center', hidden:true }
			],
			autoWidth: true,
			data: resultdata,
			selection: "row",
			resizable: true,
			autoHeight: true,
			//editable: true,
			 eventHandlers: {
			        onclick: {
			            "save-button": function (e, data) {
			           		fnEditAttrType(data.row);
			            },
			            "edit-button": function (e, data) {
			            	fnEditAttrPop(data.row);
			            }
			        }
			    },
		});
		
		//grid.hideColumn("checkbox");
		
		grid.events.on("AfterEditEnd", function(value,row,column){
		    if(column.id == "ClassName") {
		    	var classCode = classList[classList.findIndex(function(obj){
			        return obj.Name == value
			    })].ClassCode;
				grid.data.update(row.id, { ClassCode: classCode })
		    }
		});
		
		
		grid.events.on("cellClick", function(row,column,e){
			if((column.id == "Identifier" || column.id == "ItemName" || column.id == "ClassName") && grid.config.editable == false){
				fnOpenItemPop(row.ItemID);
			}
		});	
		 
		layout = new dhx.Layout("layout", {
		    rows: [
		        {
		            id: "a",
		        },
		    ]
		});
		layout.getCell("a").attach(grid);
		
		grid.config.editable = false;
		grid.hideColumn("action");
	}
		
	var selectRowData;
	
	var valueMap = new Map();
	var editTypeForm;
	var formConfig;
	function fnEditAttrPop(data){
		
		formConfig = null;
		<c:forEach var="list" items="${editFormList}" varStatus="status">
			if(${status.count} == data.RNUM){
				formConfig = null;
				formConfig =  {
			        padding: 0,
			        dateFormat: "%y/%m/%d",
			        width : "100%",
					rows: [
						 ${list}
					 ]
			    }
			}
		</c:forEach>
		
		if(formConfig == null){
			formConfig =  {
			        padding: 0,
			        align: "center",
			        dateFormat: "%y/%m/%d",
			        width : "100%",
					rows: [
						 ${newForm}
					 ]
			    }
		}
				
		editTypeForm = new dhx.Form(null, formConfig);
		
		valueMap = new Map();
		selectRowData = data;	
		if(data.PlainText1 != ""){ valueMap.set("value1",data.PlainText1); } else { valueMap.set("value1",""); }
		if(data.PlainText2 != ""){ valueMap.set("value2",data.PlainText2); } else { valueMap.set("value2",""); }
		if(data.PlainText3 != ""){ valueMap.set("value3",data.PlainText3); } else { valueMap.set("value3",""); }
		if(data.PlainText4 != ""){ valueMap.set("value4",data.PlainText4); } else { valueMap.set("value4",""); }
				
		var editTypeFormData = {
				"PlainText1":valueMap.get("value1")
				,"PlainText2":valueMap.get("value2")
				,"PlainText3":valueMap.get("value3")
				,"PlainText4":valueMap.get("value4")
				,"Identifier":data.Identifier
				,"ItemName":data.ItemName
				,"ClassCode":data.ClassCode
		};	
		editTypeForm.setValue(editTypeFormData);
		
		/* var groupCheckBox = data.LovCode2.split(",");
		var option2 = "";
		if(data.LovCode2 != ""){
			for(var i=0; i<groupCheckBox.length; i++){
				groupCheckBox[i];
				
				option2 += "'"+groupCheckBox[i]+"':"+ true+",";
			}
			
		}
		var a = "'"+groupCheckBox[0]+"'";
		var a2 =  "'"+groupCheckBox[1]+"'";
		
		editTypeForm.getItem("PlainText2").setValue({
			a: true,b: true,
		}); */
			
		editType.show();
		editType.attach(editTypeForm);

		editType.footer.events.on("click", function (id) {
		    if(id=="save-button") {
		    	if(editTypeForm.validate()){
					var editData = editTypeForm.getValue();
					
					selectRowData.PlainText1 = editData.PlainText1;
					selectRowData.PlainText2 = editData.PlainText2;
					selectRowData.PlainText3 = editData.PlainText3;
					selectRowData.PlainText4 = editData.PlainText4;
					selectRowData.Identifier = editData.Identifier;
					selectRowData.ItemName = editData.ItemName;
					selectRowData.ClassCode = editData.ClassCode;
									
					var jsonData = [];
					jsonData[0] = selectRowData;				
					$("#attrData").val(JSON.stringify(jsonData));
					 
					var url = "saveChildItemAttr.do?editRowYN=Y&attrTypeCodes=${attrTypeCodes}";	
					ajaxSubmit(document.attrFrm, url, "blankFrame"); 
					
				}
				fnCloseEditor();
		    }
		});
	}
	
	var editType = new dhx.Window({
		title: "Edit attributes",
		footer: true,
	    width: 440,
	    height: 710,
	    modal: true,
	    movable: true,
	    resizable : true,
	    dateFormat: "%y/%m/%d"
	});
	
	editType.footer.data.add({ type: "spacer" });
	editType.footer.data.add({
	    id: "save-button",
	    type: "button",
	    value: "Save",
	    icon: "mdi mdi-check",
	    circle: true,
	    submit: true
	});
	
	function fnCloseEditor() {	    
	    editTypeForm.clear();
		editType.hide();
	}
	
	function fnOpenItemPop(itemID){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		var w = 1200;
		var h = 900; 
		itmInfoPopup(url,w,h,itemID);
	}
	
	function exportXlsx() {
	    grid.export.xlsx({
	        url: "//export.dhtmlx.com/excel"
	    });
	};
	
	function fnEditAttrType(data) {
		if(!confirm("${CM00001}")){ return;}
		
		editedRow.push(data);
		var jsonData = JSON.stringify(editedRow);
		
		$("#attrData").val(jsonData);
		 
		var url = "saveChildItemAttr.do?attrTypeCodes=${attrTypeCodes}";	
		ajaxSubmit(document.attrFrm, url, "blankFrame");
	}
	
	function fnSaveChildItemAttr(){ // saveAll
		if(!confirm("${CM00001}")){ return;}
		for(var i=0; i< grid.data._order.length; i++) {
			editedRow.push(grid.data._order[i]);	
		}
		
		var jsonData = JSON.stringify(editedRow);
		
		$("#attrData").val(jsonData);
		
		var url = "saveChildItemAttr.do?attrTypeCodes=${attrTypeCodes}";	
		ajaxSubmit(document.attrFrm, url, "blankFrame");
	}
		
	function fnCallBack(editRowYN){
		var url = "editChildItemAttrList.do";
		var target = "attrDiv";
		var data = "s_itemID=${s_itemID}&varFilter=${attrTypeCodes}&editRowYN="+editRowYN; 
	 	ajaxPage(url, data, target);
	}
	
	function fnEdit() {	
		//grid.showColumn("checkbox");
		grid.config.editable = true;
		grid.showColumn("action");
		
		$("#saveAllBtn").css("display","");
		$("#editBtn").css("display","none");
		$("#addBtn").css("display","");
		$("#backBtn").css("display","");
		$("#editAttrBtn").css("display","");
		$("#copyBtn").css("display","");
		$("#moveBtn").css("display","");
		$("#sortItemBtn").css("display","");
		$("#ownershipBtn").css("display","");
		$("#delBtn").css("display","");
		
		events = "";
		
		for(var i=0; i< grid.data._order.length; i++) {
			editedRow.push(grid.data._order[i]);	
		}
	}
	
	function fnBack() {
		//grid.hideColumn("checkbox");
		grid.config.editable = false;
		grid.hideColumn("action");
		
		$("#backBtn").css("display","none");
		$("#addBtn").css("display","none");
		$("#saveAllBtn").css("display","none");
		$("#editBtn").css("display","");		
		$("#editAttrBtn").css("display","none");
		$("#copyBtn").css("display","none");
		$("#moveBtn").css("display","none");
		$("#sortItemBtn").css("display","none");
		$("#ownershipBtn").css("display","none");
		$("#delBtn").css("display","none");
		
		events = "CellClick";
	}

	function fnCheckMlov(code, rnum, colID){
		var idx = 1;
		var data;
		for(var i=0; i< grid.data._order.length; i++) {
			//editedRow.push(grid.data._order[i]);	
			if(idx ==  rnum){
				console.log("grid.data.rnum :"+JSON.stringify(grid.data._order[i]));
				console.log("grid.data.rnum colID :"+grid.data._order[i]);
				
				if(colID == "1"){
					console.log("PlainTextMLOV1 : "+grid.data._order[i].PlainTextMLOV1);
					data = grid.data._order[i].PlainTextMLOV1;
				}else if(colID == "2"){
					console.log("PlainTextMLOV2 : "+grid.data._order[i].PlainTextMLOV2);
					data = grid.data._order[i].PlainTextMLOV2;
				}else if(colID == "3"){
					console.log("PlainTextMLOV3 : "+grid.data._order[i].PlainTextMLOV3);
					data = grid.data._order[i].PlainTextMLOV3;
				}else if(colID == "4"){
					console.log("PlainTextMLOV4 : "+grid.data._order[i].PlainTextMLOV4);
					data = grid.data._order[i].PlainTextMLOV4;
				}
				
			}
			idx++;
		}
	
		//console.log("data ::"+data); // {LV31002:false,LV31003:false,LV31004:false}
		
		var plainTextMLOV = data.split(",");
		var checkObj = document.all(code+rnum);
		
		var mlovCodeMap = new Map();
		
		for(var i=0; i<plainTextMLOV.length; i++){
			var plainTextMLOV2 = plainTextMLOV[i].split(":");
			mlovCodeMap.set(plainTextMLOV2[0], plainTextMLOV2[1]);
		}
				
		for (var [key, value] of mlovCodeMap) {
		  console.log(key + ' = ' + value); 
		}

		
		if(checkObj.checked == true){
			console.log("true");
			mlovCodeMap.delete(code);
			mlovCodeMap.set(code, "true");
		}else{
			console.log("false");
			mlovCodeMap.delete(code);
			mlovCodeMap.set(code, "false");
		}
		
		var plainTextMLOV = "";
		for (var [key, value] of mlovCodeMap) {
			  if(plainTextMLOV == ""){
			  	plainTextMLOV = key +":"+value;
			  }else{
				plainTextMLOV += ","+key +":"+value;
			  }
		}
	}
	
	function fnAddNewRow(){
		grid.data.add(${addNewRowConfig});
	}
	
	function fnDownload() {
		fnGridExcelDownLoad();
	}
	
	function fnEditCheckedAllItems(avg){	
		var checkedRow = fnGetCheckedRowItems();
		if(checkedRow.length == 0){
			alert("${WM00023}");
			return;
		}

		var items = "";
		var classCodes = "";
		var nowClassCode = "";
		
		for(var i=0; i< grid.data._order.length; i++) {
			if(grid.data._order[i].checkbox == true){
				var itemStatus = grid.data._order[i].Status;
				var blocked = grid.data._order[i].Blocked;
				if (blocked != "0" && avg != "Owner") {
					if (itemStatus == "REL") {
						alert( grid.data._order[i].ItemName + "${WM00124}"); // [변경 요청 안된 상태]
					} else {
						alert( grid.data._order[i].ItemName + "${WM00123}"); // [승인요청중]
					}
					
				} else {
					// 이동 할 ITEMID의 문자열을 셋팅
					if (items == "") {
						items = grid.data._order[i].ItemID;
						classCodes = grid.data._order[i].ClassCode;
						nowClassCode = grid.data._order[i].ClassCode;
					} else {
						items = items + "," + grid.data._order[i].ItemID;
						if (nowClassCode != grid.data._order[i].ClassCode) {
							classCodes = classCodes + "," + grid.data._order[i].ClassCode;
							nowClassCode = grid.data._order[i].ClassCode;
						}
					}
				}
			}
			
		}
		
		if (items != "") {
			$("#items").val(items);

			if (avg == "Attribute2") {
				var url = "selectAttributePop.do";
				var data = "items="+items+"&classCodes="+classCodes; 
			    var option = "dialogWidth:400px; dialogHeight:250px;";
			    //window.showModalDialog(url + data , self, option);
			    window.open("", "selectAttribute2", "width=400, height=350, top=100,left=100,toolbar=no,status=no,resizable=yes");
				$("#classCodes").val(classCodes);
			    document.attrFrm.action=url;
			    document.attrFrm.target="selectAttribute2";
			    document.attrFrm.submit();
			    
			}
		
			//if (items != "") {
			else if (avg == "Attribute") {
					var url = "selectAttributePop.do";
					var data = "classCodes="+classCodes+"&items="+items; 
				   
				    var w = "400";
					var h = "350";
					$("#classCodes").val(classCodes);
				    window.open("", "selectAttribute", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
				    document.attrFrm.action=url;
				    document.attrFrm.target="selectAttribute";
				    document.attrFrm.submit();
				    
			} else  if (avg == "Owner") {				    
				    var url = "selectOwnerPop.do"; 
				    var option = "width=480, height=350, left=300, top=300,scrollbar=yes,resizble=0";
				    window.open("", "SelectOwner", option);
				    document.attrFrm.action=url;
				    document.attrFrm.target="SelectOwner";
				    document.attrFrm.submit();
				    
			} 
		 }
		
	}
		
	function urlReload(){
		fnCallBack();
	}
	
	function doTcSearchList(){
		fnCallBack();
	}
	
	var identifier = "";
	var itemName = "";
	function fnCopyItemInfoOpen(){		
		var checkedRow = fnGetCheckedRowItems();		
		if(checkedRow.length == 0){
			alert("${WM00106}");
			return;
		}
	
		var itemID = "";	
		var classCode = "";
		var itemTypeCode = "";
		for(var i=0; i< grid.data._order.length; i++) {
			if(grid.data._order[i].checkbox == true){
				itemID = grid.data._order[i].ItemID;	
				identifier = grid.data._order[i].Identifier;	
				itemName = grid.data._order[i].ItemName;	
				classCode = grid.data._order[i].ClassCode;	
				itemTypeCode = grid.data._order[i].ItemTypeCode;	
			}
		}
		
		var data = "&itemID="+itemID+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('modelID', data, 'selectModelList', '', 'Select', 'model_SQL');
		
		$("#copyItem").removeAttr('style', 'display: none');
				
		$("#ownerTeamID").val('${sessionScope.loginInfo.sessionTeamId}');	
		$("#divTapItemCopy").removeAttr('style', 'display: none');
				
		$("#cpItemID").val(itemID);
		$("#cpIdentifier").val(identifier);
		$("#cpItemName").val(itemName);
		$("#cpClassCode").val(classCode);
		$("#cpItemTypeCode").val(itemTypeCode);
		
		$("#checkElmts").val('');
		$("#newModelName").val('');
		$("#MTCTypeCode").val('');
		$("#ModelTypeCode").val(''); 
	}
	
	function fnCopyItemInfo(){
		var cpIdentifier = $("#cpIdentifier").val();
		var cpItemName = $("#cpItemName").val();
		var cpCsrInfo = $("#cpCsrInfo").val();
		
		if(cpItemName == ""){alert("${WM00034_1}");$("#cpItemName").focus();return false;}
		if(cpCsrInfo == ""){alert("${WM00041_2}");$("#cpCsrInfo").focus();return false;}
		
		if(cpIdentifier == identifier){ alert("${WM00116_1}"); return;}
		if(confirm("${CM00009}")){		
			var url = "createItem.do";
			var data = "s_itemID=${s_itemID}&option=${option}"
						+"&newClassCode="+$("#cpClassCode").val()
						+"&newIdentifier="+cpIdentifier
						+"&newItemName="+cpItemName
						+"&csrInfo="+cpCsrInfo		
						+"&autoID="+$("#autoID").val()
						+"&preFix="+$("#preFix").val()
						+"&cpItemID="+$("#cpItemID").val()
						+"&refItemID="+$("#cpItemID").val()
						+"&modelID="+$("#modelID").val()
						+"&newModelName="+$("#newModelName").val()
						+"&MTCTypeCode="+$("#MTCTypeCode").val()
						+"&ModelTypeCode="+$("#ModelTypeCode").val()
						+"&elmCopyOption=ref"
						+"&mstSTR=Y";
			var target = "blankFrame";		
			ajaxPage(url, data, target);
		}
	}
	
	function doReturnInsert(classCode){
		setTimeout(function() {urlReload();}, 2000);	
		$("#newClassCode").val("");
		$("#newIdentifier").val("");
		$("#newItemName").val("");
		$("#csrInfo").val("");
		$("#addNewItem").attr('style', 'display: none');	
		$("#divTapItemAdd").attr('style', 'display: none');		
		$("#divTapItemCopy").attr('style', 'display: none');	
		$("#copyItem").attr('style', 'display: none');
		$("#preFix").val("");
	}
	
	function doCallBackMove(){}
	
	function fnMoveItem(itemID){		
		var checkedRow = fnGetCheckedRowItems();			
		if(checkedRow.length == 0){
			alert("${WM00106}");
			return;
		}
		var items = "";		
		for(var i=0; i< grid.data._order.length; i++) {
		    if(grid.data._order[i].checkbox == true){
				if(grid.data._order[i].GUBUN == "O" || grid.data._order[i].GUBUN == "o"){		
					alert(grid.data._order[i].ItemName +"${WM00059}");
					grid.data._order[i].checkbox = false;
				} else {
					if (items == "") {
						items = grid.data._order[i].ItemID;
					} else {
						items = items + "," + grid.data._order[i].ItemID;
					}
				}
		    }
		}
		
		if (items != "") {
			var url = "acrCodeTreePop.do";
			var data = "items=" + items +"&s_itemID=${s_itemID}&option=${option}";
			fnOpenLayerPopup(url,data,doCallBackMove,617,436);
			
		}
	}
	
	var tranSearchCheck = false;
	function fnMoveItems(avg, isCheck){
		if(isCheck == "false") {
			//alert("권한이 없는 항목으로는 이동 하지 못합니다.");
			alert("${WM00060}");
			return;
		}
		
		var checkedRow = fnGetCheckedRowItems();				
		if(checkedRow.length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");
			alert("${WM00023}");
			return;
		}else{
			
			if('${s_itemID}'==avg){
				//alert("같은 항목으로는 이동 하지 못합니다."); //arguments
				alert("${WM00055}");
				return;
			}
			//if(confirm("선택된 항목을 구조이동 하시겠습니까?")){
			if(confirm("${CM00040}")){
				
				var items = "";
				for(var i=0; i< grid.data._order.length; i++) {
					if(grid.data._order[i].checkbox == true){
						if(grid.data._order[i].ItemID == avg){
							//alert("이동 될 항목중 선택 된 항목이 들어 있습니다.");
							alert("${WM00056}");
							return;
						}
						// blocked == 2 인 경우 승인요청 중, 편집 불가 경고창 표시
						var itemStatus =grid.data._order[i].Status;
						var blocked = grid.data._order[i].Blocked;
				
						if (items == "") {
							items = grid.data._order[i].ItemID;
						} else {
							items = items + "," + grid.data._order[i].ItemID;
						}	
					}
				}	
				
				if(items != ""){
					var url = "changeItemParent.do";
					var data = "s_itemID=${s_itemID}&items="+items+"&fromItemID="+avg;
					var target = "blankFrame";
					ajaxPage(url, data, target);
				}
				$(".popup_div").hide();
				$("#mask").hide();
			}		
		}
	}
		
	function fnEditChilidItemOrder(){
		var sqlKey = "item_SQL.getChildItemList";
		var url = "childItemOrderList.do?s_itemID=${s_itemID}&sqlKey="+sqlKey;
		var w = 500;
		var h = 500;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");

	}
	
	function fnGetCheckedRowItems(){
		var checkedRow = new Array;
		var idx = 0;
		for(var i=0; i< grid.data._order.length; i++) {
			if(grid.data._order[i].checkbox == true){
				checkedRow[idx] = grid.data._order[i].ItemID;
				idx ++;
			}
		}
		return checkedRow;
	}
	
	function fnDeleteItem(){
		var checkedRow = fnGetCheckedRowItems();		
				
		if(checkedRow.length == 0){
			alert("${WM00023}");
			return;
		}
	
		if(confirm("${CM00004}")){
			var items = "";
			
			for(var i=0; i< grid.data._order.length; i++) {
				if(grid.data._order[i].checkbox == true){
				// blocked == 2 인 경우 승인요청 중, 편집 불가 경고창 표시
					var itemStatus = grid.data._order[i].Status;
					var blocked = grid.data._order[i].Blocked;
					var changeMgt =grid.data._order[i].ChangeMgt;
					if (blocked != "0") {
						if (itemStatus == "REL") {
							alert( grid.data._order[i].ItemName + "${WM00121}"); 
						} else {
							alert( grid.data._order[i].ItemName + "${WM00054}"); 
						}
						grid.data._order[i].checkbox = false; 
					} else if (blocked == "0") {
						if(grid.data._order[i].Gubun == "O"){						
							alert( grid.data._order[i].ItemName +" - ${WM00052}"); 
							grid.data._order[i].checkbox = false; 
						}else if(changeMgt == "1" && (itemStatus == "MOD1" || itemStatus == "DEL1")){						
							alert(grid.data._order[i].ItemName + "${WM00046}"); 
							grid.data._order[i].checkbox = false; 
						}else {	
							if(grid.data._order[i].SCOUNT != 0){
								// 하위항목이 존재할 경우 삭제 불가
								alert(grid.data._order[i].ItemName + " - ${WM00024}");
								grid.data._order[i].checkbox = false; 								
						   } else if (items == "") {
								items = grid.data._order[i].ItemID;
						   } else {
								items = items + "," + grid.data._order[i].ItemID;
						   }
					    }
				  }
				}				
			}
			if (items != "") {
				var url = "setItemStatusForDel.do";
				var data = "s_itemID=${s_itemID}&userId=${sessionScope.loginInfo.sessionUserId}&items="+items;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
	  	}
	 }
	
</script>

<body>
<div id="attrDiv" name="attrDiv" >
<form name="attrFrm" id="attrFrm" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="attrData" name="attrData" >
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}" >
	<input type="hidden" id="items" name="items" >
	<input type="hidden" id="classCodes" name="classCodes" >
	<input type="hidden" id="autoID" name="autoID" value="${autoID}" >
	<input type="hidden" id="preFix" name="preFix" value="${preFix}" >
	<div id="mask" class='mask' style='display:none; filter:alpha(opacity=20); opacity:0.2; -moz-opacity:0.2;'></div>
	<div class="countList pdB10">
     	<li class="count">Total  <span id="TOT_CNT"></span></li>
		<li class="floatR pdR10">			
			<c:if test="${editYN eq 'Y'}">			
				<span id="backBtn" class="btn_pack nobg white"><a class="clear" onclick="fnBack()" title="Back"></a></span>		
				<span id="editBtn" class="btn_pack nobg white"><a class="edit" onclick="fnEdit();" title="Edit"></a></span>
				<span id="editAttrBtn" class="btn_pack nobg "><a class="edit2" onclick="fnEditCheckedAllItems('Attribute');" title="Attribute"></a></span>
		   		<span id="addBtn" class="btn_pack nobg"><a class="add" onclick="fnAddNewRow()" title="Add"></a></span>		
				<span id="saveAllBtn" class="btn_pack nobg" ><a class="save" id="Input" OnClick="fnSaveChildItemAttr()" title="Save All"></a></span>
				
				<c:if test="${sessionScope.loginInfo.sessionMlvl eq 'SYS'}">
					<span id="copyBtn" class="btn_pack nobg"><a class="copy" onclick="fnCopyItemInfoOpen();" title="Copy Item"></a></span>
				</c:if>
				<span id="moveBtn" class="btn_pack nobg"><a class="move" onclick="fnMoveItem()" title="Move"></a></span>
				<c:if test="${sortOption eq '1'  && TreeDataFiltered eq 'N' }" > 
				<span id="sortItemBtn" class="btn_pack nobg"><a class="updown" onclick="fnEditChilidItemOrder()" title="Edit Order"></a></span>
				</c:if>
				<span id="ownershipBtn" class="btn_pack nobg"><a class="gov" onclick="fnEditCheckedAllItems('Owner');" title="Ownership"></a></span>
				<c:if test="${blocked != 'Y'}">
					<span id="delBtn" class="btn_pack nobg white"><a class="del" onclick="fnDeleteItem()" title="Delete"></a></span>
				</c:if>
				<span class="btn_pack nobg white"><a class="xls" id="excel" onclick="fnDownload()" title="Download"></a></span>
			</c:if>
		</li>	
    </div>
    <div style="width: 100%;" id="layout"></div>
    
    <div id="divTapItemCopy" class="ddoverlap mgB5 mgT25" style="display: none;">
		<ul>
			<li class="selected" ><a><span>Copy Item</span></a></li>
		</ul>
	</div>
	<div>
    <table id="copyItem" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" style="display: none;">
		<tr>
			<th>${menu.LN00106}</th>
			<th>${menu.LN00028}</th>
			<th>${menu.LN00191}</th>
			<th>${menu.LN00125}</th>
			<th class="last" ></th>
		</tr>
		<tr>
			<td style="width:20%;">
				<input type="text" class="text" id="cpIdentifier" name="cpIdentifier" value="" />
				<input type="hidden" id="cpItemID" name="cpItemID" value="" />	
				<input type="hidden" id="cpClassCode" name="cpClassCode" value="" />
				<input type="hidden" id="cpItemTypeCode" name="cpItemTypeCode" value="" />
			</td>
			<td style="width:20%;"><input type="text" class="text" id="cpItemName" name="cpItemName"  value=""/></td>
			<td style="width:20%">
				<select id="cpCsrInfo" name="cpCsrInfo" class="sel">
				<option value="">Select</option>
				<c:forEach var="i" items="${csrList}">
					<option value="${i.CODE}">${i.NAME}</option>						
				</c:forEach>				
				</select>
			</td>
			<td style="width:20%">
				<select id="modelID" name="modelID" class="sel"></select>
			</td>
			<td align="right" style="width:20%" class="last" >
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnCopyItemInfo()"  type="submit"></span>&nbsp;
			</td>
		</tr>	
	</table></div>
</form>
</div>
</body>

<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>


