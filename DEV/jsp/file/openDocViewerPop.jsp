<%@page import="java.sql.PreparedStatement"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root" />

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<title>${fileRealName}</title>
</head>
<link rel="stylesheet" type="text/css" href="cmm/sf/css/style.css"/>
<script type="text/javascript">

$(document).ready(function(){
	/*
	var data = "fileType=URL&convertType=1&filePath=http://gbpmsdev.mando.com/viewerFileDownload.do?seq=${seq}&refererUrl=http://gbpms.mando.com&downloadUrl=&fid=${seq}&force=true&sync=true&urlEncoding=UTF-8";
	var url= "${actionURL}" + "?" + data; 
	openFullPopup(url, "Mando Web Viewer");
	window.self.close();*/

	var isNew = "${isNew}";
	$('#fileDownLoading').removeClass('file_down_off');
	$('#fileDownLoading').addClass('file_down_on');
	var docViewerType = "<%=GlobalVal.DOC_VIEWER_TYPE%>";
	var data;	

	if(docViewerType == "Polaris"){
		 data = 	{
				type : "cloud",
			    url : "<%=GlobalVal.OLM_SERVER_URL%>/viewerFileDownload.do?seq=${seq}", 		   
			    name : "${fileRealName}",
			    fileOption : "${fileOption}",
			   // viewMode : true,
		}
	}else{
		 data = 	{
				
			    fileType: "URL",

			    convertType:  "0",
			    filePath: "<%=GlobalVal.OLM_SERVER_URL%>/viewerFileDownload.do?seq=${seq}", 		   
			    refererUrl: "<%=GlobalVal.OLM_SERVER_URL%>",
			    downloadUrl: "",
			    fid: "OLM_${seq}",
			    force: true,		    
			    sync : false,
			    urlEncoding: "UTF-8",
			    fileOption : "${fileOption}"

		}
	}

if (docViewerType == "Polaris") {
	polarisViewerProcess(isNew, data);
}else{
		if(isNew == "Y") {
			//var data = "fileType=URL&convertType=1&filePath=http://gbpmsdev.mando.com/viewerFileDownload.do?seq=${seq}&refererUrl=http://gbpms.mando.com&downloadUrl=&fid=${seq}&force=true&sync=true&urlEncoding=UTF-8";
			
			ajaxFileViewer("${actionURL}",data,"${seq}");
		}
		else {
			var checkUrl = "${actionURL}";
			
			var key = checkUrl.substring(checkUrl.indexOf('=')+1,checkUrl.indexOf('&'));
			var url = "<%=GlobalVal.DOC_VIEWER_URL%>/SynapDocViewServer/status/" + key; 
			
			if(ajaxCheckFile(url)) {
				$('#fileDownLoading').addClass('file_down_off');
				$('#fileDownLoading').removeClass('file_down_on');
				location.href = "${actionURL}";
			}
			else {
				ajaxFileViewer("<%=GlobalVal.DOC_VIEWER_URL%>/SynapDocViewServer/jobJson",data,"${seq}"); 			
			}                   
		}
	}
});

function fnCallback(url) {
	$('#fileDownLoading').addClass('file_down_off');
	$('#fileDownLoading').removeClass('file_down_on');
	$("#help_content").attr("style","width:100%;height:100%");
	
	location.href = url;
	//window.opener.urlReload();
}

async function polarisViewerProcess(isNew, data) {
	   if (isNew == "Y") {
	     // 새 파일일 경우, 파일 뷰어에 전달
	     await ajaxFileViewer_polaris("${actionURL}", data, "${seq}");
	   } else {
	     // 기존 파일일 경우, 파일 변환 처리
	     var checkUrl = "${actionURL}";
	     //alert("isNew==N, 현재 filePath: " + checkUrl);
	     
	     // 변환 아이디 추출
	     var id = checkUrl.substring(checkUrl.indexOf('/viewer/') + '/viewer/'.length, checkUrl.indexOf('?'));
	       //alert(id);
	  var url = "<%=GlobalVal.DOC_VIEWER_URL%>/file/convert/" + id;
	     //alert("변환 아이디: " + id);
	     
	     // 파일 변환 여부 확인
	     try {
	       const isConverted = await ajaxCheckFile_polaris("<%=GlobalVal.DOC_VIEWER_URL%>/file/convert/" + id);
	       
	       if (isConverted) {
	         $('#fileDownLoading').addClass('file_down_off');
	         //alert("변환 성공");
	         $('#fileDownLoading').removeClass('file_down_on');
	         location.href = "${actionURL}";
	       } else {
	         //alert("변환 실패");
	         // 변환 실패 시 파일 업로드 후 뷰어 실행
	         await ajaxFileViewer_polaris("<%=GlobalVal.DOC_VIEWER_URL%>/file/upload/webviewer", data, "${seq}");
	       }
	     } catch (error) {
	       console.error('파일 변환 처리 중 오류 발생:', error);
	       alert('파일 변환 처리 중 오류가 발생했습니다.');
	     }
	   }
}

async function ajaxFileViewer_polaris(url, aData, seq) {
 console.log(aData);
 //alert("변환 url" + url);

 try {
     const data = await $.ajax({
         url: url,
         type: 'post',
         data: aData,
     });

     if (data.success == null || data.success == undefined || data.success == false) {
         alert("File Transfer Error");
     } else {
         // 변환 체크를 시작합니다.
         const isConverted = await ajaxCheckFile_polaris("<%=GlobalVal.DOC_VIEWER_URL%>/file/convert/" + data.id);
         
         if (!isConverted) {
             alert(data.id + " File Transfer Error");
         } else {
             //alert("ajaxFileViewer_polaris 변환 성공");
             var scUrl = "setDocViewerFilePath.do";
             var scData = "id=" + data.id + "&fileOption=" + aData.fileOption + "&seq=" + seq + "&stamp=" + data.stamp;
             var scTarget = "help_content";
             ajaxPage(scUrl, scData, scTarget);
         }
     }
 } catch (error) {
     alert("AJAX 요청에 오류가 발생했습니다: " + error);
 }
}

async function ajaxCheckFile_polaris(url) {
 //alert("변환 체크 시작");
 try {
     const data = await $.ajax({
         url: url,
         type: 'get',
     });

     if (data.status == "F" || data.status == null || data.status == undefined) {
         //alert("변환 체크 실패");
         return false; // 실패 시 false
     } else if (data.status == "C" || data.status == "Q") {
         //alert("변환 중 / 대기 상태, 1초 뒤에 재시도합니다.");
         // 1초 뒤에 재시도합니다.
         await new Promise(resolve => setTimeout(resolve, 1000));
         return ajaxCheckFile_polaris(url);  // 재시도
     } else if (data.status == "S") {
         //alert("변환 체크 성공");
         return true;  // 성공 시 true
     }
 } catch (error) {
     alert("변환 체크에 실패했습니다: " + error);
     return false;
 }
}
</script>
<body>
<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}/loading_circle.gif"/>
</div>
<div id="help_content"></div>

</body>
</html>