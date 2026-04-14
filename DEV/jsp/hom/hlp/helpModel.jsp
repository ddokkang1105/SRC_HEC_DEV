<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript">
	var menuIndex2 = "1 2 3 4";	
	
	$(document).ready(function(){
		// 초기화면 표시:모델 조회Tab
		modelSubTabClick(1);
	});
	
	// [Tab] Click event
	function modelSubTabClick(avg) {
		clickSubTap(avg);
		
		if (avg == 1) {
			$("#modelViewArea").attr("style", "display:block;");
			$("#modelMgtArea").attr("style", "display:none;");
			$("#modelEditArea").attr("style", "display:none;");
			$("#modelReportArea").attr("style", "display:none;");
		} else if (avg == 2) {
			$("#modelViewArea").attr("style", "display:none;");
			$("#modelMgtArea").attr("style", "display:block;");
			$("#modelEditArea").attr("style", "display:none;");
			$("#modelReportArea").attr("style", "display:none;");
		} else if (avg == 3) {
			$("#modelViewArea").attr("style", "display:none;");
			$("#modelMgtArea").attr("style", "display:none;");
			$("#modelEditArea").attr("style", "display:block;");
			$("#modelReportArea").attr("style", "display:none;");
		} else if (avg == 4) {
			$("#modelViewArea").attr("style", "display:none;");
			$("#modelMgtArea").attr("style", "display:none;");
			$("#modelEditArea").attr("style", "display:none;");
			$("#modelReportArea").attr("style", "display:block;");
		}
	}
	
	// [set link color]
	function clickSubTap(avg) {
		var realMenuIndex2 = menuIndex2.split(' ');
		var menuName = "modelSubTab";
		for(var i = 0 ; i < realMenuIndex2.length; i++){
			if (realMenuIndex2[i] == avg) {
				$("#"+menuName+realMenuIndex2[i]).addClass("on");
			} else {
				$("#"+menuName+realMenuIndex2[i]).removeClass("on");
			}
		}
	}
</script>
	
<body>
<div class="SubinfoTabs">
    <ul>
           <li id="modelSubTab1" onclick="modelSubTabClick(1);" class="on"><a><span>모델 조회</span></a></li>
           <li id="modelSubTab2" onclick="modelSubTabClick(2);"><a><span>모델 관리</span></a></li>
           <li id="modelSubTab3" onclick="modelSubTabClick(3);"><a><span>모델 편집</span></a></li>
           <li id="modelSubTab4" onclick="modelSubTabClick(4);"><a><span>프로세스 모델링 </span></a></li>
    </ul>
</div>

