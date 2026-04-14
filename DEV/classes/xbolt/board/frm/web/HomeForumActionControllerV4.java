//package xbolt.board.frm.web;
//
//import java.io.Serializable;
//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//import javax.annotation.Resource;
//import javax.servlet.http.HttpServletRequest;
//
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.ModelMap;
//import org.springframework.web.bind.annotation.RequestMapping;
//
//import xbolt.cmm.controller.XboltController;
//import xbolt.cmm.framework.util.StringUtil;
//import xbolt.cmm.framework.val.GlobalVal;
//import xbolt.cmm.service.CommonService;
//
///**
// * 업무 처리
// * @Class Name : BizController.java
// * @Description : 업무화면을 제공한다.
// * @Modification Information
// * @수정일		수정자		 수정내용
// * @---------	---------	-------------------------------
// * @2012. 09. 01. smartfactory		최초생성
// *
// * @since 2012. 09. 01.
// * @version 1.0
// */
//
//@Controller
//@SuppressWarnings("unchecked")
//
//public class HomeForumActionControllerV4  extends XboltController{
//	
//	@Resource(name = "commonService")
//	private CommonService commonService;
//	
//	@RequestMapping(value = "/forumMgtV4.do")
//	public String forumMgtV4(HttpServletRequest request, HashMap commanMap, ModelMap model) throws Exception {
//		
//		// cmm
//		String boardMgtID = StringUtil.checkNull(request.getParameter("boardMgtID"));
//		String varFilter = StringUtil.checkNull(request.getParameter("varFilter"), "4");
//		String myBoard = StringUtil.checkNull(request.getParameter("myBoard"));
//		String itemID = StringUtil.checkNull(commanMap.get("s_itemID"),"");
//		String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
//		String mailRcvListSQL = StringUtil.checkNull(request.getParameter("mailRcvListSQL"), "");
//		String emailCode = StringUtil.checkNull(request.getParameter("emailCode"), "");
//		String goDetailOpt = StringUtil.checkNull(request.getParameter("goDetailOpt"),"");
//		String boardType = StringUtil.checkNull(request.getParameter("boardType"),"frm"); // frm(표준) , cs , sr 
//		
//		model.put("s_itemID", itemID.trim());
//		model.put("noticType", varFilter);
//		model.put("emailCode", emailCode);
//		model.put("mailRcvListSQL", mailRcvListSQL);
//		model.put("myBoard", myBoard);
//		model.put("projectID", projectID);
//		model.put("menu", getLabel(request, commonService));
//		
//		if(!boardMgtID.equals("")) {
//			model.put("BoardMgtID", boardMgtID);
//		} else {
//			model.put("BoardMgtID", varFilter); 
//		}
//		
//		// 팝업에서 상세페이지로 바로 이동하는 옵션
//		if("Y".equals(goDetailOpt)){
//			String boardID = StringUtil.checkNull(request.getParameter("boardID"));
//			model.put("boardID", boardID);
//		}
//		model.put("goDetailOpt", goDetailOpt);
//		
//		// sr
//		String srID = StringUtil.checkNull(request.getParameter("srID"), "");
//		if(!"".equals(srID)){ 
//			boardType = "sr";
//		}
//		model.put("srID", srID);
//		
//		// cs
//		String showItemInfo = StringUtil.checkNull(request.getParameter("showItemInfo"));
//		String dueDateMgt = StringUtil.checkNull(request.getParameter("dueDateMgt"), "");
//		String replyMailOption = StringUtil.checkNull(request.getParameter("replyMailOption"), "");
//		String forumMailOption = StringUtil.checkNull(request.getParameter("forumMailOption"), "");
//		String showReplyDT = StringUtil.checkNull(request.getParameter("showReplyDT"), "");
//		String showAuthorInfo = StringUtil.checkNull(request.getParameter("showAuthorInfo"), "");
//		String showItemVersionInfo = StringUtil.checkNull(request.getParameter("showItemVersionInfo"), "");
//		String openDetailSearch = StringUtil.checkNull(request.getParameter("openDetailSearch"), "");
//		// tab에 달려있는 게시판 구분 ( height 값 조절용 )
//		String isItem = "N";
//		if(!"".equals(itemID)){ 
//			isItem = "Y";
//			boardType = "cs";
//		}
//		model.put("isItem", isItem);
//				
//		model.put("showItemInfo", showItemInfo);
//	    model.put("dueDateMgt", dueDateMgt);
//	    model.put("replyMailOption",replyMailOption);
//	    model.put("forumMailOption",forumMailOption);
//	    model.put("showReplyDT",showReplyDT);
//	    model.put("openDetailSearch",openDetailSearch);
//	    model.put("showAuthorInfo",showAuthorInfo);
//	    model.put("showItemVersionInfo",showItemVersionInfo);
//		
//	    model.put("boardType",boardType);
//		return nextUrl("/board/frm/boardForumMgtV4");
//	}
//	
//	@RequestMapping(value = "/boardForumListV4.do")
//	public String boardForumListV4(HttpServletRequest request, HashMap commanMap, ModelMap model) throws Exception {
//		
//		// TODO : SR 분리
//		// 표준 Forum
//		Map setMap = new HashMap();
//		List getList = new ArrayList();
//		String url = "/board/frm/boardForumListV4";
//		
//		try {
//			
//			String languageID = StringUtil.checkNull(commanMap.get("sessionCurrLangType"));
//			String ID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("s_itemID"), ""));
//			String s_itemID = StringUtil.replaceFilterString(StringUtil.checkNull( request.getParameter( "s_itemID" ),""));
//			String myBoard = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("myBoard")));
//			String noticType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("noticType"), ""));
//			String pageNum = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("pageNum"),"1"));
//			
//			String boardMgtID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("boardMgtID")));
//			String varFilter = StringUtil.checkNull(request.getParameter("varFilter"), "4");
//			
//			String screenType = StringUtil.replaceFilterString(StringUtil. checkNull(request.getParameter("screenType")));
//			String projectID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectID")));
//			String templProjectID = StringUtil.checkNull(commonService.selectString("board_SQL.getTemplProjectID", commanMap),"");
//			String scStartDt = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("scStartDt"), ""));
//			String scEndDt = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("scEndDt"), ""));
//			String category = StringUtil.replaceFilterString(StringUtil.checkNull(commanMap.get("category")));
//			String categoryIndex = StringUtil.replaceFilterString(StringUtil.checkNull(commanMap.get("categoryIndex")));			
//			String categoryCnt =  StringUtil.checkNull(commonService.selectString("board_SQL.getBoardMgtCatCNT", commanMap),"");
//			String searchType = StringUtil.replaceFilterString(StringUtil.checkNull(commanMap.get("searchType")));
//			String listType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("listType")));
//			
//			String emailCode = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("emailCode"),""));
//			String mailRcvListSQL = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("mailRcvListSQL"),""));
//			
//			String regUserName = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("regUserName"),""));
//			String scrnType =StringUtil.replaceFilterString( StringUtil.checkNull(request.getParameter("scrnType"),""));
//			String defCategory = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("defCategory"),""));
//			String boardTitle = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("boardTitle"),""));
//			String goDetailOpt = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("goDetailOpt"), ""));
//			
//			if(!"".equals(s_itemID) && !"Y".equals(goDetailOpt)) {
//				listType = "1";
//			}
//			
//			if(!boardMgtID.equals("")) {
//				model.put("BoardMgtID", boardMgtID);
//			} else {
//				model.put("BoardMgtID", varFilter); 
//			}
//			
//			
//			setMap.put("BoardMgtID", boardMgtID);
//			setMap.put("languageID", commanMap.get("sessionCurrLangType"));
//			Map boardMgtInfo = commonService.select("board_SQL.getBoardMgtInfo", setMap);
//			
//			List brdCatList = commonService.selectList("common_SQL.getBoardMgtCategory_commonSelect", setMap);
//			
//			if(boardTitle.equals("")) {
//		    	 boardTitle = StringUtil.checkNull(boardMgtInfo.get("boardMgtName"),"");
//			}
//			
//			Map<String, Serializable> ItemCsInfoMap = commonService.select("cs_SQL.getItemCsInfo",setMap);
//			
//			model.put("ItemCsInfoMap", ItemCsInfoMap);
//			model.put("boardMgtInfo", boardMgtInfo);
//			model.put("boardTitle", boardTitle);
//			model.put("s_itemID", s_itemID);
//			model.put("noticType", noticType);
//			model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode"),""));
//			model.put("search", StringUtil.checkNull(request.getParameter("search"),""));
//			model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue"),""));
//			model.put("pageNum", pageNum);
//			model.put("itemID", commanMap.get("s_itemID"));
//			model.put("myBoard", myBoard);
//			
//			model.put("screenType", screenType);
//			model.put("projectID", projectID);
//			model.put("scStartDt",scStartDt);
//			model.put("scEndDt",scEndDt);
//			model.put("brdCatList", brdCatList);
//			model.put("category", category);
//			model.put("categoryIndex", categoryIndex);
//			model.put("categoryCnt", categoryCnt);
//			model.put("brdCatListCnt", brdCatList.size());
//			model.put("searchType", searchType);
//			model.put("listType", listType);
//			model.put("mailRcvListSQL", mailRcvListSQL);
//			model.put("emailCode", emailCode);
//			
//			// SR Option ( 추후 분리 필요 )
//			String srID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("srID")));
//			String srType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("srType"),""));
//			if(srID!="" && !"".equals(srID)){
//				// 검색조건 Setting
//				model.put("srCategory", StringUtil.checkNull(request.getParameter("srCategory")));
//				model.put("srArea1", StringUtil.checkNull(request.getParameter("srArea1")));
//				model.put("subject", StringUtil.checkNull(request.getParameter("subject")));
//				model.put("searchStatus", StringUtil.checkNull(request.getParameter("searchStatus")));
//				model.put("receiptUser", StringUtil.checkNull(request.getParameter("receiptUser")));
//				model.put("requestUser", StringUtil.checkNull(request.getParameter("requestUser")));
//				model.put("requestTeam", StringUtil.checkNull(request.getParameter("requestTeam")));
//				model.put("startRegDT", StringUtil.checkNull(request.getParameter("startRegDT")));
//				model.put("endRegDT", StringUtil.checkNull(request.getParameter("endRegDT")));
//				model.put("searchSrCode", StringUtil.checkNull(request.getParameter("searchSrCode")));
//				model.put("srReceiptTeam", StringUtil.checkNull(request.getParameter("srReceiptTeam")));
//				model.put("srMode", StringUtil.checkNull(request.getParameter("srMode")));
//			}
//			
//			
//			model.put("baseUrl", GlobalVal.BASE_ATCH_URL);
//			model.put("menu", getLabel(request, commonService));
//			
//		} catch (Exception e) {
//			System.out.println(e.toString());
//		}
//
//		return nextUrl(url);
//	}
//	
//	@RequestMapping(value = "/csForumListV4.do")
//	public String csForumListV4(HttpServletRequest request, HashMap commanMap, ModelMap model) throws Exception {
//		
//		// CS forum
//		Map setMap = new HashMap();
//		List getList = new ArrayList();
//		String url = "/board/frm/csForumListV4";
//		
//		try {
//			
//			String languageID = StringUtil.checkNull(commanMap.get("sessionCurrLangType"));
//			String ID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("s_itemID"), ""));
//			String s_itemID = StringUtil.replaceFilterString(StringUtil.checkNull( request.getParameter( "s_itemID" ),""));
//			String myBoard = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("myBoard")));
//			String noticType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("noticType"), ""));
//			String pageNum = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("pageNum"),"1"));
//			
//			String boardMgtID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("boardMgtID")));
//			String varFilter = StringUtil.checkNull(request.getParameter("varFilter"), "4");
//			
//			String screenType = StringUtil.replaceFilterString(StringUtil. checkNull(request.getParameter("screenType")));
//			String projectID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectID")));
//			String templProjectID = StringUtil.checkNull(commonService.selectString("board_SQL.getTemplProjectID", commanMap),"");
//			String scStartDt = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("scStartDt"), ""));
//			String scEndDt = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("scEndDt"), ""));
//			String category = StringUtil.replaceFilterString(StringUtil.checkNull(commanMap.get("category")));
//			String categoryIndex = StringUtil.replaceFilterString(StringUtil.checkNull(commanMap.get("categoryIndex")));			
//			String categoryCnt =  StringUtil.checkNull(commonService.selectString("board_SQL.getBoardMgtCatCNT", commanMap),"");
//			String searchType = StringUtil.replaceFilterString(StringUtil.checkNull(commanMap.get("searchType")));
//			String listType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("listType")));
//			String emailCode = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("emailCode"),""));
//			String mailRcvListSQL = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("mailRcvListSQL"),""));
//			String showItemInfo = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("showItemInfo"),""));
//			String regUserName = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("regUserName"),""));
//			String authorName = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("authorName"),""));
//			String scrnType =StringUtil.replaceFilterString( StringUtil.checkNull(request.getParameter("scrnType"),""));
//			String defCategory = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("defCategory"),""));
//			String boardTitle = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("boardTitle"),""));
//			String dueDateMgt = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("dueDateMgt"),""));
//			String replyMailOption = StringUtil.checkNull(request.getParameter("replyMailOption"), "");
//			String forumMailOption = StringUtil.checkNull(request.getParameter("forumMailOption"), "");
//			String showReplyDT = StringUtil.checkNull(request.getParameter("showReplyDT"), "");
//			String openDetailSearch = StringUtil.checkNull(request.getParameter("openDetailSearch"), "");
//			String showAuthorInfo = StringUtil.checkNull(request.getParameter("showAuthorInfo"), "");
//			String showItemVersionInfo = StringUtil.checkNull(request.getParameter("showItemVersionInfo"), "");
//			String goDetailOpt = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("goDetailOpt"), ""));
//			
//			if(!"".equals(s_itemID) && !"Y".equals(goDetailOpt)) {
//				listType = "1";
//			}
//			
//			if(!boardMgtID.equals("")) {
//				model.put("BoardMgtID", boardMgtID);
//			} else {
//				model.put("BoardMgtID", varFilter); 
//			}
//			
//			setMap.put("BoardMgtID", boardMgtID);
//			setMap.put("languageID", commanMap.get("sessionCurrLangType"));
//			Map boardMgtInfo = commonService.select("board_SQL.getBoardMgtInfo", setMap);
//			
//			List brdCatList = commonService.selectList("common_SQL.getBoardMgtCategory_commonSelect", setMap);
//			
//			setMap.put("s_itemID", s_itemID);
//			Map ItemMgtUserMap = commonService.select("forum_SQL.getItemAuthorName", setMap);
//			
//			if(boardTitle.equals("")) {
//		    	 boardTitle = StringUtil.checkNull(boardMgtInfo.get("boardMgtName"),"");
//			}
//			
//			Map<String, Serializable> ItemCsInfoMap = commonService.select("cs_SQL.getItemCsInfo",setMap);
//			
//			model.put("ItemCsInfoMap", ItemCsInfoMap);
//			model.put("boardMgtInfo", boardMgtInfo);
//			model.put("boardTitle", boardTitle);
//			model.put("ItemMgtUserMap", ItemMgtUserMap);
//			model.put("s_itemID", s_itemID);
//			model.put("noticType", noticType);
//			model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode"),""));
//			model.put("search", StringUtil.checkNull(request.getParameter("search"),""));
//			model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue"),""));
//			model.put("pageNum", pageNum);
//			model.put("itemID", commanMap.get("s_itemID"));
//			model.put("myBoard", myBoard);
//			
//			model.put("screenType", screenType);
//			model.put("projectID", projectID);
//			model.put("scStartDt",scStartDt);
//			model.put("scEndDt",scEndDt);
//			model.put("brdCatList", brdCatList);
//			model.put("category", category);
//			model.put("categoryIndex", categoryIndex);
//			model.put("categoryCnt", categoryCnt);
//			model.put("brdCatListCnt", brdCatList.size());
//			model.put("searchType", searchType);
//			model.put("listType", listType);
//			model.put("mailRcvListSQL", mailRcvListSQL);
//			model.put("emailCode", emailCode);
//			model.put("showItemInfo", showItemInfo);
//			model.put("regUserName", regUserName);
//			model.put("authorName", authorName);
//			model.put("scrnType", scrnType);
//			model.put("defCategory", defCategory);
//			model.put("dueDateMgt", dueDateMgt);
//		    model.put("replyMailOption",replyMailOption);
//		    model.put("forumMailOption",forumMailOption);
//		    model.put("showReplyDT",showReplyDT);
//		    model.put("openDetailSearch",openDetailSearch);
//		    model.put("showAuthorInfo",showAuthorInfo);
//		    model.put("showItemVersionInfo",showItemVersionInfo);
//			
//			model.put("baseUrl", GlobalVal.BASE_ATCH_URL);
//			model.put("menu", getLabel(request, commonService));
//	
//			
//		} catch (Exception e) {
//			System.out.println(e.toString());
//		}
//
//		return nextUrl(url);
//	}
//	
//	@RequestMapping(value = "/srForumListV4.do")
//	public String srForumListV4(HttpServletRequest request, HashMap commanMap, ModelMap model) throws Exception {
//		
//		// SR forum
//		Map mapValue = new HashMap();
//		Map setMap = new HashMap();
//		List getList = new ArrayList();
//		String url = "/board/frm/srForumListV4";
//		
//		try {
//			
//			String languageID = StringUtil.checkNull(commanMap.get("sessionCurrLangType"));
//			String ID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("s_itemID"), ""));
//			String s_itemID = StringUtil.replaceFilterString(StringUtil.checkNull( request.getParameter( "s_itemID" ),""));
//			String myBoard = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("myBoard")));
//			String noticType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("noticType"), ""));
//			String pageNum = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("pageNum"),"1"));
//			
//			String boardMgtID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("boardMgtID")));
//			String varFilter = StringUtil.checkNull(request.getParameter("varFilter"), "4");
//			
//			String screenType = StringUtil.replaceFilterString(StringUtil. checkNull(request.getParameter("screenType")));
//			String projectID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectID")));
//			String templProjectID = StringUtil.checkNull(commonService.selectString("board_SQL.getTemplProjectID", commanMap),"");
//			String scStartDt = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("scStartDt"), ""));
//			String scEndDt = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("scEndDt"), ""));
//			String category = StringUtil.replaceFilterString(StringUtil.checkNull(commanMap.get("category")));
//			String categoryIndex = StringUtil.replaceFilterString(StringUtil.checkNull(commanMap.get("categoryIndex")));			
//			String categoryCnt =  StringUtil.checkNull(commonService.selectString("board_SQL.getBoardMgtCatCNT", commanMap),"");
//			String searchType = StringUtil.replaceFilterString(StringUtil.checkNull(commanMap.get("searchType")));
//			String listType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("listType")));
//			String srID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("srID")));
//			String srType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("srType"),""));
//			
//			String emailCode = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("emailCode"),""));
//			String mailRcvListSQL = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("mailRcvListSQL"),""));
//			
//			String scrnType =StringUtil.replaceFilterString( StringUtil.checkNull(request.getParameter("scrnType"),""));
//			String defCategory = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("defCategory"),""));
//			String boardTitle = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("boardTitle"),""));
//			
//			if(!boardMgtID.equals("")) {
//				model.put("BoardMgtID", boardMgtID);
//			} else {
//				model.put("BoardMgtID", varFilter); 
//			}
//			
//			mapValue.put("languageID", languageID);
//			mapValue.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode"),""));
//			mapValue.put("search", StringUtil.checkNull(request.getParameter("search"),""));
//			mapValue.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue"),""));
//			if ("Y".equals(myBoard)) {
//				mapValue.put("myID", commanMap.get("sessionUserId"));
//				model.put("myID", commanMap.get("sessionUserId"));
//			}
//			
//			setMap.put("BoardMgtID", boardMgtID);
//			setMap.put("languageID", commanMap.get("sessionCurrLangType"));
//			Map boardMgtInfo = commonService.select("board_SQL.getBoardMgtInfo", setMap);
//			
//			List brdCatList = commonService.selectList("common_SQL.getBoardMgtCategory_commonSelect", setMap);
//			
//			if(boardTitle.equals("")) {
//		    	 boardTitle = StringUtil.checkNull(boardMgtInfo.get("boardMgtName"),"");
//			}
//			
//			Map<String, Serializable> ItemCsInfoMap = commonService.select("cs_SQL.getItemCsInfo",setMap);
//			
//			model.put("ItemCsInfoMap", ItemCsInfoMap);
//			model.put("boardMgtInfo", boardMgtInfo);
//			model.put("boardTitle", boardTitle);
//			model.put("s_itemID", s_itemID);
//			model.put("noticType", noticType);
//			model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode"),""));
//			model.put("search", StringUtil.checkNull(request.getParameter("search"),""));
//			model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue"),""));
//			model.put("pageNum", pageNum);
//			model.put("itemID", commanMap.get("s_itemID"));
//			model.put("myBoard", myBoard);
//			
//			getList = commonService.selectList("forum_SQL.forumSelect", mapValue );
//			model.put("selectList", getList);
//			
//			model.put("screenType", screenType);
//			model.put("projectID", projectID);
//			model.put("scStartDt",scStartDt);
//			model.put("scEndDt",scEndDt);
//			model.put("brdCatList", brdCatList);
//			model.put("category", category);
//			model.put("categoryIndex", categoryIndex);
//			model.put("categoryCnt", categoryCnt);
//			model.put("brdCatListCnt", brdCatList.size());
//			model.put("searchType", searchType);
//			model.put("listType", listType);
//			model.put("srID", srID);
//			model.put("mailRcvListSQL", mailRcvListSQL);
//			model.put("emailCode", emailCode);
//			model.put("scrnType", scrnType);
//			model.put("srType", srType);
//			model.put("defCategory", defCategory);
//			
//			model.put("baseUrl", GlobalVal.BASE_ATCH_URL);
//			model.put("menu", getLabel(request, commonService));
//	
//			// SR Option
//			if(srID!="" && !"".equals(srID)){
//				// 검색조건 Setting
//				model.put("srCategory", StringUtil.checkNull(request.getParameter("srCategory")));
//				model.put("srArea1", StringUtil.checkNull(request.getParameter("srArea1")));
//				model.put("subject", StringUtil.checkNull(request.getParameter("subject")));
//				model.put("searchStatus", StringUtil.checkNull(request.getParameter("searchStatus")));
//				model.put("receiptUser", StringUtil.checkNull(request.getParameter("receiptUser")));
//				model.put("requestUser", StringUtil.checkNull(request.getParameter("requestUser")));
//				model.put("requestTeam", StringUtil.checkNull(request.getParameter("requestTeam")));
//				model.put("startRegDT", StringUtil.checkNull(request.getParameter("startRegDT")));
//				model.put("endRegDT", StringUtil.checkNull(request.getParameter("endRegDT")));
//				model.put("searchSrCode", StringUtil.checkNull(request.getParameter("searchSrCode")));
//				model.put("srReceiptTeam", StringUtil.checkNull(request.getParameter("srReceiptTeam")));
//				model.put("srMode", StringUtil.checkNull(request.getParameter("srMode")));
//			}
//			
//			
//		} catch (Exception e) {
//			System.out.println(e.toString());
//		}
//
//		return nextUrl(url);
//	}
//	
//}