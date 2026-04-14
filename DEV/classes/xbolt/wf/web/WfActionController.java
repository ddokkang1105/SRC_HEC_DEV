package xbolt.wf.web;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.org.json.JSONArray;

import xbolt.app.esp.main.util.ESPUtil;
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
public class WfActionController extends XboltController{
	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/selectWFMemberPop.do")
	public String selectWFMemberPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		try {				
				String flg = StringUtil.checkNull(request.getParameter("flg"));
				String roleTypes = StringUtil.checkNull(request.getParameter("tmpSelSHR"));
				String selectMember = StringUtil.checkNull(request.getParameter("SelectMember"),"");

				model.put("tmpSelSHR",roleTypes.replace("AREQ,", "").replaceAll("APRV", "S").replaceAll("PAGR","P").replaceAll("AGR","H").replaceAll("REW", "W"));
				model.put("wfLabel",getLabel(request, commonService,"WFSTEP"));
				model.put("selectMember",selectMember.substring(selectMember.indexOf(",")+1));
				model.put("flg", flg); 
				model.put("menuStyle", "csh_organization");
				model.put("arcCode", "AR000002");
				model.put("menu", getLabel(request, commonService)); /* Label Setting */
				model.put("agrYN", StringUtil.checkNull(request.getParameter("agrYN"),"N"));
				model.put("agrSeq", StringUtil.checkNull(commonService.selectString("wf_SQL.getAgrSeq",commandMap),""));
				model.put("clientID", StringUtil.checkNull(request.getParameter("clientID")));
		} catch (Exception e) {
			System.out.println(e.toString());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("wf/selectWFMemberPop");
	}
	

	
	@RequestMapping(value = "/afterSubmitCheck.do")
	public String afterSubmitCheck(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		List wfInstList = new ArrayList();
		// 회원 정보\
		try {
			
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
			String modeEN = "N";
			if(!languageID.equals(defaultLang)) {
				modeEN = "Y";
			}
			
			String wfStepMemberID = StringUtil.checkNull(commandMap.get("wfStepMemberIDs"));
			String wfStepRefMemberID = StringUtil.checkNull(commandMap.get("wfStepRefMemberIDs"));
			String wfStepRecMemberID = StringUtil.checkNull(commandMap.get("wfStepRecMemberIDs"));
			String wfStepRecTeamID = StringUtil.checkNull(commandMap.get("wfStepRecTeamIDs"));
			String wfStepRoleType = StringUtil.checkNull(commandMap.get("wfStepRoleTypes"));
			String endGRID = StringUtil.checkNull(commandMap.get("endGRID"));
			
				
			String wfStepMemberIDs[] = null;
			String wfStepRefMemberIDs[] = null;
			String wfStepRecMemberIDs[] = null;
			String wfStepRecTeamIDs[] = null;
			String wfStepRoleTypes[] = null;
			
			if(!wfStepMemberID.isEmpty()){ wfStepMemberIDs = wfStepMemberID.split(","); }
			if(!wfStepRoleType.isEmpty()){ wfStepRoleTypes = wfStepRoleType.split(","); }
			if(!wfStepRefMemberID.isEmpty()){ wfStepRefMemberIDs = wfStepRefMemberID.split(","); }
			if(!wfStepRecMemberID.isEmpty()){ wfStepRecMemberIDs = wfStepRecMemberID.split(","); }
			if(!wfStepRecTeamID.isEmpty()){ wfStepRecTeamIDs = wfStepRecTeamID.split(","); }
			
			if(!wfStepMemberID.isEmpty()){ 
				
				for(int i=0; i<wfStepMemberIDs.length; i++) {
					if(!wfStepRoleTypes[i].equals("MGT") && !wfStepRoleTypes[i].equals("REF")) {
						Map temp3 = new HashMap();
						
						setMap.put("memberID",wfStepMemberIDs[i]);
						setMap.put("languageID", commandMap.get("sessionCurrLangType"));					
						Map temp = commonService.select("user_SQL.getMemberInfo", setMap);
						
						if("Y".equals(modeEN)) {
							temp3.put("ActorName", temp.get("NameEN"));
						} else {
							temp3.put("ActorName", temp.get("Name"));
						}
						
						temp3.put("TeamName", temp.get("TeamName"));
						temp3.put("Position", temp.get("Position"));
						
						setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
						setMap.put("Category","WFSTEP");
						setMap.put("TypeCode",wfStepRoleTypes[i]);
						
						Map temp2 = commonService.select("common_SQL.label_commonSelect", setMap);
						
						temp3.put("WFStepName", temp2.get("LABEL_NM"));
						wfInstList.add(temp3);
					}
				}
				
				if(!"".equals(endGRID)) {
					Map temp3 = new HashMap();
							
					setMap.put("memberID",endGRID);
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));					
					Map temp = commonService.select("user_SQL.getMemberInfo", setMap);
					if("Y".equals(modeEN)) {
						temp3.put("ActorName", temp.get("NameEN"));
					} else {
						temp3.put("ActorName", temp.get("Name"));
					}
					
					temp3.put("TeamName", temp.get("TeamName"));
					temp3.put("Position", temp.get("Position"));
					
					setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
					setMap.put("Category","WFSTEP");
					setMap.put("TypeCode","APRV");
					
					Map temp2 = commonService.select("common_SQL.label_commonSelect", setMap);
					
					temp3.put("WFStepName", temp2.get("LABEL_NM"));
					wfInstList.add(temp3);
				}
			
			}
			if(wfStepRefMemberID != null && !wfStepRefMemberID.isEmpty()){ 
				for(int i=0; i<wfStepRefMemberIDs.length; i++) {
					Map temp3 = new HashMap();
					
					setMap.put("memberID",wfStepRefMemberIDs[i]);
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));					
					Map temp = commonService.select("user_SQL.getMemberInfo", setMap);
					if("Y".equals(modeEN)) {
						temp3.put("ActorName", temp.get("NameEN"));
					} else {
						temp3.put("ActorName", temp.get("Name"));
					}
					
					temp3.put("TeamName", temp.get("TeamName"));
					temp3.put("Position", temp.get("Position"));
					
					setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
					setMap.put("Category","WFSTEP");
					setMap.put("TypeCode","REF");
					
					Map temp2 = commonService.select("common_SQL.label_commonSelect", setMap);
					