<div id="user_manual">
	<div id="modelViewArea">
		<!--  모델조회 -->
		<li class="manualtitle"> :: 모델조회 화면 구성 ::</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model01.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;모델 조회 화면 조정 아이콘</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;모델링 오브젝트 속성 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;미니맵</li>
		
		<li class="manualtitle"> :: 모델 인쇄 페이지 셋업/인쇄 및 이미지 파일로 저장 :: </li>
		<li class="pdT20"><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model02.png""></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;인쇄 페이지 사이즈 설정</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;인쇄 미리 보기 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;이미지 파일로 저장</li>
		
		<li class="manualtitle"> :: 모델 이미지 사이즈 조절, 새 창에서 보기, 모델편집 이동 :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model03.png""></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;실제크기</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;확대 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;축소</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;새 창에서 보기 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;모델 편집 창으로 이동</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num06.png">&nbsp;오브젝트 속성 보이기/감추기</li>
		
		<li class="manualtitle"> :: 오브젝트 속성 편집 :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model04.png""></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;속성조회<br>
			<span> - 선택된 심볼의 상세</span><br>
			<span> - 속성 조회</span><br></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;속성편집 </li>
		
		<li class="manualtitle">:: 오브젝트 상세정보 조회 :: </li>       
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model05.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;심볼 선택 → 마우스 우 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;항목 상세 정보 Pop up </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;모델 리스트 관리 </li>
		<!--  //모델조회 -->
	</div>
	<div id="modelMgtArea">
		<!--  모델관리 -->
		<li class="manualtitle">:: 모델 리스트 조회 :: </li>  
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model06.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;모델 리스트</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;모델 복사, 생성, 삭제, 리스트 다운로드</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;모델 편집, 모델 속성 편집</li>
		
		<li class="manualtitle">:: 모델 생성 및 초기화 :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model07.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;프로세스 리스트 엑셀 템플릿</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;프로세스 모델 초기화</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;프로세스 모델 완성</li>
		
		<li class="manualtitle">:: 모델 신규 생성  :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model08.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;[Add]버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;모델명 입력</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;모델 카테고리 선택<br>
			<span> -  Base : 현행 모델</span><br>
			<span> - TEMP : 임시 모델</span><br>
			<span> - TOBE : 미래모델</span><br>
			<span> -  Version : 백업 모델(Read only)    </span></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;모델 유형 선택<br>
			<span> - Process Flow chart : 단위 프로세스(L4) 흐름도</span><br>
			<span>  - Structure model : 프로세스 구조도(L2 or L3)</span><br>
			<span>  - E2E Scenario map </span>		     </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;[Save]버튼을 클릭하여 저장<br></li>
		
		<li class="manualtitle">:: 모델 복사  :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model09.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;복사 대상 모델 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;[Copy]버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;신규 생성 모델 명 입력 및 모델 카테고리 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;[Copy]버튼 클릭하여 복사</li>
        <!--  //모델관리 -->
     </div>	
     <div id="modelEditArea">   
        <!--  모델편집-->
		<li class="manualtitle">:: 오브젝트(심볼) 추가  :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model10.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;팔레트에서 심볼 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;심볼 Drag</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;명칭 변경(F2 or 마우스 클릭)</li>
        
        <li class="manualtitle">:: 연결선 추가  :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model11.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;연결선(꺽인 선)</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;연결선(직선)</li>
        
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;팔레트에서 연결선 선택 후 소스 심볼 경계선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;타겟 심볼 경계선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;연결선 선택 → F2 → 연결선 정보 입력</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num06.png">&nbsp;연결선 위치 조정 연결선 선택  → 마우스 drag</li>

        <li class="manualtitle">:: 오브젝트 링크 편집 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model12.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;심볼 선택 → 마우스 우측버튼 → 링크 편집 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;연결시킬 오브젝트 검색 및 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;연결된 오브젝트 명 확인 및 링크 열기</li>        
        
        <li class="manualtitle">:: 오브젝트 속성 편집 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model13.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;심볼 선택 → 마우스 우측버튼 → 속성 편집 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;속성 편집 및 저장</li>        
                
        <li class="manualtitle">:: 항목상세정보 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model14.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;심볼 선택 → 마우스 우측버튼 → 항목상세정보 선택 </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;개요와 연관항목 정보 확인</li>         
        
        <li class="manualtitle">:: 오브젝트 심볼변경 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model15.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;심볼 선택 → 마우스 우측버튼  → 심볼변경 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;변경할 심볼을 선택 </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp; [Add]버튼 클릭</li>         
        
        <li class="manualtitle">:: 모델 저장 및 릴리즈 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model16.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;임시저장 : 모델 편집 메뉴에서만 변경된 모델이 조회되며, 모델 조회 화면에서는 변경 이 전 버전의 모델만 조회
                <Br>신규 생성되거나 업데이트된 오브젝트가 DB에 반영되지 않음</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;릴리즈 : 모든 사용자 및 조회화면에서 변경된 내용이 조회되고 변경된 오브젝트 값이 DB에 업데이트됨</li>                 
        <!--  //모델편집 -->
   </div>
   <div id="modelReportArea">    
        <!--  모델비교레포트 -->
		 <li class="manualtitle">:: 모델비교 리포트   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model17.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;[Report]버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;Model comparison report [EXE] 버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;비교할 두 Model ID 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;[Report] 버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;모델 비교 리스트 확인<br>
			<span>- NEW : 새로 생성된 아이템</span><br>
			<span>- Deleted : 삭제된 아이템</span><br>
			<span>- NoChange : 그대로인 아이템</span><bmmr></li>
			
		<li class="manualtitle">:: 모델검증 리포트   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model18.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;[Report]버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;Validation check for items [EXE] 버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;검증할 Model ID 선택 </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;[Report] 버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;Outbound check/ Inbound check 리스트 확인</li>
	</div> 
</div>
</body>
</html>