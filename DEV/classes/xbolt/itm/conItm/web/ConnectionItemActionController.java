package xbolt.itm.conItm.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.org.json.JSONArray;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DimTreeAdd;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
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
public class ConnectionItemActionController extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "CSService")
	private CommonService CSService;
	
	@Resource(name = "CxnItemService")
	private CommonService CxnItemService;
		
	@RequestMapping(value = "/DELCNItems.do")
	public String DELCNItems(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap target = new HashMap();
		model.put("option", StringUtil.checkNull(request.getParameter("option")));
		model.put("s_itemID", request.getParameter("s_itemID"));
		String alertType = StringUtil.checkNull(request.getParameter("alertType"), "");
		try {
			String curChangeSet = StringUtil.checkNull(commonService.selectString("item_SQL.getItemCurChangeSet", commandMap));
			
			String[] arrayStr = StringUtil.checkNull(request.getParameter("items"), "").split(",");
			if (arrayStr != null) {
				for (int i = 0; i < arrayStr.length; i++) {
					Map setMap = new HashMap();

					String s_itemIDs = arrayStr[i];

					setMap.put("FromItemID", request.getParameter("s_itemID"));
					setMap.put("ToItemID", s_itemIDs);
					setMap.put("curChangeSet", curChangeSet);
					setMap.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
					
					// 관계 아이템의 Item_Attr 데이터를 모두 삭제
					commonService.update("item_SQL.updateCNItemDeleted",setMap); 
					
				}
			}
			
			// [조직 연관항목]에서 delete할 경우, 해당 화면을 Reload해 준다.
			String ajaxScript = "";
			if ("Y".equals(StringUtil.checkNull(request.getParameter("isOrg")))) {
				ajaxScript = "this.urlReload();";
			}
			
			if(alertType.equals("DHX")) {
				target.put(AJAX_ALERT_DHX, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			}			
			target.put(AJAX_SCRIPT, ajaxScript + "this.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			if(alertType.equals("DHX")) {
				target.put(AJAX_ALERT_DHX, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
			} else {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
			}		
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
				
	@RequestMapping(value = "/newPertinentListGrid.do")
	public String newPertinentListGrid(HttpServletRequest request,
			ModelMap model) throws Exception {

		Map setMap = new HashMap();

		try {
			setMap.put("languageID", request.getParameter("languageID"));
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

			model.put("menu", getLabel(request, commonService));	/*Label Setting*/

			model.put("s_itemID", setID);
			model.put("option", request.getParameter("option"));

			setMap.put("s_itemID", s_itemID);

			model.put("ItemTypeCode", commonService.selectString(
					"config_SQL.getItemTypeCodeItemID", setMap));

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/itm/connection/newPertinentListGrid");
	}


	@RequestMapping(value = "/createCxnItem_ORG.do")
	public String createCxnItem_ORG(HttpServletRequest request, HashMap commandMap, ModelMap model)	throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		Map insertData = new HashMap();
		model.put("option", request.getParameter("option"));

		String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");
		String cxnItemType = StringUtil.checkNull(request.getParameter("cxnItemType")); 
		String cxnClassCode = StringUtil.checkNull(request.getParameter("cxnClassCode")); 
		String categoryCode = StringUtil.checkNull(request.getParameter("categoryCode"));
		String strType = StringUtil.checkNull(request.getParameter("strType"));
		String strItemID = StringUtil.checkNull(request.getParameter("strItemID"), "");
		String structureID = StringUtil.checkNull(request.getParameter("structureID"), "");
		String strLevel = StringUtil.checkNull(request.getParameter("strLevel"), "0");
		
		setMap.put("Version", "1");			
		setMap.put("Deleted", "0");
		setMap.put("ProjectID", request.getParameter("ProjectID"));
		setMap.put("Creator", StringUtil.checkNull(commandMap.get("sessionUserId"),""));
		setMap.put("OwnerTeamId",StringUtil.checkNull(commandMap.get("sessionTeamId"),""));
		setMap.put("AuthorID",StringUtil.checkNull(commandMap.get("sessionUserId"),""));
		setMap.put("Status","NEW1");
		String curChangeSet = StringUtil.checkNull(commonService.selectString("item_SQL.getItemCurChangeSet", commandMap));
		setMap.put("CurChangeSet", curChangeSet);
		
		String connectionType = StringUtil.checkNull(request.getParameter("connectionType"));
		if(connectionType.equals("")){
			setMap.put("itemTypeCode", StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCode", commandMap)) );
			setMap.put("cxnTypeCode", StringUtil.checkNull(request.getParameter("cxnTypeCode")));
			Map cxnTypeInfo = (Map)commonService.select("item_SQL.getCxnTypeInfo", setMap);
			connectionType = StringUtil.checkNull(cxnTypeInfo.get("CxnType"));
		}
		if(!curChangeSet.equals("")){
			Map setData = new HashMap();
			setData.put("s_itemID", curChangeSet);
			setMap.put("ProjectID",StringUtil.checkNull(commonService.selectString("cs_SQL.getProjectIDForCSID", setData)));
		}
		try {
			String[] arrayStr = StringUtil.checkNull(request.getParameter("items"), "").split(",");

			if (arrayStr != null) {
				for (int i = 0; i < arrayStr.length; i++) {
					String t_itemID = arrayStr[i];
					setMap.put("ItemID", commonService.selectString("item_SQL.getItemMaxID", setMap));
					
					if (connectionType.equals("From")) {
						setMap.put("FromItemID", s_itemID);
						setMap.put("ToItemID", t_itemID);	
						if(strType.equals("2")){
														
							Map setValue = new HashMap();
							setValue.put("itemID", t_itemID);											
							cxnClassCode = commonService.selectString("item_SQL.getSubStrItemClassCode", setValue);
							setMap.put("ClassCode", cxnClassCode);
							setMap.put("ParentID", strItemID);		
							setMap.put("StructureID", structureID);	
							setMap.put("Level", Integer.parseInt(strLevel)+1);				
						}
						if(cxnItemType.equals("")){ cxnItemType = StringUtil.checkNull(commonService.selectString("item_SQL.getCXNItemTypeCode",setMap), ""); }
					} else {
						setMap.put("ToItemID", s_itemID);
						setMap.put("FromItemID", t_itemID);							
						if(cxnItemType.equals("")){ cxnItemType = StringUtil.checkNull(commonService.selectString("item_SQL.getCXNItemTypeCode",setMap), ""); }
					}			
					if (cxnItemType.equals("")) {
						target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00077", new String[]{t_itemID}));
					}	
				
					setMap.put("ItemTypeCode", cxnItemType);
					if(categoryCode.equals("")){ categoryCode = StringUtil.checkNull( commonService.selectString("item_SQL.selectItemTypeCategory", setMap), "CN"); }
					setMap.put("CategoryCode", categoryCode);
					//setMap.put("ClassCode", StringUtil.checkNull( commonService.selectString("item_SQL.selectItemClassCodePertinent", setMap), "NL00000"));
					if(cxnClassCode.equals("")){
						cxnClassCode = StringUtil.checkNull( commonService.selectString("item_SQL.selectItemClassCodePertinent", setMap), "NL00000");
					}
					setMap.put("ClassCode", cxnClassCode);
					
					String existItem = StringUtil.checkNull(commonService.selectString("item_SQL.getConItemID", setMap)); // deleted != 0 				
					if(existItem.equals("") || existItem == null){						
							commonService.insert("item_SQL.insertItem", setMap);
					}else{ // update 이미 삭제된(deleted = 1) -> deleted = 0 
						setMap.put("deleted", "0");
						setMap.put("ItemID",existItem);
						setMap.put("LastUser", commandMap.get("sessionUserId"));
						commonService.update("item_SQL.updateItem", setMap);
					}
					
					/* 신규 생성된 CXN ITEM의 ITEM_CLASS.ChangeMgt = 1 일 경우, CHANGE_SET 테이블에 레코드 생성  */
					insertData = new HashMap();
					String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setMap));
					String itemID = StringUtil.checkNull(setMap.get("ItemID"));
					insertData.put("itemID", itemID);
					String projectID = commonService.selectString("item_SQL.getProjectIDFromItem", insertData);
					
					if (changeMgt.equals("1")) {
						/* Insert to TB_CHANGE_SET */
						insertData.put("itemID", itemID);
						insertData.put("userId", StringUtil.checkNull(commandMap.get("sessionUserId")));
						insertData.put("projectID", projectID);
						insertData.put("classCode", cxnClassCode);
						insertData.put("KBN", "insertCNG");
						insertData.put("status", "MOD");
						CSService.save(new ArrayList(), insertData);						
					}
					
					setMap.remove("FromItemID");
					setMap.remove("ToItemID");	
					setMap.remove("ParentID");
				}
			}		
			if(!GlobalVal.BASE_ATCH_URL.equals("daelim"))
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			
			target.put(AJAX_SCRIPT, "$('.popup_div').hide();$('#mask').hide();this.thisReload();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/createCxnItem.do")
	public String createCxnItem(HttpServletRequest request, HashMap commandMap, ModelMap model)	throws Exception {
		
		HashMap target = new HashMap();
		try {
			model.put("option", request.getParameter("option"));
				
			String[] arrayStr = StringUtil.checkNull(request.getParameter("items"), "").split(",");

			if (arrayStr != null) {
				for (int i = 0; i < arrayStr.length; i++) {
					String t_itemID = StringUtil.checkNull(arrayStr[i]);
					commandMap.put("toItemID", t_itemID);
					CxnItemService.save(commandMap);
				}
			}
		
			if(!GlobalVal.BASE_ATCH_URL.equals("daelim"))
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			
			target.put(AJAX_SCRIPT, "$('.popup_div').hide();$('#mask').hide();this.thisReload();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	// 프로세스 - 관련 프로세스 Tree List
	@RequestMapping(value = "/processTreeDiagramPop.do")
	public String processTreeDiagramPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		
		String url = "/project/changeInfo/processTreeDiagramPop";
		Map setMap = new HashMap();
		
		try {
			List returnData = new ArrayList();
			List prcList = new ArrayList();

			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
						
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("s_itemID", s_itemID);
			model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID")));
			model.put("cngtID", StringUtil.checkNull(request.getParameter("cngtID")));
			
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("viewType", "prcDlg");
			returnData = (List) commonService.selectList("attr_SQL.getItemNameInfo", setMap);
			String itemName = ""; String classIcon = "";
			if (returnData.size() > 0) {
				HashMap dtlData = (HashMap) returnData.get(0);
				itemName = (StringUtil.checkNull(dtlData.get("PlainText"))).replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ");
				itemName = StringUtil.checkNull(dtlData.get("Identifier"))
						+ " " + itemName;
				classIcon = StringUtil.checkNull(dtlData.get("Icon"));
			}
			returnData = (List) commonService.selectList("item_SQL.getCxnItemList_gridList", setMap);
			prcList = (List) commonService.selectList("item_SQL.getSubItemList_gridList", setMap);
			
			model.put("prcTreeXml", setProcessXML(s_itemID, itemName, returnData, prcList, classIcon, StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),"")));
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
    //중복제거 메소드, key는 제거할 맵 대상
    public static List<HashMap<Object, Object>> distinctArray(List<HashMap<Object, Object>> target, Object key){ 
        if(target != null){
            target = target.stream().filter(distinctByKey(o-> o.get(key))).collect(Collectors.toList());
        }
        return target;
    }

    //중복 제거를 위한 함수
    public static <T> Predicate<T> distinctByKey(Function<? super T,Object> keyExtractor) {
        Map<Object,Boolean> seen = new ConcurrentHashMap<>();
        return t -> seen.putIfAbsent(keyExtractor.apply(t), Boolean.TRUE) == null;
	    
	}
    
    @RequestMapping(value = "/cxnItemTreeMgt.do")
	public String cxnItemTreeMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/itm/connection/cxnItemTreeMgt";
		try {
			List prcList = new ArrayList();

			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"), "");		
			String childCXN = StringUtil.checkNull(request.getParameter("childCXN"), "");	
			String reqCxnTypeList[] = StringUtil.checkNull(request.getParameter("cxnTypeList"), "").split(",");	
			String cxnTypeList = "";
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			if (!StringUtil.checkNull(request.getParameter("cxnTypeList"), "").equals("")) {
				for (int i = 0; i < reqCxnTypeList.length; i++) {
					if(i==0) {
						cxnTypeList = "'"+reqCxnTypeList[i]+"'";
					}else {
						cxnTypeList += ",'"+ reqCxnTypeList[i]+"'";
					}
				}
				cmmMap.put("cxnTypeList", cxnTypeList);
			}
			
			String reqnotInCxnClsList[] = StringUtil.checkNull(request.getParameter("notInCxnClsList"), "").split(",");	
			String notInCxnClsList = "";
			
			if (!StringUtil.checkNull(request.getParameter("notInCxnClsList"), "").equals("")) {
				for (int i = 0; i < reqnotInCxnClsList.length; i++) {
					if(i==0) {
						notInCxnClsList = "'"+reqnotInCxnClsList[i]+"'";
					}else {
						notInCxnClsList += ",'"+ reqnotInCxnClsList[i]+"'";
					}
				}
				cmmMap.put("notInCxnClsList", notInCxnClsList);
			}
						
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("option", request.getParameter("option"));
			model.put("filter", request.getParameter("varFilter"));
			
			cmmMap.put("languageID",languageID);		
			cmmMap.put("mdlIF", "Y");
			
			Map processInfo = (Map) commonService.select("attr_SQL.getItemNameInfo", cmmMap);
			
			String itemName = "";
			if (!processInfo.isEmpty()) {
				itemName = (StringUtil.checkNull(processInfo.get("PlainText"))).replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ").replaceAll("\"","&#34;");
				itemName = StringUtil.checkNull(processInfo.get("Identifier")) + " " + itemName;
				
				processInfo.put("TreeName", itemName);
			}
			List cxnItemGridList = new ArrayList();
		
			cxnItemGridList.add(processInfo);
			
			Map setData = new HashMap();
			setData.put("id", "cxnProcess");
			setData.put("parent", s_itemID);
			setData.put("TreeName", "Connected Process");
			setData.put("Icon", "ex_img_process.png");
			
			
			
			cmmMap.put("showElement", "Y");
			if(childCXN.equals("Y")){
				prcList = (List)commonService.selectList("item_SQL.getChildItemList_gridList", cmmMap);
			}else{
				prcList = (List) commonService.selectList("item_SQL.getSubItemList_gridList", cmmMap);
			}
			
			if(prcList.size() > 0) {
				cxnItemGridList.add(setData);
			}
			cxnItemGridList.addAll(prcList);
			
			
			List cxnItemList = (List) commonService.selectList("item_SQL.getCxnItemList_gridList", cmmMap);
			List cxnClassCodeList = new ArrayList();
			for(int i=0; i<cxnItemList.size(); i++) {
				Map cxnInfoMap = (Map)cxnItemList.get(i);
				String classCode = StringUtil.checkNull(cxnInfoMap.get("ClassCode"));				
				cxnClassCodeList.add(classCode);				
			}
			 
			List cxnItemList2 = (List) commonService.selectList("item_SQL.getCxnItemList_gridList", cmmMap); // Class List distinct 할것
	        List<HashMap<Object, Object>> cxnClassDistinctList = distinctArray(cxnItemList2, "ClassCode");
	        	        	        
	        if(cxnClassDistinctList.size()>0) {
	        	for(int i=0; i < cxnClassDistinctList.size(); i++) {
	        		Map cxnClassInfo = (Map)cxnClassDistinctList.get(i);
	        		String classCode = StringUtil.checkNull(cxnClassInfo.get("ClassCode"));
	        		String className = StringUtil.checkNull(cxnClassInfo.get("ClassName"));
	        		
	        		long count = cxnClassCodeList.stream().filter(str -> classCode.equals(str)).count();
	        		cxnClassInfo.put("id",classCode);
	        		cxnClassInfo.put("TreeName",className+"("+count+")");
	        		cxnClassInfo.put("parent", s_itemID);
	        		cxnClassInfo.put("LinkType", "");
	        		cxnClassInfo.put("ItemPath", "");
	        		cxnClassInfo.put("CXNItemID", "");
	        		cxnClassInfo.put("ItemID", "");
	        		cxnClassInfo.put("AuthorID", "");
	        		cxnClassInfo.put("StatusName", "");
	        		cxnClassInfo.put("Status", "");	  
	        		
	        		cxnItemGridList.add(cxnClassInfo);
	        		
	        		if(classCode.equals("CL05003") || classCode.equals("CL16004")){ // Hway SOP, STP  // if ((classCode.equals("CL05003")) || (classCode.equals("CL16004")))
	        			for(int ii=0; ii<cxnItemList.size(); ii++) {
		        			Map cxnItemListInfo = (Map)cxnItemList.get(ii);
		        			
	        				if(cxnItemListInfo.get("ClassCode").equals(classCode)) {
	        					Map cxnClassTeamInfo = new HashMap();	
			        			cxnClassTeamInfo.put("id",cxnItemListInfo.get("OwnerTeamID"));
			        			cxnClassTeamInfo.put("TreeName",cxnItemListInfo.get("OwnerTeamName"));
			        			cxnClassTeamInfo.put("parent", classCode);
			        			cxnClassTeamInfo.put("LinkType", "");
			        			cxnClassTeamInfo.put("ItemPath", "");
			        			cxnClassTeamInfo.put("CXNItemID", "");
			        			cxnClassTeamInfo.put("ItemID", "");
			        			cxnClassTeamInfo.put("AuthorID", "");
			        			cxnClassTeamInfo.put("StatusName", "");
			        			cxnClassTeamInfo.put("Status", "");	  
			        			cxnClassTeamInfo.put("ItemTypeImg", cxnItemListInfo.get("ItemTypeImg"));  
			        			cxnClassTeamInfo.put("IsTeamParent", "Y");
			        			
			        			cxnItemGridList.add(cxnClassTeamInfo);
        						
			        			for(int i2=0; i2<cxnItemList.size(); i2++) {
				    				Map cxnTeamDistinctInfoMap = (Map)cxnItemList.get(i2);
				    				Map setMap = new HashMap();
				    				String linkImg = "blank.png";
				    				
				    				if(StringUtil.checkNull(cxnTeamDistinctInfoMap.get("ClassCode")).equals(cxnItemListInfo.get("ClassCode")) && cxnTeamDistinctInfoMap.get("OwnerTeamID").equals(cxnItemListInfo.get("OwnerTeamID"))) {
					    				setMap.put("itemID", StringUtil.checkNull(cxnTeamDistinctInfoMap.get("ItemID"),""));
					    				setMap.put("languageID", languageID);
					    				setMap.put("itemClassCode", StringUtil.checkNull(cxnTeamDistinctInfoMap.get("ClassCode")));
					    				List linkList = commonService.selectList("link_SQL.getLinkListFromAttAlloc", setMap);
					    				String linkUrl = "";
					    				String lovCode = "";
					    				String attrTypeCode = "";
					    				
					    				if(linkList.size() > 0){
					    					Map linkInfo = (Map)linkList.get(0);
					    					linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
					    					lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
					    					attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
					    					if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
					    					cxnTeamDistinctInfoMap.put("linkImg", linkImg);
					    					cxnTeamDistinctInfoMap.put("linkUrl", linkUrl);
					    					cxnTeamDistinctInfoMap.put("lovCode", lovCode);
					    					cxnTeamDistinctInfoMap.put("attrTypeCode", attrTypeCode);
					    				}else {
					    					cxnTeamDistinctInfoMap.put("linkImg", linkImg);
					    				}
					    				
					    				String ownerTeamID = StringUtil.checkNull(cxnTeamDistinctInfoMap.get("OwnerTeamID"));
					    				cxnTeamDistinctInfoMap.put("parent", ownerTeamID);
					    				cxnTeamDistinctInfoMap.put("HaveTeamParent", "Y");
					    			
					    				cxnItemGridList.add(cxnTeamDistinctInfoMap);
				    				}
				    			}
	        				}
	        			}
		        		
	        		} else {
	        		
		        		for(int i2=0; i2<cxnItemList.size(); i2++) {
		    				Map cxnInfoMap = (Map)cxnItemList.get(i2);
		    				Map setMap = new HashMap();
		    				String linkImg = "blank.png";
		    				
		    				if(StringUtil.checkNull(cxnInfoMap.get("ClassCode")).equals(classCode)) {
			    				setMap.put("itemID", StringUtil.checkNull(cxnInfoMap.get("ItemID"),""));
			    				setMap.put("languageID", languageID);
			    				setMap.put("itemClassCode", StringUtil.checkNull(cxnInfoMap.get("ClassCode")));
			    				List linkList = commonService.selectList("link_SQL.getLinkListFromAttAlloc", setMap);
			    				String linkUrl = "";
			    				String lovCode = "";
			    				String attrTypeCode = "";
			    				
			    				if(linkList.size() > 0){
			    					Map linkInfo = (Map)linkList.get(0);
			    					linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
			    					lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
			    					attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
			    					if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
			    					cxnInfoMap.put("linkImg", linkImg);
			    					cxnInfoMap.put("linkUrl", linkUrl);
			    					cxnInfoMap.put("lovCode", lovCode);
			    					cxnInfoMap.put("attrTypeCode", attrTypeCode);
			    				}else {
			    					cxnInfoMap.put("linkImg", linkImg);
			    				}
			    				
			    				cxnItemGridList.add(cxnInfoMap);
		    				}
		    			}
	        		}
	    		
	        	}
	        }
	        
	        List<HashMap<Object, Object>> cxnItemGridListDis = distinctArray(cxnItemGridList, "id");  //GridList distinct 할것
	        
			JSONArray gridData = new JSONArray(cxnItemGridListDis);
			model.put("gridData", gridData);
		
			List itemIDs = new ArrayList();
			for(int i=0; i< cxnItemList.size(); i++){
				Map relatedItems = (Map)cxnItemList.get(i);
				itemIDs.add(relatedItems.get("s_itemID"));
			}
			
			for(int i=0; i< prcList.size(); i++){
				Map prcData = (Map)prcList.get(i);
				itemIDs.add(prcData.get("ItemID"));
			}

			model.put("itemIDs", itemIDs);
			model.put("screenMode", StringUtil.checkNull(request.getParameter("screenMode"), ""));
			
//			String sessionAuthLev = String.valueOf(cmmMap.get("sessionAuthLev")); // 시스템 관리자
//			Map itemAuthorMap = commonService.select("project_SQL.getItemAuthorIDAndLockOwner", cmmMap);
//			if ((StringUtil.checkNull(itemAuthorMap.get("AuthorID")).equals(StringUtil.checkNull(cmmMap.get("sessionUserId"))) 
//					|| StringUtil.checkNull(itemAuthorMap.get("LockOwner")).equals(StringUtil.checkNull(cmmMap.get("sessionUserId")))
//					|| "1".equals(sessionAuthLev))
//					&& "0".equals(StringUtil.checkNull(itemAuthorMap.get("Blocked")))) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", cmmMap);
			model.put("myItem", myItem);
			
			model.put("backBtnYN", request.getParameter("backBtnYN"));
			model.put("s_itemID", s_itemID);
			model.put("varFilter", StringUtil.checkNull(request.getParameter("varFilter"), ""));
			model.put("frameName", StringUtil.checkNull(request.getParameter("frameName"), ""));
			model.put("showElement", StringUtil.checkNull(request.getParameter("showElement"), ""));
			model.put("cxnTypeList", StringUtil.checkNull(request.getParameter("cxnTypeList"), ""));
			model.put("childCXN", childCXN);

		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}

	private String setProcessXML(String mainID, String itemName, List listData, List prcListData, String classIcon, String languageID) throws Exception {
		String CELL = "	<cell></cell>";
		String CELL_CHECK = "	<cell>0</cell>";
		String CELL_OPEN = "	<cell>";
		String CELL_CLOSE = "</cell>";
		String CLOSE = ">";
		String CELL_TOT = "";
		String ROW_OPEN = "<row id=";
		String ROW_CLOSE = "</row>";
		int rowCnt = 17;
		
		// row ID 를 unique 하게 설정 하기 위한 seq
		int rowId = 0;
		String linkImg = "blank.png";
		
		String result = "<rows>";
		String resultRow = "";
		result += "<row id='" + mainID + "' open='1' style='font-weight:bold'>";
		result += CELL_CHECK;
		result += "	<cell image='"+classIcon+"'> " + itemName.replace("<", "(").replace(">", ")")
				+ "</cell>";
		for (int i = 0; i < rowCnt; i++) {
			CELL_TOT += CELL;
			if (i == rowCnt - 1) {
				result += CELL_OPEN + mainID + CELL_CLOSE;
			} else if(i == 2) {
				result += CELL_OPEN +linkImg + CELL_CLOSE;
			} else {
				result += CELL;
			}
		}
		result += CELL;
		
		String statusColor = "#000000";
		String statusWeight = "normal";
		for (int i = 0; i < prcListData.size(); i++) {
			Map fstMap = (HashMap) prcListData.get(i);
			String fstClassCode = StringUtil.checkNull(fstMap.get("ClassCode"));
			String fstClassNm = " Connected Process"; // String fstClassNm = StringUtil.checkNull(fstMap.get("ClassName"));
			
			if(StringUtil.checkNull(fstMap.get("Status")).equals("NEW1")){
				statusColor = "blue";statusWeight = "bold";
			}else if(StringUtil.checkNull(fstMap.get("Status")).equals("MOD1") || StringUtil.checkNull(fstMap.get("Status")).equals("MOD2")){
				statusColor = "orange";statusWeight = "bold";
			}else{
				statusColor = "#000000";statusWeight = "normal";
			}
			
			if (i == 0) {
				resultRow += "<row id='" + fstClassCode + "' open='1' style='font-weight:bold'>";
				resultRow += CELL_CHECK;
				resultRow += "	<cell image='"
						+ StringUtil.checkNull(fstMap.get("ItemTypeImg"))
						+ "'> " + fstClassNm+ CELL_CLOSE;
				resultRow += CELL_OPEN +""+ CELL_CLOSE;
				resultRow += CELL_OPEN +""+ CELL_CLOSE;
				resultRow += CELL_OPEN +"blank_grey.png"+ CELL_CLOSE;
				resultRow += CELL_TOT;
				resultRow += "	" + CELL_OPEN + fstClassCode + CELL_CLOSE;
				
			}
			//resultRow += ROW_OPEN + "'"
			//		+ StringUtil.checkNull(fstMap.get("ItemID")) + "'>";
			resultRow+=ROW_OPEN+"'"+StringUtil.checkNull(fstMap.get("ItemID"))+ String.valueOf(rowId) +"'>";
			rowId++;
			
			resultRow += CELL_CHECK;
			resultRow += "		" + CELL_OPEN
//					+ StringUtil.checkNull(fstMap.get("ItemTypeImg"))
//					+ "'> "
					+ StringUtil.checkNull(fstMap.get("Identifier"))
					+ " "
					+ StringUtil.checkNull(fstMap.get("ItemName")).replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ").replaceAll("\"","&#34;") + CELL_CLOSE;
			resultRow += "		" + CELL_OPEN
					+ StringUtil.checkNull(fstMap.get("ItemPath")) + CELL_CLOSE;
			
			resultRow += "		" + CELL_OPEN +StringUtil.checkNull(fstMap.get("LinkType"))+ CELL_CLOSE;
			resultRow += "		" + CELL_OPEN +"blank.png"+ CELL_CLOSE;
			
			resultRow += "		" + CELL_OPEN
					+ StringUtil.checkNull(fstMap.get("TeamName")) + CELL_CLOSE;
			resultRow += "		" + CELL_OPEN
					+ StringUtil.checkNull(fstMap.get("OwnerTeamName"))
					+ CELL_CLOSE;
			resultRow += "		" + CELL_OPEN
					+ StringUtil.checkNull(fstMap.get("Name")) + CELL_CLOSE;
			resultRow += "		" + CELL_OPEN
					+ StringUtil.checkNull(fstMap.get("LastUpdated"))
					+ CELL_CLOSE;
			
			resultRow += "	    <cell style='color:"+statusColor+";font-weight:"+statusWeight+"'>" 
					+ StringUtil.checkNull(fstMap.get("StatusName"))
					+ CELL_CLOSE;
			resultRow += "		" + CELL_OPEN
					+ StringUtil.checkNull(fstMap.get("ItemID")) + CELL_CLOSE;
			resultRow += "		" + CELL_OPEN + fstClassCode + CELL_CLOSE;
			resultRow += "		" + CELL_OPEN + "" + CELL_CLOSE;
			resultRow += "		" + CELL_OPEN + "" + CELL_CLOSE;
			resultRow += "		" + CELL_OPEN + "" + CELL_CLOSE;
			resultRow += "		" + CELL_OPEN + "" + CELL_CLOSE;
			resultRow += "		" + CELL_OPEN + "" + CELL_CLOSE;
			resultRow += "		" + CELL_OPEN + StringUtil.checkNull(fstMap.get("AuthorID")) + CELL_CLOSE;
			resultRow += ROW_CLOSE;
			if (i == prcListData.size() - 1) {
				resultRow += ROW_CLOSE;
			}
		}
		
		List classList = new ArrayList();		
		List classNameList = new ArrayList();
		List itemTypeImgList = new ArrayList();
		List ownerTeamList = new ArrayList();
		List classCnt = new ArrayList();
		if(listData.size()>0){
			for(int i=0; i<listData.size(); i++){
				Map getData = (Map)listData.get(i);				
				if(!classList.contains(getData.get("ClassCode"))){
					classList.add(getData.get("ClassCode"));
					classNameList.add(getData.get("ClassName"));
					itemTypeImgList.add(getData.get("ItemTypeImg"));
					classCnt.add(getData.get("ClassCNT"));
				}
			}
		}
		String distinctClassCode = "";
		String classCode = "";
		if(classList.size()>0){			
			
			for(int j=0; j<classList.size(); j++){
				distinctClassCode = StringUtil.checkNull(classList.get(j));
				ownerTeamList = new ArrayList();
				resultRow += "<row id='" + distinctClassCode + "' open='1'>";
				resultRow += CELL_CHECK;
				resultRow += "	<cell image='"
						+ StringUtil.checkNull(itemTypeImgList.get(j)) + "'> "
						+ StringUtil.checkNull(classNameList.get(j)) + " ("+StringUtil.checkNull(classCnt.get(j))+")"+ CELL_CLOSE;
				resultRow += CELL_OPEN +""+ CELL_CLOSE;
				resultRow += CELL_OPEN +""+ CELL_CLOSE;
				resultRow += CELL_OPEN +"blank_grey.png"+ CELL_CLOSE;
				resultRow += CELL_TOT;
				resultRow += "	" + CELL_OPEN + classCode + CELL_CLOSE;				
				
				
				for(int i=0; i<listData.size(); i++){					
					Map cxnInfo = (Map)listData.get(i);
					classCode = StringUtil.checkNull(cxnInfo.get("ClassCode"));					
					
					if(distinctClassCode.equals(classCode)){
						
						if(!ownerTeamList.contains(cxnInfo.get("OwnerTeamID"))){
							ownerTeamList.add(cxnInfo.get("OwnerTeamID"));
							
					/* HEC Only		if(classCode.equals("CL05003") || classCode.equals("CL16004")){ // SOP, STP
						
							resultRow += "<row id='" + cxnInfo.get("OwnerTeamID") + "_"+classCode+"' open='1'>";
							resultRow += CELL_CHECK;
							resultRow += "	<cell image='"
									+ StringUtil.checkNull(itemTypeImgList.get(j)) + "'> "
									+ StringUtil.checkNull(cxnInfo.get("OwnerTeamName")) + CELL_CLOSE;
							resultRow += CELL_TOT;
							resultRow += "	" + CELL_OPEN + classCode + CELL_CLOSE;	
							} */
							
							for(int i2=0; i2<listData.size(); i2++){					
								Map cxnInfo2 = (Map)listData.get(i2);								
								if(cxnInfo2.get("ClassCode").equals(cxnInfo.get("ClassCode")) && cxnInfo2.get("OwnerTeamID") .equals(cxnInfo.get("OwnerTeamID"))){
									
								if(StringUtil.checkNull(cxnInfo2.get("Status")).equals("NEW1")){
									statusColor = "blue"; statusWeight="bold";
								}else if(StringUtil.checkNull(cxnInfo2.get("Status")).equals("MOD1") || StringUtil.checkNull(cxnInfo2.get("Status")).equals("MOD2")){
									statusColor = "orange"; statusWeight="bold";
								}else{
									statusColor = "#000000"; statusWeight="normal";
								}
									
								Map setMap = new HashMap();
								setMap.put("itemID", StringUtil.checkNull(cxnInfo2.get("s_itemID"),""));
								setMap.put("languageID", languageID);
								setMap.put("itemClassCode", cxnInfo2.get("ClassCode"));
								List linkList = commonService.selectList("link_SQL.getLinkListFromAttAlloc", setMap);
								String linkUrl = "";
								String lovCode = "";
								String attrTypeCode = "";
								linkImg = "blank.png";
								if(linkList.size() > 0){
									Map linkInfo = (Map)linkList.get(0);
									linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
									lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
									attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
									if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
								}
								
								///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
								resultRow+=ROW_OPEN+"'"+StringUtil.checkNull(cxnInfo2.get("s_itemID"))+ String.valueOf(rowId) +"'>";
								rowId++;
								
								resultRow += CELL_CHECK;
								resultRow += "		" + CELL_OPEN
								+ StringUtil.checkNull(cxnInfo2.get("Identifier"))
								+ " "
								+ StringUtil.checkNull(cxnInfo2.get("ItemName")).replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ").replaceAll("\"","&#34;") + CELL_CLOSE;
								resultRow += "		" + CELL_OPEN
								+ StringUtil.checkNull(cxnInfo2.get("ItemPath")) + CELL_CLOSE;
								resultRow += "		" + CELL_OPEN +StringUtil.checkNull(cxnInfo2.get("CXNClassName"))+ CELL_CLOSE; // cxn pop
								resultRow += "		" + CELL_OPEN +linkImg+ CELL_CLOSE; // link
								resultRow += "		" + CELL_OPEN
								+ StringUtil.checkNull(cxnInfo2.get("TeamName")) + CELL_CLOSE;
								resultRow += "		" + CELL_OPEN
								+ StringUtil.checkNull(cxnInfo2.get("OwnerTeamName"))
								+ CELL_CLOSE;
								resultRow += "		" + CELL_OPEN
								+ StringUtil.checkNull(cxnInfo2.get("Name")) + CELL_CLOSE;
								resultRow += "		" + CELL_OPEN
								+ StringUtil.checkNull(cxnInfo2.get("LastUpdated"))
								+ CELL_CLOSE;
								resultRow += "		<cell style='color:"+statusColor+";font-weight:"+statusWeight+"'>" 
								+ StringUtil.checkNull(cxnInfo2.get("StatusName"))
								+ CELL_CLOSE;
								resultRow += "		" + CELL_OPEN
								+ StringUtil.checkNull(cxnInfo2.get("s_itemID")) + CELL_CLOSE;
								resultRow += "		" + CELL_OPEN + classCode + CELL_CLOSE;
								resultRow += "		" + CELL_OPEN + StringUtil.checkNull(cxnInfo2.get("CXNItemID")) +  CELL_CLOSE;
								resultRow += "		" + CELL_OPEN + linkUrl + CELL_CLOSE;
								resultRow += "		" + CELL_OPEN + lovCode + CELL_CLOSE;
								resultRow += "		" + CELL_OPEN + StringUtil.checkNull(cxnInfo2.get("CXNClassCode")) +  CELL_CLOSE;
								resultRow += "		" + CELL_OPEN + attrTypeCode +  CELL_CLOSE;
								resultRow += "		" + CELL_OPEN + StringUtil.checkNull(cxnInfo2.get("AuthorID")) +  CELL_CLOSE;
								resultRow += ROW_CLOSE;
								///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
								}
							}
						//	if(classCode.equals("CL05003") || classCode.equals("CL16004")){
						//		resultRow += ROW_CLOSE; // CLOSE 주관조직  HEC Only
						//	}
						}
					}
				}resultRow += ROW_CLOSE; // CLOSE class 
			}
			
		}
	
		result += resultRow;
		result += "</row>";
		result += "</rows>";
		//System.out.println(result);
		
		return result.replace("&","&amp;"); // 특수 문자 제거
	}
	
	/**
	 * 연관항목 화면 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/itemConnection.do")
	public String itemConnection(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();	
		
		try {
			
			/* 연관항목의 ItemTypeCode 취득 */
			String varFilters[] = StringUtil.checkNull(request.getParameter("varFilter")).split(",");  // CN00108,Y, cxnParent = Y OR N
			String varFilter = "";
			String addBtnYN = "N";
			String cxnParent = "N";
			if(varFilters.length > 2){					
				addBtnYN = StringUtil.checkNull(varFilters[1]);
				cxnParent = StringUtil.checkNull(varFilters[2].split("=")[1]);
				varFilter = StringUtil.checkNull(varFilters[0]);
			}
			else if(varFilters.length > 1) {
				if(varFilters[1].indexOf("=") > -1) {
					cxnParent = StringUtil.checkNull(varFilters[1].split("=")[1]);
				}
				else {
					addBtnYN = StringUtil.checkNull(varFilters[1]);						
				}				
				varFilter = StringUtil.checkNull(varFilters[0]);
			}
			else if(varFilters.length>0){
				varFilter = StringUtil.checkNull(varFilters[0]);
				
			}
			
			setMap.put("varFilter", varFilter);
			Map fromToItemMap = commonService.select("organization_SQL.getFromToItemTypeCode", setMap);
			
			String fromItemTypeCode = StringUtil.checkNull(fromToItemMap.get("FromItemTypeCode"));
			String toItemTypeCode = StringUtil.checkNull(fromToItemMap.get("ToItemTypeCode"));
							
			/* 연관 항목의 기본정보 취득 */
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));

			//Structure item Tree 시 // 	
			String mstItemID = StringUtil.checkNull(request.getParameter("mstItemID"));
			if(!mstItemID.equals("") && mstItemID != null){
				s_itemID = mstItemID;	
			}			

			setMap.put("s_itemID", s_itemID);
			Map itemInfoMap = commonService.select("project_SQL.getItemInfo", setMap);
			
//			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
//			Map itemAuthorMap = commonService.select("project_SQL.getItemAuthorIDAndLockOwner", setMap);
//			if ((StringUtil.checkNull(itemAuthorMap.get("AuthorID")).equals(StringUtil.checkNull(commandMap.get("sessionUserId"))) 
//					|| StringUtil.checkNull(itemAuthorMap.get("LockOwner")).equals(StringUtil.checkNull(commandMap.get("sessionUserId")))
//					|| "1".equals(sessionAuthLev))
//					&& !"1".equals(StringUtil.checkNull(itemInfoMap.get("Blocked")))) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);
			
			/* 편집 가능여부 */
			model.put("selectedItemStatus", StringUtil.checkNull(itemInfoMap.get("Status")));
			model.put("selectedItemBlocked", StringUtil.checkNull(itemInfoMap.get("Blocked")));
			
			String myItemTypeCode = StringUtil.checkNull(itemInfoMap.get("ItemTypeCode"));
			String isFromItem = "";
			if (myItemTypeCode.equals(fromItemTypeCode)) {
				setMap.put("isFromItem", "Y");
				setMap.put("ItemTypeCode", toItemTypeCode);
				model.put("isFromItem", "Y");
				model.put("ItemTypeCode", toItemTypeCode);
				isFromItem = "N";
			} else {
				setMap.put("isFromItem", "N");
				setMap.put("ItemTypeCode", fromItemTypeCode);
				model.put("isFromItem", "N");
				model.put("ItemTypeCode", fromItemTypeCode);
				isFromItem = "Y";
			}
			
			setMap.put("varFilter", varFilter);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("cxnParent", cxnParent);
			List relatedItemList = commonService.selectList("item_SQL.getCXNItems", setMap);
			
			/* 연관 항목의  속성 내용을 취득 & 편집 권한 취득 */
			if(!cxnParent.equals("Y")) {
				for (int i = 0; relatedItemList.size() > i ;i++ ) {
					Map relatedItemMap = (Map) relatedItemList.get(i);
					setMap.put("ItemID", relatedItemMap.get("CnItemID"));
					setMap.put("DefaultLang", commonService.selectString("item_SQL.getDefaultLang", setMap));
					setMap.put("sessionCurrLangType", commandMap.get("sessionCurrLangType"));
					
					setMap.put("s_itemID", relatedItemMap.get("CnItemID"));
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));
					setMap.put("defaultLang", commonService.selectString("item_SQL.getDefaultLang", setMap));
					setMap.put("option", request.getParameter("option"));
					
					List relatedAttrList = (List)commonService.selectList("attr_SQL.getItemAttr", setMap);
					if(relatedAttrList.size() > 0){
						for (int k2 = 0; relatedAttrList.size()>k2 ; k2++ ) {
							Map attrData = (Map) relatedAttrList.get(k2);
							String attrTypeCode = StringUtil.checkNull(attrData.get("AttrTypeCode"));
							String dataType = StringUtil.checkNull(attrData.get("DataType"));
							if(dataType.equals("MLOV")){
								String plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionCurrLangType")) , StringUtil.checkNull(relatedItemMap.get("CnItemID")), attrTypeCode);
								attrData.put("PlainText", plainText);
							}
						}
					}
					String plainText = "";
					String beforAttrTypeCode = "";
					String currAttrTypeCode = "";
					for (int k = 0; relatedAttrList.size()>k ; k++ ) {
						Map map = (Map) relatedAttrList.get(k);	
						if(k>0){beforAttrTypeCode = StringUtil.checkNull(map.get(k-1));}
						currAttrTypeCode = StringUtil.checkNull(map.get(k));												
					}
					
					beforAttrTypeCode = "";
					currAttrTypeCode = "";					
					List connectionAttrList =  new ArrayList();	
					List newConnectionAttrList =  new ArrayList();	
					if(isFromItem.equals("Y")){
						setMap.put("ItemID", relatedItemMap.get("RelItemID"));						
						connectionAttrList = (List)commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
						newConnectionAttrList = (List)commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
					}else{
						setMap.put("ItemID", relatedItemMap.get("PrcItemID"));						
						connectionAttrList = (List)commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
						newConnectionAttrList = (List)commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
					}
					int jj = -1;
					int j2 = 1;
					List indexList = new ArrayList();
					//System.out.println("connectionAttrList.size() :"+connectionAttrList.size());
					for (int j = 0; connectionAttrList.size()>j ; j++ ) {
						Map cnnMap = (Map) connectionAttrList.get(j);
						beforAttrTypeCode = "";
						currAttrTypeCode = "";
						if(j != 0){
							Map beforeCnnMap = (Map) connectionAttrList.get(jj);								
							beforAttrTypeCode = StringUtil.checkNull(beforeCnnMap.get("AttrTypeCode"));		
						}
						
						currAttrTypeCode = StringUtil.checkNull(cnnMap.get("AttrTypeCode"));					
						if(beforAttrTypeCode.equals(currAttrTypeCode)){
							newConnectionAttrList.remove(j-j2);
							j2++;
						}	
						jj++;
						
					}					
					for (int m = 0; newConnectionAttrList.size()>m ; m++ ) {
						Map cnnMap = (Map) newConnectionAttrList.get(m);	
						if(cnnMap.get("DataType").equals("MLOV")){
							plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionCurrLangType")) , StringUtil.checkNull(cnnMap.get("ItemID")), StringUtil.checkNull(cnnMap.get("AttrTypeCode")));
							cnnMap.put("PlainText", plainText);
						}
					}
					
					// 연관 항목 기본정보 리스트에 취득한 속성 리스트를 저장
					relatedItemMap.put("relatedAttrList", relatedAttrList);
					relatedItemMap.put("connectionAttrList", newConnectionAttrList);
				}
			}
			
			setMap.remove("s_itemID");
			List returnData = commonService.selectList("item_SQL.getClassOption", setMap);
			model.put("classOption", returnData);
			
			model.put("s_itemID", s_itemID);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("varFilter", varFilter);
			model.put("relatedItemList", relatedItemList);
			model.put("cnt", relatedItemList.size());
			model.put("screenMode", StringUtil.checkNull(request.getParameter("screenMode"), ""));
			model.put("attrDisplay", StringUtil.checkNull(request.getParameter("attrDisplay"), ""));
			model.put("myItemTypeCode", myItemTypeCode);
			model.put("option", request.getParameter("option"));
			model.put("addBtnYN", addBtnYN);
			model.put("cxnParent",cxnParent);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("/itm/connection/itemConnectionList");
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
			mLovList = commonService.selectList("attr_SQL.getMLovList",setMap);
			if(mLovList.size() > 0){
				for(int j=0; j<mLovList.size(); j++){
					Map mLovListMap = (HashMap)mLovList.get(j);
					if(j==0){
						plainText = StringUtil.checkNull(mLovListMap.get("Value"));
					}else {
						plainText = plainText + " / " + mLovListMap.get("Value") ;
					}
				}
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		return plainText;
	}
		
	@RequestMapping(value="/addRelItemPop.do")
	public String addRelItemPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try{
			
			Map setMap = new HashMap();
			
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("ItemTypeCode", request.getParameter("ItemTypeCode"));
			List returnData = commonService.selectList("item_SQL.getClassOption", setMap);
			model.put("classOption", returnData);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			model.put("s_itemID", request.getParameter("s_itemID"));
			model.put("isFromItem", request.getParameter("isFromItem"));
			model.put("CNItemTypeCode", request.getParameter("CNItemTypeCode"));
			model.put("option", request.getParameter("option"));
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/itm/connection/addRelItemPop");
	}
	
	@RequestMapping(value="/newItemInsertAndAssign.do")
	public String newItemInsertAndAssign(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		HashMap target = new HashMap();	
		Map insertCngMap = new HashMap();
		
		try {
		
			String newItemID = commonService.selectString("item_SQL.getItemMaxID", setMap);
			commandMap.put("ItemID", request.getParameter("s_itemID")); // tree에서 선택한 아이템의 ProjectID를 입력
			String projectID = commonService.selectString("project_SQL.getItemProjectId", commandMap);
			String autoID = StringUtil.checkNull(request.getParameter("autoID"));
			String preFix = StringUtil.checkNull(request.getParameter("preFix"));
			
			Map setValue = new HashMap();
			setMap.put("itemId", request.getParameter("s_itemID"));	
			String identifier = StringUtil.checkNull(request.getParameter("newIdentifier").replaceAll("<and>", "&"));
			String idLength = "";
			
			String newItemCode = "";
			if(autoID.equals("Y")){		
				newItemCode = StringUtil.checkNull(commonService.selectString("item_SQL.getNewItemCode", setMap));
				if(!newItemCode.equals("") && newItemCode != null) {				
					identifier = newItemCode;				
				}else {
					setValue.put("preFix", preFix);
					identifier = StringUtil.checkNull(commonService.selectString("item_SQL.getMaxPreFixIdentifier", setValue));
					for(int i=0; 5-identifier.length() > i; i++){
						idLength = idLength + "0";
					}
					
					if(identifier.equals("")){
						identifier = preFix + "00001";
					}else{
						identifier = preFix + idLength + identifier;
					}
				}
			}
			
			// 새로운 아이템 생성
			setMap.put("option", request.getParameter("option"));
			setMap.put("Version", "1");
			setMap.put("Deleted", "0");
			setMap.put("Creator", commandMap.get("sessionUserId"));
			setMap.put("ClassCode", request.getParameter("newClassCode"));
			setMap.put("OwnerTeamId", commandMap.get("sessionTeamId"));
			setMap.put("Identifier", identifier);
			setMap.put("ItemID", newItemID);
			String newItemTypeCode = commonService.selectString("item_SQL.getItemTypeCodeFromClassCode", setMap);
			setMap.put("ItemTypeCode", newItemTypeCode);
			// [TB_ITEM_TYPE]에서 ItemTypeCode로 해당 CategoryCode취득
			setMap.put("CategoryCode", commonService.selectString("item_SQL.getCategoryFromItemTypeCode", setMap));
			setMap.put("AuthorID",commandMap.get("sessionUserId"));
			setMap.put("ProjectID", projectID);
			setMap.put("Status","NEW1");
			commonService.insert("item_SQL.insertItem", setMap);
			
			// 새로운 아이템의 명칭 생성
			setMap.put("PlainText", request.getParameter("newItemName").replaceAll("<and>", "&"));
			setMap.put("AttrTypeCode","AT00001");			
			List getLanguageList = commonService.selectList("common_SQL.langType_commonSelect", setMap);			
			for(int i = 0; i < getLanguageList.size(); i++){
				Map getMap = (HashMap)getLanguageList.get(i);
				setMap.put("languageID", getMap.get("CODE") );				
				commonService.insert("item_SQL.ItemAttr", setMap);
			}
			
			/* 신규 생성된 ITEM의 ITEM_CLASS.ChangeMgt = 1 일 경우, CHANGE_SET 테이블에 레코드 생성  */
			commandMap.put("ItemID", newItemID);
			if ("1".equals(commonService.selectString("project_SQL.getChangeMgt", commandMap))) {
				/* Insert to TB_CHANGE_SET */
				insertCngMap.put("itemID", newItemID);
				insertCngMap.put("userId", request.getParameter("AuthorID"));
				insertCngMap.put("projectID", projectID);
				insertCngMap.put("classCode", request.getParameter("newClassCode"));
				insertCngMap.put("KBN", "insertCNG");
				CSService.save(new ArrayList(), insertCngMap);
			}
			
			// 관계 항목 생성
			setMap.put("CategoryCode", "CN");
			setMap.put("ItemTypeCode", request.getParameter("CNItemTypeCode"));
            setMap.put("ClassCode", commonService.selectString("item_SQL.selectItemClassCodePertinent", setMap));
            
            if ("Y".equals(request.getParameter("isFromItem"))) {
            	setMap.put("FromItemID", request.getParameter("s_itemID"));
            	setMap.put("ToItemID", newItemID);
            } else {
            	setMap.put("ToItemID", request.getParameter("s_itemID"));
            	setMap.put("FromItemID", newItemID);
            }
			setMap.put("ItemID", commonService.selectString("item_SQL.getItemMaxID", setMap));
			setMap.put("Identifier", "");
			commonService.insert("item_SQL.insertItem", setMap);
			
			// 새로운 아이템의 연결 아이템 생성
			setMap.put("CategoryCode", "ST1");
			setMap.put("ClassCode", "NL00000");
			setMap.put("FromItemID", request.getParameter("parentItemId"));
			setMap.put("ToItemID", newItemID);
			newItemID = commonService.selectString("item_SQL.getItemMaxID", setMap);
			setMap.put("ItemID", newItemID);
			setMap.put("Identifier", null);
			setMap.put("ItemTypeCode", newItemTypeCode);
			String itemTypeCodeCN = commonService.selectString("organization_SQL.getConItemTypeCode", setMap);
			setMap.put("ItemTypeCode", itemTypeCodeCN);
			//setMap.put("Status", null);
			commonService.insert("item_SQL.insertItem", setMap);
			
			/* 신규 생성한 상위  항목의 Dim Tree 데이터 생성 */
			String[] arrayStr = {newItemID};
			List parentItemList = DimTreeAdd.getHighLankItemList(commonService, arrayStr);
			DimTreeAdd.insertDimTreeInfo(commonService, commandMap, parentItemList);
			
			String addBtnYN = StringUtil.checkNull(request.getParameter("addBtnYN"),"");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공			
			target.put(AJAX_SCRIPT, "this.urlReload('"+addBtnYN+"');this.$('#isSubmit').remove();");
		}
		catch (Exception e) {
			System.out.println(e);
			//target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/selectCxnItemTypePop.do")
	public String selectCxnItemTypePop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {			
			
			model.put("option", StringUtil.checkNull(cmmMap.get("option")));
			model.put("itemTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode")));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("itemID", request.getParameter("s_itemID"));
			
			String reqCxnTypeList[] = StringUtil.checkNull(request.getParameter("cxnTypeList"), "").split(",");
			String cxnTypeCodes = "";
			if (!StringUtil.checkNull(request.getParameter("cxnTypeList"), "").equals("")) {
				for (int i = 0; i < reqCxnTypeList.length; i++) {
					if(i==0) {
						cxnTypeCodes = "'"+reqCxnTypeList[i]+"'";
					}else {
						cxnTypeCodes += ",'"+ reqCxnTypeList[i]+"'";
					}
				}
				model.put("cxnTypeCodes", cxnTypeCodes);
			}
			
			String itemTypeCode = StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCode", cmmMap));
			model.put("itemTypeCode", itemTypeCode);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("itm/connection/selectCxnItemTypePop");
	} 
	
	@RequestMapping(value="/selectItemTypePop.do")
	public String selectItemTypePop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {			
			String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
			model.put("itemTypeCode", itemTypeCode);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("itm/connection/selectItemTypePop");
	} 
	
	@RequestMapping (value="/getCxnAttrList.do")
	public String getCxnAttrList(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		
		try{
			String itemID = StringUtil.checkNull(cmmMap.get("itemID"),"");
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			setMap.put("ItemID", itemID);	
			setMap.put("sessionCurrLangType", languageID);	
			setMap.put("selectLanguageID", languageID);	
			List connectionAttrList = (List)commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
         
			String cxnAttrHtml = "";
			String html = "";
			String name = "";
			String areaHeight = "";
			String plainText = "";
			if(connectionAttrList.size() > 0){
				for(int i=0; i<connectionAttrList.size(); i++){
					Map cxnAttrInfo = (Map)connectionAttrList.get(i);
					html = StringUtil.checkNull(cxnAttrInfo.get("HTML"));
					name = StringUtil.checkNull(cxnAttrInfo.get("Name"));
					areaHeight = StringUtil.checkNull(cxnAttrInfo.get("AreaHeight"));
					plainText = StringUtil.checkNull(cxnAttrInfo.get("PlainText"));
					
					cxnAttrHtml += "<colgroup><col width=\"20%\"><col width=\"80%\"></colgroup>";
					cxnAttrHtml += "<tr><th class=\"viewline\">"+ name + "</th>";
					cxnAttrHtml += "<td class=\"last pdL5 pdR5\" >";
					if(html.equals("1")){
						cxnAttrHtml += "<textarea style=\"width:100%;height:" + areaHeight + "px;\" class=\"tinymceText\" >" + plainText + "</textarea>";
					}else{
						cxnAttrHtml += "<textarea style=\"width:100%;height:" + areaHeight + "px;\" readonly=\"readonly\" >" + plainText + "</textarea>";
					}
					cxnAttrHtml += "</td></tr>";
					
				}
			}
			
			System.out.println("cxnAttrHtml :"+cxnAttrHtml);
			target.put(AJAX_SCRIPT, "fnSetCxnAttrList('"+cxnAttrHtml+"','"+connectionAttrList.size()+"');");
				
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP,target); 
		return nextUrl(AJAXPAGE); 
	}
	
	@RequestMapping(value="/getItemClassCode.do") 
	public String getItemClassCode(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception { 
		Map target = new HashMap();	 
		try{ 		
			String s_itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));
			Map setMap = new HashMap();
			setMap.put("s_itemID", s_itemID);
			setMap.put("itemTypeCode", StringUtil.checkNull(commonService.selectString("item_SQL.getItemTypeCode", setMap)) );
			setMap.put("cxnTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode")));
			setMap.put("category", "CN");
			Map cxnTypeInfo = (Map)commonService.select("item_SQL.getCxnTypeInfo", setMap);
			String cxnTypeCode = "";
			if(!cxnTypeInfo.isEmpty()){
				cxnTypeCode = StringUtil.checkNull(cxnTypeInfo.get("CxnTypeCode"));
			}
			setMap.put("option", cxnTypeCode);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			List itemClassCodeList = commonService.selectList("common_SQL.classCodeOption_commonSelect", setMap); 
			
			String itemTypeCode = StringUtil.checkNull(cmmMap.get("itemTypeCode"));
			String itemClassCode = "";
			if(itemClassCodeList.size() == 1){
				Map classMap = (Map)itemClassCodeList.get(0);
				itemClassCode = StringUtil.checkNull(classMap.get("CODE"));
				target.put(AJAX_SCRIPT, "fnSetClassCode('"+itemClassCode+"')"); 
			}else if(itemClassCodeList.size() > 1){
				target.put(AJAX_SCRIPT, "fnSelectClassCodeList('"+itemTypeCode+"','"+cxnTypeCode+"')"); 
			}
			
		} catch (Exception e) { 
			System.out.println(e); 
			throw new ExceptionUtil(e.toString()); 
		} 
		 
		model.addAttribute(AJAX_RESULTMAP,target); 
		return nextUrl(AJAXPAGE); 
	}
	
	@RequestMapping(value = "/cxnProcTreeList.do")
	public String cxnProcTreeList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				List treeList = commonService.selectList("item_SQL.cxnProcTreeList",commandMap);			
				
				JSONArray treeGridData = new JSONArray(treeList);
				model.put("treeGridData",treeGridData);
				model.put("totalCount",treeList.size());
		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/itm/connection/cxnProcTreeList");
	}
	
	@RequestMapping(value="/cxnItemListPop.do")
	public String cxnItemListPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();	 
		
		try {
			/* 연관항목의 ItemTypeCode 취득 */
			/*
			 * String varFilters[] =
			 * StringUtil.checkNull(request.getParameter("varFilter")).split(","); //
			 * CN00108,Y, cxnParent = Y OR N String varFilter = ""; String addBtnYN = "N";
			 * String cxnParent = "N"; if(varFilters.length > 2){ addBtnYN =
			 * StringUtil.checkNull(varFilters[1]); cxnParent =
			 * StringUtil.checkNull(varFilters[2].split("=")[1]); varFilter =
			 * StringUtil.checkNull(varFilters[0]); } else if(varFilters.length > 1) {
			 * if(varFilters[1].indexOf("=") > -1) { cxnParent =
			 * StringUtil.checkNull(varFilters[1].split("=")[1]); } else { addBtnYN =
			 * StringUtil.checkNull(varFilters[1]); } varFilter =
			 * StringUtil.checkNull(varFilters[0]); } else if(varFilters.length>0){
			 * varFilter = StringUtil.checkNull(varFilters[0]);
			 * 
			 * }
			 */
			String cxnItemTypeCode = StringUtil.checkNull(request.getParameter("cxnItemTypeCode"));
			//String addBtnYN = StringUtil.checkNull(request.getParameter("addBtnYN"));
			String cxnParent = StringUtil.checkNull(request.getParameter("cxnParent"));
			
			setMap.put("varFilter", cxnItemTypeCode);
			Map fromToItemMap = commonService.select("organization_SQL.getFromToItemTypeCode", setMap);
			
			String fromItemTypeCode = StringUtil.checkNull(fromToItemMap.get("FromItemTypeCode"));
			String toItemTypeCode = StringUtil.checkNull(fromToItemMap.get("ToItemTypeCode"));
							
			/* 연관 항목의 기본정보 취득 */
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			setMap.put("itemID", s_itemID);
			String identifier = commonService.selectString("item_SQL.s_itemIDentifier", setMap);
			model.put("identifier", identifier);
			
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			Map l5NameInfo = commonService.select("attr_SQL.getItemNameInfo", setMap);
			
			String l5Name = StringUtil.checkNull(String.valueOf(l5NameInfo.get("PlainText")));
			model.put("l5Name", l5Name);
			
			setMap.put("category", "CN");
			setMap.put("typeCode", cxnItemTypeCode);
			String cxnCodeName = commonService.selectString("task_SQL.getDicName", setMap);
			model.put("cxnCodeName", cxnCodeName);
			
			//Structure item Tree 시 // 	
			String mstItemID = StringUtil.checkNull(request.getParameter("mstItemID"));
			if(!mstItemID.equals("") && mstItemID != null){
				s_itemID = mstItemID;	
			}			

			setMap.put("s_itemID", s_itemID);
			Map itemInfoMap = commonService.select("project_SQL.getItemInfo", setMap);
			
//			String sessionAuthLev = String.valueOf(commandMap.get("sessionAuthLev")); // 시스템 관리자
//			Map itemAuthorMap = commonService.select("project_SQL.getItemAuthorIDAndLockOwner", setMap);
//			if ((StringUtil.checkNull(itemAuthorMap.get("AuthorID")).equals(StringUtil.checkNull(commandMap.get("sessionUserId"))) 
//					|| StringUtil.checkNull(itemAuthorMap.get("LockOwner")).equals(StringUtil.checkNull(commandMap.get("sessionUserId")))
//					|| "1".equals(sessionAuthLev))
//					&& !"1".equals(StringUtil.checkNull(itemInfoMap.get("Blocked")))) {
//				model.put("myItem", "Y");
//			}
			
			String myItem = commonService.selectString("item_SQL.checkMyItem", commandMap);
			model.put("myItem", myItem);
			
			/* 편집 가능여부 */
			model.put("selectedItemStatus", StringUtil.checkNull(itemInfoMap.get("Status")));
			model.put("selectedItemBlocked", StringUtil.checkNull(itemInfoMap.get("Blocked")));
			
			String myItemTypeCode = StringUtil.checkNull(itemInfoMap.get("ItemTypeCode"));
			String isFromItem = "";
			if (myItemTypeCode.equals(fromItemTypeCode)) {
				setMap.put("isFromItem", "Y");
				setMap.put("ItemTypeCode", toItemTypeCode);
				model.put("isFromItem", "Y");
				model.put("ItemTypeCode", toItemTypeCode);
				isFromItem = "N";
			} else {
				setMap.put("isFromItem", "N");
				setMap.put("ItemTypeCode", fromItemTypeCode);
				model.put("isFromItem", "N");
				model.put("ItemTypeCode", fromItemTypeCode);
				isFromItem = "Y";
			}
			
			setMap.put("varFilter", cxnItemTypeCode);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("cxnParent", cxnParent);
			List relatedItemList = commonService.selectList("item_SQL.getCXNItems", setMap);
			
			/* 연관 항목의  속성 내용을 취득 & 편집 권한 취득 */
			if(!cxnParent.equals("Y")) {
				for (int i = 0; relatedItemList.size() > i ;i++ ) {
					Map relatedItemMap = (Map) relatedItemList.get(i);
					setMap.put("ItemID", relatedItemMap.get("CnItemID"));
					setMap.put("DefaultLang", commonService.selectString("item_SQL.getDefaultLang", setMap));
					setMap.put("sessionCurrLangType", commandMap.get("sessionCurrLangType"));
					
					setMap.put("s_itemID", relatedItemMap.get("CnItemID"));
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));
					setMap.put("defaultLang", commonService.selectString("item_SQL.getDefaultLang", setMap));
					setMap.put("option", request.getParameter("option"));
					
					List relatedAttrList = (List)commonService.selectList("attr_SQL.getItemAttr", setMap);
					if(relatedAttrList.size() > 0){
						for (int k2 = 0; relatedAttrList.size()>k2 ; k2++ ) {
							Map attrData = (Map) relatedAttrList.get(k2);
							String attrTypeCode = StringUtil.checkNull(attrData.get("AttrTypeCode"));
							String dataType = StringUtil.checkNull(attrData.get("DataType"));
							if(dataType.equals("MLOV")){
								String plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionCurrLangType")) , StringUtil.checkNull(relatedItemMap.get("CnItemID")), attrTypeCode);
								attrData.put("PlainText", plainText);
							}
						}
					}
					String plainText = "";
					String beforAttrTypeCode = "";
					String currAttrTypeCode = "";
					for (int k = 0; relatedAttrList.size()>k ; k++ ) {
						Map map = (Map) relatedAttrList.get(k);	
						if(k>0){beforAttrTypeCode = StringUtil.checkNull(map.get(k-1));}
						currAttrTypeCode = StringUtil.checkNull(map.get(k));												
					}
					
					beforAttrTypeCode = "";
					currAttrTypeCode = "";					
					List connectionAttrList =  new ArrayList();	
					List newConnectionAttrList =  new ArrayList();	
					if(isFromItem.equals("Y")){
						setMap.put("ItemID", relatedItemMap.get("RelItemID"));						
						connectionAttrList = (List)commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
						newConnectionAttrList = (List)commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
					}else{
						setMap.put("itemID", relatedItemMap.get("PrcItemID"));
						setMap.put("ItemID", relatedItemMap.get("PrcItemID"));	
						setMap.put("attrTypeCode", "ATGTP00");
						String lovCode = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAttrLovCode", setMap), "");
						setMap.put("atgGRCode", lovCode);
						
						connectionAttrList = (List)commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
						newConnectionAttrList = (List)commonService.selectList("attr_SQL.getItemAttributesInfo", setMap);
					}
					int jj = -1;
					int j2 = 1;
					List indexList = new ArrayList();
					//System.out.println("connectionAttrList.size() :"+connectionAttrList.size());
					for (int j = 0; connectionAttrList.size()>j ; j++ ) {
						Map cnnMap = (Map) connectionAttrList.get(j);
						beforAttrTypeCode = "";
						currAttrTypeCode = "";
						if(j != 0){
							Map beforeCnnMap = (Map) connectionAttrList.get(jj);								
							beforAttrTypeCode = StringUtil.checkNull(beforeCnnMap.get("AttrTypeCode"));		
						}
						
						currAttrTypeCode = StringUtil.checkNull(cnnMap.get("AttrTypeCode"));					
						if(beforAttrTypeCode.equals(currAttrTypeCode)){
							newConnectionAttrList.remove(j-j2);
							j2++;
						}	
						jj++;
						
					}					
					for (int m = 0; newConnectionAttrList.size()>m ; m++ ) {
						Map cnnMap = (Map) newConnectionAttrList.get(m);	
						if(cnnMap.get("DataType").equals("MLOV")){
							plainText = getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionCurrLangType")) , StringUtil.checkNull(cnnMap.get("ItemID")), StringUtil.checkNull(cnnMap.get("AttrTypeCode")));
							cnnMap.put("PlainText", plainText);
						}
					}
					
					// 연관 항목 기본정보 리스트에 취득한 속성 리스트를 저장
					relatedItemMap.put("relatedAttrList", relatedAttrList);
					relatedItemMap.put("connectionAttrList", newConnectionAttrList);
				}
			}
			
			setMap.remove("s_itemID");
			List returnData = commonService.selectList("item_SQL.getClassOption", setMap);
			model.put("classOption", returnData);
			
			
			// ConnectionItemActionController - cxnItemTreeMgt.do
			List cxnItemList = new ArrayList();
			//cxnItemList.add(relatedItemList);
			
			for(int i2=0; i2<relatedItemList.size(); i2++) {
				Map relatedItemMap = (Map)relatedItemList.get(i2);
				
				Map setMap2 = new HashMap();
				String linkImg = "blank.png";
				
				setMap2.put("itemID", StringUtil.checkNull(relatedItemMap.get("PrcItemID")));
				
				String classCode = commonService.selectString("item_SQL.getClassCode", setMap2);
				
				if(classCode.equals("CL04005") || classCode.equals("CL04006")) {
					setMap2.put("languageID", commandMap.get("sessionCurrLangType"));
					setMap2.put("itemClassCode", classCode);
					List linkList = commonService.selectList("link_SQL.getLinkListFromAttAlloc", setMap2);
					String linkUrl = "";
					String lovCode = "";
					String attrTypeCode = "";
					
					if(linkList.size() > 0){
						Map linkInfo = (Map)linkList.get(0);
						linkUrl = StringUtil.checkNull(linkInfo.get("URL"),"");
						lovCode = StringUtil.checkNull(linkInfo.get("LovCode"),"");
						attrTypeCode = StringUtil.checkNull(linkInfo.get("AttrTypeCode"),"");
						if(!linkUrl.equals("")){ linkImg = "icon_link.png"; }
						relatedItemMap.put("linkImg", linkImg);
						relatedItemMap.put("linkUrl", linkUrl);
						relatedItemMap.put("lovCode", lovCode);
						relatedItemMap.put("attrTypeCode", attrTypeCode);
					}else {
						relatedItemMap.put("linkImg", linkImg);
					}
					
					cxnItemList.add(relatedItemMap);
				}
			}
			
