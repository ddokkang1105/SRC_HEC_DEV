// package xbolt.board.brd.web;

// import java.time.LocalDateTime;
// import java.time.format.DateTimeFormatter;
// import java.util.ArrayList;
// import java.util.Arrays;
// import java.util.HashMap;
// import java.util.Iterator;
// import java.util.List;
// import java.util.Map;
// import java.util.Map.Entry;
// import java.util.stream.Collectors;

// import javax.annotation.Resource;
// import javax.servlet.http.HttpServletRequest;
// import javax.servlet.http.HttpSession;

// import org.apache.commons.lang3.StringEscapeUtils;
// import org.apache.commons.logging.Log;
// import org.apache.commons.logging.LogFactory;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.beans.factory.annotation.Qualifier;
// import org.springframework.stereotype.Controller;
// import org.springframework.transaction.annotation.Transactional;
// import org.springframework.transaction.interceptor.TransactionAspectSupport;
// import org.springframework.ui.ModelMap;
// import org.springframework.web.bind.annotation.RequestMapping;
// import org.springframework.web.multipart.MultipartHttpServletRequest;

// import com.org.json.JSONArray;

// import xbolt.cmm.controller.XboltController;
// import xbolt.cmm.framework.filter.XSSRequestWrapper;
// import xbolt.cmm.framework.handler.MessageHandler;
// import xbolt.cmm.framework.util.ExceptionUtil;
// import xbolt.cmm.framework.util.FileUtil;
// import xbolt.cmm.framework.util.NumberUtil;
// import xbolt.cmm.framework.util.StringUtil;
// import xbolt.cmm.framework.val.GlobalVal;
// import xbolt.cmm.service.CommonService;
// import xbolt.file.util.FileUploadUtil;

// @Controller
// @SuppressWarnings("unchecked")
// public class BoardController extends XboltController {
// 	private final Log _log = LogFactory.getLog(this.getClass());

// 	@Autowired
// 	@Qualifier("commonService")
// 	private CommonService commonService;

// 	@Resource(name = "boardService")
// 	private CommonService boardService;
	
// 	@Autowired
//     private FileUploadUtil fileUploadUtil;

// 	//////////////////////////////////////////////////////////////////////////
// 	// ==BOARD
// 	@RequestMapping(value = "/boardMgt.do")
// 	public String boardMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
// 		model.addAttribute(HTML_HEADER, "HOME");
// 		String reqBoardMgtID = StringUtil.checkNull(request.getParameter("boardMgtID"), "");
// 		String defBoardMgtID = StringUtil.checkNull(cmmMap.get("defBoardMgtID"));
// 		String BoardMgtID = "";
// 		String dueDateMgt  = StringUtil.checkNull(request.getParameter("dueDateMgt"), "");
// 		String url = "/board/brd/boardMainMenu";
// 		try {
// 			List boardMgtList = new ArrayList();
// 			String parentID = "";
// 			if (!reqBoardMgtID.equals("")) {// 그룹아이디로 넘어올경우 해당 그룹의 top 1 boardMgtID 찾아넣어주기
// 				parentID = commonService.selectString("board_SQL.getBoardParentID", cmmMap);
// 				if (parentID.equals("0")) {
// 					Map setData = new HashMap();
// 					setData.put("parentID", reqBoardMgtID);
// 					reqBoardMgtID = StringUtil
// 							.checkNull(commonService.selectString("board_SQL.getFirstBoardMgtID", setData));
// 				}
// 			}
// 			List boardGrpList = commonService.selectList("board_SQL.boardGrpList", cmmMap);
// 			boardMgtList = commonService.selectList("board_SQL.boardMgtListNew", cmmMap);
// 			String templName = commonService.selectString("board_SQL.getTemplName", cmmMap);
// 			model.put("dueDateMgt", dueDateMgt);
// 			model.put("templName", templName);
// 			model.put("boardGrpList", boardGrpList);
// 			model.put("boardMgtList", boardMgtList);
// 			model.put("boardLstCnt", StringUtil.checkNull(boardMgtList.size(), "0"));
// 			int grpOpenClose = 1;
// 			int loadingBoard = 2; // loading시 board 초기값 setting
// 			int j = 2;
// 			String boardGrpID = "";
// 			for (int i = 0; i < boardMgtList.size(); i++) {
// 				Map board = (HashMap) boardMgtList.get(i);
// 				if (!reqBoardMgtID.equals("")) {
// 					if (reqBoardMgtID.equals(StringUtil.checkNull(board.get("BoardMgtID")))) {
// 						model.put("BoardMgtID", StringUtil.checkNull(board.get("BoardMgtID")));
// 						model.put("StatusCount", i + 1);
// 						model.put("Url", StringUtil.checkNull(board.get("URL")));
// 						model.put("BoardTypeCD", StringUtil.checkNull(board.get("BoardTypeCD")));
// 						boardGrpID = StringUtil.checkNull(board.get("ParentID"));
// 						loadingBoard = j;
// 					}
// 				} else {
// 					if (i == 0) {
// 						BoardMgtID = StringUtil.checkNull(board.get("BoardMgtID"));
// 						model.put("BoardMgtID", StringUtil.checkNull(board.get("BoardMgtID")));
// 						model.put("StatusCount", i + 1);
// 						model.put("Url", StringUtil.checkNull(board.get("URL")));
// 						model.put("BoardTypeCD", StringUtil.checkNull(board.get("BoardTypeCD")));
// 						break;
// 					}
// 				}
// 				j++;
// 			}
// 			System.out.println("bbb loadingBoard:" + loadingBoard);
// 			if (!reqBoardMgtID.equals("")) {
// 				for (int i = 0; i < boardGrpList.size(); i++) {
// 					Map boardGrpMap = (HashMap) boardGrpList.get(i);
// 					if (boardGrpID.equals(StringUtil.checkNull(boardGrpMap.get("BoardGrpID")))) {
// 						// loadingBoard = loadingBoard+i+1;
// 						grpOpenClose = i + 1;
// 					}
// 				}
// 			}
// 			model.put("loadingBoard", loadingBoard);
// 			model.put("grpOpenClose", grpOpenClose);
// 			/* menu index 설정 */
// 			String menuIndex = ""; // 고정 메뉴 Index
// 			String space = " ";
// 			String startBoardIndex = "1";

// 			int ttlCnt = boardMgtList.size() + boardGrpList.size();
// 			int cnt = 1;
// 			for (int i = 0; ttlCnt > i; i++) {
// 				menuIndex = menuIndex + space + cnt;
// 				cnt++;
// 			}
// 			model.put("menuIndex", menuIndex);
// 			model.put("startBoardIndex", startBoardIndex);
// 			model.put("reqBoardMgtID", reqBoardMgtID);
// 			model.put("menu", getLabel(request, commonService)); /* Label Setting */
// 			model.put("projectID", cmmMap.get("projectID"));
// 			model.put("defBoardMgtID", defBoardMgtID);
			
// 			// 팝업에서 상세페이지로 바로 이동하는 옵션
// 			String goDetailOpt = StringUtil.checkNull(request.getParameter("goDetailOpt"),"");
// 			if("Y".equals(goDetailOpt)){
// 				String BoardID = StringUtil.checkNull(request.getParameter("BoardID"),"");
// 				model.put("BoardID", BoardID);
// 				String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
// 				model.put("s_itemID", s_itemID);
// 			}
// 			model.put("goDetailOpt", goDetailOpt);

