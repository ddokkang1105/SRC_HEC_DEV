// package xbolt.board.frm.web;

// import java.io.File;
// import java.io.Serializable;
// import java.time.LocalDateTime;
// import java.time.format.DateTimeFormatter;
// import java.util.ArrayList;
// import java.util.Arrays;
// import java.util.HashMap;
// import java.util.Iterator;
// import java.util.LinkedHashMap;
// import java.util.List;
// import java.util.Map;
// import java.util.Map.Entry;
// import java.util.function.Function;
// import java.util.stream.Collectors;
// import java.util.stream.Stream;

// import javax.annotation.Resource;
// import javax.servlet.http.HttpServletRequest;
// import javax.servlet.http.HttpServletResponse;
// import javax.servlet.http.HttpSession;

// import org.apache.commons.text.StringEscapeUtils;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.stereotype.Controller;
// import org.springframework.transaction.annotation.Transactional;
// import org.springframework.transaction.interceptor.TransactionAspectSupport;
// import org.springframework.ui.ModelMap;
// import org.springframework.web.bind.annotation.RequestMapping;
// import org.springframework.web.multipart.MultipartHttpServletRequest;

// import com.org.json.JSONObject;

// import xbolt.cmm.controller.XboltController;
// import xbolt.cmm.framework.filter.XSSRequestWrapper;
// import xbolt.cmm.framework.handler.MessageHandler;
// import xbolt.cmm.framework.util.EmailUtil;
// import xbolt.cmm.framework.util.ExceptionUtil;
// import xbolt.cmm.framework.util.FileUtil;
// import xbolt.cmm.framework.util.StringUtil;
// import xbolt.cmm.framework.val.GlobalVal;
// import xbolt.cmm.service.CommonService;
// import xbolt.custom.sk.cmm.XssUtil;
// import xbolt.file.util.FileUploadUtil;

// @Controller
// @SuppressWarnings("unchecked")
// public class HomeForumActionController extends XboltController {
	
// 	@Resource(name = "commonService")
//     private CommonService commonService;
	
// 	@Resource(name = "forumService")
// 	private CommonService forumService;
	
// 	@Autowired
//     private FileUploadUtil fileUploadUtil;
	
// 	@RequestMapping(value = "/forumMgt.do")
// 	public String forumMgt(HttpServletRequest request, HashMap commanMap, ModelMap model) throws Exception {
// 		String ID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
// 		String myBoard = StringUtil.checkNull(request.getParameter("myBoard"));
// 		String itemID = StringUtil.checkNull(commanMap.get("s_itemID"),"");
// 		String varFilter = StringUtil.checkNull(request.getParameter("varFilter"), "4");
// 		String mailRcvListSQL = StringUtil.checkNull(request.getParameter("mailRcvListSQL"), "");
// 		String emailCode = StringUtil.checkNull(request.getParameter("emailCode"), "");
// 		String srID = StringUtil.checkNull(request.getParameter("srID"), "");
// 		String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"), "");
// 		String isProcInst = StringUtil.checkNull(request.getParameter("isProcInst"), "");
// 		String elmInstNo = StringUtil.checkNull(request.getParameter("elmInstNo"), "");		
// 		String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
// 		String boardMgtID = StringUtil.checkNull(request.getParameter("boardMgtID"));
// 		String showItemInfo = StringUtil.checkNull(request.getParameter("showItemInfo"));
// 		String dueDateMgt = StringUtil.checkNull(request.getParameter("dueDateMgt"), "");
// 		String replyMailOption = StringUtil.checkNull(request.getParameter("replyMailOption"), "");
// 		String forumMailOption = StringUtil.checkNull(request.getParameter("forumMailOption"), "");
// 		String showReplyDT = StringUtil.checkNull(request.getParameter("showReplyDT"), "");
// 		String showAuthorInfo = StringUtil.checkNull(request.getParameter("showAuthorInfo"), "");
// 		String showItemVersionInfo = StringUtil.checkNull(request.getParameter("showItemVersionInfo"), "");
// 		String openDetailSearch = StringUtil.checkNull(request.getParameter("openDetailSearch"), "");
		
// 		if(!elmInstNo.equals("")) { instanceNo = elmInstNo;	}
// 		if(!boardMgtID.equals("")) {
// 			model.put("BoardMgtID", boardMgtID);
// 			} else {
// 				model.put("BoardMgtID", varFilter); 
// 			}
		
// 		String isItem = "N";

// 		if(!itemID.equals("")){ isItem = "Y";}
// 		model.put("noticType", varFilter);
// 		model.put("emailCode", emailCode);
// 		model.put("mailRcvListSQL", mailRcvListSQL);
// 	//	model.put("BoardMgtID", varFilter);
// 		model.put("s_itemID", ID.trim());
// 		model.put("myBoard", myBoard);
// 		model.put("isItem", isItem);
// 		model.put("srID", srID);
// 		model.put("isProcInst", isProcInst);
// 		model.put("instanceNo", instanceNo);
// 		model.put("projectID", projectID);
// 		model.put("showItemInfo", showItemInfo);
// 	    model.put("dueDateMgt", dueDateMgt);
// 	    model.put("replyMailOption",replyMailOption);
// 	    model.put("forumMailOption",forumMailOption);
// 	    model.put("showReplyDT",showReplyDT);
// 	    model.put("openDetailSearch",openDetailSearch);
// 	    model.put("showAuthorInfo",showAuthorInfo);
// 	    model.put("showItemVersionInfo",showItemVersionInfo);
	    
// 		model.put("menu", getLabel(request, commonService));
		
// 		// 팝업에서 상세페이지로 바로 이동하는 옵션
// 		String goDetailOpt = StringUtil.checkNull(request.getParameter("goDetailOpt"),"");
// 		if("Y".equals(goDetailOpt)){
// 			String boardID = StringUtil.checkNull(request.getParameter("boardID"));
// 			model.put("boardID", boardID);
// 		}
// 		model.put("goDetailOpt", goDetailOpt);
		
// 		return nextUrl("/board/frm/boardForumMgt");
// 	}

// 	@RequestMapping(value = "/boardForumList.do")
// 	public String boardForumList(HttpServletRequest request, HashMap commanMap, ModelMap model) throws Exception {
// 		try {
// 			Map mapValue = new HashMap();
// 			Map setMap = new HashMap();
// 			List getList = new ArrayList();
// 			String noticType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("noticType"), ""));
// 			String ID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("s_itemID"), ""));
// 			String pageNum = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("pageNum"),"1"));
// 			String s_itemID = StringUtil.replaceFilterString(StringUtil.checkNull( request.getParameter( "s_itemID" ),""));
// 			String myBoard = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("myBoard")));
// 			String BoardMgtID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("BoardMgtID")));
// 			String screenType = StringUtil.replaceFilterString(StringUtil. checkNull(request.getParameter("screenType")));
// 			String projectID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectID")));
// 			String templProjectID = StringUtil.checkNull(commonService.selectString("board_SQL.getTemplProjectID", commanMap),"");
// 			String scStartDt = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("scStartDt"), ""));
// 			String scEndDt = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("scEndDt"), ""));
// 			String category = StringUtil.replaceFilterString(StringUtil.checkNull(commanMap.get("category")));
// 			String categoryIndex = StringUtil.replaceFilterString(StringUtil.checkNull(commanMap.get("categoryIndex")));			
// 			String categoryCnt =  StringUtil.checkNull(commonService.selectString("board_SQL.getBoardMgtCatCNT", commanMap),"");
// 			String searchType = StringUtil.replaceFilterString(StringUtil.checkNull(commanMap.get("searchType")));
// 			String listType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("listType")));
// 			String srID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("srID")));
// 			String instanceNo = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("instanceNo"),""));
// 			String isProcInst = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("isProcInst"),""));
// 			String emailCode = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("emailCode"),""));
// 			String mailRcvListSQL = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("mailRcvListSQL"),""));
// 			String showItemInfo = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("showItemInfo"),""));
// 			String regUserName = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("regUserName"),""));
// 			String authorName = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("authorName"),""));
// 			String scrnType =StringUtil.replaceFilterString( StringUtil.checkNull(request.getParameter("scrnType"),""));
// 			String srType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("srType"),""));
// 			String defCategory = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("defCategory"),""));
// 			String boardTitle = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("boardTitle"),""));
// 			String dueDateMgt = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("dueDateMgt"),""));
// 			String replyMailOption = StringUtil.checkNull(request.getParameter("replyMailOption"), "");
// 			String forumMailOption = StringUtil.checkNull(request.getParameter("forumMailOption"), "");
// 			String showReplyDT = StringUtil.checkNull(request.getParameter("showReplyDT"), "");
// 			String openDetailSearch = StringUtil.checkNull(request.getParameter("openDetailSearch"), "");
// 			String showAuthorInfo = StringUtil.checkNull(request.getParameter("showAuthorInfo"), "");
// 			String showItemVersionInfo = StringUtil.checkNull(request.getParameter("showItemVersionInfo"), "");
// 			//String identifier = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("identifier"),""));
// 			//String docTitle = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("docTitle"),""));
// 			//String itemVersion = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("itemVersion"),""));
			
			
// 			if(!"".equals(templProjectID) && instanceNo.equals("") ) {
// 				projectID = templProjectID;
// 			}
						
// 			mapValue.put("languageID", request.getParameter("languageID"));
// 			mapValue.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode"),""));
// 			mapValue.put("search", StringUtil.checkNull(request.getParameter("search"),""));
// 			mapValue.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue"),""));
// 			if ("Y".equals(myBoard)) {
// 				mapValue.put("myID", commanMap.get("sessionUserId"));
// 				model.put("myID", commanMap.get("sessionUserId"));
// 			}
			
// 			setMap.put("BoardMgtID", BoardMgtID);
// 			setMap.put("languageID", commanMap.get("sessionCurrLangType"));
// 			Map boardMgtInfo = commonService.select("board_SQL.getBoardMgtInfo", setMap);
			
// 			List brdCatList = commonService.selectList("common_SQL.getBoardMgtCategory_commonSelect", setMap);
			
// 			setMap.put("s_itemID", s_itemID);
// 			Map ItemMgtUserMap = commonService.select("forum_SQL.getItemAuthorName", setMap);
			
// 			if(boardTitle.equals("")) {
// 		    	 boardTitle = StringUtil.checkNull(boardMgtInfo.get("boardMgtName"),"");
// 			}
			
// 			Map<String, Serializable> ItemCsInfoMap = commonService.select("cs_SQL.getItemCsInfo",setMap);
// 			//gridData
// //			List boardFList = commonService.selectList("forum_SQL.forumGridList_gridList", setMap);
// // 	 		JSONArray gridData = new JSONArray(boardFList);
// // 	 		model.put("gridData",gridData);
			
			
// 			model.put("ItemCsInfoMap", ItemCsInfoMap);
// 			model.put("boardMgtInfo", boardMgtInfo);
// 			model.put("boardTitle", boardTitle);
// 			model.put("ItemMgtUserMap", ItemMgtUserMap);
// 			model.put("s_itemID", s_itemID);
// 			model.put("noticType", noticType);
// 			model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode"),""));
// 			model.put("search", StringUtil.checkNull(request.getParameter("search"),""));
// 			model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue"),""));
// 			//model.put("myID", StringUtil.checkNull(request.getParameter("myID"),""));
// 			model.put("pageNum", pageNum);
// 			model.put("itemID", commanMap.get("s_itemID"));
// 			model.put("myBoard", myBoard);
// 			model.put("BoardMgtID", BoardMgtID);
// 			getList = commonService.selectList("forum_SQL.forumSelect", mapValue );
// 			model.put("selectList", getList);
// 			model.put("screenType", screenType);
// 			model.put("projectID", projectID);
// 			model.put("scStartDt",scStartDt);
// 			model.put("scEndDt",scEndDt);
// 			model.put("brdCatList", brdCatList);
// 			model.put("category", category);
// 			model.put("categoryIndex", categoryIndex);
// 			model.put("categoryCnt", categoryCnt);
// 			model.put("brdCatListCnt", brdCatList.size());
// 			model.put("searchType", searchType);
// 			model.put("listType", listType);
// 			model.put("srID", srID);
// 			model.put("isProcInst", isProcInst);
// 			model.put("instanceNo", instanceNo);
// 			model.put("mailRcvListSQL", mailRcvListSQL);
// 			model.put("emailCode", emailCode);
// 			model.put("showItemInfo", showItemInfo);
// 			model.put("regUserName", regUserName);
// 			model.put("authorName", authorName);
// 			model.put("scrnType", scrnType);
// 			model.put("srType", srType);
// 			model.put("defCategory", defCategory);
// 			model.put("dueDateMgt", dueDateMgt);
// 		    model.put("replyMailOption",replyMailOption);
// 		    model.put("forumMailOption",forumMailOption);
// 		    model.put("showReplyDT",showReplyDT);
// 		    model.put("openDetailSearch",openDetailSearch);
// 		    model.put("showAuthorInfo",showAuthorInfo);
// 		    model.put("showItemVersionInfo",showItemVersionInfo);
			
// 			model.put("baseUrl", GlobalVal.BASE_ATCH_URL);
// 			model.put("menu", getLabel(request, commonService));
	
// 			// SR Option
// 			if(srID!="" && !"".equals(srID)){
// 				// 검색조건 Setting
// 				model.put("srCategory", StringUtil.checkNull(request.getParameter("srCategory")));
// 				model.put("srArea1", StringUtil.checkNull(request.getParameter("srArea1")));
// 				model.put("subject", StringUtil.checkNull(request.getParameter("subject")));
// 				model.put("searchStatus", StringUtil.checkNull(request.getParameter("searchStatus")));
// 				model.put("receiptUser", StringUtil.checkNull(request.getParameter("receiptUser")));
// 				model.put("requestUser", StringUtil.checkNull(request.getParameter("requestUser")));
// 				model.put("requestTeam", StringUtil.checkNull(request.getParameter("requestTeam")));
// 				model.put("startRegDT", StringUtil.checkNull(request.getParameter("startRegDT")));
// 				model.put("endRegDT", StringUtil.checkNull(request.getParameter("endRegDT")));
// 				model.put("searchSrCode", StringUtil.checkNull(request.getParameter("searchSrCode")));
// 				model.put("srReceiptTeam", StringUtil.checkNull(request.getParameter("srReceiptTeam")));
// 				model.put("srMode", StringUtil.checkNull(request.getParameter("srMode")));
// 			}
			
// 		} catch (Exception e) {
// 			System.out.println(e.toString());
// 		}

// 		return nextUrl("/board/frm/boardForumList");
// 	}

	
// 	// Save new forum board //
// 	@Transactional(rollbackFor = Exception.class)
// 	@RequestMapping(value = "/saveForumPost.do")
// 	public String saveForumPost(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
// 		Map target = new HashMap();
// 		XSSRequestWrapper xss = new XSSRequestWrapper(request);
// 		String errorMessage = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068");
		
// 		try {
// 			for (Iterator i = commandMap.entrySet().iterator(); i.hasNext();) {
// 			    Entry e = (Entry) i.next(); // not allowed
// 			    if(!e.getKey().equals("loginInfo") && e.getValue() != null) {
// 			    	commandMap.put(e.getKey(), xss.stripXSS(e.getValue().toString()));
// 			    }
// 			}
			
// 			String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"), "");
// 			String mailRcvListSQL = StringUtil.checkNull(commandMap.get("mailRcvListSQL"), "");
// 			model.put("mailRcvListSQL", mailRcvListSQL);
// 			String emailCode = StringUtil.checkNull(commandMap.get("emailCode"), "");
// 			String projectID = StringUtil.checkNull(xss.getParameter("projectID"),"");
// 			String screenType = StringUtil.checkNull(xss.getParameter("screenType"),"");
// 			String templProjectID = StringUtil.checkNull(commonService.selectString("board_SQL.getTemplProjectID", commandMap),"");
// 			String relTeamMembers = "";
// 			String rctMemberID = "";
// 			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
// 			String blocked =StringUtil.checkNull(commandMap.get("blocked"), "");
// 			String dueDateMgt = StringUtil.checkNull(commandMap.get("dueDateMgt"), "");
// 			String forumMailOption = StringUtil.checkNull(commandMap.get("forumMailOption"), "");
// 			String showReplyDT = StringUtil.checkNull(commandMap.get("showReplyDT"), "");
// 			String openDetailSearch = StringUtil.checkNull(commandMap.get("openDetailSearch"), "");
// 			model.put("dueDateMgt", dueDateMgt);
// 			// 화면 표시 메뉴 Map 취득
// 			Map setMap = new HashMap();
// 			Map setMap2 = new HashMap();
// 			setMap.put("languageID", languageID);
// 			setMap.put("itemID", s_itemID);
// 			setMap.put("s_itemID", s_itemID);
// 			List selectList = commonService.selectList("forum_SQL.forumSelect", setMap);
// 			model.put("selectList", selectList);
// 			model.put("s_itemID", s_itemID);
			
