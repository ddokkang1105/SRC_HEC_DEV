package xbolt.adm.cfg;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.org.json.JSONArray;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;

@Controller
@SuppressWarnings("unchecked")
public class AttrTypeActionController extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/DefineAttributeType.do")
	public String DefineAttributeType(HttpServletRequest request, ModelMap model, HashMap commandMap) throws Exception {
		try {
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("pageNum", request.getParameter("pageNum"));
			commandMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
			
			List attrList = commonService.selectList("AttributeType_SQL.getDefineAttrList_gridList", commandMap);
			JSONArray gridData = new JSONArray(attrList);
			model.put("gridData",gridData);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/master data/DefineAttributeTypeGrid");
	}
	
	@RequestMapping(value="/getAttrTypeList.do")
	public void getFileTypeList(HttpServletRequest request,  HashMap commandMap,HttpServletResponse response) throws Exception{
		try{	
			commandMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
			List attrList = commonService.selectList("AttributeType_SQL.getDefineAttrList_gridList", commandMap);
			JSONArray gridData = new JSONArray(attrList);
			
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/plain");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().print(gridData);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
	}
	
	/**
	 * AttributeType Detail
	 * @param request
	 * @param commadMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/AttributeTypeView.do")
	public String AttributeTypeView(HttpServletRequest request, HashMap commadMap, ModelMap model) throws Exception{
		HashMap getMap = new HashMap();
		try{
			
			String defalutlang = commonService.selectString("item_SQL.getDefaultLang", getMap);
			getMap.put("AttrTypeCode", request.getParameter("itemID"));
			
			if ("1".equals(StringUtil.checkNull(request.getParameter("isComLang")))) {
				getMap.put("LanguageID", defalutlang);
			} else {
				getMap.put("LanguageID", StringUtil.checkNull(request.getParameter("getLanguageID"), String.valueOf(commadMap.get("sessionCurrLangType"))));
			}
			getMap = (HashMap)commonService.select("AttributeType_SQL.AttrReload", getMap);
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("resultMap", getMap);	
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("defalutlang", defalutlang);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}		
		return nextUrl("/adm/configuration/master data/AttributeTypeView");
	
	}
	
	/**
	 * AttributeType Insert
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/saveAttribute.do")
	public String saveAttributeType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			getMap.put("Creator", commandMap.get("sessionUserId"));
			getMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
			getMap.put("AttrTypeCode", request.getParameter("objType"));
			getMap.put("TypeCode", request.getParameter("objType"));
			getMap.put("Name", request.getParameter("objName"));
			getMap.put("DataType", request.getParameter("DataType"));
			getMap.put("Description", request.getParameter("objDescription"));
			getMap.put("Category", StringUtil.checkNull(request.getParameter("AT"), "AT"));
			  
			commonService.insert("AttributeType_SQL.insertAttributeType", getMap);
			commonService.insert("AttributeType_SQL.insertAttrDictonary", getMap);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();");
		
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
		
	/**
	 * AttributeType update
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/updateAttribute.do")
	public String updateAttribute(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			
			Map getMap = new HashMap();

			getMap.put("AttrTypeCode", request.getParameter("objAttrTypeCode"));
			getMap.put("TypeCode", request.getParameter("objAttrTypeCode"));
			getMap.put("Name", request.getParameter("objName"));
			getMap.put("DataType", request.getParameter("DataType"));
			getMap.put("Creator", request.getParameter("orgCreator"));
			getMap.put("HTML", request.getParameter("objHTML"));
			getMap.put("IsComLang", request.getParameter("objIsComLang"));
			getMap.put("Editable", request.getParameter("objEditable"));
			getMap.put("LastUpdated", request.getParameter("objLastUpdated"));
			getMap.put("Description", request.getParameter("objDescription"));
			getMap.put("LanguageID", request.getParameter("getLanguageID"));			
			getMap.put("Category", StringUtil.checkNull(request.getParameter("AT"), "AT"));
			getMap.put("attrCategory", StringUtil.checkNull(request.getParameter("attrCategory")));
			getMap.put("subAttrTypeCode", StringUtil.checkNull(request.getParameter("subAttrTypeCode")));
							
			String checkNew = StringUtil.checkNull(commonService.selectString("AttributeType_SQL.selectDictionary", getMap), "");
			
			if(checkNew.equals("")){
				commonService.insert("AttributeType_SQL.insertAttrDictonary",getMap);
			} else {	
				commonService.update("AttributeType_SQL.updateAttributeType", getMap);
				commonService.update("AttributeType_SQL.updateAttrDictonary", getMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.AttrReload();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	// AttributeType update 부분 END
	
	/**
	 * AttributeType delect
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/delAttributeType.do")
	public String delAttributeType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			
			String[] arrayCode = StringUtil.checkNull(request.getParameter("attrTypeCodes")).split(",");
			
			for (int i = 0; arrayCode.length > i ; i++) {
				getMap.put("AttrTypeCode", arrayCode[i]);
				getMap.put("TypeCode", arrayCode[i]);
				
				commonService.delete("AttributeType_SQL.deleteAttributeType",getMap);
				commonService.delete("config_SQL.delDic",getMap);
			}
		
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			target.put(AJAX_SCRIPT,"this.urlReload();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
		
	}

	// AttributeType delect END
	/**
	 * saveListOfValue Insert
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveListOfValue.do")
	public String saveListOfValue(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			getMap.put("LovCode", request.getParameter("LovID"));
			getMap.put("Value", request.getParameter("LovValue").replaceAll("<and>", "&"));
			getMap.put("LanguageID", request.getParameter("languageID"));
			getMap.put("AttrTypeCode", request.getParameter("TypeCode"));
			getMap.put("LinkFilter", request.getParameter("LinkFilter"));
			
			String LovIdCount = commonService.selectString("AttributeType_SQL.lovIdEqualCount", getMap);
			// 동일LovCode 중복 시, 메세지 표시 하고 처리를 중단함
				if (!LovIdCount.equals("0")) {
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00081", new String[]{"Code"}));
					target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
				} else {
					commonService.insert("AttributeType_SQL.insertLOV",getMap);			
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
					target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();");
				}
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
		
	}
	
	/**
	 * AttributeTypeLov delect
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/delListOfValue.do")
	public String delListOfValue(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			
			String[] arrayCode = StringUtil.checkNull(request.getParameter("lovCodes")).split(",");
			
			for (int i = 0; arrayCode.length > i ; i++) {
				getMap.put("LovCode", arrayCode[i]);
				getMap.put("AttrTypeCode", request.getParameter("TypeCode"));
				getMap.put("languageID", request.getParameter("languageID"));
				commonService.delete("AttributeType_SQL.deleteLOV",getMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			target.put(AJAX_SCRIPT,"this.urlReload("+ request.getParameter("languageID")+ ");this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 삭제중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
		// return nextUrl("/adm/configuration/DefineObjectType");
	}

	// AttributeType delect END
	
	/**
	 * AttributeTypeLov update
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateListOfValue.do")
	public String updateListOfValue(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			
			Map getMap = new HashMap();
			getMap.put("RefLovCode", request.getParameter("RefLovCode"));
			getMap.put("LovCode", request.getParameter("LovCode"));
			getMap.put("Value", request.getParameter("LovValue"));
			getMap.put("LanguageID", request.getParameter("getLanguageID"));
			getMap.put("AttrTypeCode", request.getParameter("AttrTypeCode"));
			getMap.put("LinkFilter", request.getParameter("LinkFilter"));
			
			String checkNew = StringUtil.checkNull(commonService.selectString("AttributeType_SQL.selectLov", getMap), "");
			/*if(request.getParameter("BeforeLovValue").equals("")){*/
			if (checkNew.equals("")) {
				commonService.insert("AttributeType_SQL.insertLOV", getMap);
			} else {						
				commonService.update("AttributeType_SQL.updateLOV", getMap);
			}	
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "this.urlReload("+request.getParameter("getLanguageID")+");this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
		
	}
	
	@RequestMapping(value = "/SubListOfValue.do")
	public String SubListOfValue(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/master data/SubListOfValue";
		try {
			Map setMap = new HashMap();
			String attrTypeCode = StringUtil.checkNull(request.getParameter("s_itemID"));
			String LanguageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));

			setMap.put("attrTypeCode", attrTypeCode);
			String refAttrTypeCode = StringUtil.checkNull(commonService.selectString("attr_SQL.getRefAttrTypeCode",setMap));
			
			setMap.put("LanguageID", LanguageID);
			setMap.put("TypeCode", attrTypeCode);
	        List attrLOVList = commonService.selectList("config_SQL.getSubListOfValueCode_gridList", setMap);
	        JSONArray gridData = new JSONArray(attrLOVList);
	        model.put("gridData",gridData);	
			
			model.put("refAttrTypeCode", refAttrTypeCode);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("DataType", request.getParameter("DataType"));
			model.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
			model.put("pageNum", request.getParameter("pageNum"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/AddListOfValuePop.do")
	public String AddListOfValuePop(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception{
		try{
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		
			model.put("languageID", request.getParameter("languageID"));
			model.put("TypeCode", request.getParameter("TypeCode"));
			
		}catch(Exception e){
			System.out.println(e.toString());
		}		
		return nextUrl("/popup/AddListOfValuePop");
	}
	

}
