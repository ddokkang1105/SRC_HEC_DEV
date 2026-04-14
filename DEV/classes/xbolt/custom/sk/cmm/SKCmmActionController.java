package xbolt.custom.sk.cmm;

import java.io.BufferedReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.AESUtil;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.SessionConfig;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;
import xbolt.custom.sk.cmm.ldap.LdapUserChecker;


@Controller
@SuppressWarnings("unchecked")
public class SKCmmActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;
	private AESUtil aesAction;
	
	/*
	 * 로그인 화면 구성
		1. 법인 선택
		  -. 본사/미주 : SKO, SKBA
		  -. 유럽 : SKOH, SKBM
		  -. 중국 : SKOY, SKOJ. SKOS
		  ※ 최종 로그인 법인이 저장되어 있는 경우, 자동 선택
		2. 입력 필드 : ID/PW/인증번호
		3. 인증번호 요청 버튼
		  -. 입력한 법인/사번의 사내 이메일로 인증번호 발송 
		4. SSO or LOGIN 선택하여 진행
		  -. 본사 ILM 법인은 SSO/LDAP Login 가능 (SKO, SKBA, SKOS)
		  -. 기타, 유럽/중국 해외 법인은 LDAP 으로만 Login 가능 
		     -> 기타 해외 법인 선택시, SSO 버튼 비활성화
		     
		사용자 로그인 화면 진입시, 최종 로그인 법인 정보가 존재하는 경우
		   1) SSO 적용 법인 -> SSO 자동 로그인
		   2) SSO 미적용 법인 -> 최종 로그인 법인 자동 선택
		   
		
		사용자 로그인 화면 진입시, 최종 로그인 법인 정보 미존재하는 경우
   		-. 사용자가 Login 화면에서 내용 이력 후 Sso/Login 절차에 따라 진행
   		
   		사용자 로그인 완료시
  		-. 선택한 법인 저장 (* 최종 로그인 법인 정보 저장, 쿠키/DB 모두 저장)
  		
  		사용자 로그 아웃시 (* 메인 화면 상단, 공통 기능 버튼)
		  -. 로그인 화면으로 이동
		  -. 자동 로그인 하지 않고, 사용자가 법인 변경 후 Sso/Login 선택하여 진행
		  
		* 선택된 법인이 SSO 적용 가능 법인인 경우, SSO 로그인을 진행함.
  			-. 본사 그룹웨어와 연동하여, SSO 로그인 진행
  		
  		LDAP Login 시, 2-pactor 인증 진행
		  1) 법인/ID 에 해당하는 사용자에게 사내이메일로 인증번호 발송
		    -> 인증번호 유효시간은 5분
		  2) 사용자가 인증번호 확인 후 Login 화면에서 입력
		  3) 인증번호 Validation 진행
		  4) 인증번호 정상 확인 후, LDAP 인증
  		
  		LDAP Login 5회 연속 실패시, 사용자 로그인 제한(lock)
  			-. 접속제한 해제는 시스템 관리자가 사용자 정보에서 unlock 처리
  			
  		사용자 중복 로그인시, 기존 연결된 세션 종료
  		
  		
  		
  		* 법인 LDAP 서버와 연동하여, ID/PW 인증결과 수신
  		
	 * 
	 * */
	
	@RequestMapping(value = "/custom/sk/loginAuth.do")
	 public String loginAuth(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		 HttpSession session = request.getSession(true);
		  model=setLoginScrnInfo(model,cmmMap);
		  Map loginInfo = (Map)session.getAttribute("loginInfo");
		  model.put("skSSO", StringUtil.checkNull(cmmMap.get("skSSO"),""));
		  model.put("linkUrl", StringUtil.checkNull(cmmMap.get("linkUrl"),""));
//		  if(loginInfo != null && !loginInfo.isEmpty()) {
//				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 구분
//				model.put("skSSO", "Y");
//		  }
		  
		  String fromProxy = StringUtil.checkNull(request.getParameter("path"));
		  model.put("path", fromProxy);
		  
		  Map setMap = new HashMap();
		  setMap.put("languageID", StringUtil.checkNull(cmmMap.get("languageID"), GlobalVal.DEFAULT_LANGUAGE));
		  setMap.put("teamType", "2");
//		  List companyList = commonService.selectList("common_SQL.getTeam_commonSelect", setMap);
		  
		  model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
		  model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
		  model.put("wfInstanceID", StringUtil.checkNull(cmmMap.get("wfInstanceID"),""));
		  model.put("keepLoginYN", StringUtil.checkNull(cmmMap.get("keepLoginYN"),""));
		  model.put("defArcCode", StringUtil.checkNull(cmmMap.get("defArcCode"),""));
//		  model.put("companyList",companyList);
		  
		  return nextUrl("/custom/sk/cmm/loginAuth");
	  }

	 private ModelMap setLoginScrnInfo(ModelMap model,HashMap cmmMap) throws ExceptionUtil {
		  String pass = StringUtil.checkNull(cmmMap.get("pwd"));
		  try {
			  //String pass = URLDecoder.decode(StringUtil.checkNull(cmmMap.get("pwd")), "UTF-8");
			  model.addAttribute("loginid",StringUtil.checkNull(cmmMap.get("loginid"), ""));
			  model.addAttribute("pwd",pass);
			  model.addAttribute("lng",StringUtil.checkNull(cmmMap.get("lng"), ""));
			  		  
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
			  model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
         } catch(Exception e) {
       	 throw new ExceptionUtil(e.toString());
         }
		  
		  return model;
	 	}
	 
	 @RequestMapping(value = "/custom/sk/loginCheck.do")
		public String loginCheck(ModelMap model, HashMap cmmMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
			try {
				Map resultMap = new HashMap();
				String langCode = GlobalVal.DEFAULT_LANG_CODE;
				String IS_CHECK = GlobalVal.PWD_CHECK;
				String PWD_ENCODING = (GlobalVal.PWD_ENCODING).toUpperCase();
				String pwd = (String) cmmMap.get("PASSWORD");
				
				String skSSO = StringUtil.checkNull(cmmMap.get("skSSO"));
				
				Map setData = new HashMap();
				Map idInfo = commonService.select("login_SQL.login_id_select", cmmMap);
				
				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
				
				request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
				String ip = request.getHeader("X-FORWARDED-FOR");
		        if (ip == null) ip = request.getRemoteAddr();
		        
		        // 멤버테이블에서 loginID로 조회되지 않는 경우
				if(idInfo == null || idInfo.size() == 0) {
					setData.put("ActionType", "LOGIN");
					setData.put("IpAddress",ip);
					setData.put("sessionUserId",-1);
			        commonService.insert("gloval_SQL.insertVisitLog", setData);
			        
					resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
					//resultMap.put(AJAX_ALERT, "해당아이디가 존재하지 않습니다.");
					resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));				
				} else {
					aesAction = new AESUtil();
					cmmMap.put("LOGIN_ID", idInfo.get("LoginId"));
					
					cmmMap.put("IS_CHECK", "N");
					
					if(skSSO.equals("Y")) {
						cmmMap.put("IS_CHECK", "N");
					} else {
						
						if("Y".equals(PWD_ENCODING)) {
							aesAction.setIV(request.getParameter("iv"));
							aesAction.setSALT(request.getParameter("salt"));
							
							pwd =  aesAction.decrypt(pwd);
												
							aesAction.init();
							
							pwd = aesAction.encrypt(pwd);
						}

						cmmMap.put("PASSWORD", pwd);
					}
					cmmMap.put("active", "1");
					
					//2025-02-17 sk 로그인 DefLanguageID default 1 >> 1042(한국어)
					//Map loginInfo = commonService.select("login_SQL.login_select", cmmMap);
					Map loginInfo = commonService.select("zSK_SQL.login_select", cmmMap);
					
					// 멤버테이블에는 있는데, active = 1인 멤버가 없는 경우 (Lock 걸린 경우)
					if(loginInfo == null || loginInfo.size() == 0) {
//						resultMap.put(AJAX_SCRIPT, "parent.fnReloadLock()");
//						resultMap.put(AJAX_SCRIPT, "parent.fnReload('N')");
//						resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));
						resultMap.put(AJAX_SCRIPT, "parent.deactive()");
					} else {
						// 운영서버용
						boolean ldapCheck = false;
						if(!skSSO.equals("Y")) {	// ldap 로그인
								// [LDAP의 경우 인증]
								String ldapID = StringUtil.checkNull(cmmMap.get("LOGIN_ID"));
								String siteCode = StringUtil.checkNull(loginInfo.get("sessionClientId"));
						
								if(!"".equals(siteCode)) ldapCheck = LdapUserChecker.isLdapUser(ldapID,pwd,siteCode);
								System.out.println("ldapID ==== "+ldapID+" / "+pwd+" / "+siteCode);
								System.out.println("ldapCheck ==== "+ldapCheck);
								if(ldapCheck) {
									if(StringUtil.checkNull(cmmMap.get("authStep")).equals("")) {
										// 인증번호 발송
//										resultMap.put(AJAX_SCRIPT, "parent.fnPossibleAuth()");
										// 수정 start
										String message = requestUserAuth(request, cmmMap);
										resultMap.put(AJAX_SCRIPT, "alert('"+message+"');parent.document.querySelector('#login-btn').disabled = false; parent.document.querySelector('#authNumber').disabled = false; parent.document.querySelector('#authStep').value = 'Y'");
										// 수정 end
									} else {
										// 인증번호 체크
										setData.put("loginID", cmmMap.get("LOGIN_ID"));
										setData.put("actionType", "AUTH");
										Map authMap =  commonService.select("gloval_SQL.getVisitLogComment", setData);
										String authNumber = StringUtil.checkNull(authMap.get("Comment"));
										String authTime = StringUtil.checkNull(authMap.get("Time"));
										
										// 3분 유효시간 체크
										SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
										Date now = new Date();
										Date date1 = dateFormat.parse(authTime);
										
										// Date -> 밀리세컨즈 
							    		long timeMil1 = date1.getTime();
							    		long timeMil2 = now.getTime();
							    		// 비교 
							    		long diff = (timeMil2 - timeMil1) / 1000;
							    		
//							    		if(diff > 180) {
//							    			resultMap.put(AJAX_SCRIPT, "parent.authTimeOut()");
//							    		} else {
							    			if(!authNumber.equals(StringUtil.checkNull(cmmMap.get("authNumber")))) {
												resultMap.put(AJAX_SCRIPT, "parent.authFailed()");
											} else {
												// [Authority] < 4 인 경우, 수정가능하게 변경
												if(loginInfo.get("sessionAuthLev").toString().compareTo("4") < 0)	loginInfo.put("loginType", "editor");
												else	loginInfo.put("loginType", "viewer");	
												
												// 수정 start
//												resultMap.put(AJAX_SCRIPT, "parent.fnReload('Y')");
												resultMap.put(AJAX_SCRIPT, "parent.document.querySelector('#dfForm').action = '/mainpage.do?loginIdx=BASE'; parent.document.querySelector('#dfForm').submit()");
												// 수정 end
												
												loginInfo.put("ACC_MODE", "DEV");
												loginInfo.put("Secu_Lvl", GlobalVal.PRV_SECU_LVL);
												
												
												String session_duplicate = GlobalVal.SESSION_DUPLICATE;	
												String returnValue = "";
												String currSessionID = "";
												Map<String, Object> currSessionInfo = new HashMap<>();
												String sessionBrowser = "";
												String sessionIp = "";
												
												if(session_duplicate.equals("N")) { // session duplicate check
													String keepLoginYN = StringUtil.checkNull(request.getParameter("keepLoginYN"));
													if(keepLoginYN.equals("Y")) {
														returnValue = SessionConfig.getSessionCheck("login_id", StringUtil.checkNull(idInfo.get("LoginId")),"N","");	
													}else {
														currSessionInfo = SessionConfig.getSessionInfo("login_id", StringUtil.checkNull(idInfo.get("LoginId")),"Y");	
														System.out.println( "currSessionInfo" + currSessionInfo); // 선입자 session 정보 
														currSessionID =  StringUtil.checkNull(currSessionInfo.get("sessionId"));
														sessionBrowser = StringUtil.checkNull(currSessionInfo.get("sessionBrowser"));
														sessionIp = StringUtil.checkNull(currSessionInfo.get("sessionIpAddress")); 
													}
												}
												
												String browser 	 = "";
												String userAgent = StringUtil.checkNull(request.getHeader("User-Agent"));		
												
												if(userAgent.indexOf("Trident") > -1) {												// IE
													browser = "ie";
												} else if(userAgent.indexOf("Edge") > -1 || userAgent.indexOf("Edg") > -1) {											// Edge
													browser = "edge";
												} else if(userAgent.indexOf("Whale") > -1) { 										// Naver Whale
													browser = "whale";
												} else if(userAgent.indexOf("Opera") > -1 || userAgent.indexOf("OPR") > -1) { 		// Opera
													browser = "opera";
												} else if(userAgent.indexOf("Firefox") > -1) { 										 // Firefox
													browser = "firefox";
												} else if(userAgent.indexOf("Safari") > -1 && userAgent.indexOf("Chrome") == -1 ) {	 // Safari
													browser = "safari";		
												} else if(userAgent.indexOf("Chrome") > -1) {										 // Chrome	
													browser = "chrome";
												}
												
												HttpSession session = request.getSession(true);
												
												if((!currSessionID.equals("") && !sessionBrowser.equals(browser)) || (!currSessionID.equals("") && !sessionIp.equals(ip)) ) {
													String loginID = StringUtil.checkNull(request.getParameter("LOGIN_ID")); 
													String password = StringUtil.checkNull( request.getParameter("PASSWORD")); 
													String languageID = StringUtil.checkNull( request.getParameter("LANGUAGE")); 
													String loginIdx = StringUtil.checkNull(request.getParameter("loginIdx"));
													resultMap.put(AJAX_SCRIPT, "parent.fnConfirmDuplicateLogin('"+loginID+"','"+password+"','"+languageID+"','"+loginIdx+"')");
												} else {
													setData = new HashMap();						
													setData.put("ActionType", "LOGIN");
													setData.put("IpAddress", ip);
													setData.put("sessionUserId", loginInfo.get("sessionUserId"));
													setData.put("sessionTeamId", loginInfo.get("sessionTeamId"));
													commonService.insert("gloval_SQL.insertVisitLog", setData);	
													
													session.setAttribute("login_id", idInfo.get("LoginId"));
													session.setAttribute("loginInfo", loginInfo);
													session.setAttribute("sessionBrowser", browser);
													session.setAttribute("sessionIpAddress", ip);
												}
											}
//							    		}
									}
								} else {
									setData.put("ActionType", "PWDERR");
									setData.put("IpAddress",ip);
									setData.put("sessionUserId", idInfo.get("MemberID"));
									setData.put("comment", "FAIL");
							        commonService.insert("gloval_SQL.insertVisitLog", setData);
							        
							        // 5번이상 로그인 실패 시 Active = 0
							        setData.remove("ActionType");
							        setData.remove("IpAddress");
							        setData.put("top","5");
							        
							        List<Map> errList = commonService.selectList("gloval_SQL.getVisitLogLoginErrCount", setData);
							        int errCnt = errList.stream().filter(e -> StringUtil.checkNull(e.get("ActionType")).equals("PWDERR")).collect(Collectors.toList()).size();
									if(errCnt >= 5){
										setData.put("Active", "0");
										setData.put("MemberID",  idInfo.get("MemberID"));
										commonService.update("user_SQL.updateUser", setData);
										// lock 공지
										resultMap.put(AJAX_SCRIPT, "parent.fnReloadLock()");
//										resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00175"));
									} else {
//										resultMap.put(AJAX_SCRIPT, "parent.ldapFailed()");
										resultMap.put(AJAX_ALERT, MessageHandler.getMessage(langCode + ".WM00002"));
									}
								}
//							} else {
								
//							}
						} else { //sso 로그인
							// [Authority] < 4 인 경우, 수정가능하게 변경
							if(loginInfo.get("sessionAuthLev").toString().compareTo("4") < 0)	loginInfo.put("loginType", "editor");
							else	loginInfo.put("loginType", "viewer");	
							
							resultMap.put(AJAX_SCRIPT, "parent.fnReload('Y')");
							loginInfo.put("ACC_MODE", "DEV");
							loginInfo.put("Secu_Lvl", GlobalVal.PRV_SECU_LVL);
							
							
							String session_duplicate = GlobalVal.SESSION_DUPLICATE;	
							String returnValue = "";
							String currSessionID = "";
							Map<String, Object> currSessionInfo = new HashMap<>();
							String sessionBrowser = "";
							String sessionIp = "";
							
							if(session_duplicate.equals("N")) { // session duplicate check
								String keepLoginYN = StringUtil.checkNull(request.getParameter("keepLoginYN"));
								if(keepLoginYN.equals("Y")) {
									returnValue = SessionConfig.getSessionCheck("login_id", StringUtil.checkNull(idInfo.get("LoginId")),"N","");	
								}else {
									currSessionInfo = SessionConfig.getSessionInfo("login_id", StringUtil.checkNull(idInfo.get("LoginId")),"Y");	
									System.out.println( "currSessionInfo" + currSessionInfo); // 선입자 session 정보 
									currSessionID =  StringUtil.checkNull(currSessionInfo.get("sessionId"));
									sessionBrowser = StringUtil.checkNull(currSessionInfo.get("sessionBrowser"));
									sessionIp = StringUtil.checkNull(currSessionInfo.get("sessionIpAddress")); 
								}
							}
							
							String browser 	 = "";
							String userAgent = StringUtil.checkNull(request.getHeader("User-Agent"));		
							
							if(userAgent.indexOf("Trident") > -1) {												// IE
								browser = "ie";
							} else if(userAgent.indexOf("Edge") > -1 || userAgent.indexOf("Edg") > -1) {											// Edge
								browser = "edge";
							} else if(userAgent.indexOf("Whale") > -1) { 										// Naver Whale
								browser = "whale";
							} else if(userAgent.indexOf("Opera") > -1 || userAgent.indexOf("OPR") > -1) { 		// Opera
								browser = "opera";
							} else if(userAgent.indexOf("Firefox") > -1) { 										 // Firefox
								browser = "firefox";
							} else if(userAgent.indexOf("Safari") > -1 && userAgent.indexOf("Chrome") == -1 ) {	 // Safari
								browser = "safari";		
							} else if(userAgent.indexOf("Chrome") > -1) {										 // Chrome	
								browser = "chrome";
							}
							
							HttpSession session = request.getSession(true);
							
							if((!currSessionID.equals("") && !sessionBrowser.equals(browser)) || (!currSessionID.equals("") && !sessionIp.equals(ip)) ) {
								String loginID = StringUtil.checkNull(request.getParameter("LOGIN_ID")); 
								String password = StringUtil.checkNull( request.getParameter("PASSWORD")); 
								String languageID = StringUtil.checkNull( request.getParameter("LANGUAGE")); 
								String loginIdx = StringUtil.checkNull(request.getParameter("loginIdx"));
								resultMap.put(AJAX_SCRIPT, "parent.fnConfirmDuplicateLogin('"+loginID+"','"+password+"','"+languageID+"','"+loginIdx+"')");
							} else {
								setData = new HashMap();						
								setData.put("ActionType", "LOGIN");
								setData.put("IpAddress", ip);
								setData.put("sessionUserId", loginInfo.get("sessionUserId"));
								setData.put("sessionTeamId", loginInfo.get("sessionTeamId"));
								commonService.insert("gloval_SQL.insertVisitLog", setData);	
								
								session.setAttribute("login_id", idInfo.get("LoginId"));
								session.setAttribute("loginInfo", loginInfo);
								session.setAttribute("sessionBrowser", browser);
								session.setAttribute("sessionIpAddress", ip);
							}
						}
				}// ID INFO
					
				}
				model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx")));
				model.addAttribute(AJAX_RESULTMAP,resultMap);
			}
			catch (Exception e) {
				if(_log.isInfoEnabled()){_log.info("LoginActionController::loginbase::Error::"+e.toString().replaceAll("\r|\n", ""));}
				throw new ExceptionUtil(e.toString());
			}
			return nextUrl(AJAXPAGE);
		}
	 
	// 수정 start
	 public String  requestUserAuth(HttpServletRequest request, HashMap commandMap) throws Exception {
			HashMap cntsMap = new HashMap();
			Map setMailData = new HashMap();
			Map map = new HashMap();
			String emailCode = "LOGINAUTH";
			String langCode = GlobalVal.DEFAULT_LANG_CODE;	
			String message = "";
			
			try {
				// 요청 본문에서 JSON 데이터 읽기
				StringBuilder jsonBuilder = new StringBuilder();
				try (BufferedReader reader = request.getReader()) {
					String line;
					while ((line = reader.readLine()) != null) {
						jsonBuilder.append(line);
					}
				}
				
				// [01] 수신자 정보
				List receiverList = new ArrayList();
				Map loginInfo = commonService.select("login_SQL.login_select", commandMap);
				HttpSession session = request.getSession(true);
				session.setAttribute("loginInfo", loginInfo);
				
				if(loginInfo != null && !loginInfo.isEmpty()) {
					Map temp = new HashMap();
					temp.put("receiptUserID", loginInfo.get("sessionUserId"));
					receiverList.add(0,temp);
					setMailData.put("receiverList", receiverList);
					
					// [02] 메일 로그
					setMailData.put("EMAILCODE", emailCode);
					Map setMailMapRst = (Map)setEmailLog(request, commonService, setMailData, emailCode);
					System.out.println("setMailMapRst : "+setMailMapRst );
					
					// [03] 이메일 발송
			        cntsMap.put("emailCode", emailCode);
			        cntsMap.put("languageID", commandMap.get("LANGUAGE"));
			        String emailHTMLForm = StringUtil.checkNull(commonService.selectString("email_SQL.getEmailHTMLForm", cntsMap));
					// 6자리 난수 생성
			        String authNumber = StringUtil.checkNull(RandomStringUtils.randomNumeric(6));
			        cntsMap.put("authNumber", authNumber);
			        cntsMap.put("emailHTMLForm", emailHTMLForm);
			        
			        HashMap mailMap = (HashMap)setMailMapRst.get("mailLog");				
			        Map resultMailMap = EmailUtil.sendMail(mailMap, cntsMap, getLabel(request, commonService));
					System.out.println("SEND EMAIL TYPE:"+resultMailMap+ "Msg :" + StringUtil.checkNull(setMailMapRst.get("type")));
					
					// [04] visit log 테이블에 저장
					String ip = request.getHeader("X-FORWARDED-FOR");
			        if (ip == null) ip = request.getRemoteAddr();
			        
					map.put("ActionType", "AUTH");
					map.put("IpAddress", ip);
					map.put("sessionUserId", loginInfo.get("sessionUserId"));
					map.put("sessionTeamId", loginInfo.get("sessionTeamId"));
					map.put("comment", authNumber);
					commonService.insert("gloval_SQL.insertVisitLog", map);
				}
				
				// [05] return 메시지
				message = MessageHandler.getMessage(langCode + ".WM00179");
			} catch (Exception e) {
				System.out.println(e.toString());
			}
			
			return message;
		}
	// 수정 end
}
