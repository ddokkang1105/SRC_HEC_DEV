// Public Key
var pubkey1     = "ADCBiAKBgHgWQm5CVQBNaGlIgTgv06HhOXQqSuuBPY2EvPvPsEL120jnT5HCU7lMbP8qVvb2qpGmxN+3PUVUXG1yHKqEGkNc77/eOq4KReHFeezH2wPoLnRkivm0pE4MfWwL2N6la5G1lktZdbtsWMAT7GJeEpbbDkTqatbf4XQkG2Cixq/jAgMBAAEA";
var pubkey2     = "ADCBiAKBgHgWQm5CVQBNaGlIgTgv06HhOXQqSuuBPY2EvPvPsEL120jnT5HCU7lMbP8qVvb2qpGmxN+3PUVUXG1yHKqEGkNc77/eOq4KReHFeezH2wPoLnRkivm0pE4MfWwL2N6la5G1lktZdbtsWMAT7GJeEpbbDkTqatbf4XQkG2Cixq/jAgMBAAEA";

var encrypt_header      = "encrypt_";
var double_header       = "double_";

/* [HKEY_CURRENT_USER\Software\Penta Security Systems\ISSACWeb] */
var keyname1 = 'sessionkey';
var keyname2 = 'sessionkey';

/****************************
 *  IssacWeb Common Script 
 ****************************/

/**
 *  브라우저 비트 정보 확인 
 */
function checkBrowBit() {
		var ua = window.navigator.userAgent;
 
		if (ua.indexOf('x64') != -1) return "64";
		else return "32";
}

/**
 *  브라우저 판별 
 */
function isNetscape(){
	var bTrident = navigator.userAgent.toUpperCase().indexOf('TRIDENT');
	var bMsie = navigator.userAgent.toUpperCase().indexOf('MSIE');
	var bWindows = navigator.userAgent.toUpperCase().indexOf('WINDOWS');
	// alert("isTrident : " + bTrident);
	// alert("isMsie : " + bMsie);
	// alert("isWindows : " + bWindows);
	
	if( window.ActiveXObject || (bTrident != -1 && bWindows != -1) || (bMsie != -1 && bWindows != -1)) {
		return false;
	} else {
		return true;
	}
}



function issacweb_escape(msg) {
    var tmp_msg = String(msg);
    var encMsg = '';
    var ch;
	    
    for (var i = 0; i < tmp_msg.length; i++) {
        ch = tmp_msg.charAt(i);
        if (ch == ' ')
            encMsg += '%20';
        else if (ch == '%')
            encMsg += '%25';
        else if (ch == '&')
            encMsg += '%26';
        else if (ch == '+')
            encMsg += '%2B';
        else if (ch == '=')
            encMsg += '%3D';
        else if (ch == '?')
            encMsg += '%3F';
		else if (ch == '|')
            encMsg += '%7C';
        else
            encMsg += ch;
	}
    return encMsg;
}
				
/****************************
 *  form 데이터 전체 암호화 
 ****************************/
