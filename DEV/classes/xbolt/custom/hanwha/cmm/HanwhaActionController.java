package xbolt.custom.hanwha.cmm;

import hanwha.neo.slo.SLODecrypt4AES;

import java.io.File;
import java.io.FileOutputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.NamingException;
import javax.naming.ldap.InitialLdapContext;
import javax.naming.ldap.LdapContext;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.session.SqlSession;
import org.aspectj.util.LangUtil.StringChecker;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import xbolt.cmm.controller.XboltController;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.MakeEmailContents;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.service.CommonService;
import xbolt.custom.hanwha.org.neo.branch.ss.org.service.NeoOrgWsProxy;
import xbolt.custom.hanwha.org.neo.branch.ss.org.vo.OrgUserVO;
import xbolt.custom.hanwha.slo.neo.branch.common.sso.service.*;
import xbolt.custom.hanwha.val.HanwhaGlobalVal;
import xbolt.wf.web.WfActionController;
import xbolt.custom.hanwha.adrm.ws.service.AdrmWebServiceProxy;
import xbolt.custom.hanwha.adrm.ws.service.WsApprStepVO;
import xbolt.custom.hanwha.adrm.ws.service.WsApprUserVO;
import xbolt.custom.hanwha.adrm.ws.service.WsRuleParamVO;
import xbolt.custom.hanwha.adrm.ws.service.WsRuleParamVOFactorMapEntry;
import xbolt.custom.hanwha.adrm.ws.service.WsRuleResultVO;
import xbolt.custom.hanwha.aprv.neo.branch.ss.approval.axisws.*;
import xbolt.aprv.ApprovalBatch;


