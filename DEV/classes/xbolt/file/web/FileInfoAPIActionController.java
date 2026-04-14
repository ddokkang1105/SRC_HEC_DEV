package xbolt.file.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

public class FileInfoAPIActionController  extends XboltController{
	
	@Resource(name = "commonService")
	private CommonService commonService;
	@Autowired
    private FileUploadUtil fileUploadUtil;
	
	// 첨부파일 리스트
	@RequestMapping(value = "getItemFileListInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public void getItemFileListInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {

	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");

	    JSONObject resultMap = new JSONObject();
	    Map setMap = new HashMap();

	    boolean success = false;

	    try {

	        // parameter
	    	String languageID   = StringUtil.checkNull(request.getParameter("languageID"), "");
	        String DocumentID   = StringUtil.checkNull(request.getParameter("DocumentID"), "");
	        String DocCategory  = StringUtil.checkNull(request.getParameter("DocCategory"), "");
	        // search option
	        String docDomain = StringUtil.checkNull(request.getParameter("docDomain"), "");
	        String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"), "");
	        String classCode = StringUtil.checkNull(request.getParameter("classCode"), "");
	        String myDoc = StringUtil.checkNull(request.getParameter("myDoc"), "");
	        String sessionUserId = StringUtil.checkNull(request.getParameter("sessionUserId"), "");
	        String deleted = StringUtil.checkNull(request.getParameter("deleted"), "");
	        String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"), "");
	        String parentID = StringUtil.checkNull(request.getParameter("parentID"), "");
	        String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
	        String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
	        String ownerTeamID = StringUtil.checkNull(request.getParameter("ownerTeamID"), "");
	        String refPjtID = StringUtil.checkNull(request.getParameter("refPjtID"), "");
	        String rltdItemId = StringUtil.checkNull(request.getParameter("rltdItemId"), "");
	        String s_itemID  = StringUtil.checkNull(request.getParameter("s_itemID"), "");
	        String searchValue = StringUtil.checkNull(request.getParameter("searchValue"), "");
	        String searchKey = StringUtil.checkNull(request.getParameter("searchKey"), "");
	        String updatedStartDT = StringUtil.checkNull(request.getParameter("updatedStartDT"), "");
	        String updatedEndDT = StringUtil.checkNull(request.getParameter("updatedEndDT"), "");
	        String regMemberName = StringUtil.checkNull(request.getParameter("regMemberName"), "");
	        String path = StringUtil.checkNull(request.getParameter("path"), "");
	        String isPublic    = StringUtil.checkNull(request.getParameter("isPublic"), "");
	        String fileListYN  = StringUtil.checkNull(request.getParameter("fileListYN"), "");
	        String hideBlocked  = StringUtil.checkNull(request.getParameter("hideBlocked"), "");
	        String showFilePath = StringUtil.checkNull(request.getParameter("showFilePath"), "");
	        String langFilter = StringUtil.checkNull(request.getParameter("langFilter"), "");

	        // parameter put
	        setMap.put("languageID", languageID);
	        setMap.put("DocCategory", DocCategory);
	        // option parameter put
	        setMap.put("DocumentID", DocumentID);
	        setMap.put("docDomain", docDomain);
	        setMap.put("itemTypeCode", itemTypeCode);
	        setMap.put("classCode", classCode);
	        setMap.put("myDoc", myDoc);
	        setMap.put("sessionUserId", sessionUserId);
	        setMap.put("deleted", deleted);
	        setMap.put("fltpCode", fltpCode);
	        setMap.put("parentID", parentID);
	        setMap.put("projectID", projectID);
	        setMap.put("changeSetID", changeSetID);
	        setMap.put("ownerTeamID", ownerTeamID);
	        setMap.put("refPjtID", refPjtID);
	        setMap.put("rltdItemId", rltdItemId);
	        setMap.put("s_itemID", s_itemID);
	        setMap.put("searchValue", searchValue);
	        setMap.put("searchKey", searchKey);
	        setMap.put("updatedStartDT", updatedStartDT);
	        setMap.put("updatedEndDT", updatedEndDT);
	        setMap.put("regMemberName", regMemberName);
	        setMap.put("path", path);
	        setMap.put("isPublic", isPublic);
	        setMap.put("fileListYN", fileListYN);
	        setMap.put("hideBlocked", hideBlocked);
	        setMap.put("showFilePath", showFilePath);
	        setMap.put("langFilter", langFilter);

	        // select
	        List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);

	        resultMap.put("data", attachFileList);
	        success = true;

	    } catch (IllegalArgumentException e) {
	        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	        resultMap.put("message", e.getMessage());
	        System.err.println(e);
	    } catch (DataAccessException e) {
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
	
	// file detail
	@RequestMapping(value = "getItemFileInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public void getItemFileInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();
		
		Map fileMap  = new HashMap();
		boolean success = false;
		
		try {
	        
			// parameter
			String seq = StringUtil.checkNull(request.getParameter("seq"), "");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			
			// parameter check
			if (seq.isEmpty()) {
	             throw new IllegalArgumentException("seq is required.");
	        }
			
			// file detail
			setMap.put("seq", seq);
			setMap.put("languageID", languageID);
			fileMap = commonService.select("fileMgt_SQL.getFileDetailList", setMap);
			
			success = true;
			resultMap.put("data", fileMap);
			
	        
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
	
	// file log
	@RequestMapping(value = "getFileLog.do", method = RequestMethod.GET)
	@ResponseBody
	public void getFileLog(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();
		
		List LogList = new ArrayList();
		boolean success = false;
		
		try {
	        
			// parameter
			String seq = StringUtil.checkNull(request.getParameter("seq"), "");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			String USE_FILE_LOG = StringUtil.checkNull(GlobalVal.USE_FILE_LOG);
			
			// parameter check
			if (seq.isEmpty()) {
	             throw new IllegalArgumentException("seq is required.");
	        }
			
			if("Y".equals(USE_FILE_LOG)) {
				// file detail
				setMap.put("seq", seq);
				setMap.put("languageID", languageID);
				setMap.put("blankPhotoUrlPath", GlobalVal.HTML_IMG_DIR + "/blank_photo.png");	
				setMap.put("photoUrlPath", GlobalVal.EMP_PHOTO_URL);	
				
				LogList = (List)commonService.selectList("fileMgt_SQL.getFileLogInfo", setMap);
				
				success = true;
				resultMap.put("data", LogList);
				
			} else {
				throw new Exception("USE_FILE_LOG is required.");
			}
	        
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
}