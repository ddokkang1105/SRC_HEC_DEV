package xbolt.custom.youngone.web ;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.app.esp.main.util.ESPUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.daelim.cmm.DLMCmmActionController;
import xbolt.custom.daelim.val.DaelimGlobalVal;


//<!-- 20250424 CTI 콜이력 가져오기 시작 -->
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import org.apache.ibatis.session.SqlSession;
//<!-- 20250424 CTI 콜이력 가져오기 끝 -->

/**
 * 공통 서블릿 처리
 * @Class Name : CmmActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @since 2024. 12. 13. smartfactory		최초생성
 *
 * @since 2024. 12. 13.
 * @version 1.0
 * @see
 * 
 * Copyright (C) 2024 by SMARTFACTORY All right reserved.
 */

@Controller
@SuppressWarnings("unchecked")
public class YoungOneBatchActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;
	
	private final Log _log = LogFactory.getLog(this.getClass());

	
	public void zYOH_sendMailBatch() throws Exception {  
		
		System.out.println("배치 메일 전송");
		
		try{
			
			String languageID = GlobalVal.DEFAULT_LANGUAGE;
			Map setdata = new HashMap();
			setdata.put("languageID", languageID);	
			
			String BatchYN = "Y";
			
			// 배치 메일 테이블에서 메일 정보 출력
			List mailList = commonService.selectList("esmReport_SQL.getBatchMail", setdata);
			
			// 메일 폼
			String emailCode = "ESPMAIL012";
		    if(mailList != null && mailList.size() > 0){
		    	for(int i=0; i < mailList.size(); i++){
		    		HashMap mailMap = (HashMap) mailList.get(i);
		    		// 메일 전송
		    		BatchMail(mailMap, emailCode, BatchYN);
		    	}
		    }
		    
		    // 배치 메일 테이블 삭제
		    commonService.delete("esmReport_SQL.truncateBatchMail", setdata);
		    
			
		} catch (Exception e) {
			System.out.println("YoungOneBatchActionController ::: zYOH_sendMailBatch " + e);
		}
		
	    // Batch Log Insert
		System.out.println("배치 메일 전송 완료");
		
	}
	
	// 배치 메일 발송
	public void BatchMail( HashMap srMap, String emailCode, String BatchYN ) throws Exception {  
		try {
			
			// 01. lang
			String languageID = GlobalVal.DEFAULT_LANGUAGE;
			
			// 03. receiver 셋팅
			List receiverList = new ArrayList();
			
			if(!"Y".equals(BatchYN)){
				String status = StringUtil.checkNull(srMap.get("SRStatusName"));
				String subject = StringUtil.checkNull(srMap.get("Subject")); // sr 제목
				subject = "(" + status + ")" + subject; // 메일 제목 가공 
				srMap.put("subject", subject);
				
				// 요청자에게 전송
				String receiptUserID = StringUtil.checkNull(srMap.get("RequestUserID"));
				if(!"".equals(receiptUserID)){
					Map receiverMap = new HashMap();
					receiverMap.put("receiptUserID", receiptUserID);
					receiverList.add(0,receiverMap);
				};
			} else {
				// Batch Mail
				String receiptUserList = StringUtil.checkNull(srMap.get("Receiver"));
				String ccUserIDList = StringUtil.checkNull(srMap.get("CC"));
				if(!"".equals(receiptUserList)){
					String[] receiptUsers = receiptUserList.split(";");
					for (int i = 0; i < receiptUsers.length; i++) {
						Map receiverMap = new HashMap();
						receiverMap.put("receiptUserID", receiptUsers[i]);
					    receiverList.add(i, receiverMap);
					}
				};
				if(!"".equals(ccUserIDList)){
					String[] ccUsers = ccUserIDList.split(";");
					for (int i = 0; i < ccUsers.length; i++) {
						Map receiverMap = new HashMap();
						receiverMap.put("receiptUserID", ccUsers[i]);
						receiverMap.put("receiptType", "CC");
					    receiverList.add(i, receiverMap);
					}
				};
			}
			
			// 04. 메일 셋팅
			srMap.put("EMAILCODE", emailCode);
			srMap.put("receiverList", receiverList);
			
			// 05. 메일 로그 및 전송
			if(receiverList.size() > 0){
				
				// 06. 메일 로그
				
				srMap.put("loginID", "sys");
				String documentID = StringUtil.checkNull(srMap.get("SRID"));
				if("".equals(documentID)) documentID = StringUtil.checkNull(srMap.get("DocumentID"));
				srMap.put("documentID", documentID);
				Map setMailMapRst = (Map)setBatchEmailLog(commonService, srMap, emailCode);
				System.out.println("setMailMapRst : "+setMailMapRst );
				
				if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
					
					// mail 송,수신자 정보 
					HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
					
					if("Y".equals(BatchYN)){
						// Batch Mail 정보 셋팅
						String emailSender = StringUtil.checkNull(srMap.get("SenderAcc"), GlobalVal.EMAIL_SENDER);
						String emailSenderName = StringUtil.checkNull(srMap.get("SenderName"), GlobalVal.EMAIL_SENDER_NAME);
						String emailSenderPwd = StringUtil.checkNull(srMap.get("SenderPwd"), GlobalVal.SMTP_ACCOUNT_PWD);
						String hostIP = StringUtil.checkNull(srMap.get("EmailSvrDomain"), GlobalVal.EMAIL_HOST_IP);
						String mailSubject = StringUtil.checkNull(srMap.get("Subject"));
						String Body = StringUtil.checkNull(srMap.get("Body"));
						
						mailMap.put("Sender", emailSender);
						mailMap.put("SenderName", emailSenderName);
						mailMap.put("SenderPwd", emailSenderPwd);
						mailMap.put("EmailSvrDomain", hostIP);
						mailMap.put("mailSubject", mailSubject);
						srMap.put("emailHTMLForm", Body);
					}
					
					//	메일안에 들어갈 내용 정보
					srMap.put("emailCode", emailCode);
					srMap.put("languageID", languageID);
					// 배치메일이 아닌 경우 emailHTMLForm을  db에서 가져옴
					if(!"Y".equals(BatchYN)){
						String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", srMap));
						srMap.put("emailHTMLForm", emailHTMLForm);
					}
					
					// [07] 메일 보내기
					Map menu = getBatchLabel(commonService, languageID); //getLabel(request, commonService)
					Map resultMailMap = EmailUtil.sendMail(mailMap, srMap, menu);
					System.out.println("SEND EMAIL TYPE:"+resultMailMap+ "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
					
				}else{
					System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
				}
			}
		} catch (Exception e) {
			System.out.println("YoungOneBatchActionController ::: " + e);
		}
	}
	
	
	// COMMON
	public static Map getBatchLabel(CommonService commonService, String languageID) throws Exception{
		HashMap cmmMap = new HashMap();
		HashMap getMap = new HashMap();
		cmmMap.put("languageID", languageID);
		cmmMap.put("mnCategory", "LN");
		List labelList = commonService.selectList("menu_SQL.menuName",cmmMap);
		
		cmmMap = new HashMap();
		for(int i = 0; i < labelList.size(); i++){
			cmmMap = (HashMap)labelList.get(i);
			getMap.put(cmmMap.get("TypeCode"), cmmMap.get("Name"));
		}
		
		return getMap;
	}
	
	public Map setBatchEmailLog(CommonService commonService, Map cmmMap, String dicTypeCode) throws Exception{
		
		HashMap resultMap = new HashMap();		

		if( StringUtil.checkNull(GlobalVal.USE_EMAIL).equals("Y")){
			Map mMailInfo = new HashMap();
			mMailInfo.put("dicTypeCode", dicTypeCode);
			try{
				Map setMap = new HashMap();
				List receiverList = (List)cmmMap.get("receiverList");
				//보내는 사람
				String sendUserID= StringUtil.checkNull(cmmMap.get("loginID"));
				setMap.put("userID", sendUserID);
				
				// multi mail check
				String baseUrl = GlobalVal.EMAIL_TYPE;
				String sender = GlobalVal.EMAIL_SENDER;
				String senderName = GlobalVal.EMAIL_SENDER_NAME;
				String EmailSvrDomain = GlobalVal.EMAIL_HOST_IP;
				String senderPwd = GlobalVal.SMTP_ACCOUNT_PWD;
				
				if(receiverList.size()>0 && !sender.equals("")){
					Map setDicMap = new HashMap();
					setDicMap.put("Category", "EMAILCODE");
					setDicMap.put("TypeCode", dicTypeCode);
					setDicMap.put("LanguageID", StringUtil.checkNull(cmmMap.get("languageID")));
					List mailDtlList = new ArrayList();
					mailDtlList = commonService.selectList("common_SQL.label_commonSelect",setDicMap);
					String mailSubject="";
					for(int i=0; i<mailDtlList.size(); i++){
						mailSubject = StringUtil.checkNull(((HashMap)mailDtlList.get(i)).get("LABEL_NM")); break;
					}
					//String subject = StringUtil.checkNull(cmmMap.get("subject"));
					mMailInfo.put("mailSubject", mailSubject);
					///insert emailLog
					String maxId = null;
					List receiverInfoList = new ArrayList();
					Map receiverInfoMap = new HashMap();
					Map receiverListMap = new HashMap();
					String receiptEmail = null;
					
					mMailInfo.put("Sender", sender);					
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
						mMailInfo.put("documentID", StringUtil.checkNull(cmmMap.get("documentID")));
						commonService.insert("email_SQL.insertEmailLog", mMailInfo);
					}
					
					mMailInfo.put("receiverInfoList", receiverInfoList);
					mMailInfo.put("sendUserID", sendUserID);	
					
					resultMap.put("type", "SUCESS");
					resultMap.put("mailLog", mMailInfo);
				}else{
					resultMap.put("type", "FAILE");
					resultMap.put("msg", "not exists email address : emailSender="+sender+", receiverList.Size="+receiverList.size());
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


	
	
	
	
	
	
	
	
	
	
	
}
