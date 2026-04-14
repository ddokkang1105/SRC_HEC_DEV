package xbolt.app.esm.scr.web;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.text.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.org.json.JSONArray;
import com.org.json.JSONObject;

import xbolt.app.esp.main.util.ESPUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;
/**
 * 업무 처리
 * 
 * @Class Name : SCRActionController.java
 * @Description : 업무화면을 제공한다.
 * @Modification Information
 * @수정일 수정자 수정내용
 * @--------- --------- -------------------------------
 * @2012. 09. 01. smartfactory 최초생성
 * 
 * @since 2012. 09. 01.
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")
public class SCRActionController extends XboltController {
	
	@Resource(name = "commonService")
	private CommonService commonService;
		
	@Resource(name = "scrService")
	private CommonService scrService;

	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;
	
	@RequestMapping(value = "/scrList.do")
	public String scrList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/scr/scrList";
		try {
				
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
				String mySCR = StringUtil.checkNull(request.getParameter("mySCR"),"");
				String scrMode = StringUtil.checkNull(request.getParameter("scrMode"),"");
				String finTestor = StringUtil.checkNull(request.getParameter("finTestor"),"");
			
				Map setMap = new HashMap();			
				model.put("mySCR", mySCR);
				model.put("scrMode", scrMode);
				model.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ITSP"));
				model.put("scrStatus", StringUtil.checkNull(request.getParameter("scrStatus")));
				model.put("reqDateLimit", StringUtil.checkNull(request.getParameter("reqDateLimit")));
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				
				model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
				model.put("finTestor", StringUtil.checkNull(cmmMap.get("finTestor")));
				
				Map scrMap = new HashMap();
				scrMap.put("languageID", languageID);
				scrMap.put("scrMode", scrMode);
				scrMap.put("mySCR", mySCR);
				scrMap.put("finTestor", finTestor);
				scrMap.put("loginUserId", cmmMap.get("sessionUserId"));
				
				List scrList = commonService.selectList("scr_SQL.getSCR_gridList",scrMap);
				JSONArray gridData = new JSONArray(scrList);
				model.put("gridData",gridData);
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/registerSCR.do")
	public String registerSCR(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/scr/registerSCR";
		try {
				Map setMap = new HashMap();
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType")); 
				String srID = StringUtil.checkNull(cmmMap.get("srID")); 		
			
				setMap.put("srID", srID);
				setMap.put("languageID", languageID);
				Map srInfo  = commonService.select("esm_SQL.getESMSRInfo", setMap);
				
				setMap.put("modelID", srInfo.get("ProcPathID"));
				
				List elmList = commonService.selectList("esm_SQL.procPathElmList", setMap);			
				
				// 시스템 날짜 
				Calendar cal = Calendar.getInstance();
				cal.setTime(new Date(System.currentTimeMillis()));
				String thisYmd = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
								
				model.put("thisYmd", thisYmd);
				model.put("srID", srID);
				model.put("srInfo", srInfo);				
				model.put("elmList", elmList);
				model.put("menu", getLabel(request, commonService)); //  Label Setting 	
				//Call PROC_LOG START TIME
				setInitProcLog(request);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/createSCRMst.do")
	public String createSCRMst(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
	
		try {
			HashMap setData = new HashMap();
			HashMap insertData = new HashMap();
			
			String emailCode = "SCRREQ" ;
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String planStartDT = StringUtil.checkNull(commandMap.get("planStartDT"));
			String planEndDT = StringUtil.checkNull(commandMap.get("planEndDT"));
			String planManDay = StringUtil.checkNull(commandMap.get("planManDay"));			
			String impAnalYN = StringUtil.checkNull(commandMap.get("impAnalYN"));
			String urgencyYN = StringUtil.checkNull(commandMap.get("urgencyYN"));
			String priority = StringUtil.checkNull(commandMap.get("priority"));
			String subject = StringUtil.checkNull(commandMap.get("subject"));
			String changeScope = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(commandMap.get("changeScope")));
			String jobDescription = StringUtil.checkNull(commandMap.get("jobDescription"));
			String scrIssue = StringUtil.checkNull(commandMap.get("scrIssue"));
			String cmYN = StringUtil.checkNull(commandMap.get("cmYN"));
			String finTestYN = StringUtil.checkNull(commandMap.get("finTestYN"));
			String CTRYN = StringUtil.checkNull(commandMap.get("CTRYN"));
			String scrArea1 = StringUtil.checkNull(commandMap.get("scrArea1"));
			String scrArea2 = StringUtil.checkNull(commandMap.get("scrArea2"));
			String newProcPathID = StringUtil.checkNull(commandMap.get("newProcPathID"));
			String fixedPath = StringUtil.checkNull(commandMap.get("fixedPath")); 
			String speCode = StringUtil.checkNull(commandMap.get("speCode"));
			String category = StringUtil.checkNull(commandMap.get("srCategory")); 
			String srType = StringUtil.checkNull(commandMap.get("srType")); 

			setData.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			setData.put("itemID", scrArea2);
			setData.put("roleType", "A");
			setData.put("assignmentType", "SRROLETP");
			String csrID = StringUtil.checkNull(commonService.selectString("item_SQL.getProjectIDFromItem", setData));
			String approverID = "";
			String aprvTeamID = "";
			Map aprvUserInfo = commonService.select("esm_SQL.getAprvUserInfo", setData);			
			if(!aprvUserInfo.isEmpty() && aprvUserInfo != null){
				approverID = StringUtil.checkNull(aprvUserInfo.get("MemberID"));
				aprvTeamID = StringUtil.checkNull(aprvUserInfo.get("TeamID"));
			} else {
				approverID = "1";
				setData.put("userID", "1");
				Map recTeamInfoMap = commonService.select("user_SQL.memberTeamInfo", setData);
				String teamID =  StringUtil.checkNull(recTeamInfoMap.get("TeamID"));
				aprvTeamID = teamID;
			}
			
			/* 시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyMMdd").format(cal.getTime());
			setData.put("thisYmd", thisYmd);
		    String maxScrID= StringUtil.checkNull(commonService.selectString("scr_SQL.getMaxSCRID", setData));
			String maxScrCode = StringUtil.checkNull(commonService.selectString("scr_SQL.getMaxSCRCode", setData));		
			if(maxScrCode.equals("")){ 
				maxScrCode = "SCR"  + thisYmd + "0001";
			} else {
				maxScrCode = maxScrCode.substring(maxScrCode.length() - 4, maxScrCode.length());
				int curScrCode = Integer.parseInt(maxScrCode) + 1;
				maxScrCode =  "SCR" +  thisYmd + String.format("%04d", curScrCode);			
			}
			
			insertData.put("srID", srID);
			insertData.put("csrID", csrID);
			insertData.put("scrCode", maxScrCode);
			insertData.put("scrID", maxScrID);
			insertData.put("status", "EDT");
			insertData.put("planStartDT", planStartDT); 
			insertData.put("planEndDT", planEndDT);
			insertData.put("planManDay", planManDay);
			insertData.put("approverID", approverID);
			insertData.put("aprvTeamID", aprvTeamID);
			insertData.put("impAnalYN", impAnalYN);
			insertData.put("urgencyYN", urgencyYN);
			insertData.put("priority", priority);
			insertData.put("subject", subject);
			insertData.put("changeScope", changeScope);
			insertData.put("jobDescription", jobDescription);
			insertData.put("scrIssue", scrIssue);
			insertData.put("cmYN", cmYN);
			insertData.put("finTestYN", finTestYN);
			insertData.put("CTRYN", CTRYN);
			insertData.put("regUserID", commandMap.get("sessionUserId"));
			insertData.put("regTeamID", commandMap.get("sessionTeamId"));
			insertData.put("userID", commandMap.get("sessionUserId"));
			insertData.put("scrArea1", scrArea1);
			insertData.put("scrArea2", scrArea2);
			
			if(urgencyYN.equals("1")){ // 긴급일경우 
				insertData.put("aprvStatus", "2"); // SCR Aprv Status 1: 승인요청, 2: 승인 , 3 : 반려
				insertData.put("approveYN", "0"); 
			}
			
			commonService.insert("scr_SQL.insertSCR", insertData);	
			
					
			setData.put("srID", srID);			
			String srDueDate = StringUtil.checkNull(commonService.selectString("esm_SQL.getESMSRDueDate", setData));			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			int compare = format.parse(planEndDT).compareTo(format.parse(srDueDate)); // -1,10,1 retrun
			
			if(compare > 0 ){ 
				insertData.put("dueDate", planEndDT);
			}
			
			System.out.println("1111 speCode :"+speCode);
			speCode = StringUtil.checkNull(ESPUtil.getNextSpeCode(request, commonService, insertData));
			//speCode = "SPE005";
			
			System.out.println("1111 speCode :"+speCode);
			insertData.put("srID", srID);
			insertData.put("status", speCode);
			insertData.put("blocked", 1);
			insertData.put("lastUser", commandMap.get("sessionUserId"));
			commonService.update("esm_SQL.updateESMSR", insertData);	
			
			//Save PROC_LOG
			String procRoleTP = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRProcRoleTP",insertData));
			insertData.put("speCode", speCode);
			insertData.put("procRoleTP", procRoleTP);
			Map setProcMapRst = (Map)setProcLog(request, commonService, insertData);
			if(setProcMapRst.get("type").equals("FAILE")){
				System.out.println("SAVE PROC_LOG FAILE Msg : "+StringUtil.checkNull(setProcMapRst.get("msg")));
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBack('"+maxScrID+"');parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
		
	@RequestMapping("/viewScrDetail.do")
	public String viewScrDetail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/scr/viewScrDetail";
		Map setData = new HashMap();
		try {			
			String screenMode = StringUtil.checkNull(request.getParameter("screenMode"));
			String scrID = StringUtil.checkNull(commandMap.get("scrID"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String tabNo = StringUtil.checkNull(request.getParameter("tabNo"));
			
			setData.put("scrID", scrID);
			setData.put("languageID", languageID);			
			Map scrInfo = commonService.select("scr_SQL.getSCR_gridList", setData);
			
			// CTR 존재여부
			String clsSCtsCNT = StringUtil.checkNull(commonService.selectString("ctr_SQL.getCTRCNT", setData));
			String ctrYN = "";
			if(Integer.parseInt(clsSCtsCNT) > 0){
				ctrYN = "Y";
			}
			
			String Description = StringUtil.checkNull(scrInfo.get("Description"),"");
			Description = StringUtil.replaceFilterString(Description);
			
			scrInfo.put("Description", Description);
			model.put("scrInfo", scrInfo);			

			String srID = StringUtil.checkNull(scrInfo.get("SRID"));
			setData.put("srID",srID);
			setData.put("languageID",languageID);			
			Map srInfo = commonService.select("esm_SQL.getESMSRInfo", setData); 
			
			String CTRYN = StringUtil.checkNull(scrInfo.get("CTRYN"));
			String ctrCLSYN = "N";
			if(CTRYN.equals("Y")){
				setData.put("status", "CTSCLS");
				clsSCtsCNT = StringUtil.checkNull(commonService.selectString("ctr_SQL.getCTRCNT", setData));
				if(Integer.parseInt(clsSCtsCNT) > 0){
					ctrCLSYN = "Y";
				}
			}else{
				ctrCLSYN = "Y";
			}
			setData.put("status", "CLS");
			String scrIngCount = commonService.selectString("scr_SQL.getScrCNT", setData);
			System.out.println("scrIngCount :" + scrIngCount);
			if (scrIngCount.equals("1")) {
				model.put("SRCMPYN", "Y");
			}

			// 시스템 날짜
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
			
			model.put("thisYmd", thisYmd);
			
			// WF
			setData.put("srTypeCode", StringUtil.checkNull(srInfo.get("SRType")));				
			Map srTypeInfo = commonService.select("esm_SQL.getESMSRTypeInfo",setData);
			model.put("WFDocURL", StringUtil.checkNull(srTypeInfo.get("WFDocURL")));
			
			model.put("ctrYN", ctrYN);
			model.put("ctrCLSYN", ctrCLSYN);		
			model.put("srInfo", srInfo);
			model.put("srID", srID);
			model.put("scrID", scrID);
			model.put("csrID",scrInfo.get("CSRID"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("screenMode", screenMode);
			model.put("tabNo",tabNo);
				
			String title = "SCR "+getLabel(request, commonService).get("LN00108");
			if(screenMode.equals("E")){	title = "SCR "+getLabel(request, commonService).get("LN00046"); }
			model.put("title", title);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/updateSCRInfo.do")
	public String updateSCRInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
	
		try {
			HashMap updateData = new HashMap();
			
			String emailCode = "" ;
			String scrID = StringUtil.checkNull(commandMap.get("scrID"));
			String planStartDT = StringUtil.checkNull(commandMap.get("planStartDT"));
			String planEndDT = StringUtil.checkNull(commandMap.get("planEndDT"));
			String planManDay = StringUtil.checkNull(commandMap.get("planManDay"));
			String impAnalYN = StringUtil.checkNull(commandMap.get("impAnalYN"));
			String finTestYN = StringUtil.checkNull(commandMap.get("finTestYN"));
			String urgencyYN = StringUtil.checkNull(commandMap.get("urgencyYN"));
			String cmYN = StringUtil.checkNull(commandMap.get("cmYN"));
			String subject = StringUtil.checkNull(commandMap.get("subject"));
			String changeScope = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(commandMap.get("changeScope")));
			String jobDescription = StringUtil.checkNull(commandMap.get("jobDescription"));
			String scrIssue = StringUtil.checkNull(commandMap.get("scrIssue"));
			String CTRYN = StringUtil.checkNull(commandMap.get("CTRYN"));
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String scrArea1 = StringUtil.checkNull(commandMap.get("scrArea1"));
			String scrArea2 = StringUtil.checkNull(commandMap.get("scrArea2"));
			
			String srType = StringUtil.checkNull(commandMap.get("srType"));
			String category = StringUtil.checkNull(commandMap.get("srCategory"));
			
			updateData.put("scrID", scrID);
			updateData.put("planStartDT", planStartDT); 
			updateData.put("planEndDT", planEndDT);
			updateData.put("planManDay", planManDay);
			updateData.put("impAnalYN", impAnalYN);
			updateData.put("finTestYN", finTestYN);	
			updateData.put("urgencyYN", urgencyYN);
			updateData.put("cmYN", cmYN);
			updateData.put("subject", subject);
			updateData.put("changeScope", changeScope);
			updateData.put("jobDescription", jobDescription);
			updateData.put("scrIssue", scrIssue);
			updateData.put("CTRYN", CTRYN);		
			updateData.put("lastUser", commandMap.get("sessionUserId"));
			updateData.put("scrArea1", scrArea1);
			updateData.put("scrArea2", scrArea2);
			
			// 선택된 카테고리의 접수자/접수팀  정보 취득
			Map setData = new HashMap();
			setData.put("srCatID", category);
			setData.put("srType", srType);
			Map RoleAssignMap =  commonService.select("esm_SQL.getESMSRAreaFromSrCat", setData);
			String processType = "";
			String procPathID = "";
			if(!RoleAssignMap.isEmpty()){
				if(RoleAssignMap.get("SRArea").equals("SRArea1")){ 
					setData.put("srArea", scrArea1 );
				}else{
					setData.put("srArea", scrArea2 );
				}
				setData.put("RoleType", RoleAssignMap.get("RoleType"));	
				
				processType = StringUtil.checkNull(RoleAssignMap.get("ProcessType"));
				procPathID = StringUtil.checkNull(RoleAssignMap.get("ProcPathID") );
			}			
			
			Map receiptInfoMap = new HashMap();
			setData.put("teamID", commandMap.get("sessionTeamId"));			
			receiptInfoMap = commonService.select("esm_SQL.getReceiptUser", setData);	
			
			// receiptUser && 메일 수신자 설정
			Map receiverMap = new HashMap();
			List receiverList = new ArrayList();		
			String receiptUserID = StringUtil.checkNull(receiptInfoMap.get("UserID"));
			if(receiptInfoMap != null){							
				setData.put("memberID", receiptUserID);
				Map checkMemberActiveInfo = commonService.select("user_SQL.getCheckMemberActive", setData);
				if(checkMemberActiveInfo != null && !checkMemberActiveInfo.isEmpty()){
					updateData.put("receiptUserID", checkMemberActiveInfo.get("MemberID"));
					updateData.put("receiptTeamID", checkMemberActiveInfo.get("TeamID"));
					receiverMap.put("receiptUserID", checkMemberActiveInfo.get("MemberID"));
				}else{
					updateData.put("receiptUserID", receiptInfoMap.get("UserID"));
					updateData.put("receiptTeamID", receiptInfoMap.get("TeamID"));
					receiverMap.put("receiptUserID", receiptInfoMap.get("UserID"));
				}
				receiverList.add(0,receiverMap);
				
			}else{
				updateData.put("receiptUserID", "1");
				setData.put("userID", "1");
				Map recTeamInfoMap = commonService.select("user_SQL.memberTeamInfo", setData);
				updateData.put("receiptTeamID",recTeamInfoMap.get("TeamID"));
				receiverMap.put("receiptUserID", "1");
				receiverList.add(0,receiverMap);
			}
			
			commonService.insert("scr_SQL.updateSCR", updateData);	
			
			setData = new HashMap();
			setData.put("srID", srID);		
			
			String srDueDate = StringUtil.checkNull(commonService.selectString("esm_SQL.getESMSRDueDate", setData));
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");			
			int compare = format.parse(planEndDT).compareTo(format.parse(srDueDate)); // -1,10,1 retrun
			
			updateData.put("srID", srID);	
			updateData.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
			
			// ESM_PROC_CONFIG : SpeCode, ProcPathID
			updateData.put("srType", srType);
			Map esmProcInfo = (Map)decideSRProcPath(request, commonService, updateData);
			//System.out.println(" updateSCRInfo : esmProcInfo : "+esmProcInfo);
			
			if(compare > 0){ // SCR PlandEndDT > SR DueDate -> SR. DueDate에 PlandEndDT update	
				updateData.put("dueDate", planEndDT);	
			}
			if(esmProcInfo != null && !esmProcInfo.isEmpty() ){ 
				updateData.put("speCode", esmProcInfo.get("SpeCode"));
				updateData.put("procPathID", esmProcInfo.get("ProcPathID"));
			}
					
			if(compare > 0 || ( esmProcInfo != null && !esmProcInfo.isEmpty()) ){ 					
				commonService.update("esm_SQL.updateESMSR", updateData);		
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBack();parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	// 사용안함 (WF로 대체)
	@RequestMapping(value = "/reqSCRApproval.do")
	public String reqSCRApproval(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap updateData = new HashMap();
			
			String emailCode = "SCRAPREQ" ;
			String scrID = StringUtil.checkNull(commandMap.get("scrID"));
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String aprvStatus = StringUtil.checkNull(commandMap.get("aprvStatus"));
			String scrStatus = StringUtil.checkNull(commandMap.get("scrStatus"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
			updateData.put("scrID", scrID);			
			updateData.put("aprvStatus", aprvStatus);
			updateData.put("status", scrStatus);		
			updateData.put("lastUser", commandMap.get("sessionUserId"));
			commonService.insert("scr_SQL.updateSCR", updateData);	
			
			updateData.put("srID", srID);
			String speCode = StringUtil.checkNull(ESPUtil.getNextSpeCode(request,commonService,updateData));
			updateData.put("status", speCode);
			updateData.put("lastUser", commandMap.get("sessionUserId"));
			commonService.update("esm_SQL.updateESMSR", updateData);	
			
			//Save PROC_LOG
			updateData.put("speCode", speCode);
			Map setProcMapRst = (Map)setProcLog(request, commonService, updateData);
			if(setProcMapRst.get("type").equals("FAILE")){
				System.out.println("SAVE PROC_LOG FAILE Msg : "+StringUtil.checkNull(setProcMapRst.get("msg")));
			}
		
			//send Email
			List receiverList = new ArrayList();
			Map receiverMap = new HashMap();
			receiverMap.put("receiptUserID", StringUtil.checkNull(commonService.selectString("scr_SQL.getSCRApproverID", updateData)));
			receiverList.add(0,receiverMap);

			Map setMap = new HashMap();
			setMap.put("scrID", scrID);
			setMap.put("languageID", languageID);			
			HashMap cntsMap = (HashMap)commonService.select("scr_SQL.getSCR_gridList", setMap);
			
			Map temp = new HashMap();
			temp.put("Category", "EMAILCODE"); 
			temp.put("TypeCode", emailCode);
			temp.put("LanguageID", commandMap.get("sessionCurrLangType"));
			Map emDescription = commonService.select("common_SQL.label_commonSelect", temp);
			cntsMap.put("emDescription",emDescription.get("Description"));
						
			updateData.put("receiverList", receiverList);
			updateData.put("subject", cntsMap.get("Subject"));
			Map setMailMapRst = (Map)setEmailLog(request, commonService, updateData, emailCode);
			System.out.println("setMailMapRst : "+setMailMapRst );
			
			if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
				
				Map resultMailMap = EmailUtil.sendMail(mailMap,cntsMap, getLabel(request, this.commonService));
				System.out.println("SEND EMAIL TYPE:" + resultMailMap + "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
				
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
			}
			
			model.put("scrID",scrID);
			model.put("srID",srID);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00150")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnCallBack();parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping({ "/requestTestPop.do" })
	public String requestTestPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		new HashMap();
		try {
			String scrID = StringUtil.checkNull(commandMap.get("scrID"));
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String scrStatus = StringUtil.checkNull(commandMap.get("scrStatus"));
			String srStatus = StringUtil.checkNull(commandMap.get("srStatus"));
			String srRequestUserID = StringUtil.checkNull(commandMap.get("srRequestUserID"));
			
			model.put("menu", getLabel(request, commonService));
			model.put("scrID",scrID);
			model.put("srID",srID);
			model.put("scrStatus",scrStatus);
			model.put("srStatus",srStatus);
			model.put("srRequestUserID",srRequestUserID);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/app/esm/itsp/scr/requestTestPop");
	}
	
	@RequestMapping(value = "/requestTest.do")
	public String requestTest(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap updateData = new HashMap();
			
			String emailCode = "REQSYSTEST" ;
			String scrID = StringUtil.checkNull(commandMap.get("scrID"));
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String scrStatus = StringUtil.checkNull(commandMap.get("scrStatus"));
			String speCode = StringUtil.checkNull(commandMap.get("srStatus"));
			String srRequestUserID = StringUtil.checkNull(commandMap.get("srRequestUserID"));
			
			updateData.put("scrID", scrID);			
			updateData.put("status", scrStatus);		
			updateData.put("finTestor", srRequestUserID);
			updateData.put("integTestResult", StringUtil.checkNull(request.getParameter("comment")));
			updateData.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
			commonService.insert("scr_SQL.updateSCR", updateData);	
			
			updateData.put("srID", srID);
			updateData.put("status", speCode);			
			updateData.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
			commonService.update("esm_SQL.updateESMSR", updateData);
			
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			setMap.put("scrID", scrID);
			setMap.put("languageID", languageID);			
			HashMap cntsMap = (HashMap)commonService.select("scr_SQL.getSCR_gridList", setMap);
			
			Map temp = new HashMap();
			temp.put("Category", "EMAILCODE"); 
			temp.put("TypeCode", emailCode);
			temp.put("LanguageID", commandMap.get("sessionCurrLangType"));
			Map emDescription = commonService.select("common_SQL.label_commonSelect", temp);
			cntsMap.put("emDescription",emDescription.get("Description"));
			
			//Save PROC_LOG
			String procRoleTP = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRProcRoleTP",updateData));
			updateData.put("speCode", speCode);
			updateData.put("procRoleTP", procRoleTP);
			Map setProcMapRst = (Map)setProcLog(request, commonService, updateData);
			if(setProcMapRst.get("type").equals("FAILE")){
				System.out.println("SAVE PROC_LOG FAILE Msg : "+StringUtil.checkNull(setProcMapRst.get("msg")));
			}
			
			//send Email
			List receiverList = new ArrayList();
			Map receiverMap = new HashMap();
			receiverMap.put("receiptUserID", StringUtil.checkNull(commonService.selectString("esm_SQL.getESMSRReqUserID", updateData)));
			receiverList.add(0,receiverMap);
			
			updateData.put("receiverList", receiverList);
			updateData.put("subject", cntsMap.get("Subject"));
			Map setMailMapRst = (Map)setEmailLog(request, commonService, updateData, emailCode);
			System.out.println("setMailMapRst : "+setMailMapRst );
			
			if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
									
//				cntsMap.put("userID", updateData.get("receiptUserID"));
//				cntsMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
//				String receiptLoginID = StringUtil.checkNull(commonService.selectString("2sr_SQL.getLoginID", cntsMap));
//				cntsMap.put("loginID", receiptLoginID);
				
				Map resultMailMap = EmailUtil.sendMail(mailMap,cntsMap, getLabel(request, this.commonService));
				System.out.println("SEND EMAIL TYPE:" + resultMailMap + "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
				
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
			}
			
			model.put("srID", srID);
			model.put("scrID", scrID);		
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBack();parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/completeSCR.do")
	public String completeSCR(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap updateData = new HashMap();
			
			String emailCode = "ITSCMP" ;
			String scrID = StringUtil.checkNull(commandMap.get("scrID"));
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String scrStatus = StringUtil.checkNull(commandMap.get("scrStatus"));	
			String speCode = StringUtil.checkNull(commandMap.get("speCode"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String srCmpYN = StringUtil.checkNull(commandMap.get("srCmpYN"));
			String srLastCode = StringUtil.checkNull(commandMap.get("srLastCode"));

			updateData.put("scrID", scrID);
			updateData.put("status", scrStatus);
			updateData.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
			commonService.insert("scr_SQL.updateSCR", updateData);	
		
			updateData.put("srID", srID);			
			updateData.put("status", "CLS");
			String openScrCNT = StringUtil.checkNull(commonService.selectString("scr_SQL.getScrCNT", updateData));
			
			speCode = StringUtil.checkNull(ESPUtil.getNextSpeCode(request, commonService, updateData));
			
			if (Integer.parseInt(openScrCNT) == 0) { // SCR이 전부 CLS이고 srCmpYN = Y 이면 완료처리

				updateData.remove("status");
				
				Map setMap = new HashMap();
				setMap.put("srID", srID);
				setMap.put("languageID", languageID);
				HashMap srInfo = (HashMap) commonService.select("esm_SQL.getESMSRInfo", setMap);

				updateData.put("OpenSCRCNT", openScrCNT);
				updateData.put("srStatus", srInfo.get("Status"));
				updateData.put("languageID", languageID);
				
				updateData.put("srID", srID);
				updateData.put("blocked", 1);
				updateData.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
				updateData.put("svcCompl", srCmpYN);
				updateData.put("status", speCode);
				commonService.update("esm_SQL.updateESMSR", updateData);

				// ===========================================================================================================================
				// send Email
				List receiverList = new ArrayList();
				Map receiverMap = new HashMap();
				String srRequestUserID = StringUtil.checkNull(srInfo.get("RequestUserID"));
				receiverMap.put("receiptUserID", srRequestUserID);
				receiverList.add(0, receiverMap);

				Map receiverccMap = new HashMap();
				updateData.put("languageID", languageID);

				String scrApprover = StringUtil.checkNull(commonService.selectString("scr_SQL.getSCRApproverID", updateData));
				receiverccMap.put("receiptUserID", scrApprover); //참조
				receiverccMap.put("receiptType", "CC");
				receiverList.add(receiverccMap);
				
				updateData.put("receiverList", receiverList);
				updateData.put("subject", srInfo.get("Subject"));
				Map setMailMapRst = (Map)setEmailLog(request, commonService, updateData, emailCode);
				System.out.println("setMailMapRst : "+setMailMapRst );
				
				if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
					HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");					
					setMap.put("scrID", scrID);
					setMap.put("languageID", languageID);			
					HashMap cntsMap = srInfo;
					
					Map temp = new HashMap();
					temp.put("Category", "EMAILCODE"); 
					temp.put("TypeCode", emailCode);
					temp.put("LanguageID", commandMap.get("sessionCurrLangType"));
					Map emDescription = commonService.select("common_SQL.label_commonSelect", temp);
					cntsMap.put("emDescription", emDescription.get("Description"));

					Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, commonService));
					System.out.println("SEND EMAIL TYPE:" + resultMailMap + "Msg :"
							+ StringUtil.checkNull(setMailMapRst.get("type")));

				} else {
					System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMailMapRst.get("msg")));
				}

				if ("Y".equals(srCmpYN)) { // SR 도 동시에 완료처리 이면 조치 완료 이메일 발송
					// ======================================
					// send Email SR Complete
					List srReceiverList = new ArrayList();
					Map srReceiverMap = new HashMap();
					Map srUpdateData = new HashMap();
					Map setData = new HashMap();

					srReceiverMap.put("receiptUserID", srRequestUserID); // SR 조치 시는 수신자가 조치자(ReceiptUser)가 아닌
																			// RequestUser의 이메일로 송신
					srReceiverList.add(0, srReceiverMap);

					srUpdateData.put("receiverList", srReceiverList);

					// 참조자 메일 발송
					setData.put("languageID", commandMap.get("sessionCurrLangType"));
					setData.put("SRID", srID);
					List srRefMemberList = commonService.selectList("esm_SQL.getESMSRMember", setData);
					int receiverIndex = receiverList.size();
					if (srRefMemberList.size() > 0) {
						for (int i = 0; srRefMemberList.size() > i; i++) {
							Map srRefMemberInfo = (Map) srRefMemberList.get(i);
							srReceiverMap = new HashMap();
							srReceiverMap.put("receiptUserID", srRefMemberInfo.get("MemberID"));
							srReceiverMap.put("receiptType", "CC");
							srReceiverList.add(receiverIndex, srReceiverMap);
							receiverIndex++;
						}
					}

					srUpdateData.put("subject", StringUtil.checkNull(srInfo.get("Subject")));
					setMailMapRst = (Map) setEmailLog(request, commonService, updateData, "SRCMP");
					if (StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")) {
						HashMap mailMap = (HashMap) setMailMapRst.get("mailLog");
						setMap.put("srID", srID);
						setMap.put("srType", StringUtil.checkNull(srInfo.get("SRType")));
						setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
						HashMap cntsMap = srInfo;

						cntsMap.put("srID", srID);
						cntsMap.put("teamID", StringUtil.checkNull(srInfo.get("RequestTeamID")));
						cntsMap.put("userID", StringUtil.checkNull(srInfo.get("RequestUserID")));
						cntsMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
						cntsMap.put("emailCode", "SRCMP");

						String emailHTMLForm = StringUtil
								.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", cntsMap));
						cntsMap.put("emailHTMLForm", emailHTMLForm);

						Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, commonService));
						System.out.println("SR CMP  SEND EMAIL TYPE :" + resultMailMap + "Msg :"
								+ StringUtil.checkNull(setMailMapRst.get("type")));
					} else {
						System.out.println("SR CMP SAVE EMAIL_LOG FAILE/DONT Msg : "
								+ StringUtil.checkNull(setMailMapRst.get("msg")));
					}
					// ==============================================
				}
			}
			// ===========================================================================================================================
			// Save PROC_LOG
			String procRoleTP = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRProcRoleTP",updateData));
			updateData.put("speCode",speCode);
			updateData.put("procRoleTP",procRoleTP);
			Map setProcMapRst = (Map)setProcLog(request, commonService, updateData);
			if(setProcMapRst.get("type").equals("FAILE")){
				System.out.println("SAVE PROC_LOG FAILE Msg : "+StringUtil.checkNull(setProcMapRst.get("msg")));
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnCallBackClose();parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/approveSCRCommentPop.do")
	public String approveSCRCommentPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
				String scrID = StringUtil.checkNull(commandMap.get("scrID"));
				String srID = StringUtil.checkNull(commandMap.get("srID"));
				String aprvStatus = StringUtil.checkNull(commandMap.get("aprvStatus"));
				String scrStatus = StringUtil.checkNull(commandMap.get("scrStatus"));
				String srType = StringUtil.checkNull(commandMap.get("srType"));
				String svcCompl = StringUtil.checkNull(commandMap.get("svcCompl"));
				
				model.put("menu", getLabel(request, commonService)); /*Label Setting*/	
				model.put("scrID", scrID);
				model.put("srID", srID);
				model.put("aprvStatus", aprvStatus);	
				model.put("scrStatus", scrStatus);	
				model.put("srType", srType);
				model.put("svcCompl", svcCompl);
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/app/esm/itsp/scr/approveSCRComment");
	}
	
	@RequestMapping(value = "/submitSCRApproval.do")
	public String submitSCRApproval(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap updateData = new HashMap();
			Map setMap = new HashMap();
			
			String emailCode = "SCRAPREL";
			String scrID = StringUtil.checkNull(commandMap.get("scrID"));
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String aprvStatus = StringUtil.checkNull(commandMap.get("aprvStatus"));
			String scrStatus = StringUtil.checkNull(commandMap.get("scrStatus"));
			String comment = StringUtil.checkNull(commandMap.get("comment"));
			String srType = StringUtil.checkNull(commandMap.get("srType"));
			String svcCompl = StringUtil.checkNull(commandMap.get("svcCompl"));
			
			String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
			String wfInstanceStatus = StringUtil.checkNull(commandMap.get("wfInstanceStatus"));
			
			if(!"".equals(wfInstanceID)){
				setMap.put("wfInstanceID",wfInstanceID);
				Map wfMap = (HashMap)commonService.select("wf_SQL.getWFInstDoc", setMap);
				scrID = StringUtil.checkNull(wfMap.get("DocumentID"));
				
				if("2".equals(wfInstanceStatus)){
					scrStatus = "APREL";
					aprvStatus = wfInstanceStatus;
				} else {
					scrStatus = "APRJT";
					aprvStatus = wfInstanceStatus;
					svcCompl = "Y";
				}
			}
			
			updateData.put("scrID", scrID);			
			updateData.put("aprvStatus", aprvStatus);
			updateData.put("status", scrStatus);		
			updateData.put("lastUser", commandMap.get("sessionUserId"));
			updateData.put("aprvComment", comment);
			commonService.insert("scr_SQL.updateSCR", updateData);	
			
			updateData.put("srID", srID);			
			updateData.put("lastUser", commandMap.get("sessionUserId"));	
			
			// ESM_PROC_CONFIG : SpeCode, ProcPathID
			updateData.put("srType", srType);
			updateData.put("wfInstanceID", wfInstanceID);
			updateData.put("languageID",commandMap.get("sessionCurrLangType"));
			String speCode = StringUtil.checkNull(ESPUtil.getNextSpeCode(request, commonService, updateData));
			updateData.put("status", speCode);
			updateData.put("svcCompl", svcCompl);
		
			commonService.update("esm_SQL.updateESMSR", updateData);	
			
			//Save PROC_LOG
			String procRoleTP = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRProcRoleTP", updateData));
			updateData.put("speCode", speCode);
			updateData.put("procRoleTP", procRoleTP);
			Map setProcMapRst = (Map)setProcLog(request, commonService, updateData);
			if(setProcMapRst.get("type").equals("FAILE")){
				String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
				System.out.println("Msg : "+Msg);
			}
			
			//======================================================================================================
			// send Email
			
			// reject 
			if(!aprvStatus.equals("2")) emailCode = "SCRAPRJT";
			
			setMap.put("scrID", scrID);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			HashMap cntsMap = (HashMap) commonService.select("scr_SQL.getSCR_gridList", setMap);
			
			List receiverList = new ArrayList();
			Map receiverMap = new HashMap();
			receiverMap.put("receiptUserID",StringUtil.checkNull(cntsMap.get("RegUserID")));
			receiverList.add(0, receiverMap);

			Map temp = new HashMap();
			temp.put("Category", "EMAILCODE");
			temp.put("TypeCode", emailCode);
			temp.put("LanguageID", commandMap.get("sessionCurrLangType"));
			Map emDescription = commonService.select("common_SQL.label_commonSelect", temp);
			cntsMap.put("emDescription", emDescription.get("Description"));

			updateData.put("receiverList", receiverList);
			updateData.put("subject", cntsMap.get("Subject"));
			Map setMailMapRst = (Map) setEmailLog(request, commonService, updateData, emailCode);
			System.out.println("setMailMapRst : " + setMailMapRst);

			if (StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")) {
				HashMap mailMap = (HashMap) setMailMapRst.get("mailLog");

				Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, this.commonService));
				System.out.println("SEND EMAIL TYPE:" + resultMailMap + "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));

			} else {
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMailMapRst.get("msg")));
			}
			//======================================================================================================

			if (aprvStatus.equals("2")) {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00083")); // 합의/승인
																														// 하였습니다.
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00156")); // 결재문서를 반려하였습니다.
			}
			
			model.put("scrID", scrID);
			model.put("srID", srID);
			
			target.put(AJAX_SCRIPT, "parent.fnCallBack();$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping("/scrMbrRoleList.do")
	public String scrMbrRoleList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/scr/scrMbrRoleList";
		try{
			String srID = StringUtil.checkNull(request.getParameter("srID"),"");
			String scrID = StringUtil.checkNull(request.getParameter("scrID"),"");
			String scrUserID = StringUtil.checkNull(request.getParameter("scrUserID"),"");
			String scrStatus = StringUtil.checkNull(request.getParameter("scrStatus"),"");
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
			model.put("srId",srID);
			model.put("scrId",scrID);
			model.put("scrUserID",scrUserID);
			model.put("scrStatus",scrStatus);
			model.put("scrnType","roleList");
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			Map scrMbrRoleMap = new HashMap();
			scrMbrRoleMap.put("languageID",languageID);
			scrMbrRoleMap.put("scrnType","roleList");
			scrMbrRoleMap.put("scrId",scrID);
			List scrMbrRoleList = commonService.selectList("scr_SQL.getSCRMbrList_gridList",scrMbrRoleMap);
			JSONArray gridData = new JSONArray(scrMbrRoleList);
			model.put("gridData",gridData);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping("/searchSCRMbrPop.do")
	public String searchSCRMbrPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/scr/searchSCRMbrPop";
		try{
			Map setMap = new HashMap();
			String srID = StringUtil.checkNull(request.getParameter("srId"));
			String scrID = StringUtil.checkNull(request.getParameter("scrId"));
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"),request.getParameter("languageID")); 
			setMap.put("srID",srID);
			setMap.put("languageID",languageID);
			
			Map srMstList = commonService.select("esm_SQL.getESMSRInfo", setMap); 
			String projectID = StringUtil.checkNull(srMstList.get("ProjectID"));
			model.put("projectID", projectID);
			model.put("scrId", scrID);
			model.put("scrnType",scrnType);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			setMap.put("scrId",scrID);
			setMap.put("projectID",projectID);
			List srMbrList = commonService.selectList("scr_SQL.getSCRWorkerList_gridList", setMap); 
			JSONArray gridData = new JSONArray(srMbrList);
			model.put("gridData", gridData);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/insertSCRMembers.do")
	public String insertPjtMembers(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		try {

			String memberIds = StringUtil.checkNull(request.getParameter("memberIds"));
			String scrId = StringUtil.checkNull(request.getParameter("scrId"));
			
			setMap.put("scrId", scrId);
			String[] arrayMember = memberIds.split(",");
			for(int i = 0 ; i < arrayMember.length; i++){
				String memberId = arrayMember[i];
				setMap.put("MemberID", memberId);
				commonService.insert("scr_SQL.insertSCRMemberRel", setMap);				
			}
			
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 성공															
			target.put(AJAX_SCRIPT, "this.reloadMemberList();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/updateSCRMembers.do")
	public String updateSCRMembers(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		try {
			String scrId = StringUtil.checkNull(request.getParameter("scrId"));
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
			setMap.put("scrId",scrId);
			String memberID = "";
			String planManDay = "";
			String actualManDay = "";
			String roleDescription = "";
			
			JSONArray jsonArray  = new JSONArray(request.getParameter("editedRow"));
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject jo = (JSONObject)jsonArray.get(i);
				
				memberID = StringUtil.checkNull(jo.get("MemberID"));
				if(scrnType.equals("P")){
					planManDay = StringUtil.checkNull(jo.get("PlanManDay"));
				} else if (scrnType.equals("A")){
					actualManDay = StringUtil.checkNull(jo.get("ActualManDay"));
				}
				roleDescription = StringUtil.checkNull(jo.get("RoleDescription"));
				
				setMap.put("memberID",memberID);
				setMap.put("planManDay",planManDay);
				setMap.put("actualManDay",actualManDay);
				setMap.put("roleDescription",roleDescription);
				commonService.update("scr_SQL.updateSCRMemberRel", setMap);
			}
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/delSCRMembers.do")
	public String delSCRMembers(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		try {
			String memberIds = StringUtil.checkNull(request.getParameter("memberIds"));
			String scrId = StringUtil.checkNull(request.getParameter("scrId"));
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
			
			setMap.put("scrId", scrId);
			String[] arrayMember = memberIds.split(",");
			for(int i = 0 ; i < arrayMember.length; i++){
				String memberId = arrayMember[i];
				setMap.put("MemberID", memberId);
				commonService.delete("scr_SQL.delSCRMemberRel", setMap);				
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 성공															
			target.put(AJAX_SCRIPT, "this.doSearchList('" + scrnType + "');");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
		
	@RequestMapping("/viewScrImpAnal.do")
	public String viewScrImpAnal(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/scr/viewScrImpAnal";
		Map setMap = new HashMap();
		try{
			String scrId = StringUtil.checkNull(request.getParameter("scrID"));
			setMap.put("scrID", scrId);
			setMap.put("languageID",StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			String scrUserID = StringUtil.checkNull(request.getParameter("scrUserID"),"");
			String scrStatus = StringUtil.checkNull(request.getParameter("scrStatus"),"");
			Map scrInfo = commonService.select("scr_SQL.getSCR_gridList", setMap);
			
			model.put("scrInfo", scrInfo);
			model.put("scrId", scrId);
			model.put("scrUserID", scrUserID);
			model.put("scrStatus",scrStatus);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping("/editScrImpAnal.do")
	public String editScrImpAnal(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/scr/editScrImpAnal";
		Map setMap = new HashMap();
		try{
			String scrId = StringUtil.checkNull(request.getParameter("scrId"));
			String scrStatus = StringUtil.checkNull(request.getParameter("scrStatus"));
			String scrUserID = StringUtil.checkNull(request.getParameter("scrUserID"));
			
			setMap.put("scrID", scrId);
			setMap.put("languageID",StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			Map scrInfo = commonService.select("scr_SQL.getSCR_gridList", setMap);
			
			model.put("scrInfo", scrInfo);
			model.put("scrId", scrId);
			model.put("scrStatus",scrStatus);
			model.put("scrUserID", scrUserID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping("/saveScrImpAnal.do")
	public String saveScrImpAnal(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		try{
			String scrId = StringUtil.checkNull(request.getParameter("scrId"));
			String arcAnalInfo = StringUtil.checkNull(request.getParameter("arcAnalInfo"));
			String impRewResult = StringUtil.checkNull(request.getParameter("impRewResult"));
			String cmRewResult = StringUtil.checkNull(request.getParameter("cmRewResult"));
			String impIssue = StringUtil.checkNull(request.getParameter("impIssue"));

			setMap.put("scrID", scrId);
			setMap.put("arcAnalInfo", arcAnalInfo);
			setMap.put("impRewResult", impRewResult);
			setMap.put("cmRewResult", cmRewResult);
			setMap.put("impIssue", impIssue);
			setMap.put("lastUser", commandMap.get("sessionUserId"));
			
			commonService.update("scr_SQL.updateSCR", setMap);
						
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping("/viewScrTestResult.do")
	public String viewScrTestResult(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/scr/viewScrTestResult";
		Map setMap = new HashMap();
		List fileList = new ArrayList();
		try{
			String scrId = StringUtil.checkNull(request.getParameter("scrID"));
			String srId = StringUtil.checkNull(request.getParameter("srID"));
			setMap.put("scrID", scrId);
			setMap.put("languageID",StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			Map scrInfo = commonService.select("scr_SQL.getSCR_gridList", setMap);
			String scrUserID = StringUtil.checkNull(request.getParameter("scrUserID"),"");
			String scrStatus = StringUtil.checkNull(request.getParameter("scrStatus"),"");
			String finTestor = StringUtil.checkNull(request.getParameter("finTestor"));						// FinTestor
			
			setMap.put("fltp", "SCR002");
			setMap.put("languageID",StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			List fileList1 = commonService.selectList("scr_SQL.getSCRFileList", setMap);		// FLTP별 샘플 파일
			
			for(int i=0; i<fileList1.size(); i++){
				Map fileInfo = (Map) fileList1.get(i);
				setMap.put("fltpCode",fileInfo.get("FltpCode"));
				Map fileList2 = commonService.select("scr_SQL.getSCRFileList", setMap);	// FLTP별 업로드 파일
				for(Object fileInfo2 : fileList2.keySet()){
					fileInfo.put(fileInfo2, fileList2.get(fileInfo2));
				}
				fileList.add(i, fileInfo);
			}
			
			model.put("scrInfo", scrInfo);
			model.put("scrId", scrId);
			model.put("srId", srId);
			model.put("scrUserID",scrUserID);
			model.put("scrStatus",scrStatus);
			model.put("fileList",fileList);
			model.put("finTestor",finTestor);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping("/editScrTestResult.do")
	public String editScrTestResult(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/scr/editScrTestResult";
		Map setMap = new HashMap();
		try{
			String scrId = StringUtil.checkNull(request.getParameter("scrId"));
			setMap.put("scrID", scrId);
			setMap.put("languageID",StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			Map scrInfo = commonService.select("scr_SQL.getSCR_gridList", setMap);
			
			model.put("scrInfo", scrInfo);
			model.put("scrId", scrId);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping("/saveScrTestResult.do")
	public String saveScrTestResult(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		try{
			String scrId = StringUtil.checkNull(request.getParameter("scrId"));
			String srId = StringUtil.checkNull(request.getParameter("srId"));
			
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBack('"+scrId+"');");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping("/viewScrProcResult.do")
	public String viewScrProcResult(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/scr/viewScrProcResult";
		Map setMap = new HashMap();
		try{
			String scrId = StringUtil.checkNull(request.getParameter("scrID"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			setMap.put("scrID", scrId);
			setMap.put("languageID",languageID);
			Map scrInfo = commonService.select("scr_SQL.getSCR_gridList", setMap);
			String scrUserID = StringUtil.checkNull(request.getParameter("scrUserID"),"");
			String scrStatus = StringUtil.checkNull(request.getParameter("scrStatus"),"");
			
			model.put("scrInfo", scrInfo);
			model.put("scrId", scrId);
			model.put("scrUserID",scrUserID);
			model.put("scrStatus",scrStatus);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			setMap.put("scrId", scrId);
			List scrMbrRoleList = commonService.selectList("scr_SQL.getSCRMbrList_gridList",setMap);
			JSONArray gridData = new JSONArray(scrMbrRoleList);
			model.put("gridData",gridData);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping("/editScrProcResult.do")
	public String editScrProcResult(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/scr/editScrProcResult";
		Map setMap = new HashMap();
		try{
			String scrId = StringUtil.checkNull(request.getParameter("scrId"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			setMap.put("scrID", scrId);
			setMap.put("scrId", scrId);
			setMap.put("languageID",languageID);
			Map scrInfo = commonService.select("scr_SQL.getSCR_gridList", setMap);
			
			model.put("scrInfo", scrInfo);
			model.put("scrId", scrId);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			List scrMbrRoleList = commonService.selectList("scr_SQL.getSCRMbrList_gridList",setMap);
			JSONArray gridData = new JSONArray(scrMbrRoleList);
			model.put("gridData",gridData);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping("/saveScrProcResult.do")
	public String saveScrProcResult(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		try{
			String scrId = StringUtil.checkNull(request.getParameter("scrId"));
			setMap.put("scrId",scrId);
			setMap.put("scrID",scrId);
			setMap.put("lastUser", commandMap.get("sessionUserId"));
			
			String closingCode = StringUtil.checkNull(request.getParameter("closingCode"));
			String actualManDay = StringUtil.checkNull(request.getParameter("actualMD"));
			String changeNotice = StringUtil.checkNull(request.getParameter("changeNotice"));
			setMap.put("closingCode",closingCode);
			setMap.put("actualManDay",actualManDay);
			setMap.put("changeNotice",changeNotice);
			commonService.update("scr_SQL.updateSCR", setMap);
			
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping("/scrFileList.do")
	public String scrFileList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/scr/scrFileList";
		Map setMap = new HashMap();
		List fileList = new ArrayList();
		try{
			String scrId = StringUtil.checkNull(request.getParameter("scrID"));
			String finTestor = StringUtil.checkNull(request.getParameter("finTestor"));						// FinTestor
			String scrUserID = StringUtil.checkNull(request.getParameter("scrUserID"));		// SCR 담당자
			String scrStatus = StringUtil.checkNull(request.getParameter("scrStatus"));
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String srType = StringUtil.checkNull(request.getParameter("srType"));
			
			setMap.put("scrID", scrId);
			setMap.put("fltp", "SCR001");
			setMap.put("languageID",StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			List fileList1 = commonService.selectList("scr_SQL.getSCRFileList", setMap);		// FLTP별 샘플 파일
			
			for(int i=0; i<fileList1.size(); i++){
				Map fileInfo = (Map) fileList1.get(i);
				setMap.put("fltpCode",fileInfo.get("FltpCode"));
				Map fileList2 = commonService.select("scr_SQL.getSCRFileList", setMap);	// FLTP별 업로드 파일
				for(Object fileInfo2 : fileList2.keySet()){
					fileInfo.put(fileInfo2, fileList2.get(fileInfo2));
				}
				fileList.add(i, fileInfo);
			}
			
			model.put("srID", srID);
			model.put("scrId", scrId);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("finTestor",finTestor);
			model.put("scrUserID",scrUserID);
			//model.put("fileList",fileList);
			model.put("scrStatus",scrStatus);
			model.put("srType",srType);
			
			JSONArray gridData = new JSONArray(fileList);
			model.put("gridData",gridData);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/saveScrFile.do")
	public String saveScrFile(MultipartHttpServletRequest request,HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		Map target = new HashMap();
		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		try{
			for (Iterator i = cmmMap.entrySet().iterator(); i.hasNext();) {
			    Entry e = (Entry) i.next(); // not allowed
			    if(!e.getKey().equals("loginInfo") && e.getValue() != null) {
			    	cmmMap.put(e.getKey(), xss.stripXSS(e.getValue().toString()));
			    }
			}
			
			String scrId 	= StringUtil.checkNull(xss.getParameter("scrId"), "");
			String fltpCode 	= StringUtil.checkNull(xss.getParameter("fltpCode"), "");
			String fileID = StringUtil.checkNull(xss.getParameter("fileID"), "");
			String userId = StringUtil.checkNull(StringUtil.checkNull(cmmMap.get("sessionUserId")), "");
			String sysfile = StringUtil.checkNull(xss.getParameter("sysFile"), "");
			String srID = StringUtil.checkNull(xss.getParameter("srID"));
			String srType = StringUtil.checkNull(xss.getParameter("srType"));
			String comment = StringUtil.checkNull(xss.getParameter("comment"));
			String scrStatus = StringUtil.checkNull(xss.getParameter("scrStatus"));
			String srStatus = StringUtil.checkNull(xss.getParameter("srStatus"));
			
			//기존파일 삭제 
			File existFile = new File(sysfile); 
			if(existFile.isFile() && existFile.exists()){existFile.delete();}
			
			List fileList = new ArrayList();
			Map fileMap = new HashMap();
			Map setMap = new HashMap();
			setMap.put("fltpCode",fltpCode);
			
			String filePath = StringUtil.checkNull(fileMgtService.selectString("fileMgt_SQL.getFilePath",setMap));
			File dirFile = new File(filePath);if(!dirFile.exists()) { dirFile.mkdirs();} 
			
			if("".equals(fileID)){ // 신규 등록
				Iterator fileNameIter = request.getFileNames();
				String savePath = filePath; // 폴더 바꾸기				
				String fileName = "";
				int Seq = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", cmmMap));
				int seqCnt = 0;
				
				while (fileNameIter.hasNext()) {
				   MultipartFile mFile = request.getFile((String)fileNameIter.next());
				   fileName = mFile.getName();
				   
				   if (mFile.getSize() > 0) {						   
					   fileMap = new HashMap();
					   HashMap resultMap = FileUtil.uploadFile(mFile, savePath, true);
					   
					   fileMap.put("Seq", Seq);
					   fileMap.put("DocumentID", scrId);
					   fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
					   fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
					   fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
					   fileMap.put("FilePath", resultMap.get(FileUtil.FILE_PATH));	
					   fileMap.put("FltpCode", fltpCode);
					   fileMap.put("userId", userId);
					   fileMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
					   fileMap.put("KBN", "insert");
					   fileMap.put("DocCategory", "SCR");
					   setMap.put("srID", srID);
					   String srArea2 = StringUtil.checkNull(commonService.selectString("esm_SQL.getESMSRArea2", setMap));
					   setMap.put("srArea2", srArea2);
					   String projectID = StringUtil.checkNull(commonService.selectString("sr_SQL.getProjectIDFromL2", setMap)).trim();
					   fileMap.put("projectID", projectID);
					   if(!fltpCode.equals("SCR002")){
						   fileMap.put("Description", comment);
						   fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");
					   } else {
						   setMap.put("finTestResult", comment);
						   setMap.put("lastUser", userId);
						   setMap.put("scrID", scrId);
						   commonService.update("scr_SQL.updateSCR", setMap);
						   fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");
					   }
					   
					   fileList.add(fileMap);
					   seqCnt++;
				   }
				}	
				fileMgtService.save(fileList, fileMap);
			} else{ // 파일 수정
				Iterator fileNameIter = request.getFileNames();
				String savePath = filePath;
				String fileName = "";
				int Seq = Integer.parseInt(fileID);
				int seqCnt = 0;
				
				while (fileNameIter.hasNext()) {
				   MultipartFile mFile = request.getFile((String)fileNameIter.next());
				   fileName = mFile.getName();					
				   
				   if (mFile.getSize() > 0) {						   
					   fileMap = new HashMap();
					   HashMap resultMap = FileUtil.uploadFile(mFile, savePath, true);					
					   
					   fileMap.put("Seq", Seq);
					   fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
					   fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
					   fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
					   fileMap.put("filePath", resultMap.get(FileUtil.FILE_PATH));	
					   fileMap.put("FilePath", resultMap.get(FileUtil.FILE_PATH));	
					   fileMap.put("FltpCode", fltpCode);
					   fileMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
					   fileMap.put("sessionUserId", userId);
					   fileMap.put("KBN", "update");
					   if(!fltpCode.equals("SCR002")){
						   fileMap.put("Description", comment);
						   fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_update");
					   } else {
						   setMap.put("finTestResult", comment);
						   setMap.put("lastUser", userId);
						   setMap.put("scrID", scrId);
						   commonService.update("scr_SQL.updateSCR", setMap);
						   fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_update");
					   }
					   fileList.add(fileMap);
					   seqCnt++;
				   }
				}	
					fileMgtService.save(fileList, fileMap);
			}
			
			if(scrStatus.equals("TSCMP")){
			//****************************************************************************
			// scr 테스트결과서 업로드 후 SCR Status : TSCMP, SR Status : SPE009
			setMap.put("scrID", scrId);			
			setMap.put("status", scrStatus);		
			setMap.put("lastUser", StringUtil.checkNull(cmmMap.get("sessionUserId")));
			commonService.insert("scr_SQL.updateSCR", setMap);	
			
			/*
			setMap.put("srType", srType);
			setMap.put("scrStatus", scrStatus);
			Map esmProcInfo = (Map)decideSRProcPath(request, commonService, setMap);
			//System.out.println("scrStatus :"+scrStatus);
			//System.out.println("esmProcInfo :"+esmProcInfo);
			String procPathID = "";
			String speCode = "";
			setMap.remove("status");
			
			if(esmProcInfo != null && !esmProcInfo.isEmpty()){
				speCode = StringUtil.checkNull(esmProcInfo.get("SpeCode"));
				setMap.put("status", speCode); 
			}
			*/
			
			setMap.put("srType", srType);
			setMap.put("srID", srID);
			String speCode = ESPUtil.getNextSpeCode(request, commonService, setMap);
			setMap.put("status", speCode); 
			commonService.update("esm_SQL.updateESMSR", setMap);
			
			//Save PROC_LOG
			String procRoleTP = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRProcRoleTP",setMap));
			setMap.put("speCode", speCode);
			setMap.put("procRoleTP", procRoleTP);
			Map setProcMapRst = (Map)setProcLog(request, commonService, setMap);
			if(setProcMapRst.get("type").equals("FAILE")){
				String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
				System.out.println("Msg : "+Msg);
			}
			//****************************************************************************
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT,  "parent.selfClose("+scrId+",'"+scrStatus+"');parent.$('#isSubmit').remove();");
		}catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping("/scrMainList.do")
	public String scrMainList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/scr/scrMainList";
		try{
			HashMap setData = new HashMap();
			String listSize = StringUtil.checkNull(request.getParameter("listSize"));
			String scrMode = StringUtil.checkNull(request.getParameter("scrMode"));
			String mySCR = StringUtil.checkNull(request.getParameter("mySCR"));
			
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			setData.put("loginUserId", commandMap.get("sessionUserId"));
			setData.put("scrMode", scrMode);
			setData.put("mySCR", mySCR);
			List scrList = (List)commonService.selectList("scr_SQL.getSCR_gridList", setData);
			
			model.put("scrList", scrList);
			model.put("listSize", listSize);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		} catch (Exception e) {
			System.out.println(e.toString());
		}
	return nextUrl(url);
	}
	
	@RequestMapping(value = "/addScrFilePop.do")
	public String addScrFilePop(HttpServletRequest request, ModelMap model) throws Exception {
		try{
			String scrId = StringUtil.checkNull(request.getParameter("scrId"), "");
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"), "");
			String fileID = StringUtil.checkNull(request.getParameter("fileID"), "");
			String srID = StringUtil.checkNull(request.getParameter("srID"), "");
			String scrStatus = StringUtil.checkNull(request.getParameter("scrStatus"), "");
			
			model.put("srID", srID);
			model.put("scrId",scrId);
			model.put("fltpCode",fltpCode);
			model.put("fileID",fileID);
			model.put("scrStatus",scrStatus);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		} catch (Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/app/esm/itsp/scr/addScrFilePop");
	}

	@RequestMapping("/viewScrAnalysisDesign.do")
	public String viewScrAnalysisDesign(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/scr/viewScrAnalysisDesign";
		Map setMap = new HashMap();
		
		try{
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			String scrId = StringUtil.checkNull(request.getParameter("scrID"));
			String srId = StringUtil.checkNull(request.getParameter("srID"));
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
			setMap.put("scrID", scrId);
			setMap.put("languageID",StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			Map scrInfo = commonService.select("scr_SQL.getSCR_gridList", setMap);
			
			setMap.put("fltpCode", fltpCode);
			setMap.put("languageID",StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			List fileList = commonService.selectList("scr_SQL.getSCRFileList", setMap);		
			model.put("scrInfo", scrInfo);
			model.put("scrId", scrId);
			model.put("srId", srId);
			model.put("fileList",fileList);
			model.put("fltpCode", fltpCode);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping("/saveScrDesignComment.do")
	public String saveScrDesignComment(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		try{
			String scrId = StringUtil.checkNull(request.getParameter("scrID"));			
			String designComment = StringUtil.checkNull(request.getParameter("designComment"));
			
			setMap.put("scrID",scrId);
			setMap.put("lastUser", commandMap.get("sessionUserId"));
			setMap.put("DesignComment",designComment);  
			
			commonService.update("scr_SQL.updateSCR", setMap);
			
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.setSubFrame();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping("/viewScrDevelopment.do")
	public String viewScrDevelopment(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/scr/viewScrDevelopment";
		Map setMap = new HashMap();
		
		try{
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			String scrId = StringUtil.checkNull(request.getParameter("scrID"));
			String srId = StringUtil.checkNull(request.getParameter("srID"));
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
			setMap.put("scrID", scrId);
			setMap.put("languageID",StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			Map scrInfo = commonService.select("scr_SQL.getSCR_gridList", setMap);
			
			setMap.put("fltpCode", fltpCode);
			setMap.put("languageID",StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			List fileList = commonService.selectList("scr_SQL.getSCRFileList", setMap);		
			model.put("scrInfo", scrInfo);
			model.put("scrId", scrId);
			model.put("srId", srId);
			model.put("fileList",fileList);
			model.put("fltpCode", fltpCode);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping("/saveScrDevComment.do")
	public String saveScrDevComment(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		try{
			String scrId = StringUtil.checkNull(request.getParameter("scrID"));			
			String developmentComment = StringUtil.checkNull(request.getParameter("developmentComment"));
			
			setMap.put("scrID",scrId);
			setMap.put("lastUser", commandMap.get("sessionUserId"));
			setMap.put("developmentComment",developmentComment);  
			
			commonService.update("scr_SQL.updateSCR", setMap);
			
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.setSubFrame();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/updateSCRMaster.do")
	public String updateSCRMaster(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap updateData = new HashMap();
			Map setMap = new HashMap();
			
			//String emailCode = "SCRAPREL";
			String scrID = StringUtil.checkNull(commandMap.get("scrID"));
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String srType = StringUtil.checkNull(commandMap.get("srType"));
			String srStatus = StringUtil.checkNull(commandMap.get("srStatus"));
			String scrStatus = StringUtil.checkNull(commandMap.get("scrStatus"));
			String svcCompl = StringUtil.checkNull(commandMap.get("svcCompl"));

			updateData.put("scrID", scrID);			
			updateData.put("status", scrStatus);		
			updateData.put("lastUser", commandMap.get("sessionUserId"));
			commonService.insert("scr_SQL.updateSCR", updateData);	
			
			updateData.put("srID", srID);			
			updateData.put("lastUser", commandMap.get("sessionUserId"));	
			
			// ESM_PROC_CONFIG : SpeCode, ProcPathID
			updateData.put("srType", srType);
			updateData.put("status", srStatus);
			updateData.put("languageID",commandMap.get("sessionCurrLangType"));
			String speCode = ESPUtil.getNextSpeCode(request, commonService, updateData);
			updateData.put("status", speCode);
			updateData.put("svcCompl", svcCompl);
		
			commonService.update("esm_SQL.updateESMSR", updateData);	
			
			//Save PROC_LOG
			String procRoleTP = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRProcRoleTP", updateData));
			updateData.put("speCode", speCode);
			updateData.put("procRoleTP", procRoleTP);
			Map setProcMapRst = (Map)setProcLog(request, commonService, updateData);
			if(setProcMapRst.get("type").equals("FAILE")){
				String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
				System.out.println("Msg : "+Msg);
			}
			
			//======================================================================================================
			
			model.put("scrID", scrID);
			model.put("srID", srID);
			
			target.put(AJAX_SCRIPT, "parent.fnCallBack();$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping("/viewRFCPSCRDetail.do")
	public String viewRFCPSCRDetail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esp/rfcp/viewRFCPSCRDetail";
		Map setData = new HashMap();
		try {	
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			String screenMode = StringUtil.checkNull(request.getParameter("screenMode"));
			String scrID = StringUtil.checkNull(commandMap.get("scrID"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String tabNo = StringUtil.checkNull(request.getParameter("tabNo"));
			
			setData.put("scrID", scrID);
			setData.put("languageID", languageID);			
			Map scrInfo = commonService.select("scr_SQL.getSCR_gridList", setData);
			
			String Description = StringUtil.checkNull(scrInfo.get("Description"),"");
			Description = StringUtil.replaceFilterString(Description);
			
			scrInfo.put("Description", Description);
			model.put("scrInfo", scrInfo);			

			String srID = StringUtil.checkNull(scrInfo.get("SRID"));
			setData.put("srID",srID);
			setData.put("languageID",languageID);			
			Map srInfo = commonService.select("esm_SQL.getESMSRInfo", setData); 
			
			String CTRYN = StringUtil.checkNull(scrInfo.get("CTRYN"));
			String ctrCLSYN = "N";
			if(CTRYN.equals("Y")){
				setData.put("status", "CTSCLS");
				String clsSCtsCNT = StringUtil.checkNull(commonService.selectString("ctr_SQL.getCTRCNT", setData));
				if(Integer.parseInt(clsSCtsCNT) > 0){
					ctrCLSYN = "Y";
				}
			}else{
				ctrCLSYN = "Y";
			}
			setData.put("status", "CLS");
			String scrIngCount = commonService.selectString("scr_SQL.getScrCNT", setData);
			System.out.println("scrIngCount :" + scrIngCount);
			if (scrIngCount.equals("1")) {
				model.put("SRCMPYN", "Y");
			}

			// 시스템 날짜
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
			
			model.put("thisYmd", thisYmd);
			
			// WF
			setData.put("srTypeCode", StringUtil.checkNull(srInfo.get("SRType")));				
			Map srTypeInfo = commonService.select("esm_SQL.getESMSRTypeInfo",setData);
			model.put("WFDocURL", StringUtil.checkNull(srTypeInfo.get("WFDocURL")));
			
			model.put("ctrCLSYN", ctrCLSYN);		
			model.put("srInfo", srInfo);
			model.put("srID", srID);
			model.put("scrID", scrID);
			model.put("csrID",scrInfo.get("CSRID"));
			
			model.put("screenMode", screenMode);
			model.put("tabNo",tabNo);
				
			String title = "SCR "+getLabel(request, commonService).get("LN00108");
			if(screenMode.equals("E")){	title = "SCR "+getLabel(request, commonService).get("LN00046"); }
			model.put("title", title);
			
			setData.put("srCatID", StringUtil.checkNull(srInfo.get("SubCategory")));			
			List srCatAttrSpeCodeNameList = commonService.selectList("esm_SQL.getSRCatAttrSpeCodeNameList", setData);
			model.put("srCatAttrSpeCodeNameList", srCatAttrSpeCodeNameList);
			model.put("speCode", srInfo.get("Status"));
			
			setData.put("attrTypeCode","AT00001" );
			setData.put("identifier", srInfo.get("Status"));
			String srStatusName = commonService.selectString("item_SQL.getPlainTextByIdentifier", setData);
			model.put("srStatusName", srStatusName);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/updateRFCPSCRMaster.do")
	public String updateRFCPSCRMaster(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
	
		try {
			String scrID = StringUtil.checkNull(commandMap.get("scrID"));
			
			// SRCategory Attr Save 
			Map setData = new HashMap();
			setData.put("srID", StringUtil.checkNull(request.getParameter("srID")) );
			setData.put("scrID", scrID);
			setData.put("SRCatID", StringUtil.checkNull(request.getParameter("srCatID")) );
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			setData.put("speCode", StringUtil.checkNull(commandMap.get("clickedSpeCode")) );
			setData.put("docCategory", StringUtil.checkNull(commandMap.get("docCategory")));
			List scrCatAttrList = commonService.selectList("scr_SQL.getSCRCatAttrList", setData);
			String attrTypeCodeList = "";
			if(scrCatAttrList.size() > 0) {
				for(int i=0; i<scrCatAttrList.size(); i++) {
					Map scrCatAttInfoMap = (Map)scrCatAttrList.get(i);
					if(i == 0) {
						attrTypeCodeList = "'"+StringUtil.checkNull(scrCatAttInfoMap.get("AttrTypeCode"))+"'";
					} else {
						attrTypeCodeList = attrTypeCodeList + ",'" +StringUtil.checkNull(scrCatAttInfoMap.get("AttrTypeCode")) + "'";
					}
				}
			}
			
			setData.put("attrTypeCodeList", attrTypeCodeList);
			commonService.update("scr_SQL.deleteSCRAttr", setData);	
			
			if(scrCatAttrList.size()>0) {
				setData.put("userID", commandMap.get("sessionUserId"));
				for(int i=0; i<scrCatAttrList.size(); i++) {
					Map scrCatAttrMap = (Map) scrCatAttrList.get(i);
					String attrTypeCode = StringUtil.checkNull(scrCatAttrMap.get("AttrTypeCode"));
					String dataType = StringUtil.checkNull(scrCatAttrMap.get("DataType"));
					String html = StringUtil.checkNull(scrCatAttrMap.get("HTML"));
					String value = StringUtil.checkNull(request.getParameter(attrTypeCode));
					String mLovValue = "";
					
					setData = new HashMap();
					setData.put("srID", StringUtil.checkNull(request.getParameter("srID")));
					setData.put("scrID", StringUtil.checkNull(request.getParameter("scrID")));
					setData.put("attrTypeCode", attrTypeCode);
					setData.put("value", value);	
					setData.put("userID", commandMap.get("sessionUserId"));
					setData.put("speCode", StringUtil.checkNull(commandMap.get("clickedSpeCode")));
					
					if(dataType.equals("MLOV")){							
						setData.put("attrTypeCode", attrTypeCode);
						setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
						
						List MLovList =  commonService.selectList("scr_SQL.getMLovListWidthScrAttr", setData);
						for(int j=0; MLovList.size()> j; j++) {
							Map MLovListMap = (Map)MLovList.get(j);
							String MLovValue = StringUtil.checkNull(commandMap.get(attrTypeCode+MLovListMap.get("CODE")));
							if(!MLovValue.equals("")) {
								setData.put("value", MLovValue);	
								setData.put("lovCode", MLovValue);	
								
								commonService.insert("scr_SQL.insertSCRAttr", setData);
							}
						}
					} else if(dataType.equals("MBR")) {
						if(!StringUtil.checkNull(commandMap.get(attrTypeCode)).equals("")){
							String attrMbr[] = StringUtil.checkNull(commandMap.get(attrTypeCode)).split(",");
							for(int z=0; z<attrMbr.length; z++) {
								setData.put("value", attrMbr[z]);	
								setData.put("lovCode", attrMbr[z]);	
								
								commonService.insert("scr_SQL.insertSCRAttr", setData);
							}
						}
					
					}else{	
						if(html.equals("1")){
							value =  StringEscapeUtils.escapeHtml4(value);
						}
						if(dataType.equals("LOV")) setData.put("lovCode", value);						
						commonService.insert("scr_SQL.insertSCRAttr", setData);
					}
				}
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
			target.put(AJAX_SCRIPT, "parent.fnCallBackSubTab('"+StringUtil.checkNull(commandMap.get("clickedSpeCode"))+"');parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/submitRFCPSCRMaster.do")
	public String submitRFCPSCRMaster(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
	
		try {
			HashMap updateData = new HashMap();
			
			String emailCode = "" ;
			String scrID = StringUtil.checkNull(commandMap.get("scrID"));
			
			// ESM_PROC_CONFIG : SpeCode, ProcPathID
			updateData.put("srType", StringUtil.checkNull(commandMap.get("srType")));
			updateData.put("status", StringUtil.checkNull(commandMap.get("srStatus")));
			updateData.put("languageID",commandMap.get("sessionCurrLangType"));
			updateData.put("srID", StringUtil.checkNull(commandMap.get("srID")));
			updateData.put("lastUser",commandMap.get("sessionUserId") );
			
			String speCode = ESPUtil.getNextSpeCode(request, commonService, updateData);
			
			updateData.put("status", speCode);
			updateData.put("scrID", scrID);			
			commonService.update("esm_SQL.updateESMSR", updateData);
			
			if(speCode.equals("SPE008")) { // 변경처리 완료 승인 이면 SCR CLOSE
				updateData.put("scrID", scrID);
				updateData.put("status","CLS");
				
				commonService.update("scr_SQL.updateSCR", updateData);
			}
			
			
			//Save PROC_LOG
			String srRoleTP = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRProcRoleTP",updateData));
			updateData.put("SRStatus", speCode);
			updateData.put("SRRoleTP", srRoleTP);
			updateData.put("sessionCurrLangType", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			Map setProcMapRst = (Map)setProcLog(request, commonService, updateData);
			if(setProcMapRst.get("type").equals("FAILE")){
				System.out.println("SAVE PROC_LOG FAILE Msg : "+StringUtil.checkNull(setProcMapRst.get("msg")));
			}
						
			// SRCategory Attr Save 
			Map setData = new HashMap();
			setData.put("srID", StringUtil.checkNull(request.getParameter("srID")) );
			setData.put("scrID", scrID);
			setData.put("SRCatID", StringUtil.checkNull(request.getParameter("srCatID")) );
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			setData.put("speCode", StringUtil.checkNull(commandMap.get("srStatus")) );
			setData.put("docCategory", StringUtil.checkNull(commandMap.get("docCategory")));
			
			List srCatAttrList = commonService.selectList("esm_SQL.getSRCatAttrList", setData);
			String attrTypeCodeList = "";
			if(srCatAttrList.size() > 0) {
				for(int i=0; i<srCatAttrList.size(); i++) {
					Map srCatAttInfoMap = (Map)srCatAttrList.get(i);
					if(i == 0) {
						attrTypeCodeList = "'"+StringUtil.checkNull(srCatAttInfoMap.get("AttrTypeCode"))+"'";
					} else {
						attrTypeCodeList = attrTypeCodeList + ",'" +StringUtil.checkNull(srCatAttInfoMap.get("AttrTypeCode")) + "'";
					}
				}
			}
			
			System.out.println("attrTypeCodeList :"+attrTypeCodeList);
			setData.put("attrTypeCodeList", attrTypeCodeList);
			commonService.update("esm_SQL.deleteSRAttr", setData);	
			
			if(srCatAttrList.size()>0) {
				setData.put("userID", commandMap.get("sessionUserId"));
				for(int i=0; i<srCatAttrList.size(); i++) {
					Map srCatAttrMap = (Map) srCatAttrList.get(i);
					String attrTypeCode = StringUtil.checkNull(srCatAttrMap.get("AttrTypeCode"));
					String dataType = StringUtil.checkNull(srCatAttrMap.get("DataType"));
					String html = StringUtil.checkNull(srCatAttrMap.get("HTML"));
					String value = StringUtil.checkNull(request.getParameter(attrTypeCode));
					String mLovValue = "";
					
					setData = new HashMap();
					setData.put("srID", StringUtil.checkNull(request.getParameter("srID")));
					setData.put("attrTypeCode", attrTypeCode);
					setData.put("value", value);	
					setData.put("userID", commandMap.get("sessionUserId"));
					
					if(dataType.equals("MLOV")){							
						setData.put("attrTypeCode", attrTypeCode);
						setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
						
						List MLovList =  commonService.selectList("attr_SQL.getMLovListWidthSRAttr", setData);
						for(int j=0; MLovList.size()> j; j++) {
							Map MLovListMap = (Map)MLovList.get(j);
							String MLovValue = StringUtil.checkNull(commandMap.get(attrTypeCode+MLovListMap.get("CODE")));
							if(!MLovValue.equals("")) {
								setData.put("value", MLovValue);	
								setData.put("lovCode", MLovValue);	
								
								commonService.insert("esm_SQL.insertSCRAttr", setData);
							}
						}
					} else if(dataType.equals("MBR")) {
						if(!StringUtil.checkNull(commandMap.get(attrTypeCode)).equals("")){
							String attrMbr[] = StringUtil.checkNull(commandMap.get(attrTypeCode)).split(",");
							for(int z=0; z<attrMbr.length; z++) {
								setData.put("value", attrMbr[z]);	
								setData.put("lovCode", attrMbr[z]);	
								
								commonService.insert("scr_SQL.insertSCRAttr", setData);
							}
						}
					}else{	
						if(html.equals("1")){
							value =  StringEscapeUtils.escapeHtml4(value);
						}
						if(dataType.equals("LOV")) setData.put("lovCode", value);						
						commonService.insert("esm_SQL.insertSCRAttr", setData);
					}
				}
			}
					
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
			target.put(AJAX_SCRIPT, "parent.fnCallBack('"+speCode+"');parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
}
