package xbolt.itm.inf.web;

import com.org.json.JSONArray;
import com.org.json.JSONObject;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.*;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

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
public class NewItemInfoActionController extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "itemInfoService")
	private CommonService itemInfoService;

	private final Log _log = LogFactory.getLog(this.getClass());

	@RequestMapping(value = "/NewItemInfoMain.do")
	public String NewItemInfoMain(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		Map target = new HashMap();
		String url = "";

		try {
			String showVersion = StringUtil.checkNull(commandMap.get("varFilter"));

			Map setMap = new HashMap();
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));

			// Structure item Tree 시 //
			String mstItemID = StringUtil.checkNull(request.getParameter("mstItemID"));
			if (!mstItemID.equals("") && mstItemID != null) {
				s_itemID = mstItemID;
			}

			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("s_itemID", s_itemID);
			setMap.put("itemId", s_itemID);

			String itemFileOption = commonService.selectString("fileMgt_SQL.getFileOption", setMap);
			setMap.remove("itemId");

			model.put("itemFileOption", itemFileOption);

			// List subModelList = new ArrayList();

			List relItemRowList = new ArrayList();
			String strClassName = "";

			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			setMap.put("itemID", s_itemID);
			setMap.put("status", "CLS");

			String itemReleaseVersion = commonService.selectString("cs_SQL.getItemReleaseVersion", setMap);
			String itemValidFrom = commonService.selectString("cs_SQL.getItemValidFrom", setMap);
			setMap.remove("status");
			setMap.remove("itemID");
			model.put("itemReleaseVersion", itemReleaseVersion);
			model.put("itemValidFrom", itemValidFrom);

			/* 기본정보 내용 취득 */
			List prcList = commonService.selectList("report_SQL.getItemInfo", setMap);

			/* 기본정보의 속성 내용을 취득 */
			List returnData = new ArrayList();
			// isComLang = ALL
			setMap.put("defaultLang", defaultLang);
			setMap.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
			returnData = (List) commonService.selectList("attr_SQL.getItemAttrMain", setMap);
			/* attrTypeCode 두번째 컬럼 준재여부 */
			String columnNum2YN = "N";
			if (returnData.size() > 0) {
				for (int i = 0; returnData.size() > i; i++) {
					Map attrListMap = (Map) returnData.get(i);
					if (!StringUtil.checkNull(attrListMap.get("AttrTypeCode2")).equals("")
							&& StringUtil.checkNull(attrListMap.get("ColumnNum2")).equals("2")) {
						columnNum2YN = "Y";
					}
				}
			}

			model.put("columnNum2YN", columnNum2YN);

			/* AT00037 --> LV37002, LV37003 RunLFWeb */

			List attrList = new ArrayList();
			Map attrMap = new HashMap();

			attrMap.put("languageID", request.getParameter("languageID"));
			attrMap.put("defaultLang", defaultLang);

			attrMap.put("s_itemID", s_itemID);
			attrMap.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
			attrList = commonService.selectList("attr_SQL.getItemAttr", attrMap);

			// get ITEM ATTR (각 속성에 따른 언어 설정(IsComLang)에 따른 data 취득)
			returnData = GetItemAttrList.getItemAttrList2(commonService, returnData, setMap,
					request.getParameter("languageID"));
			if (!("").equals(StringUtil.checkNull(commandMap.get("sessionParamSubItems")))) {
				setMap.put("sessionParamSubItems", commandMap.get("sessionParamSubItems").toString());
			}

			Map prcMap = (Map) prcList.get(0);

//			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
//			String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));
//			
//			if (StringUtil.checkNull(prcMap.get("AuthorID")).equals(sessionUserId) 
//					|| StringUtil.checkNull(prcMap.get("LockOwner")).equals(sessionUserId)
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}

			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);

			if (!("").equals(StringUtil.checkNull(commandMap.get("sessionParamSubItems")))) {
				setMap.remove("sessionParamSubItems");
			}

			setMap.put("languageID", request.getParameter("languageID"));
			// List relItemList =
			// commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
			// List relItemList = new ArrayList();getRelItemClassList
			// List relItemClassList =
			// commonService.selectList("item_SQL.getRelItemClassList", setMap);
			// model.put("relItemList", relItemList);
			// model.put("relItemClassList", relItemClassList);
			setMap.put("parentID", s_itemID);

			/** 관련항목 취득 */

			setMap.remove("attrTypeCode");
			/*
			 * for (int i = 0; i < relItemList.size(); i++) { Map pertinentMap = (Map)
			 * relItemList.get(i); String itemId = pertinentMap.get("s_itemID").toString();
			 * setMap.put("s_itemID", itemId); setMap.put("s_itemID", itemId);
			 * 
			 * if (null != pertinentMap.get("ClassName")) { if (className.isEmpty()) {
			 * className = pertinentMap.get("ClassName").toString(); strClassName =
			 * className;
			 * pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap)); } else
			 * { if (className.equals(pertinentMap.get("ClassName").toString())) {
			 * pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap)); } else
			 * { relItemRowList.add(pertinentDetailList);
			 * 
			 * className = pertinentMap.get("ClassName").toString(); classNameCnt++;
			 * strClassName = strClassName + "," + className;
			 * 
			 * pertinentDetailList = new ArrayList();
			 * pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap)); } } }
			 * 
			 * if (i == (relItemList.size()- 1)) { relItemRowList.add(pertinentDetailList);
			 * }
			 * 
			 * }
			 */
			setMap.put("s_itemID", s_itemID);

			/** Dimension정보 취득 */
			List dimInfoList = commonService.selectList("dim_SQL.selectDim_gridList", setMap);
			List dimResultList = new ArrayList();
			Map dimResultMap = new HashMap();
			String dimTypeName = "";
			String dimValueNames = "";
			for (int i = 0; i < dimInfoList.size(); i++) {
				Map map = (HashMap) dimInfoList.get(i);

				if (i > 0) {
					if (dimTypeName.equals(map.get("DimTypeName").toString())) {
						dimValueNames += " / " + map.get("DimValuePath").toString();
					} else {
						dimResultMap.put("dimValueNames", dimValueNames);
						dimResultList.add(dimResultMap);
						dimResultMap = new HashMap(); // 초기화
						dimTypeName = map.get("DimTypeName").toString();
						dimResultMap.put("dimTypeName", dimTypeName);
						dimValueNames = map.get("DimValuePath").toString();
					}
				} else {
					dimTypeName = map.get("DimTypeName").toString();
					dimResultMap.put("dimTypeName", dimTypeName);
					dimValueNames = map.get("DimValuePath").toString();
				}
			}

			if (dimInfoList.size() > 0) {
				dimResultMap.put("dimValueNames", dimValueNames);
				dimResultList.add(dimResultMap);
			}

			/** 첨부문서 취득 */
			commandMap.put("DocumentID", s_itemID);
			commandMap.put("s_itemID", s_itemID);
			commandMap.put("languageID", request.getParameter("languageID"));
			commandMap.put("isPublic", "N");
			commandMap.put("DocCategory", "ITM");
			// commandMap.put("hideBlocked", "Y");
			commandMap.remove("changeSetID");

			// List attachFileList =
			// commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);
			String cxnItemListYN = StringUtil.checkNull(request.getParameter("cxnItemListYN"));
			String rltdItemId = "";
			if (!cxnItemListYN.equals("N")) { /** 관련문서 취득 */
				commandMap.put("fromToItemID", s_itemID);
				List itemList = commonService.selectList("item_SQL.getCxnItemIDList", commandMap);
				Map getMap = new HashMap();
				/** 첨부문서 관련문서 합치기, 관련문서 itemClassCodep 할당된 fltpCode 로 filtering */

				for (int i = 0; i < itemList.size(); i++) {
					setMap = (HashMap) itemList.get(i);
					getMap.put("ItemID", setMap.get("ItemID"));
					if (i < itemList.size() - 1) {
						rltdItemId += StringUtil.checkNull(setMap.get("ItemID")) + ",";
					} else {
						rltdItemId += StringUtil.checkNull(setMap.get("ItemID"));
					}
				}

				commandMap.put("rltdItemId", rltdItemId);
			}

			List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);

			commandMap.remove("hideBlocked");
			List fileListNoFilter = commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);
			model.put(rltdItemId, dimValueNames);

			/* 의견공유, 변경이력, 첨부문서 화면의 표시 여부를 취득 */
			Map setValue = new HashMap();
			setValue.put("s_itemID", s_itemID);
			setValue.put("languageID", request.getParameter("languageID"));
			Map menuDisplayMap = commonService.select("item_SQL.getMenuIconDisplay", setValue);

			/* edit 가능 한 Item 인지 Item Status를 취득해서 판단 */
			String itemStatus = commonService.selectString("project_SQL.getItemStatus", setValue);
			String itemBlocked = commonService.selectString("project_SQL.getItemBlocked", setValue);

			model.put("itemStatus", itemStatus); // 아이템 Status

			if (!"0".equals(itemBlocked)) {
				model.put("isPossibleEdit", "N");
			} else {
				model.put("isPossibleEdit", "Y");
			}

			/* 모델관리 화면의 표시 여부를 취득 */
			setValue.put("s_itemID", s_itemID);
			setValue.put("languageID", request.getParameter("languageID"));
			List elementModelList = commonService.selectList("model_SQL.getItemMdlOccList_gridList", setValue);

			if (elementModelList.size() > 0) {
				model.put("isExistModel", "Y"); // 모델정보
			} else {
				model.put("isExistModel", "N"); // 모델정보
			}
			model.put("MDL_CNT", elementModelList.size()); // 모델정보

			/* 담당자 정보 취득 */
			setValue.put("MemberID", prcMap.get("AuthorID"));
