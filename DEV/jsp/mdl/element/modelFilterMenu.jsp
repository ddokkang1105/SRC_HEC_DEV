<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript">
	
	$(document).ready(function(){
		$("#modelFilterDiv").attr("style","height:"+(setWindowHeight()-74)+"px; width:100%;");
		window.onresize = function() {
			$("#modelFilterDiv").attr("style","height:"+(setWindowHeight()-74)+"px; width:100%;");
		};
		
		// 화살표 아이콘 누르면 하위 .container node 숨기기 기능
		const cells = document.querySelectorAll(".cell");		
		cells.forEach((d) => {
		  d.addEventListener("click", (e)=>{
		    const target = e.currentTarget || e.target;
		    target.classList.toggle("fold");
		    
		  })
		})
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function fnShowValues(reqDimTypeID) {
	  var dimType = document.querySelector('input[name="dimType"]:checked');
	  var valuesContainer = document.getElementById("dimValuesDiv");
	  
	  var dimTypeList = JSON.parse('${dimTypeListJson}');
	  var resDimValueList;
	  
	  var htmlCode = "";
	  if (dimType) {
		  valuesContainer.style.display = "block";
		  
		  for (var i = 0; i < dimTypeList.length; i++) {
		  	var obj = dimTypeList[i].DimTypeID;
			 if(dimType.value == obj){
				 resDimValueList = dimTypeList[i].dimValueList;
				
				for(var j=0; j < resDimValueList.length; j++){
				
					htmlCode += "<input type='checkbox' id='"+resDimValueList[j].CODE+"' name='"+resDimValueList[j].CODE+"' value='"+resDimValueList[j].CODE+"'> <label for='"+resDimValueList[j].CODE+"'>"+ resDimValueList[j].NAME+"</label><br>";
				}
				document.getElementById("dimValues").innerHTML = htmlCode;
				break;
			}		    
		  }
	  }
	  /* if(reqDimTypeID == "100001"){
		  fnClickDivision(reqDimTypeID);
	  } */
	}
	
	function getCheckedSymbol() {
        var checkedSymTypeCodes = [];
        var checkboxes = document.querySelectorAll('.symbolCheckbox');
        checkboxes.forEach(function(checkbox) {
            if (checkbox.checked) {
            	checkedSymTypeCodes.push(checkbox.id);
            }
        });
        
        return checkedSymTypeCodes;
    }
	
	function fnGetCheckedFilter(filterType, opacity) {
        var checkedFilterCodeList = [];
        var checkedOpacityList = [];
        var blurredList = [];
        
        var checkboxes = document.querySelectorAll('.'+filterType);
        checkboxes.forEach(function(checkbox) {
            if (checkbox.checked) {
            	checkedFilterCodeList.push(checkbox.id);
            	checkedOpacityList.push($("#opacity_"+checkbox.id).val());
            	if($("#opacity_"+checkbox.id).val() == "0.1"){
            		blurredList.push(checkbox.id);
            	}
            }else{
            	blurredList.push(checkbox.id);
            }
        });
        
        if(opacity == "Y"){
        	return checkedOpacityList;
        }else if(opacity == "blurredList"){
        	return blurredList;
        }else{
        	return checkedFilterCodeList;
        }
        
    }
	
	function fnGetModelFiltered(){
		var itemTypeCodeList = fnGetCheckedFilter('itemTypeList',"");
		var opacityList = fnGetCheckedFilter('itemTypeList', "Y");
		var blurredList = fnGetCheckedFilter('itemTypeList', "blurredList");
		var symTypeCodeList = fnGetCheckedFilter('symTypeList',"");
				
		var dimTypeID = "";
		var dimValueList = "";
		if(document.querySelector('input[name="dimType"]:checked') != null){
			dimTypeID = document.querySelector('input[name="dimType"]:checked').value;
			dimValueList = fnGetDimValueList();
		}
				
		parent.fnReloadModelFilter(opacityList, itemTypeCodeList, blurredList, dimTypeID, dimValueList, symTypeCodeList);
	}
	
	function fnGetDimValueList(){
		
		var dimType = document.querySelector('input[name="dimType"]:checked');
		
		var dimValueIDs = new Array;
		dimTypeID = dimType.value;
				
		var dimTypeList = JSON.parse('${dimTypeListJson}');
		for (var i = 0; i < dimTypeList.length; i++) {
		  	var obj = dimTypeList[i].DimTypeID;
			if(dimType.value == obj){
				resDimValueList = dimTypeList[i].dimValueList;
				
				for(var j=0; j < resDimValueList.length; j++){
					var checked = $("#"+resDimValueList[j].CODE).is(":checked");
					if(checked){
						dimValueIDs.push(resDimValueList[j].CODE);
					}
				}
				break;
			}		    
		}
		
		return dimValueIDs;
	}

</script>

</head>
<style>
	#modelFilterDiv {
	    width: 99%;
	    height: 100%; 
	    border: 1px solid #ccc;
	    inset-bottom: 0px;
	    padding-bottom: 20px;
	    box-sizing: border-box; 
	}
	
	 #dimValuesDiv {
        min-height: 200px; /* Adjust height as needed */
    }
	       
	.table {
	    display: flex;
	    flex-direction: column;
	    width: 100%;
	    border: 1px;
	}
	
	.row {
	    display: flex;
	    width: 100%;
	}
	
	.cell {    
		position: relative;
	    display: flex;
	    justify-content: center;
	    padding: 10px;
	    border: 1px solid #ccc;
	    box-sizing: border-box;
	    width: 100%;
	}
	
	.cell::after {	
	    position: absolute;
		content: "";
	    width: 13px;
	    height: 13px;
		background-image : url('${root}${HTML_IMG_DIR}/up-arrow.png');
	    background-size: 13px;
	    background-repeat: no-repeat;
	    right: 15px;
	    top: 11px;
	    cursor: pointer;
	}
	
	.cell.fold::after {
		background-image : url('${root}${HTML_IMG_DIR}/down-arrow.png');
	}
	
	.row:has(.cell.fold) + .container{
		display:none;
	}
	
	.header {
	    background-color: #f0f0f0;
	    font-weight: bold;
	    width: 100%;
	}
	
	.row-height {
	    height: 200px; /* Default row height */
	}
	
	.container {
	     display: flex;
	     flex-direction: column;
	     gap: 10px; /* 각 행 사이의 간격 */
	     padding: 10px;
	 }
	
	 .item {
	     display: flex;
	     align-items: center;
	 }
	
	 .item label {
	     flex: 0 0 130px; /* 라벨의 고정 너비 */
	     margin-right: 10px; /* 라벨과 콤보박스 사이의 간격 */
	 }
	
	 .item select {
	     flex: 1; /* 콤보박스의 위치를 동일하게 설정 */
	 }
	      
	.styled-hr {
	    border: done;
	    border-bottom: 1px solid #ccc; 
	    width: 100%; 
	    margin: 5px 0; /* 상하 여백 */
	}
