package xbolt.pop.web;

import java.net.URLDecoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.org.json.JSONArray;
import com.sap.tc.logging.Category;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.GlovalStoreUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

//@AutoWired
//private TilesUrlBasedViewResolver resolver;

/**
 * @Class Name : PopUpController.java
 * @Description : PopUpController.java
 * @Modification Popup
 * @수정일 수정자 수정내용
 * @--------- --------- -------------------------------
 * @2011. 2. 7. son 최초생성
 *
 * @author MCOM mCRM 시스템
 * @since 2011. 2. 7.searchPluralNamePop
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
// @RequestMapping(value="/popup/*.do")
public class PopUpController extends XboltController {

	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService cmmService;
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;
	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/popupMasterMdlEdt.do")
	public String popupMasterMdlEdt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"));
			String focusedItemID = StringUtil.checkNull(request.getParameter("focusedItemID")); 
			setMap.put("modelID", request.getParameter("modelID"));
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			String htmlTitle = StringUtil.checkNull(cmmService.selectString("model_SQL.getModelNM", setMap),"");			
			if(!instanceNo.equals("")){
				setMap.put("instanceNo", instanceNo);
				setMap.put("attrTypeCode", "AT01001");
				htmlTitle = StringUtil.checkNull(cmmService.selectString("instance_SQL.getInstAttrValue", setMap),"");
			}
			model.put("htmlTitle", htmlTitle);
			model.put("focusedItemID", focusedItemID);
			model.put("mdlFilter", StringUtil.checkNull(request.getParameter("mdlFilter")));
			model.put("itemTypeFilter", StringUtil.checkNull(request.getParameter("itemTypeFilter")));
			model.put("dimTypeFilter", StringUtil.checkNull(request.getParameter("dimTypeFilter")));
			model.put("symTypeFilter", StringUtil.checkNull(request.getParameter("symTypeFilter")));
			model.put("focusedItemID", StringUtil.checkNull(request.getParameter("focusedItemID")));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/popupMasterMdlEdt");
	}

	

	// =================================================
	/**
	 * 사용자조회 팝업
	 * 
	 * @param cmmMap
	 *            - 세그먼트 검색가능
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping
	public void userSearchPopup(HttpServletRequest request, HashMap cmmMap,
			ModelMap model) throws Exception {
		try {
			model.addAttribute(HTML_HEADER, "사용자조회");
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		}
	}

	@RequestMapping(value = "/searchNameSubPop.do")
	public String searchNameSubPop(HttpServletRequest request, ModelMap model)
			throws Exception {
		try {
			if (!StringUtil.checkNull(request.getParameter("searchValue"), "")
					.equals("")) {
				model.put("searchKey", request.getParameter("searchKey"));
				model.put("searchValue", request.getParameter("searchValue"));
				List getList = new ArrayList();
				Map getMap = new HashMap();

				getMap.put("searchKey", request.getParameter("searchKey"));
				getMap.put("searchValue", request.getParameter("searchValue"));
				getMap.put("languageID", request.getParameter("languageID"));
				getList = cmmService.selectList("project_SQL.searchNamePop",getMap);

				model.put("getList", getList);
			}
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/popup/searchNameSubPop");
	}
	
	@RequestMapping(value = "/searchTeamPop.do")
	public String searchTeamPop(HttpServletRequest request, ModelMap model) throws Exception {
		List getList = new ArrayList();
		try {
			
			String viewOption = StringUtil.checkNull(request.getParameter("viewOption")); // 키워드 검색 없을 경우 전체출력
			@SuppressWarnings("rawtypes")
			Map getMap = new HashMap();
			
			
			if (!StringUtil.checkNull(request.getParameter("searchValue"), "")
					.equals("")) {
				model.put("searchValue", request.getParameter("searchValue"));

				getMap.put("languageID", request.getParameter("languageID"));
				getMap.put("Name", request.getParameter("searchValue"));
				getMap.put("teamTypeYN",StringUtil.checkNull(request.getParameter("teamTypeYN"),"Y"));
				getMap.put("clientID", StringUtil.checkNull(request.getParameter("clientID")));
				getMap.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
				
				getList = cmmService.selectList("organization_SQL.searchTeamPop", getMap);
			}
			else if ("ALL".equals(viewOption) && "".equals(StringUtil.checkNull(request.getParameter("searchValue"), ""))) {
				
				getMap.put("languageID", request.getParameter("languageID"));
				getMap.put("teamTypeYN",StringUtil.checkNull(request.getParameter("teamTypeYN"),"Y"));
				getMap.put("clientID", StringUtil.checkNull(request.getParameter("clientID")));
				getMap.put("viewOption", viewOption);
				
				getList = cmmService.selectList("organization_SQL.searchTeamPop", getMap);
			}
			
			JSONArray gridData = new JSONArray(getList);
			model.put("gridData", gridData);
			
			model.put("clientID", StringUtil.checkNull(request.getParameter("clientID")));
			model.put("teamTypeYN",StringUtil.checkNull(request.getParameter("teamTypeYN"),"Y"));
			model.put("viewOption", viewOption);
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/popup/searchTeamPop");
	}

	@RequestMapping(value = "/searchNamePop.do")
	public String searchNamePop(HttpServletRequest request, ModelMap model)
			throws Exception {
		try {
			if (!StringUtil.checkNull(request.getParameter("searchValue"), "").equals("")) {
				model.put("searchKey", request.getParameter("searchKey"));
				model.put("searchValue", request.getParameter("searchValue"));

				List getList = new ArrayList();
				Map getMap = new HashMap();

				getMap.put("searchKey", request.getParameter("searchKey"));
				getMap.put("searchValue", request.getParameter("searchValue"));
				getMap.put("languageID", request.getParameter("languageID"));
				getList = cmmService.selectList("project_SQL.searchNamePop",getMap);

				model.put("getList", getList);

			}
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/popup/searchNamePop");
	}

	@RequestMapping(value = "/searchPluralNamePop.do")
	public String searchPluralNamePop(HttpServletRequest request, Map commandMap, ModelMap model)
			throws Exception {
		try {
				String searchKey = StringUtil.checkNull(request.getParameter("searchKey"),"");
				String searchValue = StringUtil.checkNull(request.getParameter("searchValue"),"");
				String teamID = StringUtil.checkNull(request.getParameter("teamID"),"");
				String clientID = StringUtil.checkNull(request.getParameter("clientID"),"");
				String searchOption = StringUtil.checkNull(request.getParameter("searchOption"),"");
				
			if (!StringUtil.checkNull(request.getParameter("searchValue"), "").equals("") || !teamID.equals("")) {
				
				model.put("searchKey", searchKey);
				model.put("searchValue", searchValue);
				model.put("teamID", teamID);
				model.put("clientID", request.getParameter("clientID"));

				List getList = new ArrayList();
				Map getMap = new HashMap();

				getMap.put("searchKey", searchKey);
				getMap.put("searchValue", searchValue);
				getMap.put("languageID", commandMap.get("sessionCurrLangType"));
				getMap.put("UserLevel", request.getParameter("UserLevel"));
				getMap.put("teamID", teamID);
				getMap.put("clientID", clientID);
				if(searchOption.equals("myClient")) {
					getMap.put("searchOption", searchOption);
					getMap.put("clientID", commandMap.get("sessionClientId"));
				}
				getList = cmmService.selectList("project_SQL.searchNamePop",getMap);

				model.put("getList", getList);
				Map firstRowData = new HashMap();
				if(getList.size() > 0){
					firstRowData = (Map)getList.get(0);
				}
				model.put("firstRowData", firstRowData);
				model.put("listSize", getList.size());
				
			}

			/* 작성자 팝업 창에서 선택된 user의 ID, Name을 설정할 window Object를 파라메터로 넘겨 받음 */
			model.put("objId", request.getParameter("objId"));
			model.put("objName", request.getParameter("objName"));
			model.put("UserLevel",  request.getParameter("UserLevel"));
			model.put("searchOption",  request.getParameter("searchOption"));
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/popup/searchPluralNamePop");
	}

	@RequestMapping(value = "/deleteNamePop.do")
	public String deleteNamePop(HttpServletRequest request, HashMap cmmMap, ModelMap model)
			throws Exception {
		try {
			List getList = new ArrayList();
			Map getMap = new HashMap();

			getMap.put("MemberID", request.getParameter("MemberID"));
			getMap.put("languageID", request.getParameter("languageID"));
			getMap.put("csrUserID", cmmMap.get("sessionUserId"));
			getList = cmmService.selectList("project_SQL.deleteNamePop", getMap);

			model.put("getList", getList);
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */

			/* 작성자 팝업 창에서 선택된 user의 ID, Name을 설정할 window Object를 파라메터로 넘겨 받음 */
			// model.put("objId", request.getParameter("objId"));
			// model.put("objName", request.getParameter("objName"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/popup/deleteNamePop");
	}

	@RequestMapping(value = "/searchTeamSubPop.do")
	public String searchTeamSubPop(HttpServletRequest request, ModelMap model)
			throws Exception {

		try {
			if (!StringUtil.checkNull(request.getParameter("searchValue"), "")
					.equals("")) {
				model.put("searchValue", request.getParameter("searchValue"));

				List getList = new ArrayList();
				Map getMap = new HashMap();
				getMap.put("languageID", request.getParameter("languageID"));
				getMap.put("Name", request.getParameter("searchValue"));

				getList = cmmService.selectList("organization_SQL.searchTeamPop",
						getMap);
				model.put("getList", getList);
				model.put("menu", getLabel(request, cmmService)); /* Label Setting */
			}
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/popup/searchTeamSubPop");
	}

	@RequestMapping(value = "/modelingPop.do")
	public String modelingPop(HttpServletRequest request, HashMap cmmMap,
			ModelMap model) throws Exception {

		try {
			model.put("ItemID", StringUtil.checkNull(cmmMap.get("ItemID")));
			model.put("ModelID", StringUtil.checkNull(cmmMap.get("ModelID")));
			model.put("option", StringUtil.checkNull(cmmMap.get("option")));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/popup/modelingPop");
	}

	/**
	 * 조직 사용자 트리 팝업 : ArcCode - AR000002, SQL - menuTreeListByOrg_treeList
	 * 
	 * @param request
	 * @param cmmMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/orgUserTreePop.do")
	public String orgUserTreePop(HttpServletRequest request, HashMap cmmMap,
			ModelMap model) throws Exception {
		try {
			model.put("s_itemID",
					StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/popup/orgUserTreePop");
	}
	
	@RequestMapping(value = "/orgItemTreePop.do")
	public String orgItemTreePop(HttpServletRequest request, HashMap cmmMap,
			ModelMap model) throws Exception {
		try {
			model.put("s_itemID",
					StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */
			model.put("ItemID",
					StringUtil.checkNull(request.getParameter("ItemID")));
			model.put("ItemTypeCode",
					StringUtil.checkNull(request.getParameter("ItemTypeCode")));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/popup/orgItemTreePop");
	}

	@RequestMapping(value = "/acrCodeTreePop.do")
	public String acrCodeTreePop(HttpServletRequest request, ModelMap model) throws Exception {
		try {
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			model.put("items", StringUtil.checkNull(request.getParameter("items"), ""));
			model.put("checkType", StringUtil.checkNull(request.getParameter("checkType"), ""));
			model.put("option",	StringUtil.checkNull(request.getParameter("option"), ""));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/acrCodeTreePop");
	}

	@RequestMapping(value = "/checkAuthor.do")
	public String checkAuthor(HttpServletRequest request, ModelMap model)
			throws Exception {
		try {
			Map resultMap = new HashMap();
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			String userId = StringUtil.checkNull(request.getParameter("userId"), "");
			String userType = StringUtil.checkNull(request.getParameter("userType"), "");
			model.put("s_itemID", s_itemID);
			String isCheck = "false";

			Map setMap = new HashMap();
			setMap.put("s_itemID", s_itemID);
			String authorId = cmmService.selectString("item_SQL.getItemAuthorId", setMap);
			if (userId.equals(authorId) || userType.equals("SYS")) {
				isCheck = "true";
			}

			resultMap.put(AJAX_SCRIPT, "fnReturnCheck('" + isCheck + "')");
			model.addAttribute(AJAX_RESULTMAP, resultMap);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/allItemTreePop.do")
	public String allItemTreePop(HttpServletRequest request, ModelMap model)
			throws Exception {
		try {
			String s_itemID = "";
			String setID = "";
			if (!StringUtil.checkNull(request.getParameter("subID"), "")
					.equals("")) {
				s_itemID = StringUtil.checkNull(request.getParameter("subID"), "");
				setID = StringUtil.checkNull(request.getParameter("subID"), "");
			} else {
				s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
				setID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			}
			model.put("s_itemID", setID);
			model.put("option",
					StringUtil.checkNull(request.getParameter("option"), ""));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/allItemTreePop");
	}

	@RequestMapping(value = "/allItemTreePopAdd.do")
	public String allItemTreePopAdd(HttpServletRequest request, ModelMap model)
			throws Exception {
		try {
			String s_itemID = "";
			String setID = "";
			if (!StringUtil.checkNull(request.getParameter("subID"), "")
					.equals("")) {
				s_itemID = StringUtil.checkNull(request.getParameter("subID"), "");
				setID = StringUtil.checkNull(request.getParameter("subID"), "");
			} else {
				s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
				setID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			}
			model.put("s_itemID", setID);
			model.put("option",
					StringUtil.checkNull(request.getParameter("option"), ""));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/allItemTreePopAdd");
	}

	@RequestMapping(value = "/allItemTreePopChangeSet.do")
	public String allItemTreePopChangeSet(HttpServletRequest request,
			ModelMap model) throws Exception {
		try {
			String s_itemID = "";
			String setID = "";
			if (!StringUtil.checkNull(request.getParameter("subID"), "")
					.equals("")) {
				s_itemID = StringUtil.checkNull(request.getParameter("subID"), "");
				setID = StringUtil.checkNull(request.getParameter("subID"), "");
			} else {
				s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
				setID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			}
			model.put("s_itemID", setID);
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/allItemTreePopChangeSet");
	}

	

	// 므로세스 모델 속성 수정 팝업
	@RequestMapping(value = "/selectOwnerPop.do")
	public String selectOwnerPop(HttpServletRequest request, HashMap cmmMap,
			ModelMap model) throws Exception {
		try {

			Map setMap = new HashMap();

			String items = StringUtil.checkNull(request.getParameter("items"));

			setMap.put("TeamType", "2");
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			List returnData = cmmService.selectList("organization_SQL.getTeamList", setMap);
			
			String authorID = StringUtil.checkNull(request.getParameter("authorID"));
			String authorName = StringUtil.checkNull(request.getParameter("authorName"));
			model.put("authorID", authorID);
			model.put("authorName", authorName);
			model.put("companyOption", returnData);
			model.put("items", items);
			model.put("hideOption", StringUtil.checkNull(request.getParameter("hideOption")));
			model.put("myTransfer", StringUtil.checkNull(request.getParameter("myTransfer")));
			model.put("mailNotice", StringUtil.checkNull(request.getParameter("mailNotice")));
			
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */

			
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/selectOwnerPop");
	}

	

	

	

	

	@RequestMapping(value = "/diagramPdfPop.do")
	public String diagramPdfPop(HttpServletRequest request, ModelMap model)
			throws Exception {
		try {
			System.out.println("percent=" + request.getParameter("Percent"));
			int percent = (int) (NumberUtil.getDoubleValue(request.getParameter("Percent"), 0) * 100);
			model.put("Percent", percent);
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/diagramPdfPop");
	}

	@RequestMapping(value = "/addModelTypePop.do")
	public String addModelTypePop(HttpServletRequest request, HashMap mapValue,
			ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */
			model.put("LanguageID", request.getParameter("LanguageID"));
			String MaxModelTypeID = cmmService.selectString("config_SQL.MaxModelType", setMap);
			String MaxModelTypeID1 = MaxModelTypeID.substring(2, 5);
			int intMaxModelType = Integer.parseInt(MaxModelTypeID1);
			int maxcode = intMaxModelType + 1;
			String Maxcode = "MT" + String.format("%03d", maxcode);
			model.put("MaxModelTypeCode", Maxcode);
			model.put("pageNum", request.getParameter("pageNum"));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/addModelTypePop");
	}

	@RequestMapping(value = "/AddSimbolTypePop.do")
	public String AddSimbolTypePop(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		try {
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String ModelTypeCode = StringUtil.checkNull(request.getParameter("ModelTypeCode"));
			
			commandMap.put("ModelTypeCode", ModelTypeCode);
			commandMap.put("languageID", languageID);
	        List addSimboltypePopList = commonService.selectList("config_SQL.SelectAddSimbolType_gridList", commandMap);
	        JSONArray gridData = new JSONArray(addSimboltypePopList);
	        model.put("gridData",gridData);	
			
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */

			String Name1 = new String(URLDecoder.decode(request.getParameter("Name"), "UTF-8"));

			model.put("ModelTypeCode", request.getParameter("ModelTypeCode"));
			model.put("LanguageID", request.getParameter("LanguageID"));
			model.put("Name", Name1);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/AddSimbolTypePop");
	}

	@RequestMapping(value = "/SaveSymbolAttrPop.do")
	public String SaveSymbolAttrPop(HttpServletRequest request, ModelMap model) throws Exception {
		try {
				model.put("symTypeCode", StringUtil.checkNull(request.getParameter("symTypeCode"), ""));
				model.put("Category", StringUtil.checkNull(request.getParameter("Category"), ""));
				model.put("Name", new String(URLDecoder.decode(StringUtil.checkNull(request.getParameter("Name"), ""), "UTF-8")));
				model.put("attrTypeCode", StringUtil.checkNull(request.getParameter("attrTypeCode"), ""));
				model.put("displayType", StringUtil.checkNull(request.getParameter("displayType"), ""));
				model.put("x", StringUtil.checkNull(request.getParameter("x"), ""));
				model.put("y", StringUtil.checkNull(request.getParameter("y"), ""));
				model.put("width", StringUtil.checkNull(request.getParameter("width"), ""));
				model.put("height", StringUtil.checkNull(request.getParameter("height"), ""));
				model.put("fontSize", StringUtil.checkNull(request.getParameter("fontSize"), ""));
				model.put("fontColor", StringUtil.checkNull(request.getParameter("fontColor"), ""));
				model.put("fontStyle", StringUtil.checkNull(request.getParameter("fontStyle"), ""));
				model.put("fontFamily", StringUtil.checkNull(request.getParameter("fontFamily"), ""));
				model.put("strokeWidth", StringUtil.checkNull(request.getParameter("strokeWidth"), ""));
				model.put("strokeColor", StringUtil.checkNull(request.getParameter("strokeColor"), ""));
				model.put("fillColor", StringUtil.checkNull(request.getParameter("fillColor"), ""));
				model.put("labelBackgroundColor", StringUtil.checkNull(request.getParameter("labelBackgroundColor"), ""));
				model.put("scrnMode", StringUtil.checkNull(request.getParameter("scrnMode"), ""));
				model.put("html", StringUtil.checkNull(request.getParameter("html"), ""));
				model.put("mdpID", StringUtil.checkNull(request.getParameter("mdpID")));
				model.put("newYN", StringUtil.checkNull(request.getParameter("newYN"), ""));
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/SaveSymbolAttrPop");
	}
	
	/**
	 * 모든 아이템을 select 할수 있는 팝업 창 표시
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAllItemPop.do")
	public String selectAllItemPop(HttpServletRequest request, HashMap cmmMap,
			ModelMap model) throws Exception {

		Map setMap = new HashMap();
		List getProcess = new ArrayList();

		try {

			// 클래스 리스트 취득
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("ChangeMgt", "1");
			model.put("changeClassList",	cmmService.selectList("item_SQL.getClassCodeOption", setMap));

			// 로그인 유저에게 할당 되어 있는 CSR 중, 완료 되지 않은 리스트 취득
			setMap.put("userId", cmmMap.get("sessionUserId"));
			setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("ProjectType", "CSR");
			setMap.put("isMainItem", "Y");
			List projectNameList = (List) cmmService.selectList(	"project_SQL.getProjectNameList", setMap);

			model.put("projectNameList", projectNameList);
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/selectAllItemPop");
	}

	// 모델 그리드 리스트 팝업오픈
	@RequestMapping(value = "/searchModelGridList.do")
	public String searchModelGridList(HttpServletRequest request,
			HashMap cmmMap, ModelMap model) throws Exception {

		Map setMap = new HashMap();
		String ItemID = StringUtil.checkNull(request.getParameter("ItemID"), "");
		String SRTypeCode = StringUtil.checkNull(request.getParameter("SRTypeCode"), "");
		try {
			model.put("menu", getLabel(request, cmmService));	/*Label Setting*/
			model.put("ItemID", ItemID);
			model.put("SRTypeCode",SRTypeCode);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/searchModelGridList");
	}

	/**
	 * ItemTypeCode를 조건으로 화면에 트리를 표시
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/itemTypeCodeTreePop.do")
	public String itemTypeCodeTreePop(HttpServletRequest request, ModelMap model)
			throws Exception {
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			String option = StringUtil.checkNull(request.getParameter("option"), "AR000000");
			String connectionType = StringUtil.checkNull(request.getParameter("connectionType"), "");
			String cxnTypeCodes = StringUtil.checkNull(request.getParameter("cxnTypeCodes"), "");
			String hiddenClassList = StringUtil.checkNull(request.getParameter("hiddenClassList"), "");
			String strType = StringUtil.checkNull(request.getParameter("strType"), "");
			String btnName = "Assign";
			String btnStyle = "assign";
		
			
			model.put("hiddenClassList", hiddenClassList);
			model.put("s_itemID", s_itemID);
			model.put("items",StringUtil.checkNull(request.getParameter("items"), ""));
			model.put("tFilterCode",StringUtil.checkNull(request.getParameter("tFilterCode")));
			model.put("sqlQueryID",StringUtil.checkNull(request.getParameter("sqlQueryID")));
			model.put("rootItemID", StringUtil.checkNull(request.getParameter("rootItemID")));
			model.put("checkType", StringUtil.checkNull(request.getParameter("checkType"), ""));
			model.put("option", option);
			model.put("openMode", StringUtil.checkNull(request.getParameter("openMode"), ""));
			model.put("varFilter", StringUtil.checkNull(request.getParameter("varFilter"), ""));			
			model.put("btnName", btnName);
			model.put("btnStyle", btnStyle);
			model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
			model.put("projectID", StringUtil.checkNull(request.getParameter("projectID")));
			model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
			model.put("strType", StringUtil.checkNull(request.getParameter("strType")));
			
			Map setMap = new HashMap();
			if(connectionType.equals("")){
				setMap.put("s_itemID", s_itemID);
				setMap.put("itemTypeCode", StringUtil.checkNull(cmmService.selectString("item_SQL.getItemTypeCode", setMap)) );
				setMap.put("cxnTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
				Map cxnTypeInfo = (Map)cmmService.select("item_SQL.getCxnTypeInfo", setMap);
				connectionType = StringUtil.checkNull(cxnTypeInfo.get("CxnType"));
			}
			model.put("connectionType", connectionType);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/itemTypeCodeTreePop");
	}

	/**
	 * 선택된 item의 경로를 취득
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getPathWithItemId.do")
	public String getPathWithItemId(HttpServletRequest request, HashMap cmmMap,
			ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			Map resultMap = new HashMap();

			setMap.put("s_itemID",	StringUtil.checkNull(request.getParameter("s_itemID")));
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			String itemPath = cmmService.selectString("item_SQL.getItemPath", setMap);

			resultMap.put(AJAX_SCRIPT, "fnReturn('" + itemPath + "')");
			model.addAttribute(AJAX_RESULTMAP, resultMap);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}

	/**
	 * 연관 항목 중복 체크
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/checkExistItem.do")
	public String checkExistItem(HttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			Map resultMap = new HashMap();

			String[] arrayCode = StringUtil.checkNull(request.getParameter("ids")).split(",");
			String cnItemTypeCode = StringUtil.checkNull(request.getParameter("varFilter"));
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String myCnType = StringUtil.checkNull(request.getParameter("connectionType"));
			String returnIds = "";
			String msg = "";

			if (myCnType.equals("From")) {
				//setMap.put("ToItemID", s_itemID);
				setMap.put("FromItemID", s_itemID);
			} else {
				//setMap.put("FromItemID", s_itemID);
				setMap.put("ToItemID", s_itemID);
			}

			for (int i = 0; arrayCode.length > i; i++) {
				String myItemId = String.valueOf(arrayCode[i]);
				if (myCnType.equals("From")) {
					//setMap.put("FromItemID", myItemId);
					setMap.put("ToItemID", myItemId);
				} else {
					//setMap.put("ToItemID", myItemId);
					setMap.put("FromItemID", myItemId);
				}
				
				if(cnItemTypeCode.equals("")) {
					cnItemTypeCode = StringUtil.checkNull(cmmService.selectString("item_SQL.getCXNItemTypeCode",setMap), "");
				}
				setMap.put("ItemTypeCode", cnItemTypeCode);
				setMap.put("deleted","1");
				if (!"0".equals(cmmService.selectString("organization_SQL.getCountConItem", setMap))) {
					setMap.put("ItemID", myItemId);
					setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
					String itemName = cmmService.selectString("organization_SQL.getItemIdANdName", setMap);
					if (msg.isEmpty()) {
						msg = "[" + itemName + "]";
					} else {
						msg = msg + "," + "[" + itemName + "]";
					}
				} else {
					if (returnIds.isEmpty()) {
						returnIds = myItemId;
					} else {
						returnIds = returnIds + "," + myItemId;
					}
				}
			}

			if (!msg.isEmpty()) {
				resultMap.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00117",	new String[] { msg }));				
			}else{
				resultMap.put(AJAX_SCRIPT, "fnReturn('" + returnIds + "')");
			}
			
			model.addAttribute(AJAX_RESULTMAP, resultMap);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/checkExistStrItem.do")
	public String checkExistStrItem(HttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			Map resultMap = new HashMap();

			String[] arrayCode = StringUtil.checkNull(request.getParameter("ids")).split(",");
			String cnItemTypeCode = StringUtil.checkNull(request.getParameter("varFilter"));
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String returnIds = "";
			String msg = "";

			setMap.put("parentID", s_itemID);
			setMap.put("categoryCode", "ST2");

			for (int i = 0; arrayCode.length > i; i++) {
				String myItemId = String.valueOf(arrayCode[i]);
				setMap.put("ToItemID", myItemId);
				
				if(cnItemTypeCode.equals("")) {
					setMap.put("FromItemID", s_itemID);
					cnItemTypeCode = StringUtil.checkNull(cmmService.selectString("item_SQL.getCXNItemTypeCode",setMap), "");
				}
				setMap.put("ItemTypeCode", cnItemTypeCode);
				setMap.put("deleted","1");
				if (!"0".equals(cmmService.selectString("item_SQL.getCountConStrItem", setMap))) {
					setMap.put("ItemID", myItemId);
					setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
					String itemName = cmmService.selectString("organization_SQL.getItemIdANdName", setMap);
					if (msg.isEmpty()) {
						msg = "[" + itemName + "]";
					} else {
						msg = msg + "," + "[" + itemName + "]";
					}
				} else {
					if (returnIds.isEmpty()) {
						returnIds = myItemId;
					} else {
						returnIds = returnIds + "," + myItemId;
					}
				}
			}

			if (!msg.isEmpty()) {
				resultMap.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00117",	new String[] { msg }));				
			}else{
				resultMap.put(AJAX_SCRIPT, "fnReturn('" + returnIds + "')");
			}
			
			model.addAttribute(AJAX_RESULTMAP, resultMap);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}

	

	@RequestMapping(value = "/searchNewDimItemPop.do")
	public String searchNewDimItemPop(HttpServletRequest request, ModelMap model)
			throws Exception {
		Map<String, String> setMap = new HashMap<String, String>();
		try {
			//String mainClassCode = StringUtil.checkNull(request.getParameter("newClassCodePop"));
			model.put("dimValueID",StringUtil.checkNull(request.getParameter("dimValueID")));
			model.put("dimTypeID",StringUtil.checkNull(request.getParameter("dimTypeID")));
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */
			
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/searchNewDimItemPop");
	}

	@RequestMapping(value = "/consolidationPop.do")
	public String consolidationPop(HttpServletRequest request, ModelMap model)
			throws Exception {
		Map setMap = new HashMap();
		try {
			String itemId = StringUtil.checkNull(request.getParameter("itemID"));
			setMap.put("s_itemID", itemId);
			Map itemInfoMap = cmmService.select("project_SQL.getItemInfo",setMap);

			// get TB_LANGUAGE.IsDefault = 1 인 언어 코드
			String defaultLang = cmmService.selectString("item_SQL.getDefaultLang", setMap);

			model.put("defaultLang", defaultLang);
			model.put("masterItemId", itemId);
			model.put("itemTypeCode", StringUtil.checkNull(itemInfoMap.get("ItemTypeCode")));
			model.put("itemClassCode", StringUtil.checkNull(itemInfoMap.get("ClassCode")));
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/consolidationItemPop");
	}

	/**
	 * 하위 항목 [Edit ] 이벤트
	 * 
	 * @param request
	 * @param cmmMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/editItemIDNamePop.do")
	public String editItemIDNamePop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */
			Map setMap = new HashMap();

			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			List returnData = new ArrayList();		
			
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("option", StringUtil.checkNull(request.getParameter("option")));	
			setMap.put("filterType", StringUtil.checkNull(request.getParameter("filterType")));	
			setMap.put("TreeDataFiltered", StringUtil.checkNull(request.getParameter("filterType")));	
			setMap.put("defDimTypeID", StringUtil.checkNull(request.getParameter("defDimTypeID")));	
			setMap.put("defDimValueID", StringUtil.checkNull(request.getParameter("defDimValueID")));	
			setMap.put("showTOJ", StringUtil.checkNull(request.getParameter("showTOJ")));	
			setMap.put("showElement", StringUtil.checkNull(request.getParameter("showElement")));	
			
			returnData = cmmService.selectList("item_SQL.getSubItemList_gridList", setMap);
			
			if(returnData.size()>0) {
				for(int i=0; i<returnData.size(); i++) {
					Map returnDataMap = (Map) returnData.get(i);
					returnDataMap.put("ItemName", StringUtil.checkNull(returnDataMap.get("ItemName")).replaceAll("\"", "&quot;"));
				}
			}
				
			model.put("s_itemID", s_itemID);
			model.put("getList", returnData);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/editItemIDNamePop");
	}
	
	@RequestMapping(value = "/editCxnItemIDNamePop.do")
	public String editCxnItemIDNamePop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));

			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));			
			List returnData = cmmService.selectList("item_SQL.getItemCompositionList_gridList", setMap);
		
			model.put("s_itemID", s_itemID);
			model.put("getList", returnData);
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/editCxnItemIDNamePop");
	}

	/**
	 * 변경 항목 요건 체크
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/checkChangeItem.do")
	public String checkChangeItem(HttpServletRequest request, HashMap cmmMap,
			ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			Map resultMap = new HashMap();

			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String projectID = StringUtil.checkNull(request	.getParameter("projectID"));
			setMap.put("ItemID", s_itemID);
			setMap.put("ProjectID", projectID);
			String changeMgt = cmmService.selectString("project_SQL.getChangeMgt", setMap);
			String changeItemCnt = cmmService.selectString("cs_SQL.getCNGTCount", setMap);
			setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
			String itemName = cmmService.selectString("organization_SQL.getItemIdANdName", setMap);

			if (!"1".equals(changeMgt)) {
				resultMap.put(AJAX_ALERT, MessageHandler.getMessage(
						cmmMap.get("sessionCurrLangCode") + ".WM00128",
						new String[] { itemName }));
				resultMap.put(AJAX_SCRIPT, "return false;");
			} else if (!"0".equals(changeItemCnt)) {
				resultMap.put(AJAX_ALERT, MessageHandler.getMessage(
						cmmMap.get("sessionCurrLangCode") + ".WM00117",
						new String[] { itemName }));
				resultMap.put(AJAX_SCRIPT, "return false;");
			} else {
				resultMap.put(AJAX_SCRIPT, "fnReturn('" + s_itemID + "')");
			}

			model.addAttribute(AJAX_RESULTMAP, resultMap);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}

	/**
	 * [main] 화면 Issue 상세 표시
	 * 
	 * @param request
	 * @param cmmMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/issueDetailPop.do")
	public String issueDetailPop(HttpServletRequest request, HashMap cmmMap,
			ModelMap model) throws Exception {
		Map setMap = new HashMap();
		Map result = new HashMap();
		try {

			String issueId = StringUtil.checkNull(request.getParameter("issueId"));
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("IssueID", issueId);
			result = cmmService.select("issue_SQL.getIssueInfo_gridList",	setMap);

			model.put("itemFiles", (List) cmmService.selectList("issue_SQL.getIssueFileList", setMap));
			model.put("issueFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
			model.put(AJAX_RESULTMAP, result);
			model.put("menu", getLabel(request, cmmService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/issueDetailPop");
	}
		
	
	@RequestMapping(value = "/authorInfoPop.do")
	public String authorInfoPop(HttpServletRequest request, HashMap cmmMap, ModelMap model)throws Exception {
		try {
				String memberID = StringUtil.checkNull(request.getParameter("memberID"));
				Map setMap = new HashMap();
				setMap.put("MemberID", memberID);
				setMap.put("languageID", cmmMap.get("sessionCurrLangType") );
				
				Map authorInfoMap = cmmService.select("item_SQL.getAuthorInfo", setMap);
				
				model.put("authorInfoMap", authorInfoMap);
				model.put("menu", getLabel(request, cmmService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/authorInfoPop");
	}
		
	@RequestMapping(value = "/checkClassCode.do")
	public String checkClassCode(HttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			Map resultMap = new HashMap();
			String itemIDs = StringUtil.checkNull(request.getParameter("itemIDs"));
			String varFilter = StringUtil.checkNull(request.getParameter("varFilter"));
			
			String itemIDsSPL[] = itemIDs.split(",");
			String varFilterSPL[] = varFilter.split(",");
			String itemID = "";
			String classCode = "";
			String getClassCode = "";
			String inCludeYN = "N";
			String notItemIDs = "";
		
			for(int i=0; i<itemIDsSPL.length; i++){
				itemID = StringUtil.checkNull(itemIDsSPL[i]);
				setMap.put("itemID", itemID);
				getClassCode = StringUtil.checkNull(cmmService.selectString("item_SQL.getClassCode", setMap),"");
				
				for(int j=0; j<varFilterSPL.length; j++){
					classCode = StringUtil.checkNull(varFilterSPL[j]);
					if(classCode.equals(getClassCode)){
						inCludeYN = "Y";
					}
				}
				if(!inCludeYN.equals("Y")){
					if(notItemIDs.equals("")){
						notItemIDs = itemID; 
					}else{
						notItemIDs = notItemIDs + "," + itemID; 
					}
				}
			}

			if(notItemIDs != null && !notItemIDs.equals("")){ //WM00139
				resultMap.put(AJAX_SCRIPT, "fnNotItemIDs('" + notItemIDs + "')");
				model.addAttribute(AJAX_RESULTMAP, resultMap);
			}else{				
				// success 
				resultMap.put(AJAX_SCRIPT, "fnInsertAssinID('" + itemIDs + "')");
				model.addAttribute(AJAX_RESULTMAP, resultMap);
			}
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/itemProposalTreePop.do")
	public String itemProposalTreePop(HttpServletRequest request, ModelMap model)
			throws Exception {
		try {
			String s_itemID = "";
			String setID = "";
			String option = StringUtil.checkNull(request.getParameter("option"), "");
			String itemProposal = StringUtil.checkNull(request.getParameter("itemProposal"), "");
			
			String btnName = "Assign";
			String btnStyle = "assign";
		

			model.put("itemProposal", itemProposal);
			model.put("s_itemID",StringUtil.checkNull(request.getParameter("s_itemID"), ""));
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
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/itemProposalTreePop");
	}
	
	@RequestMapping(value = "/itemTreePop.do")
	public String itemTreePop(HttpServletRequest request, ModelMap model) throws Exception {
		try {
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			model.put("items", StringUtil.checkNull(request.getParameter("items"), ""));
			model.put("checkType", StringUtil.checkNull(request.getParameter("checkType"), ""));
			model.put("option",	StringUtil.checkNull(request.getParameter("option"), ""));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/itemTreePop");
	}
	
	@RequestMapping(value = "/itemTypeCodeTreePopV4.do")
	public String itemTypeCodeTreePopV4(HttpServletRequest request, ModelMap model)
			throws Exception {
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			String option = StringUtil.checkNull(request.getParameter("option"), "AR000000");
			String connectionType = StringUtil.checkNull(request.getParameter("connectionType"), "");
			String cxnTypeCodes = StringUtil.checkNull(request.getParameter("cxnTypeCodes"), "");
			String hiddenClassList = StringUtil.checkNull(request.getParameter("hiddenClassList"), "");
			String strType = StringUtil.checkNull(request.getParameter("strType"), "");
			String btnName = "Assign";
			String btnStyle = "assign";
		
			
			model.put("hiddenClassList", hiddenClassList);
			model.put("s_itemID", s_itemID);
			model.put("items",StringUtil.checkNull(request.getParameter("items"), ""));
			model.put("tFilterCode",StringUtil.checkNull(request.getParameter("tFilterCode")));
			model.put("sqlQueryID",StringUtil.checkNull(request.getParameter("sqlQueryID")));
			model.put("rootItemID", StringUtil.checkNull(request.getParameter("rootItemID")));
			model.put("checkType", StringUtil.checkNull(request.getParameter("checkType"), ""));
			model.put("option", option);
			model.put("openMode", StringUtil.checkNull(request.getParameter("openMode"), ""));
			model.put("varFilter", StringUtil.checkNull(request.getParameter("varFilter"), ""));			
			model.put("btnName", btnName);
			model.put("btnStyle", btnStyle);
			model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
			model.put("projectID", StringUtil.checkNull(request.getParameter("projectID")));
			model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
			model.put("strType", StringUtil.checkNull(request.getParameter("strType")));
			
			Map setMap = new HashMap();
			if(connectionType.equals("")){
				setMap.put("s_itemID", s_itemID);
				setMap.put("itemTypeCode", StringUtil.checkNull(cmmService.selectString("item_SQL.getItemTypeCode", setMap)) );
				setMap.put("cxnTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
				Map cxnTypeInfo = (Map)cmmService.select("item_SQL.getCxnTypeInfo", setMap);
				connectionType = StringUtil.checkNull(cxnTypeInfo.get("CxnType"));
			}
			model.put("connectionType", connectionType);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/itemTypeCodeTreePopV4");
	}
}
