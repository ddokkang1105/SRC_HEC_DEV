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
		overflow:hidden;
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
	
  </style>
</head>
 
<body>
    	<!-- <section id="controls" class="dhx_sample-controls">
			<button class="dhx_sample-btn dhx_sample-btn--flat" onclick="runEditor()">Edit</button>
		</section> -->
		<!-- <section>
		    default export to a PDF file
			<button class="cmm_btn btn--save"" onclick="roleMindMap.export.pdf()">Export to PDF</button>
		    default export to a PNG file
			<button class="cmm_btn btn--save"" onclick="roleMindMap.export.png()">Export to PNG</button>
		</section> -->
		<div class="dhx_sample-widget" id="diagram" height="100%"></div>
		
		<script>
		
			var roleMindMap = new dhx.Diagram("diagram", {
				type: "mindmap",
				typeConfig: {
					side : {
						left : ${leftItems},
						right : ${rightItems}
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
			    if( id.substr(0,3) != "TXT"){
			    	fnDetail(id);
			    }

			});
			
			function fnOpenTeamInfoMain(teamID){
				var w = "1200";
				var h = "800";
				var url = "orgMainInfo.do?id="+teamID;
				window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			}
			
			//diagram.data.parse(testData);
			roleMindMap.data.parse(${diagramListData});
			
			function fnDetail(avg){		
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop";
				var w = 1200;
				var h = 900;
				itmInfoPopup(url,w,h,avg);
			}	
		</script>
</body>
</html>