//			Map authorInfoMap = commonService.select("item_SQL.getAuthorInfo", setValue);

			String dataType = "";
			String dataType2 = "";

			String plainText = "";
			for (int i = 0; i < returnData.size(); i++) {
				Map attrTypeMap = (HashMap) returnData.get(i);
				dataType = StringUtil.checkNull(attrTypeMap.get("DataType"));
				dataType2 = StringUtil.checkNull(attrTypeMap.get("DataType2"));
				if (dataType.equals("MLOV")) {
					plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionCurrLangType")), s_itemID,
							StringUtil.checkNull(attrTypeMap.get("AttrTypeCode")));
					attrTypeMap.put("PlainText", plainText);
				}

				if (dataType2.equals("MLOV")) {
					plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionCurrLangType")), s_itemID,
							StringUtil.checkNull(attrTypeMap.get("AttrTypeCode2")));
					attrTypeMap.put("PlainText2", plainText);
				}
			}

			Map setParam = new HashMap();
			setParam.put("refItemID", s_itemID);
			setParam.put("languageID", commandMap.get("sessionCurrLangType"));
			// List varItemList = commonService.selectList("item_SQL.getRefItemInfoList",
			// setParam);

			setParam = new HashMap();
			setParam.put("mstItemID", s_itemID);
			setParam.put("languageID", commandMap.get("sessionCurrLangType"));
			Map mstItemMap = commonService.select("item_SQL.getRefItemInfoList", setParam);

			// model.put("varItemList", varItemList);
			model.put("mstItemMap", mstItemMap);
			model.put("showVersion", showVersion);
			model.put("menu", getLabel(request, commonService));
			model.put("strClassName", strClassName);
			model.put("prcList", prcList); // 기본정보
			model.put("attributesList", returnData); // 속성
			model.put("authorID", prcMap.get("AuthorID")); // 담당자 정보
			// model.put("subModelList", subModelList);
			model.put("relItemRowList", relItemRowList); // 관련항목
			model.put("s_itemID", s_itemID);
			model.put("option", StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("option"))));
			model.put("setMap", setMap);
			model.put("screenMode", StringUtil.checkNull(request.getParameter("screenMode"), ""));
			model.put("menuDisplayMap", menuDisplayMap);
			model.put("FILE_CNT", fileListNoFilter.size());
			model.put("attachFileList", attachFileList);
			// model.put("pertinentFileList", pertinentFileList);

			model.put("dimResultList", dimResultList);
			Map setDataID = new HashMap();
			setDataID.put("itemID", s_itemID);
			String parentItemID = StringUtil
					.checkNull(commonService.selectString("item_SQL.getParentItemID", setDataID));
			model.put("parentItemID", parentItemID);

			if (StringUtil.checkNull(request.getParameter("kbn")).isEmpty()) {
				url = "/itm/itemInfo/NewItemInfoMain";
			} else {
				url = "/itm/itemInfo/NewItemInfoMainForPrint";
			}

			// Previous(ChangeSet)
			setDataID.put("rNum", 2); // ChangeSetID = 최신 ChangeSet의 직전 ChangeSet
			setDataID.put("parentItemID", parentItemID);
			setDataID.put("s_itemID", s_itemID);
			setMap.put("ItemID", s_itemID);
			String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));
			setDataID.put("changeMgt", changeMgt);

			/*
			 * String preChangeSetID = StringUtil.checkNull(commonService.selectString(
			 * "cs_SQL.getNextPreChangeSetID", setDataID)); String itemAttrRevCNT =
			 * StringUtil.checkNull(commonService.selectString("item_SQL.getItemAttrRevCNT",
			 * setDataID));
			 * 
			 * if(!preChangeSetID.equals("")){ setDataID.put("ChangeSetID", preChangeSetID);
			 * model.put("preChangeSetID", preChangeSetID); Map preChangeSetInfo =
			 * commonService.select("cs_SQL.getChangeSetData", setDataID);
			 * model.put("preChangeSetInfo", preChangeSetInfo);
			 * model.put("itemAttrRevCNT",itemAttrRevCNT);
			 * 
			 * }
			 */

			setMap = new HashMap();
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));

			setMap.put("itemID", s_itemID);
			setMap.put("assignmentType", "CNGROLETP");
			setMap.put("languageID", languageID);
			List roleAssignMemberList = commonService.selectList("item_SQL.getAssignmentMemberList", setMap);

			model.put("roleAssignMemberList", roleAssignMemberList);
			model.put("baseAtchUrl", GlobalVal.BASE_ATCH_URL);

			// QuickCheckOut 설정
			String quickCheckOut = "N";

			// String attributeBtn = "";
			List projectNameList = new ArrayList();
			String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));

			setMap = new HashMap();
			setMap.put("userId", sessionUserID);
			setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", s_itemID);
			setMap.put("ProjectType", "CSR");
			setMap.put("isMainItem", "Y");
			projectNameList = commonService.selectList("project_SQL.getProjectNameList", setMap);

			setMap.put("DocCategory", "CS");
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			String wfURL = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", setMap));
			String curChangeSet = StringUtil.checkNull(prcMap.get("CurChangeSet"));
			setMap.put("changeSetID", curChangeSet);
			String checkInOptionCS = StringUtil
					.checkNull(commonService.selectString("cs_SQL.getCheckInOptionCS", setMap));

			model.put("checkInOption", checkInOptionCS);
			model.put("projectNameList", projectNameList.size());
			model.put("wfURL", wfURL);
			model.put("quickCheckOut", quickCheckOut);
			model.put("itemBlocked", itemBlocked);
			model.put("changeMgt", changeMgt);
			model.put("curChangeSet", StringUtil.checkNull(prcMap.get("CurChangeSet")));
			model.put("releaseNo", StringUtil.checkNull(prcMap.get("ReleaseNo")));
			model.put("itemInfo", prcMap);

			String releaseNo = StringUtil.checkNull(prcMap.get("ReleaseNo"));
			setDataID.put("changeSetID", curChangeSet);
			String preChangeSetID = "";
			if (!curChangeSet.equals("") && curChangeSet != null) {
				preChangeSetID = StringUtil
						.checkNull(commonService.selectString("cs_SQL.getPreChangeSetID", setDataID));
			}

			if (!releaseNo.equals("0") && !releaseNo.equals("1") && !preChangeSetID.equals("")) {
				setDataID.put("ChangeSetID", preChangeSetID);
				model.put("preChangeSetID", preChangeSetID);
				Map preChangeSetInfo = commonService.select("cs_SQL.getChangeSetData", setDataID);
				model.put("preChangeSetInfo", preChangeSetInfo);
			}

			// revision list count
			setMap.put("documentID", s_itemID);
			model.put("REV_CNT", commonService.selectString("revision_SQL.getRevisionCOUNT", setMap));
			model.put("subscrOption",
					StringUtil.checkNull(commonService.selectString("item_SQL.getSubscrOption", setMap)));

			setMap = new HashMap();
			setMap.put("itemID", s_itemID);
			// setMap.put("assignmentType", "SUBSCR");
			setMap.put("memberID", sessionUserID);
			model.put("myItemCNT", StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCNT", setMap)));
			model.put("myItemSeq", StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemSeq", setMap)));
			model.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
			model.put("langFilter", StringUtil.checkNull(request.getParameter("langFilter")));
			model.put("loadEdit", StringUtil.checkNull(request.getParameter("loadEdit")));
			model.put("papagoTrans", StringUtil.checkNull(request.getParameter("papagoTrans")));
			model.put("gptAITrans", StringUtil.checkNull(request.getParameter("gptAITrans")));

		} catch (Exception e) {
			System.out.println(e.toString()); // @@
		}

		return nextUrl(url);
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
			mLovList = commonService.selectList("attr_SQL.getMLovList", setMap);
			if (mLovList.size() > 0) {
				for (int j = 0; j < mLovList.size(); j++) {
					Map mLovListMap = (HashMap) mLovList.get(j);
					if (j == 0) {
						plainText = StringUtil.checkNull(mLovListMap.get("Value"));
					} else {
						plainText = plainText + " / " + mLovListMap.get("Value");
					}
				}
			}
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		return plainText;
	}

	@RequestMapping(value = "/saveObjectInfo.do")
	public String saveObjectInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			String setInfo = "";
			String itemId = request.getParameter("s_itemID");
			String identifier = StringUtil.checkNull(request.getParameter("Identifier"));

			Map setValue = new HashMap();
			setValue.put("ItemID", itemId);
			setValue.put("Identifier", identifier);

			/* Identifier unique check */
			String itemCount = "0";

			if (!identifier.isEmpty()) {
				itemCount = commonService.selectString("attr_SQL.identifierEqualCount", setValue);
			}

			// 동일 ID 중복 시 팝업 창에 중복된 Item의 "항목계층명/경로/명칭"을 출력해 줌
			if (!itemCount.equals("0")) {
				setValue.put("languageID", request.getParameter("languageID"));
				// target.put(AJAX_ALERT, "동일한 ID가
				// "+commonService.selectString("attr_SQL.getEqualIdentifierInfo", setValue)+"에
				// 존재 합니다. ");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00081",
						new String[] { commonService.selectString("attr_SQL.getEqualIdentifierInfo", setValue) }));
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			} else {

				/* 기본정보 update */
				setValue.put("languageID", request.getParameter("languageID"));
				setValue.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
				setValue.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
				String AT00001YN = StringUtil.checkNull(request.getParameter("AT00001YN"));
				// 명칭
				if (!request.getParameter("AT00001").isEmpty() && !AT00001YN.equals("N")) {
					setValue.put("AttrTypeCode", "AT00001");
					setValue.put("PlainText", request.getParameter("AT00001"));
					setInfo = GetItemAttrList.attrUpdate(commonService, setValue);
				}
				// 명칭 이외
				setValue.put("Identifier", identifier);
				setValue.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
				setValue.put("CompanyID", StringUtil.checkNull(request.getParameter("companyCode")));
				setValue.put("OwnerTeamID", StringUtil.checkNull(request.getParameter("ownerTeamCode")));
				setValue.put("Version", StringUtil.checkNull(request.getParameter("Version")));
				setValue.put("AuthorID", StringUtil.checkNull(request.getParameter("AuthorID")));
				setValue.put("LastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));

				commonService.update("item_SQL.updateItemObjectInfo", setValue);

				/* Item_Attr update */
				List returnData = new ArrayList();
				// Editable 이, 1인 속성만 update 처리를 한다
				commandMap.put("Editable", "1");
				returnData = (List) commonService.selectList("attr_SQL.getItemAttr", commandMap);

				// itemInfoService.save(returnData, commandMap);
				Map setMap = new HashMap();
				String dataType = "";
				String mLovValue = "";
				String html = "";
				for (int i = 0; i < returnData.size(); i++) {
					setMap = (HashMap) returnData.get(i);
					dataType = StringUtil.checkNull(setMap.get("DataType"));
					html = StringUtil.checkNull(setMap.get("HTML"));
					if (!dataType.equals("Text")) {
						if (dataType.equals("MLOV")) {
							String reqMLovValue[] = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")))
									.split(",");
							Map delData = new HashMap();
							delData.put("ItemID", itemId);
							delData.put("AttrTypeCode", setMap.get("AttrTypeCode"));
							commonService.delete("attr_SQL.delItemAttr", delData);
							for (int j = 0; j < reqMLovValue.length; j++) {
								mLovValue = reqMLovValue[j].toString();
								setMap.put("PlainText", mLovValue);
								setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
								setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
								setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
								setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
								setMap.put("LovCode", mLovValue);
								setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
							}
						} else {
							setMap.put("PlainText",
									StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()), ""));
							setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
							setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
							setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
							setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
							if(!"Time".equals(dataType)) {
								setMap.put("LovCode",
										StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()), ""));
							}
							setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
						}
					} else {
						String plainText = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")), "");
						if (html.equals("1")) {
							plainText = StringEscapeUtils.escapeHtml4(plainText);
						}
						setMap.put("PlainText", plainText);
						setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
						setMap.put("languageID", request.getParameter("languageID"));
						setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
						setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
						setMap.put("LovCode", StringUtil
								.checkNull(commonService.selectString("attr_SQL.selectAttrLovCode", setMap), ""));
						setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
					}
				}

				String ZAT4015 = StringUtil.checkNull(request.getParameter("ZAT4015_ID"));
				String ZAT4015_Name = StringUtil.checkNull(request.getParameter("ZAT4015"));
				String ZAT4015_ORG = StringUtil.checkNull(request.getParameter("ZAT4015_ORG"));

				Map setData = new HashMap();
				if (!ZAT4015_Name.equals("") && ZAT4015_Name != null) {
					setData.put("sessionUserId", ZAT4015);
					String mbrTeamID = commonService.selectString("user_SQL.userTeamID", setData);

					setData.put("projectID", StringUtil.checkNull(request.getParameter("projectID")));
					setData.put("itemID", itemId);
					setData.put("assignmentType", "CNGROLETP");
					setData.put("roleType", "R");
					setData.put("orderNum", 1);
					setData.put("assigned", 1);
					setData.put("accessRight", "U");

					String myItemSeq = StringUtil
							.checkNull(commonService.selectString("role_SQL.getMyItemSeq", setData));

					setData.put("memberID", ZAT4015);
					setData.put("mbrTeamID", mbrTeamID);
					setData.put("creator", StringUtil.checkNull(commandMap.get("sessionUserId")));
					if (!myItemSeq.equals("")) {
						setData.put("seq", myItemSeq);
						commonService.update("role_SQL.updateRoleAssignment", setData);
					} else {
						commonService.insert("role_SQL.insertRoleAssignment", setData);
					}
				} else {
					setData.put("itemID", itemId);
					setData.put("assignmentType", "CNGROLETP");
					setData.put("roleType", "R");
					setData.put("orderNum", 1);
					setData.put("memberID", ZAT4015_ORG);
					commonService.delete("role_SQL.deleteRoleAssignment", setData);
				}

				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT,
						"parent.selfClose();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");

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

	@RequestMapping(value = "/saveItemAttr.do")
	public String saveItemAttr(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			List returnData = new ArrayList();
			Map setValue = new HashMap();
			String setInfo = "";

			String identifier = StringUtil.checkNull(request.getParameter("identifier"));

			setValue.put("ItemID", request.getParameter("s_itemID"));
			setValue.put("Identifier", identifier);

			/* Identifier unique check */
			String itemCount = "0";

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

				returnData = (List) commonService.selectList("attr_SQL.getItemAttr", commandMap);

				// itemInfoService.save(returnData, commandMap);
				Map setMap = new HashMap();
				String dataType = "";
				String mLovValue = "";
				String html = "";
				for (int i = 0; i < returnData.size(); i++) {
					setMap = (HashMap) returnData.get(i);
					dataType = StringUtil.checkNull(setMap.get("DataType"));
					html = StringUtil.checkNull(setMap.get("HTML"));

					if (!dataType.equals("Text")) {
						if (dataType.equals("MLOV")) {
							String reqMLovValue[] = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")))
									.split(",");
							Map delData = new HashMap();
							delData.put("ItemID", request.getParameter("s_itemID"));
							delData.put("AttrTypeCode", setMap.get("AttrTypeCode"));
							commonService.delete("attr_SQL.delItemAttr", delData);
							for (int j = 0; j < reqMLovValue.length; j++) {
								mLovValue = reqMLovValue[j].toString();
								setMap.put("PlainText", mLovValue);
								setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
								setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
								setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
								setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
								setMap.put("LovCode", mLovValue);
								setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
							}
						} else {
							Map delData = new HashMap();
							// delData.put("ItemID", request.getParameter("s_itemID"));
							// delData.put("AttrTypeCode", setMap.get("AttrTypeCode"));
							// commonService.delete("attr_SQL.delItemAttr", delData);
							setMap.put("PlainText",
									StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()), ""));
							setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
							setMap.put("languageID", commandMap.get("sessionDefLanguageId"));
							setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
							setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
							setMap.put("LovCode",
									StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()), ""));
							setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
						}
					} else {
						String plainText = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")), "");
						if (html.equals("1")) {
							plainText = StringEscapeUtils.escapeHtml4(plainText);
						}
						setMap.put("PlainText", plainText);
						setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
						setMap.put("languageID", request.getParameter("languageID"));
						setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
						setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
						setMap.put("LovCode", StringUtil
								.checkNull(commonService.selectString("attr_SQL.selectAttrLovCode", setMap), ""));
						setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
					}
				}

				setValue.put("s_itemID", request.getParameter("s_itemID"));
				setValue.put("Identifier", request.getParameter("identifier"));
				setValue.put("LastUser", request.getParameter("UserID"));
				commonService.update("project_SQL.updateItemStatus", setValue);

				// 명칭
				setValue.put("languageID", commandMap.get("sessionCurrLangType"));
				setValue.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
				setValue.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
				if (!request.getParameter("AT00001").isEmpty()) {
					setValue.put("AttrTypeCode", "AT00001");
					setValue.put("PlainText", request.getParameter("AT00001"));
					setInfo = GetItemAttrList.attrUpdate(commonService, setValue);
				}

				// target.put(AJAX_ALERT, "저장이 성공하였습니다.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
																														// 성공
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();parent.actionComplet();");
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

	@RequestMapping(value = "/saveCheckedObjAttr.do")
	public String saveCheckedObjAttr(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		HashMap target = new HashMap();
		HashMap setMap = new HashMap();

		try {
			List returnData = new ArrayList();

			String items = StringUtil.checkNull(request.getParameter("items"));
			String attrCode = StringUtil
					.checkNull(request.getParameter("attrCode").replace("&#39", "'").replace(";", ""));
			String classCodes = StringUtil.checkNull(request.getParameter("classCodes"));

			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("AttrTypeCodes", attrCode);
			setMap.put("ItemClassCode", classCodes);
			returnData = (List) commonService.selectList("attr_SQL.getAttrAllocList", setMap);

			setMap = new HashMap();
			String[] arrayItems = items.split(",");

			for (int i = 0; i < arrayItems.length; i++) {
				String itemId = arrayItems[i]; // 아이템 아이디
				setMap.put("s_itemID", itemId);
				Map itemInfoMap = commonService.select("project_SQL.getItemInfo", setMap);
				for (int j = 0; j < returnData.size(); j++) {
					setMap = (HashMap) returnData.get(j);

					setMap.put("ItemID", itemId);
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));
					setMap.put("ClassCode", itemInfoMap.get("ClassCode"));
					setMap.put("ItemTypeCode", itemInfoMap.get("ItemTypeCode"));
					String html = StringUtil.checkNull(setMap.get("HTML"), "");
					String plainText = StringUtil.checkNull(request.getParameter(setMap.get("AttrTypeCode").toString()),
							"");
					if (html.equals("1")) {
						plainText = StringEscapeUtils.unescapeHtml4(plainText);
					}
					setMap.put("PlainText", plainText);

					String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"), "");
					String dataType = StringUtil.checkNull(setMap.get("DataType"), "");
					if (dataType.equals("MLOV")) {
						String mLovValue = "";
						String reqMLovValue[] = StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode")))
								.split(",");
						Map delData = new HashMap();
						delData.put("ItemID", itemId);
						delData.put("languageID", languageID);
						delData.put("AttrTypeCode", setMap.get("AttrTypeCode"));
						commonService.delete("attr_SQL.delItemAttr", delData);
						for (int k = 0; k < reqMLovValue.length; k++) {
							mLovValue = reqMLovValue[k].toString();
							setMap.put("PlainText", mLovValue);
							setMap.put("LovCode", mLovValue);
							setMap.put("dataType", dataType);
							GetItemAttrList.attrUpdate(commonService, setMap);
						}
					} else {
						setMap.put("LovCode", StringUtil
								.checkNull(commonService.selectString("attr_SQL.selectAttrLovCode", setMap), ""));
						GetItemAttrList.attrUpdate(commonService, setMap);
					}
				}
			}

			// System.out.println("Edit Items Cnt :"+arrayItems.length);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
																													// 성공
			target.put(AJAX_SCRIPT, "parent.actionComplet();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, "저장중 오류가 발생하였습니다.\n\n[msg]"+e.getMessage());
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류
																													// 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	/**
	 * [하위항목] edit ID/Name
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveEditIdName.do")
	public String saveEditIdName(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map setMap = new HashMap();
			Map updateMap = new HashMap();
			List getList = new ArrayList();
			String msg = "";

			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List returnData = new ArrayList();
			setMap.put("option", StringUtil.checkNull(request.getParameter("option")));
			setMap.put("filterType", StringUtil.checkNull(request.getParameter("filterType")));
			setMap.put("TreeDataFiltered", StringUtil.checkNull(request.getParameter("filterType")));
			setMap.put("defDimTypeID", StringUtil.checkNull(request.getParameter("defDimTypeID")));
			setMap.put("defDimValueID", StringUtil.checkNull(request.getParameter("defDimValueID")));
			setMap.put("showTOJ", StringUtil.checkNull(request.getParameter("showTOJ")));
			setMap.put("showElement", StringUtil.checkNull(request.getParameter("showElement")));

			getList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);

			// setMap.put("showBlocked",
			// StringUtil.checkNull(request.getParameter("showBlocked")));
			// getList = commonService.selectList("item_SQL.getChildItemList", setMap);

			/* Identifier unique check */
			/*
			 * for (int i = 0; i < getList.size() ; i++) { Map map = (Map) getList.get(i);
			 * String itemId = StringUtil.checkNull(map.get("ItemID")); String rnum =
			 * StringUtil.checkNull(map.get("RNUM"));
			 * 
			 * setMap.put("ItemID", itemId); setMap.put("Identifier",
			 * request.getParameter("ID_"+itemId)); setMap.put("languageID",
			 * commandMap.get("sessionCurrLangType"));
			 * 
			 * String itemCount =
			 * commonService.selectString("attr_SQL.identifierEqualCount", setMap);
			 * 
			 * if (!itemCount.equals("0")) { msg = msg + "No." + rnum + " : " +
			 * MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00081",
			 * new String[]{commonService.selectString("attr_SQL.getEqualIdentifierInfo",
			 * setMap)}) + "\\n"; } }
			 */

			if (msg.isEmpty()) {
				for (int i = 0; i < getList.size(); i++) {
					Map map = (Map) getList.get(i);
					String itemId = StringUtil.checkNull(map.get("ItemID"));
					updateMap = new HashMap();

					/* 명칭 update */
					updateMap.put("ItemID", itemId);
					updateMap.put("AttrTypeCode", "AT00001");
					updateMap.put("languageID", commandMap.get("sessionCurrLangType"));
					updateMap.put("ClassCode", StringUtil.checkNull(map.get("ClassCode")));
					updateMap.put("ItemTypeCode", StringUtil.checkNull(map.get("ItemTypeCode")));
					updateMap.put("PlainText", request.getParameter("Name_" + itemId));
					updateMap.put("LovCode", "");
					GetItemAttrList.attrUpdate(commonService, updateMap);

					/* Item Identifier update */
					updateMap.put("s_itemID", itemId);

					updateMap.put("Identifier", request.getParameter("ID_" + itemId));
					updateMap.put("LastUser", commandMap.get("sessionUserId"));
					commonService.update("project_SQL.updateItemStatus", updateMap);
				}

				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
																														// 성공
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();parent.selfClose();");
			} else {
				target.put(AJAX_ALERT, msg);
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
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

	@RequestMapping(value = "/saveOwnerInfo.do")
	public String saveOwnerInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setValue = new HashMap();
		String alertType =  StringUtil.checkNull(request.getParameter("alertType"), "");
		try {

			String items = StringUtil.checkNull(request.getParameter("items"));

			String checkAuthor = StringUtil.checkNull(request.getParameter("checkAuthor"));
			String checkOwnerTeam = StringUtil.checkNull(request.getParameter("checkOwnerTeam"));
			String checkCompany = StringUtil.checkNull(request.getParameter("checkCompany"));
			String includeChildItems = StringUtil.checkNull(request.getParameter("includeChildItems"));
			String checkTransfer = StringUtil.checkNull(request.getParameter("checkTransfer"));
			String myTransfer = StringUtil.checkNull(request.getParameter("myTransfer"));
			String mailNotice = StringUtil.checkNull(request.getParameter("mailNotice"));

			setValue.put("languageID", commandMap.get("sessionCurrLangType"));
			setValue.put("LastUser", commandMap.get("sessionUserId"));

			String[] arrayItems = items.split(",");

			// 선택된 아이템과 선택된 아이템의 하위항목을 모두 취득
			List itemList = getItemChildList(arrayItems, includeChildItems);
			for (int i = 0; itemList.size() > i; i++) {
				String itemId = String.valueOf(itemList.get(i));

				setValue.put("ItemID", itemId);

				setValue.put("s_itemID", itemId);
				Map itemInfo = commonService.select("item_SQL.getObjectInfo", setValue);

				
				/* 기본정보 update */
				if ("1".equals(checkCompany)) {
					setValue.put("CompanyID", request.getParameter("companyCode"));
				}
				if ("1".equals(checkOwnerTeam)) {
					setValue.put("OwnerTeamID", request.getParameter("ownerTeamCode"));
				}

				// 담당자의 TeamID와 ComppayID로 Item의 OwnerTeamID와 CompanyID를 업데이트
				if ("1".equals(checkTransfer)) {
					setValue.put("memberID", request.getParameter("AuthorID"));
					setValue.put("userID", request.getParameter("AuthorID"));
					String companyID = StringUtil
							.checkNull(commonService.selectString("user_SQL.getMemberCompanyID", setValue));
					Map ownerTeamID = commonService.select("user_SQL.memberTeamInfo", setValue);
					setValue.put("OwnerTeamID", ownerTeamID.get("TeamID"));
					setValue.put("CompanyID", companyID);
				}

				if ("1".equals(checkAuthor)) {
					setValue.put("AuthorID", request.getParameter("AuthorID"));

					// 해당 ITEM의 ProjectID를 Creator or Member에 선택된 담당자가 존재 하지 않는 경우, Member등록 처리 함

					String projectID = commonService.selectString("project_SQL.getItemProjectId", setValue);
					setValue.put("ProjectID", projectID);
					int projectCreatorCnt = Integer
							.parseInt(commonService.selectString("project_SQL.getProjectCreatorCnt", setValue));
					int projectMemberCnt = Integer
							.parseInt(commonService.selectString("project_SQL.getProjectMemberCnt", setValue));

					if ((projectCreatorCnt + projectMemberCnt == 0)
							&& ("1".equals(commonService.selectString("project_SQL.getChangeMgt", setValue)))) {
						// insert TB_PJT_MEMBER_REL
						setValue.put("MemberID", request.getParameter("AuthorID"));
						commonService.insert("project_SQL.createPjtMemberRel", setValue);
					}

					setValue.put("itemID", itemId);

					if (includeChildItems.equals("1")) { // 담당자가 접속 사용자(MY Item.AccessRight = U인)와 다를 경우
						// MOJ/MCN Item에대한 권한도 변경해줘야 함
						commonService.update("item_SQL.updateItemFromElement", setValue);
					}

				}

				/*
				 * 신규 생성된 ITEM의 ITEM_CLASS.ChangeMgt = 1 일 경우, CHANGE_SET 해당 레코드의 담당자 정보 update
				 */
				if ("1".equals(commonService.selectString("project_SQL.getChangeMgt", setValue))) {
					// update TB_CHANGE_SET
					setValue.remove("ItemID");
					setValue.put("cngItemId", itemId);
					setValue.put("s_itemID", itemId);
					setValue.put("Status", "MOD");
					setValue.put("userId", request.getParameter("AuthorID"));
					Map changeSetMap = (HashMap) commonService.select("cs_SQL.getChangeSetData", setValue);
					if (null != changeSetMap && !changeSetMap.isEmpty()) {
						if (!StringUtil.checkNull(request.getParameter("AuthorID")).isEmpty()) {
							Map userInfoMap = (HashMap) commonService.select("project_SQL.getUserInfo", setValue);
							setValue.put("AuthorName", userInfoMap.get("Name"));

						}
						setValue.remove("s_itemID");
						setValue.put("s_itemID", changeSetMap.get("ChangeSetID"));
						commonService.update("cs_SQL.updateChangeSetForWf", setValue);
					}
				}
				setValue.remove("Status");
				setValue.put("ItemID", itemId);
				commonService.update("item_SQL.updateItemObjectInfo", setValue);

				// Visit Log
				if ("Y".equals(myTransfer)) { // Transfer일 경우 before Author 정보 기록
					String ip = request.getHeader("X-FORWARDED-FOR");
					if (ip == null)
						ip = request.getRemoteAddr();
					setValue.put("IpAddress", ip);
					setValue.put("ItemId", itemId);
					setValue.put("sessionUserId", itemInfo.get("AuthorID"));
					setValue.put("sessionTeamId", itemInfo.get("OwnerTeamID"));
					setValue.put("ActionType", "TRNSF");
					commonService.insert("gloval_SQL.insertVisitLog", setValue);
				}
				
				//메일 보내기 
				if(i==0 && "Y".equals(mailNotice)) {
					Map setMap = new HashMap();
					
					int mailIndex = 0;
					String emailType = StringUtil.checkNull(commandMap.get("emailCode"),"ITMMAIL001");
					Map setMailData = new HashMap();
					List receiverList = new ArrayList();
					
					String projectID = commonService.selectString("project_SQL.getItemProjectId", setValue);
					setValue.put("ProjectID", projectID);
					
					//기존 편집 담당자 
					String beforeAuthorID  = StringUtil.checkNull(itemInfo.get("AuthorID"),"");
					
					String afterAuthorID = request.getParameter("AuthorID"); // 변경하려는 담당자 
					setMap.put("s_itemID",projectID);
					// 프로젝트담당자 
					HashMap pjtMap = (HashMap)commonService.select("project_SQL.getProjectInfoView", setMap);
					
					//프로세스 관리자
					setMap.put("isAll", "N");
					setMap.put("itemID", itemId);
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));
					List<Map<String, Object>> assignedRoleList = commonService.selectList("role_SQL.getAssignedRoleList_gridList", setMap);
			
					Map tempMap1 = new HashMap();	//기존 편집자
					tempMap1.put("receiptUserID", beforeAuthorID);
					receiverList.add(mailIndex++,tempMap1);
					
					Map tempMap2 = new HashMap();	// 변경하려는 담당자 
					tempMap2.put("receiptUserID", afterAuthorID);
					receiverList.add(mailIndex++,tempMap2);
					
					
					Map tempMap3 = new HashMap();
					tempMap3.put("receiptUserID", pjtMap.get("AuthorID"));	//프로젝트 담당자  = ( 시스템 관리자 ) 
					receiverList.add(mailIndex++,tempMap3);
					
					// 프로세스 관리자 넣기 
					for (Map<String, Object> roleMap : assignedRoleList) {
					    Object memberId = roleMap.get("MemberID");   

					    if (memberId != null) {
					    	Map<String, Object> tempMap4 = new HashMap<>();
					        tempMap4.put("receiptUserID", memberId.toString());
					        receiverList.add(mailIndex++, tempMap4);
					    }
					}
					

					
					
					
					setMailData.put("receiverList",receiverList);
					setMailData.put("LanguageID",commandMap.get("sessionCurrLangType"));
					String subject = String.valueOf(itemInfo.get("Identifier")) + " " + String.valueOf(itemInfo.get("ItemName"));
				    setMailData.put("subject", itemInfo.get("Identifier"));
					Map setMailMap = (Map)setEmailLog(request, commonService, setMailData, emailType); //결제 상신 메일 전송
					
					
					if(StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")){
						HashMap mailMap = (HashMap)setMailMap.get("mailLog");	
						HashMap regUInfo = new HashMap();
						HashMap mailInfo = new HashMap();	
						
						mailInfo.put("Subject", subject);
						mailInfo.put("Identifier", itemInfo.get("Identifier"));
						mailInfo.put("ProcName", itemInfo.get("ItemName"));
						mailInfo.put("BeforeTeamNM", itemInfo.get("OwnerTeamName")); //변경전 담당조직
						mailInfo.put("BeforeUserNM", itemInfo.get("Name")); //변경전 담당자
						
						regUInfo.put("userID", afterAuthorID);
						String afterUserNM = StringUtil.checkNull(commonService.selectString("user_SQL.userName", regUInfo));
						mailInfo.put("AfterUserNM", afterUserNM);// 변경 후 담당자 
						setValue.put("s_memberIDs", afterAuthorID);
						Map userInfoMap = (HashMap) commonService.select("user_SQL.userList_gridList", setValue);					
						mailInfo.put("AfterTeamNM", userInfoMap.get("TeamNM"));// 변경후 담당조직
						
						
					    mailInfo.put("languageID",  commandMap.get("sessionCurrLangType"));
						mailInfo.put("emailCode", emailType);
//			
				        
				        String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", mailInfo));
						mailInfo.put("emailHTMLForm", emailHTMLForm);
						
				
						Map resultMailMap = EmailUtil.sendMail(mailMap,mailInfo,getLabel(request, commonService));
						System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMap.get("type")));
						
					 }else{ 
						System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMap.get("msg")));
					 }					
						
	
					receiverList.clear();
					

				}
			}

			
			if(alertType.equals("DHX")) {
				target.put(AJAX_ALERT_DHX, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			}
																													
			target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			if(alertType.equals("DHX")) {
				target.put(AJAX_ALERT_DHX, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류발생
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류발생
			}																												
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/editItemInfo.do")
	public String editItemInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/itm/itemInfo/editItemInfo";
		try {
			List returnData = new ArrayList();
			HashMap OccAttrInfo = new HashMap();
			HashMap getList = new HashMap();

			model.put("showVersion", StringUtil.checkNull(commandMap.get("showVersion")));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");

			OccAttrInfo = new HashMap();
			OccAttrInfo.put("ItemID", s_itemID);
			OccAttrInfo.put("languageID", request.getParameter("languageID"));
			returnData = (List) commonService.selectList("attr_SQL.getItemAttrText", OccAttrInfo);
			for (int i = 0; i < returnData.size(); i++) {
				getList = (HashMap) returnData.get(i);
				String plainText = StringUtil.checkNull(getList.get("PlainText")).replaceAll("\"", "&quot;");
				OccAttrInfo.put(getList.get("AttrTypeCode"), plainText);
			}
			model.put("AttrInfo", OccAttrInfo);

			model.put("s_itemID", s_itemID);
			model.put("option", request.getParameter("option"));

			returnData = (List) commonService.selectList("attr_SQL.getItemAttrType", OccAttrInfo);
			model.put("AttrColumn", returnData);

			OccAttrInfo.put("s_itemID", s_itemID);
			OccAttrInfo.put("option", request.getParameter("option"));
			getList = (HashMap) commonService.select("item_SQL.getObjectInfo", OccAttrInfo);
			model.put("getList", getList);

			OccAttrInfo.put("option", request.getParameter("option"));
			returnData = commonService.selectList("item_SQL.getClassOption", OccAttrInfo);
			model.put("classOption", returnData);

			returnData = new ArrayList();

			OccAttrInfo.put("languageID", (String) request.getParameter("languageID"));
			returnData = (List) commonService.selectList("attr_SQL.getItemAttrType", OccAttrInfo);

			model.put("AttrColumn", returnData);

			/* 속성 */
			returnData = new ArrayList();
			OccAttrInfo.put("s_itemID", s_itemID);
			OccAttrInfo.put("languageID", request.getParameter("languageID"));
			OccAttrInfo.put("option", request.getParameter("option"));
			OccAttrInfo.put("Editable", "1");
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);
			OccAttrInfo.put("defaultLang", defaultLang);
			OccAttrInfo.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
			model.put("showInvisible", StringUtil.checkNull(request.getParameter("showInvisible")));
			// isComLang = ALL
			returnData = (List) commonService.selectList("attr_SQL.getItemAttrMain", OccAttrInfo);
			// get ITEM ATTR (각 속성에 따른 언어 설정(IsComLang)에 따른 data 취득)
			returnData = GetItemAttrList.getItemAttrList2(commonService, returnData, OccAttrInfo,
					request.getParameter("languageID"));

			List mLovList = new ArrayList();
			List mLovAttrList = new ArrayList();
			List mLovList2 = new ArrayList();
			Map setData = new HashMap();
			Map mLovMap = new HashMap();
			String dataType = "";
			String dataType2 = "";
			String mLovAttrTypeCode = "";
			String mLovAttrTypeValue = "";

			int k = 0;
			int l = 0;
			for (int i = 0; i < returnData.size(); i++) {
				Map listMap = (Map) returnData.get(i);
				dataType = StringUtil.checkNull(listMap.get("DataType"));
				dataType2 = StringUtil.checkNull(listMap.get("DataType2"));
				if (!dataType.equals("Text")) {
					setData.put("attrTypeCode", listMap.get("AttrTypeCode"));
					setData.put("itemID", s_itemID);
					setData.put("languageID", commandMap.get("sessionCurrLangType"));
					setData.put("defaultLang", defaultLang);
					mLovList = commonService.selectList("attr_SQL.getMLovListWidthItemAttr", setData);
					listMap.put("mLovList", mLovList);

					if (k == 0) {
						mLovAttrTypeCode = StringUtil.checkNull(listMap.get("AttrTypeCode"));
						mLovAttrTypeValue = StringUtil.checkNull(listMap.get("NAME"));
					} else {
						mLovAttrTypeCode = mLovAttrTypeCode + "," + StringUtil.checkNull(listMap.get("AttrTypeCode"));
						mLovAttrTypeValue = mLovAttrTypeValue + "," + StringUtil.checkNull(listMap.get("NAME"));
					}
					model.put("mLovAttrTypeCode", mLovAttrTypeCode);
					model.put("mLovAttrTypeValue", mLovAttrTypeValue);
					k++;
				}

				if (!dataType2.equals("Text")) {
					setData.put("attrTypeCode", listMap.get("AttrTypeCode2"));
					setData.put("itemID", s_itemID);
					setData.put("languageID", commandMap.get("sessionCurrLangType"));
					setData.put("defaultLang", defaultLang);
					mLovList2 = commonService.selectList("attr_SQL.getMLovListWidthItemAttr", setData);
					listMap.put("mLovList2", mLovList2);

					if (l == 0 && mLovAttrTypeCode.equals("")) {
						mLovAttrTypeCode = StringUtil.checkNull(listMap.get("AttrTypeCode2"));
						mLovAttrTypeValue = StringUtil.checkNull(listMap.get("NAME2"));
					} else {
						mLovAttrTypeCode = mLovAttrTypeCode + "," + StringUtil.checkNull(listMap.get("AttrTypeCode2"));
						mLovAttrTypeValue = mLovAttrTypeValue + "," + StringUtil.checkNull(listMap.get("NAME2"));
					}
					model.put("mLovAttrTypeCode2", mLovAttrTypeCode);
					model.put("mLovAttrTypeValue2", mLovAttrTypeValue);
					l++;
				}

				String attrTypeCode2 = StringUtil.checkNull(listMap.get("AttrTypeCode2"));
				if (attrTypeCode2.equals("ZAT4015")) {
					setData.put("memberID", StringUtil.checkNull(listMap.get("PlainText2")));
					setData.put("assignmentType", "CNGROLETP");
					setData.put("roleType", "R");
					setData.put("orderNum", 1);
					setData.put("itemID", s_itemID);
					setData.put("languageID", commandMap.get("sessionCurrLangType"));

					Map ZAT4015Info = commonService.select("role_SQL.getMyItemMemberInfo", setData);
					model.put("ZAT4015Info", ZAT4015Info);
				}
			}

			setData = new HashMap();
			setData.put("itemClassCode", getList.get("ClassCode"));
			Map itemClassInfo = commonService.select("item_SQL.getClassOption", setData);
			String autoID = StringUtil.checkNull(itemClassInfo.get("AutoID"));

			model.put("autoID", autoID);
			model.put("getAttrList", returnData);
			model.put("title", request.getParameter("title"));

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	// 선택된 아이템들의 하위항목들을 취득해서 return
	private List getItemChildList(String[] arrayItems, String includeChildItems) throws ExceptionUtil {
		List returnList = new ArrayList();
		Map setMap = new HashMap();
		List list = new ArrayList();
		Map map = new HashMap();
		try {
			for (int i = 0; arrayItems.length > i; i++) {
				String itemId = arrayItems[i];
				returnList.add(itemId);

				if ("1".equals(includeChildItems) && !itemId.equals("0")) {
					// 취득한 아이템 리스트 사이즈가 0이면 while문을 빠져나간다.
					int j = 1;
					while (j != 0) {
						String toItemId = "";
						setMap.put("CURRENT_ITEM", itemId);
						setMap.put("CategoryCode", "ST1");
						list = commonService.selectList("report_SQL.getChildItems", setMap);
						j = list.size();
						for (int k = 0; list.size() > k; k++) {
							map = (Map) list.get(k);
							String toItemID = String.valueOf(map.get("ToItemID"));
							if (!toItemID.equals("0")) {
								returnList.add(map.get("ToItemID"));
								if (k == 0) {
									toItemId = "'" + String.valueOf(map.get("ToItemID")) + "'";
								} else {
									toItemId = toItemId + ",'" + String.valueOf(map.get("ToItemID")) + "'";
								}
							}
						}

						itemId = toItemId; // ToItemID를 다음 ItemID로 설정
					}
				}
			}
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

		return returnList;
	}

	private List removeAllHtmlTag(List List) {
		List resultList = new ArrayList();
		for (int i = 0; i < List.size(); i++) {
			Map listMap = new HashMap();
			listMap = (Map) List.get(i);
			String description = "";
			if (null != listMap.get("Description")) {
				description = listMap.get("Description").toString()
						.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
			}
			listMap.put("StringDescription", description);
			resultList.add(listMap);
		}
		return resultList;
	}

	private List getModelId(List List, String languageID) throws ExceptionUtil {
		List resultList = new ArrayList();
		Map setMap = new HashMap();
		try {
			for (int i = 0; i < List.size(); i++) {
				Map listMap = new HashMap();
				listMap = (Map) List.get(i);
				String modelId = "";

				setMap.put("ItemID", listMap.get("ItemID"));
				setMap.put("languageID", languageID);
				List modelList = commonService.selectList("model_SQL.getModelsWithItemID", setMap);

				if (modelList.size() != 0) {
					Map modelMap = (Map) modelList.get(0);
					modelId = modelMap.get("ModelID").toString();
				}

				listMap.put("ModelID", modelId);
				resultList.add(listMap);
			}
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		return resultList;
	}

	private Map removeAllHtmlTagAndSetAttrInfo(Map map) {
		String description = "";
		Map listMap = new HashMap();

		if (null != map.get("ProcessInfo")) {
			description = map.get("ProcessInfo").toString()
					.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
		}

		listMap.put("ProcessInfo", description);

		if (null != map.get("ClassName")) {
			listMap.put("ClassName", map.get("ClassName").toString());
		}

		if (null != map.get("s_itemID")) {
			listMap.put("s_itemID", map.get("s_itemID").toString());
		}

		if (null != map.get("Identifier")) {
			listMap.put("Identifier", map.get("Identifier").toString());
		}

		if (null != map.get("ItemName")) {
			listMap.put("ItemName", map.get("ItemName").toString());
		}

		if (null != map.get("LastUpdated")) {
			listMap.put("LastUpdated", map.get("LastUpdated").toString());
		}

		return listMap;
	}

	@RequestMapping(value = "/updateRefItem.do")
	public String updateRefItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setData = new HashMap();
		try {
			String ids[] = StringUtil.checkNull(request.getParameter("ids")).split(",");
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));

			setData.put("RefItemID", s_itemID);
			setData.put("LastUser", commandMap.get("sessionUserId"));
			for (int i = 0; i < ids.length; i++) {
				setData.put("ItemID", ids[i]);
				commonService.update("item_SQL.updateItem", setData);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
																													// 성공
			target.put(AJAX_SCRIPT, "fnReturn(" + s_itemID + ");");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류
																													// 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	// item previous content 조회
	@RequestMapping(value = "/viewVersionItemInfo.do")
	public String viewVersionItemInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		String url = "itm/itemInfo/viewVersionItemInfo";
		try {
			Map setMap = new HashMap();
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"));

			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", s_itemID);
			setMap.put("ChangeSetID", changeSetID);
			setMap.put("changeSetID", changeSetID);
			model.put("menu", getLabel(request, commonService));

			String strClassName = "";

			Map setDataID = new HashMap();
			setDataID.put("itemID", commandMap.get("s_itemID"));
			String parentItemID = StringUtil
					.checkNull(commonService.selectString("item_SQL.getParentItemID", setDataID));
			model.put("parentItemID", parentItemID);
			setMap.put("parentItemID", parentItemID);

			// ChanageSet info
			Map selectedCSInfo = commonService.select("cs_SQL.getChangeSetData", setMap);
			model.put("selectedCSInfo", selectedCSInfo);

			/* 기본정보 내용 취득 */
			List prcList = commonService.selectList("item_SQL.getItemAttrRevInfo", setMap);

			/* 기본정보의 속성 내용을 취득 */
			List returnData = new ArrayList();
			// isComLang = ALL
			returnData = (List) commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);

			List attrList = new ArrayList();
			Map attrMap = new HashMap();
			Map fromAttrMap = new HashMap();
			attrMap.put("languageID", commandMap.get("sessionCurrLangType"));
			attrMap.put("s_itemID", s_itemID);
			attrList = commonService.selectList("item_SQL.getItemRevDetailInfo", attrMap);

			// get ITEM ATTR (각 속성에 따른 언어 설정(IsComLang)에 따른 data 취득)
			returnData = GetItemAttrList.getItemAttrRevList(commonService, returnData, setMap,
					StringUtil.checkNull(commandMap.get("sessionCurrLangType")));

			/* CS 변경 생성자 정보 취득 */
			setMap.put("MemberID", selectedCSInfo.get("AuthorID"));
			Map authorInfoMap = commonService.select("item_SQL.getAuthorInfo", setMap);

			String dataType = "";
			Map setData = new HashMap();
			List mLovList = new ArrayList();
			String plainText = "";
			for (int i = 0; i < returnData.size(); i++) {
				Map attrTypeMap = (HashMap) returnData.get(i);
				dataType = StringUtil.checkNull(attrTypeMap.get("DataType"));
				if (dataType.equals("MLOV")) {
					setData.put("languageID", commandMap.get("sessionCurrLangType"));
					setData.put("itemID", commandMap.get("s_itemID"));
					setData.put("attrTypeCode", attrTypeMap.get("AttrTypeCode"));
					setData.put("changeSetID", changeSetID);
					mLovList = commonService.selectList("attr_SQL.getAttrRevMLovList", setData);
					plainText = "";
					if (mLovList.size() > 0) {
						for (int j = 0; j < mLovList.size(); j++) {
							Map mLovListMap = (HashMap) mLovList.get(j);
							if (j == 0) {
								plainText = StringUtil.checkNull(mLovListMap.get("Value"));
							} else {
								plainText = plainText + " / " + mLovListMap.get("Value");
							}
						}
					}
					attrTypeMap.put("PlainText", plainText);
				}
			}

			/** 첨부문서 취득 */
			setMap = new HashMap();
			setMap.put("changeSetID", changeSetID);
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("isPublic", "N");
			setMap.put("DocCategory", "ITM");
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			// setMap.put("hideBlocked", "Y");
			List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", setMap);
			model.put("attachFileList", attachFileList);

			model.put("strClassName", strClassName);
			model.put("prcList", prcList); // 기본정보
			model.put("attributesList", returnData); // 속성
			model.put("authorInfoMap", authorInfoMap); // 담당자 정보

			setMap = new HashMap();
			setMap.put("changeSetID", changeSetID);
			setMap.put("itemID", StringUtil.checkNull(commandMap.get("s_itemID")));
			String modelID = commonService.selectString("item_SQL.getModelIDFromChangSet", setMap);
			setMap.put("ModelID", modelID);
			setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			Map modelInfo = commonService.select("model_SQL.getModel", setMap);
			model.put("modelID", modelID);
			if (!modelInfo.isEmpty() && modelInfo != null) {
				model.put("MTCategory", StringUtil.checkNull(modelInfo.get("MTCategory")));
				model.put("ModelTypeName", StringUtil.checkNull(modelInfo.get("ModelTypeName")));
			}

			// NEXT ChangeSetInfo (동일 Item changeSet 바로 뒤 (AFTER))
			setData = new HashMap();
			setData.put("s_itemID", s_itemID);
			setData.put("itemID", s_itemID);
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			setData.put("parentItemID", parentItemID);
			setData.put("changeSetID", request.getParameter("changeSetID"));
			setMap.put("ItemID", s_itemID);
			String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));
			setData.put("changeMgt", changeMgt);

			Map csRNumMap = (Map) commonService.select("cs_SQL.getChangeSetRNUM", setData);
			String nextChangeSetID = "";
			String nextRNUM = StringUtil.checkNull(csRNumMap.get("NextRNUM"));

			// System.out.println("nextRNUM="+nextRNUM);
			if (!nextRNUM.equals("")) {
				setData.put("rNum", csRNumMap.get("NextRNUM"));
				nextChangeSetID = StringUtil
						.checkNull(commonService.selectString("cs_SQL.getNextPreChangeSetID", setData));

				Map nextChangeSetInfo = new HashMap();
				if (!nextChangeSetID.equals("")) {
					setData.put("ChangeSetID", nextChangeSetID);
					nextChangeSetInfo = commonService.select("cs_SQL.getChangeSetData", setData);
					model.put("nextChangeSetInfo", nextChangeSetInfo);
				}
			}
			// System.out.println("nextCSID="+nextChangeSetID);

			// Previous ChangeSetInfo

			String preChangeSetID = "";
			String PreRNUM = StringUtil.checkNull(csRNumMap.get("PreRNUM"));

			if (!PreRNUM.equals("")) {
				setData.put("rNum", csRNumMap.get("PreRNUM"));
				preChangeSetID = StringUtil
						.checkNull(commonService.selectString("cs_SQL.getNextPreChangeSetID", setData));
				Map preChangeSetInfo = new HashMap();
				if (!preChangeSetID.equals("")) {
					setData.put("ChangeSetID", preChangeSetID);
					preChangeSetInfo = commonService.select("cs_SQL.getChangeSetData", setData);
					model.put("preChangeSetInfo", preChangeSetInfo);
				}
			}

			// Last ChangeSetID
			String lastChangeSetID = "";
			setData.put("rNum", "1");
			lastChangeSetID = StringUtil.checkNull(commonService.selectString("cs_SQL.getNextPreChangeSetID", setData));

			model.put("lastChangeSetID", lastChangeSetID);
			model.put("preChangeSetID", preChangeSetID);
			model.put("nextChangeSetID", nextChangeSetID);
			model.put("projectID", request.getParameter("projectID"));
			model.put("changeSetID", changeSetID);
			model.put("authorID", request.getParameter("authorID"));
			model.put("status", request.getParameter("status"));
			model.put("s_itemID", s_itemID);

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}

	@RequestMapping(value = "/updateEditIdName.do")
	public String updateEditIdName(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map setMap = new HashMap();
			Map updateMap = new HashMap();
			String msg = "";

			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List getList = commonService.selectList("item_SQL.getItemCompositionList_gridList", setMap);

			for (int i = 0; i < getList.size(); i++) {
				Map map = (Map) getList.get(i);
				String itemId = StringUtil.checkNull(map.get("ItemID"));
				String cxnItemID = StringUtil.checkNull(map.get("CxnItemID"));
				updateMap = new HashMap();

				/* 명칭 update */
				updateMap.put("ItemID", itemId);
				updateMap.put("AttrTypeCode", "AT00001");
				updateMap.put("languageID", commandMap.get("sessionCurrLangType"));
				updateMap.put("ClassCode", StringUtil.checkNull(map.get("ClassCode")));
				updateMap.put("ItemTypeCode", StringUtil.checkNull(map.get("ItemTypeCode")));
				updateMap.put("PlainText", request.getParameter("Name_" + itemId));
				updateMap.put("LovCode", "");
				GetItemAttrList.attrUpdate(commonService, updateMap);

				/* Item Identifier update */
				updateMap.put("s_itemID", cxnItemID);

				updateMap.put("Identifier", request.getParameter("ID_" + itemId));
				updateMap.put("LastUser", commandMap.get("sessionUserId"));
				commonService.update("project_SQL.updateItemStatus", updateMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
																													// 성공
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();parent.selfClose();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류
																													// 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/itemPageView.do")
	public String itemPageView(HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/itm/itemInfo/itemPageView";
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"), GlobalVal.DEFAULT_LANGUAGE);
			String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"), "");
			String itemClassMenuUrl = StringUtil.checkNull(cmmMap.get("itemClassMenuUrl"), "");
			setMap.put("languageID", languageID);
			setMap.put("s_itemID", s_itemID);
			Map processInfo = commonService.select("report_SQL.getItemInfo", setMap);

			setMap.put("itemID", s_itemID);
			String parentItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getParentItemID", setMap));
			String itemDescription = StringUtil
					.checkNull(commonService.selectString("item_SQL.getTopItemDescription", setMap))
					.replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
			;

			setMap.put("s_itemID", s_itemID);
			Map menuDisplayMap = commonService.select("item_SQL.getMenuIconDisplay", setMap);

			model.put("menuDisplayMap", menuDisplayMap);
			model.put("itemID", s_itemID);
			model.put("parentItemID", parentItemID);
			model.put("processInfo", processInfo);
			model.put("itemDescription", itemDescription);
			model.put("itemClassMenuUrl", itemClassMenuUrl);
			model.put("menu", getLabel(cmmMap, commonService));

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("ItemAction::itemPageView::Error::" + e.toString().replaceAll("\r|\n", ""));
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	private Map getEditChildItemAttrListData(String[] varFilter, String s_itemID, String languageID, String defaultLang,
			Map menuMap) throws ExceptionUtil {

		Map resultMap = new HashMap();
		Map setData = new HashMap();
		try {
			setData.put("s_itemID", s_itemID);
			setData.put("languageID", languageID);
			setData.put("defaultLang", defaultLang);

			int idx = 1;
			for (int i = 0; i < varFilter.length; i++) {
				setData.put("attrTypeCode_" + idx, varFilter[i]);
				idx++;
			}
			List editChildItemAttrList = commonService.selectList("item_SQL.getEditChildItemAttrList", setData);

			String itemID, preItemID = "";
			String mLovValue = "";
			List mLovList = new ArrayList();
			List lovList = new ArrayList();

			String editForm = "";
			String mLovCode = "";
			List editFormList = new ArrayList();
			String RNUM = "";

			String newForm = "{ type: 'input',name: 'Identifier',value : '',label: '" + menuMap.get("LN00015") + "'}"
					+ ",{ type: 'input',name: 'ItemName',value : '',label: '" + menuMap.get("LN00028") + "'}";
			String itemName = "";
			String html1, html2, html3, html4;
			String plainText1, plainText2, plainText3, plainText4;
			for (int i = 0; i < editChildItemAttrList.size(); i++) {
				Map childItemMap = (HashMap) editChildItemAttrList.get(i);
				itemID = StringUtil.checkNull(childItemMap.get("ItemID"));
				itemName = StringUtil.checkNull(childItemMap.get("ItemName"));
				html1 = StringUtil.checkNull(childItemMap.get("Html1"));
				html2 = StringUtil.checkNull(childItemMap.get("Html2"));
				html3 = StringUtil.checkNull(childItemMap.get("Html3"));
				html4 = StringUtil.checkNull(childItemMap.get("Html4"));

				plainText1 = StringUtil.checkNull(childItemMap.get("PlainText1"));
				plainText2 = StringUtil.checkNull(childItemMap.get("PlainText2"));
				plainText3 = StringUtil.checkNull(childItemMap.get("PlainText3"));
				plainText4 = StringUtil.checkNull(childItemMap.get("PlainText4"));

				System.out.println("111plainText4:" + plainText4);

				if (!html1.equals("1"))
					plainText1 = removeAllTag(plainText1);
				else
					plainText1 = StringEscapeUtils.unescapeHtml4(plainText1);
				if (!html2.equals("1"))
					plainText2 = removeAllTag(plainText2);
				else
					plainText2 = StringEscapeUtils.unescapeHtml4(plainText2);
				if (!html3.equals("1"))
					plainText3 = removeAllTag(plainText3);
				else
					plainText3 = StringEscapeUtils.unescapeHtml4(plainText3);
				if (!html4.equals("1"))
					plainText4 = removeAllTag(plainText4);
				else
					plainText4 = StringEscapeUtils.unescapeHtml4(plainText4);

				System.out.println("2222plainText4:" + plainText4);

				childItemMap.put("ItemName", itemName);
				childItemMap.put("PlainText1", plainText1);
				childItemMap.put("PlainText2", plainText2);
				childItemMap.put("PlainText3", plainText3);
				childItemMap.put("PlainText4", plainText4);
				childItemMap.put("checkbox", false);

				RNUM = StringUtil.checkNull(childItemMap.get("RNUM"));
				editForm = "{ type: 'input',name: 'Identifier',value : '"
						+ StringUtil.checkNull(childItemMap.get("Identifier")) + "',label: '" + menuMap.get("LN00015")
						+ "'}" + ",{ type: 'input',name: 'ItemName',value : '"
						+ StringUtil.checkNull(childItemMap.get("ItemName")) + "',label: '" + menuMap.get("LN00028")
						+ "'}";

				// classOption List
				setData.put("languageID", languageID);
				setData.put("s_itemID", s_itemID);
				List classList = commonService.selectList("item_SQL.getClassOption", setData);

				String classOptions = "[{value :'', content :''}";
				for (int cidx = 0; cidx < classList.size(); cidx++) {
					Map classInfo = (Map) classList.get(cidx);
					String code = StringUtil.checkNull(classInfo.get("ClassCode"));
					String name = StringUtil.checkNull(classInfo.get("Name"));
					classOptions += ",{value :'" + code + "', content : '" + name + "'}";
				}
				classOptions += "]";

				editForm += ",{ type: 'select',name: 'ClassCode',value : '"
						+ StringUtil.checkNull(childItemMap.get("ClassCode")) + "',label: '" + menuMap.get("LN00016")
						+ "',options:" + classOptions + "}";
				if (i == 0)
					newForm += ",{ type: 'select',name: 'ClassCode',value : '',label: '" + menuMap.get("LN00016")
							+ "',options:" + classOptions + "}";

				String dataType = "";
				String comma = "";
				String html = "";
				for (int i2 = 1; i2 <= varFilter.length; i2++) {

					dataType = StringUtil.checkNull(childItemMap.get("DataType" + i2));
					html = StringUtil.checkNull(childItemMap.get("Html" + i2));
					if (!editForm.equals("")) {
						comma = ",";
					}
					if (!dataType.equals("")) {
						if (dataType.equals("LOV")) {

							setData.put("attrTypeCode", StringUtil.checkNull(childItemMap.get("AttrTypeCode" + i2)));
							setData.put("itemID", StringUtil.checkNull(childItemMap.get("ItemID")));
							setData.put("languageID", languageID);
							setData.put("defaultLang", defaultLang);
							lovList = commonService.selectList("attr_SQL.getMLovListWidthItemAttr", setData);

							String lovOptions = "[{value :'', content :''}";
							for (int k = 0; k < lovList.size(); k++) {
								Map lovInfo = (Map) lovList.get(k);
								String code = StringUtil.checkNull(lovInfo.get("CODE"));
								String name = StringUtil.checkNull(lovInfo.get("NAME"));
								lovOptions += ",{value :'" + code + "', content : '" + name + "'}";
							}
							lovOptions += "]";
							editForm += comma + "{ type: 'select',name: 'PlainText" + i2 + "',value : '"
									+ StringUtil.checkNull(childItemMap.get("LovCode" + i2)) + "',label: '"
									+ StringUtil.checkNull(childItemMap.get("AttrTypeName" + i2)) + "',options:"
									+ lovOptions + "}";
							if (i == 0)
								newForm += comma + "{ type: 'select',name: 'PlainText" + i2 + "',value : '',label: '"
										+ StringUtil.checkNull(childItemMap.get("AttrTypeName" + i2)) + "',options:"
										+ lovOptions + "}";

						} else if (dataType.equals("MLOV")) {

							setData.put("attrTypeCode", StringUtil.checkNull(childItemMap.get("AttrTypeCode" + i2)));
							setData.put("itemID", StringUtil.checkNull(childItemMap.get("ItemID")));
							setData.put("languageID", languageID);
							setData.put("defaultLang", defaultLang);
							mLovList = commonService.selectList("attr_SQL.getMLovListWidthItemAttr", setData);
							/*
							 * { name: "checkboxGroup", type: "checkboxGroup", label: "Checkbox Group",
							 * value: {first: true,second: true, }, options: {rows: [{id: "first",type:
							 * "checkbox",text: "Select 1",}, {id: "second",type: "checkbox",text:
							 * "Select 2",},] } }
							 */
							childItemMap.put("PlainText" + i2,
									getMLovVlaue(languageID, StringUtil.checkNull(childItemMap.get("ItemID")),
											StringUtil.checkNull(childItemMap.get("AttrTypeCode" + i2))));

							String mlovOptions = "{cols:[";
							String lovValues = "{";
							String mLovValues = "";

							String newFormLovValues = "{";

							String mlovCheckBoxHtml = "";
							String checked = "";
							for (int k = 0; k < mLovList.size(); k++) {
								Map mlovInfo = (Map) mLovList.get(k);
								String code = StringUtil.checkNull(mlovInfo.get("CODE"));
								String name = StringUtil.checkNull(mlovInfo.get("NAME"));
								checked = "";
								if (k == 0) {
									mlovOptions += "{id:'" + code + "', name: '" + code + "', type: 'checkbox', text: '"
											+ name + "'}";
									if (!StringUtil.checkNull(mlovInfo.get("LovCode")).equals("")) {
										lovValues += code + ":true";
										mLovValues += code + ":true";
									} else {
										lovValues += code + ":false";
										mLovValues += code + ":false";
									}

									newFormLovValues += code + ":false";
								} else {
									mlovOptions += ",{id:'" + code + "', name: '" + code
											+ "', type: 'checkbox', text: '" + name + "'}";
									if (!StringUtil.checkNull(mlovInfo.get("LovCode")).equals("")) {
										if (lovValues.equals("{")) {
											lovValues += code + ":true";
											mLovValues += code + ":true";
										} else {
											lovValues += "," + code + ":true";
											mLovValues += "," + code + ":true";
										}
									} else {
										if (lovValues.equals("{")) {
											lovValues += code + ":false";
											mLovValues += code + ":false";

											newFormLovValues += code + ":false";
										} else {
											lovValues += "," + code + ":false";
											mLovValues += "," + code + ":false";

											newFormLovValues += "," + code + ":false";
										}
									}

								}

								if (!StringUtil.checkNull(mlovInfo.get("LovCode")).equals("")) {
									checked = "checked";
								}
								mlovCheckBoxHtml += "&nbsp;&nbsp;<input type='checkbox' id='" + code + RNUM + "' name='"
										+ code + RNUM + "' " + checked + " onClick=fnCheckMlov('" + code + "','" + RNUM
										+ "','" + i2 + "')>&nbsp;" + name;
							}

							mlovOptions += "]}";
							lovValues += "}";

							newFormLovValues += "}";

							editForm += comma + "{ type: 'checkboxGroup', name: 'PlainText" + i2 + "', label: '"
									+ StringUtil.checkNull(childItemMap.get("AttrTypeName" + i2)) + "',value: "
									+ lovValues + ", options:" + mlovOptions + "}";

							if (i == 0)
								newForm += comma + "{ type: 'checkboxGroup', name: 'PlainText" + i2 + "', label: '"
										+ StringUtil.checkNull(childItemMap.get("AttrTypeName" + i2)) + "',value: "
										+ newFormLovValues + ", options:" + mlovOptions + "}";
							// childItemMap.put("PlainText"+i2, mlovCheckBoxHtml);
							// childItemMap.put("PlainTextMLOV"+i2, mLovValues);

						} else if (dataType.equals("Date")) {
							// type: "datepicker",label: "date",labelPosition: "left",labelWidth: 130, name:
							// "datepicker"
							editForm += comma + "{ type: 'datepicker',name: 'PlainText" + i2 + "',value : '"
									+ StringUtil.checkNull(childItemMap.get("PlainText" + i2)) + "',label: '"
									+ StringUtil.checkNull(childItemMap.get("AttrTypeName" + i2))
									+ "', dateFormat: '%y/%m/%d'}";

							if (i == 0)
								newForm += comma + "{ type: 'datepicker',name: 'PlainText" + i2 + "',value : '"
										+ StringUtil.checkNull(childItemMap.get("PlainText" + i2)) + "',label: '"
										+ StringUtil.checkNull(childItemMap.get("AttrTypeName" + i2))
										+ "', dateFormat: '%y/%m/%d'}";
						} else {
							if (html.equals("1")) {
								editForm += comma + "{ type: 'textarea',name: 'PlainText" + i2 + "',value : '"
										+ StringUtil.checkNull(childItemMap.get("PlainText" + i2)) + "',label: '"
										+ StringUtil.checkNull(childItemMap.get("AttrTypeName" + i2)) + "'}";

								if (i == 0)
									newForm += comma + "{ type: 'textarea',name: 'PlainText" + i2 + "',value : '"
											+ StringUtil.checkNull(childItemMap.get("PlainText" + i2)) + "',label: '"
											+ StringUtil.checkNull(childItemMap.get("AttrTypeName" + i2)) + "'}";

							} else {
								editForm += comma + "{ type: 'input',name: 'PlainText" + i2 + "',value : '"
										+ StringUtil.checkNull(childItemMap.get("PlainText" + i2)) + "',label: '"
										+ StringUtil.checkNull(childItemMap.get("AttrTypeName" + i2)) + "'}";

								if (i == 0)
									newForm += comma + "{ type: 'input',name: 'PlainText" + i2 + "',value : '"
											+ StringUtil.checkNull(childItemMap.get("PlainText" + i2)) + "',label: '"
											+ StringUtil.checkNull(childItemMap.get("AttrTypeName" + i2)) + "'}";
							}

						}
					}
				}

				// System.out.println("editForm :"+editForm);System.out.println("newForm
				// :"+newForm);
				editFormList.add(editForm);
				if (i == 0)
					resultMap.put("newForm", newForm);
				if (itemID.equals(preItemID)) {
					editChildItemAttrList.remove(i);
					i--;
				}
				preItemID = itemID;
			}

			resultMap.put("editFormList", editFormList);
			resultMap.put("editChildItemAttrList", editChildItemAttrList);

			// System.out.println("editFormList :"+editFormList);
			// System.out.println("editChildItemAttrList :"+editChildItemAttrList);

		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}

		return resultMap;
	}

	@RequestMapping(value = "/editChildItemAttrList.do")
	public String editChildItemAttrList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/itm/itemInfo/editChildItemAttrList";
		try {
			model.put("menu", getLabel(cmmMap, commonService));
			String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"), "");
			String varFilter[] = StringUtil.checkNull(cmmMap.get("varFilter"), "").split(",");

			Map setData = new HashMap();
			setData.put("arcCode", StringUtil.checkNull(request.getParameter("option")));
			model.put("sortOption",
					StringUtil.checkNull(commonService.selectString("menu_SQL.getArcSortOption", setData)));

			setData.put("SelectMenuId", StringUtil.checkNull(request.getParameter("option")));
			model.put("filterType", commonService.selectString("menu_SQL.selectArcFilter", setData));
			model.put("TreeDataFiltered", commonService.selectString("menu_SQL.selectArcTreeDataFiltered", setData));

			Map attrTypeMap = new HashMap();

			String attrTypeCodes = "";
			String attrTypeNames = "";
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String defaultLang = StringUtil.checkNull(cmmMap.get("sessionDefLanguageId"));

			setData = new HashMap();
			setData.put("languageID", languageID);
			int i2 = 1;
			if (varFilter != null) {
				for (int i = 0; i < varFilter.length; i++) {
					if (i == 0) {
						attrTypeCodes = "'" + StringUtil.checkNull(varFilter[i]) + "'";
					} else {
						attrTypeCodes += ",'" + StringUtil.checkNull(varFilter[i]) + "'";
					}
					setData.put("attrTypeCode_" + i2, StringUtil.checkNull(varFilter[i]));
					i2++;
				}
			}

			setData.put("attrTypeCodes", attrTypeCodes);
			setData.put("orderByYN", "Y");

			List attrTypeList = commonService.selectList("attr_SQL.getAttrName", setData);
			int j = 1;
			setData = new HashMap();
			attrTypeCodes = "";
			String headerConfig = "";
			Map lovListMap = new HashMap();

			String addNewRowConfig = "{'Identifier':'', 'ItemName':'', 'ClassName':'', 'ItemID': '', 'ClassCode':'', 'ItemClassIcon':'blank.png', 'StatusNM':'' ";
			for (int i = 0; i < attrTypeList.size(); i++) {
				Map attrMap = (Map) attrTypeList.get(i);

				attrTypeMap.put("attrTypeName" + j, attrMap.get("AttrTypeName"));
				attrTypeMap.put("attrTypeCode" + j, attrMap.get("AttrTypeCode"));
				setData.put("attrTypeCode_" + j, attrMap.get("AttrTypeCode"));
				String attrTypeName = StringUtil.checkNull(attrMap.get("AttrTypeName"));
				String html = StringUtil.checkNull(attrMap.get("HTML"));

				addNewRowConfig += ",'PlainText" + j + "':''";
				addNewRowConfig += ",'AttrTypeCode" + j + "':'" + StringUtil.checkNull(attrMap.get("AttrTypeCode"))
						+ "'";
				addNewRowConfig += ",'DataType" + j + "':'" + StringUtil.checkNull(attrMap.get("DataType")) + "'";

				if (StringUtil.checkNull(attrMap.get("DataType")).equals("LOV")) {
					Map setData2 = new HashMap();
					setData2.put("attrTypeCode", attrMap.get("AttrTypeCode"));
					setData2.put("itemID", s_itemID);
					setData2.put("languageID", languageID);
					setData2.put("defaultLang", defaultLang);
					List lovList = commonService.selectList("attr_SQL.getMLovListWidthItemAttr", setData2);

					lovListMap.put("lovList" + j, lovList);

					String option = "";
					for (int k = 0; k < lovList.size(); k++) {
						Map lovMap = (Map) lovList.get(k);
						if (k == 0) {
							option = "'" + StringUtil.checkNull(lovMap.get("NAME")) + "'";
						} else {
							option += ",'" + StringUtil.checkNull(lovMap.get("NAME")) + "'";
						}
					}

					if (i == 0) {
						attrTypeCodes = StringUtil.checkNull(attrMap.get("AttrTypeCode"));
						attrTypeNames = StringUtil.checkNull(attrMap.get("AttrTypeName"));
						headerConfig = "{ id: 'PlainText" + j + "', header: [{ text: '"
								+ StringUtil.checkNull(attrMap.get("AttrTypeName"))
								+ "', align: 'center'}, { content: 'inputFilter'}], editorType: 'select', options: ["
								+ option + "], align: 'center'}";
					} else {
						attrTypeCodes = attrTypeCodes + "," + StringUtil.checkNull(attrMap.get("AttrTypeCode"));
						attrTypeNames = attrTypeNames + "," + StringUtil.checkNull(attrMap.get("AttrTypeName"));
						headerConfig += ",{ id: 'PlainText" + j + "', header: [{ text: '"
								+ StringUtil.checkNull(attrMap.get("AttrTypeName"))
								+ "', align: 'center'}, { content: 'inputFilter'}], editorType: 'select', options: ["
								+ option + "], align: 'center'}";
					}
				} else if (StringUtil.checkNull(attrMap.get("DataType")).equals("MLOV")) {
					if (i == 0) {
						attrTypeCodes = StringUtil.checkNull(attrMap.get("AttrTypeCode"));
						attrTypeNames = StringUtil.checkNull(attrMap.get("AttrTypeName"));
						headerConfig = "{ id: 'PlainText" + j + "', header: [{ text: '"
								+ StringUtil.checkNull(attrMap.get("AttrTypeName"))
								+ "', align: 'center'}, { content: 'inputFilter'}], align: 'center', htmlEnable : true, editable : false}";
						/*
						 * headerConfig += ",{ id: 'PlainTextMLOV" + j + "', header: [{ text: '" +
						 * StringUtil.checkNull(attrMap.get("AttrTypeName"))+"MLOV" +
						 * "', align: 'center'}], align: 'center', hidden: false}";
						 */
					} else {
						attrTypeCodes = attrTypeCodes + "," + StringUtil.checkNull(attrMap.get("AttrTypeCode"));
						attrTypeNames = attrTypeNames + "," + StringUtil.checkNull(attrMap.get("AttrTypeName"));
						headerConfig += ",{ id: 'PlainText" + j + "', header: [{ text: '"
								+ StringUtil.checkNull(attrMap.get("AttrTypeName"))
								+ "', align: 'center'}, { content: 'inputFilter'}], align: 'center', htmlEnable : true, editable : false}";
						/*
						 * headerConfig += ",{ id: 'PlainTextMLOV" + j + "', header: [{ text: '" +
						 * StringUtil.checkNull(attrMap.get("AttrTypeName"))+"MLOV" +
						 * "', align: 'center'}], align: 'center', hidden : false}";
						 */
					}
				} else if (StringUtil.checkNull(attrMap.get("DataType")).equals("Date")) {
					if (i == 0) {
						attrTypeCodes = StringUtil.checkNull(attrMap.get("AttrTypeCode"));
						attrTypeNames = StringUtil.checkNull(attrMap.get("AttrTypeName"));
						headerConfig = "{ id: 'PlainText" + j + "', header: [{ text: '"
								+ StringUtil.checkNull(attrMap.get("AttrTypeName"))
								+ "', align: 'center'}, { content: 'inputFilter'}], align: 'center', type: 'date', format: '%y/%m/%d'}";
					} else {
						attrTypeCodes = attrTypeCodes + "," + StringUtil.checkNull(attrMap.get("AttrTypeCode"));
						attrTypeNames = attrTypeNames + "," + StringUtil.checkNull(attrMap.get("AttrTypeName"));
						headerConfig += ",{ id: 'PlainText" + j + "', header: [{ text: '"
								+ StringUtil.checkNull(attrMap.get("AttrTypeName"))
								+ "', align: 'center'}, { content: 'inputFilter'}], align: 'center', type: 'date', format: '%y/%m/%d'}";
					}
				} else {
					if (html.equals("1")) {
						if (i == 0) {
							attrTypeCodes = StringUtil.checkNull(attrMap.get("AttrTypeCode"));
							attrTypeNames = StringUtil.checkNull(attrMap.get("AttrTypeName"));
							headerConfig = "{ id: 'PlainText" + j + "', header: [{ text: '"
									+ StringUtil.checkNull(attrMap.get("AttrTypeName"))
									+ "', align: 'center'}, { content: 'inputFilter'}], align: 'center', htmlEnable: true}";
						} else {
							attrTypeCodes = attrTypeCodes + "," + StringUtil.checkNull(attrMap.get("AttrTypeCode"));
							attrTypeNames = attrTypeNames + "," + StringUtil.checkNull(attrMap.get("AttrTypeName"));
							headerConfig += ",{ id: 'PlainText" + j + "', header: [{ text: '"
									+ StringUtil.checkNull(attrMap.get("AttrTypeName"))
									+ "', align: 'center'}, { content: 'inputFilter'}], align: 'center', htmlEnable: true}";
						}
					} else {
						if (i == 0) {
							attrTypeCodes = StringUtil.checkNull(attrMap.get("AttrTypeCode"));
							attrTypeNames = StringUtil.checkNull(attrMap.get("AttrTypeName"));
							headerConfig = "{ id: 'PlainText" + j + "', header: [{ text: '"
									+ StringUtil.checkNull(attrMap.get("AttrTypeName"))
									+ "', align: 'center'}, { content: 'inputFilter'}], align: 'center'}";
						} else {
							attrTypeCodes = attrTypeCodes + "," + StringUtil.checkNull(attrMap.get("AttrTypeCode"));
							attrTypeNames = attrTypeNames + "," + StringUtil.checkNull(attrMap.get("AttrTypeName"));
							headerConfig += ",{ id: 'PlainText" + j + "', header: [{ text: '"
									+ StringUtil.checkNull(attrMap.get("AttrTypeName"))
									+ "', align: 'center'}, { content: 'inputFilter'}], align: 'center'}";
						}
					}
				}
				j++;
			}
			if (attrTypeList.size() > 0) {
				headerConfig = headerConfig + ",";
				// System.out.println(" headerConfig : " + headerConfig);
			}
			model.put("headerConfig", headerConfig);

			addNewRowConfig += "}";
			model.put("addNewRowConfig", addNewRowConfig);

			/////////////////////////// SET GRID DATA
			/////////////////////////// /////////////////////////////////////////////////////////////////////////////
			Map menuMap = getLabel(request, commonService);

			Map childItemAttrGridDataMap = getEditChildItemAttrListData(varFilter, s_itemID, languageID, defaultLang,
					menuMap);
			List editFormList = (List) childItemAttrGridDataMap.get("editFormList");
			List editChildItemAttrList = (List) childItemAttrGridDataMap.get("editChildItemAttrList");
			String newForm = StringUtil.checkNull(childItemAttrGridDataMap.get("newForm"));
			//////////////////////////////////////////////////////////////////////////////////////////////////

			setData.put("itemID", s_itemID);
			setData.put("accessRight", "U");
			Map sItemInfo = commonService.select("item_SQL.getItemAuthority", setData);
			String authorID = StringUtil.checkNull(sItemInfo.get("AuthorID"));
			String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String myItemMember = StringUtil
					.checkNull(commonService.selectString("item_SQL.getMyItemMemberIDTop1", setData));
			String sessionAuthLev = StringUtil.checkNull(cmmMap.get("sessionAuthLev"));
			String itemBlocked = StringUtil.checkNull(sItemInfo.get("Blocked"));

			String editYN = "N";
			if ("0".equals(itemBlocked) && (sessionUserID.equals(myItemMember) || authorID.equals(sessionUserID)
					|| "1".equals(sessionAuthLev))) {
				editYN = "Y";
			}

			JSONArray resultData = new JSONArray(editChildItemAttrList);
			model.put("resultData", resultData);
			model.put("editChildItemAttrList", editChildItemAttrList);
			model.put("editFormList", editFormList);
			model.put("newForm", newForm);

			model.put("editYN", editYN);
			model.put("s_itemID", s_itemID);
			model.put("attrTypeMap", attrTypeMap);

			model.put("attrTypeCodes", StringUtil.checkNull(cmmMap.get("varFilter")));
			model.put("totalCnt", editChildItemAttrList.size());
			model.put("attrTypeNames", attrTypeNames);
			model.put("editRowYN", StringUtil.checkNull(cmmMap.get("editRowYN")));

			setData.put("languageID", languageID);
			setData.put("s_itemID", s_itemID);
			List classList = commonService.selectList("item_SQL.getClassOption", setData);
			model.put("classList", new JSONArray(classList));

			List classNames = new ArrayList();
			for (int i = 0; i < classList.size(); i++) {
				Map map = (Map) classList.get(i);
				classNames.add(StringUtil.checkNull(map.get("Name")));
			}
			model.put("classOptionData", new JSONArray(classNames));

			setData.put("AuthorID", cmmMap.get("sessionUserId"));
			List csrList = commonService.selectList("project_SQL.getCsrListWithMember", setData);
			model.put("csrList", csrList);
			model.put("option", StringUtil.checkNull(cmmMap.get("option")));
			model.put("autoID", StringUtil.checkNull(cmmMap.get("autoID")));
			model.put("preFix", StringUtil.checkNull(cmmMap.get("preFix")));
		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("NewItemActionController::editChildItemAttrList::Error::"
						+ e.toString().replaceAll("\r|\n", ""));
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	public static String getJSONFormatClean(String s) {
		if (s == null) {
			return null;
		}

		return s.replace("\\\\/", "\\/").replace("\\\"", "&#34;").replace("\\r\\n", "\n").replace("\\n", "<br/>")
				.replace("\\\\", "\\");
	}

	@RequestMapping(value = "/saveChildItemAttr.do")
	public String saveChildItemAttr(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map setMap = new HashMap();
			Map setData = new HashMap();
			String setInfo = "";
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String defaultLang = StringUtil.checkNull(cmmMap.get("sessionDefLanguageId"));
			String userID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String editRowYN = StringUtil.checkNull(cmmMap.get("editRowYN"));
			String attrTypeCodes[] = StringUtil.checkNull(cmmMap.get("attrTypeCodes")).split(",");
			String attrData = getJSONFormatClean(StringUtil.checkNull(request.getParameter("attrData")));

			JSONArray jsonArray = new JSONArray(attrData);

			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject jsonData = (JSONObject) jsonArray.get(i);
				String itemID = StringUtil.checkNull(jsonData.get("ItemID"));

				Map setValue = new HashMap();
				String identifier = "";
				if (jsonData.has("Identifier")) {
					identifier = StringUtil.checkNull(jsonData.get("Identifier"));
				}
				String itemName = StringUtil.checkNull(jsonData.get("ItemName"));
				String classCode = StringUtil.checkNull(jsonData.get("ClassCode"));

				setValue.put("ItemID", itemID);
				setValue.put("languageID", languageID);
				setValue.put("identifier", identifier);

				if (!itemID.equals("")) { // EDIT
					if (!itemName.isEmpty()) {
						setValue.put("AttrTypeCode", "AT00001");
						setValue.put("PlainText", itemName);
						setInfo = GetItemAttrList.attrUpdate(commonService, setValue);
					}

					// identifiier
					setValue.put("Identifier", identifier);
					setValue.put("LastUser", userID);
					setValue.put("ClassCode", classCode);
					commonService.update("item_SQL.updateItemObjectInfo", setValue);
				} else { // Create
					if (!itemName.isEmpty()) {
						String newItemID = commonService.selectString("item_SQL.getItemMaxID", setMap);
						itemID = newItemID;

						setMap.put("option", StringUtil.checkNull(request.getParameter("option")));
						setMap.put("Version", "1");
						setMap.put("Deleted", "0");
						setMap.put("Creator", userID);
						setMap.put("CategoryCode", "OJ");
						setMap.put("ClassCode", classCode);
						setMap.put("OwnerTeamId", StringUtil.checkNull(cmmMap.get("sessionTeamId")));
						setMap.put("Identifier", identifier);
						setMap.put("ItemID", newItemID);
						setMap.put("s_itemID", request.getParameter("s_itemID"));
						setMap.put("ItemTypeCode", commonService.selectString("item_SQL.selectedItemTypeCode", setMap));

						setMap.put("AuthorID", userID);
						setMap.put("itemID", s_itemID);
						String projectID = StringUtil
								.checkNull(commonService.selectString("item_SQL.getProjectIDFromItem", setMap));
						setMap.put("ProjectID", projectID);
						setMap.put("Status", "NEW1");
						setMap.put("projectID", projectID);
						String itemAccCtrl = StringUtil
								.checkNull(commonService.selectString("project_SQL.getProjectItemAccCtrl", setMap));
						setMap.put("AccCtrl", itemAccCtrl);

						commonService.insert("item_SQL.insertItem", setMap);

						setMap.put("PlainText", itemName);
						setMap.put("AttrTypeCode", "AT00001");
						List getLanguageList = commonService.selectList("common_SQL.langType_commonSelect", setMap);
						for (int j = 0; j < getLanguageList.size(); j++) {
							Map getMap = (HashMap) getLanguageList.get(j);
							setMap.put("languageID", getMap.get("CODE"));
							commonService.insert("item_SQL.ItemAttr", setMap);
						}

						// CREATE ST1
						setMap.put("CategoryCode", "ST1");
						setMap.put("ClassCode", "NL00000");
						setMap.put("ToItemID", itemID);
						setMap.put("FromItemID", s_itemID);
						setMap.put("ItemID", commonService.selectString("item_SQL.getItemMaxID", setMap));
						setMap.remove("Identifier");
						setMap.put("ItemTypeCode",
								commonService.selectString("item_SQL.selectedConItemTypeCode", setMap));
						commonService.insert("item_SQL.insertItem", setMap);
					}
				}

				////////////////////////////////////////////////////////////////////////////////////////////////////////
				if (!itemName.isEmpty() && !StringUtil.checkNull(cmmMap.get("attrTypeCodes")).equals("")) {

					int idx = 1;
					for (int j = 0; j < attrTypeCodes.length; j++) {
						String attrTypeCode = StringUtil.checkNull(jsonData.get("AttrTypeCode" + idx));
						String plainText = StringUtil.checkNull(jsonData.get("PlainText" + idx));
						String dataType = StringUtil.checkNull(jsonData.get("DataType" + idx));

						// System.out.println("attrTypeCode :" + attrTypeCode + ", plainText:" +
						// plainText + ",dataType :" + dataType);

						if (dataType.equals("LOV")) {
							setMap.put("AttrTypeCode", attrTypeCode);

							if (!editRowYN.equals("Y")) {
								setMap.put("value", plainText);
								Map lovMap = commonService.select("analysis_SQL.getLovCodeList", setMap);
								setMap.put("PlainText", StringUtil.checkNull(lovMap.get("LovCode")));
								setMap.put("LovCode", StringUtil.checkNull(lovMap.get("LovCode")));
							} else {
								setMap.put("PlainText", plainText);
								setMap.put("LovCode", plainText);
							}

							setMap.put("ItemID", itemID);
							setMap.put("languageID", defaultLang);
							setMap.put("ClassCode", classCode);

							setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
						} else if (dataType.equals("MLOV")) {
							if (editRowYN.equals("Y")) {
								setData.put("attrTypeCode", attrTypeCode);
								setData.put("itemID", itemID);
								setData.put("languageID", languageID);
								setData.put("defaultLang", defaultLang);
								List mLovList = commonService.selectList("attr_SQL.getMLovListWidthItemAttr", setData);

								Map delData = new HashMap();
								delData.put("ItemID", itemID);
								delData.put("AttrTypeCode", attrTypeCode);
								commonService.delete("attr_SQL.delItemAttr", delData);

								// AT00031,
								// plainText:{"LV31001":true,"LV31002":true,"LV31003":true,"LV31004":false},dataType
								// :MLOV
								// System.out.println("plainText :"+plainText);
								if (!plainText.equals("")) {
									JSONObject mlovData = new JSONObject(plainText);
									for (int k = 0; k < mLovList.size(); k++) {
										Map mlovMap = (Map) mLovList.get(k);
										String mLovValue = StringUtil.checkNull(mlovMap.get("NAME"));
										String mLovCode = StringUtil.checkNull(mlovMap.get("CODE"));

										if (StringUtil.checkNull(mlovData.getString(mLovCode)).equals("true")) {
											setMap.put("PlainText", mLovValue);
											setMap.put("ItemID", itemID);
											setMap.put("AttrTypeCode", attrTypeCode);
											setMap.put("languageID", defaultLang);
											setMap.put("ClassCode", classCode);
											// setMap.put("ItemTypeCode",StringUtil.checkNull(request.getParameter("ItemTypeCode_"+itemID)));
											setMap.put("LovCode", mLovCode);
											setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
										}
									}
								}
							}
						} else { // text ...
							setMap.put("PlainText", plainText);
							setMap.put("ItemID", itemID);
							setMap.put("AttrTypeCode", attrTypeCode);
							setMap.put("languageID", languageID);
							setMap.put("ClassCode", classCode);
							setInfo = GetItemAttrList.attrUpdate(commonService, setMap);
						}
						idx++;
					}
				}
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "parent.fnCallBack('" + editRowYN + "');parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/viewItemProperty.do")
	public String viewItemProperty(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/itm/itemInfo/viewItemProperty";
		if (!StringUtil.checkNull(request.getParameter("itemPropURL")).equals("")) {
			url = "/" + StringUtil.checkNull(request.getParameter("itemPropURL"));
		}
		try {
			Map setMap = new HashMap();
			String itemID = StringUtil.checkNull(commandMap.get("itemID"));

			if (StringUtil.checkNull(commandMap.get("itemID")).equals("")) {
				commandMap.put("itemID", commandMap.get("s_itemID"));
			}

			model.put("titleViewOption", "");
			if (!StringUtil.checkNull(commandMap.get("scrnType")).equals("")) {
				model.put("titleViewOption", StringUtil.checkNull(commandMap.get("scrnType")));
			}

			setMap.put("languageID", StringUtil.checkNull(commandMap.get("languageID")));
			setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			setMap.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));
			setMap.put("ItemID", StringUtil.checkNull(commandMap.get("itemID")));
			setMap.put("sessionCurrLangType", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));

			String accMode = StringUtil.checkNull(commandMap.get("accMode"), "OPS");
			String screenMode = StringUtil.checkNull(commandMap.get("screenMode"));

			model.put("screenMode", screenMode);

			// 상단에 기재할 Item Name 을 취득
			Map prcList = commonService.select("report_SQL.getItemInfo", setMap);
			/* 기본정보의 속성 내용을 취득 */
			List attrList = new ArrayList();
			String changeSetID = "";
			if ("OPS".equals(accMode)) {
				changeSetID = StringUtil.checkNull(prcList.get("ReleaseNo"));
				setMap.put("changeSetID", changeSetID);
				prcList = commonService.select("item_SQL.getItemAttrRevInfo", setMap);
				attrList = commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
			} else {
				changeSetID = StringUtil.checkNull(prcList.get("CurChangeSet"));
				attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
			}

			Map attrMap = new HashMap();
			Map attrNameMap = new HashMap();
			Map attrHtmlMap = new HashMap();
			String mlovAttrText = "";
			for (int k = 0; attrList.size() > k; k++) {
				Map map = (Map) attrList.get(k);
				if (!map.get("DataType").equals("MLOV")) {
					attrMap.put(map.get("AttrTypeCode"), map.get("PlainText")); // 기본정보의 td
				} else {
					String mlovAttrCode = (String) map.get("AttrTypeCode");
					if (attrMap.get(mlovAttrCode) == null || attrMap.get(mlovAttrCode) == "") {
						mlovAttrText = map.get("PlainText").toString();
					} else {
						mlovAttrText += " / " + map.get("PlainText").toString();
					}
					attrMap.put(mlovAttrCode, mlovAttrText);
				}
				attrNameMap.put(map.get("AttrTypeCode"), map.get("Name")); // 기본정보의 th
				attrHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
			}

			// 관련항목 리스트
//			List relItemList = new ArrayList();
			List relItemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
//			for(int i=0; i< relItemTemp.size(); i++){
//				Map relItem = (Map) relItemTemp.get(i);
//				Map map = new HashMap();
//				map.put("languageID", setMap.get("languageID"));
//				String typeCode= (String) relItem.get("ItemTypeCode");
//				String cxnCode = "CN001"+typeCode.substring(5, 7);
//				map.put("varFilter",cxnCode);
//				map.put("isFromItem", "N");
//				map.put("s_itemID",relItem.get("s_itemID"));
//				List relCxnItemList = commonService.selectList("item_SQL.getCXNItems", map);
//				relItem.put("cxnList", relCxnItemList);
//				relItemList.add(i,relItem);
//			}

			commandMap.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));

			// 첨부문서
			setMap.put("itemId", commandMap.get("itemID"));

			// 첨부문서 취득
			commandMap.put("DocumentID", StringUtil.checkNull(commandMap.get("itemID")));
			commandMap.put("languageID", StringUtil.checkNull(commandMap.get("languageID")));
			commandMap.put("isPublic", "N");
			commandMap.put("DocCategory", "ITM");
			// commandMap.put("hideBlocked", "Y");
			commandMap.remove("changeSetID");

			List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);
			for (int i = 0; i < attachFileList.size(); i++) {
				Map getFilesize = (Map) attachFileList.get(i);
				int fileSize = Integer.parseInt(String.valueOf(getFilesize.get("FileSize")));
				String FileSize = getFileSize(fileSize);
				getFilesize.put("FileSize", FileSize);
				attachFileList.remove(i);
				attachFileList.add(i, getFilesize);
			}

			// 관련문서 취득
			commandMap.put("fromToItemID", StringUtil.checkNull(commandMap.get("itemID")));
			List itemList = commonService.selectList("item_SQL.getCxnItemIDList", commandMap);
			Map getMap = new HashMap();
			// 첨부문서 관련문서 합치기, 관련문서 itemClassCodep 할당된 fltpCode 로 filtering
			String rltdItemId = "";
			for (int i = 0; i < itemList.size(); i++) {
				setMap = (HashMap) itemList.get(i);
				getMap.put("ItemID", setMap.get("ItemID"));
				if (i < itemList.size() - 1) {
					rltdItemId += StringUtil.checkNull(setMap.get("ItemID")) + ",";
				} else {
					rltdItemId += StringUtil.checkNull(setMap.get("ItemID"));
				}
			}
			commandMap.remove("DocumentID");
			commandMap.put("rltdItemId", rltdItemId);
			List pertinentFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);

			setMap.put("status", "CLS");
			setMap.put("itemID", StringUtil.checkNull(commandMap.get("itemID")));
			String maxChangeSetVersion = commonService.selectString("cs_SQL.getItemReleaseVersion", setMap);
			String maxChangeSetValidFrom = commonService.selectString("cs_SQL.getItemValidFrom", setMap);

			setMap.put("ItemID", StringUtil.checkNull(commandMap.get("itemID")));
			String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));
			setMap.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));
			Map menuDisplayMap = commonService.select("item_SQL.getMenuIconDisplay", setMap);

			Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);

			List itemPath = new ArrayList();

			itemPath = getRootItemPath(itemID, StringUtil.checkNull(commandMap.get("languageID")), itemPath);
			Collections.reverse(itemPath);

			String blankPhotoUrlPath = GlobalVal.HTML_IMG_DIR + "/blank_photo.png";
			String photoUrlPath = GlobalVal.EMP_PHOTO_URL;
			setMap.put("blankPhotoUrlPath", blankPhotoUrlPath);
			setMap.put("photoUrlPath", photoUrlPath);
			String empPhotoItemDisPlay = GlobalVal.EMP_PHOTO_ITEM_DISPLAY;
			model.put("empPhotoItemDisPlay", empPhotoItemDisPlay);

			List roleAssignMemberList = new ArrayList();
			if (!empPhotoItemDisPlay.equals("N")) {
				roleAssignMemberList = commonService.selectList("item_SQL.getAssignmentMemberList", setMap);
			}
			model.put("roleAssignMemberList", roleAssignMemberList);

			model.put("itemInfo", itemInfo);
			model.put("itemPath", itemPath);
			model.put("menuDisplayMap", menuDisplayMap);
			model.put("itemID", StringUtil.checkNull(commandMap.get("itemID")));
			model.put("prcList", prcList); // 기본속성
			model.put("attrMap", attrMap);
			model.put("attrNameMap", attrNameMap);
			model.put("attachFileList", attachFileList); // 첨부파일
			model.put("pertinentFileList", pertinentFileList);
			model.put("showVersion", "1");
			model.put("maxVersion", maxChangeSetVersion);
			model.put("maxValidFrom", maxChangeSetValidFrom);
			model.put("changeMgt", changeMgt);
			model.put("revViewOption", StringUtil.checkNull(request.getParameter("mdlOption"), ""));
			model.put("scrnOption", StringUtil.checkNull(request.getParameter("scrnOption")));
			model.put("relItemList", relItemList); // 관련항목
			model.put("menu", getLabel(commandMap, commonService)); /* Label Setting */
			String varfilter = StringUtil.checkNull(commandMap.get("varFilter"), "");
			if (!varfilter.equals("") && !varfilter.equals(null) && !varfilter.equals("undefined")) {
				String varFilter[] = StringUtil.checkNull(commandMap.get("varFilter"), "").split(",");
				url = "/" + varFilter[0];
				if (varFilter.length > 1) {
					model.put("titleViewOption", StringUtil.checkNull(varFilter[1], ""));
				}
				if (varFilter.length > 2) {
					model.put("revViewOption", StringUtil.checkNull(varFilter[2], ""));
				}
			}
			model.put("url", url);
			model.put("itemPropURL", StringUtil.checkNull(request.getParameter("itemPropURL")));
			model.put("showElement", "Y");
			model.put("accMode", accMode);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	/**
	 * Model의 선행/후행 process 취득
	 * 
	 * @param setMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	private List getElementList(Map setMap2, Map modelMap) throws Exception {
		List returnList = new ArrayList();

		/* [TB_ELEMENT]에서 선행 /후행 데이터 취득 */
		setMap2.remove("FromID");
		setMap2.remove("ToID");
		setMap2.put("ModelID", modelMap.get("ModelID"));
		setMap2.put("SymTypeCode", "SB00004");
		List elementList = commonService.selectList("report_SQL.getElementOfModel", setMap2);
		setMap2.remove("SymTypeCode");

		for (int i = 0; elementList.size() > i; i++) {
			Map returnMap = new HashMap();
			Map elementMap = (Map) elementList.get(i);

			String objectId = String.valueOf(elementMap.get("ObjectID"));

			returnMap = elementMap;
			returnMap.put("RNUM", i + 1);

			// 선행, 후행 아이템의 Item Info 취득
			setMap2.put("s_itemID", objectId);
			Map itemInfoMap = commonService.select("report_SQL.getItemInfo", setMap2);
			returnMap.put("ID", itemInfoMap.get("Identifier"));
			returnMap.put("Name", itemInfoMap.get("ItemName"));
			returnMap.put("Description",
					StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(itemInfoMap.get("Description"), "")));

			returnList.add(returnMap);
		}

		return returnList;
	}

	/**
	 * 모델 정보 취득
	 * 
	 * @param modelMap
	 * @param request
	 */
	public void setModelMap(Map modelMap, HttpServletRequest request) {
		// model size 조정
		int width = 546;
		int height = 655;
		int actualWidth = 0;
		int actualHeight = 0;
		int zoom = 100;

		/* 문서에 표시할 모델 맵 크기를 계산 한다 */
		if ("2".equals(request.getParameter("paperSize"))) {
			width = 700;
			height = 967;
		}

		actualWidth = Integer.parseInt(StringUtil.checkNull(modelMap.get("Width"), String.valueOf(width)));
		actualHeight = Integer.parseInt(StringUtil.checkNull(modelMap.get("Height"), String.valueOf(height)));

		if (width < actualWidth || height < actualHeight) {
			for (int i = 99; i > 1; i--) {
				actualWidth = (actualWidth * i) / 100;
				actualHeight = (actualHeight * i) / 100;
				if (width > actualWidth && height > actualHeight) {
					zoom = i;
					break;
				}
			}
		}
		modelMap.remove("Width");
		modelMap.remove("Height");
		modelMap.put("Width", actualWidth);
		modelMap.put("Height", actualHeight);
		System.out.println("Width==" + actualWidth);
		System.out.println("Height==" + actualHeight);
	}

	/**
	 * 액티비티 속성 정보 취득
	 * 
	 * @param List
	 * @param defaultLang
	 * @param sessionCurrLangType
	 * @return
	 * @throws Exception
	 */
	private List getActivityAttr(List List, String defaultLang, String sessionCurrLangType, Map attrNameMap,
			Map attrHtmlMap) throws Exception {
		List resultList = new ArrayList();
		Map setMap = new HashMap();
//		List actToCheckList = new ArrayList();
		List actRuleSetList = new ArrayList();
		List actRoleList = new ArrayList();
		List actSystemList = new ArrayList();

		for (int i = 0; i < List.size(); i++) {
			Map listMap = new HashMap();
			listMap = (Map) List.get(i);
			String itemId = String.valueOf(listMap.get("ItemID"));

			setMap.put("ItemID", itemId);
			setMap.put("DefaultLang", defaultLang);
			setMap.put("sessionCurrLangType", sessionCurrLangType);
			setMap.put("delItemsYN", "N");
			List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);

			for (int k = 0; attrList.size() > k; k++) {
				Map map = (Map) attrList.get(k);
				listMap.put(map.get("AttrTypeCode"), StringUtil.checkNullToBlank(map.get("PlainText"))
						.replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\""));
			}

			setMap.put("languageID", sessionCurrLangType);
			/* Activity Rule Set 취득 Rule Group의 하위항목 Rule set list 취득 */
			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [FromItemID]인것
			setMap.put("itemTypeCode", "CN00107");
			actRuleSetList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			/* Rule set list의 연관 프로세스 && 속성 정보 취득 */
			actRuleSetList = getConItemInfo(actRuleSetList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap,
					"CN00107", "ToItemID");
			listMap.put("actRuleSetList", actRuleSetList);
			setMap.remove("CURRENT_ITEM");