// 		} catch (Exception e) {
// 			if (_log.isInfoEnabled()) {
// 				_log.info("BoardController::boardMgt::Error::" + e.toString().replaceAll("\r|\n", ""));
// 			}
// 			throw new ExceptionUtil(e.toString());
// 		}

// 		return nextUrl(url);
// 	}

// 	@RequestMapping(value = "/boardList.do")
// 	public String boardList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
// 		String BoardMgtID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("BoardMgtID"), request.getParameter("boardMgtID")));
// 		String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "1");
// 		String dueDateMgt =StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("dueDateMgt"), ""));
// 		/*
// 		 * String boardUrl = StringUtil.checkNull(request.getParameter("boardUrl"), "");
// 		 */
// 		String boardTypeCD = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("boardTypeCD"), ""));
// 		String screenType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("screenType"), ""));
// 		String defBoardMgtID = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("defBoardMgtID")));
// 		String category = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("category")));
// 		String categoryIndex = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("categoryIndex")));
// 		String categoryCnt = StringUtil.replaceFilterString(StringUtil.checkNull(commonService.selectString("board_SQL.getBoardMgtCatCNT", cmmMap),""));
// 		String scStartDt = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("scStartDt")));
// 		String searchKey = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchKey")));
// 		String searchValue = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchValue")));
// 		String scEndDt = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("scEndDt")));
// 		String myBoard = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("myBoard")));
// 		String icon = "icon_folder_upload_title.png";
// 		String projectID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectID"), ""));
// 		String templProjectID = StringUtil.replaceFilterString(StringUtil.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap),""));
// 		String projectType = "";
// 		String projectCategory = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectCategory"), ""));
// 		String projectIDs = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectIDs"), ""));
// 		String varFilter = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("varFilter"), "4"));
// 		String languageID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("languageID"), ""));
// 		String boardTitle = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("boardTitle"),""));
		
		

// 		Map setMap2 = new HashMap();
// 		setMap2.put("MenuID", boardTypeCD);
// 		String boardUrl = StringUtil.checkNull(commonService.selectString("menu_SQL.getMenuVarfilter", setMap2), "");
// 		int idx = boardUrl.indexOf("=");
// 		boardUrl = boardUrl.substring(idx + 1);
		

// //		List<String> params = Arrays.stream(boardUrl.split("&"))
// //			    .filter(s -> !s.isEmpty())
// //			    .collect(Collectors.toList());

// 		// & 기준으로 나누기
// 		List<String> parts = Arrays.asList(boardUrl.split("&"));

// 		// 첫 번째
// 		String pureUrl = parts.get(0);

// 		// 나머지는 
// 		String varFilters = parts.stream()
// 		    .skip(1)
// 		    .map(s -> "&" + s)
// 		    .collect(Collectors.joining());

// 		//System.out.println("pureUrl = " + pureUrl);
// 		//System.out.println("varfilter = " + varFilters);
		
// 		String url = pureUrl;
// 		model.put("varFilters", varFilters);
// 	 if (boardUrl.equals("")) {
// 			url = "/board/brd/boardList";
// 		}

// 		if ((BoardMgtID == null || BoardMgtID == "") && varFilter != null) {
// 			BoardMgtID = varFilter;
// 		}

// 		if (BoardMgtID != null && BoardMgtID.equals("4")) {
// 			icon = "comment_user.png";
// 		}
// 		;

// 		try {
// 			Map setMap = new HashMap();
// 			if (projectID != null && !"".equals(projectID)) {
// 				templProjectID = projectID;
// 			} else {
// 				projectID = templProjectID;
// 			}
// 			if (templProjectID != null && !"".equals(templProjectID)) {
// 				setMap.put("s_itemID", templProjectID);
// 				projectType = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectType", setMap),"");
// 			}

// 			setMap.put("BoardMgtID", BoardMgtID);
// 			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
// 			Map boardMgtInfo = commonService.select("board_SQL.getBoardMgtInfo", setMap);
// 			model.put("boardMgtInfo", boardMgtInfo);
// 			if(boardTitle.equals("")) {
// 		    	 boardTitle = StringUtil.checkNull(boardMgtInfo.get("boardMgtName"),"");
// 			}
// 			model.put("boardTitle", boardTitle);
// 			int totCnt = NumberUtil.getIntValue(commonService.selectString("board_SQL.boardTotalCnt", setMap));

// 			String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName", setMap);
// 			String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);
// 			model.put("boardMgtName", boardMgtName);
// 			model.put("CategoryYN", categoryYN);
// 			//model.put("showItemInfo", showItemInfo);
// 			String likeYN = commonService.selectString("board_SQL.getBoardLikeYN", setMap);
// 			model.put("LikeYN", likeYN);

// 			if ("Y".equals(myBoard)) {
// 				model.put("myID", cmmMap.get("sessionUserId"));
// 				model.put("boardMgtName", "Communication");
// 			}

// 			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
// 			List brdCatList = commonService.selectList("common_SQL.getBoardMgtCategory_commonSelect", setMap);
// 			Map mgtInfoMap = commonService.select("board_SQL.getBoardMgtInfo", setMap);

// 			if ("N".equals(mgtInfoMap.get("MgtOnlyYN")) && Integer.parseInt(mgtInfoMap.get("MgtGRID").toString()) > 0) {
// 				Map tmpMap = new HashMap();

// 				tmpMap.put("checkID", cmmMap.get("sessionUserId"));
// 				tmpMap.put("groupID", mgtInfoMap.get("MgtGRID"));
// 				String check = StringUtil.checkNull(commonService.selectString("user_SQL.getEndGRUser", tmpMap), "");

// 				if (!"".equals(check)) {
// 					mgtInfoMap.put("MgtGRID2", mgtInfoMap.get("MgtGRID"));
// 				} else {
// 					mgtInfoMap.put("MgtGRID2", "");
// 				}
// 			}

// 			//gridData
// 			cmmMap.put("languageID", languageID);
// 			List boardList = commonService.selectList("board_SQL.boardList_gridList", cmmMap);
//  	 		JSONArray gridData = new JSONArray(boardList);
//  	 		model.put("gridData",gridData);
 	 		
// 			model.put("scStartDt", scStartDt);
// 			model.put("searchKey", searchKey);
// 			model.put("searchValue", searchValue);
// 			model.put("scEndDt", scEndDt);
// 			model.put("templProjectID", templProjectID);
// 			model.put("projectType", projectType);
// 			model.put("mgtInfoMap", mgtInfoMap);
// 			model.put("brdCatList", brdCatList);
// 			model.put("brdCatListCnt", brdCatList.size());
// 			model.put("totalPage", totCnt);
// 			model.put("pageNum", pageNum);
// 			model.put("menu", getLabel(request, commonService)); /* Label Setting */
// 			model.put("setXML", setXML());
// 			model.put("icon", icon);
// 			model.put("BoardMgtID", BoardMgtID);
// 			model.put("screenType", screenType);
// 			model.put("myBoard", myBoard);
// 			model.put("projectID", projectID);
// 			model.put("boardUrl", boardUrl);
// 			model.put("defBoardMgtID", defBoardMgtID);
// 			model.put("category", category);
// 			model.put("categoryIndex", categoryIndex);
// 			model.put("categoryCnt", categoryCnt);
// 			model.put("baseUrl", GlobalVal.BASE_ATCH_URL);
// 			model.put("projectCategory", projectCategory);
// 			model.put("projectIDs", projectIDs);
// 			model.put("dueDateMgt", dueDateMgt);
// 		} catch (Exception e) {
// 			if (_log.isInfoEnabled()) {
// 				_log.info("BoardController::boardList::Error::" + e.toString().replaceAll("\r|\n", ""));
// 			}
// 			throw new ExceptionUtil(e.toString());
// 		}

