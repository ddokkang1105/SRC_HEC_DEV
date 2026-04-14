package xbolt.custom.daelim.itsm ;


import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.security.cert.X509Certificate;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.soap.MessageFactory;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;
import javax.xml.transform.dom.DOMSource;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.org.json.JSONArray;
/*
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpATTRS;
import com.nets.sso.agent.AuthUtil;
import com.nets.sso.agent.authcheck.AuthCheck;
import com.nets.sso.common.AgentExceptionCode;
import com.nets.sso.common.enums.AuthStatus;
*/
import com.org.json.JSONObject;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.custom.daelim.val.DaelimGlobalVal;
import xbolt.app.esp.main.util.ESPUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;
import xbolt.project.chgInf.web.CSActionController;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;

import java.io.BufferedInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

import javax.servlet.ServletException;

import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipOutputStream;

import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.val.DrmGlobalVal;

import org.springframework.web.multipart.MultipartHttpServletRequest;

/**
 * 
 * @Class Name : DLMActionController.java
 * @Description : Daelim WF Action Controller
 * @since 2024. 08. 02.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class ITSMActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "boardService")
	private CommonService boardService;
	
	@RequestMapping(value = "/scrOutputRcdMgt.do")
	public String scrOutputRcdMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/custom/daelim/itsm/scrOutputRcdMgt"; 
		try {
			String editMode = "N";
			String srID = StringUtil.checkNull(request.getParameter("srID"), "");
			String speCode = StringUtil.checkNull(request.getParameter("speCode"), "");
			String procRoleTP = StringUtil.checkNull(request.getParameter("procRoleTP"), "");
			
			String receiptUserID = StringUtil.checkNull(request.getParameter("receiptUserID"));
			String srArea2 = StringUtil.checkNull(request.getParameter("srArea2"));
			String activityStatus = StringUtil.checkNull(request.getParameter("activityStatus"));
			String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			
			setMap.put("srID", srID);
			Map mbrRcd = commonService.select("esm_SQL.selectMbrRcd", setMap);
			
			if(!mbrRcd.isEmpty()) {
				String CHANGE_DATA_OUTPUT_DTL = StringUtil.checkNull(mbrRcd.get("CHANGE_DATA_OUTPUT_DTL")).replace("\"", "\\\"");
				String NEW_SCRIN_OUTPUT_DTL = StringUtil.checkNull(mbrRcd.get("NEW_SCRIN_OUTPUT_DTL")).replace("\"", "\\\"");
				
				mbrRcd.put("CHANGE_DATA_OUTPUT_DTL", CHANGE_DATA_OUTPUT_DTL);
				mbrRcd.put("NEW_SCRIN_OUTPUT_DTL", NEW_SCRIN_OUTPUT_DTL);
			}
			
			String clientID = StringUtil.checkNull(request.getParameter("clientID"), "");
			
			// 편집모드
			/*
			if(activityStatus.equals("00")) {	// 접수 전
				setMap.put("RoleType", procRoleTP);
				setMap.put("srArea", srArea2);
				List roleUserList = commonService.selectList("esm_SQL.getReceiptUserList", setMap);
				
				String RoleTPID = "";
				if(roleUserList.size()>0){
					for(int i=0; i<roleUserList.size(); i++){
						Map RoleMap = (Map)roleUserList.get(i);
						RoleTPID = StringUtil.checkNull(RoleMap.get("CODE"));
						if(RoleTPID.equals(StringUtil.checkNull(cmmMap.get("sessionUserId")))) {
							editMode = "Y";
							break;
						}
					}
				}
			}
			*/
			if(sessionUserID.equals(receiptUserID) && activityStatus.equals("01")) editMode = "Y"; // 접수
			
			model.put("editMode", editMode);
						
			model.put("rcdID", StringUtil.checkNull(mbrRcd.get("RCDID")));
			model.put("srID", srID);
			model.put("speCode", speCode);
			model.put("procRoleTP", procRoleTP);
			model.put("mbrRcd", mbrRcd);
			model.put("clientID",clientID);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/saveOutputRcd.do")
	public String saveOutputRcd(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		Map target = new HashMap();
		try {
			Enumeration params = request.getParameterNames();
			while (params.hasMoreElements()){
				String name = (String)params.nextElement();
				setMap.put(name,  StringUtil.checkNull(request.getParameter(name), ""));
			}
			setMap.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId"))); 
			
			if(StringUtil.checkNull(setMap.get("rcdID")).equals("")) {
				String maxRCDID = commonService.selectString("esm_SQL.getMaxRCDID", setMap);
				setMap.put("rcdID", maxRCDID);
				commonService.insert("zDLM_SQL.insertOutputRcd", setMap);
			} else {
				setMap.put("rcdID", setMap.get("rcdID"));
				commonService.update("zDLM_SQL.updateOutputRcd", setMap);
			}
			
			target.put(AJAX_SCRIPT, "saveCallBack("+setMap.get("rcdID")+")");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); //  삤瑜  諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	
	@RequestMapping(value = "/espDueDateMgt.do")
	public String espDueDateMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/custom/daelim/itsm/espDueDateMgt"; 
		try {
			String editMode = "N";
			String srID = StringUtil.checkNull(request.getParameter("srID"), "");
			String speCode = StringUtil.checkNull(request.getParameter("speCode"), "");
			String dueDate = StringUtil.checkNull(request.getParameter("dueDate"), "");
			String procRoleTP = StringUtil.checkNull(request.getParameter("procRoleTP"), "");
			String receiptUserID = StringUtil.checkNull(request.getParameter("receiptUserID"));
			String srArea2 = StringUtil.checkNull(request.getParameter("srArea2"));
			String activityStatus = StringUtil.checkNull(request.getParameter("activityStatus"));
			String languageID = StringUtil.checkNull(request.getParameter("languageID"));
			String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String espDueDateMgt = StringUtil.checkNull(request.getParameter("espDueDateMgt"));
			
			setMap.put("srID", srID);
			setMap.put("status", speCode);
			setMap.put("languageID", languageID);
			
			String sortNum = StringUtil.checkNull(commonService.selectString("esm_SQL.getESPStatusSortNum", setMap));
			setMap.put("sortNum", sortNum);
			
			// 다음단계부터 진행
			if("2".equals(espDueDateMgt)){
				setMap.put("rulePass", "Y");
				List nextStatusList = commonService.selectList("esm_SQL.getESPNextEventList",setMap);
				if(nextStatusList.size() > 0 && !nextStatusList.isEmpty()){
					Map nextMap = (Map) nextStatusList.get(0);
					String NextSpeCode = StringUtil.checkNull(nextMap.get("SRNextStatus"),"");
					if(!"".equals(speCode)) setMap.put("status", NextSpeCode);
					String NextSortNum = StringUtil.checkNull(nextMap.get("NextSortNum"),"");
					if(!"".equals(sortNum)) setMap.put("sortNum", NextSortNum);
				}
			}
			
			// dueDateList
			List<Map> dueDateList = new ArrayList();
			
			// 편집모드
			if(!"V".equals(espDueDateMgt)){
				
				dueDateList = commonService.selectList("esm_SQL.getEspDueDateEditList", setMap);
				if(activityStatus.equals("01") && sessionUserID.equals(receiptUserID)) editMode = "Y";
				
			} else {
				dueDateList = commonService.selectList("esm_SQL.getEspDueDateList", setMap);
			}
			
			model.put("editMode", editMode);
		
			model.put("srID", srID);
			model.put("speCode", speCode);
			model.put("dueDate", dueDate);
			model.put("procRoleTP", procRoleTP);
			
			JSONArray gridData = new JSONArray(dueDateList);
			model.put("gridData",gridData);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/saveEspDueDate.do")
	public void saveEspDueDate(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
	    ObjectMapper objectMapper = new ObjectMapper();
	    HashMap<String, Object> setData = new HashMap<>();
	    
        res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
		
	    try {
	        // 요청 본문에서 JSON 데이터 읽기
	        StringBuilder jsonBuilder = new StringBuilder();
	        try (BufferedReader reader = request.getReader()) {
	            String line;
	            while ((line = reader.readLine()) != null) {
	                jsonBuilder.append(line);
	            }
	        }
	        String jsonString = jsonBuilder.toString();
	        
	        // jsonString을 Map 객체로 변환
	        Map<String, Object> jsonMap = objectMapper.readValue(jsonString, new TypeReference<Map<String, Object>>(){});
	        List<Map<String, Object>> dataList = (List<Map<String, Object>>) jsonMap.get("data");

	        // 데이터 처리 로직
	        String dueDate = "";
	        String srID = "";
	        int index = 0;
	        int lastIndex = dataList.size() - 1;
	        
	        for (Map<String, Object> item : dataList) {
	            HashMap<String, Object> setMap = new HashMap<>(item);

                setMap.put("userID", cmmMap.get("sessionUserId"));
                setMap.put("docCategory", StringUtil.checkNull(item.get("docCategory"),"SR"));
                setMap.put("speCode", StringUtil.checkNull(item.get("SpeCode")));
                setMap.put("value", StringUtil.checkNull(item.get("SRAT0069")));
                
                commonService.update("esm_SQL.deleteSRAttr", setMap);	
                commonService.insert("esm_SQL.insertSRAttr", setMap);
                
                if (index == lastIndex) {
                	srID =  StringUtil.checkNull(item.get("srID"));
                	dueDate = StringUtil.checkNull(item.get("SRAT0069"));
                }
                index++;  // 인덱스 증가
	        }
	        
	        // sr_mst duedate 업데이트
	        Map dueDateMap = new HashMap();
	        dueDateMap.put("srID",srID);
	        dueDateMap.put("dueDate",dueDate);
	        dueDateMap.put("lastUser", cmmMap.get("sessionUserId"));
	        
	        commonService.update("esm_SQL.updateESMSR", dueDateMap);
			
	        jsonObject.put("result", true);
	        res.getWriter().print(jsonObject);	        
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        jsonObject.put("result", false);
	        res.getWriter().print(jsonObject);
	    }
	}
	
	// sql이랑 데이터 받아서 쿼리 리턴하기
	@RequestMapping(value = "/olmapi/list", method = RequestMethod.GET)
	@ResponseBody
	public void getList(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map setMap = new HashMap();
	    try {
	    	String sqlName = StringUtil.checkNull(request.getParameter("sqlName"),"");
	    	String loginUserId = StringUtil.checkNull(request.getParameter("loginUserId"),"");
	    	String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
	    	String srMode = StringUtil.checkNull(request.getParameter("srMode"),"");
	    	setMap.put("sqlName", sqlName);
        	setMap.put("loginUserId", loginUserId);
	        setMap.put("languageID", languageID);
	        setMap.put("srMode", srMode);

			List list = commonService.selectList(sqlName, setMap);
			jsonObject.put("list", list);
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
	
	@RequestMapping(value = "/zDaerim_updateAlarmOption.do" )
	public String zDaerim_updateAlarmOption( HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		Map target = new HashMap();
		
		try {
			String memberID = StringUtil.checkNull(request.getParameter("memberID"));
			String alarmOption = StringUtil.checkNull(request.getParameter("alarmOption"));
			
			setMap.put("memberID", memberID);
			setMap.put("alarmOption", alarmOption);
			
			commonService.update("zDaerim_updateAlarmOption", setMap);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "this.doCallBack();");

		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}	
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/espSearchRoleMemberList.do")
	public String espSearchRoleMemberList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/custom/daelim/itsm/espSearchRoleMemberList"; 
		HashMap setData = new HashMap();
		String varFilter = "";
		try {
			model.put("menu", getLabel(request, commonService)); // Label Setting			
			
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String sessionUserId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String sessionAuthLev = StringUtil.checkNull(cmmMap.get("sessionAuthLev")); // 시스템 관리자
			setData.put("itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			String itDeptOpt = StringUtil.checkNull(cmmMap.get("itDeptOpt")); // 시스템 관리자
			
			// 접근권한 체크
			/*setData.put("assignmentType", "CNGROLETP");
			setData.put("assigned", "1");
			setData.put("memberId", sessionUserId);
			List roleList = commonService.selectList("role_SQL.getAssignedRoleList_gridList", setData);
			if(roleList.size() > 0 || "1".equals(sessionAuthLev)){
				model.put("editYN", "Y");
			}*/
			
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("assignmentType", StringUtil.checkNull(request.getParameter("varFilter")));			
			model.put("blankPhotoUrlPath", GlobalVal.HTML_IMG_DIR + "/blank_photo.png");	
			model.put("photoUrlPath", GlobalVal.EMP_PHOTO_URL);
			model.put("itDeptOpt", itDeptOpt);
			
			// itemID 를 통해서 clientID 가져오기
			String clientID = StringUtil.checkNull(commonService.selectString("item_SQL.getItemClientID", setData));
	        model.put("clientID", clientID);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	
	// (주) 대림 개발
	@RequestMapping(value = "/zDlm_boardMgt.do")
	public String zDlm_boardMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		model.addAttribute(HTML_HEADER, "HOME");
		String reqBoardMgtID = StringUtil.checkNull(request.getParameter("boardMgtID"), "");
		String defBoardMgtID = StringUtil.checkNull(cmmMap.get("defBoardMgtID"));
		String BoardMgtID = "";
		String url = "/custom/daelim/itsm/cc/brd/zDlm_boardMainMenu";
		try {
			List boardMgtList = new ArrayList();
			String parentID = "";
			if (!reqBoardMgtID.equals("")) {// 그룹아이디로 넘어올경우 해당 그룹의 top 1 boardMgtID 찾아넣어주기
				parentID = commonService.selectString("board_SQL.getBoardParentID", cmmMap);
				if (parentID.equals("0")) {
					Map setData = new HashMap();
					setData.put("parentID", reqBoardMgtID);
					reqBoardMgtID = StringUtil
							.checkNull(commonService.selectString("board_SQL.getFirstBoardMgtID", setData));
				}
			}
			List boardGrpList = commonService.selectList("board_SQL.boardGrpList", cmmMap);
			boardMgtList = commonService.selectList("board_SQL.boardMgtListNew", cmmMap);
			String templName = commonService.selectString("board_SQL.getTemplName", cmmMap);

			model.put("templName", templName);
			model.put("boardGrpList", boardGrpList);
			model.put("boardMgtList", boardMgtList);
			model.put("boardLstCnt", StringUtil.checkNull(boardMgtList.size(), "0"));
			int grpOpenClose = 1;
			int loadingBoard = 2; // loading시 board 초기값 setting
			int j = 2;
			String boardGrpID = "";
			for (int i = 0; i < boardMgtList.size(); i++) {
				Map board = (HashMap) boardMgtList.get(i);
				if (!reqBoardMgtID.equals("")) {
					if (reqBoardMgtID.equals(StringUtil.checkNull(board.get("BoardMgtID")))) {
						model.put("BoardMgtID", StringUtil.checkNull(board.get("BoardMgtID")));
						model.put("StatusCount", i + 1);
						model.put("Url", StringUtil.checkNull(board.get("URL")));
						model.put("BoardTypeCD", StringUtil.checkNull(board.get("BoardTypeCD")));
						boardGrpID = StringUtil.checkNull(board.get("ParentID"));
						loadingBoard = j;
					}
				} else {
					if (i == 0) {
						BoardMgtID = StringUtil.checkNull(board.get("BoardMgtID"));
						model.put("BoardMgtID", StringUtil.checkNull(board.get("BoardMgtID")));
						model.put("StatusCount", i + 1);
						model.put("Url", StringUtil.checkNull(board.get("URL")));
						model.put("BoardTypeCD", StringUtil.checkNull(board.get("BoardTypeCD")));
						break;
					}
				}
				j++;
			}
			System.out.println("bbb loadingBoard:" + loadingBoard);
			if (!reqBoardMgtID.equals("")) {
				for (int i = 0; i < boardGrpList.size(); i++) {
					Map boardGrpMap = (HashMap) boardGrpList.get(i);
					if (boardGrpID.equals(StringUtil.checkNull(boardGrpMap.get("BoardGrpID")))) {
						// loadingBoard = loadingBoard+i+1;
						grpOpenClose = i + 1;
					}
				}
			}
			model.put("loadingBoard", loadingBoard);
			model.put("grpOpenClose", grpOpenClose);
			/* menu index 설정 */
			String menuIndex = ""; // 고정 메뉴 Index
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
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("projectID", cmmMap.get("projectID"));
			model.put("defBoardMgtID", defBoardMgtID);
			
			// 팝업에서 상세페이지로 바로 이동하는 옵션
			String goDetailOpt = StringUtil.checkNull(request.getParameter("goDetailOpt"),"");
			if("Y".equals(goDetailOpt)){
				String faqID = StringUtil.checkNull(request.getParameter("faqID"),"");
				model.put("faqID", faqID);
				String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
				model.put("s_itemID", s_itemID);
			}
			model.put("goDetailOpt", goDetailOpt);

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("BoardController::boardMgt::Error::" + e.toString().replaceAll("\r|\n", ""));
			}
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl(url);
	}
	
	@RequestMapping(value = "/zDlm_editBoard.do")
	public String zDlm_faqEditBoard(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/custom/daelim/itsm/cc/zDlm_editBoard";

		try {
			// 임시저장된 파일이 존재할 수 있으므로 삭제
			String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
			String templProjectID = StringUtil
.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap), "");
			if (!path.equals("")) {
				FileUtil.deleteDirectory(path);
			}

			String BoardMgtID = StringUtil
					.replaceFilterString(StringUtil.checkNull(request.getParameter("BoardMgtID"), "1"));
			String currPage = StringUtil.checkNull(request.getParameter("currPage"), "1");
			String screenType = StringUtil
					.replaceFilterString(StringUtil.checkNull(request.getParameter("screenType"), ""));
			String boardUrl = StringUtil.checkNull(request.getParameter("url"), "");
			String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
			String category = StringUtil.checkNull(request.getParameter("category"), "");
			String categoryIndex = StringUtil.checkNull(request.getParameter("categoryIndex"), "");
			String categoryCnt = StringUtil.checkNull(request.getParameter("categoryCnt"), "");

			String scStartDt = StringUtil.checkNull(cmmMap.get("scStartDt"));
			String searchKey = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchKey")));
			String searchValue = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchValue")));
			String scEndDt = StringUtil.checkNull(cmmMap.get("scEndDt"));

			String templProjectType = "";
			String projectType = StringUtil.checkNull(request.getParameter("projectType"), "");
			String projectCategory = StringUtil
					.replaceFilterString(StringUtil.checkNull(request.getParameter("projectCategory"), ""));
			String projectIDs = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectIDs"), ""));
			String faqID = StringUtil.checkNull(cmmMap.get("faqID"), "").replaceAll("\\s+", "");
			
			Map setMap = new HashMap();
			setMap.put("ProjectID", projectID);
			templProjectType = StringUtil.checkNull(commonService.selectString("zDLM_SQL.getProjectType", setMap),"");

			if (BoardMgtID != null) {
				setMap.put("BoardMgtID", BoardMgtID);
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName", setMap);
				String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);
				model.put("boardMgtName", boardMgtName);
				model.put("CategoryYN", categoryYN);
			}

			if ("N".equals(cmmMap.get("NEW"))) {
				// 조회수UPDATE
				commonService.update("zDLM_SQL.updateFaqInqireCo", cmmMap);
				Map result = commonService.select("zDLM_SQL.selectFaqListDetail", cmmMap);

				String subject = StringUtil.checkNull(result.get("QESTN_SJ"));
				subject = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(subject));
				subject = StringEscapeUtils.unescapeHtml4(subject);

				String content = StringUtil.checkNull(result.get("QESTN_CN"));
				content = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(content));
				content = StringEscapeUtils.unescapeHtml4(content);
				
				String answer = StringUtil.checkNull(result.get("ANSWER_CN"));
				answer = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(answer));
				answer = StringEscapeUtils.unescapeHtml4(answer);

				result.put("Subject", subject);
				result.put("Content", content);
				result.put("Answer", answer);

				model.put("result", result);

				model.put("itemFiles", (List) commonService.selectList("zDLM_File_SQL.getFilesFrom", result));

				model.put(AJAX_RESULTMAP, result);

//				String LikeYN = commonService.selectString("board_SQL.getBoardLikeYN", setMap);
//				model.put("LikeYN", LikeYN);
//				String likeCNT = "";
//
//				if (LikeYN != null && "Y".equals(LikeYN)) {
//					setMap.put("BoardMgtID", result.get("BoardMgtID"));
//					setMap.put("BoardID", result.get("BoardID"));
//					likeCNT = commonService.selectString("board_SQL.getBoardLikeCNT", setMap);
//					model.put("likeCNT", likeCNT);
//				}

			} else {
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
				model.put(AJAX_RESULTMAP, result);
			}

			// model.put("templProjectType", templProjectType);
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
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("ProjectID", projectID);
			model.put("defBoardMgtID", cmmMap.get("defBoardMgtID"));
			model.put("category", category);
			model.put("categoryIndex", categoryIndex);
			model.put("categoryCnt", categoryCnt);
			model.put("projectCategory", projectCategory);

			if (screenType.equals("PG") || screenType.equals("PJT")) {
				if (!projectID.equals("")) {
					Map projectMap = new HashMap();
					setMap.put("parentID", projectID);
					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
					projectMap = commonService.select("task_SQL.getProjectAuthorID", setMap);
					model.put("projectMap", projectMap);
				}
			}

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("BoardController::boardDetail::Error::" + e.toString().replaceAll("\r|\n", ""));
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/zDlm_boardDetail.do")
	public String boardDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {

		String url = "/custom/daelim/itsm/cc/zDlm_boardDetail";

		try {
			// 임시저장된 파일이 존재할 수 있으므로 삭제
			String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
			String templProjectID = StringUtil
					.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap), "");
			if (!path.equals("")) {
				FileUtil.deleteDirectory(path);
			}

			String BoardMgtID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("BoardMgtID"), "1"));
			String currPage = StringUtil.checkNull(request.getParameter("currPage"), "1");
			String screenType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("screenType"), ""));
			String boardUrl = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("url"), ""));
			String projectID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectID"), ""));
			String category = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("category"), ""));
			String categoryIndex = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("categoryIndex"), ""));
			String categoryCnt = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("categoryCnt"), ""));

			String scStartDt = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("scStartDt")));
			String searchKey = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchKey")));
			String searchValue = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchValue")));
			String scEndDt = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("scEndDt")));

			String templProjectType = "";
			String projectType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectType"), ""));
			String projectCategory = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectCategory"), ""));
			String projectIDs = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("projectIDs"), ""));

			Map setMap = new HashMap();
			setMap.put("s_itemID", templProjectID);
			templProjectType = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectType", setMap),"");

			if (BoardMgtID != null) {
				setMap.put("BoardMgtID", BoardMgtID);
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName", setMap);
				String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);
				model.put("boardMgtName", boardMgtName);
				model.put("CategoryYN", categoryYN);

			}

			// 조회수UPDATE
			commonService.update("zDLM_SQL.updateFaqInqireCo", cmmMap);
			Map result = commonService.select("zDLM_SQL.selectFaqListDetail", cmmMap);

			String s_BoardMgtID = StringUtil.checkNull(result.get("BoardMgtID"), "");

			/*
			 * if (!s_BoardMgtID.equals(BoardMgtID)) { model.put("BoardMgtID", BoardMgtID);
			 * return nextUrl("/custom/daelim/itsm/cc/zDlm_faqList"); }
			 */
			String faqID = StringUtil.checkNull(result.get("FAQ_ID"));
			faqID = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(faqID));
			faqID = StringEscapeUtils.unescapeHtml4(faqID);

			String subject = StringUtil.checkNull(result.get("QESTN_SJ"));
			subject = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(subject));
			subject = StringEscapeUtils.unescapeHtml4(subject);

			String content = StringUtil.checkNull(result.get("QESTN_CN"));
			content = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(content));
			content = StringEscapeUtils.unescapeHtml4(content);
			
			String orgnzt = StringUtil.checkNull(result.get("ORGNZT_ID"));
			orgnzt = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(orgnzt));
			orgnzt = StringEscapeUtils.unescapeHtml4(orgnzt);
			
			String faqType = StringUtil.checkNull(result.get("FAQ_TYPE"));
			faqType = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(faqType));
			faqType = StringEscapeUtils.unescapeHtml4(faqType);

			String urgncyYN = StringUtil.checkNull(result.get("URGNCY_YN"));
			urgncyYN = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(urgncyYN));
			urgncyYN = StringEscapeUtils.unescapeHtml4(urgncyYN);
			
			String answerCN = StringUtil.checkNull(result.get("ANSWER_CN"));
			answerCN = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(answerCN));
			answerCN = StringEscapeUtils.unescapeHtml4(answerCN);
			
			result.put("Subject", StringEscapeUtils.unescapeHtml4(subject));
			result.put("Content", StringEscapeUtils.unescapeHtml4(content));
			result.put("Orgnzt", StringEscapeUtils.unescapeHtml4(orgnzt));
			result.put("FaqType", StringEscapeUtils.unescapeHtml4(faqType));
			result.put("UrgncyYN", StringEscapeUtils.unescapeHtml4(urgncyYN));
			result.put("FadID", StringEscapeUtils.unescapeHtml4(faqID));
			result.put("Answer", StringEscapeUtils.unescapeHtml4(answerCN));

			model.put("result", result);

			//첨부파일 조회
			model.put("itemFiles", (List) commonService.selectList("zDLM_File_SQL.getFilesFrom", result));

			model.put(AJAX_RESULTMAP, result);

			/*
			 * String LikeYN = commonService.selectString("board_SQL.getBoardLikeYN",
			 * setMap); model.put("LikeYN", LikeYN); String likeCNT = "";
			 * 
			 * if (LikeYN != null && "Y".equals(LikeYN)) { setMap.put("BoardMgtID",
			 * result.get("BoardMgtID")); setMap.put("BoardID", result.get("BoardID"));
			 * likeCNT = commonService.selectString("board_SQL.getBoardLikeCNT", setMap);
			 * model.put("likeCNT", likeCNT); }
			 */

			// model.put("templProjectType", templProjectType);
			model.put("scStartDt", scStartDt);
			model.put("searchKey", searchKey);
			model.put("searchValue", searchValue);
			model.put("scEndDt", scEndDt);
			model.put("templProjectID", templProjectID);
			model.put("projectType", projectType);
			model.put("BoardMgtID", BoardMgtID);
			model.put("currPage", currPage);
			model.put("NEW", StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("NEW"))));
			model.put("screenType", screenType);
			model.put("url", boardUrl);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("projectID", projectID);
			model.put("defBoardMgtID", cmmMap.get("defBoardMgtID"));
			model.put("category", category);
			model.put("categoryIndex", categoryIndex);
			model.put("categoryCnt", categoryCnt);
			model.put("projectCategory", projectCategory);
			model.put("projectIDs", projectIDs);

			if (!projectID.equals("")) {
				Map projectMap = new HashMap();
				setMap.put("projectID", orgnzt);
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				setMap.put("userID", cmmMap.get("sessionUserId"));
				projectMap = commonService.select("zDLM_SQL.getESPCustomerList", setMap);
				model.put("projectMap", projectMap);
			}