//			//ToCheck 취득 
//			setMap.put("CURRENT_ITEM", itemId); // 해당 아이템이 [ToItemID]인것
//			setMap.put("itemTypeCode", "CN00109");			
//			actToCheckList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
//			// Activity ToCheck list의 연관 프로세스 && 속성 정보 취득 
//			actToCheckList = getConItemInfo(actToCheckList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap, "CN00109", "ToItemID");
//			listMap.put("actToCheckList", actToCheckList);
//			setMap.remove("CURRENT_ITEM");

			// Role 취득
			setMap.put("CURRENT_ToItemID", itemId);
			setMap.put("itemTypeCode", "CN00201");
			actRoleList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			// Activity Role list의 연관 프로세스 && 속성 정보 취득
			actRoleList = getConItemInfo(actRoleList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap,
					"CN00201", "FromItemID");
			listMap.put("actRoleList", actRoleList);
			setMap.remove("CURRENT_ToItemID");

			// System 취득
			setMap.put("CURRENT_ITEM", itemId);
			setMap.put("itemTypeCode", "CN00104");
			actSystemList = commonService.selectList("report_SQL.getChildItemsForWord", setMap);
			// Activity System list의 연관 프로세스 && 속성 정보 취득
			actSystemList = getConItemInfo(actSystemList, defaultLang, sessionCurrLangType, attrNameMap, attrHtmlMap,
					"CN00104", "ToItemID");
			listMap.put("actSystemList", actSystemList);
			setMap.remove("CURRENT_ITEM");

			resultList.add(listMap);
		}

		return resultList;
	}

	private List getChildItemInfo(List List, String defaultLang, String sessionCurrLangType, Map attrNameMap,
			Map attrHtmlMap) throws Exception {
		List resultList = new ArrayList();
		Map setMap = new HashMap();
//		List actToCheckList = new ArrayList();
		List actRuleSetList = new ArrayList();
		List actRoleList = new ArrayList();
		List actSystemList = new ArrayList();

		for (int i = 0; i < List.size(); i++) {
			Map listMap = new HashMap();
			listMap = (Map) List.get(i);
			String itemId = String.valueOf(listMap.get("ItemID"));

			setMap.put("ItemID", itemId);
			setMap.put("DefaultLang", defaultLang);
			setMap.put("sessionCurrLangType", sessionCurrLangType);
			setMap.put("delItemsYN", "N");
			List attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);

			for (int k = 0; attrList.size() > k; k++) {
				Map map = (Map) attrList.get(k);
				listMap.put(map.get("AttrTypeCode"),
						StringEscapeUtils.unescapeHtml4(StringUtil.checkNullToBlank(map.get("PlainText"))));
			}

			List conList = commonService.selectList("item_SQL.getItemConList", setMap);
			listMap.put("conList", conList);

			resultList.add(listMap);
		}

		return resultList;
	}

	/**
	 * Connection 의 Info 정보 취득
	 * 
	 * @param List
	 * @param defaultLang
	 * @param sessionCurrLangType
	 * @return
	 * @throws Exception
	 */
	private List getConItemInfo(List List, String defaultLang, String sessionCurrLangType, Map attrRsNameMap,
			Map attrRsHtmlMap, String cnTypeCode, String source) throws Exception {
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
			for (int k = 0; attrList.size() > k; k++) {
				Map map = (Map) attrList.get(k);
				attrRsNameMap.put(map.get("AttrTypeCode"), map.get("Name"));
				attrRsHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
				if (map.get("DataType").equals("MLOV")) {
					plainText = getMLovVlaue(sessionCurrLangType, itemId,
							StringUtil.checkNull(map.get("AttrTypeCode")));
					listMap.put(map.get("AttrTypeCode"), plainText);
				} else {
					listMap.put(map.get("AttrTypeCode"), map.get("PlainText"));
				}
			}

			String isFromItem = "Y";
			if (!source.equals("FromItemID")) {
				isFromItem = "N";
			}
			setMap.put("varFilter", cnTypeCode);
			setMap.put("languageID", sessionCurrLangType);
			setMap.put("isFromItem", isFromItem);
			setMap.put("s_itemID", itemId);
			List relatedAttrList = new ArrayList();
			List cnItemList = commonService.selectList("item_SQL.getCXNItems", setMap);

			for (int k = 0; cnItemList.size() > k; k++) {
				Map map = (Map) cnItemList.get(k);
				resultSubList.add(StringUtil.checkNull(map.get("RelIdentifier")) + " "
						+ removeAllTag(StringUtil.checkNull(map.get("RelName"))));
				setMap.put("ItemID", map.get("CnItemID"));
				setMap.put("DefaultLang", defaultLang);
				setMap.put("sessionCurrLangType", sessionCurrLangType);
				relatedAttrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
				if (relatedAttrList.size() > 0) {
					for (int m = 0; m < relatedAttrList.size(); m++) {
						Map relAttrMap = (Map) relatedAttrList.get(m);
						resultSubList.add(StringUtil.checkNull(relAttrMap.get("Name")));
						resultSubList.add(StringUtil.checkNull(relAttrMap.get("PlainText")));
						resultSubList.add(StringUtil.checkNull(relAttrMap.get("HTML")));
					}
				}
			}
			listMap.put("resultSubList", resultSubList);

			resultList.add(listMap);
		}

		return resultList;
	}

	private String removeAllTag(String str) {

		str = str.replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&#40;", "(").replaceAll("&#41;", ")")
				.replace("&sect;", "-").replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn")
				.replaceAll("\r\n", "&&rn");
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ")
				.replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");
		str = str.replaceAll("<img[^>]*>", "");

		return StringEscapeUtils.unescapeHtml4(str);
	}

	// byte 용량을 환산하여 반환
	private String getFileSize(double fileSize) {
		String str = "";

		// GB 단위 이상일때 GB 단위로 환산
		if (fileSize >= 1024 * 1024 * 1024) {
			fileSize = fileSize / (1024.0 * 1024.0 * 1024.0);
			str = Math.floor(fileSize * 100) / 100.0 + "GB";
		}
		// MB 단위 이상일때 MB 단위로 환산
		else if (fileSize >= 1024 * 1024) {
			fileSize = fileSize / (1024.0 * 1024.0);
			str = Math.floor(fileSize * 100) / 100.0 + "MB";
		}
		// KB 단위 이상일때 KB 단위로 환산
		else if (fileSize >= 1024) {
			fileSize = fileSize / 1024;
			str = Math.round(fileSize) + "KB";
		}
		// KB 단위보다 작을때 byte 단위로 환산
		else {
			str = "1KB";
		}
		return str;
	}

	@RequestMapping(value = "/myMgtItemTreePop.do")
	public String myMgtItemTreePop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			String itemTypeCodeList = StringUtil.checkNull(request.getParameter("itemTypeCodeList"), "");
			String itemStatus = StringUtil.checkNull(request.getParameter("itemStatus"), "");
			String itemStatusList = StringUtil.checkNull(request.getParameter("itemStatusList"), "");
			String srID = StringUtil.checkNull(request.getParameter("srID"), "");
			String speCode = StringUtil.checkNull(request.getParameter("speCode"), "");
			String actionType = StringUtil.checkNull(request.getParameter("actionType"), "");
			String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
			String updated = StringUtil.checkNull(request.getParameter("updated"), "");
			String scrID = StringUtil.checkNull(request.getParameter("scrID"), "");

			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("itemTypeCodeList", itemTypeCodeList);
			List getList = commonService.selectList("common_SQL.getItemClassCode_commonSelect", setMap);

			model.put("itemTypeCodeList", itemTypeCodeList);
			model.put("getList", getList);
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));

			model.put("itemStatus", itemStatus);
			model.put("srID", srID);
			model.put("speCode", speCode);
			model.put("projectID", projectID);
			model.put("actionType", actionType);
			model.put("updated", updated);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("scrID", scrID);
			model.put("itemStatusList", itemStatusList);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/myMgtItemTreePop");
	}

	@RequestMapping(value = "/popupMasterItem.do")
	public String popupMaster(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			String s_itemID = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("id")));
			String languageID = StringUtil
					.replaceFilterString(StringUtil.checkNull(request.getParameter("languageID")));

			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", languageID);
			String htmlTitle = StringUtil.checkNull(commonService.selectString("item_SQL.getItemInfoHeader", setMap),
					"");

			model.put("MTCategory", StringUtil.checkNull(request.getParameter("MTCategory")));

			Map setData = new HashMap();
			setData.put("itemID", s_itemID);
			String itemClassMenuURL = StringUtil
					.checkNull(commonService.selectString("menu_SQL.getItemClassMenuURL", setData));
			String itemClassMenuVarFilter = StringUtil
					.checkNull(commonService.selectString("menu_SQL.getItemClassMenuVarFilter", setData));

			if (itemClassMenuVarFilter.contains("OPS")) {
				String releaseNo = StringUtil
						.checkNull(commonService.selectString("item_SQL.getItemReleaseNo", setMap));
				String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), releaseNo);
				setMap.put("changeSetID", changeSetID);
				String itemAttrRevName = StringUtil
						.checkNull(commonService.selectString("item_SQL.getItemRevHeader", setMap), "");
				if (!itemAttrRevName.equals("")) {
					htmlTitle = itemAttrRevName;
				}
			}
			model.put("htmlTitle", htmlTitle);

			// option=CNGREW 인 경우 item Status = MOD1 or MOD2 이면 arcCode=AR00004 else
			// AR00004A로 변경
			String option = StringUtil.checkNull(request.getParameter("option"));
			String itemStatus = commonService.selectString("project_SQL.getItemStatus", setMap);
			if (option.equals("CNGREW")) {
				if (itemStatus.equals("MOD1") || itemStatus.equals("MOD2")) {
					option = "AR000004";
				} else {
					option = "AR000004A";
				}
			}
			model.put("ArcCode", option);
			model.put("itemClassMenuURL", itemClassMenuURL);
			model.put("itemClassMenuVarFilter", itemClassMenuVarFilter);
			model.put("focusedItemID", StringUtil.checkNull(request.getParameter("focusedItemID")));
			model.put("changeSetID", StringUtil.checkNull(request.getParameter("changeSetID")));
			model.put("accMode", StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("accMode"))));

			model.put("s_itemID", StringUtil.replaceFilterString(s_itemID));
			model.put("languageID", StringUtil.replaceFilterString(languageID));
			model.put("scrnType",
					StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("scrnType"))));
			model.put("screenMode",
					StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("screenMode"))));
			model.put("MTCategory",
					StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("MTCategory"))));
			model.put("loadEdit",
					StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("loadEdit"))));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/popupMasterItem");
	}

	@RequestMapping(value = "/olmPopupMasterItem.do")
	public String olmPopupMasterItem(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			String object = StringUtil.checkNull(request.getParameter("object"), "");
			String linkID = StringUtil.checkNull(request.getParameter("linkID"), "");
			String linkType = StringUtil.checkNull(request.getParameter("linkType"), ""); // id, code,
			String itemTypeCode = StringUtil.checkNull(request.getParameter("iType"), ""); // itemTypeCode
			String identifier = StringUtil.checkNull(request.getParameter("linkID"), ""); // identifier
			String attrTypeCode = StringUtil.checkNull(request.getParameter("aType"), ""); // identifier
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			String option = StringUtil.checkNull(request.getParameter("option"), "");
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"), "");
			String accMode = StringUtil.checkNull(request.getParameter("accMode"), "");
			String focusedObjID = StringUtil.checkNull(request.getParameter("focusedObjID"), "");

			String itemID = linkID;
			setMap.put("itemTypeCode", itemTypeCode);
			setMap.put("identifier", identifier);
			setMap.put("attrTypeCode", attrTypeCode);
			setMap.put("languageID", languageID);

			if (linkType.equals("code")) {
				itemID = StringUtil.checkNull(commonService.selectString("item_SQL.getItemID", setMap), "");
			} else if (linkType.equals("atr")) {
				itemID = StringUtil.checkNull(commonService.selectString("item_SQL.getItemIDFromAttr", setMap), "");
			}

			setMap.put("s_itemID", itemID);
			setMap.put("languageID", request.getParameter("languageID"));
			String htmlTitle = StringUtil.checkNull(commonService.selectString("item_SQL.getItemInfoHeader", setMap),
					"");

			// Visit Log
			if (!"".equals(itemID)) {
				cmmMap.put("ItemId", itemID);
				if (NumberUtil.isNumeric(itemID))
					commonService.insert("gloval_SQL.insertVisitLog", cmmMap);
			} else {
				cmmMap.put("ItemId", -1);
				cmmMap.put("ActionType", "ERR");
				commonService.insert("gloval_SQL.insertVisitLog", cmmMap);
			}

			Map setData = new HashMap();
			setData.put("itemID", itemID);
			String itemClassMenuURL = StringUtil
					.checkNull(commonService.selectString("menu_SQL.getItemClassMenuURL", setData));
			String itemClassMenuVarFilter = StringUtil
					.checkNull(commonService.selectString("menu_SQL.getItemClassMenuVarFilter", setData));

			// option=CNGREW 인 경우 item Status = MOD1 or MOD2 이면 arcCode=AR00004 else
			// AR00004A로 변경
			String itemStatus = commonService.selectString("project_SQL.getItemStatus", setMap);
			if (option.equals("CNGREW")) {
				if (itemStatus.equals("MOD1") || itemStatus.equals("MOD2")) {
					option = "AR000004";
				} else {
					option = "AR000004A";
				}
			}

			model.put("itemClassMenuURL", itemClassMenuURL);
			model.put("itemClassMenuVarFilter", itemClassMenuVarFilter);
			model.put("htmlTitle", htmlTitle);
			model.put("itemID", itemID);
			model.put("option", option);
			model.put("ArcCode", option);
			model.put("scrnType", scrnType);
			model.put("itemID", itemID);
			model.put("changeSetID", changeSetID);
			model.put("accMode", accMode);
			model.put("focusedObjID", focusedObjID);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/olmPopupMasterItem");
	}

	@RequestMapping(value = "/compareAttribute.do")
	public String compareAttribute(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		String url = "/itm/itemInfo/compareAttribute";

		compareText dmp = new compareText();
		dmp.Diff_Timeout = 0;

		String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));

		String itemID = StringUtil.checkNull(cmmMap.get("itemID"));
		if ("".equals(s_itemID))
			s_itemID = itemID;

		String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
		String varFilter = StringUtil.checkNull(cmmMap.get("varFilter"));
		String attrTypeList = "";
		String attrTypeList2 = "";
		String defAttrCode = StringUtil.checkNull(cmmMap.get("defAttrCode"), "");
		String changeSetID = StringUtil.checkNull(cmmMap.get("changeSet"), "");
		String preChangeSetID = StringUtil.checkNull(cmmMap.get("preChangeSet"), "");

		Map setMap = new HashMap();
		setMap.put("itemID", s_itemID);
		String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);

		if ("".equals(changeSetID)) {
			setMap.put("s_itemID", s_itemID);
			changeSetID = commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap);
			preChangeSetID = commonService.selectString("item_SQL.getItemReleaseNo", setMap);
		}

		setMap.put("changeSetID", changeSetID);
		setMap.put("ChangeSetID", changeSetID);
		setMap.put("ItemID", s_itemID);
		String changeMgt = commonService.selectString("project_SQL.getChangeMgt", setMap);
		setMap.put("changeMgt", changeMgt);

		Map CSMap = commonService.select("cs_SQL.getChangeSetRNUM", setMap);

		if ("".equals(preChangeSetID)) {
			String preRNUM = StringUtil.checkNull(CSMap.get("PreRNUM"));
			setMap.put("rNum", preRNUM);
			preChangeSetID = StringUtil.checkNull(commonService.selectString("cs_SQL.getNextPreChangeSetID", setMap));
		}
		setMap.put("s_itemID", s_itemID);
		setMap.put("languageID", languageID);
		List itemAttrList = commonService.selectList("item_SQL.getItemClassAllocAttrType", setMap);
		List diffTextList = new ArrayList();
		String curChagneSet = StringUtil.checkNull(commonService.selectString("item_SQL.getCurChangeSet", setMap));

		if (itemAttrList != null && !itemAttrList.isEmpty()) {
			for (int i = 0; i < itemAttrList.size(); i++) {
				String afterData = "", beforeData = "";
				Map diffMap = new HashMap();
				Map attrInfo = (Map) itemAttrList.get(i);
				String isHTML = StringUtil.checkNull(attrInfo.get("HTML"));
				String dataType = StringUtil.checkNull(attrInfo.get("DataType"));
				String attrCode = StringUtil.checkNull(attrInfo.get("AttrTypeCode"));
				String attrName = StringUtil.checkNull(attrInfo.get("Name"));

				/* 기본정보의 속성 내용을 취득 */
				// isComLang = ALL
				if (dataType.equals("Text") || dataType.equals("Date")) {
					// beforeData 취득
					setMap.put("s_itemID", s_itemID);
					setMap.put("languageID", languageID);
					setMap.put("AttrTypeCode", attrCode);
					setMap.put("changeSetID", preChangeSetID);

					Map beforeDataMap = (Map) commonService.select("item_SQL.getItemRevDetailInfo", setMap);
					beforeData = StringUtil.checkNull(beforeDataMap.get("PlainText"));

					// afterData 취득
					setMap.put("changeSetID", changeSetID);
					setMap.remove("IsComLang");
					setMap.put("AttrTypeCode", attrCode);

					Map afterDataMap = new HashMap();
					if (curChagneSet.equals(changeSetID)) {
						setMap.put("attrTypeCode", attrCode);
						afterData = StringUtil
								.checkNull(commonService.selectString("item_SQL.getItemAttrPlainText", setMap));
					} else {
						afterDataMap = (Map) commonService.select("item_SQL.getItemRevDetailInfo", setMap);
						afterData = StringUtil.checkNull(afterDataMap.get("PlainText"));
					}
				} else if (dataType.equals("LOV")) {
					setMap.put("defaultLang", defaultLang);
					setMap.put("s_itemID", s_itemID);
					setMap.put("languageID", languageID);
					setMap.put("AttrTypeCode", attrCode);

					// beforeDATA 취득
					setMap.put("changeSetID", preChangeSetID);
					Map beforeDataMap = (Map) commonService.select("item_SQL.getItemRevDetailInfo", setMap);
					beforeData = StringUtil.checkNull(beforeDataMap.get("PlainText"));

					// afterDATA 취득
					Map afterDataMap = new HashMap();
					setMap.put("changeSetID", changeSetID);
					if (curChagneSet.equals(changeSetID)) {
						setMap.put("attrTypeCode", attrCode);
						String afterLovCode = StringUtil
								.checkNull(commonService.selectString("item_SQL.getItemAttrLovCode", setMap));

						if (!afterLovCode.equals("")) {
							setMap.put("AttrTypeCode", attrCode);
							setMap.put("LovCode", afterLovCode);
							setMap.put("LanguageID", languageID);
							afterData = StringUtil
									.checkNull(commonService.selectString("AttributeType_SQL.selectLov", setMap));
						}
					} else {
						afterDataMap = (Map) commonService.select("item_SQL.getItemRevDetailInfo", setMap);
						afterData = StringUtil.checkNull(afterDataMap.get("PlainText"));
					}
				}

				/*
				 * else if( dataType.equals("Date")) {
				 * 
				 * setMap.put("s_itemID", s_itemID); setMap.put("languageID", languageID); //
				 * beforeData 취득 setMap.put("changeSetID", preChangeSetID);
				 * setMap.remove("IsComLang"); setMap.put("AttrTypeCode",attrCode);
				 * 
				 * Map beforeDataMap =
				 * (Map)commonService.select("item_SQL.getItemRevDetailInfo", setMap);
				 * beforeData = StringUtil.checkNull(beforeDataMap.get("PlainText"));
				 * 
				 * // afterData 취득 setMap.put("changeSetID", changeSetID);
				 * setMap.remove("IsComLang"); setMap.put("AttrTypeCode",attrCode);
				 * 
				 * Map afterDataMap = (Map)commonService.select("item_SQL.getItemRevDetailInfo",
				 * setMap); afterData = StringUtil.checkNull(afterDataMap.get("PlainText"));
				 * 
				 * }
				 */

				if (dataType.equals("Text") || dataType.equals("LOV") || dataType.equals("Date")) {
					LinkedList<compareText.Diff> diffList = dmp.diff_main(removeAllTag(beforeData),
							removeAllTag(afterData), false);

					dmp.diff_cleanupSemantic(diffList);

					String diffTextBas = dmp.diff_prettyHtml(diffList, "BAS");
					String diffTextVer = dmp.diff_prettyHtml(diffList, "VER");

					diffMap.put("diffTextBas", diffTextBas.replaceAll("&&rn", "<br/>"));
					diffMap.put("diffTextVer", diffTextVer.replaceAll("&&rn", "<br/>"));
					diffMap.put("attrName", attrName);
					diffTextList.add(diffMap);
				}
			}
		}

		setMap.put("ChangeSetID", preChangeSetID);
		Map firChangeSetInfo = commonService.select("cs_SQL.getChangeSetData", setMap);
		model.put("firChangeSetInfo", firChangeSetInfo);

		setMap.put("ChangeSetID", changeSetID);
		Map secChangeSetInfo = commonService.select("cs_SQL.getChangeSetData", setMap);
		model.put("secChangeSetInfo", secChangeSetInfo);

		model.put("diffTextList", diffTextList);
		model.put("s_itemID", s_itemID);
		model.put("menu", getLabel(request, commonService));

		return nextUrl(url);
	}

	@RequestMapping(value = "/compareAttributePop.do")
	public String compareAttributePop(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		String url = "/itm/itemInfo/compareAttributePop";

		String s_itemID = StringUtil.checkNull(cmmMap.get("itemID"));

		Map setMap = new HashMap();
		setMap.put("itemID", s_itemID);
		String changeSetID = commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap);

		model.put("changeSetID", changeSetID);
		model.put("s_itemID", s_itemID);
		model.put("menu", getLabel(request, commonService));

		return nextUrl(url);
	}

	public String removeTag(String html) throws Exception {
		return html.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
	}

	@RequestMapping(value = "/processItemInfo.do")
	public String processItemInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "";

		try {
			Map setMap = new HashMap();
			String archiCode = StringUtil.checkNull(commandMap.get("option"), "");
			String currIdx = StringUtil.checkNull(commandMap.get("currIdx"), request.getParameter("itemViewPage"));
			String itemID = StringUtil.checkNull(commandMap.get("itemID"));
			String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"));
			String scrnMode = StringUtil.checkNull(commandMap.get("scrnMode"), "V");
			String accMode = StringUtil.checkNull(commandMap.get("accMode"), "");
			String showPreNextIcon = StringUtil.checkNull(commandMap.get("showPreNextIcon"),
					request.getParameter("itemViewPage"));
			String openItemIDs = StringUtil.checkNull(commandMap.get("openItemIDs"),
					request.getParameter("openItemIDs"));
			String itemViewPage = StringUtil.checkNull(request.getParameter("itemViewPage"));
			String itemEditPage = StringUtil.checkNull(request.getParameter("itemEditPage"));
			String option = StringUtil.checkNull(request.getParameter("option"));
			String screenMode = StringUtil.checkNull(commandMap.get("screenMode"));
			String getCxnFileListYN = StringUtil.checkNull(request.getParameter("getCxnFileListYN"));
			String getChildListYN = StringUtil.checkNull(request.getParameter("getChildListYN"));
			String getCxnListYN = StringUtil.checkNull(request.getParameter("getCxnListYN"));
			String hideBlocked = StringUtil.checkNull(commandMap.get("hideBlocked"), "");
			String csFilterYN = StringUtil.checkNull(commandMap.get("csFilterYN"), ""); // changeSetID 적용 필터
			String defSiteCode = StringUtil.checkNull(request.getParameter("defSiteCode"));
			String itemOption = StringUtil.checkNull(request.getParameter("itemOption"));
			String wfOption = StringUtil.checkNull(request.getParameter("wfOption"));
			String ArcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
			String defDimValueID = StringUtil.checkNull(request.getParameter("defDimValueID"), ArcCode);
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
			String selectedTreeID = StringUtil.checkNull(request.getParameter("selectedTreeID"));
			String fixedDimValueID = StringUtil.checkNull(request.getParameter("fixedDimValueID"));
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"));
			String accRight = StringUtil.checkNull(request.getParameter("accRight"), "");
			String status = StringUtil.checkNull(request.getParameter("status"), "");
			
			String getCSListYN = StringUtil.checkNull(request.getParameter("getCSListYN"), "Y");
			String getFileListYN = StringUtil.checkNull(request.getParameter("getFileListYN"), "Y");
			String isSubItem = StringUtil.checkNull(commandMap.get("isSubItem"));

			model.put("defDimValueID", defDimValueID);
			model.put("wfOption", wfOption);
			model.put("itemOption", itemOption);
			model.put("screenMode", screenMode);
			model.put("scrnType", scrnType);
			setMap.put("itemID", s_itemID);
			url = StringUtil.checkNull(commonService.selectString("menu_SQL.getMenuVarFilterByClass", setMap)); // default url = Menu Varfilter

			if (url.equals("")) {
				url = StringUtil.checkNull(request.getParameter("url"));
			}
			url = url.split("=")[url.split("=").length - 1];
			System.out.println("url: " + url);

			if (scrnMode.equals("V") || scrnMode.equals("")) {
				if (!itemViewPage.equals("")) {
					url = "/" + StringUtil.checkNull(itemViewPage, url);
				}
			} else {
				accMode = "DEV";
				if (!itemEditPage.equals("")) {
					url = "/" + StringUtil.checkNull(itemEditPage, url);
				}
			}

			if (itemID.equals("") && !s_itemID.equals("")) {
				commandMap.put("itemID", s_itemID);
				setMap.put("itemID", s_itemID);
				itemID = s_itemID;
			}

			if (!itemID.equals("") || !s_itemID.equals("")) {

				List itemPath = new ArrayList();

				itemPath = getRootItemPath(itemID, StringUtil.checkNull(commandMap.get("languageID")), itemPath);
				Collections.reverse(itemPath);
				model.put("itemPath", itemPath);

				setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				setMap.put("langCode", StringUtil.checkNull(commandMap.get("sessionCurrLangCode")).toUpperCase());
				String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
				setMap.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));
				setMap.put("ItemID", StringUtil.checkNull(commandMap.get("itemID")));
				setMap.put("sessionCurrLangType", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));

				model.put("titleViewOption", "");

				if (!StringUtil.checkNull(commandMap.get("scrnType")).equals("")) {
					model.put("titleViewOption", StringUtil.checkNull(commandMap.get("scrnType")));
				}

				Map itemInfo = commonService.select("report_SQL.getItemInfo", setMap);
				model.put("itemInfo", itemInfo);

