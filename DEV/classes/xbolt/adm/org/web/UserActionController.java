package xbolt.adm.org.web;

import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.org.json.JSONArray;
import com.org.json.JSONObject;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DimTreeAdd;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.cmm.framework.util.AESUtil;
/**
 * 怨듯넻 �꽌釉붾┸ 泥섎━
 * @Class Name : OrganizationActionController.java
 * @Description : 議곗쭅愿��젴 �솕硫댁쓣 �젣怨듯븳�떎.
 * @Modification Information
 * @�닔�젙�씪			�닔�젙�옄		�닔�젙�궡�슜
 * @--------- 		---------	-------------------------------
 * @2012. 10. 15.	jhAhn		理쒖큹�깮�꽦
 *
 * @since 2012. 10. 15.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class UserActionController extends XboltController{

	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "userService")
	private CommonService userService;
	private AESUtil aesAction;

	@RequestMapping(value="/UserList.do")
	public String UserList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try {
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			
			model.put("clientID", StringUtil.checkNull(request.getParameter("clientID")));
			model.put("companyID", StringUtil.checkNull(request.getParameter("companyID")));
			model.put("teamID", StringUtil.checkNull(request.getParameter("teamID")));
			model.put("searchKey", StringUtil.checkNull(request.getParameter("searchKey")));
			model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
			model.put("active", StringUtil.checkNull(request.getParameter("active")));
			model.put("teamTypeYN", StringUtil.checkNull(request.getParameter("teamTypeYN"),"Y"));
			model.put("userInfoMasking", StringUtil.checkNull(request.getParameter("userInfoMasking"),"N"));
			Map setMap = new HashMap();
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("typeCode", "1");
			setMap.put("category", "TMTP");
			String labelNM = commonService.selectString("common_SQL.getNameFromDic",setMap);
			
			model.put("labelNM",labelNM);
			
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			commandMap.put("userType",1);
			commandMap.put("active",1);
			List ulList = commonService.selectList("user_SQL.userList_gridList",commandMap);

			JSONArray gridData = new JSONArray(ulList);
			model.put("gridData",gridData);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl("adm/user/userListGrid");
	}

	@RequestMapping(value="/userInfoView.do")
	public String userInfoView(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try {
			model.put("memberID", request.getParameter("memberID"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
			Map setMap = new HashMap();
			setMap.put("MemberID", request.getParameter("memberID"));
			setMap.put("languageID", request.getParameter("languageID"));
			model.put("getData", commonService.select("user_SQL.selectUser", setMap));
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			
			model.put("clientID", StringUtil.checkNull(request.getParameter("clientID")));
			model.put("companyID", StringUtil.checkNull(request.getParameter("companyID")));
			model.put("teamID", StringUtil.checkNull(request.getParameter("teamID")));
			model.put("searchKey", StringUtil.checkNull(request.getParameter("searchKey")));
			model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
			model.put("active", StringUtil.checkNull(request.getParameter("active")));
			model.put("teamTypeYN", StringUtil.checkNull(request.getParameter("teamTypeYN"),"Y"));
			
			// Visit Log
			String userID = StringUtil.checkNull(String.valueOf(commandMap.get("sessionUserId")), "");
			
			setMap.put("sessionUserId", userID);
			String teamID = commonService.selectString("user_SQL.userTeamID", setMap);
			setMap.put("sessionTeamId", teamID);

			setMap.put("ItemId", request.getParameter("memberID"));
			setMap.put("ActionType","MBRVIEW"); 
			String ip = request.getHeader("X-FORWARDED-FOR");
	        if (ip == null)
	            ip = request.getRemoteAddr();
	        setMap.put("IpAddress",ip);
	        commonService.insert("gloval_SQL.insertVisitLog", setMap);
			
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl("adm/user/userInfoView");
	}

	
	
	@RequestMapping(value="/admin/saveUser.do")
	public String saveUser(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
		String memberId = StringUtil.checkNull(request.getParameter("MemberID"), "");
		
		String kbn = StringUtil.checkNull(request.getParameter("kbn"), "");
		try {
			
			String loginID = StringUtil.checkNull(request.getParameter("LoginID"), "");
			setMap.put("LoginID", loginID);
			setMap.put("EmployeeNum", request.getParameter("EmployeeNum"));
			setMap.put("Email", request.getParameter("Email"));
			setMap.put("Name", request.getParameter("Name"));
			setMap.put("MLVL", request.getParameter("Authority"));
			setMap.put("regID", request.getParameter("loginID"));
			setMap.put("MTelNum", request.getParameter("MTelNum"));
			setMap.put("TelNum", request.getParameter("TelNum"));
			setMap.put("Position", request.getParameter("Position"));
			setMap.put("TeamID", request.getParameter("TeamID"));
			setMap.put("NameEn", request.getParameter("NameEn"));
			setMap.put("City", request.getParameter("City"));
			setMap.put("userType", "1");
			setMap.put("timeZone", request.getParameter("timeZone"));
			
			if(!memberId.isEmpty()){
				setMap.put("MemberID", memberId);
			}
			
			if(memberId.isEmpty()){
				String memberIdCount = commonService.selectString("user_SQL.loginIdEqualCount", setMap);
				
				if (!memberIdCount.equals("0")) {
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00140"));
					target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();");
				} else {
					memberId = commonService.selectString("user_SQL.userNextVal", setMap);
					
					aesAction = new AESUtil();
					String pwd = GlobalVal.DEFAULT_PASSWRORD;
								
					if("Y".equals(GlobalVal.PWD_ENCODING)) {
						pwd = aesAction.encrypt(pwd);
					}else { 
						
					}
					
					setMap.put("Password", pwd); // default password �꽕�젙
					setMap.put("GUBUN", "insert");
					setMap.put("MemberID", memberId);
					
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
					
					commonService.insert("user_SQL.insertUser", setMap);
					target.put(AJAX_SCRIPT, "this.doSearchOUGList();this.initControl(true);this.$('#isSubmit').remove();");
					target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				}
			} else {
				setMap.put("GUBUN", "update");	
				if (!kbn.isEmpty()) {
					aesAction = new AESUtil();
					String pwd = GlobalVal.DEFAULT_PASSWRORD;
					
					if("Y".equals(GlobalVal.PWD_ENCODING)) {
						pwd = aesAction.encrypt(pwd);
					}else {
				
					}
					
					setMap.put("Password", pwd); // default password 
				}
				commonService.update("user_SQL.updateUser", setMap);
				target.put(AJAX_SCRIPT, "this.reload('"+ memberId +"');this.$('#isSubmit').remove();");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			}
			
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
		}
		catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/editUser.do")
	public String editUser(HttpServletRequest request, ModelMap model) throws Exception{
		try {
			String MemberID = StringUtil.checkNull(request.getParameter("MemberID"), "");
			
			Map setMap = new HashMap();
			Map getMap = new HashMap();
			
			List getList = new ArrayList();
			
			setMap.put("MemberID", MemberID);
			setMap.put("languageID", request.getParameter("languageID"));
			
			getMap = commonService.select("user_SQL.selectUser", setMap);
			
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("userInfo", getMap);
			
			setMap.put("TeamType", "2");
			getList = commonService.selectList("organization_SQL.getTeamList", setMap);
			model.put("companyOption", getList);
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			
		}catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl("adm/user/userInfoView");
	}

	/*
	 * ADMIN - 議곗쭅/�궗�슜�옄 愿�由� - �궗�슜�옄 - user - userGroup
	 * 
	 * */
	@RequestMapping(value="/UserGroup.do")
	public String UserGroup(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try {
			model.put("memberID", request.getParameter("memberID"));	/*Label Setting*/
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
//			model.put("filter", StringUtil.checkNull(request.getParameter("filter"),"IMPS"));	/*filter Setting*/
			
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			commandMap.put("memberID",request.getParameter("memberID"));
			List ugList = commonService.selectList("user_SQL.UserGroup_gridList",commandMap);

			JSONArray gridData = new JSONArray(ugList);
			model.put("gridData",gridData);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/adm/user/sub/UserGroup");
	}
	
	@RequestMapping(value="/admin/setAllocateUserGroup.do")
	public String setUserGroupAllocateUser(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception{
		
		Map target = new HashMap();
		
		try{
			HashMap setMap = new HashMap();
			setMap.put("memberID", request.getParameter("memberID"));
			
			commonService.delete("user_SQL.delAllocateGroup", setMap);
					
			String[] items;
			String getItem = StringUtil.checkNull(request.getParameter("items") ,"");
			if(getItem.length()> 0){
				items = getItem.split(",");
				if(items.length>0){
					for(int i = 0 ; i < items.length ; i++){
						setMap.put("GroupID", items[i]);
						commonService.insert("user_SQL.addAllocateGroup", setMap);
					}
				}
			}
			
			List<String> memberGroupNameList = commonService.selectList("user_SQL.getMemberUserGroupName", setMap);
			String getMemberGroupName = String.join(",", memberGroupNameList);
			
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			// Visit Log
			setMap.put("sessionUserId", userID);
			String teamID = commonService.selectString("user_SQL.userTeamID", setMap);
			setMap.put("sessionTeamId", teamID);
			
			setMap.put("ItemId", request.getParameter("memberID"));
			setMap.put("ActionType","CNGUSERGP"); 
			 String ip = request.getHeader("X-FORWARDED-FOR");
	        if (ip == null)
	            ip = request.getRemoteAddr();
	        setMap.put("IpAddress",ip);
	        setMap.put("comment",getMemberGroupName);
			commonService.insert("gloval_SQL.insertVisitLog", setMap);

			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			
			if(StringUtil.checkNull( request.getParameter("items") ,"").equals("")){
				//target.put(AJAX_ALERT, " �궘�젣 �릺���뒿�땲�떎.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣 �꽦怨�
			}else{
				//target.put(AJAX_ALERT, " ���옣 �븯���뒿�땲�떎.");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			}
			
		}catch(Exception e){
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " 泥섎━以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
			
		}
		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	/*
	 * ADMIN - 議곗쭅/�궗�슜�옄 愿�由� - Project - Project - userGroupAccessRight
	 * 
	 * */
	@RequestMapping(value="/userAccessRight.do")
	public String userAccessRight(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try {
			model.put("memberID", request.getParameter("memberID"));	/*Label Setting*/
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
//			model.put("filter", StringUtil.checkNull(request.getParameter("filter"),"IMPS"));	/*filter Setting*/
			
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			commandMap.put("memberID",request.getParameter("memberID"));
			List ugList = commonService.selectList("user_SQL.userAccessRight_gridList",commandMap);

			JSONArray gridData = new JSONArray(ugList);
			model.put("gridData",gridData);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/adm/user/sub/userAccessRight");
	}
	
	/*
	 * ADMIN - 議곗쭅/�궗�슜�옄 愿�由� - �궗�슜�옄 - 蹂�寃쎈떒�쐞 愿�由�
	 * 
	 * */
	@RequestMapping(value="/userProject.do")
	public String userProject(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try {
			model.put("memberID", request.getParameter("memberID"));	/*Label Setting*/
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
//			model.put("filter", StringUtil.checkNull(request.getParameter("filter"),"IMPS"));	/*filter Setting*/
			
			commandMap.put("languageID", commandMap.get("sessionCurrLangType"));
			commandMap.put("memberID",request.getParameter("memberID"));
			List upList = commonService.selectList("user_SQL.userProject_gridList",commandMap);

			JSONArray gridData = new JSONArray(upList);
			model.put("gridData",gridData);
			
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/adm/user/sub/userProject");
	}
	
	/**
	 * [愿�由ъ옄 �솕硫�] �궗�슜�옄, �궗�슜�옄 洹몃９ 硫붾돱 �솕硫�
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/userInfoMgt.do")
	public String userInfoMgt(HttpServletRequest request,ModelMap model) throws Exception{
		
		try {
			model.put("menu", getLabel(request, commonService));
			model.put("teamTypeYN",StringUtil.checkNull(request.getParameter("teamTypeYN"),"Y"));
			model.put("userInfoMasking", StringUtil.checkNull(request.getParameter("userInfoMasking"),"N"));


		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/adm/userProject/userInfoMainMenu");
	}	
	
	@RequestMapping(value="/openchangePwdPop.do")
	public String openchangePwdPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		//String currentPwd = commonService.selectString("user_SQL.getCurrentPwd", commandMap);
		String pwdEncoding = StringUtil.checkNull(GlobalVal.PWD_ENCODING,"N");
		String pwdTextCheck = StringUtil.checkNull(GlobalVal.PWD_TEXT_CHECK,"N");
		model.put("openPWD", "Y");
		model.put("pwdEncoding", pwdEncoding);
		model.put("pwdTextCheck", pwdTextCheck);
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		return nextUrl("/adm/user/changePwdPop");
	}
	
	@RequestMapping(value="/changePwd.do")
	public String changePwd(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		
		Map target = new HashMap();
		Map setMap = new HashMap();
		try{			
			String userID = StringUtil.checkNull(request.getParameter("userID"), "");
			String loginID = StringUtil.checkNull(request.getParameter("loginID"), "");
			
			String pwdTextCheck = StringUtil.checkNull(request.getParameter("pwdTextCheck"), "");
			
			String openYN = (String) request.getParameter("openPWD");		
			if(!"Y".equals(openYN)) {
				target.put(AJAX_SCRIPT, "parent.fnCheckCurrPwd('NONE')");
				model.addAttribute(AJAX_RESULTMAP, target);
				return nextUrl(AJAXPAGE);
			}
			String orgPwd = StringUtil.checkNull(request.getParameter("orgPwd"), "");
			String newPwd = StringUtil.checkNull(request.getParameter("newPwd"), "");
			String orgPwd2 = "";
			String newPwd2 = "";
			String currentPwd = commonService.selectString("user_SQL.getCurrentPwd", commandMap);
			aesAction = new AESUtil();
						
			if("Y".equals(GlobalVal.PWD_ENCODING)) {
				aesAction.setIV(request.getParameter("iv"));
				aesAction.setSALT(request.getParameter("salt"));
				
				orgPwd = aesAction.decrypt(orgPwd);
				newPwd = aesAction.decrypt(newPwd);
									
				aesAction.init();
				
				orgPwd2 = aesAction.encrypt(orgPwd);
				newPwd2 = aesAction.encrypt(newPwd);
				
			}
			else {
				orgPwd2 = orgPwd;
				newPwd2 = newPwd;
			}
			
			if(pwdTextCheck.equals("Y")) {
				String checkFlag = checkPassword(loginID, orgPwd, newPwd);
				if("Y".equals(GlobalVal.PWD_ENCODING) || !checkFlag.equals("T")) {
					target.put(AJAX_SCRIPT, "parent.fnCheckCurrPwd('"+(checkFlag.equals("F")?"Y":"C")+"')");
					model.addAttribute(AJAX_RESULTMAP, target);
					return nextUrl(AJAXPAGE);
				}
			}
			
			request.setAttribute("openPWD", "");
			if(orgPwd2.equals(currentPwd)) {
				setMap.put("userID", userID);
				setMap.put("orgPwd", orgPwd2);
				setMap.put("newPwd", newPwd2);
				commonService.update("user_SQL.changePwd", setMap);
				
				// Visit Log
				commandMap.put("ActionType","CHGPWD");
				 String ip = request.getHeader("X-FORWARDED-FOR");
		        if (ip == null)
		            ip = request.getRemoteAddr();
		        commandMap.put("IpAddress",ip);
		        commandMap.put("comment",newPwd2);		        
				commonService.insert("gloval_SQL.insertVisitLog", commandMap);
					
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
				target.put(AJAX_SCRIPT, "parent.callbackSave();");
			}
			else {
				target.put(AJAX_SCRIPT, "parent.fnCheckCurrPwd('Y');");
			}
			
		} catch(Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	public String checkPassword(String userID, String oldPwd, String newPwd) {
		
        // �옱�엯�젰 �씪移� �뿬遺�
        if (newPwd.equals(oldPwd)) {
            return "F";
        }
        
	    // �쁺臾�+�닽�옄+�듅�닔臾몄옄 議고빀
 		if (digitCheck(newPwd) < 3) {
 			return "F";
 		}
	    
	    //�븘�씠�뵒 �룷�븿 �뿬遺�
	    if(newPwd.indexOf(userID) > -1){ 
	    	return "F";
	    }
	    
	    //以묐났�맂 3�옄 �씠�긽�쓽 臾몄옄 �삉�뒗 �닽�옄 �궗�슜遺덇�
		if (checkDuplicate3Character(newPwd)) {
			return "F";
		}
		try {
			Map setMap = new HashMap();
			setMap.put("userID", userID);
			setMap.put("newPwd", newPwd);
			int ntcCnt = NumberUtil.getIntValue(commonService.selectString("user_SQL.oldPasswordList", setMap));
			if(ntcCnt > 0) {
				return "C";
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
        return "T";	
	}
	
	public static int digitCheck(String passwd) {

		int varDigit = 0;
		int varAlpha = 0;
		int varHex = 0;
		int varSum = 0;
		for (int i = 0; i < passwd.length(); i++) {
			char index = passwd.charAt(i);

			if (index >= '0' && index <= '9') {
				varDigit = 1;
			} else if ( (index >= 'a' && index <= 'z') || (index >= 'A' && index <= 'Z') ) {
				varAlpha = 1;
			} else if (index == '!' || index == '@' || index == '$'
					|| index == '%' || index == '^' || index == '&'
					|| index == '*') {
				varHex = 1;
			} 
		}

		varSum = varDigit + varAlpha + varHex;
		
		return varSum;
	}
	
	public static boolean checkDuplicate3Character(String d) {
		int p = d.length();
		byte[] b = d.getBytes(StandardCharsets.UTF_8);
		for (int i = 0; i < ((p * 2) / 3); i++) {
			int b1 = b[i + 1];
			int b2 = b[i + 2];

			if ((b[i] == b1) && (b[i] == b2)) {
				return true;
			} else {
				continue;
			}
		}
		return false;
	}
	
	@RequestMapping(value = "/settingPwdEncrypt.do")
	public String settingPwdEncrypt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		aesAction = new AESUtil();
		Map setMap = new HashMap();
		
		List temp1 = commonService.selectList("user_SQL.getAfterChnagePwd",setMap);
		for(int i=0; i<temp1.size(); i++) {
			Map tempMap = (Map)temp1.get(i);
			
			String orgPwd = (String) tempMap.get("Password");
			
			setMap.put("userID", tempMap.get("MemberID"));
			setMap.put("orgPwd", orgPwd);
			setMap.put("newPwd", aesAction.encrypt(orgPwd));
			commonService.update("user_SQL.changePwd", setMap);
			setMap.clear();
				
		}				

		
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/itemAuthorLogMgt.do")
	public String itemAuthorLogMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		try {
//			String isMain = StringUtil.checkNull(commandMap.get("isMain"));
			String scStartDt = StringUtil.checkNull(commandMap.get("scStartDt")); 
			String scEndDt = StringUtil.checkNull(commandMap.get("scEndDt"));
			String status = StringUtil.checkNull(commandMap.get("StatusCode"));
			String changeType = StringUtil.checkNull(commandMap.get("ChangetypeCode"));
			String actionType = StringUtil.checkNull(commandMap.get("ActionTypeCode"));
			String languageID = request.getParameter("languageID");
			
			commandMap.put("languageID", languageID);
//			commandMap.put("isMain", isMain); 
			commandMap.put("scStartDt", scStartDt);
			commandMap.put("scEndDt", scEndDt);
			commandMap.put("status", "01");
			commandMap.put("changeType", changeType);
			commandMap.put("actionType", actionType);
			
	        List evalTypeList = commonService.selectList("user_SQL.itemAuthorLogList_gridList", commandMap);
	        JSONArray gridData = new JSONArray(evalTypeList);
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
		return nextUrl("/adm/user/itemAuthorLogMgt");
	}
	
	@RequestMapping(value="/editProcessLogPop.do")
	public String editProcessLogPop(HttpServletRequest request, ModelMap model) throws ExceptionUtil {
		
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
		
		return nextUrl("/adm/user/editProcessLogPop");
	}
	
	@RequestMapping(value="/editProcessLog.do")
	public String editProcessLog(HashMap commandMap, HttpServletRequest request, ModelMap model) throws Exception{
		
		Map target = new HashMap();
		Map setMap = new HashMap();
		
		try {
				setMap.put("userID", commandMap.get("sessionUserId"));
				setMap.put("actionType", StringUtil.checkNull(request.getParameter("actionType"),""));
				setMap.put("comment", StringUtil.checkNull(request.getParameter("comment"),""));
				String[] arrayStr =  request.getParameter("items").split(",");
				if(arrayStr != null){
					for(int i = 0 ; i < arrayStr.length; i++){					
						String seq =  arrayStr[i];					
						setMap.put("seq", seq); 					
						commonService.update("user_SQL.updateProcessLog", setMap);
					}
				}
			
				target.put(AJAX_SCRIPT, "this.fnCallBack();this.$('#isSubmit').remove()");
				//target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			
		} catch(Exception e) {
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE); 
	}
	
	@RequestMapping(value="/callItemAuthorLog.do")
	public String callItemAuthorLog(HttpServletRequest request, ModelMap model) throws Exception {
		Map resultMap = new HashMap();
		resultMap.put("procedureName", "XBOLTADM.TW_INSERT_ITEM_AUTHOR_LOG");
		commonService.insert("user_SQL.insertItemAuthorLog", resultMap);
		
		resultMap.put(AJAX_SCRIPT, "this.doSearchList()");
		model.addAttribute(AJAX_RESULTMAP, resultMap);
		return nextUrl(AJAXPAGE);
	}
	
	
	/**
	 * ADMIN - 議곗쭅/�궗�슜�옄 愿�由� - �궗�슜�옄 - �궗�슜�옄蹂� Dimension 愿�由�
	 * 
	 * */
	@RequestMapping(value="/userDimList.do")
	public String userDimList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try {
			List dimTypeList = commonService.selectList("dim_SQL.getDimTypeList", commandMap);			
			String authLev = StringUtil.checkNull(commandMap.get("sessionAuthLev"));			
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String memberID = StringUtil.checkNull(request.getParameter("memberID"));
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"));
			String dimTypeID = StringUtil.checkNull(request.getParameter("dimTypeID"));
			String dimValueId = StringUtil.checkNull(request.getParameter("dimValueId"));

	        commandMap.put("memberID", memberID);
	        commandMap.put("languageID", languageID);
	        commandMap.put("s_itemID", s_itemID);
	        commandMap.put("dimTypeID", dimTypeID);
	        commandMap.put("dimValueId", dimValueId);
	        
	        //그리드1
	        List userDList = commonService.selectList("user_SQL.userDimList_gridList", commandMap);
	        JSONArray gridData = new JSONArray(userDList);
	        model.put("gridData",gridData);	
	        
	        //그리드2
	        List selectDimDetailList = commonService.selectList("dim_SQL.selectDimPertinentDetailList_gridList", commandMap);
 			JSONArray grid2Data = new JSONArray(selectDimDetailList);
 			model.put("grid2Data",grid2Data);	
 			
	        //그리드3
	        List selectDimRoleList = commonService.selectList("user_SQL.getMyDimRoleList_gridList", commandMap);
 			JSONArray grid3Data = new JSONArray(selectDimRoleList);
 			model.put("grid3Data",grid3Data);
 			
			model.put("memberID", request.getParameter("memberID"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
			model.put("dimTypeList", dimTypeList);
			model.put("authLev", authLev);
			model.put("scrnType", request.getParameter("scrnType"));
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/adm/user/sub/userDimList");
	}
	
	@RequestMapping(value = "/myDimAssignTreePop.do")
	public String myDimAssignTreePop(HttpServletRequest request, HashMap commandMap, ModelMap model)
			throws Exception {
		try {
			
			Map setMap = new HashMap();
			
			String btnName = "Assign";
			String btnStyle = "assign";
			String dimValues = "";
			setMap.put("memberID", StringUtil.checkNull(commandMap.get("memberID")));
			
			List DimList = (List) commonService.selectList("dim_SQL.getDimListWithMemberId", setMap);
			
			if(DimList != null && DimList.size() > 0) {
				for(int i=0; i<DimList.size(); i++) {
					Map temp = (Map)DimList.get(i);
					
					if(i==0) dimValues =    StringUtil.checkNull(temp.get("DimTypeID")) 
							        + "/" + StringUtil.checkNull(temp.get("DimValueID"));
					else dimValues += "," + StringUtil.checkNull(temp.get("DimTypeID")) 
							        + "/" + StringUtil.checkNull(temp.get("DimValueID"));					
				}
			}

			setMap.put("s_itemID", StringUtil.checkNull(commandMap.get("memberID")));
			String itemTypeCode =  commonService.selectString("item_SQL.selectedItemTypeCode", setMap);
			
			model.put("memberID",StringUtil.checkNull(request.getParameter("memberID"), ""));
			model.put("dimValues", dimValues);
			model.put("btnName", btnName);
			model.put("btnStyle", btnStyle);
			model.put("itemTypeCode", itemTypeCode);

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/popup/myDimAssignTreePop");
	}
	
    /**
	 * Dimension Assign Poup �솕硫댁뿉�꽌 [Add] �겢由� �씠踰ㅽ듃
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value="/admin/addDimensionForUser.do")
    public String addDimensionForUser(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
    	HashMap target = new HashMap();		
		try {
			 
			Map setMap = new HashMap(); 
			
			String itemID = request.getParameter("memberID");
			String dimValueIds = StringUtil.checkNull(request.getParameter("ids"));
		
			String[] arrayDimValueIds = dimValueIds.split(",");

			for (int i = 0; i < arrayDimValueIds.length; i++) {
				
				String dimValueID = arrayDimValueIds[i];
				String[] dimInfo = dimValueID.split("/");
		   
				// ItemID�쓽 ItemTypeCode, ClassCode 痍⑤뱷 
				if(dimInfo.length > 1) {
					
					
					commandMap.put("ItemID", itemID);  
					List itemInfoList = (List) commonService.selectList("dim_SQL.getItemTypeCodeAndClassCode", commandMap);
					Map itemInfoMap = (Map) itemInfoList.get(0);
					String itemTypeCode = itemInfoMap.get("ItemTypeCode").toString();
					String itemClassCode = itemInfoMap.get("ClassCode").toString();
					
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));
					setMap.put("itemID", dimInfo[0]);
					setMap.put("attrTypeCode", "AT00074");

					String maxLevel = StringUtil.checkNull(commonService.selectString("item_SQL.getItemAttrPlainText", setMap),"1");
					
					setMap.put("dimTypeID", dimInfo[0]); 
					setMap.put("dimValueID", dimInfo[1]);   
					
					String dimLevel = commonService.selectString("dim_SQL.getDimensionLevel", setMap);
					
					if(dimLevel.equals(maxLevel)) {
						
						setMap.put("ItemTypeCode", itemTypeCode);
						setMap.put("ItemClassCode", itemClassCode);
						setMap.put("ItemID", itemID);
						setMap.put("DimTypeID", dimInfo[0]); 
						setMap.put("DimValueID", dimInfo[1]);   
						setMap.put("Creator", commandMap.get("sessionUserId"));
						
						commonService.insert("dim_SQL.insertMyDim", setMap);
					}
				}
			}

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "this.assignClose();this.$('#isSubmit').remove();");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			//target.put(AJAX_ALERT, " ���옣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // �삤瑜� 諛쒖깮
		}
		
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
    /**
	 * User - Dimension �솕硫댁뿉�꽌 [Save] �겢由� �씠踰ㅽ듃
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value="/admin/saveDimensionForUser.do")
	public String saveDimensionForUser(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();  
		try{
			Map setMap = new HashMap();
			
			String memberID = request.getParameter("memberID");
			String isDeaultIds = StringUtil.checkNull(request.getParameter("isDeaultIds"));
			String dimTypeIds = StringUtil.checkNull(request.getParameter("dimTypeIds"));
			String dimValueIds = StringUtil.checkNull(request.getParameter("dimValueIds"));
			
			String[] arrayIsDeaultIds = isDeaultIds.split(",");
			String[] arrayDimTypeIds = dimTypeIds.split(",");
			String[] arrayDimValueIds = dimValueIds.split(",");
			
			for (int i = 0; i < arrayDimTypeIds.length; i++) {
				String isDeault = arrayIsDeaultIds[i];
				String dimTypeID = arrayDimTypeIds[i];
				String dimValueID = arrayDimValueIds[i];
			   
				setMap.put("isDeault", isDeault);
			   setMap.put("dimTypeID", dimTypeID);
			   setMap.put("dimValueID", dimValueID);    
			   setMap.put("memberID", memberID);   
			   
			   // UPDATE TB_MY_DIM_VALUE 
				commonService.update("dim_SQL.updateMyDimDefault", setMap);
			}
	   
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
			target.put(AJAX_SCRIPT, "this.doSearchList();this.$('#isSubmit').remove();");
			
	  } catch (Exception e) {
		  System.out.println(e);
		  target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
		  target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // ���옣 �삤瑜� 諛쒖깮
	  }
		model.addAttribute(AJAX_RESULTMAP, target);
        return nextUrl(AJAXPAGE);
    }
    
    /**
	 * Dimension �솕硫댁뿉�꽌 [Del] �겢由� �씠踰ㅽ듃
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value="/admin/delDimensionForUser.do")
	public String delDimensionForUser(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		HashMap target = new HashMap();  
		try{
			Map setMap = new HashMap();
			
			String memberID = request.getParameter("memberID");
			String dimTypeIds = StringUtil.checkNull(request.getParameter("dimTypeIds"));
			String dimValueIds = StringUtil.checkNull(request.getParameter("dimValueIds"));
			
			String[] arrayDimTypeIds = dimTypeIds.split(",");
			String[] arrayDimValueIds = dimValueIds.split(",");
			
			for (int i = 0; i < arrayDimTypeIds.length; i++) {
				String dimTypeID = arrayDimTypeIds[i];
				String dimValueID = arrayDimValueIds[i];

			   /* DELETE TB_ITEM_DIM */
			   setMap.put("DimTypeID", dimTypeID);
			   setMap.put("DimValueID", dimValueID);    
			   setMap.put("memberID", memberID);  
			   commonService.insert("dim_SQL.delMyDim", setMap);
			}
	   
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069")); // �궘�젣 �꽦怨�
			target.put(AJAX_SCRIPT, "this.doSearchList();this.$('#isSubmit').remove();");
			
	  } catch (Exception e) {
		  System.out.println(e);
		  target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
		  //target.put(AJAX_ALERT, "�궘�젣以� �삤瑜섍� 諛쒖깮�븯���뒿�땲�떎.");
		  target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜� 諛쒖깮
	  }
		model.addAttribute(AJAX_RESULTMAP, target);
        return nextUrl(AJAXPAGE);
    }
    
    @RequestMapping(value="/mbrAgentCfg.do")
    public String mbrAgentCfg(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
    	Map setMap = new HashMap();
    	try{
    		setMap.put("userID",StringUtil.checkNull(commandMap.get("sessionUserId")));
    		Map mbrAgent = commonService.select("user_SQL.getMemberStatus", setMap);
    		
    		// �떆�뒪�뀥 �궇吏� 
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date(System.currentTimeMillis()));
			String thisYmd = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
			
    		model.put("mbrAgent",mbrAgent);
    		model.put("thisYmd", thisYmd);
    		model.put("menu", getLabel(request, commonService));	/*Label Setting*/
    	}catch(Exception e){
   			System.out.println(e.toString());
   		}
   		return nextUrl("/adm/user/mbrAgentCfg");
       }
    
    /**
   	 * Member Agent �솕硫댁뿉�꽌 [save] �겢由� �씠踰ㅽ듃
   	 * @param request
   	 * @param model
   	 * @return
   	 * @throws Exception
   	 */
    @RequestMapping(value="/saveMbrAgent.do")
    public String saveMbrAgent(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
    	HashMap target = new HashMap();
    	Map setMap = new HashMap();
    	try{
    		String seq = StringUtil.checkNull(request.getParameter("seq"),"");
    		
    		String status = StringUtil.checkNull(request.getParameter("status"));
	    	String memberID = StringUtil.checkNull(request.getParameter("memberID"));
	    	setMap.put("sessionUserId",memberID);
	    	String mbrTeamID = commonService.selectString("user_SQL.userTeamID", setMap);
	    	String agentID = StringUtil.checkNull(request.getParameter("agentID"));
	    	setMap.put("sessionUserId",agentID);
	    	String agentTeamID = commonService.selectString("user_SQL.userTeamID", setMap);
	    	String dueDate =  request.getParameter("dueDate") != null ?  request.getParameter("dueDate").replaceAll("-","") : "";
	    	String roleCategory = StringUtil.checkNull(request.getParameter("roleCategory"),"");
	    	String userID = StringUtil.checkNull(request.getParameter("userID"),"");

	    	setMap.put("status",status);
	    	setMap.put("memberID",memberID);
	    	setMap.put("mbrTeamID",mbrTeamID);
	    	setMap.put("agentID",agentID);
	    	setMap.put("agentTeamID",agentTeamID);
	    	setMap.put("dueDate",dueDate);
	    	setMap.put("roleCategory",roleCategory);
	    	setMap.put("userID",userID);
	    	
	    	if(seq.equals("")||seq.equals(null)){
	    		seq = commonService.selectString("user_SQL.agentNextVal", setMap);
	    		setMap.put("seq",seq);
	    		commonService.insert("user_SQL.insertMemAgent", setMap);
	    	} else {
	    		setMap.put("seq",seq);
	    		commonService.update("user_SQL.updateMemAgent", setMap);
	    	}
	    	
	    	if(status.equals("0")){
	    		setMap.put("Active","1");
	    	} else {
	    		setMap.put("Active","0");
	    	}
	    	setMap.put("MemberID",memberID);
	    	commonService.update("user_SQL.updateUser", setMap);
	    	
			setMap.put("languageID",StringUtil.checkNull(commandMap.get("languageID")));
			setMap.remove("memberID");
			List list = commonService.selectList("user_SQL.getMbrAgentList", setMap);
			JSONArray gridData = new JSONArray(list);
	    	
	    	target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // ���옣 �꽦怨�
	    	target.put(AJAX_SCRIPT, "reload("+gridData+");");
	    	
    	} catch (Exception e) {
    		System.out.println(e);
    		target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // ���옣 �삤瑜� 諛쒖깮
		}
    	model.addAttribute(AJAX_RESULTMAP, target);
	    return nextUrl(AJAXPAGE);
    }
    
	@RequestMapping(value = "/deleteMbrAgent.do")
	public String deleteMbrAgent(HttpServletRequest request, HashMap commandMap, ModelMap model)throws Exception {
		HashMap setMap = new HashMap();
		HashMap target = new HashMap();
		try {
			String seq = StringUtil.checkNull(request.getParameter("seq"));
			String roleCategory = StringUtil.checkNull(request.getParameter("roleCategory"));
			String seqs[] = seq.split(",");
			
			for(int i=0; i<seqs.length; i++){
				setMap.put("seq", seqs[i]);
				commonService.delete("user_SQL.deleteMbrAgent", setMap);
			}
			
			setMap.put("languageID",StringUtil.checkNull(commandMap.get("languageID")));
			setMap.put("roleCategory",roleCategory);
			List list = commonService.selectList("user_SQL.getMbrAgentList", setMap);
			JSONArray gridData = new JSONArray(list);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00069"));
			target.put(AJAX_SCRIPT, "reload("+gridData+");");
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00070")); // �궘�젣 �삤瑜�			
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
    
    @RequestMapping(value="/viewMyInfo.do")
	public String viewMyInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try {
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			model.put("memberID", userID);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			
			Map setMap = new HashMap();
			setMap.put("MemberID", userID);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			model.put("getData", commonService.select("user_SQL.selectUser", setMap));
			
			model.put("teamTypeYN", StringUtil.checkNull(request.getParameter("teamTypeYN"),"Y"));
			
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl("adm/user/viewMyInfo");
	}
    
    @RequestMapping(value="/reqUserAuth.do")
	public String reqUserAuth(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
				
		try{
			HashMap setMap = new HashMap();
			String userId = StringUtil.checkNull(commandMap.get("sessionUserId"), "");
			String userNm = StringUtil.checkNull(commandMap.get("sessionUserNm"), "");
			String userEmpNm = StringUtil.checkNull(commandMap.get("sessionEmployeeNm"), "");
			String userTeamName = StringUtil.checkNull(commandMap.get("sessionTeamName"), "");
			String sysUserID = StringUtil.checkNull(request.getParameter("sysUserID"),"");
			
			setMap.put("userId", userId);
			setMap.put("userEmpNm", userEmpNm);
			setMap.put("userNm", userNm);
			setMap.put("userTeamName", userTeamName);
			setMap.put("targetUser", sysUserID);
			
			Map receiverMap = new HashMap();
			List receiverList = new ArrayList();

			receiverMap = new HashMap();
			receiverMap.put("receiptUserID", sysUserID);
			receiverMap.put("receiptType", "TO");
			receiverList.add(receiverMap);
				
			HashMap setMailData = new HashMap();
			setMailData.put("receiverList",receiverList);
			Map setMailMapRst = (Map)setEmailLog(request, commonService, setMailData, "RQUSRAUTH");
			
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("emailCode", "RQUSRAUTH");
			String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", setMap));
			setMap.put("emailHTMLForm", emailHTMLForm);
			
			if(StringUtil.checkNull(setMailMapRst.get("type")).equals("SUCESS") && !emailHTMLForm.equals("")){
				HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");
				
				Map resultMailMap = EmailUtil.sendMail(mailMap, setMap, getLabel(request, commonService));
				
				String BoardID = commonService.selectString("forum_SQL.boardNextVal", new HashMap());
				
				Map insertValMap = new HashMap();
				Map insertInfoMap = new HashMap();
				List insertList = new ArrayList();

				insertValMap.put("BoardMgtID", 4);
				insertValMap.put("boardID", BoardID);
				insertValMap.put("subject", userNm +" Requests editor right");
				insertValMap.put("content", userNm +" requested editor right.");
				insertValMap.put("userId", userId);
				insertValMap.put("s_itemID", "");
				insertValMap.put("projectID", ""); // Item�쓽 ProjectID�쓽 ParentID
				insertValMap.put("parentID", "");
				insertValMap.put("replyLev", 0);
				insertValMap.put("refID", BoardID);
				insertValMap.put("ItemMgtUserID","");
				// [TB_BOARD]�뀒�씠釉붿뿉 �뜲�씠�꽣 異붽�
				commonService.update("forum_SQL.forumInsert", insertValMap);
				
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMapRst.get("type")));
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00166")); // ���옣 �꽦怨�
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMapRst.get("msg")));
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00167")); // �삤瑜� 諛쒖깮
			}
			
		}catch(Exception e){
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();this.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00167")); // �삤瑜� 諛쒖깮
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
    
    @RequestMapping(value = "/mbrCsrList.do")
	public String mbrCsrList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{		
		try {
			Map setMap = new HashMap();
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String filter = StringUtil.checkNull(request.getParameter("filter"));
			String memberId = StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("memberID")));
			
			setMap.put("languageID", languageID);
			setMap.put("filter", filter);
			setMap.put("memberId", memberId);

	        List mbrCsList = commonService.selectList("project_SQL.getSetProjectListForCsr_gridList", setMap);
	        JSONArray gridData = new JSONArray(mbrCsList);
	        model.put("gridData",gridData);	
			
			model.put("memberID", StringUtil.replaceFilterString(StringUtil.checkNull(request.getParameter("memberID"))));	/*Label Setting*/
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/project/pjt/mbrCsrList");
	}
	
	@RequestMapping(value = "/viewMbrInfo.do")
	public String viewMbrInfo(HttpServletRequest request, HashMap cmmMap, ModelMap model)throws Exception {
		try {
				Map setMap = new HashMap();
				setMap.put("MemberID", StringUtil.checkNull(request.getParameter("memberID")));
				setMap.put("languageID", cmmMap.get("sessionCurrLangType") );
				
				Map authorInfoMap = commonService.select("item_SQL.getAuthorInfo", setMap);
				
				model.put("authorInfoMap", authorInfoMap);
				model.put("menu", getLabel(request, commonService)); /* Label Setting */

		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/adm/user/viewMbrInfo");
	}


	@RequestMapping(value="/roleManagerList.do")
	public String roleManagerList(HttpServletRequest request, ModelMap model) throws Exception{
		try {
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			
			model.put("clientID", StringUtil.checkNull(request.getParameter("clientID")));
			model.put("companyID", StringUtil.checkNull(request.getParameter("companyID")));
			model.put("teamID", StringUtil.checkNull(request.getParameter("teamID")));
			model.put("searchKey", StringUtil.checkNull(request.getParameter("searchKey")));
			model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
			model.put("active", StringUtil.checkNull(request.getParameter("active")));
			model.put("teamTypeYN", StringUtil.checkNull(request.getParameter("teamTypeYN"),"Y"));
			
			Map setMap = new HashMap();
			setMap.put("languageID", request.getParameter("languageID"));
			setMap.put("typeCode", "1");
			setMap.put("category", "TMTP");
			String labelNM = commonService.selectString("common_SQL.getNameFromDic",setMap);
			
			model.put("labelNM",labelNM);
		}
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}	
		return nextUrl("/adm/user/roleManagerList");
	}
	
	@RequestMapping(value="/getAutoMbrNMLIst.do")
	public void getAutoMbrNMLIst(HttpServletRequest request, HttpServletResponse response, HashMap commandMap, ModelMap model) throws Exception{
	    String searchValue = StringUtil.checkNull(request.getParameter("searchValue"));
	    String attrTypeCode = StringUtil.checkNull(request.getParameter("attrTypeCode"));
	    String itemTypeCode = StringUtil.checkNull(request.getParameter("itemTypeCode"));
	    String itemClassCode = StringUtil.checkNull(request.getParameter("itemClassCode"));
	    String sessionCurrLangUse = StringUtil.checkNull(request.getParameter("sessionCurrLangType"));
	    int searchListCnt = Integer.valueOf(StringUtil.checkNull(request.getParameter("searchListCnt"),"0"));
		Map setMap = new HashMap();
		JSONObject obj = new JSONObject();
		JSONArray company = new JSONArray();
		String keyValue = "";
		Map map;
		PrintWriter out;
		
		setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
		setMap.put("authority", "editor");
		List userList = commonService.selectList("organization_SQL.getUserList", setMap);
		JSONArray data = new JSONArray(userList);
		
		response.setContentType("text/html; charset=UTF-8");
		response.setHeader("Cache-control", "no-cache, no-store");
		response.setHeader("Pragma", "no-cache");
		response.setHeader("Expires", "-1");
		out = response.getWriter();
		
		out.println(data);
		out.close();
	}
	
	@RequestMapping(value="/admin/assignGroupManager.do")
	public String assignGroupManager(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		Map setMap = new HashMap();
				
		try{
			String memberID = StringUtil.checkNull(request.getParameter("memberID"),"");
			String s_itemID = StringUtil.checkNull(request.getParameter("s_itemID"),"");
			
			setMap.put("MemberID", s_itemID); //groupID
			setMap.put("SuperiorID", memberID);
			commonService.update("user_SQL.updateUser", setMap);
			
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 성공
			target.put(AJAX_SCRIPT, "fnCallBack();");
		}catch(Exception e){
			System.out.println(e.toString());
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/groupUsersList.do")
	public String groupUsersList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
		
		try {
			setMap.put("userID",StringUtil.checkNull(commandMap.get("sessionUserId")));
			// user group id list 
			List userGrMgtList = new ArrayList();
			userGrMgtList = commonService.selectList("user_SQL.getUserGrMgt", setMap);
			model.put("userGrMgtList", userGrMgtList);
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/		
		}catch(Exception e){
			System.out.println(e.toString());
		}
		return nextUrl("/adm/user/groupUsersList");
	}
	
	@RequestMapping(value = "/searchMemberPop.do")
	public String searchMemberPop(HttpServletRequest request, HashMap cmmMap, ModelMap model)throws Exception {
		try {
			model.put("searchValue", StringUtil.checkNull(request.getParameter("searchValue")));
			model.put("notCompanyIDs", StringUtil.checkNull(request.getParameter("notCompanyIDs")));
			model.put("myClient", StringUtil.checkNull(request.getParameter("myClient")));
			model.put("myWorkspace", StringUtil.checkNull(request.getParameter("myWorkspace")));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/adm/user/searchMemberPop");
	}
	
	@RequestMapping(value = "/userInfo.do")
	public void userInfo(HttpServletRequest request,  HttpServletResponse res, HashMap<String, Object> cmmMap, ModelMap model) throws Exception {
		JSONObject jsonObject = new JSONObject();
		Map setMap = new HashMap();
		
		res.setHeader("Cache-Control", "no-cache");
		res.setContentType("text/plain");
		res.setCharacterEncoding("UTF-8");
		
	    try {
	    	
	    	String memberID = StringUtil.checkNull(request.getParameter("memberID"),"");
	    	setMap.put("MemberID", memberID);
	    	setMap.put("languageID",StringUtil.checkNull(cmmMap.get("languageID")));
			Map userInfoMap = commonService.select("item_SQL.getAuthorInfo", setMap);	
			
			jsonObject.put("userInfo", userInfoMap);
	        res.getWriter().print(jsonObject);
	    } catch (Exception e) {
	        System.out.println(e.toString());
	        res.getWriter().print(jsonObject);
	    }
	}
	
	@RequestMapping(value="/userLogList.do")
	public String userLogList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
	
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date());
	
	    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	
		String selStartDate = StringUtil.checkNull(commandMap.get("startDate"), "");
		String selEndDate = StringUtil.checkNull(commandMap.get("endDate"), "");
		
		String endDate = df.format(calendar.getTime());
	    calendar.add(Calendar.DATE, -7);
		String StartDate = df.format(calendar.getTime());
	
		if(selStartDate.equals("") && selEndDate.equals("")) {
			selStartDate = StartDate;
			selEndDate = endDate;		
		}
	
	    setMap.put("startDate",selStartDate);
	    setMap.put("endDate",selEndDate);

		model.put("startDate", selStartDate);
		model.put("endDate", selEndDate);
		
		String reportCode = StringUtil.checkNull(commandMap.get("reportCode"));
		String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
		model.put("reportCode", reportCode);
		model.put("languageID", languageID);
		setMap.put("reportCode",reportCode);
		setMap.put("languageID",languageID);
		String reportName = StringUtil.checkNull(commonService.selectString("report_SQL.getReportName", setMap));
		model.put("title", reportName);
	
		List UserLogList = commonService.selectList("user_SQL.getUserLogList", setMap);
		JSONArray UserLogListData = new JSONArray(UserLogList);
		model.put("UserLogListData", UserLogListData);
		
		return nextUrl("/adm/user/userLogList");
	}
	
	@RequestMapping(value="/userMenuAccLogList.do")
	public String userMenuAccLogList(HttpServletRequest request, HashMap commandMap,ModelMap model) throws Exception{
		String url = "/adm/user/userMenuAccLogList"; 
		Map setMap = new HashMap();
		
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date());
	
	    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	
		String selStartDate = StringUtil.checkNull(commandMap.get("startDate"), "");
		String selEndDate = StringUtil.checkNull(commandMap.get("endDate"), "");
		
		String endDate = df.format(calendar.getTime());
	    calendar.add(Calendar.DATE, -7);
		String StartDate = df.format(calendar.getTime());
	
		if(selStartDate.equals("") && selEndDate.equals("")) {
			selStartDate = StartDate;
			selEndDate = endDate;		
		}
	
	    setMap.put("startDate",selStartDate);
	    setMap.put("endDate",selEndDate);

		model.put("startDate", selStartDate);
		model.put("endDate", selEndDate);
		
		String reportCode = StringUtil.checkNull(commandMap.get("reportCode"));
		String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
		model.put("reportCode", reportCode);
		model.put("languageID", languageID);
		setMap.put("reportCode",reportCode);
		setMap.put("languageID",languageID);
		String title = StringUtil.checkNull(commonService.selectString("report_SQL.getReportName", setMap));
		model.put("title", title);

		List UserMenuAccLogList = commonService.selectList("user_SQL.getUserMenuAccLogList", setMap);
		JSONArray UserMenuAccLogListData = new JSONArray(UserMenuAccLogList);
		model.put("UserMenuAccLogListData", UserMenuAccLogListData);
		
		return nextUrl(url);
	}
  
  
  @RequestMapping(value="/userMenuAccLogListStatistics.do")
	public String userMenuAccLogListStatistics(HttpServletRequest request, HashMap commandMap,ModelMap model) throws Exception{
	  String url = "/adm/user/userMenuAccLogListStatistics"; 
		Map setMap = new HashMap();
		
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date());
	
	    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	
		String selStartDate = StringUtil.checkNull(commandMap.get("startDate"), "");
		String selEndDate = StringUtil.checkNull(commandMap.get("endDate"), "");
		
		String endDate = df.format(calendar.getTime());
	    calendar.add(Calendar.DATE, -30);
		String StartDate = df.format(calendar.getTime());
	
		if(selStartDate.equals("") && selEndDate.equals("")) {
			selStartDate = StartDate;
			selEndDate = endDate;		
		}
	
	    setMap.put("startDate",selStartDate);
	    setMap.put("endDate",selEndDate);

		model.put("startDate", selStartDate);
		model.put("endDate", selEndDate);
		
		String reportCode = StringUtil.checkNull(commandMap.get("reportCode"));
		String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
		model.put("reportCode", reportCode);
		model.put("languageID", languageID);
		setMap.put("reportCode",reportCode);
		setMap.put("languageID",languageID);
		String title = StringUtil.checkNull(commonService.selectString("report_SQL.getReportName", setMap));
		model.put("title", title);
		
		List UserMenuAccLogListStatistics  = commonService.selectList("user_SQL.getUserMenuAccLogListStatistics", setMap);
		JSONArray UserMenuAccLogListStatisticsData = new JSONArray(UserMenuAccLogListStatistics);
		model.put("UserMenuAccLogListStatisticsData", UserMenuAccLogListStatisticsData);

		return nextUrl(url);
	}
  
  @RequestMapping(value="/userEmailLogList.do")
	public String userEmailLogList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		Map setMap = new HashMap();
	
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date());
	
	    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	
		String selStartDate = StringUtil.checkNull(commandMap.get("startDate"), "");
		String selEndDate = StringUtil.checkNull(commandMap.get("endDate"), "");
		
		String endDate = df.format(calendar.getTime());
	    calendar.add(Calendar.DATE, -30);
		String StartDate = df.format(calendar.getTime());
	
		if(selStartDate.equals("") && selEndDate.equals("")) {
			selStartDate = StartDate;
			selEndDate = endDate;		
		}
	
	    setMap.put("startDate",selStartDate);
	    setMap.put("endDate",selEndDate);

		model.put("startDate", selStartDate);
		model.put("endDate", selEndDate);
		
		String reportCode = StringUtil.checkNull(commandMap.get("reportCode"));
		String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
		model.put("reportCode", reportCode);
		model.put("languageID", languageID);
		setMap.put("reportCode",reportCode);
		setMap.put("languageID",languageID);
		String reportName = StringUtil.checkNull(commonService.selectString("report_SQL.getReportName", setMap));
		model.put("title", reportName);
	
		List UserEmailLogList = commonService.selectList("user_SQL.getUserEmailLogList", setMap);
		JSONArray UserEmailLogListData = new JSONArray(UserEmailLogList);
		model.put("UserEmailLogListData", UserEmailLogListData);
		
		return nextUrl("/adm/user/userEmailLogList");
	}
  
  @RequestMapping(value="/userEventLogList.do")
	public String userEventLogList(HttpServletRequest request, HashMap commandMap,ModelMap model) throws Exception{
		String url = "/adm/user/userEventLogList"; 
		Map setMap = new HashMap();
		
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date());
	
	    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	
		String selStartDate = StringUtil.checkNull(commandMap.get("startDate"), "");
		String selEndDate = StringUtil.checkNull(commandMap.get("endDate"), "");
		
		String endDate = df.format(calendar.getTime());
	    calendar.add(Calendar.DATE, -7);
		String StartDate = df.format(calendar.getTime());
	
		if(selStartDate.equals("") && selEndDate.equals("")) {
			selStartDate = StartDate;
			selEndDate = endDate;		
		}
	
	    setMap.put("startDate",selStartDate);
	    setMap.put("endDate",selEndDate);

		model.put("startDate", selStartDate);
		model.put("endDate", selEndDate);
		
		String reportCode = StringUtil.checkNull(commandMap.get("reportCode"));
		String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
		model.put("reportCode", reportCode);
		model.put("languageID", languageID);
		setMap.put("reportCode",reportCode);
		setMap.put("languageID",languageID);
		String title = StringUtil.checkNull(commonService.selectString("report_SQL.getReportName", setMap));
		model.put("title", title);

		List UserEventLogList = commonService.selectList("user_SQL.getUserEventLogList", setMap);
		JSONArray UserEventLogListData = new JSONArray(UserEventLogList);
		model.put("UserEventLogListData", UserEventLogListData);
		
		return nextUrl(url);
	}
}