// 			String userId = String.valueOf(commandMap.get("sessionUserId"));
// 			String subject = StringUtil.checkNull(xss.getParameter("subject"), "");
// 			subject = StringUtil.replaceFilterString(subject);
// 			String content = StringUtil.checkNull(commandMap.get("content"), "");
// 			content = StringUtil.replaceFilterString(content);
// 			content = XssUtil.xssCustomFilter(content);
			
// 			String BoardMgtID = StringUtil.checkNull(xss.getParameter("BoardMgtID"));
// 			String ItemMgtUserID = StringUtil.checkNull(xss.getParameter("ItemMgtUserID"));;
// 			String Category = StringUtil.checkNull(xss.getParameter("category"),"");
// 			String srID = StringUtil.checkNull(xss.getParameter("srID"),"");
// 			String instanceNo = StringUtil.checkNull(xss.getParameter("instanceNo"),"");
// 			String sharers = StringUtil.checkNull(xss.getParameter("sharers"),"");
// 			String sharerNames = StringUtil.checkNull(xss.getParameter("sharerNames"),"");
// 			String SC_END_DT = StringUtil.checkNull(xss.getParameter("SC_END_DT"),"");
// 			String reviewDept = StringUtil.checkNull(xss.getParameter("reviewDept"),"");
			
// 			Map changeSetInfo = commonService.select("report_SQL.getItemInfo", setMap);
// 			String changeSetID = StringUtil.checkNull(changeSetInfo.get("CurChangeSet"));
			
// 			String boardMgtName = StringUtil.checkNull(xss.getParameter("boardMgtName"),"");
			
// 			setMap2.put("BoardMgtID", BoardMgtID);

// 			Map boardMgtInfo = commonService.select("board_SQL.getBoardMgtInfo", setMap2);
			
// 			String postEmailYN = StringUtil.checkNull(boardMgtInfo.get("PostEmailYN"));
// 			String mgtOnlyYN = StringUtil.checkNull(boardMgtInfo.get("MgtOnlyYN"));
// 			String mgtUserID = StringUtil.checkNull(boardMgtInfo.get("MgtUserID"));
// 			String mgtGRID = StringUtil.checkNull(boardMgtInfo.get("MgtGRID"));
			
// 			String replyLev = StringUtil.checkNull(xss.getParameter("replyLev"), "0");
			
// 			if(instanceNo.equals("")) {
// 				if(!s_itemID.equals("") && !screenType.equals("mainV3")){
// 					projectID = commonService.selectString("forum_SQL.getProjectIDFromItem", setMap);
// 				}
// 				if(!"".equals(templProjectID)) {
// 					projectID = templProjectID;
// 				}
// 			}
			
// 			String BoardID = commonService.selectString("forum_SQL.boardNextVal", new HashMap());
			
// 			Map insertValMap = new HashMap();
// 			Map insertInfoMap = new HashMap();
// 			List insertList = new ArrayList();
			
// 			String sessionAuthLev = StringUtil.checkNull(commandMap.get("sessionAuthLev"), "");
// 			String writeYN = "N";
// 			if ("N".equals(mgtOnlyYN) && Integer.parseInt(mgtGRID) > 0) {
// 				Map tmpMap = new HashMap();
// 				tmpMap.put("checkID", userId);
// 				tmpMap.put("groupID", mgtGRID);
// 				String check = StringUtil.checkNull(commonService.selectString("user_SQL.getEndGRUser", tmpMap), "");

// 				if (!"".equals(check)) {
// 					boardMgtInfo.put("MgtGRID2", mgtGRID);
// 				} else {
// 					boardMgtInfo.put("MgtGRID2", "");
// 				}
// 			}
// 			String mgtGRID2 = StringUtil.checkNull(boardMgtInfo.get("MgtGRID2"));
						
// 			if((mgtOnlyYN.equals("Y") && mgtUserID.equals(userId)) 
// 				|| (mgtOnlyYN.equals("Y") && ( "".equals(mgtUserID) || mgtUserID == null))
// 				|| (!mgtOnlyYN.equals("Y") && mgtGRID.equals(mgtGRID2))
// 				|| (!mgtOnlyYN.equals("Y") && Integer.parseInt(mgtGRID) < 1 && Integer.parseInt(sessionAuthLev) <= 2)
// 			){
// 				writeYN = "Y";
// 			}else if( !mgtOnlyYN.equals("Y")) {
// 				writeYN = "Y";
// 			}
			
// 			insertValMap.put("userId", userId);
// 			insertValMap.put("BoardMgtID", BoardMgtID);
// 			String chkLimit = chkLimit(insertValMap);
			
// 			if(writeYN.equals("N")){		
// 				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00033"));
// 				target.put(AJAX_SCRIPT, "parent.doReturn();parent.$('#isSubmit').remove();");
// 			}else if("Y".equals(chkLimit)){
// 				// 유저가 1분내에 5번 이상 글을 등록할 수 없다. 
// 				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
// 				target.put(AJAX_SCRIPT, "parent.doReturn();parent.$('#isSubmit').remove();");
// 			}else {			
// 				insertValMap.put("subject", subject);
// 				insertValMap.put("content", content);
// 				insertValMap.put("boardID", BoardID);
// 				insertValMap.put("s_itemID", s_itemID);
// 				insertValMap.put("replyLev", replyLev);
// 				insertValMap.put("refID", BoardID);
// 				insertValMap.put("projectID", projectID); // Item의 ProjectID의 ParentID
// 				insertValMap.put("ItemMgtUserID",ItemMgtUserID);
// 				insertValMap.put("Category",Category);
// 				insertValMap.put("srID",srID);
// 				insertValMap.put("instanceNo",instanceNo);
// 				insertValMap.put("changeSetID",changeSetID);
// 				insertValMap.put("blocked", blocked);
// 				insertList.add(insertValMap);
		
// 				insertInfoMap.put("KBN", "insert");
// 				insertInfoMap.put("SQLNAME", "forum_SQL.forumInsert");
// 				// [TB_BOARD]테이블에 데이터 추가
// 				forumService.save(insertList, insertInfoMap);
				
// 				// file upload 공통 사용
// 				Map fileUploadMap = new HashMap();
// 				String uploadToken = StringUtil.checkNull(commandMap.get("uploadToken"), "");
// 				commandMap.put("type","BOARD");
// 				commandMap.put("uploadToken",uploadToken);
// 				commandMap.put("BoardMgtID",BoardMgtID);
// 				commandMap.put("BoardID",BoardID);
// 				commandMap.put("projectID",projectID);
// 				fileUploadMap = fileUploadUtil.fileUpload(commandMap, request);
				
// 				boolean fileUploadResult = (boolean) fileUploadMap.getOrDefault("result",false);
// 				if(!fileUploadResult) {
// 					errorMessage = StringUtil.checkNull(fileUploadMap.get("message"),"파일 업로드 실패");
// 					throw new Exception(errorMessage);
// 				}
				
			
// 			Map mapValue = new HashMap();
// 			List getList = new ArrayList();
			
// 			mapValue.put("s_itemID",s_itemID);
// 			getList = setTotalScore(commonService.selectList("forum_SQL.forumGridList_gridList", mapValue));
// 			String total_cnt = commonService.selectString("forum_SQL.forumTotalCnt", mapValue);
// 			selectList = commonService.selectList("forum_SQL.forumSelect", new HashMap() );
			
// 			model.put("total_cnt", total_cnt);
// 			model.put("s_itemID", s_itemID);
// 			model.put("BoardMgtID", BoardMgtID);
// 			model.put("selectList", selectList );
// 			model.put("getList", getList);
// 			model.put("BoardMgtID", 4);
// 			Map menu = getLabel(request, commonService);
// 			model.put("menu", menu);
// 			model.put("screenType", screenType);
// 			model.put("projectID", projectID);
// 			model.put("showReplyDT",showReplyDT);
// 			model.put("openDetailSearch",openDetailSearch);
// 			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
// 			target.put(AJAX_SCRIPT, "parent.doReturn();parent.$('#isSubmit').remove();");
			
// 			// Sending mail Start
			
// 			if("Y".equals(postEmailYN) || "M".equals(postEmailYN)) {
				
// 				HashMap setMailData = new HashMap();
// 				List<Map<String, Object>> receiverList = new ArrayList();
// 				HashMap<String, Object> tempMap = new HashMap<String, Object>();	
// 				HashMap mailInfo = new HashMap();
// 				//String receiverListString = "";
// 				String itemName = "";
// 				String pLabelName = "";
// 				int idCnt = 0;
// 				int mailIndex = 0;
				
// 				// Receiver List processing	Start	
				
// 				if(mailRcvListSQL.equals("") || mailRcvListSQL.equals(null) ) {
// 					if(s_itemID != null && !"".equals(s_itemID)) { 
// 						String ItemAuthorID =  commonService.selectString("item_SQL.getItemAuthorId", setMap);	//아이템 담당자 
// 						setMap.put("MemberID", ItemAuthorID);
// 						setMap.put("languageID", languageID);
// 						mailInfo = (HashMap) commonService.select("user_SQL.selectUser",setMap);
// 						tempMap.put("receiptUserID", ItemAuthorID);				
// 						receiverList.add(mailIndex++,tempMap);	
						
// 						setMap.put("itemID", s_itemID);
// 						setMap.put("assignmentType", "CNGROLETP");
// 						List roleAssignedMbrList = new ArrayList();
// 						if("1".equals(forumMailOption)){
// 							// CMM - assigned = 1인 변경 담당자 모두
// 							setMap.put("assigned", "1");
// 							setMap.put("isAll", "N");
// 							roleAssignedMbrList = commonService.selectList("role_SQL.getAssignedRoleList_gridList", setMap);
// 						} else {
// 							// CMM - AccessRight : U 인 담당자 + 프로세스 담당자 참조설정
// 							roleAssignedMbrList = commonService.selectList("item_SQL.getAssignmentMemberList", setMap);
// 						}
						
// 						for(int i = 0; i < roleAssignedMbrList.size(); i++){
// 							Map roleAssignedMbr = (Map) roleAssignedMbrList.get(i);
// 							String assignedMbrID = StringUtil.checkNull(roleAssignedMbr.get("MemberID"));
// 							if(!ItemAuthorID.equals(assignedMbrID)){
// 								tempMap = new HashMap();
// 								tempMap.put("receiptUserID", assignedMbrID); //참조
// 								tempMap.put("receiptType", "CC");
// 								receiverList.add(mailIndex++,tempMap);							
// 							}
// 						}
// 					} else {   //if item is not assigned , send mail to board manager // item 없는  일반 문의 게시판						
// 						tempMap = new HashMap();
// 						tempMap.put("receiptUserID", mgtUserID); //수신				
// 						receiverList.add(mailIndex++,tempMap);
// 					}
// 				}else {
// 					if(mailRcvListSQL.equals("manual")||mailRcvListSQL.equals("review")) {
						
// 						// 검토자
// 						String[] sharer = sharers.split(",");
// 						for(int i=0; i<sharer.length; i++){
// 							tempMap = new HashMap();
// 							tempMap.put("receiptUserID", sharer[i]); //수신
// 							receiverList.add(mailIndex++,tempMap);
// 						}
// 						// review 일 경우 아이템 담당자 추가
// 						if(mailRcvListSQL.equals("review") && (s_itemID != null && !"".equals(s_itemID))){
// 							tempMap = new HashMap();
// 							String ItemAuthorID =  commonService.selectString("item_SQL.getItemAuthorId", setMap);	//아이템 담당자 
// 							setMap.put("MemberID", ItemAuthorID);
// 							setMap.put("languageID", languageID);
// 							mailInfo = (HashMap) commonService.select("user_SQL.selectUser",setMap);
// 							tempMap.put("receiptUserID", ItemAuthorID);				
// 							receiverList.add(mailIndex++,tempMap);	
// 						}
// 					}else {						
// 						String itemTypeCode = commonService.selectString("item_SQL.selectedItemTypeCode", setMap);
// 						String itemClassCode = commonService.selectString("item_SQL.selectedItemClassCode", setMap);						
// 						setMap.put("itemTypeCode", itemTypeCode);
// 						setMap.put("itemClassCode", itemClassCode);
						
// 						List memberList = new ArrayList();
// 						setMap.put("assigned", "1");					
				
// 					//	setMap.put("cxnCode", "CNL0201A");	
// 						memberList = commonService.selectList(mailRcvListSQL, setMap);
					
// 						for(int k=0; k<memberList.size(); k++) {
// 							tempMap = new HashMap();
// 							rctMemberID = StringUtil.checkNull(((Map)memberList.get(k)).get("rctMemberID"));
// 							if(!rctMemberID.equals("")) {
// 								tempMap.put("receiptUserID", rctMemberID) ;
// 								receiverList.add(mailIndex++,tempMap);
// 							}
// 							relTeamMembers += ((Map)memberList.get(k)).get("rctMemberNM") +"(" + ((Map)memberList.get(k)).get("TeamNM") + ")";
// 							if(memberList.size() != 1 && k != memberList.size()-1 ) {
// 								relTeamMembers += ", ";
// 							}
// 						}
// 					}								
// 				}	
// 				// item assigned board  추가 처리
				
// 				if(s_itemID != null && !"".equals(s_itemID)) {
// 					if(mgtUserID != null && !"".equals(mgtUserID)){
// 						tempMap = new HashMap();
// 						tempMap.put("receiptUserID", mgtUserID); 	
// 						tempMap.put("receiptType", "CC");
// 						receiverList.add(mailIndex++,tempMap);
// 					}	
// 					itemName = commonService.selectString("item_SQL.getItemInfoHeader", setMap);					
// 					setMap.put("languageID", languageID);
// 					pLabelName = commonService.selectString("item_SQL.getItemClassName", setMap);
// 				}
				
// 				if("1".equals(forumMailOption)){
// 					// 수신자 : 글 작성자 추가
// 					tempMap = new HashMap();
// 					tempMap.put("receiptUserID", userId);
// 					receiverList.add(mailIndex++,tempMap);
// 				} else if("2".equals(forumMailOption)){
// 					// 수신자 : only 글 작성자
// 					// 참조자 : 게시판 관리자
// 					receiverList.clear();
// 					mailIndex = 0;
					
// 					tempMap = new HashMap();
// 					tempMap.put("receiptUserID", userId);
// 					receiverList.add(mailIndex++,tempMap);
					
// 					if(mgtUserID != null && !"".equals(mgtUserID)){
// 						tempMap = new HashMap();
// 						tempMap.put("receiptUserID", mgtUserID); 	
// 						tempMap.put("receiptType", "CC");
// 						receiverList.add(mailIndex++,tempMap);
// 					}
// 				}
				
// 				// Receiver List processing	End	
				
// 				if(receiverList.size() > 0) {
					
// 					// Sending mail
					
// 					// 중복 수신자 제거
// 					receiverList = filterDuplicateReceiptUsers(receiverList);
					
// 					// 만약 이메일 코드 없을 경우 BRDMAIL 고정
// 			        if(emailCode.equals("")){						
// 						emailCode = "BRDMAIL";
// 					}
// 					String originEmailCode = emailCode;
					
// 					// 특정 제목과 form을 사용하고싶은 경우 ( * 단 base가 되는 emailForm이 있어야 사용가능. form자체가 너무 다른 경우 makeEmailContents에 등록 후 varFilter가 아닌 emailCode를 변경해서 사용해야함 )
// 					String mgtVarfilter = StringUtil.checkNull(boardMgtInfo.get("VarFilter"));
// 					if(!"".equals(mgtVarfilter)){
// 						Map varFilterMap = getQueryParams(mgtVarfilter);
// 				        if(varFilterMap.containsKey("emailCode")){
// 				        	emailCode = StringUtil.checkNull(varFilterMap.get("emailCode"));
// 				        }
// 					}
					