//				String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
				String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));
//				
//				if (StringUtil.checkNull(itemInfo.get("AuthorID")).equals(sessionUserId) 
//						|| StringUtil.checkNull(itemInfo.get("LockOwner")).equals(sessionUserId)
//						|| "1".equals(sessionAuthLev)) {
//					model.put("myItem", "Y");
//				}

				String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
				model.put("myItem", myItem);

				setMap.put("memberID", sessionUserId);
				model.put("myItemCNT",
						StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemCNT", setMap)));

				String blankPhotoUrlPath = GlobalVal.HTML_IMG_DIR + "/blank_photo.png";
				String photoUrlPath = GlobalVal.EMP_PHOTO_URL;
				setMap.put("blankPhotoUrlPath", blankPhotoUrlPath);
				setMap.put("photoUrlPath", photoUrlPath);
				String empPhotoItemDisPlay = GlobalVal.EMP_PHOTO_ITEM_DISPLAY;
				model.put("empPhotoItemDisPlay", empPhotoItemDisPlay);

				List roleAssignMemberList = new ArrayList();
				if (!empPhotoItemDisPlay.equals("N")) {
					roleAssignMemberList = commonService.selectList("item_SQL.getAssignmentMemberList", setMap);
				}
				model.put("roleAssignMemberList", roleAssignMemberList);

				/* 기본정보 내용 취득 */
				Map prcList = commonService.select("report_SQL.getItemInfo", setMap);

				/* (OPS 와 DEV 가 같아야할 때 )기본정보 -- 관리조직, 프로세스 책임자, 담당자 취득 */
				HashMap teamMap = new HashMap();
				teamMap.put("OwnerTeamID", StringUtil.checkNull(prcList.get("OwnerTeamID")));
				teamMap.put("OwnerTeamName", StringUtil.checkNull(prcList.get("OwnerTeamName")));
				teamMap.put("Name", StringUtil.checkNull(prcList.get("Name")));
				teamMap.put("AuthorID", StringUtil.checkNull(prcList.get("AuthorID")));
				teamMap.put("TeamName", StringUtil.checkNull(prcList.get("TeamName")));

				HashMap setTeamMap = new HashMap();
				setTeamMap.put("teamID", StringUtil.checkNull(teamMap.get("OwnerTeamID")));
				setTeamMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				Map teamManagerInfo = commonService.select("user_SQL.getUserTeamManagerInfo", setTeamMap);
				teamMap.put("ownerTeamMngNM", teamManagerInfo.get("MemberName"));
				teamMap.put("ownerTeamMngID", teamManagerInfo.get("UserID"));
				model.put("teamMap", teamMap);

				/*
				 * 기본정보의 속성 내용을 취득 * OPS Mode 시 changeSetID 값이 없으면 ITEM.ReleaseNo >>
				 * changeSetID, != OPS 경우 CurChangeSet 값으로
				 */
				setMap.put("status", status);
				List<Map<String, Object>> attrList = new ArrayList();

				if ("OPS".equals(accMode)) {
					String releaseNo = StringUtil.checkNull(prcList.get("ReleaseNo"));
				    changeSetID = (changeSetID == null || changeSetID.trim().isEmpty())? releaseNo : changeSetID;
					setMap.put("changeSetID", changeSetID);
					prcList = commonService.select("item_SQL.getItemAttrRevInfo", setMap);
					attrList = commonService.selectList("item_SQL.getItemRevDetailInfo", setMap);
					//hideBlocked = "N"; // 첨부문서 백업 버전은 blocked = 2 >> hideblocked = N 이어야 조회됨
					model.put("changeSetID", changeSetID);

				} else {
					changeSetID = StringUtil.checkNull(prcList.get("CurChangeSet"));
					attrList = commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
					setMap.put("changeSetID", changeSetID);
					String wfInstanceON = StringUtil
							.checkNull(commonService.selectString("wf_SQL.getWfInstON", setMap));
					model.put("wfInstanceON", wfInstanceON);
					model.put("changeSetID", changeSetID);
				}

				Map csInfo = commonService.select("cs_SQL.getChangeSetInfo", setMap);
				model.put("csInfo", csInfo);

				Map attrMap = new HashMap();
				Map attrNameMap = new HashMap();
				Map attrHtmlMap = new HashMap();
				Map attrLinkMap = new HashMap();
				String mlovAttrText = "";
				for (int k = 0; k < attrList.size(); k++) {
					Map map = (Map) attrList.get(k);

					if (!StringUtil.checkNull(map.get("DataType")).equals("MLOV")) {
						attrMap.put(map.get("AttrTypeCode"), map.get("PlainText")); // 기본정보의 td

					} else {
						String mlovAttrCode = (String) map.get("AttrTypeCode");
						if (attrMap.get(mlovAttrCode) == null || attrMap.get(mlovAttrCode) == "") {
							mlovAttrText = StringUtil.checkNull(map.get("PlainText")).toString();
						} else {
							mlovAttrText += " / " + StringUtil.checkNull(map.get("PlainText")).toString();
						}
						attrMap.put(mlovAttrCode, mlovAttrText);
					}
					attrNameMap.put(map.get("AttrTypeCode"), map.get("Name")); // 기본정보의 th
					attrHtmlMap.put(map.get("AttrTypeCode"), map.get("HTML"));
					attrLinkMap.put(map.get("AttrTypeCode"), map.get("URL"));
				}

				/** 공정 , 상세공정 **/
				// 공정 lovInfo
				setMap.put("Name", attrMap.get("ZAT01050"));
				setMap.put("atrTypeCode", "ZAT01050");
				Map docProcessLov = commonService.select("custom_SQL.zSKON_getDefaultLov", setMap);

				setMap.put("lovCode", docProcessLov.get("LovCode"));
				// 상세공정LOV
				List detailSubList = commonService.selectList("common_SQL.getSubLovList_commonSelect", setMap);


				/** 사이트 정보 **/
			
				setMap.put("s_itemID", request.getParameter("s_itemID"));
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("defDimValueID", defDimValueID);
				
				Map SiteInfo = commonService.select("custom_SQL.zSKON_getItemSiteInfo", setMap);

				model.put("defSiteCode", SiteInfo.get("CODE"));
				/***** end ******/

				// Team Role
				if ("DEV".equals(accMode) || "".equals(accMode)) {
					setMap.put("asgnOption", "1,2"); // 해제,해제중 미출력
				} else {
					setMap.put("asgnOption", "2,3"); // 해제,신규 미출력
				}
				List roleList = commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setMap);

				if("Y".equals(isSubItem)) {
					roleList =  commonService.selectList("role_SQL.getSubItemRoleList_gridList",setMap);
				}
				
				// Dimension정보 취득
				List dimInfoList = commonService.selectList("dim_SQL.selectDim_gridList", setMap);
				List dimResultList = new ArrayList();
				Map dimResultMap = new HashMap();
				Map dimInfotMap = new HashMap();
				String dimTypeName = "";
				String dimValueNames = "";

				for (int i = 0; i < dimInfoList.size(); i++) {
					Map map = (HashMap) dimInfoList.get(i);
					dimInfotMap.put(map.get("DimValueID").toString(), map.get("DimValueID").toString());
					if (i > 0) {
						if (dimTypeName.equals(map.get("DimTypeName").toString())) {
							dimValueNames += " / " + map.get("DimValuePath").toString();
						} else {
							dimResultMap.put("dimValueNames", dimValueNames);
							dimResultList.add(dimResultMap);
							dimResultMap = new HashMap(); // 초기화
							dimTypeName = map.get("DimTypeName").toString();
							dimResultMap.put("dimTypeName", dimTypeName);
							dimValueNames = map.get("DimValuePath").toString();
						}
					} else {
						dimTypeName = map.get("DimTypeName").toString();
						dimResultMap.put("dimTypeName", dimTypeName);
						dimValueNames = map.get("DimValuePath").toString();
					}
				}
				if (dimInfoList.size() > 0) {
					dimResultMap.put("dimValueNames", dimValueNames);
					dimResultList.add(dimResultMap);
				}

				List<String> dimValueCodes = new ArrayList<>(dimInfotMap.values());
				//request.setAttribute("dimCodeList", new Gson().toJson(dimValues));
				JSONArray dimData = new JSONArray(dimValueCodes);
				model.put("dimData", dimData);
				model.put("dimInfotMap", dimInfotMap);

				// 액티비티 리스트
				List childItemList = new ArrayList();
				if (!getChildListYN.equals("N")) {
					setMap.put("gubun", "M");
					childItemList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
					String languageId = String.valueOf(commandMap.get("sessionCurrLangType"));
					childItemList = getChildItemInfo(childItemList, defaultLang, languageId, attrNameMap, attrHtmlMap); // 액티비티의 속성을 액티비티 리스트에 추가
				}

				// 모델 리스트
				setMap.put("viewYN", "Y");
				List modelList = commonService.selectList("model_SQL.getModelList_gridList", setMap);

				String reqNotInCxnClsList[] = StringUtil.checkNull(request.getParameter("notInCxnClsList"), "")
						.split(",");
				String notInCxnClsList = "";

				if (!StringUtil.checkNull(request.getParameter("notInCxnClsList"), "").equals("")) {
					for (int i = 0; i < reqNotInCxnClsList.length; i++) {
						if (i == 0) {
							notInCxnClsList = "'" + reqNotInCxnClsList[i] + "'";
						} else {
							notInCxnClsList += ",'" + reqNotInCxnClsList[i] + "'";
						}
					}
					setMap.put("notInCxnClsList", notInCxnClsList);
				}

				if (!getCxnListYN.equals("N")) { // &notInClsList=CNL0506,CNL0511
					// 관련항목 리스트
					List relItemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
					model.put("relItemList", relItemList); // 관련항목
				}

				commandMap.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));
				
				if (!getCSListYN.equals("N")) {
					// 변경이력
					List historyList = commonService.selectList("cs_SQL.getItemChangeList_gridList", commandMap);
					model.put("historyList", historyList);
				}

				// 선/후행 프로세스 리스트
				List elementList = new ArrayList();
				Map modelMap = new HashMap();
				String modelID = "";
				if (modelList.size() > 0) {
					if ("OPS".equals(accMode)) {
						modelID = commonService.selectString("model_SQL.getModelIDFromItem", commandMap);
					} else {
						modelID = StringUtil.checkNull(((Map) modelList.get(0)).get("ModelID"));
					}
				}

				setMap.put("modelID", modelID);
				modelMap = commonService.select("model_SQL.getModelInfo", setMap);

				// mdlIF = Y 인 symbolList