//			if (screenType.equals("PG") || screenType.equals("PJT")) {
//				if (!projectID.equals("")) {
//					Map projectMap = new HashMap();
//					setMap.put("projectID", orgnzt);
//					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
//					setMap.put("userID", cmmMap.get("sessionUserId"));
//					projectMap = commonService.select("zDlm_SQL.getProjectAuthorID", setMap);
//					model.put("projectMap", projectMap);
//				}
//			}

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("BoardController::boardDetail::Error::" + e.toString().replaceAll("\r|\n", ""));
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	
	@RequestMapping(value = "/zDlm_saveBoard.do")
	public String zDlm_saveBoard(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		XSSRequestWrapper xss = new XSSRequestWrapper(request);

		for (Iterator i = cmmMap.entrySet().iterator(); i.hasNext();) {
			Entry e = (Entry) i.next(); // not allowed

			if (!e.getKey().equals("loginInfo") && e.getValue() != null) {
				cmmMap.put(e.getKey(),
						xss.stripXSS2(e.getValue().toString()).replaceAll("<", "&lt;").replaceAll(">", "&gt;"));
			}
		}
		// Map map = new HashMap();
		List fileList = new ArrayList();
		String BoardMgtID = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("BoardMgtID"), ""));
		String BoardID = StringUtil.checkNull(cmmMap.get("BoardID"), "");
		String projectID = StringUtil.checkNull(cmmMap.get("project"));
		String screenType = StringUtil.checkNull(cmmMap.get("screenType"));
		String boardUrl = StringUtil.checkNull(cmmMap.get("boardUrl"));
		String pageNum = StringUtil.checkNull(cmmMap.get("pageNum"));
		String userId = StringUtil.checkNull(cmmMap.get("sessionLoginId"), "");
		String faqID = StringUtil.checkNull(cmmMap.get("faqID"), "").replaceAll("\\s+", "");

		Map setData = new HashMap();
		setData.put("BoardMgtID", BoardMgtID);

		Map boardMgtInfo = commonService.select("board_SQL.getBoardMgtInfo", cmmMap);
		
		String mgtOnlyYN = StringUtil.checkNull(boardMgtInfo.get("MgtOnlyYN"));
		String mgtUserID = StringUtil.checkNull(boardMgtInfo.get("MgtUserID"));
		String mgtGRID = StringUtil.checkNull(boardMgtInfo.get("MgtGRID"));		
		String sessionAuthLev = StringUtil.checkNull(cmmMap.get("sessionAuthLev"), "");
		String writeYN = "N";
		if ("N".equals(mgtOnlyYN) && Integer.parseInt(mgtGRID) > 0) {
			Map tmpMap = new HashMap();
			tmpMap.put("checkID", userId);
			tmpMap.put("groupID", mgtGRID);
			String check = StringUtil.checkNull(commonService.selectString("user_SQL.getEndGRUser", tmpMap), "");

			if (!"".equals(check)) {
				boardMgtInfo.put("MgtGRID2", mgtGRID);
			} else {
				boardMgtInfo.put("MgtGRID2", "");
			}
		}
		String mgtGRID2 = StringUtil.checkNull(boardMgtInfo.get("MgtGRID2"));
		
		if((mgtOnlyYN.equals("Y") && mgtUserID.equals(userId)) 
			|| (!mgtOnlyYN.equals("Y") && mgtGRID.equals(mgtGRID2))
			|| (!mgtOnlyYN.equals("Y") && Integer.parseInt(mgtGRID) < 1 && Integer.parseInt(sessionAuthLev) <= 2)
		){
			writeYN = "Y";
		}

		try {
			setData.put("userId", userId);
			String chkLimit = chkLimit(setData);
			
			if (writeYN.equals("N")){
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00033")); 
				target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID")
						+ "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove();");
			}else if("".equals(BoardID) && "Y".equals(chkLimit)){
				// 신규 등록 시 유저가 1분내에 5번 이상 글을 등록할 수 없다. 
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
				target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID")
						+ "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove();");
			} else {
				
				Map setMap = new HashMap();

				setMap.put("faqID", faqID);
				Map reqMap = commonService.select("zDLM_SQL.selectFaqListDetail", setMap);

				model.put("BoardMgtID", BoardMgtID);
				model.put("s_itemID", projectID);
				model.put("screenType", screenType);
				model.put("url", boardUrl);
				model.put("pageNum", pageNum);

				// cmmMap.put("BoardMgtID", BoardMgtID);
				// cmmMap.put("BoardID", BoardID);
				String Subject = StringUtil.checkNull(cmmMap.get("Subject"), "");
				Subject = StringUtil.replaceFilterString(Subject).replaceAll("<","&lt;").replaceAll(">","&gt;");

				String Content = StringUtil.checkNull(cmmMap.get("Content"), "");
				Content = StringUtil.replaceFilterString(Content).replaceAll("<","&lt;").replaceAll(">","&gt;");
				
				String Answer = StringUtil.checkNull(cmmMap.get("Answer"));
				Answer = StringUtil.replaceFilterString(Answer).replaceAll("<","&lt;").replaceAll(">","&gt;");
				
				String Division = StringUtil.checkNull(cmmMap.get("division"));
				String UrgncyYn = StringUtil.checkNull(cmmMap.get("urgncyYN"));
				String regUserID = StringUtil.checkNull(reqMap.get("FRST_REGISTER_ID"));
				if(UrgncyYn.equals("")) {
					UrgncyYn = "N";
				}
				
				cmmMap.put("Subject", Subject);
				cmmMap.put("Content", Content);
				cmmMap.put("Answer", Answer);
				cmmMap.put("ProjectID", projectID);
				cmmMap.put("Division", Division);
				cmmMap.put("UrgncyYn", UrgncyYn);

				

				// commandFileMap에 _ID 값이 없으면 신규 등록
				if ("".equals(faqID)) {
					// 신규 _ID 가져옴
					faqID = commonService.selectString("zDLM_SQL.faqNextVal", cmmMap);
					try {
					    String boardNumberStr = faqID.split("_")[1].replaceAll("\\s+", "");
					    int boardNumber = Integer.parseInt(boardNumberStr);
					    faqID = "FAQ_" + Integer.toString(boardNumber + 1).trim();
					} catch (NumberFormatException e) {
					    System.out.println("Invalid BoardID format: " + faqID);
					}
					cmmMap.put("GUBUN", "insert");
					cmmMap.put("FaqID", faqID);

					String savePath = ""; // 폴더 바꾸기
					String fileName = "";
					
					int seqCnt = 0;

					// Read Server File
					String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR
							+ StringUtil.checkNull(cmmMap.get("sessionUserId")) + "//";
					String targetPath = GlobalVal.FILE_UPLOAD_BOARD_DIR;
					List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
					String AtchFileId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
					cmmMap.put("AtchFileId", AtchFileId);
					
					commonService.insert("zDLM_SQL.InsertFaqCn", cmmMap);
					commonService.insert("zDLM_File_SQL.addFileMaster", cmmMap);
					
					if (tmpFileList != null) {
						for (int i = 0; i < tmpFileList.size(); i++) {
							String Seq = StringUtil.checkNull(commonService.selectString("zDLM_File_SQL.getFileSn", cmmMap),"");
							
							Map fileMap = new HashMap();
							HashMap resultMap = (HashMap) tmpFileList.get(i);
							fileMap.put("AtchFileId", AtchFileId);
							fileMap.put("FileSn", Seq);
							fileMap.put("FilePath", resultMap.get(FileUtil.FILE_PATH));
							fileMap.put("FileRealNm", resultMap.get(FileUtil.UPLOAD_FILE_NM));
							fileMap.put("FileNm", resultMap.get(FileUtil.ORIGIN_FILE_NM));
							fileMap.put("FileExt", resultMap.get(FileUtil.FILE_EXT));
							fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
							fileList.add(fileMap);
							commonService.insert("zDLM_File_SQL.addFileDetail", fileMap);
							seqCnt++;
						}
					}

//					이부분에서 file정보 삽입
//					boardService.save(fileList, cmmMap);

				} else if (regUserID.equals(userId)) {
					String AtchFileId = StringUtil.checkNull(reqMap.get("ATCH_FILE_ID"));
					
					cmmMap.put("AtchFileId", AtchFileId);
					cmmMap.put("GUBUN", "update");
					cmmMap.put("FaqID", faqID);
//					int Seq = Integer.parseInt(commonService.selectString("boardFile_SQL.boardFile_nextVal", cmmMap));
					int seqCnt = 0;
					// Read Server File
					String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR
							+ StringUtil.checkNull(cmmMap.get("sessionUserId")) + "//";
					String targetPath = GlobalVal.FILE_UPLOAD_BOARD_DIR;
					List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
					if (tmpFileList != null) {
						for (int i = 0; i < tmpFileList.size(); i++) {
							String Seq = StringUtil.checkNull(commonService.selectString("zDLM_File_SQL.getFileSn", cmmMap),"");
							Map fileMap = new HashMap();
							HashMap resultMap = (HashMap) tmpFileList.get(i);
							fileMap.put("AtchFileId", AtchFileId);
							fileMap.put("FileSn", Seq);
							fileMap.put("FilePath", resultMap.get(FileUtil.FILE_PATH));
							fileMap.put("FileRealNm", resultMap.get(FileUtil.UPLOAD_FILE_NM));
							fileMap.put("FileNm", resultMap.get(FileUtil.ORIGIN_FILE_NM));
							fileMap.put("FileExt", resultMap.get(FileUtil.FILE_EXT));
							fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
							fileList.add(fileMap);
							commonService.insert("zDLM_File_SQL.addFileDetail", fileMap);
							seqCnt++;
						}
					}

					commonService.update("zDLM_SQL.updateFaqCn", cmmMap);
//					boardService.save(fileList, cmmMap);
					// 임시 저장 디렉토리 삭제
					String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
					if (!path.equals("")) {
						FileUtil.deleteDirectory(path);
					}
				}

				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
																													// 성공
				target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID")
						+ "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove();");

			}

		} catch (Exception e) {
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		model.put("BoardMgtID", BoardMgtID);

		return nextUrl(AJAXPAGE);

	}
	
	@RequestMapping(value = "/zDlm_deleteBoard.do")
	public String deleteBoard(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		List fileList = new ArrayList();
		String BoardMgtID = StringUtil
				.replaceFilterString(StringUtil.checkNull(request.getParameter("BoardMgtID"), "1"));
		String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
		String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");
		String boardUrl = StringUtil.checkNull(request.getParameter("boardUrl"), "");
		String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "");
		String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"), "");

		model.put("BoardMgtID", BoardMgtID);
		model.put("projectID", projectID);
		model.put("screenType", screenType);
		model.put("url", boardUrl);
		model.put("pageNum", pageNum);

		try {
			Map setMap = new HashMap();

			String userLoginId = StringUtil.checkNull(cmmMap.get("sessionLoginId"), "");
			String faqID = StringUtil.checkNull(cmmMap.get("faqID"), "").replaceAll("\\s+", "");
			setMap.put("userLoginId", userLoginId);
			setMap.put("faqID", faqID);
			
			String regUserID = StringUtil.checkNull(commonService.selectString("zDLM_SQL.getForumInfo", setMap));
			if (userLoginId.equals(regUserID)) {
				cmmMap.put("GUBUN", "delete");
				commonService.delete("zDLM_SQL.deleteFaq", setMap);

				// target.put(AJAX_ALERT, "삭제가 성공하였습니다.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제
																													// 성공
				// target.put(AJAX_SCRIPT,
				// "parent.doReturn('DEL','"+BoardMgtID+");parent.$('#isSubmit').remove()");
				target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID")
						+ "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove()");
			}
		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("BoardController::deleteBoard::Error::" + e.toString().replaceAll("\r|\n", ""));
			}
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, "삭제중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류
																												// 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		model.put("BoardMgtID", BoardMgtID);
		// return nextUrl("admin/boardAdmin/boardAdminMgt");
		return nextUrl(AJAXPAGE);
	}
	
	public String chkLimit(Map map) throws Exception{
        
		// 같은 user가 1분에 5회 이상 게시글 작성 시 반려처리
		Map setData = new HashMap();
		String result = "N";
		
		String userID = StringUtil.checkNull(map.get("userId"),"");
		String boardMgtID = StringUtil.checkNull(map.get("BoardMgtID"),"");
		
		
		LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
        LocalDateTime pastTime = now.plusMinutes(-1);
        String scStartDt = pastTime.format(formatter);
        String scEndDt = now.format(formatter);
        
        setData.put("regUserID",userID);
        setData.put("boardMgtID",boardMgtID);
        setData.put("scStartDt",scStartDt);
        setData.put("scEndDt",scEndDt);
        
        String cnt = commonService.selectString("board_SQL.getBoardLimitChkCNT", setData);
        if(Integer.parseInt(cnt) >= 5){
        	result = "Y";
		}
        
        return result;
        
	}

	@RequestMapping(value="/zDlm_fileDownload.do")
	public String fileDownload( HttpServletRequest request, HttpServletResponse response, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		
		Map target = new HashMap();
		Map setMap = new HashMap();
		Map setData = new HashMap();
		
		
		String reqOrgiFileName[] = request.getParameter("seq").split(",");//StringUtil.checkNull(request.getParameter("originalFileName")).split(",");
		String reqSysFileName[] = request.getParameter("seq").split(",");//StringUtil.checkNull(request.getParameter("sysFileName")).split(",");
		String reqFilePath[] = request.getParameter("seq").split(",");
		String reqSeq[] = request.getParameter("seq").split(",");
		String reqComment[] = request.getParameter("seq").split(",");
		
		String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
		String returnValue = "";
		
		Map faqDetail = commonService.select("zDLM_SQL.selectFaqListDetail", cmmMap);
		setData.put("AtchFileId",faqDetail.get("ATCH_FILE_ID"));

		for(int i=0; reqSeq.length>i; i++){
			setData.put("seq", reqSeq[i]);
			if(scrnType.equals("BRD")){
				reqFilePath[i] = commonService.selectString("zDLM_File_SQL.getFilePath", setData);
				reqOrgiFileName[i] = commonService.selectString("zDLM_File_SQL.getFileName", setData);
				reqSysFileName[i] = reqFilePath[i] + commonService.selectString("zDLM_File_SQL.getFileSysName", setData);
			}
		}
		
		File orgiFileName = null;
		File sysFileName = null;
		String filePath = null;
		String viewName = null;
		String useFileLog = StringUtil.checkNull(GlobalVal.USE_FILE_LOG);
		String DRMFileDir = StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH) + StringUtil.checkNull(cmmMap.get("sessionUserId"))+"//";
		try{
			int fileCnt = reqOrgiFileName.length;
			if(fileCnt==1){
				Map mapValue = new HashMap();
				List getList = new ArrayList();
				
				mapValue.put("AtchFileId",faqDetail.get("ATCH_FILE_ID"));
				mapValue.put("seq", reqSeq[0]);
				Map result  = new HashMap();
				if(scrnType.equals("BRD")){
					result=commonService.select("zDLM_File_SQL.selectDownFile",mapValue);
					filePath = GlobalVal.FILE_UPLOAD_BOARD_DIR;			
				}
				
				String filename = StringUtil.checkNull(result.get("filename"));
				String original = StringUtil.checkNull(result.get("original"));
				String downFile = StringUtil.checkNull(result.get("downFile"));
				if (!new File(downFile).exists()) {					 
					 //target.put(AJAX_ALERT, "해당 파일 [ "+original+" ] 을 서버에서 찾을 수 없습니다");
					 target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00078", new String[]{original}));
					 target.put(AJAX_SCRIPT,  "setSubFrame();");
					 target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
					 // target.put(AJAX_NEXTPAGE, "jsp/file/fileGrpList.jsp");
					 model.addAttribute(AJAX_RESULTMAP, target);
				
					 return nextUrl(AJAXPAGE);
				}
				
				if(downFile == null || downFile.equals("")) downFile = FileUtil.FILE_UPLOAD_DIR + filename;
				if(filePath == null || filePath.equals("")) filePath = downFile.replace(filename, "");
				
				if ("".equals(filename)) {
					request.setAttribute("message", "File not found.");
					return "cmm/utl/EgovFileDown";
				}

				if ("".equals(original)) {
					original = filename;
				}
				setMap = new HashMap();
				setMap.put("Seq",reqSeq[0]);
				
				// 각 파일 테이블의 [DownCNT] update
				if(scrnType.equals("BRD")){
					setMap.put("TableName", "COMTNFILEDETAIL");
				}
				

				HashMap drmInfoMap = new HashMap();
				
				String userID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
				String userName = StringUtil.checkNull(cmmMap.get("sessionUserNm"));
				String teamID = StringUtil.checkNull(cmmMap.get("sessionTeamId"));
				String teamName = StringUtil.checkNull(cmmMap.get("sessionTeamName"));
				
				drmInfoMap.put("userID", userID);
				drmInfoMap.put("userName", userName);
				drmInfoMap.put("teamID", teamID);
				drmInfoMap.put("teamName", teamName);
				drmInfoMap.put("orgFileName", original);
				drmInfoMap.put("downFile", downFile);
				drmInfoMap.put("loginID", cmmMap.get("sessionLoginId"));
				drmInfoMap.put("sessionEmail", cmmMap.get("sessionEmail"));
				
				// file DRM 적용
				String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
				String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
				if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
					//DRMUtil.setDRM(drmInfoMap);
					drmInfoMap.put("ORGFileDir", filePath); // C://OLMFILE//document//
					drmInfoMap.put("DRMFileDir",DRMFileDir);
					drmInfoMap.put("Filename", filename);
					drmInfoMap.put("funcType", "download");
					returnValue = DRMUtil.drmMgt(drmInfoMap); // 암호화 
				}
				
				if(!"".equals(returnValue)) {
					downFile = returnValue;
				}
				
				request.setAttribute("downFile", downFile);
				request.setAttribute("orginFile", original);

				FileUtil.flMgtdownFile(request, response);
				
//				if(useFileLog.equals("Y")) {
//					// 한 개 기록
//					String ip = request.getHeader("X-FORWARDED-FOR");
//			        if (ip == null)
//			            ip = request.getRemoteAddr();
//			        cmmMap.put("IpAddress",ip);
//			        cmmMap.put("fileID", reqSeq[0]); 
//			        cmmMap.put("comment", reqComment[0]);
//					commonService.insert("fileMgt_SQL.insertFileLog",cmmMap);
//				}

				 
			}else{
				
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
				
				 for(int i=0; i<reqOrgiFileName.length; i++){
					returnValue = "";
					orgiFileName = new File(reqOrgiFileName[i]);
					sysFileName = new File(reqSysFileName[i]);
					
					drmInfoMap.put("orgFileName", reqOrgiFileName[i]);
					drmInfoMap.put("downFile", reqSysFileName[i].replace(reqFilePath[i], ""));
										
					String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
					String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
					if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
						drmInfoMap.put("ORGFileDir", reqFilePath[i]);
						drmInfoMap.put("DRMFileDir", DRMFileDir);
						drmInfoMap.put("Filename", reqSysFileName[i].replace(reqFilePath[i], ""));
						drmInfoMap.put("funcType", "download");
						returnValue = DRMUtil.drmMgt(drmInfoMap); // 암호화 
					}
					
					if(!sysFileName.exists()){
						viewName = orgiFileName.getName();
						// 파일이 없을경우 변경했던 파일명 원복 
						for(int k=0; k<reqOrgiFileName.length; k++){
								orgiFileName = new File(reqOrgiFileName[k]);
								sysFileName = new File(reqSysFileName[k]);
								orgiFileName.renameTo(sysFileName);
						 }
						target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00078", new String[]{viewName}));
						model.addAttribute(AJAX_RESULTMAP, target);
					
						return nextUrl(AJAXPAGE);
					}
					
					//System.out.println("drm returnValue :"+returnValue);
					if(!"".equals(returnValue)) {
						sysFileName = new File(returnValue);
						reqOrgiFileName[i] = returnValue;
						reqFilePath[i] = DRMFileDir;
					}
					
					if(sysFileName.exists()){
						
						sysFileName.renameTo(orgiFileName);
					}
					
//					if(useFileLog.equals("Y")) {
//						//여러 개 기록
//						String ip = request.getHeader("X-FORWARDED-FOR");
//				        if (ip == null)
//				            ip = request.getRemoteAddr();  
//						cmmMap.put("IpAddress",ip);
//					    cmmMap.put("fileID", reqSeq[i]); 
//					    cmmMap.put("comment", reqComment[i]);
//					    commonService.insert("fileMgt_SQL.insertFileLog",cmmMap);
//					}
				 }
				 
				 // zip file명 만들기 
				 Calendar cal = Calendar.getInstance();
				 java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
				 java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("HHmmssSSS");
				 String sdate = sdf.format(cal.getTime());
				 String stime = sdf2.format(cal.getTime());
				 String mkFileNm = sdate+stime;
				 
				 String path = GlobalVal.FILE_UPLOAD_ZIPFILE_DIR;
				 String fullPath = GlobalVal.FILE_UPLOAD_ZIPFILE_DIR+"downFiles"+sdf2+".zip";
				 String newFileNm = "FILE_"+mkFileNm+".zip";
				 
				 File zipFile = new File(fullPath); 
				 File dirFile = new File(path);
			  
				 if(!dirFile.exists()) {
				     dirFile.mkdirs();
				 } 
	
				 ZipOutputStream zos = null;
				 FileOutputStream os = null;
				 
				 try {
					 os = new FileOutputStream(zipFile);
					 zos = new ZipOutputStream(os);
					 byte[] buffer = new byte[1024 * 2];
					 int k = 0;
					 for(String file : reqOrgiFileName) {
						 filePath = reqFilePath[k];
						 if(new File(file).isDirectory()) { continue; }
				                
				         BufferedInputStream bis = null;
				         FileInputStream is = null;
				         try {
				        	 is = new FileInputStream (file);
				        	 bis = new BufferedInputStream(is);
				        	 file = file.replace(filePath, ""); 
					         
					         zos.putNextEntry(new ZipEntry(file));
					        			         
					         int length = 0;
					         while((length = bis.read(buffer)) != -1) {
					            zos.write(buffer, 0, length);
					         }
					         
				         } catch ( Exception e ) {
							 System.out.println(e.toString());
							 throw e;
						 } finally {
							 zos.closeEntry();
					         bis.close();
					         is.close();
					         k++;
						 }				         
					 }
				 } catch ( Exception e ) {
					 System.out.println(e.toString());
					 throw e;
				 } finally {
					 zos.closeEntry();
		             zos.close();
					 os.close();
				 }
			
	         //    request.setAttribute("orginFile", arg1);
				// 파일이름 원복
				for(int i=0; i<reqOrgiFileName.length; i++){
					setMap = new HashMap();
					orgiFileName = new File(reqOrgiFileName[i]);
					sysFileName = new File(reqSysFileName[i]);
					
					if(orgiFileName.exists()){
						orgiFileName.renameTo(sysFileName);
					}
					
					setMap.put("Seq",reqSeq[i]);
					// 각 파일 테이블의 [DownCNT] update
//					if(scrnType.equals("BRD")){
//						setMap.put("TableName", "TB_BOARD_ATTCH");
//					}
//					
				}
				String downFile = fullPath;
				request.setAttribute("downFile", downFile);
				request.setAttribute("orginFile", newFileNm);
				FileUtil.flMgtdownFile(request, response);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00079"));
			target.put(AJAX_SCRIPT, "doSearchList();");
			
		}catch (Exception e) {
			 System.out.println(e);
			 throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/zDlm_boardFileDelete.do")
	public String boardFileDelete(HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();		
			cmmMap.put("atchFileId", StringUtil.checkNull(cmmMap.get("atchFileId"), ""));
			cmmMap.put("Seq", StringUtil.checkNull(cmmMap.get("Seq"), ""));
			target = commonService.select("zDLM_File_SQL.boardFile_select", cmmMap);	//new mode
		try {
			
			String realFile = FileUtil.FILE_UPLOAD_DIR + target.get("FileName");
			File existFile = new File(realFile);
			if(existFile.exists() && existFile.isFile()){existFile.delete();}
			commonService.delete("zDLM_File_SQL.boardFile_delete", cmmMap);	//new mode
			/*
			if( delType.equals("BOARD")){
				//commonService.delete("CommonFile.commFile_delete", cmmMap);
			}
			 * */			
			//target.put(AJAX_ALERT, "파일 삭제가 성공하였습니다.");
			System.out.println("boardFileDelete try::"+MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00075"));
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00075")); // 성공
		}
		catch (Exception e) {
			System.out.println(e);
			//target.put(AJAX_ALERT, "파일 삭제중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00076")); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	// 전자결재 정보 가져오기
	@RequestMapping(value = "/olmapi/getDlmWFStatus", method = RequestMethod.POST)
	@ResponseBody
	public void getDlmWFStatus(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		ObjectMapper objectMapper = new ObjectMapper();
		Map setMap = new HashMap();
		
		res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
		
	    try {
	    	// 요청 본문에서 JSON 데이터 읽기
			StringBuilder jsonBuilder = new StringBuilder();
			try (BufferedReader reader = request.getReader()) {
				String line;
				while ((line = reader.readLine()) != null) {
					jsonBuilder.append(line);
				}
			}
	    	String jsonString = jsonBuilder.toString();
	    	Map<String, Object> data = objectMapper.readValue(jsonString, new TypeReference<Map<String, Object>>() {});
			
	    	String srID = StringUtil.checkNull(data.get("srID"));
	    	String languageID = StringUtil.checkNull(data.get("languageID"));
	    	String srCode = StringUtil.checkNull(data.get("srCode"));
	    	String sessionUserId = StringUtil.checkNull(data.get("sessionUserId"));
	    	
	    	setMap.put("srID", srID);
	    	setMap.put("languageID", languageID);
	    	setMap.put("srCode", srCode);

			List<Map<String, Object>> wfStatusMap = (List<Map<String, Object>>) commonService.selectList(data.get("sqlID").toString(), setMap);
			if (wfStatusMap != null) {
			    setMap.put("sessionUserID", sessionUserId);
			    String isMyProcRoleTPGroup1 = commonService.selectString("zDLM_SQL.getIsMyProcRoleTPGroup", setMap);
				String isMyRegion1 = commonService.selectString("zDLM_SQL.getIsMyRegion", setMap);
				String isMyProcRoleTPGroup2 = commonService.selectString("zDLM_SQL.getIsMyProcRoleTPGroup", setMap);
				String isMyRegion2 = commonService.selectString("zDLM_SQL.getIsMyRegion", setMap);
				 for (Map<String, Object> row : wfStatusMap) {
			        row.put("isMyProcRoleTPGroup1", isMyProcRoleTPGroup1);
			        row.put("isMyRegion1", isMyRegion1);
			        
			        row.put("isMyProcRoleTPGroup2", isMyProcRoleTPGroup2);
			        row.put("isMyRegion2", isMyRegion2);
				}
			}
			jsonObject.put("wfStatusMap", wfStatusMap);
	        res.getWriter().print(jsonObject);
	    
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
	
	
	
	//----------------------------------------------------------------------------------------------------------------------------------------------------------
	//-----------------------------------------------------------------여기부터 지식정보 관리---------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------------------------------------------------------------------
	
	@RequestMapping(value = "/zDlm_knowledgeEditBoard.do")
	public String editBoard(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {

		String url = "/custom/daelim/itsm/cc/zDlm_knowledgeEditBoard";

		try {
			// 임시저장된 파일이 존재할 수 있으므로 삭제
			String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
			String templProjectID = StringUtil
					.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap), "");
			if (!path.equals("")) {
				FileUtil.deleteDirectory(path);
			}

			String BoardMgtID = StringUtil
					.replaceFilterString(StringUtil.checkNull(request.getParameter("BoardMgtID"), "1"));
			String currPage = StringUtil.checkNull(request.getParameter("currPage"), "1");
			String screenType = StringUtil
					.replaceFilterString(StringUtil.checkNull(request.getParameter("screenType"), ""));
			String boardUrl = StringUtil.checkNull(request.getParameter("url"), "");
			String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
			String category = StringUtil.checkNull(request.getParameter("category"), "");
			String categoryIndex = StringUtil.checkNull(request.getParameter("categoryIndex"), "");
			String categoryCnt = StringUtil.checkNull(request.getParameter("categoryCnt"), "");

			String scStartDt = StringUtil.checkNull(cmmMap.get("scStartDt"));
			String searchKey = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchKey")));
			String searchValue = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchValue")));
			String scEndDt = StringUtil.checkNull(cmmMap.get("scEndDt"));

			String templProjectType = "";
			String projectType = StringUtil.checkNull(request.getParameter("projectType"), "");
			String projectCategory = StringUtil
					.replaceFilterString(StringUtil.checkNull(request.getParameter("projectCategory"), ""));

			Map setMap = new HashMap();
			setMap.put("s_itemID", templProjectID);
			templProjectType = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectType", setMap),
					"");

			if (BoardMgtID != null) {
				setMap.put("BoardMgtID", BoardMgtID);
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName", setMap);
				String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);
				model.put("boardMgtName", boardMgtName);
				model.put("CategoryYN", categoryYN);
			}

			if ("N".equals(cmmMap.get("NEW"))) {
				// 조회수UPDATE
				commonService.update("board_SQL.boardUpdateReadCnt", cmmMap);
				Map result = commonService.select("board_SQL.boardDetail", cmmMap);

				String subject = StringUtil.checkNull(result.get("Subject"));
				subject = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(subject));
				subject = StringEscapeUtils.unescapeHtml4(subject);

				String content = StringUtil.checkNull(result.get("Content"));
				content = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(content));
				content = StringEscapeUtils.unescapeHtml4(content);

				result.put("Subject", subject);
				result.put("Content", content);

				model.put("result", result);

				model.put("itemFiles", (List) commonService.selectList("boardFile_SQL.boardFile_selectList", cmmMap));

				model.put(AJAX_RESULTMAP, result);

				String LikeYN = commonService.selectString("board_SQL.getBoardLikeYN", setMap);
				model.put("LikeYN", LikeYN);
				String likeCNT = "";

				if (LikeYN != null && "Y".equals(LikeYN)) {
					setMap.put("BoardMgtID", result.get("BoardMgtID"));
					setMap.put("BoardID", result.get("BoardID"));
					likeCNT = commonService.selectString("board_SQL.getBoardLikeCNT", setMap);
					model.put("likeCNT", likeCNT);
				}

			} else {
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
				model.put(AJAX_RESULTMAP, result);
			}

			// model.put("templProjectType", templProjectType);
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
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("projectID", projectID);
			model.put("defBoardMgtID", cmmMap.get("defBoardMgtID"));
			model.put("category", category);
			model.put("categoryIndex", categoryIndex);
			model.put("categoryCnt", categoryCnt);
			model.put("projectCategory", projectCategory);

			if (screenType.equals("PG") || screenType.equals("PJT")) {
				if (!projectID.equals("")) {
					Map projectMap = new HashMap();
					setMap.put("parentID", projectID);
					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
					projectMap = commonService.select("task_SQL.getProjectAuthorID", setMap);
					model.put("projectMap", projectMap);
				}
			}

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("BoardController::boardDetail::Error::" + e.toString().replaceAll("\r|\n", ""));
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	
	
	
		// 지식정보 관리---------------------------------------------------------------------
		// ----------------------------------------------------------------------------------------------------------------------------------------------------------

		// 지식정보 관리 리스트
		@RequestMapping(value = "/zDlm_kInfoMEdit.do")
		public String zDlm_kInfoMEdit(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {

			String url = "/custom/daelim/itsm/cc/zDlm_kInfoMEdit";

			try {
				// 임시저장된 파일이 존재할 수 있으므로 삭제
				String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
				String templProjectID = StringUtil
						.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap), "");
				if (!path.equals("")) {
					FileUtil.deleteDirectory(path);
				}
				
				String knoId = StringUtil.checkNull(request.getParameter("knoId"), "");
				String searchkey = StringUtil.checkNull(request.getParameter("searchKey"), "");
				String searchValue = StringUtil.checkNull(request.getParameter("searchValue"), "");
				String searchOrg =  StringUtil.checkNull(request.getParameter("searchOrg"), "");

				if ("N".equals(StringUtil.checkNull(request.getParameter("NEW"),""))) {

					Map result = commonService.select("zDLM_KINFOM.selectKnoDetail", cmmMap);

					knoId = StringUtil.checkNull(result.get("knoId"));
					knoId = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(knoId));
					knoId = StringEscapeUtils.unescapeHtml4(knoId);

					String userNm = StringUtil.checkNull(result.get("userNm"));
					userNm = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(userNm));
					userNm = StringEscapeUtils.unescapeHtml4(userNm);

					String knoNm = StringUtil.checkNull(result.get("knoNm"));
					knoNm = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(knoNm));
					knoNm = StringEscapeUtils.unescapeHtml4(knoNm);
					
					String orgnztId = StringUtil.checkNull(result.get("orgnztId"));
					orgnztId = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(orgnztId));
					orgnztId = StringEscapeUtils.unescapeHtml4(orgnztId);

					String knoCn = StringUtil.checkNull(result.get("knoCn"));
					knoCn = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(knoCn));
					knoCn = StringEscapeUtils.unescapeHtml4(knoCn);

					String symtonDesc = StringUtil.checkNull(result.get("symtonDesc"));
					symtonDesc = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(symtonDesc));
					symtonDesc = StringEscapeUtils.unescapeHtml4(symtonDesc);

					String RootCauseDesc = StringUtil.checkNull(result.get("RootCauseDesc"));
					RootCauseDesc = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(RootCauseDesc));
					RootCauseDesc = StringEscapeUtils.unescapeHtml4(RootCauseDesc);
					
					String corpId = StringUtil.checkNull(result.get("corpId"));
					corpId = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(corpId));
					corpId = StringEscapeUtils.unescapeHtml4(corpId);
					
					String svcId = StringUtil.checkNull(result.get("svcId"));
					svcId = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(svcId));
					svcId = StringEscapeUtils.unescapeHtml4(svcId);
					
					String frstRegisterId = StringUtil.checkNull(result.get("frstRegisterId"));
					frstRegisterId = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(frstRegisterId));
					frstRegisterId = StringEscapeUtils.unescapeHtml4(frstRegisterId);
					
					result.put("companyName", commonService.select("zDLM_KINFOM.selectKnoCorpAndService", result).get("companyName"));
					result.put("srarea2Name", commonService.select("zDLM_KINFOM.selectKnoCorpAndService", result).get("srarea2Name"));
					result.put("knoId", knoId);
					result.put("frstRegisterId", frstRegisterId);
					result.put("userNm", userNm);
					result.put("knoCn", knoCn);
					result.put("knoNm", knoNm);
					result.put("symtonDesc", symtonDesc);
					result.put("rootCauseDesc", RootCauseDesc);
					result.put("srArea1",corpId);
					result.put("srArea2",svcId);

					model.put("result", result);
					model.put("itemFiles", (List) commonService.selectList("zDLM_File_SQL.getFilesFrom", result));
					model.put(AJAX_RESULTMAP, result);

				} else {
					Map result = new HashMap();
					result.put("knoId", "");
					result.put("companyName","");
					result.put("srarea2Name","");
					result.put("frstRegisterId","");
					result.put("userNm", "");
					result.put("knoCn", "");
					result.put("knoNm", "");
					result.put("symtonDesc", "");
					result.put("rootCauseDesc", "");
					model.put(AJAX_RESULTMAP, result);
				}
				
				model.put("menu", getLabel(request, commonService)); // Label Setting
				model.put("NEW", cmmMap.get("NEW"));
				model.put("searchKey", searchkey);
				model.put("searchValue", searchValue);
				model.put("searchOrg", searchOrg);
				

			} catch (Exception e) {
				if (_log.isInfoEnabled()) {
					_log.info("ITSMActionController::zDlm_editKnoDetail::Error::" + e.toString().replaceAll("\r|\n", ""));
				}
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl(url);
		}

		// 지식 정보 신규 등록 및 수정
		@RequestMapping(value = "/zDlm_knowledgeSaveBoard.do")
		public String zDlm_knowledgeSaveBoard(MultipartHttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
			Map target = new HashMap();
			XSSRequestWrapper xss = new XSSRequestWrapper(request);

			for (Iterator i = cmmMap.entrySet().iterator(); i.hasNext();) {
				Entry e = (Entry) i.next(); // not allowed

				if (!e.getKey().equals("loginInfo") && e.getValue() != null) {
					cmmMap.put(e.getKey(),
							xss.stripXSS2(e.getValue().toString()).replaceAll("<", "&lt;").replaceAll(">", "&gt;"));
				}
			}
			
			List fileList = new ArrayList();
			String BoardMgtID = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("BoardMgtID"), ""));
			String BoardID = StringUtil.checkNull(cmmMap.get("BoardID"), "");
			String projectID = StringUtil.checkNull(cmmMap.get("project"));
			String screenType = StringUtil.checkNull(cmmMap.get("screenType"));
			String boardUrl = StringUtil.checkNull(cmmMap.get("boardUrl"));
			String pageNum = StringUtil.checkNull(cmmMap.get("pageNum"));
			String userId = StringUtil.checkNull(cmmMap.get("sessionLoginId"), "");
			String knoId = StringUtil.checkNull(cmmMap.get("knoId"), "");
			Map setData = new HashMap();
			setData.put("BoardMgtID", BoardMgtID);

			Map boardMgtInfo = commonService.select("board_SQL.getBoardMgtInfo", cmmMap);

			String mgtOnlyYN = StringUtil.checkNull(boardMgtInfo.get("MgtOnlyYN"));
			String mgtUserID = StringUtil.checkNull(boardMgtInfo.get("MgtUserID"));
			String mgtGRID = StringUtil.checkNull(boardMgtInfo.get("MgtGRID"));
			String sessionAuthLev = StringUtil.checkNull(cmmMap.get("sessionAuthLev"), "");
			String writeYN = "N";
			
			if ("N".equals(mgtOnlyYN) && Integer.parseInt(mgtGRID) > 0) {
				Map tmpMap = new HashMap();
				tmpMap.put("checkID", userId);
				tmpMap.put("groupID", mgtGRID);
				String check = StringUtil.checkNull(commonService.selectString("user_SQL.getEndGRUser", tmpMap), "");

				if (!"".equals(check)) {
					boardMgtInfo.put("MgtGRID2", mgtGRID);
				} else {
					boardMgtInfo.put("MgtGRID2", "");
				}
			}
			
			String mgtGRID2 = StringUtil.checkNull(boardMgtInfo.get("MgtGRID2"));

			if ((mgtOnlyYN.equals("Y") && mgtUserID.equals(userId)) || (!mgtOnlyYN.equals("Y") && mgtGRID.equals(mgtGRID2))
					|| (!mgtOnlyYN.equals("Y") && Integer.parseInt(mgtGRID) < 1 && Integer.parseInt(sessionAuthLev) <= 2)) {
				writeYN = "Y";
			}

			try {
				setData.put("userId", userId);
				String chkLimit = chkLimit(setData);

				if (writeYN.equals("N")) {
					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00033"));
					target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID")
							+ "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove();");
				} else if ("".equals(BoardID) && "Y".equals(chkLimit)) {
					// 신규 등록 시 유저가 1분내에 5번 이상 글을 등록할 수 없다.
					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
					target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID")
							+ "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove();");
				} else {

					model.put("BoardMgtID", BoardMgtID);
					model.put("s_itemID", projectID);
					model.put("screenType", screenType);
					model.put("url", boardUrl);
					model.put("pageNum", pageNum);

			
					knoId = StringUtil.replaceFilterString(knoId);
							//.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

					String sympton = StringUtil.checkNull(cmmMap.get("sympton"), "");
					sympton = StringUtil.replaceFilterString(sympton);
							//.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
			
					String knoNm = StringUtil.checkNull(cmmMap.get("knoNm"), "");
					knoNm = StringUtil.replaceFilterString(knoNm);
							//.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
					
					String rootCause = StringUtil.checkNull(cmmMap.get("rootCause"), "");
					rootCause = StringUtil.replaceFilterString(rootCause);
							//.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

					String knwldgCn = StringUtil.checkNull(cmmMap.get("knwldgCn"), "");
					knwldgCn = StringUtil.replaceFilterString(knwldgCn);
							//.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

					cmmMap.put("knoId", knoId);
					cmmMap.put("knoNm", knoNm);
					cmmMap.put("sympton", sympton);
					cmmMap.put("rootCause", rootCause);
					cmmMap.put("knwldgCn", knwldgCn);
					cmmMap.put("orgnztId", projectID);
					cmmMap.put("userId", userId);
					Map setMap = new HashMap();

					setMap.put("knoId", knoId); 
					String regUserID = StringUtil.checkNull(commonService.selectString("zDLM_KINFOM.getForumRegID", setMap));

					// commandFileMap에 _ID 값이 없으면 신규 등록
					if ("".equals(knoId)) {
						// 신규 _ID 가져옴
						knoId = commonService.selectString("zDLM_KINFOM.boardNextVal", cmmMap);
						String knoTypeCd = commonService.selectString("zDLM_KINFOM.getKnoTypeCd", cmmMap);
						cmmMap.put("GUBUN", "insert");
						cmmMap.put("knoId", knoId);
						cmmMap.put("knoTypeCd", knoTypeCd);

						String savePath = ""; // 폴더 바꾸기
						String fileName = "";
						//int Seq = Integer.parseInt(commonService.selectString("boardFile_SQL.boardFile_nextVal", cmmMap));
						int seqCnt = 0;

						// Read Server File
						String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR
								+ StringUtil.checkNull(cmmMap.get("sessionUserId")) + "//";
						String targetPath = GlobalVal.FILE_UPLOAD_BOARD_DIR;
						List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
						String AtchFileId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
						cmmMap.put("AtchFileId", AtchFileId);

						commonService.insert("zDLM_KINFOM.insertKnoPersonal", cmmMap);
						commonService.insert("zDLM_File_SQL.addFileMaster", cmmMap);

						if (tmpFileList != null) {
							for (int i = 0; i < tmpFileList.size(); i++) {
								String fileSn = StringUtil
										.checkNull(commonService.selectString("zDLM_File_SQL.getFileSn", cmmMap), "");

								Map fileMap = new HashMap();
								HashMap resultMap = (HashMap) tmpFileList.get(i);
								fileMap.put("AtchFileId", AtchFileId);
								fileMap.put("FileSn", fileSn);
								fileMap.put("FilePath", resultMap.get(FileUtil.FILE_PATH));
								fileMap.put("FileRealNm", resultMap.get(FileUtil.UPLOAD_FILE_NM));
								fileMap.put("FileNm", resultMap.get(FileUtil.ORIGIN_FILE_NM));
								fileMap.put("FileExt", resultMap.get(FileUtil.FILE_EXT));
								fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
								fileList.add(fileMap);
								commonService.insert("zDLM_File_SQL.addFileDetail", fileMap);
								seqCnt++;
							}
						}



					} else  {
						String knoTypeCd = commonService.selectString("zDLM_KINFOM.getKnoTypeCd", cmmMap);
						String AtchFileId = StringUtil.checkNull(cmmMap.get("ATCH_FILE_ID"));
						cmmMap.put("AtchFileId", AtchFileId);
						cmmMap.put("knoTypeCd", knoTypeCd);
						cmmMap.put("GUBUN", "update");

						int seqCnt = 0;
						
						// Read Server File
						String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR
								+ StringUtil.checkNull(cmmMap.get("sessionUserId")) + "//";
						String targetPath = GlobalVal.FILE_UPLOAD_BOARD_DIR;
						List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
						
						if (tmpFileList != null) {
							for (int i = 0; i < tmpFileList.size(); i++) {
								String Seq = StringUtil
										.checkNull(commonService.selectString("zDLM_File_SQL.getFileSn", cmmMap), "");
								Map fileMap = new HashMap();
								HashMap resultMap = (HashMap) tmpFileList.get(i);
								fileMap.put("AtchFileId", AtchFileId);
								fileMap.put("FileSn", Seq);
								fileMap.put("FilePath", resultMap.get(FileUtil.FILE_PATH));
								fileMap.put("FileRealNm", resultMap.get(FileUtil.UPLOAD_FILE_NM));
								fileMap.put("FileNm", resultMap.get(FileUtil.ORIGIN_FILE_NM));
								fileMap.put("FileExt", resultMap.get(FileUtil.FILE_EXT));
								fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
								fileList.add(fileMap);
								commonService.insert("zDLM_File_SQL.addFileDetail", fileMap);
								seqCnt++;
							}
						}
						
						commonService.update("zDLM_KINFOM.updateKInfoM", cmmMap);

						// 임시 저장 디렉토리 삭제
						String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
						if (!path.equals("")) {
							FileUtil.deleteDirectory(path);
						}
					}

					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
																														// 성공
					target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID")
							+ "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove();");

				}

			} catch (Exception e) {
				System.out.println(e.toString());
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			}
			
			model.addAttribute(AJAX_RESULTMAP, target);
			model.put("BoardMgtID", BoardMgtID);

			return nextUrl(AJAXPAGE);
		}

		// 지식정보 상세조회
		@RequestMapping(value = "/zDlm_kInfoMDetail.do")
		public String knoDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {

			String url = "/custom/daelim/itsm/cc/zDlm_kInfoMDetail";

			try {
				// 임시저장된 파일이 존재할 수 있으므로 삭제
				String path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
				String templProjectID = StringUtil
						.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap), "");
				if (!path.equals("")) {
					FileUtil.deleteDirectory(path);
				}
				String BoardMgtID = StringUtil
						.replaceFilterString(StringUtil.checkNull(request.getParameter("BoardMgtID"), "1"));
				String currPage = StringUtil.checkNull(request.getParameter("currPage"), "1");
				String screenType = StringUtil
						.replaceFilterString(StringUtil.checkNull(request.getParameter("screenType"), ""));
				String boardUrl = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("url"), ""));
				String projectID = StringUtil
						.replaceFilterString(StringUtil.checkNull(request.getParameter("projectID"), ""));
				String category = StringUtil
						.replaceFilterString(StringUtil.checkNull(request.getParameter("category"), ""));
				String categoryIndex = StringUtil
						.replaceFilterString(StringUtil.checkNull(request.getParameter("categoryIndex"), ""));
				String categoryCnt = StringUtil
						.replaceFilterString(StringUtil.checkNull(request.getParameter("categoryCnt"), ""));

				String scStartDt = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("scStartDt")));
				String searchKey = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchKey")));
				String searchValue = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchValue")));
				String scEndDt = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("scEndDt")));

				String templProjectType = "";
				String projectType = StringUtil
						.replaceFilterString(StringUtil.checkNull(request.getParameter("projectType"), ""));
				String projectCategory = StringUtil
						.replaceFilterString(StringUtil.checkNull(request.getParameter("projectCategory"), ""));
				String projectIDs = StringUtil
						.replaceFilterString(StringUtil.checkNull(request.getParameter("projectIDs"), ""));
				String userId = StringUtil
						.replaceFilterString(StringUtil.checkNull(cmmMap.get("sessionLoginId"), ""));
				
				String searchOrg = StringUtil
						.replaceFilterString(StringUtil.checkNull(cmmMap.get("searchOrg"), ""));

				Map setMap = new HashMap();
				setMap.put("s_itemID", templProjectID);
				templProjectType = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectType", setMap),
						"");

				if (BoardMgtID != null) {
					setMap.put("BoardMgtID", BoardMgtID);
					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
					String boardMgtName = commonService.selectString("board_SQL.getBoardMgtName", setMap);
					String categoryYN = commonService.selectString("board_SQL.getBoardCategoryYN", setMap);
					model.put("boardMgtName", boardMgtName);
					model.put("CategoryYN", categoryYN);

				}
				Map result = commonService.select("zDLM_KINFOM.selectKnoDetail", cmmMap);

				String knoId = StringUtil.checkNull(result.get("knoId"));
				String userNm = StringUtil.checkNull(result.get("userNm"));
				String knoNm = StringUtil.checkNull(result.get("knoNm"));
				String knoCn = StringUtil.checkNull(result.get("knoCn"));
				String symtonDesc = StringUtil.checkNull(result.get("symtonDesc"));
				String RootCauseDesc = StringUtil.checkNull(result.get("RootCauseDesc"));
