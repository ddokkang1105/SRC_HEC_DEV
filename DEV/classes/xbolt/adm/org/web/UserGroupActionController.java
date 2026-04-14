package xbolt.adm.org.web;

import com.org.json.JSONArray;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * 공통 서블릿 처리
 * @Class Name : UserGroupActionController.java
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
public class UserGroupActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;
	
	/*
	 * ADMIN - 조직/사용자 관리 - 사용자 그릅 관리 - UserService 
	 * 
	 * */
	@Resource(name = "userService")
	private CommonService userService;
	/*
	 * ADMIN - 조직/사용자 관리 - 사용자 그릅 관리 - List 
	 * 
	 * */
	@RequestMapping(value="/UserGroupList.do")
	public String UserGroupList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		List getProcess = new ArrayList();		
		try {

			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			commandMap.put("userType",2);
			List mList = commonService.selectList("user_SQL.groupList_gridList",commandMap);
			
			JSONArray gridData = new JSONArray(mList);
			model.put("gridData",gridData);
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return nextUrl("/adm/user/userGroupListGrid");
	}

	/*
	 * ADMIN - 조직/사용자 관리 - 사용자 그릅 관리 - 그릅 정보 
	 * 
	 * */

	@RequestMapping(value="/groupInfoView.do")
	public String groupInfoView(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception{
		
		String url = "";
		
		try{
			Map setMap = new HashMap();
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID"), ""));
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			
			if(StringUtil.checkNull(request.getParameter("s_itemID"), "").equals("")){
				model.put("submit", "New");
				url = "/adm/user/groupInfoNew";
			}else{
				model.put("submit", "Edit");
				//setMap.put("s_itemID", request.getParameter("s_itemID"));
				//setMap.put("loginID", request.getParameter("loginID"));
				//setMap.put("name", request.getParameter("name"));
				//setMap.put("description", request.getParameter("description"));
				//setMap.put("regDate", request.getParameter("regDate"));				

				setMap = new HashMap();
				setMap.put("MemberID", request.getParameter("s_itemID"));
				setMap.put("languageID", StringUtil.checkNull(cmmMap.get("sessionCurrLangType")) );
				
				model.put("getData", commonService.select("user_SQL.selectUser", setMap));
				
				url = "/adm/user/groupInfoView";
			}
			
		}catch(Exception e){
			System.out.println(e.toString());
		}		
		return nextUrl(url);
	}
	
	/**
	 * [ADMIN] 조직/사용자 관리 - 사용자 그릅 관리 - TB_MEMBER 테이블 정보 추가 수정 삭제
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/admin/memberUpdate.do")
	public String memberUpdate(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		Map setMap = new HashMap();
		
		String type = StringUtil.checkNull(request.getParameter("type"),"");
		String loginId = StringUtil.checkNull(request.getParameter("loginID"));
		
		try {
			
			// DB에 저장될 정보들 Map에 담기
			setMap.put("LoginID", loginId);
			setMap.put("Addr1", StringUtil.checkNull(request.getParameter("description"),""));
			setMap.put("EmployeeNum", StringUtil.checkNull(request.getParameter("EmployeeNum")));
			setMap.put("Name", StringUtil.checkNull(request.getParameter("Name")));
			setMap.put("MLVL", StringUtil.checkNull(request.getParameter("Authority")));
			setMap.put("Email", StringUtil.checkNull(request.getParameter("Email")));
			setMap.put("regID", StringUtil.checkNull(request.getParameter("regID")));
			setMap.put("userType", StringUtil.checkNull(request.getParameter("userType"),"2"));
			setMap.put("Password", StringUtil.checkNull(request.getParameter("Password")));
			setMap.put("CompanyID", StringUtil.checkNull(request.getParameter("companyID")));
			
			//기존 권한이 단순 1 ,2 시스템과 사용자만 쓰이다가 4단계로 변경
			String authority = StringUtil.checkNull(request.getParameter("Authority"),"VIWER");
			if(authority.equals("SYS")){
				setMap.put("Authority", "1");
			}else if(authority.equals("TM")){
				setMap.put("Authority", "2");
			}else if(authority.equals("EDITOR")){
				setMap.put("Authority", "3");
			}else{
				setMap.put("Authority", "4");
			}
			
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			
			// 사용자(그릅)추가 || 사용자(그릅) 수정
			if(type.equals("insert") || type.equals("update")){
				String memberId = StringUtil.checkNull(request.getParameter("MemberID"),"");
				if (type.equals("insert")) {
					memberId = commonService.selectString("user_SQL.userNextVal", setMap);
				} else {
					setMap.put("MemberID", memberId);	
				}
				
				String memberIdCount = commonService.selectString("user_SQL.loginIdEqualCount", setMap);
				
				// 동일 LoginID 중복 시, 메세지 표시 하고 처리를 중단함
				if (!memberIdCount.equals("0")) {
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00140"));
					target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();");
				} else {
					setMap.put("MemberID", memberId);	
					if (type.equals("insert")) {
						commonService.insert("user_SQL.insertUser", setMap);
						target.put(AJAX_SCRIPT, "this.doSearchList();this.$('#isSubmit').remove();");
					} else {
						commonService.update("user_SQL.updateUser", setMap);
						target.put(AJAX_SCRIPT, "this.reload('"+ memberId +"');this.$('#isSubmit').remove();");
					}
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
				}
			}
			
			//사용자(그릅) 삭제
			if(type.equals("delete")){
				String[] arrayStr =  request.getParameter("items").split(",");
				if(arrayStr != null){
					for(int i = 0 ; i < arrayStr.length; i++){					
						String s_itemIDs =  arrayStr[i];					
						setMap.put("MemberID", s_itemIDs); 					
						commonService.delete("user_SQL.deleteUser", setMap);
					}
				}
				if ("user".equals(StringUtil.checkNull(request.getParameter("userMenu"),""))) {
					target.put(AJAX_SCRIPT, "this.doSearchOUGList();this.$('#isSubmit').remove();");
				} else {
					target.put(AJAX_SCRIPT, "this.doSearchList();this.$('#isSubmit').remove();");
				}
				
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			}
			
		} catch(Exception e) {
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		
		return nextUrl(AJAXPAGE);
	}
	
	/*
	 * ADMIN - 조직/사용자 관리 - Project - Project Group 
	 * 
	 * */
	

	/*
	 * ADMIN - 조직/사용자 관리 - Project - Project 
	 * 
	 * */
	@RequestMapping(value="/projectList.do")
	public String projectList(HttpServletRequest request, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		List getProcess = new ArrayList();		
		try {

			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("filter", StringUtil.checkNull(request.getParameter("filter"),"CNGS"));	/*filter Setting*/
			model.put("Category", StringUtil.checkNull(request.getParameter("Category"),"PC1"));	/*filter Setting*/
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/adm/userProject/projectList");
	}
	
	/*
	 * ADMIN - 조직/사용자 관리 - Project - Project - userGroupAccessRight
	 * 
	 * */
	@RequestMapping(value="/userGroupAccessRight.do")
	public String userGroupAccessRight(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		List getProcess = new ArrayList();		
		try {
			model.put("s_itemID", request.getParameter("s_itemID"));	/*Label Setting*/
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
//			model.put("filter", StringUtil.checkNull(request.getParameter("filter"),"IMPS"));	/*filter Setting*/
			
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			commandMap.put("userType",2);
			commandMap.put("memberID", request.getParameter("s_itemID"));
			List ugarList = commonService.selectList("user_SQL.userGroupAccessRight_gridList",commandMap);
			
			JSONArray gridData = new JSONArray(ugarList);
			model.put("gridData",gridData);
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/adm/userProject/sub/userGroupAccessRight");
	}
	
	/*
	 * ADMIN - 조직/사용자 관리 - Project - Project - allocateUsers
	 * 
	 * */
	@RequestMapping(value="/userGroupProject.do")
	public String userGroupProject(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		List getProcess = new ArrayList();		
		try {
			model.put("s_itemID", request.getParameter("s_itemID"));	/*Label Setting*/
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
//			model.put("filter", StringUtil.checkNull(request.getParameter("filter"),"IMPS"));	/*filter Setting*/
			List ugpList = commonService.selectList("user_SQL.userGroupProject_gridList",commandMap);
			
			JSONArray gridData = new JSONArray(ugpList);
			model.put("gridData",gridData);
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/adm/userProject/sub/userGroupProject");
	}

	/*
	 * ADMIN - 조직/사용자 관리 - Project - Project - allocateUsers
	 * 
	 * */
	@RequestMapping(value="/allocateUsers.do")
	public String allocateUsers(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		List getProcess = new ArrayList();		
		try {
			model.put("s_itemID", request.getParameter("s_itemID"));	/*Label Setting*/
			model.put("userType", request.getParameter("userType"));	/*Label Setting*/
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
//			model.put("filter", StringUtil.checkNull(request.getParameter("filter"),"IMPS"));	/*filter Setting*/
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List auList = commonService.selectList("user_SQL.allocateUsers_gridList",commandMap);
			
			JSONArray gridData = new JSONArray(auList);
			model.put("gridData",gridData);
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/adm/userProject/sub/allocateUsers");
	}
	
	@RequestMapping(value="/setUserGroupAllocateUser.do")
	public String setUserGroupAllocateUser(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception{
		
		Map target = new HashMap();
		
		try{
			HashMap setMap = new HashMap();
			setMap.put("s_itemID", request.getParameter("s_itemID"));
			commonService.delete("user_SQL.delAllocateUser", setMap);
			
			String[] items;
			
			String getItem = StringUtil.checkNull( request.getParameter("items") ,"");
			if(getItem.length()> 0){
				items = getItem.split(",");
				if(items.length>0){
					for(int i = 0 ; i < items.length ; i++){
						setMap.put("MemberID", items[i]);
						
						commonService.insert("user_SQL.asignAllocateUser", setMap);
					}
				}
			}
			
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			
			if(StringUtil.checkNull( request.getParameter("items") ,"").equals("")){
				//target.put(AJAX_ALERT, " 삭제 되였습니다.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			}else{
				//target.put(AJAX_ALERT, " 저장 하였습니다.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			}
			
		}catch(Exception e){
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 처리중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/admin/setUserGroupAccessRight.do")
	public String setUserGroupAccessRight(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception{
		
		Map target = new HashMap();
		
		try{
			HashMap setMap = new HashMap();
			setMap.put("MemberID", request.getParameter("memberID"));
			commonService.delete("user_SQL.delAccessRight", setMap);
			
			String[] items;
			String getItem = StringUtil.checkNull( request.getParameter("items") ,"");
			String defaultTemplCode = StringUtil.checkNull( request.getParameter("defaultTemplCode") ,"");
			String isDefault = StringUtil.checkNull( request.getParameter("isDefault") ,"");
			
			if(getItem.length()> 0){
				items = getItem.split(",");
				if(items.length>0){
					for(int i = 0 ; i < items.length ; i++){
						setMap.put("TemplCode", items[i]);
						commonService.insert("user_SQL.addAccessRight", setMap);
					}
				}
			}						
			//is Default 설정
			if(defaultTemplCode.length()>0){
				setMap.put("isDefault", isDefault);
				setMap.put("memberID", request.getParameter("memberID"));
				setMap.put("TemplCode", defaultTemplCode);	
				setMap.put("templCode", defaultTemplCode);
				String accessCnt = commonService.selectString("user_SQL.getAccessCnt", setMap);
				if(accessCnt.equals("0")){
					commonService.insert("user_SQL.addAccessRight", setMap);
				}else{
					commonService.update("user_SQL.updateAccessRight", setMap);
				}	
			}

			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));

			// Visit Log
			setMap.put("sessionUserId", userID);
			String teamID = commonService.selectString("user_SQL.userTeamID", setMap);
			setMap.put("sessionTeamId", teamID);
			setMap.put("ItemId", request.getParameter("memberID"));
			setMap.put("ActionType","CNGACCR"); 
			 String ip = request.getHeader("X-FORWARDED-FOR");
	        if (ip == null)
	            ip = request.getRemoteAddr();
	        setMap.put("IpAddress",ip);
	        setMap.put("comment",getItem);
			commonService.insert("gloval_SQL.insertVisitLog", setMap);
		
		
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			
			if(StringUtil.checkNull(request.getParameter("items") ,"").equals("") && defaultTemplCode.equals("")){
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			}else{
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			}
			target.put(AJAX_SCRIPT, "this.doSearchList();this.$('#isSubmit').remove()");
		}catch(Exception e){
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/setUserGroupChangeSet.do")
	public String setUserGroupChangeSet(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception{
		
		Map target = new HashMap();
		
		try{
			HashMap setMap = new HashMap();
			setMap.put("MemberID", request.getParameter("memberID"));
			
			commonService.delete("user_SQL.delUserProject", setMap);
			
			String[] items;
			
			String getItem = StringUtil.checkNull( request.getParameter("items") ,"");
			if(getItem.length()> 0){
				items = getItem.split(",");
				if(items.length>0){
					for(int i = 0 ; i < items.length ; i++){
						setMap.put("ProjectID", items[i]);
						
						commonService.insert("user_SQL.addUserProject", setMap);
					}
				}
			}
			
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			
			if(StringUtil.checkNull( request.getParameter("items") ,"").equals("")){
				//target.put(AJAX_ALERT, " 삭제 되였습니다.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
			}else{
				//target.put(AJAX_ALERT, " 저장 하였습니다.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			}
			
		}catch(Exception e){
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 처리중 오류가 발생하였습니다.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/searchUser.do")
	public String searchUser(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {				
				String groupID = StringUtil.checkNull(request.getParameter("groupID"), "");	
				model.put("groupID", groupID);
				model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
				cmmMap.put("languageID", cmmMap.get("sessionCurrLangType"));
				cmmMap.put("userType", 1);
				cmmMap.put("screenType", "user");
				List suList = commonService.selectList("project_SQL.searchNewMember_gridList",cmmMap);
				JSONArray gridData = new JSONArray(suList);
				model.put("gridData",gridData);


				//2025-07-15 SKON CSRF 보안 조치
				//**************************************************************
				HttpSession session = request.getSession();
				String csrfToken = UUID.randomUUID().toString();
				session.setAttribute("csrfToken", csrfToken);
				model.put("csrfToken", csrfToken);
				//**************************************************************

		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/adm/userProject/sub/selectUser");
	}
	
	@RequestMapping(value = "/admin/insertUserGroup.do")
	public String insertUserGroup(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {

				//2025-07-15 SKON CSRF 보안 조치
				//**************************************************************
				HttpSession csrfSession = request.getSession();
				String csrfToken = StringUtil.checkNull(cmmMap.get("csrfToken"));
				String sessionCsrfToken = StringUtil.checkNull(csrfSession.getAttribute("csrfToken"));
				if (csrfToken == null || !csrfToken.equals(sessionCsrfToken)) {
					throw new Exception("Invalid CSRF token");
				}
				//**************************************************************

				String groupID = StringUtil.checkNull(request.getParameter("groupID"), "");
				String reqMemberIds = StringUtil.checkNull(request.getParameter("memberIds"), "");
				String memberIdsArr[] = reqMemberIds.split(",");
				String memberID = "";
				setMap.put("groupID", groupID);
				for(int i=0; i < memberIdsArr.length; i++){
					memberID = memberIdsArr[i];
					setMap.put("memberID", memberID);
					commonService.insert("user_SQL.insertUserGroup",setMap);
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
	
	@RequestMapping(value = "/admin/deleteUserGroup.do")
	public String deleteUserGroup(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {				
				String groupID = StringUtil.checkNull(request.getParameter("groupID"), "");
				String reqMemberIds = StringUtil.checkNull(request.getParameter("memberIds"), "");
				String memberIdsArr[] = reqMemberIds.split(",");
				String memberID = "";
				setMap.put("groupID", groupID);
				for(int i=0; i < memberIdsArr.length; i++){
					memberID = memberIdsArr[i];
					setMap.put("memberID", memberID);
					commonService.delete("user_SQL.deleteUserGroup",setMap);
				}
							
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00069")); // 삭제 성공
				target.put(AJAX_SCRIPT, "fnCallBack();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT,MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/setAccessRightIsDefault.do")
	public String setAccessRightIsDefault(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception{		
		Map target = new HashMap();		
		try{
			HashMap setMap = new HashMap();
			
			String memberID = StringUtil.checkNull(commandMap.get("memberID"), "");
			String templCode = StringUtil.checkNull(commandMap.get("templCode"), "");
			String isDefault = StringUtil.checkNull(commandMap.get("isDefault"), "");
			
			setMap.put("memberID", memberID);		
			
			setMap.put("isDefault", "0");// 기존 1인것 0으로 수정 
			commonService.update("user_SQL.updateAccessRight", setMap);			
			
			setMap.put("isDefault", isDefault);
			setMap.put("templCode", templCode);			
			String accessCnt = commonService.selectString("user_SQL.getAccessCnt", setMap);
			if(accessCnt.equals("0")){
				setMap.put("MemberID", memberID);
				setMap.put("TemplCode", templCode);	
				setMap.put("isDefault", isDefault);
				commonService.insert("user_SQL.addAccessRight", setMap);
			}else{
				commonService.update("user_SQL.updateAccessRight", setMap);
			}
					
			target.put(AJAX_SCRIPT, "fnCallBack();this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
		}catch(Exception e){
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/setUserAuthority.do")
	public String setUserGroupAuthority(HttpServletRequest request,  HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try{
			String memberIDs = StringUtil.checkNull(request.getParameter("memberIDs"),"");
			String groupManagerYN = StringUtil.checkNull(request.getParameter("groupManagerYN"),""); //그룹 매니저일 경우 시스템 관리자 제외
			
			setMap.put("sessionCurrLangType",StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			setMap.put("Category","MLVL");
			List authList = new ArrayList();
			authList = commonService.selectList("common_SQL.getDicWord_commonSelect", setMap);
			
			model.put("memberIDs",memberIDs);
			model.put("employeeNums", StringUtil.checkNull(request.getParameter("employeeNums"),""));
			model.put("groupManagerYN",groupManagerYN);
			model.put("authList", authList);
			model.put("olmServerName", GlobalVal.OLM_SERVER_NAME);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		} catch (Exception e){
			System.out.println(e);
		}
		return nextUrl("/adm/userProject/sub/changeUserAuthPop");
	}
	
	@RequestMapping(value="/admin/editUserAuthority.do")
	public String editUserAuthority(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		Map setMap = new HashMap();
		try{
			String memberIDs[] = StringUtil.checkNull(request.getParameter("memberIDs"),"").split(",");
			String authority = StringUtil.checkNull(request.getParameter("authority"),"");
			String userID = StringUtil.checkNull(String.valueOf(commandMap.get("sessionUserId")), "");
			String memberID = "";
			
			if(authority.equals("SYS")){
				setMap.put("Authority", "1");
			}else if(authority.equals("TM")){
				setMap.put("Authority", "2");
			}else if(authority.equals("EDITOR")){
				setMap.put("Authority", "3");
			}else{
				setMap.put("Authority", "4");
			}
			
			// 권한 수정 시 Active = 1
			setMap.put("Active", "1");
			
			for(int i=0; memberIDs.length > i; i++){
				memberID = StringUtil.checkNull(memberIDs[i],"");
				setMap.put("sessionUserId", memberID);
				String oldMLVL = commonService.selectString("user_SQL.userMLVL", setMap);
				setMap.put("MemberID", memberID);
				setMap.put("MLVL",authority);
				commonService.update("user_SQL.updateUser", setMap);
				
				
				// Visit Log
				setMap.put("sessionUserId", userID);
				String teamID = commonService.selectString("user_SQL.userTeamID", setMap);
				setMap.put("sessionTeamId", teamID);
				
				setMap.put("ItemId", memberID);
				setMap.put("sessionClientId",oldMLVL);
				setMap.put("ActionType","CNGAU");
				 String ip = request.getHeader("X-FORWARDED-FOR");
		        if (ip == null)
		            ip = request.getRemoteAddr();
		        setMap.put("IpAddress",ip);
		        setMap.put("comment",authority);
				commonService.insert("gloval_SQL.insertVisitLog", setMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBack();");
			
		}catch(Exception e){
			System.out.println(e.toString());
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/setUserClientID.do")
	public String setUserClientID(HttpServletRequest request,  HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try{
			String memberIDs = StringUtil.checkNull(request.getParameter("memberIDs"),"");
			String groupManagerYN = StringUtil.checkNull(request.getParameter("groupManagerYN"),""); //그룹 매니저일 경우 시스템 관리자 제외
			
			setMap.put("sessionCurrLangType",StringUtil.checkNull(cmmMap.get("sessionCurrLangType")));
			setMap.put("Category","CLIENTNM");
			List clientIDList = new ArrayList();
			clientIDList = commonService.selectList("common_SQL.getDicWord_commonSelect", setMap);
			
			model.put("memberIDs",memberIDs);
			model.put("employeeNums", StringUtil.checkNull(request.getParameter("employeeNums"),""));
			model.put("groupManagerYN",groupManagerYN);
			model.put("clientIDList", clientIDList);
			model.put("olmServerName", GlobalVal.OLM_SERVER_NAME);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		} catch (Exception e){
			System.out.println(e);
		}
		return nextUrl("/adm/userProject/sub/changeUserClientIDPop");
	}
	
	@RequestMapping(value="/admin/editUserClientID.do")
	public String editUserClientID(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map target = new HashMap();
		Map setMap = new HashMap();
		try{
			String memberIDs[] = StringUtil.checkNull(request.getParameter("memberIDs"),"").split(",");
			String clientID = StringUtil.checkNull(request.getParameter("clientID"),"");
			String userID = StringUtil.checkNull(String.valueOf(commandMap.get("sessionUserId")), "");
			String memberID = "";
			
			// 권한 수정 시 Active = 1
			setMap.put("Active", "1");
			
			for(int i=0; memberIDs.length > i; i++){
				memberID = StringUtil.checkNull(memberIDs[i],"");
				setMap.put("sessionUserId", memberID);
				String oldClientID = commonService.selectString("user_SQL.userClientID", setMap);
				setMap.put("MemberID", memberID);
				setMap.put("ClientID",clientID);
				commonService.update("user_SQL.updateUser", setMap);
				
				// Visit Log
				setMap.put("sessionUserId", userID);
				String teamID = commonService.selectString("user_SQL.userTeamID", setMap);
				setMap.put("sessionTeamId", teamID);
				
				setMap.put("ItemId", memberID);
				setMap.put("sessionClientId",oldClientID);
				setMap.put("ActionType","CNGCLIENT"); 
				 String ip = request.getHeader("X-FORWARDED-FOR");
		        if (ip == null)
		            ip = request.getRemoteAddr();
		        setMap.put("IpAddress",ip);
		        setMap.put("comment",clientID);
				commonService.insert("gloval_SQL.insertVisitLog", setMap);
			}
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "parent.fnCallBack();");
			
		}catch(Exception e){
			System.out.println(e.toString());
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);	
		return nextUrl(AJAXPAGE);
	}
}
