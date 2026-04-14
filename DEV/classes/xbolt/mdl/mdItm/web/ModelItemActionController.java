package xbolt.mdl.mdItm.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import com.org.json.JSONArray;
import com.org.json.JSONException;
import com.org.json.JSONObject;

import org.apache.commons.text.StringEscapeUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DimTreeAdd;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;



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
public class ModelItemActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "mdItemService")
	private CommonService mdItemService;
	
	@RequestMapping(value="/getModelListGrid.do")
	public String getModelListGrid(HttpServletRequest request,  HashMap commandMap, ModelMap model) throws Exception{
		String url = "/mdl/modelItem/getModelListGrid";
		try{
			Map getMap = new HashMap();
			List getList = new ArrayList();			
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			
			String filter = StringUtil.checkNull(request.getParameter("filter"), "");
			if(filter.equals("itemOcc")){
				url = "/mdl/modelItem/itemMdlOccList";
				
				getMap.put("s_itemID", s_itemID);
				getMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"),""));			
				List occList = commonService.selectList("model_SQL.getItemMdlOccList_gridList", getMap);
				model.put("occDataSize",occList.size());
				JSONArray occData = new JSONArray(occList);
				model.put("occData",occData);
			}
			model.put("itemID",StringUtil.checkNull(request.getParameter("itemID"),""));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("pop", request.getParameter("pop"));
			model.put("modelID", StringUtil.checkNull( request.getParameter("modelID"),""));
			model.put("getWidth", StringUtil.checkNull( request.getParameter("getWidth"),"1024"));
			model.put("option", StringUtil.checkNull(commandMap.get("option")));
			
			Map authMap = new HashMap();
			String itemAthId = "";
			String blocked = "";
			String ItemTypeCode ="";
			
			authMap.put("itemId", StringUtil.checkNull(request.getParameter("s_itemID"),"")); 
			Map result  = mdItemService.select("fileMgt_SQL.selectItemAuthorID",authMap);
		
			model.put("selectedItemAuthorID", StringUtil.checkNull(result.get("AuthorID")));
			model.put("selectedItemBlocked", StringUtil.checkNull(result.get("Blocked")));
			model.put("selectedItemLockOwner", StringUtil.checkNull(result.get("LockOwner")));
			model.put("itemClassCode", StringUtil.checkNull(result.get("ClassCode")));
			model.put("selectedItemStatus", StringUtil.checkNull(result.get("Status")));
			model.put("ItemTypeCode", StringUtil.checkNull(result.get("ItemTypeCode")));
			model.put("itemInfo", result);
			model.put("s_itemID", s_itemID);
						
			String sessionUserID = commandMap.get("sessionUserId").toString();
			// Login user editor 권한 추가
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
			
//			if (StringUtil.checkNull(result.get("AuthorID")).equals(sessionUserID)
//					|| StringUtil.checkNull(result.get("LockOwner")).equals(commandMap.get("sessionUserId"))
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);
			
			// pop up 창에서 편집 버튼 제어 용
			model.put("pop", StringUtil.checkNull(request.getParameter("pop"),""));
			// 개요 화면에서 본 이벤트를 호출했을때 구분을 위한 파라메터
			model.put("isFromMain", StringUtil.checkNull(request.getParameter("isFromMain"),""));
			
			authMap.put("s_itemID",s_itemID);
			String itemBlocked = commonService.selectString("project_SQL.getItemBlocked", authMap);
			model.put("itemBlocked", itemBlocked);

			String viewYN = "";
			String myItemYN = StringUtil.checkNull(model.get("myItem"),"");
			viewYN = myItemYN.equals("Y") ? "N" : "Y"; model.put("viewYN", viewYN);
			getMap.put("viewYN",viewYN);
			getMap.put("s_itemID", s_itemID);
			getMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"),""));			
			List modelList = commonService.selectList("model_SQL.getModelList_gridList", getMap);
			model.put("modelList", modelList);
			JSONArray modelGridData = new JSONArray(modelList);
			model.put("gridData",modelGridData);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/saveModel.do")
	public String saveModel(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try {						
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			Map setMap = new HashMap();
			String modelTypeCode = request.getParameter("ModelTypeCode");
			setMap.put("modelTypeCode",modelTypeCode);
			String isModel = commonService.selectString("model_SQL.getIsModel",setMap); 
			if(isModel.equals("0")){
				setMap.put("isModel", isModel);
			}
			
			setMap.put("Deleted", "0");
			setMap.put("Creator", StringUtil.checkNull(request.getParameter("loginID")));
			setMap.put("ModelTypeCode", StringUtil.checkNull(request.getParameter("ModelTypeCode")));
			setMap.put("MTCategory", StringUtil.checkNull(request.getParameter("MTCTypeCode")));
			setMap.put("Identifier", StringUtil.checkNull(request.getParameter("newIdentifier")));
			setMap.put("Name", StringUtil.checkNull(request.getParameter("newModelName")));
			setMap.put("ItemID", s_itemID);	
			setMap.put("Blocked", "0");
			setMap.put("GUBUN","insert");
			setMap.put("Status", "NEW");
			setMap.put("ProjectID", StringUtil.checkNull(request.getParameter("projectID")));
			setMap.put("ChangeSetID", StringUtil.checkNull(request.getParameter("changeSetID")));
			setMap.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
			
			setMap.put("modelTypeCode", StringUtil.checkNull(request.getParameter("ModelTypeCode")));
			String modelXML = StringUtil.checkNull(commonService.selectString("model_SQL.getModelXML", setMap));
		
			setMap.put("modelXML", modelXML);
			
			mdItemService.save(setMap);			
			model.put("ModelID", setMap.get("ModelID"));
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
			target.put(AJAX_SCRIPT, "parent.callbackSave("+setMap.get("ModelID")+");");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); 
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}

	
	@RequestMapping(value="/deleteModel.do")
	public String deleteModel(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try {
			Map setMap = new HashMap();		
			String ModelIDS =  StringUtil.checkNull(request.getParameter("ModelIDS"),"");
			mdItemService.delete(commandMap);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			target.put(AJAX_SCRIPT, "parent.callbackDelete();");
		}catch(Exception e){
			System.out.println(e);
			//target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
			
	
	@RequestMapping(value="/updateModel.do")
	public String updateModel(HttpServletRequest request,  HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try {						
			 	String ModelID = StringUtil.checkNull(request.getParameter("ModelID"),"");
			 	String ModelName  = StringUtil.checkNull(request.getParameter("Name"),"");
			 	String Description = StringUtil.checkNull(request.getParameter("description"),"");
			 	String ModelTypeCode = StringUtil.checkNull(request.getParameter("ModelTypeCode"),"");
			 	String MTCTypeCode = StringUtil.checkNull(request.getParameter("MTCTypeCode"),"");
			 	String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),"");
			 	String ModelStatusCode = StringUtil.checkNull(request.getParameter("MdlStatus"),"");
			 	String Blocked = StringUtil.checkNull(request.getParameter("Blocked"),"0");
			 	String IsPublic = StringUtil.checkNull(request.getParameter("IsPublic"),"0");
			 	String ValidFrom = StringUtil.checkNull(request.getParameter("ValidFrom"),"");
			 	String ValidTo = StringUtil.checkNull(request.getParameter("ValidTo"),"");
			 	String IsModel = StringUtil.checkNull(request.getParameter("IsModel"),"0");
			 	
				Map setMap = new HashMap();
				setMap.put("ModelID", ModelID);
				setMap.put("Name", ModelName);
				setMap.put("Description", Description);
				setMap.put("ModelTypeCode", ModelTypeCode);
				setMap.put("MTCTypeCode", MTCTypeCode);
				setMap.put("languageID", languageID);
				setMap.put("LanguageID", languageID);
				setMap.put("Status", ModelStatusCode);
				setMap.put("Blocked", Blocked);
				setMap.put("IsPublic", IsPublic);
				setMap.put("ValidFrom",ValidFrom);
				setMap.put("ValidTo",ValidTo);
				setMap.put("IsModel",IsModel);
				
				List getModelTxt = commonService.selectList("model_SQL.getModelTxt", setMap);
				if(getModelTxt.size() == 0){ // 로그인한 언어가 없을경우 모델txt 신규생성
					setMap.put("GUBUN","insertModelTxt");
				}else{
					setMap.put("GUBUN","update");
					commonService.update("model_SQL.updateIsModel", setMap);
				}
				
				mdItemService.save(setMap);				
				model.put("ModelID", setMap.get("ModelID"));
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "parent.fnGoModelInfo('view');");
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/openCopyModelPop.do")
	public String openCopyModelPop(HttpServletRequest request, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{						
			 	String ModelID = StringUtil.checkNull(request.getParameter("ModelID"),"");
			 	String ModelName  = StringUtil.checkNull(request.getParameter("ModelName"),"");
			 	
			 	model.put("ModelID", ModelID);
			 	model.put("ModelName", ModelName);
			 	model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}
		catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/mdl/modelItem/copyModelPop");
	}
	
	@RequestMapping(value="/copyModel.do")
	public String copyModel(HttpServletRequest request,  HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try {						
			 	String ModelID = StringUtil.checkNull(request.getParameter("ModelID"),"");
			 	String newModelName  = StringUtil.checkNull(request.getParameter("ModelName"),"");
			 	String newMTCTypeCode = StringUtil.checkNull(request.getParameter("MTCTypeCode"),"");
			 	String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
			 	String Creator = StringUtil.checkNull(request.getParameter("Creator"),"");
			 	String includeItemMaster = StringUtil.checkNull(request.getParameter("includeItemMaster"),"");

				Map setMap = new HashMap();
				setMap.put("orgModelID", ModelID); 
				setMap.put("newModelName", newModelName);
				setMap.put("newMTCTypeCode", newMTCTypeCode);
				setMap.put("languageID", languageID);
				setMap.put("Creator", Creator);
				setMap.put("includeItemMaster", includeItemMaster);
				setMap.put("GUBUN","copy");
				mdItemService.save(setMap);
				model.put("ModelID", setMap.get("ModelID"));
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "parent.callbackSave();");
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/saveRefModel.do")
	public String saveRefModel(HttpServletRequest request,  HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try {						
			 	String ModelID = StringUtil.checkNull(request.getParameter("refModelID"),"");
			 	String checkWidthItemMaster  = StringUtil.checkNull(request.getParameter("checkWidthItemMaster"),"");
			 	String newModelName  = StringUtil.checkNull(request.getParameter("newModelName"),"");
			 	String newMTCTypeCode = StringUtil.checkNull(request.getParameter("MTCTypeCode"),"");
			 	String newModelTypeCode = StringUtil.checkNull(request.getParameter("ModelTypeCode"),"");
			 	String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
			 	String Creator = StringUtil.checkNull(request.getParameter("loginID"),"");
			 	String ItemID = StringUtil.checkNull(request.getParameter("ItemID"),"");
			 	String checkElmts = StringUtil.checkNull(request.getParameter("checkElmts"),"");
			 	
				Map setMap = new HashMap();
				setMap.put("orgModelID", ModelID); 
				setMap.put("includeItemMaster", checkWidthItemMaster);
				setMap.put("ModelName", newModelName);
				setMap.put("newMTCTypeCode", newMTCTypeCode);
				setMap.put("newModelTypeCode", newModelTypeCode);
				setMap.put("LanguageID", languageID);
				setMap.put("Creator", Creator);
				setMap.put("ItemID", ItemID);		
				setMap.put("checkElmts", checkElmts);
				setMap.put("itemId", ItemID);
				Map itemInfo = commonService.select("fileMgt_SQL.selectItemAuthorID",setMap);
				setMap.put("projectID",StringUtil.checkNull(itemInfo.get("ProjectID")));
				setMap.put("changeSetID",StringUtil.checkNull(itemInfo.get("CurChangeSet")));
				
				setMap.put("GUBUN","ref");
				mdItemService.save(setMap);
				model.put("ModelID", setMap.get("newModelID"));
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "parent.callbackSave("+setMap.get("newModelID")+");");
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/openReferenceModelPop.do")
	public String openReferenceModelPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{						
				String ItemTypeCode = StringUtil.checkNull(request.getParameter("ItemTypeCode"),""); 
				String ItemID = StringUtil.checkNull(request.getParameter("ItemID"),""); 
				String blocked = StringUtil.checkNull(request.getParameter("blocked"),""); 
				String itemAthId = StringUtil.checkNull(request.getParameter("itemAthId"),""); 
				String modelID = StringUtil.checkNull(request.getParameter("modelID"),""); 
				
				if(!modelID.equals("")){
					Map setData = new HashMap();
					setData.put("languageID", cmmMap.get("sessionCurrLangType"));
					setData.put("s_itemID", modelID);
					
					Map modelInfo = commonService.select("model_SQL.selectModelInfo", setData);
					model.put("modelInfo", modelInfo);
				}
				
				model.put("ItemTypeCode", ItemTypeCode);
				model.put("ItemID", ItemID);
				model.put("Blocked", blocked);
				model.put("itemAuthId", itemAthId);
				model.put("modelID", modelID);
				
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}
		catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/mdl/modelItem/referenceModelPop");
	}
	
	@RequestMapping(value="/reorganizeElement.do")
	public String reorganizeElement(HttpServletRequest request,  HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try {						
				Map setMap = new HashMap();
				
				List itemList = commonService.selectList("model_SQL.getNeedlessItem", setMap);
			//	deleteDimTreeInfo(cmmMap, itemList);
				
				List toItemList = commonService.selectList("model_SQL.getNeedlessToItem", setMap);
			//	deleteDimTreeInfo(cmmMap, toItemList);
				
				commonService.insert("model_SQL.deleteNeedlessItemAttr", setMap);
				commonService.insert("model_SQL.deleteNeedlessItemAttrTo", setMap);
				commonService.insert("model_SQL.deleteNeedlessItem", setMap);
				commonService.insert("model_SQL.deleteNeedlessItemInfo", setMap);
				commonService.insert("model_SQL.deleteNeedlessItemTo", setMap);
				commonService.insert("model_SQL.deleteRootError", setMap);
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069"));
				target.put(AJAX_SCRIPT, "doCallBack()");
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/createArisMdl.do")
	public String createArisMdl(HttpServletRequest request,  HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try {						
				Map setMap = new HashMap();
				String ItemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
				
				setMap.put("ItemID",ItemID);
				setMap.put("sessionUserId", cmmMap.get("sessionUserId"));
				setMap.put("defFontFamily", cmmMap.get("sessionDefFont"));
				setMap.put("defFontSize", cmmMap.get("sessionDefFontSize"));
				setMap.put("defFontColor", cmmMap.get("sessionDefFontColor"));
				setMap.put("defFontStyle", cmmMap.get("sessionDefFontStyle"));
				
				Map ModelMap = new HashMap();				
				ModelMap = commonService.select("model_SQL.getModelIDWithItemID", setMap);
				if(ModelMap == null){ // Aris모델이 없으면 
					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00105"));
					model.addAttribute(AJAX_RESULTMAP, target);
					return nextUrl(AJAXPAGE);
				}
				setMap.put("orgModelID", ModelMap.get("ModelID"));
				
				setMap.put("GUBUN", "insertArisModel");
				mdItemService.save(setMap);
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "");
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/compareModelList.do")
	public String compareModel(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{						
				String itemID = StringUtil.checkNull(request.getParameter("itemID"),""); 
				model.put("ItemID", itemID);
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				
				Map setMap = new HashMap();
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));	
				setMap.put("ItemID", itemID);
				setMap.put("ReportCode", StringUtil.checkNull(request.getParameter("ReportCode"),""));
				
				List selectCompareModelList = commonService.selectList("model_SQL.selectCompareModelList_gridList", setMap);
				
				JSONArray gridData = new JSONArray(selectCompareModelList);
				model.put("gridData", gridData);
		}
		catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/mdl/modelItem/selectCompareModelPop");
	}
	
	@RequestMapping(value="/validateItem.do")
	public String validateItem(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{						
				Map setMap = new HashMap();
				String itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				
				// Inbound Check Option 조회
				List inboundChks = new ArrayList();
				inboundChks = commonService.selectList("model_SQL.selectModelCategory",setMap);
				model.put("ItemID", itemID);
				model.put("inboundChks", inboundChks);
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
			    cmmMap.put("ItemID", itemID);
			    cmmMap.put("category", "MC");
			    cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				List<Map<String, Object>> modelCompareList = commonService.selectList("model_SQL.selectCompareModelList_gridList",cmmMap);
				
				JSONArray gridData = new JSONArray(modelCompareList);
				model.put("gridData",gridData);
				
		}
		catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/mdl/modelItem/validateItemPop");
	}
	
	@RequestMapping(value="/getValidateItemList.do")
	public String getValidateItemList(HttpServletRequest request, ModelMap model,HashMap cmmMap) throws Exception{
		Map target = new HashMap();
		try{						
				String ModelID = StringUtil.checkNull(request.getParameter("ModelID"),""); 
				String ItemID = StringUtil.checkNull(request.getParameter("ItemID"),""); 
				String ModelTypeCode = StringUtil.checkNull(request.getParameter("ModelTypeCode"));
				String InboundChks = StringUtil.checkNull(request.getParameter("InboundChk"),"");
				
				Map setMap = new HashMap();
				setMap.put("ModelID", ModelID);
				setMap.put("ItemID", ItemID);
				setMap.put("CntType", "Consistent");
				setMap.put("ModelTypeCode", ModelTypeCode);
				
				Map ConsistentMap = new HashMap();				
				ConsistentMap = commonService.select("model_SQL.selectValidateItemListCnt", setMap);
				
				Map InConsistentMap = new HashMap();
				setMap.remove("CntType");
				setMap.put("CntType", "Inconsistent");
				InConsistentMap = commonService.select("model_SQL.selectValidateItemListCnt", setMap);
				
				Map TotalMap = new HashMap();
				setMap.remove("CntType");
				TotalMap = commonService.select("model_SQL.selectValidateItemListCnt", setMap);
				
				model.put("Consistent", ConsistentMap.get("CNT"));
				model.put("InConsistent", InConsistentMap.get("CNT"));
				model.put("TotalCnt", TotalMap.get("CNT"));
				
				// grid2
				Map ConsistentMap2 = new HashMap();	
				setMap.remove("CntType");
				setMap.put("CntType", "Consistent");
				setMap.put("InboundChks", InboundChks);
				ConsistentMap2 = commonService.select("model_SQL.selectValidateItemListFromModelCnt", setMap);
				
				Map InConsistentMap2 = new HashMap();
				setMap.remove("CntType");
				setMap.put("CntType", "Inconsistent");
				InConsistentMap2 = commonService.select("model_SQL.selectValidateItemListFromModelCnt", setMap);
				
				Map TotalMap2 = new HashMap();
				setMap.remove("CntType");
				TotalMap2 = commonService.select("model_SQL.selectValidateItemListFromModelCnt", setMap);
				
				model.put("Consistent2", ConsistentMap2.get("CNT"));
				model.put("InConsistent2", InConsistentMap2.get("CNT"));
				model.put("TotalCnt2", TotalMap2.get("CNT"));
				
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				model.put("ModelID", ModelID);
				model.put("ItemID", ItemID);
				model.put("ModelTypeCode", ModelTypeCode);
				model.put("InboundChks", InboundChks);
	

				target.put("ItemID", ItemID);
				target.put("ModelID", ModelID);
				target.put("languageID", request.getParameter("languageID"));
				target.put("ModelTypeCode", ModelTypeCode);
				target.put("userId", cmmMap.get("sessionUserId"));
				target.put("authLev", cmmMap.get("sessionAuthLev"));
				List<Map<String, Object>> validateItemList = commonService.selectList("model_SQL.selectValidateItemList_gridList",target);
				
				JSONArray gridData1 = new JSONArray(validateItemList);
				model.put("gridData1",gridData1);
				
			
				target.put("InboundChks", InboundChks);
				List<Map<String, Object>> validateItemModelList = commonService.selectList("model_SQL.selectValidateItemListFromModel_gridList",target);
				
				JSONArray gridData2 = new JSONArray(validateItemModelList);
				model.put("gridData2",gridData2);
		}
		catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/mdl/modelItem/validateItemListPop");
	}
	
	@RequestMapping(value="/getValidateElementList.do")
	public String getValidateElementList(HttpServletRequest request, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{						
				String ModelID = StringUtil.checkNull(request.getParameter("ModelID"),""); 
				Map setMap = new HashMap();
			
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				model.put("ModelID", ModelID);
		}
		catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/mdl/modelItem/validateElementListPop");
	}
	
	@RequestMapping(value="/doTest.do")
	public String doTest(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{						
				String ItemID = StringUtil.checkNull(request.getParameter("ItemID"),""); 
				model.put("ItemID", ItemID);
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}
		catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/mdl/modelItem/modeligPrintHtml");
	}
	
	@RequestMapping(value="/processConnCheck.do")
	public String processConnCheck(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{						
				String itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
				String ArcCode = StringUtil.checkNull(request.getParameter("ArcCode"),"");
				String mdlCategory = StringUtil.checkNull(request.getParameter("mdlCategory"),"BAS");

 				Map setMap = new HashMap();	
 				
				if(!"".equals(ArcCode)) {
					setMap.put("ArcCode", ArcCode);
					Map temp = commonService.select("report_SQL.getArcFilterDimInfo", setMap);
					
					if(temp != null && !temp.isEmpty()) {
						model.put("DefDimTypeID", StringUtil.checkNull(temp.get("DimTypeID")));
						model.put("DefDimValueID", StringUtil.checkNull(temp.get("DefDimValueID")));
					}
				}			
				setMap.put("itemID", itemID);
				String classCode = StringUtil.checkNull(commonService.selectString("item_SQL.getClassCode", setMap));
				model.put("classCode", classCode);
				model.put("ItemID", itemID);
				model.put("mdlCategory", mdlCategory);
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}
		catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/mdl/modelItem/prcssCnnChkRptListPop");
	}
	
	@RequestMapping(value="/processConnCheckV4.do")
	public String processConnCheckV4(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		String url = "/mdl/modelItem/prcssCnnChkRptListPopV4";
		try{						
				String itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
				String ArcCode = StringUtil.checkNull(request.getParameter("ArcCode"),"");
				String mdlCategory = StringUtil.checkNull(request.getParameter("mdlCategory"),"BAS");

 				Map setMap = new HashMap();	
 				
				if(!"".equals(ArcCode)) {
					setMap.put("ArcCode", ArcCode);
					Map temp = commonService.select("report_SQL.getArcFilterDimInfo", setMap);
					
					if(temp != null && !temp.isEmpty()) {
						model.put("DefDimTypeID", StringUtil.checkNull(temp.get("DimTypeID")));
						model.put("DefDimValueID", StringUtil.checkNull(temp.get("DefDimValueID")));
					}
				}			
				setMap.put("itemID", itemID);
				String classCode = StringUtil.checkNull(commonService.selectString("item_SQL.getClassCode", setMap));
				model.put("classCode", classCode);
				model.put("ItemID", itemID);
				model.put("mdlCategory", mdlCategory);
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}
		catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}

	@RequestMapping(value="/selectPrcssCnnChkListV4.do", produces = "application/json; charset=utf8")
	@ResponseBody
	public void selectPrcssCnnChkListV4(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");
		JSONObject resultMap = new JSONObject();
		Map setMap = new HashMap();
		boolean success = false;		
		
	    try {
	        
	        // 파라미터 수신
	        String itemID = StringUtil.checkNull(request.getParameter("ItemID"));
	        String rptType = StringUtil.checkNull(request.getParameter("rptType"), "1");
	        String languageID = StringUtil.checkNull(request.getParameter("languageID"));
	        String mdlCategory = StringUtil.checkNull(request.getParameter("mdlCategory"));
	        String dimValueID = StringUtil.checkNull(request.getParameter("dimValueID"));

	        // 비즈니스 로직: rptType에 따른 SQL ID 설정
	        String sqlID = "model_SQL.selectPrcssCnnChkList_gridList"; // Outbound (default)
	        if ("2".equals(rptType)) {
	            sqlID = "model_SQL.selectPrcssCnnChkInBndList_gridList"; // Inbound
	        }

	        setMap.put("ItemID", itemID);
	        setMap.put("languageID", languageID);
	        setMap.put("mdlCategory", mdlCategory);
	        setMap.put("dimValueID", dimValueID);
	        setMap.put("sqlID", sqlID);

	        // 서비스 호출 (List 조회)
	        List cnnChkList = commonService.selectList(sqlID, setMap);
			success = true;
			resultMap.put("data", cnnChkList);

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
	
	/**
	 * 삭제 한 item의  Dimension 정보 삭제
	 * @param commandMap
	 * @param arrayStr
	 * @throws Exception
	 */
	@RequestMapping(value="/elementObjectList.do")
	public String elementObjectList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{						
				String refModelID = StringUtil.checkNull(request.getParameter("refModelID"),""); 
				model.put("refModelID", refModelID);
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}
		catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/mdl/element/elmtsObjectGridList");
	}
	
	@RequestMapping(value="/combineModel.do")
	public String combineModel(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{						
				String itemID = StringUtil.checkNull(request.getParameter("itemID"),""); 
				String newMTCTypeCode = StringUtil.checkNull(request.getParameter("newMTCTypeCode"),""); 
				model.put("itemID", itemID);
				model.put("newMTCTypeCode", newMTCTypeCode);
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}
		catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/mdl/modelItem/combineModelPop");
	}
	
	@RequestMapping(value="/saveCombineModel.do")
	public String saveCombineModel(HttpServletRequest request,  HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try {						
				Map setMap = new HashMap();
				String itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
				//String modelID = StringUtil.checkNull(request.getParameter("modelID"),"");
				String newMTCTypeCode = StringUtil.checkNull(request.getParameter("MTCTypeCode"),"");
				String newModelName  = StringUtil.checkNull(request.getParameter("newModelName"),"");
				setMap.put("itemID",itemID);
				String orgModelID = commonService.selectString("model_SQL.getModelIDFromItem",setMap);
				
				setMap.put("orgModelID", orgModelID);
				setMap.put("newMTCTypeCode", newMTCTypeCode);
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				setMap.put("Creator", cmmMap.get("sessionUserId"));
				setMap.put("newModelName", newModelName);
				
				
				List objectList = commonService.selectList("model_SQL.getOjbectListFromModel", setMap);
				setMap.put("objectList", objectList);
				setMap.put("GUBUN", "combineModelElement");
				mdItemService.save(setMap);
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "parent.callbackSave();");
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/viewModelInfo.do")
	public String viewModelInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try{
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			String modelID = StringUtil.checkNull(request.getParameter("modelID"),"");
			String itemAthId = StringUtil.checkNull(request.getParameter("itemAthId"),"");
			String blocked = StringUtil.checkNull(request.getParameter("blocked"),"");
			String ItemTypeCode = StringUtil.checkNull(request.getParameter("ItemTypeCode"));
			
			Map modelInfo = new HashMap();
			Map setData = new HashMap();
			setData.put("ModelID", modelID);
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			modelInfo = commonService.select("model_SQL.getModel", setData); 
			
			setData.put("itemId", s_itemID); 
			Map itemInfo  = mdItemService.select("fileMgt_SQL.selectItemAuthorID", setData);
			String sessionUserID = commandMap.get("sessionUserId").toString();
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev"));
			
//			if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(sessionUserID)
//					|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(sessionUserID)
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);
			
			model.put("modelInfo", modelInfo);
			model.put("s_itemID", s_itemID);	
			model.put("modelID", modelID);
			model.put("itemAthId", itemAthId);
			model.put("Blocked", blocked);			
			model.put("ItemTypeCode", ItemTypeCode);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/mdl/modelItem/viewModelInfo");
	}
	
	@RequestMapping(value="/editModelInfo.do")
	public String editModelInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try{
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			String modelID = StringUtil.checkNull(request.getParameter("modelID"),"");
			String itemAthId = StringUtil.checkNull(request.getParameter("itemAthId"),"");
			String blocked = StringUtil.checkNull(request.getParameter("blocked"),"");
			String ItemTypeCode = StringUtil.checkNull(request.getParameter("ItemTypeCode"));
			
			Map modelInfo = new HashMap();
			Map setData = new HashMap();
			setData.put("ModelID", modelID);
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			modelInfo = commonService.select("model_SQL.getModel", setData); 
			
			setData.put("itemId", s_itemID); 
			Map itemInfo  = mdItemService.select("fileMgt_SQL.selectItemAuthorID", setData);
			String sessionUserID = commandMap.get("sessionUserId").toString();
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev"));
			
//			if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(sessionUserID)
//					|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(sessionUserID)
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);
			
			model.put("modelInfo", modelInfo);
			model.put("modelID", modelID);
			model.put("s_itemID", s_itemID);		
			model.put("itemAthId", itemAthId);
			model.put("Blocked", blocked);			
			model.put("ItemTypeCode", ItemTypeCode);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/mdl/modelItem/editModelInfo");
	}
	
	@RequestMapping(value="/modelInfoMain.do")
	public String modelInfoMain(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try{
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			String modelID = StringUtil.checkNull(request.getParameter("modelID"),"");
			String varFilter = StringUtil.checkNull(request.getParameter("VarFilter"));
			String modelViewHYN = StringUtil.checkNull(request.getParameter("modelViewHYN"));
			
			Map modelInfo = new HashMap();
			Map setData = new HashMap();
			setData.put("ModelID", modelID);
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			modelInfo = commonService.select("model_SQL.getModel", setData); 
			
			setData.put("itemId", s_itemID); 
			Map itemInfo  = mdItemService.select("fileMgt_SQL.selectItemAuthorID", setData);
			String sessionUserID = commandMap.get("sessionUserId").toString();
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev"));
			
//			if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(sessionUserID)
//					|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(sessionUserID)
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);
			
			model.put("modelInfo", modelInfo);
			model.put("s_itemID", s_itemID);	
			model.put("modelID", modelID);
			model.put("itemAthId", StringUtil.checkNull(itemInfo.get("AuthorID")));
			model.put("Blocked", StringUtil.checkNull(itemInfo.get("Blocked")));			
			model.put("ItemTypeCode", StringUtil.checkNull(itemInfo.get("ItemTypeCode")));
			model.put("itemStatus", StringUtil.checkNull(itemInfo.get("Status")));
			model.put("pop", StringUtil.checkNull(commandMap.get("pop")));
			model.put("varFilter", varFilter);
			model.put("modelViewHYN", modelViewHYN);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/mdl/modelItem/modelInfoMain");
	}
	
	@RequestMapping(value="/openEditModelSortNum.do")
	public String openEditModelSortNum(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try{
			String itemIDs = StringUtil.checkNull(request.getParameter("itemIDs"),"");
			String modelID = StringUtil.checkNull(request.getParameter("modelID"),"");
			String cxnYN = StringUtil.checkNull(request.getParameter("cxnYN"),"");
			String callBack = StringUtil.checkNull(request.getParameter("callBack"),"");
			
			Map setData = new HashMap();
			setData.put("itemIDs", itemIDs);
			setData.put("modelID", modelID);
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			setData.put("cxnYN", cxnYN);
			List itemList = commonService.selectList("model_SQL.getElementItemList_gridList", setData);
			model.put("itemList", itemList);
			model.put("itemIDs", itemIDs);	
			model.put("modelID", modelID);
			model.put("callBack", callBack);
						
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/mdl/modelItem/editModelSortNum");
	}
	
	@RequestMapping(value="/editModelSortNum.do")
	public String editModelSortNum(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{
			String elementIDs[] = StringUtil.checkNull(request.getParameter("elementIDs"),"").split(",");
			String modelID = StringUtil.checkNull(request.getParameter("modelID"),"");
			String elementID = "";
			String sortNum = "";
			Map setData = new HashMap();
			setData.put("modelID",modelID);
			for(int i=0; elementIDs.length > i; i++){
				elementID = StringUtil.checkNull(elementIDs[i],"");				
				sortNum = StringUtil.checkNull(request.getParameter("sortNum_"+elementID),"");				
				setData.put("sortNum", sortNum);
				setData.put("elementID", elementID);
				//if(!sortNum.equals("")){ commonService.update("model_SQL.updateModelSortNum", setData);	}	
				commonService.update("model_SQL.updateModelSortNum", setData);	
			}
									
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "parent.fnCallBack();");
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	@RequestMapping(value="/myPageMainModelList.do")
	public String myPageMainModelList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		try {

			HashMap setMap = new HashMap();
			
			String listSize = StringUtil.checkNull(request.getParameter("listSize"));
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
		
			model.put("listSize", listSize);
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("userID", cmmMap.get("sessionUserId").toString());
			setMap.put("sessionUserId", cmmMap.get("sessionUserId").toString());
			setMap.put("searchKey", StringUtil.checkNull(request.getParameter("searchKey"), ""));
			setMap.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue"), ""));			
			setMap.put("screenType", StringUtil.checkNull(request.getParameter("screenType"), ""));			
			setMap.put("modelTypeCode", StringUtil.checkNull(request.getParameter("modelTypeCode"), ""));			
			setMap.put("MTCategory", StringUtil.checkNull(request.getParameter("MTCategory"), ""));			
			
			List getModelList = commonService.selectList("model_SQL.getModelList_gridList", setMap);
			
			JSONArray gridData = new JSONArray(getModelList);
			model.put("gridData", gridData);
		}		
		catch (Exception e) {System.out.println(e);throw new ExceptionUtil(e.toString());}		
		return nextUrl("/mdl/modelItem/myPageMainModelList");
	}
		
	@RequestMapping(value="/viewModelElmTree.do")
	public String viewModelElmTree(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		try {
			Map modelMap = new HashMap();
			Map getData = new HashMap();
			List<Map<String, Object>> prcList = new ArrayList();
			List cxnList = new ArrayList();
			Map modelInfo = new HashMap();
			
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");		
			String modelID  =  StringUtil.checkNull(request.getParameter("modelID"),"");
			String MTCategory = StringUtil.checkNull(request.getParameter("MTCategory"),""); // 모델 카테고리
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),"");
			String gridChk = StringUtil.checkNull(request.getParameter("gridChk"),"element");
			String childYN = StringUtil.checkNull(request.getParameter("showChild"));
			
			model.put("itemID", s_itemID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("option", request.getParameter("option"));
			model.put("filter", request.getParameter("varFilter"));
			
			cmmMap.put("itemId", s_itemID);
			cmmMap.put("languageID", request.getParameter("languageID"));
			
			Map itemInfo  = commonService.select("fileMgt_SQL.selectItemAuthorID",cmmMap);
			String itemStatus = StringUtil.checkNull(itemInfo.get("Status"));
			cmmMap.put("ModelID", modelID);
			cmmMap.put("ItemID", s_itemID);
			cmmMap.put("languageID", request.getParameter("languageID"));
			modelMap = commonService.select("model_SQL.getModelViewer", cmmMap);
						
			cmmMap.put("modelID",modelMap.get("ModelID"));
			cmmMap.put("cxnYN","N");
			cmmMap.put("gridChk", gridChk);
			
			if(gridChk.equals("element")||gridChk == "element") {
				cmmMap.put("classCode",StringUtil.checkNull(request.getParameter("classCode"),""));
				cmmMap.put("searchKey",StringUtil.checkNull(request.getParameter("searchKey"),""));
				cmmMap.put("searchValue",StringUtil.checkNull(request.getParameter("searchValue"),""));
				
				List<Map<String, Object>> ClassCode = (List) commonService.selectList("common_SQL.getElementClassCode_commonSelect", cmmMap );
				prcList = (List) commonService.selectList("model_SQL.getElementItemList_gridList", cmmMap);
				
				List<Map<String, Object>> classCodeList = ClassCode.stream()
				    .map(item -> {
				        Map<String, Object> newMap = new java.util.HashMap<>(item);
				        
				        newMap.put("id", newMap.get("CODE"));
				        newMap.put("ItemName", newMap.get("NAME"));
				        newMap.put("parent", "1");
				        
				        newMap.remove("CODE");
				        newMap.remove("NAME");
				        
				        return newMap;
			    })
			    .collect(Collectors.toList());
			        
				for(int i=0; i < prcList.size(); i++) {
					Map<String, Object> newMap = new java.util.HashMap<>(prcList.get(i));
					newMap.put("ItemName", newMap.get("Identifier")+" "+newMap.get("ItemName"));
					
					classCodeList.add(newMap);
				}
				
				modelMap.put("id","1");
				modelMap.put("ItemName",modelMap.get("ModelName")+"("+modelMap.get("MCName")+")");
				modelMap.remove("LastUpdated");
				classCodeList.add(modelMap);
				
				JSONArray treeGridData = new JSONArray(classCodeList);
				model.put("treeGridData",treeGridData);
								
				model.put("classCode",StringUtil.checkNull(request.getParameter("classCode"),""));
				model.put("searchKey",StringUtil.checkNull(request.getParameter("searchKey"),""));
				model.put("searchValue",StringUtil.checkNull(request.getParameter("searchValue"),""));
			}
			if(gridChk.equals("group")||gridChk == "group"){
				cmmMap.put("groupClassCode",StringUtil.checkNull(request.getParameter("groupClassCode"),""));
				cmmMap.put("groupElementCode",StringUtil.checkNull(request.getParameter("groupElementCode"),""));
				
				prcList = (List) commonService.selectList("model_SQL.getGroupElementItemList_gridList", cmmMap);
				
				prcList = prcList.stream()
				    .map(item -> {
				        Map<String, Object> newMap = new java.util.HashMap<>(item);
				        newMap.put("parent", newMap.get("GroupItemID"));
				        newMap.put("ItemName", newMap.get("ChildID")+" "+newMap.get("ChildItemName"));
				        return newMap;
			    })
			    .collect(Collectors.toList());
				
				List<Map<String, Object>> ClassCode = commonService.selectList("common_SQL.getGroupElementClassCode_commonSelect", cmmMap );
				
				List<Map<String, Object>> elementList = new ArrayList();
				
				for(int i=0; i < ClassCode.size(); i++) {
					Map classInfo =  ClassCode.get(i);
					cmmMap.put("classCode", classInfo.get("CODE"));
					List<Map<String, Object>> elementGroup = (List) commonService.selectList("common_SQL.getGroupElementCode_commonSelect", cmmMap );
					
					elementGroup = elementGroup.stream()
					    .map(item -> {
					        Map<String, Object> newMap = new java.util.HashMap<>(item);
					        
					        newMap.put("id", newMap.get("ItemID"));
					        newMap.put("ItemName", classInfo.get("NAME")+" - "+newMap.get("NAME"));
					        newMap.put("parent", "1");
					        
					        return newMap;
				    })
				    .collect(Collectors.toList());
					
					elementList.addAll(elementGroup);
				}
				
				modelMap.put("id","1");
				modelMap.put("ItemName",modelMap.get("ModelName")+"("+modelMap.get("MCName")+")");
				modelMap.remove("LastUpdated");
				elementList.add(modelMap);
				elementList.addAll(prcList);
				
				JSONArray treeGridData = new JSONArray(elementList);
				model.put("treeGridData",treeGridData);
				model.put("groupClassCode",StringUtil.checkNull(request.getParameter("groupClassCode"),""));
				model.put("groupElementCode",StringUtil.checkNull(request.getParameter("groupElementCode"),""));
			}
			
			cmmMap.put("ModelID",modelMap.get("ModelID"));
			modelInfo = commonService.select("model_SQL.getModel", cmmMap);
			String sessionUserID = cmmMap.get("sessionUserId").toString();
			String sessionAuthLev = String.valueOf(cmmMap.get("sessionAuthLev"));
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			model.put("myItem", myItem);
			
			model.put("s_itemID",s_itemID);
			model.put("ModelID",StringUtil.checkNull(modelMap.get("ModelID"),""));
			model.put("gridChk",gridChk);
			model.put("modelInfo", modelInfo);
			model.put("showChild",childYN);
		}		
		catch (Exception e) {System.out.println(e);throw new ExceptionUtil(e.toString());}		
		return nextUrl("/mdl/modelItem/viewModelElmTree");
	}
	
	private String setProcessXML(String itemID, Map modelMap,  List prcListData, String languageID, String gridChk, String childYN) throws Exception {
		Map setMap = new HashMap();
		List subItemList = new ArrayList();
		String ModelID= "";
		String ModelName= "";
		
		String CELL = "	<cell></cell>";
		String CELL_CHECK = "	<cell>0</cell>";
		String CELL_OPEN = "	<cell>";
		String CELL_CLOSE = "</cell>";
		String CLOSE = ">";
		String CELL_TOT = "";
		String ROW_OPEN = "<row id=";
		String ROW_CLOSE = "</row>";
		int rowCnt = 8;
		
		String deleted = "";
		String deletedStyle = "style='text-decoration: line-through; color:red;";
		
		// row ID 를 unique 하게 설정 하기 위한 seq
		int rowId = 0;
		String result = "";
		String resultRow = "";
		if (modelMap.size() > 0) {
			ModelID = StringUtil.checkNull(modelMap.get("ModelID"),"");
			ModelName = (StringUtil.checkNull(modelMap.get("ModelName"))).replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ");	
			
			setMap.put("modelID",ModelID);
			setMap.put("languageID", languageID);
			
			result += "<rows>";
			result += "<row id='1' open='1' style='font-weight:bold'>";
			result += CELL_CHECK;
			result += "	<cell image='img_sitemap.png'> " + ModelName.replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ")
					+"("+modelMap.get("MCName")+")"+ "</cell>";
			for (int i = 0; i < rowCnt; i++) {
				CELL_TOT += CELL;
				if (i == rowCnt - 1) {
					result += CELL_OPEN + ModelID + CELL_CLOSE;
				} else {
					result += CELL;
				}
			}
			result += CELL;
			
			if(gridChk.equals("element") || gridChk == "element"){
				List ClassCode = (List) commonService.selectList("common_SQL.getElementClassCode_commonSelect", setMap );
				for (int j = 0; j < ClassCode.size(); j++){
					Map classCodeMap = (HashMap) ClassCode.get(j);
					String classCode = StringUtil.checkNull(classCodeMap.get("CODE"));
					
					resultRow += "<row id='" + classCode + "' open='1' style='font-weight:bold'>";
					resultRow += CELL_CHECK;
					resultRow += "	<cell image='"
							+ StringUtil.checkNull(classCodeMap.get("ICON"))
							+ "'> " + StringUtil.checkNull(classCodeMap.get("NAME")) + CELL_CLOSE;
					resultRow += CELL_TOT;
					resultRow += "	" + CELL_OPEN + classCode + CELL_CLOSE;
					resultRow += "	" + CELL;
					resultRow += "	" + CELL;
					resultRow += "	" + CELL;
				
					for (int i = 0; i < prcListData.size(); i++) {
						Map fstMap = (HashMap) prcListData.get(i);
						String fstClassCode = StringUtil.checkNull(fstMap.get("ClassCode"));
						deleted = StringUtil.checkNull(fstMap.get("Deleted"));
						deletedStyle = "style='text-decoration: line-through; color:red;'";
						if(!deleted.equals("1")){
							deletedStyle = "";
						}

						String statusStyle = "style='color:#000000;'";
						if (fstClassCode.equals(classCode)) {
							resultRow+=ROW_OPEN+"'"+StringUtil.checkNull(fstMap.get("ItemID"))+ String.valueOf(rowId) +"' "+deletedStyle+">";
							resultRow += CELL_CHECK;
							resultRow += "	<cell>";
							String Identifier = StringUtil.checkNull(fstMap.get("Identifier"));
							if(Identifier.length() != 0){
								resultRow += StringUtil.checkNull(fstMap.get("Identifier")) + " ";
							}
							
							if(StringUtil.checkNull(fstMap.get("Status")).equals("NEW1")) statusStyle = "style='color:blue;font-weight:bold'";
							if(StringUtil.checkNull(fstMap.get("Status")).equals("MOD1") || StringUtil.checkNull(fstMap.get("Status")).equals("MOD2")) statusStyle = "style='color:orange;font-weight:bold'";
							
							resultRow += StringUtil.checkNull(fstMap.get("ItemName")).replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ") + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + "" + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN	+ StringUtil.checkNull(fstMap.get("Path")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN	+ StringUtil.checkNull(fstMap.get("ComTeamName")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN	+ StringUtil.checkNull(fstMap.get("OwnerTeamName")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN	+ StringUtil.checkNull(fstMap.get("AuthorName")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN	+ StringUtil.checkNull(fstMap.get("LastUpdated"))	+ CELL_CLOSE;
							resultRow += "		" + "<cell "+statusStyle+">" + StringUtil.checkNull(fstMap.get("StatusName"),"-") + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("ItemID")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + fstClassCode + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("AuthorID")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("Blocked")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("ElementID")) + CELL_CLOSE;
							
							if(childYN.equals("true")) {
								setMap.put("s_itemID",StringUtil.checkNull(fstMap.get("ItemID")));
								setMap.put("gubun", "M");
								setMap.put("getPathYN", "Y");
								subItemList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
								if(subItemList.size() > 0){
									for(int k=0; k<subItemList.size(); k++){
										Map subItemMap = (HashMap) subItemList.get(k);
										deleted = StringUtil.checkNull(subItemMap.get("Deleted"));
										if(!deleted.equals("1")){
											deletedStyle = "";
										}
										
										if(StringUtil.checkNull(subItemMap.get("Status")).equals("NEW1")) statusStyle = "style='color:blue;font-weight:bold'";
										if(StringUtil.checkNull(subItemMap.get("Status")).equals("MOD1") || StringUtil.checkNull(subItemMap.get("Status")).equals("MOD2")) statusStyle = "style='color:orange;font-weight:bold'";
										
										resultRow+=ROW_OPEN+"'"+StringUtil.checkNull(subItemMap.get("ItemID"))+ String.valueOf(rowId) +"'"+deletedStyle+">";
										resultRow += CELL_CHECK;
										resultRow += "	<cell>"+StringUtil.checkNull(subItemMap.get("Identifier"))+ " "
														+StringUtil.checkNull(subItemMap.get("ItemName")).replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ") + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN + "" + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN	+ StringUtil.checkNull(subItemMap.get("Path")) + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN	+ StringUtil.checkNull(subItemMap.get("TeamName")) + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN	+ StringUtil.checkNull(subItemMap.get("OwnerTeamName")) + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN	+ StringUtil.checkNull(subItemMap.get("Name")) + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN	+ StringUtil.checkNull(subItemMap.get("LastUpdated"))	+ CELL_CLOSE;
										resultRow += "		" + "<cell "+statusStyle+">" + StringUtil.checkNull(subItemMap.get("StatusName")) + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN + StringUtil.checkNull(subItemMap.get("ItemID")) + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN + StringUtil.checkNull(subItemMap.get("ClassCode")) + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN + StringUtil.checkNull(subItemMap.get("AuthorID")) + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN + StringUtil.checkNull(subItemMap.get("Blocked")) + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN + StringUtil.checkNull(subItemMap.get("ElementID")) + CELL_CLOSE;
										resultRow += ROW_CLOSE;
									}
								}
							}
							
							rowId++;
							resultRow += ROW_CLOSE;
		//					if (i == prcListData.size() - 1) {
		//						resultRow += ROW_CLOSE;
		//					}
						}
					}
					resultRow += ROW_CLOSE;
				}
			} else { // Group
				Map ClassCode = commonService.select("common_SQL.getGroupElementClassCode_commonSelect", setMap );
				setMap.put("classCode", ClassCode.get("CODE"));
				List elementGroup = (List) commonService.selectList("common_SQL.getGroupElementCode_commonSelect", setMap );
				for (int j = 0; j < elementGroup.size(); j++){
					Map ItemIDMap = (HashMap) elementGroup.get(j);
					String ItemID = StringUtil.checkNull(ItemIDMap.get("ItemID"));
					
					resultRow += "<row id='" + ItemID + "' open='1'>";
					resultRow += CELL_CHECK;
					resultRow += "	<cell image='"
							+ StringUtil.checkNull(ItemIDMap.get("ICON"))
							+ "'> " + StringUtil.checkNull(ClassCode.get("NAME")) + " - "
							+ StringUtil.checkNull(ItemIDMap.get("NAME")) + CELL_CLOSE;
					resultRow += CELL_TOT;
					resultRow += "	" + CELL_OPEN + ItemID + CELL_CLOSE;
					resultRow += "	" + CELL;
					resultRow += "	" + CELL;
				
					for (int i = 0; i < prcListData.size(); i++) {
						Map fstMap = (HashMap) prcListData.get(i);
						String fstGroupItemID = StringUtil.checkNull(fstMap.get("GroupItemID"));
						deleted = StringUtil.checkNull(fstMap.get("Deleted"));
						if (fstGroupItemID.equals(ItemID)) {
							if(!deleted.equals("1")){ deletedStyle = ""; }
							resultRow+=ROW_OPEN+"'"+StringUtil.checkNull(fstMap.get("ChildItemID"))+ String.valueOf(rowId) +"'"+deletedStyle+">";
							rowId++;
							resultRow += CELL_CHECK;
							resultRow+="	<cell image='"+ StringUtil.checkNull(fstMap.get("ItemTypeImg"))+"'>" + " "
									+ StringUtil.checkNull(fstMap.get("ChildID")) + " "
									+ StringUtil.checkNull(fstMap.get("ChildItemName")).replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ") + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("ChildClassName")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("Path")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("ComTeamName")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("OwnerTeamName")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("AuthorName")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("LastUpdated")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("StatusName")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("ChildItemID")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("ClassCode")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("AuthorID")) + CELL_CLOSE;
							resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("Blocked")) + CELL_CLOSE;
							resultRow += ROW_CLOSE;
		//					if (i == prcListData.size() - 1) {
		//						resultRow += ROW_CLOSE;
		//					}
						}
					}
					resultRow += ROW_CLOSE;
				}
			}
	
			result += resultRow;
			result += "</row>";
			result += "</rows>";
		}
		return result.replace("&", "/"); // 특수 문자 제거
	}
	
	@RequestMapping(value="/compareModel.do")
	public String compareModelByChangeSet(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		try{
			String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));
			String languageID = StringUtil.checkNull(cmmMap.get("languageID"));
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"));
			String preChangeSet = StringUtil.checkNull(request.getParameter("preChangeSet"));
			String modelID1 = StringUtil.checkNull(request.getParameter("modelID1"));
			String modelID2 = StringUtil.checkNull(request.getParameter("modelID2"));
			String ModelID1 ="", ModelID2 = "", curChangeSet="", releaseNo="";
			
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", languageID);
			
			Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
			if (modelID1.equals("") && modelID2.equals("")) {
				if(!changeSetID.equals("")) {	// 변경이력에서 조회
					curChangeSet = changeSetID;
					setMap.put("changeSetID", changeSetID);
					// 이전 changeSetID & modelID 구하기
					preChangeSet = commonService.selectString("cs_SQL.getPreChangeSetID",setMap);
					setMap.put("changeSetID", preChangeSet);
					ModelID1 = commonService.selectString("model_SQL.getModelIDCSID",setMap);
				} else {		// 일반 탭에서 조회
					curChangeSet = StringUtil.checkNull(itemInfo.get("CurChangeSet"));
					releaseNo = StringUtil.checkNull(itemInfo.get("ReleaseNo"));
					
					if(curChangeSet.equals(releaseNo)) {
						setMap.put("changeSetID", releaseNo);
						// 이전 changeSetID & modelID 구하기
						preChangeSet = commonService.selectString("cs_SQL.getPreChangeSetID",setMap);
						setMap.put("changeSetID", preChangeSet);
						ModelID1 = commonService.selectString("model_SQL.getModelIDCSID",setMap);
					} else {
						preChangeSet = releaseNo;
						setMap.put("changeSetID", preChangeSet);
						ModelID1 = commonService.selectString("model_SQL.getModelIDCSID",setMap);
					}
				}
				setMap.put("changeSetID", curChangeSet);
				ModelID2  = commonService.selectString("model_SQL.getModelIDCSID",setMap);
			} else {
				ModelID1 = modelID1;
				ModelID2 = modelID2;
			}
			
			// Model1(Base)
			Map setData = new HashMap();
			Map modelNmMap1 = new HashMap();
			Map modelNmMap2 = new HashMap();
			String itemCurCS = StringUtil.checkNull(itemInfo.get("CurChangeSet"));
			setData.put("ItemID", s_itemID);
			setData.put("ModelID", ModelID1);
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			modelNmMap1 = commonService.select("model_SQL.getModelViewer", setData);
			model.put("itemID1", modelNmMap1.get("ItemID")); 
			model.put("ModelTypeName1", modelNmMap1.get("ModelTypeName"));
			model.put("ModelName1", modelNmMap1.get("ModelTypeName"));
			model.put("MTCategory1", modelNmMap1.get("MTCategory"));
			model.put("LastUpdated1", modelNmMap1.get("LastUpdated"));
			if (!modelID1.equals("") && !modelID2.equals("")) {
				if(!itemCurCS.equals(preChangeSet)) {
					preChangeSet = StringUtil.checkNull(modelNmMap1.get("ChangeSetID"));
				}
			}
			
			// Model2(Tobe)
			setData.put("ModelID", ModelID2);
			modelNmMap2 = commonService.select("model_SQL.getModelViewer", setData);
			model.put("itemID2", modelNmMap2.get("ItemID"));
			model.put("ModelTypeName2", modelNmMap2.get("ModelTypeName"));
			model.put("ModelName2", modelNmMap2.get("ModelTypeName"));
			model.put("MTCategory2", modelNmMap2.get("MTCategory"));
			model.put("LastUpdated2", modelNmMap2.get("LastUpdated"));
			if (!modelID1.equals("") && !modelID2.equals("")) {
				if(!itemCurCS.equals(changeSetID)) {
					changeSetID = StringUtil.checkNull(modelNmMap2.get("ChangeSetID"));
				}
			}
			
			if(itemCurCS.equals(changeSetID)) changeSetID = "";
			
			model.put("ModelID1",ModelID1);
			model.put("ModelID2",ModelID2);
			
			setMap.put("ModelIDTobe", ModelID2);
			setMap.put("ModelIDBas", ModelID1);
			
			setMap.put("CntType", "New");				
			Map CntMap = new HashMap();				
			CntMap = commonService.select("model_SQL.getTobeBasModelCnt", setMap);
			model.put("New", CntMap.get("ElementCnt"));
			
			CntMap = new HashMap();	
			setMap.remove("CntType");
			setMap.put("CntType", "Deleted");
			CntMap = commonService.select("model_SQL.getTobeBasModelCnt", setMap);
			model.put("Deleted", CntMap.get("ElementCnt"));
			
			CntMap = new HashMap();		
			setMap.remove("CntType");
			setMap.put("CntType", "Modified");
			setMap.put("preChangeSet", preChangeSet);
			setMap.put("changeSetID", changeSetID);
			CntMap = commonService.select("model_SQL.getTobeBasModelCnt", setMap);
			model.put("Modified", CntMap.get("ElementCnt"));
						
			setMap.put("languageID",languageID);
			setMap.put("releaseNo", preChangeSet);
			setMap.put("changeSetID", changeSetID);
			setMap.put("ModelIDBas", ModelID1);
			setMap.put("ModelIDTobe", ModelID2);
			List<Map<String, Object>> elmList = commonService.selectList("model_SQL.getChangeSetModelList_gridList", setMap);
			
			if(!changeSetID.equals("")) {
				setMap.put("changeSetID",changeSetID);
				itemInfo = commonService.select("item_SQL.getItemAttrRevInfo", setMap);
			} else {
				itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
			}
			curChangeSet = StringUtil.checkNull(itemInfo.get("CurChangeSet"));
			String itemVer = StringUtil.checkNull(itemInfo.get("Version"),"1.0");
			
			Map itemRevInfo = new HashMap();
			setMap.put("s_itemID", s_itemID);
			if(!preChangeSet.equals("")) {
				setMap.put("changeSetID",preChangeSet);
				itemRevInfo = commonService.select("item_SQL.getItemAttrRevInfo", setMap);
			} else {
				itemRevInfo = commonService.select("report_SQL.getItemInfo", setMap);
			}
			String itemRevVer = StringUtil.checkNull(itemRevInfo.get("Version"),"1.0");
			String identifier = StringUtil.checkNull(itemRevInfo.get("Identifier"));
			
			setMap.put("s_itemID",ModelID1);
			Map model1Name = commonService.select("model_SQL.selectModelInfo", setMap);
			setMap.put("s_itemID",ModelID2);
			Map model2Name = commonService.select("model_SQL.selectModelInfo", setMap);
						
			// 첫번째 행
			Map firstRow = new HashMap();
			firstRow.put("id", "1");
			firstRow.put("Identifier", identifier);
			firstRow.put("PlainTextBAS", model1Name.get("Name") +" Ver. "+itemRevVer);
			firstRow.put("PlainTextTOBE", model2Name.get("Name") +" Ver "+itemVer);
			firstRow.put("button", "<button class='gridBtn'>View</button>");
			firstRow.put("ObjectID", s_itemID);
			firstRow.put("PreChangeSetID", preChangeSet);
			if(!changeSetID.equals("")) {
				firstRow.put("ChangeSetID", changeSetID);
			} else {
				firstRow.put("ChangeSetID", curChangeSet);
			}
			
			final String finalCurChangeSet = changeSetID;
			
			elmList = elmList.stream()
			    .map(item -> {
			        Map<String, Object> newMap = new java.util.HashMap<>(item);
			        String ChangeMode = StringUtil.checkNull(newMap.get("ChangeMode"));
			        String ChangeSetID = StringUtil.checkNull(newMap.get("ChangeSetID"));
			        
					if(finalCurChangeSet.equals(ChangeSetID) && !ChangeMode.equals("추가") && !ChangeMode.equals("삭제"))
						newMap.put("button","<button class='gridBtn'>View</button>");
					else
						newMap.put("button","");
					
			        return newMap;
		    })
		    .collect(Collectors.toList());
			
			elmList.add(0, firstRow);
			
			JSONArray gridData = new JSONArray(elmList);
			model.put("gridData", gridData);
			
			model.put("s_itemID", s_itemID);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl("/mdl/modelItem/compareModelByChangeSet");
	}
	
	private void setCompareModelListXmlData(String filepath,  String languageID, String xmlFilName, String s_itemID, String preChangeSet,  String changeSetID, String ModelID1, String ModelID2 ) throws Exception {
		/* xml 파일 존재 할 경우 삭제 */
		File oldFile = new File(filepath + xmlFilName);
		if (oldFile.exists()) {
			oldFile.delete();
		}
		
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance(); 
		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		
		// 루트 엘리먼트 
		Document doc = docBuilder.newDocument(); 
		Element rootElement = doc.createElement("rows"); 
		doc.appendChild(rootElement); 
		
		Map setMap = new HashMap();
		setMap.put("languageID",languageID);
		
		String HTML_IMG_DIR = GlobalVal.HTML_IMG_DIR;
		String HTML_IMG_DIR_MODEL_SYMBOL = GlobalVal.HTML_IMG_DIR_MODEL_SYMBOL;
		Element row, cell;
		
		setMap.put("s_itemID",ModelID1);
		Map model1Name = commonService.select("model_SQL.selectModelInfo", setMap);
		setMap.put("s_itemID",ModelID2);
		Map model2Name = commonService.select("model_SQL.selectModelInfo", setMap);
		
		Map itemRevInfo = new HashMap();
		setMap.put("s_itemID", s_itemID);
		if(!preChangeSet.equals("")) {
			setMap.put("changeSetID",preChangeSet);
			itemRevInfo = commonService.select("item_SQL.getItemAttrRevInfo", setMap);
		} else {
			itemRevInfo = commonService.select("report_SQL.getItemInfo", setMap);
		}
		
		String itemRevVer = StringUtil.checkNull(itemRevInfo.get("Version"),"1.0");
		String identifier = StringUtil.checkNull(itemRevInfo.get("Identifier"));
		
		Map itemInfo = new HashMap();
		if(!changeSetID.equals("")) {
			setMap.put("changeSetID",changeSetID);
			itemInfo = commonService.select("item_SQL.getItemAttrRevInfo", setMap);
		} else {
			itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
		}
		String itemNM = StringUtil.checkNull(itemInfo.get("ItemName"));
		String itemVer = StringUtil.checkNull(itemInfo.get("Version"),"1.0");
		String curChangeSet = StringUtil.checkNull(itemInfo.get("CurChangeSet"));
		
		// change set 에 따른 아이템명 
		row = doc.createElement("row"); 
		rootElement.appendChild(row); 
		row.setAttribute("id", String.valueOf(0));
        
		cell = doc.createElement("cell");			cell.appendChild(doc.createTextNode(""));		row.appendChild(cell);
		cell = doc.createElement("cell");			cell.appendChild(doc.createTextNode(""));		row.appendChild(cell);
		cell = doc.createElement("cell");			cell.appendChild(doc.createTextNode(identifier));		row.appendChild(cell);
		
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode(model1Name.get("Name") +" Ver. "+itemRevVer));
        cell.setAttribute("style", "font-weight:bold;");
		row.appendChild(cell);
		
		cell = doc.createElement("cell");			cell.appendChild(doc.createTextNode("<image src=\"/"+HTML_IMG_DIR+"btn_model.png\" title=\"모델 조회\">"));		row.appendChild(cell);
		
		cell = doc.createElement("cell");	
		cell.appendChild(doc.createTextNode(model2Name.get("Name") +" Ver "+itemVer));
	    cell.setAttribute("style", "font-weight:bold;");
		row.appendChild(cell);
		
		cell = doc.createElement("cell");			cell.appendChild(doc.createTextNode("<image src=\"/"+HTML_IMG_DIR+"btn_model.png\" title=\"모델 조회\">"));		row.appendChild(cell);
		
		cell = doc.createElement("cell");			cell.appendChild(doc.createTextNode(""));		row.appendChild(cell);
		cell = doc.createElement("cell");			cell.appendChild(doc.createTextNode(s_itemID));		row.appendChild(cell);
		cell = doc.createElement("cell");			cell.appendChild(doc.createTextNode(""));		row.appendChild(cell);
		cell = doc.createElement("cell");			cell.appendChild(doc.createTextNode(""));		row.appendChild(cell);
		cell = doc.createElement("cell");			cell.appendChild(doc.createTextNode(preChangeSet));		row.appendChild(cell);
		cell = doc.createElement("cell");	
		if(!changeSetID.equals("")) {
			cell.appendChild(doc.createTextNode(StringUtil.checkNull(changeSetID)));
		} else {
			cell.appendChild(doc.createTextNode(StringUtil.checkNull(curChangeSet)));
		}
		row.appendChild(cell);
		
		cell = doc.createElement("cell");
		cell.appendChild(doc.createTextNode("<button type=button class=gridBtn >View</button>"));
		row.appendChild(cell);
		
		setMap.put("releaseNo", preChangeSet);
		setMap.put("changeSetID", changeSetID);
		setMap.put("ModelIDBas", ModelID1);
		setMap.put("ModelIDTobe", ModelID2);
		List elmList = commonService.selectList("model_SQL.getChangeSetModelList_gridList", setMap);
		
		if(!changeSetID.equals("")) curChangeSet = changeSetID;
		
		String RNUM,ClassName,SymbolIconBAS,SymbolName,PlainTextBAS,SymbolIconTOBE,PlainTextTOBE,ChangeMode
		,ObjectID,ElementID1,ElementID2,PreChangeSetID,ChangeSetID,Identifier;
		
		Map elmMap;
		for (int i = 0; i < elmList.size(); i++) {
			row = doc.createElement("row"); 
			rootElement.appendChild(row); 
			
			cell = doc.createElement("cell");
			elmMap = (Map) elmList.get(i);
			RNUM = StringUtil.checkNull(elmMap.get("RNUM"));
			row.setAttribute("id", String.valueOf(RNUM));
			
			ClassName = StringUtil.checkNull(elmMap.get("ClassName"));
			SymbolName = StringUtil.checkNull(elmMap.get("SymbolName"));
			SymbolIconBAS = StringUtil.checkNull(elmMap.get("SymbolIconBAS"));
			PlainTextBAS = StringUtil.checkNull(elmMap.get("PlainTextBAS"));
			SymbolIconTOBE = StringUtil.checkNull(elmMap.get("SymbolIconTOBE"));
			PlainTextTOBE = StringUtil.checkNull(elmMap.get("PlainTextTOBE"));
			ChangeMode = StringUtil.checkNull(elmMap.get("ChangeMode"));
			ObjectID = StringUtil.checkNull(elmMap.get("ObjectID"));
			ElementID1 = StringUtil.checkNull(elmMap.get("BaseElementID"));
			ElementID2 = StringUtil.checkNull(elmMap.get("TobeElementID"));
			PreChangeSetID = StringUtil.checkNull(elmMap.get("PreChangeSetID"));
			ChangeSetID = StringUtil.checkNull(elmMap.get("ChangeSetID"));
			Identifier = StringUtil.checkNull(elmMap.get("Identifier"));

			cell = doc.createElement("cell");		cell.appendChild(doc.createTextNode(ClassName));					cell.setAttribute("class", "className");				row.appendChild(cell);
			cell = doc.createElement("cell");		cell.appendChild(doc.createTextNode(SymbolName));			cell.setAttribute("class", "symbolName");			row.appendChild(cell);
			cell = doc.createElement("cell");		cell.appendChild(doc.createTextNode(Identifier));			row.appendChild(cell);
			
			cell = doc.createElement("cell");	
			if(ChangeMode.equals("Deleted")) cell.setAttribute("style", "text-decoration: line-through; color:red;");
			cell.setAttribute("colspan", "2");
			cell.appendChild(doc.createTextNode("<image src=\"/"+HTML_IMG_DIR_MODEL_SYMBOL+"symbol/"+SymbolIconBAS+"\" class=\"mgR10 mgL5\">"+PlainTextBAS));
			row.appendChild(cell);
			cell = doc.createElement("cell");			cell.appendChild(doc.createTextNode(""));		row.appendChild(cell);
			
			cell = doc.createElement("cell");	
			if(ChangeMode.equals("New")) cell.setAttribute("style", "color:blue;");
			if(ChangeMode.equals("Modified")) cell.setAttribute("style", "font-style:italic;color:green;font-weight: 700;");
			cell.setAttribute("colspan", "2");
			cell.appendChild(doc.createTextNode("<image src=\"/"+HTML_IMG_DIR_MODEL_SYMBOL+"symbol/"+SymbolIconTOBE+"\" class=\"mgR10 mgL5\">"+PlainTextTOBE));
			row.appendChild(cell);
			cell = doc.createElement("cell");			cell.appendChild(doc.createTextNode(""));		row.appendChild(cell);

			cell = doc.createElement("cell");		cell.appendChild(doc.createTextNode(ChangeMode));				row.appendChild(cell);
			cell = doc.createElement("cell");		cell.appendChild(doc.createTextNode(ObjectID));						row.appendChild(cell);
			cell = doc.createElement("cell");		cell.appendChild(doc.createTextNode(ElementID1));					row.appendChild(cell);
			cell = doc.createElement("cell");		cell.appendChild(doc.createTextNode(ElementID2));					row.appendChild(cell);
			cell = doc.createElement("cell");		cell.appendChild(doc.createTextNode(PreChangeSetID));			row.appendChild(cell);
			cell = doc.createElement("cell");		cell.appendChild(doc.createTextNode(ChangeSetID));				row.appendChild(cell);
			cell = doc.createElement("cell");
			if(curChangeSet.equals(ChangeSetID) && !ChangeMode.equals("추가") && !ChangeMode.equals("삭제"))
				cell.appendChild(doc.createTextNode("<button type=button class=gridBtn >View</button>"));
			else
				cell.appendChild(doc.createTextNode(""));
			row.appendChild(cell);
		}
		
		TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
		Transformer transformer = transformerFactory.newTransformer(); 
		
		transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
		transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
		DOMSource source = new DOMSource(doc); 
		
		StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName))); 
		transformer.transform(source, result); 
	}
	
	 @RequestMapping(value="/e2eProcessTreeInfo.do")
		public String e2eProcessTreeInfo(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
			List<Map<String, Object>> elmList = new ArrayList();
			List<Map<String, Object>> list= new ArrayList();
			Map setMap = new HashMap();
			try {
				String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
				String modelID = StringUtil.checkNull(request.getParameter("modelID"), "");
				String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"), "");
				String dimValueID = StringUtil.checkNull(request.getParameter("dimValueID"), "");
				String elmClass = StringUtil.checkNull(request.getParameter("elmClass"), "");
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
								
				setMap.put("s_itemID",  s_itemID);
				setMap.put("languageID", languageID);
				setMap.put("ItemID", s_itemID);
				
				if(modelID.equals("")) {
					setMap.put("MTCategory",  "BAS");
					List baseModel = commonService.selectList("model_SQL.getModelList_gridList", setMap);
					if(baseModel.size() > 0) modelID = StringUtil.checkNull(((Map) baseModel.get(0)).get("ModelID"));
				}
				
				setMap.put("ModelID", modelID);
				Map modelMap = commonService.select("model_SQL.getModelViewer", setMap);
				
				modelMap.put("ItemName", modelMap.get("ModelName")+"("+modelMap.get("MCName")+")");
				modelMap.put("id", "1");
				
				setMap.put("modelID", modelID);
				setMap.put("itemTypeCode", "OJ00001");
				setMap.put("classCode", elmClass);
				elmList = (List) commonService.selectList("model_SQL.getElementItemList_gridList", setMap);
				
				setMap.remove("MTCategory");
				List modelList = (List) commonService.selectList("model_SQL.getModelList_gridList", setMap);
				
				model.put("s_itemID",s_itemID);
				model.put("modelID",modelID);
				model.put("modelList",modelList);
				model.put("dimTypeID",dimTypeID);
				model.put("dimValueID",dimValueID);
				model.put("elmClass",elmClass);
//				model.put("elmTreeXml",setModelTreeXML(modelMap,elmList,languageID,dimTypeID,dimValueID,modelID));
				
				for (Map map : elmList) {
				    map.put("parent", "1");
				    map.put("id", map.get("ElementID"));
				}
				
				for(int i=0; i < elmList.size(); i++) {
					Map newMap =  elmList.get(i);
//			        newMap.put("Name", newMap.get("ItemName"));
			        newMap.put("id", newMap.get("ElementID"));
			        
			        setMap.put("s_itemID", newMap.get("ItemID"));
					setMap.put("dimTypeId",dimTypeID);
					setMap.put("dimValueId",dimValueID);
					
					List itemDimYN = commonService.selectList("dim_SQL.selectDim_gridList", setMap);
					
					if(!dimTypeID.equals("") && itemDimYN.isEmpty()) continue;
					
					list.add(newMap);
					
					setMap.put("gubun", "M");
					setMap.put("getPathYN", "Y");
					List<Map<String, Object>> subItemList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
					
					setMap.remove("mainClassCode");
					setMap.put("cxnTypeCode","CN00007");
					List<Map<String, Object>> ruleList = commonService.selectList("item_SQL.getCxnItemList", setMap);
					if(ruleList.size() > 0) {
						ruleList = ruleList.stream()
							    .map(item -> {
							        Map<String, Object> map = new java.util.HashMap<>(item);
							        
							        map.put("parent", newMap.get("ElementID"));
							        map.put("Path ", map.get("ItemPath"));
							        
							        return map;
						    })
						    .collect(Collectors.toList());
						
						list.addAll(ruleList);
					}
					
					setMap.remove("mainClassCode");
					setMap.put("cxnTypeCode","CN00009");
					List<Map<String, Object>> controlList = commonService.selectList("item_SQL.getCxnItemList", setMap);
					if(controlList.size() > 0) {
						controlList = controlList.stream()
							    .map(item -> {
							        Map<String, Object> map = new java.util.HashMap<>(item);
							        
							        map.put("parent", newMap.get("ElementID"));
							        
							        return map;
						    })
						    .collect(Collectors.toList());
						
						list.addAll(controlList);
					}
					
					if(subItemList.size() > 0) {
						for(int j=0; j<subItemList.size(); j++){
							String programCxnYN = "No";
							Map subItemMap = (HashMap) subItemList.get(j);
							subItemMap.put("id", newMap.get("ElementID") + "-" + subItemMap.get("id"));
							subItemMap.put("parent", newMap.get("ElementID"));
							
							setMap.put("s_itemID", subItemMap.get("ItemID"));
							setMap.put("cxnTypeCode","CN00002");
							setMap.remove("mainClassCode");
							Map roleMap = commonService.select("item_SQL.getCxnItemList", setMap);
							
							setMap.put("cxnTypeCode","CN00004");
							setMap.put("mainClassCode","CL04005");
							List cxnList = commonService.selectList("item_SQL.getCxnItemList", setMap);
							
							if(cxnList.size() > 0) {
								programCxnYN="Yes";
								for(int k=0; k<cxnList.size(); k++){
									Map cxnMap = (HashMap) cxnList.get(k);
									
									setMap.put("itemID", StringUtil.checkNull(cxnMap.get("ItemID"),""));
									setMap.put("itemClassCode", "CL04005");
									List linkList = commonService.selectList("link_SQL.getLinkListFromAttAlloc", setMap);
									String linkUrl = "";
									String lovCode = "";
									String attrTypeCode = "";
									String linkImg = "blank.png";
									
									if(linkList.size() > 0){
										Map linkInfo = (Map)linkList.get(0);
										linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
										lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
										attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
										if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
										
										cxnMap.put("linkUrl", linkUrl);
										cxnMap.put("lovCode", lovCode);
										cxnMap.put("attrTypeCode", attrTypeCode);
									}
									
									cxnMap.put("link", "<img src='"+GlobalVal.HTML_IMG_DIR_ITEM+linkImg+"' style='height:11px'/>");
									cxnMap.put("parent", subItemMap.get("id"));
									cxnMap.put("Path", cxnMap.get("ItemPath"));
									
									list.add(cxnMap);
								}
							}
							
							subItemMap.put("roleName", roleMap.get("ItemName"));
							subItemMap.put("roleID", roleMap.get("ItemID"));
							subItemMap.put("link", programCxnYN);
							
							list.add(subItemMap);
						}
												
					}
				}
				
				list.add(modelMap);
				
				JSONArray treeGridData = new JSONArray(list);
				model.put("treeGridData",treeGridData);
				
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
			}		
			catch (Exception e) {System.out.println(e);throw new ExceptionUtil(e.toString());}		
			return nextUrl("/itm/e2e/e2eProcessTreeInfo");
		}
	 
	 private String setModelTreeXML(Map modelMap,List elmList, String languageID, String dimTypeID, String dimValueID, String modelID) throws Exception {
			Map setMap = new HashMap();
			List subItemList = new ArrayList();
			
			String ModelID= "";
			String ModelName= "";
			String HTML_IMG_DIR_ITEM = GlobalVal.HTML_IMG_DIR_ITEM;
			
			String CELL = "	<cell></cell>";
			String CELL_CHECK = "	<cell>0</cell>";
			String CELL_OPEN = "	<cell>";
			String CELL_CLOSE = "</cell>";
			String CLOSE = ">";
			String CELL_TOT = "";
			String ROW_OPEN = "<row id=";
			String ROW_CLOSE = "</row>";
			
			String programCxnYN = "";
			
			// row ID 를 unique 하게 설정 하기 위한 seq
			String result = "";
			String resultRow = "";
			
			if(modelID.equals("")) {
				result += "<rows>";
				result += "<row id='1' open='1'>";
				result += CELL_CHECK;
				result += "	<cell image='img_sitemap.png' style='font-weight:bold;text-align: left;'> No model exists</cell>";
				result += "</row>";
				result += "</rows>";
			}
			
			if (elmList.size() > 0) {
				ModelID = StringUtil.checkNull(modelMap.get("ModelID"),"");
				ModelName = (StringUtil.checkNull(modelMap.get("ModelName"))).replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ");	
				
				setMap.put("modelID",ModelID);
				setMap.put("languageID", languageID);
				
				result += "<rows>";
				result += "<row id='1' open='1'>";
				result += CELL_CHECK;
				result += "	<cell image='img_sitemap.png' style='font-weight:bold;text-align: left;'> " + ModelName.replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ")
						+"("+modelMap.get("MCName")+")"+ "</cell>";
				
				for (int i = 0; i < elmList.size(); i++){
					Map map = (Map) elmList.get(i);
					String elmID = StringUtil.checkNull(map.get("ItemID"));
					setMap.put("s_itemID",elmID);
					setMap.put("dimTypeId",dimTypeID);
					setMap.put("dimValueId",dimValueID);
					
					List itemDimYN = commonService.selectList("dim_SQL.selectDim_gridList", setMap);
					
					if(!dimTypeID.equals("") && itemDimYN.isEmpty()) continue;
					
					setMap.put("gubun", "M");
					setMap.put("getPathYN", "Y");
					subItemList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);

					setMap.remove("mainClassCode");
					setMap.put("cxnTypeCode","CN00007");
					List ruleList = commonService.selectList("item_SQL.getCxnItemList", setMap);
					
					setMap.remove("mainClassCode");
					setMap.put("cxnTypeCode","CN00009");
					List controlList = commonService.selectList("item_SQL.getCxnItemList", setMap);
					
					resultRow += "<row open='1' id='" + StringUtil.checkNull(map.get("ElementID")) + "' style='background: #eff6ff;'>";
					resultRow += CELL_CHECK;
					resultRow += "<cell image='" + StringUtil.checkNull(map.get("ClassIcon"))+ "'>" + removeAllTag(StringUtil.checkNull(map.get("Identifier")),"") +" "+ removeAllTag(StringUtil.checkNull(map.get("ItemName")),"") + CELL_CLOSE;
					resultRow += CELL_OPEN + StringEscapeUtils.unescapeHtml4(removeAllTag(StringUtil.checkNull(map.get("Path")), "")) + CELL_CLOSE;
					resultRow += CELL;
					resultRow += CELL;
					resultRow += CELL_OPEN +StringUtil.checkNull(map.get("ItemID")) + CELL_CLOSE;
					resultRow += CELL;
					resultRow += CELL;
					resultRow += CELL;
					resultRow += CELL_OPEN +StringUtil.checkNull(map.get("OwnerTeamName")) + CELL_CLOSE;
					resultRow += CELL_OPEN +"<![CDATA["+StringUtil.checkNull(map.get("ItemStatusText")) +" ]]>"+ CELL_CLOSE;
					resultRow += CELL_OPEN +StringUtil.checkNull(map.get("LastUpdated")) + CELL_CLOSE;
					resultRow += CELL_OPEN + "" + CELL_CLOSE;
					resultRow += CELL_OPEN +StringUtil.checkNull(map.get("OwnerTeamID")) + CELL_CLOSE;
					
					for(int j=0; j<ruleList.size(); j++){
						Map ruleMap = (HashMap) ruleList.get(j);
						
						resultRow += "<row open='1'>";
						resultRow += CELL_CHECK;
						resultRow += "<cell image='" + StringUtil.checkNull(ruleMap.get("ClassIcon"))+ "'>" + removeAllTag(StringUtil.checkNull(ruleMap.get("Identifier")),"") +" "+removeAllTag(StringUtil.checkNull(ruleMap.get("ItemName")),"")+ CELL_CLOSE;
						resultRow += CELL_OPEN +StringEscapeUtils.unescapeHtml4(removeAllTag(StringUtil.checkNull(ruleMap.get("ItemPath")), "")) + CELL_CLOSE;
						resultRow += CELL;
						resultRow += CELL;
						resultRow += CELL_OPEN +StringUtil.checkNull(ruleMap.get("ItemID")) + CELL_CLOSE;
						resultRow += CELL;
						resultRow += CELL;
						resultRow += CELL;
						resultRow += CELL_OPEN +StringUtil.checkNull(ruleMap.get("OwnerTeamName")) + CELL_CLOSE;
						resultRow += CELL_OPEN +"<![CDATA["+StringUtil.checkNull(ruleMap.get("ItemStatusText")) +" ]]>"+ CELL_CLOSE;
						resultRow += CELL_OPEN +StringUtil.checkNull(ruleMap.get("LastUpdated")) + CELL_CLOSE;
						resultRow += CELL_OPEN + "" + CELL_CLOSE;
						resultRow += CELL_OPEN +StringUtil.checkNull(ruleMap.get("OwnerTeamID")) + CELL_CLOSE;
						resultRow += ROW_CLOSE;
					}
					
					for(int j=0; j<controlList.size(); j++){
						Map controlMap = (HashMap) controlList.get(j);
						
						resultRow += "<row open='1'>";
						resultRow += CELL_CHECK;
						resultRow += "<cell image='" + StringUtil.checkNull(controlMap.get("ClassIcon"))+ "'>" + removeAllTag(StringUtil.checkNull(controlMap.get("Identifier")),"") +" "+removeAllTag(StringUtil.checkNull(controlMap.get("ItemName")),"")+ CELL_CLOSE;
						resultRow += CELL_OPEN +StringEscapeUtils.unescapeHtml4(removeAllTag(StringUtil.checkNull(controlMap.get("ItemPath")), "")) + CELL_CLOSE;
						resultRow += CELL;
						resultRow += CELL;
						resultRow += CELL_OPEN +StringUtil.checkNull(controlMap.get("ItemID")) + CELL_CLOSE;
						resultRow += CELL;
						resultRow += CELL;
						resultRow += CELL;
						resultRow += CELL_OPEN +StringUtil.checkNull(controlMap.get("OwnerTeamName")) + CELL_CLOSE;
						resultRow += CELL_OPEN +"<![CDATA["+StringUtil.checkNull(controlMap.get("ItemStatusText")) +" ]]>"+ CELL_CLOSE;
						resultRow += CELL_OPEN +StringUtil.checkNull(controlMap.get("LastUpdated")) + CELL_CLOSE;
						resultRow += CELL_OPEN + "" + CELL_CLOSE;
						resultRow += CELL_OPEN +StringUtil.checkNull(controlMap.get("OwnerTeamID")) + CELL_CLOSE;
						resultRow += ROW_CLOSE;
					}
					
					for(int j=0; j<subItemList.size(); j++){
						programCxnYN = "No";
						Map subItemMap = (HashMap) subItemList.get(j);
						
						setMap.put("s_itemID", subItemMap.get("ItemID"));
						setMap.put("cxnTypeCode","CN00002");
						setMap.remove("mainClassCode");
						Map roleMap = commonService.select("item_SQL.getCxnItemList", setMap);
						
						setMap.put("cxnTypeCode","CN00004");
						setMap.put("mainClassCode","CL04005");
						List cxnList = commonService.selectList("item_SQL.getCxnItemList", setMap);
						
						if(cxnList.size() > 0) programCxnYN="Yes";
						resultRow += "<row open='1'>";
						resultRow += CELL_CHECK;
						resultRow += "<cell image='" + StringUtil.checkNull(subItemMap.get("ItemTypeImg"))+ "'>" + removeAllTag(StringUtil.checkNull(subItemMap.get("Identifier")),"") +" "+removeAllTag(StringUtil.checkNull(subItemMap.get("ItemName")),"")+ CELL_CLOSE;
						resultRow += CELL_OPEN +StringEscapeUtils.unescapeHtml4(removeAllTag(StringUtil.checkNull(subItemMap.get("Path")), "")) + CELL_CLOSE;
						resultRow += CELL_OPEN +StringEscapeUtils.unescapeHtml4(removeAllTag(StringUtil.checkNull(roleMap.get("ItemName")), "")) + CELL_CLOSE;
						resultRow += CELL_OPEN +programCxnYN + CELL_CLOSE;
						resultRow += CELL_OPEN +StringUtil.checkNull(subItemMap.get("ItemID")) + CELL_CLOSE;
						resultRow += CELL;
						resultRow += CELL;
						resultRow += CELL;
						resultRow += CELL_OPEN +StringUtil.checkNull(subItemMap.get("OwnerTeamName")) + CELL_CLOSE;
						resultRow += CELL_OPEN +"<![CDATA["+StringUtil.checkNull(subItemMap.get("ItemStatusText")) +" ]]>"+ CELL_CLOSE;
						resultRow += CELL_OPEN +StringUtil.checkNull(subItemMap.get("LastUpdated")) + CELL_CLOSE;
						resultRow += CELL_OPEN +StringUtil.checkNull(roleMap.get("ItemID")) + CELL_CLOSE;
						resultRow += CELL_OPEN +StringUtil.checkNull(subItemMap.get("OwnerTeamID")) + CELL_CLOSE;
						
						for(int k=0; k<cxnList.size(); k++){
							Map cxnMap = (HashMap) cxnList.get(k);
							
							setMap.put("itemID", StringUtil.checkNull(cxnMap.get("ItemID"),""));
							setMap.put("itemClassCode", "CL04005");
							List linkList = commonService.selectList("link_SQL.getLinkListFromAttAlloc", setMap);
							String linkUrl = "";
							String lovCode = "";
							String attrTypeCode = "";
							String linkImg = "blank.png";
							
							if(linkList.size() > 0){
								Map linkInfo = (Map)linkList.get(0);
								linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
								lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
								attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
								if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
							}
							
							resultRow += "<row open='1'>";
							resultRow += CELL_CHECK;
							resultRow +=  "<cell image='" + StringUtil.checkNull(cxnMap.get("ClassIcon"))+ "'>" +removeAllTag(StringUtil.checkNull(cxnMap.get("Identifier")),"") +" "+removeAllTag(StringUtil.checkNull(cxnMap.get("ItemName")),"")+CELL_CLOSE;
							resultRow += CELL_OPEN +StringEscapeUtils.unescapeHtml4(removeAllTag(StringUtil.checkNull(cxnMap.get("ItemPath")), "")) + CELL_CLOSE;
							resultRow += CELL;
							resultRow += CELL_OPEN + "<![CDATA[ <img src='"+HTML_IMG_DIR_ITEM+linkImg +"' /> ]]>" + CELL_CLOSE;
							resultRow += CELL_OPEN +StringUtil.checkNull(cxnMap.get("ItemID")) + CELL_CLOSE;
							resultRow += CELL_OPEN + linkUrl + CELL_CLOSE;
							resultRow += CELL_OPEN + lovCode + CELL_CLOSE;
							resultRow += CELL_OPEN + attrTypeCode +  CELL_CLOSE;
							resultRow += CELL_OPEN +StringUtil.checkNull(cxnMap.get("OwnerTeamName")) + CELL_CLOSE;
							resultRow += CELL_OPEN +"<![CDATA["+StringUtil.checkNull(cxnMap.get("ItemStatusText")) +" ]]>"+ CELL_CLOSE;
							resultRow += CELL_OPEN +StringUtil.checkNull(cxnMap.get("LastUpdated")) + CELL_CLOSE;
							resultRow += CELL_OPEN + "" + CELL_CLOSE;
							resultRow += CELL_OPEN +StringUtil.checkNull(cxnMap.get("OwnerTeamID")) + CELL_CLOSE;
							resultRow += ROW_CLOSE;
						}
						resultRow += ROW_CLOSE;						
					}
					resultRow += ROW_CLOSE;
				}
		
				result += resultRow;
				result += "</row>";
				result += "</rows>";
			}

			setMap.clear();
			setMap.put("AttrTypeCode","AT00001");
			setMap.put("LanguageID",languageID);
			setMap.put("languageID",languageID);
			
			return result.replace("&", "/"); // 특수 문자 제거
		}
	 
	 private String removeAllTag(String str,String type) { 
			if(type.equals("DbToEx")){//201610 new line :: DB To Excel
				str = str.replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn").replaceAll("\r\n", "&&rn").replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&#40;", "(").replaceAll("&#41;", ")").replace("&sect;","-");//20161024 bshyun Test
			}else{
				str = str.replaceAll("\n", "&&rn");//201610 new line :: Excel To DB 
			}
			str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");
			if(type.equals("DbToEx")){
				str = str.replaceAll("&&rn", "\n");
			}
			return StringEscapeUtils.unescapeHtml4(str);
		}
	 
	@RequestMapping(value="/diagramList.do")
	public String diagramList(HttpServletRequest request,  HashMap commandMap, ModelMap model) throws Exception{
		String url = "mdl/diagram/diagramList";
		try{
			HashMap setMap = new HashMap();

			setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			setMap.put("userID", StringUtil.checkNull(commandMap.get("sessionUserId")));
			
			List getDiagramList = commonService.selectList("model_SQL.getDiagramList_gridList", setMap);

			JSONArray gridData = new JSONArray(getDiagramList);
			model.put("gridData", gridData);
			
			model.put("menu", getLabel(request, commonService));	
			model.put("autoSave", StringUtil.checkNull(request.getParameter("autoSave")));
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	 
	@RequestMapping(value="/createDiagram.do")
	public String createDiagram(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try {						
			String s_itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
			Map setMap = new HashMap();
			setMap.put("deactivated", "0");			
			setMap.put("diagramNM", StringUtil.checkNull(request.getParameter("newDiagramName")));
			setMap.put("itemID", StringUtil.checkNull(request.getParameter("itemID")));
			setMap.put("userID", StringUtil.checkNull(commandMap.get("sessionUserId")));
			
			setMap.put("GUBUN","insertDiagram");	
			setMap.put("modelTypeCode", StringUtil.checkNull(request.getParameter("modelTypeCode")));
			String modelXML = StringUtil.checkNull(commonService.selectString("model_SQL.getModelXML", setMap));		
			setMap.put("modelXML", modelXML);
			
			mdItemService.save(setMap);			
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
			target.put(AJAX_SCRIPT, "parent.fnCloseCreateDiagram();parent.urlReload();");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); 
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/deleteDiagram.do")
	public String deleteDiagram(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try {						
			String diagramIDs[] = StringUtil.checkNull(request.getParameter("diagramIDs"),"").split(",");
			Map setMap = new HashMap();
			
			for(int i=0; i<diagramIDs.length; i++) {
				setMap.put("diagramID", diagramIDs[i]);			
				commonService.delete("model_SQL.deleteDiagram", setMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); 
			target.put(AJAX_SCRIPT, "this.urlReload();");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); 
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/elmInfoTabMenu.do")
	public String elmInfoTabMenu(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/mdl/element/elmInfoTabMenu";
	
		Map setMap = new HashMap();
		String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");	
		String modelID = StringUtil.checkNull(request.getParameter("modelID"), "");	
		
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
		model.put("s_itemID", s_itemID);
		model.put("modelID", modelID);
		
		model.put("screenType", StringUtil.checkNull( request.getParameter("screenType"),"") );
		model.put("attrRevYN", StringUtil.checkNull(request.getParameter("attrRevYN"),""));	
		model.put("changeSetID", StringUtil.checkNull(request.getParameter("changeSetID"),""));	
		model.put("mdlFilter", StringUtil.checkNull(request.getParameter("mdlFilter"), ""));
		
		model.put("itemTypeFilter", StringUtil.checkNull(request.getParameter("itemTypeFilter")));
		model.put("dimTypeFilter", StringUtil.checkNull(request.getParameter("dimTypeFilter")));
		model.put("symTypeFilter", StringUtil.checkNull(request.getParameter("symTypeFilter")));
		model.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
		
		String userID = StringUtil.checkNull(String.valueOf(commandMap.get("sessionUserId")), "");
		
		setMap.put("sessionUserId", userID);
		String teamID = commonService.selectString("user_SQL.userTeamID", setMap);
		setMap.put("sessionTeamId", teamID);

		setMap.put("ItemId", s_itemID);
		setMap.put("actionType", StringUtil.checkNull(request.getParameter("actionType"),""));
		String ip = request.getHeader("X-FORWARDED-FOR");
        if (ip == null)
            ip = request.getRemoteAddr();
        setMap.put("IpAddress",ip);
		commonService.insert("gloval_SQL.insertVisitLog", setMap);
		
		return nextUrl(url);
	}
	
	@RequestMapping(value="/modelFilterMenu.do")
	public String modelFilterMenu(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		String url = "/mdl/element/modelFilterMenu";
		model.put("menu", getLabel(request, commonService));	
	
			
		model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
		model.put("modelID", StringUtil.checkNull(request.getParameter("modelID"), ""));
		
		model.put("screenType", StringUtil.checkNull( request.getParameter("screenType"),"") );
		model.put("attrRevYN", StringUtil.checkNull(request.getParameter("attrRevYN"),""));	
		model.put("changeSetID", StringUtil.checkNull(request.getParameter("changeSetID"),""));	
		
		try {	
			String itemTypeFilter[] = StringUtil.checkNull(request.getParameter("itemTypeFilter")).split(",");
			
			String opacityParam = StringUtil.checkNull(request.getParameter("opacityList"));
			String[] opacityList = StringUtil.checkNull(request.getParameter("opacityList")).split(",");
			
			if (opacityParam.isEmpty()) {
				if (itemTypeFilter.length > 0 && !itemTypeFilter[0].isEmpty()) {
				    opacityList = new String[itemTypeFilter.length];
				   
				    for (int i = 0; i < itemTypeFilter.length; i++) {
			            if ("OJ00004".equals(itemTypeFilter[i])) {
			                opacityList[i] = "20";
			            } else {
			                opacityList[i] = "100";
			            }
			        }
				}
			} 
			
			StringBuilder itemTypeCodeParamList = new StringBuilder();
			List itemTypeCodeList = new ArrayList();
			if(!StringUtil.checkNull(request.getParameter("itemTypeFilter")).equals("")) {
				for(int i=0; i<itemTypeFilter.length; i++) {
					if(i > 0) { itemTypeCodeParamList.append(","); }
					itemTypeCodeParamList.append("'"+itemTypeFilter[i]+"'");
				}
				Map setData = new HashMap();
				cmmMap.put("itemTypeCodeList", itemTypeCodeParamList.toString());
				itemTypeCodeList = commonService.selectList("analysis_SQL.getItemTypeCodeWithCategory", cmmMap);
				for(int z=0; z < itemTypeCodeList.size(); z++) {
					Map itemTypeMap = (Map)itemTypeCodeList.get(z);
					itemTypeMap.put("checked", "Y");
					itemTypeMap.put("opacity", opacityList[z]);
				}
			}
					
			List dimTypeList = new ArrayList();
			String dimTypeFilter[] = StringUtil.checkNull(request.getParameter("dimTypeFilter")).split(",");
			StringBuilder dimTypeParamList = new StringBuilder();
			if(!StringUtil.checkNull(request.getParameter("dimTypeFilter")).equals("")) {
				for(int i=0; i<dimTypeFilter.length; i++) {
					if(i > 0) { dimTypeParamList.append(","); }
					dimTypeParamList.append("'"+dimTypeFilter[i]+"'");
				}
				Map setData = new HashMap();
				cmmMap.put("dimTypeIDList", dimTypeParamList.toString());
				dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", cmmMap);
				if(dimTypeList.size() > 0) {
					for(int i=0; i< dimTypeList.size(); i++) {
						Map dimTypeMap = (Map)dimTypeList.get(i);
						cmmMap.put("dimTypeID", dimTypeMap.get("DimTypeID"));
						dimTypeMap.put("dimValueList", commonService.selectList("dim_SQL.getSelectDimList", cmmMap)); 	
					}
				}
			}
			
			List symTypeList = new ArrayList();
			String symTypeFilter[] = StringUtil.checkNull(request.getParameter("symTypeFilter")).split(",");
			StringBuilder symTypeCodeList = new StringBuilder();
			if(!StringUtil.checkNull(request.getParameter("symTypeFilter")).equals("")) {
				for(int i=0; i<symTypeFilter.length; i++) {
					if(i > 0) { symTypeCodeList.append(","); }
					symTypeCodeList.append("'"+symTypeFilter[i]+"'");
				}
				cmmMap.put("modelTypeCode", "MT001");
				cmmMap.put("symTypeCodeList", symTypeCodeList.toString());
				symTypeList = commonService.selectList("model_SQL.getSymbolTypeList", cmmMap);	
				
			}
			
			model.put("itemTypeCodeList", itemTypeCodeList);
			model.put("dimTypeList", dimTypeList);
			
			JSONArray dimTypeListJson = new JSONArray(dimTypeList);
			model.put("dimTypeListJson", dimTypeListJson);
			
			model.put("symTypeList", symTypeList);
		}
		catch (Exception e) {
			System.out.println(e);
		}
		
		return nextUrl(url);
	}
	
	@RequestMapping(value="/modelXmlExport.do")
	public String modelXmlExport(HttpServletRequest request, HashMap commandMap ,ModelMap model, HttpServletResponse response) throws Exception{
		Map target = new HashMap();
		HashMap setMap = new HashMap();

		String modelID = StringUtil.checkNull(request.getParameter("modelID"),"");
		String modelName = StringUtil.checkNull(request.getParameter("modelName"),"model");
		setMap.put("s_itemID", modelID);
		setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"),""));

		List getModelInfo = commonService.selectList("model_SQL.selectModelInfo", setMap);
		
		String modelXML = "";
		
		if (!getModelInfo.isEmpty()) {
		    Map<String, Object> modelXmlValue = (Map<String, Object>) getModelInfo.get(0);
		    modelXML = (String) modelXmlValue.get("ModelXML");
		}
		
		Calendar cal = Calendar.getInstance();
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
		java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("HHmmssSSS");
		String sdate = sdf.format(cal.getTime());
		String stime = sdf2.format(cal.getTime());
		String mkFileNm = sdate+stime;
		
	 	String filePath = GlobalVal.FILE_EXPORT_DIR;
	 	String fileName = modelName+"_"+mkFileNm+".xml";
	 	String xmlFile = filePath + modelID;
        
	 	try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(xmlFile), "UTF-8"))) {
            writer.write(modelXML);
        	
            System.out.println("XML 파일이 성공적으로 저장되었습니다: " + xmlFile);

            target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
            target.put(AJAX_SCRIPT, "parent.fnGoModelInfo('view');");
        } catch (Exception e) {
            System.err.println("파일 저장 중 오류 발생: " + e.getMessage());
        }
		request.setAttribute("downFile", xmlFile); 
		request.setAttribute("orginFile", fileName);
		
		FileUtil.downFile(request, response);
        
		  //String downFile = xmlFile;

		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/modelXmlImport.do")
	public String modelXmlImport(MultipartHttpServletRequest request, HashMap commandMap ,ModelMap model) throws Exception{
		Map target = new HashMap();

		XSSRequestWrapper xss = new XSSRequestWrapper(request);
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		Iterator<String> fileNameIter = multipartRequest.getFileNames();
		String savePath = GlobalVal.FILE_UPLOAD_TMP_DIR.replace("\\", "//");
		String filePath = "";
		String fileName = "";

		if (fileNameIter.hasNext()) {
		    // 하나의 파일만 처리
		    String fileParamName = fileNameIter.next(); // 파일 파라미터 이름
		    MultipartFile mFile = multipartRequest.getFile(fileParamName);
		    fileName = mFile.getOriginalFilename();
		    if (mFile.getSize() > 0) {
		        String ext = FileUtil.getExt(fileName);
		        
		        HashMap resultMap = FileUtil.uploadFile(mFile, savePath, true);
		        fileName = (String) resultMap.get("SysFileNm");
		        filePath = (String) resultMap.get("FilePath");
		       		    }
		}
		HashMap setMap = new HashMap();
		
		String modelID = StringUtil.checkNull(request.getParameter("modelID"),"");
	 	String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"),"");
		
	 	String xmlFile = filePath+fileName; 
		File modelXmlFile = new File(xmlFile);
		StringBuilder xmlContent = new StringBuilder();
		
		try (BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(modelXmlFile), "UTF-8"))) {
			 String firstLine = br.readLine();
			    if (firstLine != null && firstLine.trim().startsWith("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")) {
			        // 첫 번째 줄이 XML 선언이라면, 그 줄을 건너뛰고 3줄을 건너뛰고 나머지 줄 읽기
			        br.lines()
			          .skip(2)  // 처음 3줄을 건너뜀 (Draw.io -> ModelXML 불필요한 문구 삭제)
			          .forEach(line -> xmlContent.append(line));  // 모든 줄을 하나의 문자열로 합침
			    } else {

			        xmlContent.append(firstLine);  // 첫 번째 줄도 xmlContent에 추가
			        br.lines().forEach(line -> xmlContent.append(line));  // 그 뒤의 모든 줄을 합침
			    }

		} catch (IOException e) { 
			e.printStackTrace();
		}
		
		// DOM 객체 사이 공백 제거 & 위에서 3줄 건너뛴 DOM 객체 삭제
		String formattedXml = xmlContent.toString().replaceAll(">\\s*", ">").replaceAll("\\s*<", "<").replace("</diagram></mxfile>", "");
		
		setMap.put("s_itemID", modelID);
		setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"),""));

		List getModelInfo = commonService.selectList("model_SQL.selectModelInfo", setMap);
		
		String modelName = "";
		String modelDesc = "";
		String itemID = "";
		String modelTypeName = "";
		String modelCat = "";
		String modelTypeCode = "";
		
		if (!getModelInfo.isEmpty()) {
		    Map<String, Object> modelXmlValue = (Map<String, Object>) getModelInfo.get(0);
		    modelName = (String) modelXmlValue.get("Name");
		    modelDesc = (String) modelXmlValue.get("Description");
		    itemID = String.valueOf(modelXmlValue.get("ItemID"));
		    modelTypeName = (String) modelXmlValue.get("ModelTypeName");
		    modelCat = (String) modelXmlValue.get("MTCategory");
		    modelTypeCode = (String) modelXmlValue.get("ModelTypeCode");
		}
		
		setMap.put("Name", modelName);		
		setMap.put("ModelID", modelID);		
		setMap.put("LanguageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"),""));
		setMap.put("Description", modelDesc);		
		setMap.put("ModelXML", formattedXml);		
		setMap.put("lastUser", commandMap.get("sessionUserId"));		
		commonService.update("model_SQL.updateModelXML", setMap);
		
        target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
        target.put(AJAX_SCRIPT, "parent.fnGoModelInfo('view');");
        
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
}

