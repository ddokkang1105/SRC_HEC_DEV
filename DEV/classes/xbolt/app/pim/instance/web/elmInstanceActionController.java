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
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import xbolt.cmm.framework.filter.XSSRequestWrapper;
import xbolt.cmm.framework.handler.MessageHandler;
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
public class elmInstanceActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "fileMgtService")
	private CommonService fileMgtService;
	
	
	@RequestMapping(value="/viewElmInstList.do")
	public String pimElementList(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "/app/pim//instance/viewElmInstList";
		String instanceNo = StringUtil.checkNull(cmmMap.get("instanceNo"));
		String instanceClass = StringUtil.checkNull(cmmMap.get("instanceClass"));
		String nodeID = StringUtil.checkNull(cmmMap.get("processID"));
		String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
		String procModelID = StringUtil.checkNull(request.getParameter("procModelID"));
		try {
			Map setMap = new HashMap();
			setMap.put("s_itemID",  nodeID);
			setMap.put("MTCategory",  "BAS");
			setMap.put("languageID", languageID);
//			Map modelList = commonService.select("model_SQL.getModelList_gridList", setMap);
			
			setMap.put("instanceNo", instanceNo);
			setMap.put("instanceClass", instanceClass);
			Map procInstanceInfo = commonService.select("instance_SQL.getProcInstanceInfo", setMap);			
			model.put("procInstanceInfo", procInstanceInfo);	
			
			/* 기본정보 내용 취득 */
			List prcList = commonService.selectList("report_SQL.getItemInfo", setMap);
			Map prcMap = (Map) prcList.get(0);			
			model.put("prcMap",prcMap);
			
			model.put("procModelID",procModelID);
			model.put("instanceNo", instanceNo);
	        model.put("nodeID", nodeID);
	        model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);		
	}
	

	@RequestMapping(value="/editElmInstanceList.do")
	public String editElmInstanceList(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
		String url = "/app/pim//instance/editElmInstanceList";
		String instanceNo = StringUtil.checkNull(cmmMap.get("instanceNo"));
		String nodeID = StringUtil.checkNull(cmmMap.get("processID"));
		
		try {
			String filepath = request.getSession().getServletContext().getRealPath("/");
			model.put("instanceNo", instanceNo);
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			
			/* xml 파일명 설정 */
			String xmlFilName = "upload/editElmInstanceList.xml";
			
			setEditElmInstaceListXmlData(filepath, instanceNo, languageID, xmlFilName, request);
			
			model.put("xmlFilName", xmlFilName);
			model.put("nodeID", nodeID);
			model.put("procModelID", cmmMap.get("procModelID"));
			model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		
		return nextUrl(url);		
	}
	
	private void setEditElmInstaceListXmlData(String filepath, String instanceNo,  String languageID, String xmlFilName, HttpServletRequest request ) throws Exception {
		/* xml 파일 존재 할 경우 삭제 */
		File oldFile = new File(filepath + xmlFilName);
		if (oldFile.exists()) {
			oldFile.delete();
		}
		
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance(); 
		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		
		// 루트 엘리먼트 
		Document doc = docBuilder.newDocument(); 
		Element rootElement = doc.createElement("rows"); 
		doc.appendChild(rootElement); 
		
		Map setMap = new HashMap();
		Map elmInstStatusMap =  new HashMap();
		setMap.put("instanceNo", instanceNo);
		setMap.put("languageID", languageID);
		List elmInstList = commonService.selectList("instance_SQL.getElmInstList_gridList", setMap);
		setMap = new HashMap();
		setMap.put("languageID", languageID);
		setMap.put("category", "INSTSTS");
		List elmInstStatusList = commonService.selectList("common_SQL.getDictionaryOrdStnm_commonSelect", setMap);
		String elmInstStatusString = "";
		
		String HTML_IMG_DIR = GlobalVal.HTML_IMG_DIR;
		Element row, cell;
		String RNUM, procInstNo, elmItemID, elmInstNo, elmItemName, 
		actorID, actorTeamID, actorName, actorTeamName, roleID, roleName, projectCode, 
		startTime, dueDate, endTime, LastUpdated, CreationTime,Identifier,StatusNM,Status;
		
		Map elmInstMap;
		for (int i = 0; i < elmInstList.size(); i++) {
			row = doc.createElement("row"); 
			rootElement.appendChild(row); 
			
			cell = doc.createElement("cell");
			elmInstMap = (Map) elmInstList.get(i);
			RNUM = StringUtil.checkNull(elmInstMap.get("RNUM"));
			row.setAttribute("id", String.valueOf(RNUM));
			
			procInstNo = StringUtil.checkNull(elmInstMap.get("ProcInstNo"));
			elmItemID = StringUtil.checkNull(elmInstMap.get("ElmItemID"));
			projectCode = StringUtil.checkNull(elmInstMap.get("projectCode"));
			elmItemName = StringUtil.checkNull(elmInstMap.get("elmItemName"));
			elmInstNo = StringUtil.checkNull(elmInstMap.get("ElmInstNo"));
			roleID = StringUtil.checkNull(elmInstMap.get("RoleID"));
			roleName = StringUtil.checkNull(elmInstMap.get("roleName"));
			actorID = StringUtil.checkNull(elmInstMap.get("actorID"));
			actorName = StringUtil.checkNull(elmInstMap.get("actorName"));
			actorTeamID = StringUtil.checkNull(elmInstMap.get("actorTeamID"));
			actorTeamName = StringUtil.checkNull(elmInstMap.get("actorTeamName"));
			startTime = StringUtil.checkNull(elmInstMap.get("SchStartDate"));
			dueDate = StringUtil.checkNull(elmInstMap.get("DueDate"));
			endTime = StringUtil.checkNull(elmInstMap.get("endTime"));
			LastUpdated = StringUtil.checkNull(elmInstMap.get("LastUpdated"));
			CreationTime = StringUtil.checkNull(elmInstMap.get("CreationTime"));
			Identifier = StringUtil.checkNull(elmInstMap.get("Identifier"));
			StatusNM = StringUtil.checkNull(elmInstMap.get("StatusNM"));
			Status = StringUtil.checkNull(elmInstMap.get("Status"));
			
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(RNUM));
			row.appendChild(cell);    	        
			cell = doc.createElement("cell"); 
			if(!Status.equals("CLS")) {
				cell.appendChild(doc.createTextNode("0"));
			} else {
				cell.appendChild(doc.createTextNode(""));
			}
			row.appendChild(cell);
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(procInstNo));
			row.appendChild(cell);
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(elmItemID));
			row.appendChild(cell);
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(projectCode));
			row.appendChild(cell);
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(elmInstNo));
			row.appendChild(cell);    	        
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(Identifier));
			row.appendChild(cell);    	        
			cell = doc.createElement("cell"); 
			//cell.appendChild(doc.createTextNode(elmItemName));
			cell.appendChild(doc.createTextNode(elmItemName));
			row.appendChild(cell);
			cell = doc.createElement("cell"); 
			if(!Status.equals("CLS")) {
				cell.appendChild(doc.createTextNode("<span id=\"roletxt_"+RNUM+"\" style=\"display:none;\">"+roleName+"</span>"
						+ "<div id=\"roleDiv_"+RNUM+"\">"
						+ "<input type=\"text\" id=\"roleName_"+RNUM+"\" class=\"elmInstRole stext\" name=\"roleName_"+RNUM+"\" value=\""+roleName+"\" style=\"width: 86%;\"  onclick=fnAssignRole(\""+RNUM+"\") readonly/>"
						+ "<input type=\"image\" class=\"elmInstRole image\" src=\"/"+HTML_IMG_DIR+"/btn_icon_search.png\" onclick=fnAssignRole(\""+RNUM+"\") value=\"Edit\" />"
						+ "<input type=\"hidden\" class=\"elmInstRole\" name=\"roleID_"+RNUM+"\" id=\"roleID_"+RNUM+"\" value=\""+roleID+"\" />"
						+ "</div>"));
			} else {
				cell.appendChild(doc.createTextNode("<span id=\"roletxt_"+RNUM+"\">"+roleName+"</span>"
						+ "<div id=\"roleDiv_"+RNUM+"\" style=\"display:none;\">"
						+ "<input type=\"text\" id=\"roleName_"+RNUM+"\" class=\"elmInstRole stext\" name=\"roleName_"+RNUM+"\" value=\""+roleName+"\" style=\"width: 86%;\"  onclick=fnAssignRole(\""+RNUM+"\") readonly/>"
						+ "<input type=\"image\" class=\"elmInstRole image\" src=\"/"+HTML_IMG_DIR+"/btn_icon_search.png\" onclick=fnAssignRole(\""+RNUM+"\") value=\"Edit\" />"
						+ "<input type=\"hidden\" class=\"elmInstRole\" name=\"roleID_"+RNUM+"\" id=\"roleID_"+RNUM+"\" value=\""+roleID+"\" />"
						+ "</div>"));
			}
			row.appendChild(cell);    	        
			cell = doc.createElement("cell");
			if(!Status.equals("CLS")) {
				cell.appendChild(doc.createTextNode("<span id=\"actortxt_"+RNUM+"\" style=\"display:none;\">"+actorName+"</span>"
						+ "<div id=\"actorDiv_"+RNUM+"\">"
						+ "<input type=\"text\" id=\"actorName_"+RNUM+"\" class=\"stext\" name=\"actorName_"+RNUM+"\" value=\""+actorName+"\" style=\"width: 86%;\"  readonly/>"
						+ "<input type=\"image\" class=\"elmInstActor image\" src=\"/"+HTML_IMG_DIR+"/btn_icon_search.png\" onclick=fnAssignActor(\""+RNUM+"\") value=\"Edit\" />"
						+ "<input type=\"hidden\" name=\"actorID_"+RNUM+"\" id=\"actorID_"+RNUM+"\" value=\""+actorID+"\"/>"
						+ "</div>"));
			} else {
				cell.appendChild(doc.createTextNode("<span id=\"actortxt_"+RNUM+"\">"+actorName+"</span>"
						+ "<div id=\"actorDiv_"+RNUM+"\" style=\"display:none;\">"
						+ "<input type=\"text\" id=\"actorName_"+RNUM+"\" class=\"stext\" name=\"actorName_"+RNUM+"\" value=\""+actorName+"\" style=\"width: 86%;\"  readonly/>"
						+ "<input type=\"image\" class=\"elmInstActor image\" src=\"/"+HTML_IMG_DIR+"/btn_icon_search.png\" onclick=fnAssignActor(\""+RNUM+"\") value=\"Edit\" />"
						+ "<input type=\"hidden\" name=\"actorID_"+RNUM+"\" id=\"actorID_"+RNUM+"\" value=\""+actorID+"\"/>"
						+ "</div>"));
			}
			row.appendChild(cell);
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode("<span id=\"actorTeamName_"+RNUM+"\">"+actorTeamName+"</span><input type=\"hidden\" id=\"actorTeamID_"+RNUM+"\" class=\"actor\" name=\"actorTeamID_"+RNUM+"\" value=\""+actorTeamID+"\" />"));
			
			
			row.appendChild(cell);
			cell = doc.createElement("cell"); 
			//cell.appendChild(doc.createTextNode(StatusNM));
			elmInstStatusString = "<select id=\"status_"+RNUM+"\" class=\"status\" name=\"status_"+RNUM+"\">";
			elmInstStatusString += "<option value=\"\">select</option>";
			for(int elms=0; elms<elmInstStatusList.size(); elms++) {
				elmInstStatusMap = (Map) elmInstStatusList.get(elms);
				elmInstStatusString += "<option value=\""+elmInstStatusMap.get("CODE")+"\""+(Status.equals(elmInstStatusMap.get("CODE")) ? "SELECTED" : "")+">"+elmInstStatusMap.get("NAME")+"</option>";
			}
			elmInstStatusString += "</select>";
			elmInstStatusString += "<input type=\"hidden\" id=\"curStatus_"+RNUM+"\" value=\""+Status+"\"/>";
			cell.appendChild(doc.createTextNode(elmInstStatusString));
			
			row.appendChild(cell);    	  
			cell = doc.createElement("cell"); 
			if(!Status.equals("CLS")) {
				cell.appendChild(doc.createTextNode("<span id=\"schStartTimetxt_"+RNUM+"\" style=\"display:none;\">"+startTime+"</span>"
						+ "<div id=\"schStartTimeDiv_"+RNUM+"\">"
						+ "<input type=\"text\" class=\"stext schStartTime datePicker\" id=\"schStartTime_"+RNUM+"\" name=\"schStartTime_"+RNUM+"\" value=\""+startTime+"\" style=\"width: 80px;text-align: center;\"/>"
						+ "</div>"));
			} else {
				cell.appendChild(doc.createTextNode("<span id=\"schStartTimetxt_"+RNUM+"\">"+startTime+"</span>"
						+ "<div id=\"schStartTimeDiv_"+RNUM+"\" style=\"display:none;\">"
						+ "<input type=\"text\" class=\"stext schStartTime datePicker\" id=\"schStartTime_"+RNUM+"\" name=\"schStartTime_"+RNUM+"\" value=\""+startTime+"\" style=\"width: 80px;text-align: center;\"/>"
						+ "</div>"));
			}
			
			row.appendChild(cell);
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode("<input type=\"text\" class=\"stext endTime datePicker\" id=\"endTime_"+RNUM+"\" name=\"endTime_"+RNUM+"\" value=\""+endTime+"\" style=\"width: 80px;text-align: center;\"/>"));
			row.appendChild(cell);
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(CreationTime));
			row.appendChild(cell);
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(LastUpdated));
			row.appendChild(cell);
			
			cell = doc.createElement("cell");
			cell.appendChild(doc.createTextNode("<button type='button' class='gridBtn' onclick=fnelmInstaceSave('"+procInstNo+"','"+elmInstNo+"','"+elmItemID+"','"+RNUM+"');>save</button>"
					));
			row.appendChild(cell);
			cell = doc.createElement("cell"); 
			cell.appendChild(doc.createTextNode(Status));
			row.appendChild(cell);
		}
		
		TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
		Transformer transformer = transformerFactory.newTransformer(); 
		
		transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
		transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
		DOMSource source = new DOMSource(doc); 
		
		StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName))); 
		transformer.transform(source, result); 
	}
	
	@RequestMapping(value="/saveElmInst.do")
	public String saveElmInst(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		HashMap target = new HashMap();		
		try{					
			
			Map setData = new HashMap();
			String elmItemID = StringUtil.checkNull(request.getParameter("elmItemID"));
			String procInstNo = StringUtil.checkNull(request.getParameter("procInstNo"));
			String elmInstNo = StringUtil.checkNull(request.getParameter("elmInstNo"));
			String actorID = StringUtil.checkNull(request.getParameter("actorID"));
			String schStartDate = StringUtil.checkNull(request.getParameter("schStartDate"));
			String roleID =StringUtil.checkNull(request.getParameter("roleID"));
			String status = StringUtil.checkNull(request.getParameter("status"));
			
			setData.put("elmInstNo", elmInstNo);
			setData.put("elmItemID", elmItemID);
			setData.put("procInstNo", procInstNo);
			setData.put("schStartDate",schStartDate);
			setData.put("roleID", roleID);
			setData.put("useCaseID","");
			setData.put("status",status);
			setData.put("lastUser", commandMap.get("sessionUserId"));
			setData.put("lastUserTeamID", commandMap.get("sessionUserId"));
			commonService.update("instance_SQL.updateElmInst", setData);

			Map getMemberInfoMap = new HashMap();
			if(!actorID.equals("")) {
	 			String actorIDs[] = actorID.split(",");
	 			commonService.delete("worker_SQL.deletePimWorker",setData);
				for(int i=0; i<actorIDs.length; i++){
			 		setData.put("memberID", actorIDs[i]);
			 		setData.put("languageID", commandMap.get("sessionCurrLangType"));
					getMemberInfoMap = commonService.select("user_SQL.getMemberInfo", setData);
					
					if(getMemberInfoMap != null) {
						setData.put("workerNo", NextWokerNo());
						setData.put("workerTeamID", getMemberInfoMap.get("TeamID"));
						setData.put("procInstNo", procInstNo);
						setData.put("elmInstNo", elmInstNo);
						setData.put("roleID", roleID);
						setData.put("status", 1);
						setData.put("Creator", commandMap.get("sessionUserId"));
						setData.put("LastUser", commandMap.get("sessionUserId"));
						commonService.insert("worker_SQL.createPimWorker", setData);
					}
				}
			}
			
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
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
	
	@RequestMapping(value="/saveAllElmInst.do")
	public String saveAllElmInst(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();		
		Map setData = new HashMap();
		try{					
			
			String objIds[] = request.getParameter("objIds").split(",");
			String procInstNo = StringUtil.checkNull(request.getParameter("procInstNos"));
			String elmItemIDs[] = StringUtil.checkNull(request.getParameter("elmItemIDs")).split(",");
			String elmInstNos[] = StringUtil.checkNull(request.getParameter("elmInstNos")).split(",");
			String attrTypeCodes[] = StringUtil.checkNull(request.getParameter("attrTypeCodes")).split(",");
			String schStartDate, endTime, actorID, actorTeamID, elmItemName, roleID, status, attrTypeCode, documentNo;
			if(objIds.length > 0) {
				for(int i=0; i<objIds.length; i++){
					setData = new HashMap();
					schStartDate = StringUtil.checkNull(request.getParameter("schStartTime_"+objIds[i]));
//					endTime = StringUtil.checkNull(request.getParameter("endTime_"+objIds[i]));
					actorID = StringUtil.checkNull(request.getParameter("actorID_"+objIds[i]),"");
//					actorTeamID = StringUtil.checkNull(request.getParameter("actorTeamID_"+objIds[i]));
//					elmItemName = StringUtil.checkNull(request.getParameter("elmItemName_"+objIds[i]));
					roleID = StringUtil.checkNull(request.getParameter("roleID_"+objIds[i]),"");
					status = StringUtil.checkNull(request.getParameter("status_"+objIds[i]),"");
					documentNo = StringUtil.checkNull(request.getParameter("documentNo_"+objIds[i]),"");
					setData.put("procInstNo",procInstNo);
					
					if(elmItemIDs.length > 1) {
						setData.put("elmItemID",Integer.valueOf(elmItemIDs[i]));
					}
					setData.put("elmInstNo",elmInstNos[i]);

					setData.put("schStartDate",schStartDate);
//					setData.put("endTime",endTime);
//					setData.put("actorID",actorID);
//					setData.put("actorTeamID",actorTeamID);
//					setData.put("elmItemName",elmItemName);
					setData.put("roleID",roleID);
					setData.put("status",status);
					setData.put("documentNo",documentNo);
					setData.put("lastUser", commandMap.get("sessionUserId"));
					setData.put("lastUserTeamID", commandMap.get("sessionUserId"));
					setData.put("useCaseID","");
					commonService.update("instance_SQL.updateElmInst", setData);
//					commonService.update("instance_SQL.pimElementNameUpdate", setData);
					
					Map getMemberInfoMap = new HashMap();
			 		if(!actorID.equals("")) {
			 			String actorIDs[] = actorID.split(",");
			 			commonService.delete("worker_SQL.deletePimWorker",setData);
						for(int j=0; j<actorIDs.length; j++){
					 		setData.put("memberID", actorIDs[j]);
					 		setData.put("languageID", commandMap.get("sessionCurrLangType"));
							getMemberInfoMap = commonService.select("user_SQL.getMemberInfo", setData);
							
							if(getMemberInfoMap != null) {
								setData.put("workerNo", NextWokerNo());
								setData.put("workerTeamID", getMemberInfoMap.get("TeamID"));
								setData.put("elmInstNo", elmInstNos[i]);
								setData.put("status", 1);
								setData.put("Creator", commandMap.get("sessionUserId"));
								setData.put("LastUser", commandMap.get("sessionUserId"));
								commonService.insert("worker_SQL.createPimWorker", setData);
							}
						}
			 		}
			 		
			 		if(attrTypeCodes.length > 0) {
			 			for(int j=0; j<attrTypeCodes.length; j++){
				 			attrTypeCode = StringUtil.checkNull(request.getParameter(attrTypeCodes[j]+"_"+objIds[i]),"");
				 			
				 			setData.put("value", attrTypeCode);
				 			setData.put("instanceNo", elmInstNos[i]);
				 			setData.put("instanceClass", "ELM");
				 			setData.put("attrTypeCode", attrTypeCodes[j]);
				 			commonService.insert("instance_SQL.updateInstanceAttr", setData);
			 			}
			 		}
				}
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			}else {
				
			}

			target.put(AJAX_SCRIPT, "parent.goBack();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	

	@RequestMapping(value="/elmInstDetail.do")
	public String elmInstDetail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String url= "/app/pim/instance/elmInstDetail";
		
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
		//	setMap.put("instanceClass", "ELM");
			setMap.put("instanceNo", elmInstNo);
			returnData = (List)commonService.selectList("instance_SQL.getInstanceAttrText", setMap);

			setMap.put("defaultLang", defaultLang);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
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
	
	@RequestMapping(value="/elmInstFileList.do")
	public String pim_instanceFileList(HttpServletRequest request, HttpServletResponse response, HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
		String url = "/app/pim/file/elmInstFileList";
		String processID = StringUtil.checkNull(request.getParameter("processID"), "");
		String fileOption = StringUtil.checkNull(request.getParameter("fileOption"),"OLM");
		String varFilter = StringUtil.checkNull(request.getParameter("varFilter"));
		String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"),"");
		String instanceNo = StringUtil.checkNull(request.getParameter("instanceNo"), "");
		String elmItemID = StringUtil.checkNull(request.getParameter("elmItemID"), "");
		
		try {
			model.put("fileOption", fileOption);
			model.put("pageScale", GlobalVal.LIST_PAGE_SCALE);
			model.put("pageNum", request.getParameter("pageNum"));
			model.put("frmType", request.getParameter("frmType"));
			model.put("backBtnYN", request.getParameter("backBtnYN"));
			
			model.put("processID", processID);
			model.put("elmItemID", elmItemID);
			model.put("instanceNo", instanceNo);
			model.put("instanceClass", instanceClass);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/searchPjtNamePop.do")
	public String searchPjtNamePop(HttpServletRequest request, Map commandMap, ModelMap model)
			throws Exception {
		try {
				String searchKey = StringUtil.checkNull(request.getParameter("searchKey"),"");
				String searchValue = StringUtil.checkNull(request.getParameter("searchValue"),"");
				//String teamID = StringUtil.checkNull(request.getParameter("teamID"),"");
				String projectCode = StringUtil.checkNull(request.getParameter("projectCode"),"");
				
			if (!StringUtil.checkNull(request.getParameter("searchValue"), "").equals("") && !projectCode.equals("")) {
				
				model.put("searchKey", searchKey);
				model.put("searchValue", searchValue);
				//model.put("teamID", teamID);

				List getList = new ArrayList();
				Map getMap = new HashMap();

				getMap.put("searchKey", searchKey);
				getMap.put("searchValue", searchValue);
				getMap.put("languageID", commandMap.get("sessionCurrLangType"));
				getMap.put("UserLevel", request.getParameter("UserLevel"));
				//getMap.put("teamID", teamID);
				getMap.put("projectCode", projectCode);
								
				getList = commonService.selectList("project_SQL.searchPjtNamePop",getMap);

				model.put("getList", getList);
				Map firstRowData = new HashMap();
				if(getList.size() > 0){
					firstRowData = (Map)getList.get(0);
				}
				model.put("firstRowData", firstRowData);
				model.put("listSize", getList.size());
				
			}

			/* 작성자 팝업 창에서 선택된 user의 ID, Name을 설정할 window Object를 파라메터로 넘겨 받음 */
			model.put("projectCode", projectCode);
			model.put("objId", request.getParameter("objId"));
			model.put("objName", request.getParameter("objName"));
			model.put("UserLevel",  request.getParameter("UserLevel"));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e.toString());
		}

		return nextUrl("/popup/searchPjtNamePop");
	}
	
	// 외부시스템에서 OLM ProcInst 호출 
	@RequestMapping(value="/olmelmInstLink.do")
	public String olmelmInstLink(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		String url= "/app/pim/instance/elmInstDatail";
		
		try {

			String linkID = StringUtil.checkNull(request.getParameter("linkID"), "");
			String linkType = StringUtil.checkNull(request.getParameter("linkType"), ""); // id, code,		
			
			String archiCode = StringUtil.checkNull(cmmMap.get("option"),"");
			String ProcInstNo = "";
			String elmInstNo = linkID;	
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
		//	String instanceClass = StringUtil.checkNull(cmmMap.get("instanceClass"));
			String instanceNO = StringUtil.checkNull(request.getParameter("instanceNO"), "");
			
			Map setData = new HashMap();
			setData.put("instanceClass", "ELM");
			setData.put("languageID", languageID);
			//setData.put("instanceNo", ProcInstNo);
			setData.put("elmInstNo", elmInstNo);
						
			Map ElmInstMap = commonService.select("instance_SQL.getElmInstList_gridList", setData);
			ProcInstNo = StringUtil.checkNull(ElmInstMap.get("ProcInstNo"));
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
		//	setMap.put("instanceClass", "ELM");
			setMap.put("instanceNo", elmInstNo);
			returnData = (List)commonService.selectList("instance_SQL.getInstanceAttrText", setMap);

			setMap.put("defaultLang", defaultLang);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
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
			
			//Visit Log
			if(linkType.equals("id")){
				cmmMap.put("ItemId",elmItemID);
				cmmMap.put("instanceNo",instanceNO);
				cmmMap.put("ActionType","LINK");
				if( NumberUtil.isNumeric(elmItemID)) commonService.insert("gloval_SQL.insertVisitLog", cmmMap);
			}
			
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
		} catch(Exception e) {
			System.out.println(e.toString());
		}
		
		return nextUrl(url);
	}
	/*
	@RequestMapping(value="/olmelmInstLink.do")
	public String olmelmInstLink(HttpServletRequest request, ModelMap model,HashMap cmmMap)throws Exception{
		
		Map target = new HashMap();
		String url= "/app/pim/instance/elmInstDatail";
		
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
			String instanceNO = StringUtil.checkNull(request.getParameter("instanceNO"), "");
			
			String elmInstNo = linkID;
						
			Map setData = new HashMap();
			setData.put("instanceClass", "ELM");
			setData.put("languageID", languageID);
			setData.put("elmInstNo", elmInstNo);
			Map ElmInstMap = commonService.select("instance_SQL.getElmInstList_gridList", setData);
			model.put("ElmInstInfo", ElmInstMap);
			
			String elmItemID = StringUtil.checkNull(ElmInstMap.get("ElmItemID"));
			String procInstNo = StringUtil.checkNull(ElmInstMap.get("ProcInstNo"));
			setData.put("instanceNo", procInstNo);
			setData.put("elmInstNo", elmInstNo);
			setData.put("instanceClass", "PROC");
			Map procInstanceInfo = commonService.select("instance_SQL.getProcInstanceInfo", setData);			
			model.put("procInstanceInfo", procInstanceInfo);	
			
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setData);
			 속성 
			List attrList = new ArrayList();
			
			setData.put("defaultLang", defaultLang);
			setData.put("processID", elmItemID);
			setData.put("instanceNo", elmInstNo);
			setData.put("instanceClass", "ELM");
			
			*//** 첨부문서 *//*
			setData.put("isPublic", "N");
			List attachFileList = commonService.selectList("instanceFile_SQL.getInstanceFile", setData);
			model.put("attachFileList", attachFileList);
			
			//Visit Log
			if(linkType.equals("id")){
				cmmMap.put("ItemId",elmItemID);
				cmmMap.put("instanceNo",instanceNO);
				cmmMap.put("ActionType","LINK");
				if( NumberUtil.isNumeric(elmItemID)) commonService.insert("gloval_SQL.insertVisitLog", cmmMap);
			}
			
			model.put("variantClass", cmmMap.get("variantClass"));
			model.put("masterProjectID", cmmMap.get("masterProjectID"));
			model.put("myProject", cmmMap.get("myProject"));
			model.put("refPGID", cmmMap.get("refPGID"));
			model.put("elmInstNo", elmInstNo);
			model.put("elmItemID", elmItemID);
			model.put("level", (String)cmmMap.get("level"));
			model.put("menuText", StringUtil.checkNull(cmmMap.get("menuText")));
			
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
	*/	
		@RequestMapping(value = "/createElmInsthyModel.do")
		public String plm_newProcInst(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
			HashMap target = new HashMap();
			try {
				HashMap setMap = new HashMap();
				HashMap insertPjtInstData = new HashMap();
				HashMap insertElmInstData = new HashMap();
				
				String copyOption = StringUtil.checkNull(request.getParameter("copyOption"));
				String[] checkElmts = StringUtil.checkNull(request.getParameter("checkElmts")).split(",");

				String modelID = StringUtil.checkNull(request.getParameter("modelList"));
				String procInstNo = StringUtil.checkNull(request.getParameter("instanceNo"));
				
				String loginUserID = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String loginTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String Status = "WAT";
				
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
				insertElmInstData.put("status", Status);
				if(modelID != null && modelID != "") {
					if(elmList != null && !elmList.isEmpty()) {
						String maxElmInstID = "";
						for(int i=0; i<elmList.size(); i++) {
							Map tempMap = (Map)elmList.get(i);
							String objectID = StringUtil.checkNull(tempMap.get("ObjectID"));
							for(int j=0; j<checkElmts.length; j++) {
								String roleID = checkElmts[j].split("_")[0];
								String itemID = checkElmts[j].split("_")[1];
								if(objectID.equals(itemID)) {
									Date instStartTime = dateFormat.parse((String) procInfo.get("StartDate"));
									cal.setTime(instStartTime);
									
									maxElmInstID = commonService.selectString("instance_SQL.maxElmInstNo", setMap).trim();
									maxElmInstID = maxElmInstID.substring(maxElmInstID.length() - 5, maxElmInstID.length());
									int maxcode = Integer.parseInt(maxElmInstID) + 1;
									String newElmInstID = "E" + String.format("%09d", maxcode);
	
									setMap.put("languageID", languageID);
									setMap.put("s_itemID", itemID);
									setMap.put("defaultLang", defaultLang);
									
									insertElmInstData.remove("roleID");
									insertElmInstData.put("elmItemID", objectID);
									insertElmInstData.put("creator", loginUserID);
									
									insertElmInstData.put("newElmInstID", newElmInstID);
									insertElmInstData.put("sortNum", tempMap.get("SortNum"));
									insertElmInstData.put("roleID",roleID);
									
									setMap.put("ItemTypeCode", "CN00201");
									setMap.put("FromItemID", roleID);
									setMap.put("ToItemID", objectID);
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
									
									insertElmInstData.put("elementID",tempMap.get("ElementID"));
									
									commonService.insert("instance_SQL.insertElmInst", insertElmInstData);
									
									insertElmInstData.put("instanceNo", newElmInstID);
									insertElmInstData.put("instanceClass", "ELM");
									insertElmInstData.put("itemID", itemID);
									insertElmInstData.put("regTeamID", loginTeamID);
									insertElmInstData.put("regUserID", loginUserID);	
									insertElmInstData.put("lastUserTeamID", loginTeamID);
									insertElmInstData.put("lastUser", loginUserID);
									
									setMap.put("Mandatory", 1);
									setMap.remove("AttrTypeCode");
									// Mandatory Attr List
									List manAttrList = commonService.selectList("attr_SQL.getItemAttrMain", setMap);
									for(int k=0; k<manAttrList.size(); k++) {
										Map manAttr = (Map) manAttrList.get(k);
										insertElmInstData.put("attrTypeCode",  manAttr.get("AttrTypeCode"));
										insertElmInstData.put("value",  StringEscapeUtils.escapeHtml4(StringUtil.checkNull(manAttr.get("PlainText"))));
										commonService.insert("instance_SQL.insertInstanceAttr", insertElmInstData);
									}
								}
							}
						}
						
						Status = "OPN";
						insertElmInstData.put("status",Status);
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
		
		@RequestMapping(value="/elmInstAttr.do")
		public String updateElmInstAttr(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
			String url = "/app/pim/instance/elmInstAttr";
			Map setMap = new HashMap();
			Map attrMap = new HashMap();
			try{					
				String procInstNo = StringUtil.checkNull(request.getParameter("instanceNo"));
				String elmInstNo = StringUtil.checkNull(request.getParameter("elmInstNo"));
				//String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"));
				String scrnMode = StringUtil.checkNull(request.getParameter("scrnMode"),"V");
				String elmItemID = StringUtil.checkNull(request.getParameter("elmItemID"));
				String testCase = StringUtil.checkNull(request.getParameter("testCase"));
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
				String PlainText = "";
				
				setMap.put("instanceClass", "ELM");
				setMap.put("languageID", languageID);
				setMap.put("instanceNo", procInstNo);
				setMap.put("elmInstNo", elmInstNo);
				setMap.put("testCase", testCase);
							
				Map ElmInstMap = commonService.select("instance_SQL.getElmInstList_gridList", setMap);				
				
				/* 속성 */
				List attrList = new ArrayList();
				// isComLang = ALL
				setMap.put("itemID", ElmInstMap.get("ElmItemID"));
				setMap.put("instanceNo", elmInstNo);
				attrList = (List)commonService.selectList("instance_SQL.getInstanceAttrText", setMap);
				for(int i=0; i<attrList.size(); i++) {
					attrMap = new HashMap();
					PlainText = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(((Map)attrList.get(i)).get("PlainText")));
					((Map)attrList.get(i)).put("PlainText", PlainText);
				}				
				
				String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
				setMap.put("defaultLang", defaultLang);
				setMap.put("languageID", languageID);
				setMap.put("s_itemID", elmItemID);
				
				/* 기본정보 내용 취득 */
				Map prcInfo = commonService.select("report_SQL.getItemInfo", setMap);
				
				model.put("attrList",attrList);
				model.put("procInstNo",procInstNo);
				model.put("elmInstNo",elmInstNo);
				model.put("instanceClass","ELM");
				model.put("elmItemID",elmItemID);
				model.put("scrnMode",scrnMode);
				model.put("prcInfo",prcInfo);
				
			} catch(Exception e){
				System.out.println(e);
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl(url);
		}
		
		@RequestMapping(value="/updateElmInstAttr.do")
		public String saveObjectInfo(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{		
			Map target = new HashMap();
			Map setMap = new HashMap();
			try{
				String procInstNo = StringUtil.checkNull(request.getParameter("procInstNo"));
				String elmInstNo = StringUtil.checkNull(request.getParameter("elmInstNo"));
				String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"));
				String AT00008 = StringUtil.checkNull(request.getParameter("AT00008"));
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
				String loginUserID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
				String loginTeamID = StringUtil.checkNull(cmmMap.get("sessionTeamId"));
				
				setMap.put("value",AT00008);
				setMap.put("lastUser",loginUserID);
				setMap.put("lastUserTeamID",loginTeamID);
				setMap.put("instanceNo",elmInstNo);
				setMap.put("instanceClass",instanceClass);
				setMap.put("attrTypeCode","AT00008");
				
				commonService.update("instance_SQL.updateInstanceAttr", setMap);
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "parent.goBack();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");					
			} catch(Exception e){
				System.out.println(e);
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			}
			model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(AJAXPAGE);
		}
		
		@RequestMapping(value="/deleteElmInst.do")
		public String deleteElmInst(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{		
			Map target = new HashMap();
			Map setMap = new HashMap();
			try{
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
				String procInstNo = StringUtil.checkNull(request.getParameter("procInstNo"));
				String elmInstNos = StringUtil.checkNull(request.getParameter("elmInstNo"));
				setMap.put("languageID",languageID);
				setMap.put("instanceClass", "ELM");
				setMap.put("ProcInstNo",procInstNo);
				setMap.put("procInstNo",procInstNo);
				
				if(elmInstNos != "") {	//선택 삭제
					String elmInstNo[] = elmInstNos.split(",");
					for(int i=0; i<elmInstNo.length; i++) {
						setMap.put("instanceNo", elmInstNo[i]);
						commonService.delete("instance_SQL.delInstanceAttr", setMap);
						setMap.put("ElmInstNo", elmInstNo[i]);
						commonService.delete("worker_SQL.delWorkerMemberRel", setMap);
						setMap.put("elmInstNo", elmInstNo[i]);
						commonService.delete("instance_SQL.delElmInst", setMap);
					}
				} else {	// 전체 삭제
					List elmInstList = commonService.selectList("instance_SQL.getElmInstList", setMap);
					
					for(int i = 0; i < elmInstList.size(); i++) {
						Map elmInstMap = (Map) elmInstList.get(i);
						setMap.put("instanceNo", elmInstMap.get("ElmInstNo"));
						commonService.delete("instance_SQL.delInstanceAttr", setMap);
					}
					commonService.delete("worker_SQL.delWorkerMemberRel", setMap);
					commonService.delete("instance_SQL.delElmInst", setMap);

					setMap.put("status", "WAT");
					setMap.put("lastUser", cmmMap.get("sessionUserId"));
					setMap.put("ProcInstNo", procInstNo);
					commonService.update("instance_SQL.updateInstanceGridData", setMap);
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067"));
				target.put(AJAX_SCRIPT, "fnReload();parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");					
			} catch(Exception e){
				System.out.println(e);
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			}
			model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(AJAXPAGE);
		}
		

	    @RequestMapping("/InstanceFileList.do")
		public String InstanceFileList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
			String url = "/app/pim/file/InstanceFileList";
			Map setMap = new HashMap();
			List fileList = new ArrayList();
			try{
				String procInstNo = StringUtil.checkNull(request.getParameter("instanceNo"));
				String elmInstNo = StringUtil.checkNull(request.getParameter("elmInstNo"));
				String elmItemID = StringUtil.checkNull(request.getParameter("elmItemID"));
				String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"));
				
				setMap.put("elmInstNo", elmInstNo);
				setMap.put("elmItemID", elmItemID);
				setMap.put("languageID",StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				List fileList1 = commonService.selectList("instanceFile_SQL.getCxnItemFileList", setMap);		// FLTP별 샘플 파일
				
				setMap.put("instanceNo", elmInstNo);
				setMap.put("instanceClass", instanceClass);
				for(int i=0; i<fileList1.size(); i++){
					Map fileInfo = (Map) fileList1.get(i);
					setMap.put("refFileID",fileInfo.get("Seq"));
					Map instFlie = commonService.select("instanceFile_SQL.getInstanceFile", setMap);	// FLTP별 업로드 파일
					fileInfo.put("instFlie", instFlie);
					fileList.add(i, fileInfo);
				}
				
				setMap.put("procInstNo", procInstNo);
				setMap.put("MemberID", StringUtil.checkNull(commandMap.get("sessionUserId")));
				Map worker = commonService.select("worker_SQL.getPimWorkerList", setMap);
				if(worker.size() > 0) {
					model.put("uploadFlag", "T");
				}
				
				model.put("procInstNo", procInstNo);
				model.put("elmInstNo", elmInstNo);
				model.put("elmItemID", elmItemID);
				model.put("instanceClass", instanceClass);
				model.put("fileList",fileList);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
			} catch (Exception e) {
				System.out.println(e.toString());
			}
			return nextUrl(url);
		}
	    
	    @RequestMapping(value = "/addElmInstFilePop.do")
		public String addelmInstFilePop(HttpServletRequest request, ModelMap model) throws Exception {
			try{
				String seq = StringUtil.checkNull(request.getParameter("seq"));
				String elmInstNo = StringUtil.checkNull(request.getParameter("elmInstNo"));
				String elmItemID = StringUtil.checkNull(request.getParameter("elmItemID"));
				String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"));
				String FltpCode = StringUtil.checkNull(request.getParameter("FltpCode"));

				Map setMap = new HashMap();
				setMap.put("refFileID", seq);
				setMap.put("instanceNo", elmInstNo);
				setMap.put("instanceClass", instanceClass);
				Map fileInfo = commonService.select("instanceFile_SQL.getInstanceFile", setMap);
				
				model.put("elmInstNo", elmInstNo);
				model.put("elmItemID",elmItemID);
				model.put("instanceClass",instanceClass);
				model.put("seq",seq);
				model.put("FltpCode",FltpCode);
				model.put("Description",fileInfo.get("Description"));
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			} catch (Exception e){
				System.out.println(e);
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl("/app/pim/file/addElmInstFilePop");
		}
	    
	    @RequestMapping(value="/saveElmInstFile.do")
		public String saveScrFile(MultipartHttpServletRequest request,HashMap cmmMap, ModelMap model) throws  ServletException, IOException, Exception {
			Map target = new HashMap();
			XSSRequestWrapper xss = new XSSRequestWrapper(request);
			try{
				for (Iterator i = cmmMap.entrySet().iterator(); i.hasNext();) {
				    Entry e = (Entry) i.next(); // not allowed
				    if(!e.getKey().equals("loginInfo") && e.getValue() != null) {
				    	cmmMap.put(e.getKey(), xss.stripXSS(e.getValue().toString()));
				    }
				}
				
				String refFileID = StringUtil.checkNull(xss.getParameter("refFileID"), "");
				String elmInstNo = StringUtil.checkNull(request.getParameter("elmInstNo"));
				String elmItemID = StringUtil.checkNull(request.getParameter("elmItemID"));
				String FltpCode = StringUtil.checkNull(request.getParameter("FltpCode"));
				String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"));
				String userId = StringUtil.checkNull(StringUtil.checkNull(cmmMap.get("sessionUserId")), "");				String comment = StringUtil.checkNull(xss.getParameter("comment"));
				
				List fileList = new ArrayList();
				Map fileMap = new HashMap();
				Map setMap = new HashMap();
				setMap.put("fltpCode",FltpCode);
				String filePath = StringUtil.checkNull(fileMgtService.selectString("fileMgt_SQL.getFilePath",setMap));
				File dirFile = new File(filePath);if(!dirFile.exists()) { dirFile.mkdirs();} 
				

				setMap.put("refFileID",refFileID);
				setMap.put("instanceNo",elmInstNo);
				setMap.put("instanceClass",instanceClass);
				Map fileList2 = commonService.select("instanceFile_SQL.getInstanceFile", setMap);
				String fileID = StringUtil.checkNull(fileList2.get("FileID"));
				
				if("".equals(fileID)){ // 신규 등록
					Iterator fileNameIter = request.getFileNames();
					String savePath = filePath; // 폴더 바꾸기				
					String fileName = "";
					int Seq = Integer.parseInt(commonService.selectString("instanceFile_SQL.getInstancFileID", cmmMap));
					int seqCnt = 0;
					
					while (fileNameIter.hasNext()) {
					   MultipartFile mFile = request.getFile((String)fileNameIter.next());
					   fileName = mFile.getName();
					   
					   if (mFile.getSize() > 0) {						   
						   fileMap = new HashMap();
						   HashMap resultMap = FileUtil.uploadFile(mFile, savePath, true);
						   
						   fileMap.put("fileID", Seq);
						   fileMap.put("refFileID", refFileID);
						   fileMap.put("FltpCode", FltpCode);
						   fileMap.put("instanceClass", instanceClass);
						   fileMap.put("instanceNo", elmInstNo);
						   fileMap.put("itemID", elmItemID);
						   //fileMap.put("linkType", linkType);
						   fileMap.put("fileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
						   fileMap.put("fileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
						   fileMap.put("fileSize", resultMap.get(FileUtil.FILE_SIZE));
						   //fileMap.put("fileMgt", fileMgt);
						   //fileMap.put("fileFormat", fileFormat);
						   fileMap.put("userId", userId);
						   fileMap.put("Description", comment);
						   fileMap.put("filePath", resultMap.get(FileUtil.FILE_PATH));	
						   fileMap.put("languageID", cmmMap.get("sessionCurrLangType"));
						   fileMap.put("KBN", "insert");
						   fileMap.put("SQLNAME", "instanceFile_SQL.insertInstanceFile");
						   fileList.add(fileMap);
						   seqCnt++;
					   }
					}	
					fileMgtService.save(fileList, fileMap);
				} else{ // 파일 수정
					//기존파일 삭제 
					String sysfile = StringUtil.checkNull(fileList2.get("SysFile"));
					File existFile = new File(sysfile); 
					if(existFile.isFile() && existFile.exists()){existFile.delete();}
					
					
					Iterator fileNameIter = request.getFileNames();
					String savePath = filePath;
					String fileName = "";
					int Seq = Integer.parseInt(fileID);
					int seqCnt = 0;
					
					while (fileNameIter.hasNext()) {
					   MultipartFile mFile = request.getFile((String)fileNameIter.next());
					   fileName = mFile.getName();					
					   
					   if (mFile.getSize() > 0) {						   
						   fileMap = new HashMap();
						   HashMap resultMap = FileUtil.uploadFile(mFile, savePath, true);					
						   
						   fileMap.put("fileID", Seq);
						   fileMap.put("refFileID", refFileID);
						   fileMap.put("FltpCode", FltpCode);
						   fileMap.put("instanceClass", instanceClass);
						   fileMap.put("instanceNo", elmInstNo);
						   fileMap.put("itemID", elmItemID);
						   //fileMap.put("linkType", linkType);
						   fileMap.put("fileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
						   fileMap.put("fileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
						   fileMap.put("fileSize", resultMap.get(FileUtil.FILE_SIZE));
						   //fileMap.put("fileMgt", fileMgt);
						   //fileMap.put("fileFormat", fileFormat);
						   fileMap.put("userId", userId);
						   fileMap.put("Description", comment);
						   fileMap.put("filePath", resultMap.get(FileUtil.FILE_PATH));	
						   fileMap.put("languageID", cmmMap.get("sessionCurrLangType"));
						   fileMap.put("KBN", "update");
						   fileMap.put("SQLNAME", "instanceFile_SQL.updateInstanceFile");
						   fileList.add(fileMap);
						   seqCnt++;
					   }
					}	
						fileMgtService.save(fileList, fileMap);
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				target.put(AJAX_SCRIPT,  "parent.selfClose();parent.$('#isSubmit').remove();");
			}catch (Exception e) {
				System.out.println(e);
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			}
			model.addAttribute(AJAX_RESULTMAP, target);	
			return nextUrl(AJAXPAGE);
		}
	    
	    @RequestMapping(value="/instfileDelete.do")
		public String instfileDelete(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
			Map map = new HashMap();
			map.put("fileID", request.getParameter("fileID"));			
			Map target = commonService.select("instanceFile_SQL.selectDownInstanceFile", map);	//new mode

			try {
				String realFile = StringUtil.checkNull(target.get("downFile"), "");
				if(realFile.length() > 0){
					File existFile = new File(realFile);
					existFile.delete();
				}
				commonService.delete("instanceFile_SQL.deleteInstanceFile", map);	//new mode

				//target.put(AJAX_ALERT, "파일 삭제가 성공하였습니다.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00075")); // 성공
				target.put(AJAX_SCRIPT,  "fnCallBack();$('#isSubmit').remove();");
			}
			catch (Exception e) {
				System.out.println(e);
				//target.put(AJAX_ALERT, "파일 삭제중 오류가 발생하였습니다.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00076")); // 오류
			}
			model.addAttribute(AJAX_RESULTMAP, target);

			return nextUrl(AJAXPAGE);
		}
	    
	    @RequestMapping(value="/elmInstPopupMaster.do")
			public String elmPopupMaster(HttpServletRequest request, ModelMap model, HashMap cmmMap)throws Exception{
				String url = "/app/pim//instance/elmInstPopupMaster";
				
				try {
					Map setData = new HashMap();
					String procInstNo = StringUtil.checkNull(request.getParameter("procInstNo"), "");
					String elmInstNo = StringUtil.checkNull(request.getParameter("elmInstNo"), "");
					String instanceClass = StringUtil.checkNull(request.getParameter("instanceClass"), "");
					
					setData.put("procInstNo", procInstNo);
					setData.put("elmInstNo", elmInstNo);
				    String elmTypeCode = StringUtil.checkNull(commonService.selectString("instance_SQL.getElmTypeCode", setData));
					
					String elmInstUrl = "";
					if(elmTypeCode.equals("PTC")){
						elmInstUrl = "viewTODetail.do";
					}else{
						elmInstUrl = "elmInstDetail.do";
					}
					
					model.put("elmInstUrl", elmInstUrl);
					model.put("procInstNo", procInstNo);
					model.put("elmInstNo", elmInstNo);
					model.put("instanceClass", instanceClass);
					
			        model.put("menu", getLabel(request, commonService));
				} catch (Exception e) {
					System.out.println(e.toString());
				}
				return nextUrl(url);		
			}
}
