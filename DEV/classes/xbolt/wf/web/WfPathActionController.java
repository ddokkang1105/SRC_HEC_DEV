package xbolt.wf.web;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.MakeEmailContents;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonDataServiceImpl;
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
public class WfPathActionController extends XboltController {
	
	public static WfPathActionController wfPathActionController;

	@PostConstruct
    public void init() {
		wfPathActionController = this;
    }
	
	@Autowired
	@Resource(name = "commonService")
	private CommonService commonService;
	
	public Map getWfReviewItemInfo(HashMap commandMap) throws Exception { 	
		String returnVal = "";
		Map resultMap = new HashMap();
		
		try{ 			 
			CommonDataServiceImpl commonService2 = new CommonDataServiceImpl();
			String wfID = StringUtil.checkNull(commandMap.get("wfID")); 
			String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID")); 
			String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType")); 
			
			Map setMap = new HashMap(); 
			setMap.put("languageID", commandMap.get("sessionCurrLangType")); 
			setMap.put("wfID", wfID);
			setMap.put("WFID", wfID);
			setMap.put("wfDocType", wfDocType); 

			setMap.put("teamID",commandMap.get("sessionTeamId"));
			
			List pathList = wfPathActionController.commonService.selectList("user_SQL.getUserTeamManagerInfo", setMap);
		

			String memberIDs = "";
			String roleTypes = "";
			String wfStepInfo = "";
			
			if(pathList != null && !pathList.isEmpty()) {
				String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
				String userTeamID =  StringUtil.checkNull(commandMap.get("sessionTeamId"));
				String userTeamName =  StringUtil.checkNull(commandMap.get("sessionTeamName"));		
				
				// 매니저
				memberIDs = userID;
				roleTypes = "AREQ";
				wfStepInfo = userName+"("+userTeamName+") ";

				for(int i=0; i<pathList.size(); i++){
					Map itemMemberInfo = (Map)pathList.get(i);
					
					if(!"".equals(StringUtil.checkNull(itemMemberInfo.get("UserID")))) {
						wfStepInfo = wfStepInfo + " >> " 
						                        + StringUtil.checkNull(itemMemberInfo.get("MemberName")) 
						                        + "(" 
						                        + StringUtil.checkNull(itemMemberInfo.get("TeamName"))
	                    					    + ")";
						
						memberIDs = memberIDs +","+StringUtil.checkNull(itemMemberInfo.get("UserID"));
						roleTypes = roleTypes +",APRV";
					}
					
				}	
			}

			resultMap.put("memberIDs", memberIDs);
			resultMap.put("roleTypes", roleTypes);
			resultMap.put("wfStepInfo", wfStepInfo);
			
		} catch (Exception e) { 
			System.out.println(e); 
			throw new ExceptionUtil(e.toString()); 
		} 
		 
		return resultMap; 
	}

	public Map aprvBySysRole(HashMap commandMap) throws Exception {
		HashMap target = new HashMap();
		HashMap resultMap = new HashMap();

		try {
				HashMap setMap = new HashMap();
				String srID = StringUtil.checkNull(commandMap.get("srID"));
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				
				setMap.put("srID", srID);
				setMap.put("languageID", languageID);		
				String RequestUserID = StringUtil.checkNull(wfPathActionController.commonService.selectString("esm_SQL.getESMSRReqUserID", setMap));
		
				setMap.put("sessionUserId", RequestUserID);
				String reqTeamID =  StringUtil.checkNull(wfPathActionController.commonService.selectString("user_SQL.userTeamID",setMap));
				
				setMap.put("teamID", reqTeamID);
				Map managerInfo = wfPathActionController.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
				
				// team managerInfo 부재시 parent team manager 조회하여 결재 라인 생성
				if(managerInfo.isEmpty()){							
					String parentTeamID = wfPathActionController.commonService.selectString("user_SQL.getParentTeamID", setMap);
					setMap.put("teamID", parentTeamID);
					managerInfo = wfPathActionController.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
				}
				
				// List myItemMemberList = commonService.selectList("project_SQL.getMyItemFromSRList", setMap);
				String itemID = StringUtil.checkNull(commandMap.get("itemID"));
				String roleType = StringUtil.checkNull(commandMap.get("roleType"));
				String assignmentType = StringUtil.checkNull(commandMap.get("assignmentType"));
				
				if(itemID.equals("")){ itemID = StringUtil.checkNull(wfPathActionController.commonService.selectString("esm_SQL.getESMSRArea2", setMap)); }
				if(roleType.equals("")){ roleType = "I"; }
				if(assignmentType.equals("")){ assignmentType = "SRROLETP"; }
				
				setMap.put("itemID", itemID);
				setMap.put("roleType", roleType); // "I" 
				setMap.put("assignmentType", assignmentType); // "SRROLETP"
				List myItemMemberList = wfPathActionController.commonService.selectList("esm_SQL.getWFMemberList", setMap);
				
				String wfStepInfo = "";
				String memberIDs = "";
				String roleTypes = "";
				Map itemMemberInfo = new HashMap();
				// 상신자 
				String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
				String userTeamID =  StringUtil.checkNull(commandMap.get("sessionTeamId"));
				String userTeamName =  StringUtil.checkNull(commandMap.get("sessionTeamName"));		
				
				// 매니저
				String managerID = StringUtil.checkNull(managerInfo.get("UserID"));
				String managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
				String managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
				String managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));
				
