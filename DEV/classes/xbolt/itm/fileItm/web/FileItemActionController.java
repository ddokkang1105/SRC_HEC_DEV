package xbolt.itm.fileItm.web;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.org.json.JSONArray;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;
import xbolt.file.web.FileMgtActionController;
import xbolt.itm.str.web.StructureActionController;



/**
 * 업무 처리
 * @Class Name : FileItemActionController.java
 * @Description : 업무화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2012. 09. 01. smartfactory		최초생성
 *
 * @since 2022. 04. 19.
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")
public class FileItemActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "structureActionController")
	private StructureActionController strActionController;
	
	@Resource(name = "CSService")
	private CommonService CSService;
	
	@Resource(name = "fileMgtActionController")
	private FileMgtActionController fileMgtActionController;
	
	@RequestMapping(value="/fileItemList.do")
	public String fileItemList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {		
		try {
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			HashMap setData = new HashMap();	
			HashMap setMap = new HashMap();
			
			String s_itemID = StringUtil.checkNull(commandMap.get("itemID"),"");
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
			String srType = StringUtil.checkNull(commandMap.get("srType"),"");
			String showElement = StringUtil.checkNull(commandMap.get("showElement"),"");
			String accMode = StringUtil.checkNull(commandMap.get("accMode"),"");
			String currIdx = StringUtil.checkNull(commandMap.get("currIdx"),"");
			String showPreNextIcon = StringUtil.checkNull(commandMap.get("showPreNextIcon"),"");
			String tLink = StringUtil.checkNull(commandMap.get("tLink"),"");
			
			List itemPath = new ArrayList();
			itemPath = strActionController.getRootItemPath(s_itemID,languageID,itemPath);
			Collections.reverse(itemPath);
			model.put("itemPath",itemPath);
			
			setMap.put("languageID", languageID);
			setMap.put("s_itemID", s_itemID);			
			Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
			
			String parentItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getParentItemID", setMap));
			model.put("parentItemID", parentItemID);
			
//			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
//			String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));
//			if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(sessionUserId) 
//					|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(sessionUserId)
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);
						
			String changeSetID = "";
			if(accMode.equals("OPS")) {
				changeSetID = StringUtil.checkNull(itemInfo.get("ReleaseNo"));
				setMap.put("changeSetID",changeSetID);
				Map prcList = commonService.select("item_SQL.getItemAttrRevInfo", setMap);
				prcList.put("Blocked",itemInfo.get("Blocked"));
				prcList.put("ChangeMgt",itemInfo.get("ChangeMgt"));
				prcList.put("SubscrOption",itemInfo.get("SubscrOption"));
				prcList.put("CheckInOption",itemInfo.get("CheckInOption"));
				prcList.put("CheckOutOption",itemInfo.get("CheckOutOption"));
				prcList.put("Status",itemInfo.get("Status"));
				model.put("itemInfo", prcList);	
			} else {
				model.put("itemInfo", itemInfo);
			}
											
			model.put("s_itemID", s_itemID);
			model.put("itemID", s_itemID);
			model.put("id", s_itemID);
						
			model.put("srType", srType);
			model.put("showElement", showElement);
			model.put("currIdx",currIdx);
			model.put("showPreNextIcon",showPreNextIcon);
			model.put("showTOJ", StringUtil.checkNull(commandMap.get("showTOJ")));
			model.put("showVAR", StringUtil.checkNull(commandMap.get("showVAR")));
			model.put("accMode", accMode);
			model.put("tLink", tLink);
			
			//////////////////////////////////  ITEM CLASS MENU DATA 조회 END  ///////////////////////////////////////////////////////////////////
			model.put("option", request.getParameter("arcCode"));	
			model.put("arcCode", request.getParameter("arcCode"));
			
			setData.put("SelectMenuId", request.getParameter("option"));
			model.put("filterType", commonService.selectString("menu_SQL.selectArcFilter", setData));
			model.put("TreeDataFiltered", commonService.selectString("menu_SQL.selectArcTreeDataFiltered", setData));
			
			// pop up 창에서 편집 버튼 제어 용
			model.put("pop", StringUtil.checkNull(request.getParameter("pop"),""));			
			setData = new HashMap();
			setData.put("arcCode", StringUtil.checkNull(request.getParameter("option")));	
			model.put("sortOption", StringUtil.checkNull(commonService.selectString("menu_SQL.getArcSortOption", setData)));
			
			setData = new HashMap();
			setData.put("s_itemID", s_itemID);
			model.put("itemTypeCode", commonService.selectString("item_SQL.getItemTypeCode", setData));
			
			setData.put("s_itemID", s_itemID);
			setData.put("languageID", languageID);
			setData.put("option", StringUtil.checkNull(request.getParameter("option")));	
			setData.put("filterType", StringUtil.checkNull(request.getParameter("filterType")));	
			setData.put("TreeDataFiltered", StringUtil.checkNull(request.getParameter("filterType")));	
			setData.put("defDimTypeID", StringUtil.checkNull(request.getParameter("defDimTypeID")));	
			setData.put("defDimValueID", StringUtil.checkNull(request.getParameter("defDimValueID")));	
			setData.put("searchKey", StringUtil.checkNull(request.getParameter("searchKey")));	
			setData.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));	
			setData.put("showTOJ", StringUtil.checkNull(request.getParameter("showTOJ")));	
			setData.put("showElement", StringUtil.checkNull(request.getParameter("showElement")));	
			setData.put("showID", StringUtil.checkNull(request.getParameter("showID")));	
			setData.put("sortFilter", "Y");
			
			setData.put("ownerType", StringUtil.checkNull(request.getParameter("ownerType")));	
			setData.put("roleType", StringUtil.checkNull(request.getParameter("roleType")));
			setData.put("sessionUserId", commandMap.get("sessionUserId"));
			
			String childItems = "";
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			String childLevel = "1";
			String itemTypeCode =  StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCode", setMap));
			childItems = getChildItemList(s_itemID, childLevel, itemTypeCode);
		//	setData.put("childItems", childItems);
						
			List fileItemList = commonService.selectList("item_SQL.getSubItemList_gridList", setData);
			
			model.put("fileItemList", fileItemList);			
			JSONArray fileItemJSONList = new JSONArray(fileItemList);
			model.put("fileItemListData", fileItemJSONList);
			model.put("totalCnt", fileItemList.size());
			
			String fileItemIDs = "";
			if(fileItemList.size() > 0 ) {
				for(int i=0; i<fileItemList.size(); i++) {
					Map fileItemMap = (Map)fileItemList.get(i);
					if(i == 0) {
						fileItemIDs = StringUtil.checkNull(fileItemMap.get("ItemID"));
					} else {
						fileItemIDs += "," + StringUtil.checkNull(fileItemMap.get("ItemID"));
					}
				}
			}
			model.put("fileItemIDs", fileItemIDs);
			model.put("showID", StringUtil.checkNull(commandMap.get("showID")));
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/itm/fileItm/fileItemList");
	}
	
	private String getChildItemList(String s_itemID, String childLevel, String itemTypeCode) throws ExceptionUtil {
		String outPutItems = "";
		List delItemIdList = new ArrayList();
		List list = new ArrayList();
		Map map = new HashMap();
		Map setMap = new HashMap();
			try {
			String itemId = s_itemID;
			setMap.put("ItemID", itemId);
			//delItemIdList.add(itemId);
			
			// 취득한 아이템 리스트 사이즈가 0이면 while문을 빠져나간다.
			int j = 1;			
			int idx = 1;
			int childLevelInt = 15;
			if(!childLevel.equals("")) {
				childLevelInt = Integer.parseInt(childLevel);
			}
			while (j != 0 && idx <= childLevelInt) { 
				String toItemId = "";
				
				setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
				setMap.put("CategoryCode", "ST1");
				setMap.put("itemTypeCode", itemTypeCode);
				list = commonService.selectList("report_SQL.getChildItems", setMap);
				j = list.size(); 
				if(!childLevel.equals("")) idx ++;
				
				for (int k = 0; list.size() > k; k++) {
					 map = (Map) list.get(k);
					 setMap.put("ItemID", map.get("ToItemID"));
					 delItemIdList.add(map.get("ToItemID"));
					 
					 if (k == 0) {
						 toItemId = "'" + String.valueOf(map.get("ToItemID")) + "'";
					 } else {
						 toItemId = toItemId + ",'" + String.valueOf(map.get("ToItemID")) + "'";
					 }
				}
				
				itemId = toItemId; // ToItemID를 다음 ItemID로 설정
			}
			
			outPutItems = "";
			for (int i = 0; delItemIdList.size() > i ; i++) {
				
				if (outPutItems.isEmpty()) {
					outPutItems += delItemIdList.get(i);
				} else {
					outPutItems += "," + delItemIdList.get(i);
				}
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		
		return outPutItems;
	}
	
	@RequestMapping(value="/getFileItemList.do")
	public void getFileItemList(HttpServletRequest request, HashMap commandMap, HttpServletResponse res) throws Exception {		
		try {
			String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"),"");
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String searchValueAT00001 = StringUtil.checkNull(request.getParameter("searchValueAT00001"));
			String searchValueText = StringUtil.checkNull(request.getParameter("searchValueText"));
			String status = StringUtil.checkNull(request.getParameter("status"));
			String teamName = StringUtil.checkNull(request.getParameter("teamName"));
			String authorName = StringUtil.checkNull(request.getParameter("authorName"));
			String startDT = StringUtil.checkNull(request.getParameter("startDT"));
			String endDT = StringUtil.checkNull(request.getParameter("endDT"));
			String CategoryCode = StringUtil.checkNull(request.getParameter("CategoryCode"));
			
			Map setData = new HashMap();			
			setData.put("s_itemID", s_itemID);
			setData.put("languageID", languageID);
			setData.put("Status", status);	
			setData.put("OwnerTeam", teamName);	
			setData.put("Name", authorName);	
			setData.put("LastUpdated", startDT);
			setData.put("scStartDt2", startDT);
			setData.put("scEndDt2", endDT);			
			setData.put("sessionUserId", commandMap.get("sessionUserId"));
			
			String childItems = "";
			Map setMap = new HashMap();
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			String childLevel = StringUtil.checkNull(request.getParameter("childLevel"));
			
			String itemTypeCode =  StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCode", setMap));
			setData.put("ItemTypeCode", itemTypeCode);
			
			childItems = getChildItemList(s_itemID, childLevel, itemTypeCode);
			setData.put("childItems", childItems);
			List AttrCode = new ArrayList();
			Map attrMap = new HashMap();
			
			if(!searchValueAT00001.equals("")) {
				attrMap.put("attrCode", "AT00001");
				attrMap.put("searchValue", searchValueAT00001.replaceAll("comma", ","));
				attrMap.put("selectOption", "AND");			
				AttrCode.add(attrMap);
			}
			setData.put("AttrCode", AttrCode);
			setData.put("searchValueText", searchValueText.replaceAll("comma", ",")); 
			setData.put("showID", StringUtil.checkNull(request.getParameter("showID")));
			setData.put("CategoryCode", CategoryCode);
			List fileItemList = new ArrayList();
			if(!childItems.equals("")) { 
				fileItemList = commonService.selectList("search_SQL.getSearchMultiList_gridList", setData);
			}
						
			JSONArray fileItemJSONList = new JSONArray(fileItemList);		
			
			res.setHeader("Cache-Control", "no-cache");
			res.setContentType("text/plain");
			res.setCharacterEncoding("UTF-8");
			if(!StringUtil.checkNull(fileItemJSONList).equals("")){
				res.getWriter().print(fileItemJSONList);
			}
			else {
				PrintWriter pw = res.getWriter();
				pw.write("데이터가 존재하지 않습니다.");
			}			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
	
	@RequestMapping(value = "/viewFileItem.do")
	public String viewFileItem(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "itm/fileItm/viewFileItem";
		try {			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("itemID", StringUtil.checkNull(request.getParameter("itemID")));
			String autoID = StringUtil.checkNull(request.getParameter("autoID"));
			
			Map setMap = new HashMap();
			setMap.put("s_itemID", StringUtil.checkNull(request.getParameter("itemID")));
			setMap.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			
			Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);			 
			model.put("itemInfo", itemInfo);
			model.put("classCode", StringUtil.checkNull(request.getParameter("classCode")));
			
//			String sessionAuthLev = String.valueOf(cmmMap.get("sessionAuthLev")); // 시스템 관리자
//			String sessionUserId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
//			if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(sessionUserId) 
//					|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(sessionUserId)
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			model.put("myItem", myItem);
			
			Map setData = new HashMap();
			
			setData.put("s_itemID", StringUtil.checkNull(request.getParameter("itemID")));
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			setData.put("Editable", "1");
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", cmmMap);
			setData.put("defaultLang", defaultLang);
			setData.put("classCode", StringUtil.checkNull(request.getParameter("classCode")));
			setData.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
			
			List attrList = (List)commonService.selectList("attr_SQL.getItemAttrMain", setData);
			String columnNum2YN = "N"; 
			if(attrList.size() > 0){
				for(int i=0; attrList.size() > i; i++){
					Map attrListMap = (Map)attrList.get(i);
					if(!StringUtil.checkNull(attrListMap.get("AttrTypeCode2")).equals("") && StringUtil.checkNull(attrListMap.get("ColumnNum2")).equals("2") ){
						columnNum2YN = "Y";
					}
				}
			}

			model.put("columnNum2YN", columnNum2YN);
			// get ITEM ATTR (각 속성에 따른 언어 설정(IsComLang)에 따른 data 취득)
			List itemAttrList = GetItemAttrList.getItemAttrList2(commonService, attrList, setData, StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			
			String dataType = "";
			String dataType2 = "";
			setData = new HashMap();
			
			String plainText = "";			
			for(int i=0; i<itemAttrList.size(); i++){
				Map attrTypeMap = (HashMap)itemAttrList.get(i);
				dataType = StringUtil.checkNull(attrTypeMap.get("DataType"));
				dataType2 = StringUtil.checkNull(attrTypeMap.get("DataType2"));
				if(dataType.equals("MLOV")){					
					plainText = getMLovVlaue(StringUtil.checkNull(cmmMap.get("sessionCurrLangType")) , StringUtil.checkNull(cmmMap.get("itemID")), StringUtil.checkNull(attrTypeMap.get("AttrTypeCode")));
					attrTypeMap.put("PlainText", plainText);
				}
				
				if(dataType2.equals("MLOV")){
					plainText = getMLovVlaue(StringUtil.checkNull(cmmMap.get("sessionCurrLangType")) , StringUtil.checkNull(cmmMap.get("itemID")), StringUtil.checkNull(attrTypeMap.get("AttrTypeCode2")));
					attrTypeMap.put("PlainText2", plainText);
				}
			}
			
			model.put("attributesList", itemAttrList);
			
			// 첨부문서 취득
			cmmMap.put("DocumentID", StringUtil.checkNull(request.getParameter("itemID")));
			cmmMap.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			cmmMap.put("isPublic", "N");
			cmmMap.put("DocCategory", "ITM");
			/*
			 * cmmMap.put("hideBlocked", hideBlocked);
			 * 
			 * if(!hideBlocked.equals("Y")) { cmmMap.put("changeSetID",changeSetID); }
			 */
			cmmMap.put("s_itemID", cmmMap.get("itemID"));
			List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", cmmMap);
			for(int i=0; i<attachFileList.size(); i++){
				Map getFilesize = (Map)attachFileList.get(i);
				int fileSize = Integer.parseInt(String.valueOf(getFilesize.get("FileSize")));
				String FileSize = getFileSize(fileSize);
				getFilesize.put("FileSize",FileSize);
				attachFileList.remove(i);
				attachFileList.add(i,getFilesize);
			}
			model.put("attachFileList", attachFileList);
			
			/** Dimension정보 취득 */
			List dimInfoList = commonService.selectList("dim_SQL.selectDim_gridList", setMap);
			List dimResultList = new ArrayList();
			Map dimResultMap = new HashMap();
			String dimTypeName = "";
			String dimValueNames = "";
			for(int i = 0; i < dimInfoList.size(); i++){
				Map map = (HashMap)dimInfoList.get(i);				
				if (i > 0) {
					if(dimTypeName.equals(map.get("DimTypeName").toString())) {
						dimValueNames += " / "+map.get("DimValuePath").toString();
					} else {
						dimResultMap.put("dimValueNames", dimValueNames);
						dimResultList.add(dimResultMap);
						dimResultMap = new HashMap(); // 초기화
						dimTypeName = map.get("DimTypeName").toString();
						dimResultMap.put("dimTypeName", dimTypeName);
						dimValueNames = map.get("DimValuePath").toString();
					}
				}else{
					dimTypeName = map.get("DimTypeName").toString();
					dimResultMap.put("dimTypeName", dimTypeName);
					dimValueNames = map.get("DimValuePath").toString();
				}
			}
			
			if (dimInfoList.size() > 0) {
				dimResultMap.put("dimValueNames", dimValueNames);
				dimResultList.add(dimResultMap);
			}
			
			model.put("dimResultList", dimResultList);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/editFileItem.do")
	public String editFileItem(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "itm/fileItm/editFileItem";
		try {			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			String classCode = StringUtil.checkNull(request.getParameter("classCode"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			
			model.put("s_itemID", s_itemID);
			model.put("itemID", itemID);
			model.put("classCode", classCode);
			Map setMap = new HashMap();
			setMap.put("s_itemID", itemID);
			setMap.put("languageID", languageID);
			
			Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);			 
			model.put("itemInfo", itemInfo);
			
//			String sessionAuthLev = String.valueOf(cmmMap.get("sessionAuthLev")); // 시스템 관리자
//			String sessionUserId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
//			if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(sessionUserId) 
//					|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(sessionUserId)
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			model.put("myItem", myItem);
			
			// 첨부문서 취득
			cmmMap.put("DocumentID", itemID);
			cmmMap.put("languageID", languageID);
			cmmMap.put("isPublic", "N");
			cmmMap.put("DocCategory", "ITM");
			/*
			 * cmmMap.put("hideBlocked", hideBlocked);
			 * 
			 * if(!hideBlocked.equals("Y")) { cmmMap.put("changeSetID",changeSetID); }
			 */
			List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", cmmMap);
			for(int i=0; i<attachFileList.size(); i++){
				Map getFilesize = (Map)attachFileList.get(i);
				int fileSize = Integer.parseInt(String.valueOf(getFilesize.get("FileSize")));
				String FileSize = getFileSize(fileSize);
				getFilesize.put("FileSize",FileSize);
				attachFileList.remove(i);
				attachFileList.add(i,getFilesize);
			}
			model.put("attachFileList", attachFileList);
			 
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/editFileItemAttrFrame.do")
	public String editFileItemAttrFrame(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "itm/fileItm/editFileItemAttrFrame";
		try {			
			String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));
			String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));

			model.put("s_itemID", s_itemID);
			model.put("itemID", itemID);
			model.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
			model.put("pop", StringUtil.checkNull(request.getParameter("pop")));
			
			Map setData = new HashMap();
			
			setData.put("s_itemID", itemID);
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			setData.put("Editable", "1");
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", cmmMap);
			setData.put("defaultLang", defaultLang);
			setData.put("classCode", StringUtil.checkNull(request.getParameter("classCode")));
			setData.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
			
			List attrList = (List)commonService.selectList("attr_SQL.getItemAttrMain", setData);
			String columnNum2YN = "N"; 
			if(attrList.size() > 0){
				for(int i=0; attrList.size() > i; i++){
					Map attrListMap = (Map)attrList.get(i);
					if(!StringUtil.checkNull(attrListMap.get("AttrTypeCode2")).equals("") && StringUtil.checkNull(attrListMap.get("ColumnNum2")).equals("2") ){
						columnNum2YN = "Y";
					}
				}
			}
			model.put("columnNum2YN", columnNum2YN);
			// get ITEM ATTR (각 속성에 따른 언어 설정(IsComLang)에 따른 data 취득)
			List itemAttrList = GetItemAttrList.getItemAttrList2(commonService, attrList, setData, languageID);
			
			String dataType = "";
			String dataType2 = "";
			setData = new HashMap();
			
			String plainText = "";			
			for(int i=0; i<itemAttrList.size(); i++){
				Map attrTypeMap = (HashMap)itemAttrList.get(i);
				dataType = StringUtil.checkNull(attrTypeMap.get("DataType"));
				dataType2 = StringUtil.checkNull(attrTypeMap.get("DataType2"));
				if(dataType.equals("MLOV")){					
					plainText = getMLovVlaue(StringUtil.checkNull(cmmMap.get("sessionCurrLangType")) , itemID, StringUtil.checkNull(attrTypeMap.get("AttrTypeCode")));
					attrTypeMap.put("PlainText", plainText);
				}
				
				if(dataType2.equals("MLOV")){
					plainText = getMLovVlaue(StringUtil.checkNull(cmmMap.get("sessionCurrLangType")) , itemID, StringUtil.checkNull(attrTypeMap.get("AttrTypeCode2")));
					attrTypeMap.put("PlainText2", plainText);
				}
			}
			model.put("attributesList", itemAttrList);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	// byte 용량을 환산하여 반환
	private String getFileSize(double fileSize){
		String str="";
		
		//GB 단위 이상일때 GB 단위로 환산
		if (fileSize >= 1024 * 1024 * 1024) {
			 fileSize = fileSize / (1024.0 * 1024.0 * 1024.0);
			 str = Math.floor(fileSize*100)/100.0 + "GB";
		}
		 //MB 단위 이상일때 MB 단위로 환산
		else if (fileSize >= 1024 * 1024) {
	        fileSize = fileSize / (1024.0 * 1024.0);
	        str = Math.floor(fileSize*100)/100.0 + "MB";
	    }
	    //KB 단위 이상일때 KB 단위로 환산
	    else if (fileSize >= 1024) {
	        fileSize = fileSize / 1024;
	        str = Math.round(fileSize) + "KB";
	    }
	    //KB 단위보다 작을때 byte 단위로 환산
	    else {
	        str = "1KB";
	    }
	    return str;
	}
	
	private String getMLovVlaue(String languageID, String itemID, String attrTypeCode) throws ExceptionUtil {
		List mLovList = new ArrayList();
		Map setMap = new HashMap();
		String plainText = "";
		try {
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			setMap.put("languageID", languageID);
			setMap.put("defaultLang", defaultLang);			
			setMap.put("itemID", itemID);
			setMap.put("attrTypeCode", attrTypeCode);
			mLovList = commonService.selectList("attr_SQL.getMLovList",setMap);
			if(mLovList.size() > 0){
				for(int j=0; j<mLovList.size(); j++){
					Map mLovListMap = (HashMap)mLovList.get(j);
					if(j==0){
						plainText = StringUtil.checkNull(mLovListMap.get("Value"));
					}else {
						plainText = plainText + " / " + mLovListMap.get("Value") ;
					}
				}
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		return plainText;
	}
	

	@RequestMapping(value="/saveItemMst.do")
	public String saveItemMst(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{
			
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			String identifier = StringUtil.checkNull(request.getParameter("identifier"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String classCode = StringUtil.checkNull(request.getParameter("classCode"));
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
			String csrID = StringUtil.checkNull(request.getParameter("csrID"));
			String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			
			Map setMap = new HashMap();			
			
			setMap.put("ProjectID", csrID);		
			setMap.put("Identifier", identifier);
			setMap.put("ClassCode", classCode);
			setMap.put("LastUser", sessionUserID);
			setMap.put("ItemID", itemID);
			
			commonService.update("item_SQL.updateItemObjectInfo",setMap);	// update Item Info
			
			
			setMap.put("languageID", languageID);	
			setMap.put("AttrTypeCode", "AT00001");
			setMap.put("PlainText", StringUtil.checkNull(request.getParameter("itemName")));	
			String setInfo = GetItemAttrList.attrUpdate(commonService, setMap);	// update 명칭 
			
			
			
			
			// Dimension 생성 TB_ITEM_CLASS HasDimension = 1 
			String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
			String dimTypeValueID = StringUtil.checkNull(request.getParameter("dimTypeValueID"));
			if(!dimTypeID.equals("") && !dimTypeValueID.equals("")){					
				Map setData = new HashMap();
				setData.put("ItemTypeCode", itemTypeCode);
				setData.put("ItemClassCode", classCode);
				setData.put("ItemID",itemID);
				setData.put("itemID",itemID);
				setData.put("DimTypeID", dimTypeID);
				setData.put("DimValueID", dimTypeValueID);				
				String itemDimCNT = StringUtil.checkNull(commonService.selectString("dim_SQL.getCNTItemDim", setData));
				if(itemDimCNT.equals("0")) {
					commonService.update("dim_SQL.insertItemDim", setData);
				}
			}
			
			List returnData = new ArrayList();
			setMap = new HashMap();
			setMap.put("Editable", "1");
			setMap.put("classCode", classCode);
			setMap.put("languageID", languageID);
			setMap.put("defaultLang", commandMap.get("sessionDefLanguageId"));
			setMap.put("s_itemId", itemID);
			returnData = (List)commonService.selectList("attr_SQL.getItemAttr", setMap);
			
			setMap = new HashMap();
			String dataType = "";
			String mLovValue = "";
			String html = "";
			for(int i = 0; i < returnData.size() ; i++){				
				setMap = (HashMap)returnData.get(i);
				dataType = StringUtil.checkNull(setMap.get("DataType"));
				html = StringUtil.checkNull(setMap.get("HTML"));
				if(!dataType.equals("Text")){
					if(dataType.equals("MLOV")){
						String reqMLovValue[] =  StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode"))).split(",");
					
						for(int j=0; j<reqMLovValue.length; j++){
							mLovValue = reqMLovValue[j].toString();							
							setMap.put("PlainText", mLovValue);						
							setMap.put("ItemID", itemID);
							setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
							setMap.put("ClassCode", classCode);
							setMap.put("ItemTypeCode", itemTypeCode);															
							setMap.put("LovCode", mLovValue );
							setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
						}	
					}else{
						setMap.put("PlainText", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")),"") );					
						setMap.put("ItemID", itemID);
						setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
						setMap.put("ClassCode", classCode);
						setMap.put("ItemTypeCode", itemTypeCode);															
						setMap.put("LovCode", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")),""));
						setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
					}
				}else{	
					String plainText = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")),"");
					//if(html.equals("1")){plainText =  StringEscapeUtils.escapeHtml4(plainText);}
					setMap.put("PlainText", plainText);
					setMap.put("ItemID", itemID);
					setMap.put("languageID", languageID);
					setMap.put("ClassCode", classCode);
					setMap.put("ItemTypeCode", itemTypeCode);															
					setMap.put("LovCode", StringUtil.checkNull( commonService.selectString("attr_SQL.selectAttrLovCode", setMap) ,"") );
					setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
				}
			}
			
			//첨부파일 등록 : TB_FILE 
			commandMap.put("projectID", csrID);
			commandMap.put("id", itemID);
			commandMap.put("usrId", sessionUserID);
			commandMap.put("docCategory", "ITM");
			fileMgtActionController.saveMultiFile(request,commandMap,model);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "parent.fnCallBack('"+itemID+"');parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}	
	
	@RequestMapping(value = "/fileItemMenu.do")
	public String fileItemMenu(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "itm/fileItm/fileItemMenu";
		try {	
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));		
			String itemID = StringUtil.checkNull(cmmMap.get("itemID"));		
			String classCode = StringUtil.checkNull(cmmMap.get("classCode"));		
			model.put("s_itemID", s_itemID);
			model.put("itemID", itemID);
			model.put("classCode", classCode);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/fileItemHistory.do")
	public String fileItemHistory(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "itm/fileItm/fileItemHistory";
		try {	
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));		
			model.put("s_itemID", s_itemID);
			model.put("DocumentID", s_itemID);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
}
