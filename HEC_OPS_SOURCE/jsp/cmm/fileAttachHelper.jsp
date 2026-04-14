<script type="text/javascript">
var scripts = new Array;
var dms_scripts = new Array;
var beforeFileName = "";
var dms_beforeFileName = "";
var idx = 0;
var dms_idx = 0;
var extKind = "asp jsp php war cer cdx asa html htm js aspx exe dll";   

function make_array(status, display_script, item){this.status = status;this.display_script = display_script;this.item = item;}
function attach(type, obj) { 
	var val = obj.value;
	var ext=val.substring(val.lastIndexOf(".")+1).toLowerCase();
  	var isCheck = false;
  	var extKinds = extKind.split(' ');
  	for(var i=0; i<extKinds.length; i++){if(ext == extKinds[i]){ isCheck = true;}}
  	
  	if(isCheck){
		return;
  	}
  	 
	obj.style.display = 'none';	
	if(type == "1"){add_item(type, ++idx, val);} else {add_item(type, ++dms_idx, val);}	item_list(type);
}
function add_item2(type, idx){
	var file_script;
	var fileNum;
	if(type == "1"){
		if (beforeFileName == "filex" + idx) {fileNum = idx + 1;} else {fileNum = idx;}
		file_script = '<span id=file_item'+idx+' class="file_attach" ><input type=file name=filex'+fileNum+' id=filex'+fileNum+' onchange=attach("1",this) size=1></span>';
		$('#file_item_P').append(file_script);
		beforeFileName = "filex" + fileNum;
	} else {
		if (dms_beforeFileName == "dms_filex" + idx) {fileNum = idx + 1;} else {fileNum = idx;}
		file_script = '<span id=dms_file_item'+idx+' class="file_attach" ><input type="file" name="dms_filex'+fileNum+'" id="dms_filex'+fileNum+'" onchange=attach("2",this) size=1></span>';
		$('#dms_file_item_D').append(file_script);
		dms_beforeFileName = "dms_filex" + fileNum;
	}
}
function add_item(type, idx, val){
	var file_script;
	if(type == "1"){file_script='<span id=file_item'+idx+' class="file_attach" ><input type=file name=file'+idx+' id=file'+idx+' onchange=attach("1",this) size=1></span>';}else{file_script='<span id=dms_file_item'+idx+' class="file_attach" ><input type=file name=dms_file'+idx+' id=dms_file'+idx+' onchange=attach("2",this) size=1></span>';}
	for(var i = 0 ; i < scripts.length; i++){
		if(scripts[i].item.length > 0 && val.length > 0  && scripts[i].item == val  && scripts[i].status) {
			alert("기존에 첨부파일 목록에 추가된 파일입니다. 다른 파일을 추가하십시오. ");
			document.getElementById("file_item"+(idx-1)).innerHTML = '';
			add_item2(type, idx);
			return;
		}
	}
	for(var i = 0 ; i < dms_scripts.length; i++){
		if(dms_scripts[i].item.length > 0 && val.length > 0  && dms_scripts[i].item == val && dms_scripts[i].status) {
			alert("기존에 DMS 파일 목록에 추가된 파일입니다. 다른 파일을 추가하십시오. ");
			document.getElementById("dms_file_item"+(idx-1)).innerHTML = '';
			add_item2(type, idx);
			return;
		}
	}	
	if(type == "1"){
		var seq = scripts.length;
		var display_script = '<span id=display_item'+idx+'>'+val+
			'&nbsp;&nbsp;<img src="${root}${HTML_IMG_DIR}/btn_file_cancel.png" onclick=remove_item("1",'+seq+','+idx+')></span><br>';
		scripts[seq] = new make_array(true, display_script, val);
		$('#file_item_P').append(file_script);
	} else{
		var seq = dms_scripts.length;
		var display_script = '<span id=dms_display_item'+idx+'>'+val+
			'&nbsp;&nbsp;<img src="${root}${HTML_IMG_DIR}/btn_file_cancel.png" onclick=remove_item("2",'+seq+','+idx+')></span><br>';
		dms_scripts[seq] = new make_array(true, display_script, val);
		$('#dms_file_item_D').append(file_script);
	}
}
function item_list(type){
	var validate_cnt = 0;
	var display_scripts = '';
	var items = '';	
	if(type == "1"){	
		for(var i = 0 ; i < scripts.length; i++){
			if(scripts[i].status){
				validate_cnt++;
				display_scripts += '<b>'+
				validate_cnt+'</b>.'+scripts[i].display_script;
				items += scripts[i].item + "|";
			}
		}		
		if(validate_cnt == 0 ){display_scripts = '';}
		document.getElementById("display_items").innerHTML = display_scripts;
		document.getElementById("items").value = items;
	}else{
		for(var i = 0 ; i < dms_scripts.length; i++){
			if(dms_scripts[i].status){
				validate_cnt++;
				display_scripts += '<b>'+
				validate_cnt+'</b>.'+dms_scripts[i].display_script;
				items += dms_scripts[i].item + "|";
			}
		}		
		if(validate_cnt == 0 ){display_scripts = '';}
		document.getElementById("dms_display_items").innerHTML = display_scripts;
		document.getElementById("dms_items").value = items;
	}
}
function remove_item(type,seq,idx){
	if( type == "1"){scripts[seq].status = false;document.getElementById("file_item"+(idx-1)).innerHTML = '';}else{dms_scripts[seq].status = false;document.getElementById("dms_file_item"+(idx-1)).innerHTML = '';}
	item_list(type);
}
</script>