</style>

<body>

<div id="modelFilterDiv" class="mgL5" >
    <div>
        <ul>
            <li class="floatL">Select Option</li> 
 			<li class="floatR" style="margin-right: 10px;margin-bottom: 10px;">
 				<span class="btn_pack medium icon"><span class="reload"></span><input value="Reload" type="button" onclick="fnGetModelFiltered();"></span>
 			</li>
        </ul>
    </div>
    
    <div class="row header">
    	<div class="cell">Object</div>
    </div>
    <div class="container">
    	<c:forEach items="${itemTypeCodeList}" var="itemTypeList">
      		<div  class="item">
      			<input type="checkbox" class="itemTypeList" id="${itemTypeList.CODE}" value="${itemTypeList.CODE}" <c:if test="${itemTypeList.checked eq 'Y'}">checked </c:if> />
       			<label for="checkbox">${itemTypeList.NAME}</label>
	     		
		       	<select id="opacity_${itemTypeList.CODE}" name="opacity_${itemTypeList.CODE}">
		       		<option value="100" ${itemTypeList.opacity eq '100' ? 'selected' : ''} >100%</option>
		       		<option value="80" ${itemTypeList.opacity eq '80' ? 'selected' : ''} >80%</option>
		       		<option value="60" ${itemTypeList.opacity eq '60' ? 'selected' : ''} >60%</option>
		       		<option value="40" ${itemTypeList.opacity eq '40' ? 'selected' : ''} >40%</option>
		       		<option value="20" ${itemTypeList.opacity eq '20' ? 'selected' : ''} >20%</option>
					<option value="0.1">0%</option>
				</select> 
			</div>
      	</c:forEach>
	</div>
    
    <c:if test="${dimTypeList.size() > 0}">
	 	<div class="row header mgT10">
	    	<div class="cell">Dimension</div>
	    </div>
	    <div class="container">
	    	<div class="item">
	    	<c:forEach items="${dimTypeList}" var="dimTypeList">
	    		<input type="radio" class="dimTypeList" id="${dimTypeList.DimTypeID}" name="dimType" value="${dimTypeList.DimTypeID}" onchange="fnShowValues('${dimTypeList.DimTypeID}')">
	     		<label for="${dimTypeList.DimTypeID}">${dimTypeList.DimTypeName}</label>
	      	</c:forEach>
	      	</div>
	      	<div class="styled-hr"></div>
			<div id="dimValuesDiv" class="mgL30 mgT20" style="min-height: 120px;">
		       <div id="dimValues" class="mgL10" ></div>
		    </div>
		</div>
    </c:if>
    
     <c:if test="${symTypeList.size() > 0}">
	 	<div class="row header mgT10">
	    	<div class="cell">Symbol</div>
	    </div>
	    <div class="container">
	    	<div>
	    	<c:forEach var="symList" items="${symTypeList}" varStatus="status">
	    	 	<input type="checkbox" id="${symList.SymTypeCode}" name="${symList.SymTypeCode}" class="symTypeList">
	        	<img src="${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/ICON_${symList.SymTypeCode}.png" alt="${symList.SymbolNm}">
	            <label for="checkbox1">${symList.SymbolNm}</label><br>
		    </c:forEach>
	      	</div>
		</div>
    </c:if>
</div>
</body>

</html>
