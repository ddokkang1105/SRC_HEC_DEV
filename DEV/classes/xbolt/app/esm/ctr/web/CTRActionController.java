package xbolt.app.esm.ctr.web;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import xbolt.app.esp.main.util.ESPUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.sk.val.skGlobalVal;

import com.org.json.JSONArray;

/**
 * 업무 처리
 * 
 * @Class Name :
 * @Description : CTR 관리
 * @Modification Information
 * @수정일 수정자 수정내용 @--------- --------- -------------------------------
 * @
 * 
 *   @since
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")
public class CTRActionController extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "ctrService")
	private CommonService ctrService;
	
	@RequestMapping("/ctrList.do")
	public String ctrList(HttpServletRequest request, HashMap<String, String> commandMap, ModelMap model)
			throws Exception {

		String url = "/app/esm/itsp/ctr/ctrList";
		Map paramMap = new HashMap();
		String srID = StringUtil.checkNull(request.getParameter("srID"));
		String scrID = StringUtil.checkNull(request.getParameter("scrID"));
		String ctrMode = StringUtil.checkNull(request.getParameter("ctrMode"));
		String myCTR = StringUtil.checkNull(request.getParameter("myCTR"));
		String status = StringUtil.checkNull(request.getParameter("status"));

		try {

			Map<String, String> labelMap = getLabel(request, commonService);

			paramMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			paramMap.put("loginUserId", commandMap.get("sessionUserId"));
			paramMap.put("srType","ITSP");
			paramMap.put("languageID", commandMap.get("sessionCurrLangType"));
			paramMap.put("level", 1);
			model.put("sysArea1LabelNM", commonService.selectString("esm_SQL.getESMSRAreaLabelName",paramMap));
			paramMap.put("level", 2);
			model.put("sysArea2LabelNM", commonService.selectString("esm_SQL.getESMSRAreaLabelName",paramMap));
			
			if(!srID.equals("")) {
				paramMap.put("scrID", scrID);
				Map scrInfo = commonService.select("scr_SQL.getSCR_gridList", paramMap);			
				String scrStatus = StringUtil.checkNull(scrInfo.get("Status"),"");
				model.put("scrInfo", scrInfo);	
				model.put("scrStatus", scrStatus);
			}else {
				paramMap.put("srTypeCode","ITSP");
				Map SRTypeMap = commonService.select("esm_SQL.getESMSRTypeInfo",paramMap);
				model.put("itemTypeCode", SRTypeMap.get("ItemTypeCode"));
				
				Calendar cal = Calendar.getInstance();
				cal.setTime(new Date(System.currentTimeMillis()));
				String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
				cal.add(Calendar.DATE, -7);
				String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

				model.put("thisYmd", thisYmd);
				model.put("beforeYmd", beforeYmd);
				model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
				model.put("sysArea1", StringUtil.checkNull(request.getParameter("sysArea1"),""));
				model.put("sysArea2", StringUtil.checkNull(request.getParameter("sysArea2"),""));
				url = "/app/esm/itsp/ctr/searchCTRList";
			}
			
			model.put("menu", labelMap);
			model.put("srID", srID);
			model.put("scrID", scrID);
			model.put("ctrMode", ctrMode);
			model.put("myCTR", myCTR);
			model.put("status", status);
			model.put("srType", "ITSP");
			
			paramMap.put("srID", srID);
			paramMap.put("ctrMode", ctrMode);
			paramMap.put("myCTR", myCTR);
			List ctrList = commonService.selectList("ctr_SQL.getCTRMst_gridList",paramMap);
			JSONArray gridData = new JSONArray(ctrList);
			model.put("gridData",gridData);
			
			
		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/registerCTR.do")
	public String registerCTR(HttpServletRequest request, HashMap<String, String> commandMap, ModelMap model)
			throws Exception {
		try {
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String scrID = StringUtil.checkNull(request.getParameter("scrID"));
			String ctrID = StringUtil.checkNull(request.getParameter("ctrID"));
			//String ctrCode = getctrCode();
			String sysArea2 = "";
			
			Map<String, String> paramMap = new HashMap<String, String>();
			paramMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			paramMap.put("srID", srID);
			if(!srID.equals("")) {
				Map srIDData = (HashMap) commonService.select("esm_SQL.getESMSRInfo", paramMap);
				sysArea2 = StringUtil.checkNull(srIDData.get("SRArea2"));
				model.put("sysArea1", StringUtil.checkNull(srIDData.get("SRArea1")));
				model.put("sysArea2", sysArea2);
				
				paramMap.put("sysArea2", sysArea2);
				paramMap.put("assignmentType", "CTSROLETP");
				List<Object> ctrAssignedRoleList = commonService.selectList("ctr_SQL.getCTRAssignedRoleList", paramMap);
				String roleType = "";
				String roleMemberID = "";
				for(int i=0; i<ctrAssignedRoleList.size(); i++) {
					roleType = String.valueOf(((Map)ctrAssignedRoleList.get(i)).get("roleType"));
					model.put(roleType,ctrAssignedRoleList.get(i));
				}			
				if( model.get("EXE") == null && model.get("REQ") != null) {
					model.put("EXE", model.get("REQ"));
				}
				
				// speCode
				model.put("speCode", StringUtil.checkNull(srIDData.get("SRNextStatus")));
			}
			
			paramMap.put("ctrID", ctrID);
			if(!ctrID.equals("")) {
				Map ctrData = (HashMap) commonService.select("ctr_SQL.getCTRMst_gridList", paramMap);
				model.put("ctrData", ctrData);
			}
			
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			String thisTime = new SimpleDateFormat("hh:mm").format(cal.getTime());

			model.put("thisYmd", thisYmd);
			model.put("thisTime", thisTime);
			model.put("srID", srID);
			model.put("scrID", scrID);
			model.put("ctrID", ctrID);
			//model.put("ctrCode", ctrCode);

		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/app/esm/itsp/ctr/registerCTR");
	}
	
	@RequestMapping(value = "/updateCTRPop.do")
	public String updateCTR(HttpServletRequest request, HashMap<String, String> commandMap, HashMap cmmMap,ModelMap model)
			throws Exception {
		try {
			String registerType = StringUtil.checkNull(request.getParameter("registerType"));
			
			Map<String, String> paramMap = new HashMap<String, String>();
			
			HashMap setData = new HashMap();
			
			setData.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
			String ctrID = StringUtil.checkNull(request.getParameter("ctrID"));
			setData.put("ctrID", ctrID);
			Map ctrData = (HashMap) commonService.select("ctr_SQL.getCTRMst_gridList", setData);

			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			String thisTime = new SimpleDateFormat("HH:mm").format(cal.getTime());
			
			model.put("menu", getLabel(request, commonService));
			model.put("thisYmd", thisYmd);
			model.put("thisTime", thisTime);			
			model.put("ctrData", ctrData);
			model.put("registerType", registerType);
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/app/esm/itsp/ctr/updateCTR");
	}

	@RequestMapping(value = "/createCTRMst.do")
	public String ctrSave(MultipartHttpServletRequest request, HashMap<String, String> commandMap, ModelMap model) throws Exception {
		HashMap<String, String> target = new HashMap<String, String>();
		Map<String, String> failParam = new HashMap<String, String>();
		try {
			HashMap<String, String> setData = new HashMap<String, String>();
			HashMap<String, String> insertParam = new HashMap<String, String>();
			Map userInfo = new HashMap<String, String>();
			String loginID = String.valueOf(commandMap.get("sessionUserId"));
			String languageID = String.valueOf(commandMap.get("sessionCurrLangType"));
			String srID = request.getParameter("srID");
			String scrID = request.getParameter("scrID");
			String speCode = request.getParameter("speCode");
			String ctrCode = StringUtil.checkNull(request.getParameter("ctrCode"));
			String getUserID = "";
			String regDT = StringUtil.checkNull(request.getParameter("regDT"));
			String regTime = StringUtil.checkNull(request.getParameter("regTime"));
			
			String ctrID = commonService.selectString("ctr_SQL.getMaxCTRID", insertParam);
			//String ctrCode = getSctsCode();
			
			setData.put("ctrCode", ctrCode);
			int ctrCodeCnt = commonService.selectListTotCnt("ctr_SQL.getCTRCode", setData);
			if(ctrCodeCnt>0) {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00164"));
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
				model.addAttribute(AJAX_RESULTMAP, target);
				return nextUrl(AJAXPAGE);
			}
			String urgencyYN = StringUtil.checkNull(request.getParameter("urgencyYN"));
			String ifStatus = StringUtil.checkNull(request.getParameter("ifStatus"),"0");
			// CTS INSERT
			failParam.put("step", "CTR");
			insertParam.put("ctrID", ctrID);
			insertParam.put("ctrCode", ctrCode);
			insertParam.put("srID", srID);
			insertParam.put("scrID", scrID);
			insertParam.put("curWorkerID", request.getParameter("curWorkerID"));
			insertParam.put("sysArea1", request.getParameter("sysArea1"));
			insertParam.put("sysArea2", request.getParameter("sysArea2"));
			insertParam.put("urgencyYN", urgencyYN);
			insertParam.put("dueDate", request.getParameter("dueDate"));
			insertParam.put("status", request.getParameter("status"));
						
			getUserID = request.getParameter("regUserID");
			setData = new HashMap<String, String>();
			setData.put("userId",getUserID);
			userInfo = (HashMap) commonService.select("report_SQL.getUserInfo", setData);
			
			insertParam.put("regUserID", getUserID);
			insertParam.put("regTeamID", String.valueOf(userInfo.get("TeamID")));
			
			insertParam.put("regDT", regDT +" "+ regTime);
			insertParam.put("subject", request.getParameter("subject"));
			insertParam.put("Description", request.getParameter("Description"));
			
			getUserID = request.getParameter("reviewerID");
			insertParam.put("reviewerID", getUserID);
			insertParam.put("reviewerTeamID", request.getParameter("reviewerTeamID"));
/*			
			if(getUserID != null && !getUserID.equals("")) {
				setData = new HashMap<String, String>();
				setData.put("userId",getUserID);
				userInfo = (HashMap) commonService.select("report_SQL.getUserInfo", setData);

				insertParam.put("reviewerID", getUserID);
				insertParam.put("reviewerTeamID", String.valueOf(userInfo.get("TeamID")));
			}
			
			insertParam.put("approverID", request.getParameter("approverID"));
			insertParam.put("approverID", request.getParameter("approverID"));
*/			
			getUserID = request.getParameter("approverID");
			insertParam.put("approverID", getUserID);
			insertParam.put("approverTeamID", request.getParameter("approverTeamID"));
