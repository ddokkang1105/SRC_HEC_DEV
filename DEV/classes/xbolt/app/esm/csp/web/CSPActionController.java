package xbolt.app.esm.csp.web;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.org.json.JSONArray;
import com.org.json.JSONObject;

import org.apache.commons.text.StringEscapeUtils;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
/**
 * 업무 처리
 * 
 * @Class Name : ESMActionController.java
 * @Description : 업무화면을 제공한다.
 * @Modification Information
 * @수정일 수정자 수정내용
 * @--------- --------- -------------------------------
 * @2016. 04.18 . smartfactory 최초생성
 * 
 * @since 2012. 09. 01.
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")
public class CSPActionController extends XboltController {
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "esmService")
	private CommonService esmService;
		
	@Resource(name = "CSService")
	private CommonService CSService;
	
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;	
	

	@RequestMapping(value = "/cspList.do")
	public String cspList(HttpServletRequest request, HashMap cmmMap,  HashMap commandMap,   ModelMap model) throws Exception {
		String url = "/app/esm/csp/cspList";
		try {
				String srType = StringUtil.checkNull(cmmMap.get("srType"),request.getParameter("srType")); 
				String itemID = StringUtil.checkNull(commandMap.get("s_itemID"),request.getParameter("itemID")); // Item Tab에서 리스트 출력 시 사용				
				String projectID = StringUtil.checkNull(commandMap.get("projectID"),""); 
				String srMode = StringUtil.checkNull(request.getParameter("srMode"));
				String reqCompany = StringUtil.checkNull(request.getParameter("reqCompany"));
				
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				
				String searchCategory = StringUtil.checkNull(cmmMap.get("category"));
				String searchSubCategory = StringUtil.checkNull(cmmMap.get("subCategory"));
				String searchSRCode = StringUtil.checkNull(cmmMap.get("searchSrCode"));
				String searchSRArea1 = StringUtil.checkNull(cmmMap.get("srArea1"));
				String searchSRArea2 = StringUtil.checkNull(cmmMap.get("srArea2"));
				String searchSubject = StringUtil.checkNull(cmmMap.get("subject"));
				String searchStatus = StringUtil.checkNull(cmmMap.get("searchStatus"));
				String searchSRStatus = StringUtil.checkNull(cmmMap.get("srStatus"),"ALL");
				String searchReceiptUser = StringUtil.checkNull(cmmMap.get("receiptUser"));
				String searchReceiptTeam = StringUtil.checkNull(cmmMap.get("srReceiptTeam"));
				String searchRequestTeam = StringUtil.checkNull(cmmMap.get("requestTeam"));
				String searchRequestUser = StringUtil.checkNull(cmmMap.get("requestUser"));
				String searchStartRegDT = StringUtil.checkNull(cmmMap.get("startRegDT"));
				String searchEndRegDT = StringUtil.checkNull(cmmMap.get("endRegDT"));
				String searchStartSRDueDT = StringUtil.checkNull(cmmMap.get("stSRDueDate"));
				String searchEndSRDueDT = StringUtil.checkNull(cmmMap.get("endSRDueDate"));
				
				Map setData = new HashMap();
				setData.put("srType",srType);
				setData.put("languageID", languageID);
				setData.put("level", 2);
				String srAreaLabelNM2 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				
				Map setMap = new HashMap();
				setMap.put("srTypeCode", srType);				
				Map SRTypeMap = commonService.select("esm_SQL.getESMSRTypeInfo",setMap);
				
				String companyID = StringUtil.checkNull(request.getParameter("companyID"));
				
				List companyList = commonService.selectList("crm_SQL.getCompnayTreeList", commandMap);
				String companyIDList = ""; 
				if(companyList.size()>0){
					for(int i=0; companyList.size()>i; i++){
						Map companyData = (Map)companyList.get(i);
						if(i==0){
							companyIDList = StringUtil.checkNull(companyData.get("TeamID"));
						}else{
							companyIDList = companyIDList + "," +StringUtil.checkNull(companyData.get("TeamID"));
						}
					}
				}
				
				model.put("companyIDList", companyIDList);
				model.put("itemProposal", StringUtil.checkNull(SRTypeMap.get("ItemProposal")));		
				model.put("itemTypeCode", SRTypeMap.get("ItemTypeCode"));				
				model.put("srAreaLabelNM2", srAreaLabelNM2);
				model.put("refID", projectID);
				model.put("scrnType", scrnType);
				model.put("srStatus", searchSRStatus);
				model.put("srMode", srMode);
				model.put("srType", srType);
				model.put("projectID", projectID);
				model.put("itemID", itemID);
				model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum")) );
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("srID", srID);
				model.put("mainType", StringUtil.checkNull(request.getParameter("mainType")));
				model.put("sysCode", StringUtil.checkNull(request.getParameter("sysCode")));
				model.put("companyID", companyID);
				model.put("reqCompany", reqCompany);	
				
				//검색조건 setting		
				model.put("category", searchCategory);
				model.put("subCategory", searchSubCategory);
				model.put("srArea1", searchSRArea1);
				model.put("srArea2", searchSRArea2);
				model.put("subject", searchSubject);
				model.put("status", StringUtil.checkNull(cmmMap.get("status")));				
				model.put("receiptUser", searchReceiptUser);
				model.put("requestUser", searchRequestUser);
				model.put("requestTeam", searchRequestTeam);
				model.put("startRegDT", searchStartRegDT);
				model.put("endRegDT", searchEndRegDT);
				model.put("stSRDueDate", searchStartSRDueDT);
				model.put("endSRDueDate", searchEndSRDueDT);
				model.put("searchSrCode", searchSRCode);
				model.put("srReceiptTeam", searchReceiptTeam);
				model.put("searchStatus", searchStatus);
				
				model.put("reqDateLimit", StringUtil.checkNull(request.getParameter("reqDateLimit")));
				
				if(srMode.equals("mySr")){
					model.put("requstUser", cmmMap.get("sessionUserNm"));
				}
				
				// searchOption setting 
				Map cspMap = new HashMap();
				cspMap.put("languageID", languageID);
				cspMap.put("scrnType", scrnType);
				cspMap.put("srMode", srMode);
				cspMap.put("srType", srType);
				cspMap.put("itemID", itemID);
				cspMap.put("companyList", companyIDList);
								
				if(!"".equals(searchStatus) || !"".equals(searchSRStatus)){
					cspMap.put("srStatus", searchSRStatus);
				}
				
				if("mySR".equals(srMode) || srMode == "myTR"){
					cspMap.put("loginUserId",commandMap.get("sessionUserId"));
				} else if("PG".equals(srMode) || "PJT".equals(srMode)){
					cspMap.put("refID",projectID);
				} else if("myTeam".equals(srMode)){
					cspMap.put("myTeamId",commandMap.get("sessionTeamId"));
				}
				
				cspMap.put("srRegStartDT", searchStartRegDT);
				cspMap.put("srRegEndDT", searchEndRegDT);
				
				List cspList = commonService.selectList("esm_SQL.getEsrMSTList_gridList",cspMap);
				JSONArray gridData = new JSONArray(cspList);
				model.put("gridData",gridData);
				
				// srRcv 용 excel down grid
				//List excelList = commonService.selectList("esm_SQL.getSRSummaryList_gridList",cspMap);
				List excelList = new ArrayList();
				JSONArray excelData = new JSONArray(excelList);
				model.put("excelData",excelData);
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/registerCSP.do")
	public String registerCSP(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/esm/csp/registerCSP";
		
		try {
				List attachFileList = new ArrayList();
				Map setMap = new HashMap();
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType")); 
				String srType = StringUtil.checkNull(cmmMap.get("srType"),request.getParameter("srType")); 
				String parentId = StringUtil.checkNull(request.getParameter("parentID")); 
				String itemProposal = StringUtil.checkNull(cmmMap.get("itemProposal"));
				if(itemProposal.equals("Y")){
					url = "/app/esm/itmp/registerItsp";
				}
				
				//임시저장된 파일이 존재할 수 있으므로 삭제
				String path=GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
				if(!path.equals("")){FileUtil.deleteDirectory(path);}	
						
				// 시스템 날짜 
				Calendar cal = Calendar.getInstance();
				cal.setTime(new Date(System.currentTimeMillis()));
				String thisYmd = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());

				cal.add(Calendar.DATE, +14);
				String defaultDueDate = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
				
				cal = Calendar.getInstance();
				cal.add(Calendar.DATE, +7);
				String currDateAdd7 = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
				
				model.put("itemProposal", itemProposal);
				model.put("scrnType", StringUtil.checkNull(request.getParameter("scrnType")) );
				model.put("crMode", StringUtil.checkNull(request.getParameter("crMode")) );
				model.put("crFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
				model.put("menu", getLabel(request, commonService)); //  Label Setting 
				model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), "1"));
				model.put("thisYmd", thisYmd);
				model.put("defaultDueDate", defaultDueDate); // default 완료 예정일
				model.put("currDateAdd7", currDateAdd7);
				model.put("ParentID", parentId);
				model.put("scrnType", StringUtil.checkNull(request.getParameter("scrnType"), ""));
				model.put("srType", srType);
				model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID"), ""));
				model.put("srMode", StringUtil.checkNull(request.getParameter("srMode"), ""));
				// List 검색조건 setting
				model.put("category", StringUtil.checkNull(cmmMap.get("category")));
				model.put("srArea2", StringUtil.checkNull(cmmMap.get("srArea2")));
				model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
				model.put("srStatus", StringUtil.checkNull(cmmMap.get("srStatus")));				
				model.put("searchSrCode", StringUtil.checkNull(cmmMap.get("searchSrCode")));
				model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
				model.put("srReceiptTeam", StringUtil.checkNull(cmmMap.get("srReceiptTeam")));
				model.put("crReceiptTeam", StringUtil.checkNull(cmmMap.get("crReceiptTeam")));
				
				Map setData = new HashMap();
				setData.put("srType",srType);
				setData.put("languageID", cmmMap.get("sessionCurrLangType"));
				setData.put("level", 2);
				String srAreaLabelNM2 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				String stItemType = commonService.selectString("esm_SQL.getItemInfoForSRType",setData);
				
				model.put("stItemType", stItemType);
				model.put("srAreaLabelNM2", srAreaLabelNM2);
				model.put("fromSRID", StringUtil.checkNull(request.getParameter("fromSRID")));
				model.put("srArea1ListSQL", StringUtil.checkNull(request.getParameter("srArea1ListSQL")));
				
				//Call PROC_LOG START TIME
				setInitProcLog(request);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/createCSPMst.do")
	public String createCSPMst(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		try {
			HashMap setData = new HashMap();
			HashMap insertData = new HashMap();
			HashMap updateData = new HashMap();
			HashMap setMap = new HashMap();
			
			String maxSrId = "";
			String curmaxSRCode ="";
			String maxSRCode = "";
			String userID = "";
			String ProjectID = StringUtil.checkNull(xss.getParameter("ProjectID"));
			String proposal = StringUtil.checkNull(xss.getParameter("proposal"));
			String srMode = StringUtil.checkNull(xss.getParameter("srMode"));
			String scrnType = StringUtil.checkNull(xss.getParameter("scrnType"));
			String srType = StringUtil.checkNull(xss.getParameter("srType"));
			String requestUserID = StringUtil.checkNull(xss.getParameter("requestUserID"));
			String srArea2 = StringUtil.checkNull(xss.getParameter("srArea2"));
			String reqdueDate = StringUtil.checkNull(xss.getParameter("reqdueDate"));
			String reqDueDateTime = StringUtil.checkNull(xss.getParameter("reqDueDateTime"));
			String category = StringUtil.checkNull(xss.getParameter("category"));
			String subject = StringUtil.checkNull(xss.getParameter("subject"));
			String description = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(commandMap.get("description")));
			String itemIDs = StringUtil.checkNull(commandMap.get("itemIDs"));
			String emailCode = "SRREQ" ;
			String itemProposal =  StringUtil.checkNull(xss.getParameter("itemProposal"));
			String fromSRID =  StringUtil.checkNull(xss.getParameter("fromSRID"));
			String opinion =  StringUtil.checkNull(xss.getParameter("opinion"));
			
			setData.put("memberID", requestUserID);
			String companyID = StringUtil.checkNull(commonService.selectString("user_SQL.getMemberCompanyID", setData));
			
			/* 시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyMMdd").format(cal.getTime());
			setData.put("thisYmd", thisYmd);
			maxSrId = StringUtil.checkNull(commonService.selectString("esm_SQL.getMaxESMSrID", setData)).trim();
			curmaxSRCode = StringUtil.checkNull(commonService.selectString("esm_SQL.getMaxESMSRCode", setData)).trim();				
			if(curmaxSRCode.equals("")){ // 당일 CSR이 없으면
				maxSRCode = "SR"  + thisYmd + "0001";
			} else {
				curmaxSRCode = curmaxSRCode.substring(curmaxSRCode.length() - 4, curmaxSRCode.length());
				int curSRCode = Integer.parseInt(curmaxSRCode) + 1;
				maxSRCode =  "SR" +  thisYmd + String.format("%04d", curSRCode);			
			}
			
			String projectID = "";
			// 선택된 시스템(srArea2)의 ProjectID 취득 
			setData.put("srArea2", srArea2);
			projectID = StringUtil.checkNull(commonService.selectString("sr_SQL.getProjectIDFromL2", setData)).trim();
			
			setData.put("itemID",srArea2);
			String srArea1 = commonService.selectString("item_SQL.getParentItemID", setData);
			
			insertData.put("projectID", projectID);
			insertData.put("srID", maxSrId);
			insertData.put("srCode", maxSRCode);
			insertData.put("srType", srType);
			insertData.put("subject", subject);
			insertData.put("description", description);
			insertData.put("category", category); 
			insertData.put("requestUserID", requestUserID);
			insertData.put("srArea1", srArea1);
			insertData.put("srArea2", srArea2);
			insertData.put("regUserID", commandMap.get("sessionUserId"));
			insertData.put("regTeamID", commandMap.get("sessionTeamId"));
			insertData.put("companyID", companyID);	
			insertData.put("opinion", opinion);	
			if(!reqDueDateTime.equals("") ) {
				reqdueDate = reqdueDate+" "+reqDueDateTime;	
			}
			insertData.put("reqdueDate", reqdueDate);
			
			// 선택된 카테고리의 접수자/접수팀  정보 취득
			setData.put("srCatID", category);
			setData.put("srType", srType);
			Map RoleAssignMap =  commonService.select("esm_SQL.getESMSRAreaFromSrCat", setData);
			
			setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")) );			
			setData.put("itemClassCode", "CL03004");
//			List esmStatusList =  commonService.selectList("esm_SQL.getProcStatusList", setData);	
			//Map esmStatusFirst = (Map) esmStatusList.get(0);
			//String status = StringUtil.checkNull(esmStatusFirst.get("TypeCode"));
			
		//	String processType = "";
			String procPathID = "";
			if(!RoleAssignMap.isEmpty()){
				if(RoleAssignMap.get("SRArea").equals("SRArea1")){ 
					setData.put("srArea", srArea1 );
				}else{
					setData.put("srArea", srArea2 );
				}
				setData.put("RoleType", RoleAssignMap.get("RoleType"));	
			}
			//	processType = StringUtil.checkNull(RoleAssignMap.get("ProcessType"));
			procPathID = StringUtil.checkNull(RoleAssignMap.get("ProcPathID"));
			insertData.put("procPathID", procPathID);
						
			setMap.put("procPathID", procPathID);
			String startEventCode = StringUtil.checkNull(commonService.selectString("esm_SQL.getStartEventCode", setMap));
			insertData.put("status", startEventCode); 
			
			setData.put("userID", requestUserID);
			Map reqTeamInfoMap = commonService.select("user_SQL.memberTeamInfo", setData);
			insertData.put("requestTeamID",reqTeamInfoMap.get("TeamID"));
			
			String useCRM = StringUtil.checkNull(GlobalVal.USE_CRM);
			setData.put("teamID", companyID);
			String custGRNo = "";
			//if(useCRM.equals("Y")){
			custGRNo =  StringUtil.checkNull(commonService.selectString("crm_SQL.getCustGRNo", setData));
			insertData.put("custGRNo", custGRNo);
			//}
			
			Map receiptInfoMap = new HashMap();
			Map authorInfo = new HashMap();
			String receiptUserID ="";
			String receiptTeamID ="";
			setData.put("teamID", reqTeamInfoMap.get("TeamID"));
			receiptInfoMap = commonService.select("esm_SQL.getReceiptUser", setData);
			receiptUserID = StringUtil.checkNull(receiptInfoMap.get("UserID"));
			receiptTeamID = StringUtil.checkNull(receiptInfoMap.get("TeamID"));
			
			
			// 메일 수신자 설정
			Map receiverMap = new HashMap();
			List receiverList = new ArrayList();		
			if(!receiptInfoMap.isEmpty() && receiptInfoMap != null){
				setData.put("memberID", receiptUserID);
				Map checkMemberActiveInfo = commonService.select("user_SQL.getCheckMemberActive", setData);
				if(checkMemberActiveInfo != null && !checkMemberActiveInfo.isEmpty()){
					insertData.put("receiptUserID", checkMemberActiveInfo.get("MemberID"));
					insertData.put("receiptTeamID", checkMemberActiveInfo.get("TeamID"));
					receiverMap.put("receiptUserID", checkMemberActiveInfo.get("MemberID"));
				}else{
					insertData.put("receiptUserID", receiptUserID);
					insertData.put("receiptTeamID", receiptTeamID);
					receiverMap.put("receiptUserID", receiptUserID);
				}
				receiverList.add(0,receiverMap);
				
			}else{
				insertData.put("receiptUserID", "1");
				setData.put("userID", "1");
				Map recTeamInfoMap = commonService.select("user_SQL.memberTeamInfo", setData);
				insertData.put("receiptTeamID",recTeamInfoMap.get("TeamID"));
				receiverMap.put("receiptUserID", "1");
				receiverList.add(0,receiverMap);
			}
			
			//시스템 오류 건에 대해서 완료 처리 전 ITSM으로 바로 IF함//
		//	if(category.equals("SR4000") && StringUtil.checkNull(receiptInfoMap.get("TeamID")).equals("156")){	
		//		insertData.put("ITSMIF", "0");
		//		System.out.println( "Receipt TeamID=" + receiptInfoMap.get("TeamID"));
		//	}	
		
			// ItemProposal = Y
			String maxProcInstNo = "";
			// if(itemProposal.equals("Y")){
				insertData.put("proposal", proposal);
				
				maxProcInstNo = StringUtil.checkNull(commonService.selectString("instance_SQL.maxProcInstNo",setMap)).trim();
				maxProcInstNo = maxProcInstNo.substring(maxProcInstNo.length() - 5, maxProcInstNo.length());
				int curProcInstCode = Integer.parseInt(maxProcInstNo) + 1;
				String ProcInstNo = "P" + String.format("%09d", curProcInstCode);
				
//				insertData.put("ProcInstNo", ProcInstNo);
			//}
			
			setMap.put("srTypeCode",srType);
			setMap.put("procPathID", procPathID);
			Map srTypeMap = commonService.select("esm_SQL.getESMSRTypeInfo", setMap);
			
			insertData.put("defWFID", srTypeMap.get("DefWFID"));
			commonService.insert("esm_SQL.insertSRMst", insertData);
			
			if(!fromSRID.equals(null) && !fromSRID.equals("")) {
				insertData.put("srCxnCat","NULL");
				insertData.put("fromSRID",fromSRID);
				insertData.put("toSRID",maxSrId);
				insertData.put("status","OPN");
				insertData.put("creator",requestUserID);
				commonService.insert("esm_SQL.insertSrCxn", insertData);
			}
			
			// Sr 첨부파일 등록 : TB_SR_FILE 
			commandMap.put("projectID", projectID);
			insertESMSRFiles(commandMap, maxSrId);
			
			model.put("scrnType",scrnType);
			model.put("srMode", srMode);
			model.put("pageNum", StringUtil.checkNull(xss.getParameter("pageNum")));
			model.put("projectID", StringUtil.checkNull(xss.getParameter("projectID")));
			
			//Save PROC_LOG
			Map setProcMapRst = (Map)setProcLog(request, commonService, insertData);
			if(setProcMapRst.get("type").equals("FAILE")){
				System.out.println("SAVE PROC_LOG FAILE Msg : "+StringUtil.checkNull(setProcMapRst.get("msg")));
			}
				
			//Save PROC History			
			Map setProcHistory = new HashMap();
			
			Map ProcessInfo = commonService.select("esm_SQL.getProcPathItemID", setMap);
			
			setMap.put("s_itemID",projectID);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			Map pjtInfo = commonService.select("project_SQL.getProjectInfoView", setMap);
			
			setProcHistory.put("instanceNo", ProcInstNo);
			setProcHistory.put("processID", ProcessInfo.get("ItemID"));

			setProcHistory.put("procPathID", procPathID);
			setProcHistory.put("procModelID", srTypeMap.get("ProcModelID"));
			setProcHistory.put("ownerID", pjtInfo.get("AuthorID"));
			setProcHistory.put("ownerTeamID", pjtInfo.get("OwnerTeamID"));
			setProcHistory.put("status", "00");
			setProcHistory.put("dueDate", reqdueDate);
			setProcHistory.put("instanceClass", "CL03004");
			setProcHistory.put("documentNo", maxSrId);
			setProcHistory.put("procType", srType);
			setProcHistory.put("docCategory", "SR");
			
//			commonService.insert("instance_SQL.insertProcInst", setProcHistory);	
			
			// SR Area 1 Role type = 'A' 인 담당자에게  SR 접수 메일 발송
			setData.put("SRArea", srArea1);
			Map srWorkerListMap = commonService.select("esm_SQL.getSRWokerList", setData);
			String SRArea1AccountMember = StringUtil.checkNull(srWorkerListMap.get("MemberID"));
			String SRArea1AccountMemberRole = StringUtil.checkNull(srWorkerListMap.get("RoleType"));
			
			String mailOption = StringUtil.checkNull(RoleAssignMap.get("MailOption"));
			if((mailOption.equals("02") && SRArea1AccountMemberRole.equals("A"))){ 
				receiverMap = new HashMap();
				receiverMap.put("receiptUserID", SRArea1AccountMember);
				receiverMap.put("receiptType", "CC");
				receiverList.add(1,receiverMap);				
				//System.out.println("SRAREA1:SR5000:긴급변경 : "+SRArea1RoleAssignMentMap+" , receiverList : "+receiverList);
			}
			
			// 참조자 메일 발송 
			String sharers = StringUtil.checkNull(request.getParameter("sharers"));
			String refMembers[] = sharers.split(",");
			int receiverIndex = receiverList.size();
			
			   // 추가 승인자
		   	String approvers = StringUtil.checkNull(request.getParameter("approvers"));
		   	String approver[] = approvers.split(",");
		   	if(!approvers.equals("") && approvers != null){
		   		for(int i=0; approver.length > i; i++){
		   			setData = new HashMap();					
		   			setData.put("SRID", maxSrId);	
		   			setData.put("memberID", approver[i]);
		   			setData.put("sessionUserId", approver[i]);
		   			setData.put("mbrTeamID", commonService.selectString("user_SQL.userTeamID", setData));
		   			setData.put("assignmentType", "SRROLETP");	
		   			setData.put("roleType", "APRV");	
		   			setData.put("orderNum", i+1);	
		   			setData.put("assigned", "1");	
		   			setData.put("accessRight", "R");	
		   			setData.put("creator", commandMap.get("sessionUserId"));
		   			
		   			commonService.insert("esm_SQL.insertESMSRMember", setData);
		   		}
		   	}
		   	
			if(!sharers.equals("") && sharers != null){
				// Insert TB_MY_SR_MBR 				
				for(int i=0; refMembers.length > i; i++){
					setData = new HashMap();					
					setData.put("SRID", maxSrId);	
					setData.put("memberID", refMembers[i]);
		   			setData.put("sessionUserId", refMembers[i]);
		   			setData.put("mbrTeamID", commonService.selectString("user_SQL.userTeamID", setData));
					setData.put("assignmentType", "SRROLETP");	
					setData.put("roleType", RoleAssignMap.get("RoleType"));	
					setData.put("orderNum", i+1);	
					setData.put("assigned", "1");	
					setData.put("accessRight", "R");	
					setData.put("creator", commandMap.get("sessionUserId"));
					
					commonService.insert("esm_SQL.insertESMSRMember", setData);
					
					receiverMap = new HashMap();
					receiverMap.put("receiptUserID", refMembers[i]); 
					receiverMap.put("receiptType", "CC");
					receiverList.add(receiverIndex,receiverMap);
					receiverIndex++;
				}
			}
			System.out.println("receiverList :"+receiverList);
									
			//======================================
			//send Email
			insertData.put("receiverList", receiverList);
			Map setMailMapRst = (Map)setEmailLog(request, commonService, insertData, emailCode);
			System.out.println("setMailMapRst : "+setMailMapRst );
			
			if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
				setMap.put("srID", maxSrId);
				setMap.put("srType", srType);
				setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				HashMap cntsMap = (HashMap)commonService.select("esm_SQL.getESMSRInfo", setMap);
									
				cntsMap.put("userID", insertData.get("receiptUserID"));
				cntsMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				String receiptLoginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", cntsMap));
				cntsMap.put("loginID", receiptLoginID);
				
				cntsMap.put("emailCode", emailCode);
				String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", cntsMap));
				cntsMap.put("emailHTMLForm", emailHTMLForm);
								
				Map resultMailMap = EmailUtil.sendMail(mailMap,cntsMap, getLabel(request, commonService));
				//System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMapRst.get("msg")));
				
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnGoSRList();parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	private void insertESMSRFiles(HashMap commandMap, String srID) throws ExceptionUtil {
		Map fileMap  = new HashMap();
		List fileList = new ArrayList();
			try {
			int seqCnt = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", commandMap));		
			//Read Server File
			String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(commandMap.get("sessionUserId"))+"//";
			fileMap.put("fltpCode", "SRDOC");
			String filePath = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFilePath",fileMap)); 
			String targetPath = filePath;
			List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
			if(tmpFileList.size() != 0){
				for(int i=0; i<tmpFileList.size();i++){
					fileMap = new HashMap(); 
					HashMap resultMap = (HashMap)tmpFileList.get(i);
					fileMap.put("Seq", seqCnt);
					fileMap.put("DocumentID",srID);
					fileMap.put("DocCategory","SR");
					fileMap.put("projectID", commandMap.get("projectID"));
					fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
					fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
					fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
					fileMap.put("FileMgt", "SR");
					fileMap.put("FltpCode", "SRDOC");
					fileMap.put("userId", commandMap.get("sessionUserId"));
					fileMap.put("RegUserID", commandMap.get("sessionUserId"));
					fileMap.put("LastUser", commandMap.get("sessionUserId"));
					fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
					
					fileMap.put("KBN", "insert");
					fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");					
					fileList.add(fileMap);
					seqCnt++;
				}
			}
			if(fileList.size() != 0){
				esmService.save(fileList, fileMap);
			}
			
			if (!orginPath.equals("")) {
				FileUtil.deleteDirectory(orginPath);
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
	}
}
