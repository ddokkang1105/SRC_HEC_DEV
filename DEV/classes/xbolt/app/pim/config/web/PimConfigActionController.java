package xbolt.app.pim.config.web;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
/**
 * 공통 서블릿 처리
 * @Class Name : InstnceActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2018. 06. 07. Smartfactory / sykang		최초생성
 *
 * @since 2018. 06. 07
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class PimConfigActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/pim_configProcRole.do")
	public String processConfig(HttpServletRequest request,HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/app/pim/config/pim_ConfigProcRole";
		try {
			String itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
			String classCode = StringUtil.checkNull(request.getParameter("varFilter"), "");
			
			Map setData = new HashMap();
			setData.put("itemID", itemID);
			String modelID = StringUtil.checkNull(commonService.selectString("model_SQL.getModelIDFromItem",setData));
			
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			setData.put("languageID", languageID);			
			Map s_itemInfo = commonService.select("procConfig_SQL.getProcessStepList",setData);
			
			setData = new HashMap();
			setData.put("modelID", modelID);
			setData.put("classCode", classCode);
			setData.put("languageID", languageID);
			List processStepList = new ArrayList();
			if(!modelID.equals("")){
				processStepList = (List) commonService.selectList("procConfig_SQL.getProcessStepList",setData);
				model.put("prcTreeXml", makeProcessConfigXML(s_itemInfo, processStepList,cmmMap));
			}
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("VariantActionController::processConfig::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	private String makeProcessConfigXML(Map s_itemInfo, List prcListData, HashMap cmmMap) throws Exception {
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
		Map setData = new HashMap();
		List roleItemList = new ArrayList();
		List programItemList = new ArrayList();
		String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
		
		
		String itemID = StringUtil.checkNull(s_itemInfo.get("ItemID"));
		String identifier = StringUtil.checkNull(s_itemInfo.get("Identifier"));
		String itemName = StringUtil.checkNull(s_itemInfo.get("ItemName"));
		String path = StringUtil.checkNull(s_itemInfo.get("Path"));
		String orderTeamName = StringUtil.checkNull(s_itemInfo.get("OwnerTeamName"));
		String teamName = StringUtil.checkNull(s_itemInfo.get("TeamName"));
		String authorName = StringUtil.checkNull(s_itemInfo.get("AuthorName"));
		String creationTime = StringUtil.checkNull(s_itemInfo.get("CreationTime"));	
		String statusName = StringUtil.checkNull(s_itemInfo.get("StatusName"));	
		String classCode = StringUtil.checkNull(s_itemInfo.get("ClassCode"));
		String className = StringUtil.checkNull(s_itemInfo.get("ClassName"));
		String classImg = "";
		
		resultRow += "<row id='" + itemID +"."+idx+ "' open='1'>"; 
		resultRow += "<cell image='img_process.png'>"
				  + identifier +" "+itemName.replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ") + CELL_CLOSE;
		resultRow += "		" + CELL_OPEN+ path + CELL_CLOSE;	
		resultRow += "		" + CELL_OPEN+ orderTeamName + CELL_CLOSE;	
		resultRow += "		" + CELL_OPEN+ teamName + CELL_CLOSE;	
		resultRow += "		" + CELL_OPEN+ authorName + CELL_CLOSE;	
		resultRow += "		" + CELL_OPEN+ creationTime + CELL_CLOSE;	
		resultRow += "		" + CELL_OPEN+ statusName + CELL_CLOSE;	
		
		for (int i = 0; i < prcListData.size(); i++) {
			Map prcMap = (HashMap) prcListData.get(i);
			itemID = StringUtil.checkNull(prcMap.get("ItemID"));
			identifier = StringUtil.checkNull(prcMap.get("Identifier"));
			itemName = StringUtil.checkNull(prcMap.get("ItemName"));
			path = StringUtil.checkNull(prcMap.get("Path"));
			orderTeamName = StringUtil.checkNull(prcMap.get("OwnerTeamName"));
			teamName = StringUtil.checkNull(prcMap.get("TeamName"));
			authorName = StringUtil.checkNull(prcMap.get("AuthorName"));
			creationTime = StringUtil.checkNull(prcMap.get("CreationTime"));	
			statusName = StringUtil.checkNull(prcMap.get("StatusName"));	
			classCode = StringUtil.checkNull(prcMap.get("ClassCode"));
			className = StringUtil.checkNull(prcMap.get("ClassName"));
			
			resultRow += "<row id='" + itemID +"."+idx+ "' open='1'>"; 
			resultRow += "<cell image='tree_icon_process_step.gif'>"
					  + identifier +" "+itemName.replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ") + CELL_CLOSE;
			resultRow += "		" + CELL_OPEN+ path + CELL_CLOSE;	
			resultRow += "		" + CELL_OPEN+ orderTeamName + CELL_CLOSE;	
			resultRow += "		" + CELL_OPEN+ teamName + CELL_CLOSE;	
			resultRow += "		" + CELL_OPEN+ authorName + CELL_CLOSE;	
			resultRow += "		" + CELL_OPEN+ creationTime + CELL_CLOSE;	
			resultRow += "		" + CELL_OPEN+ statusName + CELL_CLOSE;	
			
				//CN00201  Get FromItemID (OJ00002)
				setData = new HashMap();				
				setData.put("itemTypeCode", "OJ00002");
				setData.put("processItemID", itemID);
				setData.put("languageID", languageID);			
				roleItemList = (List)commonService.selectList("procConfig_SQL.getRoleProgramList",setData);
		
				if(roleItemList.size() > 0 ){					
					for (int j = 0; j < roleItemList.size(); j++) {
						Map roleItemMap = (HashMap) roleItemList.get(j);
						
						itemID = StringUtil.checkNull(roleItemMap.get("ItemID"));
						identifier = StringUtil.checkNull(roleItemMap.get("Identifier"));
						itemName = StringUtil.checkNull(roleItemMap.get("ItemName"));
						path = StringUtil.checkNull(roleItemMap.get("Path"));
						orderTeamName = StringUtil.checkNull(roleItemMap.get("OwnerTeamName"));
						teamName = StringUtil.checkNull(roleItemMap.get("TeamName"));
						authorName = StringUtil.checkNull(roleItemMap.get("AuthorName"));
						creationTime = StringUtil.checkNull(roleItemMap.get("CreationTime"));	
						statusName = StringUtil.checkNull(roleItemMap.get("StatusName"));	
						classCode = StringUtil.checkNull(roleItemMap.get("ClassCode"));
						className = StringUtil.checkNull(roleItemMap.get("ClassName"));
						
						resultRow += "<row id='" + itemID +"."+idx+ "' open='1'>"; 
						resultRow += "<cell image='img_job.png'>"
								  +" " + identifier +" "+itemName.replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ") + CELL_CLOSE;
						resultRow += "		" + CELL_OPEN+ path + CELL_CLOSE;	
						resultRow += "		" + CELL_OPEN+ orderTeamName + CELL_CLOSE;	
						resultRow += "		" + CELL_OPEN+ teamName + CELL_CLOSE;	
						resultRow += "		" + CELL_OPEN+ authorName + CELL_CLOSE;	
						resultRow += "		" + CELL_OPEN+ creationTime + CELL_CLOSE;	
						resultRow += "		" + CELL_OPEN+ statusName + CELL_CLOSE;	
						
						//CN00204  Get ToItemID (OJ00004)
						setData = new HashMap();				
						setData.put("itemTypeCode", "OJ00004");	
						setData.put("roleItemID", itemID);
						setData.put("languageID", languageID);	
						programItemList = (List)commonService.selectList("procConfig_SQL.getRoleProgramList",setData);
						
						if(programItemList.size() > 0 ){					
							for (int k = 0; k < programItemList.size(); k++) {
								Map programItemMap = (HashMap) programItemList.get(k);
								itemID = StringUtil.checkNull(programItemMap.get("ItemID"));
								identifier = StringUtil.checkNull(programItemMap.get("Identifier"));
								itemName = StringUtil.checkNull(programItemMap.get("ItemName"));
								path = StringUtil.checkNull(programItemMap.get("Path"));
								orderTeamName = StringUtil.checkNull(programItemMap.get("OwnerTeamName"));
								teamName = StringUtil.checkNull(programItemMap.get("TeamName"));
								authorName = StringUtil.checkNull(programItemMap.get("AuthorName"));
								creationTime = StringUtil.checkNull(programItemMap.get("CreationTime"));	
								statusName = StringUtil.checkNull(programItemMap.get("StatusName"));	
								classCode = StringUtil.checkNull(programItemMap.get("ClassCode"));
								className = StringUtil.checkNull(programItemMap.get("ClassName"));
								
								resultRow += "<row id='" + itemID +"."+idx+ "' open='1'>";  idx++;
								resultRow += "<cell image='img_system.png'>"
										  +" "+ identifier +" "+itemName.replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ") + CELL_CLOSE;
								resultRow += "		" + CELL_OPEN+ path + CELL_CLOSE;	
								resultRow += "		" + CELL_OPEN+ orderTeamName + CELL_CLOSE;	
								resultRow += "		" + CELL_OPEN+ teamName + CELL_CLOSE;	
								resultRow += "		" + CELL_OPEN+ authorName + CELL_CLOSE;	
								resultRow += "		" + CELL_OPEN+ creationTime + CELL_CLOSE;	
								resultRow += "		" + CELL_OPEN+ statusName + CELL_CLOSE;	
								resultRow += ROW_CLOSE;
							}
						}
						resultRow += ROW_CLOSE;
					}
				}
				resultRow += ROW_CLOSE;
		}
		resultRow += ROW_CLOSE;
		result += resultRow;
		result += "</rows>";
		return result.replace("&", "/"); 
	}
	
	@RequestMapping(value="/pim_ItemConfigMgt.do")
	public String Pim_ItemConfigMgt(HttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception{
		String url = "/app/pim/config/pim_ItemConfigMgt";
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String cfgDefArc =  "PLM000";
			Map setMap = new HashMap();
			Map getMap = new HashMap();
			setMap.put("languageID", StringUtil.checkNull(cmmMap.get("languageID")));
			setMap.put("s_itemID", s_itemID);
			setMap.put("ArcCode", cfgDefArc);
			
			/*message 가져오기*/
			cmmMap.put("languageID", StringUtil.checkNull(cmmMap.get("languageID"), GlobalVal.DEFAULT_LANGUAGE));
			cmmMap.put("Category", "MSG");
		
			List messageList = commonService.selectList("procConfig_SQL.messageName",cmmMap);
		
			HashMap messageMap = new HashMap();
			HashMap listMap = new HashMap();
			for(int i = 0; i < messageList.size(); i++){
				listMap = (HashMap)messageList.get(i);
				messageMap.put(listMap.get("TypeCode"), listMap.get("Name"));
			}
		
			
			/*기본정보 취득*/
			List prcList = commonService.selectList("report_SQL.getItemInfo", setMap);
			/*ItemMgt 정보 취득*/
			Map itemConfigMap = commonService.select("procConfig_SQL.itemConfigInfo", setMap);
			
			/*SubMenu Default*/
			List getList = commonService.selectList("menu_SQL.getTabMenu", setMap);
			
			/*담당자 정보*/
			Map prcMap = (Map) prcList.get(0);
			setMap.put("MemberID", prcMap.get("AuthorID"));
			Map authorInfoMap = commonService.select("item_SQL.getAuthorInfo", setMap);
			/*Configurator 정보*/
			setMap.remove("MemberID");
			setMap.put("MemberID", itemConfigMap.get("RegUserID"));
			Map actorInfoMap = commonService.select("item_SQL.getAuthorInfo", setMap);
			
