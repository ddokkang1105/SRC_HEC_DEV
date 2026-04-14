<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagIncV7.jsp"%>
<!DOCTYPE html>
<html>
<head>
  <script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxDiagram/codebase/diagramWithEditor.js?v=6.0.1"></script>
  <link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxDiagram/codebase/diagramWithEditor.min.css?v=6.0.1">

  <style>
  
	html, body {
		height:100%;
		padding:0;
		margin:0;
		overflow:auto;
	}
	html, body, .dhx_diagram {
		background: #fff;
	}
	.dhx_sample-container__without-editor {
 		height: calc(100% - 61px); 
	}
	.dhx_sample-container__with-editor {
 		height: calc(100% - 61px); 
	}
	.dhx_sample-widget {
		height: 100%;
	}
	.dhx_diagram__container{
		height : 600px !important;
	}
	}
	.sidebar__container, .dhx_sample-controls {
        background: var(--dhx-background-primary);
    }   
	.dhx_sample-slider__container {
        width: 350px;
    }
    .dhx_sample-controls {
	    display: flex;
	    justify-content: center;
	}
  </style>
</head>

<body>
		<section class="dhx_sample-controls">
			<div class="dhx_sample-slider__container" id="slider"></div>
		</section>	
		<div  id="diagram" width="100%" height="100%">
			<section id="controls">
			    <!-- default export to a PDF file -->
<!-- 				<button class="cmm_btn btn--save"" onclick="roleMindMap.export.pdf()">Export to PDF</button> -->
<!-- 			    default export to a PNG file -->
<!-- 				<button class="cmm_btn btn--save"" onclick="roleMindMap.export.png()">Export to PNG</button> -->
<!-- 				<button class="cmm_btn btn--save"" onclick="fn3MonthReload(90)">3개월</button>
				<button class="cmm_btn btn--save"" onclick="fn3MonthReload()">Back</button> -->
			</section>
			
			<div class="dhx_sample-widget" ></div>
		</div>
	
</body>


		<script>
		 	var diagramListData = ${diagramListData};
		    var leftItems = ${leftItems};
		    var rightItems = ${rightItems};
		    
			var roleMindMap = new dhx.Diagram("diagram", {
				type: "mindmap",
				typeConfig: {
					side : {
						left : leftItems,
						right : rightItems
					}
				},
			});

			
// 			const editor = new dhx.DiagramEditor("editor", {
// 				type: "mindmap",
// 			});

// 			const editorCont = document.querySelector("#editor");
			const diagramCont = document.querySelector("#diagram");
			const controls = document.querySelector("#controls");
			const container = document.querySelector("#container");
			
			const WITH_EDITOR = "dhx_sample-container__with-editor";
			const WITHOUT_EDITOR = "dhx_sample-container__without-editor";

			function expand() {
				diagramCont.style.display = "none";
				controls.style.display = "none";
				editorCont.style.display = "block";
				container.classList.remove(WITHOUT_EDITOR);
				container.classList.add(WITH_EDITOR);
			}

			function collapse() {
				diagramCont.style.display = "block";
				controls.style.display = "flex";
				editorCont.style.display = "none";
				container.classList.remove(WITH_EDITOR);
				container.classList.add(WITHOUT_EDITOR);
			}

// 			function runEditor() {
// 				expand();
// 				editor.import(roleMindMap);
// 			}

// 			editor.events.on(" ", function () {
// 				collapse();
// 				roleMindMap.data.parse(editor.serialize());
// 			});

// 			editor.events.on("ResetButton", function () {
// 				collapse();
// 			});
			
			roleMindMap.events.on("itemClick", (id, event) => {
			    if(id != "cxnPrc" && id.substr(0,6) != "PreL1_" && id.substr(0,7) != "PostL1_" && id.substr(0,1) != "u"&& id.substr(0,3) != "4d_" && id.substr(0, 3) != "4s_" && id.substr(0, 3) !="4q_" && id.substr(0, 3) != "4p_" && id.substr(0,3) != "tr_"){
			    	fnDetail(id);
			    }
			    if(id.substr(0,3) == "4d_" || id.substr(0,3) == "4s_") fnDetail(id.split("_")[2]);
			    if(id.substr(0,3) == "4p_" || id.substr(0,3) == "4q_") fnDetail(id.split("_")[1]);
			    //if(id.substr(0,3) == "tr_") fnOpenTeamInfoMain(id.split("_")[1]);
			});
			
			function fnOpenTeamInfoMain(teamID){
				var w = "1200";
				var h = "800";
				var url = "orgMainInfo.do?id="+teamID;
				window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			}
			
			//diagram.data.parse(testData);
			//roleMindMap.data.parse(${diagramListData});
			roleMindMap.data.parse(diagramListData);
			
			function fnDetail(avg){		
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
				var w = 1200;
				var h = 900;
				itmInfoPopup(url,w,h,avg);
			}	
			

			function fn3MonthReload(avg){
			    var url = "zdlencRoleMindMap.do";
			    var data = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}";
			    if (avg) {
			        data += "&Month=" + avg;
			    }
			    var target = "diagram";

			    // ajax로 데이터 로드
			    ajaxPage(url, data, target);
			}
			$(document).ready(function() {
					const diagramContainer = document.querySelector("#diagram");
					
					// 전체 창 크기를 기준으로 계산
					const windowWidth = window.innerWidth;
					const windowHeight = window.innerHeight;

					const diagramSize = roleMindMap._diagramSize;
					//console.log(diagramSize);
					const diagramWidth = diagramSize.x-diagramSize.left;
					const diagramHeight = diagramSize.y-diagramSize.top;
					//alert (windowWidth+ " "+diagramWidth+" "+ (diagramWidth*1.1)+"//"+windowHeight+" "+diagramHeight*1.3)
					// 각각 가로, 세로 기준으로 필요한 스케일 계산
					const scaleX = (windowWidth) / (diagramWidth*1.1);
					const scaleY = (windowHeight) / (diagramHeight*1.3);

					// 최종 스케일은 둘 중 작은 값
					const scale = Math.min(scaleX, scaleY, 1); // 1 이상 커지지 않도록 제한

					// 스케일 적용
					roleMindMap.config.scale = scale;
					roleMindMap.paint();

					const tickTemplate = value => value;
					const slider = new dhx.Slider("slider", {
						min: 0.1,
						max: 1,
						tooltip: false,
						step: 0.05,
						tick: 1,
						majorTick: 2,
						value: scale,
						tickTemplate: tickTemplate
					});

					slider.events.on("change", function(value) {
						roleMindMap.config.scale = value;
							roleMindMap.paint();
					});

				});
		</script>
		


</html>