//			List<HashMap<Object, Object>> cxnItemListDis = distinctArray(cxnItemList, "id");  //GridList distinct 할것
//
//			for (HashMap<Object, Object> hashMap : cxnItemListDis) {
//				System.out.println(hashMap);
//			}
			
			model.put("s_itemID", s_itemID);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("varFilter", cxnItemTypeCode);
			model.put("relatedItemList", relatedItemList);
			model.put("cxnItemList", cxnItemList);
			model.put("cnt", relatedItemList.size());
			model.put("screenMode", StringUtil.checkNull(request.getParameter("screenMode"), ""));
			model.put("attrDisplay", StringUtil.checkNull(request.getParameter("attrDisplay"), ""));
			model.put("myItemTypeCode", myItemTypeCode);
			model.put("option", request.getParameter("option"));
			//model.put("addBtnYN", addBtnYN);
			model.put("cxnParent",cxnParent);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("/itm/connection/cxnItemListPop");
	}
	
	@RequestMapping(value = "/cxnItemList.do", method = RequestMethod.GET)
	public void cxnItemList(HttpServletRequest request,  HttpServletResponse res) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map map = new HashMap();
		
		res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
		
	    try {
	    	String s_itemID = StringUtil.checkNull(request.getParameter("itemID"),"");
	    	String languageID = StringUtil.checkNull(request.getParameter("languageID"),"");
	    	String cxnTypeList = StringUtil.checkNull(request.getParameter("cxnTypeList"),"");
	    	map.put("s_itemID", s_itemID);
        	map.put("languageID", languageID);
        	map.put("cxnTypeList", cxnTypeList);
	        
	        // 연관항목
	        List itemList = commonService.selectList("item_SQL.getCxnItemList_gridList", map);
			jsonObject.put("list", itemList);
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
	
	@RequestMapping(value = "/cxnItemListMgt.do")
	public String cxnItemListMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			model.put("itemID", StringUtil.checkNull(request.getParameter("itemID"), ""));
			model.put("itemTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode"), ""));
			model.put("classCodes", StringUtil.checkNull(request.getParameter("classCodes"), ""));
			model.put("CXNItemTypeCode", StringUtil.checkNull(request.getParameter("CXNItemTypeCode"), ""));
			model.put("CXNClassCode", StringUtil.checkNull(request.getParameter("CXNClassCode"), ""));
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/itm/connection/cxnItemListMgt");
	}
}