// 					Map temp = new HashMap();
// 					temp.put("Category", "EMAILCODE");
// 					temp.put("TypeCode", emailCode);
// 					temp.put("LanguageID", languageID);			
// 					setMailData.put("subject", subject);
// 					setMailData.put("receiverList",receiverList);	
// 					setMailData.put("languageID",languageID);
					
// 					Map setMailMap = (Map)setEmailLog(request, commonService, setMailData, emailCode);
					
// 					if(StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")){
// 						HashMap mailMap = (HashMap)setMailMap.get("mailLog");	
// 						HashMap regUInfo = new HashMap();
							
// 						setMap.clear();
// 						setMap.put("MemberID", userId);
// 						setMap.put("languageID", commandMap.get("sessionCurrLangType"));
// 						regUInfo = (HashMap) commonService.select("user_SQL.selectUser",setMap);
						
// 						mailInfo.put("content", content);	
// 						mailInfo.put("regUInfo", regUInfo);	
// 						mailInfo.put("subject", subject);	
// 						mailInfo.put("boardID", BoardID);
// 						mailInfo.put("itemName", itemName);
// 						mailInfo.put("pLabelName", pLabelName);
// 						mailInfo.put("itemID", s_itemID);
// 						mailInfo.put("languageID", commandMap.get("sessionCurrLangType"));
// 						mailInfo.put("loginID", commandMap.get("sessionLoginId"));
// 						mailInfo.put("boardMgtName", boardMgtName);
// 						mailInfo.put("relTeamMembers", relTeamMembers);
// 						mailInfo.put("emailCode", emailCode);
// 						mailInfo.put("changeSetID", changeSetID);
						
// 						// board Category 정보
// 						String categoryNM = StringUtil.checkNull(xss.getParameter("categoryNM"),"");
// 						mailInfo.put("categoryNM", categoryNM);
						
// 						// 검토자 정보
// 						mailInfo.put("sharerNames", sharerNames);
						
// 						mailInfo.put("title", boardMgtName + menu.get("LN00334"));
// 						mailInfo.put("SC_END_DT", SC_END_DT);
				        
// 				        String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", mailInfo));
// 						mailInfo.put("emailHTMLForm", emailHTMLForm);
						
// 						// emailCode원복
// 						mailInfo.put("emailCode",originEmailCode);
// 						mailMap.put("dicTypeCode",originEmailCode);
						
// 						Map resultMailMap = EmailUtil.sendMail(mailMap,mailInfo,getLabel(request, commonService));
// 						System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMap.get("type")));
						
// 					 }else{ 
// 						System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMap.get("msg")));
// 					 }					
										
// 					// Receiver List --> My Schedule 등록
// 					if((mailRcvListSQL != null && !"".equals(mailRcvListSQL))||"Y".equals(dueDateMgt)) {				
// 						HashMap scheduleMap = new HashMap();
// 						setMap = new HashMap();
// 						scheduleMap.put("scheduleId", commonService.selectString("schedule_SQL.schedulNextVal", setMap));
// 						scheduleMap.put("DocCategory", "BRD");
// 						setMap.put("boardID", BoardID);
// 						setMap.put("languageID", languageID);
// 						setMap.put("sessionUserId", userId);
// 						Map boardMap = commonService.select("forum_SQL.getForumEditInfo", setMap);
// 						scheduleMap.put("StartDT", boardMap.get("RegDT"));
// 						scheduleMap.put("EndDT", SC_END_DT);
// 						scheduleMap.put("Subject", subject);
// 						scheduleMap.put("Content", content);
// 						scheduleMap.put("userId", userId);
// 						scheduleMap.put("templCode", "");
// 						scheduleMap.put("location", "");
// 						scheduleMap.put("projectID", "");
// 						scheduleMap.put("startAlarm", "");
// 						scheduleMap.put("alarmOption", "");
// 						scheduleMap.put("documentID", BoardID);
// 						scheduleMap.put("sharerId", userId);
// 						scheduleMap.put("reviewDept", reviewDept);
// 						scheduleMap.put("disclScope", "SHR");
// 						commonService.insert("schedule_SQL.schdlDetailInsert", scheduleMap);
// 						commonService.update("schedule_SQL.mySchdlInsert", scheduleMap);
						
// 						for(int i=0; i<receiverList.size(); i++){
							
// 							String sharerID = StringUtil.checkNull(((Map)(receiverList.get(i))).get("receiptUserID"));
// 							String receiptType = StringUtil.checkNull(((Map)(receiverList.get(i))).get("receiptType"));
						
// 							if(!"CC".equals(receiptType) && !sharerID.equals(userId)){						
// 									scheduleMap.put("sharerId", sharerID);
// 									commonService.update("schedule_SQL.mySchdlInsert", scheduleMap);
// 							}
// 						}
// 					}
// 				 } 
// 			}
// 		}	
			
// 			// Mail processing End			
// 		} catch (Exception e) {
// 			System.out.println(e);
// 			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
// 			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
// 			target.put(AJAX_ALERT, errorMessage); // 오류 발생
// 		}
// 		model.addAttribute(AJAX_RESULTMAP, target);		
// 		return nextUrl(AJAXPAGE);
// 	}
// 	// input new forum board //
// 	@RequestMapping(value = "/registerForumPost.do")
// 	public String registerForumPost(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
// 		try {
// 			String ID = StringUtil.checkNull(request.getParameter("s_itemID"), ""); 
// 			String noticType = StringUtil.checkNull(request.getParameter("noticType"), ""); 
// 			String isMyCop = StringUtil.checkNull(request.getParameter("isMyCop"));
// 			String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"));
// 			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
// 			String srID = StringUtil.checkNull(request.getParameter("srID"));
// 			String srType = StringUtil.checkNull(request.getParameter("srType"));
// 			String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"));
// 			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
// 			String mailRcvListSQL = StringUtil.checkNull(request.getParameter("mailRcvListSQL"));
// 			String emailCode = StringUtil.checkNull(request.getParameter("emailCode"));
// 			String showItemInfo = StringUtil.checkNull(request.getParameter("showItemInfo"));
// 			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"),"");
// 			String boardTitle = StringUtil.checkNull(request.getParameter("boardTitle"),"");
// 			String dueDateMgt = StringUtil.checkNull(request.getParameter("dueDateMgt"), "");
// 			String forumMailOption = StringUtil.checkNull(request.getParameter("forumMailOption"), "");
// 			String showReplyDT = StringUtil.checkNull(request.getParameter("showReplyDT"), "");
// 			String openDetailSearch = StringUtil.checkNull(request.getParameter("openDetailSearch"), "");
// 			String showAuthorInfo = StringUtil.checkNull(request.getParameter("showAuthorInfo"), "");
// 			String showItemVersionInfo = StringUtil.checkNull(request.getParameter("showItemVersionInfo"), "");
		
// 			String identifier = StringUtil.checkNull(request.getParameter("identifier"),"");
// 			String docTitle = StringUtil.checkNull(request.getParameter("docTitle"),"");
// 			String itemVersion = StringUtil.checkNull(request.getParameter("itemVersion"), "");
			
// 			// 화면 표시 메뉴 Map 취득
// 			Map setMap = new HashMap();
// 			Map ItemMgtUserMap = new HashMap();	
// 			Map boardMgtMap = new HashMap();
// 			//Map itemVersion = new HashMap();
// 			//Map roleChangeUserMap = new HashMap();	
			
			
// 			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
// 			setMap.put("s_itemID", ID);
		
// 			ItemMgtUserMap = commonService.select("forum_SQL.getItemAuthorName", setMap);
// 			String path = commonService.selectString("report_SQL.getMyPathAndName", setMap);


			
// 			List selectList = commonService.selectList("forum_SQL.forumSelect", setMap);
// 			if(!"".equals(BoardMgtID)){
// 				setMap.put("BoardMgtID", BoardMgtID);
// 				setMap.put("languageID", commandMap.get("sessionCurrLangType"));				
// 				boardMgtMap = commonService.select("board_SQL.getBoardMgtInfo", setMap);
// 				model.put("boardMgtName", StringUtil.checkNull(boardMgtMap.get("boardMgtName"),""));
// 				model.put("categoryYN", StringUtil.checkNull(boardMgtMap.get("CategoryYN"),""));
// 				model.put("replyOption", StringUtil.checkNull(boardMgtMap.get("ReplyOption"),""));
				
// 				if(boardTitle.equals("")) model.put("boardTitle", StringUtil.checkNull(boardMgtMap.get("boardMgtName"),""));
// 				else model.put("boardTitle", boardTitle);
// 			}
			

// 		    model.put("boardMgtMap", boardMgtMap);
		
// 			model.put("selectList", selectList);
// 			model.put("s_itemID", ID);			
// 			model.put("menu", getLabel(request, commonService));
// 			model.put("noticType", noticType);
// 			model.put("BoardMgtID", BoardMgtID);
// 			model.put("isMyCop", isMyCop);
// 			model.put("screenType", screenType);
// 			model.put("path",path);
// 			model.put("srID",srID);
// 			model.put("srType",srType);
// 			model.put("instanceNo",instanceNo);
// 			model.put("projectID",projectID);
// 			model.put("ItemMgtUserMap",ItemMgtUserMap);
// 			model.put("mailRcvListSQL",mailRcvListSQL);
// 			model.put("emailCode",emailCode);
// 			model.put("listType", StringUtil.checkNull(request.getParameter("listType"), ""));
// 			model.put("showItemInfo",showItemInfo);
// 			model.put("scrnType", scrnType);
// 			model.put("dueDateMgt", dueDateMgt);
// 			model.put("identifier", identifier);
// 			model.put("docTitle", docTitle);
// 			model.put("itemVersion", itemVersion);
// 			model.put("showAuthorInfo",showAuthorInfo);
// 			model.put("showItemVersionInfo",showItemVersionInfo);
// 			model.put("forumMailOption",forumMailOption);
// 			model.put("showReplyDT",showReplyDT);
// 			model.put("openDetailSearch",openDetailSearch);
// 			FileUtil.deleteDirectory(GlobalVal.FILE_UPLOAD_BASE_DIR + commandMap.get("sessionUserId"));
			
// 			// DICTIONARY.Description			
// 			setMap.put("Category", "BRDNM");
// 			setMap.put("TypeCode", BoardMgtID);
// 			setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
// 			Map dicInfo = commonService.select("common_SQL.label_commonSelect", setMap);
// 			model.put("dicInfo", dicInfo);
			
// 			// file upload를 위한 session 등록
// 			HttpSession session = request.getSession(true);
// 			String uploadToken = fileUploadUtil.makeFileUploadFolderToken(session);
// 			model.put("uploadToken", uploadToken);
			
// 		} catch (Exception e) {
// 			System.out.println(e.toString());
// 		}
// 		return nextUrl("/board/frm/registerForumPost");
// 	}
	
// 	@Transactional(rollbackFor = Exception.class)
// 	@RequestMapping(value = "/updateForumPost.do")
// 	public String updateForumPost(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
// 		Map target = new HashMap();
// 		String errorMessage = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068");
// 		XSSRequestWrapper xss = new XSSRequestWrapper(request);
// 		try {
			
// 			for (Iterator i = commandMap.entrySet().iterator(); i.hasNext();) {
// 			    Entry e = (Entry) i.next(); // not allowed
// 			    if(!e.getKey().equals("loginInfo") && e.getValue() != null) {
// 			    	commandMap.put(e.getKey(), xss.stripXSS(e.getValue().toString()));
// 			    }
// 			}
			
// 			String noticType = StringUtil.checkNull(xss.getParameter("noticType"), "");
// 			String boardID = StringUtil.checkNull(xss.getParameter("boardID"), "");
// 			String isNew = StringUtil.checkNull(xss.getParameter("isNew"), "1");
// 			String ID = StringUtil.checkNull(xss.getParameter("s_itemID"), "");
// 			String deleteSeq = StringUtil.checkNull(xss.getParameter("deleteSeq"), "");
// 			String itemID = StringUtil.checkNull(xss.getParameter("itemID"),"");
// 			String BoardMgtID = StringUtil.checkNull(xss.getParameter("BoardMgtID"));
// 			String projectID = StringUtil.checkNull(xss.getParameter("projectID"),"");
// 			String Category = StringUtil.checkNull(xss.getParameter("category"),"");
// 			String mailRcvListSQL = StringUtil.checkNull(xss.getParameter("mailRcvListSQL"),"");
// 			model.put("mailRcvListSQL", mailRcvListSQL);
			
// 			Map setMap = new HashMap();
			
// 			String userId = String.valueOf(commandMap.get("sessionUserId"));			
// 			String subject = StringUtil.checkNull(xss.getParameter("subject"), "");
// 			subject = StringUtil.replaceFilterString(subject).replaceAll("<","&lt;").replaceAll(">","&gt;");
// 			String content = StringUtil.checkNull(commandMap.get("Content"), "");
// 			content = StringUtil.replaceFilterString(content).replaceAll("<","&lt;").replaceAll(">","&gt;");
// 			content = XssUtil.xssCustomFilter(content);
			
// 			String s_itemID = StringUtil.checkNull( xss.getParameter("item"), "");
// 			setMap.put("boardID",boardID);
// 			String regUserID = StringUtil.checkNull(commonService.selectString("forum_SQL.getForumRegID", setMap));
		
// 			if (isNew.equals("1") && userId.equals(regUserID)) {
				
// 				// 화면에서 삭제된 파일이 존재 할 경우
// 				if (!deleteSeq.isEmpty()) {
// 					// 파일 폴더에 저장된 해당 파일을 삭제
// 					// [TB_BOARD_ATTCH]테이블의 해당 파일을 삭제
// 					deleteCommentFile(deleteSeq);
// 				}
				
// 				// file upload 공통 사용
// 				Map fileUploadMap = new HashMap();
// 				String uploadToken = StringUtil.checkNull(commandMap.get("uploadToken"), "");
// 				String BoardID = commonService.selectString("forum_SQL.boardNextVal", new HashMap());
// 				commandMap.put("type","BOARD");
// 				commandMap.put("uploadToken",uploadToken);
// 				commandMap.put("BoardMgtID",BoardMgtID);
// 				commandMap.put("BoardID",boardID);
// 				commandMap.put("projectID",projectID);
// 				fileUploadMap = fileUploadUtil.fileUpload(commandMap, request);
				
// 				boolean fileUploadResult = (boolean) fileUploadMap.getOrDefault("result",false);
// 				if(!fileUploadResult) {
// 					errorMessage = StringUtil.checkNull(fileUploadMap.get("message"),"파일 업로드 실패");
// 					throw new Exception(errorMessage);
// 				}
			
// 				Map updateValMap = new HashMap();
// 				Map updateInfoMap = new HashMap();
// 				List updateList = new ArrayList();
				
// 				updateValMap.put("userId", userId);
// 				updateValMap.put("subject", subject);
// 				updateValMap.put("content", content);
// 				updateValMap.put("boardID", StringUtil.checkNull(boardID, BoardID));
// 				updateValMap.put("Category", Category);
// 				updateInfoMap.put("KBN", "update");
// 				updateInfoMap.put("SQLNAME", "forum_SQL.forumUpdate");
// 				updateList.add(updateValMap);
// 				forumService.save(updateList, updateInfoMap);

// 				// 수정된 Cop정보를 상세화면에 표시
// 				Map mapValue = new HashMap();
// 				List getList = new ArrayList();	
				
// 				mapValue.put("boardID", boardID);
// 				mapValue.put("parentID", boardID);
// 				mapValue.put("s_itemID", ID);
				
// 				getList = commonService.selectList("forumComment_SQL.commentGridList", mapValue);
		
				
// 				if (getList.size() == 0) {
// 					getList = commonService.selectList("forumComment_SQL.emptyForum", mapValue);
// 				}
			
// 				// 코멘트 별 점수 취득
// 				mapValue.put("userId", userId);
				
