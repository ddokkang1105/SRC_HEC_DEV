package xbolt.file.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.PrintWriter;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.org.json.JSONArray;
import com.org.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
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
import xbolt.file.util.FileUploadUtil;
import xbolt.cmm.framework.val.DrmGlobalVal;

import org.apache.commons.text.StringEscapeUtils;
import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipOutputStream;

import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;

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

public class FileMgtActionController  extends XboltController{
	
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;
	@Autowired
    private FileUploadUtil fileUploadUtil;
	
	/** 문자 인코딩 */
	private static final String CHARSET = "euc-kr";

	
	
	
	
	
	
	
	@RequestMapping(value="/goMultiUpload.do")
	public String goMultiUpload(HttpServletRequest request, HttpServletResponse response) throws  ServletException, IOException, Exception {
		
		String url = "file/multiFileUploadJ";
		try {
			
			 	/*MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;	
			    MultiValueMap<String, MultipartFile> map = multipartRequest.getMultiFileMap();
			 	
					if(map != null) {
						Iterator iter = map.keySet().iterator();
						while(iter.hasNext()) {
							String str = (String) iter.next();
							List<MultipartFile> fileList =  map.get(str);
							for(MultipartFile mpf : fileList) {
								File localFile = new File("c:\\temp\\" + StringUtils.trimAllWhitespace(mpf.getOriginalFilename()));
								OutputStream out = new FileOutputStream(localFile);
								out.write(mpf.getBytes());
								out.close();							
							}
						}
					}
			        return null;*/
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/goMultiUploadFl.do")
	public String goMultiUploadFl(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "file/multiFileUploadFl";
		String itemID = StringUtil.checkNull(request.getParameter("itemId"), "1");
		Map resultValue = new HashMap();
		Map result = new HashMap();
		try {
				cmmMap.put("itemID", itemID);
				resultValue = fileMgtService.select("fileMgt_SQL.getItemClassCode", cmmMap);
				result.put("itemClassCode", resultValue.get("itemClassCode"));
				result.put("itemID", itemID);
				model.put("menu", getLabel(request, commonService));
				model.addAttribute(AJAX_RESULTMAP, result);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
			
		return nextUrl(url);
	}
	
	
	@RequestMapping(value="/goFileMdlMgt.do")
	public String goFileMdlMgt(HttpServletRequest request, ModelMap model) throws  Exception {
		String url = "file/fileMdlMgt";
		String itemId = StringUtil.checkNull(request.getParameter("s_itemID"), "-1");
		String option  = StringUtil.checkNull(request.getParameter("option"), "-1");
		try {
				model.put("itemId", itemId);
				model.put("option", option);
				model.put("menu", getLabel(request, commonService));
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
			
		return nextUrl(url);
	}
	
	
	
	@RequestMapping(value="/goFileMdlDetail.do")
	public String goFileMdlDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "file/fileMdlDetail";
		String isNew = StringUtil.checkNull(request.getParameter("isNew"), "");
		String fileSeq = StringUtil.checkNull(request.getParameter("fileSeq"), "");
		String fileName = StringUtil.checkNull(request.getParameter("fileName"), "");
		String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"), "");
		String creationTime = StringUtil.checkNull(request.getParameter("creationTime"), "");
		String writeUserNM = StringUtil.checkNull(request.getParameter("writeUserNM"), "");
		String sysFile = StringUtil.checkNull(request.getParameter("sysFile"), "");
		String fltpName = StringUtil.checkNull(request.getParameter("fltpName"), "");
		String ID = StringUtil.checkNull(request.getParameter("s_itemID"), "-1");
		String itemClassCode = ""; 
		
		List fileList = new ArrayList();
		Map fileMap = null;
		Map resultValue = new HashMap();
		try {
				Map result = new HashMap();
				if("Y".equals(cmmMap.get("isNEW"))){ // 신규
					result.put("isNew", isNew);
					result.put("fileSeq", "");
					result.put("fileName", "");
					result.put("fltpCode", "");
					result.put("creationTime","");
					result.put("WriteUserNM","");
					result.put("sysFile", "");
					result.put("fltpName", "");
					result.put("itemID",request.getParameter("itemId"));
					result.put("menu", getLabel(request, commonService));
					result.put("isNEW",cmmMap.get("isNEW"));
					cmmMap.put("itemID",request.getParameter("itemId"));
					resultValue = fileMgtService.select("fileMgt_SQL.getItemClassCode", cmmMap);
					result.put("itemClassCode", resultValue.get("itemClassCode"));
					
					model.put("isNEW", cmmMap.get("isNEW"));
					model.put("menu", getLabel(request, commonService));
					model.addAttribute(AJAX_RESULTMAP, result);
				}else{
					result.put("isNew", isNew);
					result.put("fileSeq", fileSeq);
					result.put("fileName", fileName);
					result.put("fltpCode", fltpCode);
					result.put("creationTime",creationTime);
					result.put("WriteUserNM",writeUserNM);
					result.put("sysFile", sysFile);
					result.put("fltpName", fltpName);
					result.put("itemID",request.getParameter("itemId"));
					result.put("menu", getLabel(request, commonService));
					result.put("isNEW",cmmMap.get("isNEW"));
					cmmMap.put("itemID",request.getParameter("itemId"));
					resultValue = fileMgtService.select("fileMgt_SQL.getItemClassCode", cmmMap);
					result.put("itemClassCode", resultValue.get("itemClassCode"));
										
					model.put("isNEW", cmmMap.get("isNEW"));
					model.put("menu", getLabel(request, commonService));
					model.addAttribute(AJAX_RESULTMAP, result);
				}
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
			
		return nextUrl(url);
	}
	
	
	@RequestMapping(value="/fileDetail.do")
	public String fileDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "file/fileDetail";
		try {
			//임시저장된 파일이 존재할 수 있으므로 삭제
			String path=GlobalVal.FILE_UPLOAD_BASE_DIR + cmmMap.get("sessionUserId");
			if(!path.equals("")){FileUtil.deleteDirectory(path);}	
			
			Map fileMap  = new HashMap();
			Map setMap = new HashMap();
			String seq = StringUtil.checkNull(request.getParameter("seq"), "");
			String isNew = StringUtil.checkNull(request.getParameter("isNew"), "");
			String DocumentID = StringUtil.checkNull(request.getParameter("DocumentID"), "");
			String itemClassCode = StringUtil.checkNull(request.getParameter("itemClassCode"), "");
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"), "");
			
			setMap.put("seq", seq);
			setMap.put("DocumentID", DocumentID);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			if(isNew.equals("N")){
				fileMap = commonService.select("fileMgt_SQL.getFileDetailList",setMap);
			}
			List logList = commonService.selectList("fileMgt_SQL.getFileLogInfo", setMap);
			model.put("logList", logList);
			JSONArray gridData = new JSONArray(logList);
			model.put("gridData",gridData);
			
			//fileMap.put("DocumentID", DocumentID);
			model.put("fileMap", fileMap);
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("isNew", isNew);
			model.put("itemClassCode", itemClassCode);
			model.put("isPossibleEdit", "Y");			
			model.put("selectedItemBlocked", StringUtil.checkNull(request.getParameter("selectedItemBlocked"), ""));
			model.put("selectedItemAuthorID", StringUtil.checkNull(request.getParameter("selectedItemAuthorID"), ""));
			model.put("selectedItemLockOwner", StringUtil.checkNull(request.getParameter("selectedItemLockOwner"), ""));
			model.put("RefFileID", StringUtil.checkNull(request.getParameter("refFileID"), ""));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("scrnType", scrnType);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
			
		return nextUrl(url);
	}
	
	
	
	@RequestMapping(value="/saveTaskFile.do")
	public String saveTaskFile(MultipartHttpServletRequest request,HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		Map target = new HashMap();
		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		try{
			for (Iterator i = cmmMap.entrySet().iterator(); i.hasNext();) {
			    Entry e = (Entry) i.next(); // not allowed
			    if(!e.getKey().equals("loginInfo") && e.getValue() != null) {
			    	cmmMap.put(e.getKey(), xss.stripXSS(e.getValue().toString()));
			    }
			}
			String itemID 	= StringUtil.checkNull(xss.getParameter("itemID"), "");			
			String fltpCode = StringUtil.checkNull(xss.getParameter("fltpCode"), "");
			String fileMgt 	= StringUtil.checkNull(xss.getParameter("fileMgt"), "ITM");
			String userId 	= StringUtil.checkNull(StringUtil.checkNull(cmmMap.get("sessionUserId")), "");
			String linkType = StringUtil.checkNull(xss.getParameter("linkType"), "1");
			String fileID = StringUtil.checkNull(xss.getParameter("fileID"), "");
			String parentID = StringUtil.checkNull(xss.getParameter("parentID"), "");
			String projectID = StringUtil.checkNull(xss.getParameter("projectID"), "");			
			String changeSetID = StringUtil.checkNull(xss.getParameter("changeSetID"), "");
			String csrAuthorID = StringUtil.checkNull(xss.getParameter("csrAuthorID"), "");
			//taskResult fileUpload 추가 
			String sysfile = StringUtil.checkNull(xss.getParameter("sysFile"), "");
			String taskID = StringUtil.checkNull(xss.getParameter("taskID"), "");
			String taskTypeCode = StringUtil.checkNull(xss.getParameter("taskTypeCode"), "");
			
			//기존파일 삭제 
			File existFile = new File(sysfile); 
			if(existFile.isFile() && existFile.exists()){existFile.delete();}
			
			List fileList = new ArrayList();
			Map fileMap = new HashMap();;
			Map setMap = new HashMap();
			setMap.put("fltpCode",fltpCode);
			
			String filePath = StringUtil.checkNull(fileMgtService.selectString("fileMgt_SQL.getFilePath",setMap));
			File dirFile = new File(filePath);if(!dirFile.exists()) { dirFile.mkdirs();} 
			
			if("".equals(fileID)){ // 신규 등록				
				Iterator fileNameIter = request.getFileNames();
				String savePath = filePath; // 폴더 바꾸기				
				String fileName = "";
				int Seq = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", cmmMap));
				int seqCnt = 0;
				
				while (fileNameIter.hasNext()) {
				   MultipartFile mFile = request.getFile((String)fileNameIter.next());
				   fileName = mFile.getName();
				   
				   if (mFile.getSize() > 0) {						   
					   fileMap = new HashMap();
					   HashMap resultMap = FileUtil.uploadFile(mFile, savePath, true);
					   
					   fileMap.put("Seq", Seq);
					   fileMap.put("DocumentID", itemID);
					   fileMap.put("LinkType", linkType);
					   fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
					   fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
					   fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
					   fileMap.put("FilePath", resultMap.get(FileUtil.FILE_PATH));	
					   fileMap.put("FltpCode", fltpCode);
					   fileMap.put("FileMgt", fileMgt);
					   fileMap.put("userId", userId);
					   fileMap.put("projectID", projectID);
					   fileMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
					   fileMap.put("KBN", "insert");
					   fileMap.put("DocCategory", "ITM");
					   fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");
					
					   fileList.add(fileMap);
					   seqCnt++;
				   }
				}	
				fileMgtService.save(fileList, fileMap);
				
				if(taskID.equals("")){
					Map getMap = new HashMap();
					getMap.put("itemID", itemID);
					getMap.put("category", "A");
					getMap.put("changeSetID", changeSetID);
					getMap.put("taskTypeCode", taskTypeCode);
					taskID = StringUtil.checkNull(commonService.selectString("task_SQL.getTaskID",getMap),"");
				}
				if(taskID.equals("")){ // taskResult Actual == null일때 
					taskID = commonService.selectString("task_SQL.getMaxTaskID", setMap);
					setMap.put("taskID", taskID);
					setMap.put("seq", taskID);
					setMap.put("taskTypeCode", taskTypeCode);
					setMap.put("itemID", itemID);
					setMap.put("fileID", Seq);
					setMap.put("actor", userId);
					setMap.put("category", "A");
					setMap.put("changeSetID", changeSetID);
					setMap.put("userID", userId);
					commonService.insert("task_SQL.insertTask", setMap);
				}else{
					// task에 fileSeq update
					setMap.put("fileID", Seq);
					setMap.put("taskID", StringUtil.checkNull(cmmMap.get("taskID"), taskID));
					setMap.put("userId", userId);
					commonService.update("task_SQL.updateTaskFileID", setMap);
				}
				
			}else{ // 파일 수정
				Iterator fileNameIter = request.getFileNames();
				String savePath = filePath;
				String fileName = "";
				int Seq = Integer.parseInt(fileID);
				int seqCnt = 0;
				
				while (fileNameIter.hasNext()) {
				   MultipartFile mFile = request.getFile((String)fileNameIter.next());
				   fileName = mFile.getName();					   
				   if (mFile.getSize() > 0) {						   
					   fileMap = new HashMap();
					   HashMap resultMap = FileUtil.uploadFile(mFile, savePath, true);						   
					   fileMap.put("Seq", Seq);
					   fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
					   fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
					   fileMap.put("FltpCode", fltpCode);
					   fileMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
					   fileMap.put("sessionUserId", userId);
					   fileMap.put("KBN", "update");
					   fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_update"); 						   
					   fileList.add(fileMap);
					   seqCnt++;
				   }
				}	
					fileMgtService.save(fileList, fileMap);
			}
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("changeSetID", changeSetID);
			model.put("itemID", itemID);
			model.put("projectID", projectID);
			model.put("csrAuthorID", csrAuthorID);
			model.put("parentID", parentID);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT,  "parent.$('#isSubmit').remove();parent.fnCallBack();");
			
		}catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/saveCsrFile.do")
	public String saveCsrFile(HttpServletRequest request,HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		Map target = new HashMap();
		Map fileMap  = new HashMap();
		List fileList = new ArrayList();
		try{
			int seqCnt = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", cmmMap));
			String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");	
			fileMap.put("projectID", projectID);
			String linkType = StringUtil.checkNull(cmmMap.get("linkType"), "1");
			
			cmmMap.put("fltpCode", "CSRDF");
			String filePath = StringUtil.checkNull(fileMgtService.selectString("fileMgt_SQL.getFilePath",cmmMap),GlobalVal.FILE_UPLOAD_ITEM_DIR);
			String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(cmmMap.get("sessionUserId"))+"//";
			String targetPath = filePath;
			
			System.out.println("filePath :: "+filePath);
			File dirFile = new File(filePath);if(!dirFile.exists()) { dirFile.mkdirs();} 
			List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
			
			if(tmpFileList.size() != 0){
				for(int i=0; i<tmpFileList.size();i++){
					fileMap=new HashMap(); 
					HashMap resultMap=(HashMap)tmpFileList.get(i);
					fileMap.put("Seq", seqCnt);
					fileMap.put("DocumentID", projectID);
					fileMap.put("projectID", projectID);
					fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
					fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
					fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
					fileMap.put("FilePath", filePath);
					fileMap.put("FileFormat", resultMap.get(FileUtil.FILE_EXT));
					fileMap.put("FileMgt", "PJT");
					fileMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
					fileMap.put("userId", cmmMap.get("sessionUserId"));
					fileMap.put("LinkType", linkType);
					fileMap.put("FltpCode", "CSRDF");
					fileMap.put("KBN", "insert");
					fileMap.put("DocCategory", "PJT");
					fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");					
					fileList.add(fileMap);
					seqCnt++;
				}
			}
			
			if(fileList.size() != 0){
				fileMgtService.save(fileList, fileMap);
			}
			target.put(AJAX_SCRIPT,  "parent.viewMessage();parent.$('#isSubmit').remove();");
		}catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.dhtmlx.alert('" + MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068") + "');parent.$('#isSubmit').remove();");
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	// Manage external files
	
	
	
}