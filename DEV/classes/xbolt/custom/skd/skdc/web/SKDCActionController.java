package xbolt.custom.skd.skdc.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CompletableFuture;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipOutputStream;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.AESUtil;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.DrmGlobalVal;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.link.sso.ms.callgraphwebapp.CallGraphServlet;
import xbolt.link.sso.ms.helpers.AuthHelper;
import xbolt.link.sso.ms.helpers.Config;
import xbolt.link.sso.ms.helpers.GraphHelper;
import xbolt.link.sso.ms.helpers.IdentityContextAdapterServlet;

import com.azure.identity.ClientSecretCredential;
import com.azure.identity.ClientSecretCredentialBuilder;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonObject;
import com.microsoft.aad.msal4j.IAccount;
import com.microsoft.graph.authentication.TokenCredentialAuthProvider;
import com.microsoft.graph.models.User;
import com.microsoft.graph.requests.GraphServiceClient;
import com.microsoft.graph.requests.UserCollectionPage;
import com.org.json.JSONArray;
import com.org.json.JSONObject;

/**
 * @Class Name : SKDCActionController.java
 * @Description : SKDCActionController.java
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2023. 11. 21. smartfactory		최초생성
 *
 * @since 2023. 11. 21
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class SKDCActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;	
	
	@Resource(name = "CxnItemService")
	private CommonService CxnItemService;
	
	private AESUtil aesAction;
	
	@RequestMapping(value="/zSkdc_subItemFileList.do")
	public String zSkdc_subItemFileList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "/custom/skd/skdc/item/zSkdc_subItemFileList";
		try {
			model.put("menu", getLabel(request, commonService));
			String s_itemID = StringUtil.checkNull(request.getParameter("mstItemID"), "");
			String strItemID = StringUtil.checkNull(request.getParameter("strItemID"), "");
			String mstItemID = StringUtil.checkNull(request.getParameter("mstItemID"), "");
			String showVersion = StringUtil.checkNull(request.getParameter("varFilter"), "N");	
			String showValid = StringUtil.checkNull(request.getParameter("varFilter"), "N");	
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
			String docAllocRpt = StringUtil.checkNull(request.getParameter("docAllocRpt"));
			
			Map setData = new HashMap();
			setData.put("itemID", s_itemID);
			setData.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
			Map itemTypeMap = commonService.select("common_SQL.itemTypeCode_commonSelect", setData);
			
			model.put("itemID", s_itemID);
			model.put("showValid", showValid);
			model.put("showVersion", showVersion);
			model.put("fltpCode", fltpCode);
			model.put("itemTypeName", StringUtil.checkNull(itemTypeMap.get("NAME")));
			model.put("itemTypeCode", StringUtil.checkNull(itemTypeMap.get("CODE")));
			model.put("strItemID", strItemID);
			model.put("mstItemID", mstItemID);
			model.put("s_itemID", s_itemID);
			model.put("docAllocRpt", docAllocRpt);
			model.put("myCSR", StringUtil.checkNull(cmmMap.get("myCSR"), ""));
			model.put("csrIDs", StringUtil.checkNull(cmmMap.get("csrIDs"), ""));
			model.put("udfSTR", StringUtil.checkNull(cmmMap.get("udfSTR"), ""));
			model.put("arcCode", StringUtil.checkNull(cmmMap.get("option"), ""));
			
			setData.put("s_itemID", s_itemID);
			setData.put("strItemID", strItemID);
			setData.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			setData.put("myCSR", StringUtil.checkNull(cmmMap.get("myCSR"), ""));
			setData.put("csrIDs", StringUtil.checkNull(cmmMap.get("csrIDs"), ""));
			setData.put("udfSTR", StringUtil.checkNull(cmmMap.get("udfSTR"), ""));
			if(StringUtil.checkNull(cmmMap.get("udfSTR")).equals("Y")) {
				setData.put("categoryCode", "ST3");
			}else {
				setData.put("categoryCode", "ST2");
			}
			List strItemSubFileList = commonService.selectList("custom_SQL.zSkdc_getSubItemFileList_gridList", setData);
		
			JSONArray gridData = new JSONArray(strItemSubFileList);
			model.put("gridData", gridData);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
			
		return nextUrl(url);
	}
	
	@RequestMapping(value="/zSkdc_editSubItemFileList.do")
	public String zSkdc_editSubItemFileList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "/custom/skd/skdc/item/zSkdc_editSubItemFileList";
		try {
			model.put("menu", getLabel(request, commonService));
			String s_itemID = StringUtil.checkNull(request.getParameter("mstItemID"), "");
			String strItemID = StringUtil.checkNull(request.getParameter("strItemID"), "");
			String mstItemID = StringUtil.checkNull(request.getParameter("mstItemID"), "");
			String showVersion = StringUtil.checkNull(request.getParameter("varFilter"), "N");	
			String showValid = StringUtil.checkNull(request.getParameter("varFilter"), "N");	
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
			String docAllocRpt = StringUtil.checkNull(request.getParameter("docAllocRpt"));
			
			Map setData = new HashMap();
			setData.put("itemID", s_itemID);
			setData.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
			Map itemTypeMap = commonService.select("common_SQL.itemTypeCode_commonSelect", setData);
			
			model.put("itemID", s_itemID);
			model.put("showValid", showValid);
			model.put("showVersion", showVersion);
			model.put("fltpCode", fltpCode);
			model.put("itemTypeName", StringUtil.checkNull(itemTypeMap.get("NAME")));
			model.put("itemTypeCode", StringUtil.checkNull(itemTypeMap.get("CODE")));
			model.put("strItemID", strItemID);
			model.put("mstItemID", mstItemID);
			model.put("s_itemID", s_itemID);
			model.put("docAllocRpt", docAllocRpt);
			model.put("udfSTR", StringUtil.checkNull(cmmMap.get("udfSTR"), ""));
			
			setData.put("udfSTR", StringUtil.checkNull(cmmMap.get("udfSTR"), ""));
			if(StringUtil.checkNull(cmmMap.get("udfSTR")).equals("Y")) {
				setData.put("categoryCode", "ST3");
			}else {
				setData.put("categoryCode", "ST2");
			}
			
			setData.put("s_itemID", s_itemID);
			setData.put("strItemID", strItemID);
			setData.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			List strItemSubFileList = commonService.selectList("custom_SQL.zSkdc_getSubItemFileList_gridList", setData);
		
			JSONArray gridData = new JSONArray(strItemSubFileList);
			model.put("gridData", gridData);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
			
		return nextUrl(url);
	}
	
	@RequestMapping(value="/zSkdc_updateItemAttr.do")
	public String zSkdc_updateItemAttr (HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try{
			Map setData = new HashMap();
			JSONArray jsonArray = new JSONArray(request.getParameter("updateData"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),"");
			String itemID = "";
			List itemIDS = new ArrayList();
			JSONObject jsonData;
			setData.put("languageID", languageID);
			for (int i = 0; i < jsonArray.length(); i++) {
				jsonData = (JSONObject) jsonArray.get(i);
				
				setData = new HashMap();
				setData.put("languageID", languageID);
				itemID = StringUtil.checkNull(jsonData.get("MstItemID"), "");
				String itemNo = StringUtil.checkNull(jsonData.get("ItemNo"), "");
				
				if(!itemIDS.contains(itemID)) {
					setData.put("ItemID", itemID);
					setData.put("AttrTypeCode", "AT00000"); 
					setData.put("PlainText", itemNo);
								
					int itemAttrCnt = Integer.parseInt(commonService.selectString("report_SQL.getItemAttrCnt", setData)); // itemAttr 유무 check
					
					if(itemAttrCnt >0){ // update 
						commonService.insert("item_SQL.updateItemAttr", setData);							
					}else{ // insert 
						commonService.insert("item_SQL.setItemAttr", setData);
					}		
					
					itemIDS.add(itemID);
				
				}
			}
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "parent.fnGoFileList();parent.$('#isSubmit').remove();");
			
		}catch (Exception e) {
			System.out.println(e); 
			throw new ExceptionUtil(e.toString()); 
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	} 
	
	@RequestMapping(value="/zSkdc_strDocCodeFileList.do")
	public String zSkdc_strDocCodeFileList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "/custom/skd/skdc/item/zSkdc_strDocCodeFileList";
		try {
			model.put("menu", getLabel(request, commonService));
			String s_itemID = StringUtil.checkNull(request.getParameter("mstItemID"), "");
			String strItemID = StringUtil.checkNull(request.getParameter("strItemID"), "");
			String mstItemID = StringUtil.checkNull(request.getParameter("mstItemID"), "");
			
			Map setData = new HashMap();			
			model.put("itemID", s_itemID);
			model.put("strItemID", strItemID);
			model.put("mstItemID", mstItemID);
			model.put("s_itemID", s_itemID);
			
			setData.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			
			setData.put("itemID", mstItemID);
			List strDocCodeFileList = commonService.selectList("custom_SQL.zSkdc_getStrDocumentNameList", setData); 
			Map L0DocInfo = null;
			Map itemInfoMap = null;
			int docCodeLen = 0;
			String L0ID = ""; String L1ID = ""; String L2ID = ""; String L3ID = ""; String L4ID = ""; String L5ID = "";
			String L0ItemID = ""; String L1ItemID = ""; String L2ItemID = ""; String L3ItemID = ""; String L4ItemID = ""; String L5ItemID = "";

			
			if(strDocCodeFileList.size() > 0) {
				for(int i=0; i < strDocCodeFileList.size(); i++) {
		 			Map strDocInfo = (Map)strDocCodeFileList.get(i);
		 			String errLogYN = "";
		 			
		 			String docCode = StringUtil.checkNull(strDocInfo.get("NewIdentifier"));
					
					setData.put("itemClassCode", "CL16000");
					setData.put("docCode", docCode);					
					
					L0DocInfo = (Map)commonService.select("custom_SQL.zSkdc_getDocInfo", setData); // Identifier(docCode)의 첫번째 Code 추출(L0 : A r-BHET 5만톤 공장)
					String L0Identifier = StringUtil.checkNull(L0DocInfo.get("Identifier"));
					String structureID = StringUtil.checkNull(L0DocInfo.get("StructureID"));
					setData.put("structureID", structureID);
					
					docCodeLen = 1;
					//L0ID = null; 
					L0ID = L0Identifier;
					L1ID = ""; L2ID = ""; L3ID = ""; L4ID = ""; L5ID = "";
					
					setData.put("docID", docCode);
					
					// get L0ID 
					setData.put("identifier", L0Identifier);
					setData.put("classCode", "CL16000");
					setData.put("docCodeLen", docCodeLen);
					L0ID = StringUtil.checkNull(commonService.selectString("custom_SQL.zSkdc_getIdentifierByDocCode", setData));
					setData.put("Y","identifierNotNull");
					itemInfoMap = (Map)commonService.select("item_SQL.getItemInfoByIdentifier", setData);
					if(!itemInfoMap.isEmpty()) {
						strDocInfo.put("L0ItemID", itemInfoMap.get("ItemID"));
						strDocInfo.put("L0ItemName", itemInfoMap.get("ItemName"));
					}
					
					if(!L0ID.equals(L0Identifier)){
						// L0 부터 없음
						errLogYN = "Y";
					}
					
					// get L1ID 
					setData.put("L0ID", L0Identifier);
					setData.put("classCode", "CL16001");
					docCodeLen = docCodeLen + L0ID.length();
					setData.put("docCodeLen", docCodeLen);
					
					if(!L0ID.equals("")) {
						
						L1ID = StringUtil.checkNull(commonService.selectString("custom_SQL.zSkdc_getIdentifierByDocCode", setData));
						setData.put("identifier", L1ID);
						setData.put("Y","identifierNotNull");
						itemInfoMap = (Map)commonService.select("item_SQL.getItemInfoByIdentifier", setData);
						if(!itemInfoMap.isEmpty()) {
							strDocInfo.put("L1ItemID", itemInfoMap.get("ItemID"));
							strDocInfo.put("L1ItemName", itemInfoMap.get("ItemName"));
						}
					}else if(docCode.length() > docCodeLen){
						// L1 부터 없음
						errLogYN = "Y";
					}
					
					setData.put("L1ID", L1ID);
					setData.put("classCode", "CL16002");
					docCodeLen = docCodeLen + L1ID.length();
					setData.put("docCodeLen", docCodeLen);	
					if(!L1ID.equals("")) {
						L2ID = StringUtil.checkNull(commonService.selectString("custom_SQL.zSkdc_getIdentifierByDocCode", setData));
						setData.put("identifier", L2ID);
						setData.put("Y","identifierNotNull");
						itemInfoMap = (Map)commonService.select("item_SQL.getItemInfoByIdentifier", setData);
						if(!itemInfoMap.isEmpty()) {
							strDocInfo.put("L2ItemID", itemInfoMap.get("ItemID"));
							strDocInfo.put("L2ItemName", itemInfoMap.get("ItemName"));
						}
					}else if(docCode.length() > docCodeLen){
						// L12부터 없음
						errLogYN = "Y";
					}
										
					setData.put("L2ID", L2ID);
					setData.put("classCode", "CL16003");
					docCodeLen = docCodeLen + L2ID.length();
					setData.put("docCodeLen", docCodeLen);
					if(!L2ID.equals("")) {
						L3ID = StringUtil.checkNull(commonService.selectString("custom_SQL.zSkdc_getIdentifierByDocCode", setData));
						setData.put("identifier", L3ID);
						setData.put("Y","identifierNotNull");
						itemInfoMap = (Map)commonService.select("item_SQL.getItemInfoByIdentifier", setData);
						if(!itemInfoMap.isEmpty()) {
							strDocInfo.put("L3ItemID", itemInfoMap.get("ItemID"));
							strDocInfo.put("L3ItemName", itemInfoMap.get("ItemName"));
						}
					}else if(docCode.length() > docCodeLen){
						// L3부터 없음
						errLogYN = "Y";
					}
						
					setData.put("L3ID", L3ID);
					setData.put("classCode", "CL16004");
					docCodeLen = docCodeLen + L3ID.length();
					setData.put("docCodeLen", docCodeLen);
					if(!L3ID.equals("")) {
						L4ID = StringUtil.checkNull(commonService.selectString("custom_SQL.zSkdc_getIdentifierByDocCode", setData));
						
						setData.put("identifier", L4ID);	
						setData.put("Y","identifierNotNull");
						itemInfoMap = (Map)commonService.select("item_SQL.getItemInfoByIdentifier", setData);
						if(!itemInfoMap.isEmpty()) {
							strDocInfo.put("L4ItemID", itemInfoMap.get("ItemID"));
							strDocInfo.put("L4ItemName", itemInfoMap.get("ItemName"));
						}
					}else if(docCode.length() > docCodeLen){
						// L4 부터 없음
						errLogYN = "Y";
					}
							
					setData.put("L4ID", L4ID);
					setData.put("classCode", "CL16005");
					docCodeLen = docCodeLen + L4ID.length();
					setData.put("docCodeLen", docCodeLen);
					if(!L4ID.equals("")) {
						L5ID = StringUtil.checkNull(commonService.selectString("custom_SQL.zSkdc_getIdentifierByDocCode", setData));
						setData.put("identifier", L5ID);	
						setData.put("Y","identifierNotNull");
						itemInfoMap = (Map)commonService.select("item_SQL.getItemInfoByIdentifier", setData);
						if(!itemInfoMap.isEmpty()) {
							strDocInfo.put("L5ItemID", itemInfoMap.get("ItemID"));
							strDocInfo.put("L5ItemName", itemInfoMap.get("ItemName"));
						}
					}else if(docCode.length() > docCodeLen){
						errLogYN = "Y";
					}
					
					if(errLogYN.equals("Y")) {
						strDocInfo.put("Description", "파일명 수정 후 재업로드 하세요.");
						strDocInfo.put("errLogYN", errLogYN);
						
						setData.put("Seq", strDocInfo.get("Seq"));
						setData.put("status", "1");
						setData.put("sessionUserId", StringUtil.checkNull(cmmMap.get("sessionUserId")));
						commonService.update("fileMgt_SQL.updateFileDescription", setData);
						
					}else {
						setData.put("Seq", strDocInfo.get("Seq"));
						setData.put("status", "");
						setData.put("sessionUserId", StringUtil.checkNull(cmmMap.get("sessionUserId")));
						commonService.update("fileMgt_SQL.updateFileDescription", setData);
					}
				}
			}
		
			JSONArray gridData = new JSONArray(strDocCodeFileList);
			model.put("gridData", gridData);
			
			setData = new HashMap();
			setData.put("userId", StringUtil.checkNull(cmmMap.get("sessionUserId")));
			setData.put("LanguageID", cmmMap.get("sessionCurrLangType"));
			// setData.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			setData.put("ProjectType", "CSR");
			setData.put("isMainItem", "Y");
			List projectNameList = commonService.selectList("project_SQL.getProjectNameList", setData);
			model.put("projectNameList", projectNameList);
			model.put("projectNameListSize", projectNameList.size());
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
			
		return nextUrl(url);
	}
	
	@RequestMapping(value="/zSkdc_fileUploadClassificationn.do")
	public String zSkdc_fileUploadClassificationn(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		Map target = new HashMap();
		
		try{
			Map setMap = new HashMap();
			
			String seq =  StringUtil.checkNull(request.getParameter("seq"), "");
			
			setMap.put("seq",seq);
			
			commonService.update("fileMgt_SQL.updateFileBlocked", setMap);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT,  "doSearchList();parent.$('#isSubmit').remove();");
			
		}catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/zSkdc_createStrWithDocCode.do")
	public String  zSkdc_createStrWithDocCode(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
			Map createStrPathByDocCode = null;
			
			// 1. 첨부문서 기반 L0 하위에 item, ST2 생성
			String updateData = StringUtil.checkNull(request.getParameter("updateData"));
			String categorizeReturnValue =  zSkdc_createStrItemWithFile(cmmMap,updateData);
			//System.out.println("categorizeReturnValue :"+categorizeReturnValue);
			
			// 2. 첨부문서 DocCode 기반으로 ST2 유무 확인후 없으면 생성 (잘못된 str path 메세지 작성)
			createStrPathByDocCode = zSkdc_createStrPathByDocCode(cmmMap);
			//System.out.println("createStrPathByDocCode :"+createStrPathByDocCode);
			
			// 3. 첨부문서 DocCode 기반으로 parentID, fromItemID update 
			List updateStrItemIDList = zSkdc_updateStrPathByDocument(cmmMap);
			//System.out.println("zSkdc_updateStrPathByDocument updateStrCount :"+updateStrCount);
			System.out.println("updateStrItemIDList :"+updateStrItemIDList);
			
			commonService.selectString("item_SQL.insertStrItemHierarchy", cmmMap);
			
			if(updateStrItemIDList.size() > 0) { // 신규생성된 strItemID 상위
				zSkdc_createBEDPModel(cmmMap, updateStrItemIDList);
			}
			
			String errMsg = StringUtil.checkNull(createStrPathByDocCode.get("errMsg"));		
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "this.doSearchList();");
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}	
	
	// 신규생성된 strItemID 모델 생성
	public void zSkdc_createBEDPModel(HashMap cmmMap, List updateStrItemIDList) throws Exception{
		try{
			Map setData = new HashMap();
			List strItemIDList = new ArrayList();
			
			for(int i=0; updateStrItemIDList.size() > i; i++) {
				String strItemID = StringUtil.checkNull(updateStrItemIDList.get(i));
				
				setData.put("itemID", strItemID);
				String classCode = commonService.selectString("item_SQL.getClassCode", setData);
				
				setData.put("strItemID", strItemID);
				setData.put("ItemClassCode", classCode);
				Map itemStrHierInfo = (Map)commonService.select("item_SQL.getItemStrHier", setData);
				if(!itemStrHierInfo.isEmpty()) {
					 String L1ItemID =  StringUtil.checkNull(itemStrHierInfo.get("L1ItemID"));
					 String L2ItemID =  StringUtil.checkNull(itemStrHierInfo.get("L2ItemID"));
					 String L3ItemID =  StringUtil.checkNull(itemStrHierInfo.get("L3ItemID"));
					 String L4ItemID =  StringUtil.checkNull(itemStrHierInfo.get("L4ItemID"));
					 String L5ItemID =  StringUtil.checkNull(itemStrHierInfo.get("L5ItemID"));
					 
					 if(!L1ItemID.equals("")) {
						 strItemIDList.add(L1ItemID);
						 
					 }
					 if(!L2ItemID.equals("")) {
						 strItemIDList.add(L2ItemID);
					 
					 }
					 if(!L3ItemID.equals("")) {
						 strItemIDList.add(L3ItemID);
					 
					 }
					 if(!L4ItemID.equals("")) {
						 strItemIDList.add(L4ItemID);
					 
					 }
					 if(!L5ItemID.equals("")) {
						 strItemIDList.add(L5ItemID);
					 }
				}
			}
			
			System.out.println("create model strItemIDList "+strItemIDList.size()+":"+strItemIDList);
			setData.put("LanguageID", cmmMap.get("sessionCurrLangType"));
			setData.put("UserId", cmmMap.get("sessionUserId")); 
			setData.put("FontFamily", cmmMap.get("sessionDefFont")); 
			setData.put("FontStyle", cmmMap.get("sessionDefFontStyle")); 
			setData.put("FontSize", cmmMap.get("sessionDefFontSize")); 
			setData.put("FontColor", cmmMap.get("sessionDefFontColor")); 
			setData.put("GUBUN", "insertBaseModel");
			setData.put("dbFuncCode", "CREATE_BEDP");
			if(strItemIDList.size() > 0) {
				 Set<String> uniqueSet = new HashSet<>(strItemIDList);
			        // 중복 제거된 List로 변환
			     List<String> uniqueList = new ArrayList<>(uniqueSet);
			     for(int i=0; uniqueList.size() >i; i++) {
			    	 // 기존 base model - VER 변경
			    	setData.put("itemID", StringUtil.checkNull(uniqueList.get(i)));
			    	setData.put("orgMTCategory", "BAS"); 	
			    	setData.put("updateMTCategory", "VER"); 
	    			
 					commonService.update("model_SQL.updateModelCat", setData);
			    	 
			    	// CREATE BEDP Model
			    	setData.put("ItemID", StringUtil.checkNull(uniqueList.get(i)));
			    	commonService.insert("model_SQL.createBaseModel", setData);
			     }
			}
			
		} catch(Exception e) {
			 System.out.println(e.toString());
		}
	}

	// 1. 첨부문서명 docCode 로 L0 하위에 Item 생성, STR생성 
	public String zSkdc_createStrItemWithFile(HashMap commandMap, String updateData) throws Exception{
		String returnRowCount = "";
		//System.out.println(" zSkdc_createStrItemWithFile 실행");
		try{
			Map setData = new HashMap();
			String mstItemID = StringUtil.checkNull(commandMap.get("mstItemID"), "");
			String strItemID = StringUtil.checkNull(commandMap.get("strItemID"), "");
			String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String sessionTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			
			/*
			 * setData.put("itemID",strItemID); String structureID =
			 * StringUtil.checkNull(commonService.selectString("item_SQL.getStructureID",
			 * setData)); setData.put("structureID",structureID);
			 */
		
			JSONArray jsonArray = new JSONArray(updateData);
			JSONObject jsonData;
			for (int i = 0; i < jsonArray.length(); i++) {
				jsonData = (JSONObject) jsonArray.get(i);
				String seq = StringUtil.checkNull(jsonData.get("Seq"));
				String AT00000 = StringUtil.checkNull(jsonData.get("AT00000"));
				
				setData.put("Seq", seq);
				setData.put("description", AT00000);
				setData.put("sessionUserId",sessionUserID);
				commonService.insert("fileMgt_SQL.updateFileDescription", setData);
			}
			setData.put("mstItemID",mstItemID);
			setData.put("strItemID",strItemID);				
			setData.put("sessionTeamID",sessionTeamID);
			setData.put("sessionUserID",sessionUserID);
			setData.put("csrID",StringUtil.checkNull(commandMap.get("csrID")));
		 	returnRowCount = commonService.selectString("item_SQL.insertStrItemWithFile", setData);
		 	//System.out.println("return Inserted RowCount :"+returnRowCount);
			 	
		} catch(Exception e) {
			 System.out.println(e.toString());
		}
	 
		return returnRowCount;
	}
	
	// 1. 첨부문서명 docCode 로 L0 하위에 Item 생성, STR생성 
	public String zSkdc_createStrItemWithFile_NEW(HashMap commandMap) throws Exception{
		String returnRowCount = "";
		//System.out.println(" zSkdc_createStrItemWithFile 실행");
		try{
			Map setData = new HashMap();
			String mstItemID = StringUtil.checkNull(commandMap.get("mstItemID"), "");
			String strItemID = StringUtil.checkNull(commandMap.get("strItemID"), "");
			String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String sessionTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			
			setData.put("mstItemID",mstItemID);
			setData.put("strItemID",strItemID);				
			setData.put("sessionTeamID",sessionTeamID);
			setData.put("sessionUserID",sessionUserID);
			setData.put("itemID",strItemID);	
			String structureID = StringUtil.checkNull(commonService.selectString("item_SQL.getStructureID", setData));
			setData.put("structureID",structureID);
			
			List strDocumentList = commonService.selectList("customer_SQL.zSkdc_getStrDocumentNameList", setData);
			
			String docName = "";
			String docSeq = "";
			String newIdentifier = "";
			String plainText = "";
		 	if(strDocumentList.size() > 0) {
		 		for(int i=0; i < strDocumentList.size(); i++) {
		 			Map strDocInfo = (Map)strDocumentList.get(i);
		 			docName = StringUtil.checkNull(strDocInfo.get("DocumentName"));
		 			newIdentifier = StringUtil.checkNull(strDocInfo.get("NewIdnetifier"));
		 			docSeq = StringUtil.checkNull(strDocInfo.get("Seq"));
		 			plainText = StringUtil.checkNull(strDocInfo.get("PlainText"));
		 			
		 			String newItemID = commonService.selectString("item_SQL.getItemMaxID", setData);
		 			
		 			//String ItemClassCode = ItemClassCode From XBOLTADM.TB_ITEM_CLASS Where ItemTypeCode = 'OJ00016' And Level = 6
		 			//Select @STItemClassCode = ItemClassCode From XBOLTADM.TB_ITEM_CLASS Where ItemTypeCode = 'ST00016' And RefClass = @ItemClassCode
		 			//String itemClassCode = StringUtil.checkNull(commonService.selectString("", arg1));
		 			commandMap.put("s_itemID", mstItemID);
		 			//commandMap.put(key, remappingFunction);
		 			
		 			
		 			// File DocumentID로 생성한 Item 으로 update 
		 			// Update XBOLTADM.TB_FILE SET DocumentID = @MaxItemID Where Seq = @FileSeq
		 			setData.put("seq", docSeq);
		 			setData.put("documentID", newItemID);
		 			commonService.update("fileMgt_SQL.updateFileDocumentID", setData);
		 			
		 		}
		 	}
			/*
			 * 
			 * String s_itemID = StringUtil.checkNull(map.get("s_itemID")); String option =
			 * StringUtil.checkNull(map.get("option")); String sessionUserId =
			 * StringUtil.checkNull(map.get("sessionUserId")); String sessionTeamId =
			 * StringUtil.checkNull(map.get("sessionTeamId")); String newClassCode =
			 * StringUtil.checkNull(map.get("newClassCode")); String identifier =
			 * StringUtil.checkNull(map.get("newIdentifier")); String itemTypeCode =
			 * StringUtil.checkNull(map.get("itemTypeCode")); String IsPublic =
			 * StringUtil.checkNull(map.get("IsPublic")); String csrInfo =
			 * StringUtil.checkNull(map.get("csrInfo")); String refItemID =
			 * StringUtil.checkNull(map.get("refItemID")); String autoID =
			 * StringUtil.checkNull(map.get("autoID")); String preFix =
			 * StringUtil.checkNull(map.get("preFix")); String newItemName =
			 * StringUtil.checkNull(map.get("newItemName")); String cpItemID =
			 * StringUtil.checkNull(map.get("cpItemID")); String mstSTR =
			 * StringUtil.checkNull(map.get("mstSTR")); String strType =
			 * StringUtil.checkNull(map.get("strType")); String mstItemID =
			 * StringUtil.checkNull(map.get("mstItemID")); String structureID =
			 * StringUtil.checkNull(map.get("structureID")); String strLevel =
			 * StringUtil.checkNull(map.get("strLevel")); String strItemTypeCode =
			 * StringUtil.checkNull(map.get("strItemTypeCode")); String mstItemTypeCode =
			 * StringUtil.checkNull(map.get("mstItemTypeCode")); String newItemID =
			 * StringUtil.checkNull(map.get("newItemID"));
			 */
		} catch(Exception e) {
			 System.out.println(e.toString());
		}
	 
		return returnRowCount;
	}
	
	// 2. create ST2 Item Path
	public Map zSkdc_createStrPathByDocCode(HashMap commandMap) throws Exception{ 
		Map returnCreateStrInfo = new HashMap();
		//System.out.println(" zSkdc_createStrByDocCode STR PATH 유무체크 밋 생성  실행");
		try{
			HashMap getData = null;
			HashMap insertData = null;
			Map setData = new HashMap();
			String ItemID = StringUtil.checkNull(commandMap.get("itemID"),"");
			String mstItemID = StringUtil.checkNull(commandMap.get("mstItemID"),"");
			String strItemID = StringUtil.checkNull(commandMap.get("strItemID"),"");
			// String structureID = StringUtil.checkNull(commandMap.get("structureID"),"");
			String sessionCurrLangType = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			Map L0DocInfo = null;
			
			setData.put("itemID", strItemID);
			//setData.put("structureID", structureID);	
			setData.put("languageID", sessionCurrLangType);
			List docList = commonService.selectList("custom_SQL.zSkdc_getDocumentList", setData);

			String L0ID = ""; String L1ID = ""; String L2ID = ""; String L3ID = ""; String L4ID = ""; String L5ID = "";

			String ParentIDCHK = null;
			String FromItemID = null;
			String ToItemID = null;
			int docCodeLen = 0;
			String errLogYN = "";
			String errMsg = "";
			
			if(docList.size() > 0) {
				for (int i = 0; i < docList.size(); i++) {
					getData = (HashMap) docList.get(i);
					errLogYN = "";
					String docID = StringUtil.checkNull(getData.get("docID"));
					String procjectID = StringUtil.checkNull(getData.get("ProjectID"));
					String docName = StringUtil.checkNull(getData.get("DocName"));
					
					setData.put("itemClassCode", "CL16000");
					setData.put("docCode", docID);					
					
					L0DocInfo = (Map)commonService.select("custom_SQL.zSkdc_getDocInfo", setData); // Identifier(docCode)의 첫번째 Code 추출(L0 : A r-BHET 5만톤 공장)
					String L0Identifier = StringUtil.checkNull(L0DocInfo.get("Identifier"));
					String structureID = StringUtil.checkNull(L0DocInfo.get("StructureID"));
					setData.put("structureID", structureID);
					
					docCodeLen = 1;
					//L0ID = null; 
					L0ID = L0Identifier;
					L1ID = ""; L2ID = ""; L3ID = ""; L4ID = ""; L5ID = "";
					
					setData.put("docID", docID);
					
					// get L0ID 
					setData.put("identifier", L0Identifier);
					setData.put("classCode", "CL16000");
					setData.put("docCodeLen", docCodeLen);
					L0ID = StringUtil.checkNull(commonService.selectString("custom_SQL.zSkdc_getIdentifierByDocCode", setData));
					if(!L0ID.equals(L0Identifier)){
						// L0 부터 없음
						errLogYN = "Y";
					}
					
					// get L1ID 
					setData.put("L0ID", L0Identifier);
					setData.put("classCode", "CL16001");
					docCodeLen = docCodeLen + L0ID.length();
					setData.put("docCodeLen", docCodeLen);
					
					if(!L0ID.equals("")) {
						L1ID = StringUtil.checkNull(commonService.selectString("custom_SQL.zSkdc_getIdentifierByDocCode", setData));
					}else if(docID.length() > docCodeLen){
						// L1 부터 없음
						errLogYN = "Y";
					}
					
					setData.put("L1ID", L1ID);
					setData.put("classCode", "CL16002");
					docCodeLen = docCodeLen + L1ID.length();
					setData.put("docCodeLen", docCodeLen);	
					if(!L1ID.equals("")) {
						L2ID = StringUtil.checkNull(commonService.selectString("custom_SQL.zSkdc_getIdentifierByDocCode", setData));
					}else if(docID.length() > docCodeLen){
						// L12부터 없음
						if(!"Y".equals(errLogYN)) {
							errLogYN = "Y";
						}
					}
										
					setData.put("L2ID", L2ID);
					setData.put("classCode", "CL16003");
					docCodeLen = docCodeLen + L2ID.length();
					setData.put("docCodeLen", docCodeLen);
					if(!L2ID.equals("")) {
						L3ID = StringUtil.checkNull(commonService.selectString("custom_SQL.zSkdc_getIdentifierByDocCode", setData));
					}else if(docID.length() > docCodeLen){
						// L3부터 없음
						if(!"Y".equals(errLogYN)) {
							errLogYN = "Y";
						}
					}
						
					setData.put("L3ID", L3ID);
					setData.put("classCode", "CL16004");
					docCodeLen = docCodeLen + L3ID.length();
					setData.put("docCodeLen", docCodeLen);
					if(!L3ID.equals("")) {
						L4ID = StringUtil.checkNull(commonService.selectString("custom_SQL.zSkdc_getIdentifierByDocCode", setData));
					}else if(docID.length() > docCodeLen){
						// L4 부터 없음
						if(!"Y".equals(errLogYN)) {
							errLogYN = "Y";
						}
					}
							
					setData.put("L4ID", L4ID);
					setData.put("classCode", "CL16005");
					docCodeLen = docCodeLen + L4ID.length();
					setData.put("docCodeLen", docCodeLen);
					if(!L4ID.equals("")) {
						L5ID = StringUtil.checkNull(commonService.selectString("custom_SQL.zSkdc_getIdentifierByDocCode", setData));
					}else if(docID.length() > docCodeLen){
						// L5 부터 없음
						if(!"Y".equals(errLogYN)) {
							errLogYN = "Y";
						}
					}
					
					if("Y".equals(errLogYN)) {
						errMsg = "Y";
					}
					returnCreateStrInfo.put("errMsg", errMsg); // docCode strPath가 잘못된경우 error msg text 추가
					
					/*
					 * if (docID.length() >= 5) { L0ID = StringUtil.checkNull(docID.substring(0,
					 * Math.min(1, docID.length())), ""); L1ID =
					 * StringUtil.checkNull(docID.substring(1, Math.min(3, docID.length())), "");
					 * L2ID = StringUtil.checkNull(docID.substring(3, Math.min(5, docID.length())),
					 * ""); if (docID.length() >= 8) { L3ID =
					 * StringUtil.checkNull(docID.substring(5, Math.min(8, docID.length())), ""); if
					 * (docID.length() >= 11) { L4ID = StringUtil.checkNull(docID.substring(8,
					 * Math.min(11, docID.length())), ""); if (docID.length() >= 14) { L5ID =
					 * StringUtil.checkNull(docID.substring(11, Math.min(14, docID.length())), "");
					 * } } } }
					 */
					
					// L0 임의 지정
					// L0ID = "C";
					
					if(!"Y".equals(errLogYN)) {
					while (true) {
						setData.put("Identifier", L0ID);
						setData.put("ClassCode", "CL16000");
						FromItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getMasterItemID", setData),"");
						
						setData.put("Identifier", L1ID);
						setData.put("ClassCode", "CL16001");
						ToItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getMasterItemID", setData),"");
						
						setData.put("FromItemID", FromItemID);
						setData.put("ToItemID", ToItemID);
						setData.put("categoryCode", "ST2");
						ParentIDCHK = StringUtil.checkNull(commonService.selectString("item_SQL.getStrItemID", setData),"");
						setData.put("ParentIDCHK", ParentIDCHK);
												
						if (ToItemID.equals("")) {
							break;
						}
						
						// L0 - L1 Connection Check
						if (!ParentIDCHK.equals("")) {
							setData.put("PFromItemID", FromItemID);
							setData.put("PToItemID", ToItemID);
							
							setData.put("Identifier", L1ID);
							setData.put("ClassCode", "CL16001");
							FromItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getMasterItemID", setData),"");
							
							setData.put("Identifier", L2ID);
							setData.put("ClassCode", "CL16002");
							ToItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getMasterItemID", setData),"");
							
							setData.put("FromItemID", FromItemID);
							setData.put("ToItemID", ToItemID);
							ParentIDCHK = StringUtil.checkNull(commonService.selectString("item_SQL.getStrItemID", setData),"");
							
							setData.put("ParentIDCHK", ParentIDCHK);
							
							if (ToItemID.equals("")) {
								break;
							} 
														
							// L1 - L2 Connection Check
							if (!ParentIDCHK.equals("")) {
								setData.put("PFromItemID", FromItemID);
								setData.put("PToItemID", ToItemID);
								
								setData.put("Identifier", L2ID);
								setData.put("ClassCode", "CL16002");
								FromItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getMasterItemID", setData),"");
								
								setData.put("Identifier", L3ID);
								setData.put("ClassCode", "CL16003");
								ToItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getMasterItemID", setData),"");
								
								setData.put("FromItemID", FromItemID);
								setData.put("ToItemID", ToItemID);
								ParentIDCHK = StringUtil.checkNull(commonService.selectString("item_SQL.getStrItemID", setData),"");
								setData.put("ParentIDCHK", ParentIDCHK);
								
								if (ToItemID.equals("")) {
									break;
								} 
								
								// L2 - L3 Connection Check
								if (!ParentIDCHK.equals("")) {
									setData.put("PFromItemID", FromItemID);
									setData.put("PToItemID", ToItemID);
									
									setData.put("Identifier", L3ID);
									setData.put("ClassCode", "CL16003");
									FromItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getMasterItemID", setData),"");
									
									setData.put("Identifier", L4ID);
									setData.put("ClassCode", "CL16004");
									ToItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getMasterItemID", setData),"");
									
									setData.put("FromItemID", FromItemID);
									setData.put("ToItemID", ToItemID);
									ParentIDCHK = StringUtil.checkNull(commonService.selectString("item_SQL.getStrItemID", setData),"");
									setData.put("ParentIDCHK", ParentIDCHK);
									
									if (ToItemID.equals("")) {
										break;
									} 
									
									// L3 - L4 Connection Check
									if (!ParentIDCHK.equals("")) {
										setData.put("PFromItemID", FromItemID);
										setData.put("PToItemID", ToItemID);
										
										setData.put("Identifier", L4ID);
										setData.put("ClassCode", "CL16004");
										FromItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getMasterItemID", setData),"");
										
										setData.put("Identifier", L5ID);
										setData.put("ClassCode", "CL16005");
										ToItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getMasterItemID", setData),"");
										
										setData.put("FromItemID", FromItemID);
										setData.put("ToItemID", ToItemID);
										ParentIDCHK = StringUtil.checkNull(commonService.selectString("item_SQL.getStrItemID", setData),"");
										setData.put("ParentIDCHK", ParentIDCHK);
										
										if (ToItemID.equals("")) {
											break;
										} 
										
										// L4 - L5 Connection Check
										if (!ParentIDCHK.equals("")) {
											break;
											// L4 - L5 Connection X
										} else {
											setData.put("FromItemID", setData.get("PFromItemID")); // L4
											setData.put("ToItemID", setData.get("PToItemID")); //L5
											
											ParentIDCHK = StringUtil.checkNull(commonService.selectString("item_SQL.getStrItemID", setData),"");
											//setData.put("ParentIDCHK", ParentIDCHK);
											
											insertData = new HashMap();
											//insertData.put("strItemID", StringUtil.checkNull(commonService.selectString("report_SQL.getParentID", setData),""));
											insertData.put("strItemID", ParentIDCHK);
											insertData.put("s_itemID", FromItemID);
											insertData.put("toItemID", ToItemID);
											insertData.put("cxnClassCode", "STL1605");
											insertData.put("sessionUserId", StringUtil.checkNull(commandMap.get("sessionUserId")));
											insertData.put("sessionTeamId", StringUtil.checkNull(commandMap.get("sessionTeamId")));
											insertData.put("strLevel", "4");
											insertData.put("strType", "2"); 
											insertData.put("cxnItemType", "ST00016");
											// ADD 20240516 
											insertData.put("connectionType", "From");
											insertData.put("projectID", procjectID);
											insertData.put("categoryCode", "ST2");
											insertData.putIfAbsent("structureID", structureID);
											
											CxnItemService.save(insertData);
										}
										
										// L3 - L4 Connection X
									} else {
										setData.put("FromItemID", setData.get("PFromItemID")); //L3
										setData.put("ToItemID", setData.get("PToItemID")); // L4
										
										ParentIDCHK = StringUtil.checkNull(commonService.selectString("item_SQL.getStrItemID", setData),"");
										//setData.put("ParentIDCHK", ParentIDCHK);
										
										insertData = new HashMap();
										//insertData.put("strItemID", StringUtil.checkNull(commonService.selectString("report_SQL.getParentID", setData),""));
										insertData.put("strItemID", ParentIDCHK);
										insertData.put("s_itemID", FromItemID);
										insertData.put("toItemID", ToItemID);
										insertData.put("cxnClassCode", "STL1604");
										insertData.put("sessionUserId", StringUtil.checkNull(commandMap.get("sessionUserId")));
										insertData.put("sessionTeamId", StringUtil.checkNull(commandMap.get("sessionTeamId")));
										insertData.put("strLevel", "3");
										insertData.put("strType", "2"); 
										insertData.put("cxnItemType", "ST00016");
										// ADD 20240516 
										insertData.put("connectionType", "From");
										insertData.put("projectID", procjectID);
										insertData.put("categoryCode", "ST2");
										insertData.putIfAbsent("structureID", structureID);
										
										CxnItemService.save(insertData);
									}
								
									// L2 - L3 Connection X
								} else {
									setData.put("FromItemID", setData.get("PFromItemID")); // L2
									setData.put("ToItemID", setData.get("PToItemID")); // L3
									
									ParentIDCHK = StringUtil.checkNull(commonService.selectString("item_SQL.getStrItemID", setData),"");
									//setData.put("ParentIDCHK", ParentIDCHK);
									
									insertData = new HashMap();
									//insertData.put("strItemID", StringUtil.checkNull(commonService.selectString("report_SQL.getParentID", setData),""));
									insertData.put("strItemID", ParentIDCHK);
									insertData.put("s_itemID", FromItemID);
									insertData.put("toItemID", ToItemID);
									insertData.put("cxnClassCode", "STL1603");
									insertData.put("sessionUserId", StringUtil.checkNull(commandMap.get("sessionUserId")));
									insertData.put("sessionTeamId", StringUtil.checkNull(commandMap.get("sessionTeamId")));
									insertData.put("strLevel", "2");
									insertData.put("strType", "2"); 
									insertData.put("cxnItemType", "ST00016");
									// ADD 20240516 
									insertData.put("connectionType", "From");
									insertData.put("projectID", procjectID);
									insertData.put("categoryCode", "ST2");
									insertData.putIfAbsent("structureID", structureID);
									
									CxnItemService.save(insertData);
								}
								
								// L1 - L2 Connection X
							} else {
								setData.put("FromItemID", setData.get("PFromItemID")); //L1
								setData.put("ToItemID", setData.get("PToItemID")); //L2
								ParentIDCHK = StringUtil.checkNull(commonService.selectString("item_SQL.getStrItemID", setData),"");
								//setData.put("ParentIDCHK", ParentIDCHK);
								
								insertData = new HashMap();
								//insertData.put("strItemID", StringUtil.checkNull(commonService.selectString("report_SQL.getParentID", setData),""));
								insertData.put("strItemID", ParentIDCHK);
								insertData.put("s_itemID", FromItemID);
								insertData.put("toItemID", ToItemID);
								insertData.put("cxnClassCode", "STL1602");
								insertData.put("sessionUserId", StringUtil.checkNull(commandMap.get("sessionUserId")));
								insertData.put("sessionTeamId", StringUtil.checkNull(commandMap.get("sessionTeamId")));
								insertData.put("strLevel", "1");
								insertData.put("strType", "2"); 
								insertData.put("cxnItemType", "ST00016");
								// ADD 20240516 
								insertData.put("connectionType", "From");
								insertData.put("projectID", procjectID);
								insertData.put("categoryCode", "ST2");
								insertData.putIfAbsent("structureID", structureID);
								
								CxnItemService.save(insertData);
								
							}
							// L0 - L1 Connection X
						} else {
							setData.put("FromItemID", "16");
							setData.put("ToItemID", FromItemID);
							ParentIDCHK = StringUtil.checkNull(commonService.selectString("item_SQL.getStrItemID", setData),"");
							
							insertData = new HashMap();
							//insertData.put("strItemID", StringUtil.checkNull(commonService.selectString("report_SQL.getParentID", setData),""));
							insertData.put("strItemID", ParentIDCHK);
							insertData.put("s_itemID", FromItemID);
							insertData.put("toItemID", ToItemID);
							insertData.put("cxnClassCode", "STL1601");
							insertData.put("sessionUserId", StringUtil.checkNull(commandMap.get("sessionUserId")));
							insertData.put("sessionTeamId", StringUtil.checkNull(commandMap.get("sessionTeamId")));
							insertData.put("strLevel", "0");
							insertData.put("strType", "2"); 
							insertData.put("cxnItemType", "ST00016");
							// ADD 20240516 
							insertData.put("connectionType", "From");
							insertData.put("projectID", procjectID);
							insertData.put("categoryCode", "ST2");
							insertData.putIfAbsent("structureID", structureID);
							
							CxnItemService.save(insertData);
						}
					} 
				}
			} 	
			} 
		} catch(Exception e) {
			 System.out.println(e.toString());
		}
	 
		return returnCreateStrInfo;
	}
	
	// 3. 첨부문서명 docCode 로  STR Path 로 update str(parentID,fromItemID)
	public List zSkdc_updateStrPathByDocument(HashMap commandMap) throws Exception{
		List updateStrItemIDList = new ArrayList();
		try{
			
			Map setData = new HashMap();
			String mstItemID = StringUtil.checkNull(commandMap.get("mstItemID"), "");
			String strItemID = StringUtil.checkNull(commandMap.get("strItemID"), "");
			String structureID = "";
			
			setData.put("itemID", strItemID);
			setData.put("structureID", structureID);			
			List strDocList = commonService.selectList("custom_SQL.zSkdc_getDocumentList", setData);
			
			Map docStrMap = new HashMap();
			if(strDocList.size() > 0) {
									
				for (int i = 0; i < strDocList.size(); i++) {
					setData = new HashMap();
					
					docStrMap = (HashMap) strDocList.get(i);
					String docID = StringUtil.checkNull(docStrMap.get("docID"));
					String docStrItemID = StringUtil.checkNull(docStrMap.get("ItemID"));
					
					updateStrItemIDList.add(docStrItemID);
					structureID = StringUtil.checkNull(docStrMap.get("StructureID"));
					setData.put("itemID", docStrItemID);
					setData.put("categoryCode", "ST2");
					Map strIDPathInfo = commonService.select("item_SQL.getStrIDPathInfo", setData);
					
					String strIDPath = StringUtil.checkNull(strIDPathInfo.get("StrIDPath")); // parent strItemID
					String strIDPathToItemID = StringUtil.checkNull(strIDPathInfo.get("ToItemID")); // parent FromItemID 
					String level = StringUtil.checkNull(strIDPathInfo.get("Level")); // parent level
					
					System.out.println("strIDPAth:"+strIDPath);
					if(!strIDPath.equals("") && !strIDPath.equals("0")) {
						setData.put("ItemID", docStrItemID);
						setData.put("parentID", strIDPath);
						setData.put("fromItemID", strIDPathToItemID);	
						setData.put("level", Integer.parseInt(level)+1);
						setData.put("LastUser", StringUtil.checkNull(commandMap.get("sessionUserId")) );
						commonService.update("item_SQL.updateItem",setData); 
					}
				}
			}
			String updateCount = StringUtil.checkNull(strDocList.size());
			 	
		} catch(Exception e) {
			 System.out.println(e.toString());
		}
		return updateStrItemIDList;
	}
	
	@RequestMapping(value="/zSkdc_createStrWithDocument.do") // Structure 생성 단독실행
	public String  zSkdc_createStrWithDocument(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
			//  첨부문서 DocCode 기반으로 ST2 유무 확인후 없으면 생성 (잘못된 str path 메세지 작성)
			Map createStrPathByDocCode = zSkdc_createStrPathByDocCode(cmmMap);
					
			String errMsg = StringUtil.checkNull(createStrPathByDocCode.get("errMsg"));		
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "this.doSearchList();");
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}	

	@RequestMapping(value = "/zSkdc_updateStrPathIDDocument.do")
	public String zSkdc_updateStrPathIDDocument(HttpServletRequest request, HashMap cmmMap, ModelMap model)throws Exception {
		Map target = new HashMap();
		try {
			// 첨부문서 DocCode 기반으로 parentID, fromItemID update 
			List updateStrItemIDList = zSkdc_updateStrPathByDocument(cmmMap);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); 
			target.put(AJAX_SCRIPT, "this.doCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	private ModelMap setSkdLoginScrnInfo(ModelMap model,HashMap cmmMap) throws Exception {
		  
		  String pass = StringUtil.checkNull(cmmMap.get("pwd"));
		  model.addAttribute("loginid",StringUtil.checkNull(cmmMap.get("loginid"), ""));
		  model.addAttribute("pwd",pass);
		  model.addAttribute("lng",StringUtil.checkNull(cmmMap.get("lng"), ""));
		  
		  if(_log.isInfoEnabled()){_log.info("setLoginScrnInfo : loginid="+StringUtil.checkNull(cmmMap.get("loginid"))+",pass"+URLEncoder.encode(pass)+",lng="+StringUtil.checkNull(cmmMap.get("lng")));}		  
		  List langList = commonService.selectList("common_SQL.langType_commonSelect", cmmMap);
		  if( langList!=null &&langList.size() > 0){
			  for(int i=0; i<langList.size();i++){
				  Map langInfo = (HashMap) langList.get(i);
				  if(langInfo.get("IsDefault").equals("1")){
					  model.put("langType", StringUtil.checkNull(langInfo.get("CODE"),""));
					  model.put("langName", StringUtil.checkNull(langInfo.get("NAME"),""));
				  }
			  }
		  }else{model.put("langType", "");model.put("langName", "");}
		  model.put("langList", langList);
		  model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 구분
		  return model;
	 	}
	
	@RequestMapping(value="/custom/skd/loginskd.do")
	public String loginskd(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {
			HttpSession session = request.getSession(true);
			Map resultMap = new HashMap();
			String langCode = GlobalVal.DEFAULT_LANG_CODE;
			String languageID = StringUtil.checkNull(cmmMap.get("LANGUAGE"),StringUtil.checkNull(cmmMap.get("LANGUAGEID")) );
				if(languageID.equals("")){
					languageID = GlobalVal.DEFAULT_LANGUAGE;
				}
			
			cmmMap.put("LANGUAGE", languageID);
			String ref = request.getHeader("referer");
			//String protocol = request.isSecure() ? "https://" : "http://";
			
			String IS_CHECK2 = StringUtil.checkNull(cmmMap.get("IS_CHECK"),"");
			String IS_CHECK = GlobalVal.PWD_CHECK;
			
			String loginResult = "N"; //로그인 결과
		    
			if("".equals(IS_CHECK))
				IS_CHECK = "Y";
			
			if("N".equals(IS_CHECK2))
				IS_CHECK = "N";
			
			cmmMap.put("IS_CHECK", IS_CHECK);
			String url_CHECK = StringUtil.chkURL(ref, "https");
			String pwdCheck = StringUtil.checkNull(cmmMap.get("pwdCheck"),"");
			
			if("".equals(url_CHECK)) {
				resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
				resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));	
			}
			else {		
				Map idInfo = commonService.select("login_SQL.login_id_select", cmmMap);
				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
				if(idInfo == null || idInfo.size() == 0) {
					resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
					//resultMap.put(AJAX_ALERT, "해당아이디가 존재하지 않습니다.");
					resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));				
				}
				else {
					aesAction = new AESUtil();
					cmmMap.put("LOGIN_ID", idInfo.get("LoginId"));
					
					if("Y".equals(IS_CHECK) && "login".equals(url_CHECK)) {
						cmmMap.put("IS_CHECK", "Y");
					}
					else if (pwdCheck.equals("N")){
						cmmMap.put("IS_CHECK", "N");
					}
					
					String pwd = (String) cmmMap.get("PASSWORD");
					
					if("Y".equals(GlobalVal.PWD_ENCODING)) {
						aesAction.setIV(request.getParameter("iv"));
						aesAction.setSALT(request.getParameter("salt"));
						
						pwd =  aesAction.decrypt(pwd);
											
						aesAction.init();
						
						pwd = aesAction.encrypt(pwd);
					}
	
					cmmMap.put("PASSWORD", pwd); 
					
					Map loginInfo = commonService.select("login_SQL.login_select", cmmMap);
					if(loginInfo == null || loginInfo.size() == 0) {
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
						//resultMap.put(AJAX_ALERT, "System에 해당 사용자 정보가 없습니다.등록 요청바랍니다.");
						resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00102"));					
					}
					else {
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('Y')");
						loginResult = "Y";
						
						// 권한 체크 및 변경 - LOGIN 시 UGAC에서 권한 체크 및 return data 가지고 MLVL 대조하여 다른 경우 수정
						String loginID = StringUtil.checkNull(loginInfo.get("sessionUserId"));
						String UGACReturn = exeUGACinterface(loginID, "412", "SFOLM-VIEWER", cmmMap);
						
						if(UGACReturn!= null && !"".equals(UGACReturn)){
							if("21".equals(UGACReturn)){
								//사용자 계정에 할당된 권한그룹이 없을 경우 (신규회원)
								UGACReturn = exeUGACinterface(loginID, "426", "SFOLM-VIEWER",cmmMap);
								Map setMap = new HashMap();
								setMap.put("MLVL","VIEWER");
								setMap.put("Authority","4");
								setMap.put("MemberID", loginInfo.get("sessionUserId"));
								commonService.update("user_SQL.updateUser", setMap);
								loginInfo = commonService.select("login_SQL.login_select", cmmMap);
							} else {
								String authority = "";
								
								if("SFOLM-SYS".equals(UGACReturn)) authority = "1";
								else if("SFOLM-TM".equals(UGACReturn)) authority = "2";
								else if("SFOLM-EDITOR".equals(UGACReturn)) authority = "3";
								else if("SFOLM-VIEWER".equals(UGACReturn)) authority = "4";
								
								if(!"".equals(authority)){
									Map setMap = new HashMap();
									UGACReturn = UGACReturn.replace("SFOLM-", "");
									setMap.put("MLVL",UGACReturn);
									setMap.put("Authority",authority);
									setMap.put("MemberID", loginInfo.get("sessionUserId"));
									commonService.update("user_SQL.updateUser", setMap);
									loginInfo = commonService.select("login_SQL.login_select", cmmMap);
								}
							}
						}
						
						// [Authority] < 4 인 경우, 수정가능하게 변경
						if(loginInfo.get("sessionAuthLev").toString().compareTo("4") < 0) loginInfo.put("loginType", "editor");
						else loginInfo.put("loginType", "viewer");	
						
						session.setAttribute("loginInfo", loginInfo);
					}
				}
				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
				model.addAttribute(AJAX_RESULTMAP,resultMap);
				
				// logging
				String loginId = StringUtil.checkNull(cmmMap.get("LOGIN_ID")); //로그인 시도 ID
				String type = "login";
				HashMap loggingMap = new HashMap();
				loggingMap.put("actor",loginId);
				loggingMap.put("result",loginResult);
				Map loggingdData = makeLoggingData(type, loggingMap, null, request);
				String loggingResult = loggingSKD(loggingdData);
				
				
			}
		}
		catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("LoginActionController::loginbase::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}	
	
	@RequestMapping(value="/custom/skd/loginskdForm.do")
	public String loginskdcForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
	  model=setSkdLoginScrnInfo(model,cmmMap);
	  model.put("screenType", cmmMap.get("screenType"));
	  model.put("mainType", cmmMap.get("mainType"));
	  model.put("srID", cmmMap.get("srID"));
	  model.put("status", cmmMap.get("status"));
	  model.put("pwdCheck", cmmMap.get("pwdCheck"));
	  model.put("defArcCode", cmmMap.get("defArcCode"));
	  model.put("defTemplateCode", cmmMap.get("defTemplateCode"));
	  
	  return nextUrl("/custom/skd/login");
	}
	
	@RequestMapping(value="/custom/skd/loggingSKDBatch.do")
	public void loggindSKDBatch(HttpServletRequest request) throws Exception{
		
		// visit log 에서 login 꺼내기
		String type = "batch";
		List loggingList = new ArrayList();
		Map setMap = new HashMap();
		
		Calendar calendar = new GregorianCalendar();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		String date = formatter.format(calendar.getTime());		
		calendar.add(Calendar.DATE, -1);		
		date = formatter.format(calendar.getTime());		
		
		setMap.put("actionType","LOGIN");
		setMap.put("scStartDt",date);
		setMap.put("scEndDt",date);
		
		loggingList = commonService.selectList("report_SQL.getVisitLogList", setMap);
		
		Map loggingdData = makeLoggingData(type, null, loggingList, request);
		String loggingResult = loggingSKD(loggingdData);
	}
	
	public static String loggingSKD(Map<String, Object> data) {

		String response = "";
		String apiUrl = "";
		
		try {
			apiUrl = StringUtil.checkNull(data.get("apiUrl"));
			//URL url = new URL("https://webhook.site/82521155-1aad-44fc-bcea-4173d596b3c8");
			URL url = new URL(apiUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST"); // 전송 방식
			conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
			conn.setConnectTimeout(5000); // 연결 타임아웃 설정(5초) 
			conn.setReadTimeout(5000); // 읽기 타임아웃 설정(5초)
			conn.setDoOutput(true);	// URL 연결을 출력용으로 사용(true)
			
			String requestBody = StringUtil.checkNull(data.get("data"));
			Charset charset = Charset.forName("UTF-8");
			
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream(), charset));
			bw.write(requestBody);
			bw.flush();
			bw.close();

			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), charset));
			
			String inputLine;			
			StringBuffer sb = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				sb.append(inputLine);
			}
			br.close();
			
			response = sb.toString();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return response;
	}
	
	public Map makeLoggingData(String type, HashMap loggingMap, List loggingList, HttpServletRequest request) throws Exception {
		
		// logging start
		// type : login (실시간 로그인 logging 처리) / batch (배치)
		
	    JSONObject sendData = new JSONObject();
	    JSONArray sendList = new JSONArray();
	    
	    Map rs = new HashMap();
	    
	    String site = "SFOLM"; //AppKey : SFOLM
	    String reqUrl = "https://dpm.skchemicals.com/custom/indexSKD.do"; //요청주소 - login
	    String uri = "https://dpm.skchemicals.com"; //요청주소 - batch
	    String ip = request.getHeader("X-FORWARDED-FOR");
        if (ip == null) ip = request.getRemoteAddr();
	    
        String apiUrl = "";
        if("login".equals(type)){
        	// login
        	sendData.put("site", site);
        	sendData.put("uri", reqUrl);
        	sendData.put("actor", StringUtil.checkNull(loggingMap.get("actor")));
        	sendData.put("result", StringUtil.checkNull(loggingMap.get("result")));
        	sendData.put("ip", ip);
        	apiUrl = "https://itapi.skchemicals.com/ac/api/v1/Log/Write";
        	
        	rs.put("apiUrl",apiUrl);
        	rs.put("data",sendData.toString());
        
        }else if("authority".equals(type)){ // 권한 변경
             	sendData.put("site", site);
             	sendData.put("uri", "https://dpm.skchemicals.com/UserList.do");
             	sendData.put("obj", "사용자 권한 변경");
             	sendData.put("actor", StringUtil.checkNull(loggingMap.get("actor")));
             	sendData.put("ip", ip);
             	sendData.put("bfRole", StringUtil.checkNull(loggingMap.get("bfRole")));
             	sendData.put("afRole", StringUtil.checkNull(loggingMap.get("afRole")));
             	apiUrl = "https://itapi.skchemicals.com/ro/api/v1/Log/Write";
             	String memberJsonStr = "";
    			JSONArray memberJsonArr = new JSONArray();
    			if( !StringUtil.checkNull(loggingMap.get("employeeNums"),"").equals("")) {
    				for (String employeeNum : StringUtil.checkNull(loggingMap.get("employeeNums"),"").split(",")) {
    					memberJsonArr.put(employeeNum);
    				}
    				memberJsonStr = memberJsonArr.toString();
    				
    			}
             	sendData.put("custIdx", memberJsonArr);
             	rs.put("apiUrl",apiUrl);
             	rs.put("data",sendData.toString());
             	
        } else {
        	// batch
        	if(loggingList != null && loggingList.size() > 0) {
        		apiUrl = "https://itapi.skchemicals.com/ac/api/v2/Write";
        		SimpleDateFormat formatter = new SimpleDateFormat("yyyyy-mm-dd hh:mm:ss");
        		SimpleDateFormat  formatter1 = new SimpleDateFormat("yyyyMMddHHmmss");    
        		
        		for(int i=0; i < loggingList.size(); i++){
        			Map logging = (Map) loggingList.get(i);
        			JSONObject tempData = new JSONObject();
        			tempData.put("site", site);
        			tempData.put("uri", uri);
        			tempData.put("actor", StringUtil.checkNull(logging.get("LoginID")));
        			tempData.put("result", StringUtil.checkNull("Y"));
        			tempData.put("ip", StringUtil.checkNull(logging.get("IpAddress")));
        			
        			String accessDate = StringUtil.checkNull(logging.get("Time"));
        			Date date = formatter.parse(accessDate); 
        			accessDate = formatter1.format(date);
        			
        			tempData.put("accessDate", accessDate);
        			sendList.put(tempData);
        		}
        		
        		rs.put("apiUrl",apiUrl);
            	rs.put("data",sendList.toString());
        	}
        }
	    
        return rs;
	    // logging end
	}
	
	@RequestMapping(value="/custom/indexSKD.do")
	public String indexSKD(Map cmmMap,ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try{
				Map setData = new HashMap();
				Map userInfo = new HashMap();
				
				String auth = StringUtil.checkNull(request.getAttribute("isAuthenticated"));
				String userId = ""; //email
				
				if("false".equals(auth) || auth == null  || ("").equals(auth)){
					return "redirect:/auth/sign_in";
				} else {
					IAccount account = (IAccount) request.getAttribute("account");
					userId = StringUtil.checkNull(account.username());
				}
				
				String langCode = StringUtil.checkNull(request.getParameter("language"),"");
				setData.put("extCode", langCode);
				langCode = commonService.selectString("common_SQL.getLanguageID", setData);
				
				// 이메일 제거
				int atIndex = userId.indexOf('@');
				if(userId != null && !userId.isEmpty()) {
					if (atIndex != -1) {
			            String employeeNum = userId.substring(0,atIndex);
						setData.put("employeeNum", employeeNum);
						userInfo = commonService.select("common_SQL.getLoginIDFromMember", setData);
			        }
				}
				
				if(userInfo != null && !userInfo.isEmpty()) {
					model.put("olmI", StringUtil.checkNull(userInfo.get("LoginId")));
				} else {
					// logging
					String loginId = StringUtil.checkNull(userId); //로그인 시도 ID
					String loginResult = "N";
					String type = "login";
					
					HashMap loggingMap = new HashMap();
					loggingMap.put("actor",loginId);
					loggingMap.put("result",loginResult);
					Map loggingdData = makeLoggingData(type, loggingMap, null, request);
					String loggingResult = loggingSKD(loggingdData);
				}
				
				model.put("olmLng",langCode);
				model.put("IS_CHECK", "N");	
				model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
				model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
				model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
				model.put("pwdCheck", StringUtil.checkNull(cmmMap.get("pwdCheck"),""));
				model.put("defArcCode", StringUtil.checkNull(cmmMap.get("defArcCode"),""));
				model.put("defTemplateCode", StringUtil.checkNull(cmmMap.get("defTemplateCode"),""));
				
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SKDCActionController::SKDC Login ::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("indexSKD");
	}
	
	@RequestMapping(value="/zSkdc_strItemfileDownload.do")
	public String zSkdc_strItemfileDownload( HttpServletRequest request, HttpServletResponse response, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		Map target = new HashMap();
		Map setData = new HashMap();
		String useFileLog = StringUtil.checkNull(GlobalVal.USE_FILE_LOG);
		try {
			 // 압축 파일을 스트리밍하여 클라이언트에게 전송
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            List <String> deletedFolderFileList = new ArrayList();
            try (ZipOutputStream zipOutputStream = new ZipOutputStream(byteArrayOutputStream)) {
                String mstItemID = StringUtil.checkNull(cmmMap.get("s_itemID"));
                
               
                setData.put("languageID", cmmMap.get("sessionCurrLangType"));
    			setData.put("strItemID", cmmMap.get("strItemID"));
    			
    			setData.put("udfSTR", StringUtil.checkNull(cmmMap.get("udfSTR"), ""));
    			if(StringUtil.checkNull(cmmMap.get("udfSTR")).equals("Y")) {
    				setData.put("categoryCode", "ST3");
    			}else {
    				setData.put("categoryCode", "ST2");
    			}
    			
			    if(mstItemID.equals("")) {
			    	setData.put("itemID", cmmMap.get("strItemID"));
			    	mstItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getToItemID", setData));
                }
    			setData.put("s_itemID", mstItemID);
    			List strItemFileList = commonService.selectList("custom_SQL.zSkdc_getSubItemFileList_gridList", setData);
                
    			if(strItemFileList.size() > 0) {
                for (int i=0; i<strItemFileList.size(); i++) {
                	HashMap strItemFileInfo = (HashMap)strItemFileList.get(i);
					
					String L0ItemName = StringUtil.checkNull(strItemFileInfo.get("L0ItemName"));
					String L1ItemName = StringUtil.checkNull(strItemFileInfo.get("L1ItemName"));
					String L2ItemName = StringUtil.checkNull(strItemFileInfo.get("L2ItemName"));
					String L3ItemName = StringUtil.checkNull(strItemFileInfo.get("L3ItemName"));
					String L4ItemName = StringUtil.checkNull(strItemFileInfo.get("L4ItemName"));
					String L5ItemName = StringUtil.checkNull(strItemFileInfo.get("L5ItemName"));
					String serverFilePath = StringUtil.checkNull(strItemFileInfo.get("FilePath"));
					String fileRealName = StringUtil.checkNull(strItemFileInfo.get("FileRealName"));
					String fileName = StringUtil.checkNull(strItemFileInfo.get("FileName"));
					String folderPath = "";
					
					 if(useFileLog.equals("Y")) {
     					String ip = request.getHeader("X-FORWARDED-FOR");
     			        if (ip == null) ip = request.getRemoteAddr();
     			        cmmMap.put("IpAddress",ip);
     			        cmmMap.put("fileID", StringUtil.checkNull(strItemFileInfo.get("Seq"))); 
     			       
     			        commonService.insert("fileMgt_SQL.insertFileLog",cmmMap);
     				}
					 
					if(!L0ItemName.equals("")) {
						folderPath = L0ItemName; 
						
					} if(!L1ItemName.equals("")) {
						if(!folderPath.equals("")) {
							folderPath = folderPath + "/" + L1ItemName; 
						} else {
							folderPath = L1ItemName; 
						}
						
					} if(!L2ItemName.equals("")) {
						folderPath = folderPath + "/" + L2ItemName; 
						
					} if(!L3ItemName.equals("")) {
						folderPath = folderPath + "/" + L3ItemName; 
						
					} if(!L4ItemName.equals("")) {
						folderPath = folderPath +  "/" + L4ItemName; 
						
					} if(!L5ItemName.equals("")) {
						folderPath = folderPath + "/" + L5ItemName; 
					} 
					
                    Path sourceDirectory = Paths.get(serverFilePath); // ex) C://OLMFILE//document/BEDP
                    Path targetDirectory = Paths.get(folderPath); // ex) path/to/folder1
                    String folder = folderPath;
                    Files.walk(sourceDirectory)
                            .filter(Files::isRegularFile)
                            .filter(p -> p.getFileName().toString().equalsIgnoreCase(fileName))
                            .forEach(file -> {
                                try {
                                	// file -> ex) C:\OLMFILE\document\FLT016\20231221130453453.xlsx
                                	// 상대 경로 생성
                                    Path relativePath = sourceDirectory.relativize(file); // text1.txt
                                    
                                    Path targetPath = targetDirectory.resolve(relativePath);// path\to\folder1\text1.txt 
                                    // targetPath.getParent() : path\to\folder1 , 
                                    //System.out.println("targetPath :"+targetPath.getParent()+", targetPath:"+targetPath);
                                    
                                    // 폴더가 존재하지 않으면 생성
                                    if (!Files.exists(targetPath.getParent())) {
                                        Files.createDirectories(targetPath.getParent());
                                    }
                                    
                                    // 파일명 변경하여 복사
                                    Path newFileName = targetPath.getParent().resolve(fileRealName);
                                    // AIP 로직 추가
                                    // DRM 복호와 정보 
                        			
                        			HashMap drmInfoMap = new HashMap();		
                        			drmInfoMap.put("loginID", cmmMap.get("sessionLoginId"));
                        			drmInfoMap.put("sessionEmail", cmmMap.get("sessionEmail"));
                        			
                        			String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
                    				String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
                    				String retrunValue = "";
                    				if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
                    					drmInfoMap.put("downFile", serverFilePath+fileName);
                    					drmInfoMap.put("ORGFileDir", serverFilePath); // C://OLMFILE//document//
                    					drmInfoMap.put("DRMFileDir", StringUtil.checkNull(DrmGlobalVal.DRM_DECODING_FILEPATH) + StringUtil.checkNull(cmmMap.get("sessionUserId"))+"//");
                    					drmInfoMap.put("Filename", fileName);
                    					drmInfoMap.put("funcType", "download");
                    					retrunValue = DRMUtil.drmMgt(drmInfoMap); // 암호화 
                    				}
                    				
                    				if(!"".equals(retrunValue)) {
                    					file = Paths.get(retrunValue);
                    				}
                                    
                                    Files.copy(file, newFileName, StandardCopyOption.REPLACE_EXISTING);
                                    
                                    // 압축 파일에 파일 추가
                                   // String entryName = folder.toString() + "/" + relativePath.toString();
                                    String entryName = folder + "/" + newFileName.getParent().relativize(newFileName).toString();
                                    zipOutputStream.putNextEntry(new ZipEntry(entryName));
                                    // Files.copy(file, zipOutputStream);
                                    Files.copy(newFileName, zipOutputStream);
                                    zipOutputStream.closeEntry();

									// System.out.println("Added to ZIP: " + folder + "/" + relativePath.toString());
                                    deletedFolderFileList.add(entryName);
                                    
                                    // 암호환된 임시저장 파일 삭제 
                                    System.out.println("암호화된 임시 파일 삭제 :"+retrunValue);
                                    File existFile = new File(retrunValue);
                        			if(existFile.isFile() && existFile.exists()){existFile.delete();}
									
                                } catch (IOException e) {
                                    e.printStackTrace();
                                } catch (ExceptionUtil e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
                            });
                	}
    			} // if(strItemFileList.size() > 0) {
    			byteArrayOutputStream.close();
            }

            Calendar cal = Calendar.getInstance();
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
			java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("HHmmssSSS");
			String mkFileNm = sdf.format(cal.getTime()) + sdf2.format(cal.getTime());
			 
			String newFileNm = "FILE_"+mkFileNm+".zip";
			 
			 // 압축 파일 이름
			response.setContentType("application/zip");
		    response.setHeader("Content-Disposition", "attachment; filename=\"" + newFileNm + "\"");
		  
            // 압축 파일을 클라이언트에 전송
            try (OutputStream out = response.getOutputStream()) {
                out.write(byteArrayOutputStream.toByteArray());
                out.flush();
            }
                      
            deleteFolderAndFiles(deletedFolderFileList);
			
		}catch (Exception e) {
			 System.out.println(e);
			 throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl(AJAXPAGE);
	}
	
	private void deleteFolderAndFiles(List<String> folderPaths) throws IOException {
	    for (String folderPath : folderPaths) {
	    	Path path = Paths.get(folderPath);
            if (Files.exists(path)) {
                try {
                    Files.walk(path)
                         .sorted(Comparator.reverseOrder())
                         .map(Path::toFile)
                         .forEach(file -> {
                             try {
                                 Files.deleteIfExists(file.toPath());
                             } catch (IOException e) {
                                 System.err.println("Failed to delete file: " + file);
                             }
                         });
                    Files.deleteIfExists(path);
                } catch (IOException e) {
                    System.err.println("Failed to delete folder: " + path);
                }
            } else {
                System.out.println("Folder does not exist: " + path);
            }
	    }
	}
	
	@RequestMapping(value="/zSkdc_elmInfoTabMenu.do")
	public String zSkdc_elmInfoTabMenu(HttpServletRequest request ,ModelMap model) throws Exception{
		String url = "/custom/skd/skdc/item/zSkdc_elmInfoTabMenu";
	
		String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");	
		String modelID = StringUtil.checkNull(request.getParameter("modelID"), "");	
		
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
		model.put("s_itemID", s_itemID);
		model.put("modelID", modelID);
		
		model.put("screenType", StringUtil.checkNull( request.getParameter("screenType"),"") );
		model.put("attrRevYN", StringUtil.checkNull(request.getParameter("attrRevYN"),""));	
		model.put("changeSetID", StringUtil.checkNull(request.getParameter("changeSetID"),""));	
		
		return nextUrl(url);
	}
	
	@RequestMapping(value="/custom/skd/skdc/exeHRinterface.do")
	public void exeHRinterface(Map cmmMap,ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		try{
			
			List organizationList = makeHRData("DEPT");
			// z_dept truncate
	        zSkdc_truncateOrganization();
	        // z_dept insert
	        zSkdc_insertOrganization(organizationList);
			
	        
	        List employeeList = makeHRData("EMP");
	        // z_emp truncate
	        zSkdc_truncateEmployee();
	        // z_emp insert
	        zSkdc_insertEmployee(employeeList);
	        
	        // HR_IF 실행 
	        zSkdc_exeHRProcedure();

			System.out.println("end exeHRinterface");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SecondActionController::getEmployeeList::Error::"+e);}
			System.out.println("exeHRinterface :: Error :: " + e);
			//throw e;
		}	
		
	}
	
	public static List makeHRData(String type) throws Exception {
		
		JSONArray responseJsonList;
		List resultList = new ArrayList();
		Map<String, String> rsMap = null;
		
		//setting
	    
		// OA
		String LEGACY_KEY = "B80B254A-E73D-40F5-91CA-FBF1BF289AA1"; 
		String apiUrl = "https://apigw.skchemicals.com/EHRGW/api/"; 
		String USERID = "DPM_STG"; 
		
		// DEV
		/*
		String apiUrl = "https://dev-apigw.skchemicaslc.om/EHRGW/api/"; 
		String LEGACY_KEY = "4EA2100A-E6FA-4F2E-B925-B45E543AB4E7";
	    String USERID = "DPMS_DEV"; 
	    */
	    String ReturnDataType = "JSON";
		
	    if("EMP".equals(type)) {
			apiUrl = apiUrl + "commonEmployee";
		} else {
			apiUrl = apiUrl + "commonDepartment";
		}
		
	    JSONObject sendData = new JSONObject();
    	sendData.put("USERID", USERID);
    	sendData.put("ReturnDataType", ReturnDataType);
    	
		try {
			
			//apiUrl = "https://webhook.site/a61b5943-7cb3-4696-9df3-e7138d80bb02"; // local test
			URL url = new URL(apiUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST"); // 전송 방식
			conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
			conn.setRequestProperty("LEGACY_KEY", LEGACY_KEY);
			conn.setConnectTimeout(5000); // 연결 타임아웃 설정(5초) 
			conn.setReadTimeout(5000); // 읽기 타임아웃 설정(5초)
			conn.setDoOutput(true);	// URL 연결을 출력용으로 사용(true)
			
			String requestBody = StringUtil.checkNull(sendData.toString());
			
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
			bw.write(requestBody);
			bw.flush();
			bw.close();

			Charset charset = Charset.forName("UTF-8");
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), charset));
			
			String inputLine;			
			StringBuffer sb = new StringBuffer();
			
			while ((inputLine = br.readLine()) != null) {
				sb.append(inputLine);
			}
			br.close();
			
			String rs = StringUtil.checkNull(sb.toString());
			responseJsonList = new JSONArray(rs);
			
			//JSONArray[JSONObject] --> List[Map]
			for(int i=0; i<responseJsonList.length(); i++) {
				JSONObject jsonObject = responseJsonList.getJSONObject(i);
				rsMap = new ObjectMapper().readValue(jsonObject.toString(), Map.class);
                resultList.add(rsMap);
			}
			

		} catch (Exception e) {
			//e.printStackTrace();
			System.out.println("exeHRinterface :: Error :: " + e);
		}

		return resultList ;
	}
	
	@RequestMapping(value="/custom/skd/skdc/exeUGACinterface.do")
	public String exeUGACinterface(String userID, String type, String GroupName, Map cmmMap) throws Exception {
		
		String result = "null";
		Map setMap = new HashMap();
		
		try{
			setMap.put("userID", userID);
			String empNo = StringUtil.checkNull(commonService.selectString("user_SQL.getEmployeeNum", setMap));
			setMap.remove("userID");
			
			//String EndDate = StringUtil.checkNull(request.getParameter("EndDate"));
			// 그룹 멤버 추가 ( 신규 )
			JSONArray Members = new JSONArray();
			if("426".equals(type)){
				List rsList = new ArrayList();
				Map resMap = new HashMap();
				resMap.put("EmpNo",empNo);
				rsList.add(resMap);
				Members = new JSONArray(rsList);
			}
			
			Map inputMap = new HashMap();
			
			inputMap.put("GroupName", GroupName); //String
			inputMap.put("Members", Members); // [{"EmpNo":""...}] JsonArray / EmpNo
			//inputMap.put("EndDate", EndDate); // 권한종료일 미지정 시 30일 뒤 해제 / ex : 2022-05-04
			
			JSONObject responseJson = null;
			responseJson = makeUGACData(type,empNo,inputMap);
			
			String errorCode = "";
			if(responseJson.has("ErrorCode")){
				errorCode = StringUtil.checkNull(responseJson.get("ErrorCode"));
			}
			
			if(!"0".equals(errorCode)){
				result = errorCode;
			}
			// type412 제외 성공여부만 필요
			else if("412".equals(type)){
				if(responseJson.has("ResultData")){
					JSONArray responseList = responseJson.getJSONArray("ResultData");
					
					/**
					 
					  {"RequestUri":"http://ugac.skchemicals.com/api/v1/User/GetRoleGroups","ResultData":[{"GroupName":"SFOLM-EDITOR","DisplayName":"편집자","Description":"편집자 그룹"},{"GroupName":"SFOLM-TM","DisplayName":"변경관리자","Description":"변경관리자 그룹"},{"GroupName":"SFOLM-SYS","DisplayName":"시스템관리자","Description":"시스템관리자 그룹"}],"ContentLength":27,"ContentType":"application/json","ErrorCode":0,"ErrorMessage":null}
					 
					 */
					
					
					if(responseList.length() > 0){
						
						List groupList = new ArrayList();
						for (int i = 0; i < responseList.length(); i++) {
				            JSONObject group = responseList.getJSONObject(i);
				            String groupName = StringUtil.checkNull(group.get("GroupName"));
				            if(!"".equals(groupName)) groupList.add(groupName);
				        }
						
						if (groupList.contains("SFOLM-SYS")) {
						    result = "SFOLM-SYS";
						} else if (groupList.contains("SFOLM-TM")) {
						    result = "SFOLM-TM";
						} else if (groupList.contains("SFOLM-EDITOR")) {
						    result = "SFOLM-EDITOR";
						} else {
							result = "SFOLM-VIEWER";
						}
			            
						//JSONObject res = responseList.getJSONObject(0);
						//if(res.has("GroupName"))result = StringUtil.checkNull(res.get("GroupName"));
					} 
				}
			} else {
				if(responseJson.has("ResultData")){
					JSONObject res = responseJson.getJSONObject("ResultData");
					result = res.toString();
				}
			}
			
			//System.out.println("TEST 결과2");
			//System.out.println(result);

			System.out.println("end exeUGACinterface");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SecondActionController::getEmployeeList::Error::"+e);}
			System.out.println("exeUGACinterface :: Error :: " + e);
			//throw e;
		}
		
		return result;
		
	}
	
	public static JSONObject makeUGACData(String type, String empNo, Map inputMap) throws Exception {

		JSONObject responseJson = null;
		
		try {
			
			// parameter
			String GroupName = StringUtil.checkNull(inputMap.get("GroupName"));
			//String EndDate = StringUtil.checkNull(inputMap.get("EndDate"));
			
		    JSONObject sendData = new JSONObject();
	    	
	    	//setting
			String appUrl = "";
			// 사용자 정보
			if("411".equals(type)){
				appUrl = "api/v1/User/Info";
				sendData.put("EmpNo", empNo);
			}
		    // 사용자 계정의 권한 목록
			else if("412".equals(type)){
				appUrl = "api/v1/User/GetRoleGroups";
				sendData.put("EmpNo", empNo);
			}
			// 그룹 멤버 추가
			else if("426".equals(type)){
				JSONArray Members = (JSONArray) inputMap.get("Members");
				appUrl = "api/v1/Group/AddMembers";
				sendData.put("GroupName", GroupName);
				sendData.put("Members", Members); 
				//sendData.put("EndDate", EndDate);
			}
			
			// OA
			String apiUrl = "https://ugac.skchemicals.com/" + appUrl;
			String Authorization = "Bearer e6d1b29c-490f-42ca-bdb1-b7cca93bd6a7"; // 토큰
			String AppKey = "SFOLM"; 
			String Actor = empNo;
			
			//apiUrl = "https://webhook.site/a61b5943-7cb3-4696-9df3-e7138d80bb02"; // local test
			URL url = new URL(apiUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST"); // 전송 방식
			conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
			conn.setRequestProperty("Authorization", Authorization);
			conn.setRequestProperty("AppKey", AppKey);
			conn.setRequestProperty("Actor", Actor);
			conn.setConnectTimeout(5000); // 연결 타임아웃 설정(5초) 
			conn.setReadTimeout(5000); // 읽기 타임아웃 설정(5초)
			conn.setDoOutput(true);	// URL 연결을 출력용으로 사용(true)
			
			String requestBody = StringUtil.checkNull(sendData.toString());
			
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
			bw.write(requestBody);
			bw.flush();
			bw.close();

			Charset charset = Charset.forName("UTF-8");
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), charset));
			
			String inputLine;			
			StringBuffer sb = new StringBuffer();
			
			while ((inputLine = br.readLine()) != null) {
				sb.append(inputLine);
			}
			br.close();
			
			String rs = StringUtil.checkNull(sb.toString());
			
			//System.out.println("TEST 결과");
			//System.out.println(rs);
			
			responseJson = new JSONObject(rs);

		} catch (Exception e) {
			//e.printStackTrace();
			System.out.println("exeUGACinterface :: Error :: " + e);
		}

		return responseJson ;
	}
	
	public void zSkdc_truncateEmployee() {
		HashMap setMap = new HashMap();
		
		try{ 			
			commonService.delete("custom_SQL.zSkdc_truncateEmployee", setMap);
			System.out.println("custom_SQL.zSkdc_truncateEmployee");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SecondActionController::truncateOrganization::Error::"+e);}
			//throw e;
		}	
		
	}
	
	public void zSkdc_insertEmployee(List mapList) {
		HashMap setMap = new HashMap();
		try{ 			
			for(int i=0; i<mapList.size(); i++) {
				setMap = (HashMap) mapList.get(i);
				commonService.insert("custom_SQL.zSkdc_insertEmployee", setMap);
			}
			System.out.println("custom_SQL.zSkdc_insertEmployee");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SecondActionController::insertEmployeeList::Error::"+e);}
			//throw e;
		}	
	}
	
	public void zSkdc_truncateOrganization() {
		HashMap setMap = new HashMap();
		
		try{ 			
			commonService.delete("custom_SQL.zSkdc_truncateOrganization", setMap);
			System.out.println("custom_SQL.zSkdc_truncateEmployee");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SecondActionController::truncateOrganization::Error::"+e);}
			//throw e;
		}	
		
	}
	
	public void zSkdc_insertOrganization(List mapList) {
		HashMap setMap = new HashMap();
		try{ 			
			for(int i=0; i<mapList.size(); i++) {
				setMap = (HashMap) mapList.get(i);
				commonService.insert("custom_SQL.zSkdc_insertOrganization", setMap);
			}
			System.out.println("custom_SQL.zSkdc_insertEmployee");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SecondActionController::insertEmployeeList::Error::"+e);}
			//throw e;
		}	
	}
	
	public void zSkdc_exeHRProcedure() {
		HashMap setMap = new HashMap();
		//HR_IF_SKDC
		String procedureName = StringUtil.checkNull(GlobalVal.HR_IF_PROC);
		setMap.put("procedureName", "XBOLTADM."+procedureName);
		try{ 			
			commonService.insert("organization_SQL.insertHRTeamInfo", setMap);
			System.out.println("zhwas_exeHRProcedure");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("HanwhaActionController::zhwas_exeHRProcedure::Error::"+e);}
			//throw e;
		}	
	}
	
	@RequestMapping(value="/zSkdc_editUserAuthority.do")
	public String zSkdc_editUserAuthority(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		Map setMap = new HashMap();
		try{
			String memberIDs[] = StringUtil.checkNull(request.getParameter("memberIDs"),"").split(",");
			String authority = StringUtil.checkNull(request.getParameter("authority"),"");
			String memberID = "";
			
			if(authority.equals("SYS")){
				setMap.put("Authority", "1");
			}else if(authority.equals("TM")){
				setMap.put("Authority", "2");
			}else if(authority.equals("EDITOR")){
				setMap.put("Authority", "3");
			}else{
				setMap.put("Authority", "4");
			}
			
			// 권한 수정 시 Active = 1
			setMap.put("Active", "1");
			
			for(int i=0; memberIDs.length > i; i++){
				memberID = StringUtil.checkNull(memberIDs[i],"");
				setMap.put("MemberID", memberID);
				setMap.put("MLVL",authority);
				commonService.update("user_SQL.updateUser", setMap);
				
				setMap.put("sessionUserId", memberID);
				String teamID = commonService.selectString("user_SQL.userTeamID", setMap);
				setMap.put("sessionTeamId", teamID);
				
				// Visit Log
				setMap.put("sessionClientId",commandMap.get("sessionClientId"));
				setMap.put("ActionType","MBRAU");
				 String ip = request.getHeader("X-FORWARDED-FOR");
		        if (ip == null)
		            ip = request.getRemoteAddr();
		        setMap.put("IpAddress",ip);
		        setMap.put("comment",authority);
				commonService.insert("gloval_SQL.insertVisitLog", setMap);
			}
			
			HashMap loggingMap = new HashMap();
			setMap.put("typeCode", authority);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("category", "MLVL");
			
			loggingMap.put("actor", commandMap.get("sessionLoginId"));
			loggingMap.put("employeeNums", StringUtil.checkNull(request.getParameter("employeeNums"),""));
			loggingMap.put("bfRole", "일반 사용자");
			loggingMap.put("afRole", commonService.selectString("common_SQL.getNameFromDic", setMap));
			
			Map loggingdData = makeLoggingData("authority", loggingMap, null, request);
			System.out.println("loggingdData :" + loggingdData);
			
			String loggingResult = loggingSKD(loggingdData);
			System.out.println("loggingResult :"+loggingResult);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBack();");
			
		}catch(Exception e){
			System.out.println(e.toString());
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
}
