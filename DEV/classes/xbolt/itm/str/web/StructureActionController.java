package xbolt.itm.str.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.org.json.JSONArray;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

/**
 * 업무 처리
 * 
 * @Class Name : BizController.java
 * @Description : 업무화면을 제공한다.
 * @Modification Information
 * @수정일 수정자 수정내용 @--------- --------- ------------------------------- @2012. 09.
 *      01. smartfactory 최초생성
 *
 * @since 2012. 09. 01.
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")
public class StructureActionController extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "CSService")
	private CommonService CSService;

	@Resource(name = "mdItemService")
	private CommonService mdItemService;
	
	@Resource(name = "itemMasterService")
	private CommonService itemMasterService;
	
	@Resource(name = "CxnItemService")
	private CommonService CxnItemService;

	@RequestMapping(value = "/subMenu.do")
	public String subMenu(HttpServletRequest request, ModelMap model) throws Exception {
		// model.put(AJAX_RESULTMAP, commonService.selectList("menu_SQL.contentMenu",
		// commandMap));

		// 메뉴 받아오기용 language값 넣기
		Map setMap = new HashMap();
		setMap.put("languageID", request.getParameter("languageID"));

		String filter = StringUtil.checkNull(request.getParameter("filter"), "");

		setMap = new HashMap();
		Map getMap = new HashMap();
		model.put("menu", getLabel(request, commonService)); /* Label Setting */

		setMap = new HashMap();
		setMap.put("ModelID", StringUtil.checkNull(request.getParameter("subID"), request.getParameter("s_itemID")));

		// setMap.put("s_itemID", request.getParameter("s_itemID") );
		setMap.put("s_itemID", StringUtil.checkNull(request.getParameter("subID"), request.getParameter("s_itemID")));

		// String modelID =
		// StringUtil.checkNull(commonService.selectString("model_SQL.getTopModelID",
		// setMap),"0");

		model.put("filter", filter);
		// model.put("modelID", modelID );
		model.put("itemID", StringUtil.checkNull(request.getParameter("itemID"), ""));

		String Url = "//subMenu//" + request.getParameter("url");

		String setID = StringUtil.checkNull(request.getParameter("subID"), request.getParameter("s_itemID"));

		if (StringUtil.checkNull(request.getParameter("url"), "").equals("objectChildMenu")) {
			// TB_ITEM_CLASS 의 HasCop, HasDemention 값 가져오기
			getMap = commonService.select("menu_SQL.tabCheck", setMap);
			model.put("tabCheck", getMap);
		} else if (request.getParameter("url").equals("processChildMenu")) {
			// Occ테이블과 element테이블의 ObjectID 값 유무 확인

			setID = StringUtil.checkNull(request.getParameter("subID"), "");
			getMap = commonService.select("menu_SQL.tabCheck", setMap);
			model.put("tabCheck", getMap);
			// TODO: CBO Master Program Status 화면 제어
			model.put("classCode", StringUtil.checkNull(request.getParameter("classCode"), ""));
		}

		// System.out.println("setID = "+setID);

		model.put("parentID", StringUtil.checkNull(request.getParameter("parentID"), ""));
		model.put("s_itemID", setID);
		model.put("subID", StringUtil.checkNull(request.getParameter("subID"), ""));

		// minmap용
		model.put("getWidth", StringUtil.checkNull(request.getParameter("getWidth"), "0"));
		model.put("pop", StringUtil.checkNull(request.getParameter("pop"), ""));

		// ArcCode
		model.put("option", StringUtil.checkNull(request.getParameter("option"), ""));
		// 모델편집 속성팝업용
		model.put("screenType", StringUtil.checkNull(request.getParameter("screenType"), ""));
		model.put("screenMode", StringUtil.checkNull(request.getParameter("screenType"), ""));
		model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode"), ""));
		model.put("MTCategory", StringUtil.checkNull(request.getParameter("MTCategory"), ""));
		model.put("ModelStatus", StringUtil.checkNull(request.getParameter("ModelStatus"), ""));
		model.put("Creator", StringUtil.checkNull(request.getParameter("Creator"), ""));
		model.put("CreationTime", StringUtil.checkNull(request.getParameter("CreationTime"), ""));
		model.put("UserName", StringUtil.checkNull(request.getParameter("UserName"), ""));
		model.put("LastUpdated", StringUtil.checkNull(request.getParameter("LastUpdated"), ""));
		model.put("ModelStatusCode", StringUtil.checkNull(request.getParameter("ModelStatusCode"), ""));
		model.put("ModelTypeName", StringUtil.checkNull(request.getParameter("ModelTypeName"), ""));
		model.put("modelName", StringUtil.checkNull(request.getParameter("modelName"), ""));
		model.put("attrRevYN", StringUtil.checkNull(request.getParameter("attrRevYN"), ""));
		model.put("changeSetID", StringUtil.checkNull(request.getParameter("changeSetID"), ""));

		return nextUrl(Url);
	}

	@RequestMapping(value = "/subItemList.do")
	public String subItemList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		try {
			List returnData = new ArrayList();
			HashMap OccAttrInfo = new HashMap();
			String s_itemID = StringUtil.
					replaceFilterString(StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			

			model.put("s_itemID", s_itemID);
			model.put("option", request.getParameter("option"));
			OccAttrInfo.put("languageID", commandMap.get("sessionCurrLangType"));
			OccAttrInfo.put("s_itemID", s_itemID);
			OccAttrInfo.put("option", request.getParameter("option"));
			returnData = commonService.selectList("item_SQL.getClassOption", OccAttrInfo);
			model.put("classOption", returnData);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			OccAttrInfo.put("SelectMenuId", request.getParameter("option"));
			String fiterType = StringUtil
					.checkNull(commonService.selectString("menu_SQL.selectArcFilter", OccAttrInfo));
			String treeDataFilterd = StringUtil
					.checkNull(commonService.selectString("menu_SQL.selectArcTreeDataFiltered", OccAttrInfo));
			model.put("filterType", fiterType);
			model.put("TreeDataFiltered", treeDataFilterd);

			// Login user editor 권한 추가
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
			Map itemAuthorMap = commonService.select("project_SQL.getItemAuthorIDAndLockOwner", OccAttrInfo);
//			if (StringUtil.checkNull(itemAuthorMap.get("AuthorID"))
//					.equals(StringUtil.checkNull(commandMap.get("sessionUserId")))
//					|| StringUtil.checkNull(itemAuthorMap.get("LockOwner")).equals(
//							StringUtil.checkNull(commandMap.get("sessionUserId")))
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);

			// [ADD],[Del] 버튼 제어
			String blocked = StringUtil.checkNull(itemAuthorMap.get("Blocked"));
			if (!"0".equals(blocked)) {
				model.put("blocked", "Y");
			}

			/* 선택된 아이템의 해당 CSR 리스트를 취득 */
			OccAttrInfo.put("AuthorID", commandMap.get("sessionUserId"));
			returnData = commonService.selectList("project_SQL.getCsrListWithMember", OccAttrInfo);
			model.put("csrOption", returnData);

			// pop up 창에서 편집 버튼 제어 용
			String pop = StringUtil.
					replaceFilterString(StringUtil.checkNull(request.getParameter("pop"), ""));
			model.put("pop", pop);
			String showElement = StringUtil.checkNull(commandMap.get("showElement"));
			String showTOJ = StringUtil.
					replaceFilterString(StringUtil.checkNull(commandMap.get("showTOJ")));
			OccAttrInfo = new HashMap();
			OccAttrInfo.put("arcCode", request.getParameter("option"));
			model.put("sortOption",
					StringUtil.checkNull(commonService.selectString("menu_SQL.getArcSortOption", OccAttrInfo)));
			OccAttrInfo = new HashMap();
			OccAttrInfo.put("s_itemID", s_itemID);
			model.put("itemTypeCode", commonService.selectString("item_SQL.getItemTypeCode", OccAttrInfo));
			model.put("showTOJ", showTOJ);
			model.put("showElement", showElement);
			model.put("addOption", StringUtil.checkNull(commandMap.get("addOption")));

			String classCode = StringUtil.checkNull(request.getParameter("classCode"));
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
			String dimTypeList = StringUtil.checkNull(request.getParameter("dimTypeList"));

			model.put("classCode", classCode);
			model.put("fltpCode", fltpCode);
			model.put("dimTypeList", dimTypeList);

			OccAttrInfo.put("s_itemID", s_itemID);
			OccAttrInfo.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			OccAttrInfo.put("option", StringUtil.checkNull(request.getParameter("option")));
			OccAttrInfo.put("filterType", fiterType);
			OccAttrInfo.put("TreeDataFiltered", treeDataFilterd);
			OccAttrInfo.put("showTOJ", showTOJ);
			OccAttrInfo.put("showElement", showElement);
			OccAttrInfo.put("sessionParamSubItems", StringUtil.checkNull(commandMap.get("sessionParamSubItems")));

			String accMode = StringUtil.
					replaceFilterString(StringUtil.checkNull(commandMap.get("accMode")));
			OccAttrInfo.put("accMode", StringUtil.checkNull(commandMap.get("accMode")));
			model.put("accMode", accMode);

			List subItemList = null;
			// accMode가 OPS 일때 search 기능x
			if ("OPS".equals(accMode)) {
				subItemList = commonService.selectList("item_SQL.getChildItemList_gridList", OccAttrInfo);
			} else {
				subItemList = commonService.selectList("item_SQL.getSubItemList_gridList", OccAttrInfo);
			}

			JSONArray gridData = new JSONArray(subItemList);
			model.put("gridData", gridData);

		} catch (Exception e) { 
			System.out.println(e.toString());
		}
		return nextUrl("/itm/structure/subItemList");
	}

	@RequestMapping(value = "/itemCompositionMgt.do")
	public String itemCompositionMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {

			String varFilter = StringUtil.checkNull(request.getParameter("varFilter"));
			setMap.put("varFilter", varFilter);
			Map fromToItemMap = commonService.select("organization_SQL.getFromToItemTypeCode", setMap);

			String toItemTypeCode = StringUtil.checkNull(fromToItemMap.get("ToItemTypeCode"));

			model.put("ItemTypeCode", toItemTypeCode);

			List returnData = new ArrayList();
			HashMap OccAttrInfo = new HashMap();
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");

			model.put("s_itemID", s_itemID);
			model.put("option", request.getParameter("option"));
			OccAttrInfo.put("languageID", commandMap.get("sessionCurrLangType"));
			OccAttrInfo.put("s_itemID", s_itemID);
			OccAttrInfo.put("option", request.getParameter("option"));
			returnData = commonService.selectList("item_SQL.getClassOption", OccAttrInfo);
			model.put("classOption", returnData);
			OccAttrInfo.put("TeamType", "2");
			returnData = commonService.selectList("organization_SQL.getTeamList", OccAttrInfo);
			model.put("companyOption", returnData);
			OccAttrInfo.put("TeamType", "4");
			returnData = commonService.selectList("organization_SQL.getTeamList", OccAttrInfo);
			model.put("ownerTeamOption", returnData);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			OccAttrInfo.put("SelectMenuId", request.getParameter("option"));
			model.put("filterType", commonService.selectString("menu_SQL.selectArcFilter", OccAttrInfo));
			model.put("TreeDataFiltered",
					commonService.selectString("menu_SQL.selectArcTreeDataFiltered", OccAttrInfo));
			// model.put("cxnItemTypeList",
			// StringUtil.checkNull(request.getParameter("varFilter")));

			// Login user editor 권한 추가
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
			Map itemAuthorMap = commonService.select("project_SQL.getItemAuthorIDAndLockOwner", OccAttrInfo);

//			if (StringUtil.checkNull(itemAuthorMap.get("AuthorID"))
//					.equals(StringUtil.checkNull(commandMap.get("sessionUserId")))
//					|| StringUtil.checkNull(itemAuthorMap.get("LockOwner")).equals(
//							StringUtil.checkNull(commandMap.get("sessionUserId")))
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);

			// [ADD],[Del] 버튼 제어
			String blocked = StringUtil.checkNull(itemAuthorMap.get("Blocked"));
			if (!"0".equals(blocked)) {
				model.put("blocked", "Y");
			}

			/* 선택된 아이템의 해당 CSR 리스트를 취득 */
			OccAttrInfo.put("AuthorID", commandMap.get("sessionUserId"));
			returnData = commonService.selectList("project_SQL.getCsrListWithMember", OccAttrInfo);
			model.put("csrOption", returnData);

			setMap.put("s_itemID", request.getParameter("s_itemID"));
			Map itemInfoMap = commonService.select("project_SQL.getItemInfo", setMap);
			model.put("selectedItemStatus", StringUtil.checkNull(itemInfoMap.get("Status")));
			model.put("selectedItemBlocked", StringUtil.checkNull(itemInfoMap.get("Blocked")));
			// pop up 창에서 편집 버튼 제어 용
			model.put("pop", StringUtil.checkNull(request.getParameter("pop"), ""));
			model.put("cxnItemTypeCode", varFilter);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/itm/structure/itemCompositionMgt");
	}

	/**
	 * [하위항목] Move
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/changeItemParent.do")
	public String changeItemParent(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
		try {
			String getItems = StringUtil.checkNull(request.getParameter("items"), "");
			String[] arrayStr = getItems.split(",");

			/* Move */
			if (arrayStr != null) {
				for (int i = 0; i < arrayStr.length; i++) {
					String s_itemIDs = arrayStr[i];
					setMap = new HashMap();
					setMap.put("FromItemID", s_itemID);
					setMap.put("ToItemID", s_itemIDs);

					setMap.put("setFromItemID", request.getParameter("fromItemID"));
					commonService.update("item_SQL.updateCxnItem", setMap);
				}
			}

			/* Update TB_ITEM Status */
			HashMap updateCommandMap = new HashMap();
			updateCommandMap.put("s_itemIDs", getItems);
			updateCommandMap.put("LastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
			commonService.update("project_SQL.updateItemStatus", updateCommandMap);

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
																													// 성공
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();this.fnReload()");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류
																													// 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	/**
	 * [하위항목] Add--> 신규생성 Save
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/createItem.do")
	public String creteItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		Map insertCngMap = new HashMap();
		Map updateData = new HashMap();
		HashMap target = new HashMap();
		try {

			Map setValue = new HashMap();
			String identifier = StringUtil.checkNull(request.getParameter("newIdentifier"));
			//String autoID = StringUtil.checkNull(request.getParameter("autoID"));
			//String preFix = StringUtil.checkNull(request.getParameter("preFix"));
			String cpItemID = StringUtil.checkNull(request.getParameter("cpItemID"));
			//String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			//String fromItemID = StringUtil.checkNull(request.getParameter("fromItemID"));
			//String mstSTR = StringUtil.checkNull(request.getParameter("mstSTR"));
			//String strType = StringUtil.checkNull(request.getParameter("strType"));
			//String cxnItemType = StringUtil.checkNull(request.getParameter("cxnItemType"));
			//String strItemTypeCode = StringUtil.checkNull(request.getParameter("strItemTypeCode"));
			//String mstItemTypeCode = StringUtil.checkNull(request.getParameter("mstItemTypeCode"));
			//String strLevel = StringUtil.checkNull(request.getParameter("strLevel"));
			//String structureID = StringUtil.checkNull(request.getParameter("structureID"));
			//String mstItemID = StringUtil.checkNull(request.getParameter("mstItemID"));

			setValue.put("ItemID", request.getParameter("s_itemID"));
			setValue.put("Identifier", identifier);

			/* Identifier unique check */
			String itemCount = "0";
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
			if (!identifier.isEmpty()) {
				itemCount = commonService.selectString("attr_SQL.identifierEqualCount", setValue);
			}

			// 동일 ID 중복 시 팝업 창에 중복된 Item의 "항목계층명/경로/명칭"을 출력해 줌
			if (!itemCount.equals("0")) {
				setValue.put("languageID", commandMap.get("sessionCurrLangType"));
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00081",
						new String[] { commonService.selectString("attr_SQL.getEqualIdentifierInfo", setValue) }));
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");

			} else {
				String ItemID = commonService.selectString("item_SQL.getItemMaxID", setMap);
				commandMap.put("newItemID", ItemID);
				
				itemMasterService.save(commandMap); // create mstItem, attr, changeSet
				
				/*
				 * String ItemID = commonService.selectString("item_SQL.getItemMaxID", setMap);
				 * 
				 * setMap.put("option", StringUtil.checkNull(request.getParameter("option")));
				 * setMap.put("Version", "1"); setMap.put("Deleted", "0"); setMap.put("Creator",
				 * StringUtil.checkNull(commandMap.get("sessionUserId")));
				 * setMap.put("CategoryCode", "OJ"); setMap.put("ClassCode",
				 * StringUtil.checkNull(request.getParameter("newClassCode")));
				 * setMap.put("OwnerTeamId",
				 * StringUtil.checkNull(commandMap.get("sessionTeamId")));
				 * setMap.put("Identifier",
				 * StringUtil.checkNull(request.getParameter("newIdentifier")));
				 * setMap.put("ItemID", ItemID); setMap.put("s_itemID",
				 * request.getParameter("s_itemID")); if (itemTypeCode.equals("")) {
				 * itemTypeCode = commonService.selectString("item_SQL.selectedItemTypeCode",
				 * setMap); } setMap.put("ItemTypeCode", itemTypeCode);
				 * 
				 * setMap.put("AuthorID",
				 * StringUtil.checkNull(commandMap.get("sessionUserId")));
				 * setMap.put("IsPublic",
				 * StringUtil.checkNull(request.getParameter("IsPublic")));
				 * setMap.put("ProjectID",
				 * StringUtil.checkNull(request.getParameter("csrInfo")));
				 * setMap.put("RefItemID",
				 * StringUtil.checkNull(request.getParameter("refItemID")));
				 * setMap.put("Status", "NEW1"); setMap.put("projectID",
				 * StringUtil.checkNull(request.getParameter("csrInfo"))); String itemAccCtrl =
				 * StringUtil
				 * .checkNull(commonService.selectString("project_SQL.getProjectItemAccCtrl",
				 * setMap)); setMap.put("AccCtrl", itemAccCtrl); setMap.put("itemId",
				 * StringUtil.checkNull(request.getParameter("s_itemID"))); String idLength =
				 * ""; if (autoID.equals("Y")) { setValue = new HashMap();
				 * setValue.put("preFix", preFix); identifier = StringUtil
				 * .checkNull(commonService.selectString("item_SQL.getMaxPreFixIdentifier",
				 * setValue)); for (int i = 0; 5 - identifier.length() > i; i++) { idLength =
				 * idLength + "0"; }
				 * 
				 * if (identifier.equals("")) { identifier = preFix + "00001"; } else {
				 * identifier = preFix + idLength + identifier; }
				 * 
				 * setMap.put("Identifier", identifier); }
				 * 
				 * commonService.insert("item_SQL.insertItem", setMap);
				 * setMap.remove("CurChangeSet");
				 * 
				 * setMap.put("PlainText",
				 * StringUtil.checkNull(request.getParameter("newItemName")));
				 * setMap.put("AttrTypeCode", "AT00001"); List getLanguageList =
				 * commonService.selectList("common_SQL.langType_commonSelect", setMap); for
				 * (int i = 0; i < getLanguageList.size(); i++) { Map getMap = (HashMap)
				 * getLanguageList.get(i); setMap.put("languageID", getMap.get("CODE"));
				 * commonService.insert("item_SQL.ItemAttr", setMap); }
				 * 
				 */
				
				
				/*
				 * if ((!cpItemID.equals("") && mstSTR.equals("Y")) || cpItemID.equals("")) { if
				 * (strType.equals("2")) { setMap.put("itemID", ItemID); setMap.put("Level",
				 * Integer.parseInt(strLevel) + 1); String itemClassCode =
				 * StringUtil.checkNull(commonService.selectString(
				 * "item_SQL.getSubStrItemClassCode", setMap)); setMap.put("CategoryCode",
				 * "ST2"); setMap.put("ClassCode", itemClassCode); setMap.put("ParentID",
				 * s_itemID); fromItemID = mstItemID; setMap.put("ItemTypeCode",
				 * strItemTypeCode); setMap.put("StructureID", structureID); } else {
				 * setMap.put("CategoryCode", "ST1"); setMap.put("ClassCode", "NL00000");
				 * setMap.put("ItemTypeCode",commonService.selectString(
				 * "item_SQL.selectedConItemTypeCode", setMap)); } setMap.put("ToItemID",
				 * setMap.get("ItemID")); if (fromItemID.equals("")) { setMap.put("FromItemID",
				 * s_itemID); } else { setMap.put("FromItemID", fromItemID); }
				 * setMap.put("ItemID", commonService.selectString("item_SQL.getItemMaxID",
				 * setMap)); // setMap.put("Identifier", null); setMap.remove("RefItemID");
				 * setMap.remove("Identifier");
				 * 
				 * commonService.insert("item_SQL.insertItem", setMap); }
				 */
				/* 신규 생성된 ITEM의 ITEM_CLASS.ChangeMgt = 1 일 경우, CHANGE_SET 테이블에 레코드 생성 */
				/*
				 * setMap.put("ItemID", ItemID); String changeMgt =
				 * StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt",
				 * setMap)); if (changeMgt.equals("1")) { Insert to TB_CHANGE_SET
				 * insertCngMap.put("itemID", ItemID); insertCngMap.put("userId",
				 * StringUtil.checkNull(commandMap.get("sessionUserId")));
				 * insertCngMap.put("projectID",
				 * StringUtil.checkNull(request.getParameter("csrInfo")));
				 * insertCngMap.put("classCode",
				 * StringUtil.checkNull(request.getParameter("newClassCode")));
				 * insertCngMap.put("KBN", "insertCNG"); insertCngMap.put("status", "MOD");
				 * CSService.save(new ArrayList(), insertCngMap); }else
				 * if(!changeMgt.equals("1")){ ChangeMgt !=1 인 경우 ParentItem의 CurChangeSet
				 * Update setMap.put("itemID",s_itemID); String sItemIDCurChangeSetID =
				 * StringUtil.checkNull(commonService.selectString(
				 * "project_SQL.getCurChangeSetIDFromItem", setMap));
				 * if(!sItemIDCurChangeSetID.equals("")){ updateData = new HashMap();
				 * updateData.put("CurChangeSet", sItemIDCurChangeSetID);
				 * updateData.put("s_itemID", ItemID);
				 * commonService.update("project_SQL.updateItemStatus", updateData); } }
				 */
				/* 신규 생성한 상위 항목의 Dim Tree 데이터 생성 */
				/*
				 * String[] arrayStr = {ItemID}; List parentItemList =
				 * DimTreeAdd.getHighLankItemList(commonService, arrayStr);
				 * DimTreeAdd.insertDimTreeInfo(commonService, commandMap, parentItemList);
				 */

				// Dimension 생성 TB_ITEM_CLASS HasDimension = 1
				String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
				String dimTypeValueID = StringUtil.checkNull(request.getParameter("dimTypeValueID"));
				if (!dimTypeID.equals("") && !dimTypeValueID.equals("")) {
					Map setData = new HashMap();
					setData.put("ItemTypeCode", itemTypeCode);
					setData.put("ItemClassCode", StringUtil.checkNull(request.getParameter("newClassCode")));
					setData.put("ItemID", ItemID);
					setData.put("DimTypeID", dimTypeID);
					setData.put("DimValueID", dimTypeValueID);
					commonService.update("dim_SQL.insertItemDim", setData);
				}

				String modelID = StringUtil.checkNull(request.getParameter("modelID"));
				// copy item 일경우
				if (!cpItemID.equals("")) {
					Map itemInfoMap = new HashMap();
					itemInfoMap.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
					itemInfoMap.put("cpItemID", cpItemID);
					itemInfoMap.put("newItemID", ItemID);
					itemInfoMap.put("newItemName", StringUtil.checkNull(request.getParameter("newItemName")));
					itemInfoMap.put("ProjectID", StringUtil.checkNull(request.getParameter("csrInfo")));
					copyItemInfo(commandMap, model, itemInfoMap);

				}

				if (!modelID.equals("")) {
					Map itemInfoMap = new HashMap();
					itemInfoMap.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
					itemInfoMap.put("cpItemID", cpItemID);
					itemInfoMap.put("newItemID", ItemID);
					itemInfoMap.put("newItemName", StringUtil.checkNull(request.getParameter("newItemName")));
					itemInfoMap.put("ProjectID", StringUtil.checkNull(request.getParameter("csrInfo")));
					copyModel(commandMap, model, itemInfoMap);
				}

				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
																														// 성공

				setMap = new HashMap();
				setMap.put("ArcCode", request.getParameter("option"));
				setMap.put("SelectMenuId", request.getParameter("option"));
				String arcFilter = commonService.selectString("menu_SQL.selectArcFilter", setMap);
				String newClassCode = StringUtil.checkNull(request.getParameter("newClassCode"));
				String addYN = StringUtil.checkNull(request.getParameter("addYN"));
				if (arcFilter.equals("NF") || arcFilter.equals("ALL")) {
					System.out.println("Not Reflash");
					target.put(AJAX_SCRIPT, "this.doReturnInsert('" + newClassCode + "','" + addYN + "');this.$('#isSubmit').remove();");
				} else {
					System.out.println("Do Reflash");
					target.put(AJAX_SCRIPT,	"parent.fnRefreshTree('" + request.getParameter("s_itemID")	+ "',true);this.doReturnInsert('" + newClassCode + "','" + addYN + "');this.$('#isSubmit').remove();");
				}
			}
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류
																													// 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/setItemStatusForDel.do")
	public String setItemStatusForDel(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		model.put("option", request.getParameter("option"));
		model.put("s_itemID", request.getParameter("s_itemID"));

		HashMap target = new HashMap();
		HashMap updateCommandMap = new HashMap();
		HashMap setMap = new HashMap();

		try {

			String s_itemIDs = StringUtil.checkNull(request.getParameter("items"));
			String[] arrayStr = s_itemIDs.split(",");
			String categoryCode = StringUtil.checkNull(request.getParameter("categoryCode"));

			for (int i = 0; i < arrayStr.length; i++) {
				updateCommandMap = new HashMap();
				updateCommandMap.put("Deleted", "1");
				if (!categoryCode.equals(""))
					updateCommandMap.put("categoryCode", categoryCode);

				setMap.put("s_itemID", arrayStr[i]);
				String itemStatus = commonService.selectString("project_SQL.getItemStatus", setMap);

				if ("MOD1".equals(itemStatus)) {
					updateCommandMap.put("Status", "DEL1");
				}

				updateCommandMap.put("s_itemID", arrayStr[i]);
				updateCommandMap.put("ItemID", arrayStr[i]);
				updateCommandMap.put("LastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
				updateCommandMap.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));

				// connection Item update
				commonService.update("item_SQL.updateCNItemDeleted", updateCommandMap);
				// Item update
				commonService.update("project_SQL.updateItemStatus", updateCommandMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
			target.put(AJAX_SCRIPT, "this.urlReload();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " �궘�젣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣
																													// �삤瑜�
																													// 諛쒖깮
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	/**
	 * TB_ITEM의 AuthorTeamID 변경
	 * 
	 * @param s_itemID (teamID)
	 * @param items    (ItemID)
	 * @throws Exception
	 */
	@RequestMapping(value = "//transferDimention.do")
	public String transferDimention(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();

		try {
			// get Team ID :: target
			String getItems = StringUtil.checkNull(request.getParameter("items"), "");
			// get Item List :: items
			String[] items = getItems.split(",");

			if (items.length > 0) {
				setMap.put("s_itemID", request.getParameter("s_itemID"));
				for (int i = 0; i < items.length; i++) {
					setMap.put("ItemID", items[i]);

					// System.out.println("setMap ["+i+"] = "+setMap);

					commonService.update("item_SQL.transAuthorTeam", setMap);
				}
			}

			// target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
																													// 성공
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();this.doSearchList();");
		} catch (Exception e) {
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, "저장에 실패하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류
																													// 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	/**
	 * TB_ITEM의 AuthorTeamID 변경
	 * 
	 * @param s_itemID (teamID)
	 * @param items    (ItemID)
	 * @throws Exception
	 */
	@RequestMapping(value = "//transferUserDimention.do")
	public String transferUserDimention(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();

		try {
			// get Team ID :: target
			String getItems = StringUtil.checkNull(request.getParameter("items"), "");
			// get Item List :: items
			String[] items = getItems.split(",");

			// 하위항목 체크 유무
			String childAll = StringUtil.checkNull(request.getParameter("childAll"), "");

			if (items.length > 0) {
				setMap.put("s_itemID", request.getParameter("s_itemID"));
				for (int i = 0; i < items.length; i++) {
					setMap.put("ItemID", items[i]);

					commonService.update("item_SQL.transAuthorUser", setMap);
					// 하위항목 체크 :: 체크시 하위 항목 모두 변경 All로 받아옴
					if (!childAll.equals("")) {
						commonService.update("item_SQL.transAuthorUserChildAll", setMap);
					}
				}
			}

			// target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
																													// 성공
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();this.doSearchList();");
		} catch (Exception e) {
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, "저장에 실패하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류
																													// 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/getHasDimension.do")
	public String getHasDimension(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
			String classCode = StringUtil.checkNull(request.getParameter("itemClassCode"), "");
			String hasDimension = StringUtil.checkNull(commonService.selectString("item_SQL.getHasDim", commandMap));

			Map setData = new HashMap();
			setData.put("itemClassCode", classCode);
			Map itemClassInfo = commonService.select("item_SQL.getClassOption", setData);
			String autoID = StringUtil.checkNull(itemClassInfo.get("AutoID"));
			String preFix = StringUtil.checkNull(itemClassInfo.get("PreFix"));

			target.put(AJAX_SCRIPT, "this.fnSetDimension('" + hasDimension + "','" + autoID + "','" + preFix + "');");
		} catch (Exception e) {
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068"));
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/itemMgt.do")
	public String itemMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/itm/structure/itemMgt";
		try {
			String arcCode = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("arcCode"), ""));
			String menuStyle = StringUtil.checkNull(cmmMap.get("menuStyle"), "");
			String unfold = StringUtil.checkNull(cmmMap.get("unfold"));
			String arcDefPage = StringUtil.checkNull(cmmMap.get("arcDefPage"));
			String pageUrl = StringUtil.checkNull(cmmMap.get("pageUrl"));
			String nodeID = StringUtil.checkNull(cmmMap.get("nodeID"));
			String defMenuItemID = StringUtil.checkNull(cmmMap.get("defMenuItemID"));
			String defDimTypeID = StringUtil.checkNull(cmmMap.get("defDimTypeID"));
			String defDimValueID = StringUtil.replaceFilterString(StringUtil.checkNull(cmmMap.get("defDimValueID")));
			String loadType = StringUtil.checkNull(cmmMap.get("loadType"));
			String tLink = StringUtil.checkNull(cmmMap.get("tLink"));
			String linkNodeID = StringUtil.checkNull(cmmMap.get("linkNodeID"));
			String autoSave = StringUtil.checkNull(cmmMap.get("autoSave"));
			String myItemOnly = StringUtil.checkNull(cmmMap.get("myItemOnly"));
			String ownerTeamOnly = StringUtil.checkNull(cmmMap.get("ownerTeamOnly"));

			if (!linkNodeID.equals("")) { // Item Link Templet view linkID 가 있으면 nodeID로 setting
				nodeID = linkNodeID;
			}

			Map setData = new HashMap();
			setData.put("itemID", nodeID);
			String itemClassMenuURL = StringUtil
					.checkNull(commonService.selectString("menu_SQL.getItemClassMenuURL", setData));

			setData.put("arcCode", arcCode);
			Map arcMenuInfo = commonService.select("menu_SQL.getArcInfo", setData);
			String strType = ""; String filterType = "";
			if (arcMenuInfo != null && !arcMenuInfo.isEmpty()) {
				menuStyle = StringUtil.checkNull(arcMenuInfo.get("MenuStyle"), "");
				strType = StringUtil.checkNull(arcMenuInfo.get("StrType"), "");
				filterType = StringUtil.checkNull(arcMenuInfo.get("FilterType"));
			}
			model.put("strType", strType);
			model.put("sortOption", arcMenuInfo.get("SortOption"));
			model.put("arcCode", arcCode);
			model.put("menuStyle", menuStyle);
			model.put("defMenuItemID", defMenuItemID);
			model.put("unfold", unfold);
			model.put("arcDefPage", arcDefPage);
			model.put("pageUrl", pageUrl);
			model.put("nodeID", nodeID);
			model.put("itemClassMenuURL", itemClassMenuURL);
			model.put("varFilter", arcMenuInfo.get("VarFilter"));
			model.put("arcVarFilter", arcMenuInfo.get("VarFilter"));
			model.put("showTOJ", StringUtil.checkNull(cmmMap.get("showTOJ")));
			model.put("accMode", StringUtil.checkNull(cmmMap.get("accMode")));
			model.put("showVAR", StringUtil.checkNull(cmmMap.get("showVAR")));
			model.put("defDimTypeID", defDimTypeID);
			model.put("defDimValueID", defDimValueID);

			model.put("loadType", loadType);
			model.put("tLink", tLink);
			model.put("autoSave", autoSave);
			model.put("myItemOnly", myItemOnly);
			model.put("ownerTeamOnly", ownerTeamOnly);
			if (loadType.equals("multi")) {
				setData = new HashMap();
				setData.put("subArcCode", arcCode);
				setData.put("languageID", cmmMap.get("sessionCurrLangType"));
				List arcList = commonService.selectList("menu_SQL.getArcInfo", setData);
				model.put("arcList", arcList);
			}
			model.put("popupUrl", StringUtil.checkNull(cmmMap.get("popupUrl")));
			model.put("pWidth", StringUtil.checkNull(cmmMap.get("pWidth"), "850"));
			model.put("pHeight", StringUtil.checkNull(cmmMap.get("pHeight"), "700"));
			model.put("showLink", StringUtil.checkNull(cmmMap.get("showLink"), ""));
			model.put("filterType", filterType);
			model.put("defaultClassCodes", StringUtil.checkNull(cmmMap.get("defaultClassCodes"), ""));
			model.put("myCSR", StringUtil.checkNull(cmmMap.get("myCSR"), ""));
			model.put("csrIDs", StringUtil.checkNull(cmmMap.get("csrIDs"), ""));
			model.put("udfSTR", StringUtil.checkNull(cmmMap.get("udfSTR"), ""));
			model.put("multiDimType", StringUtil.checkNull(cmmMap.get("multiDimType"), ""));
			model.put("sqlXmlCode", StringUtil.checkNull(cmmMap.get("sqlXmlCode"), ""));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/arcItemMgt.do")
	public String arcItemMgt(HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/itm/structure/arcItemMgt";
		try {
			String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"), "");
			String menuStyle = StringUtil.checkNull(cmmMap.get("menuStyle"), "");
			String unfold = StringUtil.checkNull(cmmMap.get("unfold"));
			String arcDefPage = StringUtil.checkNull(cmmMap.get("arcDefPage"));
			String nodeID = StringUtil.checkNull(cmmMap.get("nodeID"));
			Map setData = new HashMap();
			setData.put("itemID", nodeID);
			String itemClassMenuURL = StringUtil
					.checkNull(commonService.selectString("menu_SQL.getItemClassMenuURL", setData));

			setData.put("arcCode", arcCode);
			Map arcMenuInfo = commonService.select("menu_SQL.getArcInfo", setData);
			if (arcMenuInfo != null && !arcMenuInfo.isEmpty()) {
				menuStyle = StringUtil.checkNull(arcMenuInfo.get("MenuStyle"), "");
			}

			model.put("sortOption", arcMenuInfo.get("SortOption"));
			model.put("arcCode", arcCode);
			model.put("menuStyle", menuStyle);
			model.put("unfold", unfold);
			model.put("arcDefPage", arcDefPage);
			model.put("nodeID", nodeID);
			model.put("itemClassMenuURL", itemClassMenuURL);
			model.put("varFilter", arcMenuInfo.get("VarFilter"));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/itemURL.do")
	public String itemURL(ModelMap model, HashMap cmmMap) throws Exception {
		Map target = new HashMap();
		try {
			target.put(AJAX_SCRIPT, "parent.creatMenuTab('" + cmmMap.get("MENU_ID") + "','1');");
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/setItemTabMenu.do")
	public String setItemTabMenu(HttpServletRequest request, ModelMap model, HashMap cmmMap) throws Exception {
		String url = "/itm/itemInfo/itemClassMenu";
		try {
			String archiCode = StringUtil.checkNull(cmmMap.get("option"), "");
			String s_itemID = StringUtil.checkNull(cmmMap.get("id"), StringUtil.checkNull(cmmMap.get("s_itemID"), ""));
			String srType = StringUtil.checkNull(cmmMap.get("srType"), "");
			String showElement = StringUtil.checkNull(cmmMap.get("showElement"), "");
			String accMode = StringUtil.checkNull(cmmMap.get("accMode"), "");
			String currIdx = StringUtil.checkNull(cmmMap.get("currIdx"), "");
			String showPreNextIcon = StringUtil.checkNull(cmmMap.get("showPreNextIcon"), "");

			/* ModelID 보유 확인 */
			Map setMap = new HashMap();
			setMap.put("languageID", cmmMap.get("languageID"));
			setMap.put("ModelID", s_itemID);
			setMap.put("s_itemID", s_itemID);
			List itemPath = new ArrayList();

			itemPath = getRootItemPath(s_itemID, StringUtil.checkNull(cmmMap.get("languageID")), itemPath);
			Collections.reverse(itemPath);
			model.put("itemPath", itemPath);

			model.put("id", s_itemID);
			model.put("s_itemID", s_itemID);
			model.put("choiceIdentifier", s_itemID);
			model.put("option", archiCode);
			model.put("level", (String) cmmMap.get("level"));

			setMap.put("ArcCode", archiCode);
			setMap.put("s_itemID", s_itemID);

			// TODO:MPM관리자 -> Org/User -> 사용자 관리
			// TB_MENU_ALLOC.ClassCode IS NULL

			List getList = new ArrayList();
			setMap.put("fromModelYN", StringUtil.checkNull(cmmMap.get("fromModelYN"), ""));
			// [ArcCode][ClassCode]의 Menu 취득
			getList = commonService.selectList("menu_SQL.getTabMenu", setMap);

			// [ClassCode]의 default Menu 취득
			if (getList.size() == 0) {
				setMap.put("ArcCode", "AR000000");
				getList = commonService.selectList("menu_SQL.getTabMenu", setMap);
			}

			// default Menu 취득
			if (getList.size() == 0) {
				setMap.put("ArcCode", "AR000000");
				setMap.put("s_itemID", "null");
				setMap.put("ClassCode", "CL01000");
				getList = commonService.selectList("menu_SQL.getTabMenu", setMap);
			}

			setMap = new HashMap();
			String blankPhotoUrlPath = GlobalVal.HTML_IMG_DIR + "/blank_photo.png";
			String photoUrlPath = GlobalVal.EMP_PHOTO_URL;
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));

			setMap.put("itemID", s_itemID);
			setMap.put("assignmentType", "CNGROLETP");
			setMap.put("languageID", languageID);
			setMap.put("blankPhotoUrlPath", blankPhotoUrlPath);
			setMap.put("photoUrlPath", photoUrlPath);
			setMap.put("isAll", "N");
			String empPhotoItemDisPlay = GlobalVal.EMP_PHOTO_ITEM_DISPLAY;
			model.put("empPhotoItemDisPlay", empPhotoItemDisPlay);

			List roleAssignMemberList = new ArrayList();
			if (!empPhotoItemDisPlay.equals("N")) {
				roleAssignMemberList = commonService.selectList("item_SQL.getAssignmentMemberList", setMap);
			}

			setMap.put("s_itemID", s_itemID);

			Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
			
			//2025-02-17 기본 화면 로딩 안되는 버그 수정
			itemInfo.remove("Description");
			
			
			model.put("roleAssignMemberList", roleAssignMemberList);
			model.put("baseAtchUrl", GlobalVal.BASE_ATCH_URL);
			model.put("getList", getList);
			model.put("fromModelYN", StringUtil.checkNull(cmmMap.get("fromModelYN"), ""));

			String parentItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getParentItemID", setMap));
			model.put("parentItemID", parentItemID);

			Map setValue = new HashMap();
			setValue.put("s_itemID", s_itemID);
			Map menuDisplayMap = commonService.select("item_SQL.getMenuIconDisplay", setValue);
			model.put("menuDisplayMap", menuDisplayMap);

			String sessionAuthLev = String.valueOf(cmmMap.get("sessionAuthLev")); // 시스템 관리자
			String sessionUserId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
//			if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(sessionUserId)
//					|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(sessionUserId)
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			model.put("myItem", myItem);

			String checkOutOption = StringUtil.checkNull(itemInfo.get("CheckOutOption"));
			setMap.put("itemID", s_itemID);
			setMap.put("userID", sessionUserId);
			setMap.put("checkOutOption", checkOutOption);
			String checkItemAuthorTransferable = commonService.selectString("item_SQL.getCheckItemAuthorTransferable",setMap);
			model.put("checkItemAuthorTransferable", checkItemAuthorTransferable);

			Map prcList = commonService.select("report_SQL.getItemInfo", setMap);
			/* 기본정보의 속성 내용을 취득 */

			String changeSetID = "";
			if (accMode.equals("OPS")) {
				changeSetID = StringUtil.checkNull(prcList.get("ReleaseNo"));
				setMap.put("changeSetID", changeSetID);
				prcList = commonService.select("item_SQL.getItemAttrRevInfo", setMap);
				prcList.put("Blocked", itemInfo.get("Blocked"));
				prcList.put("ChangeMgt", itemInfo.get("ChangeMgt"));
				prcList.put("SubscrOption", itemInfo.get("SubscrOption"));
				prcList.put("CheckInOption", itemInfo.get("CheckInOption"));
				prcList.put("CheckOutOption", itemInfo.get("CheckOutOption"));
				prcList.put("Status", itemInfo.get("Status"));
				model.put("itemInfo", prcList);
			} else {
				changeSetID = StringUtil.checkNull(prcList.get("CurChangeSet"),prcList.get("ReleaseNo").toString());
				setMap.put("changeSetID", changeSetID);
				String wfInstanceON = StringUtil.checkNull(commonService.selectString("wf_SQL.getWfInstON", setMap));
				model.put("wfInstanceON", wfInstanceON);
				model.put("itemInfo", itemInfo);
			}

			setMap.put("memberID", cmmMap.get("sessionUserId"));
			model.put("myItemCNT", StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCNT", setMap)));
			model.put("myItemSeq", StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemSeq", setMap)));

			// QuickCheckOut 설정
			String quickCheckOut = "N";
			String itemAuthorID = StringUtil.checkNull(itemInfo.get("AuthorID"));
			String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));

			setMap.put("ItemID", s_itemID);
			String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));

			if (itemInfo.get("Blocked").equals("2")) {
				// attributeBtn = "N";
				setMap = new HashMap();
				setMap.put("itemID", s_itemID);
				setMap.put("accessRight", "U");
				setMap.put("userID", sessionUserID);
				String myItemMember = StringUtil
						.checkNull(commonService.selectString("item_SQL.getMyItemMemberIDTop1", setMap));
				if ((itemInfo.get("Status").equals("REL")) && changeMgt.equals("1")
						&& (itemAuthorID.equals(sessionUserID) || myItemMember.equals(sessionUserID))) {
					quickCheckOut = "Y";
				}
			}
			model.put("quickCheckOut", quickCheckOut);
			model.put("s_itemID", s_itemID);

			setMap.put("DocCategory", "CS");
			String wfURL = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", setMap));
			model.put("wfURL", wfURL);

			setMap = new HashMap();
			setMap.put("userId", sessionUserID);
			setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", s_itemID);
			setMap.put("ProjectType", "CSR");
			setMap.put("isMainItem", "Y");
			setMap.put("status", "CNG");
			List projectNameList = commonService.selectList("project_SQL.getProjectNameList", setMap);
			model.put("projectNameList", projectNameList.size());

			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));

			if (srType != "") {
				setMap.put("srType", srType);
				setMap.put("itemID", s_itemID);
				int icpListCNT = commonService.selectList("esm_SQL.getEsrMSTList_gridList", setMap).size();
				model.put("srType", srType.toUpperCase());
				model.put("icpListCNT", icpListCNT);
			}
			model.put("srType", srType);
			model.put("showElement", showElement);
			model.put("currIdx", currIdx);
			model.put("showPreNextIcon", showPreNextIcon);
			model.put("showTOJ", StringUtil.checkNull(cmmMap.get("showTOJ")));
			model.put("accMode", accMode);
			model.put("tLink", StringUtil.checkNull(cmmMap.get("tLink")));
			model.put("defDimValueID", StringUtil.checkNull(cmmMap.get("defDimValueID")));
			model.put("showLink", StringUtil.checkNull(cmmMap.get("showLink"), ""));
			model.put("myCSR", StringUtil.checkNull(cmmMap.get("myCSR"), ""));
			model.put("csrIDs", StringUtil.checkNull(cmmMap.get("csrIDs"), ""));
			model.put("udfSTR", StringUtil.checkNull(cmmMap.get("udfSTR"), ""));
			
			model.put("menu", getLabel(request, commonService));

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/getItemClassMenuURL.do")
	public String getItemClassMenuURL(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		Map target = new HashMap();
		try {
			String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
			String currIdx = StringUtil.checkNull(cmmMap.get("currIdx"));
			String strType = StringUtil.checkNull(cmmMap.get("strType"));
			String arcFilterType = StringUtil.checkNull(cmmMap.get("arcFilterType"));

			Map setData = new HashMap();
			setData.put("itemID", itemID);

			String itemClassMenuURL = StringUtil
					.checkNull(commonService.selectString("menu_SQL.getItemClassMenuURL", setData));
			String itemClassMenuVarFilter = StringUtil
					.checkNull(commonService.selectString("menu_SQL.getItemClassMenuVarFilter", setData));

			String teamCNT = "";
			String actionYN = "";
			if (arcFilterType.equals("ORGITM") || arcFilterType.equals("ORG")) {
				setData.put("teamID", itemID);
				teamCNT = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamCNT", setData));
				if (Integer.parseInt(teamCNT) == 0) {
					actionYN = "N";
				}
			}
			if (itemClassMenuURL.equals("")) {
				target.put(AJAX_SCRIPT, "creatMenuTab('" + itemID + "','1','" + itemClassMenuVarFilter + "','" + currIdx
						+ "','" + actionYN + "')");
			} else {
				target.put(AJAX_SCRIPT, "fnSetItemClassMenu('" + itemClassMenuURL + "','" + itemID
						+ itemClassMenuVarFilter + "','" + currIdx + "','" + actionYN + "')");
			}
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/ownerItemList.do")
	public String ownerItemList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			model.put("s_itemID",StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("memberID"))));
			model.put("option", StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("option"))));
			model.put("ownerType",StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("ownerType"))));
			model.put("ownerTeamID",StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("ownerTeamID"))));
			model.put("authorID",StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("authorID"))));
			model.put("teamID", StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("teamID"))));
			model.put("statusList",StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("statusList"))));
			model.put("status", StringUtil.replaceFilterString(StringUtil.checkNull(StringUtil.checkNull(request.getParameter("status"), ""))));
			model.put("teamManagerID",StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("teamManagerID"))));
			model.put("srID", StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("srID"))));
			model.put("defItemTypeCode",StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("defItemTypeCode"))));
			model.put("hideTitle",StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("hideTitle"))));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			//==============================================
			/*
			 *  "languageID=${sessionScope.loginInfo.sessionCurrLangType}
			 *  &statusList=${statusList}
			 *  &changeMgtYN=Y
			 *  &ownerType=${ownerType}
			 *  &authorID=${authorID}" 
				+ "&pageNum=" + $("#currPage").val()
		        + "&searchKey=" + $("#searchKey").val()
		        + "&searchValue=" + $("#searchValue").val();
			 */
			
			commandMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			commandMap.put("statusList", model.get("statusList"));
			commandMap.put("changeMgtYN", "Y");
			commandMap.put("authorID", model.get("authorID"));
			commandMap.put("ownerType", model.get("ownerType"));
			commandMap.put("authorID", model.get("authorID"));
			commandMap.put("searchKey", request.getParameter("searchKey"));				
			commandMap.put("searchValue", request.getParameter("searchValue"));
			commandMap.put("OwnerTeamID",StringUtil.checkNull(request.getParameter("OwnerTeamID") ));
		
			List<String> ownItmList = commonService.selectList("item_SQL.getOwnerItemList_gridList",commandMap);
			JSONArray gridData = new JSONArray(ownItmList);
			model.put("gridData", gridData);
		
			
			

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/itm/structure/ownerItemList");
	}

	@RequestMapping(value = "/childItemOrderList.do")
	public String childItemOrderList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			model.put("s_itemID", s_itemID);
			model.put("sqlKey", StringUtil.checkNull(request.getParameter("sqlKey"), ""));
			model.put("strType", StringUtil.checkNull(request.getParameter("strType"), ""));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/itm/structure/childItemOrderList");
	}

	@RequestMapping(value = "/updateChildItemOrder.do")
	public String updateChildItemOrder(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		HashMap target = new HashMap();
		try {
			String ids[] = request.getParameter("ids").split(",");
			Map setData = new HashMap();
			String status = "";
			String itemID = "";
			String sortNum = "";
			String category = "";
			String strType = StringUtil.checkNull(request.getParameter("strType"), "");
			setData.put("strType", strType);

			for (int i = 0; i < ids.length; i++) {
				status = StringUtil.checkNull(request.getParameter(ids[i] + "_!nativeeditor_status"), "");
				sortNum = StringUtil.checkNull(request.getParameter(ids[i] + "_c4"), "");
				itemID = StringUtil.checkNull(request.getParameter(ids[i] + "_c5"), "");
				category = StringUtil.checkNull(request.getParameter(ids[i] + "_c6"), "");
				if (category.equals("")) {
					category = "ST1";
				}
				setData.put("itemID", itemID);
				setData.put("sortNum", sortNum);
				setData.put("categoryCode", category);
				commonService.update("item_SQL.updateItemSortNum", setData);
			}
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류
																													// 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/copyItemList.do")
	public String copyItemList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			String itemIDs = StringUtil.checkNull(request.getParameter("itemIDs"), "");

			Map setData = new HashMap();
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			setData.put("itemIDs", itemIDs);
			List itemList = commonService.selectList("report_SQL.itemStDetailInfo", setData);

			model.put("itemList", itemList);
			model.put("s_itemID", s_itemID);
			model.put("itemIDs", itemIDs);

			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/itm/structure/copyItemList");
	}

	public void copyItemInfo(HashMap commandMap, ModelMap model, Map itemInfoMap) throws Exception {

		String cpItemID = StringUtil.checkNull(itemInfoMap.get("cpItemID"), "");
		String newItemID = StringUtil.checkNull(itemInfoMap.get("newItemID"), "");

		String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
		String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));

		String projectID = StringUtil.checkNull(itemInfoMap.get("ProjectID"), "");
		Map setData = new HashMap();

		// Copy TB_ITEM_Attr
		setData.put("cpItemID", cpItemID);
		setData.put("newItemID", newItemID);
		commonService.insert("item_SQL.copyItemAttr", setData);

		/*
		 * // Copy Dimension setData = new HashMap(); setData.put("cpItemID", cpItemID);
		 * setData.put("newItemID", newItemID);
		 * commonService.insert("dim_SQL.copyItemDim",setData);
		 */

		// Copy Connection Item
		setData = new HashMap();
		setData.put("fromItemID", cpItemID);
		setData.put("userID", userID);
		setData.put("OwnerTeamId", teamID);
		setData.put("categoryCode", "CN");
		setData.put("projectID", projectID);

		List toCxnList = commonService.selectList("item_SQL.getCxnItemIDList", setData);
		if (toCxnList.size() > 0) {
			for (int k = 0; k < toCxnList.size(); k++) {
				Map toCxnMap = (Map) toCxnList.get(k);
				String cxnItemID = StringUtil.checkNull(toCxnMap.get("ItemID"));

				setData.put("newItemID", commonService.selectString("item_SQL.getItemMaxID", setData));
				setData.put("fromItemID", newItemID);
				setData.put("cpItemID", cxnItemID);
				setData.put("userID", userID);
				setData.put("status", "NEW1");
				commonService.insert("item_SQL.copyItem", setData);
			}
		}

		setData = new HashMap();
		setData.put("toItemID", cpItemID);
		setData.put("userID", userID);
		setData.put("OwnerTeamId", teamID);
		setData.put("categoryCode", "CN");
		List fromCxnList = commonService.selectList("item_SQL.getCxnItemIDList", setData);
		if (fromCxnList.size() > 0) {
			for (int l = 0; l < fromCxnList.size(); l++) {
				Map fromCxnMap = (Map) fromCxnList.get(l);
				String cxnItemID = StringUtil.checkNull(fromCxnMap.get("ItemID"));

				setData.put("newItemID", commonService.selectString("item_SQL.getItemMaxID", setData));
				setData.put("toItemID", newItemID);
				setData.put("orgItemID", cxnItemID);
				setData.put("status", "NEW1");
				commonService.insert("item_SQL.copyItem", setData);
			}
		}
	}

	// Copy Model
	public void copyModel(HashMap commandMap, ModelMap model, Map itemInfoMap) throws Exception {
		String newItemID = StringUtil.checkNull(itemInfoMap.get("newItemID"), "");
		String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
		String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
		String elmCopyOption = StringUtil.checkNull(commandMap.get("elmCopyOption"), "");
		if (elmCopyOption.equals("")) {
			elmCopyOption = "ref";
		}

		Map setData = new HashMap();

		setData.put("orgModelID", StringUtil.checkNull(commandMap.get("modelID")));
		setData.put("includeItemMaster", StringUtil.checkNull(commandMap.get("includeItemMaster")));
		setData.put("newModelName", StringUtil.checkNull(commandMap.get("newModelName")));
		setData.put("newMTCTypeCode", StringUtil.checkNull(commandMap.get("MTCTypeCode")));
		setData.put("newModelTypeCode", StringUtil.checkNull(commandMap.get("ModelTypeCode")));
		setData.put("LanguageID", languageID);
		setData.put("Creator", userID);
		setData.put("ItemID", newItemID);
		setData.put("itemID", newItemID);
		setData.put("projectID", StringUtil.checkNull(commandMap.get("csrInfo")));
		setData.put("changeSetID",
				StringUtil.checkNull(commonService.selectString("item_SQL.getCurChangeSet", setData)));
		setData.put("mstSTR", StringUtil.checkNull(commandMap.get("mstSTR")));
		setData.put("checkElmts", StringUtil.checkNull(commandMap.get("checkElmts"), ""));
		setData.put("ModelName", StringUtil.checkNull(commandMap.get("newModelName"), ""));
		setData.put("ownerTeamID", StringUtil.checkNull(commandMap.get("sessionTeamId"), ""));
		setData.put("GUBUN", elmCopyOption);
		setData.put("s_itemID", itemInfoMap.get("s_itemID"));
		setData.put("orgItemID", itemInfoMap.get("cpItemID"));
		setData.put("copyItemMasterYN", "Y");

		mdItemService.save(setData);
	}

	@RequestMapping(value = "/multiItemTreeMgt.do")
	public String multiItemTreeMgt(HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/itm/structure/multiItemTreeMgt";
		try {
			String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"), "");
			String subArcCode = StringUtil.checkNull(cmmMap.get("subArcCode"));
			String nodeID = StringUtil.checkNull(cmmMap.get("nodeID"));
			String defMenuItemID = StringUtil.checkNull(cmmMap.get("defMenuItemID"));
			String menuUrl = StringUtil.checkNull(cmmMap.get("url"));
			if (!menuUrl.equals("") && !menuUrl.equals("undefined")) {
				url = menuUrl;
			}

			Map setData = new HashMap();

			setData = new HashMap();
			setData.put("parentID", arcCode);
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			List arcList = commonService.selectList("menu_SQL.getArcInfo", setData);
			Map grArcInfo = new HashMap();
			if (arcList.size() > 0) {
				for (int i = 0; arcList.size() > i; i++) {
					Map arcInfo = (Map) arcList.get(i);

					String varFilter[] = StringUtil.checkNull(arcInfo.get("VarFilter")).split("&");
					if (varFilter.length > 0) {
						for (int j = 0; varFilter.length > j; j++) {
							String paramName[] = StringUtil.checkNull(varFilter[j]).split("=");
							if (paramName.length > 0) {
								if (StringUtil.checkNull(paramName[0]).equals("nodeID")) {
									arcInfo.put("nodeID", paramName[1]);
									setData.put("itemID", paramName[1]);
									String itemClassMenuURL = StringUtil.checkNull(
											commonService.selectString("menu_SQL.getItemClassMenuURL", setData));
									arcInfo.put("itemClassMenuURL", itemClassMenuURL);
								} else if (StringUtil.checkNull(paramName[0]).equals("arcDefPage")) {
									arcInfo.put("arcDefPage", paramName[1]);
								} else if (StringUtil.checkNull(paramName[0]).equals("pageUrl")) {
									arcInfo.put("pageUrl", paramName[1]);
								} else if (StringUtil.checkNull(paramName[0]).equals("defClassCode")) {
									arcInfo.put("defClassCode", paramName[1]);
								} else if (StringUtil.checkNull(paramName[0]).equals("popupUrl")) {
									arcInfo.put("popupUrl", paramName[1]);
								} else if (StringUtil.checkNull(paramName[0]).equals("pWidth")) {
									arcInfo.put("pWidth", paramName[1]);
								} else if (StringUtil.checkNull(paramName[0]).equals("pHight")) {
									arcInfo.put("pHight", paramName[1]);
								}

							}
						}
					}

					if (subArcCode.equals(StringUtil.checkNull(arcInfo.get("ArcCode")))) {
						grArcInfo = (Map) arcList.get(i);
					}
				}
				if (grArcInfo.isEmpty()) {
					grArcInfo = (Map) arcList.get(0);
				}
			}

			model.put("sortOption", grArcInfo.get("SortOption"));
			/*
			 * model.put("arcCode", grArcInfo.get("ArcCode")); model.put("menuStyle",
			 * grArcInfo.get("MenuStyle")); model.put("arcDefPage",
			 * grArcInfo.get("arcDefPage")); model.put("nodeID", grArcInfo.get("nodeID"));
			 * model.put("itemClassMenuURL", grArcInfo.get("itemClassMenuURL"));
			 * model.put("varFilter", grArcInfo.get("VarFilter"));
			 */
			model.put("arcList", arcList);
			model.put("nodeID", nodeID);
			model.put("grArcInfo", grArcInfo);
			model.put("subArcCode", subArcCode);
			model.put("defMenuItemID", defMenuItemID);
			model.put("showTOJ", StringUtil.checkNull(cmmMap.get("showTOJ")));
			model.put("accMode", StringUtil.checkNull(cmmMap.get("accMode")));
			model.put("showVAR", StringUtil.checkNull(cmmMap.get("showVAR")));
			model.put("objClassList", StringUtil.checkNull(cmmMap.get("objClassList")));
			model.put("ownerType", StringUtil.checkNull(cmmMap.get("ownerType")));

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/itemFolderMgt.do")
	public String itemFolderMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/itm/structure/itemFolderMgt";
		try {
			String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"), "");
			String unfold = StringUtil.checkNull(cmmMap.get("unfold"));
			String arcDefPage = StringUtil.checkNull(cmmMap.get("arcDefPage"));
			String nodeID = StringUtil.checkNull(cmmMap.get("nodeID"));
			String focusedItemID = StringUtil.checkNull(request.getParameter("focusedItemID"));
			String showTOJ = StringUtil.checkNull(cmmMap.get("showTOJ"));
			String showVAR = StringUtil.checkNull(cmmMap.get("showVAR"));
			String pageUrl = StringUtil.checkNull(cmmMap.get("pageUrl"));
			String defMenuItemID = StringUtil.checkNull(cmmMap.get("defMenuItemID"));
			String defDimTypeID = StringUtil.checkNull(cmmMap.get("defDimTypeID"));
			String defDimValueID = StringUtil.checkNull(cmmMap.get("defDimValueID"));
			String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));
			String scrnMode = StringUtil.checkNull(cmmMap.get("scrnMode"));
			String scrnUrl = StringUtil.checkNull(cmmMap.get("scrnUrl"));
			String loadType = StringUtil.checkNull(cmmMap.get("loadType"));
			String regFlg = StringUtil.checkNull(cmmMap.get("regFlg"));
			String tLink = StringUtil.checkNull(cmmMap.get("tLink"));
			if (!s_itemID.equals("")) {
				nodeID = s_itemID;
			}

			Map setData = new HashMap();
			setData.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			setData.put("SelectMenuId", arcCode);
			setData.put("arcCode", arcCode);
			setData.put("showTOJ", showTOJ);
			setData.put("showVAR", showVAR);
			setData.put("sessionUserId", cmmMap.get("sessionUserId"));
			String menuStyle = StringUtil.checkNull(commonService.selectString("menu_SQL.getMenuStyle", setData), "");
			setData.put("s_itemID", defMenuItemID);
			setData.put("defDimValueID", defDimValueID);

			setData.put("sortOption",StringUtil.checkNull(commonService.selectString("menu_SQL.getArcSortOption", setData)));
			
			String SQL_CODE = StringUtil.checkNull(commonService.selectString("menu_SQL.getMenuTreeSqlName", setData),"commonCode");
			List treeList = commonService.selectList(SQL_CODE, setData);
			// int treeMaxLevel =
			// Integer.parseInt(commonService.selectString("config_SQL.getConfigurationMaxLevel",
			// setData));

			model.put("regFlg", regFlg);
			model.put("pageUrl", pageUrl);
			model.put("arcCode", arcCode);
			model.put("defMenuItemID", defMenuItemID);
			model.put("menuStyle", menuStyle);
			model.put("unfold", unfold);
			model.put("arcDefPage", arcDefPage);
			model.put("scrnUrl", scrnUrl);
			model.put("defDimTypeID", defDimTypeID);
			model.put("defDimValueID", defDimValueID);
			model.put("nodeID", nodeID);
			model.put("focusedItemID", focusedItemID);
			model.put("showTOJ", showTOJ);
			model.put("accMode", StringUtil.checkNull(cmmMap.get("accMode")));
			model.put("ownerType", StringUtil.checkNull(cmmMap.get("ownerType")));
			model.put("showVAR", StringUtil.checkNull(cmmMap.get("showVAR")));
			model.put("tLink", tLink);

			String filepath = request.getSession().getServletContext().getRealPath("/");

			/* xml 파일명 설정 */
			Calendar cal = Calendar.getInstance();
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
			java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("HHmmssSSS");
			String sdate = sdf.format(cal.getTime());
			String stime = sdf2.format(cal.getTime());
			String mkFileNm = sdate + stime;

			String xmlFileName = "doc/tmp/itemFolderTree" + mkFileNm + ".xml";

			File dirFile = new File(filepath + "doc/tmp/");
			if (!dirFile.exists()) {
				dirFile.mkdirs();
			}

			makeItemFolderXML(filepath, treeList, xmlFileName, cmmMap, request);
			model.put("xmlFileName", xmlFileName);
			model.put("scrnMode", scrnMode);

			model.put("loadType", loadType);
			if (loadType.equals("multi")) {
				setData = new HashMap();
				setData.put("subArcCode", arcCode);
				setData.put("languageID", cmmMap.get("sessionCurrLangType"));
				List arcList = commonService.selectList("menu_SQL.getArcInfo", setData);
				model.put("arcList", arcList);
			}

			model.put("popupUrl", StringUtil.checkNull(cmmMap.get("popupUrl")));
			model.put("pWidth", StringUtil.checkNull(cmmMap.get("pWidth"), "850"));
			model.put("pHeight", StringUtil.checkNull(cmmMap.get("pHeight"), "700"));
			model.put("defDimValueID", StringUtil.checkNull(cmmMap.get("defDimValueID"), ""));
			model.put("showLink", StringUtil.checkNull(cmmMap.get("showLink"), ""));
			model.put("myCSR", StringUtil.checkNull(cmmMap.get("myCSR")));
			model.put("csrIDs", StringUtil.checkNull(cmmMap.get("csrIDs")));
			model.put("udfSTR", StringUtil.checkNull(cmmMap.get("udfSTR"), ""));
			model.put("multiDimType", StringUtil.checkNull(cmmMap.get("multiDimType"), ""));
			model.put("sqlXmlCode", StringUtil.checkNull(cmmMap.get("sqlXmlCode"), ""));
			
			setData.put("arcCode", arcCode);
			Map arcMenuInfo = commonService.select("menu_SQL.getArcInfo", setData);
			String strType = ""; String filterType = "";
			if (arcMenuInfo != null && !arcMenuInfo.isEmpty()) {
				menuStyle = StringUtil.checkNull(arcMenuInfo.get("MenuStyle"), "");
				strType = StringUtil.checkNull(arcMenuInfo.get("StrType"), "");
				filterType = StringUtil.checkNull(arcMenuInfo.get("FilterType"));
			}
			model.put("arcVarFilter", arcMenuInfo.get("VarFilter"));
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	private void makeItemFolderXML(String filepath, List treeList, String xmlFileName, HashMap cmmMap,
			HttpServletRequest request) throws ExceptionUtil {
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		try {
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
			Document doc = docBuilder.newDocument();
			Element treeElement = doc.createElement("tree");
			doc.appendChild(treeElement);
			treeElement.setAttribute("id", "0");

			Element item0 = doc.createElement("item");
			Element item1 = null;
			Element item2 = null;
			Element item3 = null;
			Element item4 = null;
			Element item5 = null;
			Element item6 = null;
			Element item7 = null;
			Element item8 = null;

			String objClassList[] = StringUtil.checkNull(request.getParameter("objClassList")).split(",");
			Map objClassMap = new HashMap();
			int idx = 1;
			if (objClassList.length > 0) {
				for (int i = 0; i < objClassList.length; i++) {
					objClassMap.put("objClass" + idx, objClassList[i]);
					idx++;
				}
			}
			String topTreeID = "";
			if (treeList.size() > 0) {
				for (int i = 0; i < treeList.size(); i++) {
					Map treeMap = (Map) treeList.get(i);
					topTreeID = StringUtil.checkNull(treeMap.get("PRE_TREE_ID"));
					if (topTreeID.equals("0")) {
						item0.setAttribute("id", StringUtil.checkNull(treeMap.get("TREE_ID")));
						item0.setAttribute("text", StringUtil.checkNull(treeMap.get("TREE_NM")));

						if (objClassMap.containsValue(StringUtil.checkNull(treeMap.get("ClassCode")))) {
							item0.setAttribute("im0", StringUtil.checkNull(treeMap.get("ClassIcon")));
							item0.setAttribute("im1", StringUtil.checkNull(treeMap.get("ClassIcon")));
							item0.setAttribute("im2", StringUtil.checkNull(treeMap.get("ClassIcon")));
						} else {
							item0.setAttribute("im0", "folderClosed.gif");
							item0.setAttribute("im1", "folderOpen.gif");
							item0.setAttribute("im2", "folderClosed.gif");
						}
						item0.setAttribute("open", "1");

						// 1 Level
						for (int i1 = 0; i1 < treeList.size(); i1++) {
							Map treeMap1 = (Map) treeList.get(i1);
							if (StringUtil.checkNull(treeMap1.get("PRE_TREE_ID"))
									.equals(StringUtil.checkNull(treeMap.get("TREE_ID")))) {
								item1 = doc.createElement("item");
								item1.setAttribute("id", StringUtil.checkNull(treeMap1.get("TREE_ID")));
								item1.setAttribute("text", StringUtil.checkNull(treeMap1.get("TREE_NM")));

								if (objClassMap.containsValue(StringUtil.checkNull(treeMap1.get("ClassCode")))) {
									item1.setAttribute("im0", StringUtil.checkNull(treeMap1.get("ClassIcon")));
									item1.setAttribute("im1", StringUtil.checkNull(treeMap1.get("ClassIcon")));
									item1.setAttribute("im2", StringUtil.checkNull(treeMap1.get("ClassIcon")));
								} else {
									item1.setAttribute("im0", "folderClosed.gif");
									item1.setAttribute("im1", "folderOpen.gif");
									item1.setAttribute("im2", "folderClosed.gif");
								}
								item0.appendChild(item1);
								// 2 Level
								for (int i2 = 0; i2 < treeList.size(); i2++) {
									Map treeMap2 = (Map) treeList.get(i2);
									if (StringUtil.checkNull(treeMap2.get("PRE_TREE_ID"))
											.equals(StringUtil.checkNull(treeMap1.get("TREE_ID")))) {
										item2 = doc.createElement("item");
										item2.setAttribute("id", StringUtil.checkNull(treeMap2.get("TREE_ID")));
										item2.setAttribute("text", StringUtil.checkNull(treeMap2.get("TREE_NM")));

										if (objClassMap
												.containsValue(StringUtil.checkNull(treeMap2.get("ClassCode")))) {
											item2.setAttribute("im0", StringUtil.checkNull(treeMap2.get("ClassIcon")));
											item2.setAttribute("im1", StringUtil.checkNull(treeMap2.get("ClassIcon")));
											item2.setAttribute("im2", StringUtil.checkNull(treeMap2.get("ClassIcon")));
										} else {
											item2.setAttribute("im0", "folderClosed.gif");
											item2.setAttribute("im1", "folderOpen.gif");
											item2.setAttribute("im2", "folderClosed.gif");
										}
										item1.appendChild(item2);

										// 3 Level
										for (int i3 = 0; i3 < treeList.size(); i3++) {
											Map treeMap3 = (Map) treeList.get(i3);
											if (StringUtil.checkNull(treeMap3.get("PRE_TREE_ID")).equals(StringUtil.checkNull(treeMap2.get("TREE_ID")))) {
												item3 = doc.createElement("item");
												item3.setAttribute("id", StringUtil.checkNull(treeMap3.get("TREE_ID")));
												item3.setAttribute("text",StringUtil.checkNull(treeMap3.get("TREE_NM")));

												if (objClassMap.containsValue(StringUtil.checkNull(treeMap3.get("ClassCode")))) {
													item3.setAttribute("im0",StringUtil.checkNull(treeMap3.get("ClassIcon")));
													item3.setAttribute("im1",StringUtil.checkNull(treeMap3.get("ClassIcon")));
													item3.setAttribute("im2",StringUtil.checkNull(treeMap3.get("ClassIcon")));
												} else {
													item3.setAttribute("im0", "folderClosed.gif");
													item3.setAttribute("im1", "folderOpen.gif");
													item3.setAttribute("im2", "folderClosed.gif");
												}
												item2.appendChild(item3);

												// 4 Level
												for (int i4 = 0; i4 < treeList.size(); i4++) {
													Map treeMap4 = (Map) treeList.get(i4);
													if (StringUtil.checkNull(treeMap4.get("PRE_TREE_ID")).equals(StringUtil.checkNull(treeMap3.get("TREE_ID")))) {
														item4 = doc.createElement("item");

														item4.setAttribute("id",StringUtil.checkNull(treeMap4.get("TREE_ID")));
														item4.setAttribute("text",StringUtil.checkNull(treeMap4.get("TREE_NM")));

														if (objClassMap.containsValue(StringUtil.checkNull(treeMap4.get("ClassCode")))) {
															item4.setAttribute("im0",StringUtil.checkNull(treeMap4.get("ClassIcon")));
															item4.setAttribute("im1",StringUtil.checkNull(treeMap4.get("ClassIcon")));
															item4.setAttribute("im2",StringUtil.checkNull(treeMap4.get("ClassIcon")));
														} else {
															item4.setAttribute("im0", "folderClosed.gif");
															item4.setAttribute("im1", "folderOpen.gif");
															item4.setAttribute("im2", "folderClosed.gif");
														}
														item3.appendChild(item4);

														// 5 Level
														for (int i5 = 0; i5 < treeList.size(); i5++) {
															Map treeMap5 = (Map) treeList.get(i5);
															if (StringUtil.checkNull(treeMap5.get("PRE_TREE_ID")).equals(StringUtil.checkNull(treeMap4.get("TREE_ID")))) {
																item5 = doc.createElement("item");
																item5.setAttribute("id",StringUtil.checkNull(treeMap5.get("TREE_ID")));
																item5.setAttribute("text",StringUtil.checkNull(treeMap5.get("TREE_NM")));

																if (objClassMap.containsValue(StringUtil.checkNull(treeMap5.get("ClassCode")))) {
																	item5.setAttribute("im0", StringUtil.checkNull(treeMap5.get("ClassIcon")));
																	item5.setAttribute("im1", StringUtil.checkNull(treeMap5.get("ClassIcon")));
																	item5.setAttribute("im2", StringUtil.checkNull(treeMap5.get("ClassIcon")));
																} else {
																	item5.setAttribute("im0", "folderClosed.gif");
																	item5.setAttribute("im1", "folderOpen.gif");
																	item5.setAttribute("im2", "folderClosed.gif");
																}
																item4.appendChild(item5);

																//////////////
																for (int i6 = 0; i6 < treeList.size(); i6++) {
																	Map treeMap6 = (Map) treeList.get(i6);
																	if (StringUtil.checkNull(treeMap6.get("PRE_TREE_ID")).equals(StringUtil.checkNull(treeMap5.get("TREE_ID")))) {
																		item6 = doc.createElement("item");
																		item6.setAttribute("id", StringUtil.checkNull(treeMap6.get("TREE_ID")));
																		item6.setAttribute("text", StringUtil.checkNull(treeMap6.get("TREE_NM")));

																		if (objClassMap.containsValue(StringUtil.checkNull(treeMap6.get("ClassCode")))) {
																			item6.setAttribute("im0",StringUtil.checkNull(treeMap6.get("ClassIcon")));
																			item6.setAttribute("im1",StringUtil.checkNull(treeMap6.get("ClassIcon")));
																			item6.setAttribute("im2",StringUtil.checkNull(treeMap6.get("ClassIcon")));
																		} else {
																			item6.setAttribute("im0","folderClosed.gif");
																			item6.setAttribute("im1", "folderOpen.gif");
																			item6.setAttribute("im2","folderClosed.gif");
																		}
																		item5.appendChild(item6);
																		
																		/////////////////////////////////////////////////////
																		
																		for (int i7 = 0; i7 < treeList.size(); i7++) {
																			Map treeMap7 = (Map) treeList.get(i7);
																			if (StringUtil.checkNull(treeMap7.get("PRE_TREE_ID")).equals(StringUtil.checkNull(treeMap6.get("TREE_ID")))) {
																				item7 = doc.createElement("item");
																				item7.setAttribute("id",StringUtil.checkNull(treeMap7.get("TREE_ID")));
																				item7.setAttribute("text",StringUtil.checkNull(treeMap7.get("TREE_NM")));

																				if (objClassMap.containsValue(StringUtil.checkNull(treeMap7.get("ClassCode")))) {
																					item7.setAttribute("im0", StringUtil.checkNull(treeMap7.get("ClassIcon")));
																					item7.setAttribute("im1", StringUtil.checkNull(treeMap7.get("ClassIcon")));
																					item7.setAttribute("im2", StringUtil.checkNull(treeMap7.get("ClassIcon")));
																				} else {
																					item7.setAttribute("im0","folderClosed.gif");
																					item7.setAttribute("im1","folderOpen.gif");
																					item7.setAttribute("im2","folderClosed.gif");
																				}
																				item6.appendChild(item7);
																				
																				for (int i8 = 0; i8 < treeList.size(); i8++) {
																					Map treeMap8 = (Map) treeList.get(i8);
																					if (StringUtil.checkNull(treeMap8.get("PRE_TREE_ID")).equals(StringUtil.checkNull(treeMap7.get("TREE_ID")))) {
																						item8 = doc.createElement("item");
																						item8.setAttribute("id",StringUtil.checkNull(treeMap8.get("TREE_ID")));
																						item8.setAttribute("text",StringUtil.checkNull(treeMap8.get("TREE_NM")));

																						if (objClassMap.containsValue(StringUtil.checkNull(treeMap8.get("ClassCode")))) {
																							item8.setAttribute("im0", StringUtil.checkNull(treeMap8.get("ClassIcon")));
																							item8.setAttribute("im1", StringUtil.checkNull(treeMap8.get("ClassIcon")));
																							item8.setAttribute("im2", StringUtil.checkNull(treeMap8.get("ClassIcon")));
																						} else {
																							item8.setAttribute("im0","folderClosed.gif");
																							item8.setAttribute("im1","folderOpen.gif");
																							item8.setAttribute("im2","folderClosed.gif");
																						}
																						item7.appendChild(item8);
																					}
																				}
																			}
																		}
																	}
																}
																///////////////
															}
														}
													}
												} // 4 Level END

											}
										} // 3 Level END
									}
								} // 2 Level END
							}
						}
					}
				}
			}
			treeElement.appendChild(item0);

			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();

			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			DOMSource source = new DOMSource(doc);
			StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFileName)));
			transformer.transform(source, result);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}

	@RequestMapping(value = "/itemInfoPop.do")
	public String itemInfoPop(HttpServletRequest request, ModelMap model, HashMap cmmMap) throws Exception {
		String url = "";
		try {

			List getList = new ArrayList();
			Map setMap = new HashMap();
			String ArcCode = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("ArcCode"), ""));
			String s_itemID = StringUtil.checkNull(request.getParameter("id"), "");
			String scrnType = StringUtil
					.replaceFilterString(StringUtil.checkNull(request.getParameter("scrnType"), ""));
			String MTCategory = StringUtil.checkNull(request.getParameter("MTCategory"), "");
			String changeSetID = StringUtil
					.replaceFilterString(StringUtil.checkNull(request.getParameter("changeSetID"), ""));
			String accMode = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("accMode"), ""));
			/* ModelID 보유 확인 */
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("ModelID", s_itemID);
			setMap.put("s_itemID", s_itemID);

			model.put("pop", "pop");
			model.put("scrnType", scrnType);

			setMap.put("ArcCode", ArcCode);
			setMap.put("s_itemID", s_itemID);
			setMap.put("scrnType", scrnType);
			String itemStatusCode = commonService.selectString("project_SQL.getItemStatus", setMap);

			// [ArcCode][ClassCode]의 Menu 취득
			getList = commonService.selectList("menu_SQL.getTabMenu", setMap);

			// [ClassCode]의 default Menu 취득
			if (getList.size() == 0) {
				setMap.put("ArcCode", "AR000000");
				getList = commonService.selectList("menu_SQL.getTabMenu", setMap);
			}

			// default Menu 취득
			if (getList.size() == 0) {
				setMap.put("ArcCode", "AR000000");
				setMap.put("s_itemID", "null");
				setMap.put("ClassCode", "CL01000");
				getList = commonService.selectList("menu_SQL.getTabMenu", setMap);
			}

			model.put("id", s_itemID);
			model.put("s_itemID", s_itemID);
			model.put("choiceIdentifier", s_itemID);
			model.put("option", ArcCode);
			model.put("level", (String) request.getParameter("level"));
			model.put("getList", getList);
			model.put("screenMode",
					StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("screenMode"))));
			model.put("MTCategory", MTCategory);
			model.put("focusedItemID", request.getParameter("focusedItemID"));
			model.put("changeSetID", changeSetID);

			setMap.put("s_itemID", s_itemID);
			Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);

            String sessionUserId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
            String checkOutOption = StringUtil.checkNull(itemInfo.get("CheckOutOption"));
            setMap.put("itemID", s_itemID);
            setMap.put("userID", sessionUserId);
            setMap.put("checkOutOption", checkOutOption);
            String checkItemAuthorTransferable = commonService.selectString("item_SQL.getCheckItemAuthorTransferable",setMap);
            model.put("checkItemAuthorTransferable", checkItemAuthorTransferable);
			//2025-02-14 Standard Menu 넘어가는 버그 수정
			//String description = StringUtil.checkNull(itemInfo.get("Description"),"");
			//itemInfo.put("Description", description.replaceAll("\r\n", "<br>"));
			itemInfo.remove("Description");

			model.put("itemInfo", itemInfo);

			if (accMode.equals("OPS")) {
				Map itemRevInfo = new HashMap();
				changeSetID = StringUtil.checkNull(itemInfo.get("ReleaseNo"));
				setMap.put("changeSetID", changeSetID);
				itemRevInfo = commonService.select("item_SQL.getItemAttrRevInfo", setMap);
				itemRevInfo.put("Blocked", itemInfo.get("Blocked"));
				itemRevInfo.put("ChangeMgt", itemInfo.get("ChangeMgt"));
				itemRevInfo.put("SubscrOption", itemInfo.get("SubscrOption"));
				itemRevInfo.put("CheckInOption", itemInfo.get("CheckInOption"));
				itemRevInfo.put("CheckOutOption", itemInfo.get("CheckOutOption"));
				itemRevInfo.put("Status", itemInfo.get("Status"));
				model.put("itemInfo", itemRevInfo);
			}

			setMap.put("itemID", s_itemID);
			String parentItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getParentItemID", setMap));
			model.put("parentItemID", parentItemID);

			setMap = new HashMap();
			String blankPhotoUrlPath = GlobalVal.HTML_IMG_DIR + "/blank_photo.png";
			String photoUrlPath = GlobalVal.EMP_PHOTO_URL;
			setMap.put("itemID", s_itemID);
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("blankPhotoUrlPath", blankPhotoUrlPath);
			setMap.put("photoUrlPath", photoUrlPath);
			setMap.put("isAll", "N");
			String empPhotoItemDisPlay = GlobalVal.EMP_PHOTO_ITEM_DISPLAY;
			model.put("empPhotoItemDisPlay", empPhotoItemDisPlay);

			List roleAssignMemberList = new ArrayList();
			if (!empPhotoItemDisPlay.equals("N")) {
				roleAssignMemberList = commonService.selectList("item_SQL.getAssignmentMemberList", setMap);
			}
			model.put("roleAssignMemberList", roleAssignMemberList);

			Map setValue = new HashMap();
			setValue.put("s_itemID", s_itemID);
			Map menuDisplayMap = commonService.select("item_SQL.getMenuIconDisplay", setValue);
			model.put("menuDisplayMap", menuDisplayMap);

