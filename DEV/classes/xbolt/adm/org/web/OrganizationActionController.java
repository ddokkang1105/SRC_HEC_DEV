package xbolt.adm.org.web;

import com.org.json.JSONArray;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * 공통 서블릿 처리
 * @Class Name : OrganizationActionController.java
 * @Description : 조직관련 화면을 제공한다.
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
public class OrganizationActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "CSService")
	private CommonService CSService;
	
	@RequestMapping(value="/processOrganization.do")
	public String processOrganization(HttpServletRequest request, ModelMap model) throws Exception{
		try {
			model.put("s_itemID", request.getParameter("s_itemID"));
			
//			setMap.put("s_itemID", request.getParameter("s_itemID"));
//			setMap.put("languageID", request.getParameter("languageID"));
			
//			List getReturnList = commonService.selectList("organization_SQL.getProcessOrgList", setMap);
			
//			model.put("organizationList", getReturnList);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("/itm/organization/organizationListGrid");
	}

	@RequestMapping(value="/processOrganizationUser.do")
	public String processOrganizationUser(HttpServletRequest request, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		
		String Url = "/itm/organization/organizationUser";
		
		try {
			List getList = new ArrayList();			
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("getTeamID", request.getParameter("teamID"));
			boolean isProcess = false;
			String Category = "";
			if(StringUtil.checkNull(request.getParameter("category"),"").equals("process") ){ isProcess = true; Category = StringUtil.checkNull(request.getParameter("category"),"");}
			if(isProcess){
				getList = commonService.selectList("organization_SQL.getProcessUserList_gridList",setMap);
				model.put("getList", getList);
				
				//Url = Url = "/itm/organization/organizationUser";
			}else{
				getList = commonService.selectList("organization_SQL.getProcessOrgMembers",setMap);
				model.put("getList", getList);
				
				getList = commonService.selectList("organization_SQL.getOrgMembers",setMap);
				model.put("getUserList", getList);
			}
			model.put("Category", StringUtil.checkNull(request.getParameter("category"),""));
			model.put("s_itemID", request.getParameter("s_itemID"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl(Url);
	}
	
	
	@RequestMapping(value="/childOrgMgt.do")
	public String childOrgMgt(HttpServletRequest request, HashMap commandMap , ModelMap model) throws Exception{
		Map setMap = new HashMap();
		try {			
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("languageID", request.getParameter("languageID"));
			List getReturnList = commonService.selectList("organization_SQL.getChildOrgList", setMap);

			model.put("organizationList", getReturnList);
			model.put("s_itemID", request.getParameter("s_itemID"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("baseAtchUrl", GlobalVal.BASE_ATCH_URL);
			model.put("hrIfProc", GlobalVal.HR_IF_PROC);
			System.out.println("hrIfProc :"+GlobalVal.HR_IF_PROC);
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List comList = commonService.selectList("organization_SQL.getOrganizationList_gridList",commandMap);
			
			JSONArray gridData = new JSONArray(comList);
			model.put("gridData",gridData);

		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("/adm/organization/childOrgMgt");
	}
	
	@RequestMapping(value="/orgMemberMgt.do")
	public String orgMemberMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try{
			
			model.put("s_itemID", StringUtil.replaceFilterString(StringUtil.checkNull(StringUtil.checkNull(request.getParameter("s_itemID"),""))));
			model.put("teamManagerID", StringUtil.replaceFilterString(StringUtil.checkNull(StringUtil.checkNull(request.getParameter("teamManagerID"),""))));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			commandMap.put("ActiveMemberYN", "Y");
			List ommList = commonService.selectList("organization_SQL.getOrgMemberList_gridList",commandMap);
			
			JSONArray gridData = new JSONArray(ommList);
			model.put("gridData",gridData);
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("adm/organization/orgMemberMgt");
	}
	
	@RequestMapping(value="/saveUserInfo.do")
	public String saveUserInfo(HttpServletRequest request, ModelMap model) throws Exception{
		try{
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			String Name= StringUtil.checkNull(request.getParameter("searchName"),"");			
			
			HashMap getMap = new HashMap();			
			getMap.put("MemberID", request.getParameter("MemberID"));
			getMap.put("Authority", request.getParameter("userAuthority"));
			getMap.put("TeamID",  s_itemID);
			getMap.put("Name",  Name);
			getMap.put("Password",  request.getParameter("Password"));
			getMap.put("Email",  request.getParameter("Email"));
			
			
			//commonService.update("user_SQL.updateUser", getMap);
			
			List getList = new ArrayList();			
			getMap = new HashMap();			
			getMap.put("TeamID",  s_itemID);			
			getMap.put("Name",  Name);			
			getList = commonService.selectList("item_SQL.selectMembers",getMap);
			
			model.put("s_itemID", s_itemID);
			model.put("searchName",  Name);
			model.put("getList", getList);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("adm/organization/organizationUser");
	}
	
	@RequestMapping(value="/DELDimUser.do")
	public String DELDimUser(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			String Name= StringUtil.checkNull(request.getParameter("searchName"),"");			
			
			Map setMap = new HashMap();			
			setMap.put("s_itemID",  s_itemID);
			
			String[] arrayStr =  request.getParameterValues("item");
			if(arrayStr != null){
				for(int i = 0 ; i < arrayStr.length; i++){					
					String s_itemIDs =  arrayStr[i];					
					setMap.put("MemberID", s_itemIDs); 					
					commonService.delete("organization_SQL.delDimUser",setMap);
				}
			}			
			setMap = new HashMap();
			List getList = new ArrayList();				
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", request.getParameter("languageID"));			
			getList = commonService.selectList("organization_SQL.getProcessOrgMembers",setMap);
			
			model.put("s_itemID", s_itemID);
			model.put("searchName",  Name);
			model.put("getList", getList);
			
			//target.put(AJAX_ALERT, "삭제가 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, "삭제중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/ADDDimUser.do")
	public String ADDDimUser(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{			
			Map setMap = new HashMap();			
			setMap.put("s_itemID",  request.getParameter("s_itemID"));			
			String[] arrayStr =  request.getParameterValues("items");
			if(arrayStr != null){
				for(int i = 0 ; i < arrayStr.length; i++){					
					String s_itemIDs =  arrayStr[i];					
					setMap.put("MemberID", s_itemIDs); 					
					commonService.insert("organization_SQL.addDimUser",setMap);
				}
			}			
/*
			setMap = new HashMap();
			List getList = new ArrayList();			
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			setMap.put("languageID", request.getParameter("languageID"));			
			String Name= StringUtil.checkNull(request.getParameter("searchName"),"");			
			getList = commonService.selectList("organization_SQL.getProcessOrgMembers",setMap);
			
			model.put("s_itemID", request.getParameter("s_itemID"));
			model.put("searchName",  Name);
			model.put("getList", getList);
 * */			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			//target.put(AJAX_ALERT, "저장이 성공하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "this.top.frames['main'].fnSearchTreeId('"+request.getParameter("s_itemID")+"');this.$('#isSubmit').remove();");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 저장중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		//model.put("noticType", noticType);

		return nextUrl(AJAXPAGE);		
		//return nextUrl("itm/organization/organizationUser");
	}
	
	@RequestMapping(value="/userList.do")
	public String userList(HttpServletRequest request, ModelMap model) throws Exception{
		Map setMap = new HashMap();		
		try {
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			
			setMap.put("s_itemID", s_itemID);
			setMap.put("languageID", request.getParameter("languageID"));			
			setMap.put("CompanyID", StringUtil.checkNull(request.getParameter("CompanyID"),""));
			setMap.put("TeamID", StringUtil.checkNull(request.getParameter("TeamID"),""));
			setMap.put("Name", StringUtil.checkNull(request.getParameter("Name"),""));
			
			List getReturnList = commonService.selectList("organization_SQL.getUserList", setMap);

			model.put("s_itemID", s_itemID);
			model.put("CompanyID", StringUtil.checkNull(request.getParameter("CompanyID"),""));
			model.put("TeamID", StringUtil.checkNull(request.getParameter("TeamID"),""));
			model.put("Name", StringUtil.checkNull(request.getParameter("Name"),""));			
			model.put("organizationList", getReturnList);	
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("/adm/organization/organizationList");
	}
		
	
	// 부서 관리 :: TB_TEAM
	@RequestMapping(value="/orgInfoView.do")
	public String orgInfoView(HttpServletRequest request, ModelMap model) throws Exception{
		try{
			Map setMap = new HashMap();

			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			model.put("parentID", StringUtil.checkNull(request.getParameter("parentID"), ""));
			if(StringUtil.checkNull(request.getParameter("s_itemID"), "").equals("")){
				model.put("submit", "New");
			}else{
				model.put("submit", "Edit");
				setMap.put("s_itemID", request.getParameter("s_itemID"));
				setMap.put("languageID", request.getParameter("languageID"));
				setMap.put("teamType", "4");
				Map getMap = commonService.select("organization_SQL.getOrganizationInfo", setMap);
				
				String ItemID = StringUtil.checkNull(getMap.get("ItemID"));
				if(ItemID != null && !"".equals(ItemID)){
				//if(ItemID != null || !ItemID.equals("")){
					setMap.put("ItemID", ItemID);
					String Path = commonService.selectString("organization_SQL.getPathOrg", setMap);
					model.put("Path",Path);
				}
				model.put("getMap", getMap);
			}
			
		}catch(Exception e){
			System.out.println(e.toString());
		}		
		return nextUrl("/adm/organization/organizationInfo");
	}
	
	/**
	 * [Save] 새로운 팀 Insert
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/admin/saveOrgInfo.do")
	public String saveOrgInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		try{
			
			Map setMap = new HashMap();			
			String s_itemID = StringUtil.checkNull(request.getParameter("parentID"), "");
			String TeamID = StringUtil.checkNull(request.getParameter("TeamID"), "");
			String isNew = StringUtil.checkNull(request.getParameter("isNew"));
			
			if(TeamID.equals("")){
				TeamID = commonService.selectString("organization_SQL.getMaxTeamId", setMap);
			}
			
			setMap.put("parentID",  s_itemID);
			setMap.put("TeamID", TeamID);
			setMap.put("TeamType", request.getParameter("TeamType"));
			setMap.put("TeamCode", request.getParameter("TeamCode"));
			setMap.put("companyID", request.getParameter("companyID"));			
			setMap.put("TeamName", request.getParameter("teamName"));
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("ItemID", request.getParameter("ItemID"));
			
			if("Y".equals(isNew)){
				commonService.insert("organization_SQL.addTeam" , setMap);
				commonService.insert("organization_SQL.addTeamText" , setMap);
			}else{
				commonService.update("organization_SQL.updateTeam" , setMap);
				commonService.update("organization_SQL.updateTeamText" , setMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();this.doSearchList()");
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		
		return nextUrl(AJAXPAGE);
	}
	
	
	
	/**
	 * delete team (TB_TEAM, TB_TEAM_TXT)
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/delTeam.do")
	public String delWorkFlow(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();

			String[] arrayCode = StringUtil.checkNull(request.getParameter("items")).split(",");
			
			for (int i = 0; arrayCode.length > i ; i++) {
				getMap.put("TeamID", arrayCode[i]);
				commonService.delete("organization_SQL.delTeam", getMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			target.put(AJAX_SCRIPT, "this.doSearchList();this.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // 삭제 오류
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	
	@RequestMapping(value="/callHrInterface.do")
	public String callHrInterface(HttpServletRequest request, ModelMap model) throws Exception {
		Map resultMap = new HashMap();
		String procedureName = StringUtil.checkNull(GlobalVal.HR_IF_PROC);
		resultMap.put("procedureName", "XBOLTADM."+procedureName);
		//commonService.insert("organization_SQL.insertHRTeamInfo", resultMap);
		commonService.insert("organization_SQL.insertHRTeamInfo", resultMap);
		model.addAttribute(AJAX_RESULTMAP, resultMap);
		return nextUrl(AJAXPAGE);
	}
	
	
	/**
	 * [Select] Organization
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getPathOrg.do")
	public String getPathOrg(HttpServletRequest request,HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();
		try{
			Map setMap = new HashMap();
			setMap.put("s_itemID",StringUtil.checkNull(request.getParameter("ItemID"), ""));
			setMap.put("languageID",commandMap.get("sessionCurrLangType"));
			String Path = commonService.selectString("item_SQL.getItemPath", setMap);
			target.put(AJAX_SCRIPT,"this.thisReload('" + Path +"');");
		}catch(Exception e){
			System.out.println(e.toString());
		}		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	
	/**
	 * [Move] Organization
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/transOrg.do")
	public String transOrg(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			
			String ajaxScript = "";
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String isMember = StringUtil.checkNull(request.getParameter("isMember"));
			String parentTeamId = StringUtil.checkNull(request.getParameter("parentID"));
			String[] arrayCode = StringUtil.checkNull(request.getParameter("items")).split(",");
			
			if (isMember.isEmpty()) {
				getMap.put("ParentID", parentTeamId);
				for (int i = 0; arrayCode.length > i ; i++) {
					getMap.put("TeamID", arrayCode[i]);
					commonService.update("organization_SQL.updateTeam", getMap);
				}
				/*ajaxScript = "this.top.frames['main'].fnRefreshTree('"+ s_itemID +"',true);";*/
				ajaxScript = "parent.fnRefreshTree('"+ s_itemID +"',true);";
			} else {
				getMap.put("TeamID", parentTeamId);
				for (int i = 0; arrayCode.length > i ; i++) {
					getMap.put("MemberID", arrayCode[i]);
					commonService.update("user_SQL.updateUser", getMap);
				}
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, ajaxScript + "this.thisReload();this.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * [Update] 매니저 변경
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/updateOrgManager.do")
	public String updateOrgManager(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
			Map getMap = new HashMap();
			
			String TeamID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String ManagerID = StringUtil.checkNull(request.getParameter("ManagerID"));
			String gubun = StringUtil.checkNull(request.getParameter("gubun"));
			
			getMap.put("TeamID",TeamID);
			
			if(gubun.equals("T")){
				getMap.put("ManagerID",ManagerID);
			}else{
				getMap.put("RoleManagerID",ManagerID);
			}
			commonService.update("organization_SQL.updateTeam", getMap);
			
			target.put(AJAX_SCRIPT, "this.thisReload();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공

		} catch (Exception e) {
			System.out.println(e);
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * [Save] 직원 정보
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/saveOrgMemberInfo.do")
	public String saveOrgMemberInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		HashMap setValue = new HashMap();
		try {
			Map updateMap = new HashMap();
			String authority = StringUtil.checkNull(request.getParameter("userAuthority"));
			String loginId = StringUtil.checkNull(request.getParameter("userLoginID"));
			String memberId = StringUtil.checkNull(request.getParameter("MemberID"));
			
			/* LoginID Unique check */
			setValue.put("LoginID", loginId);
			setValue.put("MemberID", memberId);
			String memberIdCount = commonService.selectString("user_SQL.loginIdEqualCount", setValue);
			
			//동일 LoginID 중복 시, 메세지 표시 하고 처리를 중단함
			if (!memberIdCount.equals("0")) {
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00140"));
				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();");
			} else {
				updateMap.put("MemberID", memberId);
				updateMap.put("LoginID", loginId);
				updateMap.put("Name", StringUtil.checkNull(request.getParameter("userName")));
				updateMap.put("Position", StringUtil.checkNull(request.getParameter("Position")));
				updateMap.put("Email", StringUtil.checkNull(request.getParameter("userEmail")));
				updateMap.put("MTelNum", StringUtil.checkNull(request.getParameter("mTelNum")));
				updateMap.put("TelNum", StringUtil.checkNull(request.getParameter("telNum")));
				updateMap.put("EmployeeNum", StringUtil.checkNull(request.getParameter("employeeNum")));
				updateMap.put("MLVL", authority);
				if(authority.equals("SYS")){
					updateMap.put("Authority", "1");
				}else if(authority.equals("TM")){
					updateMap.put("Authority", "2");
				}else if(authority.equals("EDITOR")){
					updateMap.put("Authority", "3");
				}else{
					updateMap.put("Authority", "4");
				}
				
				commonService.update("user_SQL.updateUser", updateMap);
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				target.put(AJAX_SCRIPT, "this.thisReload();this.$('#isSubmit').remove();");
			}
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/organizationMgt.do")
	public String organizationMgt(HashMap cmmMap,ModelMap model) throws Exception{
		String url = "/adm/organization/organizationMgt";
		try{
				String arcCode =  StringUtil.checkNull(cmmMap.get("arcCode"),"");
				String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
				String nodeID = StringUtil.checkNull(cmmMap.get("nodeID"));
				String rootTeamID = StringUtil.checkNull(cmmMap.get("rootTeamID"));
				String loadType = StringUtil.checkNull(cmmMap.get("loadType"));
				String defItemTypeCode = StringUtil.checkNull(cmmMap.get("defItemTypeCode"));
				
				model.put("arcCode", arcCode);
				model.put("menuStyle", menuStyle);
				model.put("nodeID", nodeID);
				model.put("rootTeamID", rootTeamID);
				model.put("defItemTypeCode", defItemTypeCode);
				
				model.put("loadType", loadType);
				if(loadType.equals("multi")){
					Map setData = new HashMap();
					setData.put("subArcCode", arcCode);
					setData.put("languageID", cmmMap.get("sessionCurrLangType"));
					List arcList = commonService.selectList("menu_SQL.getArcInfo", setData);
					model.put("arcList", arcList);
				}
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl(url);
	}
	
	@RequestMapping(value="/orgURL.do")
	public String orgURL(ModelMap model, HashMap cmmMap) throws Exception {
		Map target = new HashMap();	
		try {
			target.put(AJAX_SCRIPT, "parent.creatMenuTab('"+cmmMap.get("MENU_ID")+"','1');");	
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		model.addAttribute(AJAX_RESULTMAP,target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/orgMainInfo.do")
	public String setOrgTabMenu(ModelMap model,HashMap cmmMap)throws Exception{
		String url = "/adm/organization/orgMainInfo";
		try {			
			String archiCode = StringUtil.checkNull(cmmMap.get("option"),"");
			String s_itemID = StringUtil.checkNull(cmmMap.get("id"),StringUtil.checkNull(cmmMap.get("s_itemID"),""));				
			String defItemTypeCode = StringUtil.checkNull(cmmMap.get("defItemTypeCode"),"");
			String subTeam = StringUtil.checkNull(cmmMap.get("subTeam"),"");
			
			/* ModelID 보유 확인 */
			Map setMap = new HashMap();
			setMap.put("languageID", cmmMap.get("languageID"));			
			setMap.put("ModelID", s_itemID);
			setMap.put("s_itemID", s_itemID);			
					
			model.put("id", s_itemID);
			model.put("s_itemID", s_itemID);
			model.put("choiceIdentifier", s_itemID);
			model.put("option", archiCode);
			model.put("level", (String)cmmMap.get("level"));
			
			
			setMap.put("ArcCode", archiCode);			
			setMap.put("s_itemID", s_itemID);	
			
				
			model.put("menu", getLabel(cmmMap, commonService));
			Map getMap = commonService.select("organization_SQL.getOrganizationInfo", setMap);
				
			setMap.put("ItemID", s_itemID);
			String Path = commonService.selectString("organization_SQL.getPathOrg", setMap);
			model.put("Path",Path);
		
			model.put("getMap", getMap);
			
			setMap.put("teamID", s_itemID);
			String authorNM = "";
			List authorInfoList = commonService.selectList("organization_SQL.getTeamItemAuthorList", setMap);
			if(authorInfoList.size() > 0 ){
				for(int i=0; authorInfoList.size()>i; i++){
					Map authorInfoMap = (Map)authorInfoList.get(i); 
					if(i==0){
						authorNM = StringUtil.checkNull(authorInfoMap.get("AuthorName"));
					}else{
						authorNM = authorNM +","+StringUtil.checkNull(authorInfoMap.get("AuthorName"));
					}
				}
			}
			model.put("authorNM", authorNM);
			
			setMap.put("teamID", s_itemID);
			String CSCOUNT = StringUtil.checkNull(commonService.selectString("cs_SQL.getCSCOUNT", setMap));
			model.put("CSCNT", CSCOUNT);
			model.put("defItemTypeCode", defItemTypeCode);
			model.put("subTeam", subTeam);			
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl(url); 	
	}
	
	@RequestMapping(value = "/orgTeamTreePop.do")
	public String orgTeamTreePop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			model.put("s_itemID",StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("teamIDs",StringUtil.checkNull(request.getParameter("teamIDs")));
			model.put("assignedIDs", StringUtil.checkNull(request.getParameter("assignedIDs")));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/adm/organization/orgTeamTreePop");
	}
	
	@RequestMapping(value = "/orgTreePop.do")
	public String orgTreePop(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		try {
			model.put("s_itemID",StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("teamIDs",StringUtil.checkNull(request.getParameter("teamIDs")));
			model.put("assignedIDs", StringUtil.checkNull(request.getParameter("assignedIDs")));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}

		return nextUrl("/adm/organization/orgTreePop");
	}
	
	@RequestMapping(value="/teamChangeLogMgt.do")
	public String teamChangeLogMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		
		try {
			String scStartDt = StringUtil.checkNull(commandMap.get("SC_STR_DT"));
			String scEndDt = StringUtil.checkNull(commandMap.get("SC_END_DT"));
			String status = StringUtil.checkNull(commandMap.get("statusCode"));
			String changeType = StringUtil.checkNull(commandMap.get("changeTypeCode"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
			commandMap.put("languageID", languageID);
			commandMap.put("scStartDt", scStartDt);
			commandMap.put("scEndDt", scEndDt);
			commandMap.put("status", "01");
			commandMap.put("changeType", changeType);
			
	        List teamChangeLMList = commonService.selectList("organization_SQL.teamChangeLogList_gridList", commandMap);
	        JSONArray gridData = new JSONArray(teamChangeLMList);
	        model.put("gridData",gridData);	
			
			model.put("StatusCode","01");
			model.put("scStartDt",scStartDt);
			model.put("scEndDt",scEndDt);
			model.put("languageID", languageID);
			model.put("menu", getLabel(request, commonService));
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/adm/organization/teamChangeLogMgt");
	}
	
	@RequestMapping(value="/processTeamChangeLog.do")
	public String processTeamChangeLog(HttpServletRequest request, ModelMap model) throws ExceptionUtil {
		
		try {
				String languageID = request.getParameter("languageID");
				String items =  StringUtil.checkNull(request.getParameter("items"),"");
				
				model.put("items", items);
				model.put("languageID", languageID);
				model.put("menu", getLabel(request, commonService));
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/adm/organization/processTeamChangeLog");
	}
	
	@RequestMapping(value="/updateTeamChangeLog.do")
	public String editTeamChangeProcessLog(HashMap commandMap, HttpServletRequest request, ModelMap model) throws Exception{
		
		Map target = new HashMap();
		Map setMap = new HashMap();
		
		try {
				setMap.put("userID", commandMap.get("sessionUserId"));
				//setMap.put("comment", StringUtil.checkNull(request.getParameter("comment"),""));
				String[] arrayStr =  request.getParameter("items").split(",");
				if(arrayStr != null){
					for(int i = 0 ; i < arrayStr.length; i++){					
						String seq =  arrayStr[i];					
						setMap.put("seq", seq); 					
						commonService.update("organization_SQL.updateProcessLog", setMap);
					}
				}
			
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove()");
				//target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			
		} catch(Exception e) {
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE); 
	}
	
	@RequestMapping(value="/callTeamChangeLog.do")
	public String callTeamChangeLog(HttpServletRequest request, ModelMap model) throws Exception {
		Map resultMap = new HashMap();
		resultMap.put("procedureName", "XBOLTADM.TW_INSERT_TEAM_CHANGE_LOG");
		commonService.insert("organization_SQL.insertTeamChangeLog", resultMap);
		
		resultMap.put(AJAX_SCRIPT, "this.doSearchList()");
		model.addAttribute(AJAX_RESULTMAP, resultMap);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/getTeamID.do") 
	public String getTeamID(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception { 
		Map target = new HashMap();	 
		try{ 			 
			String teamID = StringUtil.checkNull(cmmMap.get("teamID")); 
			String level = StringUtil.checkNull(cmmMap.get("level")); 
			String actionYN = "";
			String teamCNT = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamCNT", cmmMap));
			if(Integer.parseInt(teamCNT) == 0){
				actionYN = "N";
			}
			target.put(AJAX_SCRIPT, "creatMenuTab('"+teamID+"','"+level+"','"+actionYN+"')"); 

		} catch (Exception e) { 
			System.out.println(e); 
			throw new ExceptionUtil(e.toString()); 
		} 
		 
		model.addAttribute(AJAX_RESULTMAP,target); 
		return nextUrl(AJAXPAGE); 
	}
	
	@RequestMapping(value="/hrOrgTaskMgt.do")
	public String hrOrgTaskMgt(HashMap cmmMap,ModelMap model) throws Exception{
		String url = "/adm/organization/hrOrgTaskMgt";
		try{
				String arcCode =  StringUtil.checkNull(cmmMap.get("arcCode"),"");
				String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
				String nodeID = StringUtil.checkNull(cmmMap.get("nodeID"));
				String rootTeamID = StringUtil.checkNull(cmmMap.get("rootTeamID"));
				String defItemTypeCode = StringUtil.checkNull(cmmMap.get("defItemTypeCode"));
				String projectID = StringUtil.checkNull(cmmMap.get("projectID"));
				String myTeam = StringUtil.checkNull(cmmMap.get("myTeam"));
				
				model.put("arcCode", arcCode);
				model.put("menuStyle", menuStyle);
				model.put("nodeID", nodeID);
				model.put("rootTeamID", rootTeamID);
				model.put("defItemTypeCode", defItemTypeCode);
				model.put("myTeam", myTeam);
				
				Map setData = new HashMap();
				setData.put("ParentID", projectID);
				setData.put("filter", "CSR");
				setData.put("languageID", cmmMap.get("sessionCurrLangType"));
				List csrList = commonService.selectList("project_SQL.getSetProjectList_gridList", setData);
				model.put("csrList", csrList);
				String csrID = "";
				if(csrList.size()>0) {
					Map csrInfo = (Map)csrList.get(0);
					model.put("defaultCsrID", csrInfo.get("ProjectID"));
				}
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl(url);
	}
	
	@RequestMapping(value="/teamTreeMgt.do")
	public String teamTreeMgt(HashMap cmmMap,ModelMap model) throws Exception{
		String url = "/adm/organization/teamTreeMgt";
		try{
				String arcCode =  StringUtil.checkNull(cmmMap.get("arcCode"),"");
				String menuStyle =  StringUtil.checkNull(cmmMap.get("menuStyle"),"");
				String nodeID = StringUtil.checkNull(cmmMap.get("nodeID"));
				String rootTeamID = StringUtil.checkNull(cmmMap.get("rootTeamID"));
				String loadType = StringUtil.checkNull(cmmMap.get("loadType"));
				String defItemTypeCode = StringUtil.checkNull(cmmMap.get("defItemTypeCode"));
				String subTeam = StringUtil.checkNull(cmmMap.get("subTeam"));
				
				model.put("arcCode", arcCode);
				model.put("menuStyle", menuStyle);
				model.put("nodeID", nodeID);
				model.put("rootTeamID", rootTeamID);
				model.put("defItemTypeCode", defItemTypeCode);
				model.put("subTeam", subTeam);
				
				model.put("loadType", loadType);
				if(loadType.equals("multi")){
					Map setData = new HashMap();
					setData.put("subArcCode", arcCode);
					setData.put("languageID", cmmMap.get("sessionCurrLangType"));
					List arcList = commonService.selectList("menu_SQL.getArcInfo", setData);
					model.put("arcList", arcList);
				}
				
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl(url);
	}
}
