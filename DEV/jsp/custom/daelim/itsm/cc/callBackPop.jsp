<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&AgentID=${AgentID}";
  	var CallBackKey = "${CallBackKey}";
  	
	$(document).ready(function(){
	
		$("#changAgentID").on("change", function(){
  			var changAgentID = $("#changAgentID").val();
  		});
		
		fnSelectSetting("Y");
		
		/*** SR Select function start ***/
		function fnSelectSetting(all) {
			
			resetSelect(all);
			fnSelect('changAgentID', selectData, 'getCallbackUserlist', '${changAgentID}', '- 담당자 변경 -','callback_SQL');
		}
		
		// select option reset
		function resetSelect(all){
			
			$("#changAgentID").val("");
			
			if(all == "Y"){
				$("#srAreaSearch").val("");
				$("#srArea1").val("");
				$("#srArea2").val("");
			}
			return;
		}
		
		function fnCheckValidation(){
			var CallRet = $("#CallRet").val();
			if(CallRet == ""){ alert("콜백결과 등록"); isCheck = false; return isCheck;}
		}
		
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
</script>

<body>

<input type="hidden" id="reqSeq" name="reqSeq" value="${reqSeq != null ? reqSeq : ''}" />
<input type="hidden" id="crudMode" name="crudMode" value="${crudMode != null ? reqSeq : ''}" />
<input type="hidden" id="varSeq" name="varSeq"  />

<div class="border-section">
	<div class="btn-wrap page-subtitle pdB10 pdT10" style="display: flex; align-items: center; gap: 10px;">
		콜백등록
		
		<div class="sline tit last" style="margin-left: auto; text-align: right;">
			<select id="changAgentID" name="changAgentID" class="sel" style="width:150px;" >
				<option value=''>담당자 변경 대상</option>
			</select>
		</div>	
		<div class="btns">
			<button id="showDesc" class="secondary" style="height: 27px;" onclick="handleClick()"> 담당자변경</button>
			<button id="new"  class="secondary" style="height: 27px;" onclick="callbackNew()">신규등록</button>	
			<button id="save" class="secondary" style="height: 27px;" onclick="callbackSave()">저장</button>		
		</div>
	</div>
	<table class="new-form form-column-8" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="8%">
		    <col width="17%">
		 	<col width="8%">
		    <col width="17%">
		    <col width="8%">
		    <col width="17%">
		    <col width="8%">
		    <col width="17%">
		</colgroup>
		<tr>	
			<th class="alignL pdL10" style="text-align: center;">고객명</th>
			<td class="sline tit" id="ReqNm" >${callbackDtl.ReqNm}</td>
			<th class="alignL pdL10" style="text-align: center;">총 콜거부횟수</th>
			<td class="sline tit" >${callbackDtl.RejectCount}</td>	
			<th class="alignL pdL10" style="text-align: center;">콜백/포기</th>
			<td class="sline tit" id="DtlCallRetNm" >${callbackDtl.DtlCallRetNm}</td>
			<th class="alignL pdL10" style="text-align: center;">의뢰자 전화번호</th>
			<td class="sline tit last" id="ReqNum">${callbackDtl.ReqNum}
			<div class="btns" style="display:inline-block;margin-left:5px;">
				<button id="makeCall" class="secondary" style="height: 27px;"  onclick="callCTI('${callbackDtl.ReqNum}')">전화걸기</button>
			</div>
			</td>
		</tr>
		<tr>
			<!-- 긴급여부 -->
			<th class="alignL pdL10">콜백결과<font color="red">&nbsp;*</font></th>
			<td colspan="7" >
				<input type="radio" name="DtlCallRet" id="CallRet01" value="01" checked><label for="CallRet01">통화성공</label>
				<input type="radio" name="DtlCallRet" id="CallRet02" value="02"><label for="CallRet02">통화실패</label>
				<input type="radio" name="DtlCallRet" id="CallRet03" value="03"><label for="CallRet03">콜백포기</label>

			</td>
		</tr>
		<tr>
			<th class="alignL pdL10">처리내용</th>
			<td style="height:200px;" class="tit last" colspan="7">
				<textarea  class="SRAT0001" id="Memo" name="Memo" style="width:100%;height:200px; border:1px solid #ddd; border-radius:6px; padding:10px;">${callbackDtl.Memo}</textarea>
			</td>
		</tr>
			
	</table>
    
    <div class="pdT20 pdB10"></div>
	<div style="width:99%; height:300px;" id="grid"></div>
    <div id="pagination"></div>
</div>
	
</body>
<script type="text/javascript"> 
	var crudMode;
	let AgentID = "${AgentID}";
	var varSeq ;
	var clickTime ;
	var cbStartTime ;
	
	fnSearch();
	
	/* 내역조회 이므로 CALLBACK_DTL 의 데이터 조회해서 뿌릴것 shkim  */
	var grid = new dhx.Grid("grid", {
	    columns: [
	    	{ width: 50, id: "no", header: [{ text: "번호" , align: "center" }], align: "center"},
	    	{ hidden:true, id: "Seq", header: [{ text: "시퀀스" , align: "center" }], align: "center"},
	    	{ hidden:true, id: "CallBackKey", header: [{ text: "CallBackKey" , align: "center" }], align: "center" },
	    	{ width: 180, id: "ReqNum", header: [{ text: "통화번호" , align: "center" }], align: "center" },
	        { width: 200, id: "RegDayTime", header: [{ text: "시작일시" , align: "center" }], align: "center" },
	        { width: 200, id: "LastUpdated", header: [{ text: "완료일시" , align: "center" }], align: "center" },
	        { width: 130, id: "AgentNm", header: [{ text: "담당자" , align: "center" }], align: "center" },
	        { hidden:true, id: "CallRet", header: [{ text: "통화상태id" , align: "center" }], align: "center" },    
	        { width: 150, id: "CallRetNm", header: [{ text: "통화상태" , align: "center" }], align: "center" },     
	        { width: 500, id: "Memo", header: [{ text: "처리내용" , align: "center" }], align: "left" },
	    ],
	    
	    autoWidth: true,
	    autoHeight: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false
	  
	});

	grid.events.on("cellClick", function (row,column,e) {
		$("#Memo").val(row.Memo);
		$("#ReqNum").val(row.ReqNum);
		$("#ReqNm").val(row.ReqNm);
		$("#DtlCallRetNm").text(row.CallRetNm);
		$("#varSeq").val(row.Seq);
		
		
		var callRetselectedValue = row.CallRet;  // 실제 데이터와 연결 필요
	    
	    // 해당하는 라디오 버튼 선택
	    var selectedRadio = document.querySelector('input[name="DtlCallRet"][value="' + callRetselectedValue + '"]');

	    if (selectedRadio) {
	        selectedRadio.checked = true;
	    } else {
	        // 라디오 버튼이 없을 경우 '통화실패' 선택
	        document.querySelector('input[name="DtlCallRet"][value="02"]').checked = true; 
	    }
	
	});
	
	function fnSearch(){ 
		var selectType = $("#selectType").val();
		var CallBackKey = "${CallBackKey}";
		var sqlID = "callback_SQL.selectCallbackDtl";
		
		var param = "&sqlID="+sqlID+"&CallBackKey="+CallBackKey+"&AgentID="+${AgentID}+"&varSeq="+varSeq;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);				
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
		
	}
	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());
	}
	
	
	// CTI 장비 전화걸기 호출 함수
	function callCTI(reqNum) {
	    if (window.opener && typeof window.opener.test === "function") {
	        window.opener.test(reqNum);
	    } else {
	        console.error("부모 창의 test 함수가 존재하지 않거나 접근할 수 없습니다.");
	    }
	}
	
	
 	function handleClick() {
	    var selectElement = document.getElementById("changAgentID");
	    var selectedOption = selectElement.options[selectElement.selectedIndex];
	    var selectedValue = selectedOption.value;
	    var selectedText = selectedOption.text;
	    crudMode ="U";
	    
	    if (selectedValue) {
	        console.log("선택된 ID: " + selectedValue + "\n선택된 옵션: " + selectedText);
	    } else {
	        alert("담당자를 선택하세요.");
	        return;
	    }
	    
	    //인자보내서 컨트롤러에서 모두 처리
	    fetch("/callBackPop.do?sessionLoginId=${sessionScope.loginInfo.sessionLoginId}&crudMode="+crudMode+"&NewAgentID="+selectedValue+"&NewAgentName="+selectedText+"&CallBackKey="+CallBackKey, {})    
		.then(data => {
			grid.data.parse(data);
			$('#loading').fadeOut(150);
			  // 변경 완료 알림창 띄우기
		    alert("변경이 완료되었습니다.");
			  
		    window.close();
			window.opener.location.reload();
			
		})
		.catch(error => {
		    console.error('Error:', error);
		    // 오류 발생 시 알림
		    alert("처리 중 오류가 발생했습니다.");
		    $('#loading').fadeOut(150);  // 로딩 화면 숨기기
		 });
				
	}

	//콜백등록 내용 저장
	function callbackSave() {

		var callbackResult = document.querySelector('input[name="DtlCallRet"]:checked').value;
        var memo = document.getElementById('Memo').value;
        
        let AgentID ="${AgentID}";
        
		if (crudMode === "C1") {
	        crudMode ="C"
			fetch("/callBackPop.do?sessionLoginId=${sessionScope.loginInfo.sessionLoginId}&crudMode="+crudMode+"&callbackResult="+callbackResult+"&memo="+memo+"&CallBackKey="+CallBackKey+"&reqSeq="+reqSeq+"&AgentID="+AgentID+"&cbStartTime="+cbStartTime, {})
			.then(res => {
	            if (!res.ok) {
	                throw new Error(`HTTP error! Status: ${res.status}`);
	            }
	            return res.text();
	        })
	       
	    	fnSearch();
	    	location.reload();
	        
		}
		else{
			alert("신규등록 버튼 클릭 후 내용 저장해주시기 바랍니다.");
		}
	}
	
	//신규입력
	function callbackNew(){
	    // 모든 radio 버튼 초기화
	    var radioButtons = document.querySelectorAll('input[name="DtlCallRet"]');
	    radioButtons.forEach(function(radio) {
	        radio.checked = false; // 모든 라디오 버튼 선택 해제
	    });

	    crudMode ="C1"
	    
	    document.getElementById("CallRet01").checked = true;
	    document.getElementById("Memo"). value = '';
	    document.getElementById("DtlCallRetNm").innerText = ''; // 콜백/포기
	    
	    clickTime = new Date();
	    cbStartTime =  clickTime.toISOString().slice(0, 19).replace("T", " ");
	    console.log("cbStartTime : "+ cbStartTime);
	}
	
	
	
</script>

