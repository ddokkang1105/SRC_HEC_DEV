package xbolt.custom.sk.skon;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

import org.apache.ibatis.session.SqlSession;

@Controller
public class SKONBatchActionController {    
    
	@Resource(name = "commonService")
	private CommonService commonService;
	
	// 반영 시 주석해제
	//@Resource(name="orclSession")
	//private SqlSession orclSession;
	
	private final Log _log = LogFactory.getLog(this.getClass());
	
	public void zSKON_sendMailBatch() throws Exception {  
		
		System.out.println("90일 미접속 사용자 배치 메일 전송");
		
		try{
			
			String languageID = GlobalVal.DEFAULT_LANGUAGE;
			Map setdata = new HashMap();
			setdata.put("languageID", languageID);	
			
			String BatchYN = "Y";
			
			// 배치 메일 테이블에서 메일 정보 출력
			String emailCode = "ESPMAIL012";
			List mailList = commonService.selectList("zSK_SQL.getBatchMail", setdata);
			
		    if(mailList != null && mailList.size() > 0){
		    	for(int i=0; i < mailList.size(); i++){
		    		HashMap mailMap = (HashMap) mailList.get(i);
		    		// 메일 전송
		    		BatchMail(mailMap, emailCode, BatchYN);
		    	}
		    }
		    
		    // 배치 메일 테이블 삭제
		    commonService.delete("zSK_SQL.truncateBatchMail", setdata);
		    
		} catch (Exception e) {
			System.out.println("SKONBatchActionController ::: zSK_sendMailBatch " + e);
		}
		
	    // Batch Log Insert
		System.out.println("배치 메일 전송 완료");
		
	}
	