/**
 * @Class Name : LfController.java
 * @Description : LfController.java
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2015. 12. 17. smartfactory		최초생성
 *
 * @since 2015. 12. 17.
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class HanwhaActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());

	@Resource(name = "commonService")
	private CommonService commonService;

	private WfActionController wfActionController;
	
	private MakeEmailContents MakeEmailContents;
	
	@RequestMapping(value="/hanwha/loginhanwhaForm.do")
	public String loginhanwhaForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
	  model=setLoginScrnInfo(model,cmmMap);
	  model.put("screenType", cmmMap.get("screenType"));
	  model.put("mainType", cmmMap.get("mainType"));
	  model.put("srID", cmmMap.get("srID"));
	  model.put("sysCode", cmmMap.get("sysCode"));
	  model.put("proposal", cmmMap.get("proposal"));
	  model.put("status", cmmMap.get("status"));
	  model.put("fileID", cmmMap.get("fileID"));
	  return nextUrl(GlobalVal.HTML_LOGIN_PAGE);
	}
		
	@RequestMapping(value="/hanwha/loginhanwha.do")
	public String loginhanwha(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {
				HttpSession session = request.getSession(true);
				Map resultMap = new HashMap();
				String langCode = GlobalVal.DEFAULT_LANG_CODE;	
				String languageID = StringUtil.checkNull(cmmMap.get("LANGUAGE"),StringUtil.checkNull(cmmMap.get("LANGUAGEID")) );
				if(languageID.equals("")){
					languageID = GlobalVal.DEFAULT_LANGUAGE;
				}
			
				cmmMap.put("LANGUAGE", languageID);
				String ref = request.getHeader("referer");
				String protocol = request.isSecure() ? "https://" : "http://";
				
				String IS_CHECK = GlobalVal.PWD_CHECK;
				String url_CHECK = StringUtil.chkURL(ref, protocol);

				if("".equals(IS_CHECK))
					IS_CHECK = "Y";
				
				
				if("".equals(url_CHECK)) {
					resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
					resultMap.put(AJAX_ALERT, "Your ID does not exist in our system. Please contact system administrator(CJWISE).");
				}
				else {
	
					Map idInfo = new HashMap();
					
					if("Y".equals(IS_CHECK) && "login".equals(url_CHECK)) {
						cmmMap.put("IS_CHECK", "Y");
					}
					else {
						cmmMap.put("IS_CHECK", "N");
					}
					
					idInfo = commonService.select("login_SQL.login_id_select", cmmMap);
				
					if(idInfo == null || idInfo.size() == 0) {
						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
						//resultMap.put(AJAX_ALERT, "해당아이디가 존재하지 않습니다.");
						resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));				
					}
					else {
						cmmMap.put("LOGIN_ID", idInfo.get("LoginId")); // parameter LOGIN_ID 는 사번이므로 조회한 LOGINID로 put
						Map loginInfo = commonService.select("login_SQL.login_select", cmmMap);
						if(loginInfo == null || loginInfo.size() == 0) {
							resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
							//resultMap.put(AJAX_ALERT, "System에 해당 사용자 정보가 없습니다.등록 요청바랍니다.");
							resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00102"));					
						}
						else {
							// [Authority] < 4 인 경우, 수정가능하게 변경
							if(loginInfo.get("sessionAuthLev").toString().compareTo("4") < 0)	loginInfo.put("loginType", "editor");
							else	loginInfo.put("loginType", "viewer");	
							resultMap.put(AJAX_SCRIPT, "parent.fnReload('Y')");
							//resultMap.put(AJAX_MESSAGE, "Login성공");					
							session.setAttribute("loginInfo", loginInfo);
						}
					}
					model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 구분
					model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
				    model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType")));
				    model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
				    model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));
					model.addAttribute(AJAX_RESULTMAP,resultMap);
				}
		}
		catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("LoginActionController::loginbase::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}
	
	private ModelMap setLoginScrnInfo(ModelMap model,HashMap cmmMap) throws Exception {
		  
	  String pass = StringUtil.checkNull(cmmMap.get("pwd"));
	  model.addAttribute("loginid",StringUtil.checkNull(cmmMap.get("loginid"), ""));
	  model.addAttribute("pwd",pass);
	  model.addAttribute("lng",StringUtil.checkNull(cmmMap.get("lng"), ""));
	  
	  if(_log.isInfoEnabled()){_log.info("setLoginScrnInfo : loginid="+StringUtil.checkNull(cmmMap.get("loginid"))+",pass"+URLEncoder.encode(pass)+",lng="+StringUtil.checkNull(cmmMap.get("lng")));}		  
	  List langList = commonService.selectList("common_SQL.langType_commonSelect", cmmMap);
	  if( langList!=null &&langList.size() > 0){
		  for(int i=0; i<langList.size();i++){
			  Map langInfo = (HashMap) langList.get(i);
			  if(langInfo.get("IsDefault").equals("1")){
				  model.put("langType", StringUtil.checkNull(langInfo.get("CODE"),""));
				  model.put("langName", StringUtil.checkNull(langInfo.get("NAME"),""));
			  }
		  }
	  }else{model.put("langType", "");model.put("langName", "");}
	  model.put("langList", langList);
	  model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 구분
	  return model;
 	}
	
	/**
	 * [결재요청] submitApproval
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/submitApproval.do")
	public String submitApproval(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		String strApprPath="";
		try {
			HashMap setMap = new HashMap();
			HashMap updateData = new HashMap();
			HashMap updateCRData = new HashMap();
			String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));
			String selectedWfId = StringUtil.checkNull(request.getParameter("workflowId"));
			String aprvOption = StringUtil.checkNull(request.getParameter("aprvOption"));
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String fromSR = StringUtil.checkNull(request.getParameter("fromSR"));
			
			String olmWfId = "WF000";
			String loginUserid = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String status = "0"; // 초기 설정 값 (0 = 상신)
			String employeeNo = StringUtil.checkNull(cmmMap.get("sessionEmployeeNm"));//사번
			setMap.put("s_itemID", projectID);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
			Map projectInfoMap = commonService.select("project_SQL.getProjectInfo", setMap);
		
			
			WsRuleParamVOFactorMapEntry[] factorMap = null;		
			
			//------------------------------------------------
			//결재선WebService를 이용하여 결재자 정보를 조회			
			
			WsRuleParamVO wsRuleParam = new WsRuleParamVO();
			wsRuleParam.setAdrmWsKey(HanwhaGlobalVal.HW_ADRM_WS_KEY);
			//wsRuleParam.setServiceCode(HanwhaGlobalVal.HW_ADRM_SERVICE_CODE);  // XBOLTADM.TB_WF . ServiseCode
			
			if(!"".equals(srID)) {
				
				setMap.put("srID", srID);
				String defWFID = StringUtil.checkNull(commonService.selectString("sr_SQL.getSRDefWFID", setMap));
				setMap.put("teamID", cmmMap.get("sessionTeamId"));
		            
		        String teamCode = StringUtil.checkNull(commonService.selectString("organization_SQL.getTeamCode", setMap));
		       		
				if(!"".equals(defWFID)) {
					setMap.put("WFID", defWFID);
					setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
					Map wfInfoMap = commonService.select("wf_SQL.getWfList", setMap);
					
					factorMap = new WsRuleParamVOFactorMapEntry[2];		
					
		            factorMap[0] = new WsRuleParamVOFactorMapEntry();
		            factorMap[0].setKey("PrimeWorkflowID");	// 팩터 코드
		            factorMap[0].setValue(defWFID);		// 비교 값
		            
		            factorMap[1] = new WsRuleParamVOFactorMapEntry();
		            factorMap[1].setKey("DrafterDeptCode");	// 팩터 코드
		            factorMap[1].setValue(teamCode);
		            
		            if(wfInfoMap != null) {
		            	wsRuleParam.setServiceCode(StringUtil.checkNull(wfInfoMap.get("ServiceCode")));	            	
		            }
		            else {
		            	wsRuleParam.setServiceCode(HanwhaGlobalVal.HW_ADRM_SERVICE_CODE);
		            }
				}
				else {					
		            factorMap = new WsRuleParamVOFactorMapEntry[1];									            
		            factorMap[0] = new WsRuleParamVOFactorMapEntry();
		            factorMap[0].setKey("DrafterDeptCode");	// 팩터 코드
		            factorMap[0].setValue(teamCode);	
		            wsRuleParam.setServiceCode(HanwhaGlobalVal.HW_ADRM_SERVICE_CODE);            
				}
			}
			else {
				factorMap = new WsRuleParamVOFactorMapEntry[0];	
				wsRuleParam.setServiceCode(HanwhaGlobalVal.HW_ADRM_SERVICE_CODE);				
			}
					
			String ADRMemployeeNo =  getEmployeeNo(employeeNo);	  
			wsRuleParam.setDraftEmpNo(ADRMemployeeNo);			 
			wsRuleParam.setFactorMap(factorMap);			
		    
			AdrmWebServiceProxy adrmProxy = new AdrmWebServiceProxy();
			WsRuleResultVO wsRuleResult = adrmProxy.getApprovalLine(wsRuleParam);
			String ruleResult = StringUtil.checkNull(wsRuleResult.getResultCode());
			String ruleResultError = StringUtil.checkNull(wsRuleResult.getErrorMessage());
			strApprPath = wsRuleResult.getPathName();
		
			//------------------------------------------------
			
			if(ruleResult.equals("0")){//결재선정보가 있음			
				//1.Search Info about [TB_WF_INST] 
				String maxWFInstanceID = commonService.selectString("wf_SQL.MaxWFInstanceID", setMap);
				String OLM_SERVER_NAME = GlobalVal.OLM_SERVER_NAME;
				int svnmLength = OLM_SERVER_NAME.length();
				System.out.println("svnmLength :"+svnmLength);
				int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(svnmLength));
				int maxcode = maxWFInstanceID2 + 1;
				String WFInstanceID = OLM_SERVER_NAME + String.format("%010d", maxcode);
				String WFID = StringUtil.checkNull(projectInfoMap.get("WFID"));
				
				//2. Search Approval User Infos
				String currentTime = DateUtil.getCurrentTime("yyyyMMddHHmmss");
				
				//2.1 상신자 정보 확인 : ReceiverInfo
				NeoOrgWsProxy orgProxy = new NeoOrgWsProxy();
				OrgUserVO[] orgUsers = orgProxy.searchGroupUserByEmpolyeeNo(employeeNo);
				if(_log.isInfoEnabled()){_log.info("HanwhaActionController::submitApproval::INFO_1::orgProxy SUCCESS :: orgUsers Size="+orgUsers.length);}
				if(orgUsers.length >0){
					OrgUserVO orgUser = orgUsers[0];
					
					ReceiverInfo[] receiverInfos = new ReceiverInfo[2];
					receiverInfos[0] = new ReceiverInfo();
					
					receiverInfos[0].setRoleType("Reciver"); // 권한 타입 (referer:참조처, receiver:수신처)
					//receiverInfos[0].setDeptType(false); // 수신처 타입 부서 여부 (true : 부서, false : 사용자, default : false)
					//receiverInfos[0].setIncludeChild(false); // 하위부서 포함 여부 (true : 하위 부서 포함, false : 하위부서 포함 안함, default : false)
					receiverInfos[0].setForwardable(true); // 전달 허용 여부 (true : 허용, false : 비허용, default : false)
					//receiverInfos[0].setReceiverKey(orgUser.getUserKey()); // 수신자 EagleOffice의 userKey	(호출함수의 suffix 가 ~UseUserId 가 아닌 경우 필수 입력)
					receiverInfos[0].setReceiverId(orgUser.getUserId()); // 수신처	isDeptType=false 일 때 EagleOffice의 userId 	isDeptType=true 일 때 EagleOffice의 deptId (호출함수의 suffix 가 ~UseUserId 인 경우 필수 입력)
					receiverInfos[0].setReceiverName(orgUser.getUserName()); // 수신처명 ( 상황 조회 시 결과 값 isDeptType=false 일 때 사용자 명, isDeptType=true 일 때 부서명 )
					receiverInfos[0].setCompanyId(orgUser.getCompanyId());
					receiverInfos[0].setCompanyName(orgUser.getCompanyName());
					receiverInfos[0].setDeptId(orgUser.getDeptId()); 
					receiverInfos[0].setDeptName(orgUser.getDeptName());
					receiverInfos[0].setFunctionId(orgUser.getJobFunctionId()); // 직책 ID
					receiverInfos[0].setFunctionName(orgUser.getJobFunctionName());
					receiverInfos[0].setEmailAddr(orgUser.getEmail());
					
					//2.2 결재자 정보 : SignerInfo
					WsApprStepVO[] apprSteps = wsRuleResult.getSteps();
					int signerCnt=0;	
					for(int i=0; i< apprSteps.length; i++){
						WsApprStepVO apprStep = apprSteps[i];
						WsApprUserVO[] apprUsers = apprStep.getUsers();
						signerCnt = signerCnt+apprUsers.length;
						
					}
					if(_log.isInfoEnabled()){_log.info("HanwhaActionController::submitApproval::INFO_2::adrmProxy SUCCESS :: signerCnt Size="+signerCnt);}
					//2.2.1 결재자 정보 : receiverInfo를 상신자 정보 추가
					//---------------------------------
					//20160526 receiverInfo를 상신자 정보 추가
					SignerInfo[] signerInfos = new SignerInfo[signerCnt+1];	//20160526 receiverInfo 추가//20160711 SignerInfo에 SR요청자 정보를 추가
					signerInfos[0] = new SignerInfo();	
					signerInfos[0].setAssignType(0); // 참여자 형태( 0:기안, 1:결재, 2:협조결재, 9:결재참조 )
					signerInfos[0].setStatus(0); //결재자 상태( 상황 조회 시 결과 값,0 : 미결, 1 : 승인, 2: 반려, 3 : 전결, default : 0 )
					signerInfos[0].setSequence(0); // 결재순번	( 병렬인 경우 반드시 동일한 순번을 가져야 하며 상신자의 결재순번은 반드시 0이 되어야 한다. 결재 및 협조의 순번은 반드시 1이상 이어야 한다. )
					signerInfos[0].setNotEditable(true);
					signerInfos[0].setNotRemovable(false);
					signerInfos[0].setEndDate(currentTime); //결재문서 처리 시간 ( 상황 조회 시 결과 값, YYYYMMDDHH24MISS )
					signerInfos[0].setArbitrary(true); // 전결 권한 ( true : 전결 가능, false : 전결 불가, default : false )
					signerInfos[0].setStdDate(currentTime); // 결재 문서 도착 시간	( 상황 조회 시 결과 값, YYYYMMDDHH24MISS )
					signerInfos[0].setComment(""); // 결재 의견
					signerInfos[0].setUserId(receiverInfos[0].getReceiverId()); 
					signerInfos[0].setUserName(receiverInfos[0].getReceiverName());	//
					signerInfos[0].setDeptName(receiverInfos[0].getDeptName());	//부서명
					signerInfos[0].setFunctionName(receiverInfos[0].getFunctionName());	//직급명	
					
					String signers = strApprPath + "(" + receiverInfos[0].getReceiverName() + ",";				
					String lastSignerLoginID ="" ;
					
					//------------------------------------------------
					////20160707 SignerInfo에 SR요청자 정보를 상신자 다음으로 추가
					//2.2.2. Search RequestUserID Info about [TB_SR_MST] 
				
					setMap.put("SR_ID", srID);
					employeeNo = commonService.selectString("sr_SQL.getSRReqEmployeeNo", setMap);
					//2.2.2.1 요청자 정보 확인 : signerInfos
					orgProxy = new NeoOrgWsProxy();
					OrgUserVO[] reqUsers = null;
					try{
						reqUsers = orgProxy.searchGroupUserByEmpolyeeNo(employeeNo);
					}catch(Exception ex){
						System.out.println(ex);
						reqUsers = null;
					}
					
					if(_log.isInfoEnabled()){_log.info("HanwhaActionController::submitApproval::INFO_3::orgProxy SUCCESS :: reqUsers Size="+reqUsers.length);}
					
					receiverInfos[1] = new ReceiverInfo();
					if(reqUsers.length >0 && reqUsers != null){									
						
						OrgUserVO reqUser = reqUsers[0];							
						receiverInfos[1].setRoleType("referer"); // 권한 타입 (referer:참조처, receiver:수신처)						
						receiverInfos[1].setForwardable(true); // 전달 허용 여부 (true : 허용, false : 비허용, default : false)
						//receiverInfos[0].setReceiverKey(orgUser.getUserKey()); // 수신자 EagleOffice의 userKey	(호출함수의 suffix 가 ~UseUserId 가 아닌 경우 필수 입력)
						receiverInfos[1].setReceiverId(reqUser.getUserId()); // 수신처	isDeptType=false 일 때 EagleOffice의 userId 	isDeptType=true 일 때 EagleOffice의 deptId (호출함수의 suffix 가 ~UseUserId 인 경우 필수 입력)
						receiverInfos[1].setReceiverName(reqUser.getUserName()); // 수신처명 ( 상황 조회 시 결과 값 isDeptType=false 일 때 사용자 명, isDeptType=true 일 때 부서명 )
						receiverInfos[1].setCompanyId(reqUser.getCompanyId());
						receiverInfos[1].setCompanyName(reqUser.getCompanyName());
						receiverInfos[1].setDeptId(reqUser.getDeptId()); 
						receiverInfos[1].setDeptName(reqUser.getDeptName());
						receiverInfos[1].setFunctionId(reqUser.getJobFunctionId()); // 직책 ID
						receiverInfos[1].setFunctionName(reqUser.getJobFunctionName());
						receiverInfos[1].setEmailAddr(reqUser.getEmail());
					}								
						
					
					int k=1;	
					
					for(int i=0; i< apprSteps.length; i++){
				
						WsApprStepVO apprStep = apprSteps[i];
						WsApprUserVO[] apprUsers = apprStep.getUsers();
						int changeOption = apprStep.getChangeOption();//0:수정불가, 1:수정가능, 2:삭제가능
						
						for(int j=0; j< apprUsers.length; j++){
							WsApprUserVO apprUser = apprUsers[j];
							
							signerInfos[k] = new SignerInfo();	
							signerInfos[k].setAssignType(1); // 참여자 형태( 0:기안, 1:결재, 2:협조결재, 9:결재참조 )
							signerInfos[k].setStatus(0); //결재자 상태( 상황 조회 시 결과 값,0 : 미결, 1 : 승인, 2: 반려, 3 : 전결, default : 0 )
							signerInfos[k].setSequence(k); // 결재순번	( 병렬인 경우 반드시 동일한 순번을 가져야 하며 상신자의 결재순번은 반드시 0이 되어야 한다. 결재 및 협조의 순번은 반드시 1이상 이어야 한다. )
							//signerInfos[k].setDelegeted(false); // 대리결재자 여부( true : 대리 결재, false : 원결재자 결재, default : false )
							//signerInfos[k].setNotRemovable(false); // 결재선상 삭제 불가능 여부 ( true : 삭제 불가능, false : 삭제 가능, default : false )
							//signerInfos[k].setNotEditable(false); // 결재선상 참여자 형태 수정 불가능 여부 	( true : 수정 불가능, false : 수정 가능, default : false )
							if(changeOption==0){signerInfos[k].setNotEditable(true);}
							else if(changeOption==1){signerInfos[k].setNotEditable(false);}
							else if(changeOption==2){signerInfos[k].setNotRemovable(false);}
							signerInfos[k].setEndDate(currentTime); //결재문서 처리 시간 ( 상황 조회 시 결과 값, YYYYMMDDHH24MISS )
							signerInfos[k].setArbitrary(true); // 전결 권한 ( true : 전결 가능, false : 전결 불가, default : false )
							signerInfos[k].setStdDate(currentTime); // 결재 문서 도착 시간	( 상황 조회 시 결과 값, YYYYMMDDHH24MISS )
							signerInfos[k].setComment(""); // 결재 의견
							
						//	signerInfos[k].setUserkey(apprUser.getUserId()); // EagleOffice의 userKey (호출함수의 suffix 가 ~UseUserId 가 아닌 경우 필수 입력)
							signerInfos[k].setUserId(apprUser.getLoginId()); 
							signerInfos[k].setUserName(apprUser.getUserName());
							signerInfos[k].setDeptName(apprUser.getDeptName());
							signerInfos[k].setFunctionName(apprUser.getUserTitle());	//직급명
											
							signers = signers + apprUsers[j].getUserName() ;
							lastSignerLoginID  = apprUsers[j].getLoginId() ;
							
							k++;
						}	
					}
					
					setMap.put("Path", signers + ")");	//결재선 Path
					
					setMap.put("loginID", lastSignerLoginID);	//최종 결재자 loginID					
					String lastSigner = StringUtil.checkNull(commonService.selectString("user_SQL.member_id_select", setMap));
					
					//MAKE 전자 결재 본문 HTML
					String apprReqHTML = MakeEmailContents.makeHTML_APREQ_CSR(projectInfoMap, StringUtil.checkNull(cmmMap.get("sessionCurrLangType")), getLabel(request,commonService));
								
					ApprovalDocument approvalDoc = new ApprovalDocument();
					String flowCase = "customized";
					String PrimeCSR = "[PRIME] ";
					approvalDoc.setTitle(PrimeCSR + StringUtil.checkNull(projectInfoMap.get("ProjectName")));	
					//approvalDoc.setBodyContent(StringUtil.checkNull(projectInfoMap.get("Description")));					
					approvalDoc.setBodyContent(StringUtil.checkNull(apprReqHTML));  // 전자결재 본문 HTML 
					approvalDoc.setBodyContentType(1);
					approvalDoc.setFlowCase(flowCase);
					approvalDoc.setCompanyId(StringUtil.checkNull(HanwhaGlobalVal.HW_COMPANY_ID));
					approvalDoc.setSystemId(StringUtil.checkNull(HanwhaGlobalVal.HW_SYSTEM_ID));
					approvalDoc.setMisDocId(WFInstanceID);
					approvalDoc.setReceiverInfos(receiverInfos);
					approvalDoc.setSignerInfos(signerInfos);
					
					//3. INSERT [TB_WF_INST] 
					if(aprvOption.equals("POST")){
						setMap.put("aprvOption", "POST"); // 후결 
					}else {
						setMap.put("aprvOption", "PRE"); // 선결
					}
					setMap.put("WFInstanceID", WFInstanceID);
					setMap.put("ProjectID", projectID);
					setMap.put("WFID", WFID);
					setMap.put("Creator", loginUserid);
					setMap.put("LastUser", loginUserid);
					setMap.put("LastSigner", lastSigner);
					setMap.put("Status", status);
					setMap.put("ReturnedValue", null);
					setMap.put("GUBUN", "insert");
					setMap.put("srID", srID);
					commonService.insert("wf_SQL.insertToWfInst", setMap);
					if(_log.isInfoEnabled()){_log.info("HanwhaActionController::submitApproval::INFO_4::insertToWfInst SUCCESS");}
		
					//4. Call WebService submitApproval
					ApprovalServiceProxy proxy = new ApprovalServiceProxy();
					String aprvResult = proxy.submitApprovalUseUserId(approvalDoc);
					if(_log.isInfoEnabled()){_log.info("HanwhaActionController::submitApproval::INFO_5::ApprovalServiceProxy SUCCESS");}
					
					//5. UPDATE [TB_WF_INST]					
					status = "1";
					setMap.put("LastUser", loginUserid);
					setMap.put("Status", status);
					setMap.put("ReturnedValue", aprvResult);	
					setMap.put("WFInstanceID", WFInstanceID);
					commonService.update("wf_SQL.updateWfInst", setMap);
					if(_log.isInfoEnabled()){_log.info("HanwhaActionController::submitApproval::INFO_6::updateWfInst SUCCESS");}
					
					/* 기존 CSR Project 편집 */
					updateData = new HashMap();
					if(aprvOption.equals("POST")){
						updateData.put("Status", "CNG"); // 결재 중			
												
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
					commonService.update("project_SQL.updateProject", updateData);	
					
					// 해당CSR CR  SR 편집
				    updateCRData = new HashMap();			
					
					updateCRData.put("CSRID", projectID);
					if(aprvOption.equals("POST")) { // 후결재 
						updateCRData.put("status", "RFC");		
						updateCRData.put("ITSMIF", "0"); // 후 결재인 경우 ITSM에 바로 릴리즈함
						
						HashMap updateSR = new HashMap();  // SR Status == 변경 중(CNG)으로 업데이트 함
						
						if(!srID.equals("")){
						updateSR.put("srID", srID);
						updateSR.put("status", "CNG");
						updateSR.put("lastUser", cmmMap.get("sessionUserId"));
						commonService.update("sr_SQL.updateSRStatus", updateSR);	
					    }	
					    
					}else  { // 선결재 
						updateCRData.put("status", "APRV");
					}
					updateCRData.put("lastUser", loginUserid);
					commonService.update("cr_SQL.updateCR", updateCRData);
					
		
					
					// 결재후 처리 
				//	ApprovalBatch approvalBatch = new ApprovalBatch();
				//	approvalBatch.setApproval();
					
					String screenType = StringUtil.checkNull(request.getParameter("screenType")).trim();
					target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00150")); // 결재상신 성공
					target.put(AJAX_SCRIPT,"parent.fnCallBack('"+fromSR+"');parent.$('#isSubmit').remove();");	
				}else{
					target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
					target.put(AJAX_ALERT, "Receiver 조직 정보 조회 오류");
				}
			}
			else{
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
				target.put(AJAX_ALERT, ruleResultError); // 결재선 오류 발생
			}
		} catch (Exception e) {
			System.out.println(e);
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
				target.put(AJAX_ALERT,MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	private String getEmployeeNo(String employeeNo){
		StringBuilder sb = new StringBuilder();
		 boolean flag = false;  
		 int p = 0;
		 while( p < employeeNo.length()){
			   if(employeeNo.charAt(p) != '0')
			    flag = true;
			    						   
			   if(flag)
			   sb.append(employeeNo.charAt(p));						    
			   p++;
		  }
		 
		 return sb.toString();
	}
	
	
	/**
	 * [상신취소] cancelApproval
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cancelApproval.do")
	public String cancelApproval(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();

		try {
			HashMap setMap = new HashMap();

			String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));			
			String loginUserid = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			setMap.put("ProjectID", projectID);

			//1.SELECT [TB_WF_INST] 
			List idList = commonService.selectList("wf_SQL.getWFInstanceListByProcessing", setMap);
			String misDocId="";
			if(idList.size()>0){
				misDocId = StringUtil.checkNull(((HashMap)idList.get(0)).get("WFInstanceID"));
			}
			if(!misDocId.equals("")){
				//2. Call Web Service cancelApproval 
				CancelApprovalDocument cancelApprovalDoc = new CancelApprovalDocument();
				String comment = "결재 취소 Test 입니다.";
				cancelApprovalDoc.setMisDocId(misDocId);
				cancelApprovalDoc.setSystemId(StringUtil.checkNull(HanwhaGlobalVal.HW_SYSTEM_ID));
				cancelApprovalDoc.setComment(comment);
	
				ApprovalServiceProxy proxy = new ApprovalServiceProxy();
				String aprvResult = proxy.cancelApproval(cancelApprovalDoc);
				System.out.println("SUBMIT APPROVAL SUCCES ::: "+aprvResult);
				
				//3. UPDATE [TB_WF_INST]
				//1:진행->APRV, 2:완료(승인)->CNG, 3:반려(반송)->HOLD, 4:상신취소->WTR
				setMap.put("LastUser", loginUserid);
				setMap.put("Status", "WTR");
				setMap.put("ReturnedValue", aprvResult);
				setMap.put("WFInstanceID", misDocId);
				commonService.update("wf_SQL.updateWfInst", setMap);
			}
			target.put(AJAX_ALERT,MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장														// 성공
			target.put(AJAX_SCRIPT, "parent.goPjtList();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	
	/**
	 * [대량 결재 상태 상황 조회 서비스] getProcessIdByBulkMisId
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getProcessIdByBulk.do")
	public String getProcessIdByBulk(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();

		try {
			HashMap setMap = new HashMap();
			String loginUserid = StringUtil.checkNull(cmmMap.get("sessionUserId"));

			//1.SELECT [TB_WF_INST] 
			List processList = commonService.selectList("wf_SQL.getWFInstanceListByProcessing", setMap);
			int prcsCnt = processList.size();
			//2. Call Web Service getProcessIdByBulkMisId 
			//1:진행->OPN, 2:완료(승인)->CLS, 3:반려(반송)->HOLD, 4:상신취소->CNCL
			MisKey[] miskey = new MisKey[prcsCnt];
			for(int i=0; i< prcsCnt; i++){
				Map processMap = (HashMap)processList.get(i);
				miskey[i].setMisDocId(StringUtil.checkNull(processMap.get("WFInstanceID")));
				miskey[i].setSystemId(StringUtil.checkNull(HanwhaGlobalVal.HW_SYSTEM_ID));
			}
			if(prcsCnt>0){
				ApprovalServiceProxy proxy = new ApprovalServiceProxy();
				ApprovalDocumentStatusOnly[] aprvStatusResults = proxy.getProcessIdByBulkMisId(miskey);
				System.out.println("SUBMIT APPROVAL SUCCES ::: "+aprvStatusResults);
				
				//3. UPDATE [TB_WF_INST]
				String olmStatus = "APRV";
				String status = "";
				for(int i=0; i<aprvStatusResults.length; i++){
					status = StringUtil.checkNull(aprvStatusResults[i].getStatus());
					//1:진행->APRV, 2:완료(승인)->CNG, 3:반려(반송)->HOLD, 4:상신취소->WTR
					if(status.equals("1") ){olmStatus="APRV";}
					else if(status.equals("2") ){olmStatus="CNG";}
					else if(status.equals("3") ){olmStatus="HOLD";}
					else if(status.equals("4") ){olmStatus="WTR";}
					setMap.put("LastUser", loginUserid);
					setMap.put("Status", olmStatus);
					setMap.put("ReturnedValue", aprvStatusResults[i].getStatus());
					setMap.put("WFInstanceID", aprvStatusResults[i].getMisDocId());
					commonService.update("wf_SQL.updateWfInst", setMap);
				}
				
				// CR Status Update
				String crStatus = "";
				String aprvOption = "";
				String projectID = "";
				for(int i=0; i<aprvStatusResults.length; i++){
					status = StringUtil.checkNull(aprvStatusResults[i].getStatus());
					//1:진행->APRV, 2:완료(승인)->CNG, 3:반려(반송)->HOLD, 4:상신취소->WTR			
					
					Map getWFInstanceInfo = commonService.select("wf_SQL.getWFInstanceInfo", setMap);
					aprvOption =  StringUtil.checkNull(getWFInstanceInfo.get("AprvOption"));
					projectID =  StringUtil.checkNull(getWFInstanceInfo.get("ProjectID"));
					
					if(status.equals("2") && aprvOption.equals("PRE") ){			
						//승인된 건 && CSR.ArpvOption = 'PRE'인 CSR의 CR에 대해서  --> CR.Status = 'RFC', CR.ITSMIF = '0' (승인 후 ITSM에 릴리즈)
						crStatus="RFC";
						setMap.put("LastUser", loginUserid);
						setMap.put("status", crStatus);
						setMap.put("ITSMIF", "0");
						setMap.put("CSRID", projectID);						
						commonService.update("cr_SQL.updateCR", setMap);
					}else if(status.equals("3") ){ // HOLD
						crStatus="HOLD";						
						setMap.put("LastUser", loginUserid);
						setMap.put("Status", crStatus);
						setMap.put("CSRID",  projectID);		
						commonService.update("cr_SQL.updateCR", setMap);
					}
				}
			}
			
			target.put(AJAX_ALERT,MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장														// 성공
			target.put(AJAX_SCRIPT, "parent.goPjtList();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * downloadProcessList
	 * @param request
	 * @param commandMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/zhwc_downloadHWCProcData.do")
	public String downloadHWCProcData(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		model.put("s_itemID", commandMap.get("s_itemID"));
		model.put("menu", getLabel(request, commonService));	/*Label Setting*/	
		return nextUrl("/custom/hanwha/hwc/report/downloadHWCProcData");
	}
	
	@RequestMapping(value="/hanwha/hwSRView.do")
	public String hwSRView(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
	  	String Empno = StringUtil.checkNull(request.getParameter("empno"));
	  	
	  	try {
	  		Map setMap = new HashMap();
		  	
		  	setMap.put("Empno", Empno);
			Map SRPVMap = commonService.select("custom_SQL.getSRProcViewHanwha", setMap);
			
			model.put("ReceiptUserID", SRPVMap.get("ReceiptUserID"));
			model.put("EmployeeNum", Empno);
			model.put("Processor", SRPVMap.get("Processor"));
			model.put("ReqCount", SRPVMap.get("ReqCount"));
			model.put("ProcCount", SRPVMap.get("ProcCount"));
			model.put("ClsDueCount", SRPVMap.get("ClsDueCount"));
				  		
	  	} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("LoginActionController::loginbase::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
	  	
		return nextUrl("/custom/hanwha/htc/report/srProcView");
	}
	

	/**
	 * [결재요청] submitApproval
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/zhwc_submitApproval.do")
	public String zhwc_submitApproval(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();
		String strApprPath="";
		try {
			HashMap setMap = new HashMap();
			HashMap updateData = new HashMap();
			HashMap updateCRData = new HashMap();
			String projectID = StringUtil.checkNull(request.getParameter("projectID"));
			String aprvOption = StringUtil.checkNull(request.getParameter("aprvOption"));
			String srID = StringUtil.checkNull(request.getParameter("srID"));
			String fromSR = StringUtil.checkNull(request.getParameter("fromSR"));
			String serviceCode = StringUtil.checkNull(request.getParameter("serviceCode"));
			String wfID = StringUtil.checkNull(request.getParameter("wfID2"));
			String wfDocumentIDs = StringUtil.checkNull(request.getParameter("wfDocumentIDs"));
			String isMulti = StringUtil.checkNull(cmmMap.get("isMulti"));
			String documentID = StringUtil.checkNull(cmmMap.get("documentID"));
			String subject = StringUtil.checkNull(cmmMap.get("subject"));
			String description = StringUtil.checkNull(cmmMap.get("description"));
			String documentType = StringUtil.checkNull(cmmMap.get("documentType"));
			
			
			String getWfStepMemberIDs = StringUtil.checkNull(cmmMap.get("wfStepMemberIDs"));
			String getWfStepRoleTypes = StringUtil.checkNull(cmmMap.get("wfStepRoleTypes"));
			String getWfStepRefMemberIDs = StringUtil.checkNull(cmmMap.get("wfStepRefMemberIDs"));

			String wfStepMemberIDs[] = null;
			String wfStepRoleTypes[] = null;
			String wfStepRefMemberIDs[] = null;
			
			if(!getWfStepMemberIDs.isEmpty()){ wfStepMemberIDs = getWfStepMemberIDs.split(","); }
			if(!getWfStepRoleTypes.isEmpty()){ wfStepRoleTypes = getWfStepRoleTypes.split(","); }
			if(!getWfStepRefMemberIDs.isEmpty()){ wfStepRefMemberIDs = getWfStepRefMemberIDs.split(","); }
			System.out.println("Msg : " + serviceCode);

			String loginUserid = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			String status = "0"; // 초기 설정 값 (0 = 상신)
			String employeeNo = StringUtil.checkNull(cmmMap.get("sessionEmployeeNm"));//사번
			setMap.put("s_itemID", projectID);
			setMap.put("languageID", cmmMap.get("sessionCurrLangType"));
		
		
			String maxWFInstanceID = commonService.selectString("wf_SQL.MaxWFInstanceID", setMap);
			String OLM_SERVER_NAME = GlobalVal.OLM_SERVER_NAME;
			int svnmLength = OLM_SERVER_NAME.length();
			System.out.println("svnmLength :"+svnmLength);
			int maxWFInstanceID2 = Integer.parseInt(maxWFInstanceID.substring(svnmLength));
			int maxcode = maxWFInstanceID2 + 1;
			String WFInstanceID = OLM_SERVER_NAME + String.format("%010d", maxcode);
			
			//2. Search Approval User Infos
			String currentTime = DateUtil.getCurrentTime("yyyyMMddHHmmss");
			
			//2.1 상신자 정보 확인 : ReceiverInfo
			NeoOrgWsProxy orgProxy = new NeoOrgWsProxy();
			OrgUserVO[] orgUsers = orgProxy.searchGroupUserByEmpolyeeNo(employeeNo);
			System.out.println("HanwhaActionController::submitApproval::INFO_1::orgProxy SUCCESS :: orgUsers Size="+orgUsers.length);
			
			int seqIndex = 0; 
			String lastSigner = loginUserid;
			SignerInfo[] signerInfos = null;
			
			if(orgUsers.length >0){
				/*
				OrgUserVO orgUser = orgUsers[0];
				
				ReceiverInfo[] receiverInfos = new ReceiverInfo[1];
				receiverInfos[0] = new ReceiverInfo();
				
				receiverInfos[0].setRoleType("Reciver"); // 권한 타입 (referer:참조처, receiver:수신처)
				//receiverInfos[0].setDeptType(false); // 수신처 타입 부서 여부 (true : 부서, false : 사용자, default : false)
				//receiverInfos[0].setIncludeChild(false); // 하위부서 포함 여부 (true : 하위 부서 포함, false : 하위부서 포함 안함, default : false)
				receiverInfos[0].setForwardable(true); // 전달 허용 여부 (true : 허용, false : 비허용, default : false)
				//receiverInfos[0].setReceiverKey(orgUser.getUserKey()); // 수신자 EagleOffice의 userKey	(호출함수의 suffix 가 ~UseUserId 가 아닌 경우 필수 입력)
				receiverInfos[0].setReceiverId(orgUser.getUserId()); // 수신처	isDeptType=false 일 때 EagleOffice의 userId 	isDeptType=true 일 때 EagleOffice의 deptId (호출함수의 suffix 가 ~UseUserId 인 경우 필수 입력)
				receiverInfos[0].setReceiverName(orgUser.getUserName()); // 수신처명 ( 상황 조회 시 결과 값 isDeptType=false 일 때 사용자 명, isDeptType=true 일 때 부서명 )
				receiverInfos[0].setCompanyId(orgUser.getCompanyId());
				receiverInfos[0].setCompanyName(orgUser.getCompanyName());
				receiverInfos[0].setDeptId(orgUser.getDeptId()); 
				receiverInfos[0].setDeptName(orgUser.getDeptName());
				receiverInfos[0].setFunctionId(orgUser.getJobFunctionId()); // 직책 ID
				receiverInfos[0].setFunctionName(orgUser.getJobFunctionName());
				receiverInfos[0].setEmailAddr(orgUser.getEmail());
				*/
				if(!getWfStepMemberIDs.isEmpty()){
					signerInfos = new SignerInfo[wfStepMemberIDs.length];	//20160526 receiverInfo 추가//20160711 SignerInfo에 SR요청자 정보를 추가
					int assignType = 0;
					int seq = 0;
					Map tempMap = new HashMap();
					System.out.println(wfStepMemberIDs.length);
					for(int i=0; i< wfStepMemberIDs.length; i++){	

						System.out.println(i);
						tempMap.put("userID", wfStepMemberIDs[i]);
						String empNo = commonService.selectString("user_SQL.getEmployeeNum", tempMap);
						OrgUserVO[] signerUsers = orgProxy.searchGroupUserByEmpolyeeNo(empNo);
						OrgUserVO signerUser = signerUsers[0];
											
						if("AGR".equals(wfStepRoleTypes[i])) {
							assignType = 2;							
						}
						else if("PAGR".equals(wfStepRoleTypes[i])) {
							assignType = 2;		
							if(seq > 1) seq--;
						}
						else if("REF".equals(wfStepRoleTypes[i])) {
							assignType = 9;
						}
						else if("AREQ".equals(wfStepRoleTypes[i])) {
							assignType = 0;
						}
						else {
							assignType = 1;							
						}
						
						signerInfos[i] = new SignerInfo();	
						signerInfos[i].setAssignType(assignType); // 참여자 형태( 0:기안, 1:결재, 2:협조결재, 9:결재참조 )
						signerInfos[i].setStatus(0); //결재자 상태( 상황 조회 시 결과 값,0 : 미결, 1 : 승인, 2: 반려, 3 : 전결, default : 0 )
						signerInfos[i].setSequence(seq); // 결재순번	( 병렬인 경우 반드시 동일한 순번을 가져야 하며 상신자의 결재순번은 반드시 0이 되어야 한다. 결재 및 협조의 순번은 반드시 1이상 이어야 한다. )
						signerInfos[i].setNotEditable(true);
						signerInfos[i].setNotRemovable(false);
						signerInfos[i].setEndDate(currentTime); //결재문서 처리 시간 ( 상황 조회 시 결과 값, YYYYMMDDHH24MISS )
						signerInfos[i].setArbitrary(true); // 전결 권한 ( true : 전결 가능, false : 전결 불가, default : false )
						signerInfos[i].setStdDate(currentTime); // 결재 문서 도착 시간	( 상황 조회 시 결과 값, YYYYMMDDHH24MISS )
						signerInfos[i].setComment(""); // 결재 의견
						signerInfos[i].setUserId(signerUser.getUserId()); 
						signerInfos[i].setUserName(signerUser.getUserName());	//
						signerInfos[i].setDeptName(signerUser.getDeptName());	//부서명
						signerInfos[i].setFunctionName(signerUser.getJobFunctionName());	//직급명	
						lastSigner = wfStepMemberIDs[i];
						seq++;
					}
				}

				System.out.println("HanwhaActionController::submitApproval::INFO_1::signerInfo SUCCESS :: signerInfos Size="+signerInfos.length);
								
				//3. INSERT [TB_WF_INST] 
				setMap.put("aprvOption", "PRE"); // 선결
			
				setMap.put("WFInstanceID", WFInstanceID);
				setMap.put("ProjectID", projectID);
				setMap.put("WFID", wfID);
				setMap.put("Creator", loginUserid);
				setMap.put("LastUser", loginUserid);
				setMap.put("LastSigner", lastSigner);
				setMap.put("Status", status);
				setMap.put("DocCategory", "CS");
				setMap.put("ReturnedValue", null);
				setMap.put("GUBUN", "insert");
				setMap.put("srID", srID);
				commonService.insert("wf_SQL.insertToWfInst", setMap);
				System.out.println("HanwhaActionController::submitApproval::INFO_4::insertToWfInst SUCCESS");
								
				// 해당CSR CR  SR 편집
			    updateCRData = new HashMap();			
				
				updateCRData.put("Status", "APRV");
				
				if(isMulti.equals("Y")) {
					String ids[] = wfDocumentIDs.split(",");
					for(int i=0; i<ids.length; i++) {
						updateCRData.put("s_itemID", ids[i]);
						updateCRData.put("wfInstanceID",WFInstanceID);
						commonService.update("cs_SQL.updateChangeSet", updateCRData);
					}
				}
				else {
					updateCRData.put("s_itemID", documentID);
					updateCRData.put("wfInstanceID",WFInstanceID);
					commonService.update("cs_SQL.updateChangeSet", updateCRData);
				}			
				    
				//MAKE 전자 결재 본문 HTML

				setMap.put("wfInstanceID",WFInstanceID);
				setMap.put("LanguageID", cmmMap.get("sessionCurrLangType"));
				Map getPJTMap = commonService.select("wf_SQL.getWFInstDetail", setMap);
				Map wfInstInfo = commonService.select("wf_SQL.getWFInstanceDetail_gridList", setMap);
				
				setMap.remove("s_itemID");
				setMap.remove("Status");
				List csInstList = commonService.selectList("cs_SQL.getChangeSetList_gridList", setMap);
				ModelMap mailModel = new ModelMap();
				getPJTMap.put("Description",description);
				getPJTMap.put("Subject",subject);
				getPJTMap.put("documentType",documentType);
				mailModel.put("getPJTMap", getPJTMap);
				mailModel.put("wfInstInfo", wfInstInfo);
				mailModel.put("csInstList", csInstList);
				mailModel.put("wfStepInstInfo", "");
				mailModel.put("wfStepInstAGRInfo", "");
				mailModel.put("wfStepInstREFInfo", "");
				mailModel.put("wfStepInstRELInfo", "");
				mailModel.put("wfStepInstRECInfo", "");
				mailModel.put("wfInstList", "");
				mailModel.put("documentType", documentType);
				
				System.out.println("HanwhaActionController::submitApproval::INFO_5::insertToWfInst SUCCESS");
				String apprReqHTML = MakeEmailContents.makeHTML_APREQ_CS(mailModel, StringUtil.checkNull(cmmMap.get("sessionCurrLangType")), getLabel(request,commonService));
				System.out.println("HanwhaActionController::submitApproval::INFO_5::Mail Form Get SUCCESS");
							
				ApprovalDocument approvalDoc = new ApprovalDocument();
				String flowCase = "customized";
				String PrimeCSR = "[H-PIP] ";
				approvalDoc.setTitle(PrimeCSR + StringUtil.checkNull(cmmMap.get("subject")));	
				//approvalDoc.setBodyContent(StringUtil.checkNull(projectInfoMap.get("Description")));					
				approvalDoc.setBodyContent(StringUtil.checkNull(apprReqHTML));  // 전자결재 본문 HTML 
				approvalDoc.setBodyContentType(1);
				approvalDoc.setFlowCase(flowCase);
				System.out.println(apprReqHTML);
				approvalDoc.setCompanyId(StringUtil.checkNull(HanwhaGlobalVal.HW_COMPANY_ID));
				approvalDoc.setSystemId(StringUtil.checkNull(HanwhaGlobalVal.HW_SYSTEM_ID));
				approvalDoc.setMisDocId(WFInstanceID);
				//approvalDoc.setReceiverInfos(receiverInfos);
				System.out.println("HanwhaActionController::submitApproval::INFO_5::ApprovalServiceProxy After");
				approvalDoc.setSignerInfos(signerInfos);				
				
	
				//4. Call WebService submitApproval
				ApprovalServiceProxy proxy = new ApprovalServiceProxy();
				System.out.println("HanwhaActionController::submitApproval::INFO_5::ApprovalServiceProxy After");
				String aprvResult = proxy.submitApprovalUseUserId(approvalDoc);
				System.out.println("HanwhaActionController::submitApproval::INFO_5::ApprovalServiceProxy SUCCESS");
				
				//5. UPDATE [TB_WF_INST]					
				status = "1";
				setMap.put("LastUser", loginUserid);
				setMap.put("Status", status);
				setMap.put("ReturnedValue", aprvResult);	
				setMap.put("WFInstanceID", WFInstanceID);
				commonService.update("wf_SQL.updateWfInst", setMap);
				System.out.println("HanwhaActionController::submitApproval::INFO_6::updateWfInst SUCCESS");
				
				
				String screenType = StringUtil.checkNull(request.getParameter("screenType")).trim();
				target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00150")); // 결재상신 성공
				target.put(AJAX_SCRIPT,"parent.fnCallBack();parent.$('#isSubmit').remove();");	
			}else{
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
				target.put(AJAX_ALERT, "Receiver 조직 정보 조회 오류");
			}
		} catch (Exception e) {
			System.out.println(e.toString());
			System.out.println(e);
				target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
				target.put(AJAX_ALERT,MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
			
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	/**
	 * [상신취소] cancelApproval
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/zhwc_cancelApproval.do")
	public String zhwc_cancelApproval(HttpServletRequest request, HashMap cmmMap, ModelMap model) throws Exception {
		Map target = new HashMap();

		try {
			HashMap setMap = new HashMap();

			String projectID = StringUtil.checkNull(request.getParameter("ProjectID"));			
			String loginUserid = StringUtil.checkNull(cmmMap.get("sessionUserId"));
			setMap.put("ProjectID", projectID);

			//1.SELECT [TB_WF_INST] 
			List idList = commonService.selectList("wf_SQL.getWFInstanceListByProcessing", setMap);
			String misDocId="";
			if(idList.size()>0){
				misDocId = StringUtil.checkNull(((HashMap)idList.get(0)).get("WFInstanceID"));
			}
			if(!misDocId.equals("")){
				//2. Call Web Service cancelApproval 
				CancelApprovalDocument cancelApprovalDoc = new CancelApprovalDocument();
				String comment = "결재 취소 Test 입니다.";
				cancelApprovalDoc.setMisDocId(misDocId);
				cancelApprovalDoc.setSystemId(StringUtil.checkNull(HanwhaGlobalVal.HW_SYSTEM_ID));
				cancelApprovalDoc.setComment(comment);
	
				ApprovalServiceProxy proxy = new ApprovalServiceProxy();
				String aprvResult = proxy.cancelApproval(cancelApprovalDoc);
				System.out.println("SUBMIT APPROVAL SUCCES ::: "+aprvResult);
				
				//3. UPDATE [TB_WF_INST]
				//1:진행->APRV, 2:완료(승인)->CNG, 3:반려(반송)->HOLD, 4:상신취소->WTR
				setMap.put("LastUser", loginUserid);
				setMap.put("Status", "WTR");
				setMap.put("ReturnedValue", aprvResult);
				setMap.put("WFInstanceID", misDocId);
				commonService.update("wf_SQL.updateWfInst", setMap);
			}
			target.put(AJAX_ALERT,MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00067")); // 저장														// 성공
			target.put(AJAX_SCRIPT, "parent.goPjtList();parent.$('#isSubmit').remove();");

		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "parent.$('#isSubmit').remove();");
			target.put(AJAX_ALERT, MessageHandler.getMessage(cmmMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생
		}

		model.addAttribute(AJAX_RESULTMAP, target);

		return nextUrl(AJAXPAGE);
	}
	
	@RequestMapping(value="/mainAuthorLogList.do")
	public String mainAuthorLogList(HttpServletRequest request, Map cmmMap,ModelMap model) throws Exception {
		try {
			model.put("mainYN", "Y");
			model.put("languageID", StringUtil.checkNull(request.getParameter("languageID"),"1042"));
			model.put("menu", getLabel(request, commonService));	/*Label Setting*/
		}		
		catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}		
		
		return nextUrl("/custom/hanwha/hwc/report/mainAuthorLogList");
	}
	

	/**
	 * Process 통계 (2018/11/21)
	 * TW_PROCESS 테이블의 데이터 이용
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value="/zhwc_ProcessItemStatistics.do")
	public String zhwc_ProcessItemStatistics(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		
		Map setMap = new HashMap();
		try {

			setMap.put("itemTypeCode", "OJ00007");
			setMap.put("identifier", "HW-1-%");
			String CntString = commonService.selectString("custom_SQL.zhwc_getProcessCntForIdentifier", setMap);
			
			setMap.put("identifier", "HW-2-%");
			String CntString2 = commonService.selectString("custom_SQL.zhwc_getProcessCntForIdentifier", setMap);
			
			setMap.put("identifier", "HW-3-%");
			String CntString3 = commonService.selectString("custom_SQL.zhwc_getProcessCntForIdentifier", setMap);

	        model.put("nomalRuleCnt", Integer.parseInt(CntString)+Integer.parseInt(CntString2)+Integer.parseInt(CntString3));
	        
			setMap.put("identifier", "HW-SHEC-%");
			CntString = commonService.selectString("custom_SQL.zhwc_getProcessCntForIdentifier", setMap);

	        model.put("shecRuleCnt", CntString);
	        
			setMap.put("identifier", "HWQ-%");
			CntString = commonService.selectString("custom_SQL.zhwc_getProcessCntForIdentifier", setMap);

	        model.put("qRuleCnt", CntString);
	        
			setMap.put("identifier", "HW-2-2_%");
			CntString = commonService.selectString("custom_SQL.zhwc_getProcessCntForIdentifier", setMap);

	        model.put("rRuleCnt", CntString);
	        
	        setMap.remove("identifier");
			setMap.put("projectID", "21");
			CntString = commonService.selectString("custom_SQL.zhwc_getProcessCntForIdentifier", setMap);

	        model.put("yProcessCnt", CntString);
	        
			setMap.put("projectID", "16");
			CntString = commonService.selectString("custom_SQL.zhwc_getProcessCntForIdentifier", setMap);

	        model.put("b1ProcessCnt", CntString);
	        
			setMap.put("projectID", "17");
			CntString = commonService.selectString("custom_SQL.zhwc_getProcessCntForIdentifier", setMap);
			
	        model.put("b2ProcessCnt", CntString);
	        
			setMap.put("projectID", "19");
			CntString = commonService.selectString("custom_SQL.zhwc_getProcessCntForIdentifier", setMap);

	        model.put("dProcessCnt", CntString);
	        
			setMap.put("projectID", "20");
			CntString = commonService.selectString("custom_SQL.zhwc_getProcessCntForIdentifier", setMap);

	        model.put("rProcessCnt", CntString);
	        
			setMap.put("projectID", "18");
			CntString = commonService.selectString("custom_SQL.zhwc_getProcessCntForIdentifier", setMap);

	        model.put("gProcessCnt", CntString);

			model.put("menu", getLabel(request, commonService));
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/custom/hanwha/hwc/report/zhwc_ProcessItemStatistics");
	}
	

	@RequestMapping(value = "/zhwc_aprvBySysPmRole.do")
	public String zhwc_aprvBySysPmRole(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception {	
		HashMap target = new HashMap();	
		Map setMap = new HashMap();
		Map urlMap = new HashMap();
		try {
			String wfID = StringUtil.checkNull(commandMap.get("wfID"));
			String srID = StringUtil.checkNull(commandMap.get("srID"));
			String sessionUserId = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String languageID = StringUtil.checkNull(commandMap.get("sessionCurrLangType"));
			String projectID = StringUtil.checkNull(commandMap.get("projectID"));
			String wfDocType = StringUtil.checkNull(commandMap.get("wfDocType"));
			
			Map resultMap = new HashMap();	
			setMap.put("teamID", commandMap.get("sessionTeamId"));
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			Map managerInfo = commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
			// 상신자 
			String userID = StringUtil.checkNull(commandMap.get("sessionUserId"));
			String userName = StringUtil.checkNull(commandMap.get("sessionUserNm"));
			String userTeamName =  StringUtil.checkNull(commandMap.get("sessionTeamName"));	
			
			if(managerInfo == null || managerInfo.isEmpty()) {
				resultMap.put("noManager","Y"); //  소속 부서장 정보가 없을 때
			}
			
			// 매니저
			String managerID = StringUtil.checkNull(managerInfo.get("UserID"));
			String managerName = StringUtil.checkNull(managerInfo.get("MemberName"));
			String managerTeamName = StringUtil.checkNull(managerInfo.get("TeamName"));
			
			setMap.put("projectID", projectID);
			setMap.put("teamID", "2");
			Map pmInfo = commonService.select("user_SQL.getUserTeamManagerInfo", setMap);
			
			String pmID = StringUtil.checkNull(pmInfo.get("UserID"));
			String pmName = StringUtil.checkNull(pmInfo.get("MemberName"));
			String pmTeamName = StringUtil.checkNull(pmInfo.get("TeamName"));
			
			String memberIDs = userID+","+managerID+","+pmID;
			String roleTypes = "AREQ,APRV,AGR";		
			String wfStepInfo = userName+"("+userTeamName+") >> "+managerName+"("+managerTeamName+") >>" + pmName + "("+pmTeamName+")";
	
			resultMap.put("memberIDs", memberIDs);
			resultMap.put("roleTypes", roleTypes);
			resultMap.put("wfStepInfo", wfStepInfo);

			target.put(AJAX_SCRIPT, "fnSetWFStepInfo('"+wfStepInfo+"','"+memberIDs+"','"+roleTypes+"','','')");
		
		} catch (Exception e) {
			System.out.println(e);
			target.put(AJAX_SCRIPT, "this.$('#isSubmit').remove();parent.$('#isSubmit').remove()");
			target.put(AJAX_ALERT, MessageHandler.getMessage(commandMap.get("sessionCurrLangCode") + ".WM00068")); // 오류 발생												
		}
		model.addAttribute(AJAX_RESULTMAP, target);
		return nextUrl(AJAXPAGE);
	}

	/**
	 * Process 통계 (2018/11/21)
	 * TW_PROCESS 테이블의 데이터 이용
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value="/zhwc_ItemConnectionList.do")
	public String zhwc_ItemConnectionList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		
		Map setMap = new HashMap();
		Map setCSMap = new HashMap();
		
		String filepath = request.getSession().getServletContext().getRealPath("/");
		String xmlFilName = "upload/itemConList.xml";
		String fromItemID = StringUtil.checkNull(commandMap.get("fromItemID"));

		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance(); 
	    
		try {
			model.put("menu", getLabel(request, commonService));
	        model.put("xmlFilName", xmlFilName);

		    DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		    Document doc = docBuilder.newDocument(); 
		    Element rootElement = doc.createElement("rows"); 
		    doc.appendChild(rootElement); 
		    
		    int rowId = 1;
		    int rowTotal = 0;
		    
			String fromItemIDs[] = fromItemID.split(",");			
		    
		    // row 엘리먼트 
			for(int no = 0; no < fromItemIDs.length; no++) {
			    setMap.remove("fromItemID");
			    
			    setMap.put("itemID", fromItemIDs[no]);
				setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			    Map L1ItemInfo = commonService.select("custom_SQL.zhwc_ItemConnectionList_gridList", setMap);

			    setMap.remove("itemID");
			    
		        Element row = doc.createElement("row"); 
		        rootElement.appendChild(row); 
		        row.setAttribute("id", String.valueOf(rowId));
	
		        Element cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode("L1")); // RowNum
		        row.appendChild(cell);
		        rowId++;
		        
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L1ItemInfo.get("Identifier")))); // Identifier
		        row.appendChild(cell);	
		        
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L1ItemInfo.get("PlainText")))); // Name		        
		        row.appendChild(cell);
		        
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode("")); // L2 Name
		        row.appendChild(cell);
		        
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode("")); // L3 Name
		        row.appendChild(cell);
		        
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode("")); // L4 Name
		        row.appendChild(cell);
		        
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode("")); // L5 Name
		        row.appendChild(cell);
		        
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L1ItemInfo.get("FileList")))); // FileList
		        row.appendChild(cell);
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L1ItemInfo.get("ConItemList")))); // Connection List
		        row.appendChild(cell);
		        
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L1ItemInfo.get("TeamNm")))); // TeamNm
		        row.appendChild(cell);
		        
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L1ItemInfo.get("AuthorNm")))); // AuthorNm
		        row.appendChild(cell);
			    
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L1ItemInfo.get("Version")))); // Version
		        row.appendChild(cell);
		        
		        setCSMap.put("itemID", L1ItemInfo.get("ItemID"));
		        setCSMap.put("status", "CLS");
		        setCSMap.put("version", L1ItemInfo.get("Version"));
				String maxValidFrom = commonService.selectString("cs_SQL.getItemValidFrom", setCSMap);
		        cell = doc.createElement("cell");
		        cell.appendChild(doc.createTextNode(StringUtil.checkNull(maxValidFrom))); // maxValidFrom
		        row.appendChild(cell);
		        
			    setMap.put("fromItemID", fromItemIDs[no]);
		        List L2ItemList = commonService.selectList("custom_SQL.zhwc_ItemConnectionList_gridList", setMap);
		        
			    
		        if(L2ItemList != null && !L2ItemList.isEmpty()) {
		        	for(int i=0; i<L2ItemList.size(); i++) {
		        		Map temp = (Map)L2ItemList.get(i);
		        		
		        		row = doc.createElement("row"); 
		    	        rootElement.appendChild(row); 
		    	        row.setAttribute("id", String.valueOf(rowId));
	
		    	        cell = doc.createElement("cell");
		    	        cell.appendChild(doc.createTextNode("L2")); // RowNum
		    	        row.appendChild(cell);
		    	        rowId++;
	
		    	        cell = doc.createElement("cell");
		    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(temp.get("Identifier")))); // ID
		    	        row.appendChild(cell);
		    	        
		    	        cell = doc.createElement("cell");
		    	        cell.appendChild(doc.createTextNode("")); // L1 Name
		    	        row.appendChild(cell);
		    	        
		    	        cell = doc.createElement("cell");
		    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(temp.get("PlainText")))); // L2 Name
		    	        row.appendChild(cell);
		    	        
		    	        cell = doc.createElement("cell");
		    	        cell.appendChild(doc.createTextNode("")); // L3 Name
		    	        row.appendChild(cell);
		    	        
		    	        cell = doc.createElement("cell");
		    	        cell.appendChild(doc.createTextNode("")); // L4 Name
		    	        row.appendChild(cell);
		    	        
				        cell = doc.createElement("cell");
				        cell.appendChild(doc.createTextNode("")); // L5 Name
				        row.appendChild(cell);
				        
		    	        cell = doc.createElement("cell");
		    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(temp.get("FileList")))); // FileList
		    	        row.appendChild(cell);
		    	        cell = doc.createElement("cell");
		    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(temp.get("ConItemList")))); // Connection List
		    	        row.appendChild(cell);
				    	    
				        cell = doc.createElement("cell");
				        cell.appendChild(doc.createTextNode(StringUtil.checkNull(temp.get("TeamNm")))); // TeamNm
				        row.appendChild(cell);
				        
				        cell = doc.createElement("cell");
				        cell.appendChild(doc.createTextNode(StringUtil.checkNull(temp.get("AuthorNm")))); // AuthorNm
				        row.appendChild(cell);
					    
				        cell = doc.createElement("cell");
				        cell.appendChild(doc.createTextNode(StringUtil.checkNull(temp.get("Version")))); // Version
				        row.appendChild(cell);
				        
				        setCSMap.put("itemID", temp.get("ItemID"));
				        setCSMap.put("status", "CLS");
				        setCSMap.put("version", temp.get("Version"));
						maxValidFrom = commonService.selectString("cs_SQL.getItemValidFrom", setCSMap);
				        cell = doc.createElement("cell");
				        cell.appendChild(doc.createTextNode(StringUtil.checkNull(maxValidFrom))); // maxValidFrom
				        row.appendChild(cell);
				        
		    		    setMap.put("fromItemID", temp.get("ItemID"));
		    	        List L3ItemList = commonService.selectList("custom_SQL.zhwc_ItemConnectionList_gridList", setMap);	 
		    	        
		    	        
		    	        if(L3ItemList != null && !L3ItemList.isEmpty()) {
		    	        	for(int j=0; j<L3ItemList.size(); j++) {
		    	        		Map L3InfoMap = (Map)L3ItemList.get(j);
		    	        		
				    	        row = doc.createElement("row"); 
				    	        rootElement.appendChild(row); 
				    	        row.setAttribute("id", String.valueOf(rowId));
	
				    	        cell = doc.createElement("cell");
				    	        cell.appendChild(doc.createTextNode("L3")); // RowNum
				    	        row.appendChild(cell);
				    	        rowId++;
	
				    	        cell = doc.createElement("cell");
				    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L3InfoMap.get("Identifier")))); // ID
				    	        row.appendChild(cell);
				    	        
				    	        cell = doc.createElement("cell");
				    	        cell.appendChild(doc.createTextNode("")); // L1 Name
				    	        row.appendChild(cell);
				    	        
				    	        cell = doc.createElement("cell");
				    	        cell.appendChild(doc.createTextNode("")); // L2 Name
				    	        row.appendChild(cell);
				    	        
				    	        cell = doc.createElement("cell");
				    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L3InfoMap.get("PlainText")))); // Name
				    	        row.appendChild(cell);
				    	        
				    	        cell = doc.createElement("cell");
				    	        cell.appendChild(doc.createTextNode("")); // L4 Name
				    	        row.appendChild(cell);
				    	        
						        cell = doc.createElement("cell");
						        cell.appendChild(doc.createTextNode("")); // L5 Name
						        row.appendChild(cell);
						        
				    	        cell = doc.createElement("cell");
				    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L3InfoMap.get("FileList")))); // FileList
				    	        row.appendChild(cell);
				    	        cell = doc.createElement("cell");
				    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L3InfoMap.get("ConItemList")))); // Connection List
				    	        row.appendChild(cell);
				    	        
						        cell = doc.createElement("cell");
						        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L3InfoMap.get("TeamNm")))); // TeamNm
						        row.appendChild(cell);
						        
						        cell = doc.createElement("cell");
						        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L3InfoMap.get("AuthorNm")))); // AuthorNm
						        row.appendChild(cell);
							    
						        cell = doc.createElement("cell");
						        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L3InfoMap.get("Version")))); // Version
						        row.appendChild(cell);
						        
						        setCSMap.put("itemID", L3InfoMap.get("ItemID"));
						        setCSMap.put("status", "CLS");
						        setCSMap.put("version", L3InfoMap.get("Version"));
								maxValidFrom = commonService.selectString("cs_SQL.getItemValidFrom", setCSMap);
						        cell = doc.createElement("cell");
						        cell.appendChild(doc.createTextNode(StringUtil.checkNull(maxValidFrom))); // maxValidFrom
						        row.appendChild(cell);
						        
				    	        setMap.put("fromItemID", L3InfoMap.get("ItemID"));
				    	        List L4ItemList = commonService.selectList("custom_SQL.zhwc_ItemConnectionList_gridList", setMap);	
	
				    	        if(L4ItemList != null && !L4ItemList.isEmpty()) {
				    	        	for(int k=0; k<L4ItemList.size(); k++) {
				    	        		
				    	        		Map L4InfoMap = (Map)L4ItemList.get(k);
				    	        		
						    	        row = doc.createElement("row"); 
						    	        rootElement.appendChild(row); 
						    	        row.setAttribute("id", String.valueOf(rowId));
	
						    	        cell = doc.createElement("cell");
						    	        cell.appendChild(doc.createTextNode("L4")); // RowNum
						    	        row.appendChild(cell);
						    	        rowId++;
							    	        
						    	        cell = doc.createElement("cell");
						    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4InfoMap.get("Identifier")))); // L4 ID
						    	        row.appendChild(cell);
						    	        
						    	        cell = doc.createElement("cell");
						    	        cell.appendChild(doc.createTextNode("")); // L1 Name
						    	        row.appendChild(cell);
						    	        
						    	        cell = doc.createElement("cell");
						    	        cell.appendChild(doc.createTextNode("")); // L2 Name
						    	        row.appendChild(cell);
						    	        
						    	        cell = doc.createElement("cell");
						    	        cell.appendChild(doc.createTextNode("")); // L3 Name
						    	        row.appendChild(cell);
						    	        
						    	        cell = doc.createElement("cell");
						    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4InfoMap.get("PlainText")))); // L4 Name
						    	        row.appendChild(cell);
						    	        
						    	        cell = doc.createElement("cell");
								        cell.appendChild(doc.createTextNode("")); // L5 Name
								        row.appendChild(cell);
								        
						    	        cell = doc.createElement("cell");
						    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4InfoMap.get("FileList")))); // FileList
						    	        row.appendChild(cell);
						    	        cell = doc.createElement("cell");
						    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4InfoMap.get("ConItemList")))); // Connection List
						    	        row.appendChild(cell);
						    	        
								        cell = doc.createElement("cell");
								        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4InfoMap.get("TeamNm")))); // TeamNm
								        row.appendChild(cell);
								        
								        cell = doc.createElement("cell");
								        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4InfoMap.get("AuthorNm")))); // AuthorNm
								        row.appendChild(cell);
									    
								        cell = doc.createElement("cell");
								        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4InfoMap.get("Version")))); // Version
								        row.appendChild(cell);
								        
								        setCSMap.put("itemID", L4InfoMap.get("ItemID"));
								        setCSMap.put("status", "CLS");
								        setCSMap.put("version", L4InfoMap.get("Version"));
										maxValidFrom = commonService.selectString("cs_SQL.getItemValidFrom", setCSMap);
								        cell = doc.createElement("cell");
								        cell.appendChild(doc.createTextNode(StringUtil.checkNull(maxValidFrom))); // maxValidFrom
								        row.appendChild(cell);
								        
						    	        setMap.put("fromItemID", L4InfoMap.get("ItemID"));
						    	        List L5ItemList = commonService.selectList("custom_SQL.zhwc_ItemConnectionList_gridList", setMap);
						    	        
						    	        if(L5ItemList != null && !L5ItemList.isEmpty()) {
						    	        	for(int l=0; l<L5ItemList.size(); l++) {
						    	        		
						    	        		Map L5InfoMap = (Map)L5ItemList.get(l);
						    	        		
								    	        row = doc.createElement("row"); 
								    	        rootElement.appendChild(row); 
								    	        row.setAttribute("id", String.valueOf(rowId));
			
								    	        cell = doc.createElement("cell");
								    	        cell.appendChild(doc.createTextNode("L5")); // RowNum
								    	        row.appendChild(cell);
								    	        rowId++;
			
								    	        cell = doc.createElement("cell");
								    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L5InfoMap.get("Identifier")))); // L5 ID
								    	        row.appendChild(cell);
								    	        
								    	        cell = doc.createElement("cell");
								    	        cell.appendChild(doc.createTextNode("")); // L1 Name
								    	        row.appendChild(cell);
								    	        
								    	        cell = doc.createElement("cell");
								    	        cell.appendChild(doc.createTextNode("")); // L2 Name
								    	        row.appendChild(cell);
								    	        
								    	        cell = doc.createElement("cell");
								    	        cell.appendChild(doc.createTextNode("")); // L3 Name
								    	        row.appendChild(cell);
								    	        
								    	        cell = doc.createElement("cell");
								    	        cell.appendChild(doc.createTextNode("")); // L4 Name
								    	        row.appendChild(cell);
								    	        
								    	        cell = doc.createElement("cell");
								    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L5InfoMap.get("PlainText")))); // L5 Name
								    	        row.appendChild(cell);
								    	        
								    	        cell = doc.createElement("cell");
								    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L5InfoMap.get("FileList")))); // FileList
								    	        row.appendChild(cell);
								    	        cell = doc.createElement("cell");
								    	        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L5InfoMap.get("ConItemList")))); // Connection List
								    	        row.appendChild(cell);
								    	        
										        cell = doc.createElement("cell");
										        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L5InfoMap.get("TeamNm")))); // TeamNm
										        row.appendChild(cell);
										        
										        cell = doc.createElement("cell");
										        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L5InfoMap.get("AuthorNm")))); // AuthorNm
										        row.appendChild(cell);
											    
										        cell = doc.createElement("cell");
										        cell.appendChild(doc.createTextNode(StringUtil.checkNull(L5InfoMap.get("Version")))); // Version
										        row.appendChild(cell);
										        
										        setCSMap.put("itemID", L5InfoMap.get("ItemID"));
										        setCSMap.put("status", "CLS");
										        setCSMap.put("version", L5InfoMap.get("Version"));
												maxValidFrom = commonService.selectString("cs_SQL.getItemValidFrom", setCSMap);
										        cell = doc.createElement("cell");
										        cell.appendChild(doc.createTextNode(StringUtil.checkNull(maxValidFrom))); // maxValidFrom
										        row.appendChild(cell);
								    	        
						    	        	}
					    	        
						    	        }   	
				    	        	}
				    	        
				    	        }   	
				    	        
		    	        	}
		    	        
		    	        }   		    
		    	        
		        	}
		        }
		        
		        
		        TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
		        Transformer transformer = transformerFactory.newTransformer(); 
		        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
			    transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
			    DOMSource source = new DOMSource(doc); 	    
			    StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName))); 
			    transformer.transform(source, result); 
			}	
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/custom/hanwha/hwc/report/zhwc_ItemConnectionList");
	}
	
	/**
	 * ProcessHWC 통계 (2016/12/12)
	 * TW_PROCESS 테이블의 데이터 이용
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value="/mainSttProcessHWC.do")
	public String mainSttProcessHWC(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		
		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType")));
			String filepath = request.getSession().getServletContext().getRealPath("/");
			/* xml 파일명 설정 */
	        String xmlFilName = "upload/mainSttProcessHWC.xml";
	        String header = "";
	        
	        /* update 버튼 클릭으로 본 엑션을 호출한 경우 Process Insert procedure를 기동한다 */
	        if (!StringUtil.checkNull(request.getParameter("eventMode")).isEmpty()) {
	        	 commonService.insert("analysis_SQL.insertTwProcess", setMap);
	        }
	       
			setMap.put("languageID", languageID);
			setMap.put("LanguageID", languageID);
		
			// get Level1 NameList (grid header표시용)
	     	List level1NameList = commonService.selectList("analysis_SQL.getLevel1Name", setMap);
	        setProcessStatisticsData(filepath, level1NameList, xmlFilName, setMap, request);
	    
	        model.put("xmlFilName", xmlFilName);
			model.put("menu", getLabel(request, commonService));
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/cusotm/hanwha/hwc/report/procCount");
	}
	
	/**
	 * Process 통계에 표시할 내용을 xml 파일로 생성
	 * @param filepath
	 * @param prcCountList
	 * @param level1NameList
	 * @param xmlFilName
	 * @param setMap
	 * @throws ExceptionUtil
	 */
	private void setProcessStatisticsData(String filepath, List level1NameList, String xmlFilName, Map setMap, HttpServletRequest request) throws ExceptionUtil {
		Map processCntMap = new HashMap();
		List<Map<String, String>> processCNTList = new ArrayList<Map<String, String>>();
        int rNum = 1;
        int L2CNT_TOTAl = 0;
        int L3CNT_TOTAl = 0;
        int L4CNT_TOTAl = 0;
        int L5CNT_TOTAl = 0;
        int L4NACNT_TOTAl = 0;
        int L4PROCNT_TOTAl = 0;
        int L4COMCNT_TOTAl = 0;
        int L4APPCNT_TOTAl = 0;
        try {
	        Map setData = new HashMap();
	        setData.put("itemClassCode", "CL01002"); // L2
	        setData.put("languageID", setMap.get("languageID"));
	        List L2List = commonService.selectList("analysis_SQL.getProcessCNTList", setData);
	        
	        setData.put("itemClassCode", "CL01004");//L3
	        List L3List = commonService.selectList("analysis_SQL.getProcessCNTList", setData);
	        
	        setData.put("itemClassCode", "CL01005");//L4
	        List L4List = commonService.selectList("analysis_SQL.getProcessCNTList", setData);
	        
	        setData.put("itemClassCode", "CL01006");//L5
	        List L5List = commonService.selectList("analysis_SQL.getProcessCNTList", setData);
	        
	        // getProcessATVCNTList
	        List AtivityList = commonService.selectList("analysis_SQL.getProcessATVCNTList", setData);
	      
	        int NACNT = 0;
	        int L4CNT = 0;
	        int L4PROCNT = 0;
	        int L4COMCNT = 0;
	        int L4APPCNT = 0;
	
			for (int i = 0; i < level1NameList.size(); i++) {
	        	Map<String, String> rowMap = new HashMap<String, String>();
	        	Map L1Item = (Map) level1NameList.get(i);
	        	        	        	
	        	rowMap.put("rNum", String.valueOf(rNum));        	
	        	rowMap.put("L1ItemName", String.valueOf(L1Item.get("label")));  
	        	
	        	Map L2Map = (Map)L2List.get(i);
	        	Map L3Map = (Map)L3List.get(i);
	        	Map L4Map = (Map)L4List.get(i);   
	        	Map L5Map = (Map)L5List.get(i);   
	        	Map AtivityListMap = (Map)AtivityList.get(i);        	
	        	
	        	rowMap.put("L2CNT", String.valueOf(L2Map.get("PRCCNT2")));  
	        	rowMap.put("L3CNT", String.valueOf(L3Map.get("PRCCNT2")));
	        	rowMap.put("L4CNT", String.valueOf(L4Map.get("PRCCNT2")));
	        	rowMap.put("L5CNT", String.valueOf(L5Map.get("PRCCNT2")));
	        	
	        	L4CNT = Integer.parseInt(String.valueOf(AtivityListMap.get("L4CNT")));
	        	L4PROCNT =  Integer.parseInt(String.valueOf(AtivityListMap.get("L4PROCNT"))); 
	        	L4COMCNT =  Integer.parseInt(String.valueOf(AtivityListMap.get("L4COMCNT"))); 
	        	L4APPCNT =  Integer.parseInt(String.valueOf(AtivityListMap.get("L4APPCNT"))); 
	        	NACNT = L4CNT -(L4PROCNT+L4COMCNT+L4APPCNT);
	        	rowMap.put("L4NACNT", String.valueOf(NACNT));
	        	
	        	rowMap.put("L4PROCNT", String.valueOf(AtivityListMap.get("L4PROCNT")));
	        	rowMap.put("L4COMCNT", String.valueOf(AtivityListMap.get("L4COMCNT")));
	        	rowMap.put("L4APPCNT", String.valueOf(AtivityListMap.get("L4APPCNT")));
	        	processCNTList.add(rowMap);
	        	rNum++;
	        	
	        	L2CNT_TOTAl = L2CNT_TOTAl + Integer.parseInt(String.valueOf(L2Map.get("PRCCNT2")));
		        L3CNT_TOTAl = L3CNT_TOTAl + Integer.parseInt(String.valueOf(L3Map.get("PRCCNT2")));
		        L4CNT_TOTAl = L4CNT_TOTAl + Integer.parseInt(String.valueOf(L4Map.get("PRCCNT2")));
		        L5CNT_TOTAl = L5CNT_TOTAl + Integer.parseInt(String.valueOf(L5Map.get("PRCCNT2")));
		        L4NACNT_TOTAl = L4NACNT_TOTAl + NACNT;
		        L4PROCNT_TOTAl = L4PROCNT_TOTAl + L4PROCNT;
		        L4COMCNT_TOTAl = L4COMCNT_TOTAl + L4COMCNT;
		        L4APPCNT_TOTAl =  L4APPCNT_TOTAl + L4APPCNT;
	        }
	        
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance(); 
		    DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		    
		    Document doc = docBuilder.newDocument(); 
		    Element rootElement = doc.createElement("rows"); 
		    doc.appendChild(rootElement); 
		    int rowId = 1;
		    for (int i = 0; i < processCNTList.size(); i++) {	    	
		    	Map<String, String> pwCNTRowMap = processCNTList.get(i);
	        	        	
	        	// row 엘리먼트 
		        Element row = doc.createElement("row"); 
		        rootElement.appendChild(row); 
		        row.setAttribute("id", String.valueOf(rowId));
		        rowId++;
		        
		        Element cell = doc.createElement("cell"); 
		        cell = doc.createElement("cell"); 
	        	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L1ItemName"))));
	        	cell.setAttribute("style", "text-align:left;");
	        	row.appendChild(cell);
	        	
	        	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L2CNT"))));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	        	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L3CNT"))));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L4CNT"))));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L5CNT"))));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L4NACNT"))));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L4PROCNT"))));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L4COMCNT"))));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L4APPCNT"))));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);        	
	        	
		    }
		    
		    	// Total
		        Element row = doc.createElement("row"); 
		        rootElement.appendChild(row); 
		        row.setAttribute("id", String.valueOf(rowId));
		        rowId++;
		        
		        Element cell = doc.createElement("cell"); 
		        cell = doc.createElement("cell"); 
	        	cell.appendChild(doc.createTextNode("Total"));
	        	cell.setAttribute("style", "text-align:left;");
	        	row.appendChild(cell);
	        	
	        	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(L2CNT_TOTAl)));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	        	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(L3CNT_TOTAl)));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4CNT_TOTAl)));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	        	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(L5CNT_TOTAl)));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4NACNT_TOTAl)));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4PROCNT_TOTAl)));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4COMCNT_TOTAl)));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4APPCNT_TOTAl)));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);  
		    
		    // XML 파일로 쓰기 
	        TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
	        Transformer transformer = transformerFactory.newTransformer(); 
	 
	        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
		    transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
		    DOMSource source = new DOMSource(doc); 
		    
		    StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName))); 
		    transformer.transform(source, result); 
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
	}
	
	/**
	 * teamProcessHWC 통계 (2016/12/12)
	 * TW_PROCESS 테이블의 데이터 이용
	 * @param request
	 * @param model
	 * @return
	 * @throws ExceptionUtil
	 */
	@RequestMapping(value="/mainSttTeamProcessHWC.do")
	public String mainSttTeamProcessHWC(HttpServletRequest request, HashMap commandMap, ModelMap model) throws ExceptionUtil {
		
		Map setMap = new HashMap();
		try {
			String languageID = StringUtil.checkNull(request.getParameter("languageID"), String.valueOf(commandMap.get("sessionCurrLangType")));
			String filepath = request.getSession().getServletContext().getRealPath("/");
			/* xml 파일명 설정 */
	        String xmlFilName = "upload/mainTeamProcessHWC.xml";
	        String header = "";
	        
	        /* update 버튼 클릭으로 본 엑션을 호출한 경우 Process Insert procedure를 기동한다 */
	        if (!StringUtil.checkNull(request.getParameter("eventMode")).isEmpty()) {
	        	 commonService.insert("analysis_SQL.insertTwProcess", setMap);
	        }
	       
			setMap.put("languageID", languageID);
			setMap.put("LanguageID", languageID);
		
			// get Level1 NameList (grid header표시용)
			setMap.put("itemClassCode", "CL01005");
	     	List processTeamList = commonService.selectList("analysis_SQL.getProcessTeamName", setMap);
	        setTeamProcessStatisticsData(filepath, processTeamList, xmlFilName, setMap, request);
	    
	        model.put("mainTeamProcessHWCFilName", xmlFilName);
			model.put("menu", getLabel(request, commonService));
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		
		return nextUrl("/cusotm/hanwha/hwc/report/procCountByTeam");
	}
	
	/**
	 * Process 통계에 표시할 내용을 xml 파일로 생성
	 * @param filepath
	 * @param prcCountList
	 * @param level1NameList
	 * @param xmlFilName
	 * @param setMap
	 * @throws ExceptionUtil
	 */
	private void setTeamProcessStatisticsData(String filepath, List processList, String xmlFilName, Map setMap, HttpServletRequest request) throws ExceptionUtil {
		Map processCntMap = new HashMap();
		List<Map<String, String>> processCNTList = new ArrayList<Map<String, String>>();
        int rNum = 1;
        int PRCCNT_TOTAl = 0;
        int L4NACNT_TOTAl = 0;
        int L4PROCNT_TOTAl = 0;
        int L4COMCNT_TOTAl = 0;
        int L4APPCNT_TOTAl = 0;
        
        int NACNT = 0;
        int L3CNT = 0;
        int L4CNT = 0;
        int L5CNT = 0;
        int L4PROCNT = 0;
        int L4COMCNT = 0;
        int L4APPCNT = 0;
        int L4PRCCNT = 0;
        int L4PROC_CNT_TOTAl= 0;
        int L3PROCNT_TOTAl = 0;
        int L5PROCNT_TOTAl = 0;
        try {
        	
        	Map setData = new HashMap();
        	setData.put("languageID", setMap.get("languageID"));
	        setData.put("itemClassCode", "CL01004"); // L3
	        List L3List = commonService.selectList("analysis_SQL.getLVProcessByTeamName", setData);
	        
	        setData.put("itemClassCode", "CL01005"); // L4
	        List L4List = commonService.selectList("analysis_SQL.getLVProcessByTeamName", setData);
	        
	        setData.put("itemClassCode", "CL01006"); // L5
	        List L5List = commonService.selectList("analysis_SQL.getLVProcessByTeamName", setData);
	        
        	for (int i = 0; i < processList.size(); i++) {
	        	Map<String, String> rowMap = new HashMap<String, String>();
	        	Map procMap = (Map) processList.get(i);
	        	
	        	Map L3Map = (Map)L3List.get(i);
	        	Map L4Map = (Map)L4List.get(i);   
	        	Map L5Map = (Map)L5List.get(i);  
	        	        	        	
	        	rowMap.put("rNum", String.valueOf(rNum));        	
	        	rowMap.put("TeamName", String.valueOf(procMap.get("TeamName"))); 
	        	rowMap.put("L3PRCCNT", String.valueOf(L3Map.get("LPRCCNT"))); 
	        	rowMap.put("L4PRCCNT", String.valueOf(L4Map.get("LPRCCNT"))); 
	        	rowMap.put("L5PRCCNT", String.valueOf(L5Map.get("LPRCCNT"))); 
	 
	        	rowMap.put("L4PROCNT", String.valueOf(procMap.get("L4PROCNT"))); 
	        	rowMap.put("L4COMCNT", String.valueOf(procMap.get("L4COMCNT"))); 
	        	rowMap.put("L4APPCNT", String.valueOf(procMap.get("L4APPCNT"))); 
	        	
	        	L3CNT = Integer.parseInt(String.valueOf(L3Map.get("LPRCCNT")));
	        	L4CNT = Integer.parseInt(String.valueOf(L4Map.get("LPRCCNT")));
	        	L5CNT = Integer.parseInt(String.valueOf(L5Map.get("LPRCCNT")));
	        	
	        	L4PRCCNT = Integer.parseInt(String.valueOf(procMap.get("PRCCNT")));
	        	L4PROCNT =  Integer.parseInt(String.valueOf(procMap.get("L4PROCNT"))); 
	        	L4COMCNT =  Integer.parseInt(String.valueOf(procMap.get("L4COMCNT"))); 
	        	L4APPCNT =  Integer.parseInt(String.valueOf(procMap.get("L4APPCNT"))); 
	        	NACNT = L4PRCCNT -(L4PROCNT+L4COMCNT+L4APPCNT);
	        	rowMap.put("L4NACNT", String.valueOf(NACNT));
	        	
	        	processCNTList.add(rowMap);
	        	
	        	PRCCNT_TOTAl = PRCCNT_TOTAl + L4CNT;
	        	
	        	L3PROCNT_TOTAl = L3PROCNT_TOTAl + L3CNT;
	        	L4PROC_CNT_TOTAl = L4PROC_CNT_TOTAl + L4CNT;
	        	L5PROCNT_TOTAl = L5PROCNT_TOTAl + L5CNT;
	        	
	        	L4PROCNT_TOTAl = L4PROCNT_TOTAl + L4PROCNT;
		        L4COMCNT_TOTAl = L4COMCNT_TOTAl + L4COMCNT;
		        L4APPCNT_TOTAl = L4APPCNT_TOTAl + L4APPCNT;
		        L4NACNT_TOTAl = L4NACNT_TOTAl + NACNT;
		        
		        rNum++;
	        }
	        
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance(); 
		    DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		    
		    Document doc = docBuilder.newDocument(); 
		    Element rootElement = doc.createElement("rows"); 
		    doc.appendChild(rootElement); 
		    int rowId = 1;
		    for (int i = 0; i < processCNTList.size(); i++) {	    	
		    	Map<String, String> pwCNTRowMap = processCNTList.get(i);
	        	        	
	        	// row 엘리먼트 
		        Element row = doc.createElement("row"); 
		        rootElement.appendChild(row); 
		        row.setAttribute("id", String.valueOf(rowId));
		        rowId++;
		        
		        Element cell = doc.createElement("cell"); 
	        	
	        	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("TeamName"))));
	         	cell.setAttribute("style", "text-align:left;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L3PRCCNT"))));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L4PRCCNT"))));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L5PRCCNT"))));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         		         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L4NACNT"))));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	        	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L4PROCNT"))));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L4COMCNT"))));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
	         	
	         	cell = doc.createElement("cell"); 
	         	cell.appendChild(doc.createTextNode(StringUtil.checkNull(pwCNTRowMap.get("L4APPCNT"))));
	         	cell.setAttribute("style", "text-align:right;");
	         	row.appendChild(cell);
		    }
		    
	    	// Total
	        Element row = doc.createElement("row"); 
	        rootElement.appendChild(row); 
	        row.setAttribute("id", String.valueOf(rowId));
	        rowId++;
	        
	        Element cell = doc.createElement("cell"); 
	        cell = doc.createElement("cell"); 
	    	cell.appendChild(doc.createTextNode("Total"));
	    	cell.setAttribute("style", "text-align:left;");
	    	row.appendChild(cell);
	    	
	    	cell = doc.createElement("cell"); 
	     	cell.appendChild(doc.createTextNode(StringUtil.checkNull(L3PROCNT_TOTAl)));
	     	cell.setAttribute("style", "text-align:right;");
	     	row.appendChild(cell);
	     	
	     	cell = doc.createElement("cell"); 
	     	cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4PROC_CNT_TOTAl)));
	     	cell.setAttribute("style", "text-align:right;");
	     	row.appendChild(cell);
	     	
	     	cell = doc.createElement("cell"); 
	     	cell.appendChild(doc.createTextNode(StringUtil.checkNull(L5PROCNT_TOTAl)));
	     	cell.setAttribute("style", "text-align:right;");
	     	row.appendChild(cell);
	     	
	    	cell = doc.createElement("cell"); 
	     	cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4NACNT_TOTAl)));
	     	cell.setAttribute("style", "text-align:right;");
	     	row.appendChild(cell);
	     	
	     	cell = doc.createElement("cell"); 
	     	cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4PROCNT_TOTAl)));
	     	cell.setAttribute("style", "text-align:right;");
	     	row.appendChild(cell);
	     	
	     	cell = doc.createElement("cell"); 
	     	cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4COMCNT_TOTAl)));
	     	cell.setAttribute("style", "text-align:right;");
	     	row.appendChild(cell);
	     	
	     	cell = doc.createElement("cell"); 
	     	cell.appendChild(doc.createTextNode(StringUtil.checkNull(L4APPCNT_TOTAl)));
	     	cell.setAttribute("style", "text-align:right;");
	     	row.appendChild(cell);
		    
		    // XML 파일로 쓰기 
	        TransformerFactory transformerFactory = TransformerFactory.newInstance(); 
	        Transformer transformer = transformerFactory.newTransformer(); 
	 
	        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8"); 
		    transformer.setOutputProperty(OutputKeys.INDENT, "yes");        
		    DOMSource source = new DOMSource(doc); 
		    
		    StreamResult result = new StreamResult(new FileOutputStream(new File(filepath + xmlFilName))); 
		    transformer.transform(source, result); 
        } catch(Exception e) {
        	throw new ExceptionUtil(e.toString());
        }
		
	}
	/*
	@Resource(name="orclSession")
	private SqlSession orclSession;
	
	@RequestMapping(value="/custom/zhwas_exeHRinterface.do")
	public void zhwas_exeHRinterface() throws Exception {
		HashMap setMap = new HashMap();
		
		System.out.println("start zhwas_exeHRinterface");
		try{
			zhwas_truncateEmployee();
			List employeeList = zhwas_selectEmployeeList();
			zhwas_insertEmployee(employeeList);
			
			zhwas_truncateOrganization();
			List organizationList = zhwas_selectOrganizationList();
			zhwas_insertOrganization(organizationList);
			
			zhwas_exeHRProcedure();

			System.out.println("end zhwas_exeHRinterface");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("HanwhaActionController::getEmployeeList::Error::"+e);}
			//throw e;
		}	
	}
	
	public void zhwas_exeHRProcedure() {
		HashMap setMap = new HashMap();
		String procedureName = StringUtil.checkNull(GlobalVal.HR_IF_PROC);
		setMap.put("procedureName", "XBOLTADM."+procedureName);
		try{ 			
			commonService.insert("organization_SQL.insertHRTeamInfo", setMap);
			System.out.println("zhwas_exeHRProcedure");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("HanwhaActionController::zhwas_exeHRProcedure::Error::"+e);}
			//throw e;
		}	
	}
	
	
	public List zhwas_selectEmployeeList() throws Exception {
		HashMap setMap = new HashMap();
		List mapList = new ArrayList();

		try{
			mapList = orclSession.selectList("hwas_ORASQL.zhwas_selectEmployeeList", setMap);
			System.out.println("hwas_ORASQL.zhwas_selectEmployeeList");
			
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("HanwhaActionController::getEmployeeList::Error::"+e);}
			//throw e;
		}
		return mapList;	
	}
	
	public void zhwas_truncateEmployee() {
		HashMap setMap = new HashMap();
		
		try{ 			
			commonService.delete("custom_SQL.zhwas_truncateEmployee", setMap);
			System.out.println("custom_SQL.zhwas_truncateEmployee");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("HanwhaActionController::truncateEmployee::Error::"+e);}
			//throw e;
		}	
		
	}
	
	public void zhwas_insertEmployee(List mapList) {
		HashMap setMap = new HashMap();
		try{ 			
			for(int i=0; i<mapList.size(); i++) {
				setMap = (HashMap) mapList.get(i);
				commonService.insert("custom_SQL.zhwas_insertEmployee", setMap);
			}
			System.out.println("custom_SQL.zhwas_insertEmployee");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("HanwhaActionController::insertEmployeeList::Error::"+e);}
			//throw e;
		}	
	}
	
	public List zhwas_selectOrganizationList() throws Exception {
		HashMap setMap = new HashMap();
		List mapList = new ArrayList();

		try{
			mapList = orclSession.selectList("hwas_ORASQL.zhwas_selectOrganizationList", setMap);
			System.out.println("hwas_ORASQL.zhwas_selectOrganizationList");
			
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("HanwhaActionController::getOrganizationList::Error::"+e);}
			//throw e;
		}
		return mapList;	
	}
	
	public void zhwas_truncateOrganization() {
		HashMap setMap = new HashMap();
		
		try{ 			
			commonService.delete("custom_SQL.zhwas_truncateOrganization", setMap);
			System.out.println("custom_SQL.zhwas_truncateOrganization");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("HanwhaActionController::truncateOrganization::Error::"+e);}
			//throw e;
		}	
		
	}
	
	public void zhwas_insertOrganization(List mapList) {
		HashMap setMap = new HashMap();
		try{ 			
			for(int i=0; i<mapList.size(); i++) {
				setMap = (HashMap) mapList.get(i);
				commonService.insert("custom_SQL.zhwas_insertOrganization", setMap);
			}
			System.out.println("custom_SQL.zhwas_insertOrganization");
		} catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("HanwhaActionController::insertOrganizationList::Error::"+e);}
			//throw e;
		}	
	}
	*/
}
