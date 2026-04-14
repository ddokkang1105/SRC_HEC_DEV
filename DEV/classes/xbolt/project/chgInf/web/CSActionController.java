package xbolt.project.chgInf.web;

import java.io.File;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.net.URL;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.namespace.QName;
import javax.xml.rpc.Call;
import javax.xml.rpc.ParameterMode;
import javax.xml.rpc.Service;
import javax.xml.rpc.ServiceFactory;

import org.apache.axis.description.ParameterDesc;
import org.apache.tools.ant.taskdefs.ManifestTask.Mode;
import org.eclipse.jdt.internal.compiler.lookup.InferenceContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.org.json.JSONArray;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.file.util.FileUploadUtil;

/**
 * 업무 처리
 * 
 * @Class Name : ChangeInfoActionController.java
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
public class CSActionController extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "CSService")
	private CommonService CSService;
	
	@Autowired
    private FileUploadUtil fileUploadUtil;
	
	@RequestMapping(value = "/ObjectHistoryGrid.do")
	public String ObjectHistoryGrid(HttpServletRequest request, ModelMap model)
			throws Exception {
		try {
			Map setMap = new HashMap();
			setMap.put("C", "제정");
			setMap.put("D", "폐기");
			setMap.put("U", "개정");

			model.put("changeClassList", setMap);
			model.put("menu", getLabel(request, commonService));
			model.put("s_itemID", request.getParameter("s_itemID"));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/project/changeInfo/ObjectHistoryGrid");
	}
			

	@RequestMapping(value = "/itemHistory.do")
	public String itemHistory(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = StringUtil.checkNull(request.getParameter("varFilter"),"");
		try {
			Map setMap = new HashMap();
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String isFromTask = StringUtil.checkNull(request.getParameter("isFromTask"));
						
			if("".equals(url)) {
				url = "/project/changeInfo/itemHistory";
			}
			
			setMap.put("userId", commandMap.get("sessionUserId"));
			setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", s_itemID);
			setMap.put("ProjectType", "CSR");
			setMap.put("isMainItem", "Y");
			List projectNameList = commonService.selectList("project_SQL.getProjectNameList", setMap);

			model.put("s_itemID", s_itemID);
			model.put("myItem", StringUtil.checkNull(request.getParameter("myItem")));
			model.put("itemStatus", StringUtil.checkNull(request.getParameter("itemStatus")));
			model.put("projectNameList", projectNameList);
			model.put("menu", getLabel(request, commonService));
			model.put("isFromTask", isFromTask);
			model.put("backBtnYN", StringUtil.checkNull(request.getParameter("backBtnYN")));
			String pop = StringUtil.checkNull(request.getParameter("pop"));
			if(pop.equals("pop")){
				model.put("backBtnYN", "N");
			}
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List changeSetList = commonService.selectList("cs_SQL.getItemChangeList_gridList", setMap);
			
			JSONArray gridData = new JSONArray(changeSetList);
			model.put("gridData", gridData);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	

	@RequestMapping(value = "/changeInfoList.do")
	public String changeInfoList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {


		String url = "project/changeInfo/changeSetofCSR";
		Map setMap = new HashMap();
		List classCodeList = new ArrayList();
		List pjtList = new ArrayList();
		List csrList = new ArrayList();
		
		String isFromPjt = StringUtil.checkNull(request.getParameter("isFromPjt"));
		String projectID = StringUtil.checkNull(request.getParameter("projectID"),""); 
		String screenType = StringUtil.checkNull(request.getParameter("screenType"));		
		String isMember = StringUtil.checkNull(request.getParameter("isMember"));
		String csrStatus = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("csrStatus")));
		String classCodes = StringUtil.checkNull(request.getParameter("classCodes"));
		String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));	
		String modStartDT = StringUtil.checkNull(request.getParameter("modStartDT"));	
		String modEndDT = StringUtil.checkNull(request.getParameter("modEndDT"));	
		
		String clsStartDt = StringUtil.checkNull(request.getParameter("clsStartDt"));	
		String clsEndDt = StringUtil.checkNull(request.getParameter("clsEndDt"));	

		try {
										
			if (scrnType.equals("ARC") || "0".equals(StringUtil.checkNull(request.getParameter("mainMenu")))) {
				url = "project/changeInfo/changeSet";

				commandMap.put("Category", "CNGSTS");
				List statusList = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);
				model.put("statusList", statusList);
				
				commandMap.put("Category", "CNGT1");
				List changeTypeList = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);
				model.put("changeTypeList", changeTypeList);

				if (!projectID.isEmpty()) {
					
					if(screenType.equals("PG")){
					    setMap.put("RefPGID", projectID);
					}else{
						setMap.put("RefPjtID", projectID);
					}
				}
				
				model.put("modStartDT",modStartDT);
				model.put("modEndDT",modEndDT);
				model.put("clsStartDt",clsStartDt);
				model.put("clsEndDt",clsEndDt);
			}

				setMap.put("ProjectType", "PJT");
				setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				pjtList = commonService.selectList("project_SQL.getParentPjtList", setMap);
				
				// 愿��젴 CSR 由ъ뒪�듃
			
				setMap.put("ProjectType", "CSR");
				csrList = commonService.selectList("project_SQL.getParentPjtList", setMap);


				setMap.put("LanguageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				setMap.put("isMine", StringUtil.checkNull(request.getParameter("isMine")));
				classCodeList = commonService.selectList("cs_SQL.getClassCodeList", setMap);
				model.put("classCodeList", classCodeList);
			
			setMap.put("s_itemID", StringUtil.checkNull(request.getParameter("ProjectID")));
			setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			Map projectInfoMap = commonService.select("project_SQL.getProjectInfo", setMap);


			setMap.put("ChangeMgt", "1");
			classCodeList = commonService.selectList("item_SQL.getClassCodeOption", setMap);
			model.put("classCodeList", classCodeList);


			setMap.put("Creator", StringUtil.checkNull(projectInfoMap.get("Creator")));
			List memberList = commonService.selectList("project_SQL.getProjectMemberList", setMap);
			model.put("memberList", memberList);
			
			model.put("classCodes", classCodes);
			model.put("pjtCreator", StringUtil.checkNull(projectInfoMap.get("Creator")));
			model.put("pjtStatus", StringUtil.checkNull(projectInfoMap.get("Status")));
			model.put("pjtWfId", StringUtil.checkNull(projectInfoMap.get("WFID")));
			model.put("screenMode", StringUtil.checkNull(request.getParameter("screenMode")));
			model.put("isMine", StringUtil.checkNull(request.getParameter("isMine")));
			model.put("status", StringUtil.checkNull(request.getParameter("status")));
			model.put("changeType", StringUtil.checkNull(request.getParameter("changeType")));
			model.put("myTeam", StringUtil.checkNull(request.getParameter("myTeam")));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			setMap.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID")));
			setMap.put("projectID", StringUtil.checkNull(request.getParameter("ProjectID")));
			setMap.put("Status", "CLS");
			model.put("clsCount", commonService.selectString("cs_SQL.getCNGTCount", setMap));
			model.put("itemCount", commonService.selectString("cs_SQL.getProjectItemCount", setMap));
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
			model.put("pjtList", pjtList);
			model.put("csrList", csrList);
		
			model.put("isFromPjt", isFromPjt);
			model.put("myPjtId", projectID);
			model.put("closingOption", StringUtil.checkNull(request.getParameter("closingOption")));
			model.put("authorID", StringUtil.checkNull(projectInfoMap.get("AuthorID")));
			model.put("currPageA", StringUtil.checkNull(request.getParameter("currPageA"), "0"));

			if(!screenType.equals("CSR")){
			model.put("refID", projectID);
			model.put("projectID", projectID);
			}

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
			model.put("isMember", isMember);
			model.put("chgsts", StringUtil.checkNull(request.getParameter("chgsts"))); // mainHomeSKH(Revision FullScreen)
		
			commandMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			commandMap.put("screenType",screenType);
			commandMap.put("pageNum", StringUtil.checkNull(request.getParameter("currPageA"), "0"));
			commandMap.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
			commandMap.put("authorName", StringUtil.checkNull(request.getParameter("authorName")));
			commandMap.put("isNotIn", StringUtil.checkNull(request.getParameter("isNotIn")));
			commandMap.put("DimTypeID", StringUtil.checkNull(request.getParameter("dimTypeID")));
			String dimValueID = StringUtil.checkNull(request.getParameter("dimValueID"), "");
			String[] dimValueIDs = dimValueID.split(",");
			commandMap.put("DimValueID", dimValueIDs);
 			
			commandMap.put("modStartDt",modStartDT);
			commandMap.put("modEndDt",modEndDT);
						
		    List<String> chsList = commonService.selectList("cs_SQL.getChangeSetMultiList_gridList",commandMap);
		    JSONArray gridData = new JSONArray(chsList);
		    model.put("chgSetData", gridData);
		
		    commandMap.put("csrID", model.get("csrID"));
		  
		    
		    
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl(url);
	}

	@RequestMapping(value = "/viewItemChangeInfo.do")
	public String viewItemChangeInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {

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
						
			getMap.put("languageID", commandMap.get("sessionCurrLangType"));

			List changeTypeList = commonService.selectList("cs_SQL.getChangeTypeList", getMap);
			
			getMap.put("ChangeSetID", request.getParameter("changeSetID"));
			setMap = commonService.select("cs_SQL.getChangeSetList_gridList", getMap);
			
			String wfInstanaceID = StringUtil.checkNull(setMap.get("WFInstanceID"));
			model.put("getData", setMap);
			
			Map setData = new HashMap();
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			setData.put("itemID", itemID);
			
			setData.put("changeSetID", commandMap.get("changeSetID"));
			setData.put("userID", commandMap.get("sessionUserId"));
			Map evaluationClassMap = new HashMap();
			if(!itemID.equals("")){
				evaluationClassMap = commonService.select("project_SQL.getEvaluationClassInfo", setData);
			}
			
			getMap.put("DocCategory", "CS");
			String wfURL = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", getMap));
			
			setData.put("s_itemID", itemID);
			List revisionList = commonService.selectList("cs_SQL.getRevisionListForCS", setData); 
		//	List nOdList = commonService.selectList("item_SQL.getNewORDelListForCS", setData); 
			
			setData = new HashMap();
			setData.put("changeSetID", commandMap.get("changeSetID"));
			setData.put("languageID", request.getParameter("languageID"));
			setData.put("isPublic", "N");
			setData.put("DocCategory", "CS");
			
			List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setData);
			
			model.put("revisionList",revisionList);
		//	model.put("nOdList",nOdList);
			model.put("attachFileList",attachFileList);
			
			model.put("StatusCode", StringUtil.checkNull(setMap.get("StatusCode")));
			model.put("CSRStatusCode", StringUtil.checkNull(setMap.get("CSRStatusCode")));
			model.put("isAuthorUser", StringUtil.checkNull(request.getParameter("isAuthorUser")));
			model.put("ProjectID", projectID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("screenMode", screenMode);
			model.put("isMyTask", isMyTask);
			model.put("changeTypeList", changeTypeList);
			model.put("ChangeType", StringUtil.checkNull(request.getParameter("ChangeType")));
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
			model.put("currPageA", StringUtil.checkNull(request.getParameter("currPageA"), "1"));
			model.put("isFromPjt", StringUtil.checkNull(request.getParameter("isFromPjt")));
			model.put("myPjtId", StringUtil.checkNull(request.getParameter("myPjtId")));
			model.put("s_itemID", StringUtil.checkNull(commandMap.get("seletedTreeId")));

			model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
			model.put("isStsCell", StringUtil.checkNull(request.getParameter("isStsCell")));

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

		return nextUrl("project/changeInfo/viewItemChangeInfo");
	}


	@RequestMapping(value = "/editItemChangeInfo.do")
	public String editItemChangeInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {

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
						
		    String path = GlobalVal.FILE_UPLOAD_BASE_DIR + commandMap.get("sessionUserId");
			if(!path.equals("")){FileUtil.deleteDirectory(path);}
			
			getMap.put("languageID", request.getParameter("LanguageID"));

			List changeTypeList = commonService.selectList("cs_SQL.getChangeTypeList", getMap);
			
			getMap.put("ChangeSetID", changeSetID);
			setMap = commonService.select("cs_SQL.getChangeSetList_gridList", getMap);
			model.put("getData", setMap);
			
			Map setData = new HashMap();
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			setData.put("itemID", itemID);
			
			setData.put("changeSetID", commandMap.get("changeSetID"));
			setData.put("userID", commandMap.get("sessionUserId"));
						
			setData.put("s_itemID", itemID);
			List revisionList = commonService.selectList("cs_SQL.getRevisionListForCS", setData); 
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
			
			model.put("revisionList",revisionList);
			
			model.put("wfURL",wfURL);
			model.put("nOdList",nOdList);
			
			model.put("StatusCode", StringUtil.checkNull(setMap.get("StatusCode")));
			model.put("CSRStatusCode", StringUtil.checkNull(setMap.get("CSRStatusCode")));
			model.put("isAuthorUser", StringUtil.checkNull(request.getParameter("isAuthorUser")));
			model.put("ProjectID", projectID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("screenMode", screenMode);
			model.put("isMyTask", isMyTask);
			model.put("changeTypeList", changeTypeList);
			model.put("ChangeType", StringUtil.checkNull(request.getParameter("ChangeType")));
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
			model.put("currPageA", StringUtil.checkNull(request.getParameter("currPageA"), "1"));
			model.put("isFromPjt", StringUtil.checkNull(request.getParameter("isFromPjt")));
			model.put("myPjtId", StringUtil.checkNull(request.getParameter("myPjtId")));
			model.put("s_itemID", StringUtil.checkNull(commandMap.get("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(commandMap.get("isItemInfo")));
			
			model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
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
			// System.out.println("-- latestChangeSetID: "+latestChangeSet);
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

		return nextUrl("project/changeInfo/editItemChangeInfo");
	}
	
	// Save ChangeSet Evaluation Score 
	@RequestMapping("/saveEVSore.do")
	public String saveEVSore(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setData = new HashMap();			
			HashMap insertEVMSTData = new HashMap();
			HashMap insertEVSCRData = new HashMap();
			HashMap updateData = new HashMap();
			
			String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String sessionTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String itemID = StringUtil.checkNull(commandMap.get("itemId"));
			String csrID = StringUtil.checkNull(commandMap.get("ProjectID"));
			String changeSetID = StringUtil.checkNull(commandMap.get("ChangeSetID"));
			String evaluationClassCode = StringUtil.checkNull(commandMap.get("evaluationClassCode"));
			String attrTypeCodeList[] = StringUtil.checkNull(commandMap.get("attrTypeCodeList")).split(",");
			String dataTypeList[] = StringUtil.checkNull(commandMap.get("dataTypeList")).split(",");
			String evType = StringUtil.checkNull(commandMap.get("evType"));
			String evSeq = "";
			String evUnitCode = "";
			String evScore = "";
			String evValue = "";
			String lovCode = "";
			String dataType = "";
			
			setData.put("evType", evType);
			setData.put("evClass", evaluationClassCode);
			setData.put("objectID", itemID);
			setData.put("projectID", csrID);
			setData.put("changSetID", changeSetID);
			setData.put("userID", sessionUserID);
			String evaluationID = StringUtil.checkNull(commonService.selectString("project_SQL.getEvaluationID", setData));
			if(evaluationID.equals("")){				
				evaluationID = commonService.selectString("project_SQL.getMaxEvaluationID", setData);
				insertEVMSTData.put("evaluationID", evaluationID);
				insertEVMSTData.put("evType", evType);
				insertEVMSTData.put("evClass", evaluationClassCode);
				insertEVMSTData.put("objectID", itemID);
				insertEVMSTData.put("projectID", csrID);
				insertEVMSTData.put("changeSetID", changeSetID);
				insertEVMSTData.put("evaluatorID", sessionUserID);
				insertEVMSTData.put("teamID", sessionTeamID);
				commonService.insert("project_SQL.insertEVMST", insertEVMSTData);
			}
			for(int i=0; attrTypeCodeList.length > i; i++){
				evUnitCode = StringUtil.checkNull(attrTypeCodeList[i]);
				dataType =  StringUtil.checkNull(dataTypeList[i]);
				if(dataType.equals("LOV")){
					evScore = StringUtil.checkNull(commandMap.get("evScore"+evUnitCode)); 
				}else{
					evValue = StringUtil.checkNull(commandMap.get("evValue"+evUnitCode));
				}
				evSeq = StringUtil.checkNull(commandMap.get("evSeq"+evUnitCode));
				lovCode = StringUtil.checkNull(commandMap.get("lovCode"+evUnitCode));
				if(evSeq.equals("")){ // INSERT TB_EV_SCORE
					evSeq = commonService.selectString("project_SQL.getMaxEVSeqID", setData);
					insertEVSCRData.put("evaluationID", evaluationID);
					insertEVSCRData.put("evSeq", evSeq);
					insertEVSCRData.put("evUnitCode", evUnitCode);
					insertEVSCRData.put("evValue", evValue);
					insertEVSCRData.put("lovCode", lovCode);	
					insertEVSCRData.put("evScore", evScore);	
					commonService.insert("project_SQL.insertEVScore", insertEVSCRData);
					evValue = "";
					
				}else{ // UPDATE TB_EV_SCORE
					updateData.put("evSeq", evSeq);
					updateData.put("evValue", evValue);
					updateData.put("evScore", evScore);
					updateData.put("lovCode", lovCode);
					updateData.put("evaluationID", evaluationID);
					commonService.update("project_SQL.updateEVScore", updateData);
				}
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
			target.put(AJAX_SCRIPT,"parent.fnCallBack();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); 
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	/**
	 *
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackFor = Exception.class)
	@RequestMapping(value = "/admin/saveNewChangeSet.do")
	public String saveNewChangeSet(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		HashMap target = new HashMap();
		HashMap fileMap = new HashMap();
		HashMap setMap = new HashMap();
		String errorMessage = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068");
		
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("itemId"));
			String screenMode = StringUtil.checkNull(request.getParameter("screenMode"));

			if (screenMode.equals("edit")) {
				updateChangeSetForCsr(request, s_itemID);
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
				target.put(AJAX_SCRIPT, "parent.fnCallBackSave();parent.$('#isSubmit').remove();");
			} else {
				String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
				String childLevel = StringUtil.checkNull(request.getParameter("childLevel"),"0");
				insertChangeSetForCsr(commandMap, s_itemID, projectID,childLevel,"");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
				target.put(AJAX_SCRIPT, "this.thisReload();this.$('#isSubmit').remove();");
			}
			

			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String ChangeSetID = StringUtil.checkNull(request.getParameter("ChangeSetID"));
			setMap.put("itemID", s_itemID);
			String curChangeSetID = StringUtil.checkNull(commonService.selectString("project_SQL.getCurChangeSetIDFromItem",setMap));
			String projectID = StringUtil.checkNull(commandMap.get("ProjectID"));	
			
			if("".equals(ChangeSetID))
				ChangeSetID = curChangeSetID;
			
			// file upload 공통 사용
			Map fileUploadMap = new HashMap();
			String uploadToken = StringUtil.checkNull(commandMap.get("uploadToken"), "");
			commandMap.put("fltpCode", "CSDOC");
			commandMap.put("fileMgt", "ITM"); 
			commandMap.put("DocumentID", ChangeSetID);
			commandMap.put("ItemID", s_itemID); 
			commandMap.put("ChangeSetID", curChangeSetID);
			commandMap.put("userId", userID);
			commandMap.put("projectID", projectID);
			commandMap.put("DocCategory", "CS");	
			commandMap.put("uploadToken",uploadToken);
			
			fileUploadMap = fileUploadUtil.fileUpload(commandMap, request);
			
			boolean fileUploadResult = (boolean) fileUploadMap.getOrDefault("result",false);
			if(!fileUploadResult) {
				errorMessage = StringUtil.checkNull(fileUploadMap.get("message"),"파일 업로드 실패");
				throw new Exception(errorMessage);
			}

		} catch (Exception e) {
			System.out.println(e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, errorMessage);  
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	/**
	 * delete ChangeSet
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteChangeSet.do")
	public String deleteChangeSet(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		HashMap updateCommandMap = new HashMap();

		try {

			String items = StringUtil.checkNull(request.getParameter("items"),""); // ChangeSetID
			String ids = StringUtil.checkNull(request.getParameter("ids"), ""); // ItemID
			String childLevel = StringUtil.checkNull(request.getParameter("childLevel"),"0");
			
			if (!items.isEmpty()) {
				String[] itemsArray = items.split(",");
				String[] idsArray = ids.split(",");
				for (int i = 0; itemsArray.length > i; i++) {
					
					/* delete TB_CHANGE_SET, TB_TASK */
					setMap.put("ChangeSetID", itemsArray[i]);
					commonService.delete("cs_SQL.delChangeSetInfo", setMap);
					
					/* update Item (Blocked=2, ProjectID = null, LockChangeSet = null) */
					setMap.put("s_itemID", idsArray[i]);
					// NEW1, DEL1
					if ("MOD1".equals(commonService.selectString("project_SQL.getItemStatus", setMap))) {
						setMap.put("Status", "REL");
					}
					setMap.put("Blocked", "2");
					setMap.put("ProjectID", "Del");
					setMap.put("CurChangeSet", "Del");
					commonService.update("project_SQL.updateItemStatus", setMap);
					
					/* update (Blocked=2, ProjectID = null) */ 
					List childItemList = getChildItemList(idsArray[i],childLevel);
					for (int k = 0; k < childItemList.size(); k++) {
						updateCommandMap = new HashMap();
						updateCommandMap.put("s_itemID", childItemList.get(k));
						updateCommandMap.put("ProjectID", "Del");
						updateCommandMap.put("Blocked", "2");
						commonService.update("project_SQL.updateItemStatus", updateCommandMap);
					}
				}
			}

			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣 �꽦怨�
			target.put(AJAX_SCRIPT,"this.thisReload();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); 
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/checkOutItem.do")
	public String checkOutItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();

		try {			
			String items = StringUtil.checkNull(request.getParameter("itemIds"));
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
			String childLevel = StringUtil.checkNull(request.getParameter("childLevel"),"0");
			String changeType = StringUtil.checkNull(request.getParameter("changeType"));
			
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String scrID = StringUtil.checkNull(request.getParameter("scrID"));
			String itemName = "";
			setMap.put("rNum", 2);
			
			if("".equals(srID)) {
				setMap.put("projectID",projectID);
				srID = StringUtil.checkNull(commonService.selectString("project_SQL.getSRIDByProjectID", setMap)); 
				commandMap.put("srID",srID);
			}

			if (!items.isEmpty()) { 
				String[] itemsArray = items.split(",");
				
				for (int i = 0; itemsArray.length > i;i++) {
					String itemID =  StringUtil.checkNull(itemsArray[i]);
					setMap.put("itemID", itemID);
					String clsCode = StringUtil.checkNull(commonService.selectString("item_SQL.getClassCode", setMap)); // 
								
					setMap.put("ItemClassCode", clsCode);	
					String checkOutOption = StringUtil.checkNull(commonService.selectString("item_SQL.getCheckOutOption", setMap)); // 
						
					setMap.put("Status", "MOD");	
					String CSCnt = StringUtil.checkNull(commonService.selectString("cs_SQL.getChangeSetCountForStatus", setMap)); //
					
				
					//if("02".equals(checkOutOption)) {copyBaseModel(commandMap, itemsArray[i]);}	else {
						if("0".equals(CSCnt)) {
							insertChangeSetForCsr(commandMap, itemsArray[i], projectID, childLevel, changeType);
							copyBaseModel(commandMap, itemsArray[i]);
						} else if(!scrID.equals("")) { // SCR -> checkout -> Update SCRID To MOD CS 
							setMap.put("AuthorID", StringUtil.checkNull(commandMap.get("sessionUserId"), ""));
							setMap.put("AuthorTeamID", StringUtil.checkNull(commandMap.get("sessionTeamId"), ""));
							setMap.put("itemID", itemID);
							setMap.put("status", "MOD");
							String changeSetID = commonService.selectString("cs_SQL.getChangeSetID", setMap);
							setMap.put("changeSetID", changeSetID);
							commonService.update("item_SQL.updateChangeSetData", setMap);							
						}
					//}
				}
			}

			if(!srID.equals("")) {
				
				setMap.put("srID",srID);
				setMap.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId"), ""));
				setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));
				Map srInfoMap = commonService.select("esm_SQL.getESMSRInfo", setMap);
				setMap.put("docCategory", "CS");
				setMap.put("srType", srInfoMap.get("SRType"));
									
				Map esmProcInfo = (Map)decideSRProcPath(request, commonService, setMap);
				
				String procPathID = "";
				String speCode = "";
				if(esmProcInfo != null && !esmProcInfo.isEmpty()){
					procPathID = StringUtil.checkNull(esmProcInfo.get("ProcPathID"));
					speCode = StringUtil.checkNull(esmProcInfo.get("SpeCode"));
					if(!speCode.equals("") && speCode != null) setMap.put("status", speCode); 
				}
				
				setMap.put("blocked", "1");
				commonService.update("esm_SQL.updateESMSR", setMap);	
				
				//Save PROC_LOG			
				Map setProcMapRst = (Map)setProcLog(request, commonService, setMap);
				if(setProcMapRst.get("type").equals("FAILE")){
					String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
					System.out.println("Msg : "+Msg);
				}
				
			}
			
			target.put(AJAX_SCRIPT, "this.thisReload();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.dhtmlx.alert('" + MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")+ "');this.$('#isSubmit').remove()");
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	
	@RequestMapping(value = "/openCommitCommentPop.do")
	public String openCommitCommentPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {				
				String items = StringUtil.checkNull(request.getParameter("items"));
				String cngts = StringUtil.checkNull(request.getParameter("cngts"));
				String pjtIds = StringUtil.checkNull(request.getParameter("pjtIds"));
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String speCode = StringUtil.checkNull(request.getParameter("speCode"));
									
				if("".equals(srID)) {
					setMap.put("projectID",pjtIds);
					srID = StringUtil.checkNull(commonService.selectString("project_SQL.getSRIDByProjectID", setMap)); 					
				}
				
				model.put("srID",srID);
				model.put("pjtIds", pjtIds); 
				model.put("cngts", cngts); 
				model.put("items", items); 
				model.put("speCode", speCode);
				model.put("menu", getLabel(request, commonService)); 
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/project/changeInfo/commitComment");
	}
	
	@RequestMapping(value = "/commitItem.do")
	public String commitItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();

		HashMap updateItemMap = new HashMap();
		HashMap updateCngtMap = new HashMap();
		HashMap updatePjtMap = new HashMap();

		try {

			String items = StringUtil.checkNull(request.getParameter("items"));
			String cngts = StringUtil.checkNull(request.getParameter("cngts"));
			String pjtId = StringUtil.checkNull(request.getParameter("pjtIds"));
			String description = StringUtil.checkNull(request.getParameter("description"));
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String speCode = StringUtil.checkNull(request.getParameter("speCode"));
			String childLevel = StringUtil.checkNull(request.getParameter("childLevel"),"0");
			
			String checkInOption = "";
		//	String csStatus = "CLS";
			int MDLCNT = 0;		
			if (!items.isEmpty()) {
				String[] itemsArray = items.split(",");
				String[] cngtsArray = cngts.split(",");
				
				for (int i = 0; itemsArray.length > i; i++) {
					String itemId = itemsArray[i];
					setMap.put("itemID", StringUtil.checkNull(itemsArray[i]));
					
					String changeSetId = null;
					if(cngtsArray.length > 1) {
						changeSetId = cngtsArray[i];
					} else {
						changeSetId = commonService.selectString("item_SQL.getCurChangeSet", setMap);
					}
					
					if("".equals(pjtId)) {
						pjtId = commonService.selectString("item_SQL.getProjectIDFromItem", setMap);
					}
					
					String curChangeSetID = changeSetId;
					
					setMap.put("changeSetID", changeSetId);
					checkInOption = commonService.selectString("cs_SQL.getCheckInOptionCS", setMap);
					
					setMap.put("Status", "MOD");
					MDLCNT = Integer.parseInt(commonService.selectString("model_SQL.getMDLCNT", setMap));						
					if(MDLCNT > 0){
						target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00157")); // Check models not released  ;
						model.addAttribute(AJAX_RESULTMAP, target);
						return nextUrl(AJAXPAGE);						
					}
										
					if("".equals(srID)) {
						setMap.put("projectID",pjtId);
						srID = StringUtil.checkNull(commonService.selectString("project_SQL.getSRIDByProjectID", setMap)); 					
					}
					
			       /* Create new changeSet */
					setMap.put("s_itemID",itemId);
					String curItemStatus = commonService.selectString("project_SQL.getItemStatus", setMap);	
					if("REL".equals(curItemStatus)) {						
						commandMap.put("srID", srID);	
						insertChangeSetForCsr(commandMap, itemId, pjtId, childLevel,"");	
						changeSetId = commonService.selectString("item_SQL.getCurChangeSet", setMap);
					}
					commandMap.put("projectID",pjtId);
					commandMap.put("changeSetID",changeSetId);	
					commandMap.put("cngts",changeSetId);
				
					ModelMap temp = closeCS(request, commandMap, model);	
					
					/*  Open item blocked and copy new model */
				    setMap.put("Blocked", "0");
				    setMap.remove("Status");					     
				   	commonService.update("project_SQL.updateItemStatus", setMap);
				   	
					copyBaseModel(commandMap, itemId);
				} 
				
				if(!"".equals(srID)) {
					Map updateData = new HashMap();
					updateData.put("srID", srID);
					updateData.put("languageID", commandMap.get("sessionCurrLangType"));
					updateData.put("status", speCode);
					updateData.put("blocked", "1");
					updateData.put("lastUser", commandMap.get("sessionUserId"));
					commonService.update("esm_SQL.updateESMSR", updateData);
					
					//Save PROC_LOG
					Map setProcMapRst = (Map)setProcLog(request, commonService, updateData);
					if(setProcMapRst.get("type").equals("FAILE")){
						System.out.println("SAVE PROC_LOG FAILE Msg : "+StringUtil.checkNull(setProcMapRst.get("msg")));
					}
				}
			}			
			target.put(AJAX_SCRIPT, "parent.fnCallBackSubmit()");
									
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); 
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	public void insertItemAttrRev(HashMap commandMap, String s_itemID, String projectID, String changeSetID) throws Exception {
		HashMap setMap = new HashMap();
		HashMap insertData = new HashMap();
		List attrList = new ArrayList();
		String seq = "";
		
		try {
			if(!"".equals(changeSetID)){
				setMap.put("changeSetID", changeSetID);	
				attrList = commonService.selectList("project_SQL.getItemAttrList", setMap);
				
				for(int h=0; h<attrList.size(); h++){
					Map attrListInfo = (Map)attrList.get(h);			
					seq = StringUtil.checkNull(commonService.selectString("project_SQL.getMaxAttrRevSeq", setMap));
					insertData.put("seq", seq);
					insertData.put("changeSetID", changeSetID);
					insertData.put("itemID", attrListInfo.get("ItemID"));
					insertData.put("attrTypeCode", attrListInfo.get("AttrTypeCode"));
					insertData.put("languageID", attrListInfo.get("LanguageID"));
					insertData.put("modelID", attrListInfo.get("ModelID"));
					insertData.put("plainText", attrListInfo.get("PlainText"));
					insertData.put("lovCode", attrListInfo.get("LovCode"));
					insertData.put("htmlText", attrListInfo.get("HtmlText"));
					insertData.put("itemTypeCode", attrListInfo.get("ItemTypeCode"));
					insertData.put("classCode", attrListInfo.get("ClassCode"));
					insertData.put("deleted", attrListInfo.get("Deleted"));
					insertData.put("font", attrListInfo.get("Font"));
					insertData.put("fontFamily", attrListInfo.get("FontFamily"));
					insertData.put("fontStyle", attrListInfo.get("FontStyle"));
					insertData.put("fontSize", attrListInfo.get("FontSize"));
					insertData.put("fontColor", attrListInfo.get("FontColor"));				
					
					commonService.insert("project_SQL.insertItemAttrRev", insertData);	
				}
			}
		} catch (Exception e) {
			System.out.println(e);
		}
	}
	

	/**
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/addCNItemToChangeSetList.do")
	public String addCNItemToChangeSetList(HttpServletRequest request,
			HashMap commandMap, ModelMap model) throws Exception {

		HashMap target = new HashMap();
		Map setMap = new HashMap();
		String msg = "";

		try {

			String items = StringUtil.checkNull(request.getParameter("items"));
			String itmNms = StringUtil.checkNull(request.getParameter("itmNms"));
			String rooItem = StringUtil.checkNull(request.getParameter("s_itemID"));
			String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
			String cngtID = StringUtil.checkNull(request.getParameter("cngtID"));
			String languageID = StringUtil.checkNull(request.getParameter("languageID"));

			if (!items.isEmpty()) {
				String[] itemsArray = items.split(",");
				String[] itmNmsArray = itmNms.split(":::");

				for (int i = 0; itemsArray.length > i; i++) {

					String itemId = itemsArray[i];
					String itemNm = itmNmsArray[i];

					/* ItemStatus check */
					setMap.put("s_itemID", itemId);
					String status = StringUtil.checkNull(commonService.selectString("project_SQL.getItemStatus", setMap));

					if ("NEW2".equals(status) || "MOD2".equals(status)
							|| "DEL2".equals(status)) {
						if (msg.isEmpty()) {
							msg = itemNm;
						} else {
							msg = msg + "," + itemNm;
						}
					} else {
						insertChangeSetForCnItm(itemId, rooItem, projectID,	cngtID, languageID);
					}

				}
			}

			model.put("ProjectID", projectID);

			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 

			if (!msg.isEmpty()) {
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00082", new String[] { msg }));
			}

			target.put(AJAX_SCRIPT,"parent.selfClose();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); 

		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	
	
	/**
	 * @param s_itemID , childLevel (childLevel = 1 일 경우 자식 childList 만 출력)
	 * @return
	 * @throws Exception
	 */
	private List getChildItemList(String s_itemID, String childLevel) throws Exception {
		List subTreeItemIDList = new ArrayList();
		List list = new ArrayList();
		Map map = new HashMap();
		Map setMap = new HashMap();
		
		String itemId = s_itemID;
		setMap.put("ItemID", itemId);
		
		int j = 1;
		while (j != 0) { 
			String toItemId = "";
			
			setMap.put("CURRENT_ITEM", itemId); 
			setMap.put("CategoryCode", "ST1");
			list = commonService.selectList("report_SQL.getChildItems", setMap);
			j = list.size();
			for (int k = 0; list.size() > k; k++) {
				 map = (Map) list.get(k);
				 setMap.put("ItemID", map.get("ToItemID"));
				 subTreeItemIDList.add(map.get("ToItemID"));
				 
				 if (k == 0) {
					 toItemId = "'" + String.valueOf(map.get("ToItemID")) + "'";
				 } else {
					 toItemId = toItemId + ",'" + String.valueOf(map.get("ToItemID")) + "'";
				 }
			}
			
			itemId = toItemId;
			
			if("1".equals(childLevel)) {
				break;
			}
		}
		
		return subTreeItemIDList;
	}

	/**
	 * [DetailView]
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/changeInfoViewDetail.do")
	public String changeInfoViewDetail(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/project/changeInfo/changeInfoViewDetail";
		try {

			Map getMap = new HashMap();
			Map setMap = new HashMap();

			getMap.put("s_itemID", request.getParameter("changeSetID"));
			getMap.put("languageID", request.getParameter("LanguageID"));

			setMap = commonService.select("cs_SQL.getAdminChangeSetInfo",getMap);

			model.put("getData", setMap);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			model.put("isDone", StringUtil.checkNull(request.getParameter("isDone")));
			model.put("pjtIds", StringUtil.checkNull(request.getParameter("pjtIds")));
			model.put("stepInstIds", StringUtil.checkNull(request.getParameter("stepInstIds")));
			model.put("wfStepIds", StringUtil.checkNull(request.getParameter("wfStepIds")));
			model.put("wfIds", StringUtil.checkNull(request.getParameter("wfIds")));

			model.put("viewCheck", StringUtil.checkNull(request.getParameter("viewCheck")));
			model.put("isMine", StringUtil.checkNull(request.getParameter("isMine")));
			model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID")));

			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			model.put("status", StringUtil.checkNull(request.getParameter("status")));
			model.put("selGov", StringUtil.checkNull(request.getParameter("selGov")));
			model.put("isDoneMenu", StringUtil.checkNull(request.getParameter("isDoneMenu")));

		} catch (Exception e) {
			System.out.println(e.toString());
			throw new Exception("EM00001");
		}

		return nextUrl(url);
	}


	private void updateChangeSetForCsr(HttpServletRequest request, String s_itemID) throws Exception {

		HashMap setMap = new HashMap();
		HashMap fileMap=new HashMap(); 
		HashMap updateCommandMap = new HashMap();
		
		updateCommandMap = new HashMap();
		updateCommandMap.put("s_itemID", s_itemID);
		
		if(request.getParameter("changeType").equals("DEL") && !request.getParameter("changeType").equals("")){
			updateCommandMap.put("Status", "DEL1");
		}else if (request.getParameter("changeType").equals("MOD") && !request.getParameter("changeType").equals("")){
			updateCommandMap.put("Status", "MOD1");
		}
		commonService.update("project_SQL.updateItemStatus", updateCommandMap);	

		/* update TB_CHANGE_SET */
		HashMap changeSetMap = new HashMap();
		
		setMap.put("ChangeSetID", request.getParameter("ChangeSetID"));
		changeSetMap = (HashMap) commonService.select("cs_SQL.getChangeSetData", setMap);
		String validFrom = StringUtil.checkNull(request.getParameter("ValidFrom")).trim();
		if(validFrom.equals("") || validFrom == null){
			validFrom = StringUtil.checkNull(changeSetMap.get("CSREndDate")); 
		}
		updateCommandMap.put("Status", request.getParameter("StatusCode"));
		updateCommandMap.put("Description", request.getParameter("description"));
		updateCommandMap.put("ChangeType", request.getParameter("changeType").substring(0, 3));
		updateCommandMap.put("Version", request.getParameter("version"));
		updateCommandMap.put("ValidFrom", validFrom);

		updateCommandMap.put("s_itemID", request.getParameter("ChangeSetID"));
		commonService.update("cs_SQL.updateChangeSetForWf", updateCommandMap);
		

	}

	/**
	 * insert changeSetInfo, update Item
	 * 
	 * @param request
	 * @param s_itemID
	 * @throws Exception
	 */
	private void insertChangeSetForCsr(HashMap commandMap, String s_itemID, String projectID, String childLevel, String changeType) throws Exception {

		HashMap setMap = new HashMap();
		HashMap insertCommandMap = new HashMap();
		HashMap updateCommandMap = new HashMap();
		HashMap fileMap = new HashMap();
		
		// get MyItem memberID
		setMap.put("itemID", s_itemID);
		setMap.remove("itemID");
		String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
		String LanguageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
		String srID = StringUtil.checkNull(commandMap.get("srID"));
		String scrID = StringUtil.checkNull(commandMap.get("scrID"));

		setMap.put("s_itemID", s_itemID);
		setMap.put("LanguageID", LanguageID);
		
		if(changeType.equals("") || changeType == null){	
			
			changeType = commonService.selectString("project_SQL.getItemConvertStatus", setMap); // CS Change Type
		}
		
		HashMap itemInfoMap = new HashMap();
		HashMap userInfoMap = new HashMap();
		HashMap projectMap = new HashMap();

		itemInfoMap = (HashMap) commonService.select("project_SQL.getItemInfo", setMap);
		
		String itemStatus = StringUtil.checkNull(itemInfoMap.get("Status"));
		
		
		setMap.put("userId", sessionUserID);
		userInfoMap = (HashMap) commonService.select("project_SQL.getUserInfo", setMap);

		setMap.put("projectID", projectID);
		projectMap = (HashMap) commonService.select("project_SQL.getProjectCategory", setMap);
		
		int changeSetID = Integer.parseInt(commonService.selectString("cs_SQL.getMaxChangeSetData", setMap));
		commandMap.put("changeSetID", changeSetID);
		
		setMap.put("itemClassCode", itemInfoMap.get("ClassCode"));
		String checkInOption = StringUtil.checkNull(commonService.selectString("project_SQL.getCheckInOption", setMap));
		
		/* update Item (Status, Blocked=0, ProjectID = CSR ID, CurChangeSet = changeSetID) */
		
		if("NEW1".equals(itemStatus))
			updateCommandMap.put("Status", "NEW1");
		else
			updateCommandMap.put("Status", "MOD1");
		

		updateCommandMap.put("AuthorID", sessionUserID);	
		updateCommandMap.put("s_itemID", s_itemID);
		updateCommandMap.put("Blocked", "0");
		updateCommandMap.put("ProjectID", projectID);
		updateCommandMap.put("CurChangeSet", String.valueOf(changeSetID));
		updateCommandMap.put("OwnerTeamID", userInfoMap.get("TeamID"));
		updateCommandMap.put("ItemID", s_itemID);
		
		if("DEL".equals(changeType)) {
			updateCommandMap.put("Status", "DEL1");
		//	updateCommandMap.put("Blocked", "1");
		}
			
		commonService.update("project_SQL.updateItemStatus", updateCommandMap);

		setMap.put("itemID", s_itemID);
		String basModelID = StringUtil.checkNull(commonService.selectString("model_SQL.getModelIDFromItem", setMap));

		setMap.put("languageID", LanguageID);
		setMap.put("ModelID", basModelID);
		setMap.put("categoryCode","MOJ");
		List mojItemList = commonService.selectList("report_SQL.getObjListOfModel", setMap);
		
		for (int m = 0; m < mojItemList.size(); m++) {
			Map mTempMap = (Map)mojItemList.get(m);
			setMap.put("ItemID", mTempMap.get("ObjectID"));
			String cMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));
			
			if(!"1".equals(cMgt)) {
				updateCommandMap.put("s_itemID", mTempMap.get("ObjectID"));		
				commonService.update("project_SQL.updateItemStatus", updateCommandMap);
			}
			setMap.remove("ItemID");
		}
				
		commonService.update("item_SQL.updateItemFromElement", updateCommandMap);
		
		List childItemList = getChildItemList(s_itemID,childLevel);
		for (int k = 0; k < childItemList.size(); k++) {
			setMap.put("ItemID", childItemList.get(k));
			String cMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));
			
			if(!"1".equals(cMgt)) {
				updateCommandMap.put("s_itemID", childItemList.get(k));		
				commonService.update("project_SQL.updateItemStatus", updateCommandMap);
			}
			setMap.remove("ItemID");
		}
				
		setMap.put("itemID", s_itemID);
		String version = StringUtil.checkNull(commonService.selectString("cs_SQL.getItemReleaseVersion", setMap),"1.0");
		String defVersion = StringUtil.checkNull(commonService.selectString("project_SQL.getItemClassDefVersion", setMap));
	
		if(defVersion.indexOf("0.") > -1 || defVersion.indexOf(".0") > -1){
			BigDecimal version2 = new BigDecimal(version);
			BigDecimal defVersion2 = new BigDecimal(defVersion);
			BigDecimal versionD2 = version2.add(defVersion2); 
			
			insertCommandMap.put("version" , String.valueOf(versionD2));
		}
		else {
			int versionD2 = (int)Double.parseDouble(version) + (int)Double.parseDouble(defVersion);
			insertCommandMap.put("version" , String.valueOf(versionD2));
		}
				
		/* Insert to TB_CHANGE_SET */
		insertCommandMap.put("ChangeSetID", changeSetID);
		insertCommandMap.put("ProjectID", projectID);
		insertCommandMap.put("PJTCategory", projectMap.get("PJCategory"));
		insertCommandMap.put("ItemID", s_itemID);
		insertCommandMap.put("ItemClassCode", itemInfoMap.get("ClassCode"));
		insertCommandMap.put("ItemTypeCode", itemInfoMap.get("ItemTypeCode"));
		insertCommandMap.put("AuthorID", sessionUserID);
		insertCommandMap.put("AuthorName", commandMap.get("sessionUserNm"));
		insertCommandMap.put("AuthorTeamID", userInfoMap.get("TeamID"));
		insertCommandMap.put("CompanyID", userInfoMap.get("CompanyID"));
		insertCommandMap.put("Reason", projectMap.get("Reason"));
		insertCommandMap.put("ChangeType", changeType);
		insertCommandMap.put("SRID" , srID);
		insertCommandMap.put("SCRID" , scrID);

	//	if("NEW1".equals(itemStatus))
	//		insertCommandMap.put("Status", "NEW");
	//	else
		insertCommandMap.put("Status", "MOD");
		if("DEL".equals(changeType)) {
			insertCommandMap.put("Status", "CMP");			
		};
		
		insertCommandMap.put("GUBUN", "insert");
		insertCommandMap.put("checkInOption", checkInOption);
		commonService.insert("cs_SQL.insertToChangeSet", insertCommandMap);
		
		//* update project (Status=CNG) 
	//	updateCommandMap = new HashMap();
	//	updateCommandMap.put("ProjectID", projectID);
	//	updateCommandMap.put("Status", "CNG");
	//	commonService.update("project_SQL.updateProject", updateCommandMap);
		
	}
	
	
	private void insertChangeSetForCnItm(String s_itemID, String rootItem,String projectID, String cngtID, String languageID) throws Exception {

		HashMap setMap = new HashMap();
		HashMap insertCommandMap = new HashMap();
		HashMap updateCommandMap = new HashMap();

		setMap.put("s_itemID", s_itemID);
		setMap.put("LanguageID", languageID);

		/* Insert to TB_CHANGE_SET */
		HashMap changeSetMap = new HashMap();
		HashMap itemInfoMap = new HashMap();
		HashMap rootItemInfoMap = new HashMap();
		HashMap userInfoMap = new HashMap();
		HashMap projectMap = new HashMap();

		changeSetMap = (HashMap) commonService.select("cs_SQL.getMaxChangeSetData", setMap);
		itemInfoMap = (HashMap) commonService.select("project_SQL.getItemInfo",setMap);
		setMap.put("s_itemID", rootItem);
		rootItemInfoMap = (HashMap) commonService.select("project_SQL.getItemInfo", setMap);
		setMap.put("userId", rootItemInfoMap.get("AuthorID"));
		userInfoMap = (HashMap) commonService.select("project_SQL.getUserInfo",	setMap);

		setMap.put("projectID", projectID);
		projectMap = (HashMap) commonService.select("project_SQL.getProjectCategory", setMap);

		int changeSetID = 0;
		if (changeSetMap.get("ChangeSetID") != null) {
			changeSetID = Integer.parseInt(changeSetMap.get("ChangeSetID").toString()) + 1;
		} else {
			changeSetID = 1;
		}

		setMap.put("changeSetID", cngtID);
		changeSetMap = (HashMap) commonService.select("cs_SQL.getChangeSetInfo", setMap);

		insertCommandMap.put("ChangeSetID", changeSetID);
		insertCommandMap.put("ProjectID", projectID);
		insertCommandMap.put("PJTCategory", projectMap.get("PJCategory"));
		insertCommandMap.put("ItemID", s_itemID);
		insertCommandMap.put("ItemClassCode", itemInfoMap.get("ClassCode"));
		insertCommandMap.put("ItemTypeCode", itemInfoMap.get("ItemTypeCode"));

		insertCommandMap.put("AuthorID", String.valueOf(changeSetMap.get("AuthorID")));
		insertCommandMap.put("AuthorName", userInfoMap.get("Name"));
		insertCommandMap.put("AuthorTeamID", userInfoMap.get("TeamID"));
		insertCommandMap.put("CompanyID", userInfoMap.get("CompanyID"));

		insertCommandMap.put("ChangeType", String.valueOf(changeSetMap.get("ChangeType")));
		insertCommandMap.put("Status", String.valueOf(changeSetMap.get("Status")));
		insertCommandMap.put("Description", String.valueOf(changeSetMap.get("Description")));
		insertCommandMap.put("Reason", String.valueOf(changeSetMap.get("Reason")));

		insertCommandMap.put("GUBUN", "insert");
		commonService.insert("cs_SQL.insertToChangeSet", insertCommandMap);

		updateCommandMap.put("Status", String.valueOf(rootItemInfoMap.get("Status")));
		updateCommandMap.put("s_itemID", s_itemID);
		updateCommandMap.put("LockOwner", String.valueOf(changeSetMap.get("AuthorID")));
		commonService.update("project_SQL.updateItemStatus", updateCommandMap);

	}


	
	// TODO:
	private void insertProjectFiles(HashMap commandMap, String projectID) throws Exception {
		Map fileMap  = new HashMap();
		List fileList = new ArrayList();

		int seqCnt = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", commandMap));
		fileMap.put("projectID", projectID);
		String linkType = StringUtil.checkNull(commandMap.get("linkType"), "1");

		//Read Server File
		String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(commandMap.get("sessionUserId"))+"//";
		String filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR;
		String targetPath = filePath;
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
				fileMap.put("FileMgt", "PJT");
				fileMap.put("DocCategory", "PJT");
				fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
				fileMap.put("userId", commandMap.get("sessionUserId"));
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
			CSService.save(fileList, fileMap);
		}
	}
	
	
	/**
	 * 蹂�寃쎌셿猷�
	 * @param request
	 * @param model
	 * @param response 
	 * @return
	 * @throws Exception
	 */
			
	@RequestMapping(value="/cngCheckOutPop.do")
	public String cngCheckOutPop(HttpServletRequest request, HashMap commandMap, ModelMap model, ServletResponse response) throws Exception{
		try{
			String checkType = StringUtil.checkNull(commandMap.get("checkType"),"OUT");
			String projectID = StringUtil.checkNull(commandMap.get("pjtIds"),"");
			String status = StringUtil.checkNull(commandMap.get("status"));	
			String changeType = StringUtil.checkNull(request.getParameter("changeType"),"");
			String itemID = StringUtil.checkNull(request.getParameter("s_itemID"));

			
			Map setMap = new HashMap();
			
			setMap.put("userId", commandMap.get("sessionUserId"));
			setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			setMap.put("ProjectType", "CSR");
			setMap.put("isMainItem", "Y");
			setMap.put("status", "CNG");

			
			List projectNameList = commonService.selectList("project_SQL.getProjectNameList", setMap);
			
			if (projectID != "" ) {
				model.put("CSRID",projectID);
				
	     	}else if(projectNameList.size() == 0) {				
				setMap.put("itemID", itemID);
				setMap.put("userID", StringUtil.checkNull(commandMap.get("sessionUserId")));
				projectID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemClassDefCSRID", setMap));
				model.put("CSRID",projectID);	

			}else if(projectNameList.size() == 1){				
				Map projectMap = (HashMap)projectNameList.get(0);
				model.put("CSRID",projectMap.get("ProjectID") );
			}
					
			model.put("checkType", checkType);
			model.put("changeType", changeType);
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("projectNameList", projectNameList);
			model.put("srID", StringUtil.checkNull(request.getParameter("srID")));
			model.put("speCode", StringUtil.checkNull(request.getParameter("speCode")));
			model.put("cngts",  StringUtil.checkNull(request.getParameter("cngts")));
			model.put("menu", getLabel(request, commonService)); /*Label Setting*/	
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("/project/changeInfo/cngCheckOutPop");
	}
		
	/**
	 * Rework
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/rework.do")
	public String rework(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		HashMap reworkMap = new HashMap();

		try {
			
			String item = StringUtil.checkNull(request.getParameter("item"), "");
			String cngt = StringUtil.checkNull(request.getParameter("cngt"), "");
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
						
			// check
			setMap.put("ChangeSetID", cngt);
			Map csInfoMap = commonService.select("cs_SQL.getChangeSetData", setMap);
			String CSStatus = StringUtil.checkNull(csInfoMap.get("Status"),"");
			String wfInstanceID = StringUtil.checkNull(csInfoMap.get("WFInstanceID"),"");
		
			setMap.put("changeSetID", cngt);
			String wfInstanceON = StringUtil.checkNull(commonService.selectString("wf_SQL.getWfInstON", setMap));
	
			//결재 상신 취소
			if("APRV".equals(CSStatus) && "N".equals(wfInstanceON)){
			      	setMap.put("Status", "4");	
			      	setMap.put("WFInstanceID", wfInstanceID);	
					commonService.update("wf_SQL.updateWfInst", setMap);
			}
			
			// 결재 상신 후 들어온 건 조치
			if(!"MOD".equals(CSStatus)){
				reworkMap.put("item", item);
				reworkMap.put("cngt", cngt);
				reworkMap.put("pjtId",StringUtil.checkNull(request.getParameter("pjtId"), ""));
				doRework(reworkMap, commandMap);
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
			}			
						
			
			String myPageFlg = StringUtil.checkNull(request.getParameter("myPage"), "N");
			
			if("Y".equals(myPageFlg)) {
				target.put(AJAX_SCRIPT,"fnCallBack();parent.$('#isSubmit').remove();");
			}
			else {
				target.put(AJAX_SCRIPT,"parent.fnCallBack();parent.$('#isSubmit').remove();");
			}

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); 
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@Transactional
    public void doReworkTx(HashMap reworkMap, HashMap commandMap) throws Exception {  //트랜잭션 보장용 래퍼
		System.out.println("doReworkTx ======");
        doRework(reworkMap, commandMap);
    }
	
	public void doRework(HashMap reworkMap, HashMap commandMap) throws Exception{
		System.out.println("doRework ======");
		HashMap updateItemMap = new HashMap();
		HashMap updateCngtMap = new HashMap();
		HashMap deletetaskMap = new HashMap();
		HashMap updatePjtMap = new HashMap();
		HashMap setData = new HashMap();
		
		try {
		
			String itemId = StringUtil.checkNull(reworkMap.get("item"), "");
			String changeSetID = StringUtil.checkNull(reworkMap.get("cngt"), "");
			String pjtId = StringUtil.checkNull(reworkMap.get("pjtId"), "");
			
			/* update TB_CHANGE_SET Status = MOD, CurTask = RDY, TB_CHANGE_SET.ApproveDate(�셿猷뚯쿂由ъ씪) = null, TB_CHANGE_SET.Approver = null */
			updateCngtMap.put("Status", "MOD");
			updateCngtMap.put("CurTask", "RDY");
			updateCngtMap.put("s_itemID", changeSetID);
			updateCngtMap.put("changeSetID", changeSetID);
			updateCngtMap.put("ApproveDate", "Del");
			updateCngtMap.put("rework", "Y");
			commonService.update("cs_SQL.updateChangeSetForWf", updateCngtMap);
			
			String changeTypeCode = StringUtil.checkNull(commonService.selectString("cs_SQL.getChangeTypeCode", updateCngtMap));
			
			/* delete TB_TASK */
			deletetaskMap.put("ChangeSetID", changeSetID);
			commonService.delete("project_SQL.delTaskINfo", deletetaskMap);
			
			/* update TB_PROJECT �빐�떦 CSR�쓽  Status = CNG */
			updatePjtMap.put("ProjectID", pjtId);
			updatePjtMap.put("Status", "CNG");
			commonService.update("project_SQL.updateProject", updatePjtMap);
			
			/* update TB_ITEM Blocked = 0 */
			
			updateItemMap.put("LastUser", commandMap.get("sessionUserId"));
			updateItemMap.put("Blocked", "0");
			updateItemMap.put("Status", "MOD1");
			if(changeTypeCode.equals("NEW")){ 
				updateItemMap.put("Status", "NEW1"); 
			}else if(changeTypeCode.equals("DEL")){ 
				updateItemMap.put("Status", "DEL1"); 					
			}
			updateItemMap.put("curChangeSet", changeSetID);
			updateItemMap.put("rework", "Y");
			
			commonService.update("project_SQL.updateItemStatus", updateItemMap);
			
			//	Update  MT Cat = WTR >> TOBE or BAS , 
			setData.put("itemID", itemId);	
			setData.put("changeSetID", changeSetID);
	    	setData.put("orgMTCategory", "WTR");
	     	setData.put("updateMTCategory", "TOBE");
	    	if(changeTypeCode.equals("NEW")){ setData.put("updateMTCategory", "BAS"); }	   
	    	commonService.update("model_SQL.updateModelCat", setData);	
			
			
			// TOBE Model Blocked = 0 				
			updateItemMap = new HashMap();			
			updateItemMap.put("ItemID", itemId);
			updateItemMap.put("changeSetID", changeSetID);
			updateItemMap.put("Blocked", "0");
			commonService.update("model_SQL.updateModelBlockedOfItem", updateItemMap);
		
		} catch (Exception e) {
			System.out.println(e);
		}

	}
	
	@RequestMapping(value = "/withdrawCS.do")
	public String withDrawCS(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		HashMap withDrawMap = new HashMap();

		try {
			
			// itemID 가져오기
			String itemID = StringUtil.checkNull(commandMap.get("itemID"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", itemID);
			setMap.put("languageID", languageID);
			
			if(itemID != null && !"".equals(itemID)){

				// 1. itemID status check ( MOD1 ONLY )
				Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
				String status = StringUtil.checkNull(itemInfo.get("Status"));
				
				if("MOD1".equals(status)) {
					// 2. get itemID curchangeSet , releaseNo , status , ProjectID
					
					withDrawMap.put("itemID", itemID);
					withDrawMap.put("status",status);
					withDrawMap.put("languageID", languageID);
					
					withDrawMap.put("changeSetID", StringUtil.checkNull(itemInfo.get("CurChangeSet"), "")); 
					
					String releaseNo = StringUtil.checkNull(itemInfo.get("ReleaseNo"), "");
					withDrawMap.put("releaseNo",releaseNo);
					
					withdrawCSdata(withDrawMap, commandMap);
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00171"));
				
				} else {
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00173")); 
				}
				
			}
			
			target.put(AJAX_SCRIPT, "this.doCallBack();parent.fnRefreshTree('"+ itemID +"',true);	parent.fnGetItemClassMenuURL('"+ itemID +"');this.$('#isSubmit').remove();");

		} catch (Exception e) {
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00167"));
			target.put(AJAX_SCRIPT, "this.doCallBack();");
			System.out.println(e);
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		 return nextUrl(AJAXPAGE);
	}
	
	//@Transactional
	public void withdrawCSdata(HashMap withDrawMap, HashMap commandMap) throws Exception{
		
		Map getChildData = new HashMap();
		Map setPjtData = new HashMap();
		Map setPreData = new HashMap();
		Map setItemData = new HashMap();
		Map setChildData = new HashMap();
		Map setNewChildData = new HashMap();
		
		Map setTeamData = new HashMap();
		setTeamData.put("assigned", "2");
		setTeamData.put("assgnVal", "3");
		
		try {
			
			// item status MOD1 only 
			String rjtProcOption = StringUtil.checkNull(withDrawMap.get("rjtProcOption"));
			
			// mando 제외
			if(!"2".equals(rjtProcOption)){
				
				String curChangeSet = StringUtil.checkNull(withDrawMap.get("changeSetID"), "");
				String releaseNo = StringUtil.checkNull(withDrawMap.get("releaseNo"), "");
				String itemID = StringUtil.checkNull(withDrawMap.get("itemID"), "");
				
				if(curChangeSet != null && !"".equals(curChangeSet) &&
				   releaseNo != null && !"".equals(releaseNo) &&
				   itemID != null && !"".equals(itemID))
				{
				
					// 1. pre version projectID get
					setPjtData.put("s_itemID",releaseNo);
					String projectID = StringUtil.checkNull(commonService.selectString("cs_SQL.getProjectIDForCSID", setPjtData));
					
					// 2. new file & new team_role delete
					setItemData.put("changeSetID",curChangeSet);
					setItemData.put("assgnVal", "1");
					commonService.delete("fileMgt_SQL.deleteFile", setItemData);
					commonService.delete("role_SQL.deleteTeamRole", setItemData);
					
					// 3. child item ( MOD or DEL ) -- 해당 아이템의 curChangeSet이 동일해야함. 예전에 삭제된 것 복구하면 안되니까 ..
					setChildData.put("Blocked", "2");
					setChildData.put("Status", "REL");
					setChildData.put("changeSetID", curChangeSet);
					setChildData.put("releaseNo", releaseNo);
					setChildData.put("CurChangeSet", releaseNo);
					setChildData.put("ProjectID", projectID);
					setChildData.put("Deleted", "0");
					setChildData.put("LastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
					
					withDrawMap.put("s_itemID", itemID);
					withDrawMap.put("accMode", "OPS");
					withDrawMap.put("delItemsYN","Y");
					withDrawMap.put("changeSetID",curChangeSet);
					List childItemList = commonService.selectList("item_SQL.getChildItemList_gridList", withDrawMap);
					
					for (int i = 0; childItemList.size() > i; i++) {
						getChildData = (Map) childItemList.get(i);
						setChildData.put("itemID", getChildData.get("ItemID"));
						setChildData.put("ItemID", getChildData.get("ItemID"));
						setChildData.put("s_itemID", getChildData.get("ItemID"));
						// 3-1. child item attr recover
						commonService.update("attr_SQL.recoverItemAttr", setChildData);
						// 3-2. update child item status ( DEL&MOD => REL ) 
						commonService.update("item_SQL.updateCNItemDelRecover", setChildData);
						commonService.update("project_SQL.updateItemStatus", setChildData);
						// 3-3. remove item_attr_rev
						commonService.delete("item_SQL.deleteAttrRev", setChildData);
						// 3-4. remove revision
						commonService.delete("item_SQL.deleteRevision", setChildData);
						// 3-5. update team role
						setTeamData.put("itemID", getChildData.get("ItemID"));
						commonService.update("role_SQL.updateTeamRole", setTeamData);
					}
					
					// 4. child item ( NEW )
					setNewChildData.put("changeSetID", curChangeSet);
					setNewChildData.put("Status", "DEL1");
					setNewChildData.put("Deleted", "1");
					setNewChildData.put("LastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
					
					withDrawMap.remove("accMode");
					withDrawMap.remove("delItemsYN");
					withDrawMap.remove("changeSetID");
					withDrawMap.put("statusList", "'NEW1','NEW2'");
					childItemList = commonService.selectList("item_SQL.getChildItemList_gridList", withDrawMap);
					
					for (int i = 0; childItemList.size() > i; i++) {
						getChildData = (Map) childItemList.get(i);
						setNewChildData.put("itemID", getChildData.get("ItemID"));
						setNewChildData.put("s_itemID", getChildData.get("ItemID"));
						setNewChildData.put("ItemID", getChildData.get("ItemID"));
						setNewChildData.put("DimTypeID", getChildData.get("ItemID"));
						// 4-1. update child item status ( NEW => DEL ) 
						commonService.update("item_SQL.updateCNItemDeleted", setNewChildData);
						commonService.update("project_SQL.updateItemStatus",setNewChildData);
					}
					
					// 5. item
					setItemData.put("Status", "REL");
					setItemData.put("changeSetID", curChangeSet);
					setItemData.put("CurChangeSet", releaseNo);
					setItemData.put("ProjectID", projectID);
					setItemData.put("itemID", itemID);
					setItemData.put("s_itemID", itemID);
					setItemData.put("Blocked", 2);
					
					// 5-1. update item status ( MOD1,MOD2 => REL / curChangeSet , releaseNo, projectID, blocked recover )
					commonService.update("project_SQL.updateItemStatus", setItemData);
					// 5-2. item_attr recover
					commonService.update("attr_SQL.recoverItemAttr", setItemData);
					// 5-3. remove item_attr_rev
					commonService.delete("item_SQL.deleteAttrRev", setItemData);
					// 5-4. remove revision
					commonService.delete("item_SQL.deleteRevision", setItemData);
					// 5-5. update team role ( del(3) -> release(2) ) 
					setTeamData.put("itemID", itemID);
					commonService.update("role_SQL.updateTeamRole", setTeamData);
					
					// 6. model
					String modelID = commonService.selectString("item_SQL.getModelIDFromChangSet", setItemData);
					setItemData.put("ModelID", modelID);
					commonService.delete("report_SQL.delElementAndModelTxt", setItemData);
					
					setItemData.put("ChangeSetID", curChangeSet);
					setItemData.put("ItemID", itemID);
					
					// 7. changeSetID delete
					commonService.delete("cs_SQL.delChangeSetInfo", setItemData);
					
					// 8. board delete (제/개정 검토 의견 해당 버전 삭제)
					List boardIDs = commonService.selectList("board_SQL.getBoardID", setItemData);
					Map boardMap = new HashMap();
					String boradID = "";
					
					if(boardIDs.size() > 0) {
						for (int i = 0; boardIDs.size() > i; i++) {
							boardMap = (Map) boardIDs.get(i);
							boradID = StringUtil.checkNull(boardMap.get("BoardID"));
							setItemData.put("boardID", boradID);
							// 파일 폴더에 저장된 해당 파일을 삭제
							List<String> deletefileList = new ArrayList<String>();
							deletefileList = commonService.selectList("forumFile_SQL.forumFile_select3", setItemData);
							File file;
							for (int j = 0; j < deletefileList.size(); j++) {
								file = new File(deletefileList.get(j));
								if (file.exists())
									file.delete();
							}
							
							// [TB_BOARD_ATTCH][TB_BOARD_COMMENT][TB_BOARD_SCORE][TB_BOARD]테이블의 해당 데이터를 모두 삭제
							Map deleteValMap = new HashMap();
							Map deleteInfoMap = new HashMap();
							List deleteList = new ArrayList();
							deleteValMap.put("boardID", boradID);
							
							deleteList.add(deleteValMap);
							deleteInfoMap.put("KBN", "delete");
							deleteInfoMap.put("SQLNAME", "forum_SQL.forumDelete");
							CSService.save(deleteList, deleteInfoMap);

							deleteValMap.put("documentID", boradID);
							CSService.delete("schedule_SQL.deleteSchedlByDocumentID", deleteValMap);
							
						}
					}
					
				}
				
				
			} else {
				// 1. model category update
				commonService.update("model_SQL.updateModelCat", withDrawMap);
				// 2. item_attr recover
				commonService.update("attr_SQL.recoverItemAttr", withDrawMap);
			}
		
		
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

	}
	
	
	/**
	 * [蹂�寃� �듅�씤 �궡�뿭]
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/csrAprvHistory.do")
	public String csrAprvHistory(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/project/pjt/csrAprvHistory";
		try {
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID")));
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));

			// Tree >> ITEM >> [媛쒖슂] >> [蹂�寃� �씠�젰]
			model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
			
		} catch (Exception e) {
			System.out.println(e.toString());
			throw new Exception("EM00001");
		}

		return nextUrl(url);
	}
	
	@RequestMapping(value="/getCsrListOption.do")
	public String getCsrListOption(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String creator = StringUtil.checkNull(request.getParameter("Creator"));
		String userId = String.valueOf(commandMap.get("sessionUserId"));
		String isIssue = StringUtil.checkNull(request.getParameter("isIssue"));
		String screenType = StringUtil.checkNull(request.getParameter("screenType"));
		String projectID = StringUtil.checkNull(request.getParameter("projectID"));
		
		// 蹂�寃쎌삤�뜑 由ъ뒪�듃
		setMap.put("ProjectType", "CSR");
	
		setMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
		if(screenType.equals("PG")){
			setMap.put("RefPGID", projectID);
		}else if (screenType.equals("PJT")){
			setMap.put("RefPjtID", projectID);
		}else if (screenType.equals("myPage")){
			setMap.put("memberId", userId);
			setMap.put("RefPjtID", projectID);
		}else{
			setMap.put("RefPjtID", projectID);
		}
		
		if (!creator.isEmpty()) {
			setMap.put("Creator", creator);
		}
		if ("Y".equals(isIssue)) {
			setMap.put("Status", "CLS");
		}
		
		model.put(AJAX_RESULTMAP, commonService.selectList("project_SQL.getParentPjtList", setMap));
		return nextUrl(AJAXPAGE_SELECTOPTION);
	}
	
	@RequestMapping(value = "/myChangeSet.do")
	public String myChangeSet(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		String url = "project/changeInfo/myChangeSet";
		Map setMap = new HashMap();
		List classCodeList = new ArrayList();
		List parentPjtList = new ArrayList();
		List csrList = new ArrayList();
		List statusList = new ArrayList();
		
		try {
			
			setMap.put("ProjectType", "PJT");
			setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			parentPjtList = commonService.selectList("project_SQL.getParentPjtList", setMap);
			
			setMap.put("ProjectType", "CSR");
			csrList = commonService.selectList("project_SQL.getParentPjtList", setMap);

			// get 怨꾩링 pulldownList
			setMap.put("LanguageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			classCodeList = commonService.selectList("cs_SQL.getClassCodeList", setMap);
			
			// Status List
			setMap.put("Category", "CNGSTS");
		
			statusList = commonService.selectList("project_SQL.getChangeSetInsertInfo", setMap);

			setMap.put("DocCategory", "CS");
			String wfURL = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", setMap));
			
			model.put("parentPjtList", parentPjtList);
			model.put("wfURL", wfURL);
			model.put("statusList", statusList);
			model.put("isPop", StringUtil.checkNull(request.getParameter("isPop"), "N"));
			model.put("currPageA", StringUtil.checkNull(request.getParameter("currPageA"), "0"));
			String memberId = StringUtil.checkNull(request.getParameter("memberID"));
			if ("".equals(memberId)) {
				memberId = (String) commandMap.get("memberId");
			}
			
			model.put("memberID", memberId);
			model.put("hideTitle", StringUtil.checkNull(request.getParameter("hideTitle")));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			// Dhtml 업그레이드 버전 적용 코드
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			commandMap.put("pageNum", StringUtil.checkNull(request.getParameter("currPageA"), "1"));
			commandMap.put("AuthorID",model.get("memberID"));
			
			List mychgList = commonService.selectList("cs_SQL.getChangeSetList_gridList",commandMap);
			
			JSONArray gridData = new JSONArray(mychgList);
			model.put("gridData",gridData);
	
			
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl(url);
	}
	
	/**
	 * 蹂�寃쏀빆紐⑹쓽 蹂�寃쎌삤�뜑 蹂�寃�
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/changeCsrOrder.do")
	public String changeCsrOrder(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		Map updateItemMap = new HashMap();
		Map updateCngtMap = new HashMap();
		try {
			String cngts = StringUtil.checkNull(request.getParameter("cngts"));
			String projectID = StringUtil.checkNull(request.getParameter("pjtId"));
			
			if (!cngts.isEmpty()) { 
				String[] cngtArray = cngts.split(",");
				for (int i = 0; cngtArray.length > i;i++) {
					String cngtId = cngtArray[i];
					// �빐�떦 �븘�씠�뀥�쓽 projectID update
					setMap.put("ChangeSetID", cngtId);
					Map itemInfoMap = commonService.select("cs_SQL.getChangeSetData", setMap);
					if (null != itemInfoMap) {
						updateItemMap.put("s_itemID", itemInfoMap.get("ItemID"));
						updateItemMap.put("ProjectID", projectID);
						commonService.update("project_SQL.updateItemStatus", updateItemMap);
						updateCngtMap.put("Status", itemInfoMap.get("Status"));
						
						// �빐�떦 change set�쓣 媛�吏�怨� �엳�뒗 item�뱾�쓽 ProjectID�� currnetCSID Update
						updateItemMap.put("ChangeSetID", itemInfoMap.get("ChangeSetID"));
						commonService.update("project_SQL.updateItemProjectForCS", updateItemMap);
					}
					// �빐�떦 change set�쓽 projectID update
					updateCngtMap.put("s_itemID", cngtId);
					updateCngtMap.put("newPjtId", projectID);
					commonService.update("cs_SQL.updateChangeSetForWf", updateCngtMap);
					
				}
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
			target.put(AJAX_SCRIPT, "this.thisReload();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); 
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * 
	 * @param changeSetId
	 * @param pjtId
	 * @param wfId
	 * @param wfStepId
	 * @return
	 * @throws Exception
	 */
	private int updateWfStepInstStatus(String changeSetId, String pjtId, String wfId, String wfStepId, String stepInstId) throws Exception {
		// [1]:吏꾪뻾以�, [2]:�셿猷�
		int result = 1;

		// 媛숈� ([WFStepID] [ProjectID] [WFID]) WF_STEP_INST List 痍⑤뱷
		HashMap searchMap = new HashMap();
		HashMap updateMap = new HashMap();

		// �빐�떦 Record留� Status瑜� 1濡� update
		updateMap.put("Status", "1");
		updateMap.put("ProjectID", pjtId);
		if (!changeSetId.isEmpty()) {
			updateMap.put("ChangeSetID", changeSetId);
		} else if (!stepInstId.isEmpty()) {
			updateMap.put("StepInstID", stepInstId);
		}
		updateMap.put("WFID", wfId);
		updateMap.put("WFStepID", wfStepId);
		commonService.update("wf_SQL.updateWFStepInst", updateMap); // Status = 1 

		searchMap.put("ProjectID", pjtId);
		searchMap.put("WFID", wfId);
		searchMap.put("WFStepID", wfStepId);
		List wfStepInstList = commonService.selectList("wf_SQL.getWfStepInstList_gridList", searchMap);

		int flg = 0;

		for (int j = 0; wfStepInstList.size() > j; j++) {
			Map map = (Map) wfStepInstList.get(j);
			String status = (String) map.get("Status");
			if (status.equals("0")) {
				flg = 1;
			}
		}

		if (flg == 0) { // Step Status != 0 ( 紐⑤몢 泥섎━ �맖)
			// 媛숈� �떒怨꾩쓽 WF Step List�쓽 紐⑤뱺 Record媛� 泥섎━ �맂 寃쎌슦
			// 紐⑤뱺 Record�쓽 Status瑜� 2濡� update
			result = 2;

			updateMap = new HashMap();
			updateMap.put("Status", "2");
			updateMap.put("ProjectID", pjtId);
			updateMap.put("WFID", wfId);
			//updateMap.put("WFStepID", wfStepId);
			commonService.update("wf_SQL.updateWFStepInst", updateMap);
		}

		return result;
		}

	/**
	 * [�빀�쓽/�듅�씤 �씠踰ㅽ듃] MyItem
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/argAprMultiUpdate_ORG.do")
	public String argAprMultiUpdate_ORG(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();

		try {
			Map setMap = new HashMap();
			Map getRefMap = new HashMap();
			Map updateCngtMap = new HashMap();
			Map updatePjtMap = new HashMap();
			Map updateItemMap = new HashMap();
			Map updateMemberMap = new HashMap();

			String userId = String.valueOf(commandMap.get("sessionUserId"));
			String pjtIds = StringUtil.checkNull(request.getParameter("pjtIds"));
			String srID = StringUtil.checkNull(request.getParameter("srID"));		
			
			String[] pjtIdArray;
			
			if (!pjtIds.isEmpty()) {
				pjtIdArray = pjtIds.split(","); // ProjectID
				
				for (int i = 0; i < pjtIdArray.length; i++) {
					String pjtId = pjtIdArray[i];
					
					setMap.put("ProjectID", pjtId);
					setMap.put("ActorID", userId);
					
					Map wfStepInstInfoMap = commonService.select("wf_SQL.getWfStepInstInfo", setMap);
					
					String stepInstId = StringUtil.checkNull(wfStepInstInfoMap.get("StepInstID"));
					String wfStepId = StringUtil.checkNull(wfStepInstInfoMap.get("WFStepID")); // APRV,AGR,CSR
					String wfId = StringUtil.checkNull(wfStepInstInfoMap.get("WFID"));

					/* �빐�떦 WF_STEP_INST status update 1 or 2 */
					// Update TB_WF_STEP_INST Status = 1
					// TB_WF_STEP_INST 紐⑤몢 泥섎━ �릺�뿀�쑝硫�  (TB_WF_STEP_INST Status != 0)
					// Update  TB_WF_STEP_INST Status = 2
					int isDone = updateWfStepInstStatus("", pjtId, wfId, wfStepId, stepInstId);

					/* �빐�떦 Project CurWFStepID, Seq update */
					// �쟾 Record�쓽 蹂�寃쎌씠 �걹�굹硫� �떎�쓬 �떒怨꾩쓽 WF Step�쓣 �꽕�젙
					if (isDone == 2) {
						setMap.put("WFID", wfId);
						setMap.put("PreStepID", wfStepId);
						String nextWfStep = StringUtil.checkNull(commonService.selectString("project_SQL.getWfStepId", setMap));
						if (nextWfStep.isEmpty()) {
							updatePjtMap.put("Status", "CNG");
							updatePjtMap.put("EndDate", "EndDate");
							updatePjtMap.put("CurWFStepID", wfStepId);
							updatePjtMap.put("srID", srID);
						} else {
							updatePjtMap.put("CurWFStepID", nextWfStep);
						}
					} else {
						updatePjtMap.put("CurWFStepID", wfStepId);
					}
					updatePjtMap.put("ProjectID", pjtId);
					updatePjtMap.put("srID", srID);
					commonService.update("project_SQL.updateProject", updatePjtMap);
					
					HashMap updateSts = new HashMap();
					if(!srID.equals("")){
						updateSts.put("srID", srID);
						updateSts.put("status", "CNG");
						updateSts.put("lastUser", commandMap.get("sessionUserId"));
						commonService.insert("esm_SQL.updateESMSRStatus", updateSts);				
						
					}		

					/*
					 * (WF_STEP_ID = 留덉�留� WFStepID && isDone = 2) �빐�떦 TB_ITEM
					 *  Item status = REL(由대━利�)
					 *  PJT_MEMBER_REL.Involved = 0, DropOutDate = systemDate
					 */
					setMap.put("WFID", wfId);
					String lastWFStepID = StringUtil.checkNull(commonService.selectString("project_SQL.getLastWFStepID", setMap));

					if (lastWFStepID.equals(wfStepId) && isDone == 2) {
						// �빐�떦 CSR�쓽 蹂�寃쏀빆紐� 紐⑤몢, Item status = REL
						setMap.put("ProjectID", pjtId);
						updateMemberMap = new HashMap();
						updateMemberMap.put("ProjectID", pjtId);
						updateMemberMap.put("Involved", 0);
						updateMemberMap.put("DropOutDate", "sysdate");
						commonService.update("project_SQL.updatePjtMemberRel", updateMemberMap);
					}
				}
			}
			
			//Save PROC_LOG
			Map setProcMapRst = (Map)setProcLog(request, commonService, updatePjtMap);
			if(setProcMapRst.get("type").equals("FAILE")){
				String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
				System.out.println("Msg : "+Msg);
			}
			
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00083")); // �빀�쓽/�듅�씤 �꽦怨� 		
			if(screenType.equals("csrDtl")){
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
			}else{
				target.put(AJAX_SCRIPT, "this.goReqList(3);this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
			}
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00084")); // �빀�쓽/�듅�씤 �삤瑜�														
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	// Aprove
	@RequestMapping("/argAprMultiUpdate.do")
	public String argAprMultiUpdate(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
			Map setMap = new HashMap();
			Map updateData = new HashMap();
			Map updatePjtMap = new HashMap();
			Map updateMemberMap = new HashMap();

			String userId = String.valueOf(commandMap.get("sessionUserId"));
			String pjtIds = StringUtil.checkNull(request.getParameter("pjtIds"));
			String srID = StringUtil.checkNull(request.getParameter("srID"));		
			
			String[] pjtIdArray;			
			if (!pjtIds.isEmpty()) {
				pjtIdArray = pjtIds.split(","); // ProjectID				
				for (int i = 0; i < pjtIdArray.length; i++) {
					String pjtId = pjtIdArray[i];
					
					setMap.put("projectID", pjtId);
					setMap.put("actorID", userId);
					
					Map wfStepInstInfoMap = commonService.select("wf_SQL.getWfStepInstInfo", setMap);
					
					String stepInstId = StringUtil.checkNull(wfStepInstInfoMap.get("StepInstID"));
					String wfStepId = StringUtil.checkNull(wfStepInstInfoMap.get("WFStepID")); // APRV,AGR,CSR
					String wfId = StringUtil.checkNull(wfStepInstInfoMap.get("WFID"));

					/* �빐�떦 WF_STEP_INST status update 1 or 2 */
					// Update TB_WF_STEP_INST Status = 1
					// TB_WF_STEP_INST 紐⑤몢 泥섎━ �릺�뿀�쑝硫�  (TB_WF_STEP_INST Status != 0)
					// Update  TB_WF_STEP_INST Status = 2
					int isDone = updateWfStepInstStatus("", pjtId, wfId, wfStepId, stepInstId);
					
					/* �빐�떦 Project Status update */
					// �쟾 Record�쓽 蹂�寃쎌씠 �걹�굹硫� �떎�쓬 �떒怨꾩쓽 WF Step�쓣 �꽕�젙
					if (isDone == 2) {			
						updatePjtMap.put("ProjectID", pjtId);
						updatePjtMap.put("Status", "CNG");
						updatePjtMap.put("EndDate", "EndDate");
						updatePjtMap.put("srID", srID);
						commonService.update("project_SQL.updateProject", updatePjtMap);
					} else { 
						// TB_WF_INST lastSeq update
						setMap.put("ProjectID", pjtId);
						String wfInstansceID = commonService.selectString("wf_SQL.getWFInstance",setMap);
						String nextWFStepInstSeq = commonService.selectString("wf_SQL.getWFStepInstSeq",setMap);
						updateData.put("projectID", pjtId);
						updateData.put("LastUser", userId);
						updateData.put("lastSeq", nextWFStepInstSeq);
						updateData.put("WFInstanceID", wfInstansceID);
						commonService.update("wf_SQL.updateWfInst", updateData);
					}
					
					HashMap updateSts = new HashMap();
					if(!srID.equals("")){
						updateSts.put("srID", srID);
						updateSts.put("status", "CNG");
						updateSts.put("lastUser", commandMap.get("sessionUserId"));
						commonService.insert("esm_SQL.updateESMSRStatus", updateSts);				
					}		

					/*
					 * (WF_STEP_ID = 留덉�留� WFStepID && isDone = 2) �빐�떦 TB_ITEM
					 *  Item status = REL(由대━利�)
					 *  PJT_MEMBER_REL.Involved = 0, DropOutDate = systemDate
					 */
					// get 留덉�留� WFStepID
					setMap.put("WFID", wfId);
					//String lastWFStepID = StringUtil.checkNull(commonService.selectString("project_SQL.getLastWFStepID", setMap));

					if (isDone == 2) {
						// �빐�떦 CSR�쓽 蹂�寃쏀빆紐� 紐⑤몢, Item status = REL
						setMap.put("ProjectID", pjtId);
						updateMemberMap = new HashMap();
						updateMemberMap.put("ProjectID", pjtId);
						updateMemberMap.put("Involved", 0);
						updateMemberMap.put("DropOutDate", "sysdate");
						commonService.update("project_SQL.updatePjtMemberRel", updateMemberMap);
					}
				}
			}
			
			//Save PROC_LOG
			Map setProcMapRst = (Map)setProcLog(request, commonService, updatePjtMap);
			if(setProcMapRst.get("type").equals("FAILE")){
				String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
				System.out.println("Msg : "+Msg);
			}
			
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00083")); // �빀�쓽/�듅�씤 �꽦怨� 		
			if(screenType.equals("csrDtl")){
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
			}else{
				target.put(AJAX_SCRIPT, "this.goReqList(3);this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
			}
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00084")); // �빀�쓽/�듅�씤 �삤瑜�														
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	// COPY BASE MODEL 
	private void copyBaseModel(HashMap commandMap, String s_itemID) throws Exception {
		HashMap setMap = new HashMap();
		String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));	
		setMap.put("itemID", s_itemID);
		setMap.put("languageID", languageID);
		setMap.put("mtCategory", "BAS");
		Map baseModelInfo = commonService.select("project_SQL.getBasModelInfo", setMap);
		
		setMap.remove("mtCategory");
		Map otherModelInfo = commonService.select("project_SQL.getBasModelInfo", setMap);
		if(baseModelInfo != null && !baseModelInfo.isEmpty()){ // Base 紐⑤뜽�씠  �엳�쑝硫�
			setMap.put("blocked", "1");
			setMap.put("MTCategory", "BAS");
			setMap.put("modelID", baseModelInfo.get("ModelID"));
			commandMap.put("orgModelID", baseModelInfo.get("ModelID"));
			commonService.update("project_SQL.updateModel", setMap);
			
			String newModelID = StringUtil.checkNull(commonService.selectString("model_SQL.getMaxModelIDString", setMap));
			setMap.put("newModelID", newModelID);
			setMap.put("newMTCTypeCode", "TOBE");
			setMap.put("Creator", commandMap.get("sessionUserId"));
			setMap.put("orgModelID", baseModelInfo.get("ModelID"));
			setMap.put("newModelName", baseModelInfo.get("ModelName"));	
			setMap.put("csrYN","Y"); // csr changeSet checkout �떆 projectID, changeSetID insert�븯湲� �쐞�븳 援щ텇媛�
			setMap.put("projectID", commandMap.get("projectID"));
			setMap.put("changeSetID", commandMap.get("changeSetID"));
			setMap.put("blocked", "0");
			commonService.insert("model_SQL.copyModel", setMap);
			
			List getElementList = commonService.selectList("model_SQL.getCpElementList", setMap);	
			List getLanguageList = commonService.selectList("common_SQL.langType_commonSelect", setMap);	
			setMap.put("includeItemMaster", "Y");
			for(int i = 0; i < getLanguageList.size(); i++){
				Map getMap = (HashMap)getLanguageList.get(i);
				setMap.put("LanguageID", getMap.get("CODE") );				
				commonService.insert("model_SQL.copyModelTxt", setMap);
			}
			
			Map setData = new HashMap();
			for(int i=0; i< getElementList.size(); i++){		
				Map getMap = (HashMap)getElementList.get(i);
				setMap.put("orgElementID", getMap.get("ElementID"));
				commonService.insert("model_SQL.copyModelElement", setMap);	
			}	
		}
		else if(otherModelInfo != null && !otherModelInfo.isEmpty()){ // Base紐⑤뜽�씠 �뾾�뒗寃쎌슦 TOP1�쓽 Model�쓣 蹂듭궗
			setMap.put("blocked", "1");
			setMap.put("MTCategory", "WTR");
			setMap.put("modelID", baseModelInfo.get("ModelID"));
			commandMap.put("orgModelID", baseModelInfo.get("ModelID"));
			commonService.update("project_SQL.updateModel", setMap);
			
			String newModelID = StringUtil.checkNull(commonService.selectString("model_SQL.getMaxModelIDString", setMap));
			setMap.put("newModelID", newModelID);
			setMap.put("newMTCTypeCode", "BAS");
			setMap.put("Creator", commandMap.get("sessionUserId"));
			setMap.put("orgModelID", otherModelInfo.get("ModelID"));
			setMap.put("newModelName", otherModelInfo.get("ModelName"));	
			setMap.put("csrYN","Y"); // csr changeSet checkout �떆 projectID, changeSetID insert�븯湲� �쐞�븳 援щ텇媛�
			setMap.put("projectID", commandMap.get("projectID"));
			setMap.put("changeSetID", commandMap.get("changeSetID"));
			setMap.put("blocked", "0");
			commonService.insert("model_SQL.copyModel", setMap);
			
			List getElementList = commonService.selectList("model_SQL.getCpElementList", setMap);	
			List getLanguageList = commonService.selectList("common_SQL.langType_commonSelect", setMap);	
			setMap.put("includeItemMaster", "Y");
			for(int i = 0; i < getLanguageList.size(); i++){
				Map getMap = (HashMap)getLanguageList.get(i);
				setMap.put("LanguageID", getMap.get("CODE") );				
				commonService.insert("model_SQL.copyModelTxt", setMap);
			}
			
			Map setData = new HashMap();
			for(int i=0; i< getElementList.size(); i++){		
				Map getMap = (HashMap)getElementList.get(i);
				setMap.put("orgElementID", getMap.get("ElementID"));
				commonService.insert("model_SQL.copyModelElement", setMap);	
			}	
		}
	}
	
	@RequestMapping(value = "/updateCSStatusForWF.do")
	public String updateCSStatusForWF(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		Map updateMap = new HashMap();
		Map tempMap = new HashMap();
		Map updateItemMap = new HashMap();
		HashMap reworkMap = new HashMap();
		
			try {	
				String wfInstanceStatus = StringUtil.checkNull(commandMap.get("wfInstanceStatus"),"");
				String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"),"");
				String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));	
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String status = StringUtil.checkNull(commandMap.get("status"));
				String preFileBlocked = StringUtil.checkNull(commandMap.get("preFileBlocked"));
				String rjtProcOption = StringUtil.checkNull(commandMap.get("rjtProcOption"));
				String childLevel = StringUtil.checkNull(request.getParameter("childLevel"),"0");
				
				setMap.put("languageID", languageID);		
		  		setMap.put("wfInstanceID", wfInstanceID);
			    List csList = commonService.selectList("cs_SQL.getChangeSetList_gridList", setMap);	
				
			    if(csList.size() > 0) {
			    	String items = "";
					String cngts = "";
					String pjtIds = "";
			    	for(int i=0; csList.size()>i; i++) {
			    		Map csInfoMap = (Map)csList.get(i);
			    		if(i==0) {
			    			items = StringUtil.checkNull(csInfoMap.get("ItemID"));
			    			cngts = StringUtil.checkNull(csInfoMap.get("ChangeSetID"));
			    			pjtIds = StringUtil.checkNull(csInfoMap.get("ProjectID"));
			    			
			    			// KPAL 자동 rework
			    			reworkMap.put("item",items);
							reworkMap.put("cngt",cngts);
							reworkMap.put("pjtId",pjtIds);
			    			
			    		}else {
			    			items += "," + StringUtil.checkNull(csInfoMap.get("ItemID"));
			    			cngts += "," + StringUtil.checkNull(csInfoMap.get("ChangeSetID"));
			    			pjtIds += "," + StringUtil.checkNull(csInfoMap.get("ProjectID"));
			    		}
			    	}
			    	commandMap.put("items", items);
				    commandMap.put("cngts", cngts);
				    commandMap.put("pjtIds", pjtIds);
				    commandMap.put("wfInstanceID", wfInstanceID);
			    }
			    
			    if("2".equals(wfInstanceStatus)) {			   
			    	ModelMap temp = closeCS(request, commandMap, model);	   			  	
			    }else if("3".equals(wfInstanceStatus)) {
			    	if("1".equals(rjtProcOption)) {
			    		// KPAL 자동 rework
						doRework(reworkMap, commandMap);
			    	} else {
			    		for(int i=0; i<csList.size(); i++){
			    			
			    			tempMap = (Map)csList.get(i);
			    			String csID = StringUtil.checkNull(tempMap.get("ChangeSetID"));
			    			String projectID = StringUtil.checkNull(tempMap.get("ProjectID"));
			    			
			    			updateMap.put("s_itemID", csID);
			    			updateMap.put("csStatus", "HOLD");						   
			    			commonService.update("cs_SQL.updateChangeSetClose", updateMap);
			    			
			    			String csItemID = StringUtil.checkNull(tempMap.get("ItemID"));
			    			List childItemList = getChildItemList(csItemID,childLevel);
			    			
			    			setMap.put("s_itemID", csItemID);
			    			setMap.put("csID", csID);			    	
			    			
			    			//commonService.update("fileMgt_SQL.updateFileBlockWithCSID", setMap);			    	
			    			
			    			// MANDO 원복
			    			if("2".equals(rjtProcOption)) {
				    			Map setData = new HashMap();
				    			setData.put("itemID", csItemID);	
				    			setData.put("changeSetID", csID); 
				    			setData.put("languageID", languageID);
				    			setData.put("orgMTCategory", "TOBE");	
				    			setData.put("updateMTCategory", "WTR");
				    			
				    			if("NEW".equals(tempMap.get("ChangeTypeCode"))) {						
				    				setData.put("orgMTCategory", "BAS");				    	
				    			}
			    				commonService.update("model_SQL.updateModelCat", setData);
			    				commonService.update("attr_SQL.recoverItemAttr", setData);
			    			}
			    		}				    	
			    	}
			    }
			   	
			    //Save PROC_LOG
			    setMap.put("sessionCurrLangType", languageID);
				Map setProcMapRst = (Map)setProcLog(request, commonService, setMap);
				if(setProcMapRst.get("type").equals("FAILE")){
					String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
					System.out.println("Msg : "+Msg);
				}	
				
				String screenType = StringUtil.checkNull(request.getParameter("screenType"));
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 	
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
			} catch (Exception e) {
				System.out.println(e);
				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); 												
			}
			model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(AJAXPAGE);
		
		}
	
	
	@RequestMapping(value="/mainChangeSetList.do")
	public String mainChangeSetList(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		Map getMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
			String changeType = StringUtil.checkNull(request.getParameter("changeType"));
			String classCode = StringUtil.checkNull(request.getParameter("classCode"));
			String qryOption = StringUtil.checkNull(request.getParameter("qryOption"));
			String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
			String dimValueID = StringUtil.checkNull(request.getParameter("dimValueID"));
			String Status = StringUtil.checkNull(request.getParameter("Status"));
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
			String LIST_PAGE_SCALE = StringUtil.checkNull(request.getParameter("LIST_PAGE_SCALE"));
	   		 
	   		String classCodeList = StringUtil.checkNull(request.getParameter("classCodeList"));
	   		String isNotIn = StringUtil.checkNull(request.getParameter("isNotIn"));
	   		String DimTypeID = StringUtil.checkNull(request.getParameter("DimTypeID"));
	   		String DimValueIDOLM_ARRAY_VALUE = StringUtil.checkNull(request.getParameter("DimValueIDOLM_ARRAY_VALUE"));
	   		
	   		getMap.put("classCodeList", classCodeList);
	   		getMap.put("isNotIn", isNotIn);
 			getMap.put("DimTypeID", DimTypeID);
 			getMap.put("DimValueIDOLM_ARRAY_VALUE", DimValueIDOLM_ARRAY_VALUE);
	   		 
			getMap.put("languageID", languageID);
			getMap.put("itemTypeCode", itemTypeCode);
			getMap.put("changeType", changeType);
			getMap.put("Status", Status);
			getMap.put("qryOption", qryOption);
			getMap.put("scrnType", scrnType);
			getMap.put("LIST_PAGE_SCALE", LIST_PAGE_SCALE);
			
	        List mainCSList = commonService.selectList("cs_SQL.getChangeSetMultiList_gridList", getMap);
	        JSONArray gridData = new JSONArray(mainCSList);
	        model.put("gridData",gridData);	
			
			model.put("itemTypeCode", itemTypeCode);
			model.put("changeType", changeType);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		
		return nextUrl("/hom/main/cs/mainChangeSetList");
	}
	
	@RequestMapping(value="/mainChangeSetList_v2.do")
	public String mainChangeSetList_v2(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
			String qryOption = StringUtil.checkNull(request.getParameter("qryOption"));
			String classCode = StringUtil.checkNull(request.getParameter("classCode"));
			String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
			String dimValueID = StringUtil.checkNull(request.getParameter("dimValueID"));

			model.put("itemTypeCode", itemTypeCode);
			model.put("qryOption", qryOption);
			model.put("classCode", classCode);
			model.put("dimTypeID", dimTypeID);
			model.put("dimValueID", dimValueID);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
			// 시스템 날짜 
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
			model.put("clsEndDt", thisYmd);
			
			cal.add(Calendar.DATE, -90);
			String lastYmd = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
			model.put("clsStartDt", lastYmd);

			setMap.put("languageID", languageID);
			setMap.put("ItemTypeCode", itemTypeCode);
			setMap.put("Status", "CLS");
			setMap.put("LIST_PAGE_SCALE", "5");
			setMap.put("scrnType", "main");
			setMap.put("qryOption", qryOption);
			setMap.put("clsStartDt", lastYmd);
			setMap.put("clsEndDt", thisYmd);
		
			
	        List mainCS2List = commonService.selectList("cs_SQL.getChangeSetMultiList_gridList", setMap);
	        JSONArray gridData = new JSONArray(mainCS2List);
	        model.put("gridData",gridData);	
			
			
			
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		
		return nextUrl("/hom/main/cs/mainChangeSetList_v2");
	}
	
	@RequestMapping(value="/olmMainChangeSetList.do")
	public String olmMainChangeSetList(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			
			setMap.put("languageID", languageID);
			setMap.put("pageNo", 1);
			setMap.put("topNum", 10);
			setMap.put("changeMgtYN", "Yes");
			setMap.put("categoryCode", "OJ");
			List csList = commonService.selectList("item_SQL.getLastUpdatedWithin7Days",setMap);
						
			model.put("csList", csList);
			model.put("languageID", languageID);	
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
						
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		
		return nextUrl("/hom/main/v34/olmMainChangeSetList");
	}
	
	@RequestMapping(value = "/checkInCommentPop.do")
	public String checkInCommentPop(HttpServletRequest request, HashMap cmmMap,
			ModelMap model) throws Exception {

		try {

			String pjtIds = StringUtil.checkNull(request.getParameter("pjtIds"));
			String cngts = StringUtil.checkNull(request.getParameter("cngts"));
			String items = StringUtil.checkNull(request.getParameter("items"));

			model.put("pjtIds", pjtIds);
			model.put("cngts", cngts);
			model.put("items", items);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/checkInCommentPop");
	}	
	
	@Transactional(rollbackFor = Exception.class)
	@RequestMapping(value = "/publishItem.do")
	public String publishItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();

		try {
			
			String items = StringUtil.checkNull(request.getParameter("items"),request.getParameter("itemID"));
			String cngts = StringUtil.checkNull(request.getParameter("cngts"));
			String pjtIds = StringUtil.checkNull(request.getParameter("pjtIds"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
			int idx = 0;
			if (!items.isEmpty()) {
				String[] itemsArray = items.split(",");
				String[] cngtsArray = items.split(",");
				String[] pjtIdsArray = items.split(",");
				String itemList = "";
				for (int i = 0; itemsArray.length > i; i++) {
					String itemId = itemsArray[i];
					String changeSetId = cngtsArray[i];
					String pjtId = pjtIdsArray[i];
					
					setMap.clear();
					setMap.put("s_itemID", itemId);
					changeSetId = commonService.selectString("item_SQL.getItemCurChangeSet",setMap);
					setMap.put("itemID", itemId);
					pjtId = commonService.selectString("item_SQL.getProjectIDFromItem",setMap);
					
					if(!changeSetId.equals("")) {
						
						if(idx == 0) {
							cngts = changeSetId;
							pjtIds = pjtId;	
							itemList = itemId;
						}else {
							cngts = cngts + "," + changeSetId;	
							pjtIds = pjtIds + "," + pjtId;	
							itemList = itemList + "," + itemId;
						}
						
						idx++;
					}
						
				}
			
				commandMap.put("cngts",cngts);
				commandMap.put("pjtIds",pjtIds);
				commandMap.put("items",itemList);
				ModelMap temp = completeCS(request, commandMap, model);
				temp = closeCS(request, commandMap, model);
			}

			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 		
			target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove();");
									
		} catch (Exception e) {
			System.out.println(e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); 
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@Transactional(rollbackFor = Exception.class)
	@RequestMapping(value = "/checkInMgt.do")
	public String checkInMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();

		try {

			String items = StringUtil.checkNull(request.getParameter("items"));
			String cngts = StringUtil.checkNull(request.getParameter("cngts"));
			String pjtIds = StringUtil.checkNull(request.getParameter("pjtIds"));
			String checkInOption = StringUtil.checkNull(request.getParameter("checkInOption"));
			// fileUpload용 token
			String uploadToken = StringUtil.checkNull(request.getParameter("uploadToken"));
			commandMap.put("uploadToken", uploadToken);
			
			if (!items.isEmpty()) {
				String[] itemsArray = items.split(",");
				String[] cngtsArray = cngts.split(",");
				String[] pjtIdsArray = pjtIds.split(",");
				
				for (int i = 0; itemsArray.length > i; i++) {
					String itemId = itemsArray[i];
					String changeSetId = cngtsArray[i];
					String pjtId = pjtIdsArray[i];
					
					 
					setMap.put("changeSetID", changeSetId);
					if (checkInOption.isEmpty()) {
						checkInOption = commonService.selectString("cs_SQL.getCheckInOptionCS", setMap);
					}	
					
					
					model = completeCS(request, commandMap, model);
					if("01".equals(checkInOption) || "01B".equals(checkInOption) || "02".equals(checkInOption)) {
						model = closeCS(request, commandMap, model);
						commonService.update("model_SQL.updateElementReleaseNo", setMap);
					}
				}
				
			}
			
			String MDLCNT = StringUtil.checkNull(model.get("MDLCNT")); // 수정중인 모델이 있을시 checkIn 중지
			if(Integer.parseInt(MDLCNT) > 0) {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00157")); // check In  
			}else {
				
				if(!checkInOption.equals("03A")){
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				}
				target.put(AJAX_SCRIPT, "fnCallBack('"+checkInOption+"')");
			}
									
		} catch (Exception e) {
			System.out.println(e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); 
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@Transactional(rollbackFor = Exception.class)
	public ModelMap completeCS(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();

		HashMap updateItemMap = new HashMap();
		HashMap updateCngtMap = new HashMap();
		HashMap updatePjtMap = new HashMap();
		
		String errorMessage = MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068");

		try {
			
			// 0. parameter setting
			String items = StringUtil.checkNull(commandMap.get("items"));
			String cngts = StringUtil.checkNull(commandMap.get("cngts"));
			String pjtIds = StringUtil.checkNull(commandMap.get("pjtIds"));
			String description = StringUtil.checkNull(commandMap.get("description"));
			String version = StringUtil.checkNull(commandMap.get("version"));
			String validFrom = StringUtil.checkNull(commandMap.get("validFrom")).trim();			
			String changeType = StringUtil.checkNull(commandMap.get("changeType")).trim();
			String checkInOption = StringUtil.checkNull(commandMap.get("checkInOption"));
			String childLevel = StringUtil.checkNull(commandMap.get("childLevel"),"0");
			String uploadToken = StringUtil.checkNull(commandMap.get("uploadToken"));
			
			// 1. status 완료처리
			String csStatus = "CMP";
			int MDLCNT = 0;		
			if (!items.isEmpty()) {
				String[] itemsArray = items.split(",");
				String[] cngtsArray = cngts.split(",");
				String[] pjtIdsArray = pjtIds.split(",");
				// 2. complete할 item 작업 
				for (int i = 0; itemsArray.length > i; i++) {
					String itemId = itemsArray[i];
					String changeSetId = cngtsArray[i];
					String pjtId = pjtIdsArray[i];
					
					// 3. 해당 아이템에 수정중인 맵 찾아서, 수정중인 맵이 있을 경우 반려처리
					setMap.put("changeSetID", changeSetId);					
					setMap.put("itemID", StringUtil.checkNull(itemsArray[i]));
					setMap.put("Status", "MOD");
					MDLCNT = Integer.parseInt(commonService.selectString("model_SQL.getMDLCNT", setMap));	
					model.put("MDLCNT", MDLCNT);
					if(MDLCNT > 0){ 
						target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00157")); // check In  
						model.addAttribute(AJAX_RESULTMAP, target);
						return model;						
					}
					
					// 4. item의 상태에 따른 상태변화 처리
					String checkInItemStatus = "";	
					setMap.put("s_itemID",itemId);
					String curItemStatus = commonService.selectString("project_SQL.getItemStatus", setMap);
					
					if(!"".equals(changeType)) {
						
						if ("NEW".equals(changeType)) {
							checkInItemStatus = "NEW2";
						} else if ("DEL".equals(changeType)) {
							checkInItemStatus = "DEL2";
						} else if ("MOD".equals(changeType)){
							checkInItemStatus = "MOD2";
						}	
						
					} else{			
						
						if ("NEW1".equals(curItemStatus)) {
							checkInItemStatus = "NEW2";
						} else if ("DEL1".equals(curItemStatus)) {
							checkInItemStatus = "DEL2";
						} else if ("MOD1".equals(curItemStatus)){
							checkInItemStatus = "MOD2";
						}							
					}
					
					// 5. 하위 아이템 처리
					List childItemList = getChildItemList(itemId,childLevel);
					
					/* ChangeMgt !=1 인 child item에 대해서  Revision Revision 생성 */					
					for (int k = 0; k < childItemList.size(); k++) {
						updateItemMap.put("s_itemID", childItemList.get(k));
						String childItemStatus = commonService.selectString("project_SQL.getItemStatus", updateItemMap);
						
						HashMap insertData = new HashMap();
						if(childItemStatus.equals("NEW1") || childItemStatus.equals("DEL1")){	
							insertData.put("docCategory", "ITM");														
							insertData.put("objectType",  commonService.selectString("item_SQL.getItemTypeCode", updateItemMap));
							insertData.put("documentID", childItemList.get(k));
							insertData.put("changeSetID", changeSetId);
							if(childItemStatus.equals("NEW1")){	 
								insertData.put("description", "Created");	
								insertData.put("revisionType", "NEW");
							}else {
								insertData.put("description", "Deleted");	
								insertData.put("revisionType", "DEL");
							}
							insertData.put("authorID", commandMap.get("sessionUserId"));
							insertData.put("authorTeamID", commandMap.get("sessionTeamId"));											
							commonService.insert("revision_SQL.insertRevision", insertData);	
					   }
						 
					}
					
					// 6. item 업데이트 ( curChanset = changeSetID )
					updateItemMap = new HashMap();
					updateItemMap.put("Status", checkInItemStatus);
					updateItemMap.put("LastUser", commandMap.get("sessionUserId"));
					updateItemMap.put("Blocked", "2");
					updateItemMap.put("curChangeSet", changeSetId);
					updateItemMap.put("checkin", "Y");
										
					commonService.update("project_SQL.updateItemStatus", updateItemMap);
					
					// 7. changeSet 종료로 업데이트
					updateItemMap.remove("curChangeSet");
					updateItemMap.remove("checkin");
					
					updateCngtMap.put("Status", csStatus);
					updateCngtMap.put("CurTask", "CLS");
					updateCngtMap.put("s_itemID", changeSetId);
					updateCngtMap.put("userID", commandMap.get("sessionUserId"));
					updateCngtMap.put("Description", description);
					updateCngtMap.put("Version", version);
					updateCngtMap.put("ValidFrom", validFrom);
					updateCngtMap.put("ChangeType", changeType);
					updateCngtMap.put("checkInOption", checkInOption);
					updateCngtMap.put("completionDT","Y");
					commonService.update("cs_SQL.updateChangeSetForWf", updateCngtMap);
				
					//8. 모델 blocked 처리 : Model Blocked = 1  				
					updateItemMap = new HashMap();
					updateItemMap.put("ItemID", itemId);
					updateItemMap.put("Blocked", "1");
					commonService.update("model_SQL.updateModelBlockedOfItem", updateItemMap);
					
					// 9. refItemID blocked 처리
					setMap.put("ProjectID", pjtId);
					List varItemList = commonService.selectList("project_SQL.getVarItemList", setMap);
					for (int k = 0; k < varItemList.size(); k++) {
						updateItemMap = new HashMap();
						updateItemMap.put("s_itemID", varItemList.get(k));
						updateItemMap.put("Blocked", "2");
						commonService.update("project_SQL.updateItemStatus", updateItemMap);
					}	
					
					
					// 10. file upload 공통 사용
					Map fileUploadMap = new HashMap();
					String fltpCode = "CSDOC";
					commandMap.put("uploadToken",uploadToken);
					commandMap.put("projectID",pjtId);
					commandMap.put("fltpCode", fltpCode);
					commandMap.put("DocumentID", changeSetId);
					commandMap.put("FltpCode", fltpCode); 
					commandMap.put("ItemID", itemId); 
					commandMap.put("FileMgt", "ITM"); 
					commandMap.put("ChangeSetID", changeSetId);
					commandMap.put("DocCategory", "CS");	
							
					fileUploadMap = fileUploadUtil.fileUpload(commandMap, request);
							
					boolean fileUploadResult = (boolean) fileUploadMap.getOrDefault("result",false);
					if(!fileUploadResult) {
						errorMessage = StringUtil.checkNull(fileUploadMap.get("message"),"파일 업로드 실패");
						throw new Exception(errorMessage);
					}
					
				}
			}
				
		} catch (Exception e) {
			System.out.println(e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, errorMessage); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return model;
	}
	

	public ModelMap closeCS(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		Map updateMap = new HashMap();
		Map updateItemMap = new HashMap();
		String ChangeTypeCode = "";
		try {	
			String items = StringUtil.checkNull(commandMap.get("items"));
			String cngts = StringUtil.checkNull(commandMap.get("cngts"));
			String pjtIds = StringUtil.checkNull(commandMap.get("pjtIds"));
			String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String sessionCurrLangType = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String childLevel = StringUtil.checkNull(commandMap.get("childLevel"),"0");
			String rjtProcOption = StringUtil.checkNull(commandMap.get("rjtProcOption"));
			if (!items.isEmpty()) {
				String[] itemsArray = items.split(",");
				String[] cngtsArray = cngts.split(",");
				String[] pjtIdsArray = pjtIds.split(",");
				
				for (int i = 0; itemsArray.length > i; i++) {

					String itemId = itemsArray[i];
					String changeSetId = cngtsArray[i];
					String pjtId = pjtIdsArray[i];
		    	
			    	updateMap.put("s_itemID", changeSetId);
				    updateMap.put("csStatus", "CLS");	
				    updateMap.put("completionDT","Y");
				    updateMap.put("changeSetID", changeSetId);	
				    
				 //   Map wfInstanceInfo = commonService.select("wf_SQL.getWFINSTanceInfo", updateMap); 
				 //   updateMap.put("description", StringUtil.checkNull(wfInstanceInfo.get("Description")));
				    
			    	commonService.update("cs_SQL.updateChangeSetClose", updateMap);
			    	
			    	//kefico 시행일 업데이트 
			    	if(rjtProcOption.equals("1")) {
			    	
			    		commonService.update("cs_SQL.updateChangeSetValidForm", updateMap);
			    	}
			    	
				    List childItemList = getChildItemList(itemId, childLevel);
				    
				    setMap.put("s_itemID", itemId);
			    	setMap.put("csID", changeSetId);
				    			    	
			    	setMap.put("itemID", itemId);				    	
			    	commonService.update("fileMgt_SQL.updateFileBlockPreVersionWithCS", setMap);						
			    
				    setMap.put("Status", "REL");
				    setMap.put("LastUser", sessionUserId);
				    setMap.put("ReleaseNo", changeSetId);
				    setMap.put("curChangeSet", changeSetId);
				    setMap.put("Blocked", "2");
				    setMap.remove("s_itemID");					     
			    	commonService.update("project_SQL.updateItemStatus", setMap);
			    				    	
			    	insertItemAttrRev(commandMap, itemId, pjtId, changeSetId);

					setMap.put("changeSetID",changeSetId);
					ChangeTypeCode = StringUtil.checkNull(commonService.selectString("cs_SQL.getChangeTypeCode", setMap));
			    	
			    	if("MOD".equals(ChangeTypeCode)) {
						Map setData = new HashMap();
				    	setData.put("itemID", itemId);				    
				    	setData.put("orgMTCategory", "BAS");
				    	setData.put("updateMTCategory", "VER");
				    	commonService.update("model_SQL.updateModelCat", setData);	
				    	
				    	setData.put("orgMTCategory", "TOBE");
				    	setData.put("updateMTCategory", "BAS");
				    	commonService.update("model_SQL.updateModelCat", setData);	
				    }
			    	else if("DEL".equals(ChangeTypeCode)) {
						Map setData = new HashMap();
				    	setData.put("itemID", itemId);				
				    	setData.put("deleted", "1");	
				    	setData.put("lastUser", sessionUserId);				    
				    	commonService.update("project_SQL.updateItemDeletedFromCS", setData);	

						for (int j = 0; j < childItemList.size(); j++) {
							updateItemMap = new HashMap();
							updateItemMap.put("itemID", childItemList.get(j));
							updateItemMap.put("deleted", "1");
							updateItemMap.put("lastUser", sessionUserId);
							commonService.update("project_SQL.updateItemDeletedFromCS", updateItemMap);	
						}						
			    	}
			    	
                    /* Update Team Role Assigned value */
				    setMap.put("assgnVal", "1");
				    setMap.put("assigned", "2");
				    setMap.put("itemID", itemId);
				    //setMap.put("changeSetID", changeSetId);
				    setMap.remove("changeSetID");
				    
					commonService.update("role_SQL.updateTeamRole", setMap);
					
					for (int j = 0; j < childItemList.size(); j++) {
					    setMap.put("itemID", childItemList.get(j));
					    
						commonService.update("role_SQL.updateTeamRole", setMap);
					}

				    setMap.put("assgnVal", "3");
				    setMap.put("assigned", "0");
				    setMap.put("itemID", itemId);
				    
					commonService.update("role_SQL.updateTeamRole", setMap);
					
					for (int j = 0; j < childItemList.size(); j++) {
					    setMap.put("itemID", childItemList.get(j));
					    
						commonService.update("role_SQL.updateTeamRole", setMap);
					}
					
					setMap.put("changeSetID", changeSetId);
					commonService.update("model_SQL.updateElementReleaseNo", setMap);
					
					setMap.clear();
					setMap.put("s_itemID", itemId);
					setMap.put("languageID", sessionCurrLangType);
					List cxnItemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
					
					if(cxnItemList != null && !cxnItemList.isEmpty()) {
						for(int j=0; j<cxnItemList.size(); j++) {
							Map cxnMap = (Map)cxnItemList.get(j);
							Map insRevMap = new HashMap();
							
							insRevMap.put("documentID",cxnMap.get("CXNItemID"));
							insRevMap.put("objectType",cxnMap.get("CXNItemTypeCode"));
							insRevMap.put("docCategory","ITM");
							insRevMap.put("changeSetID", changeSetId);
							insRevMap.put("revisionType","CXN");
							insRevMap.put("description","");
							insRevMap.put("authorID",cxnMap.get("AuthorID"));
							insRevMap.put("authorTeamID",cxnMap.get("OwnerTeamID"));

							commonService.insert("revision_SQL.insertRevision", insRevMap);
						}
					}
					
				}			    				    	
		    }
		   			  	
		    //Save PROC_LOG
			/*
			 * setMap.put("sessionCurrLangType", sessionCurrLangType); Map setProcMapRst =
			 * (Map)setProcLog(request, commonService, setMap);
			 * if(setProcMapRst.get("type").equals("FAILE")){ String Msg =
			 * StringUtil.checkNull(setProcMapRst.get("msg"));
			 * System.out.println("Msg : "+Msg); }
			 */			    
						
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
		}
		return model;
	}
	
	@RequestMapping(value="/viewSubItemHistory.do")
	public String viewSubItemHistory(HttpServletRequest request,  HashMap commandMap, ModelMap model) throws Exception{
		String url = "project/changeInfo/viewSubItemHistory";
		try{
			model.put("menu", getLabel(request, commonService));
			
			Map setMap = new HashMap();			
			String subItemClsList = StringUtil.checkNull(request.getParameter("subItemClsList"),"");
			String csStatus = StringUtil.checkNull(request.getParameter("csStatus"),"");
			
			model.put("subItemClsList", subItemClsList);
			model.put("csStatus", csStatus);
			
			String subItemClassList = "";
			if(!subItemClsList.equals("")) {
				String subItemClass[] = subItemClsList.split(",");
				for(int i=0; i<subItemClass.length; i++) {
					if(i == 0) {
						subItemClassList = "'" + subItemClass[i] + "'";
					}else {
						subItemClassList += ",'" + subItemClass[i] + "'";
					}
				}
				
			}
			setMap.put("subItemclassList", subItemClassList);
			setMap.put("csStatus", csStatus);
			
			setMap.put("s_itemID", StringUtil.checkNull( request.getParameter("s_itemID"),"") );
			setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			
			setMap.put("ItemID", StringUtil.checkNull( request.getParameter("s_itemID"),"") );
			String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));
			List subItemHistoryList = commonService.selectList("cs_SQL.getSubItemHistory_gridList", setMap);
			if(subItemHistoryList.size()>0) {
				for(int i=0; i<subItemHistoryList.size(); i++) {
					Map infoMap = (Map)subItemHistoryList.get(i);
					String subVersion = StringUtil.checkNull(infoMap.get("SubVersion"));
					String changeSetID = StringUtil.checkNull(infoMap.get("ChangeSetID"));
					String itemID = StringUtil.checkNull(infoMap.get("ItemID"));
					String statusCode = StringUtil.checkNull(infoMap.get("StatusCode"));
					
					// fnOpenInfoView(row.ChangeSetID, row.StatusCode, row.ItemID)
					subVersion = "<span onClick='fnOpenTeamPop('"+changeSetID+"','"+statusCode+"','"+itemID+"')'>" + subVersion
					+ "<img class='mgL8' src='/cmm/common/images/detail.png' id='popup' style='width:12px; cursor:pointer;' alt='새창열기'></span>";
					infoMap.put("SubVersion", subVersion);
				}		
				
			}
			
			JSONArray subItemHistoryListData = new JSONArray(subItemHistoryList);
			model.put("subItemHistoryList", subItemHistoryListData);
			model.put("totalCnt", subItemHistoryList.size());
			model.put("s_itemID", StringUtil.checkNull( request.getParameter("s_itemID"),"") );
			model.put("changeMgt", changeMgt);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/csListBySCR.do")
	public String csListBySCR(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "project/changeInfo/csListBySCR";
		try {	
				String scrID = StringUtil.checkNull(request.getParameter("scrID"));
				String csrID = StringUtil.checkNull(request.getParameter("csrID"));
				String scrRegUser = StringUtil.checkNull(request.getParameter("scrRegUser"));
				model.put("menu", getLabel(request, commonService));
				Map setData = new HashMap();
				setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				List csList = commonService.selectList("cs_SQL.getChangeSetList_gridList", commandMap);
				
				JSONArray gridData = new JSONArray(csList);
				model.put("gridData", gridData);
				model.put("scrID", scrID);
				model.put("csrID", csrID);
				model.put("scrRegUser", scrRegUser);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl(url);
	}
	
	@RequestMapping(value = "/checkChangeMgt.do")
	public void checkChangeMgt(HashMap cmmMap, HttpServletResponse response)  throws Exception {
		try {			
			String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", cmmMap));
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/plain");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().print(changeMgt);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
	
	@RequestMapping(value = "/csAprvPostProcessing.do")
	public String csAprvPostProcessing(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		Map updateMap = new HashMap();
		Map tempMap = new HashMap();
		Map updateItemMap = new HashMap();
		HashMap reworkMap = new HashMap();
		
			try {	
				
				String wfInstanceStatus = StringUtil.checkNull(commandMap.get("wfInstanceStatus"),"");
				String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"),"");
				String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));	
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String status = StringUtil.checkNull(commandMap.get("status"));
				String preFileBlocked = StringUtil.checkNull(commandMap.get("preFileBlocked"));
				String rjtProcOption = StringUtil.checkNull(commandMap.get("rjtProcOption"));
				String childLevel = StringUtil.checkNull(request.getParameter("childLevel"),"0");
				
				
				// 1) 기술 문서 신규 등록 시 Identifier  생성	>> 기존 HEC 생성 로직을 SKON 생성 규칙에 맞게 수정 필요  
				
				setMap.put("languageID", languageID);		
		  		setMap.put("wfInstanceID", wfInstanceID);
		  		Map csInfo = commonService.select("wf_SQL.getChangeSetInfoWF", setMap);
		  		
		  		String itemID = StringUtil.checkNull(csInfo.get("ItemID"));	
	            String ChangeTypeCode = StringUtil.checkNull(csInfo.get("ChangeTypeCode"));
	            String itemTypeCode = StringUtil.checkNull(csInfo.get("ItemTypeCode"));

	      		String parentID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemParentID", setMap));
	           // setMap.put("s_itemID", 103109);   // 전극을 임시 ParentID 로 설정해서 테스트 중
	           // String maxIdentifier = StringUtil.checkNull(this.commonService.selectString("item_SQL.getMaxIdentifierFromParentID", setMap));
	      		setMap.put("itemID", itemID);
	      		//문서채번 
	      		String docIdentifier= StringUtil.checkNull(this.commonService.selectString("item_SQL.s_itemIDentifier", setMap),""); //기존 identifier
	      		String docNum = "";
	      		String newDocIdenfier = "";
				String oldDocIdentifier  = "" ;// 비교할 문서번호 
	       
	            if ("NEW".equals(ChangeTypeCode) && "OJ00016".equals(itemTypeCode)&& "2".equals(wfInstanceStatus)) {//재정 & TSD & 최종 승인
			        if (docIdentifier.equals("")) { //문서 채번이 안되있는경우 
			        	setMap.put("itemID",itemID);
			        	newDocIdenfier = StringUtil.checkNull(this.commonService.selectString("zSK_SQL.fn_createItemIdentifier", setMap));
			        	setMap.put("ClassCode", "CL16004");
			        	setMap.put("docIdentifier", newDocIdenfier);
						docNum = commonService.selectString("zSK_SQL.getMaxIdentifier", setMap);
						docIdentifier = newDocIdenfier+"-"+docNum;
			        }
			        else {// 채번이 되어있는경우 
			        	setMap.put("itemID",itemID);
			        	newDocIdenfier = StringUtil.checkNull(this.commonService.selectString("zSK_SQL.fn_createItemIdentifier", setMap));
			      
			        	oldDocIdentifier=StringUtil.checkNull(docIdentifier.substring(0, docIdentifier.length() - 4),"");
			        	if(!oldDocIdentifier.equals(newDocIdenfier)) {// 기존문서번호와 변경이 있다면 
			        		setMap.put("ClassCode", "CL16004");
			        		setMap.put("docIdentifier", newDocIdenfier);
			        		docNum = commonService.selectString("zSK_SQL.getMaxIdentifier", setMap);
			        		docIdentifier=newDocIdenfier+"-"+docNum;
			        	}else {
			        		docNum=StringUtil.checkNull(docIdentifier.substring(docIdentifier.length() - 3),"");//기존 문서번호 
			        		oldDocIdentifier=StringUtil.checkNull(docIdentifier.substring(0, docIdentifier.length() - 4),"");
			        		docIdentifier = oldDocIdentifier+"-"+docNum;
			        	}
			        }
			
			        setMap.put("Identifier",docIdentifier );
			        setMap.put("ItemID", itemID);
			        setMap.put("CategoryCode", "OJ");
			        this.commonService.update("item_SQL.updateItemObjectInfo", setMap);
			     }
								
				// 2) 표준 CS 결재 처리	
	            
			    List csList = commonService.selectList("cs_SQL.getChangeSetList_gridList", setMap);	
				
			    if(csList.size() > 0) {
			    	String items = "";
					String cngts = "";
					String pjtIds = "";
			    	for(int i=0; csList.size()>i; i++) {
			    		Map csInfoMap = (Map)csList.get(i);
			    		if(i==0) {
			    			items = StringUtil.checkNull(csInfoMap.get("ItemID"));
			    			cngts = StringUtil.checkNull(csInfoMap.get("ChangeSetID"));
			    			pjtIds = StringUtil.checkNull(csInfoMap.get("ProjectID"));
			    			
			    			// KPAL 자동 rework
			    			reworkMap.put("item",items);
							reworkMap.put("cngt",cngts);
							reworkMap.put("pjtId",pjtIds);
			    			
			    		}else {
			    			items += "," + StringUtil.checkNull(csInfoMap.get("ItemID"));
			    			cngts += "," + StringUtil.checkNull(csInfoMap.get("ChangeSetID"));
			    			pjtIds += "," + StringUtil.checkNull(csInfoMap.get("ProjectID"));
			    		}
			    	}
			    	commandMap.put("items", items);
				    commandMap.put("cngts", cngts);
				    commandMap.put("pjtIds", pjtIds);
			    }
			    
			    if("2".equals(wfInstanceStatus)) {			   
			    	ModelMap temp = closeCS(request, commandMap, model);	   			  	
			    }else if("3".equals(wfInstanceStatus)) {
			    	if("1".equals(rjtProcOption)) {
			    		// KPAL 자동 rework
						doRework(reworkMap, commandMap);
			    	} else {
			    		for(int i=0; i<csList.size(); i++){
			    			
			    			tempMap = (Map)csList.get(i);
			    			String csID = StringUtil.checkNull(tempMap.get("ChangeSetID"));
			    			String projectID = StringUtil.checkNull(tempMap.get("ProjectID"));
			    			
			    			updateMap.put("s_itemID", csID);
			    			updateMap.put("csStatus", "HOLD");						   
			    			commonService.update("cs_SQL.updateChangeSetClose", updateMap);
			    			
			    			String csItemID = StringUtil.checkNull(tempMap.get("ItemID"));
			    			List childItemList = getChildItemList(csItemID,childLevel);
			    			
			    			setMap.put("s_itemID", csItemID);
			    			setMap.put("csID", csID);			    	
			    			
			    			//commonService.update("fileMgt_SQL.updateFileBlockWithCSID", setMap);			    	
			    			
			    			// MANDO 원복
			    			if("2".equals(rjtProcOption)) {
				    			Map setData = new HashMap();
				    			setData.put("itemID", csItemID);	
				    			setData.put("changeSetID", csID); 
				    			setData.put("languageID", languageID);
				    			setData.put("orgMTCategory", "TOBE");	
				    			setData.put("updateMTCategory", "WTR");
				    			
				    			if("NEW".equals(tempMap.get("ChangeTypeCode"))) {						
				    				setData.put("orgMTCategory", "BAS");				    	
				    			}
			    				commonService.update("model_SQL.updateModelCat", setData);
			    				commonService.update("attr_SQL.recoverItemAttr", setData);
			    			}
			    		}				    	
			    	}
			    }
			   	
			    //Save PROC_LOG
			    setMap.put("sessionCurrLangType", languageID);
				Map setProcMapRst = (Map)setProcLog(request, commonService, setMap);
				if(setProcMapRst.get("type").equals("FAILE")){
					String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
					System.out.println("Msg : "+Msg);
				}	
				
				String screenType = StringUtil.checkNull(request.getParameter("screenType"));
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 	
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
			} catch (Exception e) {
				System.out.println(e);
				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); 												
			}
			model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(AJAXPAGE);
		
		}
		
	@RequestMapping(value = "/checkInPassCheck.do")
	public void checkInPassCheck(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap) throws Exception {
		JSONObject jsonObject = new JSONObject();
		HashMap target = new HashMap();
		Map map = new HashMap();
		
		res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
		
	    try {
	    	String itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
	    	String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
	    	String cngts = StringUtil.checkNull(request.getParameter("cngts"),"");
	    	map.put("itemID", itemID);
	    	map.put("changeSetID", cngts);
	    	map.put("languageID", languageID);

			String messageCode = commonService.selectString("cs_SQL.checkInPassCheck", map); 
			String[] attrTypeName = new String[] {""};
			if(messageCode != null&&!messageCode.isEmpty()) {
			
			
			
					String[] messageTokens = messageCode.split("\\|"); 
			
					String firstCode ="";
					if(messageTokens.length >0) {
						String [] firstPair = messageTokens[0].split(",",2);
						firstCode = firstPair[0].trim();
						
					}

					LinkedHashSet<String> labels = new LinkedHashSet<>();
					for(String token: messageTokens) {
						if (token == null || token.isEmpty()) continue;
						String[] pair = token.split(",", 2); 
						  if (pair.length > 1) {
					            String label = pair[1].trim();
					            if (!label.isEmpty()) labels.add(label);
					        }
						  
					}
			
				    String joinedLabels = String.join(", ", labels);
				    attrTypeName = new String[] {joinedLabels};
				    String message;
				    if (!joinedLabels.isEmpty()) {
				        message = MessageHandler.getMessage( cmmMap.get("sessionCurrLangCode") + "." + firstCode, attrTypeName);
				    } else {
				     
				        message = MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + "." + firstCode);
				    }
				    jsonObject.put("message", message);
		
			} else {
				jsonObject.put("message","");
			}
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	    }
	}
	
	@RequestMapping(value = "/getItemCSInfo.do", method = RequestMethod.GET)
	public void getItemCSInfo(HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map<String, Object> map = new HashMap<>();

		res.setHeader("Cache-Control", "no-cache");
		res.setContentType("application/json");
	    res.setCharacterEncoding("UTF-8");
	    
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			
			map.put("s_itemID", s_itemID);
			map.put("languageID", languageID);
		
			List csList = commonService.selectList("cs_SQL.getItemChangeList_gridList", map);
			jsonObject.put("list", csList);
	        res.getWriter().print(jsonObject);
		} catch (Exception e) {
			e.printStackTrace();
	        jsonObject.put("list", new ArrayList<>());
	        res.getWriter().print(jsonObject);
		}
	}
	
	// csr 개수 리턴 받는 api 
	@RequestMapping(value = "/getMyCSRCount.do", method = RequestMethod.POST)
	@ResponseBody
	public String getProjectListSize(HttpServletRequest request, @RequestParam Map<String, Object> paramMap,HashMap commandMap) throws Exception {

	    JSONObject dataInfo = new JSONObject();
	    JSONObject resultMap = new JSONObject();
	  
	    try {
	        String itemID = StringUtil.checkNull(paramMap.get("s_itemID"));
	        String userId = StringUtil.checkNull(commandMap.get("sessionUserId"));
	        String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
	        String checkType = StringUtil.checkNull(commandMap.get("checkType"),"OUT");
	
			String status = StringUtil.checkNull(commandMap.get("status"));	
			String changeType = StringUtil.checkNull(request.getParameter("changeType"),"");

	        
	        
	        Map<String, Object> setMap = new HashMap<>();
	    	setMap.put("userId", userId);
			setMap.put("LanguageID", languageID);
	        setMap.put("s_itemID", itemID);
	        setMap.put("ProjectType", "CSR");
	        setMap.put("isMainItem", "Y");
	        setMap.put("status", "CNG");


	        List<?> projectNameList = commonService.selectList("project_SQL.getProjectNameList", setMap);
	        dataInfo.put("size", projectNameList.size());

	 
	        if (projectNameList.size() < 2) {
	            setMap.put("itemID", itemID);
	            setMap.put("userID", userId);
	            String projectID = StringUtil.checkNull(commonService.selectString("item_SQL.getItemClassDefCSRID", setMap));
	            if(projectID == null || projectID.isEmpty()) {
	            	projectID = StringUtil.checkNull(commonService.selectString("project_SQL.getPjtMbrRelProjectID", setMap));
	            }
	            dataInfo.put("projectID", projectID);
	        }

	    } catch (Exception e) {
	    	dataInfo.put("size", -1);
	    	dataInfo.put("error", e.toString());
	    }

	    resultMap.put("dataInfo", dataInfo);
	    return resultMap.toString(); 
	}

}
