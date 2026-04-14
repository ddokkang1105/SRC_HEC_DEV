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
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/arcMain.css"/>
<style>
	.stpContents_box{
		min-width:300px;
	}
</style>
<script type="text/javascript">
    var divText = "";
    var l1ItemID = "";
    var l2ItemID = "";
    var l2Cnt = 0;
    var l2Index = 0;
    
    
    $(document).ready(function(){
   		var defMenuItemID = "${defMenuItemID}";
   		if(defMenuItemID != "") {
   			setSubItems(defMenuItemID,"${arcCode}");
   			
   		}
   		
		
		$(".sec01").attr("style","height:"+(setWindowHeight() - 65)+"px;");

		if(defMenuItemID == "137315") {
			$("#nav_tab").attr("style","height:"+(setWindowHeight()  -137)+"px;display:none;");
			$("#nav_tab2").attr("style","height:"+(setWindowHeight()  -137)+"px;");
		}
		else {
			$("#nav_tab").attr("style","height:"+(setWindowHeight()  -137)+"px;");
			$("#nav_tab2").attr("style","height:"+(setWindowHeight()  -137)+"px;display:none;");			
		}
		// 화면 크기 조정
		window.onresize = function() {
			$(".sec01").attr("style","height:"+(setWindowHeight() - 65)+"px;");
			$("#nav_tab").css("height",(setWindowHeight()  -137)+"px");
			$("#nav_tab2").css("height",(setWindowHeight()  -137)+"px");
		};
    });
    
    function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
    
    function createSubItemDiv(avg){
    	var subList = avg.split("@");
    	var arcCode = $("#arcCode").val();
    	var funcName = "setStpL1";
    	var childCnt = "";
    	 
        for(var i=0; i<subList.length;i++) { //
	        var temp = subList[i].split("_");
	        childCnt = temp[5];
	        subChildCnt = temp[6];

			if(i > 0 && temp[2] == "1" && l2ItemID != temp[0] && l2ItemID != "") {
				divText += "</ul></div>";	
			}

			if(i > 0 && temp[2] == "0" && l1ItemID != temp[0]) {
				divText += "</ul></div></div>";
			}
			
			if(temp[2] == "0") {
				divText += "<div id='Div"+temp[0]+"' class='stpContents_box'><div class='title_sub' onClick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>"+temp[1]+"</div>";
				l1ItemID = temp[0];
				l2ItemID = "";
			}
			else if(temp[2] == "1"){
				divText += "<div class='dcontainer'><p onClick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>"+temp[1];
							
				if(subChildCnt > 0 && childCnt > 0) {
					divText += " ("+temp[6]+")</p><span id='showIcon"+temp[0]+"' onClick='showSubItem(\""+temp[0]+"\")' class='openicon open' title='Show'>&nbsp;&nbsp;&nbsp;▲</span><ul class='open' id='"+temp[0]+"' style=''>";
				}
				else { 
					divText += "</p>";				
				}
				
				l2ItemID = temp[2];
			}
			else if(temp[2] == "2"){
				divText += "<li><span></span><a onclick='"+funcName+"(\""+arcCode+"\",\""+temp[0]+"\");'>"+temp[1]+"</a></li>";
			}
        }
        
    	$("#stpContent1").html(divText);
    	var subHeight = $("#stpContent1").height();
    	var winHeight = setWindowHeight();
		
//     	if(subHeight > winHeight) {
// 			$(".nav_tab").attr("style","height:"+( subHeight + 100)+"px;");
//     	}
//     	else {
// 			$(".nav_tab").attr("style","height:900px;");    
//     	}
		
    }
    
    function showSubItem(avg) {
    	if(!$("#"+avg).hasClass("open")) {
    		$("#"+avg).attr("style","");
    		$("#showIcon"+avg).html("&nbsp;&nbsp;&nbsp;▲");
    		$("#"+avg).addClass("open");
    	}
    	else {
    		$("#"+avg).attr("style","display:none");
    		$("#"+avg).removeClass("open");
    		$("#showIcon"+avg).html("&nbsp;&nbsp;&nbsp;▼");
    	}
    }
    
    function checkSubItemCnt(avg,avg2) {
    	ajaxPage("zHkfcCreateSubItemDiv.do", "itemID="+avg+"&arcCode="+avg2+"&level=4&itemClassCode=CL05004&itemClassCodeList='CL05001','CL05002','CL05003','CL05004'", "saveFrame");
    }
    function setSubItems(avg,avg2){
    	
		if(avg == "137315") {
			$("#nav_tab").attr("style","display:none;");
			$("#nav_tab2").attr("style","height: 802px;");
		}
		else {
			$("#nav_tab").attr("style","");
			$("#nav_tab2").attr("style","display:none;");
			
			divText = "";    	
	    	checkSubItemCnt(avg,avg2);


	    	$("ul#l0List > li").each(function(i) {
	    		var value = $(this).attr('value');
	    		if(avg == value) {
	    			$(this).addClass("on");    			
	    		}
	    		else {
	    			$(this).removeClass("on");  
	    			
	    		}
	    	});  
		}
		
        
    }
    function setStpL1(arcCode,id) {
    	parent.fnRefreshPageCall(arcCode,id,"V");
    }
    
    