//			String sessionAuthLev = String.valueOf(cmmMap.get("sessionAuthLev")); // 시스템 관리자
//			if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(cmmMap.get("sessionUserID"))
//					|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(cmmMap.get("sessionUserId"))
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			model.put("myItem", myItem);

			setMap.put("memberID", cmmMap.get("sessionUserId"));
			model.put("myItemCNT", StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCNT", setMap)));
			model.put("myItemSeq", StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemSeq", setMap)));

			// QuickCheckOut 설정
			String quickCheckOut = "N";
			String itemAuthorID = StringUtil.checkNull(itemInfo.get("AuthorID"));
			String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));

			setMap.put("ItemID", s_itemID);
			String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));

			if (itemInfo.get("Blocked").equals("2")) {
				// attributeBtn = "N";
				setMap = new HashMap();
				setMap.put("itemID", s_itemID);
				setMap.put("accessRight", "U");
				setMap.put("userID", sessionUserID);
				String myItemMember = StringUtil
						.checkNull(commonService.selectString("item_SQL.getMyItemMemberID", setMap));

				if ((StringUtil.checkNull(itemInfo.get("Status")).equals("REL")) && changeMgt.equals("1")
						&& (itemAuthorID.equals(sessionUserID) || myItemMember.equals(sessionUserID))) {
					quickCheckOut = "Y";
				}
			}

			model.put("quickCheckOut", quickCheckOut);
			model.put("s_itemID", s_itemID);
			model.put("accMode", accMode);

			setMap = new HashMap();
			setMap.put("userId", sessionUserID);
			setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", s_itemID);
			setMap.put("ProjectType", "CSR");
			setMap.put("isMainItem", "Y");
			List projectNameList = commonService.selectList("project_SQL.getProjectNameList", setMap);
			model.put("projectNameList", projectNameList.size());

			List itemPath = new ArrayList();

			itemPath = getRootItemPath(s_itemID, StringUtil.checkNull(request.getParameter("languageID")), itemPath);

			Collections.reverse(itemPath);
			model.put("itemPath", itemPath);
			model.put("loadEdit", request.getParameter("loadEdit"));			
			model.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
			model.put("focusedObjID", StringUtil.checkNull(request.getParameter("focusedObjID")));

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/itm/itemInfo/itemClassMenu");
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

	private List getStrItemPath(String strItemID, String languageID, List itemPath) throws Exception {
		Map setMap = new HashMap();
		
		setMap.put("strItemID", strItemID);
		setMap.put("itemID", strItemID);
		setMap.put("categoryCode", StringUtil.checkNull(commonService.selectString("item_SQL.getItemCategoryCode", setMap)));
		String ParentItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getParentStrItemID", setMap),"0");
		setMap.remove("categoryCode");
		setMap.put("itemID", ParentItemID);
		if (Integer.parseInt(ParentItemID) > 0 && ParentItemID != null) {
			String toItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getToItemID", setMap));
			if (Integer.parseInt(toItemID) != 0 && Integer.parseInt(toItemID) > 100
					&& Integer.parseInt(ParentItemID) != 0) {
				setMap.put("ItemID", toItemID);
				setMap.put("languageID", languageID);
				setMap.put("attrTypeCode", "AT00001");
				Map temp = commonService.select("attr_SQL.getItemAttrText", setMap);
				temp.put("itemID", ParentItemID);
				// temp.put("itemID",toItemID);
				itemPath.add(temp);
				getStrItemPath(ParentItemID, languageID, itemPath);
			}
		}
		return itemPath;
	}

	@RequestMapping(value = "/myItemList.do")
	public String myItemList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			model.put("s_itemID", request.getParameter("s_itemID"));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("statusList", request.getParameter("statusList"));
			model.put("status", StringUtil.checkNull(request.getParameter("status"), ""));
			model.put("srID", request.getParameter("srID"));
			model.put("changeMgt", request.getParameter("changeMgt"));
			model.put("assignmentType", request.getParameter("assignmentType"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/itm/structure/myItemList");
	}

	@RequestMapping(value = "/rcntViewedItemList.do")
	public String lastViewedItemList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			commandMap.put("Category", "ITMSTS");
			List statusList = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);

			model.put("statusList", statusList);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/itm/structure/rcntViewedItemList");
	}

	@RequestMapping(value = "/strItemInfoMgt.do")
	public String setStrItemTabMenu(ModelMap model, HashMap cmmMap) throws Exception {
		String url = "/itm/itemInfo/strItemInfoMgt";
		try {
			String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"), "");
			if(arcCode.equals(""))  arcCode = StringUtil.checkNull(cmmMap.get("ArcCode"), "");
			String strItemID = StringUtil.checkNull(cmmMap.get("itemID"), "");
			String srType = StringUtil.checkNull(cmmMap.get("srType"), "");
			String showElement = StringUtil.checkNull(cmmMap.get("showElement"), "");
			String currIdx = StringUtil.checkNull(cmmMap.get("currIdx"), "");
			String showPreNextIcon = StringUtil.checkNull(cmmMap.get("showPreNextIcon"), "");

			Map setMap = new HashMap();
			setMap.put("languageID", cmmMap.get("languageID"));
			setMap.put("itemID", strItemID);
			setMap.put("s_itemID", strItemID);

			String structureID = StringUtil.checkNull(commonService.selectString("item_SQL.getStructureID", setMap));
			model.put("structureID", structureID);

			String strItemTypeCode = StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCode", setMap));
			model.put("strItemTypeCode", strItemTypeCode);

			String strLevel = StringUtil.checkNull(commonService.selectString("item_SQL.getStrLevel", setMap));
			model.put("strLevel", strLevel);

			String mstItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getToItemID", setMap));
			model.put("mstItemID", mstItemID);

			List itemPath = new ArrayList();
			itemPath = getStrItemPath(strItemID, StringUtil.checkNull(cmmMap.get("languageID")), itemPath);
			Collections.reverse(itemPath);
			model.put("itemPath", itemPath);

			model.put("id", strItemID);
			model.put("s_itemID", strItemID);
			model.put("choiceIdentifier", strItemID);
			model.put("option", arcCode);

			setMap.put("ArcCode", arcCode);
			// setMap.put("s_itemID", mstItemID);

			// TODO:MPM관리자 -> Org/User -> 사용자 관리
			// TB_MENU_ALLOC.ClassCode IS NULL

			// [ArcCode][ClassCode]의 Menu 취득
			List getList = new ArrayList();
			setMap.put("fromModelYN", StringUtil.checkNull(cmmMap.get("fromModelYN"), ""));
			getList = commonService.selectList("menu_SQL.getTabMenu", setMap);

			// [ClassCode]의 default Menu 취득
			if (getList.size() == 0) {
				setMap.put("ArcCode", "AR000000");
				getList = commonService.selectList("menu_SQL.getTabMenu", setMap);
			}

			// default Menu 취득
			if (getList.size() == 0) {
				setMap.put("ArcCode", "AR000000");
				setMap.put("s_itemID", "null");
				setMap.put("ClassCode", "CL01000");
				getList = commonService.selectList("menu_SQL.getTabMenu", setMap);
			}

			String blankPhotoUrlPath = GlobalVal.HTML_IMG_DIR + "/blank_photo.png";
			String photoUrlPath = GlobalVal.EMP_PHOTO_URL;
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));

			setMap.put("blankPhotoUrlPath", blankPhotoUrlPath);
			setMap.put("photoUrlPath", photoUrlPath);
			setMap.put("isAll", "N");
			String empPhotoItemDisPlay = GlobalVal.EMP_PHOTO_ITEM_DISPLAY;
			model.put("empPhotoItemDisPlay", empPhotoItemDisPlay);

			List roleAssignMemberList = new ArrayList();
			if (!empPhotoItemDisPlay.equals("N")) {
				roleAssignMemberList = commonService.selectList("item_SQL.getAssignmentMemberList", setMap);
			}

			Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
			model.put("itemInfo", itemInfo);
			model.put("roleAssignMemberList", roleAssignMemberList);
			model.put("baseAtchUrl", GlobalVal.BASE_ATCH_URL);
			model.put("getList", getList);
			model.put("fromModelYN", StringUtil.checkNull(cmmMap.get("fromModelYN"), ""));

			String sessionAuthLev = String.valueOf(cmmMap.get("sessionAuthLev")); // 시스템 관리자
			String sessionUserId = StringUtil.checkNull(cmmMap.get("sessionUserId"));