function encryptForm(form) {
	var first	= true;	
	var catMsg	= "";
	var curMsg	= "";
	
	for (var i=0; i< form.length; i++) {
		if (form.elements[i].type != "button" && 
			form.elements[i].type != "reset" && 
			form.elements[i].type != "submit") {
			if (form.elements[i].type == "checkbox" || form.elements[i].type == "radio") {
				if (form.elements[i].checked) {
					curMsg =  form.elements[i].value;
					form.elements[i].checked = false;
				} else {
					continue;
				}
			} else if (form.elements[i].type == "select-one") {
				var index = form.elements[i].selectedIndex;
				if (form.elements[i].options[index].value != "") {
						curMsg = form.elements[i].options[index].value;
				} else {
						curMsg = form.elements[i].options[index].text;
				}
				form.elements[i].selectedIndex = 0;
			} else {
				if (form.elements[i].name == "issacweb_data")
					continue;
				curMsg = form.elements[i].value;
				form.elements[i].value	= "";
			}
			if (first) {
				first = false;
			} else {
				catMsg	= catMsg + "&";
			}

			catMsg += issacweb_escape(form.elements[i].name) + "=" + issacweb_escape(curMsg);
		}
	}
	
	try {
		/* 마지막 flag -> nCipherID : SEED=1, ARIA=2, AES256=3 */
		if (isNetscape())
	    	//form.elements["issacweb_data"].value = document.IssacWebEnc.getSubApplet().issacweb_hybrid_encrypt_ex_s(catMsg, pubkey1, keyname1, 1);
			form.elements["issacweb_data"].value = document.IssacWebEnc.getSubApplet().issacweb_hybrid_encrypt_ex_s_utf8(catMsg, pubkey1, keyname1, 1);
		else
			form.elements["issacweb_data"].value = document.IssacWebEnc.issacweb_hybrid_encrypt_s_utf8(catMsg, pubkey1, keyname1); 
	} catch(e) {
		alert(e.message);
		return false;
	}
	
    //alert(form.elements["issacweb_data"].value);
    
	if (form.elements["issacweb_data"].value == "") {
		alert("issacweb_data is null");
 		return false;
	}

	form.submit();
	return false;
}

/****************************
 *  @ IssacWeb 부분 암호화
 *  - 암호화할 데이터의 이름 앞에 접두사 "encrypt_"를 붙인다. 
 ****************************/
function encryptSeleted(form){
	for (var i=0; i<form.length; i++) {
		if (form.elements[i].type != "button" &&
			form.elements[i].type != "reset"  &&
			form.elements[i].type != "submit") {
			if (form.elements[i].type == "checkbox" || 
				form.elements[i].type == "radio") {
				if(form.elements[i].checked) {
					if(form.elements[i].name.indexOf(encrypt_header) != -1)	
						form.elements[i].value = 
						document.IssacWebEnc.issacweb_encrypt_s(form.elements[i].value, keyname1);
				} else {
					continue;
				}
			} else if(form.elements[i].type == "select-one") {
				var index = form.elements[i].selectedIndex;
				if (form.elements[i].options[index].value != "text1") {
					if(form.elements[i].name.indexOf(encrypt_header) != -1)	
						form.elements[i].value  = 
						document.IssacWebEnc.issacweb_encrypt_s(form.elements[i].value, keyname1);
				} else {
					if(form.elements[i].name.indexOf(encrypt_header) != -1)	
						form.elements[i].value  = 
						document.IssacWebEnc.issacweb_encrypt_s(form.elements[i].value, keyname1);
				}
			} else {
				// Text & password field
				if(form.elements[i].name == "issacweb_data") {
					form.elements[i].value = 
					document.IssacWebEnc.issacweb_hybrid_encrypt_s("", pubkey1, keyname1);
					continue;
				}
				if(form.elements[i].name.indexOf(encrypt_header) != -1)	{
					//alert(keyname);
					form.elements[i].value	=
					document.IssacWebEnc.issacweb_encrypt_s(form.elements[i].value, keyname1);
					form.elements["parameter"].value=form.elements[i].value;
				}
			}
		}
	}
	
	form.submit();
}

/****************************
 *  @ IssacWeb 이중 암호화.
 *  - form 데이터를 서로 다른 공개키로 암호화 하는 함수
 *  - 복호화를 하는 서버가 2개일 때 사용. 
 ****************************/