//				RootCauseDesc = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(RootCauseDesc));
//				RootCauseDesc = StringEscapeUtils.unescapeHtml4(RootCauseDesc);

				result.put("companyName",
						commonService.select("zDLM_KINFOM.selectKnoCorpAndService", result).get("companyName"));
				result.put("srarea2Name",
						commonService.select("zDLM_KINFOM.selectKnoCorpAndService", result).get("srarea2Name"));
				result.put("knoId", knoId);
				result.put("userNm", userNm);
				result.put("knoCn", knoCn);
				result.put("knoNm", knoNm);
				result.put("symtonDesc", symtonDesc);
				result.put("rootCauseDesc", RootCauseDesc);

				model.put("result", result);
				
				
				//매니저 여부 조회
				setMap = new HashMap();
				setMap.put("userId", userId);
				
				String isManagerValue =StringUtil.checkNull(commonService.selectString("zDLM_KINFOM.selectManagerAuth", setMap), "0");
				System.out.println(isManagerValue);
				model.put("isManager", isManagerValue != null ? isManagerValue.trim() : "0");
				
				// 첨부파일 조회
				model.put("itemFiles", (List) commonService.selectList("zDLM_File_SQL.getFilesFrom", result));
				model.put("menu", getLabel(request, commonService)); // Label Setting
				model.put(AJAX_RESULTMAP, result);
				
				// 0422 수정
				model.put("searchKey", searchKey);
				model.put("searchValue", searchValue);
				model.put("searchOrg", searchOrg);
			} catch (Exception e) {
				if (_log.isInfoEnabled()) {
					_log.info("BoardController::boardDetail::Error::" + e.toString().replaceAll("\r|\n", ""));
				}
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl(url);
		}

		@RequestMapping(value = "/zDlm_deleteKInfoM.do")
		public String deleteKInfoM(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
			Map target = new HashMap();
			String BoardMgtID = StringUtil
					.replaceFilterString(StringUtil.checkNull(request.getParameter("BoardMgtID"), "1"));
			
			String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");
			
			try {
				Map setMap = new HashMap();

				String userLoginId = StringUtil.checkNull(cmmMap.get("sessionLoginId"), "");
				String knoId = StringUtil.checkNull(cmmMap.get("knoId"), "").replaceAll("\\s+", "");
				
				setMap.put("knoId", knoId);

				String regUserID = StringUtil.checkNull(commonService.selectString("zDLM_KINFOM.getRegId", setMap));
				//if (userLoginId.equals(regUserID)) {
					cmmMap.put("GUBUN", "delete");
					commonService.delete("zDLM_KINFOM.deleteKInfoM", setMap);
					
					// 삭제 성공 메세지
					target.put(AJAX_ALERT, "삭제가 성공하였습니다.");
					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069")); 
					
					target.put(AJAX_SCRIPT, "parent.fnGoList('DTL','" + BoardMgtID + "','" + cmmMap.get("BoardMgtID")
							+ "','" + cmmMap.get("BoardID") + "','" + screenType + "');parent.$('#isSubmit').remove()");
				//}
			} catch (Exception e) {
				if (_log.isInfoEnabled()) {
					_log.info("BoardController::deleteKInfoM::Error::" + e.toString().replaceAll("\r|\n", ""));
				}
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
				target.put(AJAX_ALERT, "삭제중 오류가 발생하였습니다.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류
																													// 발생
			}
			model.addAttribute(AJAX_RESULTMAP, target);
			
			return nextUrl(AJAXPAGE);
		}
		
		// 산출물 수정 팝업
		@RequestMapping(value = "/zDLM_changeFile.do")
		public String mbrListByPhoneNo(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
			String url = "/custom/daelim/itsm/changeFilePop";
			try {
				Map setMap = new HashMap();
				String srID = StringUtil.checkNull(request.getParameter("srID"),"");
				String status = StringUtil.checkNull(request.getParameter("status"),"");
				String srType = StringUtil.checkNull(request.getParameter("srType"),"");
				String customerNo = StringUtil.checkNull(request.getParameter("customerNo"),"");
				String projectID = StringUtil.checkNull(request.getParameter("projectID"),"");
				
				setMap.put("srID", srID);
				setMap.put("languageID",  StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
				setMap.put("docCategory", "SR");
				setMap.put("speCode", status);
				setMap.put("srType", srType);
				
				String SRAT0004 = "";
				List<Map> srAttrList = commonService.selectList("esm_SQL.getSRAttr", setMap);
				Optional filter = srAttrList.stream().filter(e -> StringUtil.checkNull(e.get("AttrTypeCode")).equals("SRAT0004")).findFirst();
				if (filter.isPresent() == true) {
					Map map = (Map) filter.get();
					SRAT0004 = StringUtil.checkNull(map.get("LovCode"));
				}
				
				Map logInfo = commonService.select("esm_SQL.getESMProLogInfo_gridList", setMap);
				
				model.put("srID", srID);
				model.put("status", status);
				model.put("srType", srType);
				model.put("SRAT0004", SRAT0004);
				model.put("customerNo", customerNo);
				model.put("projectID",projectID);
				model.put("activityLogID", StringUtil.checkNull(logInfo.get("ActivityLogID")));
				
				//임시저장된 파일이 존재할 수 있으므로 삭제
				String path=GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
				if(!path.equals("")){FileUtil.deleteDirectory(path);}
			} catch (Exception e) {
				System.out.println(e.toString());
			}
			return nextUrl(url);
		}
		
		/*FAQ 상세팝업 관련 화면*/
		@RequestMapping(value = "/zDlm_mainBoardList.do")
		public String zDlm_mainBoardList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {

			String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"));
			String mainVersion = StringUtil.checkNull(request.getParameter("mainVersion"));
			String replyLev = StringUtil.checkNull(request.getParameter("replyLev"), "0");
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
			String listSize = StringUtil.checkNull(request.getParameter("listSize"), "5");
			String boardMgtType = StringUtil.checkNull(cmmMap.get("boardMgtType"));
			String templProjectID = StringUtil.checkNull(commonService.selectString("board_SQL.getTemplProjectID", cmmMap),
					"");
			String templCode = StringUtil.checkNull(cmmMap.get("sessionTemplCode"));
			String clientID = StringUtil.checkNull(cmmMap.get("sessionClientId"));
			
			Map setMap = new HashMap();
			setMap.put("s_itemID", templProjectID);
			String templProjectType = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectType", setMap),
					"");

			String url = "/custom/daelim/itsm/cc/brd/zDlm_mainBoardList";
			try {
				if ("2".equals(mainVersion)) {
					url = "/custom/daelim/itsm/cc/brd/zDlm_mainBoardList_v2";
				}
				if ("3".equals(mainVersion)) {
					url = "/custom/daelim/itsm/cc/brd/zDlm_mainBoardList_v3";
				}
				if ("4".equals(mainVersion)) {
					url = "/custom/daelim/itsm/cc/brd/zDlm_mainBoardList_v4";
				}
				if ("5".equals(mainVersion)) {
					url = "/custom/daelim/itsm/cc/brd/zDlm_mainBoardList_v5";
				}

				Map setData = new HashMap();
				String parentID = "";
				String boardGrpID = "";
				if (boardMgtType.equals("Y")) { // boardMgtID가 Group 일경우
					boardGrpID = BoardMgtID;
					BoardMgtID = "";
					cmmMap.put("boardGrpID", boardGrpID);
				}
				cmmMap.put("BoardMgtID", BoardMgtID);
				cmmMap.put("viewType", "home");
				cmmMap.put("replyLev", replyLev);

				cmmMap.put("projectType", templProjectType);
				List brdList;
				if(templCode.equals("TMPL003")) {
					cmmMap.put("projectID", clientID);
					brdList = (List)commonService.selectList("zDLM_SQL.getFaqQnList_gridList", cmmMap);
				}else {
					brdList = (List)commonService.selectList("zDLM_SQL.getFaqQnList_gridList", cmmMap);
				}
				
				String isView = "0";
				if (brdList != null && brdList.size() > 0) {
					isView = "1";
				}
				model.put("brdList", brdList);
				model.put("isView", isView);
				model.put("boardMgtID", BoardMgtID);
				model.put("listSize", listSize);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
			} catch (Exception e) {
				System.out.println(e);
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl(url);
		}
		
		@RequestMapping(value = "/zDlm_boardDetailPop.do")
		public String zDlm_boardDetailPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
			String noticType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("noticType"), "1"));
			try {
				String BoardMgtID = StringUtil.checkNull(request.getParameter("BoardMgtID"));
				// 조회수UPDATE
				commonService.update("zDLM_SQL.updateFaqInqireCo", cmmMap);
				Map result = commonService.select("zDLM_SQL.selectFaqListDetail", cmmMap);
				Map result2 = commonService.select("zDLM_SQL.selectFaqListDetailPop", result);
//				String boardMgtNM = StringUtil.checkNull(commonService.selectString("board_SQL.getBoardMgtName", cmmMap));
				
				Map mgtInfo = commonService.select("board_SQL.getBoardMgtInfo", cmmMap);
				String url = StringUtil.checkNull(mgtInfo.get("Url"));
//				if ("forumMgt".equals(url) ){
//					Map boardMap = new HashMap();
//					Map setMap = new HashMap();
	//
//					setMap.put("boardID", cmmMap.get("BoardID"));
//					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
//					setMap.put("sessionUserId", cmmMap.get("sessionUserId"));
//					boardMap = commonService.select("forum_SQL.getForumEditInfo", setMap);
	//
//					if (boardMap != null && !boardMap.isEmpty()) {
//						result.put("ItemID", boardMap.get("ItemID"));
//						result.put("Path", boardMap.get("Path"));
//						result.put("ChangeSetID", boardMap.get("BrdChangeSetID"));
//					}
//				}

				String subject = StringUtil.checkNull(result2.get("QESTN_SJ"));
				subject = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(subject));
				subject = StringEscapeUtils.unescapeHtml4(subject);

				String content = StringUtil.checkNull(result2.get("QESTN_CN"));
				content = StringUtil.replaceFilterString(StringEscapeUtils.escapeHtml4(content));
				content = StringEscapeUtils.unescapeHtml4(content);

				result2.put("QESTN_SJ", subject);
				result2.put("QESTN_CN", content);

				model.put("itemFiles", (List) commonService.selectList("zDLM_File_SQL.getFilesFrom", result2));
				model.put(AJAX_RESULTMAP, result2);
				model.put("noticType", noticType);
				model.put("boardMgtID", BoardMgtID);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
			} catch (Exception e) {
				System.out.println(e);
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl("/custom/daelim/itsm/cc/brd/zDlm_boardDetailPop");
		}
		
		@RequestMapping(value="/zDlm_kinfoMFileDownload.do")
		public String kinfoMFileDownload( HttpServletRequest request, HttpServletResponse response, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
			Map target = new HashMap();
			Map setMap = new HashMap();
			Map setData = new HashMap();
			
			
			String reqOrgiFileName[] = request.getParameter("seq").split(",");//StringUtil.checkNull(request.getParameter("originalFileName")).split(",");
			String reqSysFileName[] = request.getParameter("seq").split(",");//StringUtil.checkNull(request.getParameter("sysFileName")).split(",");
			String reqFilePath[] = request.getParameter("seq").split(",");
			String reqSeq[] = request.getParameter("seq").split(",");
			String reqComment[] = request.getParameter("seq").split(",");
			
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
			String returnValue = "";
			
			Map knoDetail = commonService.select("zDLM_KINFOM.selectKnoDetail", cmmMap);
			setData.put("AtchFileId",knoDetail.get("ATCH_FILE_ID"));

			for(int i=0; reqSeq.length>i; i++){
				setData.put("seq", reqSeq[i]);
				if(scrnType.equals("BRD")){
					reqFilePath[i] = commonService.selectString("zDLM_File_SQL.getFilePath", setData);
					reqOrgiFileName[i] = commonService.selectString("zDLM_File_SQL.getFileName", setData);
					reqSysFileName[i] = reqFilePath[i] + commonService.selectString("zDLM_File_SQL.getFileSysName", setData);
				}
			}
			
			File orgiFileName = null;
			File sysFileName = null;
			String filePath = null;
			String viewName = null;
			String useFileLog = StringUtil.checkNull(GlobalVal.USE_FILE_LOG);
			String DRMFileDir = StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH) + StringUtil.checkNull(cmmMap.get("sessionUserId"))+"//";
			try{
				int fileCnt = reqOrgiFileName.length;
				if(fileCnt==1){
					Map mapValue = new HashMap();
					List getList = new ArrayList();
					
					mapValue.put("AtchFileId",knoDetail.get("ATCH_FILE_ID"));
					mapValue.put("seq", reqSeq[0]);
					Map result  = new HashMap();
					if(scrnType.equals("BRD")){
						
						result=commonService.select("zDLM_File_SQL.selectDownFile",mapValue);
						filePath = GlobalVal.FILE_UPLOAD_BOARD_DIR;			
					}
					
					String filename = StringUtil.checkNull(result.get("filename"));
					String original = StringUtil.checkNull(result.get("original"));
					String downFile = StringUtil.checkNull(result.get("downFile"));
					if (!new File(downFile).exists()) {					 
						 //target.put(AJAX_ALERT, "해당 파일 [ "+original+" ] 을 서버에서 찾을 수 없습니다");
						 target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00078", new String[]{original}));
						 target.put(AJAX_SCRIPT,  "setSubFrame();");
						 target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
						 // target.put(AJAX_NEXTPAGE, "jsp/file/fileGrpList.jsp");
						 model.addAttribute(AJAX_RESULTMAP, target);
						 System.out.println("===========================파일 다운로드 정상 종료=============================================");
						 return nextUrl(AJAXPAGE);
					}
					
					if(downFile == null || downFile.equals("")) downFile = FileUtil.FILE_UPLOAD_DIR + filename;
					if(filePath == null || filePath.equals("")) filePath = downFile.replace(filename, "");
					
					
					if ("".equals(filename)) {
						request.setAttribute("message", "File not found.");
						return "cmm/utl/EgovFileDown";
					}

					if ("".equals(original)) {
						original = filename;
					}
					setMap = new HashMap();
					setMap.put("Seq",reqSeq[0]);
					
					// 각 파일 테이블의 [DownCNT] update
					if(scrnType.equals("BRD")){
						setMap.put("TableName", "COMTNFILEDETAIL");
					}
					

					HashMap drmInfoMap = new HashMap();
					
					String userID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
					String userName = StringUtil.checkNull(cmmMap.get("sessionUserNm"));
					String teamID = StringUtil.checkNull(cmmMap.get("sessionTeamId"));
					String teamName = StringUtil.checkNull(cmmMap.get("sessionTeamName"));
					
					drmInfoMap.put("userID", userID);
					drmInfoMap.put("userName", userName);
					drmInfoMap.put("teamID", teamID);
					drmInfoMap.put("teamName", teamName);
					drmInfoMap.put("orgFileName", original);
					drmInfoMap.put("downFile", downFile);
					drmInfoMap.put("loginID", cmmMap.get("sessionLoginId"));
					drmInfoMap.put("sessionEmail", cmmMap.get("sessionEmail"));
					
					// file DRM 적용
					String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
					String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
					if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
						
						drmInfoMap.put("ORGFileDir", filePath); // C://OLMFILE//document//
						drmInfoMap.put("DRMFileDir",DRMFileDir);
						drmInfoMap.put("Filename", filename);
						drmInfoMap.put("funcType", "download");
						returnValue = DRMUtil.drmMgt(drmInfoMap); // 암호화 
					}
					
					if(!"".equals(returnValue)) {
						downFile = returnValue;
					}
					
					request.setAttribute("downFile", downFile);
					request.setAttribute("orginFile", original);

					FileUtil.flMgtdownFile(request, response);
					
					 
				}else{
					
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
					
					 for(int i=0; i<reqOrgiFileName.length; i++){
						returnValue = "";
						orgiFileName = new File(reqOrgiFileName[i]);
						sysFileName = new File(reqSysFileName[i]);
						
						drmInfoMap.put("orgFileName", reqOrgiFileName[i]);
						drmInfoMap.put("downFile", reqSysFileName[i].replace(reqFilePath[i], ""));
											
						String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
						String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
						if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
							drmInfoMap.put("ORGFileDir", reqFilePath[i]);
							drmInfoMap.put("DRMFileDir", DRMFileDir);
							drmInfoMap.put("Filename", reqSysFileName[i].replace(reqFilePath[i], ""));
							drmInfoMap.put("funcType", "download");
							returnValue = DRMUtil.drmMgt(drmInfoMap); // 암호화 
						}
						
						if(!sysFileName.exists()){
							viewName = orgiFileName.getName();
							// 파일이 없을경우 변경했던 파일명 원복 
							for(int k=0; k<reqOrgiFileName.length; k++){
									orgiFileName = new File(reqOrgiFileName[k]);
									sysFileName = new File(reqSysFileName[k]);
									orgiFileName.renameTo(sysFileName);
							 }
							target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00078", new String[]{viewName}));
							model.addAttribute(AJAX_RESULTMAP, target);
						
							return nextUrl(AJAXPAGE);
						}
						
						System.out.println("===========================return value 전=============================================");
						
						if(!"".equals(returnValue)) {
							sysFileName = new File(returnValue);
							reqOrgiFileName[i] = returnValue;
							reqFilePath[i] = DRMFileDir;
						}
						
						if(sysFileName.exists()){
							
							sysFileName.renameTo(orgiFileName);
						}
						

					 }
					 
					 // zip file명 만들기 
					 Calendar cal = Calendar.getInstance();
					 java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
					 java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("HHmmssSSS");
					 String sdate = sdf.format(cal.getTime());
					 String stime = sdf2.format(cal.getTime());
					 String mkFileNm = sdate+stime;
					 
					 String path = GlobalVal.FILE_UPLOAD_ZIPFILE_DIR;
					 String fullPath = GlobalVal.FILE_UPLOAD_ZIPFILE_DIR+"downFiles"+sdf2+".zip";
					 String newFileNm = "FILE_"+mkFileNm+".zip";
					 
					 File zipFile = new File(fullPath); 
					 File dirFile = new File(path);
				  
					 if(!dirFile.exists()) {
					     dirFile.mkdirs();
					 } 
		
					 ZipOutputStream zos = null;
					 FileOutputStream os = null;
					 
					 try {
						 os = new FileOutputStream(zipFile);
						 zos = new ZipOutputStream(os);
						 byte[] buffer = new byte[1024 * 2];
						 int k = 0;
						 for(String file : reqOrgiFileName) {
							 filePath = reqFilePath[k];
							 if(new File(file).isDirectory()) { continue; }
					                
					         BufferedInputStream bis = null;
					         FileInputStream is = null;
					         try {
					        	 is = new FileInputStream (file);
					        	 bis = new BufferedInputStream(is);
					        	 file = file.replace(filePath, ""); 
						         
						         zos.putNextEntry(new ZipEntry(file));
						        			         
						         int length = 0;
						         while((length = bis.read(buffer)) != -1) {
						            zos.write(buffer, 0, length);
						         }
						         
					         } catch ( Exception e ) {
								 System.out.println(e.toString());
								 throw e;
							 } finally {
								 zos.closeEntry();
						         bis.close();
						         is.close();
						         k++;
							 }				         
						 }
						 
					 } catch ( Exception e ) {
						 System.out.println(e.toString());
						 throw e;
					 } finally {
						 zos.closeEntry();
			             zos.close();
						 os.close();
					 }
				
		       
					// 파일이름 원복
					for(int i=0; i<reqOrgiFileName.length; i++){
						setMap = new HashMap();
						orgiFileName = new File(reqOrgiFileName[i]);
						sysFileName = new File(reqSysFileName[i]);
						
						if(orgiFileName.exists()){
							orgiFileName.renameTo(sysFileName);
						}
						
						setMap.put("Seq",reqSeq[i]);

					}
					String downFile = fullPath;
					request.setAttribute("downFile", downFile);
					request.setAttribute("orginFile", newFileNm);
					FileUtil.flMgtdownFile(request, response);
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00079"));
				target.put(AJAX_SCRIPT, "doSearchList();");
				
			}catch (Exception e) {
				 System.out.println(e);
				 throw new ExceptionUtil(e.toString());
			}
			return nextUrl(AJAXPAGE);
		}
}