// 		return nextUrl(url);
// 	}

// 	@RequestMapping(value = "/boardDetail.do")
// 	public String boardDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {

// 		String url = "/board/brd/boardDetail";

// 		try {
// 			// 임시저장된 파일이 존재할 수 있으므로 삭제
// 			String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
// 			String templProjectID = StringUtil
// 					.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap), "");
// 			if (!path.equals("")) {
// 				FileUtil.deleteDirectory(path);
// 			}

// 			String BoardMgtID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("BoardMgtID"), "1"));
// 			String currPage = StringUtil.checkNull(request.getParameter("currPage"), "1");
// 			String screenType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("screenType"), ""));
// 			String boardUrl = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("url"), ""));
// 			String projectID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectID"), ""));
// 			String category = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("category"), ""));
// 			String categoryIndex = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("categoryIndex"), ""));
// 			String categoryCnt = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("categoryCnt"), ""));

// 			String scStartDt = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("scStartDt")));
// 			String searchKey = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchKey")));
// 			String searchValue = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchValue")));
// 			String scEndDt = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("scEndDt")));

// 			String templProjectType = "";
// 			String projectType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectType"), ""));
// 			String projectCategory = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectCategory"), ""));
// 			String projectIDs = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectIDs"), ""));

// 			Map setMap = new HashMap();
// 			setMap.put("s_itemID", templProjectID);
// 			templProjectType = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectType", setMap),"");

// 			if (BoardMgtID != null) {
// 				setMap.put("BoardMgtID", BoardMgtID);
// 				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
// 				String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName", setMap);
// 				String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);
// 				model.put("boardMgtName", boardMgtName);
// 				model.put("CategoryYN", categoryYN);

// 			}

// 			// 조회수UPDATE
// 			commonService.update("board_SQL.boardUpdateReadCnt", cmmMap);
// 			Map result = commonService.select("board_SQL.boardDetail", cmmMap);

// 			String s_BoardMgtID = StringUtil.checkNull(result.get("BoardMgtID"), "");

// 			if (!s_BoardMgtID.equals(BoardMgtID)) {
// 				model.put("BoardMgtID", BoardMgtID);
// 				return nextUrl("/board/brd/boardList");
// 			}

// 			String subject = StringUtil.checkNull(result.get("Subject"));
// 			subject = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(subject));
// 			subject = StringEscapeUtils.unescapeHtml4(subject);

// 			String content = StringUtil.checkNull(result.get("Content"));
// 			content = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(content));
// 			content = StringEscapeUtils.unescapeHtml4(content);

// 			result.put("Subject", StringEscapeUtils.unescapeHtml4(subject));
// 			result.put("Content", StringEscapeUtils.unescapeHtml4(content));

// 			model.put("result", result);

// 			model.put("itemFiles", (List) commonService.selectList("boardFile_SQL.boardFile_selectList", cmmMap));

// 			model.put(AJAX_RESULTMAP, result);

// 			String LikeYN = commonService.selectString("board_SQL.getBoardLikeYN", setMap);
// 			model.put("LikeYN", LikeYN);
// 			String likeCNT = "";

// 			if (LikeYN != null && "Y".equals(LikeYN)) {
// 				setMap.put("BoardMgtID", result.get("BoardMgtID"));
// 				setMap.put("BoardID", result.get("BoardID"));
// 				likeCNT = commonService.selectString("board_SQL.getBoardLikeCNT", setMap);
// 				model.put("likeCNT", likeCNT);
// 			}

// 			// model.put("templProjectType", templProjectType);
// 			model.put("scStartDt", scStartDt);
// 			model.put("searchKey", searchKey);
// 			model.put("searchValue", searchValue);
// 			model.put("scEndDt", scEndDt);
// 			model.put("templProjectID", templProjectID);
// 			model.put("projectType", projectType);
// 			model.put("BoardMgtID", BoardMgtID);
// 			model.put("currPage", currPage);
// 			model.put("NEW", StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("NEW"))));
// 			model.put("screenType", screenType);
// 			model.put("url", boardUrl);
// 			model.put("menu", getLabel(request, commonService)); /* Label Setting */
// 			model.put("projectID", projectID);
// 			model.put("defBoardMgtID", cmmMap.get("defBoardMgtID"));
// 			model.put("category", category);
// 			model.put("categoryIndex", categoryIndex);
// 			model.put("categoryCnt", categoryCnt);
// 			model.put("projectCategory", projectCategory);
// 			model.put("projectIDs", projectIDs);

// 			if (screenType.equals("PG") || screenType.equals("PJT")) {
// 				if (!projectID.equals("")) {
// 					Map projectMap = new HashMap();
// 					setMap.put("parentID", projectID);
// 					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
// 					projectMap = commonService.select("task_SQL.getProjectAuthorID", setMap);
// 					model.put("projectMap", projectMap);
// 				}
// 			}

// 		} catch (Exception e) {
// 			if (_log.isInfoEnabled()) {
// 				_log.info("BoardController::boardDetail::Error::" + e.toString().replaceAll("\r|\n", ""));
// 			}
// 			throw new ExceptionUtil(e.toString());
// 		}
// 		return nextUrl(url);
// 	}

// 	@RequestMapping(value = "/editBoard.do")
// 	public String editBoard(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {

// 		String url = "/board/brd/editBoard";

// 		try {
// 			// 임시저장된 파일이 존재할 수 있으므로 삭제
// 			String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
// 			String templProjectID = StringUtil
// 					.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap), "");
// 			if (!path.equals("")) {
// 				FileUtil.deleteDirectory(path);
// 			}

// 			String BoardMgtID = StringUtil
// 					.replaceFilterString(StringUtil.checkNull(request.getParameter("BoardMgtID"), "1"));
// 			String currPage = StringUtil.checkNull(request.getParameter("currPage"), "1");
// 			String screenType = StringUtil
// 					.replaceFilterString(StringUtil.checkNull(request.getParameter("screenType"), ""));
// 			String boardUrl = StringUtil.checkNull(request.getParameter("url"), "");
// 			String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
// 			String category = StringUtil.checkNull(request.getParameter("category"), "");
// 			String categoryIndex = StringUtil.checkNull(request.getParameter("categoryIndex"), "");
// 			String categoryCnt = StringUtil.checkNull(request.getParameter("categoryCnt"), "");

// 			String scStartDt = StringUtil.checkNull(cmmMap.get("scStartDt"));
// 			String searchKey = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchKey")));
// 			String searchValue = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchValue")));
// 			String scEndDt = StringUtil.checkNull(cmmMap.get("scEndDt"));

// 			String templProjectType = "";
// 			String projectType = StringUtil.checkNull(request.getParameter("projectType"), "");
// 			String projectCategory = StringUtil
// 					.replaceFilterString(StringUtil.checkNull(request.getParameter("projectCategory"), ""));

// 			Map setMap = new HashMap();
// 			setMap.put("s_itemID", templProjectID);
// 			templProjectType = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectType", setMap),
// 					"");

// 			if (BoardMgtID != null) {
// 				setMap.put("BoardMgtID", BoardMgtID);
// 				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
// 				String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName", setMap);
// 				String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);
// 				model.put("boardMgtName", boardMgtName);
// 				model.put("CategoryYN", categoryYN);
// 			}

