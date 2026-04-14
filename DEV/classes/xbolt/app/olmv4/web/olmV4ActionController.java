package xbolt.app.olmv4.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.org.json.JSONArray;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.JsonUtil;
import xbolt.cmm.framework.util.MakeEmailContents;

import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;


@Controller
@SuppressWarnings("unchecked")
public class olmV4ActionController extends XboltController{
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;

	
	@RequestMapping("/csrInfoMgtPop.do")
	public String csrInfoMgtPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "app/olmv4/csrInfoMgtPop";
		Map setMap = new HashMap();
		Map setData = new HashMap();
		Map getMap = new HashMap();
		try {
				String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
				String screenMode = StringUtil.checkNull(request.getParameter("screenMode"));
				String mainMenu = StringUtil.checkNull(request.getParameter("mainMenu"));
				String refPjtID = StringUtil.checkNull(request.getParameter("refPjtID"));
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String srSubject = StringUtil.checkNull(request.getParameter("srSubject"));
				String srPriority = StringUtil.checkNull(request.getParameter("srPriority"));
				String screenType = StringUtil.checkNull(request.getParameter("screenType"));
				String fromSR = StringUtil.checkNull(request.getParameter("fromSR"));
				setMap.put("projectID", projectID);
				if(refPjtID.equals("")){
					refPjtID = StringUtil.checkNull( commonService.selectString("project_SQL.getRefPjtID", setMap) );
				}
				
				String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String isManager = "N";
				String isMember = "N";
				
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("openPJT", "Y");
				setMap.put("loginUserId", commandMap.get("sessionUserId"));
				setMap.put("ProjectID", refPjtID);
				List parentPjtList = commonService.selectList("project_SQL.getParentPjtFromRel", setMap);
				String refPjtAuthorID = commonService.selectString("project_SQL.getPjtAuthorID", setMap);
				setMap.remove("ProjectID");
				setMap.remove("projectID");
				
				setMap.remove("loginUserId");
				setMap.put("ProjectID", request.getParameter("ProjectID"));
				getMap = commonService.select("project_SQL.getSetProjectListForCsr_gridList", setMap);
				
				/* 로그인 유저가 해당 프로젝트의 담당자 여부 확인 : TB_PROJECT.Creator or TB_PROJECT.AuthorID */
				String csrEditable = "N";
				String authorID = StringUtil.checkNull(getMap.get("AuthorID"));
				if (loginUser.equals(authorID)) {
					isManager = "Y";
					String status = StringUtil.checkNull(getMap.get("Status"));
					if(status.equals("CSR") || status.equals("CNG") || status.equals("HOLD")){
						csrEditable = "Y";
					}
				}
				model.put("csrEditable", csrEditable);
				
				setData.put("ProjectID", request.getParameter("ProjectID"));
				setData.put("MemberID", commandMap.get("sessionUserId"));
				String pjtMemberRelCnt = commonService.selectString("project_SQL.getPjtMemberRelCnt", setData);
				if(pjtMemberRelCnt.equals("1")){
					isMember = "Y";
				}
				
				model.put("getMap", getMap);
				model.put("projectID", projectID);
				model.put("screenMode", screenMode);
				model.put("mainMenu", mainMenu);
				model.put("refPjtID", refPjtID);
				model.put("screenType", screenType);
				model.put("srID", srID);
				model.put("srSubject", srSubject);
				model.put("srPriority", srPriority);
				model.put("fromSR", fromSR);
				model.put("quickCheckOut", StringUtil.checkNull(request.getParameter("quickCheckOut")));
				model.put("itemID", StringUtil.checkNull(request.getParameter("itemID")));
				model.put("isMember", isMember);
				model.put("menu", getLabel(request, commonService)); /*Label Setting*/
				
				setData.put("csrID", request.getParameter("ProjectID"));
				model.put("CRCNT", StringUtil.checkNull(commonService.selectString("project_SQL.getCRCount", setData)));				
				
				// Tree >> ITEM >> [개요] >> [변경 이력]
				model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
				model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
				model.put("useCR", GlobalVal.USE_COMP_CR);
				model.put("refPjtAuthorID", refPjtAuthorID);
				model.put("quickCheckOut", StringUtil.checkNull(request.getParameter("quickCheckOut")));
				model.put("itemID", StringUtil.checkNull(request.getParameter("itemID")));
		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
	
	
	@RequestMapping("/csrInfoMgt.do")
	public String csrInfoMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "app/olmv4/csrInfoMgt";
		Map setMap = new HashMap();
		Map getMap = new HashMap();
		Map setData = new HashMap();
		List attachFileList = new ArrayList();

		try {			
			String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String isManager = "N";
			String isMember = "N";
			String screenMode = StringUtil.checkNull(request.getParameter("screenMode"));
			String btn = StringUtil.checkNull(request.getParameter("btn"));
			String cngCountOfmember = "";
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String refPjtID = StringUtil.checkNull(request.getParameter("refPjtID"));
			
			
			//setMap.put("ProjectID", refPjtID);
			//setMap.put("Status", "CLS");
			setMap.put("openPJT", "Y");
			setMap.put("loginUserId", commandMap.get("sessionUserId"));
			setMap.put("ProjectID", refPjtID);
			List parentPjtList = commonService.selectList("project_SQL.getParentPjtFromRel", setMap);
			JSONArray pjtData = new JSONArray(parentPjtList);
			model.put("pjtData",pjtData);
			
			String refPjtAuthorID = commonService.selectString("project_SQL.getPjtAuthorID", setMap);
			setMap.remove("ProjectID");
			
			setMap.remove("loginUserId");
			setMap.put("ProjectID", request.getParameter("ProjectID"));
			getMap = commonService.select("project_SQL.getSetProjectListForCsr_gridList", setMap);
			model.put("ProjectCode", getMap.get("ProjectCode"));
			
			String Description = StringUtil.checkNull(getMap.get("Description"),"");
			Description = StringUtil.replaceFilterString(Description);
			Description = Description.replaceAll(System.getProperty("line.separator"), "");
			getMap.put("Description", Description);
			model.put("getMap", getMap);
			
			model.put("cngCountOfmember", cngCountOfmember);
						
			setData.put("ProjectID", request.getParameter("ProjectID"));
			setData.put("MemberID", commandMap.get("sessionUserId"));
			
			setData = new HashMap();
			/* 첨부문서 취득 */
			// attachFileList = commonService.selectList("project_SQL.getProjectFileList", setMap); // 20151229 Pjt_File -> Item_File 변경
			attachFileList = commonService.selectList("project_SQL.getPjtFileList", commandMap);
				
			/* 임시 문서 보관 디렉토리 삭제 */
			String path = GlobalVal.FILE_UPLOAD_BASE_DIR + commandMap.get("sessionUserId");
			FileUtil.deleteDirectory(path);
			
			setData.remove("Status");
			model.put("srID", srID);
			setData.put("csrID", request.getParameter("ProjectID"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("isMember", isMember);
			model.put("isManager", isManager);
			model.put("screenMode", screenMode);
			
			model.put("btn", btn);
			model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID")));
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1")); // 개요화면 일때, 변경오더와 동일
			model.put("refPjtID",refPjtID);
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("fromSR", StringUtil.checkNull(request.getParameter("fromSR")));
			// Tree >> ITEM >> [개요] >> [변경 이력]
			model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
			model.put("useCR", GlobalVal.USE_COMP_CR);
			model.put("refPjtAuthorID", refPjtAuthorID);
			model.put("quickCheckOut", StringUtil.checkNull(request.getParameter("quickCheckOut")));
			model.put("itemID", StringUtil.checkNull(request.getParameter("itemID")));
				
		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/searchPjtMemberPopV4.do")
	public String searchPjtMemberPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
				model.put("searchValue", request.getParameter("searchValue"));
				List getList = new ArrayList();
				Map setMap = new HashMap();
				String projectID = StringUtil.checkNull(request.getParameter("projectID"));
				
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("searchKey", request.getParameter("searchKey"));				
				setMap.put("searchValue", request.getParameter("searchValue"));
				setMap.put("teamID", commandMap.get("teamID"));
				setMap.put("projectID", projectID);
				getList = commonService.selectList("project_SQL.getPjtWorkerList_gridList",setMap) ;
				
				model.put("getList", getList);			
				model.put("projectID", projectID);
				model.put("teamID", commandMap.get("teamID"));
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/app/olmv4/searchPjtMemberPop");
	}
	
	@RequestMapping(value = "/selectPjtMemberV4.do")
	public String selectPjtMember(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map getMap = new HashMap();
		try {
			String screenMode = StringUtil.checkNull(request.getParameter("screenMode"));
			String listEditable = StringUtil.checkNull(request.getParameter("listEditable"));
			String isProject = StringUtil.checkNull(request.getParameter("isProject"));
			String variantID = StringUtil.checkNull(request.getParameter("variantID"));
			String isPjtMgt = StringUtil.checkNull(request.getParameter("isPjtMgt"));
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
			String csrId = StringUtil.checkNull(request.getParameter("csrId"));
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			String teamID = StringUtil.checkNull(request.getParameter("teamID"));
			String authorID = StringUtil.checkNull(request.getParameter("authorID"));

			List pjtRelTeamList = new ArrayList();
			
			if ("N".equals(listEditable)) {
				// get 조직
				commandMap.put("projectID", projectID);
				pjtRelTeamList = commonService.selectList("project_SQL.getPjtRelTeam", commandMap);
				
				// get Project 정보
				commandMap.put("s_itemID", projectID);
				getMap = commonService.select("project_SQL.getProjectInfoView", commandMap);
			}
			
			commandMap.put("UserLevel","ALL");
			commandMap.put("scrnType","PJT");
			commandMap.put("assignmentYN","Y");
			commandMap.put("blankPhotoUrlPath",GlobalVal.HTML_IMG_DIR + "/blank_photo.png");
			commandMap.put("photoUrlPath",GlobalVal.EMP_PHOTO_URL);
			List workerList = commonService.selectList("project_SQL.getPjtWorkerList_gridList", commandMap);
			JSONArray workerData = new JSONArray(workerList);
			model.put("workerData",workerData);
			
			model.put("csrId", csrId);
			model.put("screenMode", screenMode);
			model.put("listEditable", listEditable);
			model.put("isProject", isProject);
			model.put("variantID", variantID);
			model.put("isPjtMgt", isPjtMgt);
			model.put("authorID", authorID);
			model.put("projectID", projectID);
			model.put("parentID", StringUtil.checkNull(request.getParameter("parentID")));
			model.put("UserLevel", StringUtil.checkNull(request.getParameter("UserLevel")));
			model.put("pjtRelTeamList", pjtRelTeamList);
			model.put("screenType", screenType);
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("getMap", getMap);
			model.put("teamID", teamID); 
			model.put("workerList", workerList); 
			model.put("menu", getLabel(request, commonService)); /*Label Setting*/		
		
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/app/olmv4/selectPjtMember");
	}
	
	@RequestMapping(value="/standardTermsSchV4.do")
	public String standardTermsSch(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		model.addAttribute(HTML_HEADER, "Standard Terms");
		
		try { 
				String lovCode = StringUtil.checkNull(commandMap.get("lovCode"));
				String page = StringUtil.checkNull(request.getParameter("page"), "1");
				String searchCondition1 = StringUtil.checkNull(request.getParameter("searchCondition1"), ""); // 검색 조건
				String searchCondition2 = StringUtil.checkNull(request.getParameter("searchCondition2"), ""); // 검색 조건
				String searchCondition3 = StringUtil.checkNull(request.getParameter("searchCondition3"), ""); // 검색 조건
				String searchCondition4 = StringUtil.checkNull(request.getParameter("searchCondition4"), ""); // 검색 조건
				String languageID =StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String userId = StringUtil.checkNull(commandMap.get("sessionUserId"));
			
				/** BEGIN ::: LANGUAGE**/
				HashMap cmmMap = new HashMap();
				
				cmmMap.put("languageID", languageID);
				cmmMap.put("userId", userId);
				String clientId = StringUtil.checkNull(commonService.selectString("standardTerms_SQL.getUserClientId", cmmMap));
				
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				/** END ::: LANGUAGE**/
				
				Map mapValue = new HashMap();
				mapValue.put("languageID", languageID);
				
				if (!searchCondition1.isEmpty()) {
					mapValue.put("searchCondition1", searchCondition1);
				} else if (!searchCondition2.isEmpty()) {
					mapValue.put("searchCondition2", searchCondition2);
				} else if (!searchCondition3.isEmpty()) {
					mapValue.put("searchCondition3", searchCondition3);
					mapValue.put("searchCondition4", searchCondition4);
				}
				
				String lovName = "";
				lovName = StringUtil.checkNull(commonService.selectString("standardTerms_SQL.getLovValue", commandMap),"");
				
				List termsList = commonService.selectList("standardTerms_SQL.getSearchResult_gridList", commandMap);
				JSONArray termsData = new JSONArray(termsList);
				
				model.put("languageID", languageID);
				model.put("clientID", clientId);
				model.put("page", page);
				model.put("searchCondition1", searchCondition1);
				model.put("searchCondition2", searchCondition2);
				model.put("searchCondition3", searchCondition3);
				model.put("searchCondition4", searchCondition4);
				model.put("pageScale", GlobalVal.LIST_PAGE_SCALE);
				model.put("lovCode", lovCode);
				model.put("lovName", lovName);
				model.put("csr", commandMap.get("csr"));		
				model.put("mgt", commandMap.get("mgt"));
				model.put("termsData", termsData);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/app/olmv4/standardTerms");
	}
	
	@RequestMapping(value = "/changeInfoListV4.do")
	public String changeInfoList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {


		String url = "app/olmv4/changeSetofCSR";
		Map setMap = new HashMap();
		List classCodeList = new ArrayList();
		List pjtList = new ArrayList();
		List csrList = new ArrayList();
		
		String isFromPjt = StringUtil.checkNull(request.getParameter("isFromPjt"));
		String projectID = StringUtil.checkNull(request.getParameter("projectID"),""); 
	//	String projectID = StringUtil.checkNull(request.getParameter("s_itemID"));
		String screenType = StringUtil.checkNull(request.getParameter("screenType"));		
		String isMember = StringUtil.checkNull(request.getParameter("isMember"));
		String csrStatus = StringUtil.checkNull(request.getParameter("csrStatus"));
		String classCodes = StringUtil.checkNull(request.getParameter("classCodes"));
		String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));	
		String modStartDT = StringUtil.checkNull(request.getParameter("modStartDT"));	
		String modEndDT = StringUtil.checkNull(request.getParameter("modEndDT"));	

		try {
										
			if (scrnType.equals("ARC") || "0".equals(StringUtil.checkNull(request.getParameter("mainMenu")))) {
				url = "project/changeInfo/changeSet";

				commandMap.put("Category", "CNGSTS");
				List statusList = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);
				model.put("statusList", statusList);
				
				commandMap.put("Category", "CNGT1");
				List changeTypeList = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);
				model.put("changeTypeList", changeTypeList);

				if (!projectID.isEmpty()) {
					
					if(screenType.equals("PG")){
					    setMap.put("RefPGID", projectID);
					}else{
						setMap.put("RefPjtID", projectID);
					}
				}
				
				model.put("modStartDT",modStartDT);
				model.put("modEndDT",modEndDT);
			}

				setMap.put("ProjectType", "PJT");
				setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				pjtList = commonService.selectList("project_SQL.getParentPjtList", setMap);
				
				// 愿��젴 CSR 由ъ뒪�듃
			
				setMap.put("ProjectType", "CSR");
				csrList = commonService.selectList("project_SQL.getParentPjtList", setMap);


				setMap.put("LanguageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				setMap.put("isMine", StringUtil.checkNull(request.getParameter("isMine")));
				classCodeList = commonService.selectList("cs_SQL.getClassCodeList", setMap);
				model.put("classCodeList", classCodeList);
			
			setMap.put("s_itemID", StringUtil.checkNull(request.getParameter("ProjectID")));
			setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			Map projectInfoMap = commonService.select("project_SQL.getProjectInfo", setMap);


			setMap.put("ChangeMgt", "1");
			classCodeList = commonService.selectList("item_SQL.getClassCodeOption", setMap);
			model.put("classCodeList", classCodeList);


			setMap.put("Creator", StringUtil.checkNull(projectInfoMap.get("Creator")));
			List memberList = commonService.selectList("project_SQL.getProjectMemberList", setMap);
			model.put("memberList", memberList);
			
			model.put("classCodes", classCodes);
			model.put("pjtCreator", StringUtil.checkNull(projectInfoMap.get("Creator")));
			model.put("pjtStatus", StringUtil.checkNull(projectInfoMap.get("Status")));
			model.put("pjtWfId", StringUtil.checkNull(projectInfoMap.get("WFID")));
			model.put("screenMode", StringUtil.checkNull(request.getParameter("screenMode")));
			model.put("isMine", StringUtil.checkNull(request.getParameter("isMine")));
			model.put("status", StringUtil.checkNull(request.getParameter("status")));
			model.put("changeType", StringUtil.checkNull(request.getParameter("changeType")));
			model.put("myTeam", StringUtil.checkNull(request.getParameter("myTeam")));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			setMap.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID")));
			setMap.put("projectID", StringUtil.checkNull(request.getParameter("ProjectID")));
			setMap.put("Status", "CLS");
			model.put("clsCount", commonService.selectString("cs_SQL.getCNGTCount", setMap));
			model.put("itemCount", commonService.selectString("cs_SQL.getProjectItemCount", setMap));
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
			model.put("pjtList", pjtList);
			model.put("csrList", csrList);
			model.put("currPageA", StringUtil.checkNull(request.getParameter("currPageA"), "1"));
			model.put("isFromPjt", isFromPjt);
			model.put("myPjtId", projectID);
			model.put("closingOption", StringUtil.checkNull(request.getParameter("closingOption")));
			model.put("authorID", StringUtil.checkNull(projectInfoMap.get("AuthorID")));

			if(!screenType.equals("CSR")){
			model.put("refID", projectID);
			model.put("projectID", projectID);
			}

			setMap.put("DocCategory", "CS");
			String wfURL = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", setMap));
			
	        List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);	
			model.put("dimTypeList", dimTypeList);
			
			commandMap.put("csrID", StringUtil.checkNull(request.getParameter("csrID")));
			List gridList = commonService.selectList("cs_SQL.getChangeSetList_gridList", commandMap);
			JSONArray gridData = new JSONArray(gridList);
			model.put("gridData", gridData);
			
			model.put("wfURL",wfURL);
			model.put("csrID", StringUtil.checkNull(request.getParameter("csrID")));
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("screenType", screenType);
			model.put("csrStatus", csrStatus);

			model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
			model.put("isMember", isMember);
			model.put("chgsts", StringUtil.checkNull(request.getParameter("chgsts"))); // mainHomeSKH(Revision FullScreen)
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl(url);
	}
	
	@RequestMapping(value="/boardListV4.do")
	public String boardList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"), request.getParameter("boardMgtID"));
		String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "1");
		/*String boardUrl = StringUtil.checkNull(request.getParameter("boardUrl"), "");*/
		String boardTypeCD = StringUtil.checkNull(request.getParameter("boardTypeCD"), "");
		String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");
		String defBoardMgtID = StringUtil.checkNull(cmmMap.get("defBoardMgtID"));
		String category = StringUtil.checkNull(cmmMap.get("category"));
		String categoryIndex = StringUtil.checkNull(cmmMap.get("categoryIndex"));
		String categoryCnt = StringUtil.checkNull(cmmMap.get("categoryCnt"));
		String scStartDt = StringUtil.checkNull(cmmMap.get("scStartDt"));
		String scEndDt = StringUtil.checkNull(cmmMap.get("scEndDt"));
		String myBoard = StringUtil.checkNull(request.getParameter("myBoard"));
		String icon = "icon_folder_upload_title.png";
		String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
		String templProjectID = StringUtil.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap),"");
		String projectType = "";
		String projectCategory = StringUtil.checkNull(request.getParameter("projectCategory"), "");
		String projectIDs = StringUtil.checkNull(request.getParameter("projectIDs"), "");
		String srID = StringUtil.checkNull(request.getParameter("srID"), "");
		String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
		String varFilter = StringUtil.checkNull(request.getParameter("varFilter"), "4");
		
		Map setMap2 = new HashMap();
		setMap2.put("MenuID", boardTypeCD);
