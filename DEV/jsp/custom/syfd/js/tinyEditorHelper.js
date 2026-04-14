﻿﻿var isEditor = false;
var tinyEditorType;
var currPage = document.location.href;
var arrPage = currPage.split('/');
var imageUrlPage = "http://"+arrPage[2]+'/upload/';
try{if( typeof(chkReadOnly) == 'undefined'){if(typeof(authLev) != 'undefined' && authLev == "1") isEditor = true;} else {if( !chkReadOnly) isEditor = true;}}catch(e){}
if (typeof(tinyMCE) != "undefined"){
		try{
			
			tinyMCE.EditorManager.editors.forEach(function(editor) {
			    var old_global_settings = tinyMCE.settings;
			    tinyMCE.settings = editor.settings;
			    tinyMCE.EditorManager.execCommand('mceRemoveEditor', false, editor.id);
			    tinyMCE.EditorManager.execCommand('mceAddEditor', false, editor.id);		    
		
			    tinyMCE.settings = old_global_settings;
			});
			
		}catch(e){/*alert("tinyMCE remove error=>>> "+e);*/}
		
		var div = document.getElementById("carcontent");
		if(div!=null && div != "undefined"){
			var elements = $(div).find('input:text');
			if(elements!=null && elements.size() > 0){var id = elements[0].id;var txtBox=document.getElementById(id);setTimeout(function() {txtBox.focus();}, 0); }
			else{
				var elements = $(div).find('input:hidden');
				if(elements!=null && elements.size() > 0){var id = elements[0].id;var txtBox=document.getElementById(id);setTimeout(function() {txtBox.focus();}, 0); }
			}
		}       
	if(isEditor){	
		if(tinyEditorType == "MAX"){
			tinyMCE.init({ 
				selector: '.tinymceText',  
				plugins: [
				    'advlist autolink lists link image charmap print preview anchor',
				    'searchreplace visualblocks code fullscreen',
				    'insertdatetime table contextmenu code textcolor ' ,
				    'lineheight'
					],
				toolbar: 'fullscreen preview | undo redo  | bold italic underline strikethrough forecolor backcolor removeformat | fontsizeselect fontselect formatselect | alignleft aligncenter alignright alignjustify lineheightselect | bullist numlist outdent indent link image',
				statusbar: false,
				fontsize_formats: '8pt 9pt 10pt 12pt 14pt 18pt 24pt 36pt',
				font_formats: 'Malgun Gothic=Malgun Gothic;Noto Sans KR=Noto Sans KR;Arial=Arial;Microsoft YaHei=Microsoft YaHei;MS PGothic=MS PGothic;굴림=굴림;굴림체=굴림체;궁서=궁서;궁서체=궁서체;돋움=돋움;돋움체=돋움체;바탕=바탕;바탕체=바탕체;Verdana=Verdana;Tahoma=Tahoma',
				relative_urls: false,
				paste_data_images: true,
				cleanup_on_startup : true,
				lineheight_formats: '10pt 12pt 14pt 18pt 24pt 36pt',	
				forced_root_block : false,	
	 			force_br_newlines : true,	
				force_p_newlines : false,	
				image_title: true,
				automatic_uploads: true,
				file_picker_types: 'image',
				file_picker_callback: function (cb, value, meta) {
				    var input = document.createElement('input');
				    input.setAttribute('type', 'file');
				    input.setAttribute('accept', 'image/png');
					input.onchange = function () {
				      var file = this.files[0];
				
				      var reader = new FileReader();
				      reader.onload = function () {
				      
				        var id = 'blobid' + (new Date()).getTime();
				        var blobCache =  tinymce.activeEditor.editorUpload.blobCache;
				        var base64 = reader.result.split(',')[1];
				        var blobInfo = blobCache.create(id, file, base64);
				        blobCache.add(blobInfo);
				
				        /* call the callback and populate the Title field with the file name */
				        // cb(blobInfo.blobUri(), { title: file.name }); // title 제거 (저장시 오류 때문)
				        cb(blobInfo.blobUri());
				      };
				      reader.readAsDataURL(file);
				    };
				
				    input.click();
				  },
				  content_style: 'body { font-family:\'Malgun Gothic\',\'Arial\',\'SimHei\',\'MS PGothic\'; font-size:12px }',
							
			    setup : function(tinyMCE) {
			    	 
					  tinyMCE.ui.registry.addButton('imagepop', {
						 // title : 'imagepop', 
						 // image : 'cmm/js/tinymce_v5/themes/img/bt_studying.png',
						 // onclick : function() {cmdImgUploadPop();}
						 icon : 'image',
						 tooltip : 'upload image',
						 onAction: function (_) {cmdImgUploadPop();}
					 });			    
					 tinyMCE.on('paste', function(e) {pasteHandler(e);});
					 tinyMCE.on('click', function(e) {clickHyperLink(e);});	
					 tinyMCE.on('init', function() {
						  this.getDoc().body.style.fontSize = '9pt';		
						  this.getDoc().body.style.fontFamily = sessionDefFont;		
					 });
			                
			    }				    
			});	
		}else{				
			tinyMCE.init({ 
				selector: '.tinymceText',  
				plugins: [
				    'advlist autolink lists link image charmap print preview anchor',
				    'searchreplace visualblocks code fullscreen',
				    'insertdatetime table contextmenu code textcolor ' ,
				    'lineheight'
					],
				toolbar: 'insertfile fullscreen preview | undo redo  | bold italic underline strikethrough forecolor backcolor removeformat | fontsizeselect fontselect formatselect | alignleft aligncenter alignright alignjustify lineheightselect | bullist numlist outdent indent link image | table charmap code searchreplace',
				statusbar: false,
				fontsize_formats: '8pt 9pt 10pt 12pt 14pt 18pt 24pt 36pt',
				font_formats: 'Malgun Gothic=Malgun Gothic;Noto Sans KR=Noto Sans KR;Arial=Arial;Microsoft YaHei=Microsoft YaHei;MS PGothic=MS PGothic;굴림=굴림;굴림체=굴림체;궁서=궁서;궁서체=궁서체;돋움=돋움;돋움체=돋움체;바탕=바탕;바탕체=바탕체;Verdana=Verdana;Tahoma=Tahoma',
				relative_urls: false,
				paste_data_images: true,
				cleanup_on_startup : true,
				lineheight_formats: '10pt 12pt 14pt 18pt 24pt 36pt',	
				forced_root_block : false,	
	 			force_br_newlines : true,	
				force_p_newlines : false,					
				menubar : false,
				image_title: true,
				automatic_uploads: true,
				file_picker_types: 'image',
				file_picker_callback: function (cb, value, meta) {
				    var input = document.createElement('input');
				    input.setAttribute('type', 'file');
				    input.setAttribute('accept', 'image/png');
					input.onchange = function () {
				      var file = this.files[0];
				
				      var reader = new FileReader();
				      reader.onload = function () {
				      
				        var id = 'blobid' + (new Date()).getTime();
				        var blobCache =  tinymce.activeEditor.editorUpload.blobCache;
				        var base64 = reader.result.split(',')[1];
				        var blobInfo = blobCache.create(id, file, base64);
				        blobCache.add(blobInfo);
				
				        /* call the callback and populate the Title field with the file name */
				        // cb(blobInfo.blobUri(), { title: file.name }); // title 제거 (저장시 오류 때문)
				        cb(blobInfo.blobUri());
				      };
				      reader.readAsDataURL(file);
				    };
				
				    input.click();
				  },
				  content_style: 'body { font-family:\'Malgun Gothic\',\'Arial\',\'SimHei\',\'MS PGothic\'; font-size:12px }',
							
			    setup : function(tinyMCE) {
			    	 
					  tinyMCE.ui.registry.addButton('imagepop', {
						 // title : 'imagepop', 
						 // image : 'cmm/js/tinymce_v5/themes/img/bt_studying.png',
						 // onclick : function() {cmdImgUploadPop();}
						 icon : 'image',
						 tooltip : 'upload image',
						 onAction: function (_) {cmdImgUploadPop();}
					 });			    
					 tinyMCE.on('paste', function(e) {pasteHandler(e);});
					 tinyMCE.on('click', function(e) {clickHyperLink(e);});	
					 tinyMCE.on('init', function() {
						  this.getDoc().body.style.fontSize = '9pt';		
						  this.getDoc().body.style.fontFamily = sessionDefFont;		
					 });
			                
			    }				    
			});	
		}
	}else{		
		tinyMCE.init({ 
			selector:'.tinymceText', 
			text: false,
			plugins: [
				    'advlist autolink lists link image charmap print preview anchor',
				    'visualblocks code fullscreen',
				    'insertdatetime table contextmenu textcolor ' ,
				    'noneditable'				   
				  ],
			toolbar: 'fullscreen | preview',
			menubar: false,
			statusbar: false,
			relative_urls:false,
			    
		    setup : function(tinyMCE) {						 
				 tinyMCE.on('init', function() {	
					    tinyMCE.on('click', function(e) {clickHyperLink(e);});	
					 	this.getDoc().body.style.fontSize = '9pt';
					 });
		    } 
		});	
		
	}
	//HyperLink click event
	function clickHyperLink(event){
		var targetNode = event.target;
		if(targetNode.nodeName.toLowerCase() === "a"){
			var aEle = document.createElement('a');aEle.href = targetNode.href;aEle.target = '_blank';	// should open a new window
			window.open(targetNode.href);
		}	
	}
	//이미지 버튼 클릭시 팝업 실제 파일업로드를 구성하여 링크할 경로를 작성한다( 아이콘클릭시 이 함수가 호출됨)
	 function cmdImgUploadPop(){
		 var win=window.open( "uploadImgFileScrn.do",
	        "editor_win","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=480,height=180,left=50,top=50"
		 );	  
	  	win.window.focus();  
	 }
	// 파일업로드 완료후 opener.editorImgUploadComplete함수호출 되는 방식 
	function editorImgUploadComplete(fileStr, dir){		
	   if( fileStr.length > 0 ){
		   fileStr = fileStr.substring(0, fileStr.length-1);	    
		   fileArray = fileStr.split("^");
		   //3개가 한묶음		  
		   var strImg = "";
		   for( var i=0; i<fileArray.length; i++){strImg += "<br><img src='"+imageUrlPage + fileArray[i] + "' border=0><br><br>";}		     
		   var contents = tinyMCE.activeEditor.getDoc().body.innerHTML; 
		   tinyMCE.activeEditor.setContent( contents + strImg );
	   }
	}
	
	function pasteHandler(e) {
	   var cbData;
	   if (e.clipboardData) {
	      cbData = e.clipboardData;
	   } else if (window.clipboardData) {
	      cbData = window.clipboardData;
	   }

	   if (e.msConvertURL) {
	     var fileList = cbData.files;
	      if (fileList.length > 0) {
	          for (var i = 0; i < fileList.length; i++) {
	              var blob = fileList[i];
	              readPastedBlob(blob);
	         }
	     }
	   }
	   if (cbData && cbData.items) {
	     if ((text = cbData.getData("text/plain"))) {
	         // Text pasting is already handled
	         return;
	     }
	     for (var i = 0; i < cbData.items.length; i++) {
	         if (cbData.items[i].type.indexOf('image') !== -1) {
	             var blob = cbData.items[i].getAsFile();
	             readPastedBlob(blob);
	         }
	     }
	   }
	}

	function readPastedBlob(blob) {
	    if (blob) {
	        reader = new FileReader();
	        reader.onload = function(evt) {
	            pasteImage(evt.target.result);
	        };
	        reader.readAsDataURL(blob);
	    }
	}
}