// 			if ("N".equals(cmmMap.get("NEW"))) {
// 				// 조회수UPDATE
// 				commonService.update("board_SQL.boardUpdateReadCnt", cmmMap);
// 				Map result = commonService.select("board_SQL.boardDetail", cmmMap);

// 				String subject = StringUtil.checkNull(result.get("Subject"));
// 				subject = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(subject));
// 				subject = StringEscapeUtils.unescapeHtml4(subject);

// 				String content = StringUtil.checkNull(result.get("Content"));
// 				content = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(content));
// 				content = StringEscapeUtils.unescapeHtml4(content);

// 				result.put("Subject", subject);
// 				result.put("Content", content);

// 				model.put("result", result);

// 				model.put("itemFiles", (List) commonService.selectList("boardFile_SQL.boardFile_selectList", cmmMap));

// 				model.put(AJAX_RESULTMAP, result);

// 				String LikeYN = commonService.selectString("board_SQL.getBoardLikeYN", setMap);
// 				model.put("LikeYN", LikeYN);
// 				String likeCNT = "";

// 				if (LikeYN != null && "Y".equals(LikeYN)) {
// 					setMap.put("BoardMgtID", result.get("BoardMgtID"));
// 					setMap.put("BoardID", result.get("BoardID"));
// 					likeCNT = commonService.selectString("board_SQL.getBoardLikeCNT", setMap);
// 					model.put("likeCNT", likeCNT);
// 				}

// 			} else {
// 				Map result = new HashMap();

// 				result.put("BoardMgtID", BoardMgtID);
// 				result.put("boardID", "");
// 				result.put("Subject", "");
// 				result.put("Content", "");
// 				result.put("WriteUserID", "");
// 				result.put("PreBoardID", cmmMap.get("PreBoardID"));
// 				result.put("ReplyLev", "");
// 				result.put("ReadCNT", "");
// 				result.put("WriteUserNm", "");
// 				result.put("AttFileID", "");
// 				result.put("RegDT", "");
// 				result.put("RegUserID", "");
// 				result.put("ModDT", "");
// 				result.put("ModUserID", "");
// 				result.put("Category", "");
// 				model.put(AJAX_RESULTMAP, result);
				
// 				// DICTIONARY.Description			
// 				setMap.put("Category", "BRDNM");
// 				setMap.put("TypeCode", BoardMgtID);
// 				setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
// 				Map dicInfo = commonService.select("common_SQL.label_commonSelect", setMap);
// 				model.put("dicInfo", dicInfo);
// 			}

// 			// model.put("templProjectType", templProjectType);
// 			model.put("scStartDt", scStartDt);
// 			model.put("searchKey", searchKey);
// 			model.put("searchValue", searchValue);
// 			model.put("scEndDt", scEndDt);
// 			model.put("templProjectID", templProjectID);
// 			model.put("projectType", projectType);
// 			model.put("BoardMgtID", BoardMgtID);
// 			model.put("currPage", currPage);
// 			model.put("NEW", cmmMap.get("NEW"));
// 			model.put("screenType", screenType);
// 			model.put("url", boardUrl);
// 			model.put("menu", getLabel(request, commonService)); /* Label Setting */
// 			model.put("projectID", projectID);
// 			model.put("defBoardMgtID", cmmMap.get("defBoardMgtID"));
// 			model.put("category", category);
// 			model.put("categoryIndex", categoryIndex);
// 			model.put("categoryCnt", categoryCnt);
// 			model.put("projectCategory", projectCategory);

// 			if (screenType.equals("PG") || screenType.equals("PJT")) {
// 				if (!projectID.equals("")) {
// 					Map projectMap = new HashMap();
// 					setMap.put("parentID", projectID);
// 					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
// 					projectMap = commonService.select("task_SQL.getProjectAuthorID", setMap);
// 					model.put("projectMap", projectMap);
// 				}
// 			}
			
// 			// file upload를 위한 session 등록
// 			HttpSession session = request.getSession(true);
// 			String uploadToken = fileUploadUtil.makeFileUploadFolderToken(session);
// 			model.put("uploadToken", uploadToken);

// 		} catch (Exception e) {
// 			if (_log.isInfoEnabled()) {
// 				_log.info("BoardController::boardDetail::Error::" + e.toString().replaceAll("\r|\n", ""));
// 			}
// 			throw new ExceptionUtil(e.toString());
// 		}
// 		return nextUrl(url);
// 	}

// 	//////////////////////////////////////////////////////////////////////////
// 	// ==ADMIN
// 	@RequestMapping(value = "/boardAdminMgt.do")
// 	public String boardAdminMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
// 		String BoardMgtID = "";
// 		String url = "/board/brd/boardMainMenu";
// 		try {
// 			List boardMgtList = new ArrayList();
// 			boardMgtList = commonService.selectList("board_SQL.boardMgtListNew", cmmMap);
// 			List boardGrpList = commonService.selectList("board_SQL.boardGrpList", cmmMap);
// 			String templName = commonService.selectString("board_SQL.getTemplName", cmmMap);
// 			String boardMgtID = StringUtil.checkNull(cmmMap.get("boardMgtID"));
// 			String defBoardMgtID = StringUtil.checkNull(cmmMap.get("defBoardMgtID"));
// 			model.put("templName", templName);

// 			model.put("boardGrpList", boardGrpList);
// 			model.put("boardMgtList", boardMgtList);
// 			model.put("boardLstCnt", StringUtil.checkNull(boardMgtList.size(), "0"));
// 			model.put("boardGrpCnt", boardGrpList.size());
// 			int j = 2;
// 			int loadingBoard = 2;
// 			for (int i = 0; i < boardMgtList.size(); i++) {
// 				Map board = (HashMap) boardMgtList.get(i);
// 				if (!boardMgtID.equals("")) {
// 					if (boardMgtID.equals(StringUtil.checkNull(board.get("BoardMgtID")))) {
// 						BoardMgtID = StringUtil.checkNull(board.get("BoardMgtID"));
// 						model.put("BoardMgtID", StringUtil.checkNull(board.get("BoardMgtID")));
// 						model.put("StatusCount", i + 1);
// 						model.put("Url", StringUtil.checkNull(board.get("URL")));
// 						model.put("BoardTypeCD", StringUtil.checkNull(board.get("BoardTypeCD")));
// 						loadingBoard = j;

// 					}
// 				} else {
// 					if (i == 0) {
// 						BoardMgtID = StringUtil.checkNull(board.get("BoardMgtID"));
// 						model.put("BoardMgtID", StringUtil.checkNull(board.get("BoardMgtID")));
// 						model.put("StatusCount", i + 1);
// 						model.put("Url", StringUtil.checkNull(board.get("URL")));
// 						model.put("BoardTypeCD", StringUtil.checkNull(board.get("BoardTypeCD")));
// 						break;
// 					}
// 				}
// 				j++;
// 			}

// 			int grpOpenClose = 1;
// 			String boardGrpID = "";
// 			if (!boardMgtID.equals("")) {// 그룹아이디로 넘어올경우 해당 그룹의 top 1 boardMgtID 찾아넣어주기
// 				boardGrpID = commonService.selectString("board_SQL.getBoardParentID", cmmMap);
// 			}
// 			if (!boardMgtID.equals("")) {
// 				for (int i = 0; i < boardGrpList.size(); i++) {
// 					Map boardGrpMap = (HashMap) boardGrpList.get(i);
// 					if (boardGrpID.equals(StringUtil.checkNull(boardGrpMap.get("BoardGrpID")))) {
// 						// loadingBoard = loadingBoard+i+1;
// 						grpOpenClose = i + 1;
// 					}
// 				}
// 			}

