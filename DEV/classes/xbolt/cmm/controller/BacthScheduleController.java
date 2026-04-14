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
public class BacthScheduleController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;
	
	private final Log _log = LogFactory.getLog(this.getClass());
	
	public void BatchMailImpSchdl() throws Exception {  
		//System.out.println("실행");
		HashMap setMeilData = new HashMap();
		Map setdata = new HashMap();
		String sharers = "";
		String Subject = "";
		
		Map receiverMap = new HashMap();
		List receiverList = new ArrayList();
		String language = GlobalVal.DEFAULT_LANGUAGE;

		setdata.put("LOGIN_ID", "skyi");
		setdata.put("IS_CHECK", "N");
		setdata.put("LANGUAGE", language);	
		Map loginInfo = commonService.select("login_SQL.login_select", setdata);
				
		List scheduleIdList = commonService.selectList("schedule_SQL.getImpendingSchdlList",setdata);
		
		for(int i=0; i<scheduleIdList.size(); i++) {
			receiverMap = new HashMap();
			receiverList = new ArrayList();
			
			setdata = (HashMap) scheduleIdList.get(i);
			setdata.put("languageID", language);
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
				Map setMailMapRst = (Map)setEmailBatchLog(loginInfo, commonService, setMailData, "SCHDLALM");
				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
				mailMap.put("mailSubject", "OLM Schedule Alarm - "+ Subject);
				
				setMeilData.put("languageID", language);
				setdata.put("emailCode", "SCHDL");
				String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", setdata));
				setMeilData.put("emailHTMLForm", emailHTMLForm);
				
				HashMap cmmMap = new HashMap();
				cmmMap.put("languageID", language);
				
				Map resultMailMap = EmailUtil.sendMail(mailMap, setMeilData, getLabel(cmmMap, commonService));
			}
		}
		
	}
	
    public Map setEmailBatchLog(Map loginInfo, CommonService commonService, Map cmmMap, String dicTypeCode) throws Exception{
		
		HashMap resultMap = new HashMap();		

		if( StringUtil.checkNull(GlobalVal.USE_EMAIL).equals("Y")){
			Map mMailInfo = new HashMap();
			mMailInfo.put("dicTypeCode", dicTypeCode);
			try{
				Map setMap = new HashMap();
				List receiverList = (List)cmmMap.get("receiverList");
				//보내는 사람
				String sendUserID= StringUtil.checkNull(loginInfo.get("sessionUserId"));
				setMap.put("userID", sendUserID);
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
	
}
