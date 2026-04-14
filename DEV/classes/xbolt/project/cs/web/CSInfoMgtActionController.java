package xbolt.project.cs.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.org.json.JSONArray;
import com.org.json.JSONException;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.file.util.FileUploadUtil;
import xbolt.project.cs.dto.ChangeSetListInfoDTO;

/**
 * 업무 처리
 * 
 * @Class Name : MainCsInfoMgtActionController.java
 * @Description : cs 관련 main 자바 
 * @Modification Information
 * @수정일 수정자 수정내용
 * @--------- --------- -------------------------------
 * @2012. 09. 01. smartfactory 최초생성
 * 
 * @since 2026. 01. 26.
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")
public class CSInfoMgtActionController extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Autowired
    private FileUploadUtil fileUploadUtil;
//	@Resource(name = "CSService")
//	private CommonService CSService;
	
	
	private static final ObjectMapper DTO_MAPPER;

	    static {
	        DTO_MAPPER = new ObjectMapper();
	        DTO_MAPPER.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.NONE);
	        DTO_MAPPER.setVisibility(PropertyAccessor.FIELD, JsonAutoDetect.Visibility.ANY);
	    }

	    
	@RequestMapping(value = "/itemHistoryV4.do")
	public String itemHistoryV4(ChangeSetListInfoDTO csInfoDTO,HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		
		String url = StringUtil.checkNull(request.getParameter("varFilter"),"");
		Map setMap = new HashMap();
		
		//parameter 
		
		String s_itemID = StringUtil.checkNull(csInfoDTO.getS_itemID());
		String isFromTask = StringUtil.checkNull(request.getParameter("isFromTask")); // 사용여부 체크

		try {
			if("".equals(url)) {
				url = "/project/cs/itemHistoryV4";
			}
			

			model.put("s_itemID", s_itemID);
			model.put("isFromTask", isFromTask);
			model.put("menu", getLabel(request, commonService));
			
			// popup 여부 체크
			String pop = StringUtil.checkNull(request.getParameter("pop"));
			if(pop.equals("pop")){
				model.put("backBtnYN", "N");
			}
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	

    
    
    @RequestMapping(value = "/myChangeSetV4.do")
    public String myChangeSetV4(ChangeSetListInfoDTO csInfoDTO,HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

        String url = "project/cs/myChangeSetV4";
        Map<String, String> setMap = new HashMap<String, String>();
        
      
        String languageID = StringUtil.checkNull(csInfoDTO.getLanguageID(),String.valueOf(commandMap.get("sessionCurrLangType")));
        String authorID = StringUtil.checkNull(csInfoDTO.getAuthorID(),String.valueOf(commandMap.get("memberId")));

        // parameter check

        
        try {

     
            setMap.put("languageID", languageID);
            setMap.put("DocCategory", "CS");
            String wfURL = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", setMap));
            
            model.put("wfURL", wfURL);
            model.put("isPop", StringUtil.checkNull(request.getParameter("isPop"), "N"));
            model.put("currPageA", StringUtil.checkNull(request.getParameter("currPageA"), "1"));
           
            model.put("authorID", authorID);
            model.put("hideTitle", StringUtil.checkNull(request.getParameter("hideTitle")));
            model.put("menu", getLabel(request, commonService)); /* Label Setting */
            
            
            
        } catch (Exception e) {
            System.out.println(e);
            throw new ExceptionUtil(e.toString());
        }

        return nextUrl(url);
    }
    
    
    @RequestMapping(value = "/changeSetInfoListV4.do")
	public String changeSetInfoListV4(ChangeSetListInfoDTO csInfoDTO,HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {



		String url = StringUtil.checkNull(request.getParameter("url"),"project/cs/changeSetInfoList");
    	Map<String, Object> setMap = new HashMap();
    	List<Map<String, Object>> classCodeList = new ArrayList();
    	
    	//param
	
		String screenType = StringUtil.checkNull(csInfoDTO.getScreenType());		
		String isFromPjt = StringUtil.checkNull(csInfoDTO.getIsFromPjt());
		String modStartDT = StringUtil.checkNull(csInfoDTO.getModStartDT());	
		String modEndDT = StringUtil.checkNull(csInfoDTO.getModEndDT());	
		
		String projectID = StringUtil.checkNull(csInfoDTO.getProjectID(),request.getParameter("csrID")); 
		//String isMember = StringUtil.checkNull(request.getParameter("isMember"));
		String csrStatus = StringUtil.checkNull(csInfoDTO.getCsrStatus());
		String classCodes = StringUtil.checkNull(csInfoDTO.getClassCodes());
	

		try {

				
			model.put("modStartDT",modStartDT);
			model.put("modEndDT",modEndDT);

			//changeSetOfCSRV4 초기 셋팅값 (계층, 담당자) 
		
			setMap.put("s_itemID", StringUtil.checkNull(projectID));
			setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			Map projectInfoMap = commonService.select("project_SQL.getProjectInfo", setMap);
			model.put("Creator", projectInfoMap.get("Creator"));
			model.put("classCodes", classCodes);
			model.put("screenMode", StringUtil.checkNull(request.getParameter("screenMode")));
			model.put("isMine", StringUtil.checkNull(request.getParameter("isMine")));
			model.put("status", StringUtil.checkNull(request.getParameter("status")));
			model.put("changeType", StringUtil.checkNull(request.getParameter("changeType")));
			model.put("myTeam", StringUtil.checkNull(request.getParameter("myTeam")));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
			model.put("isFromPjt", isFromPjt);
			model.put("myPjtId", projectID);
			model.put("closingOption", StringUtil.checkNull(request.getParameter("closingOption")));
			model.put("authorID", StringUtil.checkNull(projectInfoMap.get("AuthorID")));
			model.put("currPageA", StringUtil.checkNull(request.getParameter("currPageA"), "0"));
			if(!screenType.equals("CSR")){
			model.put("refID", projectID);
			model.put("projectID", projectID);
			}
			setMap.put("Status", "CLS");
			setMap.put("DocCategory", "CS");
			String wfURL = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", setMap));
	        List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);	
            model.put("dimTypeList", dimTypeList);
			model.put("wfURL",wfURL);
			model.put("csrID", StringUtil.checkNull(request.getParameter("csrID")));
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("screenType", screenType);
			model.put("csrStatus", csrStatus);
			model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
			//model.put("isMember", isMember);
			model.put("chgsts", StringUtil.checkNull(request.getParameter("chgsts"))); // mainHomeSKH(Revision FullScreen)
		    commandMap.put("csrID", model.get("csrID"));
		  
		    
		    
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl(url);
	}
	
    
    //팝업 cs 상세 조회화면 
    @RequestMapping(value = "/viewItemCSInfo.do")
	public String viewItemCSInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
    	
    	Map getMap = new HashMap();
    	Map setMap = new HashMap();
    	String screenMode = StringUtil.checkNull(request.getParameter("screenMode"));
    	String isMyTask = StringUtil.checkNull(request.getParameter("isMyTask"));
    	String itemID = StringUtil.checkNull(commandMap.get("seletedTreeId"));
    	String projectID = StringUtil.checkNull(commandMap.get("ProjectID"));
    	String changeSetID = StringUtil.checkNull(commandMap.get("changeSetID"));
    	
    	if(itemID.equals("")){
    		itemID = StringUtil.checkNull(commandMap.get("itemID"));
    	}
    	
		try {

			getMap.put("languageID", commandMap.get("sessionCurrLangType"));


			
			//api 01  변경이력상세 
			getMap.put("ChangeSetID", request.getParameter("changeSetID"));
			setMap = commonService.select("cs_SQL.getChangeSetList_gridList", getMap);
			model.put("getData", setMap);
			
			Map setData = new HashMap();
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			setData.put("itemID", itemID);
			
			setData.put("changeSetID", commandMap.get("changeSetID"));
			setData.put("userID", commandMap.get("sessionUserId"));

			getMap.put("DocCategory", "CS");
			String wfURL = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", getMap));

			
			//api 첨부파일 리스트 
			setData = new HashMap();
			setData.put("changeSetID", commandMap.get("changeSetID"));
			setData.put("languageID", request.getParameter("languageID"));
			setData.put("isPublic", "N");
			setData.put("DocCategory", "CS");
			
			List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setData);
			model.put("attachFileList",attachFileList);
			
			model.put("StatusCode", StringUtil.checkNull(setMap.get("StatusCode")));
			model.put("CSRStatusCode", StringUtil.checkNull(setMap.get("CSRStatusCode")));
			model.put("isAuthorUser", StringUtil.checkNull(request.getParameter("isAuthorUser")));
			model.put("ProjectID", projectID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("screenMode", screenMode);
			model.put("isMyTask", isMyTask);
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
			model.put("currPageA", StringUtil.checkNull(request.getParameter("currPageA"), "1"));
			model.put("isFromPjt", StringUtil.checkNull(request.getParameter("isFromPjt")));
			model.put("s_itemID", StringUtil.checkNull(commandMap.get("seletedTreeId")));
			model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
			model.put("isStsCell", StringUtil.checkNull(request.getParameter("isStsCell")));
			model.put("changeSetID", changeSetID);
			model.put("wfURL", wfURL);
			
	
			setData = new HashMap();
			setData.put("itemID", itemID);
			setData.put("changeSetID", changeSetID);
			setData.put("rNum", "1"); 	
			String lastChangeSetID = commonService.selectString("cs_SQL.getNextPreChangeSetID", setData);

			if(lastChangeSetID != null && lastChangeSetID.equals(changeSetID)){
				model.put("lastChangeSet", "Y");						
			}else{
				model.put("lastChangeSet", "N");
			}
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("project/cs/viewItemCSInfo");
	}

    
	@RequestMapping(value = "/editItemCSInfo.do")
	public String editItemCSInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		Map getMap = new HashMap();
		Map setMap = new HashMap();
		String screenMode = StringUtil.checkNull(request.getParameter("screenMode"));
		String isMyTask = StringUtil.checkNull(request.getParameter("isMyTask"));
		String itemID = StringUtil.checkNull(commandMap.get("seletedTreeId"));
		String projectID = StringUtil.checkNull(commandMap.get("ProjectID"));
		String changeSetID = StringUtil.checkNull(commandMap.get("changeSetID"));
		String languageID = StringUtil.checkNull(commandMap.get("languageID"));
		
		
		if(itemID.equals("")){
			itemID = StringUtil.checkNull(commandMap.get("itemID"));
		}
		
		try {

		    String path = GlobalVal.FILE_UPLOAD_BASE_DIR + commandMap.get("sessionUserId");
			if(!path.equals("")){FileUtil.deleteDirectory(path);}
			getMap.put("languageID", request.getParameter("LanguageID"));
			getMap.put("ChangeSetID", changeSetID);
			setMap = commonService.select("cs_SQL.getChangeSetList_gridList", getMap);
			model.put("getData", setMap);
			
			Map setData = new HashMap();
			setData.put("languageID", languageID);
			setData.put("itemID", itemID);
			
			setData.put("changeSetID", commandMap.get("changeSetID"));
			setData.put("userID", commandMap.get("sessionUserId"));
						
			setData.put("s_itemID", itemID);
			List nOdList = commonService.selectList("item_SQL.getNewORDelListForCS", setData); 
					
			setMap.put("DocCategory", "CS");
			String LanguageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			setMap.put("languageID", LanguageID);
			String wfURL = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", setMap));
			
			String checkInOption = StringUtil.checkNull(request.getParameter("checkInOption"));
			String changeReviewCnt = "";
			if("03B".equals(checkInOption) || "01B".equals(checkInOption)) {
				changeReviewCnt = commonService.selectString("cs_SQL.getCountChangeReview", setData);
			}

			model.put("wfURL",wfURL);
			model.put("nOdList",nOdList);
			
			model.put("StatusCode", StringUtil.checkNull(setMap.get("StatusCode")));
			model.put("CSRStatusCode", StringUtil.checkNull(setMap.get("CSRStatusCode")));
			model.put("ProjectID", projectID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("screenMode", screenMode);
			model.put("isMyTask", isMyTask);
			model.put("ChangeType", StringUtil.checkNull(request.getParameter("ChangeType")));
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
			model.put("currPageA", StringUtil.checkNull(request.getParameter("currPageA"), "1"));
			model.put("isFromPjt", StringUtil.checkNull(request.getParameter("isFromPjt")));
			model.put("s_itemID", StringUtil.checkNull(commandMap.get("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(commandMap.get("isItemInfo")));
			model.put("changeSetID", changeSetID);
			model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
			model.put("isStsCell", StringUtil.checkNull(request.getParameter("isStsCell")));
			model.put("scrnType", StringUtil.checkNull(request.getParameter("scrnType")));

			setData.put("changeSetID", commandMap.get("changeSetID"));
			setData.put("languageID", LanguageID);
			setData.put("isPublic", "N");
			setData.put("DocCategory", "CS");
		
			List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setData);

			model.put("attachFileList", attachFileList);
			
			setData = new HashMap();
			setData.put("itemID", itemID);
			setData.put("changeSetID", changeSetID);
			setData.put("rNum", "1"); 	
			String lastChangeSetID = commonService.selectString("cs_SQL.getNextPreChangeSetID", setData);
			if(lastChangeSetID != null && lastChangeSetID.equals(changeSetID)){
				model.put("lastChangeSet", "Y");				
			}else{
				model.put("lastChangeSet", "N");
			}
			
			// checkInOption [01B] [03B] 일 때, 제/개정 검토의견 체크 
			model.put("checkInOption", checkInOption);
			model.put("changeReviewCnt", changeReviewCnt);
			
			// FLTP에 CSDOC 존재 시 attach 옵션 사용 가능
			setData.put("FltpCode", "CSDOC");
			String fileTypeCount = commonService.selectString("config_SQL.fileTypeEqualCount", setData);
			model.put("fileTypeCount",fileTypeCount);
			
			// file upload를 위한 session 등록
			HttpSession session = request.getSession(true);
			String uploadToken = fileUploadUtil.makeFileUploadFolderToken(session);
			model.put("uploadToken", uploadToken);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("project/cs/editItemCSInfo");
	}
	
}
