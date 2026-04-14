package xbolt.board.brd.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import xbolt.board.brd.dto.BoardRequestDTO;
import xbolt.board.brd.dto.ForumRequestDTO;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.file.util.FileUploadUtil;

@Controller
@SuppressWarnings("unchecked")
public class BoardAPIActionController extends XboltController {
    private final Log _log = LogFactory.getLog(this.getClass());

    @Resource(name = "commonService")
    private CommonService commonService;

	@Resource(name = "forumService")
	private CommonService forumService;

    @Autowired
	private FileUploadUtil fileUploadUtil;
	
    @RequestMapping(value = "/boardDetailData.do")
    public void boardDetailData(HttpServletRequest request, @ModelAttribute BoardRequestDTO boardRequestDTO, HttpServletResponse response) throws Exception {
        
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        JSONObject resultData = new JSONObject();
        boolean success = false;
        
        try {
            // DTO에 세션 정보 주입
            Map<String, Object> loginInfo = (Map<String, Object>) request.getSession().getAttribute("loginInfo");
            if (loginInfo != null) {
                boardRequestDTO.setSessionUserId(StringUtil.checkNull(loginInfo.get("sessionUserId")));
                boardRequestDTO.setSessionCurrLangType(StringUtil.checkNull(loginInfo.get("sessionCurrLangType")));
            }

            // 임시파일 삭제 및 기본 설정
            String path = GlobalVal.FILE_UPLOAD_BASE_DIR + boardRequestDTO.getSessionUserId();
            if (!StringUtil.checkNull(path).equals("")) { FileUtil.deleteDirectory(path); }

            // 서비스 레이어로 전달할 파라미터 맵 생성
            Map<String, Object> serviceParamMap = new HashMap<>();
            serviceParamMap.put("BoardMgtID", boardRequestDTO.getBoardMgtID());
            serviceParamMap.put("BoardID", boardRequestDTO.getBoardID());
            serviceParamMap.put("languageID", boardRequestDTO.getSessionCurrLangType());

            // 게시판 정보 및 카테고리 여부
            String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName", serviceParamMap);
            String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", serviceParamMap);

            Map boardDetail = null;
            List itemFiles = new ArrayList();
            String likeCNT = "";
            String LikeYN = commonService.selectString("board_SQL.getBoardLikeYN", serviceParamMap);

            if (boardRequestDTO.getBoardID() != null && !boardRequestDTO.getBoardID().isEmpty()) {
                // 조회수 업데이트 및 상세 데이터 조회
                commonService.update("board_SQL.boardUpdateReadCnt", serviceParamMap);
                boardDetail = commonService.select("board_SQL.boardDetail", serviceParamMap);

                if (boardDetail != null) {
                    boardDetail.put("Subject", StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(boardDetail.get("Subject"))));
                    boardDetail.put("Content", StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(boardDetail.get("Content"))));
                }

                // 첨부파일 리스트
                itemFiles = (List) commonService.selectList("boardFile_SQL.boardFile_selectList", serviceParamMap);

                // 좋아요 정보
                if ("Y".equals(LikeYN) && boardDetail != null) {
                    serviceParamMap.put("BoardID", boardDetail.get("BoardID"));
                    likeCNT = commonService.selectString("board_SQL.getBoardLikeCNT", serviceParamMap);
                }
            }

            /*
            HttpSession session = request.getSession(true);
            String uploadToken = fileUploadUtil.makeFileUploadFolderToken(session);
            resultData.put("uploadToken", uploadToken);
			*/

            resultData.put("boardMgtName", boardMgtName);
            resultData.put("CategoryYN", categoryYN);
            if (boardDetail != null) { resultData.put("resultMap", boardDetail); }
            resultData.put("itemFiles", itemFiles);
            resultData.put("LikeYN", LikeYN);
            resultData.put("likeCNT", likeCNT);             

