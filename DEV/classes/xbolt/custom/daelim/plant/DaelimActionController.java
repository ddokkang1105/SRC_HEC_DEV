package xbolt.custom.daelim.plant;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.AESUtil;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.JsonUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.daelim.plant.EnsemblePlus.DLMWebServiceProxy;
import xbolt.custom.daelim.val.DaelimGlobalVal;

/**
 * @Class Name : DaelimActionController.java
 * @Description : DaelimActionController.java
 * @Modification Information
 * @수정일 수정자 수정내용 @--------- --------- ------------------------------- @2018. 01.
 *      15. smartfactory 최초생성
 *
 * @since 2018. 01. 15
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class DaelimActionController extends XboltController {
	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;
	private AESUtil aesAction;

	@RequestMapping(value = "/daelim/logindaelimForm.do")
	public String logindaelimForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		model = setLoginScrnInfo(model, cmmMap);
		return nextUrl("custom/daelim/login");
	}

	@RequestMapping(value = "/daelim/logindaelim.do")
	public String logindaelim(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {
			HttpSession session = request.getSession(true);
			Map resultMap = new HashMap();
			String langCode = GlobalVal.DEFAULT_LANG_CODE;
			String languageID = StringUtil.checkNull(cmmMap.get("LANGUAGE"),
					StringUtil.checkNull(cmmMap.get("LANGUAGEID")));
			if (languageID.equals("")) {
				languageID = GlobalVal.DEFAULT_LANGUAGE;
			}

			cmmMap.put("LANGUAGE", languageID);
			String ref = request.getHeader("referer");
			String protocol = request.isSecure() ? "https://" : "http://";

			String IS_CHECK = GlobalVal.PWD_CHECK;
			String url_CHECK = StringUtil.chkURL(ref, protocol);

			if ("".equals(IS_CHECK))
				IS_CHECK = "Y";

			if ("".equals(url_CHECK)) {
				resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
				resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));
			} else {
				Map idInfo = new HashMap();
				idInfo = commonService.select("login_SQL.login_id_select", cmmMap);

				if (idInfo == null || idInfo.size() == 0) {
					resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
					resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));
				} else {
					aesAction = new AESUtil();
					cmmMap.put("LOGIN_ID", idInfo.get("LoginId"));
					if ("Y".equals(IS_CHECK) && "login".equals(url_CHECK)) {
						cmmMap.put("IS_CHECK", "Y");
					} else {
						cmmMap.put("IS_CHECK", "N");
					}

					Map loginInfo = commonService.select("login_SQL.login_select", cmmMap);
					if (loginInfo == null || loginInfo.size() == 0) {
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
						// resultMap.put(AJAX_ALERT, "System에 해당 사용자 정보가 없습니다.등록 요청바랍니다.");
						resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00102"));
					} else {
						// [Authority] < 4 인 경우, 수정가능하게 변경
						if (loginInfo.get("sessionAuthLev").toString().compareTo("4") < 0)
							loginInfo.put("loginType", "editor");
						else
							loginInfo.put("loginType", "viewer");
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('Y')");
						// resultMap.put(AJAX_MESSAGE, "Login성공");
						session.setAttribute("loginInfo", loginInfo);
					}
				}
			}
			model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); // singleSignOn 구분
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType")));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
			model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));
			model.addAttribute(AJAX_RESULTMAP, resultMap);
		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("LoginActionController::loginbase::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}

	private ModelMap setLoginScrnInfo(ModelMap model, HashMap cmmMap) throws ExceptionUtil {
		Map setMap = new HashMap();
		String loginID = StringUtil.checkNull(cmmMap.get("loginID"));
		String language = StringUtil.checkNull(cmmMap.get("language"));
		setMap.put("extCode", language);
		try {
			String languageID = StringUtil.checkNull(commonService.selectString("common_SQL.getLanguageID", setMap),
					"");
			model.addAttribute("loginid", loginID);
			model.addAttribute("lng", languageID);

			if (_log.isInfoEnabled()) {
				_log.info("setLoginScrnInfo : loginid=" + StringUtil.checkNull(cmmMap.get("loginid")) + ",lng="
						+ StringUtil.checkNull(cmmMap.get("lng")));
			}
			List langList = commonService.selectList("common_SQL.langType_commonSelect", cmmMap);
			if (langList != null && langList.size() > 0) {
				for (int i = 0; i < langList.size(); i++) {
					Map langInfo = (HashMap) langList.get(i);
					if (langInfo.get("IsDefault").equals("1")) {
						model.put("langType", StringUtil.checkNull(langInfo.get("CODE"), ""));
						model.put("langName", StringUtil.checkNull(langInfo.get("NAME"), ""));
					}
				}
			} else {
				model.put("langType", "");
				model.put("langName", "");
			}
			model.put("langList", langList);

			String gloProjectID = StringUtil.checkNull(cmmMap.get("gloProjectID"));
			String itemID = "";
			Map setData = new HashMap();
			if (!gloProjectID.equals("") && !gloProjectID.equals("undefind")) {
				setData.put("projectCode", gloProjectID);
				Map pjtInfoMap = commonService.select("variant_SQL.getPJTInfos", setData);

				if (pjtInfoMap != null) {
					setData.put("refPGID", StringUtil.checkNull(pjtInfoMap.get("RefPGID")));
					String arcCode = StringUtil
							.checkNull(commonService.selectString("variant_SQL.getDefArcCode", setData));
					model.put("arcCode", arcCode);

					setData.put("projectID", StringUtil.checkNull(pjtInfoMap.get("ProjectID")));
					itemID = StringUtil.checkNull(commonService.selectString("variant_SQL.getDefVariantID", setData));

					if (!"".equals(itemID))
						model.put("itemID", itemID);
					else {
						model.put("itemID", "100003");
					}
				} else {
					model.put("itemID", "100003");
				}

				setData.put("loginID", loginID);
				String focusedItemID = StringUtil
						.checkNull(commonService.selectString("organization_SQL.getItemIdFromTeam", setData));
				model.put("focusedItemID", focusedItemID);
				System.out.println("focusedItemID :" + focusedItemID);
			}
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}
		model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); // singleSignOn 구분
		model.put("gloProjectID", StringUtil.checkNull(cmmMap.get("gloProjectID")));
		model.put("isCheck", StringUtil.checkNull(cmmMap.get("isCheck")));

		return model;
	}

	@RequestMapping(value = "/daelim/runIEPSystem.do")
	public String runIEPSystem(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			Map setMap = new HashMap();

			setMap.put("itemID", itemID);
			setMap.put("attrTypeCode", "AT00000");
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));

			String parameter = StringUtil.checkNull(commonService.selectString("custom_SQL.getDLBPParameter", setMap),
					"");

			String url = DaelimGlobalVal.WEB_BP_URL + "?guid=" + parameter;
			model.put("url", url);

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("MainDaelimActionController::mainpage::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("custom/daelim/plant/runIEPSystem");
	}

	@RequestMapping(value = "/daelim/runBPPopup.do")
	public String runBPPopup(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			String p_itemID = StringUtil.checkNull(request.getParameter("p_itemID"));
			Map setMap = new HashMap();

			setMap.put("itemID", itemID);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("p_itemID", p_itemID);

			String parameter = StringUtil.checkNull(commonService.selectString("custom_SQL.getDLParameter", setMap), "")
					+ "&target=IEP&UserNo=" + StringUtil.checkNull(cmmMap.get("sessionEmployeeNm"));

			String projectNo = StringUtil
					.checkNull(commonService.selectString("custom_SQL.zdaelim_getProjectNoFromitemID", setMap), "");

			if (projectNo != null && !"".equals(projectNo))
				parameter += "&ProjectNo=" + projectNo;

			model.put("url", parameter);

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("MainDaelimActionController::mainpage::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("custom/daelim/plant/runBPPopup");
	}

	@RequestMapping(value = "/daelim/getBPLinkList.do")
	public String getBPLinkList(ModelMap model, HashMap cmmMap, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		try {
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			String plainText = StringUtil.checkNull(request.getParameter("plainText"));
			Map setMap = new HashMap();
			String itemIds = "";
			String plainTexts = "";
			String itemIdList = "";

			setMap.put("itemID", itemID);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));

			setMap.put("plainText", plainText);
			List bpInfoList = commonService.selectList("custom_SQL.getBPInfoList", setMap);

			model.put("bpInfoList", bpInfoList);

			for (int i = 0; i < bpInfoList.size(); i++) {
				Map temp = (Map) bpInfoList.get(i);

				if (i == 0) {
					itemIds = StringUtil.checkNull(temp.get("ItemID"));
				} else {
					itemIds += ", " + StringUtil.checkNull(temp.get("ItemID"));
				}

			}

			response.setCharacterEncoding("UTF-8"); // 한글깨짐현상 방지
			PrintWriter out = response.getWriter();
			out.append(itemIds);
			out.append("/");
			out.append(StringUtil.checkNull(bpInfoList.size(), "0"));
			out.flush();

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("MainDaelimActionController::mainpage::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/daelim/getLinkList.do")
	public String getLinkList(ModelMap model, HashMap cmmMap, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		try {
			String categoryCode = StringUtil.checkNull(request.getParameter("categoryCode"));
			String identifier = StringUtil.checkNull(request.getParameter("identifier"));
			String refTypeCode = StringUtil.checkNull(request.getParameter("refTypeCode"));

			model.put("categoryCode", categoryCode);
			model.put("identifier", identifier);
			model.put("refTypeCode", refTypeCode);

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("MainDaelimActionController::mainpage::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/custom/daelim/plant/LinkListPop");
	}

	@RequestMapping(value = "/zdaelim_jobCxnMgt.do")
	public String zdaelim_jobCxnMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/custom/daelim/plant/zdaelim_jobCxnMgt";
		try {
			String itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			String itemIDs = StringUtil.checkNull(request.getParameter("itemIDs"), "");
			String teamID = StringUtil.checkNull(request.getParameter("teamID"), "");
			String dpName = StringUtil.checkNull(request.getParameter("dpName"), "");

			Map setData = new HashMap();
			if (!"".equals(itemIDs)) {
				setData.put("itemIDs", itemIDs);
				model.put("itemIDs", itemIDs);

				String itemList = StringUtil
						.checkNull(commonService.selectString("custom_SQL.getItemSearchList", setData), "");
				setData.put("itemList", itemList);
			} else
				setData.put("itemIDs", "");

			if (!"".equals(dpName)) {
				setData.put("dpName", dpName);
				model.put("dpName", dpName);
			}

			setData.put("itemID", itemID);
			setData.put("teamID", teamID);
			setData.put("itemTypeCode", "CN00102");
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));

			List prcList = (List) commonService.selectList("custom_SQL.zdaelim_JobCXnList_gridList", setData);
			List itemDepList = (List) commonService.selectList("custom_SQL.getItemDepList", setData);

			model.put("prcTreeXml", makeProcessTreeXML(prcList));
			model.put("itemDepList", itemDepList);

			setData.put("s_itemID", request.getParameter("s_itemID"));
			Map itemInfoMap = commonService.select("project_SQL.getItemInfo", setData);

			model.put("selectedItemStatus", StringUtil.checkNull(itemInfoMap.get("Status")));
			model.put("selectedItemBlocked", StringUtil.checkNull(itemInfoMap.get("Blocked")));

			setData.put("s_itemID", itemID);
			Map itemAuthorMap = commonService.select("project_SQL.getItemAuthorIDAndLockOwner", setData);

			String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			setData.put("accessRight", "U");
			setData.put("userID", StringUtil.checkNull(cmmMap.get("sessionUserId")));
			String myItemMember = StringUtil
					.checkNull(commonService.selectString("item_SQL.getMyItemMemberID", setData));

			String itemBlocked = StringUtil.checkNull(itemAuthorMap.get("Blocked"));
			if (myItemMember.equals(sessionUserID) && !itemBlocked.equals("1")) {
				model.put("myItem", "Y");
			}

			setData.remove("s_itemID");
			List classList = commonService.selectList("item_SQL.getClassOption", setData);
			model.put("classOption", classList);

			/* 연관항목의 ItemTypeCode 취득 */
			String varFilter = StringUtil.checkNull(request.getParameter("varFilter")); // CN00102
			model.put("varFilter", varFilter);
			setData.put("varFilter", "CN00102");
			Map fromToItemMap = commonService.select("organization_SQL.getFromToItemTypeCode", setData);

			String fromItemTypeCode = StringUtil.checkNull(fromToItemMap.get("FromItemTypeCode"));
			String toItemTypeCode = StringUtil.checkNull(fromToItemMap.get("ToItemTypeCode"));

			String myItemTypeCode = StringUtil.checkNull(itemInfoMap.get("ItemTypeCode"));
			if (myItemTypeCode.equals(fromItemTypeCode)) {
				model.put("isFromItem", "Y");
				model.put("ItemTypeCode", toItemTypeCode);
			} else {
				model.put("isFromItem", "N");
				model.put("ItemTypeCode", fromItemTypeCode);
			}

			/* 기본정보 내용 취득 */
			setData.put("s_itemID", itemID);
			List itemInfo = commonService.selectList("report_SQL.getItemInfo", setData);

			setData.put("itemID", itemID);
			String parentItemID = StringUtil.checkNull(commonService.selectString("item_SQL.getParentItemID", setData));

			model.put("itemInfo", itemInfo);
			model.put("parentItemID", parentItemID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("itemID", itemID);
			model.put("option", request.getParameter("option"));
			model.put("filter", request.getParameter("filter"));
			model.put("CNItemTypeCode", "CN00102");
			model.put("fromModelYN", StringUtil.checkNull(cmmMap.get("fromModelYN"), ""));
		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("DaelimActionController::jobCxnMgt::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	private String makeProcessTreeXML(List prcListData) throws Exception {
		String CELL = "	<cell></cell>";
		String CELL_CHECK = "	<cell>0</cell>";
		String CELL_OPEN = "	<cell>";
		String CELL_CLOSE = "</cell>";
		String CLOSE = ">";
		String CELL_TOT = "";
		String ROW_OPEN = "<row id=";
		String ROW_CLOSE = "</row>";

		String result = "<rows>";
		String resultRow = "";
		int idx = 1;
		for (int i = 0; i < prcListData.size(); i++) {
			Map prcMap = (HashMap) prcListData.get(i);
			String itemID = StringUtil.checkNull(prcMap.get("ItemID"));
			String identifier = StringUtil.checkNull(prcMap.get("Identifier"));
			String itemName = StringUtil.checkNull(prcMap.get("ItemName"));
			String classCode = StringUtil.checkNull(prcMap.get("ClassCode"));
			String className = StringUtil.checkNull(prcMap.get("ClassName"));
			String classImg = "";
			String lastUpdated = StringUtil.checkNull(prcMap.get("LastUpdated"));

			if (classCode.equals("CL02002")) {
				resultRow += "<row id='" + itemID + "'>";
				resultRow += "<cell image='blank_s.gif'>" + itemName.replace("<", "(").replace(">", ")")
						.replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ")
						.replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ")
						+ CELL_CLOSE;
				resultRow += "		" + CELL_OPEN + className + CELL_CLOSE;
				resultRow += CELL; // Category
				resultRow += CELL; // BP
				resultRow += CELL; // L&L
				resultRow += CELL; // V&E
				resultRow += CELL; // 사내표준
				resultRow += CELL; // IT System
				resultRow += CELL; // 수정일
				resultRow += CELL;
				resultRow += CELL;
				resultRow += "		" + CELL_OPEN + classCode + CELL_CLOSE;
				resultRow += CELL;
				resultRow += CELL;
				resultRow += CELL;

				for (int j = 0; j < prcListData.size(); j++) {
					Map CL02003Map = (HashMap) prcListData.get(j);
					String CL02003ItemID = StringUtil.checkNull(CL02003Map.get("ItemID"));
					String CL02003Identifier = StringUtil.checkNull(CL02003Map.get("Identifier"));
					String CL02003ItemName = StringUtil.checkNull(CL02003Map.get("ItemName"));
					String CL02003ClassCode = StringUtil.checkNull(CL02003Map.get("ClassCode"));
					String CL02003ClassName = StringUtil.checkNull(CL02003Map.get("ClassName"));
					String CL02003ClassImg = "";
					String CL02003LastUpdated = StringUtil.checkNull(CL02003Map.get("LastUpdated"));
					String CL02003FromItemID = StringUtil.checkNull(CL02003Map.get("FromItemID"));

					if (itemID.equals(CL02003FromItemID)) {
						resultRow += "<row id='" + CL02003ItemID + "." + idx + "' open='1'>";
						resultRow += "<cell image='blank_s.gif'>" + CL02003ItemName.replace("<", "(").replace(">", ")")
								.replace(GlobalVal.ENCODING_STRING[3][1], " ")
								.replace(GlobalVal.ENCODING_STRING[3][0], " ")
								.replace(GlobalVal.ENCODING_STRING[4][1], " ")
								.replace(GlobalVal.ENCODING_STRING[4][0], " ") + CELL_CLOSE;
						resultRow += "		" + CELL_OPEN + CL02003ClassName + CELL_CLOSE;
						resultRow += CELL; // Category
						resultRow += CELL; // BP
						resultRow += CELL; // L&L
						resultRow += CELL; // V&E
						resultRow += CELL; // 사내표준
						resultRow += CELL; // IT System
						resultRow += CELL; // 첨부문서
						resultRow += CELL; // 수정일
						resultRow += CELL;
						resultRow += CELL;
						resultRow += "		" + CELL_OPEN + CL02003ClassCode + CELL_CLOSE;
						resultRow += CELL;
						resultRow += CELL;
						resultRow += CELL;

						for (int k = 0; k < prcListData.size(); k++) {
							Map CL02004Map = (HashMap) prcListData.get(k);
							String CL02004ItemID = StringUtil.checkNull(CL02004Map.get("ItemID"));
							String CL02004Identifier = StringUtil.checkNull(CL02004Map.get("Identifier"));
							String CL02004ItemName = StringUtil.checkNull(CL02004Map.get("ItemName"));
							String CL02004ClassCode = StringUtil.checkNull(CL02004Map.get("ClassCode"));
							String CL02004ClassName = StringUtil.checkNull(CL02004Map.get("ClassName"));
							String CL02004ClassImg = "";
							String CL02004LastUpdated = StringUtil.checkNull(CL02004Map.get("LastUpdated"));
							String CL02004FromItemID = StringUtil.checkNull(CL02004Map.get("FromItemID"));

							if (CL02003ItemID.equals(CL02004FromItemID)) {
								resultRow += "<row id='" + CL02004ItemID + "." + idx + "' open='1'>";
								resultRow += "<cell image='blank_s.gif'>" + CL02004ItemName.replace("<", "(")
										.replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ")
										.replace(GlobalVal.ENCODING_STRING[3][0], " ")
										.replace(GlobalVal.ENCODING_STRING[4][1], " ")
										.replace(GlobalVal.ENCODING_STRING[4][0], " ") + CELL_CLOSE;
								resultRow += "		" + CELL_OPEN + CL02004ClassName + CELL_CLOSE;
								resultRow += CELL; // Category
								resultRow += CELL; // BP
								resultRow += CELL; // L&L
								resultRow += CELL; // V&E
								resultRow += CELL; // 사내표준
								resultRow += CELL; // IT System
								resultRow += CELL; // 첨부문서
								resultRow += CELL; // 수정일
								resultRow += CELL;
								resultRow += CELL;
								resultRow += "		" + CELL_OPEN + CL02004ClassCode + CELL_CLOSE;
								resultRow += CELL;
								resultRow += CELL;
								resultRow += CELL;

								for (int m = 0; m < prcListData.size(); m++) {
									Map CL02005Map = (HashMap) prcListData.get(m);

									String CL02005ItemID = StringUtil.checkNull(CL02005Map.get("ItemID"));
									String CL02005Identifier = StringUtil.checkNull(CL02005Map.get("Identifier"));
									String CL02005ItemName = StringUtil.checkNull(CL02005Map.get("ItemName"));
									String CL02005ClassCode = StringUtil.checkNull(CL02005Map.get("ClassCode"));
									String CL02005ClassName = StringUtil.checkNull(CL02005Map.get("ClassName"));
									String CL02005ClassImg = "";
									String CL02005LastUpdated = StringUtil.checkNull(CL02005Map.get("LastUpdated"));
									String CL02005FromItemID = StringUtil.checkNull(CL02005Map.get("FromItemID"));
									String Category = StringUtil.checkNull(CL02005Map.get("Category"));
									String AuthorID = StringUtil.checkNull(CL02005Map.get("AuthorID"));
									String CNItemID = StringUtil.checkNull(CL02005Map.get("CNItemID"));
									String CategoryCode = StringUtil.checkNull(CL02005Map.get("CategoryCode"));
									String LLC = StringUtil.checkNull(CL02005Map.get("LnLCnt"));
									String VEC = StringUtil.checkNull(CL02005Map.get("VnECnt"));
									String SPC = StringUtil.checkNull(CL02005Map.get("IHSCnt"));
									String CJC = StringUtil.checkNull(CL02005Map.get("RMCnt"));
									String ITC = StringUtil.checkNull(CL02005Map.get("ITCnt"));

									if (CL02004ItemID.equals(CL02005FromItemID)) {
										resultRow += "<row id='" + CL02005ItemID + "." + idx + "' open='1'>";
										idx++;
										resultRow += "<cell image='blank_s.gif'>" + CL02005ItemName.replace("<", "(")
												.replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ")
												.replace(GlobalVal.ENCODING_STRING[3][0], " ")
												.replace(GlobalVal.ENCODING_STRING[4][1], " ")
												.replace(GlobalVal.ENCODING_STRING[4][0], " ") + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN + CL02005ClassName + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN + Category + CELL_CLOSE; // Category

										if (!"".equals(Category)) {
											resultRow += "<cell type='ro'><![CDATA[<img src='" + GlobalVal.HTML_IMG_DIR
													+ "icon_link.png' />]]>" + CELL_CLOSE; // BP

											if (!"0".equals(LLC)) {
												resultRow += "<cell type='ro'><![CDATA[<img src='"
														+ GlobalVal.HTML_IMG_DIR + "icon_link.png' />]]>" + CELL_CLOSE;
											} else
												resultRow += CELL;

											if (!"0".equals(VEC)) {
												resultRow += "<cell type='ro'><![CDATA[<img src='"
														+ GlobalVal.HTML_IMG_DIR + "icon_link.png' />]]>" + CELL_CLOSE;
											} else
												resultRow += CELL;

											if (!"0".equals(SPC)) {
												resultRow += "<cell type='ro'><![CDATA[<img src='"
														+ GlobalVal.HTML_IMG_DIR + "icon_link.png' />]]>" + CELL_CLOSE;
											} else
												resultRow += CELL;

											if (!"0".equals(CJC)) {
												resultRow += "<cell type='ro'><![CDATA[<img src='"
														+ GlobalVal.HTML_IMG_DIR + "icon_link.png' />]]>" + CELL_CLOSE;
											} else
												resultRow += CELL;

											if (!"0".equals(ITC)) {
												resultRow += "<cell type='ro'><![CDATA[<img src='"
														+ GlobalVal.HTML_IMG_DIR + "icon_link.png' />]]>" + CELL_CLOSE;
											} else
												resultRow += CELL;

										} else {
											resultRow += CELL; // BP
											resultRow += CELL; // LL
											resultRow += CELL; // VE
											resultRow += CELL; // 사내표준
											resultRow += CELL; // 첨부문서
											resultRow += CELL; // IT System
										}

										resultRow += "		" + CELL_OPEN + CL02005LastUpdated + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN + CL02005ItemID + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN + CL02005Identifier + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN + CL02005ClassCode + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN + AuthorID + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN + CNItemID + CELL_CLOSE;
										resultRow += "		" + CELL_OPEN + CategoryCode + CELL_CLOSE;
										resultRow += ROW_CLOSE;
									}
								}
								resultRow += ROW_CLOSE;
							}
						}
						resultRow += ROW_CLOSE;
					}
				}
				resultRow += ROW_CLOSE;
			}
		}
		result += resultRow;
		result += "</rows>";
		// System.out.println(result);
		return result.replace("&", "/");
	}

	@RequestMapping(value = "/zdaelim_checkDuplicatedItem.do")
	public String zdaelim_checkDuplicatedItem(HttpServletRequest request, HashMap cmmMap, ModelMap model)
			throws Exception {
		try {
			Map setMap = new HashMap();
			Map resultMap = new HashMap();

			String cnItemTypeCode = StringUtil.checkNull(cmmMap.get("varFilter"));
			String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));
			String myCnType = StringUtil.checkNull(cmmMap.get("connectionType"));
			String varFilter = StringUtil.checkNull(cmmMap.get("varFilter"));

			if (myCnType.equals("From")) {
				setMap.put("ToItemID", s_itemID);
			} else {
				setMap.put("FromItemID", s_itemID);
			}
			Map setData = new HashMap();
			setData.put("arcCode", "AR000000");
			setData.put("itemTypeCode", "OJ00002");
			setData.put("sessionUserID", StringUtil.checkNull(cmmMap.get("sessionUserId")));
			setData.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			setData.put("selectedTreeItemID", s_itemID);

			List<Map> result = commonService.selectList("custom_SQL.zdaelim_JobAssign_treeList", setData);

			String disableIDs = "";

			if (result.size() > 0) {
				String getClassCode = "";
				for (int i = 0; result.size() > i; i++) {
					Map map = (Map) result.get(i);
					String itemID = StringUtil.checkNull(map.get("TREE_ID"));
					getClassCode = StringUtil.checkNull(map.get("ClassCode"), "");
					if (!varFilter.equals(getClassCode)) {
						if (disableIDs.equals("")) {
							disableIDs = itemID;
						} else {
							disableIDs = disableIDs + "," + itemID;
						}
					}
				}
			}
			resultMap.put(AJAX_SCRIPT, "fnSetDisableCheckBoxIDs('" + disableIDs + "')");
			model.addAttribute(AJAX_RESULTMAP, resultMap);
		} catch (Exception e) {
			System.out.println(e.toString());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/daelim/plant/zdaelim_jobAssignTreePop.do")
	public String zdaelim_jobAssignTreePop(ModelMap model, HashMap cmmMap, HttpServletRequest request)
			throws Exception {
		try {
			String selectedTreeItemID = StringUtil.checkNull(request.getParameter("selectedTreeItemID"), "");
			String option = StringUtil.checkNull(request.getParameter("option"), "");

			String btnName = "Assign";
			String btnStyle = "assign";

			model.put("selectedTreeItemID", selectedTreeItemID);
			model.put("items", StringUtil.checkNull(request.getParameter("items"), ""));
			model.put("checkType", StringUtil.checkNull(request.getParameter("checkType"), ""));
			model.put("option", option);
			model.put("openMode", StringUtil.checkNull(request.getParameter("openMode"), ""));
			model.put("varFilter", StringUtil.checkNull(request.getParameter("varFilter"), ""));
			model.put("connectionType", StringUtil.checkNull(request.getParameter("connectionType"), ""));
			model.put("btnName", btnName);
			model.put("btnStyle", btnStyle);
			model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
			model.put("projectID", StringUtil.checkNull(request.getParameter("projectID")));

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("DaelimActionController::zdaelim_jobAssignTreePop::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/daelim/plant/zdaelim_jobAssignTreePop");
	}

	@RequestMapping(value = "/zdaelim_jsonDhtmlxTreeList.do")
	public void zdaelim_doJsonDhtmlxTreeList(HashMap cmmMap, HttpServletResponse response, HttpServletRequest request)
			throws Exception {
		/* 해당 프로젝트 ID 설정 */
		Map projectInfoMap = new HashMap();
		String sessionTmplCode = StringUtil.checkNull(cmmMap.get("sessionTemplCode"));
		String projectID = "";
		if (sessionTmplCode.equals("TMPL003")) {
			projectID = StringUtil.checkNull(cmmMap.get("projectID"));
			cmmMap.put("projectID", projectID);
		} else {
			projectInfoMap = commonService.select("main_SQL.getPjtInfoFromTEMPL", cmmMap);
			cmmMap.put("projectID", projectInfoMap.get("ProjectID"));
		}

		Map setData = new HashMap();
		setData.put("arcCode", "AR000000");
		setData.put("itemTypeCode", "OJ00002");
		setData.put("sessionUserID", StringUtil.checkNull(cmmMap.get("sessionUserId")));
		setData.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
		setData.put("selectedTreeItemID", StringUtil.checkNull(cmmMap.get("selectedTreeItemID")));

		List<Map> result = commonService.selectList("custom_SQL.zdaelim_JobAssign_treeList", setData);

		String[] cols = ((String) cmmMap.get("cols")).split("[|]");

		JsonUtil.returnTreeJson(result, cols, response, (String) cmmMap.get("contextPath"));
	}

	@RequestMapping(value = "/checkToItems.do")
	public String checkToItems(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			String selectedTreeItemID = StringUtil.checkNull(request.getParameter("selectedTreeItemID"), "");
			String[] arrayStr = StringUtil.checkNull(request.getParameter("assignItems"), "").split(",");
			Map setData = new HashMap();
			int cnt = 0;
			if (arrayStr != null) {
				for (int i = 0; i < arrayStr.length; i++) {
					String itemID = StringUtil.checkNull(arrayStr[i], "");
					setData.put("itemID", itemID);
					setData.put("itemTypeCode", "CN00212");

					String toItemCnt = StringUtil
							.checkNull(commonService.selectString("custom_SQL.getToItemIDCount", setData));
					if (Integer.parseInt(toItemCnt) > 1) {
						cnt++;
					}
				}
			}

			// System.out.println("cnt :"+cnt);
			target.put(AJAX_SCRIPT, "this.fnUpdateCategory('" + cnt + "');");

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("DaelimActionController::checkToItems::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/daelim/plant/zdaelim_jobAssignPop.do")
	public String zdaelim_jobAssignPop(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {
			String selectedTreeItemID = StringUtil.checkNull(request.getParameter("selectedTreeItemID"), "");
			String arrStr[] = StringUtil.checkNull(request.getParameter("assignItems"), "").split(",");

			String itemID = "";
			Map assignItemMap = new HashMap();
			Map assignItemDefaultMap = new HashMap();
			List assignItemList = new ArrayList();
			List assignItemDefaultList = new ArrayList();
			List toItemList = new ArrayList();
			Map setData = new HashMap();
			String assignItemName = "";
			int idx = 0;
			int idx2 = 0;
			if (arrStr != null) {
				for (int i = 0; i < arrStr.length; i++) {
					assignItemMap = new HashMap();
					assignItemDefaultMap = new HashMap();
					setData.put("itemID", StringUtil.checkNull(arrStr[i], ""));
					setData.put("itemTypeCode", "CN00212");
					setData.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
					toItemList = commonService.selectList("custom_SQL.getToItemIDList", setData);
					setData.put("s_itemID", StringUtil.checkNull(arrStr[i], ""));
					assignItemName = StringUtil.checkNull(commonService.selectString("item_SQL.getItemPath", setData));
					if (toItemList.size() > 1) {
						assignItemMap.put("toItemList", toItemList);
						assignItemMap.put("assignItemName", assignItemName);
						assignItemMap.put("itemID", StringUtil.checkNull(arrStr[i], ""));
						assignItemMap.put("identifier",
								commonService.selectString("item_SQL.s_itemIDentifier", assignItemMap));

						assignItemList.add(idx, assignItemMap); // System.out.println("idx :"+idx);
						idx++;
					} else {
						Map toItemMap = (Map) toItemList.get(0);
						assignItemDefaultMap.put("assignItemDefaultName", assignItemName);
						assignItemDefaultMap.put("itemID", StringUtil.checkNull(arrStr[i], ""));
						assignItemDefaultMap.put("identifier",
								commonService.selectString("item_SQL.s_itemIDentifier", assignItemDefaultMap));
						assignItemDefaultMap.put("toIdentifier", toItemMap.get("Identifier"));
						assignItemDefaultMap.put("toItemName", toItemMap.get("ToItemName"));
						assignItemDefaultList.add(idx2, assignItemDefaultMap);
						idx2++;
					}
				}
			}
			// System.out.println(" assignItemList :"+assignItemList);
			// System.out.println(" assignItemDefaultList :"+assignItemDefaultList);

			model.put("selectedTreeItemID", selectedTreeItemID);
			model.put("assignItemList", assignItemList);
			model.put("assignItemDefaultList", assignItemDefaultList);
			model.put("assignCNT", assignItemList.size());
			model.put("assignDefaultCNT", assignItemDefaultList.size());
			model.put("selectedTreeItemID", selectedTreeItemID);
			model.put("assignItems", StringUtil.checkNull(request.getParameter("assignItems"), ""));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("DaelimActionController::zdaelim_jobAssignTreePop::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/daelim/plant/zdaelim_jobAssignPop");
	}

	@RequestMapping(value = "/daelim/plant/zdaelim_assignJob.do")
	public String zdaelim_assignJob(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map setData = new HashMap();
			String selectedTreeItemID = StringUtil.checkNull(request.getParameter("selectedTreeItemID"), "");
			int assignCNT = Integer.parseInt(StringUtil.checkNull(request.getParameter("assignCNT"), ""));
			int assignDefaultCNT = Integer.parseInt(StringUtil.checkNull(request.getParameter("assignDefaultCNT"), ""));
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", cmmMap);

			String assignItemID = "";
			String toIdentifier = "";
			String CNItemID = "";
			// System.out.println("assignDefaultCNT ;"+assignDefaultCNT);
			if (assignCNT > 0) {
				for (int i = 0; i < assignCNT; i++) {
					assignItemID = StringUtil.checkNull(request.getParameter("itemID_" + i), "");
					toIdentifier = StringUtil.checkNull(request.getParameter("toIdentifier_" + i), "");
					// System.out.println("assignItemID :"+assignItemID+" , toIdentifier :
					// "+toIdentifier+",selectedTreeItemID :"+selectedTreeItemID);
					// 커넥션 아이테 찾아서 속성 LOV 저장
					setData.put("fromItemID", selectedTreeItemID);
					setData.put("toItemID", assignItemID);
					setData.put("itemTypeCode", "CN00102");
					CNItemID = commonService.selectString("custom_SQL.getCNItemID", setData);

					Map delData = new HashMap();
					delData.put("ItemID", CNItemID);
					delData.put("AttrTypeCode", "AT00005");
					commonService.delete("attr_SQL.delItemAttr", delData);

					Map insertData = new HashMap();
					insertData.put("PlainText", toIdentifier);
					insertData.put("ItemID", CNItemID);
					insertData.put("languageID", defaultLang);
					insertData.put("itemID", CNItemID);
					insertData.put("ClassCode", commonService.selectString("item_SQL.getClassCode", insertData));
					insertData.put("ItemTypeCode", "CN00102");
					insertData.put("LovCode", toIdentifier);
					insertData.put("dataType", "LOV");
					insertData.put("AttrTypeCode", "AT00005");
					GetItemAttrList.attrUpdate(commonService, insertData);
				}
			}

			String assignDfItemID = "";
			String dfToIdentifier = "";
			if (assignDefaultCNT > 0) {
				for (int i = 0; i < assignDefaultCNT; i++) {
					assignDfItemID = StringUtil.checkNull(request.getParameter("dfItemID_" + i), "");
					dfToIdentifier = StringUtil.checkNull(request.getParameter("dfToIdentifier_" + i), "");
					// System.out.println("assignDfItemID :"+assignDfItemID+" , dfToIdentifier :
					// "+dfToIdentifier);
					// 커넥션 아이테 찾아서 속성 LOV 저장
					setData.put("fromItemID", selectedTreeItemID);
					setData.put("toItemID", assignDfItemID);
					setData.put("itemTypeCode", "CN00102");
					CNItemID = commonService.selectString("custom_SQL.getCNItemID", setData);

					Map delData = new HashMap();
					delData.put("ItemID", CNItemID);
					delData.put("AttrTypeCode", "AT00005");
					commonService.delete("attr_SQL.delItemAttr", delData);

					Map insertData = new HashMap();
					insertData.put("PlainText", dfToIdentifier);
					insertData.put("ItemID", CNItemID);
					insertData.put("languageID", defaultLang);
					insertData.put("itemID", CNItemID);
					insertData.put("ClassCode", commonService.selectString("item_SQL.getClassCode", insertData));
					insertData.put("ItemTypeCode", "CN00102");
					insertData.put("LovCode", dfToIdentifier);
					insertData.put("dataType", "LOV");
					insertData.put("AttrTypeCode", "AT00005");
					GetItemAttrList.attrUpdate(commonService, insertData);
				}
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBack();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("DaelimActionController::zdaelim_assignJob::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/daelim/plant/zdaelim_assignJobDf.do")
	public String zdaelim_assignJobDf(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map setData = new HashMap();
			String selectedTreeItemID = StringUtil.checkNull(request.getParameter("selectedTreeItemID"), "");
			String arrStr[] = StringUtil.checkNull(request.getParameter("assignItems"), "").split(",");
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", cmmMap);

			String assignItemID = "";
			String toIdentifier = "";
			String CNItemID = "";
			if (arrStr.length > 0) {
				for (int i = 0; i < arrStr.length; i++) {
					setData = new HashMap();
					assignItemID = StringUtil.checkNull(arrStr[i]);
					setData.put("itemID", assignItemID);
					toIdentifier = commonService.selectString("item_SQL.getToIdentifier", setData);

					// System.out.println("assignItemID :"+assignItemID+" , toIdentifier :
					// "+toIdentifier);

					setData.put("fromItemID", selectedTreeItemID);
					setData.put("toItemID", assignItemID);
					setData.put("itemTypeCode", "CN00102");
					CNItemID = commonService.selectString("custom_SQL.getCNItemID", setData);

					Map delData = new HashMap();
					delData.put("ItemID", CNItemID);
					delData.put("AttrTypeCode", "AT00005");
					commonService.delete("attr_SQL.delItemAttr", delData);

					Map insertData = new HashMap();
					insertData.put("PlainText", toIdentifier);
					insertData.put("ItemID", CNItemID);
					insertData.put("languageID", defaultLang);
					insertData.put("itemID", CNItemID);
					insertData.put("ClassCode", commonService.selectString("item_SQL.getClassCode", insertData));
					insertData.put("ItemTypeCode", "CN00102");
					insertData.put("LovCode", toIdentifier);
					insertData.put("dataType", "LOV");
					insertData.put("AttrTypeCode", "AT00005");
					GetItemAttrList.attrUpdate(commonService, insertData);
				}
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "urlReload();");

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("DaelimActionController::zdaelim_assignJobDf::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/daelim/plant/zdaelim_jobDelPop.do")
	public String zdaelim_jobDelPop(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {
			String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
			String option = StringUtil.checkNull(request.getParameter("option"), "");

			String btnName = "Assign";
			String btnStyle = "assign";

			model.put("itemID", itemID);
			model.put("checkType", StringUtil.checkNull(request.getParameter("checkType"), ""));
			model.put("option", option);
			model.put("openMode", StringUtil.checkNull(request.getParameter("openMode"), ""));
			model.put("varFilter", StringUtil.checkNull(request.getParameter("varFilter"), ""));
			model.put("connectionType", StringUtil.checkNull(request.getParameter("connectionType"), ""));
			model.put("btnName", btnName);
			model.put("btnStyle", btnStyle);
			model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
			model.put("projectID", StringUtil.checkNull(request.getParameter("projectID")));

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("DaelimActionController::zdaelim_jobAssignTreePop::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/daelim/plant/zdaelim_jobDelPop");
	}

	@RequestMapping(value = "/daelim/plant/zdaelim_jobConnectionDel.do")
	public String zdaelim_jobConnectionDel(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		HashMap target = new HashMap();
		try {
			List getValue = new ArrayList();
			Map setMap = new HashMap();

			String[] itemIDs = StringUtil.checkNull(request.getParameter("itemIDs")).split(",");

			for (int i = 0; itemIDs.length > i; i++) {
				setMap.put("itemID", itemIDs[i]);

				commonService.delete("custom_SQL.zdaelim_delConnection", setMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제
																													// 성공
			target.put(AJAX_SCRIPT, "urlReload();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제
																													// 오류
																													// 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);

	}

	@RequestMapping(value = "/daelim/goBPListPop.do")
	public String goBPListPop(ModelMap model, HashMap cmmMap, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		try {
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));

			model.put("itemIDs", itemID);

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("MainDaelimActionController::mainpage::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/custom/daelim/plant/bpListPop");
	}

	@RequestMapping(value = "/daelim/plant/updateJobCxnCategory.do")
	public String updateJobCxnCategory(ModelMap model, HashMap cmmMap, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		HashMap target = new HashMap();
		try {
			List getValue = new ArrayList();
			Map setMap = new HashMap();
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			String lovCode = StringUtil.checkNull(request.getParameter("lovCode"));

			setMap.put("itemID", itemID);
			setMap.put("lovCode", lovCode);
			setMap.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));

			commonService.update("custom_SQL.zdaelim_UpdateCategoryInfo", setMap);

			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 삭제 성공
			target.put(AJAX_SCRIPT, "fnUrlReload()");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류
																												// 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
	}

	// 므로세스 모델 속성 수정 팝업
	@RequestMapping(value = "/daelim/plant/editJobCxnCategoryPop.do")
	public String editJobCxnCategoryPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			List returnData = new ArrayList();
			HashMap setMap = new HashMap();

			String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
			String cnItemID = StringUtil.checkNull(request.getParameter("cnItemID"), "");

			model.put("itemID", itemID);
			model.put("cnItemID", cnItemID);
			model.put("menu", getLabel(request, commonService));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/custom/daelim/plant/editJobCxnCategoryPop");
	}

	@RequestMapping(value = "/daelim/runVnEPopup.do")
	public String runVnEPopup(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {
			String url = StringUtil.checkNull(request.getParameter("url"));
			String parameter = StringUtil.checkNull(request.getParameter("parameter"));

			Rfc2898DeriveBytes rfcbyte = new Rfc2898DeriveBytes();
			url = url + rfcbyte.getEncryptBase64(parameter);
			model.put("url", url);

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("MainDaelimActionController::mainpage::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("custom/daelim/plant/runBPPopup");
	}

	@RequestMapping(value = "/getItemIDFromGloPjtID.do")
	public String getItemIDFromGloPjtID(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map setData = new HashMap();
			String gloProjectID = StringUtil.checkNull(request.getParameter("gloProjectID"), "");

			Map pjtInfoMap = new HashMap();
			String itemID = "";
			if (!gloProjectID.equals("") && !gloProjectID.equals("undefind")) {
				setData.put("projectCode", gloProjectID);
				pjtInfoMap = commonService.select("variant_SQL.getPJTInfos", setData);

				if (pjtInfoMap != null) {
					setData.put("refPGID", StringUtil.checkNull(pjtInfoMap.get("RefPGID")));
					String arcCode = StringUtil
							.checkNull(commonService.selectString("variant_SQL.getDefArcCode", setData));

					setData.put("projectID", StringUtil.checkNull(pjtInfoMap.get("ProjectID")));
					itemID = StringUtil.checkNull(commonService.selectString("variant_SQL.getDefVariantID", setData));
					model.put("itemID", itemID);
				}
			}

			target.put(AJAX_SCRIPT, "parent.fnOpenItemPop('" + itemID + "');");

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("DaelimActionController::getItemIDFromGloPjtID::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/daelim/plant/updateProjectMember.do")
	public String updateProjectMember(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map setData = new HashMap();
			Map tempMap = new HashMap();
			String MemberID = "";
			String userList = StringUtil.checkNull(request.getParameter("userList"), "");

			String[] listTemp = userList.split(",");

			for (int i = 0; i < listTemp.length; i++) {
				String[] projectList = listTemp[i].split("\\|");
				setData.put("employeeNum", projectList[0]);
				MemberID = StringUtil.checkNull(
						commonService.selectString("custom_SQL.zdaelim_getMemberIDFromEmployeeNum", setData), "");
				if (!"".equals(MemberID)) {
					for (int j = 1; j < projectList.length; j++) {
						setData.put("projectCode", projectList[j]);
						tempMap = commonService.select("variant_SQL.getPJTInfos", setData);

						if (tempMap != null && !tempMap.isEmpty()) {
							setData = new HashMap();
							setData.put("memberID", MemberID);
							setData.put("ProjectID", tempMap.get("ProjectID"));
							commonService.insert("custom_SQL.zdaelim_updateProjectMember", setData);
						}

					}
				}
			}

			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("DaelimActionController::getItemIDFromGloPjtID::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/daelim/plant/regECSPjtMember.do")
	public String regECSPjtMmeber(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {

			String userList = StringUtil
					.checkNull(commonService.selectString("project_SQL.getUserListTypeString", cmmMap));
			model.put("userList", userList);

		} catch (Exception e) {
			if (_log.isInfoEnabled()) {
				_log.info("MainDaelimActionController::mainpage::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("custom/daelim/plant/RegECSPjtMember");
	}

	@RequestMapping(value = "/zDlmBIMAutoMail.do")
	public void zDlmBIMAutoMail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		String language = StringUtil.checkNull(cmmMap.get("language"), "");
		if (language.equals("")) {
			language = GlobalVal.DEFAULT_LANGUAGE;
		}

		try {
			DLMWebServiceProxy WebServiceProxy = new DLMWebServiceProxy();

			String procInstNo, elmInstNo, elmStatus, roleID, procProcessName, procInstName, elmInstName, elmProcessName,
					roleItemID, roleItemName, pimWorker = "", schStartDate, team, docItemNM, docItemNo, documentNo = "";
			String returnEnsembleUserData, memberID, procOwnerID = "";

			Map getMemberInfoMap = new HashMap();

			HashMap setMap = new HashMap();
			Map setMailData = new HashMap();
			Map setMailMapRst = new HashMap();
			Map itemBatchtempMap = new HashMap();
			Map receiverMap = new HashMap();
			List receiverList = new ArrayList();
			List pimWorkerList = new ArrayList();
			Map pimWorkerMap = new HashMap();

			HttpSession session = request.getSession(true);
			if (session.getAttribute("loginInfo") == null) {
				setMap.put("LOGIN_ID", "sys");
				setMap.put("IS_CHECK", "N");
				setMap.put("LANGUAGE", language);
				Map loginInfo = commonService.select("login_SQL.login_select", setMap);
				session.setAttribute("loginInfo", loginInfo);
			}

			setMap = new HashMap();
			setMap.put("languageID", language);
			List itemBatchMailList = commonService.selectList("instance_SQL.getElmInstBatchMailList", setMap);

			for (int i = 0; i < itemBatchMailList.size(); i++) {
				setMap = new HashMap();
				setMailData = new HashMap();
				receiverMap = new HashMap();
				receiverList = new ArrayList();
				pimWorker = "";
				itemBatchtempMap = (Map) itemBatchMailList.get(i);

				procInstNo = StringUtil.checkNull(itemBatchtempMap.get("procInstNo"));
				elmInstNo = StringUtil.checkNull(itemBatchtempMap.get("elmInstNo"));
				procProcessName = StringUtil.checkNull(itemBatchtempMap.get("procProcessName"));
				procInstName = StringUtil.checkNull(itemBatchtempMap.get("procInstName"));
				elmInstName = StringUtil.checkNull(itemBatchtempMap.get("elmInstName"));
				elmProcessName = StringUtil.checkNull(itemBatchtempMap.get("elmProcessName"));
				roleItemID = StringUtil.checkNull(itemBatchtempMap.get("roleItemID"));
				roleItemName = StringUtil.checkNull(itemBatchtempMap.get("roleItemName"));
				schStartDate = StringUtil.checkNull(itemBatchtempMap.get("schStartDate"));
				docItemNM = StringUtil.checkNull(itemBatchtempMap.get("docItemNM"));
				documentNo = StringUtil.checkNull(itemBatchtempMap.get("documentNo"));
				team = StringUtil.checkNull(itemBatchtempMap.get("parentRoleCode"));
				roleID = StringUtil.checkNull(itemBatchtempMap.get("roleCode"));
				procOwnerID = StringUtil.checkNull(itemBatchtempMap.get("OwnerID"));
				elmStatus = StringUtil.checkNull(itemBatchtempMap.get("elmStatus"));
				docItemNo = StringUtil.checkNull(itemBatchtempMap.get("docItemNo"));

				setMap.put("procInstNo", procInstNo);
				setMap.put("elmInstNo", elmInstNo);
				if (elmStatus.equals("WAT")) {
					commonService.delete("worker_SQL.deletePimWorker", setMap);
					returnEnsembleUserData = WebServiceProxy.getEnsembleUserList(docItemNM, documentNo, team, roleID);
					//returnEnsembleUserData = WebServiceProxy.getEnsembleUserList("Project","130351", "ELEC", "LE");
					//returnEnsembleUserData = "IEP001,H2018015,H2018016";
					System.out.println("itemBatchMail-returnEnsembleUserData---" + returnEnsembleUserData);

					String EmployeeNum[] = returnEnsembleUserData.split(",");
					memberID = "";
					for (int k = 0; k < EmployeeNum.length; k++) {
						setMap.put("employeeNum", EmployeeNum[k]);
						memberID = commonService.selectString("user_SQL.getMemberIDFromEmpNO", setMap);

						if (memberID != "" && memberID != null) {
							setMap = new HashMap();

							setMap.put("memberID", memberID);
							getMemberInfoMap = new HashMap();
							getMemberInfoMap = commonService.select("user_SQL.getMemberInfo", setMap);

							if (getMemberInfoMap != null) {
								setMap.put("workerNo", NextWokerNo());
								setMap.put("memberID", memberID);
								setMap.put("workerTeamID", getMemberInfoMap.get("TeamID"));
								setMap.put("procInstNo", procInstNo);
								setMap.put("elmInstNo", elmInstNo);
								setMap.put("roleID", roleItemID);
								setMap.put("status", 1);
								setMap.put("Creator", 1);
								setMap.put("LastUser", 1);
								commonService.insert("worker_SQL.createPimWorker", setMap);
							}
						}
					}
				}

				pimWorkerList = commonService.selectList("worker_SQL.getPimWorkerList", setMap);
				if(pimWorkerList.size()>0){
					for (int w = 0; w < pimWorkerList.size(); w++) {
						pimWorkerMap = (Map) pimWorkerList.get(w);

						pimWorker += StringUtil.checkNull(pimWorkerMap.get("memberName")) + "("
								+ StringUtil.checkNull(pimWorkerMap.get("teamName")) + ")";
						if (pimWorkerList.size() != 1 && w != pimWorkerList.size() - 1) {
							pimWorker += ",";
						}
						receiverMap.put("receiptUserID", pimWorkerMap.get("memberID"));
						receiverMap.put("receiptType", "TO");
						receiverList.add(w, receiverMap);
						receiverMap = new HashMap();
					}
					
					// ProcInst Owner 참조 추가
					receiverMap.put("receiptUserID", procOwnerID);
					receiverMap.put("receiptType", "CC");
					receiverList.add(pimWorkerList.size(), receiverMap);

					setMap = new HashMap();
					setMap.put("procInstNo", procInstNo);
					setMap.put("elmInstNo", elmInstNo);
					setMap.put("procProcessName", procProcessName);
					setMap.put("procInstName", procInstName);
					setMap.put("elmInstName", elmInstName);
					setMap.put("elmProcessName", elmProcessName);
					setMap.put("roleItemID", roleItemID);
					setMap.put("roleItemName", roleItemName);
					setMap.put("pimWorker", pimWorker);
					setMap.put("schStartDate", schStartDate);
					setMap.put("docItemNM", docItemNM);
					setMap.put("documentNo", documentNo);
					setMap.put("team", team);
					setMap.put("roleID", roleID);
					setMap.put("subject", procProcessName + " " + elmProcessName);
					setMap.put("docItemNo", docItemNo);

					setMailData.put("language", language);
					setMailData.put("receiverList", receiverList);
					setMailData.put("subject", elmProcessName);
					setMailMapRst = (Map) setEmailLog(request, commonService, setMailData, "PIMEM001");
					if (StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")) {
						HashMap mailMap = (HashMap) setMailMapRst.get("mailLog");

						setMap.put("languageID", language);
						setMap.put("emailCode", "PIMEM001");
						String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", setMap));
						setMap.put("emailHTMLForm", emailHTMLForm);

						Map resultMailMap = EmailUtil.sendMail(mailMap, setMap, getLabel(request, commonService));
						System.out.println("SEND EMAIL TYPE:" + resultMailMap + ", Msg:"
								+ StringUtil.checkNull(setMailMapRst.get("type")));

						commonService.update("instance_SQL.updatePimElmAlarmDate", setMap);

					} else {
						System.out.println(
								"SAVE EMAIL_LOG FAILE/DONT Msg : " + StringUtil.checkNull(setMailMapRst.get("msg")));
					}
				}
			}
			session = null;
			System.out.println("itemBatchMail complete");
		} catch (Exception e) {
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00089")); // 오류 발생
			if (_log.isInfoEnabled()) {
				_log.info("DaelimActionController::zDlmBIMAutoMail::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
	}

	@RequestMapping(value = "/daelim/plant/batchGetEnsembleUser.do")
	public void batchGetEnsembleUser(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		System.out.println("batchGetEnsembleUser execute");
		HashMap target = new HashMap();
		HashMap setinstanceMap = new HashMap();
		HashMap setMap = new HashMap();
		String language = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"), "");
		String procInstNo, elmInstNo, elmItemID, elmStatus, roleID, procProcessName, procInstName, elmInstName,
				elmProcessName, roleItemID, roleItemName, team, docItemNM, documentNo = "";
		String returnEnsembleUserData = "", memberID = "";
		Map getMemberInfoMap = new HashMap();
		Map procInstInfo = new HashMap();
		Map elmInstMap = new HashMap();
		List elmInstList = new ArrayList();

		try {
			DLMWebServiceProxy WebServiceProxy = new DLMWebServiceProxy();

			setinstanceMap.put("languageID", language);
			setinstanceMap.put("status", "OPN");
			List procInstList = commonService.selectList("instance_SQL.getProcInstanceInfo", setinstanceMap);
			for (int j = 0; j < procInstList.size(); j++) {
				procInstInfo = (Map) procInstList.get(j);

				// *** getProcInst -> DocumentNo(projectCode = jobNo)
				procInstNo = StringUtil.checkNull(procInstInfo.get("ProcInstNo"));
				docItemNM = StringUtil.checkNull(procInstInfo.get("docItemNM"));
				documentNo = StringUtil.checkNull(procInstInfo.get("DocumentNo"));

				setinstanceMap.put("instanceNo", procInstNo);
				elmInstList = commonService.selectList("instance_SQL.getElmInstList_gridList", setinstanceMap);

				for (int k = 0; k < elmInstList.size(); k++) {
					setMap = new HashMap();
					elmInstMap = (Map) elmInstList.get(k);

					// *** getElmInst -> RoleID, teamItemID -> role,team
					elmInstNo = StringUtil.checkNull(elmInstMap.get("ElmInstNo"));
					roleItemID = StringUtil.checkNull(elmInstMap.get("RoleID"));
					roleID = StringUtil.checkNull(elmInstMap.get("roleCode"));
					team = StringUtil.checkNull(elmInstMap.get("parentRoleCode"));
					elmItemID = StringUtil.checkNull(elmInstMap.get("ElmItemID"));
					elmStatus = StringUtil.checkNull(elmInstMap.get("Status"));

					if (elmStatus.equals("WAT")) {
						setMap.put("procInstNo", procInstNo);
						setMap.put("elmInstNo", elmInstNo);
						commonService.delete("worker_SQL.deletePimWorker", setMap);

						// *** getEnsembleUserList -> EmployeeNum
						returnEnsembleUserData = WebServiceProxy.getEnsembleUserList(docItemNM, documentNo, team, roleID);
						//returnEnsembleUserData = WebServiceProxy.getEnsembleUserList("Project","130351", "ELEC", "LE");
						//returnEnsembleUserData = "IEP001,H2018015,H2018016";
						System.out.println("batchGetEnsembleUser-returnEnsembleUserData---" + returnEnsembleUserData);
						if (!returnEnsembleUserData.equals("")) {
							String EmployeeNum[] = returnEnsembleUserData.split(",");
							memberID = "";

							for (int i = 0; i < EmployeeNum.length; i++) {
								setMap.put("employeeNum", EmployeeNum[i]);
								memberID = commonService.selectString("user_SQL.getMemberIDFromEmpNO", setMap);

								if (memberID != "" && memberID != null) {
									setMap = new HashMap();
									setMap.put("memberID", memberID);
									getMemberInfoMap = new HashMap();
									getMemberInfoMap = commonService.select("user_SQL.getMemberInfo", setMap);

									if (getMemberInfoMap != null) {
										setMap.put("workerNo", NextWokerNo());
										setMap.put("memberID", memberID);
										setMap.put("workerTeamID", getMemberInfoMap.get("TeamID"));
										setMap.put("procInstNo", procInstNo);
										setMap.put("elmInstNo", elmInstNo);
										setMap.put("roleID", roleItemID);
										setMap.put("status", 1);
										setMap.put("Creator", cmmMap.get("sessionUserId"));
										setMap.put("LastUser", cmmMap.get("sessionUserId"));
										commonService.insert("worker_SQL.createPimWorker", setMap);
									}
								}
							}
						}
					}
				}
			}
			System.out.println("batchGetEnsembleUser complete");
		} catch (Exception e) {
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00089")); // 오류 발생
			if (_log.isInfoEnabled()) {
				_log.info("DaelimActionController::batchGetEnsembleUser::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
	}

	@RequestMapping(value = "/daelim/plant/getEnsembleUserList.do")
	public String getEnsembleUserList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		HashMap setinstanceMap = new HashMap();
		HashMap setMap = new HashMap();
		String language = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"), "");
		String procInstNo, elmInstNo, elmStatus, roleID, roleItemID, team, docItemNM, documentNo = "";
		String returnEnsembleUserData = "", memberID = "";
		String returnEnsembleError = "", memberIdError = "";
		String script = "fnCallBackSubmit();parent.$('#isSubmit').remove();";
		Map getMemberInfoMap = new HashMap();

		try {
			// *** getProcInst -> DocumentNo(projectCode = jobNo)
			procInstNo = StringUtil.checkNull(request.getParameter("procInstNo"));

			setinstanceMap.put("instanceNo", procInstNo);
			setinstanceMap.put("languageID", language);
			Map procInstInfo = commonService.select("instance_SQL.getProcInstanceInfo", setinstanceMap);
			docItemNM = StringUtil.checkNull(procInstInfo.get("docItemNM"));
			documentNo = StringUtil.checkNull(procInstInfo.get("DocumentNo"));

			// *** getElmInst -> RoleID, teamItemID -> role,team
			List elmInstList = commonService.selectList("instance_SQL.getElmInstList_gridList", setinstanceMap);
			Map elmInstMap = new HashMap();
			if (elmInstList.size() > 0) {
				DLMWebServiceProxy WebServiceProxy = new DLMWebServiceProxy();
				for (int k = 0; k < elmInstList.size(); k++) {
					elmInstMap = (Map) elmInstList.get(k);

					elmInstNo = StringUtil.checkNull(elmInstMap.get("ElmInstNo"));
					roleItemID = StringUtil.checkNull(elmInstMap.get("RoleID"));
					roleID = StringUtil.checkNull(elmInstMap.get("roleCode"));
					team = StringUtil.checkNull(elmInstMap.get("parentRoleCode"));
					elmStatus = StringUtil.checkNull(elmInstMap.get("Status"));

					if (elmStatus.equals("WAT")) {
						setMap.put("procInstNo", procInstNo);
						setMap.put("elmInstNo", elmInstNo);
						commonService.delete("worker_SQL.deletePimWorker", setMap);

						// *** getEnsembleUserList -> EmployeeNum
						returnEnsembleUserData = WebServiceProxy.getEnsembleUserList(docItemNM, documentNo, team, roleID);
						//returnEnsembleUserData = WebServiceProxy.getEnsembleUserList("Project","130351", "ELEC", "LE");
						//returnEnsembleUserData = "IEP001,H2018015,H2018016";
						System.out.println("getEnsembleUserList-returnEnsembleUserData---" + returnEnsembleUserData);
						if (!returnEnsembleUserData.equals("")) {
							String EmployeeNum[] = returnEnsembleUserData.split(",");
							memberID = "";

							for (int i = 0; i < EmployeeNum.length; i++) {
								setMap.put("employeeNum", EmployeeNum[i]);
								memberID = commonService.selectString("user_SQL.getMemberIDFromEmpNO", setMap);

								if (memberID != "" && memberID != null) {
									setMap = new HashMap();
									setMap.put("memberID", memberID);
									getMemberInfoMap = new HashMap();
									getMemberInfoMap = commonService.select("user_SQL.getMemberInfo", setMap);

									if (getMemberInfoMap != null) {
										setMap.put("workerNo", NextWokerNo());
										setMap.put("memberID", memberID);
										setMap.put("workerTeamID", getMemberInfoMap.get("TeamID"));
										setMap.put("procInstNo", procInstNo);
										setMap.put("elmInstNo", elmInstNo);
										setMap.put("roleID", roleItemID);
										setMap.put("status", 1);
										setMap.put("Creator", cmmMap.get("sessionUserId"));
										setMap.put("LastUser", cmmMap.get("sessionUserId"));
										commonService.insert("worker_SQL.createPimWorker", setMap);
									}
								} else {
									memberIdError += EmployeeNum[i] + " ";
								}
							}
						} else {
							returnEnsembleError += (k + 1) + "No ";
						}
					}
				}

				if (!returnEnsembleError.equals("")) {
					script = script + "fnCallBackEnsembleUserList('" + returnEnsembleError + "',0);";
				}
				if (!memberIdError.equals("")) {
					script = script + "fnCallBackEnsembleUserList('" + memberIdError + "',1);";
				}
				target.put(AJAX_SCRIPT, script);
			} else {
				Object[] obj = { "Activity" };
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00168", obj));
			}

		} catch (Exception e) {
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00089")); // 오류 발생
			if (_log.isInfoEnabled()) {
				_log.info("DaelimActionController::getEnsembleUserList::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/daelim/plant/setBigRoomLink.do")
	public void setBigRoomLink(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		String OLM_SERVER_URL = StringUtil.checkNull(GlobalVal.OLM_SERVER_URL);
		String language = StringUtil.checkNull(cmmMap.get("language"), "");
		String docItemNM = "", documentNo = "", docItemNo = "", procInstNo="", iFMessage="";
		String addLink = "";

		if (language.equals("")) {
			language = GlobalVal.DEFAULT_LANGUAGE;
		}

		try {
			DLMWebServiceProxy WebServiceProxy = new DLMWebServiceProxy();

			List bigRoomLinkList = commonService.selectList("custom_SQL.zdaelim_getBigRoomLinkList", setMap);
			for (int i = 0; i < bigRoomLinkList.size(); i++) {
				setMap = new HashMap();
				setMap = (Map) bigRoomLinkList.get(i);
				addLink = OLM_SERVER_URL + "/zDli2Olm.do?GUID=#GUID#&object=procInst&linkType=id&languageID=1042";
				procInstNo = StringUtil.checkNull(setMap.get("procInstNo"));
				docItemNM = StringUtil.checkNull(setMap.get("docItemNM"));
				documentNo = StringUtil.checkNull(setMap.get("documentNo"));
				docItemNo = StringUtil.checkNull(setMap.get("docItemNo"));
				addLink += "&linkID=" + procInstNo;
				addLink += "&docItemNo=" + docItemNo;
				iFMessage = WebServiceProxy.setBigRoomLink(docItemNM, documentNo, addLink);
				if(iFMessage.equals("")) {
					setMap.put("iFMessage", "SUCCESS");
				}else {
					setMap.put("iFMessage", "FAIL");
				}
				setMap.put("lastUser", "1");				
				setMap.put("ProcInstNo", procInstNo);				
				commonService.update("instance_SQL.updateInstanceGridData", setMap);
				
			}
		} catch (Exception e) {
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00089")); // 오류 발생
			if (_log.isInfoEnabled()) {
				_log.info("DaelimActionController::setBigRoomLink::Error::" + e);
			}
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
	}

	public String NextWokerNo() throws Exception {
		Map setMap = new HashMap();
		String maxWorkNo = commonService.selectString("worker_SQL.maxWorkerNo", setMap).trim();
		maxWorkNo = maxWorkNo.substring(maxWorkNo.length() - 5, maxWorkNo.length());
		int maxcode = Integer.parseInt(maxWorkNo) + 1;
		String newMaxWorkNo = "W" + String.format("%09d", maxcode);
		return newMaxWorkNo;
	}
}