// 			/* menu index 설정 */
// 			String menuIndex = ""; // 고정 메뉴 Index
// 			String space = " ";
// 			String startBoardIndex = "1";

// 			int ttlCnt = boardMgtList.size() + boardGrpList.size();
// 			int cnt = 1;
// 			for (int i = 0; ttlCnt > i; i++) {
// 				menuIndex = menuIndex + space + cnt;
// 				cnt++;
// 			}

// 			model.put("menuIndex", menuIndex);
// 			model.put("startBoardIndex", startBoardIndex);
// 			model.put("grpOpenClose", grpOpenClose);
// 			model.put("loadingBoard", loadingBoard);
// 			model.addAttribute(HTML_HEADER, "HOME");
// 			model.put("menu", getLabel(request, commonService)); /* Label Setting */
// 			model.put("defBoardMgtID", defBoardMgtID);
// 		} catch (Exception e) {
// 			if (_log.isInfoEnabled()) {
// 				_log.info("BoardController::boardAdminMgt::Error::" + e.toString().replaceAll("\r|\n", ""));
// 			}
// 			throw new ExceptionUtil(e.toString());
// 		}
// 		return nextUrl(url);
// 	}

// 	@RequestMapping(value = "/boardAdminList.do")
// 	public String boardAdminList(HttpServletRequest request, ModelMap model) throws Exception {
// 		model.addAttribute(HTML_HEADER, "HOME");
// 		try {
// 			String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"), "1");
// 			// if(BoardMgtID.equals("3")) BoardMgtID = "1";
// 			// else if(BoardMgtID.equals("4")) BoardMgtID = "2";

// 			String page = StringUtil.checkNull(request.getParameter("page"), "1");
// 			Map mapValue = new HashMap();
// 			mapValue.put("BoardMgtID", BoardMgtID);
// 			int totCnt = NumberUtil.getIntValue(commonService.selectString("board_SQL.boardTotalCnt", mapValue));
// 			model.put("BoardMgtID", BoardMgtID);
// 			model.put("totalPage", totCnt);
// 			model.put("page", page);
// 			model.put("menu", getLabel(request, commonService)); /* Label Setting */
// 		} catch (Exception e) {
// 			System.out.println(e);
// 			throw new ExceptionUtil(e.toString());
// 		}

// 		return nextUrl("/adm/configuration/board/boardAdminList");
// 	}

// 	@RequestMapping(value = "/boardAdminDetail.do")
// 	public String boardAdminDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
// 		try {
// 			// 임시저장된 파일이 존재할 수 있으므로 삭제
// 			String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
// 			if (!path.equals("")) {
// 				FileUtil.deleteDirectory(path);
// 			}

// 			String BoardMgtID = StringUtil.checkNull(cmmMap.get("BoardMgtID"), "1");
// 			// if(BoardMgtID.equals("3")) BoardMgtID = "1";
// 			// else if(BoardMgtID.equals("4")) BoardMgtID = "2";
// 			String currPage = StringUtil.checkNull(cmmMap.get("currPage"), "1");
// 			if ("N".equals(cmmMap.get("NEW"))) {
// 				Map result = commonService.select("board_SQL.boardDetail", cmmMap);
// 				model.put("itemFiles", (List) commonService.selectList("boardFile_SQL.boardFile_selectList", result));
// 				model.addAttribute(AJAX_RESULTMAP, result);
// 			} else {
// 				Map result = new HashMap();
// 				result.put("BoardMgtID", BoardMgtID);
// 				result.put("BoardID", "");
// 				result.put("Subject", "");
// 				result.put("Content", "");
// 				result.put("WriteUserID", "");
// 				result.put("ReplyLev", "");
// 				result.put("ReadCNT", "");
// 				result.put("WriteUserNm", "");
// 				result.put("RegDT", "");
// 				result.put("RegUserID", "");
// 				result.put("ModDT", "");
// 				result.put("ModUserID", "");

// 				model.addAttribute(AJAX_RESULTMAP, result);
// 			}
// 			model.put("BoardMgtID", BoardMgtID);
// 			model.put("currPage", currPage);
// 			model.put("NEW", cmmMap.get("NEW"));
// 			model.put("menu", getLabel(request, commonService)); /* Label Setting */
// 		} catch (Exception e) {
// 			System.out.println(e);
// 			throw new ExceptionUtil(e.toString());
// 		}
// 		return nextUrl("/adm/configuration/board/boardAdminDetail");
// 	}

// 	// =======================================================================================================//

// 	//////////////////////////////////////////////////////////////////////////
// 	// ==SAVE/DELETE/UPDATE
// 	@Transactional(rollbackFor = Exception.class)
// 	@RequestMapping(value = "/saveBoard.do")
// 	public String saveBoard(MultipartHttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
// 		Map target = new HashMap();
// 		XSSRequestWrapper xss = new XSSRequestWrapper(request);

// 		for (Iterator i = cmmMap.entrySet().iterator(); i.hasNext();) {
// 			Entry e = (Entry) i.next(); // not allowed

// 			if (!e.getKey().equals("loginInfo") && e.getValue() != null) {
// 				cmmMap.put(e.getKey(),
// 						xss.stripXSS2(e.getValue().toString()).replaceAll("<", "&lt;").replaceAll(">", "&gt;"));
// 			}
// 		}
// 		// Map map = new HashMap();
// 		List fileList = new ArrayList();
// 		String BoardMgtID = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("BoardMgtID"), ""));
// 		String BoardID = StringUtil.checkNull(cmmMap.get("BoardID"), "");
// 		String projectID = StringUtil.checkNull(cmmMap.get("project"));
// 		String screenType = StringUtil.checkNull(cmmMap.get("screenType"));
// 		String boardUrl = StringUtil.checkNull(cmmMap.get("boardUrl"));
// 		String pageNum = StringUtil.checkNull(cmmMap.get("pageNum"));
// 		String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"), "");
		
// 		// file upload 공통 사용
// 		Map fileUploadMap = new HashMap();
// 		String errorMessage = MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068");
// 		String uploadToken = StringUtil.checkNull(cmmMap.get("uploadToken"), "");
		
// 		Map setData = new HashMap();
// 		setData.put("BoardMgtID", BoardMgtID);

// 		Map boardMgtInfo = commonService.select("board_SQL.getBoardMgtInfo", cmmMap);
		
// 		String mgtOnlyYN = StringUtil.checkNull(boardMgtInfo.get("MgtOnlyYN"));
// 		String mgtUserID = StringUtil.checkNull(boardMgtInfo.get("MgtUserID"));
// 		String mgtGRID = StringUtil.checkNull(boardMgtInfo.get("MgtGRID"));		
// 		String sessionAuthLev = StringUtil.checkNull(cmmMap.get("sessionAuthLev"), "");
// 		String writeYN = "N";
// 		if ("N".equals(mgtOnlyYN) && Integer.parseInt(mgtGRID) > 0) {
// 			Map tmpMap = new HashMap();
// 			tmpMap.put("checkID", userId);
// 			tmpMap.put("groupID", mgtGRID);
// 			String check = StringUtil.checkNull(commonService.selectString("user_SQL.getEndGRUser", tmpMap), "");

// 			if (!"".equals(check)) {
// 				boardMgtInfo.put("MgtGRID2", mgtGRID);
// 			} else {
// 				boardMgtInfo.put("MgtGRID2", "");
// 			}
// 		}
// 		String mgtGRID2 = StringUtil.checkNull(boardMgtInfo.get("MgtGRID2"));
		
