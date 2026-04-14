package xbolt.hom.schdl.web;

import java.io.File;
import java.io.PrintWriter;
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

import org.apache.commons.text.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.org.json.JSONObject;
import net.sf.json.JSONArray;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

@Controller
public class SchedulActionController extends XboltController{
	
	
	@Autowired
    @Qualifier("commonService")
    private CommonService commonService;
	
	@Resource(name = "schedulService")
	private CommonService schedulService;
	
	@RequestMapping(value="/schedulMgt.do")
	public String schedulMgt(HttpServletRequest request, ModelMap model) throws Exception{
		try {
				String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
				String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");
				String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "");
				
				model.put("projectID", projectID);
				model.put("screenType", screenType);
				model.put("pageNum", pageNum);
				model.put("menu", getLabel(request, commonService));	//Label Setting
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/hom/schdl/schdlMgt");
	}	
	
	@RequestMapping(value="/schedulMgtMaster.do")
	public String schedulMgt2(HttpServletRequest request, ModelMap model) throws Exception{
		try {
				String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
				String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");
				String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "");
				
				model.put("projectID", projectID);
				model.put("screenType", screenType);
				model.put("pageNum", pageNum);
				model.put("menu", getLabel(request, commonService));	//Label Setting
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/hom/schdl/schedulMgtMaster");
	}	
	
	@RequestMapping(value="/saveSchedul.do")
	public String saveSchedul(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		// insert
		List insertList = new ArrayList();
		Map insertValMap = new HashMap();
		Map insertInfoMap = new HashMap();
		// update
		Map updateValMap = new HashMap();
		Map updateInfoMap = new HashMap();
		List updateList = new ArrayList();
		// delete
		Map deleteValMap = new HashMap();
		Map deleteInfoMap = new HashMap();
		List deleteList = new ArrayList();
		
		String[] ids = request.getParameter("ids").split(",");
		int idsCnt = ids.length;		
		String start_date = null;
		String end_date = null;
		String text = null;
		String status = null;
		String details = null;
		String start_dateSuStr = null;
		String location = null;
		String scheduleID = null;
		
		String userId = StringUtil.checkNull(request.getParameter("userId"), "1");
		String userGrpId = StringUtil.checkNull(request.getParameter("userGrpId"), "1");
		String templetCode = StringUtil.checkNull(request.getParameter("templetCode"), "1");
	
		
		try {
				for(int i=0; i<idsCnt; i++){				
				insertValMap = new HashMap();				
				start_date = request.getParameter(ids[i]+"_start_date");
				end_date = request.getParameter(ids[i]+"_end_date");
				text = request.getParameter(ids[i]+"_text");
				status = request.getParameter(ids[i]+"_!nativeeditor_status");
				details = StringUtil.checkNull(request.getParameter(ids[i]+"_details"),"");
				start_dateSuStr = start_date.substring(0,10); 
				location = request.getParameter(ids[i]+"_location");
				scheduleID = request.getParameter(ids[i]+"_id");
				
				if(status.equals("inserted")){					
					scheduleID = commonService.selectString("schedule_SQL.schedulNextVal", new HashMap());
					insertValMap.put("scheduleID", scheduleID);
					insertValMap.put("start_date", start_date);
					insertValMap.put("end_date", end_date);
					insertValMap.put("text", text);
					insertValMap.put("details", details);
					insertValMap.put("userId", userId);
					insertValMap.put("userGrpId", userGrpId);
					insertValMap.put("templetCode", templetCode);
					insertValMap.put("location", location);
					
					insertInfoMap.put("KBN", "insert");
					insertList.add(insertValMap);
					insertInfoMap.put("SQLNAME", "schedule_SQL.schdlInsert");
				}else if(status.equals("updated")){					
					updateValMap.put("start_date", start_date);
					updateValMap.put("end_date", end_date);
					updateValMap.put("text", text);
					updateValMap.put("details", details);
					updateValMap.put("userId", userId);
					updateValMap.put("userGrpId", userGrpId);
					updateValMap.put("templetCode", templetCode);
					updateValMap.put("scheduleID", scheduleID);
					updateValMap.put("start_dateSuStr", start_dateSuStr);
					updateValMap.put("location", location);
					
					updateInfoMap.put("KBN", "update");
					updateInfoMap.put("SQLNAME", "schedule_SQL.schedlUpdate");
					updateList.add(updateValMap);
				}else{					
					deleteValMap.put("scheduleID", scheduleID);		
					deleteInfoMap.put("KBN", "delete");
					deleteInfoMap.put("SQLNAME", "schedule_SQL.schedlDelete");
					deleteList.add(deleteValMap);
				}
			}
			
			if(insertValMap.size() > 0){
				schedulService.save(insertList, insertInfoMap);
			}
			if(updateValMap.size()>0){
				schedulService.save(updateList, updateInfoMap);
			}
			if(deleteValMap.size()>0){
				schedulService.save(deleteList,deleteInfoMap);
			}
			
			Map target = new HashMap();
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnSelectSchdl()");
			model.addAttribute(AJAX_RESULTMAP, target);
	}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl(AJAXPAGE);
	}
	