//			/*status(Action List 제어)*/
//			String sessionUserID = cmmMap.get("sessionUserId").toString();
//			// Login user editor 권한 추가
//			String sessionAuthLev = String.valueOf(cmmMap.get("sessionAuthLev")); // 시스템 관리자
//			if (StringUtil.checkNull(prcMap.get("AuthorID")).equals(sessionUserID)
//					|| StringUtil.checkNull(prcMap.get("LockOwner")).equals(cmmMap.get("sessionUserId"))
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			model.put("myItem", myItem);

			model.put("changeSTS", itemConfigMap.get("changeSetStatus"));
			model.put("configSTS", itemConfigMap.get("configStatus"));
			
			model.put("s_itemID", s_itemID);
			model.put("languageID", cmmMap.get("languageID"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("prcList", prcList); // 기본정보
			model.put("itemConfigMap",itemConfigMap);
			model.put("getList", getList); //tabMenu
			model.put("authorInfoMap", authorInfoMap); // 담당자 정보
			model.put("actorInfoMap", actorInfoMap); // Configurator 정보
			model.put("message",messageMap);
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("VariantActionController::processConfig::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/pim_AddItemConfig.do")
	public String pim_AddItemConfig(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{
			String itemId = StringUtil.checkNull(request.getParameter("s_itemID"));
			//String viewType = StringUtil.checkNull(request.getParameter("viewType"));
			//String copyItemID = StringUtil.checkNull(request.getParameter("copyItemID"));
			Map setValue = new HashMap();
			
			String itemConfigID = commonService.selectString("procConfig_SQL.getMaxItemConfigID",setValue);
			setValue.put("itemID", itemId);
			//setValue.put("copyItemID", copyItemID);
			setValue.put("itemConfigID", itemConfigID);
			setValue.put("UserID", commandMap.get("sessionUserId"));
			
			commonService.insert("procConfig_SQL.addItemConfigInfo", setValue);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "this.fnCallback();this.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/*@RequestMapping(value = "/pim_ItemConfigCopyListPop.do")
	public String pim_ItemConfigCopyListPop(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		String url = "/app/pim/config/pim_ItemConfigCopyListPop";
		try {
			model.put("menu", getLabel(request, commonService));  Label Setting 
			model.put("languageID", request.getParameter("languageID"));
			model.put("s_itemID", request.getParameter("s_itemID"));
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}*/
	
	@RequestMapping(value="/pim_ReleaseItemConfig.do")
	public String pim_ReleaseItemConfig(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{
			String itemId = request.getParameter("s_itemID");
			String itemConfigID = request.getParameter("itemConfigID");
			
			Map setValue = new HashMap();
			setValue.put("itemID", itemId);
			setValue.put("itemConfigID", itemConfigID);
			setValue.put("UserID", commandMap.get("sessionUserId"));
			setValue.put("status", "CLS");
			setValue.put("isLast", "1");
			
			commonService.update("procConfig_SQL.saveItemConfigInfo", setValue);
			commonService.update("procConfig_SQL.updateCurConfigID", setValue);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "this.fnCallback();this.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/pim_EditItemConfigInfo.do")
	public String pim_EditItemConfigInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/app/pim/config/pim_EditItemConfigInfo";
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"),"");
			
			Map setData = new HashMap();
			setData.put("s_itemID", s_itemID);
			setData.put("languageID", languageID);
			
			/*기본정보 취득*/
			List prcList = commonService.selectList("report_SQL.getItemInfo", setData);
			/*ItemMgt 정보 취득*/
			Map itemConfigMap = commonService.select("procConfig_SQL.itemConfigInfo", setData);
			
			model.put("s_itemID", s_itemID);
			model.put("languageID", languageID);
			model.put("prcList", prcList); // 기본정보
			model.put("itemConfigMap",itemConfigMap);
			//model.put("title", request.getParameter("title"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/pim_SaveItemConfigInfo.do")
	public String pim_SaveItemConfigInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{
			String itemId = request.getParameter("s_itemID");
			String itemConfigID = request.getParameter("itemConfigID");
			String description = request.getParameter("description");
			
			Map setValue = new HashMap();
			setValue.put("itemID", itemId);
			setValue.put("itemConfigID", itemConfigID);
			setValue.put("description", description);
			setValue.put("UserID", commandMap.get("sessionUserId"));
			
			commonService.update("procConfig_SQL.saveItemConfigInfo", setValue);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}	
	
	
	@RequestMapping(value = "/pim_AllocateItemAttrType.do")
	public String pim_AllocateItemAttrType(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/app/pim/config/pim_AllocateItemAttrType";
		try {
			Map setMap = new HashMap();
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("configSTS", StringUtil.checkNull(request.getParameter("configSTS")));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/pim_SaveItemAttrType.do")
	public String pim_SaveItemAttrType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {	
				String DefValue = StringUtil.checkNull(request.getParameter("defValue"),"");
				Map getMap = new HashMap();	
				getMap.put("SortNum", request.getParameter("objsortNum"));
				getMap.put("RowNum", request.getParameter("rowNum"));
				getMap.put("ColumnNum", request.getParameter("columnNum"));
				getMap.put("AttrTypeCode", request.getParameter("AttrTypeCode"));
				getMap.put("s_itemID", request.getParameter("s_itemID"));
				getMap.put("Mandatory", StringUtil.checkNull(request.getParameter("objMandatory"),""));
				getMap.put("Calculated", StringUtil.checkNull(request.getParameter("calculated"),""));
				getMap.put("Invisible", StringUtil.checkNull(request.getParameter("invisible"),""));
				getMap.put("Link",StringUtil.checkNull(request.getParameter("link"), ""));
				getMap.put("varFilter", request.getParameter("varFilter"));
				getMap.put("dicCode", request.getParameter("dicCode"));
				getMap.put("EditLink", request.getParameter("editLink"));
				getMap.put("EditLinkVarFilter", request.getParameter("editLinkVarFilter"));
				getMap.put("DefValue", DefValue);
				getMap.put("UserID", commandMap.get("sessionUserId"));
				getMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
				
				commonService.update("procConfig_SQL.UpdateItemAttrType", getMap);
				
				String checkNew = StringUtil.checkNull(commonService.selectString("procConfig_SQL.selectItemAttrDef", getMap), "");
				if (checkNew.equals("")) {
					if(!DefValue.equals("")){ commonService.insert("procConfig_SQL.InsertItemAttrDef", getMap);}
				} else {
					commonService.update("procConfig_SQL.UpdateItemAttrDef", getMap);
				}
	
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				target.put(AJAX_SCRIPT, "fnCallBack();");
				
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	// SubAttributeTypeAllocation Delete 부분
	@RequestMapping(value = "/pim_DeleteItemAttrType.do")
	public String pim_DeleteItemAttrType(HttpServletRequest request,HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			getMap.put("AttrTypeCode", request.getParameter("AttrTypeCode"));
			getMap.put("ItemID", request.getParameter("ItemID"));

			commonService.update("procConfig_SQL.DeleteItemAttrType", getMap);
			commonService.update("procConfig_SQL.DeleteItemAttrDef", getMap);

			if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제
				target.put(AJAX_SCRIPT,"fnCallBack();");
			}

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/pim_AddItemAttrTypeCode.do")
	public String pim_AddItemAttrTypeCode(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("languageID", request.getParameter("languageID"));
			model.put("TypeCode", request.getParameter("TypeCode"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/app/pim/config/pim_AddItemAttrTypeCode");
	}
	
	@RequestMapping(value = "/pim_AddItemAttrType.do")
	public String pim_AddItemAttrType(HttpServletRequest request, HashMap commandMap,ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			String attrCodes = StringUtil.checkNull(request.getParameter("attrCodes"));
			String ItemID = StringUtil.checkNull(request.getParameter("ItemID"));
			getMap.put("UserID", commandMap.get("sessionUserId"));

			String[] arrayAttrCodes = attrCodes.split(",");
			for (int i = 0; i < arrayAttrCodes.length; i++) {
				getMap.put("AttrTypeCode", arrayAttrCodes[i]);
				getMap.put("ItemID", ItemID);
				commonService.insert("procConfig_SQL.AddItemAttrType", getMap);
			}

			// target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT,"this.selfClose();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			// target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
		@RequestMapping(value = "/pim_AllocateItemFileType.do")
	public String pim_AllocateItemFileType(HttpServletRequest request, ModelMap model) throws Exception {

		String url = "/app/pim/config/pim_AllocateItemFileType";

		try {
			Map setMap = new HashMap();
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("varFilter",request.getParameter("varFilter"));
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			model.put("languageID", request.getParameter("languageID"));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("configSTS",  StringUtil.checkNull(request.getParameter("configSTS"), ""));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/pim_AddAllocItemFilePop.do")
	public String pim_AddAllocItemFilePop(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		String url = "/app/pim/config/pim_AddAllocItemFilePop";
		try {
			model.put("varFilter",request.getParameter("varFilter"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("languageID", request.getParameter("languageID"));
			model.put("s_itemID", request.getParameter("s_itemID"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}
	
	@RequestMapping(value = "/pim_AddAllocItemFile.do")
	public String pim_AddAllocItemFile(HttpServletRequest request, HashMap commandMap,ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			Map getMap = new HashMap();
			
			String fileTypeCodes = StringUtil.checkNull(request.getParameter("fileTypeCodes"));
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			getMap.put("UserID", commandMap.get("sessionUserId"));
			
			String[] arrayFileTypeCodes = fileTypeCodes.split(",");
			for (int i = 0; i < arrayFileTypeCodes.length ; i++) {
				getMap.put("FltpCode", arrayFileTypeCodes[i]);
				getMap.put("ItemID", itemID);
				commonService.insert("procConfig_SQL.AddItemFileType", getMap);
			}
			
			model.put("varFilter",request.getParameter("varFilter"));
			model.put("s_itemID",itemID);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
			target.put(AJAX_SCRIPT,"this.selfClose();this.$('#isSubmit').remove();"); // 성공

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);

	}
	
	@RequestMapping(value = "/pim_DeleteAllocItemFileType.do")
	public String pim_DeleteFileType(HttpServletRequest request,HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			getMap.put("FltpCode", request.getParameter("FltpCode"));
			getMap.put("ItemID", request.getParameter("s_itemID"));

			commonService.delete("procConfig_SQL.DeleteItemFileType", getMap);

			if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제													
				target.put(AJAX_SCRIPT, "this.gridOTInit();this.doOTSearchList();this.$('#isSubmit').remove();"); // 성공
			}

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(
					AJAX_ALERT,
					MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);

	}
	
	@RequestMapping(value = "/pim_UpdateAllocItemFileType.do")
	public String pim_UpdateFltpAlloc(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
			try {
				String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
				String itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
				String linkType = StringUtil.checkNull(commandMap.get("linkType"));
				String mandatory = StringUtil.checkNull(commandMap.get("objMandatory"));
				
				setMap.put("fltpCode", fltpCode);
				setMap.put("itemID", itemID);
				setMap.put("linkType", linkType);
				setMap.put("mandatory", mandatory);
				setMap.put("UserID", commandMap.get("sessionUserId"));
			    commonService.update("procConfig_SQL.updateItemFileType", setMap); 
			    
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 	
				target.put(AJAX_SCRIPT, "this.urlReload();");
				
			} catch (Exception e) {
				System.out.println(e);
				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생												
			}
			model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value = "/pim_AllocateItemReportType.do")
	public String pim_AllocateItemReportType(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/app/pim/config/pim_AllocateItemReportType";
		try {
			Map setMap = new HashMap();
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("languageID", request.getParameter("languageID"));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("configSTS",  StringUtil.checkNull(request.getParameter("configSTS"), ""));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/pim_AddAllocItemReportCode.do")
	public String addAllocItemReportCode(HttpServletRequest request,
			HashMap mapValue, ModelMap model) throws Exception {
		String url = "/app/pim/config/pim_AddAllocItemReportCode";
		try {

			model.put("menu", getLabel(request, commonService)); /* Label Setting */

			model.put("languageID", request.getParameter("languageID"));
			model.put("s_itemID", request.getParameter("s_itemID"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}
	
	// SaveReportType Insert 부분
	@RequestMapping(value = "/pim_AddAllocItemReport.do")
	public String pim_AddAllocItemReport(HttpServletRequest request,
			HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			Map getMap = new HashMap();
			
			String reportCodes = StringUtil.checkNull(request.getParameter("reportCodes"));
			String ItemID = StringUtil.checkNull(request.getParameter("ItemID"));
			getMap.put("UserID", commandMap.get("sessionUserId"));
			
			String[] arrayReportCodes = reportCodes.split(",");
			for(int i = 0; i < arrayReportCodes.length ; i++){
				getMap.put("ReportCode", arrayReportCodes[i]);
				getMap.put("ItemID", ItemID);

				commonService.insert("procConfig_SQL.AddItemReport", getMap);
			}
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장															// 성공
			target.put(AJAX_SCRIPT, "this.selfClose();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);

	}

	// SaveReportType Insert END

	// SaveReportType Delete 부분
	@RequestMapping(value = "/pim_DeleteAllocItemReport.do")
	public String pim_DeleteAllocItemReport(HttpServletRequest request,
			HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			getMap.put("ReportCode", request.getParameter("ReportCode"));
			getMap.put("ItemID", request.getParameter("ItemID"));

			commonService.delete("procConfig_SQL.DeleteItemReport", getMap);

			if (StringUtil.checkNull(request.getParameter("FinalData"), "").equals("Final")) {
				// target.put(AJAX_ALERT, "삭제가 성공하였습니다.");
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
				target.put(AJAX_SCRIPT,"this.gridOTInit();this.doOTSearchList();this.$('#isSubmit').remove();");
			}

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);

	}
	
	@RequestMapping(value = "/pim_AllocateItemMenu.do")
	public String pim_AllocateItemSubMenu(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/app/pim/config/pim_AllocateItemMenu";
		try {
				Map setMap = new HashMap();
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
				model.put("pageNum", request.getParameter("pageNum"));
				model.put("languageID",  StringUtil.checkNull(request.getParameter("languageID"), ""));
				model.put("configSTS",  StringUtil.checkNull(request.getParameter("configSTS"), ""));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/pim_AddAllocItemMenuPop.do")
	public String pim_AddAllocItemMenuPop(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {

			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("languageID", request.getParameter("languageID"));
			model.put("s_itemID", request.getParameter("s_itemID"));

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/app/pim/config/pim_AddAllocItemMenuPop");
	}
	
	@RequestMapping(value = "/pim_menuListPop.do")
	public String menuListPop(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/app/pim/config/pim_menuListPop";
		try {
				Map setMap = new HashMap();
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
				model.put("languageID",  StringUtil.checkNull(request.getParameter("languageID"), ""));
				model.put("menuCat",  StringUtil.checkNull(request.getParameter("menuCat"), ""));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/pim_SaveAllocItemMenu.do")
	public String pim_SaveAllocItemMenu(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			String viewType = StringUtil.checkNull(request.getParameter("viewType"), "");
			getMap.put("menuID", StringUtil.checkNull(request.getParameter("menuId"), ""));
			getMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			getMap.put("menuType", StringUtil.checkNull(request.getParameter("menuType"), ""));
			getMap.put("sort", StringUtil.checkNull(request.getParameter("sortNum"), ""));
			getMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), ""));
			getMap.put("menuNMCode", StringUtil.checkNull(request.getParameter("dicCode"), ""));
			getMap.put("varFilter", StringUtil.checkNull(request.getParameter("varFilter"), ""));
			getMap.put("UserID", commandMap.get("sessionUserId"));
			
			if(viewType.equals("N")){
				String ItemMenuID = commonService.selectString("procConfig_SQL.getMaxItemMenuSeq",getMap);
				if(ItemMenuID == "" || ItemMenuID == null){ItemMenuID = "1";}
				getMap.put("ItemMenuID", ItemMenuID);
				commonService.insert("procConfig_SQL.insertItemMenu",getMap);	
			}else{
				getMap.put("ItemMenuID", StringUtil.checkNull(request.getParameter("itemMenuID"), ""));
				commonService.insert("procConfig_SQL.updateItemMenu",getMap);
			}
			 						
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnCallback();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/pim_DeleteAllocItemMenu.do")
	public String pim_DeleteAllocItemMenu(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String reqSeq = StringUtil.checkNull(request.getParameter("itemMenuID"));
				String seq[] = reqSeq.split(",");
				setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
				
				for(int i=0; i<seq.length; i++){
					setMap.remove("seq");
					setMap.put("ItemMenuID", seq[i]);
					commonService.delete("procConfig_SQL.deleteItemMenu", setMap);
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
				target.put(AJAX_SCRIPT, "fnCallBack();");
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/pim_AllocateItemWF.do")
	public String pim_AllocateItemWF(HttpServletRequest request, ModelMap model) throws Exception {
		String url = "/app/pim/config/pim_AllocateItemWF";
		try {
			Map setMap = new HashMap();
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("configSTS",  StringUtil.checkNull(request.getParameter("configSTS"), ""));

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/pim_AddAllocItemWFPop.do")
	public String pim_AddAllocItemWFPop(HttpServletRequest request, HashMap mapValue, ModelMap model) throws Exception {
		String url = "/app/pim/config/pim_AddAllocItemWFPop";
		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("languageID", request.getParameter("languageID"));
			model.put("s_itemID", request.getParameter("s_itemID"));
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl(url);
	}
	
	@RequestMapping(value = "/pim_SaveAllocItemWF.do")
	public String pim_SaveAllocItemWF(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			String viewType = StringUtil.checkNull(request.getParameter("viewType"), "");
			getMap.put("old_WFID", StringUtil.checkNull(request.getParameter("old_WFID"), ""));
			getMap.put("WFID", StringUtil.checkNull(request.getParameter("WFID"), ""));
			getMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			getMap.put("Status", StringUtil.checkNull(request.getParameter("status"), ""));
			getMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID"), ""));
			getMap.put("UserID", commandMap.get("sessionUserId"));
			
			if(viewType.equals("N")){
				commonService.insert("procConfig_SQL.insertItemWF",getMap);	
			}else{
				commonService.insert("procConfig_SQL.updateItemWF",getMap);
			}
			 						
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnCallBack();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/pim_DeleteAllocItemWF.do")
	public String pim_DeleteAllocItemWF(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
				String reqSeq = StringUtil.checkNull(request.getParameter("WFID"));
				String seq[] = reqSeq.split(",");
				setMap.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
				
				for(int i=0; i<seq.length; i++){
					setMap.remove("seq");
					setMap.put("WFID", seq[i]);
					commonService.delete("procConfig_SQL.deleteItemWF", setMap);
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
				target.put(AJAX_SCRIPT, "fnCallBack();");
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	

	
}
