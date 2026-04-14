//package xbolt.board.mbrd.web;
//
//import java.time.LocalDateTime;
//import java.time.format.DateTimeFormatter;
//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.Iterator;
//import java.util.List;
//import java.util.Map;
//import java.util.Map.Entry;
//
//import javax.annotation.Resource;
//import javax.servlet.http.HttpServletRequest;
//
//import org.apache.commons.logging.Log;
//import org.apache.commons.logging.LogFactory;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Qualifier;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.ModelMap;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.multipart.MultipartHttpServletRequest;
//
//import com.org.json.JSONArray;
//
//import xbolt.cmm.controller.XboltController;
//import xbolt.cmm.framework.filter.XSSRequestWrapper;
//import xbolt.cmm.framework.handler.MessageHandler;
//import xbolt.cmm.framework.util.ExceptionUtil;
//import xbolt.cmm.framework.util.FileUtil;
//import xbolt.cmm.framework.util.NumberUtil;
//import xbolt.cmm.framework.util.StringUtil;
//import xbolt.cmm.framework.val.GlobalVal;
//import xbolt.cmm.service.CommonService;
//
//
//@Controller
//@SuppressWarnings("unchecked")
//public class MboardController extends XboltController {
//	private final Log _log = LogFactory.getLog(this.getClass());
//
//	@Autowired
//    @Qualifier("commonService")
//    private CommonService commonService;
//
//	@Resource(name = "boardService")
//	private CommonService boardService;
//	
//	//////////////////////////////////////////////////////////////////////////
//	//==BOARD
//	@RequestMapping(value="/mboardList.do")
//	public String mboardList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
//		String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"), request.getParameter("boardMgtID"));
//		String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "1");
//		String boardTypeCD = StringUtil.checkNull(request.getParameter("boardTypeCD"), "");
//		String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");
//		String projectID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
//		String defBoardMgtID = StringUtil.checkNull(cmmMap.get("defBoardMgtID"));
//		String category = StringUtil.checkNull(cmmMap.get("category"));
//		String categoryIndex = StringUtil.checkNull(cmmMap.get("categoryIndex"));
//		String categoryCnt = StringUtil.checkNull(cmmMap.get("categoryCnt"));
//		String scStartDt = StringUtil.checkNull(cmmMap.get("scStartDt"));
//		String searchKey = StringUtil.checkNull(cmmMap.get("searchKey"));
//		String searchValue = StringUtil.checkNull(cmmMap.get("searchValue"));
//		String scEndDt = StringUtil.checkNull(cmmMap.get("scEndDt"));
//		String templProjectID = StringUtil.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap),"");
//		String projectType = "";
//		String icon = "icon_folder_upload_title.png";
//		String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
//		
//		Map setMap2 = new HashMap();
//		setMap2.put("MenuID", boardTypeCD);
//		String boardUrl = StringUtil.checkNull(commonService.selectString("menu_SQL.getMenuVarfilter", setMap2),"");
//		int idx = boardUrl.indexOf("=");
//		boardUrl = boardUrl.substring(idx+1);
//		String url = boardUrl ;
//		if(boardUrl.equals("")){url = "/board/mbrd/mboardList";}
//		
//		if(BoardMgtID != null && BoardMgtID.equals("4")){
//			icon = "comment_user.png";
//		};	
//			
//		try {
//			Map setMap = new HashMap();
//			if(templProjectID != null && !"".equals(templProjectID)) {
//				setMap.put("s_itemID",templProjectID);
//				projectType = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectType", setMap),"");
//				projectID = templProjectID;
//			}
//			setMap.put("BoardMgtID", BoardMgtID);			
//			int totCnt = NumberUtil.getIntValue(commonService.selectString("board_SQL.boardTotalCnt", setMap));
//		
//			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
//			String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName",setMap);	
//			String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);
//			model.put("boardMgtName", boardMgtName);
//			model.put("CategoryYN", categoryYN);			
//			
//			String likeYN = commonService.selectString("board_SQL.getBoardLikeYN", setMap);
//			model.put("LikeYN", likeYN);
//		
//			if(screenType.equals("mainV4")){
//				model.put("myID", cmmMap.get("sessionUserId"));
//				model.put("boardMgtName", "Communication");
//			}
//			
//			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
//			//setMap.put("category", "BRDCAT");
//			List brdCatList = commonService.selectList("common_SQL.getBoardMgtCategory_commonSelect", setMap);
//			Map mgtInfoMap = commonService.select("board_SQL.getBoardMgtInfo", setMap);
//			
//			if("N".equals(mgtInfoMap.get("MgtOnlyYN")) && Integer.parseInt(mgtInfoMap.get("MgtGRID").toString()) > 0) {
//				Map tmpMap = new HashMap();
//				
//				tmpMap.put("checkID", cmmMap.get("sessionUserId"));
//				tmpMap.put("groupID", mgtInfoMap.get("MgtGRID"));
//				String check = StringUtil.checkNull(commonService.selectString("user_SQL.getEndGRUser", tmpMap),"");
//				
//				if(!"".equals(check)) {
//					mgtInfoMap.put("MgtGRID2", mgtInfoMap.get("MgtGRID"));
//				}
//				else {
//					mgtInfoMap.put("MgtGRID2", "");
//				}
//			}
//			
//			//gridData
//			cmmMap.put("languageID", languageID);
//			cmmMap.put("BoardMgtID", request.getParameter("BoardMgtID"));
//			System.out.println("!!!!"+cmmMap);
//			List mboardList = commonService.selectList("board_SQL.boardList_gridList", cmmMap);
// 	 		JSONArray gridData = new JSONArray(mboardList);
// 	 		model.put("gridData",gridData);
// 	 		
//
//			model.put("scStartDt", scStartDt);
//			model.put("searchKey", searchKey);
//			model.put("searchValue", searchValue);
//			model.put("scEndDt", scEndDt);
//			model.put("templProjectID", templProjectID);
//			model.put("projectType", projectType);
//			model.put("mgtInfoMap", mgtInfoMap);
//			model.put("brdCatList", brdCatList);
//			model.put("brdCatListCnt", brdCatList.size());
//			model.put("totalPage", totCnt);
//			model.put("pageNum", pageNum);
//			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
//			model.put("icon",icon);
//			model.put("BoardMgtID", BoardMgtID);
//			model.put("screenType", screenType);
//			model.put("projectID", projectID);
//			model.put("boardUrl", boardUrl);
//			model.put("defBoardMgtID", defBoardMgtID);
//			model.put("category", category);
//			model.put("categoryIndex", categoryIndex);
//			model.put("categoryCnt", categoryCnt);
//			model.put("baseUrl", GlobalVal.BASE_ATCH_URL);
//		}
//		catch (Exception e) {
//			if(_log.isInfoEnabled()){_log.info("BoardController::boardList::Error::"+e.toString().replaceAll("\r|\n", ""));}
//			throw new ExceptionUtil(e.toString());
//		}
//		
//		return nextUrl(url);
//	}
//	
//	@RequestMapping(value="/mboardDetail.do")	
//	public String mboardDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
//		
//		String url = "/board/mbrd/mboardDetail";
//		
//		try{
//			//임시저장된 파일이 존재할 수 있으므로 삭제
//			String path=GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
//			String templProjectID = StringUtil.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap),"");
//			if(!path.equals("")){FileUtil.deleteDirectory(path);}	
//			
//			String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"), "1");
//			String currPage = StringUtil.checkNull(request.getParameter("currPage"), "1");	
//			String screenType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("screenType"), ""));	
//			String boardUrl = StringUtil.checkNull(request.getParameter("url"), "");	
//			String projectID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectID"), ""));
//			String category = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("category"), ""));
//			String categoryIndex = StringUtil.checkNull(request.getParameter("categoryIndex"), "");
//			String categoryCnt = StringUtil.checkNull(request.getParameter("categoryCnt"), "");
//
//			String scStartDt = StringUtil.checkNull(cmmMap.get("scStartDt"));
//			String searchKey = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchKey")));
//			String searchValue = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchValue")));
//			String scEndDt = StringUtil.checkNull(cmmMap.get("scEndDt"));
//			
//			String projectType = StringUtil.checkNull(request.getParameter("projectType"), "");
//			
//			Map setMap = new HashMap();
//			setMap.put("s_itemID",templProjectID);
//			String templProjectType = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectType", setMap),"");
//			
//			if(BoardMgtID != null){
//				setMap.put("BoardMgtID", BoardMgtID);
//				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
//				String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName",setMap);			
//				String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);	
//				model.put("boardMgtName", boardMgtName);
//				model.put("CategoryYN", categoryYN);
//			    
//			}
//			
//			//조회수UPDATE
//			commonService.update("board_SQL.boardUpdateReadCnt", cmmMap);
//			Map result = commonService.select("board_SQL.boardDetail", cmmMap);
//
//			String Content = StringUtil.checkNull(result.get("Content"),"");
//
//			Content = StringUtil.replaceFilterString(Content);
//			result.put("Content", Content);
//			model.put("result", result);
//
//			model.put("itemFiles", (List)commonService.selectList("boardFile_SQL.boardFile_selectList", cmmMap));
//
//			model.put(AJAX_RESULTMAP, result);
//
//			String LikeYN = commonService.selectString("board_SQL.getBoardLikeYN", setMap);
//			model.put("LikeYN", LikeYN);
//			String likeCNT = "";
//
//			if(LikeYN != null && "Y".equals(LikeYN)) {
//				setMap.put("BoardMgtID", result.get("BoardMgtID"));
//				setMap.put("BoardID", result.get("BoardID"));
//				likeCNT = commonService.selectString("board_SQL.getBoardLikeCNT",setMap);			
//				model.put("likeCNT", likeCNT);
//			}
//
//			model.put("scStartDt", scStartDt);
//			model.put("searchKey", searchKey);
//			model.put("searchValue", searchValue);
//			model.put("scEndDt", scEndDt);
//			model.put("templProjectID", templProjectID);
//			model.put("projectType", projectType);
//			model.put("BoardMgtID", BoardMgtID);
//			model.put("currPage", currPage);
//			model.put("NEW", StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("NEW"))));	
//			model.put("screenType", screenType);
//			model.put("url", boardUrl);
//			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
//			model.put("projectID", projectID);
//			model.put("defBoardMgtID", cmmMap.get("defBoardMgtID"));
//			model.put("category", category);
//			model.put("categoryIndex", categoryIndex);
//			model.put("categoryCnt", categoryCnt);
//			
//			if(screenType.equals("PG") || screenType.equals("PJT")){
//				if(!projectID.equals("")){
//					Map projectMap = new HashMap();
//					setMap.put("parentID", projectID);
//					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
//					projectMap = commonService.select("task_SQL.getProjectAuthorID",setMap);
//					model.put("projectMap", projectMap);
//				}
//			}
//		
//		}catch(Exception e){
//			if(_log.isInfoEnabled()){_log.info("BoardController::boardDetail::Error::"+e.toString().replaceAll("\r|\n", ""));}
//			throw new ExceptionUtil(e.toString());
//		}
//		return nextUrl(url);
//	}
//	
//	@RequestMapping(value="/mboardEdit.do")	
//	public String mboardEdit(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
//		
//		String url = "/board/mbrd/mboardEdit";
//		
//		try{
//			//임시저장된 파일이 존재할 수 있으므로 삭제
//			String path=GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
//			String templProjectID = StringUtil.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap),"");
//			if(!path.equals("")){FileUtil.deleteDirectory(path);}	
//			
//			String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"), "1");
//			String currPage = StringUtil.checkNull(request.getParameter("currPage"), "1");	
//			String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");	
//			String boardUrl = StringUtil.checkNull(request.getParameter("url"), "");	
//			String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
//			String category = StringUtil.checkNull(request.getParameter("category"), "");
//			String categoryIndex = StringUtil.checkNull(request.getParameter("categoryIndex"), "");
//			String categoryCnt = StringUtil.checkNull(request.getParameter("categoryCnt"), "");
//			
//			String scStartDt = StringUtil.checkNull(cmmMap.get("scStartDt"));
//			String searchKey = StringUtil.checkNull(cmmMap.get("searchKey"));
//			String searchValue = StringUtil.checkNull(cmmMap.get("searchValue"));
//			String scEndDt = StringUtil.checkNull(cmmMap.get("scEndDt"));
//			
//			String projectType = StringUtil.checkNull(request.getParameter("projectType"), "");
//			
//			Map setMap = new HashMap();
//			setMap.put("s_itemID",templProjectID);
//			String templProjectType = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectType", setMap),"");
//			
//			if(BoardMgtID != null){
//				setMap.put("BoardMgtID", BoardMgtID);
//				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
//				String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName",setMap);			
//				String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);	
//				model.put("boardMgtName", boardMgtName);
//				model.put("CategoryYN", categoryYN);
//			}
//			
//			if("N".equals(cmmMap.get("NEW"))){
//				//조회수UPDATE
//				commonService.update("board_SQL.boardUpdateReadCnt", cmmMap);
//				Map result = commonService.select("board_SQL.boardDetail", cmmMap);
//				
//				String Content = StringUtil.checkNull(result.get("Content"),"");
//
//				Content = StringUtil.replaceFilterString(Content);
//				result.put("Content", Content);
//				model.put("result", result);
//				
//				model.put("itemFiles", (List)commonService.selectList("boardFile_SQL.boardFile_selectList", cmmMap));
//
//				model.put(AJAX_RESULTMAP, result);
//					
//				String LikeYN = commonService.selectString("board_SQL.getBoardLikeYN", setMap);
//				model.put("LikeYN", LikeYN);
//				String likeCNT = "";
//				
//				if(LikeYN != null && "Y".equals(LikeYN)) {
//					setMap.put("BoardMgtID", result.get("BoardMgtID"));
//					setMap.put("BoardID", result.get("BoardID"));
//					likeCNT = commonService.selectString("board_SQL.getBoardLikeCNT",setMap);			
//					model.put("likeCNT", likeCNT);
//				}
//			    
//			}else{
//				Map result = new HashMap();
//
//				result.put("BoardMgtID", BoardMgtID);
//				result.put("boardID", "");
//				result.put("Subject", "");
//				result.put("Content", "");
//				result.put("WriteUserID", "");
//				result.put("PreBoardID", cmmMap.get("PreBoardID"));
//				result.put("ReplyLev", "");
//				result.put("ReadCNT", "");
//				result.put("WriteUserNm", "");
//				result.put("AttFileID", "");
//				result.put("RegDT", "");
//				result.put("RegUserID", "");
//				result.put("ModDT", "");
//				result.put("ModUserID", "");
//				result.put("Category","");
//				model.put(AJAX_RESULTMAP, result);
//			}
//
//			model.put("scStartDt", scStartDt);
//			model.put("searchKey", searchKey);
//			model.put("searchValue", searchValue);
//			model.put("scEndDt", scEndDt);
//			model.put("templProjectID", templProjectID);
//			model.put("projectType", projectType);
//			model.put("BoardMgtID", BoardMgtID);
//			model.put("currPage", currPage);
//			model.put("NEW", cmmMap.get("NEW"));	
//			model.put("screenType", screenType);
//			model.put("url", boardUrl);
//			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
//			model.put("projectID", projectID);
//			model.put("defBoardMgtID", cmmMap.get("defBoardMgtID"));
//			model.put("category", category);
//			model.put("categoryIndex", categoryIndex);
//			model.put("categoryCnt", categoryCnt);
//			
//			if(screenType.equals("PG") || screenType.equals("PJT")){
//				if(!projectID.equals("")){
//					Map projectMap = new HashMap();
//					setMap.put("parentID", projectID);
//					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
//					projectMap = commonService.select("task_SQL.getProjectAuthorID",setMap);
//					model.put("projectMap", projectMap);
//				}
//			}
//		
//		}catch(Exception e){
//			if(_log.isInfoEnabled()){_log.info("BoardController::boardDetail::Error::"+e.toString().replaceAll("\r|\n", ""));}
//			throw new ExceptionUtil(e.toString());
//		}
//		return nextUrl(url);
//	}
//	
//	//////////////////////////////////////////////////////////////////////////
//	//==SAVE/DELETE/UPDATE
//	@RequestMapping(value="/saveMboard.do")
//	public String saveMboard(MultipartHttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception {
//		Map target = new HashMap();		
//		XSSRequestWrapper xss = new XSSRequestWrapper(request);
//		
//		for (Iterator i = cmmMap.entrySet().iterator(); i.hasNext();) {
//		    Entry e = (Entry) i.next(); // not allowed
//
//		    if(!e.getKey().equals("loginInfo") && e.getValue() != null) {
//		    	cmmMap.put(e.getKey(), xss.stripXSS(e.getValue().toString()));
//		    }
//		}
//		String BoardMgtID = StringUtil.checkNull(cmmMap.get("BoardMgtID"), "");
//		String BoardID = StringUtil.checkNull(cmmMap.get("BoardID"), "");
//		String projectID = StringUtil.checkNull(cmmMap.get("project"));
//		String screenType = StringUtil.checkNull(cmmMap.get("screenType"));
//		String boardUrl = StringUtil.checkNull(cmmMap.get("boardUrl"));
//		String pageNum = StringUtil.checkNull(cmmMap.get("pageNum"));
//		String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"), "");
//		String RegUserID = StringUtil.checkNull(cmmMap.get("RegUserID"), "");
//			
//		try {
//			Map setData = new HashMap();
//			setData.put("userId", userId);
//			setData.put("BoardMgtID", BoardMgtID);
//			String chkLimit = chkLimit(setData);
//			
//			model.put("BoardMgtID", BoardMgtID);
//			model.put("s_itemID", projectID);
//			model.put("screenType", screenType);
//			model.put("url", boardUrl);
//			model.put("pageNum", pageNum);
//				
//			cmmMap.put("Subject", StringUtil.checkNull(cmmMap.get("Subject"), ""));
//			cmmMap.put("Content", StringUtil.checkNull(cmmMap.get("Content"), ""));
//			cmmMap.put("projectID", projectID);		
//			List fileList = new ArrayList();
//
//			//commandFileMap에 _ID 값이 없으면 신규 등록
//			if("".equals(BoardID) && "Y".equals(chkLimit)){
//				// 신규 등록 시 유저가 1분내에 5번 이상 글을 등록할 수 없다. 
//				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류발생
//				target.put(AJAX_SCRIPT, "parent.fnGoList();parent.$('#isSubmit').remove();");
//
//				model.addAttribute(AJAX_RESULTMAP, target);
//				model.put("BoardMgtID", BoardMgtID);
//		
//				return nextUrl(AJAXPAGE);
//			}
//			else if("".equals(BoardID)){
//				//신규 _ID 가져옴
//				BoardID = commonService.selectString("board_SQL.boardNextVal", cmmMap);
//				cmmMap.put("GUBUN", "insert");
//				cmmMap.put("BoardID", BoardID);
//				
//				int Seq = Integer.parseInt(commonService.selectString("boardFile_SQL.boardFile_nextVal", cmmMap));
//				int seqCnt = 0;
//				
//				//Read Server File
//				String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(cmmMap.get("sessionUserId"))+"//";
//				String targetPath = GlobalVal.FILE_MULTIMEDIA_DIR;
//				List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
//				if(tmpFileList != null){
//					for(int i=0; i<tmpFileList.size();i++){
//						Map fileMap=new HashMap(); 
//						HashMap resultMap=(HashMap)tmpFileList.get(i);
//						fileMap.put("BoardMgtID", BoardMgtID);
//						fileMap.put("BoardID", BoardID);
//						fileMap.put("Seq", Seq + seqCnt);
//						fileMap.put("FileNm", resultMap.get(FileUtil.ORIGIN_FILE_NM));
//						fileMap.put("FileRealNm", resultMap.get(FileUtil.UPLOAD_FILE_NM));
//						fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
//						fileMap.put("FilePath", resultMap.get(FileUtil.FILE_PATH));
//						fileMap.put("projectID", projectID);
//						fileList.add(fileMap);
//						seqCnt++;
//					}
//				}
//				
//			   boardService.save(fileList, cmmMap);
//			    
//			}
//			else{
//				if(!userId.equals(RegUserID)) {
//						
//					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 저장 성공
//					target.put(AJAX_SCRIPT, "parent.fnGoList();parent.$('#isSubmit').remove();");
//
//					model.addAttribute(AJAX_RESULTMAP, target);
//					model.put("BoardMgtID", BoardMgtID);
//			
//					return nextUrl(AJAXPAGE);
//				}
//				
//				cmmMap.put("GUBUN", "update");
//				
//				int Seq = Integer.parseInt(commonService.selectString("boardFile_SQL.boardFile_nextVal", cmmMap));
//				int seqCnt = 0;
//				//Read Server File
//				String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(cmmMap.get("sessionUserId"))+"//";
//				String targetPath = GlobalVal.FILE_MULTIMEDIA_DIR;
//				List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
//				if(tmpFileList != null){
//					for(int i=0; i<tmpFileList.size();i++){
//						Map fileMap=new HashMap(); 
//						HashMap resultMap=(HashMap)tmpFileList.get(i);
//						fileMap.put("BoardMgtID", BoardMgtID);
//						fileMap.put("BoardID", BoardID);
//						fileMap.put("Seq", Seq + seqCnt);
//						fileMap.put("FileNm", resultMap.get(FileUtil.ORIGIN_FILE_NM));
//						fileMap.put("FileRealNm", resultMap.get(FileUtil.UPLOAD_FILE_NM));
//						fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
//						fileMap.put("FilePath", resultMap.get(FileUtil.FILE_PATH));
//						fileMap.put("projectID", projectID);
//						fileList.add(fileMap);
//						seqCnt++;
//					}
//				}	
//			    boardService.save(fileList, cmmMap);
//			    String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
//				if(!path.equals("")){FileUtil.deleteDirectory(path);}
//			}
//			
//			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
//			target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','"+BoardMgtID+"','"+cmmMap.get("BoardMgtID")+"','"+cmmMap.get("BoardID")+"','"+screenType+"');parent.$('#isSubmit').remove();");
//			
//
//		}
//		catch (Exception e) {
//			System.out.println(e.toString());
//			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
//			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
//		}
//		model.addAttribute(AJAX_RESULTMAP, target);
//		model.put("BoardMgtID", BoardMgtID);
//
//		return nextUrl(AJAXPAGE);
//	}	
//	
//	@RequestMapping(value="/deleteMboard.do")
//	public String deleteMboard(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
//		Map target = new HashMap();
//		List fileList = new ArrayList();
//		String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"), "1");
//		String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
//		String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");
//		String boardUrl = StringUtil.checkNull(request.getParameter("boardUrl"), "");
//		String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "");
//		model.put("BoardMgtID", BoardMgtID);
//		model.put("projectID", projectID);
//		model.put("screenType", screenType);
//		model.put("url", boardUrl);
//		model.put("pageNum", pageNum);
//		
//		try {
//			cmmMap.put("GUBUN", "delete");
//			boardService.save(fileList, cmmMap);
//			//target.put(AJAX_ALERT, "삭제가 성공하였습니다.");
//			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
//			//target.put(AJAX_SCRIPT, "parent.doReturn('DEL','"+BoardMgtID+");parent.$('#isSubmit').remove()");
//			target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','"+BoardMgtID+"','"+cmmMap.get("BoardMgtID")+"','"+cmmMap.get("BoardID")+"','"+screenType+"');parent.$('#isSubmit').remove()");
//		}
//		catch (Exception e) {
//			if(_log.isInfoEnabled()){_log.info("BoardController::deleteBoard::Error::"+e.toString().replaceAll("\r|\n", ""));}
//			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
//			//target.put(AJAX_ALERT, "삭제중 오류가 발생하였습니다.");
//			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
//		}
//		model.addAttribute(AJAX_RESULTMAP, target);
//		model.put("BoardMgtID", BoardMgtID);
//		//return nextUrl("admin/boardAdmin/boardAdminMgt");
//		return nextUrl(AJAXPAGE);
//	}
//	
//	@RequestMapping(value="/editMboard.do")	
//	public String editMboard(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
//		
//		String url = "/board/mbrd/mboardEdit";
//		
//		try{
//			//임시저장된 파일이 존재할 수 있으므로 삭제
//			String path=GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
//			String templProjectID = StringUtil.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap),"");
//			if(!path.equals("")){FileUtil.deleteDirectory(path);}	
//			
//			String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"), "1");
//			String currPage = StringUtil.checkNull(request.getParameter("currPage"), "1");	
//			String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");	
//			String boardUrl = StringUtil.checkNull(request.getParameter("url"), "");	
//			String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
//			String category = StringUtil.checkNull(request.getParameter("category"), "");
//			String categoryIndex = StringUtil.checkNull(request.getParameter("categoryIndex"), "");
//			String categoryCnt = StringUtil.checkNull(request.getParameter("categoryCnt"), "");
//			
//			String scStartDt = StringUtil.checkNull(cmmMap.get("scStartDt"));
//			String searchKey = StringUtil.checkNull(cmmMap.get("searchKey"));
//			String searchValue = StringUtil.checkNull(cmmMap.get("searchValue"));
//			String scEndDt = StringUtil.checkNull(cmmMap.get("scEndDt"));
//			
//			String projectType = StringUtil.checkNull(request.getParameter("projectType"), "");
//			
//			Map setMap = new HashMap();
//			setMap.put("s_itemID",templProjectID);
//			String templProjectType = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectType", setMap),"");
//			
//			if(BoardMgtID != null){
//				setMap.put("BoardMgtID", BoardMgtID);
//				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
//				String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName",setMap);			
//				String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);	
//				model.put("boardMgtName", boardMgtName);
//				model.put("CategoryYN", categoryYN);
//			}
//			
//			if("N".equals(cmmMap.get("NEW"))){
//				//조회수UPDATE
//				commonService.update("board_SQL.boardUpdateReadCnt", cmmMap);
//				Map result = commonService.select("board_SQL.boardDetail", cmmMap);
//				
//				String Content = StringUtil.checkNull(result.get("Content"),"");
//
//				Content = StringUtil.replaceFilterString(Content);
//				result.put("Content", Content);
//				model.put("result", result);
//				
//				model.put("itemFiles", (List)commonService.selectList("boardFile_SQL.boardFile_selectList", cmmMap));
//
//				model.put(AJAX_RESULTMAP, result);
//					
//				String LikeYN = commonService.selectString("board_SQL.getBoardLikeYN", setMap);
//				model.put("LikeYN", LikeYN);
//				String likeCNT = "";
//				
//				if(LikeYN != null && "Y".equals(LikeYN)) {
//					setMap.put("BoardMgtID", result.get("BoardMgtID"));
//					setMap.put("BoardID", result.get("BoardID"));
//					likeCNT = commonService.selectString("board_SQL.getBoardLikeCNT",setMap);			
//					model.put("likeCNT", likeCNT);
//				}
//			    
//			}else{
//				Map result = new HashMap();
//
//				result.put("BoardMgtID", BoardMgtID);
//				result.put("boardID", "");
//				result.put("Subject", "");
//				result.put("Content", "");
//				result.put("WriteUserID", "");
//				result.put("PreBoardID", cmmMap.get("PreBoardID"));
//				result.put("ReplyLev", "");
//				result.put("ReadCNT", "");
//				result.put("WriteUserNm", "");
//				result.put("AttFileID", "");
//				result.put("RegDT", "");
//				result.put("RegUserID", "");
//				result.put("ModDT", "");
//				result.put("ModUserID", "");
//				result.put("Category","");
//				model.put(AJAX_RESULTMAP, result);
//			}
//			
//			
//			model.put("scStartDt", scStartDt);
//			model.put("searchKey", searchKey);
//			model.put("searchValue", searchValue);
//			model.put("scEndDt", scEndDt);
//			model.put("templProjectID", templProjectID);
//			model.put("projectType", projectType);
//			model.put("BoardMgtID", BoardMgtID);
//			model.put("currPage", currPage);
//			model.put("NEW", cmmMap.get("NEW"));	
//			model.put("screenType", screenType);
//			model.put("url", boardUrl);
//			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
//			model.put("projectID", projectID);
//			model.put("defBoardMgtID", cmmMap.get("defBoardMgtID"));
//			model.put("category", category);
//			model.put("categoryIndex", categoryIndex);
//			model.put("categoryCnt", categoryCnt);
//			
//			if(screenType.equals("PG") || screenType.equals("PJT")){
//				if(!projectID.equals("")){
//					Map projectMap = new HashMap();
//					setMap.put("parentID", projectID);
//					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
//					projectMap = commonService.select("task_SQL.getProjectAuthorID",setMap);
//					model.put("projectMap", projectMap);
//				}
//			}
//		
//		}catch(Exception e){
//			if(_log.isInfoEnabled()){_log.info("BoardController::boardDetail::Error::"+e.toString().replaceAll("\r|\n", ""));}
//			throw new ExceptionUtil(e.toString());
//		}
//		return nextUrl(url);
//	}
//	
//	@RequestMapping(value="/saveMboardLike.do")
//	public String saveBoardLike(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
//		Map setMap = new HashMap();
//		Map target = new HashMap();
//		
//		String BoardMgtID = StringUtil.checkNull(cmmMap.get("BoardMgtID"), "");
//		String BoardID = StringUtil.checkNull(cmmMap.get("BoardID"), "");
//		String LikeInfo = StringUtil.checkNull(cmmMap.get("likeInfo"),"N");
//		String screenType = StringUtil.checkNull(cmmMap.get("screenType"));
//		
//		setMap.put("BoardMgtID", BoardMgtID);
//		
//		if(BoardID.equals("")) {
//			BoardID = StringUtil.checkNull(cmmMap.get("boardID"), "");
//		}
//		
//		setMap.put("BoardID", BoardID);
//		setMap.put("sessionUserId", cmmMap.get("sessionUserId"));
//		
//		try {	
//			
//			if(LikeInfo.equals("Y")) {
//				commonService.delete("board_SQL.boardLikeDelete",setMap);
//			}
//			else {
//				commonService.insert("board_SQL.boardLikeInsert",setMap);
//			}
//			
//			//target.put(AJAX_ALERT, "저장이 성공하였습니다.");
//			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
//			if(BoardMgtID.equals("4")) {
//				target.put(AJAX_SCRIPT, "parent.fnCallBack("+BoardID+");");
//			}
//			else {
//				target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','"+BoardMgtID+"','"+cmmMap.get("BoardMgtID")+"','"+cmmMap.get("BoardID")+"','"+screenType+"');parent.$('#isSubmit').remove();");
//			}
//		}
//		catch (Exception e) {
//			if(_log.isInfoEnabled()){_log.info("BoardController::saveLikeBoard::Error::"+e.toString().replaceAll("\r|\n", ""));}
//			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
//			//target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
//			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
//		}
//		model.addAttribute(AJAX_RESULTMAP, target);
//		//return nextUrl("admin/boardAdmin/boardAdminMgt");
//		return nextUrl(AJAXPAGE);
//	}
//	
//	public String chkLimit(Map map) throws Exception{
//        
//		// 같은 user가 1분에 5회 이상 게시글 작성 시 반려처리
//		Map setData = new HashMap();
//		String result = "N";
//		
//		String userID = StringUtil.checkNull(map.get("userId"),"");
//		String boardMgtID = StringUtil.checkNull(map.get("BoardMgtID"),"");
//		
//		LocalDateTime now = LocalDateTime.now();
//        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
//        LocalDateTime pastTime = now.plusMinutes(-1);
//        String scStartDt = pastTime.format(formatter);
//        String scEndDt = now.format(formatter);
//        
//        setData.put("regUserID",userID);
//        setData.put("boardMgtID",boardMgtID);
//        setData.put("scStartDt",scStartDt);
//        setData.put("scEndDt",scEndDt);
//        
//        String cnt = commonService.selectString("board_SQL.getBoardLimitChkCNT", setData);
//        if(Integer.parseInt(cnt) >= 5){
//        	result = "Y";
//		}
//        
//        return result;
//        
//	}
//	
//}