//		String boardUrl = StringUtil.checkNull(commonService.selectString("menu_SQL.getMenuVarfilter", setMap2),"");
//		int idx = boardUrl.indexOf("=");
//		boardUrl = boardUrl.substring(idx+1);
//		String url = boardUrl ;
//		if(boardUrl.equals("")){
			String url = "/app/olmv4/boardForumList";
//		}
		
		if((BoardMgtID == null || BoardMgtID == "") && varFilter != null) {
			BoardMgtID = varFilter;
		}
		
		if(BoardMgtID != null && BoardMgtID.equals("4")){
			icon = "comment_user.png";
		};	
					
		try {
			Map setMap = new HashMap();
			if(projectID != null && !"".equals(projectID)){
				templProjectID = projectID ;			
			} else {
				projectID = templProjectID;
			}			
			if(templProjectID != null && !"".equals(templProjectID)) {
				setMap.put("s_itemID",templProjectID);
				projectType = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectType", setMap),"");				
			}
			
		
			setMap.put("BoardMgtID", BoardMgtID);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			Map boardMgtInfo = commonService.select("board_SQL.getBoardMgtInfo", setMap);
			model.put("boardMgtInfo", boardMgtInfo);
			
			int totCnt = NumberUtil.getIntValue(commonService.selectString("board_SQL.boardTotalCnt", setMap));		
			
			String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName",setMap);	
			String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);
			model.put("boardMgtName", boardMgtName);
			model.put("CategoryYN", categoryYN);			
			
			String likeYN = commonService.selectString("board_SQL.getBoardLikeYN", setMap);
			model.put("LikeYN", likeYN);
		
			if ("Y".equals(myBoard)) {
				setMap.put("myID", cmmMap.get("sessionUserId"));
				model.put("boardMgtName", "Communication");
			}
			
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			List brdCatList = commonService.selectList("common_SQL.getBoardMgtCategory_commonSelect", setMap);
			Map mgtInfoMap = commonService.select("board_SQL.getBoardMgtInfo", setMap);
			
			if("N".equals(mgtInfoMap.get("MgtOnlyYN")) && Integer.parseInt(mgtInfoMap.get("MgtGRID").toString()) > 0) {
				Map tmpMap = new HashMap();
				
				tmpMap.put("checkID", cmmMap.get("sessionUserId"));
				tmpMap.put("groupID", mgtInfoMap.get("MgtGRID"));
				String check = StringUtil.checkNull(commonService.selectString("user_SQL.getEndGRUser", tmpMap),"");
				
				if(!"".equals(check)) {
					mgtInfoMap.put("MgtGRID2", mgtInfoMap.get("MgtGRID"));
				}
				else {
					mgtInfoMap.put("MgtGRID2", "");
				}
			}
			
			setMap.put("itemID", itemID);
			setMap.put("baseURL", GlobalVal.BASE_ATCH_URL);
			setMap.put("myBoard", myBoard);
			setMap.put("srID", srID);
			List forumList = commonService.selectList("forum_SQL.forumGridList_gridList", setMap);
			JSONArray forumData = new JSONArray(forumList);
			model.put("forumData", forumData);
			
			model.put("scStartDt", scStartDt);
			model.put("scEndDt", scEndDt);
			model.put("templProjectID", templProjectID);
			model.put("projectType", projectType);
			model.put("mgtInfoMap", mgtInfoMap);
			model.put("brdCatList", brdCatList);
			model.put("brdCatListCnt", brdCatList.size());
			model.put("totalPage", totCnt);
			model.put("pageNum", pageNum);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("icon",icon);
			model.put("BoardMgtID", BoardMgtID);
			model.put("screenType", screenType);
			model.put("myBoard", myBoard);
			model.put("projectID", projectID);
			model.put("defBoardMgtID", defBoardMgtID);
			model.put("category", category);
			model.put("categoryIndex", categoryIndex);
			model.put("categoryCnt", categoryCnt);
			model.put("baseUrl", GlobalVal.BASE_ATCH_URL);
			model.put("projectCategory",projectCategory);
			model.put("projectIDs",projectIDs);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl(url);
	}

	@RequestMapping(value="/subMenuV4.do")
	public String subMenu(HttpServletRequest request ,ModelMap model) throws Exception{
		//model.put(AJAX_RESULTMAP, commonService.selectList("menu_SQL.contentMenu", commandMap));
		
		//메뉴 받아오기용 language값 넣기
		Map setMap = new HashMap();
		setMap.put("languageID", request.getParameter("languageID"));

		String filter = StringUtil.checkNull( request.getParameter("filter") , "" );
		
		setMap = new HashMap();
		Map getMap = new HashMap();
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		
		setMap = new HashMap();
		setMap.put("ModelID", StringUtil.checkNull(request.getParameter("subID"),request.getParameter("s_itemID") ));
		
		//setMap.put("s_itemID", request.getParameter("s_itemID") );
		setMap.put("s_itemID", StringUtil.checkNull(request.getParameter("subID"),request.getParameter("s_itemID") ));
		
	//	String modelID = StringUtil.checkNull(commonService.selectString("model_SQL.getTopModelID", setMap),"0"); 
		
		model.put("filter", filter );
	//	model.put("modelID", modelID );
		model.put("itemID", StringUtil.checkNull(request.getParameter("itemID"),""));
		
		
		String Url = "//app/olmv4/occMenu";
		
		String setID =  StringUtil.checkNull(request.getParameter("subID"),request.getParameter("s_itemID"));
		
		if(StringUtil.checkNull(request.getParameter("url"),"").equals("objectChildMenu")){
			//TB_ITEM_CLASS 의 HasCop, HasDemention 값 가져오기
			getMap = commonService.select("menu_SQL.tabCheck",setMap);
			model.put("tabCheck", getMap);
		}else if(StringUtil.checkNull(request.getParameter("url"),"").equals("processChildMenu")){
			//Occ테이블과 element테이블의 ObjectID 값 유무 확인
			
			setID =  StringUtil.checkNull(request.getParameter("subID"),"");
			getMap = commonService.select("menu_SQL.tabCheck",setMap);
			model.put("tabCheck", getMap);
			// TODO: CBO Master Program Status 화면 제어
			model.put("classCode", StringUtil.checkNull(request.getParameter("classCode"), ""));
		}
		
		//System.out.println("setID = "+setID);
		
		model.put("parentID", StringUtil.checkNull(request.getParameter("parentID"),"") );
		model.put("s_itemID", setID );
		model.put("subID", StringUtil.checkNull(request.getParameter("subID"),"")  );
		
		//minmap용
		model.put("getWidth", StringUtil.checkNull(request.getParameter("getWidth"),"0"));
		model.put("pop", StringUtil.checkNull(request.getParameter("pop"),""));
		
		//ArcCode
		model.put("option", StringUtil.checkNull( request.getParameter("option") ,""));
		//모델편집 속성팝업용 
		model.put("screenType", StringUtil.checkNull( request.getParameter("screenType"),"") );
		model.put("screenMode", StringUtil.checkNull( request.getParameter("screenType"),"") );
		model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode"),""));
		model.put("MTCategory", StringUtil.checkNull(request.getParameter("MTCategory"),""));
		model.put("ModelStatus", StringUtil.checkNull(request.getParameter("ModelStatus"),""));
		model.put("Creator", StringUtil.checkNull(request.getParameter("Creator"),""));
		model.put("CreationTime", StringUtil.checkNull(request.getParameter("CreationTime"),""));
		model.put("UserName", StringUtil.checkNull(request.getParameter("UserName"),""));
		model.put("LastUpdated", StringUtil.checkNull(request.getParameter("LastUpdated"),""));
		model.put("ModelStatusCode", StringUtil.checkNull(request.getParameter("ModelStatusCode"),"")); 
		model.put("ModelTypeName", StringUtil.checkNull(request.getParameter("ModelTypeName"),""));
		model.put("modelName", StringUtil.checkNull(request.getParameter("modelName"),""));	
		model.put("attrRevYN", StringUtil.checkNull(request.getParameter("attrRevYN"),""));	
		model.put("changeSetID", StringUtil.checkNull(request.getParameter("changeSetID"),""));	
		
		return nextUrl(Url);
	}
	
	@RequestMapping(value="/goFileMdlListV4.do")
	public String goFileMdlList(HttpServletRequest request, HttpServletResponse response, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		
		String url = "app/olmv4/fileMdlList";
		String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));	
		Map fileMap = new HashMap();
		String itemAthId = "";
		String Blocked = "";
		String LockOwner = "";
		try {
			fileMap.put("itemId", s_itemID);
			Map result  = fileMgtService.select("fileMgt_SQL.selectItemAuthorID",fileMap);
			String itemFileOption = fileMgtService.selectString("fileMgt_SQL.getFileOption",fileMap);
			if(result.get("AuthorID") != null){itemAthId = StringUtil.checkNull(result.get("AuthorID"));}
			if(result.get("Blocked") != null){Blocked = StringUtil.checkNull(result.get("Blocked"));}
			if(result.get("LockOwner") != null){LockOwner = StringUtil.checkNull(result.get("LockOwner"));}
			
			
						
//			String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
//			String sessionAuthLev = String.valueOf(cmmMap.get("sessionAuthLev"));
			
//			if (StringUtil.checkNull(result.get("AuthorID")).equals(sessionUserID)
//					|| StringUtil.checkNull(result.get("LockOwner")).equals(cmmMap.get("sessionUserId"))
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			model.put("myItem", myItem);
			
			fileMap.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			fileMap.put("s_itemID", s_itemID);
			List itemList = commonService.selectList("item_SQL.getCxnItemList", fileMap);
			
			String rltdItemId = "";
			for(int i = 0; i < itemList.size(); i++){
				Map itemInfo = (HashMap)itemList.get(i);
				if (i == 0) {
					rltdItemId += StringUtil.checkNull(itemInfo.get("ItemID"));
				}else{					
					rltdItemId += "," + StringUtil.checkNull(itemInfo.get("ItemID"));
				}
			}
			
			fileMap.put("rltdItemId", rltdItemId);
			fileMap.put("hideBlocked", "Y");
			fileMap.put("DocCategory", "ITM");
			fileMap.put("DocumentID", s_itemID);
			List fileList = commonService.selectList("fileMgt_SQL.getFile_gridList", fileMap);
			JSONArray fileData = new JSONArray(fileList);
			model.put("fileData",fileData);
			
			if(!rltdItemId.equals("")){rltdItemId += ","+s_itemID;}else{ rltdItemId = s_itemID;}
			model.put("itemFileOption", itemFileOption);			
			model.put("itemAthId", itemAthId);
			model.put("Blocked",Blocked);
			model.put("s_itemID", s_itemID);
			model.put("LockOwner", LockOwner);
			model.put("screenType", "model");
			model.put("menu", getLabel(request, commonService));
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/restApiGridList.do")
	public String restApiGridList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
				//http://sfolm.iptime.org:8091/odata/itemList$format=json
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/app/olmv4/restApiGridList");
	}
	
