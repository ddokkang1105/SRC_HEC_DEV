package xbolt.custom.hanwha.cmm;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.HtmlEmail;

import xbolt.cmm.framework.util.MakeEmailContents;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.hanwha.mail.neo.branch.ss.common.vo.WsAttachFile;
import xbolt.custom.hanwha.mail.neo.branch.ss.mail.service.MailServiceProxy;
import xbolt.custom.hanwha.mail.neo.branch.ss.mail.vo.WsMailInfo;
import xbolt.custom.hanwha.mail.neo.branch.ss.mail.vo.WsRecipient;

/** 
 * HANWHA EAMIL 처리
 * @Class Name : EmailHanwha.java
 * @Description : HANWHA EAMIL 처리 관련 함수 
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2016. 05. 03. smartfactory		최초생성
 *
 * @since 2017. 11. 16.
 * @version 1.0
 * @see
 * 
 * Copyright (C) 2017 by SMARTFACTORY All right reserved.
 */
@SuppressWarnings("unused")
public class EmailUtil {	
	
	public static Map sendMail(HashMap cmmEmailMap, HashMap cmmCnts, Map menu) throws Exception {
		Map returnMap = new HashMap();
		try {
			String baseUrl = GlobalVal.EMAIL_TYPE;
			String languageID = StringUtil.checkNull(cmmEmailMap.get("languageID"));
			String mailBody ="";
			if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SRREQ")){
				mailBody = MakeEmailContents.makeHTML_SRREQ(cmmCnts, menu);					
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("CSRAPREQ")){
				 mailBody = MakeEmailContents.makeHTML_CSRAPREQ(cmmCnts, menu);
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SRMRV")){
				mailBody = MakeEmailContents.makeHTML_SRREQ(cmmCnts, menu); 
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("APRVCLS")){
				mailBody = MakeEmailContents.makeHTML_APRVCLS(cmmCnts, menu);  
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("APRVRJT")){
				mailBody = MakeEmailContents.makeHTML_APRVRJT(cmmCnts, menu);  
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("APRVREF")){
				 mailBody = MakeEmailContents.makeHTML_CSRAPREQ(cmmCnts, menu);
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("BRDMAIL")){
				mailBody = MakeEmailContents.makeHTML_BRDMAIL(cmmCnts, menu); 
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SRTRP")){
				mailBody = MakeEmailContents.makeHTML_SRREQ(cmmCnts, menu); 
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("SRCMP")){
				mailBody = MakeEmailContents.makeHTML_SRCMP(cmmCnts, menu);
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("CRRCV")){
				mailBody = MakeEmailContents.makeHTML_CRRCV(cmmCnts, menu);
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("CSRCLS")){			
				mailBody = MakeEmailContents.makeHTML_APREQ_CSR(cmmCnts, languageID, menu);	
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("TERMREG")){			
				mailBody = MakeEmailContents.makeHTML_TERMREG(cmmCnts, menu);
			} else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("TERMREL")){			
				mailBody = MakeEmailContents.makeHTML_TERMREL(cmmCnts, menu);				
			}else if(StringUtil.checkNull(cmmEmailMap.get("dicTypeCode")).equals("PROPS") && baseUrl.equals("hanwha")){			
				mailBody = MakeEmailContents.makeHTML_SRPROPOSAL(cmmCnts, languageID, menu);
			}				
			returnMap = sendHanwhaEmail(cmmEmailMap,mailBody);
			
		}
		catch(Exception e) {
			System.out.println(e.toString());
		}
		return returnMap;
	}
	
	private static Map sendHanwhaEmail(HashMap cmmEmailMap, String mailBody) throws Exception {
		Map returnMap = new HashMap();
		String emailSender = GlobalVal.EMAIL_SENDER;
		
		boolean mhtContent=false;
		WsMailInfo mailInfo = new WsMailInfo();
		mailInfo.setAttachCount(0);
		mailInfo.setHtmlContent(true);
		mailInfo.setImportant(false);
		mailInfo.setMhtContent(false);
		mailInfo.setSenderEmail(emailSender);
	//	mailInfo.setSenderEmail(StringUtil.checkNull(cmmEmailMap.get("Sender")));
		mailInfo.setSubject(StringUtil.checkNull(cmmEmailMap.get("mailSubject")));
		
		List receiverList = (List)cmmEmailMap.get("receiverInfoList");
				
		WsRecipient[] receivers = new WsRecipient[receiverList.size()]; // 수신자 COUNT		
		int seqID = 0;
		WsRecipient receiver = null;
		WsAttachFile[] attachFile = null;

		for(int i=0; i<receiverList.size(); i++){
			Map receiverListMap = (Map)receiverList.get(i);
			seqID = NumberUtil.getIntValue(StringUtil.checkNull(receiverListMap.get("seqID")));
			receiver = new WsRecipient();
			receiver.setDept(false); // 부서수신자 여부 
			receiver.setRecvEmail(StringUtil.checkNull(receiverListMap.get("receiptEmail"))); // 수신자 이메일주소 
			receiver.setSeqID(seqID); // 순번
			receiver.setRecvType(StringUtil.checkNull(receiverListMap.get("receiptType")).equals("CC") ? "CC" : "TO"); // 수신자 형태 : TO(수신)/CC(참조)/BCC(숨은참조)					
			receivers[i] = receiver;
		}
		try{		
			MailServiceProxy proxy = new MailServiceProxy();
			String emailResult = proxy.sendMISMail(mailBody, mailInfo, receivers, attachFile);
			System.out.println("SEND EMAIL SUCCES ::: "+emailResult);						
			returnMap.put("type", "SUCESS");
			returnMap.put("msg", emailResult); 
		}catch(Exception ex){
			returnMap.put("type", "FAILE");
			returnMap.put("msg", ex.getMessage());
			returnMap.put("msg2", ex.toString());
			System.out.println("SEND EMAIL FAILE ::: "+ex.getMessage());						
		}
		return returnMap;
	}		
}
