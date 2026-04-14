<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%String type = request.getParameter("type") == null ? "" : request.getParameter("type");%> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css"/>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<style type="text/css">html,body {overflow-y:hidden;width:100%;height:100%}</style>
<script type="text/javascript">
function test(loginID, object, linkType, linkID, languageID, iType, aType, option,keyId) {
	$("#olmLoginid").val(loginID);
	$("#object").val(object);
	$("#linkType").val(linkType);
	$("#linkID").val(linkID);
	$("#languageID").val(languageID);
	$("#option").val(option);
	$("#iType").val(iType);
	$("#aType").val(aType);
	$("#keyId").val(keyId);
	$("#linkTest").submit();
}
</script>
</head><body>  
<form id="linkTest" name="linkTest" method="post" action="olmLink.do">
<input type="hidden" id="olmLoginid" name="olmLoginid" value="" />
<input type="hidden" id="object" name="object" value=""/>
<input type="hidden" id="linkType" name="linkType" value=""/>
<input type="hidden" id="linkID"  name="linkID"value=""/>
<input type="hidden" id="languageID" name="languageID" value=""/>
<input type="hidden" id="option" name="option" value=""/>
<input type="hidden" id="iType" name="iType" value=""/>
<input type="hidden" id="aType" name="aType" value=""/>
<input type="hidden" id="keyId" name="keyId" value=""/>
</form>
<div style="padding-left:100px;padding-top:100px; height:800px; overflow:auto;">
	
	<!-- SFOLM 표준 Item Link -->
	
	<a href="olmLink.do?olmLoginid=guest&object=itm&linkType=code&languageID=1042&iType=OJ00001&linkID=4.2.3.8&focusedObjID=4.2.3.8.8" > 101. OLM LINK [ID] </a><br>
	<span onClick="javascript:test('sales','itm','id','101489','1042','','','AR000004');"> 101-1. OLM LINK POST [ID] </span><br>
    <a href="olmLink.do?olmLoginid=a&object=itm&linkType=code&linkID=ZME21N&iType=OJ00004&languageID=1042" > 102. OLM LINK [CODE]</a><br>
	<span onClick="javascript:test('a','itm','code','ZME21N','1042','OJ00004','','');"> 102-1. OLM LINK POST [CODE] </span><br>
	
    <a href="olmLink.do?olmLoginid=a&object=itm&linkType=atr&linkID=ME21N&iType=OJ00004&aType=AT00014&languageID=1042" >103. OLM LINK [ATR]</a><br>
	<span onClick="javascript:test('a','itm','atr','ME21N','1042','OJ00004','AT00014','');"> 103-1. OLM LINK POST [ATR] </span><br>
    <a href="olmLink.do?olmLoginid=sys&object=CSR&linkType=id&linkID=12&languageID=1042" > 104. CSR LINK [ID] </a><br>	<!--  Diagram direct  -->
	<span onClick="javascript:test('sys','CSR','id','12','1042','','','');"> 104-1. CSR LINK POST [ID] </span><br><br>
    
	<a href="olmLink.do?olmLoginid=guest&object=itm&linkType=id&linkID=100659&languageID=1042">106. Item popup</a><br>
	<span onClick="javascript:test('guest','itm','id','104894','1042','','','');"> 106. Item popup POST </span><br>
	
 	<a href="olmLink.do?olmLoginid=guest&object=VER&linkType=id&keyId=104894&linkID=698&languageID=1042">107. View Version Item</a><br>
 	
 	<a href="http://localhost/olmLink.do?olmLoginid=guest&object=TERM&linkType=&linkID=&iType=&languageID=1042&scrnType=&searchValue=업무" >  Term Pop up </a><br>
	<a href="http://localhost/olmLink.do?olmLoginid=guest&object=FSEARCH&linkType=&linkID=&iType=&languageID=1042&scrnType=&searchValue=업무" >  FSEARCH Pop up </a><br>


	<!-- SFOLM 표준 Non Item Link -->
 	<a href="http://localhost/olmLinkArc.do?loginID=guest&languageID=1042&linkID=4.2.3.8&linkType=code&itemTypeCode=OJ00001" > 111. olmLinkArc [CODE]</a><br><br>
 	<span onClick="javascript:test('guest','CS','id','698','1042','','','','104894');"> 108.View ChangeSet Detail Pop POST </span><br>
 	
 	<a href="olmChangeSetLink.do?olmLoginid=guest&object=CS&linkType=id&keyID=736790&iType=&linkID=690&languageID=1042">109.CS Approval Item Pop</a><br>	
	<span onClick="javascript:test('guest','CS','id','690','1042','','','','736790');"> 109.CS Approval Item Pop POST </span><br>
 	<a href="olmAprvDueLink.do?empNo=6&language=KR">110. Approval Due List</a><br>

	<span onClick="javascript:test('guest','VER','id','12','698','','','','104894');"> 107. View Version Item POST</span><br>
 	<a href="olmLink.do?olmLoginid=guest&object=CS&linkType=id&keyId=104894&iType=&linkID=698&languageID=1042">108.View ChangeSet Detail Pop</a><br>	
	<a href="http://localhost/olmLink.do?olmLoginid=guest&object=ProcInstItm&linkType=id&linkID=ITSM-001&procType=PIM&languageID=1042&instanceNo=P000000001" > Project No --> Process Item Popup (E-mail Link)</a><br>
	<a href="http://localhost/olmLink.do?olmLoginid=guest&object=elmInst&linkType=id&linkID=E000000001&languageID=1042&instanceNO=E0000000001" >  Element Instance No --> Elm instance Pop up(E-mail Link)</a><br>
	<a href="http://localhost/olmLink.do?olmLoginid=guest&object=procInst&linkType=id&linkID=P000000001&languageID=1042" >  Process Instance No --> Process instance Pop up(E-mail Link)</a><br>

	<!-- SFOLM File Link -->
	<a href="http://localhost/olmLink.do?olmLoginid=guest&object=file&linkID=01.01.01.01&linkType=code&iType=OJ00001&languageID=1042" > Item File download Pop up </a><br>
	<a href="http://localhost/olmLink.do?olmLoginid=guest&object=file&linkID=39&linkType=fileID&languageID=1042" > File download Pop up </a><br>
	
	<a href="http://localhost/viewerFileDownload.do?seq=7"> Download file from external system w/o login </a><br>
   		
	<!-- LF -->
	<a href="http://localhost/indexLF.do?p1=2130178&p2=GWEP&p3=OMS&p4=58324101.6250858&p5=165.244.91.100&olmLng=1042" > 201. LF Single Sign ON</a><br>
	<a href="http://localhost/indexLF.do?p1=MDPADMI&p2=OMS&p3=MDP&p4=20160224005314&p5=192.168.0.101&olmLng=1042" > 202. LF Single Sign ON : 2000305</a><br>
	<a href="olmLinkLF.do?p1=1&p2=GWEP&p3=OMS&p4=58324101.6250858&p5=165.244.91.100&olmLng=1042&object=itm&linkType=code&linkID=ZME21N&iType=OJ00004" >203. LF ItemPop</a><br>
	<a href="http://localhost/indexLF.do?p1=2170039&p2=GWEP&p3=OMS&p4=6436566.8567938&p5=10.49.10.161&olmLng=1042" > 204. LF SSO API I/F</a><br>
	<!-- 
	<a href="http://localhost/srAprvDetailEmailMaster.do?languageID=1042&projectID=28&isPop=Y&isMulti=N&actionType=view&stepInstID=10&actorID=5077&stepSeq=1&wfInstanceID=OLM0000000003&wfID=WF002&documentID=3&srID=3&lastSeq=2&docCategory=SR&wfMode=CurAprv" target="_blank">204.결재 승인/반려 Email&nbsp;</a><br>
	 -->	
	<a href="http://localhost/srAprvDetailEmail.do?languageID=1042&projectID=64&stepInstID=65&isPop=Y&isMulti=N&actionType=view&actorID=1&stepSeq=1&wfInstanceID=OLM0000000033&lastSeq=1&documentID=240&srID=240&docCategory=SR&wfMode=CurAprv&aprvMode=APRV" target="_blank">205.결재 승인/반려 Email &nbsp; </a><br></br>
	
	
	<a href="http://localhost/reqSRDueDateChangeEmail.do?userID=sys&languageID=1042&srID=2&srType=ITSP" target="_blank">205.완료 예정일 수정&nbsp;</a><br>	
	<br>
	
	<!-- Hanwha HTC -->
	<a href="http://96.97.23.61/indexHWC.do?slo_p_ota=cd791ed82fcbc13dd8b679148d76e1fbc5337966f78afe273c7175664bcf073c&olmLng=1042"> 301. HANWHA Single LogON : yt.cho</a><br>		
	<a href="http://localhost/srConfirmFromEmail.do?srID=44&userID=kiseon.lee"target="_blank">302.SR Confirm&nbsp;&nbsp;<input value="Confirm" type="button"></a><br>	
	<a href="http://htg.circle.hanwha.com/api/branch/common/slo/goSloTarget.mvc?authType=2&destination=http://localhost/indexHW.do?olmLng=1042&screenType=srRqst&sysCode=S1108&proposal=01"> 303. HANWHA SR 등록</a><br>	
	<a href="http://localhost/indexHW.do?user=sys&olmLng=1042&screenType=srRqst&sysCode=S1108"> 304. HANWHA SR 등록  with System Code</span></a><br><br>	
	<a href="http://localhost/indexHW.do?user=sys&olmLng=1042&srID=10014&screenType=srRcv"> 305. HANWHA SR 접수</a><br><br>	
	<a href="http://htg.circle.hanwha.com/api/branch/common/slo/goSloTarget.mvc?authType=2&destination=http://localhost/indexHW.do?&olmLng=1042&mainType=srDsk"> 306. HANWHA Service Desk</a><br>	
	<a href="http://htg.circle.hanwha.com/api/branch/common/slo/goSloTarget.mvc?authType=2&destination=http://localhost/indexHWC.do?&olmLng=1042&screenType=myPage&mainType=mySR"> 307. HANWHA My page/My SR</a><br>	
    <a href="http://htg.circle.hanwha.com/api/branch/common/slo/goSloTarget.mvc?authType=2&destination=http://localhost/indexHWC.do?&olmLng=1042&screenType=myPage&mainType=myCSR&status=CNG"> 308. HANWHA My page/My CSR</a><br>	
	<a href=" http://96.97.23.61/hanwha/hwSRView.do?empno=130076">309. 그룹웨어 SR 진행 현황</a><br/>	
	
	<a href="http://localhost/indexHW.do?user=sys&fileID=7&mainType=FILEDOWN" target="_blank"> 311.File DonwLoad&nbsp;&nbsp;</a><br>			
	<a href="http://htg.circle.hanwha.com/neo/branch/common/slo/goSloTarget.mvc?authType=2&destination=http://96.97.28.130/indexHW.do?user=&fileID=6&mainType=FILEDOWN"> 312.운영 HANWHA TOTAL File</a><br>	
	 
	 <!--Hanwha Defence  -->
	 
	 <a href="http://localhost/indexHWC.do?slo_p_ota=cd791ed82fcbc13dd8b679148d76e1fbc5337966f78afe273c7175664bcf0c12345&olmLng=1042"> 한화 에어로스페이스 </a><br>		
	 <a href="http://cleverseapi.hanwha-ds.com/soap/auth/neoslo/goSloTarget.mvc?authType=2&destination="> 한화 에어로스페이스 </a><br>	
		
	<!-- SK Hynix -->
	<a href="olmLinkSK.do?object=itm&linkType=id&linkID=100&languageID=1042" > 401.SK SSO ITEM POP LINK [ID] </a><br>	
	<br>
	
	<!--  CJ -->
	<a href="http://localhost/indexCJ.do?userId=HFGQ10fJyBl2nZc45XHfsw==&token=n6ISFiqNhv2QFnxglW5eg==&language=KR"> 501. CJ Single Sign ON </a><br>
	<a href="http://10.64.0.60/custom/olmLinkCJ.do?userId=HFGQ10fJyBl2nZc45XHfsw==&token=n6ISFiqNhv2QFnxglW5eg==&language=KR&languageID=1042&scrnType=pop&object=itm&linkType=id&option=AR010100&linkID=107263">502. CJ SSO ITEM POP LINK(GET) </a><br>
	<br>
	
	<!-- Mando -->
	<a href="http://gbpms.mando.com/indexMD.do?PM_SABUN=Q22PsG92RIZoUnBxU2mq1/LbHt%2BmPRbghZzQxn679vm2ineQkmtxY3DBgMQ7RjtFb8nQMxtVIeHuR8JcLgkKPwoxTxccLKk%2FadNhqe5YXveFhxTd1RG0iRZyxo6dwVPXD0I7OJy8HfygXrsryqg%2FRw%3D%3D&language=KR" >601.Mando SSO </a><br>	
	<a href="http://191.1.13.171/olmLinkMD.do?PM_SABUN=Q22PsG92RIZoUnBxU2mq1/LbHt%2BmPRbghZzQxn679vm2ineQkmtxY3DBgMQ7RjtFb8nQMxtVIeHuR8JcLgkKPwoxTxccLKk%2FadNhqe5YXveFhxTd1RG0iRZyxo6dwVPXD0I7OJy8HfygXrsryqg%2FRw%3D%3D&language=KR&object=itm&linkType=code&linkID=EAC1000&iType=OJ00004&source=EAC" >602. Mando ItemPop</a><br></br>
	
	
	<a href="http://localhost/batchExportMdlImage.do?language=EN"> 600. Batch export of model images  </a><br><br>
	
	<!--  DAELIM-->
	<a href="http://localhost/indexIEP.do?userID=sys&gloProjectID=040833&language=KR" >   701.  Daelim IEP :: SYS USER</a><br>
	<a href="http://localhost/indexIEP.do?userID=guest&gloProjectID=040833&language=KR" > 702.  Daelim IEP :: GUEST USER</a><br>	
		
	<!--  DAELIM BIM -->
    <a href="http://localhost/zDli2Olm.do?GUID=234231423423&object=itm&linkType=id&linkID=116181&option=IEP2100&languageID=1042" > 703.  Ensemble Master Process Item Link : Master Process ItemID + ArcCode </a><br>
   
   	<a href="http://localhost/zDli2Olm.do?GUID=234231423423&object=itm&linkType=jobNo&linkID=200022&projectType=1&languageID=1042" > 704. Ensemble Project Process item Link : Project No, Project Type --> Project Process Item Popup </a><br>
   	<a href="http://localhost/zDli2Olm.do?GUID=234231423423&object=procInst&linkType=jobNo&linkID=200022&projecType=1&languageID=1042" > 705.  Ensemble Process Instance Link : Project No, Project Type --> Process Instance Popup </a><br>
	
	<a href="http://localhost/zDli2Olm.do?GUID=guest&object=procInst&linkType=id&linkID=P000000140&languageID=1042" >   706.  E-mail Proc Instance Link : Project No, Process Instance No --> Process Instance Popup </a><br>
   	<a href="http://localhost/zDli2Olm.do?GUID=guest&object=elmInst&linkType=id&linkID=E000000001&languageID=1042" >    707.  E-mail Elm Instance Link :  Element Instance No --> Elm instance Pop up(E-mail Link)</a><br>
   	
  	<!--  SAMSUNG -->
	<a href="http://localhost/olmLinkSamsung.do?object=itm&linkType=code&linkID=3.5.1.3.3&iType=OJ00001&language=KR" >801. Samsung Inbound Link</a><br></br>
	
	<!--  KDNVN -->
	<a href="http://localhost:8090/indexKDNVN.do?empNo=10000020&language=KR" > 901.  KDNVN Single Sign ON</a><br>	
	<a href="olmLinkArc.do?loginID=sys&languageID=1042&arcCode=AR010110" > 902. OLM Architecture Link </a><br>
	
	<a href="http://localhost/olmLinkMaster.do?srID=240&mainType=mySRDtl" target="_blank">903.SR 상세 &nbsp;</a><br>
	<a href="http://localhost/olmLinkMaster.do?wfInstanceID=OLM0000000033&mainType=myWFDtl" target="_blank">904.결재  상세  &nbsp;</a><br> <br></br>	

	<!--  CSINC  -->

    <a href= "indexCSI.do?loginID=jaemin.lee&language=KR&defTemplateCode=TMPL001&defArcCode=ITS2000" > 1000 CSINC  SSO </a> <br> 
    
    
    <a href="olmLink.do?olmLoginid=guest&object=itm&linkType=code&linkID=4.2.3.7&iType=OJ00001&languageID=1042&scrnType=TMPL" > Inbound Item Link to Template view[Code] </a><br>
    
    <!-- Nets SSO -->
    <a href="http://localhost:8090/olmNetsLink.jsp?object=itm&linkType=id&linkID=100659&languageID=1042">Nets SSO Item popup</a><br>
    
    <!--  SAML -->
	<a href="/link/sso/saml/olmSSOLink.do?&object=itm&linkType=code&linkID=02.01.01.01&languageID=1042&iType=OJ00001" > 1001. SAML SSO Item popup
	<a href="/link/sso/saml/olmSSO.do?defTemplateCode=TMPL001&defArcCode=ITS2000&srID=213&docCategory=SR" /> SAML SR 상세
	
	<!--  oAuth -->
	<a href="/link/sso/ms/olmSSOLink.do?&object=itm&linkType=code&linkID=02.01.01.01&languageID=1042&iType=OJ00001" > 1002. oAuth SSO Item popup
    
    <!-- DLMC -->
    <a href="http://localhost:8090/custom/zDlmc_InboundLink.do?object=itm&linkType=id&linkID=100913&languageID=1042"> 1003. DLMC SSO Item popup</a><br>
    
   <!-- SKON -->
    <a href="http://gsdm.sk-on.com?defArcCode=process"> 1004. process arc menu 호출
    <a href="http://gsdm.sk-on.com?defArcCode=tech"> 1005. tech arc menu 호출
    <a href="http://gsdm.sk-on.com?defArcCode=rule"> 1006. rule arc menu 호출
    <a href="http://gsdm.sk-on.com?defArcCode=term"> 1007. term arc menu 호출
   
    
	<iframe name="main" id="main" width="100%" height="100%" frameborder="0" scrolling="no"></iframe></body></html>