//	@RequestMapping(value="/getRestApiDataDhtmlx.do")
//	public void getRestApiDataDhtmlx(HashMap cmmMap, HttpServletResponse response) throws Exception{
//		String restApiUrl = "https://snippet.dhtmlx.com/codebase/data/grid/01/dataset.json";
//		//String restApiUrl = "http://sfolm.iptime.org:8091/odata/itemList";
//		try {
//			URL url = new URL(restApiUrl);
//			HttpURLConnection con = (HttpURLConnection) url.openConnection(); 
//			con.setConnectTimeout(5000); //서버에 연결되는 Timeout 시간 설정
//			con.setReadTimeout(5000); // InputStream 읽어 오는 Timeout 시간 설정
//			con.addRequestProperty("x-api-key", ""); //key값 설정
//
//			con.setRequestMethod("GET");
//			con.setDoOutput(false); 
//
//			StringBuilder sb = new StringBuilder();
//			System.out.println("con.getResponseCode()  :"+con.getResponseCode()+", HttpURLConnection.HTTP_OK:"+HttpURLConnection.HTTP_OK );
//			if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
//				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
//				String line;
//				while ((line = br.readLine()) != null) {
//					sb.append(line).append("\n");
//				}
//				br.close();
//				System.out.println("결과 : " + sb.toString());
//				
//				response.setHeader("Cache-Control", "no-cache");
//				response.setContentType("text/plain");
//				response.setCharacterEncoding("UTF-8");
//				response.getWriter().print(sb.toString());
//			} else {
//				PrintWriter pw = response.getWriter();
//				pw.write("데이터가 존재하지 않습니다.");
//				System.out.println(con.getResponseMessage());
//			}
//		}
//		catch(Exception e) {}
//	}
	
