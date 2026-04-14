package xbolt.custom.daelim.itsm ;


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
public class DLMBatchActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;
	
	private final Log _log = LogFactory.getLog(this.getClass());

	
	//<!-- 20250424 CTI 콜이력 가져오기 시작 -->
	// TODO : 주석해제해서 패치
	//@Resource(name="xsqlSession")
	//private SqlSession xsqlSession;

	public void zDlm_CtiBatch() throws Exception {  
		
		//System.out.println("CTI CDR 연계 배치 시작");
		
		System.out.println("=== zDlm_CtiBatch 실행 === [" + this + "] " + new SimpleDateFormat("HH:mm:ss.SSS").format(new Date()));

		
		Map setMap = new HashMap();
		
		try{
			
			//String languageID = GlobalVal.DEFAULT_LANGUAGE;
			//Map setdata = new HashMap();
			//setdata.put("languageID", languageID);	
			
			//Date today = new Date();
			Calendar calendar = Calendar.getInstance();
			// 하루 빼서 어제 날짜로 설정
			calendar.add(Calendar.DATE, -1);

			//System.out.println("=========> zDlm_CtiBatch 1");

			SimpleDateFormat yyyyMM = new SimpleDateFormat("yyyyMM");
			SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyyMMdd");

			// calendar.getTime()으로 Date 객체를 가져와서 format에 사용
			setMap.put("yyyyMM", yyyyMM.format(calendar.getTime()));
			setMap.put("yyyyMMdd", yyyyMMdd.format(calendar.getTime()));
			
			//System.out.println("=========> zDlm_CtiBatch 2 : " + setMap);
			
			// TODO : 주석해제해서 패치
			/*
			List<Map<String, Object>> cti = xsqlSession.selectList("daelim_SQL.zDLM_CTI_CDR_LIST", setMap);

			if (cti != null && !cti.isEmpty()) {
			    
			    // 50개씩 잘라서 나누기
			    List<List<Map<String, Object>>> partitioned = partitionList(cti, 50);

			    for (List<Map<String, Object>> subList : partitioned) {
			        Map<String, Object> paramMap = new HashMap<>();
			        paramMap.put("list", subList); // "list"는 매퍼 XML에서 사용하는 이름과 일치해야 함
			        commonService.insert("zDLM_SQL.InsertCtiCdrList", paramMap);
			    }

			    System.out.println("=========> zDlm_CtiBatch total : " + cti.size() + "건 처리 완료 (" + partitioned.size() + "회)");
			}
			 */
		} catch (Exception e) {
			System.out.println("CTI CDR 연계 배치 오류");
			System.out.println("DLMBatchActionController ::: zDlm_CtiBatch " + e);
		}
		
	    // Batch Log Insert
		System.out.println("CTI CDR 연계 배치 종료");
		
	}
	
	public static <T> List<List<T>> partitionList(List<T> list, int size) {
	    List<List<T>> partitions = new ArrayList<>();
	    for (int i = 0; i < list.size(); i += size) {
	        partitions.add(list.subList(i, Math.min(i + size, list.size())));
	    }
	    return partitions;
	}
	//<!-- 20250424 CTI 콜이력 가져오기 끝 -->
	
	
	
	public void zDlm_sendMailBatch() throws Exception {  
		
		System.out.println("배치 메일 전송");
		
		try{
			
			String languageID = GlobalVal.DEFAULT_LANGUAGE;
			Map setdata = new HashMap();
			setdata.put("languageID", languageID);	
			
			String BatchYN = "Y";
			
			// 배치 메일 테이블에서 메일 정보 출력
			List mailList = commonService.selectList("zDLM_SQL.getBatchMail", setdata);
			
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
		    commonService.delete("zDLM_SQL.truncateBatchMail", setdata);
		    
			
		} catch (Exception e) {
			System.out.println("DLMBatchActionController ::: zDlm_sendMailBatch " + e);
		}
		
	    // Batch Log Insert
		System.out.println("배치 메일 전송 완료");
		
	}
	
	public void PC_DELAY_TICKET_NEW() throws Exception {  
		
		// Report Code : ZDLM005
		System.out.println("(고객테스트)단계 점프 14일 배치 실행");
		
		String languageID = GlobalVal.DEFAULT_LANGUAGE;
		Map setdata = new HashMap();
		setdata.put("languageID", languageID);	
		
		// 메일 폼
		String emailCode = "ESPMAIL011";
		String BatchYN = "N";
		
		// 고객테스트 지연 티켓 조회 ( ACM / ICM / SCM Only )
		// SRAT0024 ( 고객테스트 완료 요청일 )
		List srList = commonService.selectList("zDLM_SQL.getDelayBatch", setdata);
	    if(srList != null && srList.size() > 0){
	    	for(int i=0; i < srList.size(); i++){
	    		HashMap srMap = (HashMap) srList.get(i);
	    		srMap.put("languageID", languageID);
	    		srMap.put("emailCode", emailCode);
	    		srMap.put("docCategory", "SR");
	    		
	    		String srID = StringUtil.checkNull(srMap.get("SRID"));
	    		srMap.put("srID", srID);
	    		Map srInfoMap =  commonService.select("esm_SQL.getESMSRInfo", srMap);
	    		srMap.putAll(srInfoMap);
	    		
	    		// batch attr 업데이트
	    		BatchAttrUpdate(srMap);
	    		
	    		// batch 업데이트
	    		BatchUpdateNextStatus(srMap);
	    		
	    		// 메일 전송
	    		//BatchMail(srMap, emailCode, BatchYN);
	    		
	    		// push 전송
	    		//BatchPush(srMap);
	    	}
	    }
	    
	    // Batch Log Insert
	    
	    
		System.out.println("예정완료일/승인요청완료일 지연 건 메일 발송 배치 완료");
	}
	
	// 배치 티켓 ATTR 업데이트
	public void BatchAttrUpdate ( HashMap srMap )throws Exception {
		
		// ATTR을 강제로 업데이트한다.
		
		String srID = StringUtil.checkNull(srMap.get("SRID"));
		String srType = StringUtil.checkNull(srMap.get("SRType"));
		String speCode = StringUtil.checkNull(srMap.get("Status"));
		
		srMap.put("srID", srID);
		srMap.put("srType",srType);
		srMap.put("speCode",speCode);
		srMap.put("userID","1"); // 관리자
		
		List<Map<String, String>> attrList = new ArrayList();
		
		// [ ACM ]
		if("ACM".equals(srType)){
			attrList.add(createAttr("SRAT0027", "01")); //데이터 정확성 - 매우만족
		    attrList.add(createAttr("SRAT0028", "01")); //시스템 응답속도 - 매우만족
		    attrList.add(createAttr("SRAT0029", "01")); //UI 편의성 - 매우만족
		    attrList.add(createAttr("SRAT0026", "01")); //요구사항 적합성 (AP) - 매우만족
		    attrList.add(createAttr("SRAT0030", "[시스템]14일이 지나 고객테스트 단계가 자동 진행 되었습니다.")); //고객의견
		    attrList.add(createAttr("SRAT0097", "01"));//보완요청 - 아니오
		} else {
			attrList.add(createAttr("SRAT0028", "01")); //시스템 응답속도 - 매우만족
		    attrList.add(createAttr("SRAT0064", "01")); //요구사항 적합성 -  그렇다
		    attrList.add(createAttr("SRAT0065", "01")); // 시스템 무결점성 - 그렇다
		    attrList.add(createAttr("SRAT0067", "테스트의견 - [시스템]14일이 지나 사전 배포 단계가 자동 진행 되었습니다."));
		}
		
		
		for (Map<String, String> entry : attrList) {
		    for (Map.Entry<String, String> e : entry.entrySet()) {
		    	String attrTypeCode = StringUtil.checkNull(e.getKey());
		    	String value = StringUtil.checkNull(e.getValue());
		    	if(!"".equals(attrTypeCode)){
		    		srMap.put("attrTypeCode", attrTypeCode);
		    		srMap.put("value", value);
		    		if(!"SRAT0030".equals(attrTypeCode) && !"SRAT0067".equals(attrTypeCode)){
		    			srMap.put("lovCode", value);
		    		}
		    		// 기존에 존재하는 ATTR 삭제
		    		commonService.delete("esm_SQL.deleteSRAttr", srMap);
		    		// 신규 추가
		    		commonService.insert("esm_SQL.insertSRAttr", srMap);
		    	}
		    }
		}
	}
	
	private Map<String, String> createAttr(String key, String value) {
	    Map<String, String> map = new HashMap<>();
	    map.put(key, value);
	    return map;
	}
	
	
	// 배치 티켓 업데이트
	public void BatchUpdateNextStatus ( HashMap srMap )throws Exception {
		
		// 조회에 필요한 정보 setting
		String srType = StringUtil.checkNull(srMap.get("SRType"));
		String srID = StringUtil.checkNull(srMap.get("SRID"));
		
		String speCode = StringUtil.checkNull(srMap.get("Status"));
		srMap.put("speCode", speCode);
		Map param = ESPUtil.getStatusParams(commonService, srMap);
		srMap.putAll(param);
		
		// NEXT 단계 가져오기
		if("ACM".equals(srType)) srMap.put("resultParameter","01");
		Map nextSpeMap = getBatchNextSpeCode(commonService, srMap);
		String nextSpeCode = StringUtil.checkNull(nextSpeMap.get("speCode"));
		String nextSortNum = StringUtil.checkNull(nextSpeMap.get("nextSortNum"));
		
		srMap.put("status", nextSpeCode);
		srMap.put("sortNum", nextSortNum);
		
		String nextPgrVarfilter = StringUtil.checkNull(nextSpeMap.get("nextPgrVarfilter"));
		Map NextParam = ESPUtil.getQueryParams(nextPgrVarfilter);
		
		// procRoleTP 예외 체크
		String procRoleTP = StringUtil.checkNull(commonService.selectString("esm_SQL.getESPProcRoleTP",srMap)); // next procRoleTP 예외처리 체크
		// * 예외 없을 경우 다음단계의 input의 procRoleTP 체크 후 업데이트 
		if("".equals(procRoleTP)){
			procRoleTP = StringUtil.checkNull(NextParam.get("procRoleTP")); // procRoleTP가 없을 시 CLIENT
		}
		srMap.put("procRoleTP", procRoleTP);
		
		// procRoleTP 가 'CLIENT' 일 경우 요청자 = receiptUser
		if("CLIENT".equals(procRoleTP)){
			srMap.put("receiptUserID",StringUtil.checkNull(srMap.get("requestUserID")));
			srMap.put("receiptTeamID",StringUtil.checkNull(srMap.get("requestTeamID")));
		}
		
		// update sr mst
		commonService.update("esm_SQL.updateESMSR", srMap);
		
		// next의 emailCode 확인
		String nextEmailCode = StringUtil.checkNull(NextParam.get("nextEmailCode"));
		if(!"".equals(nextEmailCode)) {
			// 메일&push 현상태 발송
			srMap.put("emailCode", nextEmailCode);
			String BatchYN = "N";
			BatchMail(srMap,"nextEmailCode",BatchYN);
		}

		// 단계 진행 시 무조건 receiver 삭제
		if((!"CLIENT".equals(procRoleTP))){
			commonService.update("esm_SQL.deleteReceiptUser", srMap);
			srMap.remove("receiptUserID");
			srMap.remove("receiptTeamID");
        } 
		
		// * Next 진행상태 log 추가 [default : 접수 전]
		Map setMap = new HashMap();
		setMap.put("srID", srID);
		setMap.put("status", nextSpeCode);
		String maxSeq = StringUtil.checkNull(commonService.selectString("esm_SQL.getSeqActivityLog", setMap),"0");
		
		setMap.put("SRType",srType);
		setMap.put("SpeCode", nextSpeCode);
		setMap.put("Status", "00");
		setMap.put("PID", srID);
		setMap.put("DocumentID", srID);
		setMap.put("SortNum", nextSortNum);
		setMap.put("Blocked", "0");
		setMap.put("Seq", maxSeq);
		setMap.put("ProcRoleTP", procRoleTP);
		setMap.put("DocCategory", "SR");
		commonService.insert("esm_SQL.insertActivityLog", setMap);
		
		// * 기존 status log 완료처리
		Map logMap = new HashMap();
		logMap.put("TeamID", "2768");					
		logMap.put("ActorID", "1");
		logMap.put("PID", srID);
		logMap.put("SpeCode", speCode);
		logMap.put("Status", "05");
		logMap.put("Blocked", "1");
		logMap.put("EndTime", DateUtil.getCurrentTime("yyyy-MM-dd HH:mm:ss"));
		logMap.put("maxSeq", "Y");
		commonService.update("esm_SQL.updateActivityLog", logMap);
		
	}
	
	// Status 분기처리 후 Next 값 가져오기
	private Map getBatchNextSpeCode(CommonService commonService, Map map) throws Exception {
		
		Map nextSpeMap = new HashMap();
		String speCode = "";
		String nextSortNum = "";
		
		try {
			Map setMap = new HashMap();
			
			String srID = StringUtil.checkNull(map.get("srID"));
			setMap.put("srID",srID);
			
			String languageID = StringUtil.checkNull(map.get("languageID"));
			setMap.put("languageID",languageID);
			
			// 현재 status 구하기
			String status = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRStatus", setMap));
			setMap.put("status", status);
			// 현재 sortNum 구하기
			String sortNum = StringUtil.checkNull(commonService.selectString("esm_SQL.getESPStatusSortNum", setMap));
			setMap.put("sortNum", sortNum);
			
			// return paramter 구하기 
			String actionParameter = StringUtil.checkNull(map.get("actionParameter")); // ex : wfInstanceID
			String actionValue = "";
			
			if(!"".equals(actionParameter)){
				actionValue = StringUtil.checkNull(map.get(actionParameter));
			} else {
				actionValue = StringUtil.checkNull(map.get("resultParameter"));
			}
			// 분기 결정 값 setting
			setMap.put("resultParameter",actionValue);
			
			// 결과 값 조회
			setMap.put("rulePass", "N");
			List nextStatusList = commonService.selectList("esm_SQL.getESPNextEventList",setMap);
			if(nextStatusList.size() > 0 && !nextStatusList.isEmpty()){
				Map nextMap = (Map) nextStatusList.get(0);
				speCode = StringUtil.checkNull(nextMap.get("SRNextStatus"),"");
				nextSpeMap.put("speCode", speCode);
				nextSortNum = StringUtil.checkNull(nextMap.get("NextSortNum"),"");
				nextSpeMap.put("nextSortNum", nextSortNum);
				String nextPgrVarfilter = StringUtil.checkNull(nextMap.get("SRNextSpePgrVarFilter"),"");
				nextSpeMap.put("nextPgrVarfilter", nextPgrVarfilter);
			}
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextSpeMap;
	}
	
	// 배치 Push 발송
	public void BatchPush ( HashMap srMap )throws Exception {
		
		srMap.put("type","PUSH");
		List pushReceiverList = commonService.selectList("esm_SQL.getSREmailReceiverList", srMap);
		if(pushReceiverList.size() > 0){
			
			String srCode = StringUtil.checkNull(srMap.get("SRCode"));
			String subject = StringUtil.checkNull(srMap.get("Subject"));
			String emailCode = StringUtil.checkNull(srMap.get("emailCode"));
			
			for(int i=0; i < pushReceiverList.size(); i++){
				Map pushMap = (Map) pushReceiverList.get(i);
				HashMap tmpMap = new HashMap();
				tmpMap.put("RecvEmpNo",pushMap.get("receiptUserLoginID")); // LoginID
				tmpMap.put("RecvInfo",pushMap.get("receiptTelNum")); // Tel
				tmpMap.put("RecvEmpName",pushMap.get("receiptUserName")); // Name
				tmpMap.put("RecvDeptName",pushMap.get("receiptTeamName")); // Dept Name
				tmpMap.put("subject",subject);
				tmpMap.put("srCode",srCode);
				tmpMap.put("EmailCode",emailCode);
				tmpMap.put("CompanyCode",pushMap.get("receiptTeamCode")); // Company Code
				DLMCmmActionController.zdlm_sendPush(tmpMap, commonService);
				
				String maxId = StringUtil.checkNull(commonService.selectString("email_SQL.emailLog_nextVal", srMap)).trim();
				tmpMap.put("EmailCode", "PUSH");
				tmpMap.put("Receiver", pushMap.get("receiptTelNum"));
				tmpMap.put("Sender", DaelimGlobalVal.DLM_PUSH_senderName);
				tmpMap.put("SEQ", maxId);
				commonService.insert("email_SQL.insertEmailLog", tmpMap);
			}
		}
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
			System.out.println("DLMBatchActionController ::: " + e);
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
