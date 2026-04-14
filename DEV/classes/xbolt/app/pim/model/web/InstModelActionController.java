package xbolt.app.pim.model.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.text.StringEscapeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DiagramUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;

/**
 * 공통 서블릿 처리
 * @Class Name : InstModelActionController.java
 * @Description : 공통화면을 제공한다.
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2012. 09. 01. smartfactory		최초생성
 *
 * @since 2020. 09. 27.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class InstModelActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
		    
    @RequestMapping(value="/viewProcInstModel.do")
	public String viewProcInstModel(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url="/app/pim/instance/viewProcInstModel";
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");		
			String modelID  =  StringUtil.checkNull(request.getParameter("modelID"),"");			
			String varFilters[] = StringUtil.checkNull(request.getParameter("varFilter")).split(",");
			String varFilter = varFilters[0];
			
			
			String pop = StringUtil.checkNull(request.getParameter("pop"));
			String tLink = StringUtil.checkNull(request.getParameter("tLink"));
			String procInstNo = StringUtil.checkNull(request.getParameter("instanceNo"));
			cmmMap.put("procInstNo", procInstNo);
			String procModelID = StringUtil.checkNull(commonService.selectString("instance_SQL.getProcModelID", cmmMap));
			modelID = procModelID;
		   		   
			List listXML = new ArrayList();
			List listTextXml = new ArrayList();
			Map getData = new HashMap();
			
			String modelXML = "";
			getData.put("ModelID", modelID);
			cmmMap.put("ModelID", modelID);			
			getData.put("languageID", request.getParameter("languageID"));
			/*
			getData.put("ItemID", s_itemID);
									
			Map setData = new HashMap();
			setData.put("itemId", s_itemID);

			Map result  = commonService.select("fileMgt_SQL.selectItemAuthorID",setData);
			
			setData.put("ItemID", s_itemID);

			String itemStatus = StringUtil.checkNull(result.get("Status"));
			
			//Model ID없이 Item ID만 넘어온 경우
			model.put("tobeViewOption", varFilter);
			if(modelID == null || modelID.equals("")){
				MTCategory = "BAS" ;
				if(varFilter.equals("MOD1") && (itemStatus.equals("MOD1")|| itemStatus.equals("MOD2"))) {
					MTCategory = "TOBE" ;
				}else if(varFilter.equals("MOD2")&& itemStatus.equals("MOD2")) {
					MTCategory = "TOBE" ;					
				}else if(varFilter.equals("TOBE")) {
					MTCategory = "TOBE" ;	
				}
				getData.put("MTCategory", MTCategory);
			}	
			
			String attrRevYN = "N";
			if(MTCategory.equals("VER") || MTCategory.equals("WTR")){
				attrRevYN = "Y";
			}else if(MTCategory.equals("BAS") && ( itemStatus.equals("MOD1") || itemStatus.equals("MOD2")) ) {
				attrRevYN = "Y";
			}
			
			String itemAttrRevCNT = "";
			if(!curChangeSetID.equals("") && !curChangeSetID.equals(changeSetID)){
				attrRevYN = "Y";
			}else{ 
				setData.put("changeSetID", changeSetID);
				setData.put("s_itemID", s_itemID);
				itemAttrRevCNT = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAttrRevCNT",setData));
				if(Integer.parseInt(itemAttrRevCNT) > 0){
					attrRevYN = "Y";
				}
			}
			if(changeSetID.equals("")){
				attrRevYN = "N";
			}
			//System.out.println(" MTCategory:"+MTCategory+":itemStaus :"+itemStatus+": attrRevYN :"+attrRevYN+" : changeSetID :"+changeSetID);
			model.put("attrRevYN", attrRevYN);
			*/
			Map modelMap = new HashMap();
			modelMap = commonService.select("model_SQL.getModelViewer", getData);			
			getData.put("DefFontFamily", cmmMap.get("sessionDefFont"));
			getData.put("DefFontSize", cmmMap.get("sessionDefFontSize"));
			getData.put("DefFontStyle", cmmMap.get("sessionDefFontSteyl"));
			getData.put("DefFontColor", cmmMap.get("sessionDefFontColor"));
			getData.put("DefStrokeColor", "#ff0000");			
			
			String modelExsist= null;
			String isModel = null;
			String modelTypeCode = "";
			if(modelMap!=null && !modelMap.isEmpty()){
				isModel = StringUtil.checkNull(modelMap.get("IsModel"));
				getData.put("ModelID", StringUtil.checkNull(modelMap.get("ModelID")));
				getData.put("ItemID", StringUtil.checkNull(modelMap.get("ItemID")));
				getData.put("newElementIDs", StringUtil.checkNull(cmmMap.get("newElementIDs")));
				getData.put("delElementIDs", StringUtil.checkNull(cmmMap.get("delElementIDs")));
				getData.put("newEleStrokeColor", "#0054FF");
				getData.put("delEleStrokeColor", "#ff0000");
				getData.put("modelTypeCode", StringUtil.checkNull(modelMap.get("ModelTypeCode")));
				getData.put("changeSetID", StringUtil.checkNull(modelMap.get("ChangeSetID")));
				model.put("changeSetID", StringUtil.checkNull(modelMap.get("ChangeSetID")));
				String scrnMode  =  StringUtil.checkNull(request.getParameter("scrnMode"));
				getData.put("scrnMode",scrnMode);
				getData.put("procInstNo", procInstNo);
				if(isModel.equals("0")){
					modelXML = StringUtil.checkNull(modelMap.get("ModelXML"));
				}else{
					if(!pop.equals("pop") && tLink.equals("Y")){ getData.put("TLink", "TLINK"); }
					
					/*if(attrRevYN.equals("Y")){
						listXML = commonService.selectList("model_SQL.getElementsAttrRev", getData);
						getData.put("RevYN", "Y");
						listTextXml = commonService.selectList("model_SQL.getElementsByAttrDP", getData);
					}else{ */
						listXML = commonService.selectList("instance_SQL.getProcInstModelElements", getData);	
						listTextXml = commonService.selectList("instance_SQL.getProcInstElementsByAttrDP", getData);
					//}
					if(listTextXml.size() > 0 ){
						String dataType = "";
						String displayType = "";
						String attrTypeCode = "";
						String plainText = "";
						String category = "";
						for(int i=0; listTextXml.size()>i; i++){
							getData = new HashMap();
							Map listTextMap = (Map)listTextXml.get(i);
							
							plainText = StringUtil.checkNull(listTextMap.get("PlainText"));
							dataType = StringUtil.checkNull(listTextMap.get("DataType"));
							displayType = StringUtil.checkNull(listTextMap.get("DisplayType"));							
							attrTypeCode = StringUtil.checkNull(listTextMap.get("AttrTypeCode"));
							category = StringUtil.checkNull(listTextMap.get("Category"));
							getData.put("itemID", listTextMap.get("ObjectID"));
							getData.put("attrTypeCode", listTextMap.get("AttrTypeCode"));
							getData.put("languageID", request.getParameter("languageID"));
							getData.put("displayType", displayType);	
							getData.put("defLanguageID", StringUtil.checkNull(cmmMap.get("sessionDefLanguageId")));
							
							if(displayType.equals("Text")){ //-- Text인 경우 	
								if(attrTypeCode.substring(0, 2).equals("AT")){
									//if (!attrTypeCode.equals("ID") && !attrTypeCode.equals("STS") && !attrTypeCode.equals("MDLNM")&& !attrTypeCode.equals("MDLCAT")&& !attrTypeCode.equals("MDLTP") && !attrTypeCode.equals("SortNum") && !attrTypeCode.equals("TLINK")){ //ITEM ATTR 인 경우
									if(dataType.equals("MLOV")){
										plainText = getMLovVlaue(StringUtil.checkNull(cmmMap.get("sessionCurrLangType")) , StringUtil.checkNull(listTextMap.get("ObjectID")), StringUtil.checkNull(listTextMap.get("AttrTypeCode")));
									}else{
										plainText = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByDataType", getData));
									}									
								}	
							 }else if (!attrTypeCode.equals("STS") && !attrTypeCode.equals("SBICON") && !attrTypeCode.equals("TLINK")){ //-- Text,SBICON 아닌  LOV의 경우 
									plainText = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByImage", getData));	
							 }
							
							 listTextMap.put("PlainText", plainText);
						}
					
					} 
					modelTypeCode = StringUtil.checkNull(modelMap.get("ModelTypeCode"));
				}
				//System.out.println("listTextXml :"+listTextXml);
				modelExsist=(listXML==null?"N":(listXML.size()>0?"Y":"N"));
				model.put("ModelID", modelMap.get("ModelID").toString());cmmMap.put("ModelID", modelMap.get("ModelID").toString());
				model.put("modelName", modelMap.get("ModelName"));cmmMap.put("modelName", modelMap.get("ModelName"));
				model.put("modelTypeName", "Process Instance Model");
				model.put("Dx", modelMap.get("Dx"));model.put("Dy", modelMap.get("Dy"));
				cmmMap.put("Dx", modelMap.get("Dx"));cmmMap.put("Dy", modelMap.get("Dy"));
				if(modelMap.get("ModelBlocked") != null)model.put("ModelBlocked", modelMap.get("ModelBlocked").toString());
				if(modelMap.get("ModelIsPublic") != null)model.put("ModelIsPublic", modelMap.get("ModelIsPublic").toString());
				model.put("menuUrl", modelMap.get("MenuURL"));
				model.put("viewScale", StringUtil.checkNull(modelMap.get("Zoom")));
				model.put("zoomOption", modelMap.get("ZoomOption"));
			}
			
			String itemAthId = "";
			String itemBlocked = "";
			//if(result.get("AuthorID") != null){itemAthId =  StringUtil.checkNull(result.get("AuthorID").toString(),"");}
			//if(result.get("Blocked") != null){itemBlocked =  StringUtil.checkNull(result.get("Blocked").toString(),"");}
					
			//model.put("modelXML", modelXML);
			//model.put("listXML", listXML);	
			//model.put("listTextXml", listTextXml);
			model.put("ItemID", procInstNo);	cmmMap.put("ItemID", s_itemID);	
			model.put("modelExsist", modelExsist);
			model.put("itemAthId",itemAthId);
			model.put("itemBlocked",itemBlocked);
			model.put("option", StringUtil.checkNull(cmmMap.get("option"),""));
			
			cmmMap.put("modelType", "VIEW");
			HashMap xml= new HashMap();
			if(modelMap!=null && !modelMap.isEmpty()){
				xml=DiagramUtil.getMxGraphModelXml(cmmMap, modelXML, listXML, listTextXml);
			}
			model.put("diagramForXml",StringUtil.checkNull(xml.get("diagramForXml")));
			model.put("updateForXml",StringUtil.checkNull(xml.get("updateForXml")));
			model.put("isModel", isModel);
			System.out.println("xml :"+StringUtil.checkNull(xml.get("diagramForXml")));
			// QuickCheckOut 설정
			/*
			String quickCheckOut = "N";
			List projectNameList = new ArrayList();
			if(itemStatus.equals("REL") && itemBlocked.equals("2")){
				setData = new HashMap();
				setData.put("ItemID", s_itemID);
				setData.put("itemID", s_itemID);
				setData.put("accessRight", "U");
				setData.put("userID", StringUtil.checkNull(cmmMap.get("sessionUserId")));
				String changeMgt = StringUtil.checkNull(commonService.selectString("project_SQL.getChangeMgt", setData));
				String myItemMember = StringUtil.checkNull(commonService.selectString("item_SQL.getMyItemMemberID", setData));
				String sessionUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
				if( (changeMgt.equals("1") && itemAthId.equals(sessionUserID)) || myItemMember.equals(sessionUserID) ){
					quickCheckOut = "Y";
				}

				model.put("changeMgt",changeMgt);
				setData = new HashMap();
				setData.put("userId", sessionUserID);
				setData.put("LanguageID", cmmMap.get("sessionCurrLangType"));
				setData.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
				setData.put("ProjectType", "CSR");
				setData.put("isMainItem", "Y");
				projectNameList = commonService.selectList("project_SQL.getProjectNameList", setData);
			}
			model.put("quickCheckOut",quickCheckOut);
			model.put("projectNameList", projectNameList.size());

			setData.put("itemID", s_itemID);
			String ckChangeSetID = StringUtil.checkNull(commonService.selectString("project_SQL.getCurChangeSetIDFromItem", setData));

			// Toolbar에 itemStatus 설정 
			if( itemStatus.equals("NEW2")
					|| itemStatus.equals("DEL2")
					|| (itemStatus.equals("MOD2") && MTCategory.equals("TOBE")) 
					|| (itemStatus.equals("MOD2") && ckChangeSetID.equals(changeSetID))
			) {			
				model.put("itemStatus", itemStatus);
				model.put("viewType","approval");
			}	
			else if(itemStatus.equals("MOD1") || itemStatus.equals("NEW1") || itemStatus.equals("DEL1")) {	
				model.put("itemStatus", itemStatus);	
				model.put("viewType","editing");			
			  		
			}
			*/
			String focusedItemID = StringUtil.checkNull(request.getParameter("focusedItemID"));
			if(!focusedItemID.equals("") && focusedItemID != null){
				Map positionMap = getPosition(request, modelMap);
				model.put("positionX", positionMap.get("positionX"));
				model.put("positionY", positionMap.get("positionY"));	
				model.put("viewScale", 0.8);
				model.put("focusedItemID", focusedItemID);
				//System.out.println("positionMap : "+positionMap);			
			}
			model.put("scrnType", StringUtil.checkNull(request.getParameter("scrnType")));
			model.put("pop", StringUtil.checkNull(request.getParameter("pop")));
			
			//String itemIdentifier = StringUtil.checkNull(commonService.selectString("item_SQL.s_itemIDentifier", setData));
			//model.put("itemIdentifier", itemIdentifier);
			model.put("displayRightBar", StringUtil.checkNull(request.getParameter("displayRightBar"),"block"));
			String infoTabURL = "viewInstInfo";	
			model.put("infoTabURL", infoTabURL);
			model.put("procInstNo", StringUtil.checkNull(request.getParameter("instanceNo")));
			model.put("varFilter", varFilter);
			
			String instanceNo = StringUtil.checkNull(cmmMap.get("instanceNo"));	
			String instanceClass = StringUtil.checkNull(cmmMap.get("instanceClass"));
			String scrnMode = StringUtil.checkNull(request.getParameter("scrnMode"));
			model.put("procInstNo", instanceNo);
			model.put("instanceClass", instanceClass);
			model.put("scrnMode", scrnMode);
			
			// 2025-10-27 mdlFilter 코드 추가
			model.put("mdlFilter", StringUtil.checkNull(request.getParameter("mdlFilter")));
			model.put("itemTypeFilter", StringUtil.checkNull(request.getParameter("itemTypeFilter")));
			model.put("dimTypeFilter", StringUtil.checkNull(request.getParameter("dimTypeFilter")));
			model.put("symTypeFilter", StringUtil.checkNull(request.getParameter("symTypeFilter")));
			
		} catch (Exception e) {
			
			System.out.println(e.toString());
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl(url);
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
	
	private Map getPosition(HttpServletRequest request, Map modelMap) throws ExceptionUtil {
		Map positionMap = new HashMap();
		Map setData = new HashMap();
		try {
			String focusedItemID = StringUtil.checkNull(request.getParameter("focusedItemID")); // IEP 
			String modelID = StringUtil.checkNull(modelMap.get("ModelID"));
			setData.put("modelID", modelID);
			
			if(!focusedItemID.equals("") && focusedItemID != null){
				setData.put("itemID", focusedItemID );
				
			}else{
				setData.put("itemID", StringUtil.checkNull(request.getParameter("selectedTreeID")) );
			}
			
			Map minPositionXYInfo = commonService.select("model_SQL.getMinPositionXYInfo", setData);
			if(!minPositionXYInfo.isEmpty() && !minPositionXYInfo.equals("")){
				String elementCNT = StringUtil.checkNull(commonService.selectString("model_SQL.getElementCNT",setData));
				
				String parent = StringUtil.checkNull(minPositionXYInfo.get("Parent"));
				setData.put("elementID", parent);
				Map positionXYInfo = new HashMap();
				
				int positionX = Integer.parseInt(StringUtil.checkNull(minPositionXYInfo.get("PositionX")));
				int positionY = Integer.parseInt(StringUtil.checkNull(minPositionXYInfo.get("PositionY")));
				if(!parent.equals("")){
					for(int i=0; Integer.parseInt(elementCNT) >i; i++){					
						positionXYInfo = commonService.select("model_SQL.getPositionXYInfo", setData);
						setData.put("elementID", positionXYInfo.get("Parent"));
						//System.out.println("positionXYInfo["+i+"] : "+positionXYInfo);
						if(positionXYInfo.isEmpty() || positionXYInfo.equals("")) {
							break;
						}else{
							positionX = positionX + Integer.parseInt(StringUtil.checkNull(positionXYInfo.get("PositionX")));
							positionY = positionY + Integer.parseInt(StringUtil.checkNull(positionXYInfo.get("PositionY")));
						}
					}
				}
				positionX = (int) (positionX * 0.1);
				positionY = (int) (positionY * 0.1);
				positionMap.put("positionX", positionX);
				positionMap.put("positionY", positionY);
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		return positionMap;
	}
	
	@RequestMapping(value="/viewInstInfo.do")
	public String viewInstInfo(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "/app/pim/instance/viewInstInfo";
		try {			
			String archiCode = StringUtil.checkNull(cmmMap.get("option"),"");
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String instanceClass = StringUtil.checkNull(cmmMap.get("instanceClass"));
			String instanceNo = StringUtil.checkNull(request.getParameter("s_itemID")); // ProcInstNo, ElmInstNo
			String scrnMode = StringUtil.checkNull(request.getParameter("scrnMode"));
			String testCase = StringUtil.checkNull(request.getParameter("testCase"));
			
			Map setData = new HashMap();
			setData.put("languageID", languageID);
			setData.put("elmInstNo", instanceNo);	
			setData.put("testCase", testCase);	
			Map elmInstanceInfo = commonService.select("instance_SQL.getElmInstList_gridList", setData);	
			String procInstNo = "";
			List instAttrList = new ArrayList();
			if(!elmInstanceInfo.isEmpty()){
				procInstNo = StringUtil.checkNull(elmInstanceInfo.get("ProcInstNo"));					
				
				setData.put("itemID", elmInstanceInfo.get("ElmItemID"));
				setData.put("instanceClass", "ELM");
				setData.put("instanceNo", elmInstanceInfo.get("ElmInstNo"));
				instAttrList = (List)commonService.selectList("instance_SQL.getInstanceAttrText", setData);
				for(int i=0; i<instAttrList.size(); i++) {
					String plainText = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(((Map)instAttrList.get(i)).get("PlainText")));
					((Map)instAttrList.get(i)).put("PlainText", plainText);
				}	
				setData.put("instanceNo", procInstNo);
			}else{
				setData.put("instanceNo", instanceNo);
			}
								
			setData.put("instanceClass", "PROC");
			Map procInstanceInfo = commonService.select("instance_SQL.getProcInstanceInfo", setData);	
			
			model.put("elmInstanceInfo", elmInstanceInfo);
			model.put("procInstanceInfo", procInstanceInfo);
			model.put("instAttrList", instAttrList);
		
			model.put("instanceNo", instanceNo);
			model.put("instanceClass", instanceClass);
			model.put("scrnMode", scrnMode);
			model.put("menu", getLabel(cmmMap, commonService));
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);		
	}
	
	@RequestMapping(value="/viewElmInstModel.do")
	public String viewElmInstModel(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url="/app/pim/instance/viewProcInstModel";
		try {
			String elmInstNo = StringUtil.checkNull(request.getParameter("elmInstNo"),"");			
			String varFilters[] = StringUtil.checkNull(request.getParameter("varFilter")).split(",");
			String varFilter = varFilters[0];
			
			
			String pop = StringUtil.checkNull(request.getParameter("pop"));
			String tLink = StringUtil.checkNull(request.getParameter("tLink"));
			String procInstNo = StringUtil.checkNull(request.getParameter("instanceNo"));
			cmmMap.put("procInstNo", procInstNo);
			String elmModelID = StringUtil.checkNull(commonService.selectString("instance_SQL.getElmModelID", cmmMap));
			String modelID = elmModelID;
		   		   
			List listXML = new ArrayList();
			List listTextXml = new ArrayList();
			Map getData = new HashMap();
			
			String modelXML = "";
			getData.put("ModelID", modelID);
			cmmMap.put("ModelID", modelID);			
			getData.put("languageID", request.getParameter("languageID"));
			
			Map modelMap = new HashMap();
			modelMap = commonService.select("model_SQL.getModelViewer", getData);			
			getData.put("DefFontFamily", cmmMap.get("sessionDefFont"));
			getData.put("DefFontSize", cmmMap.get("sessionDefFontSize"));
			getData.put("DefFontStyle", cmmMap.get("sessionDefFontSteyl"));
			getData.put("DefFontColor", cmmMap.get("sessionDefFontColor"));
			getData.put("DefStrokeColor", "#ff0000");			
			
			String modelExsist= null;
			String isModel = null;
			String modelTypeCode = "";
			if(modelMap!=null && !modelMap.isEmpty()){
				isModel = StringUtil.checkNull(modelMap.get("IsModel"));
				getData.put("ModelID", StringUtil.checkNull(modelMap.get("ModelID")));
				getData.put("ItemID", StringUtil.checkNull(modelMap.get("ItemID")));
				getData.put("newElementIDs", StringUtil.checkNull(cmmMap.get("newElementIDs")));
				getData.put("delElementIDs", StringUtil.checkNull(cmmMap.get("delElementIDs")));
				getData.put("newEleStrokeColor", "#0054FF");
				getData.put("delEleStrokeColor", "#ff0000");
				getData.put("modelTypeCode", StringUtil.checkNull(modelMap.get("ModelTypeCode")));
				getData.put("changeSetID", StringUtil.checkNull(modelMap.get("ChangeSetID")));
				model.put("changeSetID", StringUtil.checkNull(modelMap.get("ChangeSetID")));
				String scrnMode  =  StringUtil.checkNull(request.getParameter("scrnMode"));
				getData.put("scrnMode",scrnMode);
				getData.put("procInstNo", procInstNo);
				getData.put("grInstNo", elmInstNo);
				if(isModel.equals("0")){
					modelXML = StringUtil.checkNull(modelMap.get("ModelXML"));
				}else{
					if(!pop.equals("pop") && tLink.equals("Y")){ getData.put("TLink", "TLINK"); }
						listXML = commonService.selectList("instance_SQL.getProcInstModelElements", getData);	
						listTextXml = commonService.selectList("instance_SQL.getProcInstElementsByAttrDP", getData);
					if(listTextXml.size() > 0 ){
						String dataType = "";
						String displayType = "";
						String attrTypeCode = "";
						String plainText = "";
						String category = "";
						for(int i=0; listTextXml.size()>i; i++){
							getData = new HashMap();
							Map listTextMap = (Map)listTextXml.get(i);
							
							plainText = StringUtil.checkNull(listTextMap.get("PlainText"));
							dataType = StringUtil.checkNull(listTextMap.get("DataType"));
							displayType = StringUtil.checkNull(listTextMap.get("DisplayType"));							
							attrTypeCode = StringUtil.checkNull(listTextMap.get("AttrTypeCode"));
							category = StringUtil.checkNull(listTextMap.get("Category"));
							getData.put("itemID", listTextMap.get("ObjectID"));
							getData.put("attrTypeCode", listTextMap.get("AttrTypeCode"));
							getData.put("languageID", request.getParameter("languageID"));
							getData.put("displayType", displayType);	
							getData.put("defLanguageID", StringUtil.checkNull(cmmMap.get("sessionDefLanguageId")));
							
							if(displayType.equals("Text")){ //-- Text인 경우 	
								if(attrTypeCode.substring(0, 2).equals("AT")){
									//if (!attrTypeCode.equals("ID") && !attrTypeCode.equals("STS") && !attrTypeCode.equals("MDLNM")&& !attrTypeCode.equals("MDLCAT")&& !attrTypeCode.equals("MDLTP") && !attrTypeCode.equals("SortNum") && !attrTypeCode.equals("TLINK")){ //ITEM ATTR 인 경우
									if(dataType.equals("MLOV")){
										plainText = getMLovVlaue(StringUtil.checkNull(cmmMap.get("sessionCurrLangType")) , StringUtil.checkNull(listTextMap.get("ObjectID")), StringUtil.checkNull(listTextMap.get("AttrTypeCode")));
									}else{
										plainText = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByDataType", getData));
									}									
								}	
							 }else if (!attrTypeCode.equals("STS") && !attrTypeCode.equals("SBICON") && !attrTypeCode.equals("TLINK")){ //-- Text,SBICON 아닌  LOV의 경우 
									plainText = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByImage", getData));	
							 }
							
							 listTextMap.put("PlainText", plainText);
						}
					
					} 
					modelTypeCode = StringUtil.checkNull(modelMap.get("ModelTypeCode"));
				}
				//System.out.println("listTextXml :"+listTextXml);
				modelExsist=(listXML==null?"N":(listXML.size()>0?"Y":"N"));
				model.put("ModelID", modelMap.get("ModelID").toString());cmmMap.put("ModelID", modelMap.get("ModelID").toString());
				model.put("modelName", modelMap.get("ModelName"));cmmMap.put("modelName", modelMap.get("ModelName"));
				model.put("modelTypeName", "Process Instance Model");
				model.put("Dx", modelMap.get("Dx"));model.put("Dy", modelMap.get("Dy"));
				cmmMap.put("Dx", modelMap.get("Dx"));cmmMap.put("Dy", modelMap.get("Dy"));
				if(modelMap.get("ModelBlocked") != null)model.put("ModelBlocked", modelMap.get("ModelBlocked").toString());
				if(modelMap.get("ModelIsPublic") != null)model.put("ModelIsPublic", modelMap.get("ModelIsPublic").toString());
				model.put("menuUrl", modelMap.get("MenuURL"));
				model.put("viewScale", StringUtil.checkNull(modelMap.get("Zoom")));
				model.put("zoomOption", modelMap.get("ZoomOption"));
			}
			
			String itemAthId = "";
			String itemBlocked = "";
			//if(result.get("AuthorID") != null){itemAthId =  StringUtil.checkNull(result.get("AuthorID").toString(),"");}
			//if(result.get("Blocked") != null){itemBlocked =  StringUtil.checkNull(result.get("Blocked").toString(),"");}
					
			//model.put("modelXML", modelXML);
			//model.put("listXML", listXML);	
			//model.put("listTextXml", listTextXml);
			model.put("ItemID", procInstNo);
			model.put("modelExsist", modelExsist);
			model.put("itemAthId",itemAthId);
			model.put("itemBlocked",itemBlocked);
			model.put("option", StringUtil.checkNull(cmmMap.get("option"),""));
			
			cmmMap.put("modelType", "VIEW");
			HashMap xml= new HashMap();
			if(modelMap!=null && !modelMap.isEmpty()){
				xml=DiagramUtil.getMxGraphModelXml(cmmMap, modelXML, listXML, listTextXml);
			}
			model.put("diagramForXml",StringUtil.checkNull(xml.get("diagramForXml")));
			model.put("updateForXml",StringUtil.checkNull(xml.get("updateForXml")));
			model.put("isModel", isModel);
			System.out.println("xml :"+StringUtil.checkNull(xml.get("diagramForXml")));
			
			String focusedItemID = StringUtil.checkNull(request.getParameter("focusedItemID"));
			if(!focusedItemID.equals("") && focusedItemID != null){
				Map positionMap = getPosition(request, modelMap);
				model.put("positionX", positionMap.get("positionX"));
				model.put("positionY", positionMap.get("positionY"));	
				model.put("viewScale", 0.8);
				model.put("focusedItemID", focusedItemID);
				//System.out.println("positionMap : "+positionMap);			
			}
			model.put("scrnType", StringUtil.checkNull(request.getParameter("scrnType")));
			model.put("pop", StringUtil.checkNull(request.getParameter("pop")));
			
			//String itemIdentifier = StringUtil.checkNull(commonService.selectString("item_SQL.s_itemIDentifier", setData));
			//model.put("itemIdentifier", itemIdentifier);
			model.put("displayRightBar", StringUtil.checkNull(request.getParameter("displayRightBar"),"block"));
			String infoTabURL = "viewInstInfo";	
			model.put("infoTabURL", infoTabURL);
			model.put("procInstNo", StringUtil.checkNull(request.getParameter("instanceNo")));
			model.put("varFilter", varFilter);
			
			String instanceNo = StringUtil.checkNull(cmmMap.get("instanceNo"));	
			String instanceClass = StringUtil.checkNull(cmmMap.get("instanceClass"));
			String scrnMode = StringUtil.checkNull(request.getParameter("scrnMode"));
			model.put("procInstNo", instanceNo);
			model.put("instanceClass", instanceClass);
			model.put("scrnMode", scrnMode);
			
		} catch (Exception e) {
			
			System.out.println(e.toString());
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl(url);
	}
	
}
