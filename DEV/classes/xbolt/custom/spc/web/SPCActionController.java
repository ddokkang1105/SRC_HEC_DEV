package xbolt.custom.spc.web;


import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StringReader;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.org.json.JSONArray;
import com.org.json.JSONObject;

import nets.sso.agent.web.v2020.common.util.UUID;
import xbolt.cmm.framework.handler.MessageHandler;
import xbolt.cmm.framework.util.DRMUtil;
import xbolt.cmm.framework.util.DateUtil;
import xbolt.cmm.framework.util.EmailUtil;
import xbolt.cmm.framework.util.ExceptionUtil;
import xbolt.cmm.framework.util.FileUtil;
import xbolt.cmm.framework.util.GetItemAttrList;
import xbolt.cmm.framework.util.JsonUtil;
import xbolt.cmm.framework.util.NumberUtil;
import xbolt.cmm.framework.util.SessionConfig;
import xbolt.cmm.framework.util.StringUtil;
import xbolt.cmm.framework.val.GlobalVal;
import xbolt.custom.hyundai.val.HMGGlobalVal;
import xbolt.custom.hanwha.val.HanwhaGlobalVal;
import xbolt.cmm.controller.XboltController;
import xbolt.cmm.service.CommonService;
import xbolt.project.chgInf.web.CSActionController;

/**
 * @Class Name : HDCActionController.java
 * @Description : HDCActionController.java
 * @Modification Information
 * @수정일		수정자		 수정내용
 * @---------	---------	-------------------------------
 * @2021. 09. 02. smartfactory		최초생성
 *
 * @since 2021. 09. 02
 * @version 1.0
 * @see
 */

