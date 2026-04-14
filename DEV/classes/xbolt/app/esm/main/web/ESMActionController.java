package xbolt.app.esm.main.web;
import java.io.File;
import java.io.PrintWriter;
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
import javax.servlet.http.HttpServletResponse;

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
public class ESMActionController extends XboltController {
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "esmService")
	private CommonService esmService;
		
	@Resource(name = "CSService")
	private CommonService CSService;
	
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;	
		
	@RequestMapping(value = "/esmMgt.do")
	public String esmMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/esm/esmMgt"; 
		try {
				Map setMap = new HashMap();
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),request.getParameter("languageID")); 
				String itemID = StringUtil.checkNull(cmmMap.get("s_itemID"),request.getParameter("itemID")); 
				String parentId = StringUtil.checkNull(request.getParameter("s_itemID"));
				String srMode = StringUtil.checkNull(request.getParameter("srMode"));				
				String scrnType = StringUtil.checkNull(cmmMap.get("scrnType"),request.getParameter("")); 
				String mainType = StringUtil.checkNull(cmmMap.get("mainType"),request.getParameter("mainType"));
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String linkNodeID = StringUtil.checkNull(request.getParameter("linkNodeID"));
				String esTypeCode = StringUtil.checkNull(request.getParameter("esType"));
				String srTypeCode = StringUtil.checkNull(request.getParameter("srType"));
				
				// esm sr link detail
				if("".equals(srID) && linkNodeID != null && !"".equals(linkNodeID)){
					srID = linkNodeID;
					mainType = "mySRDtl";
				}
				
				Map esTypeMap = new HashMap();
				Map SRTypeMap = new HashMap();
				
				if(!esTypeCode.equals("")){
				     setMap.put("esTypeCode", esTypeCode);
					 esTypeMap = commonService.select("esm_SQL.getESTypeInfo",setMap);
					 String varFilter = StringUtil.checkNull(esTypeMap.get("VarFilter"));
					 String ESTypeUrl =  StringUtil.checkNull(esTypeMap.get("ESTypeUrl"));
					 model.put("varFilter", varFilter);
					 model.put("srTypeUrl", ESTypeUrl);
					 
				}else if (!srTypeCode.equals("")){
					
					setMap.put("srTypeCode", srTypeCode);
					SRTypeMap = commonService.select("esm_SQL.getESMSRTypeInfo",setMap);
					String varFilter = StringUtil.checkNull(SRTypeMap.get("VarFilter"));
					String srTypeUrl =  StringUtil.checkNull(SRTypeMap.get("SRTypeUrl"));
					model.put("varFilter", varFilter);
					model.put("srTypeUrl", srTypeUrl);
				}				
				model.put("scrnType", scrnType );
				model.put("srMode",  srMode);
				model.put("srType",  StringUtil.checkNull(request.getParameter("srType")));		
				model.put("defCategory",  StringUtil.checkNull(request.getParameter("defCategory")));		
				model.put("crMode", StringUtil.checkNull(request.getParameter("crMode")));
				model.put("srID",  srID);	
				model.put("sysCode",  StringUtil.checkNull(request.getParameter("sysCode")));	
				model.put("parentID", parentId);
				model.put("mainType", mainType);
				model.put("reqDateLimit",  StringUtil.checkNull(request.getParameter("reqDateLimit")));
				model.put("menu", getLabel(request, commonService)); /* Label Setting */		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/itspMain.do")
	public String itspMain(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception{
		Map setData = new HashMap();
		String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
		String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"));

		setData.put("languageID", languageID);
		setData.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
		setData.put("sessionUserId", languageID);
		setData.put("templCode", "TMPL003");		
		Map templateMap = commonService.select("menu_SQL.mainTempl_select",setData);
		
		model.put("templateMap", templateMap);
		model.put("menu", getLabel(request, commonService));	//Label Setting
		model.put("screenType", request.getParameter("screenType"));
		
		/* 문의 / 서비스요청 Cnt */
		setData.put("srType","ITSP");
		setData.put("loginUserId", userId);
		setData.put("srMode","mySR");
		setData.put("srStatus","ING");
		List srIngList = commonService.selectList("esm_SQL.getEsrMSTList_gridList",setData);
		
		setData.put("srStatus","SPE001");
		List srNewList = commonService.selectList("esm_SQL.getEsrMSTList_gridList",setData);
		
		if(srIngList != null && !srIngList.isEmpty()) {model.put("srIngCnt",srIngList.size());}
		else {model.put("srIngCnt","0");}
		
		if(srNewList != null && !srNewList.isEmpty()) {model.put("srNewCnt",srNewList.size());}
		else {model.put("srNewCnt","0");}
		
		/* 결재 Cnt */
		setData.put("actorID", userId);
		setData.put("wfMode", "AREQ");
		setData.put("filter", "myWF");
		List wfAREQList = commonService.selectList("wf_SQL.getWFInstList_gridList",setData);
		
		setData.put("wfMode", "CurAprv");
		List wfCurAprvList = commonService.selectList("wf_SQL.getWFInstList_gridList",setData);
		
		if(wfAREQList != null && !wfAREQList.isEmpty()) {model.put("wfAREQCnt",wfAREQList.size());}
		else {model.put("wfAREQCnt","0");}
		
		if(wfCurAprvList != null && !wfCurAprvList.isEmpty()) {model.put("wfCurAprvCnt",wfCurAprvList.size());}
		else {model.put("wfCurAprvCnt","0");}
		
		/* SCR Cnt */
		setData.put("scrMode", "ING");
		setData.put("mySCR", "Y");
		List scrIngList = commonService.selectList("scr_SQL.getSCR_gridList", setData);
		
		setData.put("status", "APREL");
		List scrAprelList = commonService.selectList("scr_SQL.getSCR_gridList", setData);
		
		if(scrIngList != null && !scrIngList.isEmpty()) {model.put("scrIngCnt",scrIngList.size());}
		else {model.put("scrIngCnt","0");}
		
		if(scrAprelList != null && !scrAprelList.isEmpty()) {model.put("scrAprelCnt",scrAprelList.size());}
		else {model.put("scrAprelCnt","0");}
		
		/* CTS Cnt */
		setData.put("ctrMode", "ING");
		setData.put("myCTR", "Y");
		setData.put("status", "");
		List ctsIngList = commonService.selectList("ctr_SQL.getCTRMst_gridList", setData);
		
		setData.put("ctrMode", "INPRG");
		List ctsApreqList = commonService.selectList("ctr_SQL.getCTRMst_gridList", setData);
		
		if(ctsIngList != null && !ctsIngList.isEmpty()) {model.put("ctsIngCnt",ctsIngList.size());}
		else {model.put("ctsIngCnt","0");}
		
		if(ctsApreqList != null && !ctsApreqList.isEmpty()) {model.put("ctsApreqCnt",ctsApreqList.size());}
		else {model.put("ctsApreqCnt","0");}
		
		return nextUrl("/app/esm/itsp/itspMain"); 
	}
	
	@RequestMapping(value = "/itspMgt.do")
	public String itspMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/itspMgt"; 
		try {
				String parentId = StringUtil.checkNull(request.getParameter("s_itemID"));
				String srMode = StringUtil.checkNull(request.getParameter("srMode"));				
				String scrnType = StringUtil.checkNull(cmmMap.get("screenType"),request.getParameter("scrnType")); 
				String mainType = StringUtil.checkNull(cmmMap.get("mainType"),request.getParameter("mainType"));
				String srType = StringUtil.checkNull(request.getParameter("srType"));
				String srTypeUrl = StringUtil.checkNull(request.getParameter("url"));
				String srArea1ListSQL = StringUtil.checkNull(request.getParameter("srArea1ListSQL"));
				String itemProposal = StringUtil.checkNull(cmmMap.get("itemProposal"),request.getParameter("itemProposal"));
				String focusMenu = StringUtil.checkNull(request.getParameter("focusMenu"));
				String multiComp = StringUtil.checkNull(request.getParameter("multiComp"));
				
				if(!srTypeUrl.equals("")){
					url = srTypeUrl;
				}
			
				if(scrnType.equals("srRqst") || scrnType.equals("srDsk")){ 
					url = "/app/esm/itsp/itspReqMain";
				}
							 
				model.put("srArea1ListSQL", srArea1ListSQL );
				model.put("itemProposal", itemProposal );
				model.put("scrnType", scrnType );
				model.put("srMode",  srMode);
				model.put("srType",  srType);			
				model.put("srID",  StringUtil.checkNull(request.getParameter("srID")));	
				model.put("sysCode",  StringUtil.checkNull(request.getParameter("sysCode")));	
				model.put("parentID", parentId);
				model.put("mainType", mainType);
				model.put("multiComp", multiComp);				
				model.put("menu", getLabel(request, commonService)); /* Label Setting */		
				model.put("focusMenu", focusMenu);
				model.put("srStatus", StringUtil.checkNull(request.getParameter("srStatus"),"ALL"));
				model.put("reqDateLimit",  StringUtil.checkNull(request.getParameter("reqDateLimit")));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/itspList.do")
	public String itspList(HttpServletRequest request, HashMap cmmMap,  HashMap commandMap,   ModelMap model) throws Exception {
		String url = "/app/esm/itsp/itspList";
		try {
				String srType = StringUtil.checkNull(cmmMap.get("srType"),request.getParameter("srType")); 
				String itemID = StringUtil.checkNull(commandMap.get("s_itemID"),request.getParameter("itemID")); // Item Tab에서 리스트 출력 시 사용				
				String projectID = StringUtil.checkNull(commandMap.get("projectID"),""); 
				String srMode = StringUtil.checkNull(request.getParameter("srMode"));
				String multiComp = StringUtil.checkNull(request.getParameter("multiComp"));
				String srArea1ListSQL = StringUtil.checkNull(request.getParameter("srArea1ListSQL"));
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
				String searchCRReceiptTeam = StringUtil.checkNull(cmmMap.get("crReceiptTeam"));
				
				if(searchStartRegDT.equals("")) {
					// 시스템 날짜 
					Calendar cal = Calendar.getInstance();
					cal.setTime(new Date(System.currentTimeMillis()));
					searchEndRegDT = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
	
					cal.add(Calendar.MONTH, -1);
					searchStartRegDT = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
				}
				
				
				Map setData = new HashMap();
				setData.put("srType",srType);
				setData.put("languageID", languageID);
				setData.put("level", 1);
				String srAreaLabelNM1 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
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
				model.put("srAreaLabelNM1", srAreaLabelNM1);
				model.put("srAreaLabelNM2", srAreaLabelNM2);
				model.put("refID", projectID);
				model.put("scrnType", scrnType);
				model.put("srStatus", searchSRStatus);
				model.put("srMode", srMode);
				model.put("srType", srType);
				model.put("projectID", projectID);
				model.put("itemID", itemID);
				//model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum")) );
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("srID", srID);
				model.put("mainType", StringUtil.checkNull(request.getParameter("mainType")));
				model.put("sysCode", StringUtil.checkNull(request.getParameter("sysCode")));
				model.put("companyID", companyID);
				model.put("multiComp", multiComp);	
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
				
				// searchOption setting 
				Map itspMap = new HashMap();
				
				itspMap.put("languageID", languageID);
				itspMap.put("scrnType", scrnType);
				itspMap.put("srMode", srMode);
				itspMap.put("srType", srType);
				itspMap.put("itemID", itemID);
				itspMap.put("category", searchCategory);
				itspMap.put("srCode", searchSRCode);
				itspMap.put("srArea1", searchSRArea1);
				itspMap.put("subject", searchSubject);
				itspMap.put("receiptUserName", searchReceiptUser);
				itspMap.put("requestTeam", searchRequestTeam);
				itspMap.put("requestUserName", searchRequestUser);
				itspMap.put("regStartDate", searchStartRegDT);
				itspMap.put("regEndDate", searchEndRegDT);
				itspMap.put("stSRDueDate", searchStartSRDueDT);
				itspMap.put("endSRDueDate", searchEndSRDueDT);
				
				if(!"".equals(searchSRArea2)){
					itspMap.put("srArea2",searchSRArea2);
				}
				if(!"".equals(searchReceiptTeam)){
					itspMap.put("srReceiptTeam",searchReceiptTeam);
				}
				if(!"".equals(searchCRReceiptTeam)){
					itspMap.put("crReceiptTeam",searchCRReceiptTeam);
				}
				if(!"".equals(searchSubCategory) || !"".equals(searchSubCategory)){
					itspMap.put("subCategory", searchSubCategory);
				}
				
				if(!"".equals(searchStatus) || !"".equals(searchSRStatus)){
					itspMap.put("srStatus", searchSRStatus);
				}
				
				if("mySR".equals(srMode) || srMode == "myTR"){
					itspMap.put("loginUserId",commandMap.get("sessionUserId"));
				} else if("PG".equals(srMode) || "PJT".equals(srMode)){
					itspMap.put("refID",projectID);
				} else if("myTeam".equals(srMode)){
					itspMap.put("myTeamId",commandMap.get("sessionTeamId"));
				}
				
				if("Y".equals(multiComp)){							
					if(!"".equals(reqCompany)){
						itspMap.put("companyID", reqCompany);
					}else{
						itspMap.put("companyID", companyIDList);
					}
				}else{
					if(companyIDList != "" & companyIDList != null) itspMap.put("companyID", companyIDList);
				}
				

				List itspList = commonService.selectList("esm_SQL.getEsrMSTList_gridList",itspMap);
				JSONArray gridData = new JSONArray(itspList);
				model.put("gridData",gridData);
				
				// srRcv 용 excel down grid
				/*
				 
				 List excelList =
				 commonService.selectList("esm_SQL.getSRSummaryList_gridList",itspMap);
				 JSONArray excelData = new JSONArray(excelList);
				 model.put("excelData",excelData);
				 
				 */
				model.put("srArea1ListSQL",srArea1ListSQL);
				
				if(srMode.equals("mySr")){
					model.put("requstUser", cmmMap.get("sessionUserNm"));
				}
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	private String checkSRSts(Map setData) throws Exception {
		List srStsList = commonService.selectList("esm_SQL.getProcStatusList", setData);  
		String checkSRSts = "N";
		if(srStsList.size()>0){
			checkSRSts = "Y";
		}
		return checkSRSts;
	}

	@RequestMapping(value = "/processItsp.do")
	public String processItsp(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/viewItspDetail";
		HashMap setData = new HashMap();
		try {
				List attachFileList = new ArrayList();
				Map setMap = new HashMap();
				Map getSRInfo = new HashMap();		
				Map getItemMap = new HashMap();
				
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType")); 
				String srID = StringUtil.checkNull(cmmMap.get("srID")); 
				String srType = StringUtil.checkNull(cmmMap.get("srType")); 
				String scrnType = StringUtil.checkNull(cmmMap.get("scrnType")); 
				String srMode = StringUtil.checkNull(cmmMap.get("srMode"));
				String pageNum = StringUtil.checkNull(cmmMap.get("pageNum"));
				String srCode = StringUtil.checkNull(cmmMap.get("srCode"));
				String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
				String srStatus = StringUtil.checkNull(cmmMap.get("srStatus"));
				String status = StringUtil.checkNull(cmmMap.get("status"));
				String receiptUserID = StringUtil.checkNull(cmmMap.get("receiptUserID"));
				String projectID = StringUtil.checkNull(cmmMap.get("projectID"));
				String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
				String isPopup = StringUtil.checkNull(cmmMap.get("isPopup"));	
				String mainType = StringUtil.checkNull(cmmMap.get("mainType"));	
				String multiComp = StringUtil.checkNull(cmmMap.get("multiComp"));
				String companyID = StringUtil.checkNull(cmmMap.get("companyID"));
				
				String itemProposal = StringUtil.checkNull(cmmMap.get("itemProposal"));
				if(itemProposal.equals("Y")) url = "/app/esm/itmp/viewItspDetail";
				
				if(srCode.equals("")){; // 외부에서 호출시 srID만 넘어옮
					setData.put("srID", srID);
					setData.put("srType", srType);
					setData.put("languageID", languageID);
					getSRInfo = commonService.select("esm_SQL.getESMSRInfo", setData);					
	
					if(!getSRInfo.isEmpty()){
						status = StringUtil.checkNull(getSRInfo.get("Status"));
						receiptUserID = StringUtil.checkNull(getSRInfo.get("ReceiptUserID"));
					}
				}
				
				// 시스템 날짜 
				Calendar cal = Calendar.getInstance();
				cal.setTime(new Date(System.currentTimeMillis()));
				String thisYmd = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
				
				/* 임시 문서 보관 디렉토리 삭제 */
				String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
				FileUtil.deleteDirectory(path);
				//String updateSRStatus = srStatus;
				setMap.put("srID", srID);
				
				setData.put("srID", srID);
				setData.put("srType", srType);
				setData.put("srCode", srCode);
				setData.put("languageID", languageID);
				Map srInfoMap = commonService.select("esm_SQL.getESMSRInfo", setData);	
				
				String stItemType = commonService.selectString("esm_SQL.getItemInfoForSRType",setData);
				
				model.put("stItemType", stItemType);
				
				String blocked = StringUtil.checkNull(srInfoMap.get("Blocked"));
				if(!scrnType.equals("srRqst") &&  // SR 등록 메뉴가 아니고
						 sessionUserID.equals(receiptUserID) &&  //  사용자 = 접수자 
						 blocked.equals("0") ) { // 상태는 조치완료나 마감이 아닐 경우  SR 접수 처리로 이동 
					if(!isPopup.equals("Y")){url = "/app/esm/itsp/processItsp";} // SR모니터링 팝업이 아니면
				}
							
				
				// proposal == 01 이메일 전송
				if(sessionUserID.equals(receiptUserID) && status.equals("SPE001") && StringUtil.checkNull(srInfoMap.get("Proposal")).equals("01")){ 
					//==============================================
					Map setMailData = new HashMap();
					//send Email
					setMailData.put("EMAILCODE", "PROPS");
					setMailData.put("subject", StringUtil.checkNull(srInfoMap.get("Subject")));
					//setMailData.put("receiptUserID", StringUtil.checkNull(srInfoMap.get("RequestUserID")));
					
					List receiverList = new ArrayList();
					Map receiverMap = new HashMap();
					receiverMap.put("receiptUserID", StringUtil.checkNull(srInfoMap.get("RequestUserID")));
					receiverList.add(0,receiverMap);
					setMailData.put("receiverList", receiverList);
					
					Map setMailMapRst = (Map)setEmailLog(request, commonService, setMailData, "PROPS");
					System.out.println("setMailMapRst( [PRIME - 제안연계 알림] ) : "+setMailMapRst );
					
					HashMap setMailMap = new HashMap();
					if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
						HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
						setMailMap.put("srID", srID);
						setMailMap.put("srType", srType);
						setMailMap.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
						HashMap cntsMap = (HashMap)commonService.select("esm_SQL.getESMSRInfo", setMailMap);
						
						cntsMap.put("srID", srID);	
						cntsMap.put("teamID", StringUtil.checkNull(srInfoMap.get("RequestTeamID")));					
						cntsMap.put("userID", StringUtil.checkNull(srInfoMap.get("RequestUserID")));
						cntsMap.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
						String requestLoginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", cntsMap));
						cntsMap.put("loginID", requestLoginID);
						
						Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, commonService));
						System.out.println("SEND EMAIL TYPE:"+resultMailMap+ "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
					}else{
						System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
					}
					//==============================================
				}
				
							
				List prLgInfoList = commonService.selectList("sr_SQL.getProLogInfo", setData);	// 진행 history		
				
				setData.put("srID", srID);
				setData.put("itemClassCode", "CL03004");
				List procStatusList = commonService.selectList("esm_SQL.getProcStatusList", setData);    // 예상 진행 리스트
				
								
				setData.put("procPathID", StringUtil.checkNull(srInfoMap.get("ProcPathID")) );
				setData.put("languageID", cmmMap.get("sessionCurrLangType"));
				//List srProcCaseList = commonService.selectList("esm_SQL.getProcPathList", setData);
				
				/* 첨부문서 취득 */
				attachFileList = commonService.selectList("sr_SQL.getSRFileList", setData);
				
				String appBtn = "N"; // app button 제어  
				if(!StringUtil.checkNull(srInfoMap.get("SubCategory")).equals("") 
						&& !StringUtil.checkNull(srInfoMap.get("Priority")).equals("") 
						&& !StringUtil.checkNull(srInfoMap.get("Comment")).equals("")
						//&& !StringUtil.checkNull(srInfoMap.get("Classification")).equals("")
						){
					appBtn = "Y";
				}
				
				/* View SR Comment 조회용 처리 */
			//	String comment = StringUtil.checkNull(srInfoMap.get("Comment"));
			//	String viewcomment = comment.replaceAll("\r","<br>");
			//	model.put("viewcomment", viewcomment);
				
				/* 담당자 정보 취득 */
				setData.put("MemberID", receiptUserID);
				Map authorInfoMap = commonService.select("item_SQL.getAuthorInfo", setData);	
				model.put("authorInfoMap", authorInfoMap); // 담당자 정보
				model.put("appBtn", appBtn);
				
				String Description = StringUtil.checkNull(srInfoMap.get("Description")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
				String Comment = StringUtil.checkNull(srInfoMap.get("Comment")).replaceAll("&lt;","<").replaceAll("&gt;", ">").replaceAll("&quot;","\"");
				srInfoMap.put("Description",Description);
				srInfoMap.put("Comment",Comment);
				
				setMap = new HashMap();
				setMap.put("srTypeCode", srType);				
				Map srTypeInfo = commonService.select("esm_SQL.getESMSRTypeInfo",setMap);
				
				setMap.put("srID", srID);
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));				
				List esmSRMbrList = commonService.selectList("esm_SQL.getESMSRMbr",setMap);
				String sharerNames = "";
				if(esmSRMbrList.size()>0){
					for(int i=0; i<esmSRMbrList.size(); i++){
						Map esmSRMbrInfo = (Map)esmSRMbrList.get(i);
						if(i==0){
							sharerNames = StringUtil.checkNull(esmSRMbrInfo.get("esmSRMbr"));
						}else{
							sharerNames = sharerNames + ", " + StringUtil.checkNull(esmSRMbrInfo.get("esmSRMbr"));
						}
					}
				}
				
				List spePrePostList = commonService.selectList("esm_SQL.getSpePrePostList",setData);
				Map spePrePostMap = new HashMap();
				Long statusNo = (long) 0;
				for(int i = 0; i < spePrePostList.size(); i++){
					Map getMap = (HashMap)spePrePostList.get(i);
					if(getMap.get("Identifier").equals(status)) {
						statusNo = (Long) getMap.get("RNUM");	// procPath에서의 현재상태 순서 구하기
					}
				}
				for(int i = 0; i < spePrePostList.size(); i++){
					Map getMap = (HashMap)spePrePostList.get(i);
					if((Long)getMap.get("RNUM") < statusNo) spePrePostMap.put(getMap.get("Identifier"), "PRE");
					if((Long)getMap.get("RNUM") == statusNo) spePrePostMap.put(getMap.get("Identifier"), "ON");
					if((Long)getMap.get("RNUM") > statusNo) spePrePostMap.put(getMap.get("Identifier"), "POST");
				}
				
				
				setData = new HashMap();
				setData.put("srID", srID);
								
				setData.put("status", "CLS");
				String openScrCNT = StringUtil.checkNull(commonService.selectString("scr_SQL.getScrCNT", setData));
				String scrCLSYN = "N";
				if(Integer.parseInt(openScrCNT)==0){
					scrCLSYN = "Y";
				}
				
				// check out 담당자가 여러명일 경우, 각자 check out 할 수 있도록 버튼 활성화
				setData.put("SRID",srID);
				setData.put("assignmentType","SRSHARE");
				setData.put("languageID", languageID);
				List srSharers = commonService.selectList("esm_SQL.getESMSRMember",setData);
				String srSharerName = "";
				String srSharerID = "";
				if(srSharers.size()>0){
					for(int i=0; i<srSharers.size(); i++){
						Map srSharerInfo = (Map)srSharers.get(i);
						if(i==0){
							srSharerName = StringUtil.checkNull(srSharerInfo.get("SRRefMember"));
							srSharerID = StringUtil.checkNull(srSharerInfo.get("MemberID"));
						}else{
							srSharerName = srSharerName + ", " + StringUtil.checkNull(srSharerInfo.get("SRRefMember"));
							srSharerID = srSharerID + "," + StringUtil.checkNull(srSharerInfo.get("MemberID"));
						}
					}
				}
				
				setData.put("procPathID", srInfoMap.get("ProcPathID"));
				setData.put("elmItemTypeCode", "OJ00003");
				//setData.put("elmClassCode", "CL03004");
				List elmCodeList = commonService.selectList("esm_SQL.getElmCodeList",setData);
				Map elmCodeMap = new HashMap();
				for(int i = 0; i < elmCodeList.size(); i++){
					Map getMap = (HashMap)elmCodeList.get(i);
					if(getMap != null){
						elmCodeMap.put(getMap.get("elmCode"), "Y");
					}
				}
				
				String createCSR = "N";
				setData.put("DueDate",new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime()));
				int csrCnt = Integer.parseInt(commonService.selectString("project_SQL.getCsrCntSR", setData));
				if(csrCnt > 0) {createCSR = "Y";}
				
				model.put("elmCodeMap", elmCodeMap);
				model.put("scrCLSYN", scrCLSYN);
				model.put("sharerNames", sharerNames);				
				model.put("WFDocURL", StringUtil.checkNull(srTypeInfo.get("WFDocURL")));				
				model.put("itemProposal", itemProposal);
				model.put("getItemMap",getItemMap);
				model.put("srInfoMap", srInfoMap);
				model.put("prLgInfoList", prLgInfoList);
				model.put("procStatusList", procStatusList);
			//	model.put("srProcCaseList", srProcCaseList);
				model.put("srFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
				model.put("SRFiles", attachFileList);
				model.put("scrnType", scrnType );
				model.put("srMode", srMode );
				model.put("srType", srType);				
				model.put("menu", getLabel(request, commonService)); //  Label Setting 
				model.put("pageNum", pageNum);
				model.put("thisYmd", thisYmd);
				model.put("projectID", projectID);
				model.put("srStatus", srStatus);
				model.put("itemID", itemID);
				model.put("isPopup", isPopup);
				model.put("srSharerName", srSharerName);
				model.put("srSharerID", srSharerID);
				model.put("createCSR", createCSR);
				model.put("status", StringUtil.checkNull(cmmMap.get("status")));				
				model.put("fromSRID", StringUtil.checkNull(request.getParameter("fromSRID")));
				model.put("srArea1ListSQL", StringUtil.checkNull(request.getParameter("srArea1ListSQL")));
				model.put("multiComp", multiComp);
				model.put("companyID", companyID);
				
				// 검색조건 Setting
				model.put("category", StringUtil.checkNull(cmmMap.get("category")));
				model.put("subCategory", StringUtil.checkNull(cmmMap.get("subCategory")));
				model.put("srArea1", StringUtil.checkNull(cmmMap.get("srArea1")));
				model.put("srArea2", StringUtil.checkNull(cmmMap.get("srArea2")));
				model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
				model.put("searchStatus", StringUtil.checkNull(cmmMap.get("searchStatus")));				
				model.put("receiptUser", StringUtil.checkNull(cmmMap.get("receiptUser")));
				model.put("requestUser", StringUtil.checkNull(cmmMap.get("requestUser")));
				model.put("requestTeam", StringUtil.checkNull(cmmMap.get("requestTeam")));
				model.put("startRegDT", StringUtil.checkNull(cmmMap.get("startRegDT")));
				model.put("endRegDT", StringUtil.checkNull(cmmMap.get("endRegDT")));
				model.put("stSRDueDate", StringUtil.checkNull(cmmMap.get("stSRDueDate")));
				model.put("endSRDueDate", StringUtil.checkNull(cmmMap.get("endSRDueDate")));	
				model.put("searchSrCode", StringUtil.checkNull(cmmMap.get("searchSrCode")));
				model.put("srReceiptTeam", StringUtil.checkNull(cmmMap.get("srReceiptTeam")));
				model.put("MULTI_COMPANY", GlobalVal.MULTI_COMPANY);			
				model.put("spePrePostMap", spePrePostMap);
				model.put("filePath", path);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/registerItsp.do")
	public String registerItsp(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/esm/itsp/registerItsp";
		
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
				model.put("srArea1", StringUtil.checkNull(cmmMap.get("srArea1")));
				model.put("srArea2", StringUtil.checkNull(cmmMap.get("srArea2")));
				model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
				model.put("srStatus", StringUtil.checkNull(cmmMap.get("srStatus")));				
				model.put("searchSrCode", StringUtil.checkNull(cmmMap.get("searchSrCode")));
				model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
				model.put("srReceiptTeam", StringUtil.checkNull(cmmMap.get("srReceiptTeam")));
				model.put("crReceiptTeam", StringUtil.checkNull(cmmMap.get("crReceiptTeam")));
				
				/* 외부에서 호출시 넘어온 sysCode로 SRArea1 ID 조회 Setting */
				String sysCode = StringUtil.checkNull(cmmMap.get("sysCode"));		
				String proposal = StringUtil.checkNull(cmmMap.get("proposal"));	
	
				if(!sysCode.equals("") && !sysCode.equals("undefined")){
					setMap = new HashMap();
					setMap.put("sysCode", sysCode);
					setMap.put("srType", srType);
					setMap.put("languageID", languageID);
					setMap.put("Identifier", sysCode);
					String srArea2 = StringUtil.checkNull(commonService.selectString("report_SQL.getItemIdWithIdentifier", setMap));
					setMap.put("srArea2", srArea2);
					Map getSRArea1 = commonService.select("common_SQL.getSrArea2_commonSelect", setMap);
					
					if(getSRArea1 != null)
						model.put("getSRArea1", getSRArea1.get("itemID"));
					else
						model.put("getSRArea1", "");
					model.put("getSRArea2", srArea2);
					model.put("sysCode", sysCode);
					model.put("proposal", proposal);
				}
				
				Map setData = new HashMap();
				setData.put("srType",srType);
				setData.put("languageID", cmmMap.get("sessionCurrLangType"));
				setData.put("level", 1);
				String srAreaLabelNM1 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				setData.put("level", 2);
				String srAreaLabelNM2 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				String stItemType = commonService.selectString("esm_SQL.getItemInfoForSRType",setData);
				
				model.put("stItemType", stItemType);
				model.put("srAreaLabelNM1", srAreaLabelNM1);
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
	
	
	@RequestMapping("/createItemForSR.do")
	public String createItemForSR(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
	
		Map setMap = new HashMap();
		HashMap target = new HashMap();	
		Map insertCngMap = new HashMap();
		Map updateData = new HashMap();
		
		try {
			Map setValue = new HashMap();
			String identifier = StringUtil.checkNull(request.getParameter("newIdentifier"));
			String addYN = StringUtil.checkNull(request.getParameter("addYN"));
			
			setValue.put("ItemID", request.getParameter("s_itemID"));
			setValue.put("Identifier", identifier);
			
			/* Identifier unique check */
			String itemCount = "0";
			String itemTypeCode = "";
			if (!identifier.isEmpty()) {
				itemCount = commonService.selectString("attr_SQL.identifierEqualCount", setValue);
			}
			
			//동일 ID 중복 시 팝업 창에 중복된 Item의 "항목계층명/경로/명칭"을 출력해 줌
			if (!itemCount.equals("0")) {
				setValue.put("languageID", commandMap.get("sessionCurrLangType"));
				//target.put(AJAX_ALERT, "동일한 ID가 "+commonService.selectString("attr_SQL.getEqualIdentifierInfo", setValue)+"에 존재 합니다. ");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00081", new String[]{commonService.selectString("attr_SQL.getEqualIdentifierInfo", setValue)}));
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			
			} else {
			
				String ItemID = commonService.selectString("item_SQL.getItemMaxID", setMap);
				
				setMap.put("option", request.getParameter("option"));			
				setMap.put("Version", "1");
				setMap.put("Deleted", "0");
				setMap.put("Creator", request.getParameter("authorID"));
				setMap.put("CategoryCode", "OJ");
				setMap.put("ClassCode", request.getParameter("itemClassCode"));
				setMap.put("OwnerTeamId", commandMap.get("sseionTeamId"));
				setMap.put("Identifier", request.getParameter("newIdentifier"));
				setMap.put("ItemID", ItemID);			
				setMap.put("ItemTypeCode", request.getParameter("itemTypeCode"));
				
				setMap.put("AuthorID", request.getParameter("authorID"));
				setMap.put("ProjectID", request.getParameter("projectID"));
				setMap.put("Status","NEW1");
				
				commonService.insert("item_SQL.insertItem", setMap);
				
				setMap.put("PlainText", request.getParameter("newItemName"));
				setMap.put("AttrTypeCode","AT00001");			
				List getLanguageList = commonService.selectList("common_SQL.langType_commonSelect", setMap);			
				for(int i = 0; i < getLanguageList.size(); i++){
					Map getMap = (HashMap)getLanguageList.get(i);
					setMap.put("languageID", getMap.get("CODE") );				
					commonService.insert("item_SQL.ItemAttr", setMap);
				}			
				
				/* 신규 생성된 ITEM의 ITEM_CLASS.ChangeMgt = 1 일 경우, CHANGE_SET 테이블에 레코드 생성  */
				setMap.put("ItemID", ItemID);
				String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));
				if (changeMgt.equals("1")) {
					/* Insert to TB_CHANGE_SET */
					insertCngMap.put("itemID", ItemID);
					insertCngMap.put("userId", request.getParameter("authorID"));
					insertCngMap.put("projectID", request.getParameter("projectID"));
					insertCngMap.put("classCode", request.getParameter("itemClassCode"));
					insertCngMap.put("KBN", "insertCNG");
					insertCngMap.put("status", "MOD");
					insertCngMap.put("version", "1.0");
					CSService.save(new ArrayList(), insertCngMap);
				}else if(!changeMgt.equals("1")){ 
					/* ChangeMgt !=1 인 경우 ParentItem의 CurChangeSet Update */
					String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
					setMap.put("itemID",s_itemID);
					String sItemIDCurChangeSetID = StringUtil.checkNull(commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap));
					if(!sItemIDCurChangeSetID.equals("")){
						updateData = new HashMap();
						updateData.put("CurChangeSet", sItemIDCurChangeSetID);
						updateData.put("s_itemID", ItemID);
						commonService.update("project_SQL.updateItemStatus", updateData);
					}
				}			
			
				target.put(AJAX_SCRIPT, "this.doReturnInsert('"+addYN+"','"+ItemID+"');this.$('#isSubmit').remove();");
			}
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/createESRMst.do")
	public String createESRMst(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
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
			String esType = StringUtil.checkNull(xss.getParameter("esType"),"");
			String srType = StringUtil.checkNull(xss.getParameter("srType"));
			String requestUserID = StringUtil.checkNull(xss.getParameter("requestUserID"));
			String srArea1 = StringUtil.checkNull(xss.getParameter("srArea1"));
			String srArea2 = StringUtil.checkNull(xss.getParameter("srArea2"));
			String reqdueDate = StringUtil.checkNull(xss.getParameter("reqdueDate"));
			String reqDueDateTime = StringUtil.checkNull(xss.getParameter("reqDueDateTime"));
			String category = StringUtil.checkNull(xss.getParameter("category"));
			String defCategory = StringUtil.checkNull(xss.getParameter("defCategory"));
			if(!"".equals(defCategory)){
				category = defCategory;
			} else {
				if("".equals(category)){
					category = "ISP100";
				}
			}
			String srReason = StringUtil.checkNull(xss.getParameter("srReason"));
			String itsmIF = StringUtil.checkNull(xss.getParameter("itsmIF"));
			String subject = StringUtil.checkNull(xss.getParameter("subject"));
			String description = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(commandMap.get("description")));
			String itemIDs = StringUtil.checkNull(commandMap.get("itemIDs"));
			String emailCode = "SRREQ" ;
			String itemProposal =  StringUtil.checkNull(xss.getParameter("itemProposal"));
			String fromSRID =  StringUtil.checkNull(xss.getParameter("fromSRID"));
			String srArea3 = StringUtil.checkNull(commandMap.get("rootItemID"));	// 개정 요청할 item
			String itemTypeCode = "";
			if(srArea3.isEmpty()) {	       srArea3 = "0";	} 
			String opinion =  StringUtil.checkNull(xss.getParameter("opinion"));
			
			setData.put("memberID", requestUserID);
			String companyID = StringUtil.checkNull(commonService.selectString("user_SQL.getMemberCompanyID", setData));
			setData.put("sessionUserId",requestUserID);
			String customerNo = StringUtil.checkNull(commonService.selectString("user_SQL.userClientID", setData));
			
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
			if(srArea3.equals("0")) {	// ISP : item이 지정 안된 경우
				if(ProjectID.equals("")) {
					// 선택된 시스템(srArea2)의 ProjectID 취득 
					setData.put("srArea2", srArea2);
					projectID = StringUtil.checkNull(commonService.selectString("sr_SQL.getProjectIDFromL2", setData)).trim();
				} else { // ISP CSR에서 등록
					projectID = ProjectID;
				}
			} else {	//ISP  : item(SRAea3)이 지정된 경우 상위 item에서 SR Area2  SR Area 1을  Search
				// srArea1, srArea2 classCode 조회
				setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")) );			
				setData.put("srType", srType);
				setData.put("itemID", srArea3);
				setData.put("itemTypeCode", itemTypeCode);
				setData.put("level", "1");
				String srArea1ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);
				setData.put("classCode", srArea1ClsCode);
				srArea1 = commonService.selectString("esm_SQL.getSuperiorItemByClass", setData);
				
				setData.put("level", "2");
				String srArea2ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);
				setData.put("classCode", srArea2ClsCode);
				srArea2 = commonService.selectString("esm_SQL.getSuperiorItemByClass", setData);
				
				// 변경제안 아이템의 projectID
				projectID = commonService.selectString("item_SQL.getProjectIDFromItem",setData);
				insertData.put("itemTypeCode", itemTypeCode);
			}
			insertData.put("itemTypeCode", itemTypeCode);
			insertData.put("projectID", projectID);
			insertData.put("srID", maxSrId);
			insertData.put("srCode", maxSRCode);
			insertData.put("esType", esType);
			insertData.put("srType", srType);
			insertData.put("subject", subject);
			insertData.put("description", description);
			insertData.put("category", category); 
			insertData.put("requestUserID", requestUserID);
			insertData.put("srArea1", srArea1);
			insertData.put("srArea2", srArea2);
			insertData.put("srArea3", srArea3);
			insertData.put("regUserID", commandMap.get("sessionUserId"));
			insertData.put("regTeamID", commandMap.get("sessionTeamId"));
			insertData.put("companyID", companyID);	
			insertData.put("clientID", customerNo);	
			insertData.put("opinion", opinion);	
			insertData.put("srReason", srReason);	
			insertData.put("itsmIF", itsmIF);	
			
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

			String procPathID = "";
			if(!RoleAssignMap.isEmpty() && srArea3.equals("0")){
				if(RoleAssignMap.get("SRArea").equals("SRArea1")){ 
					setData.put("srArea", srArea1 );
				}else{
					setData.put("srArea", srArea2 );
				}
				setData.put("RoleType", RoleAssignMap.get("RoleType"));	
			}
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
			if(useCRM.equals("Y")){
				custGRNo =  StringUtil.checkNull(commonService.selectString("crm_SQL.getCustGRNo", setData));
				insertData.put("custGRNo", custGRNo);
			}
			
			Map receiptInfoMap = new HashMap();
			Map authorInfo = new HashMap();
			String receiptUserID ="";
			String receiptTeamID ="";
			setData.put("teamID", reqTeamInfoMap.get("TeamID"));
			if(srArea3.equals("0")) {
				receiptInfoMap = commonService.select("esm_SQL.getReceiptUser", setData);
				receiptUserID = StringUtil.checkNull(receiptInfoMap.get("UserID"));
				receiptTeamID = StringUtil.checkNull(receiptInfoMap.get("TeamID"));
				
			} else {	// ISP item 지정
				setData.put("s_itemID", srArea3);
				authorInfo = commonService.select("item_SQL.getObjectInfo", setData);
				
				receiptUserID = StringUtil.checkNull(authorInfo.get("AuthorID"));
				receiptTeamID = StringUtil.checkNull(authorInfo.get("OwnerTeamID"));
				receiptInfoMap = authorInfo;
			}
			
			setData.put("srTypeCode",srType);
			if(receiptUserID.equals("")) {
				authorInfo = commonService.select("esm_SQL.getESMSRTypeInfo", setData);
				receiptUserID = StringUtil.checkNull(authorInfo.get("ManagerID"));
				receiptTeamID = StringUtil.checkNull(authorInfo.get("TeamID"));
				
				receiptInfoMap.put("receiptUserID",receiptUserID);
				receiptInfoMap.put("receiptTeamID",receiptTeamID);
			}
						
			if(receiptUserID.equals("")) {
				receiptUserID = "1";
				receiptTeamID = "1";
				receiptInfoMap.put("receiptUserID","1");
				receiptInfoMap.put("receiptTeamID","1");
			}
			
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
			
			String maxProcInstNo = "";
			insertData.put("proposal", proposal);
			
			maxProcInstNo = StringUtil.checkNull(commonService.selectString("instance_SQL.maxProcInstNo",setMap)).trim();
			maxProcInstNo = maxProcInstNo.substring(maxProcInstNo.length() - 5, maxProcInstNo.length());
			int curProcInstCode = Integer.parseInt(maxProcInstNo) + 1;
			String ProcInstNo = "P" + String.format("%09d", curProcInstCode);
			
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
			

			// SRCategory Attr Save 
			setData.put("SRCatID", category);
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			List srCatAttrList = commonService.selectList("esm_SQL.getSRCatAttrList", setData);
			if(srCatAttrList.size()>0) {
				setData.put("userID", commandMap.get("sessionUserId"));
				for(int i=0; i<srCatAttrList.size(); i++) {
					Map srCatAttrMap = (Map) srCatAttrList.get(i);
					String attrTypeCode = StringUtil.checkNull(srCatAttrMap.get("AttrTypeCode"));
					String dataType = StringUtil.checkNull(srCatAttrMap.get("DataType"));
					String html = StringUtil.checkNull(srCatAttrMap.get("HTML"));
					String value = StringUtil.checkNull(xss.getParameter(attrTypeCode));
					String mLovValue = "";
					
					setMap = new HashMap();
					setMap.put("srID", maxSrId);
					setMap.put("attrTypeCode", attrTypeCode);
					setMap.put("value", value);	
					setMap.put("userID", commandMap.get("sessionUserId"));
					
					if(dataType.equals("MLOV")){							
						setData.put("attrTypeCode", attrTypeCode);
						setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
						
						List MLovList =  commonService.selectList("attr_SQL.getMLovListWidthSRAttr", setData);
						for(int j=0; MLovList.size()> j; j++) {
							Map MLovListMap = (Map)MLovList.get(j);
							String MLovValue = StringUtil.checkNull(commandMap.get(attrTypeCode+MLovListMap.get("CODE")));
							if(!MLovValue.equals("")) {
								setMap.put("value", MLovValue);	
								setMap.put("lovCode", MLovValue);	
								
								System.out.println(attrTypeCode + " ... MLovValue :" + MLovValue);
								commonService.insert("esm_SQL.insertSRAttr", setMap);
							}
						}
					}else{	
						if(html.equals("1")){
							value =  StringEscapeUtils.escapeHtml4(value);
						}
						if(dataType.equals("LOV")) setMap.put("lovCode", value);
						
						commonService.insert("esm_SQL.insertSRAttr", setMap);
					}
				}
			}
			
			
			
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
			
			if(srArea3.isEmpty()) {	//ITSP
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
				}
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
				
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
			}
			
			model.put("scrnType", scrnType);
			model.put("srType", srType);
			model.put("srMode", srMode);
			model.put("defCategory", defCategory);
			
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
	
	@RequestMapping(value = "/updateESRInfo.do")
	public String updateESRInfo(MultipartHttpServletRequest request, HashMap  commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		try {
			HashMap setData = new HashMap();		
			HashMap updateData = new HashMap();
		
			String srMode = StringUtil.checkNull(xss.getParameter("srMode"));
			String scrnType = StringUtil.checkNull(xss.getParameter("scrnType"));
			String srType = StringUtil.checkNull(xss.getParameter("srType"));
			String srID = StringUtil.checkNull(xss.getParameter("srID"));
			String srArea1 = StringUtil.checkNull(xss.getParameter("srArea1"));
			String srArea2 = StringUtil.checkNull(xss.getParameter("srArea2"));
			String srArea3 = StringUtil.checkNull(xss.getParameter("srArea3"));
			String category = StringUtil.checkNull(xss.getParameter("category"));
			String subCategory = StringUtil.checkNull(xss.getParameter("subCategory"));
			String priority = StringUtil.checkNull(xss.getParameter("priority"));
			String comment = StringUtil.checkNull(commandMap.get("comment"));
			String dueDate = StringUtil.checkNull(xss.getParameter("dueDate")).trim();
			String proposal = StringUtil.checkNull(xss.getParameter("proposal"));
			String classification = StringUtil.checkNull(xss.getParameter("classification"));
			String dueDateTime = StringUtil.checkNull(xss.getParameter("dueDateTime"));
			String status = StringUtil.checkNull(xss.getParameter("status"));
			String srReason = StringUtil.checkNull(xss.getParameter("srReason"));
			String itsmIF = StringUtil.checkNull(xss.getParameter("itsmIF"));
			String responseTeamID = StringUtil.checkNull(xss.getParameter("responseTeam"));
			
			updateData.put("dueDate", dueDate);	
			if(!dueDate.equals("") && !dueDateTime.equals("") ) {
				updateData.put("dueDate", dueDate+" "+dueDateTime);
			}
		
			// 선택된 시스템(srArea2)의 ProjectID 취득 x
			setData.put("srArea2", srArea2);
			String projectID = StringUtil.checkNull(commonService.selectString("sr_SQL.getProjectIDFromL2", setData)).trim();
			updateData.put("projectID", projectID);
			updateData.put("srID", srID);
			updateData.put("srType", srType);
			updateData.put("category", category); 
			updateData.put("subCategory", subCategory); 
			updateData.put("priority", priority); 
			updateData.put("srArea1", srArea1);
			updateData.put("srArea2", srArea2);			
			setData.put("s_itemID",srArea3);
			updateData.put("itemTypeCode", commonService.selectString("item_SQL.selectedItemTypeCode",setData));			
			updateData.put("srArea3", srArea3);			
			updateData.put("comment", comment);	
			updateData.put("proposal", proposal);	
			updateData.put("classification", classification);	
			updateData.put("lastUser", commandMap.get("sessionUserId"));
			updateData.put("status", status);
			updateData.put("srReason", srReason);
			updateData.put("itsmIF", itsmIF);
			updateData.put("responseTeamID", responseTeamID);
			
			if(!subCategory.equals("")){
				setData.put("srCatID", subCategory);
			}else{
				setData.put("srCatID", category);
			}
			setData.put("srType", srType);
			Map esmSRCatInfo =  commonService.select("esm_SQL.getESMSRAreaFromSrCat", setData);
			if(!esmSRCatInfo.isEmpty()){
				String procPathID = StringUtil.checkNull(esmSRCatInfo.get("ProcPathID") );
				updateData.put("procPathID", procPathID);	
			}
			
			
			commonService.update("esm_SQL.updateESMSR", updateData);	
			
			if (!status.equals("")) {
				Map setProcMapRst = setProcLog(request, this.commonService, updateData);
		        if (setProcMapRst.get("type").equals("FAILE")) {
		          String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
		          System.out.println("Msg : " + Msg);
		        }
	        }
			
			// SRCategory Attr Save 
			setData.put("srID", srID);
			setData.put("SRCatID", category);
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			List srCatAttrList = commonService.selectList("esm_SQL.getSRCatAttrList", setData);
			
			commonService.update("esm_SQL.deleteSRAttr", setData);	
			if(srCatAttrList.size()>0) {
				setData.put("userID", commandMap.get("sessionUserId"));
				for(int i=0; i<srCatAttrList.size(); i++) {
					Map srCatAttrMap = (Map) srCatAttrList.get(i);
					String attrTypeCode = StringUtil.checkNull(srCatAttrMap.get("AttrTypeCode"));
					String dataType = StringUtil.checkNull(srCatAttrMap.get("DataType"));
					String html = StringUtil.checkNull(srCatAttrMap.get("HTML"));
					String value = StringUtil.checkNull(xss.getParameter(attrTypeCode));
					String mLovValue = "";
					
					setData = new HashMap();
					setData.put("srID", srID);
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
								
								System.out.println(attrTypeCode + " ... MLovValue :" + MLovValue);
								commonService.insert("esm_SQL.insertSRAttr", setData);
							}
						}
					}else{	
						if(html.equals("1")){
							value =  StringEscapeUtils.escapeHtml4(value);
						}
						if(dataType.equals("LOV")) setData.put("lovCode", value);						
						commonService.insert("esm_SQL.insertSRAttr", setData);
					}
				}
			}
			
			// Sr 첨부파일 등록 : TB_SR_FILE 
			commandMap.put("projectID", projectID);
			insertESMSRFiles(commandMap, srID);
			
			// 참조 update
			String sharers = StringUtil.checkNull(request.getParameter("sharers"));
			String srSharers[] = sharers.split(",");
			Map RoleAssignMap =  commonService.select("esm_SQL.getESMSRAreaFromSrCat", setData);
			String roleType = StringUtil.checkNull(RoleAssignMap.get("RoleType"));
			
			setData.put("srType", srType);
			setData.put("srCatID",category);
			setData.put("SRID", srID);
			setData.put("assignmentType", "SRROLETP");
			setData.put("roleType", roleType);
			
			if(!sharers.equals("") && sharers != null){
				for(int i=0; srSharers.length > i; i++){
					setData.put("memberID", srSharers[i]);
		   			setData.put("sessionUserId", srSharers[i]);
		   			setData.put("mbrTeamID", commonService.selectString("user_SQL.userTeamID", setData));
					setData.put("orderNum", i+1);
					setData.put("assigned", "1");	
					setData.put("accessRight", "R");	
					setData.put("creator", commandMap.get("sessionUserId"));
					
					Map srMbrInfo = commonService.select("esm_SQL.getESMSRMember", setData);
					if(srMbrInfo.isEmpty()){
						commonService.insert("esm_SQL.insertESMSRMember", setData);
					}
				}
				setData.put("memberIDs", sharers);
			}
			commonService.delete("esm_SQL.deleteSRMbr",setData);
			
			model.put("scrnType",scrnType);
			model.put("srMode", srMode);
			model.put("pageNum", StringUtil.checkNull(xss.getParameter("pageNum")));
			model.put("projectID", StringUtil.checkNull(xss.getParameter("projectID")));
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBackSR();$('#isSubmit').remove()");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	// SR 종료  (SPE012)
	@RequestMapping(value = "/completeESR.do")
	public String completeESR(MultipartHttpServletRequest request, HashMap  commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		try {
			HashMap setData = new HashMap();	
			HashMap setMap = new HashMap();	
			HashMap updateData = new HashMap();
		
			String srID = StringUtil.checkNull(xss.getParameter("srID"));
			String srCode = StringUtil.checkNull(xss.getParameter("srCode"));
			String memberID = StringUtil.checkNull(xss.getParameter("memberID"));			
			String srMode = StringUtil.checkNull(xss.getParameter("srMode"));
			String screenType = StringUtil.checkNull(xss.getParameter("screenType"));
			String srType = StringUtil.checkNull(xss.getParameter("srType"));
			String srArea1 = StringUtil.checkNull(xss.getParameter("srArea1"));
			String srArea2 = StringUtil.checkNull(xss.getParameter("srArea2"));
			String category = StringUtil.checkNull(xss.getParameter("category"));
			String subCategory = StringUtil.checkNull(xss.getParameter("subCategory"));
			String subject = StringUtil.checkNull(xss.getParameter("subject"));
			String priority = StringUtil.checkNull(xss.getParameter("priority"));
			String comment = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(xss.getParameter("comment")));
			String dueDate = StringUtil.checkNull(xss.getParameter("dueDate"));
			String receiptUserID = StringUtil.checkNull(xss.getParameter("receiptUserID"));
			String receiptTeamID = StringUtil.checkNull(xss.getParameter("receiptTeamID"));
			String requestUserID = StringUtil.checkNull(xss.getParameter("requestUserID"));
			String requestTeamID = StringUtil.checkNull(xss.getParameter("requestTeamID"));
			String processType = StringUtil.checkNull(xss.getParameter("processType"));
			String speCode = StringUtil.checkNull(xss.getParameter("speCode"));
			String svcCompl = StringUtil.checkNull(xss.getParameter("svcCompl"));
			String blockSR = StringUtil.checkNull(xss.getParameter("blockSR"));
			String blocked = "";
			if(blockSR.equals("Y")) blocked = "1";
				
			// 선택된 시스템(srArea2)의 ProjectID 취득 
			setData.put("srArea2", srArea2);
			String projectID = StringUtil.checkNull(commonService.selectString("sr_SQL.getProjectIDFromL2", setData)).trim();
			updateData.put("projectID", projectID);
			updateData.put("srID", srID);
			updateData.put("srType", srType);
			updateData.put("srCatID", category); 
			updateData.put("subCategory", subCategory); 
			updateData.put("priority", priority); 
			updateData.put("srArea1", srArea1);
			updateData.put("srArea2", srArea2);
			updateData.put("comment", comment);	
			updateData.put("dueDate", dueDate);	
			updateData.put("lastUser", commandMap.get("sessionUserId"));
			updateData.put("status", speCode);				
			updateData.put("srCode", srCode);
			updateData.put("svcCompl", svcCompl);
			updateData.put("blocked", blocked);
			
			commonService.update("esm_SQL.updateESMSR", updateData);	
			// Sr 첨부파일 등록 : TB_SR_FILE 
			commandMap.put("projectID", projectID);
			insertESMSRFiles(commandMap, srID);
			//Save PROC_LOG
			Map setProcMapRst = (Map)setProcLog(request, commonService, updateData);
			//System.out.println("setProcMapRst....."+setProcMapRst.get("type"));			
			if(setProcMapRst.get("type").equals("FAILE")){
				String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
				System.out.println("Msg : "+Msg);
			}
			
			//======================================
			//send Email
			List receiverList = new ArrayList();
			Map receiverMap = new HashMap();
			receiverMap.put("receiptUserID", requestUserID); // SR 조치 시는 수신자가 조치자(ReceiptUser)가 아닌 RequestUser의 이메일로 송신
			receiverList.add(0,receiverMap);
			updateData.put("receiverList", receiverList);
			
			// 참조자 메일 발송 
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			setData.put("SRID", srID);
			List srRefMemberList= commonService.selectList("esm_SQL.getESMSRMember", setData);
			int receiverIndex = receiverList.size();
			if(srRefMemberList.size() > 0){			
				for(int i=0; srRefMemberList.size() > i; i++){
					Map srRefMemberInfo = (Map)srRefMemberList.get(i);
					receiverMap = new HashMap();
					receiverMap.put("receiptUserID", srRefMemberInfo.get("MemberID"));
					receiverMap.put("receiptType", "CC");
					receiverList.add(receiverIndex,receiverMap);
					receiverIndex++;
				}
			}
			
			updateData.put("subject", subject);
			Map setMailMapRst = (Map)setEmailLog(request, commonService, updateData, "SRCMP");
			if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
				setMap.put("srID", srID);
				setMap.put("srType", srType);
				setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				HashMap cntsMap = (HashMap)commonService.select("esm_SQL.getESMSRInfo", setMap);
				
				cntsMap.put("srID", srID);	
				cntsMap.put("teamID", requestTeamID);					
				cntsMap.put("userID", requestUserID);
				cntsMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				String requestLoginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", cntsMap));
				cntsMap.put("loginID", requestLoginID);
				
				cntsMap.put("emailCode", "SRCMP");
				String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", cntsMap));
				cntsMap.put("emailHTMLForm", emailHTMLForm);
				
				Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, commonService));
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+ "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+ StringUtil.checkNull(setMailMapRst.get("msg")));
			}
			//==============================================	
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnGoSRList();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/goTransferItspPop.do")
	public String goTransferItspPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/app/esm/itsp/transferItspPop";		
		HashMap target = new HashMap();
		try {				
				String srID = StringUtil.checkNull(request.getParameter("srID")); 
				String srType = StringUtil.checkNull(request.getParameter("srType")); 
				String srArea1ListSQL = StringUtil.checkNull(request.getParameter("srArea1ListSQL")); 
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType")); 
				
				setMap.put("srID", srID);
				setMap.put("languageID", languageID);
				
				Map srInfoMap =  commonService.select("esm_SQL.getESMSRInfo", setMap);	
				String blocked = StringUtil.checkNull(srInfoMap.get("Blocked")); 
				if(blocked.equals("1")) {
//					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00046"));
					target.put(AJAX_SCRIPT, "this.fnAlertSRCmp();");
					model.addAttribute(AJAX_RESULTMAP, target);
				} else {
					setMap.put("srCatID", srInfoMap.get("Category"));
					setMap.put("srType", srInfoMap.get("SRType"));
					Map RoleAssignMap =  commonService.select("esm_SQL.getESMSRAreaFromSrCat", setMap);
					
					model.put("srID", srID );
					model.put("srType", srType );
					model.put("srInfoMap", srInfoMap);
					model.put("languageID", languageID);
					model.put("roleType", RoleAssignMap.get("RoleType"));
					model.put("srArea", RoleAssignMap.get("SRArea"));
					model.put("srArea1ListSQL", srArea1ListSQL);
					model.put("menu", getLabel(request, commonService)); //  Label Setting 		
				}				
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/transferESR.do")
	public String transferESR(HttpServletRequest request, HashMap  commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();		
			HashMap updateData = new HashMap();
			HashMap setMap = new HashMap();
		
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String srType = StringUtil.checkNull(request.getParameter("srType"));
			String receiptUserID = StringUtil.checkNull(request.getParameter("receiptUserID"));
			String receiptTeamID = StringUtil.checkNull(request.getParameter("receiptTeamID"));
			String comment = StringUtil.checkNull(request.getParameter("comment"));
			String srArea1 = StringUtil.checkNull(request.getParameter("srArea1"));
			String srArea2 = StringUtil.checkNull(request.getParameter("srArea2"));
			String subject = StringUtil.checkNull(request.getParameter("subject"));
			String transferReason = StringUtil.checkNull(request.getParameter("transferReason"));

			setData.put("srArea2", srArea2);
			String projectID = StringUtil.checkNull(commonService.selectString("sr_SQL.getProjectIDFromL2", setData)).trim();
			updateData.put("projectID", projectID);		
			updateData.put("receiptUserID",receiptUserID);
			updateData.put("receiptTeamID",receiptTeamID);
			updateData.put("comment",comment);
			updateData.put("srID", srID);
			updateData.put("lastUser", commandMap.get("sessionUserId"));
			updateData.put("srArea1",srArea1);
			updateData.put("srArea2",srArea2);
			
			setMap.put("srID", srID);
			String startEventCode = StringUtil.checkNull(commonService.selectString("esm_SQL.getStartEventCode", setMap));
			// transfer시 상태변경 없음
			//updateData.put("status", startEventCode);
		
			commonService.insert("esm_SQL.updateESMSR", updateData);	
			
			//Save PROC_LOG			
			updateData.put("subject", subject);
			updateData.put("transferReason",transferReason);
			Map setProcMapRst = (Map)setProcLog(request, commonService, updateData);
			if(setProcMapRst.get("type").equals("FAILE")){
				String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
				System.out.println("Msg : "+Msg);
			}
			
			//======================================
			//send Email
			
			List receiverList = new ArrayList();
			Map receiverMap = new HashMap();
			receiverMap.put("receiptUserID", receiptUserID);
			receiverList.add(0,receiverMap);
			updateData.put("receiverList", receiverList);
			
			String emailCode = "SRTRP" ;
			Map setMailMapRst = (Map)setEmailLog(request, commonService, updateData, emailCode);
			System.out.println("setMailMapRst( SR Transfer ) : "+setMailMapRst );
			
			if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
				setMap.put("srID", srID);
				setMap.put("srType", srType);
				setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				HashMap cntsMap = (HashMap)commonService.select("esm_SQL.getESMSRInfo", setMap);
				
				cntsMap.put("userID", updateData.get("receiptUserID"));
				cntsMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				String receiptLoginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", cntsMap));
				cntsMap.put("loginID", receiptLoginID);
				
				cntsMap.put("emailCode", "SRREQ");
				String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", cntsMap));
				cntsMap.put("emailHTMLForm", emailHTMLForm);
								
				Map resultMailMap = EmailUtil.sendMail(mailMap,cntsMap, getLabel(request, commonService));
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+" ,Msg : "+StringUtil.checkNull(setMailMapRst.get("type")));
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
			}
			//==============================================
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/editSRDueDuatePop.do")
	public String editSRDueDuatePop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/app/esm/itsp/editSRDueDuatePop";		
		try {				
				String srID = StringUtil.checkNull(request.getParameter("srID")); 
				String srType = StringUtil.checkNull(request.getParameter("srType")); 
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType")); 
				
				setMap.put("srID", srID);
				setMap.put("languageID", languageID);
				
				Map srInfoMap =  commonService.select("esm_SQL.getESMSRInfo", setMap);	
								
				model.put("srID", srID );
				model.put("srType", srType );
				model.put("srInfoMap", srInfoMap);
				model.put("languageID", languageID);
				model.put("menu", getLabel(request, commonService)); //  Label Setting 			
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/editSRDueDuate.do") 
	public String editSRDueDuate(HttpServletRequest request, HashMap  commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();		
			HashMap updateData = new HashMap();
			HashMap setMap = new HashMap();
		
			String srID = StringUtil.checkNull(request.getParameter("srID"));			
			String dueDate = StringUtil.checkNull(request.getParameter("dueDate"));
			String dueDateTime = StringUtil.checkNull(request.getParameter("dueDateTime"));
			
			updateData.put("dueDate", dueDate);	
			if(!dueDate.equals("") && !dueDateTime.equals("") ) {
				updateData.put("dueDate", dueDate+" "+dueDateTime);
			}
			updateData.put("srID", srID);
			updateData.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
			
			commonService.insert("esm_SQL.updateESMSR", updateData);	
			
			//Save PROC_LOG			
			Map setProcMapRst = (Map)setProcLog(request, commonService, updateData);
			if(setProcMapRst.get("type").equals("FAILE")){
				String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
				System.out.println("Msg : "+Msg);
			}
		
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/mainESRList.do")
	public String mainSRList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		try {
			HashMap setData = new HashMap();
			String listSize = StringUtil.checkNull(request.getParameter("listSize"));
			String srType = StringUtil.checkNull(request.getParameter("srType"));
			String srMode = StringUtil.checkNull(request.getParameter("srMode"));
			String status = StringUtil.checkNull(request.getParameter("status"));
			
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			setData.put("loginUserId", cmmMap.get("sessionUserId"));
			setData.put("myTeamId", cmmMap.get("sessionTeamId"));
			setData.put("srType", srType);
			setData.put("srMode", srMode);
			setData.put("srStatus", status);
			List srList = (List)commonService.selectList("esm_SQL.getEsrMSTList_gridList", setData);
			
			model.put("srList", srList);
			model.put("listSize", listSize);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}		
		catch (Exception e) {System.out.println(e);throw new ExceptionUtil(e.toString());}		
		return nextUrl("/app/esm/itsp/mainESRList");
	}	
	
	@RequestMapping(value = "/updateESRStatus.do")
	public String updateESRStatus(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();		
			
			String status = StringUtil.checkNull(cmmMap.get("status"));
			String svcCompl = StringUtil.checkNull(cmmMap.get("svcCompl"));
			String wfInstanceID = StringUtil.checkNull(cmmMap.get("wfInstanceID"));
			String wfInstanceStatus = StringUtil.checkNull(cmmMap.get("wfInstanceStatus"));
			String blockSR = StringUtil.checkNull(cmmMap.get("blockSR"));
			
			// srID 구하기
			setData.put("wfInstanceID", wfInstanceID);
			Map wfDocMap = commonService.select("wf_SQL.getWFInstDoc", setData);
						
			setData.put("srID", StringUtil.checkNull(wfDocMap.get("DocumentID"),StringUtil.checkNull(cmmMap.get("srID"))));
			setData.put("status", status);		
			setData.put("lastUser", StringUtil.checkNull(cmmMap.get("sessionUserId")) );
			setData.put("svcCompl", svcCompl);	
			setData.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));	
			if(blockSR.equals("Y")) setData.put("blocked", "1");
			
			// System.out.println("Fixed Path YN : " + fixedPathYN + newProcPathID)	; 	
			String fixedPathYN = commonService.selectString("esm_SQL.getFixedPathYN",setData);	
			
			// ESM_PROC_CONFIG : SpeCode, ProcPathID
			Map srInfo = commonService.select("esm_SQL.getESMSRInfo", setData);
			setData.put("srType", srInfo.get("SRType"));
			setData.put("wfInstanceStatus", wfInstanceStatus);
			
			Map esmProcInfo = (Map)decideSRProcPath(request, commonService, setData);
			//System.out.println("wfInstanceStatus :"+wfInstanceStatus);
			//System.out.println("esmProcInfo :"+esmProcInfo);
			String procPathID = "";
			String speCode = "";
			if(esmProcInfo != null && !esmProcInfo.isEmpty()){
				procPathID = StringUtil.checkNull(esmProcInfo.get("ProcPathID"));
				speCode = StringUtil.checkNull(esmProcInfo.get("SpeCode"));
				if(!procPathID.equals("") && procPathID != null && fixedPathYN.equals("N")) setData.put("procPathID", procPathID); 
				if(!speCode.equals("") && speCode != null) setData.put("status", speCode); 
			}
			
			commonService.update("esm_SQL.updateESMSR", setData);	
			