//			if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(sessionUserId)
//					|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(sessionUserId)
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			model.put("myItem", myItem);

			setMap.put("memberID", cmmMap.get("sessionUserId"));
			model.put("myItemCNT", StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCNT", setMap)));
			model.put("myItemSeq", StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemSeq", setMap)));

			// QuickCheckOut 설정
			String quickCheckOut = "N";
			String itemAuthorID = StringUtil.checkNull(itemInfo.get("AuthorID"));
			String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));

			setMap.put("ItemID", strItemID);
			String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));

			if (itemInfo.get("Blocked").equals("2")) {
				// attributeBtn = "N";
				setMap = new HashMap();
				setMap.put("itemID", strItemID);
				setMap.put("accessRight", "U");
				setMap.put("userID", sessionUserID);
				String myItemMember = StringUtil
						.checkNull(commonService.selectString("item_SQL.getMyItemMemberID", setMap));
				if (itemInfo.get("Status").equals("REL") && changeMgt.equals("1")
						&& (itemAuthorID.equals(sessionUserID) || myItemMember.equals(sessionUserID))) {
					quickCheckOut = "Y";
				}
			}
			model.put("quickCheckOut", quickCheckOut);
			model.put("s_itemID", strItemID);

			setMap.put("DocCategory", "CS");
			String wfURL = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", setMap));
			model.put("wfURL", wfURL);

			setMap = new HashMap();
			setMap.put("userId", sessionUserID);
			setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", strItemID);
			setMap.put("ProjectType", "CSR");
			setMap.put("isMainItem", "Y");
			List projectNameList = commonService.selectList("project_SQL.getProjectNameList", setMap);
			model.put("projectNameList", projectNameList.size());

			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));

			/*
			 * if(srType != ""){ setMap.put("srType", srType); setMap.put("itemID",
			 * strItemID); int icpListCNT =
			 * commonService.selectList("esm_SQL.getEsrMSTList_gridList", setMap).size();
			 * model.put("srType", srType.toUpperCase()); model.put("icpListCNT",
			 * icpListCNT); } model.put("srType", srType);
			 */

			// Master Item Info //
			Map setValue = new HashMap();
			setValue.put("s_itemID", mstItemID);
			model.put("mstItemTypeCode", commonService.selectString("item_SQL.getItemTypeCode", setValue));
			model.put("menuDisplayMap", commonService.select("item_SQL.getMenuIconDisplay", setValue));

			model.put("showElement", showElement);
			model.put("currIdx", currIdx);
			model.put("showPreNextIcon", showPreNextIcon);
			model.put("showTOJ", StringUtil.checkNull(cmmMap.get("showTOJ")));
			model.put("strItemID", strItemID);
			model.put("strType", StringUtil.checkNull(cmmMap.get("strType")));

			String tLink = StringUtil.checkNull(cmmMap.get("tLink"));
			String linkNodeID = StringUtil.checkNull(cmmMap.get("linkNodeID"));
			String autoSave = StringUtil.checkNull(cmmMap.get("autoSave"));
			String myItemOnly = StringUtil.checkNull(cmmMap.get("myItemOnly"));
			String ownerTeamOnly = StringUtil.checkNull(cmmMap.get("ownerTeamOnly"));
			String docAllocRpt = StringUtil.checkNull(cmmMap.get("docAllocRpt"));

			model.put("tLink", tLink);
			model.put("linkNodeID", linkNodeID);
			model.put("autoSave", autoSave);
			model.put("myItemOnly", myItemOnly);
			model.put("ownerTeamOnly", ownerTeamOnly);
			model.put("docAllocRpt", docAllocRpt);
			model.put("myCSR", StringUtil.checkNull(cmmMap.get("myCSR")));
			model.put("csrIDs", StringUtil.checkNull(cmmMap.get("csrIDs")));
			model.put("udfSTR", StringUtil.checkNull(cmmMap.get("udfSTR"), ""));

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/subStrItemList.do")
	public String subStrItemList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		try {
			List returnData = new ArrayList();

			String mstitemID = StringUtil.checkNull(request.getParameter("mstItemID"), "");
			String strItemID = StringUtil.checkNull(request.getParameter("strItemID"), "");

			HashMap OccAttrInfo = new HashMap();
			OccAttrInfo.put("languageID", commandMap.get("sessionCurrLangType"));
			OccAttrInfo.put("s_itemID", mstitemID);
			OccAttrInfo.put("option", request.getParameter("option"));
			returnData = commonService.selectList("item_SQL.getClassOption", OccAttrInfo);
			model.put("classOption", returnData);

			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			OccAttrInfo.put("SelectMenuId", request.getParameter("option"));
			model.put("filterType", commonService.selectString("menu_SQL.selectArcFilter", OccAttrInfo));
			model.put("TreeDataFiltered",
					commonService.selectString("menu_SQL.selectArcTreeDataFiltered", OccAttrInfo));

			// Login user editor 권한 추가
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
			Map itemAuthorMap = commonService.select("project_SQL.getItemAuthorIDAndLockOwner", OccAttrInfo);
//			if (StringUtil.checkNull(itemAuthorMap.get("AuthorID"))
//					.equals(StringUtil.checkNull(commandMap.get("sessionUserId")))
//					|| StringUtil.checkNull(itemAuthorMap.get("LockOwner")).equals(
//							StringUtil.checkNull(commandMap.get("sessionUserId")))
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);

			// [ADD],[Del] 버튼 제어
			String blocked = StringUtil.checkNull(itemAuthorMap.get("Blocked"));
			if (!"0".equals(blocked)) {
				model.put("blocked", "Y");
			}

			/* 선택된 아이템의 해당 CSR 리스트를 취득 */
			OccAttrInfo.put("AuthorID", commandMap.get("sessionUserId"));
			returnData = commonService.selectList("project_SQL.getCsrListWithMember", OccAttrInfo);
			model.put("csrOption", returnData);

			// pop up 창에서 편집 버튼 제어 용
			model.put("pop", StringUtil.checkNull(request.getParameter("pop"), ""));

			OccAttrInfo = new HashMap();
			OccAttrInfo.put("arcCode", request.getParameter("option"));
			model.put("sortOption",
					StringUtil.checkNull(commonService.selectString("menu_SQL.getArcSortOption", OccAttrInfo)));

			model.put("showTOJ", StringUtil.checkNull(commandMap.get("showTOJ")));
			model.put("showElement", StringUtil.checkNull(commandMap.get("showElement")));
			model.put("strType", StringUtil.checkNull(commandMap.get("strType")));
			model.put("s_itemID", strItemID);
			model.put("mstItemID", mstitemID);
			model.put("strItemID", strItemID);
			model.put("option", request.getParameter("option"));
			model.put("structureID", StringUtil.checkNull(request.getParameter("structureID"), ""));
			model.put("mstItemTypeCode", StringUtil.checkNull(request.getParameter("mstItemTypeCode"), ""));
			model.put("strItemTypeCode", StringUtil.checkNull(request.getParameter("strItemTypeCode"), ""));
			model.put("strLevel", StringUtil.checkNull(request.getParameter("strLevel"), "0"));
			model.put("udfSTR", StringUtil.checkNull(request.getParameter("udfSTR")));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/itm/structure/subStrItemList");
	}

	@RequestMapping(value = "/upLowStrItemList.do")
	public String upLowStrItemList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			String strItemID = StringUtil.checkNull(request.getParameter("strItemID"), "");
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			Map setData = new HashMap();
			setData.put("s_itemID", s_itemID);
			// Login user editor 권한 추가
			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
			Map itemAuthorMap = commonService.select("project_SQL.getItemAuthorIDAndLockOwner", setData);
