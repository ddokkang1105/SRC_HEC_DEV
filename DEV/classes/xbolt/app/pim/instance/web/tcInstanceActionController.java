package xbolt.app.pim.instance.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.org.json.JSONArray;

import javafx.scene.chart.PieChart.Data;
/**
 * 공통 서블릿 처리
 * @Class Name : InstnceActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2012. 09. 01. smartfactory		최초생성
 *
 * @since 2012. 09. 01.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class tcInstanceActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;

	private Map removeAllHtmlTagAndSetAttrInfo(Map map) {
		String description = "";
		Map listMap = new HashMap();
		
		if (null != map.get("ProcessInfo")) {
			description = map.get("ProcessInfo").toString().replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
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
	
	@RequestMapping(value="/tsList.do")
	public String pim_ProcInstanceList(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "//app/pim//instance/tc/tsList";
		try {
			String varFilter = StringUtil.checkNull(cmmMap.get("varFilter"));
			
			Map setMap = new HashMap();
			
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			
			if(varFilter.equals("elm")) {
				// model.put("elmItemID",cmmMap.get("s_itemID"));
				setMap.put("elmItemID",cmmMap.get("s_itemID"));
			}
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("masterItemID", StringUtil.checkNull(cmmMap.get("masterItemID"),(String) cmmMap.get("s_itemID")));
			model.put("languageID", cmmMap.get("sessionCurrLangType"));
			
			setMap.put("s_itemID",StringUtil.checkNull(cmmMap.get("masterItemID"),(String) cmmMap.get("s_itemID")));
			String authorID = commonService.selectString("item_SQL.getItemAuthorId", setMap);
			model.put("authorID",authorID);
			
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("processID",StringUtil.checkNull(cmmMap.get("masterItemID"),(String) cmmMap.get("s_itemID")));
			List tsList = commonService.selectList("instance_SQL.getProcInstList_gridList",setMap);
			
			JSONArray gridData = new JSONArray(tsList);
			model.put("gridData",gridData);	
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);		
	}
	
	@RequestMapping(value = "/registerTS.do")
	public String registerTS(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "/app/pim/instance/tc/registerTS";
		try {
			Map setMap = new HashMap();
			String masterItemID = StringUtil.checkNull(cmmMap.get("masterItemID"));
			
			setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("userId", cmmMap.get("sessionUserId"));
			setMap.put("ProjectType", "PJT");
			List pjtList = commonService.selectList("project_SQL.getProjectNameList", setMap);
			

			setMap.put("s_itemID",  masterItemID);
			setMap.put("MTCategory",  "BAS");
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			List modelList = commonService.selectList("model_SQL.getModelList_gridList", setMap);
			
			setMap.put("AuthorID", cmmMap.get("sessionUserId"));
			List csrList = commonService.selectList("project_SQL.getCsrListWithMember", setMap);
			
			model.put("pjtList",pjtList);
			model.put("csrList",csrList);
			model.put("modelList",modelList);
			model.put("p_itemID", masterItemID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/createTCInstance.do")
	public String createTCInstance(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setMap = new HashMap();
			HashMap insertPjtInstData = new HashMap();
			
			String instName = StringUtil.checkNull(request.getParameter("instName"));
			String documentNo = StringUtil.checkNull(request.getParameter("documentNo"));
			String modelID = StringUtil.checkNull(request.getParameter("modelList"));
			String startDate = StringUtil.checkNull(request.getParameter("startDate"));
			String endDate = StringUtil.checkNull(request.getParameter("endDate"));
			String csrID = StringUtil.checkNull(request.getParameter("csrList"));
			String p_itemID = StringUtil.checkNull(request.getParameter("p_itemID"));
			
			String loginUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String loginTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String Status = "WAT";
			
			String maxProcInstNo = StringUtil.checkNull(commonService.selectString("instance_SQL.maxProcInstNo",insertPjtInstData)).trim();		
			maxProcInstNo = maxProcInstNo.substring(maxProcInstNo.length() - 5, maxProcInstNo.length());
			int curProcInstCode = Integer.parseInt(maxProcInstNo) + 1;
			String ProcInstNo = "P" + String.format("%09d", curProcInstCode);
			
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("ModelID", modelID);
			Map modelInfo = commonService.select("model_SQL.getModel",setMap);
			
			// changesetID
			setMap.put("itemID",p_itemID);
			String changeSetID = commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap);
			
			insertPjtInstData.put("instanceNo", ProcInstNo);
			insertPjtInstData.put("processID", p_itemID);
			insertPjtInstData.put("procModelID", StringUtil.checkNull(modelInfo.get("RefModelID"),modelID));	// referenceModelID
			insertPjtInstData.put("procPathID", modelID);
			insertPjtInstData.put("ownerID", loginUserID);
			insertPjtInstData.put("ownerTeamID", loginTeamID);
			insertPjtInstData.put("startTime", startDate);
			insertPjtInstData.put("dueDate", "");
			insertPjtInstData.put("endTime", endDate);
			insertPjtInstData.put("status", Status);
			insertPjtInstData.put("procType", "TCP");
			insertPjtInstData.put("docCategory", "PJT");
			insertPjtInstData.put("documentNo", documentNo);
			insertPjtInstData.put("csrID", csrID);
			insertPjtInstData.put("changeSetID", changeSetID);
			commonService.insert("instance_SQL.insertProcInst", insertPjtInstData);
			
			insertPjtInstData.put("instanceClass", "PROC");
			insertPjtInstData.put("attrTypeCode",  "AT01001");
			insertPjtInstData.put("value", instName);
			insertPjtInstData.put("itemID", p_itemID);
			insertPjtInstData.put("regTeamID", loginTeamID);
			insertPjtInstData.put("regUserID", loginUserID);	
			insertPjtInstData.put("lastUserTeamID", loginTeamID);
			insertPjtInstData.put("lastUser", loginUserID);

			commonService.insert("instance_SQL.insertInstanceAttr", insertPjtInstData);	

			insertPjtInstData.put("attrTypeCode",  "AT00020");
			setMap.put("ItemID",p_itemID);
			setMap.put("attrTypeCode","AT00020");
			Map AT00020 = commonService.select("attr_SQL.getItemAttrText", setMap);
			insertPjtInstData.put("value", StringUtil.checkNull(AT00020.get("PlainText")));
			commonService.insert("instance_SQL.insertInstanceAttr", insertPjtInstData);
						
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT,"parent.fnCallBackSubmit();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
		
	@RequestMapping(value="/viewTSDetail.do")
	public String viewTSDetail(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "//app/pim//instance/tc/viewTSDetail";
		try {			
			String instanceNo = StringUtil.checkNull(cmmMap.get("instanceNo"));	
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String instanceClass = StringUtil.checkNull(cmmMap.get("instanceClass"));
			String masterItemID = StringUtil.checkNull(request.getParameter("masterItemID"));
			String procType = StringUtil.checkNull(request.getParameter("procType"));
			String scrnMode = StringUtil.checkNull(request.getParameter("scrnMode"),"V");
			
			Map setData = new HashMap();
			setData.put("ProcInstNo", instanceNo);
			if(masterItemID.equals("")) {
				masterItemID = StringUtil.checkNull(commonService.selectString("instance_SQL.getProcessID", setData));
			}
			
			setData.put("s_itemID", masterItemID);
			setData.put("languageID", languageID);
			/* 기본정보 내용 취득 */
			List prcList = commonService.selectList("report_SQL.getItemInfo", setData);
			Map prcMap = (Map) prcList.get(0);
