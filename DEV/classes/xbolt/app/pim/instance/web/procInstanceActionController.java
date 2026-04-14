package xbolt.app.pim.instance.web;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
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
import xbolt.cmm.framework.util.DiagramUtil;
import xbolt.cmm.framework.util.DimTreeAdd;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;
import xbolt.mdl.model.web.DiagramEditActionController;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
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
public class procInstanceActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	
	@RequestMapping(value="/procInstanceList.do")
	public String pim_ProcInstanceList(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "//app/pim//instance//procInstanceList";
		try {
			String varFilter = StringUtil.checkNull(cmmMap.get("varFilter"));
			if(varFilter.equals("elm")) {
				model.put("elmItemID",cmmMap.get("s_itemID"));
			}
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("masterItemID", StringUtil.checkNull(cmmMap.get("masterItemID"),(String) cmmMap.get("s_itemID")));
			
			Map setMap = new HashMap();
			setMap.put("s_itemID",StringUtil.checkNull(cmmMap.get("masterItemID"),(String) cmmMap.get("s_itemID")));
			String authorID = commonService.selectString("item_SQL.getItemAuthorId", setMap);
			model.put("authorID",authorID);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);		
	}	
	
	@RequestMapping(value="/procInstDetail.do")
	public String plm_ViewProjectCharter(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "//app/pim//instance//procInstDetail";
		try {			
			String archiCode = StringUtil.checkNull(cmmMap.get("option"),"");
			String instanceNo = StringUtil.checkNull(cmmMap.get("instanceNo"));	
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String instanceClass = StringUtil.checkNull(cmmMap.get("instanceClass"));
			String masterItemID = StringUtil.checkNull(request.getParameter("masterItemID"));
			String procType = StringUtil.checkNull(request.getParameter("procType"));
			String scrnMode = StringUtil.checkNull(request.getParameter("scrnMode"),"V");
			Map setData = new HashMap();
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
	
	@RequestMapping(value = "/procInstRoleList.do")
	public String pim_ProcWorkerList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/app/pim/instance/procInstRoleList";
		Map getMap = new HashMap();
		try {
			String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"));
			String processID = StringUtil.checkNull(request.getParameter("processID"));
			String stepID = StringUtil.checkNull(request.getParameter("stepID"));
			String gubun;
			
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("instanceNo",instanceNo);	
			model.put("menu", getLabel(request, commonService)); /*Label Setting*/		
		
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/selectElmInstTree.do")
	public String selectElmInstTree(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
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
			
			Map attrMap = commonService.select("attr_SQL.getItemAttrText", setMap);
			String procType = StringUtil.checkNull(attrMap.get("PlainText"));
			
			setMap.put("itemTypeCode", "OJ00001");
			elmList = (List) commonService.selectList("model_SQL.getElementItemList_gridList", setMap);
			List objectIDs = new ArrayList();
			
			for(int i = 0; i<elmList.size(); i++) {
				Map map = (Map) elmList.get(i);
				if(procType.equals(map.get("ProcType"))) {
					if(!objectIDs.contains(map.get("ItemID")))	objectIDs.add(map.get("ItemID"));
				}
			}
			
			model.put("modelID",modelID);
			model.put("instanceNo",instanceNo);
			model.put("processID",processID);
			model.put("searchValue",searchValue);
			model.put("elmTreeXml",setElementXML(modelMap,objectIDs,languageID,instanceNo,searchValue));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		}		
		catch (Exception e) {System.out.println(e);throw new ExceptionUtil(e.toString());}		
		return nextUrl("/app/pim/instance/selectElmInstTree");
	}
	
	private String setElementXML(Map modelMap,List roleIDs, String languageID,String procInstNo, String searchValue) throws Exception {
		Map setMap = new HashMap();
		String ModelID= "";
		String ModelName= "";
		
		String CELL = "	<cell></cell>";
		String CELL_CHECK = "	<cell>0</cell>";
		String CELL_OPEN = "	<cell>";
		String CELL_CLOSE = "</cell>";
		String CLOSE = ">";
		String CELL_TOT = "";
		String ROW_OPEN = "<row id=";
		String ROW_CLOSE = "</row>";
		int rowCnt = 2;
		
		String deleted = "";
		String deletedStyle = "style='text-decoration: red line-through;";
		
		// row ID 를 unique 하게 설정 하기 위한 seq
		int rowId = 0;
		String result = "";
		String resultRow = "";
		if (roleIDs.size() > 0) {
			ModelID = StringUtil.checkNull(modelMap.get("ModelID"),"");
			ModelName = (StringUtil.checkNull(modelMap.get("ModelName"))).replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ");	
			
			setMap.put("modelID",ModelID);
			setMap.put("languageID", languageID);
			
			result += "<rows>";
			result += "<row id='1' open='1'>";
			result += CELL_CHECK;
			result += "	<cell image='img_sitemap.png' style='font-weight:bold;text-align: left;'> " + ModelName.replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ")
					+"("+modelMap.get("MCName")+")"+ "</cell>";
			
			 if(roleIDs.size() > 0) {
				for (int i = 0; i < roleIDs.size(); i++){
					String roleID = StringUtil.checkNull(roleIDs.get(i));
					setMap.put("s_itemID",roleID);
					Map roleInfo = commonService.select("report_SQL.itemStDetailInfo", setMap);
									
					setMap.put("s_itemID",roleID);
					setMap.put("cxnTypeCode","CN00002");
					setMap.put("elmItemID",roleID);
					setMap.put("procInstNo",procInstNo);
					setMap.put("searchValue",searchValue);
					List cxnList = commonService.selectList("item_SQL.getCxnItemList", setMap);
					if(cxnList.size() > 0){
						resultRow += "<row id='" + roleID + "'>";
						resultRow += CELL_CHECK;
						resultRow += "	<cell image='" + StringUtil.checkNull(roleInfo.get("ItemTypeImg"))+ "'> "+ roleInfo.get("Identifier") + CELL_CLOSE;
						resultRow += CELL_OPEN + roleInfo.get("ItemName") + CELL_CLOSE;
						
						for(int k=0; k<cxnList.size(); k++){
							Map cxnMap = (HashMap) cxnList.get(k);
//							resultRow += "<row>";
//							resultRow += CELL_CHECK;
							resultRow += CELL_OPEN
									+ StringUtil.checkNull(cxnMap.get("ParentName")).replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ") +"/"
									+ StringUtil.checkNull(cxnMap.get("ItemName")).replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ") + CELL_CLOSE;
							resultRow += CELL_OPEN + StringUtil.checkNull(cxnMap.get("ItemID")) + CELL_CLOSE;
							resultRow += CELL_OPEN + roleID + CELL_CLOSE;
//							resultRow += ROW_CLOSE;
						}
						resultRow += ROW_CLOSE;
					}
				}
			}
	
			result += resultRow;
			result += "</row>";
			result += "</rows>";
		}
		return result.replace("&", "/"); // 특수 문자 제거
	}
	
	// 외부시스템에서 OLM ProcInst 호출 
	@RequestMapping(value="/olmProcInstLink.do")
	public String olmProcInstLink(HttpServletRequest request, ModelMap model,HashMap cmmMap)throws Exception{
					
		String url = "//app/pim//instance//procInstDetail";
		try {
			String object = StringUtil.checkNull(request.getParameter("object"), "");
			String linkID = StringUtil.checkNull(request.getParameter("linkID"), "");
			String linkType = StringUtil.checkNull(request.getParameter("linkType"), ""); // id, code,															
			String itemTypeCode = StringUtil.checkNull(	request.getParameter("iType"), ""); // itemTypeCode
			String identifier = StringUtil.checkNull(request.getParameter("linkID"), ""); // identifier
			String attrTypeCode = StringUtil.checkNull(request.getParameter("aType"), ""); // identifier
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), GlobalVal.DEFAULT_LANGUAGE);
			String option = StringUtil.checkNull(request.getParameter("option"), "");
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"), "");
			String docItemNo = StringUtil.checkNull(request.getParameter("docItemNo"), "");
			String instanceNo ="", instanceClass, masterItemID;
			
			Map setData = new HashMap();
			Map procInstanceInfo = new HashMap();
			//String projectCode = StringUtil.checkNull(request.getParameter("projectCode"));
			
			if(linkType.equals("jobNo")) {
				setData.put("documentNo", linkID);
				setData.put("docItemNo", docItemNo);
				procInstanceInfo = commonService.select("instance_SQL.getProcInstanceInfoByDocument", setData);
				instanceNo = StringUtil.checkNull(procInstanceInfo.get("ProcInstNo"));
			}else if(linkType.equals("id")) {
				instanceNo = linkID;
			}
			
			setData.put("instanceNo", instanceNo);
			setData.put("languageID", languageID);
			procInstanceInfo = commonService.select("instance_SQL.getProcInstanceInfo", setData);
			instanceClass = StringUtil.checkNull(procInstanceInfo.get("InstanceClass"));
			masterItemID = StringUtil.checkNull(procInstanceInfo.get("ProcessID"));
			
			model.put("procInstanceInfo", procInstanceInfo);	
			
			/** 첨부문서 취득 */
			setData.put("isPublic", "N");
			List attachFileList = commonService.selectList("instanceFile_SQL.getInstanceFile", setData);
			model.put("attachFileList", attachFileList);
			
			//Visit Log
			if(linkType.equals("id")){
				cmmMap.put("ItemId",masterItemID);
				cmmMap.put("instanceNo",linkID);
				cmmMap.put("ActionType","LINK");
				if( NumberUtil.isNumeric(masterItemID)) commonService.insert("gloval_SQL.insertVisitLog", cmmMap);
			}
			
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
			model.put("instanceClass", instanceClass);
			model.put("s_itemID", masterItemID);
			model.put("menu", getLabel(cmmMap, commonService));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/olmPopupMasterItemByProcPjt.do")
	public String olmPopupMasterItem(HttpServletRequest request,
			HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			String object = StringUtil.checkNull(request.getParameter("object"), "");
			String linkID = StringUtil.checkNull(request.getParameter("linkID"), "");
			String linkType = StringUtil.checkNull(request.getParameter("linkType"), ""); // id, code,															
			String itemTypeCode = StringUtil.checkNull(	request.getParameter("iType"), ""); // itemTypeCode
			String identifier = StringUtil.checkNull(request.getParameter("linkID"), ""); // identifier
			String attrTypeCode = StringUtil.checkNull(request.getParameter("aType"), ""); // identifier
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), "");
			String option = StringUtil.checkNull(request.getParameter("option"), "");
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
			String scrnType = StringUtil.checkNull(request.getParameter("scrnType"), "");
			String instanceNO = StringUtil.checkNull(request.getParameter("instanceNO"), "");
			String docItemNo = StringUtil.checkNull(request.getParameter("docItemNo"), "");
				
			 setMap = new HashMap();
			//String projectCode = StringUtil.checkNull(request.getParameter("projectCode"));
			String documentNo = linkID;

			setMap.put("documentNo", documentNo);
			setMap.put("docItemNo", docItemNo);
			Map procInstInfo = commonService.select("instance_SQL.getProcInstanceInfoByDocument", setMap);
			
			String itemID = StringUtil.checkNull(procInstInfo.get("ProcessID"));
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
			String htmlTitle = StringUtil.checkNull(commonService.selectString("item_SQL.getItemInfoHeader", setMap), "");
			
			//Visit Log
			if(!"".equals(instanceNO)){
				cmmMap.put("ItemId",itemID);
				cmmMap.put("instanceNo",instanceNO);
				cmmMap.put("ActionType","LINK");
				if( NumberUtil.isNumeric(itemID)) commonService.insert("gloval_SQL.insertVisitLog", cmmMap);
			}
			
			model.put("htmlTitle", htmlTitle);
			model.put("itemID", itemID);
			model.put("option", option);
			model.put("scrnType", scrnType);
			model.put("itemID", itemID);
			model.put("changeSetID", changeSetID);
			model.put("linkType", linkType);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/popup/olmPopupMasterItem");
	}
	
	/**
	  * 개요 화면에서 [Dimension] 아이콘 클릭 이벤트
	  * @param request
	  * @param model
	  * @return
	  * @throws Exception
	  */
	 @RequestMapping(value="/dimListForInstanceInfo.do")
	 public String dimListForInstanceInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		 String url = "/app/pim/instance/dimListForInstanceInfo";
		 try {
			 
			 List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);				
			 model.put("menu", getLabel(request, commonService));
			 model.put("s_itemID", request.getParameter("s_itemID"));
			 model.put("instanceNo", request.getParameter("instanceNo"));
			 model.put("instanceClass", request.getParameter("instanceClass"));
			 model.put("myItem", request.getParameter("myItem"));
			 model.put("dimTypeList", dimTypeList);
			 model.put("backBtnYN", request.getParameter("backBtnYN"));
				
		 } catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		 return nextUrl(url);
	}
	
	 @RequestMapping(value = "/dimAssignTreePopByInst.do")
		public String dimAssignTreePopByInst(HttpServletRequest request, HashMap commandMap, ModelMap model)
				throws Exception {
			try {
				
				Map setMap = new HashMap();
				
				String btnName = "Assign";
				String btnStyle = "assign";
				String dimValues = "";
				String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"), "");
				setMap.put("instanceNo", instanceNo);
				List instanveDimList = (List) commonService.selectList("instance_SQL.getDimListWithInstance", setMap);
				
				if(instanveDimList != null && instanveDimList.size() > 0) {
					for(int i=0; i<instanveDimList.size(); i++) {
						Map temp = (Map)instanveDimList.get(i);
						
						if(i==0) dimValues =    StringUtil.checkNull(temp.get("DimTypeID")) 
								        + "/" + StringUtil.checkNull(temp.get("DimValueID"));
						else dimValues += "," + StringUtil.checkNull(temp.get("DimTypeID")) 
								        + "/" + StringUtil.checkNull(temp.get("DimValueID"));					
					}
				}

				setMap.put("s_itemID", StringUtil.checkNull(commandMap.get("s_itemID")));
				String itemTypeCode =  commonService.selectString("item_SQL.selectedItemTypeCode", setMap);
				
				model.put("s_itemID",StringUtil.checkNull(request.getParameter("s_itemID"), ""));
				model.put("instanceNo",instanceNo);
				model.put("instanceClass", StringUtil.checkNull(request.getParameter("instanceClass")));
				model.put("dimValues", dimValues);
				model.put("btnName", btnName);
				model.put("btnStyle", btnStyle);
				model.put("itemTypeCode", itemTypeCode);

			} catch (Exception e) {
				System.out.println(e);
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl("/app/pim/instance/dimAssignTreePopByInst");
		}
	 
	 /**
		 * Dimension Assign Poup 화면에서 [Add] 클릭 이벤트
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
	    @RequestMapping(value="/addDimensionForInstance.do")
	    public String addDimensionForInstance(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
	    	HashMap target = new HashMap();		
			try {
				 
				Map setMap = new HashMap(); 
				
				String itemID = request.getParameter("s_itemID");
				String instanceNo = request.getParameter("instanceNo");
				String instanceClass = request.getParameter("instanceClass");
				
				String dimValueIds = StringUtil.checkNull(request.getParameter("ids"));
			
				String[] arrayDimValueIds = dimValueIds.split(",");

				for (int i = 0; i < arrayDimValueIds.length; i++) {
					
					String dimValueID = arrayDimValueIds[i];
					String[] dimInfo = dimValueID.split("/");
			   
					// ItemID의 ItemTypeCode, ClassCode 취득 
					if(dimInfo.length > 1) {
						
						setMap.put("languageID", commandMap.get("sessionCurrLangType"));
						setMap.put("itemID", dimInfo[0]);
						setMap.put("attrTypeCode", "AT00074");

						String maxLevel = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAttrPlainText", setMap),"1");
						
						setMap.put("dimTypeID", dimInfo[0]); 
						setMap.put("dimValueID", dimInfo[1]);   
						
						String dimLevel = commonService.selectString("dim_SQL.getDimensionLevel", setMap);
						
						if(dimLevel.equals(maxLevel)) {
							setMap.put("ItemID", itemID);
							setMap.put("instanceNo", instanceNo);
							setMap.put("instanceClass", instanceClass);
							setMap.put("DimTypeID", dimInfo[0]); 
							setMap.put("DimValueID", dimInfo[1]);   
							setMap.put("Creator", commandMap.get("sessionUserId"));
							commonService.insert("instance_SQL.insertInstanceDim", setMap);
								
							// INSERT TB_ITEM_DIM_TREE
					   
							// Connection ItemID 취득, NodeID 설정
							//List<String> connectionIdList = new ArrayList<String>();
					   
							//DimTreeAdd.getOverConnectionId(commonService, itemID, dimInfo[0], dimInfo[1], connectionIdList, 0);
							//DimTreeAdd.getUnderConnectionId(commonService, itemID, connectionIdList);
					   
							// connectionId list분, TB_ITEM_DIM_TREE record 입력
							// 단, 이미 존재하는 record 인 경우, INSERT skip
							//DimTreeAdd.insertToTbItemDimTree(commonService, connectionIdList, setMap);
						
							// INSERT TB_MY_DIM_VALUE
//									if(pageFrom.equals("User")){
//										commonService.insert("dim_SQL.insertMyDim", setMap);
//									}
					   
						}
					}
				}

				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				target.put(AJAX_SCRIPT, "this.assignClose();this.$('#isSubmit').remove();");
					
			} catch (Exception e) {
				System.out.println(e);
				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
				//target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			}
			
			model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(AJAXPAGE);
		}
	    
	    /**
		 * Dimension 화면에서 [Del] 클릭 이벤트
		 * @param request
		 * @param model
		 * @return
		 * @throws Exception
		 */
	    @RequestMapping(value="/delDimensionForInstance.do")
		public String delDimensionForInstance(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
			HashMap target = new HashMap();  
			try{
				Map setMap = new HashMap();
				
				String instanceNo = request.getParameter("instanceNo");
				String dimTypeIds = StringUtil.checkNull(request.getParameter("dimTypeIds"));
				String dimValueIds = StringUtil.checkNull(request.getParameter("dimValueIds"));
				
				String[] arrayDimTypeIds = dimTypeIds.split(",");
				String[] arrayDimValueIds = dimValueIds.split(",");
				
				for (int i = 0; i < arrayDimTypeIds.length; i++) {
					String dimTypeID = arrayDimTypeIds[i];
					String dimValueID = arrayDimValueIds[i];
					
					 /* DELETE TB_ITEM_DIM */
					   setMap.put("DimTypeID", dimTypeID);
					   setMap.put("DimValueID", dimValueID);    
					   setMap.put("instanceNo", instanceNo);   
					   commonService.delete("instance_SQL.delDimensionForInstance", setMap);
				}
		   
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
				target.put(AJAX_SCRIPT, "this.doSearchList();this.$('#isSubmit').remove();");
				
		  } catch (Exception e) {
			  System.out.println(e);
			  target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			  //target.put(AJAX_ALERT, "삭제중 오류가 발생하였습니다.");
			  target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
		  }
			model.addAttribute(AJAX_RESULTMAP, target);
	        return nextUrl(AJAXPAGE);
	    }
	    
	    @RequestMapping(value = "/viewInstanceDimDesc.do")
		 public String viewInstanceDimDesc(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
			 String url = "/app/pim/instance/viewInstanceimDesc";
			Map setMap = new HashMap();
			try {
				String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"));
				String dimTypeId = StringUtil.checkNull(request.getParameter("dimTypeId"));
				String dimValueId = StringUtil.checkNull(request.getParameter("dimValueId"));

				setMap.put("instanceNo",instanceNo);
				setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
				
				Map dimInfo = commonService.select("instance_SQL.selectInstanceDim_gridList", setMap);
				Map procInstanceInfo = commonService.select("instance_SQL.getProcInstanceInfo", setMap);
				
				
				model.put("instanceNo",instanceNo);
				model.put("dimTypeId",dimTypeId);
				model.put("dimValueId",dimValueId);
				model.put("dimInfo",dimInfo);
				model.put("authorID",procInstanceInfo.get("OwnerID"));
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
			} catch (Exception e) {
				System.out.println(e.toString());
			}
			return nextUrl(url);
		}
	    
	    @RequestMapping(value = "/saveInstanceDim.do")
		public String saveInstanceDim(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
			HashMap target = new HashMap();
			Map setMap = new HashMap();
			try {
				String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"));
				String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeId"));
				String dimValueID = StringUtil.checkNull(request.getParameter("dimValueId"));
				String description = StringUtil.checkNull(request.getParameter("description"));
				setMap.put("instanceNo", instanceNo);
				setMap.put("dimTypeID", dimTypeID);
				setMap.put("dimValueID", dimValueID);
				setMap.put("description", description);
				
				commonService.update("instance_SQL.updateInstanceDim", setMap);
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장
				target.put(AJAX_SCRIPT,"parent.fnCallBack();this.$('#isSubmit').remove();"); // 성공

			} catch (Exception e) {
				System.out.println(e);
				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
				// target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			}
			model.addAttribute(AJAX_RESULTMAP, target);
			// model.put("noticType", noticType);

			return nextUrl(AJAXPAGE);
		}
	
	    @RequestMapping(value="/updateProcInstanceInfo.do")
	    public String updateProcInstanceInfo(HttpServletRequest request,  HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		Map setMap = new HashMap();
		try {
			String instanceNo = StringUtil.checkNull(request.getParameter("procInstNo"));
			String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"));
			String startTime = StringUtil.checkNull(request.getParameter("startTime"));
		 	String description = StringUtil.checkNull(request.getParameter("description"),"");
		 	String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
		 	String processID = StringUtil.checkNull(request.getParameter("processID"));
		 	setMap.put("itemID", processID);
		 	String procModelID = commonService.selectString("model_SQL.getModelIDFromItem", setMap);
		 	setMap = new HashMap();
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String loginUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String loginTeamID = StringUtil.checkNull(cmmMap.get("sessionTeamId"));
		 	String alarmOption = StringUtil.checkNull(request.getParameter("alarmOption"));
		 	String alarmInterval = StringUtil.checkNull(request.getParameter("alarmInterval"));
		 	String ownerID = StringUtil.checkNull(request.getParameter("ownerID"));
		 	String ownerTeamID = StringUtil.checkNull(request.getParameter("ownerTeamID"));
			String startTimeChange = StringUtil.checkNull(request.getParameter("startTimeChange"));
			
		 	setMap.put("startTime", startTime);
			setMap.put("lastUser", loginUserID);
			setMap.put("ProcInstNo", instanceNo);
			setMap.put("processID", processID);
			setMap.put("procModelID", procModelID);
			setMap.put("alarmOption", alarmOption);
			setMap.put("ownerID", ownerID);
			setMap.put("ownerTeamID", ownerTeamID);
			setMap.put("alarmInterval", alarmInterval);
			setMap.put("iFMessage", null);
		 	commonService.update("instance_SQL.updateInstanceGridData", setMap);
		 	
		 	if(alarmOption.equals("0")) {
				setMap.put("procInstNo", instanceNo);				
				setMap.put("status", "RDY");				
		 		commonService.update("instance_SQL.updateElmInst", setMap);
		 	}
		 	
		 	 if(startTimeChange.equals("T")){
				setMap.put("languageID", languageID);
				setMap.put("procInstNo", instanceNo);
		 		commonService.update("instance_SQL.updateElmInstStartTimeByProcInstStartTime", setMap);		 	 	
		 	 }
		 	 
		 	  
		 	 

			setMap.put("value", description);
			setMap.put("instanceNo", instanceNo);
			setMap.put("instanceClass", instanceClass);
			setMap.put("AttrTypeCode", "AT01003");
			setMap.put("languageID", languageID);
			setMap.put("lastUserTeamID", loginTeamID);
			String attrCNT = commonService.selectString("instance_SQL.getInstanceAttrCNT", setMap);

			setMap.put("attrTypeCode", "AT01003");
			if( attrCNT.equals("0")) {
				setMap.put("regUserID", loginUserID);
				setMap.put("regTeamID", loginTeamID);
				setMap.put("itemID", s_itemID);
				commonService.insert("instance_SQL.insertInstanceAttr",setMap);
			} else {
				commonService.update("instance_SQL.updateInstanceAttr", setMap);
			}
			
			if(!processID.equals("")) {
				setMap.remove("value");
				setMap.remove("attrTypeCode");
				setMap.put("itemID", processID);
				commonService.update("instance_SQL.updateInstanceAttr", setMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "parent.goProcInstanceInfoEdit('V');");
		}catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	    @RequestMapping(value="/withDrawProcInst.do")
	    public String withDrawProcInst(HttpServletRequest request,  HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		Map setMap = new HashMap();
		try {
			String instanceNo = StringUtil.checkNull(request.getParameter("procInstNo"));
			String status = StringUtil.checkNull(request.getParameter("status"));
			String loginUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String loginTeamID = StringUtil.checkNull(cmmMap.get("sessionTeamId"));
			
		 	setMap.put("ProcInstNo", instanceNo);
		 	setMap.put("status", status);
			setMap.put("lastUser", loginUserID);
		 	commonService.update("instance_SQL.updateInstanceGridData", setMap);
		 	
		 	target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "goProcInstanceInfoEdit('V');");
		}catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	    
	    @RequestMapping(value = "/updateProcInstStartTimePop.do")
		public String updateProcInstStartTimePop(HttpServletRequest request, HashMap cmmMap, ModelMap model)throws Exception {
	    	String url = "//app/pim//instance//procInstStartTimePop";
			try {
					String procInstNo = StringUtil.checkNull(request.getParameter("procInstNo"));
					String startTime = StringUtil.checkNull(request.getParameter("startTime"));
		
					model.put("procInstNo", procInstNo);
					model.put("startTime", startTime);
					model.put("menu", getLabel(request, commonService)); /* Label Setting */
					
			} catch (Exception e) {
				System.out.println(e);
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl(url);
	    }
	    
	    
	    @RequestMapping(value="/updateProcInstStartTime.do")
	    public String updateProcInstStartTime(HttpServletRequest request,  HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		Map setMap = new HashMap();
		try {
			String procInstNo = StringUtil.checkNull(request.getParameter("procInstNo"));
			String startTime = StringUtil.checkNull(request.getParameter("startTime"));
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String loginUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String loginTeamID = StringUtil.checkNull(cmmMap.get("sessionTeamId"));
		 	//String alarmOption = StringUtil.checkNull(request.getParameter("alarmOption"));
			//String startTimeChange = StringUtil.checkNull(request.getParameter("startTimeChange"));
			
		 	setMap.put("startTime", startTime);
			setMap.put("lastUser", loginUserID);
			setMap.put("ProcInstNo", procInstNo);
			setMap.put("languageID", languageID);
		 	commonService.update("instance_SQL.updateInstanceGridData", setMap);
			setMap.put("procInstNo", procInstNo);
		 	commonService.update("instance_SQL.updateElmInstStartTimeByProcInstStartTime", setMap);
		 	setMap.put("status", "WAT");				
	 		commonService.update("instance_SQL.updateElmInst", setMap);
		 	
		 	
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "parent.fnCallback();parent.$('#isSubmit').remove();");
		}catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	    }
}