            success = true;
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            _log.error(e);
        } catch (DataAccessException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            _log.error(e);
        } catch (JSONException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            _log.error(e);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            _log.error(e);
        } finally {
            resultData.put("success", success);
            try {
                response.getWriter().print(resultData);
            } catch (Exception e) {
                _log.error(e.getMessage());
            }
        }
    }
    
    @RequestMapping(value = "/viewForumPostData.do")
    public void viewForumPostData(HttpServletRequest request, @ModelAttribute ForumRequestDTO forumRequestDTO, HttpServletResponse response) throws Exception {
        
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        JSONObject resultData = new JSONObject();
        boolean success = false;
        
        try {
            // DTO에 세션 정보 주입
            Map<String, Object> loginInfo = (Map<String, Object>) request.getSession().getAttribute("loginInfo");
            if (loginInfo != null) {
                forumRequestDTO.setSessionUserId(StringUtil.checkNull(loginInfo.get("sessionUserId")));
                forumRequestDTO.setSessionCurrLangType(StringUtil.checkNull(loginInfo.get("sessionCurrLangType")));
                if (StringUtil.checkNull(forumRequestDTO.getUserID()).isEmpty()) {
                    forumRequestDTO.setUserID(StringUtil.checkNull(loginInfo.get("sessionUserId")));
                }
            }

            Map<String, Object> mapValue = new HashMap<>();
            mapValue.put("boardID", forumRequestDTO.getBoardID());
            mapValue.put("parentID", forumRequestDTO.getBoardID());
            mapValue.put("userId", forumRequestDTO.getUserID());
            mapValue.put("s_itemID", forumRequestDTO.getItemID());
            mapValue.put("emailCode", forumRequestDTO.getEmailCode());

            // 1. 별점 입력/갱신 또는 조회수 업데이트
            if ("editScore".equals(forumRequestDTO.getFilter())) {
                if ("0".equals(commonService.selectString("forumScore_SQL.isExistScore", mapValue))) {
                    List<Map<String, Object>> insertList = new ArrayList<>();
                    Map<String, Object> insertValMap = new HashMap<>();
                    insertValMap.put("boardID", forumRequestDTO.getBoardID());
                    insertValMap.put("userId", forumRequestDTO.getUserID());
                    insertList.add(insertValMap);
                    Map<String, Object> insertInfoMap = new HashMap<>();
                    insertInfoMap.put("KBN", "insert");
                    insertInfoMap.put("SQLNAME", "forumScore_SQL.scoreInsert");
                    commonService.save(insertList, insertInfoMap);
                } else {
                    List<Map<String, Object>> updateList = new ArrayList<>();
                    Map<String, Object> updateValMap = new HashMap<>();
                    updateValMap.put("boardID", forumRequestDTO.getBoardID());
                    updateValMap.put("userId", forumRequestDTO.getUserID());
                    updateList.add(updateValMap);
                    Map<String, Object> updateInfoMap = new HashMap<>();
                    updateInfoMap.put("KBN", "update");
                    updateInfoMap.put("SQLNAME", "forumScore_SQL.scoreUpdate");
                    forumService.save(updateList, updateInfoMap);
                }
            } else if ("".equals(forumRequestDTO.getFilter())) {
                List<Map<String, Object>> updateList = new ArrayList<>();
                Map<String, Object> updateValMap = new HashMap<>();
                updateValMap.put("boardID", forumRequestDTO.getBoardID());
                updateList.add(updateValMap);
                Map<String, Object> updateInfoMap = new HashMap<>();
                updateInfoMap.put("KBN", "update");
                updateInfoMap.put("SQLNAME", "forum_SQL.forumReadCntUpdate");
                forumService.save(updateList, updateInfoMap);
            }

            // 2. 게시물 기본 정보, 댓글, 파일 목록 조회
            mapValue.put("languageID", forumRequestDTO.getSessionCurrLangType());
            mapValue.put("boardMgtID", forumRequestDTO.getBoardMgtID());
            mapValue.put("myBoard", forumRequestDTO.getMyBoard());
            mapValue.put("sessionUserId", forumRequestDTO.getSessionUserId());

            Map boardMap = commonService.select("forum_SQL.getForumEditInfo", mapValue);
            List fileList = commonService.selectList("forumFile_SQL.forumFile_select", mapValue);
            List replyList = commonService.selectList("forum_SQL.getReplyList", mapValue);
            String replyFileCnt = commonService.selectString("forumFile_SQL.getReplyFileCnt", mapValue);

            if(replyList != null && !replyList.isEmpty()){
                for(int i=0; i < replyList.size(); i++){
                    Map replyInfo = (Map)replyList.get(i);
                    replyInfo.put("Content", StringUtil.replaceFilterString(StringUtil.checkNull(replyInfo.get("Content"))).replace("\n","<br>"));
                }
            }

            // 3. 좋아요 정보 조회
            Map<String, Object> setMap = new HashMap<>();
            setMap.put("BoardMgtID", forumRequestDTO.getBoardMgtID());
            String likeYN = commonService.selectString("board_SQL.getBoardLikeYN", setMap);
            String likeCNT = "";
            if("Y".equals(likeYN)) {
                setMap.put("BoardID", forumRequestDTO.getBoardID());
                likeCNT = commonService.selectString("board_SQL.getBoardLikeCNT",setMap);
            }

            // 4. 카테고리/게시판 명 조회
            String boardTitle = forumRequestDTO.getBoardTitle();
            if(!"".equals(forumRequestDTO.getBoardMgtID())){
                setMap.put("languageID", forumRequestDTO.getSessionCurrLangType());
                String boardMgtName = StringUtil.checkNull(commonService.selectString("board_SQL.getBoardMgtName",setMap));
                resultData.put("boardMgtName", boardMgtName);
                if("".equals(boardTitle)) boardTitle = boardMgtName;
            }
            resultData.put("boardTitle", boardTitle);             

            // 5. 게시물 컨텐츠 HTML 이스케이프 해제 처리
            if(boardMap != null) {
                String Content = StringUtil.checkNull(boardMap.get("Content"),"");
                String Subject = StringUtil.checkNull(boardMap.get("Subject"),"");
                
                Content = StringEscapeUtils.unescapeHtml4(Content.replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&amp;lt;", "<").replaceAll("&amp;gt;", ">").replaceAll("&quot;", "\""));
                Subject = StringEscapeUtils.unescapeHtml4(Subject);

                boardMap.put("Content", Content);
                boardMap.put("Subject", Subject);
            }

            // 6. 작성자, 게시판 옵션 등 부가 정보 조회
            setMap.put("s_itemID", forumRequestDTO.getItemID());
            setMap.put("languageID", forumRequestDTO.getSessionCurrLangType());
            setMap.put("boardID", forumRequestDTO.getBoardID());
            setMap.put("BoardID", forumRequestDTO.getBoardID());
            setMap.put("BoardMgtID", forumRequestDTO.getBoardMgtID());
            Map ItemMgtUserMap = commonService.select("forum_SQL.getItemAuthorName", setMap);
            String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);
            String replyOption = commonService.selectString("board_SQL.getBoardReplyOption", setMap);
            Map boardMgtInfo = commonService.select("board_SQL.getBoardMgtInfo", setMap);

            // 7. SR 옵션 파라미터 (JSP 단으로 돌려보내기 위함)
            Map<String, String> srOptions = new HashMap<>();
            if(!"".equals(forumRequestDTO.getSrID())){
                srOptions.put("srCategory", forumRequestDTO.getSrCategory());
                srOptions.put("srArea1", forumRequestDTO.getSrArea1());
                srOptions.put("subject", forumRequestDTO.getSubject()); // Assuming subject is from DTO
                srOptions.put("searchStatus", forumRequestDTO.getSearchStatus());
                srOptions.put("receiptUser", forumRequestDTO.getReceiptUser());
                srOptions.put("requestUser", forumRequestDTO.getRequestUser());
                srOptions.put("requestTeam", forumRequestDTO.getRequestTeam());
                srOptions.put("startRegDT", forumRequestDTO.getStartRegDT());
                srOptions.put("endRegDT", forumRequestDTO.getEndRegDT());
                srOptions.put("searchSrCode", forumRequestDTO.getSearchSrCode());
                srOptions.put("srReceiptTeam", forumRequestDTO.getSrReceiptTeam());
                srOptions.put("srMode", forumRequestDTO.getSrMode());
            }
            
            // ----- 결과 JSON 조립 -----
            resultData.put("boardMap", boardMap);
            resultData.put("fileList", fileList);
            resultData.put("replyList", replyList);
            resultData.put("replyListCnt", replyList != null ? replyList.size() : 0);
            resultData.put("replyFileCnt", replyFileCnt);
            resultData.put("LikeYN", likeYN);
            resultData.put("likeCNT", likeCNT);              
            resultData.put("ItemMgtUserMap", ItemMgtUserMap);
            resultData.put("CategoryYN", categoryYN);
            resultData.put("replyOption", replyOption);
            resultData.put("BoardMgtInfo", boardMgtInfo);
            resultData.put("srOptions", srOptions);

            success = true;
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            _log.error(e);
        } catch (DataAccessException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            _log.error(e);
        } catch (JSONException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            _log.error(e);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            _log.error(e);
        } finally {
            resultData.put("success", success);
            try {
                response.getWriter().print(resultData);
            } catch (Exception e) {
                _log.error(e.getMessage());
            }
        }
    }

    @RequestMapping(value = "/getRegisterForumPostData.do")
    public void getRegisterForumPostData(HttpServletRequest request, @ModelAttribute ForumRequestDTO forumRequestDTO, HttpServletResponse response) throws Exception {
        
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        JSONObject resultData = new JSONObject();
        boolean success = false;
        
        try {
            // DTO에 세션 정보 주입
            Map<String, Object> loginInfo = (Map<String, Object>) request.getSession().getAttribute("loginInfo");
            if (loginInfo != null) {
                forumRequestDTO.setSessionUserId(StringUtil.checkNull(loginInfo.get("sessionUserId")));
                forumRequestDTO.setSessionCurrLangType(StringUtil.checkNull(loginInfo.get("sessionCurrLangType")));
            }

            Map<String, Object> setMap = new HashMap<>();
            
            // 게시판 이름 조회
            String boardTitle = forumRequestDTO.getBoardTitle();
            if(!"".equals(forumRequestDTO.getBoardMgtID())){
                setMap.put("BoardMgtID", forumRequestDTO.getBoardMgtID());
                setMap.put("languageID", forumRequestDTO.getSessionCurrLangType());
                String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName",setMap);           
                resultData.put("boardMgtName", boardMgtName);	
                if("".equals(boardTitle)) boardTitle = boardMgtName;
            }
            resultData.put("boardTitle", boardTitle);              
        
            setMap.put("s_itemID", forumRequestDTO.getItemID());
            Map itemMgtUserMap = commonService.select("forum_SQL.getItemAuthorName", setMap);
            String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);	
            
            resultData.put("CategoryYN", categoryYN);
            resultData.put("ItemMgtUserMap", itemMgtUserMap);
            resultData.put("action", "success");
            success = true;
            
        } catch (Exception e) {
            _log.error(e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resultData.put("message", "An error occurred.");
            success = false;
        } finally {
            resultData.put("success", success);
            try {
                response.getWriter().print(resultData);
            } catch (Exception e) {
                _log.error(e.getMessage());
            }
        }
    }

    @RequestMapping(value = "/getEditForumPostData.do")
    public void getEditForumPostData(HttpServletRequest request, @ModelAttribute ForumRequestDTO forumRequestDTO, HttpServletResponse response) throws Exception {
        
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        JSONObject resultData = new JSONObject();
        boolean success = false;
        
        try {
            // DTO에 세션 정보 주입
            Map<String, Object> loginInfo = (Map<String, Object>) request.getSession().getAttribute("loginInfo");
            if (loginInfo != null) {
                forumRequestDTO.setSessionUserId(StringUtil.checkNull(loginInfo.get("sessionUserId")));
                forumRequestDTO.setSessionCurrLangType(StringUtil.checkNull(loginInfo.get("sessionCurrLangType")));
            }

            Map<String, Object> setMap = new HashMap<>();
            
            // 게시판 이름 조회
            String boardTitle = forumRequestDTO.getBoardTitle();
            if(!"".equals(forumRequestDTO.getBoardMgtID())){
                setMap.put("BoardMgtID", forumRequestDTO.getBoardMgtID());
                setMap.put("languageID", forumRequestDTO.getSessionCurrLangType());
                String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName",setMap);           
                resultData.put("boardMgtName", boardMgtName);	
                if("".equals(boardTitle)) boardTitle = boardMgtName;
            }
            resultData.put("boardTitle", boardTitle);              
        
            // 게시글 정보 조회
            setMap.put("languageID", forumRequestDTO.getSessionCurrLangType());
            setMap.put("boardID", forumRequestDTO.getBoardID());			
            setMap.put("emailCode", forumRequestDTO.getEmailCode());	
            setMap.put("myBoard", "Y");
            setMap.put("sessionUserId", forumRequestDTO.getSessionUserId());
            
            Map resultMap = commonService.select("forum_SQL.getForumEditInfo", setMap);
            if(resultMap != null && !resultMap.isEmpty()) {
                String subject = StringUtil.checkNull(resultMap.get("Subject")).replaceAll("\"", "&quot;");
                String content = StringUtil.checkNull(resultMap.get("Content"),"");
                
                content = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(content));
                subject = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(subject));

                content = StringEscapeUtils.unescapeHtml4(content);
                subject = StringEscapeUtils.unescapeHtml4(subject);

                content = content.replaceAll("&lt;", "<").replaceAll("&gt;", ">")
                                 .replaceAll("&amp;lt;", "<").replaceAll("&amp;gt;", ">")
                                 .replaceAll("&quot;", "\"");
                
                resultMap.put("Subject", subject);
                resultMap.put("Content", content);					
            }
            
            // 수정 권한 체크
            String regUserId = (resultMap != null) ? StringUtil.checkNull(resultMap.get("RegUserID")) : "";
            if(resultMap == null || resultMap.isEmpty() || !forumRequestDTO.getSessionUserId().equals(regUserId)) {
                resultData.put("action", "redirect");
                resultData.put("message", "수정 권한이 없습니다.");
                success = true;
            } else {
                // 첨부파일 및 기타 정보 조회
                setMap.put("s_itemID", forumRequestDTO.getItemID());
                
                Map itemMgtUserMap = commonService.select("forum_SQL.getItemAuthorName", setMap);
                String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);	
                List itemFiles = commonService.selectList("forumFile_SQL.forumFile_selectList", setMap);
                
                resultData.put("forumInfo", resultMap);
                resultData.put("CategoryYN", categoryYN);
                resultData.put("ItemMgtUserMap", itemMgtUserMap);
                resultData.put("itemFiles", itemFiles);
                resultData.put("action", "success");
                success = true;
            }
        } catch (Exception e) {
            _log.error(e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resultData.put("message", "An error occurred.");
            success = false;
        } finally {
            resultData.put("success", success);
            try {
                response.getWriter().print(resultData);
            } catch (Exception e) {
                _log.error(e.getMessage());
            }
        }
    }

    @RequestMapping(value = "/deleteBoardComment.do")
    public void deleteBoardComment(HttpServletRequest request, @ModelAttribute ForumRequestDTO forumRequestDTO, HttpServletResponse response) throws Exception {
        
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        JSONObject resultData = new JSONObject();
        boolean success = false;
        
        try {
            Map<String, Object> loginInfo = (Map<String, Object>) request.getSession().getAttribute("loginInfo");
            String sessionCurrLangCode = (loginInfo != null) ? StringUtil.checkNull(loginInfo.get("sessionCurrLangCode")) : "KO";

            Map<String, Object> mapValue = new HashMap<>();
            mapValue.put("boardID", forumRequestDTO.getBoardID());

            // 1. 첨부파일 리스트 조회 및 물리적 파일 삭제
            List<String> deletefileList = commonService.selectList("forumFile_SQL.forumFile_select2", mapValue);
            if (deletefileList != null) {
                for (String filePath : deletefileList) {
                    FileUtil.deleteFile(filePath);
                }
            }

            // 2. 댓글 및 관련 파일 데이터베이스 기록 삭제
            List<Map<String, Object>> deleteList = new ArrayList<>();
            deleteList.add(mapValue);
            Map<String, Object> deleteForumInfoMap = new HashMap<>();
            deleteForumInfoMap.put("KBN", "delete");
            deleteForumInfoMap.put("SQLNAME", "forumComment_SQL.commentDelete");
            forumService.save(deleteList, deleteForumInfoMap);

            // 3. 본문 글의 댓글 카운트 업데이트 (1 감소)
            if(!StringUtil.checkNull(forumRequestDTO.getParentID()).isEmpty()) {
                Map<String, Object> updateValMap = new HashMap<>();
                Map<String, Object> updateInfoMap = new HashMap<>();
                List<Map<String, Object>> updateList = new ArrayList<>();
                updateValMap.put("parentID", forumRequestDTO.getParentID());
                updateList.add(updateValMap);
                updateInfoMap.put("KBN", "update");
                updateInfoMap.put("SQLNAME", "forum_SQL.commentDec");
                forumService.save(updateList, updateInfoMap);
            }

            resultData.put("result", "success");
            resultData.put("message", MessageHandler.getMessage(sessionCurrLangCode + ".WM00069"));
            success = true;

        } catch (Exception e) {
            _log.error(e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resultData.put("message", "An error occurred during comment deletion.");
            success = false;
        } finally {
            resultData.put("success", success);
            try {
                response.getWriter().print(resultData);
            } catch (Exception e) {
                _log.error(e.getMessage());
            }
        }
    }
}