//			String sessionAuthLev = String.valueOf(cmmMap.get("sessionAuthLev")); // 시스템 관리자
//			String sessionUserId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			
//			if (StringUtil.checkNull(prcMap.get("AuthorID")).equals(sessionUserId) 
//					|| StringUtil.checkNull(prcMap.get("LockOwner")).equals(sessionUserId)
//					|| "1".equals(sessionAuthLev)) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			model.put("myItem", myItem);

			
			model.put("s_itemID", masterItemID);
			
			setData = new HashMap();
			setData.put("instanceNo", instanceNo);
			setData.put("instanceClass", instanceClass);
			setData.put("languageID", languageID);
			Map procInstanceInfo = commonService.select("instance_SQL.getProcInstanceInfo", setData);			
			model.put("procInstanceInfo", procInstanceInfo);	
			
			/** 첨부문서 취득 */
			setData.put("isPublic", "N");
			List attachFileList = commonService.selectList("instanceFile_SQL.getInstanceFile", setData);
			model.put("attachFileList", attachFileList);
			
			/* ModelID 보유 확인 */
			Map setMap = new HashMap();
			setMap.put("languageID", cmmMap.get("languageID"));			
			setMap.put("ModelID", instanceNo);
			setMap.put("s_itemID", instanceNo);			
			
			model.put("id", instanceNo);
			model.put("masterItemID", instanceNo);
			model.put("variantClass", cmmMap.get("variantClass"));
			model.put("masterProjectID", cmmMap.get("masterProjectID"));
			model.put("myProject", cmmMap.get("myProject"));
			model.put("refPGID", cmmMap.get("refPGID"));
			model.put("choiceIdentifier", instanceNo);
			model.put("level", (String)cmmMap.get("level"));
			model.put("menuText", StringUtil.checkNull(cmmMap.get("menuText")));
			model.put("fromModelYN", StringUtil.checkNull(cmmMap.get("fromModelYN"),""));
			model.put("focusedItemID", StringUtil.checkNull(cmmMap.get("focusedItemID"),""));
			model.put("instanceClass", StringUtil.checkNull(cmmMap.get("instanceClass"),""));
			model.put("prcMap", prcMap);
			model.put("scrnMode", scrnMode);
			model.put("procType", procType);
			model.put("menu", getLabel(cmmMap, commonService));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);		
	}
	
    @RequestMapping(value="/viewTestObjectTree.do")
	public String viewTestObjectTree(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "/app/pim//instance/tc/viewTestObjectTree";
		List GRList = new ArrayList();
		Map setMap = new HashMap();
		List<Map<String, Object>> list= new ArrayList();
		try {
			String modelID = StringUtil.checkNull(request.getParameter("procModelID"), "");
			String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"), "");
			String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"), "");
			String processID = StringUtil.checkNull(request.getParameter("processID"), "");
//			String searchValue = StringUtil.checkNull(request.getParameter("searchValue"), "");
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			
			setMap.put("languageID", languageID);
			setMap.put("ItemID", processID);
			setMap.put("modelID", modelID);
			setMap.put("attrTypeCode", "AT00036");

			setMap.put("ModelID", modelID);
			Map modelMap = commonService.select("model_SQL.getModelViewer", setMap);
			
			setMap.put("languageID", languageID);
			setMap.put("instanceNo", instanceNo);
			setMap.put("testCase", "Y");
			setMap.put("grInstNo","GR");
			GRList = (List) commonService.selectList("instance_SQL.getElmInstList_gridList", setMap);

			setMap.put("instanceNo", instanceNo);
			setMap.put("instanceClass", instanceClass);
			Map procInstanceInfo = commonService.select("instance_SQL.getProcInstanceInfo", setMap);			
			model.put("procInstanceInfo", procInstanceInfo);	
			
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			setMap.put("defaultLang", defaultLang);
			setMap.put("languageID", languageID);
			setMap.put("s_itemID", processID);
			/* 기본정보 내용 취득 */
			List prcList = commonService.selectList("report_SQL.getItemInfo", setMap);
			Map prcMap = (Map) prcList.get(0);			
			model.put("prcMap",prcMap);
			
			model.put("procModelID",modelID);
			model.put("instanceNo", instanceNo);
			model.put("instanceClass", instanceClass);
	        model.put("nodeID", processID);
//	        model.put("elmTreeXml", getTestObjectXML(modelMap,GRList,languageID,instanceNo));
	        
	        modelMap.put("itemName", "<img src='"+GlobalVal.HTML_IMG_DIR_ITEM+"/img_sitemap.png' />"+modelMap.get("ModelName")+"("+modelMap.get("MCName")+")");
			modelMap.put("id", "1");
			
	        list.add(modelMap);
	        
	        //----------------------------------
	        
	        for (int i = 0; i < GRList.size(); i++){
	        	Map map = (Map) GRList.get(i);
	        	map.put("parent", "1");
				map.put("id", StringUtil.checkNull(map.get("ElmItemID")));
				
				String elmID = StringUtil.checkNull(map.get("ElmItemID"));					
				setMap.put("s_itemID", elmID);
				Map grInfo = commonService.select("item_SQL.getObjectInfo", setMap);
				
				map.put("itemName", "<img src='"+GlobalVal.HTML_IMG_DIR_ITEM+"/"+StringUtil.checkNull(grInfo.get("ItemTypeImg"))+"' />"+StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("Identifier"))) +" "+ StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("elmItemName"))));
				map.put("Path", StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(grInfo.get("Path"))));
				map.put("button", StringUtil.checkNull(map.get("ElmInstNo")));
				
				list.add(map);
				
				setMap.put("gubun", "M");
				setMap.put("srType", "TCP");
				setMap.put("getPathYN", "Y");
				List subItemList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
				if(subItemList.size() > 0){
					for(int j=0; j<subItemList.size(); j++){
						Map subItemMap = (HashMap) subItemList.get(j);
						
						setMap.put("s_itemID", subItemMap.get("ItemID"));
						setMap.put("cxnTypeCode","CN00004");
						setMap.put("List", "Y");
						setMap.put("testCase", "Y");
						setMap.put("procInstNo",instanceNo);
						setMap.put("mainClassCode","CL04005");
						List cxnList = commonService.selectList("item_SQL.getCxnItemList", setMap);
						if(cxnList.size() > 0){							
							setMap.put("instanceNo", instanceNo);
							setMap.remove("elmInstNo");
							setMap.put("elmItemID", StringUtil.checkNull(subItemMap.get("ItemID")));
							Map instRoleMap = commonService.select("instance_SQL.getElmInstList_gridList", setMap);
							
							subItemMap.put("parent", StringUtil.checkNull(map.get("ElmItemID")));
							subItemMap.put("id", StringUtil.checkNull(subItemMap.get("ItemID")));
							subItemMap.put("itemName", "<img src='"+GlobalVal.HTML_IMG_DIR_ITEM+"/"+StringUtil.checkNull(subItemMap.get("ItemTypeImg"))+"' />"+StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(subItemMap.get("Identifier"))) +" "+ StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(subItemMap.get("ItemName"))));
							subItemMap.put("Path", StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(subItemMap.get("ToItemPath"))));
							subItemMap.put("roleName", StringUtil.checkNull(instRoleMap.get("roleName")));
							list.add(subItemMap);
							
							for(int k=0; k<cxnList.size(); k++){
								Map cxnMap = (HashMap) cxnList.get(k);
								String elmInstNo = StringUtil.checkNull(cxnMap.get("ElmInstNo"));
								
								setMap.put("itemID", StringUtil.checkNull(cxnMap.get("ItemID"),""));
								setMap.put("itemClassCode", "CL04005");
								List linkList = commonService.selectList("link_SQL.getLinkListFromAttAlloc", setMap);
								String linkUrl = "";
								String lovCode = "";
								String attrTypeCode = "";
								String linkImg = "blank.png";
								
								if(linkList.size() > 0){
									Map linkInfo = (Map)linkList.get(0);
									linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
									lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
									attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
									if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
								}
								
								setMap.put("instanceNo", instanceNo);
								setMap.put("elmInstNo", elmInstNo);
								setMap.remove("elmItemID");
								setMap.remove("grInstNo");
											
								Map ElmInstMap = commonService.select("instance_SQL.getElmInstList_gridList", setMap);
								String Status = StringUtil.checkNull(ElmInstMap.get("Status"));
								
								setMap.put("Category", "INSTSTS");
								setMap.put("TypeCode", Status);
								setMap.put("LanguageID", languageID);
								Map nameByDic = commonService.select("common_SQL.label_commonSelect", setMap);
								
								String statusStyle = "style='color:#000000;'";
								if(Status.equals("WAT")) statusStyle = "style='color:orange;font-weight:bold'";
								if(Status.equals("RDY")) statusStyle = "style='color:green;font-weight:bold'";
								if(Status.equals("OPN")) statusStyle = "style='color:blue;font-weight:bold'";
								
								setMap.put("instanceNo", elmInstNo);
								setMap.put("attrTypeCode", "AT00402");
								String AT00402 = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstAttrValue", setMap),"");
								
								String AT00402Style = "gray";
								if(AT00402.equals("LV40201")) AT00402Style = "blue";
								if(AT00402.equals("LV40202")) AT00402Style = "red";
								
								cxnMap.put("parent", StringUtil.checkNull(subItemMap.get("ItemID")));
								cxnMap.put("id", elmInstNo);
								cxnMap.put("itemName", "<img src='"+GlobalVal.HTML_IMG_DIR_ITEM+"/"+StringUtil.checkNull(cxnMap.get("ClassIcon"))+"' />"+StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(cxnMap.get("Identifier"))) +" "+ StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(cxnMap.get("ItemName"))));
								cxnMap.put("Path", StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(cxnMap.get("ItemPath"))));
								cxnMap.put("roleName", StringUtil.checkNull(ElmInstMap.get("actorName")));
								cxnMap.put("linkImg", linkImg);
								cxnMap.put("linkUrl", linkUrl);
								cxnMap.put("lovCode", lovCode);
								cxnMap.put("attrTypeCode", attrTypeCode);
								cxnMap.put("statusName", "<span "+statusStyle+">"+StringUtil.checkNull(nameByDic.get("LABEL_NM"))+"</span>");
								cxnMap.put("AT00402Style", AT00402Style);
								cxnMap.put("testDate", StringUtil.checkNull(ElmInstMap.get("endTime")));
								cxnMap.put("CxnItemID", StringUtil.checkNull(cxnMap.get("ItemID")));
								list.add(cxnMap);
							}
						}
					}
				}
	        }
	        
	        // ----------------------------------
	        
	        model.put("procInstNo", instanceNo);
	        
	        JSONArray treeGridData = new JSONArray(list);
			model.put("treeGridData",treeGridData);
	        
	        model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);		
	}
    
    @RequestMapping(value = "/createTestObject.do")
	public String createTestObject(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			HashMap setMap = new HashMap();
			HashMap insertElmInstData = new HashMap();
			
			String[] checkElmts = StringUtil.checkNull(request.getParameter("checkElmts")).split(",");

			String modelID = StringUtil.checkNull(request.getParameter("modelList"));
			String procInstNo = StringUtil.checkNull(request.getParameter("instanceNo"));
			
			String loginUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String loginTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
			setMap.put("languageID", languageID);
			setMap.put("procInstNo", procInstNo);
			
			Map procInfo = commonService.select("instance_SQL.getProcInstList_gridList", setMap);
			Calendar cal = Calendar.getInstance();
			DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
			
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			
			setMap.put("ModelID",modelID);
			setMap.put("categoryCode","OJ");
			setMap.put("orderBySeq","Y");
			
			List elmList = commonService.selectList("report_SQL.getElementOfModel", setMap);
			
			insertElmInstData.put("ProcInstNo", procInstNo);
			if(modelID != null && modelID != "") {
				if(elmList != null && !elmList.isEmpty()) {
					String maxElmInstID = "";
					for(int i=0; i<elmList.size(); i++) {
						Map tempMap = (Map)elmList.get(i);
						String objectID = StringUtil.checkNull(tempMap.get("ObjectID"));
						for(int j=0; j<checkElmts.length; j++) {
							String programID = checkElmts[j].split("_")[0];
							String itemID = checkElmts[j].split("_")[1];
							String parentID = checkElmts[j].split("_")[2];
							String roleID = checkElmts[j].split("_")[3];
							if(objectID.equals(parentID)) {
								Date instStartTime = dateFormat.parse((String) procInfo.get("StartDate"));
								cal.setTime(instStartTime);
								
								// parent - Create Elm Inst 
								setMap.put("elmItemID", parentID);
								Map existElm = commonService.select("instance_SQL.getProcInstList_gridList", setMap);
								if(existElm.isEmpty()) {	//create
									maxElmInstID = commonService.selectString("instance_SQL.maxElmInstNo", setMap).trim();
									maxElmInstID = maxElmInstID.substring(maxElmInstID.length() - 5, maxElmInstID.length());
									int maxcode = Integer.parseInt(maxElmInstID) + 1;
									String newElmInstID = "E" + String.format("%09d", maxcode);
									
									insertElmInstData.put("elmItemID", parentID);
									insertElmInstData.put("creator", loginUserID);
									
									insertElmInstData.put("newElmInstID", newElmInstID);
									insertElmInstData.put("sortNum", tempMap.get("SortNum"));
									insertElmInstData.remove("programID");
									insertElmInstData.remove("grInstNo");
									
									setMap.put("AttrTypeCode", "AT01006");
									setMap.put("Editable", "1");
									setMap.remove("Mandatory");
									Map AT01006 = commonService.select("attr_SQL.getItemAttrMain", setMap);
									String startInterval = StringUtil.checkNull(AT01006.get("PlainText"),"0");
									if(startInterval.isEmpty()) startInterval = "0";
									cal.add(Calendar.DATE, Integer.parseInt(startInterval));
									insertElmInstData.put("SchStartDate",dateFormat.format(cal.getTime()));
									
									insertElmInstData.put("elementID",tempMap.get("ElementID"));
									insertElmInstData.remove("roleID");
									insertElmInstData.remove("useCaseID");
									
									// changesetID
									setMap.put("itemID",parentID);
									String changesetID = commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap);
									insertElmInstData.put("changesetID",changesetID);
									
									insertElmInstData.put("elmModelID",commonService.selectString("model_SQL.getModelIDFromItem",setMap));
									
									insertElmInstData.put("elmTypeCode","PTC");
									insertElmInstData.put("status", "WAT");
									commonService.insert("instance_SQL.insertElmInst", insertElmInstData);
									
									insertElmInstData.put("instanceNo", newElmInstID);
									insertElmInstData.put("instanceClass", "ELM");
									insertElmInstData.put("itemID", parentID);
									insertElmInstData.put("regTeamID", loginTeamID);
									insertElmInstData.put("regUserID", loginUserID);	
									insertElmInstData.put("lastUserTeamID", loginTeamID);
									insertElmInstData.put("lastUser", loginUserID);
									
									setMap.put("Mandatory", 1);
									setMap.put("s_itemID", parentID);
									setMap.remove("AttrTypeCode");
									// Mandatory Attr List
									List manAttrList = commonService.selectList("attr_SQL.getItemAttrMain", setMap);
									for(int k=0; k<manAttrList.size(); k++) {
										Map manAttr = (Map) manAttrList.get(k);
										insertElmInstData.put("attrTypeCode",  manAttr.get("AttrTypeCode"));
										insertElmInstData.put("value",  StringEscapeUtils.escapeHtml4(StringUtil.checkNull(manAttr.get("PlainText"))));
										commonService.insert("instance_SQL.insertInstanceAttr", insertElmInstData);
									}
									
									insertElmInstData.put("grInstNo",newElmInstID);
									
									String pItemAuthor = commonService.selectString("item_SQL.getItemAuthorId",setMap);
									setMap.put("sessionUserId", pItemAuthor);
									String workerTeamID = commonService.selectString("user_SQL.userTeamID",setMap);
									
									insertElmInstData.put("workerNo",NextWokerNo());
									insertElmInstData.put("memberID",pItemAuthor);
									insertElmInstData.put("workerTeamID",workerTeamID);
									insertElmInstData.put("procInstNo",procInstNo);
									insertElmInstData.put("elmInstNo",newElmInstID);
									insertElmInstData.put("status","1");
									insertElmInstData.put("Creator",loginUserID);
									insertElmInstData.put("LastUser",loginUserID);
									commonService.insert("worker_SQL.createPimWorker",insertElmInstData);
								} else {
									insertElmInstData.put("grInstNo",existElm.get("ElmInstNo"));
								}

								insertElmInstData.put("status", "WAT");
								
								maxElmInstID = commonService.selectString("instance_SQL.maxElmInstNo", setMap).trim();
								maxElmInstID = maxElmInstID.substring(maxElmInstID.length() - 5, maxElmInstID.length());
								int maxcode = Integer.parseInt(maxElmInstID) + 1;
								String newElmInstID = "E" + String.format("%09d", maxcode);

								setMap.put("languageID", languageID);
								setMap.put("s_itemID", itemID);
								setMap.put("defaultLang", defaultLang);
								
								insertElmInstData.remove("roleID");
								insertElmInstData.put("elmItemID", itemID);
								insertElmInstData.put("creator", loginUserID);
								
								insertElmInstData.put("newElmInstID", newElmInstID);
								insertElmInstData.remove("sortNum");
								insertElmInstData.put("programID",programID);
								

								insertElmInstData.put("roleID",roleID);
								
								setMap.put("ItemTypeCode", "CN00201");
								setMap.put("FromItemID", roleID);
								setMap.put("ToItemID", itemID);
								setMap.put("deleted", "1");
								String useCaseID = commonService.selectString("item_SQL.getConItemID", setMap);
								insertElmInstData.put("useCaseID",useCaseID);
								
								setMap.put("AttrTypeCode", "AT01006");
								setMap.put("Editable", "1");
								setMap.remove("Mandatory");
								Map AT01006 = commonService.select("attr_SQL.getItemAttrMain", setMap);
								String startInterval = StringUtil.checkNull(AT01006.get("PlainText"),"0");
								if(startInterval.isEmpty()) startInterval = "0";
								cal.add(Calendar.DATE, Integer.parseInt(startInterval));
								insertElmInstData.put("SchStartDate",dateFormat.format(cal.getTime()));
								
								insertElmInstData.remove("elementID");
								
								// changesetID
								setMap.put("itemID",itemID);
								String changesetID = commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setMap);
								insertElmInstData.put("changesetID",changesetID);
								
								setMap.put("itemID",parentID);
								insertElmInstData.put("elmModelID",commonService.selectString("model_SQL.getModelIDFromItem",setMap));
								
								insertElmInstData.put("elmTypeCode","ATC");
								insertElmInstData.remove("elmTypeCode");
								commonService.insert("instance_SQL.insertElmInst", insertElmInstData);
								
								insertElmInstData.put("instanceNo", newElmInstID);
								insertElmInstData.put("instanceClass", "ELM");
								insertElmInstData.put("itemID", itemID);
								insertElmInstData.put("regTeamID", loginTeamID);
								insertElmInstData.put("regUserID", loginUserID);	
								insertElmInstData.put("lastUserTeamID", loginTeamID);
								insertElmInstData.put("lastUser", loginUserID);
								
								setMap.put("Mandatory", 1);
								setMap.put("s_itemID", itemID);
								setMap.remove("AttrTypeCode");
								// Mandatory Attr List
								List manAttrList = commonService.selectList("attr_SQL.getItemAttrMain", setMap);
								for(int k=0; k<manAttrList.size(); k++) {
									Map manAttr = (Map) manAttrList.get(k);
									insertElmInstData.put("attrTypeCode",  manAttr.get("AttrTypeCode"));
									insertElmInstData.put("value",  StringEscapeUtils.escapeHtml4(StringUtil.checkNull(manAttr.get("PlainText"))));
									commonService.insert("instance_SQL.insertInstanceAttr", insertElmInstData);
								}
								setMap.remove("Mandatory");
								
								insertElmInstData.put("attrTypeCode",  "AT00401");
								insertElmInstData.put("value", "");
								commonService.insert("instance_SQL.insertInstanceAttr", insertElmInstData);
								
								insertElmInstData.put("attrTypeCode",  "AT00402");
								insertElmInstData.put("value", "");
								commonService.insert("instance_SQL.insertInstanceAttr", insertElmInstData);
								
								String itemAuthor = commonService.selectString("item_SQL.getItemAuthorId",setMap);
								setMap.put("sessionUserId", itemAuthor);
								String workerTeamID = commonService.selectString("user_SQL.userTeamID",setMap);
								
								insertElmInstData.put("workerNo",NextWokerNo());
								insertElmInstData.put("memberID",itemAuthor);
								insertElmInstData.put("workerTeamID",workerTeamID);
								insertElmInstData.put("procInstNo",procInstNo);
								insertElmInstData.put("elmInstNo",newElmInstID);
								insertElmInstData.put("roleID",roleID);
								insertElmInstData.put("status","1");
								insertElmInstData.put("Creator",loginUserID);
								insertElmInstData.put("LastUser",loginUserID);
								commonService.insert("worker_SQL.createPimWorker",insertElmInstData);
							}
						}
					}
					
					insertElmInstData.put("status","OPN");
					commonService.update("instance_SQL.updateInstanceGridData", insertElmInstData);
				}
			}else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 저장 성공
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT,"parent.fnCallBackSubmit();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
    
    public String NextWokerNo() throws Exception {
		Map setMap = new HashMap();
		String maxWorkNo = commonService.selectString("worker_SQL.maxWorkerNo", setMap).trim();
		maxWorkNo = maxWorkNo.substring(maxWorkNo.length() - 5, maxWorkNo.length());
		int maxcode = Integer.parseInt(maxWorkNo) + 1;
		String newMaxWorkNo = "W" + String.format("%09d", maxcode);
		return newMaxWorkNo;
	}
    
    private String getTestObjectXML(Map modelMap,List GRList, String languageID,String procInstNo) throws Exception {
		Map setMap = new HashMap();
		List subItemList = new ArrayList();
//			String ModelID= "";
		String ModelName= "";
		
		String CELL = "	<cell></cell>";
		String CELL_CHECK = "	<cell>0</cell>";
		String CELL_OPEN = "	<cell>";
		String CELL_CLOSE = "</cell>";
		String ROW_CLOSE = "</row>";
		
		// row ID 를 unique 하게 설정 하기 위한 seq
		String result = "";
		String resultRow = "";
		if (GRList.size() > 0) {
//				ModelID = StringUtil.checkNull(modelMap.get("ModelID"),"");
			ModelName = (StringUtil.checkNull(modelMap.get("ModelName"))).replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ");	
			
//				setMap.put("modelID",ModelID);
			setMap.put("languageID", languageID);
			
			result += "<rows>";
			result += "<row id='1' open='1'>";
			result += CELL_CHECK;
			result += "	<cell image='img_sitemap.png' style='font-weight:bold;text-align: left;'> " + ModelName.replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ")
					+"("+modelMap.get("MCName")+")"+ "</cell>";
			
			for (int i = 0; i < GRList.size(); i++){
				Map map = (Map) GRList.get(i);
				String elmID = StringUtil.checkNull(map.get("ElmItemID"));					
				setMap.put("s_itemID", elmID);
				Map grInfo = commonService.select("item_SQL.getObjectInfo", setMap);
				
				resultRow += "<row open='1' id='" + StringUtil.checkNull(map.get("ElmItemID")) + "'>";
				resultRow += CELL_CHECK;
				resultRow += "	<cell image='" + StringUtil.checkNull(grInfo.get("ItemTypeImg"))+ "'> " + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("Identifier"))) +" "+ StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("elmItemName"))) + CELL_CLOSE;
				resultRow += CELL_OPEN + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(grInfo.get("Path"))) + CELL_CLOSE;
				resultRow += CELL;
				resultRow += CELL_OPEN + "blank.png" + CELL_CLOSE;
				resultRow += CELL;
				resultRow += CELL;
				resultRow += CELL;
				resultRow += CELL;
				resultRow += CELL;
				resultRow += CELL;
				resultRow += CELL;
				resultRow += CELL_OPEN +"<![CDATA[ <button type=button class=gridBtn onclick=fnViewTODetail('"+procInstNo+"','"+StringUtil.checkNull(map.get("ElmInstNo"))+"');>Info</button> ]]>" + CELL_CLOSE;
				
				setMap.put("gubun", "M");
				setMap.put("srType", "TCP");
				setMap.put("getPathYN", "Y");
				subItemList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
				if(subItemList.size() > 0){
					for(int j=0; j<subItemList.size(); j++){
						Map subItemMap = (HashMap) subItemList.get(j);
													
						setMap.put("s_itemID", subItemMap.get("ItemID"));
						setMap.put("cxnTypeCode","CN00004");
						setMap.put("List", "Y");
						setMap.put("testCase", "Y");
						setMap.put("procInstNo",procInstNo);
						setMap.put("mainClassCode","CL04005");
						List cxnList = commonService.selectList("item_SQL.getCxnItemList", setMap);
						if(cxnList.size() > 0){							
							setMap.put("instanceNo", procInstNo);
							setMap.remove("elmInstNo");
							setMap.put("elmItemID", StringUtil.checkNull(subItemMap.get("ItemID")));
							Map instRoleMap = commonService.select("instance_SQL.getElmInstList_gridList", setMap);
							
							resultRow += "<row open='1' id='" + StringUtil.checkNull(subItemMap.get("ItemID")) + "'>";
							resultRow += CELL_CHECK;
							resultRow += "	<cell image='" + StringUtil.checkNull(subItemMap.get("ItemTypeImg"))+ "'> " + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(subItemMap.get("Identifier"))) +" "+StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(subItemMap.get("ItemName")))+ CELL_CLOSE;
							resultRow += CELL_OPEN +StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(subItemMap.get("ToItemPath"))) + CELL_CLOSE;
							resultRow += CELL_OPEN +StringUtil.checkNull(instRoleMap.get("roleName")) + CELL_CLOSE;
							
							for(int k=0; k<cxnList.size(); k++){
								Map cxnMap = (HashMap) cxnList.get(k);
								String elmInstNo = StringUtil.checkNull(cxnMap.get("ElmInstNo"));
								
								setMap.put("itemID", StringUtil.checkNull(cxnMap.get("ItemID"),""));
								setMap.put("itemClassCode", "CL04005");
								List linkList = commonService.selectList("link_SQL.getLinkListFromAttAlloc", setMap);
								String linkUrl = "";
								String lovCode = "";
								String attrTypeCode = "";
								String linkImg = "blank.png";
								
								if(linkList.size() > 0){
									Map linkInfo = (Map)linkList.get(0);
									linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
									lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
									attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
									if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
								}
								
								setMap.put("instanceNo", procInstNo);
								setMap.put("elmInstNo", elmInstNo);
								setMap.remove("elmItemID");
											
								Map ElmInstMap = commonService.select("instance_SQL.getElmInstList_gridList", setMap);
								String Status = StringUtil.checkNull(ElmInstMap.get("Status"));
								
								setMap.put("Category", "INSTSTS");
								setMap.put("TypeCode", Status);
								setMap.put("LanguageID", languageID);
								Map nameByDic = commonService.select("common_SQL.label_commonSelect", setMap);
								
								String statusStyle = "style='color:#000000;'";
								if(Status.equals("WAT")) statusStyle = "style='color:orange;font-weight:bold'";
								if(Status.equals("RDY")) statusStyle = "style='color:green;font-weight:bold'";
								if(Status.equals("OPN")) statusStyle = "style='color:blue;font-weight:bold'";
								
								setMap.put("instanceNo", elmInstNo);
								setMap.put("attrTypeCode", "AT00402");
								String AT00402 = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstAttrValue", setMap),"");
								
								String AT00402Style = "gray";
								if(AT00402.equals("LV40201")) AT00402Style = "blue";
								if(AT00402.equals("LV40202")) AT00402Style = "red";
								
								resultRow += "<row open='1' id='" + elmInstNo + "'>";
								resultRow += CELL_CHECK;
								resultRow += "	<cell image='" + StringUtil.checkNull(cxnMap.get("ClassIcon"))+ "'> " +StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(cxnMap.get("Identifier"))) +" "+StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(cxnMap.get("ItemName")))+CELL_CLOSE;
								resultRow += CELL_OPEN +StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(cxnMap.get("ItemPath"))) + CELL_CLOSE;
								resultRow += CELL_OPEN +StringUtil.checkNull(ElmInstMap.get("actorName")) + CELL_CLOSE;
								resultRow += CELL_OPEN + linkImg + CELL_CLOSE;
								resultRow += CELL_OPEN +StringUtil.checkNull(cxnMap.get("ItemID")) + CELL_CLOSE;
								resultRow += CELL_OPEN + linkUrl + CELL_CLOSE;
								resultRow += CELL_OPEN + lovCode + CELL_CLOSE;
								resultRow += CELL_OPEN + attrTypeCode +  CELL_CLOSE;
								resultRow += "<cell "+statusStyle+">" +StringUtil.checkNull(nameByDic.get("LABEL_NM")) + CELL_CLOSE;
								resultRow += CELL_OPEN + AT00402Style + CELL_CLOSE;
								resultRow += CELL_OPEN +StringUtil.checkNull(ElmInstMap.get("endTime")) + CELL_CLOSE;

								resultRow += ROW_CLOSE;
							}
							resultRow += ROW_CLOSE;
						}
					}
					resultRow += ROW_CLOSE;
				}
				
				
			}
	
			result += resultRow;
			result += "</row>";
			result += "</rows>";
		}
		return result.replace("&", "/"); // 특수 문자 제거
	}
    
    @RequestMapping(value="/viewTODetail.do")
	public String viewTODetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String url= "/app/pim/instance/tc/viewTODetail";
		
		try {			
			String archiCode = StringUtil.checkNull(cmmMap.get("option"),"");
			String ProcInstNo = StringUtil.checkNull(cmmMap.get("procInstNo"));
			String elmInstNo = StringUtil.checkNull(cmmMap.get("elmInstNo"));	
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String testCase = StringUtil.checkNull(cmmMap.get("testCase"));
		//	String instanceClass = StringUtil.checkNull(cmmMap.get("instanceClass"));
			
			Map setData = new HashMap();
			setData.put("instanceClass", "ELM");
			setData.put("languageID", languageID);
			setData.put("instanceNo", ProcInstNo);
			setData.put("elmInstNo", elmInstNo);
			setData.put("testCase", testCase);
						
			Map ElmInstMap = commonService.select("instance_SQL.getElmInstList_gridList", setData);
			model.put("ElmInstInfo", ElmInstMap);
			
			String elmItemID = StringUtil.checkNull(ElmInstMap.get("ElmItemID"));
			setData.put("elmInstNo", elmInstNo);
			setData.put("instanceClass", "ELM");
			Map procInstanceInfo = commonService.select("instance_SQL.getProcInstanceInfo", setData);			
			model.put("procInstanceInfo", procInstanceInfo);	
			
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setData);
			/* 속성 */
			Map setMap = new HashMap();
			List returnData = new ArrayList();
			// isComLang = ALL
			setMap.put("itemID", ElmInstMap.get("ElmItemID"));
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("instanceClass", "ELM");
			setMap.put("instanceNo", elmInstNo);
			returnData = (List)commonService.selectList("instance_SQL.getInstanceAttrText", setMap);

			setMap.put("defaultLang", defaultLang);
			setMap.put("s_itemID", procInstanceInfo.get("ProcessID"));
			
			/* 기본정보 내용 취득 */
			Map prcInfo = commonService.select("report_SQL.getItemInfo", setMap);

			setMap.put("s_itemID", ElmInstMap.get("ElmItemID"));
			List relItemList = commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
			//List relItemList = new ArrayList();getRelItemClassList
			List relItemClassList = commonService.selectList("item_SQL.getRelItemClassList", setMap);
			model.put("relItemList", relItemList);
			model.put("relItemClassList", relItemClassList);
			
			/** 관련항목 취득 */
			
			setMap.remove("attrTypeCode");
			
			String className = "";
			List pertinentDetailList = new ArrayList();
			List relItemRowList = new ArrayList();
			String strClassName = "";
			int classNameCnt = 1;
			
			for (int i = 0; i < relItemList.size(); i++) {
				Map pertinentMap = (Map) relItemList.get(i);
				String itemId = pertinentMap.get("s_itemID").toString();
				setMap.put("s_itemID", itemId);
				
				if (null != pertinentMap.get("ClassName")) {
					if (className.isEmpty()) {
						className = pertinentMap.get("ClassName").toString();
						strClassName = className;
						pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
					} else {
						if (className.equals(pertinentMap.get("ClassName").toString())) {
							pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
						} else {
							relItemRowList.add(pertinentDetailList);
							
							className = pertinentMap.get("ClassName").toString();
							classNameCnt++;
							strClassName = strClassName + "," + className;
							
							pertinentDetailList = new ArrayList();
							pertinentDetailList.add(removeAllHtmlTagAndSetAttrInfo(pertinentMap));
						}
					}
				}
				
				if (i == (relItemList.size()- 1)) {
					relItemRowList.add(pertinentDetailList);
				}
				
			}
			
			/** 첨부문서 취득 */
			cmmMap.put("DocumentID", ElmInstMap.get("ElmItemID"));
			cmmMap.put("s_itemID", ElmInstMap.get("ElmItemID"));
			cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			cmmMap.put("isPublic", "N");
			cmmMap.put("DocCategory", "ITM");
			cmmMap.put("hideBlocked", "Y");
			
			List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", cmmMap);
			
			/** 관련문서 취득 */
			List itemList = commonService.selectList("item_SQL.getCxnItemList", cmmMap);
			Map getMap = new HashMap();
			/** 첨부문서 관련문서 합치기, 관련문서 itemClassCodep 할당된 fltpCode 로 filtering */
			String rltdItemId = "";
			for(int i = 0; i < itemList.size(); i++){
				setMap = (HashMap)itemList.get(i);
				getMap.put("ItemID", setMap.get("ItemID"));
				if (i < itemList.size() - 1) {
				   rltdItemId += setMap.get("ItemID").toString()+ ",";
				}else{
					rltdItemId += setMap.get("ItemID").toString();
				}
			}
			cmmMap.remove("DocumentID");
			cmmMap.put("rltdItemId", rltdItemId);
			List pertinentFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", cmmMap);
			
			model.put("attachFileList", attachFileList);
			
			model.put("variantClass", cmmMap.get("variantClass"));
			model.put("masterProjectID", cmmMap.get("masterProjectID"));
			model.put("myProject", cmmMap.get("myProject"));
			model.put("refPGID", cmmMap.get("refPGID"));
			model.put("procInstNo", ProcInstNo);
			model.put("elmInstNo", elmInstNo);
			model.put("instanceClass", "ELM");
			model.put("elmItemID", elmItemID);
			model.put("option", archiCode);
			model.put("level", (String)cmmMap.get("level"));
			model.put("menuText", StringUtil.checkNull(cmmMap.get("menuText")));
			
			model.put("baseAtchUrl",GlobalVal.BASE_ATCH_URL);
			model.put("fromModelYN", StringUtil.checkNull(cmmMap.get("fromModelYN"),""));
			model.put("focusedItemID", StringUtil.checkNull(cmmMap.get("focusedItemID"),""));
			model.put("instanceClass", StringUtil.checkNull(cmmMap.get("instanceClass"),""));
			model.put("menu", getLabel(cmmMap, commonService));
			
			model.put("attributesList", returnData); // 속성
			model.put("relItemRowList", relItemRowList); //관련항목
			model.put("prcInfo", prcInfo);
			model.put("testCase", testCase);
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		
		return nextUrl(url);
	}
    	    
    @RequestMapping(value="/viewTCList.do")
	public String viewTCList(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "/app/pim//instance/tc/viewTCList";
		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String elmItemID = StringUtil.checkNull(request.getParameter("elmItemID"), "");
			String fromModelYN = StringUtil.checkNull(request.getParameter("fromModelYN"), "");
			String procInstNo = StringUtil.checkNull(request.getParameter("instanceNo"), "");
			String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"), "");
			String processID = StringUtil.checkNull(request.getParameter("processID"), "");
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			
			String resultRow = "";
			String CELL_OPEN = "	<cell>";
			String CELL_CLOSE = "</cell>";
			String CELL_CHECK = "	<cell>0</cell>";
			int RNUM = 1;
			String HTML_IMG_DIR = GlobalVal.HTML_IMG_DIR;
			
			setMap.put("languageID", languageID);
			setMap.put("s_itemID", elmItemID);
			setMap.put("gubun", "M");
			setMap.put("srType", "TCP");
			setMap.put("getPathYN", "Y");
			List subItemList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);

			resultRow += "<rows>";
			if(subItemList.size() > 0){
				for(int j=0; j<subItemList.size(); j++){
					Map subItemMap = (HashMap) subItemList.get(j);
					
					setMap.put("s_itemID", subItemMap.get("ItemID"));
					setMap.put("cxnTypeCode","CN00004");
					setMap.put("List", "Y");
					setMap.put("testCase", "Y");
					setMap.put("procInstNo",procInstNo);
					setMap.put("mainClassCode","CL04005");
					List cxnList = commonService.selectList("item_SQL.getCxnItemList", setMap);
					
					if(cxnList.size() > 0){
						setMap.put("defaultLang", defaultLang);
						List activityAttrList = commonService.selectList("attr_SQL.getItemAttr", setMap);
						String AT00008 = "", AT00014 = "", AT00053 = "";
						
						for(int k=0; k<activityAttrList.size(); k++){
							Map activityAttrMap = (HashMap) activityAttrList.get(k);
							if(activityAttrMap.get("AttrTypeCode").equals("AT00008")) AT00008 =  StringUtil.checkNull(activityAttrMap.get("PlainText"));
							if(activityAttrMap.get("AttrTypeCode").equals("AT00014")) AT00014 =  StringUtil.checkNull(activityAttrMap.get("PlainText"));
							if(activityAttrMap.get("AttrTypeCode").equals("AT00053")) AT00053 =  StringUtil.checkNull(activityAttrMap.get("PlainText"));
						}
						
						for(int k=0; k<cxnList.size(); k++){
							Map cxnMap = (HashMap) cxnList.get(k);
							String elmInstNo = StringUtil.checkNull(cxnMap.get("ElmInstNo"));
							
							setMap.put("instanceNo", procInstNo);
							setMap.put("elmInstNo", elmInstNo);
							Map ElmInstMap = commonService.select("instance_SQL.getElmInstList_gridList", setMap);
							
							setMap.put("instanceNo", elmInstNo);
							setMap.put("attrTypeCode", "AT00401");
							String AT00401 = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstAttrValue", setMap),"");
							setMap.put("attrTypeCode", "AT00402");
							String AT00402 = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstAttrValue", setMap),"");
							
							setMap.put("s_itemID", "AT00402");
							List AT00402List = commonService.selectList("attr_SQL.selectAttrLovOption", setMap);
							
							resultRow += "<row id='" + RNUM + "'>";
							resultRow += CELL_OPEN +RNUM +CELL_CLOSE;
							resultRow += CELL_CHECK;
							resultRow += CELL_OPEN +subItemMap.get("ItemName") +"^javascript:fnItemPopUp("+subItemMap.get("ItemID")+");^_self"+CELL_CLOSE;
							resultRow += CELL_OPEN +AT00008+CELL_CLOSE;
							resultRow += CELL_OPEN +AT00014 +CELL_CLOSE;
							resultRow += CELL_OPEN +StringUtil.checkNull(cxnMap.get("Identifier"))+CELL_CLOSE;
							resultRow += CELL_OPEN +StringUtil.checkNull(cxnMap.get("ItemName"))+CELL_CLOSE;
							resultRow += CELL_OPEN +AT00053 +CELL_CLOSE;							
							resultRow += CELL_OPEN +StringUtil.checkNull(ElmInstMap.get("DocumentNo"))+CELL_CLOSE;
							resultRow += CELL_OPEN + StringUtil.checkNull(ElmInstMap.get("actorName")) + CELL_CLOSE;
							resultRow += CELL_OPEN ;
								for(int i=0; i<AT00402List.size(); i++){
									Map AT00402Map = (HashMap) AT00402List.get(i);
									if(AT00402Map.get("CODE").equals(AT00402))
									resultRow += AT00402Map.get("NAME");
								}
							resultRow += CELL_CLOSE;
							resultRow += CELL_OPEN +AT00401+CELL_CLOSE;
							resultRow += CELL_OPEN +"" + CELL_CLOSE;
							resultRow += CELL_OPEN +elmInstNo+ CELL_CLOSE;
							resultRow += "</row>";
							RNUM++;
						}
					}
				}
			}
			resultRow += "</rows>";
			
			model.put("languageID", languageID);
			model.put("elmItemID", elmItemID);
			model.put("fromModelYN", fromModelYN);
			model.put("instanceNo", procInstNo);
			model.put("instanceClass", instanceClass);
			model.put("processID", processID);
	        model.put("testResultXml",resultRow);
	        model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);		
	}
    
    @RequestMapping(value="/editTCList.do")
	public String editTCList(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "/app/pim//instance/tc/editTCList";
		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String elmItemID = StringUtil.checkNull(request.getParameter("elmItemID"), "");
			String fromModelYN = StringUtil.checkNull(request.getParameter("fromModelYN"), "");
			String procInstNo = StringUtil.checkNull(request.getParameter("instanceNo"), "");
			String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"), "");
			String processID = StringUtil.checkNull(request.getParameter("processID"), "");
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			
			String resultRow = "";
			String CELL_OPEN = "	<cell>";
			String CELL_CLOSE = "</cell>";
			String CELL_CHECK = "	<cell>0</cell>";
			int RNUM = 1;
			String HTML_IMG_DIR = GlobalVal.HTML_IMG_DIR;
			
			setMap.put("languageID", languageID);
			setMap.put("s_itemID", elmItemID);
			setMap.put("gubun", "M");
			setMap.put("srType", "TCP");
			setMap.put("getPathYN", "Y");
			List subItemList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);

			resultRow += "<rows>";
			if(subItemList.size() > 0){
				for(int j=0; j<subItemList.size(); j++){
					Map subItemMap = (HashMap) subItemList.get(j);
					
					setMap.put("s_itemID", subItemMap.get("ItemID"));
					setMap.put("cxnTypeCode","CN00004");
					setMap.put("List", "Y");
					setMap.put("testCase", "Y");
					setMap.put("procInstNo",procInstNo);
					setMap.put("mainClassCode","CL04005");
					List cxnList = commonService.selectList("item_SQL.getCxnItemList", setMap);
					
					if(cxnList.size() > 0){
						setMap.put("defaultLang", defaultLang);
						List activityAttrList = commonService.selectList("attr_SQL.getItemAttr", setMap);
						String AT00008 = "", AT00014 = "", AT00053 = "";
						
						for(int k=0; k<activityAttrList.size(); k++){
							Map activityAttrMap = (HashMap) activityAttrList.get(k);
							if(activityAttrMap.get("AttrTypeCode").equals("AT00008")) AT00008 =  StringUtil.checkNull(activityAttrMap.get("PlainText"));
							if(activityAttrMap.get("AttrTypeCode").equals("AT00014")) AT00014 =  StringUtil.checkNull(activityAttrMap.get("PlainText"));
							if(activityAttrMap.get("AttrTypeCode").equals("AT00053")) AT00053 =  StringUtil.checkNull(activityAttrMap.get("PlainText"));
						}
						
						for(int k=0; k<cxnList.size(); k++){
							Map cxnMap = (HashMap) cxnList.get(k);
							String elmInstNo = StringUtil.checkNull(cxnMap.get("ElmInstNo"));
							
							setMap.put("instanceNo", procInstNo);
							setMap.put("elmInstNo", elmInstNo);
							Map ElmInstMap = commonService.select("instance_SQL.getElmInstList_gridList", setMap);
							
							setMap.put("instanceNo", elmInstNo);
							setMap.put("attrTypeCode", "AT00401");
							String AT00401 = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstAttrValue", setMap),"");
							setMap.put("attrTypeCode", "AT00402");
							String AT00402 = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstAttrValue", setMap),"");
							
							setMap.put("s_itemID", "AT00402");
							List AT00402List = commonService.selectList("attr_SQL.selectAttrLovOption", setMap);
							
							resultRow += "<row id='" + RNUM + "'>";
							resultRow += CELL_OPEN +RNUM +CELL_CLOSE;
							resultRow += CELL_CHECK;
							resultRow += CELL_OPEN +subItemMap.get("ItemName") +CELL_CLOSE;
							resultRow += CELL_OPEN +AT00008+CELL_CLOSE;
							resultRow += CELL_OPEN +AT00014 +CELL_CLOSE;
							resultRow += CELL_OPEN +StringUtil.checkNull(cxnMap.get("Identifier"))+CELL_CLOSE;
							resultRow += CELL_OPEN +StringUtil.checkNull(cxnMap.get("ItemName"))+CELL_CLOSE;
							resultRow += CELL_OPEN +AT00053 +CELL_CLOSE;							
							resultRow += CELL_OPEN +"<![CDATA[ <input type='text' class='stext' classs='documentNo' id='documentNo_"+RNUM+"' name='documentNo_"+RNUM+"' value='"+StringUtil.checkNull(ElmInstMap.get("DocumentNo"))+"'/>]]>"+CELL_CLOSE;
							resultRow += CELL_OPEN 
							+ "<![CDATA["
							+ "<input type='text' class='elmInstActor stext' id='actorName_"+RNUM+"' name='actorName_"+RNUM+"' value='"+StringUtil.checkNull(ElmInstMap.get("actorName"))+"' style='width:calc(100% - 22px);'  readonly/>"
							+ "<input type='image' class='image' src='/"+HTML_IMG_DIR+"/btn_icon_search.png' onclick=fnAssignActor('"+RNUM+"') value='Edit' />"
							+ "<input type='hidden' class='elmInstActor' name='actorID_"+RNUM+"' id='actorID_"+RNUM+"' value='"+StringUtil.checkNull(ElmInstMap.get("actorID"))+"'/>"
							+ " ]]>"+ CELL_CLOSE;
							resultRow += CELL_OPEN +"<![CDATA[ <select class='AT00402' id='AT00402_"+RNUM+"' name='AT00402_"+RNUM+"' ><option value>select</option>";
								for(int i=0; i<AT00402List.size(); i++){
									Map AT00402Map = (HashMap) AT00402List.get(i);
									resultRow += "<option value='"+AT00402Map.get("CODE")+"' ";
									if(AT00402Map.get("CODE").equals(AT00402)) resultRow += "selected";
									resultRow += ">"+AT00402Map.get("NAME")+"</option>";
								}
							resultRow += "</select>]]>" + CELL_CLOSE;
							resultRow += CELL_OPEN +"<![CDATA[ <input type='text' class='stext' classs='AT00401' id='AT00401_"+RNUM+"' name='AT00401_"+RNUM+"' value='"+AT00401+"'/>]]>"+CELL_CLOSE;
							resultRow += CELL_OPEN +"" + CELL_CLOSE;
							resultRow += CELL_OPEN +elmInstNo+ CELL_CLOSE;
							resultRow += CELL_OPEN +"<![CDATA[ <input type='hidden' class='stext' id='roleID_"+RNUM+"' name='roleID_"+RNUM+"' value='"+StringUtil.checkNull(ElmInstMap.get("RoleID"))+"'/>]]>"+CELL_CLOSE;
							resultRow += "</row>";
							RNUM++;
						}
					}
				}
			}
			resultRow += "</rows>";
			
			model.put("languageID", languageID);
			model.put("elmItemID", elmItemID);
			model.put("fromModelYN", fromModelYN);
			model.put("instanceNo", procInstNo);
			model.put("instanceClass", instanceClass);
			model.put("processID", processID);
	        model.put("testResultXml",resultRow);
	        model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);		
	}
    

    @RequestMapping(value="/selectTestObject.do")
	public String selectTestObject(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		List elmList = new ArrayList();
		Map setMap = new HashMap();
		try {
			String modelID = StringUtil.checkNull(request.getParameter("modelID"), "");
			String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"), "");
			String processID = StringUtil.checkNull(request.getParameter("processID"), "");
			String searchValue = StringUtil.checkNull(request.getParameter("searchValue"), "");
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			setMap.put("languageID", languageID);
			setMap.put("ItemID", processID);
			setMap.put("modelID", modelID);
			setMap.put("attrTypeCode", "AT00036");

			setMap.put("ModelID", modelID);
			Map modelMap = commonService.select("model_SQL.getModelViewer", setMap);
			
//			Map attrMap = commonService.select("attr_SQL.getItemAttrText", setMap);
//			String procType = StringUtil.checkNull(attrMap.get("PlainText"));
			
			setMap.put("itemTypeCode", "OJ00001");
			setMap.put("srType", "TCP");
			elmList = (List) commonService.selectList("model_SQL.getElementItemList_gridList", setMap);
			List objectIDs = new ArrayList();
			
//			for(int i = 0; i<elmList.size(); i++) {
//				Map map = (Map) elmList.get(i);
//				if(procType.equals(map.get("ProcType"))) {
//					if(!objectIDs.contains(map.get("ItemID")))	
//						objectIDs.add(map.get("ItemID"));
//				}
//			}
			
			model.put("modelID",modelID);
			model.put("instanceNo",instanceNo);
			model.put("processID",processID);
			model.put("searchValue",searchValue);
			model.put("elmTreeXml",setTestObjectXML(modelMap,elmList,languageID,instanceNo,searchValue));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		}		
		catch (Exception e) {System.out.println(e);throw new ExceptionUtil(e.toString());}		
		return nextUrl("/app/pim/instance/tc/selectTestObject");
	}
	
	private String setTestObjectXML(Map modelMap,List elmList, String languageID,String procInstNo, String searchValue) throws Exception {
		Map setMap = new HashMap();
		List subItemList = new ArrayList();
		String ModelID= "";
		String ModelName= "";
		String statusStyle = "style='color:#000000;'";
		
		String CELL = "	<cell></cell>";
		String CELL_CHECK = "	<cell>0</cell>";
		String CELL_OPEN = "	<cell>";
		String CELL_CLOSE = "</cell>";
		String CLOSE = ">";
		String CELL_TOT = "";
		String ROW_OPEN = "<row id=";
		String ROW_CLOSE = "</row>";
		int rowCnt = 2;
		
		// row ID 를 unique 하게 설정 하기 위한 seq
		int rowId = 0;
		String result = "";
		String resultRow = "";
		if (elmList.size() > 0) {
			ModelID = StringUtil.checkNull(modelMap.get("ModelID"),"");
			ModelName = (StringUtil.checkNull(modelMap.get("ModelName"))).replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ");	
			
			setMap.put("modelID",ModelID);
			setMap.put("languageID", languageID);
			
			result += "<rows>";
			result += "<row id='1' open='1'>";
			result += CELL_CHECK;
			result += "	<cell image='img_sitemap.png' style='font-weight:bold;text-align: left;'> " + ModelName.replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ")
					+"("+modelMap.get("MCName")+")"+ "</cell>";
			
			for (int i = 0; i < elmList.size(); i++){
				Map map = (Map) elmList.get(i);
				String elmID = StringUtil.checkNull(map.get("ItemID"));
				setMap.put("s_itemID",elmID);
				
				setMap.put("s_itemID", elmID);
				setMap.put("gubun", "M");
				setMap.put("srType", "TCP");
				setMap.put("getPathYN", "Y");
				subItemList = commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
				if(subItemList.size() > 0){
					for(int j=0; j<subItemList.size(); j++){
						Map subItemMap = (HashMap) subItemList.get(j);
													
						setMap.put("s_itemID", subItemMap.get("ItemID"));
						setMap.put("cxnTypeCode","CN00004");
						setMap.put("Copy", "Y");
						setMap.put("testCase", "Y");
						setMap.put("procInstNo",procInstNo);
						setMap.put("searchValue",searchValue);
						setMap.put("mainClassCode","CL04005");
						List cxnList = commonService.selectList("item_SQL.getCxnItemList", setMap);
						if(cxnList.size() > 0){

							setMap.put("cxnTypeCode","CN00002");
							setMap.remove("mainClassCode");
							Map roleMap = commonService.select("item_SQL.getCxnItemList", setMap);
							
							resultRow += "<row open='1' id='" + StringUtil.checkNull(map.get("ItemID")) + "' style='background: #dbecff;'>";
							resultRow += CELL_CHECK;
							resultRow += "	<cell image='" + StringUtil.checkNull(map.get("ItemTypeImg"))+ "'> " + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("Identifier"))) +" "+ StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("ItemName"))) + CELL_CLOSE;
							resultRow += CELL_OPEN + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("Path"))) + CELL_CLOSE;
							resultRow += CELL;
							resultRow += CELL;
							resultRow += CELL;
							resultRow += CELL;
							resultRow += CELL;
							
							resultRow += "<row open='1' id='" + StringUtil.checkNull(subItemMap.get("ItemID")) + "' style='background: #eff6ff;'>";
							resultRow += CELL_CHECK;
							resultRow += "	<cell image='" + StringUtil.checkNull(subItemMap.get("ItemTypeImg"))+ "'> " + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(subItemMap.get("Identifier"))) +" "+StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(subItemMap.get("ItemName")))+ CELL_CLOSE;
							resultRow += CELL_OPEN +StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(StringUtil.checkNull(subItemMap.get("ToItemPath")))) + CELL_CLOSE;
							resultRow += CELL;
							resultRow += CELL;
							resultRow += CELL;
							resultRow += CELL;
							resultRow += CELL;
							resultRow += CELL;
							resultRow += CELL;
							resultRow += CELL;
							resultRow += CELL_OPEN +StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(roleMap.get("ItemName"))) + CELL_CLOSE;
							
							for(int k=0; k<cxnList.size(); k++){
								Map cxnMap = (HashMap) cxnList.get(k);
								
								setMap.put("itemID", StringUtil.checkNull(cxnMap.get("ItemID"),""));
								setMap.put("itemClassCode", "CL04005");
								List linkList = commonService.selectList("link_SQL.getLinkListFromAttAlloc", setMap);
								String linkUrl = "";
								String lovCode = "";
								String attrTypeCode = "";
								String linkImg = "blank.png";
								
								if(linkList.size() > 0){
									Map linkInfo = (Map)linkList.get(0);
									linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
									lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
									attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
									if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
								}
																
								resultRow += "<row open='1'>";
								resultRow += CELL_CHECK;
								resultRow +=  "	<cell image='" + StringUtil.checkNull(cxnMap.get("ClassIcon"))+ "'> " +StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(cxnMap.get("Identifier"))) +" "+StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(cxnMap.get("ItemName")))+CELL_CLOSE;
								resultRow += CELL_OPEN +StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(cxnMap.get("ItemPath"))) + CELL_CLOSE;
								resultRow += CELL_OPEN + linkImg + CELL_CLOSE;
								resultRow += CELL_OPEN +StringUtil.checkNull(cxnMap.get("ItemID")) + CELL_CLOSE;
								resultRow += CELL_OPEN + linkUrl + CELL_CLOSE;
								resultRow += CELL_OPEN + lovCode + CELL_CLOSE;
								resultRow += CELL_OPEN + attrTypeCode +  CELL_CLOSE;
								resultRow += CELL_OPEN +StringUtil.checkNull(subItemMap.get("ItemID")) + CELL_CLOSE;
								resultRow += CELL_OPEN +StringUtil.checkNull(map.get("ItemID")) + CELL_CLOSE;
								resultRow += CELL_OPEN +StringUtil.checkNull(roleMap.get("ItemID")) + CELL_CLOSE;
								resultRow += ROW_CLOSE;
							}
							resultRow += ROW_CLOSE;
							resultRow += ROW_CLOSE;
						}
					}
				}
				
				
			}
	
			result += resultRow;
			result += "</row>";
			result += "</rows>";
		}
		return result.replace("&", "/"); // 특수 문자 제거
	}
	
	@RequestMapping(value="/viewTCDetail.do")
	public String viewTCDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String url= "/app/pim/instance/tc/viewTCDetail";
		try {
			String ProcInstNo = StringUtil.checkNull(cmmMap.get("procInstNo"));
			String elmInstNo = StringUtil.checkNull(cmmMap.get("elmInstNo"));	
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			
			Map setData = new HashMap();
			setData.put("instanceClass", "ELM");
			setData.put("languageID", languageID);
			setData.put("instanceNo", ProcInstNo);
			setData.put("elmInstNo", elmInstNo);
			setData.put("testCase", "Y");
						
			Map ElmInstMap = commonService.select("instance_SQL.getElmInstList_gridList", setData);
			model.put("ElmInstInfo", ElmInstMap);
			
			String elmItemID = StringUtil.checkNull(ElmInstMap.get("ElmItemID"));
			setData.put("elmInstNo", elmInstNo);
			setData.put("instanceClass", "ELM");
			Map procInstanceInfo = commonService.select("instance_SQL.getProcInstanceInfo", setData);			
			model.put("procInstanceInfo", procInstanceInfo);	
			
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setData);
			/* 속성 */
			Map setMap = new HashMap();
			setMap.put("defaultLang", defaultLang);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", ElmInstMap.get("ProgramID"));
			setMap.put("AttrTypeCode","AT00037");
			setMap.put("Editable","1");
			Map AT00037 = commonService.select("attr_SQL.getItemAttr",setMap);
			model.put("AT00037", StringUtil.checkNull(AT00037.get("PlainText")));
			
			setMap.put("instanceNo", elmInstNo);
			setMap.put("attrTypeCode", "AT00402");
			String AT00402 = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstAttrValue", setMap),"");
			
			setMap.put("s_itemID", "AT00402");
			List AT00402List = commonService.selectList("attr_SQL.selectAttrLovOption", setMap);
			
			for(int i=0; i<AT00402List.size(); i++){
				Map AT00402Map = (HashMap) AT00402List.get(i);
				if(AT00402Map.get("CODE").equals(AT00402)) model.put("AT00402", StringUtil.checkNull(AT00402Map.get("NAME")));
			}
			
			/** 첨부문서 취득 */
			cmmMap.put("DocumentID", ElmInstMap.get("ProgramID"));
			cmmMap.put("s_itemID", ElmInstMap.get("ProgramID"));
			cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			cmmMap.put("isPublic", "N");
			cmmMap.put("DocCategory", "ITM");
			cmmMap.put("hideBlocked", "Y");
			
			List attachFileList = commonService.selectList("fileMgt_SQL.getFile_gridList", cmmMap);
			model.put("attachFileList", attachFileList);
			
			model.put("procInstNo", ProcInstNo);
			model.put("elmInstNo", elmInstNo);
			model.put("instanceClass", "ELM");
			model.put("elmItemID", elmItemID);
			model.put("fromModelYN", StringUtil.checkNull(cmmMap.get("fromModelYN"),""));
			model.put("instanceClass", StringUtil.checkNull(cmmMap.get("instanceClass"),""));
			model.put("menu", getLabel(cmmMap, commonService));
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		
		return nextUrl(url);
	}
	
	@RequestMapping(value="/testObjectReportExcel.do")
	public String testObjectReportExcel(HttpServletRequest request, HashMap commandMap, ModelMap model, HttpServletResponse response) throws Exception{
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		FileOutputStream fileOutput = null;
		XSSFWorkbook wb = new XSSFWorkbook();
		List GRList = new ArrayList();
		try{
			String modelID = StringUtil.checkNull(request.getParameter("procModelID"), "");
			String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"), "");
			String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"), "");
			String processID = StringUtil.checkNull(request.getParameter("processID"), "");
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
			setMap.put("languageID", languageID);
			setMap.put("instanceNo", instanceNo);
			setMap.put("testCase", "Y");
			setMap.put("grInstNo","GR");
			GRList = commonService.selectList("instance_SQL.getElmInstList_gridList", setMap);
			
			Map menu = getLabel(request, commonService);
			
			XSSFSheet sheet = wb.createSheet("process report");
//			sheet.protectSheet("password");
//			sheet.createFreezePane(3, 2); // 고정줄
			XSSFCellStyle headerStyle = setCellHeaderStyle(wb);
			XSSFCellStyle contentsStyle = setCellContentsStyle(wb, "");
			XSSFCellStyle unlock = setCellContentsStyle(wb, "");
			XSSFCellStyle grStyle = setCellContentsStyle(wb, "LIGHT_CORNFLOWER_BLUE");
			XSSFCellStyle activityStyle = setCellContentsStyle(wb, "LIGHT_GREEN");
			unlock.setLocked(false);
			
			int cellIndex = 0;
			int rowIndex = 0;
			XSSFRow row = sheet.createRow(rowIndex);
			row.setHeight((short) (512 * ((double) 8 / 10 )));
			XSSFCell cell = null;
			rowIndex++;

			cell = row.createCell(cellIndex);
			cell.setCellValue("header1");
			cell.setCellStyle(headerStyle);
			/* AttributeCode 행 숨기기	*/
//			row.setZeroHeight(true);
			
			/* ItemID 열  숨기기 */
//			sheet.setColumnHidden(cellIndex, true);
			
			/* ItemID */
			cell = row.createCell(cellIndex);			cell.setCellValue("ItemID");			cell.setCellStyle(headerStyle);			cellIndex++;
			/* 경로 */
			cell = row.createCell(cellIndex);			cell.setCellValue(String.valueOf(menu.get("LN00043")));			cell.setCellStyle(headerStyle);			cellIndex++;
			/* 클래스 */
			cell = row.createCell(cellIndex);			cell.setCellValue(String.valueOf(menu.get("LN00016")));			cell.setCellStyle(headerStyle);			cellIndex++;
			/* ID */
			cell = row.createCell(cellIndex);			cell.setCellValue(String.valueOf(menu.get("LN00106")));			cell.setCellStyle(headerStyle);			cellIndex++;
			/* Name */
			cell = row.createCell(cellIndex);			cell.setCellValue(String.valueOf(menu.get("LN00028")));			cell.setCellStyle(headerStyle);			cellIndex++;
			/* 역할/담당자 */
			cell = row.createCell(cellIndex);			cell.setCellValue(String.valueOf(menu.get("LN00119")+"/"+menu.get("LN00004")));			cell.setCellStyle(headerStyle);			cellIndex++;
			/* Step 설명 (Guideline) */
			cell = row.createCell(cellIndex);			cell.setCellValue(String.valueOf("Step 설명 (Guideline)"));			cell.setCellStyle(headerStyle);			cellIndex++;
			/* Appl. */
			cell = row.createCell(cellIndex);			cell.setCellValue(String.valueOf("Appl."));			cell.setCellStyle(headerStyle);			cellIndex++;
			/* Check Point */
			cell = row.createCell(cellIndex);			cell.setCellValue(String.valueOf("Check Point"));			cell.setCellStyle(headerStyle);			cellIndex++;
			/* Document No */
			cell = row.createCell(cellIndex);			cell.setCellValue(String.valueOf("Document No"));			cell.setCellStyle(headerStyle);			cellIndex++;
			/* Results */
			cell = row.createCell(cellIndex);			cell.setCellValue(String.valueOf("Results"));			cell.setCellStyle(headerStyle);			cellIndex++;
			/* 테스트 결과 */
			cell = row.createCell(cellIndex);			cell.setCellValue(String.valueOf("테스트 결과"));			cell.setCellStyle(headerStyle);			cellIndex++; 		    sheet.autoSizeColumn(cellIndex);
			/* 비고 */
			cell = row.createCell(cellIndex);			cell.setCellValue(String.valueOf("비고"));			cell.setCellStyle(headerStyle);			cellIndex++;
			
			for (int i=0; i <GRList.size(); i++) {
				Map map = (Map) GRList.get(i);
				setMap.put("s_itemID",StringUtil.checkNull(map.get("ElmItemID")));
				Map grInfo = commonService.select("item_SQL.getObjectInfo", setMap);

				cellIndex = 0;   // cell index 초기화
				row = sheet.createRow(rowIndex);
			    row.setHeight((short) (512 * ((double) 8 / 10 )));
			    rowIndex++;
			    
				/* ItemID */
				cell = row.createCell(cellIndex);
				cell.setCellValue(StringUtil.checkNull(map.get("ElmItemID")));
				cell.setCellStyle(grStyle);
			    sheet.autoSizeColumn(cellIndex);
				cellIndex++;
				/* 경로 */ 
				cell = row.createCell(cellIndex);
				cell.setCellValue(StringUtil.checkNull(grInfo.get("Path")));
				cell.setCellStyle(grStyle);
			    sheet.autoSizeColumn(cellIndex);
				cellIndex++;
				/* 클래스 */
				cell = row.createCell(cellIndex);
				cell.setCellValue(StringUtil.checkNull(grInfo.get("ClassName")));
				cell.setCellStyle(grStyle);
			    sheet.autoSizeColumn(cellIndex);
				cellIndex++;
				/* ID */
				cell = row.createCell(cellIndex);
				cell.setCellValue(StringUtil.checkNull(map.get("Identifier")));
				cell.setCellStyle(grStyle);
			    sheet.autoSizeColumn(cellIndex);
				cellIndex++;
				/* Name */
				cell = row.createCell(cellIndex);
				cell.setCellValue(removeAllTag(StringUtil.checkNull(map.get("elmItemName")),"DbToEx"));
				cell.setCellStyle(grStyle);
			    sheet.autoSizeColumn(cellIndex);
				cellIndex++;
				for(int k=0; k<8; k++) {
					cell = row.createCell(cellIndex);
					cell.setCellValue("");
					cell.setCellStyle(grStyle);
				    sheet.autoSizeColumn(cellIndex);
					cellIndex++;
				}

				setMap.put("instanceNo", instanceNo);
				setMap.put("grInstNo",StringUtil.checkNull(map.get("ElmInstNo")));
				List programList = commonService.selectList("instance_SQL.getElmInstList_gridList", setMap);
				
				if(programList.size() > 0) {
					for (int j=0; j <programList.size(); j++) {
						Map activityMap = (Map) programList.get(j);
						setMap.put("s_itemID",StringUtil.checkNull(activityMap.get("ElmItemID")));
						Map activityInfo = commonService.select("item_SQL.getObjectInfo", setMap);

						String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
						setMap.put("defaultLang", defaultLang);
						List activityAttrList = commonService.selectList("attr_SQL.getItemAttr", setMap);
						
						String AT00008 = "", AT00014 = "", AT00053 = "";
						for(int k=0; k<activityAttrList.size(); k++){
							Map activityAttrMap = (HashMap) activityAttrList.get(k);
							if(activityAttrMap.get("AttrTypeCode").equals("AT00008")) AT00008 =  removeAllTag(StringUtil.checkNull(activityAttrMap.get("PlainText")),"DbToEx");
							if(activityAttrMap.get("AttrTypeCode").equals("AT00014")) AT00014 =  removeAllTag(StringUtil.checkNull(activityAttrMap.get("PlainText")),"DbToEx");
							if(activityAttrMap.get("AttrTypeCode").equals("AT00053")) AT00053 =  removeAllTag(StringUtil.checkNull(activityAttrMap.get("PlainText")),"DbToEx");
						}
						
						setMap.put("instanceNo", StringUtil.checkNull(activityMap.get("ElmInstNo")));
						setMap.put("attrTypeCode", "AT00401");
						String AT00401 = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstAttrValue", setMap),"");
						setMap.put("attrTypeCode", "AT00402");
						String AT00402 = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstAttrValue", setMap),"");
						setMap.put("s_itemID", "AT00402");
						List AT00402List = commonService.selectList("attr_SQL.selectAttrLovOption", setMap);
						for(int k=0; k<AT00402List.size(); k++){
							Map AT00402Map = (HashMap) AT00402List.get(k);
							if(AT00402Map.get("CODE").equals(AT00402))
								AT00402 = StringUtil.checkNull(AT00402Map.get("NAME"));
						}
						
						if(j>0) {
							Map preActivityMap = (Map) programList.get(j-1);
							if(!activityMap.get("ElmItemID").equals(preActivityMap.get("ElmItemID"))) {
								cellIndex = 0;   // cell index 초기화
								row = sheet.createRow(rowIndex);
							    row.setHeight((short) (512 * ((double) 8 / 10 )));
							    rowIndex++;
							    
								/* ItemID */
								cell = row.createCell(cellIndex);
								cell.setCellValue(StringUtil.checkNull(activityMap.get("ElmItemID")));
								cell.setCellStyle(activityStyle);
							    sheet.autoSizeColumn(cellIndex);
								cellIndex++;
								/* 경로 */ 
								cell = row.createCell(cellIndex);
								cell.setCellValue(StringUtil.checkNull(activityInfo.get("Path")));
								cell.setCellStyle(activityStyle);
							    sheet.autoSizeColumn(cellIndex);
								cellIndex++;
								/* 클래스 */
								cell = row.createCell(cellIndex);
								cell.setCellValue(StringUtil.checkNull(activityInfo.get("ClassName")));
								cell.setCellStyle(activityStyle);
							    sheet.autoSizeColumn(cellIndex);
								cellIndex++;
								/* ID */
								cell = row.createCell(cellIndex);
								cell.setCellValue(StringUtil.checkNull(activityMap.get("Identifier")));
								cell.setCellStyle(activityStyle);
							    sheet.autoSizeColumn(cellIndex);
								cellIndex++;
								/* Name */
								cell = row.createCell(cellIndex);
								cell.setCellValue(removeAllTag(StringUtil.checkNull(activityMap.get("elmItemName")),"DbToEx"));
								cell.setCellStyle(activityStyle);
							    sheet.autoSizeColumn(cellIndex);
								cellIndex++;
								/* 역할/담당자 */
								cell = row.createCell(cellIndex);
								cell.setCellValue(StringUtil.checkNull(activityMap.get("roleName")));
								cell.setCellStyle(activityStyle);
							    sheet.autoSizeColumn(cellIndex);
								cellIndex++;
								for(int k=0; k<7; k++) {
									cell = row.createCell(cellIndex);
									cell.setCellValue("");
									cell.setCellStyle(activityStyle);
								    sheet.autoSizeColumn(cellIndex);
									cellIndex++;
								}
							}
						} else {
							cellIndex = 0;   // cell index 초기화
							row = sheet.createRow(rowIndex);
						    row.setHeight((short) (512 * ((double) 8 / 10 )));
						    rowIndex++;
						    
							/* ItemID */
							cell = row.createCell(cellIndex);
							cell.setCellValue(StringUtil.checkNull(activityMap.get("ElmItemID")));
							cell.setCellStyle(activityStyle);
						    sheet.autoSizeColumn(cellIndex);
							cellIndex++;
							/* 경로 */ 
							cell = row.createCell(cellIndex);
							cell.setCellValue(StringUtil.checkNull(activityInfo.get("Path")));
							cell.setCellStyle(activityStyle);
						    sheet.autoSizeColumn(cellIndex);
							cellIndex++;
							/* 클래스 */
							cell = row.createCell(cellIndex);
							cell.setCellValue(StringUtil.checkNull(activityInfo.get("ClassName")));
							cell.setCellStyle(activityStyle);
						    sheet.autoSizeColumn(cellIndex);
							cellIndex++;
							/* ID */
							cell = row.createCell(cellIndex);
							cell.setCellValue(StringUtil.checkNull(activityMap.get("Identifier")));
							cell.setCellStyle(activityStyle);
						    sheet.autoSizeColumn(cellIndex);
							cellIndex++;
							/* Name */
							cell = row.createCell(cellIndex);
							cell.setCellValue(removeAllTag(StringUtil.checkNull(activityMap.get("elmItemName")),"DbToEx"));
							cell.setCellStyle(activityStyle);
						    sheet.autoSizeColumn(cellIndex);
							cellIndex++;
							/* 역할/담당자 */
							cell = row.createCell(cellIndex);
							cell.setCellValue(StringUtil.checkNull(activityMap.get("roleName")));
							cell.setCellStyle(activityStyle);
						    sheet.autoSizeColumn(cellIndex);
							cellIndex++;
							for(int k=0; k<7; k++) {
								cell = row.createCell(cellIndex);
								cell.setCellValue("");
								cell.setCellStyle(activityStyle);
							    sheet.autoSizeColumn(cellIndex);
								cellIndex++;
							}
						}
						
						setMap.put("s_itemID",StringUtil.checkNull(activityMap.get("ProgramID")));
						Map programInfo = commonService.select("item_SQL.getObjectInfo", setMap);

						cellIndex = 0;   // cell index 초기화
						row = sheet.createRow(rowIndex);
					    row.setHeight((short) (512 * ((double) 8 / 10 )));
					    rowIndex++;
					    
						/* ItemID */
						cell = row.createCell(cellIndex);
						cell.setCellValue(StringUtil.checkNull(activityMap.get("ProgramID")));
						cell.setCellStyle(contentsStyle);
					    sheet.autoSizeColumn(cellIndex);
						cellIndex++;
						/* 경로 */ 
						cell = row.createCell(cellIndex);
						cell.setCellValue(StringUtil.checkNull(programInfo.get("Path")));
						cell.setCellStyle(contentsStyle);
					    sheet.autoSizeColumn(cellIndex);
						cellIndex++;
						/* 클래스 */
						cell = row.createCell(cellIndex);
						cell.setCellValue(StringUtil.checkNull(programInfo.get("ClassName")));
						cell.setCellStyle(contentsStyle);
					    sheet.autoSizeColumn(cellIndex);
						cellIndex++;
						/* ID */
						cell = row.createCell(cellIndex);
						cell.setCellValue(StringUtil.checkNull(programInfo.get("Identifier")));
						cell.setCellStyle(contentsStyle);
					    sheet.autoSizeColumn(cellIndex);
						cellIndex++;
						/* Name */
						cell = row.createCell(cellIndex);
						cell.setCellValue(removeAllTag(StringUtil.checkNull(programInfo.get("ItemName")),"DbToEx"));
						cell.setCellStyle(contentsStyle);
					    sheet.autoSizeColumn(cellIndex);
						cellIndex++;
						/* 역할/담당자 */
						cell = row.createCell(cellIndex);
						cell.setCellValue(StringUtil.checkNull(activityMap.get("actorName")));
						cell.setCellStyle(contentsStyle);
					    sheet.autoSizeColumn(cellIndex);
						cellIndex++;
						/* Step 설명 (Guideline) */
						cell = row.createCell(cellIndex);
						cell.setCellValue(AT00008);
						cell.setCellStyle(contentsStyle);
					    sheet.autoSizeColumn(cellIndex);
						cellIndex++;
						/* Appl. */
						cell = row.createCell(cellIndex);
						cell.setCellValue(AT00014);
						cell.setCellStyle(contentsStyle);
					    sheet.autoSizeColumn(cellIndex);
						cellIndex++;
						/* Check Point */
						cell = row.createCell(cellIndex);
						cell.setCellValue(AT00053);
						cell.setCellStyle(contentsStyle);
					    sheet.autoSizeColumn(cellIndex);
						cellIndex++;
						/* Document No */
						cell = row.createCell(cellIndex);
						cell.setCellValue(StringUtil.checkNull(activityMap.get("DocumentNo")));
						cell.setCellStyle(contentsStyle);
					    sheet.autoSizeColumn(cellIndex);
						cellIndex++;
						/* Results */
						cell = row.createCell(cellIndex);
						cell.setCellValue(AT00401);
						cell.setCellStyle(contentsStyle);
					    sheet.autoSizeColumn(cellIndex);
						cellIndex++;
						/* 테스트 결과 */
						cell = row.createCell(cellIndex);
						cell.setCellValue(AT00402);
						cell.setCellStyle(contentsStyle);
					    sheet.autoSizeColumn(cellIndex);
						cellIndex++;
						/* 비고 */
						cell = row.createCell(cellIndex);
						cell.setCellValue("");
						cell.setCellStyle(contentsStyle);
					    sheet.autoSizeColumn(cellIndex);
						cellIndex++;
					}
				}
			}
			
			//////////////////////////////////////////
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			long date = System.currentTimeMillis();
			
			String orgFileName1 = "TESTLIST_" + "_" + formatter.format(date) + ".xlsx";
			String orgFileName2 = "TESTLIST_" + "_" + formatter.format(date) + ".xlsx";
			String downFile1 = FileUtil.FILE_EXPORT_DIR + orgFileName1;
			String downFile2 = FileUtil.FILE_EXPORT_DIR + orgFileName2;
			
			File file = new File(downFile2);
			fileOutput = new FileOutputStream(file);
			
			wb.write(fileOutput);
			
			HashMap drmInfoMap = new HashMap();
			
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
			String teamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String teamName = StringUtil.checkNull(commandMap.get("sessionTeamName"));
			
			drmInfoMap.put("userID", userID);
			drmInfoMap.put("userName", userName);
			drmInfoMap.put("teamID", teamID);
			drmInfoMap.put("teamName", teamName);
			drmInfoMap.put("orgFileName", orgFileName2);
			drmInfoMap.put("downFile", downFile2);
			
			// file DRM 적용
			String useDRM = StringUtil.checkNull(GlobalVal.USE_DRM);
			String useDownDRM = StringUtil.checkNull(GlobalVal.DRM_DOWN_USE);
			if(!"".equals(useDRM) && !"N".equals(useDownDRM)){
				drmInfoMap.put("funcType", "report");
				DRMUtil.drmMgt(drmInfoMap); // 암호화 
			}

			target.put(AJAX_SCRIPT, "parent.doFileDown('"+orgFileName1+"', 'excel');parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		} finally {
			if(fileOutput != null) fileOutput.close();
			wb = null;
			
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);	
	}
	
	private XSSFCellStyle setCellHeaderStyle(XSSFWorkbook wb) {
		XSSFCellStyle style = wb.createCellStyle();
		 
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBottomBorderColor(IndexedColors.GREY_80_PERCENT.getIndex());
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setAlignment(HorizontalAlignment.CENTER);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		
		style.setFillForegroundColor(HSSFColor.PALE_BLUE.index);
		style.setFillBackgroundColor(HSSFColor.PALE_BLUE.index);
		style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 9);
		font.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
		font.setFontName("Arial");
		
		style.setFont(font);
		 
		return style;
	}
	
	private XSSFCellStyle setCellContentsStyle(XSSFWorkbook wb, String color) {
		XSSFCellStyle style = wb.createCellStyle();
		 
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		
		if(color.equals("LIGHT_BLUE")){
			style.setFillBackgroundColor(HSSFColor.LIGHT_BLUE.index);
			style.setFillForegroundColor(HSSFColor.LIGHT_BLUE.index);
			style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		}else if(color.equals("LIGHT_CORNFLOWER_BLUE")){
			style.setFillBackgroundColor(HSSFColor.LIGHT_CORNFLOWER_BLUE.index);
			style.setFillForegroundColor(HSSFColor.LIGHT_CORNFLOWER_BLUE.index);
			style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		}else if(color.equals("LIGHT_GREEN")){ 
			style.setFillBackgroundColor(HSSFColor.LIGHT_GREEN.index);
			style.setFillForegroundColor(HSSFColor.LIGHT_GREEN.index);
			style.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		}
		
		XSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 10);
		font.setFontName("Arial");
		
		style.setFont(font);
		 
		return style;
	}
	
	private String removeAllTag(String str,String type) { 
		if(type.equals("DbToEx")){//201610 new line :: DB To Excel
			str = str.replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn").replaceAll("\r\n", "&&rn").replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&#40;", "(").replaceAll("&#41;", ")").replace("&sect;","-");//20161024 bshyun Test
		}else{
			str = str.replaceAll("\n", "&&rn");//201610 new line :: Excel To DB 
		}
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");
		if(type.equals("DbToEx")){
			str = str.replaceAll("&&rn", "\n");
		}
		//return str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");
		return StringEscapeUtils.unescapeHtml4(str);
	}
	
	@RequestMapping(value="/viewTCAppTree.do")
	public String viewTCAppTree(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "/app/pim//instance/tc/viewTCAppTree";
		List GRList = new ArrayList();
		Map setMap = new HashMap();
        List<Map<String, Object>> list= new ArrayList();
		try {
			String modelID = StringUtil.checkNull(request.getParameter("procModelID"), "");
			String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"), "");
			String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"), "");
			String processID = StringUtil.checkNull(request.getParameter("processID"), "");
//			String searchValue = StringUtil.checkNull(request.getParameter("searchValue"), "");
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			
			setMap.put("languageID", languageID);
			setMap.put("ItemID", processID);
			setMap.put("modelID", modelID);
			setMap.put("attrTypeCode", "AT00036");

			setMap.put("ModelID", modelID);			
			Map modelMap = commonService.select("model_SQL.getModelViewer", setMap);
			
			setMap.put("procInstNo", instanceNo);
			List elmInstProgramList = commonService.selectList("instance_SQL.getElmInstProgramCTEList", setMap);
			
			List elmInstProgramClassCodeList = commonService.selectList("instance_SQL.getCxnClassCodeList", setMap);
			
			setMap.put("instanceNo", instanceNo);
			setMap.put("instanceClass", instanceClass);
			Map procInstanceInfo = commonService.select("instance_SQL.getProcInstanceInfo", setMap);			
			model.put("procInstanceInfo", procInstanceInfo);	
			
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			setMap.put("defaultLang", defaultLang);
			setMap.put("languageID", languageID);
			setMap.put("s_itemID", processID);
			/* 기본정보 내용 취득 */
			List prcList = commonService.selectList("report_SQL.getItemInfo", setMap);
			Map prcMap = (Map) prcList.get(0);			
			model.put("prcMap",prcMap);
			
			model.put("procModelID",modelID);
			model.put("instanceNo", instanceNo);
			model.put("instanceClass", instanceClass);
	        model.put("nodeID", processID);
//	        model.put("elmTreeXml",getTCAppXML(modelMap, elmInstProgramList, elmInstProgramClassCodeList, languageID, instanceNo));
	        model.put("menu", getLabel(request, commonService));
	        
//	        ======================================================
	        
	     // 최종 결과를 담을 List<Map>
	        List<Map> resultList = new ArrayList<>();
	        
	        modelMap.put("itemName", "<img src='"+GlobalVal.HTML_IMG_DIR_ITEM+"/img_sitemap.png' />"+modelMap.get("ModelName")+"("+modelMap.get("MCName")+")");
	        modelMap.put("id", "1");

	        resultList.add(modelMap);
	        
	        // 1. ClassCode 리스트 추출
	        List<String> classCodeList = new ArrayList<>();
	        for (int i = 0; i < elmInstProgramClassCodeList.size(); i++){
	            Map classCodeInfo = (Map)elmInstProgramClassCodeList.get(i);
	            classCodeList.add(StringUtil.checkNull(classCodeInfo.get("ClassCode")));
	        }

	        // 2. Level 1: 최상위 프로그램 항목 
	        for (int i2 = 0; i2 < elmInstProgramList.size(); i2++){
	            Map elmProgramInfo01 = (Map) elmInstProgramList.get(i2);
	            String classCode01 = StringUtil.checkNull(elmProgramInfo01.get("ClassCode"));
	            String itemID = StringUtil.checkNull(elmProgramInfo01.get("ItemID"));
	            
	            if(StringUtil.checkNull(classCodeList.get(0)).equals(classCode01)) {
	                
	                // 데이터 Map 생성 및 계층 정보 설정 (parent, id)
	                Map mapL1 = new HashMap(elmProgramInfo01);
	                mapL1.put("id", itemID);
	                mapL1.put("parent", "1"); // 최상위 부모 ID 설정
	                
	                // itemName 필드에 이미지 태그와 텍스트 결합
	                mapL1.put("itemName", "<img src='" + GlobalVal.HTML_IMG_DIR_ITEM + "/" + StringUtil.checkNull(mapL1.get("ItemTypeImg")) + "' />"
	                                       + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(mapL1.get("Identifier")))
	                                       + " " + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(mapL1.get("ItemName"))));
	                
	                // 빈 셀에 해당하는 필드 초기화
	                mapL1.put("Path", "");
	                mapL1.put("roleName", "");
	                mapL1.put("linkImg", "blank.png");
	                mapL1.put("CxnItemID", "");
	                mapL1.put("linkUrl", "");
	                mapL1.put("lovCode", "");
	                mapL1.put("attrTypeCode", "");
	                mapL1.put("statusName", "");
	                mapL1.put("ElmInstNo", "");
	                
	                resultList.add(mapL1);
	                
	                // 3. Level 2: itemID를 부모로 갖는 항목
	                for (int i3 = 0; i3 < elmInstProgramList.size(); i3++){
	                    Map elmProgramInfo02 = (Map) elmInstProgramList.get(i3);
	                    String itemID02 = StringUtil.checkNull(elmProgramInfo02.get("ItemID"));
	                    String fromItemID02 = StringUtil.checkNull(elmProgramInfo02.get("FromItemID"));
	                    
	                    if(fromItemID02.equals(itemID)) {
	                        
	                        // 데이터 Map 생성 및 계층 정보 설정
	                        Map mapL2 = new HashMap(elmProgramInfo02);
	                        mapL2.put("id", itemID02);
	                        mapL2.put("parent", itemID); // Level 1의 itemID를 부모로 설정
	                        
	                        mapL2.put("itemName", "<img src='" + GlobalVal.HTML_IMG_DIR_ITEM + "/" + StringUtil.checkNull(mapL2.get("ItemTypeImg")) + "' />"
	                                               + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(mapL2.get("Identifier")))
	                                               + " " + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(mapL2.get("ItemName"))));
	                        
	                        // 빈 셀에 해당하는 필드 초기화
	                        mapL2.put("Path", "");
	                        mapL2.put("roleName", "");
	                        mapL2.put("linkImg", "blank.png");
	                        mapL2.put("CxnItemID", "");
	                        mapL2.put("linkUrl", "");
	                        mapL2.put("lovCode", "");
	                        mapL2.put("attrTypeCode", "");
	                        mapL2.put("statusName", "");
	                        mapL2.put("ElmInstNo", "");

	                        resultList.add(mapL2);

	                        // 4. Level 3: itemID02를 부모로 갖는 항목
	                        for (int i4 = 0; i4 < elmInstProgramList.size(); i4++){
	                            Map elmProgramInfo03 = (Map) elmInstProgramList.get(i4);
	                            String itemID03 = StringUtil.checkNull(elmProgramInfo03.get("ItemID"));
	                            String fromItemID03 = StringUtil.checkNull(elmProgramInfo03.get("FromItemID"));
	                            
	                            if(fromItemID03.equals(itemID02)) {
	                                
	                                // 링크 정보 조회
	                                setMap = new HashMap();								
	                                setMap.put("itemID", itemID03);
	                                setMap.put("itemClassCode", StringUtil.checkNull(elmProgramInfo03.get("ClassCode")));
	                                setMap.put("languageID", languageID);
	                                Map linkInfo = commonService.select("link_SQL.getLinkListFromAttAlloc", setMap);
	                                String linkUrl = ""; String lovCode = ""; String attrTypeCode = ""; String linkImg = "blank.png";
	                                
	                                if(!linkInfo.isEmpty()){
	                                    linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
	                                    lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
	                                    attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
	                                    if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
	                                }
	                                
	                                // 데이터 Map 생성 및 계층 정보 설정
	                                Map mapL3 = new HashMap(elmProgramInfo03);
	                                mapL3.put("id", itemID03 + itemID02); // 고유 ID 조합
	                                mapL3.put("parent", itemID02); // Level 2의 itemID02를 부모로 설정
	                                
	                                mapL3.put("itemName", "<img src='" + GlobalVal.HTML_IMG_DIR_ITEM + "/" + StringUtil.checkNull(mapL3.get("ItemTypeImg")) + "' />"
	                                                       + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(mapL3.get("Identifier")))
	                                                       + " " + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(mapL3.get("ItemName"))));

	                                mapL3.put("linkImg", linkImg);
	                                mapL3.put("CxnItemID", itemID03); // 원본 코드의 ItemID 셀 값
	                                mapL3.put("linkUrl", linkUrl);
	                                mapL3.put("lovCode", lovCode);
	                                mapL3.put("attrTypeCode", attrTypeCode);

	                                // 빈 셀에 해당하는 필드 초기화
	                                mapL3.put("Path", "");
	                                mapL3.put("roleName", "");
	                                mapL3.put("statusName", "");
	                                mapL3.put("ElmInstNo", "");

	                                resultList.add(mapL3);
	                                
	                                // 5. Level 4: ACTIVITY (itemID03 하위)
	                                // DB 조회 (기존 로직 유지)
	                                setMap = new HashMap();
	                                setMap.put("procInstNo", instanceNo);
	                                setMap.put("itemID", itemID03);
	                                setMap.put("languageID", languageID);
	                                List elmInstActivityList = commonService.selectList("instance_SQL.getElmInstActivityListFromProgramID", setMap);
	                                
	                                for (int j = 0; j < elmInstActivityList.size(); j++){
	                                    Map elmActivityInfo = (Map) elmInstActivityList.get(j);
	                                    String elmInstNo = StringUtil.checkNull(elmActivityInfo.get("ElmInstNo"));

	                                    // AT00402 값 조회 (기존 로직 유지)
	                                    setMap = new HashMap();
	                                    setMap.put("instanceNo", elmInstNo);
	                                    setMap.put("attrTypeCode", "AT00402");
	                                    String AT00402 = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstAttrValue", setMap),"");
	                                    
	                                    String AT00402Style = "gray";
	                                    if(AT00402.equals("LV40201")) AT00402Style = "blue";
	                                    if(AT00402.equals("LV40202")) AT00402Style = "red";
	                                    
	                                    // 데이터 Map 생성 및 계층 정보 설정
	                                    Map mapL4_activity = new HashMap(elmActivityInfo);
	                                    mapL4_activity.put("id", StringUtil.checkNull(elmActivityInfo.get("ItemID")) + itemID03); // 고유 ID 조합
	                                    mapL4_activity.put("parent", itemID03 + itemID02); // Level 3의 고유 ID를 부모로 설정
	                                    
	                                    mapL4_activity.put("itemName", "<img src='" + GlobalVal.HTML_IMG_DIR_ITEM + "/" + StringUtil.checkNull(mapL4_activity.get("Icon")) + "' />"
	                                                                   + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(mapL4_activity.get("Identifier")))
	                                                                   + " " + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(mapL4_activity.get("ItemName"))));
	                                    
	                                    mapL4_activity.put("Path", StringUtil.checkNull(mapL4_activity.get("Path")));
	                                    mapL4_activity.put("roleName", StringUtil.checkNull(mapL4_activity.get("RoleItemName")));
	                                    mapL4_activity.put("linkImg", "blank.png"); // 원본 코드에 따라 설정
	                                    mapL4_activity.put("CxnItemID", StringUtil.checkNull(mapL4_activity.get("ItemID")));
	                                    mapL4_activity.put("statusName", "<span style='" + StringUtil.checkNull(mapL4_activity.get("StatusStyle")) + "'>" + StringUtil.checkNull(mapL4_activity.get("StatusName")) + "</span>"); // 스타일 포함
	                                    mapL4_activity.put("AT00402Style", AT00402Style);
	                                    mapL4_activity.put("ElmInstNo", elmInstNo);
	                                    
	                                    // 빈 셀에 해당하는 필드 초기화
	                                    mapL4_activity.put("linkUrl", "");
	                                    mapL4_activity.put("lovCode", "");
	                                    mapL4_activity.put("attrTypeCode", "");
	                                    
	                                    resultList.add(mapL4_activity);
	                                }
	                                
	                                // 6. Level 4: PROGRAM (itemID03 하위)
	                                for (int i5 = 0; i5 < elmInstProgramList.size(); i5++){
	                                    Map elmProgramInfo04 = (Map) elmInstProgramList.get(i5);
	                                    String itemID04 = StringUtil.checkNull(elmProgramInfo04.get("ItemID"));
	                                    String fromItemID04 = StringUtil.checkNull(elmProgramInfo04.get("FromItemID"));
	                                    
	                                    if(fromItemID04.equals(itemID03)) {
	                                        
	                                        // 링크 정보 조회
	                                        setMap = new HashMap();								
	                                        setMap.put("itemID", itemID04);
	                                        setMap.put("itemClassCode", StringUtil.checkNull(elmProgramInfo04.get("ClassCode")));
	                                        setMap.put("languageID", languageID);
	                                        linkInfo = commonService.select("link_SQL.getLinkListFromAttAlloc", setMap);
	                                        linkUrl = ""; lovCode = ""; attrTypeCode = "";linkImg = "blank.png";
	                                        
	                                        if(!linkInfo.isEmpty()){
	                                            linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
	                                            lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
	                                            attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
	                                            if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
	                                        }
	                                        
	                                        // 데이터 Map 생성 및 계층 정보 설정
	                                        Map mapL4_program = new HashMap(elmProgramInfo04);
	                                        mapL4_program.put("id", itemID04 + itemID03); // 고유 ID 조합
	                                        mapL4_program.put("parent", itemID03 + itemID02); // Level 3의 고유 ID를 부모로 설정
	                                        
	                                        mapL4_program.put("itemName", "<img src='" + GlobalVal.HTML_IMG_DIR_ITEM + "/" + StringUtil.checkNull(mapL4_program.get("ItemTypeImg")) + "' />"
	                                                                   + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(mapL4_program.get("Identifier")))
	                                                                   + " " + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(mapL4_program.get("ItemName"))));
	                                        
	                                        mapL4_program.put("linkImg", linkImg);
	                                        mapL4_program.put("CxnItemID", itemID04);
	                                        mapL4_program.put("linkUrl", linkUrl);
	                                        mapL4_program.put("lovCode", lovCode);
	                                        mapL4_program.put("attrTypeCode", attrTypeCode);

	                                        // 빈 셀에 해당하는 필드 초기화
	                                        mapL4_program.put("Path", "");
	                                        mapL4_program.put("roleName", "");
	                                        mapL4_program.put("statusName", "");
	                                        mapL4_program.put("ElmInstNo", "");

	                                        resultList.add(mapL4_program);

	                                        // 7. Level 5: ACTIVITY (itemID04 하위)
	                                        setMap = new HashMap();
	                                        setMap.put("procInstNo", instanceNo);
	                                        setMap.put("itemID", itemID04);
	                                        setMap.put("languageID", languageID);
	                                        List elmInstActivityList2 = commonService.selectList("instance_SQL.getElmInstActivityListFromProgramID", setMap);
	                                        
	                                        for (int k = 0; k < elmInstActivityList2.size(); k++){
	                                            Map elmActivityInfo = (Map) elmInstActivityList2.get(k); // 변수명 k 루프에서 재사용
	                                            String elmInstNo = StringUtil.checkNull(elmActivityInfo.get("ElmInstNo"));

	                                            // AT00402 값 조회
	                                            setMap = new HashMap();
	                                            setMap.put("instanceNo", elmInstNo);
	                                            setMap.put("attrTypeCode", "AT00402");
	                                            String AT00402 = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstAttrValue", setMap),"");
	                                            
	                                            String AT00402Style = "gray";
	                                            if(AT00402.equals("LV40201")) AT00402Style = "blue";
	                                            if(AT00402.equals("LV40202")) AT00402Style = "red";
	                                            
	                                            // 데이터 Map 생성 및 계층 정보 설정
	                                            Map mapL5_activity = new HashMap(elmActivityInfo);
	                                            mapL5_activity.put("id", StringUtil.checkNull(mapL5_activity.get("ItemID")) + itemID04); // 고유 ID 조합
	                                            mapL5_activity.put("parent", itemID04 + itemID03); // Level 4 Program의 고유 ID를 부모로 설정

	                                            mapL5_activity.put("itemName", "<img src='" + GlobalVal.HTML_IMG_DIR_ITEM + "/" + StringUtil.checkNull(mapL5_activity.get("Icon")) + "' />"
	                                                                           + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(mapL5_activity.get("Identifier")))
	                                                                           + " " + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(mapL5_activity.get("ItemName"))));
	                                            
	                                            mapL5_activity.put("Path", StringUtil.checkNull(mapL5_activity.get("Path")));
	                                            mapL5_activity.put("roleName", StringUtil.checkNull(mapL5_activity.get("RoleItemName")));
	                                            mapL5_activity.put("linkImg", "blank.png"); 
	                                            mapL5_activity.put("CxnItemID", StringUtil.checkNull(mapL5_activity.get("ItemID")));
	                                            mapL5_activity.put("statusName", "<span style='" + StringUtil.checkNull(mapL5_activity.get("StatusStyle")) + "'>" + StringUtil.checkNull(mapL5_activity.get("StatusName")) + "</span>");
	                                            mapL5_activity.put("AT00402Style", AT00402Style);
	                                            mapL5_activity.put("ElmInstNo", elmInstNo);

	                                            // 빈 셀에 해당하는 필드 초기화
	                                            mapL5_activity.put("linkUrl", "");
	                                            mapL5_activity.put("lovCode", "");
	                                            mapL5_activity.put("attrTypeCode", "");

	                                            resultList.add(mapL5_activity);
	                                        }
	                                    }
	                                }
	                            }
	                        }
	                    }
	                }
	            }
	        }

            JSONArray gridData = new JSONArray(resultList);
            
            model.put("gridData",gridData);
			
