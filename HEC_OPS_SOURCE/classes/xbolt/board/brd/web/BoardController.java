package xbolt.board.brd.web;

import java.io.PrintStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

@Controller
public class BoardController extends XboltController
{
  private final Log _log = LogFactory.getLog(getClass());

  @Autowired
  @Qualifier("commonService")
  private CommonService commonService;

  @Resource(name="boardService")
  private CommonService boardService;

  @RequestMapping({"/boardMgt.do"})
  public String boardMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception { model.addAttribute("title", "HOME");
    String reqBoardMgtID = StringUtil.checkNull(request.getParameter("boardMgtID"), "");
    String defBoardMgtID = StringUtil.checkNull(cmmMap.get("defBoardMgtID"));
    String BoardMgtID = "";
    String url = "/board/brd/boardMainMenu";
    try {
      List boardMgtList = new ArrayList();
      String parentID = "";
      if (!reqBoardMgtID.equals("")) {
        parentID = this.commonService.selectString("board_SQL.getBoardParentID", cmmMap);
        if (parentID.equals("0")) {
          Map setData = new HashMap();
          setData.put("parentID", reqBoardMgtID);
          reqBoardMgtID = StringUtil.checkNull(this.commonService.selectString("board_SQL.getFirstBoardMgtID", setData));
        }
      }
      List boardGrpList = this.commonService.selectList("board_SQL.boardGrpList", cmmMap);
      boardMgtList = this.commonService.selectList("board_SQL.boardMgtListNew", cmmMap);
      String templName = this.commonService.selectString("board_SQL.getTemplName", cmmMap);

      model.put("templName", templName);
      model.put("boardGrpList", boardGrpList);
      model.put("boardMgtList", boardMgtList);
      model.put("boardLstCnt", StringUtil.checkNull(Integer.valueOf(boardMgtList.size()), "0"));
      int grpOpenClose = 1;
      int loadingBoard = 2;
      int j = 2;
      String boardGrpID = "";
      for (int i = 0; i < boardMgtList.size(); i++) {
        Map board = (HashMap)boardMgtList.get(i);
        if (!reqBoardMgtID.equals("")) {
          if (reqBoardMgtID.equals(StringUtil.checkNull(board.get("BoardMgtID")))) {
            model.put("BoardMgtID", StringUtil.checkNull(board.get("BoardMgtID")));
            model.put("StatusCount", Integer.valueOf(i + 1));
            model.put("Url", StringUtil.checkNull(board.get("URL")));
            model.put("BoardTypeCD", StringUtil.checkNull(board.get("BoardTypeCD")));
            boardGrpID = StringUtil.checkNull(board.get("ParentID"));
            loadingBoard = j;
          }
        }
        else if (i == 0) {
          BoardMgtID = StringUtil.checkNull(board.get("BoardMgtID"));
          model.put("BoardMgtID", StringUtil.checkNull(board.get("BoardMgtID")));
          model.put("StatusCount", Integer.valueOf(i + 1));
          model.put("Url", StringUtil.checkNull(board.get("URL")));
          model.put("BoardTypeCD", StringUtil.checkNull(board.get("BoardTypeCD")));
          break;
        }

        j++;
      }
      System.out.println("bbb loadingBoard:" + loadingBoard);
      if (!reqBoardMgtID.equals("")) {
        for (int i = 0; i < boardGrpList.size(); i++) {
          Map boardGrpMap = (HashMap)boardGrpList.get(i);
          if (!boardGrpID.equals(StringUtil.checkNull(boardGrpMap.get("BoardGrpID"))))
            continue;
          grpOpenClose = i + 1;
        }
      }

      model.put("loadingBoard", Integer.valueOf(loadingBoard));
      model.put("grpOpenClose", Integer.valueOf(grpOpenClose));

      String menuIndex = "";
      String space = " ";
      String startBoardIndex = "1";

      int ttlCnt = boardMgtList.size() + boardGrpList.size();
      int cnt = 1;
      for (int i = 0; ttlCnt > i; i++) {
        menuIndex = menuIndex + space + cnt;
        cnt++;
      }
      model.put("menuIndex", menuIndex);
      model.put("startBoardIndex", startBoardIndex);
      model.put("reqBoardMgtID", reqBoardMgtID);
      model.put("menu", getLabel(request, this.commonService));
      model.put("projectID", cmmMap.get("projectID"));
      model.put("defBoardMgtID", defBoardMgtID);
    }
    catch (Exception e)
    {
      if (this._log.isInfoEnabled()) this._log.info("BoardController::boardMgt::Error::" + e);
      throw new ExceptionUtil(e.toString());
    }

    return nextUrl(url); } 
  @RequestMapping({"/boardList.do"})
  public String boardList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"), request.getParameter("boardMgtID"));
    String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "1");

    String boardTypeCD = StringUtil.checkNull(request.getParameter("boardTypeCD"), "");
    String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");
    String defBoardMgtID = StringUtil.checkNull(cmmMap.get("defBoardMgtID"));
    String category = StringUtil.checkNull(cmmMap.get("category"));
    String categoryIndex = StringUtil.checkNull(cmmMap.get("categoryIndex"));
    String categoryCnt = StringUtil.checkNull(cmmMap.get("categoryCnt"));
    String scStartDt = StringUtil.checkNull(cmmMap.get("scStartDt"));
    String searchKey = StringUtil.checkNull(cmmMap.get("searchKey"));
    String searchValue = StringUtil.checkNull(cmmMap.get("searchValue"));
    String scEndDt = StringUtil.checkNull(cmmMap.get("scEndDt"));
    String myBoard = StringUtil.checkNull(request.getParameter("myBoard"));
    String icon = "icon_folder_upload_title.png";
    String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
    String templProjectID = StringUtil.checkNull(this.commonService.selectString("board_SQL.getTemplProjectID", cmmMap), "");
    String projectType = "";
    String projectCategory = StringUtil.checkNull(request.getParameter("projectCategory"), "");
    String projectIDs = StringUtil.checkNull(request.getParameter("projectIDs"), "");
    String varFilter = StringUtil.checkNull(request.getParameter("varFilter"), "4");

    Map setMap2 = new HashMap();
    setMap2.put("MenuID", boardTypeCD);
    String boardUrl = StringUtil.checkNull(this.commonService.selectString("menu_SQL.getMenuVarfilter", setMap2), "");
    int idx = boardUrl.indexOf("=");
    boardUrl = boardUrl.substring(idx + 1);
    String url = boardUrl;
    if (boardUrl.equals("")) url = "/board/brd/boardList";

    if (((BoardMgtID == null) || (BoardMgtID == "")) && (varFilter != null)) {
      BoardMgtID = varFilter;
    }

    if ((BoardMgtID != null) && (BoardMgtID.equals("4"))) {
      icon = "comment_user.png";
    }
    try
    {
      Map setMap = new HashMap();
      String project = "";
      if ((projectID != null) && (!"".equals(projectID)))
        templProjectID = projectID;
      else {
        projectID = templProjectID;
      }
      if ((templProjectID != null) && (!"".equals(templProjectID))) {
        setMap.put("s_itemID", templProjectID);
        projectType = StringUtil.checkNull(this.commonService.selectString("project_SQL.getProjectType", setMap), "");
      }

      setMap.put("BoardMgtID", BoardMgtID);
      setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
      Map boardMgtInfo = this.commonService.select("board_SQL.getBoardMgtInfo", setMap);
      model.put("boardMgtInfo", boardMgtInfo);

      int totCnt = NumberUtil.getIntValue(this.commonService.selectString("board_SQL.boardTotalCnt", setMap));

      String boardMgtName = this.commonService.selectString("board_SQL.getBoardMgtName", setMap);
      String categoryYN = this.commonService.selectString("board_SQL.getBoardCategoryYN", setMap);
      model.put("boardMgtName", boardMgtName);
      model.put("CategoryYN", categoryYN);

      String likeYN = this.commonService.selectString("board_SQL.getBoardLikeYN", setMap);
      model.put("LikeYN", likeYN);

      if ("Y".equals(myBoard)) {
        model.put("myID", cmmMap.get("sessionUserId"));
        model.put("boardMgtName", "Communication");
      }

      setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
      List brdCatList = this.commonService.selectList("common_SQL.getBoardMgtCategory_commonSelect", setMap);
      Map mgtInfoMap = this.commonService.select("board_SQL.getBoardMgtInfo", setMap);

      if (("N".equals(mgtInfoMap.get("MgtOnlyYN"))) && (Integer.parseInt(mgtInfoMap.get("MgtGRID").toString()) > 0)) {
        Map tmpMap = new HashMap();

        tmpMap.put("checkID", cmmMap.get("sessionUserId"));
        tmpMap.put("groupID", mgtInfoMap.get("MgtGRID"));
        String check = StringUtil.checkNull(this.commonService.selectString("user_SQL.getEndGRUser", tmpMap), "");

        if (!"".equals(check)) {
          mgtInfoMap.put("MgtGRID2", mgtInfoMap.get("MgtGRID"));
        }
        else {
          mgtInfoMap.put("MgtGRID2", "");
        }
      }

      model.put("scStartDt", scStartDt);
      model.put("searchKey", searchKey);
      model.put("searchValue", searchValue);
      model.put("scEndDt", scEndDt);
      model.put("templProjectID", templProjectID);
      model.put("projectType", projectType);
      model.put("mgtInfoMap", mgtInfoMap);
      model.put("brdCatList", brdCatList);
      model.put("brdCatListCnt", Integer.valueOf(brdCatList.size()));
      model.put("totalPage", Integer.valueOf(totCnt));
      model.put("pageNum", pageNum);
      model.put("menu", getLabel(request, this.commonService));
      model.put("setXML", setXML());
      model.put("icon", icon);
      model.put("BoardMgtID", BoardMgtID);
      model.put("screenType", screenType);
      model.put("myBoard", myBoard);
      model.put("projectID", projectID);
      model.put("boardUrl", boardUrl);
      model.put("defBoardMgtID", defBoardMgtID);
      model.put("category", category);
      model.put("categoryIndex", categoryIndex);
      model.put("categoryCnt", categoryCnt);
      model.put("baseUrl", GlobalVal.BASE_ATCH_URL);
      model.put("projectCategory", projectCategory);
      model.put("projectIDs", projectIDs);
    }
    catch (Exception e) {
      if (this._log.isInfoEnabled()) this._log.info("BoardController::boardList::Error::" + e);
      throw new ExceptionUtil(e.toString());
    }

    return nextUrl(url);
  }

  @RequestMapping({"/boardDetail.do"})
  public String boardDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    String url = "/board/brd/boardDetail";
    try
    {
      String path = GlobalVal.FILE_UPLOAD_BOARD_DIR + cmmMap.get("sessionUserId");
      String templProjectID = StringUtil.checkNull(this.commonService.selectString("board_SQL.getTemplProjectID", cmmMap), "");
      if (!path.equals("")) FileUtil.deleteDirectory(path);

      String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"), "1");
      String currPage = StringUtil.checkNull(request.getParameter("currPage"), "1");
      String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");
      String boardUrl = StringUtil.checkNull(request.getParameter("url"), "");
      String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
      String templprojectID = StringUtil.checkNull(request.getParameter("templProjectID"), "");
      String category = StringUtil.checkNull(request.getParameter("category"), "");
      String categoryIndex = StringUtil.checkNull(request.getParameter("categoryIndex"), "");
      String categoryCnt = StringUtil.checkNull(request.getParameter("categoryCnt"), "");

      String scStartDt = StringUtil.checkNull(cmmMap.get("scStartDt"));
      String searchKey = StringUtil.checkNull(cmmMap.get("searchKey"));
      String searchValue = StringUtil.checkNull(cmmMap.get("searchValue"));
      String scEndDt = StringUtil.checkNull(cmmMap.get("scEndDt"));

      String templProjectType = "";
      String projectType = StringUtil.checkNull(request.getParameter("projectType"), "");
      String projectCategory = StringUtil.checkNull(request.getParameter("projectCategory"), "");
      String projectIDs = StringUtil.checkNull(request.getParameter("projectIDs"), "");

      Map setMap = new HashMap();
      setMap.put("s_itemID", templProjectID);
      templProjectType = StringUtil.checkNull(this.commonService.selectString("project_SQL.getProjectType", setMap), "");

      if (BoardMgtID != null) {
        setMap.put("BoardMgtID", BoardMgtID);
        setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
        String boardMgtName = this.commonService.selectString("board_SQL.getBoardMgtName", setMap);
        String categoryYN = this.commonService.selectString("board_SQL.getBoardCategoryYN", setMap);
        model.put("boardMgtName", boardMgtName);
        model.put("CategoryYN", categoryYN);
      }

      this.commonService.update("board_SQL.boardUpdateReadCnt", cmmMap);
      Map result = this.commonService.select("board_SQL.boardDetail", cmmMap);

      String Content = StringUtil.checkNull(result.get("Content"), "");

      Content = Content.replaceAll("&lt;", "<");
      Content = Content.replaceAll("&gt;", ">");
      Content = Content.replaceAll("&quot;", "\"");
      Content = StringEscapeUtils.unescapeHtml4(Content);
      result.put("Content", Content);
      model.put("result", result);

      model.put("itemFiles", this.commonService.selectList("boardFile_SQL.boardFile_selectList", cmmMap));

      model.put("resultMap", result);

      String LikeYN = this.commonService.selectString("board_SQL.getBoardLikeYN", setMap);
      model.put("LikeYN", LikeYN);
      String likeCNT = "";

      if ((LikeYN != null) && ("Y".equals(LikeYN))) {
        setMap.put("BoardMgtID", result.get("BoardMgtID"));
        setMap.put("BoardID", result.get("BoardID"));
        likeCNT = this.commonService.selectString("board_SQL.getBoardLikeCNT", setMap);
        model.put("likeCNT", likeCNT);
      }

      model.put("scStartDt", scStartDt);
      model.put("searchKey", searchKey);
      model.put("searchValue", searchValue);
      model.put("scEndDt", scEndDt);
      model.put("templProjectID", templProjectID);
      model.put("projectType", projectType);
      model.put("BoardMgtID", BoardMgtID);
      model.put("currPage", currPage);
      model.put("NEW", cmmMap.get("NEW"));
      model.put("screenType", screenType);
      model.put("url", boardUrl);
      model.put("menu", getLabel(request, this.commonService));
      model.put("projectID", projectID);
      model.put("defBoardMgtID", cmmMap.get("defBoardMgtID"));
      model.put("category", category);
      model.put("categoryIndex", categoryIndex);
      model.put("categoryCnt", categoryCnt);
      model.put("projectCategory", projectCategory);
      model.put("projectIDs", projectIDs);

      if (((screenType.equals("PG")) || (screenType.equals("PJT"))) && 
        (!projectID.equals(""))) {
        Map projectMap = new HashMap();
        setMap.put("parentID", projectID);
        setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
        projectMap = this.commonService.select("task_SQL.getProjectAuthorID", setMap);
        model.put("projectMap", projectMap);
      }
    }
    catch (Exception e)
    {
      if (this._log.isInfoEnabled()) this._log.info("BoardController::boardDetail::Error::" + e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl(url);
  }
  @RequestMapping({"/editBoard.do"})
  public String editBoard(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    String url = "/board/brd/editBoard";
    try
    {
      String path = GlobalVal.FILE_UPLOAD_BOARD_DIR + cmmMap.get("sessionUserId");
      String templProjectID = StringUtil.checkNull(this.commonService.selectString("board_SQL.getTemplProjectID", cmmMap), "");
      if (!path.equals("")) FileUtil.deleteDirectory(path);

      String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"), "1");
      String currPage = StringUtil.checkNull(request.getParameter("currPage"), "1");
      String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");
      String boardUrl = StringUtil.checkNull(request.getParameter("url"), "");
      String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
      String templprojectID = StringUtil.checkNull(request.getParameter("templProjectID"), "");
      String category = StringUtil.checkNull(request.getParameter("category"), "");
      String categoryIndex = StringUtil.checkNull(request.getParameter("categoryIndex"), "");
      String categoryCnt = StringUtil.checkNull(request.getParameter("categoryCnt"), "");

      String scStartDt = StringUtil.checkNull(cmmMap.get("scStartDt"));
      String searchKey = StringUtil.checkNull(cmmMap.get("searchKey"));
      String searchValue = StringUtil.checkNull(cmmMap.get("searchValue"));
      String scEndDt = StringUtil.checkNull(cmmMap.get("scEndDt"));

      String templProjectType = "";
      String projectType = StringUtil.checkNull(request.getParameter("projectType"), "");
      String projectCategory = StringUtil.checkNull(request.getParameter("projectCategory"), "");

      Map setMap = new HashMap();
      setMap.put("s_itemID", templProjectID);
      templProjectType = StringUtil.checkNull(this.commonService.selectString("project_SQL.getProjectType", setMap), "");

      if (BoardMgtID != null) {
        setMap.put("BoardMgtID", BoardMgtID);
        setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
        String boardMgtName = this.commonService.selectString("board_SQL.getBoardMgtName", setMap);
        String categoryYN = this.commonService.selectString("board_SQL.getBoardCategoryYN", setMap);
        model.put("boardMgtName", boardMgtName);
        model.put("CategoryYN", categoryYN);
      }

      if ("N".equals(cmmMap.get("NEW")))
      {
        this.commonService.update("board_SQL.boardUpdateReadCnt", cmmMap);
        Map result = this.commonService.select("board_SQL.boardDetail", cmmMap);

        String Content = StringUtil.checkNull(result.get("Content"), "");

        Content = Content.replaceAll("&lt;", "<");
        Content = Content.replaceAll("&gt;", ">");
        Content = Content.replaceAll("&quot;", "\"");
        result.put("Content", Content);
        model.put("result", result);

        model.put("itemFiles", this.commonService.selectList("boardFile_SQL.boardFile_selectList", cmmMap));

        model.put("resultMap", result);

        String LikeYN = this.commonService.selectString("board_SQL.getBoardLikeYN", setMap);
        model.put("LikeYN", LikeYN);
        String likeCNT = "";

        if ((LikeYN != null) && ("Y".equals(LikeYN))) {
          setMap.put("BoardMgtID", result.get("BoardMgtID"));
          setMap.put("BoardID", result.get("BoardID"));
          likeCNT = this.commonService.selectString("board_SQL.getBoardLikeCNT", setMap);
          model.put("likeCNT", likeCNT);
        }
      }
      else {
        Map result = new HashMap();

        result.put("BoardMgtID", BoardMgtID);
        result.put("boardID", "");
        result.put("Subject", "");
        result.put("Content", "");
        result.put("WriteUserID", "");
        result.put("PreBoardID", cmmMap.get("PreBoardID"));
        result.put("ReplyLev", "");
        result.put("ReadCNT", "");
        result.put("WriteUserNm", "");
        result.put("AttFileID", "");
        result.put("RegDT", "");
        result.put("RegUserID", "");
        result.put("ModDT", "");
        result.put("ModUserID", "");
        result.put("Category", "");
        model.put("resultMap", result);
      }

      model.put("scStartDt", scStartDt);
      model.put("searchKey", searchKey);
      model.put("searchValue", searchValue);
      model.put("scEndDt", scEndDt);
      model.put("templProjectID", templProjectID);
      model.put("projectType", projectType);
      model.put("BoardMgtID", BoardMgtID);
      model.put("currPage", currPage);
      model.put("NEW", cmmMap.get("NEW"));
      model.put("screenType", screenType);
      model.put("url", boardUrl);
      model.put("menu", getLabel(request, this.commonService));
      model.put("projectID", projectID);
      model.put("defBoardMgtID", cmmMap.get("defBoardMgtID"));
      model.put("category", category);
      model.put("categoryIndex", categoryIndex);
      model.put("categoryCnt", categoryCnt);
      model.put("projectCategory", projectCategory);

      if (((screenType.equals("PG")) || (screenType.equals("PJT"))) && 
        (!projectID.equals(""))) {
        Map projectMap = new HashMap();
        setMap.put("parentID", projectID);
        setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
        projectMap = this.commonService.select("task_SQL.getProjectAuthorID", setMap);
        model.put("projectMap", projectMap);
      }
    }
    catch (Exception e)
    {
      if (this._log.isInfoEnabled()) this._log.info("BoardController::boardDetail::Error::" + e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl(url);
  }

  @RequestMapping({"/boardAdminMgt.do"})
  public String boardAdminMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception
  {
    String BoardMgtID = "";
    String url = "/board/brd/boardMainMenu";
    try {
      List boardMgtList = new ArrayList();
      boardMgtList = this.commonService.selectList("board_SQL.boardMgtListNew", cmmMap);
      List boardGrpList = this.commonService.selectList("board_SQL.boardGrpList", cmmMap);
      String templName = this.commonService.selectString("board_SQL.getTemplName", cmmMap);
      String boardMgtID = StringUtil.checkNull(cmmMap.get("boardMgtID"));
      String defBoardMgtID = StringUtil.checkNull(cmmMap.get("defBoardMgtID"));
      model.put("templName", templName);

      model.put("boardGrpList", boardGrpList);
      model.put("boardMgtList", boardMgtList);
      model.put("boardLstCnt", StringUtil.checkNull(Integer.valueOf(boardMgtList.size()), "0"));
      model.put("boardGrpCnt", Integer.valueOf(boardGrpList.size()));
      int j = 2;
      int loadingBoard = 2;
      for (int i = 0; i < boardMgtList.size(); i++) {
        Map board = (HashMap)boardMgtList.get(i);
        if (!boardMgtID.equals("")) {
          if (boardMgtID.equals(StringUtil.checkNull(board.get("BoardMgtID")))) {
            BoardMgtID = StringUtil.checkNull(board.get("BoardMgtID"));
            model.put("BoardMgtID", StringUtil.checkNull(board.get("BoardMgtID")));
            model.put("StatusCount", Integer.valueOf(i + 1));
            model.put("Url", StringUtil.checkNull(board.get("URL")));
            model.put("BoardTypeCD", StringUtil.checkNull(board.get("BoardTypeCD")));
            loadingBoard = j;
          }

        }
        else if (i == 0) {
          BoardMgtID = StringUtil.checkNull(board.get("BoardMgtID"));
          model.put("BoardMgtID", StringUtil.checkNull(board.get("BoardMgtID")));
          model.put("StatusCount", Integer.valueOf(i + 1));
          model.put("Url", StringUtil.checkNull(board.get("URL")));
          model.put("BoardTypeCD", StringUtil.checkNull(board.get("BoardTypeCD")));
          break;
        }

        j++;
      }

      int grpOpenClose = 1;
      String boardGrpID = "";
      if (!boardMgtID.equals("")) {
        boardGrpID = this.commonService.selectString("board_SQL.getBoardParentID", cmmMap);
      }
      if (!boardMgtID.equals("")) {
        for (int i = 0; i < boardGrpList.size(); i++) {
          Map boardGrpMap = (HashMap)boardGrpList.get(i);
          if (!boardGrpID.equals(StringUtil.checkNull(boardGrpMap.get("BoardGrpID"))))
            continue;
          grpOpenClose = i + 1;
        }

      }

      String menuIndex = "";
      String space = " ";
      String startBoardIndex = "1";

      int ttlCnt = boardMgtList.size() + boardGrpList.size();
      int cnt = 1;
      for (int i = 0; ttlCnt > i; i++) {
        menuIndex = menuIndex + space + cnt;
        cnt++;
      }

      model.put("menuIndex", menuIndex);
      model.put("startBoardIndex", startBoardIndex);
      model.put("grpOpenClose", Integer.valueOf(grpOpenClose));
      model.put("loadingBoard", Integer.valueOf(loadingBoard));
      model.addAttribute("title", "HOME");
      model.put("menu", getLabel(request, this.commonService));
      model.put("defBoardMgtID", defBoardMgtID);
    }
    catch (Exception e) {
      if (this._log.isInfoEnabled()) this._log.info("BoardController::boardAdminMgt::Error::" + e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl(url);
  }
  @RequestMapping({"/boardAdminList.do"})
  public String boardAdminList(HttpServletRequest request, ModelMap model) throws Exception { model.addAttribute("title", "HOME");
    try {
      String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"), "1");

      String page = StringUtil.checkNull(request.getParameter("page"), "1");
      Map mapValue = new HashMap();
      mapValue.put("BoardMgtID", BoardMgtID);
      int totCnt = NumberUtil.getIntValue(this.commonService.selectString("board_SQL.boardTotalCnt", mapValue));
      model.put("BoardMgtID", BoardMgtID);
      model.put("totalPage", Integer.valueOf(totCnt));
      model.put("page", page);
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }

    return nextUrl("/adm/configuration/board/boardAdminList"); }

  @RequestMapping({"/boardAdminDetail.do"})
  public String boardAdminDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    try {
      String path = GlobalVal.FILE_UPLOAD_BOARD_DIR + cmmMap.get("sessionUserId");
      if (!path.equals("")) FileUtil.deleteDirectory(path);

      String BoardMgtID = StringUtil.checkNull(cmmMap.get("BoardMgtID"), "1");

      String currPage = StringUtil.checkNull(cmmMap.get("currPage"), "1");
      if ("N".equals(cmmMap.get("NEW"))) {
        Map result = this.commonService.select("board_SQL.boardDetail", cmmMap);
        model.put("itemFiles", this.commonService.selectList("boardFile_SQL.boardFile_selectList", result));
        model.addAttribute("resultMap", result);
      } else {
        Map result = new HashMap();
        result.put("BoardMgtID", BoardMgtID);
        result.put("BoardID", "");
        result.put("Subject", "");
        result.put("Content", "");
        result.put("WriteUserID", "");
        result.put("ReplyLev", "");
        result.put("ReadCNT", "");
        result.put("WriteUserNm", "");
        result.put("RegDT", "");
        result.put("RegUserID", "");
        result.put("ModDT", "");
        result.put("ModUserID", "");

        model.addAttribute("resultMap", result);
      }
      model.put("BoardMgtID", BoardMgtID);
      model.put("currPage", currPage);
      model.put("NEW", cmmMap.get("NEW"));
      model.put("menu", getLabel(request, this.commonService));
    } catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("/adm/configuration/board/boardAdminDetail");
  }

  @RequestMapping({"/saveBoard.do"})
  public String saveBoard(MultipartHttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception
  {
    Map target = new HashMap();
    XSSRequestWrapper xss = new XSSRequestWrapper(request);

    for (Iterator i = cmmMap.entrySet().iterator(); i.hasNext(); ) {
      Map.Entry e = (Map.Entry)i.next();

      if ((!e.getKey().equals("loginInfo")) && (e.getValue() != null)) {
        System.out.println(xss.stripXSS2(e.getValue().toString()));
        System.out.println(e.getValue().toString().replaceAll("<", "&lt;").replaceAll(">", "&gt;"));
        cmmMap.put(e.getKey(), xss.stripXSS2(e.getValue().toString()).replaceAll("<", "&lt;").replaceAll(">", "&gt;"));
      }
    }

    List fileList = new ArrayList();
    String BoardMgtID = StringUtil.checkNull(cmmMap.get("BoardMgtID"), "");
    String BoardID = StringUtil.checkNull(cmmMap.get("BoardID"), "");
    String projectID = StringUtil.checkNull(cmmMap.get("project"));
    String screenType = StringUtil.checkNull(cmmMap.get("screenType"));
    String boardUrl = StringUtil.checkNull(cmmMap.get("boardUrl"));
    String pageNum = StringUtil.checkNull(cmmMap.get("pageNum"));
    String category = StringUtil.checkNull(cmmMap.get("category"));
    String categoryIndex = StringUtil.checkNull(cmmMap.get("categoryIndex"));
    String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"), "");
    String RegUserID = StringUtil.checkNull(cmmMap.get("RegUserID"), "");
    try
    {
      model.put("BoardMgtID", BoardMgtID);
      model.put("s_itemID", projectID);
      model.put("screenType", screenType);
      model.put("url", boardUrl);
      model.put("pageNum", pageNum);

      cmmMap.put("Subject", StringUtil.checkNull(cmmMap.get("Subject"), ""));
      cmmMap.put("Content", StringUtil.checkNull(cmmMap.get("Content"), ""));
      cmmMap.put("projectID", projectID);
      Map setMap = new HashMap();

      setMap.put("boardID", BoardID);
      String regUserID = StringUtil.checkNull(this.commonService.selectString("forum_SQL.getForumRegID", setMap));

      HashMap drmInfoMap = new HashMap();
      String userID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
      String userName = StringUtil.checkNull(cmmMap.get("sessionUserNm"));
      String teamID = StringUtil.checkNull(cmmMap.get("sessionTeamId"));
      String teamName = StringUtil.checkNull(cmmMap.get("sessionTeamName"));
      drmInfoMap.put("userID", userID);
      drmInfoMap.put("userName", userName);
      drmInfoMap.put("teamID", teamID);
      drmInfoMap.put("teamName", teamName);
      drmInfoMap.put("loginID", cmmMap.get("sessionLoginId"));
      drmInfoMap.put("sessionEmail", cmmMap.get("sessionEmail"));
      String str1;
      if ("".equals(BoardID))
      {
        BoardID = this.commonService.selectString("board_SQL.boardNextVal", cmmMap);
        cmmMap.put("GUBUN", "insert");
        cmmMap.put("BoardID", BoardID);

        String savePath = "";
        String fileName = "";
        int Seq = Integer.parseInt(this.commonService.selectString("boardFile_SQL.boardFile_nextVal", cmmMap));
        int seqCnt = 0;

        String orginPath = GlobalVal.FILE_UPLOAD_BOARD_DIR + StringUtil.checkNull(cmmMap.get("sessionUserId")) + "//";
        String targetPath = GlobalVal.FILE_UPLOAD_BOARD_DIR;
        List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);

        if (tmpFileList != null) {
          for (int i = 0; i < tmpFileList.size(); i++) {
            Map fileMap = new HashMap();
            HashMap resultMap = (HashMap)tmpFileList.get(i);
            fileMap.put("BoardMgtID", BoardMgtID);
            fileMap.put("BoardID", BoardID);
            fileMap.put("Seq", Integer.valueOf(Seq + seqCnt));
            fileMap.put("FileNm", resultMap.get("FileNm"));
            fileMap.put("FileRealNm", resultMap.get("SysFileNm"));
            fileMap.put("FileSize", resultMap.get("FileSize"));
            fileMap.put("FilePath", resultMap.get("FilePath"));
            fileMap.put("projectID", projectID);
            fileList.add(fileMap);
            seqCnt++;

            String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
            if ((!"".equals(useDRM))) {
              drmInfoMap.put("ORGFileDir", orginPath);
              drmInfoMap.put("DRMFileDir", targetPath);
              drmInfoMap.put("Filename", resultMap.get("SysFileNm"));
              drmInfoMap.put("FileRealName", resultMap.get("FileNm"));
              drmInfoMap.put("funcType", "upload");
              str1 = DRMUtil.drmMgt(drmInfoMap);
            }
          }
        }

        this.boardService.save(fileList, cmmMap);
      }
      else if (regUserID.equals(RegUserID))
      {
        cmmMap.put("GUBUN", "update");

        String savePath = "";
        String fileName = "";
        int Seq = Integer.parseInt(this.commonService.selectString("boardFile_SQL.boardFile_nextVal", cmmMap));
        int seqCnt = 0;

        String orginPath = GlobalVal.FILE_UPLOAD_BOARD_DIR + StringUtil.checkNull(cmmMap.get("sessionUserId")) + "//";
        String targetPath = GlobalVal.FILE_UPLOAD_BOARD_DIR;
        List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
        if (tmpFileList != null) {
          for (int i = 0; i < tmpFileList.size(); i++) {
            Map fileMap = new HashMap();
            HashMap resultMap = (HashMap)tmpFileList.get(i);
            fileMap.put("BoardMgtID", BoardMgtID);
            fileMap.put("BoardID", BoardID);
            fileMap.put("Seq", Integer.valueOf(Seq + seqCnt));
            fileMap.put("FileNm", resultMap.get("FileNm"));
            fileMap.put("FileRealNm", resultMap.get("SysFileNm"));
            fileMap.put("FileSize", resultMap.get("FileSize"));
            fileMap.put("FilePath", resultMap.get("FilePath"));
            fileMap.put("projectID", projectID);
            fileList.add(fileMap);
            seqCnt++;

            String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
            if ((!"".equals(useDRM))) {
              drmInfoMap.put("ORGFileDir", orginPath);
              drmInfoMap.put("DRMFileDir", targetPath);
              drmInfoMap.put("Filename", resultMap.get("SysFileNm"));
              drmInfoMap.put("FileRealName", resultMap.get("FileNm"));
              drmInfoMap.put("funcType", "upload");
              str1 = DRMUtil.drmMgt(drmInfoMap);
            }
          }
        }

        this.boardService.save(fileList, cmmMap);

        String path = GlobalVal.FILE_UPLOAD_BOARD_DIR + cmmMap.get("sessionUserId");
        if (!path.equals("")) FileUtil.deleteDirectory(path);
      }

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
      target.put("SCRIPT", "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID") + "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove();");
    }
    catch (Exception e)
    {
      System.out.println(e.toString());
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");
      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);
    model.put("BoardMgtID", BoardMgtID);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/deleteBoard.do"})
  public String deleteBoard(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    Map target = new HashMap();
    List fileList = new ArrayList();
    String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"), "1");
    String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
    String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");
    String boardUrl = StringUtil.checkNull(request.getParameter("boardUrl"), "");
    String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "");
    model.put("BoardMgtID", BoardMgtID);
    model.put("projectID", projectID);
    model.put("screenType", screenType);
    model.put("url", boardUrl);
    model.put("pageNum", pageNum);
    try
    {
      Map setMap = new HashMap();

      String BoardID = StringUtil.checkNull(request.getParameter("BoardID"));
      String RegUserID = StringUtil.checkNull(request.getParameter("RegUserID"));
      setMap.put("boardID", BoardID);
      String regUserID = StringUtil.checkNull(this.commonService.selectString("forum_SQL.getForumRegID", setMap));
      if (RegUserID.equals(regUserID)) {
        cmmMap.put("GUBUN", "delete");
        this.boardService.save(fileList, cmmMap);

        target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069"));

        target.put("SCRIPT", "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID") + "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove()");
      }
    }
    catch (Exception e) {
      if (this._log.isInfoEnabled()) this._log.info("BoardController::deleteBoard::Error::" + e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00070"));
    }
    model.addAttribute("resultMap", target);
    model.put("BoardMgtID", BoardMgtID);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }
  @RequestMapping({"/saveBoardLike.do"})
  public String saveBoardLike(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception { Map setMap = new HashMap();
    Map target = new HashMap();

    String BoardMgtID = StringUtil.checkNull(cmmMap.get("BoardMgtID"), "");
    String BoardID = StringUtil.checkNull(cmmMap.get("BoardID"), "");
    String LikeInfo = StringUtil.checkNull(cmmMap.get("likeInfo"), "N");
    String screenType = StringUtil.checkNull(cmmMap.get("screenType"));

    setMap.put("BoardMgtID", BoardMgtID);

    if (BoardID.equals("")) {
      BoardID = StringUtil.checkNull(cmmMap.get("boardID"), "");
    }

    setMap.put("BoardID", BoardID);
    setMap.put("sessionUserId", cmmMap.get("sessionUserId"));
    try
    {
      if (LikeInfo.equals("Y")) {
        this.commonService.delete("board_SQL.boardLikeDelete", setMap);
      }
      else {
        this.commonService.insert("board_SQL.boardLikeInsert", setMap);
      }

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
      if (BoardMgtID.equals("4")) {
        target.put("SCRIPT", "parent.fnCallBack(" + BoardID + ");");
      }
      else
        target.put("SCRIPT", "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID") + "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove();");
    }
    catch (Exception e)
    {
      if (this._log.isInfoEnabled()) this._log.info("BoardController::saveLikeBoard::Error::" + e);
      target.put("SCRIPT", "parent.$('#isSubmit').remove()");

      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage"); }

  @RequestMapping({"/saveBoardFile.do"})
  public String saveBoardFile(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    Map target = new HashMap();
    try {
      Map fileMap = new HashMap();
      fileMap.put("BoardMgtID", StringUtil.checkNull(cmmMap.get("mgtId")));
      fileMap.put("BoardID", StringUtil.checkNull(cmmMap.get("id")));
      fileMap.put("Seq", "0");
      fileMap.put("FileNm", StringUtil.checkNull(cmmMap.get("FileNm")));
      fileMap.put("FileRealNm", StringUtil.checkNull(cmmMap.get("FileRealNm")));
      fileMap.put("FileSize", StringUtil.checkNull(cmmMap.get("FileSize"), "0"));
      fileMap.put("FilePath", GlobalVal.FILE_UPLOAD_BOARD_DIR);

      this.commonService.insert("boardFile_SQL.boardFile_insert", fileMap);
    }
    catch (Exception e)
    {
      if (this._log.isInfoEnabled()) this._log.info("BoardController::saveBoardFile::Error::" + e);
      target.put("ALERT", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
    }
    model.addAttribute("resultMap", target);

    return nextUrl("/cmm/ajaxResult/ajaxPage");
  }

  private String setXML() {
    String result = "";

    result = "<rows><row id='11111' open='1' style='font-weight:bold'>\t<cell><![CDATA[<img src='/dev_xbolt/cmm/base/images/icon_attach.png'/>text afetr the image]]>Total</cell>\t<cell>11111</cell>\t<cell>22222</cell>\t<cell>33333</cell> </row><row id='2' >\t<cell image='icon_attach.png'>Music</cell>\t<cell>00000</cell>\t<cell>22222</cell>\t<cell>22222</cell> </row>\t<row id='3'>\t\t<cell image='/dev_xbolt/cmm/base/images/icon_attach.png'>Whatever People Say I Am, That's What I Am Not</cell>\t\t<cell>9.78</cell>\t\t<cell>1</cell>\t\t<cell>222222</cell>\t</row>\t<row id='4'>\t\t<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>\t\t<cell>9.78</cell>\t\t<cell>1</cell>\t\t<cell>222222</cell>\t</row>\t<row id='5'>\t\t<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>\t\t<cell>9.78</cell>\t\t<cell>1</cell>\t\t<cell>222222</cell>\t</row>\t<row id='3'>\t\t<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>\t\t<cell>9.78</cell>\t\t<cell>1</cell>\t\t<cell>222222</cell>\t</row>\t<row id='6'>\t\t<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>\t\t<cell>9.78</cell>\t\t<cell>1</cell>\t\t<cell>222222</cell>\t</row>\t<row id='7'>\t\t<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>\t\t<cell>9.78</cell>\t\t<cell>1</cell>\t\t<cell>222222</cell>\t</row>\t<row id='3'>\t\t<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>\t\t<cell>9.78</cell>\t\t<cell>1</cell>\t\t<cell>222222</cell>\t</row>\t<row id='8'>\t\t<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>\t\t<cell>9.78</cell>\t\t<cell>1</cell>\t\t<cell>222222</cell>\t</row>\t<row id='9'>\t\t<cell image='cd.gif'>Whatever People Say I Am, That's What I Am Not</cell>\t\t<cell>9.78</cell>\t\t<cell>1</cell>\t\t<cell>222222</cell>\t</row></rows>";

    return result;
  }
  @RequestMapping({"/mainBoardList.do"})
  public String mainBoardList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"));
    String mainVersion = StringUtil.checkNull(request.getParameter("mainVersion"));
    String replyLev = StringUtil.checkNull(request.getParameter("replyLev"), "0");
    String projectId = StringUtil.checkNull(request.getParameter("projectId"));
    String listSize = StringUtil.checkNull(request.getParameter("listSize"), "5");
    String boardMgtType = StringUtil.checkNull(cmmMap.get("boardMgtType"));
    String templProjectID = StringUtil.checkNull(this.commonService.selectString("board_SQL.getTemplProjectID", cmmMap), "");
    Map setMap = new HashMap();
    setMap.put("s_itemID", templProjectID);
    String templProjectType = StringUtil.checkNull(this.commonService.selectString("project_SQL.getProjectType", setMap), "");

    String url = "/hom/main/board/mainBoardList";
    try {
      if ("2".equals(mainVersion)) {
        url = "/hom/main/board/mainBoardList_v2";
      }
      if ("3".equals(mainVersion)) {
        url = "/hom/main/board/mainBoardList_v3";
      }
      if ("4".equals(mainVersion)) {
        url = "/hom/main/board/mainBoardList_v4";
      }
      if ("5".equals(mainVersion)) {
        url = "/hom/main/board/mainBoardList_v5";
      }

      Map setData = new HashMap();
      String parentID = "";
      String boardGrpID = "";
      if (boardMgtType.equals("Y")) {
        boardGrpID = BoardMgtID;
        BoardMgtID = "";
        cmmMap.put("boardGrpID", boardGrpID);
      }
      cmmMap.put("BoardMgtID", BoardMgtID);
      cmmMap.put("viewType", "home");
      cmmMap.put("replyLev", replyLev);

      cmmMap.put("projectID", templProjectID);
      cmmMap.put("projectType", templProjectType);

      List brdList = this.commonService.selectList("board_SQL.boardList_gridList", cmmMap);
      String isView = "0"; if ((brdList != null) && (brdList.size() > 0)) isView = "1";
      model.put("brdList", brdList);
      model.put("isView", isView);
      model.put("boardMgtID", BoardMgtID);
      model.put("listSize", listSize);
      model.put("menu", getLabel(request, this.commonService));
    } catch (Exception e) {
      System.out.println(e); throw new ExceptionUtil(e.toString());
    }return nextUrl(url);
  }
  @RequestMapping({"/mainBoardQnAList.do"})
  public String mainBoardQnAList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"));
    String mainVersion = StringUtil.checkNull(request.getParameter("mainVersion"));
    String replyLev = StringUtil.checkNull(request.getParameter("replyLev"), "0");
    String projectId = StringUtil.checkNull(request.getParameter("projectId"));
    String listSize = StringUtil.checkNull(request.getParameter("listSize"), "5");
    String boardMgtType = StringUtil.checkNull(cmmMap.get("boardMgtType"));
    String templProjectID = StringUtil.checkNull(this.commonService.selectString("board_SQL.getTemplProjectID", cmmMap), "");
    Map setMap = new HashMap();
    setMap.put("s_itemID", templProjectID);
    String templProjectType = StringUtil.checkNull(this.commonService.selectString("project_SQL.getProjectType", setMap), "");

    String url = "/hom/main/board/mainBoardQnAList";
    try {
      Map setData = new HashMap();
      String parentID = "";
      String boardGrpID = "";
      if (boardMgtType.equals("Y")) {
        boardGrpID = BoardMgtID;
        BoardMgtID = "";
        cmmMap.put("boardGrpID", boardGrpID);
      }
      cmmMap.put("BoardMgtID", BoardMgtID);
      cmmMap.put("viewType", "home");
      cmmMap.put("replyLev", replyLev);

      cmmMap.put("projectID", templProjectID);
      cmmMap.put("projectType", templProjectType);

      List brdList = this.commonService.selectList("forum_SQL.forumGridList_gridList", cmmMap);
      String isView = "0"; if ((brdList != null) && (brdList.size() > 0)) isView = "1";
      model.put("brdList", brdList);
      model.put("isView", isView);
      model.put("boardMgtID", BoardMgtID);
      model.put("listSize", listSize);
      model.put("menu", getLabel(request, this.commonService));
    } catch (Exception e) {
      System.out.println(e); throw new ExceptionUtil(e.toString());
    }return nextUrl(url);
  }
  @RequestMapping({"/boardAlarmPop.do"})
  public String boardAlarmPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    String url = "/board/brd/boardAlarmPop";
    try {
      Map setMap = new HashMap();
      setMap.put("viewType", "pop");

      Map setMap2 = new HashMap();
      setMap2.put("sessionCurrLangType", request.getParameter("languageID"));
      setMap2.put("TemplCode", request.getParameter("templCode"));

      Map templMap = this.commonService.select("main_SQL.getPjtInfoFromTEMPL", setMap2);
      String templPjtID = StringUtil.checkNull(templMap.get("ProjectID"), "");

      if (!"0".equals(templPjtID)) {
        setMap.put("templPjtID", templPjtID);
      }
      Map result = this.commonService.select("board_SQL.boardDetail", setMap);
      String content = StringUtil.checkNull(result.get("Content"));
      content = content.replaceAll("&gt;", ">");
      content = content.replaceAll("&lt;", "<");
      content = content.replaceAll("&quot;", "\"");
      content = StringEscapeUtils.unescapeHtml4(content);
      result.put("Content", content);
      model.put("itemFiles", this.commonService.selectList("boardFile_SQL.boardFile_selectList", result));
      model.put("resultMap", result);
      model.put("menu", getLabel(request, this.commonService));
    }
    catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("/board/brd/boardAlarmPop");
  }
  @RequestMapping({"/boardDetailPop.do"})
  public String boardDetailPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
    String noticType = StringUtil.checkNull(
      request.getParameter("noticType"), "1");
    try
    {
      this.commonService.update("board_SQL.boardUpdateReadCnt", cmmMap);
      Map result = this.commonService.select("board_SQL.boardDetail", cmmMap);
      String boardMgtNM = this.commonService.selectString("board_SQL.getBoardMgtName", cmmMap);
      if ("4".equals(noticType)) {
        Map boardMap = new HashMap();
        Map setMap = new HashMap();

        setMap.put("boardID", cmmMap.get("BoardID"));
        setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
        setMap.put("sessionUserId", cmmMap.get("sessionUserId"));
        boardMap = this.commonService.select("forum_SQL.getForumEditInfo", setMap);

        if ((boardMap != null) && (!boardMap.isEmpty())) {
          result.put("ItemID", boardMap.get("ItemID"));
          result.put("Path", boardMap.get("Path"));
        }
      }
      String content = StringUtil.checkNull(result.get("Content"));
      content = content.replaceAll("&gt;", ">");
      content = content.replaceAll("&lt;", "<");
      content = content.replaceAll("&quot;", "\"");
      content = StringEscapeUtils.unescapeHtml4(content);
      result.put("Content", content);

      model.put("itemFiles", this.commonService.selectList("boardFile_SQL.boardFile_selectList", result));
      model.put("resultMap", result);
      model.put("noticType", noticType);
      model.put("boardMgtNM", boardMgtNM);
      model.put("menu", getLabel(request, this.commonService));
    } catch (Exception e) {
      System.out.println(e);
      throw new ExceptionUtil(e.toString());
    }
    return nextUrl("/popup/boardDetailPop");
  }
}