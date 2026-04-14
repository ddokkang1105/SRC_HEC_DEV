package xbolt.app.pim.variant.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.ServletException;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.EmailUtil;
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
/**
 * 공통 서블릿 처리
 * @Class Name : VariantActionController.java
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
public class VariantActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "CSService")
	private CommonService CSService;
	
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;

	@Resource(name = "mdItemService")
	private CommonService mdItemService;
	
	@RequestMapping(value="/variantTreeMgt.do")
	public String variantTreeMgt(HttpServletRequest request, HashMap cmmMap,ModelMap model) throws Exception{
		String url = "/app/pim/variant/variantTreeMgt";
		try{
				String arcCode =  StringUtil.checkNull(cmmMap.get("arcCode"),"");
				String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
				String unfold = StringUtil.checkNull(cmmMap.get("unfold"));
				String arcDefPage = StringUtil.checkNull(cmmMap.get("arcDefPage"));
				String nodeID = StringUtil.checkNull(cmmMap.get("nodeID"));
				String masterProjectID = StringUtil.checkNull(cmmMap.get("projectID"));
				String variantClass = StringUtil.checkNull(cmmMap.get("variantClass"));
				String masterModelType = StringUtil.checkNull(cmmMap.get("masterModelType"));
				String refPGID = StringUtil.checkNull(cmmMap.get("refPGID"));
				String myProject = StringUtil.checkNull(cmmMap.get("myProject"));
				String gloProjectID = StringUtil.checkNull(request.getParameter("gloProjectID"));
				String focusedItemID = StringUtil.checkNull(request.getParameter("focusedItemID"));
				String variantProjectType = StringUtil.checkNull(request.getParameter("variantProjectType"));
				
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
				
				setData.put("arcCode", arcCode);
				Map arcFltClsMap = commonService.select("variant_SQL.getArcFilterClsInfo", setData);
				
				setData.put("arcFltClsCode", arcFltClsMap.get("ItemClassCode"));
				setData.put("arcFltClsName", arcFltClsMap.get("Name"));
				
				model.put("variantProjectType", variantProjectType);
				model.put("arcCode", arcCode);
				model.put("menuStyle", menuStyle);
				model.put("unfold", unfold);
				model.put("arcDefPage", arcDefPage);
				model.put("nodeID", nodeID);
				model.put("variantClass", variantClass);
				model.put("masterModelType", masterModelType);
				model.put("refPGID", refPGID);
				model.put("myProject", myProject);
				model.put("masterProjectID", masterProjectID);
				model.put("itemClassMenuURL", itemClassMenuURL);
				model.put("nodeID", nodeID);
				model.put("focusedItemID", focusedItemID);
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
				String filepath = request.getSession().getServletContext().getRealPath("/");
				/* xml 파일명 설정 */
				Calendar cal = Calendar.getInstance();
				java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
				java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("HHmmssSSS");
				String sdate = sdf.format(cal.getTime());
				String stime = sdf2.format(cal.getTime());
				String mkFileNm = sdate+stime;
				 
		        String xmlFilName = "upload/variantTree"+mkFileNm+".xml";
		        makeVariantTreeXML(filepath, topMenuList, menuList, xmlFilName, cmmMap, setData, request);
		        model.put("xmlFilName", xmlFilName);
				
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("VariantActionController::variantTreeMgt::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl(url);
	}
	
	private void makeVariantTreeXML(String filepath, List topTreeList, List treeList, String xmlFilName, HashMap cmmMap,Map setMap, HttpServletRequest request) throws ExceptionUtil {
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
				
    	        item2.setAttribute("id",  topTreeID + "_" + StringUtil.checkNull(setMap.get("arcFltClsCode")));
    	        item2.setAttribute("text", StringUtil.checkNull(setMap.get("arcFltClsName")));	
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
    	        
    	        // Variant FOLDER
    	        String variantClass =  StringUtil.checkNull(request.getParameter("variantClass"),"");
    	        String myProject =  StringUtil.checkNull(request.getParameter("myProject"),"");
    	        String pjtStatus =  StringUtil.checkNull(request.getParameter("pjtStatus"),"");
    	        setMap.put("typeCode", variantClass);
    	        String className = StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic", setMap));
    	        
    	        item2 = doc.createElement("item");	
    	        item2.setAttribute("im0", "icon_tree_variant3.gif");	
    	        item2.setAttribute("im1", "icon_tree_variant3.gif");	
    	        item2.setAttribute("im2", "icon_tree_variant3.gif");	
    	        item2.setAttribute("id", topTreeID+"_PJT" );
    	        item2.setAttribute("text", className );	
    	        item1.appendChild(item2);
    	        
    	        setMap.put("refItemID", StringUtil.checkNull(topTreeMap.get("TREE_ID")));
    	        setMap.put("classCode",  variantClass);
    	        setMap.put("myProject",  myProject);
    	        setMap.put("pjtStatus",  pjtStatus);
    	        setMap.put("sessionUserId", cmmMap.get("sessionUserId"));
    	        List variantMenuList = commonService.selectList("variant_SQL.getVariantTreeItemList", setMap);
    	        
    	        for(int m=0; m<variantMenuList.size(); m++){
    	        	Map variantMap = (Map)variantMenuList.get(m);
    	        	item3 = doc.createElement("item");				    	        	
    	        	item3.setAttribute("id", StringUtil.checkNull(variantMap.get("TREE_ID")));
    	        	item3.setAttribute("text", StringUtil.checkNull(variantMap.get("Identifier"))+" "+StringUtil.checkNull(variantMap.get("TREE_NM")));	
	    	        item2.appendChild(item3);
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
	

	@RequestMapping("/variantDetail.do")
	public String variantDetail(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception{
		try{
			Map getMap = new HashMap();
			Map variantInfo = new HashMap();
			String csrStatus = "";
			String issueStatus = "";
			
			// N-생성, R-조회, E-편집
			String pjtMode = StringUtil.checkNull(request.getParameter("pjtMode"),"R");
			
		//	String projectID = StringUtil.checkNull(commonService.selectString("variant_SQL.getVariantProjectID", commandMap));
			
			
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
		//	commandMap.put("projectType", "CSR");
			
			getMap = commonService.select("variant_SQL.getVariantProjectInfo", commandMap);
		//	variantInfo = commonService.select("variant_SQL.getVariantSubDes", commandMap); 
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("refID", StringUtil.checkNull(request.getParameter("refID")));
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("getMap", getMap);
		//	model.put("variantInfo", variantInfo);
			model.put("pjtMode", pjtMode);
			model.put("csrStatus", csrStatus);
			model.put("screenType", screenType);
		//	model.put("projectID", projectID);
			model.put("issueStatus", issueStatus);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/app/pim/variant/variantDetail");
	}
	

	@RequestMapping(value="/variantProjectList.do")
	public String variantProjectList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();	
		try {
			
			String varPjtType = StringUtil.checkNull(request.getParameter("variantProjectType"));
			
			
			if("CSR".equals(varPjtType))
				commandMap.put("category", "CSRSTS");
			else
				commandMap.put("category", "PJTSTS");
			
			List statusList = commonService.selectList("common_SQL.getDictionaryOrdStnm_commonSelect", commandMap);
			List teamList = commonService.selectList("variant_SQL.getVariantTeamList", commandMap);
			
			setMap.put("ITEM_ID", StringUtil.checkNull(request.getParameter("id")));
			
			Map itemInfo = commonService.select("item_SQL.selectItemInfo", setMap);
			setMap.put("projectID", itemInfo.get("ProjectID"));
			String refPjtID = commonService.selectString("project_SQL.getRefPjtID", setMap);
			
			String authorCnt = StringUtil.checkNull(commonService.selectString("variant_SQL.getVariantPGAuthorID", commandMap),"N");
			
			model.put("statusList", statusList);
			model.put("teamList", teamList);
			model.put("authorCnt", authorCnt);
			model.put("projectID", refPjtID);
			model.put("parentID", StringUtil.checkNull(commandMap.get("masterProjectID")));
			model.put("parentItemID", StringUtil.checkNull(request.getParameter("parentItemID")));
			model.put("variantClass", StringUtil.checkNull(commandMap.get("variantClass")));
			model.put("refPGID", StringUtil.checkNull(commandMap.get("refPGID")));
			model.put("myProject", StringUtil.checkNull(commandMap.get("myProject")));
			model.put("filter", StringUtil.checkNull(request.getParameter("filter"),"PJT"));
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("refID", StringUtil.checkNull(request.getParameter("projectID")));
			model.put("variantProjectType", StringUtil.checkNull(request.getParameter("variantProjectType")));
			model.put("mainVersion", StringUtil.checkNull(request.getParameter("mainVersion"),""));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		

		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/app/pim/variant/variantProjectList");
	}
	

	@RequestMapping("/registerVariantProject.do")
	public String registerVariantProject(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception{
		try{
			Map getMap = new HashMap();
			Map setData = new HashMap();
			String csrStatus = "";
			String issueStatus = "";
			
			// N-생성, R-조회, E-편집
			String pjtMode = StringUtil.checkNull(request.getParameter("pjtMode"));
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));

			setData.put("projectID", projectID);
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			String ProjectNM = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectName", setData));
			String ProjectPath = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectPath", setData));
			//
			//model.put("itemFiles", (List)commonService.selectList("variant_SQL.variantFile_selectList", commandMap));
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("refID", StringUtil.checkNull(request.getParameter("refID")));
			model.put("getMap", getMap);
			model.put("ProjectPath", ProjectPath+"/"+ProjectNM);
			model.put("ProjectNM", ProjectNM);
			model.put("variantClass", commandMap.get("variantClass"));
			model.put("variantPjtType", commandMap.get("variantPjtType"));
			model.put("projectID", projectID);
			model.put("parentItemID", commandMap.get("parentItemID"));
			model.put("parentID", commandMap.get("parentID"));
			model.put("refPGID", commandMap.get("refPGID"));
			model.put("projectCode", commandMap.get("projectCode"));
			model.put("pjtMode", pjtMode);
			model.put("csrStatus", csrStatus);
			model.put("screenType", screenType);
			model.put("issueStatus", issueStatus);
			model.put("myProject", StringUtil.checkNull(commandMap.get("myProject") ,""));
			model.put("s_itemID", StringUtil.checkNull(commandMap.get("s_itemID") ,""));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/app/pim/variant/registerVariantProject");
	}
	
	/**
	 * [신규 프로젝트 생성 & Edit]
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/saveVariantInfo.do")
	public String saveVariantInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws  ServletException, IOException, Exception {
		HashMap target = new HashMap();
		try {
	
			HashMap setData = new HashMap();
			HashMap setPjtMR = new HashMap();
			HashMap insertData = new HashMap();
			HashMap insertCSRData = new HashMap();
			HashMap varMap = new HashMap();
			Map parentInfoMap = new HashMap();

			String projectID =  StringUtil.checkNull(request.getParameter("projectID"));
			String parentItemID = StringUtil.checkNull(request.getParameter("parentItemID"));
			String variantClass = StringUtil.checkNull(request.getParameter("variantClass"));
			String projectCode = StringUtil.checkNull(request.getParameter("projectCode"));
			String variantPjtType = StringUtil.checkNull(request.getParameter("variantPjtType"),"");
			String AuthorID = StringUtil.checkNull(request.getParameter("AuthorID"),commandMap.get("sessionUserId").toString());
			String OwnerTeamID = StringUtil.checkNull(request.getParameter("OwnerTeamID"),commandMap.get("sessionTeamId").toString());
			String AuthorName = StringUtil.checkNull(request.getParameter("AuthorName"),commandMap.get("sessionUserNm").toString());
			String refPGID = StringUtil.checkNull(request.getParameter("refPGID"));
			
			String description = StringUtil.checkNull(request.getParameter("Description"));	
			String projectCsrId = "";

			setData.put("ProjectID", projectID);
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			parentInfoMap = commonService.select("project_SQL.getParentPjtInfo", setData);

			setData.put("projectID", projectID);
			String itemName = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectName", setData));
			
			// get Parent Project Info	
			/*

			String maxVarCode = StringUtil.checkNull(commonService.selectString("variant_SQL.getMaxVARCode", setData)).trim();			
			
			if(projectCode.equals("") && maxVarCode.equals("")){ 
				maxVarCode = "PJT#001";
			} else if(projectCode.equals("")) {
				maxVarCode = maxVarCode.replaceAll("PJT#", "");
				int curCSRCode = Integer.parseInt(maxVarCode) + 1;
				maxVarCode =  "PJT#" +  String.format("%03d",curCSRCode);			
			} else {
				maxVarCode = projectCode;
			}
			
			insertData.put("ProjectType", "PJT");
			insertData.put("Status", "OPN");
			insertData.put("UserID", commandMap.get("sessionUserId")); // Creator
			insertData.put("AuthorID", commandMap.get("sessionUserId")); // Creator
			insertData.put("AuthorName", commandMap.get("sessionUserNm")); // Creator	
			insertData.put("TeamID", commandMap.get("sessionTeamId")); // Creator TeamID
			insertData.put("ParentID", parentID);
			insertData.put("PJCategory", "VAR");
			insertData.put("StartDate", request.getParameter("StartDate"));
			insertData.put("DueDate", request.getParameter("DueDate"));
			insertData.put("TemplCode", parentInfoMap.get("TemplCode"));

			insertData.put("RefPGID", refPGID);
			insertData.put("RefPjtID", projectID);
			insertData.put("Priority", request.getParameter("Priority"));
			insertData.put("Reason", request.getParameter("Reason"));
			insertData.put("srID", StringUtil.checkNull(request.getParameter("srID")));
			insertData.put("AprvOption", parentInfoMap.get("AprvOption"));
			insertData.put("CompanyID", commandMap.get("sessionCompanyId"));
			insertData.put("Creator", commandMap.get("sessionUserId"));
			insertData.put("OwnerTeamID", commandMap.get("sessionTeamId"));
			
			insertData.put("ProjectCode", projectCode);
	
			insertData.put("ProjectID", projectID);
			
			commonService.insert("project_SQL.createProject", insertData);

			for (int i = 0; activatedLangList.size() > i; i++) {
				Map map = (Map) activatedLangList.get(i);
				String languageId = String.valueOf(map.get("CODE"));
				insertData.put("Name", request.getParameter("ProjectName"));
				insertData.put("languageID", languageId);
				insertData.put("Description",commandMap.get("ProjectName"));
				commonService.insert("project_SQL.createProjectTxt",insertData);
			}
			*/
		
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyMMdd").format(cal.getTime());
			setData.put("thisYmd", thisYmd);	
			String maxCSRCode = "";
			String curmaxCSRCode = StringUtil.checkNull(commonService.selectString("project_SQL.getMaxCSRCode", setData)).trim();				
			if(curmaxCSRCode.equals("")){ // 당일 CSR이 없으면
				maxCSRCode = "CSR"  + thisYmd + "0001";
			} else {
				curmaxCSRCode = curmaxCSRCode.substring(curmaxCSRCode.length() - 4, curmaxCSRCode.length());
				int curCSRCode = Integer.parseInt(curmaxCSRCode) + 1;
				maxCSRCode =  "CSR" +  thisYmd + String.format("%04d", curCSRCode);			
			}
			
			setData.put("ProjectID", projectID);
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			parentInfoMap = commonService.select("project_SQL.getParentPjtInfo", setData);
			
			/* CSR 신규 등록 */
			String status = "CSR";
			projectCsrId =  commonService.selectString("project_SQL.getMaxProjectID", commandMap);
			insertCSRData.put("ProjectType", "CSR");
			insertCSRData.put("Status", status);
			insertCSRData.put("UserID", AuthorID); // Creator
			insertCSRData.put("AuthorID", AuthorID); // Creator
			insertCSRData.put("AuthorName", AuthorName); // Creator	
			insertCSRData.put("TeamID", OwnerTeamID); // Creator TeamID
			insertCSRData.put("ParentID", projectID);
			insertCSRData.put("PJCategory", "VAR");
			insertCSRData.put("StartDate", request.getParameter("StartDate"));
			insertCSRData.put("DueDate", request.getParameter("DueDate"));
			insertCSRData.put("TemplCode", parentInfoMap.get("TemplCode"));

			insertCSRData.put("RefPGID", refPGID);
			insertCSRData.put("RefPjtID", projectID);
			insertCSRData.put("Priority", request.getParameter("Priority"));
			insertCSRData.put("Reason", request.getParameter("Reason"));
			insertCSRData.put("srID", StringUtil.checkNull(request.getParameter("srID")));
			insertCSRData.put("AprvOption", parentInfoMap.get("AprvOption"));
			insertCSRData.put("CompanyID", commandMap.get("sessionCompanyId"));
			insertCSRData.put("Creator", AuthorID);
			insertCSRData.put("OwnerTeamID", OwnerTeamID);
					
			insertCSRData.put("ProjectCode", maxCSRCode);
	
			insertCSRData.put("ProjectID", projectCsrId);
			
			commonService.insert("project_SQL.createProject", insertCSRData);

			List activatedLangList = commonService.selectList("common_SQL.langType_commonSelect", setData);
			for (int i = 0; activatedLangList.size() > i; i++) {
				Map map = (Map) activatedLangList.get(i);
				String languageId = String.valueOf(map.get("CODE"));
				insertCSRData.put("Name", request.getParameter("ProjectName"));
				insertCSRData.put("languageID", languageId);
				insertCSRData.put("Description",commandMap.get("ProjectName"));
				commonService.insert("project_SQL.createProjectTxt",insertCSRData);
			}		
			
			
			HashMap setCSMap = new HashMap();
			String itemID = commonService.selectString("item_SQL.getItemMaxID", setCSMap);
			varMap.put("variantClass", variantClass);
			String variantTypeCode = commonService.selectString("variant_SQL.getVariantTypeCode", varMap);
			
			
			HashMap inputData = new HashMap();
			inputData.put("CategoryCode", "OJ"); 
			inputData.put("ClassCode", variantClass);
			inputData.put("FromItemID", null);
			inputData.put("ToItemID", null); 
			inputData.put("ItemID", itemID);
			inputData.put("RefItemID", parentItemID);
			inputData.put("ItemTypeCode", variantTypeCode);
			inputData.put("Deleted", "0");
			inputData.put("Identifier", projectCode);
			inputData.put("ProjectID", projectCsrId);
			inputData.put("CompanyID", commandMap.get("sessionCompanyId"));
			inputData.put("Creator", AuthorID);
			inputData.put("LastUser", AuthorID);
			inputData.put("OwnerTeamId", OwnerTeamID);
			inputData.put("Status", "NEW1");
			commonService.insert("item_SQL.insertItem", inputData);
			
			inputData.put("languageID",  commandMap.get("sessionCurrLangType"));
			inputData.put("AttrTypeCode", "AT00001");
			inputData.put("PlainText", itemName);				
			commonService.insert("item_SQL.setItemAttr", inputData);	

			inputData.put("AttrTypeCode", "AT00003");
			inputData.put("PlainText", description);	
			commonService.insert("item_SQL.setItemAttr", inputData);				
			
			HashMap insertCngMap = new HashMap();
			/* Insert to TB_CHANGE_SET */
			insertCngMap.put("itemID", itemID);
			insertCngMap.put("userId", AuthorID);
			insertCngMap.put("projectID", projectCsrId);
			insertCngMap.put("classCode", "VCL0101");
			insertCngMap.put("KBN", "insertCNG");
			insertCngMap.put("status", "MOD");
			CSService.save(new ArrayList(), insertCngMap);
			/*
			 * 모델 복사 기능
			Map getModelMap = new HashMap();
			Map setModelMap = new HashMap();
			
			getModelMap.put("itemID", parentItemID);
			getModelMap = commonService.select("model_SQL.getModelIDFromItem",getModelMap);
			
			getModelMap.put("languageID", commandMap.get("sessionCurrLangType"));
			getModelMap.put("modelID", getModelMap.get("ModelID"));
			
			String modelNM = commonService.selectString("model_SQL.getModelNM",getModelMap);
			
			setModelMap.put("orgModelID", getModelMap.get("ModelID")); 
			setModelMap.put("newModelName", modelNM);
			setModelMap.put("newMTCTypeCode", getModelMap.get("ModelTypeCode"));
			setModelMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setModelMap.put("Creator", AuthorID);
			setModelMap.put("includeItemMaster", "Y");
			setModelMap.put("GUBUN","copy");
			mdItemService.save(setModelMap);
			*/
			
			
			/*
			 * 파일첨부 기능
			List fileList = new ArrayList();
			Map fileMap = null;
			Map getPath = new HashMap();
			Map stusMap = new HashMap();
			Map setFileMap = new HashMap();
			
			setFileMap.put("fltpCode", "PJTVAR");
			
			String filePath = StringUtil.checkNull(fileMgtService.selectString("fileMgt_SQL.getFilePath",setFileMap));  			
		
			String orginPath = GlobalVal.FILE_UPLOAD_ITEM_DIR + StringUtil.checkNull(commandMap.get("sessionUserId"))+"//";
			String targetPath = filePath;
			List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
			
			if(tmpFileList != null && !tmpFileList.isEmpty()){
				for(int i=0; i<tmpFileList.size();i++){
					
				   HashMap resultMap=(HashMap)tmpFileList.get(i);
				   fileMap = new HashMap();
				   int Seq = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", setFileMap));
				   
				   fileMap.put("Seq", Seq);
				   fileMap.put("DocumentID", itemID);
				   fileMap.put("LinkType", "OLM");
				   fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
				   fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
				   fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
				   fileMap.put("FilePath", resultMap.get(FileUtil.FILE_PATH));	
				   fileMap.put("FltpCode", "PJTVAR");
				   fileMap.put("FileMgt", "ITM");
				   fileMap.put("userId", commandMap.get("sessionUserId"));
				   fileMap.put("projectID", projectID);
				   fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
				   fileMap.put("KBN", "insert");
				   fileMap.put("DocCategory", "ITM");
				   fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");
				
				   fileList.add(fileMap);
				}
				
				fileMgtService.save(fileList, fileMap);
			}
			 */	
			
			/* 마스터 Item에 RefItemID를 자기 자신으로 설정 */
			Map setItemdata = new HashMap();
						
			setItemdata.put("itemID",parentItemID);
			
			commonService.update("variant_SQL.updateVariantMasterItemID", setItemdata);
			
			//Save PROC_LOG
			Map setProcMapRst = (Map)setProcLog(request, commonService, insertData);
			if(setProcMapRst.get("type").equals("FAILE")){
				String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
				System.out.println("Msg : "+Msg);
			}
			
			setData.put("ProjectID", projectID);
			setData.put("Status", "OPN");
			commonService.update("project_SQL.updateProject", setData);
			
			target.put(AJAX_SCRIPT, "parent.goProjectList();parent.$('#isSubmit').remove();");
			
		} catch (Exception e) {
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
	
		model.addAttribute(AJAX_RESULTMAP, target);
	
		return nextUrl(AJAXPAGE);
	}
	

	@RequestMapping(value="/setVariantTabMenu.do")
	public String setVariantTabMenu(ModelMap model,HashMap cmmMap)throws Exception{
		String url = "//subMenu//variantMenu";
		try {			
			String archiCode = StringUtil.checkNull(cmmMap.get("option"),"");
			String s_itemID = StringUtil.checkNull(cmmMap.get("id"),StringUtil.checkNull(cmmMap.get("s_itemID"),""));			
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
			getList = commonService.selectList("menu_SQL.getTabMenu", setMap);
			
			// [ClassCode]의 default Menu 취득
			if(getList.size() == 0){
				setMap.put("ArcCode", "AR000000");			
				getList = commonService.selectList("menu_SQL.getTabMenu", setMap);
			}	
			
			// default Menu 취득
			if(getList.size() == 0){
				setMap.put("ArcCode", "AR000000");	
				setMap.put("s_itemID", "null");
				setMap.put("ClassCode", "CL01000");	
				getList = commonService.selectList("menu_SQL.getTabMenu", setMap);
			}	
			
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
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url);		
	}	

	@RequestMapping("/variantProjectInfoview.do")
	public String variantProjectInfoview(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception{
		try{
			Map getMap = new HashMap();
			String isNew = "R";
			String isPjtMgt = StringUtil.checkNull(request.getParameter("isPjtMgt"));
			
			commandMap.put("s_itemID", request.getParameter("masterProjectID"));
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			getMap = commonService.select("project_SQL.getProjectInfoView", commandMap);
			
			
			model.put("getMap", getMap);
			model.put("isNew", isNew);
			model.put("isPjtMgt", isPjtMgt);
			model.put("s_itemID", StringUtil.checkNull(commandMap.get("s_itemID") ,""));
			model.put("category", StringUtil.checkNull(commandMap.get("category") ,""));			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/app/pim/variant/variantProjectInfoview");
	}

	@RequestMapping("/editVariantDetail.do")
	public String editVariantDetail(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception{
		try{
			Map getMap = new HashMap();
			Map variantInfo = new HashMap();
			String csrStatus = "";
			String issueStatus = "";
			
			// N-생성, R-조회, E-편집
			String pjtMode = StringUtil.checkNull(request.getParameter("pjtMode"),"E");
			
			String projectID = StringUtil.checkNull(commonService.selectString("variant_SQL.getVariantProjectID", commandMap));
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			commandMap.put("s_itemID", projectID);
			commandMap.put("projectType", "PJT");
			
			getMap = commonService.select("project_SQL.getProjectInfoView", commandMap);
			variantInfo = commonService.select("variant_SQL.getVariantSubDes", commandMap); 
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("refID", StringUtil.checkNull(request.getParameter("refID")));
			model.put("getMap", getMap);
			model.put("variantInfo", variantInfo);
			model.put("pjtMode", pjtMode);
			model.put("csrStatus", csrStatus);
			model.put("screenType", screenType);
			model.put("projectID", projectID);
			model.put("variantID", StringUtil.checkNull(request.getParameter("variantID")));
			model.put("issueStatus", issueStatus);
			model.put("s_itemID", StringUtil.checkNull(commandMap.get("s_itemID") ,""));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/app/pim/variant/editVariantDetail");
	}
	

	@RequestMapping(value="/editVariantInfo.do")
	public String editVariantInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws  ServletException, IOException, Exception {
		HashMap target = new HashMap();
		try {
	
			HashMap setData = new HashMap();
			HashMap setPjtMR = new HashMap();
			HashMap updateData = new HashMap();
			HashMap varMap = new HashMap();

			String ProjectID =  StringUtil.checkNull(request.getParameter("ProjectID"));
			String projectCode = StringUtil.checkNull(request.getParameter("ProjectCode"));
			String ProjectName = StringUtil.checkNull(request.getParameter("ProjectName"));
			String description = StringUtil.checkNull(request.getParameter("Description"));	
			String variantItemID = StringUtil.checkNull(request.getParameter("variantItemID"));	
			String Status = StringUtil.checkNull(request.getParameter("Status"));	
					
			
			updateData.put("Status", Status);
			updateData.put("StartDate", request.getParameter("StartDate"));
			updateData.put("DueDate", request.getParameter("DueDate"));
			updateData.put("ProjectCode", projectCode);
			updateData.put("ProjectID", ProjectID);
			
			commonService.update("project_SQL.updateProject", updateData);

			List activatedLangList = commonService.selectList("common_SQL.langType_commonSelect", setData);
			for (int i = 0; activatedLangList.size() > i; i++) {
				Map map = (Map) activatedLangList.get(i);
				String languageId = String.valueOf(map.get("CODE"));
				updateData.put("Name", request.getParameter("ProjectName"));
				updateData.put("languageID", languageId);
				updateData.put("Description",commandMap.get("ProjectName"));
				commonService.update("project_SQL.updateProjectTxt",updateData);
			}
			

			HashMap setCSMap = new HashMap();
			
			HashMap updData = new HashMap();
			updData.put("ItemID", variantItemID);
			updData.put("LastUser", commandMap.get("sessionUserId"));
			updData.put("Identifier", projectCode);
			
			commonService.update("item_SQL.updateItemObjectInfo", updData);

			updData.put("LanguageID",  commandMap.get("sessionCurrLangType"));
			updData.put("AttrTypeCode", "AT00001");
			updData.put("PlainText", ProjectName);				
			commonService.update("attr_SQL.setOccInfo", updData);	

			updData.put("AttrTypeCode", "AT00003");
			updData.put("PlainText", description);	
			commonService.update("attr_SQL.setOccInfo", updData);				
			
			//Save PROC_LOG
			Map setProcMapRst = (Map)setProcLog(request, commonService, updateData);
			if(setProcMapRst.get("type").equals("FAILE")){
				String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
				System.out.println("Msg : "+Msg);
			}
			
			target.put(AJAX_SCRIPT, "parent.goBack();parent.$('#isSubmit').remove();");
			
		} catch (Exception e) {
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
	
		model.addAttribute(AJAX_RESULTMAP, target);
	
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * csrList를 문자열로 return
	 * 
	 * @param parentInfoMap
	 * @return
	 * @throws Exception
	 */
	private String setCsrIds(List csrList) {
		String csrIds = "-1";
		for (int i = 0; i < csrList.size(); i++) {
			Map map = (Map) csrList.get(i);
			String csrId = StringUtil.checkNull(map.get("CODE"));
			
			if (csrIds.isEmpty()) {
				csrIds = csrId;
			} else {
				csrIds = csrIds + "," + csrId;
			}
		}
		
		return csrIds;
	}

	/**
	 * 동일 RefItemID  Variant list  
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/varItemList.do")
	public String itemConnection(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();	
		
		try {			
			String varFilter[] = StringUtil.checkNull(request.getParameter("varFilter")).split(",");
			
			String itemTypeCode = "";
			String mstSTR = "";	
			String elmCopyOption = "";
			if(varFilter.length > 0){
				itemTypeCode = StringUtil.checkNull(varFilter[0]);
				if(varFilter.length > 1){					
					mstSTR = StringUtil.checkNull(varFilter[1]);
					if(varFilter.length > 2){	
						elmCopyOption = StringUtil.checkNull(varFilter[2]);
					}
				}
			}
			
			/* 화면표시할 해당 아이템의 종속 아이템 리스트 취득 */
			setMap.put("itemTypeCode", itemTypeCode);
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List varItemList = commonService.selectList("variant_SQL.getVariantItems_gridList", setMap);
			
			// 프로젝트 리스트
			setMap.put("csrIds", setCsrIds(varItemList));
			List parentPjtList = commonService.selectList("project_SQL.getParentPjtOfCsr", setMap);
						
			/* 트리에서 선택한 아이템의 기본정보 취득 */
			// Map itemInfoMap = commonService.select("project_SQL.getItemInfo", setMap);
			Map itemInfoMap = commonService.select("item_SQL.getObjectInfo", setMap);
			
			/* 편집 가능여부 */
			model.put("selectedItemStatus", StringUtil.checkNull(itemInfoMap.get("Status")));
			model.put("selectedItemBlocked", StringUtil.checkNull(itemInfoMap.get("Blocked")));
						
			/* 선택된 아이템의 해당 CSR 리스트를 취득 */
			setMap.put("AuthorID", StringUtil.checkNull(itemInfoMap.get("AuthorID")));
			List returnData = commonService.selectList("project_SQL.getCsrListWithMember", setMap);
			model.put("csrOption", returnData);
			
			/* varfilter의 해당 계층리스트를 취득 */
			setMap.put("ItemTypeCode", itemTypeCode);
			setMap.remove("s_itemID");
			returnData = commonService.selectList("item_SQL.getClassOption", setMap);
			model.put("classOption", returnData);
			
			model.put("s_itemID", request.getParameter("s_itemID"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("itemTypeCode", itemTypeCode);
			model.put("varItemList", varItemList);
			model.put("parentPjtList", parentPjtList);
			
			model.put("screenMode", StringUtil.checkNull(request.getParameter("screenMode"), ""));
			model.put("attrDisplay", StringUtil.checkNull(request.getParameter("attrDisplay"), ""));
			model.put("option", request.getParameter("option"));
			model.put("itemInfoMap", itemInfoMap);
			
			setMap.put("itemID", request.getParameter("s_itemID"));
			model.put("fromItemID", StringUtil.checkNull(commonService.selectString("item_SQL.getFromItemID", setMap)));
			String modelID = StringUtil.checkNull(commonService.selectString("model_SQL.getModelIDFromItem", setMap));
			model.put("modelID", modelID);
			setMap.put("ModelID", modelID);
			Map modelInfo = commonService.select("model_SQL.getModel", setMap);
			model.put("modelInfo", modelInfo);
			
			/* setMap.put("itemClassCode", itemInfoMap.get("ClassCode"));
			String hasDimension =  StringUtil.checkNull(commonService.selectString("item_SQL.getHasDim", setMap));
			model.put("hasDimension", hasDimension); */
			model.put("mstSTR", mstSTR);
			model.put("elmCopyOption", elmCopyOption);
			model.put("varFilter", StringUtil.checkNull(request.getParameter("varFilter"), ""));
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("/app/pim/variant/varItemList");
	}
	
	@RequestMapping(value = "/delRefItems.do")
	public String delRefItems(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap target = new HashMap();
		HashMap setMap = new HashMap();
		try {
				String items[] = StringUtil.checkNull(request.getParameter("items"), "").split(",");
				setMap.put("LastUser", commandMap.get("sessionUserId"));
				setMap.put("deleted", 1);
				for(int i=0; i<items.length; i++){
					setMap.put("ItemID", items[i]);
					setMap.put("RefItemID", null);					
					commonService.update("item_SQL.updateItem", setMap);
				}
			
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
				target.put(AJAX_SCRIPT, "this.urlReload();this.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/createVariantItem.do")
	public String createVariantItem(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		HashMap target = new HashMap();
		Map insertCngMap = new HashMap();
		
		try {
		
			String newItemID = commonService.selectString("item_SQL.getItemMaxID", setMap);
			commandMap.put("ItemID", request.getParameter("s_itemID")); // tree에서 선택한 아이템의 ProjectID를 입력
			String projectID = commonService.selectString("project_SQL.getItemProjectId", commandMap);
			String curChangeSet = commonService.selectString("item_SQL.getItemCurChangeSet", commandMap);
			
			setMap.put("option", StringUtil.checkNull(request.getParameter("option")));
			setMap.put("Version", "1");
			setMap.put("Deleted", "0");
			setMap.put("Creator", StringUtil.checkNull(commandMap.get("sessionUserId")));
			setMap.put("ClassCode", StringUtil.checkNull(request.getParameter("classCode")));
			setMap.put("OwnerTeamId", StringUtil.checkNull(commandMap.get("sessionTeamId")));
			setMap.put("Identifier", StringUtil.checkNull(request.getParameter("identifier")));
			setMap.put("ItemID", newItemID);
			setMap.put("ItemTypeCode", StringUtil.checkNull(request.getParameter("itemTypeCode")));
			// [TB_ITEM_TYPE]에서 ItemTypeCode로 해당 CategoryCode취득
			setMap.put("CategoryCode", StringUtil.checkNull(commonService.selectString("item_SQL.getCategoryFromItemTypeCode", setMap)));
			setMap.put("AuthorID",  StringUtil.checkNull(commandMap.get("sessionUserId")));
			setMap.put("ProjectID", projectID);
			setMap.put("Status","NEW1");
			setMap.put("RefItemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			setMap.put("CurChangeSet", curChangeSet);
			commonService.insert("item_SQL.insertItem", setMap);
			
			// 새로운 아이템의 명칭 생성
			setMap.put("PlainText", StringUtil.checkNull(request.getParameter("itemName")));
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
				insertCngMap.put("userId", StringUtil.checkNull(commandMap.get("sessionUserId")));
				insertCngMap.put("projectID", projectID);
				insertCngMap.put("classCode", StringUtil.checkNull(request.getParameter("classCode")));
				insertCngMap.put("KBN", "insertCNG");
				insertCngMap.put("status", "MOD");
				CSService.save(new ArrayList(), insertCngMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "this.urlReload();this.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
}
