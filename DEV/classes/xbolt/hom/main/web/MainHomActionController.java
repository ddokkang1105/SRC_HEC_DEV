package xbolt.hom.main.web;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.org.json.JSONArray;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.JsonUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

@Controller
public class MainHomActionController extends XboltController{
	
	
	@Autowired
    @Qualifier("commonService")
    private CommonService commonService;
	
	@Resource(name = "schedulService")
	private CommonService schedulService;
	
	// gerpProcessLayer 이동
	@RequestMapping(value="/mainHomLayer.do")
	public String mainHomLayer(HttpServletRequest request, ModelMap model) throws Exception{
		model.put("menu", getLabel(request, commonService));	//Label Setting
		model.put("screenType", request.getParameter("screenType"));
		return nextUrl("/hom/main/v33/mainHomLayer");
	}
	
	@RequestMapping(value="/mainHomLayer_v2.do")
	public String mainHomLayer_v2(HttpServletRequest request, ModelMap model) throws Exception{
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		return nextUrl("/hom/main/v33/mainHomLayer_v2");
	}
	
	@RequestMapping(value="/mainHomLayer_v3.do")
	public String mainHomLayer_v3(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		/* Board List 설정 */
		List boardList = commonService.selectList("board_SQL.boardMgtList", cmmMap);
		
		/* Report List 설정 */
		List reportList = commonService.selectList("report_SQL.getReportListOfPjt", cmmMap);
		
		/* 해당 프로젝트 ID 설정 */
		Map projectInfoMap = commonService.select("main_SQL.getPjtInfoFromTEMPL", cmmMap);
		
		/* menu index 설정 */
		String pmenuIndex = "1 2 3 4 5 6 7 8 9"; // 고정 메뉴 Index
		String space = " ";
		
		int ttlCnt = boardList.size() + reportList.size();
		int cnt = 9;
		for (int i = 0; ttlCnt > i ; i++) {
			pmenuIndex = pmenuIndex + space + cnt;
			cnt++;
		}
		
		model.put("projectID", projectInfoMap.get("ProjectID"));
		model.put("projectName", projectInfoMap.get("Name"));
		
		model.put("boardList", boardList);
		model.put("startBoardIndex", 9);
		model.put("reportList", reportList);
		model.put("startReportIndex", boardList.size() + 9);
		model.put("pmenuIndex", pmenuIndex);
		model.put("maxIndex", ttlCnt + 9);
		
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		
		return nextUrl("/hom/main/v33/mainHomLayer_v3");
	}
	
	
	@RequestMapping(value="/mainHelpMainMenu.do")
	public String mainHelpMainMenu(HttpServletRequest request, ModelMap model) throws Exception{
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		return nextUrl("/hom/main/v33/mainHelpMainMenu");
	}
	
	/**
	 * Help 화면 Menu 이동
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/goHelpDetail.do")
	public String goHelpDetail(HttpServletRequest request, ModelMap model) throws Exception{
		String viewCheck = StringUtil.checkNull(request.getParameter("viewCheck"), "1");
		String subItem = StringUtil.checkNull(request.getParameter("subItem"), "1");
		
		String url = "/hom/hlp/helpMain"; // 메인 화면 & 개요
		
		
		if ("1".equals(viewCheck)) {
			if ("1".equals(subItem)) {
				url = "/hom/hlp/helpMain"; // 
			} else if ("2".equals(subItem)) {
				url = "/hom/hlp/helpItem"; // 하위항목
			} else if ("3".equals(subItem)) {
				url = "/hom/hlp/helpItemMapping"; // 아이템 매핑
			}
		}	
		else if ("2".equals(viewCheck)) {
			url = "/hom/hlp/helpModelabout"; // 프로세스 모델링
			if ("4".equals(subItem)) {
				url = "/hom/hlp/helpModelabout"; // 모델조회
			} else if ("5".equals(subItem)) {
				url = "/hom/hlp/helpModeledit"; // 모델관리
			} else if ("6".equals(subItem)) {
				url = "/hom/hlp/helpModellist"; // 모델편집
			} else if ("7".equals(subItem)) {
				url = "/hom/hlp/helpOcc"; // Occurrence
			} else if ("8".equals(subItem)) {
				url = "/hom/hlp/helpModelprocess"; // 프로세스 모델링
			}
		} else if ("3".equals(viewCheck)) {
			url = "/hom/hlp/helpFile"; // 첨부문서
		} else if ("4".equals(viewCheck)) {
			url = "/hom/hlp/helpDim"; // Dimension
		} else if ("5".equals(viewCheck)) {
			url = "/hom/hlp/helpUser"; // 사용자 관리
		} else if ("6".equals(viewCheck)) {
			url = "/hom/hlp/helpCfg"; // Config
		}
		
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		return nextUrl(url);
	}
			
	@RequestMapping(value="/myPage.do")
	public String myPage(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		/* Board List 설정 */
		List boardList = commonService.selectList("board_SQL.boardMgtList", cmmMap);
		
