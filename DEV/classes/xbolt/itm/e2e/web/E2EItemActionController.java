package xbolt.itm.e2e.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.service.CommonService;

/**
 * 업무 처리
 * 
 * @Class Name : BizController.java
 * @Description : 업무화면을 제공한다.
 * @Modification Information
 * @수정일 수정자 수정내용
 * @--------- --------- -------------------------------
 * @2012. 09. 01. smartfactory 최초생성
 * 
 * @since 2012. 09. 01.
 * @version 1.0
 */

@Controller
@SuppressWarnings("unchecked")
public class E2EItemActionController extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "e2eItemService")
	private CommonService e2eItemService;

	// 프로세스 - 관련 프로세스 Tree List
	@RequestMapping(value = "/e2eCreateTreeList.do")
	public String e2eCreateTreeList(HttpServletRequest request,HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/itm/e2e/e2eCreateTreeList";
		try {
			String s_itemID = "";
			String setID = "";
			if (!StringUtil.checkNull(request.getParameter("subID"), "").equals("")) {
				s_itemID = StringUtil.checkNull(request.getParameter("subID"), "");
				setID = StringUtil.checkNull(request.getParameter("subID"), "");
			} else {
				s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
				setID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			}
			
			String option = StringUtil.checkNull(request.getParameter("ArcCode"), "");
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", setID);
			model.put("option", option);
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/e2eTreeListPop.do")
	public String e2eTreeListPop(HttpServletRequest request, HashMap cmmMap,  ModelMap model) throws Exception{
		try{			
			String ItemID = StringUtil.checkNull(request.getParameter("ItemID"),"");
			String newModelName = StringUtil.checkNull(request.getParameter("newModelName"),"");
			String MTCTypeCode = StringUtil.checkNull(request.getParameter("MTCTypeCode"),"");
			String ModelTypeCode = StringUtil.checkNull(request.getParameter("ModelTypeCode"),"");
			String ItemTypeCode = StringUtil.checkNull(request.getParameter("ItemTypeCode"),"");
			String modelID = StringUtil.checkNull(request.getParameter("modelID"));
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"));
			String positionX = StringUtil.checkNull(request.getParameter("positionX"));
			String positionY = StringUtil.checkNull(request.getParameter("positionY"));
			String unfold = StringUtil.checkNull(cmmMap.get("unfold"));
			
			model.put("option", StringUtil.checkNull(cmmMap.get("option")));
			model.put("ItemID", ItemID);
			model.put("newModelName", newModelName);
			model.put("MTCTypeCode", MTCTypeCode);
			model.put("ModelTypeCode", ModelTypeCode);
			model.put("ItemTypeCode", ItemTypeCode);
			model.put("modelID", modelID);
			model.put("scrnType", scrnType);
			model.put("positionX", positionX);
			model.put("positionY", positionY);
			model.put("unfold", unfold);
			
		}catch (Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/itm/e2e/e2eTreeListPop");
		//return nextUrl("/popup/allItemTreePop");
	}

	@RequestMapping(value="/e2eCreateTreeListModel.do")
	public String e2eCreateTreeListModel(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
				String ItemID = StringUtil.checkNull(request.getParameter("ItemID"),"");
				String e2eItmeIDS = StringUtil.checkNull(request.getParameter("e2eItmeIDS"),"");
				String newModelName = StringUtil.checkNull(request.getParameter("newModelName"),"");
				String MTCTypeCode = StringUtil.checkNull(request.getParameter("MTCTypeCode"),"");
				String ModelTypeCode = StringUtil.checkNull(request.getParameter("ModelTypeCode"),"");
				
				Map setMap = new HashMap();
				setMap.put("ItemID", ItemID);
				setMap.put("e2eItemIDS", e2eItmeIDS);
				setMap.put("newModelName", newModelName);
				setMap.put("MTCTypeCode", MTCTypeCode);
				setMap.put("ModelTypeCode", ModelTypeCode);
				setMap.put("sessionUserId", cmmMap.get("sessionUserId"));
				setMap.put("defFontFamily", cmmMap.get("sessionDefFont"));
				setMap.put("defFontSize", cmmMap.get("sessionDefFontSize"));
				setMap.put("defFontColor", cmmMap.get("sessionDefFontColor"));
				setMap.put("defFontStyle", cmmMap.get("sessionDefFontStyle"));
				setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
				
				setMap.put("GUBUN", "insertE2eModel");
				e2eItemService.save(setMap);
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "callbackSave("+setMap.get("ModelID")+");");
				
		} catch (Exception e) {
			System.out.println("TEST1 ==> " + e.toString());
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/createE2eModelPop.do")
	public String createE2eModelPop(HttpServletRequest request,  ModelMap model) throws Exception{
		try{
			Map setData = new HashMap();
			String ItemTypeCode = StringUtil.checkNull(request.getParameter("ItemTypeCode"),"");
			String ItemID = StringUtil.checkNull(request.getParameter("ItemID"),"");
			
			setData.put("arcCode","AR000000");
			String arcFilter = commonService.selectString("menu_SQL.getArcFilter", setData);
			model.put("arcFilter", arcFilter);
			model.put("ItemTypeCode", ItemTypeCode);
			model.put("ItemID", ItemID);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
	
		}catch (Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/itm/e2e/createE2eModelPop");
	}
	
	@RequestMapping(value="/addObjectToDiagram.do")
	public String addObjectToDiagram(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
				String ItemID = StringUtil.checkNull(request.getParameter("ItemID"),"");
				String e2eItmeIDS = StringUtil.checkNull(request.getParameter("e2eItmeIDS"),"");				
				String modelID = StringUtil.checkNull(request.getParameter("modelID"));
				String positionX = StringUtil.checkNull(request.getParameter("positionX"));
				String positionY = StringUtil.checkNull(request.getParameter("positionY"));
				String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"),"");
				
				Map setMap = new HashMap();
				setMap.put("ItemID", ItemID);
				setMap.put("e2eItemIDS", e2eItmeIDS);
				setMap.put("sessionUserId", cmmMap.get("sessionUserId"));
				setMap.put("defFontFamily", cmmMap.get("sessionDefFont"));
				setMap.put("defFontSize", cmmMap.get("sessionDefFontSize"));
				setMap.put("defFontColor", cmmMap.get("sessionDefFontColor"));
				setMap.put("defFontStyle", cmmMap.get("sessionDefFontStyle"));
				setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
				setMap.put("modelID", modelID);
				setMap.put("positionX", positionX);
				setMap.put("positionY", positionY);
				setMap.put("itemTypeCode", itemTypeCode);
				
				setMap.put("GUBUN", "addObjectToDiagram");
				e2eItemService.save(setMap);
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "fnCallbackSave();");
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
}