function encryptDouble(form) {
	var first = true;	
	var catMsg = "";
	var curMsg;
	form.Server2ForSessionKey.value	= document.IssacWebEnc.issacweb_hybrid_encrypt_s("", pubkey2, keyname3);
	for(var i=0; i< form.length; i++){
		if(form.elements[i].type != "button"
			&& form.elements[i].type != "reset" 
			&& form.elements[i].type != "submit")
		{
			if(form.elements[i].type == "checkbox" 
				|| form.elements[i].type == "radio"){
				if(form.elements[i].checked){
						curMsg =  form.elements[i].value;
						form.elements[i].checked = false;
				}else{
						continue;
				}
			}else if(form.elements[i].type == "select-one"){
				var index = form.elements[i].selectedIndex;
				if(form.elements[i].options[index].value != ""){
						curMsg = form.elements[i].options[index].value;
				}else{
						curMsg = form.elements[i].options[index].text;
				}
				form.elements[i].selectedIndex = 0;
			}else{
					if(form.elements[i].name	== "issacweb_data")
						continue;
					if(form.elements[i].name.indexOf(double_header) != -1)	
						form.elements[i].value	= document.IssacWebEnc.issacweb_encrypt_s(form.elements[i].value, keyname3);
					curMsg =  form.elements[i].value;
					form.elements[i].value	= "";
			}
			if(first){
				first = false;
			}else{
				catMsg	= catMsg + "&";
			}
			catMsg	+= issacweb_escape(form.elements[i].name) + "=" + issacweb_escape(curMsg);	
		
		}
	}
	//생성한 키네임을 전송시켜준다.
    catMsg += "&keyname="+keyname2;
    
    form.elements["issacweb_data"].value = document.IssacWebEnc.issacweb_hybrid_encrypt_s(catMsg, pubkey1, keyname1);

	if(form.elements["issacweb_data"].value	== "") return;
    form.submit();
}

/****************************
 *  @ IssacWeb 전자서명 
 ****************************/
function encryptSig(form) {
	var first = true;	
	var catMsg = "";
	var curMsg = "";
	
	for (var i=0; i< form.length; i++) {
		if (form.elements[i].type != "button" && 
			form.elements[i].type != "reset" && 
			form.elements[i].type != "submit") {
			if (form.elements[i].type == "checkbox" || form.elements[i].type == "radio") {
				if (form.elements[i].checked) {
					curMsg =  form.elements[i].value;
					form.elements[i].checked = false;
				} else {
					continue;
				}
			} else if (form.elements[i].type == "select-one") {
				var index = form.elements[i].selectedIndex;
				if (form.elements[i].options[index].value != "") {
						curMsg = form.elements[i].options[index].value;
				} else {
						curMsg = form.elements[i].options[index].text;
				}
				form.elements[i].selectedIndex = 0;
			} else {
				if (form.elements[i].name == "issacweb_data")
					continue;
				curMsg = form.elements[i].value;
				form.elements[i].value	= "";
			}
			if (first) {
				first = false;
			} else {
				catMsg	= catMsg + "&";
			}

			catMsg += issacweb_escape(form.elements[i].name) + "=" + issacweb_escape(curMsg);	
		}
	}
    form.elements["issacweb_data"].value = document.IssacWebEnc.issacweb_hybrid_encrypt_s_utf8(catMsg, pubkey1, keyname1);
    //alert(form.elements["issacweb_data"].value);
    
	if (form.elements["issacweb_data"].value == "") {
		alert("issacweb_data is null");
 		return;
	}

	form.submit();
}

/****************************
 *  @ IssacWeb PKI 로그인 
 ****************************/
function isignPki(form, base64_challenge) {
	if (isNetscape()) {
		return pkiLogin_Ap(form, base64_challenge);		
	} else {
		return pkiLogin_Ax(form, base64_challenge);
	}
}

function pkiLogin_Ax(form, base64_challenge) {
	var challenge = 'MBIEEPbCt5t28/bPqBToNhHKXOA=';

	if ((base64_challenge != "") && (base64_challenge != undefined))
		challenge = base64_challenge;

	//alert(challenge);
	
	try {
		// 인증서 저장소 타입 설정 및 화면 출력.
		document.Client.SetStorageType(0x005, 7);
	    //document.Client.InstallFile("","http://127.0.0.1:8080/ax/img/issac.bmp");	
		document.Client.SelectUserCertEx1("인증서 선택", 0, 20, "");
	
		if (document.Client.GetLastErr() == 0) {
			if (form.vidrnd != undefined) {
				// 로드된 인증서의 비공개키로 vid검증용 random Number를 만든다.
				form.vidrnd.value = document.Client.issacwebpro_get_randomNumFromPrivateKey();
			}
			// challenge값으로 사용자 검증을 위한 response 값을 생성
			form.response.value	= document.Client.issacwebpro_make_response(challenge);
			// 모듈 내부에 저장된 인증서의 keypath 와 keypin을 초기화 하는 기능
			document.Client.issacwebpro_set_is_select_user_cert(0, "");
			// parameter로 넘길 challenge 값 저장	
			form.challenge.value = challenge;
			
			if (document.Client.GetLastErr() != 0) {
				alert("Error:" + document.Client.GetLastErr());
			} else {
				return true;
			}
		} else {
			return false;
		}
	} catch(e) {
		alert(e.message);
	}
}

