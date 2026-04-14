package xbolt.file.web;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.text.StringEscapeUtils;
import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipOutputStream;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.org.json.JSONArray;
import com.org.json.JSONException;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.DrmGlobalVal;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.file.util.FileUploadUtil;

/**
 * 업무 처리
 * @Class Name : BizController.java
 * @Description : 업무화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2012. 09. 01. smartfactory		최초생성
 *
 * @since 2012. 09. 01.
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")

public class FileInfoMgtActionController  extends XboltController{
	
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;
	@Autowired
    private FileUploadUtil fileUploadUtil;
	
	@RequestMapping(value="/fileListV4.do")
	public String fileListV4(HttpServletRequest request, HttpServletResponse response, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		
		String url = "file/fileListV4";
		String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");	
		String DocumentID = StringUtil.checkNull(request.getParameter("DocumentID"), s_itemID);	
		String fileOption = StringUtil.checkNull(request.getParameter("fileOption"),"OLM");	
		String varFilter = StringUtil.checkNull(request.getParameter("varFilter"));
		Map fileMap = new HashMap();
		Map getData = new HashMap();
		
		try {

			// File 권한 체크
			fileMap.put("itemId", DocumentID);
			Map result  = fileMgtService.select("fileMgt_SQL.selectItemAuthorID",fileMap);
			model.put("selectedItemAuthorID", StringUtil.checkNull(result.get("AuthorID")));
			model.put("selectedItemBlocked", StringUtil.checkNull(result.get("Blocked")));
			model.put("selectedItemLockOwner", StringUtil.checkNull(result.get("LockOwner")));
			model.put("itemClassCode", StringUtil.checkNull(result.get("ClassCode")));
			model.put("selectedItemStatus", StringUtil.checkNull(result.get("Status")));
			model.put("docCategory", StringUtil.checkNull(request.getParameter("DocCategory")));
			
			// itemFileOption 체크 (itemId) - VIEWER
			String itemFileOption = fileMgtService.selectString("fileMgt_SQL.getFileOption",fileMap);
			model.put("itemFileOption", itemFileOption);
			
			// FileOption 체크 - OLM / ExtLink
			if(!"".equals(varFilter)){
				model.put("fileOption", varFilter);
			}else {
				model.put("fileOption", fileOption);
			}
			
			// myItem 체크
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			
			String csrEditable = StringUtil.checkNull(result.get("csrEditable"));
			if("Y".equals(csrEditable)) {
				myItem = "Y";
			}
			model.put("myItem", myItem);
						
			// 업로드 권한 체크 ( myItem이 Y인 경우만 가능 )
			getData.put("DocumentID", DocumentID);
			getData.put("s_itemID", DocumentID);
			String uploadYN = commonService.selectString("fileMgt_SQL.getFileUploadYN", fileMap);
			if(!"".equals(StringUtil.checkNull(request.getParameter("uploadYN")))){
				uploadYN = StringUtil.checkNull(request.getParameter("uploadYN"));
			}
			model.put("uploadYN", uploadYN);
			
			// file 관련 옵션
			model.put("frmType", request.getParameter("frmType"));
			model.put("itemBlocked", StringUtil.checkNull(result.get("Blocked"), "")); 
			model.put("backBtnYN", request.getParameter("backBtnYN"));
			
			// file List 를 위한 value
			String langFilter = StringUtil.checkNull(cmmMap.get("langFilter"));
			model.put("langFilter", langFilter);
			model.put("DocumentID", DocumentID);
			model.put("s_itemID", DocumentID);
			
			// Label setting
			model.put("menu", getLabel(request, commonService));
			
			// file upload를 위한 session 등록
			HttpSession session = request.getSession(true);
			String uploadToken = fileUploadUtil.makeFileUploadFolderToken(session);
			model.put("uploadToken", uploadToken);
			
			// USE_FILE_LOG
			String USE_FILE_LOG = StringUtil.checkNull(GlobalVal.USE_FILE_LOG);
			model.put("USE_FILE_LOG", USE_FILE_LOG);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl(url);
	}

	// 템플릿파일 count 조회
	@RequestMapping(value = "getFileTmpCount.do", method = RequestMethod.GET)
	@ResponseBody
	public void getFileTmpCount(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();
		
		String fileTmpCount = "";
		boolean success = false;
		
		try {
	        
			// parameter
			String docCategory = StringUtil.checkNull(request.getParameter("docCategory"), "");
			String itemClassCode = StringUtil.checkNull(request.getParameter("itemClassCode"), "");
			
			// parameter check
			if (itemClassCode.isEmpty() && "".equals(docCategory)) {
	             throw new IllegalArgumentException("DocumentID is required.");
	        }
			
			// search cxnItemIDList
			setMap.put("itemClassCode", itemClassCode);
			setMap.put("docCategory", docCategory);
			fileTmpCount = commonService.selectString("fileMgt_SQL.getFileTmpCnt",setMap);
			
			success = true;
			resultMap.put("data", fileTmpCount);
			
	        
        } catch (IllegalArgumentException e) {
        	// 400 Bad Request
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (DataAccessException e) {
        	// 500 Internal Server Error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (JSONException e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (Exception e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } finally {
        	resultMap.put("success", success);
        	try {
        		// send to json
        		response.getWriter().print(resultMap);
        	} catch (Exception e) {
        		System.err.println(e.getMessage());
        	}
        	
        }
	}
	
	@RequestMapping(value = "saveFileDesc.do", method = RequestMethod.POST)
	@ResponseBody
	public void saveFileDesc(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();
		
		boolean success = false;
		
		try {
	        
			// parameter
			String seq = StringUtil.checkNull(request.getParameter("seq"), "");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			String DocumentID = StringUtil.checkNull(request.getParameter("DocumentID"), "");
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"), "");
			String Description = StringUtil.checkNull(request.getParameter("Description"), "");
			String sessionUserID = StringUtil.checkNull(request.getParameter("sessionUserID"), "");
			
			// parameter check
			if (seq.isEmpty()) {
	             throw new IllegalArgumentException("seq is required.");
	        }
			
			setMap.put("Seq", seq);
			setMap.put("itemID", DocumentID);
			setMap.put("LanguageID", languageID);
			setMap.put("FltpCode", fltpCode);
			setMap.put("Description", Description);
			setMap.put("sessionUserId", sessionUserID);
			
			commonService.insert("fileMgt_SQL.itemFile_update",setMap);
			success = true;
	        
        } catch (IllegalArgumentException e) {
        	// 400 Bad Request
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (DataAccessException e) {
        	// 500 Internal Server Error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } catch (Exception e) {
        	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			resultMap.put("message", e.getMessage());
            System.err.println(e);
        } finally {
        	resultMap.put("success", success);
        	try {
        		// send to json
        		response.getWriter().print(resultMap);
        	} catch (Exception e) {
        		System.err.println(e.getMessage());
        	}
        	
        }
	}
	
	@RequestMapping(value="/goFileMgt.do")
	public String goFileMgt(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "file/fileMgt";
		String itemId = StringUtil.checkNull(request.getParameter("s_itemID"), "-1");
		String option  = StringUtil.checkNull(request.getParameter("option"), "-1");
		String varFilter  = StringUtil.checkNull(request.getParameter("varFilter"));
		String fileOption  = StringUtil.checkNull(request.getParameter("fileOption"),"OLM");
		try {
			model.put("DocumentID", itemId);
			model.put("option", option);
			//model.put("menu", getLabel(request, commonService));
			if(!"".equals(varFilter)){
				model.put("fileOption", varFilter);
				}else {
				model.put("fileOption", fileOption);
			}
			model.put("itemBlocked", StringUtil.checkNull(request.getParameter("itemBlocked"),""));
			model.put("backBtnYN", request.getParameter("backBtnYN"));
			model.put("langFilter", StringUtil.checkNull(request.getParameter("langFilter")));
		}
		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
			
		return nextUrl(url);
	}
	
	@RequestMapping(value="/goFileList.do")
	public String goFileList(HttpServletRequest request, HttpServletResponse response, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "file/fileList";
		String DocumentID = StringUtil.checkNull(request.getParameter("DocumentID"), "");	
		String fileOption = StringUtil.checkNull(request.getParameter("fileOption"),"OLM");	
		String varFilter = StringUtil.checkNull(request.getParameter("varFilter"));
		Map fileMap = new HashMap();
		Map getData = new HashMap();
		try {
			model.put("menu", getLabel(request, commonService));
			fileMap.put("itemId", DocumentID);
			Map result  = fileMgtService.select("fileMgt_SQL.selectItemAuthorID",fileMap);
			String itemFileOption = fileMgtService.selectString("fileMgt_SQL.getFileOption",fileMap);
			
			model.put("selectedItemAuthorID", StringUtil.checkNull(result.get("AuthorID")));
			model.put("selectedItemBlocked", StringUtil.checkNull(result.get("Blocked")));
			model.put("selectedItemLockOwner", StringUtil.checkNull(result.get("LockOwner")));
			model.put("itemClassCode", StringUtil.checkNull(result.get("ClassCode")));
			model.put("selectedItemStatus", StringUtil.checkNull(result.get("Status")));
			model.put("DocumentID", DocumentID);
			model.put("s_itemID", DocumentID);
		
			if(!"".equals(varFilter)){
			model.put("fileOption", varFilter);
			}else {
			model.put("fileOption", fileOption);
			}
			
			getData.put("DocumentID", DocumentID);
			getData.put("s_itemID", DocumentID);
			String page = StringUtil.checkNull(request.getParameter("page"), "1");
			String uploadYN = commonService.selectString("fileMgt_SQL.getFileUploadYN", fileMap);
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			model.put("myItem", myItem);
			
			fileMap.put("s_itemID", DocumentID);
			fileMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
			//List itemList = commonService.selectList("item_SQL.getCxnItemList", fileMap);
			fileMap.put("fromToItemID", DocumentID);
			List cxnItemIDList = commonService.selectList("item_SQL.getCxnItemIDList", fileMap);
			Map getMap = new HashMap();
			
			String rltdItemId = "";
			for(int i = 0; i < cxnItemIDList.size(); i++){
				getMap = (HashMap)cxnItemIDList.get(i);
				getMap.put("ItemID", getMap.get("ItemID"));
				if (i < cxnItemIDList.size() - 1) {
				   rltdItemId += StringUtil.checkNull(getMap.get("ItemID")) + ",";
				}else{
					rltdItemId += StringUtil.checkNull(getMap.get("ItemID")) ;
				}
			}
			// model.put("fileListYN", "Y");
			model.put("rltdItemId", rltdItemId);
			
			model.put("uploadYN", uploadYN);
			model.put("itemFileOption", itemFileOption);
			model.put("frmType", request.getParameter("frmType"));
			model.put("itemBlocked", StringUtil.checkNull(result.get("Blocked"), "")); 
			model.put("backBtnYN", request.getParameter("backBtnYN"));	
			
			String langFilter = StringUtil.checkNull(cmmMap.get("langFilter"));
			getData.put("languageID", cmmMap.get("sessionCurrLangType"));
			getData.put("langFilter", langFilter);
			
			getData.put("rltdItemId", rltdItemId);
			getData.put("isPublic", "N");
			getData.put("DocCategory", "ITM");
			getData.put("hideBlocked", "N");
			
			List fileList = commonService.selectList("fileMgt_SQL.getFile_gridList",getData);
			JSONArray gridData = new JSONArray(fileList);
			model.put("gridData", gridData);
			
			String defaultLangCode = commonService.selectString("common_SQL.languageCode", getData);
			model.put("defaultLangCode", defaultLangCode);
			getData.put("itemClassCode", StringUtil.checkNull(result.get("ClassCode")));
			String fileTmpCount = commonService.selectString("fileMgt_SQL.getFileTmpCnt",getData);
			model.put("fileTmpCount", fileTmpCount);
			
			// file upload를 위한 session 등록
			HttpSession session = request.getSession(true);
			String uploadToken = fileUploadUtil.makeFileUploadFolderToken(session);
			model.put("uploadToken", uploadToken);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/saveFileDetail.do")
	public String saveFileDetail(MultipartHttpServletRequest request,HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		Map target = new HashMap();
		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		
		for (Iterator i = cmmMap.entrySet().iterator(); i.hasNext();) {
		    Entry e = (Entry) i.next(); // not allowed
		    if(!e.getKey().equals("loginInfo") && e.getValue() != null) {
		    	cmmMap.put(e.getKey(), xss.stripXSS(e.getValue().toString()));
		    }
		}
		String Grp = StringUtil.checkNull(xss.getParameter("Grp"), "");
		String url = "file/fileGrpMgt";
		String fileSeq = StringUtil.checkNull(xss.getParameter("fileSeq"), "");
		String DocumentID = StringUtil.checkNull(xss.getParameter("DocumentID"), "");
		String fltpCode = StringUtil.checkNull(xss.getParameter("fltpCode"), "");
		String fileMgt = StringUtil.checkNull(xss.getParameter("fileMgt"), "");
		String linkType = StringUtil.checkNull(xss.getParameter("linkType"), "1");
		String userId = StringUtil.checkNull(xss.getParameter("userId"), "");
		String ID = StringUtil.checkNull(xss.getParameter("s_itemID"), "");
		
		List fileList = new ArrayList();
		Map fileMap = null;
		Map stusMap = new HashMap();
		try{
			String filePath = StringUtil.checkNull(fileMgtService.selectString("fileMgt_SQL.getFilePath",cmmMap));  			
			stusMap.put("itemId", DocumentID);
			Map result  = fileMgtService.select("fileMgt_SQL.selectItemAuthorID",stusMap);
			String Status = result.get("Status").toString();
			
			String itemFileOption = fileMgtService.selectString("fileMgt_SQL.getFileOption",stusMap);
						
			if("".equals(fileSeq)){ // 신규 등록
				
				Iterator fileNameIter = request.getFileNames();
				// String savePath = GlobalVal.FILE_UPLOAD_ITEM_DIR; // 폴더 바꾸기
				String savePath = filePath; // 폴더 바꾸기
				
				String fileName = "";
				int Seq = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", cmmMap));
				int seqCnt = 0;				
				while (fileNameIter.hasNext()) {
					   MultipartFile mFile = request.getFile((String)fileNameIter.next());
					   fileName = mFile.getName();
						
						if("VIEWER".equals(itemFileOption))
							filePath = "";
						
					   if (mFile.getSize() > 0) {						   
						   fileMap = new HashMap();
						   HashMap resultMap = FileUtil.uploadFile(mFile, savePath, true);
						   
						   fileMap.put("Seq", Seq);
						   fileMap.put("DocumentID", DocumentID);
						   fileMap.put("LinkType", linkType);
						   fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
						   fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
						   fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
						   fileMap.put("FilePath", resultMap.get(FileUtil.FILE_PATH));	
						   fileMap.put("FileFormat", resultMap.get(FileUtil.FILE_EXT));	
						   fileMap.put("FltpCode", fltpCode);
						   fileMap.put("FileMgt", fileMgt);
						   fileMap.put("userId", userId);
						   fileMap.put("projectID", StringUtil.checkNull(result.get("ProjectID")));
						   fileMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
						   fileMap.put("KBN", "insert");
						   fileMap.put("DocCategory", "ITM");
						   fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");
						
						   fileList.add(fileMap);
						   seqCnt++;
					   }
					}	
					fileMgtService.save(fileList, fileMap);
				
			}else{ // 파일 수정

				Iterator fileNameIter = request.getFileNames();
				String savePath = filePath;
				String fileName = "";
				int Seq = Integer.parseInt(fileSeq);
				int seqCnt = 0;
				
				while (fileNameIter.hasNext()) {
					   MultipartFile mFile = request.getFile((String)fileNameIter.next());
					   fileName = mFile.getName();
					   
					   if (mFile.getSize() > 0) {
						   
						   fileMap = new HashMap();
						   HashMap resultMap = FileUtil.uploadFile(mFile, savePath, true);
						   
						   if("VIEWER".equals(itemFileOption))
								fileMap.put("FilePath", "VIEWER");
						   
						   fileMap.put("Seq", fileSeq);
						   fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
						   fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
						   fileMap.put("fltpCode", fltpCode);
						   fileMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
						   fileMap.put("KBN", "update");
						   fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_update"); 
						   
						   fileList.add(fileMap);
						   seqCnt++;
					   }
					}	
					fileMgtService.save(fileList, fileMap);
				
			}
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT,  "parent.fnGoList();");
			
		}catch (Exception e) {
				System.out.println(e);
				throw new ExceptionUtil(e.toString());
			}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/fileDownload.do")
	public String fileDownload( HttpServletRequest request, HttpServletResponse response, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		
		String alertType =  StringUtil.checkNull(request.getParameter("alertType"), "");
		
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

		for(int i=0; reqSeq.length>i; i++){
			setData.put("seq", reqSeq[i]);
			if(scrnType.equals("BRD")){
				reqFilePath[i] = commonService.selectString("boardFile_SQL.getFilePath", setData);
				reqOrgiFileName[i] = commonService.selectString("boardFile_SQL.getFileName", setData);
				reqSysFileName[i] = reqFilePath[i] + commonService.selectString("boardFile_SQL.getFileSysName", setData);
			}else if(scrnType.equals("INST")){
				setData.put("fileID", reqSeq[i]);
				reqFilePath[i] = commonService.selectString("instanceFile_SQL.getInstanceFilePath", setData);
				reqOrgiFileName[i] = commonService.selectString("instanceFile_SQL.getInstanceFileName", setData);
				reqSysFileName[i] = reqFilePath[i] + commonService.selectString("instanceFile_SQL.getInstanceFileSysName", setData);
			}else {
				reqFilePath[i] = commonService.selectString("fileMgt_SQL.getFilePathInSeq", setData);
				reqOrgiFileName[i] = commonService.selectString("fileMgt_SQL.getFileName", setData);
				reqSysFileName[i] = reqFilePath[i] + commonService.selectString("fileMgt_SQL.getFileSysName", setData);
				reqComment[i] = commonService.selectString("fileMgt_SQL.getFileComment", setData);
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
				
				mapValue.put("Seq", reqSeq[0]);
				Map result  = new HashMap();
				if(scrnType.equals("BRD")){
					result=fileMgtService.select("boardFile_SQL.selectDownFile",mapValue);
					filePath = GlobalVal.FILE_UPLOAD_BOARD_DIR;			
				}else if(scrnType.equals("INST")){
					mapValue.put("fileID", reqSeq[0]);
					filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR;
					mapValue.put("FilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
					result=fileMgtService.select("instanceFile_SQL.selectDownInstanceFile", mapValue);			
				
				}else if(scrnType.equals("ITSM")) {
					filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR;
					mapValue.put("FilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
					result=fileMgtService.select("zDLM_SQL.zdlm_selectDownFile",mapValue);
				}else{
					filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR;
					mapValue.put("FilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
					result=fileMgtService.select("fileMgt_SQL.selectDownFile",mapValue);
				}
				
				String filename = StringUtil.checkNull(result.get("filename"));
				String original = StringUtil.checkNull(result.get("original"));
				String downFile = StringUtil.checkNull(result.get("downFile"));
				if (!new File(downFile).exists()) {	
					
					 //"해당 파일 (파일이름)을 서버에서 찾을 수 없습니다" alert
					 if(alertType.equals("DHX")) {
						 target.put(AJAX_ALERT_DHX, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00078", new String[]{original}));
					} else {
						target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00078", new String[]{original}));
					}
					 
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
					setMap.put("TableName", "TB_BOARD_ATTCH");
				} else if(scrnType.equals("ISSUE")){
					setMap.put("TableName", "TB_ISSUE_FILE");
				} else {
					setMap.put("TableName", "TB_FILE");
				}
				
				if(scrnType.equals("INST")){
					setMap.put("fileID", reqSeq[0]);
					fileMgtService.update("instanceFile_SQL.updateInstanceFileDownCNT", setMap);
				}else{ fileMgtService.update("fileMgt_SQL.itemFileDownCnt_update", setMap); }
				

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
				
				if(!"".equals(returnValue)&&!"secret".equals(returnValue)) {
					downFile = returnValue;
				}
				
				request.setAttribute("downFile", downFile);
				request.setAttribute("orginFile", original);

				FileUtil.flMgtdownFile(request, response);
				
				if(useFileLog.equals("Y")) {
					// 한 개 기록
					String ip = request.getHeader("X-FORWARDED-FOR");
			        if (ip == null)
			            ip = request.getRemoteAddr();
			        cmmMap.put("IpAddress",ip);
			        cmmMap.put("fileID", reqSeq[0]); 
			        cmmMap.put("comment", reqComment[0]);
					commonService.insert("fileMgt_SQL.insertFileLog",cmmMap);
				}

				 
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
					if(!"".equals(returnValue)&&!"secret".equals(returnValue)) {
						sysFileName = new File(returnValue);
						reqOrgiFileName[i] = returnValue;
						reqFilePath[i] = DRMFileDir;
					}
					
					if(sysFileName.exists()){
						
						sysFileName.renameTo(orgiFileName);
					}
					
					if(useFileLog.equals("Y")) {
						//여러 개 기록
						String ip = request.getHeader("X-FORWARDED-FOR");
				        if (ip == null)
				            ip = request.getRemoteAddr();  
						cmmMap.put("IpAddress",ip);
					    cmmMap.put("fileID", reqSeq[i]); 
					    cmmMap.put("comment", reqComment[i]);
					    commonService.insert("fileMgt_SQL.insertFileLog",cmmMap);
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
					if(scrnType.equals("BRD")){
						setMap.put("TableName", "TB_BOARD_ATTCH");
					} else if(scrnType.equals("ISSUE")){
						setMap.put("TableName", "TB_ISSUE_FILE");
					} else {
						setMap.put("TableName", "TB_FILE");
					}
					
					if(scrnType.equals("INST")){ 
						setMap.put("fileID",reqSeq[i]);
						fileMgtService.update("instanceFile_SQL.updateInstanceFileDownCNT", setMap);
					}else{ fileMgtService.update("fileMgt_SQL.itemFileDownCnt_update", setMap); }
				}
				String downFile = fullPath;
				request.setAttribute("downFile", downFile);
				request.setAttribute("orginFile", newFileNm);
				FileUtil.flMgtdownFile(request, response);
			}
			
			if(alertType.equals("DHX")) {
				target.put(AJAX_ALERT_DHX, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00079"));
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00079"));
			}			
			target.put(AJAX_SCRIPT, "doSearchList();");			
		}catch (Exception e) {
			 System.out.println(e);
			 throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/deleteFile.do")
	public String deleteFile( HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		String sysFile =  StringUtil.checkNull(request.getParameter("SysFile"), "");
		String itemID = StringUtil.checkNull(request.getParameter("ItemID"), "");
		Map stusMap = new HashMap();
		try{
			stusMap.put("itemId", itemID);
			Map result  = fileMgtService.select("fileMgt_SQL.selectItemAuthorID",stusMap);
			
			File existFile = new File(sysFile);
			if(existFile.isFile() && existFile.exists()){existFile.delete();}
			fileMgtService.delete("fileMgt_SQL.itemFile_delete", cmmMap);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			target.put(AJAX_SCRIPT, "parent.goBack();");
			
		}catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/deleteFileFromLst.do")
	public String deleteFileFromLst( HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		
		try{
			String itemID = StringUtil.checkNull(request.getParameter("itemId"), "");
			String displayMsg = StringUtil.checkNull(request.getParameter("displayMsg"), "");
			String alertType = StringUtil.checkNull(request.getParameter("alertType"), "");

			//String sysFile[] = StringUtil.checkNull(request.getParameter("sysFile")).split(",");
			//String filePath[] = StringUtil.checkNull(request.getParameter("filePath")).split(",");
			String seq[] = StringUtil.checkNull(request.getParameter("seq")).split(",");
			int seqLength = seq.length; // seq 배열의 길이를 미리 저장하여 반복문에서 사용

			// filePath와 sysFile 배열 초기화
			String[] filePath = new String[seqLength];
			String[] sysFile = new String[seqLength];			
			
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
			Map setData = new HashMap();
			
			System.out.println("seqLen>>>>>"+seq.length);
			
			

			for(int i=0; seqLength>i; i++){
				setData.put("seq", seq[i]);
				if(scrnType.equals("BRD")){
					filePath[i] = commonService.selectString("boardFile_SQL.getFilePath", setData);
					sysFile[i] = commonService.selectString("boardFile_SQL.getFileSysName", setData);
					setData.put("fileID", seq[i]);
					filePath[i] = commonService.selectString("instanceFile_SQL.getInstanceFilePath", setData);
					sysFile[i] = commonService.selectString("instanceFile_SQL.getInstanceFileSysName", setData);
				}else {
					filePath[i] = commonService.selectString("fileMgt_SQL.getFilePathInSeq", setData);
					sysFile[i] = commonService.selectString("fileMgt_SQL.getFileSysName", setData);
				}
			}

			setMap.put("itemId", itemID);
			String taskFile = null;
			String fileName = "";
			System.out.println("sysFile>>"+sysFile.length);
			for(int i=0; i<sysFile.length; i++){
				
				if(!sysFile[i].equals("")){
					fileName = filePath[i] + "/" + sysFile[i];
					File existfile = new File(fileName);
					//FileUtil.deleteFile(fileName);
					if(existfile.isFile() && existfile.exists()){
						existfile.delete();
					}
				}
				setMap.put("Seq", seq[i]);
				if(scrnType.equals("INST")){
					setMap.put("fileID", seq[i]);
					fileMgtService.delete("instanceFile_SQL.deleteInstanceFile", setMap);
				}else{
					fileMgtService.delete("fileMgt_SQL.itemFile_delete", setMap);
				}
				// task에 첨부된 파일 삭제 
				taskFile = fileMgtService.selectString("fileMgt_SQL.getFileFromTask",setMap);
				if(taskFile != null){
					setMap.put("taskFileID", taskFile);
					fileMgtService.delete("fileMgt_SQL.updateNullToTaskFile",setMap);
				}
			}
			
			// 삭제 성공
			if(alertType.equals("DHX")) {
				if(!displayMsg.equals("N")) target.put(AJAX_ALERT_DHX, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069"));
			}
			else {
				if(!displayMsg.equals("N")) target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069"));
			}
			target.put(AJAX_SCRIPT, "hideFileDetailPanel(); doSearchList();");			
		}catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/deleteTempFile.do")
	public String deleteTempFile( HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String fileName =  StringUtil.checkNull(request.getParameter("fileName"), "");
		try{
			String scrnType =  StringUtil.checkNull(request.getParameter("scrnType"), "");
			
			String sessionUserID =  StringUtil.checkNull(cmmMap.get("sessionUserId"), "");
			String filePath = "";
		
				if(scrnType.equals("BRD")){
					filePath = GlobalVal.FILE_UPLOAD_BOARD_DIR;
				}else if(scrnType.equals("CNG")){
					filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR;
				}else if(scrnType.equals("ISSUE")){
					filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR;
				}else if(scrnType.equals("SR")){
					filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR;
				}else if(scrnType.equals("INST")){
					filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR;		
				}else{
					// filePath = GlobalVal.FILE_UPLOAD_TMP_DIR;	
					filePath = GlobalVal.FILE_UPLOAD_BASE_DIR;
				}
			if(!fileName.equals("")){fileName=filePath+"//"+sessionUserID+"//"+fileName;FileUtil.deleteFile(fileName);}
		}catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}	
	
	@RequestMapping(value="/goFileMdlList.do")
	public String goFileMdlList(HttpServletRequest request, HttpServletResponse response, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		
		String url = "file/fileMdlList";
		String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));	
		Map fileMap = new HashMap();
		Map setMap = new HashMap();
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
//			
//			if (StringUtil.checkNull(result.get("AuthorID")).equals(sessionUserID)
//					|| StringUtil.checkNull(result.get("LockOwner")).equals(cmmMap.get("sessionUserId"))
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			model.put("myItem", myItem);
			
			fileMap.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			fileMap.put("s_itemID", s_itemID);
			fileMap.put("fromToItemID", s_itemID);
			List itemList = commonService.selectList("item_SQL.getCxnItemIDList", fileMap); //getCxnItemIDList
			
			String rltdItemId = "";
			for(int i = 0; i < itemList.size(); i++){
				Map itemInfo = (HashMap)itemList.get(i);
				if (i == 0) {
					rltdItemId += StringUtil.checkNull(itemInfo.get("ItemID"));
				}else{					
					rltdItemId += "," + StringUtil.checkNull(itemInfo.get("ItemID"));
				}
			}
			if(!rltdItemId.equals("")){rltdItemId += ","+s_itemID;}else{ rltdItemId = s_itemID;}
			model.put("DocCategory", "ITM");
			model.put("hideBlocked", "Y");
			model.put("rltdItemId", rltdItemId);	
			model.put("itemFileOption", itemFileOption);			
			model.put("itemAthId", itemAthId);
			model.put("Blocked",Blocked);
			model.put("s_itemID", s_itemID);
			model.put("LockOwner", LockOwner);
			model.put("screenType", "model");
			model.put("menu", getLabel(request, commonService));
			
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("rltdItemId", rltdItemId);
			setMap.put("hideBlocked", "Y");
			setMap.put("DocCategory", "ITM");
			setMap.put("s_itemID", s_itemID);
			setMap.put("DocumentID", s_itemID);
			List gfmList = commonService.selectList("fileMgt_SQL.getFile_gridList",setMap);
			
			JSONArray gridData = new JSONArray(gfmList);
			model.put("gridData",gridData);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/goDocumentList.do") // fileListMgt.do 로 이동, 삭제예정 (goDocumentList.do)
	public String goDocumentList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "file/documentMainMenu";
		Map itemMap = new HashMap();
		try {
				String searchValue = StringUtil.checkNull(request.getParameter("searchValue"));
				searchValue = StringUtil.replaceFilterString(searchValue);
			
				Map setMap = new HashMap();		
				setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
				
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				model.put("isPublic", StringUtil.checkNull(request.getParameter("isPublic")));
				String screenType = StringUtil.checkNull(request.getParameter("screenType"));
				if(screenType.equals("main")){
					model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
					model.put("searchKey", StringUtil.checkNull(request.getParameter("searchKey")));
					model.put("searchValue", searchValue);
					model.put("fltpCode", StringUtil.checkNull(request.getParameter("fltpCode")));
					model.put("itemTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode")));
					model.put("itemClassCode", StringUtil.checkNull(request.getParameter("classCode")));
					model.put("regMemberName", StringUtil.checkNull(request.getParameter("regMemberName")));
					
				}
				
		}catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
			
		return nextUrl(url);
	}
	
	@RequestMapping(value="/documentDetail.do")
	public String documentDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "file/documentDetail";
		try {
				Map fileMap  = new HashMap();
				Map setMap = new HashMap();	
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				String seq = StringUtil.checkNull(request.getParameter("seq"), "");
				String isNew = StringUtil.checkNull(request.getParameter("isNew"), "");
				String DocumentID = StringUtil.checkNull(request.getParameter("DocumentID"), "");
				String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"), "");
				String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"), "");
				String strItemID = StringUtil.checkNull(request.getParameter("strItemID"), "");
				
				// String parentID = StringUtil.checkNull(request.getParameter("parentID"),"");	
				System.out.println("screenType : " + StringUtil.checkNull(request.getParameter("screenType"),""));
				String screenType = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("screenType"),""));	
				String isMember =  StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("isMember"),""));	
								
				screenType = StringEscapeUtils.escapeHtml4(screenType);
				screenType = screenType.replace("img","").replace("src","").replace("<", "&lt;").replace(">", "&gt;").replace("\0", "");
				isMember = StringEscapeUtils.escapeHtml4(isMember);
			
				String path = StringUtil.checkNull(request.getParameter("path"),"");	
				setMap.put("seq", seq);
				setMap.put("DocumentID", DocumentID);
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				setMap.put("strItemID", strItemID);
				
				fileMap = commonService.select("fileMgt_SQL.getFileDetailList",setMap);
				String classCode = StringUtil.checkNull(fileMap.get("ClassCode"),"");
				
				List logList = commonService.selectList("fileMgt_SQL.getFileLogInfo", setMap);
				model.put("logList", logList);
				JSONArray gridData = new JSONArray(logList);
				model.put("gridData",gridData);
				
				model.put("fileMap", fileMap);		
				model.put("pageNum", request.getParameter("pageNum"));
				model.put("itemTypeCode", itemTypeCode);
				model.put("fltpCode", fltpCode);
				model.put("classCode", classCode);
				model.put("docType", request.getParameter("docType"));
				model.put("screenType", screenType);
				model.put("isMember", isMember);
				model.put("path", path);
				
				setMap.put("itemId", DocumentID);
				model.put("fileOption", StringUtil.checkNull(fileMgtService.selectString("fileMgt_SQL.getFileOption",setMap)));
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
			
		return nextUrl(url);
	}
	
	/* My Page Contents>문서 */
	@RequestMapping(value="/olmDocList.do")  // fileListMgt.do 로 이동, 삭제 예정 (olmDocList.do, olmDocList.jsp)
	public String olmDocList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "file/olmDocList";
		try {
				Map setMap = new HashMap();	
				String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"), "");
				String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"), "");
				String frmType = StringUtil.checkNull(request.getParameter("frmType"), ""); 
				String screenType = StringUtil.checkNull(request.getParameter("screenType"), ""); 
				String myDoc = StringUtil.checkNull(request.getParameter("myDoc"), ""); 
				String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), ""); 
				String csrEditable = StringUtil.checkNull(request.getParameter("csrEditable"), ""); 
				String isMember = StringUtil.checkNull(request.getParameter("isMember"), ""); 
				String isPublic = StringUtil.checkNull(request.getParameter("isPublic"), ""); 
				String DocCategory = StringUtil.checkNull(request.getParameter("DocCategory"), "ITM"); 
				 
				setMap.put("fltpCode", fltpCode);
				setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
				
				String fltpName = "";
				if(!fltpCode.equals("")){
					fltpName = commonService.selectString("fileMgt_SQL.getFltpName",setMap);
				}else{
					fltpName = getLabel(request, commonService).get("LN00019").toString();
				}
				
				String parentID = StringUtil.checkNull(request.getParameter("parentID"), ""); 
				String projectID = StringUtil.checkNull(request.getParameter("projectID"), ""); 
				if(screenType.equals("mainV3") || screenType.equals("csrDtl")){
					Map projectMap = new HashMap();
					setMap.put("parentID", parentID);
					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
					projectMap = commonService.select("task_SQL.getProjectAuthorID",setMap);
					model.put("projectMap", projectMap);
					model.put("projectID", projectID);
					model.put("isMember", isMember);
				}
				
				if(screenType.equals("main")){
					model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
					model.put("searchKey", StringUtil.checkNull(request.getParameter("searchKey")));
					model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
					model.put("itemClassCode", StringUtil.checkNull(request.getParameter("itemClassCode")));
				}
				
				model.put("parentID", parentID);
				model.put("DocCategory", DocCategory);
				model.put("itemTypeCode", itemTypeCode);
				model.put("fltpCode", fltpCode);
				model.put("fltpName", fltpName);
				model.put("frmType", frmType);
				model.put("myDoc", myDoc);
				model.put("screenType", screenType);
				model.put("isPublic", isPublic);
				model.put("csrEditable", csrEditable);
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
								
				cmmMap.put("isPublic", isPublic);
				cmmMap.put("screenType", screenType);
				cmmMap.put("myDoc", myDoc);
				cmmMap.put("DocCategory", DocCategory);
				cmmMap.put("authLev", String.valueOf(cmmMap.get("sessionAuthLev")));
				cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				if(screenType.equals("csrDtl")) {
					cmmMap.put("projectID",projectID);
					cmmMap.put("refPjtID",cmmMap.get("refPjtID"));
				}
				if(!screenType.equals("csrDtl")) {
					cmmMap.put("fltpCode", fltpCode);
				}
				List odList = commonService.selectList("fileMgt_SQL.getFile_gridList",cmmMap);
				
				JSONArray gridData = new JSONArray(odList);
				model.put("gridData",gridData);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	

	@RequestMapping(value="/esmDocList.do")
	public String esmDocList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "file/esmDocList";
		try {
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				Map setData = new HashMap();	
				String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"), "");
				String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"), "");
				String isMember = StringUtil.checkNull(request.getParameter("isMember"), ""); 
				String isPublic = StringUtil.checkNull(request.getParameter("isPublic"), ""); 
				String docCategory = StringUtil.checkNull(request.getParameter("docCategory"), ""); 
				String scrID = StringUtil.checkNull(request.getParameter("scrID"));
								
				setData.put("scrID", scrID);
				setData.put("isPublic", "N");
				setData.put("DocCategory", docCategory);
				setData.put("docDomain", "ESM");
				setData.put("languageID", cmmMap.get("sessionCurrLangType"));
				
				List fileList = commonService.selectList("fileMgt_SQL.getFile_gridList",setData);
				JSONArray gridData = new JSONArray(fileList);
				model.put("gridData", gridData);
				
			
				model.put("docCategory", docCategory);
				model.put("docDomain", "ESM");
				model.put("itemTypeCode", itemTypeCode);
				model.put("fltpCode", fltpCode);
				model.put("isPublic", isPublic);
				
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	

	@RequestMapping(value="/saveItemFileDetail.do")
	public String saveItemFileDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		Map target = new HashMap();
		try {
				Map fileMap  = new HashMap();
				Map setMap = new HashMap();	
				String seq = StringUtil.checkNull(cmmMap.get("Seq"), "");
				String isNew = StringUtil.checkNull(cmmMap.get("isNew"), "");
				String fltpCode = StringUtil.checkNull(cmmMap.get("FltpCode"), "");
				String Description = StringUtil.checkNull(cmmMap.get("Description"), "");
				Description = StringUtil.replaceFilterString(Description).replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;");
				System.out.println("Description :"+Description );
				String DocumentID = StringUtil.checkNull(cmmMap.get("DocumentID"), "");				
				String sessionUserID = cmmMap.get("sessionUserId").toString();
				String scrnType = StringUtil.checkNull(cmmMap.get("scrnType"), "");
				String screenType = StringUtil.checkNull(cmmMap.get("screenType"), "");
				String blocked = StringUtil.checkNull(cmmMap.get("Blocked"), "0");
				String docCategory = StringUtil.checkNull(cmmMap.get("DocCategory"));
				String ChangeSetID = StringUtil.checkNull(cmmMap.get("ChangeSetID"));
				String Version = StringUtil.checkNull(cmmMap.get("Version"));
				String RefFileID = StringUtil.checkNull(cmmMap.get("RefFileID"), "");
				if(screenType.equals("csrDtl")){
					fltpCode = "CSRDF";			
				}
								
				setMap.put("Seq", seq);
				setMap.put("itemID", DocumentID);
				setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
				setMap.put("FltpCode", fltpCode);
				setMap.put("Description", Description);
				setMap.put("sessionUserId", sessionUserID);
				
				cmmMap.put("fltpCode", fltpCode);
				
				List fileList = new ArrayList();
				String fileMgt 	= StringUtil.checkNull(cmmMap.get("fileMgt"), "ITM");
				String userId 	= StringUtil.checkNull(cmmMap.get("sessionUserId").toString(), "");
				String linkType = StringUtil.checkNull(cmmMap.get("linkType"), "1");
	
				setMap.put("itemID", DocumentID);
				String curChangeSetID = StringUtil.checkNull(commonService.selectString("project_SQL.getCurChangeSetIDFromItem",setMap));

				String filePath = StringUtil.checkNull(fileMgtService.selectString("fileMgt_SQL.getFilePath",cmmMap), GlobalVal.FILE_UPLOAD_ITEM_DIR);  
				setMap.put("itemId",DocumentID);
				String itemFileOption = fileMgtService.selectString("fileMgt_SQL.getFileOption",setMap);
				if(seq.equals("")||!RefFileID.equals("")){//insert
					if(!RefFileID.equals("")) {
						ChangeSetID = StringUtil.checkNull(commonService.selectString("project_SQL.getCurChangeSetIDFromItem",setMap));
					}
					cmmMap.put("itemId", DocumentID);
					Map result  = fileMgtService.select("fileMgt_SQL.selectItemAuthorID",cmmMap);
					cmmMap.put("Status", StringUtil.checkNull(result.get("Status").toString()));
					cmmMap.put("KBN", "insert");
					
					//int seqCnt = 0;
					//seqCnt = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", cmmMap));
					//Read Server File
					String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(cmmMap.get("sessionUserId"))+"//";
					String targetPath = filePath;
					File dirFile = new File(targetPath);if(!dirFile.exists()) { dirFile.mkdirs();} 
					List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
					if(tmpFileList != null){
						
						if("VIEWER".equals(itemFileOption))
							filePath = "";
						
						for(int i=0; i<tmpFileList.size();i++){
							fileMap=new HashMap(); 
							HashMap resultMap=(HashMap)tmpFileList.get(i);
							//fileMap.put("Seq", seqCnt);
							fileMap.put("DocumentID", DocumentID);
							fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
							fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
							fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
							fileMap.put("FilePath", filePath);
							fileMap.put("FileFormat", resultMap.get(FileUtil.FILE_EXT));
							fileMap.put("FltpCode", fltpCode);
							fileMap.put("FileMgt", fileMgt);
							fileMap.put("LinkType", linkType);
							fileMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
							fileMap.put("userId", userId);
							fileMap.put("projectID", StringUtil.checkNull(result.get("ProjectID").toString()));
							fileMap.put("DocCategory", "ITM");
							fileMap.put("RefFileID", RefFileID);
							fileMap.put("ChangeSetID", ChangeSetID);
							fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");					
							
							fileList.add(fileMap);
							//seqCnt++;
						}
					}
					fileMgtService.save(fileList, cmmMap);					
				}
				else{//update					
				
					cmmMap.put("itemId", DocumentID);
					Map result  = fileMgtService.select("fileMgt_SQL.selectItemAuthorID",cmmMap);
					cmmMap.put("Status", StringUtil.checkNull(result.get("Status")));
					cmmMap.put("KBN", "insert");
				
					//Read Server File
					String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(cmmMap.get("sessionUserId"))+"//";
					String targetPath = filePath;
					File dirFile = new File(targetPath);if(!dirFile.exists()) { dirFile.mkdirs();} 
					List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
					
					if(tmpFileList.size() > 0){						
						
						for(int i=0; i<tmpFileList.size();i++){
							fileMap=new HashMap(); 
							HashMap resultMap=(HashMap)tmpFileList.get(i);
							if("VIEWER".equals(itemFileOption))
								fileMap.put("FilePath", "VIEWER");
							
							fileMap.put("Seq", seq);
							fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
							fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
							fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
							fileMap.put("FltpCode", fltpCode);
							fileMap.put("FileFormat", resultMap.get(FileUtil.FILE_EXT));
							fileMap.put("Description", Description);
							fileMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
							fileMap.put("Blocked", blocked);
							
							if("ITM".equals(docCategory)) {
								fileMap.put("ChangeSetID", curChangeSetID);
							}
							
							fileMap.put("sessionUserId", userId);
							fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_update");					
							
							fileList.add(fileMap);
						}
						
					}else{
						setMap.put("Blocked", blocked);
						
						if("ITM".equals(docCategory)) {
							setMap.put("ChangeSetID", curChangeSetID);
						}
						
						commonService.insert("fileMgt_SQL.itemFile_update",setMap);
					}
					fileMgtService.save(fileList, cmmMap);	
					
					setMap.put("Version",Version);
					setMap.put("s_itemID",ChangeSetID);
					commonService.update("cs_SQL.updateChangeSetVersion",setMap);
				}
			
				model.put("fileMap", fileMap);
				model.put("pageNum", cmmMap.get("pageNum"));
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				target.put(AJAX_SCRIPT, "parent.fnCallBack();");
				
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/saveMultiFile.do")
	public String saveMultiFile(HttpServletRequest request,HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		Map target = new HashMap();
		
		String fileID = StringUtil.checkNull(cmmMap.get("fileID"), ""); // fileID 존재할 경우 update 처리
		String documentID = StringUtil.checkNull(cmmMap.get("id"), "");
		String fltpCode = StringUtil.checkNull(cmmMap.get("fltpCode"), "");
		String fileMgt 	= StringUtil.checkNull(cmmMap.get("fileMgt"), "ITM");
		String userId 	= StringUtil.checkNull(cmmMap.get("usrId"), "");
		String linkType = StringUtil.checkNull(cmmMap.get("linkType"), "1");
		String docCategory = StringUtil.checkNull(cmmMap.get("docCategory"), "ITM");
		String changeSetID = StringUtil.checkNull(cmmMap.get("changeSetID"), "");
		String projectID = StringUtil.checkNull(cmmMap.get("projectID"));
		String refFileID = StringUtil.checkNull(cmmMap.get("refFileID"));
		String itemFileOption = "OLM";
		String returnValue ="";
		String errorMessage = MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068");
		
		String vaultModalYN = StringUtil.checkNull(cmmMap.get("vaultModalYN"), "");
		
		try{
			List fileList = new ArrayList();
			Map fileMap = null;
			Map stusMap = new HashMap();
			String filePath = StringUtil.checkNull(fileMgtService.selectString("fileMgt_SQL.getFilePath",cmmMap),GlobalVal.FILE_UPLOAD_ITEM_DIR);
			cmmMap.put("itemId", documentID);
			cmmMap.put("itemID", documentID);
		
			if("ITM".equals(docCategory)) {			
				Map result  = fileMgtService.select("fileMgt_SQL.selectItemAuthorID",cmmMap);
				changeSetID = StringUtil.checkNull(commonService.selectString("project_SQL.getCurChangeSetIDFromItem",cmmMap));
				projectID = StringUtil.checkNull(result.get("ProjectID").toString());
				
				itemFileOption = fileMgtService.selectString("fileMgt_SQL.getFileOption",cmmMap);
				cmmMap.put("Status", StringUtil.checkNull(result.get("Status")));
			}
			else {				
				cmmMap.put("Status", "");
			}
			
			//Read Server File
			String revisionYN = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getRevisionYN", cmmMap));	
			cmmMap.put("revisionYN", revisionYN);
			cmmMap.put("DocumentID", documentID);
			cmmMap.put("FltpCode", fltpCode);
			cmmMap.put("FileMgt", fileMgt);
			cmmMap.put("LinkType", linkType);
			cmmMap.put("ChangeSetID", changeSetID);
			cmmMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
			cmmMap.put("userId", userId);
			cmmMap.put("projectID", projectID);					
			cmmMap.put("DocCategory", docCategory);
			cmmMap.put("ItemID", documentID);
			cmmMap.put("RefFileID", refFileID);
			cmmMap.put("fileID", fileID);
			
			String KBN = "insert";
			if(!"".equals(fileID)) KBN = "update";
			cmmMap.put("KBN", KBN);
			
			Map fileUploadMap = new HashMap();
			fileUploadMap = fileUploadUtil.fileUpload(cmmMap, request);
			
			boolean fileUploadResult = (boolean) fileUploadMap.getOrDefault("result",false);
			if(!fileUploadResult) {
				errorMessage = StringUtil.checkNull(fileUploadMap.get("message"),"파일 업로드 실패");
				throw new Exception(errorMessage);
			}
			
			returnValue = StringUtil.checkNull(fileUploadMap.get("returnValue"));
			
			// saveMultiFile.do 만 파일 업로드 후, 세션 재설정
			HttpSession session = request.getSession(true);
			String newToken = fileUploadUtil.makeFileUploadFolderToken(session);
			
			if(returnValue.equals("secret")) {// 보안레이블 kefico
				target.put(AJAX_SCRIPT, "parent.viewMessageMIP('"+returnValue+"');parent.$('#isSubmit').remove();");
			}else {	
				if (!vaultModalYN.equals("Y")) {
					target.put(AJAX_SCRIPT, "parent.multiSaveCallback('" + newToken + "'); parent.viewMessage();parent.$('#isSubmit').remove();");
				} else {
						target.put(AJAX_SCRIPT, "parent.multiSaveCallback('" + newToken + "');");
				}
			}
			
			
		}catch (Exception e) {
			System.out.println(e);
			// saveMultiFile.do 만 파일 업로드 후, 세션 재설정
			HttpSession session = request.getSession(true);
			String newToken = fileUploadUtil.makeFileUploadFolderToken(session);
			target.put(AJAX_SCRIPT, "parent.dhtmlx.alert('" + errorMessage + "');parent.$('#isSubmit').remove();parent.multiSaveCallback('" + newToken + "');");
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/documentGridList.do")
	public String documentGridList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "file/documentGridList";
		try {
				Map setMap = new HashMap();	
				String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"), "");
				String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"), "");
				String frmType = StringUtil.checkNull(request.getParameter("frmType"), ""); 
				String screenType = StringUtil.checkNull(request.getParameter("screenType"), ""); 
				String docType = StringUtil.checkNull(request.getParameter("docType"), ""); 
				String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), ""); 
				String csrEditable = StringUtil.checkNull(request.getParameter("csrEditable"), ""); 
				String isMember = StringUtil.checkNull(request.getParameter("isMember"), ""); 
				String isPublic = StringUtil.checkNull(request.getParameter("isPublic"), ""); 
				String DocCategory = StringUtil.checkNull(request.getParameter("DocCategory"), "ITM"); 
				String regMemberName = StringUtil.checkNull(request.getParameter("regMemberName"), "");
				 
				setMap.put("fltpCode", fltpCode);
				setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
				
				String fltpName = "";
				if(!fltpCode.equals("")){
					fltpName = commonService.selectString("fileMgt_SQL.getFltpName",setMap);
				}else{
					fltpName = getLabel(request, commonService).get("LN00019").toString();
				}
				
				String parentID = StringUtil.checkNull(request.getParameter("parentID"), ""); 
				String projectID = StringUtil.checkNull(request.getParameter("projectID"), ""); 
				if(screenType.equals("mainV3") || screenType.equals("csrDtl")){
					Map projectMap = new HashMap();
					setMap.put("parentID", parentID);
					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
					projectMap = commonService.select("task_SQL.getProjectAuthorID",setMap);
					model.put("projectMap", projectMap);
					model.put("projectID", projectID);
					model.put("isMember", isMember);
				}
				
				if(screenType.equals("main")){
					model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
					model.put("searchKey", StringUtil.checkNull(request.getParameter("searchKey")));
					model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
					model.put("itemClassCode", StringUtil.checkNull(request.getParameter("itemClassCode")));
				}
				
				model.put("parentID", parentID);
				model.put("DocCategory", DocCategory);
				model.put("regMemberName", regMemberName);
				model.put("itemTypeCode", itemTypeCode);
				model.put("fltpCode", fltpCode);
				model.put("fltpName", fltpName);
				model.put("frmType", frmType);
				model.put("docType", docType);
				model.put("screenType", screenType);
				model.put("isPublic", isPublic);
				model.put("csrEditable", csrEditable);
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				cmmMap.put("pageNum", model.get("pageNum"));
				cmmMap.put("authLev", String.valueOf(cmmMap.get("sessionAuthLev")));
				cmmMap.put("screenType", screenType);
				cmmMap.put("isPublic", isPublic);
				cmmMap.put("DocCategory", DocCategory);
				cmmMap.put("showFilePath", "N");
		
				if(docType.equals("myDoc")) cmmMap.put("myDoc","Y");					
				List docFileList = commonService.selectList("fileMgt_SQL.getFile_gridList",cmmMap);
			  	JSONArray gridData = new JSONArray(docFileList);
			  	 model.put("gridData", gridData);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	/**
	 * 하위 항목 [Edit ] 이벤트
	 * 
	 * @param request
	 * @param cmmMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/editFileNamePop.do")
	public String editFileNamePop(HttpServletRequest request, HashMap cmmMap,
			ModelMap model) throws Exception {
		try {

			Map setMap = new HashMap();

			String documentID = StringUtil.checkNull(request.getParameter("DocumentID"));
			String docCategory = StringUtil.checkNull(request.getParameter("docCategory"), "ITM");

			setMap.put("DocumentID", documentID);
			setMap.put("DocCategory", docCategory);
			setMap.put("isPublic", "N");
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));			
			List returnData = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);

			model.put("documentID", documentID);
			model.put("getList", returnData);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/editFileNamePop");
	}
	
	@RequestMapping(value="/editFileName.do")
	public String editFileName(HttpServletRequest request,HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
	
		List fileList = new ArrayList();
		Map fileMap = null;
		Map stusMap = new HashMap();
		try{
			
				String documentID = StringUtil.checkNull(request.getParameter("documentID"));
				String docCategory = StringUtil.checkNull(request.getParameter("docCategory"),"ITM");
				
				setMap.put("DocumentID", documentID);
				setMap.put("DocCategory", docCategory);
				setMap.put("isPublic", "N");
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));			
				List returnData = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
				
				if(returnData != null) {
					for (int i = 0; i < returnData.size() ; i++) {		
					    Map map = (Map) returnData.get(i);
						String Seq = StringUtil.checkNull(map.get("Seq")); 
						fileMap = new HashMap();
					    fileMap.put("Seq", Seq);
					    fileMap.put("FileRealName", request.getParameter("Name_"+Seq));
					    fileMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
					    fileMap.put("FilePath", map.get("FilePath"));
					    fileMap.put("userId", cmmMap.get("sessionUserId"));
					    fileMap.put("KBN", "update");
	
					    fileMap.put("SQLNAME", "fileMgt_SQL.updateExtFile"); 
					   
					    fileList.add(fileMap);
					}	
				}
				
				fileMgtService.save(fileList, fileMap);				
			
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				target.put(AJAX_SCRIPT,  "parent.selfClose();");
			
		}catch (Exception e) {
				System.out.println(e);
				throw new ExceptionUtil(e.toString());
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/selectFileList.do")
	public String selectFileList(HttpServletRequest request, ModelMap model, HttpServletResponse response) throws  ServletException, IOException, Exception {
		
		String itemID = StringUtil.checkNull(request.getParameter("itemId"), "1");
		String languageID = StringUtil.checkNull(request.getParameter("languageID"), "1");
		String baseUrl = StringUtil.checkNull(request.getParameter("baseUrl"), "1");
		
		Map mapValue = new HashMap();
		List getList = new ArrayList();
		
		try {
				mapValue.put("itemId", itemID);
				mapValue.put("languageID", languageID);
				mapValue.put("baseUrl", baseUrl);
				getList = commonService.selectList("fileMgt_SQL.selectFileList",mapValue);
				
				JSONArray jsonArray = new JSONArray(getList);							
				response.setCharacterEncoding("UTF-8"); // 한글깨짐현상 방지
				PrintWriter out = response.getWriter();
			    out.write(jsonArray.toString());
			    out.flush();
				
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
			
		return nextUrl(AJAXPAGE);
	}
	

	@RequestMapping(value="/subItemFileList.do") // fileListMgt.do 이동완료 (삭제 예정 subItemFileList.do)
	public String subItemFileList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "file/subItemFileList";
		try {
			String itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");			
			String showVersion = StringUtil.checkNull(request.getParameter("varFilter"), "N");	
			String showValid = StringUtil.checkNull(request.getParameter("varFilter"), "N");	
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
			
			Map setData = new HashMap();
			setData.put("itemID", itemID);
			setData.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
			Map itemTypeMap = commonService.select("common_SQL.itemTypeCode_commonSelect", setData);
			model.put("itemID", itemID);
			model.put("showValid", showValid);
			model.put("showVersion", showVersion);
			model.put("fltpCode", fltpCode);
			model.put("itemTypeName", StringUtil.checkNull(itemTypeMap.get("NAME")));
			model.put("itemTypeCode", StringUtil.checkNull(itemTypeMap.get("CODE")));
			model.put("menu", getLabel(request, commonService));
			
			cmmMap.put("itemID", itemID);
			cmmMap.put("fltpCode", fltpCode);
			cmmMap.put("filtered", "Y");
			cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			List sifList = commonService.selectList("fileMgt_SQL.getSubItemFileList_gridList",cmmMap);
			
			JSONArray gridData = new JSONArray(sifList);
			model.put("gridData",gridData);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
			
		return nextUrl(url);
	}
	
	@RequestMapping(value="/strItemSubFileList.do") // fileListMgt.do 이동완료 (삭제 예정 strItemSubFileList.do)
	public String strItemSubFileList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "file/strItemSubFileList";
		try {
			model.put("menu", getLabel(request, commonService));
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");			
			String strItemID = StringUtil.checkNull(request.getParameter("strItemID"), "");			
			String showVersion = StringUtil.checkNull(request.getParameter("varFilter"), "N");	
			String showValid = StringUtil.checkNull(request.getParameter("varFilter"), "N");	
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
			
			Map setData = new HashMap();
			setData.put("itemID", s_itemID);
			setData.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
			Map itemTypeMap = commonService.select("common_SQL.itemTypeCode_commonSelect", setData);
			model.put("s_itemID", s_itemID);
			model.put("strItemID", strItemID);
			model.put("showValid", showValid);
			model.put("showVersion", showVersion);
			model.put("fltpCode", fltpCode);
			model.put("itemTypeName", StringUtil.checkNull(itemTypeMap.get("NAME")));
			model.put("itemTypeCode", StringUtil.checkNull(itemTypeMap.get("CODE")));
			
			setData.put("strItemID", strItemID);
			setData.put("s_itemID", s_itemID);
			setData.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			List strItemSubFileList = commonService.selectList("fileMgt_SQL.getStrItemSubFileList_gridList", setData);
		
			JSONArray gridData = new JSONArray(strItemSubFileList);
			model.put("gridData", gridData);
			
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
			
		return nextUrl(url);
	}
	

	@RequestMapping(value="/updateFileBlocked.do")
	public String updateFileBlocked(HttpServletRequest request,HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		Map target = new HashMap();
		String alertType =  StringUtil.checkNull(request.getParameter("alertType"), "");
		try{
			Map setMap = new HashMap();
			String seq =  StringUtil.checkNull(request.getParameter("seq"), "");
			setMap.put("seq",seq);
			
			commonService.update("fileMgt_SQL.updateFileBlocked", setMap);
			
			if(alertType.equals("DHX")) {
				target.put(AJAX_ALERT_DHX, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			}
			target.put(AJAX_SCRIPT,  "doSearchList();parent.$('#isSubmit').remove();");
			
		}catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			
			if(alertType.equals("DHX")) {
				target.put(AJAX_ALERT_DHX, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			}
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	// 외부(File DonwLoad) 
	@RequestMapping(value = "/zhw_fileDownload.do")
	public String zhw_fileDownload(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/file/zhw_fileDownload";		
		try {				
				String fileID = StringUtil.checkNull(request.getParameter("fileID")); 				
				model.put("fileID", fileID);	
				model.put("menu", getLabel(request, commonService)); //  Label Setting 			
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	

	@RequestMapping(value = "/selectFilePop.do")
	public String selectFilePop(HttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			Map ParentMap = new HashMap();
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			List fileList = new ArrayList();
			String itemFileOption = "";
			String myItem ="";
			
			String templateFile = StringUtil.checkNull(request.getParameter("templateFile"));
			String docCategory = StringUtil.checkNull(request.getParameter("docCategory"));
			String speCode = StringUtil.checkNull(request.getParameter("speCode"));
			String itemClassCode = StringUtil.checkNull(request.getParameter("itemClassCode"));
			setMap.put("docCategory", docCategory);
			setMap.put("speCode", speCode);
			setMap.put("itemClassCode", itemClassCode);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			
			if("Y".equals(templateFile)) {
				myItem = "Y";
				fileList = commonService.selectList("fileMgt_SQL.getTemplateFileList", setMap);
			} else {
			
				String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
				
				String linkID = StringUtil.checkNull(request.getParameter("linkID"), "");
				String linkType = StringUtil.checkNull(request.getParameter("linkType"), ""); // id, code,															
				String itemTypeCode = StringUtil.checkNull(	request.getParameter("iType"), ""); // itemTypeCode
				if ("".equals(s_itemID) && !"".equals(linkID) && linkType.equals("code")) {
					setMap.put("itemTypeCode", itemTypeCode);
					setMap.put("identifier", linkID);
					s_itemID = StringUtil.checkNull(commonService.selectString("item_SQL.getItemID", setMap), "");
				}
				
				String hideBlocked = StringUtil.checkNull(request.getParameter("hideBlocked"),"Y"); 
				setMap.put("hideBlocked",hideBlocked);
				setMap.put("DocumentID",s_itemID);
				setMap.put("s_itemID",s_itemID);
				setMap.put("DocCategory","ITM");
				setMap.put("isPublic", "N");
				setMap.put("itemId",s_itemID);
	
				Map result  = fileMgtService.select("fileMgt_SQL.selectItemAuthorID",setMap);
				itemFileOption = fileMgtService.selectString("fileMgt_SQL.getFileOption",setMap);
				
				setMap.put("fromToItemID",s_itemID);
				List itemList = commonService.selectList("item_SQL.getCxnItemIDList", setMap);
				Map getMap = new HashMap();
				/** 첨부문서 관련문서 합치기, 관련문서 itemClassCodep 할당된 fltpCode 로 filtering */
				String rltdItemId = "";
				for(int i = 0; i < itemList.size(); i++){
					ParentMap = (HashMap)itemList.get(i);
					getMap.put("ItemID", ParentMap.get("ItemID"));
					if (i < itemList.size() - 1) {
					   rltdItemId += StringUtil.checkNull(ParentMap.get("ItemID"))+ ",";
					}else{
						rltdItemId += StringUtil.checkNull(ParentMap.get("ItemID"));
					}
				}
				
				setMap.put("rltdItemId", rltdItemId);			
				fileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);		
	
				if(fileList.size() == 1) {
					model.put("downYN","Y");
					Map temp = (Map)fileList.get(0);				
					model.put("Seq", temp.get("Seq"));
					
				}
				myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			}
			
//			String sessionUserID = cmmMap.get("sessionUserId").toString();
//			// Login user editor 권한 추가
//			String sessionAuthLev = String.valueOf(cmmMap.get("sessionAuthLev")); // 시스템 관리자
//			if (StringUtil.checkNull(result.get("AuthorID")).equals(sessionUserID)
//					|| StringUtil.checkNull(result.get("LockOwner")).equals(cmmMap.get("sessionUserId"))
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			model.put("myItem", myItem);
			model.put("itemFileOption", itemFileOption);	
			model.put("fileList", fileList);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/file/selectFilePop");
	}
	
	@RequestMapping(value = "/addFilePop.do")
	public String popupAddFile(HttpServletRequest request, HashMap cmmMap,
			ModelMap model) throws Exception {
		Map resultMap = new HashMap();
		Map result = new HashMap();
		try {
			// 임시 폴더 삭제
			String scrnType = StringUtil.checkNull(cmmMap.get("scrnType"));
			String id = StringUtil.checkNull(cmmMap.get("id")); 
			String docCategory = StringUtil.checkNull(cmmMap.get("docCategory")); 
			String changeSetID = StringUtil.checkNull(cmmMap.get("changeSetID")); 
			String projectID = StringUtil.checkNull(cmmMap.get("projectID"));
			String fltpCode = StringUtil.checkNull(cmmMap.get("fltpCode"),"");
			String delTmpFlg = StringUtil.checkNull(cmmMap.get("delTmpFlg"),"");
			
			String path = "";
			path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
			if (!path.equals("") && "Y".equals(delTmpFlg)) {
				FileUtil.deleteDirectory(path);					
			}
			model.put("scrnType", scrnType);
			model.put("docCategory", docCategory);
			model.put("browserType", StringUtil.checkNull(cmmMap.get("browserType"), "IE"));
			model.put("usrId", StringUtil.checkNull(cmmMap.get("sessionUserId")));
			model.put("mgtId", StringUtil.checkNull(cmmMap.get("mgtId")));
			model.put("id", id);
			model.put("filePath", path);
			model.put("taskID", StringUtil.checkNull(cmmMap.get("taskID")));
			model.put("fltpCodeTsk", StringUtil.checkNull(cmmMap.get("fltpCode")));
			model.put("fileID", StringUtil.checkNull(cmmMap.get("fileID")));
			model.put("isTask", StringUtil.checkNull(cmmMap.get("isTask")));
			model.put("projectID",projectID);
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
			model.put("gubun", StringUtil.checkNull(cmmMap.get("gubun")));
			model.put("fltpCode", fltpCode);
			model.put("changeSetID", changeSetID);

			if (scrnType.equals("BRD")) {
				result.put("itemClassCode", "");
				result.put("itemID", "");
			} else {
				if (!id.equals("")) {
					cmmMap.put("itemID", id);
					resultMap = fileMgtService.select("fileMgt_SQL.getItemClassCode", cmmMap);
					result.put("itemClassCode", resultMap.get("itemClassCode"));
					result.put("itemID", id);
				}
			}
			model.put("instanceNo", StringUtil.checkNull(cmmMap.get("instanceNo")));
			model.put("instanceClass", StringUtil.checkNull(cmmMap.get("instanceClass")));
			model.put("menu", getLabel(request, commonService));
		
			model.addAttribute(AJAX_RESULTMAP, result);
		

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/popup/addFilePop");
	}
	
	@RequestMapping(value = "/addFilePopV4.do")
	public String addFilePopV4(HttpServletRequest request,  HashMap cmmMap, ModelMap model) throws Exception {
		Map resultMap = new HashMap();
		Map result = new HashMap();
		try {
			// 임시 폴더 삭제
			String scrnType = StringUtil.checkNull(cmmMap.get("scrnType"));
			String id = StringUtil.checkNull(cmmMap.get("id")); 
			String docCategory = StringUtil.checkNull(cmmMap.get("docCategory")); 
			String changeSetID = StringUtil.checkNull(cmmMap.get("changeSetID")); 
			String projectID = StringUtil.checkNull(cmmMap.get("projectID"));
			String fltpCode = StringUtil.checkNull(cmmMap.get("fltpCode"),"");
			String uploadToken = StringUtil.checkNull(cmmMap.get("uploadToken"),"");
			
			String path = "";

			
//			path = GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
//			if (!path.equals("")) {
//				FileUtil.deleteDirectory(path);
//			}
			

			model.put("scrnType", scrnType);
			model.put("docCategory", docCategory);
			model.put("browserType", StringUtil.checkNull(cmmMap.get("browserType"), "IE"));
			model.put("usrId", StringUtil.checkNull(cmmMap.get("sessionUserId")));
			model.put("mgtId", StringUtil.checkNull(cmmMap.get("mgtId")));
			model.put("id", id);
			model.put("filePath", path);
			model.put("taskID", StringUtil.checkNull(cmmMap.get("taskID")));
			model.put("fltpCodeTsk", StringUtil.checkNull(cmmMap.get("fltpCode")));
			model.put("fileID", StringUtil.checkNull(cmmMap.get("fileID")));
			model.put("isTask", StringUtil.checkNull(cmmMap.get("isTask")));
			model.put("projectID",projectID);
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
			model.put("gubun", StringUtil.checkNull(cmmMap.get("gubun")));
			model.put("fltpCode", fltpCode);
			model.put("changeSetID", changeSetID);

			if (scrnType.equals("BRD")) {
				result.put("itemClassCode", "");
				result.put("itemID", "");
			} else {
				if (!id.equals("")) {
					cmmMap.put("itemID", id);
					resultMap = fileMgtService.select("fileMgt_SQL.getItemClassCode", cmmMap);
					result.put("itemClassCode", resultMap.get("itemClassCode"));
					result.put("itemID", id);
				}
			}
			model.put("instanceNo", StringUtil.checkNull(cmmMap.get("instanceNo")));
			model.put("instanceClass", StringUtil.checkNull(cmmMap.get("instanceClass")));
			model.put("menu", getLabel(request, commonService));
			
			model.put("activityLogID", StringUtil.checkNull(cmmMap.get("activityLogID")));
			model.put("speCode", StringUtil.checkNull(cmmMap.get("speCode")));
			model.put("srType", StringUtil.checkNull(cmmMap.get("srType")));
			model.put("uploadToken",uploadToken);

			model.addAttribute(AJAX_RESULTMAP, result);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/file/addFilePopV4");
	}
	
	@RequestMapping(value = "/getFileAttachModalData.do", method = RequestMethod.GET)
	public void getFileAttachModalData(
			HttpServletRequest request,
			@RequestParam HashMap<String, Object> cmmMap,
			ModelMap model,
			HttpServletResponse response
	)throws Exception {
		Map resultMap = new HashMap();
		Map result = new HashMap();
		try {
			String scrnType = StringUtil.checkNull(cmmMap.get("scrnType"));
			String id = StringUtil.checkNull(cmmMap.get("id")); 
			String docCategory = StringUtil.checkNull(cmmMap.get("docCategory")); 
			String changeSetID = StringUtil.checkNull(cmmMap.get("changeSetID")); 
			String projectID = StringUtil.checkNull(cmmMap.get("projectID"));
			String fltpCode = StringUtil.checkNull(cmmMap.get("fltpCode"),"");
			
			String path = "";

			model.put("scrnType", scrnType);
			model.put("docCategory", docCategory);
			model.put("browserType", StringUtil.checkNull(cmmMap.get("browserType"), "IE"));
			model.put("usrId", StringUtil.checkNull(cmmMap.get("sessionUserId")));
			model.put("mgtId", StringUtil.checkNull(cmmMap.get("mgtId")));
			model.put("id", id);
			model.put("filePath", path);
			model.put("taskID", StringUtil.checkNull(cmmMap.get("taskID")));
			model.put("fltpCodeTsk", StringUtil.checkNull(cmmMap.get("fltpCode")));
			model.put("fileID", StringUtil.checkNull(cmmMap.get("fileID")));
			model.put("isTask", StringUtil.checkNull(cmmMap.get("isTask")));
			model.put("projectID",projectID);
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
			model.put("gubun", StringUtil.checkNull(cmmMap.get("gubun")));
			model.put("fltpCode", fltpCode);
			model.put("changeSetID", changeSetID);

			if (scrnType.equals("BRD")) {
				result.put("itemClassCode", "");
				result.put("itemID", "");
			} else {
				if (!id.equals("")) {
					cmmMap.put("itemID", id);
					resultMap = fileMgtService.select("fileMgt_SQL.getItemClassCode", cmmMap);
					result.put("itemClassCode", resultMap.get("itemClassCode"));
					result.put("itemID", id);
				}
			}
			model.put("instanceNo", StringUtil.checkNull(cmmMap.get("instanceNo")));
			model.put("instanceClass", StringUtil.checkNull(cmmMap.get("instanceClass")));
			model.put("menu", getLabel(request, commonService));
			
			model.put("activityLogID", StringUtil.checkNull(cmmMap.get("activityLogID")));
			model.put("speCode", StringUtil.checkNull(cmmMap.get("speCode")));
			model.put("srType", StringUtil.checkNull(cmmMap.get("srType")));


        	ObjectMapper objectMapper = new ObjectMapper();
        	
            Map<String, Object> responseData = new HashMap<>(model);

            responseData.put("AJAX_RESULTMAP", result);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            response.getWriter().write(objectMapper.writeValueAsString(responseData));
            
            return; 
	        

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
	}
	
	
	
	@RequestMapping(value="/downloadExtLinkFile.do")
	 public String downloadExtLinkFile(HttpServletRequest request, HttpServletResponse response,HashMap commandMap, ModelMap model) throws Exception{

		Map target = new HashMap();
		Map setMap = new HashMap();
		Map setData = new HashMap();
		String url = "";
		
		String reqOrgiFileName[] = request.getParameter("seq").split(",");//StringUtil.checkNull(request.getParameter("originalFileName")).split(",");
		String reqSysFileName[] = request.getParameter("seq").split(",");//StringUtil.checkNull(request.getParameter("sysFileName")).split(",");
		String reqFilePath[] = request.getParameter("seq").split(",");
		String reqSeq[] = request.getParameter("seq").split(",");
		String isHom = request.getParameter("isHom");
		String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
		String returnValue = "";
		

		String path=GlobalVal.FILE_UPLOAD_BASE_DIR + commandMap.get("sessionUserId");
		if(!path.equals("")){FileUtil.deleteDirectory(path);}	

		for(int i=0; reqSeq.length>i; i++){
			setData.put("seq", reqSeq[i]);
		
			reqFilePath[i] = commonService.selectString("fileMgt_SQL.getFilePathInSeq", setData);

			reqOrgiFileName[i] = commonService.selectString("fileMgt_SQL.getFileName", setData);
			reqSysFileName[i] = reqFilePath[i] + commonService.selectString("fileMgt_SQL.getFileSysName", setData);
			downloadToDir(new URL(reqFilePath[i]),new File(GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(commandMap.get("sessionUserId"))), reqOrgiFileName[i]);
			reqOrgiFileName[i] = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(commandMap.get("sessionUserId")) + "//" + reqOrgiFileName[i];
			reqSysFileName[i] = reqOrgiFileName[i];
		
		}
		/*
		File orgiFileName = null;
		File sysFileName = null;
		String filePath = null;
		String viewName = null;
		
		try{
			int fileCnt = reqOrgiFileName.length;
			
			HashMap drmInfoMap = new HashMap();
			
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
			String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));
			
			drmInfoMap.put("userID", userID);
			drmInfoMap.put("userName", userName);
			drmInfoMap.put("teamID", teamID);
			drmInfoMap.put("teamName", teamName);
			
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
					drmInfoMap.put("DRMFileDir", StringUtil.checkNull(GlobalVal.DRM_DECODING_FILEPATH) + StringUtil.checkNull(commandMap.get("sessionUserId"))+"//");
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
					//target.put(AJAX_ALERT, "해당 파일을 서버에서 찾을 수 없습니다");
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00113"));
					model.addAttribute(AJAX_RESULTMAP, target);
				
					return nextUrl(AJAXPAGE);
				}

				if(!"".equals(returnValue)) {
					sysFileName = new File(returnValue);
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
			 
			 path = GlobalVal.FILE_UPLOAD_ZIPFILE_DIR;
			 String fullPath = GlobalVal.FILE_UPLOAD_ZIPFILE_DIR+"downFiles"+sdf2+".zip";
			 String newFileNm = "FILE_"+mkFileNm+".zip";
			 
			 File zipFile = new File(fullPath); 
			 File dirFile = new File(path);
		  
			 if(!dirFile.exists()) {
			     dirFile.mkdirs();
			 } 

			 ZipOutputStream zos = null;
			 zos = new ZipOutputStream(new FileOutputStream(zipFile));
			 
			 byte[] buffer = new byte[1024 * 2];
			 int k = 0;
			 for(String file : reqOrgiFileName) {
				 filePath = reqFilePath[k];
				 if(new File(file).isDirectory()) { continue; }
		                
		         BufferedInputStream bis = new BufferedInputStream(new FileInputStream (file)); 
		         file = file.replace(filePath, ""); 
		         
		         zos.putNextEntry(new ZipEntry(file));
		        			         
		         int length = 0;
		         while((length = bis.read(buffer)) != -1) {
		            zos.write(buffer, 0, length);
		         }
		                
		         zos.closeEntry();
		         bis.close();
		         k++;
			 }
	    	 zos.closeEntry();
             zos.close();
		
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
				if(scrnType.equals("BRD")){
					setMap.put("TableName", "TB_BOARD_ATTCH");
				} else if(scrnType.equals("ISSUE")){
					setMap.put("TableName", "TB_ISSUE_FILE");
				} else {
					setMap.put("TableName", "TB_FILE");
				}
				
				if(scrnType.equals("INST")){ 
					setMap.put("fileID",reqSeq[i]);
					fileMgtService.update("instanceFile_SQL.updateInstanceFileDownCNT", setMap);
				}else{ fileMgtService.update("fileMgt_SQL.itemFileDownCnt_update", setMap); }
			}
			String downFile = fullPath;
			request.setAttribute("downFile", downFile);
			request.setAttribute("orginFile", newFileNm);
			FileUtil.flMgtdownFile(request, response);
		
			
			//target.put(AJAX_ALERT, "파일다운로드가 완료되었습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00079"));
			target.put(AJAX_SCRIPT, "doSearchList();");
			
		}catch (Exception e) {
			 System.out.println(e);
			 throw new ExceptionUtil(e.toString());
			 //target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			 //target.put(AJAX_ALERT, "지정된 파일을 찾을 수 없습니다");
		}*/
		//model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(url);
	 }
		
	public static void downloadToDir(URL url, File dir, String FileName) throws IOException {
		if (url==null) throw new IllegalArgumentException("url is null.");
		if (dir==null) throw new IllegalArgumentException("directory is null.");
		if (!dir.exists()) dir.mkdir();
		if (!dir.isDirectory()) throw new IllegalArgumentException("directory is not a directory.");
		downloadTo(url, dir, true, FileName);
	}
	
    private static void downloadTo(URL url, File targetFile, boolean isDirectory, String fileName) throws IOException{            
    	
        HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();
        int responseCode = httpConn.getResponseCode();
 
        if (responseCode == HttpURLConnection.HTTP_OK) {
            String disposition = httpConn.getHeaderField("Content-Disposition");
            File saveFilePath=null;
            
            if (isDirectory) {
            	fileName=URLDecoder.decode(fileName);
	            saveFilePath = new File(targetFile, fileName);
            }
            else {
            	saveFilePath=targetFile;
            }
            
            InputStream inputStream = httpConn.getInputStream();
             
            FileOutputStream outputStream = new FileOutputStream(saveFilePath);
            
            try {
            	 int bytesRead = -1;
                 byte[] buffer = new byte[4096];
                 while ((bytesRead = inputStream.read(buffer)) != -1) {
                     outputStream.write(buffer, 0, bytesRead);
                 }
            } catch ( Exception e ) {
            	System.out.println(e.toString());
            	throw e;
            } finally {
            	if(outputStream != null) {
            		try {
            			outputStream.close();
            			inputStream.close();
            		} catch ( Exception e ) {
                    	System.out.println(e.toString());
                    	throw e;
                    }
            	}
            }            
            
            System.out.println("File downloaded to " + saveFilePath);
        } else {
            System.err.println("No file to download. Server replied HTTP code: " + responseCode);
        }
        httpConn.disconnect();	    
    }
    
	@RequestMapping(value = "/openViewerPop.do")
	public String openViewerPop(HttpServletRequest request, HashMap cmmMap, ModelMap model)throws Exception {
		try {
				String seq = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("seq")));
				String url = "";
				String isNew = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("isNew")));
				String useFileLog = StringUtil.checkNull(GlobalVal.USE_FILE_LOG);
				String docViewerType = StringUtil.checkNull(GlobalVal.DOC_VIEWER_TYPE);
				
				Map setMap = new HashMap();
				setMap.put("Seq", seq);
				String fileOption = StringUtil.checkNull(request.getParameter("fileOption"));
				if(useFileLog.equals("Y")) {
					// VIEWER & PDFCNVT 기록
					String ip = request.getHeader("X-FORWARDED-FOR");
			        if (ip == null)
			            ip = request.getRemoteAddr();
			        cmmMap.put("IpAddress",ip);
			        cmmMap.put("fileID", seq); 
			        cmmMap.put("fileOption", fileOption);
			        commonService.insert("fileMgt_SQL.insertFileLog",cmmMap);
				}
				if("Y".equals(isNew)) {
					if(docViewerType.equals("Polaris")) {
						url = GlobalVal.DOC_VIEWER_URL+"/file/upload/webviewer";
					}else {
						url = GlobalVal.DOC_VIEWER_URL+"/SynapDocViewServer/jobJson";
					}
				}
				else {
					url = commonService.selectString("fileMgt_SQL.getFilePathInFileTable", setMap);
				}
				commonService.update("fileMgt_SQL.itemFileDownCnt_update",setMap);
				
				setMap.put("seq", seq);
				String fileRealName = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFileName", setMap),"");
				
				model.put("fileRealName", fileRealName);
				model.put("actionURL", url);
				model.put("isNew", isNew);
				model.put("seq", seq);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("fileOption", fileOption);
		
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/file/openDocViewerPop");
	}
    
	@RequestMapping(value = "/getFileCount.do")
	public void getFileCount(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map setMap = new HashMap();
		
        res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
	    try {
	    	setMap.put("documentID", StringUtil.checkNull(request.getParameter("documentID"),""));
	    	setMap.put("changeSetID", StringUtil.checkNull(request.getParameter("changeSetID"),""));
	    	setMap.put("docCategory", StringUtil.checkNull(request.getParameter("docCategory"),""));
			String count = commonService.selectString("fileMgt_SQL.getFileCnt", setMap);
			jsonObject.put("count", count);
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        jsonObject.put("message", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
	        res.getWriter().print(jsonObject);
	    }
	}
	
	// kefico Download  전에  보안레이블 check 함수 
	@RequestMapping(value = "/checkDRM.do")
	@ResponseBody
	public String checkDRM(HttpServletRequest request, HttpServletResponse response, HashMap cmmMap, ModelMap model)throws  Exception {

		Map target = new HashMap();
		Map setMap = new HashMap();
		Map setData = new HashMap();

		String reqOrgiFileName[] = request.getParameter("seq").split(",");// StringUtil.checkNull(request.getParameter("originalFileName")).split(",");
		String reqSysFileName[] = request.getParameter("seq").split(",");// StringUtil.checkNull(request.getParameter("sysFileName")).split(",");
		String reqFilePath[] = request.getParameter("seq").split(",");
		String reqSeq[] = request.getParameter("seq").split(",");
		String reqComment[] = request.getParameter("seq").split(",");

		String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
		String returnValue = "";

		for (int i = 0; reqSeq.length > i; i++) {
			setData.put("seq", reqSeq[i]);
			if (scrnType.equals("BRD")) {
				reqFilePath[i] = commonService.selectString("boardFile_SQL.getFilePath", setData);
				reqOrgiFileName[i] = commonService.selectString("boardFile_SQL.getFileName", setData);
				reqSysFileName[i] = reqFilePath[i]
						+ commonService.selectString("boardFile_SQL.getFileSysName", setData);
			} else if (scrnType.equals("INST")) {
				setData.put("fileID", reqSeq[i]);
				reqFilePath[i] = commonService.selectString("instanceFile_SQL.getInstanceFilePath", setData);
				reqOrgiFileName[i] = commonService.selectString("instanceFile_SQL.getInstanceFileName", setData);
				reqSysFileName[i] = reqFilePath[i]
						+ commonService.selectString("instanceFile_SQL.getInstanceFileSysName", setData);
			} else {
				reqFilePath[i] = commonService.selectString("fileMgt_SQL.getFilePathInSeq", setData);
				reqOrgiFileName[i] = commonService.selectString("fileMgt_SQL.getFileName", setData);
				reqSysFileName[i] = reqFilePath[i] + commonService.selectString("fileMgt_SQL.getFileSysName", setData);
				reqComment[i] = commonService.selectString("fileMgt_SQL.getFileComment", setData);
			}
		}

		File orgiFileName = null;
		File sysFileName = null;
		String filePath = null;
		String viewName = null;
		String useFileLog = StringUtil.checkNull(GlobalVal.USE_FILE_LOG);
		String DRMFileDir = StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH)
				+ StringUtil.checkNull(cmmMap.get("sessionUserId")) + "//";
		try {
			int fileCnt = reqOrgiFileName.length;
			if (fileCnt == 1) { //파일 개수 1개 
				Map mapValue = new HashMap();
				List getList = new ArrayList();

				mapValue.put("Seq", reqSeq[0]);
				Map result = new HashMap();
				if (scrnType.equals("BRD")) {
					result = fileMgtService.select("boardFile_SQL.selectDownFile", mapValue);
					filePath = GlobalVal.FILE_UPLOAD_BOARD_DIR;
				} else if (scrnType.equals("INST")) {
					mapValue.put("fileID", reqSeq[0]);
					filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR;
					mapValue.put("FilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
					result = fileMgtService.select("instanceFile_SQL.selectDownInstanceFile", mapValue);

				} else if (scrnType.equals("ITSM")) {
					filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR;
					mapValue.put("FilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
					result = fileMgtService.select("zDLM_SQL.zdlm_selectDownFile", mapValue);
				} else {
					filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR;
					mapValue.put("FilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
					result = fileMgtService.select("fileMgt_SQL.selectDownFile", mapValue);
				}

				String filename = StringUtil.checkNull(result.get("filename"));
				String original = StringUtil.checkNull(result.get("original"));
				String downFile = StringUtil.checkNull(result.get("downFile"));
				if (!new File(downFile).exists()) {
					// target.put(AJAX_ALERT, "해당 파일 [ "+original+" ] 을 서버에서 찾을 수 없습니다");
					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00078",
							new String[] { original }));
					target.put(AJAX_SCRIPT, "setSubFrame();");
					target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
					// target.put(AJAX_NEXTPAGE, "jsp/file/fileGrpList.jsp");
					model.addAttribute(AJAX_RESULTMAP, target);

					return nextUrl(AJAXPAGE);
				}


				HashMap drmInfoMap = new HashMap();
			
				drmInfoMap.put("orgFileName", original);
				drmInfoMap.put("downFile", downFile);
				drmInfoMap.put("loginID", cmmMap.get("sessionLoginId"));
				drmInfoMap.put("sessionEmail", cmmMap.get("sessionEmail"));

				// file DRM 
				String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
				String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
				if (!"".equals(useDRM) && !"N".equals(useDownDRM)) {
					// DRMUtil.setDRM(drmInfoMap);
					drmInfoMap.put("ORGFileDir", filePath); // C://OLMFILE//document//
					drmInfoMap.put("DRMFileDir", DRMFileDir);
					drmInfoMap.put("Filename", filename);
					drmInfoMap.put("funcType", "download");
					returnValue = DRMUtil.drmMgt(drmInfoMap); // 암호화
				}

				
			} else {

			}
				

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return returnValue;
	}
	
	@RequestMapping(value="/admin/saveFltpFile.do")
	public String saveFltpFile(MultipartHttpServletRequest request, HashMap commandMap ,ModelMap model) throws Exception{
		Map target = new HashMap();
		HashMap setMap = new HashMap();
		
		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		String fltpCode = StringUtil.checkNull(xss.getParameter("fltpCode"), "");
		String linkType = StringUtil.checkNull(xss.getParameter("linkType"), "1");
		String userId = StringUtil.checkNull(xss.getParameter("userId"), "");
		
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		Iterator<String> fileNameIter = multipartRequest.getFileNames();
		setMap.put("fltpCode", fltpCode);
		String savePath = commonService.selectString("fileMgt_SQL.getFilePath", setMap);
		String filePath = "";
		String fileName = "";
		String fileRealName = "";
		String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"),"");
		
		if (fileNameIter.hasNext()) {
		    // 하나의 파일만 처리
		    String fileParamName = fileNameIter.next(); // 파일 파라미터 이름
		    MultipartFile mFile = multipartRequest.getFile(fileParamName);
		    fileRealName = mFile.getOriginalFilename();
		    if (mFile.getSize() > 0) {
		        String ext = FileUtil.getExt(fileRealName);
		        
		        HashMap resultMap = FileUtil.uploadFile(mFile, savePath, true);
		        fileName = (String) resultMap.get("SysFileNm");
		        filePath = (String) resultMap.get("FilePath");
		        
			 	int Seq = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", commandMap));
			 	setMap.put("Seq",Seq);
			 	setMap.put("DocCategory","ITM");
			 	setMap.put("LinkType",linkType);
			 	setMap.put("FileName",fileName);
			 	setMap.put("FilePath",savePath);
			 	setMap.put("FltpCode",fltpCode);
			 	setMap.put("FileRealName",fileRealName);
			 	setMap.put("FileSize",mFile.getSize());
			 	setMap.put("FileMgt","ITM");
			 	setMap.put("FileFormat",ext);
			 	setMap.put("RegMemberID",1);
			 	setMap.put("LastUser",userId);
			 	setMap.put("LanguageID",languageID);
			 	
			 	commonService.insert("fileMgt_SQL.itemFile_insert",setMap);

			 	commonService.update("fileMgt_SQL.itemFltpFile_update",setMap);    
		    }
		}  
		
        target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
        target.put(AJAX_SCRIPT, "parent.fltpReload('view');");
        
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/deleteFltpFile.do")
	public String deleteFltpFile(HttpServletRequest request, HashMap cmmMap, ModelMap model)throws Exception {
		Map target = new HashMap();
		HashMap setMap = new HashMap();
		String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"), "");
		setMap.put("FltpCode", fltpCode);
		commonService.update("fileMgt_SQL.itemFltpFile_update",setMap); 
		
	    target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069"));
	    target.put(AJAX_SCRIPT, "parent.fltpReload('view');");
	        
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value="/cxnItemFileList.do")
	public String cxnItemFileList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "file/cxnItemFileList";
		try {
			String itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");			
			String itemIDs = request.getParameter("itemIDs");
			Map setData = new HashMap();
			setData.put("itemID", itemID);
			setData.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
			Map itemTypeMap = commonService.select("common_SQL.itemTypeCode_commonSelect", setData);
			model.put("itemID", itemID);
			model.put("itemIDs", itemIDs);
			model.put("s_itemID", itemID);
			model.put("itemTypeName", StringUtil.checkNull(itemTypeMap.get("NAME")));
			model.put("itemTypeCode", StringUtil.checkNull(itemTypeMap.get("CODE")));
			
			model.put("childCXN", StringUtil.checkNull(request.getParameter("childCXN"), ""));
			model.put("cxnTypeList", StringUtil.checkNull(request.getParameter("cxnTypeList"), ""));
			model.put("filter", StringUtil.checkNull(request.getParameter("filter"), ""));
			model.put("option", StringUtil.checkNull(request.getParameter("option"), ""));
			
			cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			cmmMap.put("itemIDs", itemIDs.replace("[","").replace("]",""));
			cmmMap.put("filtered", "Y");
			List cifList = commonService.selectList("fileMgt_SQL.getCxnItemFileList_gridList",cmmMap);
			
			JSONArray gridData = new JSONArray(cifList);
			model.put("gridData",gridData);
						
			model.put("menu", getLabel(request, commonService));
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
			
		return nextUrl(url);
	}
	

	@RequestMapping(value = "/updateFileRegMember.do")
	public String updateFileRegMember(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String fileSeqs = StringUtil.checkNull(request.getParameter("fileSeqs"));
		String memberID = StringUtil.checkNull(request.getParameter("memberID"));
		String alertType =  StringUtil.checkNull(request.getParameter("alertType"), "");
		Map setMap = new HashMap();
		HashMap target = new HashMap();
		try {
			setMap.put("seq", fileSeqs);
			setMap.put("regMemberID", memberID);		
			setMap.put("userID", commandMap.get("sessionUserId"));
			
			commonService.update("fileMgt_SQL.updateFileRegMember", setMap);
			
			// 저장 성공
			if (alertType.equals("DHX")) {
				target.put(AJAX_ALERT_DHX, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
			}
			
			target.put(AJAX_SCRIPT, "doSearchList();");

		} catch (Exception e) {
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			
			// 오류 발생
			if (alertType.equals("DHX")) {
				target.put(AJAX_ALERT_DHX, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
			}
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/extFileUpdateCount.do")
	public String extFileUpdateCount(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
			HashMap setMap = new HashMap();
			String fileSeq = StringUtil.checkNull(request.getParameter("fileSeq"));
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"),"");
			String useFileLog = StringUtil.checkNull(GlobalVal.USE_FILE_LOG);
			
			setMap.put("Seq",fileSeq);
			setMap.put("seq",fileSeq);
			// 각 파일 테이블의 [DownCNT] update
			if(scrnType.equals("BRD")){
				setMap.put("TableName", "TB_BOARD_ATTCH");
			} else if(scrnType.equals("ISSUE")){
				setMap.put("TableName", "TB_ISSUE_FILE");
			} else {
				setMap.put("TableName", "TB_FILE");
			}

			commonService.update("fileMgt_SQL.itemFileDownCnt_update", setMap);
			target.put(AJAX_ALERT, ""); // 삭제 성공
			target.put(AJAX_SCRIPT, "");
			
			String comment = commonService.selectString("fileMgt_SQL.getFileComment", setMap);
			if(useFileLog.equals("Y")) {
				//ExtLink기록
				String ip = request.getHeader("X-FORWARDED-FOR");
		        if (ip == null)
		            ip = request.getRemoteAddr();  
				cmmMap.put("IpAddress",ip);
			    cmmMap.put("fileID", fileSeq); 
			    cmmMap.put("comment", comment);
			    cmmMap.put("fileOption", "ExtLink");
			    commonService.insert("fileMgt_SQL.insertFileLog",cmmMap);
			}
		}
		catch(Exception e) {			
			System.out.println(e.toString());
			throw new ExceptionUtil(e.toString());
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);		
		return nextUrl(AJAXPAGE);		
		
	}
	
	@RequestMapping(value = "/modExtFilePop.do")
	public String modExtFilePop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			// 임시 폴더 삭제
			String reqSeq =  StringUtil.checkNull(request.getParameter("seqList"), "");
			String browserType =  StringUtil.checkNull(request.getParameter("browserType"), "");
			String isNew =  StringUtil.checkNull(request.getParameter("isNew"), "N");
			String itemClassCode =  StringUtil.checkNull(request.getParameter("itemClassCode"), "");
			String DocumentID =  StringUtil.checkNull(request.getParameter("DocumentID"), "");
			String seq[] = reqSeq.split(",");
			
			if(!"Y".equals(isNew)) {
				setMap.put("Seq", reqSeq);
				
				List fileList = commonService.selectList("fileMgt_SQL.getExtModFileList", setMap);
				model.put("fileList",fileList);
				
			}
			model.put("menu", getLabel(request, commonService));
			model.put("browserType",browserType);
			model.put("isNew",isNew);
			model.put("DocumentID",DocumentID);
			model.put("itemClassCode",itemClassCode);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/file/modExtFilePop");
	}
	
	@RequestMapping(value = "/saveEditExtFile.do")
	public String saveEditExtFile(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();		
		try{
			Map setMap = new HashMap();
			
			int maxCount = Integer.parseInt(StringUtil.checkNull(request.getParameter("maxCount"),"0"));
			String isNew = StringUtil.checkNull(request.getParameter("isNew"),"N");
			
			if ("Y".equals(isNew)) {
				for (int i = 0; i < maxCount ; i++) {
					String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"),""); 
					String name = StringUtil.checkNull(request.getParameter("Name_0"),"");
					String path = StringUtil.checkNull(request.getParameter("Path_0"),""); 
					String DocumentID = StringUtil.checkNull(request.getParameter("DocumentID"),""); 
					
					String seq = commonService.selectString("fileMgt_SQL.itemFile_nextVal", setMap);
					
					setMap.put("FltpCode", fltpCode);
					setMap.put("DocumentID", DocumentID);
					
					String projectID = commonService.selectString("model_SQL.getItemProjectID", setMap);
					String docCategory = commonService.selectString("fileMgt_SQL.getFltpDocCategory", setMap);
					String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),GlobalVal.DEFAULT_LANGUAGE);
					
					setMap.put("DocCategory", docCategory);
					setMap.put("FileRealName", name);
					setMap.put("FileFormat", FileUtil.getExt(name));
					//path = new String(URLEncoder.encode(path,"UTF-8"));
					setMap.put("Seq", seq);
					setMap.put("LinkType","EXT");
					setMap.put("FilePath", path);
					setMap.put("FileName", "");
					setMap.put("projectID", projectID);
					setMap.put("FileSize", 0);
					setMap.put("FileMgt", docCategory);
					setMap.put("userId", cmmMap.get("sessionUserId"));
					setMap.put("LanguageID", languageID);
					
					commonService.insert("fileMgt_SQL.itemFile_insert", setMap);
				}
			} else {
				for (int i = 0; i < maxCount ; i++) {
					String seq = StringUtil.checkNull(request.getParameter("ID_"+i),"");
					String name = StringUtil.checkNull(request.getParameter("Name_"+i),"");
					String path = StringUtil.checkNull(request.getParameter("Path_"+i),""); 
					String code = StringUtil.checkNull(request.getParameter("Code_"+i),"");
					
					setMap.put("FileRealName", name);
					//path = new String(URLEncoder.encode(path,"UTF-8"));
					setMap.put("Seq", seq);
					setMap.put("FilePath", path);
					setMap.put("fileOption", "ExtLink");
					setMap.put("userId", cmmMap.get("sessionUserId"));
					
					commonService.update("fileMgt_SQL.updateExtFile", setMap);
				}
			}			
				
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();parent.selfClose();");	
		}catch(Exception e){
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);		
		return nextUrl(AJAXPAGE);		
	}
	
	@RequestMapping(value = "/setDocViewerFilePath.do")
	public String setDocViewerFilePath(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String key = request.getParameter("key");
		String seq = request.getParameter("seq");
		String fid = request.getParameter("fid");
		String filePath = request.getParameter("filePath");
		String fileType = request.getParameter("fileType");
		String sync = request.getParameter("sync");
		String fileOption = request.getParameter("fileOption");	
		String id = request.getParameter("id");	
		String stamp = request.getParameter("stamp");	
		String docViewerType = StringUtil.checkNull(GlobalVal.DOC_VIEWER_TYPE);
		
		Map setMap = new HashMap();
		HashMap target = new HashMap();
		String url = GlobalVal.DOC_VIEWER_URL+"/SynapDocViewServer/viewer/doc.html?key="+key+"&contextPath=/SynapDocViewServer";
		//String url ="";
		if(docViewerType.equals("Polaris")) {
			if(fileOption.equals("PDFCNVT")) {
				url = GlobalVal.DOC_VIEWER_URL+"/viewer/"+id+"?stamp="+stamp;
			}else {
				url = GlobalVal.DOC_VIEWER_URL+"/viewer/"+id+"?stamp="+stamp;
			}
		}else {
			if(fileOption.equals("PDFCNVT")) {
				url = GlobalVal.DOC_VIEWER_URL+"/SynapDocViewServer/convert?fid="+fid+"&filePath="+filePath+"&fileType=URL&sync=true&convertType=2";
			}
		}
		try {
			setMap.put("Seq", seq);
			setMap.put("FilePath", url);		
//			setMap.put("userId", commandMap.get("sessionUserId"));
			setMap.put("flag", "Y");
			
			commonService.update("fileMgt_SQL.updateExtFile", setMap);
			//target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00150")); // 상신 완료
			target.put(AJAX_SCRIPT,"parent.fnCallback('"+url+"');parent.$('#isSubmit').remove()");

		} catch (Exception e) {
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/viewerFileDownload.do")
	public String viewerFileDownload(HttpServletRequest request, HashMap cmmMap, HttpServletResponse response) throws Exception {
		String seq = request.getParameter("seq");
		Map setMap = new HashMap();
		String filename = "";
		String original = "";
		String downFile = "";
		
		setMap.put("Seq", seq);
		Map fileInfo = commonService.select("fileMgt_SQL.selectDownFile",setMap);
		
		original = (String)fileInfo.get("original");
		filename = (String)fileInfo.get("filename");
		downFile = (String)fileInfo.get("downFile");
		
		HashMap drmInfoMap = new HashMap();
		// File DRM 복호화
		String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
		String DRM_UPLOAD_USE = StringUtil.checkNull(GlobalVal.DRM_UPLOAD_USE);
		if(!"".equals(useDRM) && "N".equals(DRM_UPLOAD_USE)){
			drmInfoMap.put("ORGFileDir", StringUtil.checkNull(fileInfo.get("FilePath")));	
			drmInfoMap.put("DRMFileDir", GlobalVal.FILE_UPLOAD_TMP_DIR);
			drmInfoMap.put("Filename", StringUtil.checkNull(fileInfo.get("filename")));	
			drmInfoMap.put("FileRealName", StringUtil.checkNull(fileInfo.get("filename")));		
			
			drmInfoMap.put("loginID", cmmMap.get("sessionLoginId"));
			drmInfoMap.put("sessionEmail", cmmMap.get("sessionEmail"));
			drmInfoMap.put("funcType", "upload");
			
			String returnValue = DRMUtil.drmMgt(drmInfoMap); // 복호화 
			downFile = GlobalVal.FILE_UPLOAD_TMP_DIR+filename;
		}
				
		if ("".equals(filename)) {
			request.setAttribute("message", "File not found.");
			return null;
		}

		if ("".equals(original)) {
			original = filename;
		}

		request.setAttribute("downFile", downFile);
		request.setAttribute("orginFile", original); // 20140627 request.setAttribute("orginFile", enOriginal); 수정

		FileUtil.downFile(request, response);

		return null;
	}
	
	// 파일 공통 
	@RequestMapping(value="/fileListMgt.do")
	public String fileListMgt(HttpServletRequest request, HttpServletResponse response, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = StringUtil.checkNull(request.getParameter("url"), "file/itemFileList");	
		try {
				// Label setting 
				model.put("menu", getLabel(request, commonService));
				String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");	
				String DocumentID = StringUtil.checkNull(request.getParameter("DocumentID"), s_itemID);	
				String fileOption = StringUtil.checkNull(request.getParameter("fileOption"),"OLM");	
				String varFilter = StringUtil.checkNull(request.getParameter("varFilter"));
				String listFilterType = StringUtil.checkNull(request.getParameter("listFilterType"), "");	
				
				Map fileMap = new HashMap();
	
				// File 권한 체크
				fileMap.put("itemId", DocumentID);
				Map result  = fileMgtService.select("fileMgt_SQL.selectItemAuthorID",fileMap);
				model.put("selectedItemAuthorID", StringUtil.checkNull(result.get("AuthorID")));
				model.put("selectedItemBlocked", StringUtil.checkNull(result.get("Blocked")));
				model.put("selectedItemLockOwner", StringUtil.checkNull(result.get("LockOwner")));
				model.put("itemClassCode", StringUtil.checkNull(result.get("ClassCode")));
				model.put("selectedItemStatus", StringUtil.checkNull(result.get("Status")));
				model.put("docCategory", StringUtil.checkNull(request.getParameter("DocCategory"))); // docCategory(ITM/...) ITEM/ESM/CSR 
				model.put("myDoc", StringUtil.checkNull(request.getParameter("myDoc"))); // 내문서 
				
				// itemFileOption 체크 (itemId) - VIEWER
				String itemFileOption = fileMgtService.selectString("fileMgt_SQL.getFileOption",fileMap);
				model.put("itemFileOption", itemFileOption);
				
				// FileOption 체크 - OLM / ExtLink
				if(!"".equals(varFilter)){
					model.put("fileOption", varFilter);
				}else {
					model.put("fileOption", fileOption);
				}
				
				// myItem 체크
				String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
				
				String csrEditable = StringUtil.checkNull(result.get("csrEditable"));
				if("Y".equals(csrEditable)) {
					myItem = "Y";
				}
				model.put("myItem", myItem);
							
				// 업로드 권한 체크 ( myItem이 Y인 경우만 가능 )
				String uploadYN = commonService.selectString("fileMgt_SQL.getFileUploadYN", fileMap);
				if(!"".equals(StringUtil.checkNull(request.getParameter("uploadYN")))){
					uploadYN = StringUtil.checkNull(request.getParameter("uploadYN"));
				}
				model.put("uploadYN", uploadYN);
				
				// file 관련 옵션
				model.put("itemBlocked", StringUtil.checkNull(result.get("Blocked"), "")); 
				model.put("backBtnYN", request.getParameter("backBtnYN")); // 화면의 back 버튼 출력 여부 
				
				// file List 를 위한 value
				String langFilter = StringUtil.checkNull(cmmMap.get("langFilter")); 
				model.put("langFilter", langFilter);
				model.put("DocumentID", DocumentID);
				model.put("s_itemID", DocumentID);
				
				// file upload를 위한 session 등록
				HttpSession session = request.getSession(true);
				String uploadToken = fileUploadUtil.makeFileUploadFolderToken(session);
				model.put("uploadToken", uploadToken);
				
				// USE_FILE_LOG
				String USE_FILE_LOG = StringUtil.checkNull(GlobalVal.USE_FILE_LOG);
				model.put("USE_FILE_LOG", USE_FILE_LOG);
				
				Map setMap = new HashMap();	
				
				String screenType = StringUtil.checkNull(request.getParameter("screenType"), ""); 
				// main > 첨부문서 
				String docType = StringUtil.checkNull(request.getParameter("docType"), ""); 
				String isMember = StringUtil.checkNull(request.getParameter("isMember"), ""); 
				String isPublic = StringUtil.checkNull(request.getParameter("isPublic"), ""); 
				String DocCategory = StringUtil.checkNull(request.getParameter("DocCategory"), "ITM"); 
				String regMemberName = StringUtil.checkNull(request.getParameter("regMemberName"), "");
							
				String parentID = StringUtil.checkNull(request.getParameter("parentID"), ""); 
				String projectID = StringUtil.checkNull(request.getParameter("projectID"), ""); 
				if(screenType.equals("mainV3") || screenType.equals("csrDtl")){
					Map projectMap = new HashMap();
					setMap.put("parentID", parentID);
					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
					projectMap = commonService.select("task_SQL.getProjectAuthorID",setMap);
					model.put("projectMap", projectMap);
					model.put("projectID", projectID);
					model.put("isMember", isMember);
				}
				
				if(screenType.equals("main")){
					model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
					model.put("searchKey", StringUtil.checkNull(request.getParameter("searchKey")));
					model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
					model.put("itemClassCode", StringUtil.checkNull(request.getParameter("itemClassCode")));
				}
				
				model.put("parentID", parentID);
				model.put("DocCategory", DocCategory);
				model.put("regMemberName", regMemberName);
				model.put("docType", docType);
				model.put("screenType", screenType);
				model.put("isPublic", isPublic);
				model.put("csrEditable", csrEditable);
				
				model.put("docCategory", DocCategory); // ITM
				Map itemTypeMap = commonService.select("common_SQL.itemTypeCode_commonSelect", cmmMap);
				model.put("showValid",StringUtil.checkNull(request.getParameter("showValid"), "N")); // subItemFileList 컬럼 시행일 show/hidden 여부 varFilter
				model.put("itemTypeName", StringUtil.checkNull(itemTypeMap.get("NAME")));
				model.put("itemTypeCode", StringUtil.checkNull(itemTypeMap.get("CODE")));
				
			} catch (Exception e) {
				System.out.println(e);
				throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
}