// 		if((mgtOnlyYN.equals("Y") && mgtUserID.equals(userId)) 
// 			|| (!mgtOnlyYN.equals("Y") && mgtGRID.equals(mgtGRID2))
// 			|| (!mgtOnlyYN.equals("Y") && Integer.parseInt(mgtGRID) < 1 && Integer.parseInt(sessionAuthLev) <= 2)
// 		){
// 			writeYN = "Y";
// 		}

// 		try {
// 			setData.put("userId", userId);
// 			String chkLimit = chkLimit(setData);
			
// 			if (writeYN.equals("N")){
// 				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00033")); 
// 				target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID")
// 						+ "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove();");
// 			}else if("".equals(BoardID) && "Y".equals(chkLimit)){
// 				// 신규 등록 시 유저가 1분내에 5번 이상 글을 등록할 수 없다. 
// 				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
// 				target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID")
// 						+ "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove();");
// 			} else {

// 				model.put("BoardMgtID", BoardMgtID);
// 				model.put("s_itemID", projectID);
// 				model.put("screenType", screenType);
// 				model.put("url", boardUrl);
// 				model.put("pageNum", pageNum);

// 				// cmmMap.put("BoardMgtID", BoardMgtID);
// 				// cmmMap.put("BoardID", BoardID);
// 				String Subject = StringUtil.checkNull(cmmMap.get("Subject"), "");
// 				Subject = StringUtil.replaceFilterString(Subject).replaceAll("<","&lt;").replaceAll(">","&gt;");
// 				cmmMap.put("Subject", Subject);

// 				String Content = StringUtil.checkNull(cmmMap.get("Content"), "");
// 				Content = StringUtil.replaceFilterString(Content).replaceAll("<","&lt;").replaceAll(">","&gt;");
// 				cmmMap.put("Content", Content);
// 				cmmMap.put("projectID", projectID);
// 				Map setMap = new HashMap();

// 				setMap.put("boardID", BoardID);
// 				String regUserID = StringUtil.checkNull(commonService.selectString("forum_SQL.getForumRegID", setMap));
				
// 				cmmMap.put("type","BOARD");
// 				cmmMap.put("uploadToken",uploadToken);
// 				// commandFileMap에 _ID 값이 없으면 신규 등록
// 				if ("".equals(BoardID)) {
// 					cmmMap.put("GUBUN", "insert");
// 					// 신규 _ID 가져옴
// 					BoardID = commonService.selectString("board_SQL.boardNextVal", cmmMap);
// 					// Read Server File
// 					cmmMap.put("BoardMgtID",BoardMgtID);
// 					cmmMap.put("BoardID",BoardID);
// 					cmmMap.put("projectID",projectID);
// 					fileUploadMap = fileUploadUtil.fileUpload(cmmMap, request);
// 				} else if (regUserID.equals(userId)) {
// 					cmmMap.put("GUBUN", "update");
// 					cmmMap.put("BoardMgtID",BoardMgtID);
// 					cmmMap.put("BoardID",BoardID);
// 					cmmMap.put("projectID",projectID);
// 					cmmMap.put("projectID",projectID);
// 					fileUploadMap = fileUploadUtil.fileUpload(cmmMap, request);
// 				}
				
// 				boolean fileUploadResult = (boolean) fileUploadMap.getOrDefault("result",false);
// 				if(!fileUploadResult) {
// 					errorMessage = StringUtil.checkNull(fileUploadMap.get("message"),"파일 업로드 실패");
// 					throw new Exception(errorMessage);
// 				}
				
// 				// 게시글 저장
// 				boardService.save(cmmMap);
				
// 				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
// 				target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID")
// 						+ "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove();");

// 			}
// 		} catch (Exception e) {
// 			System.out.println(e.toString());
// 			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
// 			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
// 			target.put(AJAX_ALERT, errorMessage); // 오류 발생
// 		} 
// 		model.addAttribute(AJAX_RESULTMAP, target);
// 		model.put("BoardMgtID", BoardMgtID);

// 		return nextUrl(AJAXPAGE);
// 	}

// 	@RequestMapping(value = "/deleteBoard.do")
// 	public String deleteBoard(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
// 		Map target = new HashMap();
// 		List fileList = new ArrayList();
// 		String BoardMgtID = StringUtil
// 				.replaceFilterString(StringUtil.checkNull(request.getParameter("BoardMgtID"), "1"));
// 		String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
// 		String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");
// 		String boardUrl = StringUtil.checkNull(request.getParameter("boardUrl"), "");
// 		String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "");
// 		String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"), "");
// 		model.put("BoardMgtID", BoardMgtID);
// 		model.put("projectID", projectID);
// 		model.put("screenType", screenType);
// 		model.put("url", boardUrl);
// 		model.put("pageNum", pageNum);

// 		try {
// 			Map setMap = new HashMap();

// 			String BoardID = StringUtil.checkNull(request.getParameter("BoardID"));
// 			setMap.put("boardID", BoardID);
// 			String regUserID = StringUtil.checkNull(commonService.selectString("forum_SQL.getForumRegID", setMap));
// 			if (userId.equals(regUserID) || "1".equals(String.valueOf(cmmMap.get("sessionAuthLev")))) {
// 				cmmMap.put("GUBUN", "delete");
// 				boardService.save(cmmMap);

// 				// target.put(AJAX_ALERT, "삭제가 성공하였습니다.");
// 				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제
// 																													// 성공
// 				// target.put(AJAX_SCRIPT,
// 				// "parent.doReturn('DEL','"+BoardMgtID+");parent.$('#isSubmit').remove()");
// 				target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID")
// 						+ "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove()");
// 			}
// 		} catch (Exception e) {
// 			if (_log.isInfoEnabled()) {
// 				_log.info("BoardController::deleteBoard::Error::" + e.toString().replaceAll("\r|\n", ""));
// 			}
// 			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
// 			// target.put(AJAX_ALERT, "삭제중 오류가 발생하였습니다.");
// 			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류
// 																												// 발생
// 		}
// 		model.addAttribute(AJAX_RESULTMAP, target);
// 		model.put("BoardMgtID", BoardMgtID);
// 		// return nextUrl("admin/boardAdmin/boardAdminMgt");
// 		return nextUrl(AJAXPAGE);
// 	}

// 	@RequestMapping(value = "/saveBoardLike.do")
// 	public String saveBoardLike(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
// 		Map setMap = new HashMap();
// 		Map target = new HashMap();

// 		String BoardMgtID = StringUtil.checkNull(cmmMap.get("BoardMgtID"), "");
// 		String BoardID = StringUtil.checkNull(cmmMap.get("BoardID"), "");
// 		String LikeInfo = StringUtil.checkNull(cmmMap.get("likeInfo"), "N");
// 		String screenType = StringUtil.checkNull(cmmMap.get("screenType"));

// 		setMap.put("BoardMgtID", BoardMgtID);

// 		if (BoardID.equals("")) {
// 			BoardID = StringUtil.checkNull(cmmMap.get("boardID"), "");
// 		}

// 		setMap.put("BoardID", BoardID);
// 		setMap.put("sessionUserId", cmmMap.get("sessionUserId"));

// 		try {

// 			if (LikeInfo.equals("Y")) {
// 				commonService.delete("board_SQL.boardLikeDelete", setMap);
// 			} else {
// 				commonService.insert("board_SQL.boardLikeInsert", setMap);
// 			}

// 			// target.put(AJAX_ALERT, "저장이 성공하였습니다.");
// 			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
// 			if (BoardMgtID.equals("4")) {
// 				target.put(AJAX_SCRIPT, "parent.fnCallBack(" + BoardID + ");");
// 			} else {
// 				target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID")
// 						+ "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove();");
// 			}
// 		} catch (Exception e) {
// 			if (_log.isInfoEnabled()) {
// 				_log.info("BoardController::saveLikeBoard::Error::" + e.toString().replaceAll("\r|\n", ""));
// 			}
// 			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
// 			// target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
// 			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
// 		}
// 		model.addAttribute(AJAX_RESULTMAP, target);
// 		// return nextUrl("admin/boardAdmin/boardAdminMgt");
// 		return nextUrl(AJAXPAGE);
// 	}

// 	@RequestMapping(value = "/saveBoardFile.do")
// 	public String saveBoardFile(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
// 		Map target = new HashMap();
// 		try {
// 			Map fileMap = new HashMap();
// 			fileMap.put("BoardMgtID", StringUtil.checkNull(cmmMap.get("mgtId")));
// 			fileMap.put("BoardID", StringUtil.checkNull(cmmMap.get("id")));
// 			fileMap.put("Seq", "0");
// 			fileMap.put("FileNm", StringUtil.checkNull(cmmMap.get("FileNm")));
// 			fileMap.put("FileRealNm", StringUtil.checkNull(cmmMap.get("FileRealNm")));
// 			fileMap.put("FileSize", StringUtil.checkNull(cmmMap.get("FileSize"), "0"));
// 			fileMap.put("FilePath", GlobalVal.FILE_UPLOAD_BOARD_DIR);

// 			commonService.insert("boardFile_SQL.boardFile_insert", fileMap);

// 			// target.put(AJAX_ALERT, "저장이 성공하였습니다.");
// 			// target.put(AJAX_ALERT,
// 			// MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
// 			// // 저장 성공
// 			// target.put(AJAX_SCRIPT,
// 			// "parent.doReturn('DTL','"+BoardMgtID+"','"+cmmMap.get("BoardMgtID")+"','"+cmmMap.get("BoardID")+"');parent.$('#isSubmit').remove();");
// 		} catch (Exception e) {
// 			if (_log.isInfoEnabled()) {
// 				_log.info("BoardController::saveBoardFile::Error::" + e.toString().replaceAll("\r|\n", ""));
// 			}
// 			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
// 		}
// 		model.addAttribute(AJAX_RESULTMAP, target);
// 		// model.put("BoardMgtID", BoardMgtID);

// 		return nextUrl(AJAXPAGE);
// 	}

// 	private String setXML() {
// 		String result = "";

// 		// result="<?xml version='1.0' encoding='UTF-8'?>"+
// 		result = "" + "<rows>" + "<row id='11111' open='1' style='font-weight:bold'>"
// 				+ "	<cell><![CDATA[<img src='/dev_xbolt/cmm/base/images/icon_attach.png'/>text afetr the image]]>Total</cell>"
// 				+ "	<cell>11111</cell>" + "	<cell>22222</cell>" + "	<cell>33333</cell>" + " </row>" + "<row id='2' >"
// 				+ "	<cell image='icon_attach.png'>Music</cell>" + "	<cell>00000</cell>" + "	<cell>22222</cell>"
// 				+ "	<cell>22222</cell>" + " </row>" + "	<row id='3'>"
// 				+ "		<cell image='/dev_xbolt/cmm/base/images/icon_attach.png'>Whatever People Say I Am, That's What I Am Not</cell>"
// 				+ "		<cell>9.78</cell>" + "		<cell>1</cell>" + "		<cell>222222</cell>" + "	</row>"
// 				+ "	<row id='4'>" + "		<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>"
// 				+ "		<cell>9.78</cell>" + "		<cell>1</cell>" + "		<cell>222222</cell>" + "	</row>"
// 				+ "	<row id='5'>" + "		<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>"
// 				+ "		<cell>9.78</cell>" + "		<cell>1</cell>" + "		<cell>222222</cell>" + "	</row>"
// 				+ "	<row id='3'>" + "		<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>"
// 				+ "		<cell>9.78</cell>" + "		<cell>1</cell>" + "		<cell>222222</cell>" + "	</row>"
// 				+ "	<row id='6'>" + "		<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>"
// 				+ "		<cell>9.78</cell>" + "		<cell>1</cell>" + "		<cell>222222</cell>" + "	</row>"
// 				+ "	<row id='7'>" + "		<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>"
// 				+ "		<cell>9.78</cell>" + "		<cell>1</cell>" + "		<cell>222222</cell>" + "	</row>"
// 				+ "	<row id='3'>" + "		<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>"
// 				+ "		<cell>9.78</cell>" + "		<cell>1</cell>" + "		<cell>222222</cell>" + "	</row>"
// 				+ "	<row id='8'>" + "		<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>"
// 				+ "		<cell>9.78</cell>" + "		<cell>1</cell>" + "		<cell>222222</cell>" + "	</row>"
// 				+ "	<row id='9'>" + "		<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>"
// 				+ "		<cell>9.78</cell>" + "		<cell>1</cell>" + "		<cell>222222</cell>" + "	</row>"
// 				+ "</rows>";

// 		return result;
// 	}

// 	@RequestMapping(value = "/mainBoardList.do")
// 	public String mainBoardList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {

// 		String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"));
// 		String mainVersion = StringUtil.checkNull(request.getParameter("mainVersion"));
// 		String replyLev = StringUtil.checkNull(request.getParameter("replyLev"), "0");
// 		String projectID = StringUtil.checkNull(request.getParameter("projectID"));
// 		String listSize = StringUtil.checkNull(request.getParameter("listSize"), "5");
// 		String boardMgtType = StringUtil.checkNull(cmmMap.get("boardMgtType"));
// 		String templProjectID = StringUtil.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap),
// 				"");
// 		Map setMap = new HashMap();
// 		setMap.put("s_itemID", templProjectID);
// 		String templProjectType = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectType", setMap),
// 				"");

// 		String url = "/hom/main/board/mainBoardList";
// 		try {
// 			if ("2".equals(mainVersion)) {
// 				url = "/hom/main/board/mainBoardList_v2";
// 			}
// 			if ("3".equals(mainVersion)) {
// 				url = "/hom/main/board/mainBoardList_v3";
// 			}
// 			if ("4".equals(mainVersion)) {
// 				url = "/hom/main/board/mainBoardList_v4";
// 			}
// 			if ("5".equals(mainVersion)) {
// 				url = "/hom/main/board/mainBoardList_v5";
// 			}

// 			Map setData = new HashMap();
// 			String parentID = "";
// 			String boardGrpID = "";
// 			if (boardMgtType.equals("Y")) { // boardMgtID가 Group 일경우
// 				boardGrpID = BoardMgtID;
// 				BoardMgtID = "";
// 				cmmMap.put("boardGrpID", boardGrpID);
// 			}
// 			cmmMap.put("BoardMgtID", BoardMgtID);
// 			cmmMap.put("viewType", "home");
// 			cmmMap.put("replyLev", replyLev);

// 			cmmMap.put("projectID", templProjectID);
// 			cmmMap.put("projectType", templProjectType);

// 			List brdList = (List) commonService.selectList("board_SQL.boardList_gridList", cmmMap);
// 			String isView = "0";
// 			if (brdList != null && brdList.size() > 0) {
// 				isView = "1";
// 			}
// 			model.put("brdList", brdList);
// 			model.put("isView", isView);
// 			model.put("boardMgtID", BoardMgtID);
// 			model.put("listSize", listSize);
// 			model.put("menu", getLabel(request, commonService)); /* Label Setting */
// 		} catch (Exception e) {
// 			System.out.println(e);
// 			throw new ExceptionUtil(e.toString());
// 		}
// 		return nextUrl(url);
// 	}

// 	@RequestMapping(value = "/mainBoardQnAList.do")
// 	public String mainBoardQnAList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {

// 		String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"));
// 		String mainVersion = StringUtil.checkNull(request.getParameter("mainVersion"));
// 		String replyLev = StringUtil.checkNull(request.getParameter("replyLev"), "0");
// 		String projectID = StringUtil.checkNull(request.getParameter("projectID"));
// 		String listSize = StringUtil.checkNull(request.getParameter("listSize"), "5");
// 		String boardMgtType = StringUtil.checkNull(cmmMap.get("boardMgtType"));
// 		String templProjectID = StringUtil.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap),
// 				"");
// 		Map setMap = new HashMap();
// 		setMap.put("s_itemID", templProjectID);
// 		String templProjectType = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectType", setMap),
// 				"");

// 		String url = "/hom/main/board/mainBoardQnAList";
// 		try {
// 			Map setData = new HashMap();
// 			String parentID = "";
// 			String boardGrpID = "";
// 			if (boardMgtType.equals("Y")) { // boardMgtID가 Group 일경우
// 				boardGrpID = BoardMgtID;
// 				BoardMgtID = "";
// 				cmmMap.put("boardGrpID", boardGrpID);
// 			}
// 			cmmMap.put("BoardMgtID", BoardMgtID);
// 			cmmMap.put("viewType", "home");
// 			cmmMap.put("replyLev", replyLev);

// 			cmmMap.put("projectID", templProjectID);
// 			cmmMap.put("projectType", templProjectType);

// 			List brdList = (List) commonService.selectList("forum_SQL.forumGridList_gridList", cmmMap);
// 			String isView = "0";
// 			if (brdList != null && brdList.size() > 0) {
// 				isView = "1";
// 			}
// 			model.put("brdList", brdList);
// 			model.put("isView", isView);
// 			model.put("boardMgtID", BoardMgtID);
// 			model.put("listSize", listSize);
// 			model.put("menu", getLabel(request, commonService)); /* Label Setting */
// 		} catch (Exception e) {
// 			System.out.println(e);
// 			throw new ExceptionUtil(e.toString());
// 		}
// 		return nextUrl(url);
// 	}

// 	@RequestMapping(value = "/boardAlarmPop.do")
// 	public String boardAlarmPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
// 		String url = "/board/brd/boardAlarmPop";
// 		try {
// 			Map setMap = new HashMap();
// 			setMap.put("viewType", "pop");

// 			Map setMap2 = new HashMap();
// 			setMap2.put("sessionCurrLangType", request.getParameter("languageID"));
// 			setMap2.put("TemplCode", request.getParameter("templCode"));

// 			Map templMap = commonService.select("main_SQL.getPjtInfoFromTEMPL", setMap2);
// 			String templPjtID = StringUtil.checkNull(templMap.get("ProjectID"), "");

// 			if (!"0".equals(templPjtID))
// 				setMap.put("templPjtID", templPjtID);

// 			Map result = commonService.select("board_SQL.boardDetail", setMap);
// 			String content = StringUtil.checkNull(result.get("Content"));
// 			content = StringUtil.replaceFilterString(content);
// 			content = StringEscapeUtils.unescapeHtml4(content);
// 			result.put("Content", content);
// 			model.put("itemFiles", (List) commonService.selectList("boardFile_SQL.boardFile_selectList", result));
// 			model.put(AJAX_RESULTMAP, result);
// 			model.put("menu", getLabel(request, commonService)); /* Label Setting */

// 		} catch (Exception e) {
// 			System.out.println(e);
// 			throw new ExceptionUtil(e.toString());
// 		}
// 		return nextUrl("/board/brd/boardAlarmPop");
// 	}

// 	@RequestMapping(value = "/boardDetailPop.do")
// 	public String boardDetailPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
// 		String noticType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("noticType"), "1"));
// 		try {
// 			// 조회수UPDATE
// 			commonService.update("board_SQL.boardUpdateReadCnt", cmmMap);
// 			Map result = commonService.select("board_SQL.boardDetail", cmmMap);
// 			String boardMgtNM = StringUtil.checkNull(commonService.selectString("board_SQL.getBoardMgtName", cmmMap));
			
// 			Map mgtInfo = commonService.select("board_SQL.getBoardMgtInfo", cmmMap);
// 			String url = StringUtil.checkNull(mgtInfo.get("Url"));
// 			if ("forumMgt".equals(url) ){
// 				Map boardMap = new HashMap();
// 				Map setMap = new HashMap();

// 				setMap.put("boardID", cmmMap.get("BoardID"));
// 				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
// 				setMap.put("sessionUserId", cmmMap.get("sessionUserId"));
// 				boardMap = commonService.select("forum_SQL.getForumEditInfo", setMap);

// 				if (boardMap != null && !boardMap.isEmpty()) {
// 					result.put("ItemID", boardMap.get("ItemID"));
// 					result.put("Path", boardMap.get("Path"));
// 					result.put("ChangeSetID", boardMap.get("BrdChangeSetID"));
// 				}
// 			}

// 			String subject = StringUtil.checkNull(result.get("Subject"));
// 			subject = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(subject));
// 			subject = StringEscapeUtils.unescapeHtml4(subject);

// 			String content = StringUtil.checkNull(result.get("Content"));
// 			content = StringUtil.replaceFilterString(content);

// 			result.put("Subject", subject);
// 			result.put("Content", content);

// 			model.put("itemFiles", (List) commonService.selectList("boardFile_SQL.boardFile_selectList", result));
// 			model.put(AJAX_RESULTMAP, result);
// 			model.put("noticType", noticType);
// 			model.put("boardMgtNM", boardMgtNM);
// 			model.put("menu", getLabel(request, commonService)); /* Label Setting */
// 		} catch (Exception e) {
// 			System.out.println(e);
// 			throw new ExceptionUtil(e.toString());
// 		}
// 		return nextUrl("/popup/boardDetailPop");
// 	}
	
// 	public String chkLimit(Map map) throws Exception{
        
// 		// 같은 user가 1분에 5회 이상 게시글 작성 시 반려처리
// 		Map setData = new HashMap();
// 		String result = "N";
		
// 		String userID = StringUtil.checkNull(map.get("userId"),"");
// 		String boardMgtID = StringUtil.checkNull(map.get("BoardMgtID"),"");
		
// 		LocalDateTime now = LocalDateTime.now();
//         DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
//         LocalDateTime pastTime = now.plusMinutes(-1);
//         String scStartDt = pastTime.format(formatter);
//         String scEndDt = now.format(formatter);
        
//         setData.put("regUserID",userID);
//         setData.put("boardMgtID",boardMgtID);
//         setData.put("scStartDt",scStartDt);
//         setData.put("scEndDt",scEndDt);
        
//         String cnt = commonService.selectString("board_SQL.getBoardLimitChkCNT", setData);
//         if(Integer.parseInt(cnt) >= 5){
//         	result = "Y";
// 		}
        
//         return result;
        
// 	}

// }