// 				mapValue.put("languageID", commandMap.get("sessionCurrLangType"));
// 				mapValue = commonService.select("item_SQL.getObjectInfo", mapValue);
				
// 				model.put("s_itemID", StringUtil.checkNull(xss.getParameter("s_itemID"), ""));
// 				model.put("ItemID", ID);
// 				model.put("boarID", boardID);
// 				model.put("BoardMgtID", BoardMgtID);
// 				model.put("getList", getList);
// 				model.put("noticType", noticType);
// 				//model.put("fileList", fileList);
// 				model.put("getMap", mapValue);
				
// 				model.put("pageNum", StringUtil.checkNull(xss.getParameter("pageNum"),""));
// 				model.put("searchType", StringUtil.checkNull(xss.getParameter("searchType"),""));
// 				model.put("searchValue", StringUtil.checkNull(xss.getParameter("searchValue"),""));
// 				model.put("scStartDt", StringUtil.checkNull(xss.getParameter("scStartDt"),""));
// 				model.put("scEndDt", StringUtil.checkNull(xss.getParameter("scEndDt"),""));
// 				model.put("screenType", StringUtil.checkNull(xss.getParameter("screenType"),""));
// 				model.put("listType", StringUtil.checkNull(request.getParameter("listType"), ""));
				
// 				//target.put(AJAX_ALERT, "저장이 성공하였습니다.");
// 				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
// 				target.put(AJAX_SCRIPT, "parent.doReturn();this.$('#isSubmit').remove();parent.parent.$('#isSubmit').remove();");
// 				model.addAttribute(AJAX_RESULTMAP, target);
				
// 			} else {
// 				// 메뉴 취득
// 				List selectList = commonService.selectList("forum_SQL.forumSelect", new HashMap() );
// 				model.put( "selectList", selectList);
// 				model.put("s_itemID", ID);
// 				model.put("menu", getLabel(request, commonService));
// 				model.put("listType", StringUtil.checkNull(request.getParameter("listType"), ""));

// 				return nextUrl("/board/frm/registerForumPost");
// 			}
// 		} catch (Exception e) {
// 			System.out.println(e);
// 			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
// 			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
// 			target.put(AJAX_ALERT, errorMessage); // 오류 발생
// 		}
		
// 		return nextUrl(AJAXPAGE);
// 	}
	
// 	@RequestMapping(value = "/viewForumPost.do")
// 	public String viewForumPost(HttpServletRequest request, HashMap commandMap, ModelMap model)
// 			throws Exception {
// 		String url = "/board/frm/viewForumPost";
// 		try {
// 			String noticType = StringUtil.checkNull(request.getParameter("noticType"), "");
// 			String boardID = StringUtil.checkNull(request.getParameter("boardID"), "");
// 			String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"), "");
// 			String ID = StringUtil.checkNull(request.getParameter("ItemID"),"");
// 			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
// 			String userId = StringUtil.checkNull(commandMap.get("userId"), "");
// 			String pageNum =  StringUtil.checkNull(request.getParameter("pageNum"), "1");
// 			String isMyCop =  StringUtil.checkNull(request.getParameter("isMyCop"), "");
// 			String screenType =  StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("screenType"), ""));
// 			String projectID =  StringUtil.checkNull(request.getParameter("projectID"), "");
// 			String scStartDt = StringUtil.checkNull(request.getParameter("scStartDt"), "");
// 			String scEndDt = StringUtil.checkNull(request.getParameter("scEndDt"), "");
// 			String category = StringUtil.checkNull(request.getParameter("category"), "");
// 			String categoryIndex = StringUtil.checkNull(request.getParameter("categoryIndex"), "");
// 			String categoryCnt = StringUtil.checkNull(request.getParameter("categoryCnt"), "");
// 			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"), "");
// 			String searchType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("searchType"), ""));
// 			String searchValue = StringUtil.checkNull(request.getParameter("searchValue"), "");
// 			String listType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("listType"), ""));
// 			String srID = StringUtil.checkNull(request.getParameter("srID"), "");
// 			String emailCode = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("emailCode"), ""));
// 			String boardIds = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("boardIds"), ""));
// 			String mailRcvListSQL = StringUtil.checkNull(request.getParameter("mailRcvListSQL"), "");
// 			String regUserName = StringUtil.checkNull(request.getParameter("regUserName"), "");
// 			String authorName = StringUtil.checkNull(request.getParameter("authorName"), "");
// 			String myBoard = StringUtil.checkNull(request.getParameter("myBoard"), ""); 
// 			String showItemInfo = StringUtil.checkNull(request.getParameter("showItemInfo"), ""); 
// 			String srType = StringUtil.checkNull(request.getParameter("srType"), ""); 
// 			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"), ""); 
// 			String boardTitle = StringUtil.checkNull(request.getParameter("boardTitle"),"");
// 			String dueDateMgt = StringUtil.checkNull(request.getParameter("dueDateMgt"),"");
// 			String replyMailOption = StringUtil.checkNull(request.getParameter("replyMailOption"), "");
// 			String forumMailOption = StringUtil.checkNull(request.getParameter("forumMailOption"), "");
// 			String showReplyDT = StringUtil.checkNull(request.getParameter("showReplyDT"), "");
// 			String openDetailSearch = StringUtil.checkNull(request.getParameter("openDetailSearch"), "");
// 			String showAuthorInfo = StringUtil.checkNull(request.getParameter("showAuthorInfo"), "");
// 			String showItemVersionInfo = StringUtil.checkNull(request.getParameter("showItemVersionInfo"), "");
// 			Map mapValue = new HashMap();
// 			Map boardMap = new HashMap();
// 			List fileList = new ArrayList();
// 			List replyList = new ArrayList();
// 			List replyFileList = new ArrayList();
			
// 			Map insertValMap = new HashMap();
// 			Map insertInfoMap = new HashMap();
// 			List insertList = new ArrayList();
// 			Map updateValMap = new HashMap();
// 			Map updateInfoMap = new HashMap();
// 			List updateList = new ArrayList();
// 			Map setMap = new HashMap();
			
// 			mapValue.put("boardID", boardID);
// 			mapValue.put("parentID", boardID);
// 			mapValue.put("userId", userId);
// 			mapValue.put("s_itemID", ID);
// 			mapValue.put("emailCode", emailCode);
			
// 			if(StringUtil.checkNull(request.getParameter("filter"),"").equals("edit")){
// 				// 메뉴 취득
// 				model.put("menu", getLabel(request, commonService));
// 				url = "/board/frm/editForumPost";
			
// 			}  else if (StringUtil.checkNull(request.getParameter("filter"), "").equals("editScore")) {
// 				// 별점 입력 or 갱신
// 				if ("0".equals(commonService.selectString("forumScore_SQL.isExistScore", mapValue))) {
// 					// [TB_BOARD_SCORE] 테이블에 데이터 등록
// 					insertValMap = new HashMap();
// 					insertInfoMap = new HashMap();
// 					insertList = new ArrayList();
// 					insertValMap.put("boardID", boardID);
// 					insertValMap.put("userId", userId);
// 					insertList.add(insertValMap);
// 					insertInfoMap.put("KBN", "insert");
// 					insertInfoMap.put("SQLNAME", "forumScore_SQL.scoreInsert");
// 					forumService.save(insertList, insertInfoMap);
// 				} else {
// 					// [TB_BOARD_SCORE] 테이블에 점수 업데이트
// 					updateValMap.put("boardID", boardID);
// 					updateValMap.put("userId", userId);
// 					updateList.add(updateValMap);
// 					updateInfoMap.put("KBN", "update");
// 					updateInfoMap.put("SQLNAME", "forumScore_SQL.scoreUpdate");
// 					forumService.save(updateList, updateInfoMap);
// 				}
				
// 			} else if (StringUtil.checkNull(request.getParameter("filter"), "").equals("")) {
// 				// 조회수 업데이트
// 				updateValMap = new HashMap();
// 				updateInfoMap = new HashMap();
// 				updateList = new ArrayList();
// 				updateValMap.put("boardID", boardID);
// 				updateInfoMap.put("KBN", "update");
// 				updateInfoMap.put("SQLNAME", "forum_SQL.forumReadCntUpdate");
// 				updateList.add(updateValMap);
// 				forumService.save(updateList, updateInfoMap);
// 			}
			
// 			mapValue.put("languageID", commandMap.get("sessionCurrLangType"));
// 			mapValue.put("boardMgtID", BoardMgtID);
// 			mapValue.put("myBoard", myBoard);
// 			if(myBoard.equals("Y")) {
// 				mapValue.put("sessionUserId", commandMap.get("sessionUserId"));
// 			}
// 			boardMap = commonService.select("forum_SQL.getForumEditInfo", mapValue);
// 			fileList = setLongFileName(commonService.selectList("forumFile_SQL.forumFile_select", mapValue));
// 			replyList = commonService.selectList("forum_SQL.getReplyList", mapValue);
// 			String replyFileCnt = commonService.selectString("forumFile_SQL.getReplyFileCnt", mapValue);
			
// 			if(replyList.size() > 0){
// 				for(int i=0; replyList.size()>i; i++){
// 					Map replyInfo = (Map)replyList.get(i);
// 					// replyInfo.put("Content", StringUtil.checkNull(replyInfo.get("Content")).replace("\n","<br>") );
// 					replyInfo.put("Content", StringUtil.replaceFilterString(StringUtil.checkNull(replyInfo.get("Content"))).replace("\n","<br>"));
// 				}
// 			}

// 			setMap.put("BoardMgtID", BoardMgtID);
// 			String likeYN = commonService.selectString("board_SQL.getBoardLikeYN", setMap);
// 			model.put("LikeYN", likeYN);
			
// 			if(likeYN != null && "Y".equals(likeYN)) {
// 				String likeCNT = "";
// 				setMap.put("BoardMgtID", BoardMgtID);
// 				setMap.put("BoardID", boardID);
// 				likeCNT = commonService.selectString("board_SQL.getBoardLikeCNT",setMap);			
// 				model.put("likeCNT", likeCNT);
// 			}
						
			
// 			if(!"".equals(BoardMgtID)){
// 				setMap.put("BoardMgtID", BoardMgtID);
// 				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
// 				String boardMgtName = StringUtil.checkNull(commonService.selectString("board_SQL.getBoardMgtName",setMap));			
// 				model.put("boardMgtName", boardMgtName);
// 				if(boardTitle.equals("")) boardTitle = boardMgtName;
// 			}
// 			model.put("boardTitle", boardTitle);
// 			model.put("s_itemID", s_itemID);
// 			model.put("ItemID", ID);
// 			model.put("boardID", boardID);
		
// 			model.put("noticType", noticType);
// 			model.put("BoardMgtID", BoardMgtID);
// 			String Content = StringUtil.checkNull(boardMap.get("Content"),"");
// 			String Subject = StringUtil.checkNull(boardMap.get("Subject"),"");
// 			Content = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(Content));
// 			Subject = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(Subject));
			
// 			Content = StringEscapeUtils.unescapeHtml4(Content);
// 			Subject = StringEscapeUtils.unescapeHtml4(Subject);
			
// 			Content = Content.replaceAll("&lt;", "<");
// 			Content = Content.replaceAll("&gt;", ">");
// 			Content = Content.replaceAll("&amp;lt;", "<");
// 			Content = Content.replaceAll("&amp;gt;", ">");
// 			Content = Content.replaceAll("&quot;", "\"");
			
// 			boardMap.put("Content", Content);
// 			boardMap.put("Subject", Subject);
			
// 			System.out.println("boardMap :"+boardMap);
// 			model.put("boardMap", boardMap);
// 			model.put("fileList", fileList);
// 			model.put("replyList", replyList);
// 			model.put("replyListCnt", replyList.size());
// 			model.put("replyFileCnt", replyFileCnt);
			
// 			Map ItemMgtUserMap = new HashMap();
// 			setMap.put("s_itemID",ID);
// 			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
// 			ItemMgtUserMap = commonService.select("forum_SQL.getItemAuthorName", setMap);
// 			String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);
// 			String replyOption = commonService.selectString("board_SQL.getBoardReplyOption", setMap);
// 			Map boardMgtInfo = commonService.select("board_SQL.getBoardMgtInfo", setMap);
			
// 			// SR Option
// 			if(srID!="" && !"".equals(srID)){
// 				// 검색조건 Setting
// 				model.put("srCategory", StringUtil.checkNull(request.getParameter("srCategory")));
// 				model.put("srArea1", StringUtil.checkNull(request.getParameter("srArea1")));
// 				model.put("subject", StringUtil.checkNull(request.getParameter("subject")));
// 				model.put("searchStatus", StringUtil.checkNull(request.getParameter("searchStatus")));
// 				model.put("receiptUser", StringUtil.checkNull(request.getParameter("receiptUser")));
// 				model.put("requestUser", StringUtil.checkNull(request.getParameter("requestUser")));
// 				model.put("requestTeam", StringUtil.checkNull(request.getParameter("requestTeam")));
// 				model.put("startRegDT", StringUtil.checkNull(request.getParameter("startRegDT")));
// 				model.put("endRegDT", StringUtil.checkNull(request.getParameter("endRegDT")));
// 				model.put("searchSrCode", StringUtil.checkNull(request.getParameter("searchSrCode")));
// 				model.put("srReceiptTeam", StringUtil.checkNull(request.getParameter("srReceiptTeam")));
// 				model.put("srMode", StringUtil.checkNull(request.getParameter("srMode")));
// 			}
			
// 			// 댓글 file upload를 위한 session 등록
// 			HttpSession session = request.getSession(true);
// 			String uploadToken = fileUploadUtil.makeFileUploadFolderToken(session);
// 			model.put("uploadToken", uploadToken);
			
// 			model.put("replyOption", replyOption);
// 			model.put("ItemMgtUserMap",ItemMgtUserMap);
// 			model.put("BoardMgtInfo",boardMgtInfo);
// 			model.put("CategoryYN",categoryYN);
// 			model.put("getMap", mapValue);			
// 			model.put("pageNum", pageNum);
// 			model.put("isMyCop", isMyCop);
// 			model.put("menu", getLabel(request, commonService));
// 			model.put("screenType", screenType);
// 			model.put("projectID", projectID);
// 			model.put("scStartDt", scStartDt);
// 			model.put("scEndDt", scEndDt);
// 			model.put("category", category);
// 			model.put("categoryIndex", categoryIndex);
// 			model.put("categoryCnt", categoryCnt);
// 			model.put("itemTypeCode", itemTypeCode);
// 			model.put("searchType", searchType);
// 			model.put("searchValue", searchValue);
// 			model.put("listType", listType);
// 			model.put("srID", srID);
// 			model.put("emailCode", emailCode);
// 			model.put("boardIds", boardIds);
// 			model.put("mailRcvListSQL", mailRcvListSQL);
// 			model.put("regUserName", regUserName);
// 			model.put("authorName", authorName);
// 			model.put("myBoard", myBoard);
// 			model.put("showItemInfo", showItemInfo);
// 			model.put("srType", srType);
// 			model.put("scrnType", scrnType);
// 			model.put("dueDateMgt", dueDateMgt);
// 		    model.put("replyMailOption",replyMailOption);
// 		    model.put("forumMailOption",forumMailOption);
// 		    model.put("showReplyDT",showReplyDT);
// 		    model.put("openDetailSearch",openDetailSearch);
// 		    model.put("showAuthorInfo",showAuthorInfo);
// 		    model.put("showItemVersionInfo",showItemVersionInfo);
// 			String[] boardIDsArray = boardIds.split(",");
// 			List<String> boardIDList = Arrays.asList(boardIDsArray);
// 			if(!boardIDList.contains(String.valueOf(boardID))) { 
// 				return nextUrl("/board/frm/boardForumList");
// 			}
			
// 		} catch (Exception e) {
// 			System.out.println(e.toString());
// 		}

// 		return nextUrl(url);
// 	}
	