//			if (StringUtil.checkNull(itemAuthorMap.get("AuthorID"))
//					.equals(StringUtil.checkNull(commandMap.get("sessionUserId")))
//					|| StringUtil.checkNull(itemAuthorMap.get("LockOwner")).equals(
//							StringUtil.checkNull(commandMap.get("sessionUserId")))
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);
			
			// setData.put("itemID", s_itemID);
			setData.put("itemID", strItemID);
			setData.put("categoryCode", "ST2");
			String toItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getToItemID", setData));

			model.put("strType", StringUtil.checkNull(commandMap.get("strType")));
			model.put("s_itemID", s_itemID);
			model.put("toItemID", toItemID);

			setData.put("strItemID", s_itemID);
			setData.put("s_itemID", toItemID);
			setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			setData.put("upLow", "Up");
			List upList = commonService.selectList("item_SQL.getUpLowStrItemList_gridList", setData);
			setData.put("upLow", "Lower");
			List lowerList = commonService.selectList("item_SQL.getUpLowStrItemList_gridList", setData);

			model.put("UpCNT", upList.size());
			model.put("LowerCNT", lowerList.size());
			model.put("AllCNT", upList.size() + lowerList.size());
			model.put("option", StringUtil.checkNull(commandMap.get("option")));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/itm/structure/upLowStrItemList");
	}

	@RequestMapping(value = "/deleteStrItem.do")
	public String deleteStrItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			String[] arrayStr = StringUtil.checkNull(request.getParameter("items"), "").split(",");
			if (arrayStr != null) {
				for (int i = 0; i < arrayStr.length; i++) {
					Map setMap = new HashMap();
					Map setData = new HashMap();
					String strItemID = arrayStr[i];
					setMap.put("ItemID", strItemID);
					setMap.put("deleted", 1);
					setMap.put("LastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
					commonService.update("item_SQL.updateItem", setMap);
					
					// 삭제 item이 포함된 모델 재생성
					setMap.put("itemID", strItemID);
					List modelList = commonService.selectList("model_SQL.getModelListFromElmLink", setMap);
					if(modelList.size()>0) {
						setData.put("LanguageID", commandMap.get("sessionCurrLangType"));
						setData.put("UserId", commandMap.get("sessionUserId")); 
						setData.put("FontFamily", commandMap.get("sessionDefFont")); 
						setData.put("FontStyle", commandMap.get("sessionDefFontStyle")); 
						setData.put("FontSize", commandMap.get("sessionDefFontSize")); 
						setData.put("FontColor", commandMap.get("sessionDefFontColor")); 
						setData.put("GUBUN", "insertBaseModel");
						setData.put("dbFuncCode", "CREATE_BEDP");
						for(int z=0; modelList.size() > z; z++) {
							Map modelInfoMap = (Map)modelList.get(z);
							
							setData.put("itemID", StringUtil.checkNull(modelInfoMap.get("ItemID")));
					    	setData.put("orgMTCategory", "BAS"); 	
					    	setData.put("updateMTCategory", "VER"); 
			    			
		 					commonService.update("model_SQL.updateModelCat", setData);
					    	 
					    	// CREATE BEDP Model
		 					setData.put("ItemID", StringUtil.checkNull(modelInfoMap.get("ItemID")));
					    	commonService.insert("model_SQL.createBaseModel", setData);
						}
					}
				}
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제
																													// 성공
			target.put(AJAX_SCRIPT, "this.urlReload();this.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제
																													// 오류
																													// 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/categorizeItemByDocument.do")
	public String categorizeItemByDocument(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		HashMap target = new HashMap();
		try {
			Map setData = new HashMap();
			String mstItemID = StringUtil.checkNull(request.getParameter("mstItemID"), "");
			String strItemID = StringUtil.checkNull(request.getParameter("strItemID"), "");
			String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String sessionTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));

			setData.put("mstItemID", mstItemID);
			setData.put("strItemID", strItemID);
			setData.put("sessionTeamID", sessionTeamID);
			setData.put("sessionUserID", sessionUserID);
			setData.put("itemID", strItemID);
			String structureID = StringUtil.checkNull(commonService.selectString("item_SQL.getStructureID", setData));
			setData.put("structureID", structureID);

			String returnRowCount = commonService.selectString("item_SQL.categorizeItemByDocumentProc", setData);
			// System.out.println("return Inserted RowCount :"+returnRowCount);

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "this.doCallBack();");
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/getTreeLevelList.do")
	public String getTreeLevelList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {			
			Map setData = new HashMap();
			String exceptLevel = "'0','1'";
			setData.put("itemTypeCode", "ST00016");
			setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));
			setData.put("exceptLevel", exceptLevel);
			
			List classList = commonService.selectList("item_SQL.getRefClassCodeList", setData);
			JSONArray gridData = new JSONArray(classList);
			model.put("gridData", gridData);
			model.put("arcCode", StringUtil.checkNull(commandMap.get("arcCode")));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/itm/structure/treeLevelList");
	}
	
	@RequestMapping(value = "/upLowUdfStrItemLevelList.do")
	public String upLowStrItemLevelList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {	
			
			model.put("defaultClassCodes", StringUtil.checkNull(commandMap.get("defaultClassCodes"), ""));
			model.put("myCSR", StringUtil.checkNull(commandMap.get("myCSR"), ""));
			model.put("csrIDs", StringUtil.checkNull(commandMap.get("csrIDs"), ""));
			model.put("udfSTR", StringUtil.checkNull(commandMap.get("udfSTR"), ""));
			model.put("arcCode", StringUtil.checkNull(commandMap.get("arcCode")));
			
			commandMap.put("categoryCode", "ST3");
			List getUdfStrClassSortList = commonService.selectList("item_SQL.getUdfStrClassSort", commandMap);
			model.put("udfStrClassSortNameCNT", getUdfStrClassSortList.size());
			
			String defaultUdfClassSortCode = "";
			String defaultUdfClassSortName = "";
			String sorting = "ORDER BY CASE T.NAME ";
			int idx = 1;
			if(getUdfStrClassSortList.size()>0) {
				Map udfClassSortInfo = (Map)getUdfStrClassSortList.get(0);
				defaultUdfClassSortCode =  StringUtil.checkNull(udfClassSortInfo.get("CODE"));
				defaultUdfClassSortName =  StringUtil.checkNull(udfClassSortInfo.get("NAME"));
				
				String codeSp[] = defaultUdfClassSortName.split(">");
				for(int i=0; codeSp.length >i; i++) {
					sorting += " WHEN '"+ codeSp[i] + "' THEN "+idx;
					idx++;
				}
				sorting += " ELSE 6 END";
			}else {
				sorting = "";
			}
			
			model.put("defaultUdfClassSortCode", defaultUdfClassSortCode);
			model.put("defaultUdfClassSortName", defaultUdfClassSortName);
			model.put("sorting", sorting);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/itm/structure/upLowUdfStrItemLevelList");
	}
	
	@RequestMapping(value = "/createUdfStrMgt.do")
	public String createUdfStrMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();
		try {
			cmmMap.put("SelectMenuId", cmmMap.get("arcCode"));
			String SQL_CODE=StringUtil.checkNull(commonService.selectString("menu_SQL.getMenuTreeSqlName", cmmMap) ,"commonCode"); // itemStr_treeList
		
			String defaultClassCodesArr[] = StringUtil.checkNull(cmmMap.get("defaultClassCodes")).split(",");
			String classCodesArr[] = StringUtil.checkNull(cmmMap.get("classCodes")).split(",");
			String levelsArr[] = StringUtil.checkNull(cmmMap.get("levels")).split(",");
			String classNamesArr[] = StringUtil.checkNull(cmmMap.get("classNames")).split(",");
			String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"));
			String myCSR = StringUtil.checkNull(cmmMap.get("myCSR"));
			String csrIDs = StringUtil.checkNull(cmmMap.get("csrIDs"));
			String sorceArcCode = StringUtil.checkNull(cmmMap.get("sorceArcCode"));
			
			String defaultClassCodes = "";
			String classCodes = "";
			String classNames = "";
			//String levels = "";
			for (int i = 0; i < defaultClassCodesArr.length; i++) {			    
			    if (i > 0) {
			        defaultClassCodes += ",";
			    }
			    defaultClassCodes += "'" + StringUtil.checkNull(defaultClassCodesArr[i]) + "'";
			}
			for (int i = 0; i < classCodesArr.length; i++) {			    
			    if (i > 0) {
			        classCodes += ",";
			        classNames += ">";
			    }
			    classCodes += "'" + StringUtil.checkNull(classCodesArr[i]) + "'";
			    classNames += StringUtil.checkNull(classNamesArr[i]);
			}
			
			cmmMap.put("defaultClassCodes", defaultClassCodes);
			cmmMap.put("classCodes", classCodes);
			cmmMap.put("classNames", classNames);
			cmmMap.put("udfSTR", "");
			cmmMap.put("SelectMenuId", sorceArcCode); //BEDP002
			cmmMap.put("sortOption_ORG", cmmMap.get("sortOption"));
			cmmMap.put("sortOption", "");
			cmmMap.put("udfNewSTR", "Y");
			
			List result = commonService.selectList("menu_SQL." + SQL_CODE, cmmMap);
			cmmMap.remove(defaultClassCodes);
			
			cmmMap.put("udfSTR", "Y");
			cmmMap.put("sortOption", cmmMap.get("sortOption_ORG"));
			
			List<Map<String, Object>> treeAllList = new ArrayList<>();
			Map setData = new HashMap();
			//String newRootItemID = "";
			
			setData.put("arcCode", arcCode);
			setData.put("categoryCode", "ST3");
			String rootStrItemID = ""; // rootStrItemID 이면서 structureID
			if(result.size() > 0) {
				
				//commonService.delete("menu_SQL.deleteST3", setData);
				
				for(int i=0; result.size() > i; i++) {
					setData = new HashMap();
					setData.put("udfSTR", "Y");
					Map resultMap = (Map)result.get(i);
					
					setData.put("sessionUserId", StringUtil.checkNull(cmmMap.get("sessionUserId")));
					setData.put("sessionTeamId", StringUtil.checkNull(cmmMap.get("sessionTeamId")));
					
					if( StringUtil.checkNull(resultMap.get("ClassCode")).equals("STL0000") && StringUtil.checkNull(resultMap.get("PRE_TREE_ID")).equals("0")) { // ROOT ItemID 생성
						rootStrItemID = commonService.selectString("item_SQL.getItemMaxID", setData);
						setData.put("newItemID", rootStrItemID);
						setData.put("s_itemID", StringUtil.checkNull(resultMap.get("FromItemID"))); // fromItemID
						setData.put("strItemID",  StringUtil.checkNull(resultMap.get("PRE_TREE_ID")));
						setData.put("structureID", rootStrItemID); 
						
						setData.put("toItemID", StringUtil.checkNull(resultMap.get("ToItemID")));
						setData.put("cxnItemType", "ST00016");
						setData.put("strLevel", StringUtil.checkNull(resultMap.get("Level")));
						setData.put("cxnClassCode", StringUtil.checkNull(resultMap.get("ClassCode")));
						setData.put("categoryCode", "ST3");
						setData.put("strType", "2");
						
						setData.put("refCItemID",  StringUtil.checkNull(resultMap.get("TREE_ID")));
						
						setData.put("classNames", classNames);
						setData.put("languageID",  StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
						setData.put("projectID", StringUtil.checkNull(resultMap.get("ProjectID")));
						setData.put("AT00001", classNames);
						CxnItemService.save(setData); // Create rootItemID, L0 Item 
						setData.remove("AT00001");
					}
									
					if( StringUtil.checkNull(resultMap.get("ClassCode")).equals("STL1600") && !StringUtil.checkNull(resultMap.get("PRE_TREE_ID")).equals("0")) {
						//String rootItemID = StringUtil.checkNull(resultMap.get("TREE_ID"));
						String newItemID = commonService.selectString("item_SQL.getItemMaxID", setData);
						
						setData.put("newItemID", newItemID);
						setData.put("s_itemID", StringUtil.checkNull(resultMap.get("FromItemID"))); // fromItemID
						setData.put("strItemID", rootStrItemID);
						setData.put("structureID", rootStrItemID); 
						
						setData.put("toItemID", StringUtil.checkNull(resultMap.get("ToItemID")));
						setData.put("cxnItemType", "ST00016");
						setData.put("strLevel", StringUtil.checkNull(resultMap.get("Level")));
						setData.put("cxnClassCode", StringUtil.checkNull(resultMap.get("ClassCode")));
						setData.put("categoryCode", "ST3");
						setData.put("strType", "2");
						
						setData.put("refCItemID",  StringUtil.checkNull(resultMap.get("TREE_ID")));
						
						setData.put("classNames", classNames);
						setData.put("languageID",  StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
						setData.put("projectID", StringUtil.checkNull(resultMap.get("ProjectID")));
						CxnItemService.save(setData); // Create rootItemID, L0 Item 
						
						//String newSturctureID = newItemID; // 0 level r-BHET 5만톤 strItemID 
						if(StringUtil.checkNull(resultMap.get("ClassCode")).equals("STL1600")) { // 첫번째 classCode 
							if( classCodesArr.length > 0 && !StringUtil.checkNull(classCodesArr[0]).equals("")) {
								Map subData = new HashMap();
									
								subData.put("L0ItemID", StringUtil.checkNull(resultMap.get("TREE_ID")));
								subData.put("itemClassCode", StringUtil.checkNull(classCodesArr[0]));
								List subResult1 = commonService.selectList("item_SQL.getItemStrHier", subData); // 1.class filter
								
								if(subResult1.size() > 0 ) {
									for(int z=0; subResult1.size() > z; z++) {
										Map subMap1 = (Map)subResult1.get(z);
										
										setData.put("s_itemID", StringUtil.checkNull(subMap1.get("StrItemID")));
										
										Map itemInfo1 = (Map)commonService.select("project_SQL.getItemInfo", setData);
										
										setData = new HashMap();
										setData.put("udfSTR", "Y");
										String newItemID1 = commonService.selectString("item_SQL.getItemMaxID", setData);
										
										setData.put("newItemID", newItemID1);
										setData.put("s_itemID", StringUtil.checkNull(resultMap.get("ToItemID"))); // fromItemID
										setData.put("strItemID", newItemID); // ParentID 
										setData.put("toItemID", StringUtil.checkNull(itemInfo1.get("ToItemID")));
										setData.put("structureID", rootStrItemID); 
										
										setData.put("cxnItemType", "ST00016");
										setData.put("strLevel", StringUtil.checkNull(itemInfo1.get("Level")));
										setData.put("cxnClassCode", StringUtil.checkNull(itemInfo1.get("ClassCode")));
										setData.put("categoryCode", "ST3");
										setData.put("strType", "2");
										setData.put("refCItemID",  StringUtil.checkNull(subMap1.get("StrItemID")));
										setData.put("sessionUserId", StringUtil.checkNull(cmmMap.get("sessionUserId")));
										setData.put("sessionTeamId", StringUtil.checkNull(cmmMap.get("sessionTeamId")));
										
										setData.put("classNames", classNames);
										setData.put("languageID",  StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
										setData.put("projectID", StringUtil.checkNull(itemInfo1.get("ProjectID")));
										CxnItemService.save(setData); // Create Root Item 
										
										setData.put("pNewItemID",newItemID1);
										createUdfStrSubMgt(setData); // Create L6
										
										if( classCodesArr.length > 1 && !StringUtil.checkNull(classCodesArr[1]).equals("")) { // 2. class filter
											
											// 상위 level 이 더 크면 상위레벨 classCode 로 조회 
											List subResult2 = new ArrayList();
											subData = new HashMap();
											if(Integer.parseInt(levelsArr[1]) < Integer.parseInt(levelsArr[0])) {
												subData.put("itemClassCode", StringUtil.checkNull(classCodesArr[0]));
												subData.put("strItemID", StringUtil.checkNull(subMap1.get("StrItemID")));
												
												//예) 5 level-> 4 level 
												// 5level -> strItemID, classCode 로 조회  -> filtering 할 class 의 leveㅣ Item 조회 : 가져올값 : L4ItemID *** 해당레빌의 itemID null 체크는 필수 
												
												if(StringUtil.checkNull(levelsArr[1]).equals("1")) {
													subData.put("L1ItemIDCheck", "Y");
												} else if(StringUtil.checkNull(levelsArr[1]).equals("2")) {
													subData.put("L2ItemIDCheck", "Y");
												} else if(StringUtil.checkNull(levelsArr[1]).equals("3")) {
													subData.put("L3ItemIDCheck", "Y");
												} else if(StringUtil.checkNull(levelsArr[1]).equals("4")) {
													subData.put("L4ItemIDCheck", "Y");
												} else if(StringUtil.checkNull(levelsArr[1]).equals("5")) {
													subData.put("L5ItemIDCheck", "Y");
												}
												
												subResult2 = commonService.selectList("item_SQL.getItemStrHier", subData); // 2.class filter
											
											} else {
												
												//예) 4 level-> 5 level 
												// 4level -> L4ItemID, classCode(L5) 로 조회  -> 가져올값 : StrItemID 
												if(StringUtil.checkNull(levelsArr[0]).equals("1")) {
													subData.put("L1ItemID", StringUtil.checkNull(itemInfo1.get("ItemID")));
												} else if(StringUtil.checkNull(levelsArr[0]).equals("2")) {
													subData.put("L2ItemID", StringUtil.checkNull(itemInfo1.get("ItemID")));
												} else if(StringUtil.checkNull(levelsArr[0]).equals("3")) {
													subData.put("L3ItemID", StringUtil.checkNull(itemInfo1.get("ItemID")));
												} else if(StringUtil.checkNull(levelsArr[0]).equals("4")) {
													subData.put("L4ItemID", StringUtil.checkNull(itemInfo1.get("ItemID")));
												} else if(StringUtil.checkNull(levelsArr[0]).equals("5")) {
													subData.put("L5ItemID", StringUtil.checkNull(itemInfo1.get("ItemID")));
												}
												subData.put("itemClassCode", StringUtil.checkNull(classCodesArr[1]));
												subResult2 = commonService.selectList("item_SQL.getItemStrHier", subData); // 2.class filter
											}
											
											if(subResult2.size() > 0 ) {
												for(int y=0; subResult2.size() > y; y++) {
													Map subMap2 = (Map)subResult2.get(y);
													setData = new HashMap();
													
													if(Integer.parseInt(levelsArr[1]) > Integer.parseInt(levelsArr[0])) {
														setData.put("s_itemID", StringUtil.checkNull(subMap2.get("StrItemID")));
													}else {
														if(StringUtil.checkNull(levelsArr[1]).equals("1")) {
															setData.put("s_itemID", StringUtil.checkNull(subMap2.get("L1ItemID")));
														} else if(StringUtil.checkNull(levelsArr[1]).equals("2")) {
															setData.put("s_itemID", StringUtil.checkNull(subMap2.get("L2ItemID")));
														} else if(StringUtil.checkNull(levelsArr[1]).equals("3")) {
															setData.put("s_itemID", StringUtil.checkNull(subMap2.get("L3ItemID")));
														} else if(StringUtil.checkNull(levelsArr[1]).equals("4")) {
															setData.put("s_itemID", StringUtil.checkNull(subMap2.get("L4ItemID")));
														} else if(StringUtil.checkNull(levelsArr[1]).equals("5")) {
															setData.put("s_itemID", StringUtil.checkNull(subMap2.get("L5ItemID")));
														}
													}
													Map itemInfo2 = (Map)commonService.select("project_SQL.getItemInfo", setData);
													
													
													setData.put("udfSTR", "Y");
													String newItemID2 = commonService.selectString("item_SQL.getItemMaxID", setData);
													
													setData.put("newItemID", newItemID2);
													setData.put("s_itemID", StringUtil.checkNull(itemInfo1.get("ToItemID"))); // fromItemID
													setData.put("strItemID", newItemID1); // ParentID 
													setData.put("toItemID", StringUtil.checkNull(itemInfo2.get("ToItemID")));
													setData.put("structureID", rootStrItemID); 
													
													setData.put("cxnItemType", "ST00016");
													setData.put("strLevel", StringUtil.checkNull(itemInfo2.get("Level")));
													setData.put("cxnClassCode", StringUtil.checkNull(itemInfo2.get("ClassCode")));
													setData.put("categoryCode", "ST3");
													setData.put("strType", "2");
													setData.put("refCItemID",  StringUtil.checkNull(itemInfo2.get("ItemID")));
													setData.put("sessionUserId", StringUtil.checkNull(cmmMap.get("sessionUserId")));
													setData.put("sessionTeamId", StringUtil.checkNull(cmmMap.get("sessionTeamId")));
													setData.put("classNames", classNames);
													setData.put("languageID",  StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
													setData.put("projectID", StringUtil.checkNull(itemInfo2.get("ProjectID")));
													
													CxnItemService.save(setData); // Create 2. class filter
																								
													setData.put("pNewItemID",newItemID2);
													createUdfStrSubMgt(setData); // Create L6
													
													// 3 class filter Start													
													if(classCodesArr.length > 2 && !StringUtil.checkNull(classCodesArr[2]).equals("") ) { // 3. class filter
														
														// 상위 level 이 더 크면 상위레벨 classCode 로 조회 
														List subResult3 = new ArrayList();
														subData = new HashMap();
														
														System.out.println("세번째 하이러 조회 +>");
														if(Integer.parseInt(levelsArr[2]) < Integer.parseInt(levelsArr[1])) { // 본인이 str 인것엣 해당 클래스 item 찾기
															//subData.put("itemClassCode", StringUtil.checkNull(classCodesArr[1]));
															subData.put("itemClassCode", StringUtil.checkNull(itemInfo2.get("ClassCode")));
															subData.put("strItemID", StringUtil.checkNull(itemInfo2.get("ItemID")));
															if(StringUtil.checkNull(levelsArr[2]).equals("1")) {
																subData.put("L1ItemIDCheck", "Y");
															} else if(StringUtil.checkNull(levelsArr[2]).equals("2")) {
																subData.put("L2ItemIDCheck", "Y");
															} else if(StringUtil.checkNull(levelsArr[2]).equals("3")) {
																subData.put("L3ItemIDCheck", "Y");
															} else if(StringUtil.checkNull(levelsArr[2]).equals("4")) {
																subData.put("L4ItemIDCheck", "Y");
															} else if(StringUtil.checkNull(levelsArr[2]).equals("5")) {
																subData.put("L5ItemIDCheck", "Y");
															}
																										
															subResult3 = commonService.selectList("item_SQL.getItemStrHier", subData); // 3.class filter
														
														} else { // 본인을 상위 level item 으로 갖고 있는 strItemID 찾기 
															
															if(StringUtil.checkNull(levelsArr[1]).equals("1")) {
																subData.put("L1ItemID", StringUtil.checkNull(itemInfo2.get("ItemID")));
															} else if(StringUtil.checkNull(levelsArr[1]).equals("2")) {
																subData.put("L2ItemID", StringUtil.checkNull(itemInfo2.get("ItemID")));
															} else if(StringUtil.checkNull(levelsArr[1]).equals("3")) {
																subData.put("L3ItemID", StringUtil.checkNull(itemInfo2.get("ItemID")));
															} else if(StringUtil.checkNull(levelsArr[1]).equals("4")) {
																subData.put("L4ItemID", StringUtil.checkNull(itemInfo2.get("ItemID")));
															} else if(StringUtil.checkNull(levelsArr[1]).equals("5")) {
																subData.put("L5ItemID", StringUtil.checkNull(itemInfo2.get("ItemID")));
															}
															subData.put("itemClassCode", StringUtil.checkNull(classCodesArr[2]));
															subResult3 = commonService.selectList("item_SQL.getItemStrHier", subData); // 3.class filter
														}
														
														if(subResult3.size() > 0 ) {
															for(int x=0; subResult3.size() > x; x++) {
																Map subMap3 = (Map)subResult3.get(x);
																setData = new HashMap();
																if(Integer.parseInt(levelsArr[2]) > Integer.parseInt(levelsArr[1])) {
																	setData.put("s_itemID", StringUtil.checkNull(subMap3.get("StrItemID")));
																}else {
																	if(StringUtil.checkNull(levelsArr[2]).equals("1")) {
																		setData.put("s_itemID", StringUtil.checkNull(subMap3.get("L1ItemID")));
																	} else if(StringUtil.checkNull(levelsArr[2]).equals("2")) {
																		setData.put("s_itemID", StringUtil.checkNull(subMap3.get("L2ItemID")));
																	} else if(StringUtil.checkNull(levelsArr[2]).equals("3")) {
																		setData.put("s_itemID", StringUtil.checkNull(subMap3.get("L3ItemID")));
																	} else if(StringUtil.checkNull(levelsArr[2]).equals("4")) {
																		setData.put("s_itemID", StringUtil.checkNull(subMap3.get("L4ItemID")));
																	} else if(StringUtil.checkNull(levelsArr[2]).equals("5")) {
																		setData.put("s_itemID", StringUtil.checkNull(subMap3.get("L5ItemID")));
																	}
																}
																Map itemInfo3 = (Map)commonService.select("project_SQL.getItemInfo", setData);
																
																
																setData.put("udfSTR", "Y");
																String newItemID3 = commonService.selectString("item_SQL.getItemMaxID", setData);
																
																setData.put("newItemID", newItemID3);
																setData.put("s_itemID", StringUtil.checkNull(itemInfo2.get("ToItemID"))); // fromItemID
																setData.put("strItemID", newItemID2); // ParentID 
																setData.put("toItemID", StringUtil.checkNull(itemInfo3.get("ToItemID")));
																setData.put("structureID", rootStrItemID); 
																
																setData.put("cxnItemType", "ST00016");
																setData.put("strLevel", StringUtil.checkNull(itemInfo3.get("Level")));
																setData.put("cxnClassCode", StringUtil.checkNull(itemInfo3.get("ClassCode")));
																setData.put("categoryCode", "ST3");
																setData.put("strType", "2");
																setData.put("refCItemID",  StringUtil.checkNull(itemInfo3.get("ItemID")));
																setData.put("sessionUserId", StringUtil.checkNull(cmmMap.get("sessionUserId")));
																setData.put("sessionTeamId", StringUtil.checkNull(cmmMap.get("sessionTeamId")));
																
																setData.put("classNames", classNames);
																setData.put("languageID",  StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
																setData.put("projectID", StringUtil.checkNull(itemInfo3.get("ProjectID")));
																
																CxnItemService.save(setData); // Create3. class filter
																setData.put("pNewItemID",newItemID3);
																createUdfStrSubMgt(setData); // Create L6
																// create 4 class filter start /////////////////////////////////////////////////////////////////////////////////////////////////////////////
																
																// 4 class filter Start													
																if(classCodesArr.length > 3 && !StringUtil.checkNull(classCodesArr[3]).equals("") ) { // 4. class filter
																	
																	// 상위 level 이 더 크면 상위레벨 classCode 로 조회 
																	List subResult4 = new ArrayList();
																	subData = new HashMap();
																	if(Integer.parseInt(levelsArr[3]) < Integer.parseInt(levelsArr[2])) { // 본인이 str 인것엣 해당 클래스 item 찾기
																																				
																		subData.put("itemClassCode", StringUtil.checkNull(itemInfo3.get("ClassCode")));
																		subData.put("strItemID", StringUtil.checkNull(itemInfo3.get("ItemID")));
																		
																		if(StringUtil.checkNull(levelsArr[3]).equals("1")) {
																			subData.put("L1ItemIDCheck", "Y");
																		} else if(StringUtil.checkNull(levelsArr[3]).equals("2")) {
																			subData.put("L2ItemIDCheck", "Y");
																		} else if(StringUtil.checkNull(levelsArr[3]).equals("3")) {
																			subData.put("L3ItemIDCheck", "Y");
																		} else if(StringUtil.checkNull(levelsArr[3]).equals("4")) {
																			subData.put("L4ItemIDCheck", "Y");
																		} else if(StringUtil.checkNull(levelsArr[3]).equals("5")) {
																			subData.put("L5ItemIDCheck", "Y");
																		}
																													
																		subResult4 = commonService.selectList("item_SQL.getItemStrHier", subData); //4.class filter
																	
																	} else { // 본인을 상위 level item 으로 갖고 있는 strItemID 찾기 
																		
																		if(StringUtil.checkNull(levelsArr[2]).equals("1")) {
																			subData.put("L1ItemID", StringUtil.checkNull(itemInfo3.get("ItemID")));
																		} else if(StringUtil.checkNull(levelsArr[2]).equals("2")) {
																			subData.put("L2ItemID", StringUtil.checkNull(itemInfo3.get("ItemID")));
																		} else if(StringUtil.checkNull(levelsArr[2]).equals("3")) {
																			subData.put("L3ItemID", StringUtil.checkNull(itemInfo3.get("ItemID")));
																		} else if(StringUtil.checkNull(levelsArr[2]).equals("4")) {
																			subData.put("L4ItemID", StringUtil.checkNull(itemInfo3.get("ItemID")));
																		} else if(StringUtil.checkNull(levelsArr[2]).equals("5")) {
																			subData.put("L5ItemID", StringUtil.checkNull(itemInfo3.get("ItemID")));
																		}
																		subData.put("itemClassCode", StringUtil.checkNull(classCodesArr[3]));
																		subResult4 = commonService.selectList("item_SQL.getItemStrHier", subData); // 3.class filter
																	}
																	
																	System.out.println("네번째 class filter subResult4: "+subResult4.size());
																	if(subResult4.size() > 0 ) {
																		for(int v=0; subResult4.size() > v; v++) {
																			Map subMap4 = (Map)subResult4.get(v);
																			setData = new HashMap();
																			if(Integer.parseInt(levelsArr[3]) > Integer.parseInt(levelsArr[2])) {
																				setData.put("s_itemID", StringUtil.checkNull(subMap4.get("StrItemID")));
																			}else {
																				if(StringUtil.checkNull(levelsArr[3]).equals("1")) {
																					setData.put("s_itemID", StringUtil.checkNull(subMap4.get("L1ItemID")));
																				} else if(StringUtil.checkNull(levelsArr[3]).equals("2")) {
																					setData.put("s_itemID", StringUtil.checkNull(subMap4.get("L2ItemID")));
																				} else if(StringUtil.checkNull(levelsArr[3]).equals("3")) {
																					setData.put("s_itemID", StringUtil.checkNull(subMap4.get("L3ItemID")));
																				} else if(StringUtil.checkNull(levelsArr[3]).equals("4")) {
																					setData.put("s_itemID", StringUtil.checkNull(subMap4.get("L4ItemID")));
																				} else if(StringUtil.checkNull(levelsArr[3]).equals("5")) {
																					setData.put("s_itemID", StringUtil.checkNull(subMap4.get("L5ItemID")));
																				}
																			}
																			Map itemInfo4 = (Map)commonService.select("project_SQL.getItemInfo", setData);
																			
																			
																			setData.put("udfSTR", "Y");
																			String newItemID4 = commonService.selectString("item_SQL.getItemMaxID", setData);
																			
																			setData.put("newItemID", newItemID4);
																			setData.put("s_itemID", StringUtil.checkNull(itemInfo3.get("ToItemID"))); // fromItemID
																			setData.put("strItemID", newItemID3); // ParentID 
																			setData.put("toItemID", StringUtil.checkNull(itemInfo4.get("ToItemID")));
																			setData.put("structureID", rootStrItemID); 
																			
																			setData.put("cxnItemType", "ST00016");
																			setData.put("strLevel", StringUtil.checkNull(itemInfo4.get("Level")));
																			setData.put("cxnClassCode", StringUtil.checkNull(itemInfo4.get("ClassCode")));
																			setData.put("categoryCode", "ST3");
																			setData.put("strType", "2");
																			setData.put("refCItemID",  StringUtil.checkNull(itemInfo4.get("ItemID")));
																			setData.put("sessionUserId", StringUtil.checkNull(cmmMap.get("sessionUserId")));
																			setData.put("sessionTeamId", StringUtil.checkNull(cmmMap.get("sessionTeamId")));
																			
																			setData.put("classNames", classNames);
																			setData.put("languageID",  StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
																			setData.put("projectID", StringUtil.checkNull(itemInfo4.get("ProjectID")));
																			
																			CxnItemService.save(setData); // Create4. class filter
																			setData.put("pNewItemID",newItemID4);
																			createUdfStrSubMgt(setData); // Create L6
																			
																			///// Create 5 class filter Start /////////////////////////////////////////////////////////////////////////
																			
																			// 5 class filter Start													
																			if(classCodesArr.length > 4 && !StringUtil.checkNull(classCodesArr[4]).equals("") ) { // 5. class filter
																				
																				// 상위 level 이 더 크면 상위레벨 classCode 로 조회 
																				List subResult5 = new ArrayList();
																				subData = new HashMap();
																				if(Integer.parseInt(levelsArr[4]) < Integer.parseInt(levelsArr[3])) { // 본인이 str 인것엣 해당 클래스 item 찾기
																					subData.put("itemClassCode", StringUtil.checkNull(itemInfo4.get("ClassCode")));
																					subData.put("strItemID", StringUtil.checkNull(itemInfo4.get("ItemID")));
																					
																					if(StringUtil.checkNull(levelsArr[4]).equals("1")) {
																						subData.put("L1ItemIDCheck", "Y");
																					} else if(StringUtil.checkNull(levelsArr[4]).equals("2")) {
																						subData.put("L2ItemIDCheck", "Y");
																					} else if(StringUtil.checkNull(levelsArr[4]).equals("3")) {
																						subData.put("L3ItemIDCheck", "Y");
																					} else if(StringUtil.checkNull(levelsArr[4]).equals("4")) {
																						subData.put("L4ItemIDCheck", "Y");
																					} else if(StringUtil.checkNull(levelsArr[4]).equals("5")) {
																						subData.put("L5ItemIDCheck", "Y");
																					}
																																
																					subResult5 = commonService.selectList("item_SQL.getItemStrHier", subData); // 5.class filter
																				
																				} else { // 본인을 상위 level item 으로 갖고 있는 strItemID 찾기 
																				
																					if(StringUtil.checkNull(levelsArr[3]).equals("1")) {
																						subData.put("L1ItemID", StringUtil.checkNull(itemInfo4.get("ItemID")));
																					} else if(StringUtil.checkNull(levelsArr[3]).equals("2")) {
																						subData.put("L2ItemID", StringUtil.checkNull(itemInfo4.get("ItemID")));
																					} else if(StringUtil.checkNull(levelsArr[3]).equals("3")) {
																						subData.put("L3ItemID", StringUtil.checkNull(itemInfo4.get("ItemID")));
																					} else if(StringUtil.checkNull(levelsArr[3]).equals("4")) {
																						subData.put("L4ItemID", StringUtil.checkNull(itemInfo4.get("ItemID")));
																					} else if(StringUtil.checkNull(levelsArr[3]).equals("5")) {
																						subData.put("L5ItemID", StringUtil.checkNull(itemInfo4.get("ItemID")));
																					}
																					
																					subData.put("itemClassCode", StringUtil.checkNull(classCodesArr[4]));
																					subResult5 = commonService.selectList("item_SQL.getItemStrHier", subData); // 5.class filter
																				}
																				
																				if(subResult5.size() > 0 ) {
																					for(int u=0; subResult5.size() > u; u++) {
																						Map subMap5 = (Map)subResult5.get(u);
																						setData = new HashMap();
																						if(Integer.parseInt(levelsArr[4]) > Integer.parseInt(levelsArr[3])) {
																							setData.put("s_itemID", StringUtil.checkNull(subMap5.get("StrItemID")));
																						}else {
																							if(StringUtil.checkNull(levelsArr[4]).equals("1")) {
																								setData.put("s_itemID", StringUtil.checkNull(subMap5.get("L1ItemID")));
																							} else if(StringUtil.checkNull(levelsArr[4]).equals("2")) {
																								setData.put("s_itemID", StringUtil.checkNull(subMap5.get("L2ItemID")));
																							} else if(StringUtil.checkNull(levelsArr[4]).equals("3")) {
																								setData.put("s_itemID", StringUtil.checkNull(subMap5.get("L3ItemID")));
																							} else if(StringUtil.checkNull(levelsArr[4]).equals("4")) {
																								setData.put("s_itemID", StringUtil.checkNull(subMap5.get("L4ItemID")));
																							} else if(StringUtil.checkNull(levelsArr[4]).equals("5")) {
																								setData.put("s_itemID", StringUtil.checkNull(subMap5.get("L5ItemID")));
																							}
																						}
																						Map itemInfo5 = (Map)commonService.select("project_SQL.getItemInfo", setData);
																						
																						
																						setData.put("udfSTR", "Y");
																						String newItemID5 = commonService.selectString("item_SQL.getItemMaxID", setData);
																						
																						setData.put("newItemID", newItemID5);
																						setData.put("s_itemID", StringUtil.checkNull(itemInfo4.get("ToItemID"))); // fromItemID
																						setData.put("strItemID", newItemID4); // ParentID 
																						setData.put("toItemID", StringUtil.checkNull(itemInfo5.get("ToItemID")));
																						setData.put("structureID", rootStrItemID); 
																						
																						setData.put("cxnItemType", "ST00016");
																						setData.put("strLevel", StringUtil.checkNull(itemInfo5.get("Level")));
																						setData.put("cxnClassCode", StringUtil.checkNull(itemInfo5.get("ClassCode")));
																						setData.put("categoryCode", "ST3");
																						setData.put("strType", "2");
																						setData.put("refCItemID",  StringUtil.checkNull(itemInfo5.get("ItemID")));
																						setData.put("sessionUserId", StringUtil.checkNull(cmmMap.get("sessionUserId")));
																						setData.put("sessionTeamId", StringUtil.checkNull(cmmMap.get("sessionTeamId")));
																						
																						setData.put("classNames", classNames);
																						setData.put("languageID",  StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
																						setData.put("projectID", StringUtil.checkNull(itemInfo5.get("ProjectID")));
																						
																						CxnItemService.save(setData); // Create5. class filter
																						setData.put("pNewItemID",newItemID5);
																						createUdfStrSubMgt(setData); // Create L6
																					}
																				}
																			}
																			///// Create 5 class filter End /////////////////////////////////////////////////////////////////////////
																		}
																	}
																}
																/// create 4 class filter end //////////////////////////////////////////////////////////////////////////////////////////////////
															}
														}
													}
													// 3 class filter end
													
												}
											}
										}
										
									}// 0.1 Create root,0 leve end
								}
							}
						} // 1.class filter end
					}
					
				}
			}
			
			// 모델 생성
			cmmMap.put("categoryCode","ST3");
			cmmMap.put("udfClassSort",classNames);// classNames -- > StrItemNM 변경예정
			cmmMap.put("languageID",  StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
		
			
			cmmMap.put("SelectMenuId", "BEDP004");
			cmmMap.put("udfStructureIDs", rootStrItemID); 
			cmmMap.remove("defaultClassCodes");
			// result = commonService.selectList("menu_SQL." + SQL_CODE, cmmMap);
			cmmMap.put("classCode", classCodesArr[0]);
			cmmMap.put("structureID", rootStrItemID); 
			result = commonService.selectList("item_SQL.getStrItemIDList", cmmMap);
			
			if(result.size()>0) {
				setData.put("LanguageID", cmmMap.get("sessionCurrLangType"));
				setData.put("UserId", cmmMap.get("sessionUserId")); 
				setData.put("FontFamily", cmmMap.get("sessionDefFont")); 
				setData.put("FontStyle", cmmMap.get("sessionDefFontStyle")); 
				setData.put("FontSize", cmmMap.get("sessionDefFontSize")); 
				setData.put("FontColor", cmmMap.get("sessionDefFontColor")); 
				setData.put("GUBUN", "insertBaseModel");
				setData.put("dbFuncCode", "CREATE_BEDP");
				for(int i=0; result.size() > i; i++) {
					Map resultMap = (Map)result.get(i);
					// CREATE BEDP Model
				    setData.put("ItemID", StringUtil.checkNull(resultMap.get("ItemID")));
				    commonService.insert("model_SQL.createBaseModel", setData);
				}
			}
			
			cmmMap.put("categoryCode", "ST3");
			List getUdfStrClassSortList = commonService.selectList("item_SQL.getUdfStrClassSort", cmmMap);
			model.put("udfStrClassSortNameCNT", getUdfStrClassSortList.size());
			String defaultUdfClassSortCode = "";
			String defaultUdfClassSortName = "";
			if(getUdfStrClassSortList.size()>0) {
				Map udfClassSortInfo = (Map)getUdfStrClassSortList.get(0);
				defaultUdfClassSortCode =  StringUtil.checkNull(udfClassSortInfo.get("CODE"));
				defaultUdfClassSortName =  StringUtil.checkNull(udfClassSortInfo.get("NAME"));
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "this.fnCallback('"+getUdfStrClassSortList.size()+"','"+defaultUdfClassSortCode+"','"+defaultUdfClassSortName+"');this.$('#isSubmit').remove();");
				 	
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	private void createUdfStrSubMgt (Map strSubMgtMap) throws Exception{
		
		try {
				String refCItemID = StringUtil.checkNull(strSubMgtMap.get("refCItemID")); 
				String structureID = StringUtil.checkNull(strSubMgtMap.get("structureID")); 
				
				Map setData = new HashMap();
				setData.put("parentID", refCItemID);
				setData.put("classCode", "STL1606");
				List docList = commonService.selectList("item_SQL.getChildFromParentID", setData);
				setData.put("udfSTR", "Y");
				if(docList.size() > 0) {
					for(int i=0; i<docList.size();i++) {
						Map docInfo = (Map)docList.get(i);
												
						setData.put("newItemID", commonService.selectString("item_SQL.getItemMaxID", setData));
						setData.put("s_itemID", StringUtil.checkNull(docInfo.get("FromItemID"))); // fromItemID
						setData.put("strItemID", StringUtil.checkNull(strSubMgtMap.get("pNewItemID"))); // ParentID 
						setData.put("toItemID", StringUtil.checkNull(docInfo.get("ToItemID")));
						setData.put("structureID", structureID); 
						
						setData.put("cxnItemType", "ST00016");
						setData.put("strLevel", StringUtil.checkNull(docInfo.get("Level")));
						setData.put("cxnClassCode", StringUtil.checkNull(docInfo.get("ClassCode")));
						setData.put("categoryCode", "ST3");
						setData.put("strType", "2");
						setData.put("refCItemID",  StringUtil.checkNull(docInfo.get("ItemID")));
						setData.put("sessionUserId", StringUtil.checkNull(strSubMgtMap.get("sessionUserId")));
						setData.put("sessionTeamId", StringUtil.checkNull(strSubMgtMap.get("sessionTeamId")));
						setData.put("projectID",  StringUtil.checkNull(strSubMgtMap.get("projectID")));
						CxnItemService.save(setData);
					}
				}
			
		} catch(Exception e) {
			 System.out.println(e.toString());
		}
		
	}
	 
	@RequestMapping(value = "/deleteUdfStrClassSort.do")
	public String deleteUdfStrClassSort(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();
		try {
				cmmMap.put("itemIDs", StringUtil.checkNull(cmmMap.get("udfStructureIDs")));
				commonService.delete("item_SQL.deleteUdfStr", cmmMap);
				
				cmmMap.put("categoryCode", "ST3");
				List getUdfStrClassSortList = commonService.selectList("item_SQL.getUdfStrClassSort", cmmMap);
				model.put("udfStrClassSortNameCNT", getUdfStrClassSortList.size());
				
				String defaultUdfClassSortCode = "";
				String defaultUdfClassSortName = "";
				if(getUdfStrClassSortList.size()>0) {
					Map udfClassSortInfo = (Map)getUdfStrClassSortList.get(0);
					defaultUdfClassSortCode =  StringUtil.checkNull(udfClassSortInfo.get("CODE"));
					defaultUdfClassSortName =  StringUtil.checkNull(udfClassSortInfo.get("NAME"));
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069"));
				target.put(AJAX_SCRIPT, "this.fnCallback('"+getUdfStrClassSortList.size()+"','"+defaultUdfClassSortCode+"','"+defaultUdfClassSortName+"');this.$('#isSubmit').remove();");
	 	
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/getMakeUdfStrClassSort.do")
	public void getMakeUdfStrClassSort(HttpServletRequest request,  HttpServletResponse res) throws Exception{
		try {
			res.setHeader("Cache-Control", "no-cache");
			res.setContentType("text/plain");
			res.setCharacterEncoding("UTF-8");
			String udfStrClassSortName = StringUtil.checkNull(request.getParameter("udfStrClassSortName"));
			
			String sorting = "ORDER BY CASE T.NAME ";
			int idx = 1;
		
			String codeSp[] = udfStrClassSortName.split(">");
			for(int i=0; codeSp.length >i; i++) {
				sorting += " WHEN '"+ codeSp[i] + "' THEN "+idx;
				idx++;
			}
			sorting += " ELSE 6 END";
			
			if(udfStrClassSortName.equals("")) {
				sorting = "";
			}
			
			res.getWriter().print(sorting);
			
		} catch (IOException e) {
			MessageHandler.getMessage("json.send.message");
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/getNodeStrID.do")
	public String getNodeStrID(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();
		try {	
				String stuctureID = StringUtil.checkNull(cmmMap.get("structureID"));
				cmmMap.put("categoryCode", "ST3");
				cmmMap.put("fromItemID", "216");
				String nodeStrID  = commonService.selectString("item_SQL.getNodeStrID", cmmMap);
				
				target.put(AJAX_SCRIPT, "this.fnGoUdfStr('"+stuctureID+"','"+nodeStrID+"');this.$('#isSubmit').remove();");
	 	
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/checkMyItem.do")
	public void checkMyItem(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map setMap = new HashMap();
		
        res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
	    try {
	    	setMap.put("itemID", StringUtil.checkNull(request.getParameter("itemID"),""));
	    	setMap.put("userID", StringUtil.checkNull(request.getParameter("userID"),""));
			String memberID = commonService.selectString("item_SQL.getMyItemMemberID", setMap);
			
			jsonObject.put("memberID", memberID);
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        jsonObject.put("message", MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
	        res.getWriter().print(jsonObject);
	    }
	}
}
