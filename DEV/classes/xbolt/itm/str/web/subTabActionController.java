package xbolt.itm.str.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
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
import java.io.Serializable;

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
import xbolt.cmm.framework.util.GetItemAttrList;
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

@Controller
@SuppressWarnings("unchecked")

public class subTabActionController  extends XboltController{
	
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;
	
	@RequestMapping(value = "/viewItemTabInfo.do")
	public String viewItemTabInfo(HttpServletRequest request, ModelMap model, HashMap cmmMap) throws Exception {
		String url = "/itm/itemInfo/viewItemTabInfo";
		try {
			String arcCode = StringUtil.checkNull(cmmMap.get("arcCode"), "");
			String s_itemID = StringUtil.checkNull(cmmMap.get("itemID"), StringUtil.checkNull(cmmMap.get("s_itemID"), ""));
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
			model.put("option", arcCode);
			model.put("level", (String) cmmMap.get("level"));

			setMap.put("ArcCode", arcCode);
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
//			if (!empPhotoItemDisPlay.equals("N")) {
				roleAssignMemberList = commonService.selectList("item_SQL.getAssignmentMemberList", setMap);
//			}

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
			model.put("showAttr", StringUtil.checkNull(cmmMap.get("showAttr"), ""));
			
			model.put("menu", getLabel(request, commonService));

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/viewVerticalItemTab.do")
	public String viewVerticalItemTab(HttpServletRequest request, ModelMap model, HashMap cmmMap) throws Exception {
		String url = "/itm/itemInfo/viewVerticalItemTab";
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
//			if (!empPhotoItemDisPlay.equals("N")) {
				roleAssignMemberList = commonService.selectList("item_SQL.getAssignmentMemberList", setMap);
//			}

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
	
	
	@RequestMapping(value = "/viewItemAttr.do")
	public String viewItemAttr(HttpServletRequest request, HashMap cmmMap,  HashMap commandMap,   ModelMap model) throws Exception {
		String url = "/itm/itemInfo/viewItemAttr";
		try {
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			if(myItem.equals("Y")) url = "/itm/itemInfo/editItemAttr";
			
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
			model.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/elmSidePanel.do")
	public String elmInfoTabMenu(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/mdl/element/elmSidePanel";
	
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
	
}