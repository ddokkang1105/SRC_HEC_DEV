package xbolt.app.esm.isp.web;
import java.io.File;
import java.io.FileOutputStream;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.text.StringEscapeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

import com.org.json.JSONArray;
import com.org.json.JSONObject;

@Controller
@SuppressWarnings("unchecked")
public class ISPActionController extends XboltController {
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "esmService")
	private CommonService esmService;
	
	@RequestMapping(value="/ispMain.do")
	public String ispMain(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception{
		Map setData = new HashMap();
		setData.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
		setData.put("sessionUserId", cmmMap.get("sessionUserId"));
		setData.put("templCode", "TMPL003");		
		Map templateMap = commonService.select("menu_SQL.mainTempl_select",setData);
		
		model.put("templateMap", templateMap);
		model.put("menu", getLabel(request, commonService));	//Label Setting
		model.put("screenType", request.getParameter("screenType"));
		return nextUrl("/app/esm/isp/ispMain"); 
	}
	
	@RequestMapping(value = "/ispMgt.do")
	public String ispMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/esm/isp/ispMgt"; 
		try {
				String parentId = StringUtil.checkNull(request.getParameter("s_itemID"));
				String srMode = StringUtil.checkNull(request.getParameter("srMode"));				
				String scrnType = StringUtil.checkNull(cmmMap.get("screenType"),request.getParameter("scrnType")); 
				String mainType = StringUtil.checkNull(cmmMap.get("mainType"),request.getParameter("mainType"));
				String srType = StringUtil.checkNull(request.getParameter("srType"));
				String varFilter = StringUtil.checkNull(request.getParameter("varFilter"));
				String itemProposal = StringUtil.checkNull(cmmMap.get("itemProposal"),request.getParameter("itemProposal"));
				String focusMenu = StringUtil.checkNull(request.getParameter("focusMenu"));
				String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
				String defCategory = StringUtil.checkNull(request.getParameter("defCategory"));

				cmmMap.put("srTypeCode", srType);
				Map srTypeInfo = commonService.select("esm_SQL.getESMSRTypeInfo",cmmMap);
				String srVarFilter = StringUtil.checkNull(srTypeInfo.get("VarFilter"));
				
				cmmMap.put("typeCode", srType);
				cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				cmmMap.put("category", "SRTP");
				String srTypeNM = commonService.selectString("common_SQL.getNameFromDic",cmmMap);
				
//				if(scrnType.equals("srRqst") || scrnType.equals("srDsk")){ 
//					url = "/app/esm/itsp/itspReqMain";
//				}
			
				List boardMgtList = commonService.selectList("board_SQL.boardMgtSRtypeAllocList", cmmMap);
				
				model.put("boardMgtList", boardMgtList);
				model.put("varFilter", varFilter );
				model.put("itemProposal", itemProposal );
				model.put("scrnType", scrnType );
				model.put("srMode",  srMode);
				model.put("srType",  srType);			
				model.put("srID",  StringUtil.checkNull(request.getParameter("srID")));	
				model.put("sysCode",  StringUtil.checkNull(request.getParameter("sysCode")));	
				model.put("parentID", parentId);
				model.put("mainType", mainType);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */		
				model.put("focusMenu", focusMenu);
				model.put("arcCode", arcCode);
				model.put("srVarFilter", srVarFilter);
				model.put("srTypeNM", srTypeNM);
				model.put("defCategory", defCategory);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/ispList.do")
	public String ispList(HttpServletRequest request, HashMap cmmMap,  HashMap commandMap,   ModelMap model,HttpServletResponse response) throws Exception {
		String url = "/app/esm/isp/ispList";
		try {
			Map setData = new HashMap();
			
			String srType = StringUtil.checkNull(cmmMap.get("srType"),request.getParameter("srType")); 
			String itemID = StringUtil.checkNull(commandMap.get("s_itemID"),request.getParameter("itemID")); // Item Menu에서 리스트 출력 시 사용
			String projectID = StringUtil.checkNull(commandMap.get("projectID"),""); 
			String srMode = StringUtil.checkNull(request.getParameter("srMode"));
			String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
			String varFilter = StringUtil.checkNull(request.getParameter("varFilter"));
			String multiComp = StringUtil.checkNull(request.getParameter("multiComp"));
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
			String menuStyle = StringUtil.checkNull(request.getParameter("menuStyle"));
			
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
			String searchReqCompany = StringUtil.checkNull(cmmMap.get("reqCompany"));
			
			String itemTypeCodeItemID = null;
			
			setData.put("s_itemID", itemID);
			setData.put("languageID", languageID);
			setData.put("srType",StringUtil.checkNull(srType,varFilter));
			
			setData.put("level", 1);
			String srAreaLabelNM1 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
			String srArea1ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);
			setData.put("level", 2);
			String srAreaLabelNM2 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
			String srArea2ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);

			model.put("srArea1ClsCode", srArea1ClsCode);
			model.put("srArea2ClsCode", srArea2ClsCode);
			
			setData.put("typeCode", "SRArea1");
			String srArea1 = commonService.selectString("common_SQL.getNameFromDic",setData);
			setData.put("typeCode", "SRArea2");
			String srArea2 = commonService.selectString("common_SQL.getNameFromDic",setData);
			
			Map setMap = new HashMap();
			setMap.put("srTypeCode", StringUtil.checkNull(srType,varFilter));				
			Map SRTypeMap = commonService.select("esm_SQL.getESMSRTypeInfo",setMap);

			model.put("refID", projectID);
			model.put("scrnType", scrnType);
			model.put("srStatus", searchSRStatus);
			model.put("srMode", srMode);
			model.put("srType", StringUtil.checkNull(srType,varFilter));
			model.put("projectID", projectID);
			model.put("itemID", itemID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("srID", srID);
			model.put("mainType", StringUtil.checkNull(request.getParameter("mainType")));
			model.put("sysCode", StringUtil.checkNull(request.getParameter("sysCode")));
			model.put("multiComp", multiComp);
			model.put("itemTypeCode", StringUtil.checkNull(itemTypeCodeItemID,itemTypeCode));
			model.put("srAreaLabelNM1", srAreaLabelNM1);
			model.put("srAreaLabelNM2", srAreaLabelNM2);
			model.put("menuStyle",menuStyle);
			model.put("arcCode", arcCode);
			model.put("varFilter", varFilter);
			model.put("searchStatus", searchStatus);
			model.put("defCategory", StringUtil.checkNull(cmmMap.get("defCategory")));
			
			//검색조건 jsp setting		
			model.put("category", searchCategory);
			model.put("subCategory", searchSubCategory);
			model.put("srArea1", searchSRArea1);
			model.put("srArea2", searchSRArea2);
			model.put("subject", searchSubject);
			model.put("status", StringUtil.checkNull(cmmMap.get("status")));				
			model.put("receiptUser", searchReceiptUser);
			model.put("requestUser", searchRequestUser);
			model.put("requestTeam", searchRequestTeam);
			model.put("srReceiptTeam", searchReceiptTeam);
			model.put("startRegDT", searchStartRegDT);
			model.put("endRegDT", searchEndRegDT);
			model.put("searchSrCode", searchSRCode);
			
			// searchOption setting 
			Map ispMap = new HashMap();
			
			ispMap.put("languageID", languageID);
			ispMap.put("scrnType", scrnType);
			ispMap.put("srMode", srMode);
			ispMap.put("srType", srType);
			ispMap.put("itemID", itemID);
			ispMap.put("category", searchCategory);
			ispMap.put("srCode", searchSRCode);
			ispMap.put("srArea1", searchSRArea1);
			ispMap.put("subject", searchSubject);
			ispMap.put("receiptUserName", searchReceiptUser);
			ispMap.put("requestTeam", searchRequestTeam);
			ispMap.put("requestUserName", searchRequestUser);
			ispMap.put("regStartDate", searchStartRegDT);
			ispMap.put("regEndDate", searchEndRegDT);
			
			if(itemID == "" || itemID == null){
				if("".equals(projectID)){
					ispMap.put("receiptUser", searchReceiptUser);
					ispMap.put("srReceiptTeam", searchReceiptTeam);
				}
			}
			if(!"".equals(searchStatus) || !"".equals(searchSRStatus)){
				ispMap.put("srStatus", searchSRStatus);
			}
			
			if("mySR".equals(srMode) || "myVOC".equals(srMode) || srMode == "myTR"){
				ispMap.put("loginUserId",commandMap.get("sessionUserId"));
			} else if("PG".equals(srMode) || "PJT".equals(srMode)){
				ispMap.put("refID",projectID);
			} else if("myTeam".equals(srMode)){
				ispMap.put("myTeamId",commandMap.get("sessionTeamId"));
			}
			
			if("Y".equals(multiComp) && !"".equals(searchReqCompany)){							
				ispMap.put("companyList",searchReqCompany);
			}
			
			List ispList = commonService.selectList("esm_SQL.getEsrMSTList_gridList",ispMap);
			JSONArray gridData = new JSONArray(ispList);
			model.put("gridData",gridData);
			
			if(srMode.equals("mySr")){
				model.put("requstUser", cmmMap.get("sessionUserNm"));
			}
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/registerISP.do")
	public String registerISP(HttpServletRequest request, HashMap cmmMap, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esm/isp/registerISP";
		try {
				List attachFileList = new ArrayList();
				//Map setMap = new HashMap();
				
				Map setData = new HashMap();
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType")); 
				String srType = StringUtil.checkNull(cmmMap.get("srType"),request.getParameter("srType")); 
				String parentId = StringUtil.checkNull(request.getParameter("parentID")); 
				String itemProposal = StringUtil.checkNull(cmmMap.get("itemProposal"));
				String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"));
//				if(itemProposal.equals("Y")){
//					url = "/app/esm/itmp/registerItsp";
//				}
				String varFilter = StringUtil.checkNull(cmmMap.get("varFilter"));
				String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
				String itemTypeCode = StringUtil.checkNull(cmmMap.get("itemTypeCode"));
				
				
				setData.put("srType",srType);
				setData.put("s_itemID", itemID);
				setData.put("languageID", commandMap.get("sessionCurrLangType"));
				
				setData.put("srType",StringUtil.checkNull(srType,varFilter));
				
				setData.put("level", 1);
				String srAreaLabelNM1 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				String srArea1ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);
				setData.put("level", 2);
				String srAreaLabelNM2 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				String srArea2ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);
				
				
				
				
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
				model.put("defCategory", StringUtil.checkNull(cmmMap.get("defCategory")));
				
				// List 검색조건 setting
				model.put("srCategory", StringUtil.checkNull(cmmMap.get("category")));
				model.put("srArea1", StringUtil.checkNull(cmmMap.get("srArea1")));
				model.put("srArea2", StringUtil.checkNull(cmmMap.get("srArea2")));
				model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
				model.put("status", StringUtil.checkNull(cmmMap.get("status")));				
				model.put("searchSrCode", StringUtil.checkNull(cmmMap.get("searchSrCode")));
				model.put("subject", StringUtil.checkNull(cmmMap.get("subject")));
				model.put("srReceiptTeam", StringUtil.checkNull(cmmMap.get("srReceiptTeam")));
				model.put("crReceiptTeam", StringUtil.checkNull(cmmMap.get("crReceiptTeam")));
				
				model.put("arcCode", arcCode);
				model.put("varFilter", varFilter);
				model.put("itemID", itemID);
				model.put("itemTypeCode", itemTypeCode);
				model.put("srAreaLabelNM1", srAreaLabelNM1);
				model.put("srAreaLabelNM2", srAreaLabelNM2);
				
				//Call PROC_LOG START TIME
				setInitProcLog(request);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/createISPMst.do")
	public String createISPMst(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
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
			String proposal = StringUtil.checkNull(xss.getParameter("proposal"));
			String srMode = StringUtil.checkNull(xss.getParameter("srMode"));
			String scrnType = StringUtil.checkNull(xss.getParameter("scrnType"));
			String srType = StringUtil.checkNull(xss.getParameter("srType"));
			String requestUserID = StringUtil.checkNull(xss.getParameter("requestUserID"));
			String reqdueDate = StringUtil.checkNull(xss.getParameter("reqdueDate"));
			String reqDueDateTime = StringUtil.checkNull(xss.getParameter("reqDueDateTime"));
			String category = StringUtil.checkNull(xss.getParameter("category"));
			String subject = StringUtil.checkNull(xss.getParameter("subject"));
			String description = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(commandMap.get("description")));
			String srArea3 = StringUtil.checkNull(commandMap.get("rootItemID"));	// 개정 요청할 item
			String itemTypeCode = "";
			if(srArea3.isEmpty()) { itemTypeCode = xss.getParameter("itemTypeCd"); } 
			else { itemTypeCode = xss.getParameter("itemTypeCode"); }
			String emailCode = "SRREQ" ;
//			String itemProposal =  StringUtil.checkNull(xss.getParameter("itemProposal"));
//			String varFilter = StringUtil.checkNull(xss.getParameter("varFilter"));
//			model.put("varFilter", varFilter);
			
			setData.put("memberID", requestUserID);
			String companyID = StringUtil.checkNull(commonService.selectString("user_SQL.getMemberCompanyID", setData));
			
			/* 시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyMMdd").format(cal.getTime());
			setData.put("thisYmd", thisYmd);
			maxSrId = StringUtil.checkNull(commonService.selectString("esm_SQL.getMaxESMSrID", setData)).trim();
			curmaxSRCode = StringUtil.checkNull(commonService.selectString("esm_SQL.getMaxESMSRCode", setData)).trim();				
			if(curmaxSRCode.equals("")){ // 당일 SR이 없으면
				maxSRCode = "SR"  + thisYmd + "0001";
			} else {
				curmaxSRCode = curmaxSRCode.substring(curmaxSRCode.length() - 4, curmaxSRCode.length());
				int curSRCode = Integer.parseInt(curmaxSRCode) + 1;
				maxSRCode =  "SR" +  thisYmd + String.format("%04d", curSRCode);	
			}
			
			// srArea1, srArea2 classCode 조회
			setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")) );			
			setData.put("srType", srType);
			setData.put("itemID", srArea3);
			setData.put("itemTypeCode", itemTypeCode);
			setData.put("level", "1");
			String srArea1ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);
			setData.put("classCode", srArea1ClsCode);
			String srArea1 = commonService.selectString("esm_SQL.getSuperiorItemByClass", setData);
			
			setData.put("level", "2");
			String srArea2ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);
			setData.put("classCode", srArea2ClsCode);
			String srArea2 = commonService.selectString("esm_SQL.getSuperiorItemByClass", setData);
			
//			setData.put("srCatID", subCategory);
//			Map categoryInfo= commonService.select("config_SQL.getAllSRCatMgtList_gridList", setData);
//			String category = StringUtil.checkNull(categoryInfo.get("ParentID"));
			
			// 변경제안 아이템의 projectID
			String projectID = commonService.selectString("item_SQL.getProjectIDFromItem",setData);
			insertData.put("projectID", projectID);
			insertData.put("srID", maxSrId);
			insertData.put("srCode", maxSRCode);
			insertData.put("srType", srType);
			insertData.put("subject", subject);
			insertData.put("description", description);
			insertData.put("category", category); 
//			insertData.put("subCategory", subCategory); 
			insertData.put("requestUserID", requestUserID);
			insertData.put("srArea1", srArea1);
			insertData.put("srArea2", srArea2);
			insertData.put("srArea3", srArea3);
			insertData.put("regUserID", commandMap.get("sessionUserId"));
			insertData.put("regTeamID", commandMap.get("sessionTeamId"));
			insertData.put("companyID", companyID);	
			insertData.put("itemTypeCode", itemTypeCode);	
			if(!reqDueDateTime.equals("") ) {
				reqdueDate = reqdueDate+" "+reqDueDateTime;	
			}
			insertData.put("reqdueDate", reqdueDate);
			
			// 선택된 카테고리의 접수자/접수팀  정보 취득
			setData.put("srType", srType);
			setData.put("srCatID", category);
			Map srCatInfo =  commonService.select("esm_SQL.getESMSRAreaFromSrCat", setData);
			insertData.put("procPathID", srCatInfo.get("ProcPathID"));
			
			
			setData.put("itemClassCode", "CL03004");
						
			setMap.put("procPathID", StringUtil.checkNull(srCatInfo.get("ProcPathID")));
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
			
			Map authorInfo = new HashMap();
			// item 담당자 정보 // 선택된 srArea3의 Item Type 취득
			if(srArea3.isEmpty()) {
				setData.put("srCatID", category);
				authorInfo = commonService.select("esm_SQL.getESMSRCatMagager", setData);
			} else {
				setData.put("s_itemID", srArea3);
				authorInfo = commonService.select("item_SQL.getObjectInfo", setData);
			}

			insertData.put("receiptUserID", authorInfo.get("AuthorID"));
			insertData.put("receiptTeamID", authorInfo.get("OwnerTeamID"));
			
			Map RoleAssignMap =  commonService.select("esm_SQL.getESMSRAreaFromSrCat", setData);
			String processType = StringUtil.checkNull(RoleAssignMap.get("ProcessType"));
			
			Map receiptInfoMap = new HashMap();
			setData.put("teamID", reqTeamInfoMap.get("TeamID"));
			if(processType.equals("4")){ // 부서장 검토 
				receiptInfoMap = commonService.select("user_SQL.getUserTeamManagerInfo", setData);
				insertData.put("status", "MRV"); // 소속부서장 검토 
				emailCode = "SRMRV" ;
			}else{
				receiptInfoMap = authorInfo;
			}
			
			
			// 메일 수신자 설정
			Map receiverMap = new HashMap();
			List receiverList = new ArrayList();		
			String receiptUserID = StringUtil.checkNull(receiptInfoMap.get("AuthorID"));
			if(receiptInfoMap != null){							
				setData.put("memberID", receiptUserID);
				Map checkMemberActiveInfo = commonService.select("user_SQL.getCheckMemberActive", setData);
				if(checkMemberActiveInfo != null && !checkMemberActiveInfo.isEmpty()){
					insertData.put("receiptUserID", checkMemberActiveInfo.get("MemberID"));
					insertData.put("receiptTeamID", checkMemberActiveInfo.get("TeamID"));
					receiverMap.put("receiptUserID", checkMemberActiveInfo.get("MemberID"));
				}else{
					insertData.put("receiptUserID", receiptInfoMap.get("AuthorID"));
					insertData.put("receiptTeamID", receiptInfoMap.get("OwnerTeamID"));
					receiverMap.put("receiptUserID", receiptInfoMap.get("AuthorID"));
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
			
			// ItemProposal = Y
			String maxProcInstNo = "";
			// if(itemProposal.equals("Y")){
				insertData.put("proposal", proposal);
				
				maxProcInstNo = StringUtil.checkNull(commonService.selectString("instance_SQL.maxProcInstNo",setMap)).trim();
				maxProcInstNo = maxProcInstNo.substring(maxProcInstNo.length() - 5, maxProcInstNo.length());
				int curProcInstCode = Integer.parseInt(maxProcInstNo) + 1;
				String ProcInstNo = "P" + String.format("%09d", curProcInstCode);
				
				insertData.put("ProcInstNo", ProcInstNo);
			//}
			
			setMap.put("srTypeCode",srType);
			setMap.put("procPathID", StringUtil.checkNull(srCatInfo.get("ProcPathID")));
			Map srTypeMap = commonService.select("esm_SQL.getESMSRTypeInfo", setMap);
			
			insertData.put("defWFID", srTypeMap.get("DefWFID"));
			commonService.insert("esm_SQL.insertSRMst", insertData);
			commonService.insert("esm_SQL.insertIspNip", insertData);
			
			// Sr 첨부파일 등록 : TB_SR_FILE 
			commandMap.put("projcetID", projectID);
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
			
			setProcHistory.put("instanceNo", ProcInstNo);
			setProcHistory.put("processID", ProcessInfo.get("ItemID"));
			setProcHistory.put("ProcModelID", srTypeMap.get("ProcModelID"));
			setProcHistory.put("ProcPathID", StringUtil.checkNull(srCatInfo.get("ProcPathID")));
			setProcHistory.put("status", "00");
			setProcHistory.put("dueDate", reqdueDate);
			setProcHistory.put("InstanceClass", "CL03004");
			setProcHistory.put("ownerID", ProcessInfo.get("AuthorID"));
			setProcHistory.put("ownerTeamID", ProcessInfo.get("OwnerTeamID"));
			setProcHistory.put("procType", srType);
			setProcHistory.put("docCategory", "SR");
			setProcHistory.put("documentNo", maxSrId);
			
//			commonService.insert("instance_SQL.insertProcInst", setProcHistory);	
	
			// 참조자 메일 발송 
			String sharers = StringUtil.checkNull(request.getParameter("sharers"));
			String refMembers[] = sharers.split(",");
			int receiverIndex = receiverList.size();
			
			if(!sharers.equals("") && sharers != null){
				// Insert ESM_SR_MBR 				
				for(int i=0; refMembers.length > i; i++){
					setData = new HashMap();					
					setData.put("SRID", maxSrId);	
					setData.put("memberID", refMembers[i]);
		   			setData.put("sessionUserId", refMembers[i]);
		   			setData.put("mbrTeamID", commonService.selectString("user_SQL.userTeamID", setData));
					setData.put("assignmentType", "SRROLETP");	
//					setData.put("roleType", RoleAssignMap.get("RoleType"));	
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
				cntsMap.replace("CategoryName", cntsMap.get("SubCategoryName"));
				
				cntsMap.put("emailCode", emailCode);
				String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", cntsMap));
				cntsMap.put("emailHTMLForm", emailHTMLForm);
								
				Map resultMailMap = EmailUtil.sendMail(mailMap,cntsMap, getLabel(request, commonService));
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMapRst.get("msg")));
				
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
	
	@RequestMapping(value = "/processISP.do")
	public String processISP(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/esm/isp/viewISPDetail";
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
				String varFilter = StringUtil.checkNull(cmmMap.get("varFilter"));	
				String multiComp = StringUtil.checkNull(cmmMap.get("multiComp"));
				String itemTypeCode = StringUtil.checkNull(cmmMap.get("itemTypeCode"));
				
				String itemProposal = StringUtil.checkNull(cmmMap.get("itemProposal"));
				String defCategory = StringUtil.checkNull(cmmMap.get("defCategory"));
				
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

				setData.put("srID", srID);
				setData.put("srType", srType);
				setData.put("srCode", srCode);
				setData.put("languageID", languageID);
				Map srInfoMap = commonService.select("esm_SQL.getESMSRInfo", setData);	
								
				String blocked = StringUtil.checkNull(srInfoMap.get("Blocked"));
				String option = StringUtil.checkNull(cmmMap.get("option"));
				if(sessionUserID.equals(receiptUserID) //  사용자 = 접수자
				   && !scrnType.equals("srRqst") // SR 등록 메뉴가 아니고
				   && (blocked.equals("0") || "modifyCMP".equals(option))) // 상태가 조치완료나 마감이 아닐 경우 or **완료-[수정] 제외
				{ // SR 접수 처리로 이동 
					if(!isPopup.equals("Y")){url = "/app/esm/isp/processISP";} // SR모니터링 팝업이 아니면
				}
				
				
				// proposal == 01 이메일 전송
				if(sessionUserID.equals(receiptUserID) && status.equals("SPE018") && StringUtil.checkNull(srInfoMap.get("Proposal")).equals("01")){ 
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
				setData.remove("srType");
				List procStatusList = commonService.selectList("esm_SQL.getProcStatusList", setData);    // 예상 진행 리스트
				
								
				setData.put("procPathID", StringUtil.checkNull(srInfoMap.get("ProcPathID")) );
				setData.put("languageID", cmmMap.get("sessionCurrLangType"));
				
				/* 첨부문서 취득 */
				attachFileList = commonService.selectList("sr_SQL.getSRFileList", setData);
				
				String appBtn = "N"; // app button 제어  
				if(!StringUtil.checkNull(srInfoMap.get("SubCategory")).equals("")
						&& !StringUtil.checkNull(srInfoMap.get("Comment")).equals("")
						){
					appBtn = "Y";
				}
				
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
				Long statusNo = null;
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
				
				setData.put("srCatID", srTypeInfo.get("Category"));
				setData.put("srType", srType);
				Map RoleAssignMap =  commonService.select("esm_SQL.getESMSRAreaFromSrCat", setData);
				
				setData.put("SRID",srID);
				setData.put("roleType", RoleAssignMap.get("RoleType"));
				setData.put("assignmentType", "SRROLETP");
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
				
				setMap = new HashMap();
				setMap.put("userId", sessionUserID);
				setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
				setMap.put("s_itemID", srInfoMap.get("SRArea3"));
				setMap.put("ProjectType", "CSR");
				setMap.put("isMainItem", "Y");
				List projectNameList = commonService.selectList("project_SQL.getProjectNameList", setMap);
				model.put("projectNameList", projectNameList.size());
				
				setData.put("languageID", languageID);
				Map itemInfo = commonService.select("item_SQL.getObjectInfo", setMap);
				
				model.put("sharerNames", sharerNames);				
				model.put("WFDocURL", StringUtil.checkNull(srTypeInfo.get("WFDocURL")));				
				model.put("itemProposal", itemProposal);
				model.put("getItemMap",getItemMap);
				model.put("srInfoMap", srInfoMap);
				model.put("prLgInfoList", prLgInfoList);
				model.put("procStatusList", procStatusList);
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
				model.put("multiComp", multiComp);
				model.put("itemTypeCode", itemTypeCode);
				model.put("status", StringUtil.checkNull(cmmMap.get("status")));
				model.put("itemStatus",itemInfo.get("Status"));
				model.put("option",option);
				
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
				model.put("varFilter", varFilter);
				model.put("defCategory", defCategory);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/updateITMStatus.do")
	public String updateITMStatus(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();		
		
			String srID = StringUtil.checkNull(cmmMap.get("srID"));
			String status = StringUtil.checkNull(cmmMap.get("status"));
			String svcCompl = StringUtil.checkNull(cmmMap.get("svcCompl"));
			String wfInstanceID = StringUtil.checkNull(cmmMap.get("wfInstanceID"));
			String wfInstanceStatus = StringUtil.checkNull(cmmMap.get("wfInstanceStatus"));
			String blockSR = StringUtil.checkNull(cmmMap.get("blockSR"));
			
			setData.put("wfInstanceID", wfInstanceID);
			setData.put("srID", srID);
			setData.put("status", status);		
			setData.put("lastUser", StringUtil.checkNull(cmmMap.get("sessionUserId")) );
			setData.put("svcCompl", svcCompl);	
			if(blockSR.equals("Y")) setData.put("blocked", "1");
			
			// System.out.println("Fixed Path YN : " + fixedPathYN + newProcPathID)	; 	
			String fixedPathYN = commonService.selectString("esm_SQL.getFixedPathYN",setData);	
			
			// ESM_PROC_CONFIG : SpeCode, ProcPathID
			Map srInfo = commonService.select("esm_SQL.getESMSRInfo", setData);
			setData.put("srType", srInfo.get("SRType"));
			setData.put("wfInstanceID", wfInstanceID);
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
	
	@RequestMapping(value = "/rejectISP.do")
	public String rejectISP(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();		
		
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String blockSR = StringUtil.checkNull(request.getParameter("blockSR"));
			String svcCompl = StringUtil.checkNull(request.getParameter("svcCompl"));
			
			setData.put("srID", srID);
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			
			// System.out.println("Fixed Path YN : " + fixedPathYN + newProcPathID)	; 	
			String fixedPathYN = commonService.selectString("esm_SQL.getFixedPathYN",setData);	
			
			Map srInfo = commonService.select("esm_SQL.getESMSRInfo", setData);
			setData.put("srType", srInfo.get("SRType"));
			setData.put("docCategory", "SR");
			setData.put("lastUser", StringUtil.checkNull(cmmMap.get("sessionUserId")));
			if(blockSR.equals("Y")) setData.put("blocked", "1");
			setData.put("svcCompl", svcCompl);
			
			// ESM_PROC_CONFIG : SpeCode, ProcPathID
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
	
	@RequestMapping(value = "/changeISPItem.do")
	public String changeISPItem(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap target = new HashMap();
		try{
			String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"), "");
			String srType = StringUtil.checkNull(request.getParameter("srType"), "");
			String srID = StringUtil.checkNull(request.getParameter("srID"), "");
			String subject = StringUtil.checkNull(request.getParameter("subject"), "");
			
			Map updateValMap = new HashMap();
			Map updateInfoMap = new HashMap();
			List updateList = new ArrayList();
			
			updateValMap.put("s_itemID",itemID);
			updateValMap.put("languageID",languageID);
			
			Map ItemMgtUserMap = new HashMap();
			ItemMgtUserMap = commonService.select("item_SQL.getObjectInfo", updateValMap);
			
			// srArea1, srArea2
			HashMap setData = new HashMap();
			setData.put("srID", srID);
			setData.put("itemID", itemID);
			setData.put("srType", srType);
			setData.put("languageID",languageID);
			setData.put("itemTypeCode", ItemMgtUserMap.get("ItemTypeCode"));
			setData.put("level", "1");
			String srArea1ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);
			setData.put("classCode", srArea1ClsCode);
			String srArea1 = commonService.selectString("esm_SQL.getSuperiorItemByClass", setData);
			
			setData.put("level", "2");
			String srArea2ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);
			setData.put("classCode", srArea2ClsCode);
			String srArea2 = commonService.selectString("esm_SQL.getSuperiorItemByClass", setData);
			
			updateValMap.put("languageID",languageID);
			updateValMap.put("srID",srID);
			updateValMap.put("receiptUserID",ItemMgtUserMap.get("AuthorID"));
			updateValMap.put("receiptTeamID",ItemMgtUserMap.get("OwnerTeamID"));
			updateValMap.put("srArea1",srArea1);
			updateValMap.put("srArea2",srArea2);
			updateValMap.put("srArea3",itemID);
			updateValMap.put("lastUser",commandMap.get("sessionUserId"));
			updateInfoMap.put("KBN", "update");
			updateInfoMap.put("SQLNAME", "esm_SQL.updateESMSR");
			updateList.add(updateValMap);
			esmService.save(updateList, updateInfoMap);
			target.put(AJAX_SCRIPT,"this.fnGoSRList();");
			model.addAttribute(AJAX_RESULTMAP, target);
			
			//Save PROC_LOG		
			Map setProcMapRst = (Map)setProcLog(request, commonService, setData);
			if(setProcMapRst.get("type").equals("FAILE")){
				String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
				System.out.println("Msg : "+Msg);
			}
			
			Map insertData = new HashMap();
			// 메일 수신자 설정
			Map receiverMap = new HashMap();
			List receiverList = new ArrayList();		
			String receiptUserID = StringUtil.checkNull(ItemMgtUserMap.get("AuthorID"));
			if(receiptUserID != null){	
				setData.put("memberID", receiptUserID);
				Map checkMemberActiveInfo = commonService.select("user_SQL.getCheckMemberActive", setData);
				if(checkMemberActiveInfo != null && !checkMemberActiveInfo.isEmpty()){
					insertData.put("receiptUserID", checkMemberActiveInfo.get("MemberID"));
					insertData.put("receiptTeamID", checkMemberActiveInfo.get("TeamID"));
					receiverMap.put("receiptUserID", checkMemberActiveInfo.get("MemberID"));
				}else{
					insertData.put("receiptUserID", "1");
					setData.put("userID", "1");
					Map recTeamInfoMap = commonService.select("user_SQL.memberTeamInfo", setData);
					insertData.put("receiptTeamID",recTeamInfoMap.get("TeamID"));
					receiverMap.put("receiptUserID", "1");
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
			
			//======================================
			//send Email
			Map setMap = new HashMap();
			insertData.put("subject", subject);
			insertData.put("receiverList", receiverList);
			String emailCode = "SRREQ" ;
			Map setMailMapRst = (Map)setEmailLog(request, commonService, insertData, emailCode);
			System.out.println("setMailMapRst : "+setMailMapRst );
			
			if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
				setMap.put("srID", srID);
				setMap.put("srType", srType);
				setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				HashMap cntsMap = (HashMap)commonService.select("esm_SQL.getESMSRInfo", setMap);
									
				cntsMap.put("userID", insertData.get("receiptUserID"));
				cntsMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				String receiptLoginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", cntsMap));
				cntsMap.put("loginID", receiptLoginID);
				
				cntsMap.put("emailCode", "SRREQ");
				cntsMap.replace("CategoryName", cntsMap.get("SubCategoryName"));
				String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", cntsMap));
				cntsMap.put("emailHTMLForm", emailHTMLForm);
								
				Map resultMailMap = EmailUtil.sendMail(mailMap,cntsMap, getLabel(request, commonService));
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMapRst.get("msg")));
				
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
			}
			
			
		} catch(Exception e){
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
		}		
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/processNextStep.do")
	public String processNextStep(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			
			// 1. Update SR Status
			HashMap setData = new HashMap();		
		
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String blockSR = StringUtil.checkNull(request.getParameter("blockSR"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			
			setData.put("srID", srID);
			setData.put("languageID", languageID);
			
			// System.out.println("Fixed Path YN : " + fixedPathYN + newProcPathID)	; 	
			String fixedPathYN = commonService.selectString("esm_SQL.getFixedPathYN",setData);	
			
			Map srInfo = commonService.select("esm_SQL.getESMSRInfo", setData);
			String status =  StringUtil.checkNull(srInfo.get("SRNextStatus"));
			String nextStatus = StringUtil.checkNull(srInfo.get("SRNextStatus"));
			
			setData.put("srType", srInfo.get("SRType"));
			setData.put("docCategory", "SR");
			setData.put("lastUser", StringUtil.checkNull(cmmMap.get("sessionUserId")));
			if(blockSR.equals("Y")) setData.put("blocked", "1");
			setData.put("status", nextStatus);
			
			commonService.update("esm_SQL.updateESMSR", setData);		
			
			// 2. Save PROC_LOG		
			Map setProcMapRst = (Map)setProcLog(request, commonService, setData);
			if(setProcMapRst.get("type").equals("FAILE")){
				String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
				System.out.println("Msg : "+Msg);
			}
			
			// 3. Send Mail 
			// 3-1 . find mail title [ OJ00003 / AT00089 ]
			String mailTitle = "[ITS - Service Request]";
			List attrList = new ArrayList();
			Map attrMap = new HashMap();
			
			attrMap.put("identifier", status);
			attrMap.put("itemTypeCode", "OJ00003");
			String s_itemID = commonService.selectString("item_SQL.getItemID", attrMap);
			
			attrMap.put("languageID", languageID);
			attrMap.put("defaultLang", languageID);
			
			attrMap.put("s_itemID", s_itemID);
			attrMap.put("AttrTypeCode", "AT00089"); // mail title
			attrMap.put("Editable", "1"); // mail title
			attrList = commonService.selectList("attr_SQL.getItemAttr", attrMap);
			
			if(attrList.size() > 0){
				Map resultMap = (Map) attrList.get(0);
				mailTitle = StringUtil.checkNull(resultMap.get("PlainText"));
			}
			
			// 3-2. send mail
			List receiverList = new ArrayList();
			Map receiverMap = new HashMap();
			Map updateData = new HashMap();
			
			String requestUserID = StringUtil.checkNull(srInfo.get("RequestUserID"));
			String requestTeamID = StringUtil.checkNull(srInfo.get("RequestTeamID"));
			
			receiverMap.put("receiptUserID", requestUserID); // SR 조치 시는 수신자가 조치자(ReceiptUser)가 아닌 RequestUser의 이메일로 송신
			receiverList.add(0,receiverMap);
			updateData.put("receiverList", receiverList);
			
			// 참조자 메일 발송 
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
			
			updateData.put("subject", StringUtil.checkNull(srInfo.get("Subject")));
			updateData.put("receiverList", receiverList);
			Map setMailMapRst = (Map)setEmailLog(request, commonService, updateData, "SRCMP");
			if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
				HashMap setMap = new HashMap();
				
				mailTitle = mailTitle + " " + StringUtil.checkNull(srInfo.get("Subject"));
				mailMap.remove("mailSubject");
				mailMap.put("mailSubject", mailTitle);
				setMap.put("srID", srID);
				setMap.put("srType", srInfo.get("SRType"));
				setMap.put("languageID", languageID);
				HashMap cntsMap = (HashMap)commonService.select("esm_SQL.getESMSRInfo", setMap);
				
				cntsMap.put("srID", srID);	
				cntsMap.put("teamID", requestTeamID);					
				cntsMap.put("userID", requestUserID);
				cntsMap.put("languageID", languageID);
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
	
	@RequestMapping(value = "/completeISP.do")
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
//			String srArea1 = StringUtil.checkNull(xss.getParameter("srArea1"));
//			String srArea2 = StringUtil.checkNull(xss.getParameter("srArea2"));
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
//			setData.put("srArea2", srArea2);
//			String projectID = StringUtil.checkNull(commonService.selectString("sr_SQL.getProjectIDFromL2", setData)).trim();
//			updateData.put("projectID", projectID);
			updateData.put("srID", srID);
			updateData.put("srType", srType);
			updateData.put("srCatID", category); 
			updateData.put("subCategory", subCategory); 
//			updateData.put("priority", priority); 
//			updateData.put("srArea1", srArea1);
//			updateData.put("srArea2", srArea2);
			updateData.put("comment", comment);	
			updateData.put("dueDate", dueDate);	
			updateData.put("lastUser", commandMap.get("sessionUserId"));
			updateData.put("status", speCode);				
			updateData.put("srCode", srCode);
			updateData.put("svcCompl", svcCompl);
			updateData.put("blocked", blocked);
			
			commonService.update("esm_SQL.updateESMSR", updateData);	
			// Sr 첨부파일 등록 : TB_SR_FILE 
			insertESMSRFiles(commandMap, srID);
			//Save PROC_LOG
			Map setProcMapRst = (Map)setProcLog(request, commonService, updateData);
			//System.out.println("setProcMapRst....."+setProcMapRst.get("type"));			
			if(setProcMapRst.get("type").equals("FAILE")){
				String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
				System.out.println("Msg : "+Msg);
			}
			
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
	
	@RequestMapping(value = "/modifyISP.do")
	public String modifyISP(HttpServletRequest request, HashMap cmmMap, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/esm/isp/modifyISP";
		try {	
				
				List attachFileList = new ArrayList();
				
				Map setData = new HashMap();
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType")); 
				String srType = StringUtil.checkNull(cmmMap.get("srType"),request.getParameter("srType")); 
				String varFilter = StringUtil.checkNull(cmmMap.get("varFilter"));
				String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
				
				// 기존 sr 정보
				String srID = StringUtil.checkNull(cmmMap.get("srID"));
				String srCode = StringUtil.checkNull(cmmMap.get("srCode"));
				
				setData.put("srID",srID);
				setData.put("srType", srType);
				setData.put("srCode", srCode);
				setData.put("languageID", languageID);
				Map srInfoMap = commonService.select("esm_SQL.getESMSRInfo", setData);	
				
				// List 검색조건
				setData.put("s_itemID", itemID);
				setData.put("languageID", commandMap.get("sessionCurrLangType"));
				
				setData.put("srType",StringUtil.checkNull(srType,varFilter));
				
				setData.put("level", 1);
				String srAreaLabelNM1 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				String srArea1ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);
				setData.put("level", 2);
				String srAreaLabelNM2 = commonService.selectString("esm_SQL.getESMSRAreaLabelName",setData);
				String srArea2ClsCode = commonService.selectString("esm_SQL.getSRAreaClsCode",setData);
				
				//임시저장된 파일이 존재할 수 있으므로 삭제
				String path=GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
				if(!path.equals("")){FileUtil.deleteDirectory(path);}	
				
				/* 첨부문서 취득 */
				attachFileList = commonService.selectList("sr_SQL.getSRFileList", setData);
				model.put("srFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
				model.put("SRFiles", attachFileList);
						
				// 시스템 날짜 
				Calendar cal = Calendar.getInstance();
				cal.setTime(new Date(System.currentTimeMillis()));
				String thisYmd = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());

				cal.add(Calendar.DATE, +14);
				String defaultDueDate = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
				
				cal = Calendar.getInstance();
				cal.add(Calendar.DATE, +7);
				String currDateAdd7 = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
				
				model.put("scrnType", StringUtil.checkNull(request.getParameter("scrnType")) );
				model.put("menu", getLabel(request, commonService)); //  Label Setting 
				model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), "1"));
				model.put("thisYmd", thisYmd);
				model.put("defaultDueDate", defaultDueDate); // default 완료 예정일
				model.put("currDateAdd7", currDateAdd7);
				model.put("scrnType", StringUtil.checkNull(request.getParameter("scrnType"), ""));
				model.put("srType", srType);
				model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID"), ""));
				model.put("srMode", StringUtil.checkNull(request.getParameter("srMode"), ""));
				
				// 기존 sr 정보 setting
				model.put("srInfoMap", srInfoMap);
				
				// 기존 참조 정보 setting
				setData.put("SRID",srID);
				List esmSRMbrList = commonService.selectList("esm_SQL.getESMSRMember",setData);
				String sharerNames = "";
				String sharerIDs = "";
				if(esmSRMbrList.size()>0){
					for(int i=0; i<esmSRMbrList.size(); i++){
						Map esmSRMbrInfo = (Map)esmSRMbrList.get(i);
						if(i==0){
							sharerNames = StringUtil.checkNull(esmSRMbrInfo.get("SRRefMember"));
							sharerIDs = StringUtil.checkNull(esmSRMbrInfo.get("MemberID"));
						}else{
							sharerNames = sharerNames + ", " + StringUtil.checkNull(esmSRMbrInfo.get("SRRefMember"));
							sharerIDs = sharerIDs + ", " + StringUtil.checkNull(esmSRMbrInfo.get("MemberID"));
						}
					}
				}
				model.put("sharerNames", sharerNames);
				model.put("sharerIDs", sharerIDs);
				
				model.put("srID",srID);
				model.put("varFilter", varFilter);
				model.put("itemID", itemID);
				model.put("srAreaLabelNM1", srAreaLabelNM1);
				model.put("srAreaLabelNM2", srAreaLabelNM2);
				
				//Call PROC_LOG START TIME
				setInitProcLog(request);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	/**
	 * [Report-->대시보드]
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/ispDashboard.do")
	public String ispDashboard(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		Map setMap = new HashMap();
		List projectList = new ArrayList();
		try {
			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			Map menuMap = getLabel(request, commonService);

			/* 검색조건 1 : ValueChain (없을 시 전체) */
			String srArea1 = StringUtil.checkNull(request.getParameter("srArea1"));
			/* 검색조건 2 : year,month (없을 시 전체) */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String currentYear = StringUtil.checkNull(cal.get(Calendar.YEAR));
			String year = StringUtil.checkNull(request.getParameter("year"));
			//Month+1
			String currentMonth = StringUtil.checkNull(cal.get(Calendar.MONTH)+1);
			String month = StringUtil.checkNull(request.getParameter("month"));
			
			// 첫번째 Header : Status
			commandMap.put("languageID", languageID);
			commandMap.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ISP"));
			commandMap.put("itemClassCode", "CL03004");
			
			// 순서 정렬 ( TODO ) 이슈총계 > 완료 > 진척률 > 진행중 > 접수 > 제안 > 만족도 평가 요청 > 만족도 평가완료  ( 일단 하드코딩 )
			List<Map<String, Object>> srStatList = commonService.selectList("esm_SQL.getSRStatusList", commandMap); // ISP001 ~ ISP008 header 생성 (제안 ~ 만족도평가완료)
			
			for(int i=0; i < srStatList.size(); i++){
				Map map = (Map) srStatList.get(i);
				String code = StringUtil.checkNull(map.get("CODE"));
				// sortNum 지정
				if (code.equals("ISP001")){ //제안
					map.replace("SortNum", 3);
				}else if (code.equals("ISP002")){ //접수
					map.replace("SortNum", 2);
				}else if (code.equals("ISP004")){ //진행중
					map.replace("SortNum", 1);
				}else if (code.equals("ISP006")) { //완료
					map.replace("SortNum", 6);
				}else if (code.equals("ISP007")){ //만족도 평가 요청
					map.replace("SortNum", 4);
				}else if (code.equals("ISP008")){ //만족도 평가 완료
					map.replace("SortNum", 5);
				}else {
					map.replace("SortNum", 0);
				}
			}
			// 임의 지정한 SortNum 기준으로 재정렬
			Collections.sort(srStatList, Comparator.comparing(map -> (Comparable) map.get("SortNum")));
			
			// 완료 삭제
			srStatList.remove(srStatList.size()-1);
			
			// value chain
			setMap.put("level", "1");
			setMap.put("languageID", languageID);
			setMap.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ISP"));
			List srAreaListLv1 = commonService.selectList("common_SQL.getSrArea1_commonSelect", setMap);
			
			// year
			List yearList = commonService.selectList("esm_SQL.getISPYeartList", setMap);
			
			// Month			
			 List monthList = new ArrayList();
			 for(int i = 1; i < 13; i++) { monthList.add(i);}			 	
			
			List ispStatisticsList = new ArrayList();
			
			if (isMainMenu.isEmpty()) {
				ispStatisticsList = setISPStatisticsData(srStatList, srAreaListLv1, request, languageID, year, month, srArea1, menuMap);
			}
			
			// header 생성
			int colWid = 100 / (srStatList.size() + 3);
			String ispHeaderConfig = "{width: 120, id: 'Name', align:'center' ,header: [{ text: 'No.', align:'center'}]}";
			ispHeaderConfig += ",{id: 'total', header: [{ text: '이슈총계', align:'center'}], align:'center', type: 'number', template: i => `${i}개`}";
			ispHeaderConfig += ",{id: 'cmp', header: [{ text: '완료', align:'center'}], align:'center', type: 'number', template: i => `${i}개`}";
			ispHeaderConfig += ",{id: 'progress', header: [{ text: '진척률', align:'center'}], align:'center', type: 'number', template: i => `${i}%`}";
			for (int i = 0; i < srStatList.size(); i++) {
				Map tmpMap = (Map) srStatList.get(i);
				String Name = StringUtil.checkNull(tmpMap.get("NAME"));
				String Code = StringUtil.checkNull(tmpMap.get("CODE"));
				ispHeaderConfig += ",{id: '"+Code+"', header: [{ text: '" + Name +"', align:'center'}], align:'center' ,type: 'number', template: i => `${i}개`}";
			}
			
			model.put("ispHeaderConfig", ispHeaderConfig);
			
			JSONArray ispStatisticsListData = new JSONArray(ispStatisticsList);
			model.put("ispStatisticsListData", ispStatisticsListData);

			model.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ISP"));
			model.put("menu", menuMap);
			model.put("isMainMenu", isMainMenu);
			
			/* 검색조건 */
			model.put("srArea1List", srAreaListLv1);
			model.put("srArea1", srArea1);
			model.put("yearList",yearList);
			model.put("year", year);
			model.put("monthList",monthList);
			model.put("month", month);
			model.put("languageID", languageID);
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/app/esm/isp/ispDashboard");
	}
	
	private List setISPStatisticsData(List srStatList, List srAreaListLv1,
			HttpServletRequest request, String languageID, String year, String month, String srArea1, Map menuMap) throws ExceptionUtil {
		
		List ispStatisticsList = new ArrayList();
		try {

			// TOTAL
			Map totalMap = new HashMap();
			String ttl = ""; // 전체 이슈총계
			String tcmp = ""; // 전체 완료
			int tprogress = 0; // 전체 진척률
			String cngtTtl = ""; // 전체 상태별 갯수

			/* 화면에서 선택된 검색 조건을 설정 start */
			Map setMap = new HashMap();
			setMap.put("year", year); // year
			setMap.put("month", month); // month
			setMap.put("srArea1", srArea1); // ValueChain
			/* 화면에서 선택된 검색 조건을 설정 end */
			
			// col1 No.
			totalMap.put("Name", StringUtil.checkNull(menuMap.get("LN00346")));
			
			// col 2 ( 전체 - 이슈총계 )
			setMap.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ISP"));
			ttl = commonService.selectString("analysis_SQL.getCountOfSR", setMap);
			totalMap.put("total", ttl);
			
			// col 3 ( 전체 - 완료 )
			setMap.put("svcCompl", "Y");
			tcmp = commonService.selectString("analysis_SQL.getCountOfSR", setMap);
			totalMap.put("cmp", tcmp);
			
			// col 4 ( 전체 - 진척률 )
			if(!"0".equals(tcmp)){
				Double progressResult = ((double)Integer.parseInt(tcmp)/(double)Integer.parseInt(ttl)) * 100.0;
				tprogress = (int)Math.floor(progressResult);
			}
			totalMap.put("progress", tprogress);

			// Total by Status
			setMap.remove("svcCompl");
			for (int i = 0; i < srStatList.size(); i++) {
				Map statusMap = (Map) srStatList.get(i);
				String statusCode = String.valueOf(statusMap.get("CODE"));
				if(!"ISP006".equals(statusCode)) {
					setMap.put("status", statusCode);
					cngtTtl = commonService.selectString("analysis_SQL.getCountOfSR", setMap);
					totalMap.put(statusCode, cngtTtl);
				}
			}
			ispStatisticsList.add(totalMap);
			
			// SRArea1 별 
			String srCntTtl = ""; // 이슈총계
			String cmp = ""; // 완료
			int progress = 0; // 진척률
			String srCnt = ""; // 상태 별 건수
			
			/* 화면에서 선택된 검색 조건을 설정 start */
			HashMap commandMap = new HashMap();
			commandMap.put("languageID", languageID);
			commandMap.put("year", year);
			commandMap.put("month", month);
			
			for (int i = 0; i < srAreaListLv1.size(); i++) {
				Map maplv1 = (Map) srAreaListLv1.get(i);
				String srArea1Lv1_CD = String.valueOf(maplv1.get("CODE")); // value chain itemID
				String srArea1Lv1_NM = String.valueOf(maplv1.get("NAME")); // value chain NM
				commandMap.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ISP"));

				Map<String,Object> rowMap = new HashMap<String,Object>();
				commandMap.put("srArea1", srArea1Lv1_CD);
				
				// col1 No.
				rowMap.put("Name", srArea1Lv1_NM);
				
				// col 2 ( 이슈총계 )
				commandMap.remove("status");
				srCntTtl = commonService.selectString("analysis_SQL.getCountOfSR", commandMap); // SRArea1 별 총 갯수
				rowMap.put("total", srCntTtl); // col9 : Total by Sub Category (총갯수 넣기)
				
				if("0".equals(srCntTtl) || (srArea1 != null && !"".equals(srArea1) && !srArea1Lv1_CD.equals(srArea1))){
					
					rowMap.put("total", 0);
					rowMap.put("cmp", 0);
					rowMap.put("progress", 0);
					for (int k = 0; k < srStatList.size(); k++) {
						Map satusMap = (Map) srStatList.get(k);
						String statusId = String.valueOf(satusMap.get("CODE"));
						if(!"ISP006".equals(statusId)) {
							rowMap.put(statusId, 0);
						}
					}
					
				} else {
					
					// col 3 ( 완료 )
					commandMap.put("svcCompl", "Y");
					cmp = commonService.selectString("analysis_SQL.getCountOfSR", commandMap); // SRArea1 별 총 갯수
					rowMap.put("cmp", cmp);
					
					// col 4 ( 진척률 )
					if(!"0".equals(cmp)){
						Double progressResult = ((double)Integer.parseInt(cmp)/(double)Integer.parseInt(srCntTtl)) * 100.0;
						progress = (int)Math.floor(progressResult);
					} else {
						progress = 0;
					}
					rowMap.put("progress", progress); // col9 : Total by Sub Category (총갯수 넣기)
					
					// SR by Status
					commandMap.remove("svcCompl");
					for (int k = 0; k < srStatList.size(); k++) {
						Map satusMap = (Map) srStatList.get(k);
						String statusId = String.valueOf(satusMap.get("CODE"));
						if(!"ISP006".equals(statusId)) {
							commandMap.put("status", statusId);
							srCnt = commonService.selectString("analysis_SQL.getCountOfSR", commandMap);
							rowMap.put(statusId, srCnt);
						}
					}
				}
				// SRArea1 별 row값 넣기
				ispStatisticsList.add(rowMap);
			}
			
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		
		return ispStatisticsList;
	}
	
	/**
	 * [PI PM --> Report --> 만족도 평가완료 리포트]
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/ispEvaluationCMPReport.do")
	public String ispEvaluationCMPReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		Map setMap = new HashMap();
		List projectList = new ArrayList();
		try {

			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
			setMap.put("languageID", languageID);
			/* 검색조건 1 : ValueChain (없을 시 전체) */
			String srArea1 = StringUtil.checkNull(request.getParameter("srArea1"));
			setMap.put("srArea1",srArea1);
			/* 검색조건 2 : year (없을 시 당해년도) */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			
			String startDate = StringUtil.checkNull(request.getParameter("startDate"), "");
			String endDate = StringUtil.checkNull(request.getParameter("endDate"), "");
			
		    setMap.put("startDate",startDate);
		    setMap.put("endDate",endDate);
			
			List ispEvaluationCMPList = commonService.selectList("esm_SQL.getISPEvaluationCMPList_gridList", setMap);
			JSONArray ispEvaluationCMPListData = new JSONArray(ispEvaluationCMPList);
			model.put("ispEvaluationCMPListData", ispEvaluationCMPListData);
			model.put("totalCnt", ispEvaluationCMPList.size());

			/* 검색 조건 */
			// value chain
			setMap.put("level", "1");
			setMap.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ISP"));
			List srAreaListLv1 = commonService.selectList("common_SQL.getSrArea1_commonSelect", setMap);
			
			model.put("menu", getLabel(request, commonService));
			model.put("isMainMenu", isMainMenu);
			
			model.put("srArea1List", srAreaListLv1);
			model.put("srArea1", srArea1);
			model.put("startDate", startDate);
			model.put("endDate", endDate);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/app/esm/isp/ispEvaluationCMPReport");
	}

	//이슈리포트(담당자별)
	@RequestMapping(value = "/ispProcessingReport.do")
	public String ispProcessingReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		Map setMap = new HashMap();
		
		try {
			
			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
			/* 검색조건 1 : year (없을 시 당해년도) */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String currentYear = StringUtil.checkNull(cal.get(Calendar.YEAR));
			String year = StringUtil.checkNull(request.getParameter("year"));
			List yearList = commonService.selectList("esm_SQL.getISPYeartList", setMap);
			//Month+1
			String currentMonth = StringUtil.checkNull(cal.get(Calendar.MONTH)+1);
			String month = StringUtil.checkNull(request.getParameter("month"));			
			 List monthList = new ArrayList();
			 for(int i = 1; i < 13; i++) { monthList.add(i);}			 	

			
			// SR stauts
			setMap.put("languageID", languageID);
			setMap.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ISP"));
			setMap.put("itemClassCode", "CL03004");
			List srStatusList = commonService.selectList("esm_SQL.getSRStatusList", setMap);

			List ispPList = new ArrayList();
			// 담당자
			List receiptUserList = commonService.selectList("esm_SQL.getISPReceiptUserID", setMap);
			List receiptTeamList = commonService.selectList("esm_SQL.getISPReceiptTeamID", setMap);
			
			List receiptList = new ArrayList();
			receiptList.add(receiptUserList);
			receiptList.add(receiptTeamList);
			
			if (isMainMenu.isEmpty()) {
				ispPList = setSRProcessingReceiptStatisticsData(receiptList, srStatusList, request, year,month, languageID);
			}
			
			// header 생성
			String processHeaderConfig = "{width: 100, id: 'Name', align:'center' ,header: [{ text: '', align:'center'}], footer: [{ text: `<div class ='custom_footer'>이슈 총계</div>` }]}";
			for (int i = 0; i < receiptList.size(); i++) {
				List tmpList = (List) receiptList.get(i);
				for(int j = 0; j < tmpList.size(); j++){
					Map tmpMap = (Map) tmpList.get(j);
					String Name = StringUtil.checkNull(tmpMap.get("NAME"));
					String Code = StringUtil.checkNull(tmpMap.get("CODE"));
					//(SYFD) PI담당 -> PI팀
					if(Name.equals("PI담당")) Name = "PI팀";
					processHeaderConfig += ",{ width: 100, id: '"+Code+"', header: [{ text: '" + Name +"', align:'center'}], align:'center' , type:'number', htmlEnable: true, format: '#', template: i => `<div class ='custom_footer'>${i}</div>`, footer: [{ content: 'sum' }]}";
				}
			}
			model.put("processHeaderConfig", processHeaderConfig);
			
			JSONArray ispProcessingReportListData = new JSONArray(ispPList);
			model.put("ispProcessingReportListData", ispProcessingReportListData);
			
			/* 검색 조건 */
			model.put("menu", getLabel(request, commonService));
			model.put("isMainMenu", isMainMenu);
			
			model.put("yearList",yearList);
			model.put("year",year);
			model.put("monthList",monthList);
			model.put("month", month);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/app/esm/isp/ispProcessingReport");	
	}
	
	
	
	private List setSRProcessingReceiptStatisticsData(List receiptList, List srStatusList, HttpServletRequest request, String year,String month, String languageID) throws ExceptionUtil {
		
		HashMap setMap = new HashMap();
		List ispPStatisticList = new ArrayList();
		
		try {
			/* 화면에서 선택된 검색 조건을 설정 */
			setMap.put("year",year);
			setMap.put("month", month);
			
			/* gridArea에 표시할 Count 값을 취득하여 각 행의 List에 저장 */
			List<Map<String, String>> countResultList = new ArrayList<Map<String, String>>();
			String ispPCnt = ""; // cnt
			
			// sr 과정
			Map ispPStatisticMap = new HashMap();
			for (int i = 0; i < srStatusList.size(); i++) {
				Map ispPStsMap = (Map) srStatusList.get(i);
				String stsCode = StringUtil.checkNull(ispPStsMap.get("CODE"));
				String stsName = StringUtil.checkNull(ispPStsMap.get("NAME"));
				
				ispPStatisticMap.put("Code", stsCode); 
				ispPStatisticMap.put("Name", stsName);// col1: status 명
				
				setMap.put("status",stsCode); 
				
				// User
				String type = "receiptUserID";
				for (int j = 0; j < receiptList.size(); j++) {
					List tmpList = (List)receiptList.get(j);
					if(j>0) type = "receiptTeam";
					for(int k = 0; k < tmpList.size(); k++){
						Map tmpMap = (Map) tmpList.get(k);
						String code = StringUtil.checkNull(tmpMap.get("CODE"));
						
						setMap.put(type,code);
						ispPCnt = StringUtil.checkNull(commonService.selectString("analysis_SQL.getCountOfSR", setMap),"0");
						ispPStatisticMap.put(code , ispPCnt);
					}
					setMap.remove(type);
				}
				ispPStatisticList.add(ispPStatisticMap);
				
				setMap.remove("status");
				ispPStatisticMap = new HashMap();
			}
		
		}catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		return ispPStatisticList;
	}
	
	/**
	 * [PI PM --> Report --> 만족도 조사 리포트 ]
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value = "/ispEvaluationReport.do")
	public String ispEvaluationReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		Map setMap = new HashMap();
		String url = "";
		
		try {

			String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			/* mode : (01 : 담당자 별 / 02 : valueChain 별) */
			String mode = StringUtil.checkNull(request.getParameter("mode"),"01");
			
			/* 검색조건 1 : year (없을 시 당해년도) */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String currentYear = StringUtil.checkNull(cal.get(Calendar.YEAR));
			String year = StringUtil.checkNull(request.getParameter("year"));
			//Month+1
			String currentMonth = StringUtil.checkNull(cal.get(Calendar.MONTH)+1);
			String month = StringUtil.checkNull(request.getParameter("month"));			
			List monthList = new ArrayList();
			for(int i = 1; i < 13; i++) { monthList.add(i);}	
			
			setMap.put("status","ISP008");
			List yearList = commonService.selectList("esm_SQL.getISPYeartList", setMap);
			setMap.remove("status");
			
			// stauts (우선 하드코딩)
			List evalStatus = new ArrayList();
			Map evalStatusMap = new HashMap();
			String statusNM = "";
			for(int j=5; j >= 1; j --) {
				evalStatusMap.put("CODE",String.valueOf((j)));
				if(j == 5) statusNM = "매우 만족";
				else if(j == 4) statusNM = "만족";
				else if(j == 3) statusNM = "양호";
				else if(j == 2) statusNM = "보통";
				else statusNM = "불만족";
				
				evalStatusMap.put("NAME",statusNM);
				
				evalStatus.add(evalStatusMap);
				evalStatusMap = new HashMap();
			}
			
			List evalList = new ArrayList();
			setMap.put("languageID",languageID);
			if("01".equals(mode)){
				// 담당자
				List receiptUserList = commonService.selectList("esm_SQL.getISPReceiptUserID", setMap);
				List receiptTeamList = commonService.selectList("esm_SQL.getISPReceiptTeamID", setMap);
				
				List receiptList = new ArrayList();
				receiptList.add(receiptUserList);
				receiptList.add(receiptTeamList);
				
				if (isMainMenu.isEmpty()) {
					evalList = setEvalReceiptStatisticsData(receiptList, evalStatus, request, year, month);
				}
				
				// header 생성
				String evalHeaderConfig = "{width: 100, id: 'Name', align:'center' ,header: [{ text: '', align:'center'}]}";
				for (int i = 0; i < receiptList.size(); i++) {
					List tmpList = (List) receiptList.get(i);
					for(int j = 0; j < tmpList.size(); j++){
						Map tmpMap = (Map) tmpList.get(j);
						String Name = StringUtil.checkNull(tmpMap.get("NAME"));
						String Code = StringUtil.checkNull(tmpMap.get("CODE"));
						//(SYFD) PI담당 -> PI팀
						if(Name.equals("PI담당")) Name = "PI팀";
						evalHeaderConfig += ",{ width: 100, id: '"+Code+"', header: [{ text: '" + Name +"', align:'center'}], align:'center'}";
					}
				}
				
				model.put("evalHeaderConfig", evalHeaderConfig);
				url = "/app/esm/isp/ispEvaluationReceiptUserReport";
			}
			else {
				// value chain
				setMap.put("level", "1");
				setMap.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ISP"));
				List srAreaListLv1 = commonService.selectList("common_SQL.getSrArea1_commonSelect", setMap);
				if (isMainMenu.isEmpty()) {
					evalList = setEvalSRArea1StatisticsData(srAreaListLv1, evalStatus, request, year, month);
				}
				url = "/app/esm/isp/ispEvaluationSRArea1Report";
			}
			
			JSONArray evalListData = new JSONArray(evalList);
			model.put("evalListData", evalListData);

			/* 검색 조건 */
			model.put("menu", getLabel(request, commonService));
			model.put("isMainMenu", isMainMenu);
			
			model.put("evalStatus",evalStatus);
			model.put("yearList",yearList);
			model.put("year",year);
			model.put("monthList",monthList);
			model.put("month", month);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl(url);
	}
	
	private List setEvalReceiptStatisticsData(List receiptList, List evalStatus, HttpServletRequest request, String year, String month) throws ExceptionUtil {

		HashMap setMap = new HashMap();
		List evalStatisticList = new ArrayList();
		try {
			/* 화면에서 선택된 검색 조건을 설정 */
			setMap.put("year",year);
			setMap.put("month", month);

			/* gridArea에 표시할 Count 값을 취득하여 각 행의 List에 저장 */
			List<Map<String, String>> countResultList = new ArrayList<Map<String, String>>();
			Map resultMap = new HashMap();
			Map evalTtlMap = new HashMap(); // total
			Map evalAvgMap = new HashMap(); // avg
			String evalCnt = ""; // cnt
			
			// 매우만족 , 만족 , 양호 , 보통 , 불만족
			Map evalStatisticMap = new HashMap();
			for (int i = 0; i < evalStatus.size(); i++) {
				Map evalStsMap = (Map) evalStatus.get(i);
				String stsCode = StringUtil.checkNull(evalStsMap.get("CODE"));
				String stsName = StringUtil.checkNull(evalStsMap.get("NAME"));
				
				evalStatisticMap.put("Code", stsCode);
				evalStatisticMap.put("Name", stsName);// col1: status 명
				
				setMap.put("status",stsCode);
				String type = "receiptUserID";
				// User
				for (int j = 0; j < receiptList.size(); j++) {
					List tmpList = (List)receiptList.get(j);
					if(j>0) type = "receiptTeamID";
					for(int k = 0; k < tmpList.size(); k++){
						Map tmpMap = (Map) tmpList.get(k);
						String code = StringUtil.checkNull(tmpMap.get("CODE"));
						
						setMap.put(type,code);
						evalCnt = StringUtil.checkNull(commonService.selectString("esm_SQL.getISPEvalCount", setMap),"0");
						evalStatisticMap.put(code , evalCnt);
					}
					setMap.remove(type);
				}
				evalStatisticList.add(evalStatisticMap);
				
				setMap.remove("status");
				evalStatisticMap = new HashMap();
			}
			
			evalTtlMap.put("Name", "이슈총계");
			evalAvgMap.put("Name", "평균점수");
			resultMap.put("Name", "결과");
			
			String type = "receiptUserID";
			for (int i = 0; i < receiptList.size(); i++) {
				List tmpList = (List)receiptList.get(i);
				if(i>0) type = "receiptTeamID";
				for(int j = 0; j < tmpList.size(); j++){
					Map tmpMap = (Map) tmpList.get(j);
					String code = StringUtil.checkNull(tmpMap.get("CODE"));
					
					// 이슈총계
					setMap.put(type,code);
					evalCnt = StringUtil.checkNull(commonService.selectString("esm_SQL.getISPEvalCount", setMap),"0");
					evalTtlMap.put(code, evalCnt);
					
					// 평균점수
					setMap.put("avgMode","Y");
					evalCnt = StringUtil.checkNull(commonService.selectString("esm_SQL.getISPEvalCount", setMap),"0");
					evalAvgMap.put(code, evalCnt);
					setMap.remove("avgMode");
					
					// 결과
					String result = "없음";
					int rs = 0;
					if(!"0".equals(evalCnt)){
						rs = Integer.parseInt(evalCnt);
						if(rs >= 91) result = "매우 만족";
						else if(rs >= 81 && rs <= 90) result = "만족";
						else if(rs >= 61 && rs <= 80) result = "양호";
						else if(rs >= 51 && rs <= 60) result = "보통";
						else result = "불만족";
					}
					resultMap.put(code, result);
				}
				setMap.remove(type);
			}
			evalStatisticList.add(evalTtlMap);
			evalStatisticList.add(evalAvgMap);
			evalStatisticList.add(resultMap);
			
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		return evalStatisticList;
	}
	
	private List setEvalSRArea1StatisticsData(List srAreaListLv1, List evalStatus, HttpServletRequest request, String year, String month) throws ExceptionUtil {

		HashMap setMap = new HashMap();
		List evalStatisticList = new ArrayList();
		try {
			/* 화면에서 선택된 검색 조건을 설정 */
			setMap.put("year",year);
			setMap.put("month", month);

			/* gridArea에 표시할 Count 값을 취득하여 각 행의 List에 저장 */
			List<Map<String, String>> countResultList = new ArrayList<Map<String, String>>();
			Map resultMap = new HashMap();
			String evalTtl = ""; // total
			String evalCnt = ""; // cnt
			String evalAvg = ""; // avg
			
			Map evalStatisticMap = new HashMap();
			
			for (int i = 0; i < srAreaListLv1.size(); i++) {
				Map srArea1Map = (Map) srAreaListLv1.get(i);
				String code = StringUtil.checkNull(srArea1Map.get("CODE"));
				String name = StringUtil.checkNull(srArea1Map.get("NAME"));
				
				evalStatisticMap.put("Code", code);
				evalStatisticMap.put("Name", name);// col1:value chain 명
				
				// valueChain 기준
				setMap.remove("srArea1");
				setMap.put("srArea1",code);
				
				// 총계
				evalTtl = StringUtil.checkNull(commonService.selectString("esm_SQL.getISPEvalCount", setMap),"0");
				evalStatisticMap.put("total", evalTtl);
				
				if(!"0".equals(evalTtl)){
				
					// 평균점수
					setMap.put("avgMode","Y");
					evalAvg = StringUtil.checkNull(commonService.selectString("esm_SQL.getISPEvalCount", setMap),"0");
					evalStatisticMap.put("avg", evalAvg);
					
					// 결과
					int rs = 0;
					if(!"0".equals(evalAvg)){
						rs = Integer.parseInt(evalAvg);
						if(rs >= 91) rs = 5;
						else if(rs >= 81 && rs <= 90) rs = 4;
						else if(rs >= 61 && rs <= 80) rs = 3;
						else if(rs >= 51 && rs <= 60) rs = 2;
						else rs = 1;
					}
					String result = String.valueOf(rs);
					
					// status 임의 설정 ( 5 매우만족 / 4 만족 / 3 양호 / 2 보통 / 1 불만족 )
					setMap.remove("avgMode");
					for(int j=0; j < evalStatus.size(); j ++) {
						Map evalStsMap = (Map) evalStatus.get(j);
						String stsCode = StringUtil.checkNull(evalStsMap.get("CODE"));
						String stsName = StringUtil.checkNull(evalStsMap.get("NAME"));
						
						setMap.put("status",stsCode);
						evalCnt = StringUtil.checkNull(commonService.selectString("esm_SQL.getISPEvalCount", setMap),"0");
						evalStatisticMap.put("cnt_" + stsCode, evalCnt);
						
						// result set
						if(stsCode.equals(result)){
							result = stsName;
						}
					}
					
					evalStatisticMap.put("result", result);
				} else {
					evalStatisticMap.put("avg", 0);
					for(int j=0; j < evalStatus.size(); j ++) {
						Map evalStsMap = (Map) evalStatus.get(j);
						String stsCode = StringUtil.checkNull(evalStsMap.get("CODE"));
						evalStatisticMap.put("cnt_" + stsCode, 0);
						
					}
					evalStatisticMap.put("result", "없음");
				}
				
				evalStatisticList.add(evalStatisticMap);
				
				setMap.remove("status");
				evalStatisticMap = new HashMap();
			}
			
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		return evalStatisticList;
	}
	
	@RequestMapping(value="/deleteSRMST.do")
	public String deleteSRMST(HttpServletRequest request, HashMap cmmMap, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
				String srID = StringUtil.checkNull(request.getParameter("srID"),"");
				String dbFuncCode = StringUtil.checkNull(request.getParameter("dbFuncCode"),"");
				if(dbFuncCode.equals("")) dbFuncCode = "DELETE_SR_MST"; // default procedure
				
				if(srID!= null && !"".equals(srID)){
					
					Map getData = new HashMap();
					getData.put("SRID", srID);
					getData.put("LanguageID", cmmMap.get("sessionCurrLangType"));
					getData.put("dbFuncCode", dbFuncCode);
						
					// 파일 폴더에 저장된 해당 파일을 삭제 (talk 게시판)
					Map setMap = new HashMap();
					getData.put("ItemID", "0");
					String boardID = "";
					List boardList = commonService.selectList("board_SQL.getBoardID", getData);
					for (int g = 0; boardList.size() > g; g++) {
						Map boardMap = (Map) boardList.get(g);
						setMap.put("boardID", boardMap.get("BoardID"));
						List deletefileList = new ArrayList<String>();
						deletefileList = commonService.selectList("forumFile_SQL.forumFile_select", setMap);
						File file;
						for (int i = 0; i < deletefileList.size(); i++) {
							Map temp = (Map) deletefileList.get(i);
							String realFile = StringUtil.checkNull(temp.get("fullFileName"));
							file = new File(realFile);
							if (file.exists())
								file.delete();
						}
					}
					
					// 파일 삭제 (SR)
					setMap.put("DocumentID", srID);
					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
					setMap.put("DocCategory", "SR");
					
					List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
					for (int i = 0; i < attachFileList.size(); i++) {
						Map fileMap = (Map) attachFileList.get(i);
						String realFile = StringUtil.checkNull(fileMap.get("SysFile"));
						File file;
						file = new File(realFile);
						if (file.exists())
							file.delete();
					}
					
					// delete 처리
					commonService.insert("esm_SQL.deleteSRMST", getData);
					setMap.clear();
					
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); 
					target.put(AJAX_SCRIPT, "fnGoSRList();");
					model.addAttribute(AJAX_RESULTMAP, target);
					
				}
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/sendMailSRMST.do")
	public String sendMailSRMST(HttpServletRequest request, HashMap cmmMap, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
				String srID = StringUtil.checkNull(request.getParameter("srID"),"");
				String srType = StringUtil.checkNull(request.getParameter("srType"),"");
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				
				if(srID!= null && !"".equals(srID)){
					
					// 메일 내용 셋팅
					
					Map srInfo = new HashMap();
					Map setData = new HashMap();
					
					setData.put("srID", srID);
					setData.put("srType", srType);
					setData.put("languageID", languageID);
					srInfo = commonService.select("esm_SQL.getESMSRInfo", setData);
					
					// 1 . find mail title [ OJ00003 / AT00089 ]
					String mailTitle = "[이슈 답변]";
					
					// 2. send mail
					List receiverList = new ArrayList();
					Map receiverMap = new HashMap();
					Map updateData = new HashMap();
					
					String requestUserID = StringUtil.checkNull(srInfo.get("RequestUserID"));
					String requestTeamID = StringUtil.checkNull(srInfo.get("RequestTeamID"));
					
					receiverMap.put("receiptUserID", requestUserID); // SR 조치 시는 수신자가 조치자(ReceiptUser)가 아닌 RequestUser의 이메일로 송신
					receiverList.add(0,receiverMap);
					updateData.put("receiverList", receiverList);
					
					// 참조자 메일 발송 
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
					
					updateData.put("subject", StringUtil.checkNull(srInfo.get("Subject")));
					updateData.put("receiverList", receiverList);
					Map setMailMapRst = (Map)setEmailLog(request, commonService, updateData, "SRCMP");
					if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
						HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
						HashMap setMap = new HashMap();
						
						mailTitle = mailTitle + " " + StringUtil.checkNull(srInfo.get("Subject"));
						mailMap.remove("mailSubject");
						mailMap.put("mailSubject", mailTitle);
						HashMap cntsMap = (HashMap)srInfo;
						
						cntsMap.put("srID", srID);	
						cntsMap.put("teamID", requestTeamID);					
						cntsMap.put("userID", requestUserID);
						cntsMap.put("languageID", languageID);
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
					
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00171")); 
					target.put(AJAX_SCRIPT, "fnCallBack();");
					model.addAttribute(AJAX_RESULTMAP, target);
					
				}
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
}
