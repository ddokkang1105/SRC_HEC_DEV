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
  
  <script>
  
     
     var testData =  
    	 [
    	  {"headerColor":"#607D8B","x":110,"y":180,"id":"a900868","text":"PARENT","fill":"#E6E9EF","fontStyle":"1","stroke":"#b3b3b3","fontColor":"#000000"}
    	 ,{"parent":"a900868","headerColor":"#607D8B","id":"a900871","text":"33333","fill":"#FAFFFF","fontStyle":"1","stroke":"#14BAED","fontColor":"#333333"}
    	 ,{"parent":"a900868","headerColor":"#607D8B","id":"a900869","text":"11111","fill":"#FAFFFF","fontStyle":"1","stroke":"#14BAED","fontColor":"#333333"}
    	 ,{"parent":"a900868","headerColor":"#607D8B","id":"a900870","text":"22222","fill":"#FAFFFF","fontStyle":"1","stroke":"#14BAED","fontColor":"#333333"}
    	
    	 
    	 ];
  
     const data = [
         {
             id: "1",
             text: "Chairman & CEO",
         },
         {
             id: "2",
             text: "Manager",
             parent: "1",
         },
         {
             id: "3",
             text: "Technical Director",
             parent: "1",
         },
         {
             id: "4",
             text: "Manager",
             parent: "1",
         },
         {
             id: "5",
             text: "Technical Director",
             parent: "1",
         },
         {
             id: "2.1",
             text: "Marketer",
             parent: "2",
         },
         {
             id: "2.2",
             text: "Team Lead ",
             parent: "2",
         },
     ];
  
  </script>
</head>
 
<body>
    	<!-- <section id="controls" class="dhx_sample-controls">
			<button class="dhx_sample-btn dhx_sample-btn--flat" onclick="runEditor()">Edit</button>
		</section> -->
		
		<div class="dhx_sample-widget" id="diagram" height="100%"></div>
		
		<script>
		
			const diagram = new dhx.Diagram("diagram", {
				type: "mindmap",
				typeConfig: {
					direction: "right",
				},
			});
			
			const editor = new dhx.DiagramEditor("editor", {
				type: "mindmap",
			});

			const editorCont = document.querySelector("#editor");
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

			function runEditor() {
				expand();
				editor.import(diagram);
			}

			editor.events.on(" ", function () {
				collapse();
				diagram.data.parse(editor.serialize());
			});

			editor.events.on("ResetButton", function () {
				collapse();
			});
			
			diagram.events.on("itemClick", (id, event) => {
			    console.log(id,id.substr(0,3), id.substr(0,0), event);
			    if(id != "cxnPrc" && id.substr(0,3) != "CLS" && id.substr(0,1) != "u"){
			    	fnDetail(id);
			    }
			});
			
			diagram.events.on("lineClick", function(id, events) {
			    console.log("LINE CLICK : "+ id);
			});

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