package xbolt.cmm.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;




import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.format.ScriptStyle;
import jxl.format.UnderlineStyle;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.org.json.JSONObject;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.JsonUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GetProperty;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;
import xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalDocumentStatusOnly;
import xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.ApprovalServiceProxy;
import xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.MisKey;
import xbolt.custom.hanwha.val.HanwhaGlobalVal;
import xbolt.hom.schdl.web.SchedulActionController;
import xbolt.project.chgInf.web.CSActionController;

/**
 * 공통 서블릿 처리
 * @Class Name : CmmActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2012. 09. 01. smartfactory		최초생성
 *
 * @since 2012. 09. 01.
 * @version 1.0
 * @see
 * 
 * Copyright (C) 2012 by SMARTFACTORY All right reserved.
 */

@Controller
@SuppressWarnings("unchecked")
public class BacthActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "CSActionController")
	private CSActionController CSActionController;
	
	private final Log _log = LogFactory.getLog(this.getClass());
	

	@RequestMapping(value="/getBatchList.do")
	public String getBatchList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		List batchList = new ArrayList();
		HashMap setMap = new HashMap();
		HashMap getMap = new HashMap();
		HashMap target = new HashMap();
		
		try{ 			
				
			batchList = commonService.selectList("common_SQL.getBatchList",setMap);

			if(batchList != null && !batchList.isEmpty()) {
				
				for(int i=0; i<batchList.size(); i++) {
					getMap = (HashMap) batchList.get(i);
					String URL = StringUtil.checkNull(getMap.get("URL"));
					executeBatch(URL, request, commandMap, model);					
				}
			}
			
				
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("CmmActionController::setVisitLog::Error::"+e);}
			//throw e;
		}	
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	private void executeBatch(String url, HttpServletRequest request, HashMap commandMap, ModelMap model) {
		try {
			if(url.equals("excuteEmailBatch")) {
				excuteEmailBatch(request, commandMap, model);
			}
			else if(url.equals("zhwc_ExcuteApprvBatch")) {
				zhwc_ExcuteApprvBatch(request, commandMap, model);
				
			}
			else if(url.equals("zhtc_ExcuteApprvBatch")) {
				zhtc_ExcuteApprvBatch(request, commandMap, model);
			}else if(url.equals("sendMailImpSchdl")) {
				sendMailImpSchdl(request, commandMap, model);
			}
		}catch (Exception e) {

			if(_log.isInfoEnabled()){_log.info("CmmActionController::setVisitLog::Error::"+e);}
		}
	}
	
	
	@RequestMapping(value="/excuteEmailBatch.do")
	public String excuteEmailBatch(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		List mailList = new ArrayList();
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		String flag = "Y";
		try{ 			
				
			mailList = commonService.selectList("common_SQL.getSendEmailList",setMap);

			if(mailList != null && !mailList.isEmpty()) {
				
				for(int i=0; i<mailList.size(); i++) {
					HashMap temp = (HashMap) mailList.get(i);
					String batEmailID = StringUtil.checkNull(temp.get("BatEmailID"));
					String formDataString = StringUtil.checkNull(temp.get("FormData"));
					String receiverString = StringUtil.checkNull(temp.get("RceiverList"));
					String MailFormType = StringUtil.checkNull(temp.get("MailFormType"));
					String languageID = StringUtil.checkNull(temp.get("LanguageID"));
					String mailSubject = StringUtil.checkNull(temp.get("MailSubject"));
					HashMap formData = new HashMap();
					HashMap receiverMap = new HashMap();
					List receiverList = new ArrayList();
					int j=0;

					String[] formDataStringArray = formDataString.split(",");
					
					for(String pair : formDataStringArray) {   
						 String[] entry = pair.split("=");             
						 formData.put(entry[0].trim(), entry[1].trim());     
					}

					String[] receiverStringArray = receiverString.split("/");
					
					for(String pair1 : receiverStringArray) {   
						 String[] entry = pair1.split(",");              
						 receiverMap = new HashMap();
						 for(String pair2 : entry) {   
							 String[] entry2 = pair2.split("=");             
							 receiverMap.put(entry2[0].trim(), entry2[1].trim());     
						}
						 receiverList.add(j++,receiverMap);						 
					}

					setMap.put("batEmailID",batEmailID);
					
					setMap.put("receiverList",receiverList);
					setMap.put("LanguageID",languageID);
					setMap.put("subject", mailSubject);					
					
					Map setMailMap = (Map)setEmailLog(request, commonService, setMap, MailFormType); //결제 상신 메일 전송
					if(StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")){
						HashMap mailMap = (HashMap)setMailMap.get("mailLog");
						
						Map resultMailMap = EmailUtil.sendMail(mailMap,formData,getLabel(request, commonService));
						System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMap.get("type")));
						
						setMap.put("flag","Y");
						commonService.update("common_SQL.updateEmailSendFlag", setMap);
						
					}else{
						System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMap.get("msg")));						
					}
				}
			}
			
				
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("CmmActionController::setVisitLog::Error::"+e);}
			//throw e;
		}	
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}


	@RequestMapping(value="/zhwc_ExcuteApprvBatch.do")
	public String zhwc_ExcuteApprvBatch(HttpServletRequest request,HashMap commandMap , ModelMap model) throws Exception {  
		Map target = new HashMap();
		
	 	try{
		
	 		Map setMap = new HashMap();
	 		List apprList = commonService.selectList("wf_SQL.getWFINSTanceForStatusOne",setMap);
	 		String wfInstanceStatus = "";
	 		String wfInstanceID = "";
	 		String apprStatus = "";
	 		String status = "";
	 		String url = "";
 			if(apprList != null && apprList.size() > 0){
       			int prcsCnt=apprList.size();
     			//2. Call Web Service getProcessIdByBulkMisId 
    			//1:진행->OPN, 2:완료(승인)->CLS, 3:반려(반송)->HOLD, 4:상신취소->CNCL
       			MisKey[] miskeys = new MisKey[prcsCnt];

       			for(int i=0; i<apprList.size(); i++){
       				Map prcsMap = (HashMap)apprList.get(i);	       				
       				miskeys[i] = new MisKey();
       				miskeys[i].setMisDocId(StringUtil.checkNull(prcsMap.get("WFInstanceID")));
       				miskeys[i].setSystemId(StringUtil.checkNull(HanwhaGlobalVal.HW_SYSTEM_ID));
       				//System.out.println("Set Map : "+CmmUtil.getCurrentDate()+"::i="+i+"::"+prcsMap+"::"+prcsMap.get("WFInstanceID"));
    			}
       			//System.out.println("Sucessfully Set Map");
		    	ApprovalServiceProxy proxy = new ApprovalServiceProxy();
				ApprovalDocumentStatusOnly[] aprvStatusResults = proxy.getProcessIdByBulkMisId(miskeys);								
 					
				for(int i=0; i<aprvStatusResults.length; i++){ 
					status = StringUtil.checkNull(aprvStatusResults[i].getStatus());			

					if(status.equals("2")) { //완료
						// Update  WF Instance & CSR 		
						setMap.put("wfID","WF001");
						setMap.put("wfDocType","CS");
						
						String postProcessing = StringUtil.checkNull(commonService.selectString("wf_SQL.getPostProcessing", setMap),""); 
					   
						if(postProcessing != "") {
						    status = "CLS";						
							if(postProcessing.split("\\?").length > 1) {
								String tmp[] = postProcessing.split("\\?");
								url = tmp[0];
							}
							else {
								url = postProcessing;						
							}
							
							if("updateCSStatusForWF.do".equals(url)) {
								commandMap.put("status","CLS");
								commandMap.put("wfInstanceID",aprvStatusResults[i].getMisDocId());
								commandMap.put("preFileBlocked","Y");
								CSActionController.updateCSStatusForWF(request,commandMap,model);
							}							
						}				
						
						setMap.put("status", "CLS"); 	

						setMap.put("wfInstanceID", aprvStatusResults[i].getMisDocId());
						commonService.update("cs_SQL.updateChangeSetForWFInstID", setMap);
					
						setMap.put("Status", "2");
						setMap.put("WFInstanceID", aprvStatusResults[i].getMisDocId());
						setMap.put("LastUser", "1");
						commonService.update("wf_SQL.updateWfInst", setMap);
						commonService.update("wf_SQL.updateWFStepInst", setMap); 	// Update TB_WF_STEP_INST
						
					}
					else if(status.equals("3")) { //반려
						
						setMap.put("wfID","WF001");
						setMap.put("wfDocType","CS");
						
						String postProcessing = StringUtil.checkNull(commonService.selectString("wf_SQL.getPostProcessing", setMap),""); 
					   
						if(postProcessing != "") {				
							if(postProcessing.split("\\?").length > 1) {
								String tmp[] = postProcessing.split("\\?");
								url = tmp[0];
							}
							else {
								url = postProcessing;					
							}
							
							if("updateCSStatusForWF.do".equals(url)) {
								commandMap.put("status","WTR");
								commandMap.put("wfInstanceID",aprvStatusResults[i].getMisDocId());
								CSActionController.updateCSStatusForWF(request,commandMap,model);
							}
							
						}				

						setMap.put("wfInstanceID", aprvStatusResults[i].getMisDocId());
						commonService.update("custom_SQL.zhwc_initCSVersionForWFInstID", setMap);
					
						setMap.put("Status", "3"); 	
						setMap.put("WFInstanceID", aprvStatusResults[i].getMisDocId());
						setMap.put("LastUser", "1");
						commonService.update("wf_SQL.updateWfInst", setMap);
						commonService.update("wf_SQL.updateWFStepInst", setMap); 	// Update TB_WF_STEP_INST
					}	
					else if(status.equals("4")) { //취소
						
						setMap.put("status", "CMP"); 	

						setMap.put("wfInstanceID", aprvStatusResults[i].getMisDocId());
						commonService.update("cs_SQL.updateChangeSetForWFInstID", setMap);
					
						setMap.put("Status", "0");
						setMap.put("WFInstanceID", aprvStatusResults[i].getMisDocId());
						commonService.update("wf_SQL.updateWfInst", setMap);
						
					}	
				}										  
 			} 				
		}catch(Exception e){
			System.out.println(e);
	    }
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	 }


	@RequestMapping(value="/zhtc_ExcuteApprvBatch.do")
	public String zhtc_ExcuteApprvBatch(HttpServletRequest request,HashMap commandMap , ModelMap model) throws Exception {  
		Map target = new HashMap();
		
	 	try{
		
	 		Map setMap = new HashMap();
	 		List apprList = commonService.selectList("wf_SQL.getWFINSTanceForStatusOne",setMap);
	 		String wfInstanceStatus = "";
	 		String wfInstanceID = "";
	 		String apprStatus = "";
	 		String status = "";
	 		String url = "";
 			if(apprList != null && apprList.size() > 0){
       			int prcsCnt=apprList.size();
     			//2. Call Web Service getProcessIdByBulkMisId 
    			//1:진행->OPN, 2:완료(승인)->CLS, 3:반려(반송)->HOLD, 4:상신취소->CNCL
       			MisKey[] miskeys = new MisKey[prcsCnt];

       			for(int i=0; i<apprList.size(); i++){
       				Map prcsMap = (HashMap)apprList.get(i);	       				
       				miskeys[i] = new MisKey();
       				miskeys[i].setMisDocId(StringUtil.checkNull(prcsMap.get("WFInstanceID")));
       				miskeys[i].setSystemId(StringUtil.checkNull(HanwhaGlobalVal.HW_SYSTEM_ID));
       				//System.out.println("Set Map : "+CmmUtil.getCurrentDate()+"::i="+i+"::"+prcsMap+"::"+prcsMap.get("WFInstanceID"));
    			}
       			//System.out.println("Sucessfully Set Map");
		    	ApprovalServiceProxy proxy = new ApprovalServiceProxy();
				ApprovalDocumentStatusOnly[] aprvStatusResults = proxy.getProcessIdByBulkMisId(miskeys);								
 					
				for(int i=0; i<aprvStatusResults.length; i++){ 
					status = StringUtil.checkNull(aprvStatusResults[i].getStatus());					
 					
					if(status.equals("2")) { //완료
						// Update  WF Instance & CSR 		
						setMap.put("wfID","WF001");
						setMap.put("wfDocType","CS");
						
						String postProcessing = StringUtil.checkNull(commonService.selectString("wf_SQL.getPostProcessing", setMap),""); 
					   
						if(postProcessing != "") {
						    status = "CLS";						
							if(postProcessing.split("\\?").length > 1) {
								String tmp[] = postProcessing.split("\\?");
								url = tmp[0];
							}
							else {
								url = postProcessing;						
							}
							
							if("updateCSStatusForWF.do".equals(url)) {
								commandMap.put("status","CLS");
								commandMap.put("wfInstanceID",aprvStatusResults[i].getMisDocId());
								CSActionController.updateCSStatusForWF(request,commandMap,model);
							}							
						}				
						
						setMap.put("status", "CLS"); 	

						setMap.put("wfInstanceID", aprvStatusResults[i].getMisDocId());
						commonService.update("cs_SQL.updateChangeSetForWFInstID", setMap);
					
						setMap.put("Status", "2");
						
					}
					else if(status.equals("4")) { //취소
						
						setMap.put("status", "CMP"); 	

						setMap.put("wfInstanceID", aprvStatusResults[i].getMisDocId());
						commonService.update("cs_SQL.updateChangeSetForWFInstID", setMap);
					
						setMap.put("Status", "0");
						
					}	
					else if(status.equals("3")) { //반려
						
						setMap.put("wfID","WF001");
						setMap.put("wfDocType","CS");
						
						String postProcessing = StringUtil.checkNull(commonService.selectString("wf_SQL.getPostProcessing", setMap),""); 
					   
						if(postProcessing != "") {				
							if(postProcessing.split("\\?").length > 1) {
								String tmp[] = postProcessing.split("\\?");
								url = tmp[0];
							}
							else {
								url = postProcessing;					
							}
							
							if("updateCSStatusForWF.do".equals(url)) {
								commandMap.put("status","WTR");
								commandMap.put("wfInstanceID",aprvStatusResults[i].getMisDocId());
								CSActionController.updateCSStatusForWF(request,commandMap,model);
							}
							
						}				
											
						setMap.put("Status", "3"); 	
					}	
					setMap.put("WFInstanceID", aprvStatusResults[i].getMisDocId());
					commonService.update("wf_SQL.updateWfInst", setMap);
					commonService.update("wf_SQL.updateWFStepInst", setMap); 	// Update TB_WF_STEP_INST
				}										  
 			} 				
		}catch(Exception e){
			System.out.println(e);
	    }
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	 }	
	
	@RequestMapping(value="/sendMailImpSchdl.do")
	public String sendMailImpSchdl(HttpServletRequest request,HashMap commandMap , ModelMap model) throws Exception {  
		//System.out.println("실행");
		HashMap setMeilData = new HashMap();
		Map setdata = new HashMap();
		HttpSession session = request.getSession(true);
		String sharers = "";
		String Subject = "";
		
		Map receiverMap = new HashMap();
		List receiverList = new ArrayList();
		String language = GlobalVal.DEFAULT_LANGUAGE;
		if(session.getAttribute("loginInfo") == null) {
			setdata.put("LOGIN_ID", "skyi");
			setdata.put("IS_CHECK", "N");
			setdata.put("LANGUAGE", language);	
			Map loginInfo = commonService.select("login_SQL.login_select", setdata);
			session.setAttribute("loginInfo", loginInfo);
		}
		List scheduleIdList = commonService.selectList("schedule_SQL.getImpendingSchdlList",setdata);
		
		for(int i=0; i<scheduleIdList.size(); i++) {
			receiverMap = new HashMap();
			receiverList = new ArrayList();
			
			setdata = (HashMap) scheduleIdList.get(i);
			setdata.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"),language));
			setMeilData = (HashMap) commonService.select("schedule_SQL.schedulDetail", setdata);
			sharers = StringUtil.checkNull(setMeilData.get("RegUserID")) + "," + StringUtil.checkNull(setMeilData.get("sharers")); 
			Subject = StringUtil.checkNull(setMeilData.get("Subject"));
			
			setMeilData.put("projectName", setMeilData.get("ProjectName"));
			setMeilData.put("StartDT", setMeilData.get("startDateM"));
			setMeilData.put("EndDT", setMeilData.get("endDateM"));
			setMeilData.put("location", setMeilData.get("Location"));
			setMeilData.put("userNm", setMeilData.get("WriteUserNM"));
			
			if(sharers.length() > 0) {
		 		String sharerList[] = sharers.split(",");
		
				for(int k=0; k<sharerList.length; k++){
					receiverMap = new HashMap();
					receiverMap.put("receiptUserID", sharerList[k]);
					receiverList.add(k, receiverMap);
				}
				
				HashMap setMailData = new HashMap();
				setMailData.put("receiverList",receiverList);
				Map setMailMapRst = (Map)setEmailLog(request, commonService, setMailData, "SCHDLALM");
				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
				mailMap.put("mailSubject", "OLM Schedule Alarm - "+ Subject);
				
				setMeilData.put("languageID", language);
				setdata.put("emailCode", "SCHDL");
				String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", setdata));
				setMeilData.put("emailHTMLForm", emailHTMLForm);
				
				Map resultMailMap = EmailUtil.sendMail(mailMap, setMeilData, getLabel(request, commonService));
			}
		}
		
		model.addAttribute(AJAX_RESULTMAP, setMeilData);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/sendLineWorksMessageImpSchdl.do")
	public String sendLineWorksMessageImpSchdl(HttpServletRequest request,HashMap commandMap , ModelMap model) throws Exception {  
		//System.out.println("실행");
		HashMap setMeilData = new HashMap();
		Map setdata = new HashMap();
		HttpSession session = request.getSession(true);
		String sharers = "";
		String Subject = "";
		String messageText = "";
		
		Map receiverMap = new HashMap();
		List receiverList = new ArrayList();
		String language = GlobalVal.DEFAULT_LANGUAGE;
		if(session.getAttribute("loginInfo") == null) {
			setdata.put("LOGIN_ID", "skyi");
			setdata.put("IS_CHECK", "N");
			setdata.put("LANGUAGE", language);	
			Map loginInfo = commonService.select("login_SQL.login_select", setdata);
			session.setAttribute("loginInfo", loginInfo);
		}
		List scheduleIdList = commonService.selectList("schedule_SQL.getImpendingSchdlList",setdata);
		
		for(int i=0; i<scheduleIdList.size(); i++) {
			messageText = "";
			receiverMap = new HashMap();
			receiverList = new ArrayList();
			
			setdata = (HashMap) scheduleIdList.get(i);
			setdata.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"),language));
			setMeilData = (HashMap) commonService.select("schedule_SQL.schedulDetail", setdata);
			sharers = StringUtil.checkNull(setMeilData.get("RegUserID")) + "," + StringUtil.checkNull(setMeilData.get("sharers")); 
			Subject = StringUtil.checkNull(setMeilData.get("Subject"));
			
			messageText += "Subject : "+ Subject +"\\n";
			messageText += "Content : "+ String.valueOf(setMeilData.get("Content")).replace("\r\n", "\\n") +"\\n";
			messageText += "Location : "+ setMeilData.get("Location") +"\\n";
			messageText += "Start : "+ setMeilData.get("startDateM") +"\\n";
			messageText += "End : "+ setMeilData.get("endDateM") +"\\n";
			commandMap.put("messageText",messageText);
			schdlLineWorksAlarm(request, (HashMap)commandMap, model);
			if(sharers.length() > 0) {
				String sharerList[] = sharers.split(",");
				
				for(int k=0; k<sharerList.length; k++){
					receiverMap = new HashMap();
					receiverMap.put("receiptUserID", sharerList[k]);
					receiverList.add(k, receiverMap);
				}
			}
		}
		
		model.addAttribute(AJAX_RESULTMAP, setMeilData);
		return nextUrl(AJAXPAGE);
	}
		
	
public static Map setEmailLog(HttpServletRequest request, CommonService commonService, Map cmmMap, String dicTypeCode) throws Exception{
		
		HashMap resultMap = new HashMap();		
		if( StringUtil.checkNull(GlobalVal.USE_EMAIL).equals("Y")){
			Map mMailInfo = new HashMap();
			mMailInfo.put("dicTypeCode", dicTypeCode);
			try{
				Map setMap = new HashMap();
				//	String receiptEmail =  "skyi@smartfactory.co.kr";//StringUtil.checkNull(commonService.selectString("user_SQL.userEmail", setData));		
				//	String senderEmail =  "jhwan.cho@hanwha-total.com";//StringUtil.checkNull(commandMap.get("sessionEmail"));
				List receiverList = (List)cmmMap.get("receiverList");
				//보내는 사람
				HttpSession session = request.getSession(true);
				Map loginInfo = (Map)session.getAttribute("loginInfo");
				String sendUserID= StringUtil.checkNull(loginInfo.get("sessionUserId"));
				setMap.put("userID", sendUserID);
				//String senderEmail = StringUtil.checkNull(commonService.selectString("user_SQL.userEmail", setMap));
				String emailSender = GlobalVal.EMAIL_SENDER;
				
				if(receiverList.size()>0 && !emailSender.equals("")){
					Map setDicMap = new HashMap();
					setDicMap.put("Category", "EMAILCODE");
					setDicMap.put("TypeCode", dicTypeCode);
					setDicMap.put("LanguageID", StringUtil.checkNull(loginInfo.get("sessionCurrLangType")));
					List mailDtlList = new ArrayList();
					mailDtlList = commonService.selectList("common_SQL.label_commonSelect",setDicMap);
					String mailSubject="";
					for(int i=0; i<mailDtlList.size(); i++){
						mailSubject = StringUtil.checkNull(((HashMap)mailDtlList.get(i)).get("LABEL_NM")); break;
					}
					String subject = StringUtil.checkNull(cmmMap.get("subject"));
					mMailInfo.put("mailSubject", mailSubject+" "+subject);
					///insert emailLog
					String maxId = null;
					List receiverInfoList = new ArrayList();
					Map receiverInfoMap = new HashMap();
					Map receiverListMap = new HashMap();
					String receiptEmail = null;
					
					mMailInfo.put("Sender", emailSender);					
					mMailInfo.put("EmailCode", dicTypeCode);
					
					for(int i=0; receiverList.size()>i; i++){
						receiverInfoMap = new HashMap();
						receiverListMap = (Map)receiverList.get(i);
						maxId = StringUtil.checkNull(commonService.selectString("email_SQL.emailLog_nextVal", setMap)).trim();
						receiverInfoMap.put("seqID", maxId);
						setMap.put("userID", receiverListMap.get("receiptUserID"));
						receiptEmail =  StringUtil.checkNull(commonService.selectString("user_SQL.userEmail", setMap));	
						receiverInfoMap.put("receiptEmail", receiptEmail);						
						receiverInfoMap.put("receiptType", StringUtil.checkNull(receiverListMap.get("receiptType"),"TO") );
						receiverInfoMap.put("receiptUserID", receiverListMap.get("receiptUserID"));
						
						receiverInfoList.add(i, receiverInfoMap);						
						mMailInfo.put("Receiver", receiptEmail);
						mMailInfo.put("SEQ", maxId);
						commonService.insert("email_SQL.insertEmailLog", mMailInfo);
					}
					
					mMailInfo.put("receiverInfoList", receiverInfoList);
					mMailInfo.put("sendUserID", sendUserID);	
					
					resultMap.put("type", "SUCESS");
					resultMap.put("mailLog", mMailInfo);
				}else{
					resultMap.put("type", "FAILE");
					resultMap.put("msg", "not exists email address : emailSender="+emailSender+", receiverList.Size="+receiverList.size());
				}
			}catch(Exception ex){
				resultMap.put("type", "FAILE");
				resultMap.put("msg", ex.getMessage());
			}
		}else{
			resultMap.put("type", "DONT");
			resultMap.put("msg", "not use email");
		}
		return resultMap;
	}
	
	//===================================================================================
	//PROCESS PROG_LOG
	public static Map decideSRProcPath(HttpServletRequest request, CommonService commonService, Map cmmMap) throws Exception{
		
		HashMap resultMap = new HashMap();
		//=======================
		//set Parameter
		//HashMap getParam = new HashMap();
		//Context Path
		String context 				= request.getContextPath();
		//요청페이지 주소
		String reqUrl 				= request.getServletPath();
		//=======================
		//get PROC_LOG_CONFIG
		reqUrl = reqUrl.replace("/", "");
		cmmMap.put("FunctionNM", reqUrl);
		System.out.println("XboltController.decideSRProcPath : reqUrl===>>>"+reqUrl);
		
		List procLogCnfList = commonService.selectList("procLog_SQL.getESMProcConfig",cmmMap);
		HashMap listMap = new HashMap();
		String key = "";		
		for(int i = 0; i < procLogCnfList.size(); i++){
			listMap = (HashMap)procLogCnfList.get(i);
			key = StringUtil.checkNull(listMap.get("EventParameter"));
			if(!"".equals(key) && !"".equals(StringUtil.checkNull(cmmMap.get(key)))){
				String cnfValue = StringUtil.checkNull(listMap.get("EventValue"));
				if(cnfValue.equals(StringUtil.checkNull(cmmMap.get(key)))){
					key = StringUtil.checkNull(listMap.get("PIDParameter"));			
					resultMap.put("PID", cmmMap.get(key));
					key = StringUtil.checkNull(listMap.get("ActionParameter"));			
					resultMap.put("ActionID", cmmMap.get(key));
					resultMap.put("ActivityCD", StringUtil.checkNull(listMap.get("ActivityCD")));		
					key = StringUtil.checkNull(listMap.get("CommentParameter"));			
					resultMap.put("Comment", cmmMap.get(key));	
					
					resultMap.put("SpeCode", listMap.get("SpeCode"));	
					resultMap.put("ProcPathID", listMap.get("ProcPathID"));
				
					break;
				}
			}
		}
		return resultMap;
	}
	public static Map getLabel(HttpServletRequest request, CommonService commonService) throws Exception{
		HashMap cmmMap = new HashMap();
		HashMap getMap = new HashMap();
		String langType = getUserCurrLangType(request);
		cmmMap.put("languageID", langType);
		cmmMap.put("mnCategory", "LN");
		List labelList = commonService.selectList("menu_SQL.menuName",cmmMap);
		
		cmmMap = new HashMap();
		for(int i = 0; i < labelList.size(); i++){
			cmmMap = (HashMap)labelList.get(i);
			getMap.put(cmmMap.get("TypeCode"), cmmMap.get("Name"));
		}
		
		return getMap;
	}	
	public static String getUserCurrLangType(HttpServletRequest request) throws Exception{
		HttpSession session = request.getSession(true);
		String langType = GlobalVal.DEFAULT_LANGUAGE;
		String reqLangType = StringUtil.checkNull(request.getParameter("languageID"), "");
		String sessLangType = "";
		
		if(reqLangType.equals("")){
			Map userInfo = (Map)session.getAttribute("loginInfo");
			if(userInfo!=null){
				sessLangType = String.valueOf(userInfo.get("sessionCurrLangType"));
				langType = sessLangType;
			}
		}else{langType=reqLangType;}
		//System.out.println("default="+GlobalVal.DEFAULT_LANGUAGE+", reqLangType="+reqLangType+",sessionLang="+sessLangType+",langType="+langType);
		return langType;
	}	
	
	public static void schdlLineWorksAlarm(HttpServletRequest request, HashMap cmmMap,	ModelMap model) throws Exception {
		
		String url = "https://apis.worksmobile.com/r/kr1ILTkbapVSx/message/v1/bot/1049042/message/push";
		String consumerKey = "MGBKUzF2kEzRQV3ddzbJ";
		String token = "AAAA+s5kFw2a4bYuxjO6Dw6VYzJ01gzABenLtVv5cFr8cK1CiCtu38h9iEtB2GbTsmDaba/Y2kdlHilfk730gply8Xq735Ztx+M1K2zyBxskpSKMI059aMd//U3C09WSfXTvVYNF7vhEvydnTbpsllkBAp30015BqRq52eUf6zvdOeawG5fcHsfTBCVDUMGj6gS/i1hhTvEZilwRME8QYYY+I1c0vIzIkKbcYVOCwoVnlHNzher+c3YvzNO8lkg2y9Fk62idjcrHr6cm8xc9SMrI09BN31z5q6RR0EJgbtjx0/XRydwDnEt2e6gGsZrxEtbizsDVu4I7Q0nfHKDc4yByquA=";


		//String reqeustStr = "{\"botNo\" : 1049042, \"accountId\" : \"wclee@smartfactory\", \"content\" : \"{\"type\" : \"text\", \"text\" : \"안녕하세요.\"}}";
		String reqeustStr = "{\"botNo\":1049042,\"accountId\":\"wclee@smartfactory\", \"content\":{\"type\":\"text\",\"text\":\" "+cmmMap.get("messageText")+" \"}}";
		//String reqeustStr = "{\"botNo\" : 1049042, \"accountIds\" : [\"wclee@smartfactory\"]}";
		//String reqeustStr = "{\"usePublic\" : true, \"usePermission\" : true, \"accountIds\" : [\"wclee@smartfactory\"]}}";
		//String reqeustStr = "{\"accountId\" : [\"wclee@smartfactory\"]}";
	
		JSONObject jo1 = new JSONObject(reqeustStr);
		System.out.println(jo1.toString());
		
		//System.out.println("GET으로 데이터 가져오기");
		//sendGet("https://apis.worksmobile.com/r/kr1ILTkbapVSx/message/v1/bot", consumerKey, token);
	
		System.out.println("POST로 데이터 가져오기");
		String urlParameters = jo1.toString();
		//sendPost("https://apis.worksmobile.com/r/kr1ILTkbapVSx/message/v1/bot/1049042/domain/163390", urlParameters, consumerKey, token);
		//sendPost1("https://apis.worksmobile.com/r/kr1ILTkbapVSx/message/v1/bot/1049042/room", urlParameters, consumerKey, token);
		sendPost(url, urlParameters, consumerKey, token);
		//sendPost("https://apis.worksmobile.com/r/kr1ILTkbapVSx/message/v1/bot/1049042/room", urlParameters, consumerKey, token);

	}
	
	// HTTP GET request
	private void sendGet(String targetUrl, String consumerKey, String token) throws Exception {
		URL url = new URL(targetUrl);
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
		con.setRequestMethod("GET"); // optional default is GET.
		con.setRequestProperty("Content-Type", "application/json; utf-8");
		con.setRequestProperty("Accept", "application/json");
		con.setRequestProperty("consumerKey", consumerKey);
		con.setRequestProperty("Authorization", "Bearer " + token);
		//con.setRequestProperty("User-Agent", USER_AGENT); // add request header

		int responseCode = con.getResponseCode();
		BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();

		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
		in.close();

		// print result
		System.out.println("HTTP 응답 코드 : " + responseCode);
		System.out.println("HTTP body : " + response.toString());
	}

	// HTTP POST request
	private static void sendPost(String targetUrl, String parameters, String consumerKey, String token) throws Exception {
		try {
			//JSONObject jsontype = new JSONObject(reqeustStr);
			//String body = jsontype.toString();
			String body = parameters;
			System.out.println(body);
			URL postUrl = new URL(targetUrl);
			// URL 연결
			HttpURLConnection connection = (HttpURLConnection) postUrl.openConnection();
			// Redirect처리 하지 않음
			connection.setInstanceFollowRedirects(false);
			// 요청 방식 선택 (GET, POST)
			connection.setRequestMethod("POST");
			// Request Header값 셋팅 setRequestProperty(String key, String value)
			connection.setRequestProperty("consumerKey", consumerKey);
			connection.setRequestProperty("Authorization", "Bearer "+token);
			// 타입설정(application/json) 형식으로
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setRequestProperty("Cache-Control", "no-cache");
			connection.setRequestProperty("Accept", "application/json");
			// OutputStream으로 POST 데이터를 넘겨주겠다는 옵션.
			connection.setDoOutput(true);
			// InputStream으로 서버로 부터 응답을 받겠다는 옵션.
			connection.setDoInput(true);
			// Request Body에 Data를 담기위해 OutputStream 객체를 생성.
			OutputStream os= connection.getOutputStream();
			// Request Body에 Data 셋팅.
			os.write(body.getBytes("UTF-8"));
			// Request Body에 Data 입력.
			os.flush();
			// OutputStream 종료.
			os.close();
			// 응답 코드 받기.
			int responseCode = connection.getResponseCode();
				InputStreamReader isr = null;
			if (responseCode == HttpURLConnection.HTTP_OK)
				isr = new InputStreamReader(connection.getInputStream(), "UTF-8");
			else
				isr = new InputStreamReader(connection.getErrorStream(), "UTF-8");
			BufferedReader br = new BufferedReader(isr);
			String s = "";
			String response = "";
			while ((s = br.readLine()) != null) {
				// 서버응답 받음
				response += s;
			}
			System.out.println(response);
			// 접속해지
			connection.disconnect();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (Throwable e) {
			e.printStackTrace();
		}
	}
}