//			if(!"1".equals(wfInstanceStatus)){
//				List stepList = commonService.selectList("wf_SQL.getWfStepInstList_gridList", setData);
//				Map lastStep = (Map) stepList.get(stepList.size()-1);
//				setData.put("comment",lastStep.get("Comment")); // 결재 코멘트 추가
//			}
			
			//Save PROC_LOG		
			Map setProcMapRst = (Map)setProcLog(request, commonService, setData);
			if(setProcMapRst.get("type").equals("FAILE")){
				String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
				System.out.println("Msg : "+Msg);
			}
					
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
	
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/requestEvaluationPop.do")
	public String requestEvaluationPop(HttpServletRequest request,  HashMap commandMap, ModelMap model) throws Exception {
		try{
			Map setMap = new HashMap();
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String srType = StringUtil.checkNull(commandMap.get("srType"));
			String status = StringUtil.checkNull(commandMap.get("status"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String svcCompl = StringUtil.checkNull(commandMap.get("svcCompl"));
			
			setMap.put("srID", srID);
			setMap.put("srType", srType);
			setMap.put("languageID", languageID);
			
			Map srInfo = commonService.select("esm_SQL.getESMSRInfo", setMap);	
			
			model.put("status", status);
			model.put("srInfo", srInfo);
			model.put("srID", srID);
			model.put("svcCompl", svcCompl);	
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		} catch (Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/app/esm/itsp/requestEvaluationPop");
	}
	
	@RequestMapping(value = "/requestEvaluation.do")
	public String requestEvaluation(MultipartHttpServletRequest request, HashMap  commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();		
			HashMap updateData = new HashMap();
			HashMap setMap = new HashMap();
			XSSRequestWrapper xss = new XSSRequestWrapper(request);

			String emailCode = "REQSREV" ;
			String srID = StringUtil.checkNull(request.getParameter("srID"));	
			String status = StringUtil.checkNull(request.getParameter("status"));	
			String comment = StringUtil.checkNull(request.getParameter("comment"));	
			String svcCompl = StringUtil.checkNull(commandMap.get("svcCompl"));
			
				
			updateData.put("srID", srID);
			updateData.put("status", status);
			updateData.put("comment", comment);
			updateData.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
			updateData.put("svcCompl", svcCompl);
			updateData.put("blocked", "1");
			
			commonService.insert("esm_SQL.updateESMSR", updateData);	
			
			for (Iterator i = commandMap.entrySet().iterator(); i.hasNext();) {
			    Entry e = (Entry) i.next(); // not allowed
			    if(!e.getKey().equals("loginInfo") && e.getValue() != null) {
			    	commandMap.put(e.getKey(), xss.stripXSS(e.getValue().toString()));
			    }
			}
					
			String userId = StringUtil.checkNull(commandMap.get("sessionUserId"), "");
			String sysfile = StringUtil.checkNull(xss.getParameter("sysFile"), "");
			
			//기존파일 삭제 
			File existFile = new File(sysfile); 
			if(existFile.isFile() && existFile.exists()){existFile.delete();}
			
			List fileList = new ArrayList();
			Map fileMap = new HashMap();
			setMap.put("fltpCode", "SRDOC");
			
			String filePath = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFilePath",setMap));
			File dirFile = new File(filePath);if(!dirFile.exists()) { dirFile.mkdirs();} 
			
			Iterator fileNameIter = request.getFileNames();
			String savePath = filePath; 		
			String fileName = "";
			
			int Seq = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", commandMap));
			int seqCnt = 0;
			
			try{
			while (fileNameIter.hasNext()) {					
			   MultipartFile mFile = request.getFile((String)fileNameIter.next());	
			   
			   if (mFile.getSize()>0) {	
				   
				   fileMap = new HashMap();
				   fileName = mFile.getName();
				  
				   HashMap resultMap = FileUtil.uploadFile(mFile, savePath, true);
				  			   
				   fileMap.put("Seq", Seq);
				   fileMap.put("DocumentID", srID);
				   fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
				   fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
				   fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
				   fileMap.put("FilePath", resultMap.get(FileUtil.FILE_PATH));	
				   fileMap.put("FltpCode", "SRDOC");
				   fileMap.put("userId", userId);
				   fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
				   fileMap.put("DocCategory", "SR");
				   fileMap.put("FileMgt", "SR");
				   fileMap.put("FltpCode", "SRDOC");
				   
				   fileMap.put("KBN", "insert");
				   fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");				   
				   fileList.add(fileMap);
				   seqCnt++;
			   }
			}	
			fileMgtService.save(fileList, fileMap);
			}catch(Exception ex){
				System.out.println("ex:"+ex);
			}
			
			Map setProcMapRst = setProcLog(request, this.commonService, updateData);
		      if (setProcMapRst.get("type").equals("FAILE")) {
		        String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
		        System.out.println("Msg : " + Msg);
		      }
		      
		      String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
		      setMap.put("languageID", languageID);
		      setMap.put("srID", srID);
		      Map srInfo = (HashMap)commonService.select("esm_SQL.getESMSRInfo", setMap);
		      
		      List receiverList = new ArrayList();
		      Map receiverMap = new HashMap();
		      receiverMap.put("receiptUserID", srInfo.get("RequestUserID"));
		      receiverList.add(0, receiverMap);
		      updateData.put("receiverList", receiverList);
		      updateData.put("subject", srInfo.get("Subject"));
		      
		      Map setMailMapRst = setEmailLog(request, this.commonService, updateData, emailCode);
		      if (StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")) {
		        HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
		        setMap.put("srID", srID);
		        setMap.put("srType", srInfo.get("SRType"));
		        setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
		        HashMap cntsMap = (HashMap)this.commonService.select("esm_SQL.getESMSRInfo", setMap);

				Map temp = new HashMap();
				temp.put("Category", "EMAILCODE"); 
				temp.put("TypeCode", emailCode);
				temp.put("LanguageID", commandMap.get("sessionCurrLangType"));
				Map emDescription = commonService.select("common_SQL.label_commonSelect", temp);
				cntsMap.put("emDescription",emDescription.get("Description"));
				
		        cntsMap.put("srID", srID);
		        cntsMap.put("teamID", srInfo.get("RequestTeamID"));
		        cntsMap.put("userID", srInfo.get("RequestUserID"));
		        cntsMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
		        String requestLoginID = StringUtil.checkNull(this.commonService.selectString("sr_SQL.getLoginID", cntsMap));
		        cntsMap.put("loginID", requestLoginID);

		        Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, this.commonService));
		        System.out.println("SEND EMAIL TYPE:" + resultMailMap + "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
		      } else {
		        System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMailMapRst.get("msg")));
		      }

		      target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
		      target.put("SCRIPT", "parent.fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/requestESRDueDate.do")
	public String requestESRDueDate(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();		
		
			String srID = StringUtil.checkNull(cmmMap.get("srID"));
			String srType = StringUtil.checkNull(cmmMap.get("srType"));
				
			setData.put("srID", srID);
			setData.put("srType", srType);
			setData.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
			HashMap srInfo = (HashMap)commonService.select("esm_SQL.getESMSRInfo", setData);
			
			String requestUserID = StringUtil.checkNull(srInfo.get("RequestUserID"));
			String LOGIN_ID = StringUtil.checkNull(cmmMap.get("sessionLoginId"));
			// Send Email
			List receiverList = new ArrayList();
			Map receiverMap = new HashMap();			
			Map setMailData = new HashMap();
			
			String emailCode = "SRCNGRDD" ;
			setMailData.put("EMAILCODE", emailCode);
			setMailData.put("subject", StringUtil.checkNull(srInfo.get("Subject")));
			
			receiverMap.put("receiptUserID", requestUserID);
			receiverList.add(0,receiverMap);
			setMailData.put("receiverList", receiverList);
			
			Map setMailMapRst = (Map)setEmailLog(request, commonService, setMailData, emailCode);
			System.out.println("setMailMapRst( SR Change Due Date ) : "+setMailMapRst );
			
			if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
				
				srInfo.put("userID", requestUserID);
				srInfo.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
				String requestLoginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", srInfo));
				srInfo.put("loginID", requestLoginID);
								
				Map resultMailMap = EmailUtil.sendMail(mailMap, srInfo, getLabel(request, commonService));
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+" ,Msg : "+StringUtil.checkNull(setMailMapRst.get("type")));
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
	
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	// 외부(EMail)에서 chang ESR RDD 화면 호출 
	@RequestMapping(value = "/reqSRDueDateChangeEmail.do")
	public String reqSRDueDateChangeEmail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/app/esm/itsp/reqSRDueDateChangeEmail";		
		try {				
				String userID = StringUtil.checkNull(request.getParameter("userID")); 
				String languageID = StringUtil.checkNull(request.getParameter("languageID"));				
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String srType = StringUtil.checkNull(request.getParameter("srType"));
				
				String dueDate = StringUtil.checkNull(request.getParameter("dueDate"));
				String dueDateTime = StringUtil.checkNull(request.getParameter("dueDateTime"));
				
				model.put("srID", srID);
				model.put("srType", srType);
				model.put("userID", userID);
				model.put("languageID", languageID);				
				model.put("dueDate", dueDate);
				model.put("dueDateTime", dueDateTime);
				model.put("menu", getLabel(request, commonService)); //  Label Setting 		
				
				System.out.println(" ## reqSRDueDateChangeEmail :"+url+":userID:"+userID);
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/reqSRDueDateChange.do")
	public String reqSRDueDateChange(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/app/esm/itsp/reqSRDueDateChange";		
		try {				
				String srID = StringUtil.checkNull(request.getParameter("srID")); 
				String srType = StringUtil.checkNull(request.getParameter("srType")); 
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType")); 
				
				setMap.put("srID", srID);
				setMap.put("languageID", languageID);				
				Map srInfo =  commonService.select("esm_SQL.getESMSRInfo", setMap);	
				
				model.put("srID", srID );
				model.put("srType", srType );
				model.put("srInfo", srInfo);				
				model.put("menu", getLabel(request, commonService)); //  Label Setting 			
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/confirmSRDueDate.do")
	public String confirmSRDueDate(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();		
		
			String srID = StringUtil.checkNull(cmmMap.get("srID"));
			String srType = StringUtil.checkNull(cmmMap.get("srType"));			
			String dueDate = StringUtil.checkNull(cmmMap.get("dueDate"));
			String dueDateTime = StringUtil.checkNull(cmmMap.get("dueDateTime"));
			
			setData.put("srID", srID);
			setData.put("srType", srType);
			setData.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
			HashMap srInfo = (HashMap)commonService.select("esm_SQL.getESMSRInfo", setData);
			
			srInfo.put("dueDate", dueDate);
			srInfo.put("dueDateTime", dueDateTime);
				
			String requestUserID = StringUtil.checkNull(srInfo.get("RequestUserID"));
			String LOGIN_ID = StringUtil.checkNull(cmmMap.get("sessionLoginId"));
			// Send Email
			List receiverList = new ArrayList();
			Map receiverMap = new HashMap();			
			Map setMailData = new HashMap();
			
			String emailCode = "SRCNGRDD" ;
			setMailData.put("EMAILCODE", emailCode);
			setMailData.put("subject", StringUtil.checkNull(srInfo.get("Subject")));
			
			receiverMap.put("receiptUserID", requestUserID);
			receiverList.add(0,receiverMap);
			setMailData.put("receiverList", receiverList);
			
			Map setMailMapRst = (Map)setEmailLog(request, commonService, setMailData, emailCode);
			System.out.println("setMailMapRst( SR Change Due Date ) : "+setMailMapRst );
			
			srInfo.put("emailCode", emailCode);
			srInfo.put("languageID", cmmMap.get("sessionCurrLangType"));
			String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", srInfo));
			srInfo.put("emailHTMLForm", emailHTMLForm);
			
			if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
				
				srInfo.put("userID", requestUserID);
				srInfo.put("languageID", String.valueOf(cmmMap.get("sessionCurrLangType")));
				String requestLoginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", srInfo));
				srInfo.put("loginID", requestLoginID);
								
				Map resultMailMap = EmailUtil.sendMail(mailMap, srInfo, getLabel(request, commonService));
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+" ,Msg : "+StringUtil.checkNull(setMailMapRst.get("type")));
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
	
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	public static Map getSpeCode(HttpServletRequest request, CommonService commonService) throws Exception{
		HashMap cmmMap = new HashMap();
		HashMap getMap = new HashMap();
		String langType = XboltController.getUserCurrLangType(request);
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
	
	@RequestMapping(value = "/viewProcLog.do")
	public String viewProcLog(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/app/crm/sr/procLogDetail";		
		try {				
				String srID = StringUtil.checkNull(request.getParameter("PID")); 
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType")); 
				String procSeq = StringUtil.checkNull(cmmMap.get("procSeq"));
				
				setMap.put("srID", srID);
				setMap.put("languageID", languageID);
				setMap.put("seq", procSeq);
				Map srInfoMap =  commonService.select("esm_SQL.getESMSRInfo", setMap);	
				Map procLogInfo = commonService.select("sr_SQL.getProLogInfo",setMap);				
				
				model.put("srID", srID );
				model.put("srInfoMap", srInfoMap);
				model.put("procLogInfo", procLogInfo);
				model.put("menu", getLabel(request, commonService)); //  Label Setting 	
				
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/esrList.do")
	public String esrList(HttpServletRequest request, HashMap cmmMap,  HashMap commandMap,   ModelMap model) throws Exception {
		String url = "/app/esm/esrList";
		try {
			Map setData = new HashMap();
			
			// icp내 탭에서 조회할 경우
			String fromSRID = StringUtil.checkNull(request.getParameter("fromSRID"));
			if(!fromSRID.equals("") && !fromSRID.equals(null)) {
				model.put("fromSRID",fromSRID);
				setData.put("srID",fromSRID);
				Map fromSRIDinfo = commonService.select("esm_SQL.getESMSRInfo",setData);
				model.put("fromSRIDinfo",fromSRIDinfo);
			}
			
			//검색조건 setting		
			model.put("category", StringUtil.checkNull(cmmMap.get("category")));
			model.put("subCategory", StringUtil.checkNull(cmmMap.get("subCategory")));
			model.put("srArea1", StringUtil.checkNull(cmmMap.get("srArea1")));
			model.put("srArea2", StringUtil.checkNull(cmmMap.get("srArea2")));
			model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
			model.put("status", StringUtil.checkNull(cmmMap.get("status")));				
			model.put("receiptUser", StringUtil.checkNull(cmmMap.get("receiptUser")));
			model.put("requestUser", StringUtil.checkNull(cmmMap.get("requestUser")));
			model.put("requestTeam", StringUtil.checkNull(cmmMap.get("requestTeam")));
			model.put("startRegDT", StringUtil.checkNull(cmmMap.get("startRegDT")));
			model.put("endRegDT", StringUtil.checkNull(cmmMap.get("endRegDT")));
			model.put("stSRDueDate", StringUtil.checkNull(cmmMap.get("stSRDueDate")));
			model.put("endSRDueDate", StringUtil.checkNull(cmmMap.get("endSRDueDate")));
			model.put("searchSrCode", StringUtil.checkNull(cmmMap.get("searchSrCode")));
			model.put("srReceiptTeam", StringUtil.checkNull(cmmMap.get("srReceiptTeam")));
			model.put("srStatus", StringUtil.checkNull(request.getParameter("srStatus")) );
			model.put("searchStatus", StringUtil.checkNull(request.getParameter("searchStatus")));
			model.put("menu", getLabel(request, commonService)); //  Label Setting
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value="/olmMainEsrList.do")
	public String olmMainChangeSetList(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String listSize = StringUtil.checkNull(request.getParameter("listSize"),"5");
			String srMode = StringUtil.checkNull(request.getParameter("srMode"));			
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));			
			String srType = StringUtil.checkNull(request.getParameter("srType"));			
			int chkNew = Integer.parseInt("-"+StringUtil.checkNull(request.getParameter("chkNew"),"7"));			
			
			// 시스템 날짜 
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.DATE, chkNew);
			String chkYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			
			setMap.put("languageID", languageID);
			setMap.put("listSize", listSize);
			setMap.put("srStatus", "ING");
			setMap.put("loginUserId", cmmMap.get("sessionUserId"));
			setMap.put("srMode", srMode);
			setMap.put("srType", srType);
			setMap.put("myTeamId", StringUtil.checkNull(cmmMap.get("sessionTeamId")));
			List esrList = commonService.selectList("esm_SQL.getEsrMSTList_gridList",setMap);
			
			String isView="0";if(esrList!=null && esrList.size()>0){isView="1";}
			model.put("esrList", esrList);
			model.put("languageID", languageID);
			model.put("isView", isView);
			model.put("listSize", listSize);
			model.put("chkYmd", chkYmd);
			model.put("scrnType", scrnType);
			model.put("srType", srType);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
						
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		
		return nextUrl("/hom/main/v34/olmMainEsrList");
	}
	
	@RequestMapping(value="/myITS.do")
	public String myITS(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception{
		Map setData = new HashMap();
		String url = StringUtil.checkNull(cmmMap.get("url"),"");
		
		try {
			Map setMap = new HashMap();
			Map SRTypeMap = new HashMap();
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String mLvl = StringUtil.checkNull(cmmMap.get("sessionMlvl"));			
			String scrnType = StringUtil.checkNull(cmmMap.get("scrnType"));	
			String srType = StringUtil.checkNull(cmmMap.get("srType"));

			setMap.put("actorID", userId);
			
			if(mLvl.equals("VIEWER")) {
				setMap.put("assignmentType","SUBSCR");
				setMap.put("accessRight","R");
				String itemSubCnt = StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCountByRole",setMap));
				
				setMap.put("notStatus","REL");
				setMap.put("changeMgtYN","Yes");
				String itemSubModeCnt = StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCountByRole",setMap));
				
				model.put("itemCnt",itemSubCnt);
				model.put("itemTreeCnt", itemSubCnt.replace(",", ""));				
				model.put("itemTreeModeCnt",itemSubModeCnt.replace(",", ""));		
				model.put("itemModeCnt",itemSubModeCnt);

				setMap.put("filter", "myWF");
				setMap.put("wfMode", "ToDoAprv");
				List wfToDoAprvList = commonService.selectList("wf_SQL.getWFInstList_gridList",setMap);
				
				if(wfToDoAprvList != null && !wfToDoAprvList.isEmpty()) {
					model.put("wfToDoAprvCnt",wfToDoAprvList.size());
				} else {
					model.put("wfToDoAprvCnt","0");
				}

				setMap.put("wfMode", "RefMgt");
				List wfRefMgtList = commonService.selectList("wf_SQL.getWFInstList_gridList",setMap);
				
				if(wfRefMgtList != null && !wfRefMgtList.isEmpty()) {
					model.put("wfRefMgtCnt",wfRefMgtList.size());
				} else {
					model.put("wfRefMgtCnt","0");
				}
				
				url = "/hom/mySpace/v34/olmMySpaceViewer";
			}
			else if("".equals(url)) {// 콘텐츠 Cnt
				setMap.put("changeMgtYN","Yes");
				String itemCnt = StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCount",setMap));
				setMap.put("status","NEW1");
				String itemNewCnt = StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCount",setMap));
				setMap.put("status","MOD1");
				String itemModCnt = StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCount",setMap));
				setMap.remove("status");
				setMap.put("MultiStatus","'NEW2','MOD2'");
				String itemAprvCnt = StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCount",setMap));
				setMap.remove("MultiStatus");
				setMap.put("assignmentType","SUBSCR");
				setMap.put("accessRight","R");
				setMap.remove("changeMgtYN");
				String itemSubCnt = StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCountByRole",setMap));
				
				model.put("itemCnt",itemCnt);		
				
				model.put("itemNewCnt",itemNewCnt.replace(",", ""));			
				model.put("itemModCnt",itemModCnt.replace(",", ""));			
				model.put("itemAprvCnt",itemAprvCnt.replace(",", ""));	
				model.put("itemTreeCnt", itemCnt.replace(",", ""));				
				model.put("itemSubCnt",itemSubCnt.replace(",", ""));		
				
				url = "/app/esm/itsp/myITSEditor";
			}
			
			setData.put("srTypeCode", srType);
			if(!srType.equals("")){
				 SRTypeMap = commonService.select("esm_SQL.getESMSRTypeInfo",setData);
			}
			
			String varFilter = StringUtil.checkNull(SRTypeMap.get("VarFilter"));
			model.put("varFilter",varFilter);
			
			setData.put("languageID", languageID);
			setData.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
			setData.put("sessionUserId", languageID);
	
			model.put("menu", getLabel(request, commonService));	//Label Setting
			model.put("screenType", request.getParameter("screenType"));
			
			/* 문의 / 서비스요청 Cnt */
			setData.put("srType","ITSP");
			setData.put("loginUserId", userId);
			setData.put("srMode","mySR");
			setData.put("srStatus","ING");
			// List srIngList = commonService.selectList("esm_SQL.getEsrMSTList_gridList",setData);			
			String srIngCount = commonService.selectString("esm_SQL.getSRMSTCount", setData);
			model.put("srIngCnt", srIngCount);
			
			setData.put("srStatus","SPE001");
			// List srNewList = commonService.selectList("esm_SQL.getEsrMSTList_gridList",setData);
			String srNewCount = commonService.selectString("esm_SQL.getSRMSTCount", setData);
			model.put("srNewCnt", srNewCount);
			// if(srIngList != null && !srIngList.isEmpty()) {model.put("srIngCnt",srIngList.size());} else {model.put("srIngCnt","0");}			
			//if(srNewList != null && !srNewList.isEmpty()) {model.put("srNewCnt",srNewList.size());}	else {model.put("srNewCnt","0");}
			
			/* 결재 Cnt */
			setData.put("actorID", userId);
			setData.put("wfMode", "AREQ");
			setData.put("filter", "myWF");
			List wfAREQList = commonService.selectList("wf_SQL.getWFInstList_gridList",setData);
			
			setData.put("wfMode", "CurAprv");
			List wfCurAprvList = commonService.selectList("wf_SQL.getWFInstList_gridList",setData);
			
			if(wfAREQList != null && !wfAREQList.isEmpty()) {model.put("wfAREQCnt",wfAREQList.size());}
			else {model.put("wfAREQCnt","0");}
			
			if(wfCurAprvList != null && !wfCurAprvList.isEmpty()) {model.put("wfCurAprvCnt",wfCurAprvList.size());}
			else {model.put("wfCurAprvCnt","0");}
			
			/* SCR Cnt */
			setData.put("scrMode", "ING");
			setData.put("mySCR", "Y");
			// List scrIngList = commonService.selectList("scr_SQL.getSCR_gridList", setData);
			String scrIngCount = commonService.selectString("scr_SQL.getSCRMSTCount", setData);			
			model.put("scrIngCnt",scrIngCount);
			
			setData.put("status", "APREL");
			String scrAprelCount = commonService.selectString("scr_SQL.getSCRMSTCount", setData);
			// List scrAprelList = commonService.selectList("scr_SQL.getSCR_gridList", setData);
			model.put("scrAprelCnt", scrAprelCount);
			
			//if(scrIngList != null && !scrIngList.isEmpty()) {model.put("scrIngCnt",scrIngList.size());}else {model.put("scrIngCnt","0");}			
			//if(scrAprelList != null && !scrAprelList.isEmpty()) {model.put("scrAprelCnt",scrAprelList.size());} else {model.put("scrAprelCnt","0");}
			
			/* CTS Cnt */
			setData.put("ctrMode", "ING");
			setData.put("myCTR", "Y");
			setData.put("status", "");
			//List ctsIngList = commonService.selectList("ctr_SQL.getCTRMst_gridList", setData);
			String ctrIngCount = commonService.selectString("ctr_SQL.getCTRMSTCount", setData);
			model.put("ctsIngCnt",ctrIngCount);
			
			setData.put("ctrMode", "INPRG");
			//List ctsApreqList = commonService.selectList("ctr_SQL.getCTRMst_gridList", setData);
			String ctsApreqCount = commonService.selectString("ctr_SQL.getCTRMSTCount", setData);
			model.put("ctsApreqCnt", ctsApreqCount);
 			
			//if(ctsIngList != null && !ctsIngList.isEmpty()) {model.put("ctsIngCnt",ctsIngList.size());}else {model.put("ctsIngCnt","0");}			
			//if(ctsApreqList != null && !ctsApreqList.isEmpty()) {model.put("ctsApreqCnt",ctsApreqList.size());}else {model.put("ctsApreqCnt","0");}
			
			setMap.put("userID", userId);
			String memPhoto = StringUtil.checkNull(commonService.selectString("user_SQL.getUserPhoto",setMap));
			
			model.put("memPhoto", memPhoto);
			
			//  프로젝트 Cnt & 변경과제 Cnt
			setMap.put("languageID", languageID);
			setMap.put("AuthorID", userId);
			setMap.put("ProjectType", "PJT");
			setMap.put("InStatus","'OPN'");
			List pjtList = commonService.selectList("project_SQL.getParentPjtList",setMap);
			
			if(pjtList != null && !pjtList.isEmpty()) {
				model.put("ownerPjtCnt",pjtList.size());
			}
			else {
				model.put("ownerPjtCnt","0");
			}
			
			setMap.put("ProjectType", "CSR");
			setMap.remove("InStatus");
			setMap.put("csrStatus", "ING");
			List csrList = commonService.selectList("project_SQL.getMyCsrList",setMap);
			if(csrList != null && !csrList.isEmpty()) {
				model.put("ownerCsrCnt",csrList.size());
			}
			else {
				model.put("ownerCsrCnt","0");
			}
			
			setMap.put("ProjectType", "PJT");
			setMap.put("loginUserId",userId);
			setMap.put("openPJT","ING");
			
			List pjtWorkList = commonService.selectList("project_SQL.getParentPjtFromRel",setMap);
			
			setMap.put("ProjectType", "CSR");	
			setMap.put("csrStatus", "ING");
			
			setMap.put("memberId", userId);
			setMap.remove("Status");
			setMap.remove("AuthorID");
			List csrWorkList = commonService.selectList("project_SQL.getMyCsrList",setMap);
			setMap.put("AuthorID", userId);
			
			if(pjtWorkList != null && !pjtWorkList.isEmpty()) {
				model.put("workerPjtCnt",pjtWorkList.size());
			}
			else {
				model.put("workerPjtCnt","0");
			}
			
			if(csrWorkList != null && !csrWorkList.isEmpty()) {
				model.put("workerCsrCnt",csrWorkList.size());
			}
			else {
				model.put("workerCsrCnt","0");
			}
			model.put("srType",srType);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/esrListMgt.do")
	public String esrListMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/esm/esrListMgt"; 
		try {
				JSONObject jsonData = new JSONObject();
				Enumeration params = request.getParameterNames();
				while (params.hasMoreElements()){
				    String name = (String)params.nextElement();
				    jsonData.put(name,request.getParameter(name));
				}
				model.put("jsonData",jsonData);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}	

	@RequestMapping(value = "/getSRCatAttrList.do")
	public void getSRCatAttrList(HttpServletRequest request, HashMap commandMap, HttpServletResponse res) throws Exception {
		HashMap target = new HashMap();
		try {
				Map setData = new HashMap();				
				String srID = StringUtil.checkNull(commandMap.get("srID"),"");
				String SRCatID = StringUtil.checkNull(commandMap.get("SRCatID"),"");
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				
				setData.put("srID", srID);
				setData.put("SRCatID", SRCatID);
				setData.put("languageID", languageID);
				List srCatAttrList = commonService.selectList("esm_SQL.getSRCatAttrList", setData);
				
				String attrTypeCode = "";
				String dataType = "";
				if(srCatAttrList.size() > 0) {
					for(int i=0; i<srCatAttrList.size(); i++) {
						Map srCatAttrMap = (Map) srCatAttrList.get(i);
						attrTypeCode = StringUtil.checkNull(srCatAttrMap.get("AttrTypeCode"));
						dataType = StringUtil.checkNull(srCatAttrMap.get("DataType"));
						setData.put("s_itemID", attrTypeCode);
						setData.put("attrTypeCode", attrTypeCode);
						setData.put("languageID", languageID);
						if(dataType.equals("LOV")) {
							List lovList = commonService.selectList("attr_SQL.selectAttrLovOption", setData);
							srCatAttrMap.put("lovList", new JSONArray(lovList));
						}else if(dataType.equals("MLOV")) {
							List MLovList =  commonService.selectList("attr_SQL.getMLovListWidthSRAttr", setData);
							srCatAttrMap.put("MLovList", MLovList);
						}
					}
				}
				
				JSONArray srCatAttrJSONList = new JSONArray(srCatAttrList);		
				
				res.setHeader("Cache-Control", "no-cache");
				res.setContentType("text/plain");
				res.setCharacterEncoding("UTF-8");
				if(!StringUtil.checkNull(srCatAttrJSONList).equals("")){
					res.getWriter().print(srCatAttrJSONList);
				}			
		} catch (Exception e) {
			System.out.println(e);
		}
	}
	
	@RequestMapping(value = "/modifySRDetail.do")
	public String modifySRDetail(MultipartHttpServletRequest request, HashMap  commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		try {
			HashMap setData = new HashMap();		
			HashMap updateData = new HashMap();
			HashMap mailData = new HashMap();
		
			String srType = StringUtil.checkNull(xss.getParameter("srType"));
			String srID = StringUtil.checkNull(xss.getParameter("srID"));
			String category = StringUtil.checkNull(xss.getParameter("category"));
			String srMode = StringUtil.checkNull(xss.getParameter("srMode"));
			String scrnType = StringUtil.checkNull(xss.getParameter("scrnType"));
			
			// sr 정보수정
			String srArea1 = StringUtil.checkNull(xss.getParameter("srArea1"));
			String srArea2 = StringUtil.checkNull(xss.getParameter("srArea2"));
			String srArea3 = StringUtil.checkNull(xss.getParameter("srArea3"));
			String srReason = StringUtil.checkNull(xss.getParameter("srReason"));
			String itsmIF = StringUtil.checkNull(xss.getParameter("itsmIF"));
			String subject = StringUtil.checkNull(xss.getParameter("subject"));
			String description = StringUtil.checkNull(xss.getParameter("description"));
			
			// 선택된 시스템(srArea2)의 ProjectID 취득 x
			setData.put("srArea2", srArea2);
			String projectID = StringUtil.checkNull(commonService.selectString("sr_SQL.getProjectIDFromL2", setData)).trim();
			updateData.put("projectID", projectID);
			updateData.put("srID", srID);
			updateData.put("srType", srType);
			updateData.put("srArea1", srArea1);
			updateData.put("srArea2", srArea2);
			
			setData.put("s_itemID",srArea3);
			updateData.put("itemTypeCode", commonService.selectString("item_SQL.selectedItemTypeCode",setData));			
			updateData.put("srArea3", srArea3);			
			updateData.put("lastUser", commandMap.get("sessionUserId"));
			updateData.put("srReason", srReason);
			updateData.put("itsmIF", itsmIF);
			updateData.put("subject", subject);
			updateData.put("description",description);
			
			if(srID != null && !"".equals(srID)){
				
				// 1. SR 기본 정보 수정
				commonService.update("esm_SQL.updateESMSR", updateData);	
				
				// 2. Receipt User 설정 
				Map receiptInfoMap = new HashMap();
				Map authorInfo = new HashMap(); // ISP Item 지정
				String receiptUserID ="";
				String receiptTeamID ="";
				
				// 2-1. type 1 ( 기존 설정 그대로 사용 )
				receiptUserID = StringUtil.checkNull(xss.getParameter("receiptUserID"));
				receiptTeamID = StringUtil.checkNull(xss.getParameter("receiptTeamID"));
				receiptInfoMap.put("UserID",receiptUserID);
				receiptInfoMap.put("TeamID",receiptTeamID);
				
				// 3. RoleType 설정
				setData.put("srCatID",category);
				setData.put("srType", srType);
				Map RoleAssignMap =  commonService.select("esm_SQL.getESMSRAreaFromSrCat", setData);
				String roleType = StringUtil.checkNull(RoleAssignMap.get("RoleType"));
				
				// 4. SR 메일 수신자 설정
				Map receiverMap = new HashMap();
				List receiverList = new ArrayList();		
				if(!receiptInfoMap.isEmpty() && receiptInfoMap != null){
					setData.put("memberID", receiptUserID);
					Map checkMemberActiveInfo = commonService.select("user_SQL.getCheckMemberActive", setData);
					if(checkMemberActiveInfo != null && !checkMemberActiveInfo.isEmpty()){
						mailData.put("receiptUserID", checkMemberActiveInfo.get("MemberID"));
						mailData.put("receiptTeamID", checkMemberActiveInfo.get("TeamID"));
						receiverMap.put("receiptUserID", checkMemberActiveInfo.get("MemberID"));
					}else{
						mailData.put("receiptUserID", receiptUserID);
						mailData.put("receiptTeamID", receiptTeamID);
						receiverMap.put("receiptUserID", receiptUserID);
					}
					receiverList.add(0,receiverMap);
					
				}else{
					mailData.put("receiptUserID", "1");
					setData.put("userID", "1");
					Map recTeamInfoMap = commonService.select("user_SQL.memberTeamInfo", setData);
					mailData.put("receiptTeamID",recTeamInfoMap.get("TeamID"));
					receiverMap.put("receiptUserID", "1");
					receiverList.add(0,receiverMap);
				}
				
				if(srArea3.isEmpty()) {	//ITSP
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
					}
				}
				
				
				// 5. SR 참조 수정
				String sharers = StringUtil.checkNull(xss.getParameter("sharers"));
				String refMembers[] = sharers.split(",");
				int receiverIndex = receiverList.size();
				
				if(!sharers.equals("") && sharers != null){
					// 참조 insert
					for(int i=0; refMembers.length > i; i++){
						setData.put("SRID", srID);
						setData.put("memberID", refMembers[i]);
			   			setData.put("sessionUserId", refMembers[i]);
			   			setData.put("mbrTeamID", commonService.selectString("user_SQL.userTeamID", setData));
						setData.put("assignmentType", "SRROLETP");
						setData.put("roleType", roleType);
						setData.put("orderNum", i+1);
						setData.put("assigned", "1");	
						setData.put("accessRight", "R");	
						setData.put("creator", commandMap.get("sessionUserId"));
						
						Map srMbrInfo = commonService.select("esm_SQL.getESMSRMember", setData);
						if(srMbrInfo.isEmpty()){
							commonService.insert("esm_SQL.insertESMSRMember", setData);
						}
						
						// 참조자 메일 설정
						receiverMap = new HashMap();
						receiverMap.put("receiptUserID", refMembers[i]); 
						receiverMap.put("receiptType", "CC");
						receiverList.add(receiverIndex,receiverMap);
						receiverIndex++;
					}
				}
				
				// 6. 기존  참조 delete
				setData.put("SRID", srID);
				setData.put("memberIDs", sharers);
				setData.put("assignmentType", "SRROLETP");
				setData.put("roleType", roleType);
				commonService.delete("esm_SQL.deleteSRMbr",setData);
				
				// 7. SR 첨부파일 insert : TB_SR_FILE 
				commandMap.put("projectID", projectID);
				insertESMSRFiles(commandMap, srID);
				
				//======================================
				// 8. send Email
				System.out.println("receiverList :"+receiverList);
				
				String emailCode = "SRREQ" ;
				mailData.put("receiverList", receiverList);
				mailData.put("subject", StringUtil.checkNull(subject));
				Map setMailMapRst = (Map)setEmailLog(request, commonService, mailData, emailCode);
				System.out.println("setMailMapRst : "+setMailMapRst );
				
				if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
					HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
					setData.put("srID", srID);
					setData.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
					HashMap cntsMap = (HashMap)commonService.select("esm_SQL.getESMSRInfo", setData);
										
					cntsMap.put("userID", mailData.get("receiptUserID"));
					cntsMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
					String receiptLoginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", cntsMap));
					cntsMap.put("loginID", receiptLoginID);
					
					cntsMap.put("emailCode", emailCode);
					String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", cntsMap));
					cntsMap.put("emailHTMLForm", emailHTMLForm);
					
					cntsMap.put("emailCode", "SRREQ");
					cntsMap.put("subTitle", "");
					Map resultMailMap = EmailUtil.sendMail(mailMap,cntsMap, getLabel(request, commonService));
					
				}else{
					System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
				}
				
				model.put("pageNum", StringUtil.checkNull(xss.getParameter("pageNum")));
				model.put("projectID", StringUtil.checkNull(xss.getParameter("projectID")));
				model.put("srID", srID);
				model.put("srType", srType);
				model.put("srMode", srMode);
				model.put("scrnType", scrnType);
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				target.put(AJAX_SCRIPT, "parent.doCallBackMove();$('#isSubmit').remove()");
			} else {
				target.put(AJAX_SCRIPT, "$('#isSubmit').remove()");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			}
				
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
}
