 package xbolt.mdl.model.web;

import java.io.*;
import java.net.URLDecoder;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.text.StringEscapeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.org.json.JSONArray;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.DiagramEditCRUDUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.util.DiagramUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;


/**
 * 공통 서블릿 처리
 * @Class Name : DiagramEditActionController.java
 * @Description : Diagram관련 화면을 제공한다.
 * @Modification Information
 * @수정일			수정자		수정내용
 * @--------- 		---------	-------------------------------
 * @2012. 10. 15.	jhAhn		최초생성
 *
 * @since 2012. 10. 15.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class DiagramEditActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;
	
	private DiagramEditCRUDUtil diagramService = new DiagramEditCRUDUtil();
	
	@RequestMapping(value="/newDiagramViewer.do")
	public String newDiagramViewer(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url="/mdl/model/viewModel";
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");		
			String modelID  =  StringUtil.checkNull(request.getParameter("modelID"),"");
			String MTCategory = StringUtil.checkNull(request.getParameter("MTCategory"),""); // 모델 카테고리
			
			String varFilters[] = StringUtil.checkNull(request.getParameter("varFilter")).split(",");
			String varFilter = varFilters[0];
			
			String changeSetID  =  StringUtil.checkNull(request.getParameter("changeSetID"),"");
			String structureID  =  StringUtil.checkNull(request.getParameter("structureID"),"");
			String dbFuncCode  =  StringUtil.checkNull(request.getParameter("dbFuncCode"),"");
			String curChangeSetID = "";
			
			String pop = StringUtil.checkNull(request.getParameter("pop"));
			String tLink = StringUtil.checkNull(request.getParameter("tLink"));
			String focusedObjID = StringUtil.checkNull(request.getParameter("focusedObjID"), "");
			
			//dbFuncCode가 있으면 모델 자동 생성
			if(!dbFuncCode.equals("")) {
				Map setMap = new HashMap();
				setMap.put("itemID",s_itemID);
				modelID = StringUtil.checkNull(commonService.selectString("model_SQL.getModelIDFromItem",setMap));
				if(modelID.equals("")) {
					setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
					setMap.put("UserId", cmmMap.get("sessionUserId")); 
					setMap.put("FontFamily", cmmMap.get("sessionDefFont")); 
					setMap.put("FontStyle", cmmMap.get("sessionDefFontStyle")); 
					setMap.put("FontSize", cmmMap.get("sessionDefFontSize")); 
					setMap.put("FontColor", cmmMap.get("sessionDefFontColor")); 
					setMap.put("GUBUN", "insertBaseModel");
					setMap.put("dbFuncCode", dbFuncCode);
					
					setMap.put("ItemID", s_itemID);
				    commonService.insert("model_SQL.createBaseModel", setMap);
				}
			    modelID = "";
			}			
			
			//Model ID없이 ChangeSetID만 넘어온 경우 --> ModelID를 구함
			if(!changeSetID.equals("") && modelID.equals("") && !varFilter.equals("OPS")){
				Map setData = new HashMap();
				setData.put("changeSetID", changeSetID);
				if(s_itemID.equals("")){
					s_itemID = StringUtil.checkNull(commonService.selectString("cs_SQL.getItemIDForCSID", setData));
				}
				if(varFilter.equals("PRE")){
					setData.put("itemID",s_itemID);
					Map PREChangeSetNumMap = commonService.select("cs_SQL.getChangeSetRNUM", setData);
					if(!PREChangeSetNumMap.isEmpty() && !"0".equals(PREChangeSetNumMap.get("PreRNUM"))){						
						setData.put("rNum", PREChangeSetNumMap.get("PreRNUM"));
						String getPreChangeSetID = StringUtil.checkNull(commonService.selectString("cs_SQL.getNextPreChangeSetID", setData),"");
						//System.out.println("getPreChangeSetID 이전 csID :"+getPreChangeSetID);
						if(!"".equals(getPreChangeSetID)) {
							setData.put("changeSetID", getPreChangeSetID);
							modelID = StringUtil.checkNull(commonService.selectString("model_SQL.getModelIDCSID",setData));
							changeSetID = getPreChangeSetID;
						}						
						else {
							modelID = "-1";
						}						
					}
					else {
						modelID = "-1";
					}
				}else{				
					modelID = StringUtil.checkNull(commonService.selectString("model_SQL.getModelIDCSID",setData));
					setData.put("itemID", s_itemID);
				}
				curChangeSetID = StringUtil.checkNull(commonService.selectString("project_SQL.getCurChangeSetIDFromItem",setData));
				
				
				//System.out.println("modelID ===> "+modelID);
			}
		   		   
			List listXML = new ArrayList();
			List listTextXml = new ArrayList();
			Map getData = new HashMap();
			
			String modelXML = "";
			getData.put("ModelID", modelID);
			cmmMap.put("ModelID", modelID);			
			getData.put("languageID", request.getParameter("languageID"));
			getData.put("ItemID", s_itemID);
									
			Map setData = new HashMap();
			setData.put("itemId", s_itemID);

			Map result  = commonService.select("fileMgt_SQL.selectItemAuthorID",setData);
			
			setData.put("ItemID", s_itemID);

			String itemStatus = StringUtil.checkNull(result.get("Status"));
			
			//Model ID없이 Item ID만 넘어온 경우
			model.put("tobeViewOption", varFilter);
			if(modelID == null || modelID.equals("")){				
				if(!varFilter.equals("OPS")&& ( itemStatus.equals("MOD1") || itemStatus.equals("MOD2"))) {
					MTCategory = "TOBE" ;					
				}else {
					MTCategory = "BAS" ;
				}						
				getData.put("MTCategory", MTCategory);
			}	
			
			String attrRevYN = "N";
			if(MTCategory.equals("VER") || MTCategory.equals("WTR")){
				attrRevYN = "Y";
			}else if(MTCategory.equals("BAS") && ( itemStatus.equals("MOD1") || itemStatus.equals("MOD2")) ) {
				attrRevYN = "Y";
			}
						
			if(!curChangeSetID.equals("") && !curChangeSetID.equals(changeSetID)){
				attrRevYN = "Y";
			}
		//	System.out.println(" MTCategory:"+MTCategory+":itemStaus :"+itemStatus+": attrRevYN :"+attrRevYN+" : changeSetID :"+changeSetID);
			model.put("attrRevYN", attrRevYN);
			
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
				getData.put("structureID", structureID);
				model.put("changeSetID", StringUtil.checkNull(modelMap.get("ChangeSetID")));
				
				String scrnMode  =  StringUtil.checkNull(request.getParameter("scrnMode"),"V");
				getData.put("scrnMode",scrnMode);
				if(!isModel.equals("1")){
					modelXML = StringUtil.checkNull(modelMap.get("ModelXML"));
				}else{
					if(!pop.equals("pop") && tLink.equals("Y")){ getData.put("TLink", "TLINK"); }
					if(attrRevYN.equals("Y")){
						listXML = commonService.selectList("model_SQL.getElementsAttrRev", getData);
						getData.put("attrRevYN", attrRevYN);
						listTextXml = commonService.selectList("model_SQL.getElementsByAttrDP", getData);
					}else{
						listXML = commonService.selectList("model_SQL.getElements", getData);						
						listTextXml = commonService.selectList("model_SQL.getElementsByAttrDP", getData);
					}
					if(listXML.size()>0) {
						for(int i=0; i<listXML.size(); i++) {
							Map listXMLMap = (Map)listXML.get(i);
							listXMLMap.put("PlainText", removeAllTag(StringUtil.checkNull(listXMLMap.get("PlainText"))));
						}
					}
					if(listTextXml.size() > 0 ){
						String dataType = "";
						String displayType = "";
						String attrTypeCode = "";
						String attrType = "";
						String category = "";
						String maxTextLen = "";
						for(int i=0; listTextXml.size()>i; i++){
							getData = new HashMap();
							Map listTextMap = (Map)listTextXml.get(i);
							
							attrType = StringUtil.checkNull(listTextMap.get("AttrType"));
							dataType = StringUtil.checkNull(listTextMap.get("DataType"));
							displayType = StringUtil.checkNull(listTextMap.get("DisplayType"));							
							attrTypeCode = StringUtil.checkNull(listTextMap.get("AttrTypeCode"));
							category = StringUtil.checkNull(listTextMap.get("Category"));
							maxTextLen = StringUtil.checkNull(listTextMap.get("MaxTextLen"));
							getData.put("itemID", listTextMap.get("ObjectID"));
							getData.put("attrTypeCode", listTextMap.get("AttrTypeCode"));
							getData.put("languageID", request.getParameter("languageID"));
							getData.put("displayType", displayType);	
							getData.put("defLanguageID", StringUtil.checkNull(cmmMap.get("sessionDefLanguageId")));
							getData.put("attrRevYN", attrRevYN);
							getData.put("maxTextLen", maxTextLen);
													
							if(displayType.equals("Text")){ //-- Text인 경우 						
								if(attrTypeCode.equals(attrType)){									
									if(dataType.equals("MLOV")){
										attrType = getMLovVlaue(StringUtil.checkNull(cmmMap.get("sessionCurrLangType")) , StringUtil.checkNull(listTextMap.get("ObjectID")), StringUtil.checkNull(listTextMap.get("AttrTypeCode")));
									}else{
										attrType = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByDataType", getData));
									}									
								 }	
							}else if (!attrTypeCode.equals("STS") && !attrTypeCode.equals("SBICON") && !attrTypeCode.equals("TLINK") && !attrTypeCode.equals("FILELINK")){ //-- Text,SBICON 아닌  LOV의 경우 
								attrType = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByImage", getData));	
							}
							
							listTextMap.put("PlainText", attrType);
							
							if(attrTypeCode.equals("FILELINK")) { // FILELINK 시 FILE COUNT = 0 -> FILELINK Remove
								getData.put("DocumentID",StringUtil.checkNull(listTextMap.get("ObjectID")));
								getData.put("s_itemID",StringUtil.checkNull(listTextMap.get("ObjectID")));
								getData.put("itemId", StringUtil.checkNull(listTextMap.get("ObjectID")));
								getData.put("fromToItemID",StringUtil.checkNull(listTextMap.get("ObjectID")));
								List itemList = commonService.selectList("item_SQL.getCxnItemIDList", getData);
								Map getMap = new HashMap();
								/** 첨부문서 관련문서 합치기, 관련문서 itemClassCodep 할당된 fltpCode 로 filtering */
								String rltdItemId = "";
								Map itemMap = new HashMap();
								for(int k = 0; k < itemList.size(); k++){
									itemMap = (HashMap)itemList.get(k);
									getMap.put("ItemID", itemMap.get("ItemID"));
									if (k < itemList.size() - 1) {
									   rltdItemId += StringUtil.checkNull(itemMap.get("ItemID"))+ ",";
									}else{
										rltdItemId += StringUtil.checkNull(itemMap.get("ItemID"));
									}
								}
								
								getData.put("rltdItemId", rltdItemId);			
								List fileList = commonService.selectList("fileMgt_SQL.getFile_gridList", getData);	
								if(fileList.size() == 0) {
									listTextXml.remove(i); i = i-1;
								}
							}
						}
					}					
				
				}
				modelTypeCode = StringUtil.checkNull(modelMap.get("ModelTypeCode"));
				// System.out.println("listTextXml :"+listTextXml);
				modelExsist=(listXML==null?"N":(listXML.size()>0?"Y":"N"));
				model.put("ModelID", modelMap.get("ModelID").toString());cmmMap.put("ModelID", modelMap.get("ModelID").toString());
				model.put("modelName", modelMap.get("ModelName"));cmmMap.put("modelName", modelMap.get("ModelName"));
				model.put("modelTypeName", modelMap.get("ModelTypeName"));
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
			if(result.get("AuthorID") != null){itemAthId =  StringUtil.checkNull(result.get("AuthorID").toString(),"");}
			if(result.get("Blocked") != null){itemBlocked =  StringUtil.checkNull(result.get("Blocked").toString(),"");}
					
			//model.put("modelXML", modelXML);
			//model.put("listXML", listXML);	
			//model.put("listTextXml", listTextXml);
			model.put("ItemID", s_itemID);	cmmMap.put("ItemID", s_itemID);	
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
			// System.out.println("xml :"+StringUtil.checkNull(xml.get("diagramForXml")));
			// QuickCheckOut 설정
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
			
			String focusedItemID = StringUtil.checkNull(request.getParameter("focusedItemID"));

			if(!focusedObjID.equals("")) {
				setData.put("Identifier", focusedObjID);
				focusedItemID = commonService.selectString("report_SQL.getItemIdWithIdentifier", setData);
			}
			
			if(!focusedItemID.equals("") && focusedItemID != null){
				Map positionMap = getPosition(request, modelMap);
				model.put("positionX", positionMap.get("positionX"));
				model.put("positionY", positionMap.get("positionY"));	
				model.put("viewScale", 0.8);
				model.put("focusedItemID", focusedItemID);
				model.put("ItemID", focusedItemID);
				//System.out.println("positionMap : "+positionMap);			
			}
			
			model.put("scrnType", StringUtil.checkNull(request.getParameter("scrnType")));
			model.put("pop", StringUtil.checkNull(request.getParameter("pop")));
			
			String itemIdentifier = StringUtil.checkNull(commonService.selectString("item_SQL.s_itemIDentifier", setData));
			model.put("itemIdentifier", itemIdentifier);
			model.put("displayRightBar", StringUtil.checkNull(request.getParameter("displayRightBar"),"block"));
			model.put("linkOption", StringUtil.checkNull(cmmMap.get("linkOption")));
			
			getData.put("modelTypeCode", modelTypeCode);
			getData.put("defaultUrl", "elmInfoTabMenu");
			String infoTabURL = StringUtil.checkNull(commonService.selectString("model_SQL.getInfoTabURL", getData));	
			if(infoTabURL.equals("")){ infoTabURL = "elmInfoTabMenu"; }
			model.put("infoTabURL", infoTabURL);
			model.put("procInstNo", StringUtil.checkNull(request.getParameter("instanceNo")));
			model.put("varFilter", varFilter);
			model.put("autoSave", StringUtil.checkNull(request.getParameter("autoSave")));
			model.put("showLink", StringUtil.checkNull(request.getParameter("showLink")));
			model.put("tLink", StringUtil.checkNull(request.getParameter("tLink")));
			model.put("mdlFilter", StringUtil.checkNull(request.getParameter("mdlFilter")));
			model.put("itemTypeFilter", StringUtil.checkNull(request.getParameter("itemTypeFilter")));
			model.put("dimTypeFilter", StringUtil.checkNull(request.getParameter("dimTypeFilter")));
			model.put("symTypeFilter", StringUtil.checkNull(request.getParameter("symTypeFilter")));
			
			
			String itemTypeFilter[] = StringUtil.checkNull(request.getParameter("itemTypeFilter")).split(",");			
			String opacityList = StringUtil.checkNull(request.getParameter("opacityList"));
			
			if (opacityList.equals("")) {
				if (itemTypeFilter.length > 0 && !itemTypeFilter[0].isEmpty()) {
				    for (int i = 0; i < itemTypeFilter.length; i++) {
			            if ("OJ00004".equals(itemTypeFilter[i])) {
			                if(i==0) opacityList += "20"; else  opacityList += ",20";
			            } else {
			                if(i==0) opacityList += "100"; else  opacityList += ",100";
			            }
			        }
				}
			} 
			model.put("opacityList", opacityList);
			model.put("languageID", request.getParameter("languageID"));
			System.out.println("focusedObjID === "+focusedObjID);
			
		} catch (Exception e) {
			
			System.out.println(e.toString());
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl(url);
	}
	
	@RequestMapping(value="/diagramViewerAttrRev.do")
	public String diagramViewerAttrRev(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url="/mdl/model/viewModel";
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("itemId"),"");			
			String modelID  =  StringUtil.checkNull(request.getParameter("modelID"),"");
						
			List listXML = new ArrayList();
			List listTextXml = new ArrayList();
			Map getData = new HashMap();
			String modelXML = "";
			getData.put("modelID", modelID);cmmMap.put("ModelID", modelID);			
			getData.put("languageID", cmmMap.get("sessionCurrLangType"));
			getData.put("ItemID", s_itemID);			
			Map modelMap = commonService.select("model_SQL.getModelInfo", getData);
			
			getData.put("DefFontFamily", cmmMap.get("sessionDefFont"));
			getData.put("DefFontSize", cmmMap.get("sessionDefFontSize"));
			getData.put("DefFontStyle", cmmMap.get("sessionDefFontSteyl"));
			getData.put("DefFontColor", cmmMap.get("sessionDefFontColor"));
			getData.put("DefStrokeColor", "#ff0000");
			
			//String SymTypeCode = "'SB00004','SB00005','SB00007'";
			//getData.put("SymTypeCode", SymTypeCode);
			
			String modelExsist= null;
			String isModel = null;
			if(modelMap!=null){
				isModel = StringUtil.checkNull(modelMap.get("IsModel"));
				getData.put("ModelID", StringUtil.checkNull(modelMap.get("ModelID")));
				getData.put("ItemID", StringUtil.checkNull(modelMap.get("ItemID")));
				getData.put("changeSetID", StringUtil.checkNull(modelMap.get("ChangeSetID")));
				getData.put("modelTypeCode", StringUtil.checkNull(modelMap.get("ModelTypeCode")));
				model.put("changeSetID", StringUtil.checkNull(modelMap.get("ChangeSetID")));
				if(isModel.equals("0")){
					modelXML = StringUtil.checkNull(modelMap.get("ModelXML"));
				}else{
					listXML = commonService.selectList("model_SQL.getElementsAttrRev", getData);
					getData.put("RevYN", "Y");
					listTextXml = commonService.selectList("model_SQL.getElementsByAttrDP", getData);
				}
				modelExsist=(listXML==null?"N":(listXML.size()>0?"Y":"N"));
				model.put("ModelID", modelMap.get("ModelID").toString());cmmMap.put("ModelID", modelMap.get("ModelID").toString());
				model.put("modelName", modelMap.get("ModelName"));cmmMap.put("modelName", modelMap.get("ModelName"));
				model.put("modelTypeName", modelMap.get("ModelTypeName"));
				model.put("Dx", modelMap.get("Dx"));model.put("Dy", modelMap.get("Dy"));
				cmmMap.put("Dx", modelMap.get("Dx"));cmmMap.put("Dy", modelMap.get("Dy"));
				if(modelMap.get("ModelBlocked") != null)model.put("ModelBlocked", modelMap.get("ModelBlocked").toString());
				if(modelMap.get("ModelIsPublic") != null)model.put("ModelIsPublic", modelMap.get("ModelIsPublic").toString());
				model.put("viewScale", StringUtil.checkNull(modelMap.get("Zoom")));
			}
			
			Map setData = new HashMap();
			setData.put("itemId", s_itemID);
			Map result  = commonService.select("fileMgt_SQL.selectItemAuthorID",setData);
	
			String itemAthId = "";
			String itemBlocked = "";
			if(result.get("AuthorID") != null){itemAthId =  StringUtil.checkNull(result.get("AuthorID").toString(),"");}
			if(result.get("Blocked") != null){itemBlocked =  StringUtil.checkNull(result.get("Blocked").toString(),"");}

			model.put("ItemID", s_itemID);	cmmMap.put("ItemID", s_itemID);	
			model.put("modelExsist", modelExsist);
			model.put("itemAthId",itemAthId);
			model.put("itemBlocked",itemBlocked);
			model.put("option", StringUtil.checkNull(cmmMap.get("option"),""));
			
			cmmMap.put("modelType", "VIEW");
			HashMap xml=DiagramUtil.getMxGraphModelXml(cmmMap, modelXML, listXML, listTextXml);
			model.put("diagramForXml",StringUtil.checkNull(xml.get("diagramForXml")));
			model.put("updateForXml",StringUtil.checkNull(xml.get("updateForXml")));
			model.put("isModel", isModel);
			model.put("attrRevYN", "Y");
		
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl(url);
	}
	
	@RequestMapping(value="/newDiagramEditor.do")
	public String newDiagramEditor(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url="/mdl/model/editModel";
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			String modelID  =  StringUtil.checkNull(request.getParameter("modelID"));
			List listXML = new ArrayList();
			List listTextXml = new ArrayList();
			
			Map getData = new HashMap();
			String modelXML = "";
			getData.put("ModelID", modelID);				
			getData.put("languageID", request.getParameter("languageID"));
			Map modelMap = new HashMap();					
			modelMap = commonService.select("model_SQL.getModel", getData);
			
			String dfFontFamily = StringUtil.checkNull(cmmMap.get("sessionDefFont"),"");
			String SymTypeCode = "'SB00004','SB00005','SB00007'";
			
			getData.put("DefFontFamily", cmmMap.get("sessionDefFont"));
			getData.put("DefFontSize", cmmMap.get("sessionDefFontSize"));
			getData.put("DefFontStyle", cmmMap.get("sessionDefFontStyle"));
			getData.put("DefFontColor", cmmMap.get("sessionDefFontColor"));
			getData.put("SymTypeCode", SymTypeCode);
			getData.put("DefStrokeColor", "#ff0000");
			getData.put("ItemID", s_itemID);
			getData.put("modelTypeCode", StringUtil.checkNull(modelMap.get("ModelTypeCode")));
			
			String isModel = null;
			if(modelMap!=null){
				String status = StringUtil.checkNull(modelMap.get("Status"));
				isModel = StringUtil.checkNull(modelMap.get("IsModel"));
				getData.put("DefFont", dfFontFamily);
				model.put("modelStatus", status);
				if(isModel.equals("0")){					
					modelXML = StringUtil.checkNull(modelMap.get("ModelXML"));
				}else{
					if(status.equals("NEW")||status.equals("MOD")||status.equals("NEW1")){
						modelXML = StringUtil.checkNull(modelMap.get("ModelXML"));					
					}else{
						String scrnMode  =  StringUtil.checkNull(request.getParameter("scrnMode"));
						getData.put("scrnMode",scrnMode);
						listXML = commonService.selectList("model_SQL.getElements", getData);
						if(listXML.size() > 0) {
							for(int i=0; i<listXML.size();i++) {
								Map listMap = (Map)listXML.get(i);
								String plainText = removeAllTag(StringUtil.checkNull(listMap.get("PlainText")));
								listMap.put("PlainText", plainText);
							}
						}
						listTextXml = commonService.selectList("model_SQL.getElementsByAttrDP", getData);
						if(listTextXml.size() > 0 ){
							String dataType = "";
							String displayType = "";
							String attrTypeCode = "";
							String attrType = "";
							String category = "";
							String maxTextLen="";
							for(int i=0; listTextXml.size()>i; i++){
								getData = new HashMap();
								Map listTextMap = (Map)listTextXml.get(i);
								
								attrType = StringUtil.checkNull(listTextMap.get("AttrType"));
								dataType = StringUtil.checkNull(listTextMap.get("DataType"));
								displayType = StringUtil.checkNull(listTextMap.get("DisplayType"));							
								attrTypeCode = StringUtil.checkNull(listTextMap.get("AttrTypeCode"));
								maxTextLen = StringUtil.checkNull(listTextMap.get("MaxTextLen"));
								category = StringUtil.checkNull(listTextMap.get("Category"));
								getData.put("itemID", listTextMap.get("ObjectID"));
								getData.put("attrTypeCode", listTextMap.get("AttrTypeCode"));
								getData.put("languageID", request.getParameter("languageID"));
								getData.put("displayType", displayType);	
								getData.put("defLanguageID", StringUtil.checkNull(cmmMap.get("sessionDefLanguageId")));
								getData.put("maxTextLen", maxTextLen);	
							
								if(displayType.equals("Text")){ //-- Text인 경우 						
									if(attrTypeCode.equals(attrType)){			
										if(dataType.equals("MLOV")){
											attrType = getMLovVlaue(StringUtil.checkNull(cmmMap.get("sessionCurrLangType")) , StringUtil.checkNull(listTextMap.get("ObjectID")), StringUtil.checkNull(listTextMap.get("AttrTypeCode")));
										}else {
											attrType = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByDataType", getData));
										}									
									 }	
								 }else if (!attrTypeCode.equals("STS") && !attrTypeCode.equals("SBICON")  && !attrTypeCode.equals("FILELINK") ){ //-- Text 아닌  LOV의 경우 
									 attrType = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByImage", getData));	
								 }
								
								listTextMap.put("PlainText", attrType);
								
								if(attrTypeCode.equals("FILELINK")) { // FILELINK 시 FILE COUNT = 0 -> FILELINK Remove
									getData.put("DocumentID",StringUtil.checkNull(listTextMap.get("ObjectID")));
									getData.put("s_itemID",StringUtil.checkNull(listTextMap.get("ObjectID")));
									getData.put("itemId", StringUtil.checkNull(listTextMap.get("ObjectID")));
									getData.put("fromToItemID",StringUtil.checkNull(listTextMap.get("ObjectID")));
									List itemList = commonService.selectList("item_SQL.getCxnItemIDList", getData);
									Map getMap = new HashMap();
									/** 첨부문서 관련문서 합치기, 관련문서 itemClassCodep 할당된 fltpCode 로 filtering */
									String rltdItemId = "";
									Map itemMap = new HashMap();
									for(int k = 0; k < itemList.size(); k++){
										itemMap = (HashMap)itemList.get(k);
										getMap.put("ItemID", itemMap.get("ItemID"));
										if (k < itemList.size() - 1) {
										   rltdItemId += StringUtil.checkNull(itemMap.get("ItemID"))+ ",";
										}else{
											rltdItemId += StringUtil.checkNull(itemMap.get("ItemID"));
										}
									}
									
									getData.put("rltdItemId", rltdItemId);			
									List fileList = commonService.selectList("fileMgt_SQL.getFile_gridList", getData);	
									if(fileList.size() == 0) {
										listTextXml.remove(i); i = i-1;
									}
								}
							}
						
						}
					}
				}
				 //	System.out.println("listXML  :"+listTextXml);
					if(modelMap.get("ModelBlocked") != null)model.put("ModelBlocked", modelMap.get("ModelBlocked").toString());
					if(modelMap.get("ModelIsPublic") != null)model.put("ModelIsPublic", modelMap.get("ModelIsPublic").toString());
					
					cmmMap.put("Dx", modelMap.get("Dx"));cmmMap.put("Dy", modelMap.get("Dy"));
					model.put("modelName", StringUtil.checkNull(modelMap.get("ModelName")));
					cmmMap.put("modelName", StringUtil.checkNull(modelMap.get("ModelName")));	
					model.put("viewScale", StringUtil.checkNull(modelMap.get("Zoom")));
			}
			
			Map setData = new HashMap();
			setData.put("itemId", s_itemID);
			Map result  = commonService.select("fileMgt_SQL.selectItemAuthorID",setData);
	
			model.put("itemAthId", StringUtil.checkNull(result.get("AuthorID")));
			model.put("itemBlocked", StringUtil.checkNull(result.get("Blocked")));
			model.put("selectedItemLockOwner", StringUtil.checkNull(result.get("LockOwner")));
			model.put("ItemClassCode", StringUtil.checkNull(result.get("ClassCode")));
			model.put("ItemStatus", StringUtil.checkNull(result.get("Status")));
			model.put("ItemTypeCode", StringUtil.checkNull(result.get("ItemTypeCode")));
			model.put("ItemPjtID", StringUtil.checkNull(result.get("ProjectID")));
			
			//model.put("modelXML", modelXML);
			//model.put("listXML", listXML);
			//model.put("listTextXml", listTextXml);
			model.put("ModelID", modelID);cmmMap.put("ModelID", modelID);
			model.put("ItemID", s_itemID);cmmMap.put("ItemID", s_itemID);					
			model.put("option", StringUtil.checkNull(request.getParameter("option")));
			model.put("scrnType", StringUtil.checkNull(request.getParameter("scrnType")));
			model.put("linkOption", StringUtil.checkNull(cmmMap.get("linkOption")));
			
			HashMap xml=DiagramUtil.getMxGraphModelXml(cmmMap, modelXML, listXML, listTextXml);
			model.put("diagramForXml",StringUtil.checkNull(xml.get("diagramForXml")));
			model.put("updateForXml",StringUtil.checkNull(xml.get("updateForXml")));
			model.put("isModel", isModel);
			
			System.out.println("diagramForXml :" + StringUtil.checkNull(xml.get("diagramForXml")));
			
			// getSymType
			setData = new HashMap();
			setData.put("languageID", cmmMap.get("sessionCurrLangType")); 
			setData.put("modelTypeCode", StringUtil.checkNull(modelMap.get("ModelTypeCode")));
			List symTypeList = commonService.selectList("model_SQL.getSymbolTypeList",setData);
			
			String symTypeCode = "";
			String imagePath = "";
			String defFontColor = "";
			String fillColor = "";
			String strokeColor = "";
			String shadow = "";
			String gradientColor = "";
			String generalPalette = "";
			
			// symbol Palette 설정
			if(symTypeList.size()>0){
				for(int i=0; i<symTypeList.size(); i++){
					Map symbolMap = (Map)symTypeList.get(i);
					symTypeCode = StringUtil.checkNull(symbolMap.get("SymTypeCode"));
					imagePath = StringUtil.checkNull(symbolMap.get("ImagePath"));
					defFontColor = StringUtil.checkNull(symbolMap.get("DefFontColor"));
					fillColor = StringUtil.checkNull(symbolMap.get("DefFillColor"));
					strokeColor = StringUtil.checkNull(symbolMap.get("DefStrokeColor"));
					shadow = StringUtil.checkNull(symbolMap.get("DefShadow"));
					gradientColor = StringUtil.checkNull(symbolMap.get("DefGradientColor"));
					generalPalette = imagePath+";fillColor="+ fillColor
							+ ";strokeColor="+strokeColor
							+ ";fontFamily="+StringUtil.checkNull(symbolMap.get("DefFontFamily"))
							+ ";fontStyle="+StringUtil.checkNull(symbolMap.get("DefFontStyle"))
							+ ";fontSize="+StringUtil.checkNull(symbolMap.get("DefFontSize"))
							+ ";fontColor="+defFontColor
							+ ";shadow="+shadow	
							+ ";gradientColor="+gradientColor
							+ ";startSize=38;symTypeCode="+symTypeCode+";";							
					symbolMap.put("generalPalette", generalPalette);
				}
			}
			model.put("symTypeList", symTypeList); 
			model.put("autoSave", StringUtil.checkNull(request.getParameter("autoSave")));
			model.put("showLink", StringUtil.checkNull(request.getParameter("showLink")));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl(url);
	}
	
	private String removeAllTag(String str) { 		
		str = str.replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&#40;", "(").replaceAll("&#41;", ")").replace("&sect;","-").replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn").replaceAll("\r\n", "&&rn");
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");
		return str;
		//return StringEscapeUtils.unescapeHtml4(str);
	}
	
	@RequestMapping(value="/modelView_H.do")
	public String viewModel(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url="/mdl/model/viewModel";
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			String modelID  =  StringUtil.checkNull(request.getParameter("modelID"),"");
			String MTCategory = StringUtil.checkNull(request.getParameter("MTCategory"),""); // 모델 카테고리
		   		   	
			List listXML = new ArrayList();
			List listTextXml = new ArrayList();
			Map getData = new HashMap();
			
			String modelXML = "";
			getData.put("ModelID", modelID);
			cmmMap.put("ModelID", modelID);			
			getData.put("languageID", request.getParameter("languageID"));
			getData.put("ItemID", s_itemID);
									
			Map setData = new HashMap();
			setData.put("itemId", s_itemID);

			Map result  = commonService.select("fileMgt_SQL.selectItemAuthorID",setData);
			
			String itemStatus = StringUtil.checkNull(result.get("Status"));
			String tobeViewOption = StringUtil.checkNull(request.getParameter("varFilter"));
			model.put("tobeViewOption", tobeViewOption);
			if(modelID == null || modelID.equals("")){
				MTCategory = "BAS" ;
				if(tobeViewOption.equals("MOD1") && (itemStatus.equals("MOD1")|| itemStatus.equals("MOD2"))) {
					MTCategory = "TOBE" ;
				}else if(!tobeViewOption.equals("MOD1")&& itemStatus.equals("MOD2")) {
					MTCategory = "TOBE" ;					
				}	
				getData.put("MTCategory", MTCategory);
			}	
			Map modelMap = new HashMap();
			modelMap = commonService.select("model_SQL.getModelViewer", getData);			
			getData.put("DefFontFamily", cmmMap.get("sessionDefFont"));
			getData.put("DefFontSize", cmmMap.get("sessionDefFontSize"));
			getData.put("DefFontStyle", cmmMap.get("sessionDefFontSteyl"));
			getData.put("DefFontColor", cmmMap.get("sessionDefFontColor"));
			getData.put("DefStrokeColor", "#ff0000");			
			String pop = StringUtil.checkNull(request.getParameter("pop"));
			String tLink = StringUtil.checkNull(request.getParameter("tLink"));
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
				String scrnMode  =  StringUtil.checkNull(request.getParameter("scrnMode"),"V");
				getData.put("scrnMode",scrnMode);
			
				if(isModel.equals("0")){
					modelXML = StringUtil.checkNull(modelMap.get("ModelXML"));
				}else{
					if(!pop.equals("pop") && tLink.equals("Y")){ getData.put("TLink", "TLINK"); }
					listXML = commonService.selectList("model_SQL.getElements", getData);	
					listTextXml = commonService.selectList("model_SQL.getElementsByAttrDP", getData);
					
					if(listTextXml.size() > 0 ){
						String dataType = "";
						String displayType = "";
						String attrTypeCode = "";
						String attrType = "";
						String category = "";
						for(int i=0; listTextXml.size()>i; i++){
							getData = new HashMap();
							Map listTextMap = (Map)listTextXml.get(i);
							
							attrType = StringUtil.checkNull(listTextMap.get("AttrType"));
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
								if(attrTypeCode.equals(attrType)){			
									if(dataType.equals("MLOV")){
										attrType = getMLovVlaue(StringUtil.checkNull(cmmMap.get("sessionCurrLangType")) , StringUtil.checkNull(listTextMap.get("ObjectID")), StringUtil.checkNull(listTextMap.get("AttrTypeCode")));
									}else{
										attrType = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByDataType", getData));
									}									
								 }	
							 }else if (!attrTypeCode.equals("STS") && !attrTypeCode.equals("SBICON") && !attrTypeCode.equals("TLINK")){ //-- Text 아닌  LOV의 경우 
								 attrType = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByImage", getData));	
							 }
							
							listTextMap.put("PlainText", attrType);
						}
					
					}
					modelTypeCode = StringUtil.checkNull(modelMap.get("ModelTypeCode"));
				}
				modelExsist=(listXML==null?"N":(listXML.size()>0?"Y":"N"));
				model.put("ModelID", modelMap.get("ModelID").toString());cmmMap.put("ModelID", modelMap.get("ModelID").toString());
				model.put("modelName", modelMap.get("ModelName"));cmmMap.put("modelName", modelMap.get("ModelName"));
				model.put("modelTypeName", modelMap.get("ModelTypeName"));
				model.put("Dx", modelMap.get("Dx"));model.put("Dy", modelMap.get("Dy"));
				cmmMap.put("Dx", modelMap.get("Dx"));cmmMap.put("Dy", modelMap.get("Dy"));
				if(modelMap.get("ModelBlocked") != null)model.put("ModelBlocked", modelMap.get("ModelBlocked").toString());
				if(modelMap.get("ModelIsPublic") != null)model.put("ModelIsPublic", modelMap.get("ModelIsPublic").toString());
				model.put("menuUrl", modelMap.get("MenuURL"));
				model.put("viewScale", modelMap.get("Zoom"));
				model.put("zoomOption", modelMap.get("ZoomOption"));
			}			
			String itemAthId = "";
			String itemBlocked = "";
			if(result.get("AuthorID") != null){itemAthId =  StringUtil.checkNull(result.get("AuthorID").toString(),"");}
			if(result.get("Blocked") != null){itemBlocked =  StringUtil.checkNull(result.get("Blocked").toString(),"");}					
	
			model.put("ItemID", s_itemID);	cmmMap.put("ItemID", s_itemID);	
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
			
			// QuickCheckOut 설정
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
			model.put("modelViewHYN", "Y");
			// Toolbar에 itemStatus 설정 
			if( itemStatus.equals("NEW2")|| itemStatus.equals("DEL2")|| (itemStatus.equals("MOD2") && MTCategory.equals("TOBE"))){			
				model.put("itemStatus", itemStatus);
			}	
		
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
			model.put("linkOption", StringUtil.checkNull(cmmMap.get("linkOption")));
			
			getData.put("modelTypeCode", modelTypeCode);
			getData.put("defaultUrl", "setItemTabMenu");
			String infoTabURL = StringUtil.checkNull(commonService.selectString("model_SQL.getInfoTabURL", getData));	
			if(infoTabURL.equals("")){ infoTabURL = "setItemTabMenu"; }
			model.put("infoTabURL", infoTabURL);
			
			model.put("mdlFilter", StringUtil.checkNull(cmmMap.get("mdlFilter")));			
		} catch (Exception e) {
			
			System.out.println(e.toString());
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl(url);
	}
	
	private Map getPosition(HttpServletRequest request, Map modelMap) throws ExceptionUtil {
		Map positionMap = new HashMap();
		Map setData = new HashMap();
		try {
			String focusedItemID = StringUtil.checkNull(request.getParameter("focusedItemID")); // IEP 
			String modelID = StringUtil.checkNull(modelMap.get("ModelID"));
			setData.put("modelID", modelID);
			// System.out.println("&& focusedItemID  :"+focusedItemID);
			
			if(!focusedItemID.equals("") && focusedItemID != null){
				setData.put("itemID", focusedItemID );
				
			}else{
				setData.put("itemID", StringUtil.checkNull(request.getParameter("selectedTreeID")) );
			}
			
			Map minPositionXYInfo = commonService.select("model_SQL.getMinPositionXYInfo", setData);
			if(!minPositionXYInfo.isEmpty() && !minPositionXYInfo.equals("")){
				String elementCNT = StringUtil.checkNull(commonService.selectString("model_SQL.getElementCNT",setData));
				// System.out.println("minPositionXYInfo :"+minPositionXYInfo);
				
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
							//System.out.println("i break :"+i);
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
				//System.out.println("positionX :"+positionX+", positionY : "+positionY);
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		return positionMap;
	}
	
	
	@RequestMapping(value="/saveModelBlocked.do")
	public String saveModelBlocked(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
			List blnkList = new ArrayList();
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			cmmMap.put("ModelID", StringUtil.checkNull(request.getParameter("modelID")));		
			cmmMap.put("ItemID", s_itemID);		
			cmmMap.put("GUBUN", "blocked");
			diagramService.save(blnkList, cmmMap,commonService);
			//target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			//target.put(AJAX_MESSAGE, "저장이 성공하였습니다.");
			target.put(AJAX_SCRIPT, "");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "");
			//target.put(AJAX_ALERT, "Block시키는 중에 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00090"));
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXNOPAGE);
	}
	@RequestMapping(value="/saveDiagram.do")
	public String saveDiagram(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
			List blnkList = new ArrayList();
			cmmMap.put("GUBUN", "save");			
			cmmMap.put("imgXml",URLDecoder.decode(StringUtil.checkNull(request.getParameter("plain")), "UTF-8"));	
			String diagram = URLDecoder.decode(StringUtil.checkNull(request.getParameter("diagram")), "UTF-8");			
			diagram = replaceTag(diagram);
			
			cmmMap.put("diagram",diagram);			
			diagramService.save(blnkList, cmmMap,commonService);
			//target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "");
			//target.put(AJAX_ALERT, "저장중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXNOPAGE);
	}

	@RequestMapping(value="/commitDiagram.do")
	public String commitDiagram(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
			List blnkList = new ArrayList();
			cmmMap.put("GUBUN", "commit");
			cmmMap.put("imgXml",URLDecoder.decode(StringUtil.checkNull(request.getParameter("plain")), "UTF-8"));		
			String diagram = URLDecoder.decode(StringUtil.checkNull(request.getParameter("diagram")), "UTF-8");
			
			String replaceSymTypeCode = StringUtil.checkNull(request.getParameter("replaceSymTypeCode"));
			String replaceLinkID = StringUtil.checkNull(request.getParameter("replaceLinkID"));
			String defSymSize = StringUtil.checkNull(request.getParameter("defSymSize"));
			String modelID = StringUtil.checkNull(request.getParameter("modelID"));
			
			diagram = replaceTag(diagram);
			cmmMap.put("diagram",diagram);	
			// Select Item ProjectId 
			Map setData = new HashMap();
			setData.put("itemId", cmmMap.get("itemID"));
			Map result  = commonService.select("fileMgt_SQL.selectItemAuthorID",setData);
			cmmMap.put("itemPjtID", result.get("ProjectID"));
			
			diagramService.save(blnkList, cmmMap,commonService);
			
			if(!replaceSymTypeCode.equals("")) { // 변경할 심뵬이 있으면 심볼변경
				updateSymbol(cmmMap, replaceLinkID, modelID, replaceSymTypeCode, defSymSize);
			}
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00091"));
			target.put(AJAX_SCRIPT, "");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "");
			//target.put(AJAX_ALERT, "DB Commit중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00092"));
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXNOPAGE);
	}	
	
	private String replaceTag(String str) {
		str = str.replaceAll("&lt;p&gt;", "");
		str = str.replaceAll("&lt;/p&gt;", "&#xa;");
		str = str.replaceAll("&lt;br&gt;", "&#xa;");	
		str = str.replaceAll("&amp;nbsp;", " "); 
		str = str.replaceAll("&amp;amp;", "&amp;");
		str = str.replaceAll("&lt;div&gt;", "&#xa;"); 
		str = str.replaceAll("&lt;/div&gt;", ""); 
		
		return str;
	}	
	 
	@RequestMapping(value="/batchExportMdlImage")
	public String batchExportMdlImage(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap(); 
		setMap.put("extCode", StringUtil.checkNull(request.getParameter("language"),cmmMap.get("sessionCurrLangCode").toString()));
		String fromIdentifier = StringUtil.checkNull(request.getParameter("fromItemID"));
		String level = StringUtil.checkNull(request.getParameter("level"));
		
		String LanguageID = commonService.selectString("common_SQL.getLanguageID",setMap);
		
		setMap.put("identifier", fromIdentifier);
		setMap.put("itemTypeCode", "OJ00001");
		
		String fromItemID = commonService.selectString("item_SQL.getItemID",setMap);

		setMap.put("fromItemID", fromItemID);
		setMap.put("level", level);
		setMap.put("languageID", StringUtil.checkNull(LanguageID,"1042"));
		List result  = commonService.selectList("model_SQL.getBatchList",setMap);

		model.put("languageID", StringUtil.checkNull(LanguageID,"1042"));
		model.put("result", result);
		model.put("maxCount", result.size());

		return nextUrl("/mdl/model/batchExportMdlImage");
	}
	
	@RequestMapping(value="/batchGetMdlImage")
	public String batchGetMdlImage(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			//if(StringUtil.checkNull(cmmMap.get("browserType")).equals("IE11")){url="/mdl/model/DiagramViewer_v3.4";}
			//url="/mdl/model/DiagramViewerDemo";
			String s_itemID = s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			
			String modelID  =  StringUtil.checkNull(request.getParameter("modelID"),"");
			String MTCategory = StringUtil.checkNull(request.getParameter("MTCategory"),""); // 모델 카테고리
			if(MTCategory.equals("")){
				MTCategory = "BAS";
			}
						
			List listXML = new ArrayList();
			List listTextXml = new ArrayList();
			Map getData = new HashMap();
			String modelXML = "";
			getData.put("ModelID", modelID);cmmMap.put("ModelID", modelID);			
			getData.put("languageID", request.getParameter("languageID"));
			getData.put("ItemID", s_itemID);
			getData.put("MTCategory", MTCategory);
			Map modelMap = new HashMap();					
			if(MTCategory.equals("VER")){// 20140902 hyoh 모델카테고리가 version 일경우 
				modelMap = commonService.select("model_SQL.getModel", getData);
			}else{
				modelMap = commonService.select("model_SQL.getModelViewer", getData);
			}
			/*
			if(modelMap!=null){
				modelID = StringUtil.checkNull(modelMap.get("ModelID"));getData.put("ModelID", modelID);
				//System.out.println("2:::s_itemID : "+s_itemID+" setID:"+setID+", modelID="+modelID);
				String status = StringUtil.checkNull(modelMap.get("Status"));
				if(status.equals("NEW")||status.equals("MOD")||status.equals("NEW1")){modelXML = StringUtil.checkNull(modelMap.get("ModelXML"));}
				else{returnData = commonService.selectList("model_SQL.getElements", getData);}
			}
			*/
			getData.put("DefFontFamily", cmmMap.get("sessionDefFont"));
			getData.put("DefFontSize", cmmMap.get("sessionDefFontSize"));
			getData.put("DefFontStyle", cmmMap.get("sessionDefFontSteyl"));
			getData.put("DefFontColor", cmmMap.get("sessionDefFontColor"));
			getData.put("DefStrokeColor", "#ff0000");
			
						
			String modelExsist= null;
			String isModel = null;
			if(modelMap!=null){
				isModel = StringUtil.checkNull(modelMap.get("IsModel"));
				getData.put("ModelID", StringUtil.checkNull(modelMap.get("ModelID")));
				getData.put("ItemID", StringUtil.checkNull(modelMap.get("ItemID")));
				
				if(isModel.equals("0")){
					modelXML = StringUtil.checkNull(modelMap.get("ModelXML"));
				}else{
					listXML = commonService.selectList("model_SQL.getElements", getData);
					if(listXML.size() > 0) {
						for(int i=0; i<listXML.size();i++) {
							Map listMap = (Map)listXML.get(i);
							String plainText = removeAllTag(StringUtil.checkNull(listMap.get("PlainText")));
							listMap.put("PlainText", plainText);
						}
					}
					listTextXml = commonService.selectList("model_SQL.getElementsByAttrDP", getData);					
					if(listTextXml.size() > 0 ){
						String dataType = "";
						String displayType = "";
						String attrTypeCode = "";
						String attrType = "";
						String category = "";
						for(int i=0; listTextXml.size()>i; i++){
							getData = new HashMap();
							Map listTextMap = (Map)listTextXml.get(i);
							
							attrType = StringUtil.checkNull(listTextMap.get("AttrType"));
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
								if(attrTypeCode.equals(attrType)){			
									if(dataType.equals("MLOV")){
										attrType = getMLovVlaue(StringUtil.checkNull(cmmMap.get("sessionCurrLangType")) , StringUtil.checkNull(listTextMap.get("ObjectID")), StringUtil.checkNull(listTextMap.get("AttrTypeCode")));
									}else {
										attrType = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByDataType", getData));
									}									
								 }	
							 }else if (!attrTypeCode.equals("STS") && !attrTypeCode.equals("SBICON") ){ //-- Text 아닌  LOV의 경우 
								 attrType = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByImage", getData));	
							 }
							
							listTextMap.put("PlainText", attrType);
						}
					}
				}
				modelExsist=(listXML==null?"N":(listXML.size()>0?"Y":"N"));
				model.put("ModelID", modelMap.get("ModelID").toString());cmmMap.put("ModelID", modelMap.get("ModelID").toString());
				model.put("modelName", modelMap.get("ModelName"));cmmMap.put("modelName", modelMap.get("ModelName"));
				model.put("modelTypeName", modelMap.get("ModelTypeName"));
				model.put("Dx", modelMap.get("Dx"));model.put("Dy", modelMap.get("Dy"));
				cmmMap.put("Dx", modelMap.get("Dx"));cmmMap.put("Dy", modelMap.get("Dy"));
				if(modelMap.get("ModelBlocked") != null)model.put("ModelBlocked", modelMap.get("ModelBlocked").toString());
				if(modelMap.get("ModelIsPublic") != null)model.put("ModelIsPublic", modelMap.get("ModelIsPublic").toString());
				model.put("menuUrl", modelMap.get("MenuURL"));
				model.put("viewScale", StringUtil.checkNull(modelMap.get("Zoom")));
				model.put("zoomOption", modelMap.get("ZoomOption"));
			}
			
			Map setData = new HashMap();
			setData.put("itemId", s_itemID);
			Map result  = commonService.select("fileMgt_SQL.selectItemAuthorID",setData);
	
			String itemAthId = "";
			String itemBlocked = "";
			if(result.get("AuthorID") != null){itemAthId =  StringUtil.checkNull(result.get("AuthorID").toString(),"");}
			if(result.get("Blocked") != null){itemBlocked =  StringUtil.checkNull(result.get("Blocked").toString(),"");}
	
			model.put("ItemID", s_itemID);	cmmMap.put("ItemID", s_itemID);	
			model.put("modelExsist", modelExsist);
			model.put("itemAthId",itemAthId);
			model.put("itemBlocked",itemBlocked);
			model.put("option", StringUtil.checkNull(cmmMap.get("option"),""));
			
			cmmMap.put("modelType", "VIEW");
			HashMap xml=DiagramUtil.getMxGraphModelXml(cmmMap, modelXML, listXML, listTextXml);
			model.put("diagramForXml",StringUtil.checkNull(xml.get("diagramForXml")));
			model.put("updateForXml",StringUtil.checkNull(xml.get("updateForXml")));
			model.put("isModel", isModel);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl("/mdl/model/batchSetMdlImage");
	}
	
	@RequestMapping(value="/batchSetMdlImage")
	public String batchSetMdlImage(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
			Map setMapInfo = new HashMap(); 
			cmmMap.put("imgXml",URLDecoder.decode(StringUtil.checkNull(request.getParameter("plain")), "UTF-8"));
			cmmMap.put("fileModelID", cmmMap.get("ModelID"));
			//cmmMap.put("filename", cmmMap.get("filename"));
			//cmmMap.put("w", cmmMap.get("w"));
			//cmmMap.put("h", cmmMap.get("h"));
			cmmMap.put("format", "png");
			cmmMap.put("bg", "#ffffff");
			cmmMap.put("sessionCurrLangCode", cmmMap.get("sessionCurrLangCode"));
			cmmMap.put("GUBUN", "batchSetMdlImage");
			List blnkList = new ArrayList();
			
			diagramService.save(blnkList, cmmMap, commonService);
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00091"));
			target.put(AJAX_SCRIPT, "");
		}
		catch(Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "");
			//target.put(AJAX_ALERT, "DB Commit중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00092"));		
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXNOPAGE);
	}
	
	@RequestMapping(value="/ModelTree.do")
	public String ModelTree(HttpServletRequest request, ModelMap model) throws Exception {
		try {
			List returnData = new ArrayList();
			Map getData = new HashMap();
			returnData = commonService.selectList("model_SQL.getItemsWhereMDCategory", getData);			
			model.put("MDItems", returnData);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/mdl/model/ModelTree");
	}
	
	@RequestMapping(value="/CreateAndSelectModelPopup.do")
	public String CreateAndSelectModelPopup(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			List returnData = new ArrayList();
			returnData = commonService.selectList("model_SQL.getModelsWithItemID", cmmMap);
			model.put("ModelsGivenItemID", returnData);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/mdl/model/CreateAndSelectModelPopup");
	}
	
	@RequestMapping(value="/createModel.do")
	public String makeModel(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			String ItemID = request.getParameter("ItemID");
			String modelName = request.getParameter("ModelName");
			Map getData = new HashMap();
			getData.put("ItemID", ItemID);
			
			Map maxModelID = new HashMap();
			
			maxModelID = commonService.select("model_SQL.getMaxModelID", getData);
			
			getData.put("ModelID", maxModelID.get("maxModelID"));
			getData.put("GlobalID", UUID.randomUUID().toString());
			getData.put("Name", modelName);
			getData.put("languageID", cmmMap.get("sessionCurrLangType"));
			
			commonService.insert("model_SQL.insertModel", getData);
			commonService.insert("model_SQL.insertModelAttr", getData);
			
			model.put("maxModel", maxModelID);
						
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}	
		
		return nextUrl("/mdl/model/createModel");
	}	
	
	@RequestMapping(value="/searchItemIdPopup.do")
	public String searchItemIdPopup(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			//List returnData = new ArrayList();
			//returnData = commonService.selectList("model_SQL.getModelsWithItemID", cmmMap);
			//model.put("ModelsGivenItemID", returnData);
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/mdl/model/searchItemIdPop");
	}
	
	@RequestMapping(value="/baseModelInitial.do")
	public String baseModelInitial(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
				String ItemID = StringUtil.checkNull(request.getParameter("itemID"),"");
				String mdlType = StringUtil.checkNull(request.getParameter("mdlType"),"");
				String confirmYN = StringUtil.checkNull(request.getParameter("confirmYN"),"");
				String dbFuncCode = StringUtil.checkNull(request.getParameter("dbFuncCode"),"");
				String udfSTR = StringUtil.checkNull(request.getParameter("udfSTR"),"");
				if(dbFuncCode.equals("")) dbFuncCode = "CREATE_BASEMODEL"; // default procedure
				Map getData = new HashMap();
				getData.put("ItemID", ItemID);
				getData.put("LanguageID", cmmMap.get("sessionCurrLangType"));
				getData.put("UserId", cmmMap.get("sessionUserId")); 
				getData.put("FontFamily", cmmMap.get("sessionDefFont")); 
				getData.put("FontStyle", cmmMap.get("sessionDefFontStyle")); 
				getData.put("FontSize", cmmMap.get("sessionDefFontSize")); 
				getData.put("FontColor", cmmMap.get("sessionDefFontColor")); 
				getData.put("GUBUN", "insertBaseModel");	
				getData.put("mdlType", mdlType);
				getData.put("dbFuncCode", dbFuncCode);
				
				getData.put("MTCategory", "BAS");
				String basModelCNT = StringUtil.checkNull(commonService.selectString("model_SQL.getModelCount", getData));
				if(Integer.parseInt(basModelCNT) == 0 || confirmYN.equals("Y")){
					commonService.insert("model_SQL.createBaseModel", getData);
					//getData.put("modelTypeCode", mdlType);
					String modelID = commonService.selectString("model_SQL.getMaxModelIDofItem", getData);
					cmmMap.put("modelID",modelID);	
					String isModel = commonService.selectString("model_SQL.getDiagramType", cmmMap);
				
					if(Integer.parseInt(isModel)==2) {
						modelXmlSave(request, cmmMap, model);
					}
					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
					target.put(AJAX_SCRIPT, "this.doCallBack();");
				}else{
					target.put(AJAX_SCRIPT, "this.fnConfirm('"+mdlType+"','"+dbFuncCode+"');");
				}
							
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	@RequestMapping(value="/modelXmlSave.do")
	public void modelXmlSave(HttpServletRequest request, HashMap cmmMap ,ModelMap model) throws Exception{
		Map target = new HashMap();
		HashMap setMap = new HashMap();
		List listXML = new ArrayList();
		List listTextXml = new ArrayList();
		Map getData = new HashMap();

		getData.put("languageID", cmmMap.get("sessionCurrLangType"));
		getData.put("ItemID", request.getParameter("itemID"));
		getData.put("ModelID", cmmMap.get("modelID"));
		getData.put("DefFontFamily", cmmMap.get("sessionDefFont"));
		getData.put("DefFontSize", cmmMap.get("sessionDefFontSize"));
		getData.put("DefFontStyle", cmmMap.get("sessionDefFontStyle"));
		getData.put("DefFontColor", cmmMap.get("sessionDefFontColor"));
		getData.put("DefStrokeColor", "#ff0000");

		Map modelMap = new HashMap();
		modelMap = commonService.select("model_SQL.getModelViewer", getData);
		getData.put("ModelID", StringUtil.checkNull(modelMap.get("ModelID")));
		getData.put("ItemID", StringUtil.checkNull(modelMap.get("ItemID")));
		getData.put("newElementIDs", StringUtil.checkNull(cmmMap.get("newElementIDs")));
		getData.put("delElementIDs", StringUtil.checkNull(cmmMap.get("delElementIDs")));
		getData.put("newEleStrokeColor", "#0054FF");
		getData.put("delEleStrokeColor", "#ff0000");
		getData.put("modelTypeCode", StringUtil.checkNull(modelMap.get("ModelTypeCode")));
		getData.put("changeSetID", StringUtil.checkNull(modelMap.get("ChangeSetID")));
		//getData.put("structureID", structureID);
		model.put("changeSetID", StringUtil.checkNull(modelMap.get("ChangeSetID")));
		listXML = commonService.selectList("model_SQL.getElements", getData);						
		listTextXml = commonService.selectList("model_SQL.getElementsByAttrDP", getData);
		if(listXML.size()>0) {
			for(int i=0; i<listXML.size(); i++) {
				Map listXMLMap = (Map)listXML.get(i);
				listXMLMap.put("PlainText", removeAllTag(StringUtil.checkNull(listXMLMap.get("PlainText"))));
			}
		}
		if(listTextXml.size() > 0 ){
			String dataType = "";
			String displayType = "";
			String attrTypeCode = "";
			String attrType = "";
			String category = "";
			String maxTextLen = "";
			for(int i=0; listTextXml.size()>i; i++){
				getData = new HashMap();
				Map listTextMap = (Map)listTextXml.get(i);
				
				attrType = StringUtil.checkNull(listTextMap.get("AttrType"));
				dataType = StringUtil.checkNull(listTextMap.get("DataType"));
				displayType = StringUtil.checkNull(listTextMap.get("DisplayType"));							
				attrTypeCode = StringUtil.checkNull(listTextMap.get("AttrTypeCode"));
				category = StringUtil.checkNull(listTextMap.get("Category"));
				maxTextLen = StringUtil.checkNull(listTextMap.get("MaxTextLen"));
				getData.put("itemID", listTextMap.get("ObjectID"));
				getData.put("attrTypeCode", listTextMap.get("AttrTypeCode"));
				getData.put("languageID", request.getParameter("languageID"));
				getData.put("displayType", displayType);	
				getData.put("defLanguageID", StringUtil.checkNull(cmmMap.get("sessionDefLanguageId")));
				getData.put("maxTextLen", maxTextLen);
				//getData.put("attrRevYN", attrRevYN);
										
				if(displayType.equals("Text")){ //-- Text인 경우 						
					if(attrTypeCode.equals(attrType)){									
						if(dataType.equals("MLOV")){
							attrType = getMLovVlaue(StringUtil.checkNull(cmmMap.get("sessionCurrLangType")) , StringUtil.checkNull(listTextMap.get("ObjectID")), StringUtil.checkNull(listTextMap.get("AttrTypeCode")));
						}else{
							attrType = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByDataType", getData));
						}									
					 }	
				}else if (!attrTypeCode.equals("STS") && !attrTypeCode.equals("SBICON") && !attrTypeCode.equals("TLINK") && !attrTypeCode.equals("FILELINK")){ //-- Text,SBICON 아닌  LOV의 경우 
					attrType = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByImage", getData));	
				}
				
				listTextMap.put("PlainText", attrType);
				
				if(attrTypeCode.equals("FILELINK")) { // FILELINK 시 FILE COUNT = 0 -> FILELINK Remove
					getData.put("DocumentID",StringUtil.checkNull(listTextMap.get("ObjectID")));
					getData.put("s_itemID",StringUtil.checkNull(listTextMap.get("ObjectID")));
					getData.put("itemId", StringUtil.checkNull(listTextMap.get("ObjectID")));
					getData.put("fromToItemID",StringUtil.checkNull(listTextMap.get("ObjectID")));
					List itemList = commonService.selectList("item_SQL.getCxnItemIDList", getData);
					Map getMap = new HashMap();
					/** 첨부문서 관련문서 합치기, 관련문서 itemClassCodep 할당된 fltpCode 로 filtering */
					String rltdItemId = "";
					Map itemMap = new HashMap();
					for(int k = 0; k < itemList.size(); k++){
						itemMap = (HashMap)itemList.get(k);
						getMap.put("ItemID", itemMap.get("ItemID"));
						if (k < itemList.size() - 1) {
						   rltdItemId += StringUtil.checkNull(itemMap.get("ItemID"))+ ",";
						}else{
							rltdItemId += StringUtil.checkNull(itemMap.get("ItemID"));
						}
					}
					
					getData.put("rltdItemId", rltdItemId);			
					List fileList = commonService.selectList("fileMgt_SQL.getFile_gridList", getData);	
					if(fileList.size() == 0) {
						listTextXml.remove(i); i = i-1;
					}
				}
			}
		}
		cmmMap.put("modelType", "VIEW");
		HashMap xml= new HashMap();

		String modelID  = StringUtil.checkNull(cmmMap.get("ModelID"));
		String ItemID = StringUtil.checkNull(cmmMap.get("ItemID"));
		String modelName = StringUtil.checkNull(cmmMap.get("modelName"));	
		String dx = StringUtil.checkNull(cmmMap.get("Dx"));
		String dy = StringUtil.checkNull(cmmMap.get("Dy"));
		String modelType = StringUtil.checkNull(cmmMap.get("modelType"));	

		
		cmmMap.put("Dx", modelMap.get("Dx"));
		cmmMap.put("Dy", modelMap.get("Dy"));
		cmmMap.put("modelName", modelMap.get("ModelName"));
		cmmMap.put("ModelID", modelMap.get("ModelID").toString());
		
		if(modelMap!=null && !modelMap.isEmpty()){
			xml=DiagramUtil.getMxGraphModelXml(cmmMap, "", listXML, listTextXml);
		}
		setMap.put("ModelID", modelMap.get("ModelID").toString());		
		setMap.put("ModelXML", xml.get("diagramForXml"));		
		setMap.put("lastUser", cmmMap.get("sessionUserId"));
		setMap.put("LanguageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),""));
		commonService.update("model_SQL.updateModelXML", setMap);
		/*
		 * target.put(AJAX_ALERT,
		 * MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") +
		 * ".WM00067")); target.put(AJAX_SCRIPT, "parent.fnGoModelInfo('view');");
		 * 
		 * model.addAttribute(AJAX_RESULTMAP, target); return nextUrl(AJAXPAGE);
		 */
	}
	
	@RequestMapping(value="/searchItemIdPop.do")
	public String searchItemIdPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			setMap.put("languageID", request.getParameter("languageID"));
			List labelName = commonService.selectList("menu_SQL.menuName", setMap);

			setMap = new HashMap();
			Map getMap = new HashMap();
			for (int i = 0; i < labelName.size(); i++) {
				setMap = (HashMap) labelName.get(i);
				getMap.put(setMap.get("TypeCode"), setMap.get("Name"));
			}

			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("s_itemID", request.getParameter("s_itemID"));

			model.put("menu", getMap);
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("mdl/model/searchItemIdPop");
	} 
		
	@RequestMapping(value="/selectSymbolPop.do")
	public String selectSymbolPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
				String ItemID = StringUtil.checkNull(request.getParameter("ItemID"),"");
				String ModelID = StringUtil.checkNull(request.getParameter("ModelID"));
	
				setMap = new HashMap();
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				
				Map resultMap = new HashMap();
				setMap.put("ItemID", ItemID);
				

				resultMap = commonService.select("model_SQL.getClassFromItem", setMap);

				model.put("ClassCode", resultMap.get("ClassCode"));
				model.put("ItemTypeCode", resultMap.get("ItemTypeCode"));
				
				model.put("ModelID", ModelID);
				model.put("ItemID", ItemID);
				
				setMap.put("ClassCode", resultMap.get("ClassCode"));
				setMap.put("ModelID", ModelID);
				setMap.put("ItemID", ItemID);
				setMap.put("ItemTypeCode", resultMap.get("ItemTypeCode"));
				setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));				
				
				List getSymbolList = commonService.selectList("model_SQL.getSymbolList_gridList", setMap);
				
				JSONArray gridData = new JSONArray(getSymbolList);
				model.put("gridData", gridData);				
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("mdl/model/selectSymbolPop");
	} 
	
	public void updateSymbol(HashMap cmmMap, String ItemID, String ModelID, String SymTypeCode, String defSymSize) throws Exception {
		try {
				Map getData = new HashMap();
				getData.put("ItemID", ItemID);
				getData.put("LanguageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
				getData.put("ModelID", ModelID); 
				getData.put("SymTypeCode", SymTypeCode); 
				getData.put("UserId", StringUtil.checkNull(cmmMap.get("sessionUserId"))); 
				
				Map resultMap = new HashMap();
				resultMap = commonService.select("model_SQL.getSymTypeWithSymCode", getData);
				getData.put("CategoryCode", StringUtil.checkNull(resultMap.get("ItemCategory")));
				getData.put("ItemTypeCode", StringUtil.checkNull(resultMap.get("ItemTypeCode")));
				getData.put("Style", StringUtil.checkNull(resultMap.get("ImagePath")));
				getData.put("FillColor", StringUtil.checkNull(resultMap.get("DefFillColor")));
				getData.put("StrokeColor", StringUtil.checkNull(resultMap.get("DefStrokeColor"))); 
				getData.put("GradientColor",StringUtil.checkNull(resultMap.get("DefGradientColor")));						
				getData.put("SpacingTop", StringUtil.checkNull(resultMap.get("DefSpacingTop")));	
				getData.put("LabelBackgroundColor", StringUtil.checkNull(resultMap.get("DefLabelBGColor")));						
				getData.put("Dashed", StringUtil.checkNull(resultMap.get("Dashed")));	
							
				if(defSymSize.equals("Y")){
					getData.put("DefHeight", StringUtil.checkNull(resultMap.get("DefHeight")));
					getData.put("DefWidth", StringUtil.checkNull(resultMap.get("DefWidth")));
				}
				commonService.insert("model_SQL.updateSymbolToElement", getData);
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
	
	@RequestMapping(value="/editLinkItemIdPop.do")
	public String editLinkItemIdPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {			
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			
			model.put("option", StringUtil.checkNull(cmmMap.get("option")));
			model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			setMap.put("arcCode", "AR000000");
			String arcFilter = commonService.selectString("menu_SQL.getArcFilter", setMap);
			model.put("arcFilter", arcFilter);
			model.put("clickPositionX", StringUtil.checkNull(cmmMap.get("clickPositionX")));
			model.put("clickPositionY", StringUtil.checkNull(cmmMap.get("clickPositionY")));
			model.put("itemID", request.getParameter("s_itemID"));
			model.put("modelID", request.getParameter("modelID"));
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("mdl/model/editLinkItemIdPop");
	} 
	
	@RequestMapping(value="/editLinkItemId.do")
	public String editLinkItemId(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
				Map setMap = new HashMap();
				setMap.put("languageID", request.getParameter("languageID"));
				setMap.put("s_itemID", request.getParameter("s_itemID"));
				String symTypeCode = StringUtil.checkNull(request.getParameter("symTypeCode"));
				
				setMap.put("symTypeCode", symTypeCode);
				String itemTypeCode = StringUtil.checkNull(commonService.selectString("model_SQL.getItemTypeCodeFromSymType", setMap));				
				
				model.put("option", StringUtil.checkNull(cmmMap.get("option")));
				model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
				setMap.put("arcCode", "AR000000");
				String arcFilter = commonService.selectString("menu_SQL.getArcFilter", setMap);
				model.put("arcFilter", arcFilter);
				
			
				target.put(AJAX_SCRIPT, "itemTypeCodeTreePop('"+itemTypeCode+"','"+arcFilter+"');");
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/searchItemIdTreePop.do")
	public String searchItemIdTreePop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			String unfold = StringUtil.checkNull(cmmMap.get("unfold"));
			model.put("unfold", unfold);
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			model.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("ItemTypeCode")));
			model.put("option", StringUtil.checkNull(cmmMap.get("option")));
			model.put("schText", StringUtil.checkNull(cmmMap.get("schText")));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("mdl/model/searchItemIdTreePop");
	} 
	
	/**
	 * 선택된 item의 경로를 취득
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/getPathWithItemIdName.do")
	public String getPathWithItemIdName(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try{
			Map setMap = new HashMap();
			Map resultMap = new HashMap();
			
			setMap.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			Map itemMap = new HashMap();
			
			itemMap = commonService.select("model_SQL.getItemPathName", setMap);
			String itemPath = itemMap.get("Path").toString();
			String itemText = itemMap.get("ItemText").toString();
			itemText = itemText.replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ");
			resultMap.put(AJAX_SCRIPT, "fnReturn('"+itemPath+"','"+itemText+"')");
			model.addAttribute(AJAX_RESULTMAP,resultMap);
		}catch (Exception e){
			System.out.println(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	
	public DirectoryStream<Path> getDirectory(Path path, String text) {
		DirectoryStream<Path> dir;
		try {
			dir = Files.newDirectoryStream(path, text);
			//dir.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			return null;
		}
		return dir;
	}
	
	
	@RequestMapping(value="/saveARISModel.do")
	public String saveARISModel(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {

		Map target = new HashMap();
		FileInputStream in=null;
		try {
			List blnkList = new ArrayList();
			File xmlfile;String fileNm="";
			//Directory내 file 읽기
			Path path = Paths.get(GlobalVal.ARIS_XML_DIR);
			DirectoryStream<Path> dir = getDirectory(path, "*.{xml, XML}");
			
			for (Path file : dir) { 
				//System.out.println(file.getFileName());
				fileNm=GlobalVal.ARIS_XML_DIR+file.getFileName().toString();
				xmlfile = new File(fileNm);
				if (!xmlfile.exists()) {throw new FileNotFoundException(fileNm);}
				if (!xmlfile.isFile()) {throw new FileNotFoundException(fileNm);}
				in = new FileInputStream(xmlfile);
				BufferedReader br = new BufferedReader(new InputStreamReader(in, "UTF-8"));
	 	        String word="";String mean="";
	            while((word = br.readLine())!=null){mean += StringUtil.replace(StringUtil.replace(word, "\n", ""), "\t\t", "");}     
		        br.close();
	            try{in.close();  }catch(Exception e){} finally {br.close();}
		      
		        //System.out.println(fileNm+"::"+mean);
				cmmMap.put("XML", mean);
				cmmMap.put("GUBUN", "saveARIS");
				cmmMap.put("languageID", "sessionCurrLangType");
				try{
					diagramService.save(blnkList, cmmMap,commonService);	
				} catch (Exception e) {
					System.out.println("ERR fileNm : "+fileNm+":::er :"+e);
					dir.close();
				    target.put(AJAX_ALERT, file.getFileName().toString()+" "+MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068"));
					target.put(AJAX_SCRIPT, "doCallBack()");
					model.addAttribute(AJAX_RESULTMAP, target);
					return nextUrl(AJAXPAGE);
				}finally{
			            try{if(in!=null){in.close();} }catch(Exception e){}
			 	}				
			}
			
			if(!fileNm.equals("") && !fileNm.isEmpty()){
				Map setMap = new HashMap();
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				commonService.update("model_SQL.adjustARISModel", setMap);
			}
			     
			dir.close();
		    target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
			target.put(AJAX_SCRIPT, "doCallBack()");
		} catch (Exception e) {
			target.put(AJAX_SCRIPT, "doCallBack()");
			//target.put(AJAX_ALERT, "DB Commit중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00092"));
        }finally{
            try{if(in!=null){in.close();} }catch(Exception e){}
 		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
		
			
		//XMLParserARIS xmlparser = new XMLParserARIS("DOC", fileName);
		//List<ARISObjDef> listData = xmlparser.DOCParse("ObjDef");
		//XMLParserARIS xmlparser = new XMLParserARIS("SAX", fileName);
		//List<ARISObjDef> listData = xmlparser.SAXParse();
		//for(ARISObjDef data : listData){
		//	System.out.println("GUID="+data.getM_GUID());
		//}

	}
	
	@RequestMapping(value="/goViewSymbolPop.do")
	public String goViewSymbolPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			setMap.put("languageID", request.getParameter("languageID"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */			
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("mdl/model/viewSymbolPop");
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
	
	@RequestMapping(value="/viewVersionModel.do")
	public String viewVersionModel(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url="/mdl/model/DiagramViewer_v3.4";
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");		
			String changeSetID  =  StringUtil.checkNull(request.getParameter("changeSetID"),"");
			Map setData = new HashMap();
			setData.put("changeSetID", changeSetID);
			String modelID = StringUtil.checkNull(commonService.selectString("model_SQL.getModelIDCSID",setData));
			setData.put("orgModelID", modelID);
			String curChangeSetID = StringUtil.checkNull(commonService.selectString("model_SQL.getCurChangeSetID",setData));
			  	
			List listXML = new ArrayList();
			List listTextXml = new ArrayList();
			Map getData = new HashMap();
			
			String modelXML = "";
			getData.put("ModelID", modelID);
			cmmMap.put("ModelID", modelID);			
			getData.put("languageID", request.getParameter("languageID"));
			getData.put("ItemID", s_itemID);
									
			setData = new HashMap();
			setData.put("itemId", s_itemID);

			Map result  = commonService.select("fileMgt_SQL.selectItemAuthorID",setData);
			
			String itemStatus = StringUtil.checkNull(result.get("Status"));
			String tobeViewOption = StringUtil.checkNull(request.getParameter("varFilter"));
			model.put("tobeViewOption", tobeViewOption);
			String MTCategory ="";
			if(modelID == null || modelID.equals("")){
				MTCategory = "BAS" ;
				if(tobeViewOption.equals("MOD1") && (itemStatus.equals("MOD1")|| itemStatus.equals("MOD2"))) {
					MTCategory = "TOBE" ;
				}else if(tobeViewOption.equals("MOD2")&& itemStatus.equals("MOD2")) {
					MTCategory = "TOBE" ;					
				}else if(tobeViewOption.equals("TOBE")) {
					MTCategory = "TOBE" ;	
				}
				getData.put("MTCategory", MTCategory);
			}	
			
			String attrRevYN = "N";
			if(curChangeSetID.equals("")){
				attrRevYN = "Y";
			}
		
			//System.out.println(" MTCategory:"+MTCategory+":itemStaus :"+itemStatus+": attrRevYN :"+attrRevYN);
			model.put("attrRevYN", attrRevYN);
			
			Map modelMap = new HashMap();
			modelMap = commonService.select("model_SQL.getModelViewer", getData);	
			MTCategory = StringUtil.checkNull(modelMap.get("MTCategory"),"");
			getData.put("DefFontFamily", cmmMap.get("sessionDefFont"));
			getData.put("DefFontSize", cmmMap.get("sessionDefFontSize"));
			getData.put("DefFontStyle", cmmMap.get("sessionDefFontSteyl"));
			getData.put("DefFontColor", cmmMap.get("sessionDefFontColor"));
			getData.put("DefStrokeColor", "#ff0000");			
			
			String modelExsist= null;
			String isModel = null;
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
				if(isModel.equals("0")){
					modelXML = StringUtil.checkNull(modelMap.get("ModelXML"));
				}else{
					if(attrRevYN.equals("Y")){
						listXML = commonService.selectList("model_SQL.getElementsAttrRev", getData);
						getData.put("RevYN", "Y");
						listTextXml = commonService.selectList("model_SQL.getElementsByAttrDP", getData);
					}else{
						listXML = commonService.selectList("model_SQL.getElements", getData);
						listTextXml = commonService.selectList("model_SQL.getElementsByAttrDP", getData);
					}
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
								 if (!attrTypeCode.equals("ID") && !attrTypeCode.equals("STS") && !attrTypeCode.equals("MDLNM")&& !attrTypeCode.equals("MDLCAT")&& !attrTypeCode.equals("MDLTP") && !attrTypeCode.equals("SortNum")){ //ITEM ATTR 인 경우
									if(dataType.equals("MLOV")){
										plainText = getMLovVlaue(StringUtil.checkNull(cmmMap.get("sessionCurrLangType")) , StringUtil.checkNull(listTextMap.get("ObjectID")), StringUtil.checkNull(listTextMap.get("AttrTypeCode")));
									}else{
										plainText = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByDataType", getData));
									}									
								 }	
							 }else if (!attrTypeCode.equals("STS") && !attrTypeCode.equals("SBICON")){ //-- Text 아닌  LOV의 경우 
									plainText = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByImage", getData));	
							 }
							
							listTextMap.put("PlainText", plainText);
						}
					
					}
				}
				//System.out.println("listTextXml :"+listTextXml);
				modelExsist=(listXML==null?"N":(listXML.size()>0?"Y":"N"));
				model.put("ModelID", modelMap.get("ModelID").toString());cmmMap.put("ModelID", modelMap.get("ModelID").toString());
				model.put("modelName", modelMap.get("ModelName"));cmmMap.put("modelName", modelMap.get("ModelName"));
				model.put("modelTypeName", modelMap.get("ModelTypeName"));
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
			if(result.get("AuthorID") != null){itemAthId =  StringUtil.checkNull(result.get("AuthorID").toString(),"");}
			if(result.get("Blocked") != null){itemBlocked =  StringUtil.checkNull(result.get("Blocked").toString(),"");}
					
			//model.put("modelXML", modelXML);
			//model.put("listXML", listXML);	
			//model.put("listTextXml", listTextXml);
			model.put("ItemID", s_itemID);	cmmMap.put("ItemID", s_itemID);	
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
			//System.out.println("xml :"+StringUtil.checkNull(xml.get("diagramForXml")));
			// QuickCheckOut 설정
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
			
			// Toolbar에 itemStatus 설정 
			if( itemStatus.equals("NEW2")|| itemStatus.equals("DEL2")|| (itemStatus.equals("MOD2") && MTCategory.equals("TOBE"))){			
				model.put("itemStatus", itemStatus);
				//System.out.println("itemStatus :"+itemStatus);
			}	
			
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
			
		} catch (Exception e) {
			
			System.out.println(e.toString());
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/diagramMasterPop.do")
	public String diagramMasterPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			String diagramID = StringUtil.checkNull(request.getParameter("diagramID"));
			
			setMap.put("diagramID", diagramID);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			String htmlTitle = StringUtil.checkNull(commonService.selectString("model_SQL.getDiagramNM", setMap),"");			
		
			model.put("diagramID", diagramID);
			model.put("scrnType", StringUtil.checkNull(request.getParameter("scrnType")));
			model.put("autoSave", StringUtil.checkNull(request.getParameter("autoSave")));
			model.put("htmlTitle", htmlTitle);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("mdl/diagram/diagramMasterPop");
	}
	
	@RequestMapping(value="/editDiagram.do")
	public String editDiagram(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url="/mdl/diagram/editDiagram";
		try {
			String diagramID = StringUtil.checkNull(request.getParameter("diagramID"),"");
			List listXML = new ArrayList();
			List listTextXml = new ArrayList();
			
			Map setData = new HashMap();
			setData.put("diagramID", diagramID);				
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			Map diagramInfo = commonService.select("model_SQL.getDiagramList_gridList", setData);
			String modelTypeCode = StringUtil.checkNull(diagramInfo.get("ModelTypeCode"));
			setData.put("modelTypeCode", modelTypeCode);
			String isModel = commonService.selectString("model_SQL.getIsModel", setData);
			model.put("isModel", isModel);
			
			
			String dfFontFamily = StringUtil.checkNull(cmmMap.get("sessionDefFont"),"");
			String SymTypeCode = "'SB00004','SB00005','SB00007'";

			String modelXML = StringUtil.checkNull(diagramInfo.get("ModelXML"));
			model.put("modelName", StringUtil.checkNull(diagramInfo.get("DiagramNM")));	
			model.put("viewScale", "0.8");		
			
			model.put("ModelID", diagramID); 
			model.put("diagramID", diagramID); 
			model.put("ItemID", StringUtil.checkNull(diagramInfo.get("ItemID")));
			model.put("option", StringUtil.checkNull(request.getParameter("option")));
			model.put("diagramInfo", diagramInfo);
			
			HashMap xml = new HashMap();
			String diagramForXml = "";
			if(modelXML.equals("")) {
				diagramForXml = "<mxGraphModel style=\"default-style2\" dx=\"0\" dy=\"0\" grid=\"1\" guides=\"1\" tooltips=\"1\" connect=\"1\" fold=\"1\" page=\"1\" pageScale=\"1\" pageWidth=\"2339\" pageHeight=\"3300\">";
				diagramForXml += "<root>";
				diagramForXml += "<mxCell id=\"" + diagramID + "\"/>";
				diagramForXml += "<mxCell id=\"" + (Integer.parseInt(diagramID)+1) + "\" parent=\"" + diagramID + "\"/>";
				diagramForXml += "</root>";
				diagramForXml += "</mxGraphModel>";	
				xml.put("diagramForXml", diagramForXml);
				xml.put("updateForXml", "");
			}else {
				xml=DiagramUtil.getMxGraphModelXml(cmmMap, modelXML, listXML, listTextXml);
			}
			model.put("diagramForXml",StringUtil.checkNull(xml.get("diagramForXml")));
			model.put("updateForXml",StringUtil.checkNull(xml.get("updateForXml")));
			
			
			// System.out.println("diagramForXml : "+StringUtil.checkNull(xml.get("diagramForXml")));
			// getSymType
			setData = new HashMap();
			setData.put("languageID", cmmMap.get("sessionCurrLangType")); 
			setData.put("modelTypeCode", StringUtil.checkNull(diagramInfo.get("ModelTypeCode")));
			List symTypeList = commonService.selectList("model_SQL.getSymbolTypeList",setData);
			
			String symTypeCode = "";
			String imagePath = "";
			String defFontColor = "";
			String fillColor = "";
			String strokeColor = "";
			String shadow = "";
			String gradientColor = "";
			String generalPalette = "";
			
			// symbol Palette 설정
			if(symTypeList.size()>0){
				for(int i=0; i<symTypeList.size(); i++){
					Map symbolMap = (Map)symTypeList.get(i);
					symTypeCode = StringUtil.checkNull(symbolMap.get("SymTypeCode"));
					imagePath = StringUtil.checkNull(symbolMap.get("ImagePath"));
					defFontColor = StringUtil.checkNull(symbolMap.get("DefFontColor"));
					fillColor = StringUtil.checkNull(symbolMap.get("DefFillColor"));
					strokeColor = StringUtil.checkNull(symbolMap.get("DefStrokeColor"));
					shadow = StringUtil.checkNull(symbolMap.get("DefShadow"));
					gradientColor = StringUtil.checkNull(symbolMap.get("DefGradientColor"));
					generalPalette = imagePath+";fillColor="+ fillColor
							+ ";strokeColor="+strokeColor
							+ ";fontFamily="+StringUtil.checkNull(symbolMap.get("DefFontFamily"))
							+ ";fontStyle="+StringUtil.checkNull(symbolMap.get("DefFontStyle"))
							+ ";fontSize="+StringUtil.checkNull(symbolMap.get("DefFontSize"))
							+ ";fontColor="+defFontColor
							+ ";shadow="+shadow	
							+ ";gradientColor="+gradientColor
							+ ";startSize=38;symTypeCode="+symTypeCode+";";							
					symbolMap.put("generalPalette", generalPalette);
				}
			}
			model.put("symTypeList", symTypeList);
			model.put("autoSave", StringUtil.checkNull(request.getParameter("autoSave"),""));
			
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl(url);
	}
	
	@RequestMapping(value="/viewDiagram.do")
	public String viewDiagram(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		//String url="/mdl/diagram/viewDiagram";
		String url="/mdl/model/viewModel";
		try {
			String diagramID = StringUtil.checkNull(request.getParameter("diagramID"),"");
			List listXML = new ArrayList();
			List listTextXml = new ArrayList();
			
			Map setData = new HashMap();
			setData.put("diagramID", diagramID);				
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			Map diagramInfo = commonService.select("model_SQL.getDiagramList_gridList", setData);
			String modelTypeCode = StringUtil.checkNull(diagramInfo.get("ModelTypeCode"));
			setData.put("modelTypeCode", modelTypeCode);
			String isModel = commonService.selectString("model_SQL.getIsModel", setData);
			model.put("isModel", isModel);
			
			String dfFontFamily = StringUtil.checkNull(cmmMap.get("sessionDefFont"),"");
			String modelXML = StringUtil.checkNull(diagramInfo.get("ModelXML"));
			
			model.put("modelName", StringUtil.checkNull(diagramInfo.get("DiagramNM")));	
			model.put("viewScale", "0.8");		
			
			model.put("ModelID", diagramID); 
			model.put("diagramID", diagramID); 
			model.put("ItemID", StringUtil.checkNull(diagramInfo.get("ItemID")));
			model.put("option", StringUtil.checkNull(request.getParameter("option")));
			model.put("diagramInfo", diagramInfo);
			
			HashMap xml = new HashMap();
			String diagramForXml = "";
			if(modelXML.equals("")) {
				diagramForXml = "<mxGraphModel style=\"default-style2\" dx=\"0\" dy=\"0\" grid=\"1\" guides=\"1\" tooltips=\"1\" connect=\"1\" fold=\"1\" page=\"1\" pageScale=\"1\" pageWidth=\"2339\" pageHeight=\"3300\">";
				diagramForXml += "<root>";
				diagramForXml += "<mxCell id=\"" + diagramID + "\"/>";
				diagramForXml += "<mxCell id=\"" + (Integer.parseInt(diagramID)+1) + "\" parent=\"" + diagramID + "\"/>";
				diagramForXml += "</root>";
				diagramForXml += "</mxGraphModel>";	
				xml.put("diagramForXml", diagramForXml);
				xml.put("updateForXml", "");
			}else {
				xml=DiagramUtil.getMxGraphModelXml(cmmMap, modelXML, listXML, listTextXml);
			}
			
			model.put("diagramForXml",StringUtil.checkNull(xml.get("diagramForXml")));
			model.put("updateForXml",StringUtil.checkNull(xml.get("updateForXml")));
			model.put("displayRightBar", "none");
			
			model.put("modelExsist", "Y");
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}			
		return nextUrl(url);
	}
	
	@RequestMapping(value="/saveDiagramXML.do")
	public String saveDiagramXML(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		try {
				Map setData = new HashMap();			
				String diagramID = URLDecoder.decode(StringUtil.checkNull(request.getParameter("diagramID")), "UTF-8");				
				String diagram = URLDecoder.decode(StringUtil.checkNull(request.getParameter("diagram")), "UTF-8");			
				diagram = replaceTag(diagram);
				
				setData.put("diagramID", diagramID);
				setData.put("modelXML", diagram);		
				setData.put("userID", cmmMap.get("sessionUserId"));
				
				//System.out.println("diagram :"+diagram);
				//System.out.println("imgXml :"+URLDecoder.decode(StringUtil.checkNull(request.getParameter("plain")), "UTF-8"));
			
				commonService.update("model_SQL.updateDiagramXML", setData);
	
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				target.put(AJAX_SCRIPT, "");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXNOPAGE);
	}

	@RequestMapping(value = "/getDiagramXml.do")
	public void getDiagramXml(HttpServletRequest request, HttpServletResponse res, HashMap cmmMap) throws Exception{
		try {
			res.setHeader("Cache-Control", "no-cache");
			res.setContentType("text/plain");
			res.setCharacterEncoding("UTF-8");
			String modelID = StringUtil.checkNull(request.getParameter("modelID"));
			String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
			String dimValueListParam[] = StringUtil.checkNull(request.getParameter("dimValueList")).split(",\\s*");
			String symTypeCodeListParam[] = StringUtil.checkNull(request.getParameter("symTypeCodeList")).split(",\\s*"); 
			String itemTypeCodeParam[] = StringUtil.checkNull(request.getParameter("itemTypeCodeList")).split(",\\s*"); 
			String opacityListParam[] = StringUtil.checkNull(request.getParameter("opacityList")).split(",\\s*"); 
			String blurredListParam[] = StringUtil.checkNull(request.getParameter("blurredList")).split(",\\s*"); 
			// opacity...
			
			String attrRevYN = StringUtil.checkNull(request.getParameter("attrRevYN"));
			String dimValueIDs = "";
			String blurredDimValueIDs = "";
			String symTypeCodes = "";
			String itemTypeCodeList = "";
			
			if(!StringUtil.checkNull(request.getParameter("itemTypeCodeList")).equals("")) {
				StringBuilder stringBuilder = new StringBuilder();
			    for (int i = 0; i < itemTypeCodeParam.length; i++) {
			        stringBuilder.append("'").append(itemTypeCodeParam[i]).append("'");
			        if (i < itemTypeCodeParam.length - 1) {
			            stringBuilder.append(",");
			        }
			    }
			    itemTypeCodeList = stringBuilder.toString();
			}
			
			String diagramXml = "";
			
			Map setData = new HashMap();
			Map modelMap = new HashMap();
			setData.put("ModelID", modelID);
			setData.put("ItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			setData.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			modelMap = commonService.select("model_SQL.getModelViewer", setData);	
			
			String isModel = StringUtil.checkNull(modelMap.get("IsModel"));
			setData.put("ModelID", modelID);
			setData.put("ItemID", StringUtil.checkNull(modelMap.get("ItemID")));
			setData.put("newElementIDs", StringUtil.checkNull(cmmMap.get("newElementIDs")));
			setData.put("delElementIDs", StringUtil.checkNull(cmmMap.get("delElementIDs")));
			setData.put("newEleStrokeColor", "#0054FF");
			setData.put("delEleStrokeColor", "#ff0000");
			setData.put("modelTypeCode", StringUtil.checkNull(modelMap.get("ModelTypeCode")));
			setData.put("changeSetID", StringUtil.checkNull(modelMap.get("ChangeSetID")));
			
			setData.put("DefFontFamily", cmmMap.get("sessionDefFont"));
			setData.put("DefFontSize", cmmMap.get("sessionDefFontSize"));
			setData.put("DefFontStyle", cmmMap.get("sessionDefFontSteyl"));
			setData.put("DefFontColor", cmmMap.get("sessionDefFontColor"));
				
			String scrnMode  =  StringUtil.checkNull(request.getParameter("scrnMode"),"V");
			String tLink  =  StringUtil.checkNull(request.getParameter("tLink"),"");
			String pop  =  StringUtil.checkNull(request.getParameter("pop"),"");
			setData.put("scrnMode",scrnMode);
			
			setData.put("dimFilter", "Y");
			setData.put("dimTypeID", dimTypeID);
			setData.put("blurredDimValueIDs", blurredDimValueIDs);
			setData.put("itemTypeCodeList", itemTypeCodeList);
			
			String modelXML = "";
			List listXML = new ArrayList();
			List listTextXml = new ArrayList();
			
			List<String> blurredList = new ArrayList();
			if( !StringUtil.checkNull(request.getParameter("blurredList")).equals("") && StringUtil.checkNull(request.getParameter("blurredList")) != null) {
				blurredList = Arrays.asList(blurredListParam);
			}	
			
			String blurredListDisplay = "";
			if(!StringUtil.checkNull(request.getParameter("blurredList")).equals("")) {
				StringBuilder stringBuilder = new StringBuilder();
			    for (int i = 0; i < blurredListParam.length; i++) {
			        stringBuilder.append("'").append(blurredListParam[i]).append("'");
			        if (i < blurredListParam.length - 1) {
			            stringBuilder.append(",");
			        }
			    }
			    blurredListDisplay = stringBuilder.toString();
			}
			setData.put("blurredList", blurredListDisplay);
			
			String dimValueList = "";
			if(!StringUtil.checkNull(request.getParameter("dimValueList")).equals("")) {
				StringBuilder stringBuilder = new StringBuilder();
			    for (int i = 0; i < dimValueListParam.length; i++) {
			        stringBuilder.append("'").append(dimValueListParam[i]).append("'");
			        if (i < dimValueListParam.length - 1) {
			            stringBuilder.append(",");
			        }
			    }
			    dimValueList = stringBuilder.toString();
			}
			setData.put("dimValueList", dimValueList);
			
			String symTypeCodeList = "";
			if(!StringUtil.checkNull(request.getParameter("symTypeCodeList")).equals("")) {
				StringBuilder stringBuilder = new StringBuilder();
			    for (int i = 0; i < symTypeCodeListParam.length; i++) {
			        stringBuilder.append("'").append(symTypeCodeListParam[i]).append("'");
			        if (i < symTypeCodeListParam.length - 1) {
			            stringBuilder.append(",");
			        }
			    }
			    symTypeCodeList = stringBuilder.toString();
			}
			setData.put("symTypeCodeList", symTypeCodeList);
			
			if(isModel.equals("0")){
				modelXML = StringUtil.checkNull(modelMap.get("ModelXML"));
			}else{
				if(!pop.equals("pop") && tLink.equals("Y")){ setData.put("TLink", "TLINK"); }
				if(attrRevYN.equals("Y")){
					listXML = commonService.selectList("model_SQL.getElementsAttrRev", setData);
					setData.put("RevYN", "Y");
					listTextXml = commonService.selectList("model_SQL.getElementsByAttrDP", setData);
				}else{
					listXML = commonService.selectList("model_SQL.getElements", setData);
					listTextXml = commonService.selectList("model_SQL.getElementsByAttrDP", setData);
				}
					
				if(listXML.size()>0) {
					ArrayList<String> selectedElements = new ArrayList<>();
					ArrayList<String> selectedElmParent = new ArrayList<>();
					ArrayList<String> blurredElements = new ArrayList<>();
					ArrayList<String> selectedDimElements = new ArrayList<>();
					ArrayList<String> selectedSymElements = new ArrayList<>();
					ArrayList<String> selectedCxnElements = new ArrayList<>();
					ArrayList<String> selectedCxnOpacity = new ArrayList<>();
					
					for(int i=0; i<listXML.size(); i++) {
						Map elmInfo = (Map)listXML.get(i);
						if(itemTypeCodeParam.length > 0) {
							for(int z=0; z<itemTypeCodeParam.length; z++) {
								if(StringUtil.checkNull( elmInfo.get("ItemTypeCode")).equals(itemTypeCodeParam[z]) && StringUtil.checkNull(elmInfo.get("SelectedDim")).equals("N") ) {
									elmInfo.put("Opacity", opacityListParam[z]);
								}
							}
						}
						
						if(!StringUtil.checkNull(request.getParameter("itemTypeCodeList")).equals("") && !StringUtil.checkNull(request.getParameter("dimValueList")).equals("")) {
							if(StringUtil.checkNull( elmInfo.get("SelectedItemTypeCode")).equals("Y") 
									&& StringUtil.checkNull( elmInfo.get("SelectedDim")).equals("Y")
									&& !StringUtil.checkNull( elmInfo.get("Opacity")).equals("0.1") ) {
								
								selectedElements.add(StringUtil.checkNull( elmInfo.get("ElementID")));
								selectedElmParent.add(StringUtil.checkNull( elmInfo.get("Parent")));
							} 
							
						} else if(!StringUtil.checkNull(request.getParameter("itemTypeCodeList")).equals("")) {
							if(StringUtil.checkNull( elmInfo.get("SelectedItemTypeCode")).equals("Y") && !StringUtil.checkNull( elmInfo.get("Opacity")).equals("0.1") ) {
								selectedElements.add(StringUtil.checkNull( elmInfo.get("ElementID")));
								selectedElmParent.add(StringUtil.checkNull( elmInfo.get("Parent")));
							} 
							
						} else if(!StringUtil.checkNull(request.getParameter("dimValueList")).equals("")) {
							if(StringUtil.checkNull( elmInfo.get("SelectedDim")).equals("Y")) {
								selectedElements.add(StringUtil.checkNull( elmInfo.get("ElementID")));
								selectedElmParent.add(StringUtil.checkNull( elmInfo.get("Parent")));
								selectedDimElements.add(StringUtil.checkNull( elmInfo.get("ElementID")));
							} 
						} 
						
						/*	
						if(StringUtil.checkNull( elmInfo.get("SelectedItemTypeCode")).equals("Y") && !StringUtil.checkNull( elmInfo.get("Opacity")).equals("0.1") ) {
							selectedElements.add(StringUtil.checkNull( elmInfo.get("ElementID")));
							selectedElmParent.add(StringUtil.checkNull( elmInfo.get("Parent")));
						} 
						
						*/
						
						if(StringUtil.checkNull( elmInfo.get("SelectedSym")).equals("Y")) {
							selectedElements.add(StringUtil.checkNull( elmInfo.get("ElementID")));
							selectedElmParent.add(StringUtil.checkNull( elmInfo.get("Parent")));
							selectedSymElements.add(StringUtil.checkNull( elmInfo.get("ElementID")));
						} 
						
						
						if(blurredList.contains(StringUtil.checkNull(elmInfo.get("ItemTypeCode"))) 
								&& StringUtil.checkNull(elmInfo.get("SelectedDim")).equals("N") 
								&& StringUtil.checkNull(elmInfo.get("SelectedSym")).equals("N") 
								) {
							blurredElements.add(StringUtil.checkNull( elmInfo.get("ElementID")));
						}
						
					}
					
					for(int i2=0; i2<listXML.size(); i2++) {
						Map elmInfo = (Map)listXML.get(i2);
						
						if(selectedElements.contains(StringUtil.checkNull( elmInfo.get("FromID"))) 
								|| selectedElements.contains(StringUtil.checkNull( elmInfo.get("ToID"))) 
								|| selectedElements.contains(StringUtil.checkNull( elmInfo.get("ElementID"))) 
								|| selectedElmParent.contains(StringUtil.checkNull( elmInfo.get("ElementID")))
							    || StringUtil.checkNull( elmInfo.get("SymTypeCode")).equals("SB00001") ){
							
							for(int i3=0; i3 < itemTypeCodeParam.length; i3++) {
								if(StringUtil.checkNull( elmInfo.get("ItemTypeCode")).equals(StringUtil.checkNull(itemTypeCodeParam[i3]))
									||	StringUtil.checkNull( elmInfo.get("FromItemTypeCode")).equals(StringUtil.checkNull(itemTypeCodeParam[i3]))
									||	StringUtil.checkNull( elmInfo.get("ToItemTypeCode")).equals(StringUtil.checkNull(itemTypeCodeParam[i3]))										
										) {
									elmInfo.put("Opacity", opacityListParam[i3]);
								}
								if(StringUtil.checkNull( elmInfo.get("FromItemTypeCode")).equals(StringUtil.checkNull(itemTypeCodeParam[i3]))) {
									elmInfo.put("Opacity", opacityListParam[i3]);
								}	
							}
						} else {
							elmInfo.put("Opacity", "0.1");
							elmInfo.put("fontColor", "#ffffff");
							elmInfo.put("strokeColor", "#ffffff");
							elmInfo.put("fontSize", "2");
						}
						
						if(blurredElements.contains(StringUtil.checkNull( elmInfo.get("FromID"))) 
								|| blurredElements.contains(StringUtil.checkNull( elmInfo.get("ToID"))) 
								|| blurredElements.contains(StringUtil.checkNull( elmInfo.get("ElementID"))) ){
							elmInfo.put("Opacity", "0.1");
							elmInfo.put("fontColor", "#ffffff");
							elmInfo.put("strokeColor", "#ffffff");
							elmInfo.put("fontSize", "2");
						}
						
						if(selectedDimElements.contains(StringUtil.checkNull( elmInfo.get("FromID"))) 
								|| selectedDimElements.contains(StringUtil.checkNull( elmInfo.get("ToID"))) ){
							if(StringUtil.checkNull( elmInfo.get("Opacity")).equals("0.1")) {
								elmInfo.put("Opacity",StringUtil.checkNull( elmInfo.get("DefOpacity")));	
								elmInfo.put("fontColor",StringUtil.checkNull( elmInfo.get("DefFontColor")));
								elmInfo.put("strokeColor",StringUtil.checkNull( elmInfo.get("DefStrokeColor")));
								elmInfo.put("fontSize",StringUtil.checkNull( elmInfo.get("DefFontSize")));
							}
						}
						
						if(selectedSymElements.contains(StringUtil.checkNull( elmInfo.get("FromID"))) 
								|| selectedSymElements.contains(StringUtil.checkNull( elmInfo.get("ToID"))) ){
							if(StringUtil.checkNull( elmInfo.get("Opacity")).equals("0.1")) {
								elmInfo.put("Opacity",StringUtil.checkNull( elmInfo.get("DefOpacity")));	
								elmInfo.put("fontColor",StringUtil.checkNull( elmInfo.get("DefFontColor")));
								elmInfo.put("strokeColor",StringUtil.checkNull( elmInfo.get("DefStrokeColor")));
								elmInfo.put("fontSize",StringUtil.checkNull( elmInfo.get("DefFontSize")));
							}
						}
						
						if(!StringUtil.checkNull(elmInfo.get("Opacity")).equals("0.1") && StringUtil.checkNull(elmInfo.get("CategoryCode")).equals("MCN")){
							selectedCxnElements.add(StringUtil.checkNull(elmInfo.get("FromID")));
							selectedCxnElements.add(StringUtil.checkNull(elmInfo.get("ToID")));
							selectedCxnOpacity.add(StringUtil.checkNull(elmInfo.get("FromID")) +":"+ StringUtil.checkNull(elmInfo.get("Opacity")));
							selectedCxnOpacity.add(StringUtil.checkNull(elmInfo.get("ToID")) +":"+ StringUtil.checkNull(elmInfo.get("Opacity")));
						}
					}
					
					for(int i3=0; i3<listXML.size(); i3++) { // 출력된 Connection 의 FromID,ToID 전부 출력되도록
						Map elmInfo3 = (Map)listXML.get(i3);
						
						if(selectedCxnElements.contains(StringUtil.checkNull(elmInfo3.get("ElementID"))) && StringUtil.checkNull(elmInfo3.get("Opacity")).equals("0.1")) {
							elmInfo3.put("Opacity",StringUtil.checkNull( elmInfo3.get("DefOpacity")));	
							elmInfo3.put("fontColor",StringUtil.checkNull( elmInfo3.get("DefFontColor")));
							elmInfo3.put("strokeColor",StringUtil.checkNull( elmInfo3.get("DefStrokeColor")));
							elmInfo3.put("fontSize",StringUtil.checkNull( elmInfo3.get("DefFontSize")));
							
							 for (String attribute : selectedCxnOpacity) {
					            String[] parts = attribute.split(":");
					            if (parts.length == 2 && parts[0].equals("opacity")) {
					            	String elementIDValue = parts[0];
					                String opacityValue = parts[1];
					                if(elementIDValue.equals(StringUtil.checkNull(elmInfo3.get("ElementID")))) {
					                	elmInfo3.put("Opacity",opacityValue);	
					                	break;
					                }
					            }
					        }
						}
						
						elmInfo3.put("textOpacity",StringUtil.checkNull( elmInfo3.get("Opacity"))); // 심볼 투명도 text 투명도로 동기화 
					}
				}
			}
			
			if(listTextXml.size() > 0 ){
				String dataType = "";
				String displayType = "";
				String attrTypeCode = "";
				String plainText = "";
				String category = "";
				String attrType = "";
				
				for(int i=0; listTextXml.size()>i; i++){
					setData = new HashMap();
					Map listTextMap = (Map)listTextXml.get(i);
					
					plainText = StringUtil.checkNull(listTextMap.get("PlainText"));
					dataType = StringUtil.checkNull(listTextMap.get("DataType"));
					displayType = StringUtil.checkNull(listTextMap.get("DisplayType"));							
					attrTypeCode = StringUtil.checkNull(listTextMap.get("AttrTypeCode"));
					attrType = StringUtil.checkNull(listTextMap.get("AttrType"));
					category = StringUtil.checkNull(listTextMap.get("Category"));
					setData.put("itemID", listTextMap.get("ObjectID"));
					setData.put("attrTypeCode", listTextMap.get("AttrTypeCode"));
					setData.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
					setData.put("displayType", displayType);	
					setData.put("defLanguageID", StringUtil.checkNull(cmmMap.get("sessionDefLanguageId")));
					
					if(displayType.equals("Text")){ //-- Text인 경우 						
						if(attrTypeCode.equals(attrType)){									
							if(dataType.equals("MLOV")){
								attrType = getMLovVlaue(StringUtil.checkNull(cmmMap.get("sessionCurrLangType")) , StringUtil.checkNull(listTextMap.get("ObjectID")), StringUtil.checkNull(listTextMap.get("AttrTypeCode")));
							}else{
								attrType = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByDataType", setData));
							}									
						 }	
					}else if (!attrTypeCode.equals("STS") && !attrTypeCode.equals("SBICON") && !attrTypeCode.equals("TLINK") && !attrTypeCode.equals("FILELINK")){ //-- Text,SBICON 아닌  LOV의 경우 
						attrType = StringUtil.checkNull(commonService.selectString("model_SQL.getPlainTextByImage", setData));	
					}
					
					listTextMap.put("PlainText", attrType);
					
					if(itemTypeCodeParam.length > 0) {
						for(int z2=0; z2<itemTypeCodeParam.length; z2++) {
							if(StringUtil.checkNull( listTextMap.get("ItemTypeCode")).equals(itemTypeCodeParam[z2]) && StringUtil.checkNull(listTextMap.get("SelectedDim")).equals("N") ) {
								listTextMap.put("Opacity", opacityListParam[z2]);
								listTextMap.put("textOpacity", opacityListParam[z2]);
							}
						}
					}
				}
			}
			
			cmmMap.put("Dx", modelMap.get("Dx"));
			cmmMap.put("Dy", modelMap.get("Dy"));
			cmmMap.put("ModelID", StringUtil.checkNull(modelMap.get("ModelID")));
			cmmMap.put("modelType", "VIEW");
			HashMap xml= new HashMap();
			if(modelMap!=null && !modelMap.isEmpty()){
				xml=DiagramUtil.getMxGraphModelXml(cmmMap, modelXML, listXML, listTextXml);
			}
			
			String diagramForXml = StringUtil.checkNull(xml.get("diagramForXml"));
			String updateForXml = StringUtil.checkNull(xml.get("updateForXml"));			
			
			
			res.getWriter().print(diagramForXml + "###" + updateForXml);
			
		} catch (IOException e) {
			MessageHandler.getMessage("json.send.message");
			e.printStackTrace();
		}
		//return diagramForXml;
	}
}