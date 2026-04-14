package xbolt.custom.sk.skon;

import com.org.json.JSONArray;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.project.chgInf.web.CSActionController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.*;

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
public class SKONActionController3 extends XboltController {
	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;
	
	@Resource(name="CSService")
	private CommonService CSService;
	
	@Resource(name="CSActionController")
	private CSActionController CSActionController;
	
	@RequestMapping(value = "/zSKON_cxnItemList.do", method = RequestMethod.GET)
	public void zSKON_cxnItemList(HttpServletRequest request, HttpServletResponse res) throws Exception {
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
	        
	        String defaultLang = commonService.selectString("item_SQL.getDefaultLang", map);
	        map.put("defaultLang",defaultLang);

	        List<Map<String, Object>> itemList = commonService.selectList("zSK_SQL.getCxnItemList_gridList", map);
	        jsonObject.put("list", itemList);
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        e.printStackTrace();
	        jsonObject.put("list", new ArrayList<>());
	        res.getWriter().print(jsonObject);
	    }
	}
	
	@RequestMapping(value = "/zSKON_cxnRnrList.do", method = RequestMethod.GET)
	public void zSKON_cxnRnrList(HttpServletRequest request, HttpServletResponse res) throws Exception {
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
	        
	        String defaultLang = commonService.selectString("item_SQL.getDefaultLang", map);
	        map.put("defaultLang",defaultLang);
	        
	        List<Map<String, Object>> activityList = commonService.selectList("zSK_SQL.getCxnRnrList", map); 
	        jsonObject.put("list", activityList);
	        
	        String split = "\\$\\$ ";
	        
			for (Map<String, Object> item : activityList) {
			           
		        // R
		        String r_texts[] = StringUtil.checkNull(item.get("r_text")).split(split);
		        String r_ItemIDs[] = StringUtil.checkNull(item.get("r_ItemID")).split(split);
		        String r_text = "";
		        for(int i = 0; i < r_texts.length; i++) {
		        	r_text += "<span onclick='doDetail("+r_ItemIDs[i]+")' class='link'>"+r_texts[i]+"</span><br>";
		        }
		        jsonObject.put("r_text", r_text);
		        
		        // A
		        String a_texts[] = StringUtil.checkNull(item.get("a_text")).split(split);
		        String a_ItemIDs[] = StringUtil.checkNull(item.get("a_ItemID")).split(split);
		        String a_text = "";
		        for(int i = 0; i < a_texts.length; i++) {
		        	a_text += "<span onclick='doDetail("+a_ItemIDs[i]+")' class='link'>"+a_texts[i]+"</span><br>";
		        }
		        jsonObject.put("a_text", a_text);
		        
		        // S
		        String s_texts[] = StringUtil.checkNull(item.get("s_text")).split(split);
		        String s_ItemIDs[] = StringUtil.checkNull(item.get("s_ItemID")).split(split);
		        String s_text = "";
		        for(int i = 0; i < s_texts.length; i++) {
		        	s_text += "<span onclick='doDetail("+s_ItemIDs[i]+")' class='link'>"+s_texts[i]+"</span><br>";
		        }
		        jsonObject.put("s_text", s_text);
		        
		        // I
		        String i_texts[] = StringUtil.checkNull(item.get("i_text")).split(split);
		        String i_ItemIDs[] = StringUtil.checkNull(item.get("i_ItemID")).split(split);
		        String i_text = "";
		        for(int i = 0; i < i_texts.length; i++) {
		        	i_text += "<span onclick='doDetail("+i_ItemIDs[i]+")' class='link'>"+i_texts[i]+"</span><br>";
		        }
		        jsonObject.put("i_text", i_text);
		        
		        // C
		        String c_texts[] = StringUtil.checkNull(item.get("c_text")).split(split);
		        String c_ItemIDs[] = StringUtil.checkNull(item.get("c_ItemID")).split(split);
		        String c_text = "";
		        for(int i = 0; i < c_texts.length; i++) {
		        	c_text += "<span onclick='doDetail("+c_ItemIDs[i]+")' class='link'>"+c_texts[i]+"</span><br>";
		        }
		        jsonObject.put("c_text", c_text);
			}
			res.getWriter().print(jsonObject);
			
	    } catch (Exception e) {
	        e.printStackTrace();
	        jsonObject.put("list", new ArrayList<>());
	        res.getWriter().print(jsonObject);
	    }
	}

	@RequestMapping(value = "/zSKON_DELcxnRnrList.do", method = RequestMethod.GET)
	public void zSKON_DELcxnRnrList(HttpServletRequest request, HttpServletResponse res) throws Exception {
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
	        
	        String defaultLang = commonService.selectString("item_SQL.getDefaultLang", map);
	        map.put("defaultLang",defaultLang);
	        
	        List<Map<String, Object>> activityList = commonService.selectList("zSK_SQL.getCxnRnrList", map); 
	        jsonObject.put("list", activityList);
	        
	        String split = "\\$\\$ ";
	        
			for (Map<String, Object> item : activityList) {
			    
				String itemID = StringUtil.checkNull(item.get("itemID"));
				String parentID = StringUtil.checkNull(item.get("parentID"));
				
				// R
				String r_texts[] = StringUtil.checkNull(item.get("r_text")).split(split);
				String r_ItemIDs[] = StringUtil.checkNull(item.get("r_ItemID")).split(split);
				String r_CxnItemIDs[] = StringUtil.checkNull(item.get("r_CxnItemID")).split(split);
				String r_text = "";
				for (int i = 0; i < r_texts.length; i++) {
				    r_text += "<span class='link'>" + r_texts[i];
				    
				    if (StringUtil.checkNull(item.get("r_text")) != "") {
				        r_text += "<img class='mgL8' src='/cmm/common/images/btn_file_del.png' style='width:12px; cursor:pointer;' onclick='event.stopPropagation(); delConnection(" + r_ItemIDs[i] + ", " + itemID + ")'>";
				    }

				    r_text += "</span><br>";
				}
				jsonObject.put("r_text", r_text);

				// A
				String a_texts[] = StringUtil.checkNull(item.get("a_text")).split(split);
				String a_ItemIDs[] = StringUtil.checkNull(item.get("a_ItemID")).split(split);
				String a_CxnItemIDs[] = StringUtil.checkNull(item.get("a_CxnItemID")).split(split);
				String a_text = "";
				for (int i = 0; i < a_texts.length; i++) {
				    a_text += "<span onclick='editPopup(" + a_CxnItemIDs[i] + ")' class='link'>" + a_texts[i];

				    if (StringUtil.checkNull(item.get("a_text")) != "") {
				        a_text += "<img class='mgL8' src='/cmm/common/images/btn_file_del.png' style='width:12px; cursor:pointer;' onclick='event.stopPropagation(); delConnection(" + a_ItemIDs[i] + ", " + itemID + ")'>";
				    }

				    a_text += "</span><br>";
				}
				jsonObject.put("a_text", a_text);

				// S
				String s_texts[] = StringUtil.checkNull(item.get("s_text")).split(split);
				String s_ItemIDs[] = StringUtil.checkNull(item.get("s_ItemID")).split(split);
				String s_CxnItemIDs[] = StringUtil.checkNull(item.get("s_CxnItemID")).split(split);
				String s_text = "";
				for (int i = 0; i < s_texts.length; i++) {
				    s_text += "<span class='link'>" + s_texts[i];

				    if (StringUtil.checkNull(item.get("s_text")) != "") {
				        s_text += "<img class='mgL8' src='/cmm/common/images/btn_file_del.png' style='width:12px; cursor:pointer;' onclick='event.stopPropagation(); delConnection(" + s_ItemIDs[i] + ", " + itemID + ")'>";
				    }

				    s_text += "</span><br>";
				}
				jsonObject.put("s_text", s_text);

				// I
				String i_texts[] = StringUtil.checkNull(item.get("i_text")).split(split);
				String i_ItemIDs[] = StringUtil.checkNull(item.get("i_ItemID")).split(split);
				String i_CxnItemIDs[] = StringUtil.checkNull(item.get("i_CxnItemID")).split(split);
				String i_text = "";
				System.out.println("i_texts.length : " + i_texts.length);
				for (int i = 0; i < i_texts.length; i++) {
				    i_text += "<span class='link'>" + i_texts[i];

				    if (StringUtil.checkNull(item.get("i_text")) != "") {
				        i_text += "<img class='mgL8' src='/cmm/common/images/btn_file_del.png' style='width:12px; cursor:pointer;' onclick='event.stopPropagation(); delConnection(" + i_ItemIDs[i] + ", " + itemID + ")'>";
				    }

				    i_text += "</span><br>";
				}
				jsonObject.put("i_text", i_text);

				// C
				String c_texts[] = StringUtil.checkNull(item.get("c_text")).split(split);
				String c_ItemIDs[] = StringUtil.checkNull(item.get("c_ItemID")).split(split);
				String c_CxnItemIDs[] = StringUtil.checkNull(item.get("c_CxnItemID")).split(split);
				String c_text = "";
				for (int i = 0; i < c_texts.length; i++) {
				    c_text += "<span class='link'>" + c_texts[i];

				    if (StringUtil.checkNull(item.get("c_text")) != "") {
				        c_text += "<img class='mgL8' src='/cmm/common/images/btn_file_del.png' style='width:12px; cursor:pointer;' onclick='event.stopPropagation(); delConnection(" + c_ItemIDs[i] + ", " + itemID + ")'>";
				    }

				    c_text += "</span><br>";
				}
				jsonObject.put("c_text", c_text);

			}
			res.getWriter().print(jsonObject);
			
	    } catch (Exception e) {
	        e.printStackTrace();
	        jsonObject.put("list", new ArrayList<>());
	        res.getWriter().print(jsonObject);
	    }
	}
	
	@RequestMapping(value = "/zSKON_getProcessActivity.do", method = RequestMethod.GET)
	public void zSKON_getProcessActivity(HttpServletRequest request, HttpServletResponse res) throws Exception {
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

	        
	        List<Map<String, Object>> activityList = commonService.selectList("zSK_SQL2.getProcessActivity_gridList", map); 
	        jsonObject.put("list", activityList);
	        
	        res.getWriter().print(jsonObject);
			
	    } catch (Exception e) {
	        e.printStackTrace();
	        jsonObject.put("list", new ArrayList<>());
	        res.getWriter().print(jsonObject);
	    }
	}
	
	@RequestMapping(value="/zSKON_MindMap.do")
	public String zSKON_MindMap(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		
		String url = "";

		if ("Y".equals(StringUtil.checkNull(request.getParameter("TsdYN")))) {
			url="/custom/sk/skon/item/tsd/cxnMindMap"; 
		}else if ("N".equals(StringUtil.checkNull(request.getParameter("TsdYN")))) {
			url="/custom/sk/skon/item/process/cxnMindMap";
		}

		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			Map setData = new HashMap();
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			setData.put("s_itemID", s_itemID);
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			Map itemInfo = commonService.select("attr_SQL.getItemNameInfo", setData);
			List diagramList = new ArrayList();
			List rightItems = new ArrayList();
			List leftItems = new ArrayList();

			// Clicked Item START ========================
			Map itemMap = new HashMap();
			itemMap.put("id", s_itemID);
			itemMap.put("text", StringUtil.checkNull(itemInfo.get("Identifier")) + " " + StringUtil.checkNull(itemInfo.get("PlainText")));
			itemMap.put("fill", "#0288D1");
			itemMap.put("fontColor", "FFFFFF");
			itemMap.put("stroke", "#0288D1");
			diagramList.add(itemMap);

			setData.put("showElement", "Y");
			setData.put("mdlIF", "Y");
			// Clicked Item END ========================

			// TSD START ============
			setData.put("Classode", "CL16004");
			List tsdList = (List) commonService.selectList("zSK_SQL.getCxnItemListModel_gridList", setData);

			if(tsdList.size()>0) {
				// rigthItems
				itemMap = new HashMap();
				itemMap.put("id", "TXT_TSD_" + s_itemID);
				itemMap.put("text", "Tech_Std");
				itemMap.put("parent", s_itemID);
				itemMap.put("fill", "#a5a5a5");
				itemMap.put("fontColor", "FFFFFF");
				itemMap.put("stroke", "#a5a5a5");
				diagramList.add(itemMap);

				for (int i=0; i<tsdList.size(); i++) {
					List classList = new ArrayList();
					List classNameList = new ArrayList();
					Map tsd = (Map)tsdList.get(i);

					itemMap = new HashMap();
					itemMap.put("id", StringUtil.checkNull(tsd.get("s_itemID")));
					itemMap.put("text", StringUtil.checkNull(tsd.get("Identifier"))+ " " + StringUtil.checkNull(tsd.get("ItemName")));
					itemMap.put("parent", "TXT_TSD_" + s_itemID);
					itemMap.put("fill", "#11B3A5");
					itemMap.put("fontColor", "#FFFFFF");
					itemMap.put("stroke", "#11B3A5");
					diagramList.add(itemMap);
					rightItems.add(String.valueOf("‘" + tsd.get("s_itemID")) + "‘");
				}
			}
			// TSD END ========================

			//  Process START ========================
			setData.remove("ClassCode");
			setData.put("ItemTypeCode", "OJ00001");
			List processList = (List) commonService.selectList("zSK_SQL.getCxnItemListModel_gridList", setData);

			if(processList.size()>0) {
				// leftItems
				itemMap = new HashMap();
				itemMap.put("id", "TXT_PROC_" + s_itemID);
				itemMap.put("text", "Process");
				itemMap.put("parent", s_itemID);
				itemMap.put("fill", "#a5a5a5");
				itemMap.put("fontColor", "FFFFFF");
				itemMap.put("stroke", "#a5a5a5");
				diagramList.add(itemMap);

				for (int i=0; i<processList.size(); i++) {
					List classList = new ArrayList();
					List classNameList = new ArrayList();
					Map process = (Map)processList.get(i);

					itemMap = new HashMap();
					itemMap.put("id", StringUtil.checkNull(process.get("s_itemID")));
					itemMap.put("text", StringUtil.checkNull(process.get("Identifier"))+ " " + StringUtil.checkNull(process.get("ItemName")));
					itemMap.put("parent", "TXT_PROC_" + s_itemID);
					itemMap.put("fill", "#ff9800");
					itemMap.put("fontColor", "#FFFFFF");
					itemMap.put("stroke", "#ff9800");
					diagramList.add(itemMap);
					leftItems.add(String.valueOf("‘" + process.get("s_itemID")) + "‘");
				}
			}
			// Process END ========================

			// Rule START ========================
			setData.remove("ClassCode");
			setData.put("ItemTypeCode", "OJ00007");
			List ruleList = (List) commonService.selectList("zSK_SQL.getCxnItemListModel_gridList", setData);

			if(ruleList.size()>0) {
				// rigthItems
				itemMap = new HashMap();
				itemMap.put("id", "TXT_RULE_" + s_itemID);
				itemMap.put("text", "Rule");
				itemMap.put("parent", s_itemID);
				itemMap.put("fill", "#a5a5a5");
				itemMap.put("fontColor", "FFFFFF");
				itemMap.put("stroke", "#a5a5a5");
				diagramList.add(itemMap);

				for (int i=0; i<ruleList.size(); i++) {
					List classList = new ArrayList();
					List classNameList = new ArrayList();
					Map rule = (Map)ruleList.get(i);

					itemMap = new HashMap();
					itemMap.put("id", StringUtil.checkNull(rule.get("s_itemID")));
					itemMap.put("text", StringUtil.checkNull(rule.get("Identifier"))+ " " + StringUtil.checkNull(rule.get("ItemName")));
					itemMap.put("parent", "TXT_RULE_" + s_itemID);
					itemMap.put("fill", "#018B80");
					itemMap.put("fontColor", "#FFFFFF");
					itemMap.put("stroke", "#018B80");
					diagramList.add(itemMap);
					rightItems.add(String.valueOf("‘" + rule.get("s_itemID")) + "‘");
				}
			}
			// Rule END ========================

			// E2E START ========================
			setData.remove("ClassCode");
			setData.put("ItemTypeCode", "OJ00014");
			List e2eList = (List) commonService.selectList("zSK_SQL.getCxnItemListModel_gridList", setData);

			if(e2eList.size()>0) {
				// leftItems
				itemMap = new HashMap();
				itemMap.put("id", "TXT_E2E_" + s_itemID);
				itemMap.put("text", "E2E");
				itemMap.put("parent", s_itemID);
				itemMap.put("fill", "#a5a5a5");
				itemMap.put("fontColor", "FFFFFF");
				itemMap.put("stroke", "#a5a5a5");
				diagramList.add(itemMap);

				for (int i=0; i<e2eList.size(); i++) {
					List classList = new ArrayList();
					List classNameList = new ArrayList();
					Map e2e = (Map)e2eList.get(i);

					itemMap = new HashMap();
					itemMap.put("id", StringUtil.checkNull(e2e.get("s_itemID")));
					itemMap.put("text", StringUtil.checkNull(e2e.get("Identifier"))+ " " + StringUtil.checkNull(e2e.get("ItemName")));
					itemMap.put("parent", "TXT_E2E_" + s_itemID);
					itemMap.put("fill", "#EA8F00");
					itemMap.put("fontColor", "#FFFFFF");
					itemMap.put("stroke", "#EA8F00");
					diagramList.add(itemMap);
					leftItems.add(String.valueOf("‘" + e2e.get("s_itemID")) + "‘");
				}
			}
			// E2E END ========================

			 JSONArray diagramListData = new JSONArray(diagramList);
			 model.put("diagramListData", diagramListData);
			 
			 model.put("leftItems", leftItems);
			 model.put("rightItems", rightItems);
						
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/zSKON_searchCRList.do")
	public String zSKON_searchCRList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

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

			OccAttrInfo.put("itemID", s_itemID);
			String classCode = commonService.selectString("item_SQL.getClassCode", OccAttrInfo);
			
			String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
			String dimTypeList = StringUtil.checkNull(request.getParameter("dimTypeList"));

			model.put("classCode", classCode);
			model.put("fltpCode", fltpCode);
			model.put("dimTypeList", dimTypeList);

			OccAttrInfo.put("classCode", classCode);
			OccAttrInfo.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			OccAttrInfo.put("option", StringUtil.checkNull(request.getParameter("option")));
			OccAttrInfo.put("filterType", fiterType);
			OccAttrInfo.put("TreeDataFiltered", treeDataFilterd);
			OccAttrInfo.put("showTOJ", showTOJ);
			OccAttrInfo.put("showElement", showElement);
			OccAttrInfo.put("sessionParamSubItems", StringUtil.checkNull(commandMap.get("sessionParamSubItems")));
			OccAttrInfo.put("defClassList", "CL07004");
			model.put("defClassList", "CL07004");
			
			String accMode = StringUtil.
					replaceFilterString(StringUtil.checkNull(commandMap.get("accMode")));
			OccAttrInfo.put("accMode", StringUtil.checkNull(commandMap.get("accMode")));
			model.put("accMode", accMode);

			List subItemList = null;
			subItemList = commonService.selectList("zSK_SQL.getRuleSubList_gridList", OccAttrInfo);
			
			JSONArray gridData = new JSONArray(subItemList);
			model.put("gridData", gridData);

		} catch (Exception e) { 
			System.out.println(e.toString());
		}
		return nextUrl("/custom/sk/skon/item/rule/searchCRList");
	}
	
	@RequestMapping({ "/zSKON_createMTRInfo.do" })
	public String zskon_createMTRInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
			Map setValue = new HashMap();
			Map insertCngMap = new HashMap();
			Map updateData = new HashMap();

			String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"));
			String fromItemID = StringUtil.checkNull(commandMap.get("parentID"));
			String classCode = StringUtil.checkNull(request.getParameter("classCode"));
			String cpItemID = StringUtil.checkNull(commandMap.get("cpItemID"));
			String mstSTR = StringUtil.checkNull(commandMap.get("mstSTR"));
			String ItemID = commonService.selectString("item_SQL.getItemMaxID", setMap);
			String identifier = "";
			String preFix = "";
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
			
			/** AutoID start **/
			preFix = "MTR";
			String idLength = "";
			
			Map IdentifierMap = new HashMap();
			IdentifierMap.put("preFix", preFix);
			identifier = StringUtil.checkNull(commonService.selectString("item_SQL.getMaxPreFixIdentifier", IdentifierMap));
			for(int i=0; 5-identifier.length() > i; i++){
				idLength = idLength + "0";
			}
			
			if(identifier.equals("")){
				identifier = preFix + "0000001";
			}else{
				identifier = preFix + idLength + identifier;
			}
			
			setMap.put("Identifier", identifier);
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
			attrTypeCodes.put("AT00001", "AT00001");	// 문서명
			
			attrTypeCodes.put("ZAT03010", "ZAT03010");  // 불량등급
			attrTypeCodes.put("ZAT03011", "ZAT03011");	// 불량유형
			attrTypeCodes.put("ZAT03220", "ZAT03220");	// 작성자(검출)
		
			attrTypeCodes.put("ZAT09006", "ZAT09006");  // Line
			attrTypeCodes.put("ZAT03020", "ZAT03020"); 	// 호기
			attrTypeCodes.put("ZAT09005", "ZAT09005"); 	// Model
	
			attrTypeCodes.put("ZAT03050", "ZAT03050"); 	// 검출 - 공정
			attrTypeCodes.put("ZAT03060", "ZAT03060");  // 검출 - 방법

			attrTypeCodes.put("ZAT03100", "ZAT03100"); // 발견일시
			attrTypeCodes.put("ZAT03230", "ZAT03230"); // 발견일시 (시간)

			attrTypeCodes.put("ZAT03180", "ZAT03180"); // 현상
			
			attrTypeCodes.put("ZAT01070", "ZAT01070");	// 적용Site
			
			for (Map.Entry<String, String> entry : attrTypeCodes.entrySet()) {
			    String attrTypeCode = entry.getKey();
			    String formField = entry.getValue();
			    String formValue = StringUtil.checkNull(request.getParameter(formField));  
			    
			    setMap.put("PlainText", formValue);  
			    setMap.put("AttrTypeCode", attrTypeCode);

			    if (attrTypeCode.equals("ZAT03090")) {
			    	
			    	formValue = StringUtil.checkNull(commandMap.get("ZAT03090"));
			    	
			        String[] values = formValue.split("\\$\\$");  // 복수값 분리
			        for (String val : values) {
			            setMap.put("PlainText", val);
			            setMap.put("AttrTypeCode", attrTypeCode);
			            setMap.put("LovCode", val);

			            List getLanguageList = this.commonService.selectList("common_SQL.langType_commonSelect", setMap);
			            for (int i = 0; i < getLanguageList.size(); i++) {
			                Map getMap = (HashMap) getLanguageList.get(i);
			                setMap.put("languageID", getMap.get("CODE"));
			                this.commonService.insert("item_SQL.ItemAttr", setMap);
			            }
			        }
			    } else {
			        setMap.put("PlainText", formValue);
			        setMap.put("AttrTypeCode", attrTypeCode);
			        
			        if(attrTypeCode.equals("ZAT03010") || attrTypeCode.equals("ZAT03011") 
			            || attrTypeCode.equals("ZAT03130") || attrTypeCode.equals("ZAT03131") 
			            || attrTypeCode.equals("ZAT03132") || attrTypeCode.equals("ZAT03133")
			            || attrTypeCode.equals("ZAT01070")) {
			            setMap.put("LovCode", formValue);
			        } else {
			            setMap.remove("LovCode");
			        }

			        List getLanguageList = this.commonService.selectList("common_SQL.langType_commonSelect", setMap);
			        for (int i = 0; i < getLanguageList.size(); i++) {
			            Map getMap = (HashMap) getLanguageList.get(i);
			            setMap.put("languageID", getMap.get("CODE"));
			            this.commonService.insert("item_SQL.ItemAttr", setMap);
			        }
			    }

			}


			/** 속성 insert end *****/
			
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
	
	@RequestMapping(value = "/getItemAttrLovCode.do", method = RequestMethod.GET)
	public void getItemAttrLovCode(HttpServletRequest request, HttpServletResponse res) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map<String, Object> map = new HashMap<>();

		res.setHeader("Cache-Control", "no-cache");
		res.setContentType("application/json");
	    res.setCharacterEncoding("UTF-8");
	    
		try {
			String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode"), "");
			
			map.put("itemID", itemID);
			map.put("languageID", languageID);
			map.put("attrTypeCode", attrTypeCode);

			String itemAttrLovCode = StringUtil.checkNull(this.commonService.selectString("item_SQL.getItemAttrLovCode", map));

		    res.getWriter().print(itemAttrLovCode != null ? itemAttrLovCode : ""); 
		    } catch (Exception e) {
		        e.printStackTrace();
		        res.getWriter().print("");
		    }
	}
	
	@RequestMapping("/setPopupToken.do")
	@ResponseBody
	public void setPopupToken(HttpServletRequest request) {
	    HttpSession session = request.getSession();
	    session.setAttribute("imagePopupToken", UUID.randomUUID().toString());
	}

	
	@RequestMapping("/zSKON_openImagePopup.do")
	public String zSKON_openImagePopup(HttpServletRequest request) {
	    HttpSession session = request.getSession();
	    String token = (String) session.getAttribute("imagePopupToken");

	    if (token == null) {
	        return "redirect:/accessDenied.jsp";
	    }

	    return nextUrl("/custom/sk/skon/item/mtr/imagePopup");
	}
	
	@RequestMapping("/zSKON_WFopenImagePopup.do")
	public String zSKON_WFopenImagePopup(HttpServletRequest request) {
	    HttpSession session = request.getSession();
	    String token = (String) session.getAttribute("imagePopupToken");

	    if (token == null) {
	        return "redirect:/accessDenied.jsp";
	    }

//	    return nextUrl("/custom/sk/skon/item/mtr/imagePopup"); //변경필요
	    return nextUrl("/custom/sk/skon/wf/wfImagePopup"); // 개발서버와 소스 동기화
	}

	@RequestMapping("/zSKON_TER1openImagePopup.do")
	public String zSKON_TER1openImagePopup(HttpServletRequest request) {
	    HttpSession session = request.getSession();
	    String token = (String) session.getAttribute("imagePopupToken");

	    if (token == null) {
	        return "redirect:/accessDenied.jsp";
	    }

	    return nextUrl("/custom/sk/skon/item/ter/imagePopup1"); 
	}
	
	@RequestMapping("/zSKON_TER2openImagePopup.do")
	public String zSKON_TER2openImagePopup(HttpServletRequest request) {
	    HttpSession session = request.getSession();
	    String token = (String) session.getAttribute("imagePopupToken");

	    if (token == null) {
	        return "redirect:/accessDenied.jsp";
	    }

	    return nextUrl("/custom/sk/skon/item/ter/imagePopup2"); 
	}
	
	
	
	@RequestMapping({ "/zSKON_createTERInfo.do" })
	public String zskon_createTERInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
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
			setMap.put("ItemID", ItemID); //maxItemID
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

			if (itemTypeCode.equals("")) {
				itemTypeCode = this.commonService.selectString("item_SQL.selectedItemTypeCode", setMap);
			}
			setMap.put("ItemTypeCode", itemTypeCode);

			setMap.put("AuthorID", StringUtil.checkNull(commandMap.get("sessionUserId")));
			setMap.put("IsPublic", StringUtil.checkNull(request.getParameter("IsPublic")));
			setMap.put("ProjectID", projectID);
			setMap.put("RefItemID", StringUtil.checkNull(request.getParameter("refItemID")));
			setMap.put("Status", "NEW1");

			setMap.put("itemId", StringUtil.checkNull(request.getParameter("s_itemID"))); //s_itemID

			this.commonService.insert("item_SQL.insertItem", setMap);
			setMap.remove("CurChangeSet");
			/** item insert end *****/
			
			/** 속성 insert start *****/
			Map<String, String> attrTypeCodes = new HashMap<>();
			attrTypeCodes.put("AT00001", "AT00001");  // 보고제목
			attrTypeCodes.put("ZAT01010", "ZAT01010");//관리 site정보 
			attrTypeCodes.put("ZAT03260", "ZAT03260");  // 공정(기술문서)
			attrTypeCodes.put("AT01007",  "AT01007"); // 키워드
			
			for (Map.Entry<String, String> entry : attrTypeCodes.entrySet()) {
			    String attrTypeCode = entry.getKey();
			    String formField = entry.getValue();
			    String formValue = StringUtil.checkNull(request.getParameter(formField));
	
			    setMap.put("PlainText", formValue);  
			    setMap.put("AttrTypeCode", attrTypeCode);
			    
			    if(attrTypeCode.equals("ZAT03260")) {
			    	setMap.put("LovCode", formValue);
			    }else {
		            setMap.remove("LovCode");
		        }
			    
			    List getLanguageList = this.commonService.selectList("common_SQL.langType_commonSelect", setMap);
			    for (int i = 0; i < getLanguageList.size(); i++) {
			        Map getMap = (HashMap) getLanguageList.get(i);
			        setMap.put("languageID", getMap.get("CODE"));
			        this.commonService.insert("item_SQL.ItemAttr", setMap);
			    }
			}
			
			String attrTypeCodesParam = request.getParameter("attrTypeCodes");
			List<String> attrCodes = new ArrayList<>();
			if (attrTypeCodesParam != null && !attrTypeCodesParam.isEmpty()) {
			    attrCodes = Arrays.asList(attrTypeCodesParam.split(",")); 
			}
			
			for (String code : attrCodes) {
			    if (code.contains(":")) {
			        String[] parts = code.split(":");
			        String typeCode = parts[0];
			        String[] values = parts[1].split("\\$\\$");

			        for (String val : values) {
			            setValue.put("AttrTypeCode", typeCode);
			            setValue.put("LovCode", val);
			            setValue.put("PlainText", val);
			            setValue.put("ClassCode", classCode);
			            setValue.put("ItemID", ItemID); //maxItemID
			            setValue.put("itemId", StringUtil.checkNull(request.getParameter("s_itemID"))); //s_itemID

			            List getLanguageListM = this.commonService.selectList("common_SQL.langType_commonSelect", setValue);
			            for (int i = 0; i < getLanguageListM.size(); i++) {
			                Map getMap = (HashMap) getLanguageListM.get(i);
			                setValue.put("languageID", getMap.get("CODE"));
			                this.commonService.insert("item_SQL.ItemAttr", setValue);
			            }
			        }
			    }
			}
			/** 속성 insert end *****/
			
			
			/** 채번 Update start**/
			if (docIdentifier.equals("")) { //문서 채번이 안되있는경우 
				//setMap.put("ItemID",ItemID);
				//setMap.put("ClassCode", classCode);
				setMap.put("docSiteVal", request.getParameter("ZAT01010")); // = site
				setMap.put("languageID", request.getParameter("languageID"));
				
				String newDocIdenfier = StringUtil.checkNull(this.commonService.selectString("zSK_SQL2.fn_TERcreateItemIdentifier", setMap));
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
	
	// 개발서버와 소스 동기화
	@RequestMapping(value = "/olmapi/getItemClassCode", method = RequestMethod.GET)
	@ResponseBody
	public void getItemClassCode (HttpServletRequest req, HttpServletResponse res, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map<Object, Object> setMap = new HashMap<>();
		res.setHeader("Cache-Control", "no-cache");	
		res.setContentType("text/plain");	
		res.setCharacterEncoding("UTF-8");	
		try {
			String s_itemID = StringUtil.checkNull(req.getParameter("s_itemD"), "");		
			setMap.put("s_itemID", s_itemID);		
			String classCode = this.commonService.selectString("item_SQL.selectedItemClassCode", setMap);		
			res.getWriter().print((classCode == null) ? "" : classCode);
		} catch (Exception e) {	
			System.out.println(e.toString());	
			res.getWriter().print("");	
		}
	}
}