@Controller
@SuppressWarnings("unchecked")
public class SPCActionController extends XboltController{
	private final Log _log = LogFactory.getLog(this.getClass());
	
	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value="custom/spc/zSpc_getAllProcessList.do")
	public String zSpc_getAllProcessList(HttpServletRequest request, HashMap commandMap, ModelMap model) throws Exception{
		try {
			Map setMap = new HashMap();
			Map tempMap = new HashMap();
			Map attrTypeMap = new HashMap();
			List attrAllocList = new ArrayList();
			setMap.put("languageID", commandMap.get("languageID"));
			String classcodes [] = {"CL01005", "CL01006"};
			for(int i=0; i < classcodes.length; i++) {
				setMap.put("ItemClassCode", classcodes[i]);
				attrAllocList = (List)commonService.selectList("attr_SQL.getAttrAllocList", setMap);
				for(int k=0; k < attrAllocList.size(); k++) {
					tempMap = (HashMap)attrAllocList.get(k);
					attrTypeMap.put(tempMap.get("AttrTypeCode"), tempMap.get("Name"));
				}
			}
			
			/*
			List AllProcessList = commonService.selectList("custom_SQL.zSpc_getAllProcessList", setMap);
			
			for(int i=0; i<AllProcessList.size(); i++) {
				//tempMap = new HashMap();
				tempMap = (HashMap)AllProcessList.get(i);
				tempMap.put("AT03", removeAllTag(StringUtil.checkNull(tempMap.get("AT03")),"DbToEx"));
				tempMap.put("AT26", getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(tempMap.get("ItemID")), "AT00026"));
				tempMap.put("AT37", getMLovVlaue(StringUtil.checkNull(commandMap.get("sessionDefLanguageId")), StringUtil.checkNull(tempMap.get("ItemID")), "AT00037"));
				AllProcessList.set(i, tempMap);
				
			}
			JSONArray AllProcessListData = new JSONArray(AllProcessList);
			model.put("AllProcessListData", AllProcessListData);
			model.put("totalCnt", AllProcessList.size());
			
			*/
			
			model.put("attrTypeMap", attrTypeMap);
			model.put("menu", getLabel(request, commonService));
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl("/custom/spc/report/zSpc_getAllProcessList");
	}
	
	@RequestMapping(value="custom/spc/zSpc_getAllProcessListGridData.do")
	public void zSpc_getAllProcessListGridData(HttpServletRequest request, HashMap commandMap, HttpServletResponse response) throws Exception{
		try {
			Map setMap = new HashMap();
			setMap.put("languageID", commandMap.get("sessionCurrLangType"));
			List AllProcessList = commonService.selectList("custom_SQL.zSpc_getAllProcessList", setMap);
			JSONArray AllProcessListData = new JSONArray(AllProcessList);
			
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/plain");
			response.setCharacterEncoding("UTF-8");
			
			response.getWriter().print(AllProcessListData);
		
		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
	
	private String removeAllTag(String str,String type) { 
		if(type.equals("DbToEx")){//201610 new line :: DB To Excel
			str = str.replaceAll("\r\n", "&&rn").replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&#40;", "(").replaceAll("&#41;", ")").replace("&sect;","-").replaceAll("<br/>", "&&rn").replaceAll("<br />", "&&rn");
		}else{
			str = str.replaceAll("\n", "&&rn");//201610 new line :: Excel To DB 
		}
		str = str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ").replace("&amp;", "&");
		if(type.equals("DbToEx")){
			str = str.replaceAll("&&rn", "\n");
		}
		//return str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").replace("&#10;", " ").replace("&#xa;", "").replace("&nbsp;", " ");
		return StringEscapeUtils.unescapeHtml4(str);
	}
	private String getMLovVlaue(String languageID, String itemID, String attrTypeCode) throws Exception {
		List mLovList = new ArrayList();
		Map setMap = new HashMap();
		String defaultLang = commonService.selectString("item_SQL.getDefaultLang", setMap);
		setMap.put("languageID", languageID);
		setMap.put("defaultLang", defaultLang);	
		setMap.put("itemID", itemID);
		setMap.put("attrTypeCode", attrTypeCode);
		mLovList = commonService.selectList("attr_SQL.getMLovList",setMap);
		String plainText = "";
		if(mLovList.size() > 0){
			for(int j=0; j<mLovList.size(); j++){
				Map mLovListMap = (HashMap)mLovList.get(j);
				if(j==0){
					plainText = StringUtil.checkNull(mLovListMap.get("Value"));
				}else {
					plainText = plainText + " / " + mLovListMap.get("Value") ;
				}
			}
		}
		return plainText;
	}
	
	@RequestMapping(value = "custom/spc/zSpcMain.do")
	public String zSpcMain(HttpServletRequest request, Map cmmMap, ModelMap model) throws Exception {
		String url = "/custom/spc/main/zSpcMain";

		try {
			model.put("menu", getLabel(request, commonService)); /* Label Setting */
			Map setMap = new HashMap();
			
		} catch (Exception e) {
			System.out.println(e);
			throw new ExceptionUtil(e.toString());
		}
		model.put("screenType", request.getParameter("screenType"));
		return nextUrl(url);
	}
	
	@RequestMapping(value="/custom/spc/logonServiceSpc.do")
	public String logonServiceSpc(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		try{
			String ssoID = StringUtil.checkNull(cmmMap.get("LOGIN_ID"),"");
			String spcSSO = StringUtil.checkNull(cmmMap.get("SpcSSO"),"");

			model.put("olmI", ssoID);
			model.put("olmP", "");
			model.put("ktngSSO", spcSSO);
			
			model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
			model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"),""));
			model.put("status", StringUtil.checkNull(cmmMap.get("status"),""));
			
			System.out.println("logonService.do ssoID :"+ssoID);
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("MainKTngActionController::mainpage::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("/custom/spc/logonServiceSpc");
	}
	
	@RequestMapping(value="/custom/spc/indexSpc.do")
	public String indexSpc(Map cmmMap, ModelMap model, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		try{
			String ssoID = StringUtil.checkNull(cmmMap.get("LOGIN_ID"),"");
			String spcSSO = StringUtil.checkNull(cmmMap.get("SpcSSO"),"");

			model.put("olmI", ssoID);
			model.put("olmP", "");
			model.put("spcSSO", spcSSO);
			
			model.put("olmLng", StringUtil.checkNull(cmmMap.get("olmLng"),""));
			model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType"),""));
			model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType"),""));
			model.put("srID", StringUtil.checkNull(cmmMap.get("srID"),""));
			model.put("proposal", StringUtil.checkNull(cmmMap.get("proposal"),""));
			model.put("status", StringUtil.checkNull(cmmMap.get("status"),""));
			
			//System.out.println("indexSpc.do ssoID :"+ssoID);
		}catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SPCActionController::mainpage::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}		
		return nextUrl("indexSPC");
	}
	
	@RequestMapping(value="/custom/spc/loginSpcForm.do")
	public String loginSpcForm(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
	  model=setLoginScrnInfo(model,cmmMap);
	  model.put("screenType", cmmMap.get("screenType"));
	  model.put("mainType", cmmMap.get("mainType"));
	  model.put("srID", cmmMap.get("srID"));
	  model.put("proposal", cmmMap.get("proposal"));
	  model.put("status", cmmMap.get("status"));
	  model.put("spcSSO", cmmMap.get("spcSSO"));
	  model.put("keepLoginYN", StringUtil.checkNull(cmmMap.get("keepLoginYN"),""));
	  
	  
	  //2025-03-25 CSRF 보안 조치
	  //**************************************************************
	  String csrfToken = UUID.randomUUID().toString();
	  HttpSession session = request.getSession();
	  session.setAttribute("csrfToken", csrfToken);
	  model.put("csrfToken", csrfToken);
	  //**************************************************************  
	  
	  return nextUrl("/custom/spc/login");
	}
	
	private ModelMap setLoginScrnInfo(ModelMap model, HashMap cmmMap) throws Exception {
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
	
	@RequestMapping(value="/custom/spc/loginSpc.do")
	public String loginSpc(ModelMap model, HashMap cmmMap, HttpServletRequest request) throws Exception {
		try {
			
			
			  //2025-03-25 CSRF 보안 조치
			  //**************************************************************
			  HttpSession csrfSession = request.getSession();
			  String csrfToken = StringUtil.checkNull(cmmMap.get("csrfToken"));
			  String sessionCsrfToken = StringUtil.checkNull(csrfSession.getAttribute("csrfToken"));
			  if (csrfToken == null || !csrfToken.equals(sessionCsrfToken)) {
				 throw new Exception("Invalid CSRF token");
			  }
			  //**************************************************************
			
			  	
				Map resultMap = new HashMap();
				String langCode = GlobalVal.DEFAULT_LANG_CODE;	
				String languageID = StringUtil.checkNull(cmmMap.get("LANGUAGE"),StringUtil.checkNull(cmmMap.get("LANGUAGEID")) );
				String spcSSO = StringUtil.checkNull(cmmMap.get("spcSSO"));
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
					resultMap.put(AJAX_ALERT, "Your ID does not exist in our system. Please contact system administrator.");
				}
				else {

					Map idInfo = new HashMap();
					
					if("Y".equals(IS_CHECK)) {
						cmmMap.put("IS_CHECK", "Y");
					}
					else {
						cmmMap.put("IS_CHECK", "N");
					}
					
					if(!spcSSO.equals("T")) {
						String pwd = (String) cmmMap.get("PASSWORD");
						pwd = (String) cmmMap.get("LOGIN_ID") + pwd;						
						// pwd = sha256(pwd);
						cmmMap.put("PASSWORD", pwd); 
						cmmMap.put("IS_CHECK", "N");
					}
					else {

						cmmMap.put("IS_CHECK", "N");
					}
					
					request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
					String ip = request.getHeader("X-FORWARDED-FOR");
			        if (ip == null) ip = request.getRemoteAddr();
					
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
							
							////// 중복 로그인 설정 ///////////////////////////////////////////////////////////////////////////////////////////////
							String session_duplicate = StringUtil.checkNull(GlobalVal.SESSION_DUPLICATE);	
							String returnValue = "";
							String currSessionID = "";
							
							Map<String, Object> currSessionInfo = new HashMap<>();
							String sessionBrowser = "";
							String sessionIp = "";
							
							String browser 	 = "";
							String userAgent = StringUtil.checkNull(request.getHeader("User-Agent"));		
							
							/*
							if(session_duplicate.equals("N")) { // session duplicate check								
								String keepLoginYN = StringUtil.checkNull(request.getParameter("keepLoginYN"));
								if(keepLoginYN.equals("Y")) {
									returnValue = SessionConfig.getSessionCheck("login_id", StringUtil.checkNull(idInfo.get("LoginId")),"N","");
								}else {
									currSessionInfo = SessionConfig.getSessionInfo("login_id", StringUtil.checkNull(idInfo.get("LoginId")),"Y");	
									currSessionID =  StringUtil.checkNull(currSessionInfo.get("sessionId"));
									sessionBrowser = StringUtil.checkNull(currSessionInfo.get("sessionBrowser"));
									sessionIp = StringUtil.checkNull(currSessionInfo.get("sessionIpAddress"));
								}
								
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
								
							}
							
							HttpSession session = request.getSession(true);
							if((!currSessionID.equals("") && !sessionBrowser.equals(browser)) || (!currSessionID.equals("") && !sessionIp.equals(ip)) ) {
								String loginID = StringUtil.checkNull(loginInfo.get("LOGIN_ID")); 
								String password = StringUtil.checkNull(request.getParameter("PASSWORD")); 
								String loginIdx = StringUtil.checkNull(request.getParameter("loginIdx"));
								resultMap.put(AJAX_SCRIPT, "parent.fnConfirmDuplicateLogin('"+loginID+"','"+password+"','"+languageID+"','"+loginIdx+"')");
							} else {
								Map setData = new HashMap();						
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
							
							*/
						
							if(session_duplicate.equals("N")) { // session duplicate check								
								String keepLoginYN = StringUtil.checkNull(request.getParameter("keepLoginYN"));
								currSessionInfo = SessionConfig.getSessionInfo("login_id", StringUtil.checkNull(idInfo.get("LoginId")),"Y");	// 선입자 session 취득
								currSessionID =  StringUtil.checkNull(currSessionInfo.get("sessionId"));
								sessionBrowser = StringUtil.checkNull(currSessionInfo.get("sessionBrowser"));
								sessionIp = StringUtil.checkNull(currSessionInfo.get("sessionIpAddress"));
								
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
							}
							
							if((!currSessionID.equals("") && !sessionBrowser.equals(browser)) || (!currSessionID.equals("") && !sessionIp.equals(ip)) ) { // 기존 세션 삭제 
								
								returnValue = SessionConfig.getSessionCheck("login_id", "","ALL", currSessionID);	// 기존 세션 전부삭제 
							} 
							
							HttpSession session = request.getSession(true);
														
							Map setData = new HashMap();						
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
					model.put("loginIdx", StringUtil.checkNull(cmmMap.get("loginIdx"))); //singleSignOn 구분
					model.put("screenType", StringUtil.checkNull(cmmMap.get("screenType")));
					model.put("mainType", StringUtil.checkNull(cmmMap.get("mainType")));
					model.put("srID", StringUtil.checkNull(cmmMap.get("srID")));
					model.put("sysCode", StringUtil.checkNull(cmmMap.get("sysCode")));
					model.addAttribute(AJAX_RESULTMAP,resultMap);
				}
		}
		catch (Exception e) {
			if(_log.isInfoEnabled()){_log.info("SPCActionController::loginbase::Error::"+e);}
			throw new ExceptionUtil(e.toString());
		}
		return nextUrl(AJAXPAGE);
	}

}