//				setMap.put("mdlIF","Y");
				setMap.put("modelTypeCode", modelMap.get("ModelTypeCode"));
				/*
				 * List symbolList = commonService.selectList("model_SQL.getSymbolTypeList",
				 * setMap);
				 * 
				 * String SymTypeCodes = ""; for(int i=0; i<symbolList.size(); i++) { Map map =
				 * (Map) symbolList.get(i); if(i != 0) SymTypeCodes += ","; SymTypeCodes +=
				 * "'"+map.get("SymTypeCode")+"'"; }
				 */
				String mdlIF = StringUtil.checkNull(request.getParameter("mdlIF"));
				setMap.put("ModelID", modelID);
				setMap.put("mdlIF", mdlIF);
				elementList = commonService.selectList("report_SQL.getObjListOfModel", setMap);

				// 첨부문서
				setMap.put("itemId", commandMap.get("itemID"));
				String itemFileOption = commonService.selectString("fileMgt_SQL.getFileOption", setMap);

				// 첨부문서 취득
				commandMap.put("DocumentID", StringUtil.checkNull(commandMap.get("itemID")));
				commandMap.put("languageID", StringUtil.checkNull(commandMap.get("languageID")));
				commandMap.put("isPublic", "N");
				commandMap.put("DocCategory", "ITM");
				commandMap.put("hideBlocked", hideBlocked);

				if (!csFilterYN.equals("N")) { // item 에 첨부된 전체 파일을 조회하고자 하는 경우
					commandMap.put("changeSetID", changeSetID);
				}

				if (getCxnFileListYN.equals("Y")) {
					// 관련문서 취득
					commandMap.put("fromToItemID", s_itemID);
					List itemList = commonService.selectList("item_SQL.getCxnItemIDList", commandMap);
					Map getMap = new HashMap();
					// 첨부문서 관련문서 합치기, 관련문서 itemClassCodep 할당된 fltpCode 로 filtering
					String rltdItemId = "";
					for (int i = 0; i < itemList.size(); i++) {
						setMap = (HashMap) itemList.get(i);
						getMap.put("ItemID", setMap.get("ItemID"));
						if (i < itemList.size() - 1) {
							rltdItemId += StringUtil.checkNull(setMap.get("ItemID")) + ",";
						} else {
							rltdItemId += StringUtil.checkNull(setMap.get("ItemID"));
						}
					}
					// commandMap.remove("DocumentID");
					commandMap.put("rltdItemId", rltdItemId);
				}

				
				if (!getFileListYN.equals("N")) {
					// 첨부파일
					List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", commandMap);
					List attachFileActivityList = commonService.selectList("fileMgt_SQL.getFileActivityAll_gridList",commandMap);
					model.put("attachFileList", attachFileList);
					model.put("attachFileActivityList", attachFileActivityList);
				}

				setMap.put("status", "CLS");
				setMap.put("ItemID", StringUtil.checkNull(commandMap.get("itemID")));
				String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));

				// QuickCheckOut 설정
				String quickCheckOut = "N";
				String itemAuthorID = StringUtil.checkNull(itemInfo.get("AuthorID"));
				String sessionUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));

				if (itemInfo.get("Blocked").equals("2")) {

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
				// QuickCheckOut설정끝
			
				/* project defalt csrid 넣기 */
				// 프로젝트 기술표준관리
				setMap.put("itemClassCode", "CL16004");
				setMap.put("itemTypeCode", "OJ00016");
				setMap.put("userID", StringUtil.checkNull(commandMap.get("sessionUserId")));
				String projectID = StringUtil
						.checkNull(this.commonService.selectString("item_SQL.getItemClassDefCSRID", setMap));

				setMap.put("projectID", projectID);
				model.put("projectID", projectID);

				model.put("quickCheckOut", quickCheckOut);
				setMap.put("s_itemID", StringUtil.checkNull(commandMap.get("itemID")));
				Map menuDisplayMap = commonService.select("item_SQL.getMenuIconDisplay", setMap);

				model.put("menuDisplayMap", menuDisplayMap);
				model.put("prcList", prcList); // 기본속성
				model.put("roleList", roleList);
				model.put("attrList", attrList);
				model.put("attrMap", attrMap);
				model.put("attrNameMap", attrNameMap);
				model.put("attrLinkMap", attrLinkMap);
				model.put("dimResultMap", dimResultMap);
				model.put("dimResultList", dimResultList); // 디멘션
				
				model.put("changeMgt", changeMgt);
				model.put("modelList", modelList);
				model.put("elementList", elementList); // 선후행
				model.put("activityList", childItemList); // 액티비티
				model.put("childItemList", childItemList);
				model.put("option", option);
				model.put("itemFileOption", itemFileOption);
				model.put("SiteInfo", SiteInfo); // 사이트 정보
				model.put("detailSubList", detailSubList);// 상세공정
				setMap.put("DocCategory", "CS");

				setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				String wfURL = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", setMap));
				model.put("wfURL", wfURL); // 변경이력

				if ("OPS".equals(accMode))
					setMap.put("teamID", StringUtil.checkNull(prcList.get("AuthorTeamID")));
				else
					setMap.put("teamID", StringUtil.checkNull(prcList.get("OwnerTeamID")));

				Map managerInfo = commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
				model.put("ownerTeamMngNM", managerInfo.get("MemberName")); // 프로세스 책임자
				model.put("ownerTeamMngID", managerInfo.get("UserID"));

				// Attr PlainText에 Code가 포함되는 리스트
				setMap.put("defaultLang", defaultLang);
				setMap.put("CategoryCode", "OJ");
				setMap.put("ItemTypeCode", "OJ00001");

				List attrCode = new ArrayList();
				Map temp = new HashMap();
				temp.put("attrCode", "AT00014");
				temp.put("selectOption", "AND");
				temp.put("searchValue", StringUtil.checkNull(prcList.get("Identifier")));
				attrCode.add(temp);
				setMap.put("AttrCode", attrCode);
				List attrMatchValueList = commonService.selectList("search_SQL.getSearchMultiList_gridList", setMap);
				model.put("attrMatchValueList", attrMatchValueList);
			}

			// item 생선 전 디폴트 속성들 지정
			else {
				String languageID = StringUtil.checkNull(commandMap.get("languageID"));
				// 팀명, 사이트코드명
				String TeamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));
				String memberID = StringUtil.checkNull(commandMap.get("sessionUserId"));

				//setMap.put("memberID", memberID);
				setMap.put("languageID", languageID);
				setMap.put("defDimValueID", defDimValueID);
				Map SiteInfo = commonService.select("custom_SQL.zSKON_getSiteInfo", setMap);

				setMap.put("siteCode", SiteInfo.get("CODE"));
				setMap.put("languageID", languageID);
				// 문서채번 사이트코드 정보
				Map docSiteInfo = commonService.select("custom_SQL.zSKON_getDocSite", setMap);

				// 프로젝트 기술표준관리
				setMap.put("itemClassCode", "CL16004");
				setMap.put("itemTypeCode", "OJ00016");
				setMap.put("userID", StringUtil.checkNull(commandMap.get("sessionUserId")));
				String projectID = StringUtil
						.checkNull(this.commonService.selectString("item_SQL.getItemClassDefCSRID", setMap));

				// setMap.put("projectID", projectID);

				String projectName = commonService.selectString("project_SQL.getProjectName", setMap);

				String curItemID = StringUtil.checkNull(request.getParameter("curItemID"));
				setMap.put("curItemID", curItemID);
				// setMap.put("attrTypeCode", "AT00001");
				// setMap.put("itemTypeCode", "OJ00016");

				// 문서분류
				setMap.put("s_itemID", curItemID);
				String path = commonService.selectString("item_SQL.getItemPath", setMap);

				Map itemInfo = new HashMap();
				itemInfo.put("Path", path);

				/** 디폴트 속성값 **/
				Map defaultAttr = commonService.select("custom_SQL.zSKON_getDefaultAttr", setMap);

				// 영역 lovInfo

				setMap.put("Name", defaultAttr.get("L1Name"));
				setMap.put("atrTypeCode", "ZAT01030");
				Map docAreaLov = commonService.select("custom_SQL.zSKON_getDefaultLov", setMap);

				// 상세영역

				setMap.put("Name", defaultAttr.get("L3Name"));
				setMap.put("atrTypeCode", "ZAT02022");
				Map docDetailAreaLov = commonService.select("custom_SQL.zSKON_getDefaultLov", setMap);

				// 문서 유형 lovInfo
				setMap.put("Name", defaultAttr.get("L2Name"));
				setMap.put("atrTypeCode", "ZAT01060");
				Map docTypeLov = commonService.select("custom_SQL.zSKON_getDefaultLov", setMap);

				// 공정 lovInfo
				setMap.put("Name", defaultAttr.get("L3Name"));
				setMap.put("atrTypeCode", "ZAT01050");
				Map docProcessLov = commonService.select("custom_SQL.zSKON_getDefaultLov", setMap);

				setMap.put("lovCode", docProcessLov.get("LovCode"));
				// 상세공정LOV
				List detailSubList = commonService.selectList("common_SQL.getSubLovList_commonSelect", setMap);

				// 문서유형에 따른 문서레벨
				setMap.put("Name", defaultAttr.get("L2Name"));
				setMap.put("atrTypeCode", "ZAT01060");
				Map docLevelLov = commonService.select("custom_SQL.zSKON_getDefaultLov", setMap);

				Map setData = new HashMap();
				setData.put("languageID", languageID);
				setData.put("LovCode", docLevelLov.get("RefLovCode"));
				setData.put("atrTypeCode", "ZAT01020");
				Map docLevel = commonService.select("custom_SQL.zSKON_getDefaultLov", setData);

				// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
				String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);

				// 속성 검색
				setMap.put("defaultLang", defaultLang);
				List attrList = commonService.selectList("attr_SQL.getItemAttr", setMap);

				model.put("attrList", attrList);
				/** 모델추가 **/
				model.put("docSiteInfo", docSiteInfo);
				model.put("itemInfo", itemInfo);
				model.put("curItemID", setMap.get("s_itemID"));
				model.put("TeamName", TeamName);
				model.put("SiteInfo", SiteInfo);
				model.put("defaultAttr", defaultAttr);
				model.put("docAreaLov", docAreaLov);
				model.put("docDetailAreaLov", docDetailAreaLov);
				model.put("docTypeLov", docTypeLov);
				model.put("docProcessLov", docProcessLov);
				model.put("detailSubList", detailSubList);
				model.put("docLevelLov", docLevelLov);
				model.put("docLevel", docLevel);
				model.put("projectName", projectName);
			}

			model.put("itemID", StringUtil.checkNull(commandMap.get("itemID")));

			model.put("showVersion", "1");
			model.put("revViewOption", StringUtil.checkNull(request.getParameter("mdlOption"), ""));

			model.put("showPreNextIcon", showPreNextIcon);
			model.put("openItemIDs", openItemIDs);
			model.put("option", archiCode);
			model.put("currIdx", currIdx);
			model.put("menu", getLabel(commandMap, commonService)); /* Label Setting */
			model.put("itemPropURL", StringUtil.checkNull(request.getParameter("itemPropURL")));
			model.put("itemViewPage", itemViewPage);
			model.put("itemEditPage", itemEditPage);
			model.put("scrnMode", scrnMode);
			model.put("accMode", accMode);

			commandMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));

			List<Map<String, Object>> procList = commonService.selectList("item_SQL.getSubItemList_gridList",
					commandMap);
			JSONArray gridData = new JSONArray(procList);
			model.put("gridData", gridData);

			List<Map<String, Object>> activityList = commonService
					.selectList("custom_SQL.zSKON_getProcessActivity_gridList", commandMap);
			model.put("activityListData", activityList);

			HashMap setData = new HashMap();

			model.put("menu", getLabel(request, commonService)); // Label Setting
			setData.put("itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			Map itemAuthInfo = commonService.select("item_SQL.getItemAuthority", setData);
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("itemIDAuthorID", StringUtil.checkNull(itemAuthInfo.get("AuthorID")));
			model.put("assignmentType", StringUtil.checkNull(request.getParameter("varFilter")));
			model.put("blankPhotoUrlPath", GlobalVal.HTML_IMG_DIR + "/blank_photo.png");
			model.put("photoUrlPath", GlobalVal.EMP_PHOTO_URL);
			model.put("selectedTreeID", selectedTreeID);
			model.put("fixedDimValueID", fixedDimValueID);

			setData.put("itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			setData.put("isAll", "N");
			setData.put("assignmentType", StringUtil.checkNull(request.getParameter("varFilter")));
			setData.put("blankPhotoUrlPath", GlobalVal.HTML_IMG_DIR + "/blank_photo.png");
			setData.put("photoUrlPath", GlobalVal.EMP_PHOTO_URL);
			setData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			List assignedRoleList = commonService.selectList("role_SQL.getAssignedRoleList_gridList", setData);
			JSONArray gridDataRole = new JSONArray(assignedRoleList);
			model.put("gridDataRole", gridDataRole);
			model.put("accRight", accRight);
			
			setMap.put("memberID", commandMap.get("sessionUserId"));
			model.put("myItemSeq", StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemSeq", setMap)));

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
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
	private List getRootItemPath(String itemID, String languageID, List itemPath) throws Exception {
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

	@RequestMapping(value = "/editAttrOfItemsReport.do")
	public String editAttrOfItemsReport(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			HashMap setMap = new HashMap();

			String attrCode = StringUtil.checkNull(request.getParameter("attrCode"));
			String[] attrCodes = attrCode.split(",");
			String processedAttrCode = "'" + String.join("','", attrCodes) + "'";

			String s_itemID = StringUtil.checkNull(request.getParameter("itemID"));
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			setMap.put("AttrTypeCodes", processedAttrCode);
			setMap.put("defaultLang", StringUtil.checkNull(cmmMap.get("sessionDefLanguageId")));

			List itemAttrList = (List) commonService.selectList("attr_SQL.getItemAttr", setMap);

			List mLovList = new ArrayList();
			String dataType = "";

			String plainText = "";
			for (int i = 0; i < itemAttrList.size(); i++) {
				Map attrTypeMap = (HashMap) itemAttrList.get(i);
				dataType = StringUtil.checkNull(attrTypeMap.get("DataType"));
				if (dataType.equals("MLOV")) {

					plainText = getMLovVlaue(StringUtil.checkNull(cmmMap.get("sessionCurrLangType")), s_itemID,
							StringUtil.checkNull(attrTypeMap.get("AttrTypeCode")));
					attrTypeMap.put("PlainText", plainText);

					setMap.put("s_itemID", attrTypeMap.get("AttrTypeCode"));
					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
					mLovList = commonService.selectList("attr_SQL.selectAttrLovOption", setMap);
					attrTypeMap.put("mLovList", mLovList);
				}
			}

			JSONArray jsonAttrList = new JSONArray(itemAttrList);
			model.put("s_itemID", s_itemID);
			model.put("attrCode", processedAttrCode);
			model.put("getList", itemAttrList);
			model.put("jsonAttrList", jsonAttrList);
			model.put("title", "정기검토현황");

			String classCode = StringUtil.checkNull(commonService.selectString("item_SQL.getClassCode", cmmMap));
			model.put("classCode", classCode);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/itm/itemInfo/editAttrOfItemsReport");
	}

	@RequestMapping(value = "/getFileList.do")
	public void activityFile(HttpServletRequest request, HttpServletResponse res, HashMap<String, Object> cmmMap,
			ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map map = new HashMap();

		res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
		try {
			String documentID = StringUtil.checkNull(request.getParameter("documentID"), "");
			String docCategory = StringUtil.checkNull(request.getParameter("docCategory"), "");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
			String hideBlocked = StringUtil.checkNull(request.getParameter("hideBlocked"), "");

			map.put("DocumentID", documentID);
			map.put("DocCategory", docCategory);
			map.put("languageID", languageID);
			map.put("changeSetID", changeSetID);
			map.put("hideBlocked", hideBlocked);

			//skon 보안 취약점 조치
			//map.put("showFilePath", "N");
			
			List fileList = commonService.selectList("fileMgt_SQL.getFile_gridList", map);

			jsonObject.put("data", fileList);
			res.getWriter().print(jsonObject);
		} catch (Exception e) {
			System.out.println(e.toString());
			res.getWriter().print(jsonObject);
		}
	}
	
}
