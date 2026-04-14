package xbolt.custom.sk.skon;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;

import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.DRMUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.web.bind.annotation.RequestMethod;

import org.json.simple.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.project.chgInf.web.CSActionController;

/**
 * @Class Name : SKONActionController2.java
 * @Description : SKONActionController2.java
 * @Modification Information
 * @수정일 수정자 수정내용 @ @2024. 03.
 *      27. smartfactory 최초생성
 *
 * @since 2025. 03. 03
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class SKONActionController2 extends XboltController {
	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;
	
	@Resource(name="CSService")
	private CommonService CSService;
	
	@Resource(name="CSActionController")
	private CSActionController CSActionController;
	
	// SKON attr 가져오기
	@RequestMapping(value = "/getSKONAttr.do", method = RequestMethod.GET)
	@ResponseBody
	public void getSKONAttr(HttpServletRequest request,  HttpServletResponse res) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map setMap = new HashMap();
		
        res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
	    try {
	    	String itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
			String accMode = StringUtil.checkNull(request.getParameter("accMode"),"");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
			String changeSetID = "";
			
			setMap.put("s_itemID", itemID);
			setMap.put("languageID", languageID);
			/* 기본정보 내용 취득 */
			Map prcList = commonService.select("report_SQL.getItemInfo", setMap);
	    	
			/* 기본정보의 속성 내용을 취득 * OPS Mode 시 changeSetID 값이 없으면 ITEM.ReleaseNo >> changeSetID, != OPS 경우 CurChangeSet 값으로 */
			List<Map<String, Object>>  attrList = new ArrayList();
			if("OPS".equals(accMode)) {
				changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), StringUtil.checkNull(prcList.get("ReleaseNo")));
				setMap.put("changeSetID",changeSetID);
				attrList = commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
			} else {
				setMap.put("ItemID",itemID);
				setMap.put("sessionCurrLangType",languageID);
				setMap.put("selectLanguageID",languageID);
				attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
			}
			
			jsonObject.put("list", attrList);
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
	
	// SKON 사이트 정보
	@RequestMapping(value = "/getSKONSite.do", method = RequestMethod.GET)
	@ResponseBody
	public void getSKONSite(HttpServletRequest request,  HttpServletResponse res) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map setMap = new HashMap();
		
        res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
	    try {
	    	String itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
			String accMode = StringUtil.checkNull(request.getParameter("accMode"),"");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
			String changeSetID = "";
			
			setMap.put("s_itemID", itemID);
			setMap.put("languageID", languageID);
			/* 기본정보 내용 취득 */
			Map prcList = commonService.select("report_SQL.getItemInfo", setMap);
	    	
			/* 기본정보의 속성 내용을 취득 * OPS Mode 시 changeSetID 값이 없으면 ITEM.ReleaseNo >> changeSetID, != OPS 경우 CurChangeSet 값으로 */
			List<Map<String, Object>>  attrList = new ArrayList();
			if("OPS".equals(accMode)) {
				changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), StringUtil.checkNull(prcList.get("ReleaseNo")));
				setMap.put("changeSetID",changeSetID);
				attrList = commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
			} else {
				setMap.put("ItemID",itemID);
				setMap.put("sessionCurrLangType",languageID);
				setMap.put("selectLanguageID",languageID);
				attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
			}
			
			jsonObject.put("list", attrList);
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
	
	// SKON Item Name - L1, L2 등 가져오기
		@RequestMapping(value = "/getItemNameListByHier.do", method = RequestMethod.GET)
		@ResponseBody
		public void getItemNameListByHier(HttpServletRequest request,  HttpServletResponse res) throws Exception {
			JSONObject jsonObject = new JSONObject();
			Map setMap = new HashMap();
			
	        res.setHeader("Cache-Control", "no-cache");
			res.setContentType("text/plain");
			res.setCharacterEncoding("UTF-8");
		    try {
		    	String itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
				String level = StringUtil.checkNull(request.getParameter("level"),"");
				String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"),"");
				String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
				
				setMap.put("itemID", itemID);
				setMap.put("level", level);
				setMap.put("itemTypeCode", itemTypeCode);
				setMap.put("languageID", languageID);
		    	
				Map map = commonService.select("common_SQL.getItemNameListByHier_commonSelect", setMap);
				
				jsonObject.put("data", map);
		        res.getWriter().print(jsonObject);
		    } catch (Exception e) {
		        System.out.println(e.toString());
		        res.getWriter().print(jsonObject);
		    }
		}
		
	
	@RequestMapping(value="/zSKON_searchPrcList.do")
	public String zSKON_searchPrcList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = StringUtil.checkNull(request.getParameter("url"),"/itm/structure/searchSubItemList");
		
		try{
			Map setMap = new HashMap();
			
			// menucat 파라메터가 설정되어서 본 이벤트를 호출 하는 경우 : 아이템 트리의 하위항목 			
			String s_itemID = StringUtil.checkNull(request.getParameter("itemID"));
			String isNothingLowLank = "";
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));	
			String accMode = StringUtil.checkNull(commandMap.get("accMode"),"OPS");		
//			String childItems = "";
			String screenOption = StringUtil.checkNull(request.getParameter("screenOption"));
			String ArcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
			
			if(s_itemID.equals("")) 
				s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
		
			// 선택된 아이템의 하위항목을 모두 취득
//			childItems = zSKON_getChildItemList(s_itemID);
//			if (childItems.isEmpty()) {
//				isNothingLowLank = "Y";
//			}
			model.put("s_itemID", s_itemID);
			model.put("option", StringUtil.checkNull(request.getParameter("option")));
			model.put("pop", StringUtil.checkNull(request.getParameter("pop")));
			
			
			// [ClassCode] List 취득, 해당 아이템 하위의 classcode리스트를 설정
			Map selectedItemInfoMap = commonService.select("project_SQL.getItemInfo", setMap);
			String itemTypeCode = StringUtil.checkNull(selectedItemInfoMap.get("ItemTypeCode"));
			String classCode =  StringUtil.checkNull(selectedItemInfoMap.get("ClassCode"));
			
			setMap.put("ItemTypeCode", itemTypeCode);
			setMap.put("ItemClassCode", classCode);
			List classCodeList = commonService.selectList("search_SQL.getLowlankClassCodeList", setMap);
			
		
			// Login user editor 권한 추가
//			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
//			Map itemAuthorMap = commonService.select("project_SQL.getItemAuthorIDAndLockOwner", setMap);
//			if (StringUtil.checkNull(itemAuthorMap.get("AuthorID")).equals(commandMap.get("sessionUserId")) 
//					|| StringUtil.checkNull(itemAuthorMap.get("LockOwner")).equals(commandMap.get("sessionUserId"))
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);

			commandMap.put("Category", "ITMSTS");
			List statusList = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);
			model.put("statusList", statusList);
			commandMap.put("Deactivated", "1");
						
			/** DimTypeId List */
			List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);	
			model.put("dimTypeList", dimTypeList);
	        
			/** 법인 List */
	        setMap.put("TeamType", "2");
			List companyOptionList = commonService.selectList("organization_SQL.getTeamList", setMap);
			model.put("companyOption", companyOptionList);
			
			/** Symbol List */
			List symbolCodeList = commonService.selectList("search_SQL.getSymbolCodeList", setMap);
			model.put("symbolCodeList", symbolCodeList);
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);
			
			if(screenType.equals("main")){
				model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode")));
				model.put("classCode", StringUtil.checkNull(request.getParameter("classCode")));
				model.put("AttrCode", StringUtil.checkNull(request.getParameter("searchKey")));
				model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
				model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
				model.put("searchTeamName", StringUtil.checkNull(request.getParameter("searchTeamName")));
				model.put("searchAuthorName", StringUtil.checkNull(request.getParameter("searchAuthorName")));
			}
			
			// 속성 검색
			setMap.put("defaultLang", defaultLang);
			List attrList = commonService.selectList("attr_SQL.getItemAttr", setMap);
			
			String defItemTypeCode = StringUtil.checkNull(request.getParameter("defItemTypeCode"));
			String defClassList = StringUtil.checkNull(request.getParameter("defClassList"));
			String defCompany = StringUtil.checkNull(request.getParameter("defCompany"));
			String defOwnerTeam = StringUtil.checkNull(request.getParameter("defOwnerTeam"));
			String defAuthor = StringUtil.checkNull(request.getParameter("defAuthorName"));
			String defDimTypeID = StringUtil.checkNull(request.getParameter("defDimTypeID"));
			String defDimValueID = StringUtil.checkNull(request.getParameter("defDimValueID"));
	
			String fixedDimValueID = StringUtil.checkNull(request.getParameter("fixedDimValueID"));
			String defAttrTypeCode = StringUtil.checkNull(request.getParameter("defAttrTypeCode"));
			String defAttrTypeValue = StringUtil.checkNull(request.getParameter("defAttrTypeValue"));
			String defStatus = StringUtil.checkNull(request.getParameter("defStatus"));
			setMap.put("attrTypeCode", defAttrTypeCode);
			String defAttrTypeName = commonService.selectString("report_SQL.getAttrName", setMap);
			String itemInfoRptUrl = StringUtil.checkNull(request.getParameter("itemInfoRptUrl"));
			
			setMap.put("typeCode", itemTypeCode);
			setMap.put("category", "OJ");
			String itemTypeName = StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic", setMap));		
			String selectedItemPath = StringUtil.checkNull(commonService.selectString("item_SQL.getItemPath", setMap));
			
			setMap.put("itemID", s_itemID);
			setMap.put("attrTypeCode", "AT00001");
			String itemName = commonService.selectString("item_SQL.getItemAttrPlainText", setMap);
			model.put("itemName", itemName);
			
			model.put("itemTypeName", itemTypeName);
			model.put("selectedItemPath", selectedItemPath);
			model.put("defAttrTypeName", defAttrTypeName);
			model.put("defItemTypeCode", defItemTypeCode);
			model.put("defClassList", defClassList);
			model.put("defCompany", defCompany);
			model.put("defOwnerTeam", defOwnerTeam);
			model.put("defAuthor", defAuthor);
			model.put("defDimTypeID", defDimTypeID);
			model.put("defDimValueID", defDimValueID);
			model.put("fixedDimValueID", fixedDimValueID);
			model.put("defAttrTypeCode", defAttrTypeCode);
			model.put("defAttrTypeValue", defAttrTypeValue);
			model.put("defStatus", defStatus);
			model.put("itemInfoRptUrl", itemInfoRptUrl);
			
			model.put("isNothingLowLank", isNothingLowLank);
			model.put("defaultLang", defaultLang);