					temp3.put("WFStepName", temp2.get("LABEL_NM"));
					wfInstList.add(temp3);
				}
			}
			

			if(wfStepRecMemberID != null && !wfStepRecMemberID.isEmpty()){ 
				for(int i=0; i<wfStepRecMemberIDs.length; i++) {
					Map temp3 = new HashMap();
					
					setMap.put("memberID",wfStepRecMemberIDs[i]);
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));					
					Map temp = commonService.select("user_SQL.getMemberInfo", setMap);
					if("Y".equals(modeEN)) {
						temp3.put("ActorName", temp.get("NameEN"));
					} else {
						temp3.put("ActorName", temp.get("Name"));
					}
					temp3.put("TeamName", temp.get("TeamName"));
					temp3.put("Position", temp.get("Position"));
					
					setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
					setMap.put("Category","WFSTEP");
					setMap.put("TypeCode","REC");
					
					Map temp2 = commonService.select("common_SQL.label_commonSelect", setMap);
					
					temp3.put("WFStepName", temp2.get("LABEL_NM"));
					wfInstList.add(temp3);
				}
			}

			if(wfStepRecTeamID != null && !wfStepRecTeamID.isEmpty()){ 
				for(int i=0; i<wfStepRecTeamIDs.length; i++) {
					Map temp3 = new HashMap();
					
					setMap.put("teamID",wfStepRecTeamIDs[i]);
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));					
					String temp = commonService.selectString("organization_SQL.getTeamName", setMap);
					temp3.put("ActorName", temp);
					temp3.put("TeamName", temp);
					
					setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
					setMap.put("Category","WFSTEP");
					setMap.put("TypeCode","REC");
					
					Map temp2 = commonService.select("common_SQL.label_commonSelect", setMap);
					
					temp3.put("WFStepName", temp2.get("LABEL_NM"));
					wfInstList.add(temp3);
				}
			}
			
			
			model.put("wfInstList",wfInstList);
			model.put("menu", getLabel(request, commonService)); /*Label Setting*/	
			
		} catch (Exception e) {
			System.out.println(e.toString());
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/wf/afterSubmitCheckPop");
	}
	
	
	

	@RequestMapping(value = "/submitOLMWfInst.do")
	public String submitOLMWfInst(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		try {
				HashMap setData = new HashMap();
				HashMap setMap = new HashMap();
				HashMap insertWFInstData = new HashMap();
				
				String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
				String projectID = StringUtil.checkNull(commandMap.get("projectID"));
				String docSubClass = StringUtil.checkNull(commandMap.get("docSubClass"));
				String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType"));
				String wfID = StringUtil.checkNull(commandMap.get("wfID"),"");
	
				if("".equals(wfID))
					wfID = StringUtil.checkNull(commandMap.get("wfID2"));
				
				if(wfID.indexOf("(") > 0)
					wfID = wfID.substring(0,wfID.indexOf("("));
												
				setData.put("wfID", wfID);
				String newWFInstanceID = "";
				
				//SET NEW WFInstance ID
				String maxWFInstanceID = commonService.selectString("wf_SQL.MaxWFInstanceID", setData);
				String OLM_SERVER_NAME = GlobalVal.OLM_SERVER_NAME;
				int OLM_SERVER_NAME_LENGTH = GlobalVal.OLM_SERVER_NAME.length();	
				String initLen = "%0" + (13-OLM_SERVER_NAME_LENGTH) + "d";
				
				int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(OLM_SERVER_NAME_LENGTH));
				int maxcode = maxWFInstanceID2 + 1;
				newWFInstanceID = OLM_SERVER_NAME + String.format(initLen, maxcode);

				if(wfInstanceID != null && !"".equals(wfInstanceID))
					newWFInstanceID = wfInstanceID;		
				
				setData.put("wfID",wfID);
				setData.put("wfDocType",wfDocType);
				setData.put("docSubClass",docSubClass);
				
				String wfAllocID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFAllocID", setData));

				commandMap.put("wfID",wfID);
				commandMap.put("newWFInstanceID",newWFInstanceID);
				commandMap.put("wfAllocID",wfAllocID);
				
				insertWFInstData = insertWFStepInst(request,commandMap,model);
				
				setMap.put("s_itemID", projectID);
				
				commandMap.put("insertWFInstData",insertWFInstData);

				commandMap.put("lastSeq",insertWFInstData.get("lastSeq"));
				commandMap = updateWFDocType(request,commandMap,model);
				
				
				// DocumentType에 따라 분기 처리 끝나는 지점 
				// 결재 상신 Email 전송
				sendWfMail(request,commandMap,model);

			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00150")); // 상신 완료
			target.put(AJAX_SCRIPT,"parent.fnCallBackSubmit();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	public HashMap insertWFStepInst(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		HashMap setData = new HashMap();
		HashMap inserWFInstTxtData = new HashMap();
		HashMap insertWFStepData = new HashMap();
		HashMap insertWFStepRefData = new HashMap();
		HashMap insertWFStepRecData = new HashMap();
		HashMap insertWFInstData = new HashMap();
		try {
				
				String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
				String projectID = StringUtil.checkNull(commandMap.get("projectID"));
				String documentID = StringUtil.checkNull(commandMap.get("documentID"));
				String documentNo = StringUtil.checkNull(commandMap.get("documentNo"));
				String wfID = StringUtil.checkNull(commandMap.get("wfID"));
				String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String creatorTeamID = StringUtil.checkNull(commandMap.get("sessionTeamId"));
				String aprvOption = StringUtil.checkNull(commandMap.get("aprvOption"));
				String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType"),"CSR");
				String description = StringUtil.checkNull(commandMap.get("description"));
				String wfAllocID = StringUtil.checkNull(commandMap.get("wfAllocID"));
				String subject = StringUtil.checkNull(commandMap.get("subject"));
				String newWFInstanceID = StringUtil.checkNull(commandMap.get("newWFInstanceID"));
				
				String getWfStepMemberIDs = StringUtil.checkNull(commandMap.get("wfStepMemberIDs"));
				String getWfStepRoleTypes = StringUtil.checkNull(commandMap.get("wfStepRoleTypes"));
				String getWfStepRefMemberIDs = StringUtil.checkNull(commandMap.get("wfStepRefMemberIDs"));
				String getWfStepRecMemberIDs = StringUtil.checkNull(commandMap.get("wfStepRecMemberIDs"));
				String getWfStepRecTeamIDs = StringUtil.checkNull(commandMap.get("wfStepRecTeamIDs"));
								
				String wfStepMemberIDs[] = null;
				String wfStepRoleTypes[] = null;
				String wfStepRefMemberIDs[] = null;
				String wfStepRecMemberIDs[] = null;
				String wfStepRecTeamIDs[] = null;
				String wfStepSeq[] = null;
				
				if(!getWfStepMemberIDs.isEmpty()){ wfStepMemberIDs = getWfStepMemberIDs.split(","); }
				if(!getWfStepRoleTypes.isEmpty()){ wfStepRoleTypes = getWfStepRoleTypes.split(","); wfStepSeq = getWfStepRoleTypes.split(",");}
				if(!getWfStepRefMemberIDs.isEmpty()){ wfStepRefMemberIDs = getWfStepRefMemberIDs.split(","); }
				if(!getWfStepRecMemberIDs.isEmpty()){ wfStepRecMemberIDs = getWfStepRecMemberIDs.split(","); }
				if(!getWfStepRecTeamIDs.isEmpty()){ wfStepRecTeamIDs = getWfStepRecTeamIDs.split(","); }
				
				// SET APRV PATH	
				int agrCnt  = -1;
				int idx = 0;
									
				for(int j=0; j< wfStepRoleTypes.length; j++){	
					
					if("PAGR".equals(wfStepRoleTypes[j]) && agrCnt > 0){
						wfStepSeq[j] = StringUtil.checkNull(idx);
					
						if(j+1 <= wfStepRoleTypes.length && (j+1) < wfStepRoleTypes.length && !"PAGR".equals(wfStepRoleTypes[j+1]))
							idx++;
						
					} else if("PAGR".equals(wfStepRoleTypes[j]) && agrCnt == -1){
						wfStepSeq[j] = StringUtil.checkNull(idx);
						agrCnt = 1;
						
						if(j+1 <= wfStepRoleTypes.length && (j+1) < wfStepRoleTypes.length && !"PAGR".equals(wfStepRoleTypes[j+1]))
							idx++;
						
					} else if("REW".equals(wfStepRoleTypes[j])){
						wfStepSeq[j] = StringUtil.checkNull(idx);
						
						if(j+1 <= wfStepRoleTypes.length && (j+1) < wfStepRoleTypes.length && !"REW".equals(wfStepRoleTypes[j+1]))
							idx++;
						
					} else if("MGT".equals(wfStepRoleTypes[j])){ 
						wfStepSeq[j] = "1";						
					} else if(j == 0){						
						wfStepSeq[j] = "0";
						idx++;
					} else {						
						wfStepSeq[j] = StringUtil.checkNull(idx);
						idx++;
					}
					
				}

				int lastSeq = idx-1;		
								
				//Delete WF Instance Text 
				setData.put("wfInstanceID", wfInstanceID);
				commonService.delete("wf_SQL.deleteWFInstTxt", setData);

				//INSERT NEW WF Instance
				insertWFInstData.put("WFInstanceID", newWFInstanceID);
				insertWFInstData.put("ProjectID", projectID);
				insertWFInstData.put("DocumentID", documentID);
				insertWFInstData.put("DocumentNo", documentNo);
				insertWFInstData.put("DocCategory", wfDocType);
				insertWFInstData.put("WFID", wfID);
				insertWFInstData.put("Creator", loginUser);
				insertWFInstData.put("LastUser", loginUser);
				insertWFInstData.put("Status", "1"); // 상신
				insertWFInstData.put("aprvOption", aprvOption);
				insertWFInstData.put("curSeq", "1");
				insertWFInstData.put("LastSigner", loginUser);
				insertWFInstData.put("lastSeq", lastSeq);
				insertWFInstData.put("creatorTeamID", creatorTeamID);
				insertWFInstData.put("wfAllocID", wfAllocID);
				
				commonService.insert("wf_SQL.insertToWfInst", insertWFInstData);
				
				//INSERT WF STEP INST
				String maxId = "";
				if(!getWfStepMemberIDs.isEmpty()){
					for(int i=0; i< wfStepMemberIDs.length; i++){	
											
						String status = null ;
						
						insertWFStepData.put("Seq", wfStepSeq[i]);
						maxId = commonService.selectString("wf_SQL.getMaxStepInstID", setData);	
						
						insertWFStepData.put("StepInstID", Integer.parseInt(maxId) + 1); 						
						insertWFStepData.put("ProjectID", projectID);
						
						if( i == 0){ status = "1"; }		
						else if( wfStepSeq[i].equals("1") ){ status = "0"; }
						insertWFStepData.put("Status", status);
						insertWFStepData.put("ActorID", wfStepMemberIDs[i]);
						insertWFStepData.put("WFID", wfID);
						insertWFStepData.put("WFStepID", wfStepRoleTypes[i]);
						if(wfInstanceID.isEmpty()){ insertWFStepData.put("WFInstanceID", newWFInstanceID); }
						commonService.insert("wf_SQL.insertWfStepInst", insertWFStepData);
									
					}
				}
				
				//Insert WF_STEP_INST REF 
				if(getWfStepRefMemberIDs != null && !getWfStepRefMemberIDs.isEmpty()){
					for(int j=0; j<wfStepRefMemberIDs.length; j++){
						maxId = commonService.selectString("wf_SQL.getMaxStepInstID", setData);	
						insertWFStepRefData.put("StepInstID", Integer.parseInt(maxId) + 1);
						insertWFStepRefData.put("ProjectID", projectID);
						insertWFStepRefData.put("Seq", "0");
						insertWFStepRefData.put("ActorID", wfStepRefMemberIDs[j]);
						insertWFStepRefData.put("WFID", wfID);
						insertWFStepRefData.put("WFStepID", "REF");
						if(wfInstanceID.isEmpty()){ insertWFStepRefData.put("WFInstanceID", newWFInstanceID); }
						commonService.insert("wf_SQL.insertWfStepInst", insertWFStepRefData);
					}
				}
				
				//Insert WF_STEP_INST REC (개별)
				if(getWfStepRecMemberIDs != null && !getWfStepRecMemberIDs.isEmpty()){
					for(int j=0; j<wfStepRecMemberIDs.length; j++){
						maxId = commonService.selectString("wf_SQL.getMaxStepInstID", setData);	
						insertWFStepRecData.put("StepInstID", Integer.parseInt(maxId) + 1);
						insertWFStepRecData.put("ProjectID", projectID);
						insertWFStepRecData.put("Seq", "0");
						insertWFStepRecData.put("ActorID", wfStepRecMemberIDs[j]);
						insertWFStepRecData.put("WFID", wfID);
						insertWFStepRecData.put("WFStepID", "REC");
						if(wfInstanceID.isEmpty()){ insertWFStepRecData.put("WFInstanceID", newWFInstanceID); }
						commonService.insert("wf_SQL.insertWfStepInst", insertWFStepRecData);
					}
				}

				//Insert WF_STEP_INST REC (팀별)
				if(getWfStepRecTeamIDs != null && !getWfStepRecTeamIDs.isEmpty()){
					insertWFStepRecData.remove("ActorID");
					for(int j=0; j<wfStepRecTeamIDs.length; j++){
						maxId = commonService.selectString("wf_SQL.getMaxStepInstID", setData);	
						insertWFStepRecData.put("StepInstID", Integer.parseInt(maxId) + 1);
						insertWFStepRecData.put("ProjectID", projectID);
						insertWFStepRecData.put("Seq", "0");
						insertWFStepRecData.put("ActorTeamID", wfStepRecTeamIDs[j]);
						insertWFStepRecData.put("WFID", wfID);
						insertWFStepRecData.put("WFStepID", "REC");
						if(wfInstanceID.isEmpty()){ insertWFStepRecData.put("WFInstanceID", newWFInstanceID); }
						commonService.insert("wf_SQL.insertWfStepInst", insertWFStepRecData);
					}
				}
				
				//INSERT WF INST TEXT(SUBJECT, DECSRIPTION)
				inserWFInstTxtData.put("WFInstanceID",newWFInstanceID);
				inserWFInstTxtData.put("subject",subject);
				inserWFInstTxtData.put("subjectEN",subject);
				inserWFInstTxtData.put("description",description);
				inserWFInstTxtData.put("descriptionEN",description);
				inserWFInstTxtData.put("comment","");
				inserWFInstTxtData.put("actorID",loginUser);
				commonService.insert("wf_SQL.insertWfInstTxt", inserWFInstTxtData);	

		} catch (Exception e) {
			
			System.out.println(e.toString());
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return insertWFInstData;
	}

	public HashMap updateWFDocType(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap setMap = new HashMap();
		HashMap updateData = new HashMap();
		HashMap updateCRData = new HashMap();
		try {
			String documentID = StringUtil.checkNull(commandMap.get("documentID"));
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String esType = StringUtil.checkNull(commandMap.get("esType"));
			String speCode = StringUtil.checkNull(commandMap.get("speCode"));
			String projectID = StringUtil.checkNull(commandMap.get("projectID"));
			String blockSR = StringUtil.checkNull(commandMap.get("blockSR"));
			String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String aprvOption = StringUtil.checkNull(commandMap.get("aprvOption"));
			String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType"),"CSR");
			String Status = StringUtil.checkNull(commandMap.get("Status"));
			String isMulti = StringUtil.checkNull(commandMap.get("isMulti"));
			String wfDocumentIDs = StringUtil.checkNull(commandMap.get("wfDocumentIDs"));
			String newWFInstanceID = StringUtil.checkNull(commandMap.get("newWFInstanceID"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String ValidFrom = StringUtil.checkNull(commandMap.get("ValidFrom"),"");
			String Description = StringUtil.checkNull(commandMap.get("Description"),"");
			String changeType = StringUtil.checkNull(commandMap.get("changeType"));
			HashMap insertWFInstData = (HashMap) commandMap.get("insertWFInstData");
			

			updateData = new HashMap();
			setMap.put("srID", srID);
			setMap.put("aprvOption", aprvOption);
			setMap.put("projectID", projectID);
			if(Status.equals("CNG")){
				updateData.put("Status", "APRV2"); // 결재 중
										
				//Save PROC_LOG
				Map setProcMapRst = (Map)setProcLog(request, commonService, setMap);
				if(setProcMapRst.get("type").equals("FAILE")){
					String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
					System.out.println("Msg : "+Msg);
				}
			}else {
				updateData.put("Status", "APRV"); // 결재 중
			}
			updateData.put("ProjectID", projectID);
			
		    updateCRData = new HashMap();	
			HashMap updateSR = new HashMap(); 

			if(Status.equals("CNG")) { // 후결재 
				updateCRData.put("status", "RFC");		
				updateCRData.put("ITSMIF", "0");												    
			}else  { // 선결재 
				updateCRData.put("status", "APRV");
			}
			updateCRData.put("lastUser", loginUser);

			// DocumentType에 따라 분기 처리 시작
			if(wfDocType.equals("CSR") || wfDocType.equals("PJT") ) {
				commandMap.put("emailType", "CSRCLS");
				updateData.put("CurWFInstanceID", newWFInstanceID);
				
				commonService.update("project_SQL.updateProject", updateData);	
				updateCRData.put("CSRID", projectID);

				if(!srID.equals("")){
					Map esmProcInfo = (Map)decideSRProcPath(request, commonService, insertWFInstData);
					if(esmProcInfo != null && !esmProcInfo.isEmpty()){
						updateSR.put("srID", srID);
						updateSR.put("status", esmProcInfo.get("SpeCode"));
						updateSR.put("lastUser", loginUser);
						updateSR.put("curWFInstanceID", newWFInstanceID);
						commonService.update("esm_SQL.updateESMSR", updateSR);	
					}
			    }	
				commonService.update("cr_SQL.updateCR", updateCRData);		
				
			}
			else if(wfDocType.equals("SR") || wfDocType.equals("SCR")) {
				
				updateSR.put("lastUser", loginUser);
				
				if(wfDocType.equals("SCR")){
					// SCR Status Update
					updateSR.put("srID", srID);
					updateSR.put("scrID", documentID);			
					updateSR.put("aprvStatus", "1");
					updateSR.put("status", "APREQ");		
					commonService.insert("scr_SQL.updateSCR", updateSR);
				} else {
					updateSR.put("srID", documentID);
					// SR일 경우에만 curWFInstanceID 업데이트
					updateSR.put("curWFInstanceID", newWFInstanceID);
				}
				
				commandMap.put("emailType", "SRAPREQ");
				updateSR.put("status", speCode);
				String blocked = "";
				if(blockSR.equals("Y")) blocked="1";
				updateSR.put("blocked", blocked);
				
				if("ITSP".equals(esType)){
					// esp 결재 상신 처리
					updateSR.put("languageID",languageID);
					updateSR.put("wfInstanceID", newWFInstanceID);
					ESPUtil.srAprvProcessingMaster(request, commonService, updateSR);
					
				} else {
					commonService.update("esm_SQL.updateESMSR", updateSR);	
					
					//Save PROC_LOG
					updateSR.put("SRStatus", speCode);
					Map setProcMapRst = (Map)setProcLog(request, commonService, updateSR);
					if(setProcMapRst.get("type").equals("FAILE")){
						String Msg = StringUtil.checkNull(setProcMapRst.get("msg"));
						System.out.println("Msg : "+Msg);
					}		
				}
			}
			else if(wfDocType.equals("CS")) {
				commandMap.put("emailType", "APREQ_CS");
				
				updateCRData.put("Status", "APRV");
				
				if(isMulti.equals("Y")) {
					String ids[] = wfDocumentIDs.split(",");
					for(int i=0; i<ids.length; i++) {
						updateCRData.put("s_itemID", ids[i]);
						updateCRData.put("wfInstanceID",newWFInstanceID);
						updateCRData.put("ValidFrom", ValidFrom);
						updateCRData.put("Description", Description);
						updateCRData.put("ChangeType", changeType);
						commonService.update("cs_SQL.updateChangeSetForWf", updateCRData);
						commonService.insert("cs_SQL.updateChangeSetDescriptionWF", updateCRData);	//CS table Description Update
					}
				}
				else {
					updateCRData.put("s_itemID", documentID);
					updateCRData.put("wfInstanceID",newWFInstanceID);
					updateCRData.put("ValidFrom", ValidFrom);
					updateCRData.put("Description", Description);
					updateCRData.put("ChangeType", changeType);
					commonService.update("cs_SQL.updateChangeSetForWf", updateCRData);
				}		
				
				
				String itemStatus ="";
				if(!"".equals(changeType)) {
					
					if ("NEW".equals(changeType)) {
						itemStatus  = "NEW2";
					} else if ("DEL".equals(changeType)) {
						itemStatus = "DEL2";
					} else if ("MOD".equals(changeType)){
						itemStatus = "MOD2";
					}	
					updateData.put("Status", itemStatus);
					updateData.put("LastUser", commandMap.get("sessionUserId"));
					updateData.put("Blocked", "2");
		
					updateData.put("curChangeSet",documentID );
					updateData.put("checkin", "Y");
					//item status 				
					commonService.update("project_SQL.updateItemStatus", updateData);
				} 

			
			}
			else {
				commandMap.put("emailType", "ITMREW");
			}
		} catch (Exception e) {
			
			System.out.println(e.toString());
		}

		return commandMap;
	}
	

	public String sendWfMail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {

			Map setMailData = new HashMap();
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String newWFInstanceID = StringUtil.checkNull(commandMap.get("newWFInstanceID"));

			String description = StringUtil.checkNull(commandMap.get("description"));
			String subject = StringUtil.checkNull(commandMap.get("subject"));
			String emailType = StringUtil.checkNull(commandMap.get("emailType"));
			String lastSeq = StringUtil.checkNull(commandMap.get("lastSeq"));
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String projectID = StringUtil.checkNull(commandMap.get("projectID"));
			
			setMap.put("languageID", languageID);	
			setMap.put("wfInstanceID", newWFInstanceID);
			setMap.put("projectID", projectID);
			setMap.put("nextSeq", "1");			
			
			List receiverList = new ArrayList();
			List refList = new ArrayList();
			
			List temp1 = commonService.selectList("wf_SQL.getWFStepMailList",setMap);
			int j = 0;
			
			String emailStepInstID = "";
			String emailStepSeq = "";
			String emailActorID = "";
			for(int i=0; i<temp1.size(); i++) {
				Map tempMap = (Map)temp1.get(i);
				Map tempMap2 = new HashMap();	
				
				tempMap2.put("receiptUserID", tempMap.get("ActorID"));
				receiverList.add(j++,tempMap2);
				emailStepInstID = StringUtil.checkNull(tempMap.get("StepInstID"));	
				emailStepSeq = StringUtil.checkNull(tempMap.get("Seq"));
				emailActorID = StringUtil.checkNull(tempMap.get("ActorID"));
			}	
			

			String mailSubject = subject;
			setMailData.put("receiverList",receiverList);
			setMailData.put("LanguageID",languageID);
			setMailData.put("subject", mailSubject);
			commandMap.put("wfInstanceID", newWFInstanceID);
			commandMap.put("emailCode", emailType);
			
			Map setMailMap = (Map)setEmailLog(request, commonService, setMailData, emailType); //결제 상신 메일 전송
			if(StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")){
				HashMap mailMap = (HashMap)setMailMap.get("mailLog");
				
				ModelMap mailModel = getApprovalMailForm(request, commandMap, model);
				mailModel.put("LanguageID",languageID); 
				mailMap.put("refList",refList);
				
				mailModel.put("stepInstID", emailStepInstID); 
				mailModel.put("stepSeq", emailStepSeq); 
				mailModel.put("lastSeq", lastSeq); 
				mailModel.put("actorID", emailActorID); 
				
				if(!srID.equals("")){
					setMap.put("srID",srID);
					HashMap esmMap = (HashMap)commonService.select("esm_SQL.getESMSRInfo", setMap);
					mailModel.put("SubCategoryNM",esmMap.get("SubCategoryName"));
					mailModel.put("SRArea1Name",esmMap.get("SRArea1Name"));
					mailModel.put("SRArea2Name",esmMap.get("SRArea2Name"));
					mailModel.put("ReqUserNM",esmMap.get("ReqUserNM"));
					mailModel.put("ReqTeamNM",esmMap.get("ReqTeamNM"));
					mailModel.put("ReqDueDate",esmMap.get("ReqDueDate"));
					mailModel.put("SRDescription",esmMap.get("Description"));
					mailModel.put("SRID",esmMap.get("SRID"));
					mailModel.put("wfInstanceID",esmMap.get("WFInstanceID"));

					setMap.put("s_itemID",projectID);
					HashMap pjtMap = (HashMap)commonService.select("project_SQL.getProjectInfoView", setMap);
					mailModel.put("ProjectID",pjtMap.get("ProjectID"));
					mailModel.put("ProjectName",pjtMap.get("ProjectName"));
					mailModel.put("ProjectCode",pjtMap.get("ProjectCode"));
					mailModel.put("Path",pjtMap.get("Path"));
					mailModel.put("AuthorName",pjtMap.get("AuthorName"));
					mailModel.put("TeamName",pjtMap.get("TeamName"));
					mailModel.put("StartDate",pjtMap.get("StartDate"));
					mailModel.put("DueDate",pjtMap.get("DueDate"));
					mailModel.put("Description",pjtMap.get("Description"));
				}
				
				Map resultMailMap = EmailUtil.sendMail(mailMap,mailModel,getLabel(request, commonService));
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMap.get("type")));
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMap.get("msg")));
			}

			setMap.remove("nextSeq");	
			receiverList.clear();
			j = 0;
			setMap.remove("wfStepIDs");
			setMap.put("wfStepID", "REF");			
			temp1 = commonService.selectList("wf_SQL.getWFStepMailList",setMap);
			for(int i=0; i<temp1.size(); i++) {
				Map tempMap = (Map)temp1.get(i);
				Map tempMap2 = new HashMap();	
				String WFStepID = (String) tempMap.get("WFStepID");
				if("REF".equals(WFStepID)) {
					tempMap2.put("receiptUserID", tempMap.get("ActorID"));
					receiverList.add(j++,tempMap2);
				}					
			}		
			/*
			setMap.put("wfStepID", "REC");			
			temp1 = commonService.selectList("wf_SQL.getWFStepMailList",setMap);
			for(int i=0; i<temp1.size(); i++) {
				Map tempMap = (Map)temp1.get(i);
				Map tempMap2 = new HashMap();	
				String WFStepID = (String) tempMap.get("WFStepID");
				if("REC".equals(WFStepID)) {
					tempMap2.put("receiptUserID", tempMap.get("ActorID"));
					receiverList.add(j++,tempMap2);
				}					
			}		
			
			*/
			
			setMailData.put("receiverList",receiverList);
			setMailMap = (Map)setEmailLog(request, commonService, setMailData, "APRVREF"); //결제 상신시 참조자에게 메일 전송
			if(StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")){
				HashMap mailMap = (HashMap)setMailMap.get("mailLog");
				
				ModelMap mailModel = getApprovalMailForm(request, commandMap, model);
				mailModel.put("LanguageID",languageID); 
				mailMap.put("refList",refList);
				
				Map resultMailMap = EmailUtil.sendMail(mailMap,mailModel,getLabel(request, commonService));
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMap.get("type")));
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMap.get("msg")));
			}
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/wf/approvalTransfer");
	}
	
	
	@RequestMapping(value = "/openApprTransferPop.do")
	public String openApprTransferPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
				String projectID = StringUtil.checkNull(commandMap.get("projectID"));
				String wfID = StringUtil.checkNull(commandMap.get("wfID"));
				String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
				String stepInstID = StringUtil.checkNull(commandMap.get("stepInstID"));
				String actorID = StringUtil.checkNull(commandMap.get("actorID"));
				String stepSeq = StringUtil.checkNull(commandMap.get("stepSeq"));
				String wfStepInstStatus = StringUtil.checkNull(commandMap.get("wfStepInstStatus"));
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("WFID", wfID);
				String MandatoryGRID = commonService.selectString("wf_SQL.getMandatoryGRID", setMap);
				model.put("MandatoryGRID", MandatoryGRID);
				
				model.put("menu", getLabel(request, commonService)); /*Label Setting*/	
				model.put("projectID", projectID);
				model.put("wfID", wfID);
				model.put("stepInstID", stepInstID);
				model.put("actorID", actorID);
				model.put("stepSeq", stepSeq);
				model.put("wfInstanceID", wfInstanceID);
				model.put("wfStepInstStatus", wfStepInstStatus);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/wf/approvalTransfer");
	}
	
	@RequestMapping(value = "/changeApprActor.do")
	public String changeApprActor(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		Map target = new HashMap();
		try {
				String stepInstID = StringUtil.checkNull(commandMap.get("stepInstID"));
				String wfREL = StringUtil.checkNull(commandMap.get("wfREL"));
				String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
				String actorTeamID = commonService.selectString("user_SQL.userTeamID", commandMap); 
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				
				setMap.put("stepInstID", stepInstID);
				setMap.put("actorID", wfREL);
				setMap.put("actorTeamID", actorTeamID);
				
				commonService.update("wf_SQL.changeActor", setMap);	
				
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00067")); // 저장 하였습니다.	
				target.put(AJAX_SCRIPT, "parent.fnCallBackSubmit();this.$('#isSubmit').remove();parent.$('#isSubmit').remove();");
				
				HashMap setMailData = new HashMap();
				setMap.put("wfInstanceID", wfInstanceID);
				String projectID = commonService.selectString("wf_SQL.getProjectID", setMap); 
				setMap.put("s_itemID", projectID);
				setMap.put("languageID",languageID);
				
				setMailData = (HashMap) commonService.select("project_SQL.getProjectInfo",setMap);						
				setMailData.put("subject", setMailData.get("ProjectName"));
				
				List receiverList = new ArrayList();
				
				//다음 단계 합의/승인자 리스트로 메일 전송
				Map tempMap = new HashMap();
				tempMap.put("receiptUserID", wfREL);
				receiverList.add(tempMap);
							
				setMailData.put("receiverList",receiverList);	
				setMailData.put("LanguageID",languageID);	

				Map setMailMap = (Map)setEmailLog(request, commonService, setMailData, "CSRAPREQ"); //CSR  승인 다음 단계 처리자에게 이메일 발송

				if(StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")){
					HashMap mailMap = (HashMap)setMailMap.get("mailLog");
					
					ModelMap MailModel = getApprovalMailForm(request, commandMap, model);
					MailModel.put("receiverList",receiverList);	
					MailModel.put("LanguageID",languageID);	
										
					Map resultMailMap = EmailUtil.sendMail(mailMap,MailModel,getLabel(request, commonService));
					System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMap.get("type")));
				}else{
					System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMap.get("msg")));
				}			
			
		} catch (Exception e) {
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 합의/승인 중 오류가 발생하였습니다.						
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value = "/wfInstanceList.do")
	public String wfInstanceList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
				String wfMode = StringUtil.checkNull(commandMap.get("wfMode"));
				String wfStepID = StringUtil.checkNull(commandMap.get("wfStepID"));
				String projectID = StringUtil.checkNull(commandMap.get("projectID"));
				String screenType = StringUtil.checkNull(commandMap.get("screenType"));
				String filter = StringUtil.checkNull(commandMap.get("filter"),"myWF");
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				String period = StringUtil.checkNull(commandMap.get("period"));
				String actorID = StringUtil.checkNull(commandMap.get("actorID"));
				String docCatetory = StringUtil.checkNull(commandMap.get("docCategory"));
				
				model.put("menu", getLabel(request, commonService)); /*Label Setting*/	
				String menuNum = "";
				String title ="";
				if(wfMode.equals("AREQ")){
					title = StringUtil.checkNull(getLabel(request, commonService).get("LN00211"));
				}else if(wfMode.equals("CurAprv")){
					title = StringUtil.checkNull(getLabel(request, commonService).get("LN00243"));
				}else if(wfMode.equals("ToDoAprv")){
					title = StringUtil.checkNull(getLabel(request, commonService).get("LN00244"));
				}else if(wfMode.equals("RefMgt")){
					title = StringUtil.checkNull(getLabel(request, commonService).get("LN00245"));
				}else if(wfMode.equals("Cls")){
					title = StringUtil.checkNull(getLabel(request, commonService).get("LN00118"));
				}
				
				Calendar cal = Calendar.getInstance();
				cal.setTime(new Date(System.currentTimeMillis()));
				String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
				//cal.add(Calendar.MONTH, -3);
				cal.add(Calendar.DATE, -7);
				String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
				if(docCatetory.equals("")) docCatetory = "CS";
				setMap.put("DocCategory", docCatetory);
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				String wfURL = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", setMap));
				
				setMap.put("wfStepID", wfStepID);
				setMap.put("period", period);
				setMap.put("beforeYmd", beforeYmd);
				setMap.put("thisYmd", thisYmd);
				setMap.put("wfMode", wfMode);
				setMap.put("filter", filter);
				setMap.put("projectID", projectID);
				
				if(screenType != "csrDtl"){
					actorID =  StringUtil.checkNull(commandMap.get("sessionUserId"));
					setMap.put("actorID", actorID);
				}
				
				setMap.put("languageID", languageID);
		        List wfInsList = commonService.selectList("wf_SQL.getWFInstList_gridList", setMap);
		        JSONArray gridData = new JSONArray(wfInsList);
		        model.put("gridData",gridData);	
				
				model.put("wfURL", wfURL);
				model.put("beforeYmd", beforeYmd);
				model.put("thisYmd", thisYmd);
				model.put("wfStepID", wfStepID);
				model.put("title", title);
				model.put("wfMode", wfMode);
				model.put("projectID", projectID);
				model.put("screenType", screenType);
				model.put("filter", filter);
				model.put("wfInstanceID", StringUtil.checkNull(request.getParameter("wfInstanceID"),""));
				
				String wfInstanceID = StringUtil.checkNull(request.getParameter("wfInstanceID"),"");
				Map wfInfoMap = new HashMap();
				if(!wfInstanceID.equals("")){
					setMap.put("wfInstanceID", wfInstanceID);
					setMap.put("filter", filter);
					setMap.put("actorID", StringUtil.checkNull(commandMap.get("sessionUserId")));
					wfInfoMap = (Map)commonService.select("wf_SQL.getWFInstList_gridList", setMap);
					model.put("wfInfoMap", wfInfoMap);
				}
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/wf/wfInstanceList");
	}
	
	public ModelMap getApprovalMailForm(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		List attachFileList = new ArrayList();
		List wfInstList = new ArrayList();
		List wfRefInstList = new ArrayList();
		try {
				String projectID = StringUtil.checkNull(commandMap.get("projectID"));
				String wfID = StringUtil.checkNull(commandMap.get("wfID"));
				String stepInstID = StringUtil.checkNull(commandMap.get("stepInstID"));
				String documentID = StringUtil.checkNull(commandMap.get("documentID"));
				String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
				String lastSeq = StringUtil.checkNull(commandMap.get("lastSeq"));
				String actorID = StringUtil.checkNull(commandMap.get("actorID"));
				String stepSeq = StringUtil.checkNull(commandMap.get("stepSeq"));
				String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String srID = StringUtil.checkNull(commandMap.get("srID"));
				String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType"));
				
				model.put("wfDocType",wfDocType);		
				
				setMap.put("WFStepIDs", "'AREQ','APRV','AGR','PAGR','REW'");
				setMap.put("wfInstanceID", wfInstanceID);
				setMap.put("LanguageID", commandMap.get("sessionCurrLangType"));
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				
				List wfStepInstList = commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);	
				Map wfInstInfo = commonService.select("wf_SQL.getWFInstanceDetail_gridList", setMap);
			
				String Description = StringUtil.checkNull(wfInstInfo.get("Description"),"");
				Description = StringUtil.replaceFilterString(Description);
				wfInstInfo.put("Description", Description);	

				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				
				model.put("wfInstInfo",wfInstInfo);			
				
				String wfStepInstInfo = "";
				String wfStepInstREFInfo = "";
				String wfStepInstRECInfo = "";
				String wfStepInstRELInfo = "";
				String wfStepInstAGRInfo = "";
				String afterSeq = "";
				Map wfStepInstInfoMap = new HashMap();
				if(wfStepInstList.size() > 0 ){
					for(int i=0; i<wfStepInstList.size(); i++){
						wfStepInstInfoMap = (Map) wfStepInstList.get(i);
						if(i==0){
							wfStepInstInfo = wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+")";
							afterSeq =  wfStepInstInfoMap.get("Seq").toString();
						}else{						
							if(wfStepInstInfoMap.get("Seq").equals(wfInstInfo.get("CurSeq"))){
								if(afterSeq.equals(wfStepInstInfoMap.get("Seq").toString()))
									wfStepInstInfo = wfStepInstInfo + ", "+ "<span style='color:blue;font-weight:bold'>"+wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+") </span>";
								else
									wfStepInstInfo = wfStepInstInfo + " >> "+ "<span style='color:blue;font-weight:bold'>"+wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+") </span>";
								
							}else{
								if(afterSeq.equals(wfStepInstInfoMap.get("Seq").toString()))
									wfStepInstInfo = wfStepInstInfo + ", "+ wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+")";
								else
									wfStepInstInfo = wfStepInstInfo + " >> "+ wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+")";
							}
							afterSeq = wfStepInstInfoMap.get("Seq").toString();
						}
						if(actorID.equals(wfStepInstInfoMap.get("ActorID").toString())) {
							model.put("actorWFStepName",wfStepInstInfoMap.get("WFStepName"));
							String transYN = commonService.selectString("wf_SQL.getApprTransYN", wfStepInstInfoMap);
							model.put("transYN",transYN);
						}
					}
					model.put("wfStepInstInfo", wfStepInstInfo); // 결재선
				}
				
				// 참조
				setMap.put("WFStepIDs", "'REF'");
				List wfStepInstREFList = commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
				Map wfStepInstREFInfoMap = new HashMap();
				
				if(wfStepInstREFList.size() > 0 ){
					for(int i=0; i<wfStepInstREFList.size(); i++){
						wfStepInstREFInfoMap = (Map) wfStepInstREFList.get(i);
						if(i==0){
							wfStepInstREFInfo = StringUtil.checkNull(wfStepInstREFInfoMap.get("ActorName"));
						}else{						
							wfStepInstREFInfo = wfStepInstREFInfo + ","+ wfStepInstREFInfoMap.get("ActorName");
						}
					}
					model.put("wfStepInstREFInfo", wfStepInstREFInfo); // 참조
				}
				
				// 주관부서 담당자
				setMap.put("WFStepIDs", "'MGT'");
				List wfStepInstRELList = commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
				Map wfStepInstRELInfoMap = new HashMap();
				if(wfStepInstRELList.size() > 0 ){
					for(int i=0; i<wfStepInstRELList.size(); i++){
						wfStepInstRELInfoMap = (Map) wfStepInstRELList.get(i);
						if(i==0){
							wfStepInstRELInfo = StringUtil.checkNull(wfStepInstRELInfoMap.get("ActorName"));
						}else{						
							if(loginUser.equals(wfStepInstRELInfoMap.get("ActorID"))){
								wfStepInstRELInfo = wfStepInstRELInfo + ","+ wfStepInstRELInfoMap.get("ActorName");
							}
						}
						if(actorID.equals(wfStepInstRELInfoMap.get("ActorID").toString())) {
						//	model.put("actorWFStepName",wfStepInstRELInfoMap.get("WFStepName"));
							String transYN = commonService.selectString("wf_SQL.getApprTransYN", wfStepInstRELInfoMap);
							model.put("transYN",transYN);
						}
					}
					model.put("wfStepInstRELInfo", wfStepInstRELInfo); // 참조
				}								

				// 수신
				setMap.put("WFStepIDs", "'REC'");
				setMap.put("WFStepID", "REC");
				List wfStepInstRECList = commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
				Map wfStepInstRECInfoMap = new HashMap();
				
				if(wfStepInstRECList.size() > 0 ){
					for(int i=0; i<wfStepInstRECList.size(); i++){
						wfStepInstRECInfoMap = (Map) wfStepInstRECList.get(i);
						if(i==0){
							wfStepInstRECInfo = StringUtil.checkNull(wfStepInstRECInfoMap.get("ActorName"));
						}else{						
							wfStepInstRECInfo = wfStepInstRECInfo + ","+ wfStepInstRECInfoMap.get("ActorName");
						}
					}
					model.put("wfStepInstRECInfo", wfStepInstRECInfo); // 참조
				}
				
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("s_itemID", projectID);
				Map getPJTMap = new HashMap();

				setMap.put("itemID", projectID);
				setMap.put("DocCategory", wfInstInfo.get("DocCategory"));
				setMap.put("DocumentID", commandMap.get("DocumentID"));
				
				
				
				if(wfInstInfo.get("DocCategory").equals("CSR")) {
					getPJTMap = commonService.select("project_SQL.getProjectInfo", setMap);
					setMap.put("ProjectID", projectID);
					setMap.put("projectID", projectID);
					
					attachFileList = commonService.selectList("fileMgt_SQL.getWfFileList", setMap);
				}
				else if(wfInstInfo.get("DocCategory").equals("PJT")) {
					getPJTMap = commonService.select("project_SQL.getProjectInfo", setMap);
					
					attachFileList = commonService.selectList("fileMgt_SQL.getWfFileList", setMap);
				}
				else if(wfInstInfo.get("DocCategory").equals("SR")) {
					
					Map getSRInfoMap = new HashMap();
					setMap.put("srID", documentID);
					if(documentID.equals("")) setMap.put("srID", srID); 
						
					getSRInfoMap = commonService.select("esm_SQL.getESMSRInfo", setMap);						
					attachFileList = commonService.selectList("fileMgt_SQL.getWfFileList", setMap);
					model.put("getSRInfoMap", getSRInfoMap);
				}
				else if(wfInstInfo.get("DocCategory").equals("SCR")) {
					
					setMap.put("scrID", documentID);
					Map scrInfo = commonService.select("scr_SQL.getSCR_gridList", setMap);
					model.put("scrInfo", scrInfo);
					
					srID = StringUtil.checkNull(scrInfo.get("SRID"));
					setMap.put("srID",srID);
					Map getSRInfoMap = new HashMap();
					getSRInfoMap = commonService.select("esm_SQL.getESMSRInfo", setMap);						
					attachFileList = commonService.selectList("fileMgt_SQL.getWfFileList", setMap);
					model.put("getSRInfoMap", getSRInfoMap);
					
				}
				else if(wfInstInfo.get("DocCategory").equals("CS")) {
					setMap.put("s_itemID", null);
					
					getPJTMap = commonService.select("wf_SQL.getWFInstDetail", setMap);
					
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));
					List csInstList = commonService.selectList("cs_SQL.getChangeSetList_gridList", setMap);
					model.put("csInstList", csInstList);
					
					attachFileList = commonService.selectList("fileMgt_SQL.getWfFileList", setMap);
				}
				else if(wfInstInfo.get("DocCategory").equals("ITMREW")) {
					
					getPJTMap = commonService.select("wf_SQL.getWFInstDetail", setMap);					
					setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				}
				
				setMap.put("category", "DOCCAT");
				setMap.put("typeCode", wfInstInfo.get("DocCategory"));
				
				getPJTMap.put("WFDocType",StringUtil.checkNull(commonService.selectString("common_SQL.getNameFromDic", setMap)));
				
				Description = StringUtil.checkNull(getPJTMap.get("Description"),"");
				Description = StringUtil.replaceFilterString(Description);
				getPJTMap.put("Description", Description);	
				model.put("getPJTMap", getPJTMap);				
				
				setMap.put("WFStepIDs", "'AREQ','APRV','AGR','PAGR','REW'");
				setMap.put("WFStepID", "");
				wfInstList = commonService.selectList("wf_SQL.getWfStepInstList_gridList", setMap);
				
				setMap.put("WFStepIDs", "'REC','REF'");
				wfRefInstList = commonService.selectList("wf_SQL.getWfStepInstList_gridList", setMap);

				String wfURL = commonService.selectString("wf_SQL.getWFCategoryURL", setMap);	
				
				setMap.put("emailCode", commandMap.get("emailCode") );
				String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", setMap));
				
				model.put("emailHTMLForm", emailHTMLForm);				
				model.put("menu", getLabel(request, commonService)); /*Label Setting*/	
				model.put("wfInstanceID", wfInstanceID);
				model.put("projectID", projectID);
				model.put("wfURL", wfURL);
				model.put("wfID", wfID);
				model.put("srID", srID);
				model.put("stepInstID", stepInstID);
				model.put("actorID", actorID);
				model.put("stepSeq", stepSeq);
				model.put("wfInstanceID", wfInstanceID);
				model.put("wfDocType", wfInstInfo.get("DocCategory"));
				model.put("wfMode", StringUtil.checkNull(commandMap.get("wfMode")));
				model.put("lastSeq", lastSeq);
				model.put("screenType", commandMap.get("screenType"));
				model.put("fileList", attachFileList);
				model.put("filePath", GlobalVal.FILE_UPLOAD_ITEM_DIR);
				model.put("wfInstList", wfInstList);
				model.put("wfRefInstList",wfRefInstList);
				model.put("documentID", documentID);
				model.put("docCategory", wfInstInfo.get("DocCategory"));
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return model;
	}
	
	
	@RequestMapping(value = "/approvalDetail.do")
	public String approvalDetail(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		List attachFileList = new ArrayList();
		List wfInstList = new ArrayList();
		String url = "/wf/approvalDetail"; 
		try {
				String wfMode = StringUtil.checkNull(commandMap.get("wfMode"));
				String menuIndex = "";
				String docCategory = StringUtil.checkNull(commandMap.get("docCategory"));
				url = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFDocURL", commandMap));
				
				if(wfMode.equals("AREQ")){
					menuIndex = "13";
				}else if(wfMode.equals("CurAprv")){
					menuIndex = "14";
				}else if(wfMode.equals("ToDoAprv")){
					menuIndex = "15";
				}else if(wfMode.equals("Ref")){
					menuIndex = "16";
				}else if(wfMode.equals("Cls")){
					menuIndex = "17";
				}
				model = getApprovalMailForm(request, commandMap, model);
				
				model.put("menuIndex", menuIndex);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(url);
	}

	// Approval Request 
	@RequestMapping("/createWFDocCSR.do")
	public String createWFDocCSR(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		
		String url =  StringUtil.checkNull(request.getParameter("WFDocURL")); 
		if(url.equals("")){ url = GlobalVal.CSR_APPROVAL_PATH; }

		try {
			String isNew = StringUtil.checkNull(request.getParameter("isNew"));
			String wfStep = StringUtil.checkNull(request.getParameter("wfStep"));
			String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
			String isMulti = StringUtil.checkNull(request.getParameter("isMulti"));
			String wfStepInfo = StringUtil.checkNull(request.getParameter("wfStep"), "WF001"); // TODO
			String wfDocType = StringUtil.checkNull(request.getParameter("wfDocType"),"CSR");
			String wfDocumentIDs = StringUtil.checkNull(request.getParameter("wfDocumentIDs"));
			String isPop = StringUtil.checkNull(request.getParameter("isPop"),"N");
			String backFunction = "csrDetail.do";
			String backMessage = "";
			String callbackData = "";
			Map labelMap = getLabel(request, commonService);

			String newWFInstanceID = "";
									
			String maxWFInstanceID = commonService.selectString("wf_SQL.MaxWFInstanceID", setMap);
			String OLM_SERVER_NAME = GlobalVal.OLM_SERVER_NAME;
			int OLM_SERVER_NAME_LENGTH = GlobalVal.OLM_SERVER_NAME.length();	
			String initLen = "%0" + (13-OLM_SERVER_NAME_LENGTH) + "d";
			
			int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(OLM_SERVER_NAME_LENGTH));
			int maxcode = maxWFInstanceID2 + 1;
			newWFInstanceID = OLM_SERVER_NAME + String.format(initLen, maxcode);
			
			// 합의 / 승인 단계 리스트 취득				
			setMap.put("LanguageID", commandMap.get("languageID"));
			setMap.put("WFID", wfStepInfo);
			setMap.put("TypeCode", wfStepInfo);
			setMap.put("ProjectID", request.getParameter("ProjectID"));
			
			List wfStepList = commonService.selectList("wf_SQL.getWfStepList", setMap);
			
			String wfDescription = commonService.selectString("wf_SQL.getWFDescription", setMap);
			String MandatoryGRID = commonService.selectString("wf_SQL.getMandatoryGRID", setMap);

			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("projectID", projectID);
			String ProjectName = commonService.selectString("project_SQL.getProjectName", setMap);
			
			model.put("ProjectName", ProjectName);
			model.put("wfDocumentIDs", wfDocumentIDs);
			model.put("isMulti", isMulti);
			model.put("isPop", isPop);
			model.put("wfDescription", wfDescription);
			model.put("MandatoryGRID", MandatoryGRID);
			
			setMap.put("WFStepIDs", "'AREQ','APRV','AGR'");
			
			List wfStepInstList = commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
			int wfStepInstListSize = 0;
			if(wfStepInstList != null && !wfStepInstList.isEmpty())
				wfStepInstListSize = wfStepInstList.size();
			
			model.put("wfStepInstListSize", wfStepInstListSize);
			
			String wfStepInstInfo = "";
			String wfStepInstREFInfo = "";
			String wfStepInstAGRInfo = "";
			
			String wfStepMemberIDs = "";
			String wfStepRoleTypes = "";
			
			Map wfStepInstInfoMap = new HashMap();
			Map getPJTMap = new HashMap();
			
			if(wfStepInstListSize > 0 ){
				for(int i=0; i<wfStepInstListSize; i++){
					wfStepInstInfoMap = (Map) wfStepInstList.get(i);
					if(i==0){
						wfStepInstInfo = wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+")";
						wfStepMemberIDs = StringUtil.checkNull(wfStepInstInfoMap.get("ActorID"));
						wfStepRoleTypes = StringUtil.checkNull(wfStepInstInfoMap.get("WFStepID"));
					}else{
						wfStepInstInfo = wfStepInstInfo + " >> "+ wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+")";
						wfStepMemberIDs = wfStepMemberIDs + "," + StringUtil.checkNull(wfStepInstInfoMap.get("ActorID"));
						wfStepRoleTypes = wfStepRoleTypes + "," + StringUtil.checkNull(wfStepInstInfoMap.get("WFStepID"));
					}
				}
				model.put("wfStepInstInfo", wfStepInstInfo); // 결재선
				model.put("wfStepMemberIDs", wfStepMemberIDs);
				model.put("wfStepRoleTypes", wfStepRoleTypes);
			}
							
			String wfStepRefMemberIDs = "";
			setMap.put("WFStepIDs", "'REF'");
			List wfStepInstREFList = commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
			Map wfStepInstInfREFoMap = new HashMap();
			if(wfStepInstREFList.size() > 0 ){
				for(int i=0; i<wfStepInstREFList.size(); i++){
					wfStepInstInfREFoMap = (Map) wfStepInstREFList.get(i);
					if(i==0){
						wfStepInstREFInfo = wfStepInstInfREFoMap.get("ActorName")+"("+ wfStepInstInfREFoMap.get("WFStepName")+")";
						wfStepRefMemberIDs = StringUtil.checkNull(wfStepInstInfREFoMap.get("ActorID"));
					}else{
						wfStepInstREFInfo = wfStepInstREFInfo + ","+ wfStepInstInfREFoMap.get("ActorName")+"("+ wfStepInstInfREFoMap.get("WFStepName")+")";
						wfStepRefMemberIDs = wfStepRefMemberIDs + "," + StringUtil.checkNull(wfStepInstInfREFoMap.get("ActorID"));
					}
				}
				model.put("wfStepInstREFInfo", wfStepInstREFInfo); // 결재선(참조)
				model.put("wfStepRefMemberIDs", wfStepRefMemberIDs);
				
			}	
			
			String wfStepAgrMemberIDs = "";
			setMap.put("WFStepIDs", "'AGR'");
			List wfStepInstAGRList = commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
			Map wfStepInstInfAGRoMap = new HashMap();
			if(wfStepInstAGRList.size() > 0 ){
				for(int i=0; i<wfStepInstAGRList.size(); i++){
					wfStepInstInfAGRoMap = (Map) wfStepInstAGRList.get(i);
					if(i==0){
						wfStepInstAGRInfo = wfStepInstInfAGRoMap.get("ActorName")+"("+ wfStepInstInfAGRoMap.get("WFStepName")+")";
						wfStepAgrMemberIDs = StringUtil.checkNull(wfStepInstInfAGRoMap.get("ActorID"));
					}else{
						wfStepInstAGRInfo = wfStepInstAGRInfo + ","+ wfStepInstInfAGRoMap.get("ActorName")+"("+ wfStepInstInfAGRoMap.get("WFStepName")+")";
						wfStepAgrMemberIDs = wfStepAgrMemberIDs + "," + StringUtil.checkNull(wfStepInstInfAGRoMap.get("ActorID"));
					}
				}
				model.put("wfStepInstAGRInfo", wfStepInstAGRInfo); // 결재선(참조)
				model.put("wfStepAGRMemberIDs", wfStepAgrMemberIDs);
				
			}

			setMap.put("dimTypeID", "100001");
			List regionList = commonService.selectList("dim_SQL.getDimValueNameList", setMap);
			
			model.put("regionList", regionList);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", request.getParameter("ProjectID"));
			
			Map getMap = commonService.select("wf_SQL.getWFInstanceDetail_gridList", setMap);
			model.put("getMap", getMap);

			if(getMap != null && !getMap.isEmpty())
				setMap.put("DocCategory", getMap.get("DocCategory"));

			if(wfDocType.equals("CSR")) {
				getPJTMap = commonService.select("project_SQL.getProjectInfo", setMap);
				backMessage = StringUtil.checkNull(labelMap.get("LN00203"));					
			}
			else if(wfDocType.equals("PJT")) {
				
				backFunction = "viewProjectInfo.do";	
				
				callbackData = "&changeSetID="+request.getParameter("ChangeSetID")+"&screenType=myPJT&pjtMode=R";
				getPJTMap = commonService.select("project_SQL.getProjectInfo", setMap);
				backMessage = StringUtil.checkNull(labelMap.get("LN00249"));
			}
			else if(wfDocType.equals("SR")) {
				setMap.put("srID", request.getParameter("srID"));
				getPJTMap = commonService.select("esm_SQL.getESMSRInfo", setMap);
				callbackData = "&srID="+request.getParameter("srID")+"&screenType=srRqst&srMode=mySR";
				backFunction = "processItsp.do";
				backMessage = StringUtil.checkNull(labelMap.get("LN00281"));
				
				Map setData = new HashMap();
				String srArea2 = StringUtil.checkNull(request.getParameter("srArea2"));
				setData.put("itemID", srArea2);
				setData.put("roleType", "I");
				setData.put("assignmentType", "SRROLETP");
				setData.put("languageID", commandMap.get("sessionCurrLangType"));
				String approverID = "";
				String aprvTeamID = "";
				List srWFStepList = commonService.selectList("esm_SQL.getWFMemberList", setData);
				
				String srMemberIDs = "";
				String srRoleTypes = "";		
				String srWFStepInfo = "";
				
				String sessionUserName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
				String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));
				
				String RequestUserID = StringUtil.checkNull(commonService.selectString("esm_SQL.getESMSRReqUserID", setMap));

				setMap.put("sessionUserId", RequestUserID);
				String reqTeamID =  StringUtil.checkNull(commonService.selectString("user_SQL.userTeamID",setMap));
				
				setMap.put("teamID", reqTeamID);
				Map managerInfo = commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
				
				
				String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
				String userTeamID =  StringUtil.checkNull(commandMap.get("sessionTeamId"));
				String userTeamName =  StringUtil.checkNull(commandMap.get("sessionTeamName"));		
				
				// 매니저
				String managerID = StringUtil.checkNull(managerInfo.get("UserID"));
				String managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
				String managerTeamID = StringUtil.checkNull(managerInfo.get("TeamID"));
				String managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));
						
				srMemberIDs = userID+","+managerID;
				srWFStepInfo = "AREQ,APRV";		
				srRoleTypes = userName+"("+userTeamName+") >> "+managerName+"("+managerTeamName+")";
				
				if(srWFStepList.size() > 0){
					for(int i=0; i<srWFStepList.size(); i++){
						Map srWFStep = (Map) srWFStepList.get(i);
						
						srWFStepInfo = srWFStepInfo + ">>" + StringUtil.checkNull(srWFStep.get("WFStep"));
						srMemberIDs = srMemberIDs +","+ StringUtil.checkNull(srWFStep.get("MemberID"));
						srRoleTypes = srRoleTypes + ",APRV";
						
					}
				}
				
				model.put("srMemberIDs", srMemberIDs);
				model.put("srRoleTypes", srRoleTypes);
				model.put("srWFStepInfo", srWFStepInfo);
				
				String srRequestUserID = StringUtil.checkNull(request.getParameter("srRequestUserID"));
				setData.put("memberID", srRequestUserID);
				String srRequestUserInfo = commonService.selectString("user_SQL.getMemberTeamInfo", setData);
				
				model.put("srRequestUserInfo", srRequestUserInfo);	
				model.put("srRequestUserID", srRequestUserID);
			}
			else if(wfDocType.equals("CS") && isMulti.equals("N")) {
				setMap.put("ProjectID", request.getParameter("ProjectID"));
				setMap.put("ChangeSetID", request.getParameter("ChangeSetID"));	
				setMap.put("s_itemID", request.getParameter("itemId"));				
				getPJTMap = commonService.select("wf_SQL.getChangeSetInfoWF", setMap);
				backFunction = "itemChangeInfo.do";
				callbackData = "&changeSetID="+request.getParameter("ChangeSetID")+"&screenMode=edit&StatusCode=MOD&isAuthorUser=&LanguageID="+commandMap.get("sessionCurrLangType");
				backMessage = StringUtil.checkNull(labelMap.get("LN00206"));
			}				
			
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", request.getParameter("ProjectID"));
			model.put("getPJTMap", getPJTMap);
			
			Map setData = new HashMap();
			if(StringUtil.checkNull(getPJTMap.get("Status")).equals("APRV")){
				setData.put("ProjectID",request.getParameter("ProjectID"));
				setData.put("Status","CNG");
				commonService.update("project_SQL.updateProject",setData);
			}else if(StringUtil.checkNull(getPJTMap.get("Status")).equals("APRV2")){
				setData.put("ProjectID",request.getParameter("ProjectID"));
				setData.put("Status","QA");
				commonService.update("project_SQL.updateProject",setData);
			}
			
			model.put("regionList", regionList);
			model.put("getPJTMap", getPJTMap);
			model.put("agrCnt",wfStepInstAGRList.size());
			
			model.put("wfStep", wfStep);
			model.put("wfDocType", wfDocType);
			
			model.put("menu", labelMap);  // Label Setting 
			model.put("isNew", isNew);
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
			model.put("ProjectID", projectID);
			model.put("wfDocType", wfDocType);
			model.put("backFunction", backFunction);
			model.put("backMessage", backMessage);
			model.put("callbackData", callbackData);
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("fromSR", StringUtil.checkNull(request.getParameter("fromSR")));
			model.put("srID", StringUtil.checkNull(request.getParameter("srID")));
			model.put("newWFInstanceID", newWFInstanceID);
			
			// Tree >> ITEM >> [개요] >> [변경 이력]
			model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));

		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);
	}
		
	@RequestMapping(value = "/openApprCommentPop.do")
	public String openApprCommentPop(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
				String projectID = StringUtil.checkNull(commandMap.get("projectID"));
				String wfID = StringUtil.checkNull(commandMap.get("wfID"));
				String loginUser = StringUtil.checkNull(commandMap.get("sessionUserId"));
				String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
				String stepInstID = StringUtil.checkNull(commandMap.get("stepInstID"));
				String actorID = StringUtil.checkNull(commandMap.get("actorID"));
				String stepSeq = StringUtil.checkNull(commandMap.get("stepSeq"));
				String lastSeq = StringUtil.checkNull(commandMap.get("lastSeq"));
				String wfStepInstStatus = StringUtil.checkNull(commandMap.get("wfStepInstStatus"));
				String srID = StringUtil.checkNull(commandMap.get("srID"));
				String documentID = StringUtil.checkNull(commandMap.get("documentID"));
				String svcCompl = StringUtil.checkNull(commandMap.get("svcCompl"));
				String docNo = StringUtil.checkNull(commandMap.get("docNo"));
				
				setMap.put("ProjectID", projectID);
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				setMap.put("s_itemID", projectID);
				Map getPJTMap = commonService.select("project_SQL.getProjectInfo", setMap);
				model.put("getPJTMap", getPJTMap);
								
				model.put("menu", getLabel(request, commonService)); /*Label Setting*/	
				model.put("projectID", projectID);
				model.put("wfID", wfID);
				model.put("documentID", documentID);
				model.put("srID", srID);
				model.put("stepInstID", stepInstID);
				model.put("actorID", actorID);
				model.put("stepSeq", stepSeq);
				model.put("wfInstanceID", wfInstanceID);
				model.put("lastSeq", lastSeq);
				model.put("wfStepInstStatus", wfStepInstStatus);
				model.put("svcCompl", svcCompl);
				model.put("docNo", docNo);
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/wf/approvalComment");
	}
	

	public HashMap updateWFInstStep(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
			String projectID = StringUtil.checkNull(commandMap.get("projectID"));
			String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));				
			String stepInstID = StringUtil.checkNull(commandMap.get("stepInstID"));
			String comment = StringUtil.checkNull(commandMap.get("comment"));	
			String actorID = StringUtil.checkNull(commandMap.get("actorID"));
			String lastSeq = StringUtil.checkNull(commandMap.get("lastSeq"));
			String stepSeq = StringUtil.checkNull(commandMap.get("stepSeq"));
			String wfStepInstStatus = StringUtil.checkNull(commandMap.get("wfStepInstStatus"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String wfInstanceStatus = "1";
			String docStatus = "APRV2";
			String aprvOption = StringUtil.checkNull(commandMap.get("aprvOption"),"POST");
		    String emailCode = "APREQ_CSR";
		    String svcCompl = StringUtil.checkNull(commandMap.get("svcCompl"));
		    String docNo = StringUtil.checkNull(commandMap.get("docNo"));
		
			HashMap apprInfoMail = new HashMap();
			Map wfInfoMap = new HashMap();
			setMap.put("wfInstanceID", wfInstanceID);
			wfInfoMap = commonService.select("wf_SQL.getWFInstTXT", setMap);
			String url = "";
			String data = "";
			setMap.put("ProjectID", projectID);
			setMap.put("WFInstanceID", wfInstanceID);
			setMap.put("wfInstanceID", wfInstanceID);
			setMap.put("StepInstID", stepInstID);
			setMap.put("Status", wfStepInstStatus); // 승인:2, 반려: 3
			setMap.put("comment", comment);
			setMap.put("ActorID", actorID);
			commonService.update("wf_SQL.updateWFStepInst", setMap); 	// Update TB_WF_STEP_INST
			setMap.put("LastUser", commandMap.get("sessionUserId"));
			String wfID = commonService.selectString("wf_SQL.getWFID", setMap); 
			commandMap.put("wfID", wfID);
			Map wfDocMap = commonService.select("wf_SQL.getWFInstDoc", setMap);			
			String wfStepID = commonService.selectString("wf_SQL.getWFINStepID", setMap); 
			setMap.put("projectID", projectID);
			setMap.put("stepSeq", stepSeq);
			setMap.put("status", "0");
			setMap.put("languageID", languageID);
			String getWFStepInstCount = commonService.selectString("wf_SQL.getWFStepInstCount", setMap); // status=0 인것 Count
			
			HashMap setMailData = new HashMap();				
			setMailData.put("subject", wfInfoMap.get("Subject"));
			setMailData.put("LanguageID",languageID);
			
			if(wfStepInstStatus.equals("2") || "REW".equals(wfStepID)){ // 승인
				
			    if(!lastSeq.equals(stepSeq) && Integer.parseInt(getWFStepInstCount) == 0){ // 단계  승인 완료 시 Update TB_WF_INST CurrSeq = stepSeq+1 
					setMap.put("curSeq", Integer.parseInt(stepSeq)+1);	
					setMap.put("Status", "1"); 		
					commonService.update("wf_SQL.updateWfInst", setMap); 
											
					setMap.put("Status", "0"); 		
					setMap.remove("comment");
					setMap.remove("ActorID");
					setMap.remove("StepInstID");
					setMap.put("updateSeq", Integer.parseInt(stepSeq)+1);
					
					commonService.update("wf_SQL.updateWFStepInst", setMap);
											
					setMap.put("stepInstID", stepInstID);
					setMap.put("nextSeq", Integer.parseInt(stepSeq)+1);
					
					List receiverList = new ArrayList();
					List refList = new ArrayList();
					List temp1 = commonService.selectList("wf_SQL.getWFStepMailList",setMap);
					
					//다음 단계 합의/승인자 리스트로 메일 전송
					commandMap.put("wfMailStep", "REW");
		
				} else if(lastSeq.equals(stepSeq) && Integer.parseInt(getWFStepInstCount) == 0){  //최종승인인 경우
					wfInstanceStatus = "2" ;

				} 

			    if(wfInstanceStatus.equals("2") || 
						( (!wfStepInstStatus.equals("2") && "REW".equals(wfStepID)) 
								&& lastSeq.equals(stepSeq) && Integer.parseInt(getWFStepInstCount) == 0)){

					wfInstanceStatus = "2" ;

					commandMap.put("wfMailStep", "LastREW");
					commandMap.put("wfInstanceStatus", wfInstanceStatus);

					setMap.put("Status", wfInstanceStatus); 	
					setMap.put("LastUser", actorID);
					commonService.update("wf_SQL.updateWfInst", setMap); 	
				}
			    
			    System.out.println("Approval Update SUCCESS! ");
			}else if(!wfStepInstStatus.equals("2")){ // 3 = 반려 , 4 = 상신 취소 
				commandMap.put("wfMailStep", "Return");
				wfInstanceStatus = wfStepInstStatus ;
				docStatus = "HOLD";
				target.put(AJAX_ALERT,MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00156"));// 반려하였습니다.
				
				System.out.println("wfStepInstStatus :"+wfStepInstStatus+": HOLD Update SUCCESS! ");
				//CSR Status = HOLD, WFInstance Status = 3
				setMap.put("Status", wfInstanceStatus); 	
				commonService.update("wf_SQL.updateWfInst", setMap); 	


				if(wfDocMap.get("DocCategory").equals("CS")) {
					docStatus = "WTR";
					setMap.put("status", docStatus); 	
					setMap.put("wfInstanceID", wfInstanceID);
					
					commonService.update("cs_SQL.updateChangeSetForWFInstID", setMap);
				}


			}
			commandMap.put("DocCategory", StringUtil.checkNull(wfDocMap.get("DocCategory")));
			commandMap.put("DocumentID", StringUtil.checkNull(wfDocMap.get("DocumentID")));
			commandMap.put("Subject", StringUtil.checkNull(wfInfoMap.get("Subject")));
			commandMap.put("comment", comment);
		} catch (Exception e) {
			
			System.out.println(e.toString());
		}

		return commandMap;
	}

	public HashMap sendMailForWFInstStep(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		try {
			String wfMailStep = StringUtil.checkNull(commandMap.get("wfMailStep"));
			String DocCategory = StringUtil.checkNull(commandMap.get("DocCategory"));
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String languageID = StringUtil.checkNull(commandMap.get("languageID"));
			String projectID = StringUtil.checkNull(commandMap.get("projectID"));
			String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
			String stepSeq = StringUtil.checkNull(commandMap.get("stepSeq"));
			String lastSeq = StringUtil.checkNull(commandMap.get("lastSeq"));
			String stepInstID = StringUtil.checkNull(commandMap.get("stepInstID"));
			String wfStepInstStatus = StringUtil.checkNull(commandMap.get("wfStepInstStatus"));
			String Subject = StringUtil.checkNull(commandMap.get("Subject"));
			String docNo = StringUtil.checkNull(commandMap.get("docNo"));
		
			String wfInstanceStatus = "1";
			String docStatus = "APRV2";
			String aprvOption = StringUtil.checkNull(commandMap.get("aprvOption"),"POST");
		    String emailCode = "APREQ_CSR";
		    
			setMap.put("languageID", languageID);
			setMap.put("projectID", projectID);
			setMap.put("wfInstanceID", wfInstanceID);
			

			List reqReceiverList = new ArrayList();		

			Map setWFData = new HashMap();
			//단순 승인, 반려, 최종 승인
			if("REW".equals(wfMailStep)){ // 승인
				commandMap.put("wfInstanceStatus", wfInstanceStatus);
				Map setMailData = new HashMap();
										
				setMap.put("stepInstID", stepInstID);
				setMap.put("nextSeq", Integer.parseInt(stepSeq)+1);
				
				List receiverList = new ArrayList();
				List refList = new ArrayList();
				List temp1 = commonService.selectList("wf_SQL.getWFStepMailList",setMap);
				
				//다음 단계 합의/승인자 리스트로 메일 전송
				int j = 0;
				
				String emailStepInstID = "";
				String emailStepSeq = "";
				String emailActorID = "";
				for(int i=0; i<temp1.size(); i++) {
					Map tempMap = (Map)temp1.get(i);
					Map tempMap2 = new HashMap();	
					String WFStepID = (String) tempMap.get("WFStepID");
					if("REF".equals(WFStepID)) {
						tempMap2.put("userID", tempMap.get("ActorID"));
						refList.add(StringUtil.checkNull(commonService.selectString("user_SQL.userEmail", tempMap2),""));
					}
					else {
						tempMap2.put("receiptUserID", tempMap.get("ActorID"));
						receiverList.add(j++,tempMap2);
						
						emailStepInstID = StringUtil.checkNull(tempMap.get("StepInstID"));	
						emailStepSeq = StringUtil.checkNull(tempMap.get("Seq"));
						emailActorID = StringUtil.checkNull(tempMap.get("ActorID"));
					}					
				}			

				if(DocCategory.equals("CS")) {
					emailCode = "APREQ_CS";						   		    	
			    }else if(DocCategory.equals("SR")) {		
			    	emailCode = "SRAPREQ";	
			    }else if(DocCategory.equals("CSR")) {		
			    	emailCode = "CSRCLS";	
			    }					
				
		    	commandMap.put("emailCode", emailCode);		
				setMailData.put("receiverList",receiverList);
				setMailData.put("subject", Subject);
				Map setMailMap = (Map)setEmailLog(request, commonService, setMailData, emailCode); //CSR  승인 다음 단계 처리자에게 이메일 발송
				
				if(StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")){
					HashMap mailMap = (HashMap)setMailMap.get("mailLog");
					
					ModelMap MailModel = getApprovalMailForm(request, commandMap, model);
					MailModel.put("receiverList",receiverList);	
					MailModel.put("LanguageID",languageID);	
					mailMap.put("refList",refList);
					
					MailModel.put("stepInstID", emailStepInstID); 
					MailModel.put("stepSeq", emailStepSeq); 
					MailModel.put("lastSeq", lastSeq); 
					MailModel.put("actorID", emailActorID); 
					
					if(!srID.equals("")){
						setMap.put("srID",srID);
						HashMap esmMap = (HashMap)commonService.select("esm_SQL.getESMSRInfo", setMap);
						MailModel.put("SubCategoryNM",esmMap.get("SubCategoryName"));
						MailModel.put("SRArea1Name",esmMap.get("SRArea1Name"));
						MailModel.put("SRArea2Name",esmMap.get("SRArea2Name"));
						MailModel.put("ReqUserNM",esmMap.get("ReqUserNM"));
						MailModel.put("ReqTeamNM",esmMap.get("ReqTeamNM"));
						MailModel.put("ReqDueDate",esmMap.get("ReqDueDate"));
						MailModel.put("SRDescription",esmMap.get("Description"));
						MailModel.put("SRID",esmMap.get("SRID"));
						MailModel.put("wfInstanceID",esmMap.get("WFInstanceID"));

						setMap.put("s_itemID",projectID);
						HashMap pjtMap = (HashMap)commonService.select("project_SQL.getProjectInfoView", setMap);
						MailModel.put("ProjectID",pjtMap.get("ProjectID"));
						MailModel.put("ProjectName",pjtMap.get("ProjectName"));
						MailModel.put("ProjectCode",pjtMap.get("ProjectCode"));
						MailModel.put("Path",pjtMap.get("Path"));
						MailModel.put("AuthorName",pjtMap.get("AuthorName"));
						MailModel.put("TeamName",pjtMap.get("TeamName"));
						MailModel.put("StartDate",pjtMap.get("StartDate"));
						MailModel.put("DueDate",pjtMap.get("DueDate"));
						MailModel.put("Description",pjtMap.get("Description"));
					}
					
					Map resultMailMap = EmailUtil.sendMail(mailMap,MailModel,getLabel(request, commonService));
					System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMap.get("type")));
				}else{
					System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMap.get("msg")));
				}		
				commandMap.put("message", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00083"));
				
			} else {
				if("LastREW".equals(wfMailStep)){  //최종승인인 경우
			
					wfInstanceStatus = "2" ;
	
					commandMap.put("wfInstanceStatus", wfInstanceStatus);
	
					commandMap.put("message", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00083"));

					emailCode = "APRVCLS"; if(DocCategory.equals("SR")) emailCode = "SRAPREL";	
				}
				else if("Return".equals(wfMailStep)){ // 3 = 반려 , 4 = 상신 취소 
					
					wfInstanceStatus = wfStepInstStatus ;
					commandMap.put("wfInstanceStatus", wfInstanceStatus);
					docStatus = "HOLD";
					commandMap.put("message", MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00156"));


					emailCode = "APRVRJT"; if(DocCategory.equals("SR")) emailCode = "SRAPRJT";
									
					setMap.put("wfInstanceStatus", wfInstanceStatus);
					setWFData.put("wfInstanceStatus", wfInstanceStatus);
					
				}
				
				// 최종 승인 후  결재 참조자에게 메일 발송
				setMap.put("wfStepID", "REF");
				List receiverList = new ArrayList();
				List refList = new ArrayList();
				List temp1 = commonService.selectList("wf_SQL.getWFStepMailList",setMap);
				
				int j = 0;
				for(int i=0; i<temp1.size(); i++) {
					Map tempMap = (Map)temp1.get(i);
					Map tempMap2 = new HashMap();	
					String WFStepID = (String) tempMap.get("WFStepID");
					if("REF".equals(WFStepID)) {
						tempMap2.put("receiptUserID", tempMap.get("ActorID"));
						tempMap2.put("receiptType", "CC");
						reqReceiverList.add(j++,tempMap2);
					}					
				}		
				
				if(wfInstanceStatus.equals("2")) {
					setMap.put("wfStepID", "REC");			
					temp1 = commonService.selectList("wf_SQL.getWFStepMailList",setMap);
					for(int i=0; i<temp1.size(); i++) {
						Map tempMap = (Map)temp1.get(i);
						Map tempMap2 = new HashMap();	
						String WFStepID = (String) tempMap.get("WFStepID");
						if("REC".equals(WFStepID)) {
							tempMap2.put("receiptUserID", tempMap.get("ActorID"));
							tempMap2.put("receiptType", "CC");
							reqReceiverList.add(j++,tempMap2);
						}					
					}
				}					

				//상신자 및 주관조직 담당자에게 최종 승인완료 이메일 발송
				HashMap projectInfoMap = (HashMap)commonService.select("project_SQL.getProjectInfo", setMap);
										
				Map receiverMap = new HashMap();	
			
				setWFData.put("projectID", projectID);
				setWFData.put("wfInstanceID", wfInstanceID);
							
				
				setWFData.put("wfStepID", "AREQ");
				String requester = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFActorID", setWFData)); // CSR 상신 이메일 수신자 
				receiverMap.put("receiptUserID", requester);
				reqReceiverList.add(j++,receiverMap);
				
				Map managerMap = new HashMap();
				setWFData.put("wfStepID", "MGT");
				String manager = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFActorID", setWFData)); // CSR 주관조직 담당자에게 이메일 
				if(!manager.equals("")){
					managerMap.put("receiptUserID", manager);
					managerMap.put("receiptType", "CC");
					reqReceiverList.add(j++,managerMap);
				}
											
				setMap.remove("wfStepID");
				setMap.put("wfStepIDs", "'AGR','APRV','PAGR','REW'");			
				temp1 = commonService.selectList("wf_SQL.getWFStepMailList",setMap);
				for(int i=0; i<temp1.size(); i++) {
					Map tempMap = (Map)temp1.get(i);
					Map tempMap2 = new HashMap();	
					if(!stepSeq.equals(tempMap.get("Seq"))) {
						tempMap2.put("receiptUserID", tempMap.get("ActorID"));
						reqReceiverList.add(j++,tempMap2);	
					}
				}	
				
				setWFData.put("receiverList", reqReceiverList);
				
				
				Map temp = new HashMap();
				temp.put("Category", "EMAILCODE"); 
				temp.put("TypeCode", emailCode);
				temp.put("LanguageID", commandMap.get("sessionCurrLangType"));
				Map emDescription = commonService.select("common_SQL.label_commonSelect", temp);
				projectInfoMap.put("emDescription",emDescription.get("Description"));
				
				setWFData.put("languageID", commandMap.get("sessionCurrLangType"));
				String projectName = commonService.selectString("project_SQL.getProjectName", setWFData);
				
				setWFData.put("subject", Subject);
				Map setMail_APRVCLS = (Map)setEmailLog(request, commonService, setWFData, emailCode);
				
				// 최종 승인/반려 Approval History 
				setMap.put("LanguageID", StringUtil.checkNull(commandMap.get("sessionCurrLangType")));
				setMap.put("WFStepIDs", "'AREQ','APRV','AGR','PAGR','REW'");
				setMap.put("WFStepID", "");
				List wfInstList = commonService.selectList("wf_SQL.getWfStepInstList_gridList", setMap);
				
				setMap.put("WFStepIDs", "'REC','REF'");
				List wfRefInstList = commonService.selectList("wf_SQL.getWfStepInstList_gridList", setMap);
				
				if(StringUtil.checkNull(setMail_APRVCLS.get("type")).equals("SUCESS")){
					HashMap mailMap = (HashMap)setMail_APRVCLS.get("mailLog");																									
					projectInfoMap.put("languageID", commandMap.get("sessionCurrLangType"));
					projectInfoMap.put("wfInstanceID",wfInstanceID);	
					projectInfoMap.put("docNo",docNo);
					projectInfoMap.put("wfInstList", wfInstList);	
					projectInfoMap.put("wfRefInstList", wfRefInstList);	
					
					setMap.put("emailCode", emailCode);
					setMap.put("languageID", languageID);
					String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", setMap));
					projectInfoMap.put("emailHTMLForm", emailHTMLForm);
			
				    Map resultMailMap = EmailUtil.sendMail(mailMap, projectInfoMap, getLabel(request, commonService));
				    
					System.out.println("SEND EMAIL TYPE:"+resultMailMap+ "Msg :" + StringUtil.checkNull(setMail_APRVCLS.get("type")));
				}else{
					System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+ StringUtil.checkNull(setMail_APRVCLS.get("msg")));
				}
			}			
						
		} catch (Exception e) {
			
			System.out.println(e.toString());
		}

		return commandMap;
	}
	

	public String exeForPostProcessing(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
		String Script = "";
		try {
			String wfInstanceStatus = StringUtil.checkNull(commandMap.get("wfInstanceStatus"));
			String wfID = StringUtil.checkNull(commandMap.get("wfID"));
			String DocCategory = StringUtil.checkNull(commandMap.get("DocCategory"));
			String aprvOption = StringUtil.checkNull(commandMap.get("aprvOption"),"POST");
			String projectID = StringUtil.checkNull(commandMap.get("projectID"));
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String wfInstanceID = StringUtil.checkNull(commandMap.get("wfInstanceID"));
			String svcCompl = StringUtil.checkNull(commandMap.get("svcCompl"));
			String comment = StringUtil.checkNull(commandMap.get("comment"));
			String documentID = StringUtil.checkNull(commandMap.get("DocumentID"));
			String docStatus = "CLS";
			String url = "";
			String data = "";
			String itemID = "";
			String screenType = "";

			setMap.put("wfInstanceID",wfInstanceID);
			// wfAllocID 없을 때 기본값 1
			String wfAllocID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFIDForWFAllocID", setMap),"1"); 
			setMap.put("wfAllocID", wfAllocID);
			
			String postProcessing = StringUtil.checkNull(commonService.selectString("wf_SQL.getPostProcessing", setMap),""); 
	
			if(!"".equals(postProcessing)) {
				if(postProcessing.split("\\?").length > 1) {
					String tmp[] = postProcessing.split("\\?");
					url = tmp[0];
					data = tmp[1]+"&status="+docStatus+"&screenType=csrDtl&wfInstanceID="+wfInstanceID+"&wfInstanceStatus="+wfInstanceStatus+"&svcCompl="+svcCompl + "&srID=" + srID;	
				}
				else {
					url = postProcessing;
					data = "&status="+docStatus+"&screenType="+screenType+"&wfInstanceStatus="+wfInstanceStatus+"&wfInstanceID="+wfInstanceID+"&svcCompl="+svcCompl + "&srID=" + srID;							
					
				}
			}
			Script = "parent.fnCallBackSubmit('"+url+"', '"+data+"');";
						
						
		} catch (Exception e) {
			
			System.out.println(e.toString());
		}

		return Script;
	}

	
	
	
	@RequestMapping(value = "/submitStepApproval.do")
	public String submitStepApproval(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		HashMap target = new HashMap();
		Map setMap = new HashMap();
			try {
				HashMap tempMap = commandMap;
				tempMap = updateWFInstStep(request,commandMap,model);
				
				commandMap.put("wfID", tempMap.get("wfID"));
				commandMap.put("wfMailStep", tempMap.get("wfMailStep"));
				commandMap.put("DocCategory", tempMap.get("DocCategory"));
				commandMap.put("DocumentID", tempMap.get("DocumentID"));
				
				tempMap = sendMailForWFInstStep(request,commandMap,model);

				commandMap.put("wfInstanceStatus", tempMap.get("wfInstanceStatus"));
				commandMap.put("message", tempMap.get("message"));
				
				String script = exeForPostProcessing(request,commandMap,model);

				target.put(AJAX_MESSAGE, StringUtil.checkNull(commandMap.get("message")));
				target.put(AJAX_SCRIPT, script);
							
			} catch (Exception e) {
				System.out.println(e);
				target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
				target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00084")); // 합의/승인 중 오류가 발생하였습니다.											
			}
			model.addAttribute(AJAX_RESULTMAP, target);
			return nextUrl(AJAXPAGE);
	}

	
	@RequestMapping(value="/getAprvGroupList.do")
	public String getAprvGroupList(HttpServletRequest request, HashMap commandMap,ModelMap model) throws Exception {
		String wfID = StringUtil.checkNull(request.getParameter("WFID"));
		String grID = StringUtil.checkNull(request.getParameter("GRID"));
		String grType = StringUtil.checkNull(request.getParameter("GRType"));
		
		if(grID.equals("") && !"".equals(wfID) && grType.equals("MGT")) {
			grID = commonService.selectString("wf_SQL.getMandatoryGRID", commandMap);
		}
		else if(grID.equals("") && !"".equals(wfID) && grType.equals("End")) {
			grID = commonService.selectString("wf_SQL.getEndGRID", commandMap);
		}
		
		commandMap.put("state", request.getParameter("dimTypeId"));
		commandMap.put("GRType", request.getParameter("GRType"));
		commandMap.put("GRID", grID);
		List getList = commonService.selectList("common_SQL.getAprvGroupList_commonSelect" ,commandMap);
				
		model.put(AJAX_RESULTMAP, getList);
		return nextUrl(AJAXPAGE_SELECTOPTION);
	}
	
	@RequestMapping(value="/getWFCategoryList.do")
	public String getWFCategoryList(HttpServletRequest request, HashMap commandMap,ModelMap model) throws Exception {

		Map setMap = new HashMap();
		
		try {
			
			List categoryList = commonService.selectList("wf_SQL.getWFCategoryList" ,commandMap);
		
			model.put("categoryList", categoryList);
			model.put("categoryCnt", categoryList.size());
			model.put("wfInstanceID", StringUtil.checkNull(commandMap.get("wfInstanceID")));
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
		
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("wf/wfCategoryList");
	}
	

	@RequestMapping(value="/getWFApprovalCheckList.do")
	public String getWFApprovalCheckList(HttpServletRequest request, HashMap commandMap,ModelMap model) throws Exception {

		Map setMap = new HashMap();
		
		try {
		
			String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType"));
			String documentIDs = StringUtil.checkNull(commandMap.get("documentIDs"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			
			model.put("wfDocType", wfDocType); 
			model.put("documentIDs", documentIDs);
			model.put("menu", getLabel(request, commonService));
		
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("wf/wfApprovalCheckList");
	}
	
	// Approval Request 
	@RequestMapping("/wfDocMgt.do")
	public String wfDocMgt(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		String url = "";
		Map setMap = new HashMap();

		try {
			String actionType = StringUtil.checkNull(request.getParameter("actionType"), "create");
			String wfDocType = StringUtil.checkNull(request.getParameter("wfDocType"),"CSR");
			String wfDocURL = StringUtil.checkNull(request.getParameter("WFDocURL"),"");
			String wfAprURL = StringUtil.checkNull(request.getParameter("wfAprURL"),"");
			String docCategory = StringUtil.checkNull(commandMap.get("docCategory"));
			String docSubClass = StringUtil.checkNull(commandMap.get("docSubClass"));
			String projectID = StringUtil.checkNull(commandMap.get("projectID"),"");
			
			if(actionType.equals("create")) {
				model = getWfDocInfo(request, commandMap, model);
				String defWFID = StringUtil.checkNull(model.get("defWFID"),"");
				url = "".equals(wfDocURL) ? wfDocType.equals("CSR") ? GlobalVal.CSR_APPROVAL_PATH : GlobalVal.CS_APPROVAL_PATH : wfDocURL;
				
				setMap.put("defWFID",defWFID);
				
				if("".equals(defWFID)) {

					setMap.put("wfDocType",wfDocType);
					setMap.put("docSubClass",docSubClass);
					defWFID = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFIDForTypeCode", setMap));
				}

				model.put("defWFID",defWFID);			
				setMap.put("WFID",defWFID);
				String stepName = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFURL", setMap));
				commandMap.put("funcType",stepName);
									
				HashMap returnMap = wfPathMgt(model,commandMap,request);
				String memberIDs = StringUtil.checkNull(returnMap.get("memberIDs"));
				
				if(!"".equals(memberIDs)) {
					//기본 결재선
					model.put("memberIDs",returnMap.get("memberIDs"));					
					model.put("roleTypes",returnMap.get("roleTypes"));
					model.put("wfStepInfo",returnMap.get("wfStepInfo"));
					
					//참조
					model.put("refWfStepInfo",returnMap.get("refWfStepInfo"));
					model.put("refMBIDs",returnMap.get("refBIDs"));
					
					//수신
					model.put("recWfStepInfo",returnMap.get("recWfStepInfo"));
					model.put("recMBIDs",returnMap.get("recMBIDs"));
					
					model.put("pathFlg","Y");
					
				}
				
				
				// FLTP에 CSDOC 존재 시 attach 옵션 사용 가능
				setMap.put("FltpCode", "CSDOC");
				String fileTypeCount = commonService.selectString("config_SQL.fileTypeEqualCount", setMap);
				model.put("fileTypeCount",fileTypeCount);
				
				//projectId
				model.put("ProjectID", projectID);
				
				
				
				
			}
			else if(actionType.equals("view")) {
				model = getApprovalMailForm(request, commandMap, model);				
				url = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFAprURL", commandMap));
				if(url.equals("")) url = "/wf/approvalDetail"; 
			}
			
		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return nextUrl(url);		
	}
	
	public ModelMap getWfDocInfo(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();

		try {
			String isNew = StringUtil.checkNull(request.getParameter("isNew"));
			String wfStep = StringUtil.checkNull(request.getParameter("wfStep"));
			String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
			String isMulti = StringUtil.checkNull(request.getParameter("isMulti"));
			String wfStepInfo = StringUtil.checkNull(request.getParameter("wfStep"), "WF001"); // TODO
			String wfDocType = StringUtil.checkNull(request.getParameter("wfDocType"),"CSR");
			String docSubClass = StringUtil.checkNull(request.getParameter("docSubClass"));
			String wfDocumentIDs = StringUtil.checkNull(request.getParameter("wfDocumentIDs"));
			String wfInstanceID = StringUtil.checkNull(request.getParameter("wfInstanceID"));
			String isMultiCnt = StringUtil.checkNull(request.getParameter("isMultiCnt"),"0");
			String isPop = StringUtil.checkNull(request.getParameter("isPop"),"N");
			String backFunction = "csrDetail.do";
			String backMessage = "";
			String callbackData = "";
			Map labelMap = getLabel(request, commonService);
			
			String newWFInstanceID = "";
											
			String maxWFInstanceID = commonService.selectString("wf_SQL.MaxWFInstanceID", setMap);
			String OLM_SERVER_NAME = GlobalVal.OLM_SERVER_NAME;
			int OLM_SERVER_NAME_LENGTH = GlobalVal.OLM_SERVER_NAME.length();	
			String initLen = "%0" + (13-OLM_SERVER_NAME_LENGTH) + "d";
			
			int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(OLM_SERVER_NAME_LENGTH));
			int maxcode = maxWFInstanceID2 + 1;
			newWFInstanceID = OLM_SERVER_NAME + String.format(initLen, maxcode);
			
			// 합의 / 승인 단계 리스트 취득				
			setMap.put("LanguageID", commandMap.get("languageID"));
			setMap.put("WFID", wfStepInfo);
			setMap.put("TypeCode", wfStepInfo);
			setMap.put("wfInstanceID", wfInstanceID);
			
			List wfStepList = commonService.selectList("wf_SQL.getWfStepList", setMap);
			
			String wfDescription = commonService.selectString("wf_SQL.getWFDescription", setMap);
			String MandatoryGRID = commonService.selectString("wf_SQL.getMandatoryGRID", setMap);

			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			
			model.put("wfDocumentIDs", wfDocumentIDs);
			model.put("isMulti", isMulti);
			model.put("isPop", isPop);
			model.put("wfDescription", wfDescription);
			model.put("MandatoryGRID", MandatoryGRID);
			
			setMap.put("WFStepIDs", "'AREQ','APRV','AGR'");
			
			List wfStepInstList = commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
			int wfStepInstListSize = 0;
			if(wfStepInstList != null && !wfStepInstList.isEmpty())
				wfStepInstListSize = wfStepInstList.size();
			
			model.put("wfStepInstListSize", wfStepInstListSize);
			
			String wfStepInstInfo = "";
			String wfStepInstREFInfo = "";
			String wfStepInstAGRInfo = "";
			
			String wfStepMemberIDs = "";
			String wfStepRoleTypes = "";
			
			Map wfStepInstInfoMap = new HashMap();
			Map getPJTMap = new HashMap();
			Map getWFTXTMap = new HashMap();
			
			if(wfStepInstListSize > 0 ){
				for(int i=0; i<wfStepInstListSize; i++){
					wfStepInstInfoMap = (Map) wfStepInstList.get(i);
					if(i==0){
						wfStepInstInfo = wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+")";
						wfStepMemberIDs = StringUtil.checkNull(wfStepInstInfoMap.get("ActorID"));
						wfStepRoleTypes = StringUtil.checkNull(wfStepInstInfoMap.get("WFStepID"));
					}else{
						wfStepInstInfo = wfStepInstInfo + " >> "+ wfStepInstInfoMap.get("ActorName")+"("+ wfStepInstInfoMap.get("WFStepName")+")";
						wfStepMemberIDs = wfStepMemberIDs + "," + StringUtil.checkNull(wfStepInstInfoMap.get("ActorID"));
						wfStepRoleTypes = wfStepRoleTypes + "," + StringUtil.checkNull(wfStepInstInfoMap.get("WFStepID"));
					}
				}
				model.put("wfStepInstInfo", wfStepInstInfo); // 결재선
				model.put("wfStepMemberIDs", wfStepMemberIDs);
				model.put("wfStepRoleTypes", wfStepRoleTypes);
			}
							
			String wfStepRefMemberIDs = "";
			setMap.put("WFStepIDs", "'REF'");
			List wfStepInstREFList = commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
			Map wfStepInstInfREFoMap = new HashMap();
			if(wfStepInstREFList.size() > 0 ){
				for(int i=0; i<wfStepInstREFList.size(); i++){
					wfStepInstInfREFoMap = (Map) wfStepInstREFList.get(i);
					if(i==0){
						wfStepInstREFInfo = wfStepInstInfREFoMap.get("ActorName")+"("+ wfStepInstInfREFoMap.get("WFStepName")+")";
						wfStepRefMemberIDs = StringUtil.checkNull(wfStepInstInfREFoMap.get("ActorID"));
					}else{
						wfStepInstREFInfo = wfStepInstREFInfo + ","+ wfStepInstInfREFoMap.get("ActorName")+"("+ wfStepInstInfREFoMap.get("WFStepName")+")";
						wfStepRefMemberIDs = wfStepRefMemberIDs + "," + StringUtil.checkNull(wfStepInstInfREFoMap.get("ActorID"));
					}
				}
				model.put("wfStepInstREFInfo", wfStepInstREFInfo); // 결재선(참조)
				model.put("wfStepRefMemberIDs", wfStepRefMemberIDs);
			}	
			
			String wfStepAgrMemberIDs = "";
			setMap.put("WFStepIDs", "'AGR'");
			List wfStepInstAGRList = commonService.selectList("wf_SQL.getWFStepInstInfoList", setMap);
			Map wfStepInstInfAGRoMap = new HashMap();
			if(wfStepInstAGRList.size() > 0 ){
				for(int i=0; i<wfStepInstAGRList.size(); i++){
					wfStepInstInfAGRoMap = (Map) wfStepInstAGRList.get(i);
					if(i==0){
						wfStepInstAGRInfo = wfStepInstInfAGRoMap.get("ActorName")+"("+ wfStepInstInfAGRoMap.get("WFStepName")+")";
						wfStepAgrMemberIDs = StringUtil.checkNull(wfStepInstInfAGRoMap.get("ActorID"));
					}else{
						wfStepInstAGRInfo = wfStepInstAGRInfo + ","+ wfStepInstInfAGRoMap.get("ActorName")+"("+ wfStepInstInfAGRoMap.get("WFStepName")+")";
						wfStepAgrMemberIDs = wfStepAgrMemberIDs + "," + StringUtil.checkNull(wfStepInstInfAGRoMap.get("ActorID"));
					}
				}
				model.put("wfStepInstAGRInfo", wfStepInstAGRInfo); // 결재선(참조)
				model.put("wfStepAGRMemberIDs", wfStepAgrMemberIDs);
				
			}

			setMap.put("dimTypeID", "100001");
			List regionList = commonService.selectList("dim_SQL.getDimValueNameList", setMap);
			
			
			model.put("regionList", regionList);
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", request.getParameter("ProjectID"));
			
			Map getMap = commonService.select("wf_SQL.getWFInstanceDetail_gridList", setMap);
			model.put("getMap", getMap);

			if(getMap != null && !getMap.isEmpty())
				setMap.put("DocCategory", getMap.get("DocCategory"));

			if(wfDocType.equals("CSR")) {
				getPJTMap = commonService.select("project_SQL.getProjectInfo", setMap);
				backMessage = StringUtil.checkNull(labelMap.get("LN00203"));					
			}
			else if(wfDocType.equals("PJT")) {

				backFunction = "viewProjectInfo.do";	

				callbackData = "&changeSetID="+request.getParameter("changeSetID")+"&screenType=myPJT&pjtMode=R";
				getPJTMap = commonService.select("project_SQL.getProjectInfo", setMap);
				backMessage = StringUtil.checkNull(labelMap.get("LN00249"));
			}
			else if(wfDocType.equals("SR") || wfDocType.equals("SCR")) {
							
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
				
				setMap.put("srID", srID);
				getPJTMap = commonService.select("esm_SQL.getESMSRInfo", setMap);
				callbackData = "&srID="+request.getParameter("srID")+"&screenType=srRqst&srMode=mySR&blockSR="+request.getParameter("blockSR");
				backFunction = "processItsp.do";
				backMessage = StringUtil.checkNull(labelMap.get("LN00281"));
				
				String defWFID = StringUtil.checkNull(request.getParameter("defWFID"));
				if("".equals(defWFID)) defWFID = StringUtil.checkNull(getPJTMap.get("DefWFID"));
				
				setMap.put("WFID", defWFID);
				model.put("defWFID", defWFID);
				String url = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFURL", setMap));
				model.put("wfURL", url);
				
				Map setData = new HashMap();				
				String srRequestUserID = StringUtil.checkNull(request.getParameter("srRequestUserID"));
				setData.put("memberID", srRequestUserID);
				String srRequestUserInfo = commonService.selectString("user_SQL.getMemberTeamInfo", setData);
				
				model.put("srRequestUserInfo", srRequestUserInfo);	
				model.put("srRequestUserID", srRequestUserID);
				model.put("blockSR", request.getParameter("blockSR"));
				
				setData.put("languageID", languageID);
				setData.put("wfDocType",wfDocType);
				setData.put("wfID", defWFID);
				setData.put("docSubClass", StringUtil.checkNull(getPJTMap.get("SRType")));
				List wfAllocList = commonService.selectList("common_SQL.getMenuURLFromWF2_commonSelect", setData);
				if(wfAllocList.size() == 1 ){
					Map wfAllocInfo = (Map)wfAllocList.get(0);
					model.put("wfID", wfAllocInfo.get("CODE"));
					model.put("wfName", wfAllocInfo.get("NAME"));
					model.put("wfUrl", wfAllocInfo.get("WFURL"));
				}
				model.put("wfAllocListCNT", wfAllocList.size());
				
				String speCode = StringUtil.checkNull(request.getParameter("speCode"));
				String procRoleType = StringUtil.checkNull(request.getParameter("roleType"));
				model.put("speCode",speCode);
				model.put("procRoleType",procRoleType);
				
				if(wfDocType.equals("SCR")){
					String scrID = StringUtil.checkNull(request.getParameter("scrID"));
					setMap.put("scrID", scrID);
					setMap.put("languageID", languageID);			
					Map scrInfo = commonService.select("scr_SQL.getSCR_gridList", setMap);
					model.put("scrInfo", scrInfo);
				}
			}
			else if(wfDocType.equals("CS") && (isMulti.equals("N") || isMultiCnt.equals("1"))) {
				setMap.put("ProjectID", request.getParameter("ProjectID"));
				setMap.put("ChangeSetID", request.getParameter("changeSetID"));	
				setMap.put("s_itemID", request.getParameter("itemId"));				
				getPJTMap = commonService.select("wf_SQL.getChangeSetInfoWF", setMap);
				String description = StringUtil.checkNull(getPJTMap.get("Description"));
				getPJTMap.put("Description", description.replaceAll("(\r\n|\r|\n|\n\r)", "<br/>"));
				backFunction = "viewItemChangeInfo.do";
				callbackData = "&changeSetID="+request.getParameter("changeSetID")+"&screenMode=edit&StatusCode=MOD&isAuthorUser=&LanguageID="+commandMap.get("sessionCurrLangType");
				backMessage = StringUtil.checkNull(labelMap.get("LN00206"));
				setMap.put("itemTypeCode", getPJTMap.get("ItemTypeCode"));
				setMap.put("itemClassCode", getPJTMap.get("ItemClassCode"));
				String DefWFID = StringUtil.checkNull(commonService.selectString("wf_SQL.getDefWFIDForClassCode", setMap));
				
				model.put("defWFID", DefWFID);
			}				
			
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			setMap.put("s_itemID", request.getParameter("ProjectID"));
			model.put("getPJTMap", getPJTMap);
			
			Map setData = new HashMap();
			if(StringUtil.checkNull(getPJTMap.get("Status")).equals("APRV")){
				setData.put("ProjectID",request.getParameter("ProjectID"));
				setData.put("Status","CNG");
				commonService.update("project_SQL.updateProject",setData);
			}else if(StringUtil.checkNull(getPJTMap.get("Status")).equals("APRV2")){
				setData.put("ProjectID",request.getParameter("ProjectID"));
				setData.put("Status","QA");
				commonService.update("project_SQL.updateProject",setData);
			}
		
			model.put("regionList", regionList);
			model.put("regionList", regionList);
			model.put("getPJTMap", getPJTMap);
			model.put("agrCnt",wfStepInstAGRList.size());
			
			model.put("wfStep", wfStep);

			setMap.put("wfDocType", wfDocType);
			String wfDocName = commonService.selectString("wf_SQL.getWFDocTypeName", setMap);
			
			model.put("wfLabel",getLabel(request, commonService,"WFSTEP"));
			model.put("menu", labelMap);  // Label Setting 
			model.put("wfDocName", wfDocName);
			model.put("isNew", isNew);
			model.put("mainMenu", StringUtil.checkNull(request.getParameter("mainMenu"), "1"));
			model.put("ProjectID", projectID);
			model.put("wfDocType", wfDocType);
			model.put("docSubClass", docSubClass);
			model.put("backFunction", backFunction);
			model.put("backMessage", backMessage);
			model.put("callbackData", callbackData);
			model.put("currPage", StringUtil.checkNull(request.getParameter("currPage"), "1"));
			model.put("changeSetID", StringUtil.checkNull(request.getParameter("changeSetID")));
			model.put("s_itemID", StringUtil.checkNull(request.getParameter("s_itemID")));
			model.put("screenType", StringUtil.checkNull(request.getParameter("screenType")));
			model.put("fromSR", StringUtil.checkNull(request.getParameter("fromSR")));
			model.put("srID", StringUtil.checkNull(request.getParameter("srID")));
			model.put("newWFInstanceID", newWFInstanceID);
			//model.put("wfInstanceID", wfInstanceID);
			
			// Tree >> ITEM >> [개요] >> [변경 이력]
			model.put("seletedTreeId", StringUtil.checkNull(request.getParameter("seletedTreeId")));
			model.put("isItemInfo", StringUtil.checkNull(request.getParameter("isItemInfo")));

		} catch (Exception e) {
			System.out.println(e);
			throw new Exception("EM00001");
		}
		return model;
	}
	
	@RequestMapping(value="/mainWorkflowList.do")
	public String mainWorkflowList(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"));
			String wfMode = StringUtil.checkNull(request.getParameter("wfMode"));
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			String filter = "myWF";
			
			if(screenType != "csrDtl"){
				String actorID = StringUtil.checkNull(cmmMap.get("sessionUserId"));
				setMap.put("actorID", actorID);
			}
			
			if(wfMode == "REC") {
		        LocalDate now = LocalDate.now();
		        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
		        String toDate = now.format(formatter);
		        LocalDate oldDate = now.minusMonths(3);
		        String fromDate = oldDate.format(formatter);
				String period = "1";

				setMap.put("period", period);
				setMap.put("beforeYmd", fromDate);
				setMap.put("thisYmd", toDate);				
			}
			
			setMap.put("languageID", languageID);
			setMap.put("wfMode", wfMode);
			setMap.put("screenType", screenType);
			setMap.put("filter", filter);

	        List mainWFList = commonService.selectList("wf_SQL.getWFInstList_gridList", setMap);
	        JSONArray gridData = new JSONArray(mainWFList);
	        model.put("gridData",gridData);	
			model.put("wfMode", wfMode);	
			model.put("screenType", screenType);	
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		
		return nextUrl("/hom/main/wf/mainWorkflowList");
	}
	
	@RequestMapping(value="/mainWFInstList.do")
	public String mainWorkflowList2(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		try {
			HashMap setData = new HashMap();
			int listSize = Integer.parseInt(request.getParameter("listSize"));
			String wfMode = StringUtil.checkNull(request.getParameter("wfMode"));
			String screenType = StringUtil.checkNull(request.getParameter("screenType"));
			String loginID = String.valueOf(cmmMap.get("sessionUserId"));
			String languageID = String.valueOf(cmmMap.get("sessionCurrLangType"));
			
			if(!screenType.equals("csrDtl")) {
				setData.put("actorID", loginID);
			}
			setData.put("wfMode", wfMode);
			setData.put("filter", "myWF");
			setData.put("languageID", languageID);
			List workflowList = (List)commonService.selectList("wf_SQL.getWFInstList_gridList", setData);
			
			model.put("wfMode", wfMode);	
			model.put("screenType", screenType);	
			model.put("menu", getLabel(request, commonService));	
			model.put("workflowList", workflowList);	
			model.put("listSize", listSize);	
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/hom/main/wf/mainWFInstList");
	}
	
	// 외부(EMail)에서 srAprvDetail 화면 호출 
	@RequestMapping(value = "/srAprvDetailEmail.do")
	public String srAprvDetailEmail(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		String url = "/wf/srAprvDetailEmail";		
		try {				
				String languageID = StringUtil.checkNull(request.getParameter("languageID")); 
				String projectID = StringUtil.checkNull(request.getParameter("projectID")); 
				String isPop = StringUtil.checkNull(request.getParameter("isPop")); 
				String isMulti = StringUtil.checkNull(request.getParameter("isMulti")); 
				String actionType = StringUtil.checkNull(request.getParameter("actionType")); 
				String stepInstID = StringUtil.checkNull(request.getParameter("stepInstID")); 
				String actorID = StringUtil.checkNull(request.getParameter("actorID")); 
				String stepSeq = StringUtil.checkNull(request.getParameter("stepSeq")); 
				String wfInstanceID = StringUtil.checkNull(request.getParameter("wfInstanceID")); 
				String wfID = StringUtil.checkNull(request.getParameter("wfID")); 
				String documentID = StringUtil.checkNull(request.getParameter("documentID")); 
				String srID = StringUtil.checkNull(request.getParameter("srID"));
				String lastSeq = StringUtil.checkNull(request.getParameter("lastSeq"));
				String docCategory = StringUtil.checkNull(request.getParameter("docCategory"));
				String wfMode = StringUtil.checkNull(request.getParameter("wfMode"));
				String aprvMode = StringUtil.checkNull(request.getParameter("aprvMode"));
				
				cmmMap.put("userID", StringUtil.checkNull(request.getParameter("actorID"))); 
				String loginID = StringUtil.checkNull(commonService.selectString("sr_SQL.getLoginID", cmmMap));
				
				Map setData = new HashMap();	
				setData.put("wfInstanceID", wfInstanceID);
				setData.put("stepInstID", stepInstID);
				setData.put("LanguageID", languageID);
				Map stepInstInfo = commonService.select("wf_SQL.getWFStepInstInfoList", setData);
			
				String stepInstStatus = "";
				if(!stepInstInfo.isEmpty()){
					stepInstStatus = StringUtil.checkNull(stepInstInfo.get("Status"));
				}
				String msg = MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00165");
				
				model.put("stepInstStatus", stepInstStatus);
				model.put("msg", msg);
				model.put("srID", srID );
				model.put("userID", loginID );
				model.put("languageID", languageID);

				model.put("projectID", projectID );
				model.put("isPop", isPop );
				model.put("isMulti", isMulti );
				model.put("actionType", actionType );
				model.put("stepInstID", stepInstID );
				model.put("actorID", actorID );
				model.put("stepSeq", stepSeq );
				model.put("wfInstanceID", wfInstanceID );
				model.put("wfID", wfID );
				model.put("documentID", documentID );
				model.put("srID", srID );
				model.put("lastSeq", lastSeq );
				model.put("docCategory", docCategory );
				model.put("wfMode", wfMode );
				model.put("aprvMode", aprvMode);
				model.put("menu", getLabel(request, commonService)); //  Label Setting 		
				
				
				System.out.println(" ## srAprvDetailEmail :"+url+":actorID:"+actorID);
		} catch (Exception e) {
			System.out.println(e);
		}
		return nextUrl(url);
	}
	
	@RequestMapping(value="/getWFDescription.do") 
	public String getWFDescription(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception { 
		Map target = new HashMap();	 
		try{ 			 
			String wfID = StringUtil.checkNull(cmmMap.get("wfID")); 
			String category = StringUtil.checkNull(cmmMap.get("category")); 
			Map setData = new HashMap(); 
			setData.put("languageID", cmmMap.get("sessionCurrLangType")); 
			setData.put("typeCode", wfID);
			setData.put("category", category);
			String wfDescription = StringUtil.checkNull(commonService.selectString("common_SQL.getDictionaryDescription", setData)); 
			 
			target.put(AJAX_SCRIPT, "fnSetWFDescription('"+wfDescription+"')"); 
		} catch (Exception e) { 
			System.out.println(e); 
			throw new ExceptionUtil(e.toString()); 
		} 
		 
		model.addAttribute(AJAX_RESULTMAP,target); 
		return nextUrl(AJAXPAGE); 
	}
	

	@RequestMapping(value = "/reviewItemList.do")
	public String reviewItemList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {
		Map setMap = new HashMap();
		try {
				String wfMode = StringUtil.checkNull(commandMap.get("wfMode"));
				String wfStepID = StringUtil.checkNull(commandMap.get("wfStepID"));
				String projectID = StringUtil.checkNull(commandMap.get("projectID"));
				String screenType = StringUtil.checkNull(commandMap.get("screenType"));
				String s_itemID = StringUtil.checkNull(commandMap.get("s_itemID"));
				String filter = StringUtil.checkNull(commandMap.get("filter"),"myWF");
				String pathSql = StringUtil.checkNull(commandMap.get("pathSql"));
				
				
				model.put("menu", getLabel(request, commonService)); /*Label Setting*/	
				String menuNum = "";
				String title ="";
				if(wfMode.equals("AREQ")){
					title = StringUtil.checkNull(getLabel(request, commonService).get("LN00211"));
				}else if(wfMode.equals("CurAprv")){
					title = StringUtil.checkNull(getLabel(request, commonService).get("LN00243"));
				}else if(wfMode.equals("ToDoAprv")){
					title = StringUtil.checkNull(getLabel(request, commonService).get("LN00244"));
				}else if(wfMode.equals("RefMgt")){
					title = StringUtil.checkNull(getLabel(request, commonService).get("LN00245"));
				}else if(wfMode.equals("Cls")){
					title = StringUtil.checkNull(getLabel(request, commonService).get("LN00118"));
				}
				
				Calendar cal = Calendar.getInstance();
				cal.setTime(new Date(System.currentTimeMillis()));
				String thisYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
				//cal.add(Calendar.MONTH, -3);
				cal.add(Calendar.DATE, -7);
				String beforeYmd = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

				setMap.put("DocCategory", "CS");
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
				String wfURL = StringUtil.checkNull(commonService.selectString("wf_SQL.getWFCategoryURL", setMap));
				
				model.put("wfURL", wfURL);
				model.put("beforeYmd", beforeYmd);
				model.put("thisYmd", thisYmd);
				model.put("wfStepID", wfStepID);
				model.put("title", title);
				model.put("wfMode", wfMode);
				model.put("projectID", projectID);
				model.put("screenType", screenType);
				model.put("filter", filter);
				model.put("s_itemID", s_itemID);
				model.put("wfInstanceID", StringUtil.checkNull(request.getParameter("wfInstanceID"),""));
				model.put("pathSql", pathSql);
				
				String wfInstanceID = StringUtil.checkNull(request.getParameter("wfInstanceID"),"");
				Map wfInfoMap = new HashMap();
				if(!wfInstanceID.equals("")){
					setMap.put("wfInstanceID", wfInstanceID);
					setMap.put("filter", filter);
					setMap.put("actorID", StringUtil.checkNull(commandMap.get("sessionUserId")));
					wfInfoMap = (Map)commonService.select("wf_SQL.getWFInstList_gridList", setMap);
					model.put("wfInfoMap", wfInfoMap);
				}

			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/wf/reviewItemList");
	}


	public static HashMap wfPathMgt(ModelMap model, HashMap commandMap, HttpServletRequest request) throws Exception { 
		String returnValue = "";
		String className = "xbolt.wf.web.WfPathActionController";
		Object returnVal = null;
		HashMap returnMap = new HashMap();
		try {
			Class classInfo = Class.forName(className);
			Object obj = classInfo.newInstance();
			String funcType = StringUtil.checkNull(commandMap.get("funcType"));
			
			if(!"".equals(funcType)) {
		        Method methods = obj.getClass().getMethod(funcType,new Class[]{HashMap.class});
				
		        returnMap = (HashMap) methods.invoke(obj,commandMap);	       
			}
        } catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		return returnMap;
	}
	
	@RequestMapping(value="/custom/sendWFAlarmMail.do")
	public void sendWFAlarmMail (Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		try{
			
			Map setMap = new HashMap();
			Map temp = new HashMap();
			
			HashMap setMailData = new HashMap(); // 메일 데이터
			HashMap remindMap = new HashMap(); // 리마인드 맵 (수신자 별)
			List remindList = new ArrayList(); // 리마인드 리스트 (수신자 별)
			List sendMailList = new ArrayList(); // 미상신 + 미승인 메일 보내기용
			Map mailFormMap = new HashMap(); // 이메일폼
			
			String preUser = "";
			String nowUser = "";
			String alarmMailType = "";
			String LanguageID = StringUtil.checkNull(cmmMap.get("sessionCurrLangType"),GlobalVal.DEFAULT_LANGUAGE);
			String DefLanguageID = "";
			String emailHTMLForm = "";
			String delayDate = "30";
		
			System.out.println("start sendWFAlarmMail");
			
			// 결재미상신 및 결재미승인
			setMap.put("LanguageID", LanguageID);
			//setMap.put("itemTypeCode", "'OJ00001', 'OJ00005'"); // 아이템 타입 제한할 때 사용
			setMap.put("delayDate", delayDate);
			
			List remindWorkList = commonService.selectList("wf_SQL.getCSAprqDelayList", setMap);
			for(int i = 0 ; i < remindWorkList.size(); i++){
				
				temp = (Map)remindWorkList.get(i);
					
				// 전 수신자 & 현 수신자 설정 
				if (preUser == "" && "".equals(preUser)) preUser = StringUtil.checkNull(temp.get("ReceiverID"));
				nowUser = temp.get("ReceiverID").toString();
				
				// 수신자별 메일송신
				if(!nowUser.equals(preUser)) {
					setMailData = setMail(preUser,remindList,DefLanguageID,emailHTMLForm,delayDate);
					sendMail(setMailData, request, session, DefLanguageID);
					// 초기화
					remindList = new ArrayList();
					setMailData = new HashMap();
					mailFormMap = new HashMap();
				}
				
				remindMap = new HashMap();
				remindMap.put("alarmMailType", StringUtil.checkNull(temp.get("alarmMailType")));
				remindMap.put("Version", StringUtil.checkNull(temp.get("Version")));  //ID
				remindMap.put("Identifier",StringUtil.checkNull(temp.get("Identifier")));  //ID
				remindMap.put("ItemName",StringUtil.checkNull(temp.get("ItemName")));  //명칭
				remindMap.put("AuthorName",StringUtil.checkNull(temp.get("AuthorName")));  //담당자
				remindMap.put("ChangeType",StringUtil.checkNull(temp.get("ChangeType")));  //변경구분
				remindMap.put("CreationTime",StringUtil.checkNull(temp.get("CreationTime")));  //상신일
				remindMap.put("CompletionDT",StringUtil.checkNull(temp.get("CompletionDT")));  //변경완료일
				remindMap.put("delayDate",StringUtil.checkNull(temp.get("delayDate")));  //경과일
				remindList.add(remindMap);
				
				// lang setting
				DefLanguageID =  StringUtil.checkNull(temp.get("DefLanguageID"));
				// email form
				mailFormMap.put("emailCode", "WFARLM");
				mailFormMap.put("languageID", DefLanguageID);
				emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", mailFormMap));
				
				
				preUser = nowUser;
				
				if(i == remindWorkList.size()-1){
					// 이메일 폼
					mailFormMap.put("emailCode", "WFARLM");
					mailFormMap.put("languageID", StringUtil.checkNull(temp.get("DefLanguageID")));
					emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", mailFormMap));
					
					setMailData = setMail(preUser,remindList,DefLanguageID,emailHTMLForm,delayDate);
					sendMail(setMailData, request, session, DefLanguageID);
					// 초기화
					remindList = new ArrayList();
					setMailData = new HashMap();
					mailFormMap = new HashMap();
				}
			}
			
			session.removeAttribute("loginInfo");
			System.out.println("end sendWFAlarmMail");
		}catch (Exception e) {
			System.out.println(e); 
			throw new ExceptionUtil(e.toString()); 
		}
	}
	
	public static HashMap setMail (String preUser, List remindList, String LanguageID, String emailHTMLForm, String delayDate) throws Exception{
		
		HashMap setMailData = new HashMap();
		HashMap receiverMap = new HashMap();
		List receiverList = new ArrayList();
		
		// 수신자 셋팅
		receiverMap.put("receiptUserID", preUser);  
		receiverList.add(receiverMap);	
		setMailData.put("receiverList", receiverList);
		// 데이터 셋팅
		setMailData.put("emailCode", "WFARLM");
		setMailData.put("LanguageID", LanguageID);
		setMailData.put("remindList",remindList);
		setMailData.put("subject", "");
		setMailData.put("emailHTMLForm",emailHTMLForm);
		setMailData.put("delayDate",delayDate);
		
		return setMailData;
	}
	
	public void sendMail (HashMap setMailData, HttpServletRequest request,  HttpSession session, String LanguageID) throws Exception {
		
			HashMap mailMap = new HashMap();
			Map resultMailMap = new HashMap();
			
			// 보내는이 정보 관리자로 셋팅
			session.removeAttribute("loginInfo");
			Map loginInfo = new HashMap();
			loginInfo.put("sessionUserId","1");
			loginInfo.put("sessionCurrLangType",LanguageID);
	        session.setAttribute("loginInfo",loginInfo);
			
			Map setMailMap = (Map)setEmailLog(request, commonService, setMailData, StringUtil.checkNull(setMailData.get("emailCode")));
			if(StringUtil.checkNull(setMailMap.get("type")).equals("SUCESS")){
				mailMap = (HashMap)setMailMap.get("mailLog");
				resultMailMap = EmailUtil.sendMail(mailMap,setMailData,getLabel(request, commonService));
				System.out.println("SEND EMAIL TYPE:"+resultMailMap+", Msg:"+StringUtil.checkNull(setMailMap.get("type")));
			}else{
				System.out.println("SAVE EMAIL_LOG FAILE/DONT Msg : "+StringUtil.checkNull(setMailMap.get("msg")));
			}
	}
	
	
}