	// select dhtmlx scheduler
	@RequestMapping(value="/selectSchdlList.do")
	public String selectSchdlList(HttpServletRequest request, ModelMap model, HttpServletResponse response,  HashMap cmmMap) throws Exception{
		Map mapValue = new HashMap();
		List getList = new ArrayList();
		try {
				String projectID = StringUtil.checkNull(request.getParameter("projectID"), "");
				String userID = StringUtil.checkNull(cmmMap.get("sessionUserId"), "");
				mapValue.put("userID", userID);	
				mapValue.put("projectID", projectID);	
				getList = commonService.selectList("schedule_SQL.selectSchdlList",mapValue);
			
				JSONArray jsonArray = JSONArray.fromObject(getList);				
				response.setCharacterEncoding("UTF-8"); // 한글깨짐현상 방지
				PrintWriter out = response.getWriter();
			    out.write(jsonArray.toString());
			    out.flush();
		}catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	// 
	@RequestMapping(value="/goSchdlListMgt.do")
	public String goSchdlListMgt(HttpServletRequest request, ModelMap model) throws Exception{
		HashMap<String, Comparable> setData = new HashMap<String, Comparable>();
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String schdlType = StringUtil.checkNull(request.getParameter("schdlTP"),"");
			setData.put("s_itemID", s_itemID);
		
			Map itemInfo = commonService.select("project_SQL.getItemInfo", setData);
			String projectID = StringUtil.checkNull(itemInfo.get("ProjectID"),"");
			
			model.put("documentID", StringUtil.checkNull(request.getParameter("documentID"), ""));
		 	model.put("docCategory", StringUtil.checkNull(request.getParameter("docCategory"), ""));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("s_itemID", s_itemID);
			model.put("schdlType", schdlType);
			model.put("projectID", projectID);
			//System.out.println("projectID: "+projectID);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/hom/schdl/schdlListMgt");
	}
	
	// 스케쥴 목록 이동goSchdlList

	@RequestMapping(value="/goSchdlList.do")
	public String goSchdlList(HttpServletRequest request,  HashMap<String, Comparable> cmmMap, ModelMap model) throws Exception{
		//List schdlList = new ArrayList();
		
		try {
				int i = 0;
				String searchKeyVal = StringUtil.checkNull(request.getParameter("searchKey"),"Name");
				String searchValue = StringUtil.checkNull(request.getParameter("searchValue"),"");
				String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"0");
				String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "");
				String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");
				String parentID = StringUtil.checkNull(request.getParameter("parentID"), ""); 
				String userID = StringUtil.checkNull(cmmMap.get("sessionUserId"), "");
				int documentID = Integer.parseInt(StringUtil.checkNull(cmmMap.get("documentID"), s_itemID)); 
				String docCategory = StringUtil.checkNull(cmmMap.get("docCategory"), "");
				String location = StringUtil.checkNull(cmmMap.get("location"), "");
				String schdlType = StringUtil.checkNull(request.getParameter("schdlType"), "");
				String mySchdl = StringUtil.checkNull(request.getParameter("mySchdl"), "");
				String searchViewFlag = StringUtil.checkNull(request.getParameter("searchViewFlag"), "");
				int projectID = Integer.parseInt(StringUtil.checkNull(request.getParameter("projectID"), "0"));
				String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),"");
				
				if(schdlType.equals("today")) {
					i = 30;
				}else if(schdlType.equals("week")) {
					i = 37;
				}else {
					i = 60;
				}
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(new Date());
				Date date = calendar.getTime();
				String SC_END_DT_FROM = new SimpleDateFormat("yyyy-MM-dd").format(date);
				calendar.add(Calendar.DATE, -30);
		        date = calendar.getTime();
				String SC_STR_DT_FROM = new SimpleDateFormat("yyyy-MM-dd").format(date);
				calendar.add(Calendar.DATE, +i);
		        date = calendar.getTime();
		        String SC_END_DT_TO = new SimpleDateFormat("yyyy-MM-dd").format(date);
		        
		        String pjtInfoMgtYN = StringUtil.checkNull(request.getParameter("pjtInfoMgtYN"));
				Map<String, Comparable> setMap = new HashMap<String, Comparable>();	
				if(screenType.equals("pjtInfoMgt")){
					Map projectMap = new HashMap();
					setMap.put("parentID", parentID);
					setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
					projectMap = commonService.select("task_SQL.getProjectAuthorID",setMap);
					model.put("projectMap", projectMap);
					setMap.put("userID", userID);
					String pjtMember = commonService.selectString("schedule_SQL.getPjtMember",setMap);
					if(!pjtMember.equals("")){
						model.put("pjtMember", "Y");
					}
				}
				
				
				model.put("SC_STR_DT_FROM", SC_STR_DT_FROM);				
				model.put("SC_END_DT_FROM", SC_END_DT_FROM);				
				model.put("SC_END_DT_TO", SC_END_DT_TO);				
				model.put("schdlType", schdlType);					
				model.put("mySchdl", mySchdl);				
				model.put("parentID", parentID);				
				model.put("pageNum", pageNum);
				model.put("screenType", screenType);
				model.put("documentID", documentID);
				model.put("docCategory", docCategory);
				model.put("searchViewFlag", searchViewFlag);
				model.put("menu", getLabel(request, commonService));	//Label Setting
				model.put("projectID", projectID);
				
				cmmMap.put("languageID", languageID);
				cmmMap.put("userID", request.getParameter("userID"));
				cmmMap.put("pageNum", pageNum);
				cmmMap.put("endDTCheck", "N");
			    cmmMap.put("scEndDtFrom", SC_END_DT_FROM);
				cmmMap.put("scEndDtTo", SC_END_DT_TO);
			    cmmMap.put("searchKey", searchKeyVal);
			    cmmMap.put("searchValue", searchValue);
					
				
				if(docCategory!="" && docCategory != null) {
					
					cmmMap.put("docCategory", docCategory);
				}
				if(documentID!=0) {
					
					cmmMap.put("documentID", documentID);
				}
				if(documentID!=0) {
					
					cmmMap.put("projectID", projectID);
				}
				if(location!=""&&location!=null) {
					
					cmmMap.put("location", location);
				}
				if(mySchdl!=""&&mySchdl !=null) {
					
					cmmMap.put("mySchdl", mySchdl);
				}
				List<?> schdlList = commonService.selectList("schedule_SQL.getSchdlList_gridList", cmmMap);
				
				
				JSONArray gridData = JSONArray.fromObject(schdlList);	
				model.put("gridData", gridData);
				
				
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/hom/schdl/schdlList");
	}
	
	@RequestMapping(value="/selectSchedulDetail.do")	
	public String selectSchedulDetail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/hom/schdl/schdlDetail";		
		try{	
			HashMap setMap = new HashMap();
			Map result =  new HashMap();
			List attachFileList = new ArrayList();
			//String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "");
			String userId = StringUtil.checkNull(commandMap.get("sessionUserId"), "");
			String scheduleId = StringUtil.checkNull(request.getParameter("scheduleId"), "");
			
			
			setMap.put("userId", userId);
			setMap.put("scheduleId", scheduleId);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			result = commonService.select("schedule_SQL.schedulDetail", setMap);
			String Content = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(result.get("Content")));
			result.put("Content", Content);
			
			attachFileList = commonService.selectList("schedule_SQL.getSCHDLFileList", setMap);
			
			model.put("schdlFiles", attachFileList);
			model.put("resultMap", result);
			model.put("mySchdl", StringUtil.checkNull(commandMap.get("mySchdl"), ""));
			model.put("schdlType", StringUtil.checkNull(commandMap.get("schdlType"), ""));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
	
		return nextUrl(url);
	}
	
	@RequestMapping(value="/registerSchdl.do")	
	public String registerSchdl(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/hom/schdl/registerSchdl";		
		
		try{	
			HashMap setMap = new HashMap();
			Map result =  new HashMap();
			Map docResult =  new HashMap();
			String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "");
			String userId = StringUtil.checkNull(commandMap.get("sessionUserId"), "");
			String scheduleId = StringUtil.checkNull(request.getParameter("scheduleId"), "");
			String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");
			String parentID = StringUtil.checkNull(request.getParameter("parentID"), "");
			
			String docCategory = StringUtil.checkNull(request.getParameter("docCategory"), "");
			String docCategoryName = "";
			String documentID = StringUtil.checkNull(request.getParameter("documentID"), "");
			String docNO = StringUtil.checkNull(request.getParameter("docNO"), "");
			String projectID = StringUtil.checkNull(request.getParameter("projectID"),"");
			
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new Date());
			Date date = calendar.getTime();
			String todayTime = new SimpleDateFormat("yyyy-MM-dd").format(date);
			
	        
			if(!docCategory.equals("")) {
				setMap.put("selectedCode", "'"+docCategory+"'");
				setMap.put("category", "DOCCAT");
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				docResult = commonService.select("common_SQL.getDictionary_commonSelect",setMap);
				docCategoryName = String.valueOf(docResult.get("NAME"));
			}else {
				docCategory = "CMM";
				docCategoryName = "General";
			}
			
			setMap = new HashMap();
			setMap.put("userId", userId);
			setMap.put("scheduleId", scheduleId);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
			
			if(docCategory.equals("SR")) {
				setMap.put("srID",documentID);
				result = commonService.select("esm_SQL.getESMSRInfo", setMap);
				result.put("Subject", result.get("Subject"));
				result.put("Content", result.get("Comment"));
			}
			/*
			else if(docCategory.equals("CSR")) {
				setMap.put("ProjectID",documentID);				
				result = commonService.select("project_SQL.getSetProjectListForCsr_gridList", setMap);
				result.put("Subject", result.get("ProjectName"));
				result.put("Content", result.get("Description"));
				
			}else if(docCategory.equals("PJT")) {
				setMap.put("s_itemID",documentID);
				result = commonService.select("project_SQL.getProjectInfoView", setMap);
				result.put("Subject", result.get("ProjectName"));
				result.put("Content", result.get("Description"));
			}
			*/
			
			Map projectMap = new HashMap();
			if(!parentID.equals("")) {
				setMap.put("parentID", parentID);
				projectMap = commonService.select("task_SQL.getProjectAuthorID",setMap);
			}
			model.put("todayTime", todayTime);
			model.put("projectMap", projectMap);
			model.put("parentID", parentID);
			model.put("resultMap", result);
			model.put("pageNum", pageNum);
			model.put("screenType", screenType);
			model.put("documentID", documentID);
			model.put("docNO", docNO);
			model.put("docCategory", docCategory);
			model.put("docCategoryName", docCategoryName);
			model.put("mySchdl", StringUtil.checkNull(commandMap.get("mySchdl"), ""));
			model.put("schdlType", StringUtil.checkNull(commandMap.get("schdlType"), ""));
			model.put("projectID", projectID);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			FileUtil.deleteDirectory(GlobalVal.FILE_UPLOAD_BASE_DIR + commandMap.get("sessionUserId"));
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
	
		return nextUrl(url);
	}
	@RequestMapping(value="/editSchdl.do")	
	public String editSchdl(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/hom/schdl/editSchdl";		
		try{	
			HashMap setMap = new HashMap();
			Map result =  new HashMap();
			List attachFileList = new ArrayList();
			String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "");
			String userId = StringUtil.checkNull(commandMap.get("sessionUserId"), "");
			String scheduleId = StringUtil.checkNull(request.getParameter("scheduleId"), "");
			String screenType = StringUtil.checkNull(request.getParameter("screenType"), "");
			String parentID = "", docCategory = "";
			
			setMap.put("userId", userId);
			setMap.put("scheduleId", scheduleId);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			result = commonService.select("schedule_SQL.schedulDetail", setMap);
			attachFileList = commonService.selectList("schedule_SQL.getSCHDLFileList", setMap);

			docCategory = String.valueOf(result.get("docCategory"));
			if(!docCategory.equals("CMM")) {
				parentID = String.valueOf(result.get("ProjectID"));
			}
			
			
			Map projectMap = new HashMap();
			setMap.put("parentID", parentID);
			projectMap = commonService.select("task_SQL.getProjectAuthorID",setMap);
			model.put("projectMap", projectMap);
			
			model.put("schdlFiles", attachFileList);
			model.put("parentID", parentID);
			model.put("resultMap", result);
			model.put("pageNum", pageNum);
			model.put("screenType", screenType);
			model.put("mySchdl", StringUtil.checkNull(commandMap.get("mySchdl"), ""));
			model.put("schdlType", StringUtil.checkNull(commandMap.get("schdlType"), ""));
			
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			FileUtil.deleteDirectory(GlobalVal.FILE_UPLOAD_BASE_DIR + commandMap.get("sessionUserId"));
			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl(url);
	}
	
	@RequestMapping(value="/saveSchedulDetail.do")
	public String saveSchedulDetail(HttpServletRequest request,  HashMap commandMap, ModelMap model) throws Exception{
		
		Map target = new HashMap();
		HashMap setMap = new HashMap();
		String userId = StringUtil.checkNull(commandMap.get("sessionUserId"), "");//1
		String userNm = StringUtil.checkNull(commandMap.get("sessionUserNm"), "");//박찬호
		String scheduleId = StringUtil.checkNull(request.getParameter("scheduleId"), "");
		String SchdlType = StringUtil.checkNull(request.getParameter("schdlType"), "");
		
	//	String usergroupId = StringUtil.checkNull(request.getParameter("getUserGrp"), "100");
		String templCode = StringUtil.checkNull(request.getParameter("templCode"), "");
		String startDt = StringUtil.checkNull(request.getParameter("SC_STR_DT"),"");//	"2024-07-08" 	
		String endDt = StringUtil.checkNull(request.getParameter("SC_END_DT"),"");//2024-07-09
		String start_time = StringUtil.checkNull(request.getParameter("start_time"),"");//17:30
		String end_time = StringUtil.checkNull(request.getParameter("end_time"),"");//09:00
		String regDT = StringUtil.checkNull(request.getParameter("regDT"),"");
		String startAlarm = StringUtil.checkNull(request.getParameter("startAlarm"),null);
		String Subject = StringUtil.checkNull(request.getParameter("Subject"),"");//테스트04
		String Content = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(request.getParameter("Content"),""));
		String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "1");
		String projectID= StringUtil.checkNull(request.getParameter("project"), "0");
		String projectName = StringUtil.checkNull(request.getParameter("projectName"), "");
		String location = StringUtil.checkNull(request.getParameter("Location"),"");//패스트파이브
		String docCategory = StringUtil.checkNull(request.getParameter("docCategory"),"");
		String docCategoryName = StringUtil.checkNull(request.getParameter("docCategoryName"),"");
		String sharers = StringUtil.checkNull(request.getParameter("sharers"));
		String sharerNames = StringUtil.checkNull(request.getParameter("sharerNames"), "");
 		String documentID = StringUtil.checkNull(request.getParameter("documentID"),"");
 		String docNO = StringUtil.checkNull(request.getParameter("docNO"),"");
 		String alarmOption = StringUtil.checkNull(request.getParameter("alarmOption"),"");
 		String alarmOptionName = StringUtil.checkNull(request.getParameter("alarmOptionName"),"");
 		String disclScope = StringUtil.checkNull(request.getParameter("disclScope"),"");
 		String disclScopeName = StringUtil.checkNull(request.getParameter("disclScopeName"),"");//공유자
 		

		try {
			setMap.put("SchdlType", SchdlType);
			setMap.put("userId", userId);
			setMap.put("userNm", userNm);
			//setMap.put("usergroupId", usergroupId);
			setMap.put("scheduleId", scheduleId);
			setMap.put("templCode", templCode);
			setMap.put("Subject", Subject);
			setMap.put("Content", Content);
			setMap.put("StartDT", startDt+" "+start_time);
			setMap.put("EndDT", endDt+" "+end_time);
			setMap.put("startAlarm", startAlarm);
			setMap.put("RegDT", regDT);
			setMap.put("projectName", projectName);
			setMap.put("location", location);
			setMap.put("DocCategory", docCategory);
			setMap.put("docNO", docNO);
			setMap.put("docCategoryName", docCategoryName);
			setMap.put("Sharers", sharers);
			setMap.put("sharerNames", sharerNames);
			setMap.put("documentID", documentID);
			setMap.put("alarmOption", alarmOption);
			setMap.put("alarmOptionName", alarmOptionName);
			setMap.put("disclScope", disclScope);
			setMap.put("disclScopeName", disclScopeName); //공유자 /전체/프로젝트
			setMap.put("sharerId", userId);
			if(docCategory.equals("ITM")) {
				//String projectID = ;	
				setMap.put("projectID", StringUtil.checkNull(request.getParameter("projectID"), "0"));
			}else {
				setMap.put("projectID", projectID);
			}
			
			scheduleId = commonService.selectString("schedule_SQL.schedulNextVal", setMap); // scheduleID 생성 
			
			setMap.put("scheduleId", scheduleId);
			commonService.insert("schedule_SQL.schdlDetailInsert", setMap); //TB_SCHEDULER 에 INSERT 
		
			insertSCHDLFiles(commandMap, scheduleId); //TB_FILE INSERT ?
			
			Map receiverMap = new HashMap();
			Map memberInfo = new HashMap();
			List receiverList = new ArrayList();
			sharers = userId+","+ sharers;//받는 사람생성
	 		String sharerList[] = sharers.split(",");
	
			for(int i=0; i<sharerList.length; i++){
				setMap.put("sharerId", sharerList[i]);
				receiverMap = new HashMap();
				receiverMap.put("receiptUserID", sharerList[i]);
				if(!sharerList[i].equals(userId)) {
					receiverMap.put("receiptType", "CC"); 
				}else {
					receiverMap.put("receiptType", "TO");
				}
				setMap.put("memberID", sharerList[i]);
				setMap.put("languageID", "1042");
				memberInfo = commonService.select("user_SQL.getMemberInfo", setMap);//받는사람 멤버 정보
				
				setMap.put("mbrTeamID", memberInfo.get("TeamID"));
				commonService.update("schedule_SQL.mySchdlInsert", setMap); //TB_MY_SCHEDULE 에 INSERT 
				receiverList.add(i, receiverMap);
			}

			HashMap setMailData = new HashMap();
			setMailData.put("receiverList",receiverList);
			Map setMailMapRst = (Map)setEmailLog(request, commonService, setMailData, "SCHDL");
			if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){

				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
				mailMap.put("mailSubject", "OLM Schedule - "+ Subject);
				
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("emailCode", "SCHDL");
				String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", setMap));
				//TB_EMAIL_FORM 에 등록된 EMAILFORM
				setMap.put("emailHTMLForm", emailHTMLForm);
				
				Map resultMailMap = EmailUtil.sendMail(mailMap, setMap, getLabel(request, commonService));
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMapRst.get("type")));
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
			}	
			
			
			
			if(!documentID.equals("")) {
				setMap.put("lastUser", userId);
				//Save PROC_LOG			
				Map setProcMapRst = (Map)setProcLog(request, commonService, setMap);
				if(setProcMapRst.get("type").equals("FAILE")){
					String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
					System.out.println("Msg : "+Msg);
				}
			}
			
			
			model.put("srID", StringUtil.checkNull(request.getParameter("srID"),""));
			model.put("pageNum", pageNum);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.selfClose('T'); parent.$('#isSubmit').remove();");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/updateSchedulDetail.do")
	public String updateSchedulDetail(HttpServletRequest request,  HashMap commandMap, ModelMap model) throws Exception{
		
		Map target = new HashMap();
		HashMap setMap = new HashMap();
		String userId = StringUtil.checkNull(commandMap.get("sessionUserId"), "");
		String userNm = StringUtil.checkNull(commandMap.get("sessionUserNm"), "");
		String scheduleId = StringUtil.checkNull(request.getParameter("scheduleId"), "");
		//	String usergroupId = StringUtil.checkNull(request.getParameter("getUserGrp"), "100");
		String templCode = StringUtil.checkNull(request.getParameter("templCode"), "");
		
		String startDt = StringUtil.checkNull(request.getParameter("SC_STR_DT"),"");
		String endDt = StringUtil.checkNull(request.getParameter("SC_END_DT"),"");
		String start_time = StringUtil.checkNull(request.getParameter("start_time"),"");
		String end_time = StringUtil.checkNull(request.getParameter("end_time"),"");
		String regDT = StringUtil.checkNull(request.getParameter("regDT"),"");
		String startAlarm = StringUtil.checkNull(request.getParameter("startAlarm"),null);
		String Subject = StringUtil.checkNull(request.getParameter("Subject"),"");
		String Content = StringEscapeUtils.unescapeHtml4(StringUtil.checkNull(request.getParameter("Content"),""));
		String pageNum = StringUtil.checkNull(request.getParameter("pageNum"), "1");
		String projectID = StringUtil.checkNull(request.getParameter("project"), "0");
		String projectName = StringUtil.checkNull(request.getParameter("projectName"), "");
		String location = StringUtil.checkNull(request.getParameter("Location"),"");
		String docCategory = StringUtil.checkNull(request.getParameter("docCategory"),"");
		String docCategoryName = StringUtil.checkNull(request.getParameter("docCategoryName"),"");
		String sharers = StringUtil.checkNull(request.getParameter("sharers"));
		String sharerNames = StringUtil.checkNull(request.getParameter("sharerNames"), "");
		String documentID = StringUtil.checkNull(request.getParameter("documentID"),"");
		String docNO = StringUtil.checkNull(request.getParameter("docNO"),"");
		String alarmOption = StringUtil.checkNull(request.getParameter("alarmOption"),"");
		String alarmOptionName = StringUtil.checkNull(request.getParameter("alarmOptionName"),"");
		String disclScope = StringUtil.checkNull(request.getParameter("disclScope"),"");
		String disclScopeName = StringUtil.checkNull(request.getParameter("disclScopeName"),"");
		
		
		try {
			setMap.put("userId", userId);
			setMap.put("userNm", userNm);
			//setMap.put("usergroupId", usergroupId);
			setMap.put("scheduleId", scheduleId);
			setMap.put("templCode", templCode);
			setMap.put("Subject", Subject);
			setMap.put("Content", Content);
			setMap.put("StartDT", startDt+" "+start_time);
			setMap.put("EndDT", endDt+" "+end_time);
			setMap.put("startAlarm", startAlarm);
			setMap.put("RegDT", regDT);
			setMap.put("projectID", projectID);
			setMap.put("projectName", projectName);
			setMap.put("location", location);
			setMap.put("DocCategory", docCategory);
			setMap.put("docNO", docNO);
			setMap.put("docCategoryName", docCategoryName);
			setMap.put("Sharers", sharers);
			setMap.put("sharerNames", sharerNames);
			setMap.put("documentID", documentID);
			setMap.put("alarmOption", alarmOption);
			setMap.put("alarmOptionName", alarmOptionName);
			setMap.put("disclScope", disclScope);
			setMap.put("disclScopeName", disclScopeName);
			setMap.put("sharerId", userId);
			
			commonService.update("schedule_SQL.schedlDetailUpdate", setMap);
			commonService.delete("schedule_SQL.mySchedlDelete", setMap);
			
			insertSCHDLFiles(commandMap, scheduleId);
			
			Map receiverMap = new HashMap();
			Map memberInfo = new HashMap();
			List receiverList = new ArrayList();
			sharers = userId+","+ sharers;//받는 사람생성
			String sharerList[] = sharers.split(",");
			int mySchdCnt = 0;
			for(int i=0; i<sharerList.length; i++){
				mySchdCnt = 0;
				setMap.put("sharerId", sharerList[i]);
				receiverMap = new HashMap();
				receiverMap.put("receiptUserID", sharerList[i]);
				if(!sharerList[i].equals(userId)) {
					receiverMap.put("receiptType", "CC");
				}else {
					receiverMap.put("receiptType", "TO");
				}

				setMap.put("memberID", sharerList[i]);
				setMap.put("languageID", "1042");
				memberInfo = commonService.select("user_SQL.getMemberInfo", setMap);
				
				setMap.put("mbrTeamID", memberInfo.get("TeamID"));
				
				mySchdCnt = commonService.selectListTotCnt("schedule_SQL.getMySchdlCnt", setMap);
				if(mySchdCnt == 0) {
					commonService.update("schedule_SQL.mySchdlInsert", setMap);
				}else {
					commonService.update("schedule_SQL.mySchedlUpdate", setMap);					
				}
				receiverList.add(i, receiverMap);
			}
			
			HashMap setMailData = new HashMap();
			setMailData.put("receiverList",receiverList);
			Map setMailMapRst = (Map)setEmailLog(request, commonService, setMailData, "SCHDL");
			if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
				mailMap.put("mailSubject", "OLM Schedule - "+ Subject);
				
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("emailCode", "SCHDL");
				String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", setMap));
				setMap.put("emailHTMLForm", emailHTMLForm);
				
				Map resultMailMap = EmailUtil.sendMail(mailMap, setMap, getLabel(request, commonService));
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMapRst.get("type")));
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
			}		
			
			if(!documentID.equals("")) {
				setMap.put("lastUser", userId);
				//Save PROC_LOG			
				Map setProcMapRst = (Map)setProcLog(request, commonService, setMap);
				if(setProcMapRst.get("type").equals("FAILE")){
					String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
					System.out.println("Msg : "+Msg);
				}
			}
			
			
			model.put("srID", StringUtil.checkNull(request.getParameter("srID"),""));
			model.put("pageNum", pageNum);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.goSchdlDetail("+scheduleId+"); parent.schdlListRefresh(); parent.$('#isSubmit').remove();");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		
		return nextUrl(AJAXPAGE);
	}

	@RequestMapping(value="/deleteSchdlDetail.do")
	public String deleteSchdlDetail(HttpServletRequest request,  HashMap commandMap, ModelMap model) throws Exception{

		Map target = new HashMap();
		HashMap setMap = new HashMap();
	 	List attachFileList = new ArrayList();
		String userId = StringUtil.checkNull(request.getParameter("userId"), "");
		String scheduleId = StringUtil.checkNull(request.getParameter("scheduleId"), "");
		String filePath = "";
		String fileName = "";
		HashMap resultMap;
		try {
				setMap.put("scheduleId", scheduleId);
			 	commonService.delete("schedule_SQL.mySchedlDelete", setMap);
			 	setMap.put("scheduleID", scheduleId);
			 	commonService.delete("schedule_SQL.schedlDelete", setMap);
			 	
			 	attachFileList = commonService.selectList("schedule_SQL.getSCHDLFileList", setMap);
			 	setMap.put("fltpCode", "SCHDOC");
				filePath = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFilePath",setMap)); 
			 	for(int i=0; i<attachFileList.size(); i++) {
			 		fileName = "";
			 		setMap = new HashMap();
			 		resultMap = (HashMap)attachFileList.get(i);
			 		fileName = filePath + resultMap.get("FileName");
					File existFile = new File(fileName);
					if(existFile.exists() && existFile.isFile()){existFile.delete();}
			 		setMap.put("scheduleId", scheduleId);
			 		setMap.put("Seq", resultMap.get("Seq"));
					commonService.delete("schedule_SQL.deleteSCHDLFile", setMap);
			 	}
			
			 	//target.put(AJAX_ALERT, "삭제가 성공하였습니다.");
			 	target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			 	target.put(AJAX_SCRIPT, "parent.selfClose('T'); parent.$('#isSubmit').remove();");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
	
		return nextUrl(AJAXPAGE);
	}
	
	private void insertSCHDLFiles(HashMap commandMap, String scheduleId) throws ExceptionUtil {
		Map fileMap  = new HashMap();
		List fileList = new ArrayList();
			try {
			int seqCnt = Integer.parseInt(commonService.selectString("fileMgt_SQL.itemFile_nextVal", commandMap));		
			//Read Server File
			String orginPath = GlobalVal.FILE_UPLOAD_BASE_DIR + StringUtil.checkNull(commandMap.get("sessionUserId"))+"//";
			fileMap.put("fltpCode", "SCHDOC");
			String filePath = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFilePath",fileMap)); 
			String targetPath = filePath;
			List tmpFileList = FileUtil.copyFiles(orginPath, targetPath);
			HashMap resultMap;
			if(tmpFileList.size() != 0){
				for(int i=0; i<tmpFileList.size();i++){
					fileMap = new HashMap(); 
					resultMap = (HashMap)tmpFileList.get(i);
					fileMap.put("Seq", seqCnt);
					fileMap.put("DocumentID",scheduleId);
					fileMap.put("DocCategory","SCHDL");
					fileMap.put("projectID", commandMap.get("projectID"));
					fileMap.put("FileName", resultMap.get(FileUtil.UPLOAD_FILE_NM));
					fileMap.put("FileRealName", resultMap.get(FileUtil.ORIGIN_FILE_NM));
					fileMap.put("FileSize", resultMap.get(FileUtil.FILE_SIZE));
					fileMap.put("FileMgt", "SCHDL");
					fileMap.put("FltpCode", "SCHDOC");
					fileMap.put("userId", commandMap.get("sessionUserId"));
					fileMap.put("RegUserID", commandMap.get("sessionUserId"));
					fileMap.put("LastUser", commandMap.get("sessionUserId"));
					fileMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
					
					fileMap.put("KBN", "insert");
					fileMap.put("SQLNAME", "fileMgt_SQL.itemFile_insert");					
					fileList.add(fileMap);
					seqCnt++;
				}
			}
			if(fileList.size() != 0){
				schedulService.save(fileList, fileMap);
			}
			
			if (!orginPath.equals("")) {
				FileUtil.deleteDirectory(orginPath);
			}
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
	}
	
	@RequestMapping(value="/deleteSCHDLFile.do")
	public String deleteSCHDLFile(HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();		
		HashMap setMap = new HashMap();
		try {
				String filePath = "";
				String realFile = StringUtil.checkNull(commandMap.get("realFile"));
				String fltpCode = StringUtil.checkNull(commandMap.get("fltpCode"));
				if(!fltpCode.equals("")) {
					setMap.put("fltpCode", fltpCode);
					filePath = StringUtil.checkNull(commonService.selectString("fileMgt_SQL.getFilePath",setMap));	
				}else {
					filePath = GlobalVal.FILE_UPLOAD_ITEM_DIR + commandMap.get("sessionUserId")+"//";
				}
				realFile = filePath + realFile;
				
				String Seq = StringUtil.checkNull(commandMap.get("Seq"));
				String scheduleId = StringUtil.checkNull(commandMap.get("scheduleId"));
				
				File existFile = new File(realFile);
				if(existFile.exists() && existFile.isFile()){existFile.delete();}
				if(!scheduleId.equals("")) {
					setMap.put("scheduleId", scheduleId);
					setMap.put("Seq", Seq);
					commonService.delete("schedule_SQL.deleteSCHDLFile", setMap);
				}
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00075")); // 성공
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00076")); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	

	@RequestMapping(value="/mainSchdlList.do")
	public String mainSchdlList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		try {
			String listSize = StringUtil.checkNull(request.getParameter("listSize"));
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
			cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			cmmMap.put("projectID", projectID);
			List schdlList = (List)commonService.selectList("schedule_SQL.getSchdlList_gridList", cmmMap);
			
			model.put("schdlList", schdlList);
			model.put("listSize", listSize);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}		
		catch (Exception e) {System.out.println(e);throw new ExceptionUtil(e.toString());}		
		return nextUrl("/hom/main/schdl/mainSchdlList");
	}
	
	@RequestMapping(value="/olmMainSchdlList.do")
	public String olmMainSchdlList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		try {
			Map setMap = new HashMap();
			List schdlList = new ArrayList();
			
			 Date today = new Date();
			SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
			model.put("today", date.format(today));
			  
			String languageID = String.valueOf(cmmMap.get("sessionCurrLangType"));
			String mySchdl = StringUtil.checkNull(request.getParameter("mySchdl"));
			
			int listSize = Integer.parseInt(request.getParameter("listSize"));
	        setMap.put("languageID", languageID);
	        setMap.put("listSize", listSize);
	        setMap.put("endDTCheck", "Y");
	        setMap.put("mySchdl", mySchdl);
	        setMap.put("userID", cmmMap.get("sessionUserId"));
			schdlList = (List)commonService.selectList("schedule_SQL.getSchdlList_gridList", setMap);
	        model.put("schdlList", schdlList);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}		
		catch (Exception e) {System.out.println(e);throw new ExceptionUtil(e.toString());}		
		return nextUrl("/hom/main/v34/olmMainSchdlList");
	}
	/**
	 * [main] 화면 schedul 상세 표시
	 * 
	 * @param request
	 * @param cmmMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/schdlDetailPop.do")
	public String schdlDetailPop(HttpServletRequest request, HashMap cmmMap,
			ModelMap model) throws Exception {
		Map setMap = new HashMap();
		Map result = new HashMap();
		List attachFileList = new ArrayList();
		try {

			String scheduleId = StringUtil.checkNull(request.getParameter("scheduleId"));
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			setMap.put("scheduleId", scheduleId);
			result = commonService.select("schedule_SQL.schedulDetail", setMap);
			attachFileList = commonService.selectList("schedule_SQL.getSCHDLFileList", setMap);
			String content = StringUtil.checkNull(result.get("Content"));
			content = StringUtil.replaceFilterString(content);
			result.put("Content",content);
			
			model.put("schdlFiles", attachFileList);
			model.put(AJAX_RESULTMAP, result);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/hom/schdl/schdlDetailPop");
	}
	
	@RequestMapping(value = "/olmapi/workCalendar")
	public void srAttr(HttpServletRequest request,  HttpServletResponse res) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map map = new HashMap();
		
        res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
	    try {
	    	map.put("userID", StringUtil.checkNull(request.getParameter("userID"),""));
	    	List data = commonService.selectList("schedule_SQL.getWorkCalendar_gridList", map);
			
			jsonObject.put("data", data);
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
}