		/* Report List 설정 */
		cmmMap.put("templCode", "MYPAGE");
		cmmMap.put("languageId", cmmMap.get("sessionCurrLangType"));
		List reportList = commonService.selectList("config_SQL.getReportAllocList_gridList", cmmMap);
		
		/* 해당 프로젝트 ID 설정 */
		Map projectInfoMap = commonService.select("main_SQL.getPjtInfoFromTEMPL", cmmMap);
		
		/* menu index 설정 */
		String pmenuIndex = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19"; // 고정 메뉴 Index
		String space = " ";
		
		int ttlCnt = reportList.size();
		int cnt =21;
		for (int i = 0; ttlCnt > i ; i++) {
			pmenuIndex = pmenuIndex + space + cnt;
			cnt++;
		}
		String mainType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("mainType"))); 
		String srID = StringUtil.checkNull(request.getParameter("srID"));
		if(mainType.equals("mySRDtl")){
			Map getSRInfo = commonService.select("sr_SQL.getSRInfo", cmmMap);	
			if(getSRInfo == null){
				srID = "";
			}
		}
		String myPageUrl = StringUtil.checkNull(request.getParameter("myPageTmplFilter"),""); 
		String url = "/hom/main/v33/myPage";
		if(!myPageUrl.equals("")){
			url = "/hom/main/v33/"+myPageUrl;
		}
		
		cmmMap.put("srTypeCode", StringUtil.checkNull(request.getParameter("srType"),""));				
		Map srTypeInfo = commonService.select("esm_SQL.getESMSRTypeInfo",cmmMap);
		String srVarFilter = StringUtil.checkNull(srTypeInfo.get("VarFilter"));
		model.put("srVarFilter", srVarFilter);
		
		model.put("projectID", projectInfoMap.get("ProjectID"));
		model.put("projectName", projectInfoMap.get("Name"));
		
		model.put("boardList", boardList);
		model.put("startReportIndex", 20);
		model.put("reportList", reportList);
		model.put("pmenuIndex", pmenuIndex);
		model.put("maxIndex", ttlCnt + 10);
		
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		model.put("approvalPath", GlobalVal.DEF_APPROVAL_SYSTEM);
		model.put("useCR", GlobalVal.USE_COMP_CR);
		model.put("useTask", GlobalVal.USE_COMP_TASK);
		model.put("multiCompany", GlobalVal.MULTI_COMPANY);
		
		model.put("srID", srID);
		model.put("mainType", mainType);
		model.put("screenType", request.getParameter("screenType"));
		model.put("status", request.getParameter("status"));
		model.put("srType", request.getParameter("srType"));
		model.put("wfInstanceID", StringUtil.checkNull(request.getParameter("wfInstanceID")));
				
		return nextUrl(url);
	}

	@RequestMapping(value="/pjtTemplate.do")
	public String pjtTemplate(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		/* Board List 설정 */
		List boardList = commonService.selectList("board_SQL.boardMgtListNew", cmmMap);
		List boardGrpList = commonService.selectList("board_SQL.boardGrpList", cmmMap);
		/* Report List 설정 */
		List reportList = commonService.selectList("report_SQL.getReportListOfPjt", cmmMap);
		
		String tmplFilter = StringUtil.checkNull(request.getParameter("tmplFilter"),"");
		String url = "/hom/main/v33/pjtTemplate";
		if(!tmplFilter.equals("")){
			url = "/hom/main/v33/"+tmplFilter;
			
		}
		/* 해당 프로젝트 ID 설정 */
		Map setData = new HashMap();
		
		String projectID = StringUtil.checkNull(request.getParameter("ProjectID"),"NULL");
		String projectName = StringUtil.checkNull(request.getParameter("ProjectName"),"");
		
		setData.put("projectID", projectID);
		setData.put("languageID", cmmMap.get("sessionCurrLangType"));
		if(projectID.equals("NULL") || projectID.equals("")) {	
			Map projectInfoMap = commonService.select("main_SQL.getPjtInfoFromTEMPL", cmmMap);	
			model.put("projectID", projectInfoMap.get("ProjectID"));
			model.put("projectName", projectInfoMap.get("Name"));
		} else {
			model.put("projectID",projectID);			
			if(projectName.equals("")){
				projectName = commonService.selectString("project_SQL.getProjectName", setData);
				model.put("projectName", projectName);
			}else{
				model.put("projectName", projectName);
			}
		}
		/* menu index 설정 */
		String pmenuIndex = "1 2 3 4 5 6 7 8 9 10 11"; // 고정 메뉴 Index
		String space = " ";
		
		int ttlCnt = boardList.size() + boardGrpList.size() + reportList.size();
		int cnt = 12;
		for (int i = 0; ttlCnt > i ; i++) {
			pmenuIndex = pmenuIndex + space + cnt;
			cnt++;
		}
		
		// 할당된 첫번째 게시판으로 로딩되게..
		if(boardList.size() > 0){
			Map boardInfoMap = new HashMap();
			boardInfoMap = (Map)boardList.get(0);		
			model.put("boardMgtID", boardInfoMap.get("BoardMgtID"));
			model.put("url", boardInfoMap.get("URL"));
			model.put("boardTypeCD", boardInfoMap.get("BoardTypeCD"));		
		}
	
		model.put("boardMgtList", boardList);
		model.put("boardList", boardList);
		model.put("boardGrpList", boardGrpList);
		model.put("boardGrpCnt", boardGrpList.size());
		model.put("startBoardIndex", boardGrpList.size()+12);
		model.put("reportList", reportList);
		model.put("startReportIndex", boardGrpList.size()+boardList.size() + 12);
		model.put("pmenuIndex", pmenuIndex);
		model.put("maxIndex", ttlCnt + 12);
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		
		model.put("useCR", GlobalVal.USE_COMP_CR);
		model.put("useTask", GlobalVal.USE_COMP_TASK);
		
		return nextUrl(url);
	}
	
	private String makeGridHeader(List moduleNameList, String conStr) {
		String strHeader = "";
		for (int i = 0; moduleNameList.size() > i ; i++) {
			Map moduleNameMap = (Map) moduleNameList.get(i);
        	String moduleName = (String) moduleNameMap.get("Identifier");
        	
			strHeader = strHeader + conStr + moduleName;
		}		
		return strHeader;
	}
	
	private String setChartValue(String projectID, String languageId) throws ExceptionUtil {
		
		Map jsonMap = new HashMap();
		Map setMap = new HashMap();
		List jsonList = new ArrayList();
			try {
			
			// 해당 프로젝트의 변경오더 리스트를 취득
			setMap.put("ParentID", projectID);
			setMap.put("languageID", languageId);
			List csrList = commonService.selectList("analysis_SQL.getCsrList", setMap);
			
			for (int i = 0; i < csrList.size(); i++) {
				jsonMap = new HashMap();
				setMap.remove("Status");
				
				Map map = (Map) csrList.get(i);
				String csrName = String.valueOf(map.get("ProjectName"));
				String csrId = String.valueOf(map.get("ProjectID"));
				
				// 해당 변경오더의 change set 건수 취득
				jsonMap.put("label", csrName);
				setMap.remove("ParentID");
				setMap.put("projectID", csrId);
				String cngtCnt = commonService.selectString("analysis_SQL.getProjectItemCount", setMap);
				jsonMap.put("ttl", cngtCnt);
				
				setMap.put("Status", "MOD");
				cngtCnt = commonService.selectString("analysis_SQL.getProjectItemCount", setMap);
				jsonMap.put("mod", cngtCnt);
				
				setMap.put("Status", "CLS");
				cngtCnt = commonService.selectString("analysis_SQL.getProjectItemCount", setMap);
				jsonMap.put("cls", cngtCnt);
				
		        jsonList.add(jsonMap);
			}
		
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
        String []  cols = {"label", "ttl", "mod", "cls"};
        return JsonUtil.parseJson(jsonList, cols, "/dev_xbolt");
	}
	
	@RequestMapping(value="/pgTemplate.do")
	public String pgTemplate(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		/* Board List 설정 */
		List boardList = commonService.selectList("board_SQL.boardMgtListNew", cmmMap);
		List boardGrpList = commonService.selectList("board_SQL.boardGrpList", cmmMap);
		List reportList = commonService.selectList("report_SQL.getReportListOfPjt", cmmMap);
		
		/* 해당 프로젝트 ID 설정 */
		String projectID = StringUtil.checkNull(request.getParameter("projectID"),"NULL");
		String tmplFilter = StringUtil.checkNull(request.getParameter("tmplFilter"),"");
				
		String url = "/hom/main/v33/pgTemplate";
		if(!tmplFilter.equals("")&& !tmplFilter.equals("NULL")){
			url = "/hom/main/v33/"+tmplFilter;
		}
				
		if(projectID.equals("NULL") || projectID.equals("")) {	
			Map projectInfoMap = commonService.select("main_SQL.getPjtInfoFromTEMPL", cmmMap);			
			model.put("projectID", projectInfoMap.get("ProjectID"));
			model.put("projectName", projectInfoMap.get("Name"));
		} else {
			model.put("projectID", StringUtil.checkNull(request.getParameter("projectID"),"NULL"));			
			String  projectName = commonService.selectString("project_SQL.getProjectName", cmmMap);
			model.put("projectName", projectName);
		}
		/* menu index 설정 */
		String pmenuIndex = "1 2 3 4 5 6 7 8"; // 고정 메뉴 Index
		String space = " ";

		int ttlCnt = boardList.size() + boardGrpList.size() + reportList.size();
		int cnt = 9;
		for (int i = 0; ttlCnt > i ; i++) {
			pmenuIndex = pmenuIndex + space + cnt;
			cnt++;
		}
		
		// 할당된 첫번째 게시판으로 로딩되게..
		Map boardInfoMap = new HashMap();
		if(boardList != null && !boardList.isEmpty()) {
			boardInfoMap = (Map)boardList.get(0);		
			model.put("boardMgtID", boardInfoMap.get("BoardMgtID"));
			model.put("url", boardInfoMap.get("URL"));
			model.put("boardTypeCD", boardInfoMap.get("BoardTypeCD"));	
		}
		
		cmmMap.put("srTypeCode", StringUtil.checkNull(request.getParameter("srType"),""));				
		Map srTypeInfo = commonService.select("esm_SQL.getESMSRTypeInfo",cmmMap);
		String srVarFilter = StringUtil.checkNull(srTypeInfo.get("VarFilter"));
		model.put("srVarFilter", srVarFilter);
	
		model.put("boardList", boardList);
		model.put("boardGrpList", boardGrpList);
		model.put("boardGrpCnt", boardGrpList.size());
		model.put("startBoardIndex", 8);
		model.put("startReportIndex", boardGrpList.size()+boardList.size() + 8);
		model.put("pmenuIndex", pmenuIndex);
		model.put("reportList", reportList);
		model.put("maxIndex", ttlCnt + 8);
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		
		model.put("useCR", GlobalVal.USE_COMP_CR);
		model.put("useTask", GlobalVal.USE_COMP_TASK);
		model.put("srType", StringUtil.checkNull(request.getParameter("srType"),""));
		
		return nextUrl(url);
	}
	
	@RequestMapping(value="/mainHomLayer_v4.do")
	public String mainHomLayer_v4(HttpServletRequest request, ModelMap model) throws Exception{
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		return nextUrl("/hom/main/v33/mainHomLayer_v4");
	}
	
	
	
	@RequestMapping(value="/goProjectPop.do")
	public String goProjectPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		try {
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String loginUserID = StringUtil.checkNull(cmmMap.get("sessionUserId")); 
			String filter = "PJT";

			cmmMap.put("languageID", languageID);
			cmmMap.put("loginUserID", loginUserID);
			cmmMap.put("filter", filter);
//	        List PJListPopList = commonService.selectList("project_SQL.getPJTMemberRelList_gridList", cmmMap); //원본 쿼리
	        List PJListPopList = commonService.selectList("project_SQL.getSetProjectList_gridList", cmmMap); //myProjectList 쿼리 사용

	        JSONArray gridData = new JSONArray(PJListPopList);
	        model.put("gridData",gridData);	
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}		
		catch (Exception e) {System.out.println(e);throw new ExceptionUtil(e.toString());}		
		return nextUrl("/hom/main/projectListPop");
	}	
	

	
	@RequestMapping(value="/sfMain.do")
	public String sfMain(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception{
		Map setData = new HashMap();
		setData.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
		setData.put("sessionUserId", cmmMap.get("sessionUserId"));
		setData.put("templCode", "TMPL003");		
		Map templateMap = commonService.select("menu_SQL.mainTempl_select",setData);
		
		model.put("templateMap", templateMap);
		model.put("menu", getLabel(request, commonService));	//Label Setting
		model.put("screenType", request.getParameter("screenType"));
		return nextUrl("/hom/main/v33/sfMain"); 
	}
	
	
	// gerpProcessLayer 이동
	@RequestMapping(value="/olmMainHomeV34.do")
	public String olmMainHomeV34(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception{
		String url = StringUtil.checkNull(cmmMap.get("url"),"/hom/main/v34/olmMainHomeV34");
		try {
			Map setMap = new HashMap();
			List viewItemTypeList = new ArrayList();
			
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String mLvl = StringUtil.checkNull(cmmMap.get("sessionMlvl"));
			
			setMap.put("ChangeMgt","1");
			setMap.put("languageID",languageID);
			List itemTypeCodeList = commonService.selectList("item_SQL.getItemTypeCodeList",setMap);
			
			if(itemTypeCodeList != null && !itemTypeCodeList.isEmpty()) {
				Map typeTemp = new HashMap();
				Map cntTemp = new HashMap();
				
				for(int i=0; i < itemTypeCodeList.size(); i++) {
					typeTemp = (Map)itemTypeCodeList.get(i);
					cntTemp = new HashMap();
					setMap.put("itemTypeCode",StringUtil.checkNull(typeTemp.get("CODE")));
					
					String itemCnt = StringUtil.checkNull(commonService.selectString("item_SQL.getItemCntByItemType",setMap));
					
					cntTemp.put("itemCnt", itemCnt);
					cntTemp.put("itemCode", StringUtil.checkNull(typeTemp.get("CODE")));
					cntTemp.put("itemName", StringUtil.checkNull(typeTemp.get("NAME")));
					cntTemp.put("itemIcon", StringUtil.checkNull(typeTemp.get("ICON")));
					cntTemp.put("itemArcCode", StringUtil.checkNull(typeTemp.get("ArcCode")));
					cntTemp.put("itemArcStyle", StringUtil.checkNull(typeTemp.get("ArcStyle")));
					cntTemp.put("itemArcIcon", StringUtil.checkNull(typeTemp.get("ArcIcon")));
					cntTemp.put("itemURL", StringUtil.checkNull(typeTemp.get("URL")));
					cntTemp.put("itemMenuVar", StringUtil.checkNull(typeTemp.get("MenuVar")));
					cntTemp.put("itemArcVar", StringUtil.checkNull(typeTemp.get("ArcVar")));
					cntTemp.put("itemDefColor", StringUtil.checkNull(typeTemp.get("DefColor")));
					
					viewItemTypeList.add(i, cntTemp);
				}
			}
			
			setMap.put("sessionCurrLangType",languageID);
			setMap.put("authorID",userId);
			
			// my cs List
			setMap.put("top","10");
			setMap.put("changeMgtYN","Y");
			setMap.put("statusList","'NEW1','NEW2','MOD1','MOD2'");		
			setMap.remove("itemTypeCode");
			List myItemList = commonService.selectList("item_SQL.getOwnerItemList_gridList", setMap);
			model.put("myItemList", myItemList);
			
			setMap.put("actorID", userId);
			setMap.put("filter", "myWF");
			setMap.put("wfMode", "CurAprv");
			List wfCurAprvList = commonService.selectList("wf_SQL.getWFInstList_gridList",setMap);
			if(wfCurAprvList != null && !wfCurAprvList.isEmpty()) {
				model.put("wfCurAprvCnt",wfCurAprvList.size());
			}
			else {
				model.put("wfCurAprvCnt","0");
			}
			
			// my Review Board List
			
		//  setMap.put("myID", userId);
			setMap.put("myBoard","Y");

			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			long date = System.currentTimeMillis();
			setMap.put("scEndDtFrom", formatter.format(date));
			setMap.put("BoardMgtID","BRD0001");
			setMap.put("sessionUserId",userId);
		
			List myRewBrdList = commonService.selectList("forum_SQL.forumGridList_gridList", setMap);
			model.put("myRewBrdList", myRewBrdList);
			
			model.put("srType", request.getParameter("srType"));
			model.put("viewItemTypeList",viewItemTypeList);
			model.put("languageID", languageID);	
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		model.put("menu", getLabel(request, commonService));	//Label Setting
		model.put("screenType", request.getParameter("screenType"));
		return nextUrl(url);
	}
	
	
	@RequestMapping(value="/mySpaceV34.do")
	public String mySpaceV3(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
	
		String url = StringUtil.checkNull(cmmMap.get("url"),"");
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String mLvl = StringUtil.checkNull(cmmMap.get("sessionMlvl"));			
			String scrnType = StringUtil.checkNull(cmmMap.get("scrnType"));	
			String srType = StringUtil.checkNull(cmmMap.get("srType"));
			String mySpaceViwerScrn = StringUtil.checkNull(cmmMap.get("mySpaceViwerScrn"), "/hom/mySpace/v34/olmMySpaceViewer");
			String mySpaceEditorScrn = StringUtil.checkNull(cmmMap.get("mySpaceEditorScrn"), "/hom/mySpace/v34/olmMySpaceEditor");
						
			if (url.equals("")){
				if(mLvl.equals("VIEWER")) {
					url = mySpaceViwerScrn;
				}
				else {
					url = mySpaceEditorScrn;
				}
			}
			
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
			
			setMap.put("authorID", userId);
			
			setMap.put("actorID", userId);
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
						
			setMap.put("languageID", languageID);
			setMap.put("wfMode", "AREQ");
			setMap.put("filter", "myWF");
			List wfAREQList = commonService.selectList("wf_SQL.getWFInstList_gridList",setMap);
			
			setMap.put("wfMode", "CurAprv");
			List wfCurAprvList = commonService.selectList("wf_SQL.getWFInstList_gridList",setMap);
			
			setMap.put("wfMode", "ToDoAprv");
			List wfToDoAprvList = commonService.selectList("wf_SQL.getWFInstList_gridList",setMap);
			
			setMap.put("wfMode", "RefMgt");
			List wfRefMgtList = commonService.selectList("wf_SQL.getWFInstList_gridList",setMap);
			
			setMap.put("notStatus","REL");
			setMap.put("changeMgtYN","Yes");
			String itemModeAllCnt = StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCount",setMap));
			
			String itemSubModeCnt = StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCountByRole",setMap));
			
			
			
			setMap.put("srType",srType);
			setMap.put("srMode","mySR");
			setMap.put("srStatus","ING");
			setMap.put("loginUserId", cmmMap.get("sessionUserId"));
			
			List srIngList = commonService.selectList("esm_SQL.getEsrMSTList_gridList",setMap);
			
			switch(srType) {
				default : setMap.put("srStatus","SPE001"); break;
				case "ISP" : setMap.put("srStatus","SPE018"); break;
			}
			List srNewList = commonService.selectList("esm_SQL.getEsrMSTList_gridList",setMap);
			
			cmmMap.put("templCode", "MYPAGE");
			cmmMap.put("languageId", cmmMap.get("sessionCurrLangType"));
			List reportList = commonService.selectList("config_SQL.getReportAllocList_gridList", cmmMap);
			
			/* menu index 설정 */
			String pmenuIndex = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19"; // 고정 메뉴 Index
			String space = " ";
			
			int ttlCnt = reportList.size();
			int cnt =21;
			String reportText = "";
			
			for (int i = 0; ttlCnt > i ; i++) {
				Map temp = (Map)reportList.get(i);
				
				if( i == 0 ) {
					reportText += "{id:'"+(20+i)+"',value:'"+StringUtil.checkNull(temp.get("ReportName"))
							    +"',html:'<div><a id=\"menuCng"+(20+i)+"\">&nbsp;"+StringUtil.checkNull(temp.get("ReportName"))+"</a></div>'"
							    +",varFilter:'"+StringUtil.checkNull(temp.get("ReportURL"))+"?"+StringUtil.checkNull(temp.get("VarFilter"))
							    +"&reportCode="+StringUtil.checkNull(temp.get("ReportCode"))+"'}";
							   
				}
				else {
					reportText += ",{id:'"+(20+i)+"',value:'"+StringUtil.checkNull(temp.get("ReportName"))
							    +"',html:'<div><a id=\"menuCng"+(20+i)+"\">&nbsp;"+StringUtil.checkNull(temp.get("ReportName"))+"</a></div>'"
							    +",varFilter:'"+StringUtil.checkNull(temp.get("ReportURL"))+"?"+StringUtil.checkNull(temp.get("VarFilter"))
							    +"&reportCode="+StringUtil.checkNull(temp.get("ReportCode"))+"'}";
				}
				
			}
			
			model.put("reportText",reportText);
			
			if(wfAREQList != null && !wfAREQList.isEmpty()) {
				model.put("wfAREQCnt",wfAREQList.size());
			}
			else {
				model.put("wfAREQCnt","0");
			}
			
			if(wfCurAprvList != null && !wfCurAprvList.isEmpty()) {
				model.put("wfCurAprvCnt",wfCurAprvList.size());
			}
			else {
				model.put("wfCurAprvCnt","0");
			}
			
			if(wfToDoAprvList != null && !wfToDoAprvList.isEmpty()) {
				model.put("wfToDoAprvCnt",wfToDoAprvList.size());
			}
			else {
				model.put("wfToDoAprvCnt","0");
			}
			
			if(wfRefMgtList != null && !wfRefMgtList.isEmpty()) {
				model.put("wfRefMgtCnt",wfRefMgtList.size());
			}
			else {
				model.put("wfRefMgtCnt","0");
			}
			
			if(mLvl.equals("VIEWER")) {	
				model.put("itemCnt",itemSubCnt);
				model.put("itemTreeCnt", itemSubCnt.replace(",", ""));				
				model.put("itemTreeModeCnt",itemSubModeCnt.replace(",", ""));		
				model.put("itemModeCnt",itemSubModeCnt);
			}
			else {
				model.put("itemCnt",itemCnt);		
				model.put("itemModeCnt",itemModeAllCnt);		
				
				model.put("itemNewCnt",itemNewCnt.replace(",", ""));			
				model.put("itemModCnt",itemModCnt.replace(",", ""));			
				model.put("itemAprvCnt",itemAprvCnt.replace(",", ""));	
				model.put("itemModAllCnt",itemModeAllCnt.replace(",", ""));	
				model.put("itemTreeCnt", itemCnt.replace(",", ""));				
				model.put("itemSubCnt",itemSubCnt.replace(",", ""));		
			}
			
			if(srIngList != null && !srIngList.isEmpty()) {
				model.put("srIngCnt",srIngList.size());
			}
			else {
				model.put("srIngCnt","0");
			}
			
			if(srNewList != null && !srNewList.isEmpty()) {
				model.put("srNewCnt",srNewList.size());
			}
			else {
				model.put("srNewCnt","0");
			}
			
			setMap.put("userID", userId);
			String memPhoto = StringUtil.checkNull(commonService.selectString("user_SQL.getUserPhoto",setMap));
			
			// user group id list 
			List userGrMgtList = new ArrayList();
			String userGrMgtYN = "";
			userGrMgtList = commonService.selectList("user_SQL.getUserGrMgt", setMap);
			// user group manager check
			if(userGrMgtList.size() > 0) {
				userGrMgtYN = "Y";
			}
			model.put("userGrMgtYN", userGrMgtYN);
			
			model.put("memPhoto", memPhoto);
			model.put("startReportIndex", 20);
			model.put("reportList", reportList);
			model.put("pmenuIndex", pmenuIndex);
			model.put("scrnType",scrnType);
			model.put("maxIndex", ttlCnt + 10);
			model.put("languageID", languageID);	
			model.put("pjtList", pjtList);		
			model.put("srType", srType);	
			model.put("srID", StringUtil.checkNull(request.getParameter("srID")));	
			model.put("wfInstanceID", StringUtil.checkNull(request.getParameter("wfInstanceID")));
			model.put("multiComp", StringUtil.checkNull(request.getParameter("multiComp")));	
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("mainType", StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("mainType"))));				
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);
	}
	
	
	@RequestMapping(value="/olmMySpaceItemList.do")
	public String olmMySpaceItemList(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String mlvl = StringUtil.checkNull(cmmMap.get("sessionMlvl"));
			
			setMap.put("languageID", languageID);
			setMap.put("managerID",userId);
			setMap.put("status", "ING");
			setMap.put("changeMgtYN","Y");
			List itemModList = new ArrayList();
			
			if(mlvl.equals("VIEWER")) {				
				itemModList = commonService.selectList("item_SQL.getMyItemList_gridList",setMap);
			}
			else  {		
				itemModList = commonService.selectList("item_SQL.getOwnerItemList_gridList",setMap);
			}
			
			model.put("itemModList", itemModList);	
			model.put("languageID", languageID);	
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
						
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		
		return nextUrl("/hom/mySpace/v34/olmMySpaceItemList");
	}
	
	@RequestMapping(value="/olmMySpaceCSRList.do")
	public String olmMySpaceCSRList(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			
			setMap.put("languageID", languageID);
			setMap.put("workerID", userId);
			setMap.put("csrStatus","ING");
			
			setMap.put("ProjectType", "CSR");
			List csrList = commonService.selectList("project_SQL.getMyCsrList",setMap);
			
			//pjtList.addAll(csrList);
			
						
			model.put("csrList", csrList);	
			model.put("languageID", languageID);	
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
						
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		
		return nextUrl("/hom/mySpace/v34/olmMySpaceCSRList");
	}
	
	@RequestMapping(value="/olmMySpaceLastViewed.do")
	public String olmMySpaceLastViewed(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			
			setMap.put("languageID", languageID);
			setMap.put("memberID", userId);
			List itemList = commonService.selectList("item_SQL.getRcntViewedItemList",setMap);
			
			model.put("itemList", itemList);	
			model.put("languageID", languageID);	
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
						
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		
		return nextUrl("/hom/mySpace/v34/olmMySpaceRcntViewed");
	}
	
	@RequestMapping(value="/olmSiteMap.do")
	public String olmSiteMap(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		try {
			
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			
			/*
			setMap.put("languageID", languageID);
			setMap.put("memberID", userId);
			List tmplList = commonService.selectList("menu_SQL.getSiteMapTmplList",setMap);
			List PMenuList = new ArrayList();
			List SMenuList = new ArrayList();
			List allSiteMapMenuList = new ArrayList();
			String templCode = "";
			String templName = "";
			for(int i=0; i<tmplList.size(); i++) {
				returnMap = new HashMap();
				tempPMap = (HashMap) tmplList.get(i);
				templCode = StringUtil.checkNull(tempPMap.get("TemplCode"));
				templName = StringUtil.checkNull(tempPMap.get("Name"));
				setMap.put("templCode", templCode);
				setMap.put("parentIsNull", "Y");
				PMenuList = commonService.selectList("menu_SQL.getSiteMapMenuList",setMap);
				
				setMap.put("templCode", templCode);
				setMap.put("parentIsNull", "N");
				SMenuList = commonService.selectList("menu_SQL.getSiteMapMenuList",setMap);
				
				returnMap.put("templName", templName);
				returnMap.put("templCode", templCode);
				returnMap.put("PMenuList", PMenuList);
				returnMap.put("SMenuList", SMenuList);
				allSiteMapMenuList.add(returnMap);
			}

			model.put("allSiteMapMenuList", allSiteMapMenuList);
			*/
			cmmMap.put("templCode", cmmMap.get("sessionTemplCode"));
			List layerList = commonService.selectList("menu_SQL.mainTempl_select", cmmMap);
			
			model.put("templList", layerList);
			model.put("topMenuList", commonService.selectList("menu_SQL.defaultTopMenu_select", cmmMap));
			model.put("mainMenuList", commonService.selectList("menu_SQL.mainMenu_select", cmmMap));
			model.put("scnMenuList", commonService.selectList("menu_SQL.secondMenu_select", cmmMap));
			model.put("thdMenuList", commonService.selectList("menu_SQL.thirdMenu_select", cmmMap));
			model.put("languageID", languageID);	
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			cmmMap.remove("templCode");
						
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		
		return nextUrl("/hom/sub/olmSiteMap");
	}
	
	@RequestMapping(value="/olmMainbookMarkList.do")
	public String olmMainbookMarkList(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			
			setMap.put("sessionUserId",userId);
			setMap.put("languageID",languageID);
			setMap.put("statusList", request.getParameter("statusList"));	
			setMap.put("status", StringUtil.checkNull(request.getParameter("status"),""));
			setMap.put("srID", request.getParameter("srID"));	
			setMap.put("changeMgt", request.getParameter("changeMgt"));	
			setMap.put("assignmentType", "SUBSCR");
			
			List bookMarkList = commonService.selectList("item_SQL.getMyItemList_gridList", setMap);
			model.put("bookMarkList", bookMarkList);
						
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		
		return nextUrl("/hom/main/v34/olmMainbookMarkList");
	}
	
	@RequestMapping(value = "/arcMenuMgt.do")
	public String sideMenuMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			
			String sideBtn = StringUtil.checkNull(commandMap.get("sideBtn"),"");
			if(!sideBtn.equals("")) {
				setMap.put("arcCode", sideBtn);
				setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				Map arcInfo = commonService.select("menu_SQL.getArcInfo", setMap);
				model.put("arcInfo", arcInfo);
			}
			
			model.put("menuList", commonService.selectList("menu_SQL.secondMenu_select", commandMap));
			model.put("arcCode", StringUtil.checkNull(commandMap.get("arcCode"), ""));
			model.put("arcDefPage", StringUtil.checkNull(commandMap.get("arcDefPage"), ""));
	        model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("hom/main/arc/arcMenuMgt");
	}
}