//	        ======================================================    
	        
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);		
	}
	
	private String getTCAppXML(Map modelMap, List elmInstProgramList, List elmInstProgramClassCodeList, String languageID,String procInstNo) throws Exception {
		Map setMap = new HashMap();
		List subItemList = new ArrayList();
		String ModelName= "";
		
		String CELL = "	<cell></cell>";
		String CELL_CHECK = "	<cell>0</cell>";
		String CELL_OPEN = "	<cell>";
		String CELL_CLOSE = "</cell>";
		String ROW_CLOSE = "</row>";
		
		String result = "";
		String resultRow = "";
		if (elmInstProgramList.size() > 0) {
			ModelName = (StringUtil.checkNull(modelMap.get("ModelName"))).replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ");	
			
			result += "<rows>";
			result += "<row id='1' open='1'>";
			result += "	<cell image='img_sitemap.png' style='font-weight:bold;text-align: left;'> " + ModelName.replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ")
					+"("+modelMap.get("MCName")+")"+ "</cell>";
		
			List classCodeList = new ArrayList();
			for (int i = 0; i < elmInstProgramClassCodeList.size(); i++){
				Map classCodeInfo = (Map)elmInstProgramClassCodeList.get(i);				
				classCodeList.add(StringUtil.checkNull(classCodeInfo.get("ClassCode")));
			}
			
			for (int i2 = 0; i2 < elmInstProgramList.size(); i2++){
				Map elmProgramInfo01 = (Map) elmInstProgramList.get(i2);
				String classCode01 = StringUtil.checkNull(elmProgramInfo01.get("ClassCode"));
				String itemID = StringUtil.checkNull(elmProgramInfo01.get("ItemID"));
				
				if(StringUtil.checkNull(classCodeList.get(0)).equals(classCode01)) {
					
					resultRow += "<row open='1' id='" + itemID + "'>";
					resultRow += "<cell image='" + StringUtil.checkNull(elmProgramInfo01.get("ItemTypeImg"))+ "'> " 
																 + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmProgramInfo01.get("Identifier"))) 
																 +" "+ StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmProgramInfo01.get("ItemName"))) + CELL_CLOSE;
				
					/////////////////////////////////////////////////////////////////////////////////////////////
				    
					for (int i3 = 0; i3 < elmInstProgramList.size(); i3++){
						Map elmProgramInfo02 = (Map) elmInstProgramList.get(i3);
						String itemID02 = StringUtil.checkNull(elmProgramInfo02.get("ItemID"));
						String fromItemID02 = StringUtil.checkNull(elmProgramInfo02.get("FromItemID"));
						
						if(fromItemID02.equals(itemID)) {
															
							resultRow += "<row open='1' id='" + itemID02 + "'>";
							resultRow += "	<cell image='" + StringUtil.checkNull(elmProgramInfo02.get("ItemTypeImg"))+ "'> " 
																		 + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmProgramInfo02.get("Identifier"))) 
																		 +" "+ StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmProgramInfo02.get("ItemName"))) + CELL_CLOSE;
							////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
							for (int i4 = 0; i4 < elmInstProgramList.size(); i4++){
								Map elmProgramInfo03 = (Map) elmInstProgramList.get(i4);
								String itemID03 = StringUtil.checkNull(elmProgramInfo03.get("ItemID"));
								String fromItemID03 = StringUtil.checkNull(elmProgramInfo03.get("FromItemID"));
								if(fromItemID03.equals(itemID02)) {
									setMap = new HashMap();								
									setMap.put("itemID", itemID03);
									setMap.put("itemClassCode", StringUtil.checkNull(elmProgramInfo03.get("ClassCode")));
									setMap.put("languageID", languageID);
									Map linkInfo = commonService.select("link_SQL.getLinkListFromAttAlloc", setMap);
									String linkUrl = ""; String lovCode = ""; String attrTypeCode = ""; String linkImg = "blank.png";
									
									if(!linkInfo.isEmpty()){
										linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
										lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
										attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
										if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
									}
									
									resultRow += "<row open='1' id='" + itemID03+itemID02 + "'>";
									resultRow += "	<cell image='" + StringUtil.checkNull(elmProgramInfo03.get("ItemTypeImg"))+ "'> " 
																				 + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmProgramInfo03.get("Identifier"))) 
																				 +" "+ StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmProgramInfo03.get("ItemName"))) + CELL_CLOSE;
									resultRow += CELL;
									resultRow += CELL;
									resultRow += CELL_OPEN + linkImg + CELL_CLOSE;
									resultRow += CELL_OPEN + StringUtil.checkNull(elmProgramInfo03.get("ItemID")) + CELL_CLOSE;
									resultRow += CELL_OPEN + linkUrl + CELL_CLOSE;
									resultRow += CELL_OPEN + lovCode + CELL_CLOSE;
									resultRow += CELL_OPEN + attrTypeCode +  CELL_CLOSE;			
									resultRow += CELL;
									resultRow += CELL;
									resultRow += CELL;
									resultRow += CELL;
									
									//////////////////////////////// ACTIVITY FROM PROGRAMID ////////////////////////////////////////////////////////////////////////////////////////////
									setMap = new HashMap(); 
									setMap.put("procInstNo", procInstNo);
									setMap.put("itemID", itemID03);
									setMap.put("languageID", languageID);
									List elmInstActivityList = commonService.selectList("instance_SQL.getElmInstActivityListFromProgramID", setMap); 
									for (int j = 0; j < elmInstActivityList.size(); j++){
										Map elmActivityInfo = (Map) elmInstActivityList.get(j);
										
										setMap.put("instanceNo", StringUtil.checkNull(elmActivityInfo.get("ElmInstNo")));
										setMap.put("attrTypeCode", "AT00402");
										String AT00402 = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstAttrValue", setMap),"");
										
										String AT00402Style = "gray";
										if(AT00402.equals("LV40201")) AT00402Style = "blue";
										if(AT00402.equals("LV40202")) AT00402Style = "red";
										
										resultRow += "<row open='1' id='" + StringUtil.checkNull(elmActivityInfo.get("ItemID")) + itemID03 + "'>";
										resultRow += "	<cell image='" + StringUtil.checkNull(elmActivityInfo.get("Icon"))+ "'> " 
																					 + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmActivityInfo.get("Identifier"))) 
																					 +" "+ StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmActivityInfo.get("ItemName"))) + CELL_CLOSE;
										resultRow += CELL_OPEN + StringUtil.checkNull(elmActivityInfo.get("Path")) + CELL_CLOSE;
										resultRow += CELL_OPEN + StringUtil.checkNull(elmActivityInfo.get("RoleItemName")) + CELL_CLOSE;
										resultRow += CELL_OPEN + "blank.png" + CELL_CLOSE;
										resultRow += CELL_OPEN + StringUtil.checkNull(elmActivityInfo.get("ItemID")) + CELL_CLOSE;
										resultRow += CELL;
										resultRow += CELL;
										resultRow += CELL;
										resultRow += "<cell style='"+StringUtil.checkNull(elmActivityInfo.get("StatusStyle"))+"'>" +StringUtil.checkNull(elmActivityInfo.get("StatusName")) + CELL_CLOSE;
										resultRow += CELL_OPEN + AT00402Style + CELL_CLOSE;
										resultRow += CELL;
										resultRow += CELL_OPEN + StringUtil.checkNull(elmActivityInfo.get("ElmInstNo")) + CELL_CLOSE;
										resultRow += ROW_CLOSE; 
									}
									
									////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
									
									for (int i5 = 0; i5 < elmInstProgramList.size(); i5++){
										Map elmProgramInfo04 = (Map) elmInstProgramList.get(i5);
										String itemID04 = StringUtil.checkNull(elmProgramInfo04.get("ItemID"));
										String fromItemID04 = StringUtil.checkNull(elmProgramInfo04.get("FromItemID"));
										if(fromItemID04.equals(itemID03)) {
											setMap = new HashMap();								
											setMap.put("itemID", itemID04);
											setMap.put("itemClassCode", StringUtil.checkNull(elmProgramInfo04.get("ClassCode")));
											setMap.put("languageID", languageID);
											linkInfo = commonService.select("link_SQL.getLinkListFromAttAlloc", setMap);
											linkUrl = ""; lovCode = ""; attrTypeCode = "";linkImg = "blank.png";
											
											if(!linkInfo.isEmpty()){
												linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
												lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
												attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
												if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
											}
											
											resultRow += "<row open='1' id='" + itemID04 +  itemID03 + "'>";
											resultRow += "<cell image='" + StringUtil.checkNull(elmProgramInfo04.get("ItemTypeImg"))+ "'> " 
																						 + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmProgramInfo04.get("Identifier"))) 
																						 +" "+ StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmProgramInfo04.get("ItemName"))) + CELL_CLOSE;
											resultRow += CELL;
											resultRow += CELL;
											resultRow += CELL_OPEN + linkImg + CELL_CLOSE;
											resultRow += CELL_OPEN + StringUtil.checkNull(elmProgramInfo04.get("ItemID")) + CELL_CLOSE;
											resultRow += CELL_OPEN + linkUrl + CELL_CLOSE;
											resultRow += CELL_OPEN + lovCode + CELL_CLOSE;
											resultRow += CELL_OPEN + attrTypeCode +  CELL_CLOSE;			
											resultRow += CELL;
											resultRow += CELL;
											resultRow += CELL;
											resultRow += CELL;
											
											//////////////////////////////// ACTIVITY FROM PROGRAMID ////////////////////////////////////////////////////////////////////////////////////////////
											setMap = new HashMap(); 
											setMap.put("procInstNo", procInstNo);
											setMap.put("itemID", itemID04);
											setMap.put("languageID", languageID);
											elmInstActivityList = commonService.selectList("instance_SQL.getElmInstActivityListFromProgramID", setMap); 
											for (int k = 0; k < elmInstActivityList.size(); k++){
												Map elmActivityInfo = (Map) elmInstActivityList.get(k);
												
												setMap.put("instanceNo", StringUtil.checkNull(elmActivityInfo.get("ElmInstNo")));
												setMap.put("attrTypeCode", "AT00402");
												String AT00402 = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstAttrValue", setMap),"");
												
												String AT00402Style = "gray";
												if(AT00402.equals("LV40201")) AT00402Style = "blue";
												if(AT00402.equals("LV40202")) AT00402Style = "red";
												
												resultRow += "<row open='1' id='" + StringUtil.checkNull(elmActivityInfo.get("ItemID"))+itemID04 + "'>";
												resultRow += "<cell image='" + StringUtil.checkNull(elmActivityInfo.get("Icon"))+ "'> " 
																							 + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmActivityInfo.get("Identifier"))) 
																							 +" "+ StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmActivityInfo.get("ItemName"))) + CELL_CLOSE;
												resultRow += CELL_OPEN + StringUtil.checkNull(elmActivityInfo.get("Path")) + CELL_CLOSE;
												resultRow += CELL_OPEN + StringUtil.checkNull(elmActivityInfo.get("RoleItemName")) + CELL_CLOSE;
												resultRow += CELL_OPEN + "blank.png" + CELL_CLOSE;
												resultRow += CELL;
												resultRow += CELL;
												resultRow += CELL;
												resultRow += CELL;
												resultRow += "<cell style='"+StringUtil.checkNull(elmActivityInfo.get("StatusStyle"))+"'>" +StringUtil.checkNull(elmActivityInfo.get("StatusName")) + CELL_CLOSE;
												resultRow += CELL_OPEN + AT00402Style + CELL_CLOSE;
												resultRow += CELL;
												resultRow += CELL_OPEN + StringUtil.checkNull(elmActivityInfo.get("ElmInstNo")) + CELL_CLOSE;
												resultRow += ROW_CLOSE; 
											}
											
											////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////											
											resultRow += ROW_CLOSE; 
										}
									}
									resultRow += ROW_CLOSE; 
								}
							}
							resultRow += ROW_CLOSE; 
						}
					}
					resultRow += ROW_CLOSE; // 0
				}
			}			
			result += resultRow;
			result += "</row>"; 
			result += "</rows>";
		}
		System.out.println("result :"+result);
		return result.replace("&", "/"); // 특수 문자 제거
	}

	@RequestMapping(value="/viewTCRoleTree.do")
	public String viewTCRoleTree(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "/app/pim//instance/tc/viewTCRoleTree";
		List GRList = new ArrayList();
		Map setMap = new HashMap();
		List<Map<String, Object>> list= new ArrayList();
		try {
			String modelID = StringUtil.checkNull(request.getParameter("procModelID"), "");
			String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"), "");
			String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"), "");
			String processID = StringUtil.checkNull(request.getParameter("processID"), "");
//			String searchValue = StringUtil.checkNull(request.getParameter("searchValue"), "");
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			
			setMap.put("languageID", languageID);
			setMap.put("ItemID", processID);
			setMap.put("modelID", modelID);
			setMap.put("attrTypeCode", "AT00036");

			setMap.put("ModelID", modelID);
			
			setMap.put("languageID", languageID);
			setMap.put("ItemID", processID);
			setMap.put("modelID", modelID);
			setMap.put("attrTypeCode", "AT00036");

			setMap.put("ModelID", modelID);
			Map modelMap = commonService.select("model_SQL.getModelViewer", setMap);
			
			setMap.put("procInstNo", instanceNo);
			List elmInstRoleList = commonService.selectList("instance_SQL.getElmInstRoleList", setMap);
			
			
			setMap.put("instanceNo", instanceNo);
			setMap.put("instanceClass", instanceClass);
			Map procInstanceInfo = commonService.select("instance_SQL.getProcInstanceInfo", setMap);			
			model.put("procInstanceInfo", procInstanceInfo);	
			
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			setMap.put("defaultLang", defaultLang);
			setMap.put("languageID", languageID);
			setMap.put("s_itemID", processID);
			/* 기본정보 내용 취득 */
			List prcList = commonService.selectList("report_SQL.getItemInfo", setMap);
			Map prcMap = (Map) prcList.get(0);			
			model.put("prcMap",prcMap);
			
			model.put("procModelID",modelID);
			model.put("instanceNo", instanceNo);
			model.put("instanceClass", instanceClass);
	        model.put("nodeID", processID);
//	        model.put("elmTreeXml",getTCRoleXML(modelMap, elmInstRoleList, languageID, instanceNo));
	        
	        modelMap.put("itemName", "<img src='"+GlobalVal.HTML_IMG_DIR_ITEM+"/img_sitemap.png' />"+modelMap.get("ModelName")+"("+modelMap.get("MCName")+")");
	        modelMap.put("id", "1");
	        
	        list.add(modelMap);
	        
	        for (int i = 0; i < elmInstRoleList.size(); i++){
	        	Map map = (Map) elmInstRoleList.get(i);
	        	map.put("parent", "1");
				map.put("id", StringUtil.checkNull(map.get("ItemID")));
				map.put("itemName", "<img src='"+GlobalVal.HTML_IMG_DIR_ITEM+"/"+StringUtil.checkNull(map.get("ItemTypeImg"))+"' />"+StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("Identifier"))) +" "+ StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(map.get("RoleName"))));
				
				list.add(map);
				
				//////////////////////////////Activity//////////////////////////////////////////////
				setMap = new HashMap(); 
				setMap.put("procInstNo", instanceNo);
				setMap.put("itemID", StringUtil.checkNull(map.get("ItemID")));
				setMap.put("languageID", languageID);
				List elmInstActivityList = commonService.selectList("instance_SQL.getElmInstActivityListFromRoleID", setMap); 
				for(int i2 = 0; i2 < elmInstActivityList.size(); i2++){
					Map elmInstActivityInfo = (Map) elmInstActivityList.get(i2);
					elmInstActivityInfo.put("parent", StringUtil.checkNull(map.get("ItemID")));
					elmInstActivityInfo.put("id", StringUtil.checkNull(elmInstActivityInfo.get("ItemID")));								
					elmInstActivityInfo.put("itemName", "<img src='"+GlobalVal.HTML_IMG_DIR_ITEM+"/"+StringUtil.checkNull(elmInstActivityInfo.get("Icon"))+"' />"+StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmInstActivityInfo.get("Identifier"))) +" "+ StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmInstActivityInfo.get("ItemName"))));
					elmInstActivityInfo.put("Path", StringUtil.checkNull(elmInstActivityInfo.get("Path")));
					
					list.add(elmInstActivityInfo);
					/////////////////////////PROGRAM/////////////////////////////////////////////////////
					setMap = new HashMap(); 
					setMap.put("procInstNo", instanceNo);
					setMap.put("itemID", StringUtil.checkNull(elmInstActivityInfo.get("ItemID")));
					setMap.put("languageID", languageID);
					
					List elmInstProgramList = commonService.selectList("instance_SQL.getElmInstProgramList", setMap); 
					for(int i3 = 0; i3 < elmInstProgramList .size(); i3++){ 
						Map elmInstProgramInfo = (Map) elmInstProgramList .get(i3);
						
						setMap = new HashMap();								
						setMap.put("itemID", StringUtil.checkNull(elmInstProgramInfo.get("ItemID")));
						setMap.put("itemClassCode", StringUtil.checkNull(elmInstProgramInfo.get("ClassCode")));
						setMap.put("languageID", languageID);
						Map linkInfo = commonService.select("link_SQL.getLinkListFromAttAlloc", setMap);
						String linkUrl = ""; String lovCode = ""; String attrTypeCode = ""; String linkImg = "blank.png";
						
						if(!linkInfo.isEmpty()){
							linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
							lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
							attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
							if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
						}
						
						setMap.put("instanceNo", StringUtil.checkNull(elmInstProgramInfo.get("ElmInstNo")));
						setMap.put("attrTypeCode", "AT00402"); 
						String AT00402 = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstAttrValue", setMap),"");
						String AT00402Style = "gray";
						if(AT00402.equals("LV40201")) AT00402Style = "blue"; if(AT00402.equals("LV40202")) AT00402Style = "red";
						
						elmInstProgramInfo.put("parent", StringUtil.checkNull(elmInstActivityInfo.get("ItemID")));
						elmInstProgramInfo.put("id", StringUtil.checkNull(elmInstProgramInfo.get("ElmInstNo")));
						elmInstProgramInfo.put("itemName", "<img src='"+GlobalVal.HTML_IMG_DIR_ITEM+"/"+StringUtil.checkNull(elmInstProgramInfo.get("ItemTypeImg"))+"' />"+StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmInstProgramInfo.get("Identifier"))) +" "+ StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmInstProgramInfo.get("ItemName"))));
						elmInstProgramInfo.put("Path", StringUtil.checkNull(elmInstProgramInfo.get("Path")));
						elmInstProgramInfo.put("linkImg", linkImg);
						elmInstProgramInfo.put("linkUrl", linkUrl);
						elmInstProgramInfo.put("lovCode", lovCode);
						elmInstProgramInfo.put("attrTypeCode", attrTypeCode);
						elmInstProgramInfo.put("statusName", "<span style='"+StringUtil.checkNull(elmInstProgramInfo.get("StatusStyle"))+"'>"+StringUtil.checkNull(elmInstProgramInfo.get("StatusName"))+"</span>");
						elmInstProgramInfo.put("AT00402Style", AT00402Style);
						elmInstProgramInfo.put("ElmInstNo", StringUtil.checkNull(elmInstProgramInfo.get("ElmInstNo")));
						elmInstProgramInfo.put("CxnItemID", StringUtil.checkNull(elmInstProgramInfo.get("ItemID")));
						
						list.add(elmInstProgramInfo);
					}
				}
	        }
	        
	        JSONArray treeGridData = new JSONArray(list);
	        model.put("treeGridData",treeGridData);
	        
	        model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);		
	}
	
	private String getTCRoleXML(Map modelMap, List elmInstRoleList, String languageID,String procInstNo) throws Exception {
		Map setMap = new HashMap();
		List subItemList = new ArrayList();
		String ModelName= "";
		
		String CELL = "	<cell></cell>";
		String CELL_CHECK = "	<cell>0</cell>";
		String CELL_OPEN = "	<cell>";
		String CELL_CLOSE = "</cell>";
		String ROW_CLOSE = "</row>";
		
		// row ID 를 unique 하게 설정 하기 위한 seq
		String result = "";
		String resultRow = "";
		if (elmInstRoleList.size() > 0) {
			ModelName = (StringUtil.checkNull(modelMap.get("ModelName"))).replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ");	
			
			result += "<rows>";
			result += "<row id='1' open='1'>";
			result += "	<cell image='img_sitemap.png' style='font-weight:bold;text-align: left;'> " + ModelName.replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ")
					+"("+modelMap.get("MCName")+")"+ "</cell>";
			
				for (int i = 0; i < elmInstRoleList.size(); i++){
					Map elmInstRoleInfo = (Map) elmInstRoleList.get(i);
					
					resultRow += "<row open='1' id='" + StringUtil.checkNull(elmInstRoleInfo.get("ItemID")) + "'>";
					resultRow += "	<cell image='" + StringUtil.checkNull(elmInstRoleInfo.get("ItemTypeImg"))+ "'> " 
																 + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmInstRoleInfo.get("Identifier"))) 
																 +" "+ StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmInstRoleInfo.get("RoleName"))) + CELL_CLOSE;
					
					//////////////////////////////Activity//////////////////////////////////////////////
				
				  setMap = new HashMap(); 
				  setMap.put("procInstNo", procInstNo);
				  setMap.put("itemID", StringUtil.checkNull(elmInstRoleInfo.get("ItemID")));
				  setMap.put("languageID", languageID);
				  List elmInstActivityList = commonService.selectList("instance_SQL.getElmInstActivityListFromRoleID", setMap); 
				  for(int i2 = 0; i2 < elmInstActivityList.size(); i2++){ 
					  Map elmInstActivityInfo = (Map) elmInstActivityList.get(i2);	
					  
					  resultRow += "<row open='1' id='" + StringUtil.checkNull(elmInstActivityInfo.get("ItemID")) + StringUtil.checkNull(elmInstRoleInfo.get("ItemID"))+ "'>"; 
					  resultRow += "	<cell image='" + StringUtil.checkNull(elmInstActivityInfo.get("Icon"))+ "'> " 
							  									 + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmInstActivityInfo.get("Identifier"))) +" "
							  									 + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmInstActivityInfo.get("ItemName"))) 
							  									 + CELL_CLOSE; 
					  resultRow += CELL_OPEN + StringUtil.checkNull(elmInstActivityInfo.get("Path")) + CELL_CLOSE;
					  resultRow += CELL_OPEN + "blank.png" + CELL_CLOSE;
					  resultRow += CELL; 
					  resultRow += CELL; 
					  resultRow += CELL; 
					  resultRow += CELL; 
					  resultRow += CELL; //"<cell style='"+StringUtil.checkNull(elmInstActivityInfo.get("StatusStyle"))+"'>" +StringUtil.checkNull(elmInstActivityInfo.get("StatusName")) + CELL_CLOSE;
					  resultRow += CELL;
					  resultRow += CELL; 
					  resultRow += CELL; // CELL_OPEN + StringUtil.checkNull(elmInstActivityInfo.get("ElmInstNo")) + CELL_CLOSE;
					  
					  /////////////////////////PROGRAM/////////////////////////////////////////////////////
					  
					  setMap = new HashMap(); 
					  setMap.put("procInstNo", procInstNo);
					  setMap.put("itemID", StringUtil.checkNull(elmInstActivityInfo.get("ItemID")));
					  setMap.put("languageID", languageID);
					  
					  List elmInstProgramList = commonService.selectList("instance_SQL.getElmInstProgramList", setMap); 
					  for(int i3 = 0; i3 < elmInstProgramList .size(); i3++){ 
						  Map elmInstProgramInfo = (Map) elmInstProgramList .get(i3);
						  
						  setMap = new HashMap();								
						  setMap.put("itemID", StringUtil.checkNull(elmInstProgramInfo.get("ItemID")));
						  setMap.put("itemClassCode", StringUtil.checkNull(elmInstProgramInfo.get("ClassCode")));
						  setMap.put("languageID", languageID);
						  Map linkInfo = commonService.select("link_SQL.getLinkListFromAttAlloc", setMap);
						  String linkUrl = ""; String lovCode = ""; String attrTypeCode = ""; String linkImg = "blank.png";
						
						  if(!linkInfo.isEmpty()){
							  linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
							  lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
							  attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
							  if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
						  }
						  
						  setMap.put("instanceNo", StringUtil.checkNull(elmInstProgramInfo.get("ElmInstNo")));
						  setMap.put("attrTypeCode", "AT00402"); 
						  String AT00402 = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstAttrValue", setMap),"");
						  String AT00402Style = "gray";
						  if(AT00402.equals("LV40201")) AT00402Style = "blue"; if(AT00402.equals("LV40202")) AT00402Style = "red";
					  
						  resultRow += "<row open='1' id='" + StringUtil.checkNull(elmInstProgramInfo.get("ItemID")) + StringUtil.checkNull(elmInstActivityInfo.get("ItemID")) + "'>"; 
						  resultRow += "	<cell image='" + StringUtil.checkNull(elmInstProgramInfo.get("ItemTypeImg"))+ "'> " 
								  									 + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmInstProgramInfo.get("Identifier"))) +" "
								  									 + StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(elmInstProgramInfo.get("ItemName"))) 
								  									 + CELL_CLOSE; 
						  resultRow += CELL_OPEN + StringUtil.checkNull(elmInstProgramInfo.get("Path")) + CELL_CLOSE;
						  resultRow += CELL_OPEN + linkImg + CELL_CLOSE;
						  resultRow += CELL_OPEN + StringUtil.checkNull(elmInstProgramInfo.get("ItemID")) + CELL_CLOSE;
						  resultRow += CELL_OPEN + linkUrl + CELL_CLOSE;
						  resultRow += CELL_OPEN + lovCode + CELL_CLOSE;
						  resultRow += CELL_OPEN + attrTypeCode +  CELL_CLOSE;	
						  resultRow += "<cell style='"+StringUtil.checkNull(elmInstProgramInfo.get("StatusStyle"))+"'>" +StringUtil.checkNull(elmInstProgramInfo.get("StatusName")) + CELL_CLOSE;
						  resultRow += CELL_OPEN + AT00402Style + CELL_CLOSE;
						  resultRow += CELL; 
						  resultRow += CELL_OPEN + StringUtil.checkNull(elmInstProgramInfo.get("ElmInstNo")) + CELL_CLOSE;
						  resultRow += ROW_CLOSE;
					  }
					  /////////////////////////////////////////////////////////////////////////////////////////
					  resultRow += ROW_CLOSE;
				  }
				///////////////////////////////////////////////////////////////////////////////////
					resultRow += ROW_CLOSE; 
				}
			}
		result += resultRow;
		result += "</row>"; 
		result += "</rows>";
	
		System.out.println("result :"+result);
		return result.replace("&", "/"); // 특수 문자 제거
	}
}