/*
			if(getUserID != null && !getUserID.equals("")) {
				setData = new HashMap<String, String>();
				setData.put("userId",getUserID);
				userInfo = (HashMap) commonService.select("report_SQL.getUserInfo", setData);

				insertParam.put("approverID", getUserID);
				insertParam.put("approverTeamID", String.valueOf(userInfo.get("TeamID")));
			}
*/			
			insertParam.put("CTUserID", request.getParameter("CTUserID"));
			insertParam.put("opApTeamID", request.getParameter("opApTeamID"));
			if(urgencyYN.equals("Y")) {
				insertParam.put("CTResult", request.getParameter("CTResult"));
				insertParam.put("CTExeDT", request.getParameter("CTExeDT"));
			}
			insertParam.put("ifStatus", ifStatus);
			insertParam.put("lastUser", loginID);
			insertParam.put("clientID", loginID);

			commonService.insert("ctr_SQL.insertCTR", insertParam);
			
			setData = new HashMap<String, String>();
			setData.put("srID",srID);
			setData.put("lastUser",loginID);
			setData.put("status",speCode);
			commonService.insert("esm_SQL.updateESMSR", setData);
			
			setData = new HashMap<String, String>();
			setData.put("scrID",scrID);
			setData.put("lastUser",loginID);
			setData.put("status","CTR");
			commonService.insert("scr_SQL.updateSCR", setData);

			ctsSendMail(ctrID,languageID, request);
			
			//Save PROC_LOG
			String procRoleTP = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRProcRoleTP", insertParam));
			insertParam.put("speCode", speCode);
			insertParam.put("procRoleTP", procRoleTP);
			Map setProcMapRst = (Map)setProcLog(request, commonService, insertParam);
			if(setProcMapRst.get("type").equals("FAILE")){
				String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
				System.out.println("Msg : "+Msg);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
																													// 성공
			target.put(AJAX_SCRIPT, "parent.returnSavectr();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.returnSavectr();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류
																													// 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/updateCTRInfo.do")
	public String ctrUpdate(HttpServletRequest request, HashMap<String, String> commandMap, ModelMap model)
			throws Exception {
		HashMap<String, String> target = new HashMap<String, String>();

		try {

			String loginID = String.valueOf(commandMap.get("sessionUserId"));
			String languageID = String.valueOf(commandMap.get("sessionCurrLangType"));
			
			String ctrID = request.getParameter("ctrID");
			String status = request.getParameter("status");
			String getUserID = "";
			
			Map userInfo = new HashMap<String, String>();
			Map<String, String> setData = new HashMap<String, String>();
			Map<String, String> updateParam = new HashMap<String, String>();
			
			String sqlID = "ctr_SQL.updateCTR";
			updateParam.put("ctrID", ctrID);
			updateParam.put("status", request.getParameter("status"));
			updateParam.put("curWorkerID", request.getParameter("curWorkerID"));
/*
			getUserID = request.getParameter("reviewerID");
			if(getUserID != null && !getUserID.equals("")) {
				setData = new HashMap<String, String>();
				setData.put("userId",getUserID);
				userInfo = (HashMap) commonService.select("report_SQL.getUserInfo", setData);

				updateParam.put("reviewerID", getUserID);
				updateParam.put("reviewerTeamID", String.valueOf(userInfo.get("TeamID")));
			}
*/
			updateParam.put("rewComment", request.getParameter("rewComment"));
			updateParam.put("reviewDT", request.getParameter("reviewDT"));

/*			
			getUserID = request.getParameter("approverID");
			if(getUserID != null && !getUserID.equals("")) {
				setData = new HashMap<String, String>();
				setData.put("userId",getUserID);
				userInfo = (HashMap) commonService.select("report_SQL.getUserInfo", setData);

				updateParam.put("approverID", getUserID);
				updateParam.put("approverTeamID", String.valueOf(userInfo.get("TeamID")));
			}
*/			
			updateParam.put("aprvStatus", request.getParameter("aprvStatus"));
			updateParam.put("approvalDT", request.getParameter("approvalDT"));
			updateParam.put("aprvComment", request.getParameter("aprvComment"));
			String CTExeDT = request.getParameter("CTExeDT");
			String oprApTime = request.getParameter("oprApTime");
			if(CTExeDT != null && oprApTime != null ) {
				updateParam.put("CTExeDT", CTExeDT+" "+oprApTime);
			}
			updateParam.put("CTResultTP", request.getParameter("CTResultTP"));
			updateParam.put("CTRemark", request.getParameter("CTRemark"));
			updateParam.put("CTResult", request.getParameter("CTResult"));
			updateParam.put("ifStatus", request.getParameter("ifStatus"));
			
			commonService.update(sqlID, updateParam);

			ctsSendMail(ctrID,languageID, request);
			
			// 완료 시 SR업데이트 및 로그처리
			//Save PROC_LOG
			if("CTSCLS".equals(status)){
				Map setMap = new HashMap();
				setMap.put("ctrID",ctrID);
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				setMap.put("srID", srID);
				setMap.put("resultParameter",request.getParameter("aprvStatus"));
				String speCode = StringUtil.checkNull(ESPUtil.getNextSpeCode(request,commonService,setMap));
				
				setMap.put("lastUser",loginID);
				setMap.put("status",speCode);
				commonService.insert("esm_SQL.updateESMSR", setMap);
				
				String procRoleTP = StringUtil.checkNull(commonService.selectString("esm_SQL.getSRProcRoleTP", setMap));
				setMap.put("speCode", speCode);
				setMap.put("procRoleTP", procRoleTP);
				Map setProcMapRst = (Map)setProcLog(request, commonService, setMap);
				if(setProcMapRst.get("type").equals("FAILE")){
					String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
					System.out.println("Msg : "+Msg);
				}
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
																													// 성공
			target.put(AJAX_SCRIPT, "parent.returnUpdatectr();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류
																													// 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/ctrDetail.do")
	public String ctrDetail(HttpServletRequest request, HashMap<String, String> commandMap, HashMap cmmMap,ModelMap model)
			throws Exception {
		try {

			Map<String, String> paramMap = new HashMap<String, String>();
			
			HashMap setData = new HashMap();
			
			setData.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
			String ctrID = StringUtil.checkNull(request.getParameter("ctrID"));
			setData.put("ctrID", ctrID);
			Map ctrData = (HashMap) commonService.select("ctr_SQL.getCTRMst_gridList", setData);

			setData.put("sysArea2", StringUtil.checkNull(ctrData.get("sysArea2")));
			setData.put("assignmentType", "CTSROLETP");
			List<Object> ctrAssignedRoleList = commonService.selectList("ctr_SQL.getCTRAssignedRoleList", setData);
			if(ctrAssignedRoleList.size()>0) {
				String roleType = "";
				String roleMemberID = "";
				for(int i=0; i<ctrAssignedRoleList.size(); i++) {
					roleType = String.valueOf(((Map)ctrAssignedRoleList.get(i)).get("roleType"));
					model.put(roleType,ctrAssignedRoleList.get(i));
				}			
				if( model.get("EXE") == null && model.get("REQ") != null) {
					model.put("EXE", model.get("REQ"));
				}
			}
								
			setData.put("srType","ITSP");
			setData.put("level", 1);
			model.put("sysArea1LabelNM", commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData));
			setData.remove("level");
			setData.put("level", 2);
			model.put("sysArea2LabelNM", commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData));

			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			String thisTime = new SimpleDateFormat("HH:mm").format(cal.getTime());
			
			model.put("menu", getLabel(request, commonService));
			model.put("thisYmd", thisYmd);
			model.put("thisTime", thisTime);			
			model.put("ctrData", ctrData);
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/app/esm/itsp/ctr/viewCTRDetail");
	}

	private String getCTRCode() throws Exception {
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date(System.currentTimeMillis()));
		String thisYmd = new SimpleDateFormat("yyMMdd").format(cal.getTime());
		Map setData = new HashMap();
		setData.put("thisYmd", thisYmd);
		
		String curmaxSctsCode = StringUtil.checkNull(commonService.selectString("ctr_SQL.getMaxCTRCode", setData)).trim();
		String maxSctsCode = "";
		if(curmaxSctsCode.equals("")){  
			maxSctsCode = "CTR"  + thisYmd + "0001";
		} else {
			curmaxSctsCode = curmaxSctsCode.substring(curmaxSctsCode.length() - 4, curmaxSctsCode.length());
			int curCRCode = Integer.parseInt(curmaxSctsCode) + 1;
			maxSctsCode =  "CTR" +  thisYmd + String.format("%04d", curCRCode);			
		}
		return maxSctsCode;

	}

	public void ctsSendMail(String ctrID, String languageID, HttpServletRequest request) throws Exception {
		HashMap setLogData = new HashMap();
		HashMap setSendData = new HashMap();
		HashMap paramMap = new HashMap();
		List receiverList = new ArrayList();
		
		String userID = "";
		String dicTypeCode = "";
		paramMap.put("ctrID", ctrID);
		paramMap.put("languageID", languageID);

		Map detailMap = (HashMap) commonService.select("ctr_SQL.getCTRMst_gridList", paramMap);
		String status = String.valueOf(detailMap.get("status")); 
		String urgencyYN = String.valueOf(detailMap.get("urgencyYN")); 
		String aprvStatus = String.valueOf(detailMap.get("aprvStatus")); 
		String subject = String.valueOf(detailMap.get("ctrCode"))+" "+String.valueOf(detailMap.get("subject"));

		String mailTitle = "";
		
		if(urgencyYN.equals("N")) {
			switch(status) {
			    case "CTSREQ": 
			    	userID = String.valueOf(detailMap.get("reviewerID"));
			    	dicTypeCode = "CTSREW";
			    	break;
			    case "CTSREW":
			    	userID = String.valueOf(detailMap.get("approverID"));
			    	dicTypeCode = "CTSAPREQ";
			    	break;
			    case "CTSAPRV": 
			    	userID = String.valueOf(detailMap.get("CTUserID"));
			    	if(aprvStatus.equals("2")){
			    		dicTypeCode = "CTSAPREL";
			    	}
			    	
			    	break;
			    case "CTSCMP": 
			    	break;
			    case "CTSCLS": 
			    	userID = String.valueOf(detailMap.get("regUserID"));
			    	if(detailMap.get("aprvStatus").equals("3")){
			    		dicTypeCode = "CTSAPRJT";
			    	}
			    	break;
			    default: 
			    	userID = String.valueOf(detailMap.get("regUserID"));
			    	break;
			}
		}else {
			switch(status) {
				case "CTSREQ": 
		    	userID = String.valueOf(detailMap.get("CTUserID"));
		    	dicTypeCode = "CTSEXE";
		    	break;
				case "CTSCMP": 
					userID = String.valueOf(detailMap.get("reviewerID"));
			    	dicTypeCode = "CTSREW";
					break;
			    case "CTSREW":
			    	userID = String.valueOf(detailMap.get("approverID"));
			    	dicTypeCode = "CTSAPREQ";
			    	break;
			    case "CTSCLS": 
			    	userID = String.valueOf(detailMap.get("regUserID"));
			    	if(aprvStatus.equals("2")){
			    		dicTypeCode = "CTSAPREL";
			    	}else if(aprvStatus.equals("3")) {
			    		dicTypeCode = "CTSAPRJT";			    		
			    	}
			    	break;
			    default: 
			    	userID = String.valueOf(detailMap.get("regUserID"));
			    	break;
			}
		}
		String hostIP = GlobalVal.EMAIL_HOST_IP;
		setLogData.put("receiptUserID", userID); 
		receiverList.add(0,setLogData);
		
		if(!dicTypeCode.equals("")) {
			setLogData.put("receiverList",receiverList);
			setLogData.put("languageID", languageID);
			setLogData.put("subject", subject);
			
			Map setMailMapRst = (Map)setEmailLog(request, commonService, setLogData, dicTypeCode);
			if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){

				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
				mailMap.put("dicTypeCode", "CTR");
				
				Map resultMailMap = EmailUtil.sendMail(mailMap, (HashMap) detailMap, getLabel(request, commonService));
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+ "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
			}
		}
	}

	/* CTS ATTACH FILE DELETE 로직 */
	@RequestMapping(value = "/ctrFileDelete.do")
	public String ctrFileDelete(HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		cmmMap.put("CtsReqID", StringUtil.checkNull(cmmMap.get("CtsReqID"), ""));
		cmmMap.put("ProcessCD", StringUtil.checkNull(cmmMap.get("ProcessCD"), "01"));
		cmmMap.put("Seq", StringUtil.checkNull(cmmMap.get("Seq"), ""));

		target = commonService.select("sk_cts_SQL.ctsAttchFile_select", cmmMap); // new mode

		try {

			String realFile = skGlobalVal.FILE_UPLOAD_CTS_DIR + target.get("FileName");
			File existFile = new File(realFile);
			existFile.delete();
			commonService.delete("sk_cts_SQL.deleteCTSAttch", cmmMap); // new mode

			// target.put(AJAX_ALERT, "파일 삭제가 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00075")); // 성공
		} catch (Exception e) {
			System.out.println(e);
			// target.put(AJAX_ALERT, "파일 삭제중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00076")); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/mainCTRList.do")
	public String mainCTRList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		try {
			HashMap setData = new HashMap();
			int listSize = Integer.parseInt(request.getParameter("listSize"));
			String myCTR = StringUtil.checkNull(request.getParameter("myCTR"));
			String ctrMode = StringUtil.checkNull(request.getParameter("ctrMode"));
			setData.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
			setData.put("loginUserId", cmmMap.get("sessionUserId"));
			setData.put("myCTR", myCTR);
			setData.put("ctrMode", ctrMode);
			setData.put("listSize", listSize);
			
			
			List ctrList = (List)commonService.selectList("ctr_SQL.getCTRMst_gridList", setData);
			
			setData.put("srType","ITSP");
			setData.put("level", 2);
			model.put("sysArea2LabeNM", commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData));
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("ctrList", ctrList);
			model.put("listSize", listSize);
			
		}		
		catch (Exception e) {System.out.println(e);throw new ExceptionUtil(e.toString());}		
		return nextUrl("/app/esm/itsp/ctr/mainCTRList");
	}	
	
	@RequestMapping(value = "/ctrCodeCheck.do")
	public String ctrCodeCheck(HttpServletRequest request, Map commandMap, ModelMap model)
			throws Exception {
		
		String languageID = String.valueOf(commandMap.get("sessionCurrLangType"));
		String ctrCode = StringUtil.checkNull(request.getParameter("ctrCode"));
		HashMap setData = new HashMap();
		HashMap target = new HashMap();
		try{
			setData.put("ctrCode", ctrCode);
			int ctrCodeCnt = commonService.selectListTotCnt("ctr_SQL.getCTRCode", setData);
			if(ctrCodeCnt>0) {
				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();returnCTRCodeCheck('N');");
			}else {
				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();returnCTRCodeCheck('Y');");
			}			
			model.addAttribute(AJAX_RESULTMAP, target);
		} catch (Exception e) {
			System.out.println(e);	
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();");
			
		}		
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/exeCTSInsertIF.do")
	public String exeCTSInsertIF(HttpServletRequest request, Map commandMap, ModelMap model)
			throws Exception {

		HashMap setData = new HashMap();
		HashMap target = new HashMap();
		try {
			commonService.insert("ctr_SQL.exeCTRInsertIF", setData);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
}
