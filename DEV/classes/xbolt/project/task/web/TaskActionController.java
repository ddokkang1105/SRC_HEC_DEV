package xbolt.project.task.web;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.org.json.JSONArray;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.FileUtil;
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
public class TaskActionController extends XboltController {

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "taskService")
	private CommonService taskService;

	// 프로세스 - 관련 프로세스 Tree List
	@RequestMapping(value = "/taskMgt.do")
	public String taskMgt(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/project/task/taskMgt";
		try {
				HashMap setMap = new HashMap();	
				List taskTypeList = new ArrayList();
				
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),request.getParameter("languageID")); 
				String itemID = StringUtil.checkNull(cmmMap.get("s_itemID"),request.getParameter("itemID")); 
			
				setMap.put("languageID", languageID);
				setMap.put("itemID", itemID);
				Map csrInfo = commonService.select("task_SQL.getCsrInfo", setMap);
				taskTypeList = commonService.selectList("task_SQL.getTaskTypeList", setMap);
				
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("itemID", itemID);
				model.put("csrInfo", csrInfo);
				model.put("taskTypeList", taskTypeList);
				model.put("isFromMain", StringUtil.checkNull(request.getParameter("isFromMain")));
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/getTaskMgtFromObjHistory.do")
	public String getTaskMgtFromObjHistory(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/project/task/taskMgt";
		try {
				HashMap setMap = new HashMap();	
				
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),request.getParameter("languageID")); 
				String cngtId = StringUtil.checkNull(request.getParameter("cngtId")); 
				String isFromMain = StringUtil.checkNull(request.getParameter("isFromMain")); 
			
				setMap.put("languageID", languageID);
				setMap.put("cngtId", cngtId);
				Map csrInfo = commonService.select("task_SQL.getCsrInfo", setMap);
				
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("csrInfo", csrInfo);
				model.put("itemID",  csrInfo.get("ItemID"));
				model.put("isFromMain", isFromMain);
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/taskPlan.do")
	public String taskPlan(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/project/task/taskPlan";
		try {
				HashMap setMap = new HashMap();	
				List taskList = new ArrayList();
				Map taskMap = new HashMap();	
				
				String taskType = StringUtil.checkNull(request.getParameter("taskType"), "");
				String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
				String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
				String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
				String csrAuthorID = StringUtil.checkNull(request.getParameter("csrAuthorID"), "");
				String curTask = StringUtil.checkNull(request.getParameter("curTask"), "");
				String csrStatus = StringUtil.checkNull(request.getParameter("csrStatus"), "");
				String parentID = StringUtil.checkNull(request.getParameter("parentID"), "");
				
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				setMap.put("changeSetID", changeSetID);
				setMap.put("itemID", itemID);
				setMap.put("projectID", projectID);
				setMap.put("parentID", parentID);
				
				taskList = commonService.selectList("task_SQL.getTaskList", setMap);
				model.put("actorYN", "N");
				if(taskList.size() != 0){
					for (int i = 0; i < taskList.size(); i++) {						
						taskMap = (Map)taskList.get(i);
						if(cmmMap.get("sessionUserId").equals(taskMap.get("ActorP"))){
							model.put("actorYN", "Y");							
						}
					}
				}
				JSONArray taskListtData = new JSONArray(taskList);
				model.put("taskListtData", taskListtData);
				model.put("tskCnt", taskList.size());

				List taskAuthorList = commonService.selectList("task_SQL.getPjtMemberList_gridList", setMap);
				JSONArray taskAuthorData = new JSONArray(taskAuthorList);
				model.put("taskAuthorData", taskAuthorData);
				
				model.put("taskAuthorList", taskAuthorList);
				model.put("itemID", itemID);
				model.put("changeSetID", changeSetID);
				model.put("projectID", projectID);
				
				model.put("taskType", taskType);
				model.put("csrAuthorID", csrAuthorID);
				
				model.put("curTask", curTask);
				model.put("csrStatus", csrStatus);
				model.put("parentID", parentID);
				model.put("filePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/taskDeliverables.do")
	public String taskDeliverables(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/project/task/taskDeliverables";
		try {
				HashMap setMap = new HashMap();	
				List getTaskFileList = new ArrayList();
				List actorList = new ArrayList();	
				Map actorMap = new HashMap();
				
				String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
				String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
				String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
				String parentID = StringUtil.checkNull(request.getParameter("parentID"), "");
				String csrAuthorID = StringUtil.checkNull(request.getParameter("csrAuthorID"), "");
				String csrStatus = StringUtil.checkNull(request.getParameter("csrStatus"), "");
				
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				setMap.put("projectID", projectID);
				setMap.put("itemID", itemID);
				setMap.put("parentID", parentID);
				setMap.put("changeSetID", changeSetID);
				setMap.put("htmlImgDir", "/"+GlobalVal.HTML_IMG_DIR+"/");
				getTaskFileList = commonService.selectList("task_SQL.getTaskItemFileList", setMap);
				JSONArray taskFileList = new JSONArray(getTaskFileList);

				model.put("actorYN", "N");
				actorList = commonService.selectList("task_SQL.getActorList", setMap);

				if(actorList.size() > 0){
					for (int i = 0; i < actorList.size(); i++) {		
						actorMap = (Map)actorList.get(i);
						if(cmmMap.get("sessionUserId").equals(actorMap.get("Actor"))){
							model.put("actorYN", "Y");							
						}
					}
				}
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("itemID", itemID);
				model.put("changeSetID", changeSetID);
				model.put("projectID", projectID);
				model.put("parentID", parentID);
				model.put("taskFileList", taskFileList);
				model.put("filePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
				model.put("csrAuthorID", csrAuthorID);
				model.put("csrStatus", csrStatus);
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/selectTskAuthor.do")
	public String selectTskAuthor(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/project/task/selectTaskAuthor";
		try {
				String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
				
				model.put("projectID", projectID);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/editTask.do")
	public String editTask(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		String url = "/project/task/taskEdit";
		try {
				List taskList = new ArrayList();
				List taskAuthorList = new ArrayList();
				HashMap setMap = new HashMap();	
				Map taskMap = new HashMap();	
				
				String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
				String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
				String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
				String category = StringUtil.checkNull(request.getParameter("category"), ""); 
				String categoryName = StringUtil.checkNull(request.getParameter("categoryName"), ""); 
				String csrAuthorID = StringUtil.checkNull(request.getParameter("csrAuthorID"), ""); 
				String parentID = StringUtil.checkNull(request.getParameter("parentID"), ""); 
				String curTask = StringUtil.checkNull(request.getParameter("curTask"), ""); 
				String csrStatus = StringUtil.checkNull(request.getParameter("csrStatus"), ""); 
				
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				setMap.put("changeSetID", changeSetID);
				setMap.put("itemID", itemID);
				setMap.put("category", category);
				setMap.put("projectID", projectID);
				setMap.put("parentID", parentID);
				taskList = commonService.selectList("task_SQL.getTaskEditList", setMap);
				taskAuthorList = commonService.selectList("task_SQL.getPjtMemberList_gridList", setMap);
				String taskIDCnt = commonService.selectString("task_SQL.getTaskCnt", setMap);
				String taskTypeCodeArr = "";
				String isEndDate = "Y";
				String endDate = "";
				for (int i = 0; i < taskList.size(); i++) {						
					taskMap = (Map)taskList.get(i);
					if(i == 0){
						taskTypeCodeArr = String.valueOf(taskMap.get("TaskTypeCode"));
					}else{
						taskTypeCodeArr = taskTypeCodeArr +","+String.valueOf(taskMap.get("TaskTypeCode"));
					}
					endDate = String.valueOf(taskMap.get("EndDate"));
					if(endDate.equals("")){
						isEndDate = "N";
					}
				}
				
				model.put("isEndDate",isEndDate);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("changeSetID", changeSetID);
				model.put("itemID", itemID);
				model.put("taskList", taskList);
				model.put("taskAuthorList", taskAuthorList);
				model.put("projectID", projectID);
				model.put("tskCnt", taskList.size());
				model.put("category", category);
				model.put("categoryName", categoryName);
				model.put("csrAuthorID", csrAuthorID);
				model.put("taskTypeCodeArr", taskTypeCodeArr);
				model.put("parentID", parentID);
				model.put("curTask", curTask);
				model.put("csrStatus", csrStatus);
				model.put("taskIDCnt", taskIDCnt);
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	/*
	@RequestMapping(value = "/saveTask.do")
	public String saveTask(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		List taskTypeList = new ArrayList();
		Map taskMap = new HashMap();
		try {				
				String curTask =StringUtil.checkNull(request.getParameter("curTask"), "");
				String csrStatus =StringUtil.checkNull(request.getParameter("csrStatus"), "");
				String taskID = "";
				String reqTaskID = "";
				String seq = "";
				String taskTypeCode = "";
				String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
				String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
				String category = StringUtil.checkNull(request.getParameter("category"), "");
				String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
				String parentID = StringUtil.checkNull(request.getParameter("parentID"), "");
				String confirmed = "";
				
				setMap.put("parentID", parentID);
				setMap.put("projectID", projectID);
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				taskTypeList = commonService.selectList("task_SQL.getTaskTypeList", setMap);
				
				// 입력값
				String teamID = "";
				String actor = "";
				String startDate = "";
				String endDate = "";
				String manday = "";
				String memberID = "";
				
				setMap.put("curTask", curTask);
				setMap.put("changeSetID", changeSetID);
				setMap.put("itemID", itemID);
				String getTaskID = "";
				for (int i = 0; i < taskTypeList.size(); i++) {						
					taskMap = (Map)taskTypeList.get(i);
					taskTypeCode = String.valueOf(taskMap.get("TaskTypeCode"));
					teamID = StringUtil.checkNull(request.getParameter("teamID"+taskTypeCode), "");					
					actor =  StringUtil.checkNull(request.getParameter("actor"+taskTypeCode), "");
					startDate =  StringUtil.checkNull(request.getParameter("startDate"+taskTypeCode), "");
					endDate =  StringUtil.checkNull(request.getParameter("endDate"+taskTypeCode), "");
					manday =  StringUtil.checkNull(request.getParameter("manday"+taskTypeCode), "");
					memberID =  StringUtil.checkNull(request.getParameter("memberID"+taskTypeCode), "");
					reqTaskID =  StringUtil.checkNull(request.getParameter("taskID"+taskTypeCode), "");
					
					if(reqTaskID.equals("")){// taskId 유무체크
						Map getMap = new HashMap();
						getMap.put("category", category);
						getMap.put("changeSetID", changeSetID);
						getMap.put("taskTypeCode", taskTypeCode);
						getMap.put("itemID", itemID);
						reqTaskID = StringUtil.checkNull(commonService.selectString("task_SQL.getTaskID",getMap),"");
					}
					
					if(!memberID.equals("") && (!startDate.equals("") || !endDate.equals("")) ){
						if(category.equals("A")){	curTask = taskTypeCode;  } // last Task 						
						
						if(reqTaskID.equals("")){ // NEW
							taskID =  taskService.selectString("task_SQL.getMaxTaskID",setMap);
							seq =  taskService.selectString("task_SQL.getMaxTaskSeq",setMap);
							
							setMap.put("taskTypeCode", taskTypeCode);
							setMap.put("teamID", teamID);
							setMap.put("taskID", taskID);
							setMap.put("seq", seq);
							setMap.put("changeSetID", changeSetID);
							setMap.put("category", category);
							setMap.put("actor", memberID); 
							setMap.put("startDate", startDate); 
							setMap.put("endDate", endDate); 
							setMap.put("manday", manday);
							setMap.put("confirmed", confirmed);
							setMap.put("userID", cmmMap.get("sessionUserId"));
							
							taskService.insert("task_SQL.insertTask", setMap);
							
						}else{ // MOD
							taskID = StringUtil.checkNull(request.getParameter("taskID"+taskTypeCode), "");
							seq =  StringUtil.checkNull(request.getParameter("seq"+taskTypeCode), "");
							
							setMap.put("teamID", teamID);
							setMap.put("taskTypeCode", taskTypeCode);
							setMap.put("taskID", taskID);
							setMap.put("seq", seq);
							setMap.put("changeSetID", changeSetID);
							setMap.put("category", category);
							setMap.put("actor", memberID); 
							setMap.put("startDate", startDate); 
							setMap.put("endDate", endDate); 
							setMap.put("manday", manday);
							setMap.put("confirmed", confirmed);
							setMap.put("userID", cmmMap.get("sessionUserId"));
							
							taskService.update("task_SQL.updateTask", setMap);
						}
					}
				}

				// Update ChangaeSet 
				setMap.put("curTask", curTask);
				setMap.put("changeSetID", changeSetID);
				setMap.put("itemID", itemID);
				taskService.update("task_SQL.updateChangeSet", setMap);
			
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				target.put(AJAX_SCRIPT, "parent.fnCallBack(); parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	*/
	@RequestMapping(value = "/saveTask.do")
	public String saveTask(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		List taskTypeList = new ArrayList();
		Map taskMap = new HashMap();
		try {				
			String curTask =StringUtil.checkNull(request.getParameter("curTask"), "");
			String csrStatus =StringUtil.checkNull(request.getParameter("csrStatus"), "");
			String taskID = "";
			String reqTaskID = "";
			String seq = "";
			String taskTypeCode = "";
			
			String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
			String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
			String category [] = {"P", "A"};
			String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
			String parentID = StringUtil.checkNull(request.getParameter("parentID"), "");
			String confirmed = "";
			
			setMap.put("parentID", parentID);
			setMap.put("projectID", projectID);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			//taskTypeList = commonService.selectList("task_SQL.getTaskTypeList", setMap);
			
			JSONArray jsonArray = new JSONArray(request.getParameter("updateData"));

			
			// 입력값
			String teamID = "";
			//String actor = "";
			String startDate = "";
			String endDate = "";
			String manday = "";
			String memberID = "";
			
			setMap.put("curTask", curTask);
			setMap.put("changeSetID", changeSetID);
			setMap.put("itemID", itemID);
			String getTaskID = "";
			JSONObject jsonData;
			for (int i = 0; i < jsonArray.length(); i++) {						
				jsonData = (JSONObject) jsonArray.get(i);
				
				for(int c=0; c<category.length; c++) {
					
					if(jsonData.has("teamID"+category[c])){
						teamID = StringUtil.checkNull(jsonData.get("teamID"+category[c]), "");
					}					
//					actor =  StringUtil.checkNull(jsonData.get("ActorName"+taskTypeCode), "");
					startDate =  StringUtil.checkNull(jsonData.get("StartDate"+category[c]), "");
					endDate =  StringUtil.checkNull(jsonData.get("EndDate"+category[c]), "");
					manday =  StringUtil.checkNull(jsonData.get("Manday"+category[c]), "");
					if(jsonData.has("Actor"+category[c])) {
						memberID =  StringUtil.checkNull(jsonData.get("Actor"+category[c]), "");
					}else {
						memberID = "";
					}
					
					taskTypeCode =  StringUtil.checkNull(jsonData.get("TaskTypeCode"), "");
					
					if(jsonData.has("TaskID"+category[c])){
						reqTaskID =  StringUtil.checkNull(jsonData.get("TaskID"+category[c]), "");
					}else {
						reqTaskID = "";
					}
					
					
					if(reqTaskID.equals("")){// taskId 유무체크
						Map getMap = new HashMap();
						getMap.put("category", category[c]);
						getMap.put("changeSetID", changeSetID);
						getMap.put("taskTypeCode", taskTypeCode);
						getMap.put("itemID", itemID);
						reqTaskID = StringUtil.checkNull(commonService.selectString("task_SQL.getTaskID",getMap),"");
					}
					
					if(!memberID.equals("") && (!startDate.equals("") || !endDate.equals("")) ){
						if(category[c].equals("A")){	curTask = taskTypeCode;  } // last Task 						
						
						if(reqTaskID.equals("")){ // NEW
							taskID =  taskService.selectString("task_SQL.getMaxTaskID",setMap);
							seq =  taskService.selectString("task_SQL.getMaxTaskSeq",setMap);
							
							setMap.put("taskTypeCode", taskTypeCode);
							setMap.put("teamID", teamID);
							setMap.put("taskID", taskID);
							setMap.put("seq", seq);
							setMap.put("changeSetID", changeSetID);
							setMap.put("category", category[c]);
							setMap.put("actor", memberID); 
							setMap.put("startDate", startDate); 
							setMap.put("endDate", endDate); 
							setMap.put("manday", manday);
							setMap.put("confirmed", confirmed);
							setMap.put("userID", cmmMap.get("sessionUserId"));
							
							taskService.insert("task_SQL.insertTask", setMap);
							
						}else{ // MOD
							taskID = StringUtil.checkNull(jsonData.get("TaskID"+category[c]), "");
							seq =  StringUtil.checkNull(jsonData.get("Seq"+category[c]), "");
							
							setMap.put("teamID", teamID);
							setMap.put("taskTypeCode", taskTypeCode);
							setMap.put("taskID", taskID);
							setMap.put("seq", seq);
							setMap.put("changeSetID", changeSetID);
							setMap.put("category", category[c]);
							setMap.put("actor", memberID); 
							setMap.put("startDate", startDate); 
							setMap.put("endDate", endDate); 
							setMap.put("manday", manday);
							setMap.put("confirmed", confirmed);
							setMap.put("userID", cmmMap.get("sessionUserId"));
							
							taskService.update("task_SQL.updateTask", setMap);
						}
					}
				}
			}
			
			// Update ChangaeSet 
			setMap.put("curTask", curTask);
			setMap.put("changeSetID", changeSetID);
			setMap.put("itemID", itemID);
			taskService.update("task_SQL.updateChangeSet", setMap);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBack(); parent.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/saveTaskConfirm.do")
	public String saveTaskConfirm(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {				
				String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
				String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
				String category = StringUtil.checkNull(request.getParameter("category"), "");
				String confirmed = StringUtil.checkNull(request.getParameter("taskConfirmed"), "");
				String taskStatus = StringUtil.checkNull(request.getParameter("taskStatus"), "");
					
				setMap.put("changeSetID", changeSetID);
				setMap.put("itemID", itemID);
				setMap.put("category", category);
				setMap.put("confirmed", confirmed);
				setMap.put("taskStatus", taskStatus);
				
				taskService.insert("task_SQL.updateTaskComfirmed", setMap);
				taskService.insert("task_SQL.updateChangeSetTaskStatus", setMap);
			
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/editCsrInfo.do")
	public String editCsrInfo(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {				
				String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
				String itemID = StringUtil.checkNull(request.getParameter("itemID"), "");
				String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
				String priority = StringUtil.checkNull(request.getParameter("priority"), "");
				String difficulty = StringUtil.checkNull(request.getParameter("difficulty"), "");
				String description = StringUtil.checkNull(request.getParameter("description"), "");
					
				setMap.put("changeSetID", changeSetID);
				setMap.put("itemID", itemID);
				setMap.put("projectID", projectID);
				setMap.put("priority", priority);
				setMap.put("difficulty", difficulty);
				setMap.put("description", description);
				
				taskService.insert("task_SQL.updateChageSetInfo", setMap);
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/taskSearchList.do")
	public String taskSearchList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		Map projectMap = new HashMap();
		String url = "/project/task/taskSearchList";
		try {					
				String screenMode = StringUtil.checkNull(request.getParameter("screenMode"), ""); 
				String isMainMenu = StringUtil.checkNull(request.getParameter("isMainMenu"), ""); 
				String parentID = StringUtil.checkNull(request.getParameter("parentID"), ""); 
				setMap.put("parentID", parentID);
				setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				projectMap = taskService.select("task_SQL.getProjectAuthorID",setMap);
				
				model.put("screenMode",screenMode);
				model.put("isMainMenu",isMainMenu);
				model.put("parentID",parentID);
				model.put("projectMap", projectMap);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("totalCnt", 0);
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/getTaskSearchList.do")
	public String getTaskSearchList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		Map csrMap = new HashMap();
		Map tskNmMap = new HashMap();

		String url = "/project/task/taskSearchList";
		List csrList = new ArrayList();
		List csrTaskList = new ArrayList();
		List taskNameList = new ArrayList();
		try {				
				String filepath = request.getSession().getServletContext().getRealPath("/");
				String parentID = StringUtil.checkNull(request.getParameter("project"), ""); // parentID
				String itemClassCode = StringUtil.checkNull(request.getParameter("itemClass"), "");
				String projectID = StringUtil.checkNull(request.getParameter("csrList"), ""); //projectID
				String csrTeam = StringUtil.checkNull(request.getParameter("csrTeam"), "");
				String curTask = StringUtil.checkNull(request.getParameter("curTask"), "");
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"), "");
				String isSearch = StringUtil.checkNull(request.getParameter("isSearch"), "");
				String sessionParamSubItems = StringUtil.checkNull(cmmMap.get("sessionParamSubItems"),"");
				String screenMode = StringUtil.checkNull(request.getParameter("screenMode"), "");

				setMap.put("sessionParamSubItems", sessionParamSubItems);
				setMap.put("screenMode", screenMode);
				setMap.put("parentID", parentID);
				setMap.put("itemClassCode", itemClassCode);
				setMap.put("projectID", projectID);
				setMap.put("csrTeam", csrTeam);
				setMap.put("curTask", curTask);
				setMap.put("languageID", languageID);
				setMap.put("screenMode", screenMode);

				csrList = commonService.selectList("task_SQL.getTaskSearchList", setMap);
				if(csrList.size() > 0){
					String changeSetIDs = null;
					for (int i = 0; i < csrList.size(); i++) {						
						csrMap = (Map)csrList.get(i);
						if(i==0){
							changeSetIDs = String.valueOf(csrMap.get("ChangeSetID"));
						}else{
							changeSetIDs = changeSetIDs +","+ String.valueOf(csrMap.get("ChangeSetID"));
						}
					}
					setMap.put("changeSetIDs", changeSetIDs);
					csrTaskList = commonService.selectList("task_SQL.getCsrTaskList", setMap);
					
			        csrList = setCsrTaskData(csrList);
				
			        setMap.put("parentID", parentID);
			        setMap.put("itemClassCode", itemClassCode);
			        taskNameList = commonService.selectList("task_SQL.getTaskNameList", setMap);
			        String taskNameHeader = "";
			        String taskTypeCode = "";
			        String taskName = "";
			        
			        for (int i = 0; i < taskNameList.size(); i++) {		
			        	tskNmMap = (Map)taskNameList.get(i);			        	
			        	taskTypeCode = StringUtil.checkNull(tskNmMap.get("TaskTypeCode"));
			        	taskName = StringUtil.checkNull(tskNmMap.get("TaskName"))+"("+StringUtil.checkNull(tskNmMap.get("TaskTypeCode")) + ")";
			        	if(i == 0 ) {
			        		taskNameHeader = taskNameHeader + ",{ width: 80, id: 'P_" + taskTypeCode + "_LoginID', align:'center', header: [{ text: 'Plan', align:'center' ,colspan: " + taskNameList.size() * 4 + " }"
			        										+ ",{ text: '"+taskName+"',  align:'center', colspan:4}"
			        										+ ",{ text: '"+getLabel(request, commonService).get("LN00004")+" ID', align:'center'}]}";
			        	}else {
			        		taskNameHeader = taskNameHeader + ",{ width: 80, id: 'P_" + taskTypeCode + "_LoginID', align:'center', header: ['', { text: '"+taskName+"', align:'center', colspan: 4}"
			        										+ ",{  text: '"+getLabel(request, commonService).get("LN00004")+" ID', align:'center'}]}";
			        	}
			        	
			        	taskNameHeader = taskNameHeader + ",{ width: 80, id: 'P_"+taskTypeCode+"_ActorName', align:'center', header: ['','', { text: '"+getLabel(request, commonService).get("LN00004")+"', align:'center'}]}";
			        	taskNameHeader = taskNameHeader + ",{ width: 80, id: 'P_"+taskTypeCode+"_StartDate', align:'center', header: ['','', { text: '"+getLabel(request, commonService).get("LN00296")+"', align:'center'}]}";
			        	taskNameHeader = taskNameHeader + ",{ width: 80, id: 'P_"+taskTypeCode+"_EndDate', align:'center', header: ['','', { text: '"+getLabel(request, commonService).get("LN00064")+"', align:'center'}]}";
			        }
			        
			        for (int i = 0; i < taskNameList.size(); i++) {		
			        	tskNmMap = (Map)taskNameList.get(i);	
			        	taskTypeCode = StringUtil.checkNull(tskNmMap.get("TaskTypeCode"));
			        	taskName = StringUtil.checkNull(tskNmMap.get("TaskName"))+"("+StringUtil.checkNull(tskNmMap.get("TaskTypeCode")) + ")";			        	
			        	
			        	if(i == 0 ) {
			        		taskNameHeader = taskNameHeader + ",{ width: 80, id: 'A_" + taskTypeCode + "_LoginID', align:'center', header: [{ text: 'Actual', align:'center' ,colspan: " + taskNameList.size() * 4 + " }"
			        										+ ",{ text: '"+taskName+"',  align:'center', colspan:4}"
			        										+ ",{ text: '"+getLabel(request, commonService).get("LN00004")+" ID', align:'center'}]}";
			        	}else {
			        		taskNameHeader = taskNameHeader + ",{ width: 80, id: 'A_" + taskTypeCode + "_LoginID', align:'center', header: ['', { text: '"+taskName+"', align:'center', colspan: 4}"
			        										+ ",{  text: '"+getLabel(request, commonService).get("LN00004")+" ID', align:'center'}]}";
			        	}		        	
			        	taskNameHeader = taskNameHeader + ",{ width: 80, id: 'A_"+taskTypeCode+"_ActorName', align:'center', header: ['','', { text: '"+getLabel(request, commonService).get("LN00004")+"', align:'center'}]}";
			        	taskNameHeader = taskNameHeader + ",{ width: 80, id: 'A_"+taskTypeCode+"_StartDate', align:'center', header: ['','', { text: '"+getLabel(request, commonService).get("LN00296")+"', align:'center'}]}";
			        	taskNameHeader = taskNameHeader + ",{ width: 80, id: 'A_"+taskTypeCode+"_EndDate', align:'center', header: ['','', { text: '"+getLabel(request, commonService).get("LN00064")+"', align:'center'}]}";
			        }
					//System.out.println("taskNameHeader :"+taskNameHeader);
					
					model.put("taskNameList", taskNameList);
			        model.put("taskNameHeader", taskNameHeader);
			        model.put("taskNameCnt", taskNameList.size());
					model.put("isSearch", isSearch);
				}
				setMap.put("category", "AT");
				setMap.put("typeCode", "AT00014");
				String TCode =  commonService.selectString("task_SQL.getDicName", setMap);
				setMap.put("typeCode", "AT00063");
				String CBOType =  commonService.selectString("task_SQL.getDicName", setMap);
				
				model.put("TCode", TCode);
				model.put("CBOType", CBOType);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("parentID", parentID);
				model.put("projectID", projectID);
				model.put("itemClassCode", itemClassCode);
				model.put("csrTeam", csrTeam);
				model.put("curTask", curTask );
				model.put("totalCnt", csrList.size());
				
				JSONArray csrListJson = new JSONArray(csrList);
				model.put("csrTaskList", csrListJson);
				model.put("screenMode", screenMode);
				model.put("isMainMenu", StringUtil.checkNull(request.getParameter("isMainMenu"), ""));
				
				System.out.println("csrListJson :"+csrListJson);
				 
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	private List setCsrTaskData(List csrList) throws Exception {
        Map setTaskMap = new HashMap();
		List taskPlanList = new ArrayList();
		List taskActualList = new ArrayList();

        for (int i = 0; i < csrList.size(); i++) {
        	Map<String, String> rowMap = new HashMap<String, String>();
        	Map csrMap = (Map) csrList.get(i);
        	
        	String changeSetID = String.valueOf(csrMap.get("ChangeSetID"));
        	String itemClassCode = StringUtil.checkNull(csrMap.get("ItemClassCode"));
        	String parentID = StringUtil.checkNull(csrMap.get("ParentID"));
        	
        	  // task Plan 목록
        	setTaskMap.put("changeSetID",changeSetID);
        	setTaskMap.put("category","P");
        	setTaskMap.put("itemClassCode",itemClassCode);
        	setTaskMap.put("parentID",parentID);
        	taskPlanList = commonService.selectList("task_SQL.getTaskInfoList", setTaskMap);
        	
        	for (int j = 0; j < taskPlanList.size(); j++) {
            	Map tskPMap = (Map) taskPlanList.get(j);     
            	String taskTypeCode = StringUtil.checkNull(tskPMap.get("TaskTypeCode"));
            	String loginID = StringUtil.checkNull(tskPMap.get("LoginID"));
            	String actorName = StringUtil.checkNull(tskPMap.get("ActorName"));
            	String startDate = StringUtil.checkNull(tskPMap.get("StartDate"));
            	String endDate = StringUtil.checkNull(tskPMap.get("EndDate"));
            	
            	csrMap.put("P_"+taskTypeCode+"_LoginID", loginID);
            	csrMap.put("P_"+taskTypeCode+"_ActorName", actorName);
            	csrMap.put("P_"+taskTypeCode+"_StartDate", startDate);
            	csrMap.put("P_"+taskTypeCode+"_EndDate", endDate);
	        }
		        
        	// task Actual 목록
        	setTaskMap.put("category","A");
        	taskActualList = commonService.selectList("task_SQL.getTaskInfoList", setTaskMap);
        	for (int h = 0; h < taskActualList.size(); h++) {
            	Map tskAMap = (Map) taskActualList.get(h);            	
            	String taskTypeCode = StringUtil.checkNull(tskAMap.get("TaskTypeCode"));
            	String loginID = StringUtil.checkNull(tskAMap.get("LoginID"));
            	String actorName = StringUtil.checkNull(tskAMap.get("ActorName"));
            	String startDate = StringUtil.checkNull(tskAMap.get("StartDate"));
            	String endDate = StringUtil.checkNull(tskAMap.get("EndDate"));
            	
            	csrMap.put("A_"+taskTypeCode+"_LoginID", loginID);
            	csrMap.put("A_"+taskTypeCode+"_ActorName", actorName);
            	csrMap.put("A_"+taskTypeCode+"_StartDate", startDate);
            	csrMap.put("A_"+taskTypeCode+"_EndDate", endDate);
        	}
        }
        
        return csrList;
	}
	
	@RequestMapping(value = "/goTaskUpdate.do")
	public String goTaskUpdate(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/project/task/taskExcelUpdate";
		try {					
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	//데이타 업로드
	@RequestMapping(value="/taskExcelUpload.do")
	public String taskExcelUpload(HashMap commandFileMap, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		int line = 0;
		try {	
				List list				= (List) commandFileMap.get("STORED_FILES");
				Map map					= (Map) list.get(0);
				String sys_file_name	= (String)map.get("SysFileNm");
				String file_path		= "";//(String)map.get("FilePath");
				String file_id			= (String)map.get("AttFileID");
				String uploadOption     = (String)map.get("uploadOption");
				String filePath			= FileUtil.FILE_UPLOAD_DIR + sys_file_name;				
				String errorCheckfilePath = GlobalVal.FILE_UPLOAD_TINY_DIR;
				
				Map excelMap = new HashMap();
				SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
				long date = System.currentTimeMillis();
			    String fileName = "Upload_ERROR_" + formatter.format(date) + ".txt";
			    String downFile = errorCheckfilePath + fileName;
				File file = new File(downFile); 
				BufferedWriter errorLog = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,true), "UTF-8"));
				
				String fileVersion = sys_file_name.substring(sys_file_name.lastIndexOf(".")+1,sys_file_name.length());
				
				if(fileVersion.equals("xlsx")){
					excelMap = getItemListXss(new File(filePath), commandFileMap, commandMap, errorLog);
				}else{
					excelMap = getItemListHss(new File(filePath), commandFileMap, commandMap, errorLog);
				}
	
				if (excelMap.get("msg") != null) {
					errorLog.close();
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00074")); // 오류 발생
					target.put(AJAX_SCRIPT, "parent.errorTxtDown('"+ fileName +"','"+ downFile +"');parent.$('#isSubmit').remove();");
					
				} else {
					errorLog.close();
					file.delete(); 
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 완료 
					target.put(AJAX_SCRIPT, "parent.doCntReturn('');parent.$('#isSubmit').remove();");
				}
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00072", new String[]{e.getMessage().replaceAll("\"", "")}));
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}	
	
	// xlsx 2010
	private Map getItemListXss(File excelFile, HashMap commandFileMap, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		Map excelMap = new HashMap();	
		XSSFWorkbook workbook  =  new XSSFWorkbook(new FileInputStream(excelFile));
		XSSFSheet sheet    =  null;
		XSSFRow hRow    =  null;
		XSSFCell hCell    =  null;
		
		try{			
			sheet = workbook.getSheetAt(0);  // 첫번째 sheet의 데이터 취득
			int rowCount = sheet.getPhysicalNumberOfRows(); 
			
			if( rowCount <= 1 ){
				throw new Exception("There is no data in excel file.");
			}
			String msg = checkValueXss(sheet, commandFileMap.get("uploadOption").toString(), commandMap, errorLog);
			if (!msg.equals("")) {
				excelMap.put("msg", msg);	
				return excelMap;
			}else{				
				excelMap = setUploadMapNewXss(sheet, commandFileMap.get("uploadOption").toString(), commandMap, errorLog);
			}
			
			return excelMap;

		} catch (Exception e) {
			System.out.println(e.toString());
			throw e;
		} finally {
			try{
				workbook	= null;
				sheet		= null;
			} catch(Exception e) {

			}
		}
	}
	
	// xls
	private Map getItemListHss(File excelFile, HashMap commandFileMap, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		Map excelMap = new HashMap();
		HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(excelFile)); //XLS
		HSSFSheet sheet    =  null;
		HSSFRow hRow    =  null;
		HSSFCell hCell    =  null;	 
		
		/*Workbook workBook = (Workbook) WorkbookFactory.create(excelFile);
		Sheet sheet = null;
		Row row = null;
		Cell cell = null;*/
		
		try{			
			sheet = workbook.getSheetAt(0);  // 첫번째 sheet의 데이터 취득
			int rowCount = sheet.getPhysicalNumberOfRows(); 
			
			if( rowCount <= 1 ){
				throw new Exception("There is no data in excel file.");
			}
			String msg = checkValueHss(sheet, commandFileMap.get("uploadOption").toString(), commandMap, errorLog);
			if (!msg.equals("")) {
				excelMap.put("msg", msg);	
				return excelMap;
			}else{
				excelMap = setUploadMapNewHss(sheet, commandFileMap.get("uploadOption").toString(), commandMap, errorLog);
			}
		} catch (Exception e) {
			System.out.println(e.toString());
			throw e;
		} finally {
			try{
				workbook	= null;
				sheet		= null;
			} catch(Exception e) {

			}
		}
		return excelMap;
	}
	
	// xlsx 2010
	private String checkValueXss(XSSFSheet sheet, String option, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		String[][] data	= null;
		int rowCount  =  sheet.getPhysicalNumberOfRows();
		int colCount = sheet.getRow(0).getPhysicalNumberOfCells();
		data = new String[rowCount][colCount];
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    String langCode = String.valueOf(commandMap.get("sessionCurrLangCode"));	
	    
	    String msg = null;
	    for(int i =0 ; i < rowCount; i ++){			
			row = sheet.getRow(i);
			colCount   =  row.getPhysicalNumberOfCells();
			
			for(int j = 0; j < colCount; j ++) {
				cell	= row.getCell(j);				
				if (null != cell) {
					if (HSSFCell.CELL_TYPE_NUMERIC == cell.getCellType()) {
						 DecimalFormat df = new DecimalFormat("#");
						data[i][j]	= df.format(cell.getNumericCellValue());
					} else {
						data[i][j]	= StringUtil.checkNull(cell);
					}
				} else {
					data[i][j]	= StringUtil.checkNull(cell);
				}
			}
			
			if(i > 2){
				// 데이터 입력 체크
				msg = checkValueForUploadNew(i, data, option, langCode, errorLog);
				if(!msg.equals("")){
					return msg;
				}
			}
	    }
	    return msg;
	}
	
	//xls
	private String checkValueHss(HSSFSheet sheet, String option, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		String[][] data	= null;
		int rowCount  =  sheet.getPhysicalNumberOfRows();
		int colCount = sheet.getRow(0).getPhysicalNumberOfCells();
		data = new String[rowCount][colCount];
		
		HSSFRow row     =  null;
	    HSSFCell cell    =  null;
	    String langCode = String.valueOf(commandMap.get("sessionCurrLangCode"));	
	    
	    String msg = null; 
	    for(int i =0 ; i < rowCount; i ++){			
			row = sheet.getRow(i);
			colCount   =  row.getPhysicalNumberOfCells();
			
			for(int j = 0; j < colCount; j ++) {
				cell	= row.getCell(j);				
				if (null != cell) {
					if (HSSFCell.CELL_TYPE_NUMERIC == cell.getCellType()) {
						 DecimalFormat df = new DecimalFormat("#");
						data[i][j]	= df.format(cell.getNumericCellValue());
					} else {
						data[i][j]	= StringUtil.checkNull(cell);
					}
				} else {
					data[i][j]	= StringUtil.checkNull(cell);
				}
			}
			
			if(i > 2){
				// 데이터 입력 체크
				msg = checkValueForUploadNew(i, data, option, langCode, errorLog);
				if(!msg.equals("")){
					return msg;
				}
			}
	    }
	    return msg;
	}
	
	// xlsx
	private Map setUploadMapNewXss(XSSFSheet sheet, String option, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		Map excelMap = new HashMap();
		String colsName = "";
		int attrTypeColNum = 1;
		String[][] data	= null;
		List list = new ArrayList();
		List identifierList = new ArrayList();
		List pjtTaskList = new ArrayList();
		Map setMap = new HashMap();
		Map taskMap = new HashMap();
		Map updateTskMap = new HashMap();
		
		int valCnt = 0;
		int rowCount  =  sheet.getPhysicalNumberOfRows(); 
		int colCount = sheet.getRow(0).getPhysicalNumberOfCells();
		
		data = new String[rowCount][colCount];
		
		XSSFRow row     =  null;
	    XSSFCell cell    =  null;
	    String langCode = String.valueOf(commandMap.get("sessionCurrLangCode"));	
	 
		for(int i =0 ; i < rowCount; i ++){			
			row = sheet.getRow(i);
			colCount   =  row.getPhysicalNumberOfCells();	
			for(int j = 0; j < colCount; j ++) {
				cell	= row.getCell(j);		
				if (null != cell) {
					if (XSSFCell.CELL_TYPE_NUMERIC == cell.getCellType()) {
						 if (HSSFDateUtil.isCellDateFormatted(cell)){  
						        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");  
						        data[i][j] = formatter.format(cell.getDateCellValue()); 
					    } else { 
					    	 DecimalFormat df = new DecimalFormat("#");
							 data[i][j]	= df.format(cell.getNumericCellValue());
					    }
					}else if(XSSFCell.CELL_TYPE_STRING == cell.getCellType()){ //문자 
						data[i][j]  = StringUtil.checkNull(cell.getStringCellValue());
					
					}else if(XSSFCell.CELL_TYPE_BLANK == cell.getCellType()){ //공백
						data[i][j]  = "";
					}else if(XSSFCell.CELL_TYPE_ERROR == cell.getCellType()){ //err
						data[i][j]  = StringUtil.checkNull(cell.getErrorCellValue());
					} else {
						data[i][j]	= StringUtil.checkNull(cell);
					}
				} else {
					data[i][j]	= StringUtil.checkNull(cell);
				}
				
				//System.out.println("data :"+data[i][j]);
			}
			
			if(i > 2){				
				String csrID = null;
				String itemID = null;
				Map map = new HashMap();	
				if(option.equals("identfier")){
					setMap.put("identifier", data[i][1]);
					setMap.put("projectName", data[i][7]);
					setMap.put("langugeID", commandMap.get("sessionCurrLangType"));
					csrID = commonService.selectString("task_SQL.getCsrID", setMap);
					map.put("changeSetID", csrID);
					setMap.put("changeSetID", csrID);
				}else{
					csrID = data[i][11];
					map.put("changeSetID", csrID);
					setMap.put("changeSetID", csrID);
				}
				
				itemID = taskService.selectString("task_SQL.getCsrItemID", setMap);
				pjtTaskList = taskService.selectList("task_SQL.getPjtTask", setMap);
				
				map.put("changeType", data[i][12]);
				map.put("curTask", data[i][13]);
				map.put("priority", "0"+data[i][14]);
				map.put("difficulty", "0"+data[i][15]);
				taskService.insert("task_SQL.updateChageSetInfoExcel", map);
								
				int data2 = 17;
				int data3 = 0;
				String taskCnt = null;
				String confirmed = "";
				String actorID = null;
				String actorLoginId = null;
				String startDate = null;
				String endDate = null;
				for(int k=0; k<pjtTaskList.size(); k++){
					taskMap = (Map)pjtTaskList.get(k);		
					
					actorLoginId =  StringUtil.checkNull(data[i][data2 -1],"");
					setMap.put("loginID", actorLoginId);
					actorID = taskService.selectString("task_SQL.getMemberID", setMap);
					
					startDate = StringUtil.checkNull(data[i][(data2+1)+data3],"");
					endDate = StringUtil.checkNull(data[i][(data2+2)+data3],"");
					if(actorID.equals("") || actorID == null || actorID.equals(" ")){
						actorID = "";
					}
					if(startDate.equals("") || startDate == null || startDate.equals(" ") || startDate.equals("1900-01-01")){
						startDate = "";
					}
					if(endDate.equals("") || endDate == null || endDate.equals(" ") || endDate.equals("1900-01-01")){
						endDate = "";
					}
					
					updateTskMap.put("taskTypeCode", taskMap.get("TaskTypeCode")); 
					updateTskMap.put("actorID", actorID);
					updateTskMap.put("startDate", startDate);
					updateTskMap.put("endDate", endDate);	
					updateTskMap.put("changeSetID", csrID);
					updateTskMap.put("itemID", itemID);
					updateTskMap.put("category", "P");
					updateTskMap.put("confirmed", confirmed);	
					updateTskMap.put("userID", commandMap.get("sessionUserId"));
					
					setMap.put("taskTypeCode", taskMap.get("TaskTypeCode"));
					setMap.put("category","P");
					setMap.put("loginID",actorLoginId);
					taskCnt = taskService.selectString("task_SQL.getTaskCntExcel", setMap);
					/*System.out.println("actorID :"+data[i][data2+data3]);
					System.out.println("startDate :"+data[i][(data2+2)+data3]);
					System.out.println("endDate :"+data[i][(data2+3)+data3]);*/
					
					if(!actorID.isEmpty() || (!startDate.isEmpty() || !endDate.isEmpty())){
						if(taskCnt.equals("0")){
							String taskID = taskService.selectString("task_SQL.getMaxTaskID", setMap);
							String seq = taskService.selectString("task_SQL.getMaxTaskSeq", setMap);
							String actor = taskService.selectString("task_SQL.getMemberID", setMap);
							String teamID = taskService.selectString("task_SQL.getTeamID", setMap);
							updateTskMap.put("seq", seq);
							updateTskMap.put("actor", actor);
							updateTskMap.put("taskID", taskID);	
							updateTskMap.put("teamID",teamID);
							taskService.insert("task_SQL.insertTask", updateTskMap);
						}else{
							taskService.insert("task_SQL.updateTaskInfoExcel", updateTskMap);
						}
				    }
					data3=data3+4;
				}
				for(int l=0; l<pjtTaskList.size(); l++){
					taskMap = (Map)pjtTaskList.get(l);						
					
					actorLoginId =  StringUtil.checkNull(data[i][data2+data3 -1],"");
					setMap.put("loginID", actorLoginId);
					actorID = taskService.selectString("task_SQL.getMemberID", setMap);
					
					
					startDate = StringUtil.checkNull(data[i][(data2+1)+data3]);
					endDate = StringUtil.checkNull(data[i][(data2+2)+data3]);
					if(actorID.equals("") || actorID == null || actorID.equals(" ")){
						actorID = "";
					}
					if(startDate.equals("") || startDate == null || startDate.equals(" ") || startDate.equals("1900-01-01")){
						startDate = "";
					}					
					if(endDate.equals("") || endDate == null || endDate.equals(" ") || endDate.equals("1900-01-01")){
						endDate = "";
					}
					
					updateTskMap.put("taskTypeCode", taskMap.get("TaskTypeCode"));
					updateTskMap.put("actorID", actorID);
					updateTskMap.put("startDate", startDate );
					updateTskMap.put("endDate", endDate );	
					updateTskMap.put("changeSetID", csrID); 
					updateTskMap.put("itemID", itemID);
					updateTskMap.put("category", "A");
					updateTskMap.put("confirmed", confirmed);	
					updateTskMap.put("userID", commandMap.get("sessionUserId"));
					
					setMap.put("taskTypeCode", taskMap.get("TaskTypeCode"));
					setMap.put("category","A");
					setMap.put("loginID",data[i][data2+data3]);
					taskCnt = taskService.selectString("task_SQL.getTaskCntExcel", setMap);
					if(!actorID.isEmpty() || (!startDate.isEmpty() || !endDate.isEmpty() )){
						if(taskCnt.equals("0")){							
							String taskID = commonService.selectString("task_SQL.getMaxTaskID", setMap);
							String seq = commonService.selectString("task_SQL.getMaxTaskSeq", setMap);
							String actor = taskService.selectString("task_SQL.getMemberID", setMap);
							String teamID = taskService.selectString("task_SQL.getTeamID", setMap);
							updateTskMap.put("seq", seq);
							updateTskMap.put("actor", actor);
							updateTskMap.put("taskID", taskID);	
							updateTskMap.put("teamID", teamID);	
							taskService.insert("task_SQL.insertTask", updateTskMap);
						}else{
							taskService.insert("task_SQL.updateTaskInfoExcel", updateTskMap);
						}
					}
					data3=data3+4;
				}	
			}
		}
		excelMap.put("Success", "Y");
		return excelMap;
	}
	
	private Map setUploadMapNewHss(HSSFSheet sheet, String option, HashMap commandMap, BufferedWriter errorLog) throws Exception {
		Map excelMap = new HashMap();
		String colsName = "";
		int attrTypeColNum = 1;
		String[][] data	= null;
		List list = new ArrayList();
		List identifierList = new ArrayList();
		List pjtTaskList = new ArrayList();
		Map setMap = new HashMap();
		Map taskMap = new HashMap();
		Map updateTskMap = new HashMap();
		
		int valCnt = 0;
		int rowCount  =  sheet.getPhysicalNumberOfRows(); 
		int colCount = sheet.getRow(0).getPhysicalNumberOfCells();
		
		data = new String[rowCount][colCount];
		
		HSSFRow row     =  null;
	    HSSFCell cell    =  null;
	    String langCode = String.valueOf(commandMap.get("sessionCurrLangCode"));	
	  
		for(int i =0 ; i < rowCount; i ++){			
			row = sheet.getRow(i);
			colCount   =  row.getPhysicalNumberOfCells();
			
			for(int j = 0; j < colCount; j ++) {
				cell	= row.getCell(j);	
				if (null != cell) {
					if (HSSFCell.CELL_TYPE_NUMERIC == cell.getCellType()) {
						 if (HSSFDateUtil.isCellDateFormatted(cell)){  
						        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");  
						        data[i][j] = formatter.format(cell.getDateCellValue()); 
					    } else { 
					    	 DecimalFormat df = new DecimalFormat("#");
							 data[i][j]	= df.format(cell.getNumericCellValue());
					    }
					}else if(XSSFCell.CELL_TYPE_STRING == cell.getCellType()){ //문자 
						data[i][j]  = StringUtil.checkNull(cell.getStringCellValue());
					}else if(XSSFCell.CELL_TYPE_BLANK == cell.getCellType()){ //공백
						data[i][j]  = "";
					}else if(XSSFCell.CELL_TYPE_ERROR == cell.getCellType()){ //err
						data[i][j]  = StringUtil.checkNull(cell.getErrorCellValue());
					}else {
						data[i][j]	= StringUtil.checkNull(cell);
					}
				} else {
					data[i][j]	= StringUtil.checkNull(cell);
				}
			}
			
			if(i > 2){				
				String csrID = null;
				String itemID = null;
				Map map = new HashMap();	
				if(option.equals("idntfier")){
					setMap.put("identifier", data[i][1]);
					setMap.put("projectName", data[i][7]);
					setMap.put("langugeID", commandMap.get("sessionCurrLangType"));
					csrID = commonService.selectString("task_SQL.getCsrID", setMap);
					map.put("changeSetID", csrID);
					setMap.put("changeSetID", csrID);
				}else{
					csrID = data[i][11];
					map.put("changeSetID", csrID);
					setMap.put("changeSetID", csrID);
				}
				
				itemID = taskService.selectString("task_SQL.getCsrItemID", setMap);
				pjtTaskList = taskService.selectList("task_SQL.getPjtTask", setMap);
				
				map.put("changeType", data[i][12]);
				map.put("curTask", data[i][13]);
				map.put("priority", "0"+data[i][14]);
				map.put("difficulty", "0"+data[i][15]);
				taskService.insert("task_SQL.updateChageSetInfoExcel", map);
								
				int data2 = 17;
				int data3 = 0;
				String taskCnt = null;
				String confirmed = "";
				String startDate = null;
				String endDate = null;
				String actorID = null;
				for(int k=0; k<pjtTaskList.size(); k++){
					taskMap = (Map)pjtTaskList.get(k);
					actorID =  StringUtil.checkNull(data[i][data2+data3],"");
					startDate = StringUtil.checkNull(data[i][(data2+2)+data3],"");
					endDate = StringUtil.checkNull(data[i][(data2+3)+data3],"");
					if(actorID.equals("") || actorID == null || actorID.equals(" ")){
						actorID = "";
					}
					if(startDate.equals("") || startDate == null || startDate.equals(" ") || startDate.equals("1900-01-01")){
						startDate = "";
					}
					if(endDate.equals("") || endDate == null || endDate.equals(" ") || endDate.equals("1900-01-01")){
						endDate = "";
					}
					updateTskMap.put("taskTypeCode", taskMap.get("TaskTypeCode"));
					updateTskMap.put("actorID", actorID);
					updateTskMap.put("startDate", startDate);
					updateTskMap.put("endDate", endDate);	
					updateTskMap.put("changeSetID", csrID); 
					updateTskMap.put("itemID", itemID);
					updateTskMap.put("category", "P");
					updateTskMap.put("confirmed", confirmed);	
					updateTskMap.put("userID", commandMap.get("sessionUserId"));
					
					setMap.put("taskTypeCode", taskMap.get("TaskTypeCode"));
					setMap.put("category","P");
					setMap.put("loginID",data[i][data2+data3]);
					taskCnt = taskService.selectString("task_SQL.getTaskCntExcel", setMap);
					if(!actorID.isEmpty() || (!startDate.isEmpty() || !endDate.isEmpty()) ){
						if(taskCnt.equals("0")){
							String taskID = taskService.selectString("task_SQL.getMaxTaskID", setMap);
							String seq = taskService.selectString("task_SQL.getMaxTaskSeq", setMap);
							String actor = taskService.selectString("task_SQL.getMemberID", setMap);
							String teamID = taskService.selectString("task_SQL.getTeamID", setMap);
							updateTskMap.put("seq", seq);	
							updateTskMap.put("teamID", teamID);	
							updateTskMap.put("actor", actor);
							updateTskMap.put("taskID", taskID);		
							taskService.insert("task_SQL.insertTask", updateTskMap);
						}else{
							taskService.insert("task_SQL.updateTaskInfoExcel", updateTskMap);
						}
					}
					data3=data3+4;
				}
				
				for(int l=0; l<pjtTaskList.size(); l++){
					taskMap = (Map)pjtTaskList.get(l);	
					actorID =  StringUtil.checkNull(data[i][data2+data3],"");
					startDate = StringUtil.checkNull(data[i][(data2+2)+data3],"");
					endDate = StringUtil.checkNull(data[i][(data2+3)+data3],"");
					
					if(actorID.equals("") || actorID == null || actorID.equals(" ")){
						actorID = "";
					}
					if(startDate.equals("") || startDate == null || startDate.equals(" ") || startDate.equals("1900-01-01")){
						startDate = "";
					}
					
					if(endDate.equals("") || endDate == null || endDate.equals(" ") || endDate.equals("1900-01-01")){
						endDate = "";
					}
					updateTskMap.put("taskTypeCode", taskMap.get("TaskTypeCode"));
					updateTskMap.put("actorID", actorID);
					updateTskMap.put("startDate", startDate);
					updateTskMap.put("endDate", endDate);	
					updateTskMap.put("changeSetID", csrID); 
					updateTskMap.put("itemID", itemID);
					updateTskMap.put("category", "A");
					updateTskMap.put("confirmed", confirmed);	
					updateTskMap.put("userID", commandMap.get("sessionUserId"));
					
					setMap.put("taskTypeCode", taskMap.get("TaskTypeCode"));
					setMap.put("category","A");
					setMap.put("loginID",data[i][data2+data3]);
					taskCnt = taskService.selectString("task_SQL.getTaskCntExcel", setMap);
					if(!actorID.isEmpty() || (!startDate.isEmpty() || !endDate.isEmpty() )){
						if(taskCnt.equals("0")){							
							String taskID = commonService.selectString("task_SQL.getMaxTaskID", setMap);
							String seq = commonService.selectString("task_SQL.getMaxTaskSeq", setMap);
							String actor = taskService.selectString("task_SQL.getMemberID", setMap);
							String teamID = taskService.selectString("task_SQL.getTeamID", setMap);
							updateTskMap.put("seq", seq);	
							updateTskMap.put("teamID", teamID);	
							updateTskMap.put("actor", actor);
							updateTskMap.put("taskID", taskID);	
							taskService.insert("task_SQL.insertTask", updateTskMap);
						}else{
							taskService.insert("task_SQL.updateTaskInfoExcel", updateTskMap);
						}
					}
					data3=data3+4;
				}	
			}
		}

		excelMap.put("Success", "Y");
		return excelMap;
	}
	
	private String checkValueForUploadNew(int i, String[][] data, String option, String langCode, BufferedWriter errorLog) throws Exception {
		String msg = "";
		Map commandMap = new HashMap();
		if(option.equals("csrID")){			
			if( data[i][11].isEmpty()){
				//msg = (i + 1) + "행의 Revision를 입력해 주세요.";
				msg = MessageHandler.getMessage(langCode + ".WM00111", new String[]{String.valueOf(i + 1), "Revision"});
				errorLog.write(msg); 
				errorLog.newLine();
			}			
		}else{
			if( data[i][1].isEmpty()){ 
				//msg = (i + 1) + "행의 Identifier를 입력해 주세요.";
				msg = MessageHandler.getMessage(langCode + ".WM00111", new String[]{String.valueOf(i + 1), "Identifier"});
				errorLog.write(msg); 
				errorLog.newLine();
			}
		}
		return msg;
	}
	
	@RequestMapping(value = "/editTaskResultList.do")
	public String editTaskResultList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/project/task/editTaskResultList";
		try {			
				String itemID = "";
				String itemTypeCode = "";
				String reqItemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"),"");
				if(reqItemTypeCode.equals("")){
					itemID = StringUtil.checkNull(cmmMap.get("s_itemID"));
					setMap.put("itemID", itemID);
					itemTypeCode = taskService.selectString("task_SQL.getItemTypeCode", setMap);
					model.put("itemTypeCode", itemTypeCode);
				}else{
					model.put("itemTypeCode", reqItemTypeCode);
				}
				String pageNum = StringUtil.checkNull(request.getParameter("pageNum"),"1");
				String mainVersion = StringUtil.checkNull(request.getParameter("mainVersion"),"");
				// 현재날짜 구하기 
		        Calendar cal = Calendar.getInstance();
		        cal.setTime(new Date(System.currentTimeMillis()));
		        String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
				model.put("thisYmd", thisYmd);
				model.put("itemID", itemID);
				model.put("mainVersion", mainVersion);
				
				model.put("pageNum", pageNum);
				model.put("menu", getLabel(request, commonService)); 
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/taskFileUploadPop.do")
	public String taskFileUploadPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/project/task/taskFileUploadPop";
		try {					
				String itemID = StringUtil.checkNull(request.getParameter("itemID"));
				String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"));
				String taskTypeCode = StringUtil.checkNull(request.getParameter("taskTypeCode"));
				String fltpCode = StringUtil.checkNull(request.getParameter("fltpCode"));
				String fileID = StringUtil.checkNull(request.getParameter("fileID"));
				String taskID = StringUtil.checkNull(request.getParameter("taskID"));
				String sysFile = StringUtil.checkNull(request.getParameter("sysFile"));
				String projectID = StringUtil.checkNull(request.getParameter("projectID"));
				
				model.put("itemID", itemID);
				model.put("changeSetID", changeSetID);
				model.put("taskTypeCode", taskTypeCode);
				model.put("fltpCode", fltpCode);
				model.put("sysFile", sysFile);
				model.put("fileID", fileID);
				model.put("taskID", taskID);
				model.put("projectID", projectID);
				
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/editTaskResult.do")
	public String editTaskResult(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		List editTaskList = new ArrayList();
		String url = "/project/task/taskResultEdit";
		try {					
				String itemIDArr = StringUtil.checkNull(request.getParameter("itemIDArr"));
				String changeSetIDArr = StringUtil.checkNull(request.getParameter("changeSetIDArr"));
				String taskTypeCodeArr = StringUtil.checkNull(request.getParameter("taskTypeCodeArr"));
				String pageNum = StringUtil.checkNull(request.getParameter("pageNum"));
				String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
				String taskIDPArr = StringUtil.checkNull(request.getParameter("taskIDPArr"));
				String mainVersion = StringUtil.checkNull(request.getParameter("mainVersion"));
		
				Map taskTypeMap = new HashMap();
				List taskTypeList = new ArrayList(); 
				String taskTypeCodeSpl[] = taskTypeCodeArr.split(",");
				String changeSetIdSpl[] = changeSetIDArr.split(",");
				String taskIDPSpl[] = taskIDPArr.split(",");
				String taskTypeCode = "";
				String changeSetID = "";
				String taskIDP = "";
				
				
				for(int i=0; i<taskTypeCodeSpl.length; i++){
					if(i==0){
						taskTypeCode = taskTypeCodeSpl[i].toString();
					}else{
						taskTypeCode = taskTypeCode+"','"+taskTypeCodeSpl[i].toString();
					}
				}
				
				for(int i=0; i<changeSetIdSpl.length; i++){
					if(i==0){
						changeSetID = changeSetIdSpl[i];
					}else{
						changeSetID = changeSetID+","+changeSetIdSpl[i];
					}
				}
				
				for(int i=0; i<taskIDPSpl.length; i++){
					if(i==0){
						taskIDP = taskIDPSpl[i];
					}else{
						taskIDP = taskIDP+","+taskIDPSpl[i];
					}
				}
				
				String sql = "TSK.TaskTypeCode In('"+taskTypeCode+"') ";
				setMap.put("sql", sql);
				setMap.put("taskTypeCode", taskTypeCode);
				setMap.put("changeSetID", changeSetIDArr);
				setMap.put("taskIDP", taskIDP);
				setMap.put("langugeID", cmmMap.get("sessionCurrLangType"));
				
				editTaskList = commonService.selectList("task_SQL.getEditTaskList", setMap);
				model.put("taskList", editTaskList);
				model.put("itemTypeCode", itemTypeCode);
				model.put("taskCnt", editTaskList.size());
				model.put("pageNum", pageNum);
				model.put("mainVersion", mainVersion);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
		
	@RequestMapping(value = "/saveTaskResult.do")
	public String saveTaskResult(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setPlanMap = new HashMap();
		Map setActualMap = new HashMap();
		Map setAttrMap = new HashMap();
		try {				
			
			JSONArray jsonArray = new JSONArray(request.getParameter("updateData"));
			
			//String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "");
			String reqTaskCnt = StringUtil.checkNull(request.getParameter("taskCnt"), "");
			//int taskCnt = Integer.parseInt(reqTaskCnt);
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),"");
			String itemID = "";
			String taskTypeCode = "";
			String changeSetID = "";
			String planEndDate = "";
			String actualStartDate = "";
			String actualEndDate = "";
			String programID = "";
			String tCode = "";
			String taskIDP = "";
			String taskIDA = "";
			String attrCnt = "";
			int listScale = GlobalVal.LIST_SCALE;
			JSONObject jsonData;
			for (int i = 0; i < jsonArray.length(); i++) {
				jsonData = (JSONObject) jsonArray.get(i);
				
				itemID = StringUtil.checkNull(jsonData.get("ItemID"), "");
				taskTypeCode = StringUtil.checkNull(jsonData.get("TaskTypeCode"), "");
				changeSetID = StringUtil.checkNull(jsonData.get("ChangeSetID"), "");
				planEndDate = StringUtil.checkNull(jsonData.get("PlanEndDate"), "");
				actualStartDate = StringUtil.checkNull(jsonData.get("ActualStartDate"), "");
				actualEndDate = StringUtil.checkNull(jsonData.get("ActualEndDate"), "");
				programID = StringUtil.checkNull(jsonData.get("ProgramID"), "");
				tCode = StringUtil.checkNull(jsonData.get("T_Code"), "");
				taskIDP = StringUtil.checkNull(jsonData.get("TaskIDP"), "");
				
				if(jsonData.has("TaskIDA")) {
					taskIDA = StringUtil.checkNull(jsonData.get("TaskIDA"), "");
				}else {
					taskIDA = "";
				}
				
				// Plan Save
				/*if(!taskIDP.equals("")){
						setPlanMap.put("taskID", taskIDP);
						setPlanMap.put("endDate", planEndDate);
						setPlanMap.put("userID", cmmMap.get("sessionUserId"));
						taskService.update("task_SQL.updateTaskResult", setPlanMap);
					}*/
				
				if(taskIDA.equals("")){// taskId 유무체크
					Map getMap = new HashMap();
					getMap.put("category", "A");
					getMap.put("changeSetID", changeSetID);
					getMap.put("taskTypeCode", taskTypeCode);
					getMap.put("itemID", itemID);
					taskIDA = StringUtil.checkNull(commonService.selectString("task_SQL.getTaskID",getMap),"");
				}
				
				// Actal Save
				if(!taskIDA.equals("")){ // Update
					setActualMap.put("taskID", taskIDA);
					setActualMap.put("startDate", actualStartDate);
					setActualMap.put("endDate", actualEndDate);
					setActualMap.put("userID", cmmMap.get("sessionUserId"));
					
					taskService.update("task_SQL.updateTaskResult", setActualMap);
				}else if(!actualStartDate.equals("") || !actualEndDate.equals("")){
					taskIDA = taskService.selectString("task_SQL.getMaxTaskID", setActualMap);
					setActualMap.put("taskID", taskIDA);
					setActualMap.put("itemID", itemID);
					setActualMap.put("changeSetID", changeSetID);
					setActualMap.put("taskTypeCode", taskTypeCode);
					setActualMap.put("category", "A");
					setActualMap.put("startDate", actualStartDate);
					setActualMap.put("endDate", actualEndDate);
					setActualMap.put("userID", cmmMap.get("sessionUserId"));
					setActualMap.put("actor", cmmMap.get("sessionUserId"));
					
					taskService.insert("task_SQL.insertTask", setActualMap);
				}
				
				// itemAttr Update  ProgramID
				if(!programID.equals("")){
					setAttrMap.put("itemID", itemID);
					setAttrMap.put("attrTypeCode", "AT00039");
					setAttrMap.put("languageID", languageID);
					setAttrMap.put("plainText", programID);
					attrCnt = taskService.selectString("task_SQL.selectItemAttr", setAttrMap);
					if(attrCnt.equals("0")){// itemAttrType Insert							
						taskService.insert("task_SQL.insertItemAttrPlainText", setAttrMap);
					}else{ // itemAttrType update
						taskService.update("task_SQL.updateItemAttrPlainText", setAttrMap);
					}
				}
				
				// itemAttr Update  tCode
				if(!tCode.equals("")){
					setAttrMap.put("itemID", itemID);
					setAttrMap.put("attrTypeCode", "AT00014");
					setAttrMap.put("languageID", languageID);
					setAttrMap.put("plainText", tCode);
					attrCnt = taskService.selectString("task_SQL.selectItemAttr", setAttrMap);
					if(attrCnt.equals("0")){// itemAttrType Insert							
						taskService.insert("task_SQL.insertItemAttrPlainText", setAttrMap);
					}else{ // itemAttrType update
						taskService.update("task_SQL.updateItemAttrPlainText", setAttrMap);
					}
				}
			}
			
			
			model.put("mainVersion", StringUtil.checkNull(request.getParameter("mainVersion"),""));
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnGoBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/taskMonitoringList.do")
	public String taskMonitoringList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/project/task/taskMonitoringList";
		try {	
		        // 현재날짜 구하기 
		        Calendar cal = Calendar.getInstance();
		        cal.setTime(new Date(System.currentTimeMillis()));
		        String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
		       
		        cal.add(Calendar.MONTH, -1);
		        String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
		      

				String pageNum = StringUtil.checkNull(request.getParameter("pageNum"),"1");
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"), "");
				setMap.put("typeCode", "AT00063");
				setMap.put("languageID", languageID);
				setMap.put("category", "AT");
				String AT00063 =  commonService.selectString("task_SQL.getDicName", setMap);
				model.put("htmlImgDir","/"+GlobalVal.HTML_IMG_DIR+"/");
				model.put("thisYmd", thisYmd);
				model.put("pageNum", pageNum);
				model.put("isSearch", "Y");
				model.put("AT00063", AT00063);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				System.out.println("htmlImgDir"+model.get("htmlImgDir"));
				
				cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				cmmMap.put("fromPlanEndDate", beforeYmd);
				cmmMap.put("toPlanEndDate", thisYmd);
			    cmmMap.put("currentDate", thisYmd);
			    cmmMap.put("htmlImgDir", "/"+GlobalVal.HTML_IMG_DIR+"/");
			    cmmMap.put("screenMode", "report");
			    cmmMap.put("userID", cmmMap.get("sessionUserId"));
			    cmmMap.put("pageNum", pageNum);
				List taskList = commonService.selectList("task_SQL.getTaskResultList_gridList",cmmMap);
				
				JSONArray gridData = new JSONArray(taskList);
				model.put("gridData",gridData);
				
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/editTaskActorPop.do")
	public String editTaskActorPop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/project/task/editTaskActorPop";
		try {	
				setMap.put("itemID", StringUtil.checkNull(request.getParameter("itemID")) );
				String itemIDArr = StringUtil.checkNull(request.getParameter("itemIDArr"),"");
				String changeSetIDArr = StringUtil.checkNull(request.getParameter("changeSetIDArr"),"");
				String taskTypeCodeArr = StringUtil.checkNull(request.getParameter("taskTypeCodeArr"),"");
				
				model.put("itemIDArr", itemIDArr);
				model.put("changeSetIDArr", changeSetIDArr);
				model.put("taskTypeCodeArr", taskTypeCodeArr);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value = "/editTaskActor.do")
	public String editTaskActor(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map updateMap = new HashMap();
		try {				
				String changeSetIDArr = StringUtil.checkNull(request.getParameter("changeSetIDArr"), "");
				String taskTypeCodeArr = StringUtil.checkNull(request.getParameter("taskTypeCodeArr"), "");
				String actorID = StringUtil.checkNull(request.getParameter("actorID"), "");
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),"");
				
				String changeSetIDSpl[] = changeSetIDArr.split(",");
				String taskTypeCodeSpl[] = taskTypeCodeArr.split(",");
				
				String changeSetID = "";
				String taskTypeCode = "";
				for(int i=0; i<changeSetIDSpl.length; i++){
					changeSetID =  StringUtil.checkNull(changeSetIDSpl[i],"");
					taskTypeCode =  StringUtil.checkNull(taskTypeCodeSpl[i],"");
					
					updateMap.put("changeSetID",changeSetID);
					updateMap.put("taskTypeCode",taskTypeCode);
					updateMap.put("actorID",actorID);
					updateMap.put("userID",cmmMap.get("sessionUserId"));
					taskService.update("task_SQL.updateTaskActor", updateMap);
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				target.put(AJAX_SCRIPT, "fnGoBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/setCurTaskClose.do")
	public String setCurTaskClose(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map updateMap = new HashMap();
		try {		
				String changeSetID = StringUtil.checkNull(request.getParameter("changeSetID"), "");
				String category = StringUtil.checkNull(request.getParameter("category"), "");
				String csrStatus = StringUtil.checkNull(request.getParameter("csrStatus"), "");
			
				updateMap.put("changeSetID",changeSetID);
				updateMap.put("curTask","CLS");
				taskService.update("task_SQL.updateCurTaskClose", updateMap);
				
				model.put("changeSetID", changeSetID);
				model.put("category", category);
				model.put("csrStatus", csrStatus);
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
}