//	@RequestMapping(value="/getRestApiData.do")
//	public void getRestApiData(HashMap cmmMap, HttpServletResponse response) throws Exception{
//		String restApiUrl = "http://sfolm.iptime.org:8081/odata/itemList?$format=json";
//		//  String restApiUrl= "http://ab4.ucc.uwm.edu/sap/opu/odata/sap/ZZ_SFOLM_ODATA_V4_PROJECT_SRV/ZSFTABLE01Set?$format=json";
//		HttpURLConnection conn = null;
//	    JSONObject responseJson = null;	    
//	    try {
//	        
//	        URL url = new URL(restApiUrl);
//	        conn = (HttpURLConnection) url.openConnection();
//	        conn.setConnectTimeout(10000); // 10초 동안 응답이 없으면 종료 
//	        conn.setRequestMethod("GET");
//	        // conn.setRequestProperty("X-Auth-Token", "");
//	        conn.setRequestProperty("Content-Type", "application/json");
//	        conn.setDoOutput(true);
//	  
//	        
//	        int responseCode = conn.getResponseCode();
//	        System.out.println("responseCode: "+responseCode);
//	        if (responseCode == 400) {
//	            System.out.println("400:: 해당 명령을 실행할 수 없음 ");
//	        } else if (responseCode == 401) {
//	            System.out.println("401:: X-Auth-Token Header가 잘못됨");
//	        } else if (responseCode == 500) {
//	            System.out.println("500:: 서버 에러, 문의 필요");
//	        } else if (responseCode == conn.HTTP_OK){ // 성공(200)
//	            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
//	            StringBuilder sb = new StringBuilder();
//	            String line = "";
//	            while ((line = br.readLine()) != null) {
//	                sb.append(line);
//	            }
//	            
//	            responseJson = new JSONObject(sb.toString());    
//	            System.out.println("responseJson :"+responseJson);
//	            System.out.println("responseJson :"+responseJson.get("value"));
//	            
//	            response.setHeader("Cache-Control", "no-cache");
//				response.setContentType("text/plain");
//				response.setCharacterEncoding("UTF-8");
//				response.getWriter().print(responseJson.get("value"));
//	        }
//	    }
//		catch(Exception e) {}
//	}
	
	@RequestMapping(value = "/dhtmlxV7TreeMgt.do")
	public String dhtmlxV7TreeMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/app/olmv4/dhtmlxV7TreeMgt");
	}
	
	@RequestMapping(value = "/jsonDhtmlxTreeListV7.do")
	public void jsonDhtmlxTreeListV7(HashMap cmmMap, HttpServletResponse response)  throws Exception {
		try {
			//String SQL_CODE=StringUtil.checkNull(commonService.selectString("menu_SQL.getMenuTreeSqlName", cmmMap) ,"commonCode");
			String SQL_CODE = "menuTreeListNoFilter_treeList";
			
			String tFilterCode = StringUtil.checkNull(cmmMap.get("tFilterCode"));
			
			if(!"".equals(tFilterCode)) {
				SQL_CODE=StringUtil.checkNull(commonService.selectString("menu_SQL.getSqlNameForTfilterCode", cmmMap));
			}
			List <Map>result = commonService.selectList("menu_SQL." + SQL_CODE, cmmMap);
			
			String [] cols = ((String)cmmMap.get("cols")).split("[|]");

			returnTreeJsonV7(result, cols, response, (String)cmmMap.get("contextPath"));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		
	}
	public static void returnTreeJsonV7(List list, final String[]cols, HttpServletResponse res, final String contextPath){
		sendToJsonV7(parseTreeJsonV7(list, cols,contextPath), res);
	}
	
	public static void sendToJsonV7(String jObj, HttpServletResponse res) {
		try {
			res.setHeader("Cache-Control", "no-cache");
			res.setContentType("text/plain");
			res.setCharacterEncoding("UTF-8");
			if(!jObj.equals("{rows: [ ]}")){
				res.getWriter().print(jObj);
			}
			else {
				PrintWriter pw = res.getWriter();
				pw.write("데이터가 존재하지 않습니다.");
			}

			System.out.println("json Object :"+jObj);
			
		} catch (IOException e) {
			MessageHandler.getMessage("json.send.message");
			e.printStackTrace();
		}
	}
	
	public static String parseTreeJsonV7(List list, final String[]cols, final String contextPath) {
		final String OPEN = "[";
		final String COT = "\"";
		final String COMMA = ",";
		final String CLOSE = "]";
		final String BOPEN = "{";
		final String BClOSE = "}";
		final String COL = ":";

		StringBuffer result = new StringBuffer();

		if (list != null && list.size()>0 && cols != null && cols.length > 0) {
			result.append(OPEN);
			for (int i = 0; i < list.size(); i++) {
				if (i != 0) {
					result.append(COMMA);
				}
				Map map = (Map) list.get(i);
				result.append(BOPEN);
				int j=0;
				for (String string : cols) {
					if (j>0 && !StringUtil.checkNull(map.get(string)).equals("0")) {
						result.append(COMMA);
					}
					if(!StringUtil.checkNull(map.get(string)).equals("0")) {
						result.append(COT).append(string).append(COT).append(COL);
						result.append(COT).append(get(map.get(string), contextPath)).append(COT);
						j++;
					}
				}
				result.append(BClOSE);
			}
			result.append(CLOSE);
		}

		//System.out.println("V7 result.toString() :"+result.toString());
		return result.toString().replaceAll("PRE_TREE_ID", "parent").replaceAll("TREE_ID", "id").replaceAll("TREE_NM", "value");
	}
	
	private final static String IMG_NEW_SRC = "@{new}";
	private final static String IMG_NEW_TARGET_OPEN = "<img src='";
	private final static String IMG_NEW_TARGET_CLOSE = "/images/btn_star.gif' width='13' height='13' />";
	
	/**
	 * 엔터를 <br/>로 변환한다.
	 * @param object
	 * @return
	 */
	private static Object get(Object object, final String contextPath) {
		if(object == null) {
			return "";
		}
		if(object instanceof java.lang.String) {
			String result = StringUtil.replace((String)object, "\n", "<br/>");
			result = StringUtil.replace(result, IMG_NEW_SRC, IMG_NEW_TARGET_OPEN+contextPath + IMG_NEW_TARGET_CLOSE);
			result = StringUtil.replace(result, "\r", "<br/>");
			if(result.indexOf('"')!=-1) {
				result = StringUtil.replace(result, "\"", "＂");
			}
			if(result.indexOf('\\')!=-1) {
				result = StringUtil.replace(result, "\\", "/");
			}
			return result;
		}
		return object;
	}
	
	@RequestMapping(value="/itemMgtV7.do")
	public String itemMgtV7(HttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception{
		String url = "/itm/structure/itemMgtV7";
		try{
				String arcCode =  StringUtil.checkNull(cmmMap.get("arcCode"),"");
				String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
				String unfold = StringUtil.checkNull(cmmMap.get("unfold"));
				String arcDefPage = StringUtil.checkNull(cmmMap.get("arcDefPage"));
				String pageUrl = StringUtil.checkNull(cmmMap.get("pageUrl"));
				String nodeID = StringUtil.checkNull(cmmMap.get("nodeID"));
				String defMenuItemID = StringUtil.checkNull(cmmMap.get("defMenuItemID"));
				String defDimTypeID = StringUtil.checkNull(cmmMap.get("defDimTypeID"));
				String defDimValueID = StringUtil.checkNull(cmmMap.get("defDimValueID"));
				String loadType = StringUtil.checkNull(cmmMap.get("loadType"));
				String tLink = StringUtil.checkNull(cmmMap.get("tLink"));
				String linkNodeID = StringUtil.checkNull(cmmMap.get("linkNodeID"));
				
				if(!linkNodeID.equals("")){ //Item Link Templet view linkID 가 있으면 nodeID로 setting
					nodeID = linkNodeID;
				}
				
				Map setData = new HashMap();
				setData.put("itemID", nodeID);
				String itemClassMenuURL = StringUtil.checkNull(commonService.selectString("menu_SQL.getItemClassMenuURL", setData));
				
				setData.put("arcCode", arcCode);
				Map arcMenuInfo = commonService.select("menu_SQL.getArcInfo", setData);
				String strType = "";
				if(arcMenuInfo != null && !arcMenuInfo.isEmpty()){ 
					menuStyle = StringUtil.checkNull(arcMenuInfo.get("MenuStyle"),"");
					strType = StringUtil.checkNull(arcMenuInfo.get("StrType"),"");
				}
				model.put("strType", strType);				
				model.put("sortOption", arcMenuInfo.get("SortOption"));
				model.put("arcCode", arcCode);
				model.put("menuStyle", menuStyle);
				model.put("defMenuItemID", defMenuItemID);
				model.put("unfold", unfold);
				model.put("arcDefPage", arcDefPage);
				model.put("pageUrl", pageUrl);
				model.put("nodeID", nodeID);
				model.put("itemClassMenuURL", itemClassMenuURL);
				model.put("varFilter", arcMenuInfo.get("VarFilter"));
				model.put("arcVarFilter", arcMenuInfo.get("VarFilter"));
				model.put("showTOJ", StringUtil.checkNull(cmmMap.get("showTOJ")));
				model.put("accMode", StringUtil.checkNull(cmmMap.get("accMode")));
				model.put("showVAR", StringUtil.checkNull(cmmMap.get("showVAR")));
				model.put("defDimTypeID", defDimTypeID);
				model.put("defDimValueID", defDimValueID);
				
				model.put("loadType", loadType);
				model.put("tLink", tLink);
				if(loadType.equals("multi")){
					setData = new HashMap();
					setData.put("subArcCode", arcCode);
					setData.put("languageID", cmmMap.get("sessionCurrLangType"));
					List arcList = commonService.selectList("menu_SQL.getArcInfo", setData);
					model.put("arcList", arcList);
				}
				model.put("popupUrl",StringUtil.checkNull(cmmMap.get("popupUrl")));
				model.put("pWidth",StringUtil.checkNull(cmmMap.get("pWidth"),"850"));
				model.put("pHeight",StringUtil.checkNull(cmmMap.get("pHeight"),"700"));
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl(url);
	}

	@RequestMapping(value="/dhtmlxV7LayoutAttachTree.do")
	public String dhtmlxV7LayoutAttachTree(HttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception{
		String url ="app/olmv4/dhtmlxV7LayoutAttachTree";
		
		try{
				String arcCode =  StringUtil.checkNull(cmmMap.get("arcCode"),"");
				String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
				String unfold = StringUtil.checkNull(cmmMap.get("unfold"));
				String arcDefPage = StringUtil.checkNull(cmmMap.get("arcDefPage"));
				String pageUrl = StringUtil.checkNull(cmmMap.get("pageUrl"));
				String nodeID = StringUtil.checkNull(cmmMap.get("nodeID"));
				String defMenuItemID = StringUtil.checkNull(cmmMap.get("defMenuItemID"));
				String defDimTypeID = StringUtil.checkNull(cmmMap.get("defDimTypeID"));
				String defDimValueID = StringUtil.checkNull(cmmMap.get("defDimValueID"));
				String loadType = StringUtil.checkNull(cmmMap.get("loadType"));
				String tLink = StringUtil.checkNull(cmmMap.get("tLink"));
				String linkNodeID = StringUtil.checkNull(cmmMap.get("linkNodeID"));
				
				if(!linkNodeID.equals("")){ //Item Link Templet view linkID 가 있으면 nodeID로 setting
					nodeID = linkNodeID;
				}
				
				Map setData = new HashMap();
				setData.put("itemID", nodeID);
				String itemClassMenuURL = StringUtil.checkNull(commonService.selectString("menu_SQL.getItemClassMenuURL", setData));
				
				setData.put("arcCode", arcCode);
				Map arcMenuInfo = commonService.select("menu_SQL.getArcInfo", setData);
				String strType = "";
				if(arcMenuInfo != null && !arcMenuInfo.isEmpty()){ 
					menuStyle = StringUtil.checkNull(arcMenuInfo.get("MenuStyle"),"");
					strType = StringUtil.checkNull(arcMenuInfo.get("StrType"),"");
				}
				model.put("strType", strType);				
				model.put("sortOption", arcMenuInfo.get("SortOption"));
				model.put("arcCode", arcCode);
				model.put("menuStyle", menuStyle);
				model.put("defMenuItemID", defMenuItemID);
				model.put("unfold", unfold);
				model.put("arcDefPage", arcDefPage);
				model.put("pageUrl", pageUrl);
				model.put("nodeID", nodeID);
				model.put("itemClassMenuURL", itemClassMenuURL);
				model.put("varFilter", arcMenuInfo.get("VarFilter"));
				model.put("arcVarFilter", arcMenuInfo.get("VarFilter"));
				model.put("showTOJ", StringUtil.checkNull(cmmMap.get("showTOJ")));
				model.put("accMode", StringUtil.checkNull(cmmMap.get("accMode")));
				model.put("showVAR", StringUtil.checkNull(cmmMap.get("showVAR")));
				model.put("defDimTypeID", defDimTypeID);
				model.put("defDimValueID", defDimValueID);
				
				model.put("loadType", loadType);
				model.put("tLink", tLink);
				if(loadType.equals("multi")){
					setData = new HashMap();
					setData.put("subArcCode", arcCode);
					setData.put("languageID", cmmMap.get("sessionCurrLangType"));
					List arcList = commonService.selectList("menu_SQL.getArcInfo", setData);
					model.put("arcList", arcList);
				}
				model.put("popupUrl",StringUtil.checkNull(cmmMap.get("popupUrl")));
				model.put("pWidth",StringUtil.checkNull(cmmMap.get("pWidth"),"850"));
				model.put("pHeight",StringUtil.checkNull(cmmMap.get("pHeight"),"700"));
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/dhtmlxV7TreeGrid.do")
	public String dhtmlxV7TreeGrid(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			cmmMap.put("DimTypeID", cmmMap.get("dimTypeID"));
			List dimValueNmList = (List) commonService.selectList("dim_SQL.getDimValueList", cmmMap);
			
			String treegridHeader = "";
			String cols = "";
			for(int i=0;i<dimValueNmList.size();i++) {
				Map temp = (Map)dimValueNmList.get(i);
				if(i > 0) {
					treegridHeader += "{width:100, id:"+StringUtil.checkNull(temp.get("CODE"))+", type:\"string\", header:[{text:\""+StringUtil.checkNull(temp.get("NAME"))+"\"}] },";
					cols += "|"+StringUtil.checkNull(temp.get("CODE"));
				}
				else {
					treegridHeader = "{width:100, id:"+StringUtil.checkNull(temp.get("CODE"))+", type:\"string\", header:[{text:\""+StringUtil.checkNull(temp.get("NAME"))+"\"}] },";
					cols = "|"+StringUtil.checkNull(temp.get("CODE"));
				}
			}
			
			model.put("treegridHeader", treegridHeader);
			model.put("dimcols", cols);
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/app/olmv4/dhtmlxV7TreeGrid");
	}
	
	@RequestMapping(value="/getDhtmlV7ItemTreeListByDim.do")
	public void getDhtmlV7ItemTreeListByDim( Map cmmMap, HttpServletResponse response ) throws Exception {
		Map setMap = new HashMap();
		try {
			//List treeRootItemData = new ArrayList();
			List itemTreeListByDimList = new ArrayList();
			List fromItemIdList = new ArrayList();
			List dimValueList = new ArrayList();
			List dimValueNmList = new ArrayList();			
			String rootItemID = StringUtil.checkNull(cmmMap.get("rootItemID"));	
			String rootClassCode = StringUtil.checkNull(cmmMap.get("rootClassCode"));	
			String dimTypeID = StringUtil.checkNull(cmmMap.get("dimTypeID"));	
			String cxnTypeCode = StringUtil.checkNull(cmmMap.get("cxnTypeCode"));	
			String selectedDimClass = StringUtil.checkNull(cmmMap.get("selectedDimClass"));	
			
			int maxTreeLevel = Integer.parseInt(StringUtil.checkNull(cmmMap.get("maxTreeLevel")));	
		
			setMap.put("dimTypeID",dimTypeID);
			setMap.put("rootItemID", rootItemID);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));			
			setMap.put("itemTypeCode", cxnTypeCode);
			setMap.put("classCode", rootClassCode);

			/* Get RootItem Data */
			List <Map>treeRootItemData =commonService.selectList("report_SQL.getTreeRootItem", setMap);
						
			for (int i=0; treeRootItemData.size()>i ; i++ ) {
				Map tempMap0 = (Map) treeRootItemData.get(i);
				rootItemID = String.valueOf(tempMap0.get("ItemID"));
				setMap.put("ItemTypeCode", tempMap0.get("ItemTypeCode"));
				setMap.put("classCode", tempMap0.get("Level"));
			}
			
			/* FromItemIdList Setting */
			Map tempMap1 = new HashMap();
			tempMap1.put("ToItemID", rootItemID);
			fromItemIdList.add(tempMap1);
			
			/* Get ChildItem Data */
			for(int i=1; i<maxTreeLevel; i++){	
				if(0<fromItemIdList.size()){
					setMap.put("FromItemIdList", fromItemIdList);
					setMap.put("treeLevel", i);
					List <Map>treetItemData =commonService.selectList("report_SQL.getItemTreeListByDimList", setMap);
					itemTreeListByDimList.add(treetItemData);
					fromItemIdList = (List) commonService.selectList("report_SQL.getItemTreeListByDimFromItemId", setMap);					
				}
			}
			
			/* Get DimValue Data */
			dimValueList = (List) commonService.selectList("dim_SQL.getDimValueNameList", setMap);
			
			cmmMap.put("DimTypeID", dimTypeID);
			dimValueNmList = (List) commonService.selectList("dim_SQL.getDimValueList", cmmMap);
			
			String [] cols = ((String)cmmMap.get("cols")).split("[|]");
			
			for(int j=0; j<itemTreeListByDimList.size(); j++) {
				List itemTreeList = (List)itemTreeListByDimList.get(j);
				for(int i=0; i<itemTreeList.size(); i++) {
					Map itemMap = (Map)itemTreeList.get(i);
					
					treeRootItemData.add(itemMap);
				}
			}
			
			for(int i=0; treeRootItemData.size()>i; i++) {
				Map treeDataInfo = (Map)treeRootItemData.get(i);
				String dimValueIDs[] = StringUtil.checkNull(treeDataInfo.get("DimValueID")).split(",");
				String classCode = StringUtil.checkNull(treeDataInfo.get("Level"));
				for(int l4d=0; l4d < dimValueList.size(); l4d++) {
					Map tempDimValue = (Map)dimValueList.get(l4d);
					for (String DimValueID : dimValueIDs) {
						
						if(tempDimValue.get("DimValueID").equals(DimValueID) && classCode.equals(selectedDimClass)){ 
							treeDataInfo.put(tempDimValue.get("DimValueID"), "O");
						}else {
							if(!StringUtil.checkNull(treeDataInfo.get(tempDimValue.get("DimValueID"))).equals("O")){
								treeDataInfo.put(tempDimValue.get("DimValueID"), " ");
							}
						}
					}
				}
			}
			
			returnTreeGridJsonV7(treeRootItemData, cols, response, (String)cmmMap.get("contextPath"));
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
	
	public static void returnTreeGridJsonV7(List list, final String[]cols, HttpServletResponse res, final String contextPath){
		sendToJsonV7(parseTreeGridJsonV7(list, cols,contextPath), res);
	}
	
	public static String parseTreeGridJsonV7(List list, final String[]cols, final String contextPath) {
		final String OPEN = "[";
		final String COT = "\"";
		final String COMMA = ",";
		final String CLOSE = "]";
		final String BOPEN = "{";
		final String BClOSE = "}";
		final String COL = ":";

		StringBuffer result = new StringBuffer();
		
		if (list != null && list.size()>0 && cols != null && cols.length > 0) {
			result.append(OPEN);
			for (int i = 0; i < list.size(); i++) {
				if (i != 0) {
					result.append(COMMA);
				}
				Map map = (Map) list.get(i);
				result.append(BOPEN);
				int j=0;
				for (String string : cols) {
					if (j>0 && !StringUtil.checkNull(map.get(string)).equals("") && !StringUtil.checkNull(map.get(string)).equals("1") ) {
						result.append(COMMA);
					}
					
					if( !StringUtil.checkNull(map.get(string)).equals("") && !StringUtil.checkNull(map.get(string)).equals("1") ) {
						result.append(COT).append(string).append(COT).append(COL);
						if(string.equals("TREE_NM")) {
							result.append(COT).append("<img src=/cmm/common/images/item/img_process.png>"+get(map.get(string), contextPath)).append(COT);
						} else {
							result.append(COT).append(get(map.get(string), contextPath)).append(COT);
						}
						j++;
					}
				}
				result.append(BClOSE);
			}
			result.append(CLOSE);
		}

		// System.out.println("V7 result.toString() 1111 :"+result.toString().replaceAll("PRE_TREE_ID","parent").replaceAll("TREE_ID", "id").replaceAll("TREE_NM","value").replaceAll("PRE_id","parent").replaceAll(",,",","));
		
		String resultData = result.toString().replaceAll("PREE_TREE_ID","parent").replaceAll("TREE_ID", "id").replaceAll("TREE_NM","value").replaceAll("PRE_id","parent").replaceAll(",,",",");
		return resultData;
	}
	
	@RequestMapping(value="/srDashboardV4.do")
	public String srDashboard(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws ExceptionUtil {
		String url = "/app/olmv4/srDashboard";
		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),request.getParameter("languageID")); 
			String srType = StringUtil.checkNull(request.getParameter("srType"), "ITSP"); 
			
			setMap.put("languageID",languageID);
			setMap.put("srType",srType);
			
			List srReceiptTeamList = commonService.selectList("esm_SQL.getESMSRReceiptTeamID", setMap);
			JSONArray srReceiptTeam = new JSONArray(srReceiptTeamList);
			model.put("srReceiptTeam",srReceiptTeam);
			
			List srArea1List = commonService.selectList("common_SQL.getSrArea1_commonSelect", setMap);
			JSONArray srArea1 = new JSONArray(srArea1List);
			model.put("srArea1",srArea1);
			
			List crReceiptTeamList = commonService.selectList("common_SQL.getCRReceiptTeamID_commonSelect", setMap);
			JSONArray crReceiptTeam = new JSONArray(crReceiptTeamList);
			model.put("crReceiptTeam",crReceiptTeam);
			
			setMap.put("level","1");
			List categoryList = commonService.selectList("esm_SQL.getESMSRCategory", setMap);
			JSONArray category = new JSONArray(categoryList);
			model.put("category",category);
			
			model.put("srType", srType);
			model.put("menu", getLabel(request, commonService)); // Label Setting
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);		
	}
	
	@RequestMapping(value="/srDashboardChartListV4.do")
	public String srDashboardChartListV4(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws ExceptionUtil {
		String url = "/app/olmv4/srDashboardChartList";
		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),request.getParameter("languageID")); 
			String srType = StringUtil.checkNull(request.getParameter("srType"), "ITSP"); 
			
			setMap.put("languageID",languageID);
			setMap.put("srArea1",StringUtil.checkNull(request.getParameter("srArea1")));
			setMap.put("srArea2",StringUtil.checkNull(request.getParameter("srArea2")));
			setMap.put("regStartDate",StringUtil.checkNull(request.getParameter("regStartDate")));
			setMap.put("regEndDate",StringUtil.checkNull(request.getParameter("regEndDate")));
			setMap.put("srDueStartDate",StringUtil.checkNull(request.getParameter("srDueStartDate")));
			setMap.put("srDueEndDate",StringUtil.checkNull(request.getParameter("srDueEndDate")));
			setMap.put("crDueStartDate",StringUtil.checkNull(request.getParameter("crDueStartDate")));
			setMap.put("crDueEndDate",StringUtil.checkNull(request.getParameter("crDueEndDate")));
			setMap.put("category",StringUtil.checkNull(request.getParameter("category")));
			setMap.put("subCategory",StringUtil.checkNull(request.getParameter("subCategory")));
			setMap.put("srReceiptTeam",StringUtil.checkNull(request.getParameter("srReceiptTeam")));
			setMap.put("crReceiptTeam",StringUtil.checkNull(request.getParameter("crReceiptTeam")));
			setMap.put("srType",StringUtil.checkNull(request.getParameter("srType")));
			
			List chart = commonService.selectList("analysis_SQL.getBISRCntList_chart", setMap);
			JSONArray chartData = new JSONArray(chart);
			model.put("chartData",chartData);
			
			List grid = commonService.selectList("analysis_SQL.getBISRCntList_gridList", setMap);
			JSONArray gridData = new JSONArray(grid);
			model.put("gridData",gridData);
			
			setMap.remove("category");
			setMap.remove("subCategory");
			setMap.remove("srReceiptTeam");
			setMap.remove("crReceiptTeam");
			setMap.put("stSRDueDate", StringUtil.checkNull(request.getParameter("srDueStartDate")));
			setMap.put("endSRDueDate", StringUtil.checkNull(request.getParameter("srDueEndDate")));
     		setMap.put("stCRDueDate", StringUtil.checkNull(request.getParameter("crDueStartDate")));
     		setMap.put("endCRDueDate", StringUtil.checkNull(request.getParameter("crDueEndDate")));
     		List subGridList = commonService.selectList("esm_SQL.getEsrMSTList_gridList", cmmMap);
     		JSONArray subGridData = new JSONArray(subGridList);
			model.put("subGridData",subGridData);
			
			model.put("srType",srType);
			model.put("menu", getLabel(request, commonService)); // Label Setting
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);		
	}

	@RequestMapping(value="/srStatisticsV4.do")
	public String srStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		Map setMap = new HashMap();
		List projectList = new ArrayList();
		try {
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"),request.getParameter("languageID"));
			
			setMap.put("languageID", languageID);
			setMap.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ITSP"));
			setMap.put("itemClassCode", "CL03004");
	     	List srStatList = commonService.selectList("esm_SQL.getSRStatusList", setMap);
	     	
	     	JSONArray statusList = new JSONArray(srStatList);
			model.put("statusList",statusList);
			
			setMap.put("level", "1");
	        
	     	List srCatListLv1 = commonService.selectList("esm_SQL.getESMSRCategory", setMap);
	     	
	     	String srCntTtl = "";
	     	String srCnt = "";
	     	String cngtTtl = "";
	     	List countResultList = new ArrayList();
	     	List spanList = new ArrayList();
			for (int i = 0; i < srCatListLv1.size(); i++) {
		     	Map spanMap = new HashMap();
	     		Map maplv1 = (Map) srCatListLv1.get(i);
	     		String srCatLv1_CD = String.valueOf(maplv1.get("CODE"));        	
	        	String srCatLv1_NM = String.valueOf(maplv1.get("NAME"));
	        	commandMap.remove("parentID");     			
	        	commandMap.put("parentID", maplv1.get("CODE"));
	        	commandMap.put("srType", StringUtil.checkNull(request.getParameter("srType"), "ITSP"));
	     		
	     		// SR Category lv2 Row
	     		List srCatListLv2 = commonService.selectList("esm_SQL.getESMSRCategory", commandMap);
	     		for (int j = 0; j < srCatListLv2.size(); j++) {
	     			Map rowMap = new HashMap();
		        	Map maplv2 = (Map) srCatListLv2.get(j);
		        	String srCatLv2_CD = String.valueOf(maplv2.get("CODE"));        	
		        	String srCatLv2_NM = String.valueOf(maplv2.get("NAME"));
		        	
		        	commandMap.remove("status");
		        	commandMap.remove("srCatID");
		        	commandMap.put("srCatID", srCatLv2_CD);
		        	srCntTtl = commonService.selectString("analysis_SQL.getCountOfSR", commandMap);   // [Sub Category/Status] total
		        	
		        	// row add
		        	if(j == 0) rowMap.put("id", srCatLv1_CD);
		        	rowMap.put("num", Integer.toString(j));
		        	rowMap.put("srCatLv1_NM", srCatLv1_NM);	// col1 : SR Category Name
		        	rowMap.put("srCatLv2_NM", srCatLv2_NM);	// col2 : SR Sub Category Name
		        	rowMap.put("statusCnt", srCntTtl);		// col9 : Total by Sub Category
		        	
		        	
		        	// SR Status Column add
		        	for (int k = 0; k < srStatList.size(); k++) {
		        		Map satusMap = (Map) srStatList.get(k);
		        		String statusId = String.valueOf(satusMap.get("CODE"));
		        		
		        		commandMap.remove("status");
		        		commandMap.put("status", statusId);
		        		srCnt = commonService.selectString("analysis_SQL.getCountOfSR", commandMap);
		        		rowMap.put(statusId, srCnt); 		// col3 ~ col8  : value by Status
		        	}
		        	countResultList.add(rowMap);
		        	
		        	
	     		}
	     		
	     		// SubCategory Not Allocation row add start 
	     		Map rowMap = new HashMap();
		 		commandMap.remove("status");
		    	commandMap.remove("srCatID");
		    	commandMap.remove("parentID");
		    	commandMap.put("parentID", srCatLv1_CD);
		    	commandMap.put("subCatNA", "NA");
		    	srCntTtl = commonService.selectString("analysis_SQL.getCountOfSR", commandMap);  // [Category/Status] total
		    	
		    	// Column add
		    	rowMap.put("srCatLv1_NM", srCatLv1_NM);		// col1 : SR Category Name
		    	rowMap.put("srCatLv2_NM", "N/A");	// col1 : SR Sub Category Name
		    	rowMap.put("statusCnt", srCntTtl);			// col9 : Total by Sub Category
		    	
		    	// SR Status Column add
	        	for (int k = 0; k < srStatList.size(); k++) {
	        		Map satusMap = (Map) srStatList.get(k);
	        		String statusId = String.valueOf(satusMap.get("CODE"));
	        		
	        		commandMap.remove("status");
	        		commandMap.put("status", statusId);
	        		srCnt = commonService.selectString("analysis_SQL.getCountOfSR", commandMap);
	        		rowMap.put(statusId, srCnt);			 // col3 ~ col8  : value by Status
	        	}
	        	countResultList.add(rowMap);
	        	
	     		// SubTotal row add start 
	     		rowMap = new HashMap<String, String>();
		 		commandMap.remove("status");
		    	commandMap.remove("srCatID");
		    	commandMap.remove("parentID");
		    	commandMap.remove("subCatNA");
		    	commandMap.put("parentID", srCatLv1_CD);
		    	srCntTtl = commonService.selectString("analysis_SQL.getCountOfSR", commandMap);  // [Category/Status] total
		    	
		    	// Column add
		    	rowMap.put("srCatLv1_NM", srCatLv1_NM);		// col1 : SR Category Name
		    	rowMap.put("srCatLv2_NM", "Sub Total");	// col1 : SR Sub Category Name
		    	rowMap.put("statusCnt", srCntTtl);			// col9 : Total by Sub Category
		    	
		    	// SR Status Column add
	        	for (int k = 0; k < srStatList.size(); k++) {
	        		Map satusMap = (Map) srStatList.get(k);
	        		String statusId = String.valueOf(satusMap.get("CODE"));
	        		
	        		commandMap.remove("status");
	        		commandMap.put("status", statusId);
	        		srCnt = commonService.selectString("analysis_SQL.getCountOfSR", commandMap);
	        		rowMap.put(statusId, srCnt);			 // col3 ~ col8  : value by Status
	        	}
	        	countResultList.add(rowMap);
	        	
	        	spanMap.put("row", srCatLv1_CD);
	        	spanMap.put("column", "srCatLv1_NM");
	        	spanMap.put("rowspan", srCatListLv2.size()+2);
	        	spanList.add(spanMap);
	        }
			
			// Footer Total
	    	Map rowMap = new HashMap();
	    	rowMap.put("id","Total");
	    	rowMap.put("custom",true);
	    	rowMap.put("srCatLv1_NM","Total");
		    for (int i = 0; i < srStatList.size(); i++) {
	    		Map statusMap = (Map) srStatList.get(i);
	    		String statusCode = String.valueOf(statusMap.get("CODE"));
	    		
	    		setMap.put("status", statusCode);
	    		cngtTtl = commonService.selectString("analysis_SQL.getCountOfSR", setMap);
	    		rowMap.put(statusCode, cngtTtl);
	        } 
		    
		    setMap.remove("status");
		    cngtTtl = commonService.selectString("analysis_SQL.getCountOfSR", setMap);
		    rowMap.put("statusCnt", cngtTtl);
		    countResultList.add(rowMap);
		    
	     	Map spanMap = new HashMap();
		    spanMap.put("row", "Total");
        	spanMap.put("column", "srCatLv1_NM");
        	spanMap.put("colspan", 2);
        	spanList.add(spanMap);
		    
			JSONArray result = new JSONArray(countResultList);
			model.put("result",result);
			
			JSONArray spanData = new JSONArray(spanList);
			model.put("spanData",spanData);
			
		}
		catch (Exception e) {
			System.out.println(e.getMessage());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/app/olmv4/srStatistics");
	}
	
	@RequestMapping(value = "/dhtmlxV7BarChart.do")
	public String dhtmlxV7BarChart(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				cmmMap.put("classCode", "CL01006");
				List processList = commonService.selectList("main_SQL.processSttBar_chart", cmmMap);
				
				JSONArray processListJson = new JSONArray(processList);
				System.out.println("processList :"+processList);
				System.out.println("processListJson :"+processListJson);
				
				model.put("processData", processListJson);
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/app/olmv4/dhtmlxV7BarChart");
	}
	
	@RequestMapping(value = "/dhtmlxV7PieChart.do")
	public String dhtmlxV7PieChart(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				cmmMap.put("ClassCode", "CL01005");
				List processList = commonService.selectList("main_SQL.processStt_chart", cmmMap);
				
				String colors[] = "#394E79,#5E83BA,#C2D2E9,#647B37,#98A468,#F0D0A9,#EEB98E,#9A8BA5".split(",");
				
				for(int i=0; i<processList.size(); i++) {
					Map processInfo = (Map)processList.get(i);
					processInfo.put("color", colors[i]);
				}
				
				JSONArray processListJson = new JSONArray(processList);
				System.out.println("processList :"+processList);
				System.out.println("processListJson :"+processListJson);
				
				model.put("processData", processListJson);
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/app/olmv4/dhtmlxV7PieChart");
	}
	
	@RequestMapping(value = "/dhtmlxV7LineChart.do")
	public String dhtmlxV7LineChart(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			cmmMap.put("classCode", "CL01006");
			List processList = commonService.selectList("main_SQL.processSttBar_chart", cmmMap);
			
			JSONArray processListJson = new JSONArray(processList);
			System.out.println("processList :"+processList);
			System.out.println("processListJson :"+processListJson);
			
			model.put("processData", processListJson);
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/app/olmv4/dhtmlxV7LineChart");
	}
	
	@RequestMapping(value = "/dhtmlxV7ScatterChart.do")
	public String dhtmlxV7ScatterChart(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			cmmMap.put("classCode", "CL01006");
			List processList = commonService.selectList("main_SQL.processSttBar_chart", cmmMap);
			
			JSONArray processListJson = new JSONArray(processList);
			System.out.println("processList :"+processList);
			System.out.println("processListJson :"+processListJson);
			
			model.put("processData", processListJson);
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/app/olmv4/dhtmlxV7ScatterChart");
	}
	
	@RequestMapping(value = "/getChartData.do")
	public void getChartData(HttpServletRequest request, HashMap cmmMap, HttpServletResponse res) throws Exception {
		try {
			cmmMap.put("classCode", "CL01006");
			List processList = commonService.selectList("main_SQL.processSttBar_chart", cmmMap);
			
			JSONArray processListJson = new JSONArray(processList);
						
			res.setHeader("Cache-Control", "no-cache");
			res.setContentType("text/plain");
			res.setCharacterEncoding("UTF-8");
			if(!StringUtil.checkNull(processListJson).equals("")){
				res.getWriter().print(processListJson);
			}
			else {
				PrintWriter pw = res.getWriter();
				pw.write("데이터가 존재하지 않습니다.");
			}

			System.out.println("json processListJson :"+processListJson);
			
		} catch (IOException e) {
			MessageHandler.getMessage("json.send.message");
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="/dhtmlxDiagramFlowChart.do")
	public String dhtmlxDiagramFlowChart(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url="app/olmv4/dhtmlxDiagramFlowChart";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			Map setData = new HashMap();
			String modelID = "900879";
			setData.put("modelID", modelID);
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			List elementList = commonService.selectList("model_SQL.getDhxDiagramList", setData);
			
			if(elementList.size()>0) {
				for(int i=0; i<elementList.size(); i++) {
					Map elementInfo = (Map)elementList.get(i);
					elementInfo.put("from", elementInfo.get("fromID"));
					elementInfo.put("to", elementInfo.get("toID"));
				}
			}
			
			JSONArray elementListJson = new JSONArray(elementList);
			model.put("elementList", elementListJson);
			
			System.out.println("elementList :"+elementListJson);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl(url);
	}
	
	@RequestMapping(value="/roleMindMap.do")
	public String roleMindMap(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url="app/olmv4/roleMindMap";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			Map setData = new HashMap();
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			setData.put("s_itemID", s_itemID);
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			Map itemInfo = commonService.select("attr_SQL.getItemNameInfo", setData);
			List diagramList = new ArrayList();
			List rightItems = new ArrayList();
			List leftItems = new ArrayList();
			
			setData.put("showElement", "Y");
			setData.put("mdlIF", "Y");
			setData.put("ClassCode", "CL01005");
//			List subItemList = (List) commonService.selectList("item_SQL.getSubItemList_gridList", setData);
			List processList = (List) commonService.selectList("item_SQL.getCxnItemList_gridList", setData);
			
			
			 Map itemMap = new HashMap(); 
			 itemMap.put("id",s_itemID);
			 itemMap.put("text", StringUtil.checkNull(itemInfo.get("Identifier")) +" "+ StringUtil.checkNull(itemInfo.get("PlainText")));
			 itemMap.put("fill", "#0288D1");
			 itemMap.put("fontColor", "#FFFFFF");
			 itemMap.put("stroke", "#0288D1");
			 
			 diagramList.add(itemMap);			 
			 
			 if(processList.size()>0){
					for(int i=0; i<processList.size(); i++){
						List classList = new ArrayList();
						List classNameList = new ArrayList();
						Map process = (Map)processList.get(i);
							
						 itemMap = new HashMap();
						 itemMap.put("id",StringUtil.checkNull(process.get("s_itemID")));
						 itemMap.put("text", StringUtil.checkNull(process.get("Identifier"))+" "+StringUtil.checkNull(process.get("ItemName")));
						 itemMap.put("parent", s_itemID);
						 itemMap.put("fill", "#11B3A5");
						 itemMap.put("fontColor", "#FFFFFF");
						 itemMap.put("stroke", "#11B3A5");
						 diagramList.add(itemMap);
						 
						 rightItems.add(String.valueOf("'"+process.get("s_itemID"))+"'");
							 
						setData.put("s_itemID", StringUtil.checkNull(process.get("s_itemID")));
						setData.remove("ClassCode");
						List cxnItemList = (List) commonService.selectList("item_SQL.getCxnItemList_gridList", setData);
						if(cxnItemList.size()>0){
							for(int j=0; j<cxnItemList.size(); j++){
								Map cxnMap = (Map)cxnItemList.get(j);
								if(!cxnMap.get("ItemTypeCode").equals("OJ00002")) {
									if(!classList.contains(cxnMap.get("ClassCode"))){
										classList.add(cxnMap.get("ClassCode"));
										classNameList.add(cxnMap.get("ClassName"));
										
										itemMap = new HashMap();
										itemMap.put("id","CLS_"+StringUtil.checkNull(process.get("s_itemID"))+"_" + StringUtil.checkNull(cxnMap.get("ClassCode")));
										itemMap.put("text", StringUtil.checkNull(cxnMap.get("ClassName")));
										itemMap.put("parent", StringUtil.checkNull(process.get("s_itemID")));
										itemMap.put("fill", "#a5a5a5");
										itemMap.put("fontColor", "#FFFFFF");
										itemMap.put("stroke", "#a5a5a5");
										diagramList.add(itemMap);
									}
									
									itemMap = new HashMap();
									itemMap.put("id","4d_"+StringUtil.checkNull(process.get("s_itemID"))+"_" + StringUtil.checkNull(cxnMap.get("s_itemID")));
									itemMap.put("text", StringUtil.checkNull(cxnMap.get("Identifier"))+" "+StringUtil.checkNull(cxnMap.get("ItemName")));
									itemMap.put("parent", "CLS_"+StringUtil.checkNull(process.get("s_itemID"))+"_" + StringUtil.checkNull(cxnMap.get("ClassCode")));
									itemMap.put("fill", "#ffffff");
									itemMap.put("fontColor", "#000000");
									itemMap.put("stroke", "#5569b1");
									diagramList.add(itemMap);
								}
							}
						}
					}
				}
			 
			 // 관련조직
			 setData.put("itemID", s_itemID);
			 setData.put("assigned", "1");
			 setData.put("teamRoleCat", "CNGROLETEP");
			 setData.put("roleType", "EXE");
			 List roleList = commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setData);
			 
			 for(int i=0; i < roleList.size(); i++) {
				 Map roleMap = (Map) roleList.get(i);
				 
				 itemMap = new HashMap();
				 itemMap.put("id", "tr_"+StringUtil.checkNull(roleMap.get("TeamID")));
				 itemMap.put("text", StringUtil.checkNull(roleMap.get("TeamNM")));
				 itemMap.put("parent", s_itemID);
				 itemMap.put("fill", "#ff9800");
				 itemMap.put("fontColor", "#FFFFFF");
				 itemMap.put("stroke", "#ff9800");
				 diagramList.add(itemMap);
				
				 leftItems.add("'tr_"+String.valueOf(roleMap.get("TeamID"))+"'");
			 }

			 JSONArray diagramListData = new JSONArray(diagramList);
			 model.put("diagramListData", diagramListData);
			 System.out.println("diagramListData :"+diagramListData);
			 
			 model.put("leftItems", leftItems);
			 model.put("rightItems", rightItems);
			 System.out.println("leftItems :"+leftItems);
			 System.out.println("rightItems :"+rightItems);
						
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl(url);
	}
	
	@RequestMapping(value="/initiativeMindMap.do")
	public String initiativeMindMap(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url="app/olmv4/initiativeMindMap";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			Map setData = new HashMap();
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			setData.put("s_itemID", s_itemID);
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			Map itemInfo = commonService.select("attr_SQL.getItemNameInfo", setData);
			List diagramList = new ArrayList();
			
			List subItemList = (List) commonService.selectList("item_SQL.getSubItemList_gridList", setData);
//			List processList = (List) commonService.selectList("item_SQL.getCxnItemList_gridList", setData);
			
			
			 Map itemMap = new HashMap(); 
			 itemMap.put("id",s_itemID);
			 itemMap.put("text", StringUtil.checkNull(itemInfo.get("Identifier")) +" "+ StringUtil.checkNull(itemInfo.get("PlainText")));
			 itemMap.put("fill", "#0288D1");
			 itemMap.put("fontColor", "#FFFFFF");
			 itemMap.put("stroke", "#0288D1");
			 itemMap.put("fontWeight", "bold");
			 
			 diagramList.add(itemMap);			 
			 
			 if(subItemList.size()>0){
					for(int i=0; i<subItemList.size(); i++){
						Map subItem = (Map)subItemList.get(i);
							
						 itemMap = new HashMap();
						 itemMap.put("id",StringUtil.checkNull(subItem.get("ItemID")));
						 itemMap.put("text", StringUtil.checkNull(subItem.get("Identifier"))+" "+StringUtil.checkNull(subItem.get("ItemName")));
						 itemMap.put("parent", s_itemID);
						 itemMap.put("fill", "#11B3A5");
						 itemMap.put("fontColor", "#FFFFFF");
						 itemMap.put("stroke", "#11B3A5");
						 itemMap.put("dir", "verticalLeft");
						 diagramList.add(itemMap);
						 
						// 관련조직
						 setData.put("itemID", StringUtil.checkNull(subItem.get("ItemID")));
						 setData.put("assigned", "1");
						 setData.put("teamRoleCat", "CNGROLETEP");
						 setData.put("roleType", "EXE");
						 List roleList = commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setData);
						 
						 if(roleList.size() > 0) {
						 	itemMap = new HashMap();
							itemMap.put("id","Team_"+StringUtil.checkNull(subItem.get("ItemID")));
							itemMap.put("text", "Team");
							itemMap.put("parent", StringUtil.checkNull(subItem.get("ItemID")));
							itemMap.put("fill", "#a5a5a5");
							itemMap.put("fontColor", "#FFFFFF");
							itemMap.put("stroke", "#a5a5a5");
							diagramList.add(itemMap);
								
							for(int j=0; j < roleList.size(); j++) {
								 Map roleMap = (Map) roleList.get(j);
								 
								 itemMap = new HashMap();
								 itemMap.put("id", "tr_"+StringUtil.checkNull(roleMap.get("TeamID")));
								 itemMap.put("text", StringUtil.checkNull(roleMap.get("TeamNM")));
								 itemMap.put("parent", "Team_"+StringUtil.checkNull(subItem.get("ItemID")));
								 itemMap.put("fill", "#ff9800");
								 itemMap.put("fontColor", "#FFFFFF");
								 itemMap.put("stroke", "#ff9800");
								 diagramList.add(itemMap);
							 }
						 }
							 
						setData.put("s_itemID", StringUtil.checkNull(subItem.get("ItemID")));
						setData.put("ClassCode","CL01005");
						List cxnProcList = (List) commonService.selectList("item_SQL.getCxnItemList_gridList", setData);
						if(cxnProcList.size()>0){
							itemMap = new HashMap();
							itemMap.put("id","Process_"+StringUtil.checkNull(subItem.get("ItemID")));
							itemMap.put("text", "Process");
							itemMap.put("parent", StringUtil.checkNull(subItem.get("ItemID")));
							itemMap.put("fill", "#a5a5a5");
							itemMap.put("fontColor", "#FFFFFF");
							itemMap.put("stroke", "#a5a5a5");
							diagramList.add(itemMap);
							
							for(int j=0; j<cxnProcList.size(); j++){
								List classList = new ArrayList();
								List classNameList = new ArrayList();
								Map cxnProc = (Map)cxnProcList.get(j);
								
								itemMap = new HashMap();
								itemMap.put("id","4d_"+StringUtil.checkNull(subItem.get("ItemID"))+"_" + StringUtil.checkNull(cxnProc.get("s_itemID")));
								itemMap.put("text", StringUtil.checkNull(cxnProc.get("Identifier"))+" "+StringUtil.checkNull(cxnProc.get("ItemName")));
								itemMap.put("parent", "Process_"+StringUtil.checkNull(subItem.get("ItemID")));
								itemMap.put("fill", "#5569b1");
								itemMap.put("fontColor", "#FFFFFF");
								itemMap.put("stroke", "#5569b1");
								itemMap.put("dir", "verticalLeft");
								itemMap.put("open", false);
								
								diagramList.add(itemMap);
								
								setData.put("s_itemID", StringUtil.checkNull(cxnProc.get("s_itemID")));
								setData.remove("ClassCode");
								List cxnItemList = (List) commonService.selectList("item_SQL.getCxnItemList_gridList", setData);
								if(cxnItemList.size()>0){
									for(int k=0; k<cxnItemList.size(); k++){
										Map cxnMap = (Map)cxnItemList.get(k);
//										if(!cxnMap.get("ItemTypeCode").equals("OJ00002")) {
											if(!classList.contains(cxnMap.get("ClassCode"))){
												classList.add(cxnMap.get("ClassCode"));
												classNameList.add(cxnMap.get("ClassName"));
												
												itemMap = new HashMap();
												itemMap.put("id","CLS_"+StringUtil.checkNull(subItem.get("ItemID"))+"_"+StringUtil.checkNull(cxnProc.get("s_itemID"))+"_" + StringUtil.checkNull(cxnMap.get("ClassCode")));
												itemMap.put("text", StringUtil.checkNull(cxnMap.get("ClassName")));
												itemMap.put("parent", "4d_"+StringUtil.checkNull(subItem.get("ItemID"))+"_" + StringUtil.checkNull(cxnProc.get("s_itemID")));
												itemMap.put("fill", "#a5a5a5");
												itemMap.put("fontColor", "#FFFFFF");
												itemMap.put("stroke", "#a5a5a5");
												diagramList.add(itemMap);
											}
											
											itemMap = new HashMap();
											itemMap.put("id","4d_"+StringUtil.checkNull(subItem.get("ItemID"))+"_"+StringUtil.checkNull(cxnProc.get("s_itemID"))+"_" + StringUtil.checkNull(cxnMap.get("s_itemID")));
											itemMap.put("text", StringUtil.checkNull(cxnMap.get("Identifier"))+" "+StringUtil.checkNull(cxnMap.get("ItemName")));
											itemMap.put("parent", "CLS_"+StringUtil.checkNull(subItem.get("ItemID"))+"_"+StringUtil.checkNull(cxnProc.get("s_itemID"))+"_" + StringUtil.checkNull(cxnMap.get("ClassCode")));
											itemMap.put("fill", "#ffffff");
											itemMap.put("fontColor", "#000000");
											itemMap.put("stroke", "#5569b1");
											diagramList.add(itemMap);
//										}
									}
								}
							}
						}
					}
				}
			 
			 JSONArray diagramListData = new JSONArray(diagramList);
			 model.put("diagramListData", diagramListData);
			 System.out.println("diagramListData :"+diagramListData);
						
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl(url);
	}
	
	@RequestMapping(value="/dhtmlxChartTreeMap.do")
	public String dhtmlxChartTreeMap(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url="app/olmv4/dhtmlxChartTreeMap";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			cmmMap.put("classCode", "CL01005");
			List processTreeMapList = commonService.selectList("main_SQL.processSttBar_chart", cmmMap);
			JSONArray processTreeMapListData = new JSONArray(processTreeMapList);
			
			System.out.println("processTreeMaplistData :"+processTreeMapListData);
			model.put("processTreeMapListData", processTreeMapListData);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/arcMenuV4.do")
	public String arcMenu(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/app/olmv4/arcMenu";
		try {
			Map setMap = new HashMap();
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("languageID",  StringUtil.checkNull(request.getParameter("languageID"), ""));
			model.put("arcCode", StringUtil.checkNull(request.getParameter("ArcCode")));
	
			setMap.put("languageID",StringUtil.checkNull(request.getParameter("languageID")));
			setMap.put("arcCode",StringUtil.checkNull(request.getParameter("ArcCode")));
			List list = commonService.selectList("config_SQL.getArcMenuAlloc_gridList", setMap);
			JSONArray gridData = new JSONArray(list);
			model.put("gridData",gridData);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/itSystemCoverageActivityTreeMap.do")
	public String itSystemCoverageActivityTreeMap(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url="app/olmv4/itSystemCoverageActivityTreeMap";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/getProcessTreeMapData.do")
	public void getProcessTreeMapData(HttpServletRequest request, HashMap cmmMap, HttpServletResponse res) throws Exception {
		try {			
			List processTreeMapList = commonService.selectList("analysis_SQL.getProcessStatisticsWithItSystem", cmmMap);
			JSONArray processTreeMapListData = new JSONArray(processTreeMapList);
			
			System.out.println("processTreeMaplistData :"+processTreeMapListData);
									
			res.setHeader("Cache-Control", "no-cache");
			res.setContentType("text/plain");
			res.setCharacterEncoding("UTF-8");
			if(!StringUtil.checkNull(processTreeMapListData).equals("")){
				res.getWriter().print(processTreeMapListData);
			}
			else {
				PrintWriter pw = res.getWriter();
				pw.write("데이터가 존재하지 않습니다.");
			}
		} catch (IOException e) {
			MessageHandler.getMessage("json.send.message");
			e.printStackTrace();
		}
	}
	
	

	
}