// 	@Transactional(rollbackFor = Exception.class)
// 	@RequestMapping(value = "/saveForumReply.do")
// 	public String saveForumReply(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
// 		Map target = new HashMap();
// 		String errorMessage = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068");
// 		XSSRequestWrapper xss = new XSSRequestWrapper(request);
// 		try {
// 			for (Iterator i = commandMap.entrySet().iterator(); i.hasNext();) {
// 			    Entry e = (Entry) i.next(); // not allowed
// 			    if(!e.getKey().equals("loginInfo") && e.getValue() != null) {
// 			    	commandMap.put(e.getKey(), xss.stripXSS(e.getValue().toString()));
// 			    }
// 			}
// 			// 생성
// 			List fileList = new ArrayList();
// 			String parentID = StringUtil.checkNull(xss.getParameter("parentID"), ""); // 본문 아이디 
// 			String content = StringUtil.checkNull(xss.getParameter("content_new"), "").trim();
// 			content = XssUtil.xssCustomFilter(content);
			
// 			String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"),"");
// 			String userId = String.valueOf(commandMap.get("sessionUserId"));
// 			String itemID = StringUtil.checkNull(request.getParameter("ItemID"),"");
// 			String boardID = StringUtil.checkNull(xss.getParameter("boardID"), "");
// 			String BoardMgtID = StringUtil.checkNull(xss.getParameter("BoardMgtID"));
// 			String deleteSeq = StringUtil.checkNull(xss.getParameter("deleteSeq"), "");
// 			String score = StringUtil.checkNull(xss.getParameter("score"), "");
// 			String replyLev = StringUtil.checkNull(xss.getParameter("replyLev"), "");
// 			String parentRefID = StringUtil.checkNull(xss.getParameter("parentRefID"), "0");
// 			String emailCode = StringUtil.checkNull(xss.getParameter("emailCode"), "BRDMAIL");
// 			String mailRcvListSQL = StringUtil.checkNull(xss.getParameter("mailRcvListSQL"), "");
// 			String replyMailOption  = StringUtil.checkNull(xss.getParameter("replyMailOption"), "");
// 			String forumMailOption  = StringUtil.checkNull(xss.getParameter("forumMailOption"), "");
// 			String showReplyDT = StringUtil.checkNull(xss.getParameter("showReplyDT"), "");
// 			String openDetailSearch = StringUtil.checkNull(xss.getParameter("openDetailSearch"), "");
// 			String showAuthorInfo = StringUtil.checkNull(request.getParameter("showAuthorInfo"), "");
// 			String showItemVersionInfo = StringUtil.checkNull(request.getParameter("showItemVersionInfo"), "");
// 			if(parentRefID.equals("")){parentRefID="0";}
			
// 			Iterator fileNameIter = request.getFileNames();
// 			String savePath = GlobalVal.FILE_UPLOAD_BOARD_DIR;
// 			String fileName = "";
// 			String commentSeq = "";
// 			String filefullPath;
// 			String fileSeq;
// 			Map insertValMap = new HashMap();
// 			Map insertInfoMap = new HashMap();
// 			List insertList = new ArrayList();
// 			Map updateValMap = new HashMap();
// 			Map updateInfoMap = new HashMap();
// 			List updateList = new ArrayList();
			
// 			// 코멘트 수정인 경우
// 			if (!boardID.isEmpty()) {
// 				//commentSeq = commentId;
// 				// 화면에서 삭제된 파일이 존재 할 경우
// 				if (!deleteSeq.isEmpty()) {
// 					// 파일 폴더에 저장된 해당 파일을 삭제
// 					// [TB_BOARD_ATTCH]테이블의 해당 파일을 삭제
// 					deleteCommentFile(deleteSeq);
// 				}
				
// 				// [TB_BOARD_COMMENT] 테이블에 데이터 업데이트
// 				updateValMap.put("content", content);
// 				updateValMap.put("boardID", boardID);
// 				updateList.add(updateValMap);
// 				updateInfoMap.put("KBN", "update");
// 				updateInfoMap.put("SQLNAME", "forum_SQL.forumUpdate");
// 				forumService.save(updateList, updateInfoMap);
				
				
// 			} else {
// 				// [TB_BOARD_COMMENT] 테이블에 데이터 등록
// 				boardID = commonService.selectString("forumComment_SQL.boardNextVal", new HashMap());
// 				insertValMap.put("content", content);
// 				insertValMap.put("boardID", boardID);
// 				insertValMap.put("parentID", parentID);
// 				insertValMap.put("userId", userId);
// 				insertValMap.put("BoardMgtID", BoardMgtID);
// 				insertValMap.put("replyLev", replyLev);
// 				insertValMap.put("refID", parentRefID);
				
// 				insertList.add(insertValMap);
// 				insertInfoMap.put("KBN", "insert");
// 				insertInfoMap.put("SQLNAME", "forum_SQL.forumInsert");
// 				forumService.save(insertList, insertInfoMap);			
// 			}
						
// 			// file upload 공통 사용
// 			Map fileUploadMap = new HashMap();
// 			String uploadToken = StringUtil.checkNull(commandMap.get("uploadToken"), "");
// 			commandMap.put("type","BOARD");
// 			commandMap.put("uploadToken",uploadToken);
// 			commandMap.put("BoardID",boardID);
// 			fileUploadMap = fileUploadUtil.fileUpload(commandMap, request);
			
// 			boolean fileUploadResult = (boolean) fileUploadMap.getOrDefault("result",false);
// 			if(!fileUploadResult) {
// 				errorMessage = StringUtil.checkNull(fileUploadMap.get("message"),"파일 업로드 실패");
// 				throw new Exception(errorMessage);
// 			}
			
// 			// 업데이트 된 정보를 DB에서 다시 취득해서 화면에 표시
// 			Map mapValue_s = new HashMap();
// 			List getList = new ArrayList();
			
// 			mapValue_s.put("boardID", boardID);
// 			mapValue_s.put("s_itemID", s_itemID);
// 			mapValue_s.put("userId", userId);
// 			mapValue_s.put("languageID", commandMap.get("sessionCurrLangType"));
// 			mapValue_s.put("parentID", parentID);
			
// 			fileList = new ArrayList();
// 			fileList = setLongFileName(commonService.selectList("forumFile_SQL.forumFile_select", mapValue_s));
// 			getList = commonService.selectList("forumComment_SQL.commentGridList", mapValue_s);

// 			// 표시될 글의 점수 취득
// 			//int total_score = getTotalScore(privateId);
			
// 			// 코멘트 별 점수 취득
// 			mapValue_s.put("userId", userId);
					
// 			Map getMap = new HashMap();
// 			getMap = commonService.select("item_SQL.getObjectInfo", mapValue_s);
			
// 			String postEmailYN = commonService.selectString("board_SQL.getBoardPostEmailYN", insertValMap);
// 			String replyOption = commonService.selectString("board_SQL.getBoardReplyOption", insertValMap);
			
// 			mapValue_s.put("languageID", commandMap.get("sessionCurrLangType"));
// 			mapValue_s.put("sessionUserId", commandMap.get("sessionUserId"));

// 			Map mapValue_s2 = new HashMap();
// 			mapValue_s2 = mapValue_s;
// 			mapValue_s2.put("boardID", parentID);
// 			Map boardMap = commonService.select("forum_SQL.getForumEditInfo", mapValue_s2);
			
// 			if("Y".equals(postEmailYN)  || "M".equals(postEmailYN)) {
				
// 				//if("".equals(s_itemID)) s_itemID = itemID;
				
// 				String memberID = StringUtil.checkNull(xss.getParameter("memberID"), "");
// 				String subject = StringUtil.checkNull(xss.getParameter("subject"), "");
// 				Map setMap = new HashMap();
// 				HashMap setMailData = new HashMap();
// 				List receiverList = new ArrayList();
// 				Map<String, Object> tempMap = new HashMap<String, Object>();	
// 				HashMap authorInfo = new HashMap();
// 				String receiverListString = "";
// 				int idCnt = 0;
// 				int mailIndex = 0;
				
// 				setMap.put("crArea2", itemID);
				
// 				Map tmpInfo = new HashMap();
// 				tmpInfo = (HashMap) commonService.select("cr_SQL.getReceipt",setMap);
				
// 				setMap.put("s_itemID", itemID);
// 				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				
// 				String itemName = commonService.selectString("item_SQL.getItemInfoHeader", setMap);
// 				String pLabelName = commonService.selectString("item_SQL.getItemClassName", setMap);
				
// 				//수신자 설정
// 				setMap.clear();
// 				// 게시글 작성자
// 				if(!"review".equals(mailRcvListSQL)){
// 					setMap.put("MemberID", memberID);
// 					setMap.put("languageID", commandMap.get("sessionCurrLangType"));
// 					authorInfo = (HashMap) commonService.select("user_SQL.selectUser",setMap);
// 					tempMap.put("receiptUserID", authorInfo.get("MemberID"));
// 					receiverListString = "receiptUserID="+StringUtil.checkNull(authorInfo.get("MemberID")) + ",receiptType=";
// 					receiverList.add(mailIndex++,tempMap);
// 				}
				
// 				setMap.put("BoardMgtID", BoardMgtID);
// 				String mgtUserID = commonService.selectString("forum_SQL.getBoardMgtName",setMap);
// 				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				
// 				if("1".equals(replyMailOption)){
// 					// 아이템 있을 경우 
// 					if(s_itemID != null && !"".equals(s_itemID)) {
// 						// 수신 : 아이템 담당자 
// 						tempMap = new HashMap();
// 						setMap.put("s_itemID",s_itemID);
// 						String ItemAuthorID =  commonService.selectString("item_SQL.getItemAuthorId", setMap);	
// 						setMap.put("MemberID", ItemAuthorID);
// 						setMap.put("languageID", languageID);
// 						tempMap.put("receiptUserID", ItemAuthorID);				
// 						receiverList.add(mailIndex++,tempMap);
						
// 						// mailRcvListSQL 없을 경우 
// 						if("".equals(mailRcvListSQL) || mailRcvListSQL == null){
// 							// 참조 : 개정담당자
// 							setMap.put("itemID", s_itemID);
// 							setMap.put("assignmentType", "CNGROLETP");
// 							setMap.put("assigned", "1");
// 							setMap.put("isAll", "N");
// 							List roleAssignedMbrList = commonService.selectList("role_SQL.getAssignedRoleList_gridList", setMap);
							
// 							for(int i = 0; i < roleAssignedMbrList.size(); i++){
// 								Map roleAssignedMbr = (Map) roleAssignedMbrList.get(i);
// 								String assignedMbrID = StringUtil.checkNull(roleAssignedMbr.get("MemberID"));
// 								tempMap = new HashMap();
// 								tempMap.put("receiptUserID", assignedMbrID); //참조
// 								tempMap.put("receiptType", "CC");
// 								receiverList.add(mailIndex++,tempMap);							
// 							}
// 							// 참조 : 댓글 등록자
// 							tempMap = new HashMap();
// 							tempMap.put("receiptUserID", userId);
// 							tempMap.put("receiptType", "CC");
// 							receiverList.add(mailIndex++,tempMap);
							
// 							setMap.put("boardID", parentID);
// 							List replyMbrList = commonService.selectList("forum_SQL.getReplyList", setMap);
// 							for(int i = 0; i < replyMbrList.size(); i++){
// 								Map replyMbr = (Map) replyMbrList.get(i);
// 								String replyMbrID = StringUtil.checkNull(replyMbr.get("RegUserID"));
// 								if(!userId.equals(replyMbrID)){
// 									tempMap = new HashMap();
// 									tempMap.put("receiptUserID", replyMbrID); //참조
// 									tempMap.put("receiptType", "CC");
// 									receiverList.add(mailIndex++,tempMap);							
// 								}
// 							}
// 						}
// 					}
					
// 					if("review".equals(mailRcvListSQL)){
// 						// 수신 : 검토자 리스트
// 						String scheduleId = StringUtil.checkNull(request.getParameter("scheduleID"),"");
// 						setMap.put("scheduleId", scheduleId);
// 						List receiverList1 = commonService.selectList("schedule_SQL.getSharesReceiptUserList", setMap);
// 						receiverList.addAll(receiverList1);
// 					}
					
// 					// 참조 : 게시판 담당자
// 					if(mgtUserID != null && !"".equals(mgtUserID)){
// 						tempMap = new HashMap();
// 						tempMap.put("receiptUserID", mgtUserID); 	
// 						tempMap.put("receiptType", "CC");
// 						receiverList.add(mailIndex++,tempMap);
// 					}
					
// 				}
				
// 				setMap.remove("MemberID");
				
// 				if(receiverList.size() > 0) {
// 					// Sending mail
					
// 					// 중복 수신자 제거
// 					receiverList = filterDuplicateReceiptUsers(receiverList);
				
// 					Map temp = new HashMap();
// 					Map batEmap = new HashMap();
					
// 					String originEmailCode = emailCode;
					
// 					temp.put("Category", "EMAILCODE");
// 					temp.put("TypeCode", "QNARQS");
// 					temp.put("LanguageID", commandMap.get("sessionCurrLangType"));
// 					Map emDescription = commonService.select("common_SQL.label_commonSelect", temp);
// 					batEmap.put("receiverList", receiverListString);
// 					batEmap.put("subject", emDescription.get("LABEL_NM") + subject);
// 					batEmap.put("mailFormType", emailCode);
// 					batEmap.put("languageID", commandMap.get("sessionCurrLangType"));
// 					batEmap.put("creator", userId);
					
// 					setMailData.put("receiverList",receiverList);	
// 					setMailData.put("languageID",commandMap.get("sessionCurrLangType"));
// 					setMailData.put("subject", emDescription.get("LABEL_NM") + subject);
					
// 					// 특정 제목과 form을 사용하고싶은 경우 ( * 단 base가 되는 emailForm이 있어야 사용가능. form자체가 너무 다른 경우 makeEmailContents에 등록 후 varFilter가 아닌 emailCode를 변경해서 사용해야함 )
// 					setMap.put("BoardMgtID", BoardMgtID);
// 					Map boardMgtInfo = commonService.select("board_SQL.getBoardMgtInfo", setMap);
// 					String mgtVarfilter = StringUtil.checkNull(boardMgtInfo.get("VarFilter"));
// 					if(!"".equals(mgtVarfilter)){
// 						Map varFilterMap = getQueryParams(mgtVarfilter);
// 				        if(varFilterMap.containsKey("replyEmailCode")){
// 				        	emailCode = StringUtil.checkNull(varFilterMap.get("replyEmailCode"));
// 				        	setMailData.put("subject", subject);
// 				        }
// 					}
					
					
// 					Map setMailMap = (Map)setEmailLog(request, commonService, setMailData, emailCode);
	
// 					String formData = "subject="+subject+",content="+content+",itemName="+itemName+",pLabelName="+pLabelName;
					
// 						if(StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")){
// 							HashMap mailMap = (HashMap)setMailMap.get("mailLog");	
// 							HashMap regUInfo = new HashMap();
								
// 							setMap.clear();
// 							setMap.put("MemberID", userId);
// 							setMap.put("languageID", commandMap.get("sessionCurrLangType"));
// 							regUInfo = (HashMap) commonService.select("user_SQL.selectUser",setMap);
							
// 							// reply 정보
// 							authorInfo.put("content", content);	
// 							authorInfo.put("regUInfo", regUInfo);	
// 							authorInfo.put("subject", subject);	
// 							authorInfo.put("boardID", parentID);
// 							authorInfo.put("itemName", itemName);
// 							authorInfo.put("pLabelName", pLabelName);
// 							authorInfo.put("languageID", commandMap.get("sessionCurrLangType"));
// 							authorInfo.put("emailCode", emailCode);
// 							authorInfo.put("relTeamMembers", boardMap.get("sharerNames"));
// 							authorInfo.put("sharerNames", boardMap.get("sharerNames"));
// 							authorInfo.put("SC_END_DT", boardMap.get("SC_END_DT"));
							
// 							// board Category 정보
// 							String categoryNM = StringUtil.checkNull(boardMap.get("Category"),"");
// 							authorInfo.put("categoryNM", categoryNM);
							
// 							formData += ",regUInfo="+regUInfo;
							
// 							String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", authorInfo));
// 							authorInfo.put("emailHTMLForm", emailHTMLForm);
							
// 							// emailCode 원복
// 							authorInfo.put("emailCode",originEmailCode);
// 							mailMap.put("dicTypeCode",originEmailCode);
// 							Map resultMailMap = EmailUtil.sendMail(mailMap,authorInfo,getLabel(request, commonService));
							
							
// 							System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMap.get("type")));
// 						}else{ 
// 							System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMap.get("msg")));
// 						}
						
