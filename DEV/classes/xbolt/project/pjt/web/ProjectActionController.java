package xbolt.project.pjt.web;

import java.io.File;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.org.json.JSONArray;
import com.sap.i18n.cp.ConvertSystemCpToC7bOnly;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.MakeEmailContents;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

/**
 * 공통 서블릿 처리
 * @Class Name : ProjectActionController.java
 * @Description : 배포화면을 제공한다.
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
public class ProjectActionController extends XboltController{
	@Resource(name = "commonService")
	private CommonService commonService;

	/*
	 * 변경 단위 관리 :: ProjectGroup생성 및 수정
	 *-jsp/adm/userProject/projectGroupList.jsp  
	 * */
	@RequestMapping("/changeAdmin.do")
	public String changeInfoMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/project/pjt/changeAdmin";
		try {
			model.put("isHome", StringUtil.checkNull(request.getParameter("isHome")));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
			throw new Exception("EM00001");
		}

		return nextUrl(url);
	}
	
	/**
	 * [home 화면용] 변경항목조회
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/changeInfoMgtHome.do")
	public String changeInfoMgtHome(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "/project/changeInfo/changeInfoMgt";
		try {
			
			model.put("menuName", request.getParameter("menuName"));
		} catch (Exception e) {
			System.out.println(e.toString());
			throw new Exception("EM00001");
		}

		return nextUrl(url);
	}
	
@RequestMapping(value="/projectGroupList.do")
	public String projectGroupList(HttpServletRequest request, ModelMap model) throws Exception{
		Map<String, Object> setMap = new HashMap<String, Object>();
		
		try {
			model.put("filter", StringUtil.checkNull(request.getParameter("filter"),"PG"));
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("refID", StringUtil.checkNull(request.getParameter("projectID")));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "0"));

			
			
			setMap.put("filter", model.get("filter"));
			setMap.put("languageID",  StringUtil.checkNull( request.getParameter("languageID")));
			setMap.put("screenType", model.get("screenType"));
			setMap.put("refID", model.get("refID"));
			List<Map<String,Object>> prjList = commonService.selectList("project_SQL.getSetProjectList_gridList", setMap);
			
			JSONArray gridData = new JSONArray(prjList);
			model.put("gridData", gridData);
			System.out.println("gridData>>"+gridData);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/project/pjt/projectGroupList");
	}
	
	
	@RequestMapping(value="/projectItemCreate.do")
	public String projectItemCreate(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		
		HashMap<String, String> target = new HashMap<String, String>();
		
		try{
			Map<String, Object> setData = new HashMap<String, Object>();
			
			setData.put("ProjectType", request.getParameter("ProjectType"));
			setData.put("Status", request.getParameter("Status"));
			setData.put("ParentID", StringUtil.checkNull(request.getParameter("s_itemID"),"0"));
			setData.put("PJCategory", StringUtil.checkNull(request.getParameter("category"),"PC1"));
			
			setData.put("CompanyID", request.getParameter("CompanyID"));
			setData.put("UserID", request.getParameter("UserID"));
			setData.put("TeamID", request.getParameter("ownerTeamID"));
			
			setData.put("CreationDate", request.getParameter("CreationDate"));
			setData.put("StartDate", request.getParameter("StartDate"));
			setData.put("DueDate", request.getParameter("DueDate"));
			
			setData.put("AuthorID", StringUtil.checkNull(request.getParameter("AuthorID"),request.getParameter("UserID")));
			setData.put("AuthorName", request.getParameter("AuthorName"));
			
			//System.out.println(setData);
			
			//받아온 id가 있으면 수정 없으면 생성
			if(StringUtil.checkNull(request.getParameter("ProjectID"), "").equals("")){
				setData.put("ProjectID", commonService.selectString("project_SQL.getMaxProjectID", setData) );
				commonService.insert("project_SQL.createProject",setData);
			}else{
				setData.put("ProjectID", request.getParameter("ProjectID") );
				commonService.update("project_SQL.updateProject",setData);
			}
			
			setData.put("category", request.getParameter("category"));
			setData.put("Name", request.getParameter("ProjectName"));
			setData.put("Description", request.getParameter("Description"));
			setData.put("languageID", request.getParameter("languageID"));
			if(StringUtil.checkNull(request.getParameter("ProjectID"), "").equals("")){				
				commonService.insert("project_SQL.createProjectTxt",setData);
			}else{
				commonService.update("project_SQL.updateProjectTxt",setData);
			}
			//System.out.println("setData TB_PROJECT_TXT = "+setData);
			
			//target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			
			target.put(AJAX_SCRIPT, "this.doSearchClassList();this.$('#isSubmit').remove();");
			
			//신규일 경우 grid 재검색
			/*
			if(StringUtil.checkNull(request.getParameter("ProjectID"), "").equals("")){
				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();");				
			}else{
				target.put(AJAX_SCRIPT, "this.doSearchClassList();this.$('#isSubmit').remove();");
			}
			 * */
			
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}

		
	/**
	 * [신규 프로젝트 생성 & Edit]
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/admin/savePrjInfo.do")
	public String savePrjInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{	

		Map<String, String> target = new HashMap<String, String>();
		HashMap<String, Object> setData = new HashMap<String, Object>();
		HashMap<String, Object> insertData = new HashMap<String, Object>();
		HashMap<String, Object> updateData = new HashMap<String, Object>();
		
		try{
			
			String actionType = StringUtil.checkNull(request.getParameter("actionType"));
			String RBtn = StringUtil.checkNull(request.getParameter("editBtn"));
			String prefix = StringUtil.checkNull(request.getParameter("Prefix"));
			String projectCode = StringUtil.checkNull(request.getParameter("ProjectCode"));
			String projectID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String pjtType = StringUtil.checkNull(request.getParameter("pjtType"), "PG");
			String refPGID = StringUtil.checkNull(request.getParameter("refID"));
			String companyID = StringUtil.checkNull(request.getParameter("company"), "1");
			String pgCode = StringUtil.checkNull(request.getParameter("PGCode"));
			String aprvOption = StringUtil.checkNull(request.getParameter("aprvOption"), "");
			String pjtCat = StringUtil.checkNull(request.getParameter("pjtCatName"), "PC1");
			
			String ajaxScript = "";
			String maxPJTCode = "";
			setData.put("custTeamID", companyID);
			String customerNo = commonService.selectString("crm_SQL.getCustTeamID", setData);
			// 프로젝트 신규 생성
			if (actionType.equals("C")) {
			
				setData.put("refID", refPGID);		
				setData.put("pType", "PJT");	
				/* 시스템 날짜 */
				if(!"".equals(refPGID) && "".equals(pgCode)) {
				
					setData.put("s_itemID", refPGID);		
				
					setData.put("languageID", commandMap.get("sessionCurrLangType"));	
					Map<String, Object> temp = commonService.select("project_SQL.getProjectInfo", setData);	
					pgCode = StringUtil.checkNull(temp.get("ProjectCode"));
						
				}
				Calendar cal = Calendar.getInstance();
				cal.setTime(new Date(System.currentTimeMillis()));
				String thisYY = new SimpleDateFormat("yy").format(cal.getTime());		
				setData.put("pgCode", pgCode);		
				setData.put("thisYY", thisYY);
				
				String maxCurPJTCode = StringUtil.checkNull(commonService.selectString("project_SQL.getMaxProjectCode", setData));				
				if(maxCurPJTCode.equals("")){
					maxPJTCode = pgCode  + thisYY + "0001";
				} else {
					maxCurPJTCode = maxCurPJTCode.substring(maxCurPJTCode.length() - 4, maxCurPJTCode.length());
					int curPJTCode = Integer.parseInt(maxCurPJTCode) + 1;
					maxPJTCode =  pgCode +  thisYY + String.format("%04d", curPJTCode);			
				}
				
				projectID = commonService.selectString("project_SQL.getMaxProjectID", insertData);
				insertData.put("ProjectType", pjtType);
				insertData.put("ProjectID", projectID);
				insertData.put("CompanyID", companyID);
				insertData.put("Status", "RDY"); 
				insertData.put("TeamID", StringUtil.checkNull(request.getParameter("ownerTeamCode")));
				insertData.put("ParentID", refPGID); // RefPGID선택값	
				insertData.put("AuthorID", request.getParameter("AuthorID"));	
				insertData.put("AuthorName", request.getParameter("AuthorName"));
				insertData.put("PJCategory", pjtCat); // TODO
				insertData.put("StartDate", StringUtil.checkNull(request.getParameter("StartDate")));	
				insertData.put("DueDate", StringUtil.checkNull(request.getParameter("DueDate")));					
			
				insertData.put("ProjectCode", maxPJTCode );
				insertData.put("TemplCode", StringUtil.checkNull(request.getParameter("TMPL")));
				insertData.put("Prefix", prefix);
				insertData.put("clientID", customerNo);
				
				if(pjtType.equals("PG")) {						
					insertData.put("RefPGID", projectID);
				}
				else {						
					insertData.put("RefPGID", refPGID);
					insertData.put("RefPjtID", projectID);						
				}
				
				insertData.put("AprvOption", aprvOption);
				commonService.insert("project_SQL.createProject",insertData);
				
				List activatedLangList = commonService.selectList("common_SQL.langType_commonSelect", insertData);
				
				for (int i = 0; activatedLangList.size() > i;i++ ) {
					Map map = (Map) activatedLangList.get(i);
					String languageId = String.valueOf(map.get("CODE"));
					
					insertData.put("Name", request.getParameter("ProjectName"));
					insertData.put("languageID", languageId);
					insertData.put("Description", StringUtil.checkNull(request.getParameter("Description")));
					commonService.insert("project_SQL.createProjectTxt",insertData);
				}
				
					ajaxScript = "parent.goProjectList();";		
				
			
			} else {
				updateData = new HashMap<String, Object>();
				updateData.put("ProjectID", StringUtil.checkNull(request.getParameter("s_itemID")));
				updateData.put("projectID", StringUtil.checkNull(request.getParameter("s_itemID")));
				
				if (actionType.equals("U")) { // Save
					updateData.put("ProjectCode", projectCode);
					updateData.put("TeamID", StringUtil.checkNull(request.getParameter("ownerTeamCode")));			
					updateData.put("AuthorID", request.getParameter("AuthorID"));			
					updateData.put("AuthorName", request.getParameter("AuthorName"));
					updateData.put("StartDate", StringUtil.checkNull(request.getParameter("StartDate")).trim());	
					updateData.put("DueDate", StringUtil.checkNull(request.getParameter("DueDate")).trim());
					updateData.put("Status", StringUtil.checkNull(request.getParameter("Status"))); // TODO:::
					updateData.put("Prefix", prefix);
					updateData.put("TemplCode", StringUtil.checkNull(request.getParameter("TMPL")));
					updateData.put("ParentID", refPGID);
					updateData.put("RefPGID", refPGID);
					updateData.put("CompanyID", companyID);
					updateData.put("AprvOption", aprvOption);
					updateData.put("PJCategory", pjtCat);
					commonService.update("project_SQL.updateProject", updateData);
					
					updateData.put("Name", request.getParameter("ProjectName"));
					updateData.put("languageID", request.getParameter("languageID"));
					updateData.put("Description", request.getParameter("Description"));
					
					String projectName = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectName", updateData));					
					if(projectName.equals("")){				
						commonService.insert("project_SQL.createProjectTxt",updateData);
					}else{
						commonService.update("project_SQL.updateProjectTxt",updateData);
					}
				} 										
					ajaxScript = "parent.goMyPjtInfo('R');";
				
			}
				
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, ajaxScript + "parent.$('#isSubmit').remove();");
				
			
			
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);

	}
	
	@RequestMapping(value="/DelProjectInfo.do")
	public String DelProjectInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap<String, String> target = new HashMap<String, String>();
		Map<String, String> setMap = new HashMap<String, String>();
		
		try {
			String[] arrayStr =  StringUtil.checkNull(request.getParameter("items")).split(",");
			if(arrayStr != null){
				for(int i = 0 ; i < arrayStr.length; i++){
					setMap.put("ItemID", arrayStr[i]); 
					commonService.delete("project_SQL.DelProject",setMap);	
				}
			}			
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "this.doSearchClassList();this.$('#isSubmit').remove();");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);		
	}
	
	
	@RequestMapping("/projectInfo.do")
	public String projectInfo(HttpServletRequest request, HashMap<String, Object> commandMap, ModelMap model)throws Exception{
		try{
			Map<String, Object> getMap = new HashMap<String, Object>();
			getMap = commonService.select("project_SQL.getProjectInfo", commandMap);			
			model.put("getMap", getMap);
			model.put("s_itemID", StringUtil.checkNull(commandMap.get("s_itemID") ,""));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/project/pjt/projectInfo");
	}

	@RequestMapping("/projectGroupInfoview.do")
	public String projectGroupInfoview(HttpServletRequest request, HashMap<String, Object> commandMap, ModelMap model)throws Exception{
		try{
			Map<String, Object> getMap = new HashMap<String, Object>();
			String isNew = StringUtil.checkNull(request.getParameter("isNew"));
			String isPjtMgt = StringUtil.checkNull(request.getParameter("isPjtMgt"));
			
			if ("N".equals(isNew) || "R".equals(isNew)) {
				commandMap.put("s_itemID", request.getParameter("s_itemID"));
				commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
				getMap = commonService.select("project_SQL.getProjectInfoView", commandMap);
			}
			
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
		return nextUrl("/project/pjt/projectGroupInfoView");
	}
	

	@RequestMapping(value = "/selectPjtMember.do")
	public String selectPjtMember(HttpServletRequest request, HashMap<String, Object> commandMap, ModelMap model) throws Exception {
		Map<String, Object> getMap = new HashMap<String, Object>();
		try {
			String screenMode = StringUtil.checkNull(request.getParameter("screenMode"));
			String listEditable = StringUtil.checkNull(request.getParameter("listEditable"));
			String isProject = StringUtil.checkNull(request.getParameter("isProject"));
			String variantID = StringUtil.checkNull(request.getParameter("variantID"));
			String isPjtMgt = StringUtil.checkNull(request.getParameter("isPjtMgt"));
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
			String csrId = StringUtil.checkNull(request.getParameter("csrId"));
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			String teamID = StringUtil.checkNull(request.getParameter("teamID"));
			String authorID = StringUtil.checkNull(request.getParameter("authorID"));
            String parentID = StringUtil.checkNull(request.getParameter("parentID"));
			List pjtRelTeamList = new ArrayList();
			System.out.println(listEditable);
			if ("N".equals(listEditable)) {
				// get 조직
				commandMap.put("projectID", projectID);
				pjtRelTeamList = commonService.selectList("project_SQL.getPjtRelTeam", commandMap);
				
				// get Project 정보
				commandMap.put("s_itemID", projectID);
				getMap = commonService.select("project_SQL.getProjectInfoView", commandMap);
			}
			
			model.put("csrId", csrId);
			model.put("screenMode", screenMode);
			model.put("listEditable", listEditable);
			model.put("isProject", isProject);
			model.put("variantID", variantID);
			model.put("isPjtMgt", isPjtMgt);
			model.put("authorID", authorID);
			model.put("projectID", projectID);
			model.put("parentID", parentID);
			model.put("UserLevel", StringUtil.checkNull(request.getParameter("UserLevel")));
			model.put("pjtRelTeamList", pjtRelTeamList);
			model.put("screenType", screenType);
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("getMap", getMap);
			model.put("teamID", teamID); 
			model.put("menu", getLabel(request, commonService)); /*Label Setting*/		
			
			
			
			commandMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			commandMap.put("UserLevel", "ALL");
			commandMap.put("scrnTypr", "PJT");
			List<Map<String, Object>> spmList = commonService.selectList("project_SQL.getPjtWorkerList_gridList",commandMap);
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			
			JSONArray gridData = new JSONArray(spmList);
			model.put("gridData",gridData);
			
			
			
		
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/project/pjt/selectPjtMember");
	}
	
	/**
	 * 관리자 --> 프로젝트  --> member 추가
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/managePjtMember.do")
	public String managePjtMember(HttpServletRequest request, HashMap<String, Object> commandMap, ModelMap model) throws Exception {
		Map<String, Object> getMap = new HashMap<String, Object>();
		try {
			String isNew = StringUtil.checkNull(request.getParameter("isNew"));
			String listEditable = StringUtil.checkNull(request.getParameter("listEditable"));
			String isPjtMgt = StringUtil.checkNull(request.getParameter("isPjtMgt"));
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			String teamID = StringUtil.checkNull(request.getParameter("teamID"));

			List pjtRelTeamList = new ArrayList();
			
			if ("N".equals(listEditable)) {
				// get 조직
				commandMap.put("projectID", projectID);
				pjtRelTeamList = commonService.selectList("project_SQL.getPjtRelTeam", commandMap);
				
				// get Project 정보
				commandMap.put("s_itemID", projectID);
				getMap = commonService.select("project_SQL.getProjectInfoView", commandMap);
			}
			
			model.put("isNew", isNew);
			model.put("listEditable", listEditable);
			model.put("isPjtMgt", isPjtMgt);
			model.put("projectID", projectID);
			model.put("parentID", StringUtil.checkNull(request.getParameter("parentID")));
			model.put("UserLevel", StringUtil.checkNull(request.getParameter("UserLevel")));
			model.put("pjtRelTeamList", pjtRelTeamList);
			model.put("screenType", screenType);
			model.put("getMap", getMap);
			model.put("teamID", teamID); 
			model.put("menu", getLabel(request, commonService)); /*Label Setting*/		
		
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/project/pjt/managePjtMember");
	}
	
	@RequestMapping(value = "/searchPjtMemberPop.do")
	public String searchPjtMemberPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {
				model.put("searchValue", request.getParameter("searchValue"));
				List getList = new ArrayList();
				Map<String, Object> setMap = new HashMap<String, Object>();
				String projectID = StringUtil.checkNull(request.getParameter("projectID"));
				
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("searchKey", request.getParameter("searchKey"));				
				setMap.put("searchValue", request.getParameter("searchValue"));
				setMap.put("teamID", commandMap.get("teamID"));
				setMap.put("projectID", projectID);
				getList = commonService.selectList("project_SQL.getPjtWorkerList_gridList",setMap) ;
				
				model.put("getList", getList);			
				model.put("projectID", projectID);
				model.put("teamID", commandMap.get("teamID"));
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl("/project/pjt/searchPjtMemberPop");
	}
	
	/**
	 * 관리자 --> 프로젝트  --> member --> add --> select
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/insertPjtMembers.do")
	public String insertPjtMembers(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		HashMap<String, String> target = new HashMap<String, String>();
		HashMap<String, Object> setMap = new HashMap<String, Object>();

		try {

			String memberIds = StringUtil.checkNull(request.getParameter("memberIds"));
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
			
			setMap.put("ProjectID", projectID);
			String[] arrayMember = memberIds.split(",");
			for(int i = 0 ; i < arrayMember.length; i++){
				String memberId = arrayMember[i];
				setMap.put("MemberID", memberId);
				commonService.insert("project_SQL.createPjtMemberRel", setMap);				
			}
			
			List<HashMap<String, String>> receiverList = new ArrayList<HashMap<String, String>>();
			
			HashMap<String, String> receiverMap = new HashMap<String, String>();
			for(int i = 0 ; i < arrayMember.length; i++){
				String memberId = arrayMember[i];
				receiverMap = new HashMap<String, String>();
				receiverMap.put("receiptUserID", memberId);
				receiverList.add(i,receiverMap);	
			}
					
			Map<String, Object> setMailData = new HashMap<String, Object>(); 

			setMap.put("projectID", projectID);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			String projectName = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectName",setMap)) ;
			
			setMailData.put("receiverList",receiverList);
			setMailData.put("LanguageID",StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				
			Map setMailMap = (Map)setEmailLog(request, commonService, setMailData, "CSRNTC"); //결제 상신 메일 전송
			if(StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")){
				HashMap<String, Object> mailMap = (HashMap<String, Object>)setMailMap.get("mailLog");
				
				Map<String, Object> temp = new HashMap<String, Object>();
				temp.put("Category", "EMAILCODE"); 
				temp.put("TypeCode", "CSRNTC");
				temp.put("LanguageID", commandMap.get("sessionCurrLangType"));
				Map<String, Object> emDescription = commonService.select("common_SQL.label_commonSelect", temp);
				mailMap.put("emDescription",emDescription.get("Description"));
				mailMap.put("mailSubject",emDescription.get("LABEL_NM") + " " + projectName);
				
				Map resultMailMap = EmailUtil.sendMail(mailMap,mailMap,getLabel(request, commonService));
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMap.get("type")));
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMap.get("msg")));
			}

			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			
			model.put("screenType", screenType);
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 성공															
			target.put(AJAX_SCRIPT, "this.fnCallBack();this.close();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * 관리자 --> 프로젝트  --> member --> assignmembers
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/assignMembers.do")
	public String assignMembers(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap<String, String> target = new HashMap<String, String>();
		HashMap<String, String> setMap = new HashMap<String, String>();
		try {
				String memberIds = StringUtil.checkNull(commandMap.get("memberIds"));
				String teamID = StringUtil.checkNull(commandMap.get("teamID"));
				String projectID = StringUtil.checkNull(commandMap.get("projectID"));
						
				String[] arrayMember = memberIds.split(",");
				setMap.put("teamID", teamID);	
				setMap.put("ProjectID", projectID);
				commonService.delete("project_SQL.delPjtMemberRel", setMap);	// projectID,teamID 일치하는것 모두 삭제 
				if(!memberIds.equals("")){
					for(int i = 0 ; i < arrayMember.length; i++){
						String memberId = arrayMember[i];
						setMap.put("MemberID", memberId);
						commonService.delete("project_SQL.createPjtMemberRel", setMap);				
					}
				}
			
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 성공															
				target.put(AJAX_SCRIPT, "this.fnCallBack();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	
	/**
	 * 관리자 --> 프로젝트  --> member --> del
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/delPjtMembers.do")
	public String delPjtMembers(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		HashMap<String, String> target = new HashMap<String, String>();
		HashMap<String, String> setMap = new HashMap<String, String>();

		try {

			String memberIds = StringUtil.checkNull(request.getParameter("memberIds"));
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
			
			setMap.put("ProjectID", projectID);
			String[] arrayMember = memberIds.split(",");
			for(int i = 0 ; i < arrayMember.length; i++){
				String memberId = arrayMember[i];
				setMap.put("MemberID", memberId);
				commonService.delete("project_SQL.delPjtMemberRel", setMap);				
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 성공															
			target.put(AJAX_SCRIPT, "this.reloadMemberList();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	
	
	/**
	 * [My Project List]
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/myProjectList.do")
	public String myProjectList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map<String, Object> setMap = new HashMap<String, Object>();	
		try {

			setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			setMap.put("ProjectType", "PG");	
			String refPGID =  StringUtil.checkNull(request.getParameter("projectID"));		
			String authorID =  StringUtil.checkNull(request.getParameter("authorID"));	
			String status =  StringUtil.checkNull(request.getParameter("status"));		
			String currPage = StringUtil.checkNull(request.getParameter("currPage"),"0");
			setMap.put("RefPGID", refPGID);
			
			List pgList = commonService.selectList("project_SQL.getParentPjtList", setMap);

			setMap.put("category", "PJTSTS");
		
			List statusList = commonService.selectList("common_SQL.getDictionaryOrdStnm_commonSelect", setMap);
			
			setMap.put("AuthorID", commandMap.get("sessionUserId"));
			
			List myPGList = commonService.selectList("project_SQL.getParentPjtList", setMap);
			
			if(myPGList != null && !myPGList.isEmpty()) {
				model.put("createPG","Y");
			}
			
			
			model.put("status",status);
			model.put("pgList", pgList);
			model.put("refPGID", refPGID);
			model.put("statusList", statusList);
			model.put("authorID", authorID);
			model.put("filter", StringUtil.checkNull(request.getParameter("filter"),"PJT"));
			model.put("screenType", StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("screenType"))));
			model.put("mbrType", StringUtil.checkNull(request.getParameter("mbrType")));
			model.put("mainType", StringUtil.checkNull(request.getParameter("mainType")));
			model.put("refID", StringUtil.checkNull(request.getParameter("projectID")));
			model.put("mainVersion", StringUtil.checkNull(request.getParameter("mainVersion"),""));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("currPage", currPage);
			
			commandMap.put("filter", model.get("filter"));
			commandMap.put("languageID",  String.valueOf(commandMap.get("sessionCurrLangType")));
			commandMap.put("screenType", model.get("screenType"));
			commandMap.put("refID", model.get("refID"));
			commandMap.put("pageNum", currPage);
			List<Map<String, Object>> prjList = commonService.selectList("project_SQL.getSetProjectList_gridList",commandMap);
			
			JSONArray gridData = new JSONArray(prjList);
			model.put("gridData",gridData);
	
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/project/pjt/myProjectList");
	}
	
	/**
	 * [Project 관리 Menu]
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/projectMainMenu.do")
	public String projectMainMenu(HttpServletRequest request, HashMap<String, Object> commandMap, ModelMap model) throws Exception {
		String url = "/project/pjt/projectMainMenu";
		try {
			Map<String, Object> setMap = new HashMap<String, Object>();
			String projectID = StringUtil.checkNull(request.getParameter("s_itemID"));
			setMap.put("s_itemID", projectID);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			Map<String, Object> pjtInfoMap = commonService.select("project_SQL.getProjectInfoView", commandMap);
			
			model.put("s_itemID", projectID);
			model.put("projectName", StringUtil.checkNull(pjtInfoMap.get("ProjectName")));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e.toString());
			throw new Exception("EM00001");
		}

		return nextUrl(url);
	}
	
	@RequestMapping("/registerProject.do")
	public String registerProject(HttpServletRequest request, HashMap<String, Object> commandMap, ModelMap model)throws Exception{
		try{
			Map<String, Object> getMap = new HashMap<String, Object>();
			Map setData = new HashMap();
			String csrStatus = "";
			Map<String, Object> pjtInfoMap = commonService.select("project_SQL.getProjectInfoView", commandMap);
			String refID = StringUtil.checkNull(request.getParameter("refID"),"");
			
			if("".equals(refID)) {
				getMap.put("languageID",commandMap.get("sessionCurrLangType"));
				getMap.put("authorID",commandMap.get("sessionUserId"));
				getMap.put("projectType","PG");
				List myPGList = commonService.selectList("common_SQL.getProject_commonSelect", getMap);
				
				if(myPGList != null && !myPGList.isEmpty()) {
					model.put("createPG","Y");
				}
			
			}
			// N-생성, R-조회, E-편집
			String pjtMode = StringUtil.checkNull(request.getParameter("pjtMode"));
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));	
			model.put("refID", StringUtil.checkNull(request.getParameter("refID")));
			model.put("PGName", StringUtil.checkNull(pjtInfoMap.get("ProjectName")));
			model.put("PGCode", StringUtil.checkNull(pjtInfoMap.get("ProjectCode")));
			model.put("getMap", getMap);
			model.put("pjtMode", pjtMode);
			model.put("csrStatus", csrStatus);
			model.put("screenType", screenType);
		//	model.put("issueStatus", issueStatus);
			model.put("s_itemID", StringUtil.checkNull(commandMap.get("s_itemID") ,""));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/project/pjt/registerProject");
	}
	
	/**
	 * 관리자 --> 프로젝트  --> taskType 추가
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectPjtTaskType.do")
	public String selectPjtTaskType(HttpServletRequest request, HashMap<String, Object> commandMap, ModelMap model) throws Exception {
		Map<String, Object> getMap = new HashMap<String, Object>();
		try {
			
			String isNew = StringUtil.checkNull(request.getParameter("isNew"));
			String listEditable = StringUtil.checkNull(request.getParameter("listEditable"));
			String isPjtMgt = StringUtil.checkNull(request.getParameter("isPjtMgt"));
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			List pjtRelTeamList = new ArrayList();
			
			model.put("isNew", isNew);
			model.put("listEditable", listEditable);
			model.put("isPjtMgt", isPjtMgt);
			model.put("projectID", projectID);
			model.put("pjtRelTeamList", pjtRelTeamList);
			model.put("getMap", getMap);
			model.put("screenType", screenType);
			model.put("menu", getLabel(request, commonService)); /*Label Setting*/	
			if ("N".equals(listEditable)) {
				// get 조직
				//commandMap.put("projectID", projectID);
				//pjtRelTeamList = commonService.selectList("project_SQL.getPjtRelTeam", commandMap);
				
				// get Project 정보
				commandMap.put("s_itemID", projectID);
				getMap = commonService.select("project_SQL.getProjectInfoView", commandMap);
				commandMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
				List<Map<String, Object>> sPjtList = commonService.selectList("project_SQL.getPjtTaskTypeList_gridList", commandMap);
				JSONArray gridData = new JSONArray(sPjtList);
				model.put("gridData", gridData);
			}else {
				commandMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
				commandMap.put("projectID", projectID);
				List<Map<String, Object>> tPjtList = commonService.selectList("project_SQL.getTaskTypeForPjtList_gridList", commandMap);
				JSONArray gridData = new JSONArray(tPjtList);
				model.put("gridData", gridData);
				
			}
	
		
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/project/pjt/selectPjtTaskType");
	}
	
	/**
	 * 관리자 --> 프로젝트  --> taskTypeCode --> insert
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/insertPjtTaskType.do")
	public String insertPjtTaskType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap<String, String> target = new HashMap<String, String>();
		HashMap<String, Object> setMap = new HashMap<String, Object>();
		try {
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
			String taskTypeCodes = StringUtil.checkNull(request.getParameter("taskTypeCodes"));
			String itemClassCodes = StringUtil.checkNull(request.getParameter("itemClassCodes"));
			
			setMap.put("projectID", projectID);
			String[] arrayTaskTypeCode = taskTypeCodes.split(",");
			String[] arrayItemClassCode = itemClassCodes.split(",");

			for(int i = 0 ; i < arrayTaskTypeCode.length; i++){
				String taskTypeCode = arrayTaskTypeCode[i];
				String itemClassCode = arrayItemClassCode[i];
				String sortNum = StringUtil.checkNull(commonService.selectString("project_SQL.getMaxTaskTypeSortNum", setMap)).trim();
				
				setMap.put("taskTypeCode", taskTypeCode);
				setMap.put("itemClassCode", itemClassCode);
				setMap.put("sortNum", sortNum);
				setMap.put("userID", commandMap.get("sessionUserId"));
				
				commonService.insert("project_SQL.insertPjtTaskTypeCode", setMap);				
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 														
			target.put(AJAX_SCRIPT, "this.fnCallBack();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * 관리자 --> 프로젝트  --> taskTypeCode --> delete
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/deletePjtTaskTypeCode.do")
	public String deletePjtTaskTypeCode(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap<String, String> target = new HashMap<String, String>();
		HashMap<String, String> setMap = new HashMap<String, String>();
		try {
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
			String taskTypeCodes = StringUtil.checkNull(request.getParameter("taskTypeCodes"));
			
			setMap.put("projectID", projectID);
			String[] arrayTaskTypeCode = taskTypeCodes.split(",");

			for(int i = 0 ; i < arrayTaskTypeCode.length; i++){
				String taskTypeCode = arrayTaskTypeCode[i];
				setMap.put("taskTypeCode", taskTypeCode);				
				commonService.delete("project_SQL.deletePjtTaskTypeCode", setMap);				
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); 														
			target.put(AJAX_SCRIPT, "this.fnCallBack();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * 관리자 --> 프로젝트  --> taskTypeCode -->Update sortNum,mandatory 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveTaskTypeInfo.do")
	public String saveTaskTypeInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap<String, String> target = new HashMap<String, String>();
		HashMap<String, Object> setMap = new HashMap<String, Object>();
		try {
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
			String taskTypeCode = StringUtil.checkNull(request.getParameter("taskTypeCode"));
			String sortNum = StringUtil.checkNull(request.getParameter("sortNum"));
			String mandatory = StringUtil.checkNull(request.getParameter("mandatory"));
			
			setMap.put("projectID", projectID);
			setMap.put("taskTypeCode", taskTypeCode);
			setMap.put("sortNum", sortNum);
			setMap.put("mandatory", mandatory);
			setMap.put("userID", commandMap.get("sessionUserId"));
			commonService.insert("project_SQL.udpatePjtTaskTypeInfo", setMap);				
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 														
			target.put(AJAX_SCRIPT, "this.doPSearchList();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * My page --> Contents --> ITEM --> My Item tree grid
	 * @param request
	 * @param cmmMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/myItemTreeDiagramList.do")
	public String myItemTreeDiagramList(HttpServletRequest request, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		String url = "/project/changeInfo/myItemTreeDiagramList";
		try {
			
			String status = StringUtil.checkNull(request.getParameter("Status"));
			String classCode = StringUtil.checkNull(request.getParameter("ClassCode"));
			String csrID = StringUtil.checkNull(request.getParameter("csrID"));
			
			cmmMap.put("Status", status);
			cmmMap.put("ClassCode", classCode);
			List myItemList = (List) commonService.selectList("project_SQL.getMyItemForMyPage", cmmMap);
			
			// 클래스 리스트
			cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			List classCodeList = (List) commonService.selectList("common_SQL.classCodeMgtOption_commonSelect", cmmMap);
			
			// Check In 표시 유무, 로그인 유저에게 할당 되어 있는 CSR 중, 완료 되지 않은 리스트 취득
			cmmMap.put("userId", cmmMap.get("sessionUserId"));
			cmmMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
			cmmMap.put("ProjectType", "CSR");
			cmmMap.put("isMainItem", "Y");
			List projectNameList = (List) commonService.selectList("project_SQL.getProjectNameList", cmmMap);
			
			model.put("classCodeList", classCodeList);
			model.put("projectNameList", projectNameList);
			model.put("selectedStatus", status);
			model.put("selectedClassCode", classCode);
			model.put("myItemTreeXml", setMyItemXML(myItemList));
			model.put("ttl", myItemList.size());
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("csrID", csrID);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return nextUrl(url);
	}
	
	private String setMyItemXML(List myItemList) {
		String CELL = "	<cell></cell>";
		String CELL_CHECK = "	<cell>0</cell>";
		String CELL_OPEN = "	<cell>";
		String CELL_CLOSE = "</cell>";
		String ROW_CLOSE = "</row>";
		
		int cellCnt = 7; // 표시 할 칼럼 수
		int rowId = 1; // row ID 를 unique 하게 설정 하기 위한 seq
		int pathRowId = 1;
		int newTypeFlg = 0;
		String curItemTypeCode = "";
		String curPath = "";
		String result = "<rows>";
		
		for (int i = 0; i < myItemList.size(); i++) {
			Map myItemMap = (Map) myItemList.get(i);
			String itemTypeCode = StringUtil.checkNull(myItemMap.get("ItemTypeCode"));
			String itemTypeName = StringUtil.checkNull(myItemMap.get("ItemTypeName"));
			String path = StringUtil.checkNull(myItemMap.get("Path"));
			
			/* 항목 유형 row 값 설정 */
			if (!curItemTypeCode.equals(itemTypeCode)) {
				curItemTypeCode = itemTypeCode; // 다음 비교를 위해 비교 [유형] 값을 담아둠
				newTypeFlg = 1;
				pathRowId = 1;
				if (i != 0) {
					result += ROW_CLOSE + ROW_CLOSE;
				}
				result += "<row id='" + curItemTypeCode + "' open='1' style='font-weight:bold'>";
				result += CELL_CHECK;
				result += "	<cell image='"
						+ StringUtil.checkNull(myItemMap.get("ItemTypeImg"))
						+ "'> " + itemTypeName + CELL_CLOSE;
				
				for (int j = 0; j < cellCnt; j++) {
					result += CELL;
				}
			}
			
			/* Path row 값 설정 */
			if (!curPath.equals(path)) {
				curPath = path; // 다음 비교를 위해 비교 [Path] 값을 담아둠
				if (i != 0) {
					if (newTypeFlg != 1) {
						result += ROW_CLOSE;
					}
				}
				newTypeFlg = 0;
				result += "<row id='" + curItemTypeCode + pathRowId + "' open='1' style='font-weight:bold'>";
				result += CELL_CHECK;
				result += "<cell image='"
						+ StringUtil.checkNull(myItemMap.get("ItemTypeImg")) + "'> "
						+ path + CELL_CLOSE;
				
				for (int j = 0; j < cellCnt; j++) {
					result += CELL;
				}
				pathRowId++;
			}
			
				
			/* Item row 값 설정 */
			result += "<row id='" + rowId + "'>";
			// cell : 0
			result += CELL_CHECK;
			// cell : 1
			result += "		" + "<cell image='"
					+ StringUtil.checkNull(myItemMap.get("ItemTypeImg")) + "'> "
					+ StringUtil.checkNull(myItemMap.get("Identifier"))
					+ " "
					+ StringUtil.checkNull(myItemMap.get("ItemName")).replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ")
					+ CELL_CLOSE;
			// cell : 2
			result += "		" + CELL_OPEN
					+ StringUtil.checkNull(myItemMap.get("PjtName")).replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ")
					+ CELL_CLOSE;
			// cell : 3
			result += "		" + CELL_OPEN
					+ StringUtil.checkNull(myItemMap.get("CsrName")).replace("<", "(").replace(">", ")").replace(GlobalVal.ENCODING_STRING[3][1], " ").replace(GlobalVal.ENCODING_STRING[3][0], " ").replace(GlobalVal.ENCODING_STRING[4][1], " ").replace(GlobalVal.ENCODING_STRING[4][0], " ")
					+ CELL_CLOSE;
			// cell : 4
			result += "		" + CELL_OPEN
					+ StringUtil.checkNull(myItemMap.get("OwnerTeamName"))
					+ CELL_CLOSE;
			// cell : 5
			result += "		" + CELL_OPEN
					+ StringUtil.checkNull(myItemMap.get("LastUpdated"))
					+ CELL_CLOSE;
			// cell : 6
			result += "		" + CELL_OPEN
					+ StringUtil.checkNull(myItemMap.get("StatusName"))
					+ CELL_CLOSE;
			// cell : 7
			result += "		" + CELL_OPEN
					+ StringUtil.checkNull(myItemMap.get("ItemID"))
					+ CELL_CLOSE;
			// cell : 8
			result += "		" + CELL_OPEN
					+ StringUtil.checkNull(myItemMap.get("Status"))
					+ CELL_CLOSE;
			
			result += ROW_CLOSE;
			rowId++;
		}
		
		result += ROW_CLOSE + ROW_CLOSE + "</rows>";
		System.out.println( " result :: "+result.replace("&", "/"));
		return result.replace("&", "/"); // 특수 문자 제거
	}
	
	/**
	 * [변경 요청 검색, 조회, 생성]
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/csrList.do")
	public String csrList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		String url = "/project/pjt/csrList";
		Map<String, Object> setMap = new HashMap<String, Object>();

		try {

			String mainMenu = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("mainMenu")));
			setMap.put("LanguageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			setMap.put("ProjectType", "PJT");			
			String projectID =  StringUtil.checkNull(request.getParameter("projectID"));
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			String mainType = StringUtil.checkNull(request.getParameter("mainType"));	
			String status = StringUtil.checkNull(request.getParameter("Status"));	
			String mbrType = StringUtil.checkNull(request.getParameter("mbrType"));	
			String memberID = StringUtil.checkNull(request.getParameter("memberID"));	
		    String currPage = StringUtil.checkNull(request.getParameter("currPage"), "0");
			if (!projectID.isEmpty()) {
				if(screenType.equals("PG")){
					setMap.put("RefPGID", projectID);
				}else{
					setMap.put("RefPjtID", projectID);
				}
			}
			
			if(screenType.equals("pjtInfoMgt")){
				setMap.remove("RefPjtID");
			}

			setMap.put("Status", "1");
			List pjtList = commonService.selectList("project_SQL.getParentPjtList", setMap);
			
			setMap.put("ProjectType", "PG");			
			
			List pgList = commonService.selectList("project_SQL.getParentPjtList", setMap);
			setMap.remove("ProjectType");
			// 등록 가능자 인지 판단
			setMap.put("openPJT", "Y");
			setMap.put("loginUserId", commandMap.get("sessionUserId"));
			List pjtListFromRel = commonService.selectList("project_SQL.getParentPjtFromRel", setMap);
		//	setMap.remove("ProjectID");
		//	setMap.remove("Status");
			
	//		if (mainMenu.equals("3")) {
	//			setMap.put("TypeCode", "'APRV'"); // 승인요청
	//		}
			List statusList = commonService.selectList("project_SQL.getCsrStatusList", setMap);
			
			/* 등록일 설정 FromDate:시스템 날짜에서 최근 3개월, ToDate:시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			cal.add(Calendar.MONTH, -3);
			String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("mainMenu", mainMenu);
			model.put("statusList", statusList);
			model.put("pjtList", pjtList);
			model.put("pgList", pgList);
			model.put("pjtRelCnt", pjtListFromRel.size());
			model.put("refPjtID", projectID);
			model.put("projectID", projectID);
			model.put("memberID", memberID);
			model.put("csrStatus", StringUtil.checkNull(request.getParameter("csrStatus")));
			
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("currPage", currPage);
			model.put("screenType", screenType);
			model.put("memberId", StringUtil.checkNull(request.getParameter("memberId")));
			model.put("status", status);
			model.put("mainType", mainType);
			model.put("mbrType",mbrType);
			model.put("companyID",StringUtil.checkNull(request.getParameter("companyID")));
			model.put("refPGID",StringUtil.checkNull(request.getParameter("refPGID")));
			
			

			commandMap.put("filter", "CSR");
			commandMap.put("csrStatus", model.get("csrStatus"));
			commandMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			commandMap.put("screenType", screenType);
			commandMap.put("pageNum", model.get("currPage"));
			
			List<Map<String, Object>>   csrList = commonService.selectList("project_SQL.getSetProjectListForCsr_gridList",commandMap);
			JSONArray gridData = new JSONArray(csrList);
			model.put("gridData",gridData);

			
			
		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
		
	@RequestMapping("/registerCSR.do")
	public String registerCSR(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "project/pjt/registerCSR";
		Map<String, Object> setMap = new HashMap<String, Object>();
		Map setData = new HashMap();

		try {			
			String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String btn = StringUtil.checkNull(request.getParameter("btn"));
			String cngCountOfmember = "";
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			String srID = StringUtil.checkNull(request.getParameter("srID")); 
			String refPjtID = StringUtil.checkNull(request.getParameter("refPjtID"));
			String refID = StringUtil.checkNull(request.getParameter("refID"));
		
		
			/* 등록일 설정 FromDate:시스템 날짜에서 최근 한달, ToDate:시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			cal.add(Calendar.DAY_OF_MONTH, 14);
			String dueYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			
			setMap.put("openSts", "OPN");
			setMap.put("refPGID", refID);
			setMap.put("loginUserId", commandMap.get("sessionUserId"));
			List parentPjtList = commonService.selectList("project_SQL.getParentPjtFromRel", setMap);
			String refPjtAuthorID = commonService.selectString("project_SQL.getPjtAuthorID", setMap);
			setMap.remove("ProjectID");

			/* 임시 문서 보관 디렉토리 삭제 */
			String path = GlobalVal.FILE_UPLOAD_BASE_DIR + commandMap.get("sessionUserId");
			FileUtil.deleteDirectory(path);
		
			
			setData.remove("Status");
			model.put("srID", srID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("btn", btn);
			model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID")));
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1")); // 개요화면 일때, 변경오더와 동일
			model.put("parentPjtList", parentPjtList);
			model.put("pjtFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			model.put("dueYmd", dueYmd);
			model.put("thisYmd", thisYmd);
			model.put("defaultCreator", StringUtil.checkNull(commandMap.get("sessionUserNm")));
			setMap.put("Category", "CSRSTS");
			setMap.put("TypeCode", "CNG");
			model.put("defaultStatus", commonService.selectString("project_SQL.getDictionaryName", setMap));
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("listEditable", StringUtil.checkNull(request.getParameter("listEditable")));
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("fromSR", StringUtil.checkNull(request.getParameter("fromSR")));
			model.put("fromITSP", StringUtil.checkNull(request.getParameter("fromITSP")));
			// Tree >> ITEM >> [개요] >> [변경 이력]
			model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
			model.put("useCR", GlobalVal.USE_COMP_CR);
			model.put("refPjtAuthorID", refPjtAuthorID);
			model.put("quickCheckOut", StringUtil.checkNull(request.getParameter("quickCheckOut")));
			model.put("itemID", StringUtil.checkNull(request.getParameter("itemID")));

			setMap.put("srID", srID);
			setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
			HashMap<String, Object> srInfoMap = (HashMap<String, Object>)commonService.select("esm_SQL.getESMSRInfo", setMap);
			model.put("srInfoMap", srInfoMap);
			model.put("blockSR", StringUtil.checkNull(request.getParameter("blockSR")));
			model.put("srType", StringUtil.checkNull(request.getParameter("srType")));
			model.put("refPjtID", refPjtID);
			model.put("checkType", StringUtil.checkNull(request.getParameter("checkType")));
			
		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}

	@RequestMapping("/csrDetail.do")
	public String csrDetail(HttpServletRequest request, HashMap<String, Object> commandMap, ModelMap model) throws Exception {
		String url = "project/pjt/csrDetail";
		Map<String, Object> setMap = new HashMap<String, Object>();
		Map<String, Object> getMap = new HashMap<String, Object>();
		Map<String, Object> setData = new HashMap<String, Object>();
		List attachFileList = new ArrayList();

		try {			
			String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String isManager = "N";
			String isMember = "N";
			String screenMode = StringUtil.checkNull(request.getParameter("screenMode"));
			String btn = StringUtil.checkNull(request.getParameter("btn"));
			String cngCountOfmember = "";
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String refPjtID = StringUtil.checkNull(request.getParameter("refPjtID"));
			
			
			//setMap.put("ProjectID", refPjtID);
			//setMap.put("Status", "CLS");
			setMap.put("openPJT", "Y");
			setMap.put("loginUserId", commandMap.get("sessionUserId"));
			setMap.put("ProjectID", refPjtID);
			List parentPjtList = commonService.selectList("project_SQL.getParentPjtFromRel", setMap);
			String refPjtAuthorID = commonService.selectString("project_SQL.getPjtAuthorID", setMap);
			setMap.remove("ProjectID");
			
			setMap.remove("loginUserId");
			setMap.put("ProjectID", request.getParameter("ProjectID"));
			getMap = commonService.select("project_SQL.getSetProjectListForCsr_gridList", setMap);
			model.put("ProjectCode", getMap.get("ProjectCode"));
			
			String Description = StringUtil.checkNull(getMap.get("Description"),"");
			Description = StringUtil.replaceFilterString(Description);
			getMap.put("Description", Description);
			model.put("getMap", getMap);
										
			/* 담당자별 할당된 변경 항목 건수 취득 */
			String memberIds = StringUtil.checkNull(getMap.get("PjtMemberIDs"));
			
			if (!memberIds.isEmpty()) { 
				String[] membersArray = memberIds.split(", ");
				setMap.put("projectID", request.getParameter("ProjectID"));
				for (int i = 0; membersArray.length > i;i++ ) {
					setMap.put("AuthorID", membersArray[i]);
					String cnt = commonService.selectString("cs_SQL.getProjectItemCount", setMap);
					if (cngCountOfmember.isEmpty()) {
						cngCountOfmember = cnt;
					} else {
						cngCountOfmember = cngCountOfmember + "," + cnt;
					}
				}
			}
			
			model.put("cngCountOfmember", cngCountOfmember);
			
			/* 로그인 유저가 해당 프로젝트의 담당자 여부 확인 : TB_PROJECT.Creator or TB_PROJECT.AuthorID */
			String csrEditable = "N";
			String authorID = StringUtil.checkNull(getMap.get("AuthorID"));
			if (loginUser.equals(authorID)) {
				isManager = "Y";
				String status = StringUtil.checkNull(getMap.get("Status"));
				if(status.equals("CSR") || status.equals("CNG") || status.equals("HOLD")){
					csrEditable = "Y";
				}
			}
			model.put("csrEditable", csrEditable);
			
			setData.put("ProjectID", request.getParameter("ProjectID"));
			setData.put("MemberID", commandMap.get("sessionUserId"));
			String pjtMemberRelCnt = commonService.selectString("project_SQL.getPjtMemberRelCnt", setData);
			if(pjtMemberRelCnt.equals("1")){
				isMember = "Y";
			}
			
			setData = new HashMap<String, Object>();
			/* 첨부문서 취득 */
			// attachFileList = commonService.selectList("project_SQL.getProjectFileList", setMap); // 20151229 Pjt_File -> Item_File 변경
			attachFileList = commonService.selectList("project_SQL.getPjtFileList", commandMap);
		

		/* 등록일 설정 FromDate:시스템 날짜에서 최근 한달, ToDate:시스템 날짜 */
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date(System.currentTimeMillis()));
		String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
		cal.add(Calendar.DAY_OF_MONTH, 14);
		String dueYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

		
		/* 임시 문서 보관 디렉토리 삭제 */
		String path = GlobalVal.FILE_UPLOAD_BASE_DIR + commandMap.get("sessionUserId");
		FileUtil.deleteDirectory(path);
		
		setData.remove("Status");
		model.put("srID", srID);
		setData.put("csrID", request.getParameter("ProjectID"));
		model.put("CRCNT", StringUtil.checkNull(commonService.selectString("project_SQL.getCRCount", setData)));				
		//model.put("csrCompletChk", csrCompletChk);
		model.put("menu", getLabel(request, commonService)); /* Label Setting */
		model.put("isMember", isMember);
		model.put("isManager", isManager);
		model.put("screenMode", screenMode);
		
		model.put("btn", btn);
		model.put("ProjectID", StringUtil.checkNull(request.getParameter("ProjectID")));
		model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1")); // 개요화면 일때, 변경오더와 동일
		model.put("getMap", getMap);
		model.put("parentPjtList", parentPjtList);
		model.put("pjtFiles", attachFileList);
		model.put("pjtFilePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
		model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
		model.put("dueYmd", dueYmd);
		model.put("thisYmd", thisYmd);
		model.put("defaultCreator", StringUtil.checkNull(commandMap.get("sessionUserNm")));
		setMap.put("Category", "CSRSTS");
		setMap.put("TypeCode", "CNG");
		model.put("refPjtID",refPjtID);
		model.put("defaultStatus", commonService.selectString("project_SQL.getDictionaryName", setMap));
		model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
		model.put("listEditable", StringUtil.checkNull(request.getParameter("listEditable")));
		model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
		model.put("fromSR", StringUtil.checkNull(request.getParameter("fromSR")));
		model.put("fromITSP", StringUtil.checkNull(request.getParameter("fromITSP")));
		// Tree >> ITEM >> [개요] >> [변경 이력]
		model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
		model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));
		model.put("useCR", GlobalVal.USE_COMP_CR);
		model.put("refPjtAuthorID", refPjtAuthorID);
		model.put("quickCheckOut", StringUtil.checkNull(request.getParameter("quickCheckOut")));
		model.put("itemID", StringUtil.checkNull(request.getParameter("itemID")));
			
		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
	
	/**
	 * [변경 요청 상세]:신규 , 편집
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/csrDetailPop.do")
	public String csrDetailPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "project/pjt/csrDetailPop";
		Map<String, Object> setMap = new HashMap<String, Object>();
		Map getMap = new HashMap();
		List attachFileList = new ArrayList();
		try {
				String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
				String screenMode = StringUtil.checkNull(request.getParameter("screenMode"));
				String mainMenu = StringUtil.checkNull(request.getParameter("mainMenu"));
				String refPjtID = StringUtil.checkNull(request.getParameter("refPjtID"));
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String srSubject = StringUtil.checkNull(request.getParameter("srSubject"));
				String srPriority = StringUtil.checkNull(request.getParameter("srPriority"));
				String screenType = StringUtil.checkNull(request.getParameter("screenType"));
				String fromSR = StringUtil.checkNull(request.getParameter("fromSR"));
				setMap.put("projectID", projectID);
				if(refPjtID.equals("")){
					refPjtID = StringUtil.checkNull( commonService.selectString("project_SQL.getRefPjtID", setMap) );
				}
				
				model.put("projectID", projectID);
				model.put("screenMode", screenMode);
				model.put("mainMenu", mainMenu);
				model.put("refPjtID", refPjtID);
				model.put("screenType", screenType);
				model.put("srID", srID);
				model.put("srSubject", srSubject);
				model.put("srPriority", srPriority);
				model.put("fromSR", fromSR);
				model.put("quickCheckOut", StringUtil.checkNull(request.getParameter("quickCheckOut")));
				model.put("itemID", StringUtil.checkNull(request.getParameter("itemID")));

		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
	/**
	 * [변경 오더]화면, [DEL]버튼 이벤트, CSR 리스트 삭제 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/delCsr.do")
	public String delCsr(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		HashMap<String, String> target = new HashMap<String, String>();
		HashMap<String, String> deleteCommandMap = new HashMap<String, String>();

		try {

			String pjtIds = StringUtil.checkNull(request.getParameter("pjtIds"));
			
			// Delete [TB_PROJECT_TXT], [TB_PROJECT]
			deleteCommandMap.put("pjtIds", pjtIds);
			commonService.delete("project_SQL.DelProject", deleteCommandMap);

			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제, 성공															
			target.put(AJAX_SCRIPT, "this.doSearchPjtList();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * [CSR 편집] CSR 변경 담당자 복수 선택 화면
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectPjtAuthor.do")
	public String selectPjtAuthor(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
	
		try {
			model.put("projectID", StringUtil.checkNull(request.getParameter("ProjectID")));
			model.put("csrId", StringUtil.checkNull(request.getParameter("csrId")));
			model.put("menu", getLabel(request, commonService)); /*Label Setting*/		
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			
			
			
			commandMap.put("csrId",model.get("csrId"));
			commandMap.put("languageID",StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
			
			List<Map<String, Object>> authorList = commonService.selectList("project_SQL.getPjtWorkerList_gridList",commandMap);
			
			JSONArray gridData = new JSONArray(authorList);
			model.put("gridData", gridData);
	
			//model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			
	
			
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/project/pjt/selectPjtAuthor");
	}
	
	/**
	 * [사용자 조회]화면, [Add]버튼 이벤트, CSR 담당자를 복수로 추가
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/addPjtMembers.do")
	public String addPjtMembers(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		HashMap<String, String> target = new HashMap<String, String>();
		HashMap<String, Object> setMap = new HashMap<String, Object>();

		try {

			String memberIds = StringUtil.checkNull(request.getParameter("memberIds"));
			String memberInfoList = "";
			
			setMap.put("memberIds", memberIds);
			List list = commonService.selectList("project_SQL.getMemberInfoList", setMap);
			
			for (int i = 0; list.size() > i; i++) {
				Map map = (Map) list.get(i);
				String memberInfo = StringUtil.checkNull(map.get("MemberInfo"));
				
				if (memberInfoList.isEmpty()) {
					memberInfoList = memberInfo;
				} else {
					memberInfoList = memberInfoList + "," + memberInfo;
				}
			}

			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 성공															
			target.put(AJAX_SCRIPT, "this.setInfo('"+ memberIds +"','"+ memberInfoList +"');this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * 업로드된 Project 파일을 삭제
	 * @param cmmMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/pjtFileDelete.do")
	public String pjtFileDelete(HashMap<String, String> commandMap, ModelMap model) throws Exception {
		Map<String, String> target = new HashMap<String, String>();		
		
		try {
			
			String realFile = StringUtil.checkNull(commandMap.get("realFile"));
			File existFile = new File(realFile);
			if(existFile.exists() && existFile.isFile()){existFile.delete();}
			// commonService.delete("project_SQL.delProjectFile", commandMap);	// 20151229 PJT_FILE -> ITEM_FILE 변경
			commonService.delete("project_SQL.delPjtFile", commandMap);	
				
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00075")); // 성공
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00076")); // 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/pjtDirFileDel.do")
	public String pjtDirFileDel(HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();		
		
		try {
			String realFile = GlobalVal.FILE_UPLOAD_BASE_DIR + commandMap.get("sessionUserId") + "\\" + commandMap.get("fileName");
			File existFile = new File(realFile);
			if(existFile.exists() && existFile.isFile()){existFile.delete();}
		}
		catch (Exception e) {
			System.out.println(e);
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}	

	/**
	 * CSR Code 생성 ('CSRYYMMDD000X)
	 * 
	 * @param parentInfoMap
	 * @return
	 * @throws Exception
	 */
	private String setCSRCode() throws Exception {
		HashMap setData = new HashMap();
		String result = "";
		String hyphen = "-";
		long date = System.currentTimeMillis();	
		String maxCSRCode = "";
		
	

		return result;
	}

	@RequestMapping(value = "/admin/saveNewCSRInfo.do")
	public String saveNewCSRInfo(HttpServletRequest request, HashMap<String, Object> commandMap, ModelMap model) throws Exception {
		HashMap<String, String> target = new HashMap<String, String>();
		try {

			HashMap<String, Object> setData = new HashMap<String, Object>();
			List returnData = new ArrayList();
			HashMap<String, Object> insertData = new HashMap<String, Object>();
			HashMap<String, Object> updateData = new HashMap<String, Object>();
			
			String btn = StringUtil.checkNull(request.getParameter("btn"));
			String isEditable = StringUtil.checkNull(request.getParameter("isEditable"));
			String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
			String memberIds = StringUtil.checkNull(request.getParameter("memberIds"));		
			String srID = StringUtil.checkNull(request.getParameter("srID"));		
			String quickCheckOut = StringUtil.checkNull(request.getParameter("quickCheckOut"));	
			String itemAccCtrl = StringUtil.checkNull(request.getParameter("itemAccCtrl"));	
			String maxCSRCode = "";
			String curmaxCSRCode ="";
			String parentID ="";
			String useCR = GlobalVal.USE_COMP_CR;
				
			// get Parent Project Info	
			parentID = StringUtil.checkNull(request.getParameter("ParentPjt"));	
			setData.put("ProjectID", parentID);
			Map<String, Object> parentInfoMap = commonService.select("project_SQL.getParentPjtInfo", setData);
			
			String aprvOption = StringUtil.checkNull(parentInfoMap.get("AprvOption"));
			String status = "CSR";
			if(aprvOption.equals("POST")){ status = "CNG"; }
			if(quickCheckOut.equals("Y")){ status = "CLS"; }
			insertData.put("ProjectType", "CSR");
			insertData.put("Status", status);
			insertData.put("UserID", commandMap.get("sessionUserId")); // Creator
			insertData.put("AuthorID", commandMap.get("sessionUserId")); // Creator
			insertData.put("AuthorName", commandMap.get("sessionUserNm")); // Creator	
			insertData.put("TeamID", commandMap.get("sessionTeamId")); // Creator TeamID
			insertData.put("ParentID", parentID);
			insertData.put("PJCategory", parentInfoMap.get("PJCategory"));
			insertData.put("StartDate", request.getParameter("StartDate"));
			insertData.put("DueDate", request.getParameter("DueDate"));
			insertData.put("TemplCode", parentInfoMap.get("TemplCode"));
			insertData.put("RefPGID", parentInfoMap.get("RefPGID"));
			insertData.put("RefPjtID", parentInfoMap.get("RefPjtID"));
			insertData.put("Priority", request.getParameter("Priority"));
			insertData.put("Reason", request.getParameter("Reason"));
			insertData.put("srID", StringUtil.checkNull(request.getParameter("srID")));
			insertData.put("AprvOption", aprvOption);
			insertData.put("CompanyID", commandMap.get("sessionCompanyId"));
			insertData.put("itemAccCtrl", itemAccCtrl);
			insertData.put("checkInOption", parentInfoMap.get("CheckInOption"));
			insertData.put("closingOption", parentInfoMap.get("ClosingOption"));
			insertData.put("clientID", parentInfoMap.get("ClientID"));
			
			/* 시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyMMdd").format(cal.getTime());
			setData.put("thisYmd", thisYmd);			
			curmaxCSRCode = StringUtil.checkNull(commonService.selectString("project_SQL.getMaxCSRCode", setData)).trim();				
			if(curmaxCSRCode.equals("")){ // 당일 CSR이 없으면
				maxCSRCode = "CSR"  + thisYmd + "0001";
			} else {
				curmaxCSRCode = curmaxCSRCode.substring(curmaxCSRCode.length() - 4, curmaxCSRCode.length());
				int curCSRCode = Integer.parseInt(curmaxCSRCode) + 1;
				maxCSRCode =  "CSR" +  thisYmd + String.format("%04d", curCSRCode);			
			}
							
			insertData.put("ProjectCode", maxCSRCode);
	
			projectID = commonService.selectString("project_SQL.getMaxProjectID", setData);
			insertData.put("ProjectID", projectID);
			commonService.insert("project_SQL.createProject", insertData);
			
			List activatedLangList = commonService.selectList("common_SQL.langType_commonSelect", setData);
			for (int i = 0; activatedLangList.size() > i; i++) {
				Map map = (Map) activatedLangList.get(i);
				String languageId = String.valueOf(map.get("CODE"));
				insertData.put("Name", request.getParameter("ProjectName"));
				insertData.put("languageID", languageId);
				insertData.put("Description",commandMap.get("Description"));
				commonService.insert("project_SQL.createProjectTxt",insertData);
			}
			
			String fromSR = StringUtil.checkNull(request.getParameter("fromSR"));
			String blockSR = StringUtil.checkNull(request.getParameter("blockSR"));
			String srType = StringUtil.checkNull(request.getParameter("srType"));
			String blocked = "";
			if(blockSR.equals("Y")) blocked = "1"; 
			HashMap<String, Object> updateSR = new HashMap<String, Object>();
			// SR있는 경우 생성		
			if(!srID.equals("")){
				updateSR.put("srID", srID);				
				updateSR.put("dueDate", request.getParameter("DueDate"));
				updateSR.put("lastUser", commandMap.get("sessionUserId"));	
				updateSR.put("blocked", blocked);
				updateSR.put("srType", srType);
				updateSR.put("ProjectType", "CSR");
				
				Map esmProcInfo = (Map)decideSRProcPath(request, commonService, updateSR);
				System.out.println(" :esmProcInfo :"+esmProcInfo);
				String procPathID = "";
				String speCode = "";
				if(esmProcInfo != null && !esmProcInfo.isEmpty()){
					procPathID = StringUtil.checkNull(esmProcInfo.get("ProcPathID"));
					speCode = StringUtil.checkNull(esmProcInfo.get("SpeCode"));
					if(!speCode.equals("") && speCode != null) updateSR.put("status", speCode); 
				}
				
//				commonService.update("sr_SQL.updateSRStatus", updateSR);	
				commonService.update("esm_SQL.updateESMSR", updateSR);
				
				//Call PROC_LOG START TIME
				setInitProcLog(request);
				
				//Save PROC_LOG
				Map setProcMapRst = (Map)setProcLog(request, commonService, insertData);
				if(setProcMapRst.get("type").equals("FAILE")){
					String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
					System.out.println("Msg : "+Msg);
				}
			}
			 // CR 기능 사용 경우 생성				 
			 if(useCR.equals("Y")){
				createCR(commandMap,insertData,request);
			}
			
			// TB_PJT_MEMBER_REL CSR생성자 자동지쩡
			setData = new HashMap<String, Object>();
			setData.put("MemberID",  commandMap.get("sessionUserId"));
			setData.put("ProjectID", projectID);
			commonService.insert("project_SQL.createPjtMemberRel", setData);
			
			//====================Proposal 메일발송 ==========================				
			if(!srID.equals("")){
				setData = new HashMap<String, Object>();
				setData.put("srID", srID);  
			
				Map<String, Object> SRMstInfo = commonService.select("esm_SQL.getSRMST", setData);
				String srCatID = "";
				//String srType = "";
				String proposal = "";
				String srRequestTeamID = "";
				String srSubject = "";
				String srRequestUserID = "";
				String srRegTeamID = "";
				if(!SRMstInfo.isEmpty()){
					srCatID = StringUtil.checkNull(SRMstInfo.get("SubCategory"));
					srType = StringUtil.checkNull(SRMstInfo.get("SRType"));
					proposal = StringUtil.checkNull(SRMstInfo.get("Proposal"));
					srRequestTeamID = StringUtil.checkNull(SRMstInfo.get("RequestTeamID"));
					srSubject = StringUtil.checkNull(SRMstInfo.get("Subject"));
					srRequestUserID = StringUtil.checkNull(SRMstInfo.get("RequestUserID"));
					srRegTeamID = StringUtil.checkNull(SRMstInfo.get("RegTeamID"));
				}
				
				setData.put("srCatID", srCatID);
				setData.put("srType", srType);
				Map<String, Object> SRCATInfo = commonService.select("esm_SQL.getESMSRAreaFromSrCat", setData);
				String proposalOption = "";
				if(!SRCATInfo.isEmpty()){
					proposalOption = StringUtil.checkNull(SRCATInfo.get("ProposalOption"),"").trim(); 
				}
							
				// proposalOtion == 1 && proposal==00 인경우만  진행  && srRegTeamID != 156,159(ITO,열린)
				if(proposalOption.equals("1") && proposal.equals("00") && (!srRegTeamID.equals("156") && !srRegTeamID.equals("159"))){
					// Proposal update, Proposal Mail 발송
					updateData = new HashMap<String, Object>();	
					updateData.put("srID", srID);
					updateData.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));	
					updateData.put("proposal", "01");			
					updateData.put("receiptUserID", StringUtil.checkNull(SRMstInfo.get("ReceiptUserID")));
					commonService.update("esm_SQL.updateESMSR", updateData);
					//send Email
					updateData.put("EMAILCODE", "PROPS");
					updateData.put("subject", srSubject);
					
					List<Map<String, String>> receiverList = new ArrayList<Map<String, String>>();
					Map<String, String> receiverMap = new HashMap<String, String>();
					receiverMap.put("receiptUserID", srRequestUserID);
					receiverList.add(0,receiverMap);
					updateData.put("receiverList", receiverList);
					
					Map setMailMapRst = (Map)setEmailLog(request, commonService, updateData, "PROPS");						
					Map<String, Object> setMap = new HashMap<String, Object>();
					if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
						HashMap<String, Object> mailMap = (HashMap<String, Object>)setMailMapRst.get("mailLog");
						setMap.put("srID", srID);
						setMap.put("srType", srType);
						setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
						HashMap<String, Object> cntsMap = (HashMap<String, Object>)commonService.select("esm_SQL.getESMSRInfo", setMap);
						
						cntsMap.put("srID", srID);	
						cntsMap.put("teamID", srRequestTeamID);					
						cntsMap.put("userID", srRequestUserID);
						cntsMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
						String requestLoginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", cntsMap));
						cntsMap.put("loginID", requestLoginID);
						
						Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, commonService));
						System.out.println("SEND EMAIL TYPE:"+resultMailMap+ "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
					}else{
						System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
					}
				}					
			}
			
			model.put("srID", srID);
			model.put("fromSR", fromSR);
			
		    // 상위 ParentID를 프로젝트 ID로 넘겨줌
			if(!quickCheckOut.equals("Y")){
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			}
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			String checkType = StringUtil.checkNull(request.getParameter("checkType"));
			target.put(AJAX_SCRIPT, "parent.goEdit('"+ projectID +"','"+ parentID +"','"+fromSR+"','"+quickCheckOut+"','"+itemID+"','','"+checkType+"');parent.$('#isSubmit').remove();");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * Project Info [Insert][Update]
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/saveCSRInfo.do")
	public String saveProjectInfo(HttpServletRequest request, HashMap<String, Object> commandMap, ModelMap model) throws Exception {
		HashMap<String, String> target = new HashMap<String, String>();
		try {

			HashMap<String, Object> setData = new HashMap<String, Object>();
			List returnData = new ArrayList();
			HashMap<String, Object> insertData = new HashMap<String, Object>();
			HashMap<String, Object> updateData = new HashMap<String, Object>();
			
			String isNew = StringUtil.checkNull(request.getParameter("isNew"));
			String btn = StringUtil.checkNull(request.getParameter("btn"));
			String isEditable = StringUtil.checkNull(request.getParameter("isEditable"));
			String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
			String memberIds = StringUtil.checkNull(request.getParameter("memberIds"));		
			String srID = StringUtil.checkNull(request.getParameter("srID"));		
			String quickCheckOut = StringUtil.checkNull(request.getParameter("quickCheckOut"));	
			String itemAccCtrl = StringUtil.checkNull(request.getParameter("itemAccCtrl"));	
			String maxCSRCode = "";
			String curmaxCSRCode ="";
			String parentID ="";
			String useCR = GlobalVal.USE_COMP_CR; 
			// get Parent Project Info	
			parentID = StringUtil.checkNull(request.getParameter("ParentPjt"));	
			setData.put("ProjectID", parentID);
			Map<String, Object> parentInfoMap = commonService.select("project_SQL.getParentPjtInfo", setData);
			if (isNew.equals("Y")) {
				/* CSR Project 신규 등록 */
				String aprvOption = StringUtil.checkNull(parentInfoMap.get("AprvOption"));
				String status = "CSR";
				if(aprvOption.equals("POST")){ status = "CNG"; }
				if(quickCheckOut.equals("Y")){ status = "CLS"; }
				insertData.put("ProjectType", "CSR");
				insertData.put("Status", status);
				insertData.put("UserID", commandMap.get("sessionUserId")); // Creator
				insertData.put("AuthorID", commandMap.get("sessionUserId")); // Creator
				insertData.put("AuthorName", commandMap.get("sessionUserNm")); // Creator	
				insertData.put("TeamID", commandMap.get("sessionTeamId")); // Creator TeamID
				insertData.put("ParentID", parentID);
				insertData.put("PJCategory", parentInfoMap.get("PJCategory"));
				insertData.put("StartDate", request.getParameter("StartDate"));
				insertData.put("DueDate", request.getParameter("DueDate"));
				insertData.put("TemplCode", parentInfoMap.get("TemplCode"));
				insertData.put("CompanyID", commandMap.get("sessionCompanyId"));
				insertData.put("RefPGID", parentInfoMap.get("RefPGID"));
				insertData.put("RefPjtID", parentInfoMap.get("RefPjtID"));
				insertData.put("Priority", request.getParameter("Priority"));
				insertData.put("Reason", request.getParameter("Reason"));
				insertData.put("srID", StringUtil.checkNull(request.getParameter("srID")));
				insertData.put("AprvOption", parentInfoMap.get("AprvOption"));
				/* 시스템 날짜 */
				Calendar cal = Calendar.getInstance();
				cal.setTime(new Date(System.currentTimeMillis()));
				String thisYmd = new SimpleDateFormat("yyMMdd").format(cal.getTime());
				setData.put("thisYmd", thisYmd);			
				curmaxCSRCode = StringUtil.checkNull(commonService.selectString("project_SQL.getMaxCSRCode", setData)).trim();				
				if(curmaxCSRCode.equals("")){ // 당일 CSR이 없으면
					maxCSRCode = "CSR"  + thisYmd + "0001";
				} else {
					curmaxCSRCode = curmaxCSRCode.substring(curmaxCSRCode.length() - 4, curmaxCSRCode.length());
					int curCSRCode = Integer.parseInt(curmaxCSRCode) + 1;
					maxCSRCode =  "CSR" +  thisYmd + String.format("%04d", curCSRCode);			
				}
								
				insertData.put("ProjectCode", maxCSRCode);
		
				projectID = commonService.selectString("project_SQL.getMaxProjectID", setData);
				insertData.put("ProjectID", projectID);
				commonService.insert("project_SQL.createProject", insertData);
				
				
				
				List activatedLangList = commonService.selectList("common_SQL.langType_commonSelect", setData);
				for (int i = 0; activatedLangList.size() > i; i++) {
					Map map = (Map) activatedLangList.get(i);
					String languageId = String.valueOf(map.get("CODE"));
					insertData.put("Name", request.getParameter("ProjectName"));
					insertData.put("languageID", languageId);
					insertData.put("Description",commandMap.get("Description"));
					commonService.insert("project_SQL.createProjectTxt",insertData);
				}
				
				HashMap<String, Object> updateSR = new HashMap<String, Object>();
				// SR있는 경우 생성		
				if(!srID.equals("")){
					updateSR.put("srID", srID);
					updateSR.put("status", "CSR");
					updateSR.put("DueDate", request.getParameter("DueDate"));
					updateSR.put("lastUser", commandMap.get("sessionUserId"));
					commonService.update("esm_SQL.updateESMSRStatus", updateSR);	
					Map<String, Object> srIDData = (HashMap<String, Object>) commonService.select("esm_SQL.getESMSRInfo", updateSR);
										
					updateSR.put("status", StringUtil.checkNull(srIDData.get("SRNextStatus")));
					commonService.update("esm_SQL.updateESMSR", updateSR);	
					
				}
				 // CR 기능 사용 경우 생성				 
				 if(useCR.equals("Y")){
					createCR(commandMap,insertData,request);
				}
				
				//Save PROC_LOG
				Map setProcMapRst = (Map)setProcLog(request, commonService, insertData);
				if(setProcMapRst.get("type").equals("FAILE")){
					String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
					System.out.println("Msg : "+Msg);
				}
				
				// TB_PJT_MEMBER_REL CSR생성자 자동지쩡
				setData = new HashMap<String, Object>();
				setData.put("MemberID",  commandMap.get("sessionUserId"));
				setData.put("ProjectID", projectID);
				commonService.insert("project_SQL.createPjtMemberRel", setData);
				
				
				//====================Proposal 메일발송 ==========================				
				if(!srID.equals("")){
					setData = new HashMap<String, Object>();
					setData.put("srID", srID);  
				
					Map<String, Object> SRMstInfo = commonService.select("esm_SQL.getSRMST", setData);
					String srCatID = "";
					String srType = "";
					String proposal = "";
					String srRequestTeamID = "";
					String srSubject = "";
					String srRequestUserID = "";
					String srRegTeamID = "";
					if(!SRMstInfo.isEmpty()){
						srCatID = StringUtil.checkNull(SRMstInfo.get("SubCategory"));
						srType = StringUtil.checkNull(SRMstInfo.get("SRType"));
						proposal = StringUtil.checkNull(SRMstInfo.get("Proposal"));
						srRequestTeamID = StringUtil.checkNull(SRMstInfo.get("RequestTeamID"));
						srSubject = StringUtil.checkNull(SRMstInfo.get("Subject"));
						srRequestUserID = StringUtil.checkNull(SRMstInfo.get("RequestUserID"));
						srRegTeamID = StringUtil.checkNull(SRMstInfo.get("RegTeamID"));
					}
					
					setData.put("srCatID", srCatID);
					setData.put("srType", srType);
					Map<String, Object> SRCATInfo = commonService.select("esm_SQL.getESMSRAreaFromSrCat", setData);
					String proposalOption = "";
					if(!SRCATInfo.isEmpty()){
						proposalOption = StringUtil.checkNull(SRCATInfo.get("ProposalOption"),"").trim(); 
					}
								
					// proposalOtion == 1 && proposal==00 인경우만  진행  && srRegTeamID != 156,159(ITO,열린)
					if(proposalOption.equals("1") && proposal.equals("00") && (!srRegTeamID.equals("156") && !srRegTeamID.equals("159"))){
						// Proposal update, Proposal Mail 발송
						updateData = new HashMap<String, Object>();	
						updateData.put("srID", srID);
						updateData.put("lastUser", StringUtil.checkNull(commandMap.get("sessionUserId")));	
						updateData.put("proposal", "01");			
						updateData.put("receiptUserID", StringUtil.checkNull(SRMstInfo.get("ReceiptUserID")));
						commonService.update("esm_SQL.updateESMSR", updateData);
						//send Email
						updateData.put("EMAILCODE", "PROPS");
						updateData.put("subject", srSubject);
						
						List<Map<String, String>> receiverList = new ArrayList<Map<String, String>>();
						Map<String, String> receiverMap = new HashMap<String, String>();
						receiverMap.put("receiptUserID", srRequestUserID);
						receiverList.add(0,receiverMap);
						updateData.put("receiverList", receiverList);
						
						Map setMailMapRst = (Map)setEmailLog(request, commonService, updateData, "PROPS");						
						Map<String, Object> setMap = new HashMap<String, Object>();
						if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
							HashMap<String, Object> mailMap = (HashMap<String, Object>)setMailMapRst.get("mailLog");
							setMap.put("srID", srID);
							setMap.put("srType", srType);
							setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
							HashMap<String, Object> cntsMap = (HashMap<String, Object>)commonService.select("esm_SQL.getESMSRInfo", setMap);
							
							cntsMap.put("srID", srID);	
							cntsMap.put("teamID", srRequestTeamID);					
							cntsMap.put("userID", srRequestUserID);
							cntsMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
							String requestLoginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", cntsMap));
							cntsMap.put("loginID", requestLoginID);
							
							Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, commonService));
							System.out.println("SEND EMAIL TYPE:"+resultMailMap+ "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
						}else{
							System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
						}
						
					}					
					//============================================================		
					
				}
			
			} else {
				/* 기존 CSR  편집 */				
				updateData.put("StartDate", request.getParameter("StartDate"));
				updateData.put("DueDate", request.getParameter("DueDate"));
				updateData.put("Priority", request.getParameter("Priority"));
				updateData.put("Reason", request.getParameter("Reason"));
				updateData.put("ProjectID", projectID);
				updateData.put("projectID", projectID);
				
				updateData.put("ParentID", parentID);
				updateData.put("RefPGID", parentInfoMap.get("RefPGID"));
				updateData.put("RefPjtID", parentInfoMap.get("RefPjtID"));
				updateData.put("AprvOption", parentInfoMap.get("AprvOption"));
				updateData.put("itemAccCtrl", itemAccCtrl);
				
				commonService.update("project_SQL.updateProject", updateData);

				updateData.put("Name", request.getParameter("ProjectName"));
				updateData.put("languageID", request.getParameter("languageID"));
				updateData.put("Description",commandMap.get("Description"));
				
				String projectName = StringUtil.checkNull(commonService.selectString("project_SQL.getProjectName", updateData));					
				if(projectName.equals("")){				
					commonService.insert("project_SQL.createProjectTxt",updateData);
				}else{
					commonService.update("project_SQL.updateProjectTxt", updateData);
				}						
				
				int csrCnt = Integer.parseInt(commonService.selectString("project_SQL.getCsrCntSR", commandMap));
				if(csrCnt == 0){ //동일한 SRID를 가지고 있는 다른  CSR이 있는지 확인 
					HashMap<String, Object> updateSR = new HashMap<String, Object>();  // Due date 를 업데이트 함					
					if(!srID.equals("")){
						updateSR.put("srID", srID);
						updateSR.put("DueDate", request.getParameter("DueDate"));
						updateSR.put("lastUser", commandMap.get("sessionUserId"));
						commonService.update("esm_SQL.updateESMSRStatus", updateSR);	
					 }		
				}
			}
			model.put("isNew", isNew);
			model.put("srID", srID);
			model.put("fromSR", StringUtil.checkNull(request.getParameter("fromSR")));
			String fromSR = StringUtil.checkNull(request.getParameter("fromSR"));
			
		    // 상위 ParentID를 프로젝트 ID로 넘겨줌
			if(!quickCheckOut.equals("Y")){
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			}
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			target.put(AJAX_SCRIPT, "parent.goEdit('"+ projectID +"','"+ parentID +"','"+fromSR+"','"+quickCheckOut+"','"+itemID+"');parent.$('#isSubmit').remove();");
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * Insert to TB_WF_STEP_INST (CSR)
	 * 
	 * @param changeSetId
	 * @param wfStepId
	 * @param actorId
	 * @param event
	 * @throws Exception
	 */
	private void insertToWfStepInstCsr(String wfId, int seq, int status,
			String Opinion, String projectID, String changeSetId,
			String wfStepId, String actorId, String event) throws Exception {

		HashMap<String, Object> insertCommandMap = new HashMap<String, Object>();
		// get Max StepInstID
		String maxId = commonService.selectString("wf_SQL.getMaxStepInstID", insertCommandMap);
		insertCommandMap.put("StepInstID", Integer.parseInt(maxId) + 1);
		insertCommandMap.put("Seq", seq);
		insertCommandMap.put("Status", status);
		insertCommandMap.put("Event", event);
		insertCommandMap.put("Opinion", Opinion);
		insertCommandMap.put("ActorID", actorId);
		insertCommandMap.put("ProjectID", projectID);
		insertCommandMap.put("ChangeSetID", changeSetId);
		insertCommandMap.put("WFID", wfId);
		insertCommandMap.put("WFStepID", wfStepId);
		commonService.insert("project_SQL.insertToWfStepInstForCsr", insertCommandMap);
	}

	/**
	 * Project Info [update]& Insert WF_STEP_INST
	 * 
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveWfStepInfo_ORG.do")
	public String saveWfStepInfo_ORG(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {

		HashMap<String, String> target = new HashMap<String, String>();

		try {

			HashMap<String, Object> setData = new HashMap<String, Object>();
			List returnData = new ArrayList();

			HashMap insertData = new HashMap();
			HashMap<String, Object> updateData = new HashMap<String, Object>();
			HashMap updateItemMap = new HashMap();

			String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
			String wfId = request.getParameter("WfStepSel");
			String loginUser = request.getParameter("UserID");
			String curWFStepID = "";

			/* Insert [TB_WF_STEP_INST] */
			setData.put("ProjectID", projectID);
			setData.put("WFID", wfId);
			setData.put("LanguageID", commandMap.get("sessionCurrLangType"));
			
			// 합의/승인 (화면에서 입력된 유저분 TB_WF_STEP_INST Record 생성)
			List wfStepList = commonService.selectList("wf_SQL.getWfStepList", setData);
			for (int i = 0; wfStepList.size() > i; i++) {
				Map wfStepMap = (Map) wfStepList.get(i);
				String wfStepId = (String) wfStepMap.get("WFStepID");
				// CSR(프로젝트)에 설정할 현재 WFStepID를 설정
				if (i == 0) {
					curWFStepID = wfStepId;
				}
				String memberList = StringUtil.checkNull(request.getParameter(wfStepId + "ID"));
				String[] memberArray = memberList.split(",");

				// 화면에서 입력 된 WF 단계별 유저 수 만큼 record 생성
				for (int j = 0; memberArray.length > j; j++) {
					String member = memberArray[j];
					insertToWfStepInstCsr(wfId, 0, 0, null, projectID, null, wfStepId, member, null);
				}

			}

			/* 기존 CSR Project 편집 */
			updateData = new HashMap<String, Object>();
			updateData.put("Seq", 0);
			updateData.put("WFID", request.getParameter("WfStepSel"));
			updateData.put("CurWFStepID", curWFStepID); // 결재경로 중 첫번째 단계를 설정
			updateData.put("Status", "APRV"); // 결재 중
			updateData.put("ProjectID", projectID);
			commonService.update("project_SQL.updateProject", updateData);				
		
			String screenType = StringUtil.checkNull(request.getParameter("screenType")).trim();
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT,"parent.fnCallBack();parent.$('#isSubmit').remove();");
		

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
		
	@RequestMapping(value = "/admin/updateCSRStatus.do")
	public String updateCSRStatus(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap<String, String> target = new HashMap<String, String>();
		Map<String, Object> setMap = new HashMap<String, Object>();
			try {
				String status = "";	//CSR Status
				String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));			
				String wfInstanceID = StringUtil.checkNull(request.getParameter("wfInstanceID"),"");
				String wfInstanceStatus = StringUtil.checkNull(request.getParameter("wfInstanceStatus"),"");
				String csrID = StringUtil.checkNull(request.getParameter("csrID"),"");
				
				if(!"".equals(wfInstanceID)) {
					setMap.put("wfInstanceID",wfInstanceID);
					Map<String, Object> instMap = commonService.select("wf_SQL.getWFInstDoc", setMap);
					csrID = StringUtil.checkNull(instMap.get("DocumentID"));
				}
				
				setMap.put("ProjectID",csrID);
				String aprvOption = commonService.selectString("project_SQL.getPjtAprvOption", setMap);
				
				setMap.put("projectID",csrID);
				String srID = commonService.selectString("project_SQL.getSRIDByProjectID", setMap);
								
				if("2".equals(wfInstanceStatus)){	// 최종승인
					status = "CLS";
					status = aprvOption.equals("PRE") ? "CNG" : "QA";
				} else if("3".equals(wfInstanceStatus)) {	// 반려
					status = "HOLD";
				}
				
				//CSR 담당자가 직접 완료처리 하는 경우
				if("".equals(wfInstanceID)) {
			    	 setMap.put("svcCompl","Y");
					status = StringUtil.checkNull(request.getParameter("status"),"");
				}
				
				if(!status.isEmpty()) {
					setMap.put("csrID", csrID);
					setMap.put("srID", srID);
					setMap.put("status", status);
					setMap.put("lastUser", sessionUserId);
				    commonService.update("project_SQL.updateCSRStatus", setMap);
				}
				

				List<Map> receiverList = new ArrayList<Map>();
				Map<String, String> receiverMap = new HashMap<String, String>();	
			  	if(status.equals("CLS")){
			  		
			  		// 01. TB_ITEM.ProjectID = #CSRID#  -->  Item Status = 'REL'로 업데이트 추가
				    List changeMgtList = commonService.selectList("project_SQL.getChangeMgtCsrIDList", setMap);	
				    String s_itemIDs = "";
				    setMap.put("Status", "REL");
				    setMap.put("LastUser", sessionUserId);
				    for(int i=0; i<changeMgtList.size(); i++){
				    	Map itemMap = (Map)changeMgtList.get(i);   		    		
				    	if(i==0){
				    		s_itemIDs = StringUtil.checkNull(itemMap.get("ItemID"));
				    	}else{
				    		s_itemIDs = s_itemIDs+","+StringUtil.checkNull(itemMap.get("ItemID"));				    		
				    	}
				    }
				    
				    if(changeMgtList.size()>0){
				    	setMap.put("s_itemIDs", s_itemIDs);
				    	commonService.update("project_SQL.updateItemStatus", setMap);
				    }
				    
				    /* - ITEM BaseModel L5(CL01006) List 
				       - L4 하위항목 (ST1, ToItemID) List 비교해서 모델에 없는 L5를 DELETED 1 처리, connection도 				    
				    
				    for(int i=0; i<changeMgtList.size(); i++){
				    	Map setData = new HashMap();
				    	Map itemMap = (Map)changeMgtList.get(i);  
				    	setData.put("itemID", StringUtil.checkNull(itemMap.get("ItemID")));
				    	List delMarkItemList = commonService.selectList("project_SQL.getDelMarkItemFromModelList", setData); // 모델의 L5를 제외한 L4하위 항목
				    	//System.out.println("delMarkItemList :"+delMarkItemList);
				    	
				    	String itemIDs = "";
			    		if(delMarkItemList.size()>0){
			    			 for(int j=0; j<delMarkItemList.size(); j++){
			    				 Map delMarkItemMap = (Map)delMarkItemList.get(j);
			    				 if(j==0){	itemIDs = StringUtil.checkNull(delMarkItemMap.get("ItemID")); }else{
			    					 itemIDs = itemIDs + "," + StringUtil.checkNull(delMarkItemMap.get("ItemID"));
			    				 }			    				 
			    			 }
			    			 setData.put("itemIDs", itemIDs);
			    			 System.out.println("delMarkItemIDs :"+itemIDs);
							 commonService.update("project_SQL.updateItemsDelMark", setData);
			    		}
				    } */			    
			   			    
					List itemInfoList = new ArrayList();
					Map itemMap = new HashMap();
					Map<String, Object> updateMap = new HashMap<String, Object>();
				   	    
				    String cngtCountFromItem = commonService.selectString("cs_SQL.getCngtCountFromItem", setMap);
				    if(Integer.parseInt(cngtCountFromItem) > 0){ // 해당 CSR의 changeSet 이 있으면
				    	
					    // 02. Change Type == MOD2 이면 모델 MTCategory update, BAS -> VER, TOBE -> BAS
					    setMap.put("changeType", "MOD");
					    setMap.put("csrID", csrID);
					    itemInfoList = commonService.selectList("cs_SQL.getItemInfoFromCSList", setMap);
					    for(int i=0; itemInfoList.size()>i; i++){
					    	Map<String, Object> setData = new HashMap<String, Object>();
					    	itemMap = (Map)itemInfoList.get(i);
					    	setData.put("itemID", itemMap.get("ItemID"));				    
					    	setData.put("orgMTCategory", "BAS");
					    	setData.put("updateMTCategory", "VER");
					    	commonService.update("model_SQL.updateModelCat", setData);	
					    	
					    	setData.put("orgMTCategory", "TOBE");
					    	setData.put("updateMTCategory", "BAS");
					    	commonService.update("model_SQL.updateModelCat", setData);	
					    } 
					   	
					    //03. ChangeType == DEL 이면 해당 item,하위 item TB_ITEM, deleted=1 update 
					    setMap.put("changeType", "DEL");
					    setMap.put("csrID", csrID);
					    itemInfoList = commonService.selectList("cs_SQL.getItemInfoFromCSList", setMap);
					    for(int i=0; itemInfoList.size()>i; i++){
					    	updateMap = new HashMap<String, Object>();
					    	itemMap = (Map)itemInfoList.get(i);
					    	updateMap.put("itemID", itemMap.get("ItemID"));
					    	updateMap.put("deleted", "1");	
					    	updateMap.put("lastUser", sessionUserId);
					    	commonService.update("project_SQL.updateItemDeletedFromCS", updateMap);	
					    } 
					    setMap.remove("changeType");
					    setMap.put("csrID", csrID);
					    itemInfoList = commonService.selectList("cs_SQL.getItemInfoFromCSList", setMap);
					    for(int i=0; itemInfoList.size()>i; i++){
					    	updateMap = new HashMap<String, Object>();
					    	itemMap = (Map)itemInfoList.get(i);
					    	updateMap.put("s_itemID", itemMap.get("ChangeSetID"));
					    	if(itemMap.get("ValidFrom") == null) {
					    		updateMap.put("validNull", "Y");
					    	}
					    	updateMap.put("csStatus", "CLS");
					    	commonService.update("cs_SQL.updateChangeSetClose", updateMap);
					    }				    
				    }
				    
				    //04. send Email to the last signer 
				    setMap.put("s_itemID", csrID);
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));
					HashMap<String, Object> projectInfoMap = (HashMap<String, Object>)commonService.select("project_SQL.getProjectInfo", setMap);
					
					Map<String, Object> setCSRData = new HashMap<String, Object>();
					setCSRData.put("projectID", csrID);
					
					
					//CSR 담당자가 직접 완료처리 하는 경우 최종 승인자에게 메일 발송함
					if("".equals(wfInstanceID)) {					
						String lastSigner = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFINSLastSigner", setCSRData)); // CSR 이메일 수신자 
						
						receiverMap.put("receiptUserID", lastSigner);
						receiverList.add(0,receiverMap);
						setCSRData.put("receiverList", receiverList);
					
						setCSRData.put("languageID", commandMap.get("sessionCurrLangType"));
						String projectName = commonService.selectString("project_SQL.getProjectName", setCSRData);
						
						setCSRData.put("subject", StringUtil.checkNull(projectInfoMap.get("ProjectName")));
						Map setMailCSRMapRst = (Map)setEmailLog(request, commonService, setCSRData, "CSRCLS");
						
						if(StringUtil.checkNull(setMailCSRMapRst.get("type")).equals("SUCESS")){
							HashMap<String, Object> mailMap = (HashMap<String, Object>)setMailCSRMapRst.get("mailLog");	
							
							if(!srID.equals("")){
								HashMap<String, Object> esmMap = (HashMap<String, Object>)commonService.select("esm_SQL.getESMSRInfo", setMap);
								projectInfoMap.put("SubCategoryNM",esmMap.get("SubCategoryName"));
								projectInfoMap.put("SRArea1Name",esmMap.get("SRArea1Name"));
								projectInfoMap.put("SRArea2Name",esmMap.get("SRArea2Name"));
								projectInfoMap.put("ReqUserNM",esmMap.get("ReqUserNM"));
								projectInfoMap.put("ReqTeamNM",esmMap.get("ReqTeamNM"));
								projectInfoMap.put("ReqDueDate",esmMap.get("ReqDueDate"));
								projectInfoMap.put("SRDescription",esmMap.get("Description"));
								projectInfoMap.put("SRID",esmMap.get("SRID"));
								projectInfoMap.put("wfInstanceID",esmMap.get("WFInstanceID"));
							}
							
							projectInfoMap.put("languageID", commandMap.get("sessionCurrLangType"));
							Map resultMailMap = EmailUtil.sendMail(mailMap, projectInfoMap, getLabel(request, commonService));
							System.out.println("SEND EMAIL TYPE:"+resultMailMap+ "Msg :" + StringUtil.checkNull(setMailCSRMapRst.get("type")));
						}else{
							System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+ StringUtil.checkNull(setMailCSRMapRst.get("msg")));
						}
				   }			
			  	}
			  				   
			  	if(!srID.equals("") && !status.equals("")){
			  		setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			  		setMap.put("wfInstanceStatus", wfInstanceStatus);
	  				Map esmProcInfo = (Map)decideSRProcPath(request, commonService, setMap);
					  
	  				String procPathID = "";
	  				String fixedPathYN = commonService.selectString("esm_SQL.getFixedPathYN",setMap);
	  				
					HashMap<String, Object> getSRInfoMap = (HashMap<String, Object>) commonService.select("esm_SQL.getESMSRInfo", setMap);
					
					if(esmProcInfo != null && !esmProcInfo.isEmpty()){
						procPathID = StringUtil.checkNull(esmProcInfo.get("ProcPathID"));
						setMap.put("status", esmProcInfo.get("SpeCode"));
						if(!procPathID.equals("") && procPathID != null && fixedPathYN.equals("N")) setMap.put("procPathID", procPathID); 
					}
			    	 setMap.put("lastUser", sessionUserId);
			    	commonService.update("esm_SQL.updateESMSR", setMap);				    	
			    	//======================================
					//send Email SR
			    	Map<String, Object> setSRData = new HashMap<String, Object>();
			    	setSRData.put("srID", srID);
					setSRData.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
					
					//setSRData.put("receiptUserID", StringUtil.checkNull(cntsMap.get("RequestUserID"))); //SR 조치 시는 수신자가 조치자(ReceiptUser)가 아닌 RequestUser의 이메일로 송신
					setSRData.put("subject",  StringUtil.checkNull(getSRInfoMap.get("Subject")));
					
					receiverList = new ArrayList<Map>();
					receiverMap = new HashMap<String, String>();				
					receiverMap.put("receiptUserID", StringUtil.checkNull(getSRInfoMap.get("RequestUserID"))); //SR 조치 시는 수신자가 조치자(ReceiptUser)가 아닌 RequestUser의 이메일로 송신
					receiverList.add(0,receiverMap);
					setSRData.put("receiverList", receiverList);
				    	
					Map setMailMapRst = (Map)setEmailLog(request, commonService, setSRData, "SRCMP");
					if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
						HashMap<String, Object> mailMap = (HashMap<String, Object>)setMailMapRst.get("mailLog");
					
						getSRInfoMap.put("srID", srID);	
						getSRInfoMap.put("teamID", StringUtil.checkNull(getSRInfoMap.get("RequestTeamID")) );					
						getSRInfoMap.put("userID", StringUtil.checkNull(getSRInfoMap.get("RequestUserID")) );	
						getSRInfoMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
						String requestLoginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", getSRInfoMap));
						getSRInfoMap.put("loginID", requestLoginID);
						
						getSRInfoMap.put("emailCode", "SRCMP");
						String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", getSRInfoMap));
						getSRInfoMap.put("emailHTMLForm", emailHTMLForm);
						
						Map resultSRMailMap = EmailUtil.sendMail(mailMap, getSRInfoMap, getLabel(request, commonService));
						System.out.println("SEND EMAIL TYPE:"+resultSRMailMap+ "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
					}else{
						System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+ StringUtil.checkNull(setMailMapRst.get("msg")));
					}

			    	//Save PROC_LOG
					setMap.put("status", status);
					Map setProcMapRst = (Map)setProcLog(request, commonService, setMap);
					if(setProcMapRst.get("type").equals("FAILE")){
						String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
						System.out.println("Msg : "+Msg);
					}
			  	}
			    	    
				String screenType = StringUtil.checkNull(request.getParameter("screenType"));
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 완료처리 성공 		
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
							
			} catch (Exception e) {
				System.out.println(e);
				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생												
			}
			model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(AJAXPAGE);
		
		}
	
	private void createCR( HashMap<String, Object> commandMap, HashMap<String, Object> insertData , HttpServletRequest request) throws Exception {	
		HashMap<String, Object> setData = new HashMap<String, Object>();
		try {
			/* 시스템 날짜 */
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyMMdd").format(cal.getTime());
			setData.put("thisYmd", thisYmd);
			
			String maxCRCode = "";
			String maxCrId = StringUtil.checkNull(commonService.selectString("cr_SQL.getMaxCrID", setData)).trim();
			String curmaxCRCode = StringUtil.checkNull(commonService.selectString("cr_SQL.getMaxCRCode", setData)).trim();				
			if(curmaxCRCode.equals("")){ // 당일 CR이 없으면
				maxCRCode = "CR"  + thisYmd + "0001";
			} else {
				curmaxCRCode = curmaxCRCode.substring(curmaxCRCode.length() - 4, curmaxCRCode.length());
				int curCRCode = Integer.parseInt(curmaxCRCode) + 1;
				maxCRCode =  "CR" +  thisYmd + String.format("%04d", curCRCode);			
			}
			
			Map<String, Object> setMap = new HashMap<String, Object>();						
			Map<String, Object> getSRData = commonService.select("esm_SQL.getESMSRInfo", insertData);
			
			setMap.put("crArea2",  StringUtil.checkNull(getSRData.get("SRArea2")) );
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			String ITSMType = StringUtil.checkNull(commonService.selectString("cr_SQL.getITSMType", setMap));
			
			Map<String, Object> getCRAreaUserInfo = commonService.select("cr_SQL.getCRAreaUserInfo", setMap);
			HashMap<String, Object> insertCRData = new HashMap<String, Object>();
			insertCRData.put("crID", maxCrId);
			insertCRData.put("crCode", maxCRCode);
			insertCRData.put("srID", insertData.get("srID"));
			insertCRData.put("csrID",insertData.get("ProjectID"));
			insertCRData.put("projectID", insertData.get("RefPjtID"));
			insertCRData.put("Subject", insertData.get("Name")); // Project_txt(CSR).Name
			insertCRData.put("Description", insertData.get("Description")); // Project_txt(CSR).Description
			insertCRData.put("crArea1", getSRData.get("SRArea1"));
			insertCRData.put("crArea2", getSRData.get("SRArea2"));
			insertCRData.put("status", "TEMP"); 
			insertCRData.put("procOption", "POST"); 
			insertCRData.put("priority", insertData.get("Priority")); //  CSR의 Priority
			insertCRData.put("receiptID", getCRAreaUserInfo.get("AuthorID")); //CRArea2.AuthorID
			insertCRData.put("receiptTeamID", getCRAreaUserInfo.get("OwnerTeamID")); // CRArea2.OwnerTeamID
			
			setMap.put("srArea", getSRData.get("SRArea2") );
			setMap.put("RoleType","R");		
			setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")) );
			Map<String, Object> CRreceiptInfoMap = commonService.select("sr_SQL.getSRReceiptUser", setMap);	
			
			insertCRData.put("receiptID", CRreceiptInfoMap.get("UserID"));
			insertCRData.put("receiptTeamID",CRreceiptInfoMap.get("TeamID"));
			insertCRData.put("ITSMType", ITSMType);	
			insertCRData.put("ITSMIF", "T");	
			insertCRData.put("ReqDueDate", insertData.get("DueDate")); // Project 완료 예정일	
			insertCRData.put("RegUserID", commandMap.get("sessionUserId"));
			insertCRData.put("RegTeamID", commandMap.get("sessionTeamId"));
			// 접수자/접수팀은  CRArea2 담당자를 자동 지정함
			insertCRData.put("LastUser", commandMap.get("sessionUserId"));
			commonService.insert("cr_SQL.insertCR", insertCRData);
			
			//======================================
			//send Email
			List<Map<String, Object>> receiverList = new ArrayList<Map<String, Object>>();
			Map<String, Object> receiverMap = new HashMap<String, Object>();
			receiverMap.put("receiptUserID", CRreceiptInfoMap.get("UserID"));
			receiverList.add(0,receiverMap);
			insertCRData.put("receiverList", receiverList);
			
			insertCRData.put("subject", insertData.get("Name")); 
			Map setMailMapRst = (Map)setEmailLog(request, commonService, insertCRData, "CRRCV"); //CR 접수/취소
			System.out.println("setMailMapRst : "+setMailMapRst );
			
			if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS")){
				HashMap<String, Object> mailMap = (HashMap<String, Object>)setMailMapRst.get("mailLog");
			
					setMap.put("crID", maxCrId);
			
				setMap.put("languageID", String.valueOf(commandMap.get("sessionCurrLangType")));
				HashMap<String, Object> cntsMap = (HashMap<String, Object>)commonService.select("cr_SQL.getCrMstList_gridList", setMap);
				
				Map resultMailMap = EmailUtil.sendMail(mailMap,cntsMap,getLabel(request, commonService));
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMapRst.get("type")));
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
			}
			//==============================================	
			
		} catch (Exception e) {
			System.out.println(e);											
		}
	}
	
	
	
	@RequestMapping(value = "/admin/widthdrawCSR.do")
	public String widthdrawCSR(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap<String, String> target = new HashMap<String, String>();
		Map<String, Object> setMap = new HashMap<String, Object>();
			try {
				String csrID = StringUtil.checkNull(request.getParameter("csrID"));
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));
				
				// 1.CSR Status = WTR
				setMap.put("status", "WTR");
				setMap.put("csrID", csrID);
			    commonService.update("project_SQL.updateCSRStatus", setMap); 
			    
			    setMap.put("srID", srID);
			    setMap.put("lastUser", sessionUserId);
			    String csrCnt = commonService.selectString("project_SQL.getCSRNotWTRCnt", setMap);
			    // 2.SR Status = RCV	
			    if(Integer.parseInt(csrCnt) == 0){ // 다른 취소 안된 CSR이 없으면 GO Update			    		    
				    setMap.put("status", "RCV");			   
				    commonService.update("esm_SQL.updateESMSR", setMap); 
			    }
			    
			    // 3.CR Status = WTR
			    setMap.put("status", "WTR");
			    setMap.put("CSRID", csrID);
			    commonService.update("cr_SQL.updateCR", setMap); 
			    
			  //Save PROC_LOG
				Map setProcMapRst = (Map)setProcLog(request, commonService, setMap);
				if(setProcMapRst.get("type").equals("FAILE")){
					String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
					System.out.println("Msg : "+Msg);
				}
				
			    
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 완료처리 성공 		
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
				
			} catch (Exception e) {
				System.out.println(e);
				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생												
			}
			model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(AJAXPAGE);
	}
	
	
	@RequestMapping(value = "/admin/changePjtAuthor.do")
	public String changePjtAuthor(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap<String, String> target = new HashMap<String, String>();
		Map<String, Object> setMap = new HashMap<String, Object>();
			try {
				String csrID = StringUtil.checkNull(request.getParameter("csrID"));
				String authorID = StringUtil.checkNull(request.getParameter("authorID"));
				String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));
				
				setMap.put("status", "WTR");
				setMap.put("AuthorID", authorID);
				setMap.put("ProjectID", csrID);
			    commonService.update("project_SQL.updateProject", setMap); 
			    
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 	
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
				
			} catch (Exception e) {
				System.out.println(e);
				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생												
			}
			model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(AJAXPAGE);
	}
	
	
	private Map<String, String> aprvBySysPmRole(String projectID, String languageID, HashMap commandMap) throws Exception {
		Map<String, String> resultMap = new HashMap<String, String>();
		HashMap<String, Object> setMap = new HashMap<String, Object>();			
		setMap.put("teamID", commandMap.get("sessionTeamId"));
		setMap.put("languageID", commandMap.get("sessionCurrLangType"));
		Map<String, Object> managerInfo = commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
		// 상신자 
		String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
		String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
		String userTeamID =  StringUtil.checkNull(commandMap.get("sessionTeamId"));
		String userTeamName =  StringUtil.checkNull(commandMap.get("sessionTeamName"));	
		
		if(managerInfo == null || managerInfo.isEmpty()) {
			resultMap.put("noManager","Y"); //  소속 부서장 정보가 없을 때
			return resultMap;
		}
		
		// 매니저
		String managerID = StringUtil.checkNull(managerInfo.get("UserID"));
		String managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
		String managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
		String managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));
		
		setMap.put("projectID", projectID);
		Map<String, Object> pmInfo = commonService.select("project_SQL.getPjtAuthorInfo", setMap);
		
		String pmID = StringUtil.checkNull(pmInfo.get("AuthorID"));
		String pmName = StringUtil.checkNull(pmInfo.get("AuthorName"));
		String pmTeamName = StringUtil.checkNull(pmInfo.get("Name"));
		
		String memberIDs = userID+","+managerID+","+pmID;
		String roleTypes = "AREQ,APRV,APRV";		
		String wfStepInfo = userName+"("+userTeamName+") >> "+managerName+"("+managerTeamName+") >>" + pmName + "("+pmTeamName+")";

		resultMap.put("memberIDs", memberIDs);
		resultMap.put("roleTypes", roleTypes);
		resultMap.put("wfStepInfo", wfStepInfo);
		
		return resultMap;
	}
	
	
	@RequestMapping(value = "/quickCheckOutPop.do")
	public String quickCheckOutPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap<String, String> target = new HashMap<String, String>();
		Map<String, Object> setMap = new HashMap<String, Object>();
		try {
			String itemAuthorID = StringUtil.checkNull(request.getParameter("itemAuthorID"));	
			String itemID = StringUtil.checkNull(request.getParameter("itemID"));
			setMap.put("authorID", itemAuthorID);
			setMap.put("status", "'CSR','CNG'");
			setMap.put("projectType", "CSR");
		    String CSRCNT = commonService.selectString("project_SQL.getCSRCount", setMap); 
		    		    
		    model.put("itemAuthorID", itemAuthorID);
			model.put("CSRCNT", CSRCNT);
			model.put("itemID", itemID);
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생												
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl("/project/pjt/quickCheckOutPop");
	}
	
	@RequestMapping(value = "/csrFromAuthorList.do")
	public String csrFromAuthorList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String itemAuthorID = StringUtil.checkNull(request.getParameter("itemAuthorID"));
		String itemID = StringUtil.checkNull(request.getParameter("itemID"));
		model.put("itemAuthorID", itemAuthorID);
		model.put("itemID", itemID);
		model.put("menu", getLabel(request, commonService)); /*Label Setting*/	
		return nextUrl("/project/pjt/csrFromAuthorList");
	}
	
	@RequestMapping(value = "/quickCheckOut.do")
	public String quickCheckOut(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap<String, String> target = new HashMap<String, String>();
		Map<String, Object> setMap = new HashMap<String, Object>();
			try {
				String csrIDs = StringUtil.checkNull(request.getParameter("csrIDs"));
				String itemAuthorID = StringUtil.checkNull(request.getParameter("itemAuthorID"));
				String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));
				
				setMap.put("Status", "CLS");
				setMap.put("csrIDs", csrIDs);
			    commonService.update("project_SQL.updateProject", setMap); 
			    
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); 	
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
				
			} catch (Exception e) {
				System.out.println(e);
				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생												
			}
			model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(AJAXPAGE);
	}
		
	@RequestMapping(value="/getPjtListOption.do")
	public String getPjtListOption(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map<String, Object> setMap = new HashMap<String, Object>();
		String projectID = StringUtil.checkNull(request.getParameter("projectID"));
		
		// 변경오더 리스트
		setMap.put("ProjectType", "PJT");
	
		setMap.put("languageID", StringUtil.checkNull(request.getParameter("languageID")));
		setMap.put("RefPGID", projectID);
		setMap.put("Status", "CLS");
		
		
		model.put(AJAX_RESULTMAP, commonService.selectList("project_SQL.getParentPjtList", setMap));
		return nextUrl(AJAXPAGE_SELECTOPTION);
	}

	@RequestMapping("/viewProjectInfo.do")
	public String viewProjectInfo(HttpServletRequest request, HashMap<String, Object> commandMap, ModelMap model)throws Exception{
		try{
			Map<String, Object> getMap = new HashMap<String, Object>();
			Map setData = new HashMap();
			String csrStatus = "";
		//	String issueStatus = "";
			
			// N-생성, R-조회, E-편집
			String pjtMode = StringUtil.checkNull(request.getParameter("pjtMode"));
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			
		
			getMap = commonService.select("project_SQL.getProjectInfoView", commandMap);
			
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("refID", StringUtil.checkNull(request.getParameter("refID")));
			model.put("getMap", getMap);
			model.put("pjtMode", pjtMode);
			model.put("csrStatus", csrStatus);
			model.put("screenType", screenType);
		//	model.put("issueStatus", issueStatus);
			model.put("s_itemID", StringUtil.checkNull(commandMap.get("s_itemID") ,""));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/project/pjt/viewProjectInfo");
	}
	

	@RequestMapping("/editProjectInfo.do")
	public String editProjectInfo(HttpServletRequest request, HashMap<String, Object> commandMap, ModelMap model)throws Exception{
		try{
			Map<String, Object> getMap = new HashMap<String, Object>();
			Map<String, Object> setData = new HashMap<String, Object>();
			String csrStatus = "";
		//	String issueStatus = "";
			
			// N-생성, R-조회, E-편집
			String pjtMode = StringUtil.checkNull(request.getParameter("pjtMode"));
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			String isNew = StringUtil.checkNull(request.getParameter("isNew"));
			
			if ("E".equals(pjtMode)) {
				getMap = commonService.select("project_SQL.getProjectInfoView", commandMap);
				
				// 해당 프로젝트의 하위 CSR의 상태 정보 취득
				setData.put("ProjectType", "CSR");
				setData.put("ParentID", StringUtil.checkNull(commandMap.get("s_itemID")));
				setData.put("StatusCheck", "CLS");
				String cnt = commonService.selectString("project_SQL.checkPjtCodeUnique", setData);
				if ("0".equals(cnt)) {
					csrStatus = "CLS";
				}
			}
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("refID", StringUtil.checkNull(request.getParameter("refID")));
			model.put("getMap", getMap);
			model.put("pjtMode", pjtMode);
			model.put("isNew", isNew);
			model.put("csrStatus", csrStatus);
			model.put("screenType", screenType);
		//	model.put("issueStatus", issueStatus);
			model.put("s_itemID", StringUtil.checkNull(commandMap.get("s_itemID") ,""));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/project/pjt/editProjectInfo");
	}
	
	@RequestMapping(value="/mainCSRList.do")
	public String mainCSRList(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		try {
			HashMap<String, Object> setData = new HashMap<String, Object>();
			String listSize = StringUtil.checkNull(request.getParameter("listSize"));	
			String csrMode = StringUtil.checkNull(request.getParameter("csrMode"));	
			String status = StringUtil.checkNull(request.getParameter("status"));
			
			String sessionUserId = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			setData.put("authorID",sessionUserId);
			
			String pjtCnt = StringUtil.checkNull(commonService.selectString("project_SQL.getPjtAuthorCnt", setData));
			
			if (Integer.parseInt(pjtCnt) > 0) {
				model.put("myPjt", "Y");
			}
			
			setData.put("filter", "CSR");
			setData.put("languageID", cmmMap.get("sessionCurrLangType"));
			if(csrMode.equals("myCSR")){
				setData.put("memberId", cmmMap.get("sessionUserId"));
			}
			
			setData.put("Status", status);
			List csrList = (List)commonService.selectList("project_SQL.getSetProjectListForCsr_gridList", setData);
			
			model.put("csrList", csrList);
			model.put("listSize", listSize);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}		
		catch (Exception e) {System.out.println(e);throw new ExceptionUtil(e.toString());}		
		return nextUrl("/hom/main/csr/mainCSRList");
	}	
	
	/**
	 * 변경할 [변경오더] select 할수 있는 팝업 창 표시
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCsrListPop.do")
	public String selectCsrListPop(HttpServletRequest request, ModelMap model)
	
			throws Exception {

		try {
			
			String cngts = StringUtil.checkNull(request.getParameter("cngts"));
			String curPJTID = StringUtil.checkNull(request.getParameter("curPJTID"));
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			String languageId = StringUtil.checkNull(request.getParameter("languageID"));
			
		
			
			System.out.println("languageId: "+languageId);
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			
			model.put("cngts", cngts);
			model.put("curPJTID", curPJTID);
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			model.put("csrStatus", StringUtil.checkNull(request.getParameter("csrStatus")));
			
			HashMap setMap = new HashMap(); 
			setMap.put("filter", "CSR");
			setMap.put("quickCheckOut", "Y");
			setMap.put("languageID",  languageId);
			setMap.put("curPJTID", curPJTID);
			//setMap.put("csrStatus", model.get("csrStatus"));
		
			//setMap.put("screenType", screenType);
			setMap.put("pageNum", model.get("currPage"));
			
		    List <String> scrList = commonService.selectList("project_SQL.getSetProjectListForCsr_gridList",setMap);
		    JSONArray gridData = new JSONArray(scrList);
			model.put("gridData", gridData);
			

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/selectCsrListPop");
	}
	
	@RequestMapping(value = "/selectMemberPop.do")
	public String selectMemberPop(HttpServletRequest request, HashMap cmmMap, ModelMap model)throws Exception {
		try {
				String projectID = StringUtil.checkNull(request.getParameter("projectID"));
	
				model.put("projectID", projectID);
				model.put("menuStyle", "csh_organization");
				model.put("memArr", StringUtil.checkNull(request.getParameter("memArr")));
				model.put("isProject", StringUtil.checkNull(request.getParameter("isProject")));
				model.put("arcCode", "AR000002");
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				
				model.put("s_memberIDs", StringUtil.checkNull(request.getParameter("s_memberIDs")));
				model.put("mbrRoleType", StringUtil.checkNull(request.getParameter("mbrRoleType")));
				model.put("notInRoleCat", StringUtil.checkNull(request.getParameter("notInRoleCat")));
				model.put("attrTypeCode", StringUtil.checkNull(request.getParameter("attrTypeCode")));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/selectMemberPop");
	}
	
	@RequestMapping("/pjtInfoMgt.do")
	public String pjtInfoMgt(HttpServletRequest request, HashMap<String, Object> commandMap, ModelMap model)throws Exception{
		try{
			Map<String, Object> setData = new HashMap<String, Object>();
			
			String projectID = StringUtil.checkNull(request.getParameter("ProjectID"),"NULL");
			String projectName = StringUtil.checkNull(request.getParameter("ProjectName"),"");
			
			setData.put("projectID", projectID);
			setData.put("languageID", commandMap.get("sessionCurrLangType"));
			if(projectID.equals("NULL") || projectID.equals("")) {	
				Map<String, Object> projectInfoMap = commonService.select("main_SQL.getPjtInfoFromTEMPL", commandMap);	
				model.put("projectID", StringUtil.checkNull(projectInfoMap.get("ProjectID")));
				model.put("projectName", StringUtil.checkNull(projectInfoMap.get("Name")));
				setData.put("projectID", StringUtil.checkNull(projectInfoMap.get("ProjectID")));
			} else {
				model.put("projectID",projectID);			
				if(projectName.equals("")){
					projectName = commonService.selectString("project_SQL.getProjectName", setData);
					model.put("projectName", projectName);
				}else{
					model.put("projectName", projectName);
				}
			}
			
			model.put("isNew", StringUtil.checkNull(request.getParameter("isNew")));
			model.put("refPGID", StringUtil.checkNull(commonService.selectString("project_SQL.getRefPGID", setData)));		
		
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			
		}catch(Exception e){
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/project/pjt/pjtInfoMgt");
	}
}