	// 배치 메일 발송
	public void BatchMail( HashMap map, String emailCode, String BatchYN ) throws Exception {  
		try {
			
			// 01. lang
			String languageID = GlobalVal.DEFAULT_LANGUAGE;
			
			// 03. receiver 셋팅
			List receiverList = new ArrayList();
			
			// Batch Mail
			String receiptUserList = StringUtil.checkNull(map.get("Receiver"));
			if(!"".equals(receiptUserList)){
				String[] receiptUsers = receiptUserList.split(";");
				for (int i = 0; i < receiptUsers.length; i++) {
					Map receiverMap = new HashMap();
					receiverMap.put("receiptUserID", receiptUsers[i]);
				    receiverList.add(i, receiverMap);
				}
			};
			
			// 04. 메일 셋팅
			map.put("EMAILCODE", emailCode);
			map.put("receiverList", receiverList);
			
			// 05. 메일 로그 및 전송
			if(receiverList.size() > 0){
				
				// 06. 메일 로그
				
				map.put("loginID", "paladm2025");
				Map setMailMapRst = (Map)setBatchEmailLog(commonService, map, emailCode);
				System.out.println("setMailMapRst : "+setMailMapRst );
				
				if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
					
					// mail 송,수신자 정보 
					HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
					
					String mailSubject = StringUtil.checkNull(map.get("Subject"));
					String Body = StringUtil.checkNull(map.get("Body"));
					
					mailMap.put("mailSubject", mailSubject);
					map.put("emailHTMLForm", Body);
				
					//	메일안에 들어갈 내용 정보
					map.put("emailCode", "ESPMAIL012");
					map.put("languageID", languageID);
					
					// [07] 메일 보내기
					Map menu = getBatchLabel(commonService, languageID); //getLabel(request, commonService)
					Map resultMailMap = EmailUtil.sendMail(mailMap, map, menu);
					System.out.println("SEND EMAIL TYPE:"+resultMailMap+ "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
					
				}else{
					System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
				}
			}
		} catch (Exception e) {
			System.out.println("SKONBatchActionController ::: " + e);
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
					mMailInfo.put("EmailCode", "BATCH");
					
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
	
	public void zSKON_IF_ODS() throws Exception {  
		
		System.out.println("ODS IF Start");
		
		try{
			
			// CMM
			String languageID = GlobalVal.DEFAULT_LANGUAGE;
			Map setMap = new HashMap();
			setMap.put("languageID", languageID);	
			setMap.put("SYSTEM_NM", "GSDM");
			setMap.put("SYSTEM", "GSDM");
			
			
			// 반영 시 주석해제
			/*
			List MenuList = commonService.selectList("zSK_SQL.getBatchMenuList", setMap);
			
			for (int i = 0; i < MenuList.size(); i++) {
			    Map menuItem = (Map) MenuList.get(i);
			    String menuMaxSeq = StringUtil.checkNull(orclSession.selectOne("sk_ORASQL.zSK_getNextSeqforMenuList", setMap));
				setMap.put("SEQ", menuMaxSeq);
			    setMap.put("MENU_NM", StringUtil.checkNull(menuItem.get("MENU_NM")));
			    setMap.put("USE_YN", StringUtil.checkNull(menuItem.get("USE_YN")));
			    setMap.put("REG_DT", StringUtil.checkNull(menuItem.get("REG_DT")));
			    orclSession.insert("sk_ORASQL.zSK_insertMenuList", setMap);
			}
			

			List UserStatList = commonService.selectList("zSK_SQL.getBatchUserStatus", setMap);
			
			for (int i = 0; i < UserStatList.size(); i++) {
			    Map userItem = (Map) UserStatList.get(i);
			    String UserMaxSeq = StringUtil.checkNull(orclSession.selectOne("sk_ORASQL.zSK_getNextSeqforUserList", setMap));
				setMap.put("SEQ", UserMaxSeq);
			    setMap.put("EMPLOYEE_NUM", StringUtil.checkNull(userItem.get("EMPLOYEE_NUM")));
			    setMap.put("USE_YN", StringUtil.checkNull(userItem.get("USE_YN")));
			    setMap.put("LAST_EVENT_DT", StringUtil.checkNull(userItem.get("LAST_EVENT_DT")));
			    orclSession.insert("sk_ORASQL.zSK_insertUserStatus", setMap);
			}
			
			
			
			List UserConnList = commonService.selectList("zSK_SQL.getBatchUserConnChk", setMap);
			for (int i = 0; i < UserConnList.size(); i++) {
			    Map userConnItem = (Map) UserConnList.get(i);
			    setMap.put("EMPLOYEE_NUM", StringUtil.checkNull(userConnItem.get("EMPLOYEE_NUM")));
			    setMap.put("NAME", StringUtil.checkNull(userConnItem.get("NAME")));
			    setMap.put("DEPARTMENT", StringUtil.checkNull(userConnItem.get("DEPARTMENT")));
			    setMap.put("LOGIN_DT", StringUtil.checkNull(userConnItem.get("LOGIN_DT")));
			    orclSession.insert("sk_ORASQL.zSK_insertUserConnChk", setMap);
			}

			
			List MenuConnList = commonService.selectList("zSK_SQL.getBatchMenuConnLog", setMap);
			for (int i = 0; i < MenuConnList.size(); i++) {
			    Map menuConnItem = (Map) MenuConnList.get(i);
			    setMap.put("REGID", StringUtil.checkNull(menuConnItem.get("REGID")));
			    setMap.put("MENUNM", StringUtil.checkNull(menuConnItem.get("MENUNM")));
			    setMap.put("MENUID", StringUtil.checkNull(menuConnItem.get("MENUID")));
			    setMap.put("REG_DT", StringUtil.checkNull(menuConnItem.get("REG_DT")));
			    orclSession.insert("sk_ORASQL.zSK_insertMenuConnLog", setMap);
			}
		    */
			
			
		} catch (Exception e) {
			System.out.println("SKONBatchActionController ::: zSK_IF_ODS " + e);
		}
		
	    // Batch Log Insert
		System.out.println("ODS 완료");
		
	}
	
	
}
	