// 						batEmap.put("formData", formData);
// 					}
				
// 			}

// 			// 임시 저장 디렉토리 삭제 
// 		    String path = GlobalVal.FILE_UPLOAD_BASE_DIR + commandMap.get("sessionUserId");
// 			if(!path.equals("")){FileUtil.deleteDirectory(path);}
			
// 			model.put("getMap", getMap);		
// 			model.put("s_itemID", s_itemID);
// 			model.put("parentID", parentID);
// 			model.put("getList", getList);
// 			model.put("noticType", 100);
// 			model.put("BoardMgtID", BoardMgtID);
// 			model.put("fileList", fileList);
// 			model.put("itemID", itemID);
// 			model.put("emailCode", emailCode);
// 			model.put("mailRcvListSQL", mailRcvListSQL);
// 			model.put("searchType", StringUtil.checkNull(request.getParameter("searchType")));
// 			model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
// 			model.put("scStartDt", StringUtil.checkNull(request.getParameter("scStartDt")));
// 			model.put("scEndDt", StringUtil.checkNull(request.getParameter("scEndDt")));
// 			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
// 			model.put("listType", StringUtil.checkNull(request.getParameter("listType"), ""));
// 			model.put("replyMailOption",replyMailOption);
// 			model.put("forumMailOption",forumMailOption);
// 			model.put("showAuthorInfo",showAuthorInfo);
// 			model.put("showItemVersionInfo",showItemVersionInfo);
// 			model.put("showReplyDT",showReplyDT);
// 			model.put("openDetailSearch",openDetailSearch);
			
// 			target.put(AJAX_ALERT, "저장이 성공하였습니다.");
// 			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
// 			target.put(AJAX_SCRIPT, "parent.doReturn();parent.$('#isSubmit').remove();");
// 			model.addAttribute(AJAX_RESULTMAP, target);
			
// 		} catch (Exception e) {
// 			System.out.println(e.toString());
// 			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
// 			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
// 			target.put(AJAX_ALERT, errorMessage); // 오류 발생
// 		}
		
// 		return nextUrl(AJAXPAGE);
// 	}

// 	@RequestMapping(value = "/registerForumReply.do")
// 	public String registerForumReply(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
// 		try {
			
// 			String boardID = StringUtil.checkNull(request.getParameter("boardID"), "");
// 			String parentID = StringUtil.checkNull(request.getParameter("parentID"), "");
// 			String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"));
// 			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
// 			String userId = StringUtil.checkNull(request.getParameter("userId"), "");
// 			String ItemID = StringUtil.checkNull(request.getParameter("ItemID"), "");
// 			String commentId = StringUtil.checkNull(request.getParameter("commentId"), "");
// 			String replyLev = StringUtil.checkNull(request.getParameter("replyLev"), "");
// 			String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "");
// 			String parentRefID = StringUtil.checkNull(request.getParameter("refID"), "");
// 			String noticType = StringUtil.checkNull(request.getParameter("noticType"), "");
// 			String isMyCop = StringUtil.checkNull(request.getParameter("isMyCop"), "");
// 			String searchType = StringUtil.checkNull(request.getParameter("searchType"),"");
// 			String searchValue = StringUtil.checkNull(request.getParameter("searchValue"),"");
// 			String scStartDt = StringUtil.checkNull(request.getParameter("scStartDt"));
// 			String scEndDt = StringUtil.checkNull(request.getParameter("scEndDt"));
// 			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
// 			String memberID = StringUtil.checkNull(request.getParameter("memberID"));
// 			String subject = StringUtil.checkNull(request.getParameter("subject"));
// 			String srID = StringUtil.checkNull(request.getParameter("srID"));
// 			String emailCode = StringUtil.checkNull(request.getParameter("emailCode"));
// 			String regUserID = StringUtil.checkNull(request.getParameter("regUserID"));
// 			String mailRcvListSQL = StringUtil.checkNull(request.getParameter("mailRcvListSQL"));
			
// 			Map mapValue = new HashMap();
// 			Map setMap = new HashMap();
// 			mapValue.put("boardID", boardID);
// 			mapValue.put("BoardMgtID", BoardMgtID);
// 			mapValue.put("userId", userId);
// 			mapValue.put("replyLev", replyLev);
			
// 			List fileList = new ArrayList();
// 			fileList = commonService.selectList("forumFile_SQL.forumCommentFile_select", mapValue);
// 			String content = commonService.selectString("forumComment_SQL.getContent", mapValue);
			
	
// 			if(!"".equals(BoardMgtID)){
// 				setMap.put("BoardMgtID", BoardMgtID);
// 				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
// 				String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName",setMap);			
// 				model.put("boardMgtName", boardMgtName);			
// 			}
			
// 			model.put("menu", getLabel(request, commonService)); // 메뉴 취득		
// 			model.put("fileList", fileList);
// 			model.put("content", content);
// 			model.put("BoardMgtID", BoardMgtID);
// 			model.put("s_itemID", s_itemID);
// 			model.put("boardID", boardID);
// 			model.put("noticType", noticType);
// 			model.put("ItemID", ItemID);
// 			model.put("parentID", parentID);
// 			model.put("pageNum", pageNum);
// 			model.put("parentRefID", parentRefID);
// 			model.put("isMyCop", isMyCop);
// 			model.put("searchType", searchType);
// 			model.put("searchValue", searchValue);
// 			model.put("scStartDt", scStartDt);
// 			model.put("scEndDt", scEndDt);
// 			model.put("screenType", screenType);
// 			model.put("listType", StringUtil.checkNull(request.getParameter("listType"), ""));
// 			model.put("memberID", memberID);
// 			model.put("subject", subject);
// 			model.put("srID", srID);
// 			model.put("emailCode", emailCode);
// 			model.put("regUserID", regUserID);
// 			model.put("mailRcvListSQL", mailRcvListSQL);
// 			// file upload를 위한 session 등록
// 			HttpSession session = request.getSession(true);
// 			String uploadToken = fileUploadUtil.makeFileUploadFolderToken(session);
// 			model.put("uploadToken", uploadToken);
			
// 		} catch (Exception e) {
// 			System.out.println(e.toString());
// 		}
// 		return nextUrl("/board/frm/registerForumReply");
// 	}
	
// 	@RequestMapping(value = "/boardForumDelete.do")
// 	public String boardForumDelete(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
// 		Map target = new HashMap();
// 		try {
// 				String boardID = StringUtil.checkNull(request.getParameter("BoardID"), "");
// 				String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"));
// 				String ID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
// 				String pageNum = StringUtil.checkNull(request.getParameter("pageNum"),"1");
// 				String noticType = StringUtil.checkNull(request.getParameter("noticType"), "");
// 				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
// 				String userId = StringUtil.checkNull(commandMap.get("sessionUserId"), "");
// 				String isMyCop = StringUtil.checkNull(request.getParameter("isMyCop"));
// 				String emailCode = StringUtil.checkNull(request.getParameter("emailCode"));
// 				String mailRcvListSQL = StringUtil.checkNull(request.getParameter("mailRcvListSQL"), "");
// 				String showItemInfo = StringUtil.checkNull(request.getParameter("showItemInfo"), "");
// 				model.put("mailRcvListSQL", mailRcvListSQL);
// 				model.put("emailCode", emailCode);
				
// 				Map resultMap = new HashMap();
// 				Map setMap = new HashMap();
				
// 				setMap.put("languageID", languageID);
// 				setMap.put("boardID", boardID);			
// 				resultMap = commonService.select("forum_SQL.getForumEditInfo", setMap);
// 				if(!userId.equals(resultMap.get("RegUserID"))) {
					
// 					model.put("boardID", boardID);
// 					model.put("BoardMgtID", BoardMgtID);
// 					model.put("noticType", noticType);
// 					model.put("pageNum", pageNum);
// 					model.put("menu", getLabel(request, commonService));	
// 					model.put("itemID", commandMap.get("s_itemID"));
// 					model.put("isMyCop", isMyCop);
// 					model.put("menu", getLabel(request, commonService));
					
// 					return nextUrl("/board/frm/boardForumList");
// 				}
				
				
// 				// 파일 폴더에 저장된 해당 파일을 삭제
// 				Map mapValue_s = new HashMap();
// 				mapValue_s.put("boardID", boardID);
// 				List<String> deletefileList = new ArrayList<String>();
// 				deletefileList = commonService.selectList("forumFile_SQL.forumFile_select3", mapValue_s);
// 				File file;
// 				for (int i = 0; i < deletefileList.size(); i++) {
// 					file = new File(deletefileList.get(i));
// 					if (file.exists())
// 						file.delete();
// 				}
				
// 				// [TB_BOARD_ATTCH][TB_BOARD_COMMENT][TB_BOARD_SCORE][TB_BOARD]테이블의 해당 데이터를 모두 삭제
// 				Map deleteValMap = new HashMap();
// 				Map deleteInfoMap = new HashMap();
// 				List deleteList = new ArrayList();
// 				deleteValMap.put("boardID", boardID);
				
// 				deleteList.add(deleteValMap);
// 				deleteInfoMap.put("KBN", "delete");
// 				deleteInfoMap.put("SQLNAME", "forum_SQL.forumDelete");
// 				forumService.save(deleteList, deleteInfoMap);

// 				setMap.put("documentID", boardID);
// 				forumService.delete("schedule_SQL.deleteSchedlByDocumentID", setMap);
				
// 				Map mapValue = new HashMap();
// 				List getList = new ArrayList();
				
// 				//TODO
// 				//mapValue.put("pageNo", pageNo);
// 				//mapValue.put("listCnt", 5);
// 				mapValue.put("s_itemID",ID);
				
				
// 				//getList = setTotalScore(commonService.selectList("forum_SQL.forumGridList", mapValue));
// 				//String total_cnt = commonService.selectString("forum_SQL.forumTotalCnt", mapValue);
// 				//List selectList = commonService.selectList("forum_SQL.forumSelect", mapValue );
// 				//model.put("selectList", selectList );
// 				//model.put("total_cnt",total_cnt);
// 				//model.put("getList", getList);
							
// 				model.put("noticType", noticType);
// 				model.put("BoardMgtID", BoardMgtID);
// 				model.put("s_itemID", ID);
// 				model.put("pageNum", pageNum);				
// 				model.put("menu", getLabel(request, commonService));
// 				model.put("listType", StringUtil.checkNull(request.getParameter("listType"),""));
				
// 				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); 
// 				target.put(AJAX_SCRIPT, "fnCallBackDel();parent.$('#isSubmit').remove();");
// 				model.addAttribute(AJAX_RESULTMAP, target);
			
// 		} catch (Exception e) {
// 			System.out.println(e.toString());
// 		}
// 		return nextUrl(AJAXPAGE);
// 	}

// 	@RequestMapping(value = "/boardCommentDelete.do")
// 	public String boardCommentDelete(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
// 		Map target = new HashMap();
// 		try {
// 			String parentID = StringUtil.checkNull(request.getParameter("parentID"), "");
// 			String boardID = StringUtil.checkNull(request.getParameter("boardID"), "");
// 			String userId = StringUtil.checkNull(request.getParameter("userId"), "");
// 			String ItemID = StringUtil.checkNull(request.getParameter("ItemID"), "-1");
// 			String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"));
// 			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
// 			String searchType = StringUtil.checkNull(request.getParameter("searchType"));
// 			String searchValue = StringUtil.checkNull(request.getParameter("searchValue"));
// 			String scStartDt = StringUtil.checkNull(request.getParameter("scStartDt"));
// 			String scEndDt = StringUtil.checkNull(request.getParameter("scEndDt"));
// 			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
// 			String emailCode = StringUtil.checkNull(request.getParameter("emailCode"));
// 			String mailRcvListSQL = StringUtil.checkNull(request.getParameter("mailRcvListSQL"));
			
// 			// 파일 폴더에 저장된 해당 파일을 삭제
// 			// [TB_BOARD_ATTCH][TB_BOARD_COMMENT]테이블의 해당 데이터를 모두 삭제
// 			deleteCommentFileAll(parentID, boardID);
			
// 		/*	Map mapValue_s = new HashMap();
// 			List getList = new ArrayList();
			
// 			mapValue_s.put("parentID", parentID);
// 			mapValue_s.put("userId", userId);
// 			mapValue_s.put("languageID", commandMap.get("sessionCurrLangType"));
// 			mapValue_s.put("s_itemID", ItemID);
			
// 			getList = commonService.selectList("forumComment_SQL.commentGridList", mapValue_s);
			
// 			// [TB_BOARD]테이블의 코멘트 카운트를 업데이트
// 			Map updateValMap = new HashMap();
// 			Map updateInfoMap = new HashMap();
// 			List updateList = new ArrayList();
// 			updateValMap.put("parentID", parentID);
// 			updateList.add(updateValMap);
// 			updateInfoMap.put("KBN", "update");
// 			updateInfoMap.put("SQLNAME", "forum_SQL.commentDec");
// 			forumService.save(updateList, updateInfoMap);
			
// 			if (getList.size() == 0) {
// 				getList = commonService.selectList("forumComment_SQL.emptyForum", mapValue_s);
// 			}
// 			List fileList = new ArrayList();
// 			fileList = setLongFileName(commonService.selectList("forumFile_SQL.forumFile_select", mapValue_s));
			
// 			// 표시될 글의 점수 취득
// 			//int total_score = getTotalScore(boardID);
			
// 			// 코멘트 별 점수 취득
// 			mapValue_s.put("userId", userId);
			
// 			Map getMap = new HashMap();
// 			getMap = commonService.select("item_SQL.getObjectInfo", mapValue_s);
// 			*/
// 			//model.put("getMap", getMap);
// 			model.put("s_itemID",s_itemID);
// 			//model.put("fileList", fileList);
			
// 			//model.put("getList", getList);
// 			model.put("noticType", 100);
// 			//model.put("total_score", total_score);
// 			model.put("ItemID", ItemID);
// 			model.put("s_itemID", s_itemID);
// 			model.put("boardID", boardID);
// 			model.put("parentID", parentID);
// 			model.put("BoardMgtID", BoardMgtID);
// 			model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), "1"));
// 			model.put("searchType", searchType);
// 			model.put("searchValue", searchValue);
// 			model.put("scStartDt", scStartDt);
// 			model.put("scEndDt", scEndDt);
// 			model.put("screenType", screenType);
// 			model.put("emailCode", emailCode);
// 			model.put("mailRcvListSQL", mailRcvListSQL);
// 			model.put("listType", StringUtil.checkNull(request.getParameter("listType"), ""));
			
// 			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); 
// 			target.put(AJAX_SCRIPT, "fnCallBack("+parentID+","+s_itemID+"); $('#isSubmit').remove();");
// 			model.addAttribute(AJAX_RESULTMAP, target);

// 		} catch (Exception e) {
// 			System.out.println(e.toString());
// 		}
		
// 		return nextUrl(AJAXPAGE);
// 	}
	
// 	/**
// 	 * 긴 파일 이름 편집
// 	 */
// 	private List setLongFileName(List fileList) throws ExceptionUtil {
// 		List resultList = new ArrayList();
// 		try {
// 			for (int i = 0; i < fileList.size(); i++) {
// 				Map fileMap = new HashMap();
// 				fileMap = (Map) fileList.get(i);
// 				String fileRealName = fileMap.get("FileRealName").toString();
// 				if (fileRealName.length() > 12) {
// 					fileRealName = fileRealName.substring(0, 12) + "...";	
// 				} 
				
// 				fileMap.put("FileRealName12", fileRealName);
// 				resultList.add(fileMap);
				
// 			}
//         } catch(Exception e) {
//         	throw new ExceptionUtil(e.toString());
//         }
// 		return resultList;
// 	} 
	
// 	/**
// 	 * 리스트의 해당 별점 합계를 포럼 리스트에 추가
// 	 */
// 	private List setTotalScore(List forumList) throws ExceptionUtil {
// 		List resultList = new ArrayList();
// 		try {
// 			for (int i = 0; i < forumList.size(); i++) {
// 				Map forumMap = new HashMap();
// 				forumMap = (Map) forumList.get(i);
// 				String boardId = forumMap.get("privateId").toString();
// 				int totalScore = getTotalScore(boardId);
// 				forumMap.put("totalScore", totalScore);
// 				resultList.add(forumMap);
// 			}
//         } catch(Exception e) {
//         	throw new ExceptionUtil(e.toString());
//         }
		