function pkiLogin_Ap(form, base64_challenge) {
	var challenge = 'MBIEEPbCt5t28/bPqBToNhHKXOA=';

	if ((base64_challenge != "") && (base64_challenge != undefined))
		challenge = base64_challenge;

	//alert(challenge);
	
	try {
		// 인증서 선택창을 띄우고 인증서 경로(keypath)를 가져온다.
		var keypath = document.IssacWebCMS.getSubApplet().issacwebpro_SelectUserCert("인증서 선택창", "", 3, 10, 0);
	
		// keypath 가져오기 (인증서 로드) 성공 
		if (keypath != null) {
			if (form.vidrnd != undefined) {
				// 로드된 인증서의 비공개키로 vid검증용 random Number를 만든다.	
				form.vidrnd.value    = document.IssacWebCMS.getSubApplet().issacwebpro_GetRandomNumFromPrivateKey();
			}
			// keypath와 challenge값으로 response 값을 만든다. 
			form.response.value	= document.IssacWebCMS.getSubApplet().issacwebpro_MakeResponse(challenge, keypath);
			// parameter로 넘길 challenge 값 저장
			form.challenge.value = challenge;
			
			if (document.IssacWebCMS.getSubApplet().issacwebpro_GetLastError() != 0) {
				alert("Error:" + document.IssacWebCMS.getSubApplet().issacwebpro_GetLastError());
			} else {
				return true;
			}
		} else {
			return false;
		}
	} catch (e) {
		alert(e.message);
	}
}


/**
 * applet 내부 IP변경
 */