</script>

</head>

<BODY style="overflow:auto;">

<input id="arcCode" type="hidden" value="${arcCode}"></input>
<div id="stpContainer">
<div id="stpContents" class="pdT10 pdL10 pdR10">
<ul class="row">
	<li class="col-4">
	    <div class="sec01"><!--style="width:1450px;" -->
	    <div class="whitebar">
	   		<input id="tab4" type="radio" name="tabs" <c:if test="${defMenuItemID == '137315'}">checked</c:if>>
			<label for="tab4" onClick="setSubItems('137315','${arcCode}')">KGP 프로세스 체계도</label>
			<input id="tab2" type="radio" name="tabs" <c:if test="${defMenuItemID == '112566'}">checked</c:if>>
			<label for="tab2" onClick="setSubItems('112566','${arcCode}')">Management</label>
	   		<input id="tab1" type="radio" name="tabs" <c:if test="${defMenuItemID == '112568'}">checked</c:if>>
			<label for="tab1" onClick="setSubItems('112568','${arcCode}')">Customer Oriented</label>
			<input id="tab3" type="radio" name="tabs" <c:if test="${defMenuItemID == '112570'}">checked</c:if>>
			<label for="tab3" onClick="setSubItems('112570','${arcCode}')">Support</label>
	    </div>
				    	<div id="nav_tab" class="nav_tab" >
							<div id="stpContent1"><!--  style="width:1500px;" -->
							</div>
						</div>
							<div id="nav_tab2" class="nav_tab" >
							<div id="stpContent2">
                                        <div class="stpContents_box" id="Div175336">
                                            <div class="title_sub" onclick='setStpL1("${arcCode}","175336");'>품질매뉴얼
                                            </div>
                                            <div class="dcontainer">
                                                <ul id="">
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","177307");'>품질매뉴얼 관리</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","177309");'>회사소개</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","177311");'>품질방침</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","177313");'>품질목표</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","177315");'>목적/적용범위/관련규격</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","177317");'>품질경영시스템 프로세스</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","177319");'>리더십 및 의지 표명</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","177321");'>조직 역할, 책임 및 권한</a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="stpContents_box" id="Div112566">
                                            <div class="title_sub" onclick='setStpL1("${arcCode}","112566");'>Management</div>
                                            <div class="dcontainer">
                                                <p onclick='setStpL1("${arcCode}","113679");'>경영기획 (3)</p>
                                                <span title="Show" class="openicon open" id="showIcon113679" onclick='showSubItem("113679")'>&nbsp;&nbsp;&nbsp;</span>
                                                <ul id="113679">
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113683");'>리스크 관리P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113681");'>경영계획관리P</a>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="dcontainer">
                                                <p onclick='setStpL1("${arcCode}","113685");'>경영운영 (2)</p>
                                                <span title="Show" class="openicon open" id="showIcon113685" onclick='showSubItem("113685")'>&nbsp;&nbsp;&nbsp;</span>
                                                <ul id="113685">
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113687");'>품질경영시스템관리P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113689");'>조직 및 업무분장P</a>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="dcontainer">
                                                <p onclick='setStpL1("${arcCode}","113695");'>경영검토 (2)</p>
                                                <span title="Show" class="openicon open" id="showIcon113695" onclick='showSubItem("113695")'>&nbsp;&nbsp;&nbsp;</span>
                                                <ul id="113695">
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113701");'>내부심사P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113697");'>경영검토P</a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="stpContents_box" id="Div112568" style="width: 550px;">
                                            <div class="title_sub" onclick='setStpL1("${arcCode}","112568");'>Customer Oriented</div>
                                            <div class="dcontainer" style="width: 240px; float: right;">
                                                <p onclick='setStpL1("${arcCode}","113911");'>생산 (8)</p>
                                                <span title="Show" class="openicon open" id="showIcon113911" onclick='showSubItem("113911")'>&nbsp;&nbsp;&nbsp;</span>
                                                <ul class="open" id="113911">
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113921");'>공정관리P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113941");'>사내 6M 변경 관리P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113913");'>생산관리P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113919");'>제품식별 및 추적성 관리P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113947");'>자재 및 완제품 관리P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113935");'>공정 및 최종검사P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113955");'>부적합품 처리P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113943");'>품질 및 신뢰성 시험(제품심사)P</a>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="dcontainer" style="width: 240px;">
                                                <p onclick='setStpL1("${arcCode}","113707");'>기획/영업 (1)</p>
                                                <span title="Show" class="openicon open" id="showIcon113707" onclick='showSubItem("113707")'>&nbsp;&nbsp;&nbsp;</span>
                                                <ul class="open" id="113707">
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113715");'>입찰 및 계약검토P</a>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="dcontainer" style="width: 240px;">
                                                <p onclick='setStpL1("${arcCode}","113721");'>설계/개발 (7)</p>
                                                <span title="Show" class="openicon open" id="showIcon113721" onclick='showSubItem("113721")'>&nbsp;&nbsp;&nbsp;</span>
                                                <ul class="open" id="113721">
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113723");'>제품개발P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113725");'>제품개발(전기이륜차)P</a>
                                                    </li>
                                                    <%--<li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113817");'>제어개발P</a>
                                                    </li> --%>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113831");'>설비개발 및 관리P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113853");'>부품개발P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113861");'>외주초도품승인P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113863");'>양산부품승인P</a>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="dcontainer" style="width: 240px; float: right;">
                                                <p onclick='setStpL1("${arcCode}","113959");'>인도/서비스 (4)</p>
                                                <span title="Show" class="openicon open" id="showIcon113959" onclick='showSubItem("113959")'>&nbsp;&nbsp;&nbsp;</span>
                                                <ul id="113959">
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113971");'>고객만족 관리P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113963");'>0-Km클레임 처리P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113961");'>필드클레임 처리P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113969");'>시정 및 예방조치P</a>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="dcontainer" style="width: 240px;">
                                                <p onclick='setStpL1("${arcCode}","113869");'>구매 (4)</p>
                                                <span title="Show" class="openicon open" id="showIcon113869" onclick='showSubItem("113869")'>&nbsp;&nbsp;&nbsp;</span>
                                                <ul id="113869">
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113871");'>협력사관리P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113893");'>구매관리P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113905");'>수입검사P</a>
                                                    </li>
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113909");'>협력사6M 변경 관리P</a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="stpContents_box" id="Div112570">
                                            <div class="title_sub" onclick='setStpL1("${arcCode}","112570");'>Support</div>
                                            <div class="dcontainer">
                                                <p onclick='setStpL1("${arcCode}","113981");'>교육/훈련 (1)</p>
                                                <span title="Show" class="openicon open" id="showIcon113981" onclick='showSubItem("113981")'>&nbsp;&nbsp;&nbsp;</span>
                                                <ul id="113981">
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113983");'>교육 훈련P</a>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="dcontainer">
                                                <p onclick='setStpL1("${arcCode}","113989");'>작업환경 (1)</p>
                                                <span title="Show" class="openicon open" id="showIcon113989" onclick='showSubItem("113989")'>&nbsp;&nbsp;&nbsp;</span>
                                                <ul id="113989">
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","113991");'>측정기 관리P</a>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="dcontainer">
                                                <p onclick='setStpL1("${arcCode}","114019");'>문서/기록 (1)</p>
                                                <span title="Show" class="openicon open" id="showIcon114019" onclick='showSubItem("114019")'>&nbsp;&nbsp;&nbsp;</span>
                                                <ul id="114019">
                                                    <li>
                                                        <span></span>
                                                        <a onclick='setStpL1("${arcCode}","114021");'>문서 및 자료관리P</a>
                                                    </li>
                                                </ul>
                                            </div><%-- <div class="dcontainer"><p onclick='setStpL1("${arcCode}","114027");'>기타 (1)</p><span title="Show" class="openicon open" id="showIcon114027" onclick='showSubItem("114027")'>&nbsp;&nbsp;&nbsp;</span><ul id="114027"><li><span></span><a onclick='setStpL1("${arcCode}","114029");'>기타P</a></li></ul></div> --%></div>
                                    </div>
					
					</div>
				</li>
			</ul>
		</div>
	</div>

<div style="display:none;"><iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe></div>
</BODY>