// 		return resultList;
// 	} 

	
// 	/**
// 	 * 해당 글의 별점의 합계를 취득
// 	 */
// 	private int getTotalScore(String boardId) throws ExceptionUtil {
// 		Map mapValue_s = new HashMap();
// 		int total_score = 0;
// 		try {
// 			mapValue_s.put("privateId", boardId);
// 			List scoreList = commonService.selectList("forumScore_SQL.totalScore", mapValue_s);
			
// 			for (int i = 0; i < scoreList.size(); i++) {
// 				Map scoreMap = new HashMap();
// 				scoreMap = (Map) scoreList.get(i);
// 				int scoreVal = Integer.parseInt(scoreMap.get("Score").toString());
// 				total_score = total_score + scoreVal;
// 			}
//         } catch(Exception e) {
//         	throw new ExceptionUtil(e.toString());
//         }
		
// 		return total_score;
// 	}
	
// 	/**
// 	 * 해당 코멘트의 첨부파일을 삭제
// 	 */
// 	private void deleteCommentFile(String deleteSeq) throws ExceptionUtil {
// 		String seq[] = deleteSeq.split(",");
// 		Map deleteInfoMap = new HashMap();
// 		List deleteList = new ArrayList();
// 		try {
// 			// 화면에서 삭제된 파일들을 DB에서 삭제
// 			for (int i = 1; i < seq.length; i++) {
// 				String seqNo = seq[i];
// 				// 파일 폴더에 저장된 해당 파일을 삭제
// 				Map mapValue = new HashMap();
// 				mapValue.put("Seq", seqNo);
// 				File file = new File(commonService.selectString("forumFile_SQL.forumFile_select4", mapValue));
// 				if (file.exists()) {
// 					file.delete();
// 				}
// 				// [TB_BOARD_ATTCH]테이블의 해당 파일을 삭제
// 				Map deleteValMap = new HashMap();
// 				deleteValMap.put("Seq", seqNo);
// 				deleteList.add(deleteValMap);
// 			}
		
// 			deleteInfoMap.put("KBN", "delete");
// 			deleteInfoMap.put("SQLNAME", "forumFile_SQL.forumEditFile_delete");
// 			forumService.save(deleteList, deleteInfoMap);
//         } catch(Exception e) {
//         	throw new ExceptionUtil(e.toString());
//         }
// 	}
	
// 	/**
// 	 * 해당 코멘트의 첨부파일을 모두 삭제 
// 	 */
// 	private void deleteCommentFileAll(String parentID, String boardID) throws ExceptionUtil {
// 		// 파일 폴더에 저장된 해당 파일을 삭제
// 		Map mapValue = new HashMap();
// 		mapValue.put("parentID", parentID);
// 		mapValue.put("boardID", boardID);
// 		try {
// 			List<String> deletefileList = new ArrayList<String>();
// 			deletefileList = commonService.selectList("forumFile_SQL.forumFile_select2", mapValue);
// 			File file;
// 			for (int i = 0; i < deletefileList.size(); i++) {
// 				file = new File(deletefileList.get(i));
// 				if (file.exists()) {
// 					file.delete();
// 				}
// 			}			
// 			// [TB_BOARD_ATTCH][TB_BOARD_COMMENT]테이블의 해당 데이터를 모두 삭제
// 			Map deleteValMap = new HashMap();
// 			Map deleteInfoMap = new HashMap();
// 			List deleteList = new ArrayList();
// 			deleteValMap.put("parentID", parentID);
// 			deleteValMap.put("boardID", boardID);
// 			deleteList.add(deleteValMap);
// 			deleteInfoMap.put("KBN", "delete");
// 			deleteInfoMap.put("SQLNAME", "forum_SQL.forumDelete");
// 			forumService.save(deleteList, deleteInfoMap);
			
//         } catch(Exception e) {
//         	throw new ExceptionUtil(e.toString());
//         }
		
// 	}	
	
// 	@RequestMapping(value = "/editForumPost.do")
// 	public String editForumPost(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
// 		String url = "/board/frm/editForumPost";
// 		try {
				
// 				String noticType = StringUtil.checkNull(request.getParameter("noticType"), "");
// 				String boardID = StringUtil.checkNull(request.getParameter("BoardID"), "");
// 				String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"));
// 				String ID = StringUtil.checkNull(request.getParameter("ItemID"),"");
// 				//String userId = StringUtil.checkNull(request.getParameter("userId"), "");
// 				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
// 				String pageNum = StringUtil.checkNull(request.getParameter("pageNum"));
// 				String isMyCop = StringUtil.checkNull(request.getParameter("isMyCop"));
// 				String category = StringUtil.checkNull(request.getParameter("category"), "");
// 				String categoryIndex = StringUtil.checkNull(request.getParameter("categoryIndex"), "");
// 				String categoryCnt = StringUtil.checkNull(request.getParameter("categoryCnt"), "");
// 				String searchType = StringUtil.checkNull(request.getParameter("searchType"));
// 				String searchValue = StringUtil.checkNull(request.getParameter("searchValue"));
// 				String scStartDt = StringUtil.checkNull(request.getParameter("scStartDt"));
// 				String scEndDt = StringUtil.checkNull(request.getParameter("scEndDt"));
// 				String screenType = StringUtil.checkNull(request.getParameter("screenType"));
// 				String listType = StringUtil.checkNull(request.getParameter("listType"), "");
// 				String srID = StringUtil.checkNull(request.getParameter("srID"), "");
// 				String srType = StringUtil.checkNull(request.getParameter("srType"), "");
// 				String emailCode = StringUtil.checkNull(request.getParameter("emailCode"), "");
// 				String mailRcvListSQL = StringUtil.checkNull(request.getParameter("mailRcvListSQL"), "");
// 				String showItemInfo = StringUtil.checkNull(request.getParameter("showItemInfo"), "");
// 				String scrnType = StringUtil.checkNull(request.getParameter("scrnType"),"");
// 				String boardTitle = StringUtil.checkNull(request.getParameter("boardTitle"),"");
// 				String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"), "");
// 				String myBoard = StringUtil.checkNull(request.getParameter("myBoard"),"");
// 				String boardIds = StringUtil.checkNull(request.getParameter("boardIds"),"");
// 				String dueDateMgt = StringUtil.checkNull(request.getParameter("dueDateMgt"), "");
// 				String showAuthorInfo = StringUtil.checkNull(request.getParameter("showAuthorInfo"), "");
// 				String showItemVersionInfo = StringUtil.checkNull(request.getParameter("showItemVersionInfo"), "");
		
// 				model.put("boardTitle", boardTitle);
// 				Map setMap = new HashMap();
// 				Map resultMap = new HashMap();
// 				List fileList = new ArrayList();			
				
// 				if(!"".equals(BoardMgtID)){
// 					setMap.put("BoardMgtID", BoardMgtID);
// 					setMap.put("languageID", commandMap.get("sessionCurrLangType"));
// 					String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName",setMap);			
// 					model.put("boardMgtName", boardMgtName);	
// 					if(boardTitle.equals("")) model.put("boardTitle", boardMgtName);
// 				}
			
// 				setMap.put("languageID", languageID);
// 				setMap.put("boardID", boardID);			
// 				setMap.put("emailCode", emailCode);	
// 				setMap.put("myBoard", "Y");
// 				setMap.put("sessionUserId", sessionUserId);
// 				resultMap = commonService.select("forum_SQL.getForumEditInfo", setMap);
// 				if(!resultMap.isEmpty()) {
// 					String subject = StringUtil.checkNull(resultMap.get("Subject")).replaceAll("\"", "&quot;");
// 					resultMap.put("Subject", subject);
					
// 					String Content = StringUtil.checkNull(resultMap.get("Content"),"");
// 					String Subject = StringUtil.checkNull(resultMap.get("Subject"),"");
// 					Content = StringUtil.replaceFilterString(StringEscapeUtils.unescapeHtml4(Content));
// 					Subject = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(Subject));
// 					resultMap.put("Subject", Subject);
// 					resultMap.put("Content", Content);					
// 				}
// 				if(!sessionUserId.equals(resultMap.get("RegUserID"))) {
					
// 					model.put("boardID", boardID);
// 					model.put("BoardMgtID", BoardMgtID);
// 					model.put("noticType", noticType);
// 					model.put("pageNum", pageNum);
// 					model.put("menu", getLabel(request, commonService));	
// 					model.put("itemID", commandMap.get("s_itemID"));
// 					model.put("isMyCop", isMyCop);
// 					model.put("emailCode", emailCode);
// 					model.put("menu", getLabel(request, commonService));
					
// 					return nextUrl("/board/frm/boardForumList");
// 				}
// 				setMap.put("s_itemID", ID);
				
// 				Map ItemMgtUserMap = new HashMap();
// 				ItemMgtUserMap = commonService.select("forum_SQL.getItemAuthorName", setMap);
// 				String path = commonService.selectString("report_SQL.getMyPathAndName", setMap);
// 				String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);	
// 				//fileList = setLongFileName(commonService.selectList("forumFile_SQL.forumFile_select", setMap));
				
// 				model.put("resultMap",resultMap);
// 				model.put("CategoryYN", categoryYN);
// 				model.put("category", category);
// 				model.put("categoryIndex", categoryIndex);
// 				model.put("categoryCnt", categoryCnt);
// 				model.put("boardID", boardID);
// 				model.put("BoardMgtID", BoardMgtID);
// 				model.put("forumInfo", resultMap);
// 				model.put("fileList", fileList);
// 				model.put("noticType", noticType);
// 				model.put("pageNum", pageNum);
// 				model.put("menu", getLabel(request, commonService));	
// 				model.put("itemID", commandMap.get("s_itemID"));
// 				model.put("isMyCop", isMyCop);
// 				model.put("ItemMgtUserMap", ItemMgtUserMap);
// 				model.put("path",path);
// 				model.put("s_itemID", ID);
// 				model.put("searchType", searchType);
// 				model.put("searchValue", searchValue);
// 				model.put("scStartDt", scStartDt);
// 				model.put("scEndDt", scEndDt);
// 				model.put("screenType", screenType);
// 				model.put("itemFiles", (List)commonService.selectList("forumFile_SQL.forumFile_selectList", setMap));
// 				model.put("listType", listType);
// 				model.put("myBoard", myBoard);
// 				model.put("srID", srID);
// 				model.put("srType", srType);
// 				model.put("scrnType", scrnType);
// 				model.put("emailCode", emailCode);
// 				model.put("mailRcvListSQL", mailRcvListSQL);
// 				model.put("showItemInfo", showItemInfo);
// 				model.put("boardIds", boardIds);
// 				model.put("dueDateMgt", dueDateMgt);
// 				model.put("showAuthorInfo", showAuthorInfo);
// 				model.put("showItemVersionInfo", showItemVersionInfo);
				
// 				// file upload를 위한 session 등록
// 				HttpSession session = request.getSession(true);
// 				String uploadToken = fileUploadUtil.makeFileUploadFolderToken(session);
// 				model.put("uploadToken", uploadToken);
				
// 				String[] boardIDsArray = boardIds.split(",");
// 				List<String> boardIDList = Arrays.asList(boardIDsArray);
// 				if(!boardIDList.contains(String.valueOf(boardID))) { 
// 					return nextUrl("/board/frm/boardForumList");
// 				}
				
// 		} catch (Exception e) {
// 			System.out.println(e.toString());
// 		}

// 		return nextUrl(url);
// 	}
	
// 	@RequestMapping(value = "/boardForumChangeItem.do")
// 	public String boardForumChangeItem(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
// 		HashMap target = new HashMap();
// 		try{
// 			String ItemID = StringUtil.checkNull(request.getParameter("ItemID"), "");
// 			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),""); 
// 			String BoardID = StringUtil.checkNull(request.getParameter("BoardID"), "");
// 			String userId = String.valueOf(commandMap.get("sessionUserId"));
// 			String content = StringUtil.checkNull(request.getParameter("content"),""); 
// 			String languageID = StringUtil.checkNull(request.getParameter("languageID"),""); 
// 			String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"),"");
			
			
// 			Map updateValMap = new HashMap();
// 			Map updateInfoMap = new HashMap();
// 			List updateList = new ArrayList();
				
// 			updateValMap.put("ItemID",ItemID);
// 			updateValMap.put("s_itemID",s_itemID);
// 			updateValMap.put("languageID",languageID);
			
// 			updateValMap.put("itemTypeCode",commonService.selectString("item_SQL.getItemTypeCode", updateValMap));
			
// 			Map ItemMgtUserMap = new HashMap();
// 			ItemMgtUserMap = commonService.select("forum_SQL.getItemAuthorName", updateValMap);
			
// 			updateValMap.put("languageID",StringUtil.checkNull(request.getParameter("languageID"), ""));
// 			updateValMap.put("BoardID",BoardID);
// 			updateValMap.put("ItemMgtUserID",ItemMgtUserMap.get("AuthorID"));
// 			updateInfoMap.put("KBN", "update");
// 			updateInfoMap.put("SQLNAME", "forum_SQL.changeForumItem");
// 			updateList.add(updateValMap);
// 			forumService.save(updateList, updateInfoMap);
// 			target.put(AJAX_SCRIPT,"this.thisReload("+BoardID+","+ItemID+");");
// 			model.addAttribute(AJAX_RESULTMAP, target);
			
// 				HashMap setMap = new HashMap();
// 				HashMap setMailData = new HashMap();
// 				List receiverList = new ArrayList();
// 				Map tempMap = new HashMap();	
// 				HashMap authorInfo = new HashMap();
// 				Map temp = new HashMap();
				
// 				setMap.put("boardID", BoardID);
// 				setMap.put("sessionUserID", commandMap.get("sessionUserId"));
// 				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				
// 				Map boardMap = commonService.select("forum_SQL.getForumEditInfo", setMap);
// 				String subject = StringUtil.checkNull(boardMap.get("Subject"));
// 				subject = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(subject));
// 				subject = StringEscapeUtils.unescapeHtml4(subject);
				
// 				temp.put("Category", "EMAILCODE");
// 				temp.put("TypeCode", "QNARQS");
// 				temp.put("LanguageID", commandMap.get("sessionCurrLangType"));
// 				Map emDescription = commonService.select("common_SQL.label_commonSelect", temp);
				
// 				int idCnt = 0;
// 				setMap.put("crArea2", s_itemID);
				
// 				Map tmpInfo = new HashMap();
// 				tmpInfo = (HashMap) commonService.select("cr_SQL.getReceipt",setMap);
				
// 				setMap.put("s_itemID", s_itemID);						
// 				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				
// 				String itemName = commonService.selectString("item_SQL.getItemInfoHeader", setMap);
// 				int idx = itemName.indexOf("-");
// 				String itemName1 = itemName.substring(idx+1);
// 				String itemName2 = itemName.substring(0,idx);
// 				itemName = itemName1 + " ( " + itemName2 + ")";
				
// 				String pLabelName = commonService.selectString("item_SQL.getItemClassName", setMap);
				
// 				setMap.clear();
// 				setMap.put("MemberID", tmpInfo.get("MemberID"));
// 				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
// 				authorInfo = (HashMap) commonService.select("user_SQL.selectUser",setMap);
// 				tempMap.put("receiptUserID", authorInfo.get("MemberID"));
// 				receiverList.add(0,tempMap);
				
// 				setMap.put("BoardMgtID", BoardMgtID);
// 				String mgtUserID = commonService.selectString("forum_SQL.getBoardMgtName",setMap);
// 				if(mgtUserID != "" || mgtUserID != null){
// 					if(!mgtUserID.equals(StringUtil.checkNull(authorInfo.get("MemberID")))){
// 						tempMap = new HashMap();
// 						tempMap.put("receiptUserID", mgtUserID); //참조
// 						tempMap.put("receiptType", "CC");
// 						receiverList.add(1,tempMap);
// 					}
// 				}
			
// 				setMap.remove("MemberID");
// 				setMap.remove("BoardMgtID");
								