var url = "http://sso.pentasecurity.com/isignplus/client_lib/jre1.7.0_45over";		// modify
var activeXurl = "http://sso.pentasecurity.com";		// modify
function issacLoad(method) {
	//alert("method : " + method);
	
	if (isNetscape() == true) {
		if (method == 1) {	// Std
			document.writeln("<applet id=\"IssacWebPro\" name=\"IssacWebEnc\" code=\"org.jdesktop.applet.util.JNLPAppletLauncher\" width=0 height=0 archive=\"" + url + "/applet-launcher.jar," + url + "/IssacWebPro.jar \"> ");
			document.writeln("<param name=\"codebase_lookup\" value=\"false\"> ");
			document.writeln("<param name=\"subapplet.classname\" value=\"pentasecurity.issacweb.pro.client.IssacWebSE\"> ");
			document.writeln("<param name=\"noddraw.check\" value=\"true\"> ");
			document.writeln("<param name=\"progressbar\" value=\"true\"> ");
			document.writeln("<param name=\"jnlpNumExtensions\" value=\"1\"> ");
			document.writeln("<param name=\"jnlpExtension1\" value=" + url + "/JniIssacWebJNLP.jnlp \"> </applet> ");
		} else if (method == 2) {	// pro
			document.writeln("<applet id=\"IssacWebPro\" name=\"IssacWebCMS\" code=\"org.jdesktop.applet.util.JNLPAppletLauncher\" width=0 height=0 archive=\"" + url + "/applet-launcher.jar," + url + "/IssacWebPro.jar \"> ");
			document.writeln("<param name=\"codebase_lookup\" value=\"false\">");
			document.writeln("<param name=\"subapplet.classname\" value=\"pentasecurity.issacweb.pro.client.IssacWebCMS\">");
			document.writeln("<param name=\"noddraw.check\" value=\"true\">");
			document.writeln("<param name=\"progressbar\" value=\"true\">");
			document.writeln("<param name=\"jnlpNumExtensions\" value=\"1\">");
			document.writeln("<param name=\"jnlpExtension1\" value=" + url + "/JniIssacWebJNLP.jnlp \"> </applet>");
		} else {	// all
			document.writeln("<applet id=\"IssacWebPro\" name=\"IssacWebEnc\" code=\"org.jdesktop.applet.util.JNLPAppletLauncher\" width=0 height=0 archive=\"" + url + "/applet-launcher.jar," + url + "/IssacWebPro.jar \"> ");
			document.writeln("<param name=\"codebase_lookup\" value=\"false\"> ");
			document.writeln("<param name=\"subapplet.classname\" value=\"pentasecurity.issacweb.pro.client.IssacWebSE\"> ");
			document.writeln("<param name=\"noddraw.check\" value=\"true\"> ");
			document.writeln("<param name=\"progressbar\" value=\"true\"> ");
			document.writeln("<param name=\"jnlpNumExtensions\" value=\"1\"> ");
			document.writeln("<param name=\"jnlpExtension1\" value=" + url + "/JniIssacWebJNLP.jnlp \"> </applet> ");
		
			document.writeln("<applet id=\"IssacWebPro\" name=\"IssacWebCMS\" code=\"org.jdesktop.applet.util.JNLPAppletLauncher\" width=0 height=0 archive=\"" + url + "/applet-launcher.jar," + url + "/IssacWebPro.jar \"> ");
			document.writeln("<param name=\"codebase_lookup\" value=\"false\">");
			document.writeln("<param name=\"subapplet.classname\" value=\"pentasecurity.issacweb.pro.client.IssacWebCMS\">");
			document.writeln("<param name=\"noddraw.check\" value=\"true\">");
			document.writeln("<param name=\"progressbar\" value=\"true\">");
			document.writeln("<param name=\"jnlpNumExtensions\" value=\"1\">");
			document.writeln("<param name=\"jnlpExtension1\" value=" + url + "/JniIssacWebJNLP.jnlp \"> </applet>");		
		}
	} else {
		// ActiveX 사용시 : Start
		/*
		if (method == 1) {
			document.writeln("<OBJECT ID=\"IssacWebEnc\" CLASSID=\"CLSID:F04D271A-204F-4FA5-A5C2-17636E0126AD\" CODEBASE=\"" + activeXurl + "/IssacWebProCMS_4_5_0_14.cab#Version=4,5,0,14\" width=0 height=0></OBJECT>");
			document.writeln("<OBJECT ID=\"IssacWebDec\" CLASSID=\"CLSID:F04D271A-204F-4FA5-A5C2-17636E0126AD\" width=0 height=0></OBJECT>");			
		} else if (method == 2) {
			document.writeln("<OBJECT ID=\"Client\" CLASSID=\"CLSID:834DEE30-36C2-4C7B-A2D3-16005621D9FF\" CODEBASE=\"" + activeXurl + "/IssacWebProCMS_4_5_0_14.cab#Version=4,5,0,14\" HEIGHT=0 WIDTH=0></OBJECT>");
		} else {
			document.writeln("<OBJECT ID=\"Client\" CLASSID=\"CLSID:834DEE30-36C2-4C7B-A2D3-16005621D9FF\" CODEBASE=\"" + activeXurl + "/IssacWebProCMS_4_5_0_14.cab#Version=4,5,0,14\" HEIGHT=0 WIDTH=0></OBJECT>");
			document.writeln("<OBJECT ID=\"IssacWebEnc\" CLASSID=\"CLSID:F04D271A-204F-4FA5-A5C2-17636E0126AD\" CODEBASE=\"" + activeXurl + "/IssacWebProCMS_4_5_0_14.cab#Version=4,5,0,14\" width=0 height=0></OBJECT>");
			document.writeln("<OBJECT ID=\"IssacWebDec\" CLASSID=\"CLSID:F04D271A-204F-4FA5-A5C2-17636E0126AD\" width=0 height=0></OBJECT>");			
		}
		*/
		// ActiveX 사용시 : End
		
		// Applet 사용시  : Start
		
		if (method == 1) {	// Std
			document.writeln("<applet id=\"IssacWebPro\" name=\"IssacWebEnc\" code=\"org.jdesktop.applet.util.JNLPAppletLauncher\" width=0 height=0 archive=\"" + url + "/applet-launcher.jar," + url + "/IssacWebPro.jar \"> ");
			document.writeln("<param name=\"codebase_lookup\" value=\"false\"> ");
			document.writeln("<param name=\"subapplet.classname\" value=\"pentasecurity.issacweb.pro.client.IssacWebSE\"> ");
			document.writeln("<param name=\"noddraw.check\" value=\"true\"> ");
			document.writeln("<param name=\"progressbar\" value=\"true\"> ");
			document.writeln("<param name=\"jnlpNumExtensions\" value=\"1\"> ");
			document.writeln("<param name=\"jnlpExtension1\" value=" + url + "/JniIssacWebJNLP.jnlp \"> </applet> ");
		} else if (method == 2) {	// pro
			document.writeln("<applet id=\"IssacWebPro\" name=\"IssacWebCMS\" code=\"org.jdesktop.applet.util.JNLPAppletLauncher\" width=0 height=0 archive=\"" + url + "/applet-launcher.jar," + url + "/IssacWebPro.jar \"> ");
			document.writeln("<param name=\"codebase_lookup\" value=\"false\">");
			document.writeln("<param name=\"subapplet.classname\" value=\"pentasecurity.issacweb.pro.client.IssacWebCMS\">");
			document.writeln("<param name=\"noddraw.check\" value=\"true\">");
			document.writeln("<param name=\"progressbar\" value=\"true\">");
			document.writeln("<param name=\"jnlpNumExtensions\" value=\"1\">");
			document.writeln("<param name=\"jnlpExtension1\" value=" + url + "/JniIssacWebJNLP.jnlp \"> </applet>");
		} else {	// all
			document.writeln("<applet id=\"IssacWebPro\" name=\"IssacWebEnc\" code=\"org.jdesktop.applet.util.JNLPAppletLauncher\" width=0 height=0 archive=\"" + url + "/applet-launcher.jar," + url + "/IssacWebPro.jar \"> ");
			document.writeln("<param name=\"codebase_lookup\" value=\"false\"> ");
			document.writeln("<param name=\"subapplet.classname\" value=\"pentasecurity.issacweb.pro.client.IssacWebSE\"> ");
			document.writeln("<param name=\"noddraw.check\" value=\"true\"> ");
			document.writeln("<param name=\"progressbar\" value=\"true\"> ");
			document.writeln("<param name=\"jnlpNumExtensions\" value=\"1\"> ");
			document.writeln("<param name=\"jnlpExtension1\" value=" + url + "/JniIssacWebJNLP.jnlp \"> </applet> ");
		
			document.writeln("<applet id=\"IssacWebPro\" name=\"IssacWebCMS\" code=\"org.jdesktop.applet.util.JNLPAppletLauncher\" width=0 height=0 archive=\"" + url + "/applet-launcher.jar," + url + "/IssacWebPro.jar \"> ");
			document.writeln("<param name=\"codebase_lookup\" value=\"false\">");
			document.writeln("<param name=\"subapplet.classname\" value=\"pentasecurity.issacweb.pro.client.IssacWebCMS\">");
			document.writeln("<param name=\"noddraw.check\" value=\"true\">");
			document.writeln("<param name=\"progressbar\" value=\"true\">");
			document.writeln("<param name=\"jnlpNumExtensions\" value=\"1\">");
			document.writeln("<param name=\"jnlpExtension1\" value=" + url + "/JniIssacWebJNLP.jnlp \"> </applet>");		
		}
		// Applet 사용시 : End
		
	}
}

