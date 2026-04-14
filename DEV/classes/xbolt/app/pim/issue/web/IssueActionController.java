package xbolt.app.pim.issue.web;

import java.io.File;
import java.net.URL;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.xml.namespace.QName;
import javax.xml.rpc.Call;
import javax.xml.rpc.ParameterMode;
import javax.xml.rpc.Service;
import javax.xml.rpc.ServiceFactory;

import org.apache.axis.description.ParameterDesc;
import org.eclipse.jdt.internal.compiler.lookup.InferenceContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

/**
 * 업무 처리
 * 
 * @Class Name : IssueActionController.java
 * @Description : 업무화면을 제공한다.
 * @Modification Information
 * @수정일 수정자 수정내용
 * @--------- --------- -------------------------------
 * @2012. 09. 01. smartfactory 최초생성
 * 
 * @since 2012. 09. 01.
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")
public class IssueActionController extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "issueService")
	private CommonService issueService;

	@RequestMapping(value = "/issueSearchList.do")
	public String issueSearchList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		String url = "project/issue/issueSearchList";
		Map setMap = new HashMap();

		try {
			
			String issueMode = StringUtil.checkNull(request.getParameter("issueMode"));
			String parentId = StringUtil.checkNull(request.getParameter("ParentID"));
			String creator = StringUtil.checkNull(request.getParameter("Creator"));
			String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			
			// 변경 오더 화면으로 부터 천이
			if (issueMode.equals("CSR") || issueMode.equals("PjtMgt")) {
				// default 프로젝트 값 취득
				setMap.put("ProjectType", "PJT");
				setMap.put("ProjectID", parentId);
				Map projectInfo = commonService.select("project_SQL.getParentPjtList", setMap);
				model.put("parentId", parentId);
				model.put("parentName", projectInfo.get("NAME"));
				model.put("parentSts", projectInfo.get("Status"));
				
				if (issueMode.equals("CSR")) {
					// default 변경오더 값
					setMap.put("ProjectType", "CSR");
					setMap.put("ProjectID", projectID);
					Map csrInfo = commonService.select("project_SQL.getParentPjtList", setMap);
					model.put("csrName", csrInfo.get("NAME"));
				}
				setMap.remove("ProjectID");
				setMap.put("ParentID", parentId);
			}
			
			// 변경오더 리스트
			setMap.put("ProjectType", "CSR");
			List csrList = commonService.selectList("project_SQL.getParentPjtList", setMap);
			
			// 프로젝트 리스트
			setMap.put("csrIds", setCsrIds(csrList));
			List parentPjtList = commonService.selectList("project_SQL.getParentPjtOfCsr", setMap);
			
			// 유형
			setMap.put("Deactivated", 0);
			List itemTypeList = commonService.selectList("item_SQL.getSearchItemTypeCode", setMap);
			
			// 담당자 리스트 : 요청자, 접수자, 처리자
			setMap.put("RoleName", "Requestor");
			List memberList = commonService.selectList("issue_SQL.getIssueMemberList", setMap);
			model.put("Requestor", memberList);
			setMap.put("RoleName", "Receiver");
			memberList = commonService.selectList("issue_SQL.getIssueMemberList", setMap);
			model.put("Receiver", memberList);
			setMap.put("RoleName", "Actor");
			memberList = commonService.selectList("issue_SQL.getIssueMemberList", setMap);
			model.put("Actor", memberList);
			
			// 처리조직 리스트
			List actTeamList = commonService.selectList("issue_SQL.getIssueActTeamList", setMap);
			
			// 등록 가능자 인지 판단
			setMap.put("loginUserId", commandMap.get("sessionUserId"));
			List parentPjtListFromRel = commonService.selectList("project_SQL.getParentPjtFromRel", setMap);
			
			model.put("parentPjtList", parentPjtList);
			model.put("csrList", csrList);
			model.put("itemTypeList", itemTypeList);
			model.put("actTeamList", actTeamList);
			model.put("pjtRelCnt", parentPjtListFromRel.size());
			model.put("csrCnt", csrList.size());
			model.put("issueMode", issueMode);
			
			model.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			model.put("Creator", creator);
			model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID")));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			
			// Tree >> ITEM >> [개요] >> [변경 이력]
			model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
			model.put("currPageI", StringUtil.checkNull(request.getParameter("currPageI"), "1"));
			
			model.put("screenType", screenType);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl(url);
	}
	
	
	/**
	 * [Issue 등록, 편집]:신규 or 편집
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addNewIssue.do")
	public String addNewIssue(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "project/issue/addNewIssue";
		Map setMap = new HashMap();
		Map getMap = new HashMap();
		List attachFileList = new ArrayList();
		
		try {
			String issueId = StringUtil.checkNull(request.getParameter("issueId"));
			String isIssueEdit = StringUtil.checkNull(request.getParameter("isIssueEdit"));
			String parentId = StringUtil.checkNull(request.getParameter("ParentID"));
			String issueMode = StringUtil.checkNull(request.getParameter("issueMode"));
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
			if (!issueId.isEmpty()) {
				// Issue 편집 화면 일때
				setMap.put("IssueID", issueId);
				getMap = commonService.select("issue_SQL.getIssueInfo_gridList", setMap);
				
				/* 첨부문서 취득 */
				attachFileList = commonService.selectList("issue_SQL.getIssueFileList", setMap);
			}

			// 유형
			setMap.put("Deactivated", 0);
			List itemTypeList = commonService.selectList("item_SQL.getSearchItemTypeCode", setMap);
			
			// 프로젝트 리스트
			setMap.put("Status", "CLS");
			setMap.put("CsrCount", "check");
			setMap.put("loginUserId", commandMap.get("sessionUserId"));
			if (issueMode.equals("PjtMgt")) {
				setMap.put("ProjectID", parentId);
			}
			List parentPjtList = commonService.selectList("project_SQL.getParentPjtFromRel", setMap);
			
			// 변경오더 리스트
			setMap.put("ProjectType", "CSR");
			List csrList = commonService.selectList("project_SQL.getParentPjtList", setMap);
			
			/* 임시 문서 보관 디렉토리 삭제 */
			String path = GlobalVal.FILE_UPLOAD_BASE_DIR + commandMap.get("sessionUserId");
			FileUtil.deleteDirectory(path);
			
			/* 시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			
			model.put("getMap", getMap); 
			model.put("issueFiles", attachFileList);
			model.put("issueFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
			model.put("itemTypeList", itemTypeList); 
			model.put("projectList", parentPjtList); 
			model.put("csrList", csrList); 
			model.put("isIssueEdit", isIssueEdit); 
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("issueMode", issueMode);
			model.put("currPageI", StringUtil.checkNull(request.getParameter("currPageI"), "1"));
			model.put("thisYmd", thisYmd);
			model.put("ParentID", parentId);
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType"), ""));
			model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID"), ""));

		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
	
	
	/**
	 * Issue Info [Insert]
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveNewIssue.do")
	public String saveNewIssue(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		try {

			for (Iterator i =  commandMap.entrySet().iterator(); i.hasNext();) {
			    Entry e = (Entry) i.next(); // not allowed
			    if(!e.getKey().equals("loginInfo") && e.getValue() != null) {
			    	 commandMap.put(e.getKey(), xss.stripXSS(e.getValue().toString()));
			    }
			}
			HashMap setData = new HashMap();
			HashMap insertData = new HashMap();
			HashMap updateData = new HashMap();
			String maxIssueId = "";
			
			String isIssueEdit = StringUtil.checkNull(xss.getParameter("isIssueEdit"));
			String csrId = StringUtil.checkNull(xss.getParameter("CsrList"));
			String projectID = StringUtil.checkNull(xss.getParameter("Project"));

			// get Parent Project Info
			setData.put("ProjectID", projectID);
			Map parentInfoMap = commonService.select("project_SQL.getParentPjtInfo", setData);
			
			if ("Y".equals(isIssueEdit)) {
				/* Issue 편집 */
				maxIssueId = StringUtil.checkNull(xss.getParameter("IssueID"));
				updateData.put("IssueID", maxIssueId);
				updateData.put("IssueCode", setIssueCode(parentInfoMap));
				updateData.put("ProjectID", projectID);
				updateData.put("CSRID", csrId);
				updateData.put("ItemTypeCode", StringUtil.checkNull(xss.getParameter("ItemType")));
				updateData.put("Subject", StringUtil.checkNull(xss.getParameter("Subject")));
				updateData.put("Content", StringUtil.checkNull(xss.getParameter("Description")));
				updateData.put("Status", "01"); // 상태:등록 (01)
				updateData.put("ReqDueDate", StringUtil.checkNull(xss.getParameter("ReqDueDate")));
				// 선택된 CSR의 생성자 정보 취득
				setData.put("CSRID", csrId);
				Map creatorInfoMap = commonService.select("issue_SQL.getCsrCreator", setData);
				updateData.put("Receiver", creatorInfoMap.get("Creator"));
				updateData.put("RecTeamID", creatorInfoMap.get("TeamID"));
				
				updateData.put("LastUser", commandMap.get("sessionUserId"));
				commonService.update("issue_SQL.updateIssue", updateData);
				
				/* Issue 첨부파일 등록 : TB_ISSUE_FILE */
				insertIssueFiles(commandMap, maxIssueId);
			} else {
				/* Issue 신규 등록 */
				maxIssueId = commonService.selectString("issue_SQL.getMaxIssueID", setData);
				insertData.put("IssueID", maxIssueId);
				insertData.put("IssueCode", setIssueCode(parentInfoMap));
				insertData.put("ProjectID", projectID);
				insertData.put("CSRID", csrId);
				insertData.put("ItemTypeCode", StringUtil.checkNull(xss.getParameter("ItemType")));
				insertData.put("Subject", StringUtil.checkNull(xss.getParameter("Subject")));
				insertData.put("Content", StringUtil.checkNull(xss.getParameter("Description")));
				insertData.put("Status", "01"); // 상태:등록 (01)
				insertData.put("Requestor", commandMap.get("sessionUserId"));
				insertData.put("ReqTeamID", commandMap.get("sessionTeamId"));
				insertData.put("ReqDueDate", StringUtil.checkNull(xss.getParameter("ReqDueDate")));
				// 선택된 CSR의 생성자 정보 취득
				setData.put("CSRID", csrId);
				Map creatorInfoMap = commonService.select("issue_SQL.getCsrCreator", setData);
				insertData.put("Receiver", creatorInfoMap.get("Creator"));
				insertData.put("RecTeamID", creatorInfoMap.get("TeamID"));
				
				insertData.put("LastUser", commandMap.get("sessionUserId"));
				commonService.insert("issue_SQL.createIssue", insertData);
				
				/* Issue 첨부파일 등록 : TB_ISSUE_FILE */
				insertIssueFiles(commandMap, maxIssueId);
			}
			
			model.put("screenType", StringUtil.checkNull(xss.getParameter("screenType")));
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.goBack('" + maxIssueId + "');parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * Insert To TB_ISSUE_FILE
	 * @param commandMap
	 * @param issueId
	 * @throws Exception
	 */
	private void insertIssueFiles(HashMap commandMap, String issueId) throws Exception {
		Map fileMap  = new HashMap();
		List fileList = new ArrayList();

		int seqCnt = Integer.parseInt(commonService.selectString("issue_SQL.issueFile_nextVal", commandMap));
		//Read Server File
		String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(commandMap.get("sessionUserId"))+"//";
		String filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR;
		String targetPath = filePath;
		List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
		if(tmpFileList.size() != 0){
			for(int i=0; i<tmpFileList.size();i++){
				fileMap = new HashMap(); 
				HashMap resultMap = (HashMap)tmpFileList.get(i);
				fileMap.put("Seq", seqCnt);
				fileMap.put("IssueID", issueId);
				fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
				fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
				fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
				fileMap.put("FilePath", filePath);
				fileMap.put("FileMgt", "ISSUE");
				fileMap.put("userId", commandMap.get("sessionUserId"));
				fileMap.put("RegMemberID", commandMap.get("sessionUserId"));
				fileMap.put("LastUser", commandMap.get("sessionUserId"));
				fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
				
				fileMap.put("KBN", "insert");
				fileMap.put("SQLNAME", "issue_SQL.issueFile_insert");					
				fileList.add(fileMap);
				seqCnt++;
			}
		}
		
		if(fileList.size() != 0){
			issueService.save(fileList, fileMap);
		}
	}
	
	/**
	 * [Issue detail]:상세
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/issueInfoDetail.do")
	public String issueInfoDetail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "project/issue/issueInfoDetail";
		Map setMap = new HashMap();
		Map getMap = new HashMap();
		List attachFileList = new ArrayList();
		
		try {
			String issueId = StringUtil.checkNull(request.getParameter("issueId"));
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
			setMap.put("IssueID", issueId);
			getMap = commonService.select("issue_SQL.getIssueInfo_gridList", setMap);
			
			/* 첨부문서 취득 */
			attachFileList = commonService.selectList("issue_SQL.getIssueFileList", setMap);
			
			model.put("getMap", getMap); 
			model.put("issueFiles", attachFileList);
			model.put("issueFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("issueMode", StringUtil.checkNull(request.getParameter("issueMode")));
			
			model.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			model.put("Creator", StringUtil.checkNull(request.getParameter("Creator")));
			model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID")));
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			
			// Tree >> ITEM >> [개요] >> [변경 이력]
			model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
			model.put("currPageI", StringUtil.checkNull(request.getParameter("currPageI"), "1"));
			
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType"), ""));

		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
	
	/**
	 * 업로드된 issue 파일을 삭제
	 * @param cmmMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/issueFileDelete.do")
	public String issueFileDelete(HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();		
		
		try {
			
			String realFile = StringUtil.checkNull(commandMap.get("realFile"));
			File existFile = new File(realFile);
			if(existFile.exists() && existFile.isFile()){existFile.delete();}
			commonService.delete("issue_SQL.delIssueFile", commandMap);	
				
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00075")); // 성공
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00076")); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * [Issue 접수]
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/receiveIssue.do")
	public String receiveIssue(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "project/issue/receiveIssue";
		Map setMap = new HashMap();
		Map getMap = new HashMap();
		List attachFileList = new ArrayList();
		
		try {
			String issueId = StringUtil.checkNull(request.getParameter("issueId"));
			String isIssueEdit = StringUtil.checkNull(request.getParameter("isIssueEdit"));
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
			// Issue 편집 화면 일때
			setMap.put("IssueID", issueId);
			getMap = commonService.select("issue_SQL.getIssueInfo_gridList", setMap);
			
			/* 첨부문서 취득 */
			attachFileList = commonService.selectList("issue_SQL.getIssueFileList", setMap);

			// 유형
			setMap.put("Deactivated", 0);
			List itemTypeList = commonService.selectList("item_SQL.getSearchItemTypeCode", setMap);
			
			// 변경오더 리스트
			setMap.put("Status", "CLS");
			setMap.put("ProjectType", "CSR");
			setMap.put("Creator", getMap.get("Receiver"));
			List csrList = commonService.selectList("project_SQL.getParentPjtList", setMap);
			
			// 프로젝트 리스트
			setMap.put("csrIds", setCsrIds(csrList));
			List parentPjtList = commonService.selectList("project_SQL.getParentPjtOfCsr", setMap);
			
			/* 임시 문서 보관 디렉토리 삭제 */
			String path = GlobalVal.FILE_UPLOAD_BASE_DIR + commandMap.get("sessionUserId");
			FileUtil.deleteDirectory(path);
			
			/* 시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

			model.put("thisYmd", thisYmd);
			model.put("getMap", getMap); 
			model.put("issueFiles", attachFileList);
			model.put("issueFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
			model.put("itemTypeList", itemTypeList); 
			model.put("projectList", parentPjtList); 
			//model.put("csrList", csrList); 
			model.put("isIssueEdit", isIssueEdit); 
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("issueMode", StringUtil.checkNull(request.getParameter("issueMode")));
			model.put("currPageI", StringUtil.checkNull(request.getParameter("currPageI"), "1"));
			model.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));

		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/getActorListOption.do")
	public String getClassCodeOption(HttpServletRequest request, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		setMap.put("CsrID", StringUtil.checkNull(request.getParameter("CsrID")));
		model.put(AJAX_RESULTMAP, commonService.selectList("issue_SQL.getActorList", setMap));
		return nextUrl(AJAXPAGE_SELECTOPTION);
	}
	
	/**
	 * Issue receive [update]
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveReceiveInfo.do")
	public String saveReceiveInfo(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		try {

			for (Iterator i = commandMap.entrySet().iterator(); i.hasNext();) {
			    Entry e = (Entry) i.next(); // not allowed
			    if(!e.getKey().equals("loginInfo") && e.getValue() != null) {
			    	commandMap.put(e.getKey(), xss.stripXSS(e.getValue().toString()));
			    }
			}
			HashMap setData = new HashMap();
			HashMap updateData = new HashMap();
			String maxIssueId = "";
			
			String csrId = StringUtil.checkNull(xss.getParameter("CsrList"));
			String projectID = StringUtil.checkNull(xss.getParameter("Project"));
			
			// get Parent Project Info
			setData.put("ProjectID", projectID);
			Map parentInfoMap = commonService.select("project_SQL.getParentPjtInfo", setData);

			/* Issue 편집 */
			maxIssueId = StringUtil.checkNull(xss.getParameter("IssueID"));
			updateData.put("IssueID", maxIssueId);
			updateData.put("IssueCode", setIssueCode(parentInfoMap));
			updateData.put("ProjectID", projectID);
			updateData.put("CSRID", csrId);
			updateData.put("ItemTypeCode", StringUtil.checkNull(xss.getParameter("ItemType")));
			updateData.put("DueDate", StringUtil.checkNull(xss.getParameter("DueDate")));
			updateData.put("Actor", StringUtil.checkNull(xss.getParameter("Actor")));
			// Actor 정보 취득
			setData.put("userId", StringUtil.checkNull(xss.getParameter("Actor")));
			Map actorInfoMap = commonService.select("project_SQL.getUserInfo", setData);
			updateData.put("ActTeamID", actorInfoMap.get("TeamID"));
			updateData.put("Priority", StringUtil.checkNull(xss.getParameter("Priority")));
			updateData.put("Response", StringUtil.checkNull(xss.getParameter("Response")));
			updateData.put("Status", "02"); // 상태:접수 (02)
			updateData.put("LastUser", commandMap.get("sessionUserId"));
			commonService.update("issue_SQL.updateIssue", updateData);
			
			/* Issue 첨부파일 등록 : TB_ISSUE_FILE */
			insertIssueFiles(commandMap, maxIssueId);
			model.put("screenType", StringUtil.checkNull(xss.getParameter("screenType")));
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.goDetail('" + maxIssueId + "');parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * [Issue 처리]
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/actionIssue.do")
	public String actionIssue(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "project/issue/actionIssue";
		Map setMap = new HashMap();
		Map getMap = new HashMap();
		List attachFileList = new ArrayList();
		
		try {
			String issueId = StringUtil.checkNull(request.getParameter("issueId"));
			String isIssueEdit = StringUtil.checkNull(request.getParameter("isIssueEdit"));
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
			// Issue 편집 화면 일때
			setMap.put("IssueID", issueId);
			getMap = commonService.select("issue_SQL.getIssueInfo_gridList", setMap);
			
			/* 첨부문서 취득 */
			attachFileList = commonService.selectList("issue_SQL.getIssueFileList", setMap);

			/* 임시 문서 보관 디렉토리 삭제 */
			String path = GlobalVal.FILE_UPLOAD_BASE_DIR + commandMap.get("sessionUserId");
			FileUtil.deleteDirectory(path);
			
			model.put("getMap", getMap); 
			model.put("issueFiles", attachFileList);
			model.put("issueFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
			model.put("isIssueEdit", isIssueEdit); 
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("issueMode", StringUtil.checkNull(request.getParameter("issueMode")));
			model.put("currPageI", StringUtil.checkNull(request.getParameter("currPageI"), "1"));
			model.put("ParentID", StringUtil.checkNull(request.getParameter("ParentID")));
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));

		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
	
	/**
	 * Issue action [update]
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveActionInfo.do")
	public String saveActionInfo(MultipartHttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		try {

			for (Iterator i = commandMap.entrySet().iterator(); i.hasNext();) {
			    Entry e = (Entry) i.next(); // not allowed
			    if(!e.getKey().equals("loginInfo") && e.getValue() != null) {
			    	commandMap.put(e.getKey(), xss.stripXSS(e.getValue().toString()));
			    }
			}
			HashMap setData = new HashMap();
			HashMap updateData = new HashMap();
			String maxIssueId = "";
			
			/* Issue 편집 */
			maxIssueId = StringUtil.checkNull(xss.getParameter("IssueID"));
			updateData.put("IssueID", maxIssueId);
			updateData.put("ActionDate", "systemDate");
			updateData.put("Result", StringUtil.checkNull(xss.getParameter("Result")));
			updateData.put("Status", "03"); // 상태:처리 (03)
			updateData.put("LastUser", commandMap.get("sessionUserId"));
			commonService.update("issue_SQL.updateIssue", updateData);
			
			/* Issue 첨부파일 등록 : TB_ISSUE_FILE */
			insertIssueFiles(commandMap, maxIssueId);

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.goDetail('" + maxIssueId + "');parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * IssueCode 생성 ('Prefix'-0000X)
	 * 
	 * @param parentInfoMap
	 * @return
	 * @throws Exception
	 */
	private String setIssueCode(Map parentInfoMap) throws Exception {
		// parent Project의 Prefix취득
		HashMap setData = new HashMap();
		String result = "";
		String hyphen = "-";
		
		// parent Project의 Prefix 취득
		String prefix = (String) parentInfoMap.get("Prefix");
		// 같은 parent Project의 Project 중 Max ProjectCode를 취득
		setData.put("ProjectID", parentInfoMap.get("ProjectID"));
		String maxCode = StringUtil.checkNull(commonService.selectString("issue_SQL.getMaxIssueCode", setData));

		if (maxCode.isEmpty()) {
			result = prefix + hyphen + "00001";
		} else {
			maxCode = maxCode.substring(maxCode.length() - 5, maxCode.length());
			int curCode = Integer.parseInt(maxCode) + 1;
			result = prefix + hyphen + String.format("%05d", curCode);
		}

		return result;
	}
	
	/**
	 * csrList를 문자열로 return
	 * 
	 * @param parentInfoMap
	 * @return
	 * @throws Exception
	 */
	private String setCsrIds(List csrList) throws Exception {
		String csrIds = "-1";
		for (int i = 0; i < csrList.size(); i++) {
			Map map = (Map) csrList.get(i);
			String csrId = StringUtil.checkNull(map.get("CODE"));
			
			if (csrIds.isEmpty()) {
				csrIds = csrId;
			} else {
				csrIds = csrIds + "," + csrId;
			}
		}
		
		return csrIds;
	}
	
	@RequestMapping(value="/mainIssueList.do")
	public String mainIssueList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		try {
			String listSize = StringUtil.checkNull(request.getParameter("listSize"));
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
			cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			cmmMap.put("ProjectID", projectID);
			List issueList = (List)commonService.selectList("issue_SQL.getIssueInfo_gridList", cmmMap);
			
			model.put("issueList", issueList);
			model.put("listSize", listSize);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}		
		catch (Exception e) {System.out.println(e);throw new ExceptionUtil(e.toString());}		
		return nextUrl("/hom/main/mainIssueList");
	}
	
	@RequestMapping(value = "/mainIssueSearchMgt.do")
	public String forumMgt(HttpServletRequest request, ModelMap model) throws Exception {
		String projectID = StringUtil.checkNull(request.getParameter("projectID"));
		String param = "";
		if (!projectID.isEmpty()) {
			param = "ParentID=" + projectID + "&issueMode=PjtMgt";
		}
		model.put("param", param);
		
		model.put("menu", getLabel(request, commonService));
		return nextUrl("/hom/main/mainIssueSearchMgt");
	}
}
