package xbolt.app.pim.instance.web;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
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
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;

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
public class InstanceActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@RequestMapping(value="/instanceMgt.do")
	public String instanceMgt(HttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception{
		String url = "/app/pim/main/instanceMgt";
		try{
				String arcCode =  StringUtil.checkNull(cmmMap.get("arcCode"),"");
				String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
				String unfold = StringUtil.checkNull(cmmMap.get("unfold"));
				String arcDefPage = StringUtil.checkNull(cmmMap.get("arcDefPage"));
				String nodeID = StringUtil.checkNull(cmmMap.get("nodeID"));
				Map setData = new HashMap();
				setData.put("itemID", nodeID);
				String itemClassMenuURL = StringUtil.checkNull(commonService.selectString("menu_SQL.getItemClassMenuURL", setData));
				
				model.put("arcCode", arcCode);
				model.put("menuStyle", menuStyle);
				model.put("unfold", unfold);
				model.put("arcDefPage", arcDefPage);
				model.put("nodeID", nodeID);
				model.put("itemClassMenuURL", itemClassMenuURL);
				
				setData.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
				setData.put("SelectMenuId", arcCode);
				
				List topMenuList = commonService.selectList("instance_SQL.menuTreeListTopItemFilter", setData);
				List menuList = commonService.selectList("menu_SQL.menuTreeListItemInstanceFilter", setData);
				
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
				String filepath = request.getSession().getServletContext().getRealPath("/");
				/* xml 파일명 설정 */
		        String xmlFilName = "upload/instanceTree.xml";
		        makeInstanceTreeXML(filepath, topMenuList, menuList, xmlFilName, setData, request);
		        model.put("xmlFilName", xmlFilName);
		       
				
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainActionController::instanceMgt::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl(url);
	}
	
	private void makeInstanceTreeXML(String filepath, List topTreeList, List treeList, String xmlFilName, Map setMap, HttpServletRequest request) throws ExceptionUtil {
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
		    
		    String topTreeID = "";
		    String preTreeID = "";
		    String nodeID = "";
		    for(int i=0; i<topTreeList.size(); i++){
		    	Map topTreeMap = (Map)topTreeList.get(i);
		    	topTreeID = StringUtil.checkNull(topTreeMap.get("TREE_ID"));
		    	
		    	item1.setAttribute("text",  StringUtil.checkNull(topTreeMap.get("TREE_NM")) );	
		        item1.setAttribute("id", topTreeID );	
		        item1.setAttribute("im0", "iconFlag.gif");	
		        item1.setAttribute("im1", "iconGraph.gif");	
		        item1.setAttribute("im2", "iconFlag.gif");	
		        item1.setAttribute("open", "1");	
		        for(int j=0; j<treeList.size(); j++){
		        	Map treeMap = (Map)treeList.get(j);
		        	preTreeID = StringUtil.checkNull(treeMap.get("PRE_TREE_ID"));
		        	nodeID = StringUtil.checkNull(treeMap.get("TREE_ID"));
		        	if(topTreeID.equals(preTreeID)){
		        		item2 = doc.createElement("item");	
		    	        item2.setAttribute("id", nodeID);
		    	        item2.setAttribute("text", StringUtil.checkNull(treeMap.get("TREE_NM")));	
		    	        item1.appendChild(item2);
		    	        
		    	        setMap.put("preTreeID", nodeID);
		    	        List childMenuList = commonService.selectList("instance_SQL.menuChildTreeListItemInstanceFilter", setMap);
		    	        if(childMenuList.size() > 0){
			    	        for(int k=0; k<childMenuList.size(); k++){
			    	        	Map childMap = (Map)childMenuList.get(k);
			    	        	item3 = doc.createElement("item");	
				    	        item3.setAttribute("id", StringUtil.checkNull(childMap.get("TREE_ID")));
				    	        item3.setAttribute("text", StringUtil.checkNull(childMap.get("TREE_NM")));	
				    	        item2.appendChild(item3);
				    	       
				    	        // PROCESS FOLDER
				    	        setMap.put("preTreeID", StringUtil.checkNull(childMap.get("TREE_ID")));
				    	        List procMenuList = commonService.selectList("instance_SQL.menuChildTreeListItemInstanceFilter", setMap);
				    	        item4 = doc.createElement("item");	
				    	        item4.setAttribute("im0", "leaf_origkn.gif");	
						        item4.setAttribute("im1", "leaf_origkn.gif");	
						        item4.setAttribute("im2", "leaf_origkn.gif");	
				    	        item4.setAttribute("id", "MASTER");
				    	        item4.setAttribute("text", "Master process");	
				    	        item3.appendChild(item4);
				    	        
				    	        for(int l=0; l<procMenuList.size(); l++){
				    	        	Map procMap = (Map)procMenuList.get(l);
				    	        	item5 = doc.createElement("item");	
					    	        item5.setAttribute("id", StringUtil.checkNull(procMap.get("TREE_ID")));
					    	        item5.setAttribute("text", StringUtil.checkNull(procMap.get("TREE_NM")));	
					    	        item4.appendChild(item5);
				    	        }
				    	        
				    	        // PIM FOLDER
				    	        item4 = doc.createElement("item");	
				    	        item4.setAttribute("im0", "folderOpen_origin.gif");	
						        item4.setAttribute("im1", "folderOpen_origin.gif");	
						        item4.setAttribute("im2", "folderOpen_origin.gif");	
				    	        item4.setAttribute("id", "IST" );
				    	        item4.setAttribute("text", "Instance" );	
				    	        item3.appendChild(item4);
				    	        List pimMenuList = commonService.selectList("instance_SQL.menuPIMTreeListItemInstanceFilter", setMap);
				    	        
				    	        for(int m=0; m<pimMenuList.size(); m++){
				    	        	Map pimMap = (Map)pimMenuList.get(m);
				    	        	item5 = doc.createElement("item");				    	        	
					    	        item5.setAttribute("id", StringUtil.checkNull(pimMap.get("TREE_ID")));
					    	        item5.setAttribute("text", StringUtil.checkNull(pimMap.get("TREE_NM")));	
					    	        item4.appendChild(item5);
				    	        }
			    	        }
		    	        }
		    	        
		        	}
		        }
		    }
		 
	        treeElement.appendChild(item1); 
	        
		    // XML 파일로 쓰기 
	        TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
	        Transformer transformer = transformerFactory.newTransformer(); 
	        
	        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
		    transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
		    DOMSource source = new DOMSource(doc); 	  
		    StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName))); 
		    transformer.transform(source, result); 
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}
	
	@RequestMapping(value="/procInstanceMgt.do")
	public String procInstanceMgt(HttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception{
		String url = "/app/pim/instance/procInstanceMgt";
		try{
				String arcCode =  StringUtil.checkNull(cmmMap.get("arcCode"),"");
				String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
				String unfold = StringUtil.checkNull(cmmMap.get("unfold"));
				String arcDefPage = StringUtil.checkNull(cmmMap.get("arcDefPage"));
				String nodeID = StringUtil.checkNull(cmmMap.get("nodeID"));
				String masterProjectID = StringUtil.checkNull(cmmMap.get("projectID"));
				String itemClass = StringUtil.checkNull(cmmMap.get("itemClass"));
				String masterModelType = StringUtil.checkNull(cmmMap.get("masterModelType"));
				String refPGID = StringUtil.checkNull(cmmMap.get("refPGID"));
				String myProject = StringUtil.checkNull(cmmMap.get("myProject"));
				String gloProjectID = StringUtil.checkNull(request.getParameter("gloProjectID"));
				String focusedItemID = StringUtil.checkNull(request.getParameter("focusedItemID"));
			//	String variantProjectType = StringUtil.checkNull(request.getParameter("variantProjectType"));
				
				Map setData = new HashMap();
				Map pjtInfoMap = new HashMap();
				if(!gloProjectID.equals("") && !gloProjectID.equals("undefind") ){
					setData.put("projectCode", gloProjectID);
					pjtInfoMap = commonService.select("variant_SQL.getPJTInfos", setData);
					
					if(pjtInfoMap != null){		
						setData.put("refPGID", StringUtil.checkNull(pjtInfoMap.get("RefPGID")));
						arcCode = StringUtil.checkNull(commonService.selectString("variant_SQL.getDefArcCode", setData));
						setData.put("arcCode", arcCode);
						Map arcMenuInfo = commonService.select("menu_SQL.getArcInfo", setData);
						if(arcMenuInfo != null && !arcMenuInfo.isEmpty()){ 
							menuStyle = StringUtil.checkNull(arcMenuInfo.get("MenuStyle"),"");
						}
						setData.put("projectID", StringUtil.checkNull(pjtInfoMap.get("ProjectID")));
						nodeID = StringUtil.checkNull(commonService.selectString("variant_SQL.getDefVariantID", setData));
						//System.out.println("nodeID :::"+nodeID);
					}
				}
				
				setData = new HashMap();
				setData.put("itemID", nodeID);
				String itemClassMenuURL = StringUtil.checkNull(commonService.selectString("menu_SQL.getItemClassMenuURL", setData));
				
				setData.put("sessionCurrLangType", cmmMap.get("sessionCurrLangType"));
				setData.put("languageID", cmmMap.get("sessionCurrLangType"));
				setData.put("SelectMenuId", arcCode);
				setData.put("masterModelType", masterModelType);
				
				String SQL_CODE=StringUtil.checkNull(commonService.selectString("menu_SQL.getMenuTreeSqlName", setData) ,"commonCode");
				
				List topMenuList = commonService.selectList("instance_SQL.menuTreeListTopItemFilter", setData);
				List menuList = commonService.selectList("menu_SQL."+SQL_CODE, setData);	
				
			//	model.put("variantProjectType", variantProjectType);
				model.put("arcCode", arcCode);
				model.put("menuStyle", menuStyle);
				model.put("unfold", unfold);
				model.put("arcDefPage", arcDefPage);
				model.put("nodeID", nodeID);
				model.put("itemClass", itemClass);
				model.put("masterModelType", masterModelType);
				model.put("refPGID", refPGID);
				model.put("myProject", myProject);
				model.put("masterProjectID", masterProjectID);
				model.put("itemClassMenuURL", itemClassMenuURL);
				model.put("nodeID", nodeID);
				model.put("focusedItemID", focusedItemID);
			
				String filepath = request.getSession().getServletContext().getRealPath("/");
				/* xml 파일명 설정 */
				Calendar cal = Calendar.getInstance();
				java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
				java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("HHmmssSSS");
				String sdate = sdf.format(cal.getTime());
				String stime = sdf2.format(cal.getTime());
				String mkFileNm = sdate+stime;
				 
		        String xmlFilName = "upload/procInsctanceTree"+mkFileNm+".xml";
		        makeProcInstanceTreeXML(filepath, topMenuList, menuList, xmlFilName, cmmMap, setData, request);
		        model.put("xmlFilName", xmlFilName);
				
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("InstanceActionController::procInstanceMgt::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl(url);
	}
	
	private void makeProcInstanceTreeXML(String filepath, List topTreeList, List treeList, String xmlFilName, HashMap cmmMap,Map setMap, HttpServletRequest request) throws ExceptionUtil {
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
		    
		    List childTreeMenuList = new ArrayList();
		    for(int i=0; i<topTreeList.size(); i++){
		    	Map topTreeMap = (Map)topTreeList.get(i);
		    	topTreeID = StringUtil.checkNull(topTreeMap.get("TREE_ID"));
		    	
		    	item1.setAttribute("text",  StringUtil.checkNull(topTreeMap.get("TREE_NM")) );	
		        item1.setAttribute("id", topTreeID );	
		        item1.setAttribute("im0", "icon_tree_variant1.gif");	
		        item1.setAttribute("im1", "icon_tree_variant1.gif");	
		        item1.setAttribute("im2", "icon_tree_variant1.gif");	
		        item1.setAttribute("open", "1");
		        
		        item2 = doc.createElement("item");	
    	        item2.setAttribute("im0", "icon_tree_variant2.gif");	
    	        item2.setAttribute("im1", "icon_tree_variant2.gif");	
    	        item2.setAttribute("im2", "icon_tree_variant2.gif");	
    	        item2.setAttribute("id", topTreeID);
    	        item2.setAttribute("text", "Task");	
    	        item1.appendChild(item2);
    	        	        
    	        //childTreeMenuList = commonService.selectList("menu_SQL.menuTreeListNoFilter_treeList", setMap); // 20180117 treeList(menu_SQL.VariantProjectModel_treeList) 변경
    	        if(treeList.size() > 0){
	    	        for(int j=0; j<treeList.size(); j++){
	    	        	Map childMap = (Map)treeList.get(j);
	    	        	if(StringUtil.checkNull(topTreeMap.get("TREE_ID")).equals( StringUtil.checkNull(childMap.get("PRE_TREE_ID")))){
		    	        	item3 = doc.createElement("item");	
			    	        item3.setAttribute("id", StringUtil.checkNull(childMap.get("TREE_ID")));
			    	        item3.setAttribute("text", StringUtil.checkNull(childMap.get("TREE_NM")));	
			    	        item2.appendChild(item3);
			    	        
			    	        if(treeList.size() > 0){
				    	        for(int k=0; k<treeList.size(); k++){
				    	        	Map childTreeMap = (Map)treeList.get(k);
				    	        	nodeID = StringUtil.checkNull(childMap.get("TREE_ID"));
				    	        	childTreeID = StringUtil.checkNull(childTreeMap.get("TREE_ID"));
				    	        	if(nodeID.equals( StringUtil.checkNull(childTreeMap.get("PRE_TREE_ID")))){
					    	        	item4 = doc.createElement("item");	
					    	        	item4.setAttribute("id", StringUtil.checkNull(childTreeMap.get("TREE_ID")));
					    	        	item4.setAttribute("text", StringUtil.checkNull(childTreeMap.get("TREE_NM")));	
						    	        item3.appendChild(item4);						    	        
						    	        
						    	        for(int k2=0; k2<treeList.size(); k2++){
						    	        	Map childTreeMap2 = (Map)treeList.get(k2);		
						    	        	childTreeID2 = StringUtil.checkNull(childTreeMap2.get("TREE_ID"));
						    	        	if(childTreeID.equals( StringUtil.checkNull(childTreeMap2.get("PRE_TREE_ID")))){
						    	        		item5 = doc.createElement("item");	
							    	        	item5.setAttribute("id", StringUtil.checkNull(childTreeMap2.get("TREE_ID")));
							    	        	item5.setAttribute("text", StringUtil.checkNull(childTreeMap2.get("TREE_NM")));	
								    	        item4.appendChild(item5);
								    	        
								    	        for(int k3=0; k3<treeList.size(); k3++){
								    	        	Map childTreeMap3 = (Map)treeList.get(k3);
								    	        	childTreeID3 = StringUtil.checkNull(childTreeMap3.get("TREE_ID"));
								    	        	if(childTreeID2.equals( StringUtil.checkNull(childTreeMap3.get("PRE_TREE_ID")))){
								    	        		item6 = doc.createElement("item");	
									    	        	item6.setAttribute("id", StringUtil.checkNull(childTreeMap3.get("TREE_ID")));
									    	        	item6.setAttribute("text", StringUtil.checkNull(childTreeMap3.get("TREE_NM")));	
										    	        item5.appendChild(item6);
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
    	        
    	        // &refPGID=14&masterModelType=MT003&&nodeID=748610
    	        // ProcInstance FOLDER
    	        String variantClass =  StringUtil.checkNull(request.getParameter("variantClass"),"");
    	        String myProject =  StringUtil.checkNull(request.getParameter("myProject"),"");
    	        String pjtStatus =  StringUtil.checkNull(request.getParameter("pjtStatus"),"");
    	        
    	        item2 = doc.createElement("item");	
    	        item2.setAttribute("im0", "icon_tree_variant3.gif");	
    	        item2.setAttribute("im1", "icon_tree_variant3.gif");	
    	        item2.setAttribute("im2", "icon_tree_variant3.gif");	
    	        item2.setAttribute("id", "instanceList" );
    	        item2.setAttribute("text", "Project" );	
    	        item1.appendChild(item2);
    	        
    	        setMap.put("processID", StringUtil.checkNull(topTreeMap.get("TREE_ID")));
    	        setMap.put("classCode",  variantClass);
    	        setMap.put("myProject",  myProject);
    	        setMap.put("pjtStatus",  pjtStatus);
    	        setMap.put("sessionUserId", cmmMap.get("sessionUserId"));
    	        setMap.put("instanceClass", "PROC");
    	        List procInstanceMenuList = commonService.selectList("instance_SQL.getProcInstanceList", setMap);
    	        List ElmInstMenuList = new ArrayList();
    	        String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
    	        for(int m=0; m<procInstanceMenuList.size(); m++){
    	        	Map procInstanceMap = (Map)procInstanceMenuList.get(m);
    	        	String ProcInstNo = StringUtil.checkNull(procInstanceMap.get("Identifier"));
    	        	item3 = doc.createElement("item");				    	        	
    	        	item3.setAttribute("id", StringUtil.checkNull(procInstanceMap.get("TREE_ID")));
    	        	item3.setAttribute("text", StringUtil.checkNull(procInstanceMap.get("Identifier"))+" "+StringUtil.checkNull(procInstanceMap.get("TREE_NM")));	
	    	        item2.appendChild(item3);
	    	        //ELM LIST
	    	        setMap = new HashMap();
	    	        setMap.put("ProcInstNo", StringUtil.checkNull(procInstanceMap.get("Identifier")));
	    	        setMap.put("instanceClass", "ELM");
	    	        setMap.put("languageID", languageID);
	    	        ElmInstMenuList = commonService.selectList("instance_SQL.getElmInstList", setMap);
	    	       
	    	        for(int n=0; n<ElmInstMenuList.size(); n++){
	    	        	Map ElmInstMap = (Map)ElmInstMenuList.get(n);
	    	        	String stepPreTreeID = StringUtil.checkNull(ElmInstMap.get("PRE_TREE_ID"));
	    	        	if(ProcInstNo.equals(stepPreTreeID)){
		    	        	item4 = doc.createElement("item");				    	        	
		    	        	item4.setAttribute("id", StringUtil.checkNull(ElmInstMap.get("TREE_ID")));
		    	        	item4.setAttribute("text", StringUtil.checkNull(ElmInstMap.get("Identifier"))+" "+StringUtil.checkNull(ElmInstMap.get("TREE_NM")));	
			    	        item3.appendChild(item4);
			    	        for(int n2=0; n2<ElmInstMenuList.size(); n2++){
			    	        	Map ElmInstMap2 = (Map)ElmInstMenuList.get(n2);
			    	        	if(ElmInstMap.get("Identifier").equals(ElmInstMap2.get("PRE_TREE_ID"))){
			    	        		item5 = doc.createElement("item");				    	        	
				    	        	item5.setAttribute("id", StringUtil.checkNull(ElmInstMap2.get("TREE_ID")));
				    	        	item5.setAttribute("text", StringUtil.checkNull(ElmInstMap2.get("Identifier"))+" "+StringUtil.checkNull(ElmInstMap2.get("TREE_NM")));	
					    	        item4.appendChild(item5);
			    	        	}
			    	        }
	    	        	}
	    	        }
    	        }
		    }
		 
	        treeElement.appendChild(item1); 
	        
		    // XML 파일로 쓰기 
	        TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
	        Transformer transformer = transformerFactory.newTransformer(); 
	        
	        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
		    transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
		    DOMSource source = new DOMSource(doc); 	  
		    StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName))); 
		    transformer.transform(source, result); 
		}
		catch(Exception e) {
			throw new ExceptionUtil(e.toString());
		}
	}
	
	@RequestMapping(value="/old_plm_ViewProjectCharter.do")
	public String old_plm_ViewProjectCharter(ModelMap model,HashMap cmmMap)throws Exception{
		String url = "//app/pim//instance//plm_ViewProjectCharter";
		try {			
			String archiCode = StringUtil.checkNull(cmmMap.get("option"),"");
			String s_itemID = StringUtil.checkNull(cmmMap.get("instanceNo"));			
			Map getURL  = new HashMap();			
					
			/* ModelID 보유 확인 */
			Map setMap = new HashMap();
			setMap.put("languageID", cmmMap.get("languageID"));			
			setMap.put("ModelID", s_itemID);
			setMap.put("s_itemID", s_itemID);			
			if(archiCode.equals("AR040420")){setMap.put("s_itemID", "1001");}
			//_log.info("s_itemID="+s_itemID+",archiCode="+archiCode+",languageID="+setMap.get("languageID"));
			
			model.put("id", s_itemID);
			model.put("masterItemID", s_itemID);
			model.put("variantClass", cmmMap.get("variantClass"));
			model.put("masterProjectID", cmmMap.get("masterProjectID"));
			model.put("myProject", cmmMap.get("myProject"));
			model.put("refPGID", cmmMap.get("refPGID"));
			model.put("choiceIdentifier", s_itemID);
			model.put("option", archiCode);
			model.put("level", (String)cmmMap.get("level"));
			model.put("menuText", StringUtil.checkNull(cmmMap.get("menuText")));
			
			
			setMap.put("ArcCode", archiCode);			
			setMap.put("s_itemID", s_itemID);	
			
			// TODO:MPM관리자 -> Org/User -> 사용자 관리
			// TB_MENU_ALLOC.ClassCode IS NULL
			if (archiCode.equals("AR040420")) {
				setMap.put("s_itemID", "null");	
			}
			
			List getList = new ArrayList();
			setMap.put("fromModelYN", StringUtil.checkNull(cmmMap.get("fromModelYN"),""));
			// [ArcCode][ClassCode]의 Menu 취득			
			// getList = commonService.selectList("menu_SQL.getTabMenu", setMap);
			
			// [ClassCode]의 default Menu 취득
			if(getList.size() == 0){
				setMap.put("ArcCode", "AR000000");			
			//	getList = commonService.selectList("menu_SQL.getTabMenu", setMap);
			}	
			
			// default Menu 취득
			if(getList.size() == 0){
				setMap.put("ArcCode", "AR000000");	
				setMap.put("s_itemID", "null");
				setMap.put("ClassCode", "CL01000");	
				//getList = commonService.selectList("menu_SQL.getTabMenu", setMap);
			}	
			Map menuMap = new HashMap();
			menuMap.put("Name", "개요");
			menuMap.put("URL", "plm_ViewProjectTask");
			menuMap.put("VarFilter", "");
			menuMap.put("Sort", 1);
			
			getList.add(menuMap);
			
			menuMap = new HashMap();
			menuMap.put("Name", "모델");
			menuMap.put("URL", "newDiagramViewer");
			menuMap.put("VarFilter", "&filter=element");
			menuMap.put("Sort", 2);
			
			getList.add(menuMap);
						
			setMap = new HashMap();
			String blankPhotoUrlPath = GlobalVal.HTML_IMG_DIR + "/blank_photo.png";
			String photoUrlPath = GlobalVal.EMP_PHOTO_URL;
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			
			setMap.put("itemID", s_itemID);
			setMap.put("languageID", languageID);
			setMap.put("blankPhotoUrlPath", blankPhotoUrlPath);
			setMap.put("photoUrlPath", photoUrlPath);
			setMap.put("isAll", "N");

			model.put("baseAtchUrl",GlobalVal.BASE_ATCH_URL);
			model.put("getList", getList);
			model.put("fromModelYN", StringUtil.checkNull(cmmMap.get("fromModelYN"),""));
			model.put("focusedItemID", StringUtil.checkNull(cmmMap.get("focusedItemID"),""));
			model.put("instanceClass", StringUtil.checkNull(cmmMap.get("instanceClass"),""));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);		
	}	
	
	@RequestMapping(value="/plm_ViewProjectTask.do")
	public String plm_ViewProjectTask(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String url= "/app/pim/instance/plm_ViewProjectTask";
		
		try {			
			String archiCode = StringUtil.checkNull(cmmMap.get("option"),"");
			String ElmInstNo = StringUtil.checkNull(cmmMap.get("instanceNo"));	
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String instanceClass = StringUtil.checkNull(cmmMap.get("instanceClass"));
			
			Map setData = new HashMap();
			setData.put("instanceClass", instanceClass);
			setData.put("languageID", languageID);
			setData.put("ElmInstNo", ElmInstNo);
			Map ElmInstMap = commonService.select("instance_SQL.getElmInstInfo", setData);
			model.put("ElmInstInfo", ElmInstMap);
			
			String ProcInstNo = StringUtil.checkNull(ElmInstMap.get("ProcInstNo"));
			String elmItemID = StringUtil.checkNull(ElmInstMap.get("ElmItemID"));
			setData.put("processID", elmItemID);
			setData.put("ProcInstNo", ProcInstNo);
			setData.put("instanceClass", "PROC");
			Map procInstanceInfo = commonService.select("instance_SQL.getProcInstanceInfo", setData);			
			model.put("procInstanceInfo", procInstanceInfo);	
			
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setData);
			/* 속성 */
			List attrList = new ArrayList();
			
			setData.put("defaultLang", defaultLang);
			setData.put("processID", elmItemID);
			setData.put("instanceNo", ElmInstNo);
			setData.put("instanceClass", instanceClass);
			attrList = (List)commonService.selectList("instance_SQL.getInstanceAttrView", setData);
			model.put("attrList", attrList);
			model.put("attributesList", attrList); 
			
			/** 첨부문서 */
			setData.put("isPublic", "N");
			List attachFileList = commonService.selectList("instanceFile_SQL.getInstanceFile", setData);
			model.put("attachFileList", attachFileList);
			
			setData.put("instanceNo", ProcInstNo);
			Map dimInfoMap = commonService.select("instance_SQL.getInstanceDimPath", setData);			
			model.put("dimPath", dimInfoMap.get("DimPath"));
			
			model.put("variantClass", cmmMap.get("variantClass"));
			model.put("masterProjectID", cmmMap.get("masterProjectID"));
			model.put("myProject", cmmMap.get("myProject"));
			model.put("refPGID", cmmMap.get("refPGID"));
			model.put("choiceIdentifier", ElmInstNo);
			model.put("option", archiCode);
			model.put("level", (String)cmmMap.get("level"));
			model.put("menuText", StringUtil.checkNull(cmmMap.get("menuText")));
			
			setData = new HashMap();
			setData.put("itemID", elmItemID);
			setData.put("languageID", languageID);			
			List subTabMenuList = (List)commonService.selectList("instance_SQL.getInstanceMenuList", setData);
			if(subTabMenuList.size() > 0){
				Map firstSubTabMenu = (Map)subTabMenuList.get(0);
				model.put("firstSubTabMenu", firstSubTabMenu);
			}
			
			model.put("subTabMenuList", subTabMenuList);
			model.put("subTabMenuListSize", subTabMenuList.size());
						
			model.put("baseAtchUrl",GlobalVal.BASE_ATCH_URL);
			model.put("fromModelYN", StringUtil.checkNull(cmmMap.get("fromModelYN"),""));
			model.put("focusedItemID", StringUtil.checkNull(cmmMap.get("focusedItemID"),""));
			model.put("instanceClass", StringUtil.checkNull(cmmMap.get("instanceClass"),""));
			model.put("menu", getLabel(cmmMap, commonService));
			
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		
		return nextUrl(url);
	}
	
	@RequestMapping(value="/plm_ViewProjectCharter.do")
	public String plm_ViewProjectCharter(ModelMap model,HashMap cmmMap)throws Exception{
		String url = "//app/pim//instance//plm_ViewProjectCharter";
		try {			
			String archiCode = StringUtil.checkNull(cmmMap.get("option"),"");
			String instanceNo = StringUtil.checkNull(cmmMap.get("instanceNo"));	
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String instanceClass = StringUtil.checkNull(cmmMap.get("instanceClass"));
			String masterItemID = StringUtil.checkNull(cmmMap.get("masterItemID"));
			model.put("masterItemID", masterItemID);
			
			Map setData = new HashMap();
			setData.put("instanceNo", instanceNo);
			setData.put("instanceClass", instanceClass);
			setData.put("languageID", languageID);
			Map procInstanceInfo = commonService.select("instance_SQL.getProcInstanceInfo", setData);			
			model.put("procInstanceInfo", procInstanceInfo);	
			
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setData);
			/* 기본정보의 속성 내용을 취득 */
			List attrList = new ArrayList();
			
			setData.put("defaultLang", defaultLang);
			String processID = StringUtil.checkNull(procInstanceInfo.get("ProcessID"));
			setData.put("processID", processID);
			attrList = (List)commonService.selectList("instance_SQL.getInstanceAttrView", setData);
			model.put("attrList", attrList);
			model.put("attributesList", attrList); // 속성
			
			/** 첨부문서 취득 */
			setData.put("isPublic", "N");
			List attachFileList = commonService.selectList("instanceFile_SQL.getInstanceFile", setData);
			model.put("attachFileList", attachFileList);
			
			/* ModelID 보유 확인 */
			Map setMap = new HashMap();
			setMap.put("languageID", cmmMap.get("languageID"));			
			setMap.put("ModelID", instanceNo);
			setMap.put("s_itemID", instanceNo);			
			if(archiCode.equals("AR040420")){setMap.put("s_itemID", "1001");}
			//_log.info("s_itemID="+s_itemID+",archiCode="+archiCode+",languageID="+setMap.get("languageID"));
			
			setMap.put("instanceNo", instanceNo);
			Map dimInfoMap = commonService.select("instance_SQL.getInstanceDimPath", setMap);			
			model.put("dimPath", dimInfoMap.get("DimPath"));
			
			model.put("id", instanceNo);
			model.put("masterItemID", instanceNo);
			model.put("variantClass", cmmMap.get("variantClass"));
			model.put("masterProjectID", cmmMap.get("masterProjectID"));
			model.put("myProject", cmmMap.get("myProject"));
			model.put("refPGID", cmmMap.get("refPGID"));
			model.put("choiceIdentifier", instanceNo);
			model.put("option", archiCode);
			model.put("level", (String)cmmMap.get("level"));
			model.put("menuText", StringUtil.checkNull(cmmMap.get("menuText")));
			
			setMap.put("ArcCode", archiCode);			
			setMap.put("s_itemID", instanceNo);	
			
			setData = new HashMap();
			setData.put("itemID", procInstanceInfo.get("ProcessID"));
			setData.put("languageID", languageID);			
			List subTabMenuList = (List)commonService.selectList("instance_SQL.getInstanceMenuList", setData);
			model.put("subTabMenuList", subTabMenuList);
			if(subTabMenuList.size() > 0){
				Map firstSubTabMenu = (Map)subTabMenuList.get(0);
				model.put("firstSubTabMenu", firstSubTabMenu);
			}			
			model.put("subTabMenuListSize", subTabMenuList.size());

			model.put("baseAtchUrl",GlobalVal.BASE_ATCH_URL);
			model.put("fromModelYN", StringUtil.checkNull(cmmMap.get("fromModelYN"),""));
			model.put("focusedItemID", StringUtil.checkNull(cmmMap.get("focusedItemID"),""));
			model.put("instanceClass", StringUtil.checkNull(cmmMap.get("instanceClass"),""));
			model.put("menu", getLabel(cmmMap, commonService));
		} catch (Exception e) {
			System.out.println(e);
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
	
	@RequestMapping(value="/editProcInstanceInfo.do")
	public String editProcInstanceInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/app/pim/instance/editProcInstanceInfo";
		try {
			String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"),"");
			String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"),"");
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"),"");
			model.put("instanceClass", instanceClass);
			Map setData = new HashMap();
			setData.put("instanceNo", instanceNo);
			setData.put("instanceClass", instanceClass);
			setData.put("languageID", languageID);
			
			Map procInstanceInfo = (HashMap)commonService.select("instance_SQL.getProcInstanceInfo", setData);
			model.put("procInstanceInfo", procInstanceInfo);	
			String processID = StringUtil.checkNull(procInstanceInfo.get("ProcessID"),"");
			
			/* 속성 */
			List attrList = new ArrayList();
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);
			setData = new HashMap();		
			setData.put("processID", processID);
			setData.put("instanceNo", instanceNo);
			setData.put("defaultLang", defaultLang);
			setData.put("languageID", languageID);
			setData.put("instanceClass", instanceClass);
			// isComLang = ALL
			attrList = (List)commonService.selectList("instance_SQL.getInstanceAttrView", setData);
			// get ITEM ATTR (각 속성에 따른 언어 설정(IsComLang)에 따른 data 취득)
			//returnData = GetItemAttrList.getItemAttrList2(commonService, returnData, OccAttrInfo, request.getParameter("languageID"));
			
			List mLovList = new ArrayList();
			List mLovAttrList = new ArrayList();
			List mLovList2 = new ArrayList();
		
			Map mLovMap = new HashMap();
			String dataType = "";
			String dataType2 = "";
			String mLovAttrTypeCode = "";
			String mLovAttrTypeValue = "";
			
			int k=0; int l=0;
			for(int i=0; i<attrList.size(); i++){
				Map listMap = (Map) attrList.get(i);
				dataType = StringUtil.checkNull(listMap.get("DataType"));
				dataType2 = StringUtil.checkNull(listMap.get("DataType2"));
				if(!dataType.equals("Text")){
					setData.put("attrTypeCode",listMap.get("AttrTypeCode"));
					//setData.put("itemID",s_itemID);
					setData.put("languageID", commandMap.get("sessionCurrLangType")); 
					setData.put("defaultLang", defaultLang);
					mLovList = commonService.selectList("attr_SQL.getMLovListWidthItemAttr",setData);
					listMap.put("mLovList", mLovList);
										
					if(k==0){
						mLovAttrTypeCode = StringUtil.checkNull(listMap.get("AttrTypeCode"));
						mLovAttrTypeValue =  StringUtil.checkNull(listMap.get("NAME"));
					}else{
						mLovAttrTypeCode = mLovAttrTypeCode  + "," +StringUtil.checkNull(listMap.get("AttrTypeCode"));
						mLovAttrTypeValue = mLovAttrTypeValue  + "," +StringUtil.checkNull(listMap.get("NAME"));
					}
					model.put("mLovAttrTypeCode",mLovAttrTypeCode);
					model.put("mLovAttrTypeValue",mLovAttrTypeValue);
					k++;
				}
				
				if(!dataType2.equals("Text")){
					setData.put("attrTypeCode",listMap.get("AttrTypeCode2"));
					//setData.put("itemID",s_itemID);
					setData.put("languageID", commandMap.get("sessionCurrLangType"));
					setData.put("defaultLang", defaultLang);
					mLovList2 = commonService.selectList("attr_SQL.getMLovListWidthItemAttr",setData);
					listMap.put("mLovList2", mLovList2);
										
					if(l==0 && mLovAttrTypeCode.equals("")){
						mLovAttrTypeCode = StringUtil.checkNull(listMap.get("AttrTypeCode2"));
						mLovAttrTypeValue =  StringUtil.checkNull(listMap.get("NAME2"));
					}else{
						mLovAttrTypeCode = mLovAttrTypeCode  + "," +StringUtil.checkNull(listMap.get("AttrTypeCode2"));
						mLovAttrTypeValue = mLovAttrTypeValue  + "," +StringUtil.checkNull(listMap.get("NAME2"));
					}
					model.put("mLovAttrTypeCode2",mLovAttrTypeCode);
					model.put("mLovAttrTypeValue2",mLovAttrTypeValue);
					l++;
				}
			}
			
			model.put("attrList", attrList);
			model.put("title", request.getParameter("title"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/saveProcInstanceInfo.do")
	public String saveProcInstanceInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{
			
			String setInfo = "";		
			Map setValue = new HashMap();
			String processID = StringUtil.checkNull(request.getParameter("processID"));
			String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"));
			String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"));
			
			setValue.put("instanceNo", instanceNo);
			setValue.put("instanceClass", instanceClass);						
			setValue.put("regTeamID", commandMap.get("sessionTeamId"));
			setValue.put("regUserID", commandMap.get("sessionUserId"));
			setValue.put("lastUserTeamID", commandMap.get("sessionTeamId"));
			setValue.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
			
			/* Item_Attr update */
			List procInstAttrList = new ArrayList();
			// Editable 이, 1인 속성만 update 처리를 한다
			commandMap.put("Editable", "1");
			procInstAttrList = (List)commonService.selectList("instance_SQL.getProcInstanceAttr", commandMap);	
			
			Map setMap = new HashMap();
			String dataType = "";
			String mLovValue = "";
			for(int i = 0; i < procInstAttrList.size() ; i++){				
				setMap = (HashMap)procInstAttrList.get(i);
				dataType = StringUtil.checkNull(setMap.get("DataType"));
				
				if(!dataType.equals("Text")){
					if(dataType.equals("MLOV")){
						String reqMLovValue[] =  StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode"))).split(",");
						Map delData = new HashMap();
						delData.put("instanceNo", instanceNo);
						delData.put("AttrTypeCode", setMap.get("AttrTypeCode"));
						commonService.delete("instance_SQL.delInstanceAttr", delData);
						
						for(int j=0; j<reqMLovValue.length; j++){
							mLovValue = reqMLovValue[j].toString();	
							setMap.put("instanceNo", instanceNo);
							setMap.put("instanceClass", instanceClass);		
							setMap.put("valu", mLovValue);										
							setMap.put("regTeamID", commandMap.get("sessionTeamId"));
							setMap.put("regUserID", commandMap.get("sessionUserId"));
							setMap.put("lastUserTeamID", commandMap.get("sessionTeamId"));
							setMap.put("lastUser", commandMap.get("sessionUserId"));
							
							setInfo = GetItemAttrList.procInstanceAttrUpdate(commonService, setMap);
						}	
					}else{
						setMap.put("instanceNo", instanceNo);
						setMap.put("instanceClass", instanceClass);		
						setMap.put("value", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()),"") );								
						setMap.put("regTeamID", commandMap.get("sessionTeamId"));
						setMap.put("regUserID", commandMap.get("sessionUserId"));
						setMap.put("lastUserTeamID", commandMap.get("sessionTeamId"));
						setMap.put("lastUser", commandMap.get("sessionUserId"));
						
						setInfo = GetItemAttrList.procInstanceAttrUpdate(commonService, setMap);
					}
				}else{
						setMap.put("instanceNo", instanceNo);
						setMap.put("instanceClass", instanceClass);						
						setMap.put("value", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()),"") );	
						setMap.put("regTeamID", commandMap.get("sessionTeamId"));
						setMap.put("regUserID", commandMap.get("sessionUserId"));
						setMap.put("lastUserTeamID", commandMap.get("sessionTeamId"));
						setMap.put("lastUser", commandMap.get("sessionUserId"));
						
						setInfo = GetItemAttrList.procInstanceAttrUpdate(commonService, setMap);
				}
			}
			
			target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
				
		
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}	
	
	@RequestMapping(value="/getInstanceMenuURL.do")
	public String getInstanceMenuURL(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		Map target = new HashMap();	
		try{ 			
			String instanceNo = StringUtil.checkNull(cmmMap.get("instanceNo"));
			String instanceClass = StringUtil.checkNull(cmmMap.get("instanceClass"));
			
			Map setData = new HashMap();			
			String itemID = "";	
			String instanceURL = "";
			if(instanceNo.equals("instanceList")){
				instanceURL = "pim_ProcInstanceList";
			}else{
				if(instanceClass.equals("PROC")){
					setData.put("ProcInstNo", instanceNo);
					itemID = StringUtil.checkNull(commonService.selectString("instance_SQL.getProcessID", setData));
				}else if(instanceClass.equals("ELM")){
					setData.put("ElmInstNo", instanceNo);
					itemID = StringUtil.checkNull(commonService.selectString("instance_SQL.getElmItemID", setData));
				}
				setData.put("itemID", itemID);	
				instanceURL = StringUtil.checkNull(commonService.selectString("instance_SQL.getInstacneURL", setData));
			}
			
			if(instanceURL.equals("")){
				target.put(AJAX_SCRIPT, "creatMenuTab('"+instanceNo+"','1')");
			}else{
				target.put(AJAX_SCRIPT, "fnSetInstanceMenu('"+instanceURL+"','"+instanceNo+"','"+instanceClass+"')");
			}

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		model.addAttribute(AJAX_RESULTMAP,target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/pim_ProcInstanceList.do")
	public String pim_ProcInstanceList(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "//app/pim//instance//pim_ProcInstanceList";
		try {			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("masterItemID", StringUtil.checkNull(cmmMap.get("masterItemID"),(String) cmmMap.get("s_itemID")));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);		
	}	
	
	@RequestMapping(value="/editElmInstInfo.do")
	public String editElmInstInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		String url = "/app/pim/instance/editProcInstanceInfo";
		try {
			String ProcInstNo = StringUtil.checkNull(request.getParameter("ProcInstNo"),"");
			String ElmInstNo = StringUtil.checkNull(request.getParameter("ElmInstNo"),"");
			String elmItemID = StringUtil.checkNull(request.getParameter("elmItemID"),"");
			String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"),"");
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"),"");
			
			model.put("ProcInstNo", ProcInstNo);
			model.put("ElmInstNo", ElmInstNo);
			model.put("elmItemID", elmItemID);
			model.put("instanceClass", instanceClass);
			
			Map setData = new HashMap();
			setData.put("instanceNo", ProcInstNo);
			setData.put("instanceClass", "PROC");
			setData.put("languageID", languageID);
			
			Map procInstanceInfo = (HashMap)commonService.select("instance_SQL.getProcInstanceInfo", setData);
			model.put("procInstanceInfo", procInstanceInfo);	
			
			
			setData.put("ElmInstNo", ElmInstNo);
			setData.put("instanceClass", "ELM");
			setData.put("languageID", languageID);
			Map ElmInstInfo = (HashMap)commonService.select("instance_SQL.getElmInstInfo", setData);
			model.put("ElmInstInfo",ElmInstInfo);
			
			/* 속성 */
			List attrList = new ArrayList();
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", commandMap);
			setData = new HashMap();		
			setData.put("processID", elmItemID);
			setData.put("instanceNo", ElmInstNo);
			setData.put("defaultLang", defaultLang);
			setData.put("languageID", languageID);
			setData.put("instanceClass", instanceClass);
			// isComLang = ALL
			attrList = (List)commonService.selectList("instance_SQL.getInstanceAttrView", setData);
			// get ITEM ATTR (각 속성에 따른 언어 설정(IsComLang)에 따른 data 취득)
			//returnData = GetItemAttrList.getItemAttrList2(commonService, returnData, OccAttrInfo, request.getParameter("languageID"));
			
			List mLovList = new ArrayList();
			List mLovAttrList = new ArrayList();
			List mLovList2 = new ArrayList();
		
			Map mLovMap = new HashMap();
			String dataType = "";
			String dataType2 = "";
			String mLovAttrTypeCode = "";
			String mLovAttrTypeValue = "";
			
			int k=0; int l=0;
			for(int i=0; i<attrList.size(); i++){
				Map listMap = (Map) attrList.get(i);
				dataType = StringUtil.checkNull(listMap.get("DataType"));
				dataType2 = StringUtil.checkNull(listMap.get("DataType2"));
				if(!dataType.equals("Text")){
					setData.put("attrTypeCode",listMap.get("AttrTypeCode"));
					//setData.put("itemID",s_itemID);
					setData.put("languageID", commandMap.get("sessionCurrLangType")); 
					setData.put("defaultLang", defaultLang);
					mLovList = commonService.selectList("attr_SQL.getMLovListWidthItemAttr",setData);
					listMap.put("mLovList", mLovList);
										
					if(k==0){
						mLovAttrTypeCode = StringUtil.checkNull(listMap.get("AttrTypeCode"));
						mLovAttrTypeValue =  StringUtil.checkNull(listMap.get("NAME"));
					}else{
						mLovAttrTypeCode = mLovAttrTypeCode  + "," +StringUtil.checkNull(listMap.get("AttrTypeCode"));
						mLovAttrTypeValue = mLovAttrTypeValue  + "," +StringUtil.checkNull(listMap.get("NAME"));
					}
					model.put("mLovAttrTypeCode",mLovAttrTypeCode);
					model.put("mLovAttrTypeValue",mLovAttrTypeValue);
					k++;
				}
				
				if(!dataType2.equals("Text")){
					setData.put("attrTypeCode",listMap.get("AttrTypeCode2"));
					//setData.put("itemID",s_itemID);
					setData.put("languageID", commandMap.get("sessionCurrLangType"));
					setData.put("defaultLang", defaultLang);
					mLovList2 = commonService.selectList("attr_SQL.getMLovListWidthItemAttr",setData);
					listMap.put("mLovList2", mLovList2);
										
					if(l==0 && mLovAttrTypeCode.equals("")){
						mLovAttrTypeCode = StringUtil.checkNull(listMap.get("AttrTypeCode2"));
						mLovAttrTypeValue =  StringUtil.checkNull(listMap.get("NAME2"));
					}else{
						mLovAttrTypeCode = mLovAttrTypeCode  + "," +StringUtil.checkNull(listMap.get("AttrTypeCode2"));
						mLovAttrTypeValue = mLovAttrTypeValue  + "," +StringUtil.checkNull(listMap.get("NAME2"));
					}
					model.put("mLovAttrTypeCode2",mLovAttrTypeCode);
					model.put("mLovAttrTypeValue2",mLovAttrTypeValue);
					l++;
				}
			}
			
			model.put("attrList", attrList);
			model.put("title", request.getParameter("title"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/saveElmInstInfo.do")
	public String saveElmInstInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{
			String setInfo = "";		
			Map setValue = new HashMap();
			String elmItemID = StringUtil.checkNull(request.getParameter("elmItemID"));
			String ProcInstNo = StringUtil.checkNull(request.getParameter("instanceNo"));
			String ElmInstNo = StringUtil.checkNull(request.getParameter("ElmInstNo"));
			String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"));
			
			setValue.put("instanceNo", ElmInstNo);
			setValue.put("instanceClass", instanceClass);
			setValue.put("processID", elmItemID);
			setValue.put("regTeamID", commandMap.get("sessionTeamId"));
			setValue.put("regUserID", commandMap.get("sessionUserId"));
			setValue.put("lastUserTeamID", commandMap.get("sessionTeamId"));
			setValue.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));
			
			/* Item_Attr update */
			List stepInstAttrList = new ArrayList();
			// Editable 이, 1인 속성만 update 처리를 한다
			commandMap.put("Editable", "1");
		    commandMap.put("instanceNo", ElmInstNo);
		    commandMap.put("processID", elmItemID);
			stepInstAttrList = (List)commonService.selectList("instance_SQL.getProcInstanceAttr", commandMap);	
			
			Map setMap = new HashMap();
			String dataType = "";
			String mLovValue = "";
			for(int i = 0; i < stepInstAttrList.size() ; i++){				
				setMap = (HashMap)stepInstAttrList.get(i);
				dataType = StringUtil.checkNull(setMap.get("DataType"));
				
				if(!dataType.equals("Text")){
					if(dataType.equals("MLOV")){
						String reqMLovValue[] =  StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode"))).split(",");
						Map delData = new HashMap();
						delData.put("instanceNo", ElmInstNo);
						delData.put("AttrTypeCode", setMap.get("AttrTypeCode"));
						commonService.delete("instance_SQL.delInstanceAttr", delData);
						
						for(int j=0; j<reqMLovValue.length; j++){
							mLovValue = reqMLovValue[j].toString();	
							setMap.put("instanceNo", ElmInstNo);
							setMap.put("instanceClass", instanceClass);		
							setMap.put("valu", mLovValue);										
							setMap.put("regTeamID", commandMap.get("sessionTeamId"));
							setMap.put("regUserID", commandMap.get("sessionUserId"));
							setMap.put("lastUserTeamID", commandMap.get("sessionTeamId"));
							setMap.put("lastUser", commandMap.get("sessionUserId"));
							
							setInfo = GetItemAttrList.procInstanceAttrUpdate(commonService, setMap);
						}	
					}else{
						setMap.put("instanceNo", ElmInstNo);
						setMap.put("instanceClass", instanceClass);		
						setMap.put("value", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()),"") );								
						setMap.put("regTeamID", commandMap.get("sessionTeamId"));
						setMap.put("regUserID", commandMap.get("sessionUserId"));
						setMap.put("lastUserTeamID", commandMap.get("sessionTeamId"));
						setMap.put("lastUser", commandMap.get("sessionUserId"));
						
						setInfo = GetItemAttrList.procInstanceAttrUpdate(commonService, setMap);
					}
				}else{
					setMap.put("instanceNo", ElmInstNo);
					setMap.put("instanceClass", instanceClass);						
					setMap.put("value", StringUtil.checkNull(commandMap.get(setMap.get("AttrTypeCode").toString()),"") );	
					setMap.put("regTeamID", commandMap.get("sessionTeamId"));
					setMap.put("regUserID", commandMap.get("sessionUserId"));
					setMap.put("lastUserTeamID", commandMap.get("sessionTeamId"));
					setMap.put("lastUser", commandMap.get("sessionUserId"));
					
					setInfo = GetItemAttrList.procInstanceAttrUpdate(commonService, setMap);
				}
			}
			
			target.put(AJAX_SCRIPT, "parent.selfClose();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}	
	
	@RequestMapping(value="/pim_SubInstanceList.do")
	public String pim_SubInstanceList(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "//app/pim//instance//pim_SubInstanceList";
		try {			
				Map setData = new HashMap();
				setData.put("category", "PROCSTS"); 
				setData.put("languageID", cmmMap.get("sessionCurrLangType")); 
				List instanceStatusList = commonService.selectList("common_SQL.getDictionary_commonSelect", setData);
				model.put("instanceStatusList", instanceStatusList);
			    model.put("menu", getLabel(request, commonService));	
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);		
	}
	
	@RequestMapping(value="/saveGridData.do")
	public String saveGridData(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{					
			String ids[] = request.getParameter("ids").split(",");
			Map setData = new HashMap();
			String gridStatus = "";
			String ProcInstNo = "";
			String procInstanceName = "";
			String startTime = "";
			String endTime = "";
			String status = "";
			String ownerID = "";
			String ownerTeamID = "";
			String chk = "";
			String processID = "";
			for(int i=0; i<ids.length; i++){
				// System.out.println("ids ["+i+"] :::> "+ids[i]+" Row ::::row status:"+request.getParameter(ids[i]+"_!nativeeditor_status") );
				gridStatus = StringUtil.checkNull(request.getParameter(ids[i]+"_!nativeeditor_status"),"");
				ProcInstNo = StringUtil.checkNull(request.getParameter(ids[i]+"_c1"),""); 
				procInstanceName = StringUtil.checkNull(request.getParameter(ids[i]+"_c2"),""); 
				startTime = StringUtil.checkNull(request.getParameter(ids[i]+"_c3"),"");
				endTime = StringUtil.checkNull(request.getParameter(ids[i]+"_c4"),"");
				status = StringUtil.checkNull(request.getParameter(ids[i]+"_c5"),"");
				ownerID = StringUtil.checkNull(request.getParameter(ids[i]+"_c8"),"");
				ownerTeamID = StringUtil.checkNull(request.getParameter(ids[i]+"_c9"),"");
				chk = StringUtil.checkNull(request.getParameter(ids[i]+"_c7"),"");
				processID = StringUtil.checkNull(request.getParameter(ids[i]+"_c10"),"");

				/*System.out.println("gridStatus :"+gridStatus+", ProcInstNo :"+ProcInstNo+", startTime: "+startTime+", endTime : "+endTime);
				System.out.println("status  : "+status+", ownerID : "+ownerID+", ownerTeamID :"+ownerTeamID+", chk :"+chk+" , processID :"+processID);*/
				
				if(gridStatus.equals("updated")){
					setData.put("ProcInstNo", ProcInstNo);
					setData.put("status", status);
					setData.put("startTime", startTime);
					setData.put("endTime", endTime);
					setData.put("ownerID", ownerID);
					setData.put("ownerTeamID", ownerTeamID);
					setData.put("lastUser", commandMap.get("sessionUserId"));
					setData.put("lastUserTeamID", commandMap.get("sessionTeamId"));
					commonService.update("instance_SQL.updateInstanceGridData", setData);
				
					if(!procInstanceName.equals("")){
						setData.put("attrTypeCode", "AT01001");
						setData.put("value", procInstanceName);
						setData.put("instanceNo", ProcInstNo);
						setData.put("instanceClass", "PROC");
						commonService.update("instance_SQL.updateInstanceAttr", setData);
					}
				}
			}
			//target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			//target.put(AJAX_SCRIPT, "parent.fnMyAction();parent.$('#isSubmit').remove();");
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
}
