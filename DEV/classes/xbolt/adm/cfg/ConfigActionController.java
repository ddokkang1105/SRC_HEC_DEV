package xbolt.adm.cfg;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.lang3.StringEscapeUtils;
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
 * 怨듯넻 �꽌釉붾┸ 泥섎━
 * 
 * @Class Name : ConfigActionController.java
 * @Description : 諛고룷�솕硫댁쓣 �젣怨듯븳�떎.
 * @Modification Information
 * @�닔�젙�씪 �닔�젙�옄 �닔�젙�궡�슜
 * @--------- --------- -------------------------------
 * @2013. 01. 23. jhAhn 理쒖큹�깮�꽦
 * 
 * @since 2013. 01. 23.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class ConfigActionController extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/DefineObjectType.do")
	public String DefineObjectType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			commandMap.put("categories","'OJ', 'REF','TXT','VAR','XOJ'");
			List objList = commonService.selectList("config_SQL.getObjectTypeInfo_gridList",commandMap);
			List classList = commonService.selectList("config_SQL.getAllocateClassList_gridList",commandMap);
			
			for(int i=0; i < classList.size(); i++) {
				objList.add(classList.get(i));
			}
			
			JSONArray treeGridData = new JSONArray(objList);
			model.put("treeGridData",treeGridData);
			
			model.put("selectedCat", request.getParameter("selectedCat"));
			model.put("selectedItemType", request.getParameter("selectedItemType"));
			
			model.put("cfgCode", commandMap.get("cfgCode"));
			
			List path = new ArrayList();
			String cfgCode = StringUtil.checkNull(commandMap.get("cfgCode"),"");
			
			path = getCFGMenuPath(cfgCode,StringUtil.checkNull(commandMap.get("sessionCurrLangType")),path, commandMap);
			
			Collections.reverse(path);
			model.put("path",path);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/master data/DefineObjectTypeGrid");
	}
	
	@RequestMapping(value="/getObjectAndClassList.do")
	public void getSubItemHistoryGridList(HttpServletRequest request,  HashMap commandMap,HttpServletResponse response) throws Exception{
		try{	
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			commandMap.put("categories","'OJ', 'REF','TXT','VAR','XOJ'");
			List objList = commonService.selectList("config_SQL.getObjectTypeInfo_gridList",commandMap);
			List classList = commonService.selectList("config_SQL.getAllocateClassList_gridList",commandMap);
			
			for(int i=0; i < classList.size(); i++) {
				objList.add(classList.get(i));
			}
			
			JSONArray treeGridData = new JSONArray(objList);
			
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/plain");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().print(treeGridData);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
	}
	
	@RequestMapping(value = "/boardManagement.do")
	public String boardManagement(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		try {
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("pageNum", request.getParameter("pageNum"));
		 		mapValue.put("languageID", mapValue.get("sessionCurrLangType"));
		 		List boardMList = commonService.selectList("config_SQL.getAllBoardMgtList_gridList", mapValue);
		 		JSONArray gridData = new JSONArray(boardMList);
		 		model.put("gridData",gridData);	
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/board/boardManagement");
	}

	@RequestMapping(value = "/defineTemplateGrid.do")
	public String defineTemplateGrid(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			model.put("languageID", request.getParameter("languageID"));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("cfgCode", StringUtil.checkNull(request.getParameter("cfgCode")));

			List<Map<String, String>> path = new ArrayList<Map<String, String>>();
			String cfgCode = StringUtil.checkNull(commandMap.get("cfgCode"), "");

			path = getCFGMenuPath(cfgCode, StringUtil.checkNull(commandMap.get("sessionCurrLangType")), path,commandMap);

			Collections.reverse(path);
			model.put("path", path);
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List<String> dtgList = commonService.selectList("config_SQL.getDefineTemplateCode_gridList", commandMap);

			JSONArray gridData = new JSONArray(dtgList);
			model.put("gridData", gridData);
			
			System.out.println("GRIDDATA: "+gridData);

			
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/menu/defineTemplateGrid");
		
	}

	@RequestMapping(value = "/DefineMenuTypeGrid.do")
	public String DefineMenuTypeGrid(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum")));
			
			List menuList = commonService.selectList("config_SQL.getDefineMenutypeCode_gridList", mapValue);
			JSONArray gridData = new JSONArray(menuList);
			model.put("gridData",gridData);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/menu/DefineMenuTypeGrid");
	}

	@RequestMapping(value = "/ReportType.do")
	public String ReportType(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"))); /* Label Setting */
			mapValue.put("languageID", mapValue.get("sessionCurrLangType"));
			
			List attrList = commonService.selectList("config_SQL.getReportTypeCode_gridList", mapValue);
			JSONArray gridData = new JSONArray(attrList);
			model.put("gridData",gridData);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/report/ReportType");
	}

	@RequestMapping(value = "/ObjClass.do")
	public String ObjClass(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/adm/configuration/sub/ObjClass";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/ObjConnectionType.do")
	public String ObjConnectionType(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/adm/configuration/sub/ObjConnectionType";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/arcSubMenu.do")
	public String arcSubMenu(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/adm/configuration/sub/arcSubMenu";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			model.put("ArcCode", StringUtil.checkNull(request.getParameter("ArcCode"), ""));
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/arcFilter.do")
	public String arcFilter(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/adm/configuration/menu/arcFilter";
		try {
			HashMap setMap = new HashMap();
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			//model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			model.put("ArcCode", StringUtil.checkNull(request.getParameter("ArcCode"), ""));
			model.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), ""));
			
			System.out.println("s_itemID:"+model.get("s_itemID"));
			
			setMap.put("ArcCode", model.get("ArcCode"));
			setMap.put("languageID", model.get("languageID"));
			
			List<String> arcFilterList = commonService.selectList("config_SQL.getArcFilterList_gridList",setMap);
			JSONArray gridData = new JSONArray(arcFilterList);
			model.put("gridData",gridData);
			
		
			
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/arcClass.do")
	public String arcClass(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/menu/arcClass";
		try {
			String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
	        commandMap.put("arcCode", arcCode);
	        commandMap.put("languageID", languageID);
	        
	        List arcClassList = commonService.selectList("config_SQL.getArcFilterClsList_gridList", commandMap);
	        JSONArray gridData = new JSONArray(arcClassList);
	        model.put("gridData",gridData);	
	        
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			model.put("arcCode", arcCode);
			model.put("languageID", languageID);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/arcDimension.do")
	public String arcDimention(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/menu/arcDimension";
		try {
			String arcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
	        commandMap.put("arcCode", arcCode);
	        commandMap.put("languageID", languageID);
	        
	        List arcDimList = commonService.selectList("config_SQL.getArcFilterDimList_gridList", commandMap);
	        JSONArray gridData = new JSONArray(arcDimList);
	        model.put("gridData",gridData);	
	        
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("languageID", languageID);
			model.put("arcCode", arcCode);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/SubAttributeTypeAllocation.do")
	public String SubAttributeTypeAllocation(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/adm/configuration/master data/SubAttributeTypeAllocation";
		try {
			HashMap<String, Comparable> setMap = new HashMap<String, Comparable>();
			
			String languageID = StringUtil.checkNull(request.getParameter("languageID"));
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", s_itemID);
			model.put("languageID", languageID);
			model.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			model.put("CategoryCode", request.getParameter("CategoryCode"));
			model.put("ClassName", request.getParameter("ClassName"));
			model.put("pageNum", request.getParameter("pageNum"));

			setMap.put("ItemClassCode", s_itemID);
			setMap.put("languageID", languageID);
			
			List<String> subAttrList = commonService.selectList("config_SQL.getClassAttrLocateList_gridList", setMap);
			JSONArray gridData = new JSONArray(subAttrList);
			model.put("gridData", gridData);
			
			
			
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	@RequestMapping(value = "/subArchitectureMenu.do")
	public String subArchitectureMenu(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/adm/configuration/menu/subArchitectureMenu";
		try {
			
				HashMap setMap = new HashMap();
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("languageID", request.getParameter("languageID"));
				model.put("templCode", request.getParameter("templCode"));
				model.put("pageNum", request.getParameter("pageNum"));
				model.put("viewType", request.getParameter("viewType"));
				
				setMap.put("templCode", request.getParameter("templCode"));
				setMap.put("languageID", request.getParameter("languageID"));
				
				List<String> subArcList = commonService.selectList("config_SQL.getArcTemplList_gridList", setMap);
				JSONArray gridData = new JSONArray(subArcList);
				model.put("gridData", gridData);
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/SubReportAllocation.do")
	public String SubReportAllocation(HttpServletRequest request, HashMap commandMap,ModelMap model) throws Exception {
		String url = "/adm/configuration/master data/SubReportAllocation";
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String classCode = StringUtil.checkNull(request.getParameter("classCode"));
			
			setMap.put("ClassCode", classCode);
			setMap.put("languageID", languageID);
	        List subRAList = commonService.selectList("config_SQL.getClassReportLocateList_gridList", setMap);
	        JSONArray gridData = new JSONArray(subRAList);
	        model.put("gridData",gridData);	
	        
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("classCode",classCode);
			model.put("languageID", request.getParameter("languageID"));
			model.put("ClassName", request.getParameter("ClassName"));
			model.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			model.put("CategoryCode", request.getParameter("CategoryCode"));
			model.put("pageNum", request.getParameter("pageNum"));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

		@RequestMapping(value = "/dictionaryMgtList.do")
		public String Dictionary(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
			try {
				mapValue.put("languageID", mapValue.get("sessionCurrLangType"));
	 			List dictionMList = commonService.selectList("dictionary_SQL.selectDictionaryCode_gridList", mapValue);
	 			JSONArray gridData = new JSONArray(dictionMList);
	 			model.put("menu", getLabel(request, commonService)); /* Label Setting */
	 			model.put("gridData",gridData);	
			} catch (Exception e) {
				System.out.println(e.toString());
			}
			return nextUrl("/adm/configuration/dictionary/dictionaryMgtList");
		}

	@RequestMapping(value = "/saveObject.do")
	public String saveObjectObjectTypeChild(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			getMap.put("ItemTypeCode", request.getParameter("objType"));
			getMap.put("FilePath", request.getParameter("objFilePath"));
			getMap.put("DefArchitecture", request.getParameter("objDeAcrh"));
			getMap.put("Category", StringUtil.checkNull(request.getParameter("OJ"), "OJ"));
			getMap.put("languageID", request.getParameter("languageID"));
			getMap.put("TypeCode", request.getParameter("objType"));
			getMap.put("Name", request.getParameter("objName"));
			getMap.put("Description", request.getParameter("objDec"));
			getMap.put("Creator", commandMap.get("sessionUserId"));
			
			if (request.getParameter("SaveType").equals("New")) {
				getMap.put("orgTypeCode", request.getParameter("orgTypeCode"));
				commonService.insert("config_SQL.insertItemType", getMap);
				getMap.put("Category", request.getParameter("IT"));
				commonService.insert("dictionary_SQL.insertDictionary", getMap);
			} else if (request.getParameter("SaveType").equals("Edit")) {
				getMap.put("orgTypeCode", request.getParameter("orgTypeCode"));
				commonService.update("config_SQL.updateItemType", getMap);
				getMap.put("Category", request.getParameter("IT"));
				commonService.update("dictionary_SQL.updateDictionary", getMap);
			}

			// target.put(AJAX_ALERT, "���옣�씠 �꽦怨듯븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "this.top.frames['main'].fnSearchTreeId('" + request.getParameter("s_itemID") + "');this.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " ���옣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/admin/saveDictionary.do")
	public String saveDictionary(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			getMap.put("languageID", request.getParameter("getLanguageID"));
			getMap.put("TypeCode", request.getParameter("objType"));
			getMap.put("Category", request.getParameter("categoryType"));
			getMap.put("Name", request.getParameter("objName"));
			getMap.put("Description", request.getParameter("Description"));
			getMap.put("SortNum", request.getParameter("sortNum"));
			getMap.put("Editable", StringUtil.checkNull(request.getParameter("Editable"),"0"));

			String checkNew = StringUtil.checkNull(commonService.selectString("dictionary_SQL.selectDictionary", getMap), "");
			if (checkNew.equals("")) {
				commonService.insert("dictionary_SQL.insertDictionary", getMap);
			} else {
				commonService.update("dictionary_SQL.updateDictionary", getMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT,"parent.fnCallBack(); parent.$('#isSubmit').remove()");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/admin/deleteDictinary.do")
	public String deleteDictinary(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String reqTypeCode = StringUtil.checkNull(request.getParameter("typeCode"), "");
				String reqCategoryCode = StringUtil.checkNull(request.getParameter("categoryCode"), "");
				String arrTypeCode[] = reqTypeCode.split(",");
				String arrCategoryCode[] = reqCategoryCode.split(",");
				
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				String typeCode = "";
				String categoryCode = "";
				if (arrTypeCode != null) {
					for (int i = 0; i < arrTypeCode.length; i++) {
						typeCode = arrTypeCode[i];
						categoryCode = arrCategoryCode[i];
						setMap.put("typeCode", typeCode);
						setMap.put("categoryCode", categoryCode);
						commonService.delete("dictionary_SQL.deleteDictionary",setMap);
					}
				}
							
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "fnCallBack('del');");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	

	@RequestMapping(value = "/ObjectTypeChild.do")
	public String ObjectTypeChild(HttpServletRequest request, HashMap mapValue,
			ModelMap model) throws Exception {
		try {
			List getValue = new ArrayList();
			getValue = commonService.selectList(
					"config_SQL.getObjectClassList", mapValue);

			model.put("getList", getValue);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/ObjectClass");
	}

	@RequestMapping(value = "/DefineConnectionType.do")
	public String DefineConnectionType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
				commandMap.put("categories","'CN', 'MCN', 'ST2'");
				List cxnList = commonService.selectList("config_SQL.getConnectTypeList_gridList",commandMap);			
				List classList = commonService.selectList("config_SQL.getAllocateClassList_gridList",commandMap);
				
				for(int i=0; i < classList.size(); i++) {
					cxnList.add(classList.get(i));
				}
				
				JSONArray treeGridData = new JSONArray(cxnList);
				model.put("treeGridData",treeGridData);
				
				model.put("selectedCat", request.getParameter("selectedCat"));
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/master data/DefineConnectionTypeGrid");
	}
	
	@RequestMapping(value="/getCxnAndClassList.do")
	public void getCxnAndClassList(HttpServletRequest request,  HashMap commandMap,HttpServletResponse response) throws Exception{
		try{	
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			commandMap.put("categories","'CN', 'MCN', 'ST2'");
			List cxnList = commonService.selectList("config_SQL.getConnectTypeList_gridList",commandMap);			
			List classList = commonService.selectList("config_SQL.getAllocateClassList_gridList",commandMap);
			
			for(int i=0; i < classList.size(); i++) {
				cxnList.add(classList.get(i));
			}
			
			JSONArray treeGridData = new JSONArray(cxnList);
			
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/plain");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().print(treeGridData);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
	}

	@RequestMapping(value = "/fileType.do")
	public String fileType(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), "1"));
			cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			List fltpList = commonService.selectList("config_SQL.FileType_gridList",cmmMap);
			
			JSONArray gridData = new JSONArray(fltpList);
			model.put("gridData",gridData);
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/file/fileType");
	}
	
	@RequestMapping(value="/getFileTypeList.do")
	public void getFileTypeList(HttpServletRequest request,  HashMap commandMap,HttpServletResponse response) throws Exception{
		try{	
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List fltpList = commonService.selectList("config_SQL.FileType_gridList",commandMap);
			
			JSONArray gridData = new JSONArray(fltpList);
			
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/plain");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().print(gridData);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
	}

	@RequestMapping(value = "/SubFile.do")
	public String SubFile(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/master data/SubFile";

		try {
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String ItemClassCode = StringUtil.checkNull(request.getParameter("s_itemID"));
	
			commandMap.put("languageID", languageID);
	        commandMap.put("ItemClassCode", ItemClassCode);
	        List subFileList = commonService.selectList("config_SQL.SubFileTab_gridList", commandMap);
	        JSONArray gridData = new JSONArray(subFileList);
	        model.put("gridData",gridData);	
	        
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			model.put("languageID", request.getParameter("languageID"));
			model.put("ClassName", request.getParameter("ClassName"));
			model.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			model.put("CategoryCode", request.getParameter("CategoryCode"));
			model.put("pageNum", request.getParameter("pageNum"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	// 203-03-26 �뼵�뼱 �솗�씤以�
	@RequestMapping(value = "/AllocateAttributeType.do")
	public String AllocateAttributeType(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		try {
			List getValue = new ArrayList();
			Map setMap = new HashMap();

			// ItemTypeCode 諛쏆븘�삩媛믪씠 �뾾�쓣 寃쎌슦 TB_ITEM_CLASS�뿉 �엯�젰�맂 Type肄붾뱶 以� 理쒖긽�쐞 肄붾뱶瑜� 諛쏆븘��
			// �꽔�뒗�뜲
			String ItemTypeCode = StringUtil.checkNull(request.getParameter("ItemTypeCode"), commonService.selectString("config_SQL.getObjectFromClassTopCode", mapValue));
			setMap.put("ItemTypeCode", ItemTypeCode);
			setMap.put("languageID", mapValue.get("sessionCurrLangType"));
			getValue = commonService.selectList("config_SQL.getAllocateClassList", setMap);

			model.put("getList", getValue);
			model.put("ObjectOption", commonService.selectList("config_SQL.getObjectCodeFromClass", setMap));
			model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode"), ItemTypeCode));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/AllocateAttributeType");
	}

	@RequestMapping(value = "/AllocateClassType.do")
	public String AllocateClassType(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(mapValue.get("sessionCurrLangType"));
			String ItemTypeCode = StringUtil.checkNull(request.getParameter("ItemTypeCode"));
			
			setMap.put("languageID", languageID);
			setMap.put("ItemTypeCode", ItemTypeCode);

	        List alloClassTypeList = commonService.selectList("config_SQL.getAllocateClassList_gridList", setMap);
	        JSONArray gridData = new JSONArray(alloClassTypeList);
	        model.put("gridData",gridData);	

			model.put("CategoryOption", commonService.selectList("config_SQL.getCategoryCode", setMap));
			model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
			model.put("CategoryCode", StringUtil.checkNull(request.getParameter("CategoryCode")));

			model.put("pageNum", request.getParameter("pageNum"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/master data/AllocateClassType");
	}
	
	@RequestMapping(value="/getObjectTypeList.do")
	public String getObjectTypeList(HttpServletRequest request, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		setMap.put("languageID", request.getParameter("languageID"));
		setMap.put("option", request.getParameter("option"));
		model.put(AJAX_RESULTMAP, commonService.selectList("config_SQL.getObjectCodeFromClass",setMap));
		return nextUrl(AJAXPAGE_SELECTOPTION);
	}

	@RequestMapping(value = "/ClassAllocateAttrList.do")
	public String ClassAllocateAttrList(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		String url = "/adm/configuration/ClassAllocateAttrList";
		try {
			List getValue = new ArrayList();
			getValue = commonService.selectList("config_SQL.getClassAttrLocateList", mapValue);

			model.put("getList", getValue);
			model.put("ItemClassCode", request.getParameter("ItemClassCode"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}

	@RequestMapping(value = "/ClassAllocateReportList.do")
	public String ClassAllocateReportList(HttpServletRequest request,
			HashMap mapValue, ModelMap model) throws Exception {
		String url = "/adm/configuration/ClassAllocateReportList";
		try {
			List getValue = new ArrayList();
			getValue = commonService.selectList("config_SQL.getClassReportLocateList", mapValue);

			model.put("getList", getValue);
			model.put("ItemClassCode", StringUtil.checkNull(request.getParameter("ItemClassCode"), ""));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}

	@RequestMapping(value = "/ClassAllocateAttr.do")
	public String ClassAllocateAttr(HttpServletRequest request,
			HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(request
					.getParameter("languageCode"), commonService.selectString(
					"config_SQL.defaultlanguageID", setMap));

			setMap.put("languageID", languageID);
			setMap.put("ItemClassCode", request.getParameter("ItemClassCode"));
			commonService.delete("config_SQL.clearAttrTypeAllocation", setMap);

			String arrayStr[] = request.getParameterValues("item");
			if (arrayStr != null) {
				for (int i = 0; i < arrayStr.length; i++) {
					String s_itemIDs = arrayStr[i];
					setMap.put("AttrTypeCode", s_itemIDs);
					commonService.insert("config_SQL.insertAttrTypeAllocation",
							setMap);
				}

			}

			/*
			 * getValue =
			 * commonService.selectList("config_SQL.getClassAttrLocateList",
			 * setMap);
			 * 
			 * model.put("getList", getValue); model.put("ItemClassCode",
			 * request.getParameter("ItemClassCode"));
			 * 
			 * model.put("languageOption",
			 * commonService.selectList("config_SQL.languageList",setMap));
			 * model.put("languageID", languageID ); //�씪踰� model.put("menu",
			 * getName(mapValue.get("sessionCurrLangType").toString()) );
			 */
			// target.put(AJAX_ALERT, "���옣�씠 �꽦怨듯븯���뒿�땲�떎.");
			target.put(
					AJAX_ALERT,
					MessageHandler.getMessage(commandMap
							.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "this.top.frames['main'].fnSearchTreeId('"
					+ request.getParameter("s_itemID")
					+ "');this.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " ���옣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(
					AJAX_ALERT,
					MessageHandler.getMessage(commandMap
							.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
		// return nextUrl("/adm/configuration/ClassAllocateAttrList");
	}

	@RequestMapping(value = "/ClassAllocateReport.do")
	public String ClassAllocateReport(HttpServletRequest request,
			HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map setMap = new HashMap();
			setMap.put("ItemClassCode", request.getParameter("ItemClassCode"));

			commonService.delete("config_SQL.clearReportAllocation", setMap);

			String arrayStr[] = request.getParameterValues("item");
			if (arrayStr != null) {
				for (int i = 0; i < arrayStr.length; i++) {
					String s_itemIDs = arrayStr[i];
					setMap.put("ReportCode", s_itemIDs);
					commonService.insert("config_SQL.insertReportAllocation",
							setMap);
				}
			}
			/*
			 * setMap.put("ItemClassCode",
			 * request.getParameter("ItemClassCode"));
			 * 
			 * getValue =
			 * commonService.selectList("config_SQL.getClassReportLocateList",
			 * setMap);
			 * 
			 * model.put("getList", getValue); model.put("ItemClassCode",
			 * request.getParameter("ItemClassCode"));
			 */

			// model.put("languageOption",
			// commonService.selectList("config_SQL.languageList",setMap));
			// model.put("languageID",
			// StringUtil.checkNull(request.getParameter("languageCode"),
			// commonService.selectString("config_SQL.defaultlanguageID",setMap)
			// ) );
			// �씪踰�
			// model.put("menu",
			// getName(mapValue.get("sessionCurrLangType").toString()) );
			// target.put(AJAX_ALERT, "���옣�씠 �꽦怨듯븯���뒿�땲�떎.");
			target.put(
					AJAX_ALERT,
					MessageHandler.getMessage(commandMap
							.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "this.top.frames['main'].fnSearchTreeId('"
					+ request.getParameter("s_itemID")
					+ "');this.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " ���옣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(
					AJAX_ALERT,
					MessageHandler.getMessage(commandMap
							.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);

		// return nextUrl("/adm/configuration/ClassAllocateReportList");
	}

	@RequestMapping(value = "/DefineArchitecture.do")
	public String DefineArchitecture(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			// model.put("getList", getValue);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List arcList = commonService.selectList("config_SQL.getDefineArchitectureList_gridList",setMap);
			
			JSONArray treeGridData = new JSONArray(arcList);
			model.put("treeGridData",treeGridData);
			model.put("cfgCode", commandMap.get("cfgCode"));
			
			List path = new ArrayList();
			String cfgCode = StringUtil.checkNull(commandMap.get("cfgCode"),"");
			
			path = getCFGMenuPath(cfgCode,StringUtil.checkNull(commandMap.get("sessionCurrLangType")),path, commandMap);
			
			Collections.reverse(path);
			model.put("path",path);
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/menu/DefineArchitectureGrid");
	}

	@RequestMapping(value = "saveDefineArchitecture.do")
	public String saveDefineArchitecture(HttpServletRequest request,
			HashMap mapValue, ModelMap model) throws Exception {
		try {
			List getValue = new ArrayList();
			Map setMap = new HashMap();
			setMap.put("languageID", StringUtil.checkNull(request.getParameter("languageCode"), commonService.selectString("config_SQL.defaultlanguageID", setMap)));
			getValue = commonService.selectList("config_SQL.getDefineArchitectureList", setMap);
			model.put("getList", getValue);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/DefineArchitecture");
	}

	/**
	 * saveClassType Insert
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/saveClassType.do")
	public String saveClassType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			Map getMap = new HashMap();

			getMap.put("ItemClassCode", request.getParameter("objType"));
			getMap.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			getMap.put("TypeCode", request.getParameter("objType"));
			getMap.put("Name", request.getParameter("objName"));
			getMap.put("Description", request.getParameter("objDescription"));
			getMap.put("languageID", commandMap.get("sessionCurrLangType"));
			getMap.put("Creator", commandMap.get("sessionUserId"));
			getMap.put("Category",StringUtil.checkNull(request.getParameter("CLS"), "CLS"));

			commonService.insert("config_SQL.InsertItemClass", getMap);
			commonService.insert("dictionary_SQL.insertDictionary", getMap);

			// target.put(AJAX_ALERT, "���옣�씠 �꽦怨듯븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.selfClose();parent.fnCallBack();parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " ���옣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	

	// delClassType 遺�遺�
	@RequestMapping(value = "/delClassType.do")
	public String delClassType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map getMap = new HashMap();
		
		try {
			String[] arrayCode = StringUtil.checkNull(request.getParameter("classCodes")).split(",");
			
			for (int i = 0; arrayCode.length > i ; i++) {
				getMap.put("ItemClassCode", arrayCode[i]);
				getMap.put("TypeCode", arrayCode[i]);
				commonService.delete("config_SQL.delClassType", getMap);
				commonService.delete("config_SQL.delDic", getMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣 �꽦怨�
			target.put(AJAX_SCRIPT, "this.urlReload();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�														
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
		// return nextUrl("/adm/configuration/DefineObjectType");
	}

	@RequestMapping(value = "/ClassTypeView.do")
	public String ClassTypeView(HttpServletRequest request, HashMap commandMap, ModelMap model)	throws Exception {
		HashMap getMap = new HashMap();
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			getMap.put("ItemClassCode", request.getParameter("classCode"));
			getMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
			
			getMap.put("Category", "SB");
			getMap.put("sessionCurrLangType", StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
			model.put("SymCodeList", commonService.selectList("common_SQL.getDicWord_commonSelect",getMap));
			getMap = (HashMap) commonService.select("config_SQL.LeloadClass", getMap);

			model.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			model.put("CategoryCode", request.getParameter("CategoryCode"));
			model.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("selectedCat", request.getParameter("selectedCat"));
			model.put("selectedItemType", request.getParameter("selectedItemType"));
			model.put("resultMap", getMap);
			
			getMap.put("ClassCode", request.getParameter("classCode"));
			String itemID = commonService.selectString("report_SQL.getItemIdWithIdentifier", getMap);
			model.put("itemID",itemID);
			model.put("cfgCode", StringUtil.checkNull(request.getParameter("cfgCode")));

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/master data/ClassTypeView");
		// return nextUrl(AJAXPAGE);
	}

	// CalssTypeView END

	/**
	 * updateClassType
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/updateClassType.do")
	public String updateClassType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			getMap.put("ItemClassCode", request.getParameter("ItemClassCode"));
			getMap.put("TypeCode", request.getParameter("ItemClassCode"));
			getMap.put("Name", request.getParameter("objClassName"));
			getMap.put("Icon", request.getParameter("objIcon"));
			getMap.put("SymbolName", request.getParameter("SymbolName"));
			getMap.put("ClassName", request.getParameter("ObjectName"));
			getMap.put("ChangeMgt", request.getParameter("objChangeMgt"));
			//getMap.put("HasCoP", request.getParameter("objHasCoP"));
			getMap.put("HasDimension", request.getParameter("objHasDimension"));
			//getMap.put("HasFile", request.getParameter("objHasFile"));
			getMap.put("FileOption", request.getParameter("FileOption"));
			//getMap.put("ExtFunc", request.getParameter("objExtFunc"));
			getMap.put("CheckInOption", request.getParameter("CheckInOption"));
			getMap.put("Deactivated", request.getParameter("objDeactivated"));
			getMap.put("Description", request.getParameter("objDescription"));
			getMap.put("LastUser", request.getParameter("orgLastUser"));
			getMap.put("languageID", request.getParameter("languageID"));
			getMap.put("Category", StringUtil.checkNull(request.getParameter("CLS"), "CLS"));
			getMap.put("SymbolCategory", StringUtil.checkNull(request.getParameter("SB"), "SB"));
			getMap.put("DefSymCode", StringUtil.checkNull(request.getParameter("SymbolName"), request.getParameter("DefSymCode")));
			getMap.put("MenuID", StringUtil.checkNull(request.getParameter("menuID")));
			getMap.put("Level", StringUtil.checkNull(request.getParameter("level")));
			getMap.put("AutoID", StringUtil.checkNull(request.getParameter("AutoID")));
			getMap.put("PreFix", StringUtil.checkNull(request.getParameter("PreFix")));
			getMap.put("DefWFID", StringUtil.checkNull(request.getParameter("WorkFlow")));
			getMap.put("SubscrOption", StringUtil.checkNull(request.getParameter("objSubscription")));
			getMap.put("DefVersionIncr", StringUtil.checkNull(request.getParameter("DefVersionIncr")));
			getMap.put("Varfilter", StringUtil.checkNull(request.getParameter("Varfilter")));
			getMap.put("mgtTeamID", StringUtil.checkNull(request.getParameter("mgtTeamID")));

			String checkNew = StringUtil.checkNull(commonService.selectString("config_SQL.selectClassDictionary", getMap), "");

			if (checkNew.equals("")) {
				commonService.insert("dictionary_SQL.insertDictionary", getMap);
			} else {
				commonService.update("dictionary_SQL.updateDictionary", getMap);
				commonService.update("config_SQL.UpdateItemClass", getMap);
			}
			
			model.put("pageNum", request.getParameter("pageNum"));
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.thisReload();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}


	/**
	 * ARC Menu
	 * @param request
	 * @param mapValue
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/addAttrTypeCode.do")
	public String addAttrTypeCode(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("TypeCode", request.getParameter("TypeCode"));
			model.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			
			setMap.put("languageID",request.getParameter("languageID"));
			setMap.put("ItemClassCode",request.getParameter("TypeCode"));
			List list = commonService.selectList("config_SQL.getUnAllocAttrType_gridList", setMap);
			JSONArray gridData = new JSONArray(list);
			model.put("gridData",gridData);
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/master data/addAttrTypeCode");
	}

	@RequestMapping(value = "/admin/SaveAttrType.do")
	public String Yj_TabAddFile(HttpServletRequest request, HashMap commandMap,
			ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			Map getMap = new HashMap();

			String attrCodes = StringUtil.checkNull(request.getParameter("attrCodes"));
			String itemTypeCode = StringUtil.checkNull(request.getParameter("ItemTypeCode"));
			String itemClassCode = StringUtil.checkNull(request.getParameter("ItemClassCode"));

			String[] arrayAttrCodes = attrCodes.split(",");

			for (int i = 0; i < arrayAttrCodes.length; i++) {
				getMap.put("AttrTypeCode", arrayAttrCodes[i]);
				getMap.put("ItemTypeCode", itemTypeCode);
				getMap.put("ItemClassCode", itemClassCode);
				commonService.insert("config_SQL.InsertAddAttributeType", getMap);
			}

			// target.put(AJAX_ALERT, "���옣�씠 �꽦怨듯븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT,"this.selfClose();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " ���옣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	// ///////////////////////////////////////////////////////////////////////////////
	// SubAttributeTypeAllocation Delete 遺�遺�
	@RequestMapping(value = "/admin/DeleteAttrType.do")
	public String UpdateAttrType(HttpServletRequest request,
			HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			// List getValue = new ArrayList();
			Map getMap = new HashMap();

			getMap.put("AttrTypeCode", request.getParameter("AttrTypeCode"));
			getMap.put("ItemClassCode", request.getParameter("ItemClassCode"));

			commonService.update("config_SQL.DeleteAttrTypeGrid", getMap);

			if (StringUtil.checkNull(request.getParameter("FinalData"), "")
					.equals("Final")) {

				// target.put(AJAX_ALERT, "�궘�젣媛� �꽦怨듯븯���뒿�땲�떎.");
				target.put(
						AJAX_ALERT,
						MessageHandler.getMessage(commandMap
								.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣
																			// �꽦怨�
				target.put(AJAX_SCRIPT,
						"this.doOTSearchList();this.$('#isSubmit').remove();");
			}

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " �궘�젣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(
					AJAX_ALERT,
					MessageHandler.getMessage(commandMap
							.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�
																		// 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);

	}

	/**
	 * SaveSortNum Update
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/SaveSortNum.do")
	public String SaveSortNum(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
				Map getMap = new HashMap();	
				getMap.put("SortNum", request.getParameter("objsortNum"));
				getMap.put("AttrTypeCode", request.getParameter("AttrTypeCode"));
				getMap.put("ItemClassCode", request.getParameter("ItemClassCode"));
				getMap.put("Mandatory", request.getParameter("objMandatory"));
				getMap.put("Invisible", request.getParameter("objInvisible"));
				getMap.put("Link",StringUtil.checkNull(request.getParameter("link"), ""));
				getMap.put("AreaHeight", request.getParameter("areaHeight"));
				getMap.put("rowNum", request.getParameter("rowNum"));
				getMap.put("columnNum", request.getParameter("columnNum"));
				getMap.put("varFilter", request.getParameter("varFilter"));
				getMap.put("allocationType", request.getParameter("allocationType"));
				commonService.update("config_SQL.UpdateAttrTypeGrid", getMap);
	
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "parent.SubAttrReload();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/addReportCodeAlloc.do")
	public String addReportCodeAlloc(HttpServletRequest request,
			HashMap mapValue, ModelMap model) throws Exception {
		String url = "/adm/configuration/master data/addReportCodeAlloc";
		try {
			String languageID = StringUtil.checkNull(mapValue.get("sessionCurrLangType"));
			String ClassCode = StringUtil.checkNull(request.getParameter("ClassCode"));
			
			mapValue.put("ClassCode", ClassCode);
			mapValue.put("languageID", languageID);
	        List addReportCodeList = commonService.selectList("config_SQL.addReportCodeAlloc_gridList", mapValue);
	        JSONArray gridData = new JSONArray(addReportCodeList);
	        model.put("gridData",gridData);	
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			model.put("languageID", request.getParameter("languageID"));
			model.put("ClassCode", request.getParameter("ClassCode"));
			model.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			model.put("ClassName", request.getParameter("ClassName"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}

	// SaveReportType Insert 遺�遺�
	@RequestMapping(value = "/admin/SaveReportType.do")
	public String SaveReportType(HttpServletRequest request,
			HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			Map getMap = new HashMap();
			
			String reportCodes = StringUtil.checkNull(request.getParameter("reportCodes"));
			String classCode = StringUtil.checkNull(request.getParameter("ClassCode"));
			
			String[] arrayReportCodes = reportCodes.split(",");
			
			for(int i = 0; i < arrayReportCodes.length ; i++){
				getMap.put("ReportCode", arrayReportCodes[i]);
				getMap.put("ClassCode", classCode);

				commonService.insert("config_SQL.InsertAddClassType", getMap);
			}

			// target.put(AJAX_ALERT, "���옣�씠 �꽦怨듯븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣															// �꽦怨�
			target.put(AJAX_SCRIPT, "this.selfClose();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " ���옣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(
					AJAX_ALERT,
					MessageHandler.getMessage(commandMap
							.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);

	}

	// SaveReportType Insert END

	// SaveReportType Delete 遺�遺�
	@RequestMapping(value = "/admin/DeleteReportType.do")
	public String DeleteReportType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
			HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			getMap.put("ReportCode", request.getParameter("ReportCode"));
			getMap.put("ClassCode", request.getParameter("ClassCode"));

			commonService.delete("config_SQL.DeleteReportType", getMap);

			if (StringUtil.checkNull(request.getParameter("FinalData"), "")
					.equals("Final")) {
				// target.put(AJAX_ALERT, "�궘�젣媛� �꽦怨듯븯���뒿�땲�떎.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove();");
			}

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " �궘�젣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�// 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/getReportTypeList.do")
	public void getReportTypeList(HttpServletRequest request,  HashMap commandMap,HttpServletResponse response) throws Exception{
		try{	
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List attrList = commonService.selectList("config_SQL.getReportTypeCode_gridList", commandMap);
			JSONArray gridData = new JSONArray(attrList);
			
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/plain");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().print(gridData);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
	}

	@RequestMapping(value = "/addFileAllocPop.do")
	public String YjAddFileTypeTab(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		String url = "/adm/configuration/master data/addFileAllocPop";
		try {
			String languageID = StringUtil.checkNull(mapValue.get("sessionCurrLangType"));
			String ClassCode = StringUtil.checkNull(request.getParameter("ClassCode"));

			mapValue.put("languageID", languageID);
			mapValue.put("ClassCode", ClassCode);
	        List addFileAList = commonService.selectList("config_SQL.AllocateFileType_gridList", mapValue);
	        JSONArray gridData = new JSONArray(addFileAList);
	        model.put("gridData",gridData);	
	        
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			model.put("languageID", request.getParameter("languageID"));
			model.put("ClassCode", request.getParameter("TypeCode"));
			model.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			model.put("ClassName", request.getParameter("ClassName"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}

	// SaveFileType Insert 遺�遺�
	@RequestMapping(value = "/admin/SaveFileType.do")
	public String SaveFileType(HttpServletRequest request, HashMap commandMap,
			ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			Map getMap = new HashMap();
			
			String fileTypeCodes = StringUtil.checkNull(request.getParameter("fileTypeCodes"));
			String itemClassCode = StringUtil.checkNull(request.getParameter("ItemClassCode"));
			
			String[] arrayFileTypeCodes = fileTypeCodes.split(",");
			
			for (int i = 0; i < arrayFileTypeCodes.length ; i++) {
				getMap.put("FltpCode", arrayFileTypeCodes[i]);
				getMap.put("ItemClassCode", itemClassCode);
				commonService.insert("config_SQL.InsertFileType", getMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣
			target.put(AJAX_SCRIPT,"this.selfClose();this.$('#isSubmit').remove();"); // �꽦怨�

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " ���옣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);

	}

	// DeleteFileType Insert END

	// SaveReportType Delete 遺�遺�
	@RequestMapping(value = "/admin/DeleteFileType.do")
	public String DeleteFileType(HttpServletRequest request,
			HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			getMap.put("FltpCode", request.getParameter("FltpCode"));
			getMap.put("ItemClassCode", request.getParameter("ItemClassCode"));

			commonService.delete("config_SQL.DeleteFileType", getMap);

			if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
				// target.put(AJAX_ALERT, "�궘�젣媛� �꽦怨듯븯���뒿�땲�떎.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣													
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove();"); // �꽦怨�
			}

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " �궘�젣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�														// 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);
		return nextUrl(AJAXPAGE);
	}

	// DeleteFileType Delete END

	@RequestMapping(value = "/SubAttributeType_SortNum.do")
	public String SubAttributeType_SortNum(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		String url = "/adm/configuration/master data/SubAttributeType_SortNum";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("SortNum", request.getParameter("SortNum"));
			model.put("AttrTypeCode", request.getParameter("AttrTypeCode"));
			model.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			model.put("CategoryCode", request.getParameter("CategoryCode"));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("ItemClassCode", request.getParameter("ItemClassCode"));
			model.put("ClassName", request.getParameter("ClassName"));
			model.put("languageID", request.getParameter("languageID"));
			model.put("Mandatory", request.getParameter("Mandatory"));
			model.put("Invisible", request.getParameter("Invisible"));
			model.put("Link", request.getParameter("Link"));
			model.put("areaHeight", request.getParameter("areaHeight"));
			model.put("rowNum", request.getParameter("rowNum"));
			model.put("columnNum", request.getParameter("columnNum"));
			model.put("varFilter", request.getParameter("varFilter"));
			model.put("allocationType", request.getParameter("allocationType"));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/architectureView.do")
	public String architectureView(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap getMap = new HashMap();
		try { 
			String viewType = StringUtil.checkNull(request.getParameter("viewType")); 
			String newArcCode = "";
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
			if(!viewType.equals("N")){
				getMap.put("ArcCode", request.getParameter("ArcCode"));
				getMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
				
				getMap = (HashMap) commonService.select("config_SQL.getSelectArchitecure", getMap);
			}
			//else{
		//		newArcCode = commonService.selectString("config_SQL.getMaxArcCode", commandMap).trim();
	//			getMap.put("ArcCode", newArcCode);
		//	}
			
			model.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("viewType", viewType);
			model.put("cfgCode", StringUtil.checkNull(request.getParameter("cfgCode")));

			model.put("resultMap", getMap);

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/menu/ArchitectureView");
	}

	@RequestMapping(value = "/admin/updateArchitectrue.do")
	public String updateArchitectrue(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			String viewType = StringUtil.checkNull(request.getParameter("viewType")); 
			Map getMap = new HashMap();
			getMap.put("ArcCode", StringUtil.checkNull(request.getParameter("ArcCode")));
			getMap.put("ArcName", StringUtil.checkNull(request.getParameter("ArcName")));
			getMap.put("DimTypeID", StringUtil.checkNull(request.getParameter("dimTypeID")));
			getMap.put("MstObjectID", StringUtil.checkNull(request.getParameter("mstObjectID")));
			getMap.put("WID", StringUtil.checkNull(request.getParameter("WID")));
			getMap.put("Deactivated", StringUtil.checkNull(request.getParameter("Deactivated"),"0"));			
			getMap.put("languageID", StringUtil.checkNull(request.getParameter("getLanguageID")));
			getMap.put("Description", StringUtil.checkNull(request.getParameter("objDescription")));
			getMap.put("Name", StringUtil.checkNull(request.getParameter("objLevel1Name")));
			getMap.put("LastUser", StringUtil.checkNull(commandMap.get("sessionUserId"))); 
			getMap.put("TypeCode", StringUtil.checkNull(request.getParameter("ArcCode")));
			getMap.put("Style", StringUtil.checkNull(request.getParameter("Style")));
			getMap.put("Icon", StringUtil.checkNull(request.getParameter("Icon")));
			getMap.put("FilterType", StringUtil.checkNull(request.getParameter("filterType")));
			getMap.put("Level", StringUtil.checkNull(request.getParameter("Level")));
			getMap.put("SortNum", StringUtil.checkNull(request.getParameter("SortNum")));
			getMap.put("Type", StringUtil.checkNull(request.getParameter("treeType")));
			getMap.put("MenuID", StringUtil.checkNull(request.getParameter("menuType")));
			getMap.put("ParentID", StringUtil.checkNull(request.getParameter("parentID")));
			getMap.put("SortOption", StringUtil.checkNull(request.getParameter("SortOption"),"0"));
			
			getMap.put("TypeCode", StringUtil.checkNull(request.getParameter("ArcCode")));
			getMap.put("Category","AR");
			getMap.put("Name",StringUtil.checkNull(request.getParameter("ArcName")));
			getMap.put("VarFilter", StringUtil.checkNull(request.getParameter("arcVarFilter")));
			getMap.put("UntitledOption", StringUtil.checkNull(request.getParameter("UntitledOption"),"N"));
			getMap.put("idFilter", StringUtil.checkNull(request.getParameter("idFilter")));
			
			if(viewType.equals("N")){// Insert 
				commonService.insert("config_SQL.insertArchitecture", getMap);
				commonService.insert("dictionary_SQL.insertDictionary", getMap);
			}else{// update
				String checkNew = StringUtil.checkNull(commonService.selectString("dictionary_SQL.selectDictionary", getMap), "");
				if (checkNew.equals("")) {
					commonService.insert("dictionary_SQL.insertDictionary", getMap);
				} else {						
					commonService.update("dictionary_SQL.updateDictionary", getMap);
				}
				commonService.update("config_SQL.updateArc", getMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.ArcReload('"+viewType+"');parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/defineTemplateView.do")
	public String defineTemplateView(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap getMap = new HashMap();
		HashMap setMap = new HashMap();
		try {
				String viewType = StringUtil.checkNull(request.getParameter("viewType"));
				String templCode = "";
				if(viewType.equals("E")){
					templCode = StringUtil.checkNull(request.getParameter("templCode"));
					setMap.put("templCode", templCode);				
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));
					getMap = (HashMap)commonService.select("config_SQL.getSelectTemplateCode", setMap);
				}else{
					templCode = StringUtil.checkNull(commonService.selectString("config_SQL.getMaxTemplCode", setMap));
				}
				
				model.put("menu", getLabel(request, commonService)); /* Label Setting */	
				model.put("languageID",  commandMap.get("sessionCurrLangType"));
				model.put("pageNum",  StringUtil.checkNull(request.getParameter("pageNum")));
				model.put("templCode", templCode);
				model.put("viewType", viewType);
				model.put("resultMap", getMap);
				model.put("cfgCode", StringUtil.checkNull(request.getParameter("cfgCode")));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/menu/defineTemplateView");
	}

	@RequestMapping(value = "/admin/updateTemplate.do")
	public String updateTemplate(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			String viewType = StringUtil.checkNull(request.getParameter("viewType"));
			getMap.put("TemplCode", request.getParameter("templCode"));
			getMap.put("TypeCode", request.getParameter("templCode"));
			getMap.put("Name", request.getParameter("templName"));
			getMap.put("Deactivated", StringUtil.checkNull(request.getParameter("deactivated"),"0"));
			getMap.put("LastUser", commandMap.get("sessionUserId"));
			getMap.put("Description", request.getParameter("description"));
			getMap.put("languageID", request.getParameter("LanguageID"));
			getMap.put("Category", StringUtil.checkNull(request.getParameter("TMPL"), "TMPL"));
			getMap.put("Style", StringUtil.checkNull(request.getParameter("style"), ""));
			getMap.put("Type", StringUtil.checkNull(request.getParameter("type"), ""));
			getMap.put("MenuID", StringUtil.checkNull(request.getParameter("menuID"), ""));
			getMap.put("projectID", StringUtil.checkNull(request.getParameter("project"),""));
			String checkNew = StringUtil.checkNull(commonService.selectString("config_SQL.selectTempDictionary", getMap), "");
			getMap.put("SortNum", StringUtil.checkNull(request.getParameter("sortNum"),""));
			getMap.put("VarFilter", StringUtil.checkNull(request.getParameter("varFilter"),""));
			getMap.put("defLanguage", StringUtil.checkNull(request.getParameter("defLanguage"),""));
		
			if(viewType.equals("E")){// �닔�젙
				if (checkNew.equals("")) {commonService.insert("dictionary_SQL.insertDictionary", getMap);
				} else {commonService.update("dictionary_SQL.updateDictionary", getMap);}
				commonService.update("config_SQL.updateTemplate", getMap);
			}else{
				commonService.insert("dictionary_SQL.insertDictionary", getMap);
				commonService.insert("config_SQL.insertTempl", getMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.thisReload('"+viewType+"');");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap .get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
		
	}
	
	@RequestMapping(value = "/admin/deleteTempl.do")
	public String deleteTempl(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String templCode = StringUtil.checkNull(request.getParameter("templCode"));
				System.out.println("templCode"+templCode);
				String templCodeArr[] = templCode.split(",");
				 System.out.println(templCodeArr.length);
				for(int i=0; i<templCodeArr.length; i++){
					setMap.remove("templCode");
					setMap.put("templCode", templCodeArr[i]);
					System.out.println("templCodeArr[i]"+templCodeArr[i]);
					commonService.delete("config_SQL.deleteTempl", setMap);
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
				//target.put(AJAX_SCRIPT, "parent.urlReload(); parent.$('#isSubmit').remove()");
				target.put(AJAX_SCRIPT, "parent.thisReload(); parent.$('#isSubmit').remove()");
		} catch (Exception e) {
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * workFlow List �솕硫� �몴�떆
	 * @param request
	 * @param mapValue
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/workFlowType.do")
	public String WorkFlowTypeGrid(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		try {
			mapValue.put("languageID", mapValue.get("sessionCurrLangType"));
			List wftList = commonService.selectList("config_SQL.workFlow_gridList",mapValue);
			JSONArray gridData = new JSONArray(wftList);
			model.put("gridData",gridData);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("pageNum", request.getParameter("pageNum"));
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/workFlowType");
	}
	
	/**
	 * workFlowType Detatil
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/workFlowDetailView.do")
	public String workFlowDetailView(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {

		Map getMap = new HashMap();
		try {
			
			getMap.put("WFID", request.getParameter("WFID"));
			getMap.put("languageID", request.getParameter("languageID"));
			getMap = (HashMap) commonService.select("config_SQL.getWorkFlowDetail", getMap);
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("languageID", request.getParameter("languageID"));
			model.put("resultMap", getMap);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/workFlowDetailView");
	}

	/**
	 * workFlowType Detatil
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/workFlowStepDetailView.do")
	public String workFlowStepDetailView(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {

		Map getMap = new HashMap();
		try {
			
			getMap.put("WFStepID", request.getParameter("WFStepID"));
			getMap.put("languageID", request.getParameter("languageID"));
			getMap = (HashMap) commonService.select("config_SQL.getWorkFlowStepDetail", getMap);
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("languageID", request.getParameter("languageID"));
			model.put("resultMap", getMap);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/workFlowStepDetailView");
	}
	
	/**
	 * workFlowStep List �솕硫� �몴�떆
	 * @param request
	 * @param mapValue
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/workFlowStep.do")
	public String WorkFlowStep(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		try {
			mapValue.put("languageID", mapValue.get("sessionCurrLangType"));
			List wfStepList = commonService.selectList("config_SQL.workFlowStep_gridList",mapValue);
			JSONArray gridData = new JSONArray(wfStepList);
			model.put("gridData",gridData);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("pageNum", request.getParameter("pageNum"));
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/workFlowStep");
	}
	
	/**
	 * Edit Work Flow
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/updateWorkFlow.do")
	public String updateWorkFlow(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			getMap.put("WFID", request.getParameter("objWFID"));
			getMap.put("TypeCode", request.getParameter("objWFID"));
			getMap.put("Name", request.getParameter("objName"));
			getMap.put("Deactivated", request.getParameter("objDeactivated"));
			getMap.put("languageID", request.getParameter("getLanguageID"));
			getMap.put("LastUser", commandMap.get("sessionUserId"));
			getMap.put("Description", request.getParameter("objDescription"));
			getMap.put("Category", "WF");
			getMap.put("wfCategory", StringUtil.checkNull(commandMap.get("category")));
			getMap.put("serviceCode", StringUtil.checkNull(commandMap.get("serviceCode"),""));
			getMap.put("menuID", StringUtil.checkNull(commandMap.get("menuID")));
			getMap.put("agreementYN", StringUtil.checkNull(request.getParameter("objAgreementYN"),""));
			getMap.put("postProcessing", StringUtil.checkNull(commandMap.get("postProcessing"),""));
			getMap.put("mandatoryGRID", StringUtil.checkNull(commandMap.get("mandatoryGRID"),""));
			getMap.put("endGRID", StringUtil.checkNull(commandMap.get("endGRID"),""));
			getMap.put("wfURL", StringUtil.checkNull(commandMap.get("wfURL"),""));

			String checkNew = StringUtil.checkNull(commonService.selectString("config_SQL.selectWofkFlowDictionary", getMap));

			if (checkNew.equals("")) {
				commonService.insert("dictionary_SQL.insertDictionary", getMap);
			} else {
				commonService.update("config_SQL.updateWorkFlow", getMap);
				commonService.update("dictionary_SQL.updateDictionary", getMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.thisReload();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
		
	}

	
	/**
	 * work flow step rel menu
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/workFlowStepRelMenu.do")
	public String YJ_WorkFlowMenu(HttpServletRequest request, ModelMap model) throws Exception {

		String url = "/adm/configuration/sub/workFlowStepRelMenu";

		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			model.put("languageID", request.getParameter("languageID"));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("wfName", request.getParameter("wfName"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/workFlowStepRelSub.do")
	public String workFlowStepRelSub(HttpServletRequest request, ModelMap model) throws Exception {

		String url = "/adm/configuration/change management/workFlowStepRel";

		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("WFID", request.getParameter("s_itemID"));
			model.put("languageID", request.getParameter("languageID"));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("wfName", request.getParameter("wfName"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	/**
	 * Add workFlow
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/saveWorkFlow.do")
	public String saveWorkFlow(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			getMap.put("WFID", request.getParameter("objWFID"));
			getMap.put("TypeCode", request.getParameter("objWFID"));
			getMap.put("Name", request.getParameter("objName"));
			getMap.put("Description", request.getParameter("objDescription"));
			getMap.put("languageID", commandMap.get("sessionCurrLangType"));
			getMap.put("Creator", commandMap.get("sessionUserId"));
			getMap.put("Category", "WF");
			getMap.put("Deactivated", "0");

			commonService.insert("config_SQL.insertWF", getMap);
			commonService.insert("dictionary_SQL.insertDictionary", getMap);

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * delete workFlow (TB_WF_STEP_REL, TB_WF)
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/delWorkFlow.do")
	public String delWorkFlow(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			String[] arrayCode = StringUtil.checkNull(request.getParameter("wfIds")).split(",");
			
			for (int i = 0; arrayCode.length > i ; i++) {
				getMap.put("WFID", arrayCode[i]);
				getMap.put("TypeCode", arrayCode[i]);
				commonService.delete("config_SQL.deleteWfStepRel", getMap);
				commonService.delete("config_SQL.deleteWf", getMap);
				commonService.delete("config_SQL.delDic", getMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣 �꽦怨�
			target.put(AJAX_SCRIPT, "this.urlReload();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * WF WF_STEP_REL �븷�떦
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	/*@RequestMapping(value="/addWorkFlowStepPop.do")
	public String addWorkFlowStepPop(HttpServletRequest request, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		try{	
			String editMode = "insert";
			String wfStepId = StringUtil.checkNull(request.getParameter("WFStepID"));
			Map infoMap = new HashMap();
			setMap.put("WFID", request.getParameter("WFID"));
			
			// update
			if (!wfStepId.isEmpty()) {
				editMode = "update";
				setMap.put("WFStepID", wfStepId);
				setMap.put("languageID", request.getParameter("languageID"));
				infoMap = commonService.select("config_SQL.workFlowStepRelList_gridList", setMap);
			} else {
				// insert
				// get Max sortNum
				String maxSortNum = commonService.selectString("config_SQL.MaxSortNum", setMap);
				model.put("maxSortNum", maxSortNum);
				// get PreStepId
				if (maxSortNum.equals("1")) {
					model.put("preStepId", "");
				} else {
					setMap.put("SortNum", Integer.parseInt(maxSortNum) - 1);
					String preStepId = commonService.selectString("config_SQL.getPreStepId", setMap);
					model.put("preStepId", preStepId);
				}
			}
			
			// �쁽�옱 �빐�떦 WF�뿉 �븷�떦 �릺�뼱 �엳�뒗 WFID瑜� 痍⑤뱷
			List wfStepIdList = commonService.selectList("config_SQL.getWfStepIdList", setMap);
			String arrayWfStepId = "";
			for (int i = 0; i < wfStepIdList.size(); i++) {
				Map map = (Map) wfStepIdList.get(i);
				if (arrayWfStepId.isEmpty()) {
					arrayWfStepId = String.valueOf(map.get("WFStepID"));
				} else {
					arrayWfStepId = arrayWfStepId + "," + String.valueOf(map.get("WFStepID"));
				}
			}
			model.put("arrayWfStepId", arrayWfStepId);
			model.put("editMode", editMode);
			model.put("infoMap", infoMap);
			model.put("WFID", request.getParameter("WFID"));
			model.put("languageID", request.getParameter("languageID"));
			model.put("wfName", request.getParameter("wfName"));
			model.put("menu", getLabel(request, commonService));	
			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/addWorkFlowStepPop");
	}
	 */
	@RequestMapping(value = "/WorkFlowRelView.do")
	public String WorkFlowRelView(HttpServletRequest request, HashMap mapValue,
			ModelMap model) throws Exception {

		Map getMap = new HashMap();
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			getMap.put("WFID", request.getParameter("WFID"));
			getMap.put("languageID", request.getParameter("languageID"));
			getMap.put("WFStepID", request.getParameter("WFStepID"));

			getMap = (HashMap) commonService.select(
					"config_SQL.ReloadWorkFlowStep", getMap);

			model.put("Name", request.getParameter("Name"));
			model.put("languageID", request.getParameter("languageID"));
			model.put("resultMap", getMap);
			model.put("Cateogory", request.getParameter("Cateogory"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/sub/WorkFlowRelView");
	}

	// UpdateTemplate START
	@RequestMapping(value = "/UpdateWorkFlowRel.do")
	public String UpdateWorkFlowRel(HttpServletRequest request,
			HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			Map getMap = new HashMap();

			getMap.put("WFID", request.getParameter("objWFID"));
			getMap.put("WFStepID", request.getParameter("objWFStepID"));
			getMap.put("languageID", request.getParameter("getLanguageID"));
			getMap.put("SortNum", request.getParameter("objSortNum"));
			getMap.put("Deactivated", request.getParameter("objDeactivated"));
			getMap.put("Description", request.getParameter("objDescription"));
			getMap.put("Cateogory", request.getParameter("Cateogory"));
			getMap.put("LastUser", request.getParameter("orgLastUser"));

			// String checkNew =
			// StringUtil.checkNull(commonService.selectString("config_SQL.",
			// getMap), "");

			/*
			 * if(checkNew.equals("")){
			 * 
			 * commonService.insert("config_SQL.insertTempDictonaryView",getMap);
			 * 
			 * } else{
			 */

			commonService.update("config_SQL.UpdateWorkFlowStep", getMap);
			commonService.update("config_SQL.UpdateWorkFlowStepRel", getMap);
			// commonService.update("config_SQL.UpdateWorkFlowStepDic", getMap);

			// }

			// target.put(AJAX_ALERT, "���옣�씠 �꽦怨듯븯���뒿�땲�떎.");
			target.put(
					AJAX_ALERT,
					MessageHandler.getMessage(commandMap
							.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " ���옣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(
					AJAX_ALERT,
					MessageHandler.getMessage(commandMap
							.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
		
	}
	
	/**
	 * work flow step rel insert & update
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/saveWorkFlowStepRel.do")
	public String saveWorkFlowStepRel(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			getMap.put("WFStepID", request.getParameter("WFStepID"));
			getMap.put("PreStepID", request.getParameter("PreStepID"));
			getMap.put("SortNum", request.getParameter("SortNum"));
			getMap.put("WFID", request.getParameter("WFID"));
			getMap.put("Creator", request.getParameter("Creator"));

			commonService.insert("config_SQL.InsertWFStepRel", getMap);

			// target.put(AJAX_ALERT, "���옣�씠 �꽦怨듯븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�															
			target.put(AJAX_SCRIPT, "this.selfClose();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	// ///////////////////////////////////////////////////////////////////////////////
	// WorkFlowRel Delete 遺�遺�
	@RequestMapping(value = "/DeleteWorkFlowRel.do")
	public String DeleteWorkFlowRel(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			getMap.put("WFID", request.getParameter("WFID"));
			getMap.put("WFStepID", request.getParameter("WFStepID"));
			getMap.put("PreStepID", request.getParameter("PreStepID"));

			commonService.update("config_SQL.DeleteWfStepRel", getMap);

			if (StringUtil.checkNull(request.getParameter("FinalData"), "")
					.equals("Final")) {

				// target.put(AJAX_ALERT, "�궘�젣媛� �꽦怨듯븯���뒿�땲�떎.");
				target.put(
						AJAX_ALERT,
						MessageHandler.getMessage(commandMap
								.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣
																			// �꽦怨�
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			}

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " �궘�젣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(
					AJAX_ALERT,
					MessageHandler.getMessage(commandMap
							.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�
																		// 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);

	}

	// WorkFlowRel Delete END

	@RequestMapping(value = "/modelType.do")
	public String modelType(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("languageID", request.getParameter("languageID"));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("cfgCode", commandMap.get("cfgCode"));
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			commandMap.put("cfgCode", request.getParameter("cfgCode"));
			List mtList = commonService.selectList("config_SQL.SelectModelType_gridList",commandMap);
			
			JSONArray gridData = new JSONArray(mtList);
			model.put("gridData",gridData);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/model/modelType");

	}
	
	@RequestMapping(value="/getModelTypeList.do")
	public void getModelTypeList(HttpServletRequest request,  HashMap commandMap,HttpServletResponse response) throws Exception{
		try{	
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List mtList = commonService.selectList("config_SQL.SelectModelType_gridList",commandMap);
			
			JSONArray gridData = new JSONArray(mtList);
			
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/plain");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().print(gridData);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
	}

	// modelTypeView
	@RequestMapping(value = "/modelTypeView.do")
	public String modelTypeView(HttpServletRequest request, ModelMap model,HashMap commandMap )
			throws Exception {

		HashMap getMap = new HashMap();
		try {
			
			System.out.println("commandMap:"+commandMap.get("sessionCurrLangType"));
			String viewType = StringUtil.checkNull(request.getParameter("viewType"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			getMap.put("ModelTypeCode", request.getParameter("ModelTypeCode"));
			
			getMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
			
			getMap = (HashMap) commonService.select(
					"config_SQL.ReloadSelectModelType", getMap);
			//===========================================
			if(viewType.equals("N")) {
				Map setMap = new HashMap();
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("languageID", request.getParameter("languageID"));
				String MaxModelTypeID = commonService.selectString("config_SQL.MaxModelType", setMap);
				String MaxModelTypeID1 = MaxModelTypeID.substring(2, 5);
				int intMaxModelType = Integer.parseInt(MaxModelTypeID1);
				int maxcode = intMaxModelType + 1;
				String Maxcode = "MT" + String.format("%03d", maxcode);
				model.put("MaxModelTypeCode", Maxcode);
				model.put("pageNum", request.getParameter("pageNum"));
				
			}
			
			//=======================
			model.put("Name", request.getParameter("Name"));
			model.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			model.put("languageID", request.getParameter("languageID"));
			model.put("pageNum", request.getParameter("pageNum"));
            model.put("cfgCode", request.getParameter("cfgCode"));
			model.put("resultMap", getMap);
			model.put("viewType", viewType);
			model.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/model/modelTypeView");
		// return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/admin/updateModelType.do")
	public String updateModelType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
				String viewType =StringUtil.checkNull(request.getParameter("viewType"),"");
				Map getMap = new HashMap();	
				getMap.put("languageID", commandMap.get("sessionCurrLangType"));
				getMap.put("LastUser", commandMap.get("sessionUserId")); 
				getMap.put("ModelTypeCode", request.getParameter("ModelTypeCode"));
				getMap.put("TypeCode", request.getParameter("ModelTypeCode"));
				getMap.put("IsModel", request.getParameter("objIsModel"));
				getMap.put("Name", request.getParameter("objName")); 
				getMap.put("Description", request.getParameter("objDescription"));
				getMap.put("ArisTypeNum", request.getParameter("ArisTypeNum"));
				getMap.put("Category", StringUtil.checkNull(request.getParameter("MT"), "MT"));
				getMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode")));
				getMap.put("ZoomOption", StringUtil.checkNull(request.getParameter("zoomOption"),""));
				
				String checkNew = StringUtil.checkNull(commonService.selectString("config_SQL.selectModelTypeDic", getMap), "");
				if (checkNew.equals("")) {
					commonService.insert("dictionary_SQL.insertDictionary", getMap);
				} else {
					commonService.update("config_SQL.UpdateModelType", getMap);
					commonService.update("dictionary_SQL.updateDictionary", getMap);
				}
				
	
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "parent.ModelTypeReload('"+viewType+"');");
				//target.put(AJAX_SCRIPT, "parent.ModelTypeReload();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
				//target.put(AJAX_SCRIPT, "parent.goBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " ���옣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	// saveModelType Insert 遺�遺�
	@RequestMapping(value = "/saveModelType.do")
	public String saveModelType(HttpServletRequest request, HashMap commandMap,	ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			String viewType =StringUtil.checkNull(request.getParameter("viewType"),"N");
			String SaveType =StringUtil.checkNull(request.getParameter("SaveType"),"New");
			getMap.put("ModelTypeCode", request.getParameter("objMaxModelTypeCode"));
			getMap.put("TypeCode", request.getParameter("objMaxModelTypeCode"));
			getMap.put("ItemTypeCode", request.getParameter("objItemTypeCode"));
			getMap.put("ArisTypeNum", request.getParameter("ArisTypeNum"));
			getMap.put("Name", request.getParameter("objName"));
			getMap.put("Description", request.getParameter("objDescription"));
			getMap.put("languageID", request.getParameter("LanguageID"));
			getMap.put("Creator", request.getParameter("Creator"));
			getMap.put("Category",StringUtil.checkNull(request.getParameter("MT"), "MT"));
			getMap.put("ZoomOption", request.getParameter("zoomOption"));
				System.out.println("GETMAP: "+getMap);
			if (SaveType.equals("New")) {
				commonService.insert("config_SQL.SaveModelType", getMap);
				commonService.insert("config_SQL.SaveModelTypeDic", getMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			//target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();");
			target.put(AJAX_SCRIPT, "parent.urlReload();parent.ModelTypeReload('"+viewType+"');parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
		
	}

	// saveModelType insert 遺�遺� END

	// ///////////////////////////////////////////////////////////////////////////////
	// ModelFlow Delete 遺�遺�
	@RequestMapping(value = "/admin/DelModelType.do")
	public String DelModelType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			getMap.put("ModelTypeCode", request.getParameter("ModelTypeCode"));
			getMap.put("languageID", request.getParameter("languageID"));
			
			commonService.update("config_SQL.DeleteModelTypeDic", getMap);
			commonService.update("config_SQL.DeleteModelType", getMap);

			if (StringUtil.checkNull(request.getParameter("FinalData"), "")
					.equals("Final")) {

				// target.put(AJAX_ALERT, "�궘�젣媛� �꽦怨듯븯���뒿�땲�떎.");
				target.put(
						AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣
																			// �꽦怨�
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			}

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " �궘�젣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(
					AJAX_ALERT,
					MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�
																		// 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		System.out.println("AJAXPAGE:"+AJAXPAGE);
		return nextUrl(AJAXPAGE);

	}



	// ModelFlow Delete END

		@RequestMapping(value = "/modelTypeTab.do")
		public String modelTypeTab(HttpServletRequest request, ModelMap model)
				throws Exception {

			String url = "/adm/configuration/model/modelTypeTab";

			try {
				model.put("menu", getLabel(request, commonService)); /* Label Setting */

				model.put("languageID", request.getParameter("languageID"));
				model.put("ModelTypeCode", request.getParameter("ModelTypeCode"));
				model.put("pageNum", request.getParameter("pageNum"));
				model.put("Name", request.getParameter("Name"));
				model.put("cfgCode", request.getParameter("cfgCode"));
				HashMap setMap   = new HashMap();
				
				String languageID = StringUtil.checkNull(request.getParameter("languageID"));
				if (languageID.equals("")) {
					languageID = GlobalVal.DEFAULT_LANGUAGE;
				}
				setMap.put("languageID", languageID);
				setMap.put("ModelTypeCode",request.getParameter("ModelTypeCode"));
				setMap.put("pageNum",request.getParameter("pageNum"));
				setMap.put("Name",request.getParameter("Name"));
	
				List mttList = commonService.selectList("config_SQL.SelectSimbolType_gridList", setMap);
	            
				JSONArray gridData = new JSONArray(mttList); //데이터 넘겨줌 
				model.put("gridData", gridData);
				
				System.out.println("GRIDDATA : "+gridData);

			} catch (Exception e) {
				System.out.println(e.toString());
			}
			return nextUrl(url);
		}
		
			

		@RequestMapping(value="/getModelTypeTabList.do")
		public void getModelTypeTabList(HttpServletRequest request,  HashMap commandMap,HttpServletResponse response) throws Exception{
			try{	
				commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
				commandMap.put("ModelTypeCode", commandMap.get("ModelTypeCode"));
				
				List rmtList = commonService.selectList("config_SQL.SelectSimbolType_gridList",commandMap);
				
				JSONArray gridData = new JSONArray(rmtList);
				
				response.setHeader("Cache-Control", "no-cache");
				response.setContentType("text/plain");
				response.setCharacterEncoding("UTF-8");
				response.getWriter().print(gridData);
				
			}catch(Exception e){
				System.out.println(e.toString());
			}
		}	
		
	@RequestMapping(value = "/modelDisplayTypeTab.do")
	public String modelDisplayTypeTab(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {

		String url = "/adm/configuration/model/allocateSymbolAttrDp";
		try {
			model.put("symTypeCode", request.getParameter("ModelTypeCode"));
			model.put("languageID", request.getParameter("languageID"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("Category","MDL");
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("Name", request.getParameter("Name"));
			model.put("cfgCode", request.getParameter("cfgCode"));
			HashMap setMap = new HashMap();
			
			setMap.put("symTypeCode", request.getParameter("ModelTypeCode"));
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("Category", "MDL");

			List AttrTypeDpList = commonService.selectList("config_SQL.getAttrTypeDpList_gridList", setMap);
			
			JSONArray gridData = new JSONArray(AttrTypeDpList);
			model.put("gridData", gridData);			

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	


	@RequestMapping(value = "/admin/AddSymbolType.do")
	public String AddSymbolType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			getMap.put("SymTypeCode", request.getParameter("SymTypeCode"));
			getMap.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			getMap.put("ClassCode", request.getParameter("ClassCode"));
			getMap.put("ItemCategory", request.getParameter("ItemCategory"));
			getMap.put("ModelTypeCode", request.getParameter("ModelTypeCode"));
			getMap.put("languageCode", request.getParameter("LanguageID"));
			getMap.put("Creator", commandMap.get("sessionUserId"));

			commonService.insert("config_SQL.InsertSymbolType", getMap);				
			if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
				System.out.println(StringUtil.checkNull(request.getParameter("FinalData"), ""));
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣
				target.put(AJAX_SCRIPT,"parent.selfClose(); parent.$('#isSubmit').remove();");
			}

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	// ///////////////////////////////////////////////////////////////////////////////
	// SymbolType Delete 遺�遺�
	@RequestMapping(value = "/admin/DeleteSymbolType.do")
	public String DeleteSymbolType(HttpServletRequest request,HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			int gubun = Integer.parseInt(request.getParameter("gubun"));
			getMap.put("typeCode", request.getParameter("SymTypeCode"));
			getMap.put("SymTypeCode", request.getParameter("SymTypeCode"));
			getMap.put("ModelTypeCode", request.getParameter("ModelTypeCode"));
			getMap.put("languageID",request.getParameter("LanguageID"));
			getMap.put("categoryCode","SB");
			
			if(gubun == 1){
				commonService.update("config_SQL.DeleteSymbolTypeList", getMap);
				commonService.update("config_SQL.DeleteSymbolTypeCode", getMap);
				commonService.update("dictionary_SQL.deleteDictionary", getMap);
			}else{
				commonService.update("config_SQL.DeleteSymbolType", getMap);
			}

			if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
				// target.put(AJAX_ALERT, "�궘�젣媛� �꽦怨듯븯���뒿�땲�떎.");
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣
				target.put(AJAX_SCRIPT, " parent.$('#isSubmit').remove();");
			}
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " �궘�젣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		System.out.println(AJAXPAGE);
		return nextUrl(AJAXPAGE);
	}

	// SymbolType Delete END

	/**
	 * ObjectType Detail
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/objectTypeView.do")
	public String objectTypeView(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap getMap = new HashMap();
		Map setMap = new HashMap();
		try {


			String viewType = StringUtil.checkNull(request.getParameter("viewType")," ");
			model.put("viewType", viewType);
			if(viewType.equals("N")) {
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				model.put("languageID", commandMap.get("sessionCurrLangType"));
				model.put("Category", StringUtil.checkNull(request.getParameter("Category")));
				if(request.getParameter("Category").equals("TXT")||request.getParameter("Category").equals("REF") ){
					setMap.put("Category", StringUtil.checkNull(request.getParameter("Category")));
					String MaxObjTypeCode = commonService.selectString("config_SQL.MaxObjTypeCode", setMap);
					String MaxObjTypeCode1 = MaxObjTypeCode.substring(3,7);
					int MaxObjTypeCode2 = Integer.parseInt(MaxObjTypeCode1);	
					int maxcode = MaxObjTypeCode2 + 1;
					String Maxcode = request.getParameter("Category") + String.format("%04d", maxcode);
					model.put("MaxObjectTypeCode", Maxcode);
				}
				else{
					setMap.put("Category", StringUtil.checkNull(request.getParameter("Category")));
					String MaxObjTypeCode = commonService.selectString("config_SQL.MaxObjTypeCode", setMap);
					String MaxObjTypeCode1 = MaxObjTypeCode.substring(2,7);
					int MaxObjTypeCode2 = Integer.parseInt(MaxObjTypeCode1);
					int maxcode = MaxObjTypeCode2 + 1;
					String Maxcode = request.getParameter("Category") + String.format("%05d", maxcode);
					model.put("MaxObjectTypeCode", Maxcode);
				}
			}else if(viewType.equals("C")) {
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
				commandMap.put("categories",StringUtil.checkNull(request.getParameter("categories")));
				model.put("CategoryOption", commonService.selectList("config_SQL.getCategoryCode", commandMap));
				
			}
			else {
				
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				
				getMap.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
				getMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
				getMap = (HashMap) commonService.select("config_SQL.SelectObjectTypeView", getMap);
				
				model.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
				model.put("pageNum", request.getParameter("pageNum"));
				model.put("selectedCat", request.getParameter("selectedCat"));
				model.put("selectedItemType", request.getParameter("selectedItemType"));
				model.put("cfgCode", request.getParameter("cfgCode"));
				model.put("resultMap", getMap);
			}
			
			

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/master data/objectTypeView");
		// return nextUrl(AJAXPAGE);
	}

	/**
	 * UpdateObjectType Update
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/UpdateObjectType.do")
	public String UpdateObjectType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			String rootItemId = StringUtil.checkNull(request.getParameter("objRootItemId"));
			String icon = StringUtil.checkNull(request.getParameter("objIcon"));
			/*if (rootItemId.isEmpty()) {
				rootItemId = null;
			} 
			if (icon.isEmpty()) {
				icon = null;
			} */
			String languageID = StringUtil.checkNull(request.getParameter("getLanguageID"));
			if(languageID.equals("")){ languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));}
			
			getMap.put("ItemTypeCode", request.getParameter("objItemTypeCode"));
			getMap.put("TypeCode", request.getParameter("objItemTypeCode"));
			getMap.put("languageID", languageID);
			
			getMap.put("Deactivated", request.getParameter("objDeactivated"));
			getMap.put("LastUser", request.getParameter("orgLastUser"));
			getMap.put("Name", request.getParameter("objName"));
			getMap.put("Icon", icon);
			getMap.put("RootItemId", rootItemId);
			getMap.put("Description", request.getParameter("objDescription"));
			getMap.put("DefArc", request.getParameter("objDefArc"));
			getMap.put("Category", "OJ");

			String checkNew = StringUtil.checkNull(commonService.selectString("config_SQL.selectObjectTypeDic", getMap), "");

			if (checkNew.equals("")) {
				commonService.insert("config_SQL.InsertObjDictionary", getMap);
			} else {
				commonService.update("config_SQL.UpdateObjectType", getMap);
				commonService.update("config_SQL.UpdateObjDictionary", getMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.goBack();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
		
	}

	@RequestMapping(value = "/admin/SaveObjectType.do")
	public String SaveObjectType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			getMap.put("ItemTypeCode", request.getParameter("objItemTypeCode"));
			getMap.put("Name", request.getParameter("objName"));
			getMap.put("RootItemId", request.getParameter("objRootItemId"));
			getMap.put("Category", request.getParameter("ObjCategory"));
			getMap.put("Description", request.getParameter("objDescription"));
			getMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID"),"1042"));
			getMap.put("Creator", request.getParameter("Creator"));

			if (request.getParameter("SaveType").equals("New")) {
				commonService.insert("config_SQL.SaveObjectType", getMap);
				commonService.insert("config_SQL.SaveObjectTypeDic", getMap);
			}
			

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.goBack();parent.fnCallBack();parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	/**
	 * delObjType
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/delObjType.do")
	public String delObjType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map getMap = new HashMap();
		try {
			
			String[] arrayCode = StringUtil.checkNull(request.getParameter("itemTypeCodes")).split(",");
			
			for (int i = 0; arrayCode.length > i ; i++) {
				getMap.put("TypeCode", arrayCode[i]);
				getMap.put("ItemTypeCode", arrayCode[i]);
				
				commonService.delete("config_SQL.delDic", getMap);
				commonService.delete("config_SQL.deleteObjType", getMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣
			target.put(AJAX_SCRIPT, "this.urlReload();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/subTab.do")
	public String subTab(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "";
		try {
			//硫붾돱 諛쏆븘�삤湲곗슜 language媛� �꽔湲�
			Map setMap = new HashMap();
			setMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));

			model.put("cfgCode", StringUtil.checkNull(request.getParameter("cfgCode")));
			model.put("filter", StringUtil.checkNull(request.getParameter("filter")));
			model.put("itemID", StringUtil.checkNull(request.getParameter("itemID")));
			model.put("AttrLoveDataType", StringUtil.checkNull(request.getParameter("LoveDataType")));
			model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
			model.put("CategoryCode", StringUtil.checkNull(request.getParameter("CategoryCode")));
			model.put("ClassName", StringUtil.checkNull(request.getParameter("ClassName")));
			model.put("Name", StringUtil.checkNull(request.getParameter("Name")));
			model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum")));
			model.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
			model.put("ArcCode", StringUtil.checkNull(request.getParameter("ArcCode")));
			model.put("templCode", StringUtil.checkNull(request.getParameter("templCode")));
			model.put("viewType", StringUtil.checkNull(request.getParameter("viewType")));
			model.put("projectID", StringUtil.checkNull(request.getParameter("projectID")));
			model.put("selectedCat", StringUtil.checkNull(request.getParameter("selectedCat")));
			model.put("selectedItemType", StringUtil.checkNull(request.getParameter("selectedItemType")));
			model.put("type", StringUtil.checkNull(request.getParameter("type")));
			
			url = "/adm/configuration/" + request.getParameter("url");
			
			setMap.put("typeCode",StringUtil.checkNull(request.getParameter("ArcCode")));
			setMap.put("category","AR");
			
			model.put("arcName", StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic", setMap)));
			
			List path = new ArrayList();
			String cfgCode = StringUtil.checkNull(request.getParameter("cfgCode"),"");
			
			path = getCFGMenuPath(cfgCode,StringUtil.checkNull(request.getParameter("languageID")),path, commandMap);
			
			Collections.reverse(path);
			model.put("path",path);
			model.put("cfgCode",cfgCode);
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/addClassPop.do")
	public String addClassPop(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception{
		try{
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			mapValue.put("categories",StringUtil.checkNull(request.getParameter("categories")));
			model.put("CategoryOption", commonService.selectList("config_SQL.getCategoryCode", mapValue));
		}catch(Exception e){
			System.out.println(e.toString());
		}		
		return nextUrl("/popup/addClassPop");
	}
	
	@RequestMapping(value="/addObjectTypePop.do")
	public String addObjectTypePop(HttpServletRequest request, HashMap commamdMap, ModelMap model) throws Exception{
		
		Map setMap = new HashMap();
		try{
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("languageID", commamdMap.get("sessionCurrLangType"));
			model.put("Category", request.getParameter("Category"));
			
			if(request.getParameter("Category").equals("TXT")||request.getParameter("Category").equals("REF") ){
				setMap.put("Category", request.getParameter("Category"));
				String MaxObjTypeCode = commonService.selectString("config_SQL.MaxObjTypeCode", setMap);
				String MaxObjTypeCode1 = MaxObjTypeCode.substring(3,7);
				int MaxObjTypeCode2 = Integer.parseInt(MaxObjTypeCode1);	
				int maxcode = MaxObjTypeCode2 + 1;
				String Maxcode = request.getParameter("Category") + String.format("%04d", maxcode);
				model.put("MaxObjectTypeCode", Maxcode);
			}
			else{
				setMap.put("Category", request.getParameter("Category"));
				String MaxObjTypeCode = commonService.selectString("config_SQL.MaxObjTypeCode", setMap);
				String MaxObjTypeCode1 = MaxObjTypeCode.substring(2,7);
				int MaxObjTypeCode2 = Integer.parseInt(MaxObjTypeCode1);
				int maxcode = MaxObjTypeCode2 + 1;
				String Maxcode = request.getParameter("Category") + String.format("%05d", maxcode);
				model.put("MaxObjectTypeCode", Maxcode);
			}
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/addObjectTypePop");
	}
	
	@RequestMapping(value="/AddAttributePopup.do")
	public String AddAttributePopup(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception{
		try{
			
			model.put("menu", getLabel(request, commonService)); /*Label Setting*/	
			Map setMap = new HashMap();
			
			// get [Max AttributeCode]
			String MaxAttrTypeCode = commonService.selectString("AttributeType_SQL.maxAttrTypeCode", setMap);
			String MaxCode = MaxAttrTypeCode.substring(2,7);
			int intmaxcode = Integer.parseInt(MaxCode);
			int maxcode = intmaxcode + 1;
			String Maxcode = "AT" + String.format("%05d", maxcode);
			
			model.put("Maxcode", Maxcode);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}		
		return nextUrl("/popup/AddAttributePopup");
	}
	
	/**
	 * ReportType Detail
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/reportTypeView.do")
	public String reportTypeView(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap getMap = new HashMap();
		try {

			getMap.put("ReportCode", request.getParameter("ReportCode"));
			getMap.put("languageID", StringUtil.checkNull(request.getParameter("getLanguageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
			getMap = (HashMap) commonService.select("config_SQL.getReportTypeCode_gridList", getMap);
			
			String rptAuthority = StringUtil.checkNull(getMap.get("Authority"));
			
			if("1".equals(rptAuthority)){
				getMap.put("Authority", "SYS");
			}else if(rptAuthority.equals("2")){
				getMap.put("Authority", "TM");
			}else if(rptAuthority.equals("3")){
				getMap.put("Authority", "EDITOR");
			}else{
				getMap.put("Authority", "VIEWER");
			}
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("languageID", StringUtil.checkNull(request.getParameter("getLanguageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("resultMap", getMap);

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/report/reportTypeView");
	}
	
	/**
	 * UpdateReportType Update
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/UpdateReportType.do")
	public String UpdateReportType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			Map getMap = new HashMap();
			
			String rptAuthority = StringUtil.checkNull(request.getParameter("rptAuthority"));
			if("SYS".equals(rptAuthority)){
				getMap.put("Authority", "1");
			}else if(rptAuthority.equals("TM")){
				getMap.put("Authority", "2");
			}else if(rptAuthority.equals("EDITOR")){
				getMap.put("Authority", "3");
			}else{
				getMap.put("Authority", "4");
			}

			getMap.put("reportCode", request.getParameter("reportCode"));
			getMap.put("ItemTypeCode", request.getParameter("reportCode"));
			getMap.put("reportType", request.getParameter("reportType"));
			getMap.put("TypeCode", request.getParameter("reportCode"));
			getMap.put("Name", request.getParameter("rptName"));
			getMap.put("languageID", request.getParameter("getLanguageID"));
			getMap.put("OutputType", request.getParameter("rptOutputType"));
			getMap.put("icon", request.getParameter("icon"));
			
			getMap.put("IsPublic", request.getParameter("hidIsPublic"));
			getMap.put("ReportURL", request.getParameter("rptUrl"));
			getMap.put("ActionType", request.getParameter("actionType"));
			getMap.put("MessageCode", StringUtil.checkNull(request.getParameter("messageCode"),"").trim());
			getMap.put("PWidth", StringUtil.checkNull(request.getParameter("pWidth"),"").trim());
			getMap.put("PHeight", StringUtil.checkNull(request.getParameter("pHeight"),"").trim());
			getMap.put("Deactivated", request.getParameter("hidDeactivated"));
			
			getMap.put("Category", "RP");
			getMap.put("Description", request.getParameter("rptDescription"));
			
			//String checkNew = StringUtil.checkNull(commonService.selectString("config_SQL.selectObjectTypeDic", getMap), "");

			/*if (checkNew.isEmpty()) {
				commonService.insert("config_SQL.InsertObjDictionary", getMap);
			} else {*/
			commonService.update("config_SQL.UpdateReportType", getMap);
			commonService.update("dictionary_SQL.updateDictionary", getMap);
			//}

			// target.put(AJAX_ALERT, "���옣�씠 �꽦怨듯븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.goBack();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
		
	}
	
	/**
	 * Report �떊洹� 異붽� popup �몴�떆
	 * @param request
	 * @param commamdMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/addReportTypePop.do")
	public String addReportTypePop(HttpServletRequest request, HashMap commamdMap, ModelMap model) throws Exception{
		try{
			model.put("languageID", commamdMap.get("sessionCurrLangType"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/addReportTypePop");
	}
	
	/**
	 * INSERT ReportType
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/saveReportType.do")
	public String saveReportType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			Map getMap = new HashMap();
			
			String rptAuthority = StringUtil.checkNull(request.getParameter("rptAuthority"));
			if("SYS".equals(rptAuthority)){
				getMap.put("Authority", "1");
			}else if(rptAuthority.equals("TM")){
				getMap.put("Authority", "2");
			}else if(rptAuthority.equals("EDITOR")){
				getMap.put("Authority", "3");
			}else{
				getMap.put("Authority", "4");
			}

			getMap.put("ReportCode", request.getParameter("rptItemTypeCode"));
			getMap.put("ItemTypeCode", request.getParameter("rptItemTypeCode"));
			getMap.put("Name", request.getParameter("rptName"));
			getMap.put("languageID", commandMap.get("sessionCurrLangType"));
			getMap.put("OutputType", request.getParameter("rptOutputType"));
			getMap.put("IsPublic", request.getParameter("hidIsPublic"));
			getMap.put("ReportURL", request.getParameter("rptUrl"));
			getMap.put("reportType", request.getParameter("rptType"));
			getMap.put("Deactivated", "0");
			getMap.put("Creator", commandMap.get("sessionUserId"));
			
			getMap.put("ActionType", request.getParameter("actionType"));
			getMap.put("MessageCode", StringUtil.checkNull(request.getParameter("messageCode"),"").trim());
			getMap.put("PWidth", StringUtil.checkNull(request.getParameter("pWidth"),"").trim());
			getMap.put("PHeight", StringUtil.checkNull(request.getParameter("pHeight"),"").trim());
			
			getMap.put("Category", "RP");
			getMap.put("Description", request.getParameter("rptDescription"));
			
			// reportTypeCode 以묐났 �떆, 硫붿꽭吏� �몴�떆 �븯怨� 泥섎━瑜� 以묐떒�븿
			String reportTypeCount = commonService.selectString("config_SQL.reportTypeEqualCount", getMap);
			if (!reportTypeCount.equals("0")) {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00081", new String[]{"ReportCode"}));
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			} else {
				commonService.insert("config_SQL.InsertObjDictionary", getMap);
				commonService.update("config_SQL.insertReportType", getMap);
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			}
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
		
	}
	
	/**
	 * Delete ReportType
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/delRptType.do")
	public String delRptType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map getMap = new HashMap();
		try {
			
			String[] arrayCode = StringUtil.checkNull(request.getParameter("reportCodes")).split(",");
			
			for (int i = 0; arrayCode.length > i ; i++) {
				getMap.put("TypeCode", arrayCode[i]);
				getMap.put("ReportCode", arrayCode[i]);
				
				commonService.delete("config_SQL.delDic", getMap);
				commonService.delete("config_SQL.deleteRptType", getMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣
			target.put(AJAX_SCRIPT, "this.urlReload();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	
	/**
	 * FileType Detail
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fileTypeView.do")
	public String fileTypeView(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap getMap = new HashMap();
		try {

			getMap.put("FltpCode", request.getParameter("FltpCode"));
			getMap.put("languageID", StringUtil.checkNull(request.getParameter("getLanguageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
			getMap = (HashMap) commonService.select("config_SQL.FileType_gridList", getMap);
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("languageID", StringUtil.checkNull(request.getParameter("getLanguageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("resultMap", getMap);

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/file/fileTypeView");
	}
	
	/**
	 * updateFileType Update
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/updateFileType.do")
	public String updateFileType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			Map getMap = new HashMap();
			
			getMap.put("FltpCode", request.getParameter("FltpCode"));
			getMap.put("TypeCode", request.getParameter("FltpCode"));
			getMap.put("FilePath", request.getParameter("fltpPath"));
			getMap.put("Name", request.getParameter("fltpName"));
			getMap.put("languageID", request.getParameter("getLanguageID"));
			getMap.put("isPublic", StringUtil.checkNull(request.getParameter("isPublic"),"0")); 
			getMap.put("docCategory", request.getParameter("category"));
			getMap.put("Description", request.getParameter("fltpDescription"));		
			getMap.put("RevisionYN", StringUtil.checkNull(request.getParameter("revisionMgt"),"N")); 
			
			String checkNew = StringUtil.checkNull(commonService.selectString("dictionary_SQL.selectDictionary", getMap), "");
			if (checkNew.isEmpty()) {
				commonService.insert("dictionary_SQL.insertDictionary", getMap);
			} else {
				commonService.update("config_SQL.updateFileType", getMap);
				commonService.update("dictionary_SQL.updateDictionary", getMap);
			}

			// target.put(AJAX_ALERT, "���옣�씠 �꽦怨듯븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.goBack();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
		
	}
	
	/**
	 * FileType �떊洹� 異붽� popup �몴�떆
	 * @param request
	 * @param commamdMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/addFileTypePop.do")
	public String addFileTypePop(HttpServletRequest request, HashMap commamdMap, ModelMap model) throws Exception{
		try{
			model.put("defaultFilePath", "D://OLMFILE//document/");
			model.put("languageID", commamdMap.get("sessionCurrLangType"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/addFileTypePop");
	}
	
	/**
	 * INSERT FileType
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/saveFileType.do")
	public String saveFileType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			Map getMap = new HashMap();
			
			getMap.put("FltpCode", request.getParameter("fltpCode"));
			getMap.put("TypeCode", request.getParameter("fltpCode"));
			getMap.put("ItemTypeCode", request.getParameter("fltpCode"));
			getMap.put("Name", request.getParameter("fileName"));
			getMap.put("FilePath", request.getParameter("filePath"));
			getMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
			getMap.put("Category", "FLTP");
			getMap.put("Description", request.getParameter("fileDescription"));
			
			// fileTypeCode 以묐났 �떆, 硫붿꽭吏� �몴�떆 �븯怨� 泥섎━瑜� 以묐떒�븿
			String fileTypeCount = commonService.selectString("config_SQL.fileTypeEqualCount", getMap);
			if (!fileTypeCount.equals("0")) {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00081", new String[]{"Code"}));
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			} else {
				commonService.insert("dictionary_SQL.insertDictionary", getMap);
				commonService.update("config_SQL.insertFileType", getMap);
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			}

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * Delete FLTPType
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/delFileType.do")
	public String delFileType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map getMap = new HashMap();
		try {
			
			String[] arrayCode = StringUtil.checkNull(request.getParameter("fltpCodes")).split(",");
			
			for (int i = 0; arrayCode.length > i ; i++) {
				getMap.put("TypeCode", arrayCode[i]);
				getMap.put("FltpCode", arrayCode[i]);
				
				commonService.delete("config_SQL.delDic", getMap);
				commonService.delete("config_SQL.deleteFileType", getMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣
			target.put(AJAX_SCRIPT, "this.urlReload();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/addConnectionType.do")
	public String addConnectionType(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception{
		try{
			
			mapValue.put("languageID", mapValue.get("sessionCurrLangType"));
			mapValue.put("option", "OJ");
			model.put("itemTypeCodeList", commonService.selectList("config_SQL.getObjectCodeFromClass",mapValue));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			
		}catch(Exception e){
			System.out.println(e.toString());
		}		
		return nextUrl("/popup/addConnectionType");
	}
	
	/**
	 * saveClassType Insert
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "admin/saveConType.do")
	public String saveConType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map getMap = new HashMap();
		
		try {
			
			// 湲곗〈 DB�쓽 ItemTypeCode議댁옱 泥댄겕
			getMap.put("ItemTypeCode", request.getParameter("connectionTypeId"));
			
			if ("0".equals(commonService.selectString("config_SQL.getConnectionTypeCnt", getMap))) {
				getMap.put("TypeCode", request.getParameter("connectionTypeId"));
				getMap.put("languageID", commandMap.get("sessionCurrLangType"));
				getMap.put("FromItemTypeCode",request.getParameter("fromTypeCode"));
				getMap.put("ToItemTypeCode", request.getParameter("toTypeCode"));
				getMap.put("Name", request.getParameter("connectionTypeName"));
				getMap.put("Description", request.getParameter("Description"));
				getMap.put("Category", "CN");
				getMap.put("Active", 0);
				getMap.put("Creator", commandMap.get("sessionUserId"));
				String classCode = StringUtil.checkNull(request.getParameter("connectionTypeId")).substring(3,7);
				getMap.put("ItemClassCode", "CNL" + classCode);
				
				commonService.insert("config_SQL.insertItemType", getMap);
				commonService.insert("config_SQL.InsertItemClass", getMap);
				commonService.insert("dictionary_SQL.insertDictionary", getMap);
				
				// target.put(AJAX_ALERT, "���옣�씠 �꽦怨듯븯���뒿�땲�떎.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();");
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00081", new String[]{"Connection Type"}));
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			}
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " ���옣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * Connection Type �궘�젣
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/delConnectionType.do")
	public String delConnectionType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map getMap = new HashMap();
		
		try {
			String[] arrayCode = StringUtil.checkNull(request.getParameter("connectionTypeCode")).split(",");
			
			for (int i = 0; arrayCode.length > i ; i++) {
				getMap.put("ItemTypeCode", arrayCode[i]);
				getMap.put("TypeCode", arrayCode[i]);
				commonService.delete("config_SQL.deleteObjType", getMap);
				commonService.delete("config_SQL.delDic", getMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣 �꽦怨�
			target.put(AJAX_SCRIPT, "this.urlReload();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�														
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * connectionType Detatil
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/connectionTypeView.do")
	public String connectionTypeView(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {

		HashMap getMap = new HashMap();
		try {

			getMap.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			getMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
			getMap = (HashMap) commonService.select("config_SQL.getConnectTypeList", getMap);

			model.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
			model.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("resultMap", getMap);
			model.put("selectedCat", request.getParameter("selectedCat"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/master data/connectionTypeView");
	}
	
	/**
	 * Update ConnectionType
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/editConnectionType.do")
	public String editConnectionType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			String rootItemId = StringUtil.checkNull(request.getParameter("conRootItemId"));
			String icon = StringUtil.checkNull(request.getParameter("conIcon"));
			/*if (rootItemId.isEmpty()) {
				rootItemId = null;
			} 
			if (icon.isEmpty()) {
				icon = null;
			} */
			getMap.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			getMap.put("TypeCode", request.getParameter("ItemTypeCode"));
			getMap.put("languageID", request.getParameter("getLanguageID"));
			getMap.put("Icon", icon);
			getMap.put("Deactivated", request.getParameter("conDeactivated"));
			getMap.put("RootItemId", rootItemId);
			getMap.put("DefArc", request.getParameter("conDefArc"));
			getMap.put("FromItemTypeCode", request.getParameter("fromItemTypeCode"));
			getMap.put("ToItemTypeCode", request.getParameter("toItemTypeCode"));
			/*getMap.put("FilePath", request.getParameter("conFilePath"));
			getMap.put("DMS", request.getParameter("conDMS"));*/
			
			getMap.put("Name", request.getParameter("conName"));
			getMap.put("Description", request.getParameter("conDescription"));
			getMap.put("Category", "CN");
			
			String checkNew = StringUtil.checkNull(commonService.selectString("config_SQL.selectObjectTypeDic", getMap), "");

			if (checkNew.isEmpty()) {
				commonService.insert("config_SQL.InsertObjDictionary", getMap);
			} else {
				commonService.update("config_SQL.UpdateObjectType", getMap);
				commonService.update("config_SQL.UpdateObjDictionary", getMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.goBack();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * Insert WorkFlow
	 * @param request
	 * @param mapValue
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/addWorkFlowPop.do")
	public String addWorkFlowPop(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception{
		
		Map setMap = new HashMap();
		try{
			
			String MaxWFID = commonService.selectString("config_SQL.MaxWFID", setMap);
			String MaxWFID1 = MaxWFID.substring(2,5);
			int intMaxCode = Integer.parseInt(MaxWFID1);
			int maxcode = intMaxCode + 1;
			String Maxcode = "WF" + String.format("%03d", maxcode);
			
			model.put("Maxlovcode", Maxcode);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			model.put("languageID", request.getParameter("languageID"));
			
		}catch(Exception e){
			System.out.println(e.toString());
		}		
		return nextUrl("/popup/workFlowPop");
	}
	
	/**
	 * workFlowStepRel List �솕硫� �몴�떆
	 * @param request
	 * @param mapValue
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/workFlowStepRel.do")
	public String workFlowStepRel(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			model.put("pageNum", request.getParameter("pageNum"));
			model.put("languageID", request.getParameter("languageID"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/workFlowType");
	}
	
	@RequestMapping(value = "/symbolType.do")
	public String symbolType(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		try {
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("pageNum", request.getParameter("pageNum"));
				model.put("cfgCode", commandMap.get("cfgCode"));
				
				HashMap setMap = new HashMap();
				setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				setMap.put("cfgCode", request.getParameter("cfgCode"));
				List sbtpList = commonService.selectList("config_SQL.getSymbolList_gridList",setMap);
				
				JSONArray gridData = new JSONArray(sbtpList);
				model.put("gridData",gridData);
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/model/symbolTypeList");
	}
	
	@RequestMapping(value = "/symbolTypeDetail.do")
	public String symbolTypeDetail(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap getMap = new HashMap();
		try {
				String SymTypeCode = StringUtil.checkNull(request.getParameter("SymTypeCode"));
				String viewType = StringUtil.checkNull(request.getParameter("viewType"),"");
				if(viewType.equals("E")){
					setMap.put("SymTypeCode",SymTypeCode);
					//setMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
					setMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
					getMap = (HashMap) commonService.select("config_SQL.getSymbolList_gridList", setMap);
				
				}
			    if(viewType.equals("N")) {
					model.put("menu", getLabel(request, commonService)); /* Label Setting */
					model.put("languageID", request.getParameter("languageID"));
					String MaxSymbolTypeID = commonService.selectString("config_SQL.getMaxSymTypeCode", setMap);
					model.put("MaxSymbolTypeCode", MaxSymbolTypeID);
					model.put("pageNum", request.getParameter("pageNum"));
					
				}
				
				
				model.put("resultMap", getMap);
				model.put("viewType", viewType);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("pageNum", request.getParameter("pageNum"));
				model.put("cfgCode", request.getParameter("cfgCode"));
				
				//model.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType"))));
				model.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/model/symbolTypeDetail");
	}
	
	@RequestMapping(value = "/admin/saveSymbolType.do")
	public String saveSymbolType(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String viewType = StringUtil.checkNull(request.getParameter("viewType"));
				String ArisTypeNum = StringUtil.checkNull(request.getParameter("ArisTypeNum"));
				String languageID = StringUtil.checkNull(request.getParameter("getLanguageID"),commandMap.get("sessionCurrLangType").toString());
				
				String SymTypeCode = StringUtil.checkNull(request.getParameter("SymTypeCode"));
				String SymbolName = StringUtil.checkNull(request.getParameter("SymbolName"));
				String Deactivated = StringUtil.checkNull(request.getParameter("Deactivated"),"0");
				String ItemCategory = StringUtil.checkNull(request.getParameter("ItemCategory"));
				
				String ItemTypeCode = StringUtil.checkNull(request.getParameter("ItemTypeCode"));
				String ClassCode = StringUtil.checkNull(request.getParameter("ClassCode"));
				String DefWidth = StringUtil.checkNull(request.getParameter("DefWidth"));
				String DefHeight = StringUtil.checkNull(request.getParameter("DefHeight"));
				
				String DefFillColor = StringUtil.checkNull(request.getParameter("DefFillColor"));
				String DefStrokeColor = StringUtil.checkNull(request.getParameter("DefStrokeColor"));
				String DefGradientColor = StringUtil.checkNull(request.getParameter("DefGradientColor"));
				String DefShadow = StringUtil.checkNull(request.getParameter("DefShadow"));
				
				String DefFontColor = StringUtil.checkNull(request.getParameter("DefFontColor"));
				String DefLabelBGColor = StringUtil.checkNull(request.getParameter("DefLabelBGColor"));
				String DefSpacingTop = StringUtil.checkNull(request.getParameter("DefSpacingTop"));
				String DefFontSize = StringUtil.checkNull(request.getParameter("DefFontSize"));

				String DefLovCode = StringUtil.checkNull(request.getParameter("DefLovCode"));
				String SortNum = StringUtil.checkNull(request.getParameter("SortNum"));
				String ImagePath = StringUtil.checkNull(request.getParameter("ImagePath"));
				String description = StringUtil.checkNull(request.getParameter("objDescription"));
				
				setMap.put("languageID", languageID);
				setMap.put("ArisTypeNum",ArisTypeNum);
				setMap.put("SymTypeCode",SymTypeCode);
				setMap.put("SymbolName",SymbolName);
				setMap.put("Deactivated",Deactivated);
				setMap.put("DefWidth",DefWidth);
				setMap.put("DefHeight",DefHeight);
				setMap.put("DefFillColor",DefFillColor);
				setMap.put("DefStrokeColor",DefStrokeColor);
				setMap.put("DefGradientColor",DefGradientColor);
				setMap.put("DefShadow",DefShadow);
				setMap.put("LastUser", commandMap.get("sessionUserId")); 
				setMap.put("ItemCategory",ItemCategory);
				setMap.put("ItemTypeCode",ItemTypeCode);
				setMap.put("ClassCode",ClassCode);
				setMap.put("DefFontColor",DefFontColor);
				setMap.put("DefLabelBGColor",DefLabelBGColor);
				setMap.put("DefSpacingTop",DefSpacingTop);
				setMap.put("DefFontSize",DefFontSize);
				setMap.put("SortNum",SortNum);
				setMap.put("DefLovCode",DefLovCode);
				setMap.put("ImagePath",ImagePath);
				//setMap.put("SymbolTypeCode", request.getParameter("objMaxSymbolTypeCode"));
				//setMap.put("TypeCode", request.getParameter("objMaxSymbolTypeCode"));
				if(viewType.equals("E")){
					commonService.update("config_SQL.updateSymbolType", setMap);
					commonService.update("config_SQL.updateSymbolName", setMap);
				}else{
					String newSymTypeCode = commonService.selectString("config_SQL.getMaxSymTypeCode", setMap).trim();
					setMap.put("SymTypeCode", newSymTypeCode);
					setMap.put("SymCategory", "SYM"); 
					commonService.insert("config_SQL.insertSymType", setMap);

					setMap.put("TypeCode", newSymTypeCode);
					setMap.put("Name", SymbolName);
					setMap.put("languageID", languageID);
					setMap.put("Description",description);
					setMap.put("ClientID", commandMap.get("sessionUserId"));
					setMap.put("Category", "SB"); 

					commonService.insert("dictionary_SQL.insertDictionary", setMap);
				}
				model.put("pageNum", request.getParameter("pageNum"));
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "parent.goBack();");
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/allocateArchitecture.do")
	public String allocateArchitecture(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		try {
				String ArcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				
				model.put("ArcCode", ArcCode);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("pageNum", request.getParameter("pageNum"));
				model.put("viewType", request.getParameter("viewType"));
			
				List path = new ArrayList();
				String cfgCode = StringUtil.checkNull(request.getParameter("cfgCode"),"");
				
				path = getCFGMenuPath(cfgCode,StringUtil.checkNull(request.getParameter("languageID")),path, commandMap);
				
				Collections.reverse(path);
				model.put("path",path);
				model.put("cfgCode",cfgCode);
				
			    commandMap.put("ArcCode", ArcCode);
		        commandMap.put("languageID", languageID);
		        List allArcList = commonService.selectList("config_SQL.getAllocatedArchitectureList_gridList", commandMap);
		        JSONArray gridData = new JSONArray(allArcList);
		        model.put("gridData",gridData);	
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/menu/allocateArchitecture");
	}
	
	@RequestMapping(value = "/addArcListPop.do")
	public String addArcListPop(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		try {
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String ArcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
				
		        commandMap.put("languageID", languageID);
		        commandMap.put("arcCode", ArcCode);
		        List addArcList = commonService.selectList("config_SQL.getArcTreeList_gridList", commandMap);
		        JSONArray gridData = new JSONArray(addArcList);
		        model.put("gridData",gridData);	
		        
				model.put("ArcCode", ArcCode);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("pageNum", request.getParameter("pageNum"));
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/menu/addArcListPop");
	}
	
	@RequestMapping(value = "/updateParentArc.do")
	public String updateParentArc(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String ArcCode = StringUtil.checkNull(request.getParameter("arcCode"));
				String ParentArcCode = StringUtil.checkNull(request.getParameter("parentArcCode"));
				String languageID = StringUtil.checkNull(request.getParameter("getLanguageID"),commandMap.get("sessionCurrLangType").toString());
				
				String ArcCodeArr[] = ArcCode.split(",");
				setMap.put("ParentID", ParentArcCode);
				setMap.put("languageID", languageID);
				setMap.put("LastUser", commandMap.get("sessionUserId"));
				for(int i=0; i<ArcCodeArr.length; i++){
					setMap.remove(ArcCode);
					setMap.put("ArcCode", ArcCodeArr[i]);
					commonService.update("config_SQL.updateParentArcCode", setMap);
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "parent.fnCallBack();");
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/deleteParentArc.do")
	public String deleteParentArc(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String ArcCode = StringUtil.checkNull(request.getParameter("arcCode"));
				String ArcCodeArr[] = ArcCode.split(",");
				setMap.put("LastUser", commandMap.get("sessionUserId"));
				for(int i=0; i<ArcCodeArr.length; i++){
					setMap.remove("ArcCode");
					setMap.put("ArcCode", ArcCodeArr[i]);
					commonService.update("config_SQL.updateNullParentID", setMap);
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "doOTSearchList();");
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/addArcFilterListPop.do")
	public String addArcFilterListPop(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		try {
				String ArcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
				String languageID = StringUtil.checkNull(request.getParameter("languageID"));
				
				model.put("ArcCode", ArcCode);
				model.put("languageID", languageID);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/addArcFilterListPop");
	}
	
	@RequestMapping(value = "/saveArcFilter.do")
	public String saveArcFilter(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String rootItemId = StringUtil.checkNull(request.getParameter("rootItemId"));
				String conTypeCode = StringUtil.checkNull(request.getParameter("conTypeCode"));
				String objTypeCode = StringUtil.checkNull(request.getParameter("objTypeCode"));
				String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
				
				setMap.put("rootItemId", rootItemId);
				setMap.put("conTypeCode", conTypeCode);
				setMap.put("objTypeCode", objTypeCode);
				setMap.put("arcCode", arcCode);
				setMap.put("userId", commandMap.get("sessionUserId"));
			
				commonService.insert("config_SQL.insertArcFilter", setMap);
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT,  "fnCallBack();");
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/deleteArcFilter.do")
	public String deleteArcFilter(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String ArcCode = StringUtil.checkNull(request.getParameter("arcCode"));
				String conTypeCode = StringUtil.checkNull(request.getParameter("conTypeCode"));
				String rootItemID =  StringUtil.checkNull(request.getParameter("rootItemID"));
				String conTypeCodeArr[] = conTypeCode.split(",");
				String rootItemIDArr[] = rootItemID.split(",");
				
				setMap.put("ArcCode", ArcCode);
				for(int i=0; i<conTypeCodeArr.length; i++){
					setMap.remove("ConTypeCode");
					setMap.remove("RootItemID");
					setMap.put("ConTypeCode", conTypeCodeArr[i]);
					setMap.put("RootItemID", rootItemIDArr[i]);
					commonService.update("config_SQL.deleteArcFilter", setMap);
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
				target.put(AJAX_SCRIPT, "fnCallBack();");
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/searchRootItemTreePop.do")
	public String searchRootItemTreePop(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		Map setMap = new HashMap();
		Map resultMap = new HashMap();
		try {
				String ArcCode = StringUtil.checkNull(request.getParameter("ArcCode"));
				String languageID = StringUtil.checkNull(request.getParameter("languageID"));
				String conTypeCode = StringUtil.checkNull(request.getParameter("conTypeCode"));
							
				setMap.put("conTypeCode", conTypeCode);
				resultMap = commonService.select("config_SQL.getItemFromToType", setMap);
				
				model.put("fromItemTypeCode", resultMap.get("fromItemTypeCode"));
				model.put("toItemTypeCode", resultMap.get("toItemTypeCode"));
				model.put("conTypeCode", conTypeCode);
				model.put("ArcCode", ArcCode);
				model.put("languageID", languageID);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/menu/searchRootItemTreePop");
	}
	
	@RequestMapping(value = "/saveArcClass.do")
	public String saveArcClass(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
				String ClassCode = StringUtil.checkNull(request.getParameter("ClassCode"));
				String IncludedCode = StringUtil.checkNull(request.getParameter("IncludedCode"));
				String IsSecondaryCode = StringUtil.checkNull(request.getParameter("IsSecondaryCode"));
				
				setMap.put("arcCode", arcCode);
				setMap.put("ClassCode", ClassCode);
				setMap.put("IncludedCode", IncludedCode);
				setMap.put("IsSecondaryCode", IsSecondaryCode);
				setMap.put("userId", commandMap.get("sessionUserId"));
				
				commonService.update("config_SQL.insertArcClass", setMap);
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "fnCallBack();");
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/updateArcClass.do")
	public String updateArcClass(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
				String ClassCode = StringUtil.checkNull(request.getParameter("ClassCode"));
				String IncludedCode = StringUtil.checkNull(request.getParameter("IncludedCode"));
				String IsSecondaryCode = StringUtil.checkNull(request.getParameter("IsSecondaryCode"));
				String ItemClassCode = StringUtil.checkNull(request.getParameter("ItemClassCode"));
				
				setMap.put("arcCode", arcCode);
				setMap.put("ClassCode", ClassCode);
				setMap.put("ItemClassCode", ItemClassCode);
				setMap.put("IncludedCode", IncludedCode);
				setMap.put("IsSecondaryCode", IsSecondaryCode);
				setMap.put("userId", commandMap.get("sessionUserId"));
				
				commonService.update("config_SQL.updateArcClass", setMap);
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "fnCallBack();");
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/deleteArcClass.do")
	public String deleteArcClass(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
				String reqClassCode = StringUtil.checkNull(request.getParameter("ClassCode"));
				
				setMap.put("arcCode", arcCode);
				setMap.remove("ClassCode");
				setMap.put("ClassCode", reqClassCode);
				commonService.delete("config_SQL.deleteArcClass", setMap);

				if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
					target.put(AJAX_SCRIPT, "fnCallBack();");
				}
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/saveArcDim.do")
	public String saveArcDim(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
				String objTypeCode = StringUtil.checkNull(request.getParameter("objTypeCode"));
				String dimTypeId = StringUtil.checkNull(request.getParameter("dimTypeId"));
				String dimValueId = StringUtil.checkNull(request.getParameter("dimValueId"));
				
				setMap.put("arcCode", arcCode);
				setMap.put("objTypeCode", objTypeCode);
				setMap.put("dimTypeId", dimTypeId);
				setMap.put("defDimValueId", dimValueId);
				setMap.put("userId", commandMap.get("sessionUserId"));
				
				commonService.update("config_SQL.insertArcDim", setMap);
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "fnCallBack();");
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/deleteArcDim.do")
	public String deleteArcDim(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String arcCode = StringUtil.checkNull(request.getParameter("arcCode"));
				String reqDimTypeId = StringUtil.checkNull(request.getParameter("dimTypeId"));
				
				setMap.put("arcCode", arcCode);
				setMap.remove("dimTypeId");
				setMap.put("dimTypeId", reqDimTypeId);
				commonService.delete("config_SQL.deleteArcDim", setMap);
			
				if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
					target.put(AJAX_SCRIPT, "fnCallBack();");
				}		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	
	/**
	 * Menu Detail
	 * @param request
	 * @param commadMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/menuTypeDetailView.do")
	public String menuTypeDetailView(HttpServletRequest request, HashMap commadMap, ModelMap model) throws Exception{
		HashMap getMap = new HashMap();
		try{
			
			commadMap.put("MenuID", request.getParameter("menuID"));
			getMap = (HashMap)commonService.select("config_SQL.getDefineMenutypeCode_gridList", commadMap);
			
			commadMap.put("languageID", StringUtil.checkNull(request.getParameter("getLanguageID"), String.valueOf(commadMap.get("sessionCurrLangType"))));
			commadMap.put("mnCategory", "LN");
			List labelList = commonService.selectList("menu_SQL.menuName",commadMap);
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("resultMap", getMap);	
			model.put("labelList", labelList);
			model.put("pageNum", request.getParameter("pageNum"));
			
		}catch(Exception e){
			System.out.println(e.toString());
		}		
		return nextUrl("/adm/configuration/menu/menuTypeDetailView");
	
	}
	
	/**
	 * update Menu
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/updateMenu.do")
	public String updateMenu(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			Map getMap = new HashMap();

			getMap.put("MenuID", request.getParameter("menuId"));
			getMap.put("MenuCat", request.getParameter("menuType"));
			getMap.put("URL", request.getParameter("menuUrl"));
			getMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID"),""));
			getMap.put("Icon", request.getParameter("menuIcon"));
			getMap.put("Deactivated", request.getParameter("menuDeactivated"));
			getMap.put("VarFilter", request.getParameter("menuVarFilter"));
			commonService.update("config_SQL.updateMenu", getMap);
			
			getMap.put("Name", request.getParameter("menuName"));
			getMap.put("TypeCode", request.getParameter("menuId"));
			getMap.put("Category","MN");
			getMap.put("languageID",request.getParameter("languageID"));
			getMap.put("Description",request.getParameter("description"));
			commonService.update("dictionary_SQL.updateDictionary", getMap);

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.fnCallBack();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
		
	}
	
	/**
	 * Menu delect
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/deleteMenu.do")
	public String deleteMenu(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			
			String[] arrayCode = StringUtil.checkNull(request.getParameter("menuIds")).split(",");
			for (int i = 0; arrayCode.length > i ; i++) {
				getMap.put("MenuID", arrayCode[i]);
				getMap.put("typeCode", arrayCode[i]);
				getMap.put("categoryCode","MN");
				getMap.put("languageID",request.getParameter("languageID"));
				commonService.delete("config_SQL.deleteMenu",getMap);
				commonService.delete("dictionary_SQL.deleteDictionary",getMap);
			}
		
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣 �꽦怨�
			target.put(AJAX_SCRIPT,"this.urlReload();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);
		
	}
	
	/**
	 * add new Menu form
	 * @param request
	 * @param mapValue
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/addMenuPopup.do")
	public String addMenuPopup(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception{
		try{
			mapValue.put("languageID", mapValue.get("sessionCurrLangType"));
			mapValue.put("mnCategory", "LN");
			List labelList = commonService.selectList("menu_SQL.menuName",mapValue);
			
			model.put("labelList", labelList);
			model.put("menu", getLabel(request, commonService)); /*Label Setting*/	
			
		}catch(Exception e){
			System.out.println(e.toString());
		}		
		return nextUrl("/popup/addMenuPopup");
	}
	
	/**
	 * Menu Insert
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/saveNewMenu.do")
	public String saveNewMenu(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			String menuID = StringUtil.checkNull(request.getParameter("menuID"),"");
			getMap.put("MenuID", menuID);
			getMap.put("TypeCode", menuID);
			String menuIDCNT = StringUtil.checkNull(commonService.selectString("config_SQL.getMenuIDCNT", getMap));			
			
			if(Integer.parseInt(menuIDCNT) == 0){
				getMap.put("MenuCat", request.getParameter("menuType"));
				/*getMap.put("DicCode", request.getParameter("menuName"));*/
				getMap.put("URL", request.getParameter("menuUrl"));
				getMap.put("VarFilter", request.getParameter("menuVarFilter"));
				getMap.put("MNLVL", request.getParameter("menuMnlvl"));
				getMap.put("Icon", request.getParameter("menuIcon"));
				getMap.put("Deactivated", request.getParameter("menuDeactivated"));
				
				getMap.put("Name",request.getParameter("menuName"));
				getMap.put("languageID",request.getParameter("languageID"));
				getMap.put("Category","MN");
				commonService.insert("config_SQL.insertMenu",getMap);	
				commonService.insert("config_SQL.insertDictionary",getMap);	
				 						
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
				target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();");
			}else{ // menuID 以묐났 -> return
				target.put(AJAX_SCRIPT, "parent.fnDuplicatedID();parent.$('#isSubmit').remove();");
			}

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/getMenuTypeList.do")
	public void getMenuTypeList(HttpServletRequest request,  HashMap commandMap,HttpServletResponse response) throws Exception{
		try{	
			commandMap.put("LanguageID", commandMap.get("sessionCurrLangType"));			
			List menuList = commonService.selectList("config_SQL.getDefineMenutypeCode_gridList", commandMap);
			JSONArray gridData = new JSONArray(menuList);
			
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/plain");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().print(gridData);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
	}
	
	
	@RequestMapping(value = "/arcMenu.do")
	public String arcMenu(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/adm/configuration/menu/arcMenu";
		try {
			Map setMap = new HashMap();
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("languageID",  StringUtil.checkNull(request.getParameter("languageID"), ""));
			model.put("arcCode", StringUtil.checkNull(request.getParameter("ArcCode")));
	
			setMap.put("languageID",StringUtil.checkNull(request.getParameter("languageID")));
			setMap.put("arcCode",StringUtil.checkNull(request.getParameter("ArcCode")));
			List list = commonService.selectList("config_SQL.getArcMenuAlloc_gridList", setMap);
			JSONArray gridData = new JSONArray(list);
			model.put("gridData",gridData);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/getArcMenuList.do")
	public void getArcMenuList(HttpServletRequest request,  HashMap commandMap,HttpServletResponse response) throws Exception{
		try{	
			commandMap.put("languageID",StringUtil.checkNull(request.getParameter("languageID")));
			commandMap.put("arcCode",StringUtil.checkNull(request.getParameter("ArcCode")));
			List list = commonService.selectList("config_SQL.getArcMenuAlloc_gridList", commandMap);
			JSONArray gridData = new JSONArray(list);
			
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/plain");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().print(gridData);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
	}
	
	@RequestMapping(value = "/menuListPop.do")
	public String menuListPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/menu/arcMenuListPop";
		try {
				Map setMap = new HashMap();
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("languageID",  StringUtil.checkNull(request.getParameter("languageID"), ""));
				model.put("menuCat",  StringUtil.checkNull(request.getParameter("menuCat"), ""));
				
				setMap.put("languageID",StringUtil.checkNull(commandMap.get("languageID")));
				List list = commonService.selectList("config_SQL.getMenuList_gridList", setMap);
				JSONArray gridData = new JSONArray(list);
				model.put("gridData",gridData);
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/admin/saveArcMenu.do")
	public String saveArcMenu(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			String viewType = StringUtil.checkNull(request.getParameter("viewType"), "");
			getMap.put("menuID", StringUtil.checkNull(request.getParameter("menuId"), ""));
			getMap.put("classCode", StringUtil.checkNull(request.getParameter("classCode"), ""));
			getMap.put("arcCode", StringUtil.checkNull(request.getParameter("arcCode"), ""));
			getMap.put("sort", StringUtil.checkNull(request.getParameter("sortNum"), ""));
			getMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), ""));
			getMap.put("menuDicCode", StringUtil.checkNull(request.getParameter("dicCode"), ""));
			getMap.put("varFilter", StringUtil.checkNull(request.getParameter("varFilter"), ""));
			getMap.put("hideOption",StringUtil.checkNull(request.getParameter("hideOption"), ""));
			getMap.put("scrURL",StringUtil.checkNull(request.getParameter("scrURL"), ""));
			
			if(viewType.equals("N")){
				String seq = commonService.selectString("config_SQL.getMaxMenuAllocSeq",getMap);
				getMap.put("seq", seq);
				commonService.insert("config_SQL.insertArcMenu",getMap);	
			}else{
				getMap.put("seq", StringUtil.checkNull(request.getParameter("seq"), ""));
				commonService.insert("config_SQL.updateArcMenu",getMap);
			}
			 						
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.fnReload();$('#isSubmit').remove()");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/admin/deleteArcMenu.do")
	public String deleteArcMenu(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String reqSeq = StringUtil.checkNull(request.getParameter("seq"));
				String seq[] = reqSeq.split(",");
		
				for(int i=0; i<seq.length; i++){
					setMap.remove("seq");
					setMap.put("seq", seq[i]);
					commonService.delete("config_SQL.deleteArcMenu", setMap);
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
				target.put(AJAX_SCRIPT, "fnCallBack()");
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	
	@RequestMapping(value = "/updateArcStNum.do")
	public String updateArcStNum(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map setMap = new HashMap();

			setMap.put("sortNum", request.getParameter("sortNum"));
			setMap.put("arcCode", request.getParameter("arcCode"));
			
			commonService.insert("config_SQL.updateArcStNum",setMap);			
			 						
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "fnCallBack();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/subBoardMgtAlloc.do")
	public String subBoardMgtAlloc(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/adm/configuration/menu/subBoardMgtAlloc";
		try {
			System.out.println("subBoardMgtAlloc.do호출");
				Map setMap = new HashMap();
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("templCode",  StringUtil.checkNull(request.getParameter("templCode"), ""));
				model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), ""));
				model.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), ""));
				model.put("viewType", StringUtil.checkNull(request.getParameter("viewType"), ""));
				
				setMap.put("languageID", model.get("languageID"));
				setMap.put("templCode", model.get("templCode"));
				
				List<String> subBrdList = commonService.selectList("config_SQL.getBoardMgtAlloc_gridList",setMap);
				JSONArray gridData = new JSONArray(subBrdList);
				model.put("gridData", gridData);
				
		
			
				
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/editAttrSortNumPop.do")
	public String editAttrSortNumPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try{
			model.put("menu", getLabel(request, commonService));
			model.put("itemTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode")));
			
			System.out.println("itemTypeCode: "+model.get("itemTypeCode"));
			
			
			String languageID = StringUtil.checkNull(request.getParameter("languageID"));
			if (languageID.equals("")) {
				languageID = GlobalVal.DEFAULT_LANGUAGE;
			}
			commandMap.put("languageID", languageID);
			commandMap.put("ItemTypeCode",model.get("itemTypeCode"));
			
			List mttList = commonService.selectList("config_SQL.getAttrListWithItemTypeCode_gridList", commandMap);
            
			JSONArray gridData = new JSONArray(mttList); 
			model.put("gridData", gridData);
			
			
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/editAttrSortNumPop");
	}
	
	@RequestMapping(value="/saveAttrSortNum.do")
	public String saveAttrSortNum(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		
		try{
			
			
			String idsParam = request.getParameter("ids");
			if (idsParam != null) {
				String ids[] = idsParam.split(",");
				System.out.println("Ids[]"+Arrays.toString(ids));
				String attrCodes[] = request.getParameter("AttrTypeCode").split(",");
				String gsorts[] = request.getParameter("GSortNum").split(",");
				System.out.println("attrCodes[]"+Arrays.toString(attrCodes));
				System.out.println("gsorts[]"+Arrays.toString(gsorts));
				
				Map setData = new HashMap();
				String ItemTypeCode = request.getParameter("ItemTypeCode");
				setData.put("ItemTypeCode", ItemTypeCode);
				
				String arrayData = request.getParameter("data");			
				for(int i=0; i<ids.length; i++){
					
			
				setData.put("AttrTypeCode", attrCodes[i]);
				setData.put("GSortNum", gsorts[i]);
				setData.put("ItemTypeCode", ItemTypeCode);
								
				System.out.println("attrTypeCode>>"+attrCodes[i]+"GSortNum>"+gsorts[i]+" itemTypeCode>"+ItemTypeCode);
				commonService.update("config_SQL.updateAttrSortNum", setData);
			}
		  }else {
			  System.out.println("ids is null");
		  }
			
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		System.out.println("ajaxpage>>>>>> "+AJAXPAGE);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/openBoardMgtPop.do")
	public String openBoardMgtPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/menu/addBoardMgtPop";
		try {
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String templCode = StringUtil.checkNull(request.getParameter("templCode"));
	
			commandMap.put("languageID", languageID);
			commandMap.put("templCode", templCode);
	        List addBoardMPList = commonService.selectList("config_SQL.getBoardMgtList_gridList", commandMap);
	        JSONArray gridData = new JSONArray(addBoardMPList);
	        model.put("gridData",gridData);	
		
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("templCode",  StringUtil.checkNull(request.getParameter("templCode"), ""));
			model.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
			model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), ""));
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/admin/addBoardMgt.do")
	public String addBoardMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String arrayStr[] = request.getParameter("boardMgtID").split(",");
				String templCode = StringUtil.checkNull(request.getParameter("templCode"), "");
				if (arrayStr != null) {
					setMap.put("templCode", templCode);
					for (int i = 0; i < arrayStr.length; i++) {
						String boardMgtID = arrayStr[i];
						setMap.put("boardMgtID", boardMgtID);
						commonService.insert("config_SQL.insertBoardMgtAlloc",setMap);
					}
				}
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "parent.fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/admin/deleteBoardMgtAlloc.do")
	public String deleteBoardMgtAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String boardMgtIDS = StringUtil.checkNull(request.getParameter("boardMgtID"), "");
				String templCode = StringUtil.checkNull(request.getParameter("templCode"), "");
				setMap.put("templCode", templCode);
				
				String boardMgtIDSArr[] = boardMgtIDS.split(",");
				for(int i=0; i<boardMgtIDSArr.length; i++){
					setMap.put("boardMgtID", boardMgtIDSArr[i]);
					commonService.insert("config_SQL.deleteBoardMgtAlloc",setMap);
				}
				
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/fileToItem.do")
	public String fileToItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				/* fileList 痍⑤뱷 */
				List getFileList = commonService.selectList("config_SQL.getItemsFileList", setMap);	
				
				/* 痍⑤뱷�븳 fileList 留뚰겮, �빐�떦 �븘�씠�뀥�쓽 �븯�쐞 �빆紐⑹쓣 �깮�꽦 �빐以� */
				for (int i = 0; i < getFileList.size(); i++) {
					Map fileInfoMap = (HashMap)getFileList.get(i);
					String parentId = fileInfoMap.get("ItemID").toString();
					String newItemName = fileInfoMap.get("FileRealName").toString();
					String itemTypeCode = fileInfoMap.get("ItemTypeCode").toString();
					
					// �븯�쐞�빆紐� �븘�씠�뀥 �깮�꽦
					String ItemID = commonService.selectString("item_SQL.getItemMaxID", setMap);
					setMap.put("option", request.getParameter("option"));			
					setMap.put("Version", "1");
					setMap.put("Deleted", "0");
					setMap.put("Creator", "1");
					setMap.put("CategoryCode", "OJ");
					setMap.put("OwnerTeamId", "2");
					setMap.put("CompanyID", "1");
					setMap.put("ItemID", ItemID);
					setMap.put("Identifier", "");
					setMap.put("ItemTypeCode", itemTypeCode);
					setMap.put("AuthorID", "1");
					setMap.put("Status","NEW1");
					
					if ("OJ00003".equals(itemTypeCode)) { // SQL:OJ00003
						setMap.put("ClassCode", "CL03002");
					} else { // Java or Jsp : OJ00004
						setMap.put("ClassCode", "CL04002");
					}
					
					commonService.insert("item_SQL.insertItem", setMap);
					
					// �냽�꽦 �깮�꽦 : 紐낆묶 �뙆�씪紐�
					setMap.put("PlainText", newItemName);
					setMap.put("AttrTypeCode","AT00001");			
					List getLanguageList = commonService.selectList("common_SQL.langType_commonSelect", setMap);			
					for(int j = 0; j < getLanguageList.size(); j++){
						Map getMap = (HashMap)getLanguageList.get(j);
						setMap.put("languageID", getMap.get("CODE") );				
						commonService.insert("item_SQL.ItemAttr", setMap);
					}
					
					// �뿰寃� �븘�씠�뀥 �깮�꽦
					setMap.put("s_itemID", parentId);
					setMap.put("CategoryCode", "ST1");
		            setMap.put("ClassCode", "NL00000");
					setMap.put("ToItemID", setMap.get("ItemID"));
					setMap.put("FromItemID", parentId);
					setMap.put("ItemID", commonService.selectString("item_SQL.getItemMaxID", setMap));
					setMap.put("Identifier", "");
					setMap.put("ItemTypeCode", commonService.selectString("item_SQL.selectedConItemTypeCode", setMap));
					commonService.insert("item_SQL.insertItem", setMap);
					
				}

				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/admin/deleteArchitecture.do")
	public String deleteArchitecture(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String arcCodes = StringUtil.checkNull(request.getParameter("arcCodes"));
				String arcCode[] = arcCodes.split(",");
				
				for(int i=0; i<arcCode.length; i++){
					setMap.put("arcCode", arcCode[i]);
					commonService.delete("config_SQL.deleteArchitecture", setMap);
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
				target.put(AJAX_SCRIPT, "fnCallBack('"+arcCodes+"')");
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/admin/deleteArcTemplAlloc.do")
	public String deleteArcTemplAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String templCode = StringUtil.checkNull(request.getParameter("templCode"));
				String arcCodeArr = StringUtil.checkNull(request.getParameter("arcCode"));
				String arcCode[] = arcCodeArr.split(",");
				
				setMap.put("templCode", templCode);
				for(int i=0; i<arcCode.length; i++){
					setMap.remove("arcCode");
					setMap.put("arcCode", arcCode[i]);
					commonService.delete("config_SQL.deleteArcTempl", setMap);
				}
				System.out.println("삭제성공");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
				target.put(AJAX_SCRIPT, "fnCallBack();");
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/admin/saveTemplArcSortNum.do")
	public String saveTemplArcSortNum(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		Map setMap2 = new HashMap();
		try {
				String arcCode = StringUtil.checkNull(request.getParameter("arcCode"), "");
				String templCode = StringUtil.checkNull(request.getParameter("templCode"), "");
				String sortNum = StringUtil.checkNull(request.getParameter("sortNum"), "");
				String arcName = StringUtil.checkNull(request.getParameter("arcName"), "");
				String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
				
				setMap.put("arcCode", arcCode);
				setMap.put("templCode", templCode);
				setMap.put("sortNum", sortNum);
				
				setMap2.put("Name", arcName);
				setMap2.put("TypeCode", arcCode);
				setMap2.put("languageID", languageID);
				setMap2.put("Category", "AR");
				
				commonService.insert("config_SQL.updateTemplArcSortNum",setMap);
				commonService.insert("dictionary_SQL.updateDictionary",setMap2);
				
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/openArcListPop.do")
	public String openArcListPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/menu/addTemplArcListPop";
		try {
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String templCode = StringUtil.checkNull(request.getParameter("templCode"));

				commandMap.put("templCode", templCode);
		        commandMap.put("languageID", languageID);
		        List addArcPList = commonService.selectList("config_SQL.getArcListForAddTmpl_gridList", commandMap);
		        JSONArray gridData = new JSONArray(addArcPList);
		        model.put("gridData",gridData);	
	        
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("templCode",  StringUtil.checkNull(request.getParameter("templCode"), ""));
				model.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
				model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), ""));
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/admin/addArcTempl.do")
	public String addArcTempl(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String arrayStr[] = request.getParameter("arcCode").split(",");
				String templCode = StringUtil.checkNull(request.getParameter("templCode"), "");
				setMap.put("lastUser", commandMap.get("sessionUserId"));
				String arcCode = "";
				if (arrayStr != null) {
					setMap.put("templCode", templCode);
					for (int i = 0; i < arrayStr.length; i++) {
						arcCode = arrayStr[i];
						setMap.put("arcCode", arcCode);
						commonService.insert("config_SQL.insertArcTempl",setMap);
					}
				}
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "parent.fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/boardMgtDetail.do")
	public String bordMgtDetail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/board/boardMgtDetail";
		try {
				Map setMap = new HashMap();
				Map getMap = new HashMap();
				
				String viewType = StringUtil.checkNull(request.getParameter("viewType"), "");
				String boardMgtID = StringUtil.checkNull(request.getParameter("boardMgtID"), "");
				
				setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));				
				if(viewType.equals("N")){
					String newBoardMgtID = commonService.selectString("config_SQL.getMaxBoardMgtID", commandMap).trim();
					getMap.put("BoardMgtID", newBoardMgtID);
				}else{
					setMap.put("BoardMgtID", boardMgtID);
					getMap = (HashMap) commonService.select("config_SQL.getAllBoardMgtList_gridList", setMap);
				}
				
				model.put("resultMap", getMap);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), ""));
				model.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));
				model.put("viewType", viewType);
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/admin/saveBoardMgt.do")
	public String saveBoardMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String viewType = StringUtil.checkNull(commandMap.get("viewType"), "");
				String boardMgtID = StringUtil.checkNull(commandMap.get("boardMgtID"), "");
				String boardMgtName = StringUtil.checkNull(commandMap.get("boardMgtName"), "");
				String companyID = StringUtil.checkNull(commandMap.get("companyID"), "");
				String boardTypeCD = StringUtil.checkNull(commandMap.get("boardTypeCD"), "");
				String dicTypeCode = StringUtil.checkNull(commandMap.get("dicTypeCode"), "");
				String languageID = StringUtil.checkNull(commandMap.get("getLanguageID"), "");
				String deactivated = StringUtil.checkNull(commandMap.get("deactivated"), "0");
				String description = StringUtil.checkNull(commandMap.get("description"), "");
				String parentID = StringUtil.checkNull(commandMap.get("parentID"), "0");
				String categoryYN = StringUtil.checkNull(commandMap.get("categoryYN"));
				String likeYN = StringUtil.checkNull(commandMap.get("likeYN"),"N");
				String pointYN = StringUtil.checkNull(commandMap.get("pointYN"),"N");
				String postEmailYN = StringUtil.checkNull(commandMap.get("postEmailYN"),"N");
				String mgtGRID = StringUtil.checkNull(commandMap.get("mgtGRID"),"");
				String mgtUserID = StringUtil.checkNull(commandMap.get("mgtUserID"),"");
				String mgtOnlyYN = StringUtil.checkNull(commandMap.get("mgtOnlyYN"),"N");
				String replyOption = StringUtil.checkNull(commandMap.get("replyOption"),"0");
				
				if(parentID.equals("")){
					parentID = "0";
				}
				setMap.put("userID", commandMap.get("sessionUserId"));
				setMap.put("boardMgtID", boardMgtID);
				setMap.put("companyID", companyID);
				setMap.put("boardTypeCD", boardTypeCD);
				setMap.put("dicTypeCode", dicTypeCode);
				setMap.put("languageID", languageID);
				setMap.put("languageID", languageID);
				setMap.put("Category", "BRDNM");
				setMap.put("Name", boardMgtName);
				setMap.put("deactivated", deactivated);
				setMap.put("description", description);
				setMap.put("TypeCode", boardMgtID);
				setMap.put("parentID", parentID);
				setMap.put("categoryYN", categoryYN);
				setMap.put("likeYN", likeYN);
				setMap.put("pointYN", pointYN);
				setMap.put("postEmailYN", postEmailYN);
				setMap.put("mgtGRID", mgtGRID);
				setMap.put("mgtUserID", mgtUserID);
				setMap.put("mgtOnlyYN", mgtOnlyYN);
				setMap.put("replyOption", replyOption);
				
				if(viewType.equals("N")){								
					commonService.insert("config_SQL.insertBoardMgt",setMap);
					commonService.insert("dictionary_SQL.insertDictionary",setMap);
				}else{
					commonService.update("dictionary_SQL.updateDictionary",setMap);
					commonService.update("config_SQL.updateBoardMgt",setMap);					
				}
				
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "parent.fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/allocateBoardMgt.do")
	public String boardMgtAllocation(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/board/allocateBoardMgt";
		try {	
				String viewType = StringUtil.checkNull(request.getParameter("viewType"), "");
				String boardMgtID = StringUtil.checkNull(request.getParameter("boardMgtID"), "");
				commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
	 			List allBMgtList = commonService.selectList("config_SQL.getBoardCatAllocList_gridList", commandMap);
	 			JSONArray gridData = new JSONArray(allBMgtList);
	 			model.put("gridData",gridData);	
				
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), ""));
//				model.put("languageID",StringUtil.checkNull(request.getParameter("languageID"), ""));
				model.put("viewType", viewType);
				model.put("boardMgtID", boardMgtID);
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	@RequestMapping(value = "/addTemplListPop.do")
	public String addTemplListPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/sub/addTemplListPop";
		try {	
				String boardMgtID = StringUtil.checkNull(request.getParameter("boardMgtID"), "");
				
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("languageID",StringUtil.checkNull(request.getParameter("languageID"), ""));
				model.put("boardMgtID", boardMgtID);
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/addBoardMgtAlloc.do")
	public String addBoardMgtAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String reqTemplCode = StringUtil.checkNull(request.getParameter("templCode"), "");
				String arrTemplCode[] = reqTemplCode.split(",");
				String boardMgtID = StringUtil.checkNull(request.getParameter("boardMgtID"), "");
				String templCode = "";
				if (arrTemplCode != null) {
					setMap.put("boardMgtID", boardMgtID);
					for (int i = 0; i < arrTemplCode.length; i++) {
						templCode = arrTemplCode[i];
						setMap.put("templCode", templCode);
						commonService.insert("config_SQL.insertBoardMgtTempl",setMap);
					}
				}
							
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "parent.fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/admin/updateBoardMgtAllocStNum.do")
	public String updateBoardMgtAllocStNum(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String templCode = StringUtil.checkNull(request.getParameter("templCode"), "");
				String boardMgtID = StringUtil.checkNull(request.getParameter("boardMgtID"), "");
				String sortNum = StringUtil.checkNull(request.getParameter("sortNum"), "");
				setMap.put("templCode", templCode);
				setMap.put("boardMgtID", boardMgtID);
				setMap.put("sortNum", sortNum);
				commonService.insert("config_SQL.updateBoardMgtSortNum",setMap);
							
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/deleteBoardMgtTemplAlloc.do")
	public String deleteBoardMgtTemplAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String reqTemplCode = StringUtil.checkNull(request.getParameter("templCode"), "");
				String arrTemplCode[] = reqTemplCode.split(",");
				String boardMgtID = StringUtil.checkNull(request.getParameter("boardMgtID"), "");
				String templCode = "";
				if (arrTemplCode != null) {
					setMap.put("boardMgtID", boardMgtID);
					for (int i = 0; i < arrTemplCode.length; i++) {
						templCode = arrTemplCode[i];
						setMap.put("templCode", templCode);
						commonService.delete("config_SQL.deleteBoardMgtTemplAlloc",setMap);
					}
				}
							
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/languageMgtList.do")
	public String languageMgtList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/language/languageMgtList";
		try {
				commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
				List langList = commonService.selectList("config_SQL.getLanguageList_gridList",commandMap);
				JSONArray gridData = new JSONArray(langList);
				model.put("gridData",gridData);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/admin/saveLanguageMgt.do")
	public String saveLanguageMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
				String name = StringUtil.checkNull(request.getParameter("name"), "");
				String nameEN = StringUtil.checkNull(request.getParameter("nameEN"), "");
				String fontFamily = StringUtil.checkNull(request.getParameter("fontFamily"), "");
				String fontSize = StringUtil.checkNull(request.getParameter("fontSize"), "");
				String fontColor = StringUtil.checkNull(request.getParameter("fontColor"), "");
				String deactivated = StringUtil.checkNull(request.getParameter("deactivated"), "0");
				
				setMap.put("languageID", languageID);
				setMap.put("name", name);
				setMap.put("nameEN", nameEN);
				setMap.put("fontFamily", fontFamily);
				setMap.put("fontSize", fontSize);
				setMap.put("fontColor", fontColor);
				setMap.put("deactivated", deactivated);
				commonService.insert("config_SQL.updateLanguage",setMap);
							
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "parent.fnCallBack();parent.$('#isSubmit').remove()");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/reportAlloc.do")
	public String reportAlloc(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/adm/configuration/menu/reportAllocTmplt";
		try {
			HashMap setMap = new HashMap();
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("templCode", StringUtil.checkNull(request.getParameter("templCode"), ""));
			model.put("projectID", StringUtil.checkNull(request.getParameter("projectID"), ""));
			model.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), ""));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("viewType", request.getParameter("viewType"));
			
			setMap.put("languageID", model.get("languageID"));
			setMap.put("templCode",model.get("templCode") );
			
			List<String> reportArcList = commonService.selectList("config_SQL.getReportAllocList_gridList",setMap);
			JSONArray gridData = new JSONArray(reportArcList);
			model.put("gridData", gridData);
			
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/openReportMgtPop.do")
	public String openReportMgtPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/menu/addReportMgtPop";
		try {
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String templCode = StringUtil.checkNull(request.getParameter("templCode"));
			
	        commandMap.put("languageID", languageID);
	        commandMap.put("templCode", templCode);
	        List addReportMPList = commonService.selectList("config_SQL.getReportMgtList_gridList", commandMap);
	        JSONArray gridData = new JSONArray(addReportMPList);
	        model.put("gridData",gridData);	
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("templCode", StringUtil.checkNull(request.getParameter("templCode"), ""));
			model.put("projectID", StringUtil.checkNull(request.getParameter("projectID"), ""));
			model.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), ""));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/admin/addReportAllocMgt.do")
	public String addReportAllocMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
				String reqReportCode = StringUtil.checkNull(request.getParameter("reportCode"), "");
				String templCode = StringUtil.checkNull(request.getParameter("templCode"), "");
				String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
				String reportCode = "";
				String arrReportCode[] = reqReportCode.split(",");
				
				setMap.put("templCode", templCode);
				setMap.put("projectID", projectID);
				for (int i = 0; i < arrReportCode.length; i++) {
					reportCode = arrReportCode[i];
					setMap.put("reportCode", reportCode);
					commonService.insert("config_SQL.insertReportAlloc",setMap);
				}
				
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/admin/deleteReportAlloc.do")
	public String deleteReportAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
				String reqReportCode = StringUtil.checkNull(request.getParameter("reportCode"), "");
				String templCode = StringUtil.checkNull(request.getParameter("templCode"), "");
				String reportCode = "";
				String arrReportCode[] = reqReportCode.split(",");
				
				setMap.put("templCode", templCode);
				for (int i = 0; i < arrReportCode.length; i++) {
					reportCode = arrReportCode[i];
					setMap.put("reportCode", reportCode);
					commonService.delete("config_SQL.deleteReportAlloc",setMap);
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/taskTypeMgtList.do")
	public String taskTypeMgtList(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/adm/configuration/change management/taskTypeMgtList";
		try {
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/taskTypeMgtDetail.do")
	public String taskTypeMgtDetail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/change management/taskTypeMgtDetail";
		try {
				Map setMap = new HashMap();
				Map resultMap = new HashMap();
				String taskTypeCode = StringUtil.checkNull(request.getParameter("taskTypeCode"), "");
				String viewType = StringUtil.checkNull(request.getParameter("viewType"), "");
				setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));
				
				if(taskTypeCode.equals("")){
					taskTypeCode =  StringUtil.checkNull(commonService.selectString("config_SQL.getMaxTaskTypeCode", commandMap)).trim();
				}else{
					setMap.put("taskTypeCode", taskTypeCode);
					resultMap = (HashMap) commonService.select("config_SQL.getTaskTypeMgtList_gridList", setMap);
					model.put("resultMap", resultMap);
				}
				
				model.put("taskTypeCode", taskTypeCode);
				model.put("viewType", viewType);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/saveTaskType.do")
	public String saveTaskType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String viewType = StringUtil.checkNull(request.getParameter("viewType"), "");
				String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "");
				String languageID = StringUtil.checkNull(request.getParameter("LanguageID"), "");
				String taskTypeCode = StringUtil.checkNull(request.getParameter("taskTypeCode"), "").trim();
				String taskTypeName = StringUtil.checkNull(request.getParameter("taskTypeName"), "");
				String itemClassCode = StringUtil.checkNull(request.getParameter("itemClass"), "");
				String fltpCode = StringUtil.checkNull(request.getParameter("fltp"), "");
				String deactivated = StringUtil.checkNull(request.getParameter("deactivated"), "0");
				String description = StringUtil.checkNull(request.getParameter("description"), "");
				
				setMap.put("taskTypeCode", taskTypeCode);	
				setMap.put("TypeCode", taskTypeCode);	
				setMap.put("languageID", languageID);
				setMap.put("Name", taskTypeName);
				setMap.put("Description", description);
				setMap.put("itemClassCode", itemClassCode);
				setMap.put("fltpCode", fltpCode);
				setMap.put("Category", "TSKTP");
				setMap.put("deactivated", deactivated);	
				setMap.put("userID", commandMap.get("sessionUserId"));
				setMap.put("ClientID", commandMap.get("sessionUserId"));
				if(viewType.equals("N")){ // insert					
					commonService.insert("dictionary_SQL.insertDictionary",setMap);
					commonService.insert("config_SQL.insertTaskType",setMap);
				}else{ // update
					setMap.put("languageID", languageID);
					commonService.insert("dictionary_SQL.updateDictionary",setMap);
					commonService.update("config_SQL.updateTaskType",setMap);
				}
				
				model.put("languageID", languageID);
				model.put("pageNum", pageNum);
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "parent.fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/admin/deleteTaskTypeCode.do")
	public String deleteTaskTypeCode(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String languageID = StringUtil.checkNull(request.getParameter(""), "");
				String reqTaskTypeCode = StringUtil.checkNull(request.getParameter("taskTypeCode"), "");
				String arrTaskTypeCode[] = reqTaskTypeCode.split(",");
				String taskTypeCode = "";
				if (arrTaskTypeCode != null) {
					setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));	
					for (int i = 0; i < arrTaskTypeCode.length; i++) {
						taskTypeCode = arrTaskTypeCode[i];
						setMap.put("taskTypeCode", taskTypeCode);
						commonService.delete("config_SQL.deleteTaskTypeCode",setMap);
					}
				}
							
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/admin/updateReportAllocInfo.do")
	public String updateReportAllocInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String templateCode = StringUtil.checkNull(request.getParameter("templCode"), "");
				String reportCode = StringUtil.checkNull(request.getParameter("reportCode"), "");
				String varFilter = StringUtil.checkNull(request.getParameter("varFilter"), "");
				String sortNum = StringUtil.checkNull(request.getParameter("sortNum"), "");
				String classCodeYN = StringUtil.checkNull(request.getParameter("classCodeYN"), "");
				
				String classCode = StringUtil.checkNull(request.getParameter("classCode"), "");
				String templateCodeYN = StringUtil.checkNull(request.getParameter("templateCodeYN"), "");
								
				setMap.put("templateCode", templateCode);	
				setMap.put("reportCode", reportCode);	
				setMap.put("varFilter", varFilter);
				setMap.put("classCode", classCode);
				setMap.put("sortNum", sortNum);
				commonService.update("config_SQL.updateReportAllocInfo",setMap);
				
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
				if(classCodeYN.equals("Y")||templateCodeYN.equals("Y")){
					target.put(AJAX_SCRIPT, "parent.fnCallBack(); parent.$('#isSubmit').remove();");
				}else{
					target.put(AJAX_SCRIPT, "fnCallBack();");
				}
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
//	@RequestMapping(value = "/admindeleteBoardMgt.do")
	public String deleteBoardMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String pageNum =  StringUtil.checkNull(request.getParameter("pageNum"), "");
				String boardMgtID =  StringUtil.checkNull(request.getParameter("boardMgtID"));

				setMap.put("boardMgtID", boardMgtID);
				commonService.delete("config_SQL.deleteBoardMgt",setMap);
					
				model.put("pageNum", pageNum);
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); 
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/srCatList.do")
	public String srCategoryList(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("pageNum", request.getParameter("pageNum"));
			mapValue.put("languageID", mapValue.get("sessionCurrLangType"));
 	 		List srCatList = commonService.selectList("config_SQL.getAllSRCatMgtList_gridList", mapValue);
 	 		JSONArray gridData = new JSONArray(srCatList);
 	 		model.put("gridData",gridData);	
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/srCategoryList");
	}
	
	@RequestMapping(value = "/srCatDetail.do")
	public String srCategoryMgtDetail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/change management/srCategoryDetail";
		try {
				Map setMap = new HashMap();
				Map getMap = new HashMap();
				
				String viewType = StringUtil.checkNull(request.getParameter("viewType"), "");
				String srCatID = StringUtil.checkNull(request.getParameter("srCatID"), "");
				
				setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));				
				if(viewType.equals("N")){
//					String newSRCatID = commonService.selectString("config_SQL.getMaxSRCatID", commandMap).trim();
//					getMap.put("SRCatID", newSRCatID);
					getMap.put("Level", 1);
				}else{
					setMap.put("srCatID", srCatID);
					getMap = (HashMap) commonService.select("config_SQL.getAllSRCatMgtList_gridList", setMap);
				}
				
				model.put("resultMap", getMap);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), ""));
				model.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));
				model.put("viewType", viewType);
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/admin/saveSRCat.do")
	public String saveSRCategory(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String viewType = StringUtil.checkNull(request.getParameter("viewType"), "");
				String srCatID = StringUtil.checkNull(request.getParameter("srCatID"), "");
				String srCatName = StringUtil.checkNull(request.getParameter("srCatName"), "");
				String clientID = StringUtil.checkNull(request.getParameter("clientID"), "");
				String srType = StringUtil.checkNull(request.getParameter("srType"), "");
				String itemTypeCode = StringUtil.checkNull(request.getParameter("ItemTypeCode"), "");
				String srArea = StringUtil.checkNull(request.getParameter("srArea"), "");
				String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
				String level = StringUtil.checkNull(request.getParameter("level"), "1");
				String roleType = StringUtil.checkNull(request.getParameter("roleType"), "R");
				String parentID = StringUtil.checkNull(request.getParameter("parentID"), "0");
				String processType = StringUtil.checkNull(request.getParameter("ProcessType"), "1");
				String procModelName = StringUtil.checkNull(request.getParameter("procModelName"), "");
				String procPathID = StringUtil.checkNull(request.getParameter("procPathID"), "");
				
				if(parentID.equals("")){
					parentID = "0";
				}
				setMap.put("srCatID", srCatID);
				setMap.put("parentID", parentID);
				setMap.put("level", level);
				setMap.put("srType", srType);
				setMap.put("itemTypeCode", itemTypeCode);
				setMap.put("srArea", srArea);
				setMap.put("userID", commandMap.get("sessionUserId"));
				setMap.put("clientID", clientID);
				setMap.put("TypeCode", srCatID);
				setMap.put("languageID", languageID);
				setMap.put("languageID", languageID);
				setMap.put("Category", "SRCAT");
				setMap.put("Name", srCatName);
				setMap.put("Description", "");
				setMap.put("orgTypeCode", srCatID);
				setMap.put("roleType", roleType);
				setMap.put("processType", processType);
				setMap.put("procPathID",procPathID);
				
				if(viewType.equals("N")){								
					commonService.insert("config_SQL.insertSRCategory",setMap);
					commonService.insert("dictionary_SQL.insertDictionary",setMap);
				}else{
					commonService.update("dictionary_SQL.updateDictionary",setMap);
					commonService.update("config_SQL.updateSRCategory",setMap);					
				}
				
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "parent.fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/admin/deleteSRCat.do")
	public String deleteSRCategory(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String pageNum =  StringUtil.checkNull(request.getParameter("pageNum"), "");
				String srCatID =  StringUtil.checkNull(request.getParameter("srCatID"), "");
			
				setMap.put("srCatID", srCatID);
				commonService.delete("config_SQL.deleteSRCategory",setMap);
							
				model.put("pageNum", pageNum);
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); 
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/custCategoryMgt.do")
	public String custCategoryMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		
		String url = "/adm/configuration/change management/srCustCategoryList";
		
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String customerNo = StringUtil.checkNull(request.getParameter("customerNo"));
			
			model.put("languageID", languageID);
			model.put("customerNo", customerNo);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/srCustCatAddList.do")
	public String srCustCatAddList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String customerNo = StringUtil.checkNull(request.getParameter("customerNo"));
			String srType = StringUtil.checkNull(request.getParameter("srType"));
			
			model.put("languageID", languageID);
			model.put("customerNo", customerNo);
			model.put("srType", srType);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/addSrCustCategoryPop");
	}
	
	@RequestMapping(value = "/addSRCustCat.do")
	public String addSRCustCat(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {	
				String pageNum =  StringUtil.checkNull(request.getParameter("pageNum"), "");
				
				String customerNo =  StringUtil.checkNull(request.getParameter("customerNo"), "");
				setMap.put("customerNo", customerNo);
				
				String[] srCatIDs =  StringUtil.checkNull(request.getParameter("srCatID")).split(",");
				if(srCatIDs != null){
					for(int i = 0 ; i < srCatIDs.length; i++){
						setMap.put("srCatID", srCatIDs[i]); 
						commonService.delete("config_SQL.insertSRCustCategory",setMap);
					}
				}
							
				model.put("pageNum", pageNum);
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); 
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/deleteSRCustCat.do")
	public String deleteSRCustCat(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {	
				String pageNum =  StringUtil.checkNull(request.getParameter("pageNum"), "");
				
				String customerNo =  StringUtil.checkNull(request.getParameter("customerNo"), "");
				setMap.put("customerNo", customerNo);
				
				String[] srCatIDs =  StringUtil.checkNull(request.getParameter("srCatID")).split(",");
				if(srCatIDs != null){
					for(int i = 0 ; i < srCatIDs.length; i++){
						setMap.put("srCatID", srCatIDs[i]); 
						commonService.delete("config_SQL.deleteSRCustCategory",setMap);
					}
				}
							
				model.put("pageNum", pageNum);
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); 
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/addBrdCatListPop.do")
	public String addBrdCatListPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/board/addBrdCatListPop";
		try {			
				String boardMgtID = StringUtil.checkNull(commandMap.get("boardMgtID"), "");
				String sessionLanguageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String languageID = StringUtil.checkNull(commandMap.get("languageID"),sessionLanguageID);
 				commandMap.put("languageID", languageID);
				List addBrdCatList = commonService.selectList("config_SQL.getBoardCatList_gridList", commandMap);
 				JSONArray gridData = new JSONArray(addBrdCatList);
 				model.put("gridData",gridData);	
				
 				model.put("languageID", languageID);
				model.put("boardMgtID", boardMgtID);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/addBoardMgtCatAlloc.do")
	public String addBoardMgtCatAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String pageNum =  StringUtil.checkNull(commandMap.get("pageNum"), "");
				String boardMgtID =  StringUtil.checkNull(commandMap.get("boardMgtID"), "");
				String boardCategory = StringUtil.checkNull(commandMap.get("boardCatgoryCode"), "");
				String sortNum = "";
				setMap.put("boardMgtID", boardMgtID);
				sortNum = StringUtil.checkNull(commonService.selectString("config_SQL.getMaxBoardCatSortNum",setMap));
				setMap.put("boardCategory", boardCategory);
				setMap.put("sortNum", sortNum);
				commonService.insert("config_SQL.insertBoardMgtCategory",setMap);
							
				model.put("pageNum", pageNum);
				if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
					target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
					target.put(AJAX_SCRIPT, "fnCallBack();");
				}	
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/updateBoardMgtCatAllocStNum.do")
	public String updateBoardMgtCatAllocStNum(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String pageNum =  StringUtil.checkNull(commandMap.get("pageNum"), "");
				String boardMgtID =  StringUtil.checkNull(commandMap.get("boardMgtID"), "");
				String categoryCode = StringUtil.checkNull(commandMap.get("categoryCode"), "");
				String sortNum = StringUtil.checkNull(commandMap.get("sortNum"), "");
				String languageID = StringUtil.checkNull(commandMap.get("languageID"), "");
				
				setMap.put("boardMgtID", boardMgtID);
				setMap.put("categoryCode", categoryCode);
				setMap.put("sortNum", sortNum);
				commonService.insert("config_SQL.updateBoardMgtCatSortNum",setMap);			
							
				model.put("pageNum", pageNum);
				model.put("boardMgtID", boardMgtID);
				model.put("languageID", languageID);
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/deleteBoardMgtCatAlloc.do")
	public String deleteBoardMgtCatAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String pageNum =  StringUtil.checkNull(commandMap.get("pageNum"), "");
				String boardMgtID =  StringUtil.checkNull(commandMap.get("boardMgtID"), "");
				String languageID = StringUtil.checkNull(commandMap.get("languageID"), "");
				String boardCategory = StringUtil.checkNull(commandMap.get("boardCategoryCode"), "");
				
				setMap.put("boardMgtID", boardMgtID);
				setMap.put("categoryCode", boardCategory);
	
				commonService.delete("config_SQL.deleteBoardMgtCategory",setMap);
							
				model.put("pageNum", pageNum);
				model.put("boardMgtID", boardMgtID);
				model.put("languageID", languageID);
				if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
					target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); 
					target.put(AJAX_SCRIPT, "fnCallBack();");
				}	
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/admin/updateFltpAlloc.do")
	public String updateFltpAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
			try {
				String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
				String itemClassCode = StringUtil.checkNull(request.getParameter("itemClassCode"));
				String linkType = StringUtil.checkNull(commandMap.get("linkType"));
				
				setMap.put("fltpCode", fltpCode);
				setMap.put("itemClassCode", itemClassCode);
				setMap.put("linkType", linkType);
			    commonService.update("config_SQL.updateFltpAlloc", setMap); 
			    
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 	
				target.put(AJAX_SCRIPT, "this.fnCallBack();");
				
			} catch (Exception e) {
				System.out.println(e);
				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮												
			}
			model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(AJAXPAGE);
	}
	
	
	@RequestMapping(value = "/pointType.do")
	public String pointType(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), "1"));
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/board/pointType");
	}

	@RequestMapping(value = "/savePointType.do")
	public String savePointType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			getMap.put("PointTypeID", request.getParameter("PointType"));
			getMap.put("FunctionNM", request.getParameter("FunctionNM"));
			getMap.put("Point", request.getParameter("Point"));

			String checkNew = StringUtil.checkNull(commonService.selectString("config_SQL.selectPointType", getMap), "");
			if (checkNew.equals("")) {
				commonService.insert("config_SQL.insertPointType", getMap);
			} else {
				commonService.update("config_SQL.updatePointType", getMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT,"parent.fnCallBack(); parent.$('#isSubmit').remove()");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/deletePointType.do")
	public String deletePointType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String reqTypeCode = StringUtil.checkNull(request.getParameter("typeCode"), "");
				String arrTypeCode[] = reqTypeCode.split(",");
				
				String typeCode = "";
				if (arrTypeCode != null) {
					for (int i = 0; i < arrTypeCode.length; i++) {
						typeCode = arrTypeCode[i];
						setMap.put("typeCode", typeCode);
						commonService.delete("config_SQL.deletePoinType",setMap);
					}
				}
							
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "fnCallBack('del');");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/allocateSymbolAttrDp.do")
	public String allocateSymbolAttrDp(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			String symTypeCode = StringUtil.checkNull(request.getParameter("SymTypeCode"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
			HashMap setMap = new HashMap();
			
			setMap.put("symTypeCode", symTypeCode);
			setMap.put("languageID", languageID);
			setMap.put("Category", "ELM");

			List AttrTypeDpList = commonService.selectList("config_SQL.getAttrTypeDpList_gridList", setMap);
			
			JSONArray gridData = new JSONArray(AttrTypeDpList);
			model.put("gridData", gridData);	
			model.put("symTypeCode", symTypeCode);
			model.put("languageID", languageID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("Category", "ELM");		

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/model/allocateSymbolAttrDp");
	}
	
	@RequestMapping(value = "/admin/saveSymbolAttrDp.do")
	public String saveSymbolAttrDp(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setData = new HashMap();
		try {
				String Category = StringUtil.checkNull(request.getParameter("Category"), "");
				String symTypeCode = StringUtil.checkNull(request.getParameter("symTypeCode"), "");
				
				String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode"), "");
				String displayType = StringUtil.checkNull(request.getParameter("displayType"), ""); //�닔�젙 or �깮�꽦媛�
				String DisplayType = StringUtil.checkNull(request.getParameter("DisplayType"), ""); // �썝�옒媛�
				String html = StringUtil.checkNull(request.getParameter("html"), "");
				
				String x = StringUtil.checkNull(request.getParameter("x"), "");
				String y = StringUtil.checkNull(request.getParameter("y"), "");
				String width = StringUtil.checkNull(request.getParameter("width"), "");
				String height = StringUtil.checkNull(request.getParameter("height"), "");
				
				String fontSize = StringUtil.checkNull(request.getParameter("fontSize"), "");
				String fontColor = StringUtil.checkNull(request.getParameter("fontColor"), "");
				String fontStyle = StringUtil.checkNull(request.getParameter("fontStyle"), "");
				String fontFamily = StringUtil.checkNull(request.getParameter("fontFamily"), "");
				
				String strokeWidth = StringUtil.checkNull(request.getParameter("strokeWidth"), "");
				String strokeColor = StringUtil.checkNull(request.getParameter("strokeColor"), "");
				String fillColor = StringUtil.checkNull(request.getParameter("fillColor"), "");
				String labelBackgroundColor = StringUtil.checkNull(request.getParameter("labelBackgroundColor"), "");
				
				String scrnMode = StringUtil.checkNull(request.getParameter("scrnMode"), "");
				
				String newYN = StringUtil.checkNull(request.getParameter("newYN"), "");
				
				String refPoint = StringUtil.checkNull(request.getParameter("refPoint"), "");
				String maxTextLen = StringUtil.checkNull(request.getParameter("maxTextLen"), "");
				
				setData.put("symTypeCode", symTypeCode);
				setData.put("Category", Category);
				setData.put("attrTypeCode", attrTypeCode);
				setData.put("displayType", displayType);
				setData.put("DisplayType", DisplayType);//�썝�옒媛�
				setData.put("X", x);
				setData.put("Y", y);
				setData.put("width", width);
				setData.put("height", height);
				setData.put("fontSize", fontSize);
				setData.put("fontColor", fontColor);
				setData.put("fontStyle", fontStyle);
				setData.put("fontFamily", fontFamily);
				setData.put("strokeWidth", strokeWidth);
				setData.put("strokeColor", strokeColor);
				setData.put("fillColor", fillColor);
				setData.put("labelBackgroundColor", labelBackgroundColor);
				setData.put("scrnMode", scrnMode);
				setData.put("html", html);
				setData.put("mdpID", StringUtil.checkNull(request.getParameter("mdpID")));
				setData.put("refPoint", refPoint);
				setData.put("maxTextLen", maxTextLen);
				
				if(newYN.equals("Y")){
					commonService.insert("config_SQL.insertSymbolAttrDp", setData);
				}else{
					commonService.update("config_SQL.updateSymbolAttrDp", setData);
				}
							
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "this.urlReload();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/admin/deleteAttrDp.do")
	public String deleteAttrDp(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setData = new HashMap();
		try {
				String mdpIDs[] = StringUtil.checkNull(request.getParameter("mdpIDs"), "").split(",");	
				
				for(int i=0; i<mdpIDs.length; i++){
					setData.put("mdpID", StringUtil.checkNull(mdpIDs[i]) );					
					commonService.delete("config_SQL.deleteAttrDp", setData);
				}
							
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
				target.put(AJAX_SCRIPT, "urlReload();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	

	/**
	 * Edit Work Flow Step
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/updateWorkFlowStep.do")
	public String updateWorkFlowStep(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			getMap.put("WFStepID", request.getParameter("WFStepID"));
			getMap.put("WFID", request.getParameter("WFStepID"));
			getMap.put("TypeCode", request.getParameter("WFStepID"));
			getMap.put("Name", request.getParameter("objName"));
			getMap.put("TransferYN", request.getParameter("objTransferYN"));
			getMap.put("Deactivated", request.getParameter("objDeactivated"));
			getMap.put("languageID", request.getParameter("getLanguageID"));
			getMap.put("Creator", commandMap.get("sessionUserId"));
			getMap.put("Description", request.getParameter("description"));
			getMap.put("DocCategory", request.getParameter("docCategory"));
			getMap.put("Category", "WFSTEP");
			
			String checkNew = StringUtil.checkNull(commonService.selectString("config_SQL.selectWofkFlowDictionary", getMap));

			if (checkNew.equals("")) {
				commonService.insert("dictionary_SQL.insertDictionary", getMap);
			} else {
				commonService.update("config_SQL.updateWorkFlowStep", getMap);
				commonService.update("dictionary_SQL.updateDictionary", getMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.thisReload();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
		
	}
	

	
	/**
	 * delete workFlow (TB_WF_STEP_REL, TB_WF)
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/delWorkFlowStep.do")
	public String delWorkFlowStep(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			String[] arrayCode = StringUtil.checkNull(request.getParameter("wfStepIds")).split(",");
			
			for (int i = 0; arrayCode.length > i ; i++) {
				getMap.put("WFStepID", arrayCode[i]);
				getMap.put("TypeCode", arrayCode[i]);
				commonService.delete("config_SQL.deleteWfStep", getMap);
				commonService.delete("config_SQL.delDic", getMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣 �꽦怨�
			target.put(AJAX_SCRIPT, "this.urlReload();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	

	/**
	 * Insert WorkFlow
	 * @param request
	 * @param mapValue
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/addWorkFlowStepPop.do")
	public String addWorkFlowStepPop(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception{
		try{
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			model.put("languageID", request.getParameter("languageID"));
			
		}catch(Exception e){
			System.out.println(e.toString());
		}		
		return nextUrl("/popup/workFlowStepPop");
	}
	
	/**
	 * Add workFlow
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveWorkFlowStep.do")
	public String saveWorkFlowStep(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			getMap.put("WFStepID", request.getParameter("objWFStepID"));
			getMap.put("TypeCode", request.getParameter("objWFStepID"));
			getMap.put("Name", request.getParameter("objName"));
			getMap.put("Description", request.getParameter("objDescription"));
			getMap.put("languageID", commandMap.get("sessionCurrLangType"));
			getMap.put("Creator", commandMap.get("sessionUserId"));
			getMap.put("Category", "WFSTEP");
			getMap.put("Deactivated", "0");

			commonService.insert("config_SQL.InsertWFStep", getMap);
			commonService.insert("dictionary_SQL.insertDictionary", getMap);

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * RoleType List �솕硫� �몴�떆
	 * @param request
	 * @param mapValue
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/olmRoleConfigMgt.do")
	public String olmRoleConfigMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			Map setMap = new HashMap();
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("pageNum", request.getParameter("pageNum"));
			String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
			if(languageID == null || languageID == ""){
				languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			}
			model.put("languageID",languageID);
			
			setMap.put("languageID",languageID);
			setMap.put("CategoryCode","ROLECAT");
			List roleCatList = commonService.selectList("dictionary_SQL.selectDictionaryCode_gridList", setMap);
			JSONArray roleCat = new JSONArray(roleCatList);
			model.put("roleCat",roleCat);
			
			setMap.remove("CategoryCode");
			List gridDataList = commonService.selectList("config_SQL.getRoleTypeList_gridList", setMap);
			JSONArray gridData = new JSONArray(gridDataList);
			model.put("gridData",gridData);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/roleTypeList");
	}
	
	@RequestMapping(value = "/saveRoleType.do")
	public String saveRoleType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			
			String viewType = StringUtil.checkNull(request.getParameter("viewType"), "");
			String editRoleCategory = StringUtil.checkNull(request.getParameter("editRoleCategory"), "");
			getMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), ""));
			getMap.put("ActorType",StringUtil.checkNull(request.getParameter("actorType"), ""));
			getMap.put("Name",StringUtil.checkNull(request.getParameter("roleType"), ""));
			getMap.put("Description",StringUtil.checkNull(request.getParameter("description"), ""));
			getMap.put("processType",StringUtil.checkNull(request.getParameter("processType"), ""));
			getMap.put("lastUser",StringUtil.checkNull(commandMap.get("sessionUserId")));
			getMap.put("deactivated",StringUtil.checkNull(request.getParameter("deactivated"), ""));
			getMap.put("Category",StringUtil.checkNull(request.getParameter("roleTypeCategory"), ""));
			getMap.put("TypeCode",StringUtil.checkNull(request.getParameter("roleTypeCode"), ""));
			
				if(viewType.equals("N")){// �떊洹�
					getMap.put("creator",StringUtil.checkNull(commandMap.get("sessionUserId"), ""));
					//以묐났 �솗�씤
					String checkNew = StringUtil.checkNull(commonService.selectString("dictionary_SQL.selectDictionary", getMap), "");
					if (checkNew.equals("") || checkNew == "") {
							commonService.insert("dictionary_SQL.insertDictionary",getMap);
							commonService.insert("config_SQL.insertRoleType",getMap);
					} else{ // Category & RoleTypeCode 以묐났�씪 �븣 ���옣 �삤瑜�
						Exception e = new Exception();
						throw e;
					}
				} else { // �닔�젙
					String checkNew = StringUtil.checkNull(commonService.selectString("dictionary_SQL.selectDictionary", getMap), "");
					if (checkNew.equals("")) {
						commonService.insert("dictionary_SQL.insertDictionary",getMap);
					} else {						
						commonService.update("config_SQL.updateRoleType",getMap);
						commonService.update("dictionary_SQL.updateDictionary",getMap);
					}	
					
				}
			

			String category = "";
			JSONArray returnData = new JSONArray();
			if (editRoleCategory.equals("Y")) {
				getMap.put("CategoryCode", getMap.get("Category"));
				List roleCatList = commonService.selectList("dictionary_SQL.selectDictionaryCode_gridList", getMap);
				returnData = new JSONArray(roleCatList);
			} else {
				category = StringUtil.checkNull(getMap.get("Category"));
				getMap.remove("Category");
				getMap.remove("ActorType");
				List gridDataList = commonService.selectList("config_SQL.getRoleTypeList_gridList", getMap);
				returnData = new JSONArray(gridDataList);
			}
			
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "fnCallBack("+returnData+",'"+category+"');");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/deleteRoleType.do")
	public String deleteRoleType(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String reqRoleTypeCode = StringUtil.checkNull(request.getParameter("roleTypeCode"));
				String roleTypeCode[] = reqRoleTypeCode.split(",");
				String reqRoleCategory = StringUtil.checkNull(request.getParameter("roleCategory"));
				String roleCategory[] = reqRoleCategory.split(",");
				
				for(int i=0; i<roleTypeCode.length; i++){
					setMap.put("typeCode", roleTypeCode[i]);
					setMap.put("categoryCode", roleCategory[i]);
					setMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), ""));
					
					String checkITM = StringUtil.checkNull(commonService.selectString("config_SQL.getMyItemCount", setMap), "");
					if(checkITM == ("0") || checkITM.equals("0")){
						commonService.delete("dictionary_SQL.deleteDictionary", setMap);
						commonService.delete("config_SQL.deleteRoleType", setMap);
					}else{ // MY_ITEM�뿉�꽌 �궗�슜以묒씪 寃쎌슦 �궘�젣 �삤瑜�
						Exception e = new Exception();
						throw e;
					}
				}
				
				String category = "";
				JSONArray returnData = new JSONArray();
				if (roleCategory[0].equals("ROLECAT")) {	//Category �궘�젣
					setMap.put("CategoryCode", "ROLECAT");
					List roleCatList = commonService.selectList("dictionary_SQL.selectDictionaryCode_gridList", setMap);
					returnData = new JSONArray(roleCatList);
				} else {		// Type �궘�젣
					category = roleCategory[0];
					List gridDataList = commonService.selectList("config_SQL.getRoleTypeList_gridList", setMap);
					returnData = new JSONArray(gridDataList);
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
				target.put(AJAX_SCRIPT, "fnCallBack("+returnData+",'"+category+"');");
			
		} catch (Exception e) {
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�			
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	
	@RequestMapping(value="/configurationMgt.do")
	public String configurationMgt(HashMap cmmMap,ModelMap model) throws Exception{
		String url = "/adm/configuration/configurationMgt";
		try{
				String arcCode =  StringUtil.checkNull(cmmMap.get("arcCode"),"");
				String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
				model.put("arcCode", arcCode);
				model.put("menuStyle", menuStyle);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl(url);
	}
	
	@RequestMapping(value="/cfgURL.do")
	public String cfgURL(ModelMap model, HashMap cmmMap) throws Exception {		
		Map target = new HashMap();	
		try {		
				String menuID = StringUtil.checkNull(cmmMap.get("menuID"),"");
				Map cfgUrl = new HashMap();	
				cfgUrl = commonService.select("menu_SQL.getMenuUrlListByCfg", cmmMap);
				String url = StringUtil.checkNull(cfgUrl.get("URL"),"")+".do";
				
				target.put(AJAX_SCRIPT, "parent.creatMenuTab('"+cmmMap.get("menuID")+"', '"+url+"', '1');");					
		}
		catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}		
		model.addAttribute(AJAX_RESULTMAP,target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/admin/wfAllocationMenu.do")
	public String wfAllocationMenu(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		Map getMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(mapValue.get("sessionCurrLangType"));
			String wfID = StringUtil.checkNull(request.getParameter("wfID"));
			
			getMap.put("wfID", wfID);
			getMap.put("languageID", languageID);
			
			List wfaMList = commonService.selectList("wf_SQL.getWFAllocationList_gridList",getMap);
			JSONArray gridData = new JSONArray(wfaMList);
			model.put("gridData",gridData);
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("wfID", StringUtil.checkNull(mapValue.get("wfID"))); 
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/workFlowMenuAllocation");
	}

	@RequestMapping(value = "/saveWfMNAlloc.do")
	public String saveWfMNAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			getMap.put("menuID", request.getParameter("menuID"));
			getMap.put("category", request.getParameter("categoryType"));
			getMap.put("wfID", request.getParameter("wfID"));
			getMap.put("creator", commandMap.get("sessionUserId"));

			String checkNew = StringUtil.checkNull(commonService.selectString("wf_SQL.selecWFMenuAllocation", getMap), "");
			if (checkNew.equals("")) {
				commonService.insert("wf_SQL.insertWFMenuAllocation", getMap);
			} else {
				commonService.update("wf_SQL.updateWFMenuAllocation", getMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT,"parent.fnCallBack(); parent.$('#isSubmit').remove()");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/deleteWfMNAlloc.do")
	public String deleteWfMNAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String wfID = StringUtil.checkNull(request.getParameter("wfID"), "");
				String menuID = StringUtil.checkNull(request.getParameter("menuID"), "");
				String categoryCode = StringUtil.checkNull(request.getParameter("categoryCode"), "");
				
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("wfID", wfID);
				setMap.put("menuID", menuID);
				setMap.put("categoryCode", categoryCode);
				
				commonService.delete("wf_SQL.deleteWFMenuAllocation",setMap);

				if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
					target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // ���옣 �꽦怨�
					target.put(AJAX_SCRIPT, "fnCallBack('del');");
				}	
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
		
	@RequestMapping(value = "/defineSRArea.do")
	public String defineSRArea(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("pageNum", request.getParameter("pageNum"));
//			model.put("srType", request.getParameter("srType"));
			mapValue.put("languageID", mapValue.get("sessionCurrLangType"));
	 		List srAreaList = commonService.selectList("config_SQL.getAllSRAreaList_gridList", mapValue);
	 		JSONArray gridData = new JSONArray(srAreaList);
	 		model.put("gridData",gridData);	
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/srAreaList");
	}
	
	@RequestMapping(value = "/admin/saveSRArea.do")
	public String saveSRArea(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			
			String viewType = StringUtil.checkNull(request.getParameter("viewType"), "");
			getMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), ""));
			getMap.put("lastUser",StringUtil.checkNull(request.getParameter("lastUser"), ""));
			getMap.put("srTypeCode", StringUtil.checkNull(request.getParameter("SRTypeCode"),""));
			getMap.put("itemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode"),""));
			getMap.put("itemClassCodeTd",StringUtil.checkNull(request.getParameter("ItemClassCodeTd"), ""));
			getMap.put("itemClassCode",StringUtil.checkNull(request.getParameter("ItemClassCode"), ""));
			getMap.put("levelTd",request.getParameter("LevelTd"));
			getMap.put("level",request.getParameter("Level"));

			if(viewType.equals("N")){// �떊洹�
				//以묐났 �솗�씤
				String checkNew = StringUtil.checkNull(commonService.selectString("config_SQL.getAllSRAreaList_gridList", getMap), "");
				if (checkNew.equals("") || checkNew == "") {
						commonService.insert("config_SQL.insertSRArea",getMap);
				} else{ 
					Exception e = new Exception();
					throw e;
				}
			} else { // �닔�젙
				//以묐났 �솗�씤
				String checkNew = StringUtil.checkNull(commonService.selectString("config_SQL.getAllSRAreaList_gridList", getMap), "");
				if (checkNew.equals("") || checkNew == "") {
					commonService.update("config_SQL.updateSRArea",getMap);
				} else {						
					Exception e = new Exception();
					throw e;
				}	
			}
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "fnCallBack();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/admin/deleteSRAreaList.do")
	public String deleteSRAreaList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String pageNum =  StringUtil.checkNull(request.getParameter("pageNum"), "");
				String ItemClassCode =  StringUtil.checkNull(request.getParameter("ItemClassCode"), "");
				String Level =  StringUtil.checkNull(request.getParameter("Level"), "");
				setMap.put("itemClassCode", ItemClassCode);
				setMap.put("level",Level);
				commonService.delete("config_SQL.deleteSRAreaList",setMap);
				
				model.put("pageNum", pageNum);
				if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
					target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); 
					target.put(AJAX_SCRIPT, "fnCallBack();");
				}	
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	 @RequestMapping(value = "/defineSRType.do")
	 public String defineSRType(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
	 	try {
	 		model.put("menu", getLabel(request, commonService)); /* Label Setting */
	 		model.put("pageNum", request.getParameter("pageNum"));
	 		cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
	 		List srTypeList = commonService.selectList("config_SQL.getAllSRTypeList_gridList", cmmMap);
	 		JSONArray gridData = new JSONArray(srTypeList);
	 		model.put("gridData",gridData);		
	 	} catch (Exception e) {
	 		System.out.println(e.toString());
	 	}
	 	return nextUrl("/adm/configuration/change management/srTypeList");
	 }
	
	
	@RequestMapping(value = "/srTypeDetail.do")
	public String srTypeDetail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/change management/srTypeDetail";
		try {
				Map setMap = new HashMap();
				Map getMap = new HashMap();
				
				String viewType = StringUtil.checkNull(request.getParameter("viewType"), "");
				String SRTypeCode = StringUtil.checkNull(request.getParameter("SRTypeCode"), "");
				
				setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));				
				if(viewType.equals("N")){
					getMap.put("srTypeCode", SRTypeCode);
				}else{
					setMap.put("srTypeCode", SRTypeCode);
					getMap = (HashMap) commonService.select("config_SQL.getAllSRTypeList_gridList", setMap);
				}
				
				model.put("resultMap", getMap);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("pageNum", StringUtil.checkNull(request.getParameter("pageNum"), ""));
				model.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType"), ""));
				model.put("viewType", viewType);
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/openModelListPop.do")
	public String openModelListPop(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/popup/searchModelGridList";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/admin/saveSRType.do")
	public String saveSRType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String viewType = StringUtil.checkNull(request.getParameter("viewType"), "");
				//String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"), "");
				String lastUser = StringUtil.checkNull(request.getParameter("lastUser"), "");
				String SRTypeCode = StringUtil.checkNull(request.getParameter("SRTypeCode"), "");
				String DocDomain = StringUtil.checkNull(request.getParameter("DocDomain"), "");
				String DocCategory = StringUtil.checkNull(request.getParameter("DocCategory"), ""); //SR
				String ItemType = StringUtil.checkNull(request.getParameter("ItemType"), "");	//�빆紐⑹쑀�삎
				String ProcModelName = StringUtil.checkNull(request.getParameter("ProcModelName"), "");
				String ProcModelID = StringUtil.checkNull(request.getParameter("ProcModelID"), "");
				String MenuID = StringUtil.checkNull(request.getParameter("MenuID"), "");
				String VarFilter = StringUtil.checkNull(request.getParameter("VarFilter"), "");
				String Prefix = StringUtil.checkNull(request.getParameter("Prefix"), "");
				String MaxSRAreaLvl = StringUtil.checkNull(request.getParameter("MaxSRAreaLvl"), "");
				String DimTypeID = StringUtil.checkNull(request.getParameter("DimTypeID"),"");
				String Deactivated = StringUtil.checkNull(request.getParameter("Deactivated"),"0");
				String TypeCode = StringUtil.checkNull(request.getParameter("SRTypeCode"), "");
				String Name = StringUtil.checkNull(request.getParameter("SRTypeNM"), "");
				String itemProposal = StringUtil.checkNull(request.getParameter("itemProposal"), "");
				String evalType = StringUtil.checkNull(request.getParameter("evalType"), "");
				String wfID = StringUtil.checkNull(request.getParameter("wfID"), "");
				String wfAprvURL = StringUtil.checkNull(request.getParameter("wfAprvURL"), "");
				String wfDocURL = StringUtil.checkNull(request.getParameter("wfDocURL"), "");
				String managerID = StringUtil.checkNull(commandMap.get("managerID"), ""); 
				
				
				if(ProcModelName == "" || ProcModelName.equals("")){ ProcModelID = ""; }
				setMap.put("srTypeCode", SRTypeCode);
				setMap.put("docDomain", DocDomain);
				setMap.put("docCategory", DocCategory);	//SR
				setMap.put("itemTypeCode", ItemType);
				setMap.put("procModelName", ProcModelName);
				setMap.put("procModelID", ProcModelID);
				setMap.put("menuID", MenuID);
				setMap.put("varFilter", VarFilter);
				setMap.put("prefix", Prefix);
				setMap.put("maxSRAreaLvl", MaxSRAreaLvl);
				setMap.put("dimTypeID", DimTypeID);
				setMap.put("deactivated", Deactivated);
				setMap.put("lastUser", lastUser);
				setMap.put("languageID", languageID);
				setMap.put("TypeCode", TypeCode);
				setMap.put("Name", Name);
				setMap.put("Category", "SRTP");
				setMap.put("itemProposal", itemProposal);
				setMap.put("evalType", evalType);
				setMap.put("wfID", wfID);
				setMap.put("wfAprvURL", wfAprvURL);
				setMap.put("wfDocURL", wfDocURL);
				setMap.put("managerID", managerID); 
				
				if(viewType.equals("N")){								
					//以묐났 �솗�씤
					String checkNew = StringUtil.checkNull(commonService.selectString("dictionary_SQL.selectDictionary", setMap), "");
					if (checkNew.equals("") || checkNew == "") {
					commonService.insert("config_SQL.insertSRType",setMap);
					commonService.insert("dictionary_SQL.insertDictionary",setMap);
					} else {	// TypeCode 以묐났�씪 �븣 ���옣 �삤瑜�
						Exception e = new Exception();
						throw e;
					}
				}else{
					commonService.update("dictionary_SQL.updateDictionary",setMap);
					commonService.update("config_SQL.updateSRType",setMap);	
				}
				
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "parent.fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
		
	@RequestMapping(value = "/admin/deleteSRType.do")
	public String deleteSRType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
				String languageID =  StringUtil.checkNull(request.getParameter("languageID"), "");
				String pageNum =  StringUtil.checkNull(request.getParameter("pageNum"), "");
				String srTypeCode =  StringUtil.checkNull(request.getParameter("SRTypeCode"), "");
				String TypeCode = StringUtil.checkNull(request.getParameter("SRTypeCode"), "");
				setMap.put("srTypeCode", srTypeCode);
				setMap.put("typeCode", TypeCode);
				setMap.put("languageID", languageID);
				setMap.put("categoryCode", "SRTP");
				commonService.delete("config_SQL.deleteSRType",setMap);
				commonService.delete("dictionary_SQL.deleteDictionary",setMap);
				
				model.put("pageNum", pageNum);
				if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
					target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); 
					target.put(AJAX_SCRIPT, "fnCallBack();");
				}	
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/treeTestMgt.do")
	public String treeTestMgt(HashMap cmmMap,ModelMap model) throws Exception{
		String url = "/adm/configuration/treeTestMgt";
		try{
				String arcCode =  StringUtil.checkNull(cmmMap.get("arcCode"),"");
				String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
				model.put("arcCode", arcCode);
				model.put("menuStyle", menuStyle);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl(url);
	}

	@RequestMapping(value="/treeTestXMLMgt.do")
	public String treeTestXMLMgt(HttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception{
		String url = "/adm/configuration/treeTestXMLMgt";
		try{
			String arcCode =  StringUtil.checkNull(cmmMap.get("arcCode"),"");
			String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
			String unfold = StringUtil.checkNull(cmmMap.get("unfold"));
			String arcDefPage = StringUtil.checkNull(cmmMap.get("arcDefPage"));
			String nodeID = StringUtil.checkNull(cmmMap.get("nodeID"));			
			String focusedItemID = StringUtil.checkNull(request.getParameter("focusedItemID"));
			
			Map setData = new HashMap();
			setData.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			setData.put("SelectMenuId", arcCode);
			
			String SQL_CODE=StringUtil.checkNull(commonService.selectString("menu_SQL.getMenuTreeSqlName", setData) ,"commonCode");
			//List treeList = commonService.selectList("menu_SQL."+SQL_CODE, setData);	
			List treeList = commonService.selectList("config_SQL.selectConfigurationTreeList", setData);	
			int treeMaxLevel = Integer.parseInt(commonService.selectString("config_SQL.getConfigurationMaxLevel", setData));
			
			model.put("arcCode", arcCode);
			model.put("menuStyle", menuStyle);
			model.put("unfold", unfold);
			model.put("arcDefPage", arcDefPage);
			model.put("nodeID", nodeID);
			model.put("focusedItemID", focusedItemID);
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String filepath = request.getSession().getServletContext().getRealPath("/");
			
			/* xml �뙆�씪紐� �꽕�젙 */
			Calendar cal = Calendar.getInstance();
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
			java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("HHmmssSSS");
			String sdate = sdf.format(cal.getTime());
			String stime = sdf2.format(cal.getTime());
			String mkFileNm = sdate+stime;
			 
			String xmlFileName = "upload/testTree"+mkFileNm+".xml";
			// String xmlFileName = "upload/tree3_14_selection_sorting_navigation.xml";
			makeTestTreeXML(filepath, treeList, treeMaxLevel, xmlFileName, cmmMap, setData, request);
			//makeTreeItem(filepath, treeList, treeMaxLevel, xmlFileName, cmmMap, setData, request);
			model.put("xmlFileName", xmlFileName);
		} catch (Exception e) {
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl(url);
	}
	
	private void makeTestTreeXML(String filepath, List treeList, int treeMaxLevel, String xmlFileName, HashMap cmmMap,Map setMap, HttpServletRequest request) throws ExceptionUtil {
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance(); 
		try {
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
			Document doc = docBuilder.newDocument(); 
			Element treeElement = doc.createElement("tree"); 
			doc.appendChild(treeElement); 
			treeElement.setAttribute("id", "0");
			
			Element item1 = doc.createElement("item");	
			Element item2 = null;
			Element item3 = null;
			Element item4 = null;
			Element item5 = null;
			Element item6 = null;
			
			String topTreeID = "";
			String nodeID = "";String childTreeID = "";String childTreeID2 = "";String childTreeID3 = "";
			String level = "";
			
			if(treeList.size() > 0){
				for(int i=0; i<treeList.size(); i++){
					Map treeMap = (Map)treeList.get(i);    	        	
					if(i==0){    	
						level = StringUtil.checkNull(treeMap.get("Level"));
						item1.setAttribute("id", StringUtil.checkNull(treeMap.get("TREE_ID"))  );	
						item1.setAttribute("text",  StringUtil.checkNull(treeMap.get("TREE_NM")) );	
						item1.setAttribute("im0", "folderOpen.gif");	
						item1.setAttribute("im1", "folderOpen.gif");	
						item1.setAttribute("im2", "folderClosed.gif");	
						item1.setAttribute("open", "1");
					}
										
					// 2 Level
					for(int i2=0; i2<treeList.size(); i2++){
						Map treeMap2 = (Map)treeList.get(i2);
						if(StringUtil.checkNull(treeMap2.get("PRE_TREE_ID")).equals(StringUtil.checkNull(treeMap.get("TREE_ID"))) && StringUtil.checkNull((Integer.parseInt(level)+1)).equals(StringUtil.checkNull(treeMap2.get("Level")))){
							item2 = doc.createElement("item");	
							item2.setAttribute("im0", "folderOpen.gif");	
							item2.setAttribute("im1", "folderOpen.gif");	
							item2.setAttribute("im2", "folderClosed.gif");	
							
							item2.setAttribute("id",  StringUtil.checkNull(treeMap2.get("TREE_ID")));
							item2.setAttribute("text", StringUtil.checkNull(treeMap2.get("TREE_NM")));	
							item1.appendChild(item2);
							
							// 3 Level
							for(int i3=0; i3<treeList.size(); i3++){
								Map treeMap3 = (Map)treeList.get(i3);
								if(StringUtil.checkNull(treeMap3.get("PRE_TREE_ID")).equals(StringUtil.checkNull(treeMap2.get("TREE_ID"))) && StringUtil.checkNull((Integer.parseInt(level)+2)).equals(StringUtil.checkNull(treeMap3.get("Level")))){
									item3 = doc.createElement("item");	
									item3.setAttribute("im0", "folderOpen.gif");	
									item3.setAttribute("im1", "folderOpen.gif");	
									item3.setAttribute("im2", "folderClosed.gif");	
									
									item3.setAttribute("id",  StringUtil.checkNull(treeMap3.get("TREE_ID")));
									item3.setAttribute("text", StringUtil.checkNull(treeMap3.get("TREE_NM")));	
									item2.appendChild(item3);
									
									// 4 Level
									for(int i4=0; i4<treeList.size(); i4++){
										Map treeMap4 = (Map)treeList.get(i4);
										if(StringUtil.checkNull(treeMap4.get("PRE_TREE_ID")).equals(StringUtil.checkNull(treeMap3.get("TREE_ID"))) && StringUtil.checkNull((Integer.parseInt(level)+3)).equals(StringUtil.checkNull(treeMap4.get("Level")))){
											item4 = doc.createElement("item");	
											item4.setAttribute("im0", "folderOpen.gif");	
											item4.setAttribute("im1", "folderOpen.gif");	
											item4.setAttribute("im2", "folderClosed.gif");	
											
											item4.setAttribute("id",  StringUtil.checkNull(treeMap4.get("TREE_ID")));
											item4.setAttribute("text", StringUtil.checkNull(treeMap4.get("TREE_NM")));	
											item3.appendChild(item4);   
											
											// 5 Level
											for(int i5=0; i5<treeList.size(); i5++){
												Map treeMap5 = (Map)treeList.get(i5);
												if(StringUtil.checkNull(treeMap5.get("PRE_TREE_ID")).equals(StringUtil.checkNull(treeMap4.get("TREE_ID"))) && StringUtil.checkNull((Integer.parseInt(level)+4)).equals(StringUtil.checkNull(treeMap5.get("Level")))){
													item5 = doc.createElement("item");	
													item5.setAttribute("im0", "folderOpen.gif");	
													item5.setAttribute("im1", "folderOpen.gif");	
													item5.setAttribute("im2", "folderClosed.gif");	
													
													item5.setAttribute("id",  StringUtil.checkNull(treeMap4.get("TREE_ID")));
													item5.setAttribute("text", StringUtil.checkNull(treeMap4.get("TREE_NM")));	
													item4.appendChild(item5);                        	    	        
												}
											}
										}
									}
									
								}
							}
							
						}
					}
				
				}
			}
			treeElement.appendChild(item1); 
			
			// XML �뙆�씪濡� �벐湲� 
			TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
			Transformer transformer = transformerFactory.newTransformer(); 
			
			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
			DOMSource source = new DOMSource(doc); 	  
			StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFileName))); 
			transformer.transform(source, result); 
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}
	
	@RequestMapping(value="/saveTreeData.do")
	public String saveTreeData(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{					
			String ids[] = request.getParameter("ids").split(",");
			Map setData = new HashMap();
			/*name :626004_tr_id
			name :626004_tr_pid
			name :626004_tr_order
			name :626004_tr_text
			name :626004_!nativeeditor_status
			name :ids*/
			String treeStatus = "";
			String treeID = ""; // itemID
			String preTreeID = ""; // parentItemID 
			String treeOrder = ""; // 媛숈� level �뿉�꽌�쓽 index (0遺��꽣 �떆�옉)
			String treeText = ""; // item Text
			String treeLevel = "";
			String tr_sort = "";
			
			/*Enumeration en = request.getParameterNames();
			
			while(en.hasMoreElements()){
				System.out.println("parameter : "+en.nextElement() );
			}*/

			for(int i=0; i<ids.length; i++){
				//System.out.println("ids ["+i+"] :::> "+ids[i]+" Row ::::row status:"+request.getParameter(ids[i]+"_!nativeeditor_status") );
				
				treeStatus = StringUtil.checkNull(request.getParameter(ids[i]+"_!nativeeditor_status"),"");
				treeID = StringUtil.checkNull(request.getParameter(ids[i]+"_tr_id"),""); 
				preTreeID = StringUtil.checkNull(request.getParameter(ids[i]+"_tr_pid"),""); 
				treeOrder = StringUtil.checkNull(request.getParameter(ids[i]+"_tr_order"),""); 
				treeText = StringUtil.checkNull(request.getParameter(ids[i]+"_tr_text"),""); 
				treeLevel = StringUtil.checkNull(request.getParameter(ids[i]+"_tr_level"),""); 
				tr_sort = StringUtil.checkNull(request.getParameter(ids[i]+"_tr_sort"),""); 
				
				System.out.print("preTreeID :" +preTreeID+ " : treeID : "+treeID);
				System.out.println("::: treeOrder :" +treeOrder+ " : treeText : "+treeText+", treeLevel : "+treeLevel+" , tr_sort :"+tr_sort);
				
				setData.put("orderNum", treeOrder);
				setData.put("level", treeLevel);
				setData.put("parentID", preTreeID);
				setData.put("configurationCode", treeID);
				commonService.update("config_SQL.updateConfiguration", setData);
			}
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.fnMyAction();parent.$('#isSubmit').remove();");
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/treeGridTest.do")
	public String treeGridTest(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/treeGridTest";
		try {
			String s_itemID =  StringUtil.checkNull(cmmMap.get("s_itemID"),"");
			String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
			String unfold = StringUtil.checkNull(cmmMap.get("unfold"));
			String arcDefPage = StringUtil.checkNull(cmmMap.get("arcDefPage"));
			String nodeID = StringUtil.checkNull(cmmMap.get("nodeID"));			
			
			Map setData = new HashMap();
			setData.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			
			String SQL_CODE=StringUtil.checkNull(commonService.selectString("menu_SQL.getMenuTreeSqlName", setData) ,"commonCode");
			//List treeList = commonService.selectList("menu_SQL."+SQL_CODE, setData);	
			List treeList = commonService.selectList("config_SQL.selectConfigurationTreeList", setData);	
			int treeMaxLevel = Integer.parseInt(commonService.selectString("config_SQL.getConfigurationMaxLevel", setData));
			
			model.put("menuStyle", menuStyle);
			model.put("unfold", unfold);
			model.put("arcDefPage", arcDefPage);
			model.put("nodeID", nodeID);
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String filepath = request.getSession().getServletContext().getRealPath("/");
			
			model.put("itemIDs", s_itemID);
			model.put("screenMode", StringUtil.checkNull(request.getParameter("screenMode"), ""));
			model.put("treeGridTestXml",setTreeGridTestXML(s_itemID, treeList) );
			model.put("backBtnYN", request.getParameter("backBtnYN"));
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	
	private String setTreeGridTestXML(String mainID, List treeList) throws Exception {
		String CELL = "	<cell></cell>";
		String CELL_CHECK = "	<cell>0</cell>";
		String CELL_OPEN = "	<cell>";
		String CELL_CLOSE = "</cell>";
		String CLOSE = ">";
		String CELL_TOT = "";
		String ROW_OPEN = "<row id='";
		String ROW_CLOSE = "</row>";
		
		// row ID 瑜� unique �븯寃� �꽕�젙 �븯湲� �쐞�븳 seq
		int rowId = 0;
		String level = "";
		
		String result = "<rows>";
		String resultRow = "";
		if(treeList.size() > 0){
			for(int i=0; i<treeList.size(); i++){
				Map treeMap = (Map)treeList.get(i);    	        	
				if(i==0){    	
					level = StringUtil.checkNull(treeMap.get("Level"));
					
					result += "<row id='" + StringUtil.checkNull(treeMap.get("TREE_ID")) + "' open='1'>";
					result += CELL_CHECK;
					result += "	<cell image='books.gif'> " + StringUtil.checkNull(treeMap.get("PRE_TREE_ID")) + CELL_CLOSE;
					result += CELL_OPEN + StringUtil.checkNull(treeMap.get("TREE_ID")) +" "+ StringUtil.checkNull(treeMap.get("TREE_NM")) + CELL_CLOSE;
					result += CELL_OPEN + StringUtil.checkNull(treeMap.get("TREE_NM")) + CELL_CLOSE;
				}
				
				// 2 Level
				for(int i2=0; i2<treeList.size(); i2++){
					Map treeMap2 = (Map)treeList.get(i2);
					if(StringUtil.checkNull(treeMap2.get("PRE_TREE_ID")).equals(StringUtil.checkNull(treeMap.get("TREE_ID"))) && StringUtil.checkNull((Integer.parseInt(level)+1)).equals(StringUtil.checkNull(treeMap2.get("Level")))){
						result += ROW_OPEN + StringUtil.checkNull(treeMap2.get("TREE_ID")) +  "' open='1'>";
						result += CELL_CHECK;
						result += "	<cell image='books.gif'> " + StringUtil.checkNull(treeMap2.get("PRE_TREE_ID")) + CELL_CLOSE;
						result += CELL_OPEN + StringUtil.checkNull(treeMap2.get("TREE_ID")) + " " +StringUtil.checkNull(treeMap2.get("TREE_NM")) +CELL_CLOSE;
						result += CELL_OPEN + StringUtil.checkNull(treeMap2.get("TREE_NM")) + CELL_CLOSE;
						if(StringUtil.checkNull(treeMap2.get("SUB_TREE_ID_CNT")).equals("0")){
							result += ROW_CLOSE;
						}
						
						//3 Level
						for(int i3=0; i3<treeList.size(); i3++){
							Map treeMap3 = (Map)treeList.get(i3);
							if(StringUtil.checkNull(treeMap3.get("PRE_TREE_ID")).equals(StringUtil.checkNull(treeMap2.get("TREE_ID"))) && StringUtil.checkNull((Integer.parseInt(level)+2)).equals(StringUtil.checkNull(treeMap3.get("Level")))){
								result += ROW_OPEN + StringUtil.checkNull(treeMap3.get("TREE_ID")) +  "' >";
								result += CELL_CHECK;
								result += "	<cell image='books.gif'> " + StringUtil.checkNull(treeMap3.get("PRE_TREE_ID")) + CELL_CLOSE;
								result += CELL_OPEN + StringUtil.checkNull(treeMap3.get("TREE_ID")) +" "+ StringUtil.checkNull(treeMap3.get("TREE_NM")) + CELL_CLOSE;
								result += CELL_OPEN + StringUtil.checkNull(treeMap3.get("TREE_NM")) + CELL_CLOSE;
								if(StringUtil.checkNull(treeMap3.get("SUB_TREE_ID_CNT")).equals("0")){
									result += ROW_CLOSE;
								}
							
							//4 Level
							for(int i4=0; i4<treeList.size(); i4++){
								Map treeMap4 = (Map)treeList.get(i4);
								if(StringUtil.checkNull(treeMap4.get("PRE_TREE_ID")).equals(StringUtil.checkNull(treeMap3.get("TREE_ID"))) && StringUtil.checkNull((Integer.parseInt(level)+3)).equals(StringUtil.checkNull(treeMap4.get("Level")))){
									result += ROW_OPEN + StringUtil.checkNull(treeMap4.get("TREE_ID")) +  "' >";
									result += CELL_CHECK;
									result += "	<cell image='books.gif'> " + StringUtil.checkNull(treeMap4.get("PRE_TREE_ID")) + CELL_CLOSE;
									result += CELL_OPEN + StringUtil.checkNull(treeMap4.get("TREE_ID")) + " " + StringUtil.checkNull(treeMap4.get("TREE_NM")) + CELL_CLOSE;
									result += CELL_OPEN + StringUtil.checkNull(treeMap4.get("TREE_NM")) + CELL_CLOSE;
									if(StringUtil.checkNull(treeMap4.get("SUB_TREE_ID_CNT")).equals("0")){
										result += ROW_CLOSE;
									}
									if(StringUtil.checkNull(treeMap4.get("OrderNum")).equals( StringUtil.checkNull(Integer.parseInt(StringUtil.checkNull(treeMap3.get("SUB_TREE_ID_CNT")))-1) )  ){
										result += ROW_CLOSE;
									}
								}
							}
							if(StringUtil.checkNull(treeMap3.get("OrderNum")).equals(StringUtil.checkNull(Integer.parseInt(StringUtil.checkNull(treeMap2.get("SUB_TREE_ID_CNT")))-1)) ){
								result += ROW_CLOSE;
							}
						  }
						}
					}
				}
				
			   // if(treeList.size() == i-1){
					//result += ROW_CLOSE;
			   // }
			}
			result += "</row></rows>";
		}
		//result += resultRow;
		//result += "</row>";
		//result += "</rows>";
		System.out.println(result);
		return result.replace("&", "/"); // �듅�닔 臾몄옄 �젣嫄�
	}
	
	@RequestMapping(value="/saveTreeGridData.do")
	public String saveTreeGridData(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{					
			String ids[] = request.getParameter("ids").split(",");
			Map setData = new HashMap();
			/*name :626004_tr_id
			name :626004_tr_pid
			name :626004_tr_order
			name :626004_tr_text
			name :626004_!nativeeditor_status
			name :ids*/
			String treeStatus = "";
			String gridID = ""; // itemID
			String preGridID = ""; // parentItemID 
			String column3 = "";
			String treeOrder = ""; // 媛숈� level �뿉�꽌�쓽 index (0遺��꽣 �떆�옉)
			String treeText = ""; // item Text
			String treeLevel = "";
			String tr_sort = "";
			
			/*Enumeration en = request.getParameterNames();
			
			while(en.hasMoreElements()){
				System.out.println("parameter : "+en.nextElement() );
			}*/
			int j = 0;
			String beforePreGridID = "";
			for(int i=0; i<ids.length; i++){
				treeStatus = StringUtil.checkNull(request.getParameter(ids[i]+"_!nativeeditor_status"),"");
				gridID = StringUtil.checkNull(request.getParameter(ids[i]+"_gr_id"),""); 
				preGridID = StringUtil.checkNull(request.getParameter(ids[i]+"_gr_pid"),""); 
				column3 = StringUtil.checkNull(request.getParameter(ids[i]+"_c3"),""); 
				
				System.out.print("preGridID :" +preGridID+ " : gridID : "+gridID+" : column3 :"+column3);
				
				if(beforePreGridID.equals(preGridID)){
					j = j+1;
				}else{
					j = 0;
				}
				
				setData.put("orderNum", j);
				//setData.put("level", treeLevel);
				setData.put("parentID", preGridID);
				setData.put("configurationCode", gridID);
				setData.put("sortNum", i);
				commonService.update("config_SQL.updateConfiguration", setData);
				beforePreGridID = preGridID;
				
			}
			//target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			//target.put(AJAX_SCRIPT, "parent.thisReload();parent.$('#isSubmit').remove();");
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value="/openEditSymAllocSortNum.do")
	public String openEditSymAllocSortNum(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try{
			String symTypes = StringUtil.checkNull(request.getParameter("symTypes"),"");
			String ModelTypeCode = StringUtil.checkNull(request.getParameter("ModelTypeCode"),"");
			
			Map setData = new HashMap();
			setData.put("symTypes", symTypes);
			setData.put("ModelTypeCode", ModelTypeCode);
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			List symTypeList = commonService.selectList("config_SQL.SelectSimbolType_gridList", setData);
			model.put("symTypeList", symTypeList);
			model.put("symTypes", symTypes);
			model.put("ModelTypeCode",ModelTypeCode);
						
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/model/editSymAllocSortNum");
	}
	
	@RequestMapping(value="/editSymAllocSortNum.do")
	public String editSymAllocSortNum(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{
			String symTypeCodes[] = StringUtil.checkNull(request.getParameter("symTypeCodes"),"").split(",");
			String modelTypeCode = StringUtil.checkNull(request.getParameter("modelTypeCode"),"");
			String symTypeCode = "";
			String sortNum = "";
			Map setData = new HashMap();
			setData.put("modelTypeCode",modelTypeCode);
			for(int i=0; symTypeCodes.length > i; i++){
				symTypeCode = StringUtil.checkNull(symTypeCodes[i],"");				
				sortNum = StringUtil.checkNull(request.getParameter("sortNum_"+symTypeCode),"");				
				setData.put("sortNum", sortNum);
				setData.put("symTypeCode", symTypeCode);
				commonService.update("config_SQL.updateSymAlloc", setData);	
			}
									
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "parent.fnCallBack();");
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	

	@RequestMapping(value = "/configEmail.do")
	public String configEmail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			String filepath = request.getSession().getServletContext().getRealPath("/");
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String category = "EMAILCODE";
			
			/* xml �뙆�씪紐� �꽕�젙 */
	        String xmlFilName = "upload/configEmail.xml";
	        
	        setEmailFormXmlData(filepath, languageID, category, xmlFilName, request);
			
	        commandMap.put("Category", category);
			commandMap.put("languageID", languageID);
 			List emailFormList = commonService.selectList("config_SQL.getAllEmailFormList_gridList", commandMap);
 			JSONArray gridData = new JSONArray(emailFormList);
 			model.put("gridData",gridData);	
			
 			model.put("Category", category);
	        model.put("xmlFilName", xmlFilName);
	        model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/emailFormList");
	}
	
	//  원본 setEmailFormXmlData
    private void setEmailFormXmlData(String filepath, String languageID,  String category, String xmlFilName, HttpServletRequest request ) throws Exception {
        /* xml �뙆�씪 議댁옱 �븷 寃쎌슦 �궘�젣 */
        File oldFile = new File(filepath + xmlFilName);
        if (oldFile.exists()) {
        	oldFile.delete();
        }
    	
    	Map setMap = new HashMap();
    	DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance(); 
	    DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
	    
	    // 猷⑦듃 �뿕由щ㉫�듃 
	    Document doc = docBuilder.newDocument(); 
	    Element rootElement = doc.createElement("rows"); 
	    doc.appendChild(rootElement); 
        
	    setMap.put("languageID", languageID);
	    setMap.put("Category", category);
	    List countResultList = commonService.selectList("config_SQL.getAllEmailFormList_gridList", setMap);
	    
	    int rowId = 0;	    
		for (int i = 0; i < countResultList.size(); i++) {
			  Element row = doc.createElement("row"); 
		        rootElement.appendChild(row); 
		        row.setAttribute("id", String.valueOf(rowId));
		        
		        Element cell = doc.createElement("cell");
		        Map emailFormMap = (Map) countResultList.get(i);
		        String RNUM = StringUtil.checkNull(emailFormMap.get("RNUM"));
		        String EmailCode = StringUtil.checkNull(emailFormMap.get("EmailCode"));
		        String Name = StringUtil.checkNull(emailFormMap.get("Name"));
		        String HTMLForm = StringUtil.checkNull(emailFormMap.get("HTMLForm"));
		        String Description = StringUtil.checkNull(emailFormMap.get("Description"));
		        String buttonName = "HTML";
		        if(HTMLForm.isEmpty())  buttonName = "Create";
		        
		        cell = doc.createElement("cell"); 
    	        cell.appendChild(doc.createTextNode(RNUM));
    	        row.appendChild(cell);
    	        cell = doc.createElement("cell"); 
    	        cell.appendChild(doc.createTextNode("0"));
    	        row.appendChild(cell);
    	        cell = doc.createElement("cell"); 
    	        cell.appendChild(doc.createTextNode(EmailCode));
    	        row.appendChild(cell);
    	        cell = doc.createElement("cell"); 
    	        cell.appendChild(doc.createTextNode("<input type=\"text\" class=\"stext name\"  name=\"name_"+rowId+"\" value=\""+Name+"\"  style=\"width:93%\">"));
    	        row.appendChild(cell);
    	        cell = doc.createElement("cell"); 
    	        cell.appendChild(doc.createTextNode(HTMLForm));
    	        row.appendChild(cell);
    	        cell = doc.createElement("cell"); 
    	        cell.appendChild(doc.createTextNode("<input type=\"text\" class=\"stext description\"  name=\"description_"+rowId+"\" value=\""+Description+"\" style=\"width:93%\">"));
    	        row.appendChild(cell);
    	        cell = doc.createElement("cell");
    		    String button = "<button class=\"gridBtn\" onclick=\"fnSaveGridData("+rowId+")\">save</button>"
						+ "<button class=\"gridBtn ";
    		    if(buttonName == "HTML") button += "blue";
    		    button += "\" onclick=\"fnGetEmailForm("+rowId+")\">"+buttonName+"</button>";
    		    cell.appendChild(doc.createTextNode(button));
    	        row.appendChild(cell);
    	        rowId++;
		}
	    
		TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
        Transformer transformer = transformerFactory.newTransformer(); 
 
        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
	    transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
	    DOMSource source = new DOMSource(doc); 
	    
	    StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName))); 
	    transformer.transform(source, result); 
    }
	
	@RequestMapping("/editEmailFormPop.do")
	public String editEmailFormPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/change management/editEmailFormPop";
		try{
			Map setMap = new HashMap();
			String emailCode = StringUtil.checkNull(request.getParameter("emailCode"));
			 setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			 setMap.put("emailCode", emailCode);
			 setMap.put("Category", "EMAILCODE");
			Map emailForm = commonService.select("config_SQL.getAllEmailFormList_gridList", setMap);

			model.put("emailForm", emailForm);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/saveEmailForm.do")
	public String saveEmailForm(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		try {
			String callBack = "";
			String viewType = StringUtil.checkNull(request.getParameter("viewType"));
			String emailCode = StringUtil.checkNull(request.getParameter("emailCode"));
			String name = StringUtil.checkNull(request.getParameter("name"));
			String description = StringUtil.checkNull(request.getParameter("description"));
			String htmlForm = StringUtil.checkNull(request.getParameter("htmlForm"));
			
			setMap.put("TypeCode",emailCode);
			setMap.put("emailCode",emailCode);
			setMap.put("Name",name);
			setMap.put("Description",description);
			setMap.put("htmlForm",StringEscapeUtils.unescapeHtml4(htmlForm));
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("Category", "EMAILCODE");
			
			if(viewType.equals("E")) {	//grid edit
				commonService.update("config_SQL.UpdateDictionary", setMap);
				callBack = "this.fnCallBack()";
			} else if (viewType.equals("EF")) {	// form edit
				Map emailForm = commonService.select("config_SQL.getAllEmailFormList_gridList", setMap);
					commonService.update("config_SQL.updateEmailForm", setMap);
				callBack = "parent.selfClose()";
			} else {	// addEmailFormPop
				setMap.put("emailCode",emailCode);
				Map emailForm = commonService.select("config_SQL.getAllEmailFormList_gridList", setMap);
				String emailCODECNT = StringUtil.checkNull(commonService.selectString("config_SQL.getemailCODECNT", setMap));		

				if(Integer.parseInt(emailCODECNT) == 0){
					commonService.insert("dictionary_SQL.insertDictionary", setMap);
					commonService.insert("config_SQL.insertEmailForm", setMap);
					
					String filepath = request.getSession().getServletContext().getRealPath("/");
					String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
					String category = "EMAILCODE";
					
					/* xml �뙆�씪紐� �꽕�젙 */
			        String xmlFilName = "upload/configEmail.xml";
			        setEmailFormXmlData(filepath, languageID, category, xmlFilName, request);
			        
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
					target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();");
	
				} else{ // 以묐났�씪 �븣 ���옣 �삤瑜�
					target.put(AJAX_SCRIPT, "parent.fnDuplicatedID();parent.$('#isSubmit').remove();");
				}
			}		
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	

	@RequestMapping(value = "/saveAllEmailForm.do")
	public String saveAllEmailForm(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
			String emailCodes[] = request.getParameter("emailCodes").split(",");
			String names[] = request.getParameter("names").split(",");
			String descriptions[] = request.getParameter("descriptions").split(",");
			
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("Category", "EMAILCODE");
						
	        for(int i=0; i<emailCodes.length; i++){     
		        setMap.put("TypeCode",emailCodes[i]);
		        setMap.put("Name",names[i]);
				setMap.put("Description",descriptions[i]);
		        commonService.update("config_SQL.UpdateDictionary", setMap);
			}
	        
	        String filepath = request.getSession().getServletContext().getRealPath("/");
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String category = "EMAILCODE";
			
	        /* xml �뙆�씪紐� �꽕�젙 */
	        String xmlFilName = "upload/configEmail.xml";
	        setEmailFormXmlData(filepath, languageID, category, xmlFilName, request);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "parent.fnCallBack();parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	
	@RequestMapping(value = "/addEmailFormPop.do")
	public String addEmailFormPop(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		String url = "/adm/configuration/change management/addEmailFormPop";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/delEmailForm.do")
	public String delEmailForm(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();  
		try{
			Map setMap = new HashMap();
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("categoryCode", "EMAILCODE");
						
			String emailCodes = StringUtil.checkNull(request.getParameter("emailCodes"));
			setMap.put("emailCode", emailCodes);
			setMap.put("typeCode", emailCodes);
			commonService.delete("config_SQL.delEmailForm", setMap);
			commonService.delete("dictionary_SQL.deleteDictionary",setMap);
		   
			if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
			   	String filepath = request.getSession().getServletContext().getRealPath("/");
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String category = "EMAILCODE";
				
				/* xml �뙆�씪紐� �꽕�젙 */
		        String xmlFilName = "upload/configEmail.xml";
		        setEmailFormXmlData(filepath, languageID, category, xmlFilName, request);
		   
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣 �꽦怨�
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove();");
			}
		
	  } catch (Exception e) {
		  System.out.println(e);
		  target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
		  //target.put(AJAX_ALERT, "�궘�젣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
		  target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜� 諛쒖깮
	  }
		model.addAttribute(AJAX_RESULTMAP, target);
        return nextUrl(AJAXPAGE);
    }
	
	
	@RequestMapping(value = "/configEvalType.do")
	public String configEvalType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			String filepath = request.getSession().getServletContext().getRealPath("/");
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String category = "EVTP";
			String evTypeCode = StringUtil.checkNull(request.getParameter("evTypeCode"));
			
			/* xml �뙆�씪紐� �꽕�젙 */
	        String xmlFilName = "upload/configEvalType.xml";
	        setEvalTypeXmlData(filepath, languageID, category, xmlFilName, request);
	        
	        //그리드1
	        commandMap.put("Category", category);
	        commandMap.put("languageID", languageID);
	        List evalTypeList = commonService.selectList("config_SQL.getAllEvalTypeList_gridList", commandMap);
	        JSONArray gridData = new JSONArray(evalTypeList);
	        model.put("gridData",gridData);	
	         			
 			model.put("Category", category);
	        model.put("xmlFilName", xmlFilName);
	        model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/evalTypeList");
	}
	
	private void setEvalTypeXmlData(String filepath, String languageID,  String category, String xmlFilName, HttpServletRequest request ) throws Exception {
        /* xml �뙆�씪 議댁옱 �븷 寃쎌슦 �궘�젣 */
        File oldFile = new File(filepath + xmlFilName);
        if (oldFile.exists()) {
        	oldFile.delete();
        }
    	
    	Map setMap = new HashMap();
    	DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance(); 
	    DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
	    
	    // 猷⑦듃 �뿕由щ㉫�듃 
	    Document doc = docBuilder.newDocument(); 
	    Element rootElement = doc.createElement("rows"); 
	    doc.appendChild(rootElement); 
        
	    setMap.put("languageID", languageID);
	    setMap.put("Category", category);
	    List countResultList = commonService.selectList("config_SQL.getAllEvalTypeList_gridList", setMap);
	    
	    int rowId = 0;	    
		for (int i = 0; i < countResultList.size(); i++) {
			  Element row = doc.createElement("row"); 
		        rootElement.appendChild(row); 
		        row.setAttribute("id", String.valueOf(rowId));
		        
		        Element cell = doc.createElement("cell");
		        Map evalTypeMap = (Map) countResultList.get(i);
		        String RNUM = StringUtil.checkNull(evalTypeMap.get("RNUM"));
		        String EvalTypeCode = StringUtil.checkNull(evalTypeMap.get("EvalTypeCode"));
		        String Name = StringUtil.checkNull(evalTypeMap.get("Name"));
		        String Description = StringUtil.checkNull(evalTypeMap.get("Description"));
		        
		        cell = doc.createElement("cell"); 
    	        cell.appendChild(doc.createTextNode(RNUM));
    	        row.appendChild(cell);
    	        cell = doc.createElement("cell"); 
    	        cell.appendChild(doc.createTextNode("0"));
    	        row.appendChild(cell);
    	        cell = doc.createElement("cell"); 
    	        cell.appendChild(doc.createTextNode(EvalTypeCode));
    	        row.appendChild(cell);
    	        cell = doc.createElement("cell"); 
    	        cell.appendChild(doc.createTextNode("<input type=\"text\" class=\"stext\" id=\"name_"+rowId+"\" name=\"name_"+rowId+"\" value=\""+Name+"\"  style=\"width:93%\">"));
    	        row.appendChild(cell);
    	        cell = doc.createElement("cell"); 
    	        cell.appendChild(doc.createTextNode("<input type=\"text\" class=\"stext\" id=\"description_"+rowId+"\" name=\"description_"+rowId+"\" value=\""+Description+"\" style=\"width:93%\">"));
    	        row.appendChild(cell);
    	        cell = doc.createElement("cell");
    		    String button = "<button style=\"background: #eee;border:1px solid #ddd;border-radius:5px;padding: 1px 7px;color: #3F3C3C; margin-right: 5px;\" onclick=\"fnAlloc("+rowId+")\">Allocation</button>"
		    						+ "<button style=\"background: #eee;border:1px solid #ddd;border-radius:5px;padding: 1px 7px;color: #3F3C3C;\"  onclick=\"fnSaveGridData("+rowId+")\">Save</button>";
    		    cell.appendChild(doc.createTextNode(button));
    	        row.appendChild(cell);
    	        rowId++;
		}
	    
		TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
        Transformer transformer = transformerFactory.newTransformer(); 
 
        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
	    transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
	    DOMSource source = new DOMSource(doc); 
	    
	    StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName))); 
	    transformer.transform(source, result); 
    }
	
	@RequestMapping(value = "/saveEvalType.do")
	public String saveEvalType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		try {
			String callBack = "";
			String viewType = StringUtil.checkNull(request.getParameter("viewType"));
			String evTypeCode = StringUtil.checkNull(request.getParameter("evTypeCode"));
			String name = StringUtil.checkNull(request.getParameter("name"));
			String description = StringUtil.checkNull(request.getParameter("description"),"NULL");
			
			setMap.put("TypeCode",evTypeCode);
			setMap.put("evTypeCode",evTypeCode);
			setMap.put("Name",name);
			setMap.put("Description",description);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("Category", "EVTP");
			setMap.put("docCategory", "SR");
			setMap.put("Creator", StringUtil.checkNull(commandMap.get("sessionUserId")));
			
			if(viewType.equals("E")) {	//from edit
					commonService.update("config_SQL.UpdateDictionary", setMap);
					callBack = "this.fnCallBack()";
			} else {	//from add
				Map evalInfo = commonService.select("config_SQL.getAllEvalTypeList_gridList", setMap);
				if (evalInfo.isEmpty()) {
					commonService.insert("dictionary_SQL.insertDictionary", setMap);
					commonService.insert("config_SQL.insertEvalType", setMap);
					
					String filepath = request.getSession().getServletContext().getRealPath("/");
					String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
					String category = "EVTP";
					
					/* xml �뙆�씪紐� �꽕�젙 */
			        String xmlFilName = "upload/configEvalType.xml";
			        setEvalTypeXmlData(filepath, languageID, category, xmlFilName, request);

					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
					target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();");
					
				} else{ // 以묐났�씪 �븣 ���옣 �삤瑜�
					target.put(AJAX_SCRIPT, "parent.fnDuplicatedID();parent.$('#isSubmit').remove();");
				}
			}	
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	
	@RequestMapping("/attrAllocPop.do") 
	public String attrAllocPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String evTypeCode = StringUtil.checkNull(request.getParameter("evTypeCode"));
			String category = StringUtil.checkNull(request.getParameter("category"));
			
			commandMap.put("languageID", languageID);
			commandMap.put("evTypeCode", evTypeCode);
			commandMap.put("category", category);
	        List attrAllocPopList = commonService.selectList("config_SQL.getAllocAttrType_gridList", commandMap);
	        JSONArray gridData = new JSONArray(attrAllocPopList);
	        model.put("gridData",gridData);	
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("LanguageID", request.getParameter("LanguageID"));
			model.put("evTypeCode", request.getParameter("evTypeCode"));
			model.put("category", category);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/adm/configuration/change management/attrAllocPop");
	}
	
	@RequestMapping(value = "/addEvalTypePop.do")
	public String addEvalTypePop(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		String url = "/adm/configuration/change management/addEvalTypePop";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/delEvalType.do")
	public String delEvalType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();  
		try{
			Map setMap = new HashMap();
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("categoryCode", "EVTP");
						
			String evTypeCodes = StringUtil.checkNull(request.getParameter("evTypeCodes"));
			
			setMap.put("evTypeCode", evTypeCodes);
		  	setMap.put("typeCode", evTypeCodes);
		  	commonService.delete("config_SQL.delEvalType", setMap);
		  	commonService.delete("config_SQL.delEvalAttrAlloc", setMap);
		  	commonService.delete("dictionary_SQL.deleteDictionary",setMap);
			
		  	if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
				String filepath = request.getSession().getServletContext().getRealPath("/");
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String category = "EVTP";
				
				/* xml �뙆�씪紐� �꽕�젙 */
		        String xmlFilName = "upload/configEvalType.xml";
		        setEvalTypeXmlData(filepath, languageID, category, xmlFilName, request);
		   
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣 �꽦怨�
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove();");
		  	}
			
	  } catch (Exception e) {
		  System.out.println(e);
		  target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
		  //target.put(AJAX_ALERT, "�궘�젣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
		  target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜� 諛쒖깮
	  }
		model.addAttribute(AJAX_RESULTMAP, target);
        return nextUrl(AJAXPAGE);
    }
	
	@RequestMapping(value = "/addEvalAttrAlloc.do")
	public String addEvalAttrAlloc(HttpServletRequest request,HashMap commandMap, ModelMap model) throws Exception {
		try {
			String viewType = "N";
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String evTypeCode = StringUtil.checkNull(request.getParameter("evTypeCode"));
			String category = "EVAL";
			
			commandMap.put("category", category);
			commandMap.put("languageID", languageID);
			commandMap.put("viewType", viewType);
			commandMap.put("evTypeCode", evTypeCode);

			List emailFormList = commonService.selectList("config_SQL.getAllocAttrType_gridList", commandMap);
 			JSONArray gridData = new JSONArray(emailFormList);
 			
 			model.put("category", category);
 			model.put("menu", getLabel(request, commonService)); /* Label Setting */
 			model.put("evTypeCode", evTypeCode);
 			model.put("gridData",gridData);	
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/addEvalAttrAlloc");
	}
	
	@RequestMapping(value = "/SaveEvalAttrAlloc.do")
	public String SaveEvalAttrAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			String evTypeCode = StringUtil.checkNull(request.getParameter("evTypeCode"));
			String attrCodes = StringUtil.checkNull(request.getParameter("attrCodes"));
			String[] arrayAttrCodes = attrCodes.split(",");
			
			for (int i = 0; i < arrayAttrCodes.length; i++) {
				getMap.put("attrTypeCode", arrayAttrCodes[i]);
				getMap.put("evTypeCode", evTypeCode);
				commonService.insert("config_SQL.insertEvalAttrAlloc", getMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT,"this.selfClose('"+evTypeCode+"');this.$('#isSubmit').remove();");		
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " ���옣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

   @RequestMapping(value="/delEvalAttrAlloc.do")
	public String delEvalAttrAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();  
		try{
			Map setMap = new HashMap();
			
			String evTypeCode = StringUtil.checkNull(request.getParameter("evTypeCode"));
			String attrTypeCodes = StringUtil.checkNull(request.getParameter("attrTypeCodes"));
			
			setMap.put("evTypeCode", evTypeCode);  
			setMap.put("attrTypeCode", attrTypeCodes);
			commonService.insert("config_SQL.delEvalAttrAlloc", setMap);
			
		  	if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
		  		target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣 �꽦怨�
		  		target.put(AJAX_SCRIPT, "this.doSearchList('"+evTypeCode+"');this.$('#isSubmit').remove();");
			}
			
	  } catch (Exception e) {
		  System.out.println(e);
		  target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
		  //target.put(AJAX_ALERT, "�궘�젣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
		  target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜� 諛쒖깮
	  }
		model.addAttribute(AJAX_RESULTMAP, target);
        return nextUrl(AJAXPAGE);
    }
    
    @RequestMapping(value = "/defineProcLogCfg.do")
	public String defineProcLogCfg(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			model.put("gridData", getprocLogConfig(commandMap));
			
			commandMap.put("Category","ACTP");
			List activityCodes  = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);
			model.put("activityCodes", new JSONArray(activityCodes));

			JSONArray result = new JSONArray();
			for(int i = 0; i<activityCodes.size(); i++) {
				Map map = (Map) activityCodes.get(i);
				result.put(StringUtil.checkNull(map.get("NAME"),""));
			}
			model.put("activityNames",result);
			
	        model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/defineProcLogCfg");
	}
    
    private JSONArray getprocLogConfig(HashMap commandMap) throws Exception {
		List gridList = commonService.selectList("procLog_SQL.procLogConfigList_select", commandMap);
		JSONArray gridData = new JSONArray(gridList);
		return gridData;
	}
	
	@RequestMapping(value = "/addProcLogCfg.do")
	public String addProcLogCfg(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			commandMap.put("Category","ACTP");
			List activityCodes  = commonService.selectList("common_SQL.getDicWord_commonSelect", commandMap);
			model.put("activityCodes", new JSONArray(activityCodes));
			
			JSONArray result = new JSONArray();
			for(int i = 0; i<activityCodes.size(); i++) {
				Map map = (Map) activityCodes.get(i);
				result.put(StringUtil.checkNull(map.get("NAME"),""));
			}
			model.put("activityNames",result);
			
	        model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/addProcLogCfg");
	}
    
	@RequestMapping(value = "/saveProcLog.do")
	public String saveProcLog(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		try {
			String pLogCfgID = StringUtil.checkNull(request.getParameter("PLOGCFGID"));
			String functionNM = StringUtil.checkNull(request.getParameter("functionNM"));
			String pIDParameter = StringUtil.checkNull(request.getParameter("pIDParameter"));
			String actionParameter = StringUtil.checkNull(request.getParameter("actionParameter"));
			String eventParameter = StringUtil.checkNull(request.getParameter("eventParameter"),"");
			String eventValue = StringUtil.checkNull(request.getParameter("eventValue"),"");
			String activityCD = StringUtil.checkNull(request.getParameter("activityCD"));
			String commentParameter = StringUtil.checkNull(request.getParameter("commentParameter"),"");
			
			setMap.put("pLogCfgID",pLogCfgID);
			setMap.put("functionNM",functionNM);
			setMap.put("pIDParameter",pIDParameter);
			setMap.put("actionParameter",actionParameter);
			setMap.put("eventParameter",eventParameter);
			setMap.put("eventValue",eventValue);
			setMap.put("activityCD",activityCD);
			setMap.put("commentParameter",commentParameter);
			setMap.put("userID", commandMap.get("sessionUserId"));
			
			if(pLogCfgID.equals("")) {	//grid add
				String maxPlogCfgID = StringUtil.checkNull(commonService.selectString("procLog_SQL.maxPlogCfgID",setMap)).trim();		
				maxPlogCfgID = maxPlogCfgID.substring(maxPlogCfgID.length() - 4, maxPlogCfgID.length());
				int PlogCfgID = Integer.parseInt(maxPlogCfgID) + 1;
				pLogCfgID = "PLOG" + String.format("%04d", PlogCfgID);
				
				setMap.put("pLogCfgID",pLogCfgID);
				commonService.insert("procLog_SQL.insertProcLogCfg", setMap);
			} else { //grid edit
				commonService.update("procLog_SQL.updateProcLogConfig", setMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "this.fnCallBack("+getprocLogConfig(commandMap)+")");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/saveAllProcLog.do", produces = "application/text; charset=utf-8")
	public void saveAllProcLog(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		JSONArray result = new JSONArray();
		try {			
			JSONArray jsonArray  = new JSONArray(request.getParameter("editedRow"));
			
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject jo = (JSONObject)jsonArray.get(i);
				
				String pLogCfgID = StringUtil.checkNull(jo.get("PLOGCFGID"));
				String functionNM = StringUtil.checkNull(jo.get("FunctionNM"));
				String pIDParameter = StringUtil.checkNull(jo.get("PIDParameter"));
				String actionParameter = StringUtil.checkNull(jo.get("ActionParameter"));
				String eventParameter = StringUtil.checkNull(jo.get("EventParameter"),"");
				String eventValue = StringUtil.checkNull(jo.get("EventValue"),"");
				String activityCD = StringUtil.checkNull(jo.get("ActivityCD"),"");
				String commentParameter = StringUtil.checkNull(jo.get("CommentParameter"),"");

				Map setMap = new HashMap();
				setMap.put("pLogCfgID",pLogCfgID);
		        setMap.put("functionNM",functionNM);
		        setMap.put("pIDParameter",pIDParameter);
				setMap.put("actionParameter",actionParameter);
				setMap.put("eventParameter",eventParameter);
				setMap.put("eventValue",eventValue);
				setMap.put("activityCD",activityCD);
				setMap.put("commentParameter",commentParameter);
				setMap.put("userID", commandMap.get("sessionUserId"));
				
				if(pLogCfgID.equals("")) {	//grid add
					String maxPlogCfgID = StringUtil.checkNull(commonService.selectString("procLog_SQL.maxPlogCfgID",setMap)).trim();		
					maxPlogCfgID = maxPlogCfgID.substring(maxPlogCfgID.length() - 4, maxPlogCfgID.length());
					int PlogCfgID = Integer.parseInt(maxPlogCfgID) + 1;
					pLogCfgID = "PLOG" + String.format("%04d", PlogCfgID);
					
					setMap.put("pLogCfgID",pLogCfgID);
					commonService.insert("procLog_SQL.insertProcLogCfg", setMap);
				} else { //grid edit
					commonService.update("procLog_SQL.updateProcLogConfig", setMap);
				}
			}
			response.setCharacterEncoding("UTF-8");
			result = getprocLogConfig(commandMap);
		} catch (Exception e) {
			System.out.println(e);
		}
		response.getWriter().print(result);
	}
	
	@RequestMapping(value="/delProcLog.do")
	public String delProcLog(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();  
		try{
			Map setMap = new HashMap();
			String pLogCfgIDs = StringUtil.checkNull(request.getParameter("pLogCfgIDs"));
			String[] ids = pLogCfgIDs.split(",");
			
			for (int i = 0; i < ids.length; i++) {
				String pLogCfgID = ids[i];
			   setMap.put("pLogCfgID", pLogCfgID);
			   commonService.delete("procLog_SQL.delProcLog", setMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣 �꽦怨�
			target.put(AJAX_SCRIPT, "this.fnCallBack("+getprocLogConfig(commandMap)+")");
			
	  } catch (Exception e) {
		  System.out.println(e);
		  target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
		  //target.put(AJAX_ALERT, "�궘�젣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
		  target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜� 諛쒖깮
	  }
		model.addAttribute(AJAX_RESULTMAP, target);
        return nextUrl(AJAXPAGE);
    }
	
    @RequestMapping(value = "/defineProcCfg.do")
	public String defineProcCfg(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			model.put("gridData", getProcCfg(commandMap));
			
			commandMap.put("itemClassCode","CL03004");
			List speList  = commonService.selectList("esm_SQL.getSRStatusList", commandMap);
			model.put("speList", new JSONArray(speList));

			List speNames = new ArrayList();
			for(int i=0; i<speList.size(); i++) {
				Map map = (Map) speList.get(i);
				speNames.add(StringUtil.checkNull(map.get("NAME")));
			}
			model.put("speNames", new JSONArray(speNames));
			
	        model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/defineProcCfg");
	}
    
    private JSONArray getProcCfg(HashMap commandMap) throws Exception {
		List gridList = commonService.selectList("procLog_SQL.getESMProcConfig", commandMap);
		JSONArray gridData = new JSONArray(gridList);
		return gridData;
	}
	
	@RequestMapping(value = "/addProcCfg.do")
	public String addProcCfg(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
			commandMap.put("itemClassCode","CL03004");
			
			List speList  = commonService.selectList("esm_SQL.getSRStatusList", commandMap);
			model.put("speList", new JSONArray(speList));
			
			List speNames = new ArrayList();
			for(int i=0; i<speList.size(); i++) {
				Map map = (Map) speList.get(i);
				speNames.add(StringUtil.checkNull(map.get("NAME")));
			}
			model.put("speNames", new JSONArray(speNames));
			
	        model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/adm/configuration/change management/addProcCfg");
	}
	
	@RequestMapping(value = "/saveProcCfg.do")
	public String saveProcCfg(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		try {
			String prcCfgID = StringUtil.checkNull(request.getParameter("PRCCFGID"));
			String srType = StringUtil.checkNull(request.getParameter("srType"));
			String functionNM = StringUtil.checkNull(request.getParameter("functionNM"));
			String pIDParameter = StringUtil.checkNull(request.getParameter("pIDParameter"));
			String actionParameter = StringUtil.checkNull(request.getParameter("actionParameter"));
			String eventParameter = StringUtil.checkNull(request.getParameter("eventParameter"),"");
			String eventValue = StringUtil.checkNull(request.getParameter("eventValue"),"");
			String speCode = StringUtil.checkNull(request.getParameter("speCode"));
			String procPathID = StringUtil.checkNull(request.getParameter("procPathID"));
			
			setMap.put("prcCfgID",prcCfgID);
			setMap.put("srType",srType);
			setMap.put("functionNM",functionNM);
			setMap.put("pIDParameter",pIDParameter);
			setMap.put("actionParameter",actionParameter);
			setMap.put("eventParameter",eventParameter);
			setMap.put("eventValue",eventValue);
			setMap.put("speCode",speCode);
			setMap.put("procPathID",procPathID);
			setMap.put("userID", commandMap.get("sessionUserId"));
			
			if(prcCfgID.equals("")) {	//grid add
				String maxProcCfgID = StringUtil.checkNull(commonService.selectString("procLog_SQL.maxProcCfgID",setMap)).trim();		
				maxProcCfgID = maxProcCfgID.substring(maxProcCfgID.length() - 3, maxProcCfgID.length());
				prcCfgID = "PRC" + String.format("%04d", Integer.parseInt(maxProcCfgID) + 1);
				
				setMap.put("prcCfgID",prcCfgID);
				commonService.insert("procLog_SQL.insertProcCfg", setMap);
			} else { //grid edit
				commonService.update("procLog_SQL.updateProcCfg", setMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "this.fnCallBack("+getProcCfg(commandMap)+")");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/saveAllProcCfg.do", produces = "application/text; charset=utf-8")
	public void saveAllProcCfg(HttpServletRequest request, HttpServletResponse response, HashMap commandMap) throws Exception {
		JSONArray result = new JSONArray();
		try {			
			JSONArray jsonArray  = new JSONArray(request.getParameter("editedRow"));
			
			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject jo = (JSONObject)jsonArray.get(i);
				
				String prcCfgID = StringUtil.checkNull(jo.get("PRCCFGID"));
				String srType = StringUtil.checkNull(jo.get("SRType"));
				String functionNM = StringUtil.checkNull(jo.get("FunctionNM"));
				String pIDParameter = StringUtil.checkNull(jo.get("PIDParameter"));
				String actionParameter = StringUtil.checkNull(jo.get("ActionParameter"));
				String eventParameter = StringUtil.checkNull(jo.get("EventParameter"));
				String eventValue = StringUtil.checkNull(jo.get("EventValue"));
				String speCode = StringUtil.checkNull(jo.get("SpeCode"));
				String procPathID = StringUtil.checkNull(jo.get("ProcPathID"));

				Map setMap = new HashMap();
				setMap.put("prcCfgID",prcCfgID);
				setMap.put("srType",srType);
		        setMap.put("functionNM",functionNM);
		        setMap.put("pIDParameter",pIDParameter);
				setMap.put("actionParameter",actionParameter);
				setMap.put("eventParameter",eventParameter);
				setMap.put("eventValue",eventValue);
				setMap.put("speCode",speCode);
				setMap.put("procPathID",procPathID);
				setMap.put("userID", commandMap.get("sessionUserId"));
				
				if(prcCfgID.equals("")) {	//grid add
					String maxProcCfgID = StringUtil.checkNull(commonService.selectString("procLog_SQL.maxProcCfgID",setMap)).trim();		
					maxProcCfgID = maxProcCfgID.substring(maxProcCfgID.length() - 3, maxProcCfgID.length());
					prcCfgID = "PRC" + String.format("%04d", Integer.parseInt(maxProcCfgID) + 1);
					
					setMap.put("prcCfgID",prcCfgID);
					commonService.insert("procLog_SQL.insertProcCfg", setMap);
				} else { //grid edit
					commonService.update("procLog_SQL.updateProcCfg", setMap);
				}
			}
			response.setCharacterEncoding("UTF-8");
			result = getProcCfg(commandMap);
		} catch (Exception e) {
			System.out.println(e);
		}
		response.getWriter().print(result);
	}
	
	@RequestMapping(value="/delProcCfg.do")
	public String delProcCfg(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();  
		try{
			Map setMap = new HashMap();
			String prcCfgID = StringUtil.checkNull(request.getParameter("prcCfgID"));
			
		   setMap.put("prcCfgID", prcCfgID);
		   commonService.delete("procLog_SQL.delProcCfg", setMap);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣 �꽦怨�
			target.put(AJAX_SCRIPT, "this.fnCallBack("+getProcCfg(commandMap)+")");
			
	  } catch (Exception e) {
		  System.out.println(e);
		  target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
		  //target.put(AJAX_ALERT, "�궘�젣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
		  target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜� 諛쒖깮
	  }
		model.addAttribute(AJAX_RESULTMAP, target);
        return nextUrl(AJAXPAGE);
    }
	
	/**
	 * Configuration Menu Path 조회
	 * @param setMap
	 * @param modelMap
	 * @return path
	 * @throws Exception
	 */
	public List getCFGMenuPath(String cfgCode, String languageID, List path, HashMap commandMap) throws Exception {
		System.out.println("getCFGMenuPath");
		Map setMap = new HashMap();
		Map temp = new HashMap();
		setMap.put("cfgCode", cfgCode);
		setMap.put("sessionCurrLangType", commandMap.get("sessionCurrLangType"));
		String parentCode = StringUtil.checkNull((commonService.select("config_SQL.getCfgObjInfo", setMap)).get("parentCode"),"0");
				
		if(!parentCode.equals("0")) {
			setMap.put("typeCode", cfgCode);
			setMap.put("languageID", languageID);
			setMap.put("category", "CFG");
			temp.put("cfgName",StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic",setMap)));
			temp.put("cfgCode",cfgCode);
			path.add(temp);
			getCFGMenuPath(parentCode,languageID,path, commandMap);
		}
		return path;
	}
	
	@RequestMapping(value = "/espActivityAttrTypeList.do")
	public String espActivityAttrTypeList(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		String url = "/adm/configuration/menu/espActivityAttrTypeList";
		try {
			HashMap<String, Comparable> setMap = new HashMap<String, Comparable>();

			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String SpeCode = StringUtil.checkNull(request.getParameter("SpeCode"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", s_itemID);
			model.put("languageID", languageID);
			model.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			model.put("CategoryCode", request.getParameter("CategoryCode"));
			model.put("ClassName", request.getParameter("ClassName"));
			model.put("pageNum", request.getParameter("pageNum"));
			
			setMap.put("languageID",languageID);
			setMap.put("menuCat","ATR");			
			List LinkList = commonService.selectList("common_SQL.getMenuType_commonSelect",setMap);
			model.put("Link", new JSONArray(LinkList));
			
			List LinkNames = new ArrayList();
			LinkNames.add("");
			for(int i=0; i<LinkList.size(); i++) {
				Map map = (Map) LinkList.get(i);
				LinkNames.add(StringUtil.checkNull(map.get("NAME")));
			}
			model.put("LinkNames", new JSONArray(LinkNames));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	public static String getJSONFormatClean(String s) {
	    if (s == null) {
	        return null;
	    }

	    return s.replace("\\\\/", "\\/").replace("\\\"", "&#34;").replace("\\r\\n", "\n").replace("\\n", "<br/>").replace("\\\\", "\\");
	}
	
	@RequestMapping(value = "/saveChildItemEspAttr.do")
	public String saveChildItemAttr(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map setMap = new HashMap();
			Map setData = new HashMap();
			String setInfo = "";
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String userID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String espAttrData = getJSONFormatClean(StringUtil.checkNull(request.getParameter("espAttrData")));

			JSONArray jsonArray = new JSONArray(espAttrData);

			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject jsonData = (JSONObject) jsonArray.get(i);
				String SortNum = StringUtil.checkNull(jsonData.get("SortNum"));
				String Mandatory = StringUtil.checkNull(jsonData.get("Mandatory"));
				String Link = StringUtil.checkNull(jsonData.get("LinkCode"));
				String Invisible = StringUtil.checkNull(jsonData.get("Invisible"));
				String VarFilter = StringUtil.checkNull(jsonData.get("VarFilter"));
				String RowNum = StringUtil.checkNull(jsonData.get("RowNum"));
				String ColumnNum = StringUtil.checkNull(jsonData.get("ColumnNum"));
				String AreaHeight = StringUtil.checkNull(jsonData.get("AreaHeight"));
				String SpeCode = StringUtil.checkNull(jsonData.get("SpeCode"));
				String AttrTypeCode = StringUtil.checkNull(jsonData.get("AttrTypeCode"));
				String DefaultValue = StringUtil.checkNull(jsonData.get("DefaultValue"));
				String Editable = StringUtil.checkNull(jsonData.get("Editable"));

				Map setValue = new HashMap();
			
				setValue.put("SortNum", SortNum);
				setValue.put("Mandatory", Mandatory);
				setValue.put("Link", Link);
				setValue.put("Invisible", Invisible);
				setValue.put("VarFilter", VarFilter);
				setValue.put("RowNum", RowNum);
				setValue.put("ColumnNum", ColumnNum);
				setValue.put("AreaHeight", AreaHeight);
				setValue.put("SpeCode", SpeCode);
				setValue.put("AttrTypeCode", AttrTypeCode);
				setValue.put("DefaultValue", DefaultValue);
				setValue.put("Editable", Editable);

				commonService.update("attr_SQL.updateEspItemObjectInfo", setValue);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "parent.doOTSearchList();parent.fnBack();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/addSRAttrTypeCode.do")
	public String addSRAttrTypeCode(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", request.getParameter("s_itemID"));
			model.put("languageID", request.getParameter("languageID"));
			model.put("Category", "ESM");
			
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("ItemClassCode", request.getParameter("ItemTypeCode"));
			setMap.put("Category", "ESM");
			List list = commonService.selectList("config_SQL.getUnAllocAttrType_gridList", setMap);
			JSONArray gridData = new JSONArray(list);
			model.put("gridData", gridData);
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/adm/configuration/master data/addAttrTypeCode");
	}

	@RequestMapping(value = "/SaveSRAttrType.do")
	public String SavSReAttrType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			Map getMap = new HashMap();

			String attrCodes = StringUtil.checkNull(request.getParameter("attrCodes"));
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			//String SRType = StringUtil.checkNull(request.getParameter("SRType"));
			String DocCategory = StringUtil.checkNull(request.getParameter("DocCategory"));

			String[] arrayAttrCodes = attrCodes.split(",");

			for (int i = 0; i < arrayAttrCodes.length; i++) {
				getMap.put("AttrTypeCode", arrayAttrCodes[i]);
				getMap.put("s_itemID", s_itemID);
				getMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
				commonService.insert("config_SQL.InsertAddSRAttributeType", getMap);
			}
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 
						target.put(AJAX_SCRIPT, "this.selfClose();this.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); 																								// 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/DeleteSRAttrType.do")
	public String UpdateSRAttrType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			// List getValue = new ArrayList();
			Map getMap = new HashMap();
			getMap.put("SpeCode", request.getParameter("SpeCode"));
			getMap.put("AttrTypeCode", request.getParameter("AttrTypeCode"));
			commonService.update("config_SQL.DeleteSRAttrTypeGrid", getMap);

			if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));																											// �꽦怨�
				target.put(AJAX_SCRIPT, "this.doOTSearchList();this.$('#isSubmit').remove();");
			}
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣																											// 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/espActivityFLTPList.do")
	public String espActivityFLTPList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/adm/configuration/menu/espActivityFLTPList";

		try {
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String ItemClassCode = StringUtil.checkNull(request.getParameter("s_itemID"));
	
			commandMap.put("languageID", languageID);
	        commandMap.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
	        /*
	        List subFileList = commonService.selectList("config_SQL.SubEsmFileTab_gridList", commandMap);
	        JSONArray gridData = new JSONArray(subFileList);
	        model.put("gridData",gridData);	
	        */
	        
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			model.put("languageID", request.getParameter("languageID"));
			model.put("ClassName", request.getParameter("ClassName"));
			model.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			model.put("CategoryCode", request.getParameter("CategoryCode"));
			model.put("pageNum", request.getParameter("pageNum"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/addEsmFileAllocPop.do")
	public String YjAddEsmFileTypeTab(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		String url = "/adm/configuration/master data/addFileAllocPop";
		try {
			String languageID = StringUtil.checkNull(mapValue.get("sessionCurrLangType"));
			String ClassCode = StringUtil.checkNull(request.getParameter("ClassCode"));

			mapValue.put("languageID", languageID);
			mapValue.put("ClassCode", ClassCode);
	        List addFileAList = commonService.selectList("config_SQL.AllocateEsmFileType_gridList", mapValue);
	        JSONArray gridData = new JSONArray(addFileAList);
	        model.put("gridData",gridData);	
	        
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("Category", "ESM");
			model.put("languageID", request.getParameter("languageID"));
			model.put("s_itemID", request.getParameter("s_itemID"));
			model.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			model.put("ClassName", request.getParameter("ClassName"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}
	
	@RequestMapping(value = "/SaveEsmFileType.do")
	public String SaveEsmFileType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			Map getMap = new HashMap();
			
			String fileTypeCodes = StringUtil.checkNull(request.getParameter("fileTypeCodes"));
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			
			String[] arrayFileTypeCodes = fileTypeCodes.split(",");
			
			for (int i = 0; i < arrayFileTypeCodes.length ; i++) {
				getMap.put("FltpCode", arrayFileTypeCodes[i]);
				getMap.put("s_itemID", s_itemID);
				getMap.put("languageID", commandMap.get("sessionCurrLangType"));
				commonService.insert("config_SQL.InsertEsmFileType", getMap);
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣
			target.put(AJAX_SCRIPT,"this.selfClose();this.$('#isSubmit').remove();"); // �꽦怨�

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " ���옣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);

	}
	
	@RequestMapping(value = "/DeleteEsmFileType.do")
	public String DeleteEsmFileType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			getMap.put("FltpCode", request.getParameter("FltpCode"));
			getMap.put("s_itemID", request.getParameter("s_itemID"));

			commonService.delete("config_SQL.DeleteEsmFileType", getMap);

			if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
				// target.put(AJAX_ALERT, "�궘�젣媛� �꽦怨듯븯���뒿�땲�떎.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣													
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove();"); // �꽦怨�
			}

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " �궘�젣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�														// 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		// model.put("noticType", noticType);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/updateEsmFltpAlloc.do")
	public String updateEsmFltpAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
			try {
				String fltpCodes[] = StringUtil.checkNull(request.getParameter("fltpCodes"),"").split(",");
				String SpeCode = StringUtil.checkNull(request.getParameter("SpeCode"));
				String mandatories[] = StringUtil.checkNull(request.getParameter("mandatories"),"").split(",");
				String remarks[] = StringUtil.checkNull(request.getParameter("remarks"),"").split(",");
				String linkTypes[] = StringUtil.checkNull(request.getParameter("linkTypes"),"").split(",");

				
				  for(int i=0; i<fltpCodes.length; i++){     
				        setMap.put("fltpCode",fltpCodes[i]);
						setMap.put("mandatory",mandatories[i]);
						if(remarks.length > 0)setMap.put("remark",remarks[i]);
						setMap.put("linkType",linkTypes[i]);
						setMap.put("SpeCode",SpeCode);
				        commonService.update("config_SQL.updateEsmFltpAlloc", setMap);
					}
			    
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 	
//				target.put(AJAX_SCRIPT, "this.fnCallBack();");
				target.put(AJAX_SCRIPT, "parent.fnCallBack();parent.$('#isSubmit').remove();");
				
			} catch (Exception e) {
				System.out.println(e);
//				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮												
			}
			model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(AJAXPAGE);
	}
}