//			model.put("childItems", childItems);
			model.put("menu", getLabel(request, commonService));
			model.put("idExist", StringUtil.checkNull(request.getParameter("idExist")));
			model.put("ownerType", StringUtil.checkNull(request.getParameter("ownerType")));
			model.put("showTOJ", StringUtil.checkNull(request.getParameter("showTOJ")));
			model.put("accMode", accMode);
			model.put("screenOption", screenOption);
			model.put("s_ClassCode", classCode);
			model.put("attrList", attrList);
			model.put("classCode", classCode);
			String parentID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemParentID", setMap));
			model.put("parentID", parentID);
			setMap.put("itemID", parentID);
			String parentName = commonService.selectString("item_SQL.getItemAttrPlainText", setMap);
			model.put("parentName", parentName);
			
			List itemPath = new ArrayList();
			itemPath = getRootItemPath(s_itemID, StringUtil.checkNull(commandMap.get("sessionCurrLangType")), itemPath);
			Collections.reverse(itemPath);
			model.put("itemPath", itemPath);
		} catch(Exception e) {
			System.out.println(e.toString());
		}		
		
		return nextUrl(url);
	}
	
	/**
	 * Item Path 조회
	 * 
	 * @param setMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List getRootItemPath(String itemID, String languageID, List itemPath) throws Exception {
		System.out.println("getRootItemPath");
		Map setMap = new HashMap();
		setMap.put("itemID", itemID);
		String ParentItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getParentItemID", setMap), "0");

		if (Integer.parseInt(ParentItemID) != 0 && Integer.parseInt(ParentItemID) > 100) {
			setMap.put("ItemID", ParentItemID);
			setMap.put("languageID", languageID);
			setMap.put("attrTypeCode", "AT00001");
			Map temp = commonService.select("attr_SQL.getItemAttrText", setMap);
			temp.put("itemID", ParentItemID);
			itemPath.add(temp);
			getRootItemPath(ParentItemID, languageID, itemPath);
		}

		return itemPath;
	}
	
	private String zSKON_getChildItemList(String s_itemID) throws ExceptionUtil {
		String outPutItems = "";
		List itemIdList = new ArrayList();
		List list = new ArrayList();
		Map map = new HashMap();
		Map setMap = new HashMap();
			try {
			String itemId = s_itemID;
			setMap.put("ItemID", itemId);
			//delItemIdList.add(itemId);
			
			// 취득한 아이템 리스트 사이즈가 0이면 while문을 빠져나간다.
			int j = 1;
			while (j != 0) { 
				String toItemId = "";
				
				setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
				setMap.put("CategoryCode", "ST1");
				//setMap.put("CategoryCodes", "'ST1','ST2'");
				list = commonService.selectList("report_SQL.getChildItems", setMap);
				j = list.size();
				for (int k = 0; list.size() > k; k++) {
					 map = (Map) list.get(k);
					 setMap.put("ItemID", map.get("ToItemID"));
					 itemIdList.add(map.get("ToItemID"));
					 
					 if (k == 0) {
						 toItemId = "'" + String.valueOf(map.get("ToItemID")) + "'";
					 } else {
						 toItemId = toItemId + ",'" + String.valueOf(map.get("ToItemID")) + "'";
					 }
				}
				
				itemId = toItemId; // ToItemID를 다음 ItemID로 설정
			}
			
			outPutItems = "";
			for (int i = 0; itemIdList.size() > i ; i++) {
				
				if (outPutItems.isEmpty()) {
					outPutItems += itemIdList.get(i);
				} else {
					outPutItems += "," + itemIdList.get(i);
				}
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		
		return outPutItems;
	}
	
	@RequestMapping({ "/zskon_createProcessInfo.do" })
	public String zskon_createProcessInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
			Map setValue = new HashMap();
			Map insertCngMap = new HashMap();
			Map updateData = new HashMap();

			String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"));
			String fromItemID = StringUtil.checkNull(commandMap.get("parentID"));
			String classCode = StringUtil.checkNull(commandMap.get("classCode"));
			String cpItemID = StringUtil.checkNull(commandMap.get("cpItemID"));
			String mstSTR = StringUtil.checkNull(commandMap.get("mstSTR"));
			String ItemID = commonService.selectString("item_SQL.getItemMaxID", setMap);
			String docIdentifier="";
			setMap.put("ClassCode", classCode);

			
			/** item insert start *****/
			setMap.put("ItemID", ItemID);
			setMap.put("s_itemID", fromItemID);
			
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
			setMap.put("itemClassCode", classCode);
			setMap.put("itemTypeCode", itemTypeCode);
			setMap.put("userID", StringUtil.checkNull(commandMap.get("sessionUserId")));
			String projectID = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemClassDefCSRID", setMap));
			
			setMap.put("option", StringUtil.checkNull(request.getParameter("option")));
			setMap.put("Version", "0");
			setMap.put("Deleted", "0");
			setMap.put("Creator", StringUtil.checkNull(commandMap.get("sessionUserId")));
			setMap.put("CategoryCode", "OJ");
			setMap.put("ClassCode", classCode);
			setMap.put("OwnerTeamId", StringUtil.checkNull(commandMap.get("sessionTeamId")));
			setMap.put("Identifier", docIdentifier);
			setMap.put("ItemID", ItemID);
			if (itemTypeCode.equals("")) {
				itemTypeCode = this.commonService.selectString("item_SQL.selectedItemTypeCode", setMap);
			}
			setMap.put("ItemTypeCode", itemTypeCode);

			setMap.put("AuthorID", StringUtil.checkNull(commandMap.get("sessionUserId")));
			setMap.put("IsPublic", StringUtil.checkNull(request.getParameter("IsPublic")));
			setMap.put("ProjectID", projectID);
			setMap.put("RefItemID", StringUtil.checkNull(request.getParameter("refItemID")));
			setMap.put("Status", "NEW1");

			setMap.put("itemId", StringUtil.checkNull(request.getParameter("s_itemID")));

			this.commonService.insert("item_SQL.insertItem", setMap);
			setMap.remove("CurChangeSet");
			/** item insert end *****/
			
			/** 속성 insert start *****/
			Map<String, String> attrTypeCodes = new HashMap<>();
			attrTypeCodes.put("AT00001", "AT00001");  // 문서명
			attrTypeCodes.put("ZAT01010", "ZAT01010");// 담당 site 
			attrTypeCodes.put("ZAT01080", "ZAT01080");//채번 site정보 
			attrTypeCodes.put("ZAT01020", "ZAT01020");  // 문서레벨
			attrTypeCodes.put("ZAT01030", "ZAT01030");//영역
			attrTypeCodes.put("ZAT02022", "ZAT02022"); // 상세영역
			attrTypeCodes.put("ZAT01040", "ZAT01040"); //문서분야
			attrTypeCodes.put("ZAT01060", "ZAT01060"); // 문서유형
			attrTypeCodes.put("AT00803",  "AT00803"); //목적
			attrTypeCodes.put("ZAT02016", "ZAT02016"); //적용범위
			attrTypeCodes.put("ZAT02017", "ZAT02017"); // 책임과 권한
			attrTypeCodes.put("AT01007",  "AT01007"); // 키워드
			attrTypeCodes.put("AT00003",  "AT00003"); // 문서개요
			attrTypeCodes.put("ZAT02020", "ZAT02020"); // 기록및보관
			attrTypeCodes.put("ZAT01050", "ZAT01050"); // 공정
			attrTypeCodes.put("ZAT01051", "ZAT01051"); // 상세공정
			
			for (Map.Entry<String, String> entry : attrTypeCodes.entrySet()) {
			    String attrTypeCode = entry.getKey();
			    String formField = entry.getValue();
			    String formValue = StringUtil.checkNull(request.getParameter(formField));
	
			    setMap.put("PlainText", formValue);  
			    setMap.put("AttrTypeCode", attrTypeCode);
			    if(attrTypeCode.equals("ZAT01010") || attrTypeCode.equals("ZAT01020") ||attrTypeCode.equals("ZAT01030")|| attrTypeCode.equals("ZAT01040") || attrTypeCode.equals("ZAT01060") 
			    		|| attrTypeCode.equals("ZAT01050") || attrTypeCode.equals("ZAT01051")|| attrTypeCode.equals("ZAT02022")||attrTypeCode.equals("ZAT01080")) {
			    	setMap.put("LovCode", formValue);
			    }
			    
			    List getLanguageList = this.commonService.selectList("common_SQL.langType_commonSelect", setMap);
			    for (int i = 0; i < getLanguageList.size(); i++) {
			        Map getMap = (HashMap) getLanguageList.get(i);
			        setMap.put("languageID", getMap.get("CODE"));
			        this.commonService.insert("item_SQL.ItemAttr", setMap);
			    }
			}
			/** 속성 insert end *****/
			
			
			/** 채번 Update start**/
			if (docIdentifier.equals("")) { //문서 채번이 안되있는경우 
				//setMap.put("ItemID",ItemID);
				//setMap.put("ClassCode", classCode);
				setMap.put("languageID", request.getParameter("languageID"));
				String newDocIdenfier = StringUtil.checkNull(this.commonService.selectString("zSK_SQL.fn_createItemIdentifier", setMap));
				setMap.put("docIdentifier", newDocIdenfier);
				//String docNum = commonService.selectString("zSK_SQL.getMaxIdentifier", setMap);
				docIdentifier = newDocIdenfier;
				setMap.put("Identifier",docIdentifier );
				this.commonService.update("item_SQL.updateItemObjectInfo", setMap);
			}
			
			/** 채번 Update end **/
			
			
			
			/** item ST1 insert start *****/
			if (((!cpItemID.equals("")) && (mstSTR.equals("Y"))) || (cpItemID.equals(""))) {
				setMap.put("CategoryCode", "ST1");
				setMap.put("ClassCode", "NL00000");
				setMap.put("ToItemID", setMap.get("ItemID"));
				if (fromItemID.equals("")) {
					s_itemID= StringUtil.checkNull(request.getParameter("s_itemID"));
					setMap.put("s_itemID", s_itemID);
				} else {
					setMap.put("FromItemID", fromItemID);
				}
				setMap.put("ItemID", this.commonService.selectString("item_SQL.getItemMaxID", setMap));

				setMap.remove("RefItemID");
				setMap.remove("Identifier");
				setMap.put("ItemTypeCode",this.commonService.selectString("item_SQL.selectedConItemTypeCode", setMap));
				this.commonService.insert("item_SQL.insertItem", setMap);
			}
			/** item ST1 insert end *****/
			
			/** changeSet insert start *****/
			setMap.put("ItemID", ItemID);
			String changeMgt = StringUtil.checkNull(this.commonService.selectString("project_SQL.getChangeMgt", setMap));
			if (changeMgt.equals("1")) {
				insertCngMap.put("itemID", ItemID);
				insertCngMap.put("userId", StringUtil.checkNull(commandMap.get("sessionUserId")));
				insertCngMap.put("projectID", projectID);
				insertCngMap.put("classCode", classCode);
				insertCngMap.put("KBN", "insertCNG");
				insertCngMap.put("Reason", StringUtil.checkNull(commandMap.get("Reason")));
				insertCngMap.put("Description", StringUtil.checkNull(commandMap.get("Description")));
				insertCngMap.put("status", "MOD");
				insertCngMap.put("version", "0");
				this.CSService.save(new ArrayList(), insertCngMap);
			} else if (!changeMgt.equals("1")) {
				setMap.put("itemID", s_itemID);
				String sItemIDCurChangeSetID = StringUtil.checkNull(
						this.commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap));
				if (!sItemIDCurChangeSetID.equals("")) {
					updateData = new HashMap();
					updateData.put("CurChangeSet", sItemIDCurChangeSetID);
					updateData.put("s_itemID", ItemID);
					this.commonService.update("project_SQL.updateItemStatus", updateData);
				}
			}
			/** changeSet insert end *****/
			
			/** Dimension insert start *****/
			String dimTypeID = StringUtil.checkNull("100001");
			String dimTypeValueID = StringUtil.checkNull(request.getParameter("siteCodes"));
			
					
			if ((!dimTypeID.equals("")) && (!dimTypeValueID.equals(""))) {
				String[] temp = dimTypeValueID.split(",");
				Map setData = new HashMap();

				for (int i = 0; i < temp.length; i++) {
					
					setData.put("ItemID", ItemID);
					setData.put("DimTypeID", dimTypeID);
					setData.put("DimValueID", temp[i]);
					if (!temp[i].equals("") && !temp[i].equals(" ")) {
						this.commonService.update("dim_SQL.insertItemDim", setData);
					}
				}
			}
			/** Dimension insert end *****/
			
			/** 첨부파일 insert start *****/
			String docCategory = "ITM";
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
			
			commandMap.put("itemId", ItemID);
			commandMap.put("itemID", ItemID);
			
			Map result  = fileMgtService.select("fileMgt_SQL.selectItemAuthorID", commandMap);
			String changeSetID = StringUtil.checkNull(commonService.selectString("project_SQL.getCurChangeSetIDFromItem",commandMap));
			
			String itemFileOption = fileMgtService.selectString("fileMgt_SQL.getFileOption",commandMap);
			commandMap.put("Status", StringUtil.checkNull(result.get("Status")));
			
			Map fileMap  = new HashMap();
			List fileList = new ArrayList();
			
			int seqCnt = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", commandMap));		
			//Read Server File
			String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(commandMap.get("sessionUserId"))+"//";
			fileMap.put("fltpCode", fltpCode);
			String filePath = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFilePath",fileMap)); 
			String targetPath = filePath;
			List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
			

			// DRM 복호화 정보 
			HashMap drmInfoMap = new HashMap();			
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
			String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));			
			drmInfoMap.put("userID", userID);
			drmInfoMap.put("userName", userName);
			drmInfoMap.put("teamID", teamID);
			drmInfoMap.put("teamName", teamName);
			drmInfoMap.put("loginID", commandMap.get("sessionLoginId"));
			drmInfoMap.put("sessionEmail", commandMap.get("sessionEmail"));
			
			String allFileList[] = FileUtil.ALL_FILE_LIST;
			String revisionYN = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getRevisionYN", commandMap));	
			
			if(tmpFileList.size() != 0){
				for(int i=0; i<tmpFileList.size();i++){
					fileMap = new HashMap(); 
					HashMap resultMap = (HashMap)tmpFileList.get(i);
					String fileExt = StringUtil.checkNull(resultMap.get(FileUtil.FILE_EXT));
					// 허용된 파일 확장자인 경우에만 파일을 저장
				    if(Arrays.asList(allFileList).contains(fileExt.toUpperCase())) {
						fileMap.put("Seq", seqCnt);
						fileMap.put("DocumentID", ItemID);
						fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
						fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
						fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
						fileMap.put("FileFormat", resultMap.get(FileUtil.FILE_EXT));
						fileMap.put("FilePath", filePath);
						fileMap.put("FltpCode", fltpCode);
						fileMap.put("FileMgt", "ITM");
						fileMap.put("LinkType", "1");
						fileMap.put("ChangeSetID", changeSetID);
						fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
						fileMap.put("userId", commandMap.get("sessionUserId"));
						fileMap.put("projectID", projectID);
						fileMap.put("DocCategory",docCategory);
						fileMap.put("revisionYN", revisionYN);
						fileMap.put("RegUserID", commandMap.get("sessionUserId"));
						fileMap.put("LastUser", commandMap.get("sessionUserId"));
						
						fileMap.put("KBN", "insert");
						fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");	
						
						System.out.println("targetPath :" + targetPath);
						// File DRM 복호화
						String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
						String DRM_UPLOAD_USE = StringUtil.checkNull(GlobalVal.DRM_UPLOAD_USE);
						if(!"".equals(useDRM) && !"N".equals(DRM_UPLOAD_USE)){
							drmInfoMap.put("ORGFileDir", orginPath);
							drmInfoMap.put("DRMFileDir", targetPath); // C://OLMFILE//document/FLT016//
							drmInfoMap.put("Filename", resultMap.get(FileUtil.UPLOAD_FILE_NM));	 //  newFileName
							drmInfoMap.put("FileRealName", resultMap.get(FileUtil.FILE_NAME));							
							drmInfoMap.put("funcType", "upload");
							String returnValue = DRMUtil.drmMgt(drmInfoMap); // 복호화 
						}
						
						fileList.add(fileMap);
						seqCnt++;
					} else {
				    	System.out.println("disallowedExtension :"+fileExt);
				    }
				}
			}
			
			if(fileList.size() != 0){
				fileMgtService.save(fileList, fileMap);
			}
			
			if (!orginPath.equals("")) {
				FileUtil.deleteDirectory(orginPath);
			}
			/** 첨부파일 insert end *****/
			
			/** TW_ITEM_HIER insert start *****/
		//	commonService.insert("zSK_SQL2.execItemHier", setMap);
			/** TW_ITEM_HIER insert start *****/
			
			target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT,"parent.fnEditItemInfo("+ItemID+");parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put("SCRIPT", "parent.$('#isSubmit').remove();$('#isSubmit').remove();");
			target.put("ALERT", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/olmapi/skAttrLovList", method = RequestMethod.GET)
	@ResponseBody
	public void skAttrLovList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map setMap = new HashMap();
		String result = "";
		try {
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode")); 
			String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode")); 
			
			setMap.put("itemTypeCode",itemTypeCode);
			setMap.put("attrTypeCode",attrTypeCode);
			
			result = StringUtil.checkNull(commonService.selectString("zSK_SQL2.getLovListByItemType", setMap));
			ObjectMapper objectMapper = new ObjectMapper();
			String jsonString = StringUtil.checkNull(objectMapper.writeValueAsString(result));
			
			sendToJson(jsonString, response);
        } catch (Exception e) {
            System.out.println(e);
        }
	}
	
	public static void sendToJson(String jObj, HttpServletResponse res) {
		try {
			res.setHeader("Cache-Control", "no-cache");
			res.setContentType("text/plain");
			res.setCharacterEncoding("UTF-8");
			if(!jObj.equals("{data: [ ]}")){
				res.getWriter().print(jObj);
			}
			else {
				PrintWriter pw = res.getWriter();
				pw.write("데이터가 존재하지 않습니다.");
			}			
		} catch (IOException e) {
			MessageHandler.getMessage("json.send.message");
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="/mainHomeSKON.do")
	public String olmMainHomeV34(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception{
		String url = StringUtil.checkNull(cmmMap.get("url"),"/custom/sk/skon/mainHomeSKON");
		try {
			Map setMap = new HashMap();
			List viewItemTypeList = new ArrayList();
			
			String defDimValueID = StringUtil.checkNull(cmmMap.get("defDimValueID"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String userId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String mLvl = StringUtil.checkNull(cmmMap.get("sessionMlvl"));
			
			setMap.put("ChangeMgt","1");
			setMap.put("languageID",languageID);
			List itemTypeCodeList = commonService.selectList("item_SQL.getItemTypeCodeList",setMap);
			
			if(itemTypeCodeList != null && !itemTypeCodeList.isEmpty()) {
				Map typeTemp = new HashMap();
				Map cntTemp = new HashMap();
				
				for(int i=0; i < itemTypeCodeList.size(); i++) {
					typeTemp = (Map)itemTypeCodeList.get(i);
					cntTemp = new HashMap();
					setMap.put("itemTypeCode",StringUtil.checkNull(typeTemp.get("CODE")));
					
					String itemCnt = StringUtil.checkNull(commonService.selectString("item_SQL.getItemCntByItemType",setMap));
					
					cntTemp.put("itemCnt", itemCnt);
					cntTemp.put("itemCode", StringUtil.checkNull(typeTemp.get("CODE")));
					cntTemp.put("itemName", StringUtil.checkNull(typeTemp.get("NAME")));
					cntTemp.put("itemIcon", StringUtil.checkNull(typeTemp.get("ICON")));
					cntTemp.put("itemArcCode", StringUtil.checkNull(typeTemp.get("ArcCode")));
					cntTemp.put("itemArcStyle", StringUtil.checkNull(typeTemp.get("ArcStyle")));
					cntTemp.put("itemArcIcon", StringUtil.checkNull(typeTemp.get("ArcIcon")));
					cntTemp.put("itemURL", StringUtil.checkNull(typeTemp.get("URL")));
					cntTemp.put("itemMenuVar", StringUtil.checkNull(typeTemp.get("MenuVar")));
					cntTemp.put("itemArcVar", StringUtil.checkNull(typeTemp.get("ArcVar")));
					cntTemp.put("itemDefColor", StringUtil.checkNull(typeTemp.get("DefColor")));
					
					viewItemTypeList.add(i, cntTemp);
				}
			}
			
			setMap.put("sessionCurrLangType",languageID);
			setMap.put("authorID",userId);
			
			// my cs List
			setMap.put("top","10");
			setMap.put("changeMgtYN","Y");
			setMap.put("statusList","'NEW1','NEW2','MOD1','MOD2'");		
			setMap.remove("itemTypeCode");
			List myItemList = commonService.selectList("item_SQL.getOwnerItemList_gridList", setMap);
			model.put("myItemList", myItemList);
			
			setMap.put("actorID", userId);
			setMap.put("filter", "myWF");
			setMap.put("wfMode", "CurAprv");
			List wfCurAprvList = commonService.selectList("wf_SQL.getWFInstList_gridList",setMap);
			if(wfCurAprvList != null && !wfCurAprvList.isEmpty()) {
				model.put("wfCurAprvCnt",wfCurAprvList.size());
			}
			else {
				model.put("wfCurAprvCnt","0");
			}
			
			// my Review Board List
			
		//  setMap.put("myID", userId);
			setMap.put("myBoard","Y");

			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			long date = System.currentTimeMillis();
			setMap.put("scEndDtFrom", formatter.format(date));
			setMap.put("BoardMgtID","BRD0001");
			setMap.put("sessionUserId",userId);
		
			List myRewBrdList = commonService.selectList("forum_SQL.forumGridList_gridList", setMap);
			model.put("myRewBrdList", myRewBrdList);
			
			model.put("srType", request.getParameter("srType"));
			model.put("viewItemTypeList",viewItemTypeList);
			model.put("languageID", languageID);	
			model.put("defDimValueID", defDimValueID);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		model.put("menu", getLabel(request, commonService));	//Label Setting
		model.put("screenType", request.getParameter("screenType"));
		return nextUrl(url);
	}
	
	@RequestMapping(value="/zSKON_olmMainChangeSetList.do")
	public String olmMainChangeSetList(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String defDimValueID = StringUtil.checkNull(request.getParameter("defDimValueID"));
			
			setMap.put("languageID", languageID);
			setMap.put("pageNo", 1);
			setMap.put("topNum", 15);
			setMap.put("changeMgtYN", "Yes");
			setMap.put("categoryCode", "OJ");
			setMap.put("defDimValueID", defDimValueID);
			List csList = commonService.selectList("zSK_SQL2.getLastUpdatedWithin7Days",setMap);
						
			model.put("csList", csList);
			model.put("languageID", languageID);	
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
						
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		
		return nextUrl("/custom/sk/skon/mainChangeSetList");
	}
	
	@RequestMapping(value = "/zSKON_mainSttProcessChart.do")
	public String mainSttProcessChart(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			model.put("defaultLang",commonService.selectString("item_SQL.getDefaultLang", cmmMap));
		} catch (Exception e) {	
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/sk/skon/mainSttProcessChart");
	}
	
	// itemTotalList 출력 리포트
	@RequestMapping(value="/zSKON_itemTotalReport.do")
	public String itemTotalReport(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try{
			String s_itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
			String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"),"");
			String url = StringUtil.checkNull(request.getParameter("url"),"");
			String objType = StringUtil.checkNull(request.getParameter("objType"),"OJ00001");
			String classCode = StringUtil.checkNull(request.getParameter("classCode"),"CL01005");
			String rnrOption = StringUtil.checkNull(request.getParameter("rnrOption"),"");		// 1 : 하위항목, 2 : 엘리먼트 리스트
			String elmClassList = StringUtil.checkNull(request.getParameter("elmClassList"),"");
			String accMode = StringUtil.checkNull(request.getParameter("accMode"),"");	
			String activityMode = StringUtil.checkNull(request.getParameter("activityMode"),"");	
			String customMode = StringUtil.checkNull(request.getParameter("customMode"),"");
			
			commandMap.put("ItemTypeCode", objType);
			Map modelExist = commonService.select("common_SQL.getMDLTypeCode_commonSelect", commandMap);
			
		
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			model.put("s_itemID", s_itemID);
			model.put("arcCode", arcCode);
			model.put("url", url);
			model.put("objType", objType);
			model.put("classCode", classCode);
			model.put("rnrOption", rnrOption);
			model.put("elmClassList", elmClassList);
			model.put("modelExist", modelExist.size());
			model.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));
			model.put("accMode", accMode);
			model.put("activityMode", activityMode);
			model.put("customMode", customMode);
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		
		return nextUrl("/custom/sk/skon/report/itemTotalReport");
	}
	
	/**
	 * itemDocReport 출력
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/zSKON_itemDocReport.do")
	public String itemDocReport(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		Map target = new HashMap();
		// client별 word report url 설정
		String url= "/custom/base/report/processReport";
		if(!StringUtil.checkNull(commandMap.get("exportUrl")).equals("")){ url = "/"+ StringUtil.checkNull(commandMap.get("exportUrl")); }
		try{
			Map setMap = new HashMap();
			String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
			String delItemsYN = StringUtil.checkNull(commandMap.get("delItemsYN"));
			String accMode = StringUtil.checkNull(request.getParameter("accMode"),""); 
			String activityMode = StringUtil.checkNull(request.getParameter("activityMode"),""); //하위항목 모드 : 기본 - 아이템의 하위항목 / element = 모델에 존재하는 L4,L5 항목
			
			setMap.put("languageID", languageId);
			setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("ArcCode", request.getParameter("ArcCode"));
			setMap.put("rnrOption", request.getParameter("rnrOption"));
			setMap.put("delItemsYN", delItemsYN);
			setMap.put("accMode", accMode);
			setMap.put("activityMode", activityMode);
			
			setMap.put("csYN", request.getParameter("csYN"));
			setMap.put("occYN", request.getParameter("occYN"));
			setMap.put("cxnYN", request.getParameter("cxnYN"));
			setMap.put("fileYN", request.getParameter("fileYN"));
			setMap.put("teamYN", request.getParameter("teamYN"));
			setMap.put("rnrYN", request.getParameter("rnrYN"));
			setMap.put("elmClassList", request.getParameter("elmClassList"));
			setMap.put("subItemYN", request.getParameter("subItemYN"));
			
			// 파일명에 이용할 Item Name 을 취득
			if("OPS".equals(accMode)) {
				setMap.put("attrRevYN", "Y");
			}
			
		
			Map selectedItemMap = commonService.select("report_SQL.getItemInfo", setMap);
			setMap.put("ReleaseNo",selectedItemMap.get("ReleaseNo"));
			
			/* 첨부 문서 취득 */
			setMap.put("DocumentID", request.getParameter("s_itemID"));
			setMap.put("DocCategory", "ITM");
			List L2AttachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
			// 로그인 언어별 default font 취득
			String defaultFont = commonService.selectString("report_SQL.getDefaultFont", setMap);			
			
			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);			
			List modelList = new ArrayList();
			List totalList = new ArrayList();
			
			List allTotalList = new ArrayList();
			Map allTotalMap = new HashMap();
			Map titleItemMap = new HashMap();
			String e2eModelId = "";
			Map e2eModelMap = new HashMap();
			List subTreeItemIDList = new ArrayList();
			String selectedItemPath = "";
			Map e2eAttrMap = new HashMap();
			Map e2eAttrNameMap = new HashMap();
			Map e2eAttrHtmlMap = new HashMap();
			List e2eDimResultList = new ArrayList();
			
			Map gItem = new HashMap();			// L2
			List pItemList = new ArrayList();			// L3
			List mainItemList = new ArrayList();	// L4
			
			String reportCode = StringUtil.checkNull(commandMap.get("reportCode"));
			String classCode = commonService.selectString("report_SQL.getItemClassCode", setMap);
			String objType = StringUtil.checkNull(commandMap.get("objType"));
			setMap.put("classCode", classCode);
			setMap.put("ItemTypeCode", objType);
			int maxLevel = Integer.parseInt(commonService.selectString("analysis_SQL.getItemClassMaxLevel", setMap));
			
			// 해당 아이템의 레벨 확인
			int Level = Integer.parseInt(commonService.selectString("report_SQL.getLevelfromClassCode", setMap));
			
			if(Level == 2){							// L2에서 워드리포트 실행 경우
				gItem = selectedItemMap;
				
				setMap.put("CURRENT_ITEM", selectedItemMap.get("ItemID"));
				setMap.put("CategoryCode", "ST1");
				pItemList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				
				for(int i = 0; i<pItemList.size(); i++){
					Map pItemMap = (Map) pItemList.get(i);
					setMap.put("classCode", pItemMap.get("toItemClassCode"));
					// 하위항목의 레벨 확인
					int pItemLevel = Integer.parseInt(commonService.selectString("report_SQL.getLevelfromClassCode", setMap));
					pItemLevel++;
					if(pItemLevel != maxLevel){
						setMap.put("CURRENT_ITEM", pItemMap.get("ToItemID"));
						setMap.put("CategoryCode", "ST1");
						mainItemList.add(commonService.selectList("report_SQL.getChildItemsForWord", setMap));
					}
				}
			}
			if(Level == 3){				// L3에서 워드리포트 실행 경우
				setMap.put("classCode", selectedItemMap.get("ClassCode"));
				// 하위항목의 레벨 확인
				int pItemLevel = Integer.parseInt(commonService.selectString("report_SQL.getLevelfromClassCode", setMap));
				pItemLevel++;
				if(pItemLevel != maxLevel){
					pItemList.add(selectedItemMap);
					setMap.put("CURRENT_ITEM", selectedItemMap.get("ItemID"));
					setMap.put("CategoryCode", "ST1");
					mainItemList.add(commonService.selectList("report_SQL.getChildItemsForWord", setMap));
				}
			}
			
			// 선택된 Item의 Path취득 (Id + Name)
			selectedItemPath= selectedItemMap.get("Identifier")+" "+selectedItemMap.get("ItemName");
			model.put("gItem", gItem);
			model.put("pItemList", pItemList);
			model.put("mainItemList", mainItemList);
			
			setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
			
			String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
			commandMap.put("ArcCode", arcCode);
			commandMap.put("SelectMenuId", arcCode);
			Map arcTreeFilterInfoMap =  commonService.select("report_SQL.getArcTreeFilterInfo", commandMap);	
			String TreeSql = StringUtil.checkNull(arcTreeFilterInfoMap.get("TreeSql"));
			commandMap.put("TreeSql", TreeSql);	
			String outPutItems = "";
//			if(TreeSql != null && !"".equals(TreeSql))	{
//				outPutItems = getArcTreeIDs(commandMap);
//				commandMap.put("outPutItems", outPutItems);
//			}
			
			setMap.put("outPutItems", outPutItems);
			setMap.put("selectLanguageID", StringUtil.checkNull(commandMap.get("selectLanguageID")));	
			modelList = commonService.selectList("report_SQL.getItemStrList_gridList", setMap);
			setMap.remove("ClassCode");
			
			subTreeItemIDList = getChildItemList(commonService, request.getParameter("s_itemID"), classCode, languageId, outPutItems, delItemsYN);
			
			/** 선택된 Item의 SubProcess Item취득(L2) */
			setMap.put("CURRENT_ITEM", request.getParameter("s_itemID")); // 해당 아이템이 [FromItemID]인것
			setMap.put("CategoryCode", "ST1");
			setMap.put("languageID", languageId);
			setMap.put("toItemClassCode", "CL01004");   
			
			List L2SubItemInfoList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			allTotalMap.put("L2SubItemInfoList", L2SubItemInfoList);
			
			
			setMap.put("toItemClassCode", "CL01006"); //Activity 리스트
			List L5SubItemInfoList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			allTotalMap.put("L5SubItemInfoList", L5SubItemInfoList);
			
			// QMS&E2E 의 경우 연관항목 추출 (개요에 사용)
			if ("element".equals(activityMode)) {
				setMap.put("cxnYN", "on");
				// rnrYN 이 on 일 때, subItem 정보 필요
				if("on".equals(StringUtil.checkNull(setMap.get("rnrYN")))) {
					setMap.put("subItemYN", "on");
				}
			}
			List cngtList = new ArrayList();
		
			setMap.put("itemId",   request.getParameter("s_itemID"));
			//표지 히스토리 
			 cngtList = commonService.selectList("report_SQL.getItemChangeListRPT", setMap);
		
			 allTotalMap.put("cngtList", cngtList);
			
			// 해당 아이템의 하위 항목의 서브프로세스 수 만큼 word report 작성
			getItemTotalInfo(totalList, modelList, setMap, request, commandMap, defaultLang, languageId, accMode);
			titleItemMap = selectedItemMap;
			allTotalMap.put("titleItemMap", titleItemMap);
			allTotalMap.put("totalList", totalList);
			allTotalMap.put("L2AttachFileList", L2AttachFileList);
			allTotalList.add(allTotalMap);
			
			// RASI ACTIVITY INFO ("languageID", languageId);
			commandMap.put("languageID", languageId);
			commandMap.put("s_itemID", request.getParameter("s_itemID"));
		   

		        
		    List<Map<String, Object>> activityList = commonService.selectList("zSK_SQL2.getProcessActivity_gridList", commandMap); 

		    model.put("activityList", activityList);
		

			model.put("allTotalList", allTotalList);
			model.put("e2eModelMap", e2eModelMap); // E2E report 출력인 경우
			model.put("e2eItemInfo", selectedItemMap); // E2E report 출력인 경우
			model.put("e2eAttrMap", e2eAttrMap); // E2E report 출력인 경우
			model.put("e2eAttrNameMap", e2eAttrNameMap); // E2E report 출력인 경우
			model.put("e2eAttrHtmlMap", e2eAttrHtmlMap); // E2E report 출력인 경우
			model.put("e2eDimResultList", e2eDimResultList); // E2E report 출력인 경우
			
			model.put("onlyMap", request.getParameter("onlyMap"));
			model.put("paperSize", request.getParameter("paperSize"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("setMap", setMap);
			model.put("defaultFont", defaultFont);
			model.put("subTreeItemIDList", subTreeItemIDList);
			model.put("selectedItemPath", selectedItemPath);
			String itemNameofFileNm = StringUtil.checkNull(selectedItemMap.get("ItemName")).replace("&#xa;", "");
			model.put("ItemNameOfFileNm", URLEncoder.encode(itemNameofFileNm, "UTF-8").replace("+", "%20"));
			model.put("selectedItemIdentifier", StringUtil.checkNull(selectedItemMap.get("Identifier")));
			model.put("outputType", request.getParameter("outputType"));  
			model.put("selectedItemMap", selectedItemMap);
			
			setMap.put("teamID", StringUtil.checkNull(selectedItemMap.get("OwnerTeamID")));
			Map managerInfo = commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
			model.put("ownerTeamMngNM",managerInfo.get("MemberName"));	// 프로세스 책임자
			
			model.put("csYN", request.getParameter("csYN"));
			model.put("occYN", request.getParameter("occYN"));
			model.put("cxnYN", request.getParameter("cxnYN"));
			model.put("fileYN", request.getParameter("fileYN"));
			model.put("teamYN", request.getParameter("teamYN"));
			model.put("rnrYN", request.getParameter("rnrYN"));
			model.put("subItemYN", request.getParameter("subItemYN"));
			model.put("reportCode", StringUtil.checkNull(request.getParameter("reportCode"), ""));
	
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00105")); // DB에 생성된 모델이 없습니다.
			target.put(AJAX_SCRIPT, "parent.goBack();parent.$('#isSubmit').remove();");
			System.out.println("totalList == "+totalList);
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(url);	
	}
	
	/**
	 * 각 아이템 총정보를 취득
	 * @param totalList
	 * @param modelList
	 * @param setMap
	 * @param request
	 * @param commandMap
	 * @param defaultLang
	 * @param languageId
	 * @throws Exception
	 */
	public void getItemTotalInfo(List totalList, List modelList, Map setMap, HttpServletRequest request, HashMap commandMap, String defaultLang, String languageId, String accMode) throws Exception {
		String beforFromItemID = "";
		for (int index = 0; modelList.size() > index; index++) {
			Map map = new HashMap();
			Map totalMap = new HashMap();
			Map subProcessMap = (Map) modelList.get(index);
			Map activityMap = new HashMap();
			
			List cngtList = new ArrayList(); // 변경이력 리스트
			List detailElementList = new ArrayList(); // 연관 프로세스 리스트
			List relItemList = new ArrayList(); // 연관 항목 리스트
			List relItemConList = new ArrayList(); // 연관 항목 Connected Process 리스트 
			List relItemSubList = new ArrayList(); // 연관 항목 sub item 리스트 (L4한정)
			List dimResultList = new ArrayList(); // 디멘션 정보
			List attachFileList = new ArrayList();	//첨부문서 리스트
			List roleList = new ArrayList();	//관련조직 리스트
			List rnrList = new ArrayList();	//rnr 리스트
			List elmObjList = new ArrayList();		// OJ, MOJ 엘리먼트 리스트
			List elementList = new ArrayList(); // element List
			List termList = new ArrayList();
			
			String activityMode = StringUtil.checkNull(setMap.get("activityMode"));
			
			setMap.put("s_itemID", subProcessMap.get("MyItemID"));
			setMap.put("itemId", String.valueOf(subProcessMap.get("MyItemID")));
			setMap.put("sessionCurrLangType", String.valueOf(commandMap.get("sessionCurrLangType")));
			setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			setMap.put("attrTypeCode", commandMap.get("attrTypeCode"));
			
			// Model 정보 취득 
			setMap.remove("ModelTypeCode");
			Map modelMap = new HashMap();
			String modelID = "";
			if (!"0".equals(StringUtil.checkNull(commandMap.get("modelExist")))) {
				setMap.put("MTCategory", request.getParameter("MTCategory"));
				modelMap = commonService.select("report_SQL.getModelIdAndSize", setMap);
				
				// 모델이 DB에 존재 하는 경우, 문서에 표시할 모델 맵 크기를 계산 한다
				// 모델이 DB에 존재 하는 경우, [TB_ELEMENT]에서 선행 /후행 데이터 취득
				if (null != modelMap) {
					setModelMap(modelMap, request);
					Map setMap2 = new HashMap();
					setMap2.put("languageID", languageId);
					if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap"))) && "on".equals(StringUtil.checkNull(setMap.get("occYN")))) {
						// [TB_ELEMENT]에서 선행 /후행 데이터 취득 
						detailElementList = getElementList(setMap2, modelMap);
					}
				}
			}
			
			List attrList = new ArrayList();
			String changeSetID = StringUtil.checkNull(modelMap.get("changeSetID"));
			
			/* 기본정보 취득 */
			List prcList = commonService.selectList("report_SQL.getItemInfo", setMap);
			setMap.put("changeSetID",changeSetID);
			
			if(accMode.equals("OPS")) {
				changeSetID = StringUtil.checkNull(setMap.get("ReleaseNo"));
				setMap.put("changeSetID", changeSetID);
				prcList = commonService.selectList("item_SQL.getItemAttrRevInfo", setMap);
				attrList = commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
			} else {
				attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
			}
			
			/* elementList 취득 */
			if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap"))) && "element".equals(activityMode)) { // QMS 의 경우
				// mdlIF = Y 인 symbolList
				Map setMap2 = new HashMap();
				setMap2.put("s_itemID", subProcessMap.get("MyItemID"));
				setMap2.put("itemID", String.valueOf(subProcessMap.get("MyItemID")));
				setMap2.put("languageID", languageId);
				
				Map modelMap2 = commonService.select("report_SQL.getModelIdAndSize", setMap2);
				modelID = StringUtil.checkNull(modelMap2.get("ModelID"));
				if(accMode.equals("OPS")) {
					modelID = commonService.selectString("model_SQL.getModelIDFromItem", setMap2);
				}
				
				setMap2.put("ModelID",modelID);
				setMap2.put("mdlIF", "Y");
				elementList = commonService.selectList("report_SQL.getObjListOfModel", setMap2);
			}
			
			Map csInfo = commonService.select("cs_SQL.getChangeSetInfo", setMap);
			totalMap.put("csAuthorNM",csInfo.get("AuthorName"));
			totalMap.put("csOwnerTeamNM",csInfo.get("TeamName"));
			
			//=====================================================================================================
			/* 기본정보의 속성 내용을 취득 */
			commandMap.put("ItemID", subProcessMap.get("MyItemID"));
			commandMap.put("DefaultLang", defaultLang);
			
			List activityList = new ArrayList();
			if ("N".equals(StringUtil.checkNull(commandMap.get("onlyMap")))) {
				if(!"OPS".equals(accMode)) attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", commandMap);
				
				Map attrMap = new HashMap();
				Map attrNameMap = new HashMap();
				Map attrHtmlMap = new HashMap();
				String mlovAttrText = "";
				for (int k = 0; attrList.size()>k ; k++ ) {
					map = (Map) attrList.get(k);
					if(!map.get("DataType").equals("MLOV")){
						attrMap.put(map.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4((String) map.get("PlainText")));	// 기본정보의 td
					} else {
						String mlovAttrCode = (String) map.get("AttrTypeCode");
						if(attrMap.get(mlovAttrCode) == null || attrMap.get(mlovAttrCode) == ""){
							mlovAttrText = map.get("PlainText").toString();
						} else {
							mlovAttrText += " / "+map.get("PlainText").toString();
						}
						attrMap.put(mlovAttrCode, mlovAttrText);	
					}
					attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));	// 기본정보의 th
					attrHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
				}

				// Dimension정보 취득 
				List dimInfoList = commonService.selectList("dim_SQL.selectDim_gridList", setMap);
				Map dimResultMap = new HashMap();
				String dimTypeName = "";
				String dimValueNames = "";
				
				if (dimInfoList.size() > 0) {
					for(int i = 0; i < dimInfoList.size(); i++){
						map = (HashMap)dimInfoList.get(i);
						if (i > 0) {
							if(dimTypeName.equals(map.get("DimTypeName").toString())) {
								dimValueNames += " / "+map.get("DimValueName").toString();
							} else {
								dimResultMap.put("dimValueNames", dimValueNames);
								dimResultList.add(dimResultMap);
								dimResultMap = new HashMap(); // 초기화
								dimTypeName = map.get("DimTypeName").toString();
								dimResultMap.put("dimTypeName", dimTypeName);
								dimValueNames = map.get("DimValueName").toString();
							}
						}else{
							dimTypeName = map.get("DimTypeName").toString();
							dimResultMap.put("dimTypeName", dimTypeName);
							dimValueNames = map.get("DimValueName").toString();
						}
					}
				
					dimResultMap.put("dimValueNames", dimValueNames);
					dimResultList.add(dimResultMap);
				}

				Map AttrTypeList = new HashMap();
				if ("on".equals(StringUtil.checkNull(setMap.get("cxnYN")))) {
					// 관련항목 취득 
					relItemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
					
					// 관련항목 connected processed 취득
					setMap.put("showElement", "Y");
					setMap.put("mdlIF", "Y");
					relItemConList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
					setMap.remove("showElement");
					setMap.remove("mdlIF");
					
					// sub item 관련항목 취득 (L4일때만)
					List childItemList = commonService.selectList("item_SQL.getChildItemList_gridList", setMap);
					for(int j=0; j<childItemList.size(); j++){
						Map tmp = (Map) childItemList.get(j);
						Map tmpMap = new HashMap();
						setMap.put("s_itemID", tmp.get("ItemID"));
						tmpMap.put("TreeName",StringUtil.checkNull(tmp.get("TreeName")));
						tmpMap.put("list",commonService.selectList("item_SQL.getCxnItemList_gridList", setMap));
						relItemSubList.add(tmpMap);
					}
					setMap.put("s_itemID", subProcessMap.get("MyItemID"));
					
					List impl = new ArrayList();
					List relItemID = new ArrayList();
					
					for(int j=0; j<relItemList.size(); j++){
						map = (Map) relItemList.get(j);
						impl.add(map.get("ClassCode"));
						relItemID.add(map.get("s_itemID"));
					}
					// 중복제거
					TreeSet relItemClassCode = new TreeSet(impl);
					ArrayList relItemClassCodeList = new ArrayList(relItemClassCode);
					
					// 관련항목 이름 취득
					List relItemNameList = new ArrayList();
					for(int j=0; j<relItemClassCodeList.size(); j++){
						setMap.put("typeCode", relItemClassCodeList.get(j));
						String cnName = commonService.selectString("common_SQL.getNameFromDic", setMap);
						relItemNameList.add(cnName);
					}
					
					// 관련항목 속성 조회
					List relItemAttrbyID = new ArrayList();
					for(int j=0; j<relItemID.size(); j++){
						setMap.put("itemID", relItemID.get(j));
						List temp = commonService.selectList("report_SQL.getItemAttr", setMap);
						relItemAttrbyID.addAll(temp);
					}
					
					// 용어의 정의 리스트
					setMap.put("defaultLang", defaultLang);
					setMap.put("ClassCode", "CL11004");
					setMap.remove("ItemTypeCode");
					termList = commonService.selectList("zSK_SQL.getCxnItemList_gridList", setMap);
					setMap.remove("ClassCode");
					
					totalMap.put("termList",termList);
					totalMap.put("relItemClassCodeList",relItemClassCodeList);
					totalMap.put("relItemNameList", relItemNameList);
					totalMap.put("relItemID", relItemID);
					totalMap.put("relItemAttrbyID", relItemAttrbyID);
				}
				List temp = commonService.selectList("attr_SQL.getItemAttrType", setMap);
				Map AttrTypeListTemp = new HashMap();

				for(int j=0; j<temp.size(); j++){
					AttrTypeListTemp = (Map) temp.get(j);
					AttrTypeList.put(AttrTypeListTemp.get("AttrTypeCode"), AttrTypeListTemp.get("DataType"));
				}
				
				totalMap.put("AttrTypeList", AttrTypeList);
				
				if ("on".equals(StringUtil.checkNull(setMap.get("subItemYN")))) {
					// Activity 정보 취득 
					setMap.put("viewType", "wordReport");
					setMap.put("gubun", "M");
					if ("Y".equals(StringUtil.checkNull(commandMap.get("element")))) {
						setMap.remove("gubun");
					}
					
					if("OPS".equals(accMode)){
						activityMap.put("accMode",accMode);
						activityMap.put("changeSetID",changeSetID);
						activityList = commonService.selectList("item_SQL.getChildItemList_gridList",setMap);
					}else {
						activityList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
					}
					
					activityMap.put("activityMode",activityMode);
					if ("element".equals(activityMode)) { // QMS 의 경우
						setMap.put("modelTypeCode", modelMap.get("ModelTypeCode"));
						String mdlIF = StringUtil.checkNull(request.getParameter("mdlIF"));
						setMap.put("ModelID", modelMap.get("ModelID"));
						setMap.put("mdlIF", mdlIF);
						setMap.put("SymTypeCodes", "'SB00004','SB00007'");
						setMap.put("itemCategory","OJ");
						activityList = commonService.selectList("report_SQL.getObjListOfModel", setMap);
					}
					
					activityList = getActivityAttr(activityList, defaultLang ,languageId, attrNameMap, attrHtmlMap, activityMap); // 액티비티의 속성을 액티비티 리스트에 추가
	
					// Activity 속성명 모두 취득 ( ex) AT00005:수행부서, AT00006:수행주체, AT00013:사용시스템 )
					List activityNames = commonService.selectList("report_SQL.getActivityAttrName", commandMap);
					for (int k = 0; activityNames.size()>k ; k++ ) {
						map = (Map) activityNames.get(k);
						attrNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
					}
					activityMap.remove("activityMode");
				}
				
				totalMap.put("attrMap", attrMap);
				totalMap.put("attrNameMap", attrNameMap);
				totalMap.put("attrHtmlMap", attrHtmlMap);
				
				// 첨부 문서 취득 
				setMap.remove("itemTypeCode");
				setMap.put("DocumentID", String.valueOf(subProcessMap.get("MyItemID")));
				if ("on".equals(StringUtil.checkNull(setMap.get("fileYN")))) {
					if("OPS".equals(accMode)) {
						setMap.remove("changeSetID");
						attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
						setMap.put("changeSetID",changeSetID);
					} else {
						attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
					}
					
				}
				
				if("OPS".equals(accMode)){
					setMap.put("asgnOption", "2,3"); //해제,신규 미출력
					setMap.put("cngStatus", "CLS"); //상태 : 완료
				} else {
					setMap.put("asgnOption", "1,2"); //해제,해제중 미출력
				}
				
				//if ("on".equals(StringUtil.checkNull(setMap.get("teamYN")))) {
					setMap.put("itemID", subProcessMap.get("MyItemID"));
					roleList = commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setMap);
				//}
				
				if ("on".equals(StringUtil.checkNull(setMap.get("csYN")))) {
					cngtList = commonService.selectList("report_SQL.getItemChangeListRPT", setMap);
				}
				
				if ("on".equals(StringUtil.checkNull(setMap.get("rnrYN")))) {
					if("2".equals(StringUtil.checkNull(setMap.get("rnrOption")))) { // 엘리먼트 리스트
						String elmClassLists[] = StringUtil.checkNull(setMap.get("elmClassList")).split(",");
						String classCodes = "";
						for(int i=0; i<elmClassLists.length; i++) {
							if(i == 0){
								classCodes = "'"+elmClassLists[i]+"'";
							}else{
								classCodes = classCodes+",'"+elmClassLists[i]+"'";
							}
						}
						setMap.put("elmClassList", classCodes);
					}
					List rnrTotalList = commonService.selectList("role_SQL.getSubItemTeamRoleTreeGList", setMap);
					
					for(int j=0; j<rnrTotalList.size(); j++){
						Map rnrInfo = (Map) rnrTotalList.get(j);
						AttrTypeList.put(AttrTypeListTemp.get("AttrTypeCode"), AttrTypeListTemp.get("DataType"));
						setMap.put("itemID", rnrInfo.get("ItemID"));
						List subItemRoleList = commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setMap);
						rnrInfo.put("teamInfo",subItemRoleList);
						rnrList.add(rnrInfo);
					}
				}
				
				setMap.remove("asgnOption");
				setMap.remove("cngStatus");
				
				setMap.put("refModelID", modelMap.get("ModelID"));
				elmObjList = commonService.selectList("model_SQL.getElmtsObjectList_gridList", setMap);
				elmObjList = getActivityAttr(elmObjList, defaultLang ,languageId, attrNameMap, attrHtmlMap,activityMap);
			}
			
			totalMap.put("prcList", prcList);								// 기본정보
			totalMap.put("modelMap", modelMap);				// 업무처리 절차
			totalMap.put("dimResultList", dimResultList);	// 기본정보(Dimension)
			totalMap.put("cngtList", cngtList);							// 변경이력
			totalMap.put("elementList", detailElementList);	// 선/후행 Process
			totalMap.put("relItemList", relItemList);				// 관련항목
			totalMap.put("relItemConList", relItemConList);			// 관련항목 connected process
			totalMap.put("relItemSubList", relItemSubList); 			// 관련항목 sub item
			totalMap.put("attachFileList", attachFileList);		// 첨부문서 목록
			totalMap.put("roleList", roleList);							// 관련조직 목록
			totalMap.put("activityList", activityList);				// 액티비티 목록
			totalMap.put("rnrList", rnrList);								// R&R 목록
			totalMap.put("elmObjList", elmObjList);				// 엘리먼트 OJ, MOJ 목록
			totalMap.put("elementObjList", elementList);				// 엘리먼트 목록
			totalList.add(index, totalMap);
		}
	}
	
	/**
	 * 계층별 (L1, L2, L3), 아이템의 L3, L4 리스트를 (ID + 명칭) 으로 취득
	 * @param commandMap
	 * @param arrayStr
	 * @throws Exception
	 */
	public List getChildItemList(CommonService commonService, String selectedItemId, String classCode, String languageID, String outPutItems, String delItemsYN) throws Exception {
		List list0 = new ArrayList();
		List list1 = new ArrayList();
		List l3l4ItemIdList = new ArrayList();
		Map lowLankItemIdMap = new HashMap();
		List subTreeItemIDList = new ArrayList();
		Map map0 = new HashMap();
		Map map1 = new HashMap();
		Map setMap = new HashMap();
		
		String itemId = selectedItemId;
		String toItemId = "";
		setMap.put("delItemsYN", delItemsYN);
		if (!outPutItems.isEmpty()) {
			setMap.put("CURRENT_ToItemID", outPutItems); // Dimension tree인 경우
		}
		
		if ("CL01001".equals(classCode)) {
			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
			setMap.put("CategoryCode", "ST1");
			setMap.put("languageID", languageID);
			setMap.put("toItemClassCode", "CL01002");
			list0 = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
		} else if ("CL01002".equals(classCode)) { // L2
			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
			setMap.put("CategoryCode", "ST1");
			setMap.put("languageID", languageID);
			setMap.put("toItemClassCode", "CL01004");
			list1 = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
		} else if ("CL01004".equals(classCode)) { // L3
			setMap.put("languageID", languageID);
			setMap.put("s_itemID", itemId);
			list1 = commonService.selectList("report_SQL.itemStDetailInfo", setMap);
			map1 = (Map) list1.get(0);
			map1.put("ToItemID", itemId);
			map1.put("toItemIdentifier", map1.get("Identifier"));
			map1.put("toItemName", map1.get("ItemName"));
			list1 = new ArrayList();
			list1.add(map1);
		}
		
		if (list0.size() > 0) {
			for (int i = 0; list0.size() > i; i++){
				lowLankItemIdMap = new HashMap();
				l3l4ItemIdList = new ArrayList();
				map0 = (Map) list0.get(i);
				
				String l2Name = removeAllTag(StringUtil.checkNull(map0.get("toItemName")));
				String l2Item = StringUtil.checkNull(map0.get("toItemIdentifier") + " " + l2Name);
				
				setMap.put("CURRENT_ITEM", map0.get("ToItemID")); // 해당 아이템이 [FromItemID]인것
				setMap.put("toItemClassCode", "CL01004");
				setMap.put("outPutItems",outPutItems);
				list1 = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
				lowLankItemIdMap.put("l2Item", l2Item);
				getL3l4ContentsList(list1, l3l4ItemIdList, setMap);
				lowLankItemIdMap.put("l3l4ItemIdList", l3l4ItemIdList);
				subTreeItemIDList.add(lowLankItemIdMap);
			}
		} else {
			lowLankItemIdMap = new HashMap();
			l3l4ItemIdList = new ArrayList();
			getL3l4ContentsList(list1, l3l4ItemIdList, setMap);
			lowLankItemIdMap.put("l2Item", "");
			lowLankItemIdMap.put("l3l4ItemIdList", l3l4ItemIdList);
			subTreeItemIDList.add(lowLankItemIdMap);
		}
		
		return subTreeItemIDList;
	}
	
	/**
	 * 아이템의 L3, L4 리스트를 (ID + 명칭) 으로 취득
	 * @param commandMap
	 * @param arrayStr
	 * @throws Exception
	 */
	private void getL3l4ContentsList(List list1, List l3l4ItemIdList, Map setMap) throws Exception {
		List l4ItemList = new ArrayList();
		Map l3l4ItemIdMap = new HashMap();
		
		for (int k = 0; list1.size() > k; k++) {
			l4ItemList = new ArrayList();
			l3l4ItemIdMap = new HashMap();
			
			Map map1 = (Map) list1.get(k);
			
			String l3Name = removeAllTag(StringUtil.checkNull(map1.get("toItemName")));
			String l3Item = StringUtil.checkNull(map1.get("toItemIdentifier") + " " + l3Name);
			 
			setMap.put("CURRENT_ITEM", map1.get("ToItemID")); // 해당 아이템이 [FromItemID]인것
			setMap.put("toItemClassCode", "CL01005");
			List list2 = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
		 
			for (int m = 0; list2.size() > m; m++) {
				Map map2 = (Map) list2.get(m);
				String l4Name = removeAllTag(StringUtil.checkNull(map2.get("toItemName")));
				l4ItemList.add(StringUtil.checkNull(map2.get("toItemIdentifier") + " " + l4Name));
			}
		 
			l3l4ItemIdMap.put("l3Item", l3Item);
			l3l4ItemIdMap.put("l4ItemList", l4ItemList);
			l3l4ItemIdList.add(l3l4ItemIdMap);
		}
	}
	
	/**
	 * Model의 선행/후행 process 취득 
	 * @param setMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	private List getElementList(Map setMap2, Map modelMap) throws Exception {
		List returnList = new ArrayList();
		
		// mdlIF = Y 인 symbolList
		setMap2.put("mdlIF","Y");
		setMap2.put("modelTypeCode", modelMap.get("ModelTypeCode"));
		List symbolList = commonService.selectList("model_SQL.getSymbolTypeList", setMap2);
		
		String SymTypeCodes = "";
		for(int i=0; i<symbolList.size(); i++) {
			Map map = (Map) symbolList.get(i);
			if(i != 0) SymTypeCodes += ",";
			SymTypeCodes += "'"+map.get("SymTypeCode")+"'";
		}
		
		/* [TB_ELEMENT]에서 선행 /후행 데이터 취득 */
		setMap2.remove("FromID");
		setMap2.remove("ToID");
		setMap2.put("ModelID", modelMap.get("ModelID"));
		setMap2.put("SymTypeCodes", SymTypeCodes);
		List elementList = commonService.selectList("report_SQL.getObjListOfModel", setMap2);
		
		for (int i = 0 ; elementList.size()> i ; i++) {
			Map returnMap = new HashMap();
			Map elementMap = (Map) elementList.get(i);
			String elementId = String.valueOf(elementMap.get("ElementID"));
			String objectId = String.valueOf(elementMap.get("ObjectID"));
			
			returnMap = elementMap;
			returnMap.put("RNUM", i + 1);
						
			// 선행, 후행 아이템의 Item Info 취득
			setMap2.put("s_itemID", objectId);
			Map itemInfoMap = commonService.select("report_SQL.getItemInfo", setMap2);
			returnMap.put("ID", itemInfoMap.get("Identifier"));
			returnMap.put("Name", itemInfoMap.get("ItemName"));
			returnMap.put("Description", StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(itemInfoMap.get("Description"),"")));
			
			returnList.add(returnMap);
		}
				
		return returnList;
	}
	
	/**
	 * 모델 정보 취득
	 * @param modelMap
	 * @param request
	 */
	public void setModelMap(Map modelMap, HttpServletRequest request) {
		// model size 조정
		int width = 546;
		int height = 580;
		int actualWidth = 0;
		int actualHeight = 0;
		int zoom = 100;
		
		/* 문서에 표시할 모델 맵 크기를 계산 한다 */
		if ("2".equals(request.getParameter("paperSize"))) {
			width = 700;
			height = 930;
 		}
		
		actualWidth = Integer.parseInt(StringUtil.checkNull(modelMap.get("Width"), String.valueOf(width)));
		actualHeight = Integer.parseInt(StringUtil.checkNull(modelMap.get("Height"), String.valueOf(height)));
		
		if (width < actualWidth || height < actualHeight) {
			for (int i = 99 ; i > 1 ; i-- ) {
				actualWidth = (actualWidth * i) / 100;
				actualHeight = (actualHeight * i) / 100;
				if( width > actualWidth && height > actualHeight ){
					zoom = i; 
					break;
				}
			}
		}
		
		modelMap.remove("Width");
		modelMap.remove("Height");
		modelMap.put("Width", actualWidth);
		modelMap.put("Height", actualHeight);
		System.out.println("Width=="+actualWidth);
		System.out.println("Height=="+actualHeight);
	}
	
	/**
	 * 액티비티 속성 정보 취득
	 * @param List
	 * @param defaultLang
	 * @param sessionCurrLangType
	 * @return
	 * @throws Exception
	 */
	private List getActivityAttr(List List, String defaultLang, String sessionCurrLangType,Map attrNameMap, Map attrHtmlMap, Map activityMap) throws Exception {
		List resultList = new ArrayList();
		Map setMap = new HashMap();
		List actToCheckList = new ArrayList();
		List actRuleSetList = new ArrayList();
		List actSystemList = new ArrayList();
		List actRoleList = new ArrayList();
		List actITSystemList = new ArrayList(); // 연관항목 리스트 출력
		List actTeamRoleList = new ArrayList(); // 관련조직 리스트 출력
		List actPrcList = new ArrayList(); // QMS 용 기본정보
		
		String accMode = String.valueOf(activityMap.get("accMode"));
		String changeSetID = String.valueOf(activityMap.get("changeSetID"));
		String activityMode = StringUtil.checkNull(activityMap.get("activityMode"));
		
		setMap.put("DefaultLang", defaultLang);
		setMap.put("sessionCurrLangType", sessionCurrLangType);
		setMap.put("languageID", sessionCurrLangType);
		
		for (int i = 0; i < List.size(); i++) {
			Map listMap = new HashMap();
			listMap = (Map) List.get(i);
			String itemId = String.valueOf(listMap.get("ItemID"));
			
			// QMS&E2E의 경우
			if ("element".equals(activityMode)) {
				itemId = String.valueOf(listMap.get("ObjectID"));
				setMap.put("itemId", itemId);
				setMap.put("s_itemID", itemId);
				
				changeSetID = commonService.selectString("cs_SQL.getChangeSetID", setMap);
				actPrcList = commonService.selectList("report_SQL.getItemInfo", setMap);
				
				for(int j=0; j < actPrcList.size(); j++) {
					Map actInfo = (Map) actPrcList.get(j);
					if(actInfo.containsKey("OwnerTeamID")) {
						setMap.put("teamID", StringUtil.checkNull(actInfo.get("OwnerTeamID")));
						Map managerInfo = commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
						listMap.put("ownerTeamMngNM",managerInfo.get("MemberName"));	// 프로세스 책임자
						setMap.remove("teamID");
					}
				}
				if (accMode.equals("OPS")) {
					changeSetID = commonService.selectString("item_SQL.getItemReleaseNo", setMap);
					setMap.put("changeSetID", changeSetID);
					actPrcList = commonService.selectList("item_SQL.getItemAttrRevInfo", setMap);
				}
			}
			listMap.put("actPrcList", actPrcList);
			
			setMap.put("ItemID", itemId);
			
			List attrList = new ArrayList();
			if(accMode.equals("OPS")) {
				setMap.put("changeSetID", changeSetID);
				setMap.put("s_itemID", itemId);
				setMap.put("defaultLang", defaultLang);
				attrList = commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
				setMap.remove(changeSetID);
			} else {
				attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
			}
			
			for (int k = 0; attrList.size()>k ; k++ ) {
				Map map = (Map) attrList.get(k);
				String plainText = "";
				if(map.get("DataType").equals("MLOV")){
					plainText = getMLovVlaue(sessionCurrLangType, itemId, StringUtil.checkNull(map.get("AttrTypeCode")));
					listMap.put(map.get("AttrTypeCode"), plainText);
				}else{
					if(StringUtil.checkNull(map.get("HTML"),"").equals("1")) {
						listMap.put(map.get("AttrTypeCode"), StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("PlainText"))));
					} else {
						listMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
					}
				}
			}
			
			/*Activity Rule Set 취득  Rule Group의 하위항목 Rule set list 취득 */
			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
			setMap.put("itemTypeCode", "CN00107");
			actRuleSetList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			/* Rule set list의 연관 프로세스 && 속성 정보 취득 */			
			actRuleSetList = getConItemInfo(actRuleSetList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00107", "ToItemID");
			listMap.put("actRuleSetList", actRuleSetList);
			setMap.remove("CURRENT_ITEM");
			
			//ToCheck 취득 
			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [ToItemID]인것
			setMap.put("itemTypeCode", "CN00109");			
			actToCheckList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			// Activity ToCheck list의 연관 프로세스 && 속성 정보 취득 
			actToCheckList = getConItemInfo(actToCheckList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00109", "ToItemID");
			listMap.put("actToCheckList", actToCheckList);
			setMap.remove("CURRENT_ITEM");
			
			//System 취득 
			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [ToItemID]인것
			setMap.put("itemTypeCode", "CN00104");			
			actSystemList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			// Activity system list의 연관 프로세스 && 속성 정보 취득 
			actSystemList = getConItemInfo(actSystemList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00104", "ToItemID");
			listMap.put("actSystemList", actSystemList);
			setMap.remove("CURRENT_ITEM");
			
			//연관항목 취득
			setMap.put("s_itemID", itemId);
			actITSystemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
			listMap.put("actITSystemList", actITSystemList);
			
			// Role 취득 
			setMap.put("CURRENT_ToItemID", itemId); 
			setMap.put("itemTypeCode", "CN00201");			
			actRoleList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			// Activity Role list의 연관 프로세스 && 속성 정보 취득 
			actRoleList = getConItemInfo(actRoleList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00201", "FromItemID");
			listMap.put("actRoleList", actRoleList);
			setMap.remove("CURRENT_ToItemID");
						
			// 관련조직 취득 
			setMap.put("itemID", itemId);
			if("OPS".equals(accMode)){
				setMap.put("asgnOption", "2,3"); //해제,신규 미출력
			} else {
				setMap.put("asgnOption", "1,2"); //해제,해제중 미출력
			}
			actTeamRoleList = commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setMap);
			listMap.put("actTeamRoleList", actTeamRoleList);
			
			resultList.add(listMap);
		}
		
		return resultList;
	}
	
	private String getMLovVlaue(String languageID, String itemID, String attrTypeCode) throws Exception {
		List mLovList = new ArrayList();
		Map setMap = new HashMap();
		String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
		setMap.put("languageID", languageID);
		setMap.put("defaultLang", defaultLang);	
		setMap.put("itemID", itemID);
		setMap.put("attrTypeCode", attrTypeCode);
		mLovList = commonService.selectList("attr_SQL.getMLovList",setMap);
		String plainText = "";
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
		return plainText;
	}
	
	/**
     * Connection 의 Info 정보 취득
     * @param List
     * @param defaultLang
     * @param sessionCurrLangType
     * @return
     * @throws Exception
     */
    private List getConItemInfo(List List, String defaultLang, String sessionCurrLangType, Map attrRsNameMap, Map attrRsHtmlMap, String cnTypeCode , String source) throws Exception {
        List resultList = new ArrayList();
        Map setMap = new HashMap();
        
        for (int i = 0; i < List.size(); i++) {
            Map listMap = new HashMap();
            List resultSubList = new ArrayList();
            
            listMap = (Map) List.get(i);
            String itemId = String.valueOf(listMap.get(source));
            
            setMap.put("ItemID", itemId);
            setMap.put("DefaultLang", defaultLang);
            setMap.put("sessionCurrLangType", sessionCurrLangType);
            List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
            
            String plainText = "";
            for (int k = 0; attrList.size()>k ; k++ ) {
                Map map = (Map) attrList.get(k);                
                attrRsNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
                attrRsHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
                if(map.get("DataType").equals("MLOV")){
                    plainText = getMLovVlaue(sessionCurrLangType, itemId, StringUtil.checkNull(map.get("AttrTypeCode")));
                    listMap.put(map.get("AttrTypeCode"), plainText);
                }else{
                    listMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
                }
            }
            
            String isFromItem = "Y";
            if(!source.equals("FromItemID")){ isFromItem = "N"; }
            setMap.put("varFilter", cnTypeCode);
            setMap.put("languageID", sessionCurrLangType);
            setMap.put("isFromItem", isFromItem);
            setMap.put("s_itemID", itemId);
            List relatedAttrList = new ArrayList();
//            List cnItemList = commonService.selectList("item_SQL.getCXNItems", setMap);
        
//            for (int k = 0; cnItemList.size()>k ; k++ ) {
//                Map map = (Map) cnItemList.get(k);
            if(isFromItem.equals("Y")){
                resultSubList.add(StringUtil.checkNull(listMap.get("fromItemIdentifier")) + " " + removeAllTag(StringUtil.checkNull(listMap.get("fromItemName"))));
            } else {
                resultSubList.add(StringUtil.checkNull(listMap.get("toItemIdentifier")) + " " + removeAllTag(StringUtil.checkNull(listMap.get("toItemName"))));
            }
                setMap.put("ItemID", listMap.get("FromItemID"));
                setMap.put("DefaultLang", defaultLang);
                setMap.put("sessionCurrLangType", sessionCurrLangType);
                relatedAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
                if(relatedAttrList.size()>0){
                    for(int m=0; m<relatedAttrList.size(); m++){
                        Map relAttrMap = (Map) relatedAttrList.get(m);                            
                        resultSubList.add(StringUtil.checkNull(relAttrMap.get("Name")));
                        resultSubList.add(StringUtil.checkNull(relAttrMap.get("PlainText")));
                        resultSubList.add(StringUtil.checkNull(relAttrMap.get("HTML")));
                    }
                }
//            }
            listMap.put("resultSubList", resultSubList);        
            
            resultList.add(listMap);
        }
        
        return resultList;
    }
    
	// TODO : 개행 코드 삭제
	private String removeAllTag(String str) {
		str = str.replaceAll("\n", "&&rn");//201610 new line :: Excel To DB 
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");
		//return str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");
		return StringEscapeUtils.unescapeHtml4(str);
	}
	private String removeAllTag(String str,String type) { 
		if(type.equals("DbToEx")){//201610 new line :: DB To Excel
			str = str.replaceAll("\r\n", "&&rn").replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&#40;", "(").replaceAll("&#41;", ")").replace("&sect;","-").replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn");
		}else{
			str = str.replaceAll("\n", "&&rn");//201610 new line :: Excel To DB 
		}
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");
		if(type.equals("DbToEx")){
			str = str.replaceAll("&&rn", "\n");
		}
		//return str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");
		return StringEscapeUtils.unescapeHtml4(str);
	}	

}