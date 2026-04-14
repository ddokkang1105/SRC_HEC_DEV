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
		<section>
		    <!-- default export to a PDF file -->
			<button class="cmm_btn btn--save"" onclick="diagram.export.pdf()">Export to PDF</button>
		    <!-- default export to a PNG file -->
			<button class="cmm_btn btn--save"" onclick="diagram.export.png()">Export to PNG</button>
		</section>
		<div class="dhx_sample-widget" id="diagram" height="100%"></div>
		
		<script>
		
			var diagram = new dhx.Diagram("diagram", {
				type: "mindmap",
				typeConfig: {
					direction: "right",
				},
			});
			
// 			const editor = new dhx.DiagramEditor("editor", {
// 				type: "mindmap",
// 			});

// 			const editorCont = document.querySelector("#editor");
// 			const diagramCont = document.querySelector("#diagram");
// 			const controls = document.querySelector("#controls");
// 			const container = document.querySelector("#container");
			
// 			const WITH_EDITOR = "dhx_sample-container__with-editor";
// 			const WITHOUT_EDITOR = "dhx_sample-container__without-editor";

// 			function expand() {
// 				diagramCont.style.display = "none";
// 				controls.style.display = "none";
// 				editorCont.style.display = "block";
// 				container.classList.remove(WITHOUT_EDITOR);
// 				container.classList.add(WITH_EDITOR);
// 			}

// 			function collapse() {
// 				diagramCont.style.display = "block";
// 				controls.style.display = "flex";
// 				editorCont.style.display = "none";
// 				container.classList.remove(WITH_EDITOR);
// 				container.classList.add(WITHOUT_EDITOR);
// 			}

// 			function runEditor() {
// 				expand();
// 				editor.import(diagram);
// 			}

// 			editor.events.on(" ", function () {
// 				collapse();
// 				diagram.data.parse(editor.serialize());
// 			});

// 			editor.events.on("ResetButton", function () {
// 				collapse();
// 			});
			
			diagram.events.on("itemClick", (id, event) => {
			    if(id != "cxnPrc" && id.substr(0,3) != "CLS" && id.substr(0,1) != "u"&& id.substr(0,3) != "4d_" && id.substr(0,3) != "tr_" && !id.includes("Process_") && !id.includes("Team_")){
			    	fnDetail(id);
			    }
			    if(id.substr(0,3) == "4d_") fnDetail(id.split("_")[id.split("_").length-1]);
			    if(id.substr(0,3) == "tr_") fnOpenTeamInfoMain(id.split("_")[1]);
			});
			
			function fnOpenTeamInfoMain(teamID){
				var w = "1200";
				var h = "800";
				var url = "orgMainInfo.do?id="+teamID;
				window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			}
			
// 			diagram.events.on("lineClick", function(id, events) {
// 			    console.log("LINE CLICK : "+ id);
// 			});

			//diagram.data.parse(testData);
			diagram.data.parse(${diagramListData});
			
			function fnDetail(avg){		
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
				var w = 1200;
				var h = 900;
				itmInfoPopup(url,w,h,avg);
			}	
		</script>
</body>
</html>