// 				setMailData.put("receiverList",receiverList);	
// 				setMailData.put("LanguageID",commandMap.get("sessionCurrLangType"));
// 				setMailData.put("subject", emDescription.get("LABEL_NM") + subject);	
// 				Map setMailMap = (Map)setEmailLog(request, commonService, setMailData, "BRDMAIL"); //CR 접수/취소
				
// 				if(StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")){
// 					HashMap mailMap = (HashMap)setMailMap.get("mailLog");	
// 					HashMap regUInfo = new HashMap();
						
// 					setMap.clear();
// 					setMap.put("MemberID", userId);
// 					setMap.put("languageID", commandMap.get("sessionCurrLangType"));
// 					regUInfo = (HashMap) commonService.select("user_SQL.selectUser",setMap);
					
// 					authorInfo.put("regUInfo", regUInfo);	
// 					authorInfo.put("subject", subject);	
// 					authorInfo.put("content", content);	
// 					authorInfo.put("boardID", BoardID);
// 					authorInfo.put("itemName", itemName);
// 					authorInfo.put("pLabelName", pLabelName);
// 					authorInfo.put("languageID", commandMap.get("sessionCurrLangType"));
					
// 					Map resultMailMap = EmailUtil.sendMail(mailMap,authorInfo,getLabel(request, commonService));
// 					System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMap.get("type")));
// 				}else{ 
// 					System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMap.get("msg")));
// 				}
			
// 		}catch(Exception e){
// 			System.out.println(e.toString());
// 			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
// 			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
// 		}		
// 		return nextUrl(AJAXPAGE);
// 	}
		
// 	private String removeAllTag(String str) {
// 		str = str.replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&#40;", "(").replaceAll("&#41;", ")").replace("&sect;","-").replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn").replaceAll("\r\n", "&&rn");
// 		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");

// 		return StringEscapeUtils.unescapeHtml4(str);
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
	
// 	@RequestMapping(value = "/blockedForum.do")
// 	public void blockForum(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
// 		JSONObject jsonObject = new JSONObject();
// 		Map map = new HashMap();
// 	    try {
// 	    	String blocked = StringUtil.checkNull(request.getParameter("blocked"),"");
// 	    	String boardID = StringUtil.checkNull(request.getParameter("boardID"),"");
// 	    	String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
// 	    	String userId = StringUtil.checkNull(request.getParameter("userID"),"");
// 	    	String mailRcvListSQL = StringUtil.checkNull(request.getParameter("mailRcvListSQL"),"");
// 	    	String regUserID = StringUtil.checkNull(request.getParameter("regUserID"),"");
// 	    	String itemAuthorID = StringUtil.checkNull(request.getParameter("itemAuthorID"),"");
// 	    	//String itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
// 	    	String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
// 	    	String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"),"");
// 	    	String type = StringUtil.checkNull(request.getParameter("type"),"");
// 	    	String postEmailYN = StringUtil.checkNull(request.getParameter("postEmailYN"),"");
// 	    	String replyMailOption = StringUtil.checkNull(request.getParameter("replyMailOption"),"");
	    	
// 	    	//if("".equals(s_itemID)) s_itemID = itemID;
	    	
// 	    	map.put("languageID", languageID);
// 	    	map.put("boardID", boardID);
	    	
// 	    	// 게시글 완료 시 blocked 1 처리
// 	    	if("board".equals(type)) {
// 	    		map.put("blocked", blocked);
// 				commonService.update("forum_SQL.updateBlocked", map);	    		
// 	    	}
			
// 	    	Map setMap = new HashMap();
// 			setMap.put("BoardMgtID", BoardMgtID);
// 			setMap.put("languageID", languageID);
			
// 	    	if("".equals(postEmailYN)){
// 	    		postEmailYN = commonService.selectString("board_SQL.getBoardPostEmailYN", setMap);
// 	    	}
	    	
// 	    	// 메일 전송 ( board 공통 : 요청자    /  reply 공통 : 댓글작성자 )
// 	    	if("Y".equals(postEmailYN) || "M".equals(postEmailYN)) {
// 				List receiverList = new ArrayList();
// 				Map receiverMap = new HashMap();
// 				int mailIndex = 0;
				
// 				// 수신자 : 긍 등록자
// 				if(!"".equals(regUserID) && !"review".equals(mailRcvListSQL)){
// 					receiverMap.put("receiptUserID", regUserID);
// 					receiverList.add(0,receiverMap);
// 					receiverMap = new HashMap();
// 				}
				
// 				setMap.put("BoardMgtID", BoardMgtID);
// 				String mgtUserID = commonService.selectString("forum_SQL.getBoardMgtName",setMap);
				
// 				if("1".equals(replyMailOption)){
// 					// 아이템 있을 경우 
// 					if(itemAuthorID != null && !"".equals(itemAuthorID)) {
// 						// 수신 : 아이템 담당자 
// 						Map tempMap = new HashMap();
// 						tempMap.put("receiptUserID", itemAuthorID);				
// 						receiverList.add(mailIndex++,tempMap);
						
// 						// mailRcvListSQL 없을 경우 
// 						if("".equals(mailRcvListSQL) || mailRcvListSQL == null){
// 							// 참조 : 개정담당자
// 							setMap.put("itemID", s_itemID);
// 							setMap.put("assignmentType", "CNGROLETP");
// 							setMap.put("assigned", "1");
// 							setMap.put("isAll", "N");
// 							List roleAssignedMbrList = commonService.selectList("role_SQL.getAssignedRoleList_gridList", setMap);
							
// 							for(int i = 0; i < roleAssignedMbrList.size(); i++){
// 								Map roleAssignedMbr = (Map) roleAssignedMbrList.get(i);
// 								String assignedMbrID = StringUtil.checkNull(roleAssignedMbr.get("MemberID"));
// 								tempMap = new HashMap();
// 								tempMap.put("receiptUserID", assignedMbrID); //참조
// 								tempMap.put("receiptType", "CC");
// 								receiverList.add(mailIndex++,tempMap);							
// 							}
// 							// 참조 : 댓글 등록자
// 							setMap.put("boardID", boardID);
// 							List replyMbrList = commonService.selectList("forum_SQL.getReplyList", setMap);
// 							for(int i = 0; i < replyMbrList.size(); i++){
// 								Map replyMbr = (Map) replyMbrList.get(i);
// 								String replyMbrID = StringUtil.checkNull(replyMbr.get("RegUserID"));
// 								tempMap = new HashMap();
// 								tempMap.put("receiptUserID", replyMbrID); //참조
// 								tempMap.put("receiptType", "CC");
// 								receiverList.add(mailIndex++,tempMap);							
// 							}
// 						}
// 					}
					
// 					if("review".equals(mailRcvListSQL)){
// 						// 수신 : 검토자 리스트
// 						String scheduleId = StringUtil.checkNull(request.getParameter("scheduleID"),"");
// 						setMap.put("scheduleId", scheduleId);
// 						List receiverList1 = commonService.selectList("schedule_SQL.getSharesReceiptUserList", setMap);
// 						receiverList.addAll(receiverList1);
// 					}
					
// 					// 참조 : 게시판 담당자
// 					if(mgtUserID != null && !"".equals(mgtUserID)){
// 						Map tempMap = new HashMap();
// 						tempMap.put("receiptUserID", mgtUserID); 	
// 						tempMap.put("receiptType", "CC");
// 						receiverList.add(mailIndex++,tempMap);
// 					}
// 				}
				
				
// 				if(receiverList.size()> 0){
					
// 					// 중복 수신자 제거
// 					receiverList = filterDuplicateReceiptUsers(receiverList);
					
// 					HashMap setMailData = (HashMap) commonService.select("forum_SQL.getForumEditInfo", map);
// 					String emailCode = StringUtil.checkNull(request.getParameter("emailCode"),"REQITMCLS");
// 					String originEmailCode = emailCode;
					
// 					Map boardMgtInfo = commonService.select("board_SQL.getBoardMgtInfo", setMap);
					
// 					// 특정 제목과 form을 사용하고싶은 경우 ( * 단 base가 되는 emailForm이 있어야 사용가능. form자체가 너무 다른 경우 makeEmailContents에 등록 후 varFilter가 아닌 emailCode를 변경해서 사용해야함 )
// 					String mgtVarfilter = StringUtil.checkNull(boardMgtInfo.get("VarFilter"));
// 					if(!"".equals(mgtVarfilter)){
// 						Map varFilterMap = getQueryParams(mgtVarfilter);
// 				        if(varFilterMap.containsKey("blockedEmailCode")){
// 				        	emailCode = StringUtil.checkNull(varFilterMap.get("blockedEmailCode"));
// 				        }
// 					}
					
// 					setMailData.put("EMAILCODE", emailCode);
// 					setMailData.put("receiverList", receiverList);
// 					setMailData.put("languageID", languageID);
// 					setMailData.put("subject", StringUtil.checkNull(setMailData.get("Subject")));
					
// 					// [01] 메일 로그
// 					Map setMailMapRst = (Map)setEmailLog(request, commonService, setMailData, emailCode);
					
// 					if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
						
// 						// [02] mail 송,수신자 정보 
// 						HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
						
// 						// [03] 메일안에 들어갈 내용 정보
// 						setMailData.put("emailCode", emailCode);
// 						String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", setMailData));
// 						setMailData.put("emailHTMLForm", emailHTMLForm);
						
// 						map.put("MemberID", userId);
// 						HashMap regUInfo = (HashMap) commonService.select("user_SQL.selectUser",map);
// 						setMailData.put("regUInfo", regUInfo);	
						
// 						map.put("BoardMgtID", StringUtil.checkNull(setMailData.get("BoardMgtID")));
// 						String boardMgtName = StringUtil.checkNull(commonService.selectString("board_SQL.getBoardMgtName",map));
// 						setMailData.put("boardMgtName", boardMgtName);	
						
// 						Map boardMap = commonService.select("forum_SQL.getForumEditInfo", map);
// 						// board 정보
// 						setMailData.put("content", StringUtil.checkNull(boardMap.get("Content"),""));	
// 						setMailData.put("regUInfo", regUInfo);	
// 						setMailData.put("subject", StringUtil.checkNull(boardMap.get("Subject"),""));	
// 						setMailData.put("boardID", boardID);
// 						setMailData.put("itemName", StringUtil.checkNull(boardMap.get("sharerNames"),""));
// 						setMailData.put("itemID", StringUtil.checkNull(boardMap.get("ItemName"),""));
// 						setMailData.put("languageID", cmmMap.get("sessionCurrLangType"));
// 						setMailData.put("loginID", cmmMap.get("sessionLoginId"));
// 						setMailData.put("boardMgtName", boardMgtName);
// 						setMailData.put("relTeamMembers", StringUtil.checkNull(boardMap.get("sharerNames"),""));
// 						setMailData.put("emailCode", emailCode);
						
// 						// board Category 정보
// 						setMailData.put("categoryNM", StringUtil.checkNull(boardMap.get("Category"),""));
						
// 						// 검토자 정보
// 						setMailData.put("sharerNames", StringUtil.checkNull(boardMap.get("sharerNames"),""));
						
// 						// [04] 메일 보내기
// 						// emailCode 원복
// 						setMailData.put("emailCode",originEmailCode);
// 						mailMap.put("dicTypeCode",originEmailCode);
						
// 						Map resultMailMap = EmailUtil.sendMail(mailMap, setMailData, getLabel(request, commonService));
						
// 					}else{
// 						System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
// 					}
// 				}
// 	    	}
			
// 			jsonObject.put("result", "success");
// 	        res.getWriter().print(jsonObject);
// 	    } catch (Exception e) {
// 	        jsonObject.put("result", "failed");
// 	        res.getWriter().print(jsonObject);
// 	        System.out.println(e.toString());
// 	    }
// 	}
	
// 	public static Map<String, String> getQueryParams(String query) {
//         Map<String, String> params = new HashMap<>();
        
//         if (query == null || query.isEmpty()) {
//             return params;
//         }
        
//         String[] pairs = query.substring(1).split("&");
        
//         for (String pair : pairs) {
//             String[] keyValue = pair.split("=");
//             if (keyValue.length == 2) {
//                 String key = keyValue[0];
//                 String value = keyValue[1];
//                 params.put(key, value);
//             }
//         }
        
//         return params;
//     }
	
// 	public static List<Map<String, Object>> filterDuplicateReceiptUsers(List<Map<String, Object>> list) {
// 		// 수신자는 수신자끼리 중복 제거
// 		// 참조자는 참조자끼리 중복 제거

// 		// 1) receiptType이 CC인 항목 체크
//         Map<Boolean, List<Map<String, Object>>> partitioned = list.stream()
//             .collect(Collectors.partitioningBy(m -> "CC".equals(m.get("receiptType"))));

//         // 2) 각 그룹별로 receiptUserID 기준 중복 제거
//         List<Map<String, Object>> ccList = partitioned.get(true).stream()
//                 .collect(Collectors.toMap(
//                         m -> (StringUtil.checkNull(m.get("receiptUserID"))),
//                         Function.identity(),
//                         (m1, m2) -> m1, 
//                         LinkedHashMap::new))
//                     .values().stream()
//                     .collect(Collectors.toList());;
                    
//         List<Map<String, Object>> nonCcList = partitioned.get(false).stream()
//                 .collect(Collectors.toMap(
//                         m -> (StringUtil.checkNull(m.get("receiptUserID"))),
//                         Function.identity(),
//                         (m1, m2) -> m1, 
//                         LinkedHashMap::new))
//                     .values().stream()
//                     .collect(Collectors.toList());

//         // 3) 원본 순서 유지하며 CC 없는 항목 먼저, 그 다음 CC 항목 병합
//         return Stream.concat(nonCcList.stream(), ccList.stream())
//                      .collect(Collectors.toList());
//     }
	
// 	public static List<Map<String, Object>> filterDuplicateAllReceiptUsers(List<Map<String, Object>> receiverList) {
// 			// 수신자 참조자 상관없이 모두 중복 제거
// 	        return receiverList.stream()
// 	            .collect(Collectors.toMap(
// 	                map -> (StringUtil.checkNull(map.get("receiptUserID"))),
// 	                Function.identity(),  
// 	                (m1, m2) -> {
// 	                    // 중복 receiptUserID
// 	                    boolean cc1 = "CC".equals(m1.get("receiptType"));
// 	                    boolean cc2 = "CC".equals(m2.get("receiptType"));

// 	                    if (cc1 && !cc2) return m2;      // 하나만 CC인 경우, CC를 삭제
// 	                    if (!cc1 && cc2) return m1;      // 하나만 CC인 경우, CC를 삭제
// 	                    return m1;  // 둘 다 CC 이거나 둘 다 없으면 첫번째 것 유지 (원래 순서 기준)
// 	                },
// 	                LinkedHashMap::new  // 입력 순서 유지
// 	            ))
// 	            .values().stream()
// 	            .collect(Collectors.toList());
// 	}
	
// }

// 	/* HEC only 
// 	public List aprvByActivityRole(String itemID, String cxnCode, String languageID) throws Exception {
// 		HashMap target = new HashMap();
// 		List roleMangerList = new ArrayList();
// 		try {
// 				HashMap setMap = new HashMap();
// 				setMap.put("s_itemID", itemID);
// 				setMap.put("cxnCode", cxnCode);		
// 				setMap.put("languageID", languageID);		
// 				roleMangerList = commonService.selectList("role_SQL.getItemCxnRoleManagerList", setMap);
				
// 		} catch (Exception e) {
// 			System.out.println(e);
// 			return null;
// 		}
// 		return roleMangerList;
// 	}
// 	*/
	
// 	/*
// 	public List aprvBySubActivityRole(String itemID, String languageID) throws Exception {
// 		HashMap target = new HashMap();
// 		List roleMangerList = new ArrayList();
// 		try {
// 			HashMap setMap = new HashMap();
// 			setMap.put("s_itemID", itemID);
// 			setMap.put("languageID", languageID);
// 			roleMangerList = commonService.selectList("role_SQL.getSubItemTeamRoleList_gridList", setMap);
			
// 		} catch (Exception e) {
// 			System.out.println(e);
// 			return null;
// 		}
// 		return roleMangerList;
// 	}
// 	*/