				if(!managerID.equals("")){			
					memberIDs = userID+","+managerID;
					roleTypes = "AREQ,APRV";		
					wfStepInfo = userName+"("+userTeamName+") >> "+managerName+"("+managerTeamName+")";
				}else{// manager info null 이면  제거 
					memberIDs = userID;
					roleTypes = "AREQ";		
					wfStepInfo = userName+"("+userTeamName+")";
				}
		
				for(int i=0; i<myItemMemberList.size(); i++){
					itemMemberInfo = (Map)myItemMemberList.get(i); 			
					wfStepInfo = wfStepInfo + " >> " +StringUtil.checkNull(itemMemberInfo.get("WFStep"));
					memberIDs = memberIDs +","+StringUtil.checkNull(itemMemberInfo.get("MemberID"));
					//roleTypes = roleTypes +","+StringUtil.checkNull(itemMemberInfo.get("RoleType"));
					roleTypes = roleTypes +",APRV";
				}

				resultMap.put("memberIDs", memberIDs);
				resultMap.put("roleTypes", roleTypes);
				resultMap.put("wfStepInfo", wfStepInfo);
			
		} catch (Exception e) {
			System.out.println(e);												
		}
		return resultMap;
	}
	
	public Map aprvByManager(HashMap commandMap) throws Exception {
		HashMap target = new HashMap();
		HashMap resultMap = new HashMap();
		
		try {
				HashMap setMap = new HashMap();
				String srID = StringUtil.checkNull(commandMap.get("srID"));
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				
				setMap.put("teamID", commandMap.get("sessionTeamId"));
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				Map managerInfo = wfPathActionController.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
				
				// team managerInfo 부재시 parent team manager 조회하여 결재 라인 생성
				if(managerInfo.isEmpty()){							
					String parentTeamID = wfPathActionController.commonService.selectString("user_SQL.getParentTeamID", setMap);
					setMap.put("teamID", parentTeamID);
					managerInfo = wfPathActionController.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
				}
						
				// 상신자 
				String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
				String userTeamID =  StringUtil.checkNull(commandMap.get("sessionTeamId"));
				String userTeamName =  StringUtil.checkNull(commandMap.get("sessionTeamName"));		
				// 매니저
				String managerID = StringUtil.checkNull(managerInfo.get("UserID"));
				String managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
				String managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
				String managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));
				
				String memberIDs = userID+","+managerID;
				String roleTypes = "AREQ,APRV";		
				String wfStepInfo = userName+"("+userTeamName+") >> "+managerName+"("+managerTeamName+")";
				if(managerID.equals("")){// manager info null 이면  제거 
					memberIDs = userID;
					roleTypes = "AREQ";		
					wfStepInfo = userName+"("+userTeamName+")";
				}
				

				resultMap.put("memberIDs", memberIDs);
				resultMap.put("roleTypes", roleTypes);
				resultMap.put("wfStepInfo", wfStepInfo);
			
		} catch (Exception e) {
			System.out.println(e);												
		}
		return resultMap;
	}
	
	public Map aprvBySysPmRole(HashMap commandMap) throws Exception {
		HashMap target = new HashMap();
		HashMap resultMap = new HashMap();
		try {
				HashMap setMap = new HashMap();
				String projectID = StringUtil.checkNull(commandMap.get("projectID"));
				
				setMap.put("teamID", commandMap.get("sessionTeamId"));
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				Map managerInfo = wfPathActionController.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
				
				// team managerInfo 부재시 parent team manager 조회하여 결재 라인 생성
				if(managerInfo == null || managerInfo.isEmpty()){							
					String parentTeamID = commonService.selectString("user_SQL.getParentTeamID", setMap);
					setMap.put("teamID", parentTeamID);
					managerInfo = wfPathActionController.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
				}
				// 상신자 
				String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
				String userTeamID =  StringUtil.checkNull(commandMap.get("sessionTeamId"));
				String userTeamName =  StringUtil.checkNull(commandMap.get("sessionTeamName"));	
				
				// 매니저
				String managerID = StringUtil.checkNull(managerInfo.get("UserID"));
				String managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
				String managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
				String managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));
				
				setMap.put("projectID", projectID);
				Map pmInfo = wfPathActionController.commonService.select("project_SQL.getPjtAuthorInfo", setMap);
				
				String pmID = StringUtil.checkNull(pmInfo.get("AuthorID"));
				String pmName = StringUtil.checkNull(pmInfo.get("AuthorName"));
				String pmTeamName = StringUtil.checkNull(pmInfo.get("Name"));
				
				String memberIDs = userID+","+managerID+","+pmID;
				String roleTypes = "AREQ,APRV,APRV";		
				String wfStepInfo = userName+"("+userTeamName+") >> "+managerName+"("+managerTeamName+") >>" + pmName + "("+pmTeamName+")";
				
				if(managerID.equals("")){// manager info null 이면  제거 
					memberIDs = userID+","+pmID;
					roleTypes = "AREQ,APRV";		
					wfStepInfo = userName+"("+userTeamName+")>>" + pmName + "("+pmTeamName+")";
				}


				resultMap.put("memberIDs", memberIDs);
				resultMap.put("roleTypes", roleTypes);
				resultMap.put("wfStepInfo", wfStepInfo);
				
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생												
		}
		return resultMap;
	}
	
	public Map aprvByOrgPath(HashMap commandMap) throws Exception {
		HashMap target = new HashMap();
		HashMap resultMap = new HashMap();

		try {
				HashMap setMap = new HashMap();
				String srID = StringUtil.checkNull(commandMap.get("srID"));
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String limitType = "2";
								
				// 상신자 
				String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
				String userTeamID =  StringUtil.checkNull(commandMap.get("sessionTeamId"));
				String userTeamName =  StringUtil.checkNull(commandMap.get("sessionTeamName"));	
				
				setMap.put("teamID", commandMap.get("sessionTeamId"));
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("limitType", limitType);
				Map managerInfo = getTeamManagerInfo(StringUtil.checkNull(commandMap.get("sessionTeamId")),languageID,"",limitType);
				
				// team managerInfo 부재시 parent team manager 조회하여 결재 라인 생성
				if(managerInfo.isEmpty()){							
					String parentTeamID = wfPathActionController.commonService.selectString("user_SQL.getParentTeamID", setMap);
					managerInfo = getTeamManagerInfo(parentTeamID,languageID,"",limitType);
				}
					
				// 매니저
				String managerID = StringUtil.checkNull(managerInfo.get("UserID"));
				String managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
				String managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
				String managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));
				
				String memberIDs = userID+","+managerID;
				String roleTypes = "AREQ,APRV";		
				String wfStepInfo = userName+"("+userTeamName+") >> "+managerName+"("+managerTeamName+")";
				if(managerID.equals("")){// manager info null 이면  제거 
					memberIDs = userID;
					roleTypes = "AREQ";		
					wfStepInfo = userName+"("+userTeamName+")";
				}
				
				setMap.put("teamID", managerTeamID);
				String parentTeamID = StringUtil.checkNull(wfPathActionController.commonService.selectString("user_SQL.getParentTeamID", setMap),"");
				
				while(!"".equals(parentTeamID)) {
					
					managerInfo = getTeamManagerInfo(parentTeamID,languageID,"",limitType);
					
					managerID = StringUtil.checkNull(managerInfo.get("UserID"));
					managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
					managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
					managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));
					
					if(!managerID.equals("")){ 
						memberIDs += ","+managerID;
						roleTypes += ",APRV";		
						wfStepInfo += " >> "+managerName+"("+managerTeamName+")";
					}					
					
					setMap.put("teamID", managerTeamID);
					parentTeamID = StringUtil.checkNull(wfPathActionController.commonService.selectString("user_SQL.getParentTeamID", setMap),"");
					
				}


				resultMap.put("memberIDs", memberIDs);
				resultMap.put("roleTypes", roleTypes);
				resultMap.put("wfStepInfo", wfStepInfo);
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생												
		}
		
		return resultMap;
	}
	
	private Map getTeamManagerInfo(String teamID, String languageID, String teamType, String limitType) throws Exception {
		HashMap setMap = new HashMap();	
		
		setMap.put("teamID", teamID);
		setMap.put("languageID", languageID);
		setMap.put("teamType",teamType);
		setMap.put("limitType", limitType);
		Map resultMap = wfPathActionController.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
		
		
		return resultMap;
	}


	public Map getWFPathBySQLID(HashMap commandMap) throws Exception {
		HashMap target = new HashMap();
		HashMap resultMap = new HashMap();

		try {
				HashMap setMap = new HashMap();
				String wfID = StringUtil.checkNull(commandMap.get("wfID"));
				String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType"));
				String docSubClass = StringUtil.checkNull(commandMap.get("docSubClass"));
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
				setMap.put("wfID",wfID);
				setMap.put("wfDocType",wfDocType);
				setMap.put("docSubClass",docSubClass);
				setMap.put("languageID",languageID);

				String wfUrl = StringUtil.checkNull(wfPathActionController.commonService.selectString("wf_SQL.getWFURL", setMap));
				
				if(!"".equals(wfUrl)) {
					Map wfInfoMap = wfPathActionController.commonService.select(wfUrl, commandMap);
						
					resultMap.put("memberIDs", StringUtil.checkNull(wfInfoMap.get("memberIDs")));
					resultMap.put("roleTypes", StringUtil.checkNull(wfInfoMap.get("roleTypes")));
					resultMap.put("wfStepInfo", StringUtil.checkNull(wfInfoMap.get("wfStepInfo")));
				}
				else {	
					resultMap.put("memberIDs", "");
					resultMap.put("roleTypes", "");
					resultMap.put("wfStepInfo", "");
					
				}
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생

			resultMap.put("memberIDs", "");
			resultMap.put("roleTypes", "");
			resultMap.put("wfStepInfo", "");
		}
		
		return resultMap;
	}
	
	public Map zLF_getITSAprvPath(HashMap commandMap) throws Exception {
		HashMap target = new HashMap();
		HashMap resultMap = new HashMap();
		Map setMap = new HashMap();
		
		try {
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
			setMap.put("srID", srID);
			setMap.put("languageID", languageID);

			String RequestUserID = StringUtil.checkNull(wfPathActionController.commonService.selectString("esm_SQL.getESMSRReqUserID", setMap));
			setMap.put("userID", RequestUserID);
			
			Map managerInfo = wfPathActionController.commonService.select("user_SQL.getSupeiorManagerInfo", setMap);
			
			String itemID = StringUtil.checkNull(commandMap.get("itemID"));
			String roleType = StringUtil.checkNull(commandMap.get("roleType"));
			String assignmentType = StringUtil.checkNull(commandMap.get("assignmentType"));
			
			if(itemID.equals("")){ itemID = StringUtil.checkNull(wfPathActionController.commonService.selectString("esm_SQL.getESMSRArea2", setMap)); }
			if(roleType.equals("")){ roleType = "I"; }
			if(assignmentType.equals("")){ assignmentType = "SRROLETP"; }
			
			setMap.put("itemID", itemID);
			setMap.put("roleType", roleType); // "I" 
			setMap.put("assignmentType", assignmentType); // "SRROLETP"
			List myItemMemberList = wfPathActionController.commonService.selectList("esm_SQL.getWFMemberList", setMap);
			
			String wfStepInfo = "";
			String memberIDs = "";
			String roleTypes = "";
			Map itemMemberInfo = new HashMap();
			// 상신자 
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
			String userTeamID =  StringUtil.checkNull(commandMap.get("sessionTeamId"));
			String userTeamName =  StringUtil.checkNull(commandMap.get("sessionTeamName"));		
			
			// 결재 대무자
			setMap.put("userID",RequestUserID);
			setMap.put("roleCategory","WFROLETP");
    		Map mbrAgent = wfPathActionController.commonService.select("user_SQL.getMemberStatus", setMap);
			
			// 매니저
			String managerID = "";
			String managerName = "";
			String managerTeamID = "";
			String managerTeamName = "";
			
			// 추가 승인자
			String addApproverID = "";
			String myItmMemID = "";
			
			Map map = new HashMap();
			
			setMap.put("roleType","APRV");
			setMap.put("SRID",srID);
			List addApproverList = wfPathActionController.commonService.selectList("esm_SQL.getESMSRMember", setMap);
			
			if(addApproverList.size() > 0) {
				for(int i =0; i < addApproverList.size(); i++) {
					Map addApprover = (Map) addApproverList.get(i);
					addApproverID =  StringUtil.checkNull(addApprover.get("MemberID"));
					for(int j =0; j < myItemMemberList.size(); j++) {
						Map myItmMem = (Map) myItemMemberList.get(j);
						myItmMemID =  StringUtil.checkNull(myItmMem.get("MemberID"));
						if(addApproverID.equals(myItmMemID)) {
							 addApproverList.remove(i);
							 continue;
						}
					}
				}
			}
			
    		if(mbrAgent != null && !mbrAgent.isEmpty()){
				setMap.put("memberID",mbrAgent.get("AgentID"));
    			Map agentInfo = wfPathActionController.commonService.select("user_SQL.getMemberInfo", setMap);
    			
    			// 대무자
    			managerID = StringUtil.checkNull(mbrAgent.get("AgentID"));
				managerName = StringUtil.checkNull(mbrAgent.get("Name"));
				managerTeamName = StringUtil.checkNull(agentInfo.get("TeamName"));
				
				if(addApproverList.size() > 0) {
					for(int i =0; i < addApproverList.size(); i++) {
						Map addApprover = (Map) addApproverList.get(i);
						addApproverID =  StringUtil.checkNull(addApprover.get("MemberID"));
						if(addApproverID.equals(managerID)) {
							 addApproverList.remove(i);
							 continue;
						}
					}
				}
				
				if(addApproverList.size() > 0) {
					memberIDs = userID+",";
					roleTypes = "AREQ,";
					wfStepInfo = userName+"("+userTeamName+") >> ";
					for(int i=0; i < addApproverList.size(); i++) {
						map = (Map) addApproverList.get(i);
						memberIDs += StringUtil.checkNull(map.get("MemberID"))+",";
						roleTypes += "APRV,";
						wfStepInfo += StringUtil.checkNull(map.get("SRRefMember"))+" >> ";
					}
					memberIDs += managerID;
					roleTypes += "APRV";
					wfStepInfo += managerName+"("+managerTeamName+")";
				} else {
					memberIDs = userID+","+managerID;
					roleTypes = "AREQ,APRV";
					wfStepInfo = userName+"("+userTeamName+") >> "+managerName+"("+managerTeamName+")";
				}
			} else {
				if(managerInfo != null && !managerInfo.isEmpty()){
					managerID = StringUtil.checkNull(managerInfo.get("ManagerID"));
					managerName = StringUtil.checkNull(managerInfo.get("ManagerNM"));
					managerTeamID = StringUtil.checkNull(managerInfo.get("ManagerTeamID"));
					managerTeamName = StringUtil.checkNull(managerInfo.get("ManagerTeamNM"));
					
					if(addApproverList.size() > 0) {
						for(int i =0; i < addApproverList.size(); i++) {
							Map addApprover = (Map) addApproverList.get(i);
							addApproverID =  StringUtil.checkNull(addApprover.get("MemberID"));
							if(addApproverID.equals(managerID)) {
								 addApproverList.remove(i);
								 continue;
							}
						}
					}
				} else { // 상위 승인자(superiorID)가 없으면 0으로 표기하여 상신 진행 정지하고 ITS 담당자에게 문의 하라는 confirm 창 뜨게 설정
					managerID = "0";
					managerName = "N/A";
					managerTeamID = "";
					managerTeamName = "";
				}
				
				if(!managerID.equals("")){			
					if(addApproverList.size() > 0) {
						memberIDs = userID+",";
						roleTypes = "AREQ,";		
						wfStepInfo = userName+"("+userTeamName+") >> ";
						for(int i=0; i < addApproverList.size(); i++) {
							map = (Map) addApproverList.get(i);
							memberIDs += StringUtil.checkNull(map.get("MemberID"))+",";
							roleTypes += "APRV,";
							wfStepInfo += StringUtil.checkNull(map.get("SRRefMember"))+" >> ";
						}
						memberIDs += managerID;
						roleTypes += "APRV";
						wfStepInfo += managerName+"("+managerTeamName+")";
					} else {
						memberIDs = userID+","+managerID;
						roleTypes = "AREQ,APRV";
						wfStepInfo = userName+"("+userTeamName+") >> "+managerName+"("+managerTeamName+")";
					}
				}else{// manager info null 이면  제거 
					if(addApproverList.size() > 0) {
						memberIDs = userID;
						roleTypes = "AREQ";
						wfStepInfo = userName+"("+userTeamName+")";
						for(int i=0; i < addApproverList.size(); i++) {
							map = (Map) addApproverList.get(i);
							memberIDs += ","+StringUtil.checkNull(map.get("MemberID"));
							roleTypes += ",APRV";
							wfStepInfo += " >> "+StringUtil.checkNull(map.get("SRRefMember"));
						}
					} else {
						memberIDs = userID;
						roleTypes = "AREQ";
						wfStepInfo = userName+"("+userTeamName+")";
					}
				}
			}
			
			for(int i=0; i<myItemMemberList.size(); i++){
				itemMemberInfo = (Map)myItemMemberList.get(i); 
				String myItemMember = StringUtil.checkNull(itemMemberInfo.get("MemberID"));
				if(!managerID.equals(myItemMember)){
					// 요청자와 서비스결재자(I)가 동일하지 않을 경우만 결재선 추가
					if(!RequestUserID.equals(myItemMember)) {
						wfStepInfo = wfStepInfo + " >> " +StringUtil.checkNull(itemMemberInfo.get("WFStep"));
						memberIDs = memberIDs +","+myItemMember;
						roleTypes = roleTypes +",APRV";
					}
				}
			}

			resultMap.put("memberIDs", memberIDs);
			resultMap.put("roleTypes", roleTypes);
			resultMap.put("wfStepInfo", wfStepInfo);
			
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생												
		}
		return resultMap;
	}
	
	//현대 케피코용 결재선 함수
	public Map zhkfc_aprvBySysRole(HashMap commandMap) throws Exception {
		HashMap target = new HashMap();
		HashMap resultMap = new HashMap();

		try {
				HashMap setMap = new HashMap();
				String changeSetID = StringUtil.checkNull(commandMap.get("changeSetID"));
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				
				String defaultLang = wfPathActionController.commonService.selectString("item_SQL.getDefaultLang", setMap);
				String modeEN = "N";
				if(!languageID.equals(defaultLang)) {
					modeEN = "Y";
				}
				
				setMap.put("changeSetID", changeSetID);
				
				String itemID = StringUtil.checkNull(wfPathActionController.commonService.selectString("cs_SQL.getItemIDForCSID", setMap));
				
				// 상신자
				String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
				String userTeamID =  StringUtil.checkNull(commandMap.get("sessionTeamId"));
				String userTeamName =  StringUtil.checkNull(commandMap.get("sessionTeamName"));		
				
				// 승인자3 정보 (팀장)
				setMap.put("teamID", commandMap.get("sessionTeamId"));
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				Map managerInfo = wfPathActionController.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
				
				String managerID = StringUtil.checkNull(managerInfo.get("UserID"));
				setMap.put("memberID", managerID);
				Map mngInfo = wfPathActionController.commonService.select("user_SQL.getMemberInfo", setMap);
				String managerName = StringUtil.checkNull(mngInfo.get("Name"));
				if("Y".equals(modeEN)) {
					managerName = StringUtil.checkNull(mngInfo.get("NameEN"));
				}
				
				String managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
				String managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));
				
				// 승인자1 정보 (담당자(부))
				setMap.put("itemID", itemID);
				setMap.put("orderNum", "0");
				setMap.put("assignmentType","CNGROLETP");
				String  prtMemberID = StringUtil.checkNull(wfPathActionController.commonService.selectString("item_SQL.getMyItemMemberIDTop1", setMap));
				setMap.remove("assignmentType");
				
				Map prtInfo = new HashMap();
				String prtName = "";
				String prtTeamName = "";
				if(!"".equals(prtMemberID)) {
					setMap.put("memberID", prtMemberID);
					prtInfo = wfPathActionController.commonService.select("user_SQL.getMemberInfo", setMap);
					prtName = StringUtil.checkNull(prtInfo.get("Name"));
					if("Y".equals(modeEN)) {
						prtName = StringUtil.checkNull(prtInfo.get("NameEN"));
					}
					prtTeamName = StringUtil.checkNull(prtInfo.get("TeamName"));
				}	
				
				// 승인자4 정보 (GM장) 
				setMap.put("teamID", userTeamID);
				Map gmInfo = wfPathActionController.commonService.select("custom_SQL.zhkfc_getAprvGMInfo", setMap);
				String gmMemberID = "";
				if(gmInfo != null && !gmInfo.isEmpty()) {
					String GIM_EMP_NO = StringUtil.checkNull(gmInfo.get("GIM_EMP_NO"));
					if(!GIM_EMP_NO.equals("")) {
						setMap.put("employeeNum", GIM_EMP_NO);
						gmMemberID = StringUtil.checkNull(wfPathActionController.commonService.selectString("user_SQL.getMemberIDFromEmpNO", setMap));
						setMap.remove("employeeNum");
					}
				}
				setMap.remove("teamID");
				
				// [STEP1] [상신] 상신자
				String memberIDs = userID;
				String roleTypes = "AREQ";		
				String wfStepInfo = userName+"("+userTeamName+")";
				
				// [STEP2] [승인] 승인자 1 : 해당 문서의 담당자 ( 상신자 == 담당자 일 경우 pass )
				if(!"".equals(prtMemberID)&& !userID.equals(prtMemberID)) {
					memberIDs += "," + prtMemberID;
					roleTypes += ",APRV";		
					wfStepInfo += " >> " + prtName+"("+prtTeamName+")";
				}
				
				// [STEP3] [승인] 승인자 2 : 조직도 상 팀원 상위의 WG장
				setMap.put("userID", commandMap.get("sessionUserId"));
				String wgMemberID = "";
				Map wgInfo = wfPathActionController.commonService.select("custom_SQL.zhkfc_getAprvWGInfo", setMap);
				
				int j = 0;
				if(wgInfo != null && !wgInfo.isEmpty()) {
					String GIM_EMP_NO = StringUtil.checkNull(wgInfo.get("GIM_EMP_NO"));
					if(!GIM_EMP_NO.equals("")) {
						setMap.put("employeeNum", GIM_EMP_NO);
						wgMemberID = StringUtil.checkNull(wfPathActionController.commonService.selectString("user_SQL.getMemberIDFromEmpNO", setMap));
						
						if(!"".equals(wgMemberID) && !userID.equals(wgMemberID) && !prtMemberID.equals(wgMemberID)) {
							setMap.put("memberID", wgMemberID);
							Map memberInfo = wfPathActionController.commonService.select("user_SQL.getMemberInfo", setMap);

							String wgName = StringUtil.checkNull(memberInfo.get("Name"));
							if("Y".equals(modeEN)) {
								wgName = StringUtil.checkNull(memberInfo.get("NameEN"));
							}
							String wgTeamName = StringUtil.checkNull(memberInfo.get("TeamName"));
							
							memberIDs += "," + wgMemberID;
							roleTypes += ",APRV";		
							if(j == 0) {
								wfStepInfo += " >> " + wgName+"("+wgTeamName+")";
								j++;
							}
							else {
								wfStepInfo += " , " + wgName+"("+wgTeamName+")";
							}
						}
					}
				}
				setMap.remove("userID");
				
				
				// [STEP4] [병렬합의] 병렬합의자(다수) : 해당 문서의 관련조직에 입력된 조직 팀장 (관련조직의 팀장이 없을 경우, 관련조직 상위의 GM)
				String mgtManagerID = "";
				String recMBIDs = "";
				String recWfStepInfo = "";
				String varFilter ="";
				setMap.put("MenuID", "MN166");
				varFilter =  wfPathActionController.commonService.selectString("menu_SQL.getMenuVarfilter", setMap);
				varFilter = varFilter.split("isSubItem=")[1].split("&")[0]; // → "Y"
				
				setMap.put("asgnOption", "1,2");
				setMap.put("companyID","1"); //해외법인 오픈 전 까지 KGP 만 검색
				List<Map<String, Object>> itemList = new ArrayList<>();
				
				if("Y".equals(varFilter)) {
					setMap.put("roleTypes", "'R','A','S','I','C'");
					 itemList = wfPathActionController.commonService.selectList("role_SQL.getSubItemRoleList_gridList", setMap);
				}else {
					setMap.put("roleTypes", "'R','C','S'");
					 itemList = wfPathActionController.commonService.selectList("role_SQL.getItemTeamRoleList_gridList", setMap);
					
				}
			

				Map mgtInfoMap = wfPathActionController.commonService.select("item_SQL.getItemClsMgtInfo", setMap);

				if(mgtInfoMap != null && !mgtInfoMap.isEmpty()) {
					mgtManagerID = StringUtil.checkNull(mgtInfoMap.get("MgtRoleManagerID"));
				}		
				
				j = 0;
				if(itemList != null) {
					for(int i=0; i < itemList.size(); i++) {
						Map temp = (Map)itemList.get(i);
						String roleMnID = StringUtil.checkNull(temp.get("TeamManagerID"));
						String teamID = StringUtil.checkNull(temp.get("TeamID"));
						
						setMap.put("memberID", roleMnID);
						if (!("112").equals(teamID)) { // 협력사 제외
							if(!wgMemberID.equals(roleMnID) && !managerID.equals(roleMnID)
							&& !mgtManagerID.equals(roleMnID) && !"".equals(roleMnID)
							&& !userID.equals(roleMnID) && !prtMemberID.equals(roleMnID) && !gmMemberID.equals(roleMnID)) {
								Map mnInfo = wfPathActionController.commonService.select("user_SQL.getMemberInfo", setMap);
								String name = StringUtil.checkNull(mnInfo.get("Name"));
								if("Y".equals(modeEN)) {
									name = StringUtil.checkNull(mnInfo.get("NameEN"));
								}
								
								memberIDs += ","+roleMnID;
								roleTypes += ",PAGR";	
								
								if(j == 0) {
									wfStepInfo += " >> " + name+"("+StringUtil.checkNull(mnInfo.get("TeamName"))+")";
									j++;
								}
								else {
									wfStepInfo += " , " + name+"("+StringUtil.checkNull(mnInfo.get("TeamName"))+")";
								}
							}
							else if ("".equals(roleMnID)) {
								//  팀장이 없을 경우, 상위의 GM
								String rolTeamID = StringUtil.checkNull(temp.get("TeamID"));
								setMap.put("teamID", rolTeamID);
								
								Map roleGmInfo = wfPathActionController.commonService.select("custom_SQL.zhkfc_getAprvGMInfo", setMap);
								String roleGmMemberID = "";
								if(roleGmInfo != null && !roleGmInfo.isEmpty()) {
									String GIM_EMP_NO = StringUtil.checkNull(roleGmInfo.get("GIM_EMP_NO"));
									if(!GIM_EMP_NO.equals("")) {
										setMap.put("employeeNum", GIM_EMP_NO);
										roleGmMemberID = StringUtil.checkNull(wfPathActionController.commonService.selectString("user_SQL.getMemberIDFromEmpNO", setMap));
										setMap.remove("employeeNum");
									}
								}
								setMap.remove("teamID");
								
								if(!userID.equals(roleGmMemberID) && !prtMemberID.equals(roleGmMemberID)
								&& !managerID.equals(roleGmMemberID) && !wgMemberID.equals(roleGmMemberID)
								&& !gmMemberID.equals(roleGmMemberID) && !"".equals(roleGmMemberID)) {
									setMap.put("memberID", roleGmMemberID);
									Map mnInfo2 = wfPathActionController.commonService.select("user_SQL.getMemberInfo", setMap);
									String name = StringUtil.checkNull(mnInfo2.get("Name"));
									if("Y".equals(modeEN)) {
										name = StringUtil.checkNull(mnInfo2.get("NameEN"));
									}
									
									memberIDs += ","+roleGmMemberID;
									roleTypes += ",PAGR";
									
									if(j == 0) {
										wfStepInfo += " >> " + name+"("+StringUtil.checkNull(mnInfo2.get("TeamName"))+")";
										j++;
									}
									else {
										wfStepInfo += " , " + name+"("+StringUtil.checkNull(mnInfo2.get("TeamName"))+")";
									}
								}
							}
						}
					}
				}
				
				// [STEP5] [승인] 승인자3 : 조직도 상 팀원 상위의 팀장  ( tb_team 의 managerID )
				if(!prtName.equals(managerName) && !prtTeamName.equals(managerName)
				&& !prtMemberID.equals(managerID) && !wgMemberID.equals(managerID)
				&& !"".equals(managerID)) {
					memberIDs += "," + managerID;
					roleTypes += ",APRV";		
					wfStepInfo += " >> " + managerName+"("+managerTeamName+")";
					
				}
				
				// [STEP6] [승인] 승인자4 : 조직도 상 상위의 주재원 GM
				if(!userID.equals(gmMemberID) && !prtMemberID.equals(gmMemberID)
					&& !managerID.equals(gmMemberID) && !wgMemberID.equals(gmMemberID)
					&& !"".equals(gmMemberID)) {
					
					setMap.put("memberID", gmMemberID);
					Map memberInfo = wfPathActionController.commonService.select("user_SQL.getMemberInfo", setMap);
					
					String wgName = StringUtil.checkNull(memberInfo.get("Name"));
					if("Y".equals(modeEN)) {
						wgName = StringUtil.checkNull(memberInfo.get("NameEN"));
					}
					
					String wgTeamName = StringUtil.checkNull(memberInfo.get("TeamName"));
					
					memberIDs += "," + gmMemberID;
					roleTypes += ",APRV";		
					wfStepInfo += " >> " + wgName+"("+wgTeamName+")";
					
				}

				resultMap.put("memberIDs", memberIDs);
				resultMap.put("roleTypes", roleTypes);
				resultMap.put("wfStepInfo", wfStepInfo);
				resultMap.put("recWfStepInfo", recWfStepInfo);
				resultMap.put("recMBIDs", recMBIDs);
		} catch (Exception e) {
			System.out.println(e);												
		}
		return resultMap;
	}
	
	//한화 큐셀 용 TOBE 프로세스 승인 결재선 함수
	public Map zHQC_wfPath4ToBeProc(HashMap commandMap) throws Exception {
		HashMap target = new HashMap();
		HashMap resultMap = new HashMap();

		try {
				HashMap setMap = new HashMap();
				String changeSetID = StringUtil.checkNull(commandMap.get("changeSetID"));
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				
				setMap.put("changeSetID", changeSetID);
				
				String itemID = StringUtil.checkNull(wfPathActionController.commonService.selectString("cs_SQL.getItemIDForCSID", setMap));
				
				setMap.put("teamID", commandMap.get("sessionTeamId"));
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				Map managerInfo = wfPathActionController.commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
				
				// 상신자 
				String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
				String userTeamID =  StringUtil.checkNull(commandMap.get("sessionTeamId"));
				String userTeamName =  StringUtil.checkNull(commandMap.get("sessionTeamName"));		
				// 매니저
				String managerID = StringUtil.checkNull(managerInfo.get("UserID"));
				String managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
				String managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
				String managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));
				
				String memberIDs = userID;
				String roleTypes = "AREQ";		
				String wfStepInfo = userName+"("+userTeamName+")";
				
				setMap.put("itemID", itemID);
				setMap.put("isAll", "N");
				setMap.put("assignmentType", "CNGROLETP");
				setMap.put("roleType", "A");
				
				List itemList = wfPathActionController.commonService.selectList("role_SQL.getAssignedRoleList_gridList", setMap);

				if(itemList != null) {
					for(int i=0; i < itemList.size(); i++) {
						Map temp = (Map)itemList.get(i);
						String memberID = StringUtil.checkNull(temp.get("MemberID"));
						
						setMap.put("memberID", memberID);
						Map mnInfo = wfPathActionController.commonService.select("user_SQL.getMemberInfo", setMap);

						memberIDs += ","+memberID;
						roleTypes += ",APRV";	
						
						if(i == 0) {
							wfStepInfo += " >> " + StringUtil.checkNull(mnInfo.get("Name"))+"("+StringUtil.checkNull(mnInfo.get("TeamName"))+")";						
						}
						else {
							wfStepInfo += " >> " + StringUtil.checkNull(mnInfo.get("Name"))+"("+StringUtil.checkNull(mnInfo.get("TeamName"))+")";	
						}
					}
				}	

				resultMap.put("memberIDs", memberIDs);
				resultMap.put("roleTypes", roleTypes);
				resultMap.put("wfStepInfo", wfStepInfo);
		} catch (Exception e) {
			System.out.println(e);												
		}
		return resultMap;
	}
	
	public Map aprvByManual(HashMap commandMap) throws Exception {
		HashMap target = new HashMap();
		HashMap resultMap = new HashMap();
		
		try {
				// TODO
			
		} catch (Exception e) {
			System.out.println(e);												
		}
		return resultMap;
	}
	
	//DLM ITSM 결재선
	public Map zDlm_wfPathITSM(HashMap commandMap) throws Exception {
		HashMap resultMap = new HashMap();
		try {
				HashMap setMap = new HashMap();
				// 상신자 
				String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
				String userTeamID =  StringUtil.checkNull(commandMap.get("sessionTeamId"));
				String userTeamName =  StringUtil.checkNull(commandMap.get("sessionTeamName"));		
				
				String memberIDs = userID;
				String roleTypes = "AREQ";		
				String wfStepInfo = userName;
				
				setMap.put("srID", StringUtil.checkNull(commandMap.get("srID")));		
				setMap.put("languageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));		
				Map srReqUserInfo = wfPathActionController.commonService.select("esm_SQL.getESMReqUserInfo", setMap);
				
				memberIDs += ","+ StringUtil.checkNull(srReqUserInfo.get("MemberID"));
				roleTypes += ",APRV";	
				wfStepInfo += " >> " + StringUtil.checkNull(srReqUserInfo.get("Name"));	

				resultMap.put("memberIDs", memberIDs);
				resultMap.put("roleTypes", roleTypes);
				resultMap.put("wfStepInfo", wfStepInfo);
		} catch (Exception e) {
			System.out.println(e);												
		}
		return resultMap